Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6739458331A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiG0TJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbiG0TJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:09:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FBE6172E;
        Wed, 27 Jul 2022 11:50:21 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RF9iLu005061;
        Wed, 27 Jul 2022 11:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Rt3oK636nSHqO6x0JIW7f2TEolpWXKdZA9n8GXXpyoc=;
 b=h8XG5Q7/xTDEtrEsCVhMWzX3g/+7qqcR8Uf2PFJQJCSFGy70k/LkdMClEb9LizbSK0uC
 s+dheC6zsWwdhk2Ivy35k8eRouHcRZ/dIAMSkt2n5kfkuJMDAL1jiQtwdac9W4etyAil
 hVbG+Qe801eGUynshK0m6TCZkw1CSvPoYww= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxb29rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 11:50:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOD0tVk3SVG1228jX54pDIKHy1IaL80EDt0QyAYEUKcl+Uu/BXSWiB0a5AkRmClskHrzwBtM9g4o1biuVmrdU0z9mxQlQjLrJZGvYwNBG17+kK4Fh1ic0GuIpGkn7SDZJAn8DkItG19bHLXOeqdTq2QqvB7SQLYXLcy7piS2w7uFmXYZpRpGjm4bFNpdm350sU7otJmzpOHF2c9ilS6R+G0N+cKKHRYQAtrIzQ1HFg2C4y91E8FqrnNWmNm8k8D3GSKn8trWH2GUFGV+bUa/K4yj45zrytBBRbnzWNG1TkFCDIObXJAS3sCy6xq/b+cK/e5lKT9Cro6RRqRRirX3gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rt3oK636nSHqO6x0JIW7f2TEolpWXKdZA9n8GXXpyoc=;
 b=l3XCb6oj3DkqPC1IitwDSOKG0k/9rYZe6Z12AHiZSXvJxfrItPiZFHjvA3pNWq/m6p5NJMOurxIW/xLPbMCO6ZAMWK77HFm2/uBZ4zEe/sQ5WkRtFENdvMn8nep6mHdjCsKPvCKAzmfeZG7s4RUxWuueY1pfg0EshRGhjlOQNKbOKpZGgirta66IhSP4WJ653J3kkt7J7jmrg1NdWrUX3DQEWTe/HRga1t3kS8pSXjHn5Hr19pgAy8x+B5imCqxzP06Yh64akYXiJl4MwK0guUqU5YVntxfAtsZazkqpBrVd3xfekiAskrIKAS2owdq0OxhwDFP8hIDNwWCjddwNRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB2842.namprd15.prod.outlook.com (2603:10b6:5:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Wed, 27 Jul
 2022 18:50:02 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 18:50:02 +0000
Date:   Wed, 27 Jul 2022 11:50:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 01/14] net: Change sock_setsockopt from taking
 sock ptr to sk ptr
Message-ID: <20220727185000.e325z3zpqzddvr2a@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060902.2370689-1-kafai@fb.com>
 <CANn89i+X-6Z=a-mYGEFTa=SWB2anDGsJYJoG_rAeo07HpBjw2g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+X-6Z=a-mYGEFTa=SWB2anDGsJYJoG_rAeo07HpBjw2g@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:a03:331::13) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99cfbc40-2a42-4c41-db5b-08da7000d04a
