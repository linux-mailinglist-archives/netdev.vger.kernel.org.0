Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A357CF50
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiGUPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiGUPgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:36:19 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2077.outbound.protection.outlook.com [40.107.21.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94376DCE;
        Thu, 21 Jul 2022 08:36:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRu69dUO9ZZgN7SHUg3A2He/zkUqbeFHfchxxHMl6hA0k71f5k+OGfv06SHRJdL1EHPUniPLWf5GXSuwabTrlWDQjBSMPMUw/AeOxSSBf5kcr6CBWOFOOMh016A+aCyXj/0vJ+tYICb4v5uapLHHYKLyuRi0dBxa50511yFRcezdQr+FMwtShwR6AU6TgUg5L3k3tjokOJa5zDqySDkPM3jAtCzf5U2BO8a6Bvqz3WBwxgd2Qt0fE7K1ia3Y1xjvbzoVtaMhCHooo34W6s0q2+oKZmB9Crylcxuty4Uls67cynSq3wfe4MCN+yxNNAGyZctBZRsVt4mZqLH8fAizUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOo062MotdShzo5Ry/UJutsJx9aoQgahRAHCjBZMY3g=;
 b=Sjrov4JHYTnlStwI38GEIuMFC4qog3rjtnGMCC22ICCBMlQMQq6MYmjFKvtL1OA9J6QJnOIIt6UEvK5EHX21A4NU62599OCx6sBll79eORVcXJgWqE8C8OrGfll7PI/9JeAzUsDG6HVFyaSknuXXeyPbquylva4vwNBaixOJL+APAYQqb0KRDnPTO10qwZEs5emx9C3bQqmdYGraU24YJRXR5wSmuvX1+mGs//4QfVgkX7lqnWVaOpx/3FGTZPnGixek1HR+gYXMr2Vtkm36dpNVBn/QMy4aqgmbz4btfS5UbnUC1TrmTPZ9kHnIhWW/AAB+gTHAT2ZbqS7ZP1bnHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOo062MotdShzo5Ry/UJutsJx9aoQgahRAHCjBZMY3g=;
 b=Vp0nBvFcyA8a01ssUeXk8iwIRiki/9PzDvy1IvA+Deq8T0D4s76aq0LXYxpi87YgGYHXmckJUjEts9Rek1fcohrAnqAdt5BFlL3u4KfMDYzHE+s92djyrNcrVahEyg1K6Z42FOM3owLYpGlJXMt6EjreQ3lIRoMHYjEycYIkFIhZqq0TAVs4anV6MD4/zrBAiQ+be589CYp0K40QONqwpqiPSOu3zX6IwwE0Ux69zqLYHbM1x1M53cWolMHkAmBDBqSLZxpEjINjKXy6wEulghEGiyhWoy2j94gD3Cd/reg3dQWYRHrHKbOCk1XH4bypcRJWkRfKALLmt2n/uPuvaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0302MB3280.eurprd03.prod.outlook.com (2603:10a6:803:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:36:15 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:36:15 +0000
Subject: Re: [PATCH net-next v3 35/47] net: dpaa: Use mac_dev variable in
 dpaa_netdev_init
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-36-sean.anderson@seco.com>
 <VI1PR04MB5807DD62C1A2E733CC7CC129F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <a52e07c6-1705-c0ac-48e0-00ea95f75e38@seco.com>
Date:   Thu, 21 Jul 2022 11:36:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB5807DD62C1A2E733CC7CC129F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8327d79b-5204-4537-5014-08da6b2ebfc5
X-MS-TrafficTypeDiagnostic: VI1PR0302MB3280:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2+0BHSwFCkr+fmq4moMGE7yRo7qhwP+WvCN/f5Y8wyIY3zAkKb2kmkQgcnNOHj7e5zifVa3mBFH5OfbD8d/75+/LhBmCyYXn8IbWP/IMQ7f8phl+PjK6Mq78bhuczCr5vSR1+GJX2vKAHEcysMU/4uMAPVnKViqsJr9/t199eq+Q+YHNSmNUWTBXNLK+NJFHP3GHplt7hic3md9Ydf/x1k6HT8MmZGP4RyMVx7P8ki+Vx42Sbkpyb3Qf3MUJb1arYfZ4ZR0HxrNWQ8vYlC0I/2ZdxZGSdx7tMpsVZh0QmpUQ3ZvVocu2i7JWc1RO4iWNPmlTNhhnmYh5ydubGjAd+wu+G0Ohl3xZ1I6LbEmTlPTC+z0sI2pkPJ49jz/QUBfAEfiLUmIegQoFSilPRg3eVo09GnqjMaEjWWeF/Sf7Oky4DtEHbJK+6puYFfZNRPNXapVO+XdBY1q+g4y5skNG0CmxjAcQAsV3YFIJ9i7CXMUT2Ru5crdi3Ott1nBDjZFGL2cdSug31s4SC3rNmEMnf7EqSNv+ZkokBwfTXBBh7zael1oUgMPl6hN3AZ7jLV9fHaSJdHRuXupUqKCP9nAa07vsgXkZtgATf5lc0DrZG+8XQgJ8a4W3oh8rCrxMrd8+V7ozudqwb53klAkGUEoBT78PEflk8hjcLCT9Tt/HxT6BYoglE39i6WBFRfErJxkUlMVUC1JNPv7mAnznLopZW7CBEs0UED+boKe0Cgd2qFNSNgi8bHNmX/ILEjuLFKippQjt+qcso/aUdvNllc2oF2NyWhkHGaeX5RFK/C2Xneo8E8r9gLxufEx57sS1YjUO5da3P7sy17CaJMfE1kUPzkl81aX9qyT8ahHMbOzXtg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39850400004)(376002)(136003)(38350700002)(6506007)(52116002)(36756003)(53546011)(8936002)(5660300002)(44832011)(6486002)(316002)(26005)(31686004)(478600001)(2616005)(41300700001)(6666004)(6512007)(31696002)(86362001)(83380400001)(186003)(2906002)(110136005)(66556008)(66476007)(8676002)(66946007)(4326008)(38100700002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk1xQVVzMGY3SExDU05DK0E4UTk0UVY1V3lYRVBNODNpcHRiUDliZ1l0amVF?=
 =?utf-8?B?TmFKTmNMMWZ4NDZXbzU2MVFiMW14RU1naE9LZVBpKzhhdUp1d2QwRDJNRU90?=
 =?utf-8?B?YnFHb2lITklydjRERkZrVnI1V2lKY3FUNXN3dER1Wm9xUXpwc0JaYnYva1Iy?=
 =?utf-8?B?S0FKWUFLWUNKQlVwaHFXSzhpZ25iOWQ3ZUp2aUs4NXFDTER0Z2tDQXp5U3hq?=
 =?utf-8?B?dEo5dGtaOHMrTEtxOXA5bkFHaWQwWVh1TnhrekxuYU5mS25ZTUNPMjE1MDBZ?=
 =?utf-8?B?ZFJlM21JVlNUdEZiYWd1cjJKOCtPWXY3L24wN0c0ZUJtK0JIY0tHZVZ3bmlq?=
 =?utf-8?B?dUtGTHdWcFYralZMdXI0OTZNeE5SaDZpUnlvQVRSa3BXR1daZDJKVk5wUEg0?=
 =?utf-8?B?ODBpd0FDbDVGTnkwM0gzVmdOdlI5Sk5kWWgyMVh4YkplNXY0NUE3aVRLNXFu?=
 =?utf-8?B?MEhPOTgrQ3lvUnk4TDVDK09UODFmb1RlU3ZXWUdaY1RpaklkbmlVY2p4OUw2?=
 =?utf-8?B?czdXeTcyL0NpSGJ1QlhyZHpSTDMrUDJPWldPSjcrSFBZS3lrWHg4L2xxY1pG?=
 =?utf-8?B?TUlEUmg1VFVJalF1Tnkydy9CemlxY1YzL0RjNHYvSTZaUkhNdlRpWlhWL1hC?=
 =?utf-8?B?RXVBbDEvWVpYN3Z5THNpWUIrYURYWVJuenNXNlRRWW5hSUZJckxiL2dYNTYr?=
 =?utf-8?B?Nk1EVytETFVMK2M4S1l6bjNMZnpacHYrYlRyOUJPRlVET3lZc002VEpxejd3?=
 =?utf-8?B?Q0NqNzJhWThvSEkzbWtIZUNUWkFKV2lBMFUxeG0wb2dReThUZThZMXQxd0Vn?=
 =?utf-8?B?bGxpa2dLUDhyalBuWCtHVUdFdXZqdzR1cjVtTEJHTzdtOTJ1UUg2eWdmZ2pQ?=
 =?utf-8?B?cEhTZmJuVmhVeUNKc2RjYUwxL1p6WElIZGUrTDRxbHZFRTNTWW56alNTWVBk?=
 =?utf-8?B?SGZFclNzenlCWGlpa2VzaXJRRVdoVW0vcENRMmdya1c2M3NLdTNEdzhOblNY?=
 =?utf-8?B?Y250WXlIZERjMFdrWTRzZ2xWMy9jTkpGc3BIVCthMkoyRExmTU0xeFBCa1Fo?=
 =?utf-8?B?K09BRTN1NUFoNGI0TUQxZ2Q5SUJFcC83ZldBemVsRHZTVEpjd2RwMksxK1Qr?=
 =?utf-8?B?djJoOVFWc0ZUYU91bVozQWVKWU5jZVhCZk1jODUrdVBBdzRjbDFlcmE4cVp1?=
 =?utf-8?B?bHpqMGdEZ3hpVldCR2drODkrRWdmdVBkK0xQZWJJUVN6ejNZSVdJZzd3czFn?=
 =?utf-8?B?RFMvK1Y1TGdnckJBRlY4QlNSdjV2N082NkhuL0loK24rd1RTMVBKTG1qUXlR?=
 =?utf-8?B?NTg4dVptbU85enBwTUQrZGpicnVmQTFDMTRuSzhaVjVVRGsyZzlZNFJLQUo2?=
 =?utf-8?B?TmtxdnlINGlPTHhsM2doQWxERVVMbUg1bFd5N1pacmp3elQ0QkZCNEQ5WGV5?=
 =?utf-8?B?Ujg4L0d5eUUzMWR0LzM5NmZVc0IwczEwcW5EU2djU0VWWFVVUmFDemlJd25l?=
 =?utf-8?B?TWRRZUdoUGs0ZlE3QzdCRkp3eGt6WEN4NEdpSkRNSHRIUngyOFpjazUxYy9z?=
 =?utf-8?B?cGd5RlYwdmdkYm1vM0VTMEw2cXFJT3ZTckMvbDd6YnZaTU1uNko0OEo1SFN3?=
 =?utf-8?B?Yzl5d0JkNG9zUjJIbE5mNEZ4blYzK0YwUHZuZ1lLa3NKeE9seEV0OFhsY2xZ?=
 =?utf-8?B?YUlOQ2xVRmYzaGFWM2ViMWp5alRtV01BY1NxeWFvaHFORDBYbnVtSlM2NlFq?=
 =?utf-8?B?TE1LeFo2MzdCN1ZRMUJYTGlSdi8wR2tSOWxvb0NWRnJqZTg1UUo5bVZHV2cv?=
 =?utf-8?B?U2pudXBSQ0xUWjVMS3JPcHk2MkFUYXF4bnpHdVpkZW5KNUU5bCsvZEdNeUx2?=
 =?utf-8?B?Nm5JUlRKdDJndWxUaGozY0NBYlo3c3FhQUd0U0h5NXlCSlFLTExCeGtpMGZZ?=
 =?utf-8?B?bEYvdlJXR3ZQdlc2ZHp3d1BxMHlCNCtNT2hNN1hFQjVhYUdra1VDMHQ5WitQ?=
 =?utf-8?B?a2s4WGU2QTVSdEJVb3IxdUJQcDhLc2VXQlJDbjJpcXVONWkrbkcyOVJ3dm45?=
 =?utf-8?B?ZVVITmhZOS9HYjBsc2x6Qk5NVzBYcGJKT0JOc1lnY08zZ3dxOVJ1VVhvZzlV?=
 =?utf-8?B?SHJOQ2lWa1RjQUwxWHVrVkVnaG9hK3A3eGVicTZjQmxNWTlqQ3JEeEhvRlhW?=
 =?utf-8?B?MkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8327d79b-5204-4537-5014-08da6b2ebfc5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:36:15.7643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evhm4r9SgOIl11Udx40gGTbzmuLlEiu4npHzRTwSJFqrcbT/ubTEV9uw4TnW+n8txwPelI6DCP1DZdSAGK9MQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 9:15 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>
>> Subject: [PATCH net-next v3 35/47] net: dpaa: Use mac_dev variable in
>> dpaa_netdev_init
>> 
>> There are several references to mac_dev in dpaa_netdev_init. Make things a
>> bit more concise by adding a local variable for it.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> (no changes since v1)
>> 
>>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> index d378247a6d0c..377e5513a414 100644
>> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
>> @@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device
>> *net_dev,
>>  {
>>  	struct dpaa_priv *priv = netdev_priv(net_dev);
>>  	struct device *dev = net_dev->dev.parent;
>> +	struct mac_device *mac_dev = priv->mac_dev;
>>  	struct dpaa_percpu_priv *percpu_priv;
>>  	const u8 *mac_addr;
>>  	int i, err;
>> @@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device
>> *net_dev,
>>  	}
>> 
>>  	net_dev->netdev_ops = dpaa_ops;
>> -	mac_addr = priv->mac_dev->addr;
>> +	mac_addr = mac_dev->addr;
>> 
>> -	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
>> -	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
>> +	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
>> +	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
>> 
>>  	net_dev->min_mtu = ETH_MIN_MTU;
>>  	net_dev->max_mtu = dpaa_get_max_mtu();
>> @@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device
>> *net_dev,
>>  		eth_hw_addr_set(net_dev, mac_addr);
>>  	} else {
>>  		eth_hw_addr_random(net_dev);
>> -		err = priv->mac_dev->change_addr(priv->mac_dev-
>> >fman_mac,
>> +		err = priv->mac_dev->change_addr(mac_dev->fman_mac,
>>  			(const enet_addr_t *)net_dev->dev_addr);
> 
> You can replace priv->mac_dev->change_addr with mac_dev->change_addr as well.

OK

>>  		if (err) {
>>  			dev_err(dev, "Failed to set random MAC address\n");
>> --
>> 2.35.1.1320.gc452695387.dirty
> 
