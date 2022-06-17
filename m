Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A20354EE98
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 02:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379381AbiFQA6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 20:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFQA6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 20:58:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DF853C5F;
        Thu, 16 Jun 2022 17:58:48 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GMYmZ6016917;
        Thu, 16 Jun 2022 17:58:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Gr3r9ThF4nBhWbJTr3wymjsdfvKgQSsZJ4Alcef0baA=;
 b=pM95KNIrrtj6Y+xX7B5rozpJ66u23FR3M8/o1I8L/puqOSj4SFO7YVkX6ITSLfy6N63K
 CHj2wFqzaySX9iE2C2NQg8h2U7zv9mIXnjLKhnIH+pibKJ+l+4AmLZgpy+OgfxSL69WS
 Ysb4F91xbUF/q3oUeWBSeM9RzS57VdMnLao= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqt6fqce5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:58:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZgodbRpS0Mc5bSnx3cmUdVJnSTAj9q4F1pQt+yp31YbNO2SBPAMosG+NE2j/QDVCzijMosH0dm4BWj6HneKWnHmQ2P55LN9tW+BwCp+Y8+Of31qC2fwHEuZ5e20XdOLbS3cQg0g9f8rK5b9+wKsGvZBPbnAeQti1L52fhpu0EGkBNTO2jTl1TRxVHMyqgbUabUueIIEEjA7LEa0dgzc0nxMKf5sbeS5JdZLQ0SijjpHK+4qLQwehdvAI+zasdz8brCmF+gWA1aqRMp0okElpEsvY8p81UburBWYNJ2ETJoX2sD6oGA/SuLYCs2gYcS39B80TCO1xkh27hmSSlVPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gr3r9ThF4nBhWbJTr3wymjsdfvKgQSsZJ4Alcef0baA=;
 b=TiWkDPEOMsFJPrQjfPSlaORsiCZPzFHHrRuHnjT7tVFKmhDmsBdsZzIkLCA7B4eBLXStdoJLF8MLckhWKsdvHRzOydJR3p5mqd2xV63uvZ25r4lCFuQ2Firw7K9eVBgqQVihAyJwu6GpWDpoYl9MkNRlh6eZsropEafDdNMVRn9QwLn/GRW0M+A3+aXYZNQKHkFlaW4q2UyWi1LYIKDn5yGKcUwsOlhGuGSNVBmaoQ0QxIJbQrghFTqwe56g4NzAtTJAA1DlMYU3kfXyBBka3hniG9+D5BFwDHzVq/zaZYz6cTu5irRwHeb7XZkoqqkWxYs9lv71iawfbkwb8efLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BYAPR15MB3318.namprd15.prod.outlook.com (2603:10b6:a03:106::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.22; Fri, 17 Jun
 2022 00:58:30 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 00:58:31 +0000
Date:   Thu, 16 Jun 2022 17:58:29 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 05/10] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220617005829.66pboow5uubbrdcu@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-6-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-6-sdf@google.com>
X-ClientProxiedBy: BYAPR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:74::34) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1292bbf7-5daf-4c9d-5e80-08da4ffc7ef7
X-MS-TrafficTypeDiagnostic: BYAPR15MB3318:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB33186875BDD6C1D885EC76D8D5AF9@BYAPR15MB3318.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYXiMyg5ekWBQjPQg4F5D4ZUVWu8D1QUV9MAy3fhS6pz3tP0oH1hIkDs4+KuHo331udI2nIMhgzBLNthlYlP6Kfq3wYd/NJ12oy0dhnEg5gXHN1EDCIv6LmZsjEev94Qr5m97pZ/voUV+CUnYF5tULSykGjsp4QUAYSs96MKP5mOhbZqeSXVC8TVEH6f4DV0x9xwPRn+2jeHGUt38REkC1Wu9KysTOHS89Wk4dYU7i9umV6Fi2GjPBwtzgrFKVIzXH0XS2HZ+DYtpBeJWvsVWIZlk2izMWl3zEodk75GN+wwL7kjukHy5jJVyRxwTkAdOyeQz+Heed0tiA8kHjWKztxgrtdzDuw8DezNppiVPJsMXoQIcPUgne+GQOT5PpO4hDzqxRMoi7reURfEhx/ysZMnjTloyA97VxR2n2cXXXi+S4f/OH2VmHm4aQx0//Cj8/SVbk/QLOLR/nXTm5IwfMQdkuEqTLOIBGHJRL41ArFUdMdfkntcDkDRVXCBtw+z+01A+bI25w2REp/o+9MFKjIqiqJS4moEP8AGbhozs8yBcxGlFSlzpvZDOkd3TB5/F0P/y57fUTePN4ILDOMeWj07iWwRdg5gK3RIb7wVmF1n61yLg4kwanH8yEpIlqfY5HmF3tnRjlpXng9QwMuZsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(6506007)(86362001)(5660300002)(508600001)(66556008)(8676002)(83380400001)(66946007)(186003)(33716001)(52116002)(2906002)(4326008)(6486002)(8936002)(316002)(1076003)(6916009)(66476007)(6512007)(9686003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A2MsyedCxIc/wzWcNr3U0sz/BFRp8t5C0ZIEi/CICtLNDCOWuqKar+b1+DfK?=
 =?us-ascii?Q?WC2s36q/AkS5xAQoldG3guwigH5c35ibbn3RxXG0n7MuU7F0tzjS9Bw8IPmh?=
 =?us-ascii?Q?sARj1RjUJodaiL/Eb4baGXAaiMjNkOFna8IhvIj2VNrA9KmgWV7XOp9soNc7?=
 =?us-ascii?Q?VguydRcwarRsIuIAKb7JhjBgP1iHOkPlgoZ3pspifrxx2csVUNn6PFGOonhR?=
 =?us-ascii?Q?CUst+WpWgM6ylphuoJhjsf8P0+9YNduSnyANLTQhy1jWBChTEOGDfjDMirjZ?=
 =?us-ascii?Q?rpofaLd85+DhzEWho/qKaH9c2x3tI5RLnI41BatkauCqqmYqzmecuntVyEV2?=
 =?us-ascii?Q?d0tY7RfA5jhAG5qK/s+CUCOiQJZZFiS+gqTVT1UouGe3RGEARChJWOPK4hmo?=
 =?us-ascii?Q?Jzwv6iRjQ5M/1idDK6nanWMMVqhal7ljBDpITKOOLo3tpyAnuz7JilzD/AQp?=
 =?us-ascii?Q?trVEEcJ2WlDJlkObzLX71jT+mlIu35LM3yfq+SkLcr1ZMo3g+obgJNHU1du0?=
 =?us-ascii?Q?Fm2zcQFr4XXygSKGhXHnjmbdtv4dP9fUBUdLT6Eb+jgSvobui1gtDCL5Dg41?=
 =?us-ascii?Q?i8jToqN+PjL0aAEP1x1UuxzrYn2EVBMtLLUMnmooUMnXCkMkvKlfFK1dZt+U?=
 =?us-ascii?Q?xhy5gwGegNnwk8nAlhEAEkYDXU9t4jGfh2WtgJ8XEHuwKvdNkw97zIW2RgCO?=
 =?us-ascii?Q?bFlqIfNlpJwIWsKIiTo4koOUwoOLSSToT9lSTUP5uEmqcooqLAkvQhaZur+G?=
 =?us-ascii?Q?3TZjOftpD6x9YvwSfcHmdM33hdsWbdh494M/fLEXsjxpviRup2ta9hRn7FEO?=
 =?us-ascii?Q?ziE9DClPPBTujdjzK7ueiqTBpO/BvpIpqU5UfPRfEHsaO3gl5ZyXIWjWw8L6?=
 =?us-ascii?Q?dXYXgNmBV/3ViM5QclLRQHDGpkkwsNa1eQVIXkISW5C2lVEtGvukOvLehpkO?=
 =?us-ascii?Q?jw3v88l43OgH5VAFLFeTYUeqP0SHlW5YypjLg+H2NfP5DX9UTzDDgArNk9Vc?=
 =?us-ascii?Q?2sqgngF40gkB8TjqWR0QLokeXCq82ZL3wzXI8ipBh9jLwsV6t66SV3icyY4a?=
 =?us-ascii?Q?FJca+0hEidCiJOwCQ3QeVf9fzZshP2cmIMOEfXYSIHDN1qFDisx+kVqOGvBj?=
 =?us-ascii?Q?BWtNgizo3+TTywXPRTwWIdSfuIzuktnkxnaW/qbkafdWAjF8WqvwUAnjI519?=
 =?us-ascii?Q?JRPZbTFHKj9J1/pqdSrk7pUJUVEQMcAlMJh+paC1gcGgXmNFRB4/7y07Ri0u?=
 =?us-ascii?Q?OjNT2Nw7qpg/paizZzME2eRLOBOw6D1xy8KAskHtTvQEXKfJGvGPIAA9qcOR?=
 =?us-ascii?Q?LcjfKhglqY78BMrdtszEnJ2yUfSIqZa112ECQwiQDCcLbsaJpAXhKyy/Peqz?=
 =?us-ascii?Q?JxVMHJwAEqXsjBVa6TpK/D4egLynRiEly0w5Rd3i4IFrGL2phejJ8d4suhJf?=
 =?us-ascii?Q?MWOXwAnpRvJuQrSXC/Ro9ipOwXLheIqs39GQTXVBOefoWlFSOqrLRabi+KBW?=
 =?us-ascii?Q?uEXvYswecmlZgQKHmYZxVDmUkkZRianhunL2+6r5FGrquKYe2u2+30Esbs0G?=
 =?us-ascii?Q?/mow43z9Z+dYuwJhhFdTaVVWwDBR88EWDFwJz2s/VpY9W07c9nzgFCHayEVk?=
 =?us-ascii?Q?MMN7BaeEIJRBdq2EF/uLxrtLLxrqxgj/itXJMMHPgToq+0qxNVoWbstlURpp?=
 =?us-ascii?Q?CkgbN6DK7SMxil+8t4+KFfwIxJcgsl7kAYXosnzR7CKaieFHzIQSNxujdico?=
 =?us-ascii?Q?k3mo0XQo/T7dGPQys5WoZbriD313SFA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1292bbf7-5daf-4c9d-5e80-08da4ffc7ef7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 00:58:30.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QR6xPAumlttxmZeewMujxL566ijH870IdrmXGaPZLLzMkfH4YAYSXqKZk/mQIHED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3318
