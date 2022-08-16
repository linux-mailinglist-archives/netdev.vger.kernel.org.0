Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F0B595F2E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiHPPfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiHPPer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:34:47 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0620F6169;
        Tue, 16 Aug 2022 08:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vRiWoChp5wf/4E0/DJUXs0PJ+PnRLOBn4qlJMVYcMe0=;
        t=1660664074; x=1661873674; b=ray5ujAc4zk6pPxqTsxTnCqcZle5SliSNqVYX3EDCBLCkmI
        mHdHwMlNvvJd69SkfKszBJ2EVT9dJ8hLT7ouWD3Ri5oJbw2U+eU2MasC+09LA594AoP7QUH3ZkfD+
        TAt+rBrf8NAbGLZGy1bTPYHVU3qNsb44iHaprKtyF0GtP2xENJX6e6fuv89WNTjT3aRU3VTHd89sp
        5M/v62R90RT71pP5o9OAwln6fNncOT65MbZBTziWdnUTO39v9WHNxyBODJIbe2AG47lXljQ4YUEeB
        cXfWqkgzRSnGoKV4ZqbU2ab4raZu1AYNL2jUyjjaBxRQwuEbh+Pn6X1Rrj8Wlohw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNyaE-009Zia-1G;
        Tue, 16 Aug 2022 17:34:22 +0200
Message-ID: <e81595d0373962b8a9d6e8a6cf97460c513e8926.camel@sipsolutions.net>
Subject: Re: [syzbot] upstream boot error: general protection fault in
 nl80211_put_iface_combinations
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     syzbot <syzbot+684d4ca200fda0b2141e@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Date:   Tue, 16 Aug 2022 17:34:21 +0200
In-Reply-To: <20220816153345.GA2905014@roeck-us.net>
References: <00000000000033169005e657a852@google.com>
         <6a7b0bc82647440a9036a8e637807da618552cc5.camel@sipsolutions.net>
         <20220816153345.GA2905014@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-16 at 08:33 -0700, Guenter Roeck wrote:
> On Tue, Aug 16, 2022 at 05:11:32PM +0200, Johannes Berg wrote:
> > Hmm.
> >=20
> > > HEAD commit:    568035b01cfb Linux 6.0-rc1
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D145d8a470=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D126b81cc3=
ce4f07e
> > >=20
> >=20
> > I can't reproduce this, and I don't see anything obviously wrong with
> > the code there in hwsim either.
> >=20
> > Similarly with
> > https://syzkaller.appspot.com/bug?extid=3D655209e079e67502f2da
> >=20
> > Anyone have any ideas what to do next?
> >=20
> Ignore it. It is caused by a problem in virtio. See revert series at
> https://lore.kernel.org/lkml/20220816053602.173815-1-mst@redhat.com/
>=20

Oh! OK, great, thanks! :)

johannes
