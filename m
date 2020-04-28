Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD9F1BD08E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgD1XXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:23:33 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:62365
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgD1XXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 19:23:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1eKilOK8yotYz/eKzKyajY4fwy4FlSfBkd4b3e4B5TiL1jTHPspkm7gTuPfu60iOCLI7c/4LOYVvCGlni3QXChls2Vy05y/McAE98Xm7ENDDYMaK7y5upCzWz4xDp33N3q4TntbKyg0pKWkOxWTDLPkrNZ8qV0D7/bxU/R9d/tPggR0+ejPEC4Yl4FjhkKMtZbX/PCAJAEujWt0LZD7HFo2DRYBbNlP7rB1pany1ycAXQ4lt0SLr7gLnn14Mg7Jk5CKbATa22pGg0nWhUFRpqumrp3mW6MEHSls9d/h9USiX66KVvKX0wB7vh1EAwkdgUGZWgJ1NaAs2h+iuzEzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMHBeujMxwasrdEufBAOSF4waJhdUhHXMl4OYgaF8iQ=;
 b=L2QYzS7a8XatkS04aaOGyaz9UyKL60+2sJHkpTr+h02wW1OIVChwcXSe9GqNt0jHztdWnubao6OqYMjcVXn1TYnupraDVeCRFTluoAGxh3oTUvNZdReqJoYFAKs0GwntfRJYQ1XpFC118qsRI0nlOF+3DV7MBV1ZlSD8Im7pdJKyToiyxzwypQE98bENAxOEV7vIjNS5hH7PZjy7DOHmPHZpFoycRKqPEVUPhXusp3qSswHKey1Q3bHjYBsGQ2bPfWNXo1S1jomIU0VLkffHgnfixb8pqBTxxQ6aAKQkzPPT+4AWoAJVSEfZldKs+Fh5PX7uMm+m3A5ZXTvP95JG7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMHBeujMxwasrdEufBAOSF4waJhdUhHXMl4OYgaF8iQ=;
 b=XoVWE/jQoO4JKyzownNNT+MBOSYOM/g0HMhJ+nqBEPxvdCbOeMn3xz+Q49v/ww9AZluao1GgVSsLUfX6SAouecvFAwAN6h5PROeifrwtBK2mYvYzbB5wYOJzLCleVwvtrFRD1HCbduK32Qcp7YeWIKmYk8K/6JMrOwRO9QojS+Y=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6829.eurprd05.prod.outlook.com (2603:10a6:800:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 23:23:29 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 23:23:29 +0000
Date:   Tue, 28 Apr 2020 20:23:26 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V6 mlx5-next 13/16] net/mlx5: Change lag mutex lock to
 spin lock
Message-ID: <20200428232326.GA13640@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-14-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426071717.17088-14-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:208:35::36) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0131.namprd02.prod.outlook.com (2603:10b6:208:35::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 23:23:29 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jTZZW-00085M-5Q; Tue, 28 Apr 2020 20:23:26 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 120c5772-233a-4790-43d6-08d7ebcb290e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6829:|VI1PR05MB6829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6829391A67E3DA247788043BCFAC0@VI1PR05MB6829.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(39840400004)(366004)(396003)(37006003)(478600001)(2616005)(4326008)(186003)(66556008)(6862004)(66476007)(316002)(107886003)(1076003)(66946007)(5660300002)(4744005)(8676002)(9746002)(9786002)(8936002)(52116002)(6636002)(36756003)(86362001)(26005)(2906002)(33656002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T7QvxyuLhPnwjQg+tQCWHxKavEFhQzUvYcaaGp5MxRhccVIQLSyg+N1SnnTnmYsYKr02ntrwUWftP6VMlZ5NTTV9KqUrEZuu/1KiRflhA1/Msh+PuEOurvaNiEPBO88KymXzBkDmcTr4AX/z715AO3q9S025hRDmvX+wqazU0C5MDh16RkR+2ufVNxN567myC5LJHwxWJ+//5GCNemsBR5kS3cw3I9vOSvIb3XtLxDjHqLkTMQuPdnowrGCisTIibFzlbyJiYo88j3uaeOW9BmZZY1JMAFQu8wyDUsym7L+ssaJBj8S4SF+LYgE7Rs2cVukUpVSoCpTbQQ/sXl1/hrzg5etCJkTSGb/Kyha3zRkwQHYJdB4hohrcHJRDMQxszeRU0fInmrb22MVcx6xJuUw47IkooJY7uZ/vEJ04XuMJniQaEBLSR2Ov1mTExkbbQ6zj6Ptq7nMXK2GGZM8jza/zD6/49/hr+BgUnRYzOUBhOq6yX0SC+bNl/Tuzi6hX
X-MS-Exchange-AntiSpam-MessageData: NHeSp1Xdp2LzPwnBUW3MpLkUv/YhjuycoqjgOCBMGoHKVf1uZD+mPfLnK9iha3xl6LUTM0WZigSziuG2QYUxkVf3TCAZrpVdupr/jILCPN5D4QJLzGbGqhMtEufPe+LrxJZk9YdL8ehIHXHHG0xhMuBRwU9WcPtIShOiX3Yfdi0J04PjTlFAfz7+R0ARZahwnPgqt9Z+CHG4+e2Zz9YJ2QlCtX7iH6B5dx6EzKP7CBBoUBdz6DVP9cP1C6k+G84hQRMzmnvnDL97t+x4/vKd2AZMOpGcSYt8gKYCU0HelfW8t0fe6oupmh8tjfCBA6DA0cxG3f4pdrw1ZStWrX+i9IF49NlEvJEEkAchlFxbknO4eNge0dn1hm1tjjqPTNfi5TVFgXzMWgpuepRVs/iVX8vE6vKUQRg0R2E8kdUTeZaj+zMJw9BYd17TigJYPSryBCfTfNwnMwz8Rdf63Rx9udxV4xS9c2ADW0+GBegdPIdDb/U1BqdWg1Luutf43B8I4egmucgRBlIclor1hZsijg93xTjEpomahnlFpqvM2laXgg7MY9IHLulgAEhdeOCrzBlW7P8qYHB5Mw1ViZoqdJmMsB1cQYFv5WHMddeeM/PecFr+FKGMVhbJRXIPjFfp+9nIt4EKKtPB8AAPj8bZ6XGB/kVtrnSczWU2UOHYARsu9DQIP2mds5OaTLzZ/xRDU7B1wrfRBKhxawejmnbHyi5e/QM3eZlIpHjQx8InXWon7nHHaZZASgA9fTCDS0rlPuJ5B91nLPyNm/FiM0NXua4CpRSvPGPO6HUZzBotSfQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 120c5772-233a-4790-43d6-08d7ebcb290e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 23:23:29.7792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Xg9rg9hXkX8kYnX/YUvZo/F/5sOx2Vg5jcYQn4x116zUqo9qhOctAhfzRAlX6SXi/aszcr/XRIPLgrJNQgvsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:17:14AM +0300, Maor Gottlieb wrote:
> The lag lock could be a mutex, the critical section is short
> and there is no need that the thread will sleep.
> Change the lock that protects the LAG structure from mutex
> to spin lock. It is required for next patch that need to
> access this structure from context that we can't sleep.
> In addition there is no need to hold this lock when query the
> congestion counters.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag.c | 42 +++++++++----------
>  1 file changed, 21 insertions(+), 21 deletions(-)

Lets have these two net/ patches before the RDMA patches, it seems there is
not a reason here to send RDMA patches to net

Thanks,
Jason
