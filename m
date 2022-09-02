Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A85C5ABA57
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiIBVvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIBVvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:51:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C40F242A;
        Fri,  2 Sep 2022 14:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eq0/27lCLBQKAFxOc23qu5ioVQmLIWHV9yGnI9zg/0KIUoZScXPbUoLtb0OlvcUpecmklAjP7uE3M7KBaoQRpmrEMMXmJj28LykJcPB/8kIxqEsyA0gp5+fh4c4F6J7ZWpz3yZMSzEEvBI2rF/DZ1/PxvfRqcHjiza5fdL8xW2cX7+9hqMOINAEVG32/NFXoTJDabWjxD9rJkC0ECuYJbIXBMuJvvhBQoPrZqgi9x0UX9Htkn7PJslD8WyLbM/xPjf+EQYo0hFQ2SfJSbA32o4MQH0ydrKmvMThRuaSSffsEEnnw2be8JoyE9HmzZpNdY+xYtEn6/Nsynzr+CvKjbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAJWZat29GwSRisB+GW3XOFei2UCWep28PxWIC8RSKU=;
 b=aprneHABG+sEm7FmOsynAF7AuzounGUnPIuG8em/WIUHIe/yPQvxNHiIBU8p/PmISRjEGvDdYkdcCBATNWkNdS7pxONEsB/gZn/gXMDwsHVgS5pFmcxIskMf82iVpBgY1CIpZKB15+5lz04DuVi/d+djeYUb8LIJpWYEvRzK5ydniH5TSC0AXPwuX6lg+fEwteBgXTgsRBpuCmYgPkJ01xm6rYdAMDFzIx4w4StQRCBjE1DNjQK7TQSXCt2QYjZkY2SV7GIf4FKsJe3tI1OkDNwqpvKr6aTwt14ZgJaATn5zQl0BbL34OTXJDFukKrvd3Pl99BqKa2CxNAOKaIPTyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAJWZat29GwSRisB+GW3XOFei2UCWep28PxWIC8RSKU=;
 b=WGPrhOx+5Q9yv66cJcCAMhFU6I5Rwqw1PxUH0aS9N7ZZnte+4HyVePxqj1UEalz2IeDor7zqDicPaJ13Xv9bzxuH8nZKMv4zol4c6XVY5xGvEbGwLLMzFPEacpmvThIKJET97bMk4Sa+FOXIHeOBY3ep4xiXTNrDvwy5sTfyZFc3lSlniP2sTsVZxgA+ZUk435IaRQNS4z1wif0D1zuRw1bSFklSeXWrgJv6LPUw0X5ase52KHQWOyr1N6fG6sNUWExqgWGa0HQzHmVcmCB//8K7AOsH/0mu7n+JN+D4q8repc2ltqMed8unnGccESRuPVFmLe5LPDqw1Ihgp1sA/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VE1PR03MB6352.eurprd03.prod.outlook.com (2603:10a6:803:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Fri, 2 Sep
 2022 21:51:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:51:08 +0000
Subject: Re: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in
 preparation for phylink conversion
From:   Sean Anderson <sean.anderson@seco.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
 <20220818112054.29cd77fb@kernel.org>
 <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
 <20220818115815.72809e33@kernel.org>
 <583c7997-fb01-63ad-775e-b6a8a8e93566@seco.com>
 <20220818122803.21f7294d@kernel.org>
 <db48eae9-e61c-cf8d-e652-56545193e51e@seco.com>
