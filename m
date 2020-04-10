Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D6B1A4CA0
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDJXZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:25:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726582AbgDJXZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:25:39 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ANJNZY031723;
        Fri, 10 Apr 2020 16:25:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Vwr623Rc1T/A1wrWWmIQRNhhHlIYTFbOF+1or3VE6e8=;
 b=Li2omxn07+MBzZdB3NWZZDmUjLHCbPc/u1Qy54IATQEKc6zQ7G5VPe6InTw5gPf2sAt3
 L/HPnK0OFOHtyFQS50RqSIIHy7vwxZGv0zsfBvhHKQQFxzYsXHxi1RplAdA9wYUUoydL
 AJna+zXB6xM/4YjWGLlb13B5HiOIsDjqZIw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 309sgx4221-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 16:25:27 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 16:25:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+i/i2ZQPCiKLuq5LTqkNtORwKGkz1hPVJPUVwBWCoIwrhhUP0dzjQGp0cl/aE84yNDDcXpy2v9K/tL1/LoMEiJMq0yqiq3xwtaOmWAGtpCB0vEPxtWCMRy+2mpojzIUYnIi6vGiXtDR8hjYRRZXtWc8eTkOBjs05b0dj/RYIHKvfRtLhY6GvAHUs2+Bz8p7Ds7VZTobImvwaNeJRZSD0p2H9sQhgqk04Po2oiiVZ3s6SEhs3hodn2JmfgGh+cZAlNarCU6oxldM2EM/YqyTqpJuOnpQGBCtPz4l5XT0W5bthVoL39LOThVf4TvsSnu/Mhgv7grn00BEmbxO/acnew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwr623Rc1T/A1wrWWmIQRNhhHlIYTFbOF+1or3VE6e8=;
 b=IHr3Yih93+o0fi9k81olTUlAglW/p7PTJKsRJDmKdvNQw6RqaRvivTiXfTumkwOVEqVo8kGWCUIa/zzOoZsO/WHSF/+kT3MrUxo9kqTxdLTccWHVXIQzdQM2WyGZMonSifHOTExItVJmGRP5eMeO811YCrdGq7HZTQvAGXYZ5JiSsRpJcD60ip12hqeOvnYjGAsLSH8mBjcdJremdmg2Cf+63vUeJch1DfUmyFhAp0AdRCKgxIaJhnRf2jCiLxC8f45oFZ0qqqUR4aYMY7MxOlRZ1OVqGPksAD5GU5obk61R4loIS7suB6bTtxPJXap86aiHI1kvWb65u+jKs1ZE5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwr623Rc1T/A1wrWWmIQRNhhHlIYTFbOF+1or3VE6e8=;
 b=Uaefa5WAofu+LOzTmUIeK9bXc3IRoMehdvUSO8pzl5n7IZpWxFPvP9/n6PgvFQ6uaBHGeXI4qjjsH9blVi2RkfC/SbTb1bFpMGKch0DcX9L2ztE3HM60f8zrO0S7SEXVhLCooiNGfq71KqZukDBsguuszFUarTuPqtZBc/hsq6k=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Fri, 10 Apr
 2020 23:25:26 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 23:25:26 +0000
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
 <CAEf4BzYd5gkytGookaVU_nCVVyxTYM1Z4ohqPFZW2YSY2VJ9Fg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e6e8ee19-4c1e-1284-4bbb-11c5f545f3d1@fb.com>
Date:   Fri, 10 Apr 2020 16:25:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYd5gkytGookaVU_nCVVyxTYM1Z4ohqPFZW2YSY2VJ9Fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:300:93::27) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR17CA0065.namprd17.prod.outlook.com (2603:10b6:300:93::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Fri, 10 Apr 2020 23:25:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15bbac5c-0608-4b09-d5ea-08d7dda672e0
X-MS-TrafficTypeDiagnostic: MW3PR15MB4044:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB40448A0324A18760905A64D7D3DE0@MW3PR15MB4044.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(376002)(366004)(136003)(396003)(346002)(53546011)(31696002)(6506007)(52116002)(316002)(2906002)(54906003)(2616005)(478600001)(86362001)(16526019)(186003)(36756003)(66556008)(6486002)(31686004)(66946007)(66476007)(81156014)(8936002)(8676002)(5660300002)(6512007)(4326008)(6916009);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRDdVMrqUrOWCJv/H+SlPQZGO4d2eqIOinQQrQJTN2jkSyKvvaXIZAI+/goiAXrgYV6pn1Ty5NXdZAwR3cKRwYTno4Sx3Hx69d3d41CzNWeo5oGweITKKCl0ixUNi+bFS6dA7MaNkC7lVc6Nx2GnYTg+xWyawwH3fvl3qpc3netUvx7w74PkkT90SV651MjVSMi3D65dwSYQWKVduqRfFk9ReGy72yEedNTVWmNZ3XkquhmvctaqzMVstlUpMLrP4RhID6zZ4bcyzpBKwpR1v4Et1K9EooeXjXDDq/2yosLzM6QVSCucIspEyRei5WxyEw4b+U0VQ/ap7BunFAA62g27X75Ne4IaZer5VmlknNz3SBFiWKlInRn7asFQRFC6f005IOCrEuEht65hOXMwl2mt4NaNFSGOqM029RuIiVGG1/pcEbwhxWNTVucVk3hW
X-MS-Exchange-AntiSpam-MessageData: nu6rf3fX/qqaBYJMGz98ClNa+TFGr2+QmXZuqhUSpbNKo411ti+2YDmI8qEOCnLgxZ0oO3qM5+q1dsiL8/FgY9YtICWKFY/iTkXAEblupCE66v+/9EgbaT8Wa7HtwVsiZSq+fa6CYkQqIZSHaoCiaBvPp9QsBU6PO2GtAw7zCMFAxP+8LZTcpVKmu8qVzX+P
X-MS-Exchange-CrossTenant-Network-Message-Id: 15bbac5c-0608-4b09-d5ea-08d7dda672e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 23:25:25.9424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZQx5qzntX4ATIYSRmSKYX1Olfv2hTSDyFGWTeNrpWt1OewX3bZtFOZr/rJ8iMsF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4044
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 3:25 PM, Andrii Nakryiko wrote:
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
>>
>> The target relative path is a relative directory to /sys/kernel/bpfdump/.
>> For example, it could be:
>>     task                  <=== all tasks
>>     task/file             <=== all open files under all tasks
>>     ipv6_route            <=== all ipv6_routes
>>     tcp6/sk_local_storage <=== all tcp6 socket local storages
>>     foo/bar/tar           <=== all tar's in bar in foo
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
> 
> [...]
> 
>> +
>> +static int dumper_unlink(struct inode *dir, struct dentry *dentry)
>> +{
>> +       kfree(d_inode(dentry)->i_private);
>> +       return simple_unlink(dir, dentry);
>> +}
>> +
>> +static const struct inode_operations bpf_dir_iops = {
> 
> noticed this reading next patch. It should probably be called
> bpfdump_dir_iops to avoid confusion with bpf_dir_iops of BPF FS in
> kernel/bpf/inode.c?

make sense. originally probably copied from inode.c and did not
change that.

> 
>> +       .lookup         = simple_lookup,
>> +       .unlink         = dumper_unlink,
>> +};
>> +
> 
> [...]
> 
