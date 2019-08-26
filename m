Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E639D52D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733154AbfHZRrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:47:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39670 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732551AbfHZRrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 13:47:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so339083wmg.4
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 10:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D4d6VbW5YDms7jlP346MaFNo8n4E5HMnV+xuxA0DfXk=;
        b=In0G1XLNSNCZcgQ+nnC1MUbJjC6Ncat7QxtGs7RjmqWhWZagTXJlHvABzvqxksf8Vw
         0SutLziKCMnEfqkgkshRlbRQPIooNZ4abxpCjMZQ5+J4iyFjNB3plmZNsWBzLtWb0PFa
         X7sEQ6VNA1M3V7fOJCkKQv5XOBMCBHMBJNbMEkfhUmMbJj/DnBB9aNEhgHEKlvO8Czhj
         2r9pNPMr3Fgrf7I2XcWiUmTnASsNOEl2ldowwSfv5F2CWC9YgQuqfXNHGug1+zVE9JQ9
         ZYc1fJjnd54W74W06f4kOrl1MaqGoX89WG675G8g3sqcnvpSoa3EgPi3l42DsvurcS6v
         U0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D4d6VbW5YDms7jlP346MaFNo8n4E5HMnV+xuxA0DfXk=;
        b=P0mXjXeQeh8yLancCQ9HiSU/GSuZr6afwBl9aYVnYXhOcYh1t6mecwMJleZGJsE4T2
         dQVFhEE5xDiIiiztTd7jeTRh9GtEoaSIvLI+bKfIlBe3F+QluLA6P5YIM7e0v48MLqQx
         ozYHmfl0tTwoLZXRWVRe3ZQpZL1vmsZw3s6xWqSbA89jJhAoZWItbaMvKl2VwJwtLJF9
         G03M/Ko+X787iioiBFNhMsiY6oeHFJX6kR8F4hZotEnHq271phVY32UWXMX7rCzkKLv+
         a6T0RoDFa5x4TPsskE/X/m62FOy4o4z1tlXAwMKIVC5I7j4NglSKpxBPdRZqItvcmaLY
         JbtA==
X-Gm-Message-State: APjAAAWftJHvcJ0FGsXpB9a+y3FZtwGW9Kbz/MrfxHnP6hevM7OM/TaR
        xkzsQwmLUPQg6cSzYvrcuAs=
X-Google-Smtp-Source: APXvYqygIZSn7fEsXCxJ3z+XH/URXthv9Fp8+WDUfxkLuTVrjlUbjo8roTJ50edKRbAvgWwvsaRFcQ==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr22002944wml.109.1566841663146;
        Mon, 26 Aug 2019 10:47:43 -0700 (PDT)
