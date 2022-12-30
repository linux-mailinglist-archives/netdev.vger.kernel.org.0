Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B9F6599AC
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 16:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiL3PYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 10:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiL3PYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 10:24:02 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6FE186CF;
        Fri, 30 Dec 2022 07:24:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjLnpFAGPWBx4zY9vCOWiSxzuvVho/u+QohiG6/3jRY49LrxJ3F+IOYfqCQbQuBPJuc/j/12CCCBijrvMckRRDBt8AtlCs3Lqs5Pc52J7zWeOeYewnqHI8O/njdcDbRK3obU9YLbDGii5RkMDcOZmxnCRe0x96McVFQxNOuPZvIlam3kGI22zddpy8ESuVijsEN5GFHmrXevwxV0eTgN+bejR8e8p01poz9XfCx5LS2m76yf00brUpujIIFywnQd3e0w5e6QNYESfCAq5KBDVtwxMGYA3jwYKvut6/CHw9osgCfVwiKcTxeCL5ZVIrBNJ5Jh5LhBbG+4NFDgO8uZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wx1vP5Qx0RhONjemvtZqCmT5dLJEurDw2iO6qtj8OnU=;
 b=ifhs8JRDpnKv9gynUU8xeJR2rk83E/cZhl1vHBY5G4NcxrOF1YJCUn273KYK0LI+SOcS5FZyn6U85SxSlcoAwmpKi1oRotkVTPAEhvawzF2s1pFA7z9Ji2K8xO9aMjoB56UZvCpKfXrCXVCtBn2UPLXUFiRpnmSge+lMl3hTCyoG9niRF/8RY2Bf9O2BszAnurluqHnAIyu6YVgFIjxdIAJJwR8al6fAeiMdWCe93gnPjUDV+uJM1mf8MiKpkZ87/YvLkG933y8RQgqUFU57xRBCxiaOn/2i2LKz4vtIJX3kTL/d1TmhK//Ybs8dvPG8gD3RjrOVd53Bo7VcoWOQbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx1vP5Qx0RhONjemvtZqCmT5dLJEurDw2iO6qtj8OnU=;
 b=qFhw9Si1Rd2e1t7j55KDdW7IuF5g1450asE6qp2h9D0Ht9lTN10QRc0wGpzLOFrzQAftBXO3X0iUY25yr5TkOFTJfl8XcJmypnd0O0aXS2nSkgh0BVnuybBtzTQW/weeWu2trzMnc7O/0nOOXv61cVPUh3p/YRJIk93p2bnr8TjjZfq+JCgVceCOeqNWZ+7e7g+cR+HqrDmNaTerfi9AmTJkIgAe2uiQDyJpBgOhCEV4zYgK+skARtvBD3+qLHykM0GARvWvwuE+/wm1Ln60EaDFDrGqmIhW/GwfjuQ3BDLyfddAn2Ux0I01OzedVwarUS0TqINX/nFJYWG3DTxdbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by GVXPR03MB8308.eurprd03.prod.outlook.com (2603:10a6:150:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Fri, 30 Dec
 2022 15:23:56 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.016; Fri, 30 Dec 2022
 15:23:56 +0000
Message-ID: <cf215c60-8019-924f-c4d2-4204bb6a87f3@seco.com>
Date:   Fri, 30 Dec 2022 10:23:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] net: dpaa2-mac: Get serdes only for backplane links
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221227230918.2440351-1-sean.anderson@seco.com>
 <20221229200925.35443196@kernel.org>
