Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E602824C214
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgHTPXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:23:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbgHTPXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:23:40 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KFKXio011761;
        Thu, 20 Aug 2020 08:22:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PpUOmZJIFqBGA7iqvKRjmt2IgcoJ3mlJkG5iTJCVdjI=;
 b=OYtshLzBdnPeNnaHbPcXzImlk+/dCtypWjHiJZdFKGvmxkf7gSiQmfCuylsKFvA3+Scl
 gJLgNpOBlzMBxP8y/iuTOtYWaDOuDGj6I1X/gjMNcHp8cPgufZU/Ff2OG0XZRuML2qZJ
 yDM/eOBr7ki75zSELzxMPbDdh2MUzCHbcek= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 331d50knbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 08:22:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 08:22:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldEF/1B3TGvp2U/flZly+iuSRR5UTaVStX+po+FREFlUUlREYlVefRiQKM3RWHXnjr+bRn2HXK4nVTr45k6luReK575EjQr+QokZyejqMGLmGGkmh2IdEJzywy5LWCcF1YCW/H3zttIBdvXDKjci+2CdgMM5TPk/ygsklV+U4WsekAkBX1hKkf304fHw5oyg2g0h2L9ZZn1smOeUTQLoSn02sQ1+7Hk59UVDBKMV/V+40+cFf23aUPdU9UydGLok8hE7dA5S3CS6rpcsP07OcFNDBGij22lK9QtAx1y5IhkHVhyfb460et2UVypEh04xUy2Q6EfnGrcZoVQ3q4+w+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpUOmZJIFqBGA7iqvKRjmt2IgcoJ3mlJkG5iTJCVdjI=;
 b=gEmKD1ACsCOJne2FbcLip2aWN4ci8WuobnfOoOpydjs0ZxKhUswRzECuPQvBDvsB38HSAouQAmYsD45MUt66pI5UAU8WnZn0b/bJKSwHQi74sfESPmq1iiBylf8V8U0pfJHtgS5BLR76yhAY5HmZtKUfDIFeQKtHoTDooG49sEUueuz4W33YMVyl+rrl3NlZuyd6g/OoPJPuA2PqUe/dmV98fsDrYMFLpahQTmD8t1pNOtT9CN5yigRz/YO4A3EXH7iPezr/q/SJSl1BRIKOSqGo18kfN3mBRRnau4RxeBxJVd180nN4sSrX3BUC3buJN74qqce93Tz/CjygnYdEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpUOmZJIFqBGA7iqvKRjmt2IgcoJ3mlJkG5iTJCVdjI=;
 b=hTDd5SA9mVueGFloGZw9Sh47INmKoXkGgJhqGvIl/GDdQ54rkOUx3X4T748+i9ps44j4gem/zo78GyxNMOL12efcx8FyAMegdSEcteM5TM0nua2z5us/OwNsHx6VG73d0uMRaHocHRiFWLru4MYXPh1BzVbj3bhExIp72dwLnqo=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:22:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:22:36 +0000
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
To:     Hao Luo <haoluo@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20200819224030.1615203-1-haoluo@google.com>
 <20200819224030.1615203-2-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <35519fec-754c-0a17-4f01-9d6e39a8a7e8@fb.com>
