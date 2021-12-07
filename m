Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE4846BFE4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhLGPyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhLGPyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:54:45 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87196C061574;
        Tue,  7 Dec 2021 07:51:15 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id s139so28383239oie.13;
        Tue, 07 Dec 2021 07:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5RC0SUNNieJVoq7OOLew5g5YdYByS++3ZIz6kV69YtQ=;
        b=c5KSMg8fdndhy8/ZJbbRl1gXY8zK3b8+050UzizWqxoynp0tTaaqLp7Txia8kIAY00
         +uv0Pl1mFQVCrYOZNAOaYwAn91E4+aN2EORBn0eFF1KGouZiKJmRIBeStDWKoT7Yqh03
         uWt1yMtlf71SJSMG+WLSQAKg0peL0ru0V/PK1nffAzOgjhMSMMnpHKpl/1rw+tyUg04H
         nA4rI76QyoS4LC5T6h6a2zm3koDmRuJoo/XBjtOX3CN5HUvZXwRIptjuz5XzFyjbikyz
         IKAq/0A5p8kkWHCtEYjKdTAkSrpDnAfJRKXtHzVXgFBG/6JuYdxrRwIgQtsNeaJ1HW68
         4PIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5RC0SUNNieJVoq7OOLew5g5YdYByS++3ZIz6kV69YtQ=;
        b=rqPeSlTdQwMq7MZwejDs2WsFQWmkQ64UztvphGdQGTOytO6GB4VJ7P8LY3OCsFpGTD
         nWFDYq6uQFxTFpe0f5pTl11yK4g7RvPItBr7cXkENecEDCvfpODyOgcDd5oQGbN4BrJg
         GXeDAOTUd2YRavsSW8guStW9uHbe4W4+PH50fD27Ua3zT9imGqoyZpOAjPsh8NFa4MjH
         +1bNn9vmO27NmiyxS8L+rkx4VzA+TklVKsdTk/kgdYFniTvPk97jKRicdkYsGqjzm5NB
         nlqaZxmzrJ2cZ6v0Q+N+nXZCE5OmnounbrrGf/1hCZ57Sk+gGTayJfwJmAnHqOLnQ/Sg
         iakA==
X-Gm-Message-State: AOAM532CSA2LAxIZwUBgZCY+EMKRGvjCEie68tTLyCCInnxDJafNQFAD
        dzVtavL96IzNDqA1YvnwUEY7ljUwj60=
X-Google-Smtp-Source: ABdhPJynmIO1zPK9Vosfp27CV7cVpHn4IpltNd/HrRpwB+O970MfkN9rcEfWEIv+zkn5la5oCRhJhA==
X-Received: by 2002:a54:4494:: with SMTP id v20mr5949442oiv.95.1638892274935;
        Tue, 07 Dec 2021 07:51:14 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id b17sm3082436ots.66.2021.12.07.07.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 07:51:14 -0800 (PST)
Message-ID: <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
Date:   Tue, 7 Dec 2021 08:51:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Content-Language: en-US
To:     Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20211206163447.991402-1-andrea.righi@canonical.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211206163447.991402-1-andrea.righi@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc a few SR6 folks ]

On 12/6/21 9:34 AM, Andrea Righi wrote:
> It is possible to trigger a NULL pointer dereference by running the srv6
> net kselftest (tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh):
> 
> [  249.051216] BUG: kernel NULL pointer dereference, address: 0000000000000378
> [  249.052331] #PF: supervisor read access in kernel mode
> [  249.053137] #PF: error_code(0x0000) - not-present page
> [  249.053960] PGD 0 P4D 0
> [  249.054376] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  249.055083] CPU: 1 PID: 21 Comm: ksoftirqd/1 Tainted: G            E     5.16.0-rc4 #2
> [  249.056328] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
> [  249.057632] RIP: 0010:ip6_forward+0x53c/0xab0
> [  249.058354] Code: 49 c7 44 24 20 00 00 00 00 48 83 e0 fe 48 8b 40 30 48 3d 70 b2 b5 81 0f 85 b5 04 00 00 e8 7c f2 ff ff 41 89 c5 e9 17 01 00 00 <44> 8b 93 78 03 00 00 45 85 d2 0f 85 92 fb ff ff 49 8b 54 24 10 48
> [  249.061274] RSP: 0018:ffffc900000cbb30 EFLAGS: 00010246
> [  249.062042] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8881051d3400
> [  249.063141] RDX: ffff888104bda000 RSI: 00000000000002c0 RDI: 0000000000000000
> [  249.064264] RBP: ffffc900000cbbc8 R08: 0000000000000000 R09: 0000000000000000
> [  249.065376] R10: 0000000000000040 R11: 0000000000000000 R12: ffff888103409800
> [  249.066498] R13: ffff8881051d3410 R14: ffff888102725280 R15: ffff888103525000
> [  249.067619] FS:  0000000000000000(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
> [  249.068881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  249.069777] CR2: 0000000000000378 CR3: 0000000104980000 CR4: 0000000000750ee0
> [  249.070907] PKRU: 55555554
> [  249.071337] Call Trace:
> [  249.071730]  <TASK>
> [  249.072070]  ? debug_smp_processor_id+0x17/0x20
> [  249.072807]  seg6_input_core+0x2bb/0x2d0
> [  249.073436]  ? _raw_spin_unlock_irqrestore+0x29/0x40
> [  249.074225]  seg6_input+0x3b/0x130
> [  249.074768]  lwtunnel_input+0x5e/0xa0
> [  249.075357]  ip_rcv+0x17b/0x190
> [  249.075867]  ? update_load_avg+0x82/0x600
> [  249.076514]  __netif_receive_skb_one_core+0x86/0xa0
> [  249.077231]  __netif_receive_skb+0x15/0x60
> [  249.077843]  process_backlog+0x97/0x160
> [  249.078389]  __napi_poll+0x31/0x170
> [  249.078912]  net_rx_action+0x229/0x270
> [  249.079506]  __do_softirq+0xef/0x2ed
> [  249.080085]  run_ksoftirqd+0x37/0x50
> [  249.080663]  smpboot_thread_fn+0x193/0x230
> [  249.081312]  kthread+0x17a/0x1a0
> [  249.081847]  ? smpboot_register_percpu_thread+0xe0/0xe0
> [  249.082677]  ? set_kthread_struct+0x50/0x50
> [  249.083340]  ret_from_fork+0x22/0x30
> [  249.083926]  </TASK>
> [  249.090295] ---[ end trace 1998d7ba5965a365 ]---
> 
> It looks like commit 0857d6f8c759 ("ipv6: When forwarding count rx stats
> on the orig netdev") tries to determine the right netdev to account the
> rx stats, but in this particular case it's failing and the netdev is
> NULL.
> 
> Fallback to the previous method of determining the netdev interface (via
> skb->dev) to account the rx stats when the orig netdev can't be
> determined.
> 
> Fixes: 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev")
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  net/ipv6/ip6_output.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index ff4e83e2a506..7ca4719ff34c 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -472,6 +472,9 @@ int ip6_forward(struct sk_buff *skb)
>  	u32 mtu;
>  
>  	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
> +	if (unlikely(!idev))
> +		idev = __in6_dev_get_safely(skb->dev);
> +

We need to understand why iif is not set - or set to an invalid value.


>  	if (net->ipv6.devconf_all->forwarding == 0)
>  		goto error;
>  
> 

