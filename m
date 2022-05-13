Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C1525AC9
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 06:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358254AbiEMEaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 00:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346255AbiEMEaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 00:30:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6951C28F1F8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 21:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7qTIpM/anGx2ybQ5RT/tJ4nKONPaMgCc/WNpm50jiqvDqH70o2ACoOUdAdhtEvKSaQgslhx8NI/hJ41k7i9x1HJxTdk8ej/7VwsW3IRTwIDO+vduH2azsX4gBZaYWvbE6brXAmaHpH5i1EYU182cnG9bGMlFNUbvlrpdE4Q9qEmJAwAaqALZwfsYO6bOmffMaUP0JCRiSg+XqiEpQLdvt6nyEBC+8ecoFa4s/dSj8hz3x9bGHRPS99Zfcozn7wrGjQxRb91pzGD3WD2JzrZ6YYdr+TWbi1ZXnitgXoEZjKiYbO0mjARDonUcwvPrUPm2gPs6PcI/bGehnuahl4ctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YGBkI42bthDF6Qaw64DhTGmFm2iksOa2eFmXTtwWJg=;
 b=R5WdJD18NUL4COEuQ4gX4M5JsdeM9Xatn3gd3uJQiQzm10qkahbKM/5rFmQ4J/vkHq/3QZRF0uAgI7hM03RFiQWK6y4nHY3g1/d/eCO1QS3dTOzjlE4NLBG6c/AM8h5ucIheJG1DHvR+vk4pd1gJXxtUrRdDFzGiNipd7gq0LhuHwWf2MVzV0FF+/XYSdEy6Owe21NTywtTHj3Mr8cfTgnanfckEAiX6/RFGqaucX+/undTAGbYImQb7DoV6sJBNdgK7AiMo2wFcLRhTkTsKgMUL7ubdOHV0ylJhqMfms23J5md8AO2XzZyLXNT/TDiR9x1Pln58O71uCaVVcYEP7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YGBkI42bthDF6Qaw64DhTGmFm2iksOa2eFmXTtwWJg=;
 b=nDmgnKTah0ve1fKMZ4quemsmv4qGPWFf0K0YhK1rz3xvrKEjbmm2ptABpEEwQloaHkLv+bCxib/oZdiY7Xbab727eVQSE55NUKl2C3Qeu8kZbL9rMHRzwkkhEbVwgzqwu+WPr2+k4mt2aYfE5iGUj+FTYrQFrz2aolYQmdhPO0XUECQUf5vFihWpltPscoLj1t9Isy3eG4pr0fbYxzzactZopzfLxW3BD4rBufcpPZdV1kw3Dzm+GgJHMJ8DvnvqlPFUzxa8LQkk/X5w8JDlA6bLHp2he3gf0kYzJyciF7eo3w6RTt6Jk7UN+RiThqVnC/b3NdeexduxvLdI9CfqTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 04:29:57 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 04:29:56 +0000
Date:   Thu, 12 May 2022 21:29:55 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <20220513042955.rnid4776hwp556vr@fedora>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
 <20220510033219.2639364-14-eric.dumazet@gmail.com>
 <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
 <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
