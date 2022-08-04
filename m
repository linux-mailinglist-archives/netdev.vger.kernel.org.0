Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD785898F7
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbiHDIF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbiHDIFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:05:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED025FB2
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 01:05:23 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v3so23368453wrp.0
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 01:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oKb+q4alb43WGECxOaoZfLIR3VkQA7xt0+X4RXnCFnc=;
        b=cjIrl+8gyy20kNMO1/1M7zxX595MzpLz51MWmUDBhqsGxqwu6RuqoH27B4bExIHfh1
         cx9lPZT5FBiqo+K0GaCc6LBthyFsPX8O/bjZtG6MPaVzo4LBVlpWB0+UDIvmX6EIPpLf
         Fs+F07dm+KI12eG2oVkHEuxntH1HIs7ohNpxSvdfbKlKIRPOUMpvAEZ4eKZQCvmf9jBP
         baBSX5VIVlRswIVwEfQQL7FwnOVdt3EM1Daohfhb/7HzplkEm1Qpm22A1Cc/DRKQ1Q3z
         iRlf2swsI5PNP0E+vp7qoCm83lXLgZRmiH07t1/a6KtEXtjx63k4j4TCMm+ohz18Nccu
         ym9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oKb+q4alb43WGECxOaoZfLIR3VkQA7xt0+X4RXnCFnc=;
        b=uD0GF6crPRFIjxN6Dp54l6CoM1LiQ8MdjfKLHK0kgTX3uyOf3I19gCkfbKE0WlCuY8
         o3jIX3nDYLb3LL8P/1b715RyWe5bqq4oxv7c9lqc+o0+M6hIncGnCZ2CyTUZsCjNhzMO
         fZMx+21gPYaQgaM2njubrtIPLGvKFDJUfgEBjD/o0zaXR/I3IP3h4MUXNQI/6dsTRqaX
         OfwaypvryifPUobLtYSgOOtKgXinpbcC+LtwrxMjcFY3R0hiPkNQtrnQA+e0g7wgnxCo
         4WAkKjE/pWdBOUG6hmYVYlSpOGJHBuf+O8w2YWz/6VARHH3TIb29b0C0mCTCw2fZnla1
         Fqew==
X-Gm-Message-State: ACgBeo3d1/3xanK07/AqbahDHc/Rx7VknCr0hdf4QHz5vMiG/HyZtFyq
        Idyge5P0CNnI3t2CQ7dFojY=
X-Google-Smtp-Source: AA6agR7OWz0U/S8o608/LJsZt3igsEgI0+rzkESjTcscTeqZMcRIRK9WR2VyKp3TUNxpejq6oBFpag==
X-Received: by 2002:adf:d20c:0:b0:21f:15aa:14fa with SMTP id j12-20020adfd20c000000b0021f15aa14famr557353wrh.354.1659600321846;
        Thu, 04 Aug 2022 01:05:21 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id b3-20020a05600c150300b003a03185231bsm449709wmg.31.2022.08.04.01.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 01:05:21 -0700 (PDT)
Message-ID: <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
Date:   Thu, 4 Aug 2022 11:05:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
 <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
 <20220803182432.363b0c04@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220803182432.363b0c04@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2022 4:24 AM, Jakub Kicinski wrote:
