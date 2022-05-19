Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6306052CAA2
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiESEDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiESEDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:03:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80F095DDF;
        Wed, 18 May 2022 21:03:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHLFyji+a5zJ20Grj1gw201lE6oGpHRmLqiZVplymSr94w7opo1meYU8H3Dh8Jlb91x/lZvtY8VpD3Ebp4VLs/ISGFDnP/hMrzUUOgvBbQrwoYBctuR7gCbncsU5OlYlv90j6Jw6zRj9Y8AKcqhggh88UQ4i50/KWCQxDeqoXweMDXFLyoBBCxq63xtoORB2qhlNUrou4W60T8CdBeKO9WVqLJ35afvVCWmg5k1ef7k0KiEMSgLID9bPsi8bukmha6rheLeshe7oTBWUBfcViq6qWYkw2qgyNzLtkiZcIQo/bZr63YkcCkEkin4Hnq82t/58Yfy8Ev4giSTdaeAMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CgVAePg+kxdIHDvjxs5HT/X6C3Q6DQGORypczDED8Y=;
 b=cd1p+LgUOpUNsPtZlNJT7kiAbuN+SrGC2Wmxn+gAlTY0U9LTwfa983+6glfvLhDyaPz5IQXjLsciHPGSIJ4LNyeRmhXcA+1EkX97YgdZsu4/VFv6Rs/yV89snZ642LzG9oaq+NeTpTuD4bQGWyV63pPNNZO+QYhNgOC+pFTnUv4wqrfwtvXJ7Kdm+brqHVD09V/pIJ5eUL2KFfPWy2+XWgjSY9qiNL/blyuQ2OrzrmowLRCbdIMetiH4Fhd63Kdi9Dq6YnflA6bPZzDvLisdGmYyYXNQyj5AvGcdy35FaqtHUagGkJwC7PIbatHXgpQTD5Tfw0Py8xZe20jmHAtLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CgVAePg+kxdIHDvjxs5HT/X6C3Q6DQGORypczDED8Y=;
 b=TBmbMn4uK9/v/r1yUY8KgXh702UIDtTdiSiwzgkMu+svfutbz0/6J9sxTglC1kCccLzzLwxqf5iJgwn/9zhaa8bUZgWIrF3cJCyGEDyXuCOAsLDTkI1QtIQgiqbnYygyk9hkGrq3uKf0QLP8Kgp11WG3Qom3+gfEUpwhsT8o8cRS0s5t89mJLnalU8T2RM7bUy0qQSp5XjlQXjdrVhfPgnAgyv3iAOHxxEQnW1EqHECzU1rmHV7ez7fzAdIfh/rXBiN/LQIwxpJhcFBV6NjS+JpvMrdgQORaTm6i4q3hoSoGJrS6y2FH8J1iIvDq7ERajF3TKsHihGn18Hr9OLEpxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB2519.namprd12.prod.outlook.com (2603:10b6:903:d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Thu, 19 May
 2022 04:03:47 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 04:03:46 +0000
Date:   Wed, 18 May 2022 21:03:45 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: linux-next: manual merge of the rdma tree with the net tree
Message-ID: <20220519040345.6yrjromcdistu7vh@sx1>
References: <20220519113529.226bc3e2@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220519113529.226bc3e2@canb.auug.org.au>
X-ClientProxiedBy: BYAPR01CA0049.prod.exchangelabs.com (2603:10b6:a03:94::26)
 To BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c2388c6-37b6-4b11-1742-08da394c9272
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2519:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25196535B2774CE3AA80CAEFB3D09@CY4PR1201MB2519.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SwfVyDsAzUB79GdwQbT/pU3kgaQFRRXsuKdi2LGFsaOix7La+FzXedLmQoOnp8mWXGAyup28fyWitAQUcix8RYvXddSvovCJ+034GgS7aOML6visoFY/8FuUH0LMS0rMmKCWeGBHv4BAlMP85HyXAKjrq6Km6G4jaYyJdMeDNEMCOOGuCq1sCG3jqE96Y4gDaQDO2Mq8UJjA+v3b+0flAVRPHo8q1D5gIXyBWOxnTWtQrCg1H/HPQeq8am9/N6i4THwzgJ+kkDFPay3ruZ/8HrUUajwwuIXxdNGTuNh+6spElnIhjbTS680N2T8av67fOUoPJa8+KW3Wq+TdGClV/F0oZo4KEGduqG+CYxEN/b1Low6OHKFk0y87w0kEPyJtzcA/ofOqg7Ls9jHGy+Mx//VYODnGxXPfML/jgVF86VYJLjDAdIrV1ASUsHn4wdmM7VJUNnGhdWqC9RaHt7UdQBybndEI+I+4tIw0FWRVwfkBgqRmBKc0b6sj2TfhnGJT1nDrB4PbXYVaPcLs5bdnOnlhNGa9kTsmPCK2bo2GhgOKSmWDSzihWa1STm/NJByegLhTWpFGAiUTCA3IZcyCnkkEw1dRsecG+x/KBNy4sk475fWK+FEOrAklqEMFfyxkEuoT4kTAtZysLz39T+Syw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6486002)(6512007)(86362001)(186003)(8936002)(33716001)(66476007)(8676002)(66556008)(4326008)(1076003)(107886003)(38100700002)(54906003)(6916009)(508600001)(6506007)(5660300002)(66946007)(9686003)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JoYNrwFKFeD+cwrvRtnOvjcgL9D+IjGzbtNFIgqHXOjFYqVKizYgquPAdEC1?=
 =?us-ascii?Q?hUH9MeG1QoplyrJg+WjVWucqY1fQzKqzToNKXq65vU0DYWQXDWrjRkUeEFrk?=
 =?us-ascii?Q?bibS+RRhW2PVbsMyc6grwz8Q2p9TCl6+YIq8pwbqFOQbE+eexwqVsGIDzHuf?=
 =?us-ascii?Q?WK6byOSgQN9dO9Q//fhhiPwSWbyGHM3EbFg2yiL+aNbiNVl7XMJPW2NQFVJV?=
 =?us-ascii?Q?ZYUB6iKpwqAJyi07pZN7O/mtLa4//MvlJJeWBTLCLejudRrP2dvwLbxPAshH?=
 =?us-ascii?Q?dEPClOmUDKIDjCr3I6jwIcEOeTq0Fh8/tL6C8VFZLQOoWVJFHiThJlNa7lf9?=
 =?us-ascii?Q?1iQRvU1nZbUQvZ33FfEgUuQwbDglffkJ7Q1k12P2Brgmb3i2hZdrr5313Y/b?=
 =?us-ascii?Q?tqzw9VdE3pyxFj5UsGuIkHkyCbU+DxKXVKOh3lDjOStvL6SAKSw06RZE+6sq?=
 =?us-ascii?Q?E+cFyiLE5i7sFxNWOBvG7H6i89MeVIELH2YGejZmKaIHAHDLs27U0VRdeuL2?=
 =?us-ascii?Q?Diata8h/9fSamANqPzdc7+ONl3cXr/KoIoD4gSfeDfRYRlzvjEeuTC1QiAZQ?=
 =?us-ascii?Q?0EVNRkyaVqEVYsYX66d03Pw2dAUGDG/LlY59OZ7fgYTjB37022LhieOB1YYO?=
 =?us-ascii?Q?DwKEVYkcyILpzp7ni30/N1HsmiMO8fhqMhHz9yHKnEIL3nSVqmQlrS/gSWfw?=
 =?us-ascii?Q?jadk5pbWQqWUxqBzg/ns0LDrJQ3Nxr1W+4AI188yIJuSimbk76yvig7LTC/g?=
 =?us-ascii?Q?P2t+32KYthmuuTu37PSx9dys7sEAj05u6r+V/BWbdvOzSWTZdqv/do8my5J0?=
 =?us-ascii?Q?UpSICqJwU6I50uDpIiPm5gYeMLqWgTdh9y5U16weSiQOgOmu3VHhGNpGJqbI?=
 =?us-ascii?Q?OS7DmYo8S5RXTAxYKpWdpF1w/zsiYxxwolUDdkxi4VBrteoY+n9xYsRTNVah?=
 =?us-ascii?Q?FGMbNMkX+VTgz3HDAQi/Cw0tibgBBV6ncaajhOiNnS9sKy3+6GrrEhS9q8jx?=
 =?us-ascii?Q?QdAB2vn7QGXx0nrQTM2ERKUahbb7Lo2PMbf4I3IkT4N5VgY+Syetj1AIA7PX?=
 =?us-ascii?Q?LomHjgVOKm/Xka6S0Fpw1Qw7Ls2RY18uG1mlHLCgBJhl4UkyhXNYc72D68ae?=
 =?us-ascii?Q?lyDCcNZVtoFNNpcTbAUWUh6u+c0o2TqyBBR+byeuIfrDWItiLqNvKOuFXDLn?=
 =?us-ascii?Q?pmIxxKjR92SSC96yiUqAjKM+6j1nyKzWSUx1J8D3T4P6e428DnzEDtPZ7Fnn?=
 =?us-ascii?Q?BZysxT7CdGDi7Bz9ERroQAkPsQB7kF0KvRy0y7iMO2O9ElUNgmaDsGz+PdvP?=
 =?us-ascii?Q?ddY6nviEWDBfnNuIGZZbM06zgSsKhKlW94GzoMvmJl5x2xgXtvmos9D7Ro86?=
 =?us-ascii?Q?6d8fnEDG7vNd7HxQYwbjFBAkM4YkVtXpxoRG+uoeRc4LFzieOOM249N3D0OV?=
 =?us-ascii?Q?urR26js+KavrCvgrI/ekrdJldYr+V1KTduLvd4UV0USxrhSvgNFfWB2PlcWW?=
 =?us-ascii?Q?PJS6tTuGCRTRvB5o0M5w5Ay7WJXche2gu9wR7otZd9l5wfJCWMRJ09oUVqoz?=
 =?us-ascii?Q?/odvQyqepdzw5Fo0HuBkglZtAP6imh6/k7EMLsmMDUceVtb8oEmWhgAbUSVZ?=
 =?us-ascii?Q?VBlJsmGCxoEStPiEniDyd260l0yaZDtmFA86Ziogb/euh/z21AJuPaCSBLfJ?=
 =?us-ascii?Q?GgRavP/fouU0YlLjb25QYYufIcFrj4Wap7j/HfAA+QCu30YiwIRSOKCLcOL5?=
 =?us-ascii?Q?Y8Gc8YkVoVuTKm1Lx2J4lE7GcHSKbj8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2388c6-37b6-4b11-1742-08da394c9272
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 04:03:46.4688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8UtuYBuyi8Fa2rB6ro/TZvKsKKUbxwaWYj6uapzGFODjTEISW9Sl3+LqfTr/lOqWce3bV+6uPvhS83mgftQ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2519
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 May 11:35, Stephen Rothwell wrote:
>Hi all,
>
>Today's linux-next merge of the rdma tree got a conflict in:
>
>  drivers/net/ethernet/mellanox/mlx5/core/main.c
>
>between commit:
>
>  b33886971dbc ("net/mlx5: Initialize flow steering during driver probe")
>
>from the net tree and commits:
>
>  40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support")
>  f2b41b32cde8 ("net/mlx5: Remove ipsec_ops function table")
>
>from the rdma tree.
>
>I fixed it up (see below) and can carry the fix as necessary. This
>is now fixed as far as linux-next is concerned, but any non trivial
>conflicts should be mentioned to your upstream maintainer when your tree
>is submitted for merging.  You may also want to consider cooperating
>with the maintainer of the conflicting tree to minimise any particularly
>complex conflicts.
>
>-- 
>Cheers,
>Stephen Rothwell
>
>diff --cc drivers/net/ethernet/mellanox/mlx5/core/main.c
>index ef196cb764e2,d504c8cb8f96..000000000000
>--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>@@@ -1192,15 -1181,7 +1190,7 @@@ static int mlx5_load(struct mlx5_core_d
>  		goto err_fpga_start;
>  	}
>
>- 	mlx5_accel_ipsec_init(dev);
>-
>- 	err = mlx5_accel_tls_init(dev);
>- 	if (err) {
>- 		mlx5_core_err(dev, "TLS device start failed %d\n", err);
>- 		goto err_tls_start;
>- 	}
>-
> -	err = mlx5_init_fs(dev);
> +	err = mlx5_fs_core_init(dev);
>  	if (err) {
>  		mlx5_core_err(dev, "Failed to init flow steering\n");
>  		goto err_fs;
>@@@ -1245,11 -1226,8 +1235,8 @@@ err_ec
>  err_vhca:
>  	mlx5_vhca_event_stop(dev);
>  err_set_hca:
> -	mlx5_cleanup_fs(dev);
> +	mlx5_fs_core_cleanup(dev);
>  err_fs:
>- 	mlx5_accel_tls_cleanup(dev);
>- err_tls_start:
>- 	mlx5_accel_ipsec_cleanup(dev);
>  	mlx5_fpga_device_stop(dev);
>  err_fpga_start:
>  	mlx5_rsc_dump_cleanup(dev);
>@@@ -1274,9 -1252,7 +1261,7 @@@ static void mlx5_unload(struct mlx5_cor
>  	mlx5_ec_cleanup(dev);
>  	mlx5_sf_hw_table_destroy(dev);
>  	mlx5_vhca_event_stop(dev);
> -	mlx5_cleanup_fs(dev);
> +	mlx5_fs_core_cleanup(dev);
>- 	mlx5_accel_ipsec_cleanup(dev);
>- 	mlx5_accel_tls_cleanup(dev);
>  	mlx5_fpga_device_stop(dev);
>  	mlx5_rsc_dump_cleanup(dev);
>  	mlx5_hv_vhca_cleanup(dev->hv_vhca);

I already mentioned this to the netdev maintainers, same conflict should
appear in net-next, this is the correct resolution, Thanks Stephen.
