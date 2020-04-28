Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB211BD084
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgD1XPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:15:48 -0400
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:15633
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbgD1XPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 19:15:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2d9Tsne5nil3dJN8EAMuOV8azB1fiYGOnnqtKWW+obWRuKAVeIkCh7FOR3jWMDryqUWpsXxTsftTdKLzmEsuIovD3vQ5fykvK9nwVD28QukaiXFjICEclp8PZk8ZnO3GKIqfiDyJhn3UuzDmwdOrmbaBnTcQfPnMOu19hi6gq30cz4TzCwj+bVAB5oer9SDU7nhk3lHgWh5s8jv+JmV2Huzhupol6kfhVxQqNKJ7v8Ai2BG0GQVahKNkbhXXny702VaiueMHAXX+P5AXPQ9D3jtf1oCA0JljN+D21HoP9tdMJHSknBMn8O8NvloOWtTOnPV3+NrADB6tIMzrLqs+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPDaCJC6i1il6F6vEj+tYs5SZArVzVUHzVFLwOZFS/Y=;
 b=I8sIWtYJywJ5alIJypBADerkwjm1SThEbCzIHrwOLt2LzxoSE7mAcSemBOgy319KfwyU+ydfn5SnKV2YXAiAHuxIFOTmqIFz1Z1oZsRJZ7gNvPXiOpN5WNeFMCYfjgdfZg3ONBNWo6lfCKaOhrYYPMZM9dqpfSL+DwuQNTXLufW3lGDsZHnTqVwgMR81tGFSco7PRCNSRPDc+/sN4krMTCMtqqzxggpqeQ4rOTTtKs8A26gue2sdgFaz3hryvzmdAgpzn4F/HxJEB+pZ/EAmOkXyO/oCeFujHuo/kT2lSDcZSpDHIOkMCOfjGEoOhImULuiBskIQsr65LM7N73uxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPDaCJC6i1il6F6vEj+tYs5SZArVzVUHzVFLwOZFS/Y=;
 b=DITGbWw0cusi1Esx+U2e9kHFXi6QgjdvO4JlIij7ukcFHhl8JtgrJI1MFGZqeC/KtVxSS2rsjg1jT0UuDqe83Ew+Xj2DP+f0g4/7nI9i0QYdaRUDOZE3VGE1U/NUdzRfWSd4EtghALiVX62bLJN6a0/0osbhMeYHG3C0IutDBIg=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6829.eurprd05.prod.outlook.com (2603:10a6:800:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 23:15:45 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 23:15:45 +0000
Date:   Tue, 28 Apr 2020 20:15:42 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V6 mlx5-next 10/16] RDMA: Group create AH arguments in
 struct
Message-ID: <20200428231542.GZ13640@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-11-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426071717.17088-11-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR20CA0046.namprd20.prod.outlook.com
 (2603:10b6:208:235::15) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR20CA0046.namprd20.prod.outlook.com (2603:10b6:208:235::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 23:15:45 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jTZS2-0007wM-CW; Tue, 28 Apr 2020 20:15:42 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed4a7b87-3e29-4a60-d497-08d7ebca143c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6829:|VI1PR05MB6829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6829D4B1A01D09C49E6AAA93CFAC0@VI1PR05MB6829.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39840400004)(366004)(396003)(37006003)(478600001)(2616005)(4326008)(186003)(66556008)(6862004)(66476007)(316002)(107886003)(1076003)(66946007)(5660300002)(4744005)(8676002)(9746002)(9786002)(8936002)(52116002)(6636002)(36756003)(86362001)(26005)(2906002)(33656002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Azr0JKDe6zk6wXFLt97owOusfnBSSu+81VpxncmK0ts2LVawcA7RY/yLXKq1kJVtVpg+PBi3wVdXs9WyP29/prt/tR32jRwzVkkNXTXTzb3BSX9kFEy/y6bRLY9yerhpdi+MAcWy8mug+1NxVVGvcLPbaXzsO8aQ+c4B+LbduKhcoyCqb73tgH+FiRHzUv2z5SWwpOJXza6vUq8BNNMQUzPjoadzhbgrhLI0NVP7TMztgDWvZnB127M19H1MUsqAAX3oJaRLD5OEyRFuLqah/OsXpcTidwXoM6mrI4XlJf2ONVgco9O2euWJ2YO2g2DlWpmlzEBCydpVZhmpb8CgPhx+0Gc9FvexF4eg8TMaCoII6VogcSD8zm2w2nlUUG7jJeUXzoKHJtIjf3pZkfZlM1zLvdtiaSXp9p8CMpU6C0/mta1jVpexm0G6Pzg2wGjvol8vfpeWfBCmK70nr7BnkKaqaVHc5G/64liJgQQ4eb0S9Nqdot96BQ+T+3Whyz1r
X-MS-Exchange-AntiSpam-MessageData: OGYt1y57n/d+dk64HvI5JE6KY6f6EEIf8k+yhAIKgUuIRchXEHzm/DzTw0WIGi+frgvJXka+4WTl+H/9OMqZv5TaZkvl8KoWFI3UhpWpatCYNBtfuxZwVwCdL+eMI/Y+z1BhaBdCT+C/JIMK4BsEckQz8NQLcCdsQowC1GPYm+Be/jN04y8vBC5rgDsS3i3WiFvr7dYbbhb2GVPad41BrEN6/meZiazysLkTGWKXCb5Hypcbt8gAj31cRpG4CYOBr70lVXA+4vqw2/TyCoPlnnoLHTpsXbI4fKdxbdM5sRBFcKwUcAP3eQ8ctjgh4V2g+AHAlPyGxSC+812ibu/PRiNButPxjbfZ3WnQ2XxT7zSCG4feBPUpxcP5vILlJo3xYdAZUaUkmQ7VG1T0B1MSy3935BFvM6UhaIauMCm+1vAP7viz8ftcUFwehF/BNz2WtoOww8vEyV3EDtxr/xD7mo5WHZc5UwedGeazWrBqvOl3UBU0cld9mzuX10S03aphHefoXv01iHv5Uo/wLHOh/mFvdKrPSb4f61SDDyBvZj/2wJXcsLxS8GOd4t3YJYBvYZdRr/Zew2JHuZJQCu+mOhtyXqwDHajmQyzRBofV1l+uuEpHmT1eq6cKAyEF42QRI64lXKN7D0lmLd0mYP7Slk/19iZbhO92Cvz73HmzzQXvLKlyfJ5kMDBcf1ePPVAWR6gBvxrQOt4DgsmadV0KLtMXiiYCni8fLNuX17kcDbhkb1iVu/PB7Okp7x1oNK7KaSvVEp15yaW5O4OCvf6zazssXwxbpk55f1X0gBTpWpQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed4a7b87-3e29-4a60-d497-08d7ebca143c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 23:15:45.3835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkOtCIZDw3ewS/STainZrRHRZTV/GqP3ra4s4pG6WqDR05tJNEEOKvUCjj4GwHaKytC6ouk7i5pY+YJyDxvtxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:17:11AM +0300, Maor Gottlieb wrote:
> Following patch adds additional argument to the create AH function,
> so it make sense to group ah_attr and flags arguments in struct.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> ---

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
