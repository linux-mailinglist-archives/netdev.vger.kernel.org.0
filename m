Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714B12B7354
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgKRAq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:46:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgKRAq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:46:58 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI0hdBC030038;
        Tue, 17 Nov 2020 16:46:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=05Kk6U2RWn265I7vDdvZbUiWiMU6ha4x65L8loJ3DNM=;
 b=qLidpKz85lmBLEFwok0E2j6I38/Rah4ZQDk7HoGanQ4txnNsQCjqDZ+EN1u1w0qZIYGB
 rMwuzyXRxmy6G/L/MS032hvlCz1A7eb89GcD2xDAKsdQnMcpSRx8BIBrEKWywkdYwRL/
 sbJNCnVDwWWr+lBDff509O7OkpuOrJuWdb0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34tyxqxs6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 16:46:42 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 16:46:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8DgckQnWAjKG9SQ9drBruq9xGuY8KMZCDgVnzIbvDWD/eE52S/a707RWTCW98+8k24vHd8khDeg6hcdsQl1dEKw8U5KTwh10o4Z4b1BnzzJZZslphTEisHiXtLqTW3F5h8Tcy7CKEa+SUMim7RQFzucMUge7+BfIfH/yaaYIyfj1tU+2AMY+Ot1K5HM3nUIDuafRX/8ea3tT5gObIAkMeuyVDjYqXVFKLTRdBDH8Np2gaS7aYQv4iUHx7RqF7NRGbToNRjCnPdjPfSWkUHwXfsDrOvP0ElIdCIuSKYpt8zwaxgoiiTp7U9NIybd+5hwcyzTUyRey20BIFV3Ls0uTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05Kk6U2RWn265I7vDdvZbUiWiMU6ha4x65L8loJ3DNM=;
 b=dH061z/Val8ntr9nyQBP5FaeJaQRMdpUN5j8rBV07pDfpmsl7cphEEO/R77wkT8BxKR9Xny5Np0KgDUiT5VfI0ry7I6l5bILd226582CFm9sTq6or6VO2GuyI4HTWTc4IssC/uqlVBEkIV/hlqtx6wLHvldWdnHgguPVG6ujdngy8veKImkL6xcDA34QUDS9BUyw1w1iD4ze4xe3wgoLZgXUAPBF1LuxiU1n28rnF4ofCGI8XRO41KbZqx/YW0S2ZVPfNE1J9EF0b1TEZeOlU1CSnics8m9nnFyelCgl/nzSmyocnVKqXB/UyJhL4rBHUbcd9wGF2IEpviZKRQrM+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05Kk6U2RWn265I7vDdvZbUiWiMU6ha4x65L8loJ3DNM=;
 b=GXNVLU36fsRMo5g7F11fsAQP9cWm56f4uQYVtMniQbK4FAhloCXJl8j8K2QCMgp2hFe8J7VXjVn9DCn2/im6+/NK5PGgmRD91WUwrEawyk3dLKlZenf3YZAWuifTSvdUuGbAiDnWoraTFoZMnYh5eQ+cAWPk6Yd6z0MT8vOAzh0=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3078.namprd15.prod.outlook.com (2603:10b6:a03:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 00:46:40 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3564.031; Wed, 18 Nov 2020
 00:46:40 +0000
Date:   Tue, 17 Nov 2020 16:46:34 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
References: <20201117034108.1186569-1-guro@fb.com>
 <20201117034108.1186569-7-guro@fb.com>
 <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:fcd7]
