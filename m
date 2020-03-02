Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E734175F72
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgCBQWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:22:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26998 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726831AbgCBQWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:22:30 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022G9YuO001154;
        Mon, 2 Mar 2020 08:22:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=z7kxYs7WGJvlHdOpmZwOPGPJWdSTO1HGf4CTNmPAuAs=;
 b=mbRCWjEha6ze09BWnv41OpS7HCTaZ232tEFRd5LbuRujWuLBfn9ZQkRuf3C8BvCuVlBl
 B7ODS1P+5f/HSt63rF93SN3qqTsGitaPDkM1byK43fEAB8/G/S/z0+lZy04zGvBnkaNo
 8XIR+FmKAtX6SteBTZaCc3IPLt43IAaRqng= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpnqrd66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 08:22:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 08:22:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJE/4jMdWKeRBsjHEM5SjPAjTKG3TGHc0xhc5IIU7UVTj37sT60juRrYCxdARRtmHb8oaf+mPRzrHlhtUc4kewBD1hGEYNXaZiFZBkv152WMECPDW3T6BnbyKxbBGodQqzzqErfdkRVBbUPLy6FEKl2q1mS7LMsoE4jslfo8xuPNKZfJj5ocmDZw11MbCwJB4a0Bn8GxuTsgG0hjwBhqry8NVhIfdxHf8vNQc2duzAcsuOqW+9k+UmOK3N6xVXVJWWc54+QV/Wd33zVa7rH+bcppiGn6FaloKvIxWH+zCplFn6Srow5lt/r4XV9WiqkVjzWe7AgIT79WBG1pcCawVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7kxYs7WGJvlHdOpmZwOPGPJWdSTO1HGf4CTNmPAuAs=;
 b=nHNvNbHEMRYK3UlGb436OJpV43sJsp4ORM6PWkxoiO3aYkqyCLS95qLwwMceV/DktO/zZb567MDvCIgyOr7ObkoLduZYX9MfhASSEbuIwzn1cTKrYh9C3xXNm877kYbkMwV4RV0qKXP3OKZl/2tSYp6flxUAUnTQCIxyb6k4+JShV/1EgG2+YY0fanIwQVF7+j2d9IvNpK4qOuTrzYiHZwLA30vwz2iBVDm81eXCqGVB5uwIEGvm9748vymOYsYoKfcrgPJ96GDGm7Qy2KOg7sG8DsksjopOd703/X+fwnRFKpcdmMGb0/4mtkbyzU23HxR9NMeaEVBzbZ9pk2OXjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7kxYs7WGJvlHdOpmZwOPGPJWdSTO1HGf4CTNmPAuAs=;
 b=TgeI/CrCPR0/dC+9RBV+PPkAQTFlx3BHJZ8W96cN2lrBm/frwH/cgYdyk2bKpMLhd+CeYlv2MzwclBrpFAgZrbUikkk4KCpJI9UzWcg1sVGuO6zg5RM+iwLsLBx4Vu4CeuPutJrHGV3te4GbypNhbayzpyZ7V9HLzvLnM0aZzII=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3338.namprd15.prod.outlook.com (2603:10b6:5:168::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Mon, 2 Mar
 2020 16:22:15 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:22:14 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to
 enums
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200301062405.2850114-1-andriin@fb.com>
 <20200301062405.2850114-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b57cdf6d-0849-2d54-982e-352886f86201@fb.com>
Date:   Mon, 2 Mar 2020 08:22:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200301062405.2850114-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:301:1::13) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::6:87b3) by MWHPR11CA0003.namprd11.prod.outlook.com (2603:10b6:301:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 16:22:13 +0000
X-Originating-IP: [2620:10d:c090:500::6:87b3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d94c60d1-cc0b-4a7c-50a8-08d7bec5de24
X-MS-TrafficTypeDiagnostic: DM6PR15MB3338:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB333834EE54BE4330AB05783BD3E70@DM6PR15MB3338.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(36756003)(6486002)(316002)(186003)(16526019)(2616005)(66476007)(4326008)(66556008)(86362001)(81156014)(6512007)(31696002)(81166006)(66946007)(8676002)(2906002)(478600001)(8936002)(52116002)(31686004)(5660300002)(6506007)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3338;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKY51mVM5D8qf/NevavaTbaQi2xl2kSAcpfxk2wUvCUubQv8UD4E7UV1JuI6w5L5yy8sWM4Gr7juuZ6X/+1Cbi7cH3nnY9j6swTS7MrtXwtpZFFOwAwEQ+FLIBLuqpM7rFoWHsTUSFy8Emq+MBDaANeysFNh/zKVVfGnJv+JMejGhoNP8gv0ntYA1u84EWaBGQHXY1v/lSSCWyQFp3l8fA4SsnsrNWjbDzvC59E2W1n+iSqWzs1JQThD/DmKMA/3IzesaGSoabo+YiK+yBDnRy2L9O9txBxYCGOxH6JJCe/EaGrvlTjJAUEXl12m5hhfpfj78dVN/UG69Vhc1vptuDd+mezLvInsColKgppc35iRiUgHu8c3gjXcUKWsX7RdeYu4vFYn4b5tIgKYM18yAVb0WqWFEDITogkXWVEKjwndQRevvEJw8MS3nfy1MP6+
X-MS-Exchange-AntiSpam-MessageData: ii/JXAlIlUSM57MS8WggCjQW1iXxxxF+FU2aV3RkI4071RVtx6EgGzPaQsJau7euQAGrMw1+PAUhkC0FLSvraeKOblTw0uGkY/rSeu5eOIeIK9GnTiDKm7aFFxlYLZwMu+hPGsnBJzjOx8TFQKulumO7jlNdtSwMqgOgg4QDoWyyRSmHIMo9gszltYhcn28r
X-MS-Exchange-CrossTenant-Network-Message-Id: d94c60d1-cc0b-4a7c-50a8-08d7bec5de24
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 16:22:14.3069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1B2oJ1lUBnugevDv7fWXnGHmgbemz9O1qv3hkKbBXAWe9Xv+K++FRt5QgoZA4YlG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3338
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/29/20 10:24 PM, Andrii Nakryiko wrote:
> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> enum values. This preserves constants values and behavior in expressions, but
> has added advantaged of being captured as part of DWARF and, subsequently, BTF
> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> for BPF applications, as it will not require BPF users to copy/paste various
> flags and constants, which are frequently used with BPF helpers.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
>   include/uapi/linux/bpf_common.h       |  86 ++++----
>   include/uapi/linux/btf.h              |  60 +++---
>   tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
>   tools/include/uapi/linux/bpf_common.h |  86 ++++----
>   tools/include/uapi/linux/btf.h        |  60 +++---
>   6 files changed, 497 insertions(+), 341 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 8e98ced0963b..03e08f256bd1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -14,34 +14,36 @@
>   /* Extended instruction set based on top of classic BPF */
>   
>   /* instruction classes */
> -#define BPF_JMP32	0x06	/* jmp mode in word width */
> -#define BPF_ALU64	0x07	/* alu mode in double word width */
> +enum {
> +	BPF_JMP32	= 0x06,	/* jmp mode in word width */
> +	BPF_ALU64	= 0x07,	/* alu mode in double word width */

Not sure whether we have uapi backward compatibility or not.
One possibility is to add
   #define BPF_ALU64 BPF_ALU64
this way, people uses macros will continue to work.

If this is an acceptable solution, we have a lot of constants
in net related headers and will benefit from this conversion for
kprobe/tracepoint of networking related functions.

>   
>   /* ld/ldx fields */
> -#define BPF_DW		0x18	/* double word (64-bit) */
> -#define BPF_XADD	0xc0	/* exclusive add */
> +	BPF_DW		= 0x18,	/* double word (64-bit) */
> +	BPF_XADD	= 0xc0,	/* exclusive add */
>   
>   /* alu/jmp fields */
> -#define BPF_MOV		0xb0	/* mov reg to reg */
> -#define BPF_ARSH	0xc0	/* sign extending arithmetic shift right */
> +	BPF_MOV		= 0xb0,	/* mov reg to reg */
> +	BPF_ARSH	= 0xc0,	/* sign extending arithmetic shift right */
>   
>   /* change endianness of a register */
> -#define BPF_END		0xd0	/* flags for endianness conversion: */
> -#define BPF_TO_LE	0x00	/* convert to little-endian */
> -#define BPF_TO_BE	0x08	/* convert to big-endian */
> -#define BPF_FROM_LE	BPF_TO_LE
> -#define BPF_FROM_BE	BPF_TO_BE
> +	BPF_END		= 0xd0,	/* flags for endianness conversion: */
> +	BPF_TO_LE	= 0x00,	/* convert to little-endian */
> +	BPF_TO_BE	= 0x08,	/* convert to big-endian */
> +	BPF_FROM_LE	= BPF_TO_LE,
> +	BPF_FROM_BE	= BPF_TO_BE,
>   
>   /* jmp encodings */
> -#define BPF_JNE		0x50	/* jump != */
> -#define BPF_JLT		0xa0	/* LT is unsigned, '<' */
> -#define BPF_JLE		0xb0	/* LE is unsigned, '<=' */
> -#define BPF_JSGT	0x60	/* SGT is signed '>', GT in x86 */
> -#define BPF_JSGE	0x70	/* SGE is signed '>=', GE in x86 */
> -#define BPF_JSLT	0xc0	/* SLT is signed, '<' */
> -#define BPF_JSLE	0xd0	/* SLE is signed, '<=' */
> -#define BPF_CALL	0x80	/* function call */
> -#define BPF_EXIT	0x90	/* function return */
> +	BPF_JNE		= 0x50,	/* jump != */
> +	BPF_JLT		= 0xa0,	/* LT is unsigned, '<' */
> +	BPF_JLE		= 0xb0,	/* LE is unsigned, '<=' */
> +	BPF_JSGT	= 0x60,	/* SGT is signed '>', GT in x86 */
> +	BPF_JSGE	= 0x70,	/* SGE is signed '>=', GE in x86 */
> +	BPF_JSLT	= 0xc0,	/* SLT is signed, '<' */
> +	BPF_JSLE	= 0xd0,	/* SLE is signed, '<=' */
> +	BPF_CALL	= 0x80,	/* function call */
> +	BPF_EXIT	= 0x90,	/* function return */
> +};
>   
[...]
