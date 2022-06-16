Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCE054DB4A
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358768AbiFPHMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiFPHMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:12:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31F52B1BD
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctuJBo5Sje31ysQi88Ymo8AFLzquVhPjtenFiBxa/z9ypd2xVMiIny5TOlTjKIPTgBdmGXnGV8yISD3zKP4krVfFmtzfgYtrZGwxjNYfCd8SdsNBTpMSqnC0nQanPHyIvuPrG2WYrOAcO7/wDQWaxDuYVkAZ+TEg5lWseNFDNE/n+N9woBWyw4UjKBBOUIBHLikBsncE9/axOEa5PcNOlY1VJszzIlo7/uVoas7uVk4g9g6/IxHGMwiw9KC5EkSknqqiXN+BGxAT+nZOp84ginUr3CIBZOce4QkT3OKFuEvCEsXUScmxxteoTJzWMXyhywrJSYSzWjmF9meSf0/onw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9JTcdWJldxXxMfKHNPbpvXmGG2yDe43mhVj7IPgioY=;
 b=NEG632D3hXKSDOa9ZxilCm0nfE1dF2G2S1kNkzYKchRyJY9C+M7q4lkZL0hD9H2bv64V1EYNvXekqpre17Fod/RK6VtKvrIsJF23m7ITaKEkIO7dlxRKdr5NlBkINGoEpDrfbjbNoClFhGvoXF3F5wlpcnQfwHVS9y0qEbflLlcN4gdVtBU1+2JUX9GgsM5vJ4pda3nfRbiyhsmoU0el48e43hkZTe/jJ43jK9AvbPtCvkAp0fNjBpOS4GmITsdkyzURkLbnH+YjGg0dXtvPE0DkHhxA0UvYD6+SNA3p+TkqDi81n8SKv0O0BokVlXxzwt/B9fyRzY1IUMY44NrXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9JTcdWJldxXxMfKHNPbpvXmGG2yDe43mhVj7IPgioY=;
 b=X1MHDdfimNn+sMsKfOWA+CJK7oWV9IgA7VQwSdMoRnjRqbt+eN+WAV9/E1ziWcGFlmeHl6d9mCHDd47SVS2Dg1NqmM5oQsHFZTGtdrsWK6liTsCVzD5bl769uoDklo939gUevs5tCqiuqHcPWUxkO96296LM3swVcdZHbxPFAbJZi9zMGysH9BNq9/PV1RN6WGKhQ7ZlScQ/OVeTq0RRt8r1Ry0nY3eJNjPF5pDn524rPwowLgWD9JMSG80ML99yYPfkLRGPFLF+Ak8JelRO/giEOHsrNnaDlHj+0K7xbamVztYfBcB5nXrhjxUAMoek5ySPQVuwo6n0iMmhH0BoGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1468.namprd12.prod.outlook.com (2603:10b6:4:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 07:12:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 07:12:03 +0000
Date:   Thu, 16 Jun 2022 10:11:56 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line
 card auxiliary device
Message-ID: <YqrXvLY0GGCFLs4U@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-3-jiri@resnulli.us>
 <YqnyHcsi+GPVT9ix@shredder>
 <YqoYy/RLWaDd/6uh@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqoYy/RLWaDd/6uh@nanopsycho>
X-ClientProxiedBy: VI1PR0102CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::45) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bdde2ec-4d41-4805-9b35-08da4f678338
X-MS-TrafficTypeDiagnostic: DM5PR12MB1468:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB146884ADB2D08296C1819876B2AC9@DM5PR12MB1468.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ws7g1gNqDzfJQxnAb+fKfDH4TuYFRWrZGFyZcv7+yPoz0k9oRsxLfvqMI8fYF4BHNeR7erZc4c6u3cUo2LOy2EzR3tR+Mq50K1q6AF4Ft3cP4g3TxERhUhCeT3ac5kBJRspjTqB/RkrIhb9Vg12fUdS9jQCja8+LZ0xE/PXbfOMvegEo9XlTAthGXuSWjV522huUfGaxQ8+Xtwj4M9pXlhsYtY0vot0PQe75qhjyDwfrxTzie6i3yAyHxcTcWN5TyyNkseG4mAVSlcPKKp/jqiTWOmoIaIetTBkdctF3SLYJRgXeHzAKFzN6P7QX0eCfIiRz152oVZaIE9W3zmgzND9+WQC5EyWobspwIJZ1702QcfwOV1UTLOiJWpVyjcRMKIDw0o+bQtz4VxCIGkm8iNVlzoD+byhj/SGtJzAxd53k5gQBM4sSfiqT4zMpNX+DEh81JKQ9CnFGQISKpwAKzprgjwvKWDiNS8LqYZMP9JFjyvfeonjgg4iRcThdo7J83MoDCvstThkMxHZIQ0OTfakk7OTDUGYvDW68uZaJKbrabRiEzx6KgSzXQ3XvLcUa/6RvwR4gI2Ks7HFIs9jStK/WA/pgvo2DTL/tDgg8pWPtwRIX9/sMfKrB26rtbWtMwbrFSBDx2qQmPrKPvhq/TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(38100700002)(6916009)(316002)(33716001)(66476007)(66946007)(66556008)(8676002)(83380400001)(4326008)(2906002)(86362001)(6666004)(6506007)(5660300002)(9686003)(186003)(26005)(6512007)(8936002)(6486002)(508600001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7eH0iYFi9PZZByq011goyWTbofA23yaVKWnsejBDUQLG39qwAKtACbaymvbH?=
 =?us-ascii?Q?4WUbYrLb/2V+t2iTqOHeN6wNeAAydUgGnhPJhlWuTIKVma7moTAhQbHR5Erq?=
 =?us-ascii?Q?J4eGbvdq0QNHzuB0NoMw30LoRCnoaGSj5ZDAOJcOYdby9Um2K60IXwV7spy8?=
 =?us-ascii?Q?P6hqs8iBhHEEwQd68/1ufG9Q46cwAx3oqJ0RwPNoTXhBV1ShjWMdUo+2+Byk?=
 =?us-ascii?Q?dBni0YSQXUsZuj4VnuNxtbpYNYAICc4Wxg8uz5jc1jJn2vNokYt+be44MVEH?=
 =?us-ascii?Q?QbG9YnYstZEEXtJtHlwjYzR5nl8YsJyDTHDT6i1EW3Zw1K9blfWAiAHaU5ZE?=
 =?us-ascii?Q?Tt59goyd3DD2RDr3IIMuHnWfERzI2RhGgUt/MmaXRvYem7iKj3woeEd97ZaE?=
 =?us-ascii?Q?9cIxUFGddaG5QRpVKyo2B2e1Qf/hcUeWOP15LIB14ncaVPv4SClS7fUySzcy?=
 =?us-ascii?Q?5b4EZqQxVGdWMfYdxnLfxM/J3TH6RbCaFMsRdSjdL0uh1CsNJtliHqd0kdHE?=
 =?us-ascii?Q?37Och+BHusib0AfJlsIT07Ng4wTK4rQ4XF88L6lRokqhug6YxW3S3BvQLQPi?=
 =?us-ascii?Q?cKTpBTs2mcCrBRKubeqtMxYkIhWlQaQhpQiV+PNA/qvz94JqfBO7CUvw6rLy?=
 =?us-ascii?Q?r764vXe1njuBmR9rT/Vw63bEP6xIJx71cPRRKKdQVz8dyRmLxyg2uw3VVpGd?=
 =?us-ascii?Q?lLs7yTJPI/A8lsKDJT+X5hnUEChZRPPxirRJlzCiDecwYxTYTm/R8srKcfi4?=
 =?us-ascii?Q?gIfwBp/ePdOo+CRX0Ss08apgeUKaiD6SzBiEzJc0JX9yvetPtww/OtoKyFxu?=
 =?us-ascii?Q?0tvSf2mUr1Le0KNohsI1rpA/JFHgnmoh5oovr/+JFevYptqSrvs4dQ8B7j45?=
 =?us-ascii?Q?+uGAPnobRx1XMT10DwD+5Lf13EOqXdF2OsDZ21TKPZbPwH+mZR2Y83CCfb6r?=
 =?us-ascii?Q?LV9+1IWv2uXSDkmaO6piCKBKHAet5N8qd4ekGTLrt3fEVfGesCcr2/0RlEO3?=
 =?us-ascii?Q?PA2ngFCXetFErj4rJBQUXqrINboiDTQ2785AjWITQ1002mP4lxdw8/nH1BZH?=
 =?us-ascii?Q?gIuJ54FCiPWX6EUDLaXTP9uVy0ApqeshsLPVB4HWwVb8oZQQ9dKGs6nBxtYH?=
 =?us-ascii?Q?1dTOd/rURcuOxVSoKJdVtf0PU3adRpRGNWHasnkmm33bi4ggErMwjtFXBZ5Y?=
 =?us-ascii?Q?+LcHWVNtDyxS4J0g/UOAQUKx9fD/UFM2sWyHV+ZbIpsMSKsPedKq5fY0nYX4?=
 =?us-ascii?Q?k1SBtGjqLNuUHk7/+Lry+qy3K6b6Xt5u9oRY4TE45GeJXodaG0qOWAJSSaV0?=
 =?us-ascii?Q?PXCyPTNCXS9bSQnf0d1Gmp62fZU2YT5bC7sT/fEGEk4cuSDPu0t8/jYesbiU?=
 =?us-ascii?Q?hESsIcoXRF38NMo8FfNOwK7Xrsatl2aHp5mPBc0IHaJJpo54mwuVqyXS37uL?=
 =?us-ascii?Q?TDJZTYS+BRWBQZ+KxyN8HN3dKfyqx5KvJWaF/RrwcD21wnbjB/xmbx7qg/ZB?=
 =?us-ascii?Q?c9n4w1V2CnYnaHwML9wlk6X/HGX7OWooJqoh2SXqBwY3CQ3SdVq94QMOsyLU?=
 =?us-ascii?Q?4/ao8pQ6s3Zkk7YwaXOEhfB2BF5eqM3iCjZubFPj0F3jPj9TWiYs/VRrrls6?=
 =?us-ascii?Q?j/nQZLbovq1Mx2PYDTfXa1p3UIvIncyY+BDz+mOOGdpKE5zFTTeH1baZMjow?=
 =?us-ascii?Q?eodIzjS+X3QLFHNL5/hAhN1y0fRbDYuIrQWsdiM1EdxMKdr8ey/zXYdbgXqj?=
 =?us-ascii?Q?nN/u03mzQQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdde2ec-4d41-4805-9b35-08da4f678338
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 07:12:02.9347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJwdIrjdtwQXRMBpkMzCH4+LdivVcIjbwF/LwxTKNuDQkTMDrf33ZdTF44jCXAU6mhXDQqr8yEOyVtU3Jj7uKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1468
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 07:37:15PM +0200, Jiri Pirko wrote:
> Wed, Jun 15, 2022 at 04:52:13PM CEST, idosch@nvidia.com wrote:
> >> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
> >> +{
> >> +	struct mlxsw_linecard_bdev *linecard_bdev;
> >> +	int err;
> >> +	int id;
> >> +
> >> +	id = mlxsw_linecard_bdev_id_alloc();
> >> +	if (id < 0)
> >> +		return id;
> >> +
> >> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
> >> +	if (!linecard_bdev) {
> >> +		mlxsw_linecard_bdev_id_free(id);
> >> +		return -ENOMEM;
> >> +	}
> >> +	linecard_bdev->adev.id = id;
> >> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
> >> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
> >> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
> >> +	linecard_bdev->linecard = linecard;
> >> +
> >> +	err = auxiliary_device_init(&linecard_bdev->adev);
> >> +	if (err) {
> >> +		mlxsw_linecard_bdev_id_free(id);
> >> +		kfree(linecard_bdev);
> >> +		return err;
> >> +	}
> >> +
> >> +	err = auxiliary_device_add(&linecard_bdev->adev);
> >> +	if (err) {
> >> +		auxiliary_device_uninit(&linecard_bdev->adev);
> >> +		return err;
> >> +	}
> >> +
> >> +	linecard->bdev = linecard_bdev;
> >> +	return 0;
> >> +}
> >
> >[...]
> >
> >> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
> >> +				     const struct auxiliary_device_id *id)
> >> +{
> >> +	struct mlxsw_linecard_bdev *linecard_bdev =
> >> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
> >> +	struct mlxsw_linecard_dev *linecard_dev;
> >> +	struct devlink *devlink;
> >> +
> >> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
> >> +				sizeof(*linecard_dev), &adev->dev);
> >> +	if (!devlink)
> >> +		return -ENOMEM;
> >> +	linecard_dev = devlink_priv(devlink);
> >> +	linecard_dev->linecard = linecard_bdev->linecard;
> >> +	linecard_bdev->linecard_dev = linecard_dev;
> >> +
> >> +	devlink_register(devlink);
> >> +	return 0;
> >> +}
> >
> >[...]
> >
> >> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
> >>  	linecard->provisioned = true;
> >>  	linecard->hw_revision = hw_revision;
> >>  	linecard->ini_version = ini_version;
> >> +
> >> +	err = mlxsw_linecard_bdev_add(linecard);
> >
> >If a line card is already provisioned and we are reloading the primary
> >devlink instance, isn't this going to deadlock on the global (not
> >per-instance) devlink mutex? It is held throughout the reload operation
> >and also taken in devlink_register()
> >
> >My understanding of the auxiliary bus model is that after adding a
> >device to the bus via auxiliary_device_add(), the probe() function of
> >the auxiliary driver will be called. In our case, this function acquires
> >the global devlink mutex in devlink_register().
> 
> No, the line card auxdev is supposed to be removed during
> linecard_fini(). This, I forgot to add, will do in v2.

mlxsw_linecard_fini() is called as part of reload with the global
devlink mutex held. The removal of the auxdev should prompt the
unregistration of its devlink instance which also takes this mutex. If
this doesn't deadlock, then I'm probably missing something.

Can you test reload with lockdep when line cards are already
provisioned/active?

> 
> 
> >
> >> +	if (err) {
> >> +		linecard->provisioned = false;
> >> +		mlxsw_linecard_provision_fail(linecard);
> >> +		return err;
> >> +	}
> >> +
> >>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
> >>  	return 0;
> >>  }
