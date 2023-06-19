Return-Path: <netdev+bounces-11824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB68D7349F6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 04:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE6FB1C208FC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 02:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9C9186F;
	Mon, 19 Jun 2023 02:15:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716FF139C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:15:35 +0000 (UTC)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144A4E47;
	Sun, 18 Jun 2023 19:15:34 -0700 (PDT)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-77e35504c1bso72174939f.1;
        Sun, 18 Jun 2023 19:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687140933; x=1689732933;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bBtnlsl4Pv/CEloCUaVVZxW6xo2UFnTXvxqXhklKZoE=;
        b=F5G9pRqhc5Cjsfg18aNpWbo5KZrFVgZ7ffKzGXaOnp0SFk+QyL1JHtuvbruDBqAG6C
         WRVjbUkiDcujmaESnfQjI2Ota77+xRuEzc4g3KD7GPVHe4cSdqUWUXfTDuAaGU2kL5NK
         0Q/c32e7BE9/LVc8JLeHJwocuds2oPgvDj44k3IO1eJPF5WboKkdjHKRQkFSEoX34m17
         m9RtjajHnoxU5TiMOd/DYlMxq+wyjUFbxbquJ9QJbbcbyjsrLM4x5u/CGG9Mhaa7Peld
         I4YdH/EFDc1A6FfyB3bdBHZ6fQhv3lNSgoOCVxgX9nHFMHV2WDdggCBVImY14RjAdC0S
         vdLQ==
X-Gm-Message-State: AC+VfDz/7J9esFyODZADHYkCNj+axDXNka2z+MrCBcw4vwM+y2ssG9JN
	yHPSYSxBGWZQxVQ7dh/SOQ==
X-Google-Smtp-Source: ACHHUZ4vbf5Ns9/6gGG0RTqSrtAFSQNlqmKu62lK5EfG6OfihpRyqotDLGVxGu+nbKPTCZABchn2lw==
X-Received: by 2002:a5d:8f95:0:b0:766:48cf:6ca9 with SMTP id l21-20020a5d8f95000000b0076648cf6ca9mr8693407iol.12.1687140933249;
        Sun, 18 Jun 2023 19:15:33 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id k25-20020a02cb59000000b0042675e04900sm290517jap.119.2023.06.18.19.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 19:15:32 -0700 (PDT)
Received: (nullmailer pid 2833 invoked by uid 1000);
	Mon, 19 Jun 2023 02:15:27 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rob Herring <robh@kernel.org>
To: niravkumar.l.rabara@intel.com
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>, Richard Cochran <richardcochran@gmail.com>, Wen Ping <wen.ping.teh@intel.com>, Stephen Boyd <sboyd@kernel.org>, Michael Turquette <mturquette@baylibre.com>, devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, netdev@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <20230618132235.728641-3-niravkumar.l.rabara@intel.com>
References: <20230618132235.728641-1-niravkumar.l.rabara@intel.com>
 <20230618132235.728641-3-niravkumar.l.rabara@intel.com>
Message-Id: <168714092772.2813.6608190334028827343.robh@kernel.org>
Subject: Re: [PATCH 2/4] dt-bindings: clock: Add Intel Agilex5 clocks and
 resets
Date: Sun, 18 Jun 2023 20:15:27 -0600
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Sun, 18 Jun 2023 21:22:33 +0800, niravkumar.l.rabara@intel.com wrote:
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

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/clock/intel,agilex5.yaml: title: 'Intel SoCFPGA Agilex5 platform clock controller binding' should not be valid under {'pattern': '([Bb]inding| [Ss]chema)'}
	hint: Everything is a binding/schema, no need to say it. Describe what hardware the binding is for.
	from schema $id: http://devicetree.org/meta-schemas/core.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230618132235.728641-3-niravkumar.l.rabara@intel.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


