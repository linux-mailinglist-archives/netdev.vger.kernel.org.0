Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4BE42FE1D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhJOWaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:30:24 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:20354
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238949AbhJOWaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:30:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTvCJscwb+0VM1YKcVMQCLz+YxkORZ5MGmdkUHingLiW7dbFkrrMVzLlYp2ujVGBltNGu5jPBT3eRckVRIcDpAeUqzhMH5ZADCO5YvzScVa0ulG3tmZphhqaSvRFS3gZfFLEKiAheD5pvzqjf2qc5s0D8uQ8kYj8RX1iwaBjTiI8mXX4/Y82Lg/drFn7txVXc67FTTdLpJNGAtgnWVhGgkfSz694qLYgIuT/67DTmz5l5wk9Q1bYxey8js60IXut6upOhoIqKrdCEhBr/eRerUgDhUQyOIsvAhwvRcxT5UqZslcrwLWYpwYIwm9bGlAgLbua/+OT7b88pe44tzFPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ll5aBfs9jgf0yYQDO0Ffgt/QO042h0rx75lMutRNeBg=;
 b=Eq3gjJRAIfthHvIV8KknnRqa4PUe1kB+t19cdUxGV3Ech3kBZMwWyIxNhJvCNxcxRf+1Z/YVzMlQLz+s9X8ncI8VQfbJyaUXZNBmBot+kfmhC2PCgIHu9MfV6DVgqY0Ncxx37faxNuZ7F/86mrb1WP4Boga49csG+eoA65K9vmCFjxlzNm3VfERdE4hUuRGocEA4+vSMVgbqNl6Q2zxn2KELgq5fUEbeDXJM2WBrdo/LsGuNVDiWX+gc/BWTzOUxi1qgOYI4i5x3B5TcmK2OuVakE3Yh12tecSIftYLJuZkEuvpx5olvnkZAa/PCsh4qxERSNooCC1G7pYfcWm5P8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ll5aBfs9jgf0yYQDO0Ffgt/QO042h0rx75lMutRNeBg=;
 b=iOh42VPVbjbJtZzzwAdLxmNKHwNJES26X6rWoYmm0UHQiu37JWYVG5h4n0Sw33+ZQdjoLBaDO8LC+foqdWlP3S4HJHEI1V4tyVc9uUFhKWsn/D98eiuPB1qNnvo30l5lT67F90ZSimADa/9Z/KYnwVsofcvooPXFU9ETwkYdcrA=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR03MB2967.eurprd03.prod.outlook.com (2603:10a6:6:36::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 22:28:15 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 22:28:15 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
 <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
Message-ID: <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
Date:   Fri, 15 Oct 2021 18:28:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR02CA0046.namprd02.prod.outlook.com (2603:10b6:207:3d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 22:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a17f1527-4bb7-4e1d-f4a0-08d9902b1456
X-MS-TrafficTypeDiagnostic: DB6PR03MB2967:
X-Microsoft-Antispam-PRVS: <DB6PR03MB296768D416A359D80B73FC8596B99@DB6PR03MB2967.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y8xTIs1RyGRxlkUWX/hwCTBlXsaMcYM7qpy2kLA3hQw18w0yw15eR114aYJftY1jY5vK9r3FsDSJKETsf7CN8YlMiW+NV45a1bxAXSCewLO8B1N1wP0wbN8Wo+rLRZGc+bzz7nRslmC8hVChNpbtfhWpZR0AwiQ1ghyoA3N+R+LxVmOe9o8xT6blFOs3B7JSH7En7F3LMi01IUZ0vpg52rfwfWo75xpIc/Z6hEq8TMZmNGX8BjWV82yEaxT3eKYWP0ziJfb+iHuuHuUffnLCT8cfjXB1ZSDUCqsrOzQ8yoE8wqjkBK3Izm5HPfJOOIqe8mFQga4VATcZ1LP2N3t7GUcTwAMyWN1zhpo+7QT5JUfzf7znVgyla5yzICLSIUOaO2bt198VXiuJsHjWBzk6OXdnFhQ/5NEb12ryKxP2/LVvqujwBMSy1zw7Vmu0A/Bouj37fxKyGsTCBUMDYZbGZqsO4J6j9qOd6AlnN8G4eYtVHpNeU/XTo7cxlHAQDWlJTsg1LD1gfbLkHE3kR3wVy3ZQ6HhRwSdQYcHlYNs3xJtPz23c0BE9jlB1+2goQf/+sCEfW35O5hRvEJqmKK1+7ngM+4qCB8AGzD8xM+xzRd9/x3040CljVA++eCms6v60nQCEfNoJYPyrT1eKWaMve3WrxDsBK9X3J6wFHFuDIMmPF1p72XttRMf6Z/BG9GTkoqoL6t6WBWk2okZbB3DHTNQIXCEZkl1i5/KP7QbwQ/+WdQ5z3SdxQe452FNfhD3Fg/5nrELVQ1noqzg6VyimffNKiHojkzZYIaECfgYhazJJvLw1l5s3SNkaT/Ol9AkDyK/Mv3F9LJkRSRvg/TkGm7SfvAl5XMJV+kFJcIaeb7A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(86362001)(31696002)(66476007)(6486002)(36756003)(16576012)(83380400001)(66556008)(316002)(2906002)(66946007)(8676002)(53546011)(26005)(52116002)(38100700002)(38350700002)(966005)(44832011)(186003)(956004)(508600001)(31686004)(6916009)(8936002)(5660300002)(2616005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2d0TUpMVnRGV1Z3OFQ3WnpkUjIvdmZlcHpZVlo5elpLcnVhOHFFNnJOa05O?=
 =?utf-8?B?clBWZEd3bXJQS1R3SXg5VlRYOFFoSVRMWWgya2ttRy9QcGtlaVdGOHV6UHI5?=
 =?utf-8?B?eDVDckp1WW1MYVNIRDhSN2IvdFRpeGdDNU12ZExWd1BWOFlNTW8wZlhGbkRn?=
 =?utf-8?B?K3lFOFpmNFlGTVZIMFhiUU1POXBlQUh5ejEvUXkwNGh5bC92TzFtQjdZQlNC?=
 =?utf-8?B?dmNtYy9weGlwYkNpcUFGQWxST09RMFFVbjNNSGFiWWpYano5R1RlVVFGb2p5?=
 =?utf-8?B?WDZOOVFML1dHN1hlRU9qdytJcUYxYW8yaDJSTWhQNHVNYUc3RWMxSHJXaVF0?=
 =?utf-8?B?WURveVdOVUFxbUZNYW4yNEplUjJHeTFOa1VrLytOM1RpSkViZjZYdlJxUjZF?=
 =?utf-8?B?eVd0V3VJdmxwRVIwclBmSHA1N1dwNGhFNkFvcHlub0QxVTNZcUVFd2l1K3Vy?=
 =?utf-8?B?WmJDcHpscGxheWpNRjlsN1NQVVhXNU1SNFEvYWt2WTgvNXNSc3BuL3JXU0ZX?=
 =?utf-8?B?U2Y5MVN2TnRydzZ6SkJxdmk1Wk9xc3NBZzgxSTBTblpiYlI0TG5yUnNFTUM2?=
 =?utf-8?B?ckk5dHVXYTBiZHVIaGZBWGdQNjU3V0Mwbzk0dmxKZCtZWFpoQWZGRUp6Kzdu?=
 =?utf-8?B?YjA1T1dkL0xZQVM5QzlRV04vRSsxaitPVUpUbXV5NzVlYzNXMXpVL3pTSEhY?=
 =?utf-8?B?blgwNFhVNEpkSlZ0cVMrelpXcG9JTXhGWGFjWW1WMEhnNmJHUDExNHpCSjFn?=
 =?utf-8?B?cVVLY0doV0NHNjJhV1d5QXRQZ25MM2RKc1VYU2Rsd0s4UnZGeTVCbmFpQ2VZ?=
 =?utf-8?B?NDg1TjZJWU9jZkM4b3YyS1JyWlRhY0xBQUNPWFNFNkljTkllK3M4UDZIeUk4?=
 =?utf-8?B?Y3BzbW43YnAzTG44OE1OS3hWTnZRL01GSXpjeHY5Qk5wMWwwZlJsUkJyQnF5?=
 =?utf-8?B?VVVVM3BzOFJkdFB5eG8xYy9jWlNCYUVxcS9zbGlHY0N2V3FSMFVodUhQaXZw?=
 =?utf-8?B?MFArL3U4ZUpleURwQ2VJc1dIeUkvemhneFRaaU9BQkQ1WitNWW4xOVpMQTFV?=
 =?utf-8?B?bnBqNkpMTDdNWXFON0ZqS2xNa2M0Z1VwR3E4cG8zbm8yVXBHMDBKeERvazVt?=
 =?utf-8?B?aGhQaDdDdkZ5Rk83eGdzVGxlTzBHVDRkak5uTzVGdEVjaUo3K2VaaXk1ZVVY?=
 =?utf-8?B?MzB6ZzJmTXA4SVVjaGh5SldiQk1iR0J4YlR5WlZKd2xwRjNudzd0eVQvTEpO?=
 =?utf-8?B?elkvUE91Y2dCdjFLT2ZsaWdCSVZCaTRiUmJmSU5hRzFrdmFhQ1YrTmd3SEN3?=
 =?utf-8?B?MzZVTjFWRjFXSm4xbCt3cEpQQk1JZ3VTU1pGMTJzdXR0Z29QK0FlbnFLUkdH?=
 =?utf-8?B?clk2dFkzL3hoU2xLY0VtMU0zbFhOWkpkZEJrQSs4RHlkNjJtSEluTi9pbTEy?=
 =?utf-8?B?S1hsRU5OWnN1R2JHMkVhVHZ1ZXl4NXd3MDB2bThrTmVlaVE0SVB0RnNXUE1l?=
 =?utf-8?B?NHBrTnliYjV2dEJVS2dRS2s0NUlJYnpoQ2YrdWRYVGNVK2MvdVUrSkM1SXR6?=
 =?utf-8?B?VGsybW1RTnVLKzdhYWU0Y01EVjdWbEdJUGJwcCtIUnFqZjR2dEFrOEZnNTcw?=
 =?utf-8?B?bHQrMTJiY1V3OEVrRk45dUtHK0kwNDdMdnRDRWkvQVhJaXdCTnVYUkc4STNT?=
 =?utf-8?B?TXFHNEdKVEJtSkNPdWxBZlg5dzZiUzd1K3U3VnFWZjNNd1NZc1pXZnBxZW5n?=
 =?utf-8?Q?4oReFI6HOSHfzvXBT0AHIIcPKZz5jF4FsqFVGO9?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17f1527-4bb7-4e1d-f4a0-08d9902b1456
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 22:28:15.0711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGks9pqvo1szATs9E7rr/sjAvUV5gwAIGHQM9NvyhucSbihk/4QDP1T+oMrZ+qpRLeq+cyG/6H4sBTOS+Uo0BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 10/14/21 7:08 PM, Russell King (Oracle) wrote:
> On Thu, Oct 14, 2021 at 01:50:36PM -0400, Sean Anderson wrote:
>> On 10/14/21 12:34 PM, Russell King (Oracle) wrote:
>> > You can find some patches that add the "supported_interfaces" masks
>> > in git.armlinux.org.uk/linux-arm.git net-queue
>> >
>> > and we could add to phylink_validate():
>> >
>> > 	if (!phy_interface_empty(pl->config->supported_interfaces) &&
>> > 	    !test_bit(state->interface, pl->config->supported_interfaces))
>> > 		return -EINVAL;
>> >
>> > which should go a long way to simplifying a lot of these validation
>> > implementations.
>> >
>> > Any thoughts on that?
>>
>> IMO the actual issue here is PHY_INTERFACE_MODE_NA. Supporting this
>> tends to add complexity to validate(), because we have a lot of code
>> like
>>
>> 	if (state->interface == PHY_INTERFACE_MODE_FOO) {
>> 		if (we_support_foo())
>> 			phylink_set(mask, Foo);
>> 		else if (state->interface != PHY_INTERFACE_MODE_NA) {
>> 			linkmode_zero(supported);
>> 			return;
>> 		}
>> 	}
>>
>> which gets even worse when we want to have different interfaces share
>> logic.
>
> There is always the option to use different operations structs if the
> properties of the interfaces can be divided up in that way - and that
> will probably be more efficient (not that the validate callback is a
> performance critical path though.)
>
>> IMO validate() could be much cleaner if we never called it with
>> NA and instead did something like
>>
>> 	if (state->interface == PHY_INTERFACE_MODE_NA) {
>> 		unsigned long *original;
>>
>> 		linkmode_copy(original, supported);
>> 		for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++) {
>> 			if (test_bit(i, pl->config->supported_interfaces)) {
>> 				unsigned long *iface_mode;
>>
>> 				linkmode_copy(iface_mode, original);
>> 				state->interface = i;
>> 				pl->mac_ops->validate(pl->config, iface_mode, state);
>> 				linkmode_or(supported, supported, iface_mode);
>> 			}
>> 		}
>> 		state->interface = PHY_INTERFACE_MODE_NA;
>> 	}
>>
>> This of course can be done in addition to/instead of your above
>> suggestion. I suggested something like this in v3 of this series, but it
>> would be even better to do this on the phylink level.
>
> In addition I think - I think we should use a non-empty
> supported_interfaces as an indicator that we use the above, otherwise
> we have to loop through all possible interface modes. That also
> provides some encouragement to fill out the supported_interfaces
> member.

I had a stab at this today [1], but it is only compile-tested. In order
to compile "net: phylink: use phy_interface_t bitmaps for optical
modules", I needed to run

	sed -ie 's/sfp_link_an_mode/cfg_link_an_mode/g' drivers/net/phy/phylink.c

Do you plan on making up a series for this? I think the end result is
much nicer that v3 of this series.

--Sean

[1] https://github.com/sean-anderson-seco/linux/commits/supported_interfaces_wip
