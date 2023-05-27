Return-Path: <netdev+bounces-5932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F341471366B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 22:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF1A928150B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 20:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B578E154BE;
	Sat, 27 May 2023 20:33:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED6A2C9E;
	Sat, 27 May 2023 20:33:10 +0000 (UTC)
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE30B1;
	Sat, 27 May 2023 13:33:08 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-4397b040c8fso1121258137.0;
        Sat, 27 May 2023 13:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685219588; x=1687811588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DphEniiV7+L9T07hsrZpWRu6Se0vRycld7BbJ4F2i5s=;
        b=O7rUqk+3zdR02SJ3nc0i0gjUm5pD7ypN8bPLk+lpEOfkSamIjLqdcIOrFJnJlbSCTA
         RDiaBSqFchS1EXo3a2H1RpsvowA5BEvvQUiucW7pqm+MyTXfNMeAeho2hu3j8ny+MhP7
         zIICmLCp61XHa++z3WCZL/IQkYbS4nyTO8RFLhoMwv3DKxiJ7eWTQAKT4VupGNr4s/XI
         OEWXm7aJb1rRiWY2XHan2WrpxzNO4M6L36E1adarpiQu0vyMAFQ0nffznAAwvDY2iP1m
         ylTtFUjLLvtF2YJTUojoiiX2SrwnPPNzXRpZjyAf+w476QE3yeFuYxckR/0CTE4gkle9
         NbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685219588; x=1687811588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DphEniiV7+L9T07hsrZpWRu6Se0vRycld7BbJ4F2i5s=;
        b=l8FPo3Kid4r7EFOVute5tEA/DPPTpLGAm/6AMPbudV/q6WKTj6mEL7prvI5yyXTQz+
         lk0+gaugzsrDNXSxI09HCHsmQarb0pK/kIwNn2I0h9S7bFxW+CQTbbKvza1NvdTVIBgP
         fia5jI5WPqZD1szA1R1sw9hpxcXLdfT31DdlPh2bSz56KGu/RtPfyVeMB8uXR3nvmGkV
         pHFmTe4u3OpzzZXyZuFRSGlKHw5FR7LGdnhmCcaa9PFSqZw8g0XL1m+BnrA4c7RHPlLr
         c0IW4NoLUcymjOO+XJMEXTNKIar08KB2FmOFU5CwrWM7LBTvZSvalK7rsITg8Uw2R0SY
         NC8A==
X-Gm-Message-State: AC+VfDwSIEi/p8CMV8NBfL5SUrGygiMHBwuHfy47Qc79wglFO7u3HdO7
	+9n6hs5ksy11HJKgNm/LfIaEC4Qau/kMYkyZE5k=
X-Google-Smtp-Source: ACHHUZ7j1USGL3o1axHHccs3q8ZcTSSYWRerLMuMhHfd26USaqLqm73fyuhAS9F7rRZjTkKazWJv909u45/+K0wqiV8=
X-Received: by 2002:a67:f2c9:0:b0:42c:543a:ab2a with SMTP id
 a9-20020a67f2c9000000b0042c543aab2amr1973157vsn.35.1685219587791; Sat, 27 May
 2023 13:33:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000037341d05fc460fa6@google.com> <CAF=yD-JpUc3SLtd7MtULmKOcERf6EJZ0rPc7WmJB2nUNUQRBjA@mail.gmail.com>
 <CAF=yD-+MxyoD1Mbekf93-XhAA2urAf5audD8HefmF8bfsu51iQ@mail.gmail.com>
In-Reply-To: <CAF=yD-+MxyoD1Mbekf93-XhAA2urAf5audD8HefmF8bfsu51iQ@mail.gmail.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sat, 27 May 2023 16:32:31 -0400
Message-ID: <CAF=yD-Ln94Nim0GkpLhZ7p7qQFUDE4Z-adrjRMRSh2y3iBmb+w@mail.gmail.com>
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

On Mon, May 22, 2023 at 12:19=E2=80=AFPM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 22, 2023 at 10:52=E2=80=AFAM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, May 22, 2023 at 6:51=E2=80=AFAM syzbot
> > <syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    2d1bcbc6cd70 Merge tag 'probes-fixes-v6.4-rc1' of git=
://gi..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D154b8fa12=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D51dd28037=
b2a55f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D64b0f633159=
fde08e1f1
> > > compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 202101=
10, GNU ld (GNU Binutils for Debian) 2.35.2
> > > userspace arch: arm64
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12b6382=
e280000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17fd0aee2=
80000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-asse=
ts/384ffdcca292/non_bootable_disk-2d1bcbc6.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/d2e21a43e11e/vm=
linux-2d1bcbc6.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/49e0b029f9=
af/Image-2d1bcbc6.gz.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+64b0f633159fde08e1f1@syzkaller.appspotmail.com
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: invalid-access in __packet_get_status+0x70/0xe0 net/packe=
t/af_packet.c:438
> >
> > The offending line is the last one in
> >
> > "
> > static int __packet_get_status(const struct packet_sock *po, void *fram=
e)
> > {
> >         union tpacket_uhdr h;
> >
> >         smp_rmb();
> >
> >         h.raw =3D frame;
> >         switch (po->tp_version) {
> >         case TPACKET_V1:
> >                 flush_dcache_page(pgv_to_page(&h.h1->tp_status));
> >                 return h.h1->tp_status;
> >         case TPACKET_V2:
> >                 flush_dcache_page(pgv_to_page(&h.h2->tp_status));
> > "
> >
> > The reproducer is very small:
> >
> > "
> > // socket(PF_PACKET, SOCK_DGRAM, htons(ETH_P_ALL);
> > r0 =3D socket$packet(0x11, 0x2, 0x300)
> >
> > // setsockopt PACKET_RX_RING with same block and frame sizes and counts
> > setsockopt$packet_rx_ring(r0, 0x107, 0x5,
> > &(0x7f0000000040)=3D@req3=3D{0x8000, 0x200, 0x80, 0x20000}, 0x1c)
> >
> > // excessive length, too many bits in prot, MAP_SHARED | MAP_ANONYMOUS
> > mmap(&(0x7f0000568000/0x2000)=3Dnil, 0x1000000, 0x20567fff, 0x11, r0, 0=
x0)
> > "
> >
> > What is odd here is that the program never sets packet version
> > explicitly, and the default is TPACKET_V1.
>
> The test is marked as repeat.
>
> One possibility is that there is a race between packet arrival calling
> flush_dcache_page and user mmap setup/teardown. That would exhibit as
> flakiness.
>
> ARM flush_dcache_page is quite outside my networking comfort zone.

The accessed memory is using ARM MTE tags. It appears that the memory
is accessed with the wrong tag:

 do_tag_check_fault+0x78/0x8c arch/arm64/mm/fault.c:791
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:867
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:586
 __packet_get_status+0x70/0xe0 net/packet/af_packet.c:438

