Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695DD42E088
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhJNRwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:52:50 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:35553
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232773AbhJNRws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:52:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCp8J95GKRTJ4w8aT3OZQWzaL1Ba/R5wFKorL2jdx5ASG3wf0fx1AkF5LJZPWT5JVP0DaC6R5BRj+rxSiCH8s2QyA3Sq4hPq7u9pypCk8ufeMJbuLKbQzsrg6KArAbNmJLKanwzuwAlaC0XIPkMEpiyLpnx65LkoACyo/sMGW2GocqDRDKBGzeHubwsVoi3LZV6RZI/wHk20yU4EIPc1h56KrVwyNcbx/h4BGM3x7kqlbKv+2xT2LqKJgueUL40Z1t+fjndPECLmK0rSrOtRGLV9Z6OtYaH0OFezXqY5BcjOV3Q8Xa1ljp6Rrt1cBA8ggNZEBuM5wKOzhasd9PQ/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJquFu5bjBmEdDhxVeXxzpycRnaUug9UBOpdLBFMg8I=;
 b=CWxwIoXpNKbNkWDATNBuzqJx7rdIj3sy+e0gjKiArsBfkj3VsdTlL8H9gLUUBxkiqpVgHeoc0pEfikXV69I3W1WV18cEJtgFhSToRMTvXPhBQtEa7YMt1ZTT6m5d6N2TcEVpMS/jnDc/d29MZavsrmvdZYvRCzg4BRwHIf4ktYIJqyWm5HyOna2xz6YBSXKXoDDTWQnm1u3FU6jAgWG7CSYoUtfFHKDonQ6IAWfnfGje/Qzi+FNlI8BXl1VQ8gbTE2s0tguSBSH7Epnm/1C/ElHWHPRnP8zgDcW/PS1B+dD+1zDbQEttuv+kNmlB2/s6mU/+lDyeCt1E7Mkt4+taDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJquFu5bjBmEdDhxVeXxzpycRnaUug9UBOpdLBFMg8I=;
 b=WdfbaeNJT5tg6adForWzA+zqafRlH2gyf130WYRL0mMLYp12klmyu9MYlPxsTZgc7tfcl9moZiGM3r2kN0N6QW5BrlWRXMngmacSHSJj080BD/Ea7thQ/SREvFHkG8wLlfHKsKH5gdQO15OKUftjBjGIadN9cgLxKGilSDaJOT4=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3804.eurprd03.prod.outlook.com (2603:10a6:5:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Thu, 14 Oct
 2021 17:50:41 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:50:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Antoine Tenart <atenart@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
Message-ID: <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
Date:   Thu, 14 Oct 2021 13:50:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:208:23b::9) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR11CA0004.namprd11.prod.outlook.com (2603:10b6:208:23b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:50:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b398125c-c91d-4065-3a66-08d98f3b2352
X-MS-TrafficTypeDiagnostic: DB7PR03MB3804:
X-Microsoft-Antispam-PRVS: <DB7PR03MB3804A963D338050FD1AFE9B096B89@DB7PR03MB3804.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFuYVt8bDMGgBas2iauN+400Wjl8FT6gC11WQmaRbOiz+J1ZlHn0xgenBV6urG57oWBaAGpNW9wrOAZsf35qbJMTXrjAXc3oXeTh7hue3A+fygn6adH5YUHepvvRV2ul9DcMHpCYbyMUsBS+SzFYThi/G84Zd47lJMKTFhvxSn7bMhBW45afYMjpO3HfnIrxbGHndcIMBZE3pVIIblryZlEiRhObVRiXcO6jcdhGRuE72FWECxAZtpeWXawq1KRxpq7wPjaNTsvk2xHmKf3XN/4nvpNVVi8KHnsaoNjWolb0lMmJHBzvD706Susudf3S7NfXOpyc0ZGf7ykvw6+xRhIOwsbVLntHPAVvN9Ps8ZnDQPmhRrnj5GqvU6diIPpeOpJ9mZ5SXWgou/TXrzRHt9PWudIZLGDn6w7rbkkiNRA6y/TXbRG+clY1QBMb/YMuHW53aXZ9yxy/HT87H2WUSruadhD97EYH0jYbzFqusKx5yD6u0vXWBAdiZrhpev4XAX5lGvzM5K+p3r/AdEGy3mms2wsJGTe5nhFy+icBpUeE7Jl6ug6blq+Godudg8jeOv3H1vpSpegsyA3Qq08nc7p48+EsfGSV3GsMi7zmdC6VM1qMYzD0SF+Ob6OHFWF+sayYkoTe9ymnAl1IgAXqy8xg/dm6toFubn5FzyGtFQmIBLSPuf2fLBw+gvrCeFXya7o/qBdX/4fstitc9WuOOJB1NO2e41UCiNNFpAYaXS41uwp25UxL8HZoDXpVofMV8M8n6SS5iOnARrIaeLQQ5vN/HVSN4fW9z5f4g7sDpCIWcPPhMYY59Z1wCcthcnowigD5Pt3Hm4EU1zBFRv7CK8Bj8j1us+fk8hSQa8EOcWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4001150100001)(44832011)(6666004)(2906002)(52116002)(66556008)(38100700002)(83380400001)(110136005)(31696002)(66476007)(508600001)(6486002)(4326008)(16576012)(316002)(66946007)(5660300002)(31686004)(38350700002)(956004)(36756003)(86362001)(8936002)(8676002)(53546011)(54906003)(26005)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2VQSG85Wm9EY3lJSXRiRlBzR1phbUIyNlo0b24wZEp1U05EdnBPWFBwZ3pl?=
 =?utf-8?B?Y0lUOW1tYWc1RUl0ZHNYMTJzRjVNMjJtdDZXMll6VGhrMmxQcnY5eDNEOFlG?=
 =?utf-8?B?SlBtMGV5RTVkcEVSVDcvZFd4OW1YTkJpbG54WTFuWXhnaWFOUEYxY3FBQnBM?=
 =?utf-8?B?UVZ4bUFhNDRoSnFHSzcxSVRQekR4VTNYSkRRQTZ6Vm9iVWcvZUFhTnBZNlhY?=
 =?utf-8?B?ZUk3TVhiVHhjaERDMjk4SHVhY2k4Z2JvU0hrVzBvbkhoNHNhRk1iVjRjV2cz?=
 =?utf-8?B?WmhMd2ZudDJxNkg5WThmaUMyL3A1NnlHWGZUNnNjMnAxQi92NTdzckxTOTR5?=
 =?utf-8?B?Nnc1Mmw5Nmlva0xYV2RLWnY5UTFKS1l5RTVDdWJrQXdFcE5EaU51WjVjVjQv?=
 =?utf-8?B?SXU5NWFnTkQwb1k5OVN6ZWRPVzM2SzBwM0lFUzlINW5XRVBPR1JpNkNlbXdq?=
 =?utf-8?B?K2Z3SzdvUjBLSUo0K0gxU3hGc0ppRlZiSUU1L1J3VGNSaHRaTkg5VTlwY1Qy?=
 =?utf-8?B?NCszM1lxNTd2cm4yN2tqZkx0NThFOFlLZ0o5Zzh2cVdUalZhSjAvcTNPQTBF?=
 =?utf-8?B?Y0JnWDB0Yys0d0F2NklrbWFxemp4elJmSlZNYzdDN2NDQkt5Yi81QkhtQW1p?=
 =?utf-8?B?WTB3U3BSRFJvQ0ZMWTh0dG1qOHJBR1dzeSsvQ3RmWTc1OFJ5bEhyd3M4OFVT?=
 =?utf-8?B?OWswSER6aC9XdzQ5VWtjdlhlaFRLUEtWQWhpUmFOaWduVTRKZXFrZEo5elVr?=
 =?utf-8?B?NEFpTXc4LzZ1ZGdHcWRwVUdMaG5qbDExbE0zbkRvcU4xTTlGb05ZTDlSVTJ1?=
 =?utf-8?B?SlUvRzJwUTl5dVRndG5xSER6a3BHTWY3bERLaTFTclMwV0t0L1k0MWxTRGF5?=
 =?utf-8?B?RUVIRFpGY01GcFJ2Ui9EcVRFZ0Q4YzlsN09Rc093bzJIN3lkOUVpN2QreGJR?=
 =?utf-8?B?WmpLWEprY3lFOHVQLzI2NEZ2UmtDczh3alQ0aHFkM0ord245aUZvbSt2T2NZ?=
 =?utf-8?B?UlFxQTB1VDFHUW82SzJ4YmhIVUZEaXVsQ1hFL0diQ0FnQjRtcUhvQlRiWDZR?=
 =?utf-8?B?emw5K0F4YUtCNjZTTFZyNlgrZFk4dW9LZjFvdXFVTDd5OXNZY0dNcFhXMzhN?=
 =?utf-8?B?OHl4NXdDUWplMHpNMWRSaTJad29ja3FaZUdwSDFkVnBlMXorNHhMMUhtYU5w?=
 =?utf-8?B?T2Q2Z3NHY21qeHFVdkg3cWRYYlB0MFpkVGRyTXNtSitKSFBFand1am5ESE9v?=
 =?utf-8?B?dkJiaUhtZjBLc3N5MnBUSkdmU1E4bVFaTlo4bXNyYXdObVE0cllRTnlnY2tI?=
 =?utf-8?B?b2tTN0xhS3JTZzdwWFZlSmtwa1ZnK3hKaGovYlcxWlhPbzlieW90amc1OUM5?=
 =?utf-8?B?R3Q0eWpYaThZRlR6emFEd1IzMkZzUEl5QWt2eVA2ZUhneDhybzBpa2h0QTd0?=
 =?utf-8?B?M0RoREhkSXZTSGZOaVYzMUtNcDRDS0huZEhvalZGSnZnQStZSW51di9XMll0?=
 =?utf-8?B?d2Rtb2FRWXFkWXFsTlVzaXBwQmxid1lVZ0ZqTzZGL3cwSlR0NjRFV2EwYy8x?=
 =?utf-8?B?Q3FROHFpNHlZWmNpU01WVFNqeW05blFnR1VUOXpvaEJoMytkN3FSTm5XWHl1?=
 =?utf-8?B?cURkWjFrNXdKVTNsbnRSWHdxMlFINmZJVUZIa2E3cXBQTHA5b003M3k3bFdi?=
 =?utf-8?B?ZElqMk1tQ3ZjRWRUeGFZcGEwa2ZyQnltRS9sbmpQM1NYZ3lhUlBORnI3a2dj?=
 =?utf-8?Q?LlAQXKi5sF99f2Qp7mnDaopURR3TzcJ/1DZAfXv?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b398125c-c91d-4065-3a66-08d98f3b2352
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:50:40.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDUNsq8HzTvNnMxsCjKT+QZYWr6vGH8CTwlP+qAl/b6//pwNerdWvrjGHftuGKyHpwSi5C1L3G1j9VcjwTdP9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3804
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/21 12:34 PM, Russell King (Oracle) wrote:
> On Tue, Oct 12, 2021 at 10:33:04AM +0200, Antoine Tenart wrote:
>> Hello Sean,
>>
>> Quoting Sean Anderson (2021-10-11 18:55:16)
>> > As the number of interfaces grows, the number of if statements grows
>> > ever more unweildy. Clean everything up a bit by using a switch
>> > statement. No functional change intended.
>>
>> I'm not 100% convinced this makes macb_validate more readable: there are
>> lots of conditions, and jumps, in the switch.
>>
>> Maybe you could try a mixed approach; keeping the invalid modes checks
>> (bitmap_zero) at the beginning and once we know the mode is valid using
>> a switch statement. That might make it easier to read as this should
>> remove lots of conditionals. (We'll still have the one/_NA checks
>> though).
>
> Some of this could be improved if we add the ability for a MAC to
> specify the phy_interface_t modes that it supports as a bitmap
> before calling phylink_create() - then we can have phylink check
> that the mode is supported itself prior to calling the validate
> handler.
>
> You can find some patches that add the "supported_interfaces" masks
> in git.armlinux.org.uk/linux-arm.git net-queue
>
> and we could add to phylink_validate():
>
> 	if (!phy_interface_empty(pl->config->supported_interfaces) &&
> 	    !test_bit(state->interface, pl->config->supported_interfaces))
> 		return -EINVAL;
>
> which should go a long way to simplifying a lot of these validation
> implementations.
>
> Any thoughts on that?

IMO the actual issue here is PHY_INTERFACE_MODE_NA. Supporting this
tends to add complexity to validate(), because we have a lot of code
like

	if (state->interface == PHY_INTERFACE_MODE_FOO) {
		if (we_support_foo())
			phylink_set(mask, Foo);
		else if (state->interface != PHY_INTERFACE_MODE_NA) {
			linkmode_zero(supported);
			return;
		}
	}

which gets even worse when we want to have different interfaces share
logic. IMO validate() could be much cleaner if we never called it with
NA and instead did something like

	if (state->interface == PHY_INTERFACE_MODE_NA) {
		unsigned long *original;

		linkmode_copy(original, supported);
		for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++) {
			if (test_bit(i, pl->config->supported_interfaces)) {
				unsigned long *iface_mode;

				linkmode_copy(iface_mode, original);
				state->interface = i;
				pl->mac_ops->validate(pl->config, iface_mode, state);
				linkmode_or(supported, supported, iface_mode);
			}
		}
		state->interface = PHY_INTERFACE_MODE_NA;
	}

This of course can be done in addition to/instead of your above
suggestion. I suggested something like this in v3 of this series, but it
would be even better to do this on the phylink level.

--Sean
