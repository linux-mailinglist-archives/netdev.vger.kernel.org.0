Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DAF65F0FF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbjAEQVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbjAEQVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:21:24 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2080.outbound.protection.outlook.com [40.107.7.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1449A53736;
        Thu,  5 Jan 2023 08:21:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOjPoUovTgMeoxcFAkjcqmLfodD8phCq+9y477cVuUbMRyS5c/oPKXEdWEJXqJrM8TW+gqaqU0+eizrHRi3krvSUrphlDYGTgXPrw/vJ5X7b6jdRO4pa/H+mf9k7OL5KlCz56G8xdIC5ePcxc5amqffBECKqgR4YPad9+HZQuaB92o6J1OuX07ppCucpkyBLcxaLBfnBMb0qKeEeaBRcf8Jmlb3XEr/D2yfCGLvHnjAtaK1btUFFyxKgrqyPVaOZSpIiYtVB2tmcuC8TiAMk9PmFUyfTwVh+2wiiVoT9Kf90sY+7q7JbX8jt0CEqmo5BqwXlC1yvODBOIDdxFy3gKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XnO501LiJPjBFgkB78zI4HWmCVABLILYW3p43veyCE=;
 b=eOG9JT70IsZ8Vr5Jye1b4iFumysj7hpSONli+oNWnCDF0X6fmzAvT6Lh0df3FV01+zj1Q3fL+GV09Y9oYJhtq1yxUHf83dtalv24fHeOyrhh+LG0GT8s5jmr/IwyT/tSEzy+KBgnalimGt4+hBToTd3FQQmrikQEpeQ8KX93j1Ux+6xNCA0YjGNDzvEfIk/LcqdRJVuur6yDDRUt7P7BvAW5J/J5xQ/XRIAtQ+AQ9rDm4lesMFsBnd5HZJvXYK+wPhR+koxx+3Kb7PSst8h1J46XzVY52zIOYO9o4bMVefAeeQerJOBby4GdDtDwDVh3Gao5QPYz85cU+InE3oBLYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XnO501LiJPjBFgkB78zI4HWmCVABLILYW3p43veyCE=;
 b=xw9xZjA2q5tuVdwEkCg9lAVpGX7cBViQvx5wWOwBKc+e3EyjM3KxwiRlv1iqB7vK3TWkAgGtMgLRKBFJ1vMyoyYyUIQuiuwXowHnNr4ui2f08j0nbCCxK2ZU/YiwzJb4yXaWKJb8DM+KAlTXgh2fOH2ei5Yjt3vzQIVMSKq81b9KcUhDe2PEJJVsZc3ETI+3MeOwW95yZDuFCF3P1OPDBwXsaRk+ba7h5qplhhwPoQZU2eeTzmLhLP4dhT8QXBZWZkEmM3rLs+esf4gKzpdjoaH4/FxyWCXn8zRAmUwG2o3BNO2rhrmlUgl/YTbSKLYB8IcPt4qJ5qkKOtC5afisUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PR3PR03MB6427.eurprd03.prod.outlook.com (2603:10a6:102:7b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 16:21:18 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 16:21:18 +0000
Message-ID: <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
Date:   Thu, 5 Jan 2023 11:21:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230105140421.bqd2aed6du5mtxn4@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::8) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PR3PR03MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: 08c0b67f-1413-493e-9228-08daef38e04a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBWUG321PGqJIf3aZAa3ErZWcYWW7r936sq/WcoAg5QTTcZGmqa9MnnYbMeJGxMYOt9HDk4tMF2DKGsKBjGmptBTYl7hDjvuwKmvt8sclNO/kuBa501K56ewFTOu7Z0vYSYrjK+XyXSA09aZOl7h33S3DCUP165CAnMJdBU1aCVEliOtRhwZoVRADsfEFuIJC/fwxjCAjp8TmyenoVu/MwP4aCvlr2E8yTnvWYONcNJY2KjwD3XLNxQ7oQ+GnWb4FPtqqjkCBfvYckFRLU5RV7IPP2dit+M6acxQqgKXS6sWiq0xESCeLyySAqXdjC0cJXRgpxFzJzQDy/qJ0n5pGipXPPFau60qGC9GK1rVqY8GZGKUk3H9fqtvjot4K/HLTPJorsmPqr7/Vw0A5237LURcqYZOi4HQbDMzlKnkEh1lYqg58v2/+PyVQhkf1zJrhMrfq+f6tu7wK5C4R29Ut/Tawsqg2RsWSMxmt36KDZk4Kw4yL/6nqkixwxbNVMUwO2FxHES33NrD+eyGd2I4RnmJAFE3mx9njt4JGK2rU08DTYAIHamGYtzCv4zaFVfs8NTy1KKiNjgGD+lPMY+yhR4ROCCyZjo8unr1emL+cILDxSQ4+eopOyL95Wu0iP5uTB05x7qNkbvnJNRMqNgrtpNC0CR3fKmFdV2nYt4aapCp5wD8jfhUJbXf1A70jUDIFB3v5N0Ir104axWfZJcbt56u+1lsld+sAhVqP1Yv13bjsWonwE3Tt42obKo1m5kzyRlgQ46XOeWR0sjG8HoF3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(39850400004)(396003)(451199015)(31686004)(316002)(86362001)(54906003)(6916009)(478600001)(19627235002)(31696002)(36756003)(38350700002)(2616005)(6512007)(38100700002)(26005)(53546011)(6506007)(186003)(7416002)(5660300002)(2906002)(44832011)(6486002)(52116002)(4326008)(6666004)(66476007)(66946007)(8936002)(66556008)(41300700001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVNlZjQ0S21Rck1rcTJvOFJvNEdMOFU1MTVoNWRod082cnBYekE4RWdqYzVG?=
 =?utf-8?B?V0FRNFFlNUpQMUQ0bDdGdnAya2VMTXJUWTVkR2xzdUxmem9XeHNLR2JNT01y?=
 =?utf-8?B?YlRhWVZtVkhPR3QxbUZzQVN4UTE5c0I3a08yMytuc1RYNWFTVXNFc0dUbk9O?=
 =?utf-8?B?L29aUDd5RkdUeElMa05VT3Z2QlNFcWlSeEtGM25QSVYrdUUvSzdBZ1RHUWJv?=
 =?utf-8?B?RDcxais4dnlqdGM2TnRmWFliT2E5ZjJFTGt0T01McEJwRFJrMmZXLzRUbDE4?=
 =?utf-8?B?WjJGQnBvUkY0aHRHcjFBVUZ3Nk5qeTZCZm9XaGZ6aGkwd0VtVTVKV0Q4Q1dw?=
 =?utf-8?B?UDBobS9mdjlOM2taZ2p6V3pGVFRaZ0RKTFBNSkZYdUpCRHpEODJ5cS9IbW83?=
 =?utf-8?B?anlGa1JsOExJeFk1NGE2cUk2MUQ3Z2VzL3UxVFZyUldmSk9iVnNpbms3ZW9E?=
 =?utf-8?B?ZldXdjBlN3hOaUJOZDQ4ZU8yRjlma3BGSkVENS9rWXN0U2h0bnowNWRKek5K?=
 =?utf-8?B?cldXZXVXcHJUaEJ3Y2RjTllKbG5YemFoNGZKSTNwejM0RDVESU9CWDF4TVkx?=
 =?utf-8?B?NDlXTC96dzE0ZVBIUUt0enpIYmMzQkJOd1NPd3U2MlVuR0NERzRoWVM3eHhy?=
 =?utf-8?B?NzhydG9LRy85blhGMmdYdlBSMXRNeGRPVFhwZ093ejVLN0p4T2I3MVB4aTVD?=
 =?utf-8?B?VjNXNm5SV3FrTGRYb2VDb2M0eDI5L3NYaE1IT2V3N3RTVHRnditMS1dFd0w5?=
 =?utf-8?B?RWkvdTJuNjNKbFJhZFVkcHBxQlhLVG9PQkZrUHdxRE1hMjVQbVdITm02N3Zp?=
 =?utf-8?B?WUhrVnY0VVkxUmE5WFZrOGVOUzMvSDhYVG5qS3ZzNWNwQUdjdnpYTmRZOXVo?=
 =?utf-8?B?V3RESUJLZTg3NHJLN21idnRjaHVGVVNmM1NRVDl6cWQxT1lDMUdlZVFzcHpu?=
 =?utf-8?B?SlYvTTAzakU3U3E2dUpPSjd1dXJxa1VKWEhVeHM1clVNcEYzSlR6LzJKWTds?=
 =?utf-8?B?WU1saVI5UU5OaUNxMklVVGh5OWw3Y3FuTWhJZVkyOGhSRllPd1dQOC9hcFM1?=
 =?utf-8?B?Tnhackhibmp0RDZITWFiMUVHT2o0OU9qR3BXbFV0eWhSdWs3R1l6K2RCY3V2?=
 =?utf-8?B?aG5CemhYL2M2TU8yLzMvM3NsMER2SHEyVG8yR250aTRzcHJEa0lBN0grZno3?=
 =?utf-8?B?SEZ2MUFJZDNvMXhUWWZvMFpvVlpSa0dkSkZzZ3VXYTU0SXJEQzFjZnFoOXA0?=
 =?utf-8?B?UGNZbkNCeFVtUUxER1JraW1EcUNwYTZGSDY0TUZSdmt5LzlXbnFBcTB2Qjlr?=
 =?utf-8?B?Wm1LakxjcmpVYWhkbkJnS01sdGVTa2pRZzJ4MEl6NS9NUldaclJmNGYrN1hx?=
 =?utf-8?B?TEtBOHZENHNrdERYL1Z1WlU3TkdPdzlvdnJMSEN4QnExVThZTW9RZGNqSnRD?=
 =?utf-8?B?T1pzaHN5TUVMaEZnQzZhS1c2NVJMb2F0TkhsMVNyTzNrTTU5OTBmdTFRNStW?=
 =?utf-8?B?RFEyV09YRk1CVEo0T1VkZHRxbTFIcVV5K1NkRUNtSHlNelVva21aWnA0WHNq?=
 =?utf-8?B?bHJXTmg0U1B3cHA1MDlUMEh2ckhjWG5MeVo1WFZTL09sYU1ObzhJcWxTaU1D?=
 =?utf-8?B?SHRHaXFybG5Faml0WGFVUkFTVUN4Ukt0UnlqMXhReGxXVlBjdHljQzRXeWY0?=
 =?utf-8?B?VHNlWHptdzg1ZjZxdGRYY3lpZXZ1RkJ4emw4TkJ0eXlwV1I0MnowNzRvTStv?=
 =?utf-8?B?alRMcE9uenFZaVRYb1hhRnBmcWlpM1Bhdzg3Qzk4NVo4aGlOMGNTYlVKRzN2?=
 =?utf-8?B?RXJxWTExMEp2U1UrRXA4STFpQ1pIZkNkNW9Uc1pqVUhOOENQUThKdWhCb2V2?=
 =?utf-8?B?QnV4dHZaTURzcDlaNlpVQzhyeTF0cjJGckNpeVZxaks1RXArWHQyN1FYcHlr?=
 =?utf-8?B?d2xpUTFhcWJ0T1k5RnJJRGpCTWFzWGhpY01PdDNBSWhsSkdFa1kwV2x0VTBa?=
 =?utf-8?B?TXNvMzBEWll6TjF6ekRXUS9HZng0NW5iaVU5d09yekh5cEZ0dXZLNlJsOERQ?=
 =?utf-8?B?a1B2VGp4R0x6elJPS1ozbmxwdmY1M1ZwKzRiYm1xMVl6NDZ6STd4MjNpbXZ4?=
 =?utf-8?B?NDdnTTRkNEVud1JmeUJEalBQcGEzeWU2b3VWUW5IM25EbXRCVzh6bDVUV2RB?=
 =?utf-8?B?SWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c0b67f-1413-493e-9228-08daef38e04a
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 16:21:18.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IKdzPB8c7tbmAj1mqbNVMYBns9UOBEF1Y3QDxdETRv7jo6nXE/VtqfNxeEsXPijRlXKuFjX6KitKKHzA5u5JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6427
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 09:04, Vladimir Oltean wrote:
> On Tue, Jan 03, 2023 at 05:05:11PM -0500, Sean Anderson wrote:
>>  static int aqr107_get_rate_matching(struct phy_device *phydev,
>>  				    phy_interface_t iface)
>>  {
>> -	if (iface == PHY_INTERFACE_MODE_10GBASER ||
>> -	    iface == PHY_INTERFACE_MODE_2500BASEX ||
>> -	    iface == PHY_INTERFACE_MODE_NA)
>> -		return RATE_MATCH_PAUSE;
>> -	return RATE_MATCH_NONE;
>> +	static const struct aqr107_link_speed_cfg speed_table[] = {
>> +		{
>> +			.speed = SPEED_10,
>> +			.reg = VEND1_GLOBAL_CFG_10M,
>> +			.speed_bit = MDIO_PMA_SPEED_10,
>> +		},
>> +		{
>> +			.speed = SPEED_100,
>> +			.reg = VEND1_GLOBAL_CFG_100M,
>> +			.speed_bit = MDIO_PMA_SPEED_100,
>> +		},
>> +		{
>> +			.speed = SPEED_1000,
>> +			.reg = VEND1_GLOBAL_CFG_1G,
>> +			.speed_bit = MDIO_PMA_SPEED_1000,
>> +		},
>> +		{
>> +			.speed = SPEED_2500,
>> +			.reg = VEND1_GLOBAL_CFG_2_5G,
>> +			.speed_bit = MDIO_PMA_SPEED_2_5G,
>> +		},
>> +		{
>> +			.speed = SPEED_5000,
>> +			.reg = VEND1_GLOBAL_CFG_5G,
>> +			.speed_bit = MDIO_PMA_SPEED_5G,
>> +		},
>> +		{
>> +			.speed = SPEED_10000,
>> +			.reg = VEND1_GLOBAL_CFG_10G,
>> +			.speed_bit = MDIO_PMA_SPEED_10G,
>> +		},
>> +	};
>> +	int speed = phy_interface_max_speed(iface);
>> +	bool got_one = false;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(speed_table) &&
>> +		    speed_table[i].speed <= speed; i++) {
>> +		if (!aqr107_rate_adapt_ok(phydev, speed, &speed_table[i]))
>> +			return RATE_MATCH_NONE;
>> +		got_one = true;
>> +	}
> 
> Trying to wrap my head around the API for rate matching that was
> originally proposed and how it applies to what we read from Aquantia
> registers now.
> 
> IIUC, phylink (via the PHY library) asks "what kind of rate matching is
> supported for this SERDES protocol?". It doesn't ask "via what kind of
> rate matching can this SERDES protocol support this particular media
> side speed?".

We ask "What kind of rate matching is supported for this phy interface?"

> Your code walks through the speed_table[] of media speeds (from 10M up
> until the max speed of the SERDES) and sees whether the PHY was
> provisioned, for that speed, to use PAUSE rate adaptation.

This is because we assume that if a phy supports rate matching for a phy
interface mode, then it supports rate matching to all slower speeds that
it otherwise supports. This seemed like a pretty reasonable assumption
when I wrote the code, but it turns out that some firmwares don't abide
by this. This is firstly a problem with the firmware (as it should be
configured so that Linux can use the phy's features), but we have to be
careful not to end up with an unsupported combination.

> If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
> media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
> and 10M, a call to your implementation of
> aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
> RATE_MATCH_NONE, right?

Correct.

> So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
> would be advertised on the media side?


If the host only supports 10GBASE-R and nothing else. If the host
supports SGMII as well, we will advertise 10G, 1G, 100M, and 10M. But
really, this is a problem with the firmware, since if the host supports
only 10GBASE-R, then the firmware should be set up to rate adapt to all
speeds.

> Shouldn't you take into consideration in your aqr107_rate_adapt_ok()
> function only the media side link speeds for which the PHY was actually
> *configured* to use the SERDES protocol @iface?

No, because we don't know what phy interface modes are actually going to
be used. The phy doesn't know whether e.g. the host supports both
10GBASE-R and SGMII or whether it only supports 10GBASE-R. With the
current API we cannot say "I support 5G" without also saying "I support
1G". If you don't like this, please send a patch for an API returning
supported speeds for a phy interface mode.

--Sean
