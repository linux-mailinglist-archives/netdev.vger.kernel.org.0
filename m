Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668FA1BE687
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgD2Sqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:46:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726423AbgD2Sqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:46:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TIilvO031666;
        Wed, 29 Apr 2020 11:46:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Xhsohvjl9zNb78vni3rhnDcBQ+MO7oPrVkMgl9aknm8=;
 b=Jkm/lfCXmrELbPxL+6Uytc34FJgj+b/bWpqYPI5HDWP+LlSF256No6AN9Zg+koQCALdu
 CYZqS4GILxWTeGWoSIw3nGxD0LwgOEN8szGqL4qfw9/4XDsTPBCgjSqey56gR7919szc
 oAV7eX2h8J2vwYHZ6PrZm2RF4/N1HGdftyY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54eruhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 11:46:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 11:46:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/30qd6DLsuHiTnVjGNnn5Pn/Bmlw+dMs9vvHOv8oPcIU2KxqU/iHAbTShd/7TwEUPSHCcZ/G6BJ6623hsE0S1M4bCslAuhmIsJk68k7eX/QyP83MCKjuSJN4ds74yDpWW41P072hYLUUv5pjiXefNzivA6OjD4Udim3Mm85F36SYMcEMW4g7QjkfMdsBwNT0jIHR7lcP8PZnRZ2JaDt5pzP0975wLYWQ5W4iS+dwzeDU4XXnU8ZyJeO2t6emxZkqKEg6JXOgLajnSlLzEqiQaph0Uas4sY2iJzbM5iNXtjj5TYyGB5/NQF25j2qcqXfdj/6rxbu4ezil2bIcH02qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xhsohvjl9zNb78vni3rhnDcBQ+MO7oPrVkMgl9aknm8=;
 b=ZXL17qjH4shzNn78Wvvc7eJfgfzesVut745UZZgGwDb2iQoGVfNb1eM2DB5gpkoA8GEUdm8psXXN06F51q1QK8xV0490ZWxi+EpdFFNl3euMqL5XXTVjGPCu8c5mSawuHcj6Wkm/PZTU2P6gFvryciqB/wcAcGLMg1qYVU2lA8k7yLhSzAYd7NhuKRi3cs61vil4uglyoTLdRp8OwxC+OS0FQZeuKNrCky6MYf6iqQSPF93SygRlaxOzT4FqR9vqXgAg0T4N7QQKiXnPoSISFRYB0ATbvZrFpfm615e9YoXAxNYc4MY+oJxwlBUpC9rHBZFRZeoX61Py02OFB6lfAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xhsohvjl9zNb78vni3rhnDcBQ+MO7oPrVkMgl9aknm8=;
 b=GEUniK9YLSQQoI8pG6HzpADTlREBnKl9f/FIuuTccVyDoXmKKJAQkGsBfEL6ARRK6La7t59+ylszdr6hBcDiJlahEUDbiF91r3StbtceTsjzyKWAKGiyXlSwfyAFJOaK5+sn+8hCSWT25InhD+YBpPL9XgHcoV/qeoeB/yyJ6PQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3899.namprd15.prod.outlook.com (2603:10b6:303:45::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 18:46:25 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 18:46:25 +0000
Date:   Wed, 29 Apr 2020 11:46:23 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
Message-ID: <20200429184623.ul7nxelzxeip2ign@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201242.2995160-1-yhs@fb.com>
 <CAEf4BzYtxOrzSW6Yy+0ABbm0Q71dkZTGDOcGCgHCVT=4ty5k1g@mail.gmail.com>
 <2b88797e-23b3-5df0-4d06-00b26912d14a@fb.com>
 <CAEf4BzaX_GgieGTdTG7cgDE=SxQZBaPrd3EfRGTKaNNSGrW0Tw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaX_GgieGTdTG7cgDE=SxQZBaPrd3EfRGTKaNNSGrW0Tw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR14CA0063.namprd14.prod.outlook.com
 (2603:10b6:300:81::25) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fdec) by MWHPR14CA0063.namprd14.prod.outlook.com (2603:10b6:300:81::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 18:46:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:fdec]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c49dfcb0-e724-491d-a728-08d7ec6d9eb5
