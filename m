Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0206151250F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiD0WKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiD0WKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:10:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD72F49C80;
        Wed, 27 Apr 2022 15:06:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id r9so2573283pjo.5;
        Wed, 27 Apr 2022 15:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qmucbmM52CaCl0fmfImEVzv8vNGc78ti//UJ2ph8lTQ=;
        b=MBKmEn+ifVmmQQN0jB6bPRJ9Uq+PIDqBvsMz20cj67GLM16JtWwrEIjXik2on8oBAB
         Ni6iGxFIVwVIi2yf0oBKVSkpqeAwF6ck7fUDd9Mex2owdpihiITEKRuUW+t/0pXezWcA
         UMHdkrMh405wU8GVC4Ha+5P13732bL/wyh+erNgrOvjAsNXL6sC/rCsjH7IDD4Ay4G7c
         qo3e14rz+aRBTcrw1mJ4Wvqvkon7iOxKoCDf/E1fSHWib1G7ZxZstYe8suK8NbTnnLlz
         6hTTthiVC12LIzK243k0G2zBbi0EUkQu7bju9BhAxrvtrbgzTHxmEqQ7ZsDSQelvCg+y
         0GXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qmucbmM52CaCl0fmfImEVzv8vNGc78ti//UJ2ph8lTQ=;
        b=BtJla3jjw2QZFmgcATdr+7IwUxaqeni9pNaGEfM7rcWGXxmuyV6jj8AVBPOQZuJTK7
         +wfz+pJps9lES6KJSCiQToYqaw8lHPkaZKyJgtuOIW/zgN/QL4QmOcWs92gYbFMMpJsX
         Bsk/CYB2KYaZp3ZqYGFtxom68IWBbgp49heSCuu8dZIdiDRm+dy24f9X2e//ttpOo/26
         AbIGdY56VeesFQyMdTYf4UxBXF60SfiO26GjdON+P/DhG3Yu5Nkm4Gnj+Jsb31ZNaJ+y
         b/D2NXBvqB3ok1vZpTiyekQvcHQ3G/A+9R7wBB5jfi//BlgfeBFuECbsw4KuqQFK5Gh5
         I7Iw==
X-Gm-Message-State: AOAM531X3YE+4Ytk8UsMTrsspVXIFAf5bIyVM28jyBH22WfNNPIjpHM8
        myio3F0Hm/EqRtWNabHq5Zk=
X-Google-Smtp-Source: ABdhPJzWXMNA1PfUcd/83ITryaBDRC/edPY0WxQbkMck4b4azmefFtjUEbNJs3Wo2J0ZQ7Xh/smv5A==
X-Received: by 2002:a17:90b:1a8a:b0:1d2:e93e:6604 with SMTP id ng10-20020a17090b1a8a00b001d2e93e6604mr46028945pjb.233.1651097214348;
        Wed, 27 Apr 2022 15:06:54 -0700 (PDT)
Received: from [10.69.68.169] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j64-20020a62c543000000b0050d260c0ea8sm16128026pfg.110.2022.04.27.15.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 15:06:53 -0700 (PDT)
Message-ID: <652a5d64-4f06-7ac8-a792-df0a4b43686f@gmail.com>
Date:   Wed, 27 Apr 2022 15:06:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 3/3] net: phy: micrel: add coma mode GPIO
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220427214406.1348872-1-michael@walle.cc>
 <20220427214406.1348872-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220427214406.1348872-4-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2022 2:44 PM, Michael Walle wrote:
> The LAN8814 has a coma mode pin which puts the PHY into isolate and
> power-dowm mode. Unfortunately, the mode cannot be disabled by a
> register. Usually, the input pin has a pull-up and connected to a GPIO
> which can then be used to disable the mode. Try to get the GPIO and
> deassert it.

Poor choice of word, how about deep sleep, dormant, super isolate?
-- 
Florian
