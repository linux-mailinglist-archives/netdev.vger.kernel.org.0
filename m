Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9267653D60C
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 10:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiFDIGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 04:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiFDIGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 04:06:08 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B7435AA0;
        Sat,  4 Jun 2022 01:06:06 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2543QN82007278;
        Sat, 4 Jun 2022 01:05:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gRkzhCQ/gw1Kaj2EdakXpLOnmyf8FFuE80U8orukLho=;
 b=Jvx6wFIRk7s10+N109ZmujFVaiITMxdJkidGrkfRRhmk8N4gDxsXQX02CDX1/HfPBc0j
 4xUq47Jd8KkCk62dxXoe1zH31EiZH/0+lM++jR0hWDn+y7lvwJHb6tuY9lJgCzbU5gTX
 rZYV3uZjy5ZtVF4EFwGYbyaNL0LFjcMkMIo= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gfyg0rnaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Jun 2022 01:05:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVMA9HdqESbYV1YnQu8cMoEk9NoEzGkT86rKbomMBckORVWex14q4718YeEU3BRUtcIw2CJygagQ2mUKgFyzLF6Xtw84cfBiCtBmJrPoY0BHegLqFvImTaj9pKzsKutpvfLn23QMwKNYw4tkbaAthe65VBPm2/S5pMCz9Q53XDebQ0lqcqoS6TA8FY4i3EYyN8bFZPN+ztBcYYgE+bahj7wtMf8+iOCIHlkaBsLN5NyT7pDOFz9ikFblBY21V5gju1arARqqeosiVZsUGyUpQGFajXRD8mR0Jn3+E/1NagHpzQ025NkVqLyu7pEX8SS+tgilLKRyVjRGhefqYyjpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRkzhCQ/gw1Kaj2EdakXpLOnmyf8FFuE80U8orukLho=;
 b=BP80aMQGF01ccGIs1eEzNrU1QzgkhDax7Hm4dJ89ej56yzFFBRfI+ozOgjNXS/bUtDv+eUcvUOCKR2T4MLlYS6FBgKn5BGg/3aHjV+gJF1kxcHxcduBBsbYrynXiAupMwFtxUGEbFU/ZWGgm1sm55lUbfVbiGQP0FRzD0BrHKixL8Dnw13gcD+m+AUftuBoII0Ov9O2J308kNfecwx9VsLVdSjqwJqbf4nIIs5BWOqtO59ClD9SuNWih+lxcXbHXjX19WHPpYJCqkWimm7ngp1UPOXtU7F+elxl7VCGgG5lIErzQDN0L+Ly0rOka8XQJF/Z3HC03SZ8rn7GuUv0YCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CO1PR15MB4874.namprd15.prod.outlook.com (2603:10b6:303:e1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 4 Jun
 2022 08:05:45 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 08:05:45 +0000
Date:   Sat, 4 Jun 2022 01:05:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220604080542.2fk7anxkjvysd6gr@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-6-sdf@google.com>
 <20220604065935.lg5vegzhcqpd5laq@kafai-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220604065935.lg5vegzhcqpd5laq@kafai-mbp>
X-ClientProxiedBy: MW4PR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:303:b7::27) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c481885b-f171-4922-b0b9-08da46010700
X-MS-TrafficTypeDiagnostic: CO1PR15MB4874:EE_
X-Microsoft-Antispam-PRVS: <CO1PR15MB4874B24DC9BA67F91B7F0975D5A09@CO1PR15MB4874.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LOv+SR2dkQeZ3jWLbIs48Q3jaNBFATVyHJ76ifumODdlTby60HrX7Y+fJvxIiIAtzII2xl1mNskdKJOuGwajKV7eg/FA5L6XmEwjVo++kZ2yIaS680z+rP6yEmnoTwol/YzLceD3eGsvHA+vo4XAuvXnx+ynqiLFhCwpiixJfBx3DOwWlJjwg0BUHDvVkXtrgbUIC20j1eSFzcB0zoxPi8Wtay4jqy1vplEGTLTMpifTcuYAY97XaMwGmpfvyqtURZQ+R+gAuQBjj+1sGjHZyWC+YLgVGC+LhCh+MX+bfzMgtebLgSSyPLDnEvp/Vy8E9Zwc6+Pujstp3g5CyVOL9oRsu8DI2gBZW0aKOxvpgZPw6w6rE62FtTQFk96jZtobEHYyMeInBQxXwxh/5leTt3ejOzGvzQZtb+bbMZ442xH6yQkkBBwNZOswmIFFhmAJ87VfvzXwwppvDL/PwhMngvdYLOV1yLbI8C92tB5DYApKJsaiHCID0vqCdYTsJYBdq60Oh6hp9gxnJiv0+Pxw26GX/UtXMevuTRZPMPYns1mvL88s4oM+cd7UeRAKi27kMf6agwDwDv4y67TRRhqgJYmxPUNEZfnr90F9PntaXQ0fN4FmCppwOTsIkscuj5xppSefYpnDn70S+8Kw7vZmeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(38100700002)(316002)(186003)(1076003)(6916009)(5660300002)(66946007)(6512007)(9686003)(86362001)(33716001)(8676002)(4326008)(66476007)(66556008)(52116002)(6666004)(8936002)(6506007)(2906002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XjMrRufw4qlexZZwaxXPc1sHYqzkYU4DQqKx5QQhQOJBhxSjpKXVCNZUIucX?=
 =?us-ascii?Q?32Kehbbtyvvsyr6XT4dJ8BTNBZtAO2rmkA2Kq1hPKXGsvNwFnkAxTeyfYNvC?=
 =?us-ascii?Q?th1tunS4pcTlJPmiqxP9txQ3mnxfN7SfzSoHD1DoYhnsbt/qqCsjmfV0zoJD?=
 =?us-ascii?Q?qWzONuWO2gJfSK/o3jmx6C5WJY1HWxkehm/p0r1gFGGTRKSrBXyyc4zR93rP?=
 =?us-ascii?Q?BVrhbY3N5sD3YelU5MUN6QkN9UHtvG6qnd7OYtIKA3J8cDrntHu7xrMGzBpE?=
 =?us-ascii?Q?Zum5Xspy1M7tlkoO6felEcUERLpjPii5Nz6IctjhlwKc5Fr7TCOcYsHdL7ba?=
 =?us-ascii?Q?DvCxMeMA2MAYEYc4XFVBfnKL/YMiKP+MfejTIzpQBIs68fbTNLnMCNK8g88I?=
 =?us-ascii?Q?2gneoiaU1yJWG+IIzkcVXoP03aMbPtxgUL1W8avTK9l8WikspwEeNJgC1JND?=
 =?us-ascii?Q?ChZ4A7qq2Ah1pays3jsZeqHDmN+YrLvCZPAeEv84HvGru6OjIEHZHZ2mT9wf?=
 =?us-ascii?Q?TxVeOJsAaLfGbTZK2zeZYHI1fDEcXtUZ4nsDBOSDP7ncsewkectS2IicrksE?=
 =?us-ascii?Q?fTIDYaaa29ZqGx2wbyohYNUZWr+lmzetHzfLR/mZ0nglXZaemq9860xanbw8?=
 =?us-ascii?Q?1ybaaMDJtjtFgjXYeSlcaTdcxLwWuWCaPHETHG52/27xPcsQWHBrmKGf0uEo?=
 =?us-ascii?Q?OEbuGL7CczDn7qwyv/l2oE+WNcbyLzekNWZDuJWy7sTeVz5tzELWG/MAlyYr?=
 =?us-ascii?Q?gvW2lPznabmyOJnkW6gg3m52lEws/c/YlJ72/6sXBm8t8Wo0aPj5hrVXkLJj?=
 =?us-ascii?Q?HguSxOQ7dJXPVLLcZgdbKnx+t/UZtAXNF6YqDkfvP7SvAxKpX04HBApmRD0Q?=
 =?us-ascii?Q?WkrbNw6JdcDL3gGECMG89B96+5i89rtEYXZ4Jt7YBNQlFcao8DYBrnEzB2Xu?=
 =?us-ascii?Q?hb/BlEMnWupAelJp+NePVc1k7kIoac5NpQxmwADSS23D4rkZT+r3QYuAZeBN?=
 =?us-ascii?Q?xsysk5g6+r9Vuiv3Hhqy79yATGbd5p6KSPDoDJ3419ctDH65Dg0wstSYW1iw?=
 =?us-ascii?Q?EwhQ7o7SQCXlKVFMCh+7ekEXdRQCZuqJkI9fd6cQcw8JoyTimvjN/fqIZ7+e?=
 =?us-ascii?Q?mXsmaccYFlUDzE4nxq5DyH6t4RxcsxBXmkuOnNrPouVRm2qXiXmOm1oSV8cj?=
 =?us-ascii?Q?z5XTy1ioWTgn12Ii68pgBJ8LxtyTeWdDDikd0ApP6WrU5/lgMQNkTuxiHRAz?=
 =?us-ascii?Q?txvCa/ZbyFF2Lc1eXbdwrk48E/Okgf25QXrnkAa5L5mspwFv0JC6gVytcxo8?=
 =?us-ascii?Q?0TVnJx7noJ+MhDhqi6UiRTUgkvq2qzLr3+SUznGT/vUi8GI/1QiBmDGbomm1?=
 =?us-ascii?Q?0x2Pidh4GefKFF9D24krgJvTpdbTvYe35MGYfMgC4AYC/S+XHOlV+MjHFJS6?=
 =?us-ascii?Q?PGhdczV5ZExqN0Q8gAlQxu61AwnukPDlQbQAfl2HfbOvqru+fgKoeAaYbQ0M?=
 =?us-ascii?Q?vEttGxWuSgW2DTGbsqOrqvAJ+OEeNp9jMYgkdPSDG2RmqPo2qDF+QSLVXYF4?=
 =?us-ascii?Q?fHL1T7EZmjW+mYNvMi1Iz6wSrU7oJkkQPXuepFnDHl/0Y6ckpPNyOCi3i/T3?=
 =?us-ascii?Q?F98PVY0imlrawpiqcQal8oVoMpzS1kjg9jShVcLhn8MixvEwnNy2VFfg57PI?=
 =?us-ascii?Q?vryUZqN/tcw6sS4Pn9dJmGEs4J5Ew3IkcxB7aJrIdU0iX/tudmEZ4grY4fsx?=
 =?us-ascii?Q?e7pWgByNLE8KsPgEQc0jXy+xMps9m+Q=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c481885b-f171-4922-b0b9-08da46010700
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 08:05:45.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40eJzoW6xU5Lm0Ka4c+N6fjA1steNS6wsmJN+x2yjQHcIl6/SWG5I0S+BE2Ho+UM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4874
X-Proofpoint-GUID: JOrj3-pbS5TY7RmLnagE6ghqcrAWVw78
X-Proofpoint-ORIG-GUID: JOrj3-pbS5TY7RmLnagE6ghqcrAWVw78
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-04_01,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 11:59:38PM -0700, Martin KaFai Lau wrote:
> On Wed, Jun 01, 2022 at 12:02:12PM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index a27a6a7bd852..cb3338ef01e0 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1035,6 +1035,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >  			      union bpf_attr __user *uattr)
> >  {
> > +	__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> >  	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> >  	enum bpf_attach_type type = attr->query.attach_type;
> >  	enum cgroup_bpf_attach_type atype;
> > @@ -1042,50 +1043,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >  	struct hlist_head *progs;
> >  	struct bpf_prog *prog;
> >  	int cnt, ret = 0, i;
> > +	int total_cnt = 0;
> >  	u32 flags;
> >  
> > -	atype = to_cgroup_bpf_attach_type(type);
> > -	if (atype < 0)
> > -		return -EINVAL;
> > +	enum cgroup_bpf_attach_type from_atype, to_atype;
> >  
> > -	progs = &cgrp->bpf.progs[atype];
> > -	flags = cgrp->bpf.flags[atype];
> > +	if (type == BPF_LSM_CGROUP) {
> > +		from_atype = CGROUP_LSM_START;
> > +		to_atype = CGROUP_LSM_END;
> Enforce prog_attach_flags for BPF_LSM_CGROUP:
> 
> 		if (total_cnt && !prog_attach_flags)
Correction.  Mixed up with the total_cnt below.

Should be "attr->query.prog_cnt && prog_ids && !prog_attach_flags".

> 			return -EINVAL;
> 			


[ ... ]

> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index a237be4f8bb3..27492d44133f 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> >  	}
> >  }
> >  
> > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> >  
> >  static int bpf_prog_query(const union bpf_attr *attr,
> >  			  union bpf_attr __user *uattr)
> > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> >  	case BPF_CGROUP_SYSCTL:
> >  	case BPF_CGROUP_GETSOCKOPT:
> >  	case BPF_CGROUP_SETSOCKOPT:
> > +	case BPF_LSM_CGROUP:
> >  		return cgroup_bpf_prog_query(attr, uattr);
> >  	case BPF_LIRC_MODE2:
> >  		return lirc_prog_query(attr, uattr);
> > @@ -4066,6 +4067,9 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> >  
> >  	if (prog->aux->btf)
> >  		info.btf_id = btf_obj_id(prog->aux->btf);
> > +	info.attach_btf_id = prog->aux->attach_btf_id;
> > +	if (prog->aux->attach_btf)
> > +		info.attach_btf_obj_id = btf_obj_id(prog->aux->attach_btf);
> Need this also:
> 
> 	else if (prog->aux->dst_prog)
> 		info.attach_btf_obj_id = btf_obj_id(prog->aux->dst_prog->aux->attach_btf);
Should be btf_obj_id(prog->aux->dst_prog->aux->btf) instead.

> 
> >  
> >  	ulen = info.nr_func_info;
> >  	info.nr_func_info = prog->aux->func_info_cnt;
> > -- 
> > 2.36.1.255.ge46751e96f-goog
> > 
