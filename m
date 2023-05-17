Return-Path: <netdev+bounces-3389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A79706D63
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6FDA2813EC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6BB111AC;
	Wed, 17 May 2023 15:54:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBA9111A4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:54:17 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE00A275
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:53:46 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f41dceb9c9so7241975e9.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1684338825; x=1686930825;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XLWUL3MRVNN8gIuA/oo3QRmVkiRZrJuI7xxxRWxsosg=;
        b=GXyA9HIAPJGggV6RhRn+icCdh3bdVcUPnmocTDt2zU+R5J2j4fYZMo+gJbewh4QtWn
         92XlAYn6ouWYZc8nFvA9D5GXppine4aBZbVFRwvhgn9k0KpAOxTHOFKf4eq4gXhzn7fG
         c6ZiO4mUPXLU0IOZtNDtH/yoDX/Cxjig90C1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684338825; x=1686930825;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XLWUL3MRVNN8gIuA/oo3QRmVkiRZrJuI7xxxRWxsosg=;
        b=ZCQyNyUDMJlNKE80hfIMTbTAasbaUYg8UBDSqmXVxokBwxpGJXfnLtaEU7q2jqq7uP
         sHxKw5rQQsMsod/aLYIrYZn2TqTdVSIyTEG953cl46AEj/l+8y/nhICQzPf/dYgx1Z9f
         8tgqcc9uMWs0DUlNhfl5FFR1S/vHTJQyNJ/duA3037GLpHZ0I5O8uWd6W1z0kJhPSdlS
         LgqmcHhlA4IgQE584cbB+bm0R97XiEgWH8HRRMfmQ5NQ6TO7gvY0YRY16h2T4URVYdTU
         8VlHhoycdpq1oyDUoGi6rs3zk8iWYENt7ZH1ORS0SCzNH5CUH5meLw/Fag3C7aJeUEW9
         F7iQ==
X-Gm-Message-State: AC+VfDyjofc83mDMUrT6035U2IebaJ/lgNud2Ku+fH1vRujmHQmyJR7Y
	omWQ+RJZjVANfnPsZFXinijVnk5+wskcofbnUUM=
X-Google-Smtp-Source: ACHHUZ5ErGEDms7UCeY/S8TPunPzup8+BkS3z+os8mkLsS83Tv42oNTZ48yk/uhOy0H+KCjpWvmlJw==
X-Received: by 2002:a05:600c:2247:b0:3f4:2365:e5b9 with SMTP id a7-20020a05600c224700b003f42365e5b9mr25310296wmm.34.1684338824878;
        Wed, 17 May 2023 08:53:44 -0700 (PDT)
Received: from [2001:4dd6:2021:0:21f:3bff:fe0d:cbb1] (2001-4dd6-2021-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd6:2021:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id q20-20020a1cf314000000b003f508777e33sm2635191wmq.3.2023.05.17.08.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 08:53:43 -0700 (PDT)
Date: Wed, 17 May 2023 17:53:41 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
To: Stephen Hemminger <stephen@networkplumber.org>
cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>, 
    Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
    Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <20230516200251.444f633f@hermes.local>
Message-ID: <ffdf70c7-a1d-9ff1-733e-574ca5664797@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de> <20230427132126.48b0ed6a@kernel.org> <20230427163715.285e709f@hermes.local> <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk> <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
 <87y1loapvt.fsf@toke.dk> <20230516160111.56b2c345@hermes.local> <d3fcafc-08-a74e-8bc8-b93cfcd2f5ef@tarent.de> <20230516164423.3e5b45e9@hermes.local> <3a4b33a1-5dc5-ac66-c5ee-679ff560fd8@tarent.de> <20230516200251.444f633f@hermes.local>
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

>The bottom line is the upstream kernel is very unlikely to accept
>an knob that is only useful with a non upstream kernel component.

I wasn=E2=80=99t asking for a new knob, I was asking whether one existed
already and if not then so be it.

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

