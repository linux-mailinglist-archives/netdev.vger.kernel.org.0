Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07FB5123C3
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiD0UVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiD0UVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:21:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891F0852D8;
        Wed, 27 Apr 2022 13:17:55 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RHdqxa018368;
        Wed, 27 Apr 2022 13:17:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=optGV22dfI9gi+cqGeYU2IxRWBJibpZ6MnE9kWArX7k=;
 b=q+wt8YzS76vPaUebI/aa4yPmmcR91SD4jZFHEyA4ilxTHKCYuTcbP//wfDghDPOOeuC1
 d3EWW/kviA3XLK47jXOV+1E8yrHP5rC62anjZ11l4NKk5+i1ZshoiBm6QeRMgDd8G5IA
 s4UBAQ49tluI6EifonJFLC9gC/trENhkWWk= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprsrqabb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 13:17:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+YOHNGdiSyofm9t7yJO5Hy/2hu67pIbb7g2xpHsEW5ke1pJOeJRNolUb/07cWicH533YE9iPlSDrkZxBtAkuKJ2cV25pbITEHe6WGdGU84iZdKIZWrTmCs+2FKDhit5oK3I2t/W8h1jssmG+ODYZqB02Zf61GX/fe0c1qvxKRXpH01MlvaWBHgNj0Oh/H1m0epMfnITpfAuwxhIGbpbK+o1br328dkxcaJL7jKX7MlO0JV8WKv57S+AOr0Y/6KVPtzPVxXqFgdbqP0XLpxAMsZ7x6eLW7e3XlGWMorNJ0S07o7ff15ZnQHpU9pqiy1uZtLrO9yLNLGxRz2H2Z4Fgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=optGV22dfI9gi+cqGeYU2IxRWBJibpZ6MnE9kWArX7k=;
 b=P4lcybggvnNObMy2zCaAMfdVMPRgPyGwbYqIYYAU9KiewkBHM3+xRuwM2r/2sCL+Eq6fCcajOcsAGOAnxo1jQoCT6iXdx0sB4PSjRhsVFk7ZajhsiFP3QaMrvNkvIng6V55MnLNnMh1s0t/4MZ2LvE+4CoOg5dN5L4SATcDbQDJxxhH5/RkZ8pmUmC2U56FwIfIS93kPiaY7cf+Z0TdwC0JGWAZ562TCgUw3fOvdPcjrPAFNoiMVLR0xA5kvtJ8lV1XC2grBYePXEjTfmFy2nbVgKfZlOImm5ehHmYt/Z9V7SHpuqvNnd0O3P1Y/LOZWckPODzfRIp08dMTeNNplGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MN2PR15MB4797.namprd15.prod.outlook.com (2603:10b6:208:182::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 20:17:38 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::5957:962f:677a:b4a8]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::5957:962f:677a:b4a8%6]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 20:17:38 +0000
Date:   Wed, 27 Apr 2022 13:17:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v5 3/8] bpf: per-cgroup lsm flavor
Message-ID: <20220427201735.ouou5ain725buuow@kafai-mbp.dhcp.thefacebook.com>
References: <20220419190053.3395240-1-sdf@google.com>
 <20220419190053.3395240-4-sdf@google.com>
 <20220427001006.dr5dl5mocufskmvv@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsB2Y5+5AhA0Unew77uxCGdNfF3f9DWdEoyp0HwCrWQZg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsB2Y5+5AhA0Unew77uxCGdNfF3f9DWdEoyp0HwCrWQZg@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:303:8e::8) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b19050e-84fb-49ed-11a4-08da288af958
