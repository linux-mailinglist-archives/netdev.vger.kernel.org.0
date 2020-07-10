Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7200421AF74
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgGJGc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:32:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60688 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbgGJGc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:32:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06A6VKsW018554;
        Thu, 9 Jul 2020 23:32:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=80AAuZ20OqSuO6oQ0U2VhyjFDnb2p7n1tI3PmCdR/8Y=;
 b=nb2JrvCJn9dzAbZi0rQTtS1e8D74auh5aIzEoFkUgn7KZp3zBVQGosVDbVpTPG3X49Vz
 TczNK6cX9duJLeOgMnrCRXlCNcQT5BPiN8G6QQIgxgJCPFYdzs6iTiEJ5gxi3UeqsShB
 Huya74APQKdarJf+EoOWveSFh13h9UJpnac= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 325jysrjtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Jul 2020 23:32:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 23:32:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wso5ZK3o2j+2FFxVY2ys8l+HwbdnUpqpzWoO5xEcgvWiZThwtpz3g3w4E0DcPSQ+36kkUR4baDjx6V2j15yzx2HymQ79K4SlwViFiHOhiRxyRYGjIm7foRD1Nce3XPLDJiFT4/IqYwpZ8akWt/OcgieoRqDXd4+qLi2DdL1EYowGo/MKcJlrtltNW5EIFMnCLOWmvAn8WtipiKURWPYcq1qtFT24i5ROzQ4smA1OnLn6iTy0zkcn2ctSri5d6eHkpxwy3LoANCzq0wkPSkGSdgi0MJZ8HPpDU2o+SMroYNvqLnEdiL4i/u414XXYBsKc9XoZVvUAI45DNcKIlKVdGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80AAuZ20OqSuO6oQ0U2VhyjFDnb2p7n1tI3PmCdR/8Y=;
 b=MDZuErqIFFT3Zk67UR+8m4jCab/S0iH3qxiX/czaArPzZvkWZq1uOY2ZzFcJww1vG4Wag85jXUxEg8SdAjZU65TiFHICeSYD3tZNVk3V36hEgEVo3MSHdyE0smGfkXCuecw/cKkwgUqpavKS1g8NxLg7rlYX/SMK7Sai7StoDUIsOPLCtupy+Uz4P0qnViZb82ZL4KcgO5vtH57rTKgDPdaJKFWq+FkBmMWBvCjGGllg7wqBV5RA4CC4F6AxqfmcWArc/xxiHXjwuqzfyavR0eNtpFMjK8o66MQvMB6LTSK3z5X4jZm0z1qnJdQ84SOsC1SlJjBSq3nwTyxu9Qp81w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80AAuZ20OqSuO6oQ0U2VhyjFDnb2p7n1tI3PmCdR/8Y=;
 b=JpjmxbDfRceqEPLR4fJgocAJwH3FnPk0QFArDYFBdv79CE/0e45dkzVm4pPd6BupF7/iARRKUItsHccamnMKO5fhmL0RASbpdFCvIeV2CN/5P9wE6uIYCdnTQ87NCzSJj1g2vbq1arRURZLQy3EkTPAGWZsDHcYikuWcd5hmCjY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 10 Jul
 2020 06:31:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3153.032; Fri, 10 Jul 2020
 06:31:54 +0000
Subject: Re: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode driver
 that populates bpffs.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
 <20200702200329.83224-4-alexei.starovoitov@gmail.com>
 <CAEf4BzYf64VEEMJaF8jS=KjRw7UQzOhNJpXW0+YtQZ+TxpT2aQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <79a6e702-9fe7-3334-387e-82b5048b3275@fb.com>
