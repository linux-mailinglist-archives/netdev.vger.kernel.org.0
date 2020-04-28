Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0E1BC6E0
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgD1RgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:36:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728022AbgD1RgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:36:05 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03SHZce6003763;
        Tue, 28 Apr 2020 10:35:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=r3UPXVL8pAv17wt5JLueeAID1oLGToszyWEjx0AqKoU=;
 b=Iko9gHHBBU1CayiFf/Hirp2vNCGI7gdQvKkdFM3smP/V22C/7PNogw/aIvg11DFe6bHJ
 lkCPii/N6a7zkgKZ2RSV8EA6rB479D0C4RW12XkSwDhhdKveI7Net7UZGeiJKInCv/bx
 JDDWjZIWPv4/mM3MSpup0GKOAWlfjVcAWXA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30ntjvt8an-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 10:35:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 10:35:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7TO3GpTo+rIXLNAqAD+raxyyBDVyZWRxrXtBSD/n/L8YBWK3IuU20jq/DuMrb/lSZfy6vv5/DVCmg/2QWRifIjq/OIyGii7ge0CEadxSKQ36DZG/8MYB2m+Al57mMqZvpMjzto/U95Z8KX7nuPt/IEjcxnTnLkmcVpY/Bmj3SDoH7G8702GVP4sL6bybWLpF9Udqbx1mWDJEnwGngU29kdMqb3y/e7gSOXv0mr68Bkx+lVYph9+zVroxxMfamqi0LBRpet6fN8BvYdcIWW6BVSL5Lvcq1raHKJEJJxWNKTmCYj62RO7Zmk6kJ59+PmPv3ZN5Xu6XsUoluLWtz8Luw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3UPXVL8pAv17wt5JLueeAID1oLGToszyWEjx0AqKoU=;
 b=HmG3X5uYsaKLBVqgU1/bWmNiifXWRKQBpsabGxJ/sd3LilKGBAviamEZTHrLfLF6caXreLp46AarJgySM9hfb4kaqm6PXS5f7Kej1Hu2ehzAb+yoNafbPEe3c/JkRB0FFagHGNfwpxexVCzOalrZENI6KIRHGKp/p4ersFNbAT79oEAsGrnNNSOPRYNOf+LVtLMd7bj6KmSlWUDR0mn2Qd0KEbsKXg4AT/pNpbuT8+zPUrz0kLrmf4tpkGqP4npHqhkIdAIpMw+JIA72pq3jz6MhqxK6lmpPqRFfatvdLe8h/OpF1heJX69PFVUGQjkpXUkoNtOBm06e/Zc0Gx1Ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3UPXVL8pAv17wt5JLueeAID1oLGToszyWEjx0AqKoU=;
 b=C1x/88GgeOUNK5h6A2rZJ1+tHfKBdy/ivV17SqKQO91FNocWlE97GWa6PBX3UTCkGUyCPvyRBlCiTQ8MnGsJaARn7y/1O+H5Li6Hq0uAe8zmZKw5JBpf52cGjS6ZuESA1shvO/qRvwOO3O4Dq5c+gwt2XWccNDu4mF0nKaOJP4o=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3477.namprd15.prod.outlook.com (2603:10b6:a03:10e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 28 Apr
 2020 17:35:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 17:35:37 +0000
Subject: Re: [PATCH bpf-next v1 16/19] tools/bpftool: add bpf_iter support for
 bptool
To:     Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201253.2996156-1-yhs@fb.com>
 <05d9c82d-8cba-db77-02af-265e4d200946@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <82034392-5f65-fd84-8cbd-d2aa85f01ee3@fb.com>
Date:   Tue, 28 Apr 2020 10:35:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <05d9c82d-8cba-db77-02af-265e4d200946@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0073.namprd15.prod.outlook.com
 (2603:10b6:101:20::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:4420) by CO1PR15CA0073.namprd15.prod.outlook.com (2603:10b6:101:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 17:35:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:4420]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12bf58b1-33cd-4695-45b8-08d7eb9a900f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB347711D07C61E4B6D8C39756D3AC0@BYAPR15MB3477.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0387D64A71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvzSfDGyqy2xtY7YTklmmL2/gI3Iebow7GWPfROIKEKCrnbxNTOEx4SsNtB829GbP21PH1Gl/ntLz6xEK7igYfzPCEJAuabBUgK/8q4pmiYns6xW72AodqrsT4cODvxPPEk0R0BFHtxQDDMzQVKiUTBdiInUmq0BUlZ1H+BZMuLNu0LysrpQNy6NVvFatkWTIp9fIqH2kGZJLdeLI01EV+BebSXi3dz0p4hekdBNuE1C99sM+vseEjJCETjeW1iJ3rR3/RguDsbF48g9ooej1oU1eHRkMjNvN+C+5uXN22Pl77hDkIsDiXG453WPMZWzhmPqQLpcAVpLvZFCtNLNWNXd9nOlxEoG25RTT6ddvxUV4Vlj3ky7PkXdFMdJnMkEY2fZfNCp3C+6qnaoAEM5bGFk6418i7YeDg3HSw75W0DShBRRUjf19lZ7h31Qi/wv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(52116002)(8936002)(66946007)(2906002)(5660300002)(8676002)(478600001)(36756003)(31696002)(6512007)(86362001)(6486002)(30864003)(16526019)(186003)(4326008)(31686004)(6506007)(53546011)(110136005)(54906003)(316002)(66556008)(66476007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IYpYatlsuhFJHtKeXplLDXPDk8gO+DuS7umbFGVuyX6zh0mBw6b0cVGjQ0KHx8bbjlvdbXLa+KN1xSH6Lavs7YdgDIAIcSdOLaGPIfNuVJjrWZsZS5vJECYrbmtwFc9fCYhvRDnDyVo0OR7GcWeoUAzPgwdl+qvTibeKotrxfrQbPXvQsMtKcxTxE7/r+8K5ulcECRgLy6IAWoRgarOW//VGqb6B8+JB9LNjPQq2zHI5m3DX9LlMKOcbpg/NgBeg3GgczxC7kyGDNt0w2qii7XH27YsZihNoZ05qo7UO3uQwdSIQQ8hoi1yLALqJ87pMJT+xDWnqsmCcLcQsHHJ4M7oNPR/LMURLul2O/sDlvxaT1ApVeiW9fF2yLa8NBBXWl+UR79ErkfwMyWNnVMGEC5GuXbYsWwh1dljb5SLxAUDfZS90XDTT5d7ckRSYk26qO4SxOT5PXpMFhHSduajo/dsEYNesVDaq2Aai5lPsBO07855Px8x2CCSz6iLLNhsMIjYZZ2/GuPMvEjZTVHhXMDuGxuDnFlm+j6DH8H3FgC9hu939/IOnRZmuogZoobRZiSpPEbVkOOugGiBZBDsAxv/30CYxyxCOIEhFF8rvKF11T26ODDvGk/GUGXc5o7CKoEEXvW3dspOVPdA43JEJDOGwn1FEFHTv9xAgadPbrBHSqokubJwlNqX/jqRD9wdzmc9k3hu7DsO9iul7rUFe7Fg7h9HN4XRKjixAVJWaifmpJ0o0Mp5RmMxQ0HSk9c+ywHrtsqQ7Iw2VQFIwHMWk60oEWEDKu4wlhIl+d+BtskM+1xKl3+d5GyqB0XrWAVpknXqVxDqhVk+5XvR/BB3uVA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 12bf58b1-33cd-4695-45b8-08d7eb9a900f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 17:35:37.1614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBaX1pzgMsbpy/4VJCXfv03gQJPKYhn61THqG2SMlMX1YeOTmKZVzIvUrWfuQ5Js
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3477
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_12:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 2:27 AM, Quentin Monnet wrote:
> 2020-04-27 13:12 UTC-0700 ~ Yonghong Song <yhs@fb.com>
>> Currently, only one command is supported
>>    bpftool iter pin <bpf_prog.o> <path>
>>
>> It will pin the trace/iter bpf program in
>> the object file <bpf_prog.o> to the <path>
>> where <path> should be on a bpffs mount.
>>
>> For example,
>>    $ bpftool iter pin ./bpf_iter_ipv6_route.o \
>>      /sys/fs/bpf/my_route
>> User can then do a `cat` to print out the results:
>>    $ cat /sys/fs/bpf/my_route
>>      fe800000000000000000000000000000 40 00000000000000000000000000000000 ...
>>      00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>>      00000000000000000000000000000001 80 00000000000000000000000000000000 ...
>>      fe800000000000008c0162fffebdfd57 80 00000000000000000000000000000000 ...
>>      ff000000000000000000000000000000 08 00000000000000000000000000000000 ...
>>      00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>>
>> The implementation for ipv6_route iterator is in one of subsequent
>> patches.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   .../bpftool/Documentation/bpftool-iter.rst    | 71 ++++++++++++++++
>>   tools/bpf/bpftool/bash-completion/bpftool     | 13 +++
>>   tools/bpf/bpftool/iter.c                      | 84 +++++++++++++++++++
>>   tools/bpf/bpftool/main.c                      |  3 +-
>>   tools/bpf/bpftool/main.h                      |  1 +
>>   5 files changed, 171 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
>>   create mode 100644 tools/bpf/bpftool/iter.c
>>
>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
>> new file mode 100644
>> index 000000000000..1997a6bac4a0
>> --- /dev/null
>> +++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
>> @@ -0,0 +1,71 @@
>> +============
>> +bpftool-iter
>> +============
>> +-------------------------------------------------------------------------------
>> +tool to create BPF iterators
>> +-------------------------------------------------------------------------------
>> +
>> +:Manual section: 8
>> +
>> +SYNOPSIS
>> +========
>> +
>> +	**bpftool** [*OPTIONS*] **iter** *COMMAND*
>> +
>> +	*COMMANDS* := { **pin** | **help** }
>> +
>> +STRUCT_OPS COMMANDS
> 
> s/STRUCT_OPS/ITER/

Oops. copy-paste error. Will fix.

> 
>> +===================
>> +
>> +|	**bpftool** **iter pin** *OBJ* *PATH*
>> +|	**bpftool** **struct_ops help**
> 
> s/struct_ops/iter/

Will fix.

> 
>> +|
>> +|	*OBJ* := /a/file/of/bpf_iter_target.o
>> +
>> +
>> +DESCRIPTION
>> +===========
>> +	**bpftool iter pin** *OBJ* *PATH*
> 
> Would be great to have a small blurb on what BPF iterators are and what
> they can do. I'm afraid users reading this man page will have no idea
> whatsoever.

Will add.

> 
>> +		  Create a bpf iterator from *OBJ*, and pin it to
>> +		  *PATH*. The *PATH* should be located in *bpffs* mount.
> 
> Can you keep the note that other pages have about the dot character
> being forbidden in *PATH* basename, please?

Will add.

> 
>> +
>> +	**bpftool struct_ops help**
> 
> s/struct_ops/iter/

Will fix.

> 
>> +		  Print short help message.
>> +
>> +OPTIONS
>> +=======
>> +	-h, --help
>> +		  Print short generic help message (similar to **bpftool help**).
>> +
>> +	-V, --version
>> +		  Print version number (similar to **bpftool version**).
>> +
>> +	-d, --debug
>> +		  Print all logs available, even debug-level information. This
>> +		  includes logs from libbpf as well as from the verifier, when
>> +		  attempting to load programs.> +
>> +EXAMPLES
>> +========
>> +**# bpftool iter pin bpf_iter_netlink.o /sys/fs/bpf/my_netlink**
>> +
>> +::
>> +
>> +   Create a file-based bpf iterator from bpf_iter_netlink.o and pin it
>> +   to /sys/fs/bpf/my_netlink
>> +
>> +
>> +SEE ALSO
>> +========
>> +	**bpf**\ (2),
>> +	**bpf-helpers**\ (7),
>> +	**bpftool**\ (8),
>> +	**bpftool-prog**\ (8),
>> +	**bpftool-map**\ (8),
>> +	**bpftool-cgroup**\ (8),
>> +	**bpftool-feature**\ (8),
>> +	**bpftool-net**\ (8),
>> +	**bpftool-perf**\ (8),
>> +	**bpftool-btf**\ (8)
>> +	**bpftool-gen**\ (8)
>> +	**bpftool-struct_ops**\ (8)
>> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
>> index 45ee99b159e2..17a81695da0f 100644
>> --- a/tools/bpf/bpftool/bash-completion/bpftool
>> +++ b/tools/bpf/bpftool/bash-completion/bpftool
>> @@ -604,6 +604,19 @@ _bpftool()
>>                       ;;
>>               esac
>>               ;;
>> +        iter)
>> +            case $command in
>> +                pin)
>> +                    _filedir
>> +                    return 0
>> +                    ;;
>> +                *)
>> +                    [[ $prev == $object ]] && \
>> +                        COMPREPLY=( $( compgen -W 'help' \
>> +                            -- "$cur" ) )
> 
> You should probably offer "pin" here in addition to "help".

