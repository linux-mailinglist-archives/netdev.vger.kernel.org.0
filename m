Return-Path: <netdev+bounces-482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC9F6F7AAD
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 03:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9111E1C214FE
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 01:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003DD110B;
	Fri,  5 May 2023 01:26:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E687C7E
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 01:26:15 +0000 (UTC)
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77E1124AC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:26:09 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4efe8b3f3f7so1390325e87.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 18:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683249968; x=1685841968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEXlTZkPBTQ4DLSA52HQ4S20vp3O69OcS648Z4R3cGo=;
        b=Zp+GPsjKNPQL1br8ntBZu6vJ2AffReYEsl1D5s3Mg4upcAQM+Ym0j+5wUHwkZjEgPA
         Em4sPNYwrBSP53Nu6SapwFNl/gDMCsH4Jbu4BWFdsh5BluEGqUAKniIIi5CAf5d6yGK/
         FtsxUlTC6s87z1YjaIOGHLLxl0rx9Nx87Ujx8OV3c7SQf1N6UcFZqMJJBQpCgF5UJSrC
         kPYz0KVjWe3xstAE5wtMXS2oZ3heYkEkB8nkY5wgeYlXrhEmdEVqZBfnPmf8uWJ74eHT
         V2b4c6elF4voEPMhuRQCNWhyPU6AOduhld32ymW1zEU6jGGeialFKYHQQLMIMORwBu72
         g4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683249968; x=1685841968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nEXlTZkPBTQ4DLSA52HQ4S20vp3O69OcS648Z4R3cGo=;
        b=g7skeBylI87IVwRGecM7qqtRL6Jo+AxLG0E2E9TEjBo82CstR24D+Df84r5vmieUfM
         ROohek/iKSTCaIPrqXVqqFfrhGanmWReL4JuJK0WBOhpxn/EWhaujh+h77GP/XCIyZpK
         9G4ofdfN+iBqvSv9jFm0hFXABdJTgQFCBJj+vDUhi6pc11vIG+guoU51MDqKU8DxCakn
         pT/o4AwjGnnavFjKLjEFQDtJHrkb8rAB1peJAc65RHbR0jJzn49HMFLf2O+mzox2IVKi
         ssKAYhYz3oRx6S2ZDFzb4v45i3Hrx5VuSsqckT6GC6yvEGMSa/nxCrBJLXpSiqqRljcI
         8jUg==
X-Gm-Message-State: AC+VfDyuExxihMDL/PWoosm+5Bw+bMfi3NIWj4Z0dtD5kqjrrkAU0afW
	OofnFcTE1OtD9SUVNybCVOtq4nrLHWhuo2oBIrw=
X-Google-Smtp-Source: ACHHUZ5KYsftQSoq/MY7SXEp+i1D5rXBjeu4u4bHeRR4dPFCVigoNIU7hvXJ+b5XYwLCf1AvDDsaf+YEPMratw3RnKk=
X-Received: by 2002:ac2:5602:0:b0:4f1:4086:9384 with SMTP id
 v2-20020ac25602000000b004f140869384mr39341lfd.61.1683249967858; Thu, 04 May
 2023 18:26:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACWXhKnjyA8S56idVhSFgH1FLo-qBbpxU_ZBpdnrbvv9_kEY7A@mail.gmail.com>
 <20230424125357.55b50cba@kernel.org>
In-Reply-To: <20230424125357.55b50cba@kernel.org>
From: Feiyang Chen <chris.chenfeiyang@gmail.com>
Date: Fri, 5 May 2023 09:25:56 +0800
Message-ID: <CACWXhK=HbXwxYB0+LeZU2OdrPZcUP_YG2FpqG0yZ7gjpt2yj4w@mail.gmail.com>
Subject: Re: Help needed: supporting new device with unique register bitfields
To: Jakub Kicinski <kuba@kernel.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Apr 25, 2023 at 3:54=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Sun, 23 Apr 2023 16:19:11 +0800 Feiyang Chen wrote:
> > We are hoping to add support for a new device which shares almost
> > identical logic with dwmac1000 (dwmac_lib.c, dwmac1000_core.c, and
> > dwmac1000_dma.c), but with significant differences in the register
> > bitfields (dwmac_dma.h and dwmac1000.h).
> >
> > We are seeking guidance on the best approach to support this new
> > device. Any advice on how to proceed would be greatly appreciated.
> >
> > Thank you for your time and expertise.
>
> There's no recipe on how to support devices with different register
> layout :(  You'll need to find the right balance of (1) indirect calls,
> (2) if conditions and (3) static description data that's right for you.
>
> Static description data (e.g. putting register addresses in a struct
> and using the members of that struct rather than #defines) is probably
> the best but the least flexible.
>
> Adding the stmmac maintainers.

Hi, Jakub,

Thank you very much!

Thanks,
Feiyang

