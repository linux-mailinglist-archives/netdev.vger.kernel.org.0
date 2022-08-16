Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1585964ED
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbiHPVtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237723AbiHPVtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:49:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3926BD59;
        Tue, 16 Aug 2022 14:49:47 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GJ5mwR027409;
        Tue, 16 Aug 2022 14:49:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ixXgPY3WNUuC+IKxJo6qVdHZEzj5eLqSzeZlO1f9lzo=;
 b=jjR3D7/DEnBHtykOlLcsyUI9cIRJhl+lL2e7VCsovUEbHAQuoQ44jE1WfQdbxR3advKB
 XCtoJEQdGAKHf+9HWQGTshTeywgUUK5u9j4GnG/0GivpxFNou4Xk8OZ0UOazIC7VMw9X
 IbTpv9KpLpfShaJhYMEeCKV2ZbzSTGzHA6w= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j0aekcbhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 14:49:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5taMZxONiO5FbNzSXmlQOXMzKLesOC75irMoolTLDuQzMOLIQZ+hZXlEbnTYriucR9d4wx1wIF+eKLePXW4LXupyj1gBcHW+47hdoCqDZFPlILNHxDJpplccL2tlPdIXW+COaaR5jHuYFqKVvKfvVT87WUNywTELHrYepuQNLY99baXhmotg/dADdv/Fjhlhfx8da2dD0VqhZb5rPoGAA1GFM2KmtRAwoHYGYqXpXA4HTURJM4gXre9HB2WRqdQC44c6GU6KsZ07akodZONDgptKomUjb8ltbkOoXKxTLmdLzuXgJ3xlrnoITT7VLfQ0SPjudsrKG+ocB89OY0OXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixXgPY3WNUuC+IKxJo6qVdHZEzj5eLqSzeZlO1f9lzo=;
 b=NofQqRa2PLTuJhqnX37OQoEqZRDneDGQVa14l+rKlhcGGllYyclcMM0M5CXozXF1o7ZsBjpeptQTYbqWdSyLpzOM7SfN0qyKiTh/bb5GbsIvia7P5Rlb9SKxWxYX2kgbykhFVfHgJxWuDqUPuRKMs8mrF52MZePLADR9t5gwdtC2468iBNeiXwj7IZ+X2fYzv77HYBL7zBkWg6/ACu1hZK1KLOyjfsO1gaqdRWeP1VlE8qkwULTtP2nwLFrzP5mt41dRc8IzF4377W/WDbITVAEN4ygknHEtjk00ZAQ+R4b21Frd6Fb2rCiBaHObxqIZZJU9o9gIndbdCJEt08c5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BY5PR15MB4290.namprd15.prod.outlook.com (2603:10b6:a03:1f9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Tue, 16 Aug
 2022 21:49:25 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 21:49:25 +0000
Date:   Tue, 16 Aug 2022 14:49:23 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <20220816214923.x57nkwgm6rrhkoyb@kafai-mbp>
References: <20220816103452.479281-1-yin31149@gmail.com>
 <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
 <3961607.1660655386@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3961607.1660655386@warthog.procyon.org.uk>
X-ClientProxiedBy: SJ0PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::19) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1d63c87-efba-432c-a5f8-08da7fd12fe3
X-MS-TrafficTypeDiagnostic: BY5PR15MB4290:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqgaA2DEyozrV+wSaIbCt0S6d7fyPJx/T4JXqi3VlMfpheD0SqIypogVORMF0Z3Rf3gzrTgUyfELs1wYJw2OXBOmCMmcjbfbfVRfxnGcv+RdA9p3c9hWlsgub7oVjX+VQ5SRXuJXiHNgzOKBNGoXVSDQdyjXyfdBnyNaidtb+QgBu7HhzVYoyp9O5DPw/BblenQEn1rG/4TO9I7cHADi/9MUo1wGK4g/DmvsSjj8fjCMB2b0Pc3ejyPbdx+55NgffnNVbEkiRVfUbnvtAv4/RrnIsEhJbM5f8ArBd14R/GrB4GS74gn39GQuwSB3NiUU0xS4Nr/jgm1kRRKJv6UacbhYlIF/Oyrou9qrTmu4eYzdjbIIrxQ9Gp/yUoRAT7i8Ng4irkHGCiOh0E7ywCeYBPJXdKaXiEL4qw9FFolFLmlshERsMHwfwAgQmGf2gSsW9pIdPIekwC9F5E9DXL/3+tBKoq0TnH63m+iClRJJ2Vf7mcRVO88z/7EJDcY/U4cvVCHXf8dZrqPIb4TqKK6IpW0opshv+GxiD636ALnheMVTp6GFkrmR1nmvJ9id7OOz2G3D5oW+qchz45/YQeDWGIxQ3nIeNTVeBm89qw5nc+c+XsbFho/iQ3SVaPf/vQU29IuH930mD91blMg5sEJh8X1lcD0uO0jxsqPOOoM0LJqTNiLW6P2lwwXyrVssS+s4blZRQm+PRi505XfNQn2JPltXkxkoulenUIi7whSJowI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(376002)(396003)(136003)(366004)(346002)(33716001)(38100700002)(83380400001)(86362001)(66946007)(66556008)(66476007)(8676002)(478600001)(4326008)(54906003)(6486002)(316002)(6916009)(9686003)(6512007)(6506007)(52116002)(1076003)(186003)(5660300002)(41300700001)(7416002)(8936002)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JVJIFl1fAqCaCLDJYW5ZXnjUC68LpGMjdCuWC1HDNWW4dut1/nNNPQJc05k6?=
 =?us-ascii?Q?CMIqGWMYeFP9TugyHLIT59vRk0jopYrswtDTCG54WTHKefU1Uidma/runqkj?=
 =?us-ascii?Q?uaxXxbhLzuDXJ/srdEgY3FsNdIXK3F518WxP5PJirkOPjOsDMsYdXuVVWtZS?=
 =?us-ascii?Q?2WGEVAn7jk3fJUTX+WH/LWv91P2lX4uLVL7Bez10VThATHfsK3fFIO8hW22p?=
 =?us-ascii?Q?2Tupf63y2GEx3mIUFj1lp1nwhuerx/Lyun0rZ/7yt9hGL4oGBPSEZptJmLCo?=
 =?us-ascii?Q?fzdJMHv0Ic3yukDMYfSpDDUtKH7ift8nalbsb9D7Jz0vgMBPupWcKLMiHAlV?=
 =?us-ascii?Q?AWL4S4Y8cy3IWZaQXDruED3eBPwzvRcs/j63SMqhSZy0KpqMvPKhwuUTQzJC?=
 =?us-ascii?Q?44HyIGdBdeFWXJddb/SwBiYZFHjK0uBmIJ6oo3W0zq+/UOjyul1wIrpYf52K?=
 =?us-ascii?Q?2gKhpYdGihklAyS1BpuB0RaMB23vSCumG7yG7mJ0oDRpaGFcFD6zL1/gBURb?=
 =?us-ascii?Q?JSUu3F2bLQtfdVkpW3vaev1IfGC+Iw3xYv+FtaKq0wH23bLtP/PKHGF3IOfW?=
 =?us-ascii?Q?J6B57fdno9h8pzj07H/mHLwPQFh9gpk2EIbtsSJftnGFsLpWXxuy8Q+Q4VWJ?=
 =?us-ascii?Q?N5p9XTXGaUvPRSXmeaZfGBpUappme0qCZkVn2+V0bOMzNodQe99FbnALSCdE?=
 =?us-ascii?Q?LqfZg69E0SueyMYsJpxbzN7NZIEbjg0QIdFGTECbn2Zku2C/5UpCB1oYiFYo?=
 =?us-ascii?Q?Qyv5kSU9ANGuSyN5m+MgtquHWdBbDcRLkrZYgJ6IcZ8tVF+PHp68XqEtWhsV?=
 =?us-ascii?Q?5BPJAp+1PkXRWTGpoL91FRxgdaaFTK7y+pb9X2Xc/KHtc1rDBj7hew+QREbT?=
 =?us-ascii?Q?k9wl6PbUpMvnpNjPFVpJYORmqPK8X0zZZpKjnbFnA/Jat2HJtxSgxaNCj7Cl?=
 =?us-ascii?Q?4fYuBsnXbg1FfXYdAJdoirI06cCKUOAzWSnSgYZ2Be0TdafbJaoE5YcCSGbu?=
 =?us-ascii?Q?ORsS3E7cMMY4T5Or8kwDRBIdYOkNd2NfOg9dv6dJFMq8G8j5kC0yOSTpDLD7?=
 =?us-ascii?Q?SKXvP1eFjR/o+/taN+TrIfRUOCGK4wM0hT3li6b7B0D6P+0t+nW7b/f25FBp?=
 =?us-ascii?Q?sbPtmOvzT3o355fUhBS7B/n3GflmKz6dwvsBbF8G1rptidSuHuLVHwHt2KHP?=
 =?us-ascii?Q?HAv4o5xiNB9EodRt/O6wYd5Y7wMyE6t0IS9wxB0L7jCunr3KNN46261OD4zo?=
 =?us-ascii?Q?j4NKh1WFl6Rx5GTw7Bc96PXLxaQNLmuzhxzKGIuzue5YhsVyg4iJgePC56BN?=
 =?us-ascii?Q?T0rUWgKHk4rjh1HH4ZlvgrloONXlIBu+tUGTExdqK4i8mU2SoXYkOpF/8Xkl?=
 =?us-ascii?Q?v9lIXeHSm/hMAJZOMSB+sVK8Yi1TUCWTUj+3ffbE/pCs5fcgH/tkx80cKkpM?=
 =?us-ascii?Q?p1imjMqFj9aPcvx4k27NXcpZFvYnl0O68DXL7UYoH771BsF9CGFCV62QGrmU?=
 =?us-ascii?Q?HvpG8gxkwoDsaCJ4U7/1WTsLVFY+DbmNtpL2ZbuUHE9ga31kOzkereZfw9VB?=
 =?us-ascii?Q?8tZfA62WERzhOQoTyxcyiz5Ig3Z0BjE0qt7gbiYff6T3PXN0gf0No9qe2qdJ?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d63c87-efba-432c-a5f8-08da7fd12fe3
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 21:49:25.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2exta0rfMoW4Nbi2/yToMo04t0YWRCdk77dZ+H0NKhdIOEtE19XLanQxA0RIrbk5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB4290
X-Proofpoint-GUID: sjJQxr4BzHeSZFGGgw7bM7LTj0_oEJrB
X-Proofpoint-ORIG-GUID: sjJQxr4BzHeSZFGGgw7bM7LTj0_oEJrB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 02:09:46PM +0100, David Howells wrote:
> Hawkins Jiawei <yin31149@gmail.com> wrote:
> 
> >  	if (socks) {
> >  		WRITE_ONCE(sk->sk_user_data, NULL);
> 
> Btw, shouldn't this be rcu_assign_pointer() or RCU_INIT_POINTER(), not
> WRITE_ONCE()?
It is not necessary.  The sk_user_data usage in reuseport_array
is protected by the sk_callback_lock alone.  The code
before the commit cf8c1e967224 is fine.  If the
__rcu_dereference_sk_user_data_with_flags() could be reused here as is,
an extra rcu_dereference is fine, so I did not mention it.
It seems it is not the case and new function naming is getting long,
so how about reverting the commit cf8c1e967224 and keep it as it was.
