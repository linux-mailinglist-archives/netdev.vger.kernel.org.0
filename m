Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2FE40676B
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhIJG4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:56:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53982 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231223AbhIJG4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:56:53 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18A6svpK027003;
        Thu, 9 Sep 2021 23:55:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=4alyeq5y6iX5fmLuzvmqZ1cdbDykScKeFA43YCDHJro=;
 b=kiolNmJPlnwrp3Rv5faZsISjp76q+W1PjjdWX63zIDxqwo3wcVetCTqlj0Qs+3XEEQd9
 FRcMdFS0ugoiuHaHLDvjjNYNiqAlyDJ0l1/osjhK+Lkwqs3DEeZjbubV91Cd1GRqQMj3
 TA5DvG6Vd4JgzCJBVGd+BXofZXfVfJqU8so= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3aytfxu354-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Sep 2021 23:55:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 9 Sep 2021 23:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1ScnhWt/t4JOmiFkFGe7x67KUC9lcY/6+5t3GxQMcgH+khRqw29XwYYwk4BK+bybaf59/yhBgF+p6xXHg9cLAxmUghyUixOQSI5ThzbbKw2sxJVhWfOSTZxQnH3XFXRcJ2cQ8sIxZ73r/yuUZo9M+N0ucAwhYO9fX5esZNYXiMxHBJfkqXi7fgfsAI1JjZGpa7Z1VDl10xK3+c+ADU5HmdLUmE+20u5XprcVEc2WMjhf+Hjwl2Gk6uve1yIZ2EpRJJO4c3AhhRWFn5BX0w3z1p3i6FdWrhobcDay+5iQCjH1WcUf/YbJxnNNvR1yzZSHpUfzro3OWfziEJ08/QaoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+1aYR+EsRzeL1XCV/PU1nfRW0esIvta5cE4NZ/MI4q4=;
 b=Yqi5i/e4KOP+LzQGjwnwy+XhDlsvCeh7VtodVXg+5l9f/VBDf1Y8EhK0X5+WvDWGapYIPb4+taRAWMZXhjKmwfn+11OQdbNhoFPicS6fG88m+Jp/c7yAEEAHw1kriG7cWIbeBEDktb8BpYVHy31lWPSAEYm1LGMwSkh8PEjqvhyheNbh2Z4wRf5dEdnZva2dqmoA0KBhmf8IoOpbnZuYrziZ0uWIHotJp/cMTFmedDdrW5H5I0TPIbCzUW5uhMhQcgJ0ZVhyezp46NdnlYcmtLGTC0QkYpr7VCQRKBiE6W6E8wxRsANWPMQbKS92DCPIPu8Pv1A/nQVZMFQsjBRgWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4323.namprd15.prod.outlook.com (2603:10b6:806:1ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 06:55:38 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36%8]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 06:55:38 +0000
Date:   Thu, 9 Sep 2021 23:55:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Message-ID: <20210910065535.vtwafxy2a7boipqg@kafai-mbp.dhcp.thefacebook.com>
References: <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk>
 <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
 <87bl5asjdj.fsf@toke.dk>
 <20210902233510.gnimg2krwwkzv4f2@kafai-mbp.dhcp.thefacebook.com>
 <87zgstra6j.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgstra6j.fsf@toke.dk>
