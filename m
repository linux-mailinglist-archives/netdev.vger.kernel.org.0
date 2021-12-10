Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F346FFFC
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbhLJLhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbhLJLho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 06:37:44 -0500
X-Greylist: delayed 1883 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Dec 2021 03:34:09 PST
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE1C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:34:09 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1639136048; bh=6Ko2W5Utnb8zO1C6Trh35IUiOYWi8uF9Kk63fmaYNp0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PnnitpHFEDzWeZlNpR/WnUPHNlgJl7sfNlmm+clX2g4gsDFy14xAMt7ojOd5NE4YY
         74PJZjaNcBrybtTj8WpD5XVZXPw+nQABacSH5aRXxKNqpB1ONgNmYL1HQMOKWTIQUv
         1cqbqL6wgAQaHn9REBjfRj/vApuWs/p+LN2DZwTb/U8ebDNpMVdiv97Walwr5dphd5
         hyx5+ZYVAOqUtYxiG2qh0mSzaDcpGJoiSzs5HNmaAkTVNGqaV462K507aAOwGkEybR
         iK+S3iPVo/pia/BL3anRYhlRdm/VbMroNh7o9l3W/5jBiKJkWnNfcqLyh9Vfs/4V76
         0oRiVexeq2+mw==
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] sch_cake: do not call cake_destroy() from cake_init()
In-Reply-To: <CANn89iJRu_uHi__pYr-y5p3Gw_FzmvCEgnYoBa4EGiXRNzxuPw@mail.gmail.com>
References: <20211210081536.451881-1-eric.dumazet@gmail.com>
 <87ilvwwwmm.fsf@toke.dk>
 <CANn89iJRu_uHi__pYr-y5p3Gw_FzmvCEgnYoBa4EGiXRNzxuPw@mail.gmail.com>
Date:   Fri, 10 Dec 2021 12:34:06 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87czm4wv69.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> On Fri, Dec 10, 2021 at 3:02 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@to=
ke.dk> wrote:
>>
>> Eric Dumazet <eric.dumazet@gmail.com> writes:
>>
>> > From: Eric Dumazet <edumazet@google.com>
>> >
>> > qdiscs are not supposed to call their own destroy() method
>> > from init(), because core stack already does that.
>> >
>> > syzbot was able to trigger use after free:
>
>> >
>> > Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (ca=
ke) qdisc")
>> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>> > Reported-by: syzbot <syzkaller@googlegroups.com>
>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>
>> Oops, thanks for the fix! I'm a little puzzled with the patch has my
>> S-o-b, though? It should probably be replaced by:
>>
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> Right, user error from my side, I copied it from your commit changelog
> and forgot to s/Signed-off-by/Cc/

Ah, right, makes sense; no worries :)

-Toke
