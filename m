Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8798D6D2243
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjCaOWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjCaOWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6621B34E;
        Fri, 31 Mar 2023 07:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5616A62922;
        Fri, 31 Mar 2023 14:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBBBC433D2;
        Fri, 31 Mar 2023 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680272555;
        bh=MHkM9TprN3NwvT6HN9545BzVvFD+owTbBH/IsXQsX5w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=qKlVOjhZGRXjf4tcrMX2X7Srp0RIS8N9dH8195060p1VxMUbCXsuxm5OfMa92viS2
         UvPWQ8a2CdzmSbyxkwx1axNqY+6IJbj5+6YTKGVzI1CgYFODf7rjbrwp472dopDHm8
         W2D8/ZJjojt7k2HSGqs3Hjk79V5vnzuTP48ySOOZs32Hd6YMQNgZIh45Nvj4CT3+/4
         YHyh1IzqPtrH/D+NCNqKozX++K/LSJnEDOr4+noFwMqm0Nt/2xhybEP3s8iw3ZHGpk
         QlWRyQK/sQEgioVYSbpRufwFmrunBzFA+jOgOBtuVuVrdBno2zig1ouVG/bpvAp31R
         y8SUXTxFdmSNA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Frank Wunderlich <frank-w@public-files.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: mt76: add active-low property for led
References: <20230207133504.21826-1-linux@fw-web.de>
        <7aa132aa-d2fe-e2a1-a2a7-97321a74165c@linaro.org>
        <8a6d8107-436a-1b13-3799-59fa75c59635@gmail.com>
Date:   Fri, 31 Mar 2023 17:22:27 +0300
In-Reply-To: <8a6d8107-436a-1b13-3799-59fa75c59635@gmail.com> (Matthias
        Brugger's message of "Thu, 30 Mar 2023 19:09:19 +0200")
Message-ID: <87r0t5atlo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthias Brugger <matthias.bgg@gmail.com> writes:

> On 07/02/2023 14:36, Krzysztof Kozlowski wrote:
>> On 07/02/2023 14:35, Frank Wunderlich wrote:
>>> From: Frank Wunderlich <frank-w@public-files.de>
>>>
>>> LEDs can be in low-active mode, driver already supports it, but
>>> documentation is missing. Add documentation for the dt property.
>>>
>>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>\
>>
>>
>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>
> Can you take that through your tree or are fine if I take it through mine?

It would be safest if Felix can take this to his tree, less conflicts
the better.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
