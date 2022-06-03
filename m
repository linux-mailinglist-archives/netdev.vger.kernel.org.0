Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305F153C493
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbiFCFjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbiFCFj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:39:27 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4A03914C;
        Thu,  2 Jun 2022 22:39:17 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2530qjpJ023084;
        Thu, 2 Jun 2022 22:39:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9GPnWt27H1Hu9ijKahNVDlpm6cMOxdCy1pIf2YDx/nM=;
 b=MT3/jENgRmGzSLeRnbe1OfG/KCjHueuuGRbC0naiR4rrdpsbKsFenKaxH2PHAsdZgiND
 erUa94rA72ouMGHnE+Ur8eIfndhU09+oHYQzPii8WECXdioqVOkV9ALFOgOvnpJO8f89
 KzMh09MuujQ7P4e8tA0Kbh0X4FRS+edOCaQ= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gevuu5kp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 22:39:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0c6xjpYzRfkWyIR4i41ZqHV6Z6/wxf0NdnEshrRRsnKb3hTCb9Eeczv+8MyzlEo3+LwCD2vT7qswvtUKbCCqvX65LEYDKbUhP1NCORvIGY5Cq57JUC6cELeUv4XCi8V8ZcwGrZjK0tf0TjDEq7gSPuI4mNs3B2TDV+gqDVXdOQEd+vYVMg5W0+Q4Ls3dCpoLcgNrFl3mXswrzSCq1uEVwgbQ2lVPjuYlbCxkKqDohRzjPRT2Nakal3FT0oepz8wTKw1M1e6LAdWPg9gK9a6yYA/kutyarLK68uCU5s+RWToUgtu9SjrgYmB1N2borsbaQW4j0uo9DUOGLE2Y86xxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GPnWt27H1Hu9ijKahNVDlpm6cMOxdCy1pIf2YDx/nM=;
 b=kwZAXIM5ajqu8YP9ngghC0N2qMjav6aRrVZadJ9RIzzsCqsismDm0YlmmAmlWLrcpfh+uWrYyeZjvGkWQPqWdTpztr7+1BcD/2aaAAfhHZ6621ISpaoq9zBdPYLG3UYyy+7a387sAAW4sle+aWmcOrCSChaP4NfDmy7LJkOBv7u/5G7GVKlj6xMiz95onjCYmKmPkfzuArDI7Ue+IKcOLRBEWgjUG6grWsFvRVw+Oy6z0dZI8dyXJiJ9KfCnWo8/KpyPHK4PuukMYSkvPaj+kyVxEm//w+WxXt0R8po+JySYcKnWYNK7BgbaeWO+rqRqtGf+sk4k9TeNcXikEwvb7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR1501MB2006.namprd15.prod.outlook.com (2603:10b6:4:a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Fri, 3 Jun
 2022 05:38:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 05:38:52 +0000
Date:   Thu, 2 Jun 2022 22:38:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 11/11] selftests/bpf: verify lsm_cgroup
 struct sock access
Message-ID: <20220603053848.wfgv4omsfm3mak2q@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-12-sdf@google.com>
 <20220603015225.lc4q3vkmsfnkgdq2@kafai-mbp>
 <CAKH8qBs6Wz+vukFomy7LEyohzM6mumsrgRRcyfy-0J_8drJ3ZQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBs6Wz+vukFomy7LEyohzM6mumsrgRRcyfy-0J_8drJ3ZQ@mail.gmail.com>
