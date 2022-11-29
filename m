Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4217363B685
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiK2AWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiK2AWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:22:08 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2053.outbound.protection.outlook.com [40.107.103.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824E932061;
        Mon, 28 Nov 2022 16:22:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCdzvQ7XcWPdAGc5UWEfwkDg5/PQhv+1ck77xVaohOjsQu67JTvqYArU31irf/faY3KERFBwwcnZqUpHnqGhYLFpwlO3t41RBpy055immBIWo+QuNdI+NEYvqT/kdSjDnUsX4HnifWReBbSvXde8cCr/71lXHmo9I9szRTiTiltfcYEcMCdJiDxO+jsBLItpDveV8pUpdygPWNEkJlgpkJW5/jwrD2jwkrfPXqADSB+xfjorp/jut5xxZC6F9ZXox00R2/3cijp4mNY2ypUkyUQ6OI3kfq9bHvA99DQH4VH9bvVJq2q0GzGZpPWQC5tA6hMMclEQivRbNRQkflDvAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kL38dgGwAWhX++4oDqe3dDLnAI1fJG0+cESyhDATeCY=;
 b=fGkqmT0N7h0OXoi2p25a4JXj3JM/eIS6QzlumVwYsl51/oKjO1pU4+4jyjYTZd7Sz5DnPlysZksgOF2scbB1vX71cDHpkj9r8p31UhGqvxyhrqHVR3wrePmUzSclAjyuCq3XJvQxM365A1apU5dlLpPlb363J5oWIpe5muKW1bNRO2dtH8q2DUmi6nbJZ/j4VI0cc16rqXhnePes/5Nkzr43KjubtffeUoLTHwXxGcXWWtmfo73LDyB7st6RCz8Bay7kHXFghDDbDJIqtrnjtQE6X3nxch10D2q/U26XCwYqkE8qgDCKEJJH8XdaBMXJpO8tdT3gHyj/yPpZi5p6rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kL38dgGwAWhX++4oDqe3dDLnAI1fJG0+cESyhDATeCY=;
 b=j9pO/K4KAswZVYuzej1I/baOxB0bXG2XUM/ZbgwGYYiaExprmi30RdHRcWkhmlyP5iCTnxk6dj6qrPfCQe0oOc5tOaoaovMmBMnHyo98nw9xy4jqEgt+Sin1FDv9zi7UxGKOIMCwUkESGi/ttTY5055ri6dUNEZW6BYxUgMdzZMgH39IITYwrlaOnYbC21+3KP+SSco67u4a0/oZ/jHhChT2oNYEoZl5cft7SudJhpgrkeEVvxiDL8JC9lYb5LvxjMLGoghu42HRPJHMyAYYtBlFXkGxsE/5N0AcEO5Qj3Td5zjGltftatzoS7qVRBn7EXWtIiLZZ2nvJZQwVwq00Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB8463.eurprd03.prod.outlook.com (2603:10a6:10:3b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Tue, 29 Nov
 2022 00:22:02 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:22:01 +0000
Message-ID: <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
Date:   Mon, 28 Nov 2022 19:21:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::25) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB8463:EE_
X-MS-Office365-Filtering-Correlation-Id: 91870214-8b6b-4a17-dd3d-08dad19fbb7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Us63jF8x/sBh9Kq4run1jAWiFOUTQ/OWY0+2Sy2ag+ofKP0fCEx/QtO+RYmhibTbp+945fPTvhWPBZCzD51apSCYrqr3WNpgkdshSBdE01rYg/tTIbbjK1vX6h8CiMpPJu0fAuXJIFktuWTbkLK86xd0I4uDr+iBBM3HYL/xwEJuxzlNhMeqUhvQaO6IKItaId6aA5AF2sklkFZxKruKwRk0QuaaDIhkUHwwah51FsL9cg5+xQ19XOWiMEl/x2lmMOSLdGqapqkaPBSM6fOgZUgCImYKgxhoahxk6K+4Qd3PuqwjFQMJ1n9ZlRw4dW5z5PlK3yY6A1D6xtAkL4ExQwP7CNlLaDF/JiDjdxNxXMdFmKOvuzTz6RJQIUNUVHZk+0N4wF/1pryNkNKCkDE5zO7cD6dg6uMLy/M4eW4Mzy0jTD7DfnhV5sCXL68LTKd9lMs3uoQJ8EUHG3q5cNdeOCiIr4NNKqctCQiXBpGX3xUNmMfD515qSumTmk0OidfeYHIXcr3dQfWh6EOOBm4nPhvhPnJtZIywLtwntFW1FZRNWnXCxNtwPi8hj+i/awRJWi6eMQyxjbb9XWnKGRj9OLAdMUyCd+lECuHwYvoCttoEF+c2AlJ0rPMMPG3SNO5CCqtaoWfU9UHGM5Z8r+/fuLMC4bD2QFjx89qlXUq5IBuhL/es1MB546qk8v8G2HT39kUD/jcLhAzzaBq+eZD6lC5P/9tCyubhlNidmw4NkEWM9qYbAbcHv/Af1AYOfGXf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(136003)(396003)(39850400004)(451199015)(7416002)(86362001)(31696002)(8936002)(41300700001)(2906002)(5660300002)(44832011)(66946007)(6512007)(53546011)(6666004)(6506007)(52116002)(26005)(83380400001)(2616005)(6916009)(186003)(316002)(66556008)(54906003)(8676002)(38100700002)(38350700002)(478600001)(66476007)(4326008)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1lDNFI1citVR05XZXJBOW1aNUhrNlpYdzNXUk5iVjNaL0lNenIyQXVNcjJa?=
 =?utf-8?B?aURneFpWOHB5M2lWZW55Z2JKaDdkS3NlUGUrLzlXZHlEVE1VNUxMejN3Ujkr?=
 =?utf-8?B?QUJ0R0pmQmtSUUdQSGo4Yjh6TXhPKzNiYTE1V1pyemduZXJVZkhXbWN6YTQ0?=
 =?utf-8?B?akk1Q0JYeVpsbnh2V2xULzBuQVR2eGJWcU9KUW1tK0V3eVllTU80WGVTVjJn?=
 =?utf-8?B?bnZPNmRCaGxRRUVveEthbjNTV3Q2N2tEb0svWHZrbHFxMXVZcVdYMUdBSzAw?=
 =?utf-8?B?SC9hZVdOQys2YXViNTIvYU9zd01sL2R0THZ1Nk5JTVFlcnRMeHdCelBBNERr?=
 =?utf-8?B?QjZvSHREUWR5eE96K2NHVWEyY2ZkODRBcjZoT0JwZi9nK1pGSVRPS0xNbHc1?=
 =?utf-8?B?am9uby9WejVCeU5HR2hUQ3NwWE93SEpvYUpNb0hqYWFXMVFlOE1jOTNtbnRt?=
 =?utf-8?B?dVVCTkN5T25aTVZpWWVNWUh0MHBiS1pxdEcwaFJKbno2SlQ1VWhKYnlHcWVY?=
 =?utf-8?B?R2k3T2xEeDhpZW1yRG1iTGFrTkR5bzFhZUdKeitDYmlvcncrVUZtU3FYMStK?=
 =?utf-8?B?aXF6eG93VXc1NmFkSTlQVUZVSXR1am5TTGpYWHFpYXg3QktJUE1kalM3eXdJ?=
 =?utf-8?B?S1duZmFQbVpJakE4d3hVUGsvMjhvL2I1OGJIQkE4aVZpeGdMTFZJZHM0Z3Zj?=
 =?utf-8?B?RWprTnJRVzlBTmxuWEVrN1NFUkJkS0pIdFlBci9yS29MeXBQbGt0TkJwVmFn?=
 =?utf-8?B?SzY2QmhlNkVKSGNhQVVSa2tWT3hFcldPdTVMR0Q3RUFvN2JlbDVkNFVkd2l1?=
 =?utf-8?B?aGNMVjE4NnVkOEJ1TWpnamVKNTZmbEQvbDBmaFA5SUV2TWUvMnMwTmxoTFFm?=
 =?utf-8?B?V045L3QyY2JxVmtmZlVwR1RUZndMUTluYTVhWkFCbkpPNHBaS1VrcmRXS3Fz?=
 =?utf-8?B?dDQ5RDBlOTVLaFd2OVRCNEtCaUZjb3BWYThSYThPcGRqZDBOSzVNc1VSUDBz?=
 =?utf-8?B?c21LM0pZbm1EMGJPak1CTkwzbHZQYzJGV0dxdGtyRnNPTEMyM1krQVU1YmRZ?=
 =?utf-8?B?MG9GNXZ0amFhRnpuS01LMHhiSkFDVXdzeFE5RlZuTGo1TGl2d2hiNXg2Q2lt?=
 =?utf-8?B?Wnc1VytWbHNRZmhra05QRGNkNDJ3RktKZTFiTzRLWFFYQTNrcDAxVmtRQVY5?=
 =?utf-8?B?UFJ2dDhOWEpDS3NVdlZlVGc2YVkxSWRiUnZpTjNhQ3Zlbjh3bnVkNlVOTFNm?=
 =?utf-8?B?anp2dXY2U1ZyZHNYdlpvazQwSG41dGJYVG01QTBMRkpJeXZGc2I4V2xxaVJq?=
 =?utf-8?B?NS9YK0dPOU51MzVCeUUvb24wL0lkU2hNaXhkLzI2UzBJSXlxYk5DYWlrRDBj?=
 =?utf-8?B?OWJEc0VUZnRlMjdOalpldDVHZ0x1SjhOSzFTbUJiVnBGQ09IbUYvTHhBVnFF?=
 =?utf-8?B?YmoxSTUyOTI1NktiK1RHbTF5OWI2WlpZOFM1RGRCN215NUJkK0VZUUV5ZUdK?=
 =?utf-8?B?WTJKcE5vMGUrenFqd0R5UjcwZWtobkY0bnY0ZVBwT0tsOFp0ekFEMUJna3lE?=
 =?utf-8?B?TVZ5d3BSSW9oM0RCbEhNMTZMc2U1Z1lseS9BWjV4L0lzM3BLU3hydWdRQkdK?=
 =?utf-8?B?MlJnNGJZYjFQZ2UvelQxTi9WTUZDLzJFc2Rybjk1ZTJnbkxUWjhJUUxlQmFC?=
 =?utf-8?B?ZytGV0ZIS3JWRHV0T3FVMCtpWW83K2tJa3ZxR2Q5REhQQmFRdW1zcHYycUZr?=
 =?utf-8?B?cjFYK0E1SXZwTmJGTElNaGozeXZtbnR6OHR2K3dNR2RtTFlQMFZ6UXZ1TkJ5?=
 =?utf-8?B?eHBwUG15bEI4cjNNdm5qRTZvaEc3UFJFcUlsRXBRdjliRmRwNlVuWnVVT0FV?=
 =?utf-8?B?Y2NHMmNSLzB4ZFFSdWpIdEp1WHZIMFdvWU9pczA0S00yZnBicUtWeXQ3UGdT?=
 =?utf-8?B?dG56d0ZoQUMrTVhBTWxPdHIvWXA1SThPRnJpNHM1SWpvZHFjaThYRzZyMytm?=
 =?utf-8?B?WkQ0OFBkR3pjYzdaZ2NxS2d3c1FBN0lyeUNxTUxjdmwvYkZSdy9YaHY3WTBG?=
 =?utf-8?B?YldQZGpwMmFLUWg1bnk4RGs3U2IwWG5HZXVCQVVlRmpqRitZUWV0UG94SGNQ?=
 =?utf-8?B?YU5wVTlEL2N1ekg4cUlkUExkNEdDdGFPeDBxTFFreUFaWGlaSGxnUUJsbTlk?=
 =?utf-8?B?OHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91870214-8b6b-4a17-dd3d-08dad19fbb7f
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:22:01.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHgCOp60wOU4vk83sOR/RdoSrE6O25uIyKP/UZPnpJ4cayUmaJBznrBDfQALh8e4SeUk/sxGHlIRSfyo40rr/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8463
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 18:22, Russell King (Oracle) wrote:
> On Mon, Nov 28, 2022 at 02:54:09PM -0500, Sean Anderson wrote:
>> When autonegotiation completes, the phy interface will be set based on
>> the global config register for that speed. If the SERDES mode is set to
>> something which the MAC does not support, then the link will not come
>> up. To avoid this, validate each combination of interface speed and link
>> speed which might be configured. This way, we ensure that we only
>> consider rate adaptation in our advertisement when we can actually use
>> it.
>> 
>> The API for get_rate_matching requires that PHY_INTERFACE_MODE_NA be
>> handled properly. To do this, we adopt a structure similar to
>> phylink_validate.
> 
> Note that this has all but gone away except for a few legacy cases with
> the advent of the supported_interfaces bitmap.

This is more of a note about inspiration than anything else.

> Also note that phy_get_rate_matching() will not be called by phylink
> with PHY_INTERFACE_MODE_NA since my recent commit (7642cc28fd37 "net:
> phylink: fix PHY validation with rate adaption"), and phylink is
> currently the only user of this interface.

Neat. Although I didn't get a chance to review that over the holiday...

I suppose I should rebase...

>> At the top-level, we either validate a particular
>> interface speed or all of them. Below that, we validate each combination
>> of serdes speed and link speed.
>> 
>> For some firmwares, not all speeds are supported. In this case, the
>> global config register for that speed will be initialized to zero
>> (indicating that rate adaptation is not supported). We can detect this
>> by reading the PMA/PMD speed register to determine which speeds are
>> supported. This register is read once in probe and cached for later.
>> 
>> Fixes: 3c42563b3041 ("net: phy: aquantia: Add support for rate matching")
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> This commit should not get backported until it soaks in master for a
>> while.
> 
> You will have to monitor the emails from stable to achieve that - as you
> have a Fixes tag, that will trigger it to be picked up fairly quicky.

I know; this is a rather vain attempt :)

If I had not added the fixes tag, someone would have asked me to add it.

>>  #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
>>  #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
>>  #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
>> +#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
>> +#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
>> +#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
>> +#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
>> +#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G	6
>> +#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G	7
>>  
>>  #define VEND1_GLOBAL_RSVD_STAT1			0xc885
>>  #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
>> @@ -173,6 +179,7 @@ static const struct aqr107_hw_stat aqr107_hw_stats[] = {
>>  
>>  struct aqr107_priv {
>>  	u64 sgmii_stats[AQR107_SGMII_STAT_SZ];
>> +	int supported_speeds;
>>  };
>>  
>>  static int aqr107_get_sset_count(struct phy_device *phydev)
>> @@ -675,13 +682,141 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
>>  	return 0;
>>  }
>>  
>> +/**
>> + * aqr107_rate_adapt_ok_one() - Validate rate adaptation for one configuration
>> + * @phydev: The phy to act on
>> + * @serdes_speed: The speed of the serdes (aka the phy interface)
>> + * @link_speed: The speed of the link
>> + *
>> + * This function validates whether rate adaptation will work for a particular
>> + * combination of @serdes_speed and @link_speed.
>> + *
>> + * Return: %true if the global config register for @link_speed is configured for
>> + * rate adaptation, %true if @link_speed will not be advertised, %false
>> + * otherwise.
>> + */
>> +static bool aqr107_rate_adapt_ok_one(struct phy_device *phydev, int serdes_speed,
>> +				     int link_speed)
>> +{
>> +	struct aqr107_priv *priv = phydev->priv;
>> +	int val, speed_bit;
>> +	u32 reg;
>> +
>> +	phydev_dbg(phydev, "validating link_speed=%d serdes_speed=%d\n",
>> +		   link_speed, serdes_speed);
>> +
>> +	switch (link_speed) {
>> +	case SPEED_10000:
>> +		reg = VEND1_GLOBAL_CFG_10G;
>> +		speed_bit = MDIO_SPEED_10G;
>> +		break;
>> +	case SPEED_5000:
>> +		reg = VEND1_GLOBAL_CFG_5G;
>> +		speed_bit = MDIO_PCS_SPEED_5G;
>> +		break;
>> +	case SPEED_2500:
>> +		reg = VEND1_GLOBAL_CFG_2_5G;
>> +		speed_bit = MDIO_PCS_SPEED_2_5G;
>> +		break;
>> +	case SPEED_1000:
>> +		reg = VEND1_GLOBAL_CFG_1G;
>> +		speed_bit = MDIO_PMA_SPEED_1000;
>> +		break;
>> +	case SPEED_100:
>> +		reg = VEND1_GLOBAL_CFG_100M;
>> +		speed_bit = MDIO_PMA_SPEED_100;
>> +		break;
>> +	case SPEED_10:
>> +		reg = VEND1_GLOBAL_CFG_10M;
>> +		speed_bit = MDIO_PMA_SPEED_10;
>> +		break;
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return false;
>> +	}
>> +
>> +	/* Vacuously OK, since we won't advertise it anyway */
>> +	if (!(priv->supported_speeds & speed_bit))
>> +		return true;
> 
> This doesn't make any sense. priv->supported_speeds is the set of speeds
> read from the PMAPMD. The only bits that are valid for this are the
> MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
> MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
> two definitions:
> 
> #define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
> #define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */
> 
> Note that they are the same value, yet above, you're testing for bit 6
> being clear effectively for both 10M and 2.5G speeds. I suspect this
> is *not* what you want.
> 
> MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
> MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).

Ugh. I almost noticed this from the register naming...

Part of the problem is that all the defines are right next to each other
with no indication of what you just described.

Anyway, what I want are the PCS/PMA speeds from the 2018 revision, which
this phy seems to follow.

>> +
>> +	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, reg);
>> +	if (val < 0) {
>> +		phydev_warn(phydev, "could not read register %x:%.04x (err = %d)\n",
>> +			    MDIO_MMD_VEND1, reg, val);
>> +		return false;
>> +	}
>> +
>> +	phydev_dbg(phydev, "%x:%.04x = %.04x\n", MDIO_MMD_VEND1, reg, val);
>> +	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) !=
>> +		VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
>> +		return false;
>> +
>> +	switch (FIELD_GET(VEND1_GLOBAL_CFG_SERDES_MODE, val)) {
>> +	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G:
>> +		return serdes_speed == SPEED_20000;
>> +	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI:
>> +		return serdes_speed == SPEED_10000;
>> +	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G:
>> +		return serdes_speed == SPEED_5000;
>> +	case VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII:
>> +		return serdes_speed == SPEED_2500;
>> +	case VEND1_GLOBAL_CFG_SERDES_MODE_SGMII:
>> +		return serdes_speed == SPEED_1000;
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>> +/**
>> + * aqr107_rate_adapt_ok() - Validate rate adaptation for an interface speed
>> + * @phydev: The phy device
>> + * @speed: The serdes (phy interface) speed
>> + *
>> + * This validates whether rate adaptation will work for a particular @speed.
>> + * All link speeds less than or equal to @speed are validate to ensure they are
>> + * configured properly.
>> + *
>> + * Return: %true if rate adaptation is supported for @speed, %false otherwise.
>> + */
>> +static bool aqr107_rate_adapt_ok(struct phy_device *phydev, int speed)
>> +{
> 	static int speeds[] = {
> 		SPEED_10,
> 		SPEED_100,
> 		SPEED_1000,
> 		SPEED_2500,
> 		SPEED_5000,
> 		SPEED_10000,
> 	};
> 	int i;
> 
> 	for (i = 0; i < ARRAY_SIZE(speeds) && speeds[i] <= speed; i++)
> 		if (!aqr107_rate_adapt_ok_one(phydev, speed, speeds[i]))
> 			return false;
> 
> 	/* speed must be in speeds[] */
> 	if (i == ARRAY_SIZE(speeds) || speeds[i] != speed)
> 		return false;
> 
> 	return true;
> 
> would be more concise code?

Seems reasonable. I could also stick the link_speed switch from above into this array...

>> +}
>> +
>>  static int aqr107_get_rate_matching(struct phy_device *phydev,
>>  				    phy_interface_t iface)
>>  {
>> -	if (iface == PHY_INTERFACE_MODE_10GBASER ||
>> -	    iface == PHY_INTERFACE_MODE_2500BASEX ||
>> -	    iface == PHY_INTERFACE_MODE_NA)
>> +	if (iface != PHY_INTERFACE_MODE_NA) {
>> +		if (aqr107_rate_adapt_ok(phydev,
>> +					 phy_interface_max_speed(iface)))
>> +			return RATE_MATCH_PAUSE;
>> +		else
>> +			return RATE_MATCH_NONE;
>> +	}
>> +
>> +	if (aqr107_rate_adapt_ok(phydev, SPEED_10000) ||
>> +	    aqr107_rate_adapt_ok(phydev, SPEED_2500) ||
>> +	    aqr107_rate_adapt_ok(phydev, SPEED_1000))
>>  		return RATE_MATCH_PAUSE;
>> +
>>  	return RATE_MATCH_NONE;
>>  }
>>  
>> @@ -711,10 +846,19 @@ static int aqr107_resume(struct phy_device *phydev)
>>  
>>  static int aqr107_probe(struct phy_device *phydev)
>>  {
>> -	phydev->priv = devm_kzalloc(&phydev->mdio.dev,
>> -				    sizeof(struct aqr107_priv), GFP_KERNEL);
>> -	if (!phydev->priv)
>> +	struct aqr107_priv *priv;
>> +
>> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>>  		return -ENOMEM;
>> +	phydev->priv = priv;
>> +
>> +	priv->supported_speeds = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
>> +					      MDIO_SPEED);
>> +	if (priv->supported_speeds < 0) {
> 
> Given the above confusion about the MDIO_SPEED register, I'd suggest
> this isn't simply named "supported_speeds" but "pmapmd_speeds" to
> indicate that it's the pmapmd mmd speed register.

Sure.

--Sean

>> +		phydev_err(phydev, "could not determine supported speeds\n");
>> +		return priv->supported_speeds;
>> +	};
>>  
>>  	return aqr_hwmon_probe(phydev);
>>  }
>> -- 
>> 2.35.1.1320.gc452695387.dirty
>> 
>> 
> 