Date:   Thu, 20 Aug 2020 08:22:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819224030.1615203-2-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:c0::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR05CA0021.namprd05.prod.outlook.com (2603:10b6:208:c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Thu, 20 Aug 2020 15:22:32 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34815f96-e2b8-4913-a34d-08d8451cde0d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB304697D131E6F6CD3AAF2D20D35A0@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89TYIm1l3WO/CR2GBJ/BnjLuq3gz5JiXL3b4d+kpWAB5NrSccraUZw/KsqGHKhcMkDT9zqx7G6/UgPHZY3yK8y35L1489moyRx2RctzxVXRkoOrAGrGUhcPFr1s5l2qvzNrUoS+Of3IiifhL4AVNWh0qUtc647jp7q4oY+g/zoF6Z5VdAVZQY3U8tVWOw5MGupu7IqG1X4lzKkZmFcKp+rvXKcv3AH7+SRHnJmlBOOT0V009HvBPF1x1EcC8wDKJGhemLUc6hDNDEtBTBeZ08Thg3tcjI9YPfW0XCDZqq25CnvzjFRrMqFgeql901Eh2rMJI2YywOrWPFuRdWT5tjb/crSRzfhN3SOKiNI67ztEkVMntx1skw4/+5//ZopRoeU9KvYmxXShfYMHmi5rFrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(376002)(39860400002)(66476007)(66556008)(31696002)(66946007)(2906002)(83380400001)(7416002)(86362001)(6666004)(53546011)(6486002)(5660300002)(186003)(478600001)(36756003)(4326008)(52116002)(2616005)(956004)(110011004)(31686004)(316002)(8676002)(8936002)(54906003)(16576012)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iwXB19JHQw66Td3LRg5Un7cGNNF9h4sBVG34UqBKHuTVNHMpOWR9lWOwlZ99cru1tS8HGKGdvUVJcs7wGggFFMcOuor3U5+dZOL+mE/pCtqBKXB97aTJCGS5xVG5AaQ+LCbrVDF8/JTmsyVcO4DPoB3o85uAdBxuPMg+UbiGvTm3CVFC411J5RNKNMzWuHAHwZxeBHA14CIvbXVyQpbWcdXxr9Bf0rwf8EZKX4lQYWB01wuNSpUFNdupne1mvKR3tNQz5MAjBghy7vshY0mbgt4FLLjIiQxWViVEshhz1djiR/N5Dn9pLcwG+fLBOcqZRiNeDB7hSgHUNK5jmC9WuA2j1U9jWzH7QjBiB0rAQGNh8QP/PsoEXI1YWdHDGTDtwmTsEFjvq7NgXux2MPJ6qHYy+eloeRQ0IaZ0WD2A1H8rmd6TaX774qq4XUTwy4MR5CXBBQWOIdniNpDQ32cyhx9vgMsY3BWv3fUiOxoB9+h4rUwrzRKNbFXD4016OLVUtjyYlh7WXsqn7UP818WIClk2TM9/PvwQM7QT9nVdTbh7PGMUi4At5G+OAEXo/fU324XYaPLPf9Ja7u2Ptr6+iztqGlvPxmiR2jOk+Xsnt0GJTGE9/cQTM1uVMDVBIuyMmZSdakWrdUd9x44rAbxuq8ZEYz9d8GtOlmFsffYFvedWCGLj+Y/fqEYJrc+2lGrX
X-MS-Exchange-CrossTenant-Network-Message-Id: 34815f96-e2b8-4913-a34d-08d8451cde0d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:22:36.0751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLz1uWuTjfiNkfoj/LKrEHgttQXhiNxV8x7nWDpXOT5tfPd7X2jqlEtLe8ANjQ2c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1011 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008200127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 3:40 PM, Hao Luo wrote:
> Pseudo_btf_id is a type of ld_imm insn that associates a btf_id to a
> ksym so that further dereferences on the ksym can use the BTF info
> to validate accesses. Internally, when seeing a pseudo_btf_id ld insn,
> the verifier reads the btf_id stored in the insn[0]'s imm field and
> marks the dst_reg as PTR_TO_BTF_ID. The btf_id points to a VAR_KIND,
> which is encoded in btf_vminux by pahole. If the VAR is not of a struct
> type, the dst reg will be marked as PTR_TO_MEM instead of PTR_TO_BTF_ID
> and the mem_size is resolved to the size of the VAR's type.
> 
>  From the VAR btf_id, the verifier can also read the address of the
> ksym's corresponding kernel var from kallsyms and use that to fill
> dst_reg.
> 
> Therefore, the proper functionality of pseudo_btf_id depends on (1)
> kallsyms and (2) the encoding of kernel global VARs in pahole, which
> should be available since pahole v1.18.

I tried your patch with latest pahole but it did not generate
expected BTF_TYPE_VARs. My pahole head is:
   f3d9054ba8ff btf_encoder: Teach pahole to store percpu variables in 
vmlinux BTF.

First I made the following changes to facilitate debugging:
diff --git a/btf_encoder.c b/btf_encoder.c
index 982f59d..f94c3a6 100644
--- a/btf_encoder.c
+++ b/btf_encoder.c
@@ -334,6 +334,9 @@ int cu__encode_btf(struct cu *cu, int verbose, bool 
force)
                 /* percpu variables are allocated in global space */
                 if (variable__scope(var) != VSCOPE_GLOBAL)
                         continue;
+               /* type 0 is void, probably an internal error */
+               if (var->ip.tag.type == 0)
+                       continue;
                 has_global_var = true;
                 head = &hash_addr[hashaddr__fn(var->ip.addr)];
                 hlist_add_head(&var->tool_hnode, head);
@@ -399,8 +402,8 @@ int cu__encode_btf(struct cu *cu, int verbose, bool 
force)
                 }

                 if (verbose)
-                       printf("symbol '%s' of address 0x%lx encoded\n",
-                              sym_name, addr);
+                       printf("symbol '%s' of address 0x%lx encoded, 
type %u\n",
+                              sym_name, addr, type);

                 /* add a BTF_KIND_VAR in btfe->types */
                 linkage = var->external ? BTF_VAR_GLOBAL_ALLOCATED : 
