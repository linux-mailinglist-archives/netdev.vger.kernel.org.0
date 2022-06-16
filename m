Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7045F54E8BC
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiFPRmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiFPRmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:42:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B88149F8B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Np5HwtguspTdBfv+cHReyRkEC2H1Cxwymigr5XsSa52pleapt0hRZDH2UaEW0c9QqbGLhy26WvkESmpcB5QsS/Ddv+lYuxskUeV26OdgmzEBPySzN+LC3kIo4+re3ZIf29/Q9aa3a3F18DInyGormIiH0HgVMNb706HY5yEp+GQNeRHxcJ2C2HNhi7GfFQK5cl+d7aJeGTiTI/0eXVHsDVGiXGDQdl38ml21Kz8KtOpuKVdVUn1W+fzVtYis13ZSYcBmAJ56Iwjsx6QyAAsDM34uAC6JMj8lHrUVs7qSPE37SRa8GH8Q8GQo4+vvbwhLLxAelyBz5cHJUuMAnJnd3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4VcBsldaXbQygyQonrNhW5L2fnlrLyHvShR/m+CJxI=;
 b=S3Fw7e1yfaXUQR4lmvuuDM733xiZ+pqWsBVq8sDlOdRaeFDIkUAMSmWJIvSDKZ8dVwqcLKlKVBgd/0Dfe8AloAeWXJ+QKFZI78L7lYisRtwLe8OwnhQPKN51gW9viEpw9WvBoT41o24tfoW+yYf+UQXZg6MEi+S9wiZVHNnqFCIH/vOlGXkZJ2MWfQy0Ck/eabfq9SVjy+zXomKrGc2xX9qUjZGCCWLcsvHPWnPNcKS1JCk4/8r6pggxa0VKyPLQNeMkAOEKcrW6/mKbXmspPhc2T0SZMHQyyFtDD9KE0RSWnIf2sOnGip9eZTsFdeLiqAkM4cVqS5Nx6VwmIAPAZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4VcBsldaXbQygyQonrNhW5L2fnlrLyHvShR/m+CJxI=;
 b=CiutZbI5oCb+RmlgaA/OeHtfvaEZfDdp6M0LGSbzPDITHJuwdTAWprqibTjiAFs0Us3xa5RCoCC95lAKC+uZqOxkgeqcFhlqznTOvgSlOgoKMSz9UcdZxCsVvDKyDtXGUyzeWSZ6Ojdma4nkQ4TPMNMTQykEjg7wojttb/pkXfmbyPKfh7kf0/WfedblZQcyxe2p/qvl+DbHJ8V3oGqQ667GM0Gkmm2iWt8F0kSD/v3+Ww1jRGkfsHg21zrLzeSyys04sed/h8YAc/S+Oui+34qZUn9Cd8AZjJqm8vpHXOojO986+af/bgTPS1hQaNVx5gLFj589HvMLaRLzFrK80A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3927.namprd12.prod.outlook.com (2603:10b6:610:2d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 17:41:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 17:41:58 +0000
Date:   Thu, 16 Jun 2022 20:41:52 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line
 card auxiliary device
Message-ID: <YqtrYGobjgoJr+34@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-3-jiri@resnulli.us>
 <YqnyHcsi+GPVT9ix@shredder>
 <YqoYy/RLWaDd/6uh@nanopsycho>
 <YqrXvLY0GGCFLs4U@shredder>
 <Yqtc346Kd2AXEd/l@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqtc346Kd2AXEd/l@nanopsycho>
X-ClientProxiedBy: VI1P195CA0006.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 300d0311-9993-440f-6164-08da4fbf835a
X-MS-TrafficTypeDiagnostic: CH2PR12MB3927:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3927C5B9E5DB056284000A34B2AC9@CH2PR12MB3927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SA38INaASRTIa85dcDKabh4b4pv7gya3L32o71oZhSAc/tRULW6MToq6FhvNfrqCkp/l69WZGHD8Q/nCar3X9yeuMZGal1amAcbxs4MPssUUpjK8QDPgz7unKuhqavUTgISU9HW9596tvTaFRtUdvNx49W/CP18OAzVMQf81qlrLoKs199OWpPLqUeJpMzfR9/eiDbGv3Z+S+h2+8zNMfLITaKhsyyayuP0V2poEiy0fv7hSJtuY9+ciM9jkg5UH+jirFpxjKVZuCXrf5+L73h1rEBaMS2hhPIeBYSVhmousRH47zSE/BP7L0wBIdhw1Rr9gkpX/KFnd9hhC6DGgsYCHkGytMM5t3doEGGa6qlwOfLpcJIpfcigL+KW5/s/0D/6UBclrtXHZRmczuHv90r3nXUpoFRKXZgNYTKmrlH6j3TLYI+qaGO5w+p0AMgDQGUu9N1/n+L4B5dDiXvK8yBpi9/YYHVkdomu8JmdQy7P0K1VusIAGDua655RArWp3XkI4nW2cyOD3Lokmqfie6me0a2zZSEwgFfQyNHyEKePhqZ8JXmMDyC68y+Jc6DzntuTwyow1vNlEAKd9vIfOakYIRWmyudNEXrgU8RJXgbVwibdkrhX8J7vhULSt9FEl9glf71jaxXaYsEvVADkNSDBchIsh5EcZdY2XCPjg8QUIzVT5AKfwGk/a3irRt+bv+i8H65m4bfy2IPiW9MTIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(83380400001)(6512007)(4326008)(6506007)(508600001)(9686003)(107886003)(8936002)(8676002)(86362001)(38100700002)(5660300002)(6916009)(33716001)(186003)(316002)(6486002)(6666004)(66476007)(2906002)(66556008)(66946007)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rs2Z4RB9ZpbJALgAuj0o60PWnxQY+f5X9DOFkniJPSnYNeN+f3hb/jkF8fj4?=
 =?us-ascii?Q?ys3NnC8DtW5wjmq8OETgid0LxQGYOVPb+yA+5ynWdcFkaDqhJRGlr1i9TPDo?=
 =?us-ascii?Q?ujvOkJkeKQ390o3P1PBHqy+tQvOQ5YXz9qEeo9N07wnHeJEcPGYJi87lMH38?=
 =?us-ascii?Q?hKbxelpP7HRFVfGQyaCa7MHn5LWuH8dOZbnSVVUUFwLcbmnhO5rMf5AlY/IV?=
 =?us-ascii?Q?6fVF2Ru2ye2V92gis/swZNAK7ibH9+Dt15NairOI6kqOFWF0+poDy9eDJ9Sp?=
 =?us-ascii?Q?oISLFnMdoymyAXTyh5HguFuQYTbN8L0z0ogPLApv2bYj6rkaUxXaYymfwRRI?=
 =?us-ascii?Q?m/L/o7XJGpH1rzPeaw0E3D11LdBDdzVMmveLp8nV6aKpIDPFbU33CjNHzNKu?=
 =?us-ascii?Q?oHHtRaZFwnoqqDiTzYquIvbP7wpi/7xqvhl/F36bJ60Lnv9uaXrb9MmBw0Bl?=
 =?us-ascii?Q?AOgvLBXiNdhUlkb4eFAqebOxvshcx5bLNpwqvCYqIbTF25bVh5dqcQrUFxaB?=
 =?us-ascii?Q?MHHFebAoDrR/klGUbr6zIDHw2Cs/c7iCIRn7OTkWPhhtlYtk9gXiD6lC589G?=
 =?us-ascii?Q?RTH/pY7xbod13hh8VkF2Ed2T1P20vVp+MWxP0ktROrlDphfvuln+ALEf9Mc9?=
 =?us-ascii?Q?c8ldUiv0u23yqtizYcEFQ9ietWLeRQT/5bi9agyZprgTi01w4751cY1xBTPQ?=
 =?us-ascii?Q?8Ukjv6KK/+K8+kjnFXv8D42rp4t5EoNvdMg1TCaAietWONrrdv2bJza4PSNz?=
 =?us-ascii?Q?cymr4aWM3vT0WNdxB59d1hHLWSiowQ+iz8G+TUEJjPDlUzJLfyfpde3KLyyE?=
 =?us-ascii?Q?BY6fIRRuDV+riaiXgKj5p/dmXj0cEeRSK+2ZBK2kWLYx0aI66HdF/1tlOIRp?=
 =?us-ascii?Q?UemBrNEUVXSmrzt9DNUO65AOCJo+pF2ek/9xiVMXKnHWA3NqUFuAo1+JqhbE?=
 =?us-ascii?Q?imME2GnCdK3+evJzO3vEcZQ2rJw7zfqEh8fB13HDQYm585mvdnlhSLcEW+OZ?=
 =?us-ascii?Q?yMxjEbLi1wiytdfvXXjib+hRMQI8NWQ6uw7kfhZE+uFTEukVk/Q2K1VlkF5u?=
 =?us-ascii?Q?MygDaHR9MoVw2Wm0reuKUZeRBKf+S0TaukuvdrzL9LvJaiIfierBxOqX3rJe?=
 =?us-ascii?Q?giM05BKw+q4ApqPaPlasfNQ+ysSpe+dEtWE+FOoaHSnq1zP5mgwy4mfeyhXr?=
 =?us-ascii?Q?aHQthe9TJDcEJScDMB2tvxKksr6Ozv/2AAtLrdh4aDLDXl/3uyBs6lcQ30Rc?=
 =?us-ascii?Q?ESbWcYYqhWU9etwoMuOSMc+IeyN6NbN+k1uuNaN+nQiGMumBmJIBtK7VXS2k?=
 =?us-ascii?Q?UplDAM7UT2Q0UIJ7xGk5QfyirMpVz6babCa9h2jhGLPlgFKvQ9JIafHpnIHM?=
 =?us-ascii?Q?oqoBI5kGOtlMjvuC8DSYvJ6XwsWMT9v0WWYwPKI6JdWUC4sVt2p7HZSJVpL3?=
 =?us-ascii?Q?W1n/o9qmNW99+wnvijUVCWSvtLHfpupLH5TaQpnInfcxXTMb15vGUbXrY+kT?=
 =?us-ascii?Q?W4XRvv4dyN0N/zd2LY7aMFEp4GSvA5C8F1Ms5e5Pd+zzUyzc4T8tYzanutkm?=
 =?us-ascii?Q?X05cy41ifbjKHLksR+0/eU/CWveGpfHPaoOrz0b1uq5T285DVwl7yHE6lrYX?=
 =?us-ascii?Q?EXA7WVCiYi6DBXnZQsJ1sguE0VwoZNIWVC98UmBQ9qHC1Qd1xzIBQbf7LKBJ?=
 =?us-ascii?Q?63TmZjlF8qQ7nPug+3ogaqxlNzDYLtGGSjYE17PzUTLW9KPhPnogxnmuiBSL?=
 =?us-ascii?Q?aLWH9zTnMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300d0311-9993-440f-6164-08da4fbf835a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 17:41:58.8682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzYp8sSv6pKpoeUqXhtv2/ZJiyEvd9ISIedmgnX/sFaWotMFEHBI5GtDAZpNAuWjt39yksHWpOPUGZG0PNB/8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3927
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 06:39:59PM +0200, Jiri Pirko wrote:
> Thu, Jun 16, 2022 at 09:11:56AM CEST, idosch@nvidia.com wrote:
> >On Wed, Jun 15, 2022 at 07:37:15PM +0200, Jiri Pirko wrote:
> >> Wed, Jun 15, 2022 at 04:52:13PM CEST, idosch@nvidia.com wrote:
> >> >> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
> >> >> +{
> >> >> +	struct mlxsw_linecard_bdev *linecard_bdev;
> >> >> +	int err;
> >> >> +	int id;
> >> >> +
> >> >> +	id = mlxsw_linecard_bdev_id_alloc();
> >> >> +	if (id < 0)
> >> >> +		return id;
> >> >> +
> >> >> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
> >> >> +	if (!linecard_bdev) {
> >> >> +		mlxsw_linecard_bdev_id_free(id);
> >> >> +		return -ENOMEM;
> >> >> +	}
> >> >> +	linecard_bdev->adev.id = id;
> >> >> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
> >> >> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
> >> >> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
> >> >> +	linecard_bdev->linecard = linecard;
> >> >> +
> >> >> +	err = auxiliary_device_init(&linecard_bdev->adev);
> >> >> +	if (err) {
> >> >> +		mlxsw_linecard_bdev_id_free(id);
> >> >> +		kfree(linecard_bdev);
> >> >> +		return err;
> >> >> +	}
> >> >> +
> >> >> +	err = auxiliary_device_add(&linecard_bdev->adev);
> >> >> +	if (err) {
> >> >> +		auxiliary_device_uninit(&linecard_bdev->adev);
> >> >> +		return err;
> >> >> +	}
> >> >> +
> >> >> +	linecard->bdev = linecard_bdev;
> >> >> +	return 0;
> >> >> +}
> >> >
> >> >[...]
> >> >
> >> >> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
> >> >> +				     const struct auxiliary_device_id *id)
> >> >> +{
> >> >> +	struct mlxsw_linecard_bdev *linecard_bdev =
> >> >> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
> >> >> +	struct mlxsw_linecard_dev *linecard_dev;
> >> >> +	struct devlink *devlink;
> >> >> +
> >> >> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
> >> >> +				sizeof(*linecard_dev), &adev->dev);
> >> >> +	if (!devlink)
> >> >> +		return -ENOMEM;
> >> >> +	linecard_dev = devlink_priv(devlink);
> >> >> +	linecard_dev->linecard = linecard_bdev->linecard;
> >> >> +	linecard_bdev->linecard_dev = linecard_dev;
> >> >> +
> >> >> +	devlink_register(devlink);
> >> >> +	return 0;
> >> >> +}
> >> >
> >> >[...]
> >> >
> >> >> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
> >> >>  	linecard->provisioned = true;
> >> >>  	linecard->hw_revision = hw_revision;
> >> >>  	linecard->ini_version = ini_version;
> >> >> +
> >> >> +	err = mlxsw_linecard_bdev_add(linecard);
> >> >
> >> >If a line card is already provisioned and we are reloading the primary
> >> >devlink instance, isn't this going to deadlock on the global (not
> >> >per-instance) devlink mutex? It is held throughout the reload operation
> >> >and also taken in devlink_register()
> >> >
> >> >My understanding of the auxiliary bus model is that after adding a
> >> >device to the bus via auxiliary_device_add(), the probe() function of
> >> >the auxiliary driver will be called. In our case, this function acquires
> >> >the global devlink mutex in devlink_register().
> >> 
> >> No, the line card auxdev is supposed to be removed during
> >> linecard_fini(). This, I forgot to add, will do in v2.
> >
> >mlxsw_linecard_fini() is called as part of reload with the global
> >devlink mutex held. The removal of the auxdev should prompt the
> >unregistration of its devlink instance which also takes this mutex. If
> >this doesn't deadlock, then I'm probably missing something.
> 
> You don't miss anything, it really does. Need to remove devlink_mutex
> first.

Can you please send it separately? Will probably need thorough review
and testing...

The comment above devlink_mutex is: "An overall lock guarding every
operation coming from userspace. It also guards devlink devices list and
it is taken when driver registers/unregisters it.", but devlink does not
have "parallel_ops" enabled, so maybe it's enough to only use this lock
to protect the devlink devices list?

> 
> 
> >
> >Can you test reload with lockdep when line cards are already
> >provisioned/active?
> >
> >> 
> >> 
> >> >
> >> >> +	if (err) {
> >> >> +		linecard->provisioned = false;
> >> >> +		mlxsw_linecard_provision_fail(linecard);
> >> >> +		return err;
> >> >> +	}
> >> >> +
> >> >>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
> >> >>  	return 0;
> >> >>  }
