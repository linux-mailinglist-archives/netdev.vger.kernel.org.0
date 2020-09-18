Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CCD26FC4A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRMPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:15:08 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13161 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRMPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:15:08 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 08:15:07 EDT
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64a11b0000>; Fri, 18 Sep 2020 04:59:23 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 12:00:07 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 12:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTetg/PyRUt0LnFEWYARRjL4I71BbYIrezc9bqrpx5i3McXtBnYYy5maXjGUBjz+dQW67oPX6KoAA27vzmFoTUal77X9t/ZNF+ZnwHzUGrv1vr9uZD7YknNeaJHDeSglTKseasQHzTKpfdxcVQy846HhS4HLdiAyvONJKWWGyL1HxDNL5GT3+M+XjEmD5MiOQ7R9wLj3wf2SPEOPlexZOfu8rFwI/A7G7u18sq9eczqjEE3a7jMaOKyA7GcFzbPd8TZtBY1xa23XNvl9UsJ7bfOesCZUbLBEGTYbjWpnBWS1d74r7E9e1XrBl8Wrrd2xWEUhf5fzHSpUcurTut+TEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZHXVEeZvf5UrUt+wL3+H1JyK0qEwQ1MmJfv9uWS/W8=;
 b=fLpP99Xjp194ObUAfyTxkv3uttYkcDWLGYRG8ZaiolMOyjhyvYhuzb05umQRFl3vgW/2L1UXK64CTyQxb/d+E2HlaJ7AhkgbpC8uqWDnvai27RI8bGti0HRzvVBYkglt24LsmoplS+ovUL4IPrxM86tDP4EV2/HTcDgUzofpNRmH99uyWUOuRXXWXfcoMz+VDfNIvFIm+2KhkY/g+f5hnNgmUI9ocEvhQY7WBtEfWXw93XN7ftOO9gNLWvfHLhZLN2PvFtvl+dew0ueCJGM3C6o1nKcDfImwt0VbdnRc4fDsEC1O24zjhyHNxskxGPAm7ZXflpvu6nie/VUD92IHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3308.namprd12.prod.outlook.com (2603:10b6:5:182::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 12:00:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Fri, 18 Sep 2020
 12:00:05 +0000
Date:   Fri, 18 Sep 2020 09:00:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Oded Gabbay <oded.gabbay@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <SW_Drivers@habana.ai>, <gregkh@linuxfoundation.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918120002.GA226091@nvidia.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
X-ClientProxiedBy: MN2PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:208:a8::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR12CA0023.namprd12.prod.outlook.com (2603:10b6:208:a8::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 12:00:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kJF3a-000wsx-DP; Fri, 18 Sep 2020 09:00:02 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3fa741c-9934-495d-66d7-08d85bca60a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3308:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33085B2069B9119FBB9F69F8C23F0@DM6PR12MB3308.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Jaf+hI0AMEQrT0iicI4QegLwNP2oZetZKoRekB5wHRmzaSHcJUN8h00JaxYjiXVHDjMk/H1W9RdYcndxiC9lEeq1lKO/oYT1J1kplo9dV5Ejl36Be6x+f9wC1ZyWGBqAhsAodZO7tbHoji05nmfPwZpAERY0TlWwanOS+ojOv5nbhMC8tVtNxfFWFAJ0Vqv47zf9pk41ZvCULMAqaWNkWR14ST3Gi0vRrY57E2wcywujXMqFmKPiRru82UHN/wuSPldwj8MyYJ3iZtrF2DbAF9SxRkSAG2M434wbQU7qMPVe+u9ASK6i6kMtpdUEc1l/BO4QblMD6ntMU4brmcl3ETpclIkgPdDwzoZ+nGiwIZbch2SXEarnQbWnx1NqWAO2VFoXv0OQV68gUZCdw00B5zLEOdFLBFaApEshJ50KFBchp1U7QR1YOIfpgouLgFJg+IsTeRzDm8dKTZst6ThTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(66946007)(66556008)(8936002)(26005)(66476007)(6916009)(8676002)(186003)(33656002)(36756003)(4326008)(2906002)(2616005)(9746002)(9786002)(86362001)(1076003)(83380400001)(5660300002)(426003)(316002)(478600001)(966005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +CD4Z6H1V3EjqLxfjZqdSdKsXRKYlKkLi4VEQs8bAMIls/RF/VeypOohNO4RQSyeRXxUmiIgKIHaREHJqKpiotbb1mYsCA0hh97BgcQZkxfNGhqyjUNYtylvSlYcxa6SKw8q205VIAprNpGxqOrQC8cv0RQISLxO/1uyt1GUYHk4cHPgYAqACQzSRJbtdimWib0ZuHpT9YKnNjZx5fqt85PXgOE1cfsXPNYufkp5zhBM6T2MfBue/6gfMmgUM/jMmsv6XOvuQpPWC9P/7oHgjYmRJWuCtX+r/2YvPEJnE8S4/4IVhw9Q3mvROEPV2h2IGKtKZjK+cgv6aAv7D2+YEdkrfXTE/4OYgDoZM1xmFQPF7VBMrfy5CF3uemSqTFbzLI+8inLBpt/rjptQ3JaCythuVsDwGerkUIPShZ/0lhx/ApXYplLwxaWsOjxWtuOqTyncUwhTyf4SOMnkOLVhjOkXjRZzGNX37fV4g4n64ICXIAb00Yffv6bXLpfzSFThIFhTsDt3OXAdQvopJgWQfntSH9H/C7KUtYcx8Seq55mot6zYuJoNgGmDSliAg41mPu7JtJQByGqRqby5IgQXd0GBPEg3YCVZiFmtJdRNPP9XvkfZ/fpecL2qynRtkPqiCtOfUsehkmIcELgY3uCcMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fa741c-9934-495d-66d7-08d85bca60a0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 12:00:04.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oXwQ4IvdPWlkUNP0FAZvMPIKtG+//Elc/FR8J/72f4uhRybAUFi7w9bEHdG6FHk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3308
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600430363; bh=IZHXVEeZvf5UrUt+wL3+H1JyK0qEwQ1MmJfv9uWS/W8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Date:From:To:CC:Subject:Message-ID:
         References:Content-Type:Content-Disposition:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=VnCqFRbkbSQB/8n6ufnjn2QarRPvS+dY0/o9i1igkjqvGZ3IjP9AUawA0JOrll8YB
         7Je3u+XH9GVErzWEVuzAEBwQXkJhyoyw7frbiVOHe8eNWinPj/tP0wji0R0o/RZ0SG
         mi8roRIFylqrbR17DWm2AWFfVFnhx4tsY/7q8zw5VJWNuCti9NidjhuPi3I9ZvQbUd
         AHGHLR2ke3lER0r0dpph0oe3qwb9OATlwaCUX4QqeWyqiDHecCWbQTryu83Vov5vPE
         bd2j5l78yko5WC3j+h+ueYPrhiGsfaivf4+PHjXwrwPLycTUhHP+g/2b4oDvpfo0zm
         fsOAyi5tIcHxA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 
On Tue, Sep 15, 2020 at 08:10:08PM +0300, Oded Gabbay wrote:
> Hello,
> 
> This is the second version of the patch-set to upstream the GAUDI NIC code
> into the habanalabs driver.
> 
> The only modification from v2 is in the ethtool patch (patch 12). Details
> are in that patch's commit message.
> 
> Link to v2 cover letter:
> https://lkml.org/lkml/2020/9/12/201

>1. The NIC functionality is NOT exposed as different PCI Physical
>   Functions. There is a single PF which is used for compute and
>   networking, as the main goal of the NIC ports is to be used as
>   intra-communication and not as standard network interfaces. This
>   implies we can't connect different drivers to handle the networking
>   ports because it is the same device, from the kernel POV, as the
>   compute. Therefore, we must integrate the networking code into the
>   main habanalabs driver.

No, this means you need to use virtual bus/ancillary bus that your
other Intel colleagues have been working on with Greg.

It is specificaly intended as the way to split a single PCI function
across multiple subsystems. eg drivers/misc/habanalabs would be the
pci_driver and drivers/net/ethernet/habanadalabs would be the
'virtual/ancillary' driver. Probably one per port.

Jasno
