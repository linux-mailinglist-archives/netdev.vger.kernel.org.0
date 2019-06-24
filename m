Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2D51062
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbfFXP3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:29:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44853 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730975AbfFXP3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:29:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so7694437pfe.11
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 08:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5sMA8Bhdq57YWns4UhDuBeWcNG1MKu8bMzUeQztIwmo=;
        b=geq2YQDjLudJEDsQW5df0w57jpwjsnFBugQD+Uxq7vemrKR40xxaxDNeQF0sXx3Rup
         +DA2Un2DphDRoo8ungSfRXbIAeOYVSP8atN1GmkrIUp93o/qfei8daFta8ZANX/Rvha4
         cj2FUFRjj3kQxyF5HmshlEZsPmv7/9ueZ7OJ5s3KeCt0ghUcyz89NUbZG6iKL8mWwoEo
         FKc59cQrxu83tAxDA9Z32lh8AlnSNyPPgm63n25sGVi2SzkFa/PJnHT06AfrLkjgqj4g
         nG4ha0ezpIaDHia4ysySQd3D5K+Qm+edX7DKO2J+ZRt5LuFDdjJHZ4yw+lStdI4s8Qga
         d8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5sMA8Bhdq57YWns4UhDuBeWcNG1MKu8bMzUeQztIwmo=;
        b=Qh2CITwrIGxzsWD0Tcj1j1McPXYFiamqgtbAk5aaWUhuyNMJ5ykUsUHLs1TzVr0L/V
         sYM6oX206lb5QBL2T83nEqQr+4tiS6NrfT2Uc1cPBVVKQQKqekHM/AXanO6q5nsox7QQ
         Ep3kj5HhUBX6gkc0Nbrn5Cyy+cMX7x4iY3418EOyi5amKxw9Is1gPXnwESvB3cRQq5P1
         dAlnASfXrSyGR0N2mTkSaAZ3PX6AwSHOHmd1yZ34aqFHIy3xiNfwdsBhClvx2RjONlmP
         lHVKSQ3AlUNNEncTA4lhy9RHjasOToUWfq6vj9kR01aLAVH7t1xWYGxZCp6Mhm7+AqP1
         tvAg==
X-Gm-Message-State: APjAAAUo0vAmCacWoPvu4sH1O8Q66Mb+Lv+1fjm5lou+pjDd/hX2VoJb
        LJCVjEGjOqhTenhmedId/PwEiyfVCZVcpSmrR1oKiw==
X-Google-Smtp-Source: APXvYqyGugxGb0p/WNDcK74We/hdAUW6mjTNAvW4+3FAphRoJfY+GG6lJrx5vEz+N8+hkaus4qFaa4hXvgmejqcWdxo=
X-Received: by 2002:a65:4c0c:: with SMTP id u12mr33434112pgq.130.1561390178725;
 Mon, 24 Jun 2019 08:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008f19f7058c10a633@google.com> <871rzj6sww.fsf@miraculix.mork.no>
In-Reply-To: <871rzj6sww.fsf@miraculix.mork.no>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 24 Jun 2019 17:29:27 +0200
Message-ID: <CAAeHK+xjP6Uuwa7ccgomj1ea+2sZahriQvRzdmU-f6FZdxJ5Zw@mail.gmail.com>
Subject: Re: KASAN: global-out-of-bounds Read in qmi_wwan_probe
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        syzbot <syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 2:59 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> syzbot <syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com> writes:
>
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    9939f56e usb-fuzzer: main usb gadget fuzzer driver
> > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1615a669a00=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Ddf134eda130=
bb43a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db68605d7fadd2=
1510de1
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10630af6a=
00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1127da69a00=
000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
> >
> > usb 1-1: new high-speed USB device number 2 using dummy_hcd
> > usb 1-1: Using ep0 maxpacket: 8
> > usb 1-1: New USB device found, idVendor=3D12d1, idProduct=3D14f1,
> > bcdDevice=3Dd4.d9
> > usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
> > usb 1-1: config 0 descriptor??
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: global-out-of-bounds in qmi_wwan_probe+0x342/0x360
> > drivers/net/usb/qmi_wwan.c:1417
> > Read of size 8 at addr ffffffff8618c140 by task kworker/1:1/22
> >
> > CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 5.2.0-rc5+ #11
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 01/01/2011
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0xca/0x13e lib/dump_stack.c:113
> >  print_address_description+0x67/0x231 mm/kasan/report.c:188
> >  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
> >  kasan_report+0xe/0x20 mm/kasan/common.c:614
> >  qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
> >  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
> >  really_probe+0x281/0x660 drivers/base/dd.c:509
> >  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
> >  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
> >  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
> >
>
> Hello Kristian!
>
> I need some help understanding this...  IIUC syzbot is claiming an
> out-of-bounds access at line 1417 in v5.2-rc5.  Or whatever - I'm having
> a hard time deciphering what kernel version the bot is actually
> testing. The claimed HEAD is not a kernel commit.  At least not in my
> kernel...

The bot currently tests this tree:
https://github.com/google/kasan/tree/usb-fuzzer, which is essentially
5.2-rc5.

>
>
> But if this is correct, then it points to the info->data access you
> recently added:
>
> 822e44b45eb99 (Kristian Evensen        2019-03-02 13:32:26 +0100 1409)  /=
* Several Quectel modems supports dynamic interface configuration, so
> 7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1410)   =
* we need to match on class/subclass/protocol. These values are
> 7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1411)   =
* identical for the diagnostic- and QMI-interface, but bNumEndpoints is
> 7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1412)   =
* different. Ignore the current interface if the number of endpoints
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1413)   =
* equals the number for the diag interface (two).
> 7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1414)   =
*/
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1415)  i=
nfo =3D (void *)&id->driver_info;
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1416)
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1417)  i=
f (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1418)   =
       if (desc->bNumEndpoints =3D=3D 2)
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1419)   =
               return -ENODEV;
> e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1420)  }
>
>
> I must be blind. I cannot see how this could end up failing.
> id->driver_info is always set to one of qmi_wwan_info,
> qmi_wwan_info_quirk_dtr or qmi_wwan_info_quirk_quectel_dyncfg at this
> point.  How does that end up out-of-bounds?

I've run the reproducer locally and checked the addresses. The
structures that you mentioned are at:

gef> p &qmi_wwan_info
$1 =3D (const struct driver_info *) 0xffffffff85d32e80 <qmi_wwan_info>
gef> p &qmi_wwan_info_quirk_dtr
$2 =3D (const struct driver_info *) 0xffffffff85d32dc0 <qmi_wwan_info_quirk=
_dtr>
gef> p &qmi_wwan_info_quirk_quectel_dyncfg
$3 =3D (const struct driver_info *) 0xffffffff85d32d00
<qmi_wwan_info_quirk_quectel_dyncfg>

And the bad access for me happens on address 0xffffffff85d32ce0, so it
seems that driver_info somehow ended up lying below
qmi_wwan_info_quirk_quectel_dyncfg.

gef> x/6gx 0xffffffff85d32ce0
0xffffffff85d32ce0: 0x0000000000000000 0x0000000000000000
0xffffffff85d32cf0: 0x0000000000000000 0x0000000000000000
0xffffffff85d32d00 <qmi_wwan_info_quirk_quectel_dyncfg>:
0xffffffff85d32cc0 0x0000000000000600

>
>
>
> Bj=C3=B8rn