Content-Language: en-US
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221229200925.35443196@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:a03:331::21) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|GVXPR03MB8308:EE_
X-MS-Office365-Filtering-Correlation-Id: ed133c9b-446b-4234-7bb7-08daea79de0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VXaRcuh6KVomHOEchMDQj2zQrpAk55jLOPg9icHoi+AdWcXPsJTgIJdJAEGPhorlw2LSiFnm20mpmc5KZdceu7xGFojXnd3XFOZBITRK88jYDKvwMx8pvSyPAS+2ofqNXvyAVEUBjhOHFgbe/UzWcB7zhlUTop4Kul6Rss+JKQoTbJ+VZEttGwg24rFcTAcNM/u1sgjgLaIG3ntem0iVz1o1aiqgW2rkHTUBlbRFDcBvt4cBsDqTHqmQCue+0gtPoMIKWpvULHeNWnCj5LoVmuH9fttMwYqd1V3lRLk8sF9hITvhLEuuLH+5DjrJwSS+IRoBN/fuOTfwM9HH8N/DfFNQ2H0D66p0Oxn0M2eHpuvDGP3XAeOUWRwACOsNtBuyFr+H5Xcs3DZtPqCovDIjbb8XLwfRxeww77pthqjhmho0kyWX8b7byPGG7HsB7pBW716nvjmwmyxQ+jLxzPOCkmmRNcLxyq4rcBt2eZnjMkpZOfrgYJd9PaeL9LqXd5E0DogR0leGQJVjpIm0hrN3SUgPFYLVhE9mwYq9y/l+b3PdUw31ORZXM6iRc0HCjHQFD1q/pXgF37LZoa5fLOSZ8csG3AoN6KKd+SB41zXdO3Eww/rO0ICKzY80zpx5GZZszGghxBSAbkyA4gzF9/UWY2ePf9Fj53WMZFeZfw55XKaUN1hb74zOKdOui5MCliPVpMoJfGHxSL50J1aKI46ph6O1N9GWSZ60jW2OQy5nJdo1tm88F0kU9P6s+/HON4yaQK6T9APV7WyKQ7TxCrfUaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(136003)(366004)(376002)(396003)(346002)(451199015)(53546011)(6506007)(2616005)(26005)(186003)(6512007)(6486002)(478600001)(558084003)(52116002)(86362001)(31696002)(2906002)(6666004)(6916009)(316002)(54906003)(31686004)(44832011)(36756003)(41300700001)(38350700002)(38100700002)(66556008)(66946007)(5660300002)(66476007)(8676002)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3RZVHZuNFJOdzhPNU9FODE3bWd6YWg1eXRHdGJvRGN0RGNJbm4vWHZ0Mjhh?=
 =?utf-8?B?OEMzYWRKMlBCbU0weWFqSTY1bXVjRDYzSHVTMHA3WS9MdDV0Y3c0ejV0MlpJ?=
 =?utf-8?B?N2NyQlBXdmdRZWwwb3ErVjJGWWwvUUVONGkzUExhOTE0Vjk1ZWsxMHFObFhX?=
 =?utf-8?B?UjV6bDZaNWVOK2hDQXpINUQrYlRVNmZMelZnWGZYZ3ZDSnNBdFp2clNBMjZu?=
 =?utf-8?B?bTMvbnRKZ25Qd012ck1QNGxLQTJBenlaOVAvUnF6ZnVwNkc2QXFwQk9pQi90?=
 =?utf-8?B?dWNBWWhmNk42OFozalM5Wk1WOVBZUTRJdzhMWUw1ZFA3cHkraER4N2lWZnFO?=
 =?utf-8?B?bWhsOEt1R2VDREVERkpEdXhIcHBUbk9NRy9oekxJK2NMbFdKVTlIb3o1NG9h?=
 =?utf-8?B?by9NTU9LWTVvTGt2MzRkVjYwRXdqTjdSYmljNTNXbXpFMmhDL0d2SUpPNW83?=
 =?utf-8?B?VUtZaGhGbGQ4SS9wYXFYKzBlZUtpbEhyWkV6cWlKTzJyU25XdC9vQ090dGhL?=
 =?utf-8?B?N0VuRXZyMng1eGFXbTNPaGJSM2dobUh2VHhxelJiSGd6L1dQNmd4M01leXVZ?=
 =?utf-8?B?TXRwdGU5MzlnMXZJYnVWSWhZSXFZQUdwUWp4VVFZMGhxMmRORG5HblFKZVlH?=
 =?utf-8?B?bU5DaHV5MmZ3c2tFZDNuUUt1SG5HMU5IN2RyM2hQTEhUcnczbmZwSkYzT0FT?=
 =?utf-8?B?MU0yVWgveGhVZ21PUEFtRm9ISmxyb29hdWlWTTdsSEVVNkwwb0xqN2I0UWgw?=
 =?utf-8?B?SStmeW5pS0RmSEpYSklZalFzbFBObXZGamtZT1R1SDVTWWY1dklibE9rZEEz?=
 =?utf-8?B?QUZlc0NucnJrY3ZBblRXM0lRUnNic3dIR2pqU2lnSi9lOUVPZDU0SVczUjVY?=
 =?utf-8?B?ZERMQWdlMGd4LzJCS21aSjUvNzZqNzNyYk8yTVk0TVBUOG1sTHJCekdzZ0NG?=
 =?utf-8?B?THRaL2VNaWpybVVXTXNlbUljZlUzQkRUMy9abTVRcDBDOGQrYUxLckduMWdM?=
 =?utf-8?B?VGFyNm81T2M1eDdTQk81S3BxTXNOUTR1ZEk2cU9XZlo5bDgyTklkN2JXaFpI?=
 =?utf-8?B?cmpPeEI0MC9VczBsSEdWSG54ZVRib1NhWUM0aldHSzN3K09vcHN6b1pVWFcz?=
 =?utf-8?B?VTNlelE2YnVPUUEwd3FRK1NoM08ydmlnWjhITWVGWnBqR2wvd2RtRDdmRTRU?=
 =?utf-8?B?MUJpdVJYVWdVSTFsczNubVhKYWg2NmRmOEgxaUVFYTI1VFpJeXZNL0JDZkc4?=
 =?utf-8?B?TGEzZTlQY2s1K3hYMU5LQzJOaUN5MzJFZ3Qzay9QUk0vczlpZlZXTEoyRmZK?=
 =?utf-8?B?NTVIc2FVODk5UkNoN3oxNkpkOUlWK1FkYXIyRXRGUndsU2NyUUJWcVY1bmxO?=
 =?utf-8?B?SWhWbkJWZXFsNmVxMUk0cGl3UWNVR1BKWEwyS0hPNTlBc1Y4R1RucjdSYmZR?=
 =?utf-8?B?WjR0enFqRFlsNlV5N2FPT3g5dWR4UTNnSE5WZEY2Q1ZCREg0UE5nSFI3R3gy?=
 =?utf-8?B?VXlIQi8rbHd4Rm5meWY1cnZWaC9RdzN3eXM0ZzNaM05sUWpMUXYyMFUzNE8r?=
 =?utf-8?B?d1FELzU0T1I1ZUVleDBSZzJUOVNiZGV3eG5wVFF1dktINHNvenB0SVBGTk9V?=
 =?utf-8?B?L3hmNTRmSXBjVVcyeGFtUWQyNzltS1RMV3ROR1VkL0FvQlNadnFDaU90ZklJ?=
 =?utf-8?B?eGRlRkFSMEZ2ZXpobFVJSEMvZ1N3ckdNS3BEanZJNldFSFZLRURCSXZOWjVR?=
 =?utf-8?B?YWJZRGFrbWZqcVhBYmhPRjl4NHAvaCsxakxJWmVpcXdNazVDQmpXeWxVcmQ3?=
 =?utf-8?B?U0xzSGl6T1RWTmJUMUxZSzQ1MVR1WUJXUkRUbDAvUER6VGpyN2t5UXYwNmVl?=
 =?utf-8?B?WHpqeFhJVUNIUDlIaCtqR2YrL0IrQldzenFYLzdmTHBWM2hvRWhOS3BGRmh5?=
 =?utf-8?B?WkhORVFsTjMxVDBneFE2d0lLMmdLM3NOeEUzVjVZUWRzUDBWeW45RWV5eFVK?=
 =?utf-8?B?QjlQTGFTY0RUNElyUWR4anlEZnZBb2JjMXYvTnNQdW1KNkx0TG1qODdzdStl?=
 =?utf-8?B?aE1FZ2NTWWNUUkRHZUtUOUs2RDVLTmoySWt2OXF4TVhKSVFiVE4rcmZ3bzN4?=
 =?utf-8?B?TjhRWmVyelMwRmx0Yjlwc3pjbHZvS3VEcnlEa1dieUVJWmlQS1gyTVJaRjA3?=
 =?utf-8?B?Znc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed133c9b-446b-4234-7bb7-08daea79de0c
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 15:23:56.6148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcdWnl1EgNU7cgOWArWiXQwYZLzRYc6g1TUDNcHFzLpDhanqUlsvHmEs1KsZK5mH8CNVoKWiE0yOHEIZsNjftA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR03MB8308
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/29/22 23:09, Jakub Kicinski wrote:
> On Tue, 27 Dec 2022 18:09:18 -0500 Sean Anderson wrote:
>> +	if (!(mac->features & !DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
> 
> This line is odd as sparse points out

Ah, you're right.

--Sean
