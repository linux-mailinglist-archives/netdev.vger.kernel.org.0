Return-Path: <netdev+bounces-1654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E50D6FEA13
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87530281660
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974601773B;
	Thu, 11 May 2023 03:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E02428E7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:17:17 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2046.outbound.protection.outlook.com [40.92.107.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A8D4230;
	Wed, 10 May 2023 20:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdzI+JILhAZm1FK5eCYlc6YgiDFcbvlZfn/OCKnMdReVq9YnA/Ei5sb9YZDcqnEwY6zohYmoLXK/4fiz/GctJbpOzHvW8B3aAoB2zgz2kh44OjMddUQ7VXW7PqZN99bniKS3OAZ3AD5iOjB4qFOLW+K5E257ii9BbGl/mmfNVfFkVi+uo1PuEaznoPhqX9Efw8rL8F57/lC1bKd07hDrE8asiFw3x69Z9XW976QdjPSl64Uok8FKzXHR41qdfLe49W88pUJb63i/M2FxmVGm+HFwiQxRQFYJtoWwkJhmLqMX/cnOZLEY+Wxw0v0A3vud/2kK/3vrNpK1CqK0LTTulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCq7AIj7Rkd+59By2ou4H55UQRh/tHJ/x5HWhqIRRok=;
 b=KQ9aWsQdkEKlUQ++HbmvQGicYcEXuAwqfRLTh+niIY2SIZa99x5APFzKoCxuatd6Wu4xB3dSqscHNU1BMD9hj51yiKT+xFyQoSlGnm2Bq9LtggYg/1haerm9VLJ1aSfY5uqPVVRYwYtnFRyn+UPDHh5/fIDDvvgxm4DtBeMaJxEZBcXMfy6cIr+cTQSibj6VyfwxDhrSzmoynwF8pRIEZU9OWzFv1Eme317ICL31gQQyhI/jO2a+827CyIKo3xMTcwPnFVAGOLCVtOdzFEFn7lfFt1Q4spZqWhAo6y9YIOUf9V+HBsCTrv0hCEe7c1K2MPY5Bglhzhbo8jqB9WuvGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCq7AIj7Rkd+59By2ou4H55UQRh/tHJ/x5HWhqIRRok=;
 b=bl+7nCcTrQog0DQ2XsuXr+7+OJnnoPNo6vRnMBmAfzPk37WySinEGvkql7U0+uU436MBos3xjD+TJJXpwOMaOxCyfrIOfev4JUZy2aDB8Di8EV4yS60/Ayl4Oj0qVw5mxT8YfOXY2JScYZ9NMSheg5nqaymzUDtDRmhevg18s1ZBAYTrXsiRLkp9mibcMgTZbS9qu43/ziCg5+qRM5CdSnx8iwIIDFSn5cBGeBN6hTuNevKflECdvqZkjoNcvw9Dgcnv3x2HBZto92Tx/LR2XV1eZQjqEgFr4UKNx9npwA6dAuPAYurYvMSGnuBnTqf9KvREQnq4XYPcZEDjKcoapg==
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12) by PUZPR01MB4932.apcprd01.prod.exchangelabs.com
 (2603:1096:301:f3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Thu, 11 May
 2023 03:16:56 +0000
Received: from KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821]) by KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 ([fe80::93cb:1631:4c4c:1821%4]) with mapi id 15.20.6387.018; Thu, 11 May 2023
 03:16:56 +0000
Message-ID:
 <KL1PR01MB54486E8738DC81E062BA2D0EE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Date: Thu, 11 May 2023 11:16:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2] net: mdiobus: Add a function to deassert reset
To: Alexander Stein <alexander.stein@ew.tq-group.com>, andrew@lunn.ch
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch>
 <KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <9107661.CDJkKcVGEf@steina-w>
From: Yan Wang <rk.code@outlook.com>
In-Reply-To: <9107661.CDJkKcVGEf@steina-w>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN: [Q7JojGAbaI9VqIvq83L5ApDzpGMsV/RYYKmLKjlqzwI=]
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To KL1PR01MB5448.apcprd01.prod.exchangelabs.com
 (2603:1096:820:9a::12)
