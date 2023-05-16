Return-Path: <netdev+bounces-3052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8F8705414
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF64E2812BF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56229E557;
	Tue, 16 May 2023 16:38:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486D1E553
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:38:53 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B8493C7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:38:45 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f509ec3196so34184655e9.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1684255124; x=1686847124;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ob0FdpiQ2WL+URPAIi1rnPFUnZr4mGmLQl0dRiyZxno=;
        b=ZdzxkKuhMjy8Ot/rgCXlvI5n0hC3xgqNXe2G6iUmLe7f5OBB0JovBMWXP57O7MU1je
         hx+puDcJSa8FYB6+aqF8czR1zVf7hf9WiQ1dhy1K2PsdgpZH2aQ4uTyos3wwgzBam+RC
         hSFCeiHNtAuIzUd5fSsRy2Ci675VhN2pk3yRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684255124; x=1686847124;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ob0FdpiQ2WL+URPAIi1rnPFUnZr4mGmLQl0dRiyZxno=;
        b=evN0NPehuB6ae364mTe63PaHpNGy3aIdcLeChOSRAIz9I4a9q5NSa8gLayuEztwm/3
         OsrHF/xsKCen2VyNxszwn9MhHCGdK9cxlZYOGMWI543uqC10wz6DN/c6S1pkgCne/i6P
         3SxX15i25cnzdFIXw2noPMye4GSsHQOaMcgdHYFi9SzXNpQrDwB2TSbADaLHmrKZkWiM
         P9glehhd4cp/yEB+8B3L5/i01dMCnTOf226tWKGNiwe64Td7KChz5ZzXC3ZbKkchN8Wc
         pCcJLm0Eel6EMZ5UdhIie2fd/KC0pa5XECq0Ar2WuZUP9s7/hZqp473Qhy4Nahex6pAk
         jyLQ==
X-Gm-Message-State: AC+VfDyfdhdPXxjyUMfgdRlPQ6K+Fwvgwm6P7zwLaoCEQ4DcPS6vSinh
	wNTdU6mMPw+xYZRyoR1+7hVKHA==
X-Google-Smtp-Source: ACHHUZ7nk56mzDYiAT9wFCEdF2R7UM/l7LQUCvy+zHoXf8kX4P6/NvLF3G6egOJgNoAgzo3kH7tTCg==
X-Received: by 2002:a7b:c3c5:0:b0:3f5:189e:af69 with SMTP id t5-20020a7bc3c5000000b003f5189eaf69mr1450740wmj.13.1684255123926;
        Tue, 16 May 2023 09:38:43 -0700 (PDT)
Received: from [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1] (2001-4dd7-624f-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id f5-20020a1c6a05000000b003f4fbd9cdb3sm2824595wmc.34.2023.05.16.09.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 09:38:43 -0700 (PDT)
Date: Tue, 16 May 2023 18:38:42 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
To: Stephen Hemminger <stephen@networkplumber.org>
cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
    Haye.Haehne@telekom.de, 
    =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <20230427163715.285e709f@hermes.local>
Message-ID: <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de> <20230427132126.48b0ed6a@kernel.org> <20230427163715.285e709f@hermes.local>
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

On Thu, 27 Apr 2023, Stephen Hemminger wrote:

>On Thu, 27 Apr 2023 13:21:26 -0700
>Jakub Kicinski <kuba@kernel.org> wrote:

>> Doesn't ring a bell, what's your setup?

Intel NUC with Debian bullseye on it and a custom qdisc that
limits and delays outgoing traffic, therefore occasionally
returning NULL from .dequeue even if the qdisc is not empty.

iperf3 sending from the same NUC to a device on the network
behind that qdisc where the corresponding iperf server runs.

>It might be BQL trying to limit outstanding packets locally.

Possibly?

Thanks,
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

