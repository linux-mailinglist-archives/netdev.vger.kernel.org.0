Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0214F647F66
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLIIjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiLIIjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:39:32 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51C760B7D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:39:26 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id j206so4714794ybj.1
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 00:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GUGGQj15T3qQbeVLgcJB6xrxEome6rwG6hErs3Zjdo=;
        b=gPKoRHvGy0jNW39RFKcBp3/yl4sbAEA5JVQ34R7dkBBH4C298sE+yDKuwDMlxibY/c
         w344BunK6p0wUSdW2cjsybO9SiTE8QjHv8Q64Eo4C7LL+EZTmTZDnyOJYfS4UEfnNrUw
         PaCdW5X/0UmlKP5aiu72NpuSFB0bwAxdWBleJFbbGZz8jkXSqDXpMKXl81qfy7ASP/1F
         ik/l+kAJSpzjqVlH22DpJGE5UIL/GV6WjuOKs08i3crS2Bz+X20oOlKhJO9PSJ0HnRY4
         zG3JNXqRRXteVsMJv3NPZ2H4INGOpsjDXzHqVD0SKeQKzryL6MiSIhVp+c14yEr6+1ln
         9IJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GUGGQj15T3qQbeVLgcJB6xrxEome6rwG6hErs3Zjdo=;
        b=6YqqrtrLdaQJa9zAxxNmM+peS/sa5bkMZmp3MSS2PYYXSyMVRZAU16woy5cmRbWMNW
         oIThjZOqcNXJAR3gYhUYjyvH5kFQzNjPIIvEseldTWV4VQNFNPoBdbXFq1DmYQZKFVWK
         TxZGeyo4DCuORF+YfrZ1PESQDWFC3PVUiLB6D5btj7qjelb7ULAyRjEYCrtbFX7Sn/2v
         j0+8YFX31Arpsha5Dwmuz7uaQKeWqzWn5+ntxTgi+6K1Nq2EihcCmHYwn+BQZRNes7/l
         xJB+O3P6N/vK8iINXMPMnAkeqpwsuBKhPWK1XtDb8VUCRzM/rvy3S/xEjsNRzVi6BjCj
         61ZQ==
X-Gm-Message-State: ANoB5pmCINNf5Aqxn9CoF1bgVuzhJjUni8fqe2X+DuOb9XFsnw2KYJDN
        XmPiKDZnVjIwOhp1ekHRO9YpXCctH+OFAzJJNhgH2Q==
X-Google-Smtp-Source: AA0mqf7ZACKRjj1D0rcTNVVA25tu2DwTXeoSYJ3oO9D76DQARIgzERW6rrlYRiXtf/QusZjCu2X2dO1d9FIDFhTgAEs=
X-Received: by 2002:a25:941:0:b0:706:bafd:6f95 with SMTP id
 u1-20020a250941000000b00706bafd6f95mr9109558ybm.55.1670575165654; Fri, 09 Dec
 2022 00:39:25 -0800 (PST)
MIME-Version: 1.0
References: <20220831133758.3741187-1-leitao@debian.org> <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
 <Y5DPU3p+N7rBW+QY@gmail.com> <CANn89iKia8PVz8QrtukzA-9wUiJHiOB1r6d04xuL_YHqHaBULw@mail.gmail.com>
 <Y5IGa0pauk+YkSSv@gmail.com>
In-Reply-To: <Y5IGa0pauk+YkSSv@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Dec 2022 09:39:14 +0100
Message-ID: <CANn89iK8BtCDXsH=fwnUg8fzP_tDB-=wmezkc-dCCVpp-FqzxA@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of WARN_ON_ONCE()
To:     Breno Leitao <leitao@debian.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, leit@fb.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 8, 2022 at 4:44 PM Breno Leitao <leitao@debian.org> wrote:
>
> On Wed, Dec 07, 2022 at 06:59:38PM +0100, Eric Dumazet wrote:

> > Try to give us symbols with scripts/decode_stacktrace.sh , thanks.
>
> Sorry, here it is:
>
>  [749619.538804] WARNING: CPU: 19 PID: 0 at net/ipv4/tcp.c:4552 tcp_sock_=
warn+0x6/0x20
>  [749619.553969] Modules linked in: sch_fq sunrpc bpf_preload tls act_gac=
t cls_bpf tcp_diag inet_diag skx_edac nfit libnvdimm x86_pkg_temp_thermal i=
ntel_powerclamp coretemp kvm_intel iTCO_wdt iTCO_vendor_support kvm evdev s=
es irqbypass enclosure i2c_i801 i2c_smbus ipmi_si ipmi_devintf ipmi_msghand=
ler acpi_cpufreq button tpm_crb sch_fq_codel vhost_net tun tap vhost vhost_=
iotlb virtio_net net_failover failover mpls_gso mpls_iptunnel mpls_router i=
p_tunnel fou ip6_udp_tunnel udp_tunnel fuse sg nvme mpi3mr scsi_transport_s=
as nvme_core xhci_pci xhci_hcd loop efivarfs autofs4
>  [749619.678066] Hardware name: XXXXX
>  [749619.695308] RIP: tcp_sock_warn+0x6/0x20
>  [749619.704034] Code: 4d 01 3e 85 c0 0f 84 57 ff ff ff 48 8b 0c 24 44 8b=
 01 eb 82 e8 eb b7 14 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53=
 <0f> 0b 48 85 ff 0f 85 77 70 14 00 5b c3 66 66 2e 0f 1f 84 00 00 00
