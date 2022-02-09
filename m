Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EFD4B02C8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiBJCAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:00:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiBJB7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:23 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF622AABB;
        Wed,  9 Feb 2022 17:42:46 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 219NY9bj028497;
        Wed, 9 Feb 2022 15:40:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CFGZET++CoApEKXIkltHxWrf1nh48MtGheWkuqvpIYE=;
 b=Jl+0Jv/ZB8hOBJP2HXSRZ/qV5txQpEqGtSFuylnpM6KSVBS3A1kX8J9whrfcAW1ICsrt
 aewQRwOYu2AlYqsWluhrsQZ1BTUYxripg1ZR4m6NfsFPfDec0mO0U1h7pddym6VrEg+j
 JFx3k6QBG0tou2l/a6R/NpLbxLRtPKOaoJI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4h9fjwec-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Feb 2022 15:40:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 15:40:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NurKN3X3jHtKQhuZ2sskq65MWQf5VGvb3SwF1U5dzJ9HbYQxDL5asaHkCp6kt86ZabM7EyoV2/T3lmQnB8ZDFNs10ilcYXvk8ZaJARZPX2qfzn6CZE0cvqJrySox4IbCsMYgyfOgG3UBBGvX2h9DlbGOz8iLvbBrgK8lZdnpflX/xFFa7c9auz9L57J6rF3Uth3emXOjnjbvwmJ4yKS+QgE/dfqZUi+Vqx4xhsQArrsOwikHGEEyUxN6IEZt4ORMSDpLOrrY6UPOyizp6+YYDIhH5SBOv/lB03lvBdI4iIfr3kNlOGDAbhXgu9KBH46qYIl4Slw/HKXp0NlNnM9mSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFGZET++CoApEKXIkltHxWrf1nh48MtGheWkuqvpIYE=;
 b=hM53j34chf116k2ezC8i770cK6ZhgXISHUDrNtkyCcGTg6xwcjbdUx/qIRvhH/O5JeqOaVxe7TnQNtWg1hDLGsfInA/vuWQryyHySwu1X+UBGvaYNNKF4UHCMBIWJtqkjPqoIEgzW3irrUUBuA3pN9lk4qr+2SMRwC0Ibvt9mtAPMOLDKAuCkR2DOTJx05Ev7SGQ5OqzTFuwXOO8bcUbZIo9nSEuSRUCFoouqanmtb3l9p4Z9B04vKNAPxQ26NgWnKfHaPY1wA2zZJsr9zoRMFuiEHBFO5lMkJwIjNYTq8NELdnW7ors680BKb1X0exXWfbxM9rmWtV7BE0XaNcIBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by BN8PR15MB2818.namprd15.prod.outlook.com (2603:10b6:408:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 23:40:36 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::d1e4:259b:cf19:99c1]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::d1e4:259b:cf19:99c1%3]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 23:40:35 +0000
Date:   Wed, 9 Feb 2022 15:40:33 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: Override default socket policy per cgroup
Message-ID: <20220209234033.d4uxiid2lbtentt3@kafai-mbp.dhcp.thefacebook.com>
References: <YgPz8akQ4+qBz7nf@google.com>
 <20220209210207.dyhi6queg223tsuy@kafai-mbp.dhcp.thefacebook.com>
 <YgQ3au11pALDjyub@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YgQ3au11pALDjyub@google.com>
