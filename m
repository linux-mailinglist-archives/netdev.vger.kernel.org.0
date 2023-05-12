Return-Path: <netdev+bounces-2006-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 509C06FFF1C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FD292819B5
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE857F6;
	Fri, 12 May 2023 02:57:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C617E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:57:42 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2025.outbound.protection.outlook.com [40.92.53.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8862810CE;
	Thu, 11 May 2023 19:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoEIwjWrNrCuG+rZ5611OfwPDQhZBNch7HUG2fDnRR2fsUIcznh/3T5G/v72pji7WaSDF4QcPWkNCuTyuS5LQHfs2LNBlnZf9zk6588mYY4UFTJPXluEDtLBXh1JQCmQyilWyNWHs4Ggs2EsNl9btvq9fvpzQ26WmkvshA9YBYiHqGCSxH2W2IL0QoTEzoyeb7b8QAVm99F+LKj2EzPsMVBI3l3vZjg0cPVKW2tSsHetPNdyE4XETfvTNy7TRMRTVk92qlfZ6uwjrjDeA+z24ek+qI2rnhE+8GLCZ/iMo4hYQqtwrK7Ti7gbECvqYiSbr5kwHL3R+lHQBwt6Xhr+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNk/I1z9hwZOPuB74PxGI+L5b8YjY8/QMP9Pkar9Wog=;
 b=mhAU2F+Rt/awDweRqf5i+tO3YbLomct3GaFbpK7ZyIgcNYZ21uyem6kuylpL5fgmqoeVpn4ebtF7pi3TJR9Z0Mnjr9Ycwm7ydIsQkDu/xoYD0kIFEvNnDeqMpfdBCERUtL8NFbQ1Vb7sptYce7clGBG3yN8bCOCOX5HVCAZRBuxhIm2dFmtxVTr0ATr4EID7k/fjfay/f3dtbrLb/dky6786zwwbtn20MKijpAQ+679bEXwtwWmQBBOQuzBAGNA3NmivnsLb2s42b4miUGC01PpzjuLIWzVlYyU6vIqte5eUctKz58dez1aDNYUI7A9+t79XkXHJ8uoXvUvRXdEXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNk/I1z9hwZOPuB74PxGI+L5b8YjY8/QMP9Pkar9Wog=;
 b=tLJBWtcp/T/52BzcbbwvvhO9+ct/1Zj4YtYvztYu1cj0rSDZL6/DxTatzO1hsB7ILccw0HXPAvSMsViykz/v6Tc+7uN4VszKAn5rJU7jap6bWe5jpqwTfBetPbKybDcxCfwrynC0ZRQpDDw+uAyf5GPJJQMxhU6wzZVe6aFuHGnGCpc6rEqnujCcocUfuwVN18r4fFc708tQrFcqrGwFPBUGo33k1d7AFx+dPWko4kwijji/V04SchAvWrifgjdstaOWu+yn3Ryh/HwfZ73Bfsm6drMUXedmKvNdeGghHS2qwpz7HI4smUKiPXvD1Rjq9HSc23o9aFxHYEff+bvj3A==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by KL1PR01MB4912.apcprd01.prod.exchangelabs.com
 (2603:1096:820:bb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Fri, 12 May
 2023 02:57:34 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Fri, 12 May 2023
 02:57:34 +0000
Message-ID:
 <KL1PR01MB5448B438410FAB31E5FC3F65E6759@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Date: Fri, 12 May 2023 10:57:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v4] net: mdiobus: Add a function to deassert reset
To: Simon Horman <simon.horman@corigine.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux@armlinux.org.uk
References: <KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <ZFziRIzP/sXZMgiU@corigine.com>
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <ZFziRIzP/sXZMgiU@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [3yq7I4c+hXo189i2G+rGdGf/RhqslXSOjb55UzlOquE=]
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <aee9a194-5c67-e9ba-7b79-c235aa8921a8@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|KL1PR01MB4912:EE_
X-MS-Office365-Filtering-Correlation-Id: dd034912-9b3b-4db8-6b86-08db5294a2c4
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hY8X8mevwVvTO62JkwdgG25P7Eq0/mbV4lQowhQ83kqeZPQG7Af9q/qH7Xy8pJCBnUD5MuO1pO7HZqpXwJsZu4mXgzEXB9XjlBelNaN2mFNP/sCAgc9SynUyrWF35g9lSodbiRmOtaXrIwtwHkQvZGy0jaTvFjOMhqQiw+ebGbwBcGkR/nNHj74Cwl+3YhRu111i8Wtv7kOu/sFXvDfsqERzF6prp8KCvT1mp44WMqNVkQM957YLXuPAsXo1fhdJbhreiDTpgRVLvGNIFONUWB5gwLa0+GOlVv+mSPBAB29NyvTIS79lO2SsQzm+Fr7I6dJFetb/4Y1GZe52JUSGJbqrSZndEI98fJKs9HfCSlh1xFhpkMQvVD+diYfzzyLIOt93CESVdPZFWRct5tCm66ABF7nqN1L1BCA/t5BksWzviYVV++Lc/y0wNP28Odt1qjUjbm5KBS4sICfEgUoj/z0ka/+988Qwqq85ioMyuH0xUOFQZJyDpKdMX6CwECWxC9KmVfifpjNtaCDsD5w2Uh6YNTtcEJA0nDdsf1Xf6KCnsml1uLm5I/ZjZb6nLMWDxHSS+UOy+IjngeAd361L8Vypo0fvn12TLc9JdcT3tsQ=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bndCOFhtbUhEaEZHNS95M21QK1JtN0w5Ymt6ZFQyZTlZTUdYZEViclpJRHkx?=
 =?utf-8?B?dmxtcDFXeEx1WUh4OXAzRWI3d2hLQjM1OXFIbzhrSXNLek9sb3ZBTTZmM3RR?=
 =?utf-8?B?Ums1S0JyMFAwM3VvRGdrMjRsOEJmL2pmLzQzMUZtWEFFcWtLNVlRV0NUSVM0?=
 =?utf-8?B?OExzdElFdDFZT2d6bEFhR1oveXRQZFhnSGRtaE9JUk9HTmMzWTd2azl6MkVt?=
 =?utf-8?B?ajM1Y1Bjb0NkWlFoZnF3ajZvaWFpVjNIRU8zNlJqa2hTVjJTNGRZM0I5TTg5?=
 =?utf-8?B?YjVVNHQ5bG50U2hTMFZmQ0NKaXJTbFRMWEtRZ28xRFdQUlNTOTFRZDYySkZK?=
 =?utf-8?B?bGFXYkZJVGVOYTlQU0VUQzExVHEvcDZjNWFpeTJjd3MxdUszUXlqMGZVUlhi?=
 =?utf-8?B?dnhHVmNQVUhUVk4vaG9uaVM1S0o4bUc4NUFLaGpZejhhSG9CWDdZWDFmZmpn?=
 =?utf-8?B?UDBMZFJ5bFE3aWxlR1hGWlhDclZBZmFlS25qS1hIVnJZNk5qcXRvWHBrZVhZ?=
 =?utf-8?B?cEY1Nng0NkNjSXZPVjYwR0RFUXJINDJLMjNWVVAyMHdBL3VSM2MxRXh6ZEdH?=
 =?utf-8?B?QUhieEZVc1JEbmFOYm9FV2h6cjQ5NlhIUGowT1VWb3psajZqTHl0K1hsQmx2?=
 =?utf-8?B?RldyU0VaeEdoLzJGWFh4Nnl5NGpmcWdaNlNWalV2bTMvMFRCaHFwUHJZdXN0?=
 =?utf-8?B?dWc2Y1dZaVNlK1A2NGxPMzhKTitkaFBQeDZPcXAzL1lwMXN0MFFOYnNrUG5H?=
 =?utf-8?B?WTdNaUJua0VxODZLbjhrS2YyVFhOVGtEVDhZakVKUGh5SkpOcGt2VHZKUmY1?=
 =?utf-8?B?SmVvOG9yTjYyKzZMOTIwaS9URFRsVEsrMXJQYkw1NW5TVDkvWGQrVFlXZ0l3?=
 =?utf-8?B?WGY4c2l6UTVtNVBQTmdET0RMcFNnNldqWlMrTDNQNGM0VHc2c1FRRGpya0VD?=
 =?utf-8?B?dStDL21ydzlITHoza2V2cWUxZEdkMmo5bm1CMWNSU3NMdkQ4NUVDYUlNenlS?=
 =?utf-8?B?UUhMK1IwYmQrQklhNTlvaTRlV2hyTVh4Y3dNbjVyWFNDekRIWnVRZHJ4WHdD?=
 =?utf-8?B?dDFWQ2RPVDNEZTVTZW85c1c5Z0RIZ09aZFlhb1Q2QnpVSjZHdDRwbG9GSmRG?=
 =?utf-8?B?WWxQWTdyOW9lSTkrVWx4MEc3Z3RlR1FMdUUvVStLc2pCVzJoMnpGdjFtTGk4?=
 =?utf-8?B?MnZNM3ViZVRsMzl4c3Vvay9VMTBsTzhseC9qWUx4OTFyVlBEMVJ4KzVuUjNk?=
 =?utf-8?B?N05jb1ZPQVREb2NoSzluaGJGTTZrWFlYQWJTb2d2MlFIWmJJQUM5VHAwdjRl?=
 =?utf-8?B?TFlsaU92cUtPMnhFOUV0ckZOZ29PUGpscm9xQnMvb2x4ODVtTURtMTZhNmhz?=
 =?utf-8?B?TlhYS3ByaHFoazVuUk12dWRwSTFGdU1BWXpvV0lHakxxZGdlbk1iL1BLUStk?=
 =?utf-8?B?Nk11UmVCMnBaUEF5b3kxR0ZNb1pLVmlOdlVwT1JrTXN3VTZzcHFkNHR4VGpq?=
 =?utf-8?B?UDhsdkdnYzRCancyOUtIczZkZldNRi9jbCtKZ0pnZURpaFlPWWYwUDZCOHFY?=
 =?utf-8?B?Sm9GeE4va2R4Mm5icXdrMHZFRXQ3MllYL2xNT0ljQVhnOHZSUDk0M3E1SDEw?=
 =?utf-8?B?WHlzMGUwMjc2UXl0V1c2N3AxODdrM0E9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd034912-9b3b-4db8-6b86-08db5294a2c4
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 02:57:34.4655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR01MB4912
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/11/2023 8:40 PM, Simon Horman wrote:
> On Thu, May 11, 2023 at 02:59:09PM +0800, Yan Wang wrote:
>> It is possible to mount multiple sub-devices on the mido bus.
>> The hardware power-on does not necessarily reset these devices.
>> The device may be in an uncertain state, causing the device's ID
>> to not be scanned.
>>
>> So,before adding a reset to the scan, make sure the device is in
>> normal working mode.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Link: https://lore.kernel.org/oe-kbuild-all/202305101702.4xW6vT72-lkp@intel.com/
>> Signed-off-by: Yan Wang <rk.code@outlook.com>
> ...
>
>> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
>> index 1183ef5e203e..9d7df6393059 100644
>> --- a/drivers/net/mdio/fwnode_mdio.c
>> +++ b/drivers/net/mdio/fwnode_mdio.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/of.h>
>>   #include <linux/phy.h>
>>   #include <linux/pse-pd/pse.h>
>> +#include <linux/gpio/consumer.h>
>>   
>>   MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
>>   MODULE_LICENSE("GPL");
>> @@ -57,6 +58,35 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
>>   	return register_mii_timestamper(arg.np, arg.args[0]);
>>   }
>>   
>> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
>> +{
>> +	struct gpio_desc *reset;
>> +	unsigned int reset_assert_delay;
>> +	unsigned int reset_deassert_delay;
> nit: Please arrange local variables for networking code in reverse xmas
>       tree order - longest line to shortest.
>
>> +
>> +	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_LOW, NULL);
>> +	if (IS_ERR(reset)) {
>> +		if (PTR_ERR(reset) == -EPROBE_DEFER)
>> +			pr_debug("%pOFn: %s: GPIOs not yet available, retry later\n",
>> +				 to_of_node(fwnode), __func__);
>> +		else
>> +			pr_err("%pOFn: %s: Can't get reset line property\n",
>> +			       to_of_node(fwnode), __func__);
>> +
>> +		return;
>> +	}
>> +	fwnode_property_read_u32(fwnode, "reset-assert-us",
>> +				 &reset_assert_delay);
>> +	fwnode_property_read_u32(fwnode, "reset-deassert-us",
>> +				 &reset_deassert_delay);
> Does the return value of fwnode_property_read_u32() need to be
> checked for errors?
>
>> +	gpiod_set_value_cansleep(reset, 1);
>> +	fsleep(reset_assert_delay);
>> +	gpiod_set_value_cansleep(reset, 0);
>> +	fsleep(reset_deassert_delay);
>> +	/*Release phy's reset line, mdiobus_register_gpiod() need to request it*/
> nit:
>
> 	/* Release phy's reset line, mdiobus_register_gpiod() needs to
> 	 * request it.
> 	 */

Thank you for your suggestion.

Best Regards
>> +	gpiod_put(reset);
>> +}
>> +
>>   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>>   				       struct phy_device *phy,
>>   				       struct fwnode_handle *child, u32 addr)
>> @@ -119,6 +149,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>>   	u32 phy_id;
>>   	int rc;
>>   
>> +	fwnode_mdiobus_pre_enable_phy(child);
>> +
>>   	psec = fwnode_find_pse_control(child);
>>   	if (IS_ERR(psec))
>>   		return PTR_ERR(psec);
>> -- 
>> 2.17.1
>>
>>


