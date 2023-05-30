Return-Path: <netdev+bounces-6557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADEC716E84
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:17:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07AA62812D1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD44931EF7;
	Tue, 30 May 2023 20:16:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6B8200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:16:59 +0000 (UTC)
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C8D11F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:16:58 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-7870821d9a1so135826241.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685477817; x=1688069817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0kAdkdKKcoRJt6cKjH1W0Y3LVvvUu8hvwdcqLr31R0=;
        b=FgadNGHAdk0KDJfdw36OOsAPc/TK1I2pklt00gO0NwCzO1J/Q89+hQuUIDHV9wwQiP
         XZyYXXuRBCw6u5A6PzrSo7Kx+IoUE3+HLTy7coAi0oOAdXb+T/b5DaBjaWA2Lw+UGPdZ
         26eRgmkS1C8SKxxoi6X+hRgfr20bsusGc2UN/rM5jMNEQtvUoOxzsbv58hHggwrHkn/d
         axKk4CkNTune/4ANGkTobaVg0IBU/9ka5rF5/Jm4uaZQenKfabEI0+0AjKnYba2jp66T
         btWFo/Z/B5Py6wqKun1Brawp0TKtyBaLtesAziM3BLtRQlILqj1L7D4VlNZV1AesrmjN
         fm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685477817; x=1688069817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0kAdkdKKcoRJt6cKjH1W0Y3LVvvUu8hvwdcqLr31R0=;
        b=TJ+jYxrA+Oa0q/pemqe53LiU5FLodS+y9sbeC1kTXYKcPpMK8LTNJ9nyHtbL5lzNr4
         Nu5p6htotgHIfVd8vc/ikjlKYm+Gzwp0rggiDtyPxjzszLxqz5wCofwr+N7h0nsqJRND
         kE51JoRF1yhOge72CAz9Svw9sTo9KlASwI/TYOnx6td7hOm1yci3oLr9jVQKR2ACqoH4
         82w8SJVx5sA0HcTw2xOjz0arU8iEwrvoWsccEVPmA/AboJR5GL4GEQI6N3iIODTjpnhQ
         BLPH5WEnbXgKsDg84GIlP0rNjijK0y2NuAySLhWytDNeo7vFGRy32LzdBi0K5JOlTJPZ
         tAaA==
X-Gm-Message-State: AC+VfDybaNHOjWOkEqFih6DmfruLdDG3vGLQ5PI83m1rrGHLN5jd4mAl
	ns717KTRzUioH/XKSXZDu1ILN79542zUYH3PQkc=
X-Google-Smtp-Source: ACHHUZ6xZzW5SqnuT3FJ92dVZXZSK0/WzHrq0AzNX5e/7GnQbgp7Ew4vFzTbaFPMRadJm+ubno+i1ExJxfAYkFoOMKM=
X-Received: by 2002:a67:efc9:0:b0:439:4ac8:5b20 with SMTP id
 s9-20020a67efc9000000b004394ac85b20mr1592447vsp.11.1685477816988; Tue, 30 May
 2023 13:16:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF=yD-L88D+vxGcd1u9y07VKW242_macrQ+Q10ZCo_br9z2+ow@mail.gmail.com>
 <20230530173422.71583-1-kuniyu@amazon.com>
In-Reply-To: <20230530173422.71583-1-kuniyu@amazon.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 30 May 2023 16:16:20 -0400
Message-ID: <CAF=yD-Je+-t+tabGi6YOXAHjG7Osr+p3X=Utw=-24oMpE+08Jw@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	kuba@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 1:34=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Mon, 29 May 2023 22:15:06 -0400
> > On Mon, May 29, 2023 at 9:04=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazo=
n.com> wrote:
> > >
> > > Recently syzkaller reported a 7-year-old null-ptr-deref [0] that occu=
rs
> > > when a UDP-Lite socket tries to allocate a buffer under memory pressu=
re.
> > >
> > > Someone should have stumbled on the bug much earlier if UDP-Lite had =
been
> > > used in a real app.  Additionally, we do not always need a large UDP-=
Lite
> > > workload to hit the bug since UDP and UDP-Lite share the same memory
> > > accounting limit.
> > >
> > > Given no one uses UDP-Lite, we can drop it and simplify UDP code by
> > > removing a bunch of conditionals.
> > >
> > > This series removes UDP-Lite support from the core networking stack f=
irst
> > > and incrementally removes the dead code.
> > >
> > > [0]: https://lore.kernel.org/netdev/20230523163305.66466-1-kuniyu@ama=
zon.com/
> >
> > Even if there is high confidence that this protocol is unused, for
> > which I'm not sure the above is sufficient proof, it should be
> > disabled first and left in place, and removed only when there is no
> > chance that it has to be re-enabled.
> >
> > We already have code churn here from the split between UDP and
> > UDPLite, which was reverted in commit db8dac20d519 ("[UDP]: Revert
> > udplite and code split."). This series would be an enormous change to
> > revert. And if sufficient time passes in between, there might be ample
> > patch conflicts, the fixups of which are sources for subtle bugs.
>
> Thanks Willem, I didn't know someone attempted to disable UDP-Lite.
>
> You may prefer this way.
> https://lore.kernel.org/netdev/20230525151011.84390-1-kuniyu@amazon.com/
>
> I'm fine whichever, but the next question will be like how long should we
> wait ?  We happen to know that we have already waited for 7 years.

Is it a significant burden to keep the protocol, in case anyone is
willing to maintain it?

If consensus is that it is time to remove, a warning may not be
sufficient for people to notice.

Perhaps break it, but in a way that can be undone trivially,
preferably even without recompiling the kernel. Say, returning
EOPNOTSUPP on socket creation, unless a sysctl has some magic
non-deprecated value. But maybe I'm overthinking it. There must be
prior art for this?

