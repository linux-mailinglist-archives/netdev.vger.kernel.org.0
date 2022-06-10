Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD90545937
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbiFJAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiFJAgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:36:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8B62228CD;
        Thu,  9 Jun 2022 17:36:45 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259LPoN1007534;
        Thu, 9 Jun 2022 17:36:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wbAeM2Drf08u36kfllsgpKbesUj2QSXqIXwOj8hNNTU=;
 b=BnKZfUw7UVMYmv1oU3ZukgPDaU+XQeypl3XgcscyOE1mAAHMjBwBDO00Ta1jmECjEFNV
 aiID7ke1yIIXH2RdEAtq0TTGPsuBSmDOEh+ONuYTHS7sosx0q5JT5AqYm/dC2hZfQa6W
 z85WgU7hHWQ8mrASNt+aZYnzBMkp+rsyObU= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gke7w57nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 17:36:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4v8G4mgx6vheXR1VTkbG1DLqdX4jPGQqQ8aYeCvY4XZA/dQBoiL0fdWFWy8W3DvhyNLj9cgdW40NCffxZ/AJEUVpfSErpkbf6c8Ouq9FkT/gmMZkSOlJST0KAs2l6f8jxlkuvxRupDkPno2Ub1gYnoSMcMXuFzU78TkO1kUsa2aYbzwT0T4uBDlwb+TkGLANYIIZRSBANqTsBFnOU46r3FM06ek4Vf4RBylwQ1cAWoPg4MHQvLBps3xzc82Z9znsB07p1ZoS+Aix/OR9lZLRcVS4k+hBXCmBcrhHz0CbrFslcMoYY5onmrMx4Q2CNUHA4tzPCNgeLHplSRDZVnqzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbAeM2Drf08u36kfllsgpKbesUj2QSXqIXwOj8hNNTU=;
 b=TwL/3sZad5379lcBs2+tGlq+bmdpxw92Tmu/yNYXs8EfpMcW1Dt8Ek2KY9IdPFi3gkRmMpGw0qc7ZNZR3J6Kcq+0MUywYApF1RRI4O+YHsj3S5G8jeazJ60OUIuE+we8hHhRIDW2CN0Aqxhg3wgUZDOn8XtxJwxEobtI0J/eIDGMOuF8AVOhiwACRjGeslUMONS+jiGQR6wH4ZdzSqYgnlqbimfS4hTbtI8TBxpHT1xrrQ0gCGpevYwCkeSxomzwX61vDOSPFRYUv9fFLvbHmZRO7SIZcuI1OySyO/tUuAvKm1hK/eMa6D0At0sfAfnge8efODFurfG4BpIIHSFP1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by MN2PR15MB3375.namprd15.prod.outlook.com (2603:10b6:208:39::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 00:36:20 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::31b7:473f:3995:c117]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::31b7:473f:3995:c117%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 00:36:20 +0000
Date:   Thu, 9 Jun 2022 17:36:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
Message-ID: <20220610003618.um4qya5rl6hirvnz@kafai-mbp>
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
 <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
