Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219932EEC58
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 05:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbhAHETS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 23:19:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbhAHETS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 23:19:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DCEE207B8;
        Fri,  8 Jan 2021 04:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610079517;
        bh=TRAa3O0EFrFbaenlE71fuH1tfT499fm7Tuamq3oD0/E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e/C/RrVv+NGNDGjsnLGjIEc94mZp4yF83mWBmK5Cf3DaWjujhHMUrX5o4BCD9ktP7
         vRsVqkjDgOVwZac0V0nxSmNap0Pk/mqnoAweQJoZ34fCjAFCqkk9PBAswqcO2bXOYJ
         IZ/eDVt64RXEfXYVlRdvb/XX6sxclfdpOxxFC4kpuX0xUiGUhdRD42YWIkQvpNVsTP
         hlHgVvajtlnLhJeLogQ30bmLUss6WBL2qrvAjEAr69MYblWhnOAW61eL0fC9MzB6id
         N4vSAxCC1sUjM+fOcsD13gkQQDfwY3gv2iwEF3lJGbDq4d1uwSrMld1TJ9TjKQD2P4
         v1PwRjPD9U46w==
Message-ID: <59a7dcba82adfabb16cd49e89dafa02aa37b6fd4.camel@kernel.org>
Subject: Re: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow
 accounting is enabled
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Date:   Thu, 07 Jan 2021 20:18:36 -0800
In-Reply-To: <c3291eb2e888ac0f86ce163931d4680fb56b11a8.camel@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
         <20210107202845.470205-5-saeed@kernel.org>
         <20210107190707.6279d0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <c3291eb2e888ac0f86ce163931d4680fb56b11a8.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-07 at 20:06 -0800, Saeed Mahameed wrote:
> On Thu, 2021-01-07 at 19:07 -0800, Jakub Kicinski wrote:
> > On Thu,  7 Jan 2021 12:28:38 -0800 Saeed Mahameed wrote:
> > > +	int ret;
> > > +
> > > +	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
> > > +	if (!counter)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	counter->is_shared = false;
> > > +	counter->counter = mlx5_fc_create(ct_priv->dev, true);
> > > +	if (IS_ERR(counter->counter)) {
> > > +		ct_dbg("Failed to create counter for ct entry");
> > > +		ret = PTR_ERR(counter->counter);
> > > +		kfree(counter);
> > > +		return ERR_PTR(ret);
> > 
> > The err ptr -> ret -> err ptr conversion seems entirely pointless,
> > no?
> Indeed, will address this in a net-next patch
> 

Actually no, because counter is being kfreed so we must return
ERR_PTR(ret).