Message-ID: <d4459e45-2cf1-92f5-2de0-52e70882c883@seco.com>
Date:   Fri, 2 Sep 2022 17:51:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <db48eae9-e61c-cf8d-e652-56545193e51e@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0385.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dd7bb35-6a43-4cdb-dd59-08da8d2d3e11
X-MS-TrafficTypeDiagnostic: VE1PR03MB6352:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d86HQbYU4E7oZHvkccLOJ7CFKsQAcvh+ZExZh13iCbxWQ8pMUSed1a+mIg2BmjsxxL9exEoghx66gOOU56Ni5lLRUK3LPr2S2WY3hGr1mWvUj1E2z5eFzMI8KKzolAiBimhDFbJDlum2Utb8aXNBGhVXkqlm9KN21R9OXpee4IcCpb0O3M9bQYBndZ1De82MuH9W26FdLRhNVHcsw8TRUcdEKRxsEAfaT3g5sqJTmP0kAce7gAyatBE3Bmsm4Tpp7hUub2j3de6PH4mPm0YIF06T2iPUVAD3/mp2C/QLbzV6sZzhZmPMfBXBPz8IddgOlExykr4+d2T5Sl+LagDLHkwirYa3I6M9zDJ2zWIzMSL0nbmXhVku+6bq32dnUs+dfR/F2jQ+ftGLJweh5nn4c7tYwL/UzpuVSVRMx9WRj7QGeWjbWwZrd6SLiPyUq2tJmc+C4/YhUjdBZacbjuiRHdlkOSGwM1t5tO3sDnd0dvQIztM86DKzDM8CFgX7RXDTE0iuIsDE6fDFxobqrhY2VvvwjqfvFwdLjhvRnIPEFfwwqYCvDz/gvDrTKjdtDFMLWjxLGT85bASnjuO+t4hQEnCrUH/QjLkjZB8K4x5txWtzz0We9862FYf4NK2Oq6w/Tr42xo286Ty5RAptbt+ij8DYLL1lgSHPCtIb0VaVBJdi2MNYw/f20quUfRta37sc6vXR7wPT0kjksxhfAEIjheDBl94XE2HRAVTKFCx17LPCpEBq/4StBquM6rMOLTriS8jo2Yh9V2WIVViZSp8MVBhc4OpbtW4h0EykBIC6gNQ4L3VRFG1jioTDMLvaj7jPtJd9t+0n8tUocX4FMlwLyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39840400004)(366004)(396003)(376002)(346002)(38350700002)(478600001)(2616005)(186003)(6486002)(36756003)(44832011)(38100700002)(5660300002)(7416002)(2906002)(31686004)(8936002)(6512007)(66556008)(31696002)(54906003)(316002)(86362001)(66946007)(66476007)(4326008)(8676002)(6666004)(26005)(6916009)(6506007)(53546011)(41300700001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTlieVdCNVRzckkzZngzcGlFMDU5NWYxeFpBekZzRzMwYXRxSEZhRWZGaEpw?=
 =?utf-8?B?NXhkK1FQMGg0WGMrOU81RGI3aWlCSUhsYytYS09sQzBTLzZ0MXZwZ1ByclNv?=
 =?utf-8?B?TWd1aHFFU3hicjhicERZenhwWW9kTDJGVjhTQVZQWGl4RnNEbktRcVM1anA3?=
 =?utf-8?B?MjhQeERGVVJKZXc0d3kvdWZPaTcyVlcvZ2ZkSEptMEJ5bXEvQ213UzFZWFUz?=
 =?utf-8?B?VHVQQzJHMnQzbG5HbW5VbXRwamhXZEFDbnEzWTVPaGY5bkR2cnZOKzZ3ZEZH?=
 =?utf-8?B?V3dsT2I2d3VIOEVyK2hQZytMWU1aaTk5QjVhaXhZYWI4ZHRNajF2QW8ybUxL?=
 =?utf-8?B?MXZKUUpzVC81WEVGbVhaWVRxVnU5VDNTQTBTcjZRdTRYK2djQ2laNXdQc00x?=
 =?utf-8?B?UmNJaVJuK1JCai8vbkl1NjJtZ29SWkpWMHdubExwMmJaVHJvNmVDaXBWWXRY?=
 =?utf-8?B?SHFnMHo4d2FIR1duN0x5Z245VE9NK1ZiQXJvemxaK1lYVVRsM3RXK2VIaXZS?=
 =?utf-8?B?NCtUd25BRFFjM1hOWWV5cU1IeStJNkVOc3J5NEtjRmVyRzFlbmpUQUpBK2VP?=
 =?utf-8?B?SnRwMGZVZ3M1ZzZVWldxZDR0S1I1WmM2N2Z5aGJJYUtGdlBZTi8rMTBhc2ht?=
 =?utf-8?B?ZWROUzRFT29ha2pqaEJ3Q1ZBKzA0eDB5cFlEZ3RqQ1FLbHJTdkhtK1EvU0pw?=
 =?utf-8?B?V3NVbjV0YzFMRXp1bFpNeE5FbllSbkR0UlRhWHB4VWpDSDNEQjdYSk5tWnhY?=
 =?utf-8?B?cnc2NGZheHJhdGk4c2E4cWs4NkFJdGs2YWNHNVY1WTdZUVpybnA1VWhJNHVp?=
 =?utf-8?B?anMzb055RlhOZU5UbXZTUFFaN3MzK0tYZ0FiWVM5SmhEZ3IveEMvWDE5OFV4?=
 =?utf-8?B?OWF0aFhES2M2bXhmdGJYNGRsc1FYR0NmWnFZS1ZKMWt0SDZTeEswZElsVUg5?=
 =?utf-8?B?TUNyaDRsdHl4SXBoenI2K0pmZ2l2bXJIQ2xJeXFZZjUrTVl5YUNEd1M5NzJq?=
 =?utf-8?B?d1dnV01Zb0hFRUNpTVNrNFBNYW5BVVFGOGMwa0RvZWV2VmJIQTlHUjFXdG1M?=
 =?utf-8?B?TDQvYnFBMHQzT0ZQV0dOMlhzR3VXbUxBa1BNcFV3N0pLZVF3YlY1andnVVNs?=
 =?utf-8?B?SXdNcWFUdk83am9pOHlaSGI3UERXWDQ4a3JtSlE3L2xaVlZWSDVNa01hT2N2?=
 =?utf-8?B?WkJwYlV6UDNqU1VnWTU4ZU95SVVLY29MV3BsODZ0ZmxDLzd5U2RsNzYycG16?=
 =?utf-8?B?MW1uMWg5THEyL2grMzU5S0tFdzAyWTFGbWN5eDh1SVlzYUNRSkR5Q3lYWHVC?=
 =?utf-8?B?ZDU5SVlNRmlhNHRKYnFOeW56b0hlNWU2OWRrdlRaQjVEWnB6K1hhWHRpSWZI?=
 =?utf-8?B?dnZkQVlKem1VR2VPcmZFNUpBL0pOVk1IdGg2a2FWeU81Y0FxbGsyd3ZIWFBM?=
 =?utf-8?B?TStmQmhWUDFPcC9JVVNyOXU2S3JuREpyaFFQRlhXcXhKbzhHeks0YTV1d2Jk?=
 =?utf-8?B?YVVZWk8zSmFxbXZuRSszM2gwUVcybmwyTVl4RHM1Ryt0SnVmNlgrS2x3dWR1?=
 =?utf-8?B?djZWbjRZVmVCRHhwS09ScndXT2FGTFNKWjdSckV2Z0xUa3J2em5zb0RqcWNU?=
 =?utf-8?B?RnR3SDZkQ2dGZ3kzditvOWRwaUwxSGVwdlRDNERmck9HTEZaQjBNK2JOcWYr?=
 =?utf-8?B?aE1BWkhwTlVOai9uaVdHMFlMbTBEOEx4Rm9LNURCaGIwSHFzMktDZnRieU1q?=
 =?utf-8?B?cjBzSDVWZ0VEKzRYdEhNL3lidHJkT1daUjJSWXQ2dktPYzdDOFluYXc4d1JS?=
 =?utf-8?B?cTR2QnVKTkFRdjk3Z0lnREJVL2ZReTNFTmorcWFXK1laREp4SjdvVTY2U0l3?=
 =?utf-8?B?Mk5kZ0tHTm8rbWJYbGlrSmsxL0tpcENsNWJOTFJOc3hGaGoyd1F2MGsxY1h2?=
 =?utf-8?B?a0I4dTFvaVZSaDQ0WFRWa25xNXZia0JtZjRaT2xaclFTT1JiL0xmdE16L1J2?=
 =?utf-8?B?ZWcyS04wRm43eWk2Ri9IVEdjbnFJbXJKUU0rWVliTUIwb3VRY1BSWHZuczV2?=
 =?utf-8?B?SnVKREYwZDQxV0dncCsvdE9oa003TWp1cUlMRlV5RTFXVjlNYUgzUEN4QURP?=
 =?utf-8?B?OFFIVGV1bHVrY0RNZFFybDBIZS9HcDJrNnpnb3RCNFluL29XRkFNUnhSMk1X?=
 =?utf-8?B?NlE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd7bb35-6a43-4cdb-dd59-08da8d2d3e11
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:51:08.4811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSiTsF3p7XfarWXkEtxzerTPOwap8OEkW7Z0gwUTrqUKV0RmgCTTBPSN5ZK5HjVkPEj6QmkNKnfH0yZc+JuaPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR03MB6352
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/22 5:32 PM, Sean Anderson wrote:
> Hi Jakub,
> 
> On 8/18/22 3:28 PM, Jakub Kicinski wrote:
>> On Thu, 18 Aug 2022 15:14:04 -0400 Sean Anderson wrote:
>>> > Ack, no question. I'm trying to tell you got to actually get stuff in.
>>> > It's the first week after the merge window and people are dumping code
>>> > the had written over the dead time on the list, while some reviewers
>>> > and maintainers are still on their summer vacation. So being
>>> > considerate is even more important than normally.  
>>> 
>>> OK, so perhaps a nice place to split the series is after patch 11. If
>>> you would like to review/apply a set of <15 patches, that is the place
>>> to break things. I can of course resend again with just those, if that's
>>> what I need to do to get these applied.
>> 
>> Mm, okay, let's give folks the customary 24h to object, otherwise I'll
>> pull in the first 11 tomorrow.
> 
> OK, it's been around two weeks. Aside from one bugfix (thanks Dan), there
> has been no further feedback on this series. Can we apply the second half?

Actually, the mentioned bugfix causes this series not to apply. I'm resending
the second half.

--Sean
