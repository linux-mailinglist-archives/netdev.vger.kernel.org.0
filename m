Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2143A5BD068
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiISPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 11:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiISPQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 11:16:32 -0400
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6B38696;
        Mon, 19 Sep 2022 08:15:47 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 11DFC58012A;
        Mon, 19 Sep 2022 11:15:46 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 11:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1663600546; x=1663607746; bh=V2
        NHp03LEGFatOiT5SjFLIfjK3Dfgn5PwWj8407qQ9U=; b=sL0wAf4fnlz910F4Vz
        odUFag9auWhR/JyQhsLSE2hhs2iaOmseZ2lH4k1AI6HmHq43B6Os0UKYrwZtTeOX
        3s6ldQyHOblUK8qk1b+gAXaPyQlPiQkA4uwasunUQ2yj1TUlzVnEwEbVHsx00zRE
        kM3JXx7k+m6N2TPkCtLZ6VKUb7mu1xgy9r/LIog9I7rdaHflnXmE8FYjKJiCsRxO
        Uh4ZPnTHM6MahoycLN32BjqQSsl9MubT1fF8Yyl42/N5Gg+LUbNxudFDwthhbdk8
        Z4Wm3tGF+eRhPigVD+N9/sS5/nutzPX0rC5gxa4njw9m1geXcFCOono28a5UAs7H
        MiJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663600546; x=1663607746; bh=V2NHp03LEGFatOiT5SjFLIfjK3Df
        gn5PwWj8407qQ9U=; b=0T3K43FVWjJFjss+Dr0RpPQff86JEiZ/mtijgFEbUr/l
        V1wb621rNSwI4xv7bWmNSm3tVuNlCf1JR8T49wMQJtNMmbmGIxrPwPrpEbAdrp6+
        XssX+ZjvHat2nIGd+3gCBFOkNmK4JZW0369RrKyfF4khiD8NzXoybiJM3g2QqiLA
        6hWugCya3tqgP/uFNzfKAHFe0vakoFK9nS96AFLXQsnjquOyaNNMc/f/pMNVNBZ6
        orD0qmkHv/0GjynpRJAvkXhTW+m8MRFmrgfhFuk/YN2Wnd1S8I/+sbvznRorZbUy
        NO431d1qd1FTaT9qoiKMeckANp7jhSiq3JiJuRLkig==
X-ME-Sender: <xms:n4coY4w3oVzkvr77PB1H4fmBb40ZfQZy2NPF_wgQPMfKT_UHaIdYBg>
    <xme:n4coY8SKki3oKPC9hfhlcZPz5VA3fXj7KTW57FsLva5PyKbe-mf9IPkv4NNRGtd0Y
    SAbxqDZb8ytBlKk-FI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfufhv
    vghnucfrvghtvghrfdcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrf
    grthhtvghrnhepfeegudfghfejvdffgffgkeetuddtteeuheduiedtgfdufedvudeitddv
    leeivdfgnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgv
    thgvrhdruggvvh
X-ME-Proxy: <xmx:n4coY6WFIew5Sc41BNZQRbuHJ6iDGtkghtY6vE2WG9w9A2UjvI4pnA>
    <xmx:n4coY2iRVzdGAhuC6fa-__H6wK_f2H5UR-DQhjwLL0c0IMnCDFe5Xw>
    <xmx:n4coY6AdELWjRb6eLemIUP2tTRNz8fz4-rgm_i1QEoe-z4Jsf_HbeA>
    <xmx:oocoY04cLhYi_fAbiGr4SEo2BotTLrK9LYGTnOoJWrSydn28MXNgNQ>
Feedback-ID: i51094778:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C7BA1A6007C; Mon, 19 Sep 2022 11:15:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <c7c1e2a8-2293-4060-b17f-dcfce98ee219@app.fastmail.com>
In-Reply-To: <35722313-6585-1748-6821-aebe0859ef6e@linaro.org>
References: <20220907170935.11757-1-sven@svenpeter.dev>
 <20220907170935.11757-2-sven@svenpeter.dev>
 <35722313-6585-1748-6821-aebe0859ef6e@linaro.org>
Date:   Mon, 19 Sep 2022 17:15:43 +0200
From:   "Sven Peter" <sven@svenpeter.dev>
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hector Martin" <marcan@marcan.st>,
        "Alyssa Rosenzweig" <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <bjorn.andersson@linaro.org>,
        "Konrad Dybcio" <konrad.dybcio@somainline.org>,
        "Balakrishna Godavarthi" <bgodavar@codeaurora.org>,
        "Rocky Liao" <rjliao@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: net: Add generic Bluetooth controller
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Sep 8, 2022, at 13:16, Krzysztof Kozlowski wrote:
> On 07/09/2022 19:09, Sven Peter wrote:
>> 
>> Bluetooth controllers share the common local-bd-address property.
>> Add a generic YAML schema to replace bluetooth.txt for those.
>> 
>> Signed-off-by: Sven Peter <sven@svenpeter.dev>
>> ---
>> changes from v1:
>>   - removed blueetooth.txt instead of just replacing it with a
>>     deprecation note
>>   - replaced references to bluetooth.txt
>> 
>> checkpatch complains here because it thinks I do to many things at once,
>> I think it's better to replace bluetooth.txt in single commit though.
>> Let me know if you prefer this to be split into multiple commits
>> instead.
>> 
>> .../bindings/net/bluetooth-controller.yaml    | 30 +++++++++++++++++++
>
> I propose to keep it in net/bluetooth subdirectory. In next patch you
> can move there other files.

Sure, I can also already move net/qualcomm-bluetooth.yaml to the new
subdirectory since I need to touch it in this commit anyway.

>
>>  .../devicetree/bindings/net/bluetooth.txt     |  5 ----
>>  .../bindings/net/qualcomm-bluetooth.yaml      |  4 +--
>>  .../bindings/soc/qcom/qcom,wcnss.yaml         |  8 ++---
>>  4 files changed, 35 insertions(+), 12 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml
>>  delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/net/bluetooth-controller.yaml b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
>> new file mode 100644
>> index 000000000000..0ea8a20e30f9
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
>> @@ -0,0 +1,30 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/bluetooth-controller.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Bluetooth Controller Generic Binding
>> +
>> +maintainers:
>> +  - Marcel Holtmann <marcel@holtmann.org>
>> +  - Johan Hedberg <johan.hedberg@gmail.com>
>> +  - Luiz Augusto von Dentz <luiz.dentz@gmail.com>
>> +
>> +properties:
>> +  $nodename:
>> +    pattern: "^bluetooth(@.*)?$"
>> +
>> +  local-bd-address:
>> +    $ref: /schemas/types.yaml#/definitions/uint8-array
>> +    minItems: 6
>
> No need for minitems.

Ok, dropped.


Best,


Sven
