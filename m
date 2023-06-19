Return-Path: <netdev+bounces-11856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C6A734E2B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54A641C20995
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BCF6BA2C;
	Mon, 19 Jun 2023 08:43:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B1E63DA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:43:08 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862EF26BD;
	Mon, 19 Jun 2023 01:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5K1cm3JaZ2rJVdx93OeU4GwwiEK43I8WC0Olk6Oy5GqPITUNv1km1V6Y5+Kyu1C1JLI+8pKRXvkG6IcIxGm7cm6Jkf0EtV5lg3Ed2ETz21J61MJ1mbguMZNmZblSL9ZKs/w70oZAjxcoCzJG1BDcb10midi3r5GJ+ZU1HgmH4HjOUXtxEMXuPASef+GZh5k+TbvB9lErjow4EmB8aWum2KCc4eD6Gc+yZcRs1cG14kEsOJOejjjky570ZWDJl2aazoqi+2KoTU4rA4nINBdoE1mZ0QV2IA0eSJzPNx68AooA5Yd0KqFmw08IQg0J3t/gaYJQgqqJI7zKyKqhnx5oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBjGqDZ2/FU+1NvLVg5BhZMRNjIbbTCGQBwoOmRqwDg=;
 b=N5HeczatIZNAn18VYrOe62w5z0NNA681bpmtrRbq+1LNE6ToZjK+Wp6QlDZ26zglKMRkv1YisbIuDzK8cdaKA2MHHRe19whdvlrkdQ1XcpsC+wGae7MSPjsmnFHnCoKB6tUNQVlzCQc+ByOR7Gixmvp2haaqfuNHhvKDoonr4J14E9ckSax8tauJ2ntiWz8OXgHvD5ReZrVsxmcFBghor762VwI69EJADsVLB/AVl+6/3LkIgiJw+DHgOrikvMzCwHfmfiOrDDoFfJSyGPpiWvQR4Mv35YDV6Xmm9mi1aK5FzUyjBiXfLKVNzh/FIo9OoVQrTdP1x9yOPL266JqvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBjGqDZ2/FU+1NvLVg5BhZMRNjIbbTCGQBwoOmRqwDg=;
 b=IeB19UJpDDdSCAFf9a7yX2UC6vzdgdWUqa6M0naw5baPEAm2sZvd8wNW1FM734Cc6jlHgaTKUxoQJuk7tYmlk5BDyHEYHr6TDCerDT+kCiO2X5vYALpQLblm2jRZDLnbcuN8gGgdctJt85Vh0YWgeo4uylejBNUet6joAWdTk3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8259.eurprd04.prod.outlook.com (2603:10a6:20b:3e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 08:42:26 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 08:42:29 +0000
Message-ID: <9cba4edd-5eab-5a4e-0c10-753495278f8c@oss.nxp.com>
Date: Mon, 19 Jun 2023 11:42:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 01/14] net: phy: nxp-c45-tja11xx: fix the PTP
 interrupt enablig/disabling
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com,
 stable@vger.kernel.org
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-2-radu-nicolae.pirea@oss.nxp.com>
 <5f47ee8c-6a84-4449-9331-1895e4a612d9@lunn.ch>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <5f47ee8c-6a84-4449-9331-1895e4a612d9@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0008.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::9) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AM9PR04MB8259:EE_
