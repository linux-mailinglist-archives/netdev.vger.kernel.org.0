Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE8364DB9E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 13:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiLOMvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 07:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLOMvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 07:51:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B8C2870B
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671108652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aBno//7WjcOWMRUrIz42bHzL1ShN20yQGU3sgB16aK0=;
        b=fJMx9dR/CexwZWr9Srp/sq8hnsJg+etlm6L9QFb2OLCeHMPBiq7kCnt5ecSk1jAx+6raa4
        3aGBEuGaewVOdJ0UJCiPyem5L8LfFxL5FU2YSYXTctNK8fG50OohYT2tmyfONON4z0RZwa
        iawo6iL76u1d+DNnbKL3JRC4pkvBUW4=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-E-Xa4_ApOZGwXUxQPvBo0g-1; Thu, 15 Dec 2022 07:50:51 -0500
X-MC-Unique: E-Xa4_ApOZGwXUxQPvBo0g-1
Received: by mail-vk1-f200.google.com with SMTP id n20-20020a1fa414000000b003bc585c7d50so3602683vke.16
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:50:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aBno//7WjcOWMRUrIz42bHzL1ShN20yQGU3sgB16aK0=;
        b=ww0o968OxJbLMpMIRb97xfNy3Srbrc8r2FsYV4rlYo0/ysAE6adj48JhYB7O44nAix
         EbwjKcSOyFf9byztvzVugMTKWlXLbV416BJ14NoyebiNDhf13jxz0FXbUv85wmivty+z
         2JvtoRyInJOt3EchmyeX3fJNtCdVXjqLEtpiFOUUI1fHjgH8nSyKD0XRVzYNtaKB7B2l
         0OGKQg/0nmxYcAqlCJ1OR5cwM1hJ8mtrrttI50QyY4rbPo9L/VhItJYOdCX7Qs1R163C
         onfR87iKKp9ItZOTnZaYBTP5Q3KaUzXZu49PGZ1eapFrkYrpa5ZMA8fLDHtv9J1CgCYd
         PyEA==
X-Gm-Message-State: AFqh2krC8BdiyzsI0HN2RKgmBUO5QE5eYSZHJQnUTKa3aVuYN6JkGRZo
        n+tyr1NIoS9xIIEBOr5ONfdRf68ps/PWHqRtVWef94l7YPYxrT7wbPT2dlwlYwAHqd2zhrC0OWm
        IP0z2l1fYk2FVIU7y
X-Received: by 2002:a05:6122:45d:b0:3c6:bdf4:6959 with SMTP id f29-20020a056122045d00b003c6bdf46959mr548674vkk.10.1671108649496;
        Thu, 15 Dec 2022 04:50:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu6DWo44NHcFV0orc///SSNVKIMZBmZgZHKCvvb1pzUQmok7MEpYkdW7V3f5Pd8o/lMvdjSfQ==
X-Received: by 2002:a05:6122:45d:b0:3c6:bdf4:6959 with SMTP id f29-20020a056122045d00b003c6bdf46959mr548583vkk.10.1671108647752;
        Thu, 15 Dec 2022 04:50:47 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-97-87.dyn.eolo.it. [146.241.97.87])
        by smtp.gmail.com with ESMTPSA id do39-20020a05620a2b2700b006fcc3858044sm11916151qkb.86.2022.12.15.04.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 04:50:47 -0800 (PST)
