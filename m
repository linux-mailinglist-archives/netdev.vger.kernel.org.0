Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E241F57A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 21:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355485AbhJATL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 15:11:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14926 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229882AbhJATL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 15:11:26 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191GIXcd012345;
        Fri, 1 Oct 2021 12:09:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UdsPKAqx1xqYqBgI2fFtjc1qC/xP0WmlTaKfUKcb9/c=;
 b=eW3adoi+YEGGr0V89ZrXOwM9krrUtclGniZ+87kDGH7QLl33qrNOyOI/Dj65lMZP+9qX
 vO0vDZ5h3pYokNfty1jm4tg939hf+/FjtkZ/8DPJk5xvQbbob4/niGJ3/MDn8Hkazf2c
 gFL265oQn70dcqL5iaWhila5XqUOio+/148= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bdh9pgt7c-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 Oct 2021 12:09:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 12:09:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDlYRFSB1cyDg8476K2lv5fk/J+3YwMaKcAfC0AH1SEfyFwDCtYYyu1CzKHmi5duM7eA7FOcDiNy6vKSl5EqMImOT4tcAPDFZS+TDgpWrJWgoF0diIWeyd0HlEEUudAFrCoexXbMqRL2sxqc9/mJCY5UDxtyfD+50VIQ6hC696TFD3nSm2w4/nx1lnkwI2YEMAo3YuP/4VxlokLBffejmz3cOJSVbgTTloXkcDank35ytobgJrU0UJHW6sqVAYl5yCQzlfVQTGDE7YMHWbv3xUTXYLMjeaBzTMEQWKYRduEdTSJvrqhnPOOf5aPDBr3rc88HjIUJevzN2N/iluhOMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdsPKAqx1xqYqBgI2fFtjc1qC/xP0WmlTaKfUKcb9/c=;
 b=iuzx0w1CMsSMXd/jghl50b4goht66NhRaYPopeE2kn7eR4ZGyikjn8NgpThuwAASckO8z6fYv5Dqbj3O1qAVOG3LK4fUUimgUVmUWT23gsk1htxJsgOmFfgtxq12E0cdGGhfydD2RdwcYGlnwM+Q5gRjV6fS5VHJUPU7+vXumoIj4ngvtgU+NkRZj3tkNAFyQDZukw9AEZNjw6LYfRad2CrG4tEBAuI3TDewIbz7RYH7bK0Ld9LkYIIlbmTWXh5jLg2Q7Q+bo4Lb06SLMlGuH6GLNhQVA9CfZlWGgkXoAxeiekrQ3YoqB8XQTpqxUCsa86uDAZXZB/va8MDNoVq9JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2397.namprd15.prod.outlook.com (2603:10b6:805:1c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 19:09:04 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%6]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 19:09:04 +0000
