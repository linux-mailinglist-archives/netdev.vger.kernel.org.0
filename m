Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F3C42610F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhJHAWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:22:14 -0400
Received: from mail-eopbgr40084.outbound.protection.outlook.com ([40.107.4.84]:12859
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232350AbhJHAWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 20:22:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+7+Is2WdT6enbHle5UG8jijKwRhQlV3NG+LlOZtj06Eg2syVNIXSwe0Ceo9GIyxtdvPI+fmZ2kMOlEhuW1T0WdYEyAF10zXYZl7hUOkSdMtMfccLWiXmqRAZclLUfupPO/ch/exvp2hHu22hvy/ymKaY/UdZ/r/uNmP4/fqBHxKQ8Mvk8DRYF9RQNHqBd455/WUJEZlSBKXmLvMBnB0Ro/X/dWpYYlRmQQ+jsSCr8SZJYCxzWJRfhJnzMAr1nfO+9j1egBUvDaYXyUIOd08rz/7/Zi1RceSz1pSS6Ca/jA5e8QH6oDTTMNnLjH/NU3tPUvH8vKKc+9GCu2QBl0s6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzn94vbO/iawGYn7jqTGeDGzUnTVFLoPr/bmcH8gyEk=;
 b=aeiCs74qEfxcWXQ5+3Xf9xKbr3YoM9BmQ6yEP+kuroT+ij0kaY9IMzpDPW4WIFkG9gZmd+iPo5yPFK2ht0Xt4UFHEs33dwEwqeqsZjSpWzMrHzT8LrW38vHP9yCe48q297n4/Woipu/dvUdRfrrzXaNQs7BJz4LBjkkQvSjov4AIN//BXNxJG+SvniKakRN6047d7v3tSGqbnlhSK9VZH7X9xAX1gWSfkT57jeXw7NfVjFiCBGXay2lDnSaxbAQwX34M1T6s4jwSo5mMFexEmCW70X0AMCR+HDR8pnVNOT1plowN41yYETehaIaz9iCwzssclh18Gw1lUMmDEYOPbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzn94vbO/iawGYn7jqTGeDGzUnTVFLoPr/bmcH8gyEk=;
 b=JduzR38gP90+W7EORML9oEJedUiaBLaRpv9ibkZADhR4ojWeDPitHvXHp1+hzUgXx4cty+15BQr4RuKDfVShlmbEl9G9QietL3e8379E1hd1QwEGr2whsC/0xF2g73gZbOyT5YrxgjJDZ0La/wzxr1Dwdh2Nn+HNC13ZgIz4b0M=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4986.eurprd03.prod.outlook.com (2603:10a6:10:74::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 00:20:14 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.019; Fri, 8 Oct 2021
 00:20:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 08/16] net: macb: Clean up macb_validate
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-9-sean.anderson@seco.com>
 <b1401da6-5bab-2e4c-e667-aca0bbf013dc@microchip.com>
Message-ID: <b898bd53-baa8-2a25-74d2-de3b75f447e3@seco.com>
Date:   Thu, 7 Oct 2021 20:20:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b1401da6-5bab-2e4c-e667-aca0bbf013dc@microchip.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0116.namprd02.prod.outlook.com
 (2603:10b6:208:35::21) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR02CA0116.namprd02.prod.outlook.com (2603:10b6:208:35::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 00:20:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69f3e8e9-042a-4774-7df4-08d989f16617
X-MS-TrafficTypeDiagnostic: DB7PR03MB4986:
X-Microsoft-Antispam-PRVS: <DB7PR03MB4986BED4F8A65AD84A97760196B29@DB7PR03MB4986.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E5Wt+DVIjY4vmHG2kYbubExsYrpwoh6d7BziWkBM65oP/TW+4MQxVb6mtOmQ7N1uJUD353Z9PiQyNX4JH8dQizBNueBQF1+X8oNowKtOegA30oI3niGCwDObXGUCQGh/dafoeFAk0mJQNOY7O1L17WWEIlE37IqdnP2vaGPvN1cJL8cACslLq2+uXj8Bkc70ypz69Gb1u53kTkUvDRyQhwONLtFPUmWVTZyyM6ko99saRAd9iDrk+Aasz2Bj+4CSIH7yAN8uMNikLzqM5DfQ48H0BRWsRNab1zgdus0OK1n+/SioX4CnarR9cpM/3AjmyCbWk840ktdtliJnfnidFdhUL0gTx8VECXwMW317VJCpGf2TT3wJY9EnbyJjqSVypOYTk+sxNpr+OH50eSVkQYsZQl5Ka4RV1olAeRVWdDhwEwDOkcsVyYWHzWow0IRaP3mTFDjkzEyezIisvYHHj+3CM0U5dVW0JDDs4xt3gCMj2XcBMxtmBTqDksDwFEyZibhgKsAU1rLgZQHGIpco9Enh6qKNQYCGp5zUAOZk0gZ0GFux1HZ5EIrPO/QA8/wN4RFxVcEe7vm6mlwTKPqpui5yheitxSrnOY12GqSsFhw4I44wI0HyhjMgLLDG9YKD9UW2hyBWcgxM5bzC3BwuDzRO4W2iuu0MY4S5SURPPepZdWH96WaqPqLrA3Red6JWW/SuQEB+BIVlMVqtQAV7LmBFIdVjNROalhNh+rTPd3psSod3G0bKiPSytP67EshH4PCsai1H+dQY8jq7it8ErA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(316002)(52116002)(26005)(8676002)(16576012)(31686004)(66476007)(31696002)(6486002)(38100700002)(38350700002)(5660300002)(66946007)(8936002)(66556008)(4326008)(956004)(53546011)(44832011)(2906002)(186003)(508600001)(54906003)(110136005)(6666004)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?8AxYkmMAsK4S5YjNy/OwxInBAX1Gn9ax3XEcP9R62cCGwtG0survRDdZ?=
 =?Windows-1252?Q?Q1ZaRt3vutRa7+u39kldCRJstQe0xFtOcLs63Yq9VFNP1ssTFchSsLPb?=
 =?Windows-1252?Q?hHRou1lSpVwmIVImtXHQGEtNBqhcp7Flys1NLwXyNF3Wwz48dlVtQwWC?=
 =?Windows-1252?Q?Q/TIMRazxK9htujyg4AZajnQFI1EzGkZUxUn4MMX+KIUbEfcI6S9tafb?=
 =?Windows-1252?Q?OTvDXSEFWiLWdYtuG8zDTedmd47+EhCkzppt16nkzrBw1IRjV/Ib8/Ut?=
 =?Windows-1252?Q?f4FT2eLijMj1uQnKcypTJHyAUaqw47h6LTJlioecSrGgvtbRDFDmQrGA?=
 =?Windows-1252?Q?R6tshSxYdDd4nSQlxoQSt7WJmXG0/Jd1NZXaj7Eitm8JsyXXDTqZydbH?=
 =?Windows-1252?Q?oZQYrZNHurX1u56G0pF60mtNFRipENzNYXokNiKcojclD4Jdzdp45GGg?=
 =?Windows-1252?Q?uW00uWX/sWcvBKprOPDEi0KLP4+kM/YUYKNGgCodrSHXE3ZPZwTQUwrl?=
 =?Windows-1252?Q?xvTrElLlvP/4A32dIXLNxS05cY4+Vbq8TsNxD7VS4xEOyDkN1RHYpkvM?=
 =?Windows-1252?Q?KT7Jos2EerFrCdoKk4QVAWxqwNaKH5B7iJXzlpzEMTj/xp5n63Am7W5g?=
 =?Windows-1252?Q?FCyB95/NYubRwfwirw33r1iN4Ay+OcrZj6z/p8X/C/Rjx6xa1Pqcr0dI?=
 =?Windows-1252?Q?/3O8udXDbWT35gp8iG9i0GhQ8ZPZF9j5THk7M5x+y3zr0bnTzlurariG?=
 =?Windows-1252?Q?NgW0ymZvV/BHA2pFbwyUUtXeXaEkAGDDytRjOnV3TxLIJFwCsB7crlN5?=
 =?Windows-1252?Q?T8hzC/bCV7Oo5b9z6ojCBgseWGLs2s6Kwg9Lq3/07EfjFo5BZzUG5oAB?=
 =?Windows-1252?Q?4ZfqRgQ1jg0yTHClQFRbkFmgBKJxtQ3udZoVa86l55eIXOnbTqP+WR9j?=
 =?Windows-1252?Q?QfaTVULQ9zXoM+LmhHzujYkkSxpU/gcZEpuLR96+JfGTYMVO4IhXDdph?=
 =?Windows-1252?Q?Dd9uVh8yhhgirkd65+AMm/GRnrS1NzMPPkxapHCUNOpdz/ygoJjB7gR1?=
 =?Windows-1252?Q?xE4opTiXKoTmI62mR0FyKdt5ZwWJn6OWluYqHdqW5aq/es/POF+6dLfF?=
 =?Windows-1252?Q?5FrnSxUSgl5oIi2mnp+GwP+MxE8TR2AizwtJGf2xGxtcW45+ISnCekz+?=
 =?Windows-1252?Q?I5mJ+3NFeN/EGKyPj5X/QuzPLRLLGXkRsM5Zx/sI8kwqcgzBjF9DvQPL?=
 =?Windows-1252?Q?SYBGBnTwf8sBtdz3lU+RjQLqI670FP5o4utg8x2dvA8KO5v2rPK/oI3H?=
 =?Windows-1252?Q?YjCLkxKgZpGpJWq8oc5yTbkoiFXhmb4DLeakXOfF91MY9xKbDpqv2XXt?=
 =?Windows-1252?Q?QmqB927n4xGYGEAuWNSNogi3gQHPoRFLVdIW+wXUs1pR8Az/IkJWbvCa?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f3e8e9-042a-4774-7df4-08d989f16617
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 00:20:14.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2cHFNOSdwAzwL93HJqtIenmJyPmj8RUkTjy4+u6m9OMEep6xgUCFgUMKw0HLKbFNbYRpnjMtdumWfB5MNm16A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On 10/7/21 9:22 AM, Nicolas Ferre wrote:
> On 04/10/2021 at 21:15, Sean Anderson wrote:
>> While we're on the subject, could someone clarify the relationship
>> between the various speed capabilities? What's the difference between
>> MACB_CAPS_GIGABIT_MODE_AVAILABLE, MACB_CAPS_HIGH_SPEED, MACB_CAPS_PCS,
>> and macb_is_gem()? Would there ever be a GEM without GIGABIT_MODE?
>
> Yes. GEM is a new revision of the IP that is capable of doing Gigabit
> mode or not. sama7g5_emac_config is typically one of those doing only
> 10/100.

Thanks for pointing that out. But even that config still has
MACB_CAPS_GIGABIT_MODE_AVAILABLE. So presumably you can use it for
gigabit speed if you don't use MII-on-RGMII. I suppose that
sama7g5_emac_config is not a GEM?

>> HIGH_SPEED without PCS? Why doesn't SGMII care if we're a gem (I think
>> this one is a bug, because it cares later on)?
>
> MACB_CAPS_HIGH_SPEED and MACB_CAPS_PCS were added by
> e4e143e26ce8f5f57c60a994bdc63d0ddce3a823 ("net: macb: add support for
> high speed interface"). In this commit it is said that "This
> controller has separate MAC's and PCS'es for low and high speed
> paths." Maybe it's a hint.

Ah, so perhaps HIGH_SPEED only represents the capability for a
high-speed PCS. Which of course is a bit strange considering that we
check for both it, PCS, and GIGABIT_MODE when determining whether we can
do 10G.

--Sean
