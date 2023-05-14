Return-Path: <netdev+bounces-2419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5D1701CC2
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 11:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 981401C20A07
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 09:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD93A4C7D;
	Sun, 14 May 2023 09:51:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA7A1877
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 09:51:42 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB110C2
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 02:51:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so102768589a12.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 02:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684057897; x=1686649897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1B3du+5hpvlLOa22naBqYj3xDgWNzyGiPg0V7Tn+jlA=;
        b=VsizmiPhgVVC017QpqyleBMJ6rMsZ6adYRvRLnGhJXvM5cBZfIoBWaE5nAB954jxuN
         st8r7Jl2src32zEaX6zbGMKCiu/DYREMSOJntv28ncNe4MSjbwcsNNkEmqojhzwQEMPy
         TiBhkH/9MVvjWgr9rszUv8nLkchIcB6+CUOdCpMWnINKSz68ArWroDy8k4La6Qykyg2n
         DOs0t3N/qXQmPLzO8QOvRH0VdPmTxIlbWAGttWitZNSWTlWdu+xemCmudRUbUvti2qmT
         KdJwNdT7SWSzkvsaP/xzEujH99ic+BiL12UtQqqlNMPnrRZ4vf9e45hbZUG1l+nuJ2Kv
         YrkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684057897; x=1686649897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1B3du+5hpvlLOa22naBqYj3xDgWNzyGiPg0V7Tn+jlA=;
        b=bUBf0NCgY7+/3sY0I3NmVolektm1NbidK68MJGVtBY/Xon0BskjMqrofq9gVBXNtWN
         ck/EuBmeMD/HyKG0YEKro6b3fCPM2h89hddN0vsOTYsmtqNr0M0d0LqOTP+9ppozKLfi
         ayhG+zj7NQYf7X2M5t7K4pP88in2KlGUMF/xrfzxDUHEIQewUufFqgk1LRw8YBQdEA/X
         dIPMskSctAAUQtJ/vp6IYcbBCItrwIhjst+o47ofnWV0v+xi6jBOuRkVIIqT1vF+MxE9
         9YLzmYST68QIsiH5tk4lzOfmn+BhY4RQoyAHi+F/jrVm5b4lJGQ52CXzekVD0ieX8Rdw
         50qw==
X-Gm-Message-State: AC+VfDyIe9/4xxmoMAVMW7H/wuHGN5OGkibW6307wchT6ZtLYaQiuHCR
	4wJc3KacemPYYjtKX+AqhRi4IA==
X-Google-Smtp-Source: ACHHUZ58XebRfUPqpJ87adEoTJVSm4nYzk/motHLFcYmh+n/Hi1XU9+7Z/l1hQUhfE06kxij9bcHjA==
X-Received: by 2002:a17:907:8689:b0:96a:316f:8aaa with SMTP id qa9-20020a170907868900b0096a316f8aaamr12388354ejc.37.1684057896845;
        Sun, 14 May 2023 02:51:36 -0700 (PDT)
Received: from krzk-bin ([2a02:810d:15c0:828:715f:ddce:f2ba:123b])
        by smtp.gmail.com with ESMTPSA id r9-20020aa7cb89000000b005021d210899sm5663978edt.23.2023.05.14.02.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 02:51:36 -0700 (PDT)
Date: Sun, 14 May 2023 11:51:33 +0200
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Rudi Heitbaum <rudi@heitbaum.com>
Cc: pabeni@redhat.com, alistair@alistair23.me,
	linux-arm-kernel@lists.infradead.org, jernej.skrabec@gmail.com,
	robh+dt@kernel.org, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, conor+dt@kernel.org,
	anarsoul@gmail.com, devicetree@vger.kernel.org,
	linux-sunxi@lists.linux.dev, luiz.dentz@gmail.com,
	johan.hedberg@gmail.com, kuba@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, edumazet@google.com,
	marcel@holtmann.org, wens@csie.org, linux-kernel@vger.kernel.org,
	samuel@sholland.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: net: realtek-bluetooth: Add RTL8822BS
Message-ID: <20230514095133.b4ojnu6y222kzhcb@krzk-bin>
References: <20230514074731.70614-1-rudi@heitbaum.com>
 <20230514074731.70614-2-rudi@heitbaum.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230514074731.70614-2-rudi@heitbaum.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 14 May 2023 07:47:29 +0000, Rudi Heitbaum wrote:
> Add compatible string for RTL8822BS for existing Realtek Bluetooth
> driver.
> 
> Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
> ---
>  .../devicetree/bindings/net/realtek-bluetooth.yaml  | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml: properties:compatible:oneOf:1:items: 'oneOf' conditional failed, one must be fixed:
	[{'enum': ['realtek,rtl8821cs-bt']}, {'const': ['realtek,rtl8822bs-bt', 'realtek,rtl8822cs-bt']}] is not of type 'object'
	['realtek,rtl8822bs-bt', 'realtek,rtl8822cs-bt'] is not of type 'integer', 'string'
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml: properties:compatible:oneOf:1:items: 'oneOf' conditional failed, one must be fixed:
	[{'enum': ['realtek,rtl8821cs-bt']}, {'const': ['realtek,rtl8822bs-bt', 'realtek,rtl8822cs-bt']}] is not of type 'object'
	['realtek,rtl8822bs-bt', 'realtek,rtl8822cs-bt'] is not of type 'string'
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml#
Traceback (most recent call last):
  File "/usr/local/bin/dt-validate", line 167, in <module>
    sg.check_trees(filename, testtree)
    ...
  File "/usr/lib/python3.10/sre_parse.py", line 599, in _parse
    raise source.error(msg, len(this) + 1 + len(that))
re.error: bad character range s-b at position 18

Note: You even broke the dtschema :)

See https://patchwork.ozlabs.org/patch/1781021

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

