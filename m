Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CE641F347
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhJARmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:42:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2738 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229632AbhJARmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:42:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191G7xk6017697;
        Fri, 1 Oct 2021 10:39:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1Ka9pos44HOTWyYsjAaF4AVP6F7ipz3z3PuVAD4gs+A=;
 b=TfTcWO4qRJuXOinXQMaCy4FvYSk3ZtmWSqBLGAgQS1rBhcW7/TYOuDLzWeJiRQBxrzui
 IYlh2v2Nk15n1SphZPLYqlCoKUaSeLg2uLlKEWu8KuCynChw+3jt/fcXn/kSRzz/Wzku
 eAsrLZldieVCh7B38HPzxzKrHKsxSb4aTzs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bdh9sra2e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 Oct 2021 10:39:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 10:39:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU0SAJgvsNKXHVdzkSxA05+Eb8OtJE2xEOtibei00NmDN4tg4kEi8UNUQj2K0M7XMIwxqZhKsEVcEnl3XeJNVaXMHoLSnzfYYU8WZ48MqXu9a1IBHPg+30ufq92ZPZQqFUykdBrlcDul2M3YIo2J/9DrQtf/mQWXsXIst+ljusFAeD78t0M8Ee7FPk70HIDt1RqMPmSIKbl+XsBhue9Y4kELy+Twsl0C9MUCCm9Rktn/Eg36ySBTskOLnDUSvbVue6MLUko98+5y9EVkFRn9RfCTFus1QasrJN9K4o6Np3121E9AkWH9CkSNIWV64UTXMaM3JR89MSmzklaKgLL3lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ka9pos44HOTWyYsjAaF4AVP6F7ipz3z3PuVAD4gs+A=;
 b=OcZcZibFd9AaHkLvJtaJw0qPywpTw1C0kDxkfdxA0TAfc7yF5oHlBWaNRawt4wvajP7xn/TP6XGWfUGA4Smh68MpSnFeomdY6b5othGU7PPUf4hYtib8LNvqbjRvfdvL21DaW+OyJMLQzGVBm/0qVuG4B/40hSAxFEmxiu/losTODJ7vOu6AMv+GhByXb9wnv51skZLMMLP9f9H6f7vuz6TLvr5ru5auwJon3Xib0omkkSRHanu+O3T2U2wxeFT8766QEfuYOU47E8goFjNSt0X3pLQTc+SQZryHmhZKiXYgfyL34L6ZUG2hmpYxAY6veJi9DrqcULRL6CiOrgkPrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5014.namprd15.prod.outlook.com (2603:10b6:806:1d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 17:39:34 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%6]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 17:39:34 +0000
Date:   Fri, 1 Oct 2021 10:39:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/5] bpf: factor out a helper to prepare
 trampoline for struct_ops prog
Message-ID: <20211001173932.d6tknlfnqg2o6uu3@kafai-mbp>
References: <20210928025228.88673-1-houtao1@huawei.com>
 <20210928025228.88673-3-houtao1@huawei.com>
 <20210929175620.yi4jfpllhugys6eo@kafai-mbp.dhcp.thefacebook.com>
 <74247c43-39df-6872-4de6-8f4136ac37cd@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74247c43-39df-6872-4de6-8f4136ac37cd@huawei.com>
