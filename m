Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FD76DB1F0
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjDGRme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjDGRm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:42:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C008AB740;
        Fri,  7 Apr 2023 10:42:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEHFqtbvusqoZBHOHn7/d/4Ei6nFCt2s8BFLMPkA2IeHO9riKAS/EIsrIV0uqlvJSjAIY7LzKcYZIy7MJldi95Mdad6i35i+8vtxfwgKaii/f4jmAlvufxhsPuSYwS1eFAHI1NGTIlsGgyn+R9JshTR6quCFPcijmML4GDIANvSRYXgT76nyyyEBRepZ1HvAE5iUMJ0Jm3F2+ioTNCGuNrBBhRWgPkUj9+RvcoGe3/3exisCeDnX5ACZ7uFeeUjd83C/IEUqIUSmp5RC5Y8GtNlG0V+aSyBq/uj1RGbHlECAgtcrKXWzSMaziD6z6Nq0jXETRSjZLu3+FSwjy6B9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ufm+avF7yr2dZsayGwmZElxpxGwyK6e/FxCvFQWuQAA=;
 b=kt30KNPvxU74EnFplLwLTfe4kfW5Jtu8Yn2pe3sRo/5g4bqOAm7WQUz1aFCiKxHCR03bRz3r6FpjZikWEwcTtTi9NYgGhg8ztVecof4376AKVd+j+MMSBM0qzGU7X3z1iotkaYkLsYQhA5vyu51g5lK78apjwJX7V0VbZPIMSnyWNxGqKEAWTyZO/5PA2vHR4Lo03IM1s7bqxCzKtPfHoDGyyytcEJ48mCvtpB2d6eZDvo5rCPtbMftYLQ5Y2JX3I1lDMhnuqt6VOYl+RJiv3tLuNHZoprkr+Ejbwp9XL6J+PviGcwYJhX8QRbxmFEs1q3Eu1aJ25/+Fgs9z/cgugQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ufm+avF7yr2dZsayGwmZElxpxGwyK6e/FxCvFQWuQAA=;
 b=GE9Dqdsh9F5tAgNiJhFNfI4GF6HJweNKtLBGNrOkZUpNLOkNmhBYU8BbeOmvTtdblEfqGOPr64msVJPjbp3ZSnh6w71D6gCXvYe2cB0+81plpAJ6D+Kd048EXZl4+KMOsEq/+hDov0TxquCSwYFQdXUb7C8HddQbsZbiirNr0ng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PAXPR04MB8944.eurprd04.prod.outlook.com (2603:10a6:102:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Fri, 7 Apr
 2023 17:42:15 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%7]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 17:42:14 +0000
