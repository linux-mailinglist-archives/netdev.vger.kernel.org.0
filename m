Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2376253C28B
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 04:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241001AbiFCBwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 21:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiFCBwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 21:52:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF5510C5;
        Thu,  2 Jun 2022 18:52:44 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2530qxuK014107;
        Thu, 2 Jun 2022 18:52:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=amFJiBSCq2W2nKB5c7h0LiN672ZzhaMya8L/bE0JjaE=;
 b=YJjAa85E7MIR//4tRNZ0ppGzEGg0TYLEGoje8Vz+vmauYC2pAKRBH6/6V87CYpBiUSIm
 dpO2OPvyXDFjsiiqGSg+J7eZirQrhIeHX/0/BeuVytk1bLzjdGTiEbKK0LLE7K5FM13y
 sKTrfwLtU7KF2TbMTd+ZvB6gdNoqThjDDBk= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge9m2ubvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 18:52:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkR07FpqbZz4LxggEnu2CW4TWYIf5sap+SXTrJNUPgyc/gnreK0jJcyWNL8QzbjXfh3k9fuCYBz/PrpyLD8f5+lmpxa0pwwizxg35gLJHXGRlBccSMWrBUnplhZgyUh7sDMgGDp64n+cwLnoZmwkgomcbHUdThAjUymwwxGJK2cX/iUwj/rdSTQnja690R+0XI7ahLi1xsjlPTJB+lCumAFmNOWlmZeqyjpcucvPQuy06fbN+ePdwaO1Sk7TEth9mAV2FSbIAsfKKfoKo7SAxBv8klEUbKfJAYVlrG/nqZ27B2iKf0KVUnqxCXEMr7N3RhAw92HkOEWMmYuj9sWWLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amFJiBSCq2W2nKB5c7h0LiN672ZzhaMya8L/bE0JjaE=;
 b=ET6cUm/I/Ub8RnVn7hAT2L+UCQIhr+cQPP6ChAYCDm13j7Io+/CI4phvV3KuUJb0jBd6sXHTNbRgle8cVkDc9llbneQGojKtZ0SQ7/e1MAxGvcovTiFDuqo74Sv3UR4Nojmvn094/5AbOMqJpb4BcWeI3d7YTXWOiSycDmZcOaOADO3549XGGxnlQ2nb8ll/Jh430cgwO8z3K+Gkd/SXyA8amPwnTaGyVWg3n96ORRHB7S67+q7lQb3z8IDsIW08Pv44M++H9pLkwHEDjpXpG0AVInfAtVSAa68/TdWODDyEKSzM8K968UIq194ri47wNlNVZGNvHN3hv9IBdB4b5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB1983.namprd15.prod.outlook.com (2603:10b6:805:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Fri, 3 Jun
 2022 01:52:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 01:52:28 +0000
Date:   Thu, 2 Jun 2022 18:52:25 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 11/11] selftests/bpf: verify lsm_cgroup
 struct sock access
