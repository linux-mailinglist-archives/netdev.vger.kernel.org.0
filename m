Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025416EB173
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjDUSSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDUSSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:18:32 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC08E5C;
        Fri, 21 Apr 2023 11:18:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682101061; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=NvW5PMzboN2oljS2TRbMemAjQYPKqEcFN3hDVO00r1N95UKaOXWZ/XTJ56LXyt9nVa7/Rsy3Ydvhmex4gK2Tl20qMw44mKPJK3m1WUXgTyMXdV+UWilycNUoJICVnhPrdUFYQwjcdveglA0KELbCwOL2ahuYUqVzZSFKdXzlxBw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682101061; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=xWWFChmQ+UHotcIY2z7pe6hhMlP2w1vAmQsTuIvSeco=; 
        b=SRNDDXJeyyQUqeqDQWDX1zLXmIJN5WsmZnFhEQ8yL9KLL3iYoY1oUhOscbt1KWBpEqp+0ma0yMqA0L3To2ubSydwgiY3tTAEB6I5Gtka/3KPJ3IAU+E6+YLQqw9XYpLe6WnHiYWdtpfqp7+e/FofIpPY4oZ21hx2I/LOjOLw+bA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682101061;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=xWWFChmQ+UHotcIY2z7pe6hhMlP2w1vAmQsTuIvSeco=;
        b=X2yZE7JrO3Sy0316LrOgMRPbSRIHbgD1987AfCMgY93+kqXnt7E4PxKdhLfGZkGw
        i6YFpGXSo44a5tgAkOEUUSNqxuHWnafyRTG6dAC1fDmP9h55NpitPP3Ppzo8EYGKg+f
        Z0fxWsNAqA2v5dvZsumy9eJ2mykwldIVhkmrI33c=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682101060291324.7908655036442; Fri, 21 Apr 2023 11:17:40 -0700 (PDT)
Message-ID: <810aa47b-7007-7d53-9a23-c2d17d43d8a8@arinc9.com>
Date:   Fri, 21 Apr 2023 21:17:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next 08/22] net: dsa: mt7530: change
 p{5,6}_interface to p{5,6}_configured
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
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZELH2RlYLPjJGx6Y@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.04.2023 20:28, Daniel Golle wrote:
> On Fri, Apr 21, 2023 at 05:36:34PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The idea of p5_interface and p6_interface pointers is to prevent
>> mt753x_mac_config() from running twice for MT7531, as it's already run with
>> mt753x_cpu_port_enable() from mt7531_setup_common(), if the port is used as
>> a CPU port.
>>
>> Change p5_interface and p6_interface to p5_configured and p6_configured.
>> Make them boolean.
>>
>> Do not set them for any other reason.
>>
>> The priv->p5_intf_sel check is useless as in this code path, it will always
>> be P5_INTF_SEL_GMAC5.
>>
>> There was also no need to set priv->p5_interface and priv->p6_interface to
>> PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup() as they would
>> already be set to that when "priv" is allocated. The pointers were of the
>> phy_interface_t enumeration type, and the first element of the enum is
>> PHY_INTERFACE_MODE_NA. There was nothing in between that would change this
>> beforehand.
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> NACK. This assumes that a user port is configured exactly once.
> However, interface mode may change because of mode-changing PHYs (e.g.
> often using Cisco SGMII for 10M/100M/1000M but using 2500Base-X for
> 2500M, ie. depending on actual link speed).
> 
> Also when using SFP modules (which can be hotplugged) the interface
> mode may change after initially setting up the driver, e.g. when SFP
> driver is loaded or a module is plugged or replaced.

I'm not sure I understand. pX_configured would be set to true only when 
the port is used as a CPU port. mt753x_mac_config() should run for user 
or DSA ports more than once, if needed.

Arınç