X-MS-TrafficTypeDiagnostic: DM6PR15MB2842:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYlO3QQRYIEPtWFa/pUdAawZ2c+/aBD/vUkMtMfiu2/79JOzUH8nVsTlV3dy9CkRxahfXx7JA/N8iDlb5n6gtSimSA9BsskXkBP5aGQCy1pfHu/CMsDbsQywb52TZ+ju0yBxAjknaQtrgp6qqg/vJFvTkAs8o38+z43upCypc7K5AcyeOOzkUvIq14cRs6c1iuaR4dch2ZA1yU5VRbOyehilYTtmACVqwuzeiHUzq5eoOFg7cYJ5Cxy2uxUxB7DGmpgpcd7ZedKIeNa9/xcZkhophaMEPTPn3wqdi/8Jea9PZiiPe/rZAgEgPfieQOrhrG6o5Latxe3/6msycPfE1yXpuJpIlcoX86S6XghKZFPdikHcP2qrIH1nL0TFeFaPNGr6jx6IEsh3JqxcMEOAnfGXyH2PCQAR83IIbtJ0fu5iPocguK2vgqXTf/5w9m/o23kEDJ2I9NpCfHU8LDFePrAtDU6t9l6lRoGSX7fnB+Jd1AStVIswlka0icPCfidO6NtkJq24+aIGyGYG+PwsiyEWoMYdfWDbSg9NKgBbj36JsmoNI061+1ADqpx2gsuVRL9Pez7ipbrmUQxgI9my73YoS2YQBssvvlDoIoEO5nDKmnedJkxINpCFGeiT3iGp2QbqqbbFSUPkjIuLY7exFz8qsc+Vz4LLXxduXUlMPTsyybsLArki4jDxWkuEFJcxHWC2PlMp8Mcz8mcfEMpsR+aECkmM2vsCqDe4IUFJ8fQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(478600001)(8676002)(66946007)(8936002)(66476007)(5660300002)(38100700002)(4326008)(66556008)(6486002)(6916009)(316002)(41300700001)(2906002)(1076003)(6506007)(186003)(86362001)(53546011)(6512007)(54906003)(52116002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xMcit3c4S9plppYUOpvu/dNQdKx4DEaq6IGQksWrM+TBRQ+JjjJwbchGIau7?=
 =?us-ascii?Q?3JzvntTQd+3zd29dZhJnNmjmdjmNGoGevkC+Pbo6s70eoPUH6IkO6VKxjpdY?=
 =?us-ascii?Q?n12GtuPdDvDvxEBr9GOXXI+OAq+OlKV0xqQo11/H9C9hg9bIHPJWkc6BhwCe?=
 =?us-ascii?Q?soe2OrpaUxYqHumL2BEX8iln1X6fPPPANb0r7lZXa+jthXSD5gCKMIfsaTyu?=
 =?us-ascii?Q?HX4YyYbBd42Iwv1yu1QfSXPPbNnt6HyDadgFrS5eAIn7JbAp13UYqrE/TxMC?=
 =?us-ascii?Q?mL1lH21p4vxPGrW6Y6uHbCc5CBGiHAn95KZFCYcbG4Zlb2wbvre8RuzTFHUC?=
 =?us-ascii?Q?sp2zzXGBHc0teUD0BcyEMsxszYCVzqS+Ebn3bV4ptIF4NHHGD1Qxc6rwF3DZ?=
 =?us-ascii?Q?TMqjmB8O6QSPTJH2gQ80riNlaLyhv+Ru9pK+TvRlrr/n4e4Sc6KXsj3WMp4J?=
 =?us-ascii?Q?/sH3h4HEEpLoGbaMHmREzmd9PzVtgdQXEhBCdHwK1T6jHQAI/SLpwd/jByzL?=
 =?us-ascii?Q?TZP/yA4Ps2EYV/svGaUCurL6JPMhRasFgI1qKIX1vNXHqC0CuQMwnvSrSV6H?=
 =?us-ascii?Q?tuTGM4gFoXpoZfpMRoM1i6FI87ZGi/Xv1uBuno2+ztDmC02yGTHcE2t/VYjY?=
 =?us-ascii?Q?uYaA48XyJz7Dtp9EujNhCXJGY3xxd8siN0sHB0nBPk6YLmTmEpdo+lFaxJJp?=
 =?us-ascii?Q?LxNf4YQmQ4s49MBFisFfal7KEPO7WpnDQyjCFkE52jKMUhmu60GzGVy6RPjJ?=
 =?us-ascii?Q?utiyus18RpQFPSMhJihc1q68FlBZtx+aza14vTKgWHBp0eBHrNMe8f11AdeK?=
 =?us-ascii?Q?ChV7AII6AZmM35fMIaSNlx4jHn3BuoTVAQclIigmYxoqmKf90SLAWJY04BhS?=
 =?us-ascii?Q?jG6it9IaMdXID0HPon3+8NS/hSFv6TU2SGgx2lb5ctGDXzKCLsR/F0qLMYtE?=
 =?us-ascii?Q?QUvqcIzyjYJKMWvG3KhBzgk5wKCRktDIl5OtS14Cl0YH1WFdacOvDS0pbfzw?=
 =?us-ascii?Q?viAQ5etwAL6k4l1+Z9WyxJXjtfZ+VAwPrc4oexNN02tqYRFY5TJKrEiHhSk6?=
 =?us-ascii?Q?7tjnLJM8v348ASg1cGKOkc3DHE5BPkZ+FUSv6kao1KpcCDKYvuUycv1EgMBC?=
 =?us-ascii?Q?at2Hz2cFr6/MxmmVTyI1k6nHg10YnBLvRHtWUlQso2wiGiz9nZoD+UzD23z8?=
 =?us-ascii?Q?+mrtkp4jyNok0IeF4N8MxVgstl81RUZXyFqVmsSHmIsmcTOgq5c1KCE83yJh?=
 =?us-ascii?Q?tLawnJFGkShm8pRb/0JbdTfURTe8tw4KPOZmxr7KX45aMM9tnP8brLf6GTS9?=
 =?us-ascii?Q?mWOujFHtbRGuco405CAF0N86tcFNmOotm2BtwPzvGwjN4RRJfYif/bQMklSn?=
 =?us-ascii?Q?3xe/0S70NNG7ci29YPrbC41K8LWo8RllLCPNqKspZObG2Wa5i+Ly86BhsXE3?=
 =?us-ascii?Q?gm52RP9wdgeoahZe2r63H3fvObQRyHWXby1jf7SZN709BQhDNsfv5UZdsCk4?=
 =?us-ascii?Q?DxSYwyzQUFtP4s2fgt72zTw8+rGwAaW3K2MHgj5x2B4dFfzchEeRnwp2MAYy?=
 =?us-ascii?Q?9gzRPrDqBLtBVnJj12Mz9PNMVEdj0hsFaxlNSVpWEmRQh34/gthtvWQssIMp?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cfbc40-2a42-4c41-db5b-08da7000d04a
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 18:50:02.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9tSVmQuKRNIgZfcaLFReIo/5kXN2Hg2RdJ9FUTug5koy/gqZ4OEgsnDGgWJoz8L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2842
X-Proofpoint-ORIG-GUID: KVBzO3PvfUi03UT8K3pvhiKfHLbfbjJ3
X-Proofpoint-GUID: KVBzO3PvfUi03UT8K3pvhiKfHLbfbjJ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 10:16:28AM +0200, Eric Dumazet wrote:
> On Wed, Jul 27, 2022 at 8:09 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > A latter patch refactors bpf_setsockopt(SOL_SOCKET) with the
> > sock_setsockopt() to avoid code duplication and code
> > drift between the two duplicates.
> >
> > The current sock_setsockopt() takes sock ptr as the argument.
> > The very first thing of this function is to get back the sk ptr
> > by 'sk = sock->sk'.
> >
> > bpf_setsockopt() could be called when the sk does not have
> > a userspace owner.  Meaning sk->sk_socket is NULL.  For example,
> > when a passive tcp connection has just been established.  Thus,
> > it cannot use the sock_setsockopt(sk->sk_socket) or else it will
> > pass a NULL sock ptr.
> >
> > All existing callers have both sock->sk and sk->sk_socket pointer.
> > Thus, this patch changes the sock_setsockopt() to take a sk ptr
> > instead of the sock ptr.  The bpf_setsockopt() only allows
> > optnames that do not require a sock ptr.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> 
> ...
> 
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index f7ad1a7705e9..9e2539dcc293 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1795,7 +1795,7 @@ void sock_pfree(struct sk_buff *skb);
> >  #define sock_edemux sock_efree
> >  #endif
> >
> > -int sock_setsockopt(struct socket *sock, int level, int op,
> > +int sock_setsockopt(struct sock *sk, int level, int op,
> >                     sockptr_t optval, unsigned int optlen);
> >
> 
> SGTM, but I feel we should rename this to sk_setsockopt() ?
Ah, right.  will rename it.
