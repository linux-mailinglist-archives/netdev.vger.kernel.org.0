Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27918DE49E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 08:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfJUGdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 02:33:04 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:33178 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfJUGdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 02:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1571639580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f8Na+LpUnC8JqDzImVYyMaPGE+qt4/Ni60vqdp8XrY8=;
        b=syXmfz8mKLUBM1cGhnWNvHBYSh0aKWq8MhW/asgTnjdfU2L/PxVDQdDyu8YF9k8y+pIyqs
        aSOIA4lTT3JstP8wWxFKYMQSLs0G1pUAyzE7YQJbs7sWyjV/hmLMWDJBbI0k2REkQ4xrKw
        T6nQAzCRX3HKyfei2AOTJuAUT71rS1E=
From:   Sven Eckelmann <sven@narfation.org>
To:     syzbot <syzbot+7dd2da51d8ae6f990403@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in batadv_iv_ogm_queue_add
Date:   Mon, 21 Oct 2019 08:32:27 +0200
Message-ID: <2128256.8pjUZaGXEE@bentobox>
In-Reply-To: <000000000000ccde8d059564d93d@google.com>
References: <000000000000ccde8d059564d93d@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3485240.qhH8nyTcuX"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3485240.qhH8nyTcuX
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, 21 October 2019 07:21:06 CEST syzbot wrote:
[...]
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+7dd2da51d8ae6f990403@syzkaller.appspotmail.com
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 4256 Comm: kworker/u4:0 Not tainted 5.4.0-rc3+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
> RIP: 0010:batadv_iv_ogm_queue_add+0x49/0x1120  
> net/batman-adv/bat_iv_ogm.c:605
> Code: 48 89 75 b8 48 89 4d c0 4c 89 45 b0 44 89 4d d0 e8 fc 02 46 fa 48 8d  
> 7b 03 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
> 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 18 0d 00 00
> RSP: 0018:ffff88805d2cfb80 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888092284000
> RDX: 0000000000000000 RSI: ffffffff872d1214 RDI: 0000000000000003
> RBP: ffff88805d2cfc18 R08: ffff888092284000 R09: 0000000000000001
> R10: ffffed100ba59f77 R11: 0000000000000003 R12: dffffc0000000000
> R13: ffffed101245080e R14: ffff888092284000 R15: 0000000100051cf6
> FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200002c0 CR3: 00000000a421b000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   batadv_iv_ogm_schedule+0xb0b/0xe50 net/batman-adv/bat_iv_ogm.c:813
>   batadv_iv_send_outstanding_bat_ogm_packet+0x580/0x760  
> net/batman-adv/bat_iv_ogm.c:1675

I am guessing that the fix for this is queued up since a while at 
 https://git.open-mesh.org/linux-merge.git/commit/40e220b4218bb3d278e5e8cc04ccdfd1c7ff8307

Kind regards,
	Sven
--nextPart3485240.qhH8nyTcuX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl2tUPsACgkQXYcKB8Em
e0ZceA/+OtAsNK+rKyCKhKluFI1maGPynDOVKdN3fkopRfC6pfxPDtjyvU6R4fbH
3XYTc6dQ8UBVltpEJ/0cNHCxuaEUjNRYM7rT3a+SD52ge/vJdIR1SdPpVY7UaQj9
plnFQBF7vSR/YoEfsXLyCFg1S/m237HGU4antFgJ7eNXgx/zSgKZ7tsXnaIDVbsP
iWsr+PXJ5RQzWDubFfDpJSyvCQn0XPztypLZRKsfa+bo73PqGn3WEWsA/I/QKwTu
7xUbIWtWEzqciX43489rtkAY2SvoeZAYPckXDs/D2udpdGEVJOLZ4xJCyDpVVfyR
+qm1au5OnHtKg4nMmyi60YLAmh+VN0t2E0GgByabgp7PQ6rgYIEB00Q2Muys1Mhn
agZ6Z9s4u118mjof9f8eJ1tv1Sx2aRRK+wBOvuOeb6tpoXSDqMV+YZP5TtZ9zETg
NN63hkKvbrhUYucyxWfkRI6x6pwbZHh3MoggT+34ShO/gzZdZV3S6IgDPpRhPYaL
Sjhno54NZ84oROcswA6b0gF2T/WD46ebZXxwjN0BIoThQX0U2fk/Hq4sCzTc0Fdt
7R3yK1SWI/yxLf2MHRqSm8MK066xj92gckB4VU8riRjUIbU+nt4mmTzRgdvXvsyY
UnrIIU0H3QSx+v56qHpFsFID5wu5BKjm2vKgrokmd9dSokXUSJs=
=GRad
-----END PGP SIGNATURE-----

--nextPart3485240.qhH8nyTcuX--



