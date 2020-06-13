Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D641F833F
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 14:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgFMMjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 08:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgFMMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 08:39:46 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9608C03E96F;
        Sat, 13 Jun 2020 05:39:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id p20so12696696ejd.13;
        Sat, 13 Jun 2020 05:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rLYdWMneE4TVUY9aSOs8/2TEq8Z2KQLp41INl5IKYh0=;
        b=oORIqEvjVM4ZMLb1sDdiGXA7Dp79k42spmbQA63GyvXfvZvTDlVAByDFp4LdE2FxHN
         kVeBfr19R6eOj8puIaIIWbcExMPl4PB5J7mLTkTgBLM/xM7/FLeyGGDKzDRJt+P7ED1Q
         iOjmyvmo7fLX7wCcdjg7zjSYYy5uzb2xBom6gnYz6l5D/fkB4rOVsZT/woS2Sz9uuvhW
         zC3iksBAL7p4+8HoPHSMWeejQ73LViQPEWUSVrYBPUhcf9noUJUJwEGOPiDARW8QYJnF
         tps/fq1tToMoCQum9vX/L4YMzxZ+scsjZxyNMcQGcUvcwH9lXTgmI0JCWkN5VtNbGKKB
         YYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rLYdWMneE4TVUY9aSOs8/2TEq8Z2KQLp41INl5IKYh0=;
        b=EGh8RgGuNiTNK6jg4bjDAPRhgg4seT6MsGv21HeAcUZ9Fdvv2Zn0FJpugGnYygteNG
         7Ufudl3wQfnr2KYflMJO2esflU73n6XYKB6iWrLdmiie1jivUKDd4YT4AZat3O7eiQV8
         UjRNFRwhixn+fhlRWabHoDqz/O7vQN2jDvRWyjPipIYlAWgrRKLwSE1e66UiUzMW6SCC
         qAs4lIOkOLW7PwNqxQbS5tTUDTNcEuhVMc10E8hijIIxPDbgak1n3oYZjmTnmqPP4cxi
         skQeU1xYXf+8jaTLzcWICP7cf3z6+3crCG00qcbj2hzQVHFuppPCmm1jl6mgpy8pgVqs
         3caA==
X-Gm-Message-State: AOAM530rMfgQ/WE4c1CvVaklWr43oM2Y7tSVbIwtbjWEHm8pWGwHEO6Y
        Oh4C335ySHxy9B0HmYmKf03sJmjwnCka6gd1zak=
X-Google-Smtp-Source: ABdhPJysRCa7yIX8FfZzFbBFY3gZOtUop9G2+iZF0fUZA9B2TXVj7BjV2V8LQigDxv3g85vf4gke44qavwc3cA3YZLA=
X-Received: by 2002:a17:906:ce30:: with SMTP id sd16mr18271989ejb.374.1592051983520;
 Sat, 13 Jun 2020 05:39:43 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Sat, 13 Jun 2020 08:39:32 -0400
Message-ID: <CAMdYzYpKEOWCjb-kZj=HAkzQ0_QNs4N_6pXz1qPb1YQ2Xh5Jsg@mail.gmail.com>
Subject: [Crash] unhandled kernel memory read from unreadable memory
To:     "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Morning,

Last night I started experiencing crashes on my home server.
I updated to 5.6.17 from 5.6.15 a few days ago but I'm not sure if
that is related.
The crash occurred four times between last night and this morning.