X-ClientProxiedBy: MW3PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:303:2a::15) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66b928eb-74eb-43e6-9778-08da4a793d18
X-MS-TrafficTypeDiagnostic: MN2PR15MB3375:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3375FA2E0CFA1DF090493B94D5A69@MN2PR15MB3375.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyotM0aCGoFcYeQMim/9OUfEd5Tv/MxlsUp/liMO6fm2BCbsEXZnBhnMbJ4gxZxufiOf9TQBTbW6z+T062MDAVSW2accHD09/V6MniKjGX2FJnHU/SYf+s8mZ/4FHFNyzovm/ns4oquOGtp69X1wjhXFkwP7xO/GqF705aSTXi4Oi10LgEQAAZ6YB0Ov78f4jUV8CVav/S+8lj2ILoUke7IpGofzP9CmXT6IBt8jgSQoJ/Iv35Olp8T33Q3uw3tcVKaEw5jscCzyK5yhUDXqaRQrhgH8w4eYh4Y0ioycd0VeBtwZx26GjEmbXPPR13d01dgSQROm+rXJrnBMxOdCywhhHl0ImOc/gRJSG5/nSr+Q5DEbQrrTT7EX/IgUHz4U3fk3RQw3H+1DvGUWeYh7MrW6cREzOEP52ELDEDI5wb+mrq2FpC/OUV4TXapWhC70ZmKlyV/GWw4YN9aeFJPUvgyj5WqEo2t3XY6xZ0BEQDh9m559RlSg9Tux3ArN/T+mCTpUZtv9FqOcmqyD2CrUfaweGWwrrmxjHvXLLXJAEB0BNKehUnGjXHphMDUdh0f8MgF8GuUE7jAg1K9I47ZOaDxWIDQOCzxL1rB6uZ2zlNiogBWh+5C+3p4O9uycC70AglusuAWCtvVnPWkM43zTbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(7416002)(5660300002)(6512007)(9686003)(508600001)(52116002)(86362001)(53546011)(2906002)(6506007)(8936002)(6486002)(33716001)(38100700002)(1076003)(186003)(66476007)(83380400001)(8676002)(66946007)(6916009)(4326008)(66556008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sMt4TTtxYUsZkHiY7hx6wpDfyxGwTiy0jLsHupyDW2GHIRwMaFOdm6mV2tKB?=
 =?us-ascii?Q?r3fi4MguDYYV2GyELGn0j5S7avagzcdRD7no9l7obKsJ2xOnCx9tXjntmUKE?=
 =?us-ascii?Q?0zB5dsQelXYO7zQlYVX/B0SZLxPIxH3XAA/FI/UaJ9GUQULTNoFSncnH461e?=
 =?us-ascii?Q?qNxdaf+TA/l7bKiRgBP5JbEhIRWa52T5A4PDMd5ka2g14/S3ZdQq4GBg6VMN?=
 =?us-ascii?Q?iVojZcr3sVKrSMIPCID0w4dqW11pPaSUuYkDmkXgMSKm4wdCK1xGHh49D1tT?=
 =?us-ascii?Q?Z9MzHNNNhF5sjBFh33+Z0t51UAr1lcDbr2jstR5wlbbRfiGgVq24i5WHDpqj?=
 =?us-ascii?Q?P4uga/tRHftmbeaY3Rp2qlIZJWDYy0NXaBYkHOsmSky4w/i6xxBSFMWAL9tO?=
 =?us-ascii?Q?58i6GHv7A9qrY0C2ymcJs9Av7sajtL1ROtkbNxP7FcJB4VVYzAtNlsSnc8Z2?=
 =?us-ascii?Q?TAYrc9RlY1uxs7s6I0rs2gUya+ZvsnDf0KRa+EDS+hmd4pNCkPyLaPxZaD7W?=
 =?us-ascii?Q?hAZLDMTOhjaUUmkrp8+5ObYXKwJF1qAaB5l7g6AsZvnSKDK032E0dRVxuqkA?=
 =?us-ascii?Q?Y3pW8GtNxHJOLsbMjPyhoQJ2yANKSm5/rw9kHbHtJIn1KiKtCK+PbIcbDppP?=
 =?us-ascii?Q?oh0M+5oTl2EZDpVbCWFBgWAZ/h5n7yXgAxKjMxRRvP/2hnZtrxAL7PtYKles?=
 =?us-ascii?Q?Lx8dPYPz82iCqYoymJ48X0q0bZk9VcH7gzGdvKU8BbbEdPhQwEdhSzr/Lk8J?=
 =?us-ascii?Q?kIB8q8iNSXTVezXarTSquhaGNSBMpoQfO+xRG9vrm+eNOszQDYry6d8kAv0F?=
 =?us-ascii?Q?3q1crrII/iQKi2iIxS5AKsO90RGGMhFwAn0zBNR0lWV4Dp+rEBDG2gq24AVW?=
 =?us-ascii?Q?ilUnIz/dr7yGfJHoWi8evEXJjxflU27D6ljUnbbMb6K1aeTYovq/bnLLxi0V?=
 =?us-ascii?Q?XbwA7xSK70UvzMBdpkeUoi7eN/oPvy4iFlf/S/0ZatF3gPx1ddwL2vqIjXDP?=
 =?us-ascii?Q?JBDFM0n5rabyW7glU8CjalVLWZQokb/4sUfIJJawnFg9HLas7nNEOk5PWiHQ?=
 =?us-ascii?Q?ygKB/yhU93IEc9vYTPjCTp+lbMcgv4UD/byUk0wlSXCnzF5Xfx9VIjHUVQ8+?=
 =?us-ascii?Q?dGyeqzl6yp4yXDq3NsMa2anmisuyUYslovq4lVzucK09Yfqt+AuTtFETFXQr?=
 =?us-ascii?Q?fsiE28JKzcfk+IJtIR32IX8oE0YSilpbK/V1mIeEKknbMdEWxb5heYL7LhM3?=
 =?us-ascii?Q?NDw0jhkPYU8nRKUCgukauuOmFlQW7iGF6nSEUn8FibH9wmEadNGa2DJ9gqvv?=
 =?us-ascii?Q?xxAfdsJYr0YBBi5WJrjZW5EVF9dwX3oDcbbwy7jJyGqZYaiMjjNlGigHLKXV?=
 =?us-ascii?Q?4j0iFOWzI/SF1FIzEIF+9c9oaSgklA2bBjadCvpxjMSWcopHYKmJVu/xpWiY?=
 =?us-ascii?Q?p+3btVf0ntxlyjKVgLOMwVXIs3sOhsJa7ip+a+DkQh5fL13nHCYUU2eLKxt/?=
 =?us-ascii?Q?bq5dpUlFqueVgRxWJ/mcENWa7NqVNIC5P49ZQF+mzusap1ZvPBi74OOzJdQO?=
 =?us-ascii?Q?Vu//CsCWTxZsrbdkLeYFswjV7rT7mDeqO80hsVeN4w4nGfn1K4YMMCMy7toz?=
 =?us-ascii?Q?v1bhI0hlBMhbF3P3KJeF2u7Gp4TnRoxbbZIf8pW0zo17m5u3e0HENsxKJ+cp?=
 =?us-ascii?Q?RW6HRGWje1BkYdf1f/pjNgoFfp88FFx0F4rmRoF8dLLaftzrJEtQckkuIYND?=
 =?us-ascii?Q?GguWeRxECQlvlMP/189yD1/aqdmdeq0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b928eb-74eb-43e6-9778-08da4a793d18
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 00:36:20.4897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KL1Uh5OZ0Nz9Fw1ZP3qxfWQH0R6mrX+BWZcRRcyK9KKKIhG1yrxxaZ3X/m8GI3ct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3375
X-Proofpoint-ORIG-GUID: 24FDu8HeYSMqijRbEwEgUMzzosQVtrLk
X-Proofpoint-GUID: 24FDu8HeYSMqijRbEwEgUMzzosQVtrLk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_16,2022-06-09_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 05:17:47PM -0700, Martin KaFai Lau wrote:
> On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
> > On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > > A customer reported a request_socket leak in a Calico cloud environment. We
> > > found that a BPF program was doing a socket lookup with takes a refcnt on
> > > the socket and that it was finding the request_socket but returning the parent
> > > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > > 1st, resulting in request_sock slab object leak. This patch retains the
> Great catch and debug indeed!
> 
> > > existing behaviour of returning full socks to the caller but it also decrements
> > > the child request_socket if one is present before doing so to prevent the leak.
> > > 
> > > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > > thanks to Antoine Tenart for the reproducer and patch input.
> > > 
> > > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> Instead of the above commits, I think this dated back to
> 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")

Since this is more bpf specific, I think it could go to the bpf tree.
In v2, please cc bpf@vger.kernel.org and tag it with 'PATCH v2 bpf'.
