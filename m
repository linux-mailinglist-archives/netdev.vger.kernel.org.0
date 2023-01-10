Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4D6663AA4
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbjAJIL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbjAJILT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:11:19 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A89AE4C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:11:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xin9cZPKntVmrOmVgxp33pPbRvXu33zCzsOIFz6UmnutekWwmgW0yVrL61usdAL4kzzywPPNND/DVvvXBPYjF2Ro83HpKWtZd+hC8bH9zV8wpP3NnMHjReY3C6Ya1YaxsqWmVv3Yul5l/e9uXWqK9ze2iYW4TPo5H+czUlKpjUR2S14jixStydHL4viKchzlj1kD05XJrmyAo60qbGW/jCaG4dOwKN/dhZ1AdZSVDs/PoFBbbIp3aorDGE7XviP2gsVLga7NMFuGt0ksQnKOwcdoq6D9y2Efr/GbdPdWQUwxjhp5D3jSCmD5YiVS7u+QWpXsA/7gJ7SM+abeQJdXfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8t46y4WFy62McIROAvgT6nIzPzAGqsVUx965XLaY0Jw=;
 b=ht1MLrBmElfyH+qLU8Xgkjbgm8Uh0zzEIb7A/42LghDzqvYuxM4+OVlN7OdjozMsjKISFSuu69lwx0MIcxPRUhgDUNrcL7/AY6J8m08z7nOT99M18TBAH/AuLBPM2te1V0I16iTtD/TJdrmPJdpFcnTzNI1zyqPEhbqFflCUb3KK8ibFwj7/9W8VfEMhvZsQU57fbYm4IbshOTsEcSIjTgyNyN3Pe6K12341yO1UBSbAJB10sHMpfm8xLiAm3JBfpYiTFYuUbMuBkyLHiEjf/CD/gu/GkHCLvoFUR5/LEDMUxZtFO+BTOa2riwmfRGQVDrhDp7F/9zs7NqcRJc1MCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8t46y4WFy62McIROAvgT6nIzPzAGqsVUx965XLaY0Jw=;
 b=ZWp+MaaLqyIglRDTQeGy7YA17RHv+QTi4ic6iWZjpzr/fAAY4xPzgifSg8uuFprEGq6iaaKsFvC8EdxUFSiu4NAfltmfGQjSNhWuH7BUWDgn6cRPQCB49PVPbEw1s0QpzAEYv7SWnev/0GnJyvLESrizhnoviaB1tpTWoeugAG/Hr5YPXwyhPWz1PZCHH19fSLS/V8ycghoTgMbUuvepG8TbRno9U7kkgW1DknaF0Rw5MmtGincXNPKpnzyhc5af5NGwkynGLvacd5WrHRz2s4KYNxtFA6tJ9YTngplE+AcbKMy9mNkQccG5zjIkXGjPQZ+KMLWwVUbgGGhL8N22iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL3PR12MB6548.namprd12.prod.outlook.com (2603:10b6:208:38f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 08:11:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 08:11:02 +0000
Date:   Tue, 10 Jan 2023 10:10:55 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 03/11] devlink: remove linecard reference
 counting