[23352.431106] rockpro64 kernel: Unable to handle kernel read from
unreadable memory at virtual address 0000000000000010
[23352.431938] rockpro64 kernel: Mem abort info:
[23352.432199] rockpro64 kernel:   ESR = 0x96000004
[23352.432485] rockpro64 kernel:   EC = 0x25: DABT (current EL), IL = 32 bits
[23352.432965] rockpro64 kernel:   SET = 0, FnV = 0
[23352.433248] rockpro64 kernel:   EA = 0, S1PTW = 0
[23352.433536] rockpro64 kernel: Data abort info:
[23352.433803] rockpro64 kernel:   ISV = 0, ISS = 0x00000004
[23352.434153] rockpro64 kernel:   CM = 0, WnR = 0
[23352.434475] rockpro64 kernel: user pgtable: 4k pages, 48-bit VAs,
pgdp=0000000094d4c000
[23352.435174] rockpro64 kernel: [0000000000000010]
pgd=0000000094f3d003, pud=00000000bdb7f003, pmd=0000000000000000
[23352.435963] rockpro64 kernel: Internal error: Oops: 96000004 [#1] SMP
[23352.436396] rockpro64 kernel: Modules linked in: xt_TCPMSS
nf_conntrack_netlink xfrm_user xt_addrtype br_netfilter ip_set_hash_ip
ip_set_hash_net xt_set ip_set cfg80211 nft_counter xt_length
xt_connmark xt_multiport xt_mark nf_log_ip>
[23352.436519] rockpro64 kernel:  ghash_ce enclosure snd_soc_es8316
scsi_transport_sas snd_seq_midi sha2_ce snd_seq_midi_event
snd_soc_simple_card snd_rawmidi snd_soc_audio_graph_card sha256_arm64
panfrost snd_soc_simple_card_utils sha1>
[23352.444216] rockpro64 kernel:  async_pq async_xor xor xor_neon
async_tx uas raid6_pq raid1 raid0 multipath linear usb_storage
xhci_plat_hcd dwc3 rtc_rk808 clk_rk808 rk808_regulator ulpi udc_core
fusb302 tcpm typec fan53555 rk808 pwm_>
[23352.455532] rockpro64 kernel: CPU: 3 PID: 1237 Comm: nfsd Not
tainted 5.6.17+ #74
[23352.456054] rockpro64 kernel: Hardware name: pine64
rockpro64_rk3399/rockpro64_rk3399, BIOS
2020.07-rc2-00124-g515f613253-dirty 05/19/2020
[23352.457010] rockpro64 kernel: pstate: 60400005 (nZCv daif +PAN -UAO)
[23352.457445] rockpro64 kernel: pc : __cgroup_bpf_run_filter_skb+0x2a8/0x400
[23352.457918] rockpro64 kernel: lr : ip_finish_output+0x98/0xd0
[23352.458287] rockpro64 kernel: sp : ffff80001325b900
[23352.458581] rockpro64 kernel: x29: ffff80001325b900 x28: ffff000012f0fae0
[23352.459051] rockpro64 kernel: x27: 0000000000000001 x26: ffff00005f0ddc00
[23352.459521] rockpro64 kernel: x25: 0000000000000118 x24: ffff0000dcd3c270
[23352.459990] rockpro64 kernel: x23: 0000000000000010 x22: ffff800011b1aec0
[23352.460458] rockpro64 kernel: x21: ffff0000efcacc40 x20: 0000000000000010
[23352.460928] rockpro64 kernel: x19: ffff0000dcd3bf00 x18: 0000000000000000
[23352.461396] rockpro64 kernel: x17: 0000000000000000 x16: 0000000000000000
[23352.461863] rockpro64 kernel: x15: 0000000000000000 x14: 0000000000000004
[23352.462332] rockpro64 kernel: x13: 0000000000000001 x12: 0000000000201400
[23352.462802] rockpro64 kernel: x11: 0000000000000000 x10: 0000000000000000
[23352.463271] rockpro64 kernel: x9 : ffff800010b6f6d0 x8 : 0000000000000260
[23352.463738] rockpro64 kernel: x7 : 0000000000000000 x6 : ffff0000dc12a000
[23352.464208] rockpro64 kernel: x5 : ffff0000dcd3bf00 x4 : 0000000000000028
[23352.464677] rockpro64 kernel: x3 : 0000000000000000 x2 : ffff000012f0fb08
[23352.465145] rockpro64 kernel: x1 : ffff00005f0ddd40 x0 : 0000000000000000
[23352.465616] rockpro64 kernel: Call trace:
[23352.465843] rockpro64 kernel:  __cgroup_bpf_run_filter_skb+0x2a8/0x400
[23352.466283] rockpro64 kernel:  ip_finish_output+0x98/0xd0
[23352.466625] rockpro64 kernel:  ip_output+0xb0/0x130
[23352.466920] rockpro64 kernel:  ip_local_out+0x4c/0x60
[23352.467233] rockpro64 kernel:  __ip_queue_xmit+0x128/0x380
[23352.467584] rockpro64 kernel:  ip_queue_xmit+0x10/0x18
[23352.467903] rockpro64 kernel:  __tcp_transmit_skb+0x470/0xaf0
[23352.468274] rockpro64 kernel:  tcp_write_xmit+0x39c/0x1110
[23352.468623] rockpro64 kernel:  __tcp_push_pending_frames+0x40/0x100
[23352.469040] rockpro64 kernel:  tcp_send_fin+0x6c/0x240
[23352.469358] rockpro64 kernel:  tcp_shutdown+0x60/0x68
[23352.469669] rockpro64 kernel:  inet_shutdown+0xb0/0x120
[23352.469997] rockpro64 kernel:  kernel_sock_shutdown+0x1c/0x28
[23352.470464] rockpro64 kernel:  svc_tcp_sock_detach+0xd0/0x110 [sunrpc]
[23352.470980] rockpro64 kernel:  svc_delete_xprt+0x74/0x240 [sunrpc]
[23352.471445] rockpro64 kernel:  svc_recv+0x45c/0xb10 [sunrpc]
[23352.471864] rockpro64 kernel:  nfsd+0xdc/0x150 [nfsd]
[23352.472179] rockpro64 kernel:  kthread+0xfc/0x128
[23352.472461] rockpro64 kernel:  ret_from_fork+0x10/0x18
[23352.472785] rockpro64 kernel: Code: 9100c0c6 17ffff7b f9431cc0
91004017 (f9400814)
[23352.473324] rockpro64 kernel: ---[ end trace 978df9e144fd1235 ]---
[29973.397069] rockpro64 kernel: Unable to handle kernel read from
unreadable memory at virtual address 0000000000000010
[29973.397966] rockpro64 kernel: Mem abort info:
[29973.398224] rockpro64 kernel:   ESR = 0x96000004
[29973.398503] rockpro64 kernel:   EC = 0x25: DABT (current EL), IL = 32 bits
[29973.398976] rockpro64 kernel:   SET = 0, FnV = 0
[29973.399254] rockpro64 kernel:   EA = 0, S1PTW = 0
[29973.399537] rockpro64 kernel: Data abort info:
[29973.399799] rockpro64 kernel:   ISV = 0, ISS = 0x00000004
[29973.400143] rockpro64 kernel:   CM = 0, WnR = 0
[29973.400416] rockpro64 kernel: user pgtable: 4k pages, 48-bit VAs,
pgdp=00000000dcdd1000
[29973.400989] rockpro64 kernel: [0000000000000010] pgd=0000000000000000
[29973.401490] rockpro64 kernel: Internal error: Oops: 96000004 [#2] SMP
