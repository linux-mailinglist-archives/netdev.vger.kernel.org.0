Return-Path: <netdev+bounces-1656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 904DD6FEA1B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D0F8281136
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D1917746;
	Thu, 11 May 2023 03:20:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E4028E7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:20:14 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2063.outbound.protection.outlook.com [40.92.107.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B4DE63;
	Wed, 10 May 2023 20:20:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mquQVtEYcXivlFycGoKg1jX/k2m1zXsyOw9qB9fIgEZCtQ8CotnPX+g1bvVaw7lZT5d2qPFF6TKKIVavaV4/xsqog9169/LLfuzMQF5QZqlqNgJedjPdNxN5OJ2jQcFOB5gz93XoSVSU5ShP5T6cy1VDvdlW2QGN7lSqKPTx/dA6zf94Wiz/0lPmhB9rQig9cHeb4/gnZYjSYl6pzuD+CY1C/ntaJFEg4+90MVoEkZGBu/qwPe/DkSzrcL8ymg2pljwHGg7l8f87I9t9nzVuxH6BMgJDiHvRlaXu30hz3QC0sKUegE3PTNeKNim9mspGj13Ph5/fiTcL/+qItMmb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glWyDnuvbjfn81dMPnk+8ciNlXFS5lnuqIM+dQrnTh4=;
 b=VSsmRrywl3NcUVCuocKyY8w6HWRh4r40O/GDTugdujtk7sqf3/5cro/2xTfDNl93hdwq2PGdZzx507vfgEy4hgQV0TiAT44VVhz2MUuIFMrjEviM3uT/mn7Y4o/0Nh21LCRCwzc9Z0de4iqowVHWVPDvtCeADb+CueKehU6HB+FoGXmmv/xE+2+QFM3CiaezoUaLtYCF6HgJNoXdbRMrQ1raEUFGMwZT0Ers9bf8Fr1AYUzKJ7rkpc6D56e3v9Y9AidF7+ukTpXnwbcKp7bz/U9VJVbnxsoin2cTeShe4m1OdX+N3j+A+VFzxFa7WNh3SgSAXLyD7yehSDOiJvpPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glWyDnuvbjfn81dMPnk+8ciNlXFS5lnuqIM+dQrnTh4=;
 b=IzPLyaM0Kukk8akDJM6eCBmkSFC1ztnhtP9f7igmmucbTETtRxO43OukiT1nrosaKUeM8j62uAfcnFqGCrniR63hppFoqkp5M0KPEjmwJ9RQ+fu2KN40bO5lXkQwgOROg1A7jSmqInhGU6KesM2FCyjwT72RX7+NcV5ogAqX2xrPdSQiptFEiRcB5CbkV40aaHP31scq+odkjlm1lk7gQhKMQc6iXJlT26tLSIa6LzdVNedAsdTBiMcK49N0qUt01c7YRdTo008hajDLzbPdrbzioqPRKjiMSXdNrzMAJo/ykPijhk0tnqNWwn7jvmi42VaOeMBn7dgeaQxE8J206w==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by SEYPR01MB4486.apcprd01.prod.exchangelabs.com
 (2603:1096:101:8b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 03:19:58 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Thu, 11 May 2023
 03:19:57 +0000
Message-ID:
 <KL1PR01MB5448316A031146A449F87BF9E6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Date: Thu, 11 May 2023 11:19:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3] net: mdiobus: Add a function to deassert reset
To: Andrew Lunn <andrew@lunn.ch>
Cc: hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux@armlinux.org.uk
References: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <5b6eb4c3-1ef8-4ed5-bcf3-0bb11897ce24@lunn.ch>
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <5b6eb4c3-1ef8-4ed5-bcf3-0bb11897ce24@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [hYhotKpWPvhX91KTWl08UYyiKjm2Zh1X]
X-ClientProxiedBy: TYCP286CA0107.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::9) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <0ce1c312-3987-740c-ac4c-4ebe0e27f7e9@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|SEYPR01MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 935dfef2-07c4-449d-4597-08db51ce98c2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8ZsD2gTYivl9v3AHDiv+/XyCjfhVoQxCjZkVcRYIbv8+UgQFBgDNsMnoc8Hexk//gSyZhmpTFIPKIBxgdcVI5BvBZiqccjve50iBLM+C4uA7FIsynkT5me1Ko+AQsHjzlhv1hOwmUKWS37A1eNDLAcbo6LaJfKK7OIOYzM+HvEjoTZ459DxgjRPM4tgHMSHq5nqO/RKotHTGjN87Bfs7X2mINwqD3MT/fw6v2grHoT9/9eUervFWMj0xzFgijpBDTf3gWpiEeHM4aZAXpG3kjZiODXnvczwB1FXkRfipbdfdBEA/ZHyj1m2/t8ewT4aIdhoewp0dTt0HErTeYa3tJ3Cd3dhepqnrwu5bTjGEXg5wWpUtX77nb/yGmui1qQRpy1hs70XnsilZWQCsvDT29zkthPOyEsaphP8ADTUN6Zu7Cvd+u0SV+hfjni3nSLjat7Yqzvg4pCP8N9m/Ems2SYMa/+xtmM0OvXMWtAGkVR+hvOqRS4jLCZ1VOqAhl5SeJtEXsRnSOUZ1Ott76oaucAt/9AMjh2+rtqsvU27tPn+n58QJwqOKs9m1zjamNpX68sYo4BjU22AunzoAbGSH3vr0ozVBMBYTdXKdvELbft1KLK7NMLsB0oQ0wClY87WR
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFZZMmhoMEIxTkJTMDFaZXphMEJTb0ZrZFFpdmxTcVpvbzlEVFFRcllBSVIx?=
 =?utf-8?B?ak9kdFNjdW9KOE5wSHlvVE42d0VjejRhWHkwUUp4YkEzR2NWRGJrcS9EbzAz?=
 =?utf-8?B?L1IrNFlYcXhVSGNlU1k4OXhVKzRPSDFZSjVDUVR4TXZWZFg2UW1KQlNueUZ0?=
 =?utf-8?B?Q3hXUkN4SFNqV1AyakI4SjduUzRnR0pMUXNNNnpSbng2cExLSGpnSjQxV1lE?=
 =?utf-8?B?dUt5SEdtZVBvTFFwR3B0MkZvNm1rZnpWc2JFWDh3REVyQmVsSFQxY1dXdkJH?=
 =?utf-8?B?eTBnb3dvNGdFNWpsYjdqNDBnS1NRcTBqY3VHTTZFVEZpbVpwOEtncHJQSFU2?=
 =?utf-8?B?Vkc2Z0FuMFM3WGNUdTcrbW9YSDdka0VyQm5VdzdYUlNETW9wOHdTZW85OFlO?=
 =?utf-8?B?LzBkUXh3WmlYRHZUOUVHWVMxaEdnZjl4aGNRakZZRElIWnZzZllCTzM1Rm5t?=
 =?utf-8?B?YkdOajQ4elJjTG03UXpRWnpXSUlpbmR3azY4M1VNdzJlbENnZStBbDFVWTZO?=
 =?utf-8?B?N1JOdVcxTVNQc29LZDFrVVNLOGk0WDJlZ1RwTVJTcU5CYUlnUXlZeEJyRnJU?=
 =?utf-8?B?SGtNaTdjWWY1ZTEyblVJUU9UVGtvbzl2aVdxMHNBNndDYWI2Zm95eEx6bEhi?=
 =?utf-8?B?OVkyRyt6MDY3SjZKMjRwdjJhVjZMcUZsZkttMC95YVBlR1BTcG8zUkg5YmFn?=
 =?utf-8?B?N010YTFmcmZXWDNPa2NpWUtPWnZLSm04QmlVR0EzUUZhNWlUQUZ4aEk1Zk5R?=
 =?utf-8?B?YTBZc3JDSkRKUm5Cc1RRbFhmNEV3TkdsKzdMK2hNUVI4Z29OOXdhL1hCTFJt?=
 =?utf-8?B?aUJHMlYrQW1qSlBSYXZhS3gweXNaMDVGbnU5VHZqbk1KR1hNeEpSd3hHd3Ew?=
 =?utf-8?B?SnhkSnlGVGx5WHVxaUJWeFhNaFl4QUFGVjN4L2U2WjZ1VUV5SFNSUit3VlB1?=
 =?utf-8?B?RnROWDZvVkZUcjQveERYYTJCZTZkd2xBSjZHVGIyVzdlWlNHK0ppcTh6UEpG?=
 =?utf-8?B?ZU5nSW1KbUFRTGdkalMzQWErMzliTFRDSjRBc0taNEhTYkNvMkk1YkZ5THpB?=
 =?utf-8?B?L3BPMmd6RGlENXJqZkpQdDZreFhJUmRtVGw5V1pKSXNObGdxVTBaMFpUa0ZQ?=
 =?utf-8?B?RDQxZ29MNGMrdGlTK2d6bkttZzNLKzN1SmZRRThKczRPNnVIUG5RVjhMcDVs?=
 =?utf-8?B?L21ZOThSY1VnRy90OHdyWUEwVEtiV0NuR0hOcENVNGYzUkZpN2ZCZXdkUE5I?=
 =?utf-8?B?KzlBYXRJdDdqUnJtZ0xNeVFRY0o5d1JEYmlKL0xYejZXa0VzUTZCQ2pHVzZP?=
 =?utf-8?B?T3gvOW9xenF2ZE9ZdFpkaHBCMG1ITDAvRXZxZFR6TktCejhjWWxET21XVklt?=
 =?utf-8?B?bVYwYkZMSkljU2NmWjlKa1pwSUpBaHlpaS95TC9nVldNSVB5QWVIaWpqa1NE?=
 =?utf-8?B?N080YlM2YjBSUFZEbXJoN1JUZ0VuaG5TczF4WkRCWnlycDd6cXUxTWRqaGVN?=
 =?utf-8?B?ZkhYbUxISUU0S1ZjOTJ2Ym8ydDBGY0NaRXlSOExqWE43eWJMTDhTN0Y3eEFM?=
 =?utf-8?B?MEJjRUowV0pFSkdEd01yWUVVRjNPbVlkcVpUQnpMT2Z1MHJEVEdrcHpzalhh?=
 =?utf-8?B?YmJFRVNqUG96cWorSEptdUJPWDQ3Wnc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935dfef2-07c4-449d-4597-08db51ce98c2
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 03:19:57.2890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR01MB4486
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/11/2023 6:15 AM, Andrew Lunn wrote:
>> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
>> +{
>> +	struct gpio_desc *reset;
>> +
>> +	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
>> +	if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
>> +		return;
>> +
>> +	usleep_range(100, 200);
>> +	gpiod_set_value_cansleep(reset, 0);
>> +	/*Release the reset pin,it needs to be registered with the PHY.*/
>> +	gpiod_put(reset);
> You are still putting it into reset, and then taking it out of
> reset. This is what i said should not be done. Please only take it out
> of reset if it is in reset.
>
> Also, you ignored my comments about delay after reset.
>
> Documentation/devicetree/bindings/net/ethernet-phy.yaml says:
>
>    reset-gpios:
>      maxItems: 1
>      description:
>        The GPIO phandle and specifier for the PHY reset signal.
>
>    reset-assert-us:
>      description:
>        Delay after the reset was asserted in microseconds. If this
>        property is missing the delay will be skipped.
>
>    reset-deassert-us:
>      description:
>        Delay after the reset was deasserted in microseconds. If
>        this property is missing the delay will be skipped.
>
> You are deasserting the reset, so you should look for this property,
> and if it is there, delay for that amount. Some PHYs take a while
> before they will respond on the bus.
I'm very sorry, I forgot. Thank you
>         Andrew


