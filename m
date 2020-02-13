Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7D15C79A
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBMQNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:13:31 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:16129
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgBMQNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 11:13:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckTmmWO/avMSQQqDHm7zQgz1dtO3VUpUEmh8rEw+uI9Qix7qtQMUB1IGBywtb7SKKHjrtBc1zw/BXFiOkiaIjEE2LvPJO9MPHCri4ez+b8nb+m6tlDV7iIgOJiDXRfMWzpiAO7NjfLSAFW7rxiGSIui5fFfs30kZTmlpAuXib1WCWQ6kSv1PuwMc1sOiryhx2dTB4iYEXz1tY8rG4Ht0/imR5bbUjDDyEpivu9+KKlYaeIoeq03MU8MF6NSvSa91eTStgJO3wXaVcuuKE4K+5cBU1Uq9xHRO0ItPIIbUtVQDCsd44OrOCW8YeSoezEC5Z1f/tDymyAd/6cDudmuQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a19Z3rUgt3OUrEzgwWPfpZ3cX93HfzRrg/vLKakSmd8=;
 b=ek1d0f7Bie9aXG7sAY9zAeEJw3n/SXQBATc9f+pm0ItwvKEDzwBfc3T/K3eOYAzXdsvJFl4TEujxqyGZUprvx4W1UlyTBU5qBJklPmER11LsFJKlFNk/WaFkbE68gNube/Qhj977UNsWjMs8RG9E0WbePoVHiGd3m5Z94d4+q4VES8G7KnVn1/L+qdmHR5vSt0e0X7dRpKdVkYXBCFu2xqq1JoDK+/pwaKGJxdyLvD+19ZKWg6ABiEQgFp5k56PQlqS5e3XhmDmAmreZkudC9gqBnKlq2nnalFLgLSBn+BbtlW0jI04FZaE3qsOUQ6Zi8wQqax7eqKJCj5zSWRxKzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a19Z3rUgt3OUrEzgwWPfpZ3cX93HfzRrg/vLKakSmd8=;
 b=hNkwHQzD0ucOf4N5M4f2/6sagPWXkVGwneYXHAo9b1MOOFPJ0UzdXqzA6DWMe9N4gW+wYX2uZMTmtQuRtiUfob8JI7GfIuFVrG7xRu4hzCZqTcNjFqmoql+sC/1gZVs1ZnWMShHnoXeTcTjRu9L2N9AOU6F1kOqnqX8gKMSSCEg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6158.eurprd05.prod.outlook.com (20.178.123.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Thu, 13 Feb 2020 16:13:23 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 16:13:23 +0000
Date:   Thu, 13 Feb 2020 12:13:20 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200213161320.GY4271@mellanox.com>
References: <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
 <20200213105743-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213105743-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0077.namprd02.prod.outlook.com
 (2603:10b6:208:51::18) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0077.namprd02.prod.outlook.com (2603:10b6:208:51::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 16:13:23 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2H7A-00005L-4g; Thu, 13 Feb 2020 12:13:20 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab3753b7-0e90-42f5-e893-08d7b09fa691
X-MS-TrafficTypeDiagnostic: VI1PR05MB6158:|VI1PR05MB6158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6158A088A66609018CC529DDCF1A0@VI1PR05MB6158.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(189003)(199004)(5660300002)(26005)(9786002)(9746002)(86362001)(316002)(66946007)(66556008)(66476007)(7416002)(6916009)(33656002)(36756003)(2906002)(52116002)(1076003)(2616005)(8676002)(4326008)(478600001)(81156014)(8936002)(81166006)(186003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6158;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t85u1jEuRLXKF89gNesmocZGVmElu5SNrU0ENThwpU3Ulpk+aE64uALnixKpKX9DU2hsKdSZALmtRojfMW8Ntiul8BhthBZPDHDGjnKc8EtPAU+P/76OrG813j1FhwxHfjbggSHhLQQfNpFLXK3rCxSRUJlGsnwwK+Yw/x4n8aY9VojKFk03+VskFyDCjqaT3TPJg8ivLAfXvGPrd2Ia1tPFSWZ4syVXYedsHl02kQGBs2OeH9R1ZbqqajPNIRrOb9vjBMSX06L7cPipwRArMoMEv26uCQpuPhaLY2qy06qTRugwfcIpTc345KJZIJPg08Y8bHOdy4BSpcAzcoq6oXOv5/gIRzEE7sq2m2WoNTibW5WVXCQkt9XJKThX8aY6F147JuaA7S5blTBgrf+/m7XkMMEkUal/GtaKc/LVgFs6pgx13zGKj05WmLPdQ2JSTYZD5jKUSqonuRrbtS9sHQXcmLOGfOad5B5aVQlszmhSOFxZqhE5fLe6sLOGzft2
X-MS-Exchange-AntiSpam-MessageData: YxPV3JFWVWB/Vf8wMBcR+7cIOT3X2rPXCuwYvk32W/I15MQvyf3DxeEDQbpREQypaZoVsOzJhF99ab/ifxLr/dVZ4rxSodSS+NLiAokr53wtmUHfHl/mDZI9qZBcCLcSzEQ6HDpKdjuzAj5OEbYW/g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3753b7-0e90-42f5-e893-08d7b09fa691
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 16:13:23.8202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5fZcXUzs+R9SgQDN+TCdj/PEv8Uw0BOEWXfNa8HhqEfUA2yTYpOTyIrn4oByoG1OHSWU/onMXSGJEVsS1+jTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:59:34AM -0500, Michael S. Tsirkin wrote:
> On Thu, Feb 13, 2020 at 11:51:54AM -0400, Jason Gunthorpe wrote:
> > The 'class' is supposed to provide all the library functions to remove
> > this duplication. Instead of plugging the HW driver in via some bus
> > scheme every subsystem has its own 'ops' that the HW driver provides
> > to the subsystem's class via subsystem_register()
> 
> Hmm I'm not familiar with subsystem_register. A grep didn't find it
> in the kernel either ...

I mean it is the registration function provided by the subsystem that
owns the class, for instance tpm_chip_register(),
ib_register_device(), register_netdev(), rtc_register_device() etc

So if you have some vhost (vhost net?) class then you'd have some
vhost_vdpa_init/alloc(); vhost_vdpa_register(), sequence
presumably. (vs trying to do it with a bus matcher)

I recommend to look at rtc and tpm for fairly simple easy to follow
patterns for creating a subsystem in the kernel. A subsystem owns a class,
allows HW drivers to plug in to it, and provides a consistent user
API via a cdev/sysfs/etc.

The driver model class should revolve around the char dev and sysfs
uABI - if you enumerate the devices on the class then they should all
follow the char dev and sysfs interfaces contract of that class.

Those examples show how to do all the refcounting semi-sanely,
introduce sysfs, cdevs, etc.

I thought the latest proposal was to use the existing vhost class and
largely the existing vhost API, so it probably just needs to make sure
the common class-wide stuff is split from the 'driver' stuff of the
existing vhost to netdev.

Jason
