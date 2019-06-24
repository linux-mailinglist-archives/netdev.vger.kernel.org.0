Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5930350B4C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbfFXM7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:59:35 -0400
Received: from canardo.mork.no ([148.122.252.1]:34121 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbfFXM7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 08:59:35 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:282:c0c6:2870:15ff:fe87:c238])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x5OCxGG2006893
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 24 Jun 2019 14:59:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1561381158; bh=XQsUYIbtGV5iLBtEMGinbcXCCB2jfmy7MxU1fU6ua0E=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=NFec1O8OFGN9c5A8nkGrqjIpmLTHJO9Q0DGVTC2jYIVhCNIkS8MJGaVONb6L+caha
         EYyp1Vo1/sf6IDv2WP4xQVnRDiQOJVr0k/hVFTjmyuGOGq/BOHdD/krguQzXjzQHVU
         JNt8Z/ZueCsQzPQ/dyQncu9JhJ/fPL3kSF26llJA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@mork.no>)
        id 1hfOYx-0007Ao-Fm; Mon, 24 Jun 2019 14:59:11 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     syzbot <syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com>,
        andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: global-out-of-bounds Read in qmi_wwan_probe
Organization: m
References: <0000000000008f19f7058c10a633@google.com>
Date:   Mon, 24 Jun 2019 14:59:11 +0200
In-Reply-To: <0000000000008f19f7058c10a633@google.com> (syzbot's message of
        "Mon, 24 Jun 2019 05:07:05 -0700")
Message-ID: <871rzj6sww.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    9939f56e usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1615a669a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Ddf134eda130bb=
43a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Db68605d7fadd215=
10de1
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10630af6a00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1127da69a00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
>
> usb 1-1: new high-speed USB device number 2 using dummy_hcd
> usb 1-1: Using ep0 maxpacket: 8
> usb 1-1: New USB device found, idVendor=3D12d1, idProduct=3D14f1,
> bcdDevice=3Dd4.d9
> usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
> usb 1-1: config 0 descriptor??
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: global-out-of-bounds in qmi_wwan_probe+0x342/0x360
> drivers/net/usb/qmi_wwan.c:1417
> Read of size 8 at addr ffffffff8618c140 by task kworker/1:1/22
>
> CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 5.2.0-rc5+ #11
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xca/0x13e lib/dump_stack.c:113
>  print_address_description+0x67/0x231 mm/kasan/report.c:188
>  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
>  kasan_report+0xe/0x20 mm/kasan/common.c:614
>  qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
>  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
>  really_probe+0x281/0x660 drivers/base/dd.c:509
>  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
>  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
>  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
>

Hello Kristian!

I need some help understanding this...  IIUC syzbot is claiming an
out-of-bounds access at line 1417 in v5.2-rc5.  Or whatever - I'm having
a hard time deciphering what kernel version the bot is actually
testing. The claimed HEAD is not a kernel commit.  At least not in my
kernel...


But if this is correct, then it points to the info->data access you
recently added:

822e44b45eb99 (Kristian Evensen        2019-03-02 13:32:26 +0100 1409)  /* =
Several Quectel modems supports dynamic interface configuration, so
7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1410)   * =
we need to match on class/subclass/protocol. These values are
7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1411)   * =
identical for the diagnostic- and QMI-interface, but bNumEndpoints is
7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1412)   * =
different. Ignore the current interface if the number of endpoints
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1413)   * =
equals the number for the diag interface (two).
7c5cca3588545 (Kristian Evensen        2018-09-08 13:50:48 +0200 1414)   */
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1415)  inf=
o =3D (void *)&id->driver_info;
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1416)=20
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1417)  if =
(info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1418)     =
     if (desc->bNumEndpoints =3D=3D 2)
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1419)     =
             return -ENODEV;
e4bf63482c309 (Kristian Evensen        2019-04-07 15:39:09 +0200 1420)  }


I must be blind. I cannot see how this could end up failing.
id->driver_info is always set to one of qmi_wwan_info,
qmi_wwan_info_quirk_dtr or qmi_wwan_info_quirk_quectel_dyncfg at this
point.  How does that end up out-of-bounds?



Bj=C3=B8rn
