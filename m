Return-Path: <netdev+bounces-6446-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D00A716519
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE30F281197
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A4E2107A;
	Tue, 30 May 2023 14:51:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99FE19516
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:51:32 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E547D10D2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:51:09 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so128595e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685458267; x=1688050267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Boxp5LVOXDRjybRsA1bwYyc9p+pImifWx2GJNX2PQfw=;
        b=Ik/ggP8YEGneZufiqkDvEkv2O7cCaeSCt4g1fGo/r3jRqcGBYGvo+u6IyXjZU+mlkl
         sy8Ri0k5pwC8zqubDQKmrBXese9YQklvf3cH78LZRVYCqCobGteAv0bnV2+/PxMoR5uE
         dtI2J8yd6O9QMrehOhoyFgFwbIILfAhtynJS9v9rnGFYOqNEoT4W7N3bQPAsutdKrL4g
         lPRg472DnV7pLGwQrl/Y0q8X1+uK/O86a5QcT1CevsI9oGG0bNk7CjV+cOjh6k6uUCMr
         jcBhDpG4xgJgDu2Kj4tt1H81Zpa59vtjZwPBzH2D0uR7McNZ2TaOp0VO6cVKrTEVU5Im
         4KkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685458267; x=1688050267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Boxp5LVOXDRjybRsA1bwYyc9p+pImifWx2GJNX2PQfw=;
        b=YumTp2LbfyxiWC2XATHe0pUTj+f3oIsvBM9ep1tCE7yuFXyPqC6Oz+caNqDdX53WRQ
         RYtaOzIvBzAtNpdUkRn30FaMTSS8o+oqF32r7mtTlxTtOd70VaY8BX13O1CN5NBfmywP
         UFQaova069uGENCyV7OqLoD/R0Lmv3xXhSZ9Ypf3g51xhck7kmJ6f7HrJZwaMXcSm0rQ
         K34z9nM7GgyjzOSJxH2l1tuFiyKSzVr4aSJcWaHqZJCwm12BDWQlzlJsnonTlLzIgzdm
         sM+RVrK4gyHVfLfHC6vmVMc3G4hf6OVMwONIRkTrajAMJA388Cofp291dAoWbjCl9wKt
         Kyrg==
X-Gm-Message-State: AC+VfDxNHWXVhuuWdOIHiLgnzPNyLTpIeFF5HqXSXZlUYskaA2PrR3fg
	9S/C1h7lXdx1TAx9vObqzuWCXCnRwfnQH21hDNYSNg==
X-Google-Smtp-Source: ACHHUZ5vAyxUOkeBc9rtXMpmepBETBg7M+KoSo/vBDxlWrj9a6qGWypB4umP0rOgoNCulVaRB0r0FvwH2LkoQ2WudrY=
X-Received: by 2002:a05:600c:1906:b0:3f1:9a3d:4f7f with SMTP id
 j6-20020a05600c190600b003f19a3d4f7fmr153797wmq.1.1685458267338; Tue, 30 May
 2023 07:51:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
 <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com> <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com>
In-Reply-To: <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 16:50:55 +0200
Message-ID: <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix mishandling when the sack compression is deferred
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 4:32=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> I'm confused. You said in the previous email:
> "As a bonus, no need to send one patch for net, and another in net-next,
> trying to 'fix' issues that should have been fixed cleanly in a single pa=
tch."
>
> So we added "introducing ICSK_ACK_TIMER flag for sack compression" to
> fix them on top of the patch you suggested.
>
> I can remove the Suggested-by label. For now, I do care about your
> opinion on the current patch.
>
> Well...should I give up introducing that flag and then leave that
> 'issue' behind? :S

Please let the fix go alone.

Then I will look at your patch, but honestly I fail to see the _reason_ for=
 it.

In case you missed it, tcp_event_ack_sent() calls
inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);

