Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA711BE91B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgD2UvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:51:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgD2UvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:51:11 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03TKmN0C019863;
        Wed, 29 Apr 2020 13:50:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9XbWLNPsTMnxLNImeTqhzzyC8VZKwOApuS4JTz2DjxU=;
 b=FiibevxtR6nVzOjhr174ypIltkbhnJkXK3M3xaF5e8e+c0F5lnBNIZ+j3Wupdffdhh1E
 uuSKk1jh2s9Ud+HkJG19Y8TGxGoqtKEkXd6XW7Sv3fjKS5HzW6bDciawk+DCrcpE8wl8
 /RB/XpXakqYm+3r3ewPxiwFcHRtSufYk4mM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30mgvnxe5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 13:50:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 13:50:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZqJcFMubGJ6oKpV/+fVlnGZTP09gpFriZMcFiDHWqzvu26/RftFEnbFNCJXKkdhljOeWyA+HMAOWzmP+WqFyoFJzCCSU7HeVh4Mlb/L/pgF3jQhYdsRkMGPn7lSx17Y7kI0iyCK399gi1BruG3BE+REeSuSGRt/CbOmdr6YBga1mTxKveSq1wULguu30xpt0F5NqBl3QPBKXhKrkn25nzpHVLXp/IFEyZ6Qv3YkFcPOUtA3JvdAk3AygBx6JJ3eKHd1US/hQFSkG+IixtOH5viYp+1DfUu+55oYaJQiSzBz7HGdymqfCj5RHonC8+HpiKp8fo74AepMXD//wNfdcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XbWLNPsTMnxLNImeTqhzzyC8VZKwOApuS4JTz2DjxU=;
 b=OnY0ZMqxyVxqYKpR3ldTQXnwPk51Vvz1DaiDzaN+c7x8CPZDPfe9mpUcSfsgvCTzBI6GL2IF4gmF44YwNu0vjA0qoNy95xm3ymz+y2WNf+wYosylpxpDTlFp0gtbxP7laE9sVJtQcDHPYbHQ0JrYaiGdcpbzAaSeZHMpKmGciFGamva/+/qnXzjOYl7zx/O0KeYQ7YplOr+rXsIrHG1KVBDTarthYgbxEdONl8FuR6uS43LPzG7okFKbomr/y1EHWjKCMePt6j7XoFS9+eCyU0ez1nzcoSLpCGbBD5ZK8HNAbQAz5HJeYRfnFn6UeEOXQ02pTYCYfwqMGdBtTzIIkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XbWLNPsTMnxLNImeTqhzzyC8VZKwOApuS4JTz2DjxU=;
 b=SlFuf0ddfyqMkT8vsj3bCeMpeAUfW/CXTHwNwZV5vGegURG1KihBqwpsLh/MqcHkymHr8ktud6GYzVMN8FC0HuuOUQeC5m1MDNFRjq1SZjiPbTu1pSCDMXvhkt8BH9NMldewrh/z+thU/3hr110cmDpeHN7BMJXymP6oOjI5m3A=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3865.namprd15.prod.outlook.com (2603:10b6:303:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 20:50:54 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 20:50:54 +0000
Date:   Wed, 29 Apr 2020 13:50:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
Message-ID: <20200429205051.fjf7uxowggqoxozh@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201242.2995160-1-yhs@fb.com>
 <CAEf4BzYtxOrzSW6Yy+0ABbm0Q71dkZTGDOcGCgHCVT=4ty5k1g@mail.gmail.com>
 <2b88797e-23b3-5df0-4d06-00b26912d14a@fb.com>
 <CAEf4BzaX_GgieGTdTG7cgDE=SxQZBaPrd3EfRGTKaNNSGrW0Tw@mail.gmail.com>
 <20200429184623.ul7nxelzxeip2ign@kafai-mbp>
 <88bfc829-3c2d-96aa-7d32-4f3ff9b4ad08@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88bfc829-3c2d-96aa-7d32-4f3ff9b4ad08@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR18CA0048.namprd18.prod.outlook.com
 (2603:10b6:320:31::34) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2292) by MWHPR18CA0048.namprd18.prod.outlook.com (2603:10b6:320:31::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 20:50:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:2292]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64ab65cd-6b03-4c48-5e63-08d7ec7f0236
