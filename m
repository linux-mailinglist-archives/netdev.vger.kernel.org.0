Return-Path: <netdev+bounces-3390-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 228AF706D6A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3DE41C20EB5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095EC111A5;
	Wed, 17 May 2023 15:55:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DF44436
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:55:05 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569A97DAA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:54:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f42bcf5df1so9480615e9.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684338874; x=1686930874;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WW3yc6qLDSVEyyghngTSd5Z5D/V4s7AWzrzlbaFSmj0=;
        b=Dd/oHRRoSwzYdOM5xht4igEQaz/5iduktDtWzSIEN3Vqf88LP2wLu9ZE6PyowtBwFB
         fwZ8EoRqcRFdb5F/06eYWEgvvEZiBLodiSKKUxJuj4lsZxrk4gd1QXD+Q8t7y6DDTAiD
         PnKG5m/O/BWUx96AYEwCG9VQRdzr5a++n5x4SoyU+PmmVRs2HqO+o6cO2/y8JrERxGfs
         vBqoQ6lInj53SSnSyP245Wn+06BZ30PTdXV++b2bMvkdg0oe/cKFF1bUZiy+7hH6wspI
         V3IXzN0Lb4vd9SQ9sDQbmRlcvYMO7ZbWYKjSJ/T8FfE4DqIq3RbxqI+6i5TXw454i17B
         4gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684338874; x=1686930874;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WW3yc6qLDSVEyyghngTSd5Z5D/V4s7AWzrzlbaFSmj0=;
        b=cKAYynJuK1Ql7ACGIjXbLpavObjFoz1UbXo75HV9ke1NCorTDE3vFbNTfN++HSGODV
         fimeG2DfiVT+geKacAyku4y2b+6FzPAzPMegSAMD+HEIxL6X8NQTmd53bQYtDW3nxh9r
         W0C+O6GzJD3uH1NziypB3O9/7hFEh+EoZBwqbTAPGZbZbM4pysZFa49MnJtmvQKKwdhr
         q+JVQksE8fxUsgQEsG1NeTQAbdApziBTKePOHT3IuXXkUbjWjW8wbeo7YhQxL9zlw7cc
         kg8bG/+/uBGi/vXAXd3g8+WNR/eB8bVTcf8YkcGpmnjs+rSRADbbU8pbHkgPxl3uByNy
         KV7w==
X-Gm-Message-State: AC+VfDzO8vm3I2PDzcDKWQIG638X6dZ1V7NhheHDqmp20GPRoO7Fvg5q
	6apN+1F5JW1E+T5xEn6Nr3KRxa7Wjjw=
X-Google-Smtp-Source: ACHHUZ46MMcmlILJAeUbwCj3hQtObW4rkyyWCHF4jHp92dboS3zcEESTJmeA/3NAtnkq8nPQHV97Uw==
X-Received: by 2002:a05:600c:2146:b0:3f5:60b:31 with SMTP id v6-20020a05600c214600b003f5060b0031mr8706025wml.27.1684338874129;
        Wed, 17 May 2023 08:54:34 -0700 (PDT)
Received: from ?IPV6:2a02:3100:9170:3300:755b:bc80:4fec:8610? (dynamic-2a02-3100-9170-3300-755b-bc80-4fec-8610.310.pool.telefonica.de. [2a02:3100:9170:3300:755b:bc80:4fec:8610])
        by smtp.googlemail.com with ESMTPSA id v5-20020a1cf705000000b003f4f1b884b3sm2592286wmh.20.2023.05.17.08.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 08:54:33 -0700 (PDT)
Message-ID: <e422df96-7fd8-5ebc-444c-58464f500f5d@gmail.com>
Date: Wed, 17 May 2023 17:54:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Toshiba 1179:fbb0 (r8169)
To: Tom Doenen <tom@inkblu.nl>
References: <2762fd68-d0c0-0f1a-0371-502938e66e18@inkblu.nl>
Content-Language: en-US
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <2762fd68-d0c0-0f1a-0371-502938e66e18@inkblu.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17.05.2023 13:36, Tom Doenen wrote:
> Good afternoon,
> 
> we have a few Toshiba laptops within our organisation who seem to have a specific (rebranded?) RTL 810xE pci ethernet chip.
> At bootup the Linux driver asks to inform the maintainer of the r8169 driver/module.
> 
> The device identifiers are :  10ec:8136  and 1179:fbb0
> 
> Would it be possible to add this identifier to the driver/module ?
> ( kernel upto 6.3.2 does not include this signature )
> 
The PCI ID is standard and recognized, otherwise r8169 wouldn't be loaded.
Supposedly what you mean is that the chip XID isn't recognized.
Please provide a full dmesg log of an affected machine.

> Do you need any further information ?
> 
> Kind regards,
> Tom Doenen
> 
> 
Heiner


