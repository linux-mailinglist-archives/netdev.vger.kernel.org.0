Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C3D525B21
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 07:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiEMFtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 01:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiEMFtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 01:49:51 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A022F5C875
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 22:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbJuUZLwI4u7LQ1WzkCEyPO7aCwlvbbcClwVudwjaDeoNId7pJdKes6LQAOwDqtZou58+9u6ldPzO+F72oiaD/T0dWnwmTJ+KHU8j5DcHzFfp1IpvydAxkpwPwfG6rbN8vTCFFOGeZQhy6uMpG8d95aH84Xd+t8GMSwCJzXaeGu17MQRPf6D2yef/BS3+edlpy2SY97t6JYFhMmR+N4dFr2L7aao7dgnkh099e7BJ5pnF53tDH6jjAbpgxPkx2696tOKlCUHg1IaJ/UD2HE5fdYanx/jwHZzQWy0g7OyUbJ/wd5z49VhuoH+ezAC/re6niNKGicCz3ZDjbfaQ53Jtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVsCg2PJR/0bG/BcVKKh7p5RBxJvSBbM4aFMCNWMIsQ=;
 b=j/EfibpGTU++UJ6EDDtD8wagO2WoFL/tpBsjAV2BoaquJM2gPoptTv8ugcPhDd/nS203QArl2mZb9scN6UilnsVpQSdPrADL8ORblX75ZsM21HNAxrCO+KQ21xMtwdlNcCCaJJarikM0DDcLh4DM4SgnwTFAVuCJkporFrqYKljYE/DbAW6oh+mlDlFSDMSwebaVcXfGo5bW9GZ1lTEhor74ZpoDHRsYVv057RNvxBwL4xW6SBVf46lwbwKEWwV2PNiDrughLZmEusxjHp2mSynwqAoaqBYEka0YwGmfQmVwcMRinemdQXTLtIYriMjD23b1yN/e1S1aYNKKht2zPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVsCg2PJR/0bG/BcVKKh7p5RBxJvSBbM4aFMCNWMIsQ=;
 b=RzgJRofYP2bTojMzDQsJytw+i0L2924fqJ+v2NRJXj641hiuZ0WBt42qtDwPnQjn6zgkz8lD1GaIEyFbJlnjV6uzuFF3dOi4S3nc+eFP7oob6uNyD4FqU3lqC5xGAGzTEURqTJTxHgLqa6F4x5M7fnBCCNZt4n5OJz2FsC2+9AOjSmEhbpPKeaQ8qxeJAklwgQm80Rc3oIhj5VtvZz7uRsOA7winGr91elg6FLnSCmMu//kDd5y0hc5yGaOfIsh7rMwOU72W/K81OvzDArukFmokBuBUBNV5cpCwMp9yRv46yW7iHFERdXmH9SPZWQ66IVuVNM93JGs7jzbuygQSGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 05:49:46 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 05:49:46 +0000
