Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38DA558B56
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiFWWls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiFWWlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:41:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A1F517F3;
        Thu, 23 Jun 2022 15:41:46 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25NK2rmO000461;
        Thu, 23 Jun 2022 15:41:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9V/JM+PGEJiS42kDihw9U1LizRYIS+C5WJyqVwHXmw0=;
 b=p5Z5WVotf8pOocwYLypuJiJIo5MJCTrdIPmUG/FfeaLzsX5+rNE00Di3jaZElEkLiGJQ
 cf/VVbpZFUV/7w8UZwhwckbjXs0ddX8dDx49m4xyFOMzaf07xN18g5gEzn2cMb9ERjvj
 y570w2sGimmRBXPxwlw2Yf7pgUDLUbMTQIM= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gvqwxkx8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:41:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBu/XjIzx876V2kGDMCsN1QfeHMuCFtZ56XyNcwqjhfbyAto2p+YXjXSU5R/Zg+I6+BIsmA++D2nWvtTjUdvKzRx/Pfq4lQmhPjOskyuxozYa7czfOc4gowTiJgcwWdfl3WCboyk3oXM8Fw24ni2dQIEpWS26pgFtR4ifitTqjvkH6GvvhcewyOKJdhspRJiL0VWtG6Huw1R8eW8DWg+bIESrzJTNvy14NeNBjfKFpPsQWcQ4d5/MIdxGFy+iHFdSyomNg6CGicraKdMEg61kiBaYmPITT3F/kTjjk6Cj6L2BqwD4QDwfpdE4S4vzV155Q7BhmlVo4UpKI0sMiUJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9V/JM+PGEJiS42kDihw9U1LizRYIS+C5WJyqVwHXmw0=;
 b=Rj5ctcQLGb+6tMn3MY9B1WlOGsWNWI2oHJRj90hHpFkkeEuoF3ujiyICWFdk8bpUKyOdjrG21XSrNXHRZsXJNbJhn1RSOMFOxE58miKqE0rAoZGhSoD8a+ymku28ajVBClxOoIrBrCKaiW5++HyvIZyAFvRmRMNYs5KECGOQHfR2j2v95LHFaBEKzjeeUf93vlRXOovP2eUKZ+Yfb5y399cc0lh+Q/mBjO6Q18heXks95q+muny70OfY0f2h7y/YEOz03eXXia0QQ38LC0bXvTVvzP07XpX786UZllApVOl5GCqiXW4snc4QqVQYs/EbiAfbw1YDGSWEkFAc+XkYHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by CO1PR15MB4827.namprd15.prod.outlook.com (2603:10b6:303:fe::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Thu, 23 Jun
 2022 22:41:30 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:41:30 +0000
Date:   Thu, 23 Jun 2022 15:41:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 04/11] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220623224128.id7akccvefjo7kre@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-5-sdf@google.com>
X-ClientProxiedBy: BYAPR01CA0024.prod.exchangelabs.com (2603:10b6:a02:80::37)
 To MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9f88c7d-6e93-4e75-4dc9-08da55698429
