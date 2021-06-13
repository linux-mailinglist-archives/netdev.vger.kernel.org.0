Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB43A58BA
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhFMNiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 09:38:00 -0400
Received: from mout.gmx.net ([212.227.17.22]:55865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231738AbhFMNiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 09:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1623591348;
        bh=1ZFz1/mIB5bnttffrzVRdlzUMFRiToLqs1Cx70F/Amg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=MEP/7dKvW9Lon3sGRdxs3ybRvk7Ztnq8/LNDyRd4KMcONHy2Yx9thdJADCYBlPbF+
         LYPRXdCnNxriSjmUQmWON4JuoOv3pedN/4CqpmTGgYarxEiGcGkXbWuanlwb1YaDaZ
         1D1yIfGZo3QP0NBdNiSuma+Z1VHDbFIVErnZ/Fw4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [88.130.61.210] ([88.130.61.210]) by web-mail.gmx.net
 (3c-app-gmx-bap71.server.lan [172.19.172.171]) (via HTTP); Sun, 13 Jun 2021
 15:35:48 +0200
MIME-Version: 1.0
Message-ID: <trinity-0d8be729-1e3c-452c-8171-962963abed0d-1623591348277@3c-app-gmx-bap71>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     Patrick Menschel <menschel.p@posteo.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 13 Jun 2021 15:35:48 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <34cc6b6a-6eb0-f3ce-1864-9057b80fab9e@posteo.de>
References: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
 <f9d008bc-2416-8032-0005-35d7c6d87fc1@hartkopp.net>
 <34cc6b6a-6eb0-f3ce-1864-9057b80fab9e@posteo.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:3XXrmPETE/w+QQQSBfRwD8jlRdcWg0F4qeUVnsI2jxRZEnIM9y8sUU+H+zgX0s45v83oM
 gfDilZI82cCAc6K2COQh5NUQT39eDl1ZdoANWdJe5jjybCAyaMw68Ir7hLX7gjkEGU6FvqnP4BLc
 Zkdn4SqgPNPwfYPA3HH3t3y1v3q1F2WIF37Q+Dl75vfJTpvGnXZsZ2YYouoi4VTnmYG8Qtgh3uz+
 IhS9KpbppL1odOt8RFf1qmHfc0Y4sql6vg2LMNKXyvx1+Ljy34rKtufPvxrTVHLmefVFeGE9r48N
 D0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:r+vepHbWli4=:PwJ8/RS50nQhfIw7wsSj5Q
 cu8Rcc4JKlwYV4H6KnoAGOfl2mQT5KXRWoeyNbKjfxxhjK6VrPYA6IKASR8Qa2uXOdpefDHwQ
 g2B5m217mOCif+lNIJUpKmqhh4Qg3+hswtoFEdhiaz3HoFAFq8YF3tIkUJry5GVAFOEnkYZRz
 /ofJrTH1BHcuopAxzUrGIgoctgEkXUJp9CGNNoMbf1FztjF2IyoVWIu8Ljutl+vVI9EqGMliU
 OUaeSsR64TXTvZT9Zlpem5UydvZYG6SWm9iR8r5HQkx1p3Y62A5h9bgq+3dRBIJ9HrC0h5y1y
 o2b8l0G/HniRrM0fdosePBeKPyW42L6mn6Cnh0ArNPsuuim10kfiQAyet06UVXMJ0yuy8TO22
 I4LroPMHydVaG71GC2UmpWPJjujUjGLyqXKLTVbxTQ4IE+otmcE6bEc746Mgf9/9JZLULO14v
 zlECHK+F+uoGoxZrmtQfCwAt1kagh5KJcDPhx2909ttduwLTZD+cLSh1AZOSqxK2ej4I/W+b0
 S32wEuVS4XuNRlaAJHJKTvGySCBiSeFyGLS5JGDoDwTESyDxVBc8q+p+2gMBfpa9oM7H4VCFl
 wx4JQlVnNo4AYzFL4kAT73zgVfY2JMHRkGdwUhL3jJ+Tgwq576MDzhTt+vRD6hdhhHpgmlc5h
 PomJwU8kwLevKZ3kBC7PZ8LTylo/rxuwmS+HQvQkdpWCNUB3wwF42+31+fkyXzY3ivLItsVeH
 RfEwF05R1fEpKnKWVDsQ1nna1b9/tjiRzihj5LYGpqCIFSqJEzgnmYAVuq5Ne3qaHmUUH23B8
 YycXy6zFD/bgzlQX07Mq/YgtR2J6A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Hi,
>
>1.
>Are you sure this leak really happens on 64-bit and not on 32-bit instead?
>
>I remember I got the problems with bcm msg head on the 32bit raspberry
>pi because I missed the alignment by accident.
>
>When I calculate the size of msg head on a Ryzen 1800X with Python
>3.9.5, I get:
>
>struct.calcsize("IIIllllII"),struct.calcsize("IIIllllII0q")
>(56, 56)
>
>First Value is raw, the second value is the alignment hack with the zero
>length quad word "0q".
>
>On the 32bit raspberry pi, same op results in the gap.
>
>struct.calcsize("IIIllllII"),struct.calcsize("IIIllllII0q")
>(36, 40)

Hey Patrick,

having reproduced this leak I could only observe the issue on 64-bit systems.
I've just tested it on a 32-bit OS running on a raspberry pi and I couldn't observe
any leak. The offset difference on 32-bit between count and ival1 is 4.
On 64-bit systems, it's 8:

(gdb) ptype struct bcm_msg_head
type = struct bcm_msg_head {
    __u32 opcode;
    __u32 flags;
    __u32 count;
    struct bcm_timeval ival1;
    struct bcm_timeval ival2;
    canid_t can_id;
    __u32 nframes;
    struct can_frame frames[0];
}
(gdb) p/x &((struct bcm_msg_head *)0x0)->count
$1 = 0x8
(gdb) p/x &((struct bcm_msg_head *)0x0)->ival1
$2 = 0x10
(gdb) p sizeof(((struct bcm_msg_head *)0x0)->count)
$3 = 4

>2.
>Finding stucts with non-zero-ed gaps should be easy with a skript or
>even better with a GCC directive. I believe Syzbot does such a thing too.
>
>Kind Regards,
>Patrick Menschel

I didn't notice any syzbot report about this leak, nor did I find it with syzkaller.

Norbert