X-ClientProxiedBy: MWHPR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:300:13d::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:28fd) by MWHPR20CA0012.namprd20.prod.outlook.com (2603:10b6:300:13d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 06:55:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f886fc-f7bf-4e83-edb4-08d97427fee2
X-MS-TrafficTypeDiagnostic: SA1PR15MB4323:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4323CD759CDE024C1B47AC3FD5D69@SA1PR15MB4323.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzjTz/oRwSwsDM1pxDzi7YIB/RiIdN346X0ZKZj1k4TujDGFPoRXZQ1MFFpEDbULLShHHWwxhmfQT2w0u1zKBPJKPL+dx7tBguFUBkcFcgwSC4UkaacK8ieAjxvLE5g/Y9FLg9/tMkqX9OdLmhhcGdhsKbIDyjT2MNIWm5Xrfwzq+p4hDaFOdHrFD9W7+PWgLZFNxZHMxrfv6hXufPbTSk3Vs1HjdnZ/lxP+x+auGb/LoP4ti+WUI09QlWOnNFeQ4gFFfgQODUEb0xZcHBPrqrOpoD3GlSV03P8hWAaVfJtl6/b7+UjTr9XvON0dVtH760jyCueSNWeASsKX6zQH+5PB4d5g1ELryRwMJUk03vhRDTtAztOk//KPyUPfmq/wRgd12delkYZmqVTcZSE9UlRMzj9Upjxwkjdrg07t1tBmcfESdw+LDaB48PGgmUNIXtMDvclOuMhTo4kZ7BK05VQuPgNx2pySq/TWYz8FZbg5UG7aSql1eUOA2do5ibC8YJ71jOFz291i2FHQ9avZwRO0nKqGqS/+4JNz/BdJjB+kbNNLDgNFRv8hGOJARjB56SN47SROcSGNBgcpVWKh0IjzCR3HrVdyma2W0lS1ihnk0fc2Cn0EZtD0liW4I4BrAhr//A8Sazs4uf5WK8QXAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(2906002)(83380400001)(7696005)(66476007)(5660300002)(6506007)(52116002)(8936002)(66556008)(9686003)(6916009)(8676002)(316002)(38100700002)(86362001)(4326008)(55016002)(1076003)(186003)(54906003)(66946007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LObRl3cDnbjwbkPeK1FsbpnXXyPbpjihzXNhP1Amcmt1ZGU4L6GZUv9FCV?=
 =?iso-8859-1?Q?9TzIE1dwBEyus19hZ+mz/M2nEiSDLQGpTeE0e60/cQYG5O88OxD3UScu6F?=
 =?iso-8859-1?Q?5sYmP6Ru9nPWZl1Glc/7y+G7CHQVkp6XpXObla01QvKO/H/G6K7KK+ovF3?=
 =?iso-8859-1?Q?dr7X0HZkn90NDXTuuMJzSli/6SaFPLdLDIJVtPSKEZauUgEVnndLTRXykY?=
 =?iso-8859-1?Q?DwuBNmtlkljDfolqUziTHfhJn5r7uTec1l1tKQjPZKRwFq57vvJTPzUZyM?=
 =?iso-8859-1?Q?LEyql9CNHdnIQsnoive69s5kFSmbGS+FT72OCPjf8WEqzV1PYFQz53PA3F?=
 =?iso-8859-1?Q?o8a3AEzZ6xMXb6JkTUCXYprL4D4NoAzpMVqN7bYeany8jiRPe/Pd+kWf6b?=
 =?iso-8859-1?Q?XSecoMY3xpozsixN/JGd1Zpl0LoHNSTwCgr7bbXMUSp2pJatvN89Hs/f8I?=
 =?iso-8859-1?Q?sPQ/bM57Jc3P9RhYgnlB3tmj94gnoK+qU+NI2+KaMbNzXYCl4KRt6ckBbe?=
 =?iso-8859-1?Q?v0jYetU88dC1/7iwIEuZBwgmFq5kICyVMNab+GN06gV9IbmG0wWKvPW/fN?=
 =?iso-8859-1?Q?NpFOf64QGgnB4pYf7dCRN5LBSLPTC49fHYcfDBrT/x13+EqOGkjWpZDKtJ?=
 =?iso-8859-1?Q?l2lWW+0tbMM1dE/zCsOzVxNwyx0aAaLHAPpTunKCir+EHBDw9irvbw8JUT?=
 =?iso-8859-1?Q?jBOVU/Po9yobANHKxTHOdGSfi2skasoI8QLF/F99h80wa6Er5AZ/3x4Y6J?=
 =?iso-8859-1?Q?nSsBHymC9hQdSCB7ROIDetPYfRuOiaJmGgnpKSkd6kwjRy+YqVJMRyu4Y1?=
 =?iso-8859-1?Q?utTDA6/SAF2CEk1UEV+9ypQxy3icNly7emZfLRKNI4rzj5fhkCJRbuyPhT?=
 =?iso-8859-1?Q?M58MqfwO2K01dusYqo/N4IBzT9RLr3v5MlRgcbfe8jyDB6lzyPXVYF8sPw?=
 =?iso-8859-1?Q?/sdkwOEixZ8aXDDXyHjyj7JAsNf6CD1nF8Y/j9axz5wqeTxhD7VEsLawCP?=
 =?iso-8859-1?Q?NiUPQR2SQ5CEpvWIISCN8SW6Bcj5S5GZGPSX6zZyykOnGfA4DecjspyUNx?=
 =?iso-8859-1?Q?YQO0mOHtYeZFZw2sdYWjsKGbvn+B/+kBUd55WTB/OuuyoE78iSLTJUZUYY?=
 =?iso-8859-1?Q?z7WvuZCgAJ7hkguwqX4L9FMXc30sOa+RA9WlE6Acjwrhy68MpsrdQpUnK4?=
 =?iso-8859-1?Q?ixHDBiyMQRQ4WNtyeGhKn9MIobv42BoDW7iBvkMBEO51Onroyn1u0Q4Fqc?=
 =?iso-8859-1?Q?z/rgG+IaeGZGarqOksRDBX9mwpUMzexp7wX3J1grJFxZztF9uS0TV5wq2I?=
 =?iso-8859-1?Q?TWfqNEl8zTIs31CEuPqfhkAjIFDezfpZ3rwhC2Xv78KvAM5EYKSgal8Zs0?=
 =?iso-8859-1?Q?BwyCsXuBCvrf+vv97TBK4OHdKd5PE2hA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f886fc-f7bf-4e83-edb4-08d97427fee2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 06:55:38.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8r3nnYxrbuO4NYwhRyarqdHvSEn65wcl9YBmhgyw/wYdGXD+bW1ZKBeErLkLNiF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4323
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: KUu_PvAivm7XzJEz3tGuuIsH_4aQcDnW
X-Proofpoint-ORIG-GUID: KUu_PvAivm7XzJEz3tGuuIsH_4aQcDnW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-10_02:2021-09-09,2021-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 clxscore=1015 adultscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=756 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109100042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 04:44:04PM +0200, Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> 
> > On Fri, Sep 03, 2021 at 12:27:52AM +0200, Toke Høiland-Jørgensen wrote:
> >> >> The question is if it's useful to provide the full struct_ops for
> >> >> qdiscs? Having it would allow a BPF program to implement that interface
> >> >> towards userspace (things like statistics, classes etc), but the
> >> >> question is if anyone is going to bother with that given the wealth of
> >> >> BPF-specific introspection tools already available?
> > Instead of bpftool can only introspect bpf qdisc and the existing tc
> > can only introspect kernel qdisc,  it will be nice to have bpf
> > qdisc work as other qdisc and showing details together with others
> > in tc.  e.g. a bpf qdisc export its data/stats with its btf-id
> > to tc and have tc print it out in a generic way?
> 
> I'm not opposed to the idea, certainly. I just wonder if people who go
> to the trouble of writing a custom qdisc in BPF will feel it's worth it
> to do the extra work to make this available via a second API. We could
> certainly encourage it, and some things are easy (drop and pkt counters,
> etc), but other things (like class stats) will depend on the semantics
> of the qdisc being implemented, so will require extra work from the BPF
> qdisc developer...
Right, different qdisc has different stats, I think it is currently
stored in qdisc_priv()?  When a qdisc is created, a separate priv is
created together.

Yes, the bpf qdisc prog can store its stats to a bpf map, but then when the
same prog attached to different qdiscs, it has to create different stats maps?

Also, instead of ->enqueue() itself is a bpf prog,
having an ->enqueue() preparing a bpf ctx (zeroing, assigning...etc) and
then make another call to a bpf prog will all add some costs.

That said, I still think it needs a bpf skb map that can queue/dequeue
skb first.  Then it will become possible to prototype different interface
ideas.
