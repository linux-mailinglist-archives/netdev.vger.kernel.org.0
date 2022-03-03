Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F204CCA31
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 00:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbiCCXng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 18:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiCCXnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 18:43:35 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B244EF7A;
        Thu,  3 Mar 2022 15:42:49 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 223KEsSp001045;
        Thu, 3 Mar 2022 15:42:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dcqoKRVUCaUIyZ0w330uUCeiF9DbZCnDABoPGW2+lAs=;
 b=DvTX8+UvJYl+Rqm2Amvd6NojEtr0bR2Jz7adIZ6nNORUdIv5rXiAKUHGozTeE9iu2Jhs
 84IdeE4NH2tRgWSJYRcFUqTKzQgOhCg+NT9z5OUhxMYeF0Od/LD6flXimMGnhfFGQKlc
 4mbyhpaj8tSoLtTLUeoQSQpRhtn5vxae38I= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ek4hrhbcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 15:42:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2I3n5//ZJlLnDLd3/g8LzbGc8smhSomz/JDfcQRf0KfD9Z3gtFvyzrbF+c2mRIfZ8M2lEL0qf2gv5au9PrbUVrKkBB4/a1+si3W1K947QTdUo7aTP3eSuBUSJTFeUvdzcMvW7zo2QfR5yZWy8T2Dq5m5P8EMUVTrtxd/tlbET87kPyt6FWP55FIkHSfpLX9QBcJgfAmCcdY+vMYWkrNZqQuZMukBztQL+Sa4s8jUfqzTheWvI4QQq6/71Fuw+k7ukwquxP3YpvZLvmu6CqfTGXkHN0IkjghnopbhWKHEOFzyCziByNFajdY5pj+kgZH8UqfPvwC3bFX6qWUOT4vSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcqoKRVUCaUIyZ0w330uUCeiF9DbZCnDABoPGW2+lAs=;
 b=JE35BgQCTr16RgALjFHT4uCGwKP5Nyc5WqqAqcEf1+Dx3tVcRxn2DQFDsY7YfDDq+ucjexgFScRqcLWuJe3oWfzrZatQfksFEqNHSzo1/LhEpDHEAE/Md84Lf4SrskU7AMZt44j6HTruDZeTcRZlSY/PueLaIthWfdWUr3OvHHtgG4nADXF1h4AqG2CfEkEntL9kJAgl2GVBS7oVbtawtX8Bq1bIpIBSze0xDk8QJhtShFLTkz0t9xAJpJ7b9sNTh4wQPJfUnKS1aJJ/nDjxJqZHW0c1X2tcAeuOIOCvzwgmhVgH3t/hR4ey+04dv9VX+OhBnHPP711vPMtUQnA7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW4PR15MB4473.namprd15.prod.outlook.com (2603:10b6:303:102::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 23:42:08 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.016; Thu, 3 Mar 2022
 23:42:08 +0000
Date:   Thu, 3 Mar 2022 15:42:01 -0800
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
Message-ID: <20220303234201.3xl4pbuua4kwkrfu@kafai-mbp>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195628.3484598-1-kafai@fb.com>
 <9cfeb60e-5d72-8e5e-2e34-5239edc3c09d@iogearbox.net>
 <20220303204303.bpqlpbyylodpax5x@kafai-mbp>
 <419d994e-ff61-7c11-0ec7-11fefcb0186e@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <419d994e-ff61-7c11-0ec7-11fefcb0186e@iogearbox.net>
X-ClientProxiedBy: MWHPR15CA0054.namprd15.prod.outlook.com
 (2603:10b6:301:4c::16) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9d27e5f-bb70-406e-4533-08d9fd6f6c22
X-MS-TrafficTypeDiagnostic: MW4PR15MB4473:EE_
X-Microsoft-Antispam-PRVS: <MW4PR15MB44736404F0668282A06529BFD5049@MW4PR15MB4473.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyHFcAxd+Ypf1vm5rYyBEP5GM1j0xa4+EtJy2qLNZ5VpMjdp1KYnmP4Sw3yioxvlgPFV1GFkmjkmR4yZCIsAT9kXSoNLPGvObqZDYiXP0h1kP0qrFjoAEp0rmGBUMzL7NGBpAIo+NBUckMOKIehB+DkiXucoC0xBUHaCSEtbR0zeSPf0EMpmkAgfTeTIXipT01sX9b/qP+RzaTyl/YWTFSsb5JMlSvsGFlWaepEBkp+y4UoyboPvQxTido0+2jumH+GzEWq0UVgqY7aaiDgC7SBk+FVS9ZvTM630dWy/SkE8+AOWimf8TlmxBru1sTKM7qj8qF/38lEFFf6yCVwtHzbjzWxeb3gB/YDFT4bUV7YG5iQ4YZqWGETNykpeRv3JodPPq3RO0InYpkDgfJwuRi4KtDEOKINsbvVmKYNywB0O+KUOYzcoUuvADcWgcoLZdUFiIhZnpEDnaARj98d4LnDVcOsYkiUarS175mi92AP+sqYnXoqv4lHZuAo+ImosdT3kPYGU3UXJEsrTEroaAJTgDvvjPFuORX4KEtJr/em4oDYhmLKxvtvdzBxm5q9YoxbMpGer9jAQa3la/8N/Vc9OOU+kGK+8coMQpV7yffX/yGqehyDcKyEc0BidKwbPo4aRJvMKqZ+wl9/46yV95Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(1076003)(6916009)(38100700002)(54906003)(53546011)(4326008)(6506007)(8676002)(52116002)(8936002)(86362001)(6486002)(316002)(6512007)(9686003)(66946007)(66476007)(2906002)(66556008)(186003)(33716001)(508600001)(6666004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GAfhcy1xCI2r5ubLxuFLS+fBKFPo4rPs5tAh2CnQ9ooOHqZOEd1wn36pPGIs?=
 =?us-ascii?Q?UqZOBAvjv8jpnHqjYhp2UZelnmRkniDWGvVAemRyzzZRuWfBirLZm28HC0BW?=
 =?us-ascii?Q?Sh1TsfQiLSEjwS4LJU/Gn0cKH2/g834H55BinRUxi9rhm2fyEpmNH/auVdmI?=
 =?us-ascii?Q?BqN4w0mmjm7kuc8QcRMTe68CzgPGfUsQxT5JmVK8f+93tjWj/VtynsX7DWXk?=
 =?us-ascii?Q?dLhwhjvNbQe+dCegubCQtIkFBBCLyUGd+grwRkv+xOQhvYnGeaaCfkVhLBXP?=
 =?us-ascii?Q?ckJuKuUcsLyYrnUwxssrqc2np1hZDJv73Gr5YOz8p9cy4Fn+9rAasnhWKE/2?=
 =?us-ascii?Q?iFizIi062c4b1dfUMlBRl0BuCGOSmH6VKLpak7W3jTflpIY5NbqAGOPVT6zw?=
 =?us-ascii?Q?Q1uOREhbbrrAOfU//Be0QyClyNpJVrphMIR9SZCuPu2clEoP3TWWy3lekvuj?=
 =?us-ascii?Q?v33vmJ/LG9V64Qqj2gvfcdJZCwANQyPKLFfxbpX+NlMjdvSo8vLGjt4HQMW5?=
 =?us-ascii?Q?EICDHaoOTG0FMGsbcKEqxby9TkqfwYzxKEsfehaagYUSlJEqokjY9xnKOedG?=
 =?us-ascii?Q?VtAAVQYXRJEgBVLWHA89gBWzxYj94c2mZHv6vQ1IgOyDDfViVnas/47fAf3t?=
 =?us-ascii?Q?VsUfcgVumrtgDKrVzHwUaX2K4/aIbcAQZJBOIemXiG+o/a4rgMbc+d3heWXr?=
 =?us-ascii?Q?Jk2H8DiLCyy4XMcl+mkwlc3Pdl8ZLKBsDmT2JulbG9/OvJhT/MiZfMFuR5wB?=
 =?us-ascii?Q?JrHA7UkImTT0gNSYQHUHvkg8anfU5QLNaBVTY7sRDU2yn+IBD/t1u4KbW3cE?=
 =?us-ascii?Q?U+BM9SHzQhEEktLc7DFUuO7NtCUYRKLEFDXDvCw5vah6L0P4DaST3r5h8Y/t?=
 =?us-ascii?Q?tmTQZIHl8Dho47Ie/hYm4Vx94aLvMp8MrFVGWM0tGGDE2j4x9UqdMUKXAtAc?=
 =?us-ascii?Q?lhINJ7jKm6+QDYWp927P39DQvQLZY9Urf7hgNwEz702Nq9VpZruQY8+5JRh3?=
 =?us-ascii?Q?7FoLznZ62ByokgasYdWGXAOaDrK54Oso2KvWK79icwePPVS1C0XS1Oq4PDuu?=
 =?us-ascii?Q?R3IhdMaR+AyTp6z4AKZtICMvImGKg1DWfJmCoTJyRUh/X3NacuKLWhPTZSc5?=
 =?us-ascii?Q?cWYf68+t6g0+G7JAN2W5G+C1XsNYM2YECG2Lj8njhq0a5PZipVY9bDxdOgTE?=
 =?us-ascii?Q?nAz1u53XTLC9MGlaZeZVMCBa4itmJNC52vCaKJpgC6YzcUQkO1zqhbqNL6xN?=
 =?us-ascii?Q?ySEJL2MxGJBOmUiBy5ua6nXLfHZWE+CMdDkjPV2j0YoIYDl4Zc906nzZuYGz?=
 =?us-ascii?Q?xjKzABbxpI72t8hIqjk5TGmENJnuLzA9DtgP13JxayBWD+5OeUWnXZFlGis3?=
 =?us-ascii?Q?OYjrtuvel129hq9x1y05sCzhxMZeanY+Pr/5POV22wcMzZn7aiMRwQoqWLy0?=
 =?us-ascii?Q?8jsfaufu0np497HSrQIzCZhIUT+PZitLnVuphZr3mx+sEMmIxIPnPELDNna7?=
 =?us-ascii?Q?GhJit6HdXiBAnGq+oWvA81Rq5mysLkRNm2yTrFzvflTBk8k0rW6g5R+M+Ek4?=
 =?us-ascii?Q?kGZPBc237Z7tLqC3ORVcZS4gSB67D0GFTrvmutaL?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d27e5f-bb70-406e-4533-08d9fd6f6c22
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 23:42:08.1556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMaDb3YAEVJQNrDSllnYQR35oI2zWmSREvZn8vavNmL7EukVJQaE3arxy+oE50tM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4473
X-Proofpoint-GUID: IJtV6zi85YaoY7wbVwUkYnYhPh9F8Smb
X-Proofpoint-ORIG-GUID: IJtV6zi85YaoY7wbVwUkYnYhPh9F8Smb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_14,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxlogscore=930 lowpriorityscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203030109
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

On Thu, Mar 03, 2022 at 11:55:55PM +0100, Daniel Borkmann wrote:
> On 3/3/22 9:43 PM, Martin KaFai Lau wrote:
> > On Thu, Mar 03, 2022 at 02:00:37PM +0100, Daniel Borkmann wrote:
> > > On 3/2/22 8:56 PM, Martin KaFai Lau wrote:

> > > > +static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *si,
> > > > +						 struct bpf_insn *insn)
> > > > +{
> > > > +	__u8 value_reg = si->src_reg;
> > > > +	__u8 skb_reg = si->dst_reg;
> > > > +
> > > > +#ifdef CONFIG_NET_CLS_ACT
> > > > +	__u8 tmp_reg = BPF_REG_AX;
> > > > +
> > > > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> > > > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
> > > 
> > > Can't we get rid of tcf_bpf_act() and cls_bpf_classify() changes altogether by just doing:
> > > 
> > >    /* BPF_WRITE: __sk_buff->tstamp = a */
> > >    skb->mono_delivery_time = !skb->tc_at_ingress && a;
> > >    skb->tstamp = a;
> > It will then assume the bpf prog is writing a mono time.
> > Although mono should always be the case now,  this assumption will be
> > an issue in the future if we need to support non-mono.
> 
> Right, for that we should probably instrument verifier to track base based
> on ktime helper call once we get to that point.
The bpf prog does not necessary write a value which is obtained from a
bpf ktime helper.  It could be a value based on the previous skb sent
from a cgroup.

> 
> > > (Untested) pseudo code:
> > > 
> > >    // or see comment on common SKB_FLAGS_OFFSET define or such
> > >    BUILD_BUG_ON(TC_AT_INGRESS_OFFSET != SKB_MONO_DELIVERY_TIME_OFFSET)
> > > 
> > >    BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
> > >    BPF_ALU32_IMM(BPF_OR, tmp_reg, SKB_MONO_DELIVERY_TIME_MASK)
> > >    BPF_JMP32_IMM(BPF_JSET, tmp_reg, TC_AT_INGRESS_MASK, <clear>)
> > This can save a BPF_ALU32_IMM(BPF_AND).  I will do that
> > together in the follow up. Thanks for the idea !
> 
> Yeah the JSET comes in handy here.
> 
> > >    BPF_JMP32_REG(BPF_JGE, value_reg, tmp_reg, <store>)
> > > <clear>:
> > >    BPF_ALU32_IMM(BPF_AND, tmp_reg, ~SKB_MONO_DELIVERY_TIME_MASK)
> > > <store>:
> > >    BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
> > >    BPF_STX_MEM(BPF_DW, skb_reg, value_reg, offsetof(struct sk_buff, tstamp))
> > > 
> > > (There's a small hack with the BPF_JGE for tmp_reg, so constant blinding for AX doesn't
> > > get into our way.)
> > > 
> > > > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
> > > > +	/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
> > > > +	 * Clear the skb->mono_delivery_time.
> > > > +	 */
> > > > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > > > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > > > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > > > +				~SKB_MONO_DELIVERY_TIME_MASK);
> > > > +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
> > > > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > > > +#endif
> > > > +
> > > > +	/* skb->tstamp = tstamp */
> > > > +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
> > > > +			      offsetof(struct sk_buff, tstamp));
> > > > +	return insn;
> > > > +}
> > > > +
> 