X-ClientProxiedBy: MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::34) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40e4176f-c32c-46cc-e687-08d9ec2591ea
X-MS-TrafficTypeDiagnostic: BN8PR15MB2818:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2818C509F937B28F397E06D3D52E9@BN8PR15MB2818.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSa+Bvwis09U0JsX60cJRYDDahJTZgX17GDKWSneTWwYB7EXiE6k/ZhnMFTt2IXS6gj1kiuMBSevpG9zsN+1qFLOlgAxxgNYMntHbmxNIY9tqGNRRocQyIDtQWOBdOkrvjk/pOXYBP9dEWemmHfuBVO+9W+OAMUoTlDEZKYCXlhcb7x+jDnklNH6nfnaff34TBOl95BxfzDDpSWUMsQ4+OBwc51QwI+jW0yhfxxvaEXS3+R9gh+6sZo4GPkcZtlxZQzSO9grFoir3EAogD56kE8hks3+0iyMiLCWvNOey+/YRSZzSXMJ4GXSFIXQhBKLKXWUSZinI3nF4iV8eR7pXnGmpTdd//LmeqfCNIa5HFSkJiIzM2CvO56YUzcSnVPpUBRRSDDUNtwfPxCo2lHoxMgVWs+LRTDbs6+ErwZoXzCJyIU+eeb9awC1jhae4YGecPiYa0gTpnZfs/ORMWmWu5uQyBOD/9sUwEUyeQrqQH+GVFTP0H1zT5g2Rw4tDuT/DUytI3y9zcbo+6xYyC/kXa+VCZamF9r2MWgXS7gGtsPaW7PDNqfvidvJgATlhGDpq5an4dn81KWMPTLRhtrd9VPqb5A33p6wqPc/XA/mt4SRXz3JbDzAMmPxFG2UZGTdQo80hnlfIwZ+4Lfrba+47A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66476007)(66556008)(8676002)(6486002)(6512007)(66946007)(508600001)(316002)(6916009)(6506007)(2906002)(186003)(9686003)(1076003)(83380400001)(52116002)(38100700002)(86362001)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0211oTHUSHgrIoktuANJYqxJPfhJs6lt0OPeBEPQNCWSGekCa1XvvIPbG4X?=
 =?us-ascii?Q?yugFsVuJbLm/c6c5BUNZPy8NYtd0gdpqdoCc+AtV21MEqsSOqR4JKglGEciy?=
 =?us-ascii?Q?VbszGv8rvP3stln1+BCjQmBfi5y8WQiMe7DttAFVEpx3fFzizYXynw0bMxHI?=
 =?us-ascii?Q?Z8GJSbD3jVMJhyh2PBPeUtDfn0ZHFxKq1CbOJN7FRmNt7NaLBMXiD/8YGooh?=
 =?us-ascii?Q?VwoVDud1RPMVHIJheCtpfV0p/vmnmuaPCPsbob6urLRGhtoFLyWsgFP/gIRK?=
 =?us-ascii?Q?Ny2sEwLJCwer4UXypz2izGMrJ7IsCDeYEHyYF16LiWi51+piUFOqFTYMPyMz?=
 =?us-ascii?Q?L+n7/Ni7cIev/jrhfYY6gakPsVMs9+cqSvku2fpoDKQg4xUGyhsjTf6N+2yW?=
 =?us-ascii?Q?q3VF9L9S3mfUqoSiZcl48rftXJqLMslgKqZrjlT1WyfDtDc8I44iNT5d0mn9?=
 =?us-ascii?Q?TR6c6uQfMLvJHIc0OORpr+LTYRa7ztsqO0ZFZECwFAvJg6oUUsUX9rCa5M95?=
 =?us-ascii?Q?lRk4RKtqzIzTfb2x6BcfjW0h325n5CvYixOhM4+TMo5ZowvK+TGKwd5c71SL?=
 =?us-ascii?Q?Ksugr2FO216bZEq+r+3aZiJ64xHG0DTnu0X75ipbpB1onJgbJvTYOPo1P/Lr?=
 =?us-ascii?Q?DI61fEb/4/vin470+07wOHhRABCf2+gbh2/E+qz6a6TIlMTx5tODJNruEC2n?=
 =?us-ascii?Q?DB2J1LiyTV/urICe8+6/qpmOYxRQpofo1j7L7dJwcIStHFVe4PAPA6uJCnt8?=
 =?us-ascii?Q?46eBIvASFFhxMoyvSTmpqJT2cQ+OP9eP0JLSTUUE/SwuoDauMMb/38MTfK4k?=
 =?us-ascii?Q?KE9IIOiMOgQCA6oTI1eGCvwtyX52jGbXt/qATikIJMDq38mZ/5EerEYITs06?=
 =?us-ascii?Q?P6cqonnSwtjV1sg+k3Ugc8UBIFKx7RDTe0LaHUJ5TeDDHYKHEjLhLmpxu3lY?=
 =?us-ascii?Q?zxxM+Hbf1jLI8Eoiymkbf+AlR2NLDN6YtYtFhSfD2QMimvdZPYH07qeF8+dV?=
 =?us-ascii?Q?qVoV+058WvLUkcDG8rRUC+jgtz0dLAsigiQ8lXXQBx4OL/cW4db2X9tEEbam?=
 =?us-ascii?Q?a/eTPSnstaGPszfeLPNHd6i6GzIvGSYO5lxTtCtccOLwSV+SF7DolowLiK+/?=
 =?us-ascii?Q?aDWqWVJ4DkVn5V6NGXuqi5NT01TN43b//IaQjtmQWdodkJl9ERBaev5knOtP?=
 =?us-ascii?Q?TqMhMwLAbSr0jvDavo3vW7DJf+wzGhagVygCnwf2JUZEJjztoYE1zj4U+XPV?=
 =?us-ascii?Q?F4I3YlQEGFoWYPDip1sNxIXorFXe4p86ziSVEPIQS/qkVyzHRKoBvnbWt+eL?=
 =?us-ascii?Q?DqsnVpG2o1aBGmiXAQJ+dgW49FL4IW3YbAHAEoSD8bnr6Wuvz797wDxvTm08?=
 =?us-ascii?Q?kyGr+Sw2oOg4sYYeAjUfzDkm7iT7OhyywG4o4KegSUgEO7HjU6hU5hZD3jMv?=
 =?us-ascii?Q?jyH0UVjONfif2n9Pv9LmX76wynMFVrvnz52LZ/NGTS4mPWPm2Gr60SP136Ft?=
 =?us-ascii?Q?IzDyaiOFDzSmuavPBYsqNfZwjcN+fUW+I8ncfg3dYTBA+WJuCqXsuQyADyW4?=
 =?us-ascii?Q?obXPwvFruH6WSUor+7Enx3HFyi1SsIxKscVKOv5/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e4176f-c32c-46cc-e687-08d9ec2591ea
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 23:40:35.8639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL5sTjLDD6tSB4aRnJZ+YruoRb6uXDO8lSH3lEonS2+PtGnmHsGAURoC0UIiQ2WI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2818
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: qlnfisLrUkgD0REsx6nwiyKr7aPl1JyT
X-Proofpoint-GUID: qlnfisLrUkgD0REsx6nwiyKr7aPl1JyT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_12,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090123
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

