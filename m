Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5872024BBEC
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgHTMf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:35:57 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:39071 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgHTJsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:07 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2a71feb8;
        Thu, 20 Aug 2020 09:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=cC4XKmjMItkWu82Ddd4N3/mfNJY=; b=aH3z0j
        ih2A6UbHCt3IxPb9cGURoW1AdUF79cwHzp+slOvV8CXFkpZjl6EwYEA+JlKT5gjg
        zXUFARHfV2sFXTmSREd8NhJunCIHY4nLafXpXu1CpMGAdsfYq1ZI7Ulbh+f6nFuU
        GLpyQGqn20N+3jb0blAVWJ4mBsKgajaVO0bu5fJURP7VRaYN89n0QypNDmBbRufv
        ee0CyvIMq5UV+mGRrzaGLR7yKNhLsfMBrsRgpAAPY0ix1nrsuR83acVzKS7914El
        0vW2TT1WjeT+Ulx5s/6fFxHTTSITqe0SO9LaYWBs5aRN38VHZxd5DoUNpQtc1oJx
        mQHl+eYy/l9WTo+Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 18dd5401 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 20 Aug 2020 09:21:41 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id z17so385964ioi.6;
        Thu, 20 Aug 2020 02:48:06 -0700 (PDT)
X-Gm-Message-State: AOAM533pN3W79s134djddKcgXm3DtAhueZEDHWNsMOx+g89DE9LGy6Z0
        nvgqpWN0nwu7SaecnD3KF0JrCiBgFDzwFZD/hPw=
X-Google-Smtp-Source: ABdhPJwxqXuh3zpZ+vXV6pG3wfV26J+WMkYRDPSnD0jh7SwXM3vLbJ0QIOl7CaiQOrNMVRuAQnK6mTMYW9n8YZipXUs=
X-Received: by 2002:a05:6638:138a:: with SMTP id w10mr2407389jad.36.1597916885689;
 Thu, 20 Aug 2020 02:48:05 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a7e38a05a997edb2@google.com> <0000000000005c13f505ad3f5c42@google.com>
In-Reply-To: <0000000000005c13f505ad3f5c42@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Aug 2020 11:47:54 +0200
X-Gmail-Original-Message-ID: <CAHmME9rd+54EOO-b=wmVxtzbvckET2WSMm-3q8LJmfp38A9ceg@mail.gmail.com>
Message-ID: <CAHmME9rd+54EOO-b=wmVxtzbvckET2WSMm-3q8LJmfp38A9ceg@mail.gmail.com>
Subject: Re: WARNING in __cfg80211_connect_result
To:     syzbot <syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, kvalo@codeaurora.org,
        leon@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 8:42 PM syzbot
<syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit e7096c131e5161fa3b8e52a650d7719d2857adfd
> Author: Jason A. Donenfeld <Jason@zx2c4.com>
> Date:   Sun Dec 8 23:27:34 2019 +0000
>
>     net: WireGuard secure network tunnel
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175ad8b1900000
> start commit:   e3ec1e8c net: eliminate meaningless memcpy to data in pskb..
> git tree:       net-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14dad8b1900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10dad8b1900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
> dashboard link: https://syzkaller.appspot.com/bug?extid=cc4c0f394e2611edba66
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d9de91900000
>
> Reported-by: syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com
> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")

Having trouble linking this back to wireguard... Those oopses don't
have anything to do with it either. Bisection error?