Date:   Thu, 12 May 2022 22:49:45 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <20220513054945.6zpaegnsgtued4up@fedora>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
 <20220510033219.2639364-14-eric.dumazet@gmail.com>
 <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
 <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
 <20220513042955.rnid4776hwp556vr@fedora>
 <CANn89iKSs3bwUBho_XEuSBRB+v+iR98OZTrhaSS88D4ZYwCwSA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANn89iKSs3bwUBho_XEuSBRB+v+iR98OZTrhaSS88D4ZYwCwSA@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::6) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5fc88db-996a-4b53-db52-08da34a462f7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3370BDAC39B70CD7E0FDC2F3B3CA9@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eoY+EH78ryEBadkyAJX8/yhZVPPsj40cQq6SBqSV0jflniqvBezZ3vO6+NwIYhuNyZMjFSOpUxkGQpdr5eL9rBom0P191m9FcMjZOKdXn8aJ3RssDyiQhAGre7VVb+qVJRzfCeYJov8sJ0CVpKkL4H9NA4ulFsiZe4+EYEISRWdS/2+T6pOIma6y77eocDM5XPaljRla+z61S1xGRLSr0zLp3rl4RrB/SrtXntYBFY+tjEkibBVj7nc5Hm2vEw2e7oxoxHo9xiHe/vHE7aqu6mhAJ6c3r222/7ZaXjEpB85MmyDQQh80f5mw4b9JWAKKlsf7/JIwJYjh29DQGha3bPLWqv0x4R02zEdu4zON/EzUBXoKnePtfkkhb8Mx+Qk2FlbexEjPks2mKs/lb1iBUggdfRpsfzN/VRq7DZPY35XP4JrFLd/dhRn8hmsbV/8MlPmeO4kV3yWpzjN/3oxvPNk6PlxIkXash/51VGAOjj7P53+GwhlVpyJ3Asuq8o/j45w/b2UXObR1OjyKpE/CZcyXioytXrvIZT6Hf4mR0Lv9Sr9RNkUKfk2Bo5XAEonPXz0ZXlfrYMQ302RwGScY1LxtaTObi4C5zAXv1HD7m+uFYXTkwR+cvtcfEy/mlMcKFFEhx8rzA9MNTn5Mu0zPzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(86362001)(6486002)(6506007)(508600001)(38100700002)(83380400001)(9686003)(6512007)(186003)(1076003)(8936002)(5660300002)(54906003)(6916009)(316002)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqKz6eWVKX9t5XqNecFGPZCcLzVsKbRevpbJY8mS8B2u2JHzNusndcq747ZM?=
 =?us-ascii?Q?09ZL7xkkDylxZF79RLVYT5BzhWMBYAqmzbY8HWg+qLkgqrUWjaRi2cmhNV2j?=
 =?us-ascii?Q?dQqa01gg8Fk74wbrmnYej0ljIfMZd+53rAb0aPaakZ3tQPZu3xfunqLTBLwX?=
 =?us-ascii?Q?x6BQkhgOTY98zXlrNEEeSrsRlOLMHlYmr/41w1e2NvVDcoVsIwu5ikR2TdWv?=
 =?us-ascii?Q?T7mhqi+AY2Y2nMu27LrZTmPa9YNKxk1GacFp0XoSnEom77vlRDQpP8L8tjwV?=
 =?us-ascii?Q?1ThWq9q4+qT0vafTPvI9nzEJCTtbwYeEglUyyjifb37WZw1/rGUvKCvQFHPi?=
 =?us-ascii?Q?k3uEXP0aUUgGCS+s0mhvC//8g8kP/fHHNgmBqYWc/F8387hJSpAn4oe1TCLE?=
 =?us-ascii?Q?tthjTjzLlJ3d+wgl0X87dkw8m5Z9SmF7jnNrMlR7d954A4GSjOV668zTBmL6?=
 =?us-ascii?Q?lz4wCn+osENIILJG9vyBG03c4ifQi7gH+DUO2X5e1QDweMPcZWDQ8rg3wRG2?=
 =?us-ascii?Q?YbOczK/QFaxR/p5rpL5LTz16HX4kxJQEj769MYijDTqjxW0PVL7FPzmsbphi?=
 =?us-ascii?Q?KaMiOZLklcf+CJFURlCGGK1G+0dJOsmWLFBq/+dU/HmRzI8GQqUX95fwtp3G?=
 =?us-ascii?Q?9SLIVGEEilXX70tzRQvfv4NAiQO5jh4z4V1tkFS/F8e0CUxCXNvSdCPPRx5J?=
 =?us-ascii?Q?KKYOivFAmq6YSv63anpRkkh2cHy++ECbcx62Ww3uaQuHOdKxwG/RGYFsc3UI?=
 =?us-ascii?Q?mFUzaIGnAvvNJyptXtzNmwyRiANVx/CCN2QQgy/lsw5nakgZ0mkhczqljP1X?=
 =?us-ascii?Q?v+hgqFLNmDJEF/xadL8sejn9BJl/A2Cm4Z1qib7uYD8VlTxB8z/RSZdKBZOu?=
 =?us-ascii?Q?uaLATl+gpu0rA+vHS3j3amjNOkBlp10tzGHSTsSUwbUjF9szgVWYnnLeVjOD?=
 =?us-ascii?Q?X9XraRdPTxbKTDYQhOaWfTcsYmdXtxSxMufeqrY6baJGDbjDhY8iPwJdQ42h?=
 =?us-ascii?Q?EU05slt6o9fYOp16j60KPKc1P/hlUJyYjjPjqE9Aadep+mtoVRqNUfyDq/hs?=
 =?us-ascii?Q?0yx1/a2x3E/N5s1mITy8odFsCLPlAYqgXbG/GHLhPqOEZjUez1ZYo2jONdpf?=
 =?us-ascii?Q?fw+r6zIJR23oFHSBYlZ0+1t36HBESxv3gsPe+NxXTl8Hy5BbfAv4G6u9HU9L?=
 =?us-ascii?Q?Mp11VCNlIpt6/gtYsOLLrMNU5Fz087E+AkMEKpbnBcjNr/tVdrKAOZ/ABrsU?=
 =?us-ascii?Q?N5DI4c9QDjToi7o+h9Z5kS1/w3k3YG7KMGqCCpYsHvrgjFclDJ/x5BENJqOA?=
 =?us-ascii?Q?ke+ewGxdCt/3llRtIGdYjNhmvgxTRRdsBSMLjSzfzWWMr7q7PvaWagVXL8zS?=
 =?us-ascii?Q?NS0amVBZ8pGaEv38s5XYoPuMPKmiYCrGYolVNTOD0ovLWE4ZHwXiy6m3MHC4?=
 =?us-ascii?Q?/P7GVahVK3wkbyiyc/oXSMDf2WGb42X6rqXd7ckJNmL9AIYRNSnAyYPfWauz?=
 =?us-ascii?Q?lqvrt6Nm0DohW0Bus+KCR0XIym6LABmNzG0qZQnTt/YBpw54q1eCTSfE5r4F?=
 =?us-ascii?Q?lpA5dD1s8UxxUlPWG/+DEVTmqxNNgehUudRvevmDG2tRn1MsX32kMtGsatSu?=
 =?us-ascii?Q?wOlrfJ7Fu5I7yGoUEv4FjaDvEOEs+iC6ERVdrQUG/OXLnwbLpe7aeP3bxv3C?=
 =?us-ascii?Q?90RqzLYbU41PiL2VjyCBnvhx1JNm6z7mnR923RZtZoJD4o6UaAKJZhlbjddL?=
 =?us-ascii?Q?fFPa6n40AW/JMIiK70fnM9/xqx/No+/aQF2DMtX2ey4+4Pa61oXX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5fc88db-996a-4b53-db52-08da34a462f7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 05:49:46.7600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FesYcwhVaLxULAgabbI0nw5TeNsUGguUVjO0RmPqR1mO5HduNdHJiq7buKNDdaM1f00p1ga27LHRDRJoAmfHCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 May 21:34, Eric Dumazet wrote:
