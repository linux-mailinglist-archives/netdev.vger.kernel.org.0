Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B3434C96
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfFDPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:49:20 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33139 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfFDPtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:49:17 -0400
Received: by mail-lj1-f194.google.com with SMTP id v29so8905130ljv.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 08:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nHNUhyyhYgUDTnhIgl8sUKgANmsUTVdE1Nd/zOsazY0=;
        b=DUwBhqcw0BolsLiqlOoJTLn4eb7CUMHRkHVO4QY/D6+Y8sXaau96RQ3PEdHXHmAdJs
         OOCz4gvbMt61zmKeTBIZkfU/Cfw1Gt3PSkshWgqLuLW8GgaSRs8JiXJfPJKeDYDZAfvT
         B7piEbWvRTOQzC7EiJHUgZlVJm9sorc8YXXIFNJrQLU81e+F7rXjoSJMyb1OXFdkFl75
         dW41DoxjfMNAkDtEbGqlKKTR9X/yFWOR0T23OA3F3+/RR5qhoR4xNMrkKcUUz2dTMQ95
         VjQvVIPKswqlGYUULKWLcZ0B+UrG/PWh0zlsn2rvD9DzMQp2MohfT0CktCqOQofhbiyL
         WiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nHNUhyyhYgUDTnhIgl8sUKgANmsUTVdE1Nd/zOsazY0=;
        b=oqmMDW0yRTopRxNQk9G+49oZlR+AbOv7bDikGI8HJm6xWGOO0BVFzQLzhYbQkqLGLE
         00xJM8jCThyIC7Y2XcmV06/bLFksmYOB/gk7RvoFciZdO0s+HU3jUXAydwOq60Yc1HZj
         O8jP/fMXl4i6kiwStXfc4MEBjqDsUoNe5ul2ouVGyqu7g1uHBklHenNGLVDQc50EJnZy
         VV4dTJttqcseC9mxncQvgWnb5pexfGO5HrOrFb7bTz49W9bsytgvQbs9fvIFGENWE2KG
         r+sxZwJnOkVsKkpBzDMKpHVjNJBT72GEPKkTyMvUDfLzOYinAknko9iwia9fTUTtO1sU
         bcIA==
X-Gm-Message-State: APjAAAWEU8mLO1QQ7aCVTh6PD7P04z4chvZGbLr8GWo8Z72+mI3VQv23
        Hv01gKxPKh2lKtK/VwrRT+o23impxovNkLVhXjPcMPFzbs0=
X-Google-Smtp-Source: APXvYqz/6DBwAEgL3eDu2dDyrmiEnM6gDjdIKBpLH8c0rcyaudJRj7/VbD+M7XCpKnhgKm1J4WWZeD5Xr0b6gT6xpC4=
X-Received: by 2002:a2e:90d1:: with SMTP id o17mr17599943ljg.187.1559663354159;
 Tue, 04 Jun 2019 08:49:14 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Jun 2019 21:19:03 +0530
Message-ID: <CA+G9fYt9kmOez73UUwT_iWKN8j+j7eD=GQX1-qrUnnYGqPuNpw@mail.gmail.com>
Subject: bpf: test_btf : kernel Oops: 207 : PC is at memcpy+0xc0/0x330
To:     Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Yonghong Song <yhs@fb.com>, alan.maguire@oracle.com,
        alexei.starovoitov@gmail.com
Cc:     lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

while running kernel selftest bpf: test_btf the following kernel oops
detected on beaglebone x15 board.
Linux version 5.2.0-rc3-next-20190604

Full test log link can be found below [1]

bpf: test_btf_ #

