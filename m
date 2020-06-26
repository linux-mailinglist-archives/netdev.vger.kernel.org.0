Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE1520BB34
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgFZVKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:10:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49124 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgFZVKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:10:51 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QLAWG1030571;
        Fri, 26 Jun 2020 14:10:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=V9r4BGc5N0DxjAIwE0+lIfDodQntlcNUW/Lz5Ihwk6o=;
 b=hS2mCSsxIm8dOtY+ypjNJL+IcEjAcEq9YaMCzNTBT1lEqNQ4x7yVqCz+e3GXxjP2kUAF
 RhRtib7wMIfWDjdicF5dACKyG6B0FZHsffxOmBY2hCDTsYZz/b/8zwFM7/tEqxJfgld1
 xTXwrLEAwhfmPvJ1UoBZQBYL0SLnX4zPmnc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31w3w2n6vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 14:10:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 14:09:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjdXSAwyZd+q/BxiJz1Db1+MVZQ8FXoWVWs5qBKLdW0YPmp2pDUZPZf/56Wzf/XimmvdPh5+mFzH9VQUP6wh50t4SIiglt8piNfUYnuU2gJt2r9UkvXylpj5rHz4WjlsVihZuLSWXbS4nEtp1s0yUfW4PYoMW/qBNO9nCS2zLwdxHTn3vUoPZnqGq70VYOIWgb6KIgrTXeqTuY6XsaQl0HIIF1PyP+VjP/NBxB7PE5pHbZKPupOnk0DyHYpY+xRbc7kOSDtDupfNWvxPZxf3sYG7SPk5VBPH/hbGUCpbmpCyvf5K3y5Y4TDcYlWUrn2pW4VIzR8aS3Son0ConwBsrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9r4BGc5N0DxjAIwE0+lIfDodQntlcNUW/Lz5Ihwk6o=;
 b=A21oKKBs9lihRq2QuJaz73jQBXv7jfbzBWqS8dA9sbgesfJ//Fwa8fGJosrSGWKz5PxZDNeq8xfWiK/4dGvIR9RAdG+HUlLNBrdRFB67iBYT2b4hI3ThnE0soIOtXOYUJG6Tt1D3GL/nsjdA0FMNQLM37ULaAjxb6CmrevBoBB/cvSBeL2dDWBvGAYW2SoFIfbNrgjCujGJjLxrwhPWKE9o0TOiTIQcodZp1hxQUvfDYCcVpgGp+csNVoSPanShhb/WytbeOkl8RA/V4u4ST04X3I9Wlt69nUEb/gF9CT11/90b4JJCrxhMZtRDltF//Q2rg5m9FiSmk+aWWZGR1sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9r4BGc5N0DxjAIwE0+lIfDodQntlcNUW/Lz5Ihwk6o=;
 b=LaR/6hrtSi4fgT0Z5XYvu5zNsAdo5sBauN9QUWemnRYGovAjtDz5IgCEo/FL7k9ylT8B9qbXEad0hN6ZRQUprV0Xa/CeBB4zSzdhWFuBGxOYNLzp3ZX89iL6W52Nj3fInKj2YjZtPXJ2DFysw34dET5495lkvkz1KxlxcjB1tyQ=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 21:09:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 21:09:56 +0000