X-ClientProxiedBy: CO2PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:102:2::33) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:fcd7) by CO2PR05CA0065.namprd05.prod.outlook.com (2603:10b6:102:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Wed, 18 Nov 2020 00:46:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05054820-0369-4a59-554e-08d88b5b6934
X-MS-TrafficTypeDiagnostic: BYAPR15MB3078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30788C1418DCB87C2C0A9CF1BEE10@BYAPR15MB3078.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rrtl0+2zZhL+iBuoet4fdsGoAb3GoA6wjz4q2ly4pIo5Pw79bPuwLTUZh7Qoet211mi2L/U+D+2TtchjD8PrehQbsxY45nibwwfBseHl2GEuuidCCNsb7XKiZZKST05T3fyT+ZFusjzcERrOKsaOaoQl/HoFCRahgJ0A0JA2YxT9xZv0ZRaKATEAa1jKnuEOhJN4ppJokeUcJWV8LslXgrUaN5sNqp87oHwxyEH1aS8NNqoJuDIzEBzwltr8ChAOU/mqN9V3pa8EvdIFb3bzNlyfmuMB+N04WTNDImIeMexrv6jnTGiXqD8UzYk1rRc/UwoGIOXI+5+0ltjCHpzvwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(376002)(366004)(316002)(6916009)(2906002)(186003)(33656002)(1076003)(7696005)(52116002)(53546011)(6506007)(6666004)(16526019)(5660300002)(8676002)(8936002)(66556008)(86362001)(66476007)(83380400001)(55016002)(15650500001)(66946007)(4326008)(478600001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: d2016z6nQTLPOlL7UK/O+ywwvugMCe70sP/H22c7eDjgIQGaohksHZQh3P6H4DcShhkewKXPEeKkUs9LS4cAxL0OhQ5G6IQJlL/bBXTzx8LmFdmG5r8+vG4hlcy8zmBblyGnEIOyd2jIx7YYL7IAAS+aB4XVOhvBQ5OwgR+/y/PwdHhpVev3RVc4tKVlA11t/YsfU+Pmzs4cCmjYSvMjrf3/auVf5WF3vQVYAnlp3K4urXbvR5QFc2i44UNeI6YEw3SnRwQpiNw5PId0cpOhadkOEy6bTjjuYT2MFCbGAQqZOfjsxGe+K10bMjiInAhx1nOUjSiru2tAIk2hyGv84uEysawGtJxSeIVtnRdlIw6oE2sySK9Kxg6XYqI8z/+oMkGdO9yskY3T6XiWVCd0AT+MvSsk9bh9nwJkXc/Ec4sDWCwOgdKJFCAMvFhQUOBPyNFcYN7BjVSj8OmpKdI31LtNylDQJxGNDiCsK2Gee0UJzkPrNbhFvW9Dg4fHHc+XWe5UyrlaDQESOP6PbwrVifbCLXajR+SFWk1UCPhQL+0BLqu4WidKelnNKqQcSEbZXm/Pb/0mEMXhu5DvuXiAOYehe1rKGt8Gc7he4sETDfRf/xL+HXpfyLzOOxa5yc4A/reA8Zg4PjlM7lENhl7RNzOviTVTneDNDvmvv0grQ9s=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05054820-0369-4a59-554e-08d88b5b6934
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 00:46:40.0285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5wJcmZBlcySEUWrXlOTzMQaNwqzn4VeeiCrfIybCnG2qSM8iWARXaLEq5oqw9ze
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3078
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0 suspectscore=1
 malwarescore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 01:06:17AM +0100, Daniel Borkmann wrote:
> On 11/17/20 4:40 AM, Roman Gushchin wrote:
> > In the absolute majority of cases if a process is making a kernel
> > allocation, it's memory cgroup is getting charged.
> > 
> > Bpf maps can be updated from an interrupt context and in such
> > case there is no process which can be charged. It makes the memory
> > accounting of bpf maps non-trivial.
> > 
> > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> > memcg accounting from interrupt contexts") and b87d8cefe43c
> > ("mm, memcg: rework remote charging API to support nesting")
> > it's finally possible.
> > 
> > To do it, a pointer to the memory cgroup of the process which created
> > the map is saved, and this cgroup is getting charged for all
> > allocations made from an interrupt context.
> > 
> > Allocations made from a process context will be accounted in a usual way.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> [...]
> > +#ifdef CONFIG_MEMCG_KMEM
> > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > +						 void *value, u64 flags)
> > +{
> > +	struct mem_cgroup *old_memcg;
> > +	bool in_interrupt;
> > +	int ret;
> > +
> > +	/*
> > +	 * If update from an interrupt context results in a memory allocation,
> > +	 * the memory cgroup to charge can't be determined from the context
> > +	 * of the current task. Instead, we charge the memory cgroup, which
> > +	 * contained a process created the map.
> > +	 */
> > +	in_interrupt = in_interrupt();
> > +	if (in_interrupt)
> > +		old_memcg = set_active_memcg(map->memcg);
> > +
> > +	ret = map->ops->map_update_elem(map, key, value, flags);
> > +
> > +	if (in_interrupt)
> > +		set_active_memcg(old_memcg);
> > +
> > +	return ret;
> 
> Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
> retpoline for lookup/update/delete calls on maps") which removes the indirect
> call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
> not invoked for the vast majority of cases.

I see. Well, the first option is to move these calls into map-specific update
functions, but the list is relatively long:
  nsim_map_update_elem()
  cgroup_storage_update_elem()
  htab_map_update_elem()
  htab_percpu_map_update_elem()
  dev_map_update_elem()
  dev_map_hash_update_elem()
  trie_update_elem()
  cpu_map_update_elem()
  bpf_pid_task_storage_update_elem()
  bpf_fd_inode_storage_update_elem()
  bpf_fd_sk_storage_update_elem()
  sock_map_update_elem()
  xsk_map_update_elem()

Alternatively, we can set the active memcg for the whole duration of bpf
execution. It's simpler, but will add some overhead. Maybe we can somehow
mark programs calling into update helpers and skip all others?

What do you think?

Thanks!
