Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB9C15314F
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgBEM5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:57:01 -0500
Received: from mail-eopbgr10041.outbound.protection.outlook.com ([40.107.1.41]:46861
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726386AbgBEM5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 07:57:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQKCu4+70/kJSBcmulkd6fE5JAWXqSUsoahihvze38tsEhLjuhOkLTtDOJCM0LrWI+DXWJwx//lnbUsRzVvt5WbgRBaf42ssZ84E0/EjgSDtjVQys3gIIZK7ZeMSJumy+YW3S4QydoHa5BeoBQnCBYFsDo/83qRCjQfu2OKqd14uP6caAsHCjTPv7Vvh7K+AMmjLiP4NtXaTMb+F/V4ZzaQGJ8L4AhGT3ib4rYOIFZppHXX5epzfUR8qJvgKB5jNxP5k3+NX8c0gyz7F2VT/LjmNXualnNpZuR2pszHP1zYtxe92Cc15q2V40gGz5rN+QNXM3tgH7ivN5qgFoFfGGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbiPdN/Tw9XZTbyfw4LGMrONC3v0+6S/WuRJhvHO4Tw=;
 b=JrAdRBJaCDYfHSnnGXGaLa1TNaH/UI1SUKmizArhczqd1cfVYEynecLkR9/5k5CAXlAqO1TWLv9lHSlzqTCyjvnXX5uywgB/I6eQ+6Pal2+9B3Q8YpR10FrLAnOO7jmqfkfcwlW4EmPK5iBNkpyLoQxDr4wZRXcQv1wFI8Lun/l1P6Po05iX3cgIA45m987EKsDOHxYssUV5gw37iH4Di9Z1aUCXfg/s6ZCfS2kUOfJu6iLitodvYetyhuebInN5D1BHd8InpYghBV1I/5/KfC+p8ImSL7tZYcBEZNqUiMxFMs2rOzLXZ/e738oQbQ1SP4fRZii6X/Kas7k73P6YrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbiPdN/Tw9XZTbyfw4LGMrONC3v0+6S/WuRJhvHO4Tw=;
 b=HUqeCSJWz5pEvpa6i2a32ezw1unnN9LnmoIScZvtGJYTFugpRKxnstscHF3JzfdCzlQMBiJVjgdfzOU9nEVvDG9qp1MqyyNTrJXzhz27OLbaSVJzGwWhDYYPe5LGacHGJdZKRVNEMdD9HIuE44W0xAX0oJXISKaxOAGO24yU83s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4509.eurprd05.prod.outlook.com (10.171.182.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 5 Feb 2020 12:56:53 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2707.020; Wed, 5 Feb 2020
 12:56:53 +0000
Date:   Wed, 5 Feb 2020 08:56:48 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205125648.GV23346@mellanox.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR05CA0062.namprd05.prod.outlook.com
 (2603:10b6:208:236::31) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR05CA0062.namprd05.prod.outlook.com (2603:10b6:208:236::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.12 via Frontend Transport; Wed, 5 Feb 2020 12:56:53 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1izKEa-0002I9-2r; Wed, 05 Feb 2020 08:56:48 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8f8fb22b-1f4c-4d1b-e392-08d7aa3adf80
X-MS-TrafficTypeDiagnostic: VI1PR05MB4509:|VI1PR05MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4509FA44E2ECF6674D62AB4DCF020@VI1PR05MB4509.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(2616005)(6916009)(26005)(186003)(7416002)(36756003)(33656002)(81156014)(81166006)(8936002)(9746002)(9786002)(8676002)(2906002)(1076003)(4326008)(66476007)(66946007)(66556008)(4744005)(478600001)(5660300002)(316002)(52116002)(86362001)(54906003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4509;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgU9/3vE7rJYUS2L6IWqg10NyNGNV3Fo/zCFzdtAkzHzdiYixeujAbMyPr3Up9SgmPunaXZQ1jEpn7UN42D5oDQ+WqaFoss+ZMs62E7ORCriGuviExal0wRfiIEo7zSMvbRStwZsBP+Q+1MUjJMMmYVHsjlyXQozL9JZwIaaf2Z+UqycIEdKFUy2y4qRgEqLIRnJO6gShwg00nwO9VZELiu8kuBNYj6sSchOSZcSXBxI3kXoeho5bKrxBDx1jb7TQ70iSKejvRmgqQgLsG7DWC1h+swqeaAoKgHd7Kv+NxgZTtLulqZ9oYhGYBDA3r37qFiG6wL/buJf//G8iVZHzuAVQC96dnIf9UjMAgSzALP03EIjhlPiLpyS/l0S6RUrhB8Uh0Hghemxnma9kgWowI6SXKD5yDyYuO6HxvvOpjWAfoWyR6g0A3c8vP20OtosdSLX112OG13R/+4i1OlceLT+GtVCZfEqLM7SS4ZYMSNVwKXbIgCG3TFYOvGiu2lL
X-MS-Exchange-AntiSpam-MessageData: n1YkP5iFigNTfa5KFTJKaT4IhUwo19bRL4ngRj9iADAEXWD9JLYAO5y92o05X17qTFiV6JXJAt7MY+SCTscuiZ9/H2CvotdbMpx8YerIj9hngHhvbOf21RsGHMF3ozY3rr3eo2F8BncEuARfM1vWpw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8fb22b-1f4c-4d1b-e392-08d7aa3adf80
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 12:56:53.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQ01rPmVWX2GbT50QEsE8g6wEQjpuNubHc0YWbcwnBAr7qgaxFt2UCbDidwlc0PIn3y+UjGfyWisqL0OL7AGXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4509
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 03:50:14PM +0800, Jason Wang wrote:
> > Would it be better for the map/umnap logic to happen inside each device ?
> > Devices that needs the IOMMU will call iommu APIs from inside the driver callback.
> 
> Technically, this can work. But if it can be done by vhost-vpda it will make
> the vDPA driver more compact and easier to be implemented.

Generally speaking, in the kernel, it is normal to not hoist code of
out drivers into subsystems until 2-3 drivers are duplicating that
code. It helps ensure the right design is used

Jason
