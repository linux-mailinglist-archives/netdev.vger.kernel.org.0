Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A551F4B389D
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 00:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiBLX22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 18:28:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiBLX21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 18:28:27 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601EC5FF19;
        Sat, 12 Feb 2022 15:28:23 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21CHZKrq021926;
        Sat, 12 Feb 2022 15:28:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nfV06JkX5TaFFPbxfKYflm1DPA1yQWNPq0sPoPVj0Ys=;
 b=MuvGYOZiZlg3Bnrqx9iGTx12r/kjE8OcpZ+Ypl6K5/OdSRsOuaLPDrhju/wiZ5k3Kl3e
 5BONRzPbu6JLA7c9HQgdaqKhnmLFcNZX7qogbo2DSoLa/EziDrbwJIN1OsIJyxl4n6tu
 1p6kOoZE6ciWF8tjo1Fy3WYawLsYw8HA+uU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e6avwj5t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 12 Feb 2022 15:28:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 12 Feb 2022 15:28:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaLse9lv/jj16EPUgTIK3MDq94NO2TlZb7TWMlb/UhvkITNgThXNVONXXshnOWG05Eg6AUro5aWiiZ9vTZ9M36lXsZguD25NlX3R71RyYLkaGGD1fZ64+YTxYM0JdVX1bDnqWRRYLkYrzx81uaI1HS96mG5ss7gsPXJQZVkUzNxRo+wTFH5almfbFfcfmSMUFbWo7ZWKcp/oUhQz2qr9IVHadRd5TmWt49yrvgAvWiEGlN2Mrd1Jg7MBwAepdyYRxFFjccgGX9wYHmp42/g9B1I44PR/ME2vPNtdkWm9lWr2AaK0opz3pgwZEH4UGxqhRo1DNgcDAvg0JvVGcDSesw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfV06JkX5TaFFPbxfKYflm1DPA1yQWNPq0sPoPVj0Ys=;
 b=FOK4Ia8/SP3aOBEH66hxxDPI8onCLSPnUOSzWYplBVBqhuq2+Mg4CQcIVlpXZ9iG23zCYzufICuZf/K7sLA4x/bP/82w7hobd4HnDz4OBC/cOH8sNgBVRXSOBD6H1spX2lPWo+0o9InqOH/k6R7mDlkWDKpC8bcVcJBaRtvW2uVZwqIyxkNiyTFxnteFgctc53vSJY23NtcmYjSg9PNpu4F/reko+liOB+XcXbynI6zd1N9PA+rWQH4liNAaijoPrKYzYpET4lcAXfLu4Wsliw6gRj4jlUqRn921Bdm1oprWPRFVW0YBS15KfGVQRxqGwzHx5ZZg3D29dJDV4DiVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB2632.namprd15.prod.outlook.com (2603:10b6:a03:152::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sat, 12 Feb
 2022 23:28:02 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311%6]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 23:28:02 +0000
Date:   Sat, 12 Feb 2022 15:27:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4 net-next 1/8] net: Add skb->mono_delivery_time to
 distinguish mono delivery_time from (rcv) timestamp
Message-ID: <20220212232757.bzcdp5apb4r7whd7@kafai-mbp.dhcp.thefacebook.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071238.885669-1-kafai@fb.com>
 <YggG8U9lBD37umyl@pop-os.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YggG8U9lBD37umyl@pop-os.localdomain>
