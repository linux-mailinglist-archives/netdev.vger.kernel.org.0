Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19433A0693
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 00:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFHWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 18:11:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhFHWK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 18:10:58 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158M5mq3029950;
        Tue, 8 Jun 2021 15:08:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0kJuj8ujqojBR+3sTXmwGrRGQYrH9t9b38PRS4bCHVg=;
 b=aLvqoZqGhnobpvnWmwbQxASukllqqbI+S0aY9fKQ4MbDX7zEslHeL4Sklxofki04Mh+A
 PZ4soyR6ttUX+51PoutU8lyYoBtc8U+E7g+RS7Y8Brn+TpYAmeYH89AmqrzpdjL2qxQT
 uvR86sk7URa2rNy/wfJh/H8FObY++ZuTCZE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 392fmdrgk6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Jun 2021 15:08:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 15:08:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W37n/kUdT/r++tbKLzPYnBBv+ifXJbLhSgY5lSNMjDdhbSdo8wmK6K0+/bnCEqwzi1zdcoleT9VaeEh0XI0NvpBGBBmubIA/9jjul1IEgsqi1vdrAZrVzfF9cr0nCr7Vc1s47hBhPR87NThB5OFSL3Kq+0yV5Gw/1su3wan3LzMiu9MyyJ0/6ThimE2FyA4+LXdpvDseo0qaDG6m4b9Ec5ghodsNwFtHupUlzwN/wtaHLmIOZM5fWEJFNXyMRvksQCngptmGZ+yKAt6Uin53xpevbWjBxs8lGEWUyJwe1pnyiFVzasbtOjZu1qQWi6qaby1WWH7xHu61SkPD2J1psg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kJuj8ujqojBR+3sTXmwGrRGQYrH9t9b38PRS4bCHVg=;
 b=ky8K7Xmj/7TM0st14HPLQT/yiETTJ7auWqCz6DD7fgAQwkpO0Gvonbegp+57EcqjcrrgIpH+4LMVAzBcShqknHUAsgUldje8S/SSQrk6kgtA1GvXhdhvfPHO+GJvtsxGtEaHwyFW06pwKoNrSwYUi2MoZokU58wwakvsw+rmBcEM0gnhL7FT8mJQB1b6yglGqTnU79zxV704PYqkHRhs+INrrnyxWv+t0bDA7LoKTeeI0X8g95FQzoTQEuNzkE258ZBdGeqFaFlqFImL/aDS+DnscFBhCdlqNUjP/aGtmtym068vBlfKYRO+PBQZiirmUGxVaXekUxwWFp+fkq0qfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4239.namprd15.prod.outlook.com (2603:10b6:806:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 22:08:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 22:08:44 +0000
Date:   Tue, 8 Jun 2021 15:08:39 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next v4 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210608220839.c3xuapju2efn2k24@kafai-mbp>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-2-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210608170224.1138264-2-tannerlove.kernel@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:90f3]
X-ClientProxiedBy: MWHPR2201CA0039.namprd22.prod.outlook.com
 (2603:10b6:301:16::13) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:90f3) by MWHPR2201CA0039.namprd22.prod.outlook.com (2603:10b6:301:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 22:08:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 035e9606-606f-4407-e0da-08d92ac9fb31
X-MS-TrafficTypeDiagnostic: SN7PR15MB4239:
X-Microsoft-Antispam-PRVS: <SN7PR15MB4239722CB92FDE5F6248A8A6D5379@SN7PR15MB4239.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZOicjxdVt/TT4vGm49Un8afXzlqZFPdg3rHxc06FaWdgjDTaFWfkfD+QUbCdyj21r4CldgDHhYOLb1NAM0ftW0w2CymJOSQjkjDi62L2K7QxUCLHQHmKGb0ScK979MyPuDvu4Gn20KSwm4ctNTxQfT/iotKJgieSsZk9k4Zr4zpum7I10GuGdZW9T7UELe5BmmZtg2qkLwVxv5VWvi93ner5pYya4vp5CPqArdpGRecEeLUNGIHuT3SkChPfT29BG9+xd5kH7n8eFkFkz1pUMswBhNc6fu4csU6RXrSnmHNhrm32UYwW4ETn4vNmsMehoncGLvizTh8Q2/U1AUBruBAWHFqMGg3KBshYsYkcRxsXDWDvGFKGr8yIwS50QMGrpNDRJY8Mjye2+cvE/JQQhJZkvRb/peBzdbZ7ujaNN7U7nqWOcm4/ERRLh/XT8Zk5vPiEM5tToiJXtpZ26bTDPOowdnsrhmetM7tyDHX/CDTidM3eYLVXiMfcPeyv350DrsBmKeRrEjnzVM4Fn3+TZwzsZmYjaSc4CI7YMoWV8RDIQcLmYPyYjQXhV0ZzgmlwVpFRXF8cD25yOm2MWlcs4zE/tyttJ1Deu54B+k2ozM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(2906002)(6666004)(5660300002)(1076003)(186003)(7416002)(16526019)(316002)(9686003)(8936002)(86362001)(8676002)(54906003)(83380400001)(6496006)(52116002)(6916009)(4326008)(66946007)(66556008)(66476007)(33716001)(38100700002)(478600001)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lVVcm12hppYWYCBTCGI/BOzRTyXRS/kqbG5orOmnZ0H/cFiQ7U0Q4bVHLkqT?=
 =?us-ascii?Q?PSLSu1k5lJCNaqF5DT6gfiy4RcLGDGAxROXgmeUlUkKCx0OShHS4hWghSybp?=
 =?us-ascii?Q?bnj52hNs4ZU+1wQp55J07iBqHc5jErGE9NCacNpvKSf51YoB8DnZ8TFvY2yo?=
 =?us-ascii?Q?o7NxBFe8ivMcEjuDd+e600oPoo4NdxRPadeEqdXFCI74RNDXnUpW9BAOztTa?=
 =?us-ascii?Q?qFsmEF/BaDTGe2GHJ9uy0BntHFmVFSGJ/JCsoz1U44QEK0lMWqAGyVj01OR0?=
 =?us-ascii?Q?CXl8kGk+ksJz8vS4FlfnpT6xJTquSZDZl9RW9X5O4SsmpEAwAvpODXpI1Rtp?=
 =?us-ascii?Q?cET+o+WAWgq1GBaDoSkpzGHZo1CYVpz5YuvaLqRl/Da7JhbfP105HwP8HHVA?=
 =?us-ascii?Q?mRm06NSNJa7bR5ItKOIjTDmpk2NzHjzN9tJRRYJTtMkSDYjQ2vOmYWmCzfPT?=
 =?us-ascii?Q?TTFTIE/M16waEYaYysVurBZXeKUQXl22clqS1GF2UFLCC1ePhwadrFZR/eOQ?=
 =?us-ascii?Q?lXmgkPGKKw5zT1OGuz+uRW6kAzmRuUOtiAWgmP4pDcyM7jtiPrC0WJsOSAcd?=
 =?us-ascii?Q?nw8lB0ROtvDH1DK6imVPLcaHX77SQQ2LllxA9aZiDAqVPMxkIiImjjrRuY6K?=
 =?us-ascii?Q?ySUmh1YbHk2rjjD4pqzv93MknHrsTqI3Oi/OeBXmAyuUyPgrd12lPQnut5j8?=
 =?us-ascii?Q?9J5VMXbPqD41Va7h+zmUbL7kpXA/bhWozQse+p9NVkoPP7JaGyNprZ6q9qZV?=
 =?us-ascii?Q?V/s0UXC4QX6XqehL4HYECc9A5BZfc+2nspc2RhTt/X9ruhJAv/3MrdK/USsv?=
 =?us-ascii?Q?2EmKtKGKLWfQpZB7zOi+lsQPX/tUvlEO/Yaa5lyJ1kMd1IWI06WSDKRshY1f?=
 =?us-ascii?Q?lB3LB8tzYxoQjcAVckG03Qyb2scFge8pZI1Kvx6B5FkO51c6J1N2adbYdrLR?=
 =?us-ascii?Q?quSoUpIiDPVGtYhoCDCsrtuiSFkGZtPvmfwk+HQ0RRUG4lnbgsUgvfa1cfLD?=
 =?us-ascii?Q?3IiA9md4wSucztiAn9Y1b8vByWBZJZES3g+IfB+DHRXXRp09/rmUtnj64eh9?=
 =?us-ascii?Q?cDbAnLQQA6bI3c71L6gmvb9PKbhFSsOmGYWjDiWF+f76jTDJpFNp3UOVUJS4?=
 =?us-ascii?Q?C3D6mOZWo2DabLGfDudlO4v4iSPjFAGI7LjkjnIw90a7fwq9KrK96f2yBUGX?=
 =?us-ascii?Q?aPgV32X67dKoDWIi0y36kc8Qh1k6ZsinIFfV5uU00an5mjtqksetZ7eerjbx?=
 =?us-ascii?Q?uIl8MRqzc3LWdMwp2ymS2jHVcp/Y9fVww93A3fDnTZkt3RzYNoUjzqEfgoNx?=
 =?us-ascii?Q?ts8Snw/gAaWh7eGDAjeNBe9YHYnAE1KI1mJ5bA9FMwysng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 035e9606-606f-4407-e0da-08d92ac9fb31
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 22:08:44.2591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZyCRaTietysue9qU+9HRbs1jdYPtQQ1Cbn5zxoQcV8YAZ7NOn/4bApqF8fv6n9U0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4239
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: nUL-TeIyecjxfhPyMr1PY1TN14awGC2l
X-Proofpoint-ORIG-GUID: nUL-TeIyecjxfhPyMr1PY1TN14awGC2l
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_17:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 01:02:22PM -0400, Tanner Love wrote:
[ ... ]

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9dc44ba97584..a333e6177de1 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -430,6 +430,8 @@ enum bpf_reg_type {
>  	PTR_TO_PERCPU_BTF_ID,	 /* reg points to a percpu kernel variable */
>  	PTR_TO_FUNC,		 /* reg points to a bpf program function */
>  	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
> +	PTR_TO_VNET_HDR,	 /* reg points to struct virtio_net_hdr */
> +	PTR_TO_VNET_HDR_OR_NULL, /* reg points to virtio_net_hdr or NULL */
>  	__BPF_REG_TYPE_MAX,
>  };
>
[ ... ]

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 418b9b813d65..e1ac34548f9a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
>  	};
>  	__u32	flags;
>  	__be32	flow_label;
> +	__bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
> +	__u8	vhdr_is_little_endian;
>  };
>  
>  struct bpf_func_info {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 331b170d9fcc..2962b537da28 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -22,6 +22,7 @@
>  #include <linux/error-injection.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/btf_ids.h>
> +#include <linux/virtio_net.h>
>  
>  #include "disasm.h"
>  
> @@ -441,7 +442,8 @@ static bool reg_type_not_null(enum bpf_reg_type type)
>  		type == PTR_TO_TCP_SOCK ||
>  		type == PTR_TO_MAP_VALUE ||
>  		type == PTR_TO_MAP_KEY ||
> -		type == PTR_TO_SOCK_COMMON;
> +		type == PTR_TO_SOCK_COMMON ||
> +		type == PTR_TO_VNET_HDR;
>  }
>  
>  static bool reg_type_may_be_null(enum bpf_reg_type type)
> @@ -453,7 +455,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
>  	       type == PTR_TO_BTF_ID_OR_NULL ||
>  	       type == PTR_TO_MEM_OR_NULL ||
>  	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
> -	       type == PTR_TO_RDWR_BUF_OR_NULL;
> +	       type == PTR_TO_RDWR_BUF_OR_NULL ||
> +	       type == PTR_TO_VNET_HDR_OR_NULL;
>  }
>  
>  static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
> @@ -576,6 +579,8 @@ static const char * const reg_type_str[] = {
>  	[PTR_TO_RDWR_BUF_OR_NULL] = "rdwr_buf_or_null",
>  	[PTR_TO_FUNC]		= "func",
>  	[PTR_TO_MAP_KEY]	= "map_key",
> +	[PTR_TO_VNET_HDR]	= "virtio_net_hdr",
> +	[PTR_TO_VNET_HDR_OR_NULL] = "virtio_net_hdr_or_null",
>  };
>  
>  static char slot_type_char[] = {
> @@ -1166,6 +1171,9 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
>  	case PTR_TO_RDWR_BUF_OR_NULL:
>  		reg->type = PTR_TO_RDWR_BUF;
>  		break;
> +	case PTR_TO_VNET_HDR_OR_NULL:
> +		reg->type = PTR_TO_VNET_HDR;
> +		break;
>  	default:
>  		WARN_ONCE(1, "unknown nullable register type");
>  	}
> @@ -2528,6 +2536,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
>  	case PTR_TO_MEM_OR_NULL:
>  	case PTR_TO_FUNC:
>  	case PTR_TO_MAP_KEY:
> +	case PTR_TO_VNET_HDR:
> +	case PTR_TO_VNET_HDR_OR_NULL:
>  		return true;
>  	default:
>  		return false;
> @@ -3384,6 +3394,18 @@ static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
>  	return 0;
>  }
>  
> +static int check_virtio_net_hdr_access(struct bpf_verifier_env *env, int off,
> +				       int size)
> +{
> +	if (size < 0 || off < 0 ||
> +	    (u64)off + size > sizeof(struct virtio_net_hdr)) {
> +		verbose(env, "invalid access to virtio_net_hdr off=%d size=%d\n",
> +			off, size);
> +		return -EACCES;
> +	}
> +	return 0;
> +}
> +
>  static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
>  			     u32 regno, int off, int size,
>  			     enum bpf_access_type t)
> @@ -3568,6 +3590,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
>  	case PTR_TO_XDP_SOCK:
>  		pointer_desc = "xdp_sock ";
>  		break;
> +	case PTR_TO_VNET_HDR:
> +		pointer_desc = "virtio_net_hdr ";
> +		break;
>  	default:
>  		break;
>  	}
> @@ -4218,6 +4243,23 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  		}
>  
>  		err = check_flow_keys_access(env, off, size);
> +		if (!err && t == BPF_READ && value_regno >= 0) {
> +			if (off == offsetof(struct bpf_flow_keys, vhdr)) {
> +				regs[value_regno].type = PTR_TO_VNET_HDR_OR_NULL;
check_flow_keys_access() needs some modifications

1. What if t == BPF_WRITE?  I think "keys->vhdr = 0xdead" has to be rejected.
   
2. It needs to check loading keys->vhdr is in sizeof(__u64) like other
   pointer loading does.  Take a look at the flow_keys case in
   flow_dissector_is_valid_access().

It also needs to convert the pointer loading like how
flow_dissector_convert_ctx_access() does on flow_keys.

A high level design question.  "struct virtio_net_hdr" is in uapi and
there is no need to do convert_ctx.  I think using PTR_TO_BTF_ID_OR_NULL
will be easier here and the new PTR_TO_VNET_HDR* related changes will go away.

The "else if (reg->type == PTR_TO_CTX)" case earlier could be a good example.

To get the btf_id for "struct virtio_net_hdr", take a look at
the BTF_ID_LIST_SINGLE() usage in filter.c

> +				/* required for dropping or_null */
> +				regs[value_regno].id = ++env->id_gen;
> +			} else {
> +				mark_reg_unknown(env, regs, value_regno);
> +			}
> +		}
> +	} else if (reg->type == PTR_TO_VNET_HDR) {
> +		if (t == BPF_WRITE) {
> +			verbose(env, "R%d cannot write into %s\n",
> +				regno, reg_type_str[reg->type]);
> +			return -EACCES;
> +		}
> +
> +		err = check_virtio_net_hdr_access(env, off, size);
>  		if (!err && t == BPF_READ && value_regno >= 0)
>  			mark_reg_unknown(env, regs, value_regno);
>  	} else if (type_is_sk_pointer(reg->type)) {
[ ... ]

> @@ -8390,6 +8392,30 @@ static u32 flow_dissector_convert_ctx_access(enum bpf_access_type type,
>  				      si->dst_reg, si->src_reg,
>  				      offsetof(struct bpf_flow_dissector, flow_keys));
>  		break;
> +
> +	case offsetof(struct __sk_buff, len):
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, skb),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_flow_dissector, skb));
> +		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, 0, 4);
> +		/* bpf_flow_dissector->skb == NULL */
> +		/* dst_reg = bpf_flow_dissector->data_end */
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, data_end),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_flow_dissector, data_end));
> +		/* TMP = bpf_flow_dissector->data */
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, data),
> +				      BPF_REG_TMP, si->src_reg,
I don't think BPF_REG_TMP can be used here.  My understanding is that is for
classic bpf.  Try BPF_REG_AX instead.

It will be a good idea to cover this case if it has not been done in patch 3.

> +				      offsetof(struct bpf_flow_dissector, data));
> +		/* dst_reg -= bpf_flow_dissector->data */
> +		*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_TMP);
> +		*insn++ = BPF_JMP_A(1);
> +		/* bpf_flow_dissector->skb != NULL */
> +		/* bpf_flow_dissector->skb->len */
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
> +				      si->dst_reg, si->dst_reg,
> +				      offsetof(struct sk_buff, len));
> +		break;
>  	}
>  
>  	return insn - insn_buf;