X-Proofpoint-GUID: 9r93zgCQfQ5lTnjtgy4iPHsrf22WrG8x
X-Proofpoint-ORIG-GUID: 9r93zgCQfQ5lTnjtgy4iPHsrf22WrG8x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_20,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:57:58AM -0700, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index ba402d50e130..c869317479ec 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1029,57 +1029,92 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  			      union bpf_attr __user *uattr)
>  {
> +	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
>  	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>  	enum bpf_attach_type type = attr->query.attach_type;
> +	enum cgroup_bpf_attach_type from_atype, to_atype;
>  	enum cgroup_bpf_attach_type atype;
>  	struct bpf_prog_array *effective;
>  	struct hlist_head *progs;
>  	struct bpf_prog *prog;
>  	int cnt, ret = 0, i;
> +	int total_cnt = 0;
>  	u32 flags;
>  
> -	atype = to_cgroup_bpf_attach_type(type);
> -	if (atype < 0)
> -		return -EINVAL;
> +	if (type == BPF_LSM_CGROUP) {
> +		if (attr->query.prog_cnt && prog_ids && !prog_attach_flags)
> +			return -EINVAL;
>  
> -	progs = &cgrp->bpf.progs[atype];
> -	flags = cgrp->bpf.flags[atype];
> +		from_atype = CGROUP_LSM_START;
> +		to_atype = CGROUP_LSM_END;
> +		flags = 0;
> +	} else {
> +		from_atype = to_cgroup_bpf_attach_type(type);
> +		if (from_atype < 0)
> +			return -EINVAL;
> +		to_atype = from_atype;
> +		flags = cgrp->bpf.flags[from_atype];
> +	}
>  
> -	effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> -					      lockdep_is_held(&cgroup_mutex));
> +	for (atype = from_atype; atype <= to_atype; atype++) {
> +		progs = &cgrp->bpf.progs[atype];
nit. Move the 'progs = ...' into the 'else {}' case below.

>  
> -	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> -		cnt = bpf_prog_array_length(effective);
> -	else
> -		cnt = prog_list_length(progs);
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> +			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> +							      lockdep_is_held(&cgroup_mutex));
> +			total_cnt += bpf_prog_array_length(effective);
> +		} else {
> +			total_cnt += prog_list_length(progs);
> +		}
> +	}
>  
>  	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
>  		return -EFAULT;
> -	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> +	if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
>  		return -EFAULT;
> -	if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> +	if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
>  		/* return early if user requested only program count + flags */
>  		return 0;
> -	if (attr->query.prog_cnt < cnt) {
> -		cnt = attr->query.prog_cnt;
> +
> +	if (attr->query.prog_cnt < total_cnt) {
> +		total_cnt = attr->query.prog_cnt;
>  		ret = -ENOSPC;
>  	}
>  
> -	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> -		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> -	} else {
> -		struct bpf_prog_list *pl;
> -		u32 id;
> +	for (atype = from_atype; atype <= to_atype && total_cnt; atype++) {
> +		progs = &cgrp->bpf.progs[atype];
same here.

> +		flags = cgrp->bpf.flags[atype];
and the 'flags = ...' can be moved to 'if (prog_attach_flags) {}'

Others lgtm.

Reviewed-by: Martin KaFai Lau <kafai@fb.com>

>  
> -		i = 0;
> -		hlist_for_each_entry(pl, progs, node) {
> -			prog = prog_list_prog(pl);
> -			id = prog->aux->id;
> -			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> -				return -EFAULT;
> -			if (++i == cnt)
> -				break;
> +		if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> +			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> +							      lockdep_is_held(&cgroup_mutex));
> +			cnt = min_t(int, bpf_prog_array_length(effective), total_cnt);
> +			ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> +		} else {
> +			struct bpf_prog_list *pl;
> +			u32 id;
> +
> +			cnt = min_t(int, prog_list_length(progs), total_cnt);
> +			i = 0;
> +			hlist_for_each_entry(pl, progs, node) {
> +				prog = prog_list_prog(pl);
> +				id = prog->aux->id;
> +				if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> +					return -EFAULT;
> +				if (++i == cnt)
> +					break;
> +			}
>  		}
> +
> +		if (prog_attach_flags) {
> +			for (i = 0; i < cnt; i++)
> +				if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> +					return -EFAULT;
> +			prog_attach_flags += cnt;
> +		}
> +
> +		prog_ids += cnt;
> +		total_cnt -= cnt;
>  	}
>  	return ret;
>  }
