Return-Path: <netdev+bounces-8504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC20E72457B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92760280FE8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B277E2DBB0;
	Tue,  6 Jun 2023 14:15:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B537B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:15:26 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1E7A0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:15:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-514ad92d1e3so6617a12.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686060923; x=1688652923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pLyWS7SWDOyM7foxXo03DIfgZrJGdKALWcjxSFuqPSI=;
        b=1cfXwlvFLwgvPEeXmsASNwRbD653BTsqwYQ1LcNEPTT4BXneAbe3wpottMa1T+McCm
         /0VySIIR7jmqr0XHfHmiXeYY7OVPAN1fXRLBV3VC3OkeHg+Qr/KHJJDvjJTkP+TZpKfu
         EOCz5fMHtU0fbAozamIsIJK3zAdmWUBVeh2pyu5HAqSdCM1d9PZgTaB2QpTIyGHIeZXr
         OTVQr+UpEAuuVVm8mmDP8x6xj45nMc4cCaYV5IrRaJ7PKEBQaHYr4vajfGhIKhXyBXtn
         Mf76PocRSBEBPgvTbRjIbl1RK/Q71kxbWeGtXy7AUKYXgNu8Wj5YgY1Ml2avpsuX9dSg
         C2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686060923; x=1688652923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pLyWS7SWDOyM7foxXo03DIfgZrJGdKALWcjxSFuqPSI=;
        b=Hh8URaz2Dw3+iU4u6Wkk9pmpt2VlmO5nejgBIV1RtGs0X7qmzT2Ayk2vr1gScA3oJc
         G+s8+nr5DKPKGkvEwBg09U5ruKlTRt6wG558pL1mKE+BAeLG1L1cj7hxRnoIjizJkPvK
         Bu51uUFwgk1lYE+fCwzAQXaGVweNI+WjdTjKvAx5K+Elh8DJ7LjfHPu6W1zL0UkA2CPv
         UyL3YtT5GW2hqcJAxZY2LNqqcItuNwvH80HRMe0ZhfoUmSSvTPCTZJBss07EugG7bwpS
         aYWRE8ihNvCLOzSbPXZxVud2A5Y3FkDRRW2iDcmBDHJD1UHKEY1LeQbEcVo1h6FkKMvG
         T1Tg==
X-Gm-Message-State: AC+VfDwTvn4z8XMLwn3caDUbZFNVH2A1+tV0vuw2pUBEUySR4v0PMVG0
	lvNDc2QMDAuPILmKXZdMgpFaTFOjx9sESOzBra1yLQ==
X-Google-Smtp-Source: ACHHUZ68AhSKzPq8oXoEUT1tuXri7wnaVhz47pC1frMiObKMMqCIEmjZaT2DD/yWdmVRtuXH14kOqx9aeXEnylwgS9c=
X-Received: by 2002:a50:c05b:0:b0:50b:f6ce:2f3d with SMTP id
 u27-20020a50c05b000000b0050bf6ce2f3dmr160246edd.0.1686060923361; Tue, 06 Jun
 2023 07:15:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606140041.3244713-1-ptf@google.com>
In-Reply-To: <20230606140041.3244713-1-ptf@google.com>
From: Patrick Thompson <ptf@google.com>
Date: Tue, 6 Jun 2023 10:15:12 -0400
Message-ID: <CAJs+hrHAz17Kvr=9e2FR+R=qZK1TyhpMyHKzSKO9k8fidHhTsA@mail.gmail.com>
Subject: Re: [PATCH] r8169: Disable multicast filter for RTL_GIGA_MAC_VER_46
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, nic_swsd@realtek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For added context I came across this issue on this realtek adapter:
10ec:8168:103c:8267. The device erroneously filters multicast packets
that I can see with other adapters using the same netdev settings.


On Tue, Jun 6, 2023 at 10:00=E2=80=AFAM Patrick Thompson <ptf@google.com> w=
rote:
>
> MAC_VER_46 ethernet adapters fail to detect IPv6 multicast packets
> unless allmulti is enabled. Add exception for VER_46 in the same way
> VER_35 has an exception.
>
> Signed-off-by: Patrick Thompson <ptf@google.com>
> ---
>
>  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethe=
rnet/realtek/r8169_main.c
> index 4b19803a7dd01..96245e96ee507 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2583,7 +2583,8 @@ static void rtl_set_rx_mode(struct net_device *dev)
>                 rx_mode |=3D AcceptAllPhys;
>         } else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
>                    dev->flags & IFF_ALLMULTI ||
> -                  tp->mac_version =3D=3D RTL_GIGA_MAC_VER_35) {
> +                  tp->mac_version =3D=3D RTL_GIGA_MAC_VER_35 ||
> +                  tp->mac_version =3D=3D RTL_GIGA_MAC_VER_46) {
>                 /* accept all multicasts */
>         } else if (netdev_mc_empty(dev)) {
>                 rx_mode &=3D ~AcceptMulticast;
> --
> 2.41.0.rc0.172.g3f132b7071-goog
>

