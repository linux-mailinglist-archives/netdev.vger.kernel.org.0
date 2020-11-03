Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EB52A46F0
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 14:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgKCNwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 08:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729498AbgKCNwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 08:52:23 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357B9C0613D1;
        Tue,  3 Nov 2020 05:52:23 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id p19so3446289wmg.0;
        Tue, 03 Nov 2020 05:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xu+xro/ZCgia8r39GAj0uv1l/oSQCE9B06Tu/+jZ4jY=;
        b=aGT6RWfWiqL0t2cizwEyiYzERywVUOqlhBkYO9uqeVXBco8CXkeW2QGI5KgrOYakOR
         qrjAm313tMSJrtg8sqRFlcqDSVN7ybOR/AEUdv3v+y6As+pRzgPC3+BoOJ+So7NJL2gm
         9NV7dy4v98qHEgrhn5iK2SyDz7oSFogTL8tP5NLtce6GEpjKPRBLYuGEd1CS+BTBMg5B
         jdh+XoJtJJh8TMGikH47tOeTwKT/rARNJpr087UVT4L5xWdRLQILPankwPoiU8WJVqjl
         hpaZmweC1DM3t1ypWRGV06jpktH3Ny692yy0QKPMK9w5C5mM5MV3qdD3cKeOWdktK1/A
         z2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xu+xro/ZCgia8r39GAj0uv1l/oSQCE9B06Tu/+jZ4jY=;
        b=HgkM4qbzbYK4n/tuPEZA21tFCzAioClTTtTDSJZsoKlEgmDn5AwPJzPGf6V/xiyIne
         5RK0PFRaARhvpYx0bi/X/Vq1hDn5mMHp4NRFznFF9HwiskFhswo1L4NzGJCwFQLCeEfa
         qOOyy0hpUMfrI0RL9/L8vUHCEwkoEF514Wych2Vah5AtJyoAsQhlWmHy0dcMNerKGGj4
         y/WCFeyiIjQJgmgcALtn2BYUSL4HAN73N4Slo083DlKyH5RlbTAwAc7Nfc/Egxu+ttbV
         ih5kxDZjy/HnOfCB4SKtB8uv3jgNREs7usqZHnVupVpcOArzVR2Ph3Eq7igFW/qyptAm
         LWCw==
X-Gm-Message-State: AOAM531yN+g63vGkGSeNyea8XjSFrODZv5KqUz+fYxQDzBzBCLxSfEfw
        zaQbD6f5pbKo4ozGWTTj9/omMEo6AMtQ9cZt5T0=
X-Google-Smtp-Source: ABdhPJxzmKx33Z0zB5kBjXijem14sn56szX+GBj6vIrYQ8GEwdJ5uSfZnV9cRG7hUtO24PiFAd8BuOzLEtURoh+y6n0=
X-Received: by 2002:a7b:ce0e:: with SMTP id m14mr3687814wmc.111.1604411541931;
 Tue, 03 Nov 2020 05:52:21 -0800 (PST)
MIME-Version: 1.0
References: <00000000000013259505a931dd26@google.com> <0000000000002d865a05b3051076@google.com>
 <CADvbK_fo2_J6VzevRF2J805Hb6R+Zx7pk8iV-LDD8Xs2L_P7Fw@mail.gmail.com>
In-Reply-To: <CADvbK_fo2_J6VzevRF2J805Hb6R+Zx7pk8iV-LDD8Xs2L_P7Fw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 3 Nov 2020 21:52:10 +0800
Message-ID: <CADvbK_e6jD_wvo+iz9oNHEjOKa=Xsy9OhnEbV1M8kDWp=qnxwA@mail.gmail.com>
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

On Tue, Nov 3, 2020 at 9:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Sun, Nov 1, 2020 at 1:40 PM syzbot
> <syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this issue to:
> >
> > commit bcd623d8e9fa5f82bbd8cd464dc418d24139157b
> > Author: Xin Long <lucien.xin@gmail.com>
> > Date:   Thu Oct 29 07:05:05 2020 +0000
> >
> >     sctp: call sk_setup_caps in sctp_packet_transmit instead
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14df9cb8500000
> > start commit:   68bb4665 Merge branch 'l2-multicast-forwarding-for-ocelot-..
> > git tree:       net-next
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=16df9cb8500000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12df9cb8500000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=eac680ae76558a0e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5be8aebb1b7dfa90ef31
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11286398500000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bbf398500000
> >
> > Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com
> > Fixes: bcd623d8e9fa ("sctp: call sk_setup_caps in sctp_packet_transmit instead")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> I'm looking into this, Thanks.
This was actually caused by:

commit a1dd2cf2f1aedabc2ca9bb4f90231a521c52d8eb
Author: Xin Long <lucien.xin@gmail.com>
Date:   Thu Oct 29 15:05:03 2020 +0800

    sctp: allow changing transport encap_port by peer packets

where the IP6CB was overwritten by SCTP_INPUT_CB.

inet6_skb_parmI will fix it by bringing inet6_skb_parm back to sctp_input_cb:

 struct sctp_input_cb {
+       union {
+               struct inet_skb_parm    h4;
+#if IS_ENABLED(CONFIG_IPV6)
+               struct inet6_skb_parm   h6;
+#endif
+       } header;
+       __be16 encap_port;
        struct sctp_chunk *chunk;
        struct sctp_af *af;
-       __be16 encap_port;
 };

Will post it soon, Thanks.
