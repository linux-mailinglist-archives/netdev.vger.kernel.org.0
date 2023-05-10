Return-Path: <netdev+bounces-1495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFFF76FE012
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A37432814A6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED97014AAD;
	Wed, 10 May 2023 14:25:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5D512B91
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:25:06 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2F09007;
	Wed, 10 May 2023 07:24:43 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34AENknN023679;
	Wed, 10 May 2023 09:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683728627;
	bh=gR6IVuKbRKYO1DmIRDu7mk6S0UxadvOmtfohJs7JR50=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=ItmSnfRFxtgHAabhQiGvTlhdv+SN9n5Qm6WgQMOSmgQreqosoxIPHJh4La2aCOjsl
	 QLjDB0EJat/v+Xwg/nmPT3IJ544OxIZx0ZzuF7ZWt4Rafy3cWgqAo4+vQk4je7GtGM
	 MAXkJ1u2uNSFucdo+zakpJSUI9jk3+Svru7hhUlQ=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34AENkCD021548
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 10 May 2023 09:23:46 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 10
 May 2023 09:23:46 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 10 May 2023 09:23:46 -0500
Received: from [128.247.81.95] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34AENkET008910;
	Wed, 10 May 2023 09:23:46 -0500
Message-ID: <f8077b36-ed89-e957-1aba-f9cda7acd566@ti.com>
Date: Wed, 10 May 2023 09:23:46 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/4] can: m_can: Add hrtimer to generate software
 interrupt
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger
	<wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth
 Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Oliver
 Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-3-jm@ti.com>
 <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
 <84e5b09e-f8b9-15ae-4871-e5e4c4f4a470@ti.com>
 <20230510-salad-decaf-009b9da48271-mkl@pengutronix.de>
Content-Language: en-US
From: Judith Mendez <jm@ti.com>
In-Reply-To: <20230510-salad-decaf-009b9da48271-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Marc,

On 5/10/23 02:21, Marc Kleine-Budde wrote:
> On 09.05.2023 17:18:06, Judith Mendez wrote:
> [...]
>>>> +	if (!mcan_class->polling && irq < 0) {
>>>> +		ret = -ENXIO;
>>>> +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found and polling not activated\n");
>>>> +		goto probe_fail;
>>>> +	}
>>>> +
>>>> +	if (mcan_class->polling) {
>>>> +		if (irq > 0) {
>>>> +			mcan_class->polling = 0;
>>>
>>> false
>>>
>>>> +			dev_dbg(mcan_class->dev, "Polling enabled and hardware IRQ found, use hardware IRQ\n");
>>>
>>> "...using hardware IRQ"
>>>
>>> Use dev_info(), as there is something not 100% correct with the DT.
>>
>> Is it dev_info or dev_dbg?
> 
> dev_info() - But without an explicit "poll-interval' in the DT, this
> code path doesn't exist anymore.
> 
>> I used to have dev_info since it was nice to see when polling was
>> enabled.
> 
> Re-read your code, this is not about enabling polling. This message
> handles the case where an IRQ was given _and_ "poll-interval" was
> specified. So there is something not 100% correct with the DT (IRQ _and_
> polling), but this is obsolete now.

Sorry, I meant it was nice to see when polling was enabled or not. In

this case, if polling was enabled but hardware IRQ exists, it is good

information to see this print. But I understand now how this is a case

where 'something is strange'.

>> Also, I had seen this print and the next as informative prints, hence the dev_info().
> 
> We don't print messages when IRQs are enabled, so enabling polling
> should be a dev_dbg(), too.
> 
>> However, I was told in this review process to change to dev_dbg. Which is correct?
> 
> Driver works correct -> dev_dbg()
> Something is strange -> dev_info()

Got it, this is very helpful. Thanks.



regards,

Judith

