Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD52636D95F
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbhD1OQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhD1OQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 10:16:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B91C061573;
        Wed, 28 Apr 2021 07:15:52 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n2so10083520wrm.0;
        Wed, 28 Apr 2021 07:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2TpHsdEOrt7ciuQ/8DonxUWDEmVGDD5Q+PcxJbinjA8=;
        b=lcJDBUoeKWD+RKvR/VVPkhB0Aq29ff/KoBw1J/qHr221cHVaSIrbhecEowgc7pOOzt
         rLlBmh7hI+D8Vvpz0wokgFbOBzKN/Y64vYdRqdxOpLe/zgWi/qDpb3UxO3S6+ejkSvis
         ZdVVrbVoz3AOwvdRKDfJznQgvWCvYr0C3Yd6xG0vb7LLK4EhAAbRPXzR2PXo4HCAqU0M
         0qHp5e2o3uh0zpAkzCPJXfMTFV/Gk4PB9iMZFf4V8DDxFJhYHzClZSCdhiZhrL0PP3sO
         XWhDDcAHWQSpCdcxpAR8rq5xy4BeMuBy2jvMwTidW22+CEZ/Jye7h563iYM1nElm3+kr
         5Iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2TpHsdEOrt7ciuQ/8DonxUWDEmVGDD5Q+PcxJbinjA8=;
        b=G2+5if8AjbWhbWUcIYHgYFk1Cz6BD09iHBoRXb9a9ILpu9E41mYYdmZmy4rLNnvt9g
         itDgDXeqB+i/Je3rCvueHQjiBFHOFjdogNdfRnA7xdOyfjOlxNTQaAhKPZ5hG2lD9Ga+
         DnqokkuUJLCGx2cw9X/csHzc3t8I+i0E+LDzR+QVdS+Sy/Zn9psJYPA3BLdjRB0GaYuv
         Cc6EWsgmdeAk06hvmgyTEvCaEDxl/MCoiVy9ZFvhcDvCvgZpBUwk9QV32SzFcCw7W+Zt
         1NPadyAQQ76G0+c/lX8KDPpBMJlXQwKIUDk17oM0/AX0H+JZyElLvUDUv3zL6UG7FWpN
         Fn4Q==
X-Gm-Message-State: AOAM532c/Pb5K/EwNP6r23L5k8XZzycXcJAne+ZyeUgFB90+Z1aKtl4C
        dxKijrSbJQtJrkLrbfeOt232mCfEiZU=
X-Google-Smtp-Source: ABdhPJz/Ep1od8VTgUm37D4i97raVXSeNeA4KB1hHHImiFcsfBCxx6YAfdBZlov2ONKwDg0762E/Mg==
X-Received: by 2002:a05:6000:1209:: with SMTP id e9mr36880804wrx.192.1619619351230;
        Wed, 28 Apr 2021 07:15:51 -0700 (PDT)
Received: from [192.168.1.102] ([37.168.62.78])
        by smtp.gmail.com with ESMTPSA id x189sm7083129wmg.17.2021.04.28.07.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:15:50 -0700 (PDT)
