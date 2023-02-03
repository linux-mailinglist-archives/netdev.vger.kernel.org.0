Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A53689EFA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBCQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBCQST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:18:19 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F48A42A4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:18:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhSvxTALOa66jWg29va8Xtqf/sKQ2sLaQsQ86lKl+b+jKl365QRnSIdxdKL3OaF52YkMrQqUDKdCNd/r5/B5GQk2YiWjAhWe0FtXOFjUMbgVl3Y7S+Wbl/n3jTmHdd5MEz2QC0DRJL7nv1XmEbP2P6BN8MrR08v/R1V9HwXKbbhp9Aql0/DZWKp0VuvPWb7+QuMRtWENjv5oHldM54v7pD7Hf3pL9jGWNoCYMfion7kMzyxLq20tkPnJUHeXUlvebOk5bWKr4tKs3gBZe+H1uBq9IZjHk11nQLQ9sHCY9T9GHvO2zgiLgj2T7G6LFh27CUh5fdi6yFbPlhX/+Sk6Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghU0B/dQB6tMYIdfLJm6odxg92+xjJ5j6l+80OhyXtY=;
 b=lgjtG2ueJCepFovsAKoXQdcBlM3n8OV0v4tDHa5DmJoReqgM85bJ+2AML305nJpdzt5Ks12Zs+SIgFiwNwgXOtxxyhdhoLMuVytzQ6Whx8eTUH/4/Pq0oKYoRpGvwHA6ICVVhr8O2EE/0QMg+Iy+sxQVg4gP3pQyVaLGhVVf2PGKd5olJf9zJ3uSFGcgVYJz0IHKR4d97CqWK5WpJIaCedGU3g84Yua3qfq9hoBPp1LNbkEVkHLCVwxR6qspInq06CbTf4cs5D/CyiD8ss3nkF1D5eEorkoCwlr1KiM725tDcJdkGxfnHqODCdPsLNlBecQnXwU2ylgoFZ06TT+vjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghU0B/dQB6tMYIdfLJm6odxg92+xjJ5j6l+80OhyXtY=;
 b=qSbjIRTcQaKI+1pajujD6UL1HlZqEnNa4cF93GcHKhpGX6wSXe9CEJJhq6YNIqbCnLxv/jSQehlR0Jo4cFZlTDwKMZvUojXBBolIFjYzL8ACdRgfMSqxDmjLuBiY7q0VDWFJrtArYJaKJ8Ioqq1Kx5h+y3gDZspkly3w69rjlFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4780.namprd13.prod.outlook.com (2603:10b6:510:79::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 16:18:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 16:18:15 +0000
Date:   Fri, 3 Feb 2023 17:18:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v5 net-next 08/17] net/sched: mqprio: allow reverse
 TC:TXQ mappings