X-Microsoft-Original-Message-ID:
 <2591cbd3-5bc1-515a-a157-8a51dc321e13@outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR01MB5448:EE_|PUZPR01MB4932:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fe48ab3-4447-477a-bfd8-08db51ce2cf2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gqsTBqNZ+6YT44/twAgBfZbZHnoqV165z4ctIl8CfiaggZaSLb8prtqU/PshyLlkXNYpfQ+vSxI4ec5cGkc5kAb82hpnAWg9px5fwLJfC6E92h+UlLxGqJSd4YBCEjZpmJhnXmO66OsPMhBcJH35mOnlkTzQKatc+Plo6DGdDuaLxEG/wB6ecL6am/3rt/ByaJJ0ZPJ3fSti1yLCtG/caOXj7h8/zWJ4H16IdTPqXJhuyl3OtZIVz4Uq/MVd5INPOctssVV1SPAMJjW69fkfvSYeq4JFbRIrTsbIdYY0Dn1zEoqxhbRtY91I7eGoCb8WkHwcdjwXyS+2m8D45ipfT6OisWuYY8ERNct+77ftlvNRNvH+8bfaci5vKNQIcaeUJ1Lp+OyXjubvts52iTXSrgthdaPtnrv1yt1KHmsWJmrWeFBRNusUIU0Ry8qF9r7hGvKF15KpdTBJiCVqGkxGhCcpmaWbl+yrpjlQdBkMfvAo3m6cM9st6a9eBXuBMYd0eYpT58U5fzkVRejClM4WO6zvD9OcMb9I5xhW7zj0M8CLqTILIAwYvfqP4WMlpb70UDxlDn7qJ4A7r+WJgdL/2wNJ6i7aRGfDY61mp7usI1c=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3JxOXlSS3ByLy80Q3Jwai82YW45a1ZQamRjWmwvSkhLUXNiOFVqand5WVRW?=
 =?utf-8?B?Q1JDVmpyZXFpYkxNenZzaDMzejhjaFljVExIYVlTRGg2aFdFdVdNM09Rd2p5?=
 =?utf-8?B?VVFyV1c1SnlIaW1HcHRobU9qRXYzVzloQXB6MUhtV1RLNTdDVlpBUnltc2ND?=
 =?utf-8?B?Y3NrdkZqd0RCZVhVeGZzRlB1czdSVXdOSm1WaWE0MXdscG03OEoycXJNaE0y?=
 =?utf-8?B?Qkd1ZW96bUp5bU5Rcm1kdXZ2LzhrNWptOHh1QzBjWjc5SnBYeXZHZFFyWXlj?=
 =?utf-8?B?L3pmVlEydEg0aHMxNm4wdDZBazJuQloyOEI2YVdHV2xqQ0FpZE4vcm4rVk9D?=
 =?utf-8?B?NXlLdXNzUnVqdG9MSXpiWldoeVlmcDE0NU9Ba3BINFQvNmJlK21ya0J4QzFh?=
 =?utf-8?B?R2tKbHFGRW1ZL2Y4MHViRnIrcE5qeTRqUjlMM3RCaFhMaDZFbVYzVHhONXBa?=
 =?utf-8?B?UkpndCtlOUNhS3hJUGNzSHdNdmV3dE5ub3VMTXBOZXQ2NUtXMWVWcDFPb1JQ?=
 =?utf-8?B?UWhWV3lQdGlGWDZlcTk3Q1NyWWw2cWlHei92QVA3bkdrVFhiL3dUMDZiUnlR?=
 =?utf-8?B?Z1pKTG5LT3JYL3hBeW0vbVFHQ0lSUmxwWFBVei9hS0JNb0ROazFjUDJVVnMy?=
 =?utf-8?B?ZGpyRXUwZ0swdTM1UXFYR0xTVVFOeVFHWEovZ21YeHpaLzFMSlp0M3I1cUxr?=
 =?utf-8?B?OHhkWFJmbVpzamplM3kvYzJjSEVOVjhmRUU0bTBrZElEdExaSEVWQnBTZ0hw?=
 =?utf-8?B?enlKSW83cGRleE05VHhwbGVOZlJ4dWVwTFhYdEkwc0lsY2FQVFNPWXpzZGY1?=
 =?utf-8?B?dXFRQ3dHOE4yQWpPRDZ2RzJiTGJyRTJpZkxSY0tJZy9OdDlKK1B6T2hzd0x4?=
 =?utf-8?B?T2k0RTBpdURhNDN2czZ1Y2wwTGFKZ3hGYVk5dXZwSEtvTFYzZ05xQTVlQlhG?=
 =?utf-8?B?T05TZC9XekRwM0h5emZuMFpGZzRYRk9OeGpPcEh5emlpczVlSTlWeVA1ckQr?=
 =?utf-8?B?bUxQT3dGc05FT2Z4ZXRvMk14QmkzYjRRbXd4STZVYUpESWU5ejYrZDJ4QnBW?=
 =?utf-8?B?Vm16dFNScm01UzhpaEF4OWNja0NibllyVHN3MnhsSDR0d0ZqRElwbWdseGZB?=
 =?utf-8?B?N1RMbGVJZWVZMjZBMlpDMmVVWE8vMDFqenRlbHJnaXFSVEpHOWFKcHAycm54?=
 =?utf-8?B?Sk5vZDQrbWRGUFFKOTJSeVFLdVpnM29NbUdYODZ0aFpxWmxoOFVscUQ1NFZT?=
 =?utf-8?B?Q3hSMEhQTzFqRUloNEhPWlZERmhWSjgzcExXeXd2amVseHMvVENEUTFacDBB?=
 =?utf-8?B?Z0krTFJ2ajFuaUd2cHRrVXZjSTJ4dUpBQ2QxOGZsd0pUSk9OZjhzNk1jcHZS?=
 =?utf-8?B?T1NLL045OVp4R0xVTTN2OWc5c1FuOTFVOXFnM0I3bkJXU1B5VmlISzVOYysz?=
 =?utf-8?B?TmRsUDVtQXJuZzBzZE4yNnJWOTQxcE1lRks0Y3MxV2hZNWpOSmR0UGJOMzR0?=
 =?utf-8?B?Q0duZy9EV28wK1NtOElWaXRlS2RDcXhRKzlORUIvUmtwRlVTUnh0d3VQYUtI?=
 =?utf-8?B?S3lFSkhUVjVvT0dFYTkxOTFlMWFEL0dTTm1GbERkSHdzUmEyZ2xHakxkS1ZB?=
 =?utf-8?B?Vi8wUEpwTE83R1U1RGV4dzA1dnQvdUE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe48ab3-4447-477a-bfd8-08db51ce2cf2