Received: from [192.168.8.147] (1.170.185.81.rev.sfr.net. [81.185.170.1])
        by smtp.gmail.com with ESMTPSA id c187sm288484wmd.39.2019.08.26.10.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2019 10:47:41 -0700 (PDT)
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
To:     Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
References: <20190826170724.25ff616f@pixies>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
Date:   Mon, 26 Aug 2019 19:47:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826170724.25ff616f@pixies>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/19 4:07 PM, Shmulik Ladkani wrote:
> Hi,
> 
> In our production systems, running v4.19.y longterm kernels, we hit a
> BUG_ON in 'skb_segment()'. It occurs rarely and although tried, couldn't
> synthetically reproduce.
> 
> In v4.19.41 it crashes at net/core/skbuff.c:3711
> 
> 		while (pos < offset + len) {
> 			if (i >= nfrags) {
> 				i = 0;
> 				nfrags = skb_shinfo(list_skb)->nr_frags;
> 				frag = skb_shinfo(list_skb)->frags;
> 				frag_skb = list_skb;
> 				if (!skb_headlen(list_skb)) {
> 					BUG_ON(!nfrags);
> 				} else {
> 3711:					BUG_ON(!list_skb->head_frag);
> 
> With the accompanying dump:
> 
>  kernel BUG at net/core/skbuff.c:3711!
>  invalid opcode: 0000 [#1] SMP PTI
>  CPU: 2 PID: 0 Comm: swapper/2 Kdump: loaded Not tainted 4.19.41-041941-generic #201905080231
>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
>  RIP: 0010:skb_segment+0xb65/0xda9
>  Code: 89 44 24 60 48 89 4c 24 70 e8 87 b3 ff ff 48 8b 4c 24 70 44 8b 44 24 60 85 c0 44 8b 54 24 4c 0f 84 fc fb ff ff e9 16 fd ff ff <0f> 0b 29 c1 89 ce 09 ca e9 61 ff ff ff 0f 0b 41 8b bf 84 00 00 00
>  RSP: 0018:ffff9e4d79b037c0 EFLAGS: 00010246
>  RAX: ffff9e4d75012ec0 RBX: ffff9e4d74067500 RCX: 0000000000000000
>  RDX: 0000000000480020 RSI: 0000000000000000 RDI: ffff9e4d74e3a200
>  RBP: ffff9e4d79b03898 R08: 0000000000000564 R09: f69d84ecbfe8b972
>  R10: 0000000000000571 R11: a6b66a32f69d84ec R12: 0000000000000564
>  R13: ffff9e4c18d03ef0 R14: 0000000000000000 R15: ffff9e4d74e3a200
>  FS:  0000000000000000(0000) GS:ffff9e4d79b00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00000000007f50d8 CR3: 000000009420a003 CR4: 00000000001606e0
>  Call Trace:
>   <IRQ>
>   tcp_gso_segment+0xf9/0x4e0
>   tcp6_gso_segment+0x5e/0x100
>   ipv6_gso_segment+0x112/0x340
>   skb_mac_gso_segment+0xb9/0x130
>   __skb_gso_segment+0x84/0x190
>   validate_xmit_skb+0x14a/0x2f0
>   validate_xmit_skb_list+0x4b/0x70
>   sch_direct_xmit+0x154/0x390
>   __dev_queue_xmit+0x808/0x920
>   dev_queue_xmit+0x10/0x20
>   neigh_direct_output+0x11/0x20
>   ip6_finish_output2+0x1b9/0x5b0
>   ip6_finish_output+0x13a/0x1b0
>   ip6_output+0x6c/0x110
>   ? ip6_fragment+0xa40/0xa40
>   ip6_forward+0x501/0x810
>   ip6_rcv_finish+0x7a/0x90
>   ipv6_rcv+0x69/0xe0
>   ? nf_hook.part.24+0x10/0x10
>   __netif_receive_skb_core+0x4fa/0xc80
>   ? netif_receive_skb_core+0x20/0x20
>   ? netif_receive_skb_internal+0x45/0xf0
>   ? tcp4_gro_complete+0x86/0x90
>   ? napi_gro_complete+0x53/0x90
>   __netif_receive_skb_one_core+0x3b/0x80
>   __netif_receive_skb+0x18/0x60
>   process_backlog+0xb3/0x170
>   net_rx_action+0x130/0x350
>   __do_softirq+0xdc/0x2d4
> 
> To our best knowledge, the packet flow leading to this BUG_ON is:
> 
>   - ingress on eth0 (veth, gro:on), ipv4 udp encapsulated esp
>   - re-ingresss on eth0, after xfrm, decapsulated ipv4 tcp
>   - the skb was GROed (skb_is_gso:true)
>   - ipv4 forwarding to dummy1, where eBPF nat4-to-6 program is attached
>     at TC Egress (calls 'bpf_skb_change_proto()'), then redirect to ingress
>     on same device.
>     NOTE: 'bpf_skb_proto_4_to_6()' mangles 'shinfo->gso_size'

Doing this on an skb with a frag_list is doomed, in current gso_segment() state.

A rewrite  would be needed (I believe I did so at some point, but Herbert Xu fought hard against it)


>   - ingress on dummy1, ipv6 tcp
>   - ipv6 forwarding
>   - egress on tun2 (tun device) that calls:
>     validate_xmit_skb -> ... -> skb_segment BUG_ON
> 
> A similar issue was reported and fixed by Yonghong Song in commit
> 13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb").
> 
> However 13acc94eff12 added "BUG_ON(!list_skb->head_frag)" to line 3711,
> and patchwork states:
> 
>     This patch addressed the issue by handling skb_headlen(list_skb) != 0
>     case properly if list_skb->head_frag is true, which is expected in
>     most cases. [1]
> 
> meaning, 13acc94eff12 does not support list_skb->head_frag=0 case.
> 
> Historically, it is claimed that skb_segment is rather intolerant to
> gso_size changes, quote:
> 
>     Eric suggested to shrink gso_size instead to avoid segmentation+fragments.
>     I think its nice idea, but skb_gso_segment makes certain assumptions about
>     nr_frags and gso_size (it can't handle frag size > desired mss). [2]
> 
> Any suggestions how to debug and fix this?
> 
> Could it be that 'bpf_skb_change_proto()' isn't really allowed to
> mangle 'gso_size', and we should somehow enforce a 'skb_segment()' call
> PRIOR translation?
> 
> Appreciate any input and assistance,
> Shmulik
> 
> [1] https://patchwork.ozlabs.org/patch/889166/
> [2] https://patchwork.ozlabs.org/patch/314327/
> 
