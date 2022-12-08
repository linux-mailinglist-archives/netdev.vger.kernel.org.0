Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95737647366
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLHPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHPov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:44:51 -0500
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC72942F55;
        Thu,  8 Dec 2022 07:44:47 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id vp12so4976876ejc.8;
        Thu, 08 Dec 2022 07:44:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdyBFEqIG8fwUURQmTwxGO8y2+7Y099+U/U3XuFwmKs=;
        b=jUdgSsy2Seh12U1Hm2V8UaK+ek41YBy06mTA0uvmX9LyhYOjaF5IfZrUgly9/EqbWA
         2Nl1OXA4lEWvNpENHXl8EnolG77IBzhmyuJojExIRb22UgStsNyeILNXJMtAI8ninWBU
         0RsPWAfjhbsFw4PB0PL8NmF8plCHzfv2KwUMbSELI8doiGjfqPbY+oV2Rrv+tPeJ7edC
         B9zjTJpxAwmhRxb22tyUm9R1Dw0BpPehIWOAz4kZPavxezTAdijcpe8Ei+zGrxKuDwKh
         Hvd+OH1DET2yRsHJxh8nPCDGbtn1vtNPqmVoE79YYAgOS3a6Y5kTA60FxK9Nxjf8j6oO
         4Uxw==
X-Gm-Message-State: ANoB5pm01BkvmAVYHBxuV2cE5O6zkp2KxYskADfzLxDL8f/pTUTZGeLY
        Yst7VyPnzDpjZorrFN97bzY=