X-ClientProxiedBy: SJ0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7049d9fe-1051-41a4-2ba3-08da34993bbf
X-MS-TrafficTypeDiagnostic: BL1PR12MB5378:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5378E2E2EA60A9BDB8CA29BFB3CA9@BL1PR12MB5378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gZIr+0xVsNfrUzUX2dSz/9A9US7V043+NWckN4j8sK96qbCuS5mWPQExwi7ZMd3Zqz3XmgtqzvNpBrBkblpw9kVP39OrwndhOZ7J/YuaNYQnCtZDOXQNBNJIeSjWRKpCni8joUgmwveE5HW5LCA50CUtoIJPo6MNTkSzBQ20uekcvvBwP2ohiLX03BOZGm9X1yIepiDNWKHaKklVwJL4jYiLQ/ZEvovxBpRyMVL5fT1O+8ZVICJbKyhbnweqp+qoMjewt2J3S1AhEGipALjXzS73qI+YDNdZF1UTInvVtSE1ohEGf8HnhdpQwRNm4Xk0KBt+JkkySHStDzDPSmPCGweARk/JHNto0klbLlvwI4nlsPsR4IGgmdUdIq7p1nw721184XOkLKQcJfxVo5Bpv2ZCheWcyHHv340PNPzrR39ZQkRQs0CK9KVywNqKOCrVslLNW5MiGWhTQssAD9NhfFpFSTP9yo6GnkOxE1NRbHlXXoEbDNoU4rdJn65Vic8IrO3stzEHX0R97U5iGH97whgIHHEHaIMkMYfoi+t06w3eWGl4TpY09m2y/kHZJgf6wL45jdkKbihaOvUysWpNo+Ar5CG9ddfKaFOx3bctvurDuram+UGo1I8BTovN+7AKysUblyEnJMqEJOqTImOtcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(6512007)(6916009)(4326008)(9686003)(8676002)(6486002)(33716001)(316002)(54906003)(508600001)(38100700002)(6506007)(1076003)(186003)(5660300002)(8936002)(2906002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1ZQu1QdMIOD0skwHaYTRGuqnKE/58qYhS4iYYsQ5r1OVqgnHMGAB0KtxlP?=
 =?iso-8859-1?Q?mxeo1aTuZtk2YzrHzige0kFxdvxFnjMu4kksefWp20/ZDagNN0Dl7zx12A?=
 =?iso-8859-1?Q?YU51R5DIWtIHAsg6Y+r7++f65ja/qv6Z3s8Fkyo2jVyr8aCewfjgKFBOYe?=
 =?iso-8859-1?Q?grVY69jgIpMk7AqKtEIx+woNsnZgeZLoimoBJF+T+leYT7qs2MV4IGJyx8?=
 =?iso-8859-1?Q?yXd7nvnnyxBHGy8eDiRuJ/a/BnO6JLx0hvDoaz3T26eLz5mMkolgmj1ZAd?=
 =?iso-8859-1?Q?KQFD3lpISA2VbCz9JuYzQnb/dva16Ls+z0jT/+bZtW28n9UyqceLpAEGDT?=
 =?iso-8859-1?Q?MeoF0mJdhzsozakDQj5cE6HUZZ5XhJseMLdymQI1T0gBbmI3gKGXtVvO7I?=
 =?iso-8859-1?Q?oUZ3nQF3AfW6wGGd4UsD9Kh8oR0/Y4dVfd/T35uSu+pFcv6lR2jeD2fGDX?=
 =?iso-8859-1?Q?b/19Dwjoh9h7Hk5fG8imYE4VdQMTCP3NGBm+gVF49U4TH+USLl2QMUw14T?=
 =?iso-8859-1?Q?4879H9VeMez2wuMYoLgyySdiGp3fq6bP/9FfqV40a3zmUuvB2ptB/uL7ds?=
 =?iso-8859-1?Q?ZnJ5PxEI1iDyfg4r2LcXox6H2aYSLy2Wehc2FKxvnzrIxp7r6WW9oxTru1?=
 =?iso-8859-1?Q?nT2fkhT94FWZriG/xiAPQcwTBo4SY6bl75JLpEybYPP59Fu0q8qw4ek1h/?=
 =?iso-8859-1?Q?LQy00P+8dF7HkEnWda/vbGRJM6paa3VC/q711Zs75Hm5/+iwfhzmVr1Abn?=
 =?iso-8859-1?Q?cKdgCBJhlBWT+g1bTs7QLv0A8QH6+lRwL5DcQsaUL0qvow0Eqry1hrq0/V?=
 =?iso-8859-1?Q?p+nfILw/qTnXlTBvry/Ft48S819KDBT7dKzhVgaKsZrSeZwmMwr3/Mly/v?=
 =?iso-8859-1?Q?w8oJC45iU/6sHHkJXlb2TdhhW2FMWUwvydtUoU7VSn66HFoRuOf5OxhCZD?=
 =?iso-8859-1?Q?ysRQrE0aL9yBbQIIp12wCUYhR4bPmK4EdqUUyO8smLQaw5SSOoSr9khFuV?=
 =?iso-8859-1?Q?rY5/Cbs/WMv2l742wQ8FcCinUfTZdSSxYrofFhZ+CZPIAmt+N8G2BDKuNy?=
 =?iso-8859-1?Q?3yWYZvyrAptQMTo+ELcUqDi8hKqAZvnecbUpcEtiFQ/vBlUORDTgXXk92g?=
 =?iso-8859-1?Q?2Hr0Wq6ifkLdYJ/sCbccCKYXQdKXJ6bM4gku/BzsAZPEtxg30ZqY5b/otr?=
 =?iso-8859-1?Q?df4Nt5TCBZJIyB9fYCHGUBn9yDLPNq3oJes7++iJeitJJdIP37hJU4LNfY?=
 =?iso-8859-1?Q?cxDojMLfXoLdBjJljO6mNNAO4u96mdcETEKJ14ZABsw3ZR1y7NGwBCmQJ8?=
 =?iso-8859-1?Q?YZP2FEx2SKclZhSszP4yL2lWznqfKM4WzOacLXufVKOAWX//a5E6OkCV5Y?=
 =?iso-8859-1?Q?wKHNkAWR8mUUYPDvu1Gkm/HmFy4Tm7HpHAPYy0KVEbkP7CzPfDoBzUBEze?=
 =?iso-8859-1?Q?ND9aPFdtLV1reEAxNOlWHqbxNdVZw0Li1PBnUEEtj72WMVXu+lqWo/woEV?=
 =?iso-8859-1?Q?dYxO1hfXqqY7vLcnHcdR7uLqtTwyb27HMpvwXrgoEdmWzly18hjPl8mi2q?=
 =?iso-8859-1?Q?icG4ebX3CDa9r8SGjprN9sVH8Sa00MLK9AQCQOywRjWWb9Yri0rcAOgfSq?=
 =?iso-8859-1?Q?WiSr3VjmayPmf1B6ECev8BUO8AKlzu1YSZDeZCXGVttwOAw8cYTc6e023Y?=
 =?iso-8859-1?Q?us787lMg6WXyk87F2DhfyTTQEwbLVv3+nOwhH93BCKmW0LUGSqTRkuRVwM?=
 =?iso-8859-1?Q?9sh/tPjk6vIL+QyL2s7IcVnNYevDd3Dokq6fY3RHxTt19RWAwpA2PGXual?=
 =?iso-8859-1?Q?lmHSMd2XNUXBRb48qaQyHpdEqXVUJMw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7049d9fe-1051-41a4-2ba3-08da34993bbf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 04:29:56.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWlBJHPcKRBlN6r4q7GQ/DDHKDpEE5fjdiGMypXk8YACVp/0pAYTt6PDP7O85EEQpV8U7KOxKb9u/TZkPPeI6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 May 11:02, Paolo Abeni wrote:
>On Thu, 2022-05-12 at 01:40 -0700, Saeed Mahameed wrote:
>> On 09 May 20:32, Eric Dumazet wrote:
>> > From: Coco Li <lixiaoyan@google.com>
>> >
>> > mlx5 supports LSOv2.
>> >
>> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
>> > with JUMBO TLV for big packets.
>> >
>> > We need to ignore/skip this HBH header when populating TX descriptor.
>> >
>>
>> Sorry i didn't go through all the documentations or previous discussions,
>> please bare with me, so why not clear HBH just before calling the
>> driver xmit ndo ?
>
>I guess this way is more efficient: the driver copies IP hdr and TCP
>hdr directly in the correct/final location into the tx descriptor,
>otherwise the caller would have to memmove L2/L3 just before the driver
>copies them again.
>>

memmove(sizeof(L2/L3)) is not that bad when done only every 64KB+.
it's going to be hard to repeat this and maintain this across all drivers
only to get this micro optimization that I doubt it will be even measurable.

>> Or if HBH has to stick, 
>
>My understanding is that this is not the case.
>
>Cheers,
>
>Paolo
>
