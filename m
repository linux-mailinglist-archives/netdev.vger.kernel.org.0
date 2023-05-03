Return-Path: <netdev+bounces-136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C356F55B2
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 12:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 604E628149A
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537B8D2F8;
	Wed,  3 May 2023 10:13:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DD37484
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 10:13:53 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C33D46AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:13:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-94ef8b88a5bso758380066b.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 03:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wetterwald-eu.20221208.gappssmtp.com; s=20221208; t=1683108830; x=1685700830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQTJ+8xY/XN7ruC+gnz6ODzwyqsp6FV2TVXipbJXb0Y=;
        b=yDkX2Xvc/1oG4f0DUGmm/vWeuenwBAm3Ey8fxRCtthl40z49eKf1btyNVOv8QVcXnY
         1LmSLr4xt9fao8Bj1EqfghHePNTy66IBfHwdgswKMPw6eKeEh23hxob5xS5UI9bjKtJv
         IXLdauyZMCQRjrSLyhelEi1oTGYF+p3uvuZebkxMV/Rz668diA8z4jOab6jYXhrM5v48
         8H0CEHCugfoZibf5HiLa0a1azbnuJ0fluuOdpeoYSo99xDELnLFBDiLv8OR6cIMCeUyt
         rqP1Wo5mxXL438djfT8ss6R0bT6Gw2k+wr6BvVopUHiCR16p5ciIDcx3eGRpMLCuCSqy
         0yVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683108830; x=1685700830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQTJ+8xY/XN7ruC+gnz6ODzwyqsp6FV2TVXipbJXb0Y=;
        b=aiCtZ8TUpWVdEoR3nw5uQBn66qmJnQebWMvSCEDNd8s2eSLrk42tn4lZGzzpOX74gi
         hMI7+JOyVpWP1At40wgjSOzV4OpOpSlQEPhF3Fq2JxCt3++/t9H0jqwqVurXsniD01OG
         dMow/CRG+lmSDQ8tAO319K+Oy3s8ll13a8zKF3ALreSRNfiZKcHHHwfviVirv4pUHEWV
         u88d+NsfWCIJhqxVsVGcDlFFP9LDWYz5WZQDoXEorNvKM4/klZHHhkGn4UJJh8IyHv6f
         dBwvDMpB/YYiAuyxNt82GrJ1WTcITnbNV5cAIG36KOKv3k0EeApfDyz90JBUfjMOpcBi
         xa/Q==
X-Gm-Message-State: AC+VfDwgE8F4ldE3HPpV7Mc+/ZNC9AamWAz0kAZr2ALtlN5uRDx0kAkx
	xbFP3BLKmU5vGqOdG3FZg/ipRTQKJIE7WSado+P+TA==
X-Google-Smtp-Source: ACHHUZ7eO5at1iQOJijmabErzA0wezPA1D3I7njMQOGCB8qmTL6ITAZr+yamM1fYR2SA+TcQc4UeXcOCwjY3rZY+6h0=
X-Received: by 2002:a17:907:a40b:b0:93b:866:bafe with SMTP id
 sg11-20020a170907a40b00b0093b0866bafemr2606233ejc.56.1683108830084; Wed, 03
 May 2023 03:13:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
In-Reply-To: <CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
From: Martin Wetterwald <martin@wetterwald.eu>
Date: Wed, 3 May 2023 12:13:39 +0200
Message-ID: <CAFERDQ0mfFYBWunXR1RCztsGr9CUMwUt7QEUZXW8T2NfAqq6+w@mail.gmail.com>
Subject: Re: [PATCH] net: ipconfig: Allow DNS to be overwritten by DHCPACK
To: davem@davemloft.net, dsahern@kernel.org
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 3, 2023 at 12:06=E2=80=AFPM Martin Wetterwald <martin@wetterwal=
d.eu> wrote:
> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index e90bc0aa85c7..c125095453da 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -937,9 +937,11 @@ static void __init ic_do_bootp_ext(u8 *ext)
>          servers=3D *ext/4;
>          if (servers > CONF_NAMESERVERS_MAX)
>              servers =3D CONF_NAMESERVERS_MAX;
> -        for (i =3D 0; i < servers; i++) {
> -            if (ic_nameservers[i] =3D=3D NONE)
> +        for (i =3D 0; i < CONF_NAMESERVERS_MAX; i++) {
> +            if (i < servers)
>                  memcpy(&ic_nameservers[i], ext+1+4*i, 4);
> +            else
> +                ic_nameservers[i] =3D NONE;
>          }
>          break;
>      case 12:    /* Host name */
> --

I reset the whole DNS array every time because, in case we have a DHCPOFFER
containing more DNS servers than the DHCPACK, we probably don't want to hav=
e a
"mix" between DNS servers from the DHCPOFFER and from the DHCPACK at the sa=
me
time.
But this could break users having a DHCP server sending only DNS informatio=
n in
the DHCPOFFER and nothing in the DHCPACK.

Do such kind of DHCP server implementation exist?
Do you see a better way than resetting the whole array every time?

