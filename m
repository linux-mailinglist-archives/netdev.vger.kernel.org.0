Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35E4B8086
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 07:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiBPGMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 01:12:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBPGMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 01:12:19 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFA6205F0;
        Tue, 15 Feb 2022 22:12:08 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21G0rWPm009997;
        Tue, 15 Feb 2022 22:11:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pMQpcC0kMnhheQibZoOenHLPMx1lLrscm6YWlm/cHig=;
 b=l+ii3HT6ZsLG34zGTrl+bRg4gKCahFt8/feNa9wQsw46Ka3c9fcI0LPY/Mm2WyP227an
 KOIr3HFytHQXc7rFEHmCbTfjsaLbXYf2nxPwpHN1v755jh6041zMGP8YIhtNEJeHGp5q
 IFt+SKVTbDHNQr5a3riEwvHRqSfPcfqSphs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n4mj3mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 22:11:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 22:11:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVQHa8ECU1t4Waq30ZavV4qNc/a/PYIuGc8ZhDrkRSVfujWHx7yxYVe4P3TxMdmJSt09YPgECTAobd/NkzWEA/6czoAVGHmexRCOXlj21/YrDp0JB+4D7Edzt1eBLMPXitr7M4j2C3FI7vm47YFShEJGq9uMCM3+LnnAti7ptxlFb6oVgRspLJ+M5p4keXHMAFKLnSLmCL1+u/6A1GZ2xDRfMkJKdplYuznnd62RDEth96dO0d/nB8TCTMSVTadXeXVeo9RwHvTcmwVlUEwbTnRotdIBROnz1EgcTt5U0ftlcdYF4vLM7kp/Mi/YrVlE0LOD6hC6cH5MaBdE57j5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMQpcC0kMnhheQibZoOenHLPMx1lLrscm6YWlm/cHig=;
 b=nZvVjtfXituL4owqSeGRwcrEkbEv3gVnpMgAxZj83uUgYmctTuLD0q1iYvwZXmJdX+NlV36IFMaSRKBcTpX0kKorTB2vcaCJmtmife+wBpcp1EZ4jMLROSYFzO0RG6GrKym4GjodqXxnglWeN5/fSkdHy8qiMnGO8T2JlgTHGou6v2nIkgWX6qNlbJq609cLzXScgUqnWV+fJrELkwCcC4PnEqqgu5p9WiARzUcjfzl5tpu8q9yANYLw80U07Vi5G+r+bW1BAasBXKNKSNP28AUmJSoAz5X9oOZz3VBKbdnJjhuPL7JAem1p9ySTXRrBeh3LxMvV3PugQ3JN2BmpSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4770.namprd15.prod.outlook.com (2603:10b6:806:19e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 06:11:42 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311%6]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 06:11:42 +0000
Date:   Tue, 15 Feb 2022 22:11:38 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4 net-next 1/8] net: Add skb->mono_delivery_time to
 distinguish mono delivery_time from (rcv) timestamp
Message-ID: <20220216061138.ndrb26i3erhnt6f7@kafai-mbp.dhcp.thefacebook.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071238.885669-1-kafai@fb.com>
 <1d03f759-3eea-0032-18fc-1f6fed2c14bc@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1d03f759-3eea-0032-18fc-1f6fed2c14bc@iogearbox.net>
