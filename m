Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6724DA39C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiCOUAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbiCOUAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:00:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FC639821;
        Tue, 15 Mar 2022 12:58:56 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FHNoaB032545;
        Tue, 15 Mar 2022 12:58:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OnPmol+cgPOXP6g6B6tebMOCNU6uzExTqYYyosTyD6Q=;
 b=TBnVeBdV2aWq2fE9guyi/Fg20QSSbXJ3eIF4O9YztLkKWyJSptMG9IQvkMVSAX4rfUSb
 OkI+Y2p1mdqRt005zBEB/3hdv8t74HEMzPELzNollv9XrsBXML9DiT8mTHc8o9UN7gyQ
 M8T0jkVMgzY7JIAbbACgYN+TsqN24VDSKXk= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ety5f1663-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 12:58:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDi095IR9ZtLdb0DrmO5sMjSAuflF9sEHzDivElkJhryhqSSlZaG26xpN9OnEwib4arp4I6YtphlMwrlDmvkp30Kkmu6nbfCqsJm61T+SUo6GCKSAEgQb2K+0hYoDG0E78RRhxB4kaiYLnz/IiFP4/wHApCk7fHeVeOrwoV7tPBZ/alLOESObdp0QiOkrKkxO9kl6R4LgJZFPO9lnKUFRDVukFh9ccBKzEF2S36ADP8iV4H6hc1qvpQE4BiHHcqw227f6Wjn4+3t4puK2KglN//GIfnl9pj69Rpjfd7pfmotPXyHSa/QliXzkULCyKxI1Hx8LnyXxScwFMc+eSzLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnPmol+cgPOXP6g6B6tebMOCNU6uzExTqYYyosTyD6Q=;
 b=UmJCRH/q/rKJcjN4hY3/Uqg2X9yQo70NzXX2wki/5J7z6A20ENsFnK55Had6pTXtFlPDVcW2L2JbD0cN72FbPWjzGKFwLqKmOfJ/Nss/dRlYwWLq/cy7gGpnUek6Cq09FXqWM8q0M1TzFnf4Sab5HA91a+O97jv0gqGOZi0ROkok1yjTt8bXzUAF/zW9fYzXZsAPj6VyOsEiSO2q0EvAtk7/W1bH6SEbUToZKnXcAu7vy85vN89H1n3/rUzdq4kJKmciKXAU0P55ZH1l2u/EPme2hJp/GENS5wq2PsPQnk8FlMbkJ2ryP4XkG42JwFgg4jHnx1Sl2ynvrpsTBkXmwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CO6PR15MB4211.namprd15.prod.outlook.com (2603:10b6:5:344::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 19:58:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 19:58:28 +0000
Date:   Tue, 15 Mar 2022 12:58:22 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        sdf@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] net: Use skb->len to check the validity of the
 parameters in bpf_skb_load_bytes
