Return-Path: <netdev+bounces-11804-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6D27347B6
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1997C280FB1
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA4A79C2;
	Sun, 18 Jun 2023 18:49:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9755380
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:49:58 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284B61A8
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:49:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9875c2d949eso290942566b.0
        for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687114195; x=1689706195;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=egmO6OV1Bz5VQAFOcSA2yvmgko4DP3AIwWBe4wogBpU=;
        b=wLCkTuSoXWs5OS2GH4oguloxCQysCpprbQeNWLtky7hUgZHjRadqUIbRvgawQNifDQ
         oxsEjZsPi9sAxu1RMB+b6Klph0vydmaobht3oGdC7URgNF1q2If0fGEO7pOTYDuWK27e
         VrlJ/HJWC6AOvmTj1YhacvKVSO+odtnr2b+P8y0dDKt7jJTR2ju5viq7L3/yT4tfOES2
         vjwF8mcoTDS6SfdK6g6+kNefAL3dEbyicUvm2FMAtyx1ovF/VV+8hdB05ojPtRWjhBEs
         eXC690pbMVE1af9SPWw7oE/Rb2ZaPOBnoVkyEon98jUDMHAWCQ1tD7SGa6LrXdTVhfEG
         eJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687114195; x=1689706195;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=egmO6OV1Bz5VQAFOcSA2yvmgko4DP3AIwWBe4wogBpU=;
        b=VVyN7ISW9yFtWouboPOYgsv0/gujBdEljIIgAu5JDAxoputxXFrx7Q4P8uBpieCudn
         5/3A03TS6c3D1yTZtT23Y39qUAIMQRxaBk3dnkSwwjxurNRsNxf3fC/4q0dF7iPuiTVy
         pPpPkK70J9JdRPGHrsYp0lqO17VaDUry0k1YLBdkaHoOpUpypmSBvL460yt/mQj5odCz
         V/hcuoVwN5NSDkVA9qugAGxfyTFDxOMzVYE/mTbXNc9fQuMnDq212LvCwUiRPEvIEbl1
         8z5k/lSCuk9Sh9ZjjZfb1zR/xz1nHgDCBlyyS06kptUSKEPbk3tgf74xXHe/7/+v0NFD
         SxoA==
X-Gm-Message-State: AC+VfDyoUaxfl7reHTG04d4Wr5cIG0x3/cQlr1zDoy6x8/RsCs///+2z
	uGwdW2umSpKBBG9n8FHsJjgyAw==
X-Google-Smtp-Source: ACHHUZ6ixmDs1JdGQPRJq6X11DNyyezRvqtTA2KxBvxWBzmnAllpu+/PMH+f+AF/HZ/Q80Y3VkcLSw==
X-Received: by 2002:a17:907:9406:b0:988:2a2f:919f with SMTP id dk6-20020a170907940600b009882a2f919fmr3215551ejc.6.1687114195206;
        Sun, 18 Jun 2023 11:49:55 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id p13-20020a1709060e8d00b00982a99d9757sm4912284ejf.221.2023.06.18.11.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jun 2023 11:49:54 -0700 (PDT)
Message-ID: <8d5f38e6-2ca6-2c61-da29-1d4d2a3df569@linaro.org>
Date: Sun, 18 Jun 2023 20:49:52 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/4] dt-bindings: clock: Add Intel Agilex5 clocks and
 resets
Content-Language: en-US
To: niravkumar.l.rabara@intel.com, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
 Wen Ping <wen.ping.teh@intel.com>, Richard Cochran
 <richardcochran@gmail.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 netdev@vger.kernel.org, Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>
References: <20230618132235.728641-1-niravkumar.l.rabara@intel.com>
 <20230618132235.728641-3-niravkumar.l.rabara@intel.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230618132235.728641-3-niravkumar.l.rabara@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 18/06/2023 15:22, niravkumar.l.rabara@intel.com wrote:
> From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
> 
> Add clock and reset ID definitions for Intel Agilex5 SoCFPGA
> 
> Co-developed-by: Teh Wen Ping <wen.ping.teh@intel.com>
> Signed-off-by: Teh Wen Ping <wen.ping.teh@intel.com>
> Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
> ---
>  .../bindings/clock/intel,agilex5.yaml         |  42 ++++++++
>  include/dt-bindings/clock/agilex5-clock.h     | 100 ++++++++++++++++++
>  .../dt-bindings/reset/altr,rst-mgr-agilex5.h  |  79 ++++++++++++++
>  3 files changed, 221 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/intel,agilex5.yaml
>  create mode 100644 include/dt-bindings/clock/agilex5-clock.h
>  create mode 100644 include/dt-bindings/reset/altr,rst-mgr-agilex5.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/intel,agilex5.yaml b/Documentation/devicetree/bindings/clock/intel,agilex5.yaml
> new file mode 100644
> index 000000000000..e408c52deefa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/intel,agilex5.yaml

Filename matching compatible, so missing "clk"

> @@ -0,0 +1,42 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/clock/intel,agilex5.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Intel SoCFPGA Agilex5 platform clock controller binding

Drop "binding"

> +
> +maintainers:
> +  - Teh Wen Ping <wen.ping.teh@intel.com>
> +  - Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
> +
> +description:
> +  The Intel Agilex5 Clock controller is an integrated clock controller, which
> +  generates and supplies to all modules.

"generates and supplies" what?

> +
> +properties:
> +  compatible:
> +    const: intel,agilex5-clkmgr


Why "clkmgr", not "clk"? You did not call it Clock manager anywhere in
the description or title.

> +
> +  '#clock-cells':
> +    const: 1
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#clock-cells'

Keep the same order as in properties:

> +
> +additionalProperties: false
> +
> +examples:
> +  # Clock controller node:
> +  - |
> +    clkmgr: clock-controller@10d10000 {
> +      compatible = "intel,agilex5-clkmgr";
> +      reg = <0x10d10000 0x1000>;
> +      #clock-cells = <1>;
> +    };
> +...
> diff --git a/include/dt-bindings/clock/agilex5-clock.h b/include/dt-bindings/clock/agilex5-clock.h
> new file mode 100644
> index 000000000000..4505b352cd83
> --- /dev/null
> +++ b/include/dt-bindings/clock/agilex5-clock.h

Filename the same as binding. Missing vendor prefix, entirely different
device name.

> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
> +/*
> + * Copyright (C) 2022, Intel Corporation
> + */

...

> +
> +#endif	/* __AGILEX5_CLOCK_H */
> diff --git a/include/dt-bindings/reset/altr,rst-mgr-agilex5.h b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
> new file mode 100644
> index 000000000000..81e5e8c89893
> --- /dev/null
> +++ b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h

Same filename as binding.

But why do you need this file? Your device is not a reset controller.

Best regards,
Krzysztof


