Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFDD5771ED
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiGPWhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPWhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:37:32 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024D31CB2B;
        Sat, 16 Jul 2022 15:37:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAoJnq29xu8Bfz3tPKgSsIPJC9xEnxv7fD9OLArJh5RhsmNTJvK6jgmgRJmXb77hvLvm2ll7OUAt3BJyz2j+/UnPGP/9GmIZg0u4UuGMSONTMqOmBuDEKyDweYoLBT2D9PZOFHm+vf46dHi78q4Bpr7JEabSKaOqVcdYTCMPQ3LVytlHcjODtVO6o3Z/KsY8mDxuSzhaCNq4DUpPQLBb8gHRaIIp/cdtX3UiHd58x4Jd8rrcPwWn9KCZZeNUHu74WLhdH2QbpwF2HPfwWf9av/wCei4wVrrxBWlfC2EseLIDZjCp5GPDJnIhIT5H+1+kbsal8AZ8hHCFcmweVI7ohg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csCI6oX8rXPCn7jli1asJ/VbsGp+AHuf4H9qu/BHxsg=;
 b=RTVMdyArFjIM+xPrEWGRRqEbzlCUsPxccSWg77amDhFJIoDdze78o1ToGhXBgr+ceqGrPT3/DtAtymJb3jobaNXFvJuEGKCoUmGA01it7Gi8Hd6Qp7SDBiogkin0L6vU/YWUVzgxYtsj65hxFQawv2DZr2GzMNgaYszn5BgCoBwUPxtJfLFTtEO6ZurNZ7XVrHcg0Ew404yOBwHS7f3Zqtc6RVeIyvsibtkgiR/EAdGMlJeb/JcnyZ2CqugTb60Vg/t8QlRw6PlvgeKtyXduDZINzAkpayjLvVQJthykkvb3qNFmsMVS7OIdLv3iQzoSa/dJ9O67z/SmDmp/4u6OSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csCI6oX8rXPCn7jli1asJ/VbsGp+AHuf4H9qu/BHxsg=;
 b=srA+kcve5vwd4I+41w1LO+Q94soC9or6qIso+cgjEQT7mmKuBJY9dWMPv9gdmCH2uqVM9jRPo5BwE5+vhPXqoXOKuaA+F9bzdjS4OX52pFJGvDah80vPnqMf8yjQpnBjEFOASXNtqzvERg8mI4pxZsqcd4n2Bv3Y0hJTbmatifazkJThZWV0u95N3/e44KFZN2tY5GZGhxQGAHT+zhu+Ql7vmw8RTXOt4gkTYUzrrD+DFGNHob7TydRb+8JcZt1A8qkhWuQdmDSZlRrFaycXCedcs8JocciWyEsD/IJlAqXCgupR19YKZFxZyMHWD/RVo+TTe0LpbAsyqFJSU9rMbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7901.eurprd03.prod.outlook.com (2603:10a6:102:214::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Sat, 16 Jul
 2022 22:37:27 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.022; Sat, 16 Jul 2022
 22:37:27 +0000
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com> <YtMc2qYWKRn2PxRY@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com>
Date:   Sat, 16 Jul 2022 18:37:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YtMc2qYWKRn2PxRY@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0124.namprd02.prod.outlook.com
 (2603:10b6:208:35::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e951a8b4-ea05-49ca-7f6d-08da677bc27b
X-MS-TrafficTypeDiagnostic: PAXPR03MB7901:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QmYO5DAryCNYimbFcKCzNS9zAiEKJNvdUbTv0D1FqAhIa0KAtGISF3dWPQK+ugC/WyF6o5hVBddPusxJ64PJmSh1ysK+B3DIsFulAUuQAcA94TksOysDgVbrfgqVsPXovzm6qkQsQT+tJHJdybvO9JbKZiNLfQZtER/35ppl0a/i+ap5cnYEL0aTJ23YZIlBFOWuAYgCBRFS8A55rHSHU8BWY6ntaCHjwdEzvHwX1nOHGziZbC3Ws17ZWQ8di2ixsf1jASVuqljYhOOFBEM54ly4+/+G0IkJxLhy/+rWiqWdEhCMsMA4lBfWyhSTa+wnRoF4Y4OW51Jfi15EzOTTAG01zADZyJ7n/7U6qk5X973Aab/PoIUr9yEa7rdpM6uLGu86dko1BUOwvQDORji5nb9y12xFTgsB7Krqa54gtDVyh13s4oucSx+DAolLUOZkJXawPVlsBWqWb9yL7TB/ouk0r+dc8UhhyHLbLj+PiNmGGPL0SHeQkFrgRGc72yhXJDWiFHOCijc0ESmg6QQFRn25Xfv0L2p7X1nr64rcQJ4B4Wy+o9iIn7eG2jOhnk/vPlUFwUZ+9wMQB65bT85cNlqjiUzyohH+peYRiURE6u7E+dYaYPCeO4+MV7l8Y12OK04Uw+TKYvEAUVV2PguOvIAzawPdPJNNTggAfobuX96GetMklSGVu6h1i1kT6tED7SGHKBo4+HwsjbBe3qGxGwtdI77Pp+u73/wtwqTOCI78sac1SX1SzqEdr9joM8FHwruJSRz7mq1vqNF+ME03Jr0vg3ONnzA2v70zrtYySp8y1S03SnPPbMh9rm3mX3zqKTnmXJLlyoVf/ztZA16RvNFSfFF4+g4QQWD+YKqAPfU45O9SSTLe1GZ2NUWrS9S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39840400004)(396003)(366004)(136003)(376002)(346002)(7416002)(5660300002)(66476007)(66556008)(66946007)(4326008)(8676002)(44832011)(8936002)(54906003)(2906002)(38100700002)(36756003)(86362001)(31696002)(38350700002)(6486002)(478600001)(6916009)(316002)(186003)(2616005)(6506007)(52116002)(53546011)(41300700001)(6666004)(26005)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUc1RVZrNkdZcE90eGFIeFNTV2trMlZodjhBWSt5dkg0YUdoQ0NGTm9kcTBL?=
 =?utf-8?B?OVk2Qk1sNXVrMkhWNjcrU0p5WnZsM1Y4RjlNMmR3bnhpS2tzeUJhSU4vVUpO?=
 =?utf-8?B?eDRzS3RxYWYyZlZpTmVSRTRjMFl4Mmp4TWYxRVZSa1VXU1VDbUt4eE1hSkov?=
 =?utf-8?B?YXgwRUgvbDY3cHgvZkV3ZDFPQmZHR0R4WkFoeXBQdlN3VFFydTBMSEdyb0F6?=
 =?utf-8?B?aE5RYStiVG1KV3Faem9vSTJ1RlF3aVBPbFlYaFFoM1pUekRTQlgyM05PcDlU?=
 =?utf-8?B?bHJtSG81M0xKbmFVUDIyVE1QdG1lNE5kRUR6TGRqekVXTnlUMTJqczhyNHBw?=
 =?utf-8?B?bWZ1Wm9NVW9RQ1NaRFBmN3BqOVFDcW13Q0J3MGQvYzBudVJGK3N3QVpySXNJ?=
 =?utf-8?B?SksrU1lCaVBXR3lWTDg0aUVDUjJkRURsY2tibUlHWGdFNm56ejhYQTR1bjkx?=
 =?utf-8?B?ZHNQSHJEcXpwRXd5R2VscmhUNnQrdCszYjJXUlp6Wk1jV0RnbzNGUkhHSW5Z?=
 =?utf-8?B?S0YrdlNBNWlPMVFHcEhWd3V2ajRYaEszNXhCNytUMDgyRGJqQUZkcUwwR2p2?=
 =?utf-8?B?MGtMVXVVbG04SkRUYTVpUkYrcVQ4NTc0OHE3Zlp6Zjk1UE5rdUt6SFhNSXEw?=
 =?utf-8?B?MDhYUVRuQXFhUmdsQlpyTkp6anBzVTBaZngybGR2UVVNWXByWnFqc3lkU1dQ?=
 =?utf-8?B?ZVRsUEtDUXVodnBzaWl0MEl4bVdjU0E3anJFdXczdkNuZWJnNUpoeFYzclRn?=
 =?utf-8?B?Y3o2S2FyQ2M2dHU1amluUWdLdSsySTdGUTdESndiNkE5Y2Q5bGduZGhJbm93?=
 =?utf-8?B?eDRReTJjaElqdFRQNHg1TVpaNm9kbXBBR1V6cVlnQUs2UFhIdGk2T3JRRERz?=
 =?utf-8?B?QXJzNkpqdkF2ZGwrOFhYZnJlcGVMTTc0dk9YbkFBVDJmUkNXL0NvL0JtWTI4?=
 =?utf-8?B?MUFCT0JjaXlRTWpFS3hYQ3UyZkFyb0c1MzlhQWRwVlJFakhCajNnTWw4YzNX?=
 =?utf-8?B?c1F0M1NaU3RZL0ZldWdsMEwvaDNvL3ovUHdDNjRpTWtSa2IwdnprdTVUSzBj?=
 =?utf-8?B?MTRYODJqVGhjdDVvVDZRcEgyUW9XOUlZc01xeXVQYTM1SHZOMk1XY25vUUZ2?=
 =?utf-8?B?OU5idkJHZVB3dDJ0Szc5YkxwUTN1Rnpldnc3aFpUajdENTZmbDFlekpKRm9a?=
 =?utf-8?B?TWoyNEhYZnZNU3U1OXRaV1RmMFA4ZjkyTG5LYmhQb3R6Z2xlSkw3eitqcThQ?=
 =?utf-8?B?eDhRNW5UZ0RERERQbmwzUlp3R0k5MkZZWlZvanltZDhtWWVsNE1ieGlkNGxO?=
 =?utf-8?B?UytFTldtMURtMGhFMEdqL1JZVEF1MVR3L3d4TTl6ZGZrbzU2Zm0veWNvREJ3?=
 =?utf-8?B?czN2SmhldkhFQ0UxMUxpOXhSNGlsbW5JVlFIYWFPZWhXUFBBMjNDZWZnN0o3?=
 =?utf-8?B?SGFNSmg1MHVna0tELzRieWs1Y3E3cHhpeHoxZDhJS2owdGIvU2pRck9tSTBT?=
 =?utf-8?B?MSttd0JBNTVNT0hOYk51cGM0Y2h1TGxYN3U5K0xZdDR4bmNTRUorVktreDJQ?=
 =?utf-8?B?N21wUUpjZm0ybjI2ZFJkWVF4Y2drVVdRbFE5MVhzeVZzVStIOFkzbVlySDhC?=
 =?utf-8?B?Nm9iT3VVM3JJVFBvVjMyUjdSeUxhTVA3NndzUUhmUytSU1YwMGpwYU9UektX?=
 =?utf-8?B?ai9HeGk3eTFwSjFMTDIvajJFM3FzUjFNcjhEb1BaaXNHQzRiZC9DbTc2VEJS?=
 =?utf-8?B?eTB1VzlrNndDMUlvQXNtZHZUKzU5WjZxZTllVHU2YkNCWkh0ZVdtaFR5ajBZ?=
 =?utf-8?B?c2tScndQdGtDSXF4VklHck51eExSWWl1VkJieWU3V1VnU0xFYjQ5NFJ1eCtF?=
 =?utf-8?B?Uy9oVWw5MUdzMFphekpkNzNRd2RuQnJDVFo5Sm1EU1pWMUVIRDZGSW9vbXdR?=
 =?utf-8?B?SER3L1czKzhmNXF6NlR3ckhxVnRPekw3ZEtZdTJtRnpvTGczS0tLKzhzUXRE?=
 =?utf-8?B?ODJXVnFXejVHdktEMUNjTTgzdHRudnpmWTFaMTRjMHNQZElsRmViaGdEOFRh?=
 =?utf-8?B?SUY4RVY5eW1XUDVyb2ZNQVJOZ0xqRTUrVzN0cGhmaS9Qb3dEWDRKMGxyY0Mz?=
 =?utf-8?Q?yN8ZhauY1cCq8jS1ERCGiaNt2?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e951a8b4-ea05-49ca-7f6d-08da677bc27b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 22:37:26.8951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Czo8unPwV2/yiZXnHlp2rtIoB2XJ1F2D1VocIQZMNkCsQlCRPsuOdyxIcoqXQvFBcwOulIP/McgdzQ8sW0SLfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7901
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/22 4:17 PM, Andrew Lunn wrote:
> On Fri, Jul 15, 2022 at 05:59:17PM -0400, Sean Anderson wrote:
>> If the phy is configured to use pause-based rate adaptation, ensure that
>> the link is full duplex with pause frame reception enabled. Note that these
>> settings may be overridden by ethtool.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>>
>> Changes in v3:
>> - New
>>
>>   drivers/net/phy/phylink.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index 7fa21941878e..7f65413aa778 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
>>   	pl->phy_state.speed = phy_interface_speed(phydev->interface,
>>   						  phydev->speed);
>>   	pl->phy_state.duplex = phydev->duplex;
>> +	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
>> +		pl->phy_state.duplex = DUPLEX_FULL;
>> +		rx_pause = true;
>> +	}
> 
> I would not do this. If the requirements for rate adaptation are not
> fulfilled, you should turn off rate adaptation.
> 
> A MAC which knows rate adaptation is going on can help out, by not
> advertising 10Half, 100Half etc. Autoneg will then fail for modes
> where rate adaptation does not work.

OK, so maybe it is better to phylink_warn here. Something along the
lines of "phy using pause-based rate adaptation, but duplex is %s".

> The MAC should also be declaring what sort of pause it supports, so
> disable rate adaptation if it does not have async pause.

That's what we do in the previous patch.

The problem is that rx_pause and tx_pause are resolved based on our
advertisement and the link partner's advertisement. However, the link
partner may not support pause frames at all. In that case, we will get
rx_pause and tx_pause as false. However, we still want to enable rx_pause,
because we know that the phy will be emitting pause frames. And of course
the user can always force disable pause frames anyway through ethtool.

--Sean
