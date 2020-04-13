Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09CD1A6F68
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 00:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389697AbgDMWpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 18:45:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46910 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389691AbgDMWns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 18:43:48 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03DMeeGl000804;
        Mon, 13 Apr 2020 15:44:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=IBD6z51Y4yZ3ZNOaPQnn07cIPDVJYKYFMqlatuhp9Ek=;
 b=AtTrjtL/9juWr8KHGMxH23TCG2mRdGFT9P4stDfkzSLRYiAB7aYGGzUgMsQyP+8BJdyI
 wTIE2+st8bPpoONhkR0BefIboxyAR62w23rvWvOocvLVohqhkd+dEDWTuBYkHckVrewT
 ejw5ngH6lINGa7UG2NWyDklI/FlFbBatT9g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30bbdmahpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Apr 2020 15:44:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 13 Apr 2020 15:44:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+SnFeGxNfV/YF7Bpk9jIwus/a8dfZVyRsHyLohO4nP9jHUb5SckmpYo9FjCkKbvXsvcCKAiigQJs5QCur1MNuM8L3SLVhpqLLAYswmOcV+OUulrDNLlaAc+jkS0O260fSDzwyzXBKs93PVr1VJRUG6V84RhBAXLZ2blFYLACkREHzu5mFqJh7YZ94HUmaX/DM/C/+DMyWElCNEovnd5jdN+fUuzR/fmUb5OdNcgWDBYDO5n2uuNrPXayCin2EjSjdqMCrePq3PnhM3ejIEVcYtWiC7CX1fYVBPftWRfar9Fc9cE+wcz+YXP6YwhmmEp0cnHg34jfq71MrGXTHRBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBD6z51Y4yZ3ZNOaPQnn07cIPDVJYKYFMqlatuhp9Ek=;
 b=O5QZoHuYaoP39pTSbYErVHNK34Xlg2dKS7Kbh0Uo1sKzEuYxzYnLFRnFKAywBgbBpXCcmlkLa+fGdH07faFG9c59G4z/egq8/uGRbG0T5DwEuiB7uP35Tf2W6oXpKlMXaPqidXzBZUDcEwpEAypgrFnYZu3FLoxH8a4tG3EQeFH9W87A3fHR/qEDl5OrRq+eH+8e+mg4MmBNY4aajWYaQZEzg5cfGfk1sn0d+vJe7rmHlYjNHNE3Xbl7lpB3T90v/QyQn70O1qLSkuhviVYsvymQyUy4oI/t0ARpzFglBWsTLF2uG5joCKUzcRL2uuW2Am5FHWQVmTKT8RblCEe2Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBD6z51Y4yZ3ZNOaPQnn07cIPDVJYKYFMqlatuhp9Ek=;
 b=E53V9QLZtSbWwFZ9X2i5ZEkGOeirOixQSrXcClnXwHW0Om66QJ+OtjXzktb9PI5sPR9aKHy5tiuaqlrFZ9I3934wewOCfcFxwpxttcqTv4in2picp0WbOqdhDbrAqHVIMP6ykpfSEHAplG4FM5Q/foJ0msTtgHk9Xkan20MEdQ8=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2918.namprd15.prod.outlook.com (2603:10b6:a03:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Mon, 13 Apr
 2020 22:44:15 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 22:44:15 +0000
Date:   Mon, 13 Apr 2020 15:44:12 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: always specify expected_attach_type on
 program load if supported
Message-ID: <20200413224412.GA44785@rdna-mbp.dhcp.thefacebook.com>
References: <20200412055837.2883320-1-andriin@fb.com>
 <20200413202126.GA36960@rdna-mbp.dhcp.thefacebook.com>
 <CAEf4Bzbf7kuzTnq6d=Jh+hRdUi++vxabZz2oQU=hPh52rztbgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbf7kuzTnq6d=Jh+hRdUi++vxabZz2oQU=hPh52rztbgg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:300:117::31) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:f8c7) by MWHPR03CA0021.namprd03.prod.outlook.com (2603:10b6:300:117::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Mon, 13 Apr 2020 22:44:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:f8c7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86ab19ec-973f-4c3b-2ea5-08d7dffc318a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2918:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2918688CC41AB70A290854F6A8DD0@BYAPR15MB2918.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 037291602B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(376002)(39860400002)(396003)(366004)(136003)(6916009)(16526019)(186003)(4326008)(86362001)(66476007)(9686003)(8936002)(66946007)(66556008)(33656002)(52116002)(6496006)(53546011)(316002)(54906003)(30864003)(5660300002)(6486002)(966005)(1076003)(81156014)(2906002)(8676002)(478600001);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxNNjR34yPsk/dx6phnz1xJ553DLBUuwsdlLZ60cJziLCl8TNjGJ+APmOzj71s1ehmd5NiwZ7YS61+uJn85YXckcV+2LkmDTUjhYsWc8m57iQQuS833ct9ROO0IXajiSfUkkrXOfsYGpxUC33tKXp7szrLVf/xPmWPpJntow6j6tcgAu1KWNqgb7W/C+TmbLDQFYfLS4kJ0YsZv/xfZAs0TwoyxUf9eYwXh3Ei/RJXiLY9XCihJviFhLciHbE+pzfMXGyqesll2qXbnin2B9lf3V9IShWC5I52H/Ffi6rK9NteSJbgEeoU+CF7DR4L+6FttzmIvOvLp/FOfhPd/4PnbHdmljLYGIIV4ApS1R4BeOLx+zussU6fUP1cHgsT+Ovz/28/uJ5oPGbibfIkg1sZwU2Xtdzu3c0HXvx52ka5ceDz9JyS2B+F2Smoc9Ii2onEUcS6ZaBAHuKW9DHwpiz7MFFmHH+FhNhSqq9TNxPecX6mx3F2CMW9ucXpl8ElFR79c9rUZhiG/+jclCyLlS2Q==
X-MS-Exchange-AntiSpam-MessageData: WShDAvebLxAxJB9ZwOrSW7bHVyz6D2x9Z5x86WOqqIg752MqwjNWrby9gCn0PuqCDX13oZv4eeEE9e9rTvJaSZg0HYrAesh+/PkMAycj6levSq8fKzuwCw/xvmFCx5ZisI3EJnSbxj8WFUjmcZSqwYkIcX+qR+EfBZ1LvUFM3coquO8PNjsuNVgLsiAAltXV
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ab19ec-973f-4c3b-2ea5-08d7dffc318a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2020 22:44:15.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NnUURgFgnO1NWFWhmt8lFmOp/jj5WZQ/ADyYwG8hjrw1lYaqNbIuMaHRahddZZO4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2918
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_11:2020-04-13,2020-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> [Mon, 2020-04-13 15:00 -0700]:
> On Mon, Apr 13, 2020 at 1:21 PM Andrey Ignatov <rdna@fb.com> wrote:
> >
> > Andrii Nakryiko <andriin@fb.com> [Sat, 2020-04-11 22:58 -0700]:
> > > For some types of BPF programs that utilize expected_attach_type, libbpf won't
> > > set load_attr.expected_attach_type, even if expected_attach_type is known from
> > > section definition. This was done to preserve backwards compatibility with old
> > > kernels that didn't recognize expected_attach_type attribute yet (which was
> > > added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But this
> > > is problematic for some BPF programs that utilize never features that require
> > > kernel to know specific expected_attach_type (e.g., extended set of return
> > > codes for cgroup_skb/egress programs).
> > >
> > > This patch makes libbpf specify expected_attach_type by default, but also
> > > detect support for this field in kernel and not set it during program load.
> > > This allows to have a good metadata for bpf_program
> > > (e.g., bpf_program__get_extected_attach_type()), but still work with old
> > > kernels (for cases where it can work at all).
> > >
> > > Additionally, due to expected_attach_type being always set for recognized
> > > program types, bpf_program__attach_cgroup doesn't have to do extra checks to
> > > determine correct attach type, so remove that additional logic.
> > >
> > > Also adjust section_names selftest to account for this change.
> > >
> > > More detailed discussion can be found in [0].
> > >
> > >   [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.thefacebook.com/
> > >
> > > Reported-by: Andrey Ignatov <rdna@fb.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c                        | 123 +++++++++++-------
> > >  .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
> > >  2 files changed, 106 insertions(+), 59 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index ff9174282a8c..925f720deea0 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -178,6 +178,8 @@ struct bpf_capabilities {
> > >       __u32 array_mmap:1;
> > >       /* BTF_FUNC_GLOBAL is supported */
> > >       __u32 btf_func_global:1;
> > > +     /* kernel support for expected_attach_type in BPF_PROG_LOAD */
> > > +     __u32 exp_attach_type:1;
> > >  };
> > >
> > >  enum reloc_type {
> > > @@ -194,6 +196,22 @@ struct reloc_desc {
> > >       int sym_off;
> > >  };
> > >
> > > +struct bpf_sec_def;
> > > +
> > > +typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
> > > +                                     struct bpf_program *prog);
> > > +
> > > +struct bpf_sec_def {
> > > +     const char *sec;
> > > +     size_t len;
> > > +     enum bpf_prog_type prog_type;
> > > +     enum bpf_attach_type expected_attach_type;
> > > +     bool is_exp_attach_type_optional;
> > > +     bool is_attachable;
> > > +     bool is_attach_btf;
> > > +     attach_fn_t attach_fn;
> > > +};
> > > +
> > >  /*
> > >   * bpf_prog should be a better name but it has been used in
> > >   * linux/filter.h.
> > > @@ -204,6 +222,7 @@ struct bpf_program {
> > >       char *name;
> > >       int prog_ifindex;
> > >       char *section_name;
> > > +     const struct bpf_sec_def *sec_def;
> > >       /* section_name with / replaced by _; makes recursive pinning
> > >        * in bpf_object__pin_programs easier
> > >        */
> > > @@ -3315,6 +3334,32 @@ static int bpf_object__probe_array_mmap(struct bpf_object *obj)
> > >       return 0;
> > >  }
> > >
> > > +static int
> > > +bpf_object__probe_exp_attach_type(struct bpf_object *obj)
> > > +{
> > > +     struct bpf_load_program_attr attr;
> > > +     struct bpf_insn insns[] = {
> > > +             BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +             BPF_EXIT_INSN(),
> > > +     };
> > > +     int fd;
> > > +
> > > +     memset(&attr, 0, sizeof(attr));
> > > +     attr.prog_type = BPF_PROG_TYPE_CGROUP_SOCK;
> > > +     attr.expected_attach_type = BPF_CGROUP_INET_EGRESS;
> >
> > Could you clarify semantics of this function please?
> >
> > According to the name it looks like it should check whether
> > expected_attach_type attribute is supported or not. But
> > BPF_CGROUP_INET_EGRESS doesn't align with this since
> > expected_attach_type itself was added long before it was supported for
> > BPF_CGROUP_INET_EGRESS.
> >
> > For example 4fbac77d2d09 ("bpf: Hooks for sys_bind") added in Mar 2018 is
> > the first hook ever that used expected_attach_type.
> >
> > aac3fc320d94 ("bpf: Post-hooks for sys_bind") added a bit later is the
> > first hook that made expected_attach_type optional (for
> > BPF_CGROUP_INET_SOCK_CREATE).
> >
> > But 5cf1e9145630 ("bpf: cgroup inet skb programs can return 0 to 3") for
> > BPF_CGROUP_INET_EGRESS was merged more than a year after the previous
> > two.
> 
> I'm checking if kernel is rejecting non-zero expected_attach_type
> field in bpf_attr for BPF_PROG_LOAD command.
> 
> Before 5e43f899b03a ("bpf: Check attach type at prog load time"),
> kernel would reject non-zero expected_attach_type because
> expected_attach_type didn't exist in bpf_attr. So if that's the case,
> we shouldn't specify expected_attach_type.
> 
> After that commit, BPF_CGROUP_INET_EGRESS for
> BPF_PROG_TYPE_CGROUP_SOCK would be supported, even if it is optional,
> so using that combination should work.
> 
> Did I miss something?

So you're saying that there is nothing special about
BPF_CGROUP_INET_EGRESS, you just need _any_ attach type and it just
happened so that you used this one.

That sounds fine, but could you clarify it with a comment please,
otherwise it looks confusing: "why BPF_CGROUP_INET_EGRESS and not some
other attach type, for example any of those which got optional
expected_attach_type earlier, what's so special about
BPF_CGROUP_INET_EGRESS".

Also, I just realized that this combination: BPF_PROG_TYPE_CGROUP_SOCK and
BPF_CGROUP_INET_EGRESS is incorrect: BPF_CGROUP_INET_EGRESS attach type
corresponds to BPF_PROG_TYPE_CGROUP_SKB prog type, not to
BPF_PROG_TYPE_CGROUP_SOCK. This call will always fail with EINVAL on new
kernels, because of this code in bpf_prog_load_check_attach:

	switch (prog_type) {
	case BPF_PROG_TYPE_CGROUP_SOCK:
		switch (expected_attach_type) {
		case BPF_CGROUP_INET_SOCK_CREATE:
		case BPF_CGROUP_INET4_POST_BIND:
		case BPF_CGROUP_INET6_POST_BIND:
			return 0;
		default:
			return -EINVAL;
		}

That should be fixed.

And since this has to be changed anyway I'd go with BPF_PROG_TYPE_CGROUP_SOCK
and BPF_CGROUP_INET_SOCK_CREATE combination since this is the very first
combination in kernel that relied on optional expected_attach_type -- that
would make more sense IMO. And clarifying comment as mentioned above :)

> > > +     attr.insns = insns;
> > > +     attr.insns_cnt = ARRAY_SIZE(insns);
> > > +     attr.license = "GPL";
> > > +
> > > +     fd = bpf_load_program_xattr(&attr, NULL, 0);
> > > +     if (fd >= 0) {
> > > +             obj->caps.exp_attach_type = 1;
> > > +             close(fd);
> > > +             return 1;
> > > +     }
> > > +     return 0;
> > > +}
> > > +
> > >  static int
> > >  bpf_object__probe_caps(struct bpf_object *obj)
> > >  {
> > > @@ -3325,6 +3370,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
> > >               bpf_object__probe_btf_func_global,
> > >               bpf_object__probe_btf_datasec,
> > >               bpf_object__probe_array_mmap,
> > > +             bpf_object__probe_exp_attach_type,
> > >       };
> > >       int i, ret;
> > >
> > > @@ -4861,7 +4907,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> > >
> > >       memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
> > >       load_attr.prog_type = prog->type;
> > > -     load_attr.expected_attach_type = prog->expected_attach_type;
> > > +     /* old kernels might not support specifying expected_attach_type */
> > > +     if (!prog->caps->exp_attach_type && prog->sec_def &&
> > > +         prog->sec_def->is_exp_attach_type_optional)
> > > +             load_attr.expected_attach_type = 0;
> > > +     else
> > > +             load_attr.expected_attach_type = prog->expected_attach_type;
> >
> > I'm having a hard time checking whether it'll work for all cases or may
> > not work for some combination of prog/attach type and kernel version
> > since there are many subtleties.
> >
> > For example BPF_PROG_TYPE_CGROUP_SOCK has both a hook where
> > expected_attach_type is optional (BPF_CGROUP_INET_SOCK_CREATE) and hooks
> > where it's required (BPF_CGROUP_INET{4,6}_POST_BIND), and there
> > bpf_prog_load_fixup_attach_type() function in always sets
> > expected_attach_type if it's not yet.
> 
> Right, so we use the fact that they are allowed, even if optional.
> Libbpf should provide correct expected_attach_type, according to
> section definitions and kernel should be happy (unless user specified
> wrong section name, of course, but we can't help that).
> 
> >
> > But I don't have context on all hooks that can be affected by this
> > change and could easily miss something.
> >
> > Ideally it should be verified by tests. Current section_names.c test
> > only verifies what will be returned, but AFAIK there is no test that
> > checks whether provided combination of prog_type/expected_attach_type at
> > load time and attach_type at attach time would actually work both on
> > current and old kernels. Do you think it's possible to add such a
> > selftest? (current libbpf CI supports running on old kernels, doesn't
> > it?)
> 
> So all the existing selftests are essentially verifying this, if run
> on old kernel. I don't think libbpf currently runs tests on such old
> kernels, though. But there is no extra selftest that we need to add,
> because every single existing one will execute this piece of libbpf
> logic.

Apparently existing tests didn't catch the very obvious bug with
BPF_PROG_TYPE_CGROUP_SOCK / BPF_CGROUP_INET_EGRESS invalid combination.

I think it'd be useful to start with at least basic test focused on
expected_attach_type. Then later extend it to new attach types when they're
being added and, ideally, to existing ones.


> > > +     pr_warn("prog %s exp_Attach %d\n", prog->name, load_attr.expected_attach_type);
> > >       if (prog->caps->name)
> > >               load_attr.name = prog->name;
> > >       load_attr.insns = insns;
> > > @@ -5062,6 +5114,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
> > >       return 0;
> > >  }
> > >
> 
> trimming irrelevant parts is good ;)

ack

-- 
Andrey Ignatov
