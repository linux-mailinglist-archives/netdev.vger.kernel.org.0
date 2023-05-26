Return-Path: <netdev+bounces-5767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB40E712B3D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DBD0281928
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1EF27739;
	Fri, 26 May 2023 16:57:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103F42CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:57:24 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578611B4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:57:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51440706e59so1370515a12.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685120231; x=1687712231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ja0in5TBjui7p3/oTjd6x+SMy6lwZFw3t5bIyVH8ZoE=;
        b=EgpyCWMxWlEshViGGzD8bgABvTUenjyo4lKUXIN/W+C5GFL3GuoNiG+MLL9NLsqN2y
         TBBZYnE+K3GfVyYiZKmqmdtCb1SfVx4tHcGhf4Ut6SI1G/PBAztZmryJl9GnLxS7JeAX
         mASMl5vqGIOSeAxkFWXhAAjRFecncD27wPuFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685120231; x=1687712231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ja0in5TBjui7p3/oTjd6x+SMy6lwZFw3t5bIyVH8ZoE=;
        b=jz1OScSMf11y3m2RqJxWU+3kTejUaSvaaWZ4A1Nqgu3EAzrCB+Sn2/E1oN//XUx8I1
         TcdGNdhSKwvtXxm1XxgKoVi5pgWSm54Hy2tVqslSlqkmNZGG2WURAhOsKYFPO3+LCkTa
         BKMS8LlfPAjTcsS46FTP8+B6rTaLeC3UUFXhs8f0iseOzOgFuCRcvp4Mxr0KIT7/5Gho
         zLTJ8DeLd/Fp+j4LtNR68vdXsWPtoDvx5i/+gMvMRbmG1/ekUMD9rYI+hn9u+C9e93Mu
         C+TSFRC43siywNjZdz9sAxn6DWSELnTjCSnRixVGr1AU5+3RhzSEuydqKNHVsM97ZSvs
         poIA==
X-Gm-Message-State: AC+VfDxLewim+vG6LgB0z8ADt9Vh15hiyx4oLoWU2T0qUSgKc6NfKPnY
	/5vh7DfM3GQD3Dp4iWx3P2DxBA23EDwsK1mxsGFpzwpg
X-Google-Smtp-Source: ACHHUZ6ugvWAqFtQWl6Y0NvgC5eB7WIAS3FDV87e/BbbYp9E2Vo4jPevi44btmcMJnToDUBGl1t+9A==
X-Received: by 2002:a17:907:1c8c:b0:96b:559d:ff19 with SMTP id nb12-20020a1709071c8c00b0096b559dff19mr2923791ejc.21.1685120231493;
        Fri, 26 May 2023 09:57:11 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id r3-20020a170906a20300b00965ffb8407asm2321885ejy.87.2023.05.26.09.57.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 09:57:10 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-51440706e59so1370463a12.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:57:10 -0700 (PDT)
X-Received: by 2002:a17:906:ef06:b0:973:92d4:9f4e with SMTP id
 f6-20020a170906ef0600b0097392d49f4emr2458863ejs.53.1685120230471; Fri, 26 May
 2023 09:57:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com> <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
In-Reply-To: <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2023 09:56:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
Message-ID: <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Eric Dumazet <edumazet@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 9:37=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> Hmm.. my build environment does not like this yet :)

Ahh, I tested it in an allmodconfig build, but only building that one
file, and not trying to link it. And gas was apparent;y perfectly
happy just leaving that undefined feature as a relocation.

I assume that if you just add a

   #include <asm/cpufeatures.h>

to the includes, it magically works for you?

             Linus

