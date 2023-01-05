Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE965F112
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjAEQZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjAEQZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:25:51 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2066.outbound.protection.outlook.com [40.107.105.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC9544DB;
        Thu,  5 Jan 2023 08:25:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzDZB9kaaQh3g7ZMPcSu3gUVRfk5v0PKsyqtXeygZBTTUEoHDYXITM5th5Vo7lckqOcL5d0zLFJXF28cB+kHUJyUmREkPNX+1tf22KQzonH3JQyct+S8WUKLkD9Zlmi+3utsi0WDe3LBqGlscdQI+EQTCNALH0jdKXKASEdk9YHU1KUSUoitcRx30/VeQenirqeFJbxGl4g9S0nx/W0DhsOIWEvAu60zq8SqXZsu/Kh7fHFaEw5aekSHYQbZTX2NlRrpFCHw9k39+m6rkSZqq/fo4MfaJcosXM4fHazdtw0BkfVIKRC1SYD00Hn1szqHzuNpgpePgL3Svo+gLGufSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McFZyHP5MUXZ3/LB44zQXOGtohsR/gjXg+bPgEPJZlI=;
 b=U8i1G2OSgUN1MFUfaQbc9KGw5xuo23UAEzaZG866OhwNY3j80cIs1oo55DYFPgTa0UaB+etJp2O8U9D4LFxVlbnjtnX2/GKnBxqVzmB7QuICnJMSZUZnzrnrRF0618rFthCnOPix0uYdPDfHNtSPKofCn91haOdDzv7VG1X5saE513Qi8A5QjgKTKiqxn7tFOF0t8puwDica2XR3CX+SNEo0UPtqK9OsBT+2COKvm/fvl4nZ7otcgu7YG/3QIOp1Cy/7SXIqFPAYgwN93FvKjSd4mSJW3XYAktDXyB91U7NoZEh26L5asPPQpYvg+eD+huWOsd3VjYOyl2k2FrNK7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McFZyHP5MUXZ3/LB44zQXOGtohsR/gjXg+bPgEPJZlI=;
 b=fe1vRW8s6FnOcA/3NhUkXQSCY7JjkEcvURI7PX680b8FCIg09FrAW/tWqb4UTT25dlMqnHd/TOq+Es/33adXNL3bNbe4GI6VKa+wKTYsZItFfITf5t8Xx82YBo8IpWRgjbg+g8/me6bmfvJDn/kXSv+Rp798+mqHOz0e5Kqud0nMZ6Cor1tX5g8vw5ezzJXMMCH4pza1YIOUBHCKpvRpJkMjig321AAbP5enyihDN+o9A20ehIkykrvyeacxYvFKRm4YTIyQX+M0g16QPvGcMW0e49URKHRSZS3x9MBVCWdYndm7t18R6BHwpxI+n5jZG3WB7n1YG8/CBS2/yThCbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS4PR03MB8434.eurprd03.prod.outlook.com (2603:10a6:20b:519::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 16:25:45 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 16:25:45 +0000
Message-ID: <eb0f6eff-1456-1b59-b598-bff79cd749e1@seco.com>
Date:   Thu, 5 Jan 2023 11:25:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 0/4] phy: aquantia: Determine rate adaptation
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
 <20230105133906.srx57bkfdl4ey32f@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230105133906.srx57bkfdl4ey32f@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::22) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS4PR03MB8434:EE_
