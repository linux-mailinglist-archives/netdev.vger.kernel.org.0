Return-Path: <netdev+bounces-4364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D026F70C329
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 892A0281063
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B969616409;
	Mon, 22 May 2023 16:20:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8716401;
	Mon, 22 May 2023 16:20:20 +0000 (UTC)
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE975F4;
	Mon, 22 May 2023 09:20:18 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id a1e0cc1a2514c-783fc329e72so1594190241.3;
        Mon, 22 May 2023 09:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684772418; x=1687364418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQZuFyKz5hTVe5q8CSWku/WlIYzI4Py/CmBN1bqXtzg=;
        b=J+xPpPSx24may27+92v9OqamVaSStyTOu6LyM2wso5WIClB/9DSicR3Q8Zuv2mJIwp
         FlI9G2svxo/LeNXYOfa/B7ys3CqU3MKiRsARzUYJpies4X7BeGbq8gMCTQEm8lkWQbhJ
         OrDqO2ME5WzjA/9Q7SmAf2BHe/zJ5IgItO3FuIc/dYRvUFo50N5noNl10ChEpAr6kVAw
         yFcn22/8M7Gq/FcxaE06h3/dP61SHAiTThUS4QCQrpSgVF46AZU3nRch5WN/xMb03LNO
         zHKatI7xjRVVol36sHd4T3HAlq4CZRexfRoE0ZyyJOYGyxrrJ4L9uQOpNx6tlNqR9nyF
         Wpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684772418; x=1687364418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQZuFyKz5hTVe5q8CSWku/WlIYzI4Py/CmBN1bqXtzg=;
        b=l1mtnX8hVzc+Ntm350BvIfchsIbGKcB6TDtebTYCA4GtnfHuD2ZaJbO874v2baphJ4
         PG80IPdxPtZBkl3KhGjxbrwH6oEuJOdjkqEYTLWsScIS18qIJ4A3DSL5nB5jtAmzVd1n
         IJd8YtuZgWYmC2Ni14IkeFHMhe54/9CfDiOPXWkvXXXdTLPN2s0wkvBFDkdWlwL9/+xr
         Zrs6B32jkhw/Pk3OIyQ6U0E+7Zf7CNtKWKFWBpKAkaawlqDWK6qmZUN1xvgukGnkPavj
         RaJrDdYbhTY7vnXhjc/GQqRPboyqr7rcEHRUwKQ+A08zywTvMZ8NEDa0hOvigDgBC6BI
         gZkQ==
X-Gm-Message-State: AC+VfDzhfWe9hzAcBiwhucS9wb1bM/26LVX037/nSKh/tmuR/Guf7K0I
	vN4/Et/kAqBbIccIv343BuJhzj69LhzdYDYATTo=
X-Google-Smtp-Source: ACHHUZ5f/fyUoakvYwpH0GFFUbcPicCt3clTUFeKQ4jSnmEhQcCSeE/YSAqooi5VfkqmGC4STzDNFoSVKCJ2QDadl4E=
X-Received: by 2002:a05:6102:7a8:b0:438:d4bd:f1f2 with SMTP id
 x8-20020a05610207a800b00438d4bdf1f2mr2911145vsg.22.1684772417822; Mon, 22 May
 2023 09:20:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037341d05fc460fa6@google.com> <CAF=yD-JpUc3SLtd7MtULmKOcERf6EJZ0rPc7WmJB2nUNUQRBjA@mail.gmail.com>
In-Reply-To: <CAF=yD-JpUc3SLtd7MtULmKOcERf6EJZ0rPc7WmJB2nUNUQRBjA@mail.gmail.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 22 May 2023 12:19:41 -0400
Message-ID: <CAF=yD-+MxyoD1Mbekf93-XhAA2urAf5audD8HefmF8bfsu51iQ@mail.gmail.com>
Subject: Re: [syzbot] [net?] KASAN: invalid-access Read in __packet_get_status
To: syzbot <syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com>
Cc: bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 10:52=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 22, 2023 at 6:51=E2=80=AFAM syzbot
> <syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    2d1bcbc6cd70 Merge tag 'probes-fixes-v6.4-rc1' of git:/=
/gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D154b8fa1280=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D51dd28037b2=
a55f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D64b0f633159fd=
e08e1f1
> > compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110=
, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12b6382e2=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17fd0aee280=
000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/384ffdcca292/non_bootable_disk-2d1bcbc6.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/d2e21a43e11e/vmli=
nux-2d1bcbc6.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/49e0b029f9af=
/Image-2d1bcbc6.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: invalid-access in __packet_get_status+0x70/0xe0 net/packet/=
af_packet.c:438
>
> The offending line is the last one in
>
> "
> static int __packet_get_status(const struct packet_sock *po, void *frame)
> {
>         union tpacket_uhdr h;
>
>         smp_rmb();
>
>         h.raw =3D frame;
>         switch (po->tp_version) {
>         case TPACKET_V1:
>                 flush_dcache_page(pgv_to_page(&h.h1->tp_status));
>                 return h.h1->tp_status;
>         case TPACKET_V2:
>                 flush_dcache_page(pgv_to_page(&h.h2->tp_status));
> "
>
> The reproducer is very small:
>
> "
> // socket(PF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL);
> r0 =3D socket$packet(0x11, 0x2, 0x300)
>
> // setsockopt PACKET_RX_RING with same block and frame sizes and counts
> setsockopt$packet_rx_ring(r0, 0x107, 0x5,
> &(0x7f0000000040)=3D@req3=3D{0x8000, 0x200, 0x80, 0x20000}, 0x1c)
>
> // excessive length, too many bits in prot, MAP_SHARED | MAP_ANONYMOUS
> mmap(&(0x7f0000568000/0x2000)=3Dnil, 0x1000000, 0x20567fff, 0x11, r0, 0x0=
)
> "
>
> What is odd here is that the program never sets packet version
> explicitly, and the default is TPACKET_V1.

The test is marked as repeat.

One possibility is that there is a race between packet arrival calling
flush_dcache_page and user mmap setup/teardown. That would exhibit as
flakiness.

ARM flush_dcache_page is quite outside my networking comfort zone.