# BTF GET_INFO test[3] (Large bpf_btf_info) OK
GET_INFO: test[3]_(Large #
# BTF GET_INFO test[4] (BTF ID) OK
GET_INFO: test[4]_(BTF #
[  341.144885] 8<--- cut here ---
[  341.148164] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[  341.156443] pgd = b0902156
[  341.159294] [00000000] *pgd=9655e003, *pmd=ff918003
[  341.164229] Internal error: Oops: 207 [#1] SMP ARM
[  341.169052] Modules linked in: tun sha1_generic sha1_arm_neon
sha1_arm algif_hash af_alg snd_soc_simple_card
snd_soc_simple_card_utils snd_soc_core ac97_bus snd_pcm_dmaengine
snd_pcm snd_timer snd soundcore fuse
[  341.187962] CPU: 0 PID: 6773 Comm: test_sockmap Not tainted
5.2.0-rc3-next-20190604 #1
[  341.195923] Hardware name: Generic DRA74X (Flattened Device Tree)
[  341.202058] PC is at memcpy+0xc0/0x330
[  341.205836] LR is at bpf_msg_push_data+0x70c/0x728
[  341.210654] pc : [<c12da820>]    lr : [<c10ea4a4>]    psr: 800b0013
[  341.216957] sp : e99ad6cc  ip : 00000002  fp : e99ad83c
[  341.222212] r10: d1bdc000  r9 : 00000001  r8 : 00000000
[  341.227467] r7 : cd1de000  r6 : 00000000  r5 : d1bdc000  r4 : 00000000
[  341.234032] r3 : 00000000  r2 : 80000000  r1 : 00000000  r0 : cd1de000
[  341.240597] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  341.247771] Control: 30c5387d  Table: 91b19880  DAC: fffffffd
[  341.253553] Process test_sockmap (pid: 6773, stack limit = 0x3ad4028c)
[  341.260118] Stack: (0xe99ad6cc to 0xe99ae000)
[  341.264502] d6c0:                            cd1de000 00000000
c10ea4a4 00000000 00000000
[  341.272725] d6e0: 00000000 00000000 00000000 00000000 00000000
00000000 ea2759a0 00000001
[  341.280948] d700: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.289171] d720: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.297394] d740: 00000000 00000000 00000000 00000000 00000000
00000000 e99ad78c d03f0580
[  341.305615] d760: 00000004 d03f0000 00000007 000003a9 00000000
00000000 00000000 00000000
[  341.313836] d780: 00000000 00000000 00000000 00000000 d03f0000
c0581f6c 00000060 c1e09fd0
[  341.322060] d7a0: e99ad85c e99ad7b0 c04c1d1c 00000000 c06c3638
c1dc19b8 e99ad7ec d03f0540
[  341.330283] d7c0: 00000002 d03f0000 00000007 000003a9 00000001
d03f0560 d03f0000 e3444ce4
[  341.338506] d7e0: 00000060 c1e09fd0 e99ad8a4 e99ad7f8 cbc66e00
e99ad8a8 c1419868 c059b69c
[  341.346730] d800: 00000000 00000000 e99ad824 e99ad818 c04e3b7c
f006b240 e99ad8b8 c1419868
[  341.354954] d820: c10e9d98 00000000 00000000 c0581ddc e99ad894
e99ad840 c0581f6c c10e9da4
[  341.363175] d840: 00000000 00000000 00000000 00000000 00000000
00000000 f5388145 290412b8
[  341.371399] d860: c2432908 00000000 f08d7937 c1e08488 f006b028
00000011 c11cd828 f006b000
[  341.379620] d880: e99ad9e4 c1fc9e37 e99ad934 e99ad898 c0584910
c0581e48 00000000 00000000
[  341.387841] d8a0: 00000005 00000004 00000003 00000002 00000001
00000000 cbc66ee8 00000000
[  341.396063] d8c0: d1bdc000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.404286] d8e0: 00000000 00000000 d1bdc000 00000000 cbc66ee0
00000000 00000007 00000006
[  341.412509] d900: 00000010 c1fc9e37 e99ad8b8 00000000 cf380840
c10fdef4 c11cd828 9fdbe7c7
[  341.420732] d920: d1bdc000 d1bdc000 e99ad984 e99ad938 c10fdf18
c05848d0 00000000 00000000
[  341.428954] d940: c10fde14 c0459978 e99ad97c e99ad958 c056165c
e7bdd400 000001ff d1bdc000
[  341.437178] d960: e7bdd400 00000011 cf380840 00000000 e99ad9e4
c1fc9e37 e99ad9cc e99ad988
[  341.445407] d980: c11cd828 c10fde20 c11cda3c 00000000 00000000
e99ad9a0 00000000 00000000
[  341.453631] d9a0: 00000001 e7bdd400 cf380840 eb6d1030 c1e08488
00000000 00000003 c1fc9e37
[  341.461855] d9c0: e99adcac e99ad9d0 c11cdb60 c11cd518 00000000
00000000 c11cd90c e8577024
[  341.470078] d9e0: 00000020 00000001 00000000 00000000 00000001
00000001 00000000 00000001
[  341.478300] da00: 00000000 00000000 00000000 00000000 eb6d1030
00000000 00000001 00000000
[  341.486522] da20: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.494742] da40: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.502965] da60: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.511184] da80: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  341.519406] daa0: 00000000 00000000 00000000 00000000 00000000
00000087 00000001 d03f0500
[  341.527628] dac0: d03f0000 c1e47f04 00000000 c1e09fd0 e99adb8c
e99adae0 c04c1d1c c04c10d0
[  341.535850] dae0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000078
[  341.544074] db00: d03f04f0 00000087 00000000 00000000 c2432908
c2638640 00000087 d03f0500
[  341.552296] db20: c1e08488 c2418b30 406293ec 295bca2f 00000000
00000000 00000000 00000000
[  341.560517] db40: 00000000 00000000 d03f04f0 00000078 e99adb84
e99adb60 c040e488 00000087
[  341.568741] db60: 00000001 d03f0500 d03f0000 c1e47f04 00000000
c1e09fd0 e99adc34 e99adb88
[  341.576961] db80: c04c1d1c c04c10d0 ffffe000 c1fcaf30 c069cddc
c1e47f04 e99adbbc e99adba8
[  341.585182] dba0: c04c19e0 c04c1864 d03f04f0 00000087 00000000
00000000 c2432908 c2638640
[  341.593405] dbc0: 00000087 d03f0500 c1e08488 c2418b30 406293ec
295bca2f e99adc24 e99adbe8
[  341.601628] dbe0: c04fe13c c05615d4 00000001 00000000 c069cddc
e99adc54 e99adc2c e99adc08
[  341.609851] dc00: c040e488 c040ce94 c1e08488 00000000 ffffe000
c1fcaf30 c069cddc c1e47f04
[  341.618073] dc20: e99adc64 e99adc30 d03f0000 c04fe13c ffffe000
c1fcaf30 c069cddc c1e47f04
[  341.626294] dc40: e99adc64 e99adc50 c04c19e0 c04c1864 c1dc1000
c04fe13c e99adc8c e99adc68
[  341.634517] dc60: c056165c c04c18d8 c1e47e40 400b0013 00000001
e99adce0 c069cddc 9fdbe7c7
[  341.642738] dc80: e99adccc cf380840 c11cd90c e776d400 eb6d1030
00000010 00000001 c1938660
[  341.650959] dca0: e99adcf4 e99adcb0 c119c98c c11cd918 00000000
e3444a98 e99add14 e99adcd0
[  341.659180] dcc0: c069ce08 c069cd10 5cf61726 c119c908 c10933a0
00000000 00000000 c06b7624
[  341.667403] dce0: 00000001 c1938660 e99add14 e99adcf8 c1093390
c119c914 00000000 e3444a98
[  341.675624] dd00: e7cd5110 c1e08488 e99add2c e99add18 c10933d8
c1093368 00000000 0000026d
[  341.683846] dd20: e99add64 e99add30 c06b7694 c10933ac e99add38
00000000 00000000 00000000
[  341.692067] dd40: c1e08488 9fdbe7c7 e7bdc800 e99adda0 d3b2fcc0
00000018 e99add9c e99add68
[  341.700289] dd60: c06b8a04 c06b7630 e99ade60 00000000 00000000
c1e08488 d3b2fcc0 c06b7624
[  341.708510] dd80: e68598c0 00000000 00000001 e99adf20 e99addfc
e99adda0 c06b9214 c06b897c
[  341.716731] dda0: 00000001 00000001 00000000 e68598c0 00000000
00000000 00000000 00000000
[  341.724953] ddc0: 00000000 00000000 00000000 9fdbe7c7 00000000
c06b9240 e99adea0 00000001
[  341.733176] dde0: 00000000 00000010 00000000 00000001 e99ade14
e99ade00 c06b9270 c06b91a4
[  341.741398] de00: 00000000 c06b7624 e99ade34 e99ade18 c06b761c
c06b924c 00000000 e99adea0
[  341.749621] de20: 00000001 d3b2fcc0 e99ade9c e99ade38 c06b7ff0
c06b75dc 00000000 c067a2dc
[  341.757842] de40: 00000001 c1e08488 00000000 c06b75d0 00000000
e9949a00 00000010 00000000
[  341.766065] de60: 00000011 00000000 e99adf1c 9fdbe7c7 00020000
c1e08488 e99adf18 00000010
[  341.774285] de80: 00000000 e9949a00 e99adf20 e68598c0 e99adef4
e99adea0 c06b8238 c06b7edc
[  341.782507] dea0: 00000001 00000001 00000000 e68598c0 00000010
00000000 e99adf20 00000000
[  341.790729] dec0: 00000000 00000000 d03f0000 9fdbe7c7 c1e08488
c1e08488 e9949a00 fffff000
[  341.798952] dee0: 00000fff 00000001 e99adf5c e99adef8 c067ac74
c06b8198 00000001 00000000
[  341.807174] df00: e776d420 00000000 00000000 00000000 e68598c0
e9949a00 00000010 00000000
[  341.815397] df20: 00000000 00000000 c1e08488 9fdbe7c7 00000001
c1e08488 00000001 00000000
[  341.823618] df40: 00000000 c04011c4 0000001e 00000001 e99adfa4
e99adf60 c067c2a4 c067aaa4
[  341.831841] df60: fffff000 00000fff e99adfac e99adf78 c1dc1000
9fdbe7c7 e99adfac bef7ca44
[  341.840063] df80: 00000001 00000200 000000bb c04011c4 e99ac000
000000bb 00000000 e99adfa8
[  341.848285] dfa0: c0401000 c067c1b8 bef7ca44 00000001 0000001a
0000001e 00000000 00000001
[  341.856508] dfc0: bef7ca44 00000001 00000200 000000bb 00000001
0000001e 0000001a 00000010
[  341.864729] dfe0: 00045034 bef7c884 000137c0 b6e76d7c 200b0010
0000001a 00000000 00000000
[  341.872948] Backtrace:
[  341.875425] [<c10e9d98>] (bpf_msg_push_data) from [<c0581f6c>]
(___bpf_prog_run+0x130/0x1bbc)
[  341.883999]  r10:c0581ddc r9:00000000 r8:00000000 r7:c10e9d98
r6:c1419868 r5:e99ad8b8
[  341.891869]  r4:f006b240
[  341.894426] [<c0581e3c>] (___bpf_prog_run) from [<c0584910>]
(__bpf_prog_run32+0x4c/0x68)
[  341.902649]  r10:c1fc9e37 r9:e99ad9e4 r8:f006b000 r7:c11cd828
r6:00000011 r5:f006b028
[  341.910520]  r4:c1e08488
[  341.913079] [<c05848c4>] (__bpf_prog_run32) from [<c10fdf18>]
(sk_psock_msg_verdict+0x104/0x354)
[  341.921909]  r4:d1bdc000
[  341.924470] [<c10fde14>] (sk_psock_msg_verdict) from [<c11cd828>]
(tcp_bpf_send_verdict+0x31c/0x400)
[  341.933654]  r10:c1fc9e37 r9:e99ad9e4 r8:00000000 r7:cf380840
r6:00000011 r5:e7bdd400
[  341.941524]  r4:d1bdc000
[  341.944083] [<c11cd50c>] (tcp_bpf_send_verdict) from [<c11cdb60>]
(tcp_bpf_sendpage+0x254/0x3c4)
[  341.952914]  r10:c1fc9e37 r9:00000003 r8:00000000 r7:c1e08488
r6:eb6d1030 r5:cf380840
[  341.960784]  r4:e7bdd400
[  341.963343] [<c11cd90c>] (tcp_bpf_sendpage) from [<c119c98c>]
(inet_sendpage+0x84/0x294)
[  341.971480]  r10:c1938660 r9:00000001 r8:00000010 r7:eb6d1030
r6:e776d400 r5:c11cd90c
[  341.979350]  r4:cf380840
[  341.981906] [<c119c908>] (inet_sendpage) from [<c1093390>]
(kernel_sendpage+0x34/0x44)
[  341.989868]  r10:c1938660 r9:00000001 r8:c06b7624 r7:00000000
r6:00000000 r5:c10933a0
[  341.997738]  r4:c119c908
[  342.000290] [<c109335c>] (kernel_sendpage) from [<c10933d8>]
(sock_sendpage+0x38/0x40)
[  342.008248]  r4:c1e08488
[  342.010805] [<c10933a0>] (sock_sendpage) from [<c06b7694>]
(pipe_to_sendpage+0x70/0xa4)
[  342.018856] [<c06b7624>] (pipe_to_sendpage) from [<c06b8a04>]
(__splice_from_pipe+0x94/0x1cc)
[  342.027424]  r7:00000018 r6:d3b2fcc0 r5:e99adda0 r4:e7bdc800
[  342.033122] [<c06b8970>] (__splice_from_pipe) from [<c06b9214>]
(splice_from_pipe+0x7c/0xa8)
[  342.041605]  r10:e99adf20 r9:00000001 r8:00000000 r7:e68598c0
r6:c06b7624 r5:d3b2fcc0
[  342.049475]  r4:c1e08488
[  342.052032] [<c06b9198>] (splice_from_pipe) from [<c06b9270>]
(generic_splice_sendpage+0x30/0x38)
[  342.060953]  r10:00000001 r9:00000000 r8:00000010 r7:00000000
r6:00000001 r5:e99adea0
[  342.068822]  r4:c06b9240
[  342.071377] [<c06b9240>] (generic_splice_sendpage) from
[<c06b761c>] (direct_splice_actor+0x4c/0x54)
[  342.080562] [<c06b75d0>] (direct_splice_actor) from [<c06b7ff0>]
(splice_direct_to_actor+0x120/0x2bc)
[  342.089827]  r4:d3b2fcc0
[  342.092383] [<c06b7ed0>] (splice_direct_to_actor) from [<c06b8238>]
(do_splice_direct+0xac/0xe4)
[  342.101218]  r10:e68598c0 r9:e99adf20 r8:e9949a00 r7:00000000
r6:00000010 r5:e99adf18
[  342.109088]  r4:c1e08488
[  342.111645] [<c06b818c>] (do_splice_direct) from [<c067ac74>]
(do_sendfile+0x1dc/0x420)
[  342.119693]  r8:00000001 r7:00000fff r6:fffff000 r5:e9949a00 r4:c1e08488
[  342.126436] [<c067aa98>] (do_sendfile) from [<c067c2a4>]
(sys_sendfile+0xf8/0x11c)
[  342.134048]  r10:00000001 r9:0000001e r8:c04011c4 r7:00000000
r6:00000000 r5:00000001
[  342.141917]  r4:c1e08488
[  342.144475] [<c067c1ac>] (sys_sendfile) from [<c0401000>]
(ret_fast_syscall+0x0/0x28)
[  342.152346] Exception stack(0xe99adfa8 to 0xe99adff0)
[  342.157428] dfa0:                   bef7ca44 00000001 0000001a
0000001e 00000000 00000001
[  342.165650] dfc0: bef7ca44 00000001 00000200 000000bb 00000001
0000001e 0000001a 00000010
[  342.173870] dfe0: 00045034 bef7c884 000137c0 b6e76d7c
[  342.178951]  r10:000000bb r9:e99ac000 r8:c04011c4 r7:000000bb
r6:00000200 r5:00000001
[  342.186822]  r4:bef7ca44
[  342.189377] Code: e4808004 e480e004 e8bd01e0 e1b02f82 (14d13001)
[  342.195755] ---[ end trace d2353d98cf59813b ]---


[1] https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190604/testrun/760426/log