Message-ID: <Y70dj+4CszKzCSBp@shredder>
References: <20230109183120.649825-1-jiri@resnulli.us>
 <20230109183120.649825-4-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109183120.649825-4-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR07CA0180.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL3PR12MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e850e51-256a-4dea-e0fe-08daf2e236db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDKEAQLhvDL4ciVY9PrYsylNlRr6gwY1lhlTfahNjWoWgOpsHbQebVp3pN4o8CyHj5ff4d09Zf/P9gS04AXceKYPqLTgOcI6BpAQunVAr22tsiOG68mcHLBl97/da4YDdzy6LseRr/MHkQ4nOwa1UfehxP9LkjL5k0cA7xk1F3GYYWPvk9vROCEoxJ5aGW3C+eYnyVy3YEoeybjJlE7ZW2RwY6Gf573X8YvcsnvtUTJeLq7c+iVHcTK0LWZkXCJGKTEO2wx6LEGxazsI3lmQGsQhOw92gsI6a5L0Il7jEv9iGsJEQyBandivQOcZ5EJyMvnOCwCttUYYztuwK+SPgs0garsuNdIIPKPWLfiE8wpVb41q7JblKrmJnLVuJzi0dQT6B7/y4etFgC59VHd6xy/4ZlxQbo054RnF5erLhd+/YkwNgrQVB9kBcaaGKb6J68I15ceNJe7MGEFLDodmuzxEJlD5LxIYPwwkVZw81YOcayAuByyplcnQJXC70GULQHeMjX4CU0XX9XvBG+vKejWx5KKvxH7snanFUJ5toN4skhsamTEBtUkD/hE+Mdn3WJYNvK3F7C6TuJnFDnlgs34PZ2Vz09cBWk14LWvIDMa/ibEjpzttDh85sOuIHJzowciKkOq85/JJWO6np5RiYDUuHAJviTci9LiESPI6h43ffRfa1iZKV4lgS3oP5tOq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199015)(6486002)(478600001)(6666004)(6512007)(9686003)(5660300002)(186003)(26005)(316002)(6916009)(66556008)(66946007)(8676002)(6506007)(66476007)(41300700001)(4326008)(83380400001)(2906002)(107886003)(8936002)(4744005)(7416002)(38100700002)(86362001)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QPhOtX8+ZIggpIvalYf0DPYHXVunUsRy5qkLhmmYHTtKQD4MM3Gk7c89p+xO?=
 =?us-ascii?Q?WxpMr/V1J8vHvRwRz8ayUBk6r1IUKxYcfaIVtR4BJkpLXiX/lq1QyeRnPmDa?=
 =?us-ascii?Q?2+0APwf7yBqmeX/7w+PVSx9fsJV6e1rhMtmMHJIrseHfMLYyM0wGG5lgOVIQ?=
 =?us-ascii?Q?jCNUmxu9WSRHceusv0fhOYtTOnQD2RjXQcXs00CvdRwhQpfU5DMR+8G9zFEH?=
 =?us-ascii?Q?BSY6pdziFW50Ry20ExD9KewAK/xJ+zsLxCTkcHAyiACJZjgKhH29T19pW6zF?=
 =?us-ascii?Q?3diVGzGYw1bAy3ok4+IljdKn/llrB7cpyPankn/gsDUhMQAG5PRqkcgL+KvV?=
 =?us-ascii?Q?vr6tngrWIWHTX4mw5vpUtxWCr32X1XpfelPNtRtfsvQOP1KFD8ANhEDQIG6y?=
 =?us-ascii?Q?j9+aMZ4Ww/bHBXvJD8ur7qgv/wN6cpbBOdTwz5Ap2yvHP7Yj34MyfNFErk82?=
 =?us-ascii?Q?MGBVYhUoGa0Lb1vNQ45VDNyora8DR8oYrzoHrzd9/V9LkKDcoA1OSGB2Igj9?=
 =?us-ascii?Q?bNBhOxoFGAq407/VgQIHBgh0+utnYidg1DzbfHDDTxDoW9RuX3tQEoPBJ4pU?=
 =?us-ascii?Q?N7brRxmQbE4BasokPSdHPrXKc56ira2PPLJP5Q8jhIVI5sO7WX2yqj9y2haM?=
 =?us-ascii?Q?5WDbspziryBjpljVRIzFSZmTHjsDsgdz2qwOzX70EuVeyKOxnBxyTXh5LYw/?=
 =?us-ascii?Q?KMcKFOVfa9N0fckjiaOugcS4vJVfyrGpFuHJ53+I8PakZv3/Iu1XWDKmTZGt?=
 =?us-ascii?Q?yzMyG7Vpv4NFS8TCMMP3j8DPgZs9/EdoxtdomD7Yvgh1xAOLe+RQ57JWQhyV?=
 =?us-ascii?Q?LtykVXfIRn38xmi0BNeZsaCG0/lpxMAy0F5wfUkrTJd6JBUE7i+Pq72ZjXLy?=
 =?us-ascii?Q?dTOd1X/pxWLcXNwBs/X4uNQDp4mBIENH6ODXfeBLRGlTvhlPnMQdXnyQEY7q?=
 =?us-ascii?Q?9tFXb63O1l9DYEhoIf+m8mjMjXeoUEl8Nza8ayFPl1P/59EXBqp+L4XIHOrh?=
 =?us-ascii?Q?kdc67rNF7IDTEethkxbEAQuQoRzYo4Ediqk02hSYTGqS/Yh53sg4LPH+5pRd?=
 =?us-ascii?Q?SFcjZhjSBa/X4kd60BwDwvcibaQjw4NVGdFv1pitG1Uj7a3OM/RCAzlhYoaf?=
 =?us-ascii?Q?2tKvUV4HGkgpm85wLKQ7esHod4DZxetOgTrOlcSmrN0/b4iXA5H7RX9IE8Sa?=
 =?us-ascii?Q?hQqYrtSk2+ekNevaxxi3ydxUKyy7fC9wIkpmed89xt3qBjDMulguhXl2Vhrj?=
 =?us-ascii?Q?m1J7PFBKX8d+w5iAB1dAtJl0X5EnE1S/SN5mFf+/jw62TsPiCY6XbsiZKI35?=
 =?us-ascii?Q?IksNrRsfcCKaDlRRuP1FnqBJVm1eWxLGHIkJPTgBST5cewfu7zemdWHaxK+z?=
 =?us-ascii?Q?YHX8nT4/DVkDcgcHAErSQzf3qTNBrulu8N7s18WlyA0++8OJbHCvUnFV/xxf?=
 =?us-ascii?Q?rnonBzfzqUYvEG2Mym9vbDDCj8N0m7rRIKoxC0oc8UDiqSMVvzNgcLjBhmIP?=
 =?us-ascii?Q?zqRVxgxmcNYnpmw49ltH9Lt0+CSMkT5iCc5h5Eao6wkLGjwVxn7Uli3NlQMi?=
 =?us-ascii?Q?AmF31WgmOaVAqxWicxPnTGA1UY/OjdOO0/iJKSdI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e850e51-256a-4dea-e0fe-08daf2e236db
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:11:02.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nw+K5eNQ4mquzYwrieC98txlfqoROKnDDkp/IrrxWA2hygG5brJERTgNn2/Gm0b/4OAwohIwxppOSv0NVZOnpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6548
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 07:31:12PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As long as the linecard life time is protected by devlink instance
> lock, the reference counting is no longer needed. Remove it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