X-ClientProxiedBy: MW4PR04CA0299.namprd04.prod.outlook.com
 (2603:10b6:303:89::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6c5f423-86a8-4d48-76b3-08d9f113338b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4770:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4770A40D5F7A695FB0EFF7C8D5359@SA1PR15MB4770.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJ6TXC4ql8XVkb4hYNfzL4lAb9wMbvd/aE+/sidBh0tjFfh2n/uSHlfJ6XNy23BnGrwOx9ViMinguNI0meNUD+EdDOAkjzV8bybAEn471GBx0LuwfVJQUXrMpDWSoFrVqBBNXDmM3pI8e4y0+kJ2euqsbqyVoP7TL1CDxFL7PPb9qmOYP6jdC+dqy7Ixdc8LY3XUu7kRZ++HPwCSQLDCQoV8EFA4KvE0gMUWIyG6LKBxyvbcNRsdimNhzc3DgS2s6jF9tbWUFpnrAtAquq6fcny/zhSVJ4/HU3+V84Kk29CxQeFCjCrLeqbl7kK7c0DPaSOkWcqZAQoqd6Ix6CCx9OYJT3zFWqB52oYZkUR2YbLGqE68baHzEzYL3Z1nMQOdDxZjHU0AVTp9BWfvmzleyXByrSY+SaMtrWBk6RQcMGnCpWs1+4OocqD3oJIk+4bgA+erfsCmVEg+cf6YWsSb7mK0aspJiXla+0qe97L3H4r1Xk34uB+vaatQuaG3UHAzZhIuIMCOuzDv21eyEG4B7ALxlyUFexYsW2MRvSdFpNRhF3rJpaPEkdB8bAthgW+cbviOGCFUZNdIbeL6o5I8lCv7QH4EkOu+c0KmGJh58vvOxixBX78KafDbKRBapTKeFJPk/QlyGL2ncEdCI8Wkfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(38100700002)(9686003)(83380400001)(316002)(6486002)(6916009)(86362001)(1076003)(66476007)(8936002)(8676002)(6512007)(54906003)(53546011)(66556008)(6666004)(52116002)(186003)(2906002)(4326008)(6506007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTVAAuHg5fUs45smlo5b63nf+gXCW7xuAtgG4sXOnkWWHyunYaO6cnC1cEJZ?=
 =?us-ascii?Q?Ybl7MXpIwBcHLcKiUQFC3Wsazc976WRjJs4AXnuOi77jqMe4lhRg0ob0kIBw?=
 =?us-ascii?Q?yjJKMFH9Z1L8EFHQBe+dUGe4wPeghbCAGtgTFCcGkUN4MLIzxNUunhC7Imft?=
 =?us-ascii?Q?aDBmo4Qw5wv6E1EMW+QVoNcJWv1kWU7L1iZRU5TOh2K0+NmfHdSQ3/M171HF?=
 =?us-ascii?Q?+wsewU80yKM86WBFc6p+lQASjnKCvZIv8ZcxrdiNTSQlh79gOaFPIg8CQv0B?=
 =?us-ascii?Q?kR610nFQSOZZYwi/6OAqmv5nLL9kNqwJLXuYh1+PSx/+2tCEBiVzX2+7SeiE?=
 =?us-ascii?Q?twjiz9icx0wmh+HqofHgqYR/iFkTZtkg6mwhtb9F/3InmYuf7rbIv2M5gLTm?=
 =?us-ascii?Q?/EtEnSM9UzCGbkvfCWUW2ucjQ2jWTESsYmocAqzjquKWk1hOOtOfCuqn6HNv?=
 =?us-ascii?Q?9nW/X9rnUCrEzezFAkY2tJ8cq4M/WVYaF7udJFya1Y5fUmfzmOk1RTioQeCs?=
 =?us-ascii?Q?f3U5z7xSW3N2YFT2nqwZflyJcl1dkzpoPchf6r7O3cqpa7zS5/zDxSZ8aFT+?=
 =?us-ascii?Q?AOJIq2cVCyiZVI/cef1FhkxphKQ4IdsJ+ebFrNBy7kqH/5RHK6Jo8IQf9C2H?=
 =?us-ascii?Q?65fDffD1X3e8n9DmEl2PiF2iPsc48NDLI/jjEcislVM7+Hqflf26nNxV8gsV?=
 =?us-ascii?Q?H3TYpBTayZCfBCrxxS8OeLlaYS5T17Eb2ojiJq4VuGYRLIrWsi7pRRBA0LlO?=
 =?us-ascii?Q?m+mRTAxgV8V8wtZ6t+mtUGa8gpRD3oTMRgOjGKjVKx0+CNGP+pa9nPcLDadl?=
 =?us-ascii?Q?9upvULF5F/X8M2BpWPd+dzzz+HnM+hUJIi5m0nJOMVfxx4FMvqoP3HYPZhKh?=
 =?us-ascii?Q?2iRY/6U5Q/+Ud/r2i4W1obTWOpcandV3gu5XKz3UTO1yai7tJ86rsd3bha3j?=
 =?us-ascii?Q?V3fgyoc+nVGUesdvKUR1iTnoE3jQ6LTJRUGM32dg/s3vg6El+6Vvurzxk/KN?=
 =?us-ascii?Q?6WMKnwlijn1ghlWGmiKPLbnkvS1HxwrazdAlGFYMy9HsHE+8bEKJMW6hst0h?=
 =?us-ascii?Q?BZyz4tM3M7FqbphfW2leSN2KIHU0Qs3Q1NzJ01VLIlAnA3S9x/LSHtR/1N9c?=
 =?us-ascii?Q?emhrdupfGDj5U/tMLU5IMl4M5PmCg/G9ciBkizGyOoRC7ZkDFgqU2us7zm8E?=
 =?us-ascii?Q?wE1kN1Tm5A+by+YwGh0y+1Ltm/RiVO4NP+5fExLImqTUTjpzj6pUdtyPMe0j?=
 =?us-ascii?Q?EEL3yjrVYbclqtTKoE5nj38omU9O7ADKGphO9ze9Fs4JZS42EanYKbynSzJS?=
 =?us-ascii?Q?RYZUwFc3d9ukWlic9jQN47vNjL6KsnBRB2sxAj0ZQ5ZviLQmiSAuQLJjkKVF?=
 =?us-ascii?Q?xFk8d11EGpuZNv1YwJnfIfLXzp/CZBWVnzloI5WonVrR0yIHI9l+xxDgxmcg?=
 =?us-ascii?Q?AprUQU77wCXDtIyzF0mT1HeivdP3Zq384srhyRvLnr3GxqbkRAyxnC8pyvdZ?=
 =?us-ascii?Q?Pc+4eDgC2OVlCcikMn3UdjdofAyep8BrtBIWe6exRt0jkLUG4hKk4nHjx0qk?=
 =?us-ascii?Q?0+vuY1W0XgOttgbLi4iMBZoJszkLsscivSJGWRBp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c5f423-86a8-4d48-76b3-08d9f113338b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 06:11:42.2179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/o76ZE4hvq2fduTRmKk0r/Nur/3/wphCkjSMpVpg6563rUr6gV/smtKRogRXt6/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4770
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: W1zex25G1S89uNmO4f0SM8_sbE62jm6r
X-Proofpoint-GUID: W1zex25G1S89uNmO4f0SM8_sbE62jm6r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_02,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202160031
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 09:49:07PM +0100, Daniel Borkmann wrote:
> On 2/11/22 8:12 AM, Martin KaFai Lau wrote:
> [...]
> > The current use case is to keep the TCP mono delivery_time (EDT) and
> > to be used with sch_fq.  A later patch will also allow tc-bpf@ingress
> > to read and change the mono delivery_time.
> > 
> > In the future, another bit (e.g. skb->user_delivery_time) can be added
> [...]
> > ---
> >   include/linux/skbuff.h                     | 13 +++++++++++++
> >   net/bridge/netfilter/nf_conntrack_bridge.c |  5 +++--
> >   net/ipv4/ip_output.c                       |  7 +++++--
> >   net/ipv4/tcp_output.c                      | 16 +++++++++-------
> >   net/ipv6/ip6_output.c                      |  5 +++--
> >   net/ipv6/netfilter.c                       |  5 +++--
> >   net/ipv6/tcp_ipv6.c                        |  2 +-
> >   7 files changed, 37 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index a5adbf6b51e8..32c793de3801 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -747,6 +747,10 @@ typedef unsigned char *sk_buff_data_t;
> >    *	@dst_pending_confirm: need to confirm neighbour
> >    *	@decrypted: Decrypted SKB
> >    *	@slow_gro: state present at GRO time, slower prepare step required
> > + *	@mono_delivery_time: When set, skb->tstamp has the
> > + *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
> > + *		skb->tstamp has the (rcv) timestamp at ingress and
> > + *		delivery_time at egress.
> >    *	@napi_id: id of the NAPI struct this skb came from
> >    *	@sender_cpu: (aka @napi_id) source CPU in XPS
> >    *	@secmark: security marking
> > @@ -917,6 +921,7 @@ struct sk_buff {
> >   	__u8			decrypted:1;
> >   #endif
> >   	__u8			slow_gro:1;
> > +	__u8			mono_delivery_time:1;
> 
> Don't you also need to extend sch_fq to treat any non-mono_delivery_time marked
> skb similar as if it hadn't been marked with a delivery time?
The current skb does not have clock base info, so the sch_fq does not depend
on it to work also.  fq_packet_beyond_horizon() should already be a good guard
on the clock base difference.  An extra check on the new mono_delivery_time does
not necessary add extra value on top.
