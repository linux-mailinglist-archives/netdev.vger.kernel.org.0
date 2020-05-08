Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484431CAAB5
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 14:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgEHMgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 08:36:01 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:41825
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbgEHMgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 08:36:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=byOy4nNXzzym2wte2W4DwzuO7Ed3L+xD1Hw5sKtB0n5OgwPLxWFKKLI6SbsXcwIfL5isF0QGwQ5EtXRJeEWhIIbSTE2CRuQhg2TREabCzzvCAos3a9PzYetDXigGBW2vo6Cz1y/2wqQq/w2BgLQIJM3Gr+WhHZcyU5RaMD3JbcD4K4lNHRsto8v1m5digXjMLoMhyDq1LIU0F1B7P5vEqVcAdevIR/rlvh2uT2EPXNrV7jITiFmnSyhBCxR+2QkGb590ErcIYInsXwYV+9Zyg2goIpqTzgXMwf6oXIRAmXIHexzDOvIe81Esd0ljFQlY+1v6h6Gn9zjp9YgL81wt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OX6eeVGsCLrPWw5UHdJNnZbK1EOBt2ZxCSO9BYDeLPk=;
 b=SGzrJgT6icFiZr74uHRSur7XZ3KZOVyuZ7StcMquh4MlBo0u+/yIbwberAGwcH5tsVlMHD3nSzRUvOh6B8+mfNHb/JbVWeGXSwIyqCcVcAprhqwV47GelQVugeu4+qCF2Brg75wZKmzggcQ1YyZBd2vasjcxioWxj39H2TiEVMKD1CtwuntmfHMPoXNEvwgrbtiRGCWA7aHQN0qKMJDbb4MAspxNGGHfF+/Z6kDz+Xj6oKaGnBKY9AVc8k/uUHdGTcrKXe/UNvHl/z2TyJJQZHhBlWQuS6r1eAAtKNdgD9Hb6h961P1ttCnhX7beElaVBHmd2CgzlNQzAoTvBx02wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OX6eeVGsCLrPWw5UHdJNnZbK1EOBt2ZxCSO9BYDeLPk=;
 b=NBCfqeKX8BErc7xzGwpCStI7k0HmSyO9bFdHh2TlegE7k2MqIjmjjlF+rK+UqKS8/4lx6l/eeJftkbKh4i+qHQMt32+W7QEiB+bRrZrgglJkYTYoErPEo4UV4Bt7c58j00NIBtwCDn892JpDXkcEnAXXTgEJ4ZeBpqsZpwcm3EI=
Authentication-Results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5885.eurprd05.prod.outlook.com (2603:10a6:803:df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Fri, 8 May
 2020 12:35:54 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2979.030; Fri, 8 May 2020
 12:35:54 +0000
Date:   Fri, 8 May 2020 09:35:50 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma tree
Message-ID: <20200508123550.GG19158@mellanox.com>
References: <20200508131851.5818d84d@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508131851.5818d84d@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:207:3d::18) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0041.namprd02.prod.outlook.com (2603:10b6:207:3d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 12:35:53 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jX2EI-0004B5-VQ; Fri, 08 May 2020 09:35:50 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 473f9d80-0781-4851-f6d3-08d7f34c595f
X-MS-TrafficTypeDiagnostic: VI1PR05MB5885:|VI1PR05MB5885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB58853B27F0577E5A6A89C98CCFA20@VI1PR05MB5885.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CSD9FqAAErIFdemMc5k1y2PM2aibslsiB8LAc3U2jRSsIPkqAKJBj57E0SVHLrBTuUN0kTZIEENND+Wje3L8Rr75fRrqdgGiTrcZeg3ZlCWLqTlzslzyiuGzMjSGP0NO0R/igJgTaXvOT+0abCZ+iDoNCXPY2exNQsHnWGdzwe32yk65J7NImNHvjmcsvBBUHJjzWpeexm0jEMOnhewcFFCFzkyplHWBjbc2vjHD5SEyyHX1e71Ck1p9irF2Y7FJMW9YkqqGgC1XiZUNcZAob2sL+s0tZeVLm+fmFYMwSpnBXo4nerpdg8dFYun+FjuGiavS2916TiUI6x2yhyEBaiMwuQ8tV5SMNhuLvdK3naO0hyJJU/TrdMfUl5hVrGE/hapC1CXeQo+xFkaA6XfkB5PnlWmqDYwnFbKyDnUCXovqnIV/HWyGXGi0wqwYtgmYvDXFahXP6eLuakOJV4vuvyQ9Fpz9UhDInbPQ8CCIdUo2cHeh4bcb3u43CoTqglOFg8WVq+rZqPpRYGM19U2Eo4WVY9u/wWLnHTPhA9w9Zoo9RjDw7CX8mDj4Sw4uWKt9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(33430700001)(83300400001)(33440700001)(52116002)(2616005)(83310400001)(186003)(33656002)(1076003)(36756003)(83290400001)(83320400001)(83280400001)(66556008)(66476007)(66946007)(8676002)(4744005)(86362001)(478600001)(4326008)(110136005)(8936002)(6636002)(9746002)(54906003)(5660300002)(9786002)(2906002)(107886003)(316002)(26005)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Y1+Y74E4RYB5817VSPQQeV4sOi2UgT5hUHf6hcmSAN4yqwN307TPlipnzD8MUzncQuEubYUAA5FohAlr5UjDt32eWL/qUhojKCOAQgdA+juzgxgLkCCIAkNbAtF/nXWk0sjKZbxStrIkUFu0q/Oci1e+a7yQozsvxf1Ig94Gt0WRfAa9nqsmakpNov/WxseGvTxlN/8ohFOJv9WHIngcer6i3cwGhsNXlbBBxdb59eXvNy9dB41Mu/lbt+aA9DOvcXIDoKpPJRHgMFvPRQ8BycI3XBAl0x1/wYStGX74O6IH5+VIlRnBOkhLt9XDCoaKFAjjnGtmJIlvimDphxazkJaP4bJaBMqdjv7Bmrw9mCnXKaIkjLbWC9sFQG9iaztGwuGLGU8Q4eesdl9hBXwHu9MIILVU25q2XanPr4qUzOST+nsHgGaCJSGNYeLwsVDodCXDtxtuHzqcOYSBhJF+F7ySZkc4KA/EXp8qdfHSp68ZwHlmPg60uwKCfnKv7HRx
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473f9d80-0781-4851-f6d3-08d7f34c595f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 12:35:54.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Jp72NXjOioH2OcH3669Czvtc6aey0wG1OzwVmZ6DyWk1Sjgml34lwUkxk50Gq+6PjpHPwaq+ZjS8k/RrXk2Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5885
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 01:18:51PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/net/bonding/bond_main.c
> 
> between commits:
> 
>   ed7d4f023b1a ("bonding: Rename slave_arr to usable_slaves")
>   c071d91d2a89 ("bonding: Add helper function to get the xmit slave based on hash")
>   29d5bbccb3a1 ("bonding: Add helper function to get the xmit slave in rr mode")
> 
> from the rdma and mlx5-next trees and commit:
> 
>   ae46f184bc1f ("bonding: propagate transmit status")
> 
> from the net-next tree.

Saeed? These patches in the shared branch were supposed to be a PR to
net-net? I see it hasn't happened yet and now we have conflicts?? 

Jason
