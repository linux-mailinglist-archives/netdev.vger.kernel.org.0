Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7842C6DAF9D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjDGPYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjDGPYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:24:12 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2085.outbound.protection.outlook.com [40.107.14.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DEB213B;
        Fri,  7 Apr 2023 08:24:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QInS3LNJvSpnhLxn/Jxdc79ZFStfIA36XTqBq7lbTrryXOk2bPmQHfnZvnWfv3q086yMCFUx8a0jRc8v07xJH5ilc6FjvrYjdf0cV8iowQTPCUTp1x8//MZgwrAvtxA6ocjF4D11XX67a7UFrTYnOlTYil6dHMAYVIExDYe5z5OWjd78VLySd8Ws73alRbrqcSMfDj0W3WvMwElqCVFDMIwWZB76XZsnBvRuOcUIHoida+w1wG+bWVsdNnMKakQfidTz0xKzeCEAxryiLvOMqxfe5sEh3o5Xu+xCm/lu04V1mw4r93v6jnanoKanRX4z+EheseeVPQnlWdjRmmJiHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpjbS5ntKmvcjGPYHRMkifxM8WFRnqGYQnzOSDadjoI=;
 b=lr0sazBS/dYyPHtkr3xz/AKZSAUgfz95WsBsZxW0q4WHYypvs3hzr8MEWiXRsGYD4lvuvDskrknAEdhVP+EtYHuczTUxH+z0Jny55D7O/JMxR37+rLshFlJ0KiIDZM0b8JPdmQKw8Foskv79k/JUzUiqkGw/V3vl1TUsDNPYWo+N9RKhG45ea65wiRHquXofoYHceQgKORtw3H1OIq3jOFZb13i+Pumk+JugXbKSmupRP7PM6s/wIWf5a/o7gWFizzLQ7OzPsDkvJtd6+ZRJ0L+vnldiLeaJHp10Kldq64dg8uo94YvoTgFT+mEEPNp4nepyWR7zXC9BII9lmNDdVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpjbS5ntKmvcjGPYHRMkifxM8WFRnqGYQnzOSDadjoI=;
 b=EibV/ZGDz1x6Chi0vdFTQz6g1bmja5NOL0FtcUOlbvkC55SHvnckUEA2wBcf8bWIBPsCNYpkSIeZTm6dxgZCo55bGLFxTS4kpyKsayzYwpbZ0q9WrFMmvrM+uQDIupXPX7uOjvUmGBKT4urErhszbcpGlpm1Zu+8LqyhlQ7IUBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8194.eurprd04.prod.outlook.com (2603:10a6:20b:3e6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 15:24:07 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%7]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 15:24:07 +0000
Message-ID: <5ec588cf-f4f9-5329-730e-ba5bc6d2bdff@oss.nxp.com>
Date:   Fri, 7 Apr 2023 18:24:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: disable port and global
 interrupts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230406095546.74351-1-radu-nicolae.pirea@oss.nxp.com>
 <47d0347d-02a1-48a3-8553-d6ab2be731e8@lunn.ch>
Content-Language: en-US
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <47d0347d-02a1-48a3-8553-d6ab2be731e8@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0016.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::18) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AM9PR04MB8194:EE_
X-MS-Office365-Filtering-Correlation-Id: a2417179-c736-4c5b-d498-08db377c20f1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FdveF/0oicmG/8GJbUIsg8nXKBpgTgzHuRi+qtdVMVF5ZKlxe2CU/GNzsbqA/MvCTWtrcnUnBbhCpfzOqivy0UEEaMGPXJDycCAPggSe7LfxQANqdVrRv2qIfEuI75+Mf8UM+9aNMcDN9QmtgKck5B1JepygDDXh/8bqf8rjaadBNTqgu9vrpj+haI6HuBVdWMoOGaKDpMrO2n/OTeCXr6f8VuC3QYWN4md8K0VI7c+y/Q3lswzqHBLgCBotNGiU//18Xxc72ntrhrlvbEqVeVl7EsD6ObSlz498kJ2/C6L18wEefHcSdE3qcu/nkb+jFoz9uNdLzdAz8esm0Sr0cwZR3Mg0zhPvNCmSJQQlZkFv5gFR17SPKAQcqYHcFrLYO1yN5JxMHXQMotuyvk5eUFu7wOdTgy/25Xomozng3iJ5XUKrhpl4JlsY6vkEYAtMFC3T72ELyslz9VCErc4Krc35D3ltVqi/MZUWKIFR0niLYseVeHt7ZDxZZX6jCuuokcLXg5wuIfT6fg/cOgYJXaXQel3SMFo/gdhPRVvNe9HzLeki06GbEmmaOMeDYiOtAlZVHix/huOpH7Yw5KTSPGBS0dgtgcKUTU9bi5wr+YZV3oHcqg6xBEqn7yMkeNMfe5bh7Be20uJNjlCds9Yakg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199021)(38100700002)(31686004)(2616005)(316002)(31696002)(83380400001)(186003)(478600001)(86362001)(66946007)(66476007)(66556008)(8676002)(6916009)(4326008)(7416002)(26005)(53546011)(6506007)(6512007)(2906002)(6666004)(5660300002)(6486002)(8936002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXJaeGhCVnNLWFNvN0UySlRWbUdVcTBwYVVXM1VVaW9Fa3NiKzIvUm5wV0tu?=
 =?utf-8?B?clRjL1Q5Y1MxZWhMOHNPempVTTRnQ2tabE9XMHovNVIvZHBHaVZHUXRmYzZr?=
 =?utf-8?B?cFR1Lzd0Nmp5UXlGSExYTWVMcWc5OTl6QjBoN0ZoL2dCMTBwcUNYem04R24z?=
 =?utf-8?B?eG5BZWVrSlpxdkdxb0NzbHZaSnJCR28xbEovS1gvY3RicklnLzIxV1FaZUcr?=
 =?utf-8?B?ZGxZOUhLYmhMT2NhbXQ0TlVCZUJqeXp3d21zWHFWTjJkWTFlUU1pS0QrbDZQ?=
 =?utf-8?B?bFUwVFpQMVpqQVVodUd5RVQ2R3Z4SUI3bHJtS1ppS29XNG95elJFZGtXM2wr?=
 =?utf-8?B?dFo2WXdxcWw1RllQMUYrZjIwTmxRNC9LdXR4bEVwVVZTL1dab3NiVGo0Q0d3?=
 =?utf-8?B?V2tMU1l2dldFSXduMTJKL0wvaVJUWG5wSDU0dHJUV1ZFaWNadE5vTmpQM0NG?=
 =?utf-8?B?WnQ5bVlHazVUV2U3NUpuRGwvemlWb3MrL0lsRDNQS25ZMUNtL2JTZDV6ZkpX?=
 =?utf-8?B?cmY4SlNmdXU3aHQ0VU9sQ3ZZUmdTbXdNcHRKM2hyQlpqc0JEb0dCQ1dKVUVy?=
 =?utf-8?B?VUdpZDV6ODRXVUZ4QzNtK0NwZjdHUytJZ05scG0wS3V4aHUvL2pqaVB1bXlh?=
 =?utf-8?B?Skp0NEdpdzhINmh3cnhtT3FndnNsTzNCWTY4MlFPSXU1MWoyeVN5aVBDS04y?=
 =?utf-8?B?M1JSN3E1NmQ5YXlXUXJKc1djcTkvbC9ORnRJRnVUeDNlSzI2MktXMG9GaTBI?=
 =?utf-8?B?MndObUlaVWlUbHYybEpydWJDOWR5WUhwV2QyZW1UdlNFbjYwcUhkNmZPM2VT?=
 =?utf-8?B?UEh1Q3pUNE4zT0plWUZJL2hZbXdqNFp4dTA0Q09naXN3dHNBRlBqMXRuVlJC?=
 =?utf-8?B?UCs0Y0ZNUE1qVXZqV3FseGc5TFdDREZKckRzYVdtVmcrQUp3TlNzWU9uZWh6?=
 =?utf-8?B?eXl6Q05nUytMUVJHcjNoM0djb3JUSGR2SEdBOUZ1UUszcXBxRWZCTC91ZGhY?=
 =?utf-8?B?V1JvYVZ3UVM5YTc1ZzJucnEyc2U0WjIvYlUwOXpaZmczL0paN2dWT2hKSzhG?=
 =?utf-8?B?azZiOUU5NVltUVFBV2RVVk8vYVQ0Z3ZWcUhSYVBrbkxTQ085RFJobkdaSEc5?=
 =?utf-8?B?TlJiMG1mVzk5YVlBdTgzYVdDMHlUSXJrbFppWk1kc0tEajZyZFBVaGRNVkFh?=
 =?utf-8?B?TFZRNGZYcFF4cTRsbUxyMVp5bHMzejFGWVBPdWVvMjVJNW1yNEF0TG13TzQv?=
 =?utf-8?B?QnZnT0tkMlJoT2JqN21CNFNTNzNHZFlOZGN3bGhCMjRtaWdYWlRJaThTOEky?=
 =?utf-8?B?QnUxdWVXV05NcysxK1JLalVFZGJ3cWRwRmIyeDl6ZnNrL2d5Y2UrSFZuNHBp?=
 =?utf-8?B?TWsrSzZFTXJMaEl4T0hhZU9DZ0ZpbktzdFEzOTREaVhuTHFLVWlNK1NQcm5D?=
 =?utf-8?B?M1R5OWhKSnVrcWM1dEhLYWVMUS9CT25mLzU2RnBtb3hNcU5mVjhqQVNYYnRM?=
 =?utf-8?B?QUdVRU5Xc0VQZCtTblZudFMzbFppQjFHWmhqdndCWFlyT1pObG1kSG52QXF6?=
 =?utf-8?B?WVJVNFQzWWV3bzkrcllRaHNnMVpDcitOenpVVTNORXpEOUpMNEE0RGpmbkZr?=
 =?utf-8?B?OGc0SmY5Vjg3S2xzYU1hbHdnbUNNQW05akpMcVhHaVJhR1FWVGdaOWwzRzMz?=
 =?utf-8?B?TmhhSzdicGt1RE54akFHVURIdy9ZSEVnaWpNQzJ1NjlIQlRnNXJBUiszRnFD?=
 =?utf-8?B?YndmTWM3ZWcrS1M3aDZXTGhBL2d4aGcxbkg1V1Q4Wjg4bE5GMEE2VUpyWG1X?=
 =?utf-8?B?RFpBUmpNNHpqeVRkQjlSdkdaTHZCbGwrRFZiZjBBZ1laY3U3RFJndjF5enZa?=
 =?utf-8?B?U3RRaXJhT3VrUWJmVUpNR1BTamdYaUpsS2VpcVVRTHcrVWVwZ2cyWmxNeExw?=
 =?utf-8?B?b3o1dm9DdXZDNndRdmY3Y0hxWVRVd2pwU0dldnJOa2R0dDlnMlFRKzR2N3J4?=
 =?utf-8?B?VnRMUnFDaXVrM1IwMzRCMlRyd1QyZXEyRU84bzgyRXlxNnlFUnlXNzFnb2ZR?=
 =?utf-8?B?eEFla2tjSkdsREdxUSt2cUtQWFZ5U0RlR2s5dVZoTmtSM1kxVmU5MW1uNG9i?=
 =?utf-8?B?cjY5UFg1UDlIdU56Yjd0dEoybDg5NTJxSGJ4YXFIL3lSYnUyMHBtTTZ5Nmhp?=
 =?utf-8?B?TkE9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2417179-c736-4c5b-d498-08db377c20f1
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 15:24:07.3561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eExfiPXzXDa4bWlW3mTj3DJhNz16YfJHslHRDsiA3sJL4Q7JgWTt5KsP/llkExp5acJbPHgGQhSmfsgGaFrTWYchneFeUCSabYcvX6LDa/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8194
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.04.2023 17:14, Andrew Lunn wrote:
> On Thu, Apr 06, 2023 at 12:55:46PM +0300, Radu Pirea (OSS) wrote:
>> Disabling only the link event irq is not enough to disable the
>> interrupts. PTP will still be able to generate interrupts.
>>
>> The interrupts are organised in a tree on the C45 TJA11XX PHYs. To
>> completely disable the interrupts, they are disable from the top of the
>> interrupt tree.
>>
>> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
>> CC: stable@vger.kernel.org # 5.15+
>> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
>> ---
>>   drivers/net/phy/nxp-c45-tja11xx.c | 22 ++++++++++++++++------
>>   1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
>> index 029875a59ff8..ce718a5865a4 100644
>> --- a/drivers/net/phy/nxp-c45-tja11xx.c
>> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
>> @@ -31,6 +31,10 @@
>>   #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
>>   #define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
>>   
>> +#define VEND1_PORT_IRQ_ENABLES		0x0072
>> +#define PORT1_IRQ			BIT(1)
>> +#define GLOBAL_IRQ			BIT(0)
> 
> I find the PORT1 confusing there, it suggests there is a port0? What
> is port0? There is no other reference to numbered ports in the driver.
Sometimes HW engineers starts to count from 1 :)
TJA1103 have only one port, but the things becomes complicated if we 
talk about SJA1110 phys. From the SJA1110 user manual looks like the 
VEND1_PORT_IRQ_ENABLES register is shared between the phys. I need to 
clarify this.

