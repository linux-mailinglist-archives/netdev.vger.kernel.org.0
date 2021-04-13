Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEC35E0DA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345149AbhDMODM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:03:12 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:57307
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345086AbhDMOCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:02:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2wKS3qNKZAXAxK/+Gy0rSfHIxpX/0xkbcaV6atSRYSmFPj5omeT+WH4bWuBzkLRLFjp6aUhQWyAGPfuaOWrNuuTbQQHC7eu2L/Ubj2AKCBYy8PbHfRWswllA6O6ET7h0VfeH6ZrrRbeq/qu4R2k2WELp0Vh9kvfVxTw5vX6fUbvZVFk/B/jDvsLZVcuCucBvw4FpbgPEvsmfubgQaT8P1E41oE5HLgdM+mhrnZxlW58unLMJlnBzqivq8r9rVY+ozrfZbM5nXiiSUaL/0FGGvBQKIhUMTJAKtAWlRBz5hV9jxAYR0T/t1614Cqlqi0hutYQn7Z8bjO12s4uKqwBaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IL70YRJFUvhAU3Ulrz5GnMS7EIFLbBnnYHO+cbkyOwk=;
 b=MsY4FcKBFVqjt3+LDBN/UliI6dPIy4dAATdLSBWF4vSP2iE4ht5htsyUUmaL4hoccXZJEocm0seLh7xrjN/laD2fCziZgHpU1cee7iJOKPyDdCuP+QwE+Bxg8bGjPLoMi5xGmdwqP8DgmxYYKmcN3/uDnb/7A2luNGVUnKSfDotV8BtIvi0Jqm2XuoZOCjgNi7rjqXCOlioMymWjolHsQUVHk6sDo+NQi7sM5hk1+gg72B4stnZc0jJEtfZWPoorhWh+RsFvEVgvnmnK4zycEj+OytIvMxvy49oGZBtPBgSsI8xgFmU/8fyVA224/lAUDDPdQquc573bpfjOEJBtOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IL70YRJFUvhAU3Ulrz5GnMS7EIFLbBnnYHO+cbkyOwk=;
 b=RMNzTMA/30iQbIiyrzu1fTz//6iUoqfI8P0g+ItUnTd0btYxnri4hale68NgQN2ZbIoDNQR+WsAZfXwLQoa3yqbS++/+GaKdH/Q9DeVR1ug9o1X8PeFBIZzwsVdcPvecdlKR/LkmdFZU4HBGhvooMnzyp8fKWpYUrwypyWjTUqo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB4884.eurprd04.prod.outlook.com (2603:10a6:208:d0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 14:02:29 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::3419:69b2:b9a3:cb69]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::3419:69b2:b9a3:cb69%9]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 14:02:29 +0000
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Radu-nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
 <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
 <YHRX7x0Nm9Kb0Kai@lunn.ch>
 <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
 <YHR6sXvW959zY22K@lunn.ch> <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
 <YHWc/afcY3OXyhAo@lunn.ch> <b4f05b61-34f5-e6bf-4373-fa907fc7da4d@oss.nxp.com>
 <YHWjU2LEXTqEYCmZ@lunn.ch>
