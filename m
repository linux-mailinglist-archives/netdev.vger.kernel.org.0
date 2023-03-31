Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39186D1E56
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjCaKxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCaKxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:53:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2101.outbound.protection.outlook.com [40.107.243.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDF21D2CE;
        Fri, 31 Mar 2023 03:53:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNRdaDU1XFGysOUKk8VQ8CbsWmSzM+ake7A51uOqHW0DwU5RbaDN8IoYr8S3tfIzpHaOioItTtZLWf5pcZ7HszwY417hb1WwMdoMcG78IwOWEm3ZFJ+BRII8DgxdBzsXYTV1mCOMxuHKWLteVpA8zOYp7SXxebma1Q60IYB6W6bJFNCbJ/+lypT3O+yEZLNaUaiG04O+XRcKZmWmL0rToYV9b3n1A3bFw4a2JwTnvNWDDF33lNNbjyphZbqjlXDuXdwDLpJfozfCIObMTh7tWI2yj7Dsjo3dpNff2RpAZbwNkAbD2Y8uW2G+Gscvzo99YtUBB0OG+xPmWfR6sLiFVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvH+0p1PPyFBVRtnbJKkqXaGqJ3Mbn1XKqpDl2PkYO0=;
 b=cTUdSjnNBwjVsluav7MPN25SUWvvVuRnsHTRf2RdXhgNSIuu+q9aQEojjs18V5bB9Ik0M0pd2okUcUfm6653GsR8P9OEw3LJ3ijMD79siFt0gfpQ0SaAIILmSD1a4Vyq5qjez2SWQ5TlJgwdJnpZZhZLuuBkjfDrFybKqZ796nyknFscGfLzg28dxqOupGBmpRVlWbpVW4Ts3cLFWVnDa7DRj5uLDAsLkVUe6I66Z2zYS02NSCCWABlCfvA7L1QDZ8jNJeHOEuXAcK5S6yk82SiRPBFMBHLwqizM4G8nFAQUqGtO2o23uAlNTK7k1ziITe/5HGPjQgOVNEdNqVh9Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvH+0p1PPyFBVRtnbJKkqXaGqJ3Mbn1XKqpDl2PkYO0=;
 b=u81vMQQhHsvN9cksnkPtIBuixGeHEMWNGKsT3qRjNZy9HAtJqhFiwzlmKuevIbt0F3+iBr8DG888hbrDQm5cC5fOr8TCPB80M/1JNsG8yiV2y5wclR4QDZI7Np2+mw2fNm1ZFmkwPEeVxKznh5Fzoz0bDUKl0RC/omsK9ha3k2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5990.namprd13.prod.outlook.com (2603:10b6:303:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 10:53:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 10:53:04 +0000
Date:   Fri, 31 Mar 2023 12:52:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] vringh: fix typos in the vringh_init_* documentation
Message-ID: <ZCa7gt7UZ4edEl2Q@corigine.com>
References: <20230331080208.17002-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331080208.17002-1-sgarzare@redhat.com>
X-ClientProxiedBy: AM3PR07CA0075.eurprd07.prod.outlook.com
 (2603:10a6:207:4::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb2ad56-793c-48ba-91f1-08db31d61acc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGqb5khMV34q0meHApQxn5G9OcFRDxrvAPea5DvuExazc2UznfThjas5m2ZrLs8zfVT6/h7ui3QBjWyX6MCLAazOKirlHN0DFlOBYjEszvncfDDDJi4vGV2oEx3QSDQgwLa1jiUt4h84WpLDMdoxZv4SmlcwyLDA8Xy2sxEB/dp/MNpVBz3L5WKJi6BiEZYq5QmFAvD+/dgGtdTbDSyHrIGLTp1tHmUp2qj2NkLY6aIC1vQ6535C7shI+rsq8g9RGefjhTowhKkDgQT2a7wh4AB1NjmN+THoetqhRtzfqJpzZc0xHBWBsRYH2t/metPesqnQYcXVeQ4+osOH1U/z6zHip0U1u2aa2LA6gbIayTwPuPxx8RNJrHkMr39GiBeJzKiHlX/wSodQm+JGggri450KxG1Vdb9uBomfBIiL+90ukYecVRcBXqFgV7KL4hMbPwc+68TiTe+dvFeg8c7PkHnKEFRJRyLsqPMe60PRme4JJsi1K68F9F6MBv89Xkv7OATcFN8DqYF/AhoKtVZgzefW78Ziph0fIXMB3W9RpXUrl+vU2Gmwq7foBzYDGuri
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199021)(54906003)(2616005)(316002)(6666004)(478600001)(6506007)(6512007)(66946007)(8676002)(6916009)(186003)(4326008)(6486002)(66476007)(66556008)(5660300002)(41300700001)(8936002)(44832011)(38100700002)(2906002)(36756003)(558084003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AV79GkXcQYvj5DfYC+hKIjWZh56T9eHIHCxd3vzGCCCWARmQfQ0WSsrOFypr?=
 =?us-ascii?Q?9hteGW3RatxZJU4WhcPuYX1LxRDquLbgu3rGYUxI0kmc4yszmR5i2+V4R2Bd?=
 =?us-ascii?Q?H7TzMq8a1sX+RQqcITFH/0YywbDAqgB7+JEb0NbPSQuD1lYlkbsBOEq7jjU/?=
 =?us-ascii?Q?1RaEO0Qdb4WJKkZT6XDWF+TEM0KHsALU/etgEyGBZsJNttVv+1yC40sQgoR6?=
 =?us-ascii?Q?prfoLTkmUnNLgl7jO2P+Ls0JEawLtwITAlZUW7MKVr692IpGqLkTyHGn9jdp?=
 =?us-ascii?Q?haNsmm79KUc3+XFv8Mqt4RiIkCO09QCp8rbY1NGRzIEZ8IoVwoxfJ7ayMbgV?=
 =?us-ascii?Q?Ho+kEFeSjsCgkxCtcXDLTvayEaEuq9bjrzo6fYf5whzKrcJKv2PfQTMxC3bB?=
 =?us-ascii?Q?HgPRKk0kh7Yc2zt0u7Y2wXMF/uYK3unEN0NuFBzJjbZ0H6+RlUK3/p4Tyt+x?=
 =?us-ascii?Q?sSVLRjHJfd1hOL3HQTFmE6Sj1sqw0YLabA5bVDJvBotU5hsFaGU9zsfLLYdq?=
 =?us-ascii?Q?HR2syq3rBHu3DmYow+iqdCkZTYuUDMV3Qd6mxoKyC1RLH6QUY041q75wHDfj?=
 =?us-ascii?Q?jrBokurwqvC4P+LsFBR1sAxQmfAf+JvQUz1qgMGg8BShMZwcW1C5XvVPgq+G?=
 =?us-ascii?Q?M1aCY4sn7m4dg5fIkUMfA4Y6+fg60LYWgL3FsVO+kJXcSJ2PUziC+MNXTebC?=
 =?us-ascii?Q?76PgHm/iGQTOesLfS7/w5ywN7Tvqpbhl1FatR6BEZ419LH7vp22pSFvkaEUY?=
 =?us-ascii?Q?3SWO6998Uvp1biyvD2j3zQYRl+Isnm0dQjv7nL8jYaEkTB+oBvlZ6VXvM7uh?=
 =?us-ascii?Q?95r1tOua56isEHrHuvHLDNn2uZpFXiPb3TFMTYpssj0jj8rqojWAKlEXqg6J?=
 =?us-ascii?Q?M6PfWAETmh5j2+yc6/DYUNTdGyiynhLqrtgKkltg8rE3sW4akIESbn+jfxNF?=
 =?us-ascii?Q?iWVUbhlvX4PaBQ9wirWpIIe6Nj11HXQPTizEFl5sa4Q/Yr+ahUFuF7W7cPKu?=
 =?us-ascii?Q?L4UHguQLWg9VOKbv9BULyJ7btCjFn3R/PKhGl2ObsfdX8qF8VnPVfUwu2GPz?=
 =?us-ascii?Q?LtMebghx+L17R3KJDjeok09cP4dn0Uo7H9iY87ErUNcztw0fi5da/QIHxjk8?=
 =?us-ascii?Q?rwhJ2TlwWflylhnMIh2X/P3H7mALI83oFFma1OoWsQ4txkA2bV0gaC7Tl4SZ?=
 =?us-ascii?Q?IBANSa0/abHAxEUKptXX5nu4C8GnPwflnJjetrTCf1MS+PagvdYHCeNwCiMv?=
 =?us-ascii?Q?PTX3g7OICrRNBGzO23MrKJUlDaf2+gzuLQgDRtNJnfuE3fZJSo9t7QltpEuC?=
 =?us-ascii?Q?/z0LO9xn5vYGL4RIAYPmkn3k+CHmHz9/hEVb7U6q6/D487xq23LOdXHhPBlB?=
 =?us-ascii?Q?SQ8g0izRffqZkfT4qwLDYZK4+tomCM5cx0qKF7/7lU7KA3FV3zLTVMBQx2uD?=
 =?us-ascii?Q?aPUrBus6s7oN9LiePMdEnlTkPaKF+VIHr4/j96zsIbsngGabI0XJ4Ky+UU/t?=
 =?us-ascii?Q?xaEltB84LZmN+5f16HR3syJHmDph63W0Do9loHArjiak5nPqvPjU8yhjJbOT?=
 =?us-ascii?Q?uC82dU6NjGFKk96zYvZnSa/iWwspCtBZ0659ZxlKvniG4xJ6qVepLa1HGT4K?=
 =?us-ascii?Q?r19ghpq8DywWEsO88439ya4k0VVNGVpUml/4ltSLsUAIvLat89WkpgrAve2f?=
 =?us-ascii?Q?y2krlQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb2ad56-793c-48ba-91f1-08db31d61acc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 10:53:04.7636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FusAdjzjo8ritolVXNN/P0ZscIgs0C1mApTKYQy4xzjvX43zKefIBxUJvtXW2nu+PmapshZUAOdHzZpvW1El8CJhMK3BbaObCicuVt2rSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5990
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:02:08AM +0200, Stefano Garzarella wrote:
> Replace `userpace` with `userspace`.
> 
> Cc: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks, LGTM.
