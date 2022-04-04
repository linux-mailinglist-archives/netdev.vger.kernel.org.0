Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9594F1658
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358389AbiDDNrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358276AbiDDNrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:47:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A871F3E5CA
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 06:45:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u9so6032273edd.11
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ag4NtuXcd337V7EAqGGmB9o5JEXFbkeH+3FIqIGxGO0=;
        b=F0mJ7WcX4xs/jOWKodEod/6QWP7Ws2vdXT+KJwA3bipp69Y294eucyZJIPupeUKJ8N
         6Aq2+S80bx6u/ZqROwVieqoEL5yAoKEH0GMrrOc4VbJ9BcKW8Jlm02idcWjg1ImRzOjO
         bu38z/dqyZkTVu0lEJFBfXU6zPJWisFE+Rj1f4OhydFYaC40Ih+a1Q9WitQg/0+CTKmk
         Z2zFcgSVry7N1yP7lLhh0JOUzlHQkLPivo6PVGj2GbDIV88pXNWs4sa8Yq54kyIHdF3G
         mVquOW9lHC2ZyikW2VMY0M8K7F7859m/dHqLXvahTivFjkmaMXM3nusALXtOVmLfj7Ln
         k5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ag4NtuXcd337V7EAqGGmB9o5JEXFbkeH+3FIqIGxGO0=;
        b=cPGASSF9qY+8UWwkVzHznmmCQ8hlWmSZq1SV71TWUe5iPAFz8vRwQ8759K1x7T6qM/
         nygv+R7zxfGpItAsoDUQU4SaN9iTlKLqFbEMzpdp3rmSbkZHm4qGvqftNRtMmvphY/Km
         XOJ+O1MlNGh6Pf+HkV8B6Wx+g/vHEfOrea5FotQq01Ij0jXlQCXNG50OE8aJpMKa3PRk
         Wb2aPSrDJQUxbUgU202Qi+vJbrDvvr3Ev3zH0/rNMMSNSNnISQfsnS2ObHcdO+ZKfMjO
         UrEV9qFtZ3CDBzOqrGHcsMSqxi4Fzl7Z8hTZgw3f49xUfQvGYJ/HzT/Rqbu7Eser7ELw
         Foag==
X-Gm-Message-State: AOAM530ZkdPzFMPV0EzlRcqNZoPuLbysg01//+LLMjZxLPTiQgjTNwpa
        64D9P1a+00/k8V63+t2IQQLJYD44MzKqfxhM
X-Google-Smtp-Source: ABdhPJwys+HV9TUCHNVVEmCAx3DDsJ2cNjVstxGVCnIgM8Bc/ms4M+z4PvyJ39/sEk8Lu/e3YL4/Mg==
X-Received: by 2002:a05:6402:5201:b0:419:4c82:8f11 with SMTP id s1-20020a056402520100b004194c828f11mr77514edd.133.1649079905006;
        Mon, 04 Apr 2022 06:45:05 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id hs12-20020a1709073e8c00b006dfdfdac005sm4409273ejc.174.2022.04.04.06.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 06:45:04 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     netdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 0/2] MAINTAINERS/dt-bindings: changes to my emails
Date:   Mon,  4 Apr 2022 15:45:02 +0200
Message-Id: <164907989905.809631.16161802401962719876.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330074016.12896-1-krzysztof.kozlowski@linaro.org>
References: <20220330074016.12896-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 09:40:14 +0200, Krzysztof Kozlowski wrote:
> From: Krzysztof Kozlowski <krzk@kernel.org>
> 
> Hi,
> 
> I can take both patches via my Samsung SoC tree, if that's ok.
> 
> Best regards,
> Krzysztof
> 
> [...]

Applied, thanks!

[1/2] dt-bindings: update Krzysztof Kozlowski's email
      commit: 8a1e6bb3f78f06432e095758476358d8cb63c03d
[2/2] MAINTAINERS: update Krzysztof Kozlowski's email to Linaro
      commit: 1a9f338f9cf96f8338d5592dee5fce222929e4f7

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
