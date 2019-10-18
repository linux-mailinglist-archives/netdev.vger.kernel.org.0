Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244CEDC770
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442835AbfJROeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:34:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55426 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408695AbfJROeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:34:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so6415910wma.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qRJSjSfwWk65VGJdf4XvN9SqgEtDgNCxKyoZRmSRziU=;
        b=Dran/X3VvHsOsLxMHx2mR4Tbc2E0CsYuXkAVyxt+rQg1nOiiruEmPu6Rq/0c282a+F
         ggJOtx621SXz4bS1W6J3oTzOrrCZthi6et66yFpQYwUW2P9id96GcGZMCfdcXwbLX5es
         ve8HtlmX+75D9UfDTi1k9mYUAFEwXCjB8Q5j2H7CuqjYuTNuHkEXO7gqEN/vVEffGumb
         bPwC0XzbDLfAfKN1WTlLIxCzJsSCIt2y6MkGh031HvQEv9/LlHfkESbTMlJ0AYSuR5mG
         oeShHCaasoNi9k/zgpcPJBvcsuumloyWQqdDVf6fcgvcjI+LILE1fhCeVpnrMRN7cTPP
         XEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qRJSjSfwWk65VGJdf4XvN9SqgEtDgNCxKyoZRmSRziU=;
        b=sYidpk9HnY0NX/l5ZmOkZOIaikCQCG2LDsPCTgK/klzqQkETRV4cNK8G75l2rksckd
         8PWZBGNFZOPCdk0/ZLdMC/3yLsppreuGKddZQ/tWwNpNaAu2jrFbb6tW8K/EJ0sMLwAE
         W+3qjbg4x4uYgggJflTz0SH3+jc/D3TYJKoND8IqmrGcNEQ//VNbyebv6iHCHh4F3nOk
         xxc070ScbRG6uovTblAB2kEGYeAbOVbkxhutqWyZZ4ousc4BC1fubZ7ehosAkkVk9ctb
         X8CqpDIVc8T05zSQ8OJYFHBPtV73g2sZPXLgtbtWSZlUIIUxHvxMxYlZ3uCYEyXrwE54
         Ko5A==
X-Gm-Message-State: APjAAAXROehVly4Jwn2Ph4G/Tp/E5nMGmuEEZJ9xWi+Q6rFMtYD+4XIC
        t5pMmIhOuJ65s7bOQLkQczdk0EjE6gHVNojORnm61g==
X-Google-Smtp-Source: APXvYqx5fIkvKBTZRLKu9evz7okLaALBFiYvdfXt23Zivfzy0uSIv3xvGaPkDb4c0B8dNmIBr6OCZSHyRLUQMglcJRw=
X-Received: by 2002:a05:600c:2196:: with SMTP id e22mr2108693wme.79.1571409254188;
 Fri, 18 Oct 2019 07:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006120c905952febbd@google.com> <5289022.tfFiBPLraV@bentobox>
In-Reply-To: <5289022.tfFiBPLraV@bentobox>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 18 Oct 2019 16:34:02 +0200
Message-ID: <CAG_fn=VFnPmhupvPLZMZWJP6U_-w=fxoZd+R668rzBeCGh+S3A@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in batadv_hard_if_event
To:     Sven Eckelmann <sven@narfation.org>
Cc:     syzbot <syzbot+0183453ce4de8bdf9214@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        Networking <netdev@vger.kernel.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Petko Manolov <petkan@nucleusys.com>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 4:32 PM Sven Eckelmann <sven@narfation.org> wrote:
>
> Hi,
>
> not sure whether this is now a bug in batman-adv or in the rtl8150 driver=
. See
> my comments inline.
>
> On Friday, 18 October 2019 16:12:08 CEST syzbot wrote:
> [...]
> > usb 1-1: config 0 has no interface number 0
> > usb 1-1: New USB device found, idVendor=3D0411, idProduct=3D0012,
> > bcdDevice=3D56.5f
> > usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
> > usb 1-1: config 0 descriptor??
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > BUG: KMSAN: uninit-value in batadv_check_known_mac_addr
> > net/batman-adv/hard-interface.c:511 [inline]
> > BUG: KMSAN: uninit-value in batadv_hardif_add_interface
> > net/batman-adv/hard-interface.c:942 [inline]
> > BUG: KMSAN: uninit-value in batadv_hard_if_event+0x23c0/0x3260
> > net/batman-adv/hard-interface.c:1032
> > CPU: 0 PID: 13223 Comm: kworker/0:3 Not tainted 5.4.0-rc3+ #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
> >   kmsan_report+0x14a/0x2f0 mm/kmsan/kmsan_report.c:109
> >   __msan_warning+0x73/0xf0 mm/kmsan/kmsan_instr.c:245
> >   batadv_check_known_mac_addr net/batman-adv/hard-interface.c:511 [inli=
ne]
> >   batadv_hardif_add_interface net/batman-adv/hard-interface.c:942 [inli=
ne]
> >   batadv_hard_if_event+0x23c0/0x3260 net/batman-adv/hard-interface.c:10=
32
> >   notifier_call_chain kernel/notifier.c:95 [inline]
> [...]
>
> The line in batman-adv is (batadv_check_known_mac_addr):
>
>                 if (!batadv_compare_eth(hard_iface->net_dev->dev_addr,
>                                         net_dev->dev_addr))
>
> So it goes through the list of ethernet interfaces (which are currently
> attached to a batadv interface) and compares it with the new device's MAC
> address. And it seems like the new device doesn't have the mac address pa=
rt
> initialized yet.
>
> Is this allowed in NETDEV_REGISTER/NETDEV_POST_TYPE_CHANGE?
>
> > Uninit was stored to memory at:
> >   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
> >   kmsan_internal_chain_origin+0xbd/0x170 mm/kmsan/kmsan.c:317
> >   kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:253
> >   kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:273
> >   __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
> >   set_ethernet_addr drivers/net/usb/rtl8150.c:282 [inline]
> >   rtl8150_probe+0x1143/0x14a0 drivers/net/usb/rtl8150.c:912
>
> This looks like it should store the mac address at this point.
>
>     static inline void set_ethernet_addr(rtl8150_t * dev)
>     {
>         u8 node_id[6];
>
>         get_registers(dev, IDR, sizeof(node_id), node_id);
>         memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
>     }
>
> But it seems more like get_registers failed and the uninitialized was sti=
ll
> copied to the mac address. Thus causing the KMSAN error in batman-adv.
Yes, most of such reports is usually because functions like
get_registers() fail or read 0 bytes.

> Is this interpretation of the KMSAN output correct or do I miss something=
?
>
> Kind regards,
>         Sven



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