Message-ID: <20220315195822.sonic5avyizrufsv@kafai-mbp.dhcp.thefacebook.com>
References: <20220315123916.110409-1-liujian56@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315123916.110409-1-liujian56@huawei.com>
X-ClientProxiedBy: CO1PR15CA0057.namprd15.prod.outlook.com
 (2603:10b6:101:1f::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c1f1176-4c0b-4625-2370-08da06be2b05
X-MS-TrafficTypeDiagnostic: CO6PR15MB4211:EE_
X-Microsoft-Antispam-PRVS: <CO6PR15MB421139A9451C2301E4B7AF4ED5109@CO6PR15MB4211.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1ZcC1N2R1w6R/lzTlu41kHH5DB1z87Q1vVsKc+zzdAQ2fME3JnT0ez9KhTGBmKNcfInJ37xCZktJrtDEi5eF1YlRaVT6Ts5HLRagBCT6Ybn8i3pgYeLbvxqjiTFmGOSaODLdjbg+BH8p2aaUxHi0fCWbaV2Cv5GkfP/Jp31fPOUARz4eIBgVDybYDHZOLIwNnr83kgnyWhRhpE8WczdSsozPmSNl2RmlcURYFX0O5elRgEwwv6fbQaIthBpm9iuvb47ZjLy9CHbb/XmMpek630+liH37jt5hAhYnqp+B4tCeS2FHQ8T7swwGH78/g3KAw4kZZgfxDiVNoJ3/dPLbcsoGonvZt3vpLbrV5boLqvb6d0iYZOob1CCR2N0xgaA0UVrveeR5adbVsTK+kBMcDrbNwS1TspGFNxvE1SdMTiefmfsay6+DKyjWSTYGCmcXkXanUFyNSZxIybtVANUcQ89Lbt/YlgfVnyyYICYerogZsHbd9qHvHvttIBtmPSFrQLhDVNrfyIGGW1cD/Udv7iJacdSyTFpzB8neoxo/znTeC01IEH8ppbi7jlthnWpRcCAXB+WMSL4S+NWzY6BdqfftvBr5aLRrwcx8GLDS3//+TjckS8ws36zF+7b0RVRhokLcQAIWQdFch6LBdGBjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(6512007)(6506007)(52116002)(6486002)(508600001)(558084003)(6666004)(38100700002)(5660300002)(7416002)(2906002)(1076003)(316002)(6916009)(86362001)(66476007)(8936002)(66556008)(8676002)(4326008)(66946007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3IRN5j2BTynUou5YIOJaTxTVvHZkehSnPWvfSTJxzsH01tnfQVR+LCxGhvmk?=
 =?us-ascii?Q?kMfnQZD34CU6yYKZrM9Ir/UlyTtx4DxjoN7xXW7dHFwXB2phPZpwIL+hYFv9?=
 =?us-ascii?Q?Td3t+ctsEpl4o8RmslXuFuK3qqLA7Bj32nc/BfgDqK7p6OpN7AxZtaIvH5i4?=
 =?us-ascii?Q?OngvR92MUOyG7PGPmt8NrFDFLfB3ypmBK1XOvK4X+RB1+oxIkpPKja+jjhiA?=
 =?us-ascii?Q?p9Yky0ifq0C7Airz2UA0yvGS3GJP80a/bS5qDWy6NWMH+RzLS+j8JFVdEJfT?=
 =?us-ascii?Q?tdK3jP7YXEqvfFgWG34iej13QuR5cYJiefNyghEnC0gFFWURobqVEiQxTXp8?=
 =?us-ascii?Q?ecphnxwCjBEQZWbdpQZF1KBGBpjRYCtoJ9/k/jWKbiqBfnLWDcTzNXl7CnWF?=
 =?us-ascii?Q?d/4euZk2ylYpBjEAVFYUIyrH8TnEAB1aDBsC0o+kAKg3jSn4P4wY8Ne73X0U?=
 =?us-ascii?Q?FEkjNjViUZb5GJhgMKGZQIxRFNI4s4Sbqf/yMznHBuFL+n0YnWYNTFVPK0uO?=
 =?us-ascii?Q?QwVxVUwNzd7sZxGq5iB9/9VaxYzInHj3P5BfHic0vXpag1QZTB1u9GrWMnQy?=
 =?us-ascii?Q?pR/ro8jvgiulvRROd4ZXIcVyiiYd218A/VUWaugjQikDK31PVyXSl2TnB8Ej?=
 =?us-ascii?Q?UBTuBGCA6S2me2odx6FdAPM0G+/F/6mE7tfW5fw1yDYHK/Z8kgCP15uPf4Kw?=
 =?us-ascii?Q?YHumBak5Mk5oNccQcSE0kYtYQThKxc0Li7mZchJZWO286VBDGeqh0mzbg5H/?=
 =?us-ascii?Q?iNL2uuhK9p4HkB3RQ9GCg53qRiYSPz09M8lhNx99YYu9ZCFksBUWeexhasiM?=
 =?us-ascii?Q?/+LrB6PKVRHDcEZrf2JD7dIMaaDHnGoLFLNH2lLBBPNuKC432GJQs5w5RrIm?=
 =?us-ascii?Q?ioYyxzIMP44i5e6kwpuerFMYKGancgidTTdjfzIqgWn6pZ2lUmp6aV3MyPJO?=
 =?us-ascii?Q?rHAEVQ4ECmG7v3Q3txhNMeS+rrgreeuPcDsa1htjGX6nIiRhNM2xUK+UGquA?=
 =?us-ascii?Q?DJklDRcpFDmU7ffHAsk1c2fAR4j3D1q3CkyS5ON6kDutBhV3nsH8zy7zmbOZ?=
 =?us-ascii?Q?iU14vvwlDnb6wlU5KIz9OdoLRaBKhfwAi3QsrdWDPPk6EiCptzn0w1qDKLQl?=
 =?us-ascii?Q?uC/nzs0ztqooVMf0kjrtREJ2Z+3YPTiKFauG0f5FVMLfcTqz4doEDXNidT90?=
 =?us-ascii?Q?ZPWQVHxT+ApGVlnNkwR7mVahJVFF+pTjsPJd7AV+6Jd9j2GFDygC7Uo64BP0?=
 =?us-ascii?Q?iRpHl5aeZHBsJJ9QT4Hu1f9/93kaJTnpiZf1CsYUBKJR4m2kfSgZYNas0XDp?=
 =?us-ascii?Q?4HCyBZtYp07HSWglnfv6khX/UCkV8OfMO3Of73IzIw+xHZYubIBlTQbADBZl?=
 =?us-ascii?Q?HGtKwemsPh1oj5L5kr+juCqrQYKOsNd8vx3B0oFYv1WOwiLsIcmPPdFQVj25?=
 =?us-ascii?Q?eo4fwayFyu2RcSpG4FzErrYcbkUJFvB9ddn7tLaSnRj9Bl1pE/uuRA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1f1176-4c0b-4625-2370-08da06be2b05
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 19:58:28.1821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGswKO9KbYaoEbiEQgWOM3jRTxvsSDjly2Q1JtEfUR+akJogMFwVthRrLDGOKmK+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4211
X-Proofpoint-GUID: FoFgzMb5HSoT5o-UJ5qdE3blRbpiGk5U
X-Proofpoint-ORIG-GUID: FoFgzMb5HSoT5o-UJ5qdE3blRbpiGk5U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_10,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 08:39:16PM +0800, Liu Jian wrote:
> The data length of skb frags + frag_list may be greater than 0xffff,
> so here use skb->len to check the validity of the parameters.
What is the use case that needs to look beyond 0xffff ?
