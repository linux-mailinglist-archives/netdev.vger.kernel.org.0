Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17BF4C18
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfKHMvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:51:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35426 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbfKHMvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 07:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573217480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zT3DRd+1FXC1nKqpTZwClAtzf5Bk9MH8wvbLAxN4qE=;
        b=cOW8eHpJA/n2nRDbPr3SHyVbCc8sKTV0ESSKqTbzqFBdnzG7OWDEBBxgyd1SNRPLJvkWc5
        w+eAURL4bF8Rcm8naFGHz5beo3DNRmB9NZN9KoBKgPAmgE/dwwGOEqe6csBCj6Z+r7MKV6
        /3FcVPMhO5+CUrkDuoe5A4Za3Bukc3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-ZMyCVXcFN9GdelQO6M-9WA-1; Fri, 08 Nov 2019 07:51:17 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AFDF107ACC3;
        Fri,  8 Nov 2019 12:51:15 +0000 (UTC)
Received: from elisabeth (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A0AF5C1BB;
        Fri,  8 Nov 2019 12:51:10 +0000 (UTC)
Date:   Fri, 8 Nov 2019 13:51:05 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     syzbot <syzbot+999bca54de2ee169c021@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dvyukov@google.com, frederic@kernel.org,
        fweisbec@gmail.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, yoshfuji@linux-ipv6.org
Subject: Re: KASAN: use-after-free Read in tick_sched_handle (3)
Message-ID: <20191108135105.674043a5@elisabeth>
In-Reply-To: <000000000000e139ab0596c1d4c0@google.com>
References: <0000000000007829c8057b0b58ed@google.com>
        <000000000000e139ab0596c1d4c0@google.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ZMyCVXcFN9GdelQO6M-9WA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 07 Nov 2019 05:42:07 -0800
syzbot <syzbot+999bca54de2ee169c021@syzkaller.appspotmail.com> wrote:

> syzbot suspects this bug was fixed by commit:
>=20
> commit bc6e019b6ee65ff4ebf3ca272f774cf6c67db669
> Author: Stefano Brivio <sbrivio@redhat.com>
> Date:   Thu Jan 3 20:43:34 2019 +0000
>=20
>      fou: Prevent unbounded recursion in GUE error handler also with UDP-=
Lite
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D119c0bc260=
0000
> start commit:   1c7fc5cb Linux 5.0-rc2
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D817708c0a0300=
f84
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D999bca54de2ee16=
9c021
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12c95a30c00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11df010740000=
0
>=20
> If the result looks correct, please mark the bug fixed by replying with:
>=20
> #syz fix: fou: Prevent unbounded recursion in GUE error handler also with=
 =20
> UDP-Lite
>=20
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion

#syz fix: fou: Prevent unbounded recursion in GUE error handler also with U=
DP-Lite