> On Tue, 2 Aug 2022 17:54:01 +0300 Tariq Toukan wrote:
>>    [  407.589886] RIP: 0010:tls_device_decrypted+0x7a/0x2e0
> 
> Sorry, got distracted yesterday. This?
> 
> --->8--------------------
> tls: rx: device: bound the frag walk
> 
> We can't do skb_walk_frags() on the input skbs, because
> the input skbs is really just a pointer to the tcp read
> queue. We need to bound the "is decrypted" check by the
> amount of data in the message.
> 
> Note that the walk in tls_device_reencrypt() is after a
> CoW so the skb there is safe to walk. Actually in the
> current implementation it can't have frags at all, but
> whatever, maybe one day it will.
> 
> Reported-by: Tariq Toukan <tariqt@nvidia.com>
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   net/tls/tls_device.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index e3e6cf75aa03..6ed41474bdf8 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -984,11 +984,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
>   	int is_decrypted = skb->decrypted;
>   	int is_encrypted = !is_decrypted;
>   	struct sk_buff *skb_iter;
> +	int left;
>   
> +	left = rxm->full_len - skb->len;
>   	/* Check if all the data is decrypted already */
> -	skb_walk_frags(skb, skb_iter) {
> +	skb_iter = skb_shinfo(skb)->frag_list;
> +	while (skb_iter && left > 0) {
>   		is_decrypted &= skb_iter->decrypted;
>   		is_encrypted &= !skb_iter->decrypted;
> +
> +		left -= skb_iter->len;
> +		skb_iter = skb_iter->next;
>   	}
>   
>   	trace_tls_device_decrypted(sk, tcp_sk(sk)->copied_seq - rxm->full_len,

Now we see a different trace:

------------[ cut here ]------------
WARNING: CPU: 4 PID: 45887 at net/tls/tls_strp.c:53 
tls_strp_msg_make_copy+0x10e/0x120
Modules linked in: sch_netem iptable_raw bonding rdma_ucm nf_tables 
ib_ipoib ib_umad ip_gre ip6_gre gre ip6_tunnel tunnel6 ipip tunnel4 
mlx5_vfio_pci vfio_pci_core vfio_virqfd vfio_iommu_type1 vfio geneve 
mlx5_ib ib_uverbs mlx5_core openvswitch nsh xt_conntrack xt_MASQUERADE 
nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat 
br_netfilter rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm 
ib_cm overlay ib_core fuse [last unloaded: ib_uverbs]
CPU: 4 PID: 45887 Comm: iperf Not tainted 
5.19.0-rc8_net_next_mlx5_18607aa #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:tls_strp_msg_make_copy+0x10e/0x120
Code: 41 c7 47 44 00 00 00 00 48 8b 44 24 08 65 48 2b 04 25 28 00 00 00 
75 16 48 83 c4 10 4c 89 f8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b eb 
a5 e8 79 0a 28 00 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00
RSP: 0018:ffff88810574fb28 EFLAGS: 00010282
RAX: 00000000fffffff2 RBX: ffff8881136b8cd0 RCX: 0000000000000872
RDX: ffff8881c4bb6000 RSI: 0000000000004855 RDI: ffff88810c4ab500
RBP: 0000000000004855 R08: 00000000000042f0 R09: ffff88810c4aa000
R10: 0000000000000001 R11: 0000000000001000 R12: 0000160000000000
R13: 0000000000000001 R14: ffff8881ada4f8d0 R15: ffff88810c4aa000
FS:  00007f5efe4fe700(0000) GS:ffff88846fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5ef4004000 CR3: 00000001ee214005 CR4: 0000000000370ea0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <TASK>
  tls_rx_one_record+0x1f2/0x310
  tls_sw_recvmsg+0x327/0x8d0
  inet6_recvmsg+0x62/0x220
  ____sys_recvmsg+0x109/0x120
  ? _copy_from_user+0x44/0x80
  ? iovec_from_user+0x4a/0x150
  ___sys_recvmsg+0xa4/0xe0
  ? find_held_lock+0x2b/0x80
  ? __fget_files+0xb9/0x190
  ? __fget_files+0xd3/0x190
  __sys_recvmsg+0x4e/0x90
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f5effe086dd
Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 5a ef ff ff 8b 54 24 
1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2f 00 00 00 0f 05 <48> 3d 00 
f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 8e ef ff ff 48
RSP: 002b:00007f5efe4fda70 EFLAGS: 00000293 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 00007f5ef4022be0 RCX: 00007f5effe086dd
RDX: 0000000000000000 RSI: 00007f5efe4fdad0 RDI: 0000000000000004
RBP: 0000000000004130 R08: 0000000000000000 R09: 00007f5efe4fdc38
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f5ef40284e3
R13: 00007f5efe4fe660 R14: 00007f5efe4fdb58 R15: 00007f5ef4020ba0
  </TASK>
irq event stamp: 2999
hardirqs last  enabled at (3017): [<ffffffff811daf27>] 
__up_console_sem+0x67/0x70
hardirqs last disabled at (3030): [<ffffffff811daf0c>] 
__up_console_sem+0x4c/0x70
softirqs last  enabled at (2680): [<ffffffff81170d47>] 
irq_exit_rcu+0x97/0xd0
softirqs last disabled at (2671): [<ffffffff81170d47>] 
irq_exit_rcu+0x97/0xd0
---[ end trace 0000000000000000 ]---
