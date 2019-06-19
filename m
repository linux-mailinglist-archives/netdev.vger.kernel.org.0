Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB24B08C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 06:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfFSEDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 00:03:05 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:53560 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFSEDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 00:03:05 -0400
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x5J42qB4032589;
        Wed, 19 Jun 2019 13:02:53 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x5J42qB4032589
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1560916973;
        bh=tkjX5PNPrJPasCTxYHgyfQnyjLXksXDnK7VVj0pwtio=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=njLHgxeAGTZ5u0FEsPFhFCMOXl8f5pQ/EGbVZSeENKMHAWMQsfwCoTCWU/U7Ov5KU
         SFK3e3xhe+ovZc9jbwXYo7GvanaDCaRumyuRmyWf/X+6EIhpNvjC4FsXfsf4LXmiiO
         w9yv77nIuqOKlgPDlGhI4ePlpqpoZJpgbQ9X7kYCGemTTE5ZVCmVwX/j0FeEOU+Jyk
         HtCvJRWgPAiyf/ygzvbVNi56ywoBFvCBOxUDJhMzFhsHhr/+M4lYGwi5mWJQ/3UizI
         YxExw6VY/RMuDD9UNdLh9hbBSF+oDW+LwkjgVyCrBXf5xZfFUOGj3fBg3pqrChVB0g
         RqOJhZ6u5X+Lg==
X-Nifty-SrcIP: [209.85.222.54]
Received: by mail-ua1-f54.google.com with SMTP id v20so3021031uao.3;
        Tue, 18 Jun 2019 21:02:52 -0700 (PDT)
X-Gm-Message-State: APjAAAXUfrKw3y3ZmopRuYu8DK2ocC8zDi+UmQZwwdArs7riTy/SoRmJ
        Rc9I+ewo2XiTU0wcu2OcH9KHlFDmdwlxhmQCmsM=
X-Google-Smtp-Source: APXvYqyrqOA+mb7BvfFmB/sS1UkmNbUU4f3Y32P40E16rHImNQaL4GpzCijTQmg4Wje+hkLazBbiBWljAqa5DIzeWLA=
X-Received: by 2002:a67:cd1a:: with SMTP id u26mr26623437vsl.155.1560916971750;
 Tue, 18 Jun 2019 21:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190619132326.1846345b@canb.auug.org.au>
In-Reply-To: <20190619132326.1846345b@canb.auug.org.au>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 19 Jun 2019 13:02:15 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQCe0APJ3ggJYRDf_DjYg=dH9+2nNsYoygiFKhTa=givg@mail.gmail.com>
Message-ID: <CAK7LNAQCe0APJ3ggJYRDf_DjYg=dH9+2nNsYoygiFKhTa=givg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.


On Wed, Jun 19, 2019 at 12:23 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> In file included from usr/include/linux/tc_act/tc_ctinfo.hdrtest.c:1:
> ./usr/include/linux/tc_act/tc_ctinfo.h:30:21: error: implicit declaration of function 'BIT' [-Werror=implicit-function-declaration]
>   CTINFO_MODE_DSCP = BIT(0),
>                      ^~~
> ./usr/include/linux/tc_act/tc_ctinfo.h:30:2: error: enumerator value for 'CTINFO_MODE_DSCP' is not an integer constant
>   CTINFO_MODE_DSCP = BIT(0),
>   ^~~~~~~~~~~~~~~~
> ./usr/include/linux/tc_act/tc_ctinfo.h:32:1: error: enumerator value for 'CTINFO_MODE_CPMARK' is not an integer constant
>  };
>  ^
>
> Caused by commit
>
>   24ec483cec98 ("net: sched: Introduce act_ctinfo action")
>
> Presumably exposed by commit
>
>   b91976b7c0e3 ("kbuild: compile-test UAPI headers to ensure they are self-contained")
>
> from the kbuild tree.


My commit correctly blocked the broken UAPI header, Hooray!

People export more and more headers that
are never able to compile in user-space.

We must block new breakages from coming in.


BIT() is not exported to user-space
since it is not prefixed with underscore.


You can use _BITUL() in user-space,
which is available in include/uapi/linux/const.h


Thanks.




> I have applied the following (obvious) patch for today.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 19 Jun 2019 13:15:22 +1000
> Subject: [PATCH] net: sched: don't use BIT() in uapi headers
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/uapi/linux/tc_act/tc_ctinfo.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_act/tc_ctinfo.h
> index da803e05a89b..6166c62dd7dd 100644
> --- a/include/uapi/linux/tc_act/tc_ctinfo.h
> +++ b/include/uapi/linux/tc_act/tc_ctinfo.h
> @@ -27,8 +27,8 @@ enum {
>  #define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
>
>  enum {
> -       CTINFO_MODE_DSCP        = BIT(0),
> -       CTINFO_MODE_CPMARK      = BIT(1)
> +       CTINFO_MODE_DSCP        = (1UL << 0),
> +       CTINFO_MODE_CPMARK      = (1UL << 1)
>  };
>
>  #endif
> --
> 2.20.1
>
> --
> Cheers,
> Stephen Rothwell



-- 
Best Regards
Masahiro Yamada
