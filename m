Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1785C5BC078
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIRW6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIRW6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 18:58:40 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C915803;
        Sun, 18 Sep 2022 15:58:38 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id j8so9808018qvt.13;
        Sun, 18 Sep 2022 15:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=On0Twl+qLgtTGT6nhxqRrmN4VvYYyU8Ly4GQsMMss6I=;
        b=kPikrSYkj1RNsg8hKY8N3naAv9roDzMTfSx4uwuV/aNHkhwDWKdq8pt8GSKvpGV5TD
         RmxuFZEifY3UZ70vKAb0vDUqKPkPAhfckWuqb3vDSZCzgkDX0Se7fPSmZpnpmyIRrNea
         2sMwoVYyDdSLo7hOnHODmzoYjZ065MM0DY9V1gPa5evLlvIAKTjdiiC8EYlRSl8+rYah
         wb3Sb91x5xD6QCQKEpNBOFjvDsFaHKqyFnbroBsdJtMhM8oecPrrarCEvL0UokuldpEe
         7VoCkGb53x2ajEXlZ7V9a9/thIUP/Uu16pU5n1jUZdeayUbvG5yAqh08kIR1o4v1TjIk
         XEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=On0Twl+qLgtTGT6nhxqRrmN4VvYYyU8Ly4GQsMMss6I=;
        b=RQM8vAB8Ag4/jDJEInivVXkYcjdvgo0GDYRTFrhYq2v6+2W6Ubyq3Y2w3Y/mcFRQEW
         0g8KJN+q8o7y32LuGkqAPOF8A3UskqsGCZ85KmxXXS2/ojt2Nkr4VvPlWDSzkFDiFcST
         eU8AHImHBUfmQ35GzPJnjuSor9thOZDAptThBWmvfhGf3F+FCb8QZt8RMk9abmthknCJ
         tmpcDm3lSMoehiFrb8cZtfAGbnYO2QhxH6Fz53eE/5tf/tG1USrlN6/zqpk1A36S3nCZ
         viHg/NYsGMEWerAlvl23DsNtpuBlxP5MCeDd27oVEGK7GTxBBvBcrkBDoZvy6mOA+/qH
         MqmA==
X-Gm-Message-State: ACrzQf3iUs9fcZLKTwPiEftQVktncK32AjFshk/ELyv5rg3q1Z4zeJ85
        IhcR6aw7M/0smcFN4M2rHX0=
X-Google-Smtp-Source: AMsMyM66N7Uen+weo9M5AojoDwLzCF0jF4tTnxx5FU7wEoNFjn9VXiEAVBxrLlfLHqesSJKuY9l2Sg==
X-Received: by 2002:ad4:596b:0:b0:4ad:2fad:fe1e with SMTP id eq11-20020ad4596b000000b004ad2fadfe1emr5114123qvb.1.1663541917251;
        Sun, 18 Sep 2022 15:58:37 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bn32-20020a05620a2ae000b006b615cd8c13sm11365092qkb.106.2022.09.18.15.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 15:58:36 -0700 (PDT)
Message-ID: <b66fff15-3521-f889-d9bf-70f1cf689cdc@gmail.com>
Date:   Sun, 18 Sep 2022 15:58:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Move MT7530 phy muxing from DSA to PHY driver
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thibaut <hacks@slashdirt.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
References: <0e3ca573-2190-57b0-0e98-7f5b890d328e@arinc9.com>
 <YyKQKRIYDIVeczl1@lunn.ch> <dad09430-4f33-7f1d-76c7-4dbd0710e950@arinc9.com>
 <YyXiswbZfDh8aZHN@lunn.ch> <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
