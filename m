Return-Path: <netdev+bounces-2096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDA97003BC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A6661C2116D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1974BE5D;
	Fri, 12 May 2023 09:29:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45B3BE5C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:29:00 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2109.outbound.protection.outlook.com [40.92.52.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F04B9;
	Fri, 12 May 2023 02:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUr7YFaWRjAzwX3AS8Dd9dsYevOGtqc5r3iAh5rADMam0P6QpxTH3HtVHkcMcyZVHdgf8ao66BCBwTLYjiUgnTRiIw0sQ8glFWGKdqHUVk1r79UwM5UGcOBfgsF8IYJZCenP5xObxfn/Kd9+WlXM55PNHmghOPA3qT7+4ZgPa3qLVFh59DdOjPwSyUVvd9FB3Sb17BsUs8DEimKG3u6bmWx20WqsS/BZMsuykjAefs3hDDeea5KCr3AjHuToi9At6EE4uh9xJwtdRAky8NU50wA2bZEf50JMzIzd2wkv4YY4SUvCygES2O6g1casBPDmDSU1Drb8GfV4+fcVEH+A6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwYIf4TyttllzKKaZbpdPCQAKhoGTt529yNl8eOTAOI=;
 b=C5e1kznxX/uzQ6m+GITcvizTBTjMAOolqa4DdcIlma1WgpeUYQzUXLu4dZdjxHnwf4+mCBqF98+NPA/BaaKvdVjDym5UW/UVDlZlQZHuADIlZlqxoMdPZx537QeegO44h4mIBENcZDcK/Cf5Ph49DpI0cWQtb0hFc6Go/VmCP6FbeSBJf+1/uTWdHxg9JtfzqQETe+FsfvVyMSlXWoPpHcYtDujjsyZVeuGKfLfJ0oHyI79+pQIONJnrbTOj9/HRY3Y+wJWfWQe3GoFk4ruGavXQMdIeWf93QQEoJd7KsbScw6JjIuvwjjrSW9HscozQzEq8p7v9LIw3K4vfGde7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwYIf4TyttllzKKaZbpdPCQAKhoGTt529yNl8eOTAOI=;
 b=B0t7W6arvMhMtaWjl5V0myfvfyHLMiz8J5WBIZITFBNGSnPJltGvxwidkfquTmbTScJfv9TmVknAYyv/J/8tX8uRAq7ps/BhrMotantNSpCqo7sZxzDxHZPMGBUulE2//tJGCc2EavM1S7ZvhGfL9Nmt3EeHfzuRORSJgKH/5NrqHWcAgz9KdCY1CjU2+R/GH7+W6dPisjOfbwaL6bJ1dJWrF+rxwwkdpq8VaLXOaBU+HrQ/e3kC0r3zFpY4dQLNDbxdevgeTap1mvARkW4XbpZ6LVkNNgaeDbgPKHB/oCBMxKuH8WSp/r/ic/GJAs+hh5wBJkvZ551JHM6fNuXTsg==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by JH0PR01MB5708.apcprd01.prod.exchangelabs.com
 (2603:1096:990:11::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 09:28:54 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 09:28:54 +0000
Message-ID:
 <KL1PR01MB54488021E5650ED8A203057FE6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Date: Fri, 12 May 2023 17:28:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5] net: mdiobus: Add a function to deassert reset
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <KL1PR01MB54486A247214CC72CAB5A433E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <ZF4AjX6csKkVJzht@shell.armlinux.org.uk>
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <ZF4AjX6csKkVJzht@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [7hdJPv3gWsM6dVisk/UnX6uwCH4g0O7NV5E85l51d1E=]
X-ClientProxiedBy: TYCP286CA0047.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::18) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <987e4c9f-6eaf-935c-6183-d574fbfba35b@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|JH0PR01MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: faec82a0-4b30-4c62-4d11-08db52cb4df8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PVdk6HvBOSIxT7AZxekJyFrzJH6jRB6APLGD5gAQT3prboMl2iCmlYqL/Jxgq0n2DjVDrO4xW8TssILU0fRBCEKj2hTUekc5GpAeWQx08a3y6Nctd1ddluCjVBOJJ7SyGGOtI/MyOBuVORoLCeHxmJQTkvxLwccWY3wEVbGcwYl9t+BDsJD7WrPz6nGOjkgLmUYKoAwNiVe76DmCCp4fA+BpvClx3Hdh81DDy2XPacGUKHB39tuLXLQP3eL+pi+FbWAzwMl+4nBApFMt+aPScUxEB/gvpRF7Vqmp9eC000VC69noD4qfC3HZA6x62ieyyQ/cprIsjViXsDZenDZVp/DYDlajXNQz2pLddWfyVnfzf6ihcx+w8QcSvDH2Fkxgj/N8k/cHT0ee22Ud+WP7BGX/INTLf832nSI8JiL+kiTzjJRz/DtGaR1GYh5jdra+4KeiJcbJy4O9P8dU0PxHyZG1UnJ2GzT6L8ONnnevZ9mdP9vwKc8akv7qKQPLSxKFZem+GATXjGbnO2zWaT5A7/TtBTilCPnHdEbirIETcU4ixCZXLhH+5h7pa/KF9AApYlsOSPIq0UokSjD19jgU7EjlzrIMsa3PWQpuxOlmVixqUJGAcVqGnHLUnX2DR1L5
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE9CQXF4TXJlNVEzVHFCZTd1QnpJWUtpbzFXeU8rcFRkYUlvSURMNGk4VmM3?=
 =?utf-8?B?WE9yeHdXV1NadW9XUVRTYXZuTHljbmx1d3ZDR0tBR3FKOFdzVVhDajEySldl?=
 =?utf-8?B?T1IzMEhQTExBRFZIRG95UVRwTGVZL29TU1FNSkkzU0d3VEFobEN4RTNCMXA5?=
 =?utf-8?B?NHd4YkRESDBoZVp0RjlMaWszYjc2QzUrQ1cyeEUrZnhXQ0dDMzNYd21ISUh3?=
 =?utf-8?B?VGc3MUVGZHZjNktpMng2STNLYWxsejRBS2I4Z2lmSGd1bUFrVFo3S1BCbHVq?=
 =?utf-8?B?R29SOGEvNHJMc1ZQUEsyMzJxckxiRUtxWFJhemxtSW9YUk9aU1pla3pqaFJo?=
 =?utf-8?B?MTRFeGtEZC8wRnEzcVN3cHlpMUlZQU1zZ0N1M3RFaG1uZk9UR0ZYMkloLzI0?=
 =?utf-8?B?YzJVbnQ2aGRuMXRuV3NOMkpYYUo4ZGZJRHcrR0MzV2NXbkVVSWRmeUpkQVQz?=
 =?utf-8?B?SDlaSVN0TU9IN2UrWVk4c2kzVGs4aUxPWmZSZGdZMFQ5b3BiUW40RUJqZk5n?=
 =?utf-8?B?Q0xRendXaTRwa1Y4VWR5RVEwcno4Rnk0QVZvejRmNUhhSkludE5FRnF1ZkU4?=
 =?utf-8?B?RUZPeEw2aGZMSzVWVjRzaGt3UnJtVHJHT2gxNTBMTXpLWG9jVWYzbFVzbW13?=
 =?utf-8?B?MWZoTkc2SXhscVBBV3h0YVJlbmJXb1NtM1dYWVFzU2lHZGJrbGFpamxtMnIz?=
 =?utf-8?B?K3FCcTBpajlmZDYvRzlKb1h4azIybTlibWY2R2hUeElienhkQWVCYklBeU1j?=
 =?utf-8?B?TnFaZkVONGU0ZVBQQU1sWmJIVExicytJK0s0dmR1dzRYY0g0emljdENhcE92?=
 =?utf-8?B?aHQxV09sdytleDBlK1VlaG9mVjlqTTBYOUM4WnJVd2FCWUFOQkFSVmtiWjFu?=
 =?utf-8?B?QzlkUDVtRTd5U3dUaXd2cWdTdDVOOC9QVDdQWFd6UVl1N01PSk5OOXZYb3J2?=
 =?utf-8?B?ekczRjdKcS9semZyamJZYzFHdGxaaFVkalozcjZNK3dVanpwcW5YYlJ5clF1?=
 =?utf-8?B?WFI0ajBMWHZmZzdRa1ZnZThQS1FhT0ZDQUVCRGhSVXh6MTRlRS9ZM0N5M0lu?=
 =?utf-8?B?WVNGSjluVW5GOG9pbksrZEloYlZEdWtLNERzdzlUL0xxeWdOamQrb0cySlFj?=
 =?utf-8?B?emRZaUhCSlZHNGhZNC94aVNFa1hJZ3owbmRSWXZXdWQwNzZaS0NVTklhYk5p?=
 =?utf-8?B?aGxoL0xkTkpIaDdpcms3MnZreVJYd1BTTGEwYWR4S05QYk44T1Q0T3hXZzhQ?=
 =?utf-8?B?bXlyWGx5VUdrMnB6ME9VY0xzUUQ3VkdNWmRteVplNzc1YWNkUFRidFBCZURa?=
 =?utf-8?B?bjlWM3I4V1FVeVBkRTJHUnQyNE5MRUkvUFZnNE9YdzFiU0U4Zk5VTE9Zem1j?=
 =?utf-8?B?R2JoN0tZQ2pXNURkUi9LWnVVWlV1OTMyMnRPbFpJNnZZOCtxdXBjWG1Gc3NU?=
 =?utf-8?B?UUY4ZU8waVhXb2RxTHRiOUJ1Y3lKemN0N1pMMWtuN2d1eEtLUjYyME84RmpG?=
 =?utf-8?B?eThGbzlNdlA3RnVzajZXTTM5QnBMYWcyY0NUOW5UR3FNcENucHRic21MajV2?=
 =?utf-8?B?RXNaNmtvL0M2c2kwTzIxeEJjRjhGQVBlbUNFeVJNdDExRzdpNUR3TFVmTUhv?=
 =?utf-8?B?YU9aaE1MWVBCb25IeXR0b005ZDEyMEE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faec82a0-4b30-4c62-4d11-08db52cb4df8
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 09:28:54.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR01MB5708
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/12/2023 5:02 PM, Russell King (Oracle) wrote:
> On Fri, May 12, 2023 at 03:08:53PM +0800, Yan Wang wrote:
>> +	gpiod_set_value_cansleep(reset, gpiod_is_active_low(reset));
>> +	fsleep(reset_assert_delay);
>> +	gpiod_set_value_cansleep(reset, !gpiod_is_active_low(reset));
> Andrew, one of the phylib maintainers and thus is responsible for code
> in the area you are touching. Andrew has complained about the above
> which asserts and then deasserts reset on two occasions now, explained
> why it is wrong, but still the code persists in doing this.
>
> I am going to add my voice as another phylib maintainer to this and say
> NO to this code, for the exact same reasons that Andrew has given.
>
> You now have two people responsible for the code in question telling
> you that this is the wrong approach.
>
> Until this is addressed in some way, it is pointless you posting
> another version of this patch.
>
> Thanks.
>
I'm very sorry, I didn't have their previous intention.
The meaning of the two assertions is reset and reset release.
If you believe this is the wrong method, please ignore it.