Will add.

> 
>> +                    ;;
>> +            esac
>> +            ;;
>>           map)
>>               local MAP_TYPE='id pinned name'
>>               case $command in
>> diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
>> new file mode 100644
>> index 000000000000..db9fae6be716
>> --- /dev/null
>> +++ b/tools/bpf/bpftool/iter.c
>> @@ -0,0 +1,84 @@
>> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +// Copyright (C) 2020 Facebook
>> +
>> +#define _GNU_SOURCE
>> +#include <linux/err.h>
>> +#include <bpf/libbpf.h>
>> +
>> +#include "main.h"
>> +
>> +static int do_pin(int argc, char **argv)
>> +{
>> +	const char *objfile, *path;
>> +	struct bpf_program *prog;
>> +	struct bpf_object *obj;
>> +	struct bpf_link *link;
>> +	int err;
> 
> Nit: initialise err t0 -1 do you don't have to set it three times below?

Double checked cmd_select() handling the return value:
   0 : success
   non-0 : failure

Looking like I can remove two `err = -1` below.

> 
>> +
>> +	if (!REQ_ARGS(2))
>> +		usage();
>> +
>> +	objfile = GET_ARG();
>> +	path = GET_ARG();
>> +
>> +	obj = bpf_object__open(objfile);
>> +	if (IS_ERR_OR_NULL(obj)) {
>> +		p_err("can't open objfile %s", objfile);
>> +		return -1;
>> +	}
>> +
>> +	err = bpf_object__load(obj);
>> +	if (err < 0) {
>> +		err = -1;
>> +		p_err("can't load objfile %s", objfile);
>> +		goto close_obj;
>> +	}
>> +
>> +	prog = bpf_program__next(NULL, obj);
>> +	link = bpf_program__attach_iter(prog, NULL);
>> +	if (IS_ERR(link)) {
>> +		err = -1;
>> +		p_err("attach_iter failed for program %s",
>> +		      bpf_program__name(prog));
>> +		goto close_obj;
>> +	}
>> +
>> +	err = bpf_link__pin(link, path);
> 
> Try to mount bpffs before that if "-n" is not passed? You could even
> call do_pin_any() from common.c by passing bpf_link__fd().

You probably means do_pin_fd()? That is a good suggestion, will use it
in the next revision.

> 
>> +	if (err) {
>> +		err = -1;
>> +		p_err("pin_iter failed for program %s to path %s",
>> +		      bpf_program__name(prog), path);
>> +		goto close_link;
>> +	}
>> +
>> +	err = 0;
>> +
>> +close_link:
>> +	bpf_link__disconnect(link);
>> +	bpf_link__destroy(link);
>> +close_obj:
>> +	bpf_object__close(obj);
>> +	return err;
>> +}
>> +
>> +static int do_help(int argc, char **argv)
>> +{
>> +	fprintf(stderr,
>> +		"Usage: %s %s pin OBJ PATH\n"
>> +		"       %s %s help\n"
>> +		"\n",
>> +		bin_name, argv[-2], bin_name, argv[-2]);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct cmd cmds[] = {
>> +	{ "help",	do_help },
>> +	{ "pin",	do_pin },
>> +	{ 0 }
>> +};
>> +
>> +int do_iter(int argc, char **argv)
>> +{
>> +	return cmd_select(cmds, argc, argv, do_help);
>> +}
>> dif	"",
>>   		bin_name, bin_name, bin_name);
>> @@ -222,6 +222,7 @@ static const struct cmd cmds[] = {
>>   	{ "btf",	do_btf },
>>   	{ "gen",	do_gen },
>>   	{ "struct_ops",	do_struct_ops },
>> +	{ "iter",	do_iter },
>>   	{ "version",	do_version },
>>   	{ 0 }
>>   };
>> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
>> index 86f14ce26fd7..2b5d4a616b48 100644
>> --- a/tools/bpf/bpftool/main.h
>> +++ b/tools/bpf/bpftool/main.h
>> @@ -162,6 +162,7 @@ int do_feature(int argc, char **argv);
>>   int do_btf(int argc, char **argv);
>>   int do_gen(int argc, char **argv);
>>   int do_struct_ops(int argc, char **argv);
>> +int do_iter(int argc, char **argv);
>>   
>>   int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
>>   int prog_parse_fd(int *argc, char ***argv);
>> f --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
>> index 466c269eabdd..6805b77789cb 100644
>> --- a/tools/bpf/bpftool/main.c
>> +++ b/tools/bpf/bpftool/main.c
>> @@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
>>   		"       %s batch file FILE\n"
>>   		"       %s version\n"
>>   		"\n"
>> -		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen | struct_ops }\n"
>> +		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen | struct_ops | iter }\n"
>>   		"       " HELP_SPEC_OPTIONS "\n"
>>   		"",
>>   		bin_name, bin_name, bin_name);
>> @@ -222,6 +222,7 @@ static const struct cmd cmds[] = {
>>   	{ "btf",	do_btf },
>>   	{ "gen",	do_gen },
>>   	{ "struct_ops",	do_struct_ops },
>> +	{ "iter",	do_iter },
>>   	{ "version",	do_version },
>>   	{ 0 }
>>   };
>> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
>> index 86f14ce26fd7..2b5d4a616b48 100644
>> --- a/tools/bpf/bpftool/main.h
>> +++ b/tools/bpf/bpftool/main.h
>> @@ -162,6 +162,7 @@ int do_feature(int argc, char **argv);
>>   int do_btf(int argc, char **argv);
>>   int do_gen(int argc, char **argv);
>>   int do_struct_ops(int argc, char **argv);
>> +int do_iter(int argc, char **argv);
>>   
>>   int parse_u32_arg(int *argc, char ***argv, __u32 *val, const char *what);
>>   int prog_parse_fd(int *argc, char ***argv);
>>
> 
> Have you considered simply adapting the more traditional workflow
> "bpftool prog load && bpftool prog attach" so that it supports iterators
> instead of adding a new command? It would:

