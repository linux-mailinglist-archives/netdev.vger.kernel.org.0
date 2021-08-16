Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857733ED98C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhHPPK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:10:56 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:48975 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229550AbhHPPK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:10:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 6D5442B01288;
        Mon, 16 Aug 2021 11:10:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Aug 2021 11:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=QH2i+g2wWgrw++ix3rV29qp4xkP
        WlAQZm+p6piVCMLw=; b=aZggHCp1Ba1yTlAbk2MLyQt2LOVHDW/W762RUAm1Z91
        XNZYfy5gIGd7y4/h05aPeYWDtxodJweZZ36F7+XhUnz6gUX53xJHwCnWnsAvVXrl
        ZTtFIg/M6ytXweTpVKYifpFZeZX7A4704NwmqzykAfMde4444963Ln7qd8/YdmNc
        QeOmgYv4fD3BtDZJyU6g00T/5LknXQTomwWQBbrHJdr2hHLEIEgofnQxi0erlZ2C
        g/tvoMKe0yyTIFUqti/UUgv5/EpDuLWFfsFUnEMtvA/8BZ4iASVDTHyBllWm+sCl
        Ybk6vG9poLXcyTN+J2fbks+OJhn3FVUsA7GgTochuOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QH2i+g
        2wWgrw++ix3rV29qp4xkPWlAQZm+p6piVCMLw=; b=mMjw/li99GEDCJn70/rZTS
        MlFQonrrEJhVDbYSsQdfVxQtAybMDof/LL16u7NqwhEooGk2J/9UWO8ZpFXAwmKc
        39xscZ34g2xlTIQDiaFp32iDrPl7jmb1Disf71uyxcoGBmTi2i6S92lmilW2DLzj
        aNUN61ZO0HNVydbtnBcaLTYLV9aWK3Wec9qwGmbp9V+pU6TBoqK28Kl65gFFzkAh
        VWHyid7norHBXUHmecvqG40VoqTYfv7uMwBaNkHqKzcglXwOz04GzuhcRoaURGw3
        /HorNw5NKMuocRvCVzUfJ+Omu7KGHJgXMty45Zrr7dJe746Mc27kPY6+1SpnN53A
        ==
X-ME-Sender: <xms:3X8aYfZqeYGAdTfgBZASi_CeVDHwvhGsJfDFiOXUMQhvLt-QWaph0g>
    <xme:3X8aYeaqiW20J_uRghfFhCqxyJ8k3BVhxaYILGMYJYiE2wnN7ENvovotZJGCGIS6-
    xdxghHUUzsRuQ>
X-ME-Received: <xmr:3X8aYR_AkEoRzg2DdlNd7R_4fVRPLhO8NL9565M7o_-BmPx_ktuvj5PiEh3zXLiWydhbqxnHi1Mv8zL3n3hKgVnbPoNnXimX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrledugdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3X8aYVoTtQ-N4karYvkwnh90C37BKjyoxo5F_Q0DgBlwJyPAz41rQQ>
    <xmx:3X8aYardt367KHXLDLhd3JwlMK2123GN8ElI9sYevmw4W6F7YSjRdA>
    <xmx:3X8aYbS5DmsZlluMn9CdXS8mfmY5vPR4DFxE4UHdcjaq5Mhd2FXDzw>
    <xmx:338aYXgu2V2mAass_oG3wgHQUi1ZEQBZx7q4ToVGHS1BEj1di8KmLZeN84U>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Aug 2021 11:10:20 -0400 (EDT)
Date:   Mon, 16 Aug 2021 17:10:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <YRp/2kRzujLsV8sm@kroah.com>
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

Should now be fixed up in my tree so that you do not need to drop that
networking patch anymore.

thanks,

greg k-h