>  All code
>  =3D=3D=3D=3D=3D=3D=3D=3D
>     0:  4d 01 3e                add    %r15,(%r14)
>     3:  85 c0                   test   %eax,%eax
>     5:  0f 84 57 ff ff ff       je     0xffffffffffffff62
>     b:  48 8b 0c 24             mov    (%rsp),%rcx
>     f:  44 8b 01                mov    (%rcx),%r8d
>    12:  eb 82                   jmp    0xffffffffffffff96
>    14:  e8 eb b7 14 00          callq  0x14b804
>    19:  66 66 2e 0f 1f 84 00    data16 nopw %cs:0x0(%rax,%rax,1)
>    20:  00 00 00 00
>    24:  0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>    29:  53                      push   %rbx
>    2a:* 0f 0b                   ud2             <-- trapping instruction
>    2c:  48 85 ff                test   %rdi,%rdi
>    2f:  0f 85 77 70 14 00       jne    0x1470ac
>    35:  5b                      pop    %rbx
>    36:  c3                      retq
>    37:  66                      data16
>    38:  66                      data16
>    39:  2e                      cs
>    3a:  0f                      .byte 0xf
>    3b:  1f                      (bad)
>    3c:  84 00                   test   %al,(%rax)
>         ...
>
>  Code starting with the faulting instruction
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     0:  0f 0b                   ud2
>     2:  48 85 ff                test   %rdi,%rdi
>     5:  0f 85 77 70 14 00       jne    0x147082
>     b:  5b                      pop    %rbx
>     c:  c3                      retq
>     d:  66                      data16
>     e:  66                      data16
>     f:  2e                      cs
>    10:  0f                      .byte 0xf
>    11:  1f                      (bad)
>    12:  84 00                   test   %al,(%rax)
>         ...
>  [749619.741779] RSP: 0018:ffffc90000d08988 EFLAGS: 00010246
>  [749619.752436] RAX: ffff88814b57f5c0 RBX: ffff8881bd2540c0 RCX: ffffc90=
000d08a34
>  [749619.766900] RDX: 0000000000000000 RSI: 00000000cda8f4af RDI: ffff888=
1bd2540c0
>  [749619.781364] RBP: 0000000000000000 R08: ffffc90000d08a38 R09: 0000000=
0cda8f44f
>  [749619.795831] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000=
000000000
>  [749619.810300] R13: ffffc90000d08a34 R14: 0000000000011406 R15: 0000000=
000000000
>  [749619.824788] FS:  0000000000000000(0000) GS:ffff88903f8c0000(0000) kn=
lGS:0000000000000000
>  [749619.841168] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [749619.852857] CR2: 000000000007c2e9 CR3: 0000000b82412002 CR4: 0000000=
0007706e0
>  [749619.867331] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
>  [749619.881800] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
>  [749619.896260] PKRU: 55555554
>  [749619.901859] Call Trace:
>  [749619.906927]  <IRQ>
>  [749619.911129] tcp_fastretrans_alert+0x988/0x9e0
>  [749619.920222] ? kmem_cache_free+0x33c/0x3d0
>  [749619.928606] tcp_ack+0x8b4/0x1360
>  [749619.935425] ? __cgroup_bpf_run_filter_skb+0x185/0x440
>  [749619.945910] tcp_rcv_established+0x2f3/0x660
>  [749619.954639] ? sk_filter_trim_cap+0xbc/0x220
>  [749619.963358] tcp_v6_do_rcv+0xbe/0x3e0
>  [749619.970863] tcp_v6_rcv+0xc01/0xc90

Still no symbols (file name : line number).

>  [749619.978029] ip6_protocol_deliver_rcu+0xbd/0x450
>  [749619.987453] ip6_input_finish+0x3d/0x60
>  [749619.995313] ip6_input+0xb5/0xc0
>  [749620.001958] ip6_sublist_rcv_finish+0x37/0x50
>  [749620.010851] ip6_sublist_rcv+0x1dd/0x270
>  [749620.018877] ipv6_list_rcv+0x113/0x140
>  [749620.026552] __netif_receive_skb_list_core+0x1a0/0x210
>  [749620.037025] netif_receive_skb_list_internal+0x186/0x2a0
>  [749620.047838] ? napi_gro_complete+0x6c/0xd0
>  [749620.056215] gro_normal_list.part.171+0x19/0x40
>  [749620.065471] napi_complete_done+0x65/0x150
>  [749620.073856] bnxt_poll_p5+0x25b/0x2b0
>  [749620.081369] __napi_poll+0x25/0x120
>  [749620.088537] net_rx_action+0x189/0x300
>  [749620.096224] __do_softirq+0xbb/0x271
>  [749620.103571] irq_exit_rcu+0x97/0xa0
>  [749620.110732] common_interrupt+0x7f/0xa0
>  [749620.118595]  </IRQ>
>  [749620.122964] asm_common_interrupt+0x1e/0x40
>  [749620.131511] RIP: cpuidle_enter_state+0xc2/0x340
>  [749620.141621] Code: 48 89 c5 0f 1f 44 00 00 31 ff e8 f9 8d 73 ff 45 84=
 ff 74 12 9c 58 f6 c4 02 0f 85 38 02 00 00 31 ff e8 b2 36 79 ff fb 45 85 f6=
 <0f> 88 e8 00 00 00 49 63 d6 48 2b 2c 24 48 6b ca 68 48 8d 04 52 48
