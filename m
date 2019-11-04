Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924D0EEAFD
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfKDVWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:22:47 -0500
Received: from canardo.mork.no ([148.122.252.1]:37859 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfKDVWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:22:47 -0500
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id xA4LMV2u006902
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 22:22:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1572902556; bh=48oj23vht5x5+7JKYCCyMc5bdK+KmMf3l3mvdQ60FJQ=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=nsp4z2A0Ol0ZPMNtpvgXHP/QHASiVnZT0tLNU9H0xfszOUbrCOyeBClHdJHWz1/im
         cy+MsmDRoekwPAsBW7OmzgqJ5K3fR6gi8KlZdBmLOf+ECqQ4CcehiszZpfY7TXfyQC
         6umMwZjJVfImOgRcPXXfNRL2AoBoKQHDnJ8+5heQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iRjnx-0003Uh-Se; Mon, 04 Nov 2019 22:22:29 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
Organization: m
References: <00000000000013c4c1059625a655@google.com>
Date:   Mon, 04 Nov 2019 22:22:29 +0100
In-Reply-To: <00000000000013c4c1059625a655@google.com> (syzbot's message of
        "Wed, 30 Oct 2019 12:22:07 -0700")
Message-ID: <87ftj32v6y.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com> writes:

> syzbot found the following crash on:
>
> HEAD commit:    96c6c319 net: kasan: kmsan: support CONFIG_GENERIC_CSUM o=
n..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11f103bce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9e324dfe9c7b0=
360
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D0631d878823ce24=
11636
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10dd9774e00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13651a24e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0631d878823ce2411636@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in cdc_ncm_set_dgram_size+0x6ba/0xbc0
> drivers/net/usb/cdc_ncm.c:587
> CPU: 0 PID: 11865 Comm: kworker/0:3 Not tainted 5.4.0-rc5+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
>  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
>  cdc_ncm_set_dgram_size+0x6ba/0xbc0 drivers/net/usb/cdc_ncm.c:587

..
> Variable was created at:
>  cdc_ncm_set_dgram_size+0xf5/0xbc0 drivers/net/usb/cdc_ncm.c:564
>  cdc_ncm_set_dgram_size+0xf5/0xbc0 drivers/net/usb/cdc_ncm.c:564
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

This looks like a false positive to me. max_datagram_size is two bytes
declared as

	__le16 max_datagram_size;

and the code leading up to the access on drivers/net/usb/cdc_ncm.c:587
is:

	/* read current mtu value from device */
	err =3D usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
			      USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
			      0, iface_no, &max_datagram_size, 2);
	if (err < 0) {
		dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
		goto out;
	}

	if (le16_to_cpu(max_datagram_size) =3D=3D ctx->max_datagram_size)



AFAICS, there is no way max_datagram_size can be uninitialized here.
usbnet_read_cmd() either read 2 bytes into it or returned an error,
causing the access to be skipped.  Or am I missing something?

I tried to read the syzbot manual to figure out how to tell this to the
bot, but couldn't find that either.  Not my day today it seems ;-)

Please let me know what to do about this.


Bj=C3=B8rn