X-MS-Office365-Filtering-Correlation-Id: 36e01366-8f98-48b7-461e-08daef397f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HH7UpRu2dudHJmV71EDKVcsl4kfOsecSH5ZxX+jvszM/G1f+qY7katoBRD3DKNC8R797Zd5NBs3VjukFmGcsJaJM+UZ6gyXBujwgVHu5BXqo5y5LfUT3FGNFyT0YVS/jSo2Uk69NzaHUIjmUlvnbmg02D5RK1wP29VXv17zlhWbl44bC+E0hH4JB3Cm2GbW1MF4W5XKAOtnacTp0iKUKHYatsMQ6Elpy2+aUIZzg3B0hN+458/eMB1hbi6mnJrvLEdZ/dFNRV1V7ER8kkrSk9mff46h3Z2KWlu/cmuQMSHlXecVyQ2FmAvtPnoUP9OoPuMgix7Ru/wlbdeEz4OVToCrPn1CpUceiRSFY5duPgeR29ZX2ZGMiHMX8jYdy3ZI1q2rtcERuNevdUZji25IL8s+UsFD+7GeIsM/YU+pgRAZNm9syKqrlpoX5bFf1NONqf70RpmBw5mmzQuRfjSCi93CWPw3sAQ9br93OxvA8CQLq1SpgBUjZ27yoTtUfqZam5aCDVeUBg62W6TMhGcpmwR22FUMOJYb5waqjEugwosfO6K8Mvo2bDd++oKzFPb839DxRzFsrhhRXQqamE0dmXlYIqsFFvUigw++XBnSJWXRPCDLRYKJq7qKZIbW0NxmksBJpa43hV0YywN+K23A+4xnQ7LwlWbKVRscvNaMLhttzIne2gued3tok95/a5R2SuvRQvrlnNLOcOq5iD0QPhepvGxzJuVSsCRfCQkr6WKBA5MbV5r+SkNlIZ3lGmTjYUkjCVhFJqTIuIu9ECbrD8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39850400004)(136003)(376002)(396003)(451199015)(83380400001)(186003)(26005)(6512007)(53546011)(2616005)(6506007)(6666004)(31696002)(36756003)(86362001)(38100700002)(38350700002)(8676002)(4326008)(41300700001)(4744005)(7416002)(31686004)(2906002)(5660300002)(8936002)(44832011)(6486002)(52116002)(478600001)(66556008)(66476007)(316002)(66946007)(6916009)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVFLU1N1ZGErY2s1OFV5WTlwZmIvRldHYzV1UXlUaFRvZFoxY1VzQXJLK2VD?=
 =?utf-8?B?UExqSVR2TlR6Y2xWOXBoNWQvOTRKYU14ZHZBeXNPZGptU01UQk5mY2t1OFZX?=
 =?utf-8?B?ZjQrRW9wMWpNdjM4NXVnYkduQWYrZEZGeHhwZXZyM2RYQUttdFIyS3JUZGtl?=
 =?utf-8?B?c1F4c2lWdkZDbmZ2WmIveW1RM3BUci9EYTE3dWlzK1g2MkUrQytNUURtdllu?=
 =?utf-8?B?S1VEcERlcm1nWVg2WjBJQlBQQ3o0bUpYY012NWxUbzdaTU5GbGRPOURmakZK?=
 =?utf-8?B?QndzblJoazJDK3YzL1lsMEtqMm15Y1pwSllrTHRGRUtWamJSRDZ0R0VUNWpx?=
 =?utf-8?B?b2RXVFN1MGs3VlR5L0VEQUNQNVJHUUoyOEFMQktuN0RNbzlZcTF6YXhFaUll?=
 =?utf-8?B?L1dnWVk1Z0tSYnVnN3RON2NnVjlMdjlHa2VhZlhwSEVVZXZob2JFQUZVd3Bt?=
 =?utf-8?B?dGptMkdsNDhUeW1oNnh1ZlRoZW5HYkxWTGptbmFjSnpVRldOeHRUNUgzMXBD?=
 =?utf-8?B?SkFJMUFjUEltVXNReFVxN05IQVNmVUkycDgyelFrTGRIVmxLZnV4QzdaSDRq?=
 =?utf-8?B?dUJ3MlNxVCtrSEo1Z2NxYWJBaW91SnBCcXNUcURKUGFBL0dOazNudm9ZWWdn?=
 =?utf-8?B?RXAzdHNxUkpXNDc4SkV5QXBtNmpjbmlzYUFGaGNJK3ZScXY0a1UyUjRWUTRr?=
 =?utf-8?B?WVRMTllNVTdIVlQzMlJibmsvc3IwTXMzdW9iL0ZxZDBmakZqbUwzaG00ODFJ?=
 =?utf-8?B?S1gwSEdTb0ZnWnZueHIxR0UyUzNZeGxZRzFmbjNzN2RHbmRJKzhjSERyME5m?=
 =?utf-8?B?TE5NM0E0N3VaMHBXd09GeFNhT2NlL0hRNmFMOEJuYTQySFJqcFdvM1V6QWVx?=
 =?utf-8?B?cHZvQUo5d1VDOC82aFpta2FKdGVId2gwVFN4UWVXdk92UlBoMW03V3FpeHF6?=
 =?utf-8?B?ejNXNGVkZDJRWFFyVVdDcnVhVXlzOTYySWV0OXpBbC85eEpnSWFwcnA4QzJG?=
 =?utf-8?B?UXFHNktKcHFiV2QwMkMwVVlyVDJ1eUdBempvR2g5L1RLU2FjSDFjM0trdjF3?=
 =?utf-8?B?SFFOc1dJZ2hlZzZteDM3Y1U0ZXBid0YvR0ZPL0ZucDFsQzZ2NW5jNTZNRVdl?=
 =?utf-8?B?bzZXVm1RZEhwajFCNmdMeGxwWk9RM2U0U0FaWUY4QmduQ05ZUWVxYlpFSTE2?=
 =?utf-8?B?TlR1d0FlcXVtQTBRRzBTRDFwVlhFeFNHcEVjejh0aE1PTTNqU2ZBbGk4V243?=
 =?utf-8?B?MldXWXY0UHQ2cVBvSG14RE82VVNaT3NXUnA3SFQ1MnU0NkwxZ3pUWE1ka0l3?=
 =?utf-8?B?dWd0U08yUUd2Y2xEaXI3QjBsTzdqZVNlL0M2V1ZEM1d5SGt0ckNvM1ZPY2k4?=
 =?utf-8?B?eTZFWXZJQ3FjTmlTZSsxZVFrWFdzYy9mUmh1VWJjekJWSU5xNFVmM3ZMcW02?=
 =?utf-8?B?ajU5NFpvRXFNd3ZNM2QwaWkxK3NDem1Dd1FGRlJ4ME1TUnd5d2xZYjkzYXhm?=
 =?utf-8?B?NU40eEthQTlIbEtLS05yWFZ6WUpRaW90WUdxZm5kWXZ2czF5YnVCdDgwNmYv?=
 =?utf-8?B?MVN2ZHNkcCszMm0rTFZLZS9zL1pFR25tQ3hPWnhTUGdYS1hMYjdRemtFZ1RI?=
 =?utf-8?B?RUo0aUpTalpMOHhPODdZNjE2ZHBFbHFvS3JUZjBxajB5SitZQ2JLQWViTWky?=
 =?utf-8?B?ZDFNdTBBVmhGOEJGejFVMkgvVDZuYXBDRFZVY0dGZVM4aHdNUmRwZXNEMzhS?=
 =?utf-8?B?cGFxWGtVc3YvbUdJT2RvYjhsRzZXVkdxcXZncWIwdFVjVkYwRGhPQnlWKzl5?=
 =?utf-8?B?YzluVHRyayswZ0ducThrNmtuMzhNeEVJbkVsb2lCTGt1YXVQdzhqeEZtV0pC?=
 =?utf-8?B?cWZQalo0L1VoTzdsRGhIUHo2NHdUZFJOT1Y3MVdOUVlOcHFlVVFNci81NEUr?=
 =?utf-8?B?eFdqSjZHNDRyaW16UWxrT2xOT0VRNU9ZaXgwRi9NUmQ4ZVpZQ25ZaUFpb2J6?=
 =?utf-8?B?UzJ2cmFqUGt0Slhka0VXUkNTdHQ2MCs2VzZqcmxrTkhEbEtqNVhyYTI0TE5n?=
 =?utf-8?B?OW4yRkVlWmY5dHpqMGQxUWFZeEt0UUI4eVB0QmZXVCtpcGkvUWd4bzIxakdl?=
 =?utf-8?B?YWdJTk9LTVN3alZDdXpGL0poVWhBZ3ZFRWZySDdkeHp3dlgxNnBOT2EzRFB4?=
 =?utf-8?B?SUE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e01366-8f98-48b7-461e-08daef397f45
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 16:25:45.5172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9i9uk/wyU/A+HflyP4neG9T2jgwLcbR1NMcu9mrR5HNh5JgyUV7BefAzL+o9BKb0NJdwwHXtkQrsgkuVrYTqqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8434
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 08:39, Vladimir Oltean wrote:
> Hi Sean,
> 
> On Tue, Jan 03, 2023 at 05:05:07PM -0500, Sean Anderson wrote:
>> This attempts to address the problems first reported in [1]. Tim has an
>> Aquantia phy where the firmware is set up to use "5G XFI" (underclocked
>> 10GBASE-R) when rate adapting lower speeds. This results in us
>> advertising that we support lower speeds and then failing to bring the
>> link up. To avoid this, determine whether to enable rate adaptation
>> based on what's programmed by the firmware. This is "the worst choice"
>> [2], but we can't really do better until we have more insight into
>> what the firmware is doing. At the very least, we can prevent bad
>> firmware from causing us to advertise the wrong modes.
> 
> After this patch set, is there any reason why phydev->rate_matching
> still exists and must be populated by the PHY driver?

It's necessary for phylink_link_up to know what speed to use for the MAC.

--Sean
