Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28AC1AB3FC
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 00:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbgDOW5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 18:57:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26974 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732701AbgDOW5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 18:57:24 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FMp16r007543;
        Wed, 15 Apr 2020 15:57:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xpYPldKHdsk61SkaqR3N8cRlfWw42Hi3W+lqdl6uUsc=;
 b=kY+hiEGgX2o0HnmtzVSeHzj9b2VKZ6EMcpDBVXWoYTC2a5znHA7PxL+RkeKkxTtdTO5z
 pfLOuuqyUYli0tfQG5lHNyUvrEiFbPQIj0tlE6nXQTb8OHjtnF/zVFNPxTNqS0AvBG1b
 WYnMHeF6vfechy5LEjMSOdh/Q1EA8k4HHK4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7t8gws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Apr 2020 15:57:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 15:57:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnNdO0qFbSCyhL675xxrSyXgoySFDB1O6msMA9M6SHGeIDcwhqg/Xw7fXPZfbMQ3tzqunRE8wRhu0mTFaAipkonVQqFAorS/suU92HkYEnJa5IuS8UDE9J+vDm+S5cTTelbe7VynLU8UzE5vQzg6PSeDVo0KS48I9BIQYpf10w8Qe6v03ZOV81qEuMGfv3l0gTX8eLtU3RyY4qwuzNgOIgpTzonUDKnqTRzKEjvFm3vpYCfJshw3wJWxu7Ny8G2NWifY0L5fDkukYMTUyem4ngEERrzPPReJQD6H3lq8dhZWU1rLCMX3C9pR/toJKlRHq0NbQXD395fyxZdXImM19g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpYPldKHdsk61SkaqR3N8cRlfWw42Hi3W+lqdl6uUsc=;
 b=b1w+CrM3pHIS17T102KFrIwnWrLrKuo13KXikW8W0+M997LTcaTRHNzgPmCgYopzDxD6gtFZKMNzKkAq9aT0QiJoJMD/U40QlDnNVp6r1JAtMFu0pi1/47DUD+FDIzSxvTA+n2hBh0BZmrF1CaB4EtlZ8m8U37ZnYlC4D9qXSnq+U82Fiuzf0SarUOsIGVsl3hHTazd+9RCLRHbacPdhbii9NKn0YG0KIKZp9dYHLY+cYg+ipLL8lkvCX7BXGqepJYAQ5ABEye+CDdVWRNymEfd1nzByV9hnFCHqHsp5hOgC8vDb79KpeTFV3WRA+L77WKxHGQcY1R705HyzXyxsrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpYPldKHdsk61SkaqR3N8cRlfWw42Hi3W+lqdl6uUsc=;
 b=LAoLmZ5gbMsyUhitxLhNG4X0jZeFBn7ikBr+byAhV3sadoVT4R/X4YXWa5LCZGKWLCrA5AVNraIlOmGXAcM6cne3bgtlLDe0NW5QrfhPbBWbbFA6oNmSkw77zHLq6YHvC/l96DfzNUrDf5MFNSgXJnzydButUpzgEz4daNGjswc=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3994.namprd15.prod.outlook.com (2603:10b6:303:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 15 Apr
 2020 22:57:06 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 22:57:06 +0000
Subject: Re: [RFC PATCH bpf-next 03/16] bpf: provide a way for targets to
 register themselves
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232523.2675550-1-yhs@fb.com>
 <CAEf4Bzb5K6h+Cca63JU35XG+NFoFDCVrC=DhDNVz6KTmoyzpFw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ce741052-6da2-8eb7-0612-5f68150b44f9@fb.com>
Date:   Wed, 15 Apr 2020 15:57:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzb5K6h+Cca63JU35XG+NFoFDCVrC=DhDNVz6KTmoyzpFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:300:ee::16) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lhton-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:6fee) by MWHPR04CA0030.namprd04.prod.outlook.com (2603:10b6:300:ee::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 22:57:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:6fee]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7276e291-b58b-4831-92c0-08d7e19051e0
X-MS-TrafficTypeDiagnostic: MW3PR15MB3994:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB399475F17EE8688B3A9A8BCBD3DB0@MW3PR15MB3994.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(346002)(396003)(366004)(39860400002)(376002)(478600001)(31686004)(8676002)(31696002)(66476007)(8936002)(66556008)(66946007)(36756003)(186003)(16526019)(86362001)(316002)(81156014)(6916009)(2616005)(6486002)(4326008)(2906002)(6512007)(6506007)(54906003)(5660300002)(52116002)(53546011);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tGS6dt+2Lo5EtyOBe0VaEykgRBcVCE9HIVAhtLyid/EOhk39Q1CoYnAqhpbzXfv7XUk+fCsU4EPOQoYyZIAm4irggg9YSJ8LAQV1KI03ZfdXd4OnAK59kDSwfGLJzkZFbJzMKN1ZG1XDvHr71DflzyD8gtLLO/ZNUf0QnOdsS+TL/ruBlvG1wA8AXA7cCOUd4MH0Kowj+libkb29lF5b/fWIq8V9jYLHm02kHqxdFRr6/cDOERXi8allAGwJ4XvFg6RhObIKWnwGq9B6TjYgJV1HM6LcVhYZzMlKnvhZup9XtOQKtjDQtT/21uuztaronTribuQIjUhtnHpu9Kmi5aK5F53NrOm9yyGtsRN3B4pdFFO5qM73cMjAkIIu9+BUAnSNguHgkWdNgc+Oww3Fn5ig8Ba+xti8sCz4P1lKLfivxtpUyGEyhSXVfC/yvYZe
X-MS-Exchange-AntiSpam-MessageData: d4sfqysFEyn6O5ytfVQA71kAj+7KD61I8UBW228g3qbr8YavEzAPBp1GlrB9U5eQw5u3drDmk7rWcw2mXAtLk4+vz5kCfwIJuv2AO+1G3utWz+KSAa8Ofvg6vR0vb9RJ1lJna3YCR8thAye2Zg85Nw2Ngx1PrlVDl6cblL7S0E+WxXjegqVvl+4Jx+f1XQ3z
X-MS-Exchange-CrossTenant-Network-Message-Id: 7276e291-b58b-4831-92c0-08d7e19051e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 22:57:06.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbACqKmy2cHkqsM/x/NX0qLXqcVVVHwMhgazSVpfejAMRKLDMI5r9BQkDqeKhEwr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3994
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_08:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 3:18 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Here, the target refers to a particular data structure
>> inside the kernel we want to dump. For example, it
>> can be all task_structs in the current pid namespace,
>> or it could be all open files for all task_structs
>> in the current pid namespace.
>>
>> Each target is identified with the following information:
>>     target_rel_path   <=== relative path to /sys/kernel/bpfdump
>>     target_proto      <=== kernel func proto which represents
>>                            bpf program signature for this target
>>     seq_ops           <=== seq_ops for seq_file operations
>>     seq_priv_size     <=== seq_file private data size
>>     target_feature    <=== target specific feature which needs
>>                            handling outside seq_ops.
> 
> It's not clear what "feature" stands for here... Is this just a sort
> of private_data passed through to dumper?
> 
>>
>> The target relative path is a relative directory to /sys/kernel/bpfdump/.
>> For example, it could be:
>>     task                  <=== all tasks
>>     task/file             <=== all open files under all tasks
>>     ipv6_route            <=== all ipv6_routes
>>     tcp6/sk_local_storage <=== all tcp6 socket local storages
>>     foo/bar/tar           <=== all tar's in bar in foo
> 
> ^^ this seems useful, but I don't think code as is supports more than 2 levels?
> 
>>
>> The "target_feature" is mostly used for reusing existing seq_ops.
>> For example, for /proc/net/<> stats, the "net" namespace is often
>> stored in file private data. The target_feature enables bpf based
>> dumper to set "net" properly for itself before calling shared
>> seq_ops.
>>
>> bpf_dump_reg_target() is implemented so targets
>> can register themselves. Currently, module is not
>> supported, so there is no bpf_dump_unreg_target().
>> The main reason is that BTF is not available for modules
>> yet.
>>
>> Since target might call bpf_dump_reg_target() before
>> bpfdump mount point is created, __bpfdump_init()
>> may be called in bpf_dump_reg_target() as well.
>>
>> The file-based dumpers will be regular files under
>> the specific target directory. For example,
>>     task/my1      <=== dumper "my1" iterates through all tasks
>>     task/file/my2 <=== dumper "my2" iterates through all open files
>>                        under all tasks
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h |   4 +
>>   kernel/bpf/dump.c   | 190 +++++++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 193 insertions(+), 1 deletion(-)
>>

