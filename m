Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBD03ECE06
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 07:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbhHPFZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 01:25:13 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:53697 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhHPFZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 01:25:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 296FF2B011AB;
        Mon, 16 Aug 2021 01:24:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 16 Aug 2021 01:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=5mOWqSNBK3/mb0NfaVtTdfrOLyN
        devV1TJzFPzAHTbQ=; b=hmgPPKaSdi3pNxgas6DnbAVkLJJvpqnCJU7lEN38aaQ
        0brbWWyv+Ne4mHJbBaKnk96NAjlhiDJU6K04M+QRjmuZiSS2e6/P1Z+ZpVKHuOeR
        AOEX96lXY23DbIZbD8QZVsbAJ8P/1tknZz9DwXVYXMIzFLOVw0yOgG30BUOz0aFi
        FcL2VrhMr4sMT9znD5/VENzuzx+aFLgGgueYkmntDrv1zJ2+Zf0Cza088+d9Ao9C
        XD/b6H2U2wimKlFk4RsTK7w6YlSSJCWpAMFPk3Jl25JYeicc7jov1DXGgIcLp3G8
        txvSPjS4qq5E95TL4nKHQAxs7AifK6yrSSkB8PiStuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5mOWqS
        NBK3/mb0NfaVtTdfrOLyNdevV1TJzFPzAHTbQ=; b=ptRZZ0F17jF8VTSfU41TLd
        kQ0INvdSdDXhKhfTQYxHinCuRYg75EdvC1w5naPGvWY5guNMR0HP36I6RSSIlDEk
        DMZrGLUBcOoIBY6vxeQ63aNH4l6zLro/EhGLVqoC8Xl90rU1kvwGNaWzxvsGzRMt
        sU67XgKpynuvqeNQz0U7jMuPgVC44nkhHDplEqSlXbD/90ozdUOzu4o41ovS/stz
        6ZIWU9qRq4OEXv/6NCWQmhLlE2BawDBPnBm2fLcLqUs/VIjcBnT2OO2e1E62N8ak
        2+LERlfRry1/9ij4RGjvC28DMfzl76u7jxQt0grW0jo3vFqje9m8UyLQeccoXM7Q
        ==
X-ME-Sender: <xms:lvYZYdyKZigrR77b8pLjP-CM3YU9z4UTANZyOgQ4ligNNG0KOuRCzw>
    <xme:lvYZYdTjMGe1SfbzPzcNeZznh0_x1Trn2CT3In-arD5-XCPdpJ5J13q1ry--rYigH
    chHXZgFs1R4kg>
X-ME-Received: <xmr:lvYZYXXRUbP0ngPTRjcDG2UapM8SVO0RVWkvlmH3oC8o7L4vddmAq9ujmStVV9rOmoMQzrCqEN-HurJYAIXE2Y3S27SCMAYm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrledtgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:lvYZYfi4xK6YnSGTCt8rkj0CONWxP4dPsrxrH28ti-9ig3b2HziQEQ>
    <xmx:lvYZYfBV1fgbxsBm7ZTR3sYZHb0-KxE6_WAzz_65tGCc8793ULoe1w>
    <xmx:lvYZYYLTMXgEtaJ0FaRq5s2Zs6-F9d8YEX8LmsXT9R-Q31Y7absqkA>
    <xmx:mPYZYT5E_VnCSfF0ZydVxlHoceSBALzcrCzEdeQQOash64Ko7PkWdykkHSM>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Aug 2021 01:24:37 -0400 (EDT)
Date:   Mon, 16 Aug 2021 07:24:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <YRn2kUHl2hVFPggS@kroah.com>
References: <20210816135216.46e50364@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816135216.46e50364@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 01:52:16PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/r8188eu/core/rtw_br_ext.c:8:10: fatal error: ../include/net/ipx.h: No such file or directory
>     8 | #include "../include/net/ipx.h"
>       |          ^~~~~~~~~~~~~~~~~~~~~~
> 
> Caused by commit
> 
>   6c9b40844751 ("net: Remove net/ipx.h and uapi/linux/ipx.h header files")
> 
> from the net-next tree.
> 
> I have reverted that commit for today.
> 

That's not fair to the networking developers, I'll work on a patch for
this driver to remove that later today...

thanks,

greg k-h
