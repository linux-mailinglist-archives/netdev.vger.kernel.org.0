Return-Path: <netdev+bounces-2608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A31702B01
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BA27281255
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FB6A957;
	Mon, 15 May 2023 11:02:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8C1C13
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:02:56 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1C593;
	Mon, 15 May 2023 04:02:54 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 23BB25C0192;
	Mon, 15 May 2023 07:02:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 May 2023 07:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684148574; x=1684234974; bh=k3bkc5kbQLind
	qaAZwgKQDCzKb/RiDpdbOBY6VLoomM=; b=Yq8V31mnYntVncpnkfikbvTODOLyk
	bYHwpE3kCaUI9YRjpSzWuFvcdKICu4I4Ypzf77TMRpVXWqMi5vx4mycr27TJ17mR
	rnsAj1zylvF5QQ2qN6My9wX+gDZdrb+/twOaA+BT2CBCuNgF1Za2R6U046tXkjQ8
	pyHNSlFDgxgG14MGLjrya5AKsTIc8TwS3DrWATHdC4eKBQBqXK2f8777fGY2qb+P
	uVkzZz7+HzuBIKpf9nEVfdFnOHsusrHpKn+7PGNsO6/gf779A75awX9BbaLfK8qU
	lQCthRo9JgEjNPcZR+WQK9/hyQ3NlNtilVbx55DvWwGEJp5dHreOchqJg==
X-ME-Sender: <xms:XRFiZHn_55FVWzhzBzskJGtfvtpefgILMoOS5DNj-J1Q03WdWv3uzA>
    <xme:XRFiZK2Y0Eg3kwaMsfjohjtWSL4PzzRrRFLKHsme6YIZAFp3NHbHIabFZFfRvWg4j
    TCUTeaFfFPU1Wc>
X-ME-Received: <xmr:XRFiZNrH2CY3cq5Vz_JfXzd1584CimRCifq4niA7FkZq7-9NL9S8q7Bm0zNY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehjedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XRFiZPlfttufVFWNDBs3dR8wYhFbBIj4N5_WS3pdiC-kdtO62KEdsQ>
    <xmx:XRFiZF1XsAroQFfSwhmID2IXNMt0Z9ATbmul0uO53l2CPdGA8oEwAg>
    <xmx:XRFiZOtcNaxVVmrbx9FReyo0mr-195GzWO3xik1-G0mxaA_-9RqGUQ>
    <xmx:XhFiZN8f8qv4hBVc7OQAxu3xjcL3o5noxh-dim_F5EKJM7wR2vRBKg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 May 2023 07:02:53 -0400 (EDT)
Date: Mon, 15 May 2023 14:02:50 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Angus Chen <angus.chen@jaguarmicro.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Remove low_thresh in ip defrag
Message-ID: <ZGIRWjNcfqI8yY8W@shredder>
References: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 09:01:52AM +0800, Angus Chen wrote:
> As low_thresh has no work in fragment reassembles,del it.
> And Mark it deprecated in sysctl Document.
> 
> Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>

Getting the following traces with this patch when creating a netns:

[   10.186564] ------------[ cut here ]------------                                                                                                                                                                                                                                                                    
[   10.186596] sysctl net/ipv4/ipfrag_low_thresh: data points to kernel global data: ipfrag_low_thresh_unused                                              
[   10.186648] WARNING: CPU: 1 PID: 193 at net/sysctl_net.c:155 register_net_sysctl+0xaf/0x150
[   10.186659] Modules linked in:                                                                                                                                                                                                                                                                                      
[   10.186667] CPU: 1 PID: 193 Comm: ip Not tainted 6.4.0-rc1-custom-gd1e4632b304c #57
[   10.186672] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
[   10.186681] RIP: 0010:register_net_sysctl+0xaf/0x150                                                                                                    
[   10.186691] Code: 00 a3 72 b9 48 81 fd 00 00 20 a3 73 b0 48 c7 c1 0b 7b dc a1 48 8b 13 4c 8b 43 08 4c 89 ee 48 c7 c7 d0 c2 eb a1 e8 41 66 44 ff <0f> 0b 66 81 63 14 6d ff 48 8b 53 40 48 83 c3 40 48 85 d2 75 8b 5b
[   10.186696] RSP: 0018:ffffaca28031bd98 EFLAGS: 00010282                                                                                                 
[   10.186705] RAX: 0000000000000000 RBX: ffff9daa80846640 RCX: 00000000ffffdfff
[   10.186711] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
[   10.186714] RBP: ffffffffa3162b28 R08: 00000000ffffdfff R09: 00000000ffffdfff
[   10.186717] R10: ffffffffa2670880 R11: ffffffffa2670880 R12: ffff9daa83100000
[   10.186720] R13: ffffffffa1e19fc9 R14: ffff9daa80846600 R15: 0000000000000000                                 
[   10.186728] FS:  00007fe0e810d740(0000) GS:ffff9dabb7c80000(0000) knlGS:0000000000000000   
[   10.186732] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                                                                                                                                                       
[   10.186735] CR2: 000056387c867530 CR3: 000000010318d005 CR4: 0000000000170ee0                       
[   10.186739] Call Trace:                                                                                                                                 
[   10.186766]  <TASK>                                                                                                                                     
[   10.186807]  ipv4_frags_init_net+0xe1/0x180                                                                                                                                                                                                                                                                         
[   10.186817]  ops_init+0x37/0x120                                                                                                                        
[   10.186826]  setup_net+0x12a/0x290                                                                                                                      
[   10.186831]  copy_net_ns+0xd8/0x180                                                                                                                     
[   10.186836]  create_new_namespaces+0x123/0x300                                                                                                          
[   10.186849]  unshare_nsproxy_namespaces+0x60/0xa0                                                                                                       
[   10.186857]  ksys_unshare+0x181/0x360                                                                                                                   
[   10.186869]  __x64_sys_unshare+0x12/0x20                                                                                                                
[   10.186876]  do_syscall_64+0x38/0x80                         
[   10.186885]  entry_SYSCALL_64_after_hwframe+0x63/0xcd                                                                                                   
[   10.186897] RIP: 0033:0x7fe0e82f23cb
[   10.186908] Code: 73 01 c3 48 8b 0d 65 5a 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 35 5a 0c 00 f7 d8 64 89 01 48
[   10.186912] RSP: 002b:00007ffe0513ec08 EFLAGS: 00000217 ORIG_RAX: 0000000000000110
[   10.186918] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007fe0e82f23cb
[   10.186921] RDX: 0000000000000000 RSI: 000056387c863113 RDI: 0000000040000000
[   10.186924] RBP: 000056387c862c3a R08: 0000000000000000 R09: 0000000000000073
[   10.186927] R10: 0000000000000000 R11: 0000000000000217 R12: 0000000000000000
[   10.186930] R13: 00007fe0e810d6b8 R14: 00007ffe05140e10 R15: 000056387c864fe5
[   10.186934]  </TASK>
[   10.186936] ---[ end trace 0000000000000000 ]---
[   10.187912] ------------[ cut here ]------------
[   10.187917] sysctl net/ipv6/ip6frag_low_thresh: data points to kernel global data: ip6_frags_low_thresh_unused
[   10.187955] WARNING: CPU: 0 PID: 193 at net/sysctl_net.c:155 register_net_sysctl+0xaf/0x150
[   10.187966] Modules linked in:
[   10.187970] CPU: 0 PID: 193 Comm: ip Tainted: G        W          6.4.0-rc1-custom-gd1e4632b304c #57
[   10.187980] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
[   10.187982] RIP: 0010:register_net_sysctl+0xaf/0x150
[   10.187989] Code: 00 a3 72 b9 48 81 fd 00 00 20 a3 73 b0 48 c7 c1 0b 7b dc a1 48 8b 13 4c 8b 43 08 4c 89 ee 48 c7 c7 d0 c2 eb a1 e8 41 66 44 ff <0f> 0b 66 81 63 14 6d ff 48 8b 53 40 48 83 c3 40 48 85 d2 75 8b 5b
[   10.187993] RSP: 0018:ffffaca28031bd98 EFLAGS: 00010282
[   10.187998] RAX: 0000000000000000 RBX: ffff9daa822d8240 RCX: 00000000ffffdfff
[   10.188002] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
[   10.188004] RBP: ffffffffa28ade80 R08: 00000000ffffdfff R09: 00000000ffffdfff
[   10.188008] R10: ffffffffa2670880 R11: ffffffffa2670880 R12: ffff9daa83100000
[   10.188010] R13: ffffffffa1e1c4fc R14: ffff9daa822d8200 R15: 0000000000000000
[   10.188017] FS:  00007fe0e810d740(0000) GS:ffff9dabb7c00000(0000) knlGS:0000000000000000
[   10.188021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.188024] CR2: 00007f1a0e26ece0 CR3: 000000010318d003 CR4: 0000000000170ef0
[   10.188027] Call Trace:
[   10.188031]  <TASK>
[   10.188035]  ipv6_frags_init_net+0xbd/0x150
[   10.188046]  ops_init+0x37/0x120
[   10.188051]  setup_net+0x12a/0x290
[   10.188057]  copy_net_ns+0xd8/0x180
[   10.188062]  create_new_namespaces+0x123/0x300
[   10.188071]  unshare_nsproxy_namespaces+0x60/0xa0
[   10.188078]  ksys_unshare+0x181/0x360
[   10.188087]  __x64_sys_unshare+0x12/0x20
[   10.188094]  do_syscall_64+0x38/0x80
[   10.188100]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   10.188108] RIP: 0033:0x7fe0e82f23cb
[   10.188113] Code: 73 01 c3 48 8b 0d 65 5a 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 35 5a 0c 00 f7 d8 64 89 01 48
[   10.188117] RSP: 002b:00007ffe0513ec08 EFLAGS: 00000217 ORIG_RAX: 0000000000000110
[   10.188122] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007fe0e82f23cb
[   10.188125] RDX: 0000000000000000 RSI: 000056387c863113 RDI: 0000000040000000
[   10.188128] RBP: 000056387c862c3a R08: 0000000000000000 R09: 0000000000000073
[   10.188131] R10: 0000000000000000 R11: 0000000000000217 R12: 0000000000000000
[   10.188133] R13: 00007fe0e810d6b8 R14: 00007ffe05140e10 R15: 000056387c864fe5
[   10.188138]  </TASK>
[   10.188140] ---[ end trace 0000000000000000 ]---