X-MS-TrafficTypeDiagnostic: MN2PR15MB4797:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB47973D5992F87384BDC05898D5FA9@MN2PR15MB4797.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpA6sC9WpWvDNt7750+wdQw7XqL1a4psZmJl/0iI+euLGWwbbzLROQXExiraZpIn+aNP+T8L7MTgSlBOx3CSQHTAEU5KaJFVU3rfYJtM8xG8ry/1JvQUXBor9wxUZ0piM4kgZPEtjHPl9evWC0eX7fQm2Ks0Giv5KH/yaE7ILlUK/XWOMBsVdh2ivh1NLlc4XJzO3ssGaKjqDN9DX9h1RFkTGlb6+kU4QQ5oL5zDWWQyCiXbZWtt7jKuRZeKxp6sp47J+acSdkCNre+a1NXSPSiE0HNwqEjVMGnaQj4Eb7kMEPz+MqSs5mnkm4Ow8/FE9LtdJJjZjNiFvcdwMQQvUwZ1SeDxHbvXiwTWZFyPvvDIeCRT5WtO9Be9EmyK55TA2RA7Qgb9onT9FXRfoHjQDtyPc1Zfrr7na2N8+CyUT8p6ZzUQ5b+925jBxV3i/yztqAv2th75dVPtWbtTWIDbILl5FokS+KOJnI1QzjPUrkOkxiJLTK3XDtDJE8z72+FrIKt824umivPQZ4YQ0GcFA7/rAPY0TNzmDLa5Jp4z2eJ1hJRx26bzEtBIbEQmT6OwM446Nw+aIry3OChL1dDwvaA02XAEjTI+mAWieQIUb7OvBQrz7a+u7bUBVeckyFzdCDOmgslDWQtK+Cck5XyoUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(316002)(5660300002)(1076003)(8936002)(186003)(38100700002)(6666004)(6506007)(6486002)(52116002)(66476007)(66556008)(9686003)(6512007)(6916009)(8676002)(4326008)(86362001)(66946007)(83380400001)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dyJQ/6K1bNJuftAbM6/udvzA6S3arBnpfVbmd+G+DDRuN3iDZoiyC688HZXa?=
 =?us-ascii?Q?6x4JQFu5wUgc66YL8udJFIRpA6eL9mMbPkD88hQ2o5FmFMJcI8ikLtSLh9Wv?=
 =?us-ascii?Q?ph+edoqGGh4jPoLBF+iZzkZGjtSfoApCOOTvLXXqly4m4Nykzlwou521vh+T?=
 =?us-ascii?Q?+vKghf98La5xyKv8tgDsOnsCwpc5O0fJ3pcnJ5dPbAHZwmSuKLRMlXSnLblk?=
 =?us-ascii?Q?M8rodLswfH7wGqKXbt1dR8seTlnLE7HJ/cRI1h0/9oVI6yA3CPN/nLqO0w9Y?=
 =?us-ascii?Q?GG+w7YPstBlKpbBuWx6aNk4Y3moNbT8IjVvxzdbgRSAfW/ZMiL016IX9B7/W?=
 =?us-ascii?Q?v/5Lx21wZaImskhlTBZIX6/Xs5+9zMX50bXDSs9MfRjopGi5u5rbtrPxf3a+?=
 =?us-ascii?Q?Ul1HSALk6P6zuKRwDocQmwTqO6/pyPi7IvzUrdHuRiNdchKZNMCgFo3XbK9W?=
 =?us-ascii?Q?8k3YjyF6TIQXcwMeVZjeXKdWx5YEFYcSTW+7YANkJM2/+0sWVat7m2Z9GNJg?=
 =?us-ascii?Q?hAJpYMHqmYxj1kMIg0/q7EzC8ZAqCGKowaufbP4pZ5kfa2s90JlDVWH+nh/g?=
 =?us-ascii?Q?sFvVgJSlyGxwlH2FTJKtjYyxVz+gqwn8kqosxWFx5GUhicD4rT4SNxNKaPGN?=
 =?us-ascii?Q?+koWdmSXl0ro7Y+hiM746Iywvc4MBmyAbAwY/iXJ7UH9I3sHU7Yi7E7bP7NG?=
 =?us-ascii?Q?AOVn15YngufDhcssfLkjOy8NdrZXy/UTk1TuSw7BOy75FjvYKI2D5670GUDW?=
 =?us-ascii?Q?oN37pi6FL1TuqWEX1r6Ve0bkuJt9lnKcy+F16Q8tuXXpqpVGkYcbOld15hcq?=
 =?us-ascii?Q?wo31XasG3oo6RKZ8I3i1dHgdlMv8+aIKOrEVeFycWTEtmF65ZjpSKPp0lfSv?=
 =?us-ascii?Q?PRs1U639kdRAAFBr/sP0e6SsDUWWVcr3b/BJRpal5qoYTDU9idEtltZzRHAF?=
 =?us-ascii?Q?EA74BpgoXP1aGntRrkbwkAtDy1QHm/c+Ifc9o79KNFzV1R6tklrmEBLXk/mn?=
 =?us-ascii?Q?tjjMp3+RLP6fEDblEPivqFtwAqu4UOyNSaApAtmMbIYDXpMtFazSPjyM2tKZ?=
 =?us-ascii?Q?DVjOb/WlPoSGro1V30F14AV+wBGtDJl/gHW/Hb85MWtEyxczWwC57o3iRXLH?=
 =?us-ascii?Q?x2Kgscll/hkHFKl8KewjxMMI20xlMfKS5EJ6eSu7gBvOrORHfnglBFXbUrw2?=
 =?us-ascii?Q?oSNmAm9Ig58alAgwPpS0O5s+nCaXNVC+DJRMprmZg/Zug8JW/bg9gToQ0Z//?=
 =?us-ascii?Q?IZiy43mZQtt+4cj2fOMW+XXZU0QRvu4xfjAuRcH8ihBMHUvLI/8mhEj9ZiJR?=
 =?us-ascii?Q?wx7pPNeZMolxhU0VfDsTeOa+2CxFn+McONGG0u1vQjNFq8vyeJpnlX5WZl5q?=
 =?us-ascii?Q?hDv7myS2QcMhEEuikB6bSLwWj7Pf5R+qP968mc9dxXvisVGxHgLckh47Zwqz?=
 =?us-ascii?Q?+fWTrgOeDtHKlZvHa/kzIrMw9Qet8gDJF9nNth3J8DdlhMXnBa5hGzc0cUpu?=
 =?us-ascii?Q?jvZPRc/06tENLxpzwCr2SMuOps6D15k4cYGHfBb3tRJaoP892YxxH5qrvt/u?=
 =?us-ascii?Q?OX11WKrhHCvKC+RMfBXmCx9ULNhGcXQWlWfRc2XTKjMtZ5aCc7fVEYC2GJR8?=
 =?us-ascii?Q?R+eewkGB0/W/E10KWuiUPGP6sE9OYd+Ee9jceiSBCcjkMcbGR4bZziChwheG?=
 =?us-ascii?Q?E+8jHsjgE72w5O4wcwQU2W7sa/GOs3ltpeeYk5JP+zpo1vOrXU9rZsloPk4I?=
 =?us-ascii?Q?YDLwZ14wjT/ArMg7GNDW1/j5yfQPWvg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b19050e-84fb-49ed-11a4-08da288af958
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 20:17:38.3054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y165zKg8+WJO2iSDfOPtvD6SbVZPSL9LXhBQrnRLiY3tlG3Szpc4dYDrxctYiLsv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB4797
X-Proofpoint-ORIG-GUID: rrJ-kSmDDsnRa5s4JuYR0ZIKnIHiS6GX
X-Proofpoint-GUID: rrJ-kSmDDsnRa5s4JuYR0ZIKnIHiS6GX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 10:47:48AM -0700, Stanislav Fomichev wrote:
> Regarding cgroup_id+attach_type key of local storage: maybe prohibit
> that mode for BPF_LSM_CGROUP ? We have two modes: (1) keyed by
> cgroup_id+attach_type and (2) keyed by cgroup_id only (and might be
> shared across attach_types). The first one never made much sense to
> me; the second one behaves exactly like the rest of local storages
> (file/sk/etc). WDYT? (we can enable (1) if we ever decide that it's
> needed)
Ah right, cgroup local_storage has already allowed keys in different
granularity and is using key_size to decide which part of
the bpf_cgroup_storage_key should be used.

In that case, may be just allow (1) and (2) now to avoid a new
inconsistent usage surprise with other existing cgroup's prog type.
In the future, if a more granular cgroup local_storage is needed,
the attach_btf_id can be added to 'struct bpf_cgroup_storage_key'.
The existing non BPF_LSM_CGROUP prog will always have attach_btf_id 0.
Would that work?

One caveat though, sizeof(bpf_cgroup_storage_key) is 16 now with
4 bytes padding at the end, so the future __u32 attach_btf_id may
not be able to use the padding in order to get a different size.
I think it is minor and should be ok.

