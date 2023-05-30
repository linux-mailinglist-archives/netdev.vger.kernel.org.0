Return-Path: <netdev+bounces-6436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9CE71643D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 259692811CF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68BC101E4;
	Tue, 30 May 2023 14:32:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55292D24B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:32:24 +0000 (UTC)
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE491B1
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:32:15 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-5566347e71eso2806048eaf.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685457135; x=1688049135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZWvROxggALhzFbiTh/9p+CH1g9gxbeFxnQou8YA5MA=;
        b=lcMuaqzMPB/jo5098rqeW+pKXhCvOw27M5LeUjd/IWIH15eVLzBUXP2g7NkiXkQPOD
         nzU0E1iZHM4K1fU6sI9kLBKo4EkHrjzbbbmEzSbC1tVSClMy27ToV3uIGPG7fG+IyTmF
         XTokbJxBohrlVzW5X0UchhoBL29IM6JC2mzAEW8rYbDZ+bKBQunVSi8a2a7tF3446a0B
         1keBKSJ8lpau99T1WcV1AooplMS5ABrJj3MIJKbK0ZXt16drvPfc8ePSulcjNE1bO9ua
         yGJFdhBXTozz+1x5hSGjoFG5uiu9dbebwtRcLeo1xdl5kBt9xHp7lL1/pCpNwLAYhies
         rdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685457135; x=1688049135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ZWvROxggALhzFbiTh/9p+CH1g9gxbeFxnQou8YA5MA=;
        b=V4shBqR1Cd/y9iX0ES7WtOUB9nmOKfdLmEpxUb8sEjwVZ4k8FIXLZYmJL0w2xgDYmV
         EEfoz3HgekEW7w18IyI3fknIDn091rhiV7xa8k1963u79ZYi99YQwpqZQKh2yMEZ7RyE
         w0U9JDzpdS2KYfDylVvtr1Mwb4n19OPDeY+8O8mDuZ6SKaudrLDVLHw2EBAt4hLS8aT7
         i0Ke4eSUhXqOKpIr+VMlhdmXQZ5o83oWKhsKkkmJ11JJU1WqZuui/5yiYxmgFpnPNQrD
         LcbwcTIgVmXLXcNxDRZ1pXtcPgkmsNAMYZhHZYnZ/n50w6e2M+HUPFyyzdeZYKZ7jt8n
         o9qw==
X-Gm-Message-State: AC+VfDyB5LWWguloN/u0mwfmaHR3PHoM5oWVbG4seJTFOsiHcpBxVo79
	ede/tEJYv0ZITPu09Op35/+G1tV/AToartR9WhM=
X-Google-Smtp-Source: ACHHUZ6ApMYV6mqzSzBr1Q0fpZOXmiyXHee4zwURQWnGfGoq68dEC4Bkcd8Ml2Hfoc3dP6S9c6iNV7zVmgrGocLjKiA=
X-Received: by 2002:a4a:4fd2:0:b0:555:51a9:5bff with SMTP id
 c201-20020a4a4fd2000000b0055551a95bffmr1115368oob.8.1685457134935; Tue, 30
 May 2023 07:32:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000> <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
In-Reply-To: <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 May 2023 22:31:38 +0800
Message-ID: <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix mishandling when the sack compression is deferred
To: Eric Dumazet <edumazet@google.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:23=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Tue, May 30, 2023 at 4:19=E2=80=AFPM fuyuanli <fuyuanli@didiglobal.com=
> wrote:
> >
> > In this patch, we mainly do two things which could be separately
> > found as the following links:
> > 1) fix not sending a compressed ack if it's deferred.
> > 2) use the ICSK_ACK_TIMER flag in tcp_sack_compress_send_ack() and
> > tcp_event_ack_sent() in order we can cancel it if it's deferred.
> >
> > Here are more details in the old logic:
> > When sack compression is triggered in the tcp_compressed_ack_kick(),
> > if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
> > and then defer to the release cb phrase. Later once user releases
> > the sock, tcp_delack_timer_handler() should send a ack as expected,
> > which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
> > Therefore, the receiver would not sent an ack until the sender's
> > retransmission timeout. It definitely increases unnecessary latency.
> >
> > Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
> > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > Link: https://lore.kernel.org/netdev/20230529113804.GA20300@didi-ThinkC=
entre-M920t-N000/
> > Link: https://lore.kernel.org/netdev/20230530023737.584-1-kerneljasonxi=
ng@gmail.com/
> > ---
> > v2:
> > 1) change the commit title and message
> > 2) reuse the delayed ack logic when handling the sack compression
> > as suggested by Eric.
> > 3) "merge" another related patch into this one. See the second link.
>
> No.
>
> This is not the patch I suggested.

I'm confused. You said in the previous email:
"As a bonus, no need to send one patch for net, and another in net-next,
trying to 'fix' issues that should have been fixed cleanly in a single patc=
h."

So we added "introducing ICSK_ACK_TIMER flag for sack compression" to
fix them on top of the patch you suggested.

I can remove the Suggested-by label. For now, I do care about your
opinion on the current patch.

Well...should I give up introducing that flag and then leave that
'issue' behind? :S

Thanks,
Jason