X-MS-Office365-Filtering-Correlation-Id: 44362faa-6452-46b3-2a43-08db70a11d67
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eDVdxZWpisHArBK5LX2hriC4ObKviXf1dLkhhmp9zVB0IRcUM5J+A3NANbvNnPrtiQkRKEsxRBklK9c7elBZQVA/3b4s3og0ADchBk1eoqOEaJIQF2qbabViThT0YJRcLG2waGRdIftiNyjNT3fXVNoTaYD8MjBS16tjDbeMV6zoRo2WGezyH0AZ+lohlrx0rmArAKPXX9U9l8L2w0LKCKzEtnbtxGukOPfpFRwxMYxG2jZnUPKklPUCyjsu3ZHpGslYD25Vgi78E8dfvfAdVfqy4IMHjZC5VYboG2PgletQIWkYQ1ra2XTetdHvwBtD4ygQSAGn80Fl8LohRtZZBay/tAKngOpl9KiyPexzK1Xdy3xLKOcRYcrjrEJ0JdPCtE+D+/3lH8Vf029maobcXLYh3hMgn19MWGDMJMRCBXyb0g4tAMx2SkZGAFtSaTt0bLrmRQX28IT7y/YfEj92/HoV/GCaz9SGNFItFAPtjOlu8qvcJ6Vlf90C5BSGkKubXSo+jIq/lm48wO0cwiy6fbVjk8C4OgRRgEDIRqTUZLTpHj8koM9HiXMqVKgEhpj7vGJeDGP9DNJlRv3mnCvXK/1Ap35L3hA/tN64Q/YIYpz9xmxMuThnwVKcVowA5dOBk/CK5ApKzgr22eeHo0Rebg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(41300700001)(5660300002)(7416002)(8936002)(8676002)(2906002)(86362001)(31696002)(26005)(6506007)(6512007)(53546011)(186003)(478600001)(6486002)(66946007)(66556008)(66476007)(6916009)(4326008)(38100700002)(316002)(31686004)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWNzZWdZOFUzK0tKc2hDWXVia3RDeUk1aGszV3htUkFBSGRPTjZoR3hRZFhO?=
 =?utf-8?B?c2VuWCt4a0tyUm54YmJlMzdRTTVZd2h6Ti91SE13a09yaTlvVTBsYnhWYzk0?=
 =?utf-8?B?VkdjcUZTKzMwNk5nNHlxWk9lUDVBTG0ydUJpK0hJOGJxMkhRRzZtQ25Dcy9Q?=
 =?utf-8?B?N1dEc3pqT2VEajAwRENVbzRkSEJBei9KbmR1VllBeGNUNHpVN1pkWXErenQr?=
 =?utf-8?B?bU56R1RaakFRQ2FTRTlGK0ZGaEV1bkZWOE85M1JXdzRXdVNJVXlTUGRZMWM4?=
 =?utf-8?B?TnJTVDRhSjJ4UFprUVlKMnkwNnpFa1dUb3JMZ212dWxOajYvK0lab1pKWlVZ?=
 =?utf-8?B?cXhueGFUa1FabDg4UUNyelBkSTNQU3Z0RFAxbmhVaEs1K1ZqRnhGZFlTN2tY?=
 =?utf-8?B?UFZjd3RCTDdab3FacjJPazNoa0h4eHpLMFJ3MHlJVjJpZGZZSER4WlBmMFph?=
 =?utf-8?B?RWRkVGR4Z0lJUFVvNWI2NG9CQ1F2K0tQVWx0QUk4MDM3WGJWOGRhTUNUNUFB?=
 =?utf-8?B?UnVvWEo1MDY3Z1ByOEhGT0dRcFhXSGV4MU9aWUdGeVMyMTFWcUJtZ2NWLytr?=
 =?utf-8?B?RE96Y3VHTVNpMmdmTXltL1FxSENpUkNFbUNqbHlyUnNGTW5KTzhNcitNRllK?=
 =?utf-8?B?YzFmKzdJMjk3emNLREU5S2FPRkJ3UlJjVWVzSHN3a29hYVBOUTc2SUFxZTQv?=
 =?utf-8?B?K0gzNHZ3TC9CUnlWdlFRQlk5ZDJBTFh5c0xkcFVnOWNOaVFyVmR4YmNaYVQw?=
 =?utf-8?B?amNMc0YrTWEzcG1PclRuQkIrT0FJbkpTaERrVnJUSGFMY0Q2ZWJQZm1hdmR6?=
 =?utf-8?B?bVhkV3lKcmxBMHF2YkpkVVUwN3MwMXRqdFlvdHo5R3BLWlh2YkVmdE5vVk1y?=
 =?utf-8?B?bE1lK2tiYW1QOVU1R2pMNlJjbUsvaU1RQWJZVUJtN3FXaE15U1dlVXJ4ejFJ?=
 =?utf-8?B?RjNNYUhMVG5mcUQ1NjZvU1ZFLy8zNm5HUlUvRUd6cVowbXJXb3pmUVVMVnF3?=
 =?utf-8?B?NTBvWkdsRlVPUFJjUmdUTzNqYnRDbVN0N2lkWFVBUGpFalRjQXJ0ZytHdXpk?=
 =?utf-8?B?L2NGK0hiVVBvMTc0OGRwM0NvVWRkL0xKQXZOenE3Y253NXZwYndPVjJzTUlM?=
 =?utf-8?B?T1NCbHRyT2ZZNERTNDNuL0JWRVNlZkFvbHh3MzdkZ3c5SytuaXFSZ1dOeGJs?=
 =?utf-8?B?a1dnQmk1MHdkaVpqUG96c1VLbnZEaGU3MXNYbTF1K2t2dkY5ZWR4QmhpaUJH?=
 =?utf-8?B?bEI3bXVmUDl1aEgrMG4vZFkzMFdnWHdKMUZiU25Qbno3ODFNL0tCeW9MU3FP?=
 =?utf-8?B?eG8xMllpb1Z6RngrdmVmN21ZeUxIcW56MEtpZXU4cXhsTnJkeUM3YW51N3A3?=
 =?utf-8?B?Q1NnMjZkaktvMThHRUN5Mi9TZThlajkvYkJXVGF5SnpmZm5DbmFvZHllWmVF?=
 =?utf-8?B?eGZqcTJsaXh2Z3A2L2JXUkFUU2I2TzRMNzdBVzVJWGdPK1dVeGFqajdDaGoz?=
 =?utf-8?B?MC91c094RitDMm1MYmV6VERKbEcyWEFHVW9WenUyOFVkVnc1c2FlakROcmwz?=
 =?utf-8?B?OXZvam9ESHcrd0NMNjJHcjI4V3ptMHVPa3ZwN1dtejVQbGZCakJreGxlL0V6?=
 =?utf-8?B?a2VkRGFraDNCczdQTlZ5WWQxTk1qUHBSTis0dlA5WEYxeURLeDBsN1lTc2Mz?=
 =?utf-8?B?ekxFUUNYWCs1LzB4VDBFZE9UY1J6bFE2UGR6c3FUcDE0WkhGQ3BseDAycG1m?=
 =?utf-8?B?c3NKcmxMWUs5TlZPTUU4SjUwbFJrZTZ2SHdWRG5ONTlmOXB4Q3oveXJ3aUxm?=
 =?utf-8?B?b3N1V2F2MjlGTVJ4V0FxeDNwbFVqQUVNQk1WSTZ6djhqZFRrK2JzcVBGMTMz?=
 =?utf-8?B?cFg2NVRmdVdIemdESE5rUXNoUy83VW9jbEwrYzZPTnByWkIraTdURG01czdO?=
 =?utf-8?B?UjlqZWJwOTFJbVFUVkgzUGE5RG5rSTBITTVlbkZrWWZXQVVrSE5qSGNVNWVS?=
 =?utf-8?B?MGM1TWFZbkxEbkZHZnptaUZqbDZMWTRTVnBCUE9oT1lkTFpnanJGVFMrL1JQ?=
 =?utf-8?B?Zmg2ajhIZHkySlNISGZTNTMyVXhaRlBhT0dvK0M3a2VZSityR0lyVWJhRElI?=
 =?utf-8?B?eE51WTEzL2lkcDdxN2xFdTdCSXF0RW1iUU1Ldlk0MnhHcUJhMkNUVG9idjBL?=
 =?utf-8?B?Y3c9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44362faa-6452-46b3-2a43-08db70a11d67
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 08:42:29.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZkqjnT1XQaboPJjqbNflr3oCQd9ZVd30gdY8EYDd5O9adC+g54TXUJrqhjEon8VwZ0cebHnI3hH3j2/rfmLgLHceceqfe4VMv6F7z42h50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8259
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16.06.2023 23:36, Andrew Lunn wrote:
> On Fri, Jun 16, 2023 at 04:53:10PM +0300, Radu Pirea (NXP OSS) wrote:
>> .config_intr() handles only the link event interrupt and should
>> disable/enable the PTP interrupt also.
>>
>> It's safe to disable/enable the PTP irq even if the egress ts irq
>> is disabled. This interrupt, the PTP one, acts as a global switch for all
>> PTP irqs.
>>
>> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
>> CC: stable@vger.kernel.org # 5.15+
>> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> 
> Please don't mix fixes and development work in one patchset. Please
> post this to applying to net, not net-next.

Ok. I will send it to net and apply your suggestions.

> 
>>   static int nxp_c45_config_intr(struct phy_device *phydev)
>>   {
>> -     if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>> +     /* The return value is ignored on purpose. It might be < 0.
>> +      * 0x807A register is not present on SJA1110 PHYs.
>> +      */
>> +     if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
>> +             phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
>> +                              VEND1_PORT_FUNC_IRQ_EN, PTP_IRQS);
>>                return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
>>                                        VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
> 
> phy_set_bits_mmd() will not return an error if the register does not
> exist. There is no such indication for MDIO. This is going to do a
> read/modify/write. That read might get 0xffff, or random junk. And
> then the write back will be successful. The only time
> phy_read()/phy_write return error is when there is a problem within
> the bus master, like its clock gets turned off and the transfer times
> out.
> 
> So it is good to document you are accessing a register which might not
> exist, but there is no need to ignore the return code.
> 
>         Andrew

-- 
Radu P.

