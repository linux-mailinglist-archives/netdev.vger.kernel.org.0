Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C01D097E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgEMHGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:06:07 -0400
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:30359
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729199AbgEMHGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 03:06:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9hbu/Qf0lj91l43jtiFeokYFOCrrZg/jGmel71HbSAXXwcVBrY5iZxC8t3mREvpvTYh3C9rRQiYbT2yffvvu3lLk5g78YF+sg0D4kD1zYrA+pkwf8u2rl5toaLpidDh9h0DFNsUc8nyGSjWyoBa4C9iNX4+hLfe2TYHOOHRF8UANqq8kRBTELRvCKNQ54QTndydZbtICpN+b/rYG+7Y/Z7nKE3mP3WumrwkKyfOwDb1LZIm9QxW+fz9qxnOrs8VQdWTZ8lycGuV7mnCZJkapIGmWoWT1o3wN4r3b/9sasZjhjBNPUjNAQ+l7ANP30KK/5GefXJdRQhbKI9+eRpPFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG4hp87PDk/HTjQkIv8yKTmY7xBitvvjsj6pi0G/7BQ=;
 b=FKMAdEdGDkkjOtsJiJu4N78auZ+u0HsOkImfw4w/vf3j2Ul54TpFA4hAxnkV6dqtyd2RIS+XijhaDRbDUTPSKeJ/ta+0lGuC1rX6HqkMOcnMwoad/I9+9RXwsUSDdqJ3vJ3j60IxBXGZ73spM0PLEKs1SaU0lzVhmo8suvf1OzZV/bjqgHzqcl10aEzR6FPTeqBRw/pGtacc4nJJocubbt4iUwLfIcMi1QvvcVpQp4oGGINNdu1ECy0gcOven6IExMwMFQSWamw9ofdZd5Pyk4rWGsKFX8EKnBrb/OFEgxy9CReH8BmEO7T2tlCW3VOR3aRlMIqqaOzX4Fz/tHszpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG4hp87PDk/HTjQkIv8yKTmY7xBitvvjsj6pi0G/7BQ=;
 b=ipEeSA00uu0T3FwxiMMeKLgggg4zCApWouAwVDIevGMV4QQsKhTeC6BentxCyyBUycTj5LXLeMYwBSqAgEgFoqynHFP6D3VeFRzWxKLrl9cc8aBg8TSD6OMPZ5PSdalbPxjunt//ZePniGJBpNqVrA4GDZo+xKGUGP6h8MLEDrU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB5540.eurprd05.prod.outlook.com (2603:10a6:20b:5f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 07:06:03 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 07:06:03 +0000
Date:   Wed, 13 May 2020 10:05:59 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/4] Add steering support for default miss
Message-ID: <20200513070559.GP4814@unreal>
References: <20200504053012.270689-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504053012.270689-1-leon@kernel.org>
X-ClientProxiedBy: AM4PR0101CA0047.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::15) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM4PR0101CA0047.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 07:06:02 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0fa8612-4869-4410-2c9e-08d7f70c1949
X-MS-TrafficTypeDiagnostic: AM6PR05MB5540:|AM6PR05MB5540:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5540D69EB8114AA13FBA2097B0BF0@AM6PR05MB5540.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s9IfP/Wyw4O5vKeMEEtCWd09N1IiVfr+8CmYyKNpaBoJDLzdhfb7YIiUSTgoNOK/oL4QEYjnnrsmh7MONKx+Lq+6ka/cWCcs8sVBBk2v4FVGuQLpfwpPDgkFBGo2LetgtdWUYZDEfPHxj1L7iP6S+QARqaJ7G5bi8D4IVkMGouN3YK0yTMSyY47zKrTMv2KdRAGlr+/dtXo+7G1e9acjHsZHGX0ilKTITjrrmSfOHjpQAlezR9NMZ2NLubFJmcIJWZYEZ8A9eeckPbJ7fC/TGAwuCc4SoKv+kDO7gqAvhnGWvTaqtcZudVz6e91t9dgQU3vezhYV/k3iy5aPwhLAPgDw2QQObWBTPgQWkt0z1mRZGkfheHocNvSEgNX/1gaYc0pod/4St1uUOkXnqG3seH8gAgUMUhHZxaSnAxpidWTAliYeAWBoW8OAGrdU+YGQNaL4FPmEjcvEQqy9COHPbPJz0KJLarfGyloya+G6aMWKBJchtwg96VmhKJBkPTxnNLZ1A5+tKc2gC0+PDbHdE0jWiLtm+5L1uzDcMOqUKRwHdZ1PyOm3F9z+IAi2SGnTBGexhutH12yy95Hc4CD6JONfGa09qcgJobPZWRLlhQ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(33430700001)(16526019)(52116002)(8676002)(186003)(5660300002)(54906003)(8936002)(110136005)(1076003)(66476007)(4326008)(6636002)(66946007)(4744005)(966005)(86362001)(6666004)(107886003)(33440700001)(9686003)(316002)(6486002)(2906002)(33656002)(478600001)(66556008)(33716001)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bdEQ+NQ+sGoKZEU5Tkhkqp5e+rhzer5ZFjO3rVaqBgnVG5xJzJVahyTcuMlBf7XFva8dyaBALYreF1oQR2efLDS0CsehQuQIJCFHcNBdL+2GAhOlWeo+4t1Ta8w9QnXAcyCZUvSRcj7ELGldHUzmd26lrARveENFpYAariaZFwR+UdWboWq8VOrtO0xOMI+k7LkuddPLpxlEHZXcXoZWXqzB3wJhBe7EllrQfCfj8TC/BlPqtBrDyhETRxmJyI4zuMj7irXWPuIDJjg2x473L4z2t3o10TTX9Ni/1abXLDajoqeBWZgnAmuCe3rZr9A+5RMjIrbA8CN9dTemUResFsxVuiZjtJW2LGIPoB0CAYOWMzkRUZxZwyadKGeptRtDo3OhpY1zidvfUrC6LmG91WanVHj1ijpm2SkOA7lSaAtBvBPAv+2ootrOZVtGEGsG2pwEyrckVhb4lTeceS0nnQffM3P0qiBV4e8d6Efsxh/gzNUdlvALGJEqPXKJtED2
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fa8612-4869-4410-2c9e-08d7f70c1949
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 07:06:03.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJojLLXCGXYckqVBXLGTCcpkAfMEcQqHbonn0B7VGkyN/7KITD0cGE5Sf18QOBqVi+AoHfx+0ewoM6OTfAvHsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5540
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 08:30:08AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog
> v1:
>  * Rebased on latest rdma-next
>  * Removed attr_is_valid() check from flags
> v0: https://lore.kernel.org/linux-rdma/20200413135220.934007-1-leon@kernel.org
>
> -------------------------------------------------------------------------
> Hi,
>
> This code from Naor refactors the fs_core and adds steering support
> for default miss functionality.
>
> Thanks
>
> Maor Gottlieb (4):
>   {IB/net}/mlx5: Simplify don't trap code
>   net/mlx5: Add support in forward to namespace

Applied to mlx5-next with change of IS_ERR_OR_NULL().

19386660212d net/mlx5: Add support in forward to namespace
8e14c75c999a {IB/net}/mlx5: Simplify don't trap code

Thanks