Subject: Re: [PATCH v4 bpf-next 01/14] bpf: Add resolve_btfids tool to resolve
 BTF IDs in ELF object
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-2-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d521c351-2bcd-2510-7266-0194ade5ca64@fb.com>
Date:   Fri, 26 Jun 2020 14:09:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200625221304.2817194-2-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1988] (2620:10d:c090:400::5:90d4) by BY3PR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:254::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.13 via Frontend Transport; Fri, 26 Jun 2020 21:09:55 +0000
X-Originating-IP: [2620:10d:c090:400::5:90d4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50072faf-5d4e-4bb2-6439-08d81a1546e1
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB35706499801B0D5F0B9EE86DD3930@BY5PR15MB3570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxUXHZerK3DfsFh064z6T3VBqP3IADE5hxbGysqApxaF1aE8A3tXq1Z2caO17nzvZ1/ol8fm/6G351BurZp6NGFRuBXgGds4SU6VLxKCiEyLn52aPax7wW//huwBGMFODxHWY43PF1ECftlVc4lKjMRV79BA9aJnNCVi4ZARNpdNU3Wb8Ka8RLjEDGJeTJKWusbPZsjkDZT8CYYMoDH+C0ZCvhT99jCEKXSeBTTe6wm0/msukOIcr+ycKFTPtMfc67CAasgx6dIVzOkavMj3ytLbD691hyo7GAssRcM6h1LLOuUNsFm6e8hATsF1C6ydcxQFvNLbjOtSARegUJV8fr7nEF0pQUDqk4au4+0lLaxRbL5QJkMgjNMFVBhDuWtg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(346002)(39860400002)(366004)(376002)(316002)(4326008)(478600001)(7416002)(5660300002)(86362001)(36756003)(31696002)(2906002)(2616005)(31686004)(54906003)(16526019)(53546011)(6486002)(186003)(66556008)(66946007)(8936002)(110136005)(66476007)(52116002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: l/axy+oR7MZrrJ5kGAnq4Q6WtmoZG8BCGHDs+Gzw7cxzSMZUoJsxz0rxCEEOU3wXBC5qsV7XUx8b8mNv4GBAZx+uO90AiRF0GDJ5dwY6C2SXZR+4afco4+LZdae6n+QIrJ+kJ1NIpoU/j2w1aBF+4uI3yfj6yrvPK5srltAkZCKOE7aVKVZ9GyrNBVmPCxuFIkj0+28W7BgkufMuav0jpZYeQVBwxpNJpS6yWcdJ0cqXMD00zpm0CaD6LUTRNOXVzxooy0Cjl0ecfyBaiJ/WU7mXbouAr/qK6M/U0u4rGobpmv8XFGh7zYSlYqlzG0mRhSqlZpkB/OCH47b6dtYUbTbK4f0JRG6GwqFRyTWWqbOlMm1HW8O/iSJEkwzJBbfchbEosmu7cBkmvKj8o24Edqr0CzR7xtqv8iv8U06gUxLZvLH73csk07OZ2k9pQy5OKpG/94NrSaw77xlfVAWc3lx9gb3D/xylj8331RkM/+tdisWzBQBbOjcfaoxrEwE24Lp0Is4keR7lBh6MjG4HTw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 50072faf-5d4e-4bb2-6439-08d81a1546e1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 21:09:56.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WSdV+HORWRLLlOPBEF3yXlJET1At8SIVFVuws5i0jJarSOaBimqIWioDLfdOOHs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1011
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/20 3:12 PM, Jiri Olsa wrote:
> The resolve_btfids tool scans elf object for .BTF_ids section
> and resolves its symbols with BTF ID values.
> 
> It will be used to during linking time to resolve arrays of BTF
> ID values used in verifier, so these IDs do not need to be
> resolved in runtime.
> 
> The expected layout of .BTF_ids section is described in btfid.c
> header. Related kernel changes are coming in following changes.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/bpf/resolve_btfids/Build    |  26 ++
>   tools/bpf/resolve_btfids/Makefile |  76 ++++
>   tools/bpf/resolve_btfids/main.c   | 716 ++++++++++++++++++++++++++++++
>   3 files changed, 818 insertions(+)
>   create mode 100644 tools/bpf/resolve_btfids/Build
>   create mode 100644 tools/bpf/resolve_btfids/Makefile
>   create mode 100644 tools/bpf/resolve_btfids/main.c
> 
> diff --git a/tools/bpf/resolve_btfids/Build b/tools/bpf/resolve_btfids/Build
> new file mode 100644
> index 000000000000..c7318cc55341
> --- /dev/null
> +++ b/tools/bpf/resolve_btfids/Build
> @@ -0,0 +1,26 @@
> +resolve_btfids-y += main.o
> +resolve_btfids-y += rbtree.o
> +resolve_btfids-y += zalloc.o
> +resolve_btfids-y += string.o
> +resolve_btfids-y += ctype.o
> +resolve_btfids-y += str_error_r.o
> +
> +$(OUTPUT)rbtree.o: ../../lib/rbtree.c FORCE
> +	$(call rule_mkdir)
> +	$(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)zalloc.o: ../../lib/zalloc.c FORCE
> +	$(call rule_mkdir)
> +	$(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)string.o: ../../lib/string.c FORCE
> +	$(call rule_mkdir)
> +	$(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)ctype.o: ../../lib/ctype.c FORCE
> +	$(call rule_mkdir)
> +	$(call if_changed_dep,cc_o_c)
> +
> +$(OUTPUT)str_error_r.o: ../../lib/str_error_r.c FORCE
> +	$(call rule_mkdir)
> +	$(call if_changed_dep,cc_o_c)
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> new file mode 100644
> index 000000000000..f6502ff26573
> --- /dev/null
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -0,0 +1,76 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +ifeq ($(srctree),)
> +srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +endif
> +
> +ifeq ($(V),1)
> +  Q =
> +  msg =
> +else
> +  Q = @
> +  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
> +  MAKEFLAGS=--no-print-directory
> +endif
> +
> +OUTPUT := $(srctree)/tools/bpf/resolve_btfids/
> +
> +LIBBPF_SRC := $(srctree)/tools/lib/bpf/
> +SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
> +
> +BPFOBJ     := $(OUTPUT)/libbpf.a
> +SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
> +
> +BINARY     := $(OUTPUT)/resolve_btfids
> +BINARY_IN  := $(BINARY)-in.o
> +
> +all: $(BINARY)
> +
> +$(OUTPUT):
> +	$(call msg,MKDIR,,$@)
> +	$(Q)mkdir -p $(OUTPUT)
> +
> +$(SUBCMDOBJ): fixdep FORCE
> +	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
> +
> +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> +	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
> +
> +CFLAGS := -g \
> +          -I$(srctree)/tools/include \
> +          -I$(srctree)/tools/include/uapi \
> +          -I$(LIBBPF_SRC) \
> +          -I$(SUBCMD_SRC)
> +
> +LIBS = -lelf -lz
> +
> +export srctree OUTPUT CFLAGS Q
> +include $(srctree)/tools/build/Makefile.include
> +
> +$(BINARY_IN): fixdep FORCE
> +	$(Q)$(MAKE) $(build)=resolve_btfids
> +
> +$(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
> +	$(call msg,LINK,$@)
> +	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
> +
> +libsubcmd-clean:
> +	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
> +
> +libbpf-clean:
> +	$(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
> +
> +clean: libsubcmd-clean libbpf-clean fixdep-clean
> +	$(call msg,CLEAN,$(BINARY))
> +	$(Q)$(RM) -f $(BINARY); \
> +	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
> +
> +tags:
> +	$(call msg,GEN,,tags)
> +	$(Q)ctags -R . $(LIBBPF_SRC) $(SUBCMD_SRC)
> +
> +FORCE:
> +
> +.PHONY: all FORCE clean tags

After applying the whole patch set to my bpf-next tree locally, I cannot 
build:

-bash-4.4$ make -j100 && make vmlinux
   GEN     Makefile
   DESCEND  objtool
   DESCEND  bpf/resolve_btfids
make[4]: *** No rule to make target 
`/data/users/yhs/work/net-next/tools/bpf/resolve_btfids/fixdep'.  Stop.
make[3]: *** [fixdep] Error 2
make[2]: *** [bpf/resolve_btfids] Error 2
make[1]: *** [tools/bpf/resolve_btfids] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: *** wait: No child processes.  Stop.
make: *** [__sub-make] Error 2
-bash-4.4$

Any clue what is the possible issue here?

> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> new file mode 100644
> index 000000000000..d758e2bdbc9d
> --- /dev/null
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -0,0 +1,716 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +
> +/*
> + * resolve_btfids scans Elf object for .BTF_ids section and resolves
[...]
