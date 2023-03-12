Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCF66B6841
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 17:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCLQ1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCLQ1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 12:27:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1FF2716
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 09:27:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y4so10083504edo.2
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 09:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678638434;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5FIbyw7Lq952OtVv5bqjHlLASt7e6oZgy6qhaanaKuo=;
        b=i6kMQk1WCB6VZ0H1cGfIz3DtN/NRSIenIMASs+5Z5pgNSzAXtztQ9WrfwI4rXNHGp2
         mZDGU42GlWjzNLJgmgV8VEHHVIogpOZ8OTWjMCx+lN3kqzjr8DhK8DuNKUg8Oszmx0Qq
         DmvnquXqo+NvvXoSOQ7F8OFPAvvFOIDMzgUcw0ym2EMRmtDxx7iYM5r1EasHzSWoBpMJ
         76/RD+fV9qPGavMyzjCwI2xKaLlW+15Gwbsan5p0BuR86CVz/Ob4XYzmz/qcNmTAg8H6
         GPsUk3B/MUjzcAzGVJJQRpl0DWTTr0iLHSxYcJI1VoMbuBjrDCyF+wFftnHN1otcjtrj
         aA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678638434;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5FIbyw7Lq952OtVv5bqjHlLASt7e6oZgy6qhaanaKuo=;
        b=5ezMC4lxNqckDNVnyPDtpXR0D7MfrV+3z/QgOK6UDnQCzc/0QfTw1X7lqiF2xXV1r4
         ULnH0aL0Ttnu/rhOXPROSkGQ3Bfd4RSkVcwEhXLz8gD7HDFeSrQRUJAdvyX0wC0LA6/E
         PH5NuPnckiJMCjijFC406nCuLD/lGQdvbXrsvp2jGmPC1KJHafpsB2RQuHQ33cHQHRdx
         w2T+Y/5Mf1HvOKdr9qgdLxhyWfGJfEah9R7v6kjXTffagznE2R6E2uo/wtyDhDDiOCss
         OAwadZiqJtQVazZ0rfeurrddairkagnpbnnW7QXM8ujoqaB4uv6Jv/bAUC1oe4DCvcNy
         OFTg==
X-Gm-Message-State: AO0yUKUAb8YepT594NX+OIifgKnuaNIQExD8bW5hmKCCOEWlhoKCVsjG
        8FtQoMEwC/dyI0YE3BeoY+4Wyg==
X-Google-Smtp-Source: AK7set9vIzpPBM1LnWSCWT1qTTPdlPM72u/LqmANIAapUJVSLlKL9o5fPHi6BPNOvrew3btHQu5JhQ==
X-Received: by 2002:a17:906:1b19:b0:90d:5f56:b109 with SMTP id o25-20020a1709061b1900b0090d5f56b109mr8038034ejg.2.1678638433747;
        Sun, 12 Mar 2023 09:27:13 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:d9f6:3e61:beeb:295a? ([2a02:810d:15c0:828:d9f6:3e61:beeb:295a])
        by smtp.gmail.com with ESMTPSA id z13-20020a170906668d00b008b30e2a450csm2417428ejo.144.2023.03.12.09.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 09:27:13 -0700 (PDT)
Message-ID: <b32f506e-ac08-b883-747f-1f9bca27ab6f@linaro.org>
Date:   Sun, 12 Mar 2023 17:27:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] dt-bindings: net: realtek-bluetooth: Fix double RTL8723CS
 in desc
Content-Language: en-US
To:     Diederik de Haas <didi.debian@cknow.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20230312155435.12334-1-didi.debian@cknow.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230312155435.12334-1-didi.debian@cknow.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2023 16:54, Diederik de Haas wrote:
> The description says 'RTL8723CS/RTL8723CS/...' whereas the title and
> other places reference 'RTL8723BS/RTL8723CS/...'.
> 
> Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

