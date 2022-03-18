Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0064DD265
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiCRBX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiCRBX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:23:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE2C2A4566;
        Thu, 17 Mar 2022 18:22:40 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22I0vrpJ018080;
        Thu, 17 Mar 2022 18:22:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/AJJ7X6srwI/giHUxWeZdSG80nIPV9tY28tMdo/pwJI=;
 b=k5PIkIA+SZ0upZc/ygkF80ccoNK6pR4Ethw8Mo0TsnaUGsDut/fbkZPZDR4m5XHt/4fp
 +MaoM32AqxE5bkZak5BZjYQxaCsinTJkDDYjXnoTGxthI7tIPDr6o0BPGcjwlw3hO0YX
 94/DRsT/aEdiJIMgn13t2z0IbDTb3x0oBfM= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3evfyw03g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 18:22:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaXlEIr1TdT2Z8PCAMLq5hHkdPaN2kwjuPQ4Hv2e4daqIuLTvFQqRwm6+hwuS4vryV2Qk/0RZzu/EBxhBg6nLuVPxVjWOInKh6M3fcekInHWoa21Rk3A4wRpMW8obcn4vRE82Lh3hEgoBQ6vDCpulffJGUiN7ZYx4dWiSgwlIufvLb66hHpnfNDSmKyP4tLJpH9qlLHwYh6VpKiVTwx7vS/vVhXxttYV/le1Q+heiJNNczzxdZdb2JsV5117v8Vc70g49nADwjbrEsL3Zm+lJbYAQ2DGt6DfLb+IZLNmN1XFWLectdwo+S9iy+9UNwxlEU4oPML2rh8Na8LRdRPisA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AJJ7X6srwI/giHUxWeZdSG80nIPV9tY28tMdo/pwJI=;
 b=dRjcEqPZSzyhE3TeLRt3Zgmtsh0oI7kPAPO7lLFmMVV+ors35+ea21arhlEJcCz7SRafWuE4+IaJ28DWYaoPVRToBkZi2YE2+ImAdjZhq9Bo34hBRBrjYa6xm0NLGomd8Tf1awb2LPvwfewwrxtCv+A2374+hC6nVBvNIh1KI1fIFW3GUQ64r8rCO18VzichU1W5H29GxWWNeRWGxkq6E1QQL7iI2XGIidc0PdVHHYlXTIAtJdCZDuI7t9HB/HSacSXURgnT3P1i+mTIg2lw+FC7N9d5Q+Pu/BzDvLO4RMsTUtiOd/1VGMSL0Fhy8c/vIrxaGtVxTo7AMESt9rxynA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4660.namprd15.prod.outlook.com (2603:10b6:806:19f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Fri, 18 Mar
 2022 01:22:23 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 01:22:23 +0000
Date:   Thu, 17 Mar 2022 18:22:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Treat bpf_sk_lookup remote_port as a
 2-byte field
Message-ID: <20220318012219.wtrpgaawg4czsqcj@kafai-mbp.dhcp.thefacebook.com>
References: <20220317165826.1099418-1-jakub@cloudflare.com>
 <20220317165826.1099418-2-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317165826.1099418-2-jakub@cloudflare.com>
X-ClientProxiedBy: MW4P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::6) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb02c56a-3f18-4dc5-21aa-08da087dc12a
X-MS-TrafficTypeDiagnostic: SA1PR15MB4660:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4660D6FD3F16B779BEC1213CD5139@SA1PR15MB4660.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWMLLxrEjU0gkhMbjovjmAiQVGaRvyvpSv+W2zQovch1R/i3iHCkFlLGEBNOVYa4vkJrUsXh14w7lAGB0RnotHFpLdORMBiIVIHsH6LrnBepw+OgENGNM4YKqbP5sL9HL/Tk3peDI/F4d33p3CFqTeNazPmBPphNEVYLnInJPJr6zlBRvVhD/MT2zYo8Z3DWa8vlp/QgyWo4ccmCFN9NKy1nZSZjxWwj73N4BfH0Ba3QhIFIlgBtF+cIvtudhYV2l64OmI61xDGeHcLGdU/YS2Cqsxi+cXmUrTeZcWYUxC0VvbyXbf62gHV/d+UQM+kWyMUndMm9KHtiyV8+ydxoaNox+EEBtuOgGP6Z2ZR6aBuZ0OaUBtnVXqd44cDC1dEy6nsgVzdWVCfF+pvk2Q034kOeTE6rMKbeNoaHZD6HyA/Uk/6c+b+jylZuadrlZRtluUr9ti3AilFX0XLvLdEQpoY7OtsdMqTJUyvp0SWgWkud2JjTNZ2rX7zHOu8WvDRKvnxnzoFh6p0LiQm49GPCkfCRwjlDNI2z9uPd4vS25ka/SDiEq7mqzCqcQx/u/SisGxg4nJ7lL68o5gJfC6eG53v8SkVXk9YAjBIuJqrfQs7mmQ0lnPGq4dqgRW4mcueECFDlMoG7dGI/Lgc3qwDUcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(52116002)(9686003)(6512007)(6506007)(6666004)(86362001)(6486002)(2906002)(186003)(5660300002)(8936002)(54906003)(83380400001)(508600001)(8676002)(66946007)(66556008)(66476007)(6916009)(1076003)(316002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qAFV+K2ixqM4B8AcaRiJH1jxvQdmAUvuRsxtHO1Ryzb6IiRTFmcHjoBjPclH?=
 =?us-ascii?Q?8qI8uRtcTu5kosRzqOiwHzsfO0lRtyo9KJ1tJtPqqvAGqilmp4YJCZ6b0j99?=
 =?us-ascii?Q?PsoJ40Xoj+S3q9UJLT4eOQ53/F+bvrU3RtDz3WCqI135fJg+9/FVbxSPWIin?=
 =?us-ascii?Q?MPx6wfCvb5Bjbko0iwqYgGeIPzpR8qA0xLa3BAIFsD6/kv4m5s4tc7RtMCQW?=
 =?us-ascii?Q?BcegmFkqNTqSXy+7rYDxQ5dn63TPM2hzFcVTRkEPSVkuJamWH4zgFb64UZ4v?=
 =?us-ascii?Q?+70JC5+4LwNvLWW+n4X0/qKW/ydZceZcZa2qKVgrJkVg1h1aM4Ez0AKguPsr?=
 =?us-ascii?Q?MqcQQjIvmwUVK1CXZjdzCQdOGe+yD+bkn0qnOVbzCs5hKAwQHaRjgWVpnBfM?=
 =?us-ascii?Q?jcpXxv/h4p+hPeSofwK8DhLTXVGkm3jz8lXxBNmcfS+w1OMq8salf70T6gOa?=
 =?us-ascii?Q?KWnr5iyu6xaNYo0e9qpLGy0DRL0xFP+msmR1AREQTfcEdHKNatvKetynjEg+?=
 =?us-ascii?Q?AHY+6XDkwT6Qz9c71vj2O/0oOtyOPLc1F2aNhd4ku8V6mxs0cTo2HlnQ4lbU?=
 =?us-ascii?Q?Ymt9AOllgDFEXBJn/SkXT5wS8DtCIgKey1BgJlzCbegHWQKmBBA6mKAxUOFk?=
 =?us-ascii?Q?Fx69KSbVclcGB8K3hHO6tMFdsAX5WsJ9f4ccbQJ5ajDeKRyIIFVPKJEMPqx+?=
 =?us-ascii?Q?EeVqx5YMdqYe1fuT6nOSKpOf0EeIeITRTUCy68Ly2veRsdOWn/B/ShVhnrtD?=
 =?us-ascii?Q?fQ3vWrKJ/LBDVrsbZZrKFcL41brkAMiSL7uFacYeZdHB1AkTVX7tsI99SZRx?=
 =?us-ascii?Q?IIxWJNiemyYpWdhl54wKHA8tTqElMY5nA0F2YTzB15xYdKhnz1Onj3WdTrQn?=
 =?us-ascii?Q?44QgHwakE7bdeVehfupKKm5T71gH0j1bw0/P8MKbZOD5fNzc0XW4bwhe13Qy?=
 =?us-ascii?Q?X8dhvI3Gf10fqvGHHF2cTZKDtuCXuPKuYv4tvh1pUdLeyBEhoqhiYrA0FE6D?=
 =?us-ascii?Q?f+Q7jJV/GHjj/gOh+eqiAFb+tuVkrLf4tmi9DM1MvweqwOrfd42+bpb3Qgl5?=
 =?us-ascii?Q?gxchwXDgz6Nf+pRdG36GQ7tQw5FKgGnF74LDRsVkCOhfYTLkCWIymO48hQzS?=
 =?us-ascii?Q?j/bXhw+DYCpRJ+DdAqMIw8mEAFICrXXuXNMrdQkChNgk3VWZ4+oIY3hIxdn4?=
 =?us-ascii?Q?BdRb1HPnJPLbE4d2Zp63Xygx0CLFtdqNjJLal9KswG1OvkmdQLjIxlmOuCpw?=
 =?us-ascii?Q?N5IknDSbccVL5EKAvlEvvxLaSC7kMAceZ29OVAkvpmgQ1RTjrFgj20p+lfg1?=
 =?us-ascii?Q?7ntuvQcA0Cb1oSjDEQEjaLjg/69OLg2jZm+d+F/iJtdhzY6bck4CW7/ufNoW?=
 =?us-ascii?Q?zvEfIyj5InaB8nk3E1bNHQbZpJXFTsUz4ofoAwDDHgC9bGAmk98u/CaEFIBW?=
 =?us-ascii?Q?zfLkJvbKv6tHxsGXrp+S7szxAXV/OzpYvCuccIl5WBtNtB7XsvFqnw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb02c56a-3f18-4dc5-21aa-08da087dc12a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 01:22:23.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZ4OGva2lxhd+lnAeicymtWdIL2T/ZEDSqmX4CIm5Q76NXw22dB+LIMmGaQ63MIf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4660
X-Proofpoint-ORIG-GUID: nv8Tkr1ufUilxmq0lBIbNJBYIhpkeepy
X-Proofpoint-GUID: nv8Tkr1ufUilxmq0lBIbNJBYIhpkeepy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_07,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 05:58:24PM +0100, Jakub Sitnicki wrote:
> In commit 9a69e2b385f4 ("bpf: Make remote_port field in struct
> bpf_sk_lookup 16-bit wide") the remote_port field has been split up and
> re-declared from u32 to be16.
> 
> However, the accompanying changes to the context access converter have not
> been well thought through when it comes big-endian platforms.
> 
> Today 2-byte wide loads from offsetof(struct bpf_sk_lookup, remote_port)
> are handled as narrow loads from a 4-byte wide field.
> 
> This by itself is not enough to create a problem, but when we combine
> 
>  1. 32-bit wide access to ->remote_port backed by a 16-wide wide load, with
>  2. inherent difference between litte- and big-endian in how narrow loads
>     need have to be handled (see bpf_ctx_narrow_access_offset),
> 
> we get inconsistent results for a 2-byte loads from &ctx->remote_port on LE
> and BE architectures. This in turn makes BPF C code for the common case of
> 2-byte load from ctx->remote_port not portable.
> 
> To rectify it, inform the context access converter that remote_port is
> 2-byte wide field, and only 1-byte loads need to be treated as narrow
> loads.
> 
> At the same time, we special-case the 4-byte load from &ctx->remote_port to
> continue handling it the same way as do today, in order to keep the
> existing BPF programs working.
> 
> Fixes: 9a69e2b385f4 ("bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/filter.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 03655f2074ae..9b1e453baf6d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -10989,13 +10989,24 @@ static bool sk_lookup_is_valid_access(int off, int size,
>  	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
>  	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
>  	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
> -	case offsetof(struct bpf_sk_lookup, remote_port) ...
> -	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
>  	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
>  	case bpf_ctx_range(struct bpf_sk_lookup, ingress_ifindex):
>  		bpf_ctx_record_field_size(info, sizeof(__u32));
>  		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
>  
> +	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
> +		/* Allow 4-byte access to 2-byte field for backward compatibility */
> +		if (size == sizeof(__u32))
> +			return off == offsetof(struct bpf_sk_lookup, remote_port);
nit. The bad "off" value should have been rejected earlier in the
"if (off % size != 0)" check?

> +		bpf_ctx_record_field_size(info, sizeof(__be16));
> +		return bpf_ctx_narrow_access_ok(off, size, sizeof(__be16));
> +
> +	case offsetofend(struct bpf_sk_lookup, remote_port) ...
> +	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
> +		/* Allow access to zero padding for backward compatibility */
> +		bpf_ctx_record_field_size(info, sizeof(__u16));
> +		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
> +
>  	default:
>  		return false;
>  	}
> @@ -11077,6 +11088,11 @@ static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
>  						     sport, 2, target_size));
>  		break;
>  
> +	case offsetofend(struct bpf_sk_lookup, remote_port):
> +		*target_size = 2;
> +		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
> +		break;
> +
>  	case offsetof(struct bpf_sk_lookup, local_port):
>  		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
>  				      bpf_target_off(struct bpf_sk_lookup_kern,
> -- 
> 2.35.1
> 
