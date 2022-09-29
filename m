Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4079A5EF144
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiI2JGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiI2JGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:06:08 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC10413FB51
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:06:06 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id t4so497206wmj.5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=1fO0qaHDUPQyzt9G+/Ln/q6kw6Dd3DKO8rTIIZflHhA=;
        b=QBFe2GCeBZv701W+gMbxFdjMN2F12yDMtEH2KGGN9Ng6XdWKC4vHdGWWGrigP5OWpa
         8Vjmq06IQIs5CkS7jcDrRBrr4jqHoSvWWCDz/XSMSNbF15zm3g5G/8l/8+9oolPrFNff
         G5CKi6/QI9yin/8I4DjkANCrf2DYZnBonGo+kjzRvZUG+dMIws1en84U94JqBRmSuLgU
         t5pNavhhcO50AL2BT6uZBYJge59m7mNA8HIjF6e1WqbM2g2Bh/ZZYlSLSrz8EohIOCJ/
         ctSP+UM0GOw+oEIMlJdx39U0HZnRcSYeM+bIXpSRY6dzca70ys9HMBdTPe9W9Rn7i7XX
         DdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=1fO0qaHDUPQyzt9G+/Ln/q6kw6Dd3DKO8rTIIZflHhA=;
        b=O8pKHAFtNSqH1CvYHDO8iktnzMOSdLpySw9hN8Z8ET/RKuWkd6I+esY41WtTjC+OvO
         SEPIhJ3z4XK4jJThLt/6+T4zgNnK1NAVyQ2HZcmMK14FLvkKcivS0Tuubgynw7T7Hr41
         kNMCurrTfNmZhJv+d/bngHwRuSF9V+nyWx3bFmQRN1I+EH+px2qiGjgyKLTqGEMplYfI
         tfYLeeA8lE6DvrhTkrfc0tEaaF1UtJpC2DFhjNMH2cOJLSm25pUYuZjlL53SwgMFzZ+G
         UpGygh79kqJFsh7XxCQOO98FJX92PggVvzyTeaeIhx4GqQZxE/tS+OYVciX+6INxBKkT
         yPlg==
X-Gm-Message-State: ACrzQf1xKazTzItABkCRtYEU66Z/ozNcMgxYC1b61NvzE1mdm6AnWawX
        QjfPzPuz89C5mpmvuPb3k3C1Eg==
X-Google-Smtp-Source: AMsMyM4d7MiDsUle8S4bqCwB6dPDrv+b9MfgJyVBPBoVphmDcqPr+wUq59s4mO3WvRYzghIyCsApow==
X-Received: by 2002:a05:600c:3d86:b0:3b4:b65f:a393 with SMTP id bi6-20020a05600c3d8600b003b4b65fa393mr1520883wmb.0.1664442365336;
        Thu, 29 Sep 2022 02:06:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:c9dd:4896:ac7a:b9e1? ([2a01:e0a:b41:c160:c9dd:4896:ac7a:b9e1])
        by smtp.gmail.com with ESMTPSA id u7-20020adfdd47000000b00228655a5c8fsm6383149wrm.28.2022.09.29.02.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 02:06:04 -0700 (PDT)
Message-ID: <45f51dee-6359-6539-feec-1525209f3f3e@6wind.com>
Date:   Thu, 29 Sep 2022 11:06:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 4/6] netlink: add a proto specification for FOU
Content-Language: en-US
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        gnault@redhat.com
References: <20220929011122.1139374-1-kuba@kernel.org>
 <20220929011122.1139374-5-kuba@kernel.org>
 <6c64b772-7b2b-77f8-4523-4408e0b3bf8a@6wind.com>
Organization: 6WIND
In-Reply-To: <6c64b772-7b2b-77f8-4523-4408e0b3bf8a@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 29/09/2022 à 11:02, Nicolas Dichtel a écrit :
> 
> Le 29/09/2022 à 03:11, Jakub Kicinski a écrit :
>> FOU has a reasonably modern Genetlink family. Add a spec.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>>  Documentation/netlink/specs/fou.yaml | 128 +++++++++++++++++++++++++++
>>  1 file changed, 128 insertions(+)
>>  create mode 100644 Documentation/netlink/specs/fou.yaml
>>
>> diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
>> new file mode 100644
>> index 000000000000..266c386eedf3
>> --- /dev/null
>> +++ b/Documentation/netlink/specs/fou.yaml
>> @@ -0,0 +1,128 @@
>> +name: fou
>> +
>> +protocol: genetlink-legacy
>> +
>> +doc: |
>> +  Foo-over-UDP.
>> +
>> +c-family-name: fou-genl-name
>> +c-version-name: fou-genl-version
>> +max-by-define: true
>> +kernel-policy: global
>> +
>> +definitions:
>> +  -
>> +    type: enum
>> +    name: encap_type
>> +    name-prefix: fou-encap-
>> +    enum-name:
>> +    entries: [ unspec, direct, gue ]
>> +
>> +attribute-sets:
>> +  -
>> +    name: fou
>> +    name-prefix: fou-attr-
>> +    attributes:
>> +      -
>> +        name: unspec
>> +        type: unused
> The first attribute should always be unspec/unused. Maybe it could be
> automatically generated?
I read the doc after the code :)
