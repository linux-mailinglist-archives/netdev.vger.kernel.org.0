Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F1A57D13B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiGUQRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiGUQRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:17:05 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0425E88F11;
        Thu, 21 Jul 2022 09:16:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3eOoHSX8XyUdP7UXkJ7cMzpNWvcPybLKkxun71dKUHuEOCFddRnuIG2n5h33QIKq7/+bfZadLoDnbHZHAqlGe+jsm+SJtHXz0Ikze5+b/B0iRSkizs9PMIMnnVf0RWLwFxNjfL7zAHZRj3rYH5xgIwjmjypYOuRACLSdNBoNCFgDkYHauzf6o8u1WEl8VcEuiXY5CCEiMB+Ou7bCd+mDMYLb+1Wev2p9YflFRZjt5ULCoygta2JMQ07jvvXdVSyL0UbZRskso/RVOySMODXKFHZLpwzywF7xJyj3YKyIG2QjjcpkE6yJi3Lj0PRZBYpTHY7+Gh0SnW/SsIOl/SWyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcxdxsbCejSjB6Vy1K+qw1BX+s1IXWhvrS66oX5Tkio=;
 b=BoEYBoEunchlPkc1pEO9inNjGiprkb6sOu6TOnnQOgdCEYwB0XFUeAvjHOoUWUWqP3POGOeczxM4UYVK2asMI9dO9a0kQG9SId6RVe+Rz+NVNfk+bhh4SRtK7/QoEdze/u+ausXwBl8mmAW9eNp2m820I00HvcXZ/Q1BVwMb3jWKUm+UgHGueBKdIDH+076x+9zuwveFl9aQWRJO71ApH0UpBiZInZjkjkKLn4GYS8fxuRhkYFD5I1n+F0EhwiB4N8920oCuD1BqpBkNu4N14MFnTruHMGktrArWJwnBmCCds2yk0IoyAC7NMnf6Dim5MIbW2Olf9b5GraM+2P3Gwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcxdxsbCejSjB6Vy1K+qw1BX+s1IXWhvrS66oX5Tkio=;
 b=iycw7J5uEtl9IQwErHWbzbIt8swRJMvy9FKGWT8rv1UaSR420uGlkWgBakP6GX4FI4WG5n9JfHF+vZO7lSO4zAeIIQlQWp7L2IQ9V5FTXF9BImhps4mxbWGptZfg4D7pVlgemfA0eJl56vIoeda8laDR4jwtxBQz2lvvb9X5YKBFosjuBLse8+lNMFT8hDQS0jVPYL4XzrlpD7Uyhq25PAJMxo2dJRF4lKqhXJv36sYpD50slhq4CUQgcNNaZwLp/wpigBeCt9dlMq25aAWiRb8ttDb2CK5E1EqEsQYAP/Dqm24kFRL7n5iK80R0em0Qsq/f/e2EydAvOz/dMEpdGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4393.eurprd03.prod.outlook.com (2603:10a6:10:17::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 16:15:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 16:15:29 +0000
Subject: Re: [PATCH v2 06/11] net: phylink: Support differing link/interface
 speed/duplex
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
 <20220719235002.1944800-7-sean.anderson@seco.com>
 <YtekL4y/XKn1m/V4@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <6a2fe06b-3a96-026b-34da-6e6f13876c62@seco.com>
Date:   Thu, 21 Jul 2022 12:15:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtekL4y/XKn1m/V4@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0039.prod.exchangelabs.com (2603:10b6:208:23f::8)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a95fe51-f40f-4367-beda-08da6b343a82
X-MS-TrafficTypeDiagnostic: DB7PR03MB4393:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xV5quRQy7Bdgi4nPFNS7pdaSVtKlvdJZyD/vBzr57Y/8T1mf5ZUZUwQC3ZILbClvyajl5hCi7WaE/Ux2UDYuz9GmvhT9/52950ggXai5AzD/8s4Hu/DRWptu1+Brz1CEO2gAxdO3YgIgg+HQP6xqD8sRysnX9agkgwSun/IJuk2Zne0RIDq+WmZjX2DMpgo3SHz/coxoyANzRkzMnAFqwi3MxdQiEIOmPCR/vsf/BvrCDc+QL42Ieruln4K6KOnCHbHxvKoxjRzIUOJh5XnTQLhta/CE3KmkKnEyWV/h3CFtbDqFH97e2X/CIGr4C6MGtCvRDmKPTUJ9etFTOjam3gf5erI24vSiyPltem1WTgsrsIv9JV8Ql0h46x+I7H4AAnJaznYmj9EwWvh6HNZNEZHenQgyP0KHz/JVItet2yShmkYmOD8i+v9ardKqrAmvWfseKPvKnGJoKuT2yqsQD89HuGmG7uj0IKj8o4izmBljVlVxgHS4Tr09SGMK9NUdh699Ng30IvW4WMhSyV3+5+6ys85vwlGBhXJ0vs00NQ/DA+QL+7fJizvF0E1avPwaz08yj+DBmqWofm7YDNvH71FjBxVqw0iGRQUqXAs3bpUlAPfMrHnVu5CNSSG8rBApPt7v3+Mn5qbYGQtPFWG4hBin59aoxipDCwWWKCDzvuAm9OCRy54xq9J9w/ajNSEeKuxCmi/rZp//jDcWyF4to8JnW8+2ltyhwlVnlTtuZQ9TuB2tG8ixsiluIUfXvL1JQRuhRLkMeg5dlcdIoEBGvOMS2xUx3sGLO4pnhsQrUyAdNsHKNHNIBu3wD821UwCaL1lUNusmk170f8FfuTVnaK4+lbKIZScvMS8b9cpLCz4m6x8H3xNU/aZLx8OBSQ0oqnnciY+TodSuSOcTLmZxcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(39850400004)(136003)(396003)(41300700001)(66946007)(26005)(6512007)(44832011)(186003)(83380400001)(38100700002)(2906002)(2616005)(6666004)(52116002)(53546011)(6506007)(38350700002)(316002)(31696002)(54906003)(6486002)(6916009)(31686004)(86362001)(8936002)(478600001)(7416002)(5660300002)(8676002)(36756003)(4326008)(66556008)(66476007)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWc2YmhiVHZQa0dXR3pwMy9OeFc1NmRLQ0g4NlB5QlZzWStweGJFdGloREtG?=
 =?utf-8?B?WExXeVBqTnV6a2t2UnRRenBOU2VMZTg3bXUrL2RWamxUY2ZGZVVrd3orTE1Q?=
 =?utf-8?B?ZzhGUkhXZkNPalM2K0h4aG1YYkdybFN6UUdhMXVDSzJjNG81UWpGcW16a1Zx?=
 =?utf-8?B?Rk85clZkV1lDR0VSenByNnZZWlNadW5qTk52MXkzUnc5c2N5WTVYMjRONERG?=
 =?utf-8?B?WDVrUnU4dXdNQUo1RzdJTkVXVjZiM0dLSDhFTStmUUcvaFV1aE13c2xEa3Ra?=
 =?utf-8?B?OWEzWmV3WWtUMmd3cjdCUGthRnI0bGh0R1J5dTNod3Y4Q2QwdWp0Tm1UVC82?=
 =?utf-8?B?V292R2hIRmNUSk9EZ1VHM1ExcVpsNkZtMElIaGt1cFpuMWh3YmxXbm01TEpj?=
 =?utf-8?B?L3VnZlZ4dzc4a25Kc05WWHIyQkk3YjZOcVF6L3lIVWVHV2t6ZUlBWXhhQS8z?=
 =?utf-8?B?R01SbWVLbElGSHpyS1VobkJBTHBqOUpWY25GWGtzOGd4aHZqZXpRcHVyakJ0?=
 =?utf-8?B?YXhDWmZ0dkRpNHg1aWJVRUkwcTk1cVRSRnFSRkIwTlRBNzBRbVpaV1pkMU5F?=
 =?utf-8?B?NXV5bTAwOENJQVc4bHVPTmN3bElVNnJ5SXk3eUFiTXVUN0NObUF6dVZqanRu?=
 =?utf-8?B?VTEyNUN4dlp1Mk5NL292c0E5b3Y0b242VUJrcTBjUkRTWERER2t3QlZ2SVZC?=
 =?utf-8?B?S3FjbEM4b2F4eHRIaWt2TDFrU0pjTFV0ckR4MUNLTmhyTHp3amVuSG8yM2l0?=
 =?utf-8?B?RzJoZ3UzZXlzVkQ1OTkvR01LbUsxV21mRGVZMGhHZ2hIenNqcjJYZzF1VC82?=
 =?utf-8?B?bmhZQm14VGpmTUhPVFBtdVMwejk2L3V0UUorc1htUmtVU2xYdXJnSEdJRUNU?=
 =?utf-8?B?emFZRDRFN3JYRXl6VmUrWHhKZHIvQTYrMHlRSm15QTZGbGJGMTIvZUhEcVhn?=
 =?utf-8?B?MCsxSDAzQzBIc1BCWHpIQS9uYXRvd0ZOUDAxR1NHTGttZVIyT1dMeWhkL1dS?=
 =?utf-8?B?bnBmM1VzWXZmUkhHdHU3dmdSUkQ0Wkg0UzBIRFEvRmFDd1AvN0lacUl3TjZm?=
 =?utf-8?B?MzEwSHpNdWdTeEg3anF6NFNDNFBXak9oMkpoSlB5QTgvU0tremw1TWYrT1k2?=
 =?utf-8?B?bXRFcFhjYnJRNzhWY1RVd3VsTDJtT0xBVVo0Mzlqc3RyditUNWpwOFpNVDY0?=
 =?utf-8?B?VUFoVnFoNm5VS3pWMmI0bTNjZTJLOXVCRG41ZVNmRVBSUi9vRE1lMzJQK04z?=
 =?utf-8?B?dDF2UlNrNkJJenZPZ1BHZ3NiR3o5akZmZWwxRXpCa3lhdW0va3g4YXFpNDZN?=
 =?utf-8?B?VEFvbk1JK1BBMWxUZFJEWE90OHY4MGVGdHppcnZKczhpNDZnSWh4dkRjRUZw?=
 =?utf-8?B?MGY1TVlKYzU2anBhN2lJRUNoWTdrTm1telZZYVRJNHJaOTVRS2FnRnUzTm1E?=
 =?utf-8?B?NHhSRjZVT0ZLWmZHdDJvdmhmczV5cGpuSjdRdG01K3BLVnlVd092VWtDeWtw?=
 =?utf-8?B?aTB4M0xPdE55YVVWcHJ6bHJyNEhYSjA4aTRkd2MySGxuTXhUdy92OXIzL2dh?=
 =?utf-8?B?YUlLZ2pFcjlxenBwSFhSbSs2ZGFXdFdGdnFMMno4UDdQMVEvQUtVTldLTitT?=
 =?utf-8?B?UTdqajF4cmIybUltdlBqaTk2VWFuZ252NzQyRUlPeDh6OUVDUHVDSDdHbE1O?=
 =?utf-8?B?T3hUNW9rUG1pczRWbXBkTFFlaVI3Tk9GOGxMbXJRWFN6eE5CT3RYa2pXN2hT?=
 =?utf-8?B?RWhmSU14VUtXL24yL3BDRzM5QzZpVTZwNFVHQzBaN29paG4va1UvYkN6ZzdK?=
 =?utf-8?B?ZjRpVE54YkM1UkxhSGF6NkxRdFE2YzdsMkRaTDFhcnlyaWdGOEIyN3NUNTll?=
 =?utf-8?B?SExVck1FVGd2OGtaaWdlYmFsY3ExR2hLbzdWSG9XeFhHdG1ENDlFWEsreVVi?=
 =?utf-8?B?SVdOUnVLWjBFd1kyVk93ZTN1QWdVakJMTGZmcHRnS3VWelVJU2I1a3ZsWUpu?=
 =?utf-8?B?TjRlVlF5STlNeWVldld4UkxTTzFHU2FSVDNjc1RPalI1NGM1NFE4K09sTTBs?=
 =?utf-8?B?TU90T3ZrZHZSbldKSk1xWVVVMjdEYlBMcGdWQy9ndkNYM3ZIaHU3ZnExUGJX?=
 =?utf-8?B?Mzh5R1lzNWtzMWU5WEJ1VUdzZ1ZubnUzSy9JOEd4VGFZMXNuYmNxUjBRVjNR?=
 =?utf-8?B?bnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a95fe51-f40f-4367-beda-08da6b343a82
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 16:15:29.1871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjhCwIj/aLmggVrqr2ySovNTwRamQNHI79oycV7hiukB/evCM9VO1g81oWjefEflJrBA940WNjJSXaZLKZaxqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4393
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 2:43 AM, Russell King (Oracle) wrote:
> On Tue, Jul 19, 2022 at 07:49:56PM -0400, Sean Anderson wrote:
>> This adds support for cases when the link speed or duplex differs from
>> the speed or duplex of the phy interface mode. Such cases can occur when
>> some kind of rate adaptation is occurring.
>> 
>> The following terms are used within this and the following patches. I
>> do not believe the meaning of these terms are uncommon or surprising,
>> but for maximum clarity I would like to be explicit:
>> 
>> - Phy interface mode: the protocol used to communicate between the MAC
>>   or PCS (if used) and the phy. If no phy is in use, this is the same as
>>   the link mode. Each phy interface mode supported by Linux is a member
>>   of phy_interface_t.
>> - Link mode: the protocol used to communicate between the local phy (or
>>   PCS) and the remote phy (or PCS) over the physical medium. Each link
>>   mode supported by Linux is a member of ethtool_link_mode_bit_indices.
>> - Phy interface mode speed: the speed of unidirectional data transfer
>>   over a phy interface mode, including encoding overhead, but excluding
>>   protocol and flow-control overhead. The speed of a phy interface mode
>>   may vary. For example, SGMII may have a speed of 10, 100, or 1000
>>   Mbit/s.
>> - Link mode speed: similarly, the speed of unidirectional data transfer
>>   over a physical medium, including overhead, but excluding protocol and
>>   flow-control overhead. The speed of a link mode is usually fixed, but
>>   some exceptional link modes (such as 2BASE-TL) may vary their speed
>>   depending on the medium characteristics.
>> 
>> Before this patch, phylink assumed that the link mode speed was the same
>> as the phy interface mode speed. This is typically the case; however,
>> some phys have the ability to adapt between differing link mode and phy
>> interface mode speeds. To support these phys, this patch removes this
>> assumption, and adds a separate variable for link speed. Additionally,
>> to support rate adaptation, a MAC may need to have a certain duplex
>> (such as half or full). This may be different from the link's duplex. To
>> keep track of this distunction, this patch adds another variable to
>> track link duplex.
> 
> I thought we had decided that using the term "link" in these new members
> was a bad idea.

I saw that you and Andrew were not in favor, but I did not get a response to
my defense of this terminology. That said, this is not a terribly large
change to make.

>> @@ -925,12 +944,16 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>>  	linkmode_zero(state->lp_advertising);
>>  	state->interface = pl->link_config.interface;
>>  	state->an_enabled = pl->link_config.an_enabled;
>> -	if  (state->an_enabled) {
>> +	if (state->an_enabled) {
>> +		state->link_speed = SPEED_UNKNOWN;
>> +		state->link_duplex = DUPLEX_UNKNOWN;
>>  		state->speed = SPEED_UNKNOWN;
>>  		state->duplex = DUPLEX_UNKNOWN;
>>  		state->pause = MLO_PAUSE_NONE;
>>  	} else {
>> -		state->speed =  pl->link_config.speed;
>> +		state->link_speed = pl->link_config.link_speed;
>> +		state->link_duplex = pl->link_config.link_duplex;
>> +		state->speed = pl->link_config.speed;
>>  		state->duplex = pl->link_config.duplex;
>>  		state->pause = pl->link_config.pause;
>>  	}
>> @@ -944,6 +967,9 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
>>  		pl->mac_ops->mac_pcs_get_state(pl->config, state);
>>  	else
>>  		state->link = 0;
>> +
>> +	state->link_speed = state->speed;
>> +	state->link_duplex = state->duplex;
> 
> Why do you need to set link_speed and link_duple above if they're always
> copied over here?

This will be conditional on the rate adaptation in the next patch. I should
have been more clear in the commit message, but this patch is not really useful
on its own, and primarily serves to break up the changes to make things easier
to review.

>>  /* The fixed state is... fixed except for the link state,
>> @@ -953,10 +979,17 @@ static void phylink_get_fixed_state(struct phylink *pl,
>>  				    struct phylink_link_state *state)
>>  {
>>  	*state = pl->link_config;
>> -	if (pl->config->get_fixed_state)
>> +	if (pl->config->get_fixed_state) {
>>  		pl->config->get_fixed_state(pl->config, state);
>> -	else if (pl->link_gpio)
>> +		/* FIXME: these should not be updated, but
>> +		 * bcm_sf2_sw_fixed_state does it anyway
>> +		 */
>> +		state->link_speed = state->speed;
>> +		state->link_duplex = state->duplex;
>> +		phylink_state_fill_speed_duplex(state);
> 
> This looks weird. Why copy state->xxx to state->link_xxx and then copy
> them back to state->xxx in a helper function?
> 

Because in the next patch the speed/rate could be different if rate adaptation
is enabled. This is not really necessary for now, since fixed state links cannot
specify rate adaptation, but I have tried to be complete.

--Sean
