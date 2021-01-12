Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F02F38AA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406506AbhALSXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:23:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406483AbhALSXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:23:01 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CIEBFa002070;
        Tue, 12 Jan 2021 10:21:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Hpu8DFA7YwEMMfUHbQbjR6DgkBDYe47o8rFP0Vu60TA=;
 b=fHL8OnDB288OOcLS0A7sTCC9I62ysQG35LUF7VtX0JL1qNbP4Y5EaA0feuI2Yr1+7t9v
 ET33SuutgFemjmeMLivsvHJc5jb/cEFKadMMPwQ42pulZQsTpfrrsEWummy0QXWL8j8y
 CGnD7YozbWDLMkGSMXCt2vYzp3p8Lp6ZPf0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpp8hf4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 10:21:57 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 10:21:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHzJqsgusyk9UaaJ/ZRkUmCGEr9cut3XPApM6JkW4Ti8WqdcS35pCQxovqDJx5K/X9FKAszvEnoQM/kNdn7QjHfUM5Z+vTpeNS+hzkxjH/+sHXQmMnUPnmCfxY4klI7vLZeIUstWcaP7bAxXeLKXVhJf+4Z8DrGnRYTE29szY9PqATKLyqeT3Di0hWTNGCpVo5KbXL/QhRDJSyqe06lD02O1y7Y4fIv70CcCmI8t0A+GU+4eRFQVOdfsoMaJ4q4AukeWN0/2giYQGZpyQNDhxaivNXU4No9oGu3L6DlIWpK5y6BofsMMhxd7ayxQzmUqyDH8LKZXpa8U0caodGbZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hpu8DFA7YwEMMfUHbQbjR6DgkBDYe47o8rFP0Vu60TA=;
 b=cbKWrjG5iM2AZbGiedGmzNBojPE1xuXNc4BeExK02pN/x/oEFgpuTHptG0bG0lMIkpoD5IILzgZsqjc78fA60S+8ozamuTVV6bnVEFWnvCm92+vtxnIUtA4GmeOBNm3WhyoQe7jWAsD4TfRonfh82DZIrEBw3mfh20ZccoPICzsN9BFeag5Zu6Evb8umduYMnq5aXAkMk2t6M+GucwMF5NiLDniQP7MqSREL1uK5jQqkraN/cs1MzlSmRsZ9qnp1me2iB2kik2aYbsBvlDCOE25zLNU4uIOo2PI8lSciwdE2fuxkre1BipJ60CkbJuJvoN9mZPeO7l8hUKRG8Jy9aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hpu8DFA7YwEMMfUHbQbjR6DgkBDYe47o8rFP0Vu60TA=;
 b=alr2bYornj1aF/KQ7gLk9bBJUg/SJG4AKgx4HJMK89P48GkzFHC15lXSjRkFknotSl025QI5PAiLT2LZlUv3PiEQmw877w/q9vfC+86XpTSFDEkZxHfSKxyEhugYg5EbD6AsWYK8kfMtPFqc+ORdpXXQsIscfXpdi4GSCKIL9FE=
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3542.namprd15.prod.outlook.com (2603:10b6:610:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 18:21:53 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 18:21:52 +0000
Date:   Tue, 12 Jan 2021 10:21:45 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "haoluo@google.com" <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Message-ID: <20210112182109.ti434nov2c6dmuvn@kafai-mbp>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <4D0333B1-C729-41BF-AB1D-9AC233431094@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0333B1-C729-41BF-AB1D-9AC233431094@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:bc5d]
X-ClientProxiedBy: SJ0PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:334::11) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bc5d) by SJ0PR05CA0096.namprd05.prod.outlook.com (2603:10b6:a03:334::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Tue, 12 Jan 2021 18:21:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d24315c-f147-47de-117c-08d8b726ef9f
X-MS-TrafficTypeDiagnostic: CH2PR15MB3542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB35420C78C38D501015C5B85ED5AA0@CH2PR15MB3542.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHvLCmUiYBczJe94oUCZgsG3/7zw7xZkAUj3LPIhYe+MZgXU3vtxc7hEsTp6lnT8WFsIOlcsqtyOVof64xCr4IrKPbYZ1qyWXmv0qrbaF9FZhC9TKZWHcym1s2ZQMi/zhfITKQ7lQtXS9VYMowZ3MK1YZKI1AsTPQF7D/KYIKr0MnRB7K2JE8leiygQreoYY5EH6jVDsrQTYtV33quOg61wYR24L7KLDtB87dfKFmFdyITSd34kIdBCF5hthuc1f3mnqVGlfweJyP2oP0AyVLzUGLjNqzayc1tufGW+vxUbn0khWdFp4JA3sV5BnCH/Ai3O1urriAiZQ6109hDCXRQyWKk5UmPiKD1QVT5RSDxNk4G/XwQOi2/y7uF+OJkwWBHBYxdHDEPmxAVv0zZic5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(4326008)(6862004)(6666004)(33716001)(53546011)(52116002)(6636002)(8676002)(316002)(8936002)(6496006)(186003)(16526019)(478600001)(55016002)(9686003)(2906002)(54906003)(83380400001)(1076003)(66946007)(66556008)(66476007)(86362001)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Jk5DnKc6/Tq209g+QiW3HKLhmWghkoLISjxX6E1cWIiZDNhE1uYhhY4ApKlZ?=
 =?us-ascii?Q?Ay2git0vRrLuYbCe5gyKF3yVse/AbzMY0Loh5eoSDDKq0/ouZqgx0Jz5/l5r?=
 =?us-ascii?Q?NDWItRfp3cdLyTcrfNSvIP9Ek+FTsD0/nisauQgqaP+jD58j/tRVopzdSwoj?=
 =?us-ascii?Q?z+UAZerVxDSAtJDXdE/R5jYlfCMtqzCoYF4mJpYn/I1THPdKRKXVaA+QFQTd?=
 =?us-ascii?Q?XPSBRcWPMkHF4sWnzbNw+GAy5hgjYkq/XAPf3TVR1lad5V5PTQPfhBec7WwP?=
 =?us-ascii?Q?Sjn2nAg2DcYm/Ej3hZ1v3emI/+Up8UxftUtYL+pw3lF3tqnzmkl8XUEtDyye?=
 =?us-ascii?Q?EVl8WqChwTF112H3lQZ1yYn0VBeQWn7Y45WA/YMcaWYX6SJ0HMzSixY2rH96?=
 =?us-ascii?Q?DmrBSgk8Paegh16/rlBaDSU6v+ucbZ1fE2KhVeorWymNnsRHEuUOsaekwTFf?=
 =?us-ascii?Q?q23xsfQMAOmrfBgNeD9Xmo2N0M+J7KIyLv5AxWQXOrqZn2c8GMIrVpAxtmr7?=
 =?us-ascii?Q?R9604OPIL9HejPGMGRGmvFlVB29oe7rA1deoR/VNi7lIVa8J172XYlMtyi5g?=
 =?us-ascii?Q?dXgscySLDXtWuSiLGL2mYBAleD0MZXe77yiosiIE5f7lmJv415A15saZuHP3?=
 =?us-ascii?Q?orPFrJn8dcTmiVpY4JM3oLemW/ny2b2ItDW8kFD4yP1FW5MwOGz4wlrBgsbR?=
 =?us-ascii?Q?h6gSfM2gCcjXG/Pmvwo+5Cl8GoulqyqRy4dyS0olMhLY2CNVHQBiQ3G9rpGz?=
 =?us-ascii?Q?6J2Yeeg+KHRCfr+M0XzbXwczoFv0Lj7D+cICm5rSww3I/crl5PgUHfqylVgv?=
 =?us-ascii?Q?nsm0+iSOjS48MSGf3tKpPWBr8KkpqE4lB/ZhrTpzJvYztodRz27m+r5hEy3Q?=
 =?us-ascii?Q?atwt/eQFUUjEV6bvbLx2779JpPtV5Cv59vdwp3huZaWnhLiqW0nxfxGBtEcs?=
 =?us-ascii?Q?H0SceYrF6HeKAw6tuU9eXUPKwQ9EsQrshrsXxOjVOOOywhaH9cfjAzIehp7E?=
 =?us-ascii?Q?66iVJEp74kX1YLL0Cd03w5D7+w=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 18:21:52.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d24315c-f147-47de-117c-08d8b726ef9f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjL091mF0Au+9F1tEbBK/WMXA5sFDP9XMCIiZgybQkhhQpVm1B793lemeSshql+e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3542
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 03:41:26PM -0800, Song Liu wrote:
> 
> 
> > On Jan 11, 2021, at 10:56 AM, Martin Lau <kafai@fb.com> wrote:
> > 
> > On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
> > 
> > [ ... ]
> > 
> >> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> >> index dd5aedee99e73..9bd47ad2b26f1 100644
> >> --- a/kernel/bpf/bpf_local_storage.c
> >> +++ b/kernel/bpf/bpf_local_storage.c
> >> @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
> >> {
> >> 	struct bpf_local_storage *local_storage;
> >> 	bool free_local_storage = false;
> >> +	unsigned long flags;
> >> 
> >> 	if (unlikely(!selem_linked_to_storage(selem)))
> >> 		/* selem has already been unlinked from sk */
> >> 		return;
> >> 
> >> 	local_storage = rcu_dereference(selem->local_storage);
> >> -	raw_spin_lock_bh(&local_storage->lock);
> >> +	raw_spin_lock_irqsave(&local_storage->lock, flags);
> > It will be useful to have a few words in commit message on this change
> > for future reference purpose.
> > 
> > Please also remove the in_irq() check from bpf_sk_storage.c
> > to avoid confusion in the future.  It probably should
> > be in a separate patch.
> 
> Do you mean we allow bpf_sk_storage_get_tracing() and 
> bpf_sk_storage_delete_tracing() in irq context? Like
Right.

However, after another thought, may be lets skip that for now
till a use case comes up and a test can be written.
