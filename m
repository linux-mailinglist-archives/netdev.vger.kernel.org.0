Return-Path: <netdev+bounces-11080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEAA731812
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A62B3281770
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A640413AF3;
	Thu, 15 Jun 2023 12:02:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971D8125DA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:02:52 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6563B2976;
	Thu, 15 Jun 2023 05:02:51 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6658b869cf2so523696b3a.1;
        Thu, 15 Jun 2023 05:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686830571; x=1689422571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtR5yyjqqOCcg96T40YDoUHPwlla3NqWVuy2D+ZwTIk=;
        b=PhKz+v5RhdIZi9p3VwAdDvXQV5oRpln5h3H1OahPU9aPdUTrEDtHRZrQWyeNYkXDhQ
         FW+GtnP5O4PQNfU7c2r1RSfrUsxyPAFnXmWW+HL0psVqM9niZcIAYtfP5rNoVRk4TNtA
         1NnBSz0msntQ5g15c8mgesTGUDLTiopufKHo2jgbtnZjCRPcD+iOvpo8B+0YrVBPdzWj
         V6etC3SrridTxb50fjzgznPI1RZxiKP3A1hIX+EKYTB6Bt9/Y3G7ccRoUuVtM96MUFXV
         6fVkLBvdMEcOMh5w/qxg0mEj74/3VJSzLpmSzJwEZRtZMgrRkG82ll5H7pqgycrPVgbi
         FGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686830571; x=1689422571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtR5yyjqqOCcg96T40YDoUHPwlla3NqWVuy2D+ZwTIk=;
        b=F28zpCSHpiY2uM3giO6LZc8uI6Cd4+EaLF8P/M6IgbYHQNk5DBMTXqVp+Cu6Kwwg0d
         eObX21EWKLvJaSvDTrXb1JdPqjaqwQ8kS4M6iTM4QIWyk9CnNXPUKNC9FBP+pSP13lQL
         BZ2lWXp9wGPnsRrPF8J4j+WelmV04zFDXQpBPnMzRnFtSMLt+MGHuHhnMnm6IGJpFeH1
         5p2QADfOvG7A22LSGb0KZtfBsCsSL4KLghI6yUmeI006XC8t6QmIkeSIphL1gfnkDRfE
         pYr6GtUOhbdSJFyYe4vX08inlxDrjDbih/gWjGuM1k2A2DzFFjvQXi5I8hzaQZDac/QL
         C0VQ==
X-Gm-Message-State: AC+VfDzm1jJhc6RtJC8bZQjyWBNJ5FDqPD1SIR02vRa+hDOfWNyNeXkM
	z7Q4AW2yN9HUUVXzCxVSzbfy4eljVX9E16hXfR0=
X-Google-Smtp-Source: ACHHUZ6+VxPro345cAyYns3wxBIQ8MkoqAQ7K0joSqII6JtVpNSXaEzuVfrY/vlsvBIaTx3vOplxpbmmOMkf991aJKQ=
X-Received: by 2002:a17:90b:3614:b0:253:25c3:7a95 with SMTP id
 ml20-20020a17090b361400b0025325c37a95mr5822610pjb.14.1686830570764; Thu, 15
 Jun 2023 05:02:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530224820.303619-1-jm@ti.com> <20230530224820.303619-3-jm@ti.com>
In-Reply-To: <20230530224820.303619-3-jm@ti.com>
From: Hiago Franco <hiagofranco@gmail.com>
Date: Thu, 15 Jun 2023 14:02:39 +0200
Message-ID: <CAK4Znzk_9-nsEW16-ue4sSapixTn3UCPqKkj7iBX+Q_GKLUjoQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] can: m_can: Add hrtimer to generate software interrupt
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>, linux-can@vger.kernel.org, 
	Wolfgang Grandegger <wg@grandegger.com>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Schuyler Patton <spatton@ti.com>, 
	Tero Kristo <kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	Oliver Hartkopp <socketcan@hartkopp.net>, Simon Horman <simon.horman@corigine.com>, 
	Conor Dooley <conor+dt@linaro.org>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:51=E2=80=AFAM Judith Mendez <jm@ti.com> wrote:
>
> Introduce timer polling method to MCAN since some SoCs may not
> have M_CAN interrupt routed to A53 Linux and do not have
> interrupt property in device tree M_CAN node.
>
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use timer polling method.
>
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found in
> device tree M_CAN node. The timer will generate a software
> interrupt every 1 ms. In hrtimer callback, we check if there is
> a transaction pending by reading a register, then process by
> calling the isr if there is.
>
> Signed-off-by: Judith Mendez <jm@ti.com>

Tested-by: Hiago De Franco <hiago.franco@toradex.com> # Toradex Verdin AM62