>On Thu, May 12, 2022 at 9:29 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
>>
>> On 12 May 11:02, Paolo Abeni wrote:
>> >On Thu, 2022-05-12 at 01:40 -0700, Saeed Mahameed wrote:
>> >> On 09 May 20:32, Eric Dumazet wrote:
>> >> > From: Coco Li <lixiaoyan@google.com>
>> >> >
>> >> > mlx5 supports LSOv2.
>> >> >
>> >> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
>> >> > with JUMBO TLV for big packets.
>> >> >
>> >> > We need to ignore/skip this HBH header when populating TX descriptor.
>> >> >
>> >>
>> >> Sorry i didn't go through all the documentations or previous discussions,
>> >> please bare with me, so why not clear HBH just before calling the
>> >> driver xmit ndo ?
>> >
>> >I guess this way is more efficient: the driver copies IP hdr and TCP
>> >hdr directly in the correct/final location into the tx descriptor,
>> >otherwise the caller would have to memmove L2/L3 just before the driver
>> >copies them again.
>> >>
>>
>> memmove(sizeof(L2/L3)) is not that bad when done only every 64KB+.
>> it's going to be hard to repeat this and maintain this across all drivers
>> only to get this micro optimization that I doubt it will be even measurable.
>
>We prefer not changing skb->head, this would break tcpdump.
>

in that case we can provide a helper to the drivers to call, just before
they start processing the skb.

>Surely calling skb_cow_head() would incur a cost.
>

Sure, but the benefit of this patch outweighs this cost by orders of
magnitude, you pay an extra 0.1$ for a cleaner code, and you still
get your 64K$ BIG TCP cash. 

>As I suggested, we can respin the series without the mlx5 patch, this
>is totally fine for us, if we can avoid missing 5.19 train.

To be clear, I am not nacking, Tariq already reviewed and gave his blessing,
and i won't resist this patch on v6. I am Just suggesting an improvement
to code readability and scalability to other drivers.

FWIW:
Acked-by: Saeed Mahameed <saeedm@nvidia.com>

