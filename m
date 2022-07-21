Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A25A57D20B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiGUQz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiGUQz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:55:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2074.outbound.protection.outlook.com [40.107.22.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA6126130;
        Thu, 21 Jul 2022 09:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAY56lPSTlpcywHRi+EI2sTsMSBEoJVqXRzFBZDL9muvlTK8JnHM7EOUcKhiUWyYjhHLGCcjkEP0LD9NihT46zTL8lt6uz1mSDsSxAnJIxTinXJk+nKL2ZXIgGNRJpdJVkv6dOGyEqRHdsOEc951+6eF7EfxFKLhZa5NyehNudQvoqMbXKZH5kitGZ6JU+gf02SeIpLLtqM90GGAmP9eegnaDitVc6FnMn0wkuN1V7cvDk3UpZfAc3+fxHWvkXYlKayNhhXFBIZZHGiBNVqo7+8zrRsZqJoqGCHXLW/VoIfrxH33t+FZSLIx/ZQiZnWWGf/zu4SMhNOxEYAY0kZ36g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOoZ84wCwoG3EQctPF6HMatLIP8Ooczmpff5bo/7I8U=;
 b=jZhkj6EWDL2vJ/IQR2gX2v7IWg371r/QyFxwejbLOiIX80RqKFN+F28Us7dGnq51yuu2TmW0f31lOu1CcrpJoPAq3aeT7HXf6IWS4RRv9nq76/eGOw8pjumeZMbyFFywEXlV7xdrwFHLr/PVofhbgi0p9KsDtTsSIV89gmt0rU2BiQHhJd2iwcVJroRFXZ9UlijtyP/yoeZ33WXiQbyt3rR4gYzzIlq3/i61vP+UskHEFUqHutTKXjNWu8tY9axNmfu0HskrLhmtWqtibtHVQeqzePByVESDjiEdq2gdRAXaxLEqH/RwjFjf4WpagedTAQ2RJxRrEAUwucv+HUky9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOoZ84wCwoG3EQctPF6HMatLIP8Ooczmpff5bo/7I8U=;
 b=FvQFQhKuM7XQpLvEEsR0Eq9ZuniMARW+ydYHx7/B+Ew7ClFz4DmfEfPYbHZzVVXdWZJ7KjbVLCn24XriGoFXJYbOvWpQj/ZOnz35vAwluah5WtjGCXc5sv+ELng81+pfD7ocNNtRGmE1SzFA/LbAgbaiRoX4oMC6s4/xBxVKztFnn3vdDs7ZpJGFS4zaymYc6Jl3JOdNkbDEQpOR/1crXlyuXpzWgQRvYSdgsifP+S/bL1PBTYio9vhLIT2WNjsmRc5AsklQ5WDM+VBuPg2N5u198QH9lKPnAuDQWGWFhOMeLxIOAWpxMDE/7as3Bzl3ffze+SGpneyZb1HmvQPxHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3030.eurprd03.prod.outlook.com (2603:10a6:6:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 16:55:21 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 16:55:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on rate
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
 <20220719235002.1944800-9-sean.anderson@seco.com>
 <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
Message-ID: <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com>
Date:   Thu, 21 Jul 2022 12:55:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:610:4c::14) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fb27086-8960-49a5-f659-08da6b39cc6d
X-MS-TrafficTypeDiagnostic: DB6PR03MB3030:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEd3AHUQ0m2tRxM4NI9gQ9gixH1uYazOKQ1gtQCkz2m+ZFnbmpEmrskknOg+ydKenaUKkQxrdml9DCe1iCHTYbOFy3k9yGi4lfzQC8l6EqckGMFGCdKnbyjgmu7l9QUSXLQ7wKVhZz9ZIt+uB/s+uls81nLKK93wStrzPSubI53yQ0GmT13t7MmkxArPbt4WzkKWT4J57TVbV8oYjKxXamKtrnt2zX+ikAobBkPAgT460qCLLhiTLe2uJLibyqSPYayF2nRc2/Vfm8QyUDMvEIY++wLqH69NIPEeN5Pgx4TD4LNms3sOY/osVAviZfOLZ2kljwZbxtkdifkwtZU+K76621joIJYFakvlThvKzz4hTcPCyZbeOh9H68XEHQEukx5c6vBo1pw/08lcxGPzEI14lWgxYh0yS0fQHYf5pxOa4+LxNYDIdXuN3WJk0YTvsU/h6jzIWDdswxAwvReS4tJdaDln5pv28hRXzB1lQIRfxXQrdgK8pzj5BxDXBTb0RrsdsAAADJiqjOP7m4qVbq7jjj5Q9ws3REtMvmE/wsK6E60WExu6Gabai03hF5fY8FnfnBMQ/vE2Md0t0nwUTVNNWS4UK3y8YmfFNyr2uPCsExE1Nem10MVx9+dcFNViNyOmALhsX+tHyQXnUoZwik4dy9wweKoggVVkSvfcM9fkpFqYz+jdfv7xeYeUmVG/NfVGwRq+KndfKZv6kxJAGIG3LHgpBAWawexlltbYEDnJLqUlofZP8PCFNpI9NuNigs725fRv00JjphifQYvO88OwBO6Kt5M7jA+5VOlZK+mC7Udjjva3wqgm2BQlW59oplbtMWBf4Ix9Cso6qnJb1wXTmtPP9eWnwl797A3m1Ko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39850400004)(346002)(376002)(31696002)(38100700002)(83380400001)(6486002)(86362001)(38350700002)(8676002)(4326008)(66946007)(316002)(6916009)(66556008)(66476007)(54906003)(2906002)(5660300002)(8936002)(44832011)(53546011)(6512007)(7416002)(6506007)(52116002)(6666004)(26005)(186003)(41300700001)(2616005)(478600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWtGMjgzTXd4aG9pL0dXZ2xqK3FjZzhmUG9vR2ViTm0xOXdmOFBseGdZNVIx?=
 =?utf-8?B?MjVVenRPSThTRVNsUmRaMWdwekN4RHJqWVBUdmEvMmhPRWx6NG5sV3B6SC9z?=
 =?utf-8?B?Tk13cDZMUnNHYTZmamlhbG03VjVuNzFXNXBlWXhKMGlyZHk3aklxUlpocjhs?=
 =?utf-8?B?Y2d1VnNQa2VHOUFLVVEwdjFwaDROKytEL00zQ0s0eTB3QkFWNzZiWVl4Vk0y?=
 =?utf-8?B?bEszMlY0dm5LVVJmM0k5UmZ3WmtuRXBldUlKSUJQanZoTTc0WlprSm54ZWFn?=
 =?utf-8?B?TFlQTzIrT2kyNWovT2NUeFEydHNaT3JQK25BZ1RDbVNtYW9pbDZlUGpnYUJ3?=
 =?utf-8?B?c2pqTGlqNkdCR2FaTVNITXRWRWNIMU4rQ3FDZnR2WTRZeTBweWFrd0gwbUNk?=
 =?utf-8?B?RStrdzd4c3Y3SEptak8vVGFmc29FOEYzbFFJUkVtWm90MmYwZ001bC9iOUNy?=
 =?utf-8?B?NnpZM0JTVkhjaUhFckdQNTlDR0RpN3NXN2hkMXlDcFBhWUphMlY5OEVyam52?=
 =?utf-8?B?OHUxZlZmMTdDeWhzZ0lwNVpsY3JJL2FrSy8xNU1aUjNEZFVMRmhZdjF6MDJ2?=
 =?utf-8?B?Qmd2cnBsSmdEOFdsaVloY1p5cUpyVDQrKzdjVTRXYXhUd0dLd1RIRUlRcWJz?=
 =?utf-8?B?TzNTbjBxOEU5UVdMOFRjd1RxMHpoOXkzYzA2dVdBajE5WVg4N1htM0p2SmU1?=
 =?utf-8?B?TUpJZTR2SkN0TnFpcjAvMDdLSGZEUFRoVWQxQStWOTdQRXZTY29EcFNOOXNm?=
 =?utf-8?B?VG5Ec2FtUnVENzFoWUVQQkxjQ1h5VldWRDEzZjVTOFdqNU5KOG55enJvSm9U?=
 =?utf-8?B?c20zTEdseTQ3cVc2cXpDUEtUK2p6aE1YZGErSmJhVlZOK3VxejljZjFKVmcx?=
 =?utf-8?B?T3ZvWlByUmxEM21tL2tyRS9neDlYK2ZRZ09iOExzalc3Z0djYWdGYkIyTzdk?=
 =?utf-8?B?Kzh2SklwMmZ2ZWZ6RWhQRHNIdCt2Z2JRcHcxNCsxUHh0L3NUdVRnRGtSc0hr?=
 =?utf-8?B?dUU1emViZlloZk5tbmFtSGRISW9ETG1UVktDSkczeEZjUm56RUw0M0ZiWjNy?=
 =?utf-8?B?RXpobmYrYjllWWp0cUtrMFRDK1hJdnJMRDd2bVE3V2YwT1FrdGF5ZkhWQThO?=
 =?utf-8?B?dzkwT2lYWFNXQnRsUjZjVGxUV01obzNUWVFmbVpFYVhwN01UUkk4WHMwMTYx?=
 =?utf-8?B?TVpuM2ZlN2NrU3J0ZlI0cldRV1RCcW1kNVBsRjV3NzRlNnNsaFNNaVp2anJP?=
 =?utf-8?B?b1c3ZWpiaGhBVE5HbDdoYXc5OTZkK2JHRjJOVVE5VUplTUFiQU9PV2lzdWZF?=
 =?utf-8?B?Zm1BbTExMGszNGFVbmpxeHFhY1hIMy9QMmJLL2tLQXRHR2lqZXhVZXdkanNT?=
 =?utf-8?B?VjQ2c2QrdUloUUZ5cFFwd0tKVEZhVnNTUWxPME9QU3NLbWlhMmlFd0YxbDg1?=
 =?utf-8?B?Q0FKdHpWdjZjSkdUbnpSbWt2MWZCZmx5VG1uTCtlcENCOEwrRXVOZ1JwbkZx?=
 =?utf-8?B?Z3lQVmVOWDhIWE8ySWQ2K2dvTGxCTWR1UFNNVVpvdmRtaEF5ajA0UHFsSVdo?=
 =?utf-8?B?bkwvZlJzaFMzK1hYME9JdUprTDlKQkw3eVl3K2RGb01EYWtXWEZ6QXZGYVo1?=
 =?utf-8?B?cFFMU0J0dFlHWiszZTUwRm1PUUxXWVVTWktnbUxrWTFXMzNINVZhOEo2dWpr?=
 =?utf-8?B?bWNCZWx3aktoTzBXMWNiai9jS0VJNm9VTHBBTGZsbjdOeXFWWnQrRFJ2MEk2?=
 =?utf-8?B?cE5CQlJmSFF5RFExcCt4bDF4TkNtK1ZHOG9EU21UNEIwZXhLRmtQTGhMd3J4?=
 =?utf-8?B?R1lsWTIyblAwVEEzazVKQ3l5YjE3cjBoZjhoY01uTHlzSnp3NU9IaVpIbkZ6?=
 =?utf-8?B?cTV1VWFnU1I4NzlrbVVFVllxb0Y2RmhzL0xQeFUwUlFKZHN6RDJITVRQRWRN?=
 =?utf-8?B?b3VQNmhGbjdIdFltKzZqdGlFaStrN3pKc3hXS1BXV1dBL09lblZDdFloNTVj?=
 =?utf-8?B?OXQ0N3lLZWZMaktDNjdDeE9hS1VUTDk3UWtRNE5DOGszVHo2d2FmN2tCQ3Uv?=
 =?utf-8?B?TmdsMnJTQkJTSmE1bzE4NEtVOUlTSTE0RWZseFRYcm9hQjFoRkxLUnhvcGhB?=
 =?utf-8?B?UElCTkdpcTFka2ovekU5TDAyUk5PRVNQNCt1Qk1PUGFWcGxYWmd6ZjI4LzFt?=
 =?utf-8?B?MGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb27086-8960-49a5-f659-08da6b39cc6d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 16:55:21.5444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcpMQrGM5kjCzozWDxbUh/T/VGXaIGtr0QCbNPg6VHKiBTSPEmlby5C+Si+l7utblmpDeEzfT5pFF96r/AMHug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3030
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 3:08 AM, Russell King (Oracle) wrote:
> On Tue, Jul 19, 2022 at 07:49:58PM -0400, Sean Anderson wrote:
>> +static int phylink_caps_to_speed(unsigned long caps)
>> +{
>> +	unsigned int max_cap = __fls(caps);
>> +
>> +	if (max_cap == __fls(MAC_10HD) || max_cap == __fls(MAC_10FD))
>> +		return SPEED_10;
>> +	if (max_cap == __fls(MAC_100HD) || max_cap == __fls(MAC_100FD))
>> +		return SPEED_100;
>> +	if (max_cap == __fls(MAC_1000HD) || max_cap == __fls(MAC_1000FD))
>> +		return SPEED_1000;
>> +	if (max_cap == __fls(MAC_2500FD))
>> +		return SPEED_2500;
>> +	if (max_cap == __fls(MAC_5000FD))
>> +		return SPEED_5000;
>> +	if (max_cap == __fls(MAC_10000FD))
>> +		return SPEED_10000;
>> +	if (max_cap == __fls(MAC_20000FD))
>> +		return SPEED_20000;
>> +	if (max_cap == __fls(MAC_25000FD))
>> +		return SPEED_25000;
>> +	if (max_cap == __fls(MAC_40000FD))
>> +		return SPEED_40000;
>> +	if (max_cap == __fls(MAC_50000FD))
>> +		return SPEED_50000;
>> +	if (max_cap == __fls(MAC_56000FD))
>> +		return SPEED_56000;
>> +	if (max_cap == __fls(MAC_100000FD))
>> +		return SPEED_100000;
>> +	if (max_cap == __fls(MAC_200000FD))
>> +		return SPEED_200000;
>> +	if (max_cap == __fls(MAC_400000FD))
>> +		return SPEED_400000;
>> +	return SPEED_UNKNOWN;
>> +}
> 
> One of my recent patches introduced "phylink_caps_params" table into
> the DSA code (which isn't merged) but it's about converting the caps
> into the SPEED_* and DUPLEX_*. This is doing more or less the same
> 7thing but with a priority for speed rather than duplex. The question
> about whether it should be this way for the DSA case or whether speed
> should take priority was totally ignored by all reviewers of the code
> despite being explicitly asked.
> 
> Maybe this could be reused here rather than having similar code.

I'm in favor of that.

>> @@ -482,7 +529,39 @@ unsigned long phylink_get_capabilities(phy_interface_t interface,
>>  		break;
>>  	}
>>  
>> -	return caps & mac_capabilities;
>> +	switch (rate_adaptation) {
>> +	case RATE_ADAPT_NONE:
>> +		break;
>> +	case RATE_ADAPT_PAUSE: {
>> +		/* The MAC must support asymmetric pause towards the local
>> +		 * device for this. We could allow just symmetric pause, but
>> +		 * then we might have to renegotiate if the link partner
>> +		 * doesn't support pause.
> 
> Why do we need to renegotiate, and what would this achieve? The link
> partner isn't going to say "oh yes I do support pause after all",
> and in any case this function is working out what the capabilities
> of the system is prior to bringing anything up.
> 
> All that we need to know here is whether the MAC supports receiving
> pause frames from the PHY - if it doesn't, then the MAC is
> incompatible with the PHY using rate adaption.

AIUI, MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
ASM_DIR bits used in autonegotiation. For reference, Table 28B-2 from
802.3 is:

PAUSE (A5) ASM_DIR (A6) Capability
========== ============ ================================================
         0            0 No PAUSE
         0            1 Asymmetric PAUSE toward link partner
         1            0 Symmetric PAUSE
	 1            1 Both Symmetric PAUSE and Asymmetric PAUSE toward
                        local device

These correspond to the following valid values for MLO_PAUSE:

MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
============= ============== ==============================
            0              0 MLO_PAUSE_NONE
            0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
            1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
	    1              1 MLO_PAUSE_NONE, MLO_PAUSE_RX,
                             MLO_PAUSE_TXRX

In order to support pause-based rate adaptation, we need MLO_PAUSE_RX to
be valid. This rules out the top two rows. In the bottom mode, we can
enable MLO_PAUSE_RX without MLO_PAUSE_TX. Whatever our link partner
supports, we can still enable it. For the third row, however, we can
only enable MLO_PAUSE_RX if we also enable MLO_PAUSE_TX. This can be a
problem if the link partner does not support pause frames (or the user
has disabled MLO_PAUSE_AN and MLO_PAUSE_TX). So if we were to enable
advertisement of pause-based, rate-adapted modes when only MAC_SYM_PAUSE
was present, then we might end up in a situation where we'd have to
renegotiate without those modes in order to get a valid link state. I
don't want to have to implement that, so for now we only advertise
pause-based, rate-adapted modes if we support MLO_PAUSE_RX without
MLO_PAUSE_TX.

>> +		 */
>> +		if (!(mac_capabilities & MAC_SYM_PAUSE) ||
>> +		    !(mac_capabilities & MAC_ASYM_PAUSE))
>> +			break;
>> +
>> +		/* Can't adapt if the MAC doesn't support the interface's max
>> +		 * speed
>> +		 */
>> +		if (state.speed != phylink_caps_to_speed(mac_capabilities))
>> +			break;
> 
> I'm not sure this is the right way to check. If the MAC supports e.g.
> 10G, 1G, 100M and 10M, but we have a PHY operating in 1000base-X mode
> to the PCS/MAC and is using rate adaption, then phylink_caps_to_speed()
> will return 10G, but state.speed will be 1G.
> 
> Don't we instead want to check whether the MAC capabilities has the FD
> bit corresponding to state.speed set?

Yes, that seems correct.

>> +
>> +		adapted_caps = GENMASK(__fls(caps), __fls(MAC_10HD));
>> +		/* We can't use pause frames in half-duplex mode */
>> +		adapted_caps &= ~(MAC_1000HD | MAC_100HD | MAC_10HD);
> 
> Have you checked the PHY documentation to see what the behaviour is
> in rate adaption mode with pause frames and it negotiates HD on the
> media side? Does it handle the HD issue internally?

It's not documented. This is just conservative. Presumably, there exists
(or could exist) a duplex-adapting phy, but I don't know if I have one.

--Sean
