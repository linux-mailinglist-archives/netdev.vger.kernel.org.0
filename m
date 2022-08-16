Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D725960B8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiHPQ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbiHPQ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:59:46 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA95E321;
        Tue, 16 Aug 2022 09:59:45 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GGlGtP026044;
        Tue, 16 Aug 2022 09:59:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=sqTnMbasM963BbiNBPRmzXRiHIyGOSUUFi3pPm7Jmqs=;
 b=PCV5ryEYQ6UjdlMhJXIiIp3q9AtCU9JkKjYKRfSXYGErARJ+USs+8zwwbjrN7A2Ch/ft
 5hhlM6Zy41EGpBTHCpI+ihN4C9XYEirad494hNoDKd8bVM+NiIDsIKlQXXAizCkblfaS
 qgCRI+OilqK290PZwtqii8jdPcwEaNhvMb4= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hyn841tch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:59:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqkNWBOvBFYQYgn/fHKkwTfoVOy1NYCLT0rKvj5iFuP7Lf9NrFCGWjbEZUgeAoWgP0qWITZB2bthcBJAZfRZqc/oj0XhwTAT/WktCx6ou1JZJZuShZdFPauGbgNoCHSS6x4oeSqtdNz+DWnIIudB6eWyfFlymZrkxj+tCHlRmRcomRVxNoUvdenJIU5nE0ndKwkzlk7VlBEwclS0pm1IgO80LukagDTwvP2XYbDrX/oQd/2AFUXhBeG0v0ONTK/K3iloIxPrq3XlzXs6DZ8KWXKV7iqQyFLGDuay7gWuLgJtf3FuvmlXgNl7Ps448TppZyLQTMgqif1VcdZ8VkQaKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqTnMbasM963BbiNBPRmzXRiHIyGOSUUFi3pPm7Jmqs=;
 b=Gd4XT/V4DTHGxOwHBlyl5nTkHpNC/IXl95UaUAwR3BN9yGyI9CSfPHinp/t4PsTz/I9I78bvycKcUgOzaaWDAQBhZVB8A/MtDPKeN23DvpZ5VE3c05EYinz5eVaY5jhXKeQFYpFHeK9DFPVLkGBjjmF+F6BzwJU/kEVNqwqFcDQa6cvwyJd1rPyw1RVsjAbhD7DqM9VJfsiTmoYCcDtprur5zqYi7JnGNWaZ8djpxylwkhFn6Pd9ljR0yPQWSomphoFKsxbY1PUGsw6JgJDF+pDVJ/Wit4kIMamIt30Pu08F98V6D04p8Nrq11VFhtLWu95P1cHGNaIdXYaRN2Igbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MWHPR15MB1567.namprd15.prod.outlook.com (2603:10b6:300:be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 16:59:39 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 16:59:39 +0000
Date:   Tue, 16 Aug 2022 09:59:33 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jie Meng <jmeng@fb.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: Make SYN ACK RTO tunable by BPF programs
 with TFO
Message-ID: <20220816165933.j7nsql7e7dytwoj4@kafai-mbp>
References: <20220815202900.3961097-1-jmeng@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815202900.3961097-1-jmeng@fb.com>
X-ClientProxiedBy: SJ0PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::11) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e3aca33-e0c3-4abc-d561-08da7fa8b511
X-MS-TrafficTypeDiagnostic: MWHPR15MB1567:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uA0NXR40RzxIQhHoKGyu+OPWHsrcF7++MgxF+yHsWUB846CRL3oEbpNdHTwoIovZHAoQZX18KJjjzCSeS8EdQ5+FtGE9hSYa6184rsK79n3XyiC49XcL7LoTUqSSpLSWoOrukZPcp53VJhVOHiEq89bsRA11tg6dph22KXlpRXibHCjZPmcyT08XZhV6B1gPP0nn97C8QVa4m7AavlWDMVIhtAGw0aQ9Pt1HcAJN0+HvdqwxR1E5oVBWyjZzj3rlKRK3eRFC/KwrCb8sOJw0AZyhJwmshPq77xQ/8nYfA0mbGvPFGiLAR8q0wAyazqRiS4KjMjmfbiFo6C/pRhSTrEh/V9yNTrCQddx9X6ptM+h/hrR6SoDHf8hnEkhu157zMhnW1MSo8bWzl+9lJSZDveh6gcHDu45ZnazPPPV9S0aP9K5Wh/wCBW8edDBG9VC2rY1aYpWw2dy6APHIeUYJ162vX7QT+Rr4f//7A8XXkiwTvEw+HAq5W8OhCduvjtRG71oKatHWYdkvvU7zbSu6at7rRRWSeLQmcZ6SNNZSEqr85wS1ydeHdXvYxwHRLecw+LHoa3bD8kJPF0gOyGA3RE9qhUHGRYFuJ3qI6azwukzRltDeN6mTIy0GyP6JYhFoOnwGOH8QztzTHwnWYk9Dq7DrsvKuMm0xFy8D1YtABjnsYHvUcNp/E4KnxOpm78M3R21wpLbceS6vqMEh1Z2u5rKE0U7aJ06cAhMhBtfTZtsJ1gMFwoU36Hh9x/FtvKw/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(86362001)(6666004)(9686003)(6512007)(6506007)(6636002)(4326008)(52116002)(1076003)(186003)(316002)(41300700001)(478600001)(6486002)(66946007)(66476007)(66556008)(38100700002)(33716001)(2906002)(4744005)(5660300002)(6862004)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ch75hZZxxLFxxStAd7SraqVkwiPoiWnGcPvSn61A3lxTUUfqiz9/hnp27/vO?=
 =?us-ascii?Q?2taWIf2WjubqjwLnWoXHGWWyoopCiab8aBdOWE8nF6qEMe++ap6Aif+AeJTa?=
 =?us-ascii?Q?KM81cO9uFFo8fbR54EbVBVEK3ghwRNIwuae99LHHpuKwq+a+Ft2mg6I+IbDz?=
 =?us-ascii?Q?5+lD7cv2ZANM6vM1vV2efm8AQUoSTh9TfT9BqbKi2Nlr1XS5JpiYvc4h2Sh6?=
 =?us-ascii?Q?O3jD9gFdxmifJDjB8wU+aeVuHi34BBapgPA3CBCHUFGWToSGvUCPalicvg3X?=
 =?us-ascii?Q?QVGbw5S1I/2mSwyh5iM+wYi98numLe+tExm4B0zkT9t3X/37FSH+6k4mj4wc?=
 =?us-ascii?Q?+h8UyEbuqi/uoEY50wll2MDQgdsiMcPHjTuv95xO7uOsKKRh+v9pURq3+oyk?=
 =?us-ascii?Q?GqSd04xnmVQrFDPt9CvH5g+lxn1BRAM640M4YYAVn96TwlNAyX9RYlkGuzu7?=
 =?us-ascii?Q?/VoETvzppw7b1+XrPVMdq8iEdx38bjQrHnBcIA5jh++lBzQNebehGgxjrdyJ?=
 =?us-ascii?Q?vOpT59/2KHYfmZcDim07e/5U6EKkESyH0TdqW7IGf6kU8ezQoX7vTP5LNMkM?=
 =?us-ascii?Q?Na7tlhpc3GVTn3EFWwOYfbGJArjQsi7kka6BkQMkSOfJEAp6PEA3XiA9oe7j?=
 =?us-ascii?Q?MJli9T0w3v++Dc+QAy9mhs2QeDFk/IAaa/zbYzeqGlmc/gd2n5ZslM+x2BFk?=
 =?us-ascii?Q?hjhyoP28uhMEpD2n56F65CPot22WFlWdWtPGQCLDc0nnH0ZECH+jw1Dtcoc1?=
 =?us-ascii?Q?xhtW6Ko7b6HZuQIhM0as0Pl3KY6ovxFm6xLAGRmcspyp2q/vmYUdDj2cr993?=
 =?us-ascii?Q?yEI1bOzbFW4PujXNaIgq6Cv6eMQIJJY4+gKm2ZDTOITwrOA5Ru7Q6TveIk4+?=
 =?us-ascii?Q?f8o9N9YMHC2Mf8+e15rbLVa3n2ScPldO+m5I9AWSw3uOkZEmDfaVRi1N/m3O?=
 =?us-ascii?Q?d5NVSgRycm2lh2v7PiVo1rbL1u44P4Q14Msk8yetKUXTV1EBAdJWIQSAW8gP?=
 =?us-ascii?Q?Yb30xx3l0Mm2oKiowLuTtCp4giUMe+5DeGyXbB1elA8LDGy0PJ2kxTNkFCGR?=
 =?us-ascii?Q?ILk65lCcIVga1jGCBgyUOF5rZ5wahuXy76hiw9kY/FXN9gHfuI9xZdH9HTjJ?=
 =?us-ascii?Q?Ak8pdrBEKqGql6IkDYk8pBT6R5R9rkXQ3Ketw/UOFKsloOJx2C6NVSimGBwI?=
 =?us-ascii?Q?Ey7xrEqAi+upXLj7gKtnOcLGP1lwRvXkhe8VrTpWLzjE7sX5OE/M8ZpKg/rx?=
 =?us-ascii?Q?J2CfKQA6MWctzOg9573y+UJz4MsO6tVBXZpWhQvA97YZFChgRWtUW272cSup?=
 =?us-ascii?Q?oxUEmGIW1ao3ieYGolINgM92y9w31j++BpedqO0A2GmExaEe5iNoHZRZ3bj5?=
 =?us-ascii?Q?0KzaLqkTtNAatfldEuGUnv7Mfn2JDD1C6woyIfyxdggfujYbR8lzAl7FSli6?=
 =?us-ascii?Q?+NnW8wcRJhN089iGdIvfi7kp/0jrg1Y+sKg+6IeqH//cFWZhBrgJLJxgjYMn?=
 =?us-ascii?Q?Nbyc2vYbjjWuyUD1SIS5ZcOF9cVMJLdDxlHSEvADFtzF5KPVq8aUm0tIDjvY?=
 =?us-ascii?Q?xLVMMX34juIwmpCxdosGPn/wgwLI1DWF0RM0PZSAWh1UB975DPue2TSXb+YN?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3aca33-e0c3-4abc-d561-08da7fa8b511
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 16:59:39.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZVz545wHNVrU3ZbRiachESlcgSOk96YJtNa2w43SToG1y1S0fIHNy3C5Nnzc16B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1567
X-Proofpoint-ORIG-GUID: UAt-7tSQFFa-7ICam8-ciRgxnQszyLUx
X-Proofpoint-GUID: UAt-7tSQFFa-7ICam8-ciRgxnQszyLUx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SCC_BODY_URI_ONLY,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 01:29:00PM -0700, Jie Meng wrote:
> Instead of the hardcoded TCP_TIMEOUT_INIT, this diff calls tcp_timeout_init
> to initiate req->timeout like the non TFO SYN ACK case.
> 
> Tested using the following packetdrill script, on a host with a BPF
> program that sets the initial connect timeout to 10ms.
> 
> `../../common/defaults.sh`
> 
> // Initialize connection
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_TCP, TCP_FASTOPEN, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
> 
>    +0 < S 0:0(0) win 32792 <mss 1000,sackOK,FO TFO_COOKIE>
>    +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
>    +.01 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
>    +.02 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
>    +.04 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
>    +.01 < . 1:1(0) ack 1 win 32792
> 
>    +0 accept(3, ..., ...) = 4
Acked-by: Martin KaFai Lau <kafai@fb.com>