From:   Christian Herber <christian.herber@oss.nxp.com>
Message-ID: <d8910e5f-bdbb-f127-2acb-a6277c53b568@oss.nxp.com>
Date:   Tue, 13 Apr 2021 16:02:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <YHWjU2LEXTqEYCmZ@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [217.111.68.82]
X-ClientProxiedBy: AM4PR0202CA0003.eurprd02.prod.outlook.com
 (2603:10a6:200:89::13) To AM0PR04MB7041.eurprd04.prod.outlook.com
 (2603:10a6:208:19a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [165.114.161.25] (217.111.68.82) by AM4PR0202CA0003.eurprd02.prod.outlook.com (2603:10a6:200:89::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 14:02:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08575edb-1261-453f-51f5-08d8fe84c674
X-MS-TrafficTypeDiagnostic: AM0PR04MB4884:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4884617B7D0436CAEA85DE96C74F9@AM0PR04MB4884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sl5kmWbLPSjNknkgaZnwLwOjLqjdKjmO1B8LOMwaNkZTTogdGC5QFp+/sLOzlS6aqMGeFj5L0XFSDHsebc1981E5oddObbiLkUNzdVqNsPBFUYdoedwjyFnz9LS7taYLLKBcaCRLM6y+vSuihUtVwPH3RgR3pCHcyg3cA2L/xRqZKVR2K3EBkX+qvlGAU9lUw6unZdr0JGt2WOm1z/rwlAGzICDnDHfSc2qYKmgzAC8fRLe7QQsR7ryNPVqHM8ON3SqW6qkjy3Uow2Vc+tmcBQ5kM+F8jYdxKxiWnmz0mMsPnKuUU1X5tpn0lKeG0gq0wlqMUfzQbtYSkdZClRAvlOQaM2sYulFQLQ3ad3sUYMHXyrr96RijrI1voRWgTTBhRowuMUYcwrns3klU1Ax9yTGk+0iabO7ECOornNRzDRyEqne6ph2lXWxkUiSRv8FYDNHsWkadvh5GSmb42TcN2+NYfofXfmDpNTTX8spITnYQ6MgKpYq+qryzAuO8t/fjfgWc4biIH0ESuWAMtxCFBCD08xNXR8huwGXMzTA/HZ9p/lYmQSLVdPzuZf2OoFnkh4Tc2dQFgZ7XpKzNGMWRoyDEQxlJQOzAyBLSGQrtEdinXWypnZSJ75uPOqr9aJwbghO//TKr1EyAoYThm91xtfeQs9mWGjUB6TSSXrZLgIWwYJ1ForMC70dzCAhUUrQX+hwzp0mbfROAw7Q9Wm9NdIwAICDOTrGIZ7DEiNUy3FFZAdwt/I8FS+sv8/A/4nf7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(6706004)(6916009)(38350700002)(2906002)(66476007)(8936002)(186003)(498600001)(86362001)(26005)(66556008)(8676002)(4326008)(31686004)(53546011)(54906003)(55236004)(956004)(83380400001)(44832011)(6486002)(52116002)(2616005)(5660300002)(38100700002)(66946007)(16526019)(31696002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OWhOY3BKWllVNDhQNmRCTFVGWCtwa1VoM3RRZXMwSU5SVVBmbTNzQjdidUVB?=
 =?utf-8?B?ZGxTSGhKeXRKYXpWVXlpKzVwbTJaMEN1N2RrVGF6NnhXZUxRczRoYktBZmhq?=
 =?utf-8?B?bHo0dFoxSmhSNloxaWk2ZTBXd3NCNTVTQkZyQkYyVWJqM2V3Q0sycnZ2bDk4?=
 =?utf-8?B?V0dFOWJRc2x4SUFobUprVnQxdEUyYnIzdTVENUZXUUVTaW5nMC9VWFplbFM3?=
 =?utf-8?B?Z2NYN1N5b0dNY21YeVI1eEVRbXB0M1duQk1mMDFlVVFPTG1oOTB1UExHdmIx?=
 =?utf-8?B?WGdiZW4xaEVmN0ZSZ3VTQklkTWVhNitKS2tHaTdqSmgyM0NrMzNiR3lRYmZx?=
 =?utf-8?B?VHFIU1dndCtTbmFhMURHM2Q4OTA3ZC9hRnNHTVFCR3VGTWFRdjhIS1VMTE5G?=
 =?utf-8?B?U0hhMVdlWTNOSHBUM2xWd2diMzFESzdZR2xxWmZBYklwb0hKdGRpeForM2xo?=
 =?utf-8?B?Tlh4WmVRL0FUa2lES0hvVXdGMlZVaE9GeFZZR0tCTjlhdmQ4VlZTdGZXWTNo?=
 =?utf-8?B?N3JNOE9OSmdzVkZlNmMrWTR3SXh2b1V2b0tQVm1vTjZGQlcrNk1YSmpEMXFp?=
 =?utf-8?B?T1NwdHRYU2UwTzZ0SUFsK040RmVJMENvYVB5Y3FORUV4QjBpRkxNakYyRTc4?=
 =?utf-8?B?UFVjNElpaSt6bHNLK0JlQ1lyVDB5UWE1L0tNOURsLzFsWm9raDdHTHJkUks0?=
 =?utf-8?B?T25uaDgzSTFkaEJkbDFocmI3aVhidDZrRDBNalBuYjJNSE8zdjVUTVZybndu?=
 =?utf-8?B?ZGdpUERnWHpMcFRHNzU0VGVNSGs4MDJGb0xIYUN4a0c2TGRubTB0cTVFMFk1?=
 =?utf-8?B?UlhHbHFzVkR3RWpkcW1za281Rmg3Z0l4WjNKQzI1a09rTFBPaE54SExqQStt?=
 =?utf-8?B?ajNIMFcwdll5VnRyWm56emQvYStIdkcwNjdmVlhtaW9QdFpwZjF0TVM0OVYw?=
 =?utf-8?B?d045YW5LUXJZNmNCWmtQWUliVlF6cnFYL3kwTHlBSG84SVhNaERGVVlRcmpG?=
 =?utf-8?B?QmFiMEVSMDByZHpUelZianA0MS9hcko0ZDBDaFZDODlNVVlFRGFiRHIxQ3pM?=
 =?utf-8?B?M2M0VlVQOHd5c1hmek4yZlU5akJqalZhMGpRSHJvaGVzamNnZGVob1BxT3M0?=
 =?utf-8?B?VHRIWGVZME5kam1MK05HS2p3dXcrbmxSQlhuUVJ6S2xCM1RrT1dBVUYrQ2tl?=
 =?utf-8?B?Z3BUVmdxekRWaUY2UXZobFptRXM5dHNyUWdkQlE2QkZFZlExQXpkakZVT0Ir?=
 =?utf-8?B?bmozS3B6emZHUEFEQlJvOW9seXJyQmdJelEzSEl4RElGd21XZXArNHowRkw5?=
 =?utf-8?B?aGRvVDBFMUdDeFpjNU1jNWR3d2tRZVVWZnZYdEltWmJodk1EVkozT2prUlQz?=
 =?utf-8?B?UGcvOVZUWGhsVFp2bk5sUk43M1RDVVY2ZmNaWCtadlBEZ1FtNFFBQ0F6ck1t?=
 =?utf-8?B?SnUycDNKMithRjM5S0JwdkdCbEo5emV3WFRQNlNhcDJrV3hZWUFnZWVlVXhn?=
 =?utf-8?B?UEl2SFZhSkFZQlhZMm04TnlsclVndUlxYkk3SFFhV2FlYTF5RzRmZkg3T0Rk?=
 =?utf-8?B?UWJFUFlIRjlWM1cxWGRBWHA5d0IzYjI4M2tHaC9ZV1U3cTMzNWRCaWdFUGZz?=
 =?utf-8?B?NG1kakErVkErbHJZejRaalZRek44V1Q5ck5Dc1FvVCtqVjFBeVFmOVdRZzZp?=
 =?utf-8?B?T1ZOMWdCSWN2UWVIcFNSNlZSWC9Oa3o0Szhtd3BrN0U1VTA2cjVSb2ZyV1Ni?=
 =?utf-8?Q?027YBJONWwRuF3+Onn7OsSf2RHRFrrWhYHqi2lO?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08575edb-1261-453f-51f5-08d8fe84c674
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB7041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 14:02:29.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hH87x2FgUVuhlCLXERI+PNZKmdh4Mok+b6N4KMPARr+x+CeYk0OSkKvP0rAlN582t3SOWm41xBeNX15MFXAuQq2sdlFuw4i9hi7a+j8LjzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/2021 3:57 PM, Andrew Lunn wrote:
>> Ok, we can agree that there will not be a perfect naming. Would it be a
>> possibility to rename the existing TJA11xx driver to TJA1100-1-2 or is that
>> unwanted?
> 
> It is generally a bad idea. It makes back porting fixing harder if the
> file changes name.
> 
>> If nxp-c45.c is to generic (I take from your comments that' your
>> conclusion), we could at least lean towards nxp-c45-bt1.c? Unfortunately,
>> the product naming schemes are not sufficiently methodical to have a a good
>> driver name based on product names.
> 
> And what does bt1 stand for?
> 
> How about nxp-c45-tja11xx.c. It is not ideal, but it does at least
> give an indication of what devices it does cover, even if there is a
> big overlap with nxp-tja11xx.c, in terms of pattern matching. And if
> you do decide to have a major change of registers, your can call the
> device tja1201 and have a new driver nxp-c45-tja12xx.
> 
>         Andrew
> 

bt1 standing for BASE-T1.

As you can see from the current situation, it could well happen that a 
future PHY is SW incompatible (right now I would say it is unlikely, but 
ok), and the device is still a TJA11xx.

nxp-c45-tja11xx is acceptable from my point of view.