Message-ID: <Y90zwMijGCw79Ulw@corigine.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202003621.2679603-9-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM3PR07CA0115.eurprd07.prod.outlook.com
 (2603:10a6:207:7::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: c5476370-4bf9-4519-0209-08db060240b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwJWHATkIIg22GH3jeoHn3OLY3zIkjT7ghsHj+vTBf5rCPm3klxM8HSvJwflxPPyzOz2knYpnOVvzBpOvHQoofr50GQrBlXxONdXGfOmS3BHDo3wVRtkgLT4Tw6rTSLbvD2slEaEuSitv7Br4Y3PYKHO5g1z3OaZ9W8m+isIhsLGHOOJPdmJoVmYiLvOkGzVKNeE/GfYgZnq+kS1dhdrrfAGM7UCUB7oM/i0zzFMCeZ4xAqYvMCa3ElQfyItnVjr6BG2c0EtR8bAC/Bolx49cmExdseR1VOAx1Ej/rgu5SQ5HwV37Z9AaH1MK9O8bcjUgSMVo+jNLWh08wULYqno8sMs14QMOWuJyPWzlmwyT0ATRhIhIGxO7+Az64OOCncBzBNyOc6BrVUk0Zy4rzu5GFp08XsgdoRvPdj2lCMCtrt5oMgkNlKghtcPsvXEx1b0KxP7THq7+FNX2q22fwTQy1uEbnx13GL7eXTDAJRQfloBFu7HPx4yl7lq4/Ccc1ZH/uEIxIK7KwHLnK9L8Bj0S6VtNEt1UwcROXfOQcwayTUGoz4AjxcN2X7O6Ks8bVoPgKck4nCa41OHFwLjYAzyI6gtMT7FXseQX+W5tu5nz9OVR3YVk4sgOZGU7pAXewpLFgcM7ntstpYxFVrnBnK8Cen5oquFqKAqnxRlEpir+0uW0BcEre0iz908b+O6kuOW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39840400004)(136003)(366004)(451199018)(2616005)(83380400001)(38100700002)(8676002)(66946007)(6916009)(44832011)(66476007)(8936002)(66556008)(41300700001)(7416002)(5660300002)(86362001)(2906002)(4326008)(478600001)(6486002)(6506007)(966005)(54906003)(6666004)(316002)(186003)(36756003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZuRYDQSFz3Jm/8bjSE+XzQSzataMRa/CuybZyGwuRzoGmpMgOZqTVO4QIK3?=
 =?us-ascii?Q?9Y040MxX8atxsgbIoQFgVcs9PlI2Owf+NpKMbvCTYQPSEfpgesonGU95i/Ne?=
 =?us-ascii?Q?w38GxydXKrHoZE5QYamAFqh7AsciMyfDRMv30+VJSad1QR4SVIRFBFi1+g5C?=
 =?us-ascii?Q?zBpGBZiOjOa+/1IDiPEfoBO+hxyjwimwlWs+MAT4HI1bj3FxUcDrsrX4jvrC?=
 =?us-ascii?Q?ChCqcGvlIuF2AIgybvGAXA1GMmkwYPxkheKwOl1iYm0X1yCA0cjILVDtubn2?=
 =?us-ascii?Q?3yUlltVaL6eieBUoMBqLUy88QlZlU6snr/P4AVgV/UqHns7/aG4lIdaPRQqw?=
 =?us-ascii?Q?FhzlHabckEGpYRl1C7dRg6skCEnbxy5hA4an1S4mHRvEyM6MPEOCHQQne3aa?=
 =?us-ascii?Q?D+99fBDQYbwb/xZcZeFdsWd493LIDLeyCr0OLco7LzwWCNu+t/U4YopTc4N9?=
 =?us-ascii?Q?SpcbJw6iH24KSsf/QzXNlXKlk8uEJys69FUH0SHN71yMOZS8KMFs1c4nPhD9?=
 =?us-ascii?Q?jXP3W7pFZ7G8+im5+vXFmKSXJJ4xugl0Q1Wo0jIPFkX/r96btXE+z0/G2nqW?=
 =?us-ascii?Q?v3qsJut99woDQYFMe+O5yD1cSXBYUIaI15QkFcpC85bAnn7+pKvB7NjvYS8y?=
 =?us-ascii?Q?kAxeLMt9YHKiTjHYywRnOrR4/eXjwFjgbAal8+QF+K7mbghw/Bl3C6Ig7h3H?=
 =?us-ascii?Q?2rY/Hh+HAu9NGvfZ75QO2wCPFNKOe9g91oy3b6YoMx0sQ+LNujEF6AZNFR+A?=
 =?us-ascii?Q?ibAgDzg42boGqzkrNZbCrkjmm/Jf/qbK/95pQkZRarCXTiPZ3MC5aTjBYI2+?=
 =?us-ascii?Q?vlQ0sKalRnCk6eavL1JaD8bq805LupZ9+NnmGECJ/ut26oW3w8S9xz7Lt8+K?=
 =?us-ascii?Q?lsLZN8ZCbFPzBoDteBZ9trbFDsYloWxrYaEpIVvThn7umxIupRU/8z9Qxywn?=
 =?us-ascii?Q?YFdMikfeF9P2cCFevEtwrz330w4TFMUMUyQ28DzqtjCtNlZ2q0OKQZJJ5ZHi?=
 =?us-ascii?Q?NNAWDaV3ikcY/bestFr/Kao0nnQE3TnH2mBt5ruAeXtoZMqKRIs7kXlrEl4z?=
 =?us-ascii?Q?UWZu2yb2Bnt5qgAomINE8Kq6deeFrs4DwzjCz6cZqZUecONYd4SuMteeRXzG?=
 =?us-ascii?Q?qzjxatwBDRt1ZL3U5mQwy5ggz6S+7MgPQgg1kLq78gxqW7wlTrZKx81ZBv/Z?=
 =?us-ascii?Q?sJUO7Nf76gZ4bLlvKMbnWaElEfTW8L5W7ubU3WXdXjGD34BW8nP+vLPl7Eud?=
 =?us-ascii?Q?6WSUomYutit9OuAPt5WdxN7ZZrmSfrxd4jO+ivWsdD3QxsSL1mw7W/JRhqgd?=
 =?us-ascii?Q?Z3nNoCvg6BYRauclMh0Nxl+BGFH+2g2nF/bIsln4z42R6hZYz/l2fwVKhExR?=
 =?us-ascii?Q?71SszZQBYrx3/WZ9woaTCrA1NqfSralC+gNjlE95sctzi3DU3p2hNrTkgzqm?=
 =?us-ascii?Q?GAuTK4GX4d0FUtR2AxQsvd+abDQo0ujGD3yS1Ud7A9KEhrNVMpGIlbfnJ7iL?=
 =?us-ascii?Q?bJgxjIRhIBJ+qPE5qIe/ZDPO3tQjTaJMVXaVhW5sTb6QhIALzMP8Bi1fIj98?=
 =?us-ascii?Q?WYx3yXBjy3Jp8RnAkno4vjg8hhgmnDZcbGW+f3ubvxqL+GEDKH/9l/SpEIlw?=
 =?us-ascii?Q?05VoNgEzEcUFAYjhGKo5hpmKDw1I9uBCYUGqfLwu74CpVXT48c37R6rdcJYA?=
 =?us-ascii?Q?J/cVdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5476370-4bf9-4519-0209-08db060240b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 16:18:15.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hp6tHpaiXoTCm4Hf/VbTYAXXVeqOOc8fJw6ZbVujOxCKIP8N5tI27twzPF+0V4628Qo9wE/qXAiDl1OcAzVdcu1t06AsHCeip1Fko9Li5Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4780
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 02:36:12AM +0200, Vladimir Oltean wrote:
> By imposing that the last TXQ of TC i is smaller than the first TXQ of
> any TC j (j := i+1 .. n), mqprio imposes a strict ordering condition for
> the TXQ indices (they must increase as TCs increase).
> 
> Claudiu points out that the complexity of the TXQ count validation is
> too high for this logic, i.e. instead of iterating over j, it is
> sufficient that the TXQ indices of TC i and i + 1 are ordered, and that
> will eventually ensure global ordering.
> 
> This is true, however it doesn't appear to me that is what the code
> really intended to do. Instead, based on the comments, it just wanted to
> check for overlaps (and this isn't how one does that).
> 
> So the following mqprio configuration, which I had recommended to
> Vinicius more than once for igb/igc (to account for the fact that on
> this hardware, lower numbered TXQs have higher dequeue priority than
> higher ones):
> 
> num_tc 4 map 0 1 2 3 queues 1@3 1@2 1@1 1@0
> 
> is in fact denied today by mqprio.
> 
> The full story is that in fact, it's only denied with "hw 0"; if
> hardware offloading is requested, mqprio defers TXQ range overlap
> validation to the device driver (a strange decision in itself).
> 
> This is most certainly a bug, but it's not one that has any merit for
> being fixed on "stable" as far as I can tell. This is because mqprio
> always rejected a configuration which was in fact valid, and this has
> shaped the way in which mqprio configuration scripts got built for
> various hardware (see igb/igc in the link below). Therefore, one could
> consider it to be merely an improvement for mqprio to allow reverse
> TC:TXQ mappings.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230130173145.475943-9-vladimir.oltean@nxp.com/#25188310
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230128010719.2182346-6-vladimir.oltean@nxp.com/#25186442
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

