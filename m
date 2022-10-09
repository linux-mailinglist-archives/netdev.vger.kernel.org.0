Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1465F8BFC
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 17:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJIPWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 11:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiJIPWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 11:22:17 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CFC165B3
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 08:22:16 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id ay9so5374891qtb.0
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 08:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gi30W6qO/QQQISv8PyR3uP8MA6T/Qkq2eAnyNWkaPQo=;
        b=fsIhbyW+5LNxRUzfAm5uDLNs5RL1XrhuBUaER46mnIrpINGRiHQEtOrFksaO0mC+mr
         hdaW5Ixjo3ypZ6ITLqz5MMq9sfvMr0JsxnK8xmnyMqRcD6I+nwnJ90cj2o0nfIwGSOKv
         zJgXmu565F0ZkyD3iIoxRyy5mj4VEWfPy/eJShSnqQRX2izpOIHySyiOHeWWfoE4WmOK
         6V8X9pA7KmWzvugqfTbJPwE0sOnXhlJ7czlGNpu56/Xh6rL5RHIo/imZyqaLdagL2iRO
         cqOKLnO73l+FtSDG3uxXMWfBNHpOFSFQpOt3jMuVXFlBdhgcO5dPiEWZb3yyJJhPCdUi
         lJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gi30W6qO/QQQISv8PyR3uP8MA6T/Qkq2eAnyNWkaPQo=;
        b=bsjVk1jedQw6nOp4lUlwfFPR1OTa6fx27+sgRJ/hMPG+Dx8FrwbEZkL3dQwoQt/QJw
         X93DBt73dLot7g55qTEf6zLw/XkF4rv+iJp/Ay4OPcpN6N+uhzmUNJt2NwpltKp5t6Vd
         BPlX4A55mfe8/ah5aluVaSAVq259jqOkoIqpkhs3CXv6y8JzHO6HSTy8BtDMK1Q7xh04
         3nHxiTY4lCqZWvdalRDWUv1GEPtLIkrut89kQN2GZGaVEJm8Q1fr96a4vTSqROLLZBgZ
         +o2Y2JuB9Jv6z/XtSj9KUO7+LslNpyHq3aSalNmHcr0FqLavLJIvfMRELYXhqw71F3ly
         1LGg==
X-Gm-Message-State: ACrzQf1ZOgAuft0lLp+KeImIdEdKQqxW+fbHd4ebUUSfVTS5wGqrl/cD
        ddf5iHQsZrI39u2UlDa49KZQzA==
X-Google-Smtp-Source: AMsMyM77qc2qXgZ3zI7eVyqJTBsbEuOolRRKQMmDBZCGvXmo38imssALA4dp/8f9g+G6wgTdYPaxaA==
X-Received: by 2002:ac8:7e82:0:b0:35b:b24e:2159 with SMTP id w2-20020ac87e82000000b0035bb24e2159mr11961830qtj.623.1665328935853;
        Sun, 09 Oct 2022 08:22:15 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id y11-20020ac8128b000000b0039a275607c3sm536833qti.55.2022.10.09.08.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 08:22:15 -0700 (PDT)
Message-ID: <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
Date:   Sun, 9 Oct 2022 17:20:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221008225628.pslsnwilrpvg3xdf@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2022 00:56, Vladimir Oltean wrote:
>>  
>> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
>> +M:	Jerry Ray <jerry.ray@microchip.com>
>> +M:	UNGLinuxDriver@microchip.com
>> +L:	netdev@vger.kernel.org
>> +S:	Maintained
>> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
>> +F:	drivers/net/dsa/lan9303*
>> +
> 
> Separate patch please? Changes to the MAINTAINERS file get applied to
> the "net" tree.

This will also go via net tree, so there is no real need to split it.

Best regards,
Krzysztof