>> +
> 
> [...]
> 
>> +       if (S_ISDIR(mode)) {
>> +               inode->i_op = i_ops;
>> +               inode->i_fop = f_ops;
>> +               inc_nlink(inode);
>> +               inc_nlink(dir);
>> +       } else {
>> +               inode->i_fop = f_ops;
>> +       }
>> +
>> +       d_instantiate(dentry, inode);
>> +       dget(dentry);
> 
> lookup_one_len already bumped refcount, why the second time here?

This is due to artifact in security/inode.c:

void securityfs_remove(struct dentry *dentry)
{
         struct inode *dir;

         if (!dentry || IS_ERR(dentry))
                 return;

         dir = d_inode(dentry->d_parent);
         inode_lock(dir);
         if (simple_positive(dentry)) {
                 if (d_is_dir(dentry))
                         simple_rmdir(dir, dentry);
                 else
                         simple_unlink(dir, dentry);
                 dput(dentry);
         }
         inode_unlock(dir);
         simple_release_fs(&mount, &mount_count);
}
EXPORT_SYMBOL_GPL(securityfs_remove);

I did not implement bpfdumpfs_remove like the above.
I just use simple_unlink so I indeed do not need the above dget().
I have removed it in RFC v2. Tested it and it works fine.

I think we may not need that additional reference either in
security/inode.c.

> 
>> +       inode_unlock(dir);
>> +       return dentry;
>> +
>> +dentry_put:
>> +       dput(dentry);
>> +       dentry = ERR_PTR(err);
>> +unlock:
>> +       inode_unlock(dir);
>> +       return dentry;
>> +}
>> +
> 
> [...]
> 
