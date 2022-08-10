Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0698858F468
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 00:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiHJWa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 18:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiHJWa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 18:30:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E9C43;
        Wed, 10 Aug 2022 15:30:57 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AGuSA5003233;
        Wed, 10 Aug 2022 15:30:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ln/TxMM1PbYkM5xdEE1MijES8wOeA8H8gSyfD2Rkoww=;
 b=RvketywgHyrfYa0DjZqV+sc9UzCj8J6Sk9vXCU4iqQ0kbN0m5VFDgbLZQjj4te86fnnf
 0b5L2fhm008qz1omPJQA8EVL0keAnObMOUHgD+rn+wZVywFz29H8LtYvK5vz/oNiAnhA
 LMSuIVDvujYWTOtB8dZAMkOQT3x1dyOQZFI= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hvdb6cnjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 15:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYy+/HJLgg4pDRYpSrDk2R5itvUrfPABxBM221mWS94/cL7orLoDrMQ7RfZcJ2O2xprg7bwGlcuiAF94dsrbCQAJ+wxA7m2PLl5Bex8LKHpXnkItnCTRY8Xa6ieXIIEAlFgDg7ConMahxLsRnt6sQ5PLHb0+sprkiz1Qlm8cAtkzOMRuEdfWv8dVYEiQCLH5oTRClm2q8ejhKCRxz1wbSCoPixY1EqReLZcQ0G48ULj7wpc4mcoJfM3CReSxNmo9uXE9ihSavdZr0ol2oyId8dKcfq5UJLkY/GqvAP6akppSdeEn/ENs5GAwvh0iPtIvMzcPjHJchg5u0f15PtcT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ln/TxMM1PbYkM5xdEE1MijES8wOeA8H8gSyfD2Rkoww=;
 b=iw0TjxStmKUpBwde99n2APPBCfMQrvdO8a1ph5D/Sbm8Z0Ls+9OPMgqUfijrBTutuKIa1RcFXMvnlRWyPXZIaDeDprFnA5Sg/cEiWDxmE3UCbkpp0ZRAe6+cH6FBiHP8wUfUyZw4ZZ9hOKWP2mXkM2yIe3xurqaAnf2vdGPIwL50qmNmCpXW26hLry5hlNnnQZVau9arvFdyaTtIwQtG199I6XmRrWXiX7WZQPANNQ5pcvoWT6yp/sSvzsS8vCP1H8WFzu1WQvzk2wH4PbYzYUp1VYoNL1kkX1d107LW7zUDsbyklo85eprQTkstONbdQhAEKbwiyduP4e89gv0qYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BYAPR15MB2471.namprd15.prod.outlook.com (2603:10b6:a02:90::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 22:30:55 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5525.011; Wed, 10 Aug 2022
 22:30:55 +0000
Date:   Wed, 10 Aug 2022 15:30:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jie Meng <jmeng@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: Make SYN ACK RTO tunable by BPF programs
 with TFO
Message-ID: <20220810223051.5pg2jayrak7nk46a@kafai-mbp.dhcp.thefacebook.com>
References: <20220806000635.472853-1-jmeng@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806000635.472853-1-jmeng@fb.com>
X-ClientProxiedBy: SJ0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:a03:331::15) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e8c2a6f-17dd-4112-adeb-08da7b1ffd5b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2471:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6ie7edy4QjOxLZyS4wNW0gPIHtK7mjPa0coHOKClJRpDgz+SeD14P7MW4e5PsUB3mmunW4W05x18D2LYXbZTTrgtdcmvnXrcR/k0RdH3yFSSBuPiF56MNpU6dlv24XJwufBoJCUySmke5ZQwnxO/aDgAEYz8PAr+W9no0MY8uA/soVY1fZH7sauAH1XhIf3IYGdjiWpFmhX7byIXaHLxoGcVLybvkO5QNB1oceTKC/KcIYfx0IZO6V+wPgD0hKp3vvGMDbXKG+s6pu+QcEJ3qTHPWHOImbXpGt0SAs/S5v3zGVWTjF0IeEcld1jSOWbKtZWGhuDDlfnyRjXe4/8qgZPfwpZTVIDgN6suPiKjp+vK3beT1XWlmYJF95KGggDNNGAlME5obRMQuw4B43fdkBe2TE4VMNTI16rcT3T+uNlAZcY0WY8PSfA6zMBxJZRtUopdFvVbjxk7k8FBrDcR/53/RkN/Qpjo1R2DI1F0aXZzBSCPsX5YKG8jum/FBUUxTKik+PWjWQTpTu6Skg5qt8Tvw5kVXCaBUyGzq0povqST64I+4dA+6uHXeVuSykzcu8Ov9rzw5omNYrJjOaIDvRlPJNGZMMKkaialkZ5iIKwfRxL7XTjQ5FdlSqEA75YqXyWAWYB7M0m72nOmu16jIY4+dI7s1EusL46zagj3Fo9Wa8ietM+eLdwF4NkcneBQoIbYuzWmk6AI6mt2OaKRpjcl89xHpOpyGKmyZ2wonetfXL57ktwaF1/hM2ZabLv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(1076003)(6636002)(66556008)(66476007)(316002)(4326008)(450100002)(66946007)(8676002)(86362001)(186003)(6506007)(6486002)(41300700001)(52116002)(38100700002)(6666004)(6512007)(478600001)(9686003)(8936002)(4744005)(6862004)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BWMrRG1Y2FNsZTVH393BrOqFRf0CeIFcGVxdLEtpPxb9+VX3prWp0vdWjo7f?=
 =?us-ascii?Q?MECmtIu0oD/ao1PwX6HrcXfLF2i18UGZNY/9PCr7SrbntSc3azMZq4BKOW9V?=
 =?us-ascii?Q?muIKJL35BtndQCIBLWVkrviAWqOZDCud8SHDWOwfx7KL9fBVJGSXWd+E6v4l?=
 =?us-ascii?Q?kWn2WR6vaE7lZvYgInl3b+iblDXw6FsH80WbJ/JhDnnzmgxH5UxHOtsNQ4JJ?=
 =?us-ascii?Q?/kNxmK17fwjTsgsTHiDfhAEDBXoz1Ka8Gn1kHRjpjGVhyzFecBf3+v3XyLLV?=
 =?us-ascii?Q?eqzILI8QqFDd3VwPlIlZF6Tu74Wit/CI5pnQN9c5iPeVB09295/yjEFgUeOw?=
 =?us-ascii?Q?4TB7Jejc6ib6fyk0qXp17zhY3lEVhpMnTtC6IlMUOfh75G4n0muKhAeRYgRT?=
 =?us-ascii?Q?TpIsMEKU60V/R6v5Gs5RSrRC+DqfIUOiMguFOqlJrHLaF/Pm6n2JwqFKJsgN?=
 =?us-ascii?Q?wsTQHnq+A1lhSXM4WN1D9XBKebl3s25FTM9mO27p/IqNNfAV4sEUl9XlfGnv?=
 =?us-ascii?Q?4JNj242W5sxcnaSnSqf1wgRbdQtKRs8L0tQ8+vJMn3MmVM+SbBkt+ua7MXq9?=
 =?us-ascii?Q?hxCpAVXU0ZNm9Aafqz2fXbsXg5UBlFONAOTEpu/rVxWFHFBUnsXlnCheMW4V?=
 =?us-ascii?Q?34CJbdcoaIshUqIIYFHABKACcR0GADv0LzE6PjZNws1NL/WC5q8CVK5qz0M7?=
 =?us-ascii?Q?K8OQNxC6LsUT12f6OnXEHy17vcHBUHd8Px/0aY9pJm7RDOV9xNV6+d0FuMFZ?=
 =?us-ascii?Q?TKULts0GKbyD4gg8krOwKB3sIP2eJ8R7/6vNuthHGMlTw8US76PzGMrbm219?=
 =?us-ascii?Q?aZF2TLjSJwjx5gWo82Ntq6w8r59rEeA1J71t4DgQoReHpsxi0+uQEHCUqx7N?=
 =?us-ascii?Q?GbxhDicR/q24PteBDse+CnHXYx17J2uz29/y95tsvLiHPvNZHMCoQRykov6k?=
 =?us-ascii?Q?ZxnzLOsoD5/32pysM3goCwNxDfzdTEZKGY2ZPfmVLKaex8SVGmAq9u0wrUhw?=
 =?us-ascii?Q?ZqL+eUU3MMKJQqXuEMWS6A6yOw4c4iSdLlp3BtUX5OZO+prCNYnaMjd3zvfk?=
 =?us-ascii?Q?ncCDv7Z37hngbbFpc+Q7UqyYniqaVWStFJ6fEPWUde18C7ENa5s+Z6llF7Di?=
 =?us-ascii?Q?z9HpZCgqLlfy8Tc1gj0dZevW0AsxDerb7SJtRnFVVE6EYKgj424qdqisG+qB?=
 =?us-ascii?Q?lTkD+89m0f81tRaa7Vg3qeFCLz56TxW104GVgYXM33YAf4nUf3bK39MwzoIS?=
 =?us-ascii?Q?Cqs1qMKhxzdD3djlBYDAxuz9N3LzfjcIndgwSdEjTH3OcsxUn2Azg4Z4FcT+?=
 =?us-ascii?Q?fga8tpzys/6S/PbYzHYmqd1fyhwU6QC8p17b1i4mhJmNZDTU4NbrnyAUbObx?=
 =?us-ascii?Q?DsyiDWJj68d2FLiWNrBBBsJ9SI+K+FTaBWN5yPowIySuTLePRAJsdAjY1zUL?=
 =?us-ascii?Q?kQ9Sg2F2Dt2xM7YirFMCDFsN6vzRJOvz3qnV4zVMQWqhoC6jZEdYaVdJArOC?=
 =?us-ascii?Q?zR9BqTHLZSls802AokrWoB+sMjg/koa6mo0MpTuPDI4p4rgFpzNS5FwzqSQk?=
 =?us-ascii?Q?CdmAHLymmNtJM3t3tjC4zBB2Cxo4NZRwh5qjy2HAGBx6fkpkl+TY9cLfDYsQ?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8c2a6f-17dd-4112-adeb-08da7b1ffd5b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 22:30:55.2911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NfkldNWw8wx0ig+QcaZxvIDBAwOBipMdugtWGZmRECzls0OoGndoS02uzY6272xu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2471
X-Proofpoint-ORIG-GUID: c-TLRMDzjZKclNx6ZZXdcKnCJjBFxHpo
X-Proofpoint-GUID: c-TLRMDzjZKclNx6ZZXdcKnCJjBFxHpo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 05:06:35PM -0700, Jie Meng wrote:
> Instead of the hardcoded TCP_TIMEOUT_INIT, this diff calls tcp_timeout_init
> to initiate req->timeout like the non TFO SYN ACK case.
> 
> Tested using the following packetdrill script, on a host with a BPF
> program that sets the initial connect timeout to 10ms.
Please also cc the bpf mailing list.