Subject: Re: UBSAN: shift-out-of-bounds in __qdisc_calculate_pkt_len
To:     Hao Sun <sunhao.th@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CACkBjsYnV3_KkMasd-5GBeTBSqVun+BbPhNn+hyFpwA678mf4A@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e1d781fd-886b-3489-7eb0-4cef2a90920c@gmail.com>
Date:   Wed, 28 Apr 2021 16:15:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsYnV3_KkMasd-5GBeTBSqVun+BbPhNn+hyFpwA678mf4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 4:53 AM, Hao Sun wrote:
> Hi
> 
> When using Healer to fuzz the Linux kernel, UBSAN reported a
> shift-out-of-bounds bug in net/sched/sch_api.c:580:10.
> 
> Here are the details:
> commit:   89698becf06d341a700913c3d89ce2a914af69a2
> version:   Linux 5.12
> git tree:    upstream
> kernel config, reproduction program can be found in the attached file.
> 
> ================================================================================
> UBSAN: shift-out-of-bounds in net/sched/sch_api.c:580:10
> shift exponent 247 is too large for 32-bit type 'int'
> CPU: 1 PID: 3176 Comm: kworker/1:2 Not tainted 5.12.0-rc7+ #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x20c lib/ubsan.c:327
>  __qdisc_calculate_pkt_len.cold+0x1b/0xcf net/sched/sch_api.c:580
>  qdisc_calculate_pkt_len include/net/sch_generic.h:787 [inline]
>  __dev_xmit_skb net/core/dev.c:3803 [inline]
>  __dev_queue_xmit+0x13b2/0x3020 net/core/dev.c:4162
>  neigh_hh_output include/net/neighbour.h:499 [inline]
>  neigh_output include/net/neighbour.h:508 [inline]
>  ip_finish_output2+0xf20/0x2240 net/ipv4/ip_output.c:230
>  __ip_finish_output net/ipv4/ip_output.c:308 [inline]
>  __ip_finish_output+0x699/0xe20 net/ipv4/ip_output.c:290
>  ip_finish_output+0x35/0x200 net/ipv4/ip_output.c:318
>  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
>  ip_output+0x201/0x610 net/ipv4/ip_output.c:432
>  dst_output include/net/dst.h:448 [inline]
>  ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
>  iptunnel_xmit+0x618/0x9f0 net/ipv4/ip_tunnel_core.c:82
>  geneve_xmit_skb drivers/net/geneve.c:967 [inline]
>  geneve_xmit+0xea7/0x41b0 drivers/net/geneve.c:1075
>  __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4839 [inline]
>  xmit_one net/core/dev.c:3605 [inline]
>  dev_hard_start_xmit+0x1ff/0x940 net/core/dev.c:3621
>  __dev_queue_xmit+0x2699/0x3020 net/core/dev.c:4194
>  neigh_resolve_output net/core/neighbour.c:1491 [inline]
>  neigh_resolve_output+0x4ee/0x810 net/core/neighbour.c:1471
>  neigh_output include/net/neighbour.h:510 [inline]
>  ip6_finish_output2+0xd09/0x21f0 net/ipv6/ip6_output.c:117
>  __ip6_finish_output+0x4bb/0xe10 net/ipv6/ip6_output.c:182
>  ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
>  NF_HOOK_COND include/linux/netfilter.h:290 [inline]
>  ip6_output+0x242/0x810 net/ipv6/ip6_output.c:215
>  dst_output include/net/dst.h:448 [inline]
>  NF_HOOK include/linux/netfilter.h:301 [inline]
>  ndisc_send_skb+0xf52/0x14c0 net/ipv6/ndisc.c:508
>  ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
>  addrconf_dad_work+0xd29/0x1380 net/ipv6/addrconf.c:4119
>  process_one_work+0x9ad/0x1620 kernel/workqueue.c:2275
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2421
>  kthread+0x374/0x490 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> ================================================================================
> 

Can you submit a patch ?

We are at a point that we are flooded with such report. (look at syzbot queue for instance)

We prefer having formal patches, and as a bonus you will be a famous linux contributor.

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index f87d07736a1404edcfd17a792321758cd4bdd173..265289da7e84e4a408428767a57f82c00fd85b7f 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -504,6 +504,11 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
                return ERR_PTR(-EINVAL);
        }
 
+       if (s->cell_log >= 32 || s->size_log >= 32) {
+               NL_SET_ERR_MSG(extack, "Invalid cell_log/size_log of size table");
+               return ERR_PTR(-EINVAL);
+       }
+
        list_for_each_entry(stab, &qdisc_stab_list, list) {
                if (memcmp(&stab->szopts, s, sizeof(*s)))
                        continue;





