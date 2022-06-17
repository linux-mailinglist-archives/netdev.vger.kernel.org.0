Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12F54EF81
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379994AbiFQDIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379936AbiFQDIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:08:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61DF5EBEE
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 20:08:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h34-20020a17090a29a500b001eb01527d9eso2212538pjd.3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 20:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=05w5k2H6iAH0ZgNLPs0+l2PLAxsLXlw8R/ymoZjeiWA=;
        b=L1ijCKGk+5t0GFYr6QoXTOuTW2lQ5YXPwcnoiMY7ETJ5r4InHxmUSox96iNVWIPCw7
         geORc75Yp0A2REzbnK7CIdy4w5GE43FtCMMn1KwfKHunoyksryjt4mWmipSGDdYq0/n9
         lIjFSVM6xulhkuDMwgJZR2poUmQXSO0NCrT6BipgsBFZI8EbiGVxoW5IvB41/vO8bGRw
         1I+pOnNq0JSBJJuz0wWkvhx0xh9qMLS5zzji571ujkr6aO79+/rEATfwIp4eQf/8qK9p
         YcV53uvub22JVngjEt0OaMC306j0pcf9eYPTI5R+PbBbCPBuIIzX3yFQy2g3Z8+gXsID
         ngaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05w5k2H6iAH0ZgNLPs0+l2PLAxsLXlw8R/ymoZjeiWA=;
        b=wxB8eI8QEYtpySEZfe+8j8rLy51mgHegGdAFhcS3OfnZLVJsoPhbTXK4I8CC7CoFMs
         ikq8pqS7RuahAKqIw/p4JV8kXpuhivL/NGn5FgrloDQ2ECTpDNscZ9lJEuK5mTEk2XcF
         qiQjV1Hd7egFxqTq8u8TZlo1YNAo67I3qIrjDNNnAbWpc56A1774SqOvTuFsf5cPeL2W
         38rp+icNlncG83j0QP5RXAoBPekdrXsCMYk1cGfyMqkXVkGQ4gpPpgxFJiDxQrdnDv3/
         oh+/1IAvtvWdNOXe/T8cg76TmkRGlg/EMEONRKvYKHx7KagiqLZhy8N5/vZM21xEK2F5
         MUPA==
X-Gm-Message-State: AJIora+vxLnbVJknpyL9jJeiTU7Sf4jtYgjnbrfN/wYWoYunL/4LxK7X
        tmPsqfLu3/8etLeCGwoQs+aCFg==
X-Google-Smtp-Source: AGRyM1v2X0TnjSzAadnit9H8W9ElwHqlbqJ1rgB3Cfo5mtc3wxQzXXIyyIBCXj/bQoPI/AWse5xmBA==
X-Received: by 2002:a17:90b:4b47:b0:1e8:9529:27c6 with SMTP id mi7-20020a17090b4b4700b001e8952927c6mr18956391pjb.178.1655435297320;
        Thu, 16 Jun 2022 20:08:17 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902714f00b00168c1668a49sm2334325plm.85.2022.06.16.20.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 20:08:16 -0700 (PDT)
Date:   Thu, 16 Jun 2022 20:08:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Yuming Chen <chenyuming.junnan@bytedance.com>,
        Ted Lin <ted@mostlyuseful.tech>,
        Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net] net/sched: sch_netem: Fix arithmetic in
 netem_dump() for 32-bit platforms
Message-ID: <20220616200814.15fff125@hermes.local>
In-Reply-To: <20220616234336.2443-1-yepeilin.cs@gmail.com>
References: <20220616234336.2443-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 16:43:36 -0700
Peilin Ye <yepeilin.cs@gmail.com> wrote:

> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As reported by Yuming, currently tc always show a latency of UINT_MAX
> for netem Qdisc's on 32-bit platforms:
> 
>     $ tc qdisc add dev dummy0 root netem latency 100ms
>     $ tc qdisc show dev dummy0
>     qdisc netem 8001: root refcnt 2 limit 1000 delay 275s  275s
>                                                ^^^^^^^^^^^^^^^^
> 
> Let us take a closer look at netem_dump():
> 
>         qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency,
>                              UINT_MAX);
> 
> qopt.latency is __u32, psched_tdiff_t is signed long,
> (psched_tdiff_t)(UINT_MAX) is negative for 32-bit platforms, so
> qopt.latency is always UINT_MAX.
> 
> Fix it by using psched_time_t (u64) instead.
> 
> Note: confusingly, users have two ways to specify 'latency':
> 
>   1. normally, via '__u32 latency' in struct tc_netem_qopt;
>   2. via the TCA_NETEM_LATENCY64 attribute, which is s64.
> 
> For the second case, theoretically 'latency' could be negative.  This
> patch ignores that corner case, since it is broken (i.e. assigning a
> negative s64 to __u32) anyways, and should be handled separately.
> 
> Thanks Ted Lin for the analysis [1] .
> 
> [1] https://github.com/raspberrypi/linux/issues/3512
> 
> Reported-by: Yuming Chen <chenyuming.junnan@bytedance.com>
> Fixes: 112f9cb65643 ("netem: convert to qdisc_watchdog_schedule_ns")
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
>  net/sched/sch_netem.c | 4 ++--

Thanks for fixing. 
Guess it is time to run netem on one of the Pi's.

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