X-ClientProxiedBy: MW4PR03CA0199.namprd03.prod.outlook.com
 (2603:10b6:303:b8::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75122406-b7c6-4798-f2fb-08d9ee7f4fff
X-MS-TrafficTypeDiagnostic: BYAPR15MB2632:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB26324BCF1DD43CBBFD1A209FD5319@BYAPR15MB2632.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVB7CX8VNB3HhlJzIo4ZjWNac4qH+D6b91yCzDOhnSbeVClNOYDPgSFfSk5AoDkynikDms2OpvYzGz9LJUx5WVD5uudSx8WvMecHft9ERxJEYL5ktpiWcQlEzIMd5Lr8DjSTBOtTGKN5MDx0vhOuwLbzqLdufuZWL8j/zfFp3xOur98MU310wmJTndcFiHjUPYcz3M5r8GPlR9iiK8l69Oa00XLfrTGgj+3yM6FQbyd6Onum3eHurNJcwCyH4YA5WtOgZAgomfwFdVWo+rodrqEH35MSV+Z4EUUX/PQFRVuK0hZGSMN4u6q3RJzKKFS6huWLVv5uh5btWH0nTnLa4w6CsS9aV39ysG8YWLaRIjw7C0JlFPxF5nC4dbgsFcdnvHVo91M1s8TLcbJrBrFlhLfbBQXv/IpfXtDYUhFHOniZQ7blZIjJ+b3/mhKQvN/4KxAr7jLrYE+b3wrdo5IdEAwxUGtzy9Bw8HC5ncE5++boa7dxDC0T0I8IrHKWC8cYET2cKhHXTtJQWh8iY5jpQox1ap6XPzSAIKBKE0IGdgWH9zGaAGBHixzNR+xH1+Cl3QYulRkCjZsk/6SwikgKJ3JyS3KyY221ndaijd24P6ehzJuYbc29bc6ZOqOGuBM/T8l6yQfj1ELtsPpjkaElkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(316002)(66946007)(38100700002)(6666004)(8936002)(6506007)(6486002)(6916009)(54906003)(5660300002)(4326008)(66556008)(66476007)(8676002)(7416002)(52116002)(86362001)(1076003)(9686003)(6512007)(2906002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5qbArV4F8n8D+37+OY23jxLgehe/l/fI9saSjotHcR947umkNHcj/MEZdK2Q?=
 =?us-ascii?Q?Vqj3DkF5FSf1G29LPgBluTTsdJH/GuF0gK4nwiMiJBmrf784EtNd7DgR6Q5W?=
 =?us-ascii?Q?Yy39PxMZSsqXKJC0nnnUYDlcvZoUzIhqLOsMSewmTmDEEHfcFaDU1+o+p5Yj?=
 =?us-ascii?Q?BWscsfW9b2yl9UBOYbzRIUTTCE3F3NJn1EnIqqysWcQkrHRVIY8CDARnA1Eb?=
 =?us-ascii?Q?76uvJz9S4zLUmV9q25pDs9PPS0S44P+sHjAytO6KnXBP70Z80jm5jYpIg0Ts?=
 =?us-ascii?Q?BY17Gy1p8d7e47mY1iUq/XF4QlqL9CGo5QnkFGzndOJPWWUJGRemUN/agQP0?=
 =?us-ascii?Q?KWc4Gvcr5PRxznCOh36h/EUqhb3cmMhbjp+4APYkyY3XXGFDO3CHNPduRHag?=
 =?us-ascii?Q?fEK9hldXfiCuNci7Z2MZ1Y9zm0fPAAy5eGXMdF3E+bxPh/j9Qz6OICJ4xCE+?=
 =?us-ascii?Q?DpuNUh8c++9xBS7IBlGR3D+4v//l65cpOiB3xFO3RpcMCpv6z9S0xhlg5qHF?=
 =?us-ascii?Q?MRvWyw1NeR2BjBTxxPLA4IkpZb85pgIIybfRQbOvUMb9uWNFPEileK4v6Gju?=
 =?us-ascii?Q?qEP8oNgoobAHlJWOL61wvx1ziCwnyq0iy5ZPXXIyqbSl519x70NBMli8WSM2?=
 =?us-ascii?Q?hvckpmwwSzsEsg0tn+eCXqDPBB12zImJDOcsUKcD/36ZF28pjv1Zanhuhvv9?=
 =?us-ascii?Q?y4wFOO+wy9SBnY8VRuT3Pllh9Y3zOgmAddzm4X3Mmtvl+c/3LfcD+Qlz+BiG?=
 =?us-ascii?Q?HmnwO8GCKviXPBc7LjmEvmDm7XAfG+WX6OUzhjn5TBNFX627ZU5dXC2rG+uW?=
 =?us-ascii?Q?kjLhLER3MlMYMKjJzXW5Q2jaa9uAeZ4sjRB6elX+rG9e1KenkZf/4qQeo8bF?=
 =?us-ascii?Q?hIIykzkcpnmj1jYMKso4wkYJtAqBEu2JHU5w+DJr1qAZqIkJ9hnD7sl56CHl?=
 =?us-ascii?Q?ESifySvaBBfszopWGj8/FT4ElK3Uqqh4Vf5Qx1bNUgi/PPBU3RmHACYtylho?=
 =?us-ascii?Q?u+QvCcBZTAmnQAEZpQXpA9K6TfzHKAyDcUAwFwFvZWwII5InCvxjV9JRGA6s?=
 =?us-ascii?Q?AlguiGfiqQW7kqCxfxb9wzKcJagLZX4XfdQqww5Fz2AHzUnv5LCQMoyfNJ3q?=
 =?us-ascii?Q?z76N/8zACh1SEoKLcmJuUKpkE0PSeAkYVCu16ygoKw4gCLqCoG4ERv/D8Vfk?=
 =?us-ascii?Q?Y51xXd2zg6t8HHg0u8yZNqDDYh7amMkQOFwrNAYiPcL6plH3qPSMVhChH4QM?=
 =?us-ascii?Q?QHJAFey3Vd1+Y36opEEYnbS6BLQJHhHwn2XdjQIZ5JWbFGy6S1bRc4N5/SYN?=
 =?us-ascii?Q?FtjVa81b4czgDUatO2XNHzmCsZ7TLQE7fnMOkz8rlOX6+B9YwPCKIFxf2cGg?=
 =?us-ascii?Q?ZOJ7zyaCyQOw90lsrniIaj1+hrt/toL2CJ1f0ugq6LAydagPOrPI5efZSDze?=
 =?us-ascii?Q?6WbfFRhxKu88SEzuQgKl9YQ5jHT5+iVHA5wAguj8a9O/6B4AtS/iOAQIFnAj?=
 =?us-ascii?Q?Q0Ouh+V4mIC4LHZ354cziZwp3f+sAO/jP03WsiZuJrthHFnaCXEBLZae2McK?=
 =?us-ascii?Q?G2f22CCuT9+wP8s8hXSNFhRluK4QEdNnlmm1hpy4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75122406-b7c6-4798-f2fb-08d9ee7f4fff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 23:28:02.1629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ga6q1rQegxORP4qyAJTSinosu6G0Zf77eEFCirul0eNWuxsAlcISNRzKlIlwqze/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2632
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: tfRPKl_O7eZ5menJqXZPCEWTqzuW6F87
X-Proofpoint-GUID: tfRPKl_O7eZ5menJqXZPCEWTqzuW6F87
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-12_09,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxlogscore=566 adultscore=0 impostorscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202120148
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 12, 2022 at 11:13:53AM -0800, Cong Wang wrote:
> On Thu, Feb 10, 2022 at 11:12:38PM -0800, Martin KaFai Lau wrote:
> > skb->tstamp was first used as the (rcv) timestamp.
> > The major usage is to report it to the user (e.g. SO_TIMESTAMP).
> > 
> > Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in TCP)
> > during egress and used by the qdisc (e.g. sch_fq) to make decision on when
> > the skb can be passed to the dev.
> > 
> > Currently, there is no way to tell skb->tstamp having the (rcv) timestamp
> > or the delivery_time, so it is always reset to 0 whenever forwarded
> > between egress and ingress.
> > 
> > While it makes sense to always clear the (rcv) timestamp in skb->tstamp
> > to avoid confusing sch_fq that expects the delivery_time, it is a
> > performance issue [0] to clear the delivery_time if the skb finally
> > egress to a fq@phy-dev.  For example, when forwarding from egress to
> > ingress and then finally back to egress:
> > 
> >             tcp-sender => veth@netns => veth@hostns => fq@eth0@hostns
> >                                      ^              ^
> >                                      reset          rest
> > 
> > This patch adds one bit skb->mono_delivery_time to flag the skb->tstamp
> > is storing the mono delivery_time (EDT) instead of the (rcv) timestamp.
> > 
> > The current use case is to keep the TCP mono delivery_time (EDT) and
> > to be used with sch_fq.  A later patch will also allow tc-bpf@ingress
> > to read and change the mono delivery_time.
> 
> Can you be more specific? How is the fq in the hostns even visible to
> container ns? More importantly, why the packets are always going out from
> container to eth0?
> 
> From the sender's point of view, it can't see the hostns and can't event
> know whether the packets are routed to eth0 or other containers on the
> same host. So I don't see how this makes sense.
The sender does not need to know if there is fq installed anywhere or
how the packet will be routed.  It is completely orthogonal.
Today, the TCP is always setting the EDT without knowing where
it will be routed and if there is fq (or any lower layer code) installed
anywhere in the routing path that will be using it.

> Crossing netns is pretty much like delivering on wire, *generally speaking*
> if the skb meta data is not preserved on wire, it probably should not for
> crossing netns either.
There are many fields in the skb that are not cleared.  In general, it clears
when it is needed.  e.g. skb->sk in the veth case above and sk has info
that is not even in the tcp/ip packet itself.  The delivery time was
needed to be cleared because there is no way to distinguish between
the rcv timestamp and the delivery time.
