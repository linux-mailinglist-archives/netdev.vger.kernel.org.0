Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F06721397E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgGCLlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:41:10 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:61143 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGCLlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 07:41:08 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eff19520000>; Fri, 03 Jul 2020 19:41:06 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Fri, 03 Jul 2020 04:41:06 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Fri, 03 Jul 2020 04:41:06 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 Jul
 2020 11:40:59 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 3 Jul 2020 11:40:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iopbQ+DmP1DRwVnI4S6AdVshHjiShcxf040Ic5A3bIOLEhYNOePT7seD8WOAHEYfk4faJTcmihjv+J9wYkJS8yu+Oi8crRPIaAaQEmWtPrkYrvNBP77Bqcg6KzodFje2nei4B1Al8jS89CI+TbUPyK3X8v6/FU4uufyX6b+x79MQDDZy953pSV+i5iluH/qJ3E28NMSKdoEPTUbnX2BBKTplPyiSerz3r4kVxRwbUghIAmbfig9X6YW9XgYY6GMAm4fxSMkeBLjx1rate7/fsZVPHd4c2iNEMg+wgOuLZP39HE2Su3opdqsi5S5bhjIOy4/YD4n+pC1l8J0TSrq61w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ut/GjgRZjF/2o/HDlAmrBkMd0y4v1JWB0Vct/uaBUbE=;
 b=leyPCWqDDZPnVM3IUYRg7EZWMH9mKKOT8x3sTLWAEgil9P+vRLJ7bl9Vfx8DdKDwq+rVcXJ3hmlGcjqe7a3gPmqN64livtIx1pvv81IbYpsCPcdGo5KiBk3hHr+kZxLKLxh6rbgNZfCg3PpVYlnB/blcJOk0KlmYugv0QLamMc/wbbLaZnv+ntHm/nHAZESB5woCvpXVki6Xhf2vjUYWTxi1vBSzLF6eWA9ruaKsH4/8k/JfEZdDGtsjFZQAzMcbkO9Fm7GQjb6vOpcse552EF49Dw+VZ/KRSHj+q4NMQJdgqGFs0bS0Fq/qgbMQPgsHSmQe4diIM431EywukOoJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4497.namprd12.prod.outlook.com (2603:10b6:5:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Fri, 3 Jul
 2020 11:40:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3153.028; Fri, 3 Jul 2020
 11:40:57 +0000
Date:   Fri, 3 Jul 2020 08:40:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        "Michael Guralnik" <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] Create IPoIB QP with specific QP number
Message-ID: <20200703114055.GJ23676@nvidia.com>
References: <20200623110105.1225750-1-leon@kernel.org>
 <20200702175541.GA721759@nvidia.com> <20200703062809.GG4837@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200703062809.GG4837@unreal>
