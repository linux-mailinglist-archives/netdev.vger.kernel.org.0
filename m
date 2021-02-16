Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033B431D15C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhBPUEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:04:25 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4757 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhBPUEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 15:04:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c25190000>; Tue, 16 Feb 2021 12:03:37 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 20:03:36 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 20:03:34 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 20:03:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw2II3H2ho6/V2r7gGICP6i/UwIKhUwygpHb1qfVonsb2mc0d58LNDHFIdlIg3ZXNy/mVRsh5ENfid9kOCFXcH7UAVCZVE1HTjYWjA2GnrY6NLVNNaXjdQewG6OdMIKDT9hEayCLIj7jTPYnCjiKwB5gEaTDPmPm+NFehlN+6kdXBbsqGEcv8Z5rfmFouklbf91vJftApArI5tj7ZlcRCkv7A1wLdi+6jYO9j7lvOMUsaS0yUQb1NDbuWFGKqyfvORzdGEuy73tIgfVm6wXZAZuhlvwQLkJV8jQZ676acYk+BLL9/7kTooCaYIY/o2iwpkjAJZegNam4MKbArKfh1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jq4fdPxRjAKYGxNX0dfEO2ZWHDnyvEfNESUBump5aCI=;
 b=PaXok+tmXXwgsb7tO1qXDkSmIXrau4cW0djQ4GtghFJXrSPsCpfmKSqRXJccF+zPubPE+wHl/lNUuF8SM9VFc6pgf70N6SsWD/N7a/gpzbRHWsYTvUma9mt1cEs/Y9XaiTqM7dfuFQhSPaLEFZNBNX/M8L/ktgrZ00noFPx/4rKD14fB0tVzeYgAVDwlCoHU87s628D/cpAgWJUVDa/XSx8Ot07aLUOY8nV8ekjt+YLzp/W0Ie5Y2WNx4z6Kd+We8Y5z55vKSt/JcPK1g+ClduKxPuH1Y6YCFwC7c/PCkBd2V6TKxRPnCVKEioPeKV2aEiWY3iHq0/YH0yTlVW0KlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3305.namprd12.prod.outlook.com (2603:10b6:5:189::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Tue, 16 Feb
 2021 20:03:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 20:03:31 +0000
Date:   Tue, 16 Feb 2021 16:03:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/6] net/mlx5: Add new timestamp mode bits
Message-ID: <20210216200329.GA2221694@nvidia.com>
References: <20210212223042.449816-1-saeed@kernel.org>
 <20210212223042.449816-2-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210212223042.449816-2-saeed@kernel.org>
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0097.namprd03.prod.outlook.com (2603:10b6:208:32a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Tue, 16 Feb 2021 20:03:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lC6ZG-009Jz0-0B; Tue, 16 Feb 2021 16:03:30 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613505817; bh=Jq4fdPxRjAKYGxNX0dfEO2ZWHDnyvEfNESUBump5aCI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=WOqkFoyTjNpsVLs3jmc81HpQs++q7MKe7cajTNWN7Dp7hcw/wKGrPG2gHJzl/IpGj
         wDPJqv2npck1VJtw2y1I+5UQB3sB35jSrV2btL9mRd0MnKDQNGuJu2Ym7NxHu+0bxV
         R9Fy9qrK/5gv3AvNsf5BQ+dWQ6Kw+kZ16jcShWlM8fpp4FpvxC1qBPbf0DVCigqHHA
         CuKgnEadgADgiORLCLkOZKxKXrOP7ajI4gnGdHsjTq+NlLW5n56oKHQzp3eeZGB1sk
         kfLMBPARcSLam4EGQumsum8qFjQ3xMqU8p+zDbnK7ACn+jsIGQUEIw3ssYejo/4sRY
         JH3dqfSUhj9ug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 02:30:37PM -0800, Saeed Mahameed wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> These fields declare which timestamp mode is supported by the device
> per RQ/SQ/QP.
> 
> In addition add the ts_format field to the select the mode for
> RQ/SQ/QP.
> 
> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 54 +++++++++++++++++++++++++++++++----
>  1 file changed, 49 insertions(+), 5 deletions(-)

This is a commit in the shared branch now, so this series will have to
go as a pull request if it wants to go before the next rc1

Jason
