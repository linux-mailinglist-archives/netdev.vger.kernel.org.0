Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3625478594
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhLQHeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:34:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33292 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232167AbhLQHeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 02:34:15 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BH1FxfE017889;
        Thu, 16 Dec 2021 23:33:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xYVHyGPVQKvHszMNmBpOw+zGInugyYu3WogDrU/vOGI=;
 b=pmFkwihAdpgu33jnPl+VSnQ377oZZrM6ygOd4JTPn1cRdDJGwydMp9r7e3i/U7KTtTnY
 nzwliWh/bce/Rvb0EbS9wYxsIOonQMlB2vFH7pv/406DUeDb043zgeoPfY32EM63OVbj
 ijuVRLpOtT26Ij+Vaytf9cZ0UOvLfi6VPoI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d0gqx1mef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 23:33:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 23:33:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+93FwF38CTzu5xyD25wwzVgp58tUht+3mHsL7tgDWkkMCQYGwAzjAtZeHSVNfN66MeIWvPyWSs4tsAtdvri66wGCMErEdIal7w5hOkkEBxl7UeYGJ8bhWlaJGgNlyFewyj+2I5ryx20EFOaKKFlfXdFheYz8gYVuKG+jLU2TegwDPSOVUOXgJ/BbgVjLPKZPR8CS3cPCvdItbqf3HO+JsvlEelFB514Qxq1FtYLG3q4tOlfTneV7Km4z66n5Rm9iGss+EibZsYO+eEbBRzMirFL35vHfMQZoPoriIPbxABEDPAsLntsIiyZXo8MHMvunN33MaWHa2uvgc3DjpTzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYVHyGPVQKvHszMNmBpOw+zGInugyYu3WogDrU/vOGI=;
 b=laWRJh8BGUxqsrN9D+j27tSqqEI2Tw8P5fuGV5RBkI5QeF26UBm7SIofNqnzag7I8/CHKmMBHIa8KeJr/NcgdGApTU8Xybg6OL0oQjf3h6Y2Q6EvpV32ElIOzEFk3vpl7vB56eXN1raAywrEq3leY/bWAb32Ur3Q7tr67kOKKh7no2wCDDjQP4ZdoeIGUVKs1ohcIM8wBGZAGeMeEKXyJE3PxUCaMzCPITvsZcGycAYFWA7k1IOQc+kPHgd8nOlicXSUgSWGiUX0eN1daTrISGLjvgomXgEi0pd3bkE8ETh4j1byS65yW8j6G2SlhY5VqI8D/j7lQVgMz1Ft+eCD4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3904.namprd15.prod.outlook.com (2603:10b6:806:85::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 07:33:54 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 07:33:54 +0000
Date:   Thu, 16 Dec 2021 23:33:51 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
Message-ID: <20211217073351.k4thkro443m3fnme@kafai-mbp.dhcp.thefacebook.com>
References: <20211215201158.271976-1-kafai@fb.com>
 <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
 <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
 <CA+FuTSfsrMUAz-5Huf2j4f35ttqO5gpFKvsn4uJLXtRPqEaKEg@mail.gmail.com>
 <ca11f6f6-86f9-52c9-4251-90bf0b6f588a@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ca11f6f6-86f9-52c9-4251-90bf0b6f588a@iogearbox.net>
X-ClientProxiedBy: MW4PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:303:b5::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0184a24-b3fb-4a47-6bdf-08d9c12f9453
X-MS-TrafficTypeDiagnostic: SA0PR15MB3904:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3904A68F6C4DB33D2ED01269D5789@SA0PR15MB3904.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GuuIf2S8VxAHMWB1p+dXUYNkODP2bwZbd8mfS6kyKVvwOmvTCRsY7T69l0uxkXZ/d/D+QOV0Ky7V1QnLCbe+TAegnN2Z6fokukie+gBufdtDCxIMQvSYSqHdg6NhxbLjU1tlHWlViUQEw9gQZJvczoMA3exhWBlW1c8XDruQPQvFTHkfs/HlKWtYwmN2PXM/8bVlOJur6Jb4gFJZxkF/fNVGJ7Dn+RFI7dBxh+lNWPRLvZl2aVoLdz55nBsUYaE30/hajP4YC4Dx9QU7uUXWuy47Dv0pk0j+vJdc0w4LJx2M0UMwRrHoS5BK485Ai5ZSOYHDG4edSXHRFI3lYqu5pfxEXrpjFRzDPFSo3Ziv8X8OhLrjOYLHd8hQDPk2k3vqyUSw4VMNiAySqDq2tC7vYJ9nLgzAOFr3JBf+ABN5lhP3FBWv6BUSIcy3kZRRCAIFhWVtkDzPDfGO8HwNQzxR9eizxgPKhZdW+5Yw0NMMGWadQAdFXJEGkexp0F5blgO7sJ1ZqLQ7cm05vO3Y0vSDCvyFbUaiXB73/9pL45JHEY4TiHkK7rTq/cMdZJtOxT05aIDX5hLqShMr6hAFXwljPOxoVeKlco5asSsbJUzmcaKJAuVVVGPJL89vGg2mwfmSpfHZ3/8wMb48doH3urzEAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(86362001)(53546011)(8676002)(186003)(6666004)(1076003)(6512007)(508600001)(9686003)(6486002)(66556008)(66476007)(66946007)(316002)(6916009)(83380400001)(5660300002)(52116002)(2906002)(4326008)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1HrYDstzsNCZFSGLmBcTDI7yXZgd7rT+IqQgPGEz/5+aiOXVXV2rO7PO7Ugo?=
 =?us-ascii?Q?ldJRvFEAyY8qHmeA1mVPjCElMETLo2TFKwseYf5YIU6vBK4TQj3RKS7IcoFb?=
 =?us-ascii?Q?E5O0amKQskHyNlqvmhS63PW/gvTxoqa8q6LV6nNA85Cb0yASOV/h4K4N+ilE?=
 =?us-ascii?Q?7dhB1KvRRpMd7XqavFiArxcojcxLgFhR2zYEpuU5zDSwpfCUuDp2vQelPi+1?=
 =?us-ascii?Q?Xp9g0PdoDuLKr24YJZ4I6bd3RzxE2BEAVJAd+bV4bAaBJRViwhVva/JnU7jP?=
 =?us-ascii?Q?BO94LhinUNkzD4evnbW0iPcrENKopsflGzDPdG1gYHdmvZrZB7OTc1LGznTE?=
 =?us-ascii?Q?0n5U4GQRVFKLcsdlvVY635DbqpJBmOvnYhQbm6gic5kD/3RkiUoxwb2GmBBy?=
 =?us-ascii?Q?s6pxkvLiMYK9iQ2/9uN2uJKmfZ+NH1ls9KzZcCKbnEO4pKISPiykywPWw1j6?=
 =?us-ascii?Q?CQl2os0i0YX7XyLChqamjNY5tT1ExdHZzt425YYbwVNfW4t6ANZJ7zcWQkjO?=
 =?us-ascii?Q?Obdy0htQ5HfbvDqIGWuaRC9wG2Bg9c8YiG4Y8WcEEfvxqKzV4fCuOGK5Knoo?=
 =?us-ascii?Q?Z8sRyiMwZj+FUGDGlVAv6Chwl8+JAn8Ut8nyWFsBMXdjiR5YrxUB2KJXn4Gz?=
 =?us-ascii?Q?NJuDH9/S7PmgohliffPh1wZ6TS0g2WiYGXch8It2HHikp/HODp98vs9jtgpq?=
 =?us-ascii?Q?ACUqzalWtOcFHaLwjQVlJK1B9gZEcEZWEeFg8XU5HdRTWXtnJWarj+nPb3Uq?=
 =?us-ascii?Q?IVEN6js1TDF5qqSCj0hDWwSrCksHAaVVHGkbgw69TFX9ucDTCxGMPIAoqV7Y?=
 =?us-ascii?Q?eRX5Nqp2eDq2CuRDnP47EV/AMZEJQjxjVm9swrIzE84zfDuxjs/jDNX7UkZf?=
 =?us-ascii?Q?p2uEEn3pS37hI0dvibPkBua78lZtHF62z/tihUZKlzHC4iE6FuKdWOqq6pGT?=
 =?us-ascii?Q?yod9WUPJWtKG9dRXyyvjcELaVgbjp0bJyhqlBguZDaVmqhZ8q14HNcDRxPBo?=
 =?us-ascii?Q?2h1iIwXIG92iaiGSUVVzNe2LVGOdKQguraTYnawvLJWkuIsPXgCX6yp2/84R?=
 =?us-ascii?Q?gKesQUmXBHOp24AO49eG1yUOA8ucJNc1GldEaYmDHvq8VEzKn5OVUSjNKUjJ?=
 =?us-ascii?Q?Lk3g+10IzL5HfT1lOqOgk2JPVMBNjJW1nKCE8PMorKJIvgz2pd2cnkMKaa1B?=
 =?us-ascii?Q?xBGkVplSymU0jfB0eNbcx84xTwTXgIiyM87RI6a6XCiU5S3NCCXXcX0qhe6K?=
 =?us-ascii?Q?xngG+7aNE77g9JNkkJD5BocedR/7d4CIB+nTlYPB3sKGPCovUUQLe1L/juIX?=
 =?us-ascii?Q?GKEYInYlv87U4J6NYEHuTbDTaq5AsY8g4RDDAJoEe2LrmHf9cykB8xBeWw+r?=
 =?us-ascii?Q?TBb+nCYsP71jUBih1tSBbDt7gCVHAa3YrHnB61yNZHQqlJJB7zUdkX1VVtEZ?=
 =?us-ascii?Q?l+4Ol1v6mpXPH7AH4CR1WOibllDIBjwGi9v9Szas6dXu2rfC6bqmN2Ex6pHB?=
 =?us-ascii?Q?l7ah0WhwosuKXxaqXeQ0BkkAot3qRbQXoFmDtkEdNsiW32Po9Frqmmx2G06h?=
 =?us-ascii?Q?3qhs+xRTEyyH2QyiaEzmVIYgxhhBENdN5eoAVRem?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0184a24-b3fb-4a47-6bdf-08d9c12f9453
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:33:54.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kN4zND27uwucPHmU+eaZsAP/mpKOt4bdlfNxQyBqPfQc/EtKk6hB47vWxgz3FMn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3904
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: LNUmDMO0HeepFhsodPyyef8zeWI6NULI
X-Proofpoint-ORIG-GUID: LNUmDMO0HeepFhsodPyyef8zeWI6NULI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_02,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 12:42:30AM +0100, Daniel Borkmann wrote:
> On 12/16/21 11:58 PM, Willem de Bruijn wrote:
> > > > > @@ -530,7 +538,14 @@ struct skb_shared_info {
> > > > >          /* Warning: this field is not always filled in (UFO)! */
> > > > >          unsigned short  gso_segs;
> > > > >          struct sk_buff  *frag_list;
> > > > > -       struct skb_shared_hwtstamps hwtstamps;
> > > > > +       union {
> > > > > +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
> > > > > +                * tx_delivery_tstamp is stored instead of
> > > > > +                * hwtstamps.
> > > > > +                */
> > > > 
> > > > Should we just encode the timebase and/or type { timestamp,
> > > > delivery_time } in th lower bits of the timestamp field? Its
> > > > resolution is higher than actual clock precision.
> > > In skb->tstamp ?
> > 
> > Yes. Arguably a hack, but those bits are in the noise now, and it
> > avoids the clone issue with skb_shinfo (and scarcity of flag bits
> > there).
> > 
> > > > is non-zero skb->tstamp test not sufficient, instead of
> > > > SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
> > > > 
> > > > It is if only called on the egress path. Is bpf on ingress the only
> > > > reason for this?
> > > Ah. ic.  meaning testing non-zero skb->tstamp and then call
> > > skb_save_delivery_time() only during the veth-egress-path:
> > > somewhere in veth_xmit() => veth_forward_skb() but before
> > > skb->tstamp was reset to 0 in __dev_forward_skb().
> > 
> > Right. If delivery_time is the only use of skb->tstamp on egress, and
> > timestamp is the only use on ingress, then the only time the
> > delivery_time needs to be cached if when looping from egress to
> > ingress and this field is non-zero.
> > 
> > > Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
> > > because the skb->tstamp could be stamped by net_timestamp_check().
> > > 
> > > Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.
> > > 
> > > Did I understand your suggestion correctly?
> > 
> > I think so.
> > 
> > But the reality is complicated if something may be setting a delivery
> > time on ingress (a BPF filter?)
> 
> I'm not quite following the 'bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)'
> part yet; in our case we would need to preserve it as well, for example, we are
> redirecting via bpf from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
> the egress path and fq sits on phys-dev.. (I mean if needed we could easily do
> that as shown in my prev diff with a flag for the helper).
Right, we have the same use case:
    redirecting from bpf@tc-ingress@host-veth to bpf@tc-egress@phys-dev in
    the egress path and fq sits on phys-dev

My earlier comment was on having the delivery_time preserved in
the skb_shared_hwtstamps.  The delivery_time (e.g. EDT) and
timestamp (timestamp as RX timestamp) are separately stored when
looping from veth-egress to veth-ingress:

	delivery_time in skb_shared_hwtstamps
	rx timestamp in skb->tstamp

Thus, when bpf_redirect_neigh(phys-dev) happens, bpf_out_*() can
continue to reset skb->tstamp as-is while delivery_time will
automatically be kept in skb_shared_hwtstamps.  When the skb
reaches the egress@phys-dev (__dev_queue_xmit), the delivery_time
in skb_shared_hwtstamps will be restored into skb->tstamp (done
in skb_restore_delivery_time in this patch).

> > > However, we still need a bit to distinguish tx_delivery_tstamp
> > > from hwtstamps.
> > > 
> > > > 
> > > > > +{
> > > > > +       if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
> > > > > +               skb_shinfo(skb)->tx_delivery_tstamp = skb->tstamp;
> > > > > +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP;
> > > > > +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> > > > > +       }
> > > > 
> > > > Is this only called when there are no clones/shares?
> > > No, I don't think so.  TCP clone it.  I also started thinking about
> > > this after noticing a mistake in the change in  __tcp_transmit_skb().
> > > 
> > > There are other places that change tx_flags, e.g. tcp_offload.c.
> > > It is not shared at those places or there is some specific points
> > > in the stack that is safe to change ?
> > 
> > The packet probably is not yet shared. Until the TCP stack gives a
> > packet to the IP layer, it can treat it as exclusive.
> > 
> > Though it does seem that these fields are accessed in a possibly racy
> > manner. Drivers with hardware tx timestamp offload may set
> > skb_shinfo(orig_skb)->tx_flags & SKBTX_IN_PROGRESS without checking
> > whether the skb may be cloned.
