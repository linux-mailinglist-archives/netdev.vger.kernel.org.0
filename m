Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B231705DC
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgBZRTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:19:14 -0500
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:6242
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgBZRTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 12:19:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFPb2zOESN7WXAg6t557Ixx27Sdiq8ONR6RGPTF4HJVjeBklV964meEEntgCL6mNRweU+llPZ+avDFY3Ruqww3TUzQnlmUVaMx+4Y8enNmf2JgjfHV/S7UhDo1d+a+xKb8wwa9d8NJ/sSf9ojk+DNOvNHFMvkM8FbEQbfVkjQcmj2DZ9UVIg0PZ0uAmxJax/aNHShCFyc5F80FGKhc1Nd7qOnJcZXFa4S1rTJUb/G4ArcKmskY7NHmgqecYwj0wVcMkIePS7nkOY+mYzm/ky5OMZzBm2lE0C8QdtJqpJyLjic3zRNQVw7LpK8xtqt5X8oSPhDTWUatTQzVxUSLc78A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTa4Vioq81O3+93Nkq8/5gs+Zdq/m9mThAJ3d5+2BNI=;
 b=mVDoTK/VrRcXAIyFkX7+f1ed7jwQJm0iGTtLkBORwt8ThnUP2zNGbNabbDmDJyrYBGXE4Fliwk6tPIf6HkO2QWvzrRmwe3XoMupigvW7ykze1EChSRwjwNt2U46/hcAC3/+3JszqkGivqnl51srebe3KX0FciBdVbaJDUVy76wI9XhrDMDGTgT0plrrBLB4rkD1oYKpDiB2BXTdSf4yLWVmLfmIbsuTXk/HGwvv0Mabwv7dbNiyF+c6srB6bKK2wTHI8oF/JTtdc4gmfIkIHkSAfmWf/llPhpve4NYBye74n7t8P/0JX/wTNPWoof7yrFiDj/padd8HKJbGXqaFP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTa4Vioq81O3+93Nkq8/5gs+Zdq/m9mThAJ3d5+2BNI=;
 b=f930Im1Jt+r+uS6t139vVf4Lh0u/bpULiTrp0awc58WDJO83xf5KUVCFGl08QeWLOq3i3pPpfDwdw6niBhJshMPxcmTfJwLJaNkgSQAcHPfmwXneTVabMb5EwWWn4+bpk7ODaUquLXwAFsrM+0AJraGvpq7MMV17kjZ/1A7Z0xU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6543.eurprd05.prod.outlook.com (20.179.26.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 17:19:09 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 17:19:09 +0000
Date:   Wed, 26 Feb 2020 13:19:05 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH V4 5/5] vdpasim: vDPA device simulator
Message-ID: <20200226171905.GS26318@mellanox.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-6-jasowang@redhat.com>
 <20200220151215.GU23930@mellanox.com>
 <6c341a77-a297-b7c7-dea5-b3f7b920b1f3@redhat.com>
 <793a1b81-4f78-c405-4aae-f32a2bf67d87@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793a1b81-4f78-c405-4aae-f32a2bf67d87@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:207:3d::47) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0070.namprd02.prod.outlook.com (2603:10b6:207:3d::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21 via Frontend Transport; Wed, 26 Feb 2020 17:19:09 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j70Kv-0004T2-Pj; Wed, 26 Feb 2020 13:19:05 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed6a34cd-4d7c-49a6-aa20-08d7badffda5
X-MS-TrafficTypeDiagnostic: VI1PR05MB6543:|VI1PR05MB6543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6543903DFB3972E583125EE9CFEA0@VI1PR05MB6543.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(199004)(189003)(8676002)(316002)(81156014)(9786002)(52116002)(2616005)(26005)(478600001)(54906003)(81166006)(2906002)(9746002)(33656002)(4744005)(7416002)(4326008)(6916009)(66556008)(86362001)(36756003)(8936002)(186003)(5660300002)(66946007)(66476007)(1076003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6543;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+0wfyiIkq1srC5QKEGHCHxPLfnAMtQr9k0axoqfggasL7aESpaLHIjMbkdSNYKMXlijYsHkbarUKWARRsz9b/rpq0aq94CU9YVYSZPZCESvuIOjmOZSsq67EV1HrfaL7svW3zwLhQXg5oMsFJJQyWha6TZA1UR1HGSNpDlmrssb/k2sAh/mDuvo3eCVGACBGxUMzjAXEQOS2guIquqLB4Ldp9FEQ8AyWgCPCez8SSE+UBZndD1XZoyrXQHYiHZv05CWHdZG0gz56MhTNlOYK2EutHGkq1DlQbpIfAW6tAQfWd94ruOxr62HgjBFYabctgt7VSD3ZYGa+quyszik70wKoSfqJENuxFOZWo518mndscrpW4M35K8bbm7pGAujDsHj/AIFf+9ZtOL5RR96i4LG97TV8XMD2O0FRavLqlpHUNZ8QSmdtzFMXmq50OWbGZ/0imdB/TH2iP0Fr2GTNkQHyrDr5IgDVs6AVZ4P2wK0mrgSRLXzGEr2OHFy54R1
X-MS-Exchange-AntiSpam-MessageData: i2VC+9mj04/g+se0zfNtQvQYSyQlh/qZz9Jh6c8VEk67KWY1VzC6DvB6aXi1sNizKvXuQgTbLVKqqXZ9i674ZPJd6qEYh3BNoWvU93fxWSdf/npI8dnqSb3QDrpoqRz7WYFBQWgu8qal0ZO2I/s1qg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6a34cd-4d7c-49a6-aa20-08d7badffda5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 17:19:09.6288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bidSoB3arg9mIl2Doior3Qnku9G5o1W26r+ZvMzsv/W/rcmJh2ZlUrZkBnKoDyPImAehJdvdhY1huxkAJvOX6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6543
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:12:26PM +0800, Jason Wang wrote:
> > > It is a bit weird to be creating this dummy parent, couldn't this be
> > > done by just passing a NULL parent to vdpa_alloc_device, doing
> > > set_dma_ops() on the vdpasim->vdpa->dev and setting dma_device to
> > > vdpasim->vdpa->dev ?
> > 
> > 
> > I think it works.
> 
> 
> Rethink about this, since most hardware vDPA driver will have a parent and
> will use it to find the parent structure e.g
> 
> dev_get_drvdata(vdpa->dev->parent)

Oh that seems like a sketchy pattern

> So I keep this dummy parent in V5.

The dummy parent is visible in sysfs, I think you should remove it so
the syfs for this virtual device makes sense.

Jason