Content-Language: en-US
In-Reply-To: <4a291389-105a-6288-1347-4f02171b0dd0@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2022 4:28 AM, Arınç ÜNAL wrote:
> On 17.09.2022 18:07, Andrew Lunn wrote:
>>>> Where in the address range is the mux register? Officially, PHY
>>>> drivers only have access to PHY registers, via MDIO. If the mux
>>>> register is in the switch address space, it would be better if the
>>>> switch did the mux configuration. An alternative might be to represent
>>>> the mux in DT somewhere, and have a mux driver.
>>>
>>> I don't know this part very well but it's in the register for hw trap
>>> modification which, I think, is in the switch address space.
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c?id=1f9a6abecf538cc73635f6082677a2f4dc9c89a4#n941
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.h?id=1f9a6abecf538cc73635f6082677a2f4dc9c89a4#n500
>>>
>>> Like you said, I don't think we can move away from the DSA driver, 
>>> and would
>>> rather keep the driver do the mux configuration.
>>>
>>> We could change the check for phy muxing to define the phy muxing 
>>> bindings
>>> in the DSA node instead. If I understand correctly, the mdio address for
>>> PHYs is fake, it's for the sole purpose of making the driver check if
>>> there's request for phy muxing and which phy to mux. I'm saying this 
>>> because
>>> the MT7530 switch works fine at address 0 while also using phy0 as a 
>>> slave
>>> interface.
>>>
>>> A property could be introduced on the DSA node for the MT7530 DSA 
>>> driver:
>>>
>>>      mdio {
>>>          #address-cells = <1>;
>>>          #size-cells = <0>;
>>>
>>>          switch@0 {
>>>              compatible = "mediatek,mt7530";
>>>              reg = <0>;
>>>
>>>              reset-gpios = <&pio 33 0>;
>>>
>>>              core-supply = <&mt6323_vpa_reg>;
>>>              io-supply = <&mt6323_vemc3v3_reg>;
>>>
>>>              mt7530,mux-phy = <&sw0_p0>;
>>>
>>>              ethernet-ports {
>>>                  #address-cells = <1>;
>>>                  #size-cells = <0>;
>>>
>>>                  sw0_p0: port@0 {
>>>                      reg = <0>;
>>>                  };
>>>              };
>>>          };
>>>      };
>>>
>>> This would also allow using the phy muxing feature with any ethernet 
>>> mac.
>>> Currently, phy muxing check wants the ethernet mac to be gmac1 of a 
>>> MediaTek
>>> SoC. However, on a standalone MT7530, the switch can be wired to any 
>>> SoC's
>>> ethernet mac.
>>>
>>> For the port which is set for PHY muxing, do not bring it as a slave
>>> interface, just do the phy muxing operation.
>>>
>>> Do not fail because there's no CPU port (ethernet property) defined when
>>> there's only one port defined and it's set for PHY muxing.
>>>
>>> I don't know if the ethernet mac needs phy-handle defined in this case.
>>
>>  From mediatek,mt7530.yaml:
>>
>>    Port 5 modes/configurations:
>>    1. Port 5 is disabled and isolated: An external phy can interface 
>> to the 2nd
>>       GMAC of the SOC.
>>       In the case of a build-in MT7530 switch, port 5 shares the RGMII 
>> bus with 2nd
>>       GMAC and an optional external phy. Mind the GPIO/pinctl settings 
>> of the SOC!
>>    2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd 
>> GMAC.
>>       It is a simple MAC to PHY interface, port 5 needs to be setup 
>> for xMII mode
>>       and RGMII delay.
>>    3. Port 5 is muxed to GMAC5 and can interface to an external phy.
>>       Port 5 becomes an extra switch port.
>>       Only works on platform where external phy TX<->RX lines are 
>> swapped.
>>       Like in the Ubiquiti ER-X-SFP.
>>    4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd 
>> CPU port.
>>       Currently a 2nd CPU port is not supported by DSA code.
>>
>> So this mux has a scope bigger than the switch, it also affects one of
>> the SoCs MACs.
>>
>> The phy-handle should have all the information you need, but it is
>> scattered over multiple locations. It could be in switch port 5, or it
>> could be in the SoC GMAC node.
>>
>> Although the mux is in the switches address range, could you have a
>> tiny driver using that address range. Have this tiny driver export a
>> function to set the mux. Both the GMAC and the DSA driver make use of
>> the function, which should be enough to force the tiny driver to load
>> first. The GMAC and the DSA driver can then look at there phy-handle,
>> and determine how the mux should be set. The GMAC should probably do
>> that before register_netdev. The DSA driver before it registers the
>> switch with the DSA core.
>>
>> Does that solve all your ordering issues?
> 
> I believe it does.
> 
>>
>> By using the phy-handle, you don't need any additional properties, so
>> backwards compatibility should not be a problem. You can change driver
>> code as much as you want, but ABI like DT is fixed.
> 
> Understood, thanks Andrew!

Yes this seems like a reasonably good idea, I would be a bit concerned 
about possibly running into issues with fw_devlink=on and whichever 
driver is managing the PHY device not being an actual PHY device driver 
provider and thus preventing the PHY device consumers from probing. This 
is not necessarily an issue right now though because 'phy-handle' is not 
(yet again) part of of_supplier_bindings.

Maybe what you can do is just describe that mux register space using a 
dedicated DT node, and use a syscon phandle for both the switch and/or 
the MAC and have them use an exported symbol routine that is responsible 
for configuring the mux in an atomic and consistent way.
-- 
Florian

