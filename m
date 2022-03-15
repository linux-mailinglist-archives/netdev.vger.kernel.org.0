Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E984D953D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345398AbiCOH1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345396AbiCOH1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:27:46 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4D54B1CA
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 00:26:34 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 22B69405A5
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 07:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647329193;
        bh=6W+HqHw1FUgoLMsYmyHiWYylWMCDG3fxoibhab4YrX8=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=m+KJCVZh9JPnu4nYwprZ35sFH0nReBPlc7tQ7ey8W0S6mS7h8oS5yvjwv52j5WtdV
         QZd0YJa5iI+D2wFkfVWOl/sUeZbpiHims2GjJUDJU/PF8G6EyF9LevUnFxcGyAZfeh
         YHplgW55G2tHW5n3TWHZdVToss6McaMtf60yu09EX1AUTfUAPe7B4UtYYjnCxA6z3q
         DBcyqNWCPDDk6uR97VzGHDY7QZpEFQwpIQaBoh/TXzN0thdyiX3FO1pvIsGa6kPo4d
         jZByh5CKu2mSaRjF5S92QKlMloXTCL5CkoE+kFU/2w78ay5Odbumr2hhlLvO7r0iEk
         oZCK8HExVOSdA==
Received: by mail-ej1-f69.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so9191243eje.6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 00:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6W+HqHw1FUgoLMsYmyHiWYylWMCDG3fxoibhab4YrX8=;
        b=qpIKrs+bSO9xguJROLJ2TqvuOShqG6LTb1GpK+KdOyfRAA/xZ/IaXu2eK/7g8hlIAv
         eNjLKU2dXQbCnOtdZpPqPl0AxSuQVb9z+Ik0eeFeLqCSAW958O0IGSTHvj5tQ7GRyDe9
         H7ntJaX2FwMcB5n0RezI+mVIgu9mMSjNRrnzR5JaEdDDBg7wpI3IRDCQYKcsKMGcOgpF
         k9BedGXC0qeWq9uEN37sTv3CB21+5uCTJRXFf3/P5kXNNQPtlj4uqhhCgoYj3eNDQC3C
         QdUKlZGJAWLAXx0Cte4I4UW+LNdTK2pXws744A2Y8WxILS0dm+AjuS9dUsdmXZhbtYR2
         DIMA==
X-Gm-Message-State: AOAM531tbvsKvsNLsTVjabDb2ctH3Nxs77diwanq6QxPSK70CrTZHm1r
        fgv1X0vVEanXvn10NrjzgMY5tZTw0MK8/gsSwK5UDveiTxyOtzScnmvk82Zi9psT4muH0e3KTRI
        fFUd9KCUJ8pU//SAa9YOpMcxQxKM2imZ6pw==
X-Received: by 2002:a17:906:58d6:b0:6da:bc08:af7 with SMTP id e22-20020a17090658d600b006dabc080af7mr21802601ejs.537.1647329192713;
        Tue, 15 Mar 2022 00:26:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnDbQYJVjdkAqS6JFlxy5WBRyCf0iSai3h0i7BrJoEZsIL3UYorPiU2igHiXhm8YdBNZmxXQ==
X-Received: by 2002:a17:906:58d6:b0:6da:bc08:af7 with SMTP id e22-20020a17090658d600b006dabc080af7mr21802587ejs.537.1647329192504;
        Tue, 15 Mar 2022 00:26:32 -0700 (PDT)
Received: from [192.168.0.153] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.googlemail.com with ESMTPSA id si13-20020a170906cecd00b006cded0c5ee2sm7866659ejb.61.2022.03.15.00.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 00:26:31 -0700 (PDT)
Message-ID: <ed530a57-b339-a8c4-93a6-5666e95f104e@canonical.com>
Date:   Tue, 15 Mar 2022 08:26:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Content-Language: en-US
To:     Amit Kumar Kumar Mahapatra <akumarma@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>, git <git@xilinx.com>
References: <20220310153909.30933-1-amit.kumar-mahapatra@xilinx.com>
 <78c7b777-1527-759f-41f7-bd8422cb4eb0@canonical.com>
 <DM8PR02MB7926512883E8C0AF954AE2F6BA109@DM8PR02MB7926.namprd02.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <DM8PR02MB7926512883E8C0AF954AE2F6BA109@DM8PR02MB7926.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2022 06:38, Amit Kumar Kumar Mahapatra wrote:
> Hello Krzysztof,
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> Sent: Thursday, March 10, 2022 10:25 PM
>> To: Amit Kumar Kumar Mahapatra <akumarma@xilinx.com>;
>> wg@grandegger.com; mkl@pengutronix.de; kuba@kernel.org;
>> robh+dt@kernel.org; Appana Durga Kedareswara Rao
>> <appanad@xilinx.com>
>> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org;
>> devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>> kernel@vger.kernel.org; Michal Simek <michals@xilinx.com>; git
>> <git@xilinx.com>; Amit Kumar Kumar Mahapatra <akumarma@xilinx.com>
>> Subject: Re: [PATCH v3] dt-bindings: can: xilinx_can: Convert Xilinx CAN
>> binding to YAML
>>
>> On 10/03/2022 16:39, Amit Kumar Mahapatra wrote:
>>> Convert Xilinx CAN binding documentation to YAML.
>>>
>>> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-
>> mahapatra@xilinx.com>
>>> ---
>>> BRANCH: yaml
>>>
>>> Changes in v2:
>>>  - Added reference to can-controller.yaml
>>>  - Added example node for canfd-2.0
>>>
>>> Changes in v3:
>>>  - Changed yaml file name from xilinx_can.yaml to xilinx,can.yaml
>>>  - Added "power-domains" to fix dts_check warnings
>>>  - Grouped "clock-names" and "clocks" together
>>>  - Added type $ref for all non-standard fields
>>>  - Defined compatible strings as enum
>>>  - Used defines,instead of hard-coded values, for GIC interrupts
>>>  - Droped unused labels in examples
>>>  - Droped description for standard feilds
>>> ---
>>>  .../bindings/net/can/xilinx,can.yaml          | 161 ++++++++++++++++++
>>>  .../bindings/net/can/xilinx_can.txt           |  61 -------
>>>  2 files changed, 161 insertions(+), 61 deletions(-)  create mode
>>> 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
>>>  delete mode 100644
>>> Documentation/devicetree/bindings/net/can/xilinx_can.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
>>> b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
>>> new file mode 100644
>>> index 000000000000..78398826677d
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
>>> @@ -0,0 +1,161 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) %YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/can/xilinx,can.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title:
>>> +  Xilinx Axi CAN/Zynq CANPS controller
>>> +
>>> +maintainers:
>>> +  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - xlnx,zynq-can-1.0
>>> +      - xlnx,axi-can-1.00.a
>>> +      - xlnx,canfd-1.0
>>> +      - xlnx,canfd-2.0
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>> +
>>> +  interrupts:
>>> +    maxItems: 1
>>> +
>>> +  clocks:
>>> +    minItems: 1
>>> +    maxItems: 2
>>> +
>>> +  clock-names:
>>> +    maxItems: 2
>>> +
>>> +  power-domains:
>>> +    maxItems: 1
>>> +
>>> +  tx-fifo-depth:
>>> +    $ref: "/schemas/types.yaml#/definitions/uint32"
>>> +    description: CAN Tx fifo depth (Zynq, Axi CAN).
>>> +
>>> +  rx-fifo-depth:
>>> +    $ref: "/schemas/types.yaml#/definitions/uint32"
>>> +    description: CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in
>>> + sequential Rx mode)
>>> +
>>> +  tx-mailbox-count:
>>> +    $ref: "/schemas/types.yaml#/definitions/uint32"
>>> +    description: CAN Tx mailbox buffer count (CAN FD)
>>
>> I asked about vendor prefix and I think I did not get an answer from you
>> about skipping it. Do you think it is not needed?
> 
> Sorry, I went through all your previous comments but I couldn't find the 
> comment where you had asked about vendor prefix. Could you please point
> me to it ?
> We can add vendor prefix to non-standard fields, but we need to update 
> driver to be aligned with it and deprecate original property which has been 
> added in 2018 and acked by Rob and Marc at that time.
> https://github.com/torvalds/linux/commit/7cb0f17f5252874ba0ecbda964e7e01587bf828e

Ah, I am sorry, apologies. I have never asked for the prefix and I
should not mention it here. I think I got confused with different
patchset but this one here is conversion. The prefix is not needed.

Best regards,
Krzysztof
