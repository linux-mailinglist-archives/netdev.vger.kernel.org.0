Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EDA31A453
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhBLSLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:11:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5878 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhBLSLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:11:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026c4b70000>; Fri, 12 Feb 2021 10:11:03 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 18:11:01 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 18:11:00 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 18:10:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqkAw6z13XlgY3y0Q2H0o4ZlvD1WPX7/KgFLt9iEIhxmSwt+ob4DvvulYOcJfsO/7R9ERFRUdk5Fh1mTtRlfQlvh2lBL7RBa1TFdo0tUjRDU5bbx10/hYeWzsaYqSq7XqQtvA7pbwNJQ/6Gwk0AVKwb7xXVW3kkhuZQ4vfMQAYf7gFhKiu0l9jKLMBDuodQzD57e+LIYFFmlwW32u+akajB4D44V/R5LnpbKjvDjaEAP5p1CNpC+BuP1sEQyLbmwVUhx94m7H9jtK2vmqOpJtTbIYXLKdWHQKm2D7qsCSxZMRgHwSMlQr13qh/eddd3pEiljexeozInSVmNbS+TGgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ox2EsG3cWoRzCRGL1ryIs+33iuI1Rv4nxHLidqE9+7k=;
 b=VSsHbGngqWySVpRPKO2NqfX3+MW46QHvDnl3h1KTsPoZQ5YsrpLaEC2t3P5ViAiZKWE4ytZpBYKlkhZOczyjLE8DlJmDAgXd+bUeeJP4XOdfpacKV+K4jN12EJNNQnMOSUqqICGuyZh4czI9mbVFrlyMtgJEQjQ4XjPIluHHfoCeHOZWK8+jLzFJuUu7TGdIEJnxkzbZGdBybEvPLmp0XSWZKajMuqbOMUg6VibcBeOh9TV+QAzBBLCSLEcvHZ98VIFPdxl56SGASKt/fADWEfbL0K4c6zxVOBcaFYBPNDm9Oyaz8lGBCgklon7U6ZsJeK2i2rHO2z1JjZG4ITBApA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2938.namprd12.prod.outlook.com (2603:10b6:5:18a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 18:10:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 18:10:57 +0000
Date:   Fri, 12 Feb 2021 14:10:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        <linux-rdma@vger.kernel.org>, "Maor Gottlieb" <maorg@nvidia.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Real time/free running timestamp support
Message-ID: <20210212181056.GB1737478@nvidia.com>
References: <20210209131107.698833-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210209131107.698833-1-leon@kernel.org>
X-ClientProxiedBy: MN2PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:208:a8::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR12CA0020.namprd12.prod.outlook.com (2603:10b6:208:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 18:10:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAcu8-007I9T-6B; Fri, 12 Feb 2021 14:10:56 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613153463; bh=Ox2EsG3cWoRzCRGL1ryIs+33iuI1Rv4nxHLidqE9+7k=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=dbxMbLoGowilHKHxxEjGRC7l/NiZq3RiJJgvIqZvGunKbjP4WIGp86lfMcKIkM7fn
         IPV2hCzlZtyFkiDmWFxOvdDrdCbrYIWE3vzwd2LVRmx/Vyu6us1rchYrWsURM9SxUS
         mUjqS4h09K7vK6c8BVt/epfbfHGMcsTkEPlSKuWVCnB7teKVdlzK+cz/86xxOj9EMu
         Nc29F8zByS8X4t8vPMzQ418GM2WJiY47iHlVOJIvPf0du2MyCbSwZ4xLWBNfTluQYq
         gFmUGgX+rvIAVCP53yNVwSMMtg0ducjjhU9FW64bW3uupHUwl3lcZJdT1/CjUdIxNI
         PK6Xwq/+BrIWg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 03:11:05PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add an extra timestamp format for mlx5_ib device.
> 
> Thanks
> 
> Aharon Landau (2):
>   net/mlx5: Add new timestamp mode bits
>   RDMA/mlx5: Fail QP creation if the device can not support the CQE TS
> 
>  drivers/infiniband/hw/mlx5/qp.c | 104 +++++++++++++++++++++++++++++---
>  include/linux/mlx5/mlx5_ifc.h   |  54 +++++++++++++++--
>  2 files changed, 145 insertions(+), 13 deletions(-)

Since this is a rdma series, and we are at the end of the cycle, I
took the IFC file directly to the rdma tree instead of through the
shared branch.

Applied to for-next, thanks

Jason
