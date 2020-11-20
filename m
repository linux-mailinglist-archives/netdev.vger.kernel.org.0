Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0CF2BB9AE
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgKTXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:06:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8968 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727417AbgKTXGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:06:15 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AKN08MC023894;
        Fri, 20 Nov 2020 15:05:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6KMWIDSm6aiSmsEFks3k1XNusuRCF+nTULBZBiignBU=;
 b=AH2XszNAikrY6q4ZkDOfCyKP+/2zMyPrqEXrJzRfPMGMfaeKCQOrzCUK9ldZ1xN1IR7/
 2j2zmm93BT7N+GHziW9V0KqnMW7S8HedQ87duS4WSHHT47532YUf2+EwnwUhha7LVlks
 0d8VoqfwCKbfB+NTVek+ZfQnm1QFsG+ZG2k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 34xb6fv3ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 15:05:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 15:05:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGqoDczTnd/yHidwnvuSzg1xoiobRrpqkmZm0WnDfOFIie7Mxsx5ENSoTt+vzejeRoQGYFnvUF1BAcu/GMDuyescS1GsT+ctIPLpLfUr5L9rG42HTnKVFN5SBxBpgfSFTegp03VuU1KDsa67qyrWYmpnwtpWCw0PhkDbqra9b/WGEMtFulqvJZPPddmqKU24Kf2dm79HT7RC2dZyHssCDPJlQ0wA4OwR/BIBav5nuEkKqB9mihLyL50KNy+umVZXywJ2CwmD592nRZEk0CyzAzgd7OsTP/5SvDWvpsm5bdDn7Ulo6+OFYfWOTQsIFdNeYDoPpPC9ZyOc4xOov65r3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KMWIDSm6aiSmsEFks3k1XNusuRCF+nTULBZBiignBU=;
 b=LhRmJQwWgSwe3fcGwE3YvFyhBBnoLbblLKswEQm6Do0eSuiMN/Ro7kdnhpYwZnLwn+Yxti5EDZgQBSzw2YjqBHKTf8vY3s41Mk+NGR3tKQd7JYEU8xai0YXpIk0nP2BGIFjmMVVZiL2Ia3Rm5zdIvacC8+kY3eyv2lwp7M1u7WTv+NxqR2hFFp4Hj/jkArLKhQEEWaVfJnwQj4vmsIhNs/Qmgyvsk0ONQdYOOu711U5d7MNdS3fCZwFNtmsaiIUZtOOpsvCaLzMtyhbVAcsVN1+tGs5y34x8DVQhoVxbkTlMufOQMDtdrBVZa6T1L/78eRf+K2SsG3lm9U4koLW0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KMWIDSm6aiSmsEFks3k1XNusuRCF+nTULBZBiignBU=;
 b=LLyUK4kfVDUy1bpR+IW4Yn95abr81yE+7AKH6RKDhktMbBMuARUQA5Sf0wk4c3DGK/8dDw60A/KNE29fEyjKyinaHDixd3/qILFLyZo5pEIzL4eSu5KCxrr9NgcN4zLI/Nv4FtVJTklrv5utk+Y1wZ/2AbMYqDlhzupKJXn7drI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Fri, 20 Nov
 2020 23:05:56 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 23:05:56 +0000
Date:   Fri, 20 Nov 2020 15:05:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add kernel module BTF support for
 CO-RE relocations