Date:   Fri, 1 Oct 2021 12:09:02 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] bpf: do .test_run in dummy BPF STRUCT_OPS
Message-ID: <20211001190902.c5zmrxedytkcrc3l@kafai-mbp>
References: <20210928025228.88673-1-houtao1@huawei.com>
 <20210928025228.88673-4-houtao1@huawei.com>
 <20210929185541.cb5z2xnngqljkscu@kafai-mbp.dhcp.thefacebook.com>
 <89ce4b1c-6ea6-80b9-ec2f-5a6d49dd591b@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <89ce4b1c-6ea6-80b9-ec2f-5a6d49dd591b@huawei.com>
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp (2620:10d:c090:400::5:8bbf) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 19:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb8b4a38-495b-443b-107e-08d9850eef82
X-MS-TrafficTypeDiagnostic: SN6PR15MB2397:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2397E7DCF32EB1C4FA4A4E7CD5AB9@SN6PR15MB2397.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BIbCYFTA0mcBP5J3v1mzBnDxRbc/uwHmUG/MSZWHT7bDrqTwnNzidEd3eiOGtS4aihaHybrQ0jjwLi77V2fhrvS41RI78zbMsHtLvGzM8wFZYPNDspjSt137djAcwn43yJrOhRRqpqJaX0KTmoRtaUFO6XiKsWX5IrfxsUYKP4wsBfrTdKYMBgF8CiE5MUE//xJ6niufktdv9xq6zA4iRXXUQX8Sesv52RoF2qBflhvcoJ5uMa3bz8EjVhdsLV1fNkRxX2a7KjeAgO0/kX9hWBnlTjUCpC0P47tBAbdVSUn+z/f7AyeV1uvATrx+O2NSwVXGk3bdn8VYOYPd0Sy8hYezCHqaGrQJxjwrdIp9j9tbW37sbyo0J/qm73GPQXxDzfghHZNW+3mQYQCzy6XXM1F7rXasMHTFSZLy+SYnnwvyu96m1yX5RTYTruP95NKRYBw79p5yrgmCaSrdlfrP0vtFzv7rIabH35Rjy2gBfNkLkLVCYxt92M2kfClqpVvI1UDgQcsbg0WCiqGCIqwzS82UBGGE75CzSrVaNGNorNxSnY51yufUNl8rajxReeVT+5ZO/IO7N3QAY331tTfI/ysE2qM31P+GzmIOBzYteYffCMb3SUVMBCzymxP9LMU9LcaVo5jZR6SQ2y3EqgXhX1ywcY17StpfJ2/zJKbjvhhJYOK+hunQIT8RizIjhNrh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(508600001)(66476007)(66556008)(8936002)(1076003)(66946007)(6916009)(6496006)(55016002)(33716001)(8676002)(186003)(38100700002)(2906002)(86362001)(9686003)(316002)(4326008)(5660300002)(52116002)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9FkmoNedgAkPfotyTOxAKI0ouWPdWhjBC8Vh9Sxj8jQwLJsxek59TsPlDZvy?=
 =?us-ascii?Q?7hY1ahZj7y6yKMiOhf50KwJmVKMTu2geXoQWja1MC+HwFQBh/e2DRyQrb0M1?=
 =?us-ascii?Q?d1TOKydh1CWMwzsiJw5jn0p9c6H+OQsNek7Fz+65BaZejw4nEgAaSFl5a8Yq?=
 =?us-ascii?Q?KKOTx+hjAyzYsoTSryrkIZ2PGs/1I+rKsPpmKFyDSiACDhRn515SalH7HYrZ?=
 =?us-ascii?Q?XONLnumzP6f3Hq0Aaqm4ANlELytBClu1YgFHU11jt6X9bm16swdyjpgpJF+l?=
 =?us-ascii?Q?lpg2EATwGVT/L5hRaGNTHArHEkgHgkY2Kk75oZWma87Pritj3600TaKJSiSz?=
 =?us-ascii?Q?VqjdRnh9Xt9qONt7nVfqqhrj8YV5BaPfdNpIfN+3VbiKzvr+67tvzb4kzwIm?=
 =?us-ascii?Q?kY+9DoVGixVIPgVGDcmDUfVPVxiQ9o1iP4kawu5c+5Q54i43YNkW1qI2O48W?=
 =?us-ascii?Q?H6yznUMeX03XafNZUWa7U7vclE4t4TWpuBIY+RKyTx3DgQJKD8FN3p0UmC9d?=
 =?us-ascii?Q?XwA2L+ktLF8zTt+tM5CPpfsqbKzYWIzVgA/eAJGlqTPE2Fi+g8OLXhc7OCXK?=
 =?us-ascii?Q?AUHO4mcX4tppLSwbj7SfW5A3c4hjKa6ijWBP8VYhkexzHoZx6Du411VwNIlx?=
 =?us-ascii?Q?NFkyI9N7EUW4rOZ1Fl8xAWrSt9aPWI3iQyoiBFrzUXoEPNMqkmvfM0GMuQcN?=
 =?us-ascii?Q?qfUw+hIKBhHQYctbZpLoSPguIcsi+ESssdmxkSLhNxNVybPyT3koAAR4vl5w?=
 =?us-ascii?Q?lJ9eCpPgph6ec5d3K0L9tDkmbQ7ukV2eyQhyvxofXBVnKZwR6vma9Zauc3j9?=
 =?us-ascii?Q?vuAiRsOBXkbB2SVbfOYw4vx1edAraq1WUn2L3trWCt9Pfm+hfoPVPr62sOqY?=
 =?us-ascii?Q?cz/ivtrYh2V1/qz4YhlH3XijYMPUoshas8Vvn3PFD7LZXtC4ZQW2tdorptbE?=
 =?us-ascii?Q?KGJ4ms97BJJWQs6GmkP+2OKhD0MnZMN958pN/GTF5DI+AGobggFo0Etw/cY+?=
 =?us-ascii?Q?WG2wap/1lCXvau3pKC/27MJBUv56v2L7I7guLDXNI7hoFr7CS1xpAmSXvNKV?=
 =?us-ascii?Q?H8k+7XiO49YnQLAFg+05V37S7jdb8FGKKQPIgy1gE/fqRGiGKDk62/ekGgSr?=
 =?us-ascii?Q?LR12DWQQEDfZIkgZdR31a+R1zzZa5Ip2y7BspXB6l5AvAMK5DpSTfZqGVNO9?=
 =?us-ascii?Q?GZ4CrHvIXvT13chJzFjvuKiU3TIaU/XtRaRNy6Dddyc9xOicUd9Qcz8UM/5Z?=
 =?us-ascii?Q?2H4kwFGry+heOxgKFO8rFfVyYEsCG6c23E2ZiO4pw3uj40hINX8w4b84vXtW?=
 =?us-ascii?Q?8QiTUX53uOuObNCnX2RFvUZ4PPmEb0JLZwB5VETA9IAU2g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8b4a38-495b-443b-107e-08d9850eef82
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 19:09:04.5364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzBLAv4AjzDi79pIGuNBH9JR9hNFQVh2nMMtrrZcjCyfc7fqyIFV03mF1d4NP8JL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2397
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6Zbh1ccELcSnBCc12kINqh27udgq8VpH
X-Proofpoint-ORIG-GUID: 6Zbh1ccELcSnBCc12kINqh27udgq8VpH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_04,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 clxscore=1011 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 07:05:41PM +0800, Hou Tao wrote:
> >> diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
> >> index 1249e4bb4ccb..da77736cd093 100644
> >> --- a/net/bpf/bpf_dummy_struct_ops.c
> >> +++ b/net/bpf/bpf_dummy_struct_ops.c
> >> @@ -10,12 +10,188 @@
> >>  
> >>  extern struct bpf_struct_ops bpf_bpf_dummy_ops;
> >>  
> >> +static const struct btf_type *dummy_ops_state;
> >> +
> >> +static struct bpf_dummy_ops_state *
> >> +init_dummy_ops_state(const union bpf_attr *kattr)
> >> +{
> >> +	__u32 size_in;
> >> +	struct bpf_dummy_ops_state *state;
> >> +	void __user *data_in;
> >> +
> >> +	size_in = kattr->test.data_size_in;
> > These are the args for the test functions?  Using ctx_in/ctx_size_in
> > and ctx_out/ctx_size_out instead should be more consistent
> > with other bpf_prog_test_run* in test_run.c.
> Yes, there are args. I had think about using ctx_in/ctx_out, but I didn't
> because I thought the program which using ctx_in/ctx_out only has
> one argument (namely bpf_context *), but the bpf_dummy_ops::init
> may have multiple arguments. Anyway I will check it again and use
> ctx_in/ctx_out if possible.
got it.

ctx_in could have multiple args.
I was more thinking on the muliple arg test also. Potentially some of them
are just integers, e.g. 

int test2(struct bpf_dummy_ops_state *state, char a, short b, int c, long d)
{

}

All args can be put in ctx_in like bpf_prog_test_run_raw_tp().
Take a look at raw_tp_test_run.c.  Although it is not strictly
necessary to use u64 for all args in the struct_ops test
because the struct_ops test still wants to prepare the
trampoline to catch the return value issue...etc,  passing
an array of u64 args in ctx_in should make it easier to program
the userspace and optimizing the ctx_in based on the sizeof each
arg seems not gaining much as a test also.

For "struct bpf_dummy_ops_state *state", instead of making an
exception to pass ptr arg in data_in,  the user ptr can be directly
passed as a u64 stored in ctx_in also, then there is no need to use
data_in or data_size_in.  If it is needed, the userspace's
sizeof(struct bpf_dummy_ops_state) can be found from the
prog->aux->btf.
There is no need to use data_out/data_out_size also, just directly
copy it back to the same user ptr stored in ctx_in.
