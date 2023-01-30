Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB96815D4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbjA3QAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbjA3QAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:00:41 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831D199C6;
        Mon, 30 Jan 2023 08:00:39 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id D05445C0052;
        Mon, 30 Jan 2023 11:00:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 30 Jan 2023 11:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675094438; x=1675180838; bh=0EW3uWXnO7
        g4p/xwansv2fJ2bLuCH0UQwzuldiNnwpg=; b=AzySeLg/+x8vFzDHxidj02rdWP
        ebIkvXtBBDRVd7lcu3psSa1Onmq8gc2i3ryz+0pxl8ylbz3HJY6q/Wvrrs8gZHER
        zyHMxm75ASfmN60DCBnW787mg80ochBcUH2RtlEtQMK1dqBph8ZOaF1gQYAhbKWG
        kqgKfPb5hqreW79QbnEl7mZjI+X4FRG//HkLqXWjQnpaeqaKkWR+E3/c/mW6mDSz
        SusxQzxKRhUM0Uj2K0NTuAyyWiR0zoDuM4NxC87fA/V22Z2K6hpRloYdYnj2lM9s
        vOI83GllbCgiSdC1MMBNbsgoW7lf8MGIgFVJCxa/y5vB27Tu6dhfwnCHtChw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675094438; x=1675180838; bh=0EW3uWXnO7g4p/xwansv2fJ2bLuC
        H0UQwzuldiNnwpg=; b=mMNhVq8gou7yjhuo0V9GxJ8F0ABMkXSp0Oo33Pbhc0Y0
        e/wDj6g+vo7po/hBs0U77s6d/kPQ9u3gjLjbkuavOHcWFk3UQ2gIgada1/bTzutO
        xoQ6n3J5uIaQg/pvVJTzTtq3EhHXifDu8muqRWLD2KI1zJR8NnMi/rcCxDjTaiqd
        o4fQG6TuJ7m5nLCUJv9JTfJ+h6xtnFkKRRQ/I7Kl+KKhGAhd9Gt+HNd6BELOFbAH
        ZIJAuvbEkxAlFzyJKOzyGUH4vyQruUCruTssIKYfoa+Z8fc5M3zk+tSmRkhHdYGa
        QO78AUI3nM87+ZkNdY7t8WcEsjEi3f2ZfYuO+qGmdQ==
X-ME-Sender: <xms:punXY2zUbH4RYf55jILEQ7gRL0-witwGBqvgAAxPPpEilQRFmpjLow>
    <xme:punXYySWtV4z813yYvX6tLsbqVK1udXUfp0B8YXNYqEn8VDmobZiBqKN0oah8dtUU
    jd_-0a14FrzFw>
X-ME-Received: <xmr:punXY4WdxRA6psg950rZcZ8GdTwMw5nwuCW2diXFPjipSFpZlytKJX-JfXh4tFrpAi-b2dQW47BICdmW55axtrQgSgSd3au45zwE1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefvddgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:punXY8j7KIGshaSphlbsONe0rPFqwByokJzJlu4SEz6qkPLG2O2eIQ>
    <xmx:punXY4CoTJm9OZPBgNED6b42ATfORM6_QhWlVdIksnI6PNIqvAY6VQ>
    <xmx:punXY9Ja7ftmJcB0hzmSjVrjobTVtx5T0g52ancbuXbq13Lx8YQ5EQ>
    <xmx:punXY85aLnDI5NdSH1stDX-Cm79x_jlCYZddIeq2EWQFEMU01I_FtQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Jan 2023 11:00:37 -0500 (EST)
Date:   Mon, 30 Jan 2023 17:00:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 net-next tree
Message-ID: <Y9fpog52SpcWowAD@kroah.com>
References: <20230130153229.6cb70418@canb.auug.org.au>
 <Y9e4lFKZMylweoQF@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9e4lFKZMylweoQF@smile.fi.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 02:31:16PM +0200, Andy Shevchenko wrote:
> On Mon, Jan 30, 2023 at 03:32:29PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the driver-core tree got a conflict in:
> > 
> >   include/linux/acpi.h
> > 
> > between commit:
> > 
> >   1b94ad7ccc21 ("ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_dsm() stubs")
> > 
> > from the net-next tree and commit:
> > 
> >   162736b0d71a ("driver core: make struct device_type.uevent() take a const *")
> > 
> > from the driver-core tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> 
> Seems correct, thank you!

Looks good to me too, thanks!

greg k-h
