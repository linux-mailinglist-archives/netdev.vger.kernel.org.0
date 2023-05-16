Return-Path: <netdev+bounces-3135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5D1705B6F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 627C52812BA
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B081078F;
	Tue, 16 May 2023 23:40:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE9529119
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 23:40:28 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA805253
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:40:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f41dceb9c9so860025e9.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1684280425; x=1686872425;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3gJ6ClKCN5IpuWuuZ4gAq1QA9hxr0NJz78qq27otER0=;
        b=T+iKqFa0QVTTwTfMy0EnKWcebI3l+7lITkXNnpLsCYqm8cxK/g+6daKPEqIf/YvVhO
         +ZJ2cE7aglgGApQjd5vagAnlx+MzCErICKsJ/Sq7vUFKs2EjcBWxuPDVHMYhXi2DPCF9
         tXCMhAlwdJUt0VqDRloYyeJ4clUmjjpRJHCSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684280425; x=1686872425;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3gJ6ClKCN5IpuWuuZ4gAq1QA9hxr0NJz78qq27otER0=;
        b=g4MAImvuu7Fo6OWs0BxmOhJcaYhs37/TtM1sNbBUjlf3CRjYiwDrhwUXM2dI+s8BLY
         rWr6+3ZixGaUvDRzdLA0WF0l6HnEA57xp3E0Tl5NYv4wnDdquNf70KLZqwfyNrwMJUDX
         sqcImHoYzKzHD8Tm4xb6D/damQ3s5V7HkBowfb3aBTFs5SN3eAauhqpZPBV2MU29O5To
         AKuqJ4MpqYDBE0QveYttzvI6Fd+Si+itOGoEOW0RfxdlVPn4ju7dyX6uBmavHgYMSNms
         uJ0YjpTVJ0UIbPgz6PxktP5mmqf3pQFk1e+DIeEvX21nmD1mbtrabJdtq92BjaYWPJ+r
         u1LA==
X-Gm-Message-State: AC+VfDyTPdj8waQa5Md2Nv14NUVDFOlzl/EDXLh3p8McanvWrO7DjQS1
	E4qHAPwwa786fYSJR9jS5ZhcGQ==
X-Google-Smtp-Source: ACHHUZ6p1bpyfuzEkMPYdkv0PWKr6f8mAIytG8MbwJGVw0PEc3dXSiAz+8FrEhHXpiekzKuRQE3Nrw==
X-Received: by 2002:a05:600c:2116:b0:3f4:294d:8524 with SMTP id u22-20020a05600c211600b003f4294d8524mr20152496wml.22.1684280424842;
        Tue, 16 May 2023 16:40:24 -0700 (PDT)
Received: from [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1] (2001-4dd7-624f-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id f17-20020a7bc8d1000000b003f4290720cbsm337611wml.29.2023.05.16.16.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 16:40:24 -0700 (PDT)
Date: Wed, 17 May 2023 01:40:23 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
To: Stephen Hemminger <stephen@networkplumber.org>
cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>, 
    Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
    Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <20230516160111.56b2c345@hermes.local>
Message-ID: <d3fcafc-08-a74e-8bc8-b93cfcd2f5ef@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de> <20230427132126.48b0ed6a@kernel.org> <20230427163715.285e709f@hermes.local> <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk> <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
 <87y1loapvt.fsf@toke.dk> <20230516160111.56b2c345@hermes.local>
Content-Language: de-DE-1901
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 16 May 2023, Stephen Hemminger wrote:

>If your qdisc was upstream, others could collaborate to resolve the issue.
>As it stands, the kernel development process is intentionally hostile
>to out of tree developer changes like this.

The qdisc is a simulation for the network connection of one
5G UE. It=E2=80=99s not suitable as general router qdisc. I doubt
it would even be considered for acceptance. The kernel
upstreaming process is not the least hostile either=E2=80=A6

bye,
//mirabilos
--=20
Infrastrukturexperte =E2=80=A2 tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn =E2=80=A2 http://www.tarent.de/
Telephon +49 228 54881-393 =E2=80=A2 Fax: +49 228 54881-235
HRB AG Bonn 5168 =E2=80=A2 USt-ID (VAT): DE122264941
Gesch=C3=A4ftsf=C3=BChrer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Ale=
xander Steeg

                        ***************************************************=
*
/=E2=81=80\ The UTF-8 Ribbon
=E2=95=B2=C2=A0=E2=95=B1 Campaign against      Mit dem tarent-Newsletter ni=
chts mehr verpassen:
=C2=A0=E2=95=B3=C2=A0 HTML eMail! Also,     https://www.tarent.de/newslette=
r
=E2=95=B1=C2=A0=E2=95=B2 header encryption!
                        ***************************************************=
*

