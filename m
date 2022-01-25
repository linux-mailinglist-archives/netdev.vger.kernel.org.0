Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C136249BED2
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiAYWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:46:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234071AbiAYWqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:46:13 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20PMO21m013784;
        Tue, 25 Jan 2022 14:45:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=VP2OOQjgTyxZ6R+IX1E7nTorto6FyG8Jphxj108Z6HM=;
 b=T+rpLSr2FeQA0WlW2Z+5iUMgQ/7Q33wns97yY2W4cYc0qEFQUn8Qubdmg+ErC2+TYc79
 YlDhZGzezUzkrURPlZXshHS1vIDTf37JR/XHaoFManB/W423tU4uISVks4fyrhpG4ZhD
 2wfUklEe+az7tUk5kwuiOSHvoX2AbYJpB0A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3dtebww0qa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Jan 2022 14:45:31 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 14:45:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnH2EV63m3tNFzXY2ChtMR9AcDrwrY86Xj7Uuq5IhE4GA/0qM3PUqRCK3RwS9FaGttMVM2dhHH7pBhBi3+yJfFWhKSn/e4gwFXqy0AXSsObgA8v/LRFnNKMCcoWo5ynp20n9fy5ea211aiWbMVPyPyR1yu/DKcWGHXcb7e58Dqlp3v1Cco7zyPb2vvXxi1v8PBN9uBMze9OBaqmOSGL/nlGC3NGqPLr3IJlk0cjSD/BhIfh/5KwCBPdJPsk6axsmdm822Qf1qLgw2jbERtjLWOv+GUnJAoSc+iz7Z4dX74hABk++Te34IcTi/j1Yfe9y3wBtHNZv2jk1vIWfH+/ezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VP2OOQjgTyxZ6R+IX1E7nTorto6FyG8Jphxj108Z6HM=;
 b=ZrkP1VVtiUB7/4Jwjf7ThRlyu8+0zoFBEYKpMhwEp23bT2SXYr8tTmbVWAEYHVSZuVcV1DSn9JTQ+s32PqM3IZwNHh1HkXyqKsflYvxTRkeO2D/czhgRuFp6eyj9lwpHoWUsj51O9PrRE43Sr2gXIUc6KdW3wcH5ddcjL9D0hhGj0c72BocXZWXOGzLq+yV61WWuEuuaItiupdCwQxgRJGG8IHmBpv14kVJ40wLXcffiAou/5Av74HyvUVo6ODdutTYBsk/Cp3nj3vx0rj6N/I0cgZT7zbyBwlRuNzdURVmMVCEqLsrJhZYDkpKu/k0Bjr4fc/5tahtFdxkyJn/TQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4967.namprd15.prod.outlook.com (2603:10b6:806:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 22:45:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 22:45:28 +0000
Date:   Tue, 25 Jan 2022 14:45:24 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <menglong8.dong@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mengensun@tencent.com>, <flyingpeng@tencent.com>,
        <mungerjiang@tencent.com>, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
Message-ID: <20220125224524.fkodqvknsluihw74@kafai-mbp.dhcp.thefacebook.com>
References: <20220113070245.791577-1-imagedong@tencent.com>
 <87sftbobys.fsf@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87sftbobys.fsf@cloudflare.com>
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd2adcbd-c196-4501-3aa0-08d9e0546245
X-MS-TrafficTypeDiagnostic: SA1PR15MB4967:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB49673162C01D1C20274F72A8D55F9@SA1PR15MB4967.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDK56jo4IoTsLX0aVPbii+q1VDxzSVXVc36ODkCLzzmqU4dkB3vfbNRBD46UxuBrR1MwezTujoNEOqq/w/8C5miDsIQSyoIF/VRb7mRYvx086vDmjnIZSzPOUo2O3hnLwy1V3NvEoiY/xaJ6F3CPOls1QwB5jy4PGGbmtZVFc2DyfH1OtRKHGfVeDqu8czyQfaRI7+t0zs+wvsI3zj5EkQkxkjFWBUCGU9ZocdYZgv+ElUloHvjzlL5WYFpI0gLQsYjcNi9eZwjzkUimTdJEqoStr6vCtCvKKVbNuHXwrfyn+t9J1LSP8BRJKpLKqoP6KpGAprmcd5xxTlfR3US22FcgrKi3azkT9BNAI01o/p3EUNrYxsVXylgSP2CzBmVWuehP22xwapWfqewqZLp9wOFZs47K1oPqHL/yZW2eeTaBH0x6cpIPh1twGoENbfctQWReEaffxkefRfu7Zy2rewuxtJDBgR8+Yva8JNzqbGmiT5ZAHZ3vYjDuEYpBo1Ix+J507DhJPnvIgYHF9ixQnML/7YNR+iDmvbyrc3eOnv6LEemu3hqfk/Sd82DxWxqZ9UsjbvQNp5vEftbKrV3aE11ISzgfMEasOTk9vluoK9naL/3TYtmMacBhujL+GygLfrB84Opm+pjD/ZcaP/3m3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(4326008)(38100700002)(66476007)(66556008)(66946007)(83380400001)(508600001)(7416002)(9686003)(6512007)(316002)(52116002)(186003)(5660300002)(6666004)(1076003)(2906002)(6486002)(8936002)(86362001)(6916009)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qbyklREP5N4r75Fp/Q/df6KD8ndvXI/C3HzzXklfpOKbqk0BnDurTK5Zgnd7?=
 =?us-ascii?Q?fOWPlDYdQAoUEkEs+WY0Uze3i1pq1brnalkZsdZpFiXZhPc7GWDkW+Yz+7Y8?=
 =?us-ascii?Q?rbxX2m7jIBC+WI+uX7Y54EGcaWv1atdNxg0BKWDbiERUvyVkdCheO8RpK4Hk?=
 =?us-ascii?Q?XCgd6Xk1JKK+8rJdFSTHg/q6OPattozJUzl1XjDHXKJspaQ0O0iR9HVqWiHV?=
 =?us-ascii?Q?5g/vlnj/knFnZl08dhXq8FYijjdfCTmxtSrXxmXnE0dDtucIEGs3qUeRePJP?=
 =?us-ascii?Q?TRMkzoI2O3WGBgUp3r1Ww++5oeuMWBRknKQvk3+ygVDiK7f38D67bMT6GIhc?=
 =?us-ascii?Q?0+jE/xZwDnK7LpZBvDsfFjKuQKqMifrWtJpNmyUG6GdtESGsb92wtPWO/jx7?=
 =?us-ascii?Q?XrdgXHCT5F13yMHAWY3XqiUBgmCmDnrfZJvlnAmtti5ykWuButrsu9yB81tj?=
 =?us-ascii?Q?r+P2gGWhlJPDGam+vw96ZHPC5S7og7QqxmgNZ+byML0M6ANo59N2zVONcA7N?=
 =?us-ascii?Q?bybo+INMVfPFfNlA9fKR3L1jWtr7pieNJAUzqrCzqL9rS6cIS0aKIEybye0b?=
 =?us-ascii?Q?59JIsKg/jR+BnI2yFw2anE67cIykaxRWsWskUKn6VynPMcgL3w+R7c5OTRxr?=
 =?us-ascii?Q?s5KE694bvQ967BoEzdrk8ZvhnIzFHi68tE+NNplaaKKPVS4111ow0LnQ7SRN?=
 =?us-ascii?Q?ECCxdIh6i8lRl5F81spmZpGO/PKdmw46mhnblg5jcLAGd//R7FJNdN2W0SV2?=
 =?us-ascii?Q?vV20fj14bckKPn8+heR20mlEma4nhC0tb16Aj6z01Z4muNj2fhc1cZXatHRC?=
 =?us-ascii?Q?nAAD9oK5Uivq3KgWVH97bCAsieCBWfikG7VQroddVtlhu3E9pjEXNR2f1yws?=
 =?us-ascii?Q?3zgQ/ebGT2D/3xlg2YznhKOo/lBgZybyZCCkevHjnUrioV2vS8LJyc7JaJ8J?=
 =?us-ascii?Q?5fwy3B5WP2bcyCG5zRhqFhkSHua+2bMVsla93T97ifna5tL12LXteMEXkqtt?=
 =?us-ascii?Q?+ov42kokNckekNfeL60e8UGH2StBx14zVBxc5JRHlXrCl0sVpVc9kdCGgo9g?=
 =?us-ascii?Q?BT/FeB0/oXt/T2knPgiX5ktfFt4zQDZ04CEiO3MKjHaGKiQ2Mhl5W9yUUUNT?=
 =?us-ascii?Q?jvorU+gOAwF43oyNpP5mZp2X0PnnRpwj+/iCE3hIWIp9sT3yOcMnvPMj7GU0?=
 =?us-ascii?Q?hdUTgj+a0++5ibiWB+mpaZNcbyW+WP7Tu/MYzkwT7Anir0mytO7Q8mqjlYCE?=
 =?us-ascii?Q?/+j0iYURbmt7dMQ6Dg9mUsZikkr/Oimbhgu8DM+3+vv6aFDXyjLrvBntMSvf?=
 =?us-ascii?Q?vGbzPlu870oBOrpjGSvLPRKa7YRxoFvXJzB8fLQVEFenpLE9APUDUGghgJ7Q?=
 =?us-ascii?Q?DfQNi9RDIgapv6+MTSu9ARZWfK81rN5Le9E0dqOOA8Q3264kB8V4jwBWJfIe?=
 =?us-ascii?Q?plyTNcCCMN4s+1jtDfVPF8DhdtnIaG1Ib9kYGy8joDhx5hZlCnUb6lyZec64?=
 =?us-ascii?Q?S/W00/cPcfV/fWdECcdn7kL2NWSM4kAulkfuJohyCZgJ7KSfrU2/QZaCJP8Y?=
 =?us-ascii?Q?kUxsa4Wt00pw8Q3aFwSXj+n0dJ+XI0RGopKanUkS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2adcbd-c196-4501-3aa0-08d9e0546245
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 22:45:28.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKJKHH5E0SoBGGF4IIO9mLFH4ytC89mi3Yv9HdYHbHIoneVTbkNHSakXdTkEUXG2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4967
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ae2LG2i2XOYanTF_EaZAPAqisQOqCdTS
X-Proofpoint-ORIG-GUID: ae2LG2i2XOYanTF_EaZAPAqisQOqCdTS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=932 spamscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 08:24:27PM +0100, Jakub Sitnicki wrote:
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b0383d371b9a..891a182a749a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5500,7 +5500,11 @@ struct bpf_sock {
> >  	__u32 src_ip4;
> >  	__u32 src_ip6[4];
> >  	__u32 src_port;		/* host byte order */
> > -	__u32 dst_port;		/* network byte order */
> > +	__u32 dst_port;		/* low 16-bits are in network byte order,
> > +				 * and high 16-bits are filled by 0.
> > +				 * So the real port in host byte order is
> > +				 * bpf_ntohs((__u16)dst_port).
> > +				 */
> >  	__u32 dst_ip4;
> >  	__u32 dst_ip6[4];
> >  	__u32 state;
> 
> I'm probably missing something obvious, but is there anything stopping
> us from splitting the field, so that dst_ports is 16-bit wide?
> 
> I gave a quick check to the change below and it seems to pass verifier
> checks and sock_field tests.
> 
> IDK, just an idea. Didn't give it a deeper thought.
> 
> --8<--
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4a2f7041ebae..344d62ccafba 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5574,7 +5574,8 @@ struct bpf_sock {
>  	__u32 src_ip4;
>  	__u32 src_ip6[4];
>  	__u32 src_port;		/* host byte order */
> -	__u32 dst_port;		/* network byte order */
> +	__u16 unused;
> +	__u16 dst_port;		/* network byte order */
This will break the existing bpf prog.

>  	__u32 dst_ip4;
>  	__u32 dst_ip6[4];
>  	__u32 state;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a06931c27eeb..c56b8ba82de5 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8276,7 +8276,6 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
>  	case offsetof(struct bpf_sock, family):
>  	case offsetof(struct bpf_sock, type):
>  	case offsetof(struct bpf_sock, protocol):
> -	case offsetof(struct bpf_sock, dst_port):
>  	case offsetof(struct bpf_sock, src_port):
>  	case offsetof(struct bpf_sock, rx_queue_mapping):
>  	case bpf_ctx_range(struct bpf_sock, src_ip4):
> @@ -8285,6 +8284,9 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
>  	case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
>  		bpf_ctx_record_field_size(info, size_default);
>  		return bpf_ctx_narrow_access_ok(off, size, size_default);
> +	case offsetof(struct bpf_sock, dst_port):
> +		bpf_ctx_record_field_size(info, sizeof(__u16));
> +		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
>  	}
> 
>  	return size == size_default;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4a2f7041ebae..344d62ccafba 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5574,7 +5574,8 @@ struct bpf_sock {
>  	__u32 src_ip4;
>  	__u32 src_ip6[4];
>  	__u32 src_port;		/* host byte order */
> -	__u32 dst_port;		/* network byte order */
> +	__u16 unused;
> +	__u16 dst_port;		/* network byte order */
>  	__u32 dst_ip4;
>  	__u32 dst_ip6[4];
>  	__u32 state;
