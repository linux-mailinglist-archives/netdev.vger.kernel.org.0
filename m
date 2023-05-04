Return-Path: <netdev+bounces-315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 990196F703C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB0AD1C21225
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562B1BA2D;
	Thu,  4 May 2023 16:51:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48576A954
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:51:17 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987581716
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 09:51:15 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f0a2f8216fso788571cf.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 09:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683219075; x=1685811075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smUXkej0xPzQw1tg67ntvigJgPPhrNFSnWepihD6ur8=;
        b=K1oJeQe320jy4VAtg3hw+5lreYPqWQXRA2DhbRqCx+JumP5I+wGtVUapJkj4xbP5Gc
         LekZghaozR/4Qo4Man59/cjwsyO1mWdp1HYs2Up0YspSfb5Y09KyJUACWQO64fh2SfhT
         /WrgNUBfJy561g+iLGCchaOa0QJrOGh+51kgnejTI4ms2xjEgy0cE0eYTdIcQfuaBbj2
         laz1HzpEdBlAd4yN3mcFlfSFxvlDATXF+jgnemjKagcvfb4oBUn6y5WhU1hAzE9eLHd8
         YBShAagG+6NldxNv9bhLZFUy84FIwetvoEpA2oDHLtvoPB+boKrhKz9OSAuX1NBtfLR1
         3Mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683219075; x=1685811075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smUXkej0xPzQw1tg67ntvigJgPPhrNFSnWepihD6ur8=;
        b=IKnJGIcnzUPkOnKFnosc4W1Jku8eBJ3/DuiKmMBtBPGJuVJXVycbbr0Z5TnEcY7dYm
         6dYMNgBx4ug3WsrQWu3yizn+6jWi0GYhTJ2FsNzfa8jWVm4D3iXn8LWGlAa2EoXQWnfk
         8iYYQyUFbxZaidUaEtbrMZFnHq2l44Cq/YtP8oreQkT8XcQPVMjQTwkIRAUESpkdRYiy
         5/Z6dmprJLTkWd5XZGbk1ldKPWz0l8nsneLKt79BSnqOwr/4SYiN6QX+QCUOvD6z2Opx
         R+nIx3NO3pjJkytDLkv7VX7iMSzqOAhailnwZcIPunnR/2AA0cWus0ikqPY2OFFIBfXX
         uORQ==
X-Gm-Message-State: AC+VfDxPTiu/qwzU/pHvGNpTJ08TfB4TvCl+4G9XWElZKqYQU33kQtPU
	F5sgcOF+GZSynPWVSQjzLggucfaHmkwzuLGmmXcKpQ==
X-Google-Smtp-Source: ACHHUZ57M6XvrZOUlJI4JuZPd/5ZX1/+KJTt4pAsY8OkJ3eOXQG7rcN0DdhPWJ3waUZhDaSXwPJ+uOusE1Vz1WLvmCE=
X-Received: by 2002:ac8:7f8c:0:b0:3f1:f8d0:a3a7 with SMTP id
 z12-20020ac87f8c000000b003f1f8d0a3a7mr498652qtj.8.1683219074618; Thu, 04 May
 2023 09:51:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000951c2505d8a0a8e5@google.com> <00000000000091b72905fae0eda2@google.com>
In-Reply-To: <00000000000091b72905fae0eda2@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 4 May 2023 18:51:03 +0200
Message-ID: <CANp29Y6PHCKRWSQvhs2gKTMC3u95Zo8VLTmXRxP1=5X00EKh-w@mail.gmail.com>
Subject: Re: [syzbot] [can?] WARNING in j1939_session_deactivate_activate_next
To: syzbot <syzbot+3d2eaacbc2b94537c6c5@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kernel@pengutronix.de, 
	kuba@kernel.org, linux-can@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org, 
	o.rempel@pengutronix.de, pabeni@redhat.com, robin@protonic.nl, 
	socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com, 
	william.xuanziyang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 6:47=E2=80=AFPM syzbot
<syzbot+3d2eaacbc2b94537c6c5@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit d0553680f94c49bbe0e39eb50d033ba563b4212d
> Author: Ziyang Xuan <william.xuanziyang@huawei.com>
> Date:   Mon Sep 6 09:42:00 2021 +0000
>
>     can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D10cf099028=
0000
> start commit:   fa182ea26ff0 net: phy: micrel: Fixes FIELD_GET assertion
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D796b7c2847a68=
66a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D3d2eaacbc2b9453=
7c6c5
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1455e3b2880=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10296e7c88000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:
>
> #syz fix: can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Looks correct.
#syz fix: can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/00000000000091b72905fae0eda2%40google.com.