Date:   Thu, 9 Jul 2020 23:31:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <CAEf4BzYf64VEEMJaF8jS=KjRw7UQzOhNJpXW0+YtQZ+TxpT2aQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::107b] (2620:10d:c090:400::5:25a) by BYAPR07CA0004.namprd07.prod.outlook.com (2603:10b6:a02:bc::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 06:31:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:25a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72132657-4b3c-4f40-6beb-08d8249aefca
X-MS-TrafficTypeDiagnostic: BYAPR15MB2774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB277494446BC86B0316463971D3650@BYAPR15MB2774.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B9CfyQVTk6WRnhy63i6ktk3mlpGR+CUxjEDZMehfK3P6fiXosBK/B2XUh2jAq/18sBCv4URtKHk8sY2vNWo12tkeHBbOjlmR50nYvn+QvEvrLq//YcthHRGnDYy3dQJuCNpjausumBVLMV7UjMaVbYG96aTB+S0BW2c7h88+QI6fkQUE4rVc5XoJibgsVUgLDTtjlDDVG9Vk4Wws8XXRhr1tcsmt/MEjuI0mdOFe93dfT7jqGnPtTyAVvpTVJrP/tphC52M9Us6cQfXJoza8N6ZlznipssEN95t/vk7p9JiRCZuO3+ElGzvpmBi+hnB36HNWBb9h2qfoF66bGCbCYb+oVeI7r7OIFKIPddOIDz+Ji7Ew8nTFFQVeXeaQn00t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(6486002)(4326008)(86362001)(8936002)(31696002)(31686004)(53546011)(8676002)(36756003)(316002)(54906003)(478600001)(52116002)(110136005)(16526019)(186003)(2906002)(83380400001)(5660300002)(66476007)(2616005)(66556008)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6Ppq0Hz4Rel8akthvkme5NQckpgsjYy1cyXxtRZsLF3bdkdOP5PigLFbhYkb/+vDKAkMP5E6MbzurOCfuhAIMRRhXneoE3iUYKB8Y+7j4zeTVtMabtgPZ9/cop1ViF+fKlxOk8H7U5kmu0FqfPR5kPFu2RqV7x+vWZI1XcOHm69cgaN8afVzviVNHnmh4o+g4nUJFM8tDCjiBnONkoYhp+WqpXyZksvShwqOIYW24anSjbtUsu8ZXDpap1KRpIS4pDuvaRS1+DfQARIu4RffYxvI9Mg1vaw3zMuSPiQuXPMpgRS0AUlj1vAp8vTY1EVYT8DmKmBaLJVGx8NpRTs/ynOn/J5knvwfcpijRPfq8Ek9K3MrSJq5ZDy9AQ2VQd/ICmBKg13lg4tfv9XzN3+a+1CCEcz9b5rIV+Rn+UHtwkORseEDMJmkiUkl5AI61rRsOemrOY73bHr6sztY1KuFOn19uk5dizk2DanNVP2JBp00+20+G57/kB5UNVTV58u1kVJyClBRyaF5mSaWfs5s4w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 72132657-4b3c-4f40-6beb-08d8249aefca
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 06:31:54.1588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwWZofw7dfvYVhAS+lhF9aSTbL+JM5rjNSYGj+VauWat9nZeDtaNMhIkMGKGNJxg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_01:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 8:15 PM, Andrii Nakryiko wrote:
> On Thu, Jul 2, 2020 at 1:04 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> From: Alexei Starovoitov <ast@kernel.org>
>>
>> Add kernel module with user mode driver that populates bpffs with
>> BPF iterators.
>>
>> $ mount bpffs /sys/fs/bpf/ -t bpf
>> $ ls -la /sys/fs/bpf/
>> total 4
>> drwxrwxrwt  2 root root    0 Jul  2 00:27 .
>> drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
>> -rw-------  1 root root    0 Jul  2 00:27 maps
>> -rw-------  1 root root    0 Jul  2 00:27 progs
>>
>> The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
>> maps, load two BPF programs, attach them to BPF iterators, and finally send two
>> bpf_link IDs back to the kernel.
>> The kernel will pin two bpf_links into newly mounted bpffs instance under
>> names "progs" and "maps". These two files become human readable.
>>
>> $ cat /sys/fs/bpf/progs
>>    id name            pages attached
>>    11    dump_bpf_map     1 bpf_iter_bpf_map
>>    12   dump_bpf_prog     1 bpf_iter_bpf_prog
>>    27 test_pkt_access     1
>>    32       test_main     1 test_pkt_access test_pkt_access
>>    33   test_subprog1     1 test_pkt_access_subprog1 test_pkt_access
>>    34   test_subprog2     1 test_pkt_access_subprog2 test_pkt_access
>>    35   test_subprog3     1 test_pkt_access_subprog3 test_pkt_access
>>    36 new_get_skb_len     1 get_skb_len test_pkt_access
>>    37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
>>    38 new_get_constan     1 get_constant test_pkt_access
>>
>> The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
>> all BPF programs currently loaded in the system. This information is unstable
>> and will change from kernel to kernel.
>>
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> ---
> 
> [...]
> 
>> +static int bpf_link_pin_kernel(struct dentry *parent,
>> +                              const char *name, struct bpf_link *link)
>> +{
>> +       umode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
>> +       struct dentry *dentry;
>> +       int ret;
>> +
>> +       inode_lock(parent->d_inode);
>> +       dentry = lookup_one_len(name, parent, strlen(name));
>> +       if (IS_ERR(dentry)) {
>> +               inode_unlock(parent->d_inode);
>> +               return PTR_ERR(dentry);
>> +       }
>> +       ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
>> +                           &bpf_iter_fops);
> 
> bpf_iter_fops only applies to bpf_iter links, while
> bpf_link_pin_kernel allows any link type. See bpf_mklink(), it checks
> bpf_link_is_iter() to decide between bpf_iter_fops and bpffs_obj_fops.
> 
> 
>> +       dput(dentry);
>> +       inode_unlock(parent->d_inode);
>> +       return ret;
>> +}
>> +
>>   static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>>                            enum bpf_type type)
>>   {
>> @@ -638,6 +659,57 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
>>          return 0;
>>   }
>>
>> +struct bpf_preload_ops bpf_preload_ops = { .info.driver_name = "bpf_preload" };
>> +EXPORT_SYMBOL_GPL(bpf_preload_ops);
>> +
>> +static int populate_bpffs(struct dentry *parent)
> 
> So all the pinning has to happen from the kernel side because at the
> time that bpf_fill_super is called, user-space can't yet see the
> mounted BPFFS, do I understand the problem correctly? Would it be
> possible to add callback to fs_context_operations that would be called
> after FS is mounted and visible to user-space? At that point the
> kernel can spawn the user-mode blob and just instruct it to do both
> BPF object loading and pinning?