X-MS-TrafficTypeDiagnostic: CO1PR15MB4827:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGI3rI4dGuVobZlExqC18JZRe3m72NqfJkNGsS9Y70aK/J2kw2twuIYKgmrBvDlc2nM3GHnerMlLif5OFoMBlYHaKRl5sTvNTh0AvE1UneJxO4Ex+Ra5iJiRzd3bBLk4j7S81jT7m3gK67A3BGAlpH+aJMuGcEMVDJ2dncKGsrDRbKVW8QoidBZvbL+GxQPti0t2gYQ4H0XjxZZJT/jlPNVcppbiT78slJq1t64KRTfzJSJm9ZOkFW1xnzWH9K7a2x3M1eAQZG/bbRTsh2AB4CLNLSlusZO8ZVsKix8V+Y7+CZ55Z/jHzgrcE79z5VmKMtxi4JLNxYc7OqrFc3iNTLxQyx3dhUCx9jnoid90WgeHjEutvMAW+QvnmgutJeaZm+DR2QajjHov1CgNN/IM6J1fkXloF7yGYDG9D4GFQEV6y8Pi0i7IO7vY4euWFnUC3X+fw214ReYXDXbbrmzxtx6FGz2Yqg6bUBEh7kI6z3m3mt+1zLP0yNbUr0h3Jh3G3eavS2eDUJxSmmc6THkj8u0Ru/RIx3H5LkaX/OQFt/E6vCV2XjaO3DPMjgGksjWgRhnF5F791wVgOTlQyggnVqBTvZj7Oisl2xHBMDy/zks/5v8h5PaTveedEydCqqPz8ACP4vV5hvZphGdW9PfQDT9wpBGwpgL1EMp7OqR4MZV4k9gYxOiqT+VsSghsv9EVJboXRWYL0jNCuKbraDS+/jNi/R0nW0p1uUxyRGe9Kt10LttA5EHSzcWvjHx85VtH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(346002)(396003)(136003)(366004)(376002)(9686003)(4326008)(41300700001)(1076003)(33716001)(66946007)(6916009)(6512007)(5660300002)(6486002)(66476007)(66556008)(8676002)(478600001)(8936002)(186003)(316002)(38100700002)(52116002)(6506007)(2906002)(86362001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t1b5+emdGhzzj51jAItPNrrCANkdBa2gmQTlehM4i4PwHD3dAWYXXpxBwCKu?=
 =?us-ascii?Q?LvTpDGkkXOFOVcJA/ZYlN9coaiXworwe+gl15+S+DeL3r+0anx3txpZ6jgmZ?=
 =?us-ascii?Q?vlVlT/1eU3feVXMWCZn2gWzb0G/P9j8fT9ytJ03R+6lZAzrYlf4vPS3HD7bf?=
 =?us-ascii?Q?yvCL40+boNa4QJ5gRl9BfcNqKL3Tgh0b5Kn+F1DfzWr7WohoAlWKSDrRoQjL?=
 =?us-ascii?Q?xR3/FlJGCtRqPitzbTUO4xKMplY1hEdfF0p309M5AEvocB3Lo2+/4j5adC4q?=
 =?us-ascii?Q?kuysSrYkOAR3/NuaFda/IiX6yoaLcBNHiTLJiR+/JOja193DlmOztRyfl6Nn?=
 =?us-ascii?Q?nsmSK7o9XD4915pa9xwvIb5EAhaDkIR4nsJzzlyRRC9X/u9ud/0fe5jtRKJt?=
 =?us-ascii?Q?NshaVMupWlpVYVSkCJvdWZzz5yFIQtZh+bbQMY0U3h0M78qJl8Sky9bMgpQO?=
 =?us-ascii?Q?dSRi7urrhEBX63bWpOOgIeI+fbRQphxHP/tsgSuekj/6EbHa5TEPU8Cg+eC5?=
 =?us-ascii?Q?yk+x7AN5A3tEe/D/HmKXSFQIQtzKsdSffTxsx1QjPIiZvkQMd9DJPl1aLt1d?=
 =?us-ascii?Q?1hab3q72PX3GWPeJq1x3b1nmFOlvGaG86KX813Os6oTC2TqKdKESFu3/ErxZ?=
 =?us-ascii?Q?l+6/i4vQEJf67acSVVEr49T17ETDCOHPuXMzh7w0YOex9CCdZsRE/coSEDH/?=
 =?us-ascii?Q?pTty9uWg3Z9OJngocUf1q3WmW1mqurZSduP4byBJqTmQo838Mrn6XfdwjpJW?=
 =?us-ascii?Q?bULTYhtmJyp2eJUJNMvU2zw2r/2H99TeNvOd7SR2Gy82KqVKzs2nGNQIYfVO?=
 =?us-ascii?Q?1pgeO/82nxlewlwvt+R4MLdaytwDyUfFfXZhgCwPfctySPAGpNzaoOBxoeIz?=
 =?us-ascii?Q?Ej6IxhZvIUPN4gUwFZ195jPcPzmaAHwdA3AmxEXsAWyHk6KQKdec8oz4D+t7?=
 =?us-ascii?Q?9j8VPnhXxlvMrwXFxpNdsxY5J3IC9tCh2OsN2HQ0sNq/Mb1aISV891njUh4K?=
 =?us-ascii?Q?DnCteolFDJUhhhM/fgx7XtuVZDELMPm5EvtMGZgep7nj7jbleWmd4l9fGlFT?=
 =?us-ascii?Q?MC0YLAPFdnMlGJFmOpLD5QjI6vtynzNWSeIUN8DLn9TJNkrbErwfvD1vwF3L?=
 =?us-ascii?Q?kdKMInwxyRiM5yrvYLHTtUlvJa5MP9QKIfUrTpQhIi/RXvSLXNxXTyucHItV?=
 =?us-ascii?Q?bmBjG7cdFwrO7evM4d53ROtA2tAgs6oJPauwNlTahR7w2NpvdcjRLCTsCmFu?=
 =?us-ascii?Q?OuA/11ZxZCcEP0ykNgudERM2HbeoeaPfEyYcY9F4pW0v3p71kl2LeyWJBP0I?=
 =?us-ascii?Q?MsnTxE06J8pqz6qQewvGpTwr0dREQM7urYbEL0GduSfCHRy2cYrQL7lKagUe?=
 =?us-ascii?Q?2xt7TsF6WB/7FQbaxi7L1NhH1iYppdmGp691G0mbLg9yMddZ3N77uZU9UuQH?=
 =?us-ascii?Q?iZX1Sa4U6AFvVFdB+Rjyd4EQSn3haCiL7z581bCHYQUOBnZIeKy/1WfqgZ0I?=
 =?us-ascii?Q?NxMRlzn0/Ay6Os/IzhWIe/Lm1WIWQOCuIH05CDZHXd/yej6P81V4EqSowVqk?=
 =?us-ascii?Q?LMDf27YcELCQjFV0sFd9Uo1drdI1tXVIAnHM/Q+avjjcBfJknyzC/+FoGwz5?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f88c7d-6e93-4e75-4dc9-08da55698429
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:41:30.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OO0zSNMnGjw95ck3QMKwm8NTurG2JLNY0Pu4Tr2GY5CrksbYRaDQ8cPzG1jOcHau
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4827
X-Proofpoint-ORIG-GUID: q90zeDrlbF490u0SLoBAaQl3hi-ncNVV
X-Proofpoint-GUID: q90zeDrlbF490u0SLoBAaQl3hi-ncNVV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_11,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 09:03:39AM -0700, Stanislav Fomichev wrote:
> Previous patch adds 1:1 mapping between all 211 LSM hooks
> and bpf_cgroup program array. Instead of reserving a slot per
> possible hook, reserve 10 slots per cgroup for lsm programs.
> Those slots are dynamically allocated on demand and reclaimed.
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
