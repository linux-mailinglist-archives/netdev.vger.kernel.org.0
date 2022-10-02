Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79F25F2531
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 22:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJBUCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 16:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJBUCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 16:02:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F4F303F2;
        Sun,  2 Oct 2022 13:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6Ay8qiGMPx7dDTK6TPzxHoenhV4yP8MRk067A6uT+wM=;
        t=1664740957; x=1665950557; b=FvatK+jGcMNkt0Bm9lTNk44xem3xUytvPuUoSMAJ+lYhG1D
        BZhd+L+wczCn3EPZFFhq9l+WUIBq1sPxBzWBoU/J8NaNq6gfry9B5F4s+4R46Q8rO6d1sTBeRB7jG
        pFAh7A4ayRGKF9GgKiy/W156E8jyhKyq5Dq55+5NSigwsZ/hRGdRucTvXxlF2eC56Ao7iaWMTb32z
        CPQ0Gwn1yjKn6bHvkxv4oUvtmG9ehmlJgoeNQWkJ6WWPq8fBkaPq5qwEemyVkFCUK/qjwq+xs4rVP
        J8j2scmP07nNhdJo7H2p9GyvCj8kIUk6d8oHj3AX3WuBUHfkd2HQHQzcwqVL1WPQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1of5AT-00DaVw-2p;
        Sun, 02 Oct 2022 22:02:29 +0200
Message-ID: <026ada86847b6f5a9f89cf005b5d75d035ff6a19.camel@sipsolutions.net>
Subject: Re: [syzbot] WARNING: lock held when returning to user space in
 ieee80211_change_mac
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+4ef359e6b423499fa4e1@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Date:   Sun, 02 Oct 2022 22:02:28 +0200
In-Reply-To: <0000000000001850d105e9f9e6de@google.com>
References: <0000000000001850d105e9f9e6de@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-10-01 at 07:26 -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    6627a2074d5c net/smc: Support SO_REUSEPORT
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10183a7088000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd4d64087513b5=
aa1
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4ef359e6b423499=
fa4e1
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/9ecb75606956/dis=
k-6627a207.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1073865fcb40/vmlinu=
x-6627a207.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4ef359e6b423499fa4e1@syzkaller.appspotmail.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> 6.0.0-rc6-syzkaller-01407-g6627a2074d5c #0 Not tainted
> ------------------------------------------------
> syz-executor.3/10164 is leaving the kernel with locks still held!
> 1 lock held by syz-executor.3/10164:
>  #0: ffff888147acaa88 (&local->mtx){+.+.}-{3:3}, at: ieee80211_can_powere=
d_addr_change net/mac80211/iface.c:217 [inline]
>  #0: ffff888147acaa88 (&local->mtx){+.+.}-{3:3}, at: ieee80211_change_mac=
+0x9b4/0xf40 net/mac80211/iface.c:264
>=20

Uh, right. Pretty sure this will fix it once I merge it:

https://patchwork.kernel.org/project/linux-wireless/patch/Yx9LJFA7PDSRmb/M@=
kili/

johannes
