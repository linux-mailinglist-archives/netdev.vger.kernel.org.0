Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1892C2AEF8A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKKLYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKKLYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:24:12 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D696C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:24:12 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id q5so1229922qkc.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 03:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9xuuackRiUtSlBLGiQKxEWTouJw8FNaN4sTCD1uCgDI=;
        b=V784RG0ZxTqWeGqccapJoQKyASlqnIeTcLEt2WHsTCnwpYl87gsvLifzB7MSEEeZXl
         GcSqETlsdOXus3WAznjJPOxZvxnMkDZPw6zqqE6Ux0TpGzhsZOk5InJ5xSdmaJyVPSTt
         OYSkEZ1lbSvh8tKeXmNU6lbcRJ2nqhyvqVb1Kf72ilGwhh9GnIfsjvzNV+PU+sImaJoa
         G58OsJ9a1YUmO5V0Tqtf3rJDRfF3OOv/ykSVKaHtBX8PHgMZ+RgiJOGz9v0jxdeUcBeu
         JwSxieds2pqwEe3Mznw7R/vQi5dEa6CxcUI/m24vJ0uZ6CmnJwsMLJrz7UdxbgQA8641
         u6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xuuackRiUtSlBLGiQKxEWTouJw8FNaN4sTCD1uCgDI=;
        b=lFu/+DmUr52h3fn6Wwx2LODJ9OQ0dHf0blPcl21PeY0k9JKEsi3QsNV8ZY1qwXBSt1
         VMgJMpuOgNadFuGzDJUQSwAT+tLBzMAUoSQpis0E7IEASf1xxk7tfIZq3RUrEDwnY4ER
         vR3L3juUBOmvsEGP3WGBpPNXYZV4k+kMssRwZhJmZX2d2dv61/4PAKsSdmjKY069C8LZ
         l8kUSwwqZ+E9siddH++CLnNIxjqdtgUgU4u0zvDNgG3QmyiU4zfGyHBkEEBuzhC4dG6p
         qLUuMxcFtsOaSNKFs2ihT6CXgJeKq3F9n0KHziqZErpwK97PYzoYTL8bvB+6tLiwq5tk
         R5rg==
X-Gm-Message-State: AOAM533qvAoOhLND56C19SQbQzN8xyQt5qWTkk3mGJmCyypduu8bJVKC
        Q01FLEel4BgUHRmt3n5E3GnrJct0BE1YJikb2vx7Qg==
X-Google-Smtp-Source: ABdhPJxz85C1QiSraIe+0/ik6klqSjxR0dhVn3yUQJMS8OEiywLd9K3IYTCQYGHlsh9E1uvMS4jje7Dsi/of7RrzgOI=
X-Received: by 2002:a37:49d6:: with SMTP id w205mr24434650qka.501.1605093851351;
 Wed, 11 Nov 2020 03:24:11 -0800 (PST)
MIME-Version: 1.0
References: <00000000000053e07805a9b61e09@google.com> <000000000000ba6a2d05ac300953@google.com>
In-Reply-To: <000000000000ba6a2d05ac300953@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 12:24:00 +0100
Message-ID: <CACT4Y+ZFqCBRhnJxv09QEZqm3eNym5vyLUHGpZfHY58DQ=YLKQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __cfg8NUM_wpan_dev_from_attrs (2)
To:     syzbot <syzbot+14e0e4960091ffae7cf7@syzkaller.appspotmail.com>
Cc:     alex.aring@gmail.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 9:00 AM syzbot
<syzbot+14e0e4960091ffae7cf7@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit bf64ff4c2aac65d680dc639a511c781cf6b6ec08
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Sat Jun 27 07:12:24 2020 +0000
>
>     genetlink: get rid of family->attrbuf
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12069494900000
> start commit:   e44f65fd xen-netfront: remove redundant assignment to vari..
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
> dashboard link: https://syzkaller.appspot.com/bug?extid=14e0e4960091ffae7cf7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11818aa7100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f997d3100000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: genetlink: get rid of family->attrbuf
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: genetlink: get rid of family->attrbuf
