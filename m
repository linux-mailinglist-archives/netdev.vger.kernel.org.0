Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7886E24BB0C
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgHTMWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbgHTJzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 05:55:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA50C061757;
        Thu, 20 Aug 2020 02:55:12 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k8hHZ-007L1T-Cn; Thu, 20 Aug 2020 11:54:53 +0200
Message-ID: <8d35f1aa44b4f228e104275a824adaacf0b36674.camel@sipsolutions.net>
Subject: Re: WARNING in __cfg80211_connect_result
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        syzbot <syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, kvalo@codeaurora.org,
        leon@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        syzkaller-bugs@googlegroups.com
Date:   Thu, 20 Aug 2020 11:54:51 +0200
In-Reply-To: <CAHmME9rd+54EOO-b=wmVxtzbvckET2WSMm-3q8LJmfp38A9ceg@mail.gmail.com>
References: <000000000000a7e38a05a997edb2@google.com>
         <0000000000005c13f505ad3f5c42@google.com>
         <CAHmME9rd+54EOO-b=wmVxtzbvckET2WSMm-3q8LJmfp38A9ceg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-08-20 at 11:47 +0200, Jason A. Donenfeld wrote:
> On Wed, Aug 19, 2020 at 8:42 PM syzbot
> <syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com> wrote:
> > syzbot has bisected this issue to:
> > 
> > commit e7096c131e5161fa3b8e52a650d7719d2857adfd
> > Author: Jason A. Donenfeld <Jason@zx2c4.com>
> > Date:   Sun Dec 8 23:27:34 2019 +0000
> > 
> >     net: WireGuard secure network tunnel
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175ad8b1900000
> > start commit:   e3ec1e8c net: eliminate meaningless memcpy to data in pskb..
> > git tree:       net-next
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=14dad8b1900000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10dad8b1900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
> > dashboard link: https://syzkaller.appspot.com/bug?extid=cc4c0f394e2611edba66
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d9de91900000
> > 
> > Reported-by: syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com
> > Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> 
> Having trouble linking this back to wireguard... Those oopses don't
> have anything to do with it either. Bisection error?

Probably the typical generic netlink issue - syzbot often hits the
generic netlink family by ID, rather than by name. So when it has a
kernel without WG a generic netlink family disappears, the later ones
get different IDs, and the issue no longer happens since the ID is now
no longer valid or hitting some completely different code path ...

johannes

