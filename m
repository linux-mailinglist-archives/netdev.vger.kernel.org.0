Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7989B55C6E4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiF0Plm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238488AbiF0Plj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:41:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD9419C10
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkV8JjmE2s8gGWheLqD4R/fCND6idAetGLSJo4mNqrDof4yQ8gORdsTJ4uuF1RLaDa1UAjnIwq85la/WlYGiKlP6yI+aJCM36Lp5kYDpQo5OnCNQZf3jIpIe/ermgIh8oH6AEkmnk/w6FgJXZtzAS44UzKGRbRYJv1NRQqS3hXXUYTG0EHq3ihkWMTOahI9tFhOsrlfMKmlNursNBmx8vKgNjtNNKlcFEEARXrpVcy6mNHKOK8BnE+798+RG7uCB2Xhc/rnXsluGkI/QGFK5bXUML8VkA/c3/jzUY1E1kbdUI3GUL02hTMWY4+sbM5iWqgTzdCXbUAkh9683xPgriA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37UNuThCQndblMjGrSF/Ldyf496meatDBaWpiWnNhKc=;
 b=Xw+TMF9X3LI4n0MVTnQtHuhkpNiK8kfy5mQA/auB5ADYBD8dGH1cLHazAVmLDBAywpkXGeVfaup+JPuUeSW8wpkKm5ZS5ivds6CCgmsoFFWsXakuNvB+hfWfxcHZam0eJZzSKIemC74HoRETRPr7EKMBFy5H4P9deM91uWp28tewrJrpliuWFQxYDGlXg3bgWXJDjXXQlWsKSM6yPtL3q/zjXWtU5D7uHMYn2TyW4qo9nd/Dv0TZgMJadt2Q2ku4oUxTjgIO0KvB3nLvTq5GWBFkIkZ5HW859mKooYtAJPPViFW7FF5WOq/a1Z6veIH0/e9iwHmt1KrubZjiiMNR3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37UNuThCQndblMjGrSF/Ldyf496meatDBaWpiWnNhKc=;
 b=sRuGgO7a5eNs+SdlEU15nLdBfXxoo4xEKLDvuSHJB/2ct0Teiis7dby+vaRtWqpK16O7rrpegUkX1VP1PuDmueO6yLQi5UvxyPSSWmFdbrIuDUYiUqo0w4t68hMCmrdxc3Zu9jU8TGLEHQt139SEpRt1SCyq9WQhznMA/jJQ+dnCY0H0IP64l7LL6zSJOzt09sUVIeTc4whmlTL1PbzC7jamhHTEX2RTrHBs9jtT1aBvNnwHDY+e+RWa3FrZb0Il8oL72D/J+8oFxrXZHXCxW+5uXlJbkiMIO0hX6YQj5keLlD999hlH9xp3tH2VuI3YqzcbQm1hb96uLJmvrYciDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3751.namprd12.prod.outlook.com (2603:10b6:610:25::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 15:41:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 15:41:36 +0000
Date:   Mon, 27 Jun 2022 18:41:31 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <YrnPqzKexfgNVC10@shredder>
References: <20220627135501.713980-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627135501.713980-1-jiri@resnulli.us>
X-ClientProxiedBy: LO4P123CA0304.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34154970-8b40-4bdd-1da0-08da58538536
X-MS-TrafficTypeDiagnostic: CH2PR12MB3751:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJkYX6rcnKp5+lt+z0qrnNocEPg99iRM9snQjBlPMii7tF6dqyTgFcvq7JbCW8fiQFmBitg99w/swxTVyFEa/jGRrPKXY2E6bN+MnPzkUXxi0GwXuEdZCYuSJw0Xv3FGll31Av7/U2leotZnrwxqZo+6MMO0Kd97BHFy9F/IXEXp7Cks/mSWrVU4wd/qKcFSky+zYqfj9isiRahVA+E48U/o8vNV8GeRwXhacTHdLgXZ5tFW6MwjZo5SPfGuHyFLOi36uvoudulptizsay+NbCpzoNkSRyCHz2LndqiWogeWspGhJ9vMwu5Xw7Limfl+vxBxgLjJ8nkrfqVfsXjwV5ELVRkkkqprGIt/0aeZWdz2h6EmXzmz3oVPqGleJKhXqyPdfbGDq96sMs3eyPNQuNGW5F3i7TrqzHGKStWG1UfDcduAWOBmIvlhZs59QJ4Te6GYVGi4kFoTqbh0u0oaVGq/PprP2MXqUw88zBRbkoGb2YHpafifp8e+lXklVkf0uhZjuagUJ3zNOckyIELRJfeHCjYNfhO7A8JFXu0dTQ7+X1xeNToxM+U5+fV73mh/RtP9yGgG+Uz4c8P2n1+oRN/YDovV9YRIAj5mjD1r7XC7j2XB6J7Nxex+sX2xyPjXi7TRp2rdU/PhOGr0JWIyffwyte6K0DG3kYABbHsMWi313VwF4KzDGfP0l1TNJf8tx3TF6Yf8LvL6S24PugCDGaUIWLoa7AJEk8B7jnNkzi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(6506007)(8936002)(478600001)(26005)(6486002)(6916009)(2906002)(38100700002)(86362001)(9686003)(5660300002)(41300700001)(83380400001)(4326008)(8676002)(33716001)(6666004)(6512007)(186003)(107886003)(66946007)(66476007)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cyAj+uLytyRltImFzYM3cI4oSJAhFgT0tMDcsdLq9HucBW+SWrTf9L/2E7id?=
 =?us-ascii?Q?VGFiIV8I85+E2apiV4rhPWTkeJRqsM4gIasu8He2bHyu+4jrN8f2JQ0AtWT8?=
 =?us-ascii?Q?vsv6IJmVTBRyxh2IWJIcjcVitZZkZ2Xq5TUYwlZcp5iT44Hc+5/vYef9q9VS?=
 =?us-ascii?Q?NRGX0iuNOxXnxgvu+NbdVFI2Iv5MwKBkVol2/2NNcXM4bYQEU7/ng0BXvODu?=
 =?us-ascii?Q?e9R36xxtzKcpcLR+vtmoOwOQqFAVWYRXN0HSA3H2X8JesSLZ8nHm4PlRTe6+?=
 =?us-ascii?Q?4UGX0f56BXAtqvP/F0KWOOJU4JuLzr96YsVkMZESWcPhz4SojMCbC6wMMPGZ?=
 =?us-ascii?Q?DSN3Qvlrolxk4GMpTp4DwIdNQwOxxz2WnyV3j8X875zzJdd+PvFw9H+vE8rk?=
 =?us-ascii?Q?dVw+aHBSZ8147/rRFGrbbJD2KGIoeFodulMEnFQvm8nJumRL7govjZMu7+tB?=
 =?us-ascii?Q?11fl+Qi1R27cp7PG7zchubUbzYF3/VYvE2xndjNDMfKvs2Bc3km/cG94+a8P?=
 =?us-ascii?Q?/co56D/Bevakn7GhySBePHBq0YCjcA2F0TZOkBU12O4SOeDKBgzNkyh36Vaz?=
 =?us-ascii?Q?1YbfpyeTDsliOXYtRKCR/Bi8Th9R2SGmu3/l0+TL40QN1yr/jzVN2FcMc0Il?=
 =?us-ascii?Q?CoC57+Dn89e1wRmhPGY8XH3bh4igeB15s7k7+AUjNsVbnCTr6mvkLQMpPeLF?=
 =?us-ascii?Q?4fdPGaVYYxA3Dn6Wq22Faummn6xJyD0ZRkwQZvWesLYiK1zWH0lu/8QRU9lO?=
 =?us-ascii?Q?WDj2vPbo5+LzCNo5FW8XHA4VaLaNRB2XFuQL39QfDnD4VSW1qVJaQUVSu7+U?=
 =?us-ascii?Q?wXI5RgzlJtRngrX84nqgmKmvp+gLhmWWHbPLIac8v1rqzctacvsyPBOEJ+3B?=
 =?us-ascii?Q?S6L0WU2wA8ohdE79KL7DSZyUqeukIaDA+FD2NcXUlK5kY3nPRlvKyKGZx06k?=
 =?us-ascii?Q?SerTL1HM9w/TUdR+sAeKA4KNOz4jvFLBY+y0knLzQ2P0GdA/c0rDCrz7+ioK?=
 =?us-ascii?Q?t61Bot+kd+GQKP1gcnbYty+fpDQBzigJ2PYKAB6iSAcD+gPbWWaIzhdsqDd2?=
 =?us-ascii?Q?t3T18syJIzcfdhupfVQzKEpJ0YJ00vsz4yzmfjeC7vVgsp4b047WkLT1hP0e?=
 =?us-ascii?Q?oRL020cocIPMrmT0FuJqZSPCgghWFkdr0qF2FyjyxmLcaBQsoQY9jkBQSbEv?=
 =?us-ascii?Q?mQRzxrwLfNgJtCpoA+FqB2mfdUT0gMg6MnhC+aONj0ID6ehMbHUR5Ts1tUz4?=
 =?us-ascii?Q?dadxgdTltJAeLstSWr0YnVDGJiaR9GUEaQMtR5wrK+cidOqBONIUxXeovFkw?=
 =?us-ascii?Q?lt1wNTQhjG891rJ19kjWV6JLyfGRwEJMhkdwITmSS2SugXwAnqrxZEIWeEl4?=
 =?us-ascii?Q?EteY2lww/3UU6bitne0BaqFcxT3pPE03N2TfFM8eZBeEbUOcavjy0+MWWyQY?=
 =?us-ascii?Q?62jB84c2vrwFOnIsRT+ZJ+lNKfs+mEJf0m1VgT28SynC1hBBKHsB+8Ds9ovL?=
 =?us-ascii?Q?KVD+hMnM5LK7FRIk87xppBDy2+AiCi9sRjDu2UqbEkn3eENdaBftKS4Md9p7?=
 =?us-ascii?Q?yGSc5SxgruxW/8fwAPMhcgSqmxzlQICk2UObtVG9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34154970-8b40-4bdd-1da0-08da58538536
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 15:41:36.8355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFS5IQ7eBGGIXYL5bGSYO4Q5aEXW4tyaOjbAzyRNi2RhUTcxwJtxaFUFCF//VZnRCVCqcpI1pLfKBM35qY1iBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3751
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This is an attempt to remove use of devlink_mutex. This is a global lock
> taken for every user command. That causes that long operations performed
> on one devlink instance (like flash update) are blocking other
> operations on different instances.

This patchset is supposed to prevent one devlink instance from blocking
another? Devlink does not enable "parallel_ops", which means that the
generic netlink mutex is serializing all user space operations. AFAICT,
this series does not enable "parallel_ops", so I'm not sure what
difference the removal of the devlink mutex makes.

The devlink mutex (in accordance with the comment above it) serializes
all user space operations and accesses to the devlink devices list. This
resulted in a AA deadlock in the previous submission because we had a
flow where a user space operation (which acquires this mutex) also tries
to register / unregister a nested devlink instance which also tries to
acquire the mutex.

As long as devlink does not implement "parallel_ops", it seems that the
devlink mutex can be reduced to only serializing accesses to the devlink
devices list, thereby eliminating the deadlock.

> 
> The first patch makes sure that the xarray that holds devlink pointers
> is possible to be safely iterated.
> 
> The second patch moves the user command mutex to be per-devlink.
> 
> Jiri Pirko (2):
>   net: devlink: make sure that devlink_try_get() works with valid
>     pointer during xarray iteration
>   net: devlink: replace devlink_mutex by per-devlink lock
> 
>  net/core/devlink.c | 256 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 161 insertions(+), 95 deletions(-)
> 
> -- 
> 2.35.3
> 
