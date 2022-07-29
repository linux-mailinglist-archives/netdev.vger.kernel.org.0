Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8D585574
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiG2TID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiG2THs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:07:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740268C3F4;
        Fri, 29 Jul 2022 12:06:32 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26THAJuj022751;
        Fri, 29 Jul 2022 12:06:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vbj9tt4w3iSQeu6sSYhcc8nWSZh1SJJSpzh7SrIgubg=;
 b=FL9+9r1i/HUAlxNnHEciLenwhx0CUM9aTfgaUBujQU/vZbgWsu7FoAtx83UNp/abMOan
 uC8wdQ3sOFTjI/oxcHzpk4cibKOXTy7muu57URmOG15I4eVSDa9qfJ2BDIYQ4h5XB3fy
 8ajNt+ff8JJnm31KoAwwDWpRdnG/gS52Duc= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hkst1at74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 12:06:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpgM7xTVF6FCdDAj7RUht8tCVF8Ce5Mt26iHiv9Cyp+/6jsXPj750llhWQ5HswsSWMK4Tm87ubrOmNisDZhBZkQCPqpkeqzdMEju/HifQ9zPaAdbu38sBatWj3KL9mfyB9bJa7jRybyQsFDGwusOyL3iK+IXLkhBlMoP9Uhlmnee5qev7QlLkELIAOOxASrnIZz8xsomm4hV1A3OQJjtJWIJBBrp9ioFKitV2d9lOZIxlnCglBgM71BgGA6hW09J5S17wyjQIeBvig4CWvDhT27JS8sC0hhGrX3f2S3K9lqcgg6b0qT2rIfal6rSUTm/4xarUG0ZUgZSTTOH40CS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbj9tt4w3iSQeu6sSYhcc8nWSZh1SJJSpzh7SrIgubg=;
 b=GFWCfHb7otz4XqzXeionsj0p5scXxHJ7RitYpGLCFhPheZz0HcWwXgepUK+IjZjXEdilxt08RgYBPi80tknobXxgFEgHoPTVkP1gtTTcY4/jtjGZXxRqgASux0bW+kH6C1sapImDs9RXAxJEIIlPpmb5t6RatGhiwMyCBsoPFZKOd7qMzpnKgvNV7EDQQYP2EwCxlTudiKwXDc5Ts1HzG2xPL5SsK0BbXDu39gKFitBrS/g4qDtW1lqpXApmdlsBDiFRipJVG7LYOqT94htjQGQC1HholgCFti8AMM9ezQ4tvvO/DDNSgOIdeo/tqcUbv42Gg0pWynU7ZEonsm8tBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB4140.namprd15.prod.outlook.com (2603:10b6:5:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Fri, 29 Jul
 2022 19:06:08 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 19:06:08 +0000
Date:   Fri, 29 Jul 2022 12:06:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Jakub Kicinski' <kuba@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Message-ID: <20220729190605.6fxlhdetyytv34zm@kafai-mbp.dhcp.thefacebook.com>
References: <YuFsHaTIu7dTzotG@google.com>
 <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
 <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
 <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
 <20220727184903.4d24a00a@kernel.org>
 <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
 <20220728095629.6109f78c@kernel.org>
 <732a8006394f49d58c586156f3f81281@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <732a8006394f49d58c586156f3f81281@AcuMS.aculab.com>
X-ClientProxiedBy: SJ0PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::34) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cdb3669-9bb0-435a-daa4-08da7195648d
X-MS-TrafficTypeDiagnostic: DM6PR15MB4140:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DAbRsrjOnFgsGKS4aU9OWQn7YtEDYLZAyVE0LnQz6vuGKVcGe8JiQvn/JlurSICTNktCA3FxK7kJYuq+Pn7mxki+4hwE/ZMWNreAC/qrwMifC1YrCzjKTjhR1sWISGfB1oqPw54fyLo3o8kFOoEpNcQFoZusq0CLM7ckbOIe6lyFc4JKiaGk/+ENyD5ftg+iit2JfhQ4XkTNkFguo5HA1h2Zt0Hi+xftCG90jZvNcilCBRF9wHzpV9zBYeiL5+Y2+ulmRSc6Exuv8Pc2aMMRwerYisJxW6YdoWCoVonmqmHmFGyv6NYMBAowi5hnw8PSkhnWVbjYAROxMbXE9FF5lCoGjTsB25h0oRik7KkzEYaLDVobJn8STCmasEEpG1kl5vs93MfaNrzzSKcJPl4VdHR3afg/hZ8lyIALJJRq5PUM0xxOEHyClDkQPa+U9Ojnb1qFsPeV9aDKOKyZrih4tex9rpep8yCy2jm1uC9QLw+wlDI2ulg5Ufw2E5RdDpoxSfqUtZzI1Bj+WuAXnb+jfy725Sa1l+P5onN+14Zb3IuD0BR94C7WUUoiqS7jayDZrEeG4QMUOLmnIqCWorz75PU9nfrAKbChtkEaOaq4Z/Wg+X/r+ganvfiSp7RU4aI4ON3pvtUo8NM/lvcStf2ZZFooh7oDaEeijDZ5NdqsoYXo5lNsJoD0+2byGULn6h49PcClNSkOxUug1645pHqlw8tWOE2IwFrcaxkYAAbfFtciDO9na39rbEfd8j1p3XkO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(316002)(54906003)(1076003)(7416002)(186003)(5660300002)(86362001)(6916009)(83380400001)(8936002)(478600001)(6666004)(2906002)(6486002)(66946007)(52116002)(41300700001)(8676002)(66556008)(4326008)(66476007)(6506007)(6512007)(9686003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t60Pqv+fZwJgZL6J28xXLknT4zisDVMU7yjGnpQHXn0GC01xftn9c22EEnYG?=
 =?us-ascii?Q?sBer+6XsCwCftFAg0+prqHX8acOP/b4EEF2SWMyqQssn+1A3EjO97aGiRg/G?=
 =?us-ascii?Q?bqA1/TmOk9ja3vp6oChNBLJSDF6rlFd/MMFDi1/Gvi4EGXnb8K+hxHk1JYm0?=
 =?us-ascii?Q?7pY7N7puQJeWogDGlQ8hqMQ9g4xmMUxfp3OgEjJSCldUuuQKrzxn5fJALzTt?=
 =?us-ascii?Q?YX2tqTY1KCpS7Me179TTtFzXw9h14ITtzBOEUhQpX5Og/HDQVaJR52EHdzdW?=
 =?us-ascii?Q?X8T55E2Lhe639nIi9Abt6xqLJCy7l/o/br+e369Kq4e47tXpKt5r9honZuNK?=
 =?us-ascii?Q?3+ucFylGNrI2zwUpXWi/0tnneyIhTiZ2d9ZJJxIcFYLKIwwW1O64Jk7t1psf?=
 =?us-ascii?Q?jUrkSSaxiTUj6uCl7W4Ujt5jh0QVsZiXxTDXd//x+thVqDf01iM1gmgbp/F5?=
 =?us-ascii?Q?4kIobquFibBvHPo45ePFHmuHA21gTvS2/KqGAAOSW+C75xPDYyf9fTKyY2lT?=
 =?us-ascii?Q?1CKsoNLBlRA25dGkiD6xWSMyvMHY3WgiVuKObBrnnGpdaPmNd6SbVZm2osZ6?=
 =?us-ascii?Q?0+CArkvm1blI3CL+O0aE9FGxw8ARuwx9uUgFTU/kz1FcpGy7Bi74IT/HP1Kz?=
 =?us-ascii?Q?QqhXRDyXXkCjMTTuZNJsKMaLvt8+viFvvzOdUcsSwxqKUydEdZ9txBfQZud4?=
 =?us-ascii?Q?iF6RN/fdAH795t2Ji4n1TMZ/WTuHVyy43wIXWxUS8uHQRdJrrNYA9Z4n8I/Z?=
 =?us-ascii?Q?QjPe/JGNXLot0lXOkWAZViUp2f1IaIUWolSDCIXctP/7GN72hWNapVPbbs1C?=
 =?us-ascii?Q?2tGNH/uk0924FpxcNmQxRV+bxiW9VBGifXRggtDntQvAdfNoFJBkwuUZh+cg?=
 =?us-ascii?Q?RrqmOtuIamfkfwFs4bbEdYHjYDRXwmuE3tF3I5L2JEgJM7sn18AN25YneB38?=
 =?us-ascii?Q?oNusRpSRONpsre+k6fLW7OY8kWlox4YaSz3SnaPnfRhK+CkG5qeQ5oCwRUjP?=
 =?us-ascii?Q?gFCvyLAXnxMhqwsn8Z31yB5kLYRJU9xW2aaHP4OpKVgIT5kptO0FnAFzQv/D?=
 =?us-ascii?Q?PkjVkGO0KNSeGsk5hvldGR0N1mY1qGRHYWVoojLQIyZ5Bu5QZOpaDtcJuskW?=
 =?us-ascii?Q?Ch7OEJiXVu1FxMA9f7adgNMhOKBbo5qw2r1+qLZ61uT1nuU6rmf9pC5rWHg1?=
 =?us-ascii?Q?qCSe8OID+zC+RThk3bTd/Tpj2TcxHVvXi2y7RiOnJBVm4HWYC3+BOHGBZqOJ?=
 =?us-ascii?Q?o1GuNcsQljgm5OC44wTeVTnbZo7ZDNg04mvd7GqVSIXrBH5crFQzN8zzXqUf?=
 =?us-ascii?Q?x/Z6+In7fsLG94IRPbj8SrOGu0fIcArDNIHYkLv5/YGorErvHd791FDraEmj?=
 =?us-ascii?Q?tCutHrJExPksNIyW1Q2jRrfKpvmg/wOfRXzSnpIffmdCmRlDtXMI954YfcPq?=
 =?us-ascii?Q?lbNYOJOH/xAAwtKK5hLE6pIM45apxPeTkI5zMvPQlVO2ywRm+N7uc0Up9TBt?=
 =?us-ascii?Q?bywMxjt+pHvm7jl5CHVytcyIHF7PqWzBkDQr3H61qj7Uob8jh+DN65wRbcav?=
 =?us-ascii?Q?gE0a6/atvlTT9tWXPY5lXodCF4y6uKoWFTl9it3A1y7dF/Yl9g4o57sZE9UT?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cdb3669-9bb0-435a-daa4-08da7195648d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:06:07.9773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +O1Q1QFjNW6Ar47Mb2jarThTRVyyfT0GHQOrnNLjvd52fO2G7F8rQbJ3HimegN4U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4140
X-Proofpoint-GUID: t8MRvavC_etmRvOnQrEh-oXOibVwRAx8
X-Proofpoint-ORIG-GUID: t8MRvavC_etmRvOnQrEh-oXOibVwRAx8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 10:04:29AM +0000, David Laight wrote:
> From: Jakub Kicinski
> > Sent: 28 July 2022 17:56
> > 
> > On Thu, 28 Jul 2022 09:31:04 -0700 Martin KaFai Lau wrote:
> > > If I understand the concern correctly, it may not be straight forward to
> > > grip the reason behind the testings at in_bpf() [ the in_task() and
> > > the current->bpf_ctx test ] ?  Yes, it is a valid point.
> > >
> > > The optval.is_bpf bit can be directly traced back to the bpf_setsockopt
> > > helper and should be easier to reason about.
> > 
> > I think we're saying the opposite thing. in_bpf() the context checking
> > function is fine. There is a clear parallel to in_task() and combined
> > with the capability check it should be pretty obvious what the code
> > is intending to achieve.
> > 
> > sockptr_t::in_bpf which randomly implies that the lock is already held
> > will be hard to understand for anyone not intimately familiar with the
> > BPF code. Naming that bit is_locked seems much clearer.
> > 
> > Which is what I believe Stan was proposing.
> 
> Or make sk_setsockopt() be called after the integer value
> has been read and with the lock held.
> 
> That saves any (horrid) conditional locking.
> 
> Also sockptr_t should probably have been a structure with separate
> user and kernel address fields.
> Putting the length in there would (probably) save code.
> 
> There then might be scope for pre-copying short user buffers
> into a kernel buffer while still allowing the requests that
> ignore the length copy directly from a user buffer.
Some optnames take its own lock.  e.g. some in do_tcp_setsockopt.
Those will need to be broken down to its own locked and unlocked functions.
Not only setsockopt, this applies to the future [g]etsockopt() refactoring also
where most optnames are not under one lock_sock() and each optname could take
the lock or release it in its own optname.  

imo, this is unnecessary code churn for long switching cases like
setsockopt without a clear benefit.  While the patch is not the first
conditional locking in the kernel, I would like to hear how others think
about doing this in a helper like lock_sock_sockopt() for set/getsockopt().

With in_bpf() helper suggested by Stan, the is_locked can be passed
as one additional argument instead.  Then there is no need to change
the sockptr_t and leave sockptr_t to contain the optval itself.
