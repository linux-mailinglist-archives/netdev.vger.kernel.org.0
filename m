Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B686D7C99
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbjDEMaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEMaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:30:24 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A571BE9;
        Wed,  5 Apr 2023 05:30:23 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id cr18so30969373qtb.0;
        Wed, 05 Apr 2023 05:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680697822; x=1683289822;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3+2VGm8z/Tpa/KlruzK7easb5RdQQJ0e4dPOmz+MI9A=;
        b=HNLeRFaFdyCpoL4pVKJlJ+XTD47YzLkenQdxXKF0hRvkIX46JNGH6YU/SWOh28LFRz
         wFbWwBwH5k8lvVpPTM66lgX2jXxbff1q00KtUv5biTTme2BYoq8200ak2qfJo0ChFBOY
         KZKl1Q8BB5PhNJHlH0+OAtn6AJSJSZ5alWM2dpCrK71r6aMujObAbizJQDV7X9rFR//q
         tph3oz1U118uxSE9liBM0+XQ27puGgiss/+OF8TqReP0V4iUMqHxn4j5xwD4EoIyktcY
         +52YHa8Q2iFfFmSK3dOOhiQioJpOZqf1QbcvUwNaigHVk6obKlYMOw29Nm34b6rZz8w9
         Izuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680697822; x=1683289822;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+2VGm8z/Tpa/KlruzK7easb5RdQQJ0e4dPOmz+MI9A=;
        b=TMKxUEI0Na+vSKqebB1XjbrYjG0rOufVwjFM6EqGgAOWwQZ1ZsJPcP7GL7YfhZ+Xit
         owjrMq8hxQ1JyynRMvyw5iE0A2r77o3Eo94lcCUX2BmoSe7iXl9Btim1P/1pdczKHmh3
         QVsHFmwlt8tleIQHnhtADfj/iAXC2fGeixda/NNIsDmtGTnf3hvJAxokuB5D29oavAmu
         R50Go755POkUZLiunPi8pdiyg4DJr2ZeWIMTfVZAMppVPZqYSC0uIgv1eO2bC3SUUIPQ
         EAwmGUMG75M4QFpde5KtV4QLNK06IlK65UUicvDpEK/FhbPMEa3B3FrU3emCun94S2A/
         jEUA==
X-Gm-Message-State: AAQBX9cUEvh+cOnvA035gB7NuwQrMQhkjChBfMT/nJ994v00OfCWhTKb
        yBKd8tqZ2bye0Y0icA0lT10=
X-Google-Smtp-Source: AKy350Zx7ogA2k+0sBwF00+tuvY2a1KEmuYa0/5tnBRZwqmQICQP+dr5mL0bSDxULDykiw5oB6B4BQ==
X-Received: by 2002:ac8:5a4e:0:b0:3d9:b59f:1ba9 with SMTP id o14-20020ac85a4e000000b003d9b59f1ba9mr4605799qta.12.1680697822394;
        Wed, 05 Apr 2023 05:30:22 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c195-20020ae9edcc000000b007484d284cdasm4424593qkg.93.2023.04.05.05.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:30:15 -0700 (PDT)
Message-ID: <956792db-c6a4-f16f-e7e4-b9d08c12f986@gmail.com>
Date:   Wed, 5 Apr 2023 05:30:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 05/12] net: phy: add phy_id_broken support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Marco Felsch <m.felsch@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-5-7e5329f08002@pengutronix.de>
 <6461467c-8f9d-41b6-b060-08190126e81f@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <6461467c-8f9d-41b6-b060-08190126e81f@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/5/2023 5:27 AM, Andrew Lunn wrote:
> On Wed, Apr 05, 2023 at 11:26:56AM +0200, Marco Felsch wrote:
>> Some phy's don't report the correct phy-id, e.g. the TJA1102 dual-port
>> report 0 for the 2nd port. To fix this a driver needs to supply the
>> phyid instead and tell the phy framework to not try to readout the
>> phyid. The latter case is done via the new 'phy_id_broken' flag which
>> tells the phy framework to skip phyid readout for the corresponding phy.
> 
> In general, we try to avoid work around for broken hardware in the
> core. Please try to solve this within nxp-tja11xx.c.

Agreed, and one way to solve working around broken PHY identification 
registers is to provide them through the compatible string via 
"ethernet-phyAAAA.BBBB". This forces the PHY library not to read from 
those registers yet instantiate the PHY device and force it to bind to a 
certain phy_driver.
-- 
Florian
