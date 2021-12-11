Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29C9471004
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 02:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbhLKCA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:00:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36600 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229462AbhLKCA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:00:56 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAKJIXC013720;
        Fri, 10 Dec 2021 17:57:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pi+UQf4bppN3E5f0RGJomncJDEbY5gHDpekkGSi05rM=;
 b=LCNcTYq9F8s1WSJh0yryVXI7FpfAr6eUenYyC6bSrkXnDNpIOmAOFybObFsaT1xfPl1j
 toyUEKBpwu5+dOKYLLbgxC5BcZTDHdGVBTcpAzpl//a21xNjWeYWU+li0tAwvcD6yunv
 svopAvgG/6aH2K6U4KQA2inGuNw8lRNgRxc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cvcqd27g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Dec 2021 17:57:07 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 17:57:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YX6xec0V46xtkM9dWvpzbpjAu0CsuOenlYeUKPo/PAQWQugwFNhL1YMgRb496Ad6gARHK8yCRoISxjzRkUVL/hEJe3uztWPnX6SKh0KBtugNY2fmmiJh1fOlOoxM5fVTUjhXWyNnTI0Tu2CEOUjRY4/FOoSEknnjh0YyrXkxvzu0FONVKBbhGuE2uLc6Na4omOyYD9GYhSy4zZZaL12BXLwqaZGXTkTIcg8J2D3LYKeeMhSGcT0HoywzD6RKV0NeQSoKXehE3hY9TDKACrJEc5ujsmiamquVIB211/LKD4l0gXdw7VoVJd/zo6LaF6dfKeJpt+l4rCd5avrnNKosqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pi+UQf4bppN3E5f0RGJomncJDEbY5gHDpekkGSi05rM=;
 b=a6DlUzNFImJiaUrpAh2NUIYNDz1eTxRU0EAXlFaJZrgM4G3LZ4oWXEozc7xp1mB3RBXRDaXU0e+zNRvslYwrQ3J9TnDKraG5Xf0Yp77VAn+b4JigtuB2H8oKXkBQHy+DTRd6XuGwbsKH2PkzdqkYi486UGyOuQOgxU44vukg2sL+Hq1RMG8Etc17LOSJnSSF7KTHtdfMf+lC52iz+yBYmTOViqqEbfDwu75REMkBLsJ6gB5FNcTehoAWteJVS6pcZPtA8/2Jz9/u/sv1AAkZ4cfZLaa58a0o8HFQ+BsY+zrYuikxbdlPfy+k48VorwvFwXh8OE4pdSBIjAJ4z2kFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5046.namprd15.prod.outlook.com (2603:10b6:806:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sat, 11 Dec
 2021 01:57:00 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Sat, 11 Dec 2021
 01:57:00 +0000
Date:   Fri, 10 Dec 2021 17:56:56 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb
 BPF filtering
Message-ID: <20211211015656.tvufcnh5k4rrc7sw@kafai-mbp.dhcp.thefacebook.com>
References: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
 <20211211003838.7u4lcqghcq2gqvho@kafai-mbp.dhcp.thefacebook.com>
 <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5f7d2f60-b833-04e5-7710-fdd2ef3b6f67@gmail.com>
X-ClientProxiedBy: MW4PR04CA0290.namprd04.prod.outlook.com
 (2603:10b6:303:89::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:acd1) by MW4PR04CA0290.namprd04.prod.outlook.com (2603:10b6:303:89::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Sat, 11 Dec 2021 01:56:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04260dfc-ed0b-4fdd-c0ea-08d9bc4984fb
X-MS-TrafficTypeDiagnostic: SA1PR15MB5046:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB504646EBE1134B6D389971E1D5729@SA1PR15MB5046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHiJoYJZp9AA5vaPNvB/iShKREABCjn1zZbrrYhtxBRk065PnhZ27WvzFRkeShfPdobkqs5ufpcb0xduVnc4kJCrZHMyJqZrL0Wo/Hq44LyT0BFxWwCW5RtZdgwsqtTvwpw0FrqQ78GM56ApFF/EbpToKzRGZ3MlyJ9Q8eq4VeeeI1XBXHOZC2QLp7uKGSE2c69ZnuaziIBulczpgoMQAmg+4EbhdNDfL/YyVTKnY6H7Hcz5Q2d6pe3FOGKK9D+HZtNhB4NjXQynPr8UrYF42GfUpbExAY62EBNnzlA/dy/VQuaCYMkicejrb3OM6S26JTMPYJb6a5orhoInM1LX/s05w6+a3lw/Di+tAuWyBv9J4Qkauhn4GUFPCiuITxAok88nIrw1TCakRpWH1gdeyw6yO5l3A9qvPcmdvYN+nWb8pTClmguIE9pzg8o8GjMziiafgTq5MiR1hL2Z9qWpMaUEdzsvZRjVUMJz7t2xy8cPUggjo07blqde50EzSSf409gB+Igvx9mf0hAm5ZqOJiN3d8UJW7uAYb8XOsLSUSZhCY92q4e3UZMB3PNQ6/gM/nwhjmNs6wq+sh9RfS1MXfcl+ejkDsjcoT+2njE7E2bqqY19PTPdTL3TQ74jBWRzWZKoXHHm6FZ9Ek8DwJl2Tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(53546011)(2906002)(5660300002)(86362001)(9686003)(186003)(54906003)(8676002)(6916009)(4326008)(55016003)(6506007)(8936002)(66946007)(316002)(1076003)(6666004)(52116002)(66476007)(508600001)(83380400001)(38100700002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AwJui23Y4+c+ALkwMOwsrz+iH5B73RcruPXRGz7qB6XRxcCE4PDoKPgYg9JF?=
 =?us-ascii?Q?b5s4stbxbKRILKPWqIVgYYTiM5qGobFcy/mGFF4b887Dn7pyW84AEmtDTTTc?=
 =?us-ascii?Q?2TtL2vy4F69pDpC7lZ45l/VVW28xQ+HOGfIJTv1nFMH6wWNjkt60ZgtqgtIx?=
 =?us-ascii?Q?Uu6GSlaLW62gRcja+hwMUDmxeYEKPH+GhMFiwjxC/96zMPPUJLJi2jrHS3+M?=
 =?us-ascii?Q?ee/UPGPwZqtMwfWos1IfobRaovMYbIXmSvk/hhPjbhtkB6K9xWaPppbBO/rV?=
 =?us-ascii?Q?2BKI2pvMJ8eqkdEWYKKJ0VbzJQbbR0VvzHrQ3R2EnBmgqDnbICdkuZCYw8KX?=
 =?us-ascii?Q?SFjS2GqDUmM8f4e1tiNNYkkm3hDwmuZKo1+5dl3bGH22UwWJC7fvOr3EEa0m?=
 =?us-ascii?Q?ZZWxNwvZ2vqbUmd9K22yDhkqVHv5mt4+MRGLv7eU2F8AMgaGZuzeUZq4ePvR?=
 =?us-ascii?Q?d+lnSypoziT9+bXzMiaBAHLuqounB575rSapsVsaTdeo6Twl9Rd8TtiAs+WI?=
 =?us-ascii?Q?DKgXlz0isTh00a+6LzBKaDuXyfK7Ypq0wF7Mvxf2vtAwxohFfwwo5IwMY1pV?=
 =?us-ascii?Q?HBCSzdG1/MaYpNLoHQy8bYEfUI10Orp7peKU3oV4cJLEovK6UpIC16gG0j29?=
 =?us-ascii?Q?ch2lFk5U5OkiCXWn+ADq5IRO9LCDvpYKiTzDc6XWr7I23EyJLI0lCuIa0XAr?=
 =?us-ascii?Q?U6DnBREaBWUy0R7QgV3VXaejmns0AHVsyaZpoSeBz7U0kZFPVWXziUjWd45A?=
 =?us-ascii?Q?dH7ZOs8WyAYeQXmGagw+P524UyZL0pjAcMkHE/fiiwLyLrrq+ozFmWIUaWvu?=
 =?us-ascii?Q?CWfJRTzUdi+auWQghqB059vVLT1VpLz40c2huOxKYy3QE8t3oR/Y2ISMWAjI?=
 =?us-ascii?Q?DIhVIoTExG1XFkkagnwLSbmi+TZcIUeWR5oS74FakwigBb7GQkwEHNK6EjTg?=
 =?us-ascii?Q?RZFup/vA6+pUtQ7vcbZStBcsNyE/XfLHq6TrZn8Ni+j+Wv9OQNjHaBAPg1Mu?=
 =?us-ascii?Q?N4NXUGADLcLV4oqCOGzvHaWh4ji4wcrwWkWspHEaOSTewF8U0B3FZbvLGUup?=
 =?us-ascii?Q?+NmtCNBMa4+MX/cYJyRXWWrtx5zdV3eKG6TTvTS2nd2YIcnXd28zFyE7wTqb?=
 =?us-ascii?Q?ExKRgQuziM0Yk9jvkYhhH7AKg5uYwqlv8tQFsjVZE1OH0Sjx4IyD+oel1H/j?=
 =?us-ascii?Q?zCwGRb3YGms+P0sWMezLM8+keZX3oMGqkvQ3h/YnBLOWDT+N52pgSjjOCGDk?=
 =?us-ascii?Q?eNpIfKll2klpyi5Fuc45NtYNkUhgnmYqvswibQh8zeaxiNcTYNP4ty0h9thG?=
 =?us-ascii?Q?xoL+BmdGEDh17VFRzJsSyZuYkcHNQt1HYJyxEKHL5XnwItJVXFjus9l96bBT?=
 =?us-ascii?Q?e5bwSWbT7bWE/V4RmGK105uXHIWrL5lEawpcZrvwnFi9nqY4RTz/VN41jEVl?=
 =?us-ascii?Q?M+LrrEWrm2eL9h/DKU29qt6kvGJ7T6+/XpZFXjexY3qHdKuXLokOsft0hFzc?=
 =?us-ascii?Q?7D867IWKu7kMvoaqh5qZIv3rYbFQOUO6ECpXGa3Jjtnk3gVvz2JQ6/IaZsPk?=
 =?us-ascii?Q?47+RTTxYKhhKsd4MY9v6aF3YEmx2dMB3kT2Qz7nJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04260dfc-ed0b-4fdd-c0ea-08d9bc4984fb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 01:57:00.2328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zp3TIU716/x4n8NsTluU8hA85VLvF2YxpT93awhO7OTdGelzz4tMBtNd6NCmMvGp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5046
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: pkyl2SU2Oz3A6swOS0vBLZkg61Z01o4E
X-Proofpoint-GUID: pkyl2SU2Oz3A6swOS0vBLZkg61Z01o4E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_09,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 mlxscore=0 mlxlogscore=446 lowpriorityscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112110009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 01:15:05AM +0000, Pavel Begunkov wrote:
> On 12/11/21 00:38, Martin KaFai Lau wrote:
> > On Fri, Dec 10, 2021 at 02:23:34AM +0000, Pavel Begunkov wrote:
> > > cgroup_bpf_enabled_key static key guards from overhead in cases where
> > > no cgroup bpf program of a specific type is loaded in any cgroup. Turn
> > > out that's not always good enough, e.g. when there are many cgroups but
> > > ones that we're interesting in are without bpf. It's seen in server
> > > environments, but the problem seems to be even wider as apparently
> > > systemd loads some BPF affecting my laptop.
> > > 
> > > Profiles for small packet or zerocopy transmissions over fast network
> > > show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
> > > migrate_disable/enable(), and similarly on the receiving side. Also
> > > got +4-5% of t-put for local testing.
> > > 
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >   include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
> > >   kernel/bpf/cgroup.c        | 23 +++++++----------------
> > >   2 files changed, 28 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > > index 11820a430d6c..99b01201d7db 100644
> > > --- a/include/linux/bpf-cgroup.h
> > > +++ b/include/linux/bpf-cgroup.h
> > > @@ -141,6 +141,9 @@ struct cgroup_bpf {
> > >   	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
> > >   	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
> > > +	/* for each type tracks whether effective prog array is not empty */
> > > +	unsigned long enabled_mask;
> > > +
> > >   	/* list of cgroup shared storages */
> > >   	struct list_head storages;
> > > @@ -219,11 +222,25 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
> > >   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> > >   				     void *value, u64 flags);
> > > +static inline bool __cgroup_bpf_type_enabled(struct cgroup_bpf *cgrp_bpf,
> > > +					     enum cgroup_bpf_attach_type atype)
> > > +{
> > > +	return test_bit(atype, &cgrp_bpf->enabled_mask);
> > > +}
> > > +
> > > +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> > > +({									       \
> > > +	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
> > > +									       \
> > > +	__cgroup_bpf_type_enabled(&__cgrp->bpf, (atype));		       \
> > > +})
> > I think it should directly test if the array is empty or not instead of
> > adding another bit.
> > 
> > Can the existing __cgroup_bpf_prog_array_is_empty(cgrp, ...) test be used instead?
> 
> That was the first idea, but it's still heavier than I'd wish. 0.3%-0.7%
> in profiles, something similar in reqs/s. rcu_read_lock/unlock() pair is
> cheap but anyway adds 2 barrier()s, and with bitmasks we can inline
> the check.
It sounds like there is opportunity to optimize
__cgroup_bpf_prog_array_is_empty().

How about using rcu_access_pointer(), testing with &empty_prog_array.hdr,
and then inline it?  The cgroup prog array cannot be all
dummy_bpf_prog.prog.  If that could be the case, it should be replaced
with &empty_prog_array.hdr earlier, so please check.