Message-ID: <20201120230549.37k4zsjsrxbyjin3@kafai-mbp.dhcp.thefacebook.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-5-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-5-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:300:13d::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR20CA0007.namprd20.prod.outlook.com (2603:10b6:300:13d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 23:05:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 854328a9-e2df-4177-2b07-08d88da8d63a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25843F69D552D1E6206AD2C4D5FF0@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:324;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B9l0BDtIR4ieJerPocSXIuYQraFUkWOB8nn0POukgAXMN6GCCqndyDVmZ/STZdI1/yXIGuR7acm9vhrQNfTwpoSOKhkLEw/dEZ2BXQ+u+vy1N+A/QOxOkmTp8xOXw9YryhA62BlVV9hSoDLx6mVxwRUoQMwxUueUXOn/hDL2ubn5B0zhulpdG2R/VURcid2RkoWBpo2I2N/q25Rhv7hq1pZFyVxBzEoTynLqPBI3dfBj7/YQTrGkxUExMpHB/9Pl4DVeH4KsPm2jWAuThQtVxc5mZ4Vo+I0pIXuENaY+P6uhE6ZA6G3kpKruLFnFlqsJ8MgVoV6wDrsKh8XoT/Py9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(376002)(396003)(316002)(1076003)(66946007)(66476007)(478600001)(2906002)(8676002)(16526019)(83380400001)(5660300002)(6666004)(7696005)(55016002)(52116002)(9686003)(66556008)(6916009)(4326008)(6506007)(8936002)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yArpkFRbbM2SzW82RDQIhqVP8KfZYIQqIeIKheijEHijKwLr49aFOBF5dAKiJ1JR/5qiLhEbaKa+zcljC4GwMBPOkUCtvroaN3xn8avlCZvNJiJZjcwnPKQOkVV1jLXJ5OrKPwDbH/eMu6CiPfBSogEqG7Dc5MSbJB/fLTB9b48nJnZNPP5sTUvXRzejN3wzhpXrxqlK+h2E4EwmGJ8zxRzy9X9NER/XFVmUe5ycQJVlwaDjuWmPkiPQ7A0Vn5Q8Njhf2aKJq0Y35QhRXEWBSBk5sHzQG0UqnJnlg76qaGh4paBC1FeUT3FC4wirs47auz1TanWwc9/s5FAGEgxqLKeFIoy2hYfuKWPYXxOdj+LMraA7Ht0fOaAZlmZckQWpx5osB0fHSqf7KXIbNyUCVAstiHApZDUufxy21tT/bmSPlMzalSaBXgD0yNvLoVeHv1msfOhWsUt/dlluZCQ2nrI93J3eDHzKTFXk7Cdg+W4CF/zrhjMVNnRvPw6dCwK/Bcr1k/VqrPcKgtV4bJ0+2mVfSgZYaxQ9mUOVK4OknqNIVyawTZVzkYGHUaGJCLCjaTWCJhYqylnzFz+VtICud815Y9mdCNtsdO+xR08IQ6CMef55fej4vQgiTPQvxXigOKRLlSk1zV7VLtcg/dclyRiDcZXbDdzFfhY3k5fdsfw/ivwMn/200cmEiW4Ta3WTKKHvClVooP/vqL4FiVUFabIyfyWLCE6b6ClvUP6AsoLgwkjLMEil8vBvUgjs34u69XAPgJ4lzZUrb7EsNgiat9d82MXX8BGJMQ7/uVqOs6hTQydkCf0ACy7UkPbR8WLdnyARml68YYu1Y5tc6WZHk8vHyd3y5ELzwAt7xP+RMsocBiVigp1FnDSw0jPoVOKzt3Sc+YlYNp/MgnrQ/MF1ZryG0NfdtaUgqghiXNZf1/PKROID7pLXJSUdSkIqxp/C
X-MS-Exchange-CrossTenant-Network-Message-Id: 854328a9-e2df-4177-2b07-08d88da8d63a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 23:05:56.4391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHg7h6QDm8RFAq1d57QEr4uLqjpTOKv62iWLdqJ0u+NnrYIXe/09t4KzTWvyCczk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=7
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 bulkscore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:42PM -0800, Andrii Nakryiko wrote:
[ ... ]

> +static int load_module_btfs(struct bpf_object *obj)
> +{
> +	struct bpf_btf_info info;
> +	struct module_btf *mod_btf;
> +	struct btf *btf;
> +	char name[64];
> +	__u32 id, len;
> +	int err, fd;
> +
> +	if (obj->btf_modules_loaded)
> +		return 0;
> +
> +	/* don't do this again, even if we find no module BTFs */
> +	obj->btf_modules_loaded = true;
> +
> +	/* kernel too old to support module BTFs */
> +	if (!kernel_supports(FEAT_MODULE_BTF))
> +		return 0;
> +
> +	while (true) {
> +		err = bpf_btf_get_next_id(id, &id);
> +		if (err && errno == ENOENT)
> +			return 0;
> +		if (err) {
> +			err = -errno;
> +			pr_warn("failed to iterate BTF objects: %d\n", err);
> +			return err;
> +		}
> +
> +		fd = bpf_btf_get_fd_by_id(id);
> +		if (fd < 0) {
> +			if (errno == ENOENT)
> +				continue; /* expected race: BTF was unloaded */
> +			err = -errno;
> +			pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> +			return err;
> +		}
> +
> +		len = sizeof(info);
> +		memset(&info, 0, sizeof(info));
> +		info.name = ptr_to_u64(name);
> +		info.name_len = sizeof(name);
> +
> +		err = bpf_obj_get_info_by_fd(fd, &info, &len);
> +		if (err) {
> +			err = -errno;
> +			pr_warn("failed to get BTF object #%d info: %d\n", id, err);

			close(fd);

> +			return err;
> +		}
> +
> +		/* ignore non-module BTFs */
> +		if (!info.kernel_btf || strcmp(name, "vmlinux") == 0) {
> +			close(fd);
> +			continue;
> +		}
> +

[ ... ]

> @@ -8656,9 +8815,6 @@ static inline int __find_vmlinux_btf_id(struct btf *btf, const char *name,
>  	else
>  		err = btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
>  
> -	if (err <= 0)
> -		pr_warn("%s is not found in vmlinux BTF\n", name);
> -
>  	return err;
>  }
>  
> @@ -8675,6 +8831,9 @@ int libbpf_find_vmlinux_btf_id(const char *name,
>  	}
>  
>  	err = __find_vmlinux_btf_id(btf, name, attach_type);
> +	if (err <= 0)
> +		pr_warn("%s is not found in vmlinux BTF\n", name);
> +
Please explain this move in the commit message.

>  	btf__free(btf);
>  	return err;
>  }
> -- 
> 2.24.1
> 
