Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23E16460D3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLGR74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiLGR7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:59:53 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9CE5D69A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:59:51 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3704852322fso194610237b3.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 09:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvQqPZb0HyLKTtihqVOtyF4LFNcuCoZJQcEBfxfdTAU=;
        b=eCU6VlIXSasoscAbFFEqj7RkjyRoy5pojeLH7Jgh6ydvo9IAOBBeMSSnvkzxo1UTgO
         F6IOxpH+mrafQSbeJZRZfDzxhfiAScUPuJjwL0GDHflWAAC8uHxiXL4tZBa8EaOhbpMw
         u4WEOa3M6oYV6RFFCetVdo1+q7T5L8SBh8TBoGLMavAI4/WaHucYBi7ktF4OCywuMWxO
         YaPl2Ie3i4hCBrDWjBNheWilsLL+x9UBk7h9H6q1i36hnC41pQ6jyZzwhAYT5eIihsce
         87MGs1YGbyzpwVa8uXnqZSqZiwi+wF1N5QTDVBu20A4VpP8WKd14FPTI6e24X0lDRfin
         erzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvQqPZb0HyLKTtihqVOtyF4LFNcuCoZJQcEBfxfdTAU=;
        b=hjYtToXdHCh3SvcZcu0f+7lZHGPkDgbkvSCC8BWeRDoEQXOS9lUFDS38J3VF88gQNe
         95ATmflISwmTcEi+2SjLluAhwv8zoOw9gkfDxzp6TYYU9BKWp7y+QbF70BQJNP2r+Kcy
         B0Zt+uBeCblXqM12mlMmdtsblxmhmXOoeUEd6TUTcKzRtKXAlf8qwwtKc3BcWxOqp8u6
         dpKipA6ITPvFGAvHgkEs3V78x7O4ncXRW04anTPzYe0HvmsdAgp/FbIpGCdfRFGX3Yhs
         rjhFCRuAlrWK0MRJnXEtmslzP6x4YMExyyV96gqHz9u++IOJdW9Wrg+pi/HvVJPBlEt5
         +rZA==
X-Gm-Message-State: ANoB5pnvGWUipWvDHiSlwYHhbDhoBD7wq7IHneh+TU1AktRVJKfVuAup
        +W5wHxh0LgxGxZLu01VmrskZn9Wr772bLW1gdZSnOg==
X-Google-Smtp-Source: AA0mqf6jGLt6IljiIZlTFr0jRxs5fXqrdn+/z4fC0vww7kKaIodAWapTPF4xFFvoTYkwLje8H0Fkb+zkDO1nGw32WZU=
X-Received: by 2002:a81:a8a:0:b0:37e:6806:a5f9 with SMTP id
 132-20020a810a8a000000b0037e6806a5f9mr7018502ywk.47.1670435990183; Wed, 07
 Dec 2022 09:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20220831133758.3741187-1-leitao@debian.org> <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
 <Y5DPU3p+N7rBW+QY@gmail.com>
In-Reply-To: <Y5DPU3p+N7rBW+QY@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 18:59:38 +0100
Message-ID: <CANn89iKia8PVz8QrtukzA-9wUiJHiOB1r6d04xuL_YHqHaBULw@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 6:37 PM Breno Leitao <leitao@debian.org> wrote:
>
> On Sat, Sep 03, 2022 at 09:42:43AM -0700, Eric Dumazet wrote:
> > On Wed, Aug 31, 2022 at 6:38 AM Breno Leitao <leitao@debian.org> wrote:
> > >
> > > There are cases where we need information about the socket during a
> > > warning, so, it could help us to find bugs that happens that do not h=
ave
> > > a easily repro.
> > >
> > > BPF congestion control algorithms can change socket state in unexpect=
ed
> > > ways, leading to WARNings. Additional information about the socket st=
ate
> > > is useful to identify the culprit.
> >
> > Well, this suggests we need to fix BPF side ?
> >
> > Not sure how this can happen, because TCP_BPF_IW has
> >
> > if (val <=3D 0 || tp->data_segs_out > tp->syn_data)
> >      ret =3D -EINVAL;
> > else
> >     tcp_snd_cwnd_set(tp, val);
>
> I am not sure we are hitting this path, please check the stack below
>
> > It seems you already found the issue in an eBPF CC, can you share the d=
etails ?
>
> Sure, here is an example of what we are facing (with some obfuscation).
> Remeber that there are users' BPF application running:
>
> [155375.750105] ------------[ cut here ]------------
> [155375.759526] WARNING: CPU: 19 PID: 0 at net/ipv4/tcp.c:4552 tcp_sock_w=
arn+0x6/0x20
> [155375.774700] Modules linked in: vhost_net tun vhost vhost_iotlb tap vi=
rtio_net net_failover failover mpls_gso mpls_iptunnel mpls_router ip_tunnel=
 fou ip6_udp_tunnel udp_tunnel sch_fq sunrpc bpf_preload tls act_gact cls_b=