Message-ID: <104c1190-cd18-d7c9-7b27-af367ac539bb@oss.nxp.com>
Date:   Fri, 7 Apr 2023 20:42:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
 <cf1dd1a9-2e2d-473e-89f0-8e2c51226dfe@lunn.ch>
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <cf1dd1a9-2e2d-473e-89f0-8e2c51226dfe@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::14) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PAXPR04MB8944:EE_
X-MS-Office365-Filtering-Correlation-Id: a666fb68-869c-4951-97dd-08db378f6c9b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2IlY7zlOcJreX1szA3yFkBYuUHG7rZvdM5FsiiAGppy7nDBbYkpY+46liv3TRLBeMM2Qa8bNqXgCMPVjC+hLvroV0zyobUW4rtoOclJDIcu1bTklQGDT+KjrUBy8PlBHGerFxBtHQ/WR4D9fNdhf0f63LWXUmWJHX+Oia3WcZAHD85z+qfSqlPl8iLAB7CvENTuuBi0S5LuEZHSLVbUPiAnVZfuHzWKr8pTw3fv0kdF4YAVpbJR5RB2MYlfIOraUHx4zrSE76hToSeZHSSIrjxqu8uNxikCtVtyLo+G7EfqOIxKQCqEN6ujgT8okwuPKuRagGm4ctXG4yPM7c5okG+V4hReoxAx/PFKkcEgAxYBuJTGQkakBtVTlKD8GnO8XTIbP9c98AaMnayYQ3LPIih8TrT6Yg2GX40UXNki7JdpLJu7ptOO17CnfM9hCfUUdOJGhetuLBkS3pJ75r/y18XjLfakPgMupwB+ppAdUi4w7Oe91aS8v0Msav+U432k7imR2gsllAuuQwYctutTL0sXiLpJBCmEVAUKziWSSOzVOdrSioD1j9+ZO/zSe42JumMxczkW8fMOmnpvThl+1nK8XqdMSSJSQdww7MjAinpSnXgaS2Uzm8yOI448uMWD/z76CULodhh3W5Frr9Zzuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(478600001)(316002)(53546011)(6512007)(6506007)(26005)(186003)(6486002)(2906002)(5660300002)(66476007)(41300700001)(66946007)(6916009)(4326008)(8936002)(8676002)(7416002)(66556008)(38100700002)(86362001)(31696002)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVZnK3JEYmdUZEN2VFI2bEZ1eUQ4WjFpejlUWkxHTmdJTEYwL3AxYnpNM3lH?=
 =?utf-8?B?ZGE3QkFxaEIvaHNzUTRzVDB0SDFGYzFWTEphNVBiR3kwYnVuQnRlamIrS2tS?=
 =?utf-8?B?cWVTQVM1aUNBZllxWVBNUDFqSGhvZi9ONTdWWEU3ZFVDd2JFOWc0T0Q3ZFox?=
 =?utf-8?B?a1hKQ1V4MHcxbTZzUWhkUHEzdHh5OGEyME9kWitMMlRBdjUzK3R4Tk9GQ01J?=
 =?utf-8?B?emIyR1poU0tlNkFhNlJBbmg5eDJvN0hRdUlpWVlEMlB0NWVMK0ZramljbHQ2?=
 =?utf-8?B?VHZvRnVwRzhCUTBNOVhsd3p1bi9PZk5ibEl0S3JZakNQb2RVRjcrZk5peTBh?=
 =?utf-8?B?a0U0OUgzcUV5aDlsMmlKaVRJYlQ0ZnZvZ2k0SlBZdzIrWXAwTGFQTGl4NlJC?=
 =?utf-8?B?WDBMZ2IrOFhQcmVCcXNQQlRiTTFpMmtYZlZFcHhYQXpPVG1rdUV0bVlXM0pj?=
 =?utf-8?B?a2JYU0FjODZhMXRWMll4cjVUcU1pYjJ0ZmR0QjU4cHYyUjlFNjBOekNQN2Fv?=
 =?utf-8?B?Sm9qNmgrWndsdmd5d3JKdmc1TTNDRG5sa1Y1S1JWM05wT3NpU1RGWm9BOXZL?=
 =?utf-8?B?VmlUanRSeStiUXdOSThicFJnSmJuTW13T3lwRnBHKzd6MVVGRnRQTG9rZmhi?=
 =?utf-8?B?MUhlY00rejhqVmY0dUZRS2lKa2pmVGkyUDNvL3JYZEsrajlHbTVUQ2JtQmZS?=
 =?utf-8?B?bjE0clBVeWh4b055bHZnL0JZT1ljWFMxck03RlJKQUREa2tQaTl4ZWsyd0ZI?=
 =?utf-8?B?eVhJSFFyWitwRW43ZDBRamY3MC9BYUdXekFKS2lxa0lOREx0WHVFQVlOanNu?=
 =?utf-8?B?OHNjZHJUNC9kMHVLR2RwZnRLTjNaZmkzdDU0bjdzMmRJamN3bVBCQ1NGQjRP?=
 =?utf-8?B?TFMyR0MwUkpucjFKR0RCSzN0QXQwSGpvbTB1elNzMkRDMEFMU0E5UUIrR1N1?=
 =?utf-8?B?UW1MUEZ2OHJUQnZtR3hqYUE5ellPYjZYZWNGdllDUXU5Y1FCU2g1MXlMOUdN?=
 =?utf-8?B?UHBENUZyQnFPMmxDSFJjeThzY2xmUmNRazFpUWN1QldDdEZpWGV3YUYveVlO?=
 =?utf-8?B?ODVpQ3ZOcVZBcGdmbGt6dVh1R2VoR1VNeTlQZW1SdTdXWmFEVExIOXRTa05h?=
 =?utf-8?B?blJmZ1hjdnU0Q0tJa2gxTFlxYk41MTg0RVQvSmNvWWNObldHNFRZSnhNOTRG?=
 =?utf-8?B?U1hQMnRleGRoRDhudUUxbENMb2NuUTBQYzBIZkFJWkxhUGJhZ3NNeU1XM1BC?=
 =?utf-8?B?RVBBM2lFQmdvMFhLMkhjTVE3R3RQbEFTYzBHaGoyVld6UTRTOEVSZ09XaEdQ?=
 =?utf-8?B?RVhQYnNya2NKemhqK0N4Qjk0WDBjT1Y3aGNXT0xNVmowaU1OY1FTL1BQT3Bu?=
 =?utf-8?B?MUJBdWF1VzM3djI3UkRtTFgxSWdObDRPMEFHd05HM2NXWk40QVNTK3M3TkU1?=
 =?utf-8?B?WU5NNWQwcVlYMWwvdDIwVkhzUndYaDd1Zm9tYS8zNlh2RmJ0Y09abmJVbFE5?=
 =?utf-8?B?dDZheW5BUm1ONjg5SGRQZ1pFc1RGQ3VLQ21NaC9KbFpQVG1Cc28rUEVvN0Vy?=
 =?utf-8?B?NXJHY0VnaFlQdEJuRGYrcmNEd1d4a0FnU0hGcjJUR2tpUjR3emc5NlJYRlZh?=
 =?utf-8?B?TkJzTXJmSkRMemNMeWpUcmNyNFdsbWFoU2FETmErNmNsU25ZUE80T2ZRQWZv?=
 =?utf-8?B?cm5jYVMrRVFMclFDNXZ3UWJaNmJ0UDJhRnlES21CTFJyWVF5K0JnczlCTGZ4?=
 =?utf-8?B?M3dxK1NFM0RMTHNxNTJpNWE2aTBUL051M3dJODBFVGlGbUJXVmEyTCtCQXpB?=
 =?utf-8?B?SHpBck1hTnFoTE9ISnZ1S0I0ZlRMQ0Q5Y3NzNVFSbDlCRGkwYWJqam5DQy9y?=
 =?utf-8?B?M0dna3ZSRDFlamxxU0tBVHM4RWpydm9FWVFFbXBYMnh0Q09LbGlTS2dVQkYw?=
 =?utf-8?B?SmI4K2R0STR2UkFvaFJQa2VKREtWcldNSVgvRWJSV1VETVJXbENXdzlHc0I0?=
 =?utf-8?B?K2x6dU00YWVDc3hrZ3c2U1VOUy8xVjZhUy9ndnFicm94a012UWJWZ093bWhM?=
 =?utf-8?B?emFMK1dkNGJrN3lteTNMNnMwT0RIU0VtZWc2c1Nkam1acFVTMmdOdm45UHBi?=
 =?utf-8?B?cUMwRk5HTUFIYjg1K1pSRXZQNmNRNWZqVDZLcCt6bGFBaHM1L0hkL0JzdlEw?=
 =?utf-8?B?Rnc9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a666fb68-869c-4951-97dd-08db378f6c9b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 17:42:14.7656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BzcsKT29pG9mJmPZEXSkpjBB9ccLHWnl+LANNJd6cZgYcE8+X99wqCi+/QuXIWQs3TkJqq3WsvyPHWESdg+LSMZ14pWwZFvUR3l5FsQdwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8944
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.04.2023 17:20, Andrew Lunn wrote:
> On Thu, Apr 06, 2023 at 12:59:04PM +0300, Radu Pirea (OSS) wrote:
>> Unregister PTP clock when the driver is removed.
>> Purge the RX and TX skb queues.
>>
>> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
>> CC: stable@vger.kernel.org # 5.15+
>> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
>> ---
>>   drivers/net/phy/nxp-c45-tja11xx.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
>> index 5813b07242ce..27738d1ae9ea 100644
>> --- a/drivers/net/phy/nxp-c45-tja11xx.c
>> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
>> @@ -1337,6 +1337,17 @@ static int nxp_c45_probe(struct phy_device *phydev)
>>   	return ret;
>>   }
>>   
>> +static void nxp_c45_remove(struct phy_device *phydev)
>> +{
>> +	struct nxp_c45_phy *priv = phydev->priv;
>> +
>> +	if (priv->ptp_clock)
>> +		ptp_clock_unregister(priv->ptp_clock);
>> +
>> +	skb_queue_purge(&priv->tx_queue);
>> +	skb_queue_purge(&priv->rx_queue);
> 
> Do you need to disable interrupts? I suppose the real question is, is
> it guaranteed phy_disconnect() is called before the driver is removed?
The MAC driver should call phy_disconnect() when it is removed. Also, 
the user should not be able to remove the PHY driver if is in uses.

Radu P.
> 
>     Andrew
