Return-Path: <netdev+bounces-4331-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC70070C187
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFEC71C20AD5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2578A1429E;
	Mon, 22 May 2023 14:53:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF8A14278;
	Mon, 22 May 2023 14:53:28 +0000 (UTC)
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F47ABB;
	Mon, 22 May 2023 07:53:27 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-4572fc781daso601219e0c.2;
        Mon, 22 May 2023 07:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684767206; x=1687359206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9odVnjjoR+4AuNw6ksnagpqi3r+RrcYNLrZWenZLiqg=;
        b=BmDabCZP63yATPO3XTiegoftHUu9QDq5tUiWk9D2y5meNYS71L2+1QqBnzNqGAW0Kv
         1a3mvYpDCSEQeZOhOynLeIHLkpkoNMgcNPBA/0kb6ZJ82jRLgvXYDfPvU1QJ9hlXfVej
         EIV2LHLSbXfJIcp6rmNKIjLR+21txsxlBNLBZ8SaSbNMwI5Q7xzu7RVBd32UZoNHcQnA
         mCzpFCYnkbnwxLv0fP+4KZeTfiDQAMwjLgb5qaw1/r3fE9UOGIMKrQotlQ5iXSVZN/rw
         +cHtNUQtGBzbT6+VKET+/tqfJbXmhb/hv/ckaKtSMSHwX5u0hnPZWf5ejpHH4phQXn/v
         +ZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684767206; x=1687359206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9odVnjjoR+4AuNw6ksnagpqi3r+RrcYNLrZWenZLiqg=;
        b=Y7zZMtqnvS3MngCmJ3ChUQ1q0q3AFYVokGTT0BgNFQagVGiRAhqd8lczVWEuP5C+BK
         420B99i+FoSUQF+V1Xp85tgvOfn/teeB35DH6QSVzGPMtuKZpDaIrXLrdqXECDszquZ9
         jaXkF5m6pSZinra3TZjInFsaCJ/LeoqyRtln3sxcI5ZRC158fNvI/ps2XWfdJDzl9DwG
         XwhtL3JjXQdA+ALKGHCPX4JaZFs9naJpXWgI3LFcIV5EvdHSptWS6zB+vTvNQDsShgS8
         cYKW6uDn82sg5czWUj/iW637cJr3ZAvAJsqtoDdLAtsg2S/Hi2fS2gE2ve1RuqcrvFRo
         Y6Kg==
X-Gm-Message-State: AC+VfDwfcUmmWJfkKawoRHBVoUwKJ/Nl0Og/3Z04f5FwociC/IAN+9SL
	Sul+LVbrtnC2k6Y2GUEXDRZBCG2oEtqQ1ihLlOQ=
X-Google-Smtp-Source: ACHHUZ5YGXAvxeJfZofHQqhHemSuYJRUrF5dA75oZkpfK7uqtzBcrKqf4fZ0R1FfwZPq2zhdo+nmrksQb6SqxEWqbDY=
X-Received: by 2002:a1f:3f88:0:b0:457:1a8:9ea4 with SMTP id
 m130-20020a1f3f88000000b0045701a89ea4mr3819909vka.3.1684767206566; Mon, 22
 May 2023 07:53:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037341d05fc460fa6@google.com>
In-Reply-To: <00000000000037341d05fc460fa6@google.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 22 May 2023 10:52:49 -0400
Message-ID: <CAF=yD-JpUc3SLtd7MtULmKOcERf6EJZ0rPc7WmJB2nUNUQRBjA@mail.gmail.com>
Subject: Re: [syzbot] [net?] KASAN: invalid-access Read in __packet_get_status
To: syzbot <syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com>
Cc: bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 6:51=E2=80=AFAM syzbot
<syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    2d1bcbc6cd70 Merge tag 'probes-fixes-v6.4-rc1' of git://g=
i..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D154b8fa128000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D51dd28037b2a5=
5f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D64b0f633159fde0=
8e1f1
> compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, =
GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12b6382e280=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17fd0aee28000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/3=
84ffdcca292/non_bootable_disk-2d1bcbc6.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d2e21a43e11e/vmlinu=
x-2d1bcbc6.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/49e0b029f9af/I=
mage-2d1bcbc6.gz.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: invalid-access in __packet_get_status+0x70/0xe0 net/packet/af=
_packet.c:438

The offending line is the last one in

"
static int __packet_get_status(const struct packet_sock *po, void *frame)
{
        union tpacket_uhdr h;

        smp_rmb();

        h.raw =3D frame;
        switch (po->tp_version) {
        case TPACKET_V1:
                flush_dcache_page(pgv_to_page(&h.h1->tp_status));
                return h.h1->tp_status;
        case TPACKET_V2:
                flush_dcache_page(pgv_to_page(&h.h2->tp_status));
"

The reproducer is very small:

"
// socket(PF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL);
r0 =3D socket$packet(0x11, 0x2, 0x300)

// setsockopt PACKET_RX_RING with same block and frame sizes and counts
setsockopt$packet_rx_ring(r0, 0x107, 0x5,
&(0x7f0000000040)=3D@req3=3D{0x8000, 0x200, 0x80, 0x20000}, 0x1c)

// excessive length, too many bits in prot, MAP_SHARED | MAP_ANONYMOUS
mmap(&(0x7f0000568000/0x2000)=3Dnil, 0x1000000, 0x20567fff, 0x11, r0, 0x0)
"

What is odd here is that the program never sets packet version
explicitly, and the default is TPACKET_V1.

