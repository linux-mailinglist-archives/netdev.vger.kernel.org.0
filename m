Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B081B2748
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgDUNOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:14:36 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33463 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbgDUNOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:14:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A0A285C018D;
        Tue, 21 Apr 2020 09:14:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 09:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=zycOR+6bwJZ4JHSqR6NX+uiN3Tw
        /gGPTY7r2R6DKCBw=; b=cKWjnJNrRwmj77Rinqy5MmebASJv6OyeEPlnrRQl+p3
        G9JvXjDqrzf1tZ/3O4Ic2p4JpeE9+Cwr1ZWdzRZJBITdh9Ui9l/OY4u7q+Dm3U89
        nBBJMAFU0vRVbSTrzRbR9rqbeyl5pn3/B9wv0NdEvL9BDZB3o8Dy5ErjGjI3jJXa
        n1RKTgh64lWaMDLuWYizBr3ShEsctDePpkj+KHt+WnNs0xo7ecg+kHiNcgbADhDf
        W7m+01HpvXrJYmSFYeVRnWbjPyq7lea6naMsl7vjqA4cfx2PTb5nc2tZuTkz17xn
        xT4+Ct2l79UvVyuElyRsgTgvOu34ZYeewRSYM9KbUwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zycOR+
        6bwJZ4JHSqR6NX+uiN3Tw/gGPTY7r2R6DKCBw=; b=4P15AjXzP6+3Vg8BvUAboo
        dRYlSfXBPfdaBwPEY+QKBhLBlsMYOAOc50Q402RqxhEmrrnolZRSJaIzUzMjpU3o
        4Kh2dAinou8YVMqmAreOLJufb2V/f/+mPkg6CZh055FywUikeWh1F7OwAkYetPp5
        DcMV15QxW+cQLe9YxbQ10W9VUiRWCl7UCrpI0oT8XxEdV9S0ZJMZQqclzwd6+PzM
        vWlQf3MJNE21ldXZUdC/p1D0bkzUyq4sjtcMaS0I4LhjbOqRreGYGkJVHTWzevzn
        svoJLAC5R2EzL5/d9ULy1OVpRTvu2oA8AYmSxKg6sdIoy4tyqcZ6JmLoIOQlGBZQ
        ==
X-ME-Sender: <xms:ufGeXsNgwLibxkBMiItC1pgLrc_HMaGVsmZAWJp-HfizbnH2Ji3aUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ufGeXjvDcsn9MyfggEELC2s8TcZ8GbTJ8-ftSQws3A1wS5B0RXyDwQ>
    <xmx:ufGeXnFhnZmsVAWRq2CAPj830ZPNIhgIQkShXsWZ7mI_OviAAGYJOg>
    <xmx:ufGeXmSx0_me1dYA5FsUcEwYunKSVW89YauQ9r3EE1nZRgwBL-Bqog>
    <xmx:uvGeXn6bNMRg48tAFBjfXpxN8ksNoyy72wvR8kiQNyBqa0n185eddQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16FA73065C82;
        Tue, 21 Apr 2020 09:14:32 -0400 (EDT)
Date:   Tue, 21 Apr 2020 15:14:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set
 back-ends to report partial overlaps on insertion
Message-ID: <20200421131431.GA793882@kroah.com>
References: <20200407000058.16423-1-sashal@kernel.org>
 <20200407000058.16423-27-sashal@kernel.org>
 <20200407021848.626df832@redhat.com>
 <20200413163900.GO27528@sasha-vm>
 <20200413223858.17b0f487@redhat.com>
 <20200414150840.GD1068@sasha-vm>
 <20200421113221.rvh3jkjet32m6ng4@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421113221.rvh3jkjet32m6ng4@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:32:21PM +0200, Pablo Neira Ayuso wrote:
> Hi Sasha,
> 
> On Tue, Apr 14, 2020 at 11:08:40AM -0400, Sasha Levin wrote:
> > On Mon, Apr 13, 2020 at 10:38:58PM +0200, Stefano Brivio wrote:
> > > On Mon, 13 Apr 2020 12:39:00 -0400
> > > Sasha Levin <sashal@kernel.org> wrote:
> > > 
> > > > On Tue, Apr 07, 2020 at 02:18:48AM +0200, Stefano Brivio wrote:
> > > > 
> > > > >I'm used to not Cc: stable on networking patches (Dave's net.git),
> > > > >but I guess I should instead if they go through nf.git (Pablo's tree),
> > > > >right?
> > > > 
> > > > Yup, this confusion has caused for quite a few netfilter fixes to not
> > > > land in -stable. If it goes through Pablo's tree (and unless he intructs
> > > > otherwise), you should Cc stable.
> > > 
> > > Hah, thanks for clarifying.
> > > 
> > > What do you think I should do specifically with 72239f2795fa
> > > ("netfilter: nft_set_rbtree: Drop spurious condition for overlap detection
> > > on insertion")?
> > > 
> > > I haven't Cc'ed stable on that one. Can I expect AUTOSEL to pick it up
> > > anyway?
> > 
> > I'll make sure it gets queued up when it hits Linus's tree :)
> 
> 5.6.6 is out and this fix is still not included...
> 
> Would you please enqueue...
> 
> commit 72239f2795fab9a58633bd0399698ff7581534a3
> Author: Stefano Brivio <sbrivio@redhat.com>
> Date:   Wed Apr 1 17:14:38 2020 +0200
> 
>     netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion
> 
> for 5.6.x -stable ?

Now queued up, thanks.

greg k-h
