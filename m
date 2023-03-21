Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556F06C37FB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCURON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjCUROK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:14:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F295CB77D
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:13:39 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b20so29583184edd.1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679418816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qwHz4/9dnMV7mjKwGWCSSDfzoyGzlVzCiSmSZNtj3Gs=;
        b=Ko1+TzlJ0AwPpAfHMXTcJVbvWgHTUTWE/GpawM6+QZT6X+aZ/fAkCLaGpNTWvcqc8o
         4ATHHTx59AIuf17Sj1OHkoP+0WxzQcRqp+rc5h7FzVE+xyyihRIMqDG4dqBPoAypQAQG
         rExhHVEhjpOgJSNZiO5E12k03JUfzy2tXjrgitx18mLUOcfRaCTfNeUfY/TbH8Qu/ax9
         wKz9uqPd8q1pYJKemBak8ThBAv06fJqGMMJU9ViIox0w8XsJBTJzy74tkoCJs137zQWj
         QoDEtmOSv5cPXj6FSesie1E5/aoZl3Npj8VmZvjQi1GVX9PKlzL20sTKfSikTzZOIQLi
         E7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679418816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwHz4/9dnMV7mjKwGWCSSDfzoyGzlVzCiSmSZNtj3Gs=;
        b=MGhaLO33Bo9+S9SqqlPYFgd4W+Xo0kVBU5b5IRx2mA+hYxHinu1B1f2xJHf8iES4rQ
         7gHSVpWYCSK+jep8RggBRh6q2r/zZOtNuKZzfOFto2usm4CJref08WBVAF0DPLsm7gfF
         lZrOsvdaUD7mu5DtUCsBXBaLdpJOrHnizCwk8CrJQLp4rP6FREV/Id2cCIe4nXLIWX2u
         d4PoMtE3Qzs4FLIEdEJa1G/LoJ/ambGUD6hscj7ZmYBUp+eAlsck5UUeBzfE7QSunLrr
         8NgSR+vhYWTFHSFJmVtK4hH5SqiK/Z3082QZPEUr3mR5izLnwgO5BOg1bUeboTsE/5PA
         m4PQ==
X-Gm-Message-State: AO0yUKWhCuCyHCoIGzGRRFwwXuEQnTyBYiBRz0nNWnE2tV2UrnmNS2SS
        atojSsW8pfKWiIF32zq9q8U=
X-Google-Smtp-Source: AK7set8jpyhjlBFf3U3xYvAcdeafC0CoWzdQPzjTC/iChaNedNTcvLxmle87JV5/cj0Ftco3T6tlvQ==
X-Received: by 2002:a17:906:344f:b0:8b1:75a0:e5c6 with SMTP id d15-20020a170906344f00b008b175a0e5c6mr3773925ejb.18.1679418816238;
        Tue, 21 Mar 2023 10:13:36 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o11-20020a17090608cb00b008d0dbf15b8bsm6110222eje.212.2023.03.21.10.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:13:35 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:13:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/3] net: remove some skb_mac_header assumptions
Message-ID: <20230321171333.t4u6z2n5ex76h3ot@skbuf>
References: <20230321164519.1286357-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321164519.1286357-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Tue, Mar 21, 2023 at 04:45:16PM +0000, Eric Dumazet wrote:
> Historically, we tried o maintain skb_mac_header available in most of
> networking paths.
> 
> When reaching ndo_start_xmit() handlers, skb_mac_header() should always
> be skb->data.
> 
> With recent additions of skb_mac_header_was_set() and 
> DEBUG_NET_WARN_ON_ONCE() in skb_mac_header(), we can attempt
> to remove our reliance on skb_mac_header in TX paths.
> 
> When this effort completes we will remove skb_reset_mac_header()
> from __dev_queue_xmit() and replace it by
> skb_unset_mac_header() on DEBUG_NET builds.
> 
> Eric Dumazet (3):
>   net: do not use skb_mac_header() in qdisc_pkt_len_init()
>   sch_cake: do not use skb_mac_header() in cake_overhead()
>   net/sched: remove two skb_mac_header() uses
> 
>  net/core/dev.c         | 8 ++++----
>  net/sched/act_mirred.c | 2 +-
>  net/sched/act_mpls.c   | 2 +-
>  net/sched/sch_cake.c   | 6 +++---
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> -- 
> 2.40.0.rc2.332.ga46443480c-goog
> 

skb_mac_header() shows quite a few hits in net/dsa/ as well, in functions
that contain "xmit" in the name. Should those be changed as well?
