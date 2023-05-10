Return-Path: <netdev+bounces-1447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B9A6FDCBF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67D081C20CFB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF1C8C1C;
	Wed, 10 May 2023 11:34:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BB6FDE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:34:16 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B936269A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:34:14 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso114495e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718453; x=1686310453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJ0B1g+f8cgGMeUyswCfosVhqOwS2k6tY+t32CjBcKI=;
        b=iobBuStksNwwSttvAhFcxNh5zuoslRjBkvkqavlyUEUqvw9sbWuos8u9o/BPRbwSXs
         MI3zgYsz3iZVL0No6WE35hOVXlFH9cyaBQBrokQ5OsngsthuB7DL1wwYt64dJTDwigJQ
         e1tY3WKVDhu3UL/xsQNH6zGipnBXTPXl5xsATOHlvHgFBNtya6F2ECWgPi7qtathe1T3
         TXLof2zD+4/AOeZdrNuRndq3Ze1X4S2DzrmHSCBxriSPxdwPeZV6mBDiFg1tdCwWwRKc
         UYxixhZ6dy/qXzv8sk1KYqN6gkPCrGcxtSwGSbQ1tDMwTytnVqTZNYW0YS/exGbjzp2D
         rRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718453; x=1686310453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJ0B1g+f8cgGMeUyswCfosVhqOwS2k6tY+t32CjBcKI=;
        b=MOE9uvDhFztgrWZMJ5+Z0bspsyoqVDTm5PLX3a0Uxbad4+KngjHLzzRtSiLjE75VY/
         lf+amrSO4fRCa1Di0ZfNPlVekZMOt9Kqur25P76TDYCssveO9nu5scahtYIGIob6QpCW
         BgX2hbypIAtcPTmQGMvlgAvnoYw0c+HVVao1XrmBXbA2KHk2QOwbsV7SwrIdP/Tv73bi
         uc30DsDoeyJM4EJ6vFUnPKLJCcCQ4WkHIkeeprGhiQpvXhG3tE5bGkbnupaQ35KD169o
         Pz4X/Q6ghcFMJb5/M0ytwSE47ShviwhSb+K4tKXsQgFK0zIKBgwimWKIcL2UEC0ZC1Ls
         gvDQ==
X-Gm-Message-State: AC+VfDwhhPPX4XOQUl0kW5okgWkyYy0z9DjQgfeEYEcpKc5yxK52H7rz
	l9Rkx31gqF/sK+aQSrmzyebVuoTaUZjASaOFah0rCw==
X-Google-Smtp-Source: ACHHUZ6FD/5vb/Ig8+D3c6okJvoSv28/EETKkeizpEz03vSYr12RLoFd7SpdjCZUNIGn1leOPsaYUPLqxVRsbQwLT88=
X-Received: by 2002:a05:600c:82cb:b0:3f3:3855:c5d8 with SMTP id
 eo11-20020a05600c82cb00b003f33855c5d8mr185930wmb.6.1683718452754; Wed, 10 May
 2023 04:34:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk> <E1pwgrM-001XDs-3b@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pwgrM-001XDs-3b@rmk-PC.armlinux.org.uk>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:34:00 +0200
Message-ID: <CANn89iK9chzd_xDiVFDQB2OV8-cQ0Ep1kbvdedBOftovc3m0kg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] net: mvneta: mark mapped and tso buffers separately
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:15=E2=80=AFPM Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> wrote:
>
> Mark dma-mapped skbs and TSO buffers separately, so we can use
> buf->type to identify their differences.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