X-ClientProxiedBy: CO2PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:104:5::20) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef6eb924-4075-4fd1-c72c-08da45235763
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2006:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1501MB2006D5563D5124B5B11AA6BAD5A19@DM5PR1501MB2006.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GyGQoZc1kS9DdSz5rNHyoJQBwKy9mJNb+cHWbsFZcGQICq9orEKKKwcypM/K92BwLwsJV04BB7+AxTJm+fCxcI8fWKbaMrXePEu14upMFySRdtTmlw/W0H69SXbjhvcenc2cxZmAQcF72KOiTJXHYqU0fQ3oD3NjFUjHQ+WSFwrPkENZ6fDGZDE0GXg/L0x4CZP9MHoqAbu2sUDFU1VZWVhQ1qbfZXXiroPqaTNd8w6H8SOI+9YSaAeCKjuPvSLADHygSRlWcpNg2fq1+n5GQFYFMY++4SyBwPXTjvIqjVwcCWGH7IYlU1hCjy8/wNNfwOeqdp/FCO2asBbU5Z1P78YE6kNCCLKT+QF3K1VR9ZaAoctbMaZDHg4MLdH5VQfEgEYrH4X6V8Tphcc8/uZ49VLtc+CDXIO6WVVAlmcJGkpkUGLMYhSljQzfWUXuSLuDySoPPo/WvlV2Fy6d9BiOmM8N5pfnN/QZq1Plsmk4DIXGbi58MXlgC0H9xf+TnLqAzQ6+g/GA09X7aM5spJr10qQWuk22OxO3hzMn3+fSas3nmfntki9kHfKI6fQDppYnb0BxiCuUiFMxhpiYXFLty2jXGH41kYSkxICvtNcYZrlYo4n3u59TkpdwiKd/eSYUdwvSfC1JWmoyo7HrMrAmgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66476007)(66946007)(66556008)(316002)(8676002)(4326008)(86362001)(6916009)(38100700002)(508600001)(1076003)(6666004)(5660300002)(6486002)(53546011)(52116002)(6506007)(2906002)(6512007)(9686003)(8936002)(4744005)(33716001)(83380400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+gjg8E4rmVIwBxiQdK92E4czy/ZQatc0R4HqMMELCBM05Vvpkiv6kbHxMUvb?=
 =?us-ascii?Q?8b3YGeO/GmO9pLCWD2SvXcvksVZd8OhRUGuTHx/NNmRoItZdElnD4gGklpT9?=
 =?us-ascii?Q?Nwq7XW1EIhCagnFHxYlSUJ9w99uC0cOTmknkY9aANMutGNVLxZTyCMMxENiI?=
 =?us-ascii?Q?PrREzPM8O5/ZSSUoP+SVaC0hNkzOpIgnXLTY11CYAwPW5TGRgbz+u5kfzU1V?=
 =?us-ascii?Q?ivBcEApRC9at/6I/xVE7CPhCIIhUDLNCgnKBAc//P/aUX3xuWXBMSFYLevsa?=
 =?us-ascii?Q?92l+8RUmaUKUzgUCrzw1EhAaJ1V4bXfKNIpzDQWh6gwwtm8TXVNHbrBbCTU7?=
 =?us-ascii?Q?qa6a32FSxLWkhdGgkFoz4yxc5oIywdtkdhQZXFyItfGL+RPkgEEm/6vgtZ/y?=
 =?us-ascii?Q?VlaR6PjxriY0Qwz/uSYG4k/5DLgeIR+/cVJXGAoRDWyN6/Gbj29K8rZX+0I2?=
 =?us-ascii?Q?5Yza7MvVzAotXD5YiOh8mCQVvdcDOfcF11dtrDvInvww1fKItvxDNqjItz0l?=
 =?us-ascii?Q?Xqt76fuGConrXNbtr9lKrWImTtolNU2iDGq+LYrgcGZV984P9IJyHcAPOP9K?=
 =?us-ascii?Q?3vzQHtvi71tgQ8QT82LAk9XYjVsl38o18Hqavaa5h4trIeoi/BDBXsR0TOdL?=
 =?us-ascii?Q?B1tGO/vzOvcRpkJBp6lEVZbBSUVN30kIbOrN87fs6Q+Coze2QSJgDNaGBAQt?=
 =?us-ascii?Q?6mWX3T2XKmwmYBClclKL7HsrdR5sIGCps7tzycd6/mSIzIT/W1YpPTuen/qy?=
 =?us-ascii?Q?5HD5j805+TzmtTqK9Z6rUlXI5uK+lD1BDhhliXJJ1W9AnwG0qkx80nPFZ/QQ?=
 =?us-ascii?Q?i4A/ZjKYSvYsHztiM0bvt8AzxA3B813aHp2twp2D7v7mrwc5yTx7DN/5abRj?=
 =?us-ascii?Q?SZhVCeatXGvzUYJXceLIcDW/TjwSVaa+7cp7i2UAb/bCw/+m6ddSvJ7VYCtP?=
 =?us-ascii?Q?efYUFIYFVV65qmFrWY2WsrCqGGip9SWvem+gjViKVLAefhNTFjxk5lU/14vb?=
 =?us-ascii?Q?NzZLfiPyAhu4zdv4JUxEvyxXdW/lENaXtxWY2jMfUh5NeiaiLjw8Q1diBVEO?=
 =?us-ascii?Q?dyqxRIFsE82evQPoyqss2q3iHSGHsAZv9crj75HkSPlObYFRzX3QAh6B9cTH?=
 =?us-ascii?Q?UufcvqMU3Nm15APCz0XUizIgxFQn5kTJaSrLo3ZeotavZbeSCImLdWqC6jpl?=
 =?us-ascii?Q?maJzTG5hvZN4mFBJDKo94RC0o2AcFxlc5GoCoMw373DKfdxE4xNwCEOl9674?=
 =?us-ascii?Q?VzYzHyKYSSXaoqpw2coCS1nulVaVO/7vimO6u2Ahf8G6FXd9VyeuWiar+DVx?=
 =?us-ascii?Q?FVWDIyL5qhBAZD/Y+ovTaFQ3lwW/71sRvAslxF0FgyicONaVWTnSIYevtF3f?=
 =?us-ascii?Q?Maq8tCgfCXccunvyrhYhDgRyDOgp/an8R+Fez0P8sJyaKtzPFcJUpVn0avfk?=
 =?us-ascii?Q?R1X5wOQaBXtfVI17zeAOxmr3b3Y9YQg1TxWjdZciiIFcjq/DyGNYYxahtvqt?=
 =?us-ascii?Q?ptJMLXadIAIi/aPvFZ8j4zbA6CSICsEkrIwBt1lMxUi7fowqEcghgeJrnJmO?=
 =?us-ascii?Q?qnuEzzo9GhUBbOpKkurk1vtjsCiuAZy5ePAX0j3BFdJTLgup+iN7dKZstKIN?=
 =?us-ascii?Q?sLL5tW57ecKJcv0ADA8zvJXHw/HXNXVE9voQyCDuAXgl59fKq3YvVrETzYGs?=
 =?us-ascii?Q?wglOHpD84MP11bTZkpk9ttIxBOVF1TQ353g0TvYXRVc+aDLifOUIQMc1QG6W?=
 =?us-ascii?Q?mM0MfwII5vbLsVZslVpylIgeOWY2K4o=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6eb924-4075-4fd1-c72c-08da45235763
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 05:38:52.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BI8oyL4IBgNQ9GxG87FQMpwOUR4kvTKl1rnDkq3TuO9s+KD6nxHM6A92Smb7uKFI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2006
X-Proofpoint-GUID: cmja5hXDnD5NRlNw_RFwwV0grZ6Uf0sA
X-Proofpoint-ORIG-GUID: cmja5hXDnD5NRlNw_RFwwV0grZ6Uf0sA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_01,2022-06-02_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 06:59:47PM -0700, Stanislav Fomichev wrote:
> On Thu, Jun 2, 2022 at 6:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Jun 01, 2022 at 12:02:18PM -0700, Stanislav Fomichev wrote:
> > > sk_priority & sk_mark are writable, the rest is readonly.
> > >
> > > One interesting thing here is that the verifier doesn't
> > > really force me to add NULL checks anywhere :-/
> > Are you aware if it is possible to get a NULL sk from some of the
> > bpf_lsm hooks ?
> 
> No, I don't think it's relevant for lsm hooks. I'm more concerned
> about fentry/fexit which supposedly should go through the same
> verifier path and can be attached everywhere?
fentry/fexit is BPF_READ.  It will be marked with BPF_PROBE_MEM
and the fault will be handled by the bpf extable handler.

If the lsm hooks cannot get a NULL sk, BPF_WRITE on the sk_prioirity and
sk_mark is fine.

Took a first pass on the set and will take a closer look.
