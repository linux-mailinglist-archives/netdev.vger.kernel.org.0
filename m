Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F9065F358
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbjAESED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbjAESD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:03:57 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2040.outbound.protection.outlook.com [40.107.7.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5354B58304;
        Thu,  5 Jan 2023 10:03:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5Yt6sHiHqd/Vd5dqw1tW4Yebn2RSW3w4vtU8Y0ojsm/QDFTgZjtv4FKHwxEbelXY9nMaxDyObsU49yDZYpf6NIbyyVndBCvyBsXTdN2WgXrSFgmVK6gU6ZxcctnYXA7qiCqMWnpl7OgV0tPIrd6TjGcl1nypPWRZVPr7NycIjM4whrmLuGUXKzohJ9IFvtu5sxJrolroIXSTbvfY6RSjeCq/PW/MvFJI9oRFG26PRwEOLNR39VyxK/PQMbyiogtn5oCiUYz6VA4jGtDODGgPCQQx2dcEhe1edrUKn8HmJRksE807SHgR3zJCrjPQbpQ/SjwaTtQ8mlSRhT47+iwpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoj9DFmTl/jsy2uU0veVZJrssAweEUNOadhzR5i/Z6E=;
 b=Los0QmvVjxO8sYL8IA71IoqDZWQD/Upj4XA8YkQVomm3O2JkZaOvt1kbi4rV/9k9H20g+HscIpIH8drigC3L20O2EGd//w5yjLSfEgYtcjCKZGfgfaFQ8M3JLnrzBqb/Ryn+xoIL/axCLSN2gadDbATzPj39UG8M0ashcc6ohJ7NnHoXAiLEA+sh27R/RVbJm1L6kowLRdznedR4gpmCgwhAl0rCB1sx3ZULGkzPcqUTkxDQyqKHMcKBtr5jc8/95Xmc17N7pCNWFPKLhSJRxnAwy0vu2W8whRAciFG0lcG633dlzpHNyJWMsTxbOutQw3cYHcgxYgV6swNpkxwoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoj9DFmTl/jsy2uU0veVZJrssAweEUNOadhzR5i/Z6E=;
 b=QmLcwpvyQCya7aY3bUGtWuVj3OlTdPQ0fzR8xfCvZyQ1GHH6VfFb9/2XgnKs5UwC/LZ1g2VqG9D7ZGdDU7yzHhHnoILdhl2t7dTt1HXLT44XOilsZ6ip12OJju6rB5V9+sdDuIA/ltCNyC44bKxOzSCAIkog6bSTwoG6wsd0tmN82y+mXriTMCnJAAJhQkKRDr1mmRgM9j89vaY2yCS2bEEpBfnfwPkK15I1xr9to1KJBnyD8J3yF5fXjWcsG5hpmUVzC5q4c8L/pXE+Jc7EZ5tuqIi0aOAEPmE8xLmVD807+DRW6ZhEGb7dPnbWiuEiTljw8XgmcWAugOHaJiJuUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB9817.eurprd03.prod.outlook.com (2603:10a6:20b:61b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 18:03:53 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 18:03:53 +0000
Message-ID: <39660d10-69b9-fa52-5a49-67d5f7e1acaf@seco.com>
Date:   Thu, 5 Jan 2023 13:03:49 -0500
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
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
 <20230105175206.h3nmvccnzml2xa5d@skbuf>
 <20230105175542.ozqn67o3qmadnaph@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230105175542.ozqn67o3qmadnaph@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:236::13) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB9817:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c830480-dcbe-453c-ffcf-08daef4734d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gM0hxiKULwOevOyaShc2FGBUY8srQ1ihFeWreXH1bat1xoZa5HGExsPDMAz357zkIdd+TQnbyHiTLz2QsEhZBIMLim6ZcWm47uQ97I6YZSBW7TCK0LQ1NKCq6a0P2Stx4pFdQWGXSdkrIFMB1SYUmFgOLuKjbjUOtKc57emkxcQTB+TvELT7I13Ccjh2UGudyiMHCicp0+Cnuwjr6/N+iCAZQ1EI2gc6eCD4FcJ/e23U7UaIwrd1b1IiE5mYo6lvdWAYuS9ZPBxuI7oUuu9u98VAHfGx7e3neQMVm1ZA6of9p2S9xP4k0RjlQL+HLu5qcN+ypMiwSklpFXYL3yZkXViDV2ak+Q5sI2tKqkMHorqn8hKZE4bVfdI2FTTjkX6XjrTs4U1UCxmBRFEqigwtejItENzED2TH9SmYeU/q68PZgddYrmi7VY8VgT+GAS9KUciLQ/E6/jH7EkRW/KNQ3rcPgYwjd/Ngv09rimKQ9eB2vM0kQO6V6uf9XI9svnYmhTWczf4eoEHmVJaYBIgwdi+BANRSPzl72CrisKD5NWx/6S7wfFTo8JrcItIiToY/lMp/URn08L+0SNSP5rhMHruxKaT3ez0v/92vugPvHziv8vtFT5Ki/Jc/T7S2zc2Tql+kEuWWS2xo7sFaPMpvpY6BIFI/9pcGRQnyFQwcISwsbxjRKOILWtMtyLfAI9FqdIVUAcAwdZ6EfeANc+QK9yyMYf7w7dQFO7aIfgtg2LTPO7+BgN/bDOWDpqhv+sLTyiLwdSAVNa9Q+vMRWXa1Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(376002)(136003)(346002)(396003)(366004)(451199015)(186003)(83380400001)(26005)(6512007)(2616005)(31696002)(86362001)(36756003)(38100700002)(38350700002)(44832011)(2906002)(54906003)(6916009)(31686004)(4326008)(8676002)(66946007)(41300700001)(8936002)(5660300002)(316002)(7416002)(66476007)(6666004)(478600001)(66556008)(6486002)(53546011)(52116002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzF6TThJZlRwT3NXZVpWN1VwWmthcC9ON0swME1qZkZlWnBKdGJwaXhSa1B4?=
 =?utf-8?B?YjFDUzd2MTNMREUxM2VrNTFUbTMzUW03UklJRWN4bEo2djhnN1k2TytSYlI5?=
 =?utf-8?B?bVF5VkRFNjJYTXNvamJQR0xGbk0xazZDendiOHVUSm5NbWJ5V0NoenZzU1A5?=
 =?utf-8?B?TlBxSjJEbE0yZFlYZTB0MC9lTnVZQ0dhOTNNd05HcFdXdmJjVzVvUkcvTllW?=
 =?utf-8?B?S254eloyaHhjb2hHakRtR0s1WFR4U2pCZy8yN0xCcVFJVjEwVDVjdEVwU2pH?=
 =?utf-8?B?U0NxbklhRCtNVVo5YmdwaVk0OVdVVC9YNDE2TmdFRW93TmszbzAxUlBudEVD?=
 =?utf-8?B?aGpGdi8wT1VOTXNURE9GQldvWjBoemh2cTRPbStGVDl4aERMZ1Q5QkhFaDB4?=
 =?utf-8?B?RWd0SCs1TSt1MUptdGRRRS9lRUQ2MHJlMlNsQmZWZnRzaXhrMFFPYlQ1b0My?=
 =?utf-8?B?b1BJSzdtcGM3UTU3Z0VOcjU4YUlWY0t0VXExb2dDb3YzQ01Uc0F2Rkh6aVpS?=
 =?utf-8?B?UVFVcDVucjl5S0tFMUx2OHRXbUk4ekt3ajJ2aTR2WTI0QVNvM2FQZmh5YXdk?=
 =?utf-8?B?dzlJZmJWOTF0N3NyNVMwRjh2SkFib09BSFZ2UUg1eTdwM2ZaZU8vL3hVNzhx?=
 =?utf-8?B?TDRtM3ZVdjhpY0ZHdDB0VGI3eVhTOWZDZ2plY3BrQlhqeVFXU3dnY2c0Y0Iz?=
 =?utf-8?B?bTVibzdIY2s4MEsyRlhCYjhlNStTRzRLT2xmQytXUVMvWnc0SkJTSU5jL29F?=
 =?utf-8?B?TUR1M2MwV0hUNUtzSE5mZWNCb2xxUFErT3Q0dVhVQlRNMnFmd21yY2hBZi85?=
 =?utf-8?B?VFV2TEVsVnlmV3d2Q0dHWjRyYi9VVlQ0Mll3ZEZCdmM4a3Rya1pPaThtZ2xF?=
 =?utf-8?B?WEJKMUovM3JYaVJVL0IvV2l0UXllS1R1VGhkejBqZlVYL1NwTlBuclVxWkdV?=
 =?utf-8?B?MWhkZnB3U2dkRFJWUSsyV0pJdVZlTk1hejk5cEo1dGNlTUVDaVhyZTVKbjc4?=
 =?utf-8?B?ejB2YlM5czNQOHpXSHgxL2RCa0J0UkM1ZnlLaDFjKzBvTUtLL3Frd1J6am1m?=
 =?utf-8?B?d2dwNmtVOGVMRnhZd1VHOEtPV1B0a1lxOGVsMkdweGI1TWhZSkRjeGpSVVFG?=
 =?utf-8?B?ZUxWVk5DcHdzaWhENGdQOVk5QXZ1T2hVRm5GMDlSRmhzM0xkQnhkQi9zS2Vr?=
 =?utf-8?B?bldIR0tWUFoySmVDNXZlVXRIWnM5MlVsdjRGQUp6aHNldFlnS3BLc2pKdkRS?=
 =?utf-8?B?SHZMWEhvT25neFVpVE1QQzFqN1dIMWpIa0NRQnFFOXRLczJGRG8xREtlODA5?=
 =?utf-8?B?aFppbjMrdzRqZUx2b1RnUnp3NElYWFZqa1p3ejIzSVg2Rnc5aERhK1N3b3V2?=
 =?utf-8?B?VmpkYmc1WDFNUERWNENVVTJWcHU2dlN1RFM5OWVWeGx1T01QeUJqK0lUbFN5?=
 =?utf-8?B?czJLZ1RveHo3WjZuM1FEd2lYNjh3dTRYOUt4YW9rUm9IeldieUtHT0J2c1BF?=
 =?utf-8?B?RnJId1duRGtUbEJCcjVFOHZvcCtIRGlDQjc4TVIyR1Z1MWlCMEdlTEJUR0Z3?=
 =?utf-8?B?blZGb1J2S09OWUZKMzhzQVdkM09heVQ4OVN6WmhxY0s2VXJXbmtFbnJ1UGVw?=
 =?utf-8?B?UFQ0Mys0SHJ5d3pmQ2VMb2VPOW9kejdZR0d1S0x5VjdncEkrSWV6MnBmN2RY?=
 =?utf-8?B?UzUyM0RScE9DaUVSTDVpN3N1Z2J5aUVFSm1QakQrNElPRGQ3OWlWeW1wSFov?=
 =?utf-8?B?bk5OSlNBN05VMTFaUUtGT1luRlFmc21IT3BYZlRSMVJJcE8vL1U5b2hlWmF0?=
 =?utf-8?B?WTRibWc2a0RnSWUxcitsOGd5SlpNWnZQL3E1TERoUzNURzZPTi8zalczblhj?=
 =?utf-8?B?TjZOZ2lyTFJlMGY2Z0NwMENNazA0L1NqREJabUw3cmtzNjh3NW1OZENSVG8y?=
 =?utf-8?B?ZG5scXJyOXZQZ0NIUzVidHZJL0g1V090c3h2bDlCTTRoanUrSHJ0NHNXV3lY?=
 =?utf-8?B?TEI3TFRYcFIvRGdKM3J3Q3RiUWJvZnhaaHdnMzV2OE13N2pIK2Z3VytpZlFI?=
 =?utf-8?B?SWt1QWJWR3prT3J4NWNEbXRrRFZwR29KcXpyOHBIdDN5Z09NUXNPR3FNejlG?=
 =?utf-8?B?OW9xWDY3SlJDdEVvc2FQVEtnZmFsbEZxZjE1SG9McEU2SzBKU1pqSVB4OUY3?=
 =?utf-8?B?Qmc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c830480-dcbe-453c-ffcf-08daef4734d4
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 18:03:53.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lljDKW9VJJGMP57YrJT0PDIQ8KUWOmMpAhzYfx9vnxgk1PgyffQGXKNk//yljdZ6526XDzYQP8ruSExYEIuR+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9817
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 12:55, Vladimir Oltean wrote:
> On Thu, Jan 05, 2023 at 07:52:06PM +0200, Vladimir Oltean wrote:
>> On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
>> > Again, this is to comply with the existing API assumptions. The current
>> > code is buggy. Of course, another way around this is to modify the API.
>> > I have chosen this route because I don't have a situation like you
>> > described. But if support for that is important to you, I encourage you
>> > to refactor things.
>> 
>> I don't think I'm aware of a practical situation like that either.
>> I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
>> for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
>> As for Layerscape boards, SERDES protocol switching is a very new concept there,
>> so they're all going to be provisioned for PAUSE all the way down
>> (or USXGMII, where that is available).
>> 
>> I just pointed this out because it jumped out to me. I don't have
>> something against this patch getting accepted as it is.
> 
> A real-life (albeit niche) scenario where someone might have an Aquantia
> firmware provisioned like this would be a 10G capable port that also
> wants to support half duplex at 10/100 speeds. Although I'm not quite
> sure who cares about half duplex all that much these days.

IMO if we really want to support this, the easier way would be to teach
the phy driver how to change the rate adaptation mode. That way we could
always advertise rate adaptation, but if someone came along and
requested 10HD we could reconfigure the phy to support it. However, this
was deemed too risky in the discussion for v1, since we don't really
know how the firmware interacts with the registers.

--Sean