X-ClientProxiedBy: SJ0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::7) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp (2620:10d:c090:400::5:8bbf) by SJ0PR03CA0332.namprd03.prod.outlook.com (2603:10b6:a03:39c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Fri, 1 Oct 2021 17:39:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60cb86e4-e7d6-473a-8a2f-08d985026eae
X-MS-TrafficTypeDiagnostic: SA1PR15MB5014:
X-Microsoft-Antispam-PRVS: <SA1PR15MB501466491FF60C96B099496CD5AB9@SA1PR15MB5014.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IcNkMzMN4t+/gY24s0ESaZsOXawNyzyt95ODNxOqomhQdXUoHAqYI20MhXaHpHmYRTSm14+yzh9BFmWqnWPGFQjChhjKmbB8NngAuhwRyhevUqYep/XD54UkjF+NrX0dCW17WjKJ2jXxgr1oMG6x4PTDMEt4M8H7VM3Mm4b5uwL2UTVCCqppdbw8jT/PXHzlJk1EEaCz4Aib4hZzGE8/8mAfTEj1F7uIyUOnSsEXqGCCMpav33krSf9UQPVkZ2sASnIq/UasxnfLX/Zf7tg0WqGV2gxKqWRDDA/5UTF29DRl1p1kfPiddxO40gZ1DgdBvqrZqnZBfGZUkhJ4v98V9XGzrQUOm5ZQLYbPh58x/MktYPbDG1nkf1+nlW54/bo0TFHNmkCnVP/RSkJQDd+TEumxmjYTzXoUfi2aFCi85f3IDQ3luw9nUfpY3Tr196UKcHEVMUwTnrbASLjzB806lF+oVVk0OowX59/6DJtpijk7Xdsyn/XrROOg1hD5Y3b2LT6MWNSbW3JCVDA03+c0XcrPb+yf8woGo3urD1r0dUBG+g+xmrI99hFYHFtCvnBy+ZICTiRrcYC2npQUnBk3w6pCwajStbi4lQcs5J3XKM1taUPI9jocemUEu/BIP4cTw9a3GFgzrjN98vJxAGEELg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(4326008)(186003)(5660300002)(52116002)(33716001)(6496006)(9686003)(86362001)(38100700002)(316002)(55016002)(1076003)(6916009)(66476007)(54906003)(8936002)(508600001)(66556008)(2906002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XFlhQ0y5YHj6lmfIDFh4YheMqIT9ruuNRcjI0+6mbaCi9AIN4JdFb22k+yWY?=
 =?us-ascii?Q?rzbF448uWQhpdR/2CvYVYUk71KphZaiS4A4loGzloU3AAySjMUerswHUZTP6?=
 =?us-ascii?Q?oNUiISRaWVjtJ1/ruq+bkUSuhIs/3Q6FcgX+pQ7v02m6hk9pLCv6YaUbpRZm?=
 =?us-ascii?Q?ZaqaKS684/gP5c6taqG4UdZVlm641LSloibyf6xFhElutunUS/7O0CvQq3HO?=
 =?us-ascii?Q?thJSN6uWkRf6S2efAY7BEyx5NrNdyaOx8AxDVieqJJCtFRhwZKGPCiO3Uux3?=
 =?us-ascii?Q?wc8gYwj13whtUkiR1LfPW1yliDkB10jsjbbP8yL8OBcVye68Midpl+bY+e89?=
 =?us-ascii?Q?XHahltg7cMwSekuFOD7q4sLtc6vadVycFAIwc5ztQHqkQxCZqB7vRiKj/itN?=
 =?us-ascii?Q?YqeV7O6Nu6pJ5JoG6HJaMd+FC9xHZsVb+EgaGkoFDl4CefZVNYdYPQt/8jVK?=
 =?us-ascii?Q?HJria5wr7Db600j9LvlZeVEeVXsi2+SanGT1XUQL00tqd6+WDrXQxMATE1vz?=
 =?us-ascii?Q?s6fVLjPub1qPdp3U8+UnUZGJ9qKHPxZQcj3+q9XgRmUCLKk63VKGv6mKsMse?=
 =?us-ascii?Q?kzG8/Beeeg8B1vi42RaJccTeMovG2mV5FTq5wNE8HJlh55A8yAsEUKtUyP4L?=
 =?us-ascii?Q?Rp1NXD93gtLsnuAq1mEs7pMUUA8COvgZQiQ/+AhG8erbL+uSLTOoRAYfUGJ5?=
 =?us-ascii?Q?yRxY6GTr6ObRX0kQML6WivUGbwifr5Z1hK4dv5q9Paw6t7TqwLJeaGqeldK8?=
 =?us-ascii?Q?Q7ADaTM3UGs4IW9BHcTrubrbr2eU4ELQU12dYL2YIB/Y9freMFmNKxilRNEE?=
 =?us-ascii?Q?+aFSIcAW1gmPObPdYC6lvbCafYXpFuLdFTfkNdCPkYhvWShVwggogP+ScFKk?=
 =?us-ascii?Q?3ECTNkf9z6Lp83oAMx6U+2JmG9xHHgdLNWPO3+xtbyPNSkmPoPaQWkE2OyZL?=
 =?us-ascii?Q?pA2ax6FwMevGR37r3wiw7M0hn4ALPRdMTYjuy+NLf1xO3rSQrpNsp1McQhKh?=
 =?us-ascii?Q?9G7ai2Mum8Mf0GS4A0cvFKb0Apm4z5DIlaAR/Y0N0W8Y/5ws3/J0+ZKWKVes?=
 =?us-ascii?Q?2nU9phnqTvxQWGpRS+LdR4jTQ+ejJJmO0+Iwfvqn6sXKbJd2JZMj7mEH++fr?=
 =?us-ascii?Q?4DD2mxJYu4mb2KXi42FP+gDP7bc6klEq++o3y71s3cVEf9/fS3DvRMZ+3AbF?=
 =?us-ascii?Q?B0vlzEOKRYRaWEKLidp3P1BExATNM+5IHb3hPNjCicYl8g7lV5VzN2efs490?=
 =?us-ascii?Q?lvst25UKMe8IRqgfr2t/7+JDgOskDm/tJe30c/myPxbbAayZGyWNaj+QpiQE?=
 =?us-ascii?Q?z54sg4HjZexCr37kn1aM5sYWxCRiIMiU17g8/rHcwk65XQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cb86e4-e7d6-473a-8a2f-08d985026eae
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 17:39:34.5535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAosw1rJBOH4/eK3WBuVhpzuprEI/QpHxH1p8WLvkV87ATzk3NPY4mztNDvQQ/Rw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5014
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 5klPvO3IEy-fSrEVdcUe8xyXj97j2olV
X-Proofpoint-GUID: 5klPvO3IEy-fSrEVdcUe8xyXj97j2olV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_04,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=764 phishscore=0 clxscore=1015 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 06:17:33PM +0800, Hou Tao wrote:
> >> +int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
> >> +			    struct bpf_prog *prog,
> >> +			    const struct btf_func_model *model,
> >> +			    void *image, void *image_end)
> > The existing struct_ops functions in the kernel now have naming like
> > bpf_struct_ops_.*().  How about renaming it to
> > bpf_struct_ops_prepare_trampoline()?
> bpf_struct_ops_prepare_trampoline() may be a little long, and it will make
> the indentations of its parameters look ugly, so how about
> bpf_struct_ops_prep_prog() ?
hmm... naming is hard...
but it is preparing the trampoline instead of preparing the
prog, and most other bpf funcs are using 'prepare' instead of 'prep'.
My preference is a better naming on what the func does and a
consistent naming with others.  The indentation looks fine also.

It is not too bad ;)
bpf_struct_ops_prepare_prog()
arch_prepare_bpf_trampoline()
bpf_struct_ops_prepare_trampoline()

The params indentation looks fine and within 80 cols:

int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_progs *tprogs,
				      struct bpf_prog *prog,
				      const struct btf_func_model *model,
				      void *image, void *image_end0
{

}
