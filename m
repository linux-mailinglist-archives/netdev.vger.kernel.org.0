Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA13B5F3426
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJCRGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJCRGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:06:48 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CDB2C674
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:06:39 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id s17so2202756ljs.12
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 10:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=r0Z5yE/2rNF+pvpyQXUAi3Xvmkjk0yqwlZznS4MM2b4=;
        b=bau++nGklIo7U08JXPGNo3iOg9p0MFPrhIGm0KZl+ya7g2hPNx7gGTLCiIuVKymW3y
         Cn33CpKQaCpuXY297INCjISDyjOnMyXKZawwlAC6UsW1zHLOrUcJGHoEOpf5SxNbhfW9
         HnLTGTbwhVN3mek7dbcybwTPKSYXhuS/35AQyKT9J6XoRNG15VlkkDQgHy1azjXp12pA
         mWeprimevmA4Jf3l7W9MvnwcYFpCGHxA9p38NS1ZqMyELUnyejIkKwvCp8w+lzIuQidV
         nMbmPQRcjScml/4s0F0rBwKzmFLw8PqwzYRjTOHJdQcVLW7QTohqJxipR9fAOt7PJpX5
         DTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=r0Z5yE/2rNF+pvpyQXUAi3Xvmkjk0yqwlZznS4MM2b4=;
        b=X/y7Jw0eOx0vb9PrjhZGb8TG5RCysnQv1wdaN4VtsTwy0yAYP2/4dUjxJeIQglxCKv
         TqRMFx+pKy1NepNw2FTkEFKt8sq4v/seP8T/CQAUXFBrLRXZG0ecdPPHZbzlEeBC5XPc
         qV/lpJniQVLVDLWUG5t2upvPf4ZTOkM7rO2LpMN63VrGsob2ReXYvBLFHrD8aTE9u9Dw
         puSyz0WgqzX8wTjEJRZ0nWf4gPdPivJRF+L45f/X5F0BOOU/2IfmFpIoAh5AYpCNpSxd
         ZPdS/qKQI7lmiK4Yxw1u+8j2IdLtC/EYlz/cHDO4uCHVkScCbPsQcLkaAND4P/nRJRjL
         nOGA==
X-Gm-Message-State: ACrzQf1Tqr8o8qJ9DB4Fe8Y8/tnnc5kzd/5XF6ZrMM66h6WY2lXgjMjX
        NE99Rcq9k7AgG+lIp1lNg3euug==
X-Google-Smtp-Source: AMsMyM7TbQ/E+ZeZ5oQBBxqIr8itrpHEL8mApGbB0maUJCo2oyUmFAOIHhyw+pcmNK06WwQGFr+9bw==
X-Received: by 2002:a2e:80d4:0:b0:26d:e557:a9ca with SMTP id r20-20020a2e80d4000000b0026de557a9camr858442ljg.311.1664816797323;
        Mon, 03 Oct 2022 10:06:37 -0700 (PDT)
Received: from fedora.. ([78.10.207.2])
        by smtp.gmail.com with ESMTPSA id z3-20020a056512370300b004a2386b8cebsm659145lfr.210.2022.10.03.10.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 10:06:36 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     mw@semihalf.com
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mig@semihalf.com, netdev@vger.kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, upstream@semihalf.com
Subject: Re: [PATCH v2] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Mon,  3 Oct 2022 19:06:13 +0200
Message-Id: <20221003170613.132548-1-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <CAPv3WKcW+O_CYd2vY2xhTKojVobo=Bm5tdFdJ8w33FHximPTcA@mail.gmail.com>
References: <CAPv3WKcW+O_CYd2vY2xhTKojVobo=Bm5tdFdJ8w33FHximPTcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/10/2022 10:23, Marcin Wojtas wrote:
>niedz., 2 paź 2022 o 10:00 Krzysztof Kozlowski
><krzysztof.kozlowski@linaro.org> napisał(a):
>>
>> On 01/10/2022 17:53, Michał Grzelak wrote:
>> > Hi Krzysztof,
>> >
>> > Thanks for your comments and time spent on reviewing my patch.
>> > All of those improvements will be included in next version.
>> > Also, I would like to know your opinion about one.
>> >
>> >>> +
>> >>> +  marvell,system-controller:
>> >>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> >>> +    description: a phandle to the system controller.
>> >>> +
>> >>> +patternProperties:
>> >>> +  '^eth[0-9a-f]*(@.*)?$':
>> >>
>> >> The name should be "(ethernet-)?port", unless anything depends on
>> >> particular naming?
>> >
>> > What do you think about pattern "^(ethernet-)?eth[0-9a-f]+(@.*)?$"?
>> > It resembles pattern found in net/ethernet-phy.yaml like
>> > properties:$nodename:pattern:"^ethernet-phy(@[a-f0-9]+)?$", while
>> > still passing `dt_binding_check' and `dtbs_check'. It should also
>> > comply with your comment.
>>
>> Node names like ethernet-eth do not make much sense because they contain
>> redundant ethernet or eth. AFAIK, all other bindings like that call
>> these ethernet-ports (or sometimes shorter - ports). Unless this device
>> is different than all others?
>>
>
>IMO "^(ethernet-)?port@[0-9]+$" for the subnodes' names could be fine
>(as long as we don't have to modify the existing .dtsi files) - there
>is no dependency in the driver code on that.

Indeed, driver's code isn't dependent; however, there is a dependency
on 'eth[0-2]' name in all relevant .dts and .dtsi files, e.g.:

https://github.com/torvalds/linux/blob/master/arch/arm/boot/dts/armada-375.dtsi#L190
https://github.com/torvalds/linux/blob/master/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi#L72

Ports under 'ethernet' node are named eth[0-2], thus those and all .dts files 
including the above would have to be modified to pass through `dtbs_check'.

Best regards,
Michał