X-MS-Exchange-CrossTenant-AuthSource: KL1PR01MB5448.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 03:16:56.4654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR01MB4932
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/10/2023 7:55 PM, Alexander Stein wrote:
> Am Mittwoch, 10. Mai 2023, 10:02:52 CEST schrieb Yan Wang:
>> It is possible to mount multiple sub-devices on the mido bus.
> mdio bus
Yes, misspelled.
>> The hardware power-on does not necessarily reset these devices.
>> The device may be in an uncertain state, causing the device's ID
>> to be scanned.
>>
>> So, before adding a reset to the scan, make sure the device is in
>> normal working mode.
>>
>> I found that the subsequent drive registers the reset pin into the
>> structure of the sub-device to prevent conflicts, so release the
>> reset pin.
>>
>> Signed-off-by: Yan Wang <rk.code@outlook.com>
> We had similar cases where the (single) PHY was in reset during Linux boot.
> Should you be able to make this work by using a "ethernet-phy-id%4x.%4x"
> compatible? See also [1]
>
> [1] https://lkml.org/lkml/2020/10/28/1139
Well, I've seen the [1] before, this method may mask some issues. For 
example ,if I use
another type of phy ,I have to modify the DT, Is it very cumbersome?
>> ---
>> v2:
>>    - fixed commit message
>>    - Using gpiod_ replace gpio_
>> v1:
>> https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR01M
>> B5448.apcprd01.prod.exchangelabs.com/ - Incorrect description of commit
>> message.
>>    - The gpio-api too old
>> ---
>>   drivers/net/mdio/fwnode_mdio.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
>> index 1183ef5e203e..6695848b8ef2 100644
>> --- a/drivers/net/mdio/fwnode_mdio.c
>> +++ b/drivers/net/mdio/fwnode_mdio.c
>> @@ -57,6 +57,20 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
>> return register_mii_timestamper(arg.np, arg.args[0]);
>>   }
>>
>> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
>> +{
>> +	struct gpio_desc *reset;
>> +
>> +	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH,
> NULL);
>> +	if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
> How are you dealing with EPROBE_DEFER if the reset line is e.g. attached to an
> i2c expander, which is to be probed later on?
Thank you ,The logic is wrong,trying to fix it.
>> +		return;
>> +
>> +	usleep_range(100, 200);
> How do you know a PHY's reset pulse width?
>
>> +	gpiod_set_value_cansleep(reset, 0);
> What about post-reset stabilization times before MDIO access is allowed?
yes,I need to get reset pulse width and post-reset stabilization times 
from reset-assert-us and  reset-deassert-us. right?
>> +	/*Release the reset pin,it needs to be registered with the PHY.*/
> /* Release [...] PHY. */
>
> Best regards,
> Alexander
Thank you for your support.
>> +	gpiod_put(reset);
>> +}
>> +
>>   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>>   				       struct phy_device *phy,
>>   				       struct fwnode_handle *child,
> u32 addr)
>> @@ -119,6 +133,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>>   	u32 phy_id;
>>   	int rc;
>>
>> +	fwnode_mdiobus_pre_enable_phy(child);
>> +
>>   	psec = fwnode_find_pse_control(child);
>>   	if (IS_ERR(psec))
>>   		return PTR_ERR(psec);
>