X-ClientProxiedBy: MN2PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:208:23c::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR18CA0019.namprd18.prod.outlook.com (2603:10b6:208:23c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Fri, 3 Jul 2020 11:40:56 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jrK3r-003RGn-Fh; Fri, 03 Jul 2020 08:40:55 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09924028-afe3-43da-9848-08d81f45f356
X-MS-TrafficTypeDiagnostic: DM6PR12MB4497:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4497455A07F7C377311D9B56C26A0@DM6PR12MB4497.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzDCTCgg8Z8amRh7D1sjEBiwYvIEvgqGIhLFe0o7FYsLtLkS3P+NF5HLODF3lYACRPG3QxjDmd6XChXELLtbFcC/Ce054WnrvfU2tNXLv5FaOB3tsnTQ74TeuHl7sFp2BRFJU4vrq5dNxmVmp+OU4sbOF+QgDiQANKP1Dqtp3aXn+rFJZakjhAGRkClDE34h7L22WT6DWi8JAwfJ+DLAWRnTtIhlOik+kBgpoSeWvsex2oJbsJ7m1ku4jWje7G1XEkm3hH884AanaxPE149Y9yKiMWOEIV17MeKIHBxsJSJth1X8pTiNSl7WrvPJMj/yeqPW7we+pVcJf9V8owueIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(86362001)(478600001)(4326008)(83380400001)(6916009)(2616005)(316002)(33656002)(8676002)(2906002)(186003)(1076003)(26005)(5660300002)(426003)(54906003)(9746002)(9786002)(36756003)(66946007)(66476007)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: illOw/1T6O5pMdASMQvlkastyY3pXjTUmAh3ml/6YI6ZJLRMcD6UwQ5HvzWF1vqI+DMwT0AKnLIhI3dUHgDPX19XHbk4ab7z4Gb5R38hacyIaNh+K4FUBKrFXcJC4hSmjGYwYnvd+4EMjzK8K4M0r4mRt9YCF/YcdpJ9tWp/iRslGoCJLoTatgFv7Dkk54JZ64w0lXDwceQECzO9Z+o93sobT9Pd9i2kLSnE47C82VP5beMzvUomLzzgOkV4aFNKQgvZTuecX/zk9tfIHh/1wW3Z8A7DPkVzu3+aeEVmxELmyGu2cz7axA3lR7gToa6CgFzVbh6Efwu/zcvhg8l8UTughRGCDoRi+Rf6GtzgD731mqHPLxRFkK3aOu3gCI5wBGs0Nr4tyVi6f76I1wl0aEZd8JLd7WS7kr+7vmx5zoYaOgZDsh6OPAA34m5XtdYYlCNWOWrvK5mOnoNe1o6iKkIodTGzEeWSvL+0btE3Abk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09924028-afe3-43da-9848-08d81f45f356
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 11:40:57.1556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61em7vR6Sdqx+E56HuSIpO16V02ia8jVuNu7MrwB290llfGf9irCAVFBWF6puBDi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4497
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593776466; bh=ut/GjgRZjF/2o/HDlAmrBkMd0y4v1JWB0Vct/uaBUbE=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-Forefront-PRVS:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Cd2i0eEVmzFAYQpFKq55i3i5W9BcMyNmL8XYqOAwqZ7psG5zDRbn903QMhVaxCTvs
         700GuQOrZW0LRK6jijEFFm/Ds1amI5iWFfxFwukyeyGYNNVV8x5oaVJ3RSDN3tSOSf
         D7wkhWb2KC8ysLpNOljzi7cVXV5aKdKm/T/yBRoeChIUGgJpG3wj8LasWJ9bEgyPz9
         s4AYmF2vHIIZSjHq+V71hYYwclQsEKhZuhigwV6zi47VuQDeurtDOUMMhVPAHwptnS
         Hhd+Su3ZhBM7aO2v2knqp8nD7poeHVaq843WNX3dJ7+2wzObKxt0HW8YOGSxMe37Cb
         FVPjIiCZwRjgQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 09:28:09AM +0300, Leon Romanovsky wrote:
> On Thu, Jul 02, 2020 at 02:55:41PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 23, 2020 at 02:01:03PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > >From Michael,
> > >
> > > This series handles IPoIB child interface creation with setting
> > > interface's HW address.
> > >
> > > In current implementation, lladdr requested by user is ignored and
> > > overwritten. Child interface gets the same GID as the parent interface
> > > and a QP number which is assigned by the underlying drivers.
> > >
> > > In this series we fix this behavior so that user's requested address is
> > > assigned to the newly created interface.
> > >
> > > As specific QP number request is not supported for all vendors, QP
> > > number requested by user will still be overwritten when this is not
> > > supported.
> > >
> > > Behavior of creation of child interfaces through the sysfs mechanism or
> > > without specifying a requested address, stays the same.
> > >
> > > Thanks
> > >
> > > Michael Guralnik (2):
> > >   net/mlx5: Enable QP number request when creating IPoIB underlay QP
> > >   RDMA/ipoib: Handle user-supplied address when creating child
> >
> > Applied to for-next, thanks
> 
> Thanks Jason,
> 
> Won't it better that first patch be applied to mlx5-next in order to
> avoid possible merge conflicts?

Oops, sure, go ahead please

Jason
