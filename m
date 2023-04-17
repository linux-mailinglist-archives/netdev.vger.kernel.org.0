Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02E76E4B7E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjDQOcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDQOcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CEE5FD8;
        Mon, 17 Apr 2023 07:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E9961C01;
        Mon, 17 Apr 2023 14:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56642C433D2;
        Mon, 17 Apr 2023 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681741921;
        bh=qZwGgXwj74zjmmmG+1bRkrLbz6C/n830VkCa80+0q3k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JQmlZNPpvZPotgMsSrI/tmK/cig3Ot4xYX5389aGKCX/PiT5jEjrKfCv8Jm+uDMWI
         c422Xpq/411fGx3ag+rZGXz4KCg9ggPtmB1Xh+WdYAcgCZ8t+EzRBFDPUuMXi8uHj2
         KdQuFpfBcnP558W9jb0B5KV4DctWHI2P9Gd0qJxS9y24usT+Ep/sas5ERx0nSwctks
         udSDeGzoN/IBqVsTpyRUGnTo18pMz4V7E0Q+dlXBABP6OA4e/U/guFB8Q+vCr7iocD
         pGdeL594bigrJ629aefx4p2wViv2KD7udJQKqpsJ41slSlIhFseUxdFTvz2LPorUlZ
         0XUk0YPJYVRCQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: Convert ATH10K to YAML
References: <20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org>
        <87pm82x1ew.fsf@kernel.org>
        <8a6834d6-8e5a-3c48-8a04-8d9c4d160408@linaro.org>
Date:   Mon, 17 Apr 2023 17:31:56 +0300
In-Reply-To: <8a6834d6-8e5a-3c48-8a04-8d9c4d160408@linaro.org> (Konrad
        Dybcio's message of "Mon, 17 Apr 2023 15:36:59 +0200")
Message-ID: <878reqwper.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konrad Dybcio <konrad.dybcio@linaro.org> writes:

> On 17.04.2023 12:12, Kalle Valo wrote:
>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>> 
>>> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
>>> be reconsidered on the driver side, especially the latter one.
>> 
>> I'm curious, what do you mean very little? We set ath10k firmware
>> parameters based on these coex properties. How would you propose to
>> handle these?
>
> Right, I first thought they did nothing and then realized they're
> sent to the fw.. I never amended the commit message though..

Ok, I can remove that sentence before I commit the patch.

>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
>>> @@ -0,0 +1,358 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/wireless/qcom,ath10k.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Qualcomm Technologies ATH10K wireless devices
>> 
>> [...]
>> 
>>> +  wifi-firmware:
>>> +    type: object
>>> +    additionalProperties: false
>>> +    description: |
>>> +      The ATH10K Wi-Fi node can contain one optional firmware subnode.
>>> +      Firmware subnode is needed when the platform does not have Trustzone.
>> 
>> Is there a reason why you write ath10k in upper case? There are two case
>> of that in the yaml file. We usually write it in lower case, can I
>> change to that?
>
> No particular reason, my brain just implicitly decided that it
> should be this way.. Please unify it (or LMK if you want me to
> perform another resend)!

No need to resend. I already changed these to lower case in my pending
branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ca448a93d8669a3af5aa644725444aa61b4ca255

I'll remove the coex sentence later.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
