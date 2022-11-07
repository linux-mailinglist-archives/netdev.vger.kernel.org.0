Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D00361FDC2
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiKGSkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiKGSkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:40:19 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9026520198;
        Mon,  7 Nov 2022 10:40:18 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id s20so7721932qkg.5;
        Mon, 07 Nov 2022 10:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSEQrw4mhcPxa7ZRyjeV+zh0S8mxURHBDWDQBmjbbK4=;
        b=AqlOOA0Fl2iAW3i+Stm7LaJg3ozlLIaZ+P1yzZWfO4Hn1nu6xfAkrCGNefOTQ706zR
         XdCpHIWj5ESNONNNF+5Y42r6ctTYUxr3jrId+h64hw4FYno2/yEFSQDro8fr5LpVSOZP
         2qCHD0RQtjRRczreB10WroM3RmZC5yIY0SqhFjacrNc3/ynZZ/uAbrwPW82w3ak9nCfd
         SAJKEiIqiyUipPKqRI+a91xXDx3cWIiCng8Vy5ZnYMG5GT/nQapaZaKA3/qGQC1p+RPd
         QDzKIx0dvU/u58fxUguv8B1wv5xyIoZtk68u0F6+HA/19sMi0ZNVOGnTxAhXnuLplnum
         qM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oSEQrw4mhcPxa7ZRyjeV+zh0S8mxURHBDWDQBmjbbK4=;
        b=xRu43Y9LH0+WNQ/TG1eG9ixtScwW9NrVm9JZQ2ngwxDFa5+Mg2aqhA/z7IdLrgQdEt
         isdgAWVDIhiAJ+ef+B9ravgVQ22lZ5PWrpo8BwVl1wK1FzJg8c2gD/bhdW/bcbOld4It
         Xqvz+A0TVD1UXTXtyUqmnt1yB6/LVLZHx0UGeeOzy6UvTWYoi9JcKTDp79E7kBg+sIGp
         x/U27AUgTKHm/4aiajQOOag46jvpzJ1YT93zhPiQiRsWijglPjlwwmF9wZpzK5k4xNH/
         9jHdX0vu0ynI9yW9f9WTdvz30aiwFgmqnUznFlfj5ZVNtDXnw14sPHCyjreZO1ViXsR2
         GeNg==
X-Gm-Message-State: ACrzQf3mdjmiQ8WSRmy5OpRueAtgWR8Swkvf0/uHPeIJysYKmpPH75NA
        ZflgJVbHY34P1KnqBnBMKr8=
X-Google-Smtp-Source: AMsMyM7y2ySxIqnP3Q7GjsbWSKl/8WqMGzRHoBQJ0/3bAJawFA7WegxPK3tZmYwDbwfFwIodoXImeA==
X-Received: by 2002:a05:620a:29c7:b0:6fa:aba4:f853 with SMTP id s7-20020a05620a29c700b006faaba4f853mr8971241qkp.208.1667846417660;
        Mon, 07 Nov 2022 10:40:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c22-20020ac87d96000000b003a5416da03csm6592007qtd.96.2022.11.07.10.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 10:40:17 -0800 (PST)
Message-ID: <02d0cc2d-26b4-e655-c2b9-9514a29074f5@gmail.com>
Date:   Mon, 7 Nov 2022 10:40:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org\"" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107112736.mbdfflh6z37sijwg@skbuf>
 <20221107084535.61317862@kernel.org> <20221107172846.y5nmi3plzd4wemmv@skbuf>
 <20221107102440.1aecdbdb@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221107102440.1aecdbdb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/22 10:24, Jakub Kicinski wrote:

[snip]

> Yeah, it's a balancing act. Please explore the metadata option, I think
> most people jump to the skb extension because they don't know about
> metadata. If you still want skb extension after, I'll look away.

It seems to me like we are trying too hard to have a generic out of band 
solution to provide tagger information coming from a DMA descriptor as 
opposed to just introducing a DSA tagger variant specific to the format 
being used and specific to the switch + integrated MAC. Something like 
DSA_TAG_IPQDMA or whatever the name chosen would be, may be fine.

The only value I see at this point in just in telling me that the tagger 
format is coming from a DMA descriptor, but other than that, it is just 
a middle layer that requires marshalling of data on both sides, so sure 
the idea behind DSA was to be able to mix and match any Ethernet MAC 
with any discrete switch, but integrating both into the same ASIC does 
nullify the design goal.
-- 
Florian

