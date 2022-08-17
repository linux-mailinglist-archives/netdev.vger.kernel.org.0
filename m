Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD4D596662
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 02:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiHQAnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 20:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiHQAnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 20:43:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8824CA16;
        Tue, 16 Aug 2022 17:43:43 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27H0JEvU008328;
        Tue, 16 Aug 2022 17:43:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=m1kKGyDnL9lWww8aOhgCdIZE3YpH0PCURSV5H6hv7l4=;
 b=IYjYDynTrKnKoiuwJ4afczw14H7rWDtI5SH3uOdk65a51ny2plLwOn661Nk5LHhv2soa
 j7O/FpCMUb7GLzdD/5U5BgxIs471ts+01UUJ1UD+r7iYISX5bQHITgDHYoqYzhZuzs8V
 TaBxqqRtVBry+/VPwC6+A5c7N1MNw6w8VNQ= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j0np583je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 17:43:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu3mQUQRdSPSmPPZylxAG6IgD7bY9D/dKjekxRuyg7EvbOR+8z5r4yzok+aq5sZ3LhpYGpGyTg/0+a9L8ALUuwBK9Bt3sxexB2BDiNpARRLWALC5WtyUdRRdi9CBbW6y/flsFJohGi+biCjcrzrN4JtiQ1H+9bOvoGeRWxWBNxV9gp0J+cvbEA9s6dVUnnDFg/ohA4PG7kyZzEopJC/ss4MU+kihJhDTKZGGsXl8EkHV7zACc7J8/9ks5/jtR3x0b4VspZOBACZ6KlyPw7/1cSWocsjl49tnAANXwt08OIAVipHiPdUh/m3yHLvRn1FXweXqXr+WdJOWxUh07OA16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1kKGyDnL9lWww8aOhgCdIZE3YpH0PCURSV5H6hv7l4=;
 b=TDyvhmQJLhTSDMjqaV5XDXyLcX6rgFGTfXjmqUwhyIYV7FoAR1Hr7fevks2mjvDTSMbnRpVHbEDQDFlvdBJnMwc8mYXyscTHjxcJa000wLU/wGGGWAJ3jpqnx9A/YOfh8pUZzMnv6HjL2ROpY9XqDsF0gLL2MhQaZG5pDNqA0f7dJIm8j+L4qMSK0ofQ3sk6cjiQzy1uYY+8GK7J7E2mlGlJ9SOtxHTWPKDOw9Whd3QLGyTTXXKJHGiPPGSHucgNhDzIapsV0NYS0byVbMdgqzocwDUx2DTjKp+Ig87Olgt4odPRW2dkZ27kb4dluWMyi5eTKE/jR0aSgMZWSJD4Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SJ0PR15MB4520.namprd15.prod.outlook.com (2603:10b6:a03:379::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 00:43:21 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 00:43:21 +0000
Date:   Tue, 16 Aug 2022 17:43:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        bpf@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <20220817004319.fd7dekpqeumbvmsh@kafai-mbp>
References: <20220816103452.479281-1-yin31149@gmail.com>
 <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
 <804153.1660684606@warthog.procyon.org.uk>
 <20220816164435.0558ef94@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816164435.0558ef94@kernel.org>
X-ClientProxiedBy: BY5PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::37) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f2d51a2-aec4-4f00-1dc1-08da7fe97c56
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4520:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7gZVY+qFPJWL2dXPdX/sRtkeb0Aoot9dqKcQIkS0GfHPtagkNjr69SBDCDRPGEBcMqGxzwk24HCvorFi4gPCGnOBjDx7fZlY6CDX8PJ+f4zlSXB86wqk0HEwqCZZ+prwtxnG70QPqAQqaB6JaMCK4VqLTSOzCCk1ELaeGkxFhmQdjpAqUVNfGdWM9IEV/ukhUJlKxVb8bsFY7sWrn/Hn2dBASvsUU0RP+q5w8044G3PVF16O0i6HWIsi/iQ34lSqR7LJZ9CnsEPukdwHle/EnF4lYXcl/qMpVoISKhDxf0NY//HdUDIhFW+hOT6SfKq5df479Y95QSiheyZ1C6MLCOe2w8QsHIaUpaYPNLCRTWDX7nkn6MeWDU07DijSiP4pijPoy7AWKeqJMj9P84WU92ygXDeD+KxRZp9VS0DLmwoancKb7xJ0ug/3xHwnhXDiPoBW5aIKPluJltszo+biOqPRtBHFvNW+mPEMhjEOTQ1p4ttUHvbKJFSx4j0bLtKZSxFrJPFSeOZJJul5MDVbsArhL+p5BmazkGb4SPcEVuE5uVQ+eETJUKm9i7q95OU19o/jXOHg51KKuhq46VXYM3K898z13N4OFVsR5EsB1hOxRADvju2aESp3UaASD9FJ/5q0NByboUN34/BhmQQ2YOxezLY0LKO34HTKatfROezm/5xQRs8wx0NNY3Lp6DgVHPON1A4kTq4yhEKlrrtm4Yu0ZtGgEk/ouMoKvKqRj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(52116002)(6506007)(41300700001)(478600001)(6512007)(6486002)(83380400001)(9686003)(186003)(1076003)(2906002)(7416002)(54906003)(33716001)(5660300002)(6916009)(316002)(8936002)(66476007)(66556008)(8676002)(66946007)(38100700002)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zTgPRFla0xL3Ow6uCADnAlBNTbBo3QmAuji+C0qwaF6aFVjqmSKkB9IVaHaf?=
 =?us-ascii?Q?6gjFpIlUqSw50J6oEySAM0PRaHz2N31gSFqC2d9bC9bA0QW36k4J6J7FdHXy?=
 =?us-ascii?Q?47HerSJzxbbMMOP2Y+u89tWTe7P0DiEbjooKCuUGjxsxME+CbkL7k7+CdNSn?=
 =?us-ascii?Q?X2veQcoTBeFCe8juCsIAQGN6cCWzfnfec0Ky1ZDk7OkbG77seukPE2ZkQiny?=
 =?us-ascii?Q?j6PGX1TTdK0HHytLm2qWHd60wqwrRaY8gmT7gwm/x7Swq/+z+74gLOx8dKwU?=
 =?us-ascii?Q?kp5+K+j3JduGQi3M2yy3OCM9apMpw40HWVZA864N58SkxYCuep/AR5z29BK6?=
 =?us-ascii?Q?KSI3BMrAyL5MqCbF4B7EtVo7Y9v7UoqzOgeORxQhthbiKIK86dNRhn1zcPqk?=
 =?us-ascii?Q?/JkijTLGyr1o+8DFTgAsKRyZ+Mvh25dVbFDsRK+y9ovFLgj6Q/uNHE0x2lr4?=
 =?us-ascii?Q?l0KWWiFrETI4InS/bkYdiBYM/CZmPNhGT3jf3LKfrtFDN/vAj3JsNpCuNptv?=
 =?us-ascii?Q?6bI+cgDm3ea/juAO1anOP1EEk0CjaMpSEeyMPCJ+74BO0Bw32wAjWZP5s0It?=
 =?us-ascii?Q?8NfzVuaX7Jom+8qopS7iTrJ3j0NQV8EdVbcpsodVZx2rqZ2GL/97yU1dUBSf?=
 =?us-ascii?Q?Yo12xCyxtJ3apj3enD0AUv00xIHR2YUCa5IqgojVOu6AB4yT9pcc0QqmlNF3?=
 =?us-ascii?Q?MJ1Xp82izPOe9SYCtC5M8wHsNiclvefvpPX3eV8YDBLbjGUIVGHhiUWalrxt?=
 =?us-ascii?Q?WAw7/Hc4zbefhIjIP5eEzCLIND2x1y8U5WNlfhpEMSJbcoJqIBDY3jdH/63l?=
 =?us-ascii?Q?OW5q6GrhGbn41yMDsIHdvrqgv2mB8pfG8T3vi3j2ELOy0CW/obrVZnXCB8QR?=
 =?us-ascii?Q?o2YZ8jiCMokcemlabjcvi0jDTkAtzSWQWrQPQ+O2KKU5CDqoKjaVjztPcxPH?=
 =?us-ascii?Q?WelmvLTC1lfkVV3hWUdJcIBbwQuQL0rvmlg0WNrJAK8IKf9OJlBgLTQrxA5/?=
 =?us-ascii?Q?N/f3ODDsLmoi2H/2LeT5wIskUo6z2V5lk/jW6WK1RoEZ1cF3JnVC2IgOQqeA?=
 =?us-ascii?Q?fF01H4WqY0Vi1HfhfBm9J1kGf504nUxnOWUppxhXOjn2m0hYsZ9teN5nO3zK?=
 =?us-ascii?Q?VwfLwcKFS7hkfo5/xezB1Cqw5+jUVDL1dXeAhbkro6ZcYfNDWu5e3sHkykik?=
 =?us-ascii?Q?L4w6R8UtJnlFt6k/K9uX9yrCFveGb/blGUaeMYeD72+1C6pYlrNJB1cmNzFk?=
 =?us-ascii?Q?fIvP/zYsTL5SnIq7Pb2okJr3t298VTGFPN2QLO9IvHtLj8dkoSUNZT/7QdM6?=
 =?us-ascii?Q?azoFoscnVJhiYaN1E0C2Ojkr0q53Zvk20GRazRSeDKBntraBOanP6/t8IXdd?=
 =?us-ascii?Q?4YS8JwIgQ/MFgWx0Nu3Qbr/3UZRX7IQjPxbJ7AGiDmBzvM+3CCaGpiQVtfkc?=
 =?us-ascii?Q?CWJKVfJjHUeJOpTuiqzPd5pbF1ISjP46NWNp6UUeKoPy/2CcLMtXI541Yd9d?=
 =?us-ascii?Q?t16fC7qaHAhpqLwyIgXcGgspgcGlU0bYTpS4ispjhfsVggSfyjY+Zz7MsBdj?=
 =?us-ascii?Q?XJhct7o/KYwKTGEEyYPW9dt2ifAU0+PBg6ZyYref?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2d51a2-aec4-4f00-1dc1-08da7fe97c56
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 00:43:21.8347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rQnRaKBp4ZsvATWbA5QrNiUGtLp7jHVEw9SlBJ8awLtOdZ1bsHwaH8/G9x37yTJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4520
X-Proofpoint-GUID: WHJOkSY9WWWm6BJ2kXO2JpPO-MAcCl1c
X-Proofpoint-ORIG-GUID: WHJOkSY9WWWm6BJ2kXO2JpPO-MAcCl1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 04:44:35PM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 22:16:46 +0100 David Howells wrote:
> > So either __rcu_dereference_sk_user_data_with_flags_check() has to be a macro,
> > or we need to go with something like the first version of my patch where I
> > don't pass the condition through.  Do you have a preference?
> 
> I like your version because it documents what the lock protecting this
> field is.
> 
> In fact should we also add && sock_owned_by_user(). Martin, WDYT? Would
> that work for reuseport? Jakub S is fixing l2tp to hold the socket lock
> while setting this field, yet most places take the callback lock...
It needs to take a closer look at where the lock_sock() has already
been acquired and also need to consider the lock ordering with reuseport_lock.
It probably should work but may need a separate patch to discuss those
considerations ?

> 
> One the naming - maybe just drop the _with_flags() ? There's no version
> of locked helper which does not take the flags. And not underscores?
I am also good with a shorter name.

Could a comment be added to bpf_sk_reuseport_detach() mentioning
sk_user_data access is protected by the sk_callback_lock alone (or the lock
sock in the future) while reusing __locked_read_sk_user_data() with
a rcu_dereference().  It will be easier to understand if there is
actually any rcu reader in the future code reading.