On Wed, Feb 09, 2022 at 01:51:38PM -0800, sdf@google.com wrote:
> On 02/09, Martin KaFai Lau wrote:
> > On Wed, Feb 09, 2022 at 09:03:45AM -0800, sdf@google.com wrote:
> > > Let's say I want to set some default sk_priority for all sockets in a
> > > specific cgroup. I can do it right now using cgroup/sock_create, but it
> > > applies only to AF_INET{,6} sockets. I'd like to do the same for raw
> > > (AF_PACKET) sockets and cgroup/sock_create doesn't trigger for them :-(
> > Other than AF_PACKET and INET[6], do you have use cases for other
> > families?
> 
> No, I only need AF_PACKET for now. But I feel like we should create
> a more extensible hook point this time (if we go this route).
> 
> > > (1) My naive approach would be to add another cgroup/sock_post_create
> > > which runs late from __sock_create and triggers on everything.
> > >
> > > (2) Another approach might be to move BPF_CGROUP_RUN_PROG_INET_SOCK and
> > > make it work with AF_PACKET. This might be not 100% backwards compatible
> > > but I'd assume that most users should look at the socket family before
> > > doing anything. (in this case it feels like we can extend
> > > sock_bind/release for af_packets as well, just for accounting purposes,
> > > without any way to override the target ifindex).
> > If adding a hook at __sock_create, I think having a new
> > CGROUP_POST_SOCK_CREATE
> > may be better instead of messing with the current inet assumption
> > in CGROUP_'INET'_SOCK_CREATE.  Running all CGROUP_*_SOCK_CREATE at
> > __sock_create could be a nice cleanup such that a few lines can be
> > removed from inet[6]_create but an extra family check will be needed.
> 
> SG. Hopefully I can at least reuse exiting progtype and just introduce
> new hook point in __sock_create.
> 
> > The bpf prog has both bpf_sock->family and bpf_sock->protocol field to
> > check with, so it should be able to decide the sk type if it is run
> > at __sock_create.  All bpf_sock fields should make sense or at least 0
> > to all families (?), please check.
> 
> Yeah, that's what I think as well, existing bpf_sock should work
> as is (it might show empty ip/port for af_packet), but I'll do verify
> that.
> 
> > For af_packet bind, the ip[46]/port probably won't be useful?  What
> > the bpf prog will need?
> 
> For AF_PACKET bind we would need new ifindex and new protocol. I was
> thinking
> maybe new bpf_packet_sock type+helper to convert from bpf_sock is the
> way to go here.
Right, should follow the existing bpf_skc_to_*() and
RET_PTR_TO_BTF_ID_OR_NULL pattern to return a 'struct packet_sock *'.

> For AF_PACKET bind we actually have another use-case where I think
> generic bind hook might be helpful. I have a working prototype with
> fmod_ret,
> but feels like per-cgroup hook is better (let's me access cgroup local
> storage):
> We'd like to have a cgroup-enforced TX-only form of raw socket (grant
> CAP_NET_RAW+restrict RX path). For AF_INET{,6} it means allow only
> socket(AF_INET{,6}, SOCK_RAW, IPPROTO_RAW); that's easily enforcible with
> the current hooks. For AF_PACKET it means allow only
> socket(AF_PACKET, SOCK_RAW, 0 == ETH_P_NONE) and prohibit bind to protocol
> != 0.
Meaning a generic hook for bind also?
hmm... yeah, instead of adding a new one for AF_PACKET, adding a generic
one may be more useful.
Just noticed there are INET4_POST_BIND and INET6_POST_BIND
instead of one INET_POST_BIND.  It may be worth checking if it was due to some
bummer in the sock.  A quick look seems to be fine, the addrs in the sock are
not overlapped in a union.