BTF_VAR_STATIC;
diff --git a/libbtf.c b/libbtf.c
index 7a01ded..3a0d8d7 100644
--- a/libbtf.c
+++ b/libbtf.c
@@ -304,6 +304,8 @@ static const char * const btf_kind_str[NR_BTF_KINDS] = {
         [BTF_KIND_RESTRICT]     = "RESTRICT",
         [BTF_KIND_FUNC]         = "FUNC",
         [BTF_KIND_FUNC_PROTO]   = "FUNC_PROTO",
+       [BTF_KIND_VAR]          = "VAR",
+       [BTF_KIND_DATASEC]      = "DATASEC",
  };

  static const char *btf_elf__name_in_gobuf(const struct btf_elf *btfe, 
uint32_t offset)
@@ -671,7 +673,7 @@ int32_t btf_elf__add_var_type(struct btf_elf *btfe, 
uint32_t type, uint32_t name
                 return -1;
         }

-       btf_elf__log_type(btfe, &t.type, false, false, "type=%u name=%s",
+       btf_elf__log_type(btfe, &t.type, false, false, "type=%u name=%s\n",
                           t.type.type, btf_elf__name_in_gobuf(btfe, 
t.type.name_off));

         return btfe->type_index;

It would be good if you can add some of the above changes to
pahole for easier `pahole -JV` dump.

With the above change, I only got static per cpu variables.
For example,
    static DEFINE_PER_CPU(unsigned int , mirred_rec_level);
in net/sched/act_mirred.c.

[10] INT 'unsigned int' size=4 bits_offset=0 nr_bits=32 encoding=(none)
[74536] VAR 'mirred_rec_level' type_id=10, linkage=static

The dwarf debug_info entry for `mirred_rec_level`:
0x0001d8d6:   DW_TAG_variable
                 DW_AT_name      ("mirred_rec_level")
                 DW_AT_decl_file 
("/data/users/yhs/work/net-next/net/sched/act_mirred.c")
                 DW_AT_decl_line (31)
                 DW_AT_decl_column       (0x08)
                 DW_AT_type      (0x00000063 "unsigned int")
                 DW_AT_location  (DW_OP_addr 0x0)
It is not a declaration and it contains type.

All global per cpu variables do not have BTF_KIND_VAR generated.
I did a brief investigation and found this mostly like to be a
pahole issue. For example, for global per cpu variable
bpf_prog_active,
   include/linux/bpf.h
         DECLARE_PER_CPU(int , bpf_prog_active);
   kernel/bpf/syscall.c
         DEFINE_PER_CPU(int , bpf_prog_active);
it is declared in the header include/linux/bpf.h and
defined in kernel/bpf/syscall.c.

In many cu's, you will see:
0x0003592a:   DW_TAG_variable
                 DW_AT_name      ("bpf_prog_active")
                 DW_AT_decl_file 
("/data/users/yhs/work/net-next/include/linux/bpf.h")
                 DW_AT_decl_line (1074)
                 DW_AT_decl_column       (0x01)
                 DW_AT_type      (0x0001fa7e "int")
                 DW_AT_external  (true)
                 DW_AT_declaration       (true)

In kernel/bpf/syscall.c, I see
the following dwarf entry for real definition:
0x00013534:   DW_TAG_variable
                 DW_AT_name      ("bpf_prog_active")
                 DW_AT_decl_file 
("/data/users/yhs/work/net-next/include/linux/bpf.h")
                 DW_AT_decl_line (1074)
                 DW_AT_decl_column       (0x01)
                 DW_AT_type      (0x000000d6 "int")
                 DW_AT_external  (true)
                 DW_AT_declaration       (true)

0x00021a25:   DW_TAG_variable
                 DW_AT_specification     (0x00013534 "bpf_prog_active")
                 DW_AT_decl_file 
("/data/users/yhs/work/net-next/kernel/bpf/syscall.c")
                 DW_AT_decl_line (43)
                 DW_AT_location  (DW_OP_addr 0x0)

Note that for the second entry DW_AT_specification points to the 
declaration. I am not 100% sure whether pahole handle this properly or 
not. It generates a type id 0 (void) for bpf_prog_active variable.

Could you investigate this a little more?

I am using gcc 8.2.1. Using kernel default dwarf (dwarf 2) exposed
the above issue. Tries to use dwarf 4 and the problem still exists.


> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   include/linux/btf.h      | 15 +++++++++
>   include/uapi/linux/bpf.h | 38 ++++++++++++++++------
>   kernel/bpf/btf.c         | 15 ---------
>   kernel/bpf/verifier.c    | 68 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 112 insertions(+), 24 deletions(-)
> 
[...]
