Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CE12A4607
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 14:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgKCNOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 08:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbgKCNON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 08:14:13 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7088AC0613D1;
        Tue,  3 Nov 2020 05:14:13 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c18so12703203wme.2;
        Tue, 03 Nov 2020 05:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0YHS/4LvDDFoixg/k7JisZUeQpF8iffOcuETYi8OTNM=;
        b=KsCT0oU5Be7Ny6mUPzkvD3LP/R8aSjRvghI5F+bx6VwrdW+9CLs4SYYE54x7uxXWw9
         2CW4cxAxuiNw2W44+Lhqvr6U9vQmrkHimqRUM/Rib0XjrxUJsVyiSvhl0f4lFZXXcJV0
         cDzxz+aCR5Q3VezUrcVT92BufoY7hswt5BdAGYiCNkGeSjKcN9mbei45hLyVtn/Ui6Ud
         NxaWBiv5UIl/QBTy9w1051xCjjehcCsMHrMPmAumujDLla7rs0iaC9iQotaCCxtZQOu3
         HHNvl6AgipcCsKhOOhARP3pPrtYPcpD/glCpajFnUZL/fvU3rWD+aWj4n8xnUiDQPDxD
         2Opg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0YHS/4LvDDFoixg/k7JisZUeQpF8iffOcuETYi8OTNM=;
        b=qFFj2E4jru7xc0QMTApTB6OSxY6h6wdyqU4dp3QNNLeeUkBCPX7hsINW9YN5tJV/CR
         TslIxnL2nFchuyDnN/gPzHistXM6THd/RNQG5/pSPuopUc3/pkD0oImaZ715EaSGsd7F
         GL1LTsu/j/3kiiTaKYp8bMQMYECHyzmEclM+zEyJtr0OFwv2ZYz8fo7y6hX3jzr5GOje
         mqlvj2HMrfREzvX32y3/TEXsNgp7xY2fXP7EGhoG1QppTIQSUgSOxZfd7aysJXPGkp/q
         ZFxWwPl1rke42WMcy9DjWScz1e5NloBLhPu2Csbzg6In964LRLdDt8Z9bo2MfZjJx8Aa
         1t5Q==
X-Gm-Message-State: AOAM533LmP4G/KHU8OKHBPWdSdH7IrFQ9oxFizpCgZFbQPt0N72Jorfm
        aZdbd1uW9w6MJ8vZOUcVvZQrQlxYZCMZXGQJoCM=
X-Google-Smtp-Source: ABdhPJyKoUEqxpQ3azDqrh2rmOp4rCs0qSy/FJmsI6OGy0UTj/cujIjaMgNjok4OV6bvPXMShupPYM58wXVIUcR9rPs=
X-Received: by 2002:a05:600c:210:: with SMTP id 16mr3529929wmi.122.1604409252243;
 Tue, 03 Nov 2020 05:14:12 -0800 (PST)
MIME-Version: 1.0
References: <00000000000013259505a931dd26@google.com> <0000000000002d865a05b3051076@google.com>
In-Reply-To: <0000000000002d865a05b3051076@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 3 Nov 2020 21:14:00 +0800
Message-ID: <CADvbK_fo2_J6VzevRF2J805Hb6R+Zx7pk8iV-LDD8Xs2L_P7Fw@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in decode_session6
To:     syzbot <syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 1, 2020 at 1:40 PM syzbot
<syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit bcd623d8e9fa5f82bbd8cd464dc418d24139157b
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Thu Oct 29 07:05:05 2020 +0000
>
>     sctp: call sk_setup_caps in sctp_packet_transmit instead
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14df9cb8500000
> start commit:   68bb4665 Merge branch 'l2-multicast-forwarding-for-ocelot-..
> git tree:       net-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16df9cb8500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12df9cb8500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=eac680ae76558a0e
> dashboard link: https://syzkaller.appspot.com/bug?extid=5be8aebb1b7dfa90ef31
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11286398500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bbf398500000
>
> Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com
> Fixes: bcd623d8e9fa ("sctp: call sk_setup_caps in sctp_packet_transmit instead")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
I'm looking into this, Thanks.
