Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB7640F0FC
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 06:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbhIQEUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 00:20:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230407AbhIQEUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 00:20:33 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18H20rPk013876;
        Thu, 16 Sep 2021 21:19:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=PxbfRPzRkXkILoWhH8Xc9G9g2reBkWW1IaSXLnzn94M=;
 b=iQw0v6X8oDavH0itoDffnjJeA3taD8sysbrv+ptIj4/3/6rhKPikIWa4QTTqE+S1ZsSM
 d6Uw6DtM+XaDC4rnqWhrm/fGsuLLWqYCbcM3CE2w9EEQnndIi/d3i5NIALYEubFnx4mJ
 0bKKfwPZ7AHs7nCrgK/Z/k+kKKW4agoJSt4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b47j44tw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Sep 2021 21:19:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 16 Sep 2021 21:19:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxyoBfL/3uvGCqlU0kLH85yRQsXgMOYRSIGkeTmE+oCYfIhfiRrwHl7Nz0hSq3rgT1pj2etwHmg0UwS8WLflrAc+bRUswzT6sCrQamW7oZXTNCTAIN2+YhkR8Zz5Mbo+yOtr4o05QhpMBe5L+5HLJT//Ie1o08bjD1el7sypomo7n609JAO0Vl5/1TAmd9ON8S52xLQSZCgUo1cz1pBFpnwMoPJh1KHakQCJ72d6ogcxn1o26QsBUte7sCqHyne44mhbsS7uVMZ1ZsgL272wZCtetAaBJWkUblxlD6bta6JNAotlKT+8Kf2bcL8ywwPSfkkKdqC4fmzKHGaTaD4ljg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PxbfRPzRkXkILoWhH8Xc9G9g2reBkWW1IaSXLnzn94M=;
 b=XzwB+1oXlJfueKtBUHQItVXEdE74sAdDD2zfhC+NqhorZzP3ue/OIowVQmAcIpo+oap4q5gSg7TkgVJ1OiTPOOfe1SEJuOKmvmfytIP3IzHEEAQO/75J1sri5SzuFkla4tyESsWjwynr7NcZKkmlqyW3qswrpDHrnprxfGSwaXGDP2ljGj99PXY036jwlGv7SNlAvjQFFTQ6YDbM2Evngo0Hmh+PhKu/G0vrvV8oz8OSsW3wfRwiin5noOrurfLPY3AXbO3hfTcx7w8Au+gdLHoDVoPhwmDpzYSBVkbvczwA/7bby+aF0Tkuc040awle5nnrLmhmLL7iCJdlDTO17Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5046.namprd15.prod.outlook.com (2603:10b6:806:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 04:19:05 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%6]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 04:19:05 +0000
