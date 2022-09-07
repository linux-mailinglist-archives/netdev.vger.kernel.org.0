Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826C35B0DD0
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIGULZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIGULX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:11:23 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF36D9CC;
        Wed,  7 Sep 2022 13:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmGM6CL7HEzvF7+QU4ws7kpoKy9U0wt3Rxw2Hm8vXAgUAuYNtXZSFHdLBf1x6dHO9JKzkYRphVlZ6kVIxquE0ZMQKdOk54aSm2jjFhF7XPgAtaI/zaaJUr6XkbzSWKiGO7Forx3aHeebfGsB6xpyvHXOV3iur5Ago0ZjnzQg/edm6qu2VvWN4+G7SnlUnXYD4PPFKANUuOiq3oA09DNgNa5BSSEJ3wNTOWTaNCi61NmdiGu53cjI3wIX23f5v2PdFaniWiQljnaYb90RiZABoIvE9MoEqKbJhWTnnpEZ+RZeVWj25HA3V4mAEVAaNGIroy5OGNfza3qKZJuYCaFhJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jkNuJCv2YNHSFDPxd6cQ1m+QghAhEjep4PDkPqbTG0=;
 b=CnC16ZSljUx7QbjzLZynEhWeDl63ZbNihrqAP8jBvMBXBXl02BYhTl7kd+XkufSnW46Tr+gl1HrrpTVLhNSWyOk88Vn4y9OBnWSDlhOyauTJAqIray7fQvbfNQoRUHj8fFQC5k9B1a5facmdhqE3DyFlsm2wloUygJg7SntPFu2ePTpOh0ElRl5bb3HAEyPbIsRu54Nf4Ev9mxGdhgbcv13osev5AqlSpStLanom8kLckD+sJpjbTl+lT39wYfqFfnB27hXfWXntF4uNQXcaaPMIAQkVX/EBRsCGof4XX41ZV4qst3ZsH421wWoiBgsqlRqRSAbTIsYHd8LQ3M9TAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jkNuJCv2YNHSFDPxd6cQ1m+QghAhEjep4PDkPqbTG0=;
 b=ZxI0jaSazPPrFV30G3ftBC2OS5nhi7e7yVhvdMenvad1fTKeDTwZqH9HMHKed1XhKs5JRl09/XuiMY7LEnGTj7DdlyVYliKWvFuS1EpbY8KJzfZ8lHdIAz25aPGx6N4Wnh+k2+Ve2H6oDbsVzmggDqJpmCuvswqulUigdD7O5BlOzy51UF7XyqK/vB0QSFMA+Sh0MB5aptmHkHvsQ8fe0Td+NMazFKiIfwzpL/dlfq547ERb/mSYuuskaeLVR/SY6G42Jrsm11r+onw7m/eapcOiDj9Vcgp9BmSNSiiSbtRp7xUhD7k8sf3mUMa6E+3XOAqL0Kip84T3I+VLYA9Yyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GV2PR03MB8581.eurprd03.prod.outlook.com (2603:10a6:150:ad::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 20:11:18 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 20:11:18 +0000
Subject: Re: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
 <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
 <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <745dfe6a-8731-02cc-512a-b46ece9169ed@seco.com>
Date:   Wed, 7 Sep 2022 16:11:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0006.prod.exchangelabs.com
 (2603:10b6:207:18::19) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ccbb198-81ad-4188-9ec3-08da910d1fae
X-MS-TrafficTypeDiagnostic: GV2PR03MB8581:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OoRprQeeop3fPR5VhamdEic+s93CwQ5qslcj0JGDmfB3h18aQekYiJyqKYzviZOknI/3OaIxh/lTYvusMGPIF8rZTTt6kMDmzH6FDtVY9syEQmICKrkBRWz3Ux/RwBL5WW+xV1OJ4/NnMwut6p3IeQoMggp9ey27k17c/zidIia2HfwfTpfvoQyhwmd0pdR6+s9Grcgu4x+a1lq6FUtr+EqFcT6d0KjIgLG/24Vl4NI2LEIGpKaMSyhIq57NY3rdy46XUXczmkSZ6H5ZJFkVi1yVxagS1N2a1b/AhEsP8K2t3d8GqQe+BpgadU0o8P1+vBkbgLBBqnUxvLJZlpeaib5q7EL899JYjUe1SqZwD0daaee68RIMgCrJkJ7p+HwQvwc1sicJSZt7/SD+CZHFvC9pOGl3vdFEFwl6MogUtclnnAVSqlgZ7n0MocaqMyGMG06BjNGTnvzMLwXcz3CVVdbOP7kBkj532I8XxRKpw6imWevCjN+zRAnspe1ipynMjrSFmRpJJikaO3XVoYU09Q+hrB0HMfSUyWGHT2jrxtr7i13VyJgD6nLs7+j8QR1F2hKnqJc0PeNn4p2Pgdbxve3rEgG6iZeC78ubgzPYT8xZ8KWgBfdQLjwbj0qN06iWlO30hYZkigLP/JaJ25wx/pCdBm02Y3PZvGklbReHxMEz8DB1fvgpq1Dud5ZZluY0zN1n6rudwjAj8m3qwLXEqhuN49HhZ1U2kDYeHV8JLdRpEVTV8YPFSPPFn/TMjcXP/rHiCzVALeGNoH31eg462VmNMrNnx03h+tYbDupLdj9dDQoIJI3BOp0MxYXU2uOn75ti9/1lxpowVQ3u3RE8ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(366004)(396003)(39850400004)(5660300002)(83380400001)(54906003)(316002)(86362001)(6916009)(2616005)(41300700001)(6486002)(38100700002)(8936002)(186003)(38350700002)(44832011)(4326008)(8676002)(66556008)(31686004)(66946007)(31696002)(478600001)(7416002)(2906002)(66476007)(6666004)(26005)(6512007)(53546011)(6506007)(36756003)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWo4bnNWbk9GU3E3RHIwZEI3emtxS3J0VDdoZkNzZnFKeTNoOFVOVGhLc2Np?=
 =?utf-8?B?VS9PRzQ5WFR4UXVYdmhPc0pmalpSZWx2QXhzOFo5WEdVWFl6djVGbSsyZUNN?=
 =?utf-8?B?TmxaZytua1N2Mzc1VXVTa3hOdzloTnZpMWtjUGRQaEMxTm1zN0g5bjFtWkVC?=
 =?utf-8?B?aGg5bGJtVWhsYVVPRjExTG9NZGJWd1dVNzAzUEQ0Nmd6ekFkZlBPODJUVWcw?=
 =?utf-8?B?anNuTFlGWFhzbTFvRnVvdUk2RWJOcGZCRUEwMk53ZU9YN0NOV1dVMnFKLytN?=
 =?utf-8?B?V0FMS2pRQnN5NWlwbnAyZTRUUnZleXJaN01XMFpQOGN0cE1zZjBtbW1NaXQ0?=
 =?utf-8?B?UzZFRnpjcU93S0txaVFXaHhJWW1MT1FYS1E0TG5PK1JEQ2F6OTlxS3R0dFJx?=
 =?utf-8?B?bnJRQ3JMSGJYNDRxUnZqWFEvRG1Ka3dMcmlRQWRBdGYycERRL2VTNVhmeTlC?=
 =?utf-8?B?TnJkMFc5VkhOejhWZmdsdmtsRCszTlo3M2FGdmQzMlV4dlJLYzZrK2tYK0FG?=
 =?utf-8?B?R2lJYmREMjVwM0lPWU5UeW9jd09uMGVXVVgvUUFPd202ZlROQjc0eTVnSkdP?=
 =?utf-8?B?VnZBcUNCclAzQlNXbWsvN2RvZ2xFc2V3WEpnMTY3dXRPU2YwMEpYTW1TUC9h?=
 =?utf-8?B?NVcwMnZ1aDZKK0V0L2RSM1NHbzZaRW5xN0ZLQmZhb3RYUDFRcXdWMVJ0akE4?=
 =?utf-8?B?bk8xSFlabWgwdlJ2Vlp5RHRLZmJramg2M243RWRlWXUzVEJFY0xjdlpVVElW?=
 =?utf-8?B?YW0yZG96SWkrZGdDeVZYWUV3aUVFdUltcVdteTkwczRqdXV6ZC9EVGxVclNk?=
 =?utf-8?B?L2EzNUJJenQrM1l3NWVybmZMVmk3cjVsTm9vOFhVWldsY1ZOYUMyanFwRDNH?=
 =?utf-8?B?cDE5dTJ0bExtV2h3VjNLUmlvK2NyM0o4UDQ5UEtTRGxrQURSWWMzNEtBa0JN?=
 =?utf-8?B?Q04rclpGSTRoZmNsOWtlWHNEcFR0bEdQUW41RGNJMjdFbm9URDFQQzVFenNw?=
 =?utf-8?B?cHBGdDFGOEpBNGtmVFBwaWVBeTZmZE1xMmtYL1JHam55MmlJNWV6MkVmdmNn?=
 =?utf-8?B?WHBsWjVRU1JzbDRjTmp1V2ZtS09meDJDZnZMYVJWNk0rMXl1T1Uya2Y0VEV4?=
 =?utf-8?B?T0x5Z1l0WW9FMjgyUFlqWHpFQTltcHFWditBM3FFU1Z6TXAwOGZtaTNJSE4y?=
 =?utf-8?B?d2xDZzBiV3k2ZFJua0ZQV2pVbmpIWHN3S1RycFE1Zi9mM05PS0xzUjlaTkc5?=
 =?utf-8?B?MDZ6amJlTlVEcGJOUnkvd3RVVHdiWGxtaXVVMUhvUFZYWnY2cmRnUGJUSlNJ?=
 =?utf-8?B?bXZpSDY0YjFNeUI4c1d4K2JyanVBMEx4QmNOakl5MXFvM3gxMHJMQ3BnQXZD?=
 =?utf-8?B?WnUxZXQzVzdiODJoNXVweDYyQTFxYkFXNnU5bzYwa3pjRjhQeFh1eUpoZHho?=
 =?utf-8?B?UURJSVBwakI2dmNmd3JqcXh4ZWZ5UDFxQmZFbk5LMzlnM1FtRUo2WDdlbXZV?=
 =?utf-8?B?dWkzWlFVNzZsOStlcHRtVThJZEFBV2dBcXZkbWNSWkwzZzZrS1F2TnBsNjQz?=
 =?utf-8?B?ZlFuT3pOTFBmcVB4QVFNU1RCWjQ2SVlnNUJrMUtXbjhQakE1cm53TWpHME1Y?=
 =?utf-8?B?cXJ2cUxWYzVlL1gxeHJ5dThENlloQnY3ekovUXVqK2s5UjJnUEk2OEorRXpU?=
 =?utf-8?B?NVJmQmZMN0xnNzBDeUdVVjl2K1plenJFNWZqWjRQdjBPdVlLTS9KcGlwVTRX?=
 =?utf-8?B?RG1qd3ZSZVA5clFPZnBuZkd3aGxPUjlGTnp1a29jNFVQUVByQysxNy9xTWQx?=
 =?utf-8?B?Y1VqUTZBU1lvY3l5UlViZ2h0S0lHUWRWTWIwekg4YS9QTWhwb1pnKzVLc09z?=
 =?utf-8?B?endFejlLZEh5VGgvTStUQUJPNDlLQzkvT3lxQ2RPMzRwZkVSL1pNWEo0L0U0?=
 =?utf-8?B?RFpMZm9XTmFCcm5rVFNCQ0cxUjIvWndGUWNCM21BcTdTU21NUDRKUnNmY3Ux?=
 =?utf-8?B?bmd5SWM4NEROMUhKM2x6bjNRTzAyUitQRWRORTYyTDBmVlNsem5ZSjdlczVN?=
 =?utf-8?B?VXQyV09lanhtZWJhOXhGdFFRc3VKUWdMSHIvTkVERjJYOXNTZ25xNG50SzR4?=
 =?utf-8?Q?CZuLplgCAe33sZFCBqmuJPMLa?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ccbb198-81ad-4188-9ec3-08da910d1fae
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 20:11:18.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSmTkn7G3kvC3L2rVzhzHFRNJjAX3ZtUDmFn41pthL4/4bRwWX4wWutuVIxtkqXo2J0yfO+L1Dp7bCxRWI/4/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8581
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 2:04 PM, Russell King (Oracle) wrote:
> On Wed, Sep 07, 2022 at 12:52:59PM -0400, Sean Anderson wrote:
>> On 9/7/22 5:38 AM, Russell King (Oracle) wrote:
>>> On Tue, Sep 06, 2022 at 12:18:45PM -0400, Sean Anderson wrote:
>>>> This documents the possible MLO_PAUSE_* settings which can result from
>>>> different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
>>>> direct consequence of IEEE 802.3 Table 28B-2.
>>>>
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> ---
>>>>
>>>> (no changes since v3)
>>>>
>>>> Changes in v3:
>>>> - New
>>>>
>>>>    include/linux/phylink.h | 16 ++++++++++++++++
>>>>    1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
>>>> index 6d06896fc20d..a431a0b0d217 100644
>>>> --- a/include/linux/phylink.h
>>>> +++ b/include/linux/phylink.h
>>>> @@ -21,6 +21,22 @@ enum {
>>>>    	MLO_AN_FIXED,	/* Fixed-link mode */
>>>>    	MLO_AN_INBAND,	/* In-band protocol */
>>>> +	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
>>>> +	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE 802.3
>>>
>>> "used in our autonegotiation advertisement" would be more clear.
>>
>> What else would it be (besides advertisement)? Regarding "our", these bits are
>> also set based on the link partner pause settings (e.g. by phylink_decode_c37_word).
> 
> No they aren't - MAC_(SYM|ASYM)_PAUSE are only the local side.
> phylink_decode_c37_word() makes no use of these enums - it uses the
> advertisement masks and decodes them to booleans, which are then used
> to set MLO_PAUSE_TX and MLO_PAUSE_RX.

Sorry, I mistakenly conflated the two while reviewing things, but see below.

> What I'm getting at is the comment is ambiguous.
> 
> MAC_(SYM|ASYM)_PAUSE are used to determine the values of PAUSE and
> ASM_DIR bits in our local advertisement to the remote end.

I agree that this sentence is confusing. A more precise version of it might be

> MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our autonegotiation
> advertisement. They correspond to the PAUSE and ASM_DIR bits defined by 802.3,
> respectively.

My intention here is to clarify the relationship between the terminology. Your
proposed modification has "our autonegotiation advertisement" apply to PAUSE/ASM_DIR
instead of MAC_*_PAUSE, which is also confusing, since those bits can apply to either
party's advertisement.

>>>> +	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
>>>> +	 * ============= ============== ==============================
>>>> +	 *             0              0 MLO_PAUSE_NONE
>>>> +	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
>>>> +	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
>>>> +	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
>>>> +	 *                              MLO_PAUSE_RX
>>>
>>> Any of none, tx, txrx and rx can occur with both bits set in the last
>>> case, the tx-only case will be due to user configuration.
>>
>> What flow did you have in mind? According to the comment on linkmode_set_pause,
>> if ethtool requests tx-only, we will use MAC_ASYM_PAUSE for the advertising,
>> which is the second row above.
> 
> I think you're missing some points on the ethtool interface. Let me
> go through it:
> 
> First, let's go through the man page:
> 
>             autoneg on|off
>                    Specifies whether pause autonegotiation should be enabled.
> 
>             rx on|off
>                    Specifies whether RX pause should be enabled.
> 
>             tx on|off
>                    Specifies whether TX pause should be enabled.
> 
> This is way too vague and doesn't convey very much inforamtion about
> the function of these options. One can rightfully claim that it is
> actually wrong and misleading, especially the first option, because
> there is no way to control whether "pause autonegotiation should be
> enabled." Either autonegotiation with the link partner is enabled
> or it isn't.
>   
> Thankfully, the documentation of the field in struct
> ethtool_pauseparam documents this more fully:
> 
>   * If @autoneg is non-zero, the MAC is configured to send and/or
>   * receive pause frames according to the result of autonegotiation.
>   * Otherwise, it is configured directly based on the @rx_pause and
>   * @tx_pause flags.
> 
> So, autoneg controls whether the result of autonegotiation is used, or
> we override the result of autonegotiation with the specified transmit
> and receive settings.
> 
> The next issue with the man page is that it doesn't specify that tx
> and rx control the advertisement of pause modes - and it doesn't
> specify how. Again, the documentation of struct ethtool_pauseparam
> helps somewhat:
> 
>   * If the link is autonegotiated, drivers should use
>   * mii_advertise_flowctrl() or similar code to set the advertised
>   * pause frame capabilities based on the @rx_pause and @tx_pause flags,
>   * even if @autoneg is zero.  They should also allow the advertised
>   * pause frame capabilities to be controlled directly through the
>   * advertising field of &struct ethtool_cmd.
> 
> So:
> 
> 1. in the case of autoneg=0:
> 1a. local end's enablement of tx and rx pause frames depends solely
>      on the capabilities of the network adapter and the tx and rx
>      parameters, ignoring the results of any autonegotiation
>      resolution.
> 1b. the behaviour in mii_advertise_flowctrl() or similar code shall
>      be used to derive the advertisement, which results in the
>      tx=1 rx=0 case advertising ASYM_DIR only which does not tie up
>      with what we actually end up configuring on the local end.
> 
> 2. in the case of autoneg=1, the tx and rx parameters are used to
>     derive the advertisement as in 1b and the results of
>     autonegotiation resolution are used.
> 
> The full behaviour of mii_advertise_flowctrl() is:
> 
> ethtool  local advertisement	possible autoneg resolutions
>   rx  tx  Pause AsymDir
>   0   0   0     0		!tx !rx
>   1   0   1     1		!tx !rx, !tx rx, tx rx
>   0   1   0     1		!tx !rx, tx !rx
>   1   1   1     0		!tx !rx, tx rx
> 
> but as I say, the "possible autoneg resolutions" and table 28B-3
> is utterly meaningless when ethtool specifies "autoneg off" for
> the pause settings.
> 
> So, "ethtool -A autoneg off tx on rx off" will result in an
> advertisement with PAUSE=0 ASYM_DIR=1 and we force the local side
> to enable transmit pause and disabel receive pause no matter what
> the remote side's advertisement is.
> 
> I hope this clears the point up.

My intent here is to provide some help for driver authors when they
need to fill in their mac capabilities. The driver author probably
knows things like "My device supports MLO_PAUSE_TX and MLO_PAUSE_TXRX
but not MLO_PAUSE_RX." They have to translate that into the correct
values for MAC_*_PAUSE. When the user starts messing with this process,
it's no longer the driver author's problem whether the result is sane
or not.

How about

> The following table lists the values of tx_pause and rx_pause which
> might be requested in mac_link_up depending on the results of> autonegotiation (when MLO_PAUSE_AN is set):>
> MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
> ============= ============== ======== ========
>             0              0        0        0
>             0              1        0        0>                                     1        0
>             1              0        0        0
>                                     1        1>             1              1        0        0
>                                     0        1
>                                     1        1
>
> When MLO_PAUSE_AN is not set, any combination of tx_pause and> rx_pause may be requested. This depends on user configuration,
> without regard to the values of MAC_SYM_PAUSE and MAC_ASYM_PAUSE.

Perhaps there should be a note either here or in mac_link_up documenting
what to do if e.g. the user requests just MLO_PAUSE_TX but only symmetric
pause is supported. In mvneta_mac_link_up we enable symmetric pause if
either tx_pause or rx_pause is requested.

--Sean