X-MS-TrafficTypeDiagnostic: MW3PR15MB3899:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3899B2834DD6FE264FFFBFB7D5AD0@MW3PR15MB3899.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(366004)(39860400002)(396003)(346002)(9686003)(54906003)(55016002)(8676002)(4326008)(8936002)(478600001)(33716001)(316002)(1076003)(66476007)(6496006)(66946007)(5660300002)(186003)(66556008)(6916009)(52116002)(86362001)(53546011)(2906002)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9aviCpYleIGWPeskVTtKoKSgxVypKZCan1ZOQLdhOSgOJbv1D4Gsp2PTgfi1xdVK1HIiHRdTVjlr9xBx96TjPoeLcc9l+69LMV2vmhrx9EzJ+Iq0aXV4eEwdZE2n4hM+24RKqT4A87Tvjhnt8MfWpGhebHqBVazvY4pANBjzMf91lgzym/X4R6MJolTeQqJhFxlCNa5+bgZdXGyfCoslkGBCYZY4VcAGoHrkUbma8rAK0b8AqFh6V+0OMQrxfVwT/CusEfQdo1CzQzljrdW8qT3hRhl+hI5tfahH4MugxfdXHF9Swv1MbxBYsF8nYbAQSpsi2crON9KReX8ACZ39KsPrLRl4fWVHby3hOIeSpEJ+FWkWrxIR0TQSBLxaauX3SSMYaAKaGmjfy1am8rEYfSBZz0JqwGzhDKa990ugePL5Z+lEavEnwDKHHuYq0Oy
X-MS-Exchange-AntiSpam-MessageData: /oN2VircQC2qSp4lIblV5vGAq59YnBdfQxASPNCSexBr2hitkqjkpTi8WyaeHPjfIvbsLu+xClXlQIEKZHOWUjU/px51R764JWe0o00+hWrst5xxuYeahGpS2cEK353yy8xm8mz6f6AML18yOKSnCNQEm+lFPcxXo17yg+qT+iijUqtLvGsPyFtrk+egylRCftrtl9jNxGOSYc1s88QpxZ5QQhpfXi1GjwP8PC0Qd9NeDbkpVgTUAoA6625dOEKMZeSv7SQ/iaFzaGQcA4WAzdfFIBJzGYhL+K1/IWR1PrklIT6pC9XT4Ce8odi5GSd7x356OSUHWMhMjb6n12IFAly4lHVqy3jdeR6Goagrhs/7HOr9rw6nMb2nuvH3/yX1BU5fQxZu+QoTAmg96aWrUW/Z1M6cWPC2Lau3GNS0etzgOF8i25qB5VzMg9I5kzpTMdDUKzL+Pq9ONrh48uEG1gtI2NUpYOewu3O72itIROnmaVlV2WTwyooItcYxMQMuc4+9n9U542QALYveqNPfqQd9680kWWw1RFs1kee1mwckyIGHbwLAhgiC0svTB32YdQne5U1SBph6RKU9whcRZHU1eJPgYL2C9L4s3WMTPquMEcLkV4+AzoYVTlaVdPeX10Lb8ABYGH39yt669JqgpfJtlS0FkTR8dPYMlrqmQNmb4F1wPw12iMpVKk1RNWJm3+QcRiDBWi4tB0KaVJ8pfb3V/+kpd1QrL5rTdbp/sw+OwavzEEI9AKxVCN+r/4E/IYsLMaXMNwroTpu5PErPBmoL1f9mFKcmzH5XCO/8Df+b0fu5OmMWa6ZXmVcgiVTBYwWbMxUSkOEu+xVx7qz/Kg==
X-MS-Exchange-CrossTenant-Network-Message-Id: c49dfcb0-e724-491d-a728-08d7ec6d9eb5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 18:46:25.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdSKbQA4OHFMcqJy+aJ555c9lSAETo5EffTSDTjs3CpMy06mH6bi8XekAIn2w9hN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3899
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_09:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 11:16:35AM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 29, 2020 at 12:07 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 4/28/20 11:56 PM, Andrii Nakryiko wrote:
> > > On Mon, Apr 27, 2020 at 1:19 PM Yonghong Song <yhs@fb.com> wrote:
> > >>
> > >> A new bpf command BPF_ITER_CREATE is added.
> > >>
> > >> The anonymous bpf iterator is seq_file based.
> > >> The seq_file private data are referenced by targets.
> > >> The bpf_iter infrastructure allocated additional space
> > >> at seq_file->private after the space used by targets
> > >> to store some meta data, e.g.,
> > >>    prog:       prog to run
> > >>    session_id: an unique id for each opened seq_file
> > >>    seq_num:    how many times bpf programs are queried in this session
> > >>    has_last:   indicate whether or not bpf_prog has been called after
> > >>                all valid objects have been processed
> > >>
> > >> A map between file and prog/link is established to help
> > >> fops->release(). When fops->release() is called, just based on
> > >> inode and file, bpf program cannot be located since target
> > >> seq_priv_size not available. This map helps retrieve the prog
> > >> whose reference count needs to be decremented.
> > >>
> > >> Signed-off-by: Yonghong Song <yhs@fb.com>
> > >> ---
> > >>   include/linux/bpf.h            |   3 +
> > >>   include/uapi/linux/bpf.h       |   6 ++
> > >>   kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
> > >>   kernel/bpf/syscall.c           |  27 ++++++
> > >>   tools/include/uapi/linux/bpf.h |   6 ++
> > >>   5 files changed, 203 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > >> index 4fc39d9b5cd0..0f0cafc65a04 100644
> > >> --- a/include/linux/bpf.h
> > >> +++ b/include/linux/bpf.h
> > >> @@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
> > >>   int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
> > >>   int bpf_obj_get_user(const char __user *pathname, int flags);
> > >>
> > >> +#define BPF_DUMP_SEQ_NET_PRIVATE       BIT(0)
> > >> +
> > >>   struct bpf_iter_reg {
> > >>          const char *target;
> > >>          const char *target_func_name;
> > >> @@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
> > >>   int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> > >>   int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> > >>                            struct bpf_prog *new_prog);
> > >> +int bpf_iter_new_fd(struct bpf_link *link);
> > >>
> > >>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
> > >>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> > >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > >> index f39b9fec37ab..576651110d16 100644
> > >> --- a/include/uapi/linux/bpf.h
> > >> +++ b/include/uapi/linux/bpf.h
> > >> @@ -113,6 +113,7 @@ enum bpf_cmd {
> > >>          BPF_MAP_DELETE_BATCH,
> > >>          BPF_LINK_CREATE,
> > >>          BPF_LINK_UPDATE,
> > >> +       BPF_ITER_CREATE,
> > >>   };
> > >>
> > >>   enum bpf_map_type {
> > >> @@ -590,6 +591,11 @@ union bpf_attr {
> > >>                  __u32           old_prog_fd;
> > >>          } link_update;
> > >>
> > >> +       struct { /* struct used by BPF_ITER_CREATE command */
> > >> +               __u32           link_fd;
> > >> +               __u32           flags;
> > >> +       } iter_create;
> > >> +
> > >>   } __attribute__((aligned(8)));
> > >>
> > >>   /* The description below is an attempt at providing documentation to eBPF
> > >> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> > >> index fc1ce5ee5c3f..1f4e778d1814 100644
> > >> --- a/kernel/bpf/bpf_iter.c
> > >> +++ b/kernel/bpf/bpf_iter.c
> > >> @@ -2,6 +2,7 @@
> > >>   /* Copyright (c) 2020 Facebook */
> > >>
> > >>   #include <linux/fs.h>
> > >> +#include <linux/anon_inodes.h>
> > >>   #include <linux/filter.h>
> > >>   #include <linux/bpf.h>
> > >>
> > >> @@ -19,6 +20,19 @@ struct bpf_iter_link {
> > >>          struct bpf_iter_target_info *tinfo;
> > >>   };
> > >>
> > >> +struct extra_priv_data {
> > >> +       struct bpf_prog *prog;
> > >> +       u64 session_id;
> > >> +       u64 seq_num;
> > >> +       bool has_last;
> > >> +};
> > >> +
> > >> +struct anon_file_prog_assoc {
> > >> +       struct list_head list;
> > >> +       struct file *file;
> > >> +       struct bpf_prog *prog;
> > >> +};
> > >> +
> > >>   static struct list_head targets;
> > >>   static struct mutex targets_mutex;
> > >>   static bool bpf_iter_inited = false;
> > >> @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
> > >>   /* protect bpf_iter_link.link->prog upddate */
> > >>   static struct mutex bpf_iter_mutex;
> > >>
> > >> +/* Since at anon seq_file release function, the prog cannot
> > >> + * be retrieved since target seq_priv_size is not available.
> > >> + * Keep a list of <anon_file, prog> mapping, so that
> > >> + * at file release stage, the prog can be released properly.
> > >> + */
> > >> +static struct list_head anon_iter_info;
> > >> +static struct mutex anon_iter_info_mutex;
> > >> +
> > >> +/* incremented on every opened seq_file */
> > >> +static atomic64_t session_id;
> > >> +
> > >> +static u32 get_total_priv_dsize(u32 old_size)
> > >> +{
> > >> +       return roundup(old_size, 8) + sizeof(struct extra_priv_data);
> > >> +}
> > >> +
> > >> +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
> > >> +{
> > >> +       return old_ptr + roundup(old_size, 8);
> > >> +}
> > >> +
> > >> +static int anon_iter_release(struct inode *inode, struct file *file)
> > >> +{
> > >> +       struct anon_file_prog_assoc *finfo;
> > >> +
> > >> +       mutex_lock(&anon_iter_info_mutex);
> > >> +       list_for_each_entry(finfo, &anon_iter_info, list) {
> > >> +               if (finfo->file == file) {
> > >
> > > I'll look at this and other patches more thoroughly tomorrow with
> > > clear head, but this iteration to find anon_file_prog_assoc is really
> > > unfortunate.
> > >
> > > I think the problem is that you are allowing seq_file infrastructure
> > > to call directly into target implementation of seq_operations without
> > > intercepting them. If you change that and put whatever extra info is
> > > necessary into seq_file->private in front of target's private state,
> > > then you shouldn't need this, right?
> >
> > Yes. This is true. The idea is to minimize the target change.
> > But maybe this is not a good goal by itself.
> >
> > You are right, if I intercept all seq_ops(), I do not need the
> > above change, I can tailor seq_file private_data right before
> > calling target one and restore after the target call.
> >
> > Originally I only have one interception, show(), now I have
> > stop() too to call bpf at the end of iteration. Maybe I can
> > interpret all four, I think. This way, I can also get ride
> > of target feature.
> 
> If the main goal is to minimize target changes and make them exactly
> seq_operations implementation, then one easier way to get easy access
> to our own metadata in seq_file->private is to set it to point
> **after** our metadata, but before target's metadata. Roughly in
> pseudo code:
> 
> struct bpf_iter_seq_file_meta {} __attribute((aligned(8)));
> 
> void *meta = kmalloc(sizeof(struct bpf_iter_seq_file_meta) +
> target_private_size);
> seq_file->private = meta + sizeof(struct bpf_iter_seq_file_meta);
I have suggested the same thing earlier.  Good to know that we think alike ;)

May be put them in a struct such that container_of...etc can be used:
struct bpf_iter_private {
        struct extra_priv_data iter_private;
	u8 target_private[] __aligned(8);
};

> 
> 
> Then to recover bpf_iter_Seq_file_meta:
> 
> struct bpf_iter_seq_file_meta *meta = seq_file->private - sizeof(*meta);
> 
> /* voila! */
> 
> This doesn't have a benefit of making targets simpler, but will
> require no changes to them at all. Plus less indirect calls, so less
> performance penalty.
> 