Message-ID: <20220603015225.lc4q3vkmsfnkgdq2@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-12-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601190218.2494963-12-sdf@google.com>
X-ClientProxiedBy: MW4PR04CA0126.namprd04.prod.outlook.com
 (2603:10b6:303:84::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48f872fe-6b4e-4e63-25bf-08da4503b6af
X-MS-TrafficTypeDiagnostic: SN6PR1501MB1983:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB1983354D16C1B422BA812DE9D5A19@SN6PR1501MB1983.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEntr3yAd4rlt0QOI2nBZRl0ptG+6mio0zs6X3fiUVdCuoLPJUa5ZAoNWn9EMvCEYArJYmanoluz7vm3z2tnxj8xz6Y7EtVHiuL60/hTbFh621mIOhJmXsUgLN0tL8bOlU/Rjh6q4ofpPvGpEoSzPp3e8zFjWVIw3yLjOpy/+7KFa54Zvu1+Vr2yjhI+38naUafQ/OqXnsWkfdOkrpCIo1HxEGQge9PPr3CLl9g0j+Toh+GwnJbBG7OM6t8skL+KwOmOg9Tjr5BVEVQsoZMmnRqi28MkVeQ9Duz5/lsVGf9ur0RdAAGfEscWG84P8iitdRCT/aYGf6aLO21AIQi4TfNpg+V2XEjEqA8VV//KvTXjXUUJ1bGaQt8/g7TMOOMqi/tAg+ON+jx+jWkD6488g7+FZqShysainSOPVrEiep/CNUD/nQPV0SaxvKVud2318/KoaKPORPVi5LBa0+dQh2bgbJwE3MhnpFCrivUrum6G3RK2FWcJJu5+Lp4Hr4pO8pY3RhtqhBtLTS7yrkoSiSJwmCI+x7hh3zl2pF+zJwA+FxSs1IER4Q/lQ12c0J+cSEx/kBr8wWAGsCr+W/h4dvC9F4kal/S/cSwwYIw9IqZgoY4BDPraq+OMzQv8nhtKqIDNGzfDBJ8O9czxaaccPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(66476007)(66946007)(66556008)(86362001)(4326008)(38100700002)(6916009)(508600001)(1076003)(6486002)(186003)(6666004)(52116002)(316002)(9686003)(6506007)(6512007)(2906002)(5660300002)(8936002)(4744005)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bwTkBmwW3uHuFabttEGHfy7ExKbaLkjRGByqoSQ6eJeDiCxcHqvSv4q+MWcZ?=
 =?us-ascii?Q?sVK85/z4eVVyyorBLqb+8YeJRdzuY3yx8ZuxVbpWj0X+soLqKf28pgTxjjYR?=
 =?us-ascii?Q?YHOeAbhoqYf8T9kuJq/6hdYSGwCMDDpKK03DkHeVuc+5zflWysLc4ak0+L7g?=
 =?us-ascii?Q?ewfqqW+f09pW4RWdE4D+ZuaasWDnRYTQ1HBEbStplaG8fFV+838Svkmz0gQ1?=
 =?us-ascii?Q?K4sJghqepMVA5Bg6WHLKcRCpyfX4WHwyyP3Iw48ltTzTB0a1sT039e+TwbHW?=
 =?us-ascii?Q?ah98ZmwrxPD9j6FLUdQNNXr0xzcKVCL2OdbcHgsPjU3m96X8ypC1CeGvrAVv?=
 =?us-ascii?Q?Yy7ypgIJHr1G2MsQEOPip6jYD221gL9o2vH7q1URsstPRvA2y3gzWBr9i/nZ?=
 =?us-ascii?Q?5ug2Fb7YY0Lt/jsiC+nqOv2GpWGkRufK8ey79jRBFrlmJXKlHzD2EQQNZozL?=
 =?us-ascii?Q?r6zPAAPV1ebaxcExgnEvW4DkXKndjjkt7pl1YYS4DJnyX87iwu6TCyLkWDdm?=
 =?us-ascii?Q?p1BrmSiODEiKhS+OVAnGlD+7VdEzi34uYH8RWiPvJVoDPZmZoE6Gkf6msYTx?=
 =?us-ascii?Q?wQBZF2Ui9ZZeldhgiTUgEBrvfOIqToDjZpaJuEepus7bpO5wlUIRZm2tA8my?=
 =?us-ascii?Q?p/hNldoLClT9p6dWtcKAFyMRzMR9hA4yY5qx2oaLiEr1SxJsd0LbyDT6YinA?=
 =?us-ascii?Q?NCjaWXCN6eCBn4w15N4PjCEURJDMOke0+M07TbSqoJzeS+jGI+HiN27NW5ok?=
 =?us-ascii?Q?DKLGfhE+z3EaVUmMMOdRUW8PM/pApsadyoSngFKY1kZrJRGVTWmiEurxUedq?=
 =?us-ascii?Q?PYQndQh58W7QRvRH1rzp/LUDiK3aMuR4ldptzB5h0Qr9b4dYfFn7RkAw33xJ?=
 =?us-ascii?Q?sGVHY+7w3jwCqfvb+NJ9+6hAdKaCdMBzJKQc6s+8STMqb61kDSKDWgFnqnXD?=
 =?us-ascii?Q?WkNnnT0ZMv261/shixT3fqkQGsricfnlJXdvCf01ZMCH4SRX5Yfag2TpBvv0?=
 =?us-ascii?Q?epNls2z3YtqcKyTWXz6lDRAuCGbUTA+qaxfCwMYBxCBq+Mta1Uax6ghIHhp5?=
 =?us-ascii?Q?HukanEgzeAB1X9OylgX9LdEZy9yE6F0NXS7ssbiS8//DsEKISyzwPzMAia7C?=
 =?us-ascii?Q?bTyQm5biGnJ0ct0QOiglE23Gtcsa69luxqyqcnPJbeZnN8hZMuCme8LvPf+G?=
 =?us-ascii?Q?HPy5/7+QRBrKOnxWN2/nkGlVXgPxjjQRjBz0Em7TaOZ+gyofvnXQXQW6OqbD?=
 =?us-ascii?Q?ljOZlrgkjtjJ0aHq4LcCC/T7Oor27AFG3kpSCEZ7lqbFr/ijVF2r548Msgj6?=
 =?us-ascii?Q?C6a/qBKGtVIlVxLCh+Rn1Fi7CtCCrP92u8R9Okqmym9R7RvM83F5dEFXcDi6?=
 =?us-ascii?Q?pi5/chaA7sBwZ9lQgqs8V609Uiu9WzpnpVmqtlGpGEboD3prxzEKBO/6jF3y?=
 =?us-ascii?Q?VsXXD7O5Ai8Kzz88IlkA0VJ0jRmd37EqIisupNvoe3z/xlSEVc5p7KdAfM5Q?=
 =?us-ascii?Q?BFJ9/oenPgJwXb8aVSlKKvICcXbHpBE0bKzmon98BE/1NHOOdeWsNrXsPhTY?=
 =?us-ascii?Q?UXZ6pMRIgahV47+YAxOeFxcwoiORynJST/ljizcRUlLPDEC+V5zyD6heg6dv?=
 =?us-ascii?Q?G9B5NU8VX26VwdNw8B+NcooL+q3mEngoXLJnTDSHrCOyP7xn7ROlIFfhHnDK?=
 =?us-ascii?Q?AUniXgATy7iMWxJhiB3EyHvqJXZFdmE+V+/VaDwR7RnGDoobPElKlUMWk9UQ?=
 =?us-ascii?Q?/VjtSrv1gOSCfHPgW8G5P5KAZ3YlkXw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f872fe-6b4e-4e63-25bf-08da4503b6af
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 01:52:28.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSP55d7Gx/36A24vyalxKDRNXlT/4lGQHAbC+kRCesUCk5U4apgG1CnDdV0Q6LP7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB1983
X-Proofpoint-GUID: MRWfGzpLfO4nSFPoamwzmC5q6LLfQ8DB
X-Proofpoint-ORIG-GUID: MRWfGzpLfO4nSFPoamwzmC5q6LLfQ8DB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_01,2022-06-02_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:02:18PM -0700, Stanislav Fomichev wrote:
> sk_priority & sk_mark are writable, the rest is readonly.
> 
> One interesting thing here is that the verifier doesn't
> really force me to add NULL checks anywhere :-/
Are you aware if it is possible to get a NULL sk from some of the
bpf_lsm hooks ?
