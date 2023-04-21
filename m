Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD916EB197
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjDUS00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDUS0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:26:25 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4819A;
        Fri, 21 Apr 2023 11:26:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682101549; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ds5/t7tB/NXM7HvrlG/DEhVQjQSPN9lS2QcmvahcM/5pTa0KmZEjjAFxJiH4WvXUICPoFmLKgF3CHbdT+f8KaQN+G6y+ekdhd4lXd2uN9mmGnuz7ozKbcRvlUGADaddw6/uALn41InwJ6T+1gVIIqXaDIbCZELLkKNu12ljBTxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682101549; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gAERKVRg6pqZtkYAZeOg+BzUO9hWZqA/1cyFdbAA+mw=; 
        b=WN1nZ0Ht8kq0jdrxnnF+EQwbQ/VnQnIWuGNlQNFLE6kyal2Nyqjye0EUT5TyOOlW1+dRR3GWlHwiTpXhbsYvgvaC4ClC2iOnDpIPAmRHGMil2tN6zX75QQOjckKY1kgxN+p3rT1Auxk/K0sCzWdQ7NdBc07+zFU7F4Eg1yJ+irk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682101549;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=gAERKVRg6pqZtkYAZeOg+BzUO9hWZqA/1cyFdbAA+mw=;
        b=Zo4JC4PDTjErNWz6V6pNir51eG6T2A5En1K4G2Ghzj7dUp/oWkZTk+LE+8PsE5vz
        tSbQ+zxFcKtclizo4FdjOz8SSOIAwgVSmzoajW/ep7HHo7MX7kkGHrQoQ8CRsL94sCA
        J2qwKMo3AZ2jZfCRi492/xpMwejx2Ew2D3ebxGcg=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682101548505326.82901676703693; Fri, 21 Apr 2023 11:25:48 -0700 (PDT)
Message-ID: <235c80fc-3f1b-a9c9-6364-6f50ee45b21b@arinc9.com>
Date:   Fri, 21 Apr 2023 21:25:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next 08/22] net: dsa: mt7530: change
 p{5,6}_interface to p{5,6}_configured
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-9-arinc.unal@arinc9.com>
 <ZELH2RlYLPjJGx6Y@makrotopia.org>
 <810aa47b-7007-7d53-9a23-c2d17d43d8a8@arinc9.com>
 <f1c38c13-a1f6-93d8-90ae-4ea3f7e06dc2@arinc9.com>
In-Reply-To: <f1c38c13-a1f6-93d8-90ae-4ea3f7e06dc2@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.04.2023 21:20, Arınç ÜNAL wrote:
> On 21.04.2023 21:17, Arınç ÜNAL wrote:
>> On 21.04.2023 20:28, Daniel Golle wrote:
>>> On Fri, Apr 21, 2023 at 05:36:34PM +0300, arinc9.unal@gmail.com wrote:
>>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>
>>>> The idea of p5_interface and p6_interface pointers is to prevent
>>>> mt753x_mac_config() from running twice for MT7531, as it's already 
>>>> run with
>>>> mt753x_cpu_port_enable() from mt7531_setup_common(), if the port is 
>>>> used as
>>>> a CPU port.
>>>>
>>>> Change p5_interface and p6_interface to p5_configured and 
>>>> p6_configured.
>>>> Make them boolean.
>>>>
>>>> Do not set them for any other reason.
>>>>
>>>> The priv->p5_intf_sel check is useless as in this code path, it will 
>>>> always
>>>> be P5_INTF_SEL_GMAC5.
>>>>
>>>> There was also no need to set priv->p5_interface and 
>>>> priv->p6_interface to
>>>> PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup() as they 
>>>> would
>>>> already be set to that when "priv" is allocated. The pointers were 
>>>> of the
>>>> phy_interface_t enumeration type, and the first element of the enum is
>>>> PHY_INTERFACE_MODE_NA. There was nothing in between that would 
>>>> change this
>>>> beforehand.
>>>>
>>>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>
>>> NACK. This assumes that a user port is configured exactly once.
>>> However, interface mode may change because of mode-changing PHYs (e.g.
>>> often using Cisco SGMII for 10M/100M/1000M but using 2500Base-X for
>>> 2500M, ie. depending on actual link speed).
>>>
>>> Also when using SFP modules (which can be hotplugged) the interface
>>> mode may change after initially setting up the driver, e.g. when SFP
>>> driver is loaded or a module is plugged or replaced.
>>
>> I'm not sure I understand. pX_configured would be set to true only 
>> when the port is used as a CPU port. mt753x_mac_config() should run 
>> for user or DSA ports more than once, if needed.
> 
> Looking at this again, once pX_interface is true, the check will prevent 
> even user or DSA ports to be configured again. What about setting 
> pX_interface to false after mt753x_mac_config() is run?

On a third thought, pX_interface will never be true for the port if it's 
a user or DSA port so this should not be a problem at all.

Arınç
