Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FBE6C43FD
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCVHYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCVHYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:24:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4DF113DA;
        Wed, 22 Mar 2023 00:24:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so18321048pjb.0;
        Wed, 22 Mar 2023 00:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679469879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpEbG4YQUaQXPtB2gfbr/azBJEM00eGr1PlhBXRaESA=;
        b=UqAaMbcv9xm8qzjjVTk6xdXIPMcuKT0JNYR2SmMvtl6pqpM+3VMfPyZ7uj+LKKhPH0
         JUExSAlBOBtOfESglH7n6/OFOEW6OBeIAhI20alggGLrgiTuKvyDFH0f+me3guMi7Y1Z
         jGSgJIkR20zgAa+nnjHfVzQM+DXTUFU84iNs0j0rMrtpO3d3I6ib/DP6fl7FaRyN16I1
         JLXPFamhoHMOP2VjpYEgaw4NqtNn8WhlXFaEv6W+pKgLVNFlU7SlaV5aYUb3HiQbHGcs
         TSHRZIc2ctq1e5CS/xxu9TCV7Sr+r9TWyGPGE38LvUmxO1J9w67G815k/LrdKQehPbvH
         1v6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679469879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zpEbG4YQUaQXPtB2gfbr/azBJEM00eGr1PlhBXRaESA=;
        b=joDRY9jDqPZtN3sItmHy7xUs35mGKUpyBKdotKA4ed70AR3zegKPFm+ZsCzDxK/r9v
         AhGbz2sFhtZ6sr9OKwhHFyED5cd12Jh9oFv75froXTt9tKnbAeKLrzoSN9VVp0h8a1Qy
         Aff+yzWJqmsI1r8j1PWqGQJASDgYfW07pFtiu+wvoHQWSKwElnKKxJpG0t4VhclHr0Yx
         WfF39/nDE/nqkYYmvQH0y7wUd6c/T/r01tWjrFMW0OrQ2EN3fREPUvqbSpq5YXzbZfqu
         5HSjTFlAe/1yij5ds3d0lpjMBjdRQyvmSTY5KDQSjK9F4s0SHVR+LJ+lYZpOZ4DH8ekP
         Fhbw==
X-Gm-Message-State: AO0yUKU6+wbSRgod5jk/qpuj2usWUffVcgzQG2D8ATkbM70KBzaCrHbc
        Ob+RoO3rjnMzcOUvwE76N1A=
X-Google-Smtp-Source: AK7set/5M/lA6U4QcNHXUFnsz2j3kZJEJkpdU24b0YJsLB41tdp8TWXvdB4rQv8eRaMkTVojyT8tgQ==
X-Received: by 2002:a17:903:247:b0:1a0:5671:42a6 with SMTP id j7-20020a170903024700b001a0567142a6mr1902982plh.31.1679469879073;
        Wed, 22 Mar 2023 00:24:39 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id ju10-20020a170903428a00b0019a83f2c99bsm9901305plb.28.2023.03.22.00.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 00:24:38 -0700 (PDT)
From:   xu xin <xu.xin.sc@gmail.com>
X-Google-Original-From: xu xin <xu.xin16@zte.com.cn>
To:     linyunsheng@huawei.com, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, jiang.xuexin@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xu.xin16@zte.com.cn, yang.yang29@zte.com.cn,
        zhang.yunkai@zte.com.cn
Subject: Re: [PATCH] rps: process the skb directly if rps cpu not changed
Date:   Wed, 22 Mar 2023 07:24:35 +0000
Message-Id: <20230322072435.32813-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aadae1c0-9d50-d89d-d0ea-a300fa09682c@huawei.com>
References: <aadae1c0-9d50-d89d-d0ea-a300fa09682c@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[So sorry, I made a mistake in the reply title]

On 2023/3/21 20:12, yang.yang29@zte.com.cn wrote:
>> From: xu xin <xu.xin16@zte.com.cn>
>> 
>> In the RPS procedure of NAPI receiving, regardless of whether the
>> rps-calculated CPU of the skb equals to the currently processing CPU, RPS
>> will always use enqueue_to_backlog to enqueue the skb to per-cpu backlog,
>> which will trigger a new NET_RX softirq.
>
>Does bypassing the backlog cause out of order problem for packet handling?
>It seems currently the RPS/RFS will ensure order delivery,such as:
>https://elixir.bootlin.com/linux/v6.3-rc3/source/net/core/dev.c#L4485
>
>Also, this is an optimization, it should target the net-next branch:
>[PATCH net-next] rps: process the skb directly if rps cpu not changed
>

Well, I thought the patch would't break the effort RFS tried to avoid "Out of
Order" packets. But thanks for your reminder, I rethink it again, bypassing the
backlog from "netif_receive_skb_list" will mislead RFS's judging if all
previous packets for the flow have been dequeued, where RFS thought all packets
have been dealed with, but actually they are still in skb lists. Fortunately,
bypassing the backlog from "netif_receive_skb" for a single skb is okay and won't
cause OOO packets because every skb is processed serially by RPS and sent to the
protocol stack as soon as possible.

If I'm correct, the code as follws can fix this.

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5666,8 +5666,9 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
        if (static_branch_unlikely(&rps_needed)) {
                struct rps_dev_flow voidflow, *rflow = &voidflow;
                int cpu = get_rps_cpu(skb->dev, skb, &rflow);
+               int current_cpu = smp_processor_id();
 
-               if (cpu >= 0) {
+               if (cpu >= 0 && cpu != current_cpu) {
                        ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
                        rcu_read_unlock();
                        return ret;
@@ -5699,11 +5700,15 @@ void netif_receive_skb_list_internal(struct list_head *head)
                list_for_each_entry_safe(skb, next, head, list) {
                        struct rps_dev_flow voidflow, *rflow = &voidflow;
                        int cpu = get_rps_cpu(skb->dev, skb, &rflow);
+                       int current_cpu = smp_processor_id();
 
                        if (cpu >= 0) {
                                /* Will be handled, remove from list */
                                skb_list_del_init(skb);
-                               enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
+                               if (cpu != current_cpu)
+                                       enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
+                               else
+                                       __netif_receive_skb(skb);
                        }
                }


Thanks.

>> 
>> Actually, it's not necessary to enqueue it to backlog when rps-calculated
>> CPU id equals to the current processing CPU, and we can call
>> __netif_receive_skb or __netif_receive_skb_list to process the skb directly.
>> The benefit is that it can reduce the number of softirqs of NET_RX and reduce
>> the processing delay of skb.
>> 
>> The measured result shows the patch brings 50% reduction of NET_RX softirqs.
>> The test was done on the QEMU environment with two-core CPU by iperf3.
>> taskset 01 iperf3 -c 192.168.2.250 -t 3 -u -R;
>> taskset 02 iperf3 -c 192.168.2.250 -t 3 -u -R;
>> 
>> Previous RPS:
>> 		    	CPU0       CPU1
>> NET_RX:         45          0    (before iperf3 testing)
>> NET_RX:        1095         241   (after iperf3 testing)
>> 
>> Patched RPS:
>>                 CPU0       CPU1
>> NET_RX:         28          4    (before iperf3 testing)
>> NET_RX:         573         32   (after iperf3 testing)
>
>Sincerely.
>Xu Xin
