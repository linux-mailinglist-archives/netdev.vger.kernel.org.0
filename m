Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A134D56BD
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245465AbiCKAaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiCKAaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:30:17 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF4319DEB7;
        Thu, 10 Mar 2022 16:29:15 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22AIOaDU013535;
        Thu, 10 Mar 2022 16:28:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=ytlWhABGmf4o/VRGR1K+vR5TpqBsnGyGBc/zPG+zI5g=;
 b=GSJ5/qdAJ5YTy7n5qnqg1E64RhRStIBAH7RkWD/S6ZPrf7qUXxD92J5hRvx8rS5BkvQY
 ae0Uufr5O1OhpZX2N23RTAa4iXRmrZOoA7u2PqgLtmax/o63tWgQHagjXKSCGoF3pogY
 O64M3cvHCH6Ott6Kq+19rTHBwm5ZWcpHrNE= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eqpk72jes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 16:28:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARks7K7ABLQp+5/EVStu73dNTHQRty/Oez0/CJV8MNpQEvQyHCFJrD6L6bM9Er01Msd1kvh888VAW28Z7gC/0vkModAqAnrQiaEdFR9D/G6MX6fdDCqYtqg7pv+V6b4Ao3dQUKcMNoNuXpGJFecIDLX7oekdW+FjTTrnQfKJN4cb8boPlmLEhRSa5yg8tuqIi0lcSfkkW5Cjd7NyDPGZNJ0AtzZ5PJHETVbvPxV0E2wEJfhy6DFlu4EFsCsPjk7hVZDFRRIgzEKoJPOAScThFiT8bE7lbgkCg3S84I5ID7Ye4dge59+oMYMwk9J4AW5Dft+Qc9t0h983o3HMe6q9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sU1lOCFTRsgYeTCE87wEmB+x8iNW1nf/t4q9zfe/ZxU=;
 b=m5YVEV3p67l5PTFYUhYmGiu8mr2u8HRvOBhfjJnCi+z4QxL2T1Zfxw3lg91hx2lcpZrVA20lro61xP3AAi2tcNVHq8ic9v4FHSL+bOMTEl/tFMBcl+w+e+mCfhAWsLA5X9u3nkLpQEdZgk2OGgrEA7Coq+PAoxl8cJIumJmXO1y/fQPN5bG98EmMf6njmpmlsofI8Ez4rcUZgq8FLxxDOMjKAgspmdWP+1K9HzAuwz9PtpRYoHZqPO9h+ME51kkaUCfuh2t7nSJj6tc5MJ/t75gpK4kdEFuFgvvSzfHniy+QCVBiiWPlIFXSDXvsFMrJIZQORolQ5jGFBuHkViamLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW3PR15MB3961.namprd15.prod.outlook.com (2603:10b6:303:44::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 00:28:56 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 00:28:56 +0000
Date:   Thu, 10 Mar 2022 16:28:52 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add a test for maximum
 packet size in xdp_do_redirect
Message-ID: <20220311002852.f3wwvjofo3ici6pc@kafai-mbp.dhcp.thefacebook.com>
References: <20220310225621.53374-1-toke@redhat.com>
 <20220310225621.53374-2-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220310225621.53374-2-toke@redhat.com>
X-ClientProxiedBy: CO2PR07CA0060.namprd07.prod.outlook.com (2603:10b6:100::28)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 415c2a66-f3e6-4d66-418c-08da02f620d6
X-MS-TrafficTypeDiagnostic: MW3PR15MB3961:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB3961920B184DB81AA0EA075ED50C9@MW3PR15MB3961.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xTNWzuVk6mFoJ/0oZps5BQA13uwyFPoqYoCKQ89dM5ygUiFNII0VbhNN6+N/neLYs0iEi9HOkIwfKjm+p4cyGhtQOzcuDT7HU2xWAtPVBsiyTp7diVbSdAUk3PsGpumQEeBcohCCaoeGObnf69HbuvfTT2s7HLEm97P9aYbBC4L3kDuCvPb8TlUFfI2lQxC52stxb/KI68Is/YHonIop5+QF5cHi3XuxeJA1TIyfdQGmDt0qnxvANuoRg5atb/ms2sGrnRGe4uO39QelZR7n/fYKCQK65ts70VacYyQJa8fBKoPpGbj1OGguBo/BnTgSwxQf5PaRBX+5g9s0QM9vKGtFF1aX4K5caR4ejUAr6bHkeIGSknALPJNlovqN2JAxgz7ps1XrVmSflCnI0qMqySPh0f7JA2dyFMKKU6yXSGHjtNbw5NjgKuNsbr/UgeLMb48GKowhAYx83NQd3VSLd8sUcsUsAGckbfEFGIm/JQs4x2DLXZdrvau886qF5YPF5+Cn2HVoF9JTcNOGPlFII0EIwLVeh1+5AcvygVwdw8QVlo/5SuRKUBGMUoeAsphJX3xq4XfLxQxZqLDFx8qMiDYqsvdS75rpX/3ksDDtiQjphOVT8G6JalP0yEGoL7gweAEJvzuaGXRsdXUhbTgjEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(8936002)(86362001)(5660300002)(6486002)(9686003)(6512007)(186003)(1076003)(6666004)(7416002)(4744005)(2906002)(6506007)(52116002)(66556008)(66946007)(66476007)(4326008)(8676002)(316002)(54906003)(6916009)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1GV09bLr6LHDBs/FXf8lcasHcSC6hHLMOrzhQ9o8VnTrfdgNCwbiSRcSqg?=
 =?iso-8859-1?Q?/aV+hLlGLfAtxJzQoekmxJVA28L4HXOWZsNtK8J5Rzo+pw0sVV4e8zZVKM?=
 =?iso-8859-1?Q?4UwZaeIwNTjQmXOtdSQUJWjmm6qOMomQN+51cEHmZUqUjvdlE3MACsbh+8?=
 =?iso-8859-1?Q?/MR4KjwwjaMMJ5396zsk2NtSY+Zc9JtNIR/BpyKjSVi6z1IyIULkv8C6F/?=
 =?iso-8859-1?Q?UKXB6NQBdmAECTk5ZphbhT4m8t/DSDUK1ETR7MlDMN3CZ+PRbp2q981rRE?=
 =?iso-8859-1?Q?8XvZzvGNpIdkJ5UMctCyOd0Tk+8mldyo7/GsYgPN+0/F5lwerYbM9f94rn?=
 =?iso-8859-1?Q?Ku5wymyznO1WYyH35NKTHKhhixhyT05menP2IVbkbAviDGzzYHcSmXK+6D?=
 =?iso-8859-1?Q?iJdEnqnsWsiSNH1j/pa/n+qaodXiGdLpMHuIXmZjDvEVFWLwEhGJS/LIOh?=
 =?iso-8859-1?Q?D0FDzzn9htul8/IHZj+mYe+Elvs4NkMF41VDYLOmRSt7YuHj8LsqoCbD4G?=
 =?iso-8859-1?Q?p0cddRR7EBI1OUWxW1mTyR+5M+ktwGqua9RwySeUzku9sb65VyTjaJJ117?=
 =?iso-8859-1?Q?Zh6/vkhJez6Wl38Mqc1iXVoEeWZIrcgcpaLDUZJ16Hm66AEHKEnREF+g5e?=
 =?iso-8859-1?Q?n0bgeCzm9j6eJIsiEG1b+fFl23ooxvMb734lxy8ShCW0NklUAGfhsLIgP6?=
 =?iso-8859-1?Q?pOjUHhkuEWoJ5E1hFqkkh2Ox85lQp+rUPFVXhJnQTgeQ72ADxexWrxjv8n?=
 =?iso-8859-1?Q?5L7JJQU0x+UlPelSWar0d/jtL1+TNqr14BrLUz8hq85m2na8WFFbMJf2Sj?=
 =?iso-8859-1?Q?pVDW3EWzbgWhu29/Oc/eeVHp474U9dOQKquU46jkD79dkD1U7o6insWdCW?=
 =?iso-8859-1?Q?ZOkuR9csbrxoXL2n8OQ2YRoAukWgNyiQoZlqtTYvAPtbh/2nYRAK99ydyZ?=
 =?iso-8859-1?Q?1yRB638/VBuYomVQsg1bOnx0PjFEq5SiMjtRTHXypAeuqMfMv3VKTLbFRy?=
 =?iso-8859-1?Q?rciu8iL4l1M2YgI81oJATHYZKNYahdRHRGvXjX4KePPOsFxsd3FkGCFp0o?=
 =?iso-8859-1?Q?tVp4yEGkX6LBUgLakyaSeph3kSQ844VfqZBtSTcfsl6FYEQ6GplrDwMcUz?=
 =?iso-8859-1?Q?5Kd1UH9cwYCxBNbrhcvup9sUmak9s8WnoUjoJF9z0wOilrDPJKlqv5JHn5?=
 =?iso-8859-1?Q?pbqdDsWyIYesYNhaPbxdvhseV+OeQEm3vN1ocP6ziYaOH4rj5co2eOrc+V?=
 =?iso-8859-1?Q?NPR0xWOxcNSb8je4lM++slWZ1Yv+UIT3KgpeXcI4nsQ5cIvhWlqepEd81f?=
 =?iso-8859-1?Q?/lXoRIXQ3GgCHHPvZYVCfbsF7uWHMJZuWcquZkSQSllL2bQzYQ6lNdY9zE?=
 =?iso-8859-1?Q?i+HJSkQhpoktOUcq9CF9OW651ErqcyqqxTDzpC7ilsB7L4bw4xPdPFnXWu?=
 =?iso-8859-1?Q?LcxmovnnMrS5R+tDrCAaFd2OKMtJLZkHzNcGsiUpY7U9Uqnvqp+wizsGOg?=
 =?iso-8859-1?Q?3wS/888GdseDSu2Q2TeYzolyIOj8QSyBiHcPLc0bpZMXFf58TU0QwhxgMg?=
 =?iso-8859-1?Q?W8IzXn5c+BmW0tOmvZ4HdLd8PS5Lx2su8/0RPOljNPn+s7yEi2tN7EqnFy?=
 =?iso-8859-1?Q?STCxaXWbt7DlhxMzA8nnLtzCqLrTvcOTxS/2KYxwvA9N3QXpViGkL/+Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415c2a66-f3e6-4d66-418c-08da02f620d6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 00:28:56.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LsmREDKSAo0Tb4H9lik6hB/8GyXLu53dqNL8xbqqcLvhf4aEllemoeCa9MXrE1wc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3961
X-Proofpoint-GUID: GARrWyQQhOGgOWvpWsxkD-D8T9a1X6ES
X-Proofpoint-ORIG-GUID: GARrWyQQhOGgOWvpWsxkD-D8T9a1X6ES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_09,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 11:56:21PM +0100, Toke Høiland-Jørgensen wrote:
> This adds an extra test to the xdp_do_redirect selftest for XDP live packet
> mode, which verifies that the maximum permissible packet size is accepted
> without any errors, and that a too big packet is correctly rejected.
Acked-by: Martin KaFai Lau <kafai@fb.com>
