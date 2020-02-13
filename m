Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E98A15BF92
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgBMNll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:41:41 -0500
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:63969
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729901AbgBMNlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 08:41:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1A+D0LUZ9br/fzphgpTTRJWngxawLSwDzI63drwhmVbbFk0knhBlxFOD58up3aJXsrAkHVsxop4iAAKQin9UeFuGFZbaQMGBMRRTdykVSdlcvybtrtEG9GYw30zjsO7ugZZOdmfEpQWES7kHQuYf1te4bxPeFQPp4QjbLLFEkf40pEoxr/SiOIR9YSTJFCbcKdbzvlL7ME3G9BSx9h7OJJeqLcHgoiswrVAR2P+vD8GxLDju17POBgPpq5aWjyL8iOYaIw7iAMufHCABcOF8NPYiQWOntW5KWgTiLDM922lJNG7f+rQTfPngkt3+9NDRz3ct2BnztX0u6bFWTcwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7LL+aaOEnNU8sX0PFRO04XXN+ii7yrnP4UCLR2RDPI=;
 b=lujeM+nAnV+s2Lu814SotBgD2GI3Gc/k/Zpm724qUPnRoUatpIOmtBBIF82LDkUwDWJz5yOlKRKhfhOU8RLzER85jek1wuFbURZxrwYNlPU6U7FuVuc0IeDaYSB+tHngJxBom5Qy+OdgnaDc0HRf/iMRp+wssxon20K6u83VnTj0+0bNfXr/nmCOqyOuK91mBAKFLnvzkbKGeUSsaLC8Uq4YI9cJl16yAj/9oRKQdIGcAeU7YWVmPFULBVIimFzCkTjLSGCzs6IVfkypzI9xqKgulA5ezhVoR0AjY5Aqp8udUMM1oJv0Gs2IV4O1RIRVJNRMAtHcw6V+NvAglssvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7LL+aaOEnNU8sX0PFRO04XXN+ii7yrnP4UCLR2RDPI=;
 b=QSqv97o/XZudSRLmFrUh9Zowmnz0xSusl0lYcXs23EbvoUmcOwyMlD/T/cx5w28U6DtvElBqIfYfBdbBfdUzLNS9lameYLb2+e6jF6vrSBzgfmBcbGVd8gyAY3tPpBWcM5OvNmQZLaZ83NM+nMu0/SuK7DZfe6QfScpMC0hFRV4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3358.eurprd05.prod.outlook.com (10.170.235.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 13 Feb 2020 13:41:33 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 13:41:33 +0000
Date:   Thu, 13 Feb 2020 09:41:28 -0400
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
Message-ID: <20200213134128.GV4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR15CA0017.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::30) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR15CA0017.namprd15.prod.outlook.com (2603:10b6:208:1b4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 13:41:33 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j2EkC-0003I6-W2; Thu, 13 Feb 2020 09:41:28 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1adcc69-d29a-477c-2237-08d7b08a7048
X-MS-TrafficTypeDiagnostic: VI1PR05MB3358:|VI1PR05MB3358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB33583CA30B546963913A4BE7CF1A0@VI1PR05MB3358.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(4744005)(86362001)(52116002)(81156014)(81166006)(8676002)(33656002)(1076003)(6916009)(7416002)(5660300002)(4326008)(186003)(66556008)(66476007)(9746002)(9786002)(26005)(2906002)(66946007)(36756003)(8936002)(2616005)(478600001)(316002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3358;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlWrp6Nfhlh0evx85Ghey1w5roVSvJniN88ZcLPL2Q/KM0Eo4guRPjI02RIa5ZefC3fRLF0j8QShoOXm+ukalPxvz16MToQZ6K1zKxIdm4F8YbQ8fNqFrpCY6PEqUPFACN7U2pkFxIEPOt4dfaszE9ONeLN1sOWtc+ipF0N0rC5jevo10vX3yyhTwwIq/gcQB2FGS/Lu+ghH1l0aN+8BewSaVVlPrggoehGvi/l2777w83gIqiBtlz6Q0XDgiRgOXrwxKS/A90qzPbFdf0aD+UvFCEjAp8m2JmhOyiBiibXMBPHadR/S6Ney+LCP6mKuLl2u6w0V1vs+uh5JMaXlzJmP1fIay6DucQ/pPR1AG/75J3cbRwYCkEFSHr5rAxtElkAlx+/KU1LDiWEKhXZUSvY5loXby9UYLT4rRdE7exX7rET2DWuPAL6YgSEhrnfOB+vEqfb/P9quplC1QcMjVmG4XZRm5mG07HxBOZYodQYYXT6vWONywi+nvfNEcu9L
X-MS-Exchange-AntiSpam-MessageData: idjbgiTTizyLnfS6MmeK1KvvFk71VaASvpgGsWtgJE6C79o/9XtsLAzVT7RiAa+7HGAmoImhLqzTaWDPUfdxJjyemQkojYdlzOAHijTy0m6CzI0/Gy7c49tBOuBL6SNbfD4RK0CAbUEHCCcK2BCopQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1adcc69-d29a-477c-2237-08d7b08a7048
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 13:41:33.4454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llj4s6z4DgZNKv6H8eqtqYtCFHKU9j5ABavy0mshn4Hk0jLLN4OQR3CLCpxNmZYLQE5vOXFL3JrGS7SW6s3eYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 11:34:10AM +0800, Jason Wang wrote:

> >   You have dev, type or
> > class to choose from. Type is rarely used and doesn't seem to be used
> > by vdpa, so class seems the right choice
> > 
> > Jason
> 
> Yes, but my understanding is class and bus are mutually exclusive. So we
> can't add a class to a device which is already attached on a bus.

While I suppose there are variations, typically 'class' devices are
user facing things and 'bus' devices are internal facing (ie like a
PCI device)

So why is this using a bus? VDPA is a user facing object, so the
driver should create a class vhost_vdpa device directly, and that
driver should live in the drivers/vhost/ directory.

For the PCI VF case this driver would bind to a PCI device like
everything else

For our future SF/ADI cases the driver would bind to some
SF/ADI/whatever device on a bus.

I don't see a reason for VDPA to be creating busses..

Jason
