Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9013D30B044
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhBATUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:20:41 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19397 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhBATUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:20:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018545d0001>; Mon, 01 Feb 2021 11:19:57 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:19:55 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 19:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfSWX8VCVBBTSq49X5/5/DvmXTIFEsur9UUOmgDfrlJ6gFZuUvgWn4UVxgp7WilxmOQaWXaGC838Qv4M+o0+xHxSnnMhXWt0ZbNjQd800P4D5YCYAAz5inSOdj0ozFZMNYKkoLr0lXhfyRzh5GhwvGLp9+jGM65G1v5PWs7Fv72pIW3QKOyXQiI7cpDmnU6b0cn+B8nTXwkh3WhI6gMOuXgkAYADATdj2A1bxisopzeYAH18GG08qYnA2dFnV0jMxLEmDBHs72QZbweAEwZl8BXxxJkk5aWCAF7fivN3KPndyExTN5QFKMttwQ9iW3I3jfGe1Ivnv9ToIc6Tbca2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+O2AjQKmqE4s3Q4qxTi7yuTt13VMC75CskpMpZhq2w=;
 b=KPo4t/pO393UcyNL1huFy9YMT7M03Vwm0FabkQ8ljqE4X3Pp7ZdONNF3h0oR7+M2H1xr1M+LDUECVHNShPjDcMAPtExBpJlfCb8k93XkJRbsHfIsMadLQ5SeTeC6gZZa1ZHy+injfaUU98SXU9HEV3US7bMIv08aNg2kCz6jla6/07+LtT8BCxX0vaVeQiYiu9RCR7qAVIBrdtJLkOJj5ICKvQGl2JoAuY82OeIvxCNRqgzGZJNMMKtiB1ebTBTSP4UocPySy3kL1iY01lNMOhwLY7kKtSOKMVgCykpLyxkKVmnoKaD7vS3eE9gj2JqehcM74P3CPrSDu9SI9eLt0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4778.namprd12.prod.outlook.com (2603:10b6:5:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 19:19:53 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 19:19:53 +0000
Date:   Mon, 1 Feb 2021 15:19:52 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210201191952.GP4247@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com> <20210126053740.GO579511@unreal>
 <ccf8895d9ac545e1a9f9f73ca1d291bf@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ccf8895d9ac545e1a9f9f73ca1d291bf@intel.com>
X-ClientProxiedBy: BL1PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0229.namprd13.prod.outlook.com (2603:10b6:208:2bf::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.13 via Frontend Transport; Mon, 1 Feb 2021 19:19:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6ejo-002Il3-45; Mon, 01 Feb 2021 15:19:52 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612207197; bh=v+O2AjQKmqE4s3Q4qxTi7yuTt13VMC75CskpMpZhq2w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=kkHdGQriVlnkNKlepTHirm+Gj6q+qt295T+p01jSMdup+LDrIY5fKvsVMdORSYQip
         uxCcuV0xZ//s/xfkCWJZ2IB8TXX+tEK4U+5ryamRuOMbF4UQzMK0kDMjCtNcw9u6gT
         cRSqyAVJ4/PdgosmW5uFfs2igk/0WLAqciJC3bEGtRlhJKitNlpFQbvk8NSzKSq/Oc
         zdh9bPcq02s1RSCXIrBE2LDQAvoWL+GNmik2Lq3ofQKheDDin2Nk4f4quWnCFqUXfU
         RIWMCiZgwmC1cPOPJUuzhjiGh+Pqy6FdyN9VguDHN30NiGqC8PZ78pQYNyXi2IwS4s
         7WL1m3CItRzPQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 01:19:22AM +0000, Saleem, Shiraz wrote:

> Do you mean 2 different auxiliary device names - one for RoCE and
> iWARP?  The drv.probe() and other callbacks will be very similar for
> gen2, so one gen2 aux driver which can bind to iW and RoCE aux
> device should suffice.

You probably end up with three aux device names, gen 1, gen 2 roce and
gen 2 iwarp

Certainly flipping modes should change the device name. This helps
keep everything synchronized, since you delete a device and wait for
all drivers to unbind then create a new device with a different
name.

Jason
