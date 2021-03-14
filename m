Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9404E33A820
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 22:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhCNVFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 17:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNVE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 17:04:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCBBC061574;
        Sun, 14 Mar 2021 14:04:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y6so14956890eds.1;
        Sun, 14 Mar 2021 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZjFfxKTovBxwulqo+ImLk+V9b+H+KpBCZ7VOswH7ocY=;
        b=avhChHTz5p/ny5mdvUjs28E6jY5jzEducLkh8t6R5uyYmEGKHtUxoxeTUW2mP8mflc
         xTjJxps+fnD9FjK6qeWNVvQCo5QsbXmtiDvdg30IDJZPjo3nK6YZkO7mh6uDfEaZWlW4
         xp4HAuE78q95I1yc+9m22tBjN6Vz0csGuEfRvmzrhv377ETqn+vfp1S5kVsWsbcVg6WE
         T+BlZJL8zb4mfXCXPZNIqYR0lOOPDNG/oNmL5n9DP3SWgi7fPggEg3E3B74pftQCFdz1
         Nx/2fLznKH6/rcVkkZsoypX45nUdXCIyBsYxQnWlIgoWezxDpttUQaCnPxmk0gSSQq4s
         UWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZjFfxKTovBxwulqo+ImLk+V9b+H+KpBCZ7VOswH7ocY=;
        b=esJRB9N/jkYMklQ2KqZtQYckTYfLcpNz6hs/jxpx8THmya/1N2zjzmgv7cqyNSaxJV
         zhZ8/0VeCwPhswcxJfXmK8SxHbhJ0rmoQ8k1EERKXYCeqMVS7oMM5ugRCPL/71Er/Q86
         GpFY7izLbnQJdM4GoBlYvAWzr28IbrmEKcYzUX+9Ca5RKDmsRLS4Fl7t9g8/K389YXs+
         eMSDNxNWZxjkDMRLGVn+5vJqUwMUi3sxWkSxBHAqvcLXL4QUy7L1HDKsK3qOb8Lv3gWd
         xCI6WZIXmFjql5ANW15LxscyWFq4LtYAZLRBSwR7QL2zq2RfGug34/FECMCTe//1vZuU
         gVew==
X-Gm-Message-State: AOAM530bXcZwFRdhmQQzVrHg0e1Z7YM17OG0wzRah74DhELHFBDkPGBb
        7wA06fACsRl4RHdiztAGajg=
X-Google-Smtp-Source: ABdhPJxpbdtZ+CSWF60SFXi3ZnNJd7ujB2AGPRdVqwzUGqkpLotiZZC6mAOdGDt6PqKyc0ma7pwF4g==
X-Received: by 2002:a05:6402:158d:: with SMTP id c13mr26381961edv.297.1615755896345;
        Sun, 14 Mar 2021 14:04:56 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id mc10sm6111783ejb.56.2021.03.14.14.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 14:04:55 -0700 (PDT)
Date:   Sun, 14 Mar 2021 23:04:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next 4/6] linux/etherdevice.h: misc trailing
 whitespace cleanup
Message-ID: <20210314210453.o2dmnud45w7rabcw@skbuf>
References: <20210314111027.7657-1-alobakin@pm.me>
 <20210314111027.7657-5-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314111027.7657-5-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 11:11:32AM +0000, Alexander Lobakin wrote:
> Caught by the text editor. Fix it separately from the actual changes.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  include/linux/etherdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 2e5debc0373c..bcb2f81baafb 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -11,7 +11,7 @@
>   * Authors:	Ross Biro
>   *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
>   *
> - *		Relocated to include/linux where it belongs by Alan Cox
> + *		Relocated to include/linux where it belongs by Alan Cox
>   *							<gw4pts@gw4pts.ampr.org>
>   */
>  #ifndef _LINUX_ETHERDEVICE_H
> --
> 2.30.2
> 
> 

Your mailer did something weird here, it trimmed the trailing whitespace
from the "-" line. The patch doesn't apply.
