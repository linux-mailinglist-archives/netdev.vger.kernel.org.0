Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EA86C6D94
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjCWQbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjCWQb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:31:28 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2079.outbound.protection.outlook.com [40.107.7.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343F237726;
        Thu, 23 Mar 2023 09:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60RgRqj8IXQ4oE/FEk7PhLZiN2eqNRpjUCdx1dSxwpQ=;
 b=LYcFiqgPcX8wh8v6GXko4EwuMA42DQGM/mV4aDhlDTp83J+QG6AXhfvilvH65nHb9sSgVSdW/R4DdjmGwUrQDR5x5OFQTXKtd7PIifj6/II9z8VNcDpQARgtTCNxEBqNokJ1ED4nM55L9N937ImAr9QxvhOXn3NXzZVnrDAn9IdyO/umMmn4ytH7PCxwJiOPr/O8C+xn0w/c3f3H4+YYnseIgjcVAS7I6WRqu0Xt2/4XC3CzCdXq+8bHoZQTqnKrVHZPo27Lt00Zx0WmSwBJSgmk2rfi32q+lGrYbbKggIKKtGbKYFDtJqxzmq5sdkGDX5uS0YHmH8t9tapH5lQcuQ==
Received: from DU2PR04CA0166.eurprd04.prod.outlook.com (2603:10a6:10:2b0::21)
 by DB5PR03MB10049.eurprd03.prod.outlook.com (2603:10a6:10:4a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 16:30:47 +0000
Received: from DB8EUR05FT031.eop-eur05.prod.protection.outlook.com
 (2603:10a6:10:2b0:cafe::61) by DU2PR04CA0166.outlook.office365.com
 (2603:10a6:10:2b0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 16:30:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.86)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.86 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.86; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.86) by
 DB8EUR05FT031.mail.protection.outlook.com (10.233.239.193) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Thu, 23 Mar 2023 16:30:47 +0000
Received: from outmta (unknown [192.168.82.135])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id D6D1E2008026E;
        Thu, 23 Mar 2023 16:30:46 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (unknown [104.47.12.53])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id AFD6E20080075;
        Thu, 23 Mar 2023 16:20:54 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7x9r3wYKLmRaJSfQJu7bzmA6x2hrEEFvU6y2E8PZ3QmQvBlVtYc2plPYjZ0Jbdlv7UEdrCpTa1xlRxy4AvjV+qIk99JKTGAv7+niK3z3j8OAasIGo9q+6vNiJTTvVfE8alWxalNZbee6RItAQ6agriXHQwYWy8a2Phe8G4bXru2mFPfsyAh3+fU+S1RWdCNQZCfGW3HPCytBXFm7Lc2K+X6NoYTgDoB48PFTRSTHp6mcpnHnbG01VMeIYfn8teYxclKMg0JhyxEz/dE3SiaInKzJBkEmkebaPlaF1a2jACdbnWp3QOWnYXJyamN6am0bydhCtfOj0fuI+Jc6dEb4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60RgRqj8IXQ4oE/FEk7PhLZiN2eqNRpjUCdx1dSxwpQ=;
 b=HLn/jrriH1SOQi0A6dqfhlZtsSCDveihy70In7XI2lrqosX/tvY+ZYLy+oyVVWUg1+z3mNVhfUeIubv4L2H5r4ssXROLUzCSPuYc4NWCac65NZexJ8TrDlmQHAkSYACoyHhrNlPul0INlzhR6reErLOdQTQm5cjaOfOqK1Kk2NifnWMyKzAKRDHXkDKXhDx9C8oNWyITPFJYG0hhjaPhoQO5uR1VNQ5mmnd+ctazqewiQqlMTStR7lASaY/3Y+6jR24owVYIn40qlmzW8hgi1TuZsl+tlZui1yRlULJgGEFqfcy3+KJC+4+nE+waVWHngyA8rGxUCULuIvtCcOeVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60RgRqj8IXQ4oE/FEk7PhLZiN2eqNRpjUCdx1dSxwpQ=;
 b=LYcFiqgPcX8wh8v6GXko4EwuMA42DQGM/mV4aDhlDTp83J+QG6AXhfvilvH65nHb9sSgVSdW/R4DdjmGwUrQDR5x5OFQTXKtd7PIifj6/II9z8VNcDpQARgtTCNxEBqNokJ1ED4nM55L9N937ImAr9QxvhOXn3NXzZVnrDAn9IdyO/umMmn4ytH7PCxwJiOPr/O8C+xn0w/c3f3H4+YYnseIgjcVAS7I6WRqu0Xt2/4XC3CzCdXq+8bHoZQTqnKrVHZPo27Lt00Zx0WmSwBJSgmk2rfi32q+lGrYbbKggIKKtGbKYFDtJqxzmq5sdkGDX5uS0YHmH8t9tapH5lQcuQ==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB6963.eurprd03.prod.outlook.com (2603:10a6:20b:2d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:30:38 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 16:30:38 +0000
Message-ID: <d6900e52-ddd2-9334-3ed0-734b3e4a957a@seco.com>
Date:   Thu, 23 Mar 2023 12:30:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
 <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
 <20230323152724.fxcxysfe637bqxzt@LXL00007.wbi.nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230323152724.fxcxysfe637bqxzt@LXL00007.wbi.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0014.namprd12.prod.outlook.com
 (2603:10b6:208:a8::27) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB6963:EE_|DB8EUR05FT031:EE_|DB5PR03MB10049:EE_
X-MS-Office365-Filtering-Correlation-Id: d4ad94d2-b560-45ef-1b4e-08db2bbbf4fb
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: RnDYNXJq9WL/dPNIZGcmknyZpeNhSK/PwIH9qtZVeL3GpA9B0GA3krdvrVBzXJWHiRaaIFFIuBHXqNA4xPpqzl3uWxrBJ1SPARDB5C1KD6o6p0129CtsVpF8k1D1Uz3Ay7PtA3y/zbCblWchkmg++Qu42PvITAVCuKdtTMXuPrGSED0nziuIawI9E1ZqqUuJ6W6X0Bs6huY4fCxUOWB0uHsxuxKpPg/wM2I1kRCGC86ayvi/nKfwJCY8gejAuWMcMACDOu8EEir8ROnzdHVbMgovjJa0Yd8MbOifZDCeYfBxtmNLeTnmYZ+yfr7lyVZxluA4OVK8n/4T65170fDDJVkqAeUdwZghQBgMq3Gm6lRjVJH8VqK69vzH8IonnXEbsL9eJI6ZG3g6M3YO4ACMX6T/P9nNU7S25QBwH4XEZ05BBwgGujWsuwlUaFYwXb522nNEzFT8SvaQTefs4ikxdXktJfCTPXM5oP8ZleV6pfxqo9h9MNQNUfKVTpUcP9S+EzOeUS9VTq2xWb+mVuAmkdkKPkFCcdO25M9VJbkkoCwImfyOQMot7RHkLYU7DSuaPusXwuA2mbk73keyDXKGyBYlfjCHjZiGxgx4D2pQesUn5+se5VId3onFtwTDRhsa3SsubVaoS6TtEja8QP5OdIctjD1Qv+fppQLGEekw8G5t/XJOzMHcq+cr82P076VY6gwDWbBXolQLj15zGVmXCj11OTGkZ/jtc9QbCdX2M3bYeFHYHM8hqZjaV4jBcJAnGu75Tm0Oxd3fyAcoszFNRg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(39850400004)(396003)(136003)(451199018)(31686004)(38100700002)(38350700002)(2906002)(478600001)(6486002)(2616005)(186003)(31696002)(86362001)(36756003)(52116002)(316002)(66946007)(54906003)(6916009)(66476007)(8676002)(66556008)(4326008)(8936002)(6666004)(6512007)(6506007)(26005)(53546011)(5660300002)(44832011)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6963
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB8EUR05FT031.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 957bf8a1-b484-447e-83e9-08db2bbbef80
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A4p4jpFOwFpGChmRKib9/sSvl+iH9ank3USnxwFZwi+OXWm1SH72n0MfOTuOxfGloZwxkDV/XMkDnE3TuJX1wYpAd3azoifJ1mULJZNJwS5t6pO9rkYdkQadvlxzBsaISF5g8Uk+k93CMOYs32ZOL8IL6l8UPPH5cyCq6dumtaUbpqPHzKzMwAwa6Erj1nktZfeyCDKOkseqWrVZA/Ksu0HKlTjgQSvMegxib4D4cpo4pqKUW8BTZrAxK17jl+GspzLooDKOvI4ng0nYg5NjO3rHt1O/J194oOOUDfWEtK2dv8l+3FvBvqDvUExrwHnDvfmuv9VUN2r5Xj0UvHj87DPDK7voFWIY84N0ZSbdYqTXdSBt8vndknbOe5vdsgDVQ55PjYW/FxVEeNRmXqLso9QFgRJwUXVhEv/qu9+vJGBR5Swe4SVAutsX33RzJjYkZgxB96i/1RluJZ3iaWWA1WUI5ePbG2ocJ2KOUH6rE2jXe+8jQZvYduwqyvpmdOJqgp+xvenvj57DRwosGUhcSJCyMqhUpW0KkfPUkg5B5Qfc4T1OXwfdE7i3KiOKWd0xUhK3+5APGxFRPbRhynzMehYiQ/tPVYT5mXaz7/FqcM3HfIgZRwwyxY+VzJ4wmkVwk7mrAttZFdaxy4GZXcMFhKePveE+SSJ/4sP/SDYIwt63nl1EYRnKjBWYude9UB0B5Cfl/c7fKjJw2f4xGGwz+sbcOJ6PPJXNLpVBY+iqM74=
X-Forefront-Antispam-Report: CIP:20.160.56.86;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(396003)(39850400004)(451199018)(46966006)(36840700001)(31686004)(41300700001)(5660300002)(8676002)(6916009)(4326008)(2906002)(44832011)(34020700004)(36860700001)(82740400003)(356005)(7596003)(36756003)(31696002)(86362001)(7636003)(26005)(6666004)(6486002)(70586007)(478600001)(316002)(70206006)(8936002)(40480700001)(82310400005)(6506007)(54906003)(47076005)(336012)(2616005)(6512007)(53546011)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:30:47.1095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ad94d2-b560-45ef-1b4e-08db2bbbf4fb
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.86];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR05FT031.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR03MB10049
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 11:27, Ioana Ciornei wrote:
> On Mon, Mar 06, 2023 at 11:13:17AM -0500, Sean Anderson wrote:
>> On 3/6/23 03:09, Ioana Ciornei wrote:
>> > On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
>> >> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
>> >> add backplane link mode support"), Ioana Ciornei said [1]:
>> >> 
>> >> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
>> >> > by Linux (since the firmware is not touching these). That being said,
>> >> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
>> >> > also have their PCS managed by Linux (no interraction from the
>> >> > firmware's part with the PCS, just the SerDes).
>> >> 
>> >> This implies that Linux only manages the SerDes when the link type is
>> >> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
>> >> moving the existing conditions to more appropriate places.
>> > 
>> > I am not sure I understand why are you moving the conditions to
>> > different places. Could you please explain?
>> 
>> This is not (just) a movement of conditions, but a changing of what they
>> apply to.
>> 
>> There are two things which this patch changes: whether we manage the phy
>> and whether we say we support alternate interfaces. According to your
>> comment above (and roughly in-line with my testing), Linux manages the
>> phy *exactly* when the link type is BACKPLANE. In all other cases, the
>> firmware manages the phy. Similarly, alternate interfaces are supported
>> *exactly* when the firmware supports PROTOCOL_CHANGE. However, currently
>> the conditions do not match this.
>> 
>> > Why not just append the existing condition from dpaa2_mac_connect() with
>> > "mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?
>> > 
>> > This way, the serdes_phy is populated only if all the conditions pass
>> > and you don't have to scatter them all around the driver.
>> 
>> If we have link type BACKPLANE, Linux manages the phy, even if the
>> firmware doesn't support changing the interface. Therefore, we need to
>> grab the phy, but not fill in alternate interfaces.
>> 
>> This does not scatter the conditions, but instead moves them to exactly
>> where they are needed. Currently, they are in the wrong places.
> 
> Sorry for not making my position clear from the first time which is:
> there is no point in having a SerDes driver or a reference to the
> SerDes PHY if the firmware does not actually support changing of
> interfaces.
> 
> Why I think that is because the SerDes is configured at boot time
> anyway for the interface type defined in the RCW (Reset Configuration
> Word). If the firmware does not support any protocol change then why
> trouble the dpaa2-eth driver with anything SerDes related?

It's actually the other way around. If the firmware is managing the phy,
why try to probe it? Consider a situation where the firmware supports
protocol change, but the link type is PHY. Then we will probe the
serdes, but we may confuse the firmware (or vice versa).

> This is why I am ok with only extending the condition from
> dpaa2_mac_connect() with an additional check but not the exact patch
> that you sent.

AIUI the condition there is correct because Linux controls the PCS in
both PHY and BACKPLANE modes (although the RGMII check is a bit
strange).

--Sean
