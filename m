Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB5F5833EC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiG0UFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiG0UFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:05:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CA25A3E2;
        Wed, 27 Jul 2022 13:05:34 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RICq5B018772;
        Wed, 27 Jul 2022 13:05:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=mYCirhdMA9BbZ6zRfi0kVTT4tAUdN2vFI2fNlCx2C/M=;
 b=ai5sV5xd/DQlsd/gyKC7dVHf4Rj3F91L8MEbBjzUVyOmi4INRj3sVWpApHrqG0bNylXn
 d9S1R3egVMP05nznmHrSXa/Hy93Q2qljHGdFJUtgzR9hQAJKXiXJPccreqNlrY6ggjbJ
 wB7C7/6Q/IpR7FIvSX4k/Z3r5Agzb/NP3WE= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk3ck4kng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 13:05:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGrDgxlqK1SxWFiPWiU4iZnQEGpoxmypE5IEqFNH22fKycO9+WNJJL/wOMO55CcN2Rfhd4FiWrKoXgXVhTOMFDg1xYz9NlH2d1wjm2zEzj5hd4Bt+7uKRky/O1r2pXO6exI9NpUAWUy47wNTk6Z7QGxWE+/YAlT+YNtKiSoW+IsT85VCATujURLFBQ34AyfeSqR+sD6o129ODoRk4Y3iZ0HVXS0BJFocjiKALtPD5d6uDo1kpQFeiQPDwVlIxbhGqcVh2if4ZxspQ/fLxiQaoNs2cML/akmHawBRd63vUF6aNFembfrELsZgDkNF/3EKMf047BudyieLe2t4lDdiQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYCirhdMA9BbZ6zRfi0kVTT4tAUdN2vFI2fNlCx2C/M=;
 b=Dht4qsOAfiYC7cVENvGSeNlJtKRR4Mx63d4L2fwrV7GGxRz/6QswtcD2g16qH7b5uLJClUkK4+wXosVZgKuwsPHfMZ1EVz4QWQBqG1H3xhGr/+v5hbrdiHqfqBMU1CtvUzM/5/sgKfICE/6Oo3S+ZjLtKlw5Wr3cMvQWvALCmfvIsck63VnWkZ1HZcrHsvdXP+pFS41yrA3f4icS0QO2ha9f+7E1ZZW+sAWK3PHlTPFxljF8XxXmQ4Rd5rwdMinQXDijd9n+G1Ck8B3xAPgaVXOyvH3Gwg/03kd+aV4Kbyic70MXSXeAADjjkQpQDwCiBS6ZtjVVxv6S0Fokb3ZJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB3097.namprd15.prod.outlook.com (2603:10b6:5:13d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 20:05:07 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 20:05:07 +0000
Date:   Wed, 27 Jul 2022 13:05:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220727200505.nzt7bxuc7yckjdcj@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060909.2371812-1-kafai@fb.com>
 <381439a429b54e8e8dda848e1d3d306f@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <381439a429b54e8e8dda848e1d3d306f@AcuMS.aculab.com>
X-ClientProxiedBy: SJ0PR03CA0344.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::19) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7990a40-dbff-4d2f-14a8-08da700b4d63
X-MS-TrafficTypeDiagnostic: DM6PR15MB3097:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RxWBEje1PwvDA5pH3FmFbl/Q5JN9Ik7PqqohlbEW+9Wr20Q/7WVlFoTBOBzHU/tvbITJUX7Rvf7YenhkBye62dCVmIARzY0X8Fzr82XTLhSxxw9eGxkzofT2tEyivdGqEHCtQMQvXzON5+wSx+y1aBnOxaHLy0heQSY69WD49aat7YAJLePF1oBTxYqOxWNmECZdZMx9Y0deNIxfY8okJL/MjO3lRMi4qktVo+cnPVdRbTxvCVC7iRR4MOKe73hJXPLJeK40xjabWuu1NuaWHGNCGPNnBtjzzx1ki/qln7CXkr/5vLMuv8oSv7ZUB8yU83Gmupvhs9lJ0Y8LYXk+qOCuEpPbUNYlFSWi1XNsWJzUJ3oIpVe2mxqxT0jdNwCqvn6kAWZ0Lk2MZw431jCIOWZcfNGOzNsxzCzkAAbvjIvNFqzC4BlkWTWcjP+o8n+7j1Ol9hfq3BOaoo7G5IQCz2scBREigYDRFutgrbg71848P8v5NOVr+arCJYim8OKw6UJhVaPDMU3sGwq4SFu2yYe3Eb5hvbJQ0wCwC6ZIka7vKuMZvx3MBleVnqj1yCOJYc/xmGJKhZuGGogS9c7BUMXRKTcl8daamGgk2zTRf57MFZCCG+hldJUGDo7tdyOImcsyKElUXzXSpbtO3QRa8UO4wFj2P+W9TEy0b/BMcke4DLHZKcwS752t4Umna++8DaSFoLy5d17ycgMj+lRXdxjFC95YbRlDtvbqSC0tHNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(186003)(1076003)(66476007)(8676002)(66556008)(52116002)(83380400001)(66946007)(6486002)(2906002)(41300700001)(6916009)(6506007)(54906003)(4326008)(6512007)(9686003)(5660300002)(478600001)(38100700002)(4744005)(7416002)(86362001)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pvoz/7a9i7o4EAOIHuDrn843JPeaETdeFxP9vezMkTFG15AHe0MrxKWjHAgy?=
 =?us-ascii?Q?G5ARB5qCxqU/8hfnOqHWzMJRNy1UReC4dSiEpJ3VItaW8wesBILOFkhDIiMj?=
 =?us-ascii?Q?M0q/e8Esl9M7MP4wM9h0yKCicXg63rCT1djMrnkfJG1y+BTwwoX5M8EmtnUo?=
 =?us-ascii?Q?vged0LjFpVNHqdCCz4mQdV3JSswtnrfZic3FKm9ik85T8Y1YTbISz8JGyOjl?=
 =?us-ascii?Q?4ck7aj5x/+CJcjaTaqMP5MQPGjL6DJjG2XeCd1iqdknCJNstCZbba/0Jm7Kw?=
 =?us-ascii?Q?UzZcxutkAy0rCsUIsfta38SgnOY578js/jRgqUszPgBY8Js/bK2vCpTI+9oW?=
 =?us-ascii?Q?k3+0VKc5y9uhRr+tadS4wa5W+5pHA67j7BcY9olrvDOwrejsz95GgQkUAvru?=
 =?us-ascii?Q?677W/e+/Pb5o3+ggOEEVfFHGBd0RqhtUas6rX5csT/wCXn5eK1QdTUSQ91Co?=
 =?us-ascii?Q?g6Dhfi3fIG3/znxvW3BIQ1lJCN1b+/0e8HEBcYYVo2eaOB482WWKo8LIGYVs?=
 =?us-ascii?Q?KwbgA2Ch2v0tC/8pqlVyhQ219MNXg+qkN9P7sJuk/Jn6R4VsBgGUFH0Xg/Sy?=
 =?us-ascii?Q?mj9rzEV61xsKlUOgDyaFF16WRDHkuEf+1nWmAmTOFRrIaOtCCN2NdWCyHkfY?=
 =?us-ascii?Q?E7CLUnzDsLPO+VMz/nl2FYpp5JU3GVPVlZYZU8wHwjxV7EG8IWcWYOpUZvMU?=
 =?us-ascii?Q?9N/MoZKG6P4N0+Rf3EklPHWyhPM0H0T2OiaycaC10tP1nyOxPORPgpsKT41P?=
 =?us-ascii?Q?n5U5foRFYUJCi/cOT0ANlsyhXhhdVF1QqInQM6iVaRDmYgkLL0mGTjux79by?=
 =?us-ascii?Q?ygveFwJTf3GpM3RmTAoXR/G7KjoOG9eJ23Pk0OqNoypo1B71dvZUoTxeWlJs?=
 =?us-ascii?Q?6MVkBBdtkhBv4CPxbxtFpw6ac9EMsjRBbKjHBrg+BoOBYQnfbrWxivUIMWLv?=
 =?us-ascii?Q?5brfH3LugiHrIUWyH5VmeZgjRJzAw1Unj6AxjNwBZfI6Z342bJ+J63RIru0u?=
 =?us-ascii?Q?lx+9rw7+BC0oDbzW47lgCwJptLiWVezLnmPYUTHygeMlpyquXoSrusMNSU31?=
 =?us-ascii?Q?tu/62OXCM9Dy8QVodfQ6XBgiMUbVu96mz+AZMjUzALLrpttMsU9BQB3VT2tX?=
 =?us-ascii?Q?NrBGojCZUPJtTfvJNyZZA7x5CyG+63pI8ToTmx/et5f/8OmBWT3B5WPCz4E3?=
 =?us-ascii?Q?zzL851aaU6kyhuI60oWNaTTwyLjswrrQROTiU49qvsRgAQOgdFOTM2dsphvh?=
 =?us-ascii?Q?kf12aXTHmQTw3g1+7+CdTnpRqZCTCQKXiCfn+mqeERyw+whAoaXkcctHRoET?=
 =?us-ascii?Q?9Rp5nXe+fONZjIyB2UnFEr5hS+L4OfSTm++VMpVAFywNHtXum5xw9bN9LnnM?=
 =?us-ascii?Q?hi91EfEtWBxVDs76pj9LOacngOjiCUUEqzogHNPenZ57S1sjGv71ymmCM63S?=
 =?us-ascii?Q?bGEMwgBaRwWYA1k7yTFP5nZFIkGTFkZHQK14hkCSDRjv7qqS76VgBM/sk5fz?=
 =?us-ascii?Q?rxpf/giYbMgpAXM1Fj6pFNmTkbTM504ouqNCGxvMqWABlq59D99WpqLydcqo?=
 =?us-ascii?Q?nVh4MAGPBy7zm7ze6N4k6eBFMUTa2MPo8bt50CE+CdnbBwrv8wshirRGN+wg?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7990a40-dbff-4d2f-14a8-08da700b4d63
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 20:05:07.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SiaCDldT35KgZ2xZTDoF3gFvLjgXwpjQk3le+mqdw3TY8nzcGb38imIB4D+jibKv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3097
X-Proofpoint-ORIG-GUID: ZUtzZleaQJ9eDG_Q8YEEF2TU7K2Tk-Rh
X-Proofpoint-GUID: ZUtzZleaQJ9eDG_Q8YEEF2TU7K2Tk-Rh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:36:18AM +0000, David Laight wrote:
> From: Martin KaFai Lau
> > Sent: 27 July 2022 07:09
> > 
> > Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> > the sock_setsockopt().  The number of supported options are
> > increasing ever and so as the duplicated codes.
> > 
> > One issue in reusing sock_setsockopt() is that the bpf prog
> > has already acquired the sk lock.  sockptr_t is useful to handle this.
> > sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> > memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> > has already been ensured by the bpf prog.
> 
> That is a really horrid place to hide an 'is locked' bit.
> 
> You'd be better off splitting sock_setsockopt() to add a function
> that is called with sk_lock held and the value read.
> That would also save the churn of all the callers.
There is no churn to the callers after this patch, so quite
the opposite.
