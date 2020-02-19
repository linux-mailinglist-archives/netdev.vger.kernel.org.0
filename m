Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9A0163D44
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgBSGuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:50:40 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:59167 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgBSGuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 01:50:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2C7F3CC00F8;
        Wed, 19 Feb 2020 07:50:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1582095036; x=1583909437; bh=6N/wx1PPm7
        0XWkAYLWsXauw4+sMVlpaGdfM/XPXQNfs=; b=P8l5AL1uJmdf4WSO/J4pKD+6nV
        0fPeRbqTfRajP8An38Xf7agnkiU0vDzIVPuQG32BZwMeZUQgKhN4rDOC2jqi2xim
        i20JDuOzx9m4pGbAu8EXYZN2ETn5xnENKKjTTF1g1ayRFaKKFgoPjBRLCKWBPwFz
        3ewJn1A287yoxasEg=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 19 Feb 2020 07:50:36 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id DC736CC00F3;
        Wed, 19 Feb 2020 07:50:33 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 6720120FCF; Wed, 19 Feb 2020 07:50:33 +0100 (CET)
Date:   Wed, 19 Feb 2020 07:50:33 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     syzbot <syzbot+8b5f151de2f35100bbc5@syzkaller.appspotmail.com>
cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        florent.fourcot@wifirst.fr, Florian Westphal <fw@strlen.de>,
        jeremy@azazel.net, johannes.berg@intel.com,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        tanhuazhong@huawei.com
Subject: Re: KASAN: use-after-free Read in bitmap_ip_destroy
In-Reply-To: <0000000000000d774c059ee442e6@google.com>
Message-ID: <alpine.DEB.2.20.2002190746590.20111@blackhole.kfki.hu>
References: <0000000000000d774c059ee442e6@google.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="110363376-950394365-1582095033=:20111"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-950394365-1582095033=:20111
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


#syz fix: netfilter: ipset: use bitmap infrastructure completely

On Tue, 18 Feb 2020, syzbot wrote:

> syzbot suspects this bug was fixed by commit:
>=20
> commit 32c72165dbd0e246e69d16a3ad348a4851afd415
> Author: Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu>
> Date:   Sun Jan 19 21:06:49 2020 +0000
>=20
>     netfilter: ipset: use bitmap infrastructure completely
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D17fc79b5e0=
0000
> start commit:   8f8972a3 Merge tag 'mtd/fixes-for-5.5-rc7' of git://git.k=
e..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dcfbb8fa33f49f=
9f3
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D8b5f151de2f3510=
0bbc5
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e22559e00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16056faee0000=
0
>=20
> If the result looks correct, please mark the bug fixed by replying with:
>=20
> #syz fix: netfilter: ipset: use bitmap infrastructure completely
>=20
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-950394365-1582095033=:20111--