X-MS-TrafficTypeDiagnostic: MW3PR15MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3865F7B07F9A0BB79A7B02B3D5AD0@MW3PR15MB3865.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(376002)(136003)(366004)(346002)(53546011)(52116002)(1076003)(8676002)(86362001)(6496006)(2906002)(8936002)(5660300002)(33716001)(54906003)(316002)(4326008)(478600001)(6636002)(55016002)(186003)(16526019)(9686003)(66556008)(66946007)(66476007)(6862004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 28UwNzFS4U1xVJzc3JWbFKtFvISUens9nC+tw65zGmaHHiuQsldgolULg0YaDRDwQvEyeDfDcZizLLzHCrrx6r55bqyo4k0gdl7Rq46EosuQ5YpG8hcrB23s1XfGe0gJ/n0yqRb3znyviJotTWJaB8Gx9mcRERV8mu2RQO34s8ULw53bCWLQrpXzYPfgu/l6NwvQm0879N9shUX8UMd/2uAcP9dJ7csRroiuEWcoz1y1U8gHnyLqzrOb0zd+NeED4rvDtfmTaOVjXIO1IeSsZo6G4aF/GrAc4/JqpzCa0EXqs/uEG5sKqu1ykvuXS6XTStz8HM915cIN+KgEUHzpUkKHitDhdBi5OkAXwtaaAxphVoptKAmeoHyhhlB/5nRZhwwnVuYAPZT3qGdGshKGwl3EbWCfr3Qo47A3eOXBiRRGqsYCqS1wK4NoTt4xbhlJ
X-MS-Exchange-AntiSpam-MessageData: O7B8Qcq4ApTHQqc4qrjZZcpGk0TYmZRhtp5+8IonwEk+MWiPKIXzPcdhknaEQvdDMz8PB5j6CgGBz3nq3B5s/oSIO1g+VQMbsriAeGsCp9gibfgybn0mG0OI4PDrPRTrVXs0Zy9MTui20a8AgsAyiHMPRT0N4vzoDI2L3aGGvGqXh7CQ+hn+rw/aG5FkO4By5eRclauW6iYr+ZwrlH7LMLKQWycJPVgIt2Nr+NWNhf/Qo+2UMmwIXZl9GvaNvV6yolK1l0/REJGyJt5yqVYRhD2hDy1wK1qoncEDTx/vN+k3owwB80h6nkTd9m/hx9vaNA4mzfm5/QNTe0w1IXePQva3ZDXoUxqw5jU4zANEzZMY/UHGLoEtpZzE4xXStld3SR8DVKSYbyeEAAVks/YRhu2LULcv32rLaLxC9fgl9XQb4Jj+jyYENR05tFyZ+tQ7XZZHZ10E3rfq/Dp5qqbMyvICmwqCeB92lNrYIkAMv49Xap+KZ/DHNQsrPrXZ2teKz5IvcDh3EMrbnnAd2yHw5+PeVSlapm0CLVPgJUYlFKhBFNhett3gNTd3yJ7PBNWv2HTam6MifdfnwzizjbSSwQhSOqqBatfQv6G5oAr/dc7uWD231SDZCfUaz/h695dc9zIAjl1yDjKoml9XPgPQw5je/8JWVv75EoEBfLypmn8RnKzSUhASlVxnGN9x7GLyQd7604+3u1oQLwA6knTsLWNWpFGnbLEp7Bhyz3ufUfKA2vJvWG/J5BaPeBb8K7NWWuKqp8PMdgFdYsmWCJnm/8tfCk+3iaNUg4pxk5LrHOmUBQgnJBeRcjGm1iWhORx+Jp/7FotaNETrxr0fR/0rVw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ab65cd-6b03-4c48-5e63-08d7ec7f0236
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 20:50:54.0962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p94nH/oU6Xec+ZYHXmCREmW9KaUZf8Fw3f0M0Y3iXnd3i1lksTQPvtiJJWE41FuP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3865
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_10:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 12:20:05PM -0700, Yonghong Song wrote:
> 
> 
> On 4/29/20 11:46 AM, Martin KaFai Lau wrote:
> > On Wed, Apr 29, 2020 at 11:16:35AM -0700, Andrii Nakryiko wrote:
> > > On Wed, Apr 29, 2020 at 12:07 AM Yonghong Song <yhs@fb.com> wrote:
> > > > 
> > > > 
> > > > 
> > > > On 4/28/20 11:56 PM, Andrii Nakryiko wrote:
> > > > > On Mon, Apr 27, 2020 at 1:19 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > > 
> > > > > > A new bpf command BPF_ITER_CREATE is added.
> > > > > > 
> > > > > > The anonymous bpf iterator is seq_file based.
> > > > > > The seq_file private data are referenced by targets.
> > > > > > The bpf_iter infrastructure allocated additional space
> > > > > > at seq_file->private after the space used by targets
> > > > > > to store some meta data, e.g.,
> > > > > >     prog:       prog to run
> > > > > >     session_id: an unique id for each opened seq_file
> > > > > >     seq_num:    how many times bpf programs are queried in this session
> > > > > >     has_last:   indicate whether or not bpf_prog has been called after
> > > > > >                 all valid objects have been processed
> > > > > > 
> > > > > > A map between file and prog/link is established to help
> > > > > > fops->release(). When fops->release() is called, just based on
> > > > > > inode and file, bpf program cannot be located since target
> > > > > > seq_priv_size not available. This map helps retrieve the prog
> > > > > > whose reference count needs to be decremented.
> > > > > > 
> > > > > > Signed-off-by: Yonghong Song <yhs@fb.com>
> > > > > > ---
> > > > > >    include/linux/bpf.h            |   3 +
> > > > > >    include/uapi/linux/bpf.h       |   6 ++
> > > > > >    kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
> > > > > >    kernel/bpf/syscall.c           |  27 ++++++
> > > > > >    tools/include/uapi/linux/bpf.h |   6 ++
> > > > > >    5 files changed, 203 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > > index 4fc39d9b5cd0..0f0cafc65a04 100644
> > > > > > --- a/include/linux/bpf.h
> > > > > > +++ b/include/linux/bpf.h
> > > > > > @@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
> > > > > >    int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
> > > > > >    int bpf_obj_get_user(const char __user *pathname, int flags);
> > > > > > 
> > > > > > +#define BPF_DUMP_SEQ_NET_PRIVATE       BIT(0)
> > > > > > +
> > > > > >    struct bpf_iter_reg {
> > > > > >           const char *target;
> > > > > >           const char *target_func_name;
> > > > > > @@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
> > > > > >    int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> > > > > >    int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> > > > > >                             struct bpf_prog *new_prog);
> > > > > > +int bpf_iter_new_fd(struct bpf_link *link);
> > > > > > 
> > > > > >    int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
> > > > > >    int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > index f39b9fec37ab..576651110d16 100644
> > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > @@ -113,6 +113,7 @@ enum bpf_cmd {
> > > > > >           BPF_MAP_DELETE_BATCH,
> > > > > >           BPF_LINK_CREATE,
> > > > > >           BPF_LINK_UPDATE,
> > > > > > +       BPF_ITER_CREATE,
> > > > > >    };
> > > > > > 
> > > > > >    enum bpf_map_type {
> > > > > > @@ -590,6 +591,11 @@ union bpf_attr {
> > > > > >                   __u32           old_prog_fd;
> > > > > >           } link_update;
> > > > > > 
> > > > > > +       struct { /* struct used by BPF_ITER_CREATE command */
> > > > > > +               __u32           link_fd;
> > > > > > +               __u32           flags;
> > > > > > +       } iter_create;
> > > > > > +
> > > > > >    } __attribute__((aligned(8)));
> > > > > > 
> > > > > >    /* The description below is an attempt at providing documentation to eBPF
> > > > > > diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> > > > > > index fc1ce5ee5c3f..1f4e778d1814 100644
> > > > > > --- a/kernel/bpf/bpf_iter.c
> > > > > > +++ b/kernel/bpf/bpf_iter.c
> > > > > > @@ -2,6 +2,7 @@
> > > > > >    /* Copyright (c) 2020 Facebook */
> > > > > > 
> > > > > >    #include <linux/fs.h>
> > > > > > +#include <linux/anon_inodes.h>
> > > > > >    #include <linux/filter.h>
> > > > > >    #include <linux/bpf.h>
> > > > > > 
> > > > > > @@ -19,6 +20,19 @@ struct bpf_iter_link {
> > > > > >           struct bpf_iter_target_info *tinfo;
> > > > > >    };
> > > > > > 
> > > > > > +struct extra_priv_data {
> > > > > > +       struct bpf_prog *prog;
> > > > > > +       u64 session_id;
> > > > > > +       u64 seq_num;
> > > > > > +       bool has_last;
> > > > > > +};
> > > > > > +
> > > > > > +struct anon_file_prog_assoc {
> > > > > > +       struct list_head list;
> > > > > > +       struct file *file;
> > > > > > +       struct bpf_prog *prog;
> > > > > > +};
> > > > > > +
> > > > > >    static struct list_head targets;
> > > > > >    static struct mutex targets_mutex;
> > > > > >    static bool bpf_iter_inited = false;
> > > > > > @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
> > > > > >    /* protect bpf_iter_link.link->prog upddate */
> > > > > >    static struct mutex bpf_iter_mutex;
> > > > > > 
> > > > > > +/* Since at anon seq_file release function, the prog cannot
> > > > > > + * be retrieved since target seq_priv_size is not available.
> > > > > > + * Keep a list of <anon_file, prog> mapping, so that
> > > > > > + * at file release stage, the prog can be released properly.
> > > > > > + */
> > > > > > +static struct list_head anon_iter_info;
> > > > > > +static struct mutex anon_iter_info_mutex;
> > > > > > +
> > > > > > +/* incremented on every opened seq_file */
> > > > > > +static atomic64_t session_id;
> > > > > > +
> > > > > > +static u32 get_total_priv_dsize(u32 old_size)
> > > > > > +{
> > > > > > +       return roundup(old_size, 8) + sizeof(struct extra_priv_data);
> > > > > > +}
> > > > > > +
> > > > > > +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
> > > > > > +{
> > > > > > +       return old_ptr + roundup(old_size, 8);
> > > > > > +}
> > > > > > +
> > > > > > +static int anon_iter_release(struct inode *inode, struct file *file)
> > > > > > +{
> > > > > > +       struct anon_file_prog_assoc *finfo;
> > > > > > +
> > > > > > +       mutex_lock(&anon_iter_info_mutex);
> > > > > > +       list_for_each_entry(finfo, &anon_iter_info, list) {
> > > > > > +               if (finfo->file == file) {
> > > > > 
> > > > > I'll look at this and other patches more thoroughly tomorrow with
> > > > > clear head, but this iteration to find anon_file_prog_assoc is really
> > > > > unfortunate.
> > > > > 
> > > > > I think the problem is that you are allowing seq_file infrastructure
> > > > > to call directly into target implementation of seq_operations without
> > > > > intercepting them. If you change that and put whatever extra info is
> > > > > necessary into seq_file->private in front of target's private state,
> > > > > then you shouldn't need this, right?
> > > > 
> > > > Yes. This is true. The idea is to minimize the target change.
> > > > But maybe this is not a good goal by itself.
> > > > 
> > > > You are right, if I intercept all seq_ops(), I do not need the
> > > > above change, I can tailor seq_file private_data right before
> > > > calling target one and restore after the target call.
> > > > 
> > > > Originally I only have one interception, show(), now I have
> > > > stop() too to call bpf at the end of iteration. Maybe I can
> > > > interpret all four, I think. This way, I can also get ride
> > > > of target feature.
> > > 
> > > If the main goal is to minimize target changes and make them exactly
> > > seq_operations implementation, then one easier way to get easy access
> > > to our own metadata in seq_file->private is to set it to point
> > > **after** our metadata, but before target's metadata. Roughly in
> > > pseudo code:
> > > 
> > > struct bpf_iter_seq_file_meta {} __attribute((aligned(8)));
> > > 
> > > void *meta = kmalloc(sizeof(struct bpf_iter_seq_file_meta) +
> > > target_private_size);
> > > seq_file->private = meta + sizeof(struct bpf_iter_seq_file_meta);
> > I have suggested the same thing earlier.  Good to know that we think alike ;)
> > 
> > May be put them in a struct such that container_of...etc can be used:
> > struct bpf_iter_private {
> >          struct extra_priv_data iter_private;
> > 	u8 target_private[] __aligned(8);
> > };
> 
> This should work, but need to intercept all seq_ops() operations
> because target expects private data is `target_private` only.
> Let me experiment what is the best way to do this.
As long as "seq_file->private = bpf_iter_private->target_private;" as
Andrii also suggested, the existing seq_ops() should not have to be
changed or needed to be intercepted because they are only
accessing it through seq_file->private.

The bpf_iter logic should be the only one needed to access the
bpf_iter_private->iter_private and it can be obtained by, e.g.
"container_of(seq_file->private, struct bpf_iter_private, target_private)"

> 
> > 
> > > 
> > > 
> > > Then to recover bpf_iter_Seq_file_meta:
> > > 
> > > struct bpf_iter_seq_file_meta *meta = seq_file->private - sizeof(*meta);
> > > 
> > > /* voila! */
> > > 
> > > This doesn't have a benefit of making targets simpler, but will
> > > require no changes to them at all. Plus less indirect calls, so less
> > > performance penalty.
> > > 