Date:   Thu, 16 Sep 2021 21:19:03 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Message-ID: <20210917041903.yuepvbvajtheuvct@kafai-mbp.dhcp.thefacebook.com>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <CAM_iQpUjJ+goqoFX+vPUXbcvt3oDga2UgA-MKMXJh9iYY8j_6g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM_iQpUjJ+goqoFX+vPUXbcvt3oDga2UgA-MKMXJh9iYY8j_6g@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b667) by SJ0PR05CA0118.namprd05.prod.outlook.com (2603:10b6:a03:334::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Fri, 17 Sep 2021 04:19:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4c41c72-dc80-4697-4930-08d97992491b
X-MS-TrafficTypeDiagnostic: SA1PR15MB5046:
X-Microsoft-Antispam-PRVS: <SA1PR15MB5046FCBA3B2E98835ED45CF1D5DD9@SA1PR15MB5046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NjTCuaagmH0zGMo2yZBsLg8+R2CLnjk7OEV3EJH5WATsJ/OstUsKNEhXjFXn4biqq9EJo9cjfWTzxfklblRcjJqGJo4gTAERbbchIROBg8B1RQPFo2eJKt00hsZAlIuXq0uyBbx39hI3oGoQWMcYYQjSPdC6SptJGTi8Net+HzxE08pSBo75sGCvkuB90wwKurgOog1LOO1Nl5XXkJznhIFPRI+ryNy2WuDKne6fyvepNRow7cg/6y7GRRJ7Kszfhkw7ZWfSz2h70OmWFcd4z0HhdRNezJYRVCEVlJElLxiDi8raXrOCehCDb1tZBfYTvOjouyE3ACsFRg5tL11a4xsSHqWLtoVuvK18hSO1uPjHmX5mRPJwQPDjWfJiMbOahb6QM9HlU5yyMw8xL8kg5Dm181/H3ONx7rDTqGuGAdtTgvov1+Dwzeg0J/yatQDz3R6aNbLy1R75jeCWuVkjRxa1MCDYBeoSt24so/ae5xlB23j+veEdjRWmJTaR8p1W+SErRGOgvWVFkJtjUM0b2E91/MEXGIZWH9BpT1TXH+iwSY3tjMFTv7Bhr55GgT7eiJY6zsY9jJUvbRmY0vp7gAqcY0sgKRPmtUuaHmOqfbvsMrEY5qBRg4QqTPDtGQDFK3Gm49KUPOOawzkRG7vRDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(7696005)(66946007)(66556008)(1076003)(66476007)(8676002)(38100700002)(52116002)(53546011)(6506007)(86362001)(9686003)(5660300002)(186003)(55016002)(4326008)(508600001)(3716004)(6916009)(316002)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/mlX+ZXt3kfLL4i46T2BiqVrwUiY1vwyiuZ/lR2Xz+p15kOohdoNJ9a8CTV?=
 =?us-ascii?Q?/ExCQCKK6Qp4Khm5jNkWmQxv5iQhrY5ufvdGZAT765/hKawfZk5QfGVnOfHx?=
 =?us-ascii?Q?OgGOFa8mW0z+C2zKbb+AzVWgpnmBQf7zfInALId1jKGYNAPtU6cRFUA6wTDr?=
 =?us-ascii?Q?r+O94TWpk3fVIX57oOS4JB7qtsyXMeblmBTcQABCXu3UysNNzxgFA8p8RtBc?=
 =?us-ascii?Q?x8pldy0odYnObhYWQ/E6S7hO6hhqeRG8+bpPHODd6IvpVEjZZvhAGGPB+/lZ?=
 =?us-ascii?Q?as+W+yWb7m2pS3mkHSthDVVapVaIpbr8gHUkT+ha8s/kiVJt+RdeUw1Bd0dU?=
 =?us-ascii?Q?zZ/x49vA7qbOZUeKjfy2wxu7ysYleO/VWatT10zFEhrFTh8wQWqoSjG5Fk+o?=
 =?us-ascii?Q?N5lYpumV91Nve1WUAKSKVmOGgbuEeRuI1+4XIlllgaBMq2hMQwyOKQckukv5?=
 =?us-ascii?Q?8HSfoMkqaLsH9FovVCYQT6CfDQSk1TDiCiz5xvZXcr1EOVsAq70wtHQq1CpX?=
 =?us-ascii?Q?s4SuWbbIwdlIkZ06t2WxNN0iFLEfxUWzYdR5hacPNynJJvTCShsZykC0Wm2E?=
 =?us-ascii?Q?G/61TeytVF0/8/Z5V+PiLCyjbH6VTOvLK0afu9EiV77p+GzXnQJ3Hh0fSBs6?=
 =?us-ascii?Q?upsLEGwA/Yshw5XgJz+m+AsZ7X4KcmS2UNpBGU8MefUM6poRaWfp6Zm19eXi?=
 =?us-ascii?Q?POTVxpM1jeuuatladktyaGnSXLEQGFVBGjGGYolhLmRHGfOGpX1pvX4Hh0vo?=
 =?us-ascii?Q?arn7A3fxs9relzfIRSELp3sRk23HLmTS4HhahlxzUxdXtc0nOci1h2oFBIq7?=
 =?us-ascii?Q?Rc1xBAIwi8L3eCQrgV6dwN2GrQH7SL4IeKIIuyHQf+b0bR7CkqWTiGf/LQiH?=
 =?us-ascii?Q?7j7ZAc8sV/g1OufqMpSNr+6JYymAu+VfZJINgrYkfSyvO4bHF1tA1xsEYOIB?=
 =?us-ascii?Q?fYbpx4N4isiO6tt+dDvoY6vYc+o9iTcF6wH7OjBCHS95UI2WB47zmnmZ9Jf+?=
 =?us-ascii?Q?0S5IgbQrNIjLXtFqftJHHue8AN6YDj6Ad+9Wsu/RgTSMprsVfAgq923wcrUp?=
 =?us-ascii?Q?dUpvVia0u0h7WsnEitzHa1kHLkXhxTk9MWk2KkxZh0rqXCLx9xzTr9TAHUPY?=
 =?us-ascii?Q?K+Gt8+47Q6PxiPKvRLi6mnAX0K9nL0K4zzwv5Q32k700UR7KV3mUUH6xgMiK?=
 =?us-ascii?Q?AfkTC2vyt5kBtx9sUOF2elqOUxyVmACaywhTgNSpkKkx7oH796nvzsKvyGOa?=
 =?us-ascii?Q?2vG8PQkOOxQd28JTIUXTYwcQyYWmx0VNH2J5kSqHy0FUH/sZhpJitvU+Y2SS?=
 =?us-ascii?Q?p9ltiVYaXvWxey1yvN09NATMKaZMs1rZBQ0n0T1WE78sRA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c41c72-dc80-4697-4930-08d97992491b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 04:19:05.0049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rP7wClAfQcSdbfNI/d2i0Nrd7kfxl1Ah5qlGZWFRGTFfCcs+b76aQA/oWYkaNW5h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5046
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: X1ql_17z8WQIg4e4_xp94tM47oNysPDg
X-Proofpoint-GUID: X1ql_17z8WQIg4e4_xp94tM47oNysPDg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_02,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 06:09:46PM -0700, Cong Wang wrote:
> On Wed, Sep 1, 2021 at 10:45 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > _if_ it is using as a qdisc object/interface,
> > the patch "looks" easier because it obscures some of the ops/interface
> > from the bpf user.  The user will eventually ask for more flexibility
> > and then an on-par interface as the kernel's qdisc.  If there are some
> > common 'ops', the common bpf code can be shared as a library in userspace
> > or there is also kfunc call to call into the kernel implementation.
> > For existing kernel qdisc author,  it will be easier to use the same
> > interface also.
> 
> Thanks for showing the advantages of a kernel module. And no, we
> are not writing kernel modules in eBPF.
The line is very blurry between a bpf_prog and kernel module,
especially with the advancement of bpf, btf, and CO-RE.

Both bpf_prog.o (struct_ops or not) and some_native_kern_mod.ko are attaching
to some kernel hooks to be called.  If writing bpf and attaching it to a hook
does not work for you, bpf does not fit your case.

> And kfunc call really sucks, it does not even guarantee a stable ABI, it
> is a serious mistake you made for eBPF.
Not ture.  It depends on what is allowed to be called by bpf.
Needless to say I cannot agree with the "sucks" description.

This kind of dismissive discussion is worse than unproductive
and not the best way to use the mailing list time.
