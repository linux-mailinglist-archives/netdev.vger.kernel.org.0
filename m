Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2114C2CFB3D
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 13:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgLEMK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 07:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbgLELVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 06:21:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277F9C061A52;
        Sat,  5 Dec 2020 03:20:22 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id d18so8563472edt.7;
        Sat, 05 Dec 2020 03:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pFubxfr8TFbxQDJSOpWOytb7HLBaRWXRUz4oP+BoVPY=;
        b=AZURVcC6OJupQc+TX0wKSi9ndyA8sSCeiaKQjWp7MuLbjQ06CR27ZzrX60fG4wW0E9
         neLjKkEmfALRY/L2LxUBvdX62A8AOUdzozr2nsK9ySd1EawIE92TzJhPjfjLDIMKFFtz
         PjmY+YNS3mx7YqxE2AGFpukWbX0D6EJrYUJEIWBpc0HJMhZmYoR/Al/Ly9yTKTA5mBnI
         iWqJ5q1x0UuJ2pFKOr2bjtRbbD7cMg1KzNJrPFHDKET4MDqMlYmFp2QB4U5jBjVg9TPo
         F3JEipPVBV/+4bsC0lMxUpSLc7R9dRh4GcwPuN89YDtgnhINqzlk8l0SutVBsBXPL12Q
         OxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pFubxfr8TFbxQDJSOpWOytb7HLBaRWXRUz4oP+BoVPY=;
        b=aqyxNNQckoWQEWwdTuxycTxmOHJjv1CUuPS2lkvFpSngyeFf70KM5kBWGew0hTK6Pl
         ZBQ2g8QZeEDA7UuEB7NgSC2NtdqYLWD73fKh/++FV6mrXNIAVT7XtAw7On4IoUSH5lG2
         JCz9hck5lrgjatbX+H5dxt4wXMDd+HwEyR2bXEiC3Ac6YtyNxviYK8LcXP+5XHM+I8T/
         m4C45f4z4X2jskSoP7gk2MUgWwvIYbGrPXNQ2ojZUEJqt7aNq9Ps2Ilsz5iTOOCjvmrH
         t/26bwHNlt7eq3wryNz3wJg81dUhSPLat2QhG+xt3uLeiH2xKNq2iTaWcIEnG1zcKvQl
         Cb0g==
X-Gm-Message-State: AOAM531b1ygF6l4Fr37AKCqe07mkO+lJjUh68xZS/gRK507l/A6VSOAY
        ff6gZxu5JyKcWND8J1Ycz2A=
X-Google-Smtp-Source: ABdhPJw+unuRTFJO1NOL8frkI1yVuOJQmy3spxq/6bJQmnA9TDY3fDq8+xWvo35iYTRJvdJlNzjeKQ==
X-Received: by 2002:a50:8163:: with SMTP id 90mr11604786edc.142.1607167220864;
        Sat, 05 Dec 2020 03:20:20 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id m13sm5713938edi.87.2020.12.05.03.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 03:20:20 -0800 (PST)
Date:   Sat, 5 Dec 2020 13:20:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/7] net: 8021q: remove unneeded MODULE_VERSION() usage
Message-ID: <20201205112018.zrddte4hu6kr5bxg@skbuf>
References: <20201202124959.29209-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202124959.29209-1-info@metux.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:49:53PM +0100, Enrico Weigelt, metux IT consult wrote:
> Remove MODULE_VERSION(), as it isn't needed at all: the only version
> making sense is the kernel version.
>
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  net/8021q/vlan.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index f292e0267bb9..683e9e825b9e 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -36,15 +36,10 @@
>  #include "vlan.h"
>  #include "vlanproc.h"
>
> -#define DRV_VERSION "1.8"
> -
>  /* Global VLAN variables */
>
>  unsigned int vlan_net_id __read_mostly;
>
> -const char vlan_fullname[] = "802.1Q VLAN Support";
> -const char vlan_version[] = DRV_VERSION;
> -
>  /* End of global variables definitions. */
>
>  static int vlan_group_prealloc_vid(struct vlan_group *vg,
> @@ -687,7 +682,7 @@ static int __init vlan_proto_init(void)
>  {
>  	int err;
>
> -	pr_info("%s v%s\n", vlan_fullname, vlan_version);
> +	pr_info("802.1Q VLAN Support\n");

How do we feel about deleting this not really informative message
altogether in a future patch?
