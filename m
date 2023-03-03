Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA436A9AF0
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 16:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjCCPpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 10:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjCCPpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 10:45:06 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAA213510;
        Fri,  3 Mar 2023 07:45:01 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B818F240005;
        Fri,  3 Mar 2023 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677858299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBb5NZZHWMS7OOzC2BgZpLywcBgzQ152iDOosFWmf5o=;
        b=EIIzxHOEDJq8JNssE+YZBG/+eHaOJXYNW/LpxfMisf8pjZiXTWwGQvkqdWQZxlm/WoF1Sa
        JNf8nF1ehjNhXgcDsDRqolF6qiJUlsWI8EAIVYvuzvB2xmOQESsnTGp04EcHt/vQBXG1Vg
        F6K/J2Vv9aTPQvg0v2Ruf9YMl6Pe05TlCgnlx2iM1fw0zMxHY5dwNNgC/d1QpxAutvvgmF
        ouURjwikQp9wbsI+yp1xVqL4AEv6ZRVLvTiTHpM4pXSpJKU7whDQwtEoXMzDn2YQYB7sm8
        coK9tTLKY+QAHYbEs0ujqpwrUak5iSpGu7+61uXH2aQ/BPDGgm4f+SRr+ztraw==
Date:   Fri, 3 Mar 2023 16:44:56 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     syzbot <syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com>,
        alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [wpan?] general protection fault in
 nl802154_trigger_scan
Message-ID: <20230303164456.603c2ebd@xps-13>
In-Reply-To: <ZAISIS/h9UV6Ox+r@corigine.com>
References: <000000000000adec0205f5ffcaf4@google.com>
        <ZAISIS/h9UV6Ox+r@corigine.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

simon.horman@corigine.com wrote on Fri, 3 Mar 2023 16:28:33 +0100:

> On Fri, Mar 03, 2023 at 06:30:49AM -0800, syzbot wrote:
> > Hello,
> >=20
> > syzbot found the following issue on:
> >=20
> > HEAD commit:    f3a2439f20d9 Merge tag 'rproc-v6.3' of git://git.kernel=
.or..
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D12df1a7f480=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D81f5afa0c20=
1c8de
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbd85b31816913=
a32e473
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binu=
tils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1597f254c=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15053e40c80=
000
> >=20
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/0719d575f3ac/d=
isk-f3a2439f.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/4176aabb67b5/vmli=
nux-f3a2439f.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/2b0e3c0ab205=
/bzImage-f3a2439f.xz
> >=20
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com
> >=20
> > general protection fault, probably for non-canonical address 0xdffffc00=
00000000: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 1 PID: 5076 Comm: syz-executor386 Not tainted 6.2.0-syzkaller-1248=
5-gf3a2439f20d9 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 02/16/2023
> > RIP: 0010:nla_get_u8 include/net/netlink.h:1658 [inline]
> > RIP: 0010:nl802154_trigger_scan+0x132/0xc90 net/ieee802154/nl802154.c:1=
415
> > Code: 48 c1 ea 03 80 3c 02 00 0f 85 3f 0a 00 00 48 8b ad f8 00 00 00 48=
 b8 00 00 00 00 00 fc ff df 48 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 =
48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 d0 07 00 00
> > RSP: 0018:ffffc90003397568 EFLAGS: 00010247
> > RAX: dffffc0000000000 RBX: ffffc900033975d8 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff89cec1a1 RDI: 0000000000000004
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000001
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff888146fb4c90
> > R13: ffff888146f82000 R14: ffff888146f820a0 R15: ffffc900033975f8
> > FS:  0000555556c9b300(0000) GS:ffff8880b9900000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055be8d9c04f0 CR3: 0000000023513000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
> >  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
> >  genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
> >  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> >  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> >  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> >  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> >  sock_sendmsg_nosec net/socket.c:722 [inline]
> >  sock_sendmsg+0xde/0x190 net/socket.c:745
> >  ____sys_sendmsg+0x71c/0x900 net/socket.c:2504
> >  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2558
> >  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2587
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f416cc9ee69
> > Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fff243fe498 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00007f416cd17380 RCX: 00007f416cc9ee69
> > RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 001d00000000000c
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
> > R13: 0000000000000003 R14: 00007fff243fe4b7 R15: 00007fff243fe4ba
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:nla_get_u8 include/net/netlink.h:1658 [inline]
> > RIP: 0010:nl802154_trigger_scan+0x132/0xc90 net/ieee802154/nl802154.c:1=
415
> > Code: 48 c1 ea 03 80 3c 02 00 0f 85 3f 0a 00 00 48 8b ad f8 00 00 00 48=
 b8 00 00 00 00 00 fc ff df 48 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 =
48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 d0 07 00 00
> > RSP: 0018:ffffc90003397568 EFLAGS: 00010247
> > RAX: dffffc0000000000 RBX: ffffc900033975d8 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff89cec1a1 RDI: 0000000000000004
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000001
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff888146fb4c90
> > R13: ffff888146f82000 R14: ffff888146f820a0 R15: ffffc900033975f8
> > FS:  0000555556c9b300(0000) GS:ffff8880b9900000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055be8d9c04f0 CR3: 0000000023513000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > ----------------
> > Code disassembly (best guess):
> >    0:	48 c1 ea 03          	shr    $0x3,%rdx
> >    4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
> >    8:	0f 85 3f 0a 00 00    	jne    0xa4d
> >    e:	48 8b ad f8 00 00 00 	mov    0xf8(%rbp),%rbp
> >   15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
> >   1c:	fc ff df
> >   1f:	48 8d 7d 04          	lea    0x4(%rbp),%rdi
> >   23:	48 89 fa             	mov    %rdi,%rdx
> >   26:	48 c1 ea 03          	shr    $0x3,%rdx
> > * 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping inst=
ruction
> >   2e:	48 89 fa             	mov    %rdi,%rdx
> >   31:	83 e2 07             	and    $0x7,%edx
> >   34:	38 d0                	cmp    %dl,%al
> >   36:	7f 08                	jg     0x40
> >   38:	84 c0                	test   %al,%al
> >   3a:	0f 85 d0 07 00 00    	jne    0x810 =20
>=20
> I believe this is fixed here:
>=20
> - [PATCH net] ieee802154: Prevent user from crashing the host
>   https://lore.kernel.org/netdev/20230301154450.547716-1-miquel.raynal@bo=
otlin.com/
>=20
> - pull-request: ieee802154 for net 2023-03-02
>   https://lore.kernel.org/netdev/20230302153032.1312755-1-stefan@datenfre=
ihafen.org/

Hopefully, yes :)

Thanks,
Miqu=C3=A8l
