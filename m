Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136E324A32B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgHSPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:32:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22796 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbgHSPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:32:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JFVwnh005346;
        Wed, 19 Aug 2020 08:32:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PxcfV38LlaY3J75Su5wbXtIs9tgLp2TLBsH77iDnXj4=;
 b=SopQ3aREpqH9svNRIxzW8oXzss4KCNT0BojJF86xmPMkTnHY9c/so0CKld2P8IBisdX2
 0nEgddt3Njw/ufq4HmXNl10cDLsRvK7jPZbL8tS20NSGNkLSZqrB2CiSup8jDM6xTnqd
 bjKhcGbxo8AeUWfhXdr0XRzKPKpDNpxuFFE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304kps359-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 08:32:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 08:31:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvHD7jtHDgQBPJiy7H17URfhhhuELUByc1HCdiKoOr9+doT9c2desiXhmQTIAslVJGL9C90tP4m7ozmJ00O7/6pKRFmGb5hFjKWBn76H8jt8O9QMkA/Kz+ElaK5ElGuTj/RO5tpGAvi3F+bGZ2g+BIK/TH+kjn43RuMdRhnMCXYJWMWZgUONHc6EAwZo03VAW4FeRiOGuubKq1LtN4gtyKQURpjZt9iEfLsNmV/UHw5wcudbM+VFOYtT+Bu9Zsi8V7Ri6CdaKtiEb83YwvYV27w1OZM9JDv67U9L+eAqfv34b4ZanXwE4HxciLY8lYKGonXNMxUZZR646D+142PTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxcfV38LlaY3J75Su5wbXtIs9tgLp2TLBsH77iDnXj4=;
 b=ngbIJAVLb9NM7gGqCQkCAI2JXNEb/3UGlnoJkBQ67h2e8SrJ/IhfSlFx4v/qH3ALyRNKhnE6TEY9lQ9rsSK/PK0vURrJr8g59IWRi6lZQIyxi7upZlLCU7WmXYmqQ1lVAAQ3MFeYWOUMIoS3rSyLr+1OvXwpz9Yi6xBA/v+D8OgmIiXw8OfidHssAeI+sduBFaowQsVSvdfRINWvxn07ytTxdqZIKGZT0CdPBqYS+XAYcvR8iz7RHBhrxTBXPlp8IEQ9o4cX1kf4XdSqnFOP4bisracJ6pvAnsMWEES+pQltvJfrno2DSa6XBl4ZTv7xdvXJEtHQTcHAx4Hn+AFeRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxcfV38LlaY3J75Su5wbXtIs9tgLp2TLBsH77iDnXj4=;
 b=MYdhoeIyiBF6aK5zBjPzc3OPnn42gRE/8CWwL2PC9F/qVCWDFArsHkPDp4d5mgzmK5vOxt5cHtUUiExpsZfrrOGwmDcWTMxIwq6eZRiZ+QcKlKc+k87Cy08toPvP/NnnegmeLEnMxMgdH86NVfaC6VwyWlJE9e/C69pu+HnbHsg=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 15:31:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 15:31:56 +0000
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Mark Wielaard <mjw@redhat.com>, Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200819092342.259004-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
Date:   Wed, 19 Aug 2020 08:31:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092342.259004-1-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0092.namprd02.prod.outlook.com
 (2603:10b6:208:51::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:9a2) by BL0PR02CA0092.namprd02.prod.outlook.com (2603:10b6:208:51::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18 via Frontend Transport; Wed, 19 Aug 2020 15:31:53 +0000
X-Originating-IP: [2620:10d:c091:480::1:9a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dfe6a90-d5a9-47ed-1b24-08d84455016b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23766866695E12DA9906FBEFD35D0@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDw3/cRHSwe+DMbb0J/2/ir+hG5D5EOFIEjIhAmrIjO0JSaNUDxWRc2LhS4/krcAOiWRIe/W6Qg/hsklIMu0xgHsnzTs9SPP/fZVht9PwVOy8eymMalfbIajZRD7qgIOyzCtxS5bOrQLB1ynkvojBFZpo7Wakfl4Tlfn00KPMeqQik55F9yP6KLi+0W+Bv+h0PidUgFgrxijN5coUyVRYeEC4Mc9Ypk65KYTRB6CGitkUkWJZtUeCPiHCgZroya34iKbEg2IVCDmV8VNPomWSYDoMyDNdQ4Ka51U2pvS80e0lvfFEjjouQhep1R5bwgnldZHg2f0C/tRl5Jq2R6Rk7RhcPpiGSjXouXJ1+/VtMwBF4QGp+tccinoRcaMqVIa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(5660300002)(186003)(316002)(86362001)(31696002)(8676002)(66946007)(8936002)(478600001)(2906002)(66476007)(66556008)(53546011)(83380400001)(16526019)(6486002)(4326008)(110136005)(36756003)(54906003)(31686004)(52116002)(2616005)(7416002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vxCHG7lHWYBn2wkxtmBofRE1GAkh0TH6Svf79sduQU+Jyu70kliXzMWMC0a1DDYqRlTIM24KUJbJmAaRik7RXaVViRUq3vlhj9BjuZ3CWAtPK0YZWxxILfww7cJr3ts8pqa7pe/0CZLoIEGWMLUYnf0fwy49DR93qn7dsFM0R4/gU+AhnxdCXyin1fDiSD4wsVxSshQ0Kq7pwjMkyzlc8JgrWciP3QHIBkwJg7DF1XnzrlHGRVnqfaGBjCCyYDcfxVhCW+tRtKMgwUQQriWaadOmL1nNpqADvHwudoRW2ddDs8B+kj8C3IKtxmrDcbxfWr/TExF9IbKZwTeEflSCpDhxpxlo4EMtrN52qODk14f3v08sWy3XZ0ENMCWhvNEyCv12WRzhvuMX5U0vsesnpG9BxcXBs5e652iCvna0xLSrOZgnKOpjV2nKhX+FQlyKFiFKV4vnTCBdGi0yp/53m+L7QZW1RzmK85sXqTRX/70nyZdZvhTfAS5XWWYzBG7JQugYhTLzREaMGpFUVnoFyUUiFuekW2smpmcaTil2iYC92T7n+SDS+oAWDlilebsf3F2OQ1u9m/Q7HpG1+DVsv/Vywyj7PeNQFbMom40kAcX/KufZ18xY7RYYw7a40ST9X5EuXEf51oWn46Ug6W7DY2NVLKWfGTYbkhSLiugHuwtIr0/6vMCP+CEooZ+V7W5l
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfe6a90-d5a9-47ed-1b24-08d84455016b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:31:56.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pPcHLvXRAC5NUl3oPiL6iLkPTOOqX3E2UeSO64v5JikxKFpD0IIwnE3/wbJSSO7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_09:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:23 AM, Jiri Olsa wrote:
> The data of compressed section should be aligned to 4
> (for 32bit) or 8 (for 64 bit) bytes.
> 
> The binutils ld sets sh_addralign to 1, which makes libelf
> fail with misaligned section error during the update as
> reported by Jesper:
> 
>     FAILED elf_update(WRITE): invalid section alignment
> 
> While waiting for ld fix, we can fix compressed sections
> sh_addralign value manually.
> 
> Adding warning in -vv mode when the fix is triggered:
> 
>    $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
>    ...
>    section(36) .comment, size 44, link 0, flags 30, type=1
>    section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 16, expected 8
>    section(38) .debug_info, size 129104957, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(40) .debug_line, size 7374522, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(41) .debug_frame, size 702463, link 0, flags 800, type=1
>    section(42) .debug_str, size 1017571, link 0, flags 830, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 16, expected 8
>    section(45) .symtab, size 2955888, link 46, flags 0, type=2
>    section(46) .strtab, size 2613072, link 0, flags 0, type=3
>    ...
>    update ok for vmlinux
> 
> Another workaround is to disable compressed debug info data
> CONFIG_DEBUG_INFO_COMPRESSED kernel option.

So CONFIG_DEBUG_INFO_COMPRESSED is required to reproduce the bug, right?

I turned on CONFIG_DEBUG_INFO_COMPRESSED in my config and got a bunch of
build failures.

ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize 
decompress status for section .debug_info
ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize 
decompress status for section .debug_info
ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize 
decompress status for section .debug_info
ld: drivers/crypto/virtio/virtio_crypto_algs.o: unable to initialize 
decompress status for section .debug_info
drivers/crypto/virtio/virtio_crypto_algs.o: file not recognized: File 
format not recognized

ld: net/llc/llc_core.o: unable to initialize decompress status for 
section .debug_info
ld: net/llc/llc_core.o: unable to initialize decompress status for 
section .debug_info
ld: net/llc/llc_core.o: unable to initialize decompress status for 
section .debug_info
ld: net/llc/llc_core.o: unable to initialize decompress status for 
section .debug_info
net/llc/llc_core.o: file not recognized: File format not recognized

...

The 'ld' in my system:

$ ld -V
GNU ld version 2.30-74.el8
   Supported emulations:
    elf_x86_64
    elf32_x86_64
    elf_i386
    elf_iamcu
    i386linux
    elf_l1om
    elf_k1om
    i386pep
    i386pe
$

Do you know what is the issue here?

> 
> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> Cc: Mark Wielaard <mjw@redhat.com>
> Cc: Nick Clifton <nickc@redhat.com>
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/bpf/resolve_btfids/main.c | 36 +++++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
> 
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index 4d9ecb975862..0def0bb1f783 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -233,6 +233,39 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
>   	return btf_id__add(root, id, false);
>   }
>   
> +/*
> + * The data of compressed section should be aligned to 4
> + * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
> + * sets sh_addralign to 1, which makes libelf fail with
> + * misaligned section error during the update:
> + *    FAILED elf_update(WRITE): invalid section alignment
> + *
> + * While waiting for ld fix, we fix the compressed sections
> + * sh_addralign value manualy.
> + */
> +static int compressed_section_fix(Elf *elf, Elf_Scn *scn, GElf_Shdr *sh)
> +{
> +	int expected = gelf_getclass(elf) == ELFCLASS32 ? 4 : 8;
> +
> +	if (!(sh->sh_flags & SHF_COMPRESSED))
> +		return 0;
> +
> +	if (sh->sh_addralign == expected)
> +		return 0;
> +
> +	pr_debug2(" - fixing wrong alignment sh_addralign %u, expected %u\n",
> +		  sh->sh_addralign, expected);
> +
> +	sh->sh_addralign = expected;
> +
> +	if (gelf_update_shdr(scn, sh) == 0) {
> +		printf("FAILED cannot update section header: %s\n",
> +			elf_errmsg(-1));
> +		return -1;
> +	}
> +	return 0;
> +}
> +
>   static int elf_collect(struct object *obj)
>   {
>   	Elf_Scn *scn = NULL;
> @@ -309,6 +342,9 @@ static int elf_collect(struct object *obj)
>   			obj->efile.idlist_shndx = idx;
>   			obj->efile.idlist_addr  = sh.sh_addr;
>   		}
> +
> +		if (compressed_section_fix(elf, scn, &sh))
> +			return -1;
>   	}
>   
>   	return 0;
> 
