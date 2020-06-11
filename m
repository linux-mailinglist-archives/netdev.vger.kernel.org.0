Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1491F68FA
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgFKNUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 09:20:13 -0400
Received: from mail-am6eur05on2061.outbound.protection.outlook.com ([40.107.22.61]:1121
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbgFKNUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 09:20:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYDBtKLRZKDYV1bgXJGuPQDkyiCxquU3QcQzSN0bZJok0Lzyz/dh3687pUZ911gnmRI/L0H5QpWZSiGAADJaAwNE1nD79fiECg+gUS26oHehUg4TTjGSUfmWIt/ewzC9gPKgGe2JesSy3/IHInozt9A5eTS3XbYBfqxDYOAcW5AL4hIqqqeN0ybDSH7GbkeLp7KCc+hO/sL1fGrK9nNjJgSCfOLf3j3ezet1f5DthgeE8rlyBF0DClDHOY/GYy06BJUbrcK+qTiaj7SqjavnC9b/BxTBK1jtQwJYI2f+M59/mKLOcpp3wovmkWG4A91ksck1F1hXntCJiJsT/094QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xdv3Gdvi9jJt3Iye17pCzxNgEpUr/jXD5GfBUkK/0M=;
 b=QU/X57A1z1M6lAzPLEOT4sgfZ1XRROP3KbRAtn8bNrYjIrL+9A2I5O3k421ox0pk6c19HSILoAz3uaY9VhBnfufRgNLWWcjOFd6MURbSijWilTYY+kKjeanlPuXUJF0b/bov84nbjH5bDcMRgTGkkhbAZ5EOLsL5v8y+9dEtz84Ujr2pkzdXwvACjx6Tk4Im/GHdx8ZsAp1pmBu98xQYIXcF8gTlFCh1OiRdOn7Xc1ppZ+IRG1WxPF3g1EnOjBPCzQvmPsUvkui1JNk/Bbs3ymMPEdVEog1AecmfdJHbqpnMOEcgofL+xpJ6OkLwgWE6ZAcqh30ind1DT6YpIomiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xdv3Gdvi9jJt3Iye17pCzxNgEpUr/jXD5GfBUkK/0M=;
 b=cF5+3bJsTFLJQ9uaEzxMmBvEa4vnKVxkkye47YTW8sUf8QpnxzO2cdDmyS6iHcTGuXwh/7b71SBUZCMpVpDuVT3CpReZ3FBnbKkcUrmRDksQciIXdqFvcPQxJjjH0Wx8pwdLcAQ9ZRja3/c0N3MmI4zT1CP2VcaHBZ4oJWXHIwE=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4260.eurprd05.prod.outlook.com (2603:10a6:208:58::25)
 by AM0PR05MB4834.eurprd05.prod.outlook.com (2603:10a6:208:ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 13:20:07 +0000
Received: from AM0PR05MB4260.eurprd05.prod.outlook.com
 ([fe80::497c:34f:a99d:97dc]) by AM0PR05MB4260.eurprd05.prod.outlook.com
 ([fe80::497c:34f:a99d:97dc%5]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 13:20:07 +0000
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
To:     Andrew Lunn <andrew@lunn.ch>, Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200430234106.52732-1-saeedm@mellanox.com>
 <20200430234106.52732-2-saeedm@mellanox.com>
 <20200502150857.GC142589@lunn.ch>
From:   Meir Lichtinger <meirl@mellanox.com>
Message-ID: <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
Date:   Thu, 11 Jun 2020 16:19:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200502150857.GC142589@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0098.eurprd02.prod.outlook.com
 (2603:10a6:208:154::39) To AM0PR05MB4260.eurprd05.prod.outlook.com
 (2603:10a6:208:58::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.0.0.9] (87.70.217.68) by AM0PR02CA0098.eurprd02.prod.outlook.com (2603:10a6:208:154::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Thu, 11 Jun 2020 13:20:03 +0000
X-Originating-IP: [87.70.217.68]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eab53e9f-2c37-4abb-bf69-08d80e0a28af
X-MS-TrafficTypeDiagnostic: AM0PR05MB4834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4834887E7FF23FF0E71F3B1ADA800@AM0PR05MB4834.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmyevFwvIiw0qfvimrCJB5eF8vU/1Ma+q6uDgtpIvh8TLxTFvku4vvl3enSxcEhrgtzi/rdM5RYMU+BKOkCKFOZZxaIUiinmXPibn8eF3FcA6pTMgoFgaNBGpYvoeNtRPaImXlMElxlVp9XvwU/19vqorR0bZMjwUM8rgDbDyDjd3T9XxnP5lD/4KtL3Fs7GfuZjkhNXZatGVK4iIo6reCe0g0d0MfuabkLHKxjhyrzDulrvQzmCKfyjNgPloluxANuLLDiS+TS6hQWG7M7HfZ6UQ030Ho1kxtk7xTIm/F4z5Wh/YEX3C4ff5wmcoXmoAJklf3eD3lpe/xPbNoKL/WjhnUON6OUxs7CnEq71TCXv/YIGeQgxdUJOoTZs5B3N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4260.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(6666004)(186003)(31686004)(66556008)(16526019)(86362001)(5660300002)(36756003)(66476007)(66946007)(31696002)(26005)(8676002)(54906003)(8936002)(52116002)(478600001)(6486002)(6636002)(4326008)(16576012)(316002)(53546011)(110136005)(2616005)(956004)(83380400001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W2J/FrQ22z1P4QQJhJfdMedb3imnJK0J/gRyyM6qbjADqKfHlR46dsSt7+Gfc3Qjgwlkot6DNjdsGLxzrYV9+vlGUfcsFH51+s0VElY54RyynW34OyDR7yuLkM82asZdtGeF4g+IIO1dNTNF/bRBQNb4RBAyQnmsB96MlIXyUa2Evrmk/CnWTYqzBsVxT4oCuroQd9hniSlC9YjziANlo+Mfn8Qris8opk+db/fSMU4ipjQPqJziX10y047sTIt0jWo5ziYrYJOYnNJc5KvQlw1YhxIHxrVQRg8xIzpij0wezNw1SwWVgZVnQi4fB7nh+8EVX0RCLYLGQLSYXQYv/jFwJmrIZxEk+lgULAEiV+0AdbeZFZPtdQxiLawxG+KgDfIEqhMuUv76XACJ9GW+ZdGzvWBllfWJ1pQ8joxQ1x8Zx7a9vJiAULKtTDkPt7LMLKeFm0YOlu7tgxEtRZz6hrsw1McCfxsShWwXNImP3RA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab53e9f-2c37-4abb-bf69-08d80e0a28af
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 13:20:07.3530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0gL0m6OB19rZy9i1jKiPogtvBV0bxiA2U5oQ7q543OB8lnQRQGkjnplqp6/UFaGyjpP8R0UuruliwLxSMissg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4834
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02-May-20 18:08, Andrew Lunn wrote:
> On Thu, Apr 30, 2020 at 04:41:05PM -0700, Saeed Mahameed wrote:
>> From: Meir Lichtinger <meirl@mellanox.com>
>>
>> Define 100G, 200G and 400G link modes using 100Gbps per lane
>>
>> Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
>> CC: Andrew Lunn <andrew@lunn.ch>
>> Reviewed-by: Aya Levin <ayal@mellanox.com>
>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>> ---
>>   drivers/net/phy/phy-core.c   | 17 ++++++++++++++++-
>>   include/uapi/linux/ethtool.h | 15 +++++++++++++++
>>   net/ethtool/common.c         | 15 +++++++++++++++
>>   net/ethtool/linkmodes.c      | 16 ++++++++++++++++
>>   4 files changed, 62 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 66b8c61ca74c..a71fc8b18973 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -8,7 +8,7 @@
>>   
>>   const char *phy_speed_to_str(int speed)
>>   {
>> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 75,
>> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 90,
>>   		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>>   		"If a speed or mode has been added please update phy_speed_to_str "
>>   		"and the PHY settings array.\n");
>> @@ -78,12 +78,22 @@ static const struct phy_setting settings[] = {
>>   	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
>>   	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
>>   	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
>> +	PHY_SETTING( 400000, FULL, 400000baseCR4_Full		),
>> +	PHY_SETTING( 400000, FULL, 400000baseKR4_Full		),
>> +	PHY_SETTING( 400000, FULL, 400000baseLR4_ER4_FR4_Full	),
> Hi Mier, Saeed.
>
> Could you explain this last one? Seems unlikely this is a 12 pair link
> mode. So i assume it is four pair which can do LR4, ER4 or FR4?
Correct
> Can
> you connect a 400000baseLR4 to a 400000baseER4 with a 10Km cable and
> it work?

LR, ER & FR are using same technology – single mode fiber, w/WDM –

and by design are fully interoperable but haven’t tested all combinations.

> How do you know you have connected a 400000baseLR4 to a
> 400000baseER4 with a 40Km and it is not expected to work, when looking
> at ethtool? I assume the EEPROM contents tell you if the module is
> LR4, ER4, or FR4?
>
>       Andrew
Correct.

In addition, this is the terminology exposed in 50 Gbps and we followed it.


Meir

