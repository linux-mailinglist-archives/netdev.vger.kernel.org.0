Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7942B4CC73A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 21:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiCCUoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 15:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiCCUoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 15:44:13 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3925517EE;
        Thu,  3 Mar 2022 12:43:27 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 223KGfgk015966;
        Thu, 3 Mar 2022 12:43:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UeuxYRZVN/WMVaUpoFB+Eng7/t9J4CIm/7NFP5I0xBc=;
 b=VMhQ8ypSsiqeg06Vtoh+yeTHjbCw2+KduDfOqWpFxQsg09DWiCfEHspnHiuyg8cphHs2
 hSQGiy2Nqo7SNYz2LPxWILZPyiIsmpAkK+74wrF06n6zD/zY9YOhFV7waPiX9gIE3QEl
 ZsIvqxoFl5zda/c3OxIn/jljR/0TDfFN1L0= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ek4je0618-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 12:43:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkB5nXMbKT2xAVuu8JnjRCuPew27nYerTdzXoW7ikeRY1CetVvosf+H/maw+QAT7INbWrkrrHgNtwWsJ9SohqJ2Me/kXnKegP09QmFWIEG0C4UnW1AxvvKvE9qw3W10f6RQczWMm4fSej/5jeXMWGYkNJcga22/1ktUpjqph6tyeahyb7NmYAQYVh9Tav4CNJcmzQIrJGzOFxZoHN7+YUaMRMq5caCG0gy4aRluo9ZkTD9p/XO0I/Kb2RqM2P7qXnfFHLcBWw+YdxZdNH5/cUYm7bCEZ0JsvV3h7JeJOKEYC/j30GBKpc5X2JKhbaYzPFG3Zr48oOBZ27+kogfAqOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeuxYRZVN/WMVaUpoFB+Eng7/t9J4CIm/7NFP5I0xBc=;
 b=fh6FEm/uKWLbBFTQ4aso+8R8DXeI6BuB1/9VHhM6KZg6wqgJSdpzhpNigenYo2Hnnup0vePtvm7V6mE7UWDlR9bALO9QaTe2vjul5pv3INB41Vrsygm3h7ME5tft9q+/AeihXtGHKR67z5EbbR7f/WZjpV3ODAvI0wJnwpzm1XAUWw0I6MDNQAgZXEaWnAebGN8dekhh2WybUs1ZZ4XR7ZHmd/uGtGLDcqsUxv+rM94Orbc0VHqPvg5cl6TT6li806/ar5vGlM/aMfZbc7erKFlrkZQwbuGrya9742bv6a3k0nwMQFgXVcVM0KZmBOplyTDic5Ucq5yoxaJz/Dzmuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4577.namprd15.prod.outlook.com (2603:10b6:806:199::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 3 Mar
 2022 20:43:08 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 20:43:08 +0000
Date:   Thu, 3 Mar 2022 12:43:03 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v6 net-next 11/13] bpf: Keep the (rcv) timestamp behavior
 for the existing tc-bpf@ingress
Message-ID: <20220303204303.bpqlpbyylodpax5x@kafai-mbp>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195628.3484598-1-kafai@fb.com>
 <9cfeb60e-5d72-8e5e-2e34-5239edc3c09d@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cfeb60e-5d72-8e5e-2e34-5239edc3c09d@iogearbox.net>