This is possible during bpf_fill_super() which is called when a `mount`
syscall is called. I experimented it a little bit when in my early
bpf_iter experiment with bpffs to re-populate every existing
iterators in a new bpffs mount.

In this case, we probably do not want to repopulate it in
every new bpffs mount. I think we just want to put them in a fixed
location. Since this is a fixed location, the system can go ahead
to do the mount, I think. But could just set up all necessary
data structures and do eventual mount after file system is up
in user space. Just my 2 cents.

> 
> Or are there some other complications with such approach?
> 
>> +{
>> +       struct bpf_link *links[BPF_PRELOAD_LINKS] = {};
>> +       u32 link_id[BPF_PRELOAD_LINKS] = {};
>> +       int err = 0, i;
>> +
>> +       mutex_lock(&bpf_preload_ops.lock);
>> +       if (!bpf_preload_ops.do_preload) {
>> +               mutex_unlock(&bpf_preload_ops.lock);
>> +               request_module("bpf_preload");
>> +               mutex_lock(&bpf_preload_ops.lock);
>> +
>> +               if (!bpf_preload_ops.do_preload) {
>> +                       pr_err("bpf_preload module is missing.\n"
>> +                              "bpffs will not have iterators.\n");
>> +                       goto out;
>> +               }
>> +       }
>> +
>> +       if (!bpf_preload_ops.info.tgid) {
>> +               err = bpf_preload_ops.do_preload(link_id);
>> +               if (err)
>> +                       goto out;
>> +               for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
>> +                       links[i] = bpf_link_by_id(link_id[i]);
>> +                       if (IS_ERR(links[i])) {
>> +                               err = PTR_ERR(links[i]);
>> +                               goto out;
>> +                       }
>> +               }
>> +               err = bpf_link_pin_kernel(parent, "maps", links[0]);
>> +               if (err)
>> +                       goto out;
>> +               err = bpf_link_pin_kernel(parent, "progs", links[1]);
>> +               if (err)
>> +                       goto out;
> 
> This hard coded "maps" -> link #0, "progs" -> link #1 mapping is what
> motivated the question above about letting user-space do all pinning.
> It would significantly simplify the kernel part, right?
> 
>> +               err = bpf_preload_ops.do_finish();
>> +               if (err)
>> +                       goto out;
>> +       }
> 
> [...]
> 
