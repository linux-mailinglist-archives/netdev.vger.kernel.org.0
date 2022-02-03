Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE8B4A88C4
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238447AbiBCQlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352318AbiBCQll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:41:41 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5781AC06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:41:40 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id i19so2987051qvx.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=wEfhFHy+NFOqYQfJuNmdVRQdSmiIBKsi4KXKxLcO/KM=;
        b=IiF0KYtHGzcFhEbaKS4icU12c3D+TrgYxTaZaz/5Trr/KfN6+cN1Z2SpD1xRMl8VkP
         2kKiI16CUVoYzGi9graQi27dBWrTgbMXw/8NkesRkJx4DYHEqSd63GmUVZm2RboDWCxP
         b6rCrHPShFIka2qyRuUZPK3/wJRdfQjEgX6mdh8H0AKCu0IHwLp2pHV/0SvRykafTuHn
         ajSX+LhJcjkdC0lFecT5QFBhpwE0GYDHT8o9gevLparBXqpKT3wLkCBqWXLMjDxM7jxd
         3RhZgYNpSJsR2sui32s9NCsjWq8brrpFnFRhigTLMvmyZJcSaK3sc/QvCZ6+7I2rLlZw
         /84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wEfhFHy+NFOqYQfJuNmdVRQdSmiIBKsi4KXKxLcO/KM=;
        b=meSGGLWmTBJlCW2SWO7FyVYlTTg2QKGl4TNYm+Dhoxq3N3xene93JK17zvO8jDNk6I
         nD70rhJ26TDr5s9w5aAvTExxpLqsMIFkR0AYRbJrhY67kgFFS/jxs559CQ9cmQjiekst
         t2XNL/QrvxMbWMQsHZeSfLmj7Y/a9T5TZBGJbuzfpi+DW2hXmSFTC8GwNwCxXBVOZV0m
         5M1ElQS1tJ+5d+l7JXIZC9YXmAvMxOfdO+Yerx1tAuo+xxUCLVlLK73lkr5ZeJRE+hWJ
         KSw0wVYrL+JeX9gyPR3Qphe9rCQODEabbpY3KDQJv/czHuDJpswzG6jxcdUIOudiXHNM
         p7Vg==
X-Gm-Message-State: AOAM532qWFcb3+ChylTwB1s04MK8mzi4vgQ+f9P6zEkt1n26XIdFWm5l
        MySJ1Re1X9yV17GMa2CfN6ih9N4K6wMjtw==
X-Google-Smtp-Source: ABdhPJwuRGQRkSRlsSgQv5VGeVRr/aZ2P2zbekmwlmQ5imvBJFFsagp0GGfVbtL2bcAHmLIJCsjxoA==
X-Received: by 2002:a05:6214:27cd:: with SMTP id ge13mr31842609qvb.52.1643906499373;
        Thu, 03 Feb 2022 08:41:39 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id d11sm11707851qtd.63.2022.02.03.08.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:41:38 -0800 (PST)
Message-ID: <07cd64ccacb61cb933bb66af83cb238caf956c96.camel@gmail.com>
Subject: Re: [PATCH net-next 2/3] net: gro: minor optimization for
 dev_gro_receive()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Thu, 03 Feb 2022 08:39:57 -0800
In-Reply-To: <2a6db6d6ca415cb35cc7b3e4d9424baf0516d782.1643902526.git.pabeni@redhat.com>
References: <cover.1643902526.git.pabeni@redhat.com>
         <2a6db6d6ca415cb35cc7b3e4d9424baf0516d782.1643902526.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-03 at 16:48 +0100, Paolo Abeni wrote:
> While inspecting some perf report, I noticed that the compiler
> emits suboptimal code for the napi CB initialization, fetching
> and storing multiple times the memory for flags bitfield.
> This is with gcc 10.3.1, but I observed the same with older compiler
> versions.
> 
> We can help the compiler to do a nicer work clearing several
> fields at once using an u32 alias. The generated code is quite
> smaller, with the same number of conditional.
> 
> Before:
> objdump -t net/core/gro.o | grep " F .text"
> 0000000000000bb0 l     F .text  0000000000000357 dev_gro_receive
> 
> After:
> 0000000000000bb0 l     F .text  000000000000033c dev_gro_receive
> 
> RFC -> v1:
>  - use __struct_group to delimt the zeroed area (Alexander)
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/gro.h | 52 +++++++++++++++++++++++++--------------------
> --
>  net/core/gro.c    | 18 +++++++---------
>  2 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 8f75802d50fd..fa1bb0f0ad28 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -29,46 +29,50 @@ struct napi_gro_cb {
>         /* Number of segments aggregated. */
>         u16     count;
>  
> -       /* Start offset for remote checksum offload */
> -       u16     gro_remcsum_start;
> +       /* Used in ipv6_gro_receive() and foo-over-udp */
> +       u16     proto;
>  
>         /* jiffies when first packet was created/queued */
>         unsigned long age;
>  
> -       /* Used in ipv6_gro_receive() and foo-over-udp */
> -       u16     proto;
> +       /* portion of the cb set to zero at every gro iteration */
> +       __struct_group(/* no tag */, zeroed, /* no attrs */,

Any specific reason for using __struct_group here rather than the
struct_group macro instead?


