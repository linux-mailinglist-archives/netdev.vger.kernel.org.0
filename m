Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC562EEC1E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 05:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbhAHEHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 23:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbhAHEHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 23:07:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E944323601;
        Fri,  8 Jan 2021 04:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610078784;
        bh=v5QTfGeoRRbfY0WgS5RARRN1AzBhtGOSPvv+DFwxbtA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SOPSw2xaTHQ9wa3hImtElyQsw1LrGI45al4lNk11IWQePxRn4/B2wxPzwE1fL3q9/
         WJe5nEXq9cQ/SYiSc3Tc3gI+bh5biudjR+c28eczRoMYlNuxutGgxMKtmdwBlOKAK7
         youMSMs2Tk7So+623pbabRpAxAMNlgjhCeuaqU6U+E12J2iePx9+gR48ut1D/FfIfF
         HmdboUXEp05m/PZG4o/8A48u3CskmCoVhi9Qd5eANPbPdCHgVntiNz7y3I8yurtBKY
         gynsDW9v7eAfKJQJZgNu+1OJj0PmEX1dyuUj9lc799GlkA03pEHL+Fzgrxz/phISyM
         5mz3zmTE1nGDA==
Message-ID: <c3291eb2e888ac0f86ce163931d4680fb56b11a8.camel@kernel.org>
Subject: Re: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow
 accounting is enabled
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Date:   Thu, 07 Jan 2021 20:06:23 -0800
In-Reply-To: <20210107190707.6279d0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210107202845.470205-1-saeed@kernel.org>
         <20210107202845.470205-5-saeed@kernel.org>
         <20210107190707.6279d0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-07 at 19:07 -0800, Jakub Kicinski wrote:
> On Thu,  7 Jan 2021 12:28:38 -0800 Saeed Mahameed wrote:
> > +	int ret;
> > +
> > +	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
> > +	if (!counter)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	counter->is_shared = false;
> > +	counter->counter = mlx5_fc_create(ct_priv->dev, true);
> > +	if (IS_ERR(counter->counter)) {
> > +		ct_dbg("Failed to create counter for ct entry");
> > +		ret = PTR_ERR(counter->counter);
> > +		kfree(counter);
> > +		return ERR_PTR(ret);
> 
> The err ptr -> ret -> err ptr conversion seems entirely pointless,
> no?
Indeed, will address this in a net-next patch