X-ClientProxiedBy: MWHPR19CA0072.namprd19.prod.outlook.com
 (2603:10b6:300:94::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23351bb3-0ea4-40f3-114b-08d9fd566c1d
X-MS-TrafficTypeDiagnostic: SA1PR15MB4577:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4577D93E9AC71F94D1AC5805D5049@SA1PR15MB4577.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZtD2+KboJVBYXuHrVvMXDKznOgCDLcTJsvg/M+dbkN9sRuQtJxWEGvg/N3Cu3Z2k1FvTy8T9e3YMxZkbBkIPzhaoXUBwKsJA3fwULgfTboGgD4Y+4OYLgbASboYv50cWEinNqGiKxi60nn/qeJPrMvxQZh3aqehKJL65iGVkid/PxLrRmT24Zfdxt/oyaWDbuQjXZ8m5Ew6ApzsPhiV1Cb1kZYJfj4VP+fwTle9+CPga5cgpaWK2I+/M5mdvgdTFphnTr2zgu26Ooyb+1cGI2OqFDSKbyZQBVNw66ARSnUc+rs+0pYlQ6t0QfohjL6ijAS++22pKEdnHjDuE4i9IZ+84NLFijqSuPb8e67jyIgyG2V0gkLBKStCN+lAz53coQptna0rjwvgrzZyhcNd3sFgx6fEs2i8cq6SZfLHPYg521ljlKKcAhKhZbYiwJdUbYHaNmv6zZIklseSiTagPAC/LqzZXnwtzzkfqeQUyewazITUggnzbouWScb5ovjQESLudCk15eO7xF8mwrKnx8/lr9BGRC6GeGeLgfVkA1MPpGOUx5Ra3t5mZpAR78her1JB1fKmoZVThUc708VarulzuhUuVbu08BkEJc0Fy9Y997zAXljRvY9amCeH3QgW10jX8Kc8IieEWIGN3duD8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(5660300002)(2906002)(83380400001)(33716001)(52116002)(186003)(53546011)(6666004)(1076003)(54906003)(6506007)(6512007)(9686003)(8936002)(66556008)(66476007)(316002)(86362001)(38100700002)(508600001)(6486002)(66946007)(8676002)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RTG5tTfGFqq5ixLVu47LZmG2U/JyYqUuph8DBiU78zeFtB7YJ3tND1rfxnNL?=
 =?us-ascii?Q?AKP0nxXhAZksOqECHIRQ432KT60EnMjmODVdHlW9jwtFGV50r/6gcajnPO7z?=
 =?us-ascii?Q?qF8g+q0EAr20n3hCKEz/Ig0x+6GHxKQwVXK1/NvrPgFoxyLcdI2+1wONKvee?=
 =?us-ascii?Q?WlFRQF1Lb0fDPrxnseXX5OElSHysfkEVOfX/mqoOnABHHPulUYFq8heizIKc?=
 =?us-ascii?Q?32sHOYyUNH5I8txKssx1GUSLmQS/aN+BnLgjU0Vi/9L/pTOpNEgLwpuwftPq?=
 =?us-ascii?Q?he7qODEL2u7qKMNYf4EukYKdIG9wMxU00lGQI+hNd9hLuc9hYSldEHauDeXt?=
 =?us-ascii?Q?2VeHjlpoz99p1BclBNzdnZRHkx4ljrVRiKLbjmkfl/Sswa6NB2k4NeA/o6CK?=
 =?us-ascii?Q?5aE2PJreOVcxbC/4yvFOOpQ4Vyw0RBsVSQVqC3gT4gMzrhQrkAM2MPe14P1b?=
 =?us-ascii?Q?Qutk1txLQKlvDpgj/Xy2XWO4P2LtDxbsAe65czmgGIYjgn0rvV2429SVjirX?=
 =?us-ascii?Q?QArpumUIc8sdJk5QkeaTIJ7Gky2pUivKYbSRZd8QQ7zMTAQoa0704nnYhAcK?=
 =?us-ascii?Q?JJ3oN2KhCp3oWLofaGJ9E9URfHGlS25LN5SvY8EuBi6jv6jbEpJuE0YLLruO?=
 =?us-ascii?Q?Lu28OA/04bhrkWS5pzq6aM77N56ZIgijDrmPFHTobTb+fpZomeQsRESDTXeB?=
 =?us-ascii?Q?+LK0KoUsxtSu467F/ytSSJTot8YXwHC4s5nifFUnnuVAlXfAA2qqDKJKRjsv?=
 =?us-ascii?Q?q3NOpkkKFzfErgsZPn9SLHxWu4lD5p6LAjGRZ3eDKzrl1vYZfsTBs9JwaAl+?=
 =?us-ascii?Q?7UQV4xpesBt5+mghJMEtaX9v0baXum58LptCJ0hucM6Zg4bPgdYn6I6NrRNN?=
 =?us-ascii?Q?yZv1cJy8aWSPb05JE/wd/3uSHKAeoV6kWK2cLB3XLC7PSI4srvNk7X7u9+m7?=
 =?us-ascii?Q?PwtBY3QDFF8ml+LlPGECu6sklbF2XfsZ4z8ovkbL2g9YxH8Cm1DtQkqvS5PQ?=
 =?us-ascii?Q?qxb/PxY2FZOTX/tgiF7dgynAFaynxKM57rM506/qragy5ehr65OaocX9sby/?=
 =?us-ascii?Q?tIXOTWm66A2158liKXeGLo38XyRZaO3xHNe68++NN7aypfuXT5pFKgiJPOym?=
 =?us-ascii?Q?9JuotStcIMlvthNjzNg4FsJnU+ShTLlLTWfHLFj1EqG3qTbg+BuX5jzpCSZg?=
 =?us-ascii?Q?mKDaKbxsFaRKK75eOWm9kyKbqO3YFHcwuFqKowfgxn97Qut3GVDOtaK0MnoM?=
 =?us-ascii?Q?HOrjEXA8T0zU0Ukb/eeuVr7t8nka8Qzxkz0bpDFObK2KnQM3qzVdxllPTjS3?=
 =?us-ascii?Q?l/byhFG9YmVGDJrZsQfmp2eXa77d1dtb1nlRejx2ETRyZyq1z5qEkqQYEFPi?=
 =?us-ascii?Q?SKD/2+J9w9/F8CH4miv3i9nzXFrrjtNiX72WmVxEhatuW9i8Y6PC5rWK8pOg?=
 =?us-ascii?Q?CX8YeXKgdOf6J7/rMb6GDz+BiXvbMjHaJYZgPWobQ+C5dzXVjzDTlQXNLltK?=
 =?us-ascii?Q?bs9iV/P9xPy2SViNmpsIrzSCfLadTV2swybNiydS4CCvy3o+nUu5Y7sLGDc7?=
 =?us-ascii?Q?2PBdbSqozUsge7UGYv36U7IQ/rl3pYgRnJlnBGHk585umHLh1KIIUzWj9OPM?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23351bb3-0ea4-40f3-114b-08d9fd566c1d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 20:43:08.0930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+PWWKQwW+GyXH2R2laKGTbvwfs3wmka4DtGHQ/VwvoixyameMrafVJ4rRp3iAFu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4577
X-Proofpoint-GUID: LHR1AZ3GSsgoyEANCPlLQaHVRawJdtQr
X-Proofpoint-ORIG-GUID: LHR1AZ3GSsgoyEANCPlLQaHVRawJdtQr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203030092
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 02:00:37PM +0100, Daniel Borkmann wrote:
> On 3/2/22 8:56 PM, Martin KaFai Lau wrote:
> > If the tc-bpf@egress writes 0 to skb->tstamp, the skb->mono_delivery_time
> > has to be cleared also.  It could be done together during
> > convert_ctx_access().  However, the latter patch will also expose
> > the skb->mono_delivery_time bit as __sk_buff->delivery_time_type.
> > Changing the delivery_time_type in the background may surprise
> > the user, e.g. the 2nd read on __sk_buff->delivery_time_type
> > may need a READ_ONCE() to avoid compiler optimization.  Thus,
> > in expecting the needs in the latter patch, this patch does a
> > check on !skb->tstamp after running the tc-bpf and clears the
> > skb->mono_delivery_time bit if needed.  The earlier discussion
> > on v4 [0].

[ ... ]

> > @@ -1047,10 +1047,16 @@ struct sk_buff {
> >   /* if you move pkt_vlan_present around you also must adapt these constants */
> >   #ifdef __BIG_ENDIAN_BITFIELD
> >   #define PKT_VLAN_PRESENT_BIT	7
> > +#define TC_AT_INGRESS_MASK		(1 << 0)
> > +#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
> >   #else
> >   #define PKT_VLAN_PRESENT_BIT	0
> > +#define TC_AT_INGRESS_MASK		(1 << 7)
> > +#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
> >   #endif
> >   #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_present_offset)
> > +#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_offset)
> > +#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_offset)
> 
> Just nit, but given PKT_VLAN_PRESENT_OFFSET, TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET
> are all the same offsetof(struct sk_buff, __pkt_vlan_present_offset), maybe lets use just one single
> define? If anyone moves them out, they would have to adopt as per comment.
Make sense.  I will update the comment, remove these two defines
and reuse the PKT_VLAN_PRESENT_OFFSET.  Considering it
is more bpf insn rewrite specific, I will do a
follow-up in filter.c and skbuff.h at bpf-next.

> >   #ifdef __KERNEL__
> >   /*
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index cfcf9b4d1ec2..5072733743e9 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8859,6 +8859,65 @@ static struct bpf_insn *bpf_convert_shinfo_access(const struct bpf_insn *si,
> >   	return insn;
> >   }
> > +static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn *si,
> > +						struct bpf_insn *insn)
> > +{
> > +	__u8 value_reg = si->dst_reg;
> > +	__u8 skb_reg = si->src_reg;
> > +
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	__u8 tmp_reg = BPF_REG_AX;
> > +
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
> 
> nit: As far as I can see, can't si->dst_reg be used instead of AX?
Ah.  This one got me also when using dst_reg as a tmp. dst_reg and src_reg
can be the same:

;           skb->tstamp == EGRESS_FWDNS_MAGIC)
     169:       r1 = *(u64 *)(r1 + 152)

> 
> > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
> > +	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
> > +	 * so check the skb->mono_delivery_time.
> > +	 */
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > +				SKB_MONO_DELIVERY_TIME_MASK);
> > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
> > +	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
> > +	*insn++ = BPF_MOV64_IMM(value_reg, 0);
> > +	*insn++ = BPF_JMP_A(1);
> > +#endif
> > +
> > +	*insn++ = BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
> > +			      offsetof(struct sk_buff, tstamp));
> > +	return insn;
> > +}
> > +
> > +static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *si,
> > +						 struct bpf_insn *insn)
> > +{
> > +	__u8 value_reg = si->src_reg;
> > +	__u8 skb_reg = si->dst_reg;
> > +
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	__u8 tmp_reg = BPF_REG_AX;
> > +
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
> 
> Can't we get rid of tcf_bpf_act() and cls_bpf_classify() changes altogether by just doing:
> 
>   /* BPF_WRITE: __sk_buff->tstamp = a */
>   skb->mono_delivery_time = !skb->tc_at_ingress && a;
>   skb->tstamp = a;
It will then assume the bpf prog is writing a mono time.
Although mono should always be the case now,  this assumption will be
an issue in the future if we need to support non-mono.

> 
> (Untested) pseudo code:
> 
>   // or see comment on common SKB_FLAGS_OFFSET define or such
>   BUILD_BUG_ON(TC_AT_INGRESS_OFFSET != SKB_MONO_DELIVERY_TIME_OFFSET)
> 
>   BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
>   BPF_ALU32_IMM(BPF_OR, tmp_reg, SKB_MONO_DELIVERY_TIME_MASK)
>   BPF_JMP32_IMM(BPF_JSET, tmp_reg, TC_AT_INGRESS_MASK, <clear>)
This can save a BPF_ALU32_IMM(BPF_AND).  I will do that
together in the follow up. Thanks for the idea !

>   BPF_JMP32_REG(BPF_JGE, value_reg, tmp_reg, <store>)
> <clear>:
>   BPF_ALU32_IMM(BPF_AND, tmp_reg, ~SKB_MONO_DELIVERY_TIME_MASK)
> <store>:
>   BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
>   BPF_STX_MEM(BPF_DW, skb_reg, value_reg, offsetof(struct sk_buff, tstamp))
> 
> (There's a small hack with the BPF_JGE for tmp_reg, so constant blinding for AX doesn't
> get into our way.)
> 
> > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
> > +	/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
> > +	 * Clear the skb->mono_delivery_time.
> > +	 */
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > +				~SKB_MONO_DELIVERY_TIME_MASK);
> > +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
> > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > +#endif
> > +
> > +	/* skb->tstamp = tstamp */
> > +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
> > +			      offsetof(struct sk_buff, tstamp));
> > +	return insn;
> > +}
> > +
