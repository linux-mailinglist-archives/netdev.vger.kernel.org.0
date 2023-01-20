Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C372675C53
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjATR6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjATR6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:58:36 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4BC8C932;
        Fri, 20 Jan 2023 09:58:09 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x4so4565440pfj.1;
        Fri, 20 Jan 2023 09:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cx84QmywTvFoBakCztnkOurn2Q9lhNaHfIWPrd7Q84U=;
        b=DskurABhQLJuIsPo613aAntE6w4RfZEmj4v2B0zetdkQEUfNmAP4U9r1PN7AusGb9G
         c6WjTk5VqsK5hcQXUVByj/rSQhtDXX8+dzqxmTPWhCTnTxpTbcC7rUIFiKhWawqOvtq/
         l0wTbUc1NgCZstw8nz1YvIt5mNjOhlqK0cy6GUNaoekcmWNZ9QvyzarHE94RLpdQJ/1U
         FpzHzuzPurr84svjGZxSEpUqwwrLKSHnnxeoBhTQEgirttQKfHOF+BjOGVW83WbRZF7n
         RadtgtI+BXtfKRtriT166WVIOv17T5meCfScvx+LcQKOeTqyORT7OQncoEDmbWVfmvfk
         ufzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cx84QmywTvFoBakCztnkOurn2Q9lhNaHfIWPrd7Q84U=;
        b=oYw9IUEfWtpPpi5onWf6eBReLFQP7dqOrNvvIC31Bsu6Xyh8nU2AqxvZ6zU/dUd3IW
         wxaUfDZghWsLUL6Vao7v1oWUwVeTgALgoNcFeOK/85DFUMKqw9B2xOsAPvusU6bgQ+C+
         XymaWYEvElMCjM+l8xpyVEif6mM0nJr3RJGU8qeuxVA6hWygZceShXTtqFGKNu8vE7tr
         l4niVF3gUPz8Nb6ZwBGOzP5sEu3c4VkML0jkJ/Z2r7YZnlp97Zpv2PAr4b7wPTPzs0HL
         mGcNrDhYMfanLQURv5/LHYypEG4Gr48uivFAOpfvAO3d+mSddmvAbLQ5gt9rPnj9DfOv
         IrDQ==
X-Gm-Message-State: AFqh2koNlYi2By7buKD6MzDK/iXX6dQQMutUy/MXG2RikpkU3VaZEDOG
        cuf8775e3jmrCLcy6sjowUM=
X-Google-Smtp-Source: AMrXdXuNCFeAx/JDqDGATqUS4LoHQSEsTB/HVSUwk9iEp7PfUVH49hkjaXEgNYJj8SORa5YfjMebvw==
X-Received: by 2002:a62:5287:0:b0:58b:453e:77e0 with SMTP id g129-20020a625287000000b0058b453e77e0mr14575557pfb.20.1674237488327;
        Fri, 20 Jan 2023 09:58:08 -0800 (PST)
Received: from [10.14.5.12] ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id z37-20020a056a001da500b0058e1a104ca9sm1368853pfw.107.2023.01.20.09.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 09:58:07 -0800 (PST)
Message-ID: <c45aa954-0931-1829-459f-8771faf05173@gmail.com>
Date:   Fri, 20 Jan 2023 09:58:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v1 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
 <20230119131821.3832456-3-o.rempel@pengutronix.de>
 <6a02c93f-e854-bb8e-2172-2c2537f9d800@gmail.com>
 <20230120055514.GI6162@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230120055514.GI6162@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2023 9:55 PM, Oleksij Rempel wrote:
> On Thu, Jan 19, 2023 at 11:25:42AM -0800, Florian Fainelli wrote:
>> On 1/19/23 05:18, Oleksij Rempel wrote:
>>> KSZ9477 variants of PHYs are not completely compatible with generic
>>> phy_ethtool_get/set_eee() handlers. For example MDIO_PCS_EEE_ABLE acts
>>> like a mirror of MDIO_AN_EEE_ADV register. If MDIO_AN_EEE_ADV set to 0,
>>> MDIO_PCS_EEE_ABLE will be 0 too. It means, if we do
>>> "ethtool --set-eee lan2 eee off", we won't be able to enable it again.
>>>
>>> With this patch, instead of reading MDIO_PCS_EEE_ABLE register, the
>>> driver will provide proper abilities.
>>
>> We have hooks in place already for PHY drivers with the form of the read_mmd
>> and write_mmd callbacks, did this somehow not work for you?
>>
>> Below is an example:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb
>>
>> (here the register location is non-standard but the bit definitions within
>> that register are following the standard).
> 
> It will work for this PHY, but not allow to complete support for AR8035.
> AR8035 provides support for "SmartEEE" where  tx_lpi_enabled and
> tx_lpi_timer are optionally handled by the PHY, not by MAC.

Not sure I understand your reply here, this would appear to be a 
limitation that exists regardless of the current API defined, does that 
mean that you can make use of the phy_driver::{read,write}_mmd function 
calls and you will make a v2 that uses them, or something else entirely?
-- 
Florian
