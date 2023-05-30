Return-Path: <netdev+bounces-6428-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9EAC7163DC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A9601C20B27
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FA023C72;
	Tue, 30 May 2023 14:23:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E2D21076
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:23:39 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCB0E6B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:23:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so125475e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685456590; x=1688048590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpS+v9astrIWciuP6AW6IcOJp29/neHVPmUPqCQqLYk=;
        b=Q/1n/Q5U0ws7VDmj6VRBX2wfq7F5i7u/kb7N51VeHhkHbz4tTTZ+V/uhWbUMv+0tW+
         jUKM1vQtM19OFK83HQR0n6Xs2a9cX4lVbnLnI6U4kV4kFReYNkrKlBfAqqH3z9CAaurp
         vuDobR4y2/3mvletj2hCYp44hsz/Ocyv8MTFTqnvoJPdZ5UaXw2haXIynD/pPDYHPHqL
         CvkM7b5IiPnLgKg/RPnlIE7XbyH73fcL7+mkk24WBlP8lwrzk/lv3NOFl39mZ1egLQYd
         GYfQ0+/zzbbq4cO9uMxbcaLjnwisASum4uhdGfy98JtwLsN/imHoNy+a6fEh700B+y6l
         BuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685456590; x=1688048590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpS+v9astrIWciuP6AW6IcOJp29/neHVPmUPqCQqLYk=;
        b=FU3NasotBwpzetAc9S7jifGYHaBxFYhPero876MfHsoc5jKvx0Hzh0ViVgCe2xCLOQ
         uDz3zx+YlxtVw/7/QKm2XWYN6AH04Yt0OXPZietcWwXvcDcGXJrRwvao0VOS8T1QA5nW
         yfFjewNLAjxW4ju36hKut74MTVhbHlvk1xYrAZrBIWCBexd2XSLu1ftV+y23y06LzSiu
         hyNYJsu1xntbg3PwsAscM/3ucgwPiuFkVuscsRyF7+fXzBBTkDissRkm4IjEvSWqhH6l
         vju1+nFn8XP/dhx9xW4SsN2z5hhLQ2JMLpezvvo6MPCoHNrb54Ob/u506ObHWVu69DtR
         DfqA==
X-Gm-Message-State: AC+VfDzl+SS/p7oBUiG+jnwLQ4WchioIOE1iCOqEYR0auKENgRI8qXAl
	vylunSL83KJElRN/B6NyJvfIZDlXEz2fIWInIlV3Vw==
X-Google-Smtp-Source: ACHHUZ6DO1jDG1WnOh30Q8Tdtf+K4s3bQJcMxtJ1jKMD+rmSEVQLw7h0Myu8+U933G1k+v5o12KX2blAlrs9yoBVwJI=
X-Received: by 2002:a05:600c:1c84:b0:3f4:df95:17e0 with SMTP id
 k4-20020a05600c1c8400b003f4df9517e0mr146328wms.5.1685456590048; Tue, 30 May
 2023 07:23:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
In-Reply-To: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 16:22:58 +0200
Message-ID: <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix mishandling when the sack compression is deferred
To: fuyuanli <fuyuanli@didiglobal.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, 
	toke <toke@toke.dk>, netdev@vger.kernel.org, 
	Weiping Zhang <zhangweiping@didiglobal.com>, Tio Zhang <tiozhang@didiglobal.com>, 
	Jason Xing <kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 4:19=E2=80=AFPM fuyuanli <fuyuanli@didiglobal.com> =
wrote:
>
> In this patch, we mainly do two things which could be separately
> found as the following links:
> 1) fix not sending a compressed ack if it's deferred.
> 2) use the ICSK_ACK_TIMER flag in tcp_sack_compress_send_ack() and
> tcp_event_ack_sent() in order we can cancel it if it's deferred.
>
> Here are more details in the old logic:
> When sack compression is triggered in the tcp_compressed_ack_kick(),
> if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
> and then defer to the release cb phrase. Later once user releases
> the sock, tcp_delack_timer_handler() should send a ack as expected,
> which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
> Therefore, the receiver would not sent an ack until the sender's
> retransmission timeout. It definitely increases unnecessary latency.
>
> Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
> Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> Link: https://lore.kernel.org/netdev/20230529113804.GA20300@didi-ThinkCen=
tre-M920t-N000/
> Link: https://lore.kernel.org/netdev/20230530023737.584-1-kerneljasonxing=
@gmail.com/
> ---
> v2:
> 1) change the commit title and message
> 2) reuse the delayed ack logic when handling the sack compression
> as suggested by Eric.
> 3) "merge" another related patch into this one. See the second link.

No.

This is not the patch I suggested.