This is a good question, I should have clarified better in the commit
message.
   - prog load && prog attach won't work.
     the create_iter is a three stage process:
       1. prog load
       2. create and attach to a link
       3. pin link
     In the current implementation, the link merely just has the program.
     But in the future, the link will have other parameters like map_id,
     tgid/gid, or cgroup_id, or others.

     We could say to do:
       1. bpftool prog load <pin_path>
       2. bpftool iter pin prog file
          <maybe more parameters in the future>

     But this requires to pin the program itself in the bpffs, which
     mostly unneeded for file iterator creator.

     So this command `bpftool iter pin ...` is created for ease of use.

> 
> - Avoid adding yet another bpftool command with a single subcommand

So far, yes, in the future we may have more. In my RFC patcch, I have
`bpftool iter show ...` for introspection, this is to show all 
registered targets and all file iterators prog_id's.

This patch does not have it and I left it for the future work.
I am considering to use bpf iterator to do introspection here...

> 
> - Enable to reuse the code from prog load, in particular for map reuse
> (I'm not sure how relevant maps are for iterators, but I wouldn't be
> surprised if someone finds a use case at some point?)

Yes, we do plan to have map element iterators. We can also have
bpf_prog or other iterators. Yes, map element iterator use 
implementation should be `bpftool map` code base since it is
a use of bpf_iter infrastructure.

> 
> - Avoid users naively trying to run "bpftool prog load && bpftool prog
> attach <prog> iter" and not understanding why it fails

`bpftool prog attach <prog> [map_id]` mostly used to attach a program to
a map, right? In this case, it won't apply, right?

BTW, Thanks for reviewing and catching my mistakes!

> 
> Quentin
> 
