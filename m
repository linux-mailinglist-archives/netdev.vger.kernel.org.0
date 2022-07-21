Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E66757D16F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiGUQZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiGUQY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:24:59 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2064.outbound.protection.outlook.com [40.107.20.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD8F88E1A;
        Thu, 21 Jul 2022 09:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEL2B7S1OsWfvaZBhAPP3IQYRSsv8I+vllWgFpL7hlpuzgykfZ2sta5ChchDeh6Zn/up385dgrxXjrp3vxYSSK9GuxFZIL7sY1g2ZnOGcF0EZoChBwKvW+OySiM+YbymXUnDE6f3YPoWRnf9C3FKHc8foUcOcPZlz1FZw/dhARGTfzQvrAiN8w+Xls9+m3YemSyXO6Vkj0Si9xa1euw9hzPS9x0/rwGrY3LUUNCLSlvspKXOmT+6KKjcvYFhjIskD2lubedkmh5awNdxagXlHxupYeH6g6mxOxrpAwyKchQBybOFU4rETc5rtHM0n6QaZC761QxpurP47X6aU/q6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSFGIEAwkGlZ7yN0rOdho6Z1JpUSYW1m/FJ2JAm9npM=;
 b=fCwadh80kYbvFl73TH5HZggt0E7G2om3IZSksZjmQj0q4FadwtKwvb4MhHQI3oMWPOKgCKA/pJHHaYaKd+dr2MVmtBcsdN7L5gsiz2qF49J1TeGoGa3MIE3OMeI9VOGo4XFVJ1CaS+KLuKJZNJfEC/IzkgltKCQKfNzFqPQiUbQsf+MYbz1ZllJKsuHjdilQfO5vzPUg738mAgSOsovTnKmT4PIL4dUa7NnVnbiGQlQSVWH2vi8MVueSJ8OJ97DJ32X/c5rBvOWKB3/djBY43P7w5k/S+7yJQF/9lcoFZdSgDIBs33AxqUaZx4NMsSXXyO0jEt/PA70kERE5+ELZgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSFGIEAwkGlZ7yN0rOdho6Z1JpUSYW1m/FJ2JAm9npM=;
 b=enTLRHv74Fbzed5Gcrg94Tkcb9Kks9Ii6WlSVDKjlmXHoWHWS3GbDBd60BjPacPS2yoe9YTG+aYDEWCDUv+cLjP+2eadp5GlJAV5Ym9KoDtlPHfUGxb08dx51R3YpgyG2Y3zsIY+y8H9atjrruSnLLBcVjaCmScYcUqUBiYTlj/tOwvBXUP1CK/xD9exxUovaxHLbbrqBRluyaXKtLLIXskHbNip9InEjTuXIEQ+21RwxVxZ9nrJ3k5fwFBYvckNlUYwRFHOCCdJTyDYX0QwZtl+37SOqpiHCf/ioYKCAie6CPCdBJzAwPUWdPItf/lXudgEYbtQExGi+tmSpbtyaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7043.eurprd03.prod.outlook.com (2603:10a6:20b:2de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 16:24:54 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 16:24:54 +0000
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on rate
 adaptation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-8-sean.anderson@seco.com>
 <YtelzB1uO0zACa42@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <91232aa9-2681-2910-f480-8fc75149a896@seco.com>
Date:   Thu, 21 Jul 2022 12:24:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtelzB1uO0zACa42@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:208:2be::31) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a2070ca-60f8-4905-b14d-08da6b358b4a
X-MS-TrafficTypeDiagnostic: AM9PR03MB7043:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GwuVVXwDbdCEPbHgvQ9q1Z61DLYGiAPPiUYIIZKGyn3lX00a9t6avFYZtyhnZSvlkXAmsvzhmT+k0DbfSel+nrUgTD6ulvxd7nYyblNVjGmL0m57HsgLRrNXTvVweBbOxtN3ASjJCaoe9gx+UmqjbeAo5G081d1F7prOe/9Qu2Op6bwlsOBRpVuxyd/nnFNU9GmcmcG/sp9pMXDB6O6oAsvRkqErxsS4HDKy/jZQUJUt6GzyMXzOHUCTPkWRZVA5RgmJYIh08g2hueIw429vC1mmcYSf3kWeXRn4drW9VG6W65xQ+8m4ZHuSxYTZ7G4s2cBnI535JIhBCwUiMTGZqwoPz1F78HWKXb9TG8SAZBgm3MRv6wSsg6+PButZ6Kbt1/C8OfEjdnQ/WcJjO3WnklIrdIaqRr6fS/29OOvh5bEd0LZXtrm+4CyXPYvWRbaMN4AUkwiWxQTHiYOyYhnULCdW5xVjxy2wZClojPWrHSbkjXgyBnlr6Bdb8jIhecyot/3xH8AnK/sxLoZVl9UPwj9AjkBRvTBHUkj5NWEFT3ZDUIaoVbiTgBCDfrNP1MNwBBPa0dHpEQ7z8xyPN9xfJItKj6nW/IUx4KTyqwV+31rWwHf6QEGvrNmFB8H8tfYIqDhKXUfZxXOSPoCPElGnG2ZhLtZQGFv0qqxvY0hcCQUCmelDUSYYRKhoHh/WTyhiNFw4tMmeTMgQxc5aoUVaZkpsq9BRyL82AdzvoogxBWFNWePAqojY4CPOcl0P5yu775IwMAajFclFDYgco0gwHElXe14gl+8d8BjWexwpznZ5UHBTY/dGiVgnUq4F/ubOLG+kSrxVM5OtxpExzAzvX9GrWwqBZM3QO2i58xbM934=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39850400004)(136003)(366004)(376002)(8936002)(38100700002)(36756003)(31696002)(5660300002)(38350700002)(186003)(86362001)(2616005)(31686004)(83380400001)(52116002)(6506007)(478600001)(6512007)(6486002)(54906003)(6666004)(316002)(41300700001)(7416002)(66946007)(66476007)(44832011)(8676002)(4326008)(66556008)(53546011)(2906002)(26005)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkQySklpVGllZ1kzcXdwMXI4VVl5b0lrNXRFaVJBMWVVWHYyNUI4WUgyRklz?=
 =?utf-8?B?NldBTDlaUGFyekdKSHl1eGZxZGZkWnpLdFFha2RVaXdBYXJPWHRtaDdZQW5C?=
 =?utf-8?B?R3F4VlFZWWYzUXJmVi8veVRvZUdmUjhTbTQra2cvSXRkb25YRkZaQXJRTFZF?=
 =?utf-8?B?Y0hTZGFPU0w4MCs4WXJ3ZGtXd29PRjdGQUZiS2xMMWpQUS8yVVRzL2FzOG9w?=
 =?utf-8?B?M0xKUGZoZ0RtSEJhVU5iUnF6Y1hLUjZOMVRaZExlZWFQOEhVWUVoUGJ4WGd5?=
 =?utf-8?B?Ykl0T2IwcWhBZTFyK0EwNVp0RG05aFByZEFzWmptRVk1SnZPNnNzMmtxdjlY?=
 =?utf-8?B?YjBOM1FxQ2gwM3NaT2R3cEdIM21wMVEvYVRLdTJaWDBiYy9CeEtXYW5rVVFR?=
 =?utf-8?B?RG43dDlPbXhqZENWUmIzeEdHaVpyTkNDSWZ4QUQ2NVpjU3pIT2RZRWtRa1FN?=
 =?utf-8?B?b3lPT2RlNmNIelVhNThXQW1OYTVleU9NcUFldktXcmk1cjU3L3FMMnI1bXdV?=
 =?utf-8?B?MDVCd2VxZWZuWnpBM2FZeG1xVDQvWXlWYTNtVmFhdlBrWTN1MzlrVlpIZmZV?=
 =?utf-8?B?QkdYbmpZZ0RpSmREaTJBQXZBT1JWUWRZeThQQ1l6VkNKdWJxdVVxMndyd3NC?=
 =?utf-8?B?YlBleFF0MXhJZ3E3MWVxWDdCZ1Z5ZmlUelBzdFR2azZZWEdYNlIzRTkrNE0y?=
 =?utf-8?B?eG54OVV5aUdvcFhNV0t4V2pqZ2JpSWxrUVVnYkxUb09lQ3Y2dUFFdUphelpp?=
 =?utf-8?B?d0FVSWtESDlkY3BoL2t5ZlVGVHdTM2RRVE9CSWRVcEczVC9Ubzk1L0tURzlt?=
 =?utf-8?B?b0g5SVZEM0dZVVNJMzk5TEFNZkxhSkNoTHlBNlBRMHpmekJaR3dCTUdpRXNQ?=
 =?utf-8?B?c3VjU1dpNW1jbEk1TjdoNWxwc1RFTnk0NzhaM21LK1EwUUxxVG52M3lNRUt2?=
 =?utf-8?B?ais0dGIxam02VThUa2NhUElYdFRVYlFtaGNqLzAyK2NnU2wwSkhVWWlybHpP?=
 =?utf-8?B?bmZwbXdUQXRQdjQxSzJvN1BkZ2RGUUZ1L2YwNzhZNjhLWjZyTTMweHRQSWEx?=
 =?utf-8?B?MkNBL1Z1a0dXRkRRY1U1c3FVQllYOUZuVHhsRStKQ0YwS1VubENPY21FM2Rv?=
 =?utf-8?B?SmJQQmdrQzIyVDBSNDBhbStmNk9Wb0FDQ3JxaC91TGdXWjdoVWpxZmRFOU9P?=
 =?utf-8?B?RUlHc0dUMm5jSEhWcURiQ25rWWlXMzI4d09aREx4L3pSU1JGdUlCSU9meGxm?=
 =?utf-8?B?QTkrSTRyT0NzcUxMUnBpQm1HMjJXcGxBa05qdXZwd2Y3ZmVhd2pVOS9TMkhR?=
 =?utf-8?B?K3FrM29uTHlVcWF6ZUFnYk9na2Y0NkFnNGdhRndwMjBBN2JkTDFCQ3NDYzRn?=
 =?utf-8?B?NWZKMVJLaEdpcFRad0NCNlIza3dCcTc0cGxRWjNTM2NGSHFiQkhxZkJJaWRV?=
 =?utf-8?B?RFVEMkpabDc2Z3dzdmZDTkNKUVNFdzFhellzUnRGcmhLSFFNZW9vWitkYUh4?=
 =?utf-8?B?RnU5TTVtNDhvbnE0V0VldHAveWxiaGk3MVJ5VmVPenZvaVA2cTVPVm5zYUZv?=
 =?utf-8?B?T2I4N0NxNXdaYWNVczBUWFZiNVd4MlVkVDZQNjczRkpib1JCOTg1RzBJaEw5?=
 =?utf-8?B?R2xpQnZFeTJHNXZvU0h3Lzhjbm44VGRjQjZmdlc3QXZuZVkzVnBGYnNFL2c2?=
 =?utf-8?B?NVFhSllHZjlIMTRkMzRkaENBT3NucnN5YTI5enVzbCsraldrYVZzRkxJQTRt?=
 =?utf-8?B?dVN2Z2tPV0NVUzRySlFHWStXNEw4RzZUWHlmTnkyRTJHWmFEZU9tSjMrcW9Y?=
 =?utf-8?B?KzBiaGNSSHFzVElxdngwMzdWbHlNcjJkQk1EWlFlS2hJVzd1anpRTlZneHVx?=
 =?utf-8?B?S1hZaVB3VFJSL1E4U2FwQjc4YWhaQ2h0YzdOZFhBR1NLR0tLeUhBbWJIbjE1?=
 =?utf-8?B?ZTBzWXVBZkN0emFQbTNpOE5MbXdIVmZMczhjZmJUYUdHeUhlckZwMC9ZczBq?=
 =?utf-8?B?WlVUbGxZb1YxOFBKeURpaDJlWjR3R0NrNThQOTl3aFMxdTZlRC9XRkxxNHdD?=
 =?utf-8?B?UXRHdXZDYkRvNE4zT2pqKzBsZHNrVWwrMVpGbngxVld3NWlDaGpaNlZteDJY?=
 =?utf-8?B?MUhNLzAwM2pPb05yZytqenNQT1JGRHdnaEV2Vi9IVUFYc1NvUWhJUHJ0Rngr?=
 =?utf-8?B?cFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2070ca-60f8-4905-b14d-08da6b358b4a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 16:24:54.3994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZ/VSwSKFfMFNo4NKlDIhJSO7QSfWNhW3MCdfCXasjzxlLkyyooLQR7yQ8ufSGRhPF48/ojpx+Z3XEM4TzL02Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7043
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 2:50 AM, Russell King (Oracle) wrote:
> On Tue, Jul 19, 2022 at 07:49:57PM -0400, Sean Anderson wrote:
>> If the phy is configured to use pause-based rate adaptation, ensure that
>> the link is full duplex with pause frame reception enabled. As
>> suggested, if pause-based rate adaptation is enabled by the phy, then
>> pause reception is unconditionally enabled.
>> 
>> The interface duplex is determined based on the rate adaptation type.
>> When rate adaptation is enabled, so is the speed. We assume the maximum
>> interface speed is used. This is only relevant for MLO_AN_PHY. For
>> MLO_AN_INBAND, the MAC/PCS's view of the interface speed will be used.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> Changes in v2:
>> - Use the phy's rate adaptation setting to determine whether to use its
>>   link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.
>> - Always use the rate adaptation setting to determine the interface
>>   speed/duplex (instead of sometimes using the interface mode).
>> 
>>  drivers/net/phy/phylink.c | 126 ++++++++++++++++++++++++++++++++++----
>>  include/linux/phylink.h   |   1 +
>>  2 files changed, 114 insertions(+), 13 deletions(-)
>> 
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index da0623d94a64..619ef553476f 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -160,16 +160,93 @@ static const char *phylink_an_mode_str(unsigned int mode)
>>   * @state: A link state
>>   *
>>   * Update the .speed and .duplex members of @state. We can determine them based
>> - * on the .link_speed and .link_duplex. This function should be called whenever
>> - * .link_speed and .link_duplex are updated.  For example, userspace deals with
>> - * link speed and duplex, and not the interface speed and duplex. Similarly,
>> - * phys deal with link speed and duplex and only implicitly the interface speed
>> - * and duplex.
>> + * on the .link_speed, .link_duplex, .interface, and .rate_adaptation. This
>> + * function should be called whenever .link_speed and .link_duplex are updated.
>> + * For example, userspace deals with link speed and duplex, and not the
>> + * interface speed and duplex. Similarly, phys deal with link speed and duplex
>> + * and only implicitly the interface speed and duplex.
>>   */
>>  static void phylink_state_fill_speed_duplex(struct phylink_link_state *state)
>>  {
>> -	state->speed = state->link_speed;
>> -	state->duplex = state->link_duplex;
>> +	switch (state->rate_adaptation) {
>> +	case RATE_ADAPT_NONE:
>> +		state->speed = state->link_speed;
>> +		state->duplex = state->link_duplex;
>> +		return;
>> +	case RATE_ADAPT_PAUSE:
>> +		state->duplex = DUPLEX_FULL;
>> +		break;
>> +	case RATE_ADAPT_CRS:
>> +		state->duplex = DUPLEX_HALF;
>> +		break;
>> +	case RATE_ADAPT_OPEN_LOOP:
>> +		state->duplex = state->link_duplex;
>> +		break;
>> +	}
>> +
>> +	/* Use the max speed of the interface */
>> +	switch (state->interface) {
>> +	case PHY_INTERFACE_MODE_100BASEX:
>> +	case PHY_INTERFACE_MODE_REVRMII:
>> +	case PHY_INTERFACE_MODE_RMII:
>> +	case PHY_INTERFACE_MODE_SMII:
>> +	case PHY_INTERFACE_MODE_REVMII:
>> +	case PHY_INTERFACE_MODE_MII:
>> +		state->speed = SPEED_100;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_TBI:
>> +	case PHY_INTERFACE_MODE_MOCA:
>> +	case PHY_INTERFACE_MODE_RTBI:
>> +	case PHY_INTERFACE_MODE_1000BASEX:
>> +	case PHY_INTERFACE_MODE_1000BASEKX:
>> +	case PHY_INTERFACE_MODE_TRGMII:
>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> +	case PHY_INTERFACE_MODE_RGMII_RXID:
>> +	case PHY_INTERFACE_MODE_RGMII_ID:
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +	case PHY_INTERFACE_MODE_QSGMII:
>> +	case PHY_INTERFACE_MODE_SGMII:
>> +	case PHY_INTERFACE_MODE_GMII:
>> +		state->speed = SPEED_1000;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_2500BASEX:
>> +		state->speed = SPEED_2500;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_5GBASER:
>> +		state->speed = SPEED_5000;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_XGMII:
>> +	case PHY_INTERFACE_MODE_RXAUI:
>> +	case PHY_INTERFACE_MODE_XAUI:
>> +	case PHY_INTERFACE_MODE_10GBASER:
>> +	case PHY_INTERFACE_MODE_10GKR:
>> +	case PHY_INTERFACE_MODE_USXGMII:
>> +		state->speed = SPEED_10000;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_25GBASER:
>> +		state->speed = SPEED_25000;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_XLGMII:
>> +		state->speed = SPEED_40000;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_INTERNAL:
>> +		state->speed = state->link_speed;
>> +		return;
>> +
>> +	case PHY_INTERFACE_MODE_NA:
>> +	case PHY_INTERFACE_MODE_MAX:
>> +		state->speed = SPEED_UNKNOWN;
>> +		return;
>> +	}
>> +
>> +	WARN_ON(1);
>>  }
>>  
>>  /**
>> @@ -803,11 +880,12 @@ static void phylink_mac_config(struct phylink *pl,
>>  			       const struct phylink_link_state *state)
>>  {
>>  	phylink_dbg(pl,
>> -		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
>> +		    "%s: mode=%s/%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
>>  		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
>>  		    phy_modes(state->interface),
>>  		    phy_speed_to_str(state->speed),
>>  		    phy_duplex_to_str(state->duplex),
>> +		    phy_rate_adaptation_to_str(state->rate_adaptation),
>>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>>  		    state->pause, state->link, state->an_enabled);
>>  
>> @@ -944,6 +1022,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>>  	linkmode_zero(state->lp_advertising);
>>  	state->interface = pl->link_config.interface;
>>  	state->an_enabled = pl->link_config.an_enabled;
>> +	state->rate_adaptation = pl->link_config.rate_adaptation;
>>  	if (state->an_enabled) {
>>  		state->link_speed = SPEED_UNKNOWN;
>>  		state->link_duplex = DUPLEX_UNKNOWN;
>> @@ -968,8 +1047,10 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>>  	else
>>  		state->link = 0;
>>  
>> -	state->link_speed = state->speed;
>> -	state->link_duplex = state->duplex;
>> +	if (state->rate_adaptation == RATE_ADAPT_NONE) {
>> +		state->link_speed = state->speed;
>> +		state->link_duplex = state->duplex;
>> +	}
> 
> So we need to have every PCS driver be udpated to fill in link_speed
> and link_duplex if rate_adaption != none.

The PCS doesn't know what the link speed/duplex is. If rate adaptation is
enabled, then the PCS only knows what the interface speed/duplex is.

> There's got to be a better way - maybe what I suggested in the last
> round of only doing the rate adaption thing in the link_up() functions,
> since that seems to be the only real difference.
> 
> I'm not even sure we need to do that - in the "open loop" case, we
> need to be passing the media speed to the MAC driver with the knowledge
> that it should be increasing the IPG.
> 
> So, I'm thinking we don't want any of these changes, what we instead
> should be doing is passing the media speed/duplex and the interface
> speed/duplex to the PCS and MAC.

> We can do that by storing the PHY rate adaption state, and processing
> that in phylink_link_up().

This approach sounds better. You patch below looks good. I'll test it
and use it for v3.

--Sean
