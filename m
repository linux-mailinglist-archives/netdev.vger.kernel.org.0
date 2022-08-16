Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17625952F5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiHPGtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiHPGtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:49:04 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2D02B634;
        Mon, 15 Aug 2022 18:55:44 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id jm11so5701300plb.13;
        Mon, 15 Aug 2022 18:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=sh0+kl/MIhEpaGSpuSWIBcImTuOVUHOzxRM5k/ATctk=;
        b=Q8JW6K4cGjVEkYJQYxYvbagu805CQ2WZYbQp1cKmarFWTEtjA+EHABYTUjmser6KNq
         iGSZbKiIKxcVpynW6wRwwzq3A6ix3J07oxs+OruptnXr9aBpwWzF/EQS0DpIjvkpYZpN
         OVxGbOtl/sxdzKLM00lg0UTFp4SBnpRc7pa0GTz+Mhr8JkG/oq+/OVu+yfiViH6+QgCz
         67AK56RkGaxh7/jg33y8xU53X8ukpOrpVIOpa0lUPpztyLXN5HOGN/5eEEj/GXzg5s+W
         JBGJ76IjdNTUvROnkulTyhnK91/JDBAnG/2GaTyTgvO3amC6QVb4DeWJzVvXitlNs+xV
         K5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=sh0+kl/MIhEpaGSpuSWIBcImTuOVUHOzxRM5k/ATctk=;
        b=vUIXxI7dveAlghkAgu4VFJthKLWPTvhe3UCz0r8W4XDCG3HtZSkveNBTvM3s6goa1v
         SvDjAu7JSlASbD2fzliRnT8OHiPcNvLP5W75eaaw+3nsYosKkeJB8s0Ip/j7EFWwbjD5
         XRN+XEgkFxarVfmQo08882yKCHa7wc5dd8urAjnms23Re2Yxw1b1F8pYNjfw1lrnE2jt
         UULw/NPXEOMieByVgSAhugj1MDNSpnnPSCJKFDRCcdWOBLX47OPXDZq452Mxmc4GscUJ
         8kifQU/nVu7IT68RUJHBIomZ0UGF4Cno0PMuLcWOjawcaMycOjRaGKk4FR2D4FpOk9uf
         SXDQ==
X-Gm-Message-State: ACgBeo263U/q1ve5njUpvvnacp6JzEzqvdJc4yaDe+l6wEZNN0qgjG7V
        TEonRuMxMmk/lXMkyVY7Fws=
X-Google-Smtp-Source: AA6agR7YnhoAqUCK6ue9bgTGofU+lxSI6q+yVJj2gPy7gAsFY1BxVCN4KDR1FJzoIiduxoFGwPbj4g==
X-Received: by 2002:a17:902:8505:b0:171:3df7:dea1 with SMTP id bj5-20020a170902850500b001713df7dea1mr20033845plb.110.1660614944242;
        Mon, 15 Aug 2022 18:55:44 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902ea0b00b0016be96e07d1sm7630902plg.121.2022.08.15.18.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 18:55:43 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:55:42 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Wei Liu <wei.liu@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <Yvr4+t3IchkhFCfD@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220815162524-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815162524-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 04:39:08PM -0400, Michael S. Tsirkin wrote:
> 
> Given this affects the driver/device interface I'd like to
> ask you to please copy virtio-dev mailing list on these patches.
> Subscriber only I'm afraid you will need to subscribe :(
> 

Ah makes sense, will do!

Best,
Bobby
