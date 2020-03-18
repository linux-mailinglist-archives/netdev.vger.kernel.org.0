Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFB1189C54
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCRMzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:08 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:62957
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbgCRMzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 08:55:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYWUIkcj3Kj3U3Tt0EuWYdGVh5g4Lwc5vlfHMqLL1lYIJUxEZgaWqLekMDkpCG2yu3NyQHUDHHLq3Oj+hw9yzIFUP3EAaE9WYh6Gzcwulqs2XQ3DtY/mPFGXtAjuaiHouRDD4gafekImlcTOYQ1xk1+0hmn1+EcJehH3RtW7x2FOUY9iIfvpWH7TUisACJhAeNZibF7npmeA4RsJRWH7VeAOaruB6wtCiu5kqHZUXpgsohfM8OLsYlK1BjaNkSlCcelFwR04dQFojYkpcQTWq0TMUVKpINeHm4peN0r9JAeFJTVK4ZNFhYD2NOn/qJC5e/WeYdz5P5sDiATfA0Vf+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LaL8hutKHGnH4r18ajhmXDOhDPoTBI8b+aF3WEJNvw=;
 b=VgMMda6bdpxI1abdJwlYFs2v1oLnvRqV4tvRtD0GGys1mLA/x8yLEJujsPmN24CnjLKWoDRN5FazE4F8elsNgMwmiwg6F6BA6HjWZ1HpEDC8is/p/+ED0zCx+AJRo1S2t1AQccIysuTRI0HcTazorcTMvhtqnpClveY5x3zo5SZvWXWBlS+gRW21Ox6hpvcgDW/eZy1vtvm8oKK4kR9Hhgd7lxe4dIr7ZHgFazIqF+pJ7PwVa8CjqQTWdlpNutuIsaeWH8PxiaYmiGgMlVJgqyg674aBt+g8HSahU6dqyzcLzNvZHVnjyZxGwy4GHjopwSYwlCCze7A20t7xi7eHSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LaL8hutKHGnH4r18ajhmXDOhDPoTBI8b+aF3WEJNvw=;
 b=P5qdxkh+EQ97zVXLH7aJKxooVHnaovYyGuF3FaKchdA3wmLB+s2opCbPFpFNH6ydn8XguKC8shnVoTs/KCbkdSJelP7B2gZvn92R1ImzZdkhtJraD/xQC60zEFJc0gA213v4seOPOvdhAfljCMYfotrHY2I6xXlv5x9bHbVZBXk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6350.eurprd05.prod.outlook.com (20.179.26.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 18 Mar 2020 12:55:03 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 12:55:03 +0000
Date:   Wed, 18 Mar 2020 09:54:59 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318125459.GI13183@mellanox.com>
References: <20200318124329.52111-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200318124329.52111-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR01CA0049.prod.exchangelabs.com (2603:10b6:208:23f::18)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR01CA0049.prod.exchangelabs.com (2603:10b6:208:23f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 18 Mar 2020 12:55:03 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEYDr-0004Zs-QL; Wed, 18 Mar 2020 09:54:59 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6847729f-6aa5-47de-681a-08d7cb3b9368
X-MS-TrafficTypeDiagnostic: VI1PR05MB6350:|VI1PR05MB6350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6350D60C426B7E78CD34DCCFCFF70@VI1PR05MB6350.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(199004)(66946007)(86362001)(9786002)(107886003)(9746002)(478600001)(66476007)(186003)(1076003)(2616005)(52116002)(26005)(54906003)(4326008)(2906002)(33656002)(5660300002)(316002)(81166006)(81156014)(8676002)(8936002)(66556008)(6916009)(36756003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6350;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sg9mwugB2t55EGjSYpwPx5FOwE91G9/+6m5sl2NC65REJY6XSDQlpuSb28haaS3c0J/tsksTSk7YLzwhhv2fflw9Ogz5245+LXbdGQtsIKWk7wu8O7bIrtNEn3wl3HOkxVHLkCXd42aSsaAA5y8RReQGX3AbVNgxpNoPzcTPfArMGsR7daZ5dIDipZchmc2sxIdn+BDkvt8eks8/j2Y8CtCd+rJuN0snPIZphFLPZZrI6aUj4VOCkYKZ5Twn7gGqtDDYBw1KkIu1ppL3H9+Bj0x/dk8+7nrC+ebZoEo1inWjEpYB/9P35C7evP/MJtKoWRVfKn/ic8l0xHms7KihjVXgqXm9Q9S0WVgrHVzqwlioPnhLtB/glkP2u+0jNVeMcm5V3kRUzLD89SY3R8ivPG/khI/VZhfcOf8XWv+bFqDaUdPcJEIrA5Yc+WcIbt/0WsU96Mlc7v0JfX6NYFXXB6AX8YqItNnp02oYGPPZm+revlhydEPavXSnMT2bcPzT
X-MS-Exchange-AntiSpam-MessageData: J3btn9XfaNaCVnPomuUIV/eSJnB8QOqKp4djeKhcUkEgm99Qh0G4bxOm/2js75S/eotjL7hg30140qRsCqPNIPIndlau2LsyTJNG7nzMFinmOYiXpD9r3XLj4aXRV2JKjh2cQb1gnic4KJcgKvR/gg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6847729f-6aa5-47de-681a-08d7cb3b9368
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 12:55:03.4005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bol06R9uoR8fmJBMrOOb6kjVDt/m6VvvHBX96x7HAUsLfXeOLUdj8ejUVdrJpypLfni1cb1bsAze+/vJijkTzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 02:43:25PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> From Yishai,
> 
> This series exposes API to enable a dynamic allocation and management of a
> UAR which now becomes to be a regular uobject.
> 
> Moving to that mode enables allocating a UAR only upon demand and drop the
> redundant static allocation of UARs upon context creation.
> 
> In addition, it allows master and secondary processes that own the same command
> FD to allocate and manage UARs according to their needs, this can’t be achieved
> today.
> 
> As part of this option, QP & CQ creation flows were adapted to support this
> dynamic UAR mode once asked by user space.
> 
> Once this mode is asked by mlx5 user space driver on a given context, it will
> be mutual exclusive, means both the static and legacy dynamic modes for using
> UARs will be blocked.
> 
> The legacy modes are supported for backward compatible reasons, looking
> forward we expect this new mode to be the default.

We are starting to accumulate a lot of code that is now old-rdma-core
only.

I have been wondering if we should add something like

#if CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION < 21
#endif

So we can keep track of what is actually a used code flow and what is
now hard to test legacy code.

eg this config would also disable the write interface(), turn off
compat write interfaces as they are switched to use ioctl, etc, etc.

Jason
