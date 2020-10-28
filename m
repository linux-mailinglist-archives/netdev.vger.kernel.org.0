Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8BE29DEA8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbgJ2Azy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731653AbgJ1WRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0531822249;
        Wed, 28 Oct 2020 05:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603862940;
        bh=j9PkiQ7S1inYkjVg1VlbFXYGya4JPZOEejPm0DCw75c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KKnF7PIFtiOmh/Du1pR4PL9WEBX9ONCmXSKMZg2cQ0MMW5IPBn73oeTnd2N2au7hi
         6TIwPyp/z8M5Pt8R1r9alQwBwLiIzcDYxQ3vtbJNqdPFEuCbIrhHTDV5ENcqtPYOXb
         +Uc7jPRh5nvf82242EeQ8oIl4/uZ6IgriALUCn6w=
Date:   Wed, 28 Oct 2020 07:28:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net v1] net: protect tcf_block_unbind with block lock
Message-ID: <20201028052856.GF1763578@unreal>
References: <20201026123327.1141066-1-leon@kernel.org>
 <20201027180331.42ece60f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027180331.42ece60f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 06:03:31PM -0700, Jakub Kicinski wrote:
> On Mon, 26 Oct 2020 14:33:27 +0200 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > The tcf_block_unbind() expects that the caller will take block->cb_lock
> > before calling it, however the code took RTNL lock and dropped cb_lock
> > instead. This causes to the following kernel panic.
>
> > Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > v1:
> >  * Returned rtnl_lock()
> > v0:
> > https://lore.kernel.org/netdev/20201026060407.583080-1-leon@kernel.org
>
> Applied, thanks.
>
> I'm surprised you put the lore link in the notes. Maybe the usefulness
> of the change log could be argued, but the number of times I tried to
> find a specific revision and couldn't...

This is my preferred way of submitting patches, it allows to enjoy from
all worlds: clean commit message and ability to see previous versions
at the same time.

Lorifier [1] gives such links to me in automatic way, all that I need
is to copy them from previous versions.

[1] https://github.com/danrue/lorifier

Thanks