Maybe is not a good idea to cut the interrupts from the top of the 
interrupt tree.
I will send another patch where I will disable the PTP and link event 
interrupts from nxp_c45_config_intr callback.
> 
>> -static bool nxp_c45_poll_txts(struct phy_device *phydev)
>> +static bool nxp_c45_poll(struct phy_device *phydev)
>>   {
>>   	return phydev->irq <= 0;
>>   }
> 
> Maybe as a new patch, but phy_interrupt_is_valid() can be used here.
> 
> Maybe also extend the commit message to include a comment that
> functions names are changed to reflect that all interrupts are now
> disabled, not just _txts interrupts. Otherwise this rename might be
> considered an unrelated change.

> 
>> @@ -448,7 +452,7 @@ static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
>>   static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
>>   {
>>   	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
>> -	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
>> +	bool poll_txts = nxp_c45_poll(priv->phydev);
>>   	struct skb_shared_hwtstamps *shhwtstamps_rx;
>>   	struct ptp_clock_event event;
>>   	struct nxp_c45_hwts hwts;
>> @@ -699,7 +703,7 @@ static void nxp_c45_txtstamp(struct mii_timestamper *mii_ts,
>>   		NXP_C45_SKB_CB(skb)->header = ptp_parse_header(skb, type);
>>   		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>>   		skb_queue_tail(&priv->tx_queue, skb);
>> -		if (nxp_c45_poll_txts(priv->phydev))
>> +		if (nxp_c45_poll(priv->phydev))
>>   			ptp_schedule_worker(priv->ptp_clock, 0);
>>   		break;
>>   	case HWTSTAMP_TX_OFF:
>> @@ -772,7 +776,7 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
>>   				 PORT_PTP_CONTROL_BYPASS);
>>   	}
>>   
>> -	if (nxp_c45_poll_txts(priv->phydev))
>> +	if (nxp_c45_poll(priv->phydev))
>>   		goto nxp_c45_no_ptp_irq;
>>   
>>   	if (priv->hwts_tx)
>> @@ -892,10 +896,12 @@ static int nxp_c45_config_intr(struct phy_device *phydev)
>>   {
>>   	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>>   		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
>> -					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
>> +					VEND1_PORT_IRQ_ENABLES,
>> +					PORT1_IRQ | GLOBAL_IRQ);
>>   	else
>>   		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
>> -					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
>> +					  VEND1_PORT_IRQ_ENABLES,
>> +					  PORT1_IRQ | GLOBAL_IRQ);
>>   }
>>   
>>   static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
>> @@ -1290,6 +1296,10 @@ static int nxp_c45_config_init(struct phy_device *phydev)
>>   	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_FUNC_ENABLES,
>>   			 PTP_ENABLE);
>>   
>> +	if (!nxp_c45_poll(phydev))
>> +		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
>> +				 VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
>> +
> 
> It seems odd to be touching interrupt configuration outside of
> nxp_c45_config_intr(). Is there a reason this cannot be part of
> phydev->interrupts == PHY_INTERRUPT_ENABLED ?
Well, these C45 TJA PHYs have the interrupts organized in a tree.
The idea in this patch was to enable any interrupt(external trigger, 
PTP, link event, etc) from anywhere, but nxp_c45_config_intr to be able 
to disable/enable them in one register write.
> 
> 	Andrew

Radu P.
