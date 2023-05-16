Return-Path: <netdev+bounces-3138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E0A3705B76
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 175AB2812EF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76E010963;
	Tue, 16 May 2023 23:47:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D0C29119
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 23:47:14 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319254698
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:47:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f4249b7badso1365075e9.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1684280831; x=1686872831;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ErlL1rQJ+K9dFIX+SzDIJ1c8OglMCM6Vy28e6pLUhFM=;
        b=RDHeWTLQLik/Co+ODJXa+eUpJ6JPjrfq6mSuNVe6DKPuFNMibqTizhi8jx7XOlfVM9
         Rjgmnl73Wb7gaTd8SgC1Wb35G66YZ+eifN+JX2A4x4QStSdUrB6sGdJO08dfpOH1d7YW
         wPMRiUFLZG1MIkcJYg9ioLn2z512oKPhmzlaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684280831; x=1686872831;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ErlL1rQJ+K9dFIX+SzDIJ1c8OglMCM6Vy28e6pLUhFM=;
        b=EFpFB7stf1ar49DzDRe2dLseEEkoX/lyO8DOZmY8l72IKpjVyZzxE3YSjwY4EkbAB8
         R5y3nIgx5+P2VR9bKR/iYY2qs2pmw/6iRNXJiEHivqK0jsT7ADBNGE29vjwRc+qWg1i+
         PvEi3+HQlnBTdXMDSr2cI6SNqIPPyxfGihJ5hNpqu4JeDSL2kFO1HhahiM6RQd5Qj2PT
         VU/Ra6D4wmgNno7RLM8asizHW4hO/Nf5roMpqnNC+w1Q0XlCpQRtTY32ociycZTlVHjn
         jvFK+75r5Sy+l/sZIsOyLaHMnUcUHj9uCYQ0n8sHeUW9TrbVgQA+s4+5uOk3rCGnJlu4
         fS8w==
X-Gm-Message-State: AC+VfDwK/GHpdtJFKQi8CFDeEH/v2ZqvG3c08gcU/hWdq1rlgdDIXR/b
	8Py6KcTF9fg8DoNcvzUdbi80t53eWgknv94/iSE=
X-Google-Smtp-Source: ACHHUZ6d2irqgDIWmnxOjBknkI6Jn2gHUSq0rUMH9Adsy4LjQSZCODRyrnq+TqR/FSD6bJJsm7nplg==
X-Received: by 2002:a7b:ce89:0:b0:3f5:6e5:1688 with SMTP id q9-20020a7bce89000000b003f506e51688mr6837315wmj.2.1684280831657;
        Tue, 16 May 2023 16:47:11 -0700 (PDT)
Received: from [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1] (2001-4dd7-624f-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id m6-20020a7bca46000000b003f4bef65a65sm303611wml.28.2023.05.16.16.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 16:47:11 -0700 (PDT)
Date: Wed, 17 May 2023 01:47:10 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
To: Stephen Hemminger <stephen@networkplumber.org>
cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>, 
    Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
    Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <20230516164423.3e5b45e9@hermes.local>
Message-ID: <3a4b33a1-5dc5-ac66-c5ee-679ff560fd8@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de> <20230427132126.48b0ed6a@kernel.org> <20230427163715.285e709f@hermes.local> <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk> <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
 <87y1loapvt.fsf@toke.dk> <20230516160111.56b2c345@hermes.local> <d3fcafc-08-a74e-8bc8-b93cfcd2f5ef@tarent.de> <20230516164423.3e5b45e9@hermes.local>
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

>Sounds like it could be extension or part of existing netem.

No, it does so much more=E2=80=A6 very extensive reporting to userspace
using debugfs/relayfs, for example, and very specific extra
behaviour. We did look at netem, but it caused trouble.

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

