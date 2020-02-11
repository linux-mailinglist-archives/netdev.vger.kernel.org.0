Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0F8159041
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 14:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgBKNr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 08:47:56 -0500
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:3041
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728921AbgBKNrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 08:47:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n755TQjlEVqPvIX62y/oEPA7hjjo+EeBAOAaA1f+b5jX3eQOFYy5lFGWTRQHtRU3iF2RsGk40bYlQpd5bnMXMSn0lRujRf+HqP2/KXzT54TeNubVdD5R26y7JZAUKB57drEAT4T7r4y+BOF0oJ6DfzPpFhVwRHCy/JZxJWjV+mcttZXEjeNlS90ZkxaMwHYWFvIUwPkYngJxeUacWdYi5SHmT9vrJ1UH4TjZ1HLmDMECPSi9gux8ALKhXcEfSs1R38ds0O9LUDI0WJu1jLv/ZpU0nJn7Wc1lvwdy1aYvhi/QzVDNNboTUXGdfxWvNYaxjrPjSgW52mYeOQnB9xmwxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3RViT7jx3uOhpwUikxYveBcgiP7xloyY/aoS0FZppo=;
 b=CswdyqbQIuIPCc+QniHLTdsxyR0w3VMOu21lxSpA5/iR6PlpjSFj92z0sVn/k4P1pe2yAt3ZpDcAAD84JmgKaCWBtJ30NoAsptuqlirqCwoCZRFfZIxeiJzNEEniJW3RFCoJ2Xl6ik2U7sQNBPBdSd0AmTKTxY3gNwDUz+oPGsRsVK+UCdD97jvgbbc1a2WdsvYRjO+413a4zWrrffqpXdXCfBE/CUe47C2H/0ONu6eOdlObHsN7PWMc3rtMW/46qDsWuWzy0gWXAWZzgmjJgdUs8jD17I/oCnyaqg4xSmAlnKHSdTf4yopfS5dIjkVVlBSKybaFZ/0BEp1xKwzPhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3RViT7jx3uOhpwUikxYveBcgiP7xloyY/aoS0FZppo=;
 b=MsaqThPx2Y9JjAol+eTgDcT2ESsF8gGhJA7lpHWoZR7o4mPdG/jO7E8T9yWI2casiXsFHClwaDc5fEOYMGwk2jFzCn6uti6FevTvrffTF2W0l47Wz3dkQ0U2Zhzc9ez1qBCL0zG0AbtxJxfyL4A0X8sW9ta1TkwdfbJn0x6nyR0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 13:47:50 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 13:47:50 +0000
Date:   Tue, 11 Feb 2020 09:47:46 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200211134746.GI4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210035608.10002-4-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR14CA0020.namprd14.prod.outlook.com
 (2603:10b6:208:23e::25) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR14CA0020.namprd14.prod.outlook.com (2603:10b6:208:23e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 13:47:50 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j1VtC-0005NE-JH; Tue, 11 Feb 2020 09:47:46 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80ee99ac-9a8d-49ce-870c-08d7aef8fc2a
X-MS-TrafficTypeDiagnostic: VI1PR05MB5102:|VI1PR05MB5102:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51025721EE5118416576B579CF180@VI1PR05MB5102.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(189003)(199004)(316002)(66476007)(81166006)(52116002)(66556008)(81156014)(66946007)(2906002)(478600001)(86362001)(33656002)(7416002)(5660300002)(8936002)(36756003)(9786002)(9746002)(186003)(1076003)(6916009)(8676002)(2616005)(4326008)(26005)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5102;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T23A4tiyjVXJsicFKnT9kc2z80/eaJrG8sKW27M5UJ4wF0zAgBJeeQ6wuJdOhL9009BfyYVagtB0bTr6i/991KT4kshFzoHVrNYKY3yNyPI5XWX6GSx0xr7Bhq3chncHLCi91R8AOyEITFJUJze1YcCy4eFimxAAwRCHc8koDe/+8coMcwzprVbTKXSMyUYydTFvwYZYaAD1VSlQzFlAxZDONf6pwsMuOt6QrWPqEEwTJyDG3ZGEd2BN9Pd0s8rXUg2/dwkO7TWRPszxV+nufywBukdHtJ1++QO2wku5Ew+Pj9WCu5o6hYJSgbMIpHAgtR1kToAmoSEbfA5l9z/JTie8EqVv/JnFL/xobghUAaBlj5L4q7rz8rF5bDe6sHF89fHwe1LmUJHy2smi/gSnzbvVwfp97zVlTaP0iNmnaMxIToiQM3fNftV3EGy1QhT0XqMdnu7v+ynIY7ATDbgdOW31VCOLHFgbHdxlluVGAv/Dks5osei4Bh9+4g8ymq5Q
X-MS-Exchange-AntiSpam-MessageData: OJ9PUo8SwnxMuhdfmsVM7okmDwwE6acVEU5RJvCFAJSDZFDGjKnfCnb7WurfyPGmtRjNGji1Q6D6moy+juXIbRTmKrxnbvl2MhjcLKdIVEdjcdSwjxxqhAPoK1HxZDZsFx0cRHDcxCtc531usVvS/w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ee99ac-9a8d-49ce-870c-08d7aef8fc2a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 13:47:50.6309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SnG/tU9/bEK0bYQNTdUWz6LkEzEOPNxy4la5azD6WHfAGaKU8AdkVEueLk7pQEw9ADajrrWJ+Ul/7jVRWUsJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 11:56:06AM +0800, Jason Wang wrote:
> +/**
> + * vdpa_register_device - register a vDPA device
> + * Callers must have a succeed call of vdpa_init_device() before.
> + * @vdev: the vdpa device to be registered to vDPA bus
> + *
> + * Returns an error when fail to add to vDPA bus
> + */
> +int vdpa_register_device(struct vdpa_device *vdev)
> +{
> +	int err = device_add(&vdev->dev);
> +
> +	if (err) {
> +		put_device(&vdev->dev);
> +		ida_simple_remove(&vdpa_index_ida, vdev->index);
> +	}

This is a very dangerous construction, I've seen it lead to driver
bugs. Better to require the driver to always do the put_device on
error unwind

The ida_simple_remove should probably be part of the class release
function to make everything work right

> +/**
> + * vdpa_unregister_driver - unregister a vDPA device driver
> + * @drv: the vdpa device driver to be unregistered
> + */
> +void vdpa_unregister_driver(struct vdpa_driver *drv)
> +{
> +	driver_unregister(&drv->driver);
> +}
> +EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
> +
> +static int vdpa_init(void)
> +{
> +	if (bus_register(&vdpa_bus) != 0)
> +		panic("virtio bus registration failed");
> +	return 0;
> +}

Linus will tell you not to kill the kernel - return the error code and
propagate it up to the module init function.

> +/**
> + * vDPA device - representation of a vDPA device
> + * @dev: underlying device
> + * @dma_dev: the actual device that is performing DMA
> + * @config: the configuration ops for this device.
> + * @index: device index
> + */
> +struct vdpa_device {
> +	struct device dev;
> +	struct device *dma_dev;
> +	const struct vdpa_config_ops *config;
> +	int index;

unsigned values shuld be unsigned int

Jason
