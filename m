Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932275771AD
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 23:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiGPVzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 17:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiGPVzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 17:55:50 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10085.outbound.protection.outlook.com [40.107.1.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C501186E5;
        Sat, 16 Jul 2022 14:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIfoq5xBqCfOAw12U6gx0m3RmKQ+9daEkfug43uFNoctBNcjdHHfNikD9eL1vWcWkrtyaTmE4N10o5FY8H0UaMe4tQ3Qxuy6wpP9i4SSp7SqI2XnIImymQvoQmn69/Gex2kKQNF3mzLcUZl6uMdA03IvN+WkXErTg/I+tYAovTQQeJChCdHgpcuY2OPxSK/dnZ05A829ZyYbNW4Le9VPEtsVhVRc/34gXmU1YIzWxShJIaY+cf0+uq9nIRyKUffzP6GXtuC2CQu5mM0sFH0ptPryrZ3x3vJtxkchJpRkBQTqANEvwx8oY9x8E+N1jprBpwwSBC70JcDMw4pk0r7iCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gf9sTiBBl03tmjYXQ9kZYFliPpw1KIhk8z7LgJVWGx8=;
 b=ArbBNHd1tD7vfp+GWq0O8QnFCeTbazo40R0V/t4P4CSk/SUQpCEyZY05dXX9PHR9QDoqfiwLlCStXwATnefed27dmnBKcNc3U4LEZtZkutWBba0IDYNj+IFu1CQkHEFk42fwnXF+3qwuRY5ItT1yqHK85IMZZVMtXNd3ZzEKai6c8BlgG17jbHt4mo9/hk8PgZ7igqC+FwPU1MtNkfb8vPPGVppW8YGZDBb/xBcHuNQqoceoY3kfP0zQp02+AaGyKOM5ZUkB8Ot8d8wYIWqjYICxdYiLJrvdzJ84aR7k/dZmb6IW7xBgerz5oyrftCw9Eo7uSRaWMh9Rq13/Odcrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gf9sTiBBl03tmjYXQ9kZYFliPpw1KIhk8z7LgJVWGx8=;
 b=aG4HcRQG41oUgHTYmV8Tp2VRq1x+vGeADe5K3cNQVvF53x427VCQoec76wK0MaPhdlFiJ57xbUgeXQw5j6RKiVjx+0kcsDCCb4zLLQvNsULgKmTrEwosZ3GmvVtiEpqvP+W7lcpl9H0D5gCBZMWpbVRiSycIjtbCc9BKaEQYt54A+dVQCq8HtRGbfpjotv2oJeYx+LVB/e4pzOj+BmVJuXHL4hVDCKgoPbKf5YfMiebMgHRVW16wppkXoTbOrGIPPCYc3mxWoGf/Xl7SP5UK0f3nvvu9W7jru8bohURIsN0VWTo0bO0BOAfpR14+qZzzNxUf49Nqk7ydqv4by6jHbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AM6PR03MB4904.eurprd03.prod.outlook.com (2603:10a6:20b:8b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Sat, 16 Jul
 2022 21:55:45 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.021; Sat, 16 Jul 2022
 21:55:44 +0000
Subject: Re: [PATCH net-next v3 07/47] net: phy: Add support for rate
 adaptation
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
 <20220715215954.1449214-8-sean.anderson@seco.com> <YtMT8V4PNkxJ9lMm@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <6f8e17cb-3f6b-9e89-51a4-9452d562204b@seco.com>
Date:   Sat, 16 Jul 2022 17:55:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YtMT8V4PNkxJ9lMm@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4181b89d-67d6-4a99-b6c3-08da6775eed7
X-MS-TrafficTypeDiagnostic: AM6PR03MB4904:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQL6H6LXkh6Vpf49HWtVrnPg0HUGO2z2fsjYzxJRO11PAVrE8vL2NwYdK3ij1tJTb52MrJdb2n5r52Pu67vfkcnyMaaMxPmSJe4O69DzElET5WipcDmqJEdqtiGt9h4zHJQCnQfZAKn223ybJR0JKg08coEKgKqLZQuRlJBkzjJlVlbaEmtxM9KV1VIH5RMTZvoEclaqAkonLSbMQWpd2Y8cBfuuBbgjcmyKbiupENIfvFDKBkhPP5ZeYlQieZeq7SgJpmuZaOrqCaQ5MK3mfQk4RUrSsW9B7T9iv+bH6DzfwNW0U8hytISDgLaHmaWRKlGhAdT2Pcxxjs7mL43h7kpCqW6Cd41SgXrdb+Cg07riRdLdFVD2vMCFg8BwqNtG7Uv1Jp1NinsWKz6OfkkHYOInuawa0B7Ko5VpJAKwb427KqnR8a3ZGfuuXn5xfEnylnGbcb6pZSdNx9sM39AhPaDKxiRkV3d4vRrlCgup2SSUDDtnF+0HZ3EH5ndPbutDAp4+JkYhsveXgAB99aETSY4+UIqG5vaPiN/Tnk7dFa9TczUjFKg4VVLdfY75346UZioTdkKyW8hWfypxjTSKyJ9i7DywfDsXFTqUUeGQAZUiAkyHD6WugvRt2zRQr5NNEFkfb0RyqRBX3yAiW1xDp0mXKExwGG8wKCZLigr0+bwxx1+1LpYyXR7b8dfJRyn1MsymlJYFpRy0qbZ/8pnBE6nEgnzHgn1DMN6/7sIBZ2gMxZhZ6vTLJ7EDIjAg3iXtOZvulGSGdNDOzom7TosfHCcPVCi5cfXUMhm+Tr7aZyZe8EAu0AKSx7ubDFwpTSWCovqsD653296UPtsMzL6srf/d1pMpJMAJ3a7X4O4RRYr+Y/EfN/0M4Arn37gOgz/z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39840400004)(136003)(396003)(366004)(346002)(53546011)(2616005)(8676002)(6506007)(31686004)(66946007)(52116002)(86362001)(66476007)(4326008)(186003)(7416002)(5660300002)(38350700002)(8936002)(316002)(6512007)(38100700002)(36756003)(26005)(66556008)(6666004)(54906003)(41300700001)(478600001)(2906002)(44832011)(83380400001)(31696002)(6916009)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXZvemNhQ3VxY2xKa21id0VJQjJLWENyQmIzRk1MSFgxUk9PcWQramJhTStv?=
 =?utf-8?B?dXdLRWpGOHNkd1NhR3JOWXZSOExLSWF4UGVaWUhYbkJZSUxWc0RVYWtlOUpM?=
 =?utf-8?B?aTZqTDl2bmJkRlI0NmhkZHFBTWZqUEN0enA4THJ3aDl2blQvMDRacTJrWXFP?=
 =?utf-8?B?T2g5M2pMZ1EyUW81Z0xuRGVSVjdHbGNwc1g3NTAwanpaQ2tPV3VoT1RmR2tE?=
 =?utf-8?B?VUJoOXlVZjVKTURxN3RwZUk3MG1KbXBMc2ZsOG1vQkh0Z01TcXQ5ZjVDNndo?=
 =?utf-8?B?cXRiYmIvZ3lHYWNRcmVnMGM2MkdsQnlUUHp3cmFTaDY4OE5tWTBRcUhqWGFV?=
 =?utf-8?B?MDNxR3RpcmQ5dExwbHpDYTFEcnl3S0NHdFpRQjdicnJZSUJ1a2RLQzNadU51?=
 =?utf-8?B?a2M4RlRRM0w1aGFTd1NjUUxWY3Zkd3NVa2NMYW1HWG1XN1JmQXFIZjJrN29D?=
 =?utf-8?B?dHZCRGdCSzBPelZRZEJCei8xaUJWZDRqeXdlanowdEhCQ0xMQkZ0L3FJV0tV?=
 =?utf-8?B?SnVKdkU2OWYvTjJWSnA2REtaOUo0VzVqZGJDbVVuTEFuNWovMDlQeWFmVmZk?=
 =?utf-8?B?M1Z3VnpuM21Fck5acFBKdXJMa0Y3cVlCbUNVOXdtQmc1VUtsQ254Q3BDQTls?=
 =?utf-8?B?UFIzS25iOXM5R2oyUXd2YnlFeWV6ZkYrSlZwTGdoL25Tc05rNHlKZjNJODVj?=
 =?utf-8?B?UDlZV2plTk9iOFRtNFJUaUIrcDhValNCOUd2YlhKOGFLU2hETC9LMHlVYktT?=
 =?utf-8?B?WVMrZTZKMWEvQWhFSGlsTm1pRUczdWVMczg0aC9IMXZUc0x6MjRqOGxFMFd4?=
 =?utf-8?B?MGlDbk5UaHdHS3hVSmRIRlVLSHZWQ2RQMmRZbWdlTlVNNGt3NTdRWEFGZnpt?=
 =?utf-8?B?YTUrb1g0RHgrNXdVVWN5SnBLMW81VzZlMzNkWk1NNnZsOC9HaUx2MlcyZHdE?=
 =?utf-8?B?ZTIrRjAyaXRRTkd3QlZNdTdjOWNDQnRmUkU0M3R0RXphdEZTYVpiVVdWYmpn?=
 =?utf-8?B?SWlJR1cybnJqN0d6RTAxa1RWZURkN2lEYWxLeHVJNUlTRXZodmk2aUZGZmFP?=
 =?utf-8?B?VU1EWnNSZGRxS1dBMkk2L3ZPWHY0R3Y1dlRreXVKNVZPSGMvbHoxaXFwejNi?=
 =?utf-8?B?ZUtrbFNLQTB3RUdGTHJoQitJTDdDekFvQUNFMnpqY0ZWcnpoZjZmT0NyY0dl?=
 =?utf-8?B?eDYwOVFVUXo2U254b0U1K2JQNGJrTWYrcGl2bFhrLzdhUHRrcFZnQU9HTHpl?=
 =?utf-8?B?cmRuaHg1ekF2Wm9ZREoycUZ3QjlQaDUrWWp1ZTBVUnVXelFyTVpiTjJaWUN6?=
 =?utf-8?B?cDc5Y0R3V0RRNUR5MWVuMkF2ZGlHTUx4NlRFVVNxOVZxZW1XU2V5REphQVhh?=
 =?utf-8?B?VTdjOGNjc2EvbHNtV1c2M2lMOU1mZFRWTnhlbmZyQ2JuRjJvT3JGQ0tDa3RP?=
 =?utf-8?B?QWtsK3B1d2tGVjEra2d5anVXd1VGRDhtS1d5U0x1ckJCREpBTlN6YXlSbFN3?=
 =?utf-8?B?M2pKZ2g1anB4UUorUUNoaXA5ZmNZNWYrUWV0NkE4NEJSSVcwcTluMUEvenF0?=
 =?utf-8?B?WmVXWERZeVlXWnRBTkxBNGFGUWR5eVJoQ3JwUGZ2c0xUa0o5cGdYZFhOQzRT?=
 =?utf-8?B?L2VINS83cjk1cXhpWGtSTFhuaDY4ZHVzbVVzcHJJWHNDTHdpZkR4K3A1Q0RP?=
 =?utf-8?B?OVh0cDVVaXhNWXZMamZNekZ5R3BpRnBnOUxOYjdYSkdNQXdSamNYY1RDTTZE?=
 =?utf-8?B?ZlE2M05uVUU5SW5Nd25DSzRsbnV5MGEzdDhpbzBrbStnR3ZjUEVyNC96WFdw?=
 =?utf-8?B?MkNYZXRlOXNnYm1yRm03TklTa2Z6eHdkWTFPblJyZG9SMVFrdlJ5NStDcVp1?=
 =?utf-8?B?ejRQalI1bDBHcm9ycDduUmI1ZWFhMVZkMHpDM0JTNVBHRVJmWmlBOG5NRHkw?=
 =?utf-8?B?cjgzWlJnMHU5NEJZNWM1d3l6RDk5RXI2QU8yQ0svdXkzQlQ0OW1LVkhTSGZs?=
 =?utf-8?B?QXZweEpIVWZUL1BvY3BYRUlBWkpPbDllQm5MRkV2T3FjVVdxeEtXREE3YXND?=
 =?utf-8?B?eisrRE1aNDVZcGVVVGttMXIwd1dsbjZrdmdiVFYrMmh6Smh1UnU0ckhIZ1lq?=
 =?utf-8?B?WVo3SzEvTFBFZng4Z05OZkZkeis5c3UxQnBqeXVVYjhTaUJhdXE5K0s4T0Zp?=
 =?utf-8?B?RkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4181b89d-67d6-4a99-b6c3-08da6775eed7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 21:55:44.6514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJ8mhDINu12Hi8ESkWVVZCwPFMidsic/PHY6OZHxYjimwGd5djduqUh5QLsYNdPABkMI+4eXfwJxVCsjOxeKaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4904
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/22 3:39 PM, Andrew Lunn wrote:
>>   drivers/net/phy/phy.c | 21 +++++++++++++++++++++
>>   include/linux/phy.h   | 38 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 59 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index 8d3ee3a6495b..cf4a8b055a42 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -114,6 +114,27 @@ void phy_print_status(struct phy_device *phydev)
>>   }
>>   EXPORT_SYMBOL(phy_print_status);
>>   
>> +/**
>> + * phy_get_rate_adaptation - determine if rate adaptation is supported
>> + * @phydev: The phy device to return rate adaptation for
>> + * @iface: The interface mode to use
>> + *
>> + * This determines the type of rate adaptation (if any) that @phy supports
>> + * using @iface. @iface may be %PHY_INTERFACE_MODE_NA to determine if any
>> + * interface supports rate adaptation.
>> + *
>> + * Return: The type of rate adaptation @phy supports for @iface, or
>> + *         %RATE_ADAPT_NONE.
>> + */
>> +enum rate_adaptation phy_get_rate_adaptation(struct phy_device *phydev,
>> +					     phy_interface_t iface)
>> +{
>> +	if (phydev->drv->get_rate_adaptation)
>> +		return phydev->drv->get_rate_adaptation(phydev, iface);
> 
> It is normal that any call into the driver is performed with the
> phydev->lock held.

Ah, so like phy_ethtool_get_strings.

>>   #define PHY_INIT_TIMEOUT	100000
>>   #define PHY_FORCE_TIMEOUT	10
>> @@ -570,6 +588,7 @@ struct macsec_ops;
>>    * @lp_advertising: Current link partner advertised linkmodes
>>    * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
>>    * @autoneg: Flag autoneg being used
>> + * @rate_adaptation: Current rate adaptation mode
>>    * @link: Current link state
>>    * @autoneg_complete: Flag auto negotiation of the link has completed
>>    * @mdix: Current crossover
>> @@ -637,6 +656,8 @@ struct phy_device {
>>   	unsigned irq_suspended:1;
>>   	unsigned irq_rerun:1;
>>   
>> +	enum rate_adaptation rate_adaptation;
> 
> It is not clear what the locking is on this member. Is it only safe to
> access it during the adjust_link callback, when it is guaranteed that
> the phydev->lock is held, so the value is consistent? Or is the MAC
> allowed to access this at other times?

The former. My intention is that this has the same access as link/interface/speed/duplex.

--Sean
