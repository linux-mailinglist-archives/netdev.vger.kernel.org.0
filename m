Return-Path: <netdev+bounces-9214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4963727F7B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37F5B1C20FDD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AD3125BA;
	Thu,  8 Jun 2023 11:54:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F721119D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:54:24 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A851FFE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:54:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so65735e9.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686225261; x=1688817261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pazMV69yfgFZtP5YDiQoyIf8m2D7hEJoNwU1Dx6CL8=;
        b=n38eRUOr4umoCI3/QeJjYKUG5wauY5XjpbsCAk1wajgj91PVr1M6zAt4A9q6TvWUs7
         VqUI2OLwjSp69CjrKIYNdE1Vl9nj/0BUVDz9dzA3+W70nmnMscD1svF4KX9ZvTVBRcY0
         e/efkjGrGTB30e4tokL4P9NUorLG51i/Iao4ki/GG4GlhZ1Q59kKNACiouxvuKwQXD0r
         V6npe7gl/9G7ZmM1Q8Uxzo0NKePnr9/d/wQ++4oKKTT5adJuUNdliPlwwZYz/WttxAdU
         3VviFQ3ER2MuB7p5zTA1IPCQ02NF9kS4fNagTOZ+5i+QKGqgqX0D7m+ugJzTtYpwTiTf
         F/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686225261; x=1688817261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pazMV69yfgFZtP5YDiQoyIf8m2D7hEJoNwU1Dx6CL8=;
        b=ORncxF9dCPcE2iyaZPIfTY6O1Zn9pGjsM3vD2bseU/gvyFXnP4tuphT7raudJ0FvMX
         /zSCdXP13COiqlVD8yWTBy0P5A3T+pIkcJcNb9Q5m3KdyaHTj8NpwQX/cC9Q0jW2kHYz
         lXPZxKa0Xyp0ZuIutDen1Mb3aiYoKMv6CI/4iZPozLSxJ3hYOPRKf6pf51CyxHMbCvZo
         wpnQOHx113m6WS+vh7aUZJkbGUnU0xbWR6y+fVMTbvaTWayQFYvjeXv7rNUoCLzRZYHM
         PNEMOtU7xHbCu8bI4utQ4J0CPyDOEHo7lOXF3BMp83+S2rIZQZJVAnO1WXxRKKbosSUn
         O+fQ==
X-Gm-Message-State: AC+VfDxslSIKx/dx53MRZfaU8cwFbbViIvT3ssKhrt7kFfMVeB63qFlp
	9DqzhwCPpRmka1kWOmI7/DBEdTOPUJesFX/yD57IP4iTOPVwDK/oxlckdw==
X-Google-Smtp-Source: ACHHUZ4mzPivgHhSIaZ4zzukHxcstQVei8abw9RuANC/UKP6oJ2udNBEdZbHZg/kO9daP38viSJzG29otuBxNJ69Wmg=
X-Received: by 2002:a05:600c:1f0d:b0:3f7:ba55:d03b with SMTP id
 bd13-20020a05600c1f0d00b003f7ba55d03bmr156301wmb.2.1686225261431; Thu, 08 Jun
 2023 04:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606064306.9192-1-duanmuquan@baidu.com> <CANn89iKwzEtNWME+1Xb57DcT=xpWaBf59hRT4dYrw-jsTdqeLA@mail.gmail.com>
 <DFBEBE81-34A5-4394-9C5B-1A849A6415F1@baidu.com> <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
 <D8D0327E-CEF0-4DFC-83AB-BC20EE3DFCDE@baidu.com> <CANn89iKXttFLj4WCVjWNeograv=LHta4erhtqm=fpfiEWscJCA@mail.gmail.com>
 <8C32A1F5-1160-4863-9201-CF9346290115@baidu.com> <CANn89i+JBhj+g564rfVd9gK7OH48v3N+Ln0vAgJehM5xJh32-g@mail.gmail.com>
 <7FD2F3ED-A3B5-40EF-A505-E7A642D73208@baidu.com>
In-Reply-To: <7FD2F3ED-A3B5-40EF-A505-E7A642D73208@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 8 Jun 2023 13:54:09 +0200
Message-ID: <CANn89iJ5kHmksR=nGSMVjacuV0uqu5Hs0g1s343gvAM9Yf=+Bg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: "Duan,Muquan" <duanmuquan@baidu.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org" <dsahern@kernel.org>, 
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 1:24=E2=80=AFPM Duan,Muquan <duanmuquan@baidu.com> w=
rote:
>
> Besides trying to find the right tw sock, another idea is that if FIN seg=
ment finds listener sock, just discard the segment, because this is obvious=
 a bad case, and the peer will retransmit it. Or for FIN segment we only lo=
ok up in the established hash table, if not found then discard it.
>

Sure, please give the RFC number and section number that discusses
this point, and then we might consider this.

Just another reminder about TW : timewait sockets are "best effort".

Their allocation can fail, and /proc/sys/net/ipv4/tcp_max_tw_buckets
can control their number to 0

Applications must be able to recover gracefully if a 4-tuple is reused too =
fast.

>
> 2023=E5=B9=B46=E6=9C=888=E6=97=A5 =E4=B8=8B=E5=8D=8812:13=EF=BC=8CEric Du=
mazet <edumazet@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jun 8, 2023 at 5:59=E2=80=AFAM Duan,Muquan <duanmuquan@baidu.com>=
 wrote:
>
>
> Hi, Eric,
>
> Thanks a lot for your explanation!
>
> Even if we add reader lock,  if set the refcnt outside spin_lock()/spin_u=
nlock(), during the interval between spin_unlock() and refcnt_set(),  other=
 cpus will see the tw sock with refcont 0, and validation for refcnt will f=
ail.
>
> A suggestion, before the tw sock is added into ehash table, it has been a=
lready used by tw timer and bhash chain, we can firstly add refcnt to 2 bef=
ore adding two to ehash table,. or add the refcnt one by one for timer, bha=
sh and ehash. This  can avoid the refcont validation failure on other cpus.
>
> This can reduce the frequency of the connection reset issue from 20 min t=
o 180 min for our product,  We may wait quite a long time before the best s=
olution is ready, if this obvious defect is fixed, userland applications ca=
n benefit from it.
>
> Looking forward to your opinions!
>
>
> Again, my opinion is that we need a proper fix, not work arounds.
>
> I will work on this a bit later.
>
> In the meantime you can apply locally your patch if you feel this is
> what you want.
>
>