pf tcp_diag inet_diag skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_po=
werclamp coretemp iTCO_wdt kvm_intel iTCO_vendor_support kvm evdev ses irqb=
ypass enclosure i2c_i801 i2c_smbus ipmi_si ipmi_devintf ipmi_msghandler acp=
i_cpufreq button tpm_crb sch_fq_codel fuse sg nvme mpi3mr scsi_transport_sa=
s nvme_core xhci_pci xhci_hcd loop efivarfs autofs4
> [155375.874916] CPU: 19 PID: 0 Comm: swapper/19 Kdump: loaded Tainted: G =
S                5.12.0-0_XXXXXXXX_g0fed6f189e14 #1
> [155375.898770] Hardware name: XXXX XXX XXXX XXXXX, BIOS BS_BIOS_XXX XX/X=
X/2022
> [155375.916015] RIP: 0010:tcp_sock_warn+0x6/0x20
> [155375.924755] Code: 4d 01 3e 85 c0 0f 84 57 ff ff ff 48 8b 0c 24 44 8b =
01 eb 82 e8 eb b7 14 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 =
<0f> 0b 48 85 ff 0f 85 77 70 14 00 5b c3 66 66 2e 0f 1f 84 00 00 00
> [155375.962518] RSP: 0018:ffffc90000d08988 EFLAGS: 00010246
> [155375.973157] RAX: ffff88817432b5c0 RBX: ffff88828f748000 RCX: ffffc900=
00d08a34
> [155375.987614] RDX: 0000000000000000 RSI: 00000000822be8c8 RDI: ffff8882=
8f748000
> [155376.002074] RBP: 0000000000000040 R08: ffffc90000d08a38 R09: 00000000=
822be334
> [155376.016531] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000=
00000000
> [155376.030988] R13: ffffc90000d08a34 R14: 0000000000005546 R15: 00000000=
00000000
> [155376.045441] FS:  0000000000000000(0000) GS:ffff88903f8c0000(0000) knl=
GS:0000000000000000
> [155376.061804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [155376.073474] CR2: 00007fe407603080 CR3: 0000000b19993006 CR4: 00000000=
007706e0
> [155376.087928] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
> [155376.102383] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
> [155376.116841] PKRU: 55555554
> [155376.122427] Call Trace:
> [155376.127497]  <IRQ>
> [155376.131697]  tcp_fastretrans_alert+0x988/0x9e0
> [155376.140774]  tcp_ack+0x8b4/0x1360
> [155376.147581]  ? __cgroup_bpf_run_filter_skb+0x185/0x440
> [155376.158037]  tcp_rcv_established+0x135/0x660
> [155376.166755]  ? sk_filter_trim_cap+0xbc/0x220
> [155376.175472]  tcp_v6_do_rcv+0xbe/0x3e0
> [155376.182974]  tcp_v6_rcv+0xc01/0xc90
> [155376.190128]  ip6_protocol_deliver_rcu+0xbd/0x450
> [155376.199541]  ip6_input_finish+0x3d/0x60
> [155376.207388]  ip6_input+0xb5/0xc0
> [155376.214019]  ip6_sublist_rcv_finish+0x37/0x50
> [155376.222912]  ip6_sublist_rcv+0x1dd/0x270
> [155376.230935]  ipv6_list_rcv+0x113/0x140
> [155376.238618]  __netif_receive_skb_list_core+0x1a0/0x210
> [155376.249080]  netif_receive_skb_list_internal+0x186/0x2a0
> [155376.259887]  gro_normal_list.part.171+0x19/0x40
> [155376.269137]  napi_complete_done+0x65/0x150
> [155376.277514]  bnxt_poll_p5+0x25b/0x2b0
> [155376.285027]  ? tcp_write_xmit+0x278/0x1060
> [155376.293398]  __napi_poll+0x25/0x120
> [155376.300552]  net_rx_action+0x189/0x300
> [155376.308227]  __do_softirq+0xbb/0x271
> [155376.315554]  irq_exit_rcu+0x97/0xa0
> [155376.322710]  common_interrupt+0x7f/0xa0
> [155376.330566]  </IRQ>
> [155376.334947]  asm_common_interrupt+0x1e/0x40
> [155376.343499] RIP: 0010:cpuidle_enter_state+0xc2/0x340
> [155376.353619] Code: 48 89 c5 0f 1f 44 00 00 31 ff e8 f9 8d 73 ff 45 84 =
ff 74 12 9c 58 f6 c4 02 0f 85 38 02 00 00 31 ff e8 b2 36 79 ff fb 45 85 f6 =
<0f> 88 e8 00 00 00 49 63 d6 48 2b 2c 24 48 6b ca 68 48 8d 04 52 48
> [155376.391367] RSP: 0018:ffffc90000293e90 EFLAGS: 00000202
> [155376.402004] RAX: ffff88903f8eaa80 RBX: ffffe8ffff4c6c00 RCX: 00000000=
0000001f
> [155376.416456] RDX: 00008d503c63f228 RSI: 000000005ba4b680 RDI: 00000000=
00000000
> [155376.430910] RBP: 00008d503c63f228 R08: 0000000000000002 R09: 00000000=
0002a300
> [155376.445372] R10: 002435b781e62f4a R11: ffff88903f8e9a84 R12: 00000000=
00000001
> [155376.459832] R13: ffffffff83621200 R14: 0000000000000001 R15: 00000000=
00000000
> [155376.474307]  cpuidle_enter+0x29/0x40
> [155376.481654]  do_idle+0x1bb/0x200
> [155376.488297]  cpu_startup_entry+0x19/0x20
> [155376.496320]  start_secondary+0x104/0x140
> [155376.504342]  secondary_startup_64_no_verify+0xb0/0xbb
> [155376.514629] ---[ end trace 9b428a0d7901c3ff ]---
> [155376.524041] TCP: Socket Info: family=3D10 state=3D1 sport=3D12345 dpo=
rt=3D57616 ccname=3Dned_tcp_dctcp01 cwnd=3D1
> [155376.524045] TCP: saddr=3DXXXX:XXXX:XXXX:XXXX:XXXX:0000:00c8:0000 dadd=
r=3DXXXX:XXXX:XXXX:XXXX:XXXX:0000:0288:00

Try to give us symbols with scripts/decode_stacktrace.sh , thanks.

Also 5.12 is kind of old :/