X-Google-Smtp-Source: AA0mqf4oi+8BUrMWWDImPFU0JGrSg7Ie1vhBSSnBlx4DUf9VAaCqOG8qkonahdAb1RMepkTm+zVlWg==
X-Received: by 2002:a17:906:f741:b0:7b4:edca:739 with SMTP id jp1-20020a170906f74100b007b4edca0739mr2275729ejb.5.1670514286255;
        Thu, 08 Dec 2022 07:44:46 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-117.fbsv.net. [2a03:2880:31ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id g18-20020a17090604d200b0078d9b967962sm9720473eja.65.2022.12.08.07.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 07:44:45 -0800 (PST)
Date:   Thu, 8 Dec 2022 07:44:43 -0800
From:   Breno Leitao <leitao@debian.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, leit@fb.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of
 WARN_ON_ONCE()
Message-ID: <Y5IGa0pauk+YkSSv@gmail.com>
References: <20220831133758.3741187-1-leitao@debian.org>
 <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
 <Y5DPU3p+N7rBW+QY@gmail.com>
 <CANn89iKia8PVz8QrtukzA-9wUiJHiOB1r6d04xuL_YHqHaBULw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKia8PVz8QrtukzA-9wUiJHiOB1r6d04xuL_YHqHaBULw@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 06:59:38PM +0100, Eric Dumazet wrote:
> On Wed, Dec 7, 2022 at 6:37 PM Breno Leitao <leitao@debian.org> wrote:
> >
> > On Sat, Sep 03, 2022 at 09:42:43AM -0700, Eric Dumazet wrote:
> > > On Wed, Aug 31, 2022 at 6:38 AM Breno Leitao <leitao@debian.org> wrote:
> > > >
> > > > There are cases where we need information about the socket during a
> > > > warning, so, it could help us to find bugs that happens that do not have
> > > > a easily repro.
> > > >
> > > > BPF congestion control algorithms can change socket state in unexpected
> > > > ways, leading to WARNings. Additional information about the socket state
> > > > is useful to identify the culprit.
> > >
> > > Well, this suggests we need to fix BPF side ?
> > >
> > > Not sure how this can happen, because TCP_BPF_IW has
> > >
> > > if (val <= 0 || tp->data_segs_out > tp->syn_data)
> > >      ret = -EINVAL;
> > > else
> > >     tcp_snd_cwnd_set(tp, val);
> >
> > I am not sure we are hitting this path, please check the stack below
> >
> > > It seems you already found the issue in an eBPF CC, can you share the details ?
> >
> > Sure, here is an example of what we are facing (with some obfuscation).
> > Remeber that there are users' BPF application running:
> >
> > [155375.750105] ------------[ cut here ]------------
> > [155375.759526] WARNING: CPU: 19 PID: 0 at net/ipv4/tcp.c:4552 tcp_sock_warn+0x6/0x20
> > [155375.774700] Modules linked in: vhost_net tun vhost vhost_iotlb tap virtio_net net_failover failover mpls_gso mpls_iptunnel mpls_router ip_tunnel fou ip6_udp_tunnel udp_tunnel sch_fq sunrpc bpf_preload tls act_gact cls_bpf tcp_diag inet_diag skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm evdev ses irqbypass enclosure i2c_i801 i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq button tpm_crb sch_fq_codel fuse sg nvme mpi3mr scsi_transport_sas nvme_core xhci_pci xhci_hcd loop efivarfs autofs4
> > [155375.874916] CPU: 19 PID: 0 Comm: swapper/19 Kdump: loaded Tainted: G S                5.12.0-0_XXXXXXXX_g0fed6f189e14 #1
> > [155375.898770] Hardware name: XXXX XXX XXXX XXXXX, BIOS BS_BIOS_XXX XX/XX/2022
> > [155375.916015] RIP: 0010:tcp_sock_warn+0x6/0x20
> > [155375.924755] Code: 4d 01 3e 85 c0 0f 84 57 ff ff ff 48 8b 0c 24 44 8b 01 eb 82 e8 eb b7 14 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 <0f> 0b 48 85 ff 0f 85 77 70 14 00 5b c3 66 66 2e 0f 1f 84 00 00 00
> > [155375.962518] RSP: 0018:ffffc90000d08988 EFLAGS: 00010246
> > [155375.973157] RAX: ffff88817432b5c0 RBX: ffff88828f748000 RCX: ffffc90000d08a34
> > [155375.987614] RDX: 0000000000000000 RSI: 00000000822be8c8 RDI: ffff88828f748000
> > [155376.002074] RBP: 0000000000000040 R08: ffffc90000d08a38 R09: 00000000822be334
> > [155376.016531] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> > [155376.030988] R13: ffffc90000d08a34 R14: 0000000000005546 R15: 0000000000000000
> > [155376.045441] FS:  0000000000000000(0000) GS:ffff88903f8c0000(0000) knlGS:0000000000000000
> > [155376.061804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [155376.073474] CR2: 00007fe407603080 CR3: 0000000b19993006 CR4: 00000000007706e0
> > [155376.087928] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [155376.102383] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [155376.116841] PKRU: 55555554
> > [155376.122427] Call Trace:
> > [155376.127497]  <IRQ>
> > [155376.131697]  tcp_fastretrans_alert+0x988/0x9e0
> > [155376.140774]  tcp_ack+0x8b4/0x1360
> > [155376.147581]  ? __cgroup_bpf_run_filter_skb+0x185/0x440
> > [155376.158037]  tcp_rcv_established+0x135/0x660
> > [155376.166755]  ? sk_filter_trim_cap+0xbc/0x220
> > [155376.175472]  tcp_v6_do_rcv+0xbe/0x3e0
> > [155376.182974]  tcp_v6_rcv+0xc01/0xc90
> > [155376.190128]  ip6_protocol_deliver_rcu+0xbd/0x450
> > [155376.199541]  ip6_input_finish+0x3d/0x60
> > [155376.207388]  ip6_input+0xb5/0xc0
> > [155376.214019]  ip6_sublist_rcv_finish+0x37/0x50
> > [155376.222912]  ip6_sublist_rcv+0x1dd/0x270
> > [155376.230935]  ipv6_list_rcv+0x113/0x140
> > [155376.238618]  __netif_receive_skb_list_core+0x1a0/0x210
> > [155376.249080]  netif_receive_skb_list_internal+0x186/0x2a0
> > [155376.259887]  gro_normal_list.part.171+0x19/0x40
> > [155376.269137]  napi_complete_done+0x65/0x150
> > [155376.277514]  bnxt_poll_p5+0x25b/0x2b0
> > [155376.285027]  ? tcp_write_xmit+0x278/0x1060
> > [155376.293398]  __napi_poll+0x25/0x120
> > [155376.300552]  net_rx_action+0x189/0x300
> > [155376.308227]  __do_softirq+0xbb/0x271
> > [155376.315554]  irq_exit_rcu+0x97/0xa0
> > [155376.322710]  common_interrupt+0x7f/0xa0
> > [155376.330566]  </IRQ>
> > [155376.334947]  asm_common_interrupt+0x1e/0x40
> > [155376.343499] RIP: 0010:cpuidle_enter_state+0xc2/0x340
> > [155376.353619] Code: 48 89 c5 0f 1f 44 00 00 31 ff e8 f9 8d 73 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 38 02 00 00 31 ff e8 b2 36 79 ff fb 45 85 f6 <0f> 88 e8 00 00 00 49 63 d6 48 2b 2c 24 48 6b ca 68 48 8d 04 52 48
> > [155376.391367] RSP: 0018:ffffc90000293e90 EFLAGS: 00000202
> > [155376.402004] RAX: ffff88903f8eaa80 RBX: ffffe8ffff4c6c00 RCX: 000000000000001f
> > [155376.416456] RDX: 00008d503c63f228 RSI: 000000005ba4b680 RDI: 0000000000000000
> > [155376.430910] RBP: 00008d503c63f228 R08: 0000000000000002 R09: 000000000002a300
> > [155376.445372] R10: 002435b781e62f4a R11: ffff88903f8e9a84 R12: 0000000000000001
> > [155376.459832] R13: ffffffff83621200 R14: 0000000000000001 R15: 0000000000000000
> > [155376.474307]  cpuidle_enter+0x29/0x40
> > [155376.481654]  do_idle+0x1bb/0x200
> > [155376.488297]  cpu_startup_entry+0x19/0x20
> > [155376.496320]  start_secondary+0x104/0x140
> > [155376.504342]  secondary_startup_64_no_verify+0xb0/0xbb
> > [155376.514629] ---[ end trace 9b428a0d7901c3ff ]---
> > [155376.524041] TCP: Socket Info: family=10 state=1 sport=12345 dport=57616 ccname=ned_tcp_dctcp01 cwnd=1
> > [155376.524045] TCP: saddr=XXXX:XXXX:XXXX:XXXX:XXXX:0000:00c8:0000 daddr=XXXX:XXXX:XXXX:XXXX:XXXX:0000:0288:00
> 
> Try to give us symbols with scripts/decode_stacktrace.sh , thanks.

Sorry, here it is:

 [749619.538804] WARNING: CPU: 19 PID: 0 at net/ipv4/tcp.c:4552 tcp_sock_warn+0x6/0x20
 [749619.553969] Modules linked in: sch_fq sunrpc bpf_preload tls act_gact cls_bpf tcp_diag inet_diag skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt iTCO_vendor_support kvm evdev ses irqbypass enclosure i2c_i801 i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq button tpm_crb sch_fq_codel vhost_net tun tap vhost vhost_iotlb virtio_net net_failover failover mpls_gso mpls_iptunnel mpls_router ip_tunnel fou ip6_udp_tunnel udp_tunnel fuse sg nvme mpi3mr scsi_transport_sas nvme_core xhci_pci xhci_hcd loop efivarfs autofs4
 [749619.678066] Hardware name: XXXXX
 [749619.695308] RIP: tcp_sock_warn+0x6/0x20
 [749619.704034] Code: 4d 01 3e 85 c0 0f 84 57 ff ff ff 48 8b 0c 24 44 8b 01 eb 82 e8 eb b7 14 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 <0f> 0b 48 85 ff 0f 85 77 70 14 00 5b c3 66 66 2e 0f 1f 84 00 00 00
 All code
 ========
    0:	4d 01 3e             	add    %r15,(%r14)
    3:	85 c0                	test   %eax,%eax
    5:	0f 84 57 ff ff ff    	je     0xffffffffffffff62
    b:	48 8b 0c 24          	mov    (%rsp),%rcx
    f:	44 8b 01             	mov    (%rcx),%r8d
   12:	eb 82                	jmp    0xffffffffffffff96
   14:	e8 eb b7 14 00       	callq  0x14b804
   19:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
   20:	00 00 00 00
   24:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   29:	53                   	push   %rbx
   2a:*	0f 0b                	ud2    		<-- trapping instruction
   2c:	48 85 ff             	test   %rdi,%rdi
   2f:	0f 85 77 70 14 00    	jne    0x1470ac
   35:	5b                   	pop    %rbx
   36:	c3                   	retq
   37:	66                   	data16
   38:	66                   	data16
   39:	2e                   	cs
   3a:	0f                   	.byte 0xf
   3b:	1f                   	(bad)
   3c:	84 00                	test   %al,(%rax)
 	...

 Code starting with the faulting instruction
 ===========================================
    0:	0f 0b                	ud2
    2:	48 85 ff             	test   %rdi,%rdi
    5:	0f 85 77 70 14 00    	jne    0x147082
    b:	5b                   	pop    %rbx
    c:	c3                   	retq
    d:	66                   	data16
    e:	66                   	data16
    f:	2e                   	cs
   10:	0f                   	.byte 0xf
   11:	1f                   	(bad)
   12:	84 00                	test   %al,(%rax)
 	...
 [749619.741779] RSP: 0018:ffffc90000d08988 EFLAGS: 00010246
 [749619.752436] RAX: ffff88814b57f5c0 RBX: ffff8881bd2540c0 RCX: ffffc90000d08a34
 [749619.766900] RDX: 0000000000000000 RSI: 00000000cda8f4af RDI: ffff8881bd2540c0
 [749619.781364] RBP: 0000000000000000 R08: ffffc90000d08a38 R09: 00000000cda8f44f
 [749619.795831] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 [749619.810300] R13: ffffc90000d08a34 R14: 0000000000011406 R15: 0000000000000000
 [749619.824788] FS:  0000000000000000(0000) GS:ffff88903f8c0000(0000) knlGS:0000000000000000
 [749619.841168] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [749619.852857] CR2: 000000000007c2e9 CR3: 0000000b82412002 CR4: 00000000007706e0
 [749619.867331] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [749619.881800] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [749619.896260] PKRU: 55555554
 [749619.901859] Call Trace:
 [749619.906927]  <IRQ>
 [749619.911129] tcp_fastretrans_alert+0x988/0x9e0
 [749619.920222] ? kmem_cache_free+0x33c/0x3d0
 [749619.928606] tcp_ack+0x8b4/0x1360
 [749619.935425] ? __cgroup_bpf_run_filter_skb+0x185/0x440
 [749619.945910] tcp_rcv_established+0x2f3/0x660
 [749619.954639] ? sk_filter_trim_cap+0xbc/0x220
 [749619.963358] tcp_v6_do_rcv+0xbe/0x3e0
 [749619.970863] tcp_v6_rcv+0xc01/0xc90
 [749619.978029] ip6_protocol_deliver_rcu+0xbd/0x450
 [749619.987453] ip6_input_finish+0x3d/0x60
 [749619.995313] ip6_input+0xb5/0xc0
 [749620.001958] ip6_sublist_rcv_finish+0x37/0x50
 [749620.010851] ip6_sublist_rcv+0x1dd/0x270
 [749620.018877] ipv6_list_rcv+0x113/0x140
 [749620.026552] __netif_receive_skb_list_core+0x1a0/0x210
 [749620.037025] netif_receive_skb_list_internal+0x186/0x2a0
 [749620.047838] ? napi_gro_complete+0x6c/0xd0
 [749620.056215] gro_normal_list.part.171+0x19/0x40
 [749620.065471] napi_complete_done+0x65/0x150
 [749620.073856] bnxt_poll_p5+0x25b/0x2b0
 [749620.081369] __napi_poll+0x25/0x120
 [749620.088537] net_rx_action+0x189/0x300
 [749620.096224] __do_softirq+0xbb/0x271
 [749620.103571] irq_exit_rcu+0x97/0xa0
 [749620.110732] common_interrupt+0x7f/0xa0
 [749620.118595]  </IRQ>
 [749620.122964] asm_common_interrupt+0x1e/0x40
 [749620.131511] RIP: cpuidle_enter_state+0xc2/0x340
 [749620.141621] Code: 48 89 c5 0f 1f 44 00 00 31 ff e8 f9 8d 73 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 38 02 00 00 31 ff e8 b2 36 79 ff fb 45 85 f6 <0f> 88 e8 00 00 00 49 63 d6 48 2b 2c 24 48 6b ca 68 48 8d 04 52 48
 All code
 ========
    0:	48 89 c5             	mov    %rax,%rbp
    3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    8:	31 ff                	xor    %edi,%edi
    a:	e8 f9 8d 73 ff       	callq  0xffffffffff738e08
    f:	45 84 ff             	test   %r15b,%r15b
   12:	74 12                	je     0x26
   14:	9c                   	pushfq
   15:	58                   	pop    %rax
   16:	f6 c4 02             	test   $0x2,%ah
   19:	0f 85 38 02 00 00    	jne    0x257
   1f:	31 ff                	xor    %edi,%edi
   21:	e8 b2 36 79 ff       	callq  0xffffffffff7936d8
   26:	fb                   	sti
   27:	45 85 f6             	test   %r14d,%r14d
   2a:*	0f 88 e8 00 00 00    	js     0x118		<-- trapping instruction
   30:	49 63 d6             	movslq %r14d,%rdx
   33:	48 2b 2c 24          	sub    (%rsp),%rbp
   37:	48 6b ca 68          	imul   $0x68,%rdx,%rcx
   3b:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
   3f:	48                   	rex.W
 
 Code starting with the faulting instruction
 ===========================================
    0:	0f 88 e8 00 00 00    	js     0xee
    6:	49 63 d6             	movslq %r14d,%rdx
    9:	48 2b 2c 24          	sub    (%rsp),%rbp
    d:	48 6b ca 68          	imul   $0x68,%rdx,%rcx
   11:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
   15:	48                   	rex.W
 [749620.179375] RSP: 0018:ffffc90000293e90 EFLAGS: 00000202
 [749620.190016] RAX: ffff88903f8eaa80 RBX: ffffe8ffff4c6c00 RCX: 000000000000001f
 [749620.204491] RDX: 0002a9c665c30050 RSI: 000000005ba4b680 RDI: 0000000000000000
 [749620.218949] RBP: 0002a9c665c30050 R08: 0000000000000002 R09: 000000000002a300
 [749620.233403] R10: 00219fc7cf6dd4ca R11: ffff88903f8e9a84 R12: 0000000000000001
 [749620.247854] R13: ffffffff83621200 R14: 0000000000000001 R15: 0000000000000000
 [749620.262315] cpuidle_enter+0x29/0x40
 [749620.269649] do_idle+0x1bb/0x200
 [749620.276296] cpu_startup_entry+0x19/0x20
 [749620.284333] start_secondary+0x104/0x140
 [749620.292364] secondary_startup_64_no_verify+0xb0/0xbb
 [749620.302657] ---[ end trace 44f03a0d3a4e81fd ]---

> Also 5.12 is kind of old :/

Right. Unfortunately this problem is not easily reproducible, and, we
need millions of machines running some specific workload to reproduce
it.


That said, the motivation for this patch is to dump more TCP information
when we get such warnings, so, we have relevant data to understand more
about the issues (when it happens). I.e, this patch is not this problem
above, but, providing more information when we hit such warnings.

That said, this is patch is about creating the
TCP_SOCK_WARN_ON_ONCE() macro, and eventually move some of the
WARN_ON_ONCE() to TCP_SOCK_WARN_ON_ONCE(). (I.e, this is not a patch to solve
the case above.)

Anyway, I got some feedbacks from the patch, let me send a V2 of the
patch, which I expect to clarify the problem better.