Message-ID: <f8af2b70e3c2074de04b2117100b2cdc5ec4ec6d.camel@redhat.com>
Subject: Re: [PATCH net v2] net: sched: ematch: reject invalid data
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jun Nie <jun.nie@linaro.org>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 13:50:43 +0100
In-Reply-To: <20221214022058.3625300-1-jun.nie@linaro.org>
References: <20221214022058.3625300-1-jun.nie@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 10:20 +0800, Jun Nie wrote:
> syzbot reported below bug. Refuse to compare for invalid data case to fix
> it.
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 PID: 6 Comm: kworker/0:0 Not tainted 5.15.77-syzkaller-00764-g7048384c9872 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: wg-crypt-wg2 wg_packet_tx_worker
> RIP: 0010:em_cmp_match+0x4e/0x5f0 net/sched/em_cmp.c:25
> Call Trace:
>  <TASK>
>  tcf_em_match net/sched/ematch.c:492 [inline]
>  __tcf_em_tree_match+0x194/0x720 net/sched/ematch.c:518
>  tcf_em_tree_match include/net/pkt_cls.h:463 [inline]
>  basic_classify+0xd8/0x250 net/sched/cls_basic.c:48
>  __tcf_classify net/sched/cls_api.c:1549 [inline]
>  tcf_classify+0x161/0x430 net/sched/cls_api.c:1589
>  prio_classify net/sched/sch_prio.c:42 [inline]
>  prio_enqueue+0x1d3/0x6a0 net/sched/sch_prio.c:75
>  dev_qdisc_enqueue net/core/dev.c:3792 [inline]
>  __dev_xmit_skb+0x35c/0x1650 net/core/dev.c:3876
>  __dev_queue_xmit+0x8f3/0x1b50 net/core/dev.c:4193
>  dev_queue_xmit+0x17/0x20 net/core/dev.c:4261
>  neigh_hh_output include/net/neighbour.h:508 [inline]
>  neigh_output include/net/neighbour.h:522 [inline]
>  ip_finish_output2+0xc0f/0xf00 net/ipv4/ip_output.c:228
>  __ip_finish_output+0x163/0x370
>  ip_finish_output+0x20b/0x220 net/ipv4/ip_output.c:316
>  NF_HOOK_COND include/linux/netfilter.h:299 [inline]
>  ip_output+0x1e9/0x410 net/ipv4/ip_output.c:430
>  dst_output include/net/dst.h:450 [inline]
>  ip_local_out+0x92/0xb0 net/ipv4/ip_output.c:126
>  iptunnel_xmit+0x4a2/0x890 net/ipv4/ip_tunnel_core.c:82
>  udp_tunnel_xmit_skb+0x1b6/0x2c0 net/ipv4/udp_tunnel_core.c:175
>  send4+0x78d/0xd20 drivers/net/wireguard/socket.c:85
>  wg_socket_send_skb_to_peer+0xd5/0x1d0 drivers/net/wireguard/socket.c:175
>  wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
>  wg_packet_tx_worker+0x202/0x560 drivers/net/wireguard/send.c:276
>  process_one_work+0x6db/0xc00 kernel/workqueue.c:2313
>  worker_thread+0xb3e/0x1340 kernel/workqueue.c:2460
>  kthread+0x41c/0x500 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
> 
> Reported-by: syzbot+963f7637dae8becc038f@syzkaller.appspotmail.com
> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")

Very likely this is not the correct fixes tag.

> Signed-off-by: Jun Nie <jun.nie@linaro.org>
> ---
>  net/sched/em_cmp.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
> index f17b049ea530..0284394be53f 100644
> --- a/net/sched/em_cmp.c
> +++ b/net/sched/em_cmp.c
> @@ -22,9 +22,14 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
>  			struct tcf_pkt_info *info)
>  {
>  	struct tcf_em_cmp *cmp = (struct tcf_em_cmp *) em->data;
> -	unsigned char *ptr = tcf_get_base_ptr(skb, cmp->layer) + cmp->off;
> +	unsigned char *ptr;
>  	u32 val = 0;
>  
> +	if (!cmp)
> +		return 0;

It feels like this is papering over the real issue. Why em->data is
NULL here? why other ematches are not afflicted by this issue? 

is em->data really NULL or some small value instead? KASAN seams to
tell it's a small value, not 0, so this patch should not avoid the
oops. Have you tested it vs the reproducer?

Thanks,

Paolo

