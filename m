Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D6023117E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgG1STS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:19:18 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1099 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgG1STR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:19:17 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f206c180000>; Tue, 28 Jul 2020 11:19:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 28 Jul 2020 11:19:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 28 Jul 2020 11:19:17 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 28 Jul
 2020 18:19:07 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 28 Jul 2020 18:19:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7md6q9n9IFtC0cCV2rdqTdE+e8rxcrUfHqLGlIizX61vnqoYo5nymm12LkcCWy37Xx3RGQlirIWCY44AYHVyDCrLe8xEztgzf0u4HDwklz5KOPQErTTysbxN7XSIf9KXG5gM4Mco4kiFw0nSoCSgDwDH6nZ8S6CCyDJ7DiSldnxZt/NXzPp3I4aYkW6AxnJf/xnZCpPzJwWWgPjidIisx5DboFZrHKwrBJIWGvUjm4mPRLd6a8sZJ6hTavPhoOYb8JwzLvaBc5kpIaoTbkcCLspKubIzVEuZHLm4xuIyTO29UZIfq3JdrciLttDOOr8R/Bu08vIITY6GTGlh0eCFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhscnaZWb5h2DQ8PmNCl4jSdG3qvMdhS4W0S6lMfH14=;
 b=BeSn07xoQBiI/A0N8AiLRU4RASKtkFlVizsRXrROVfC4sljMYfbq17ZWa+47PAdLS+5+r1f4Wm5ADVazO8yBpVU5nh7iFffpgOSq6h8DSRzEw9OSNtBmqhxT6Y2VyXNtlstWychzIz34YT24LK1PIU63lK3jWNPD7c5Vs/yMsvFUBqDGOZUYUiXINrdWxURxK+3u2Z54ukUQRCHnqq4ohYLCmgMiYnjXYgogVJdeRhbE+ob64zcSOUIOA09GgVgZO21USvQONGZI/TDiIeiGPMafm7DCtRfVrc4SkreXx+VRDn1u0QCi/IETS+YTgNokY2JVfDQxkaN0oZkhW2BIkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4011.namprd12.prod.outlook.com (2603:10b6:5:1c5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 18:19:06 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 18:19:06 +0000
Date:   Tue, 28 Jul 2020 15:19:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Christoph Hellwig <hch@lst.de>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, <robin.murphy@arm.com>,
        <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <willemb@google.com>, <edumazet@google.com>,
        <steffen.klassert@secunet.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <borisp@mellanox.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728181904.GA138520@nvidia.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-22-jonathan.lemon@gmail.com>
 <20200727073509.GB3917@lst.de>
 <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
 <20200727182424.GA10178@lst.de>
 <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:208:134::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:208:134::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 18:19:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k0UBs-000b7I-KL; Tue, 28 Jul 2020 15:19:04 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fb2a0bb-b77e-44bf-4357-08d83322b6c4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4011:
X-Microsoft-Antispam-PRVS: <DM6PR12MB40119EC14DD0E934B33DC2E2C2730@DM6PR12MB4011.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XlF0BKQw8w26PIOoRIZdNjD9zwWsq8lOmCd7BerUje7Ph77oBRMvKb68XfLzyEhyYI07ZnOyOG+izi2hBH2lWtB75ozs09iJWp4fEuFQgD/QPNC3H3ftASEkEyQCS4Fm7vA51kCcM2wCrxu3/QbvHooWJ/Z0mUYBgQV0huPlgpGybte1CJWuMH2aL3FwlKIgQR64oS+0q91RX4Jt+vP8wYMcHrCpdLDPdcegBxQXGnh+zxVZ0TD9z6sWDefDSm/jiNFscgEvK2cRE4pRMIqipKJihXZzXumRT0k+eeb+8B9aYrCvpneZ13qbntUbv8NeycDypfiNw6ygcI0Wi0A1ZEw1ZI/eEIFk9f/gy+v90qhjUIBI7HF4DlrUXqWZNEJ8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(33656002)(6916009)(426003)(2906002)(66556008)(86362001)(9786002)(2616005)(8936002)(186003)(36756003)(8676002)(26005)(1076003)(4326008)(9746002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pHVkpPzH8XDRi8zyktJpd/6VBvzaRELMmw8vbFEBJB6+R9wl9siCjUcdH1UI1zWnZhRlVX/z3yX7y1xETRZIrkmnE2rKIGZHOzOX+LfBa3qShbQ70/4y+x9GEDCEzquR/4WM2FlQ6D4VHevo/0tNT/R4kjIsmtuodxQmzGFLtqe8px+e32VF9hkmQ4xv2yk/bfKMDEM5yPk+hWMEFD2+xJLMTZL9t8TcLF8bMjGggss7XJZW0I0SvhXVCymHao92vQTQLEcMchASYuX94nwVl8Rg+NY1wsACRFq5WWmE1UbCNSb7meSuUK4PTklnzg3+Q0p4DFnMRaR9DDca7Z4heCAzpqgS0E4GY3xuo5IbanJwnVeuK34juT0kwvJX1NZcbCnsRoMBgCGXjQ+BN5OoyvBBmBm63ozpmE+eLB5e1z6VYf1AT4GIhL+NqNuhjeejMHPhkkCloQhhnFBxz37Pr8Noce/SequpY8GN19CffalQnSY5Ld0wPpFzXmg0xs0r+yY4KcIQxai9pGj6pEfTVofIR47yRRXuWW7twDMLcFoEroeFCvVyFw4/py9etT9WOR6vLTkgA+tOcqGi6qprlt7aHyk71dhgApHVbI1iUXfVkstrlDEftNGgIjFDzHrVSft/l8xE+39XLjk3N9HBNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fb2a0bb-b77e-44bf-4357-08d83322b6c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 18:19:06.4413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrCGhdmpFpU4xJ9kcVGddPS/Pq7l0oPojst5UJx+5hgBLffaDmcrpH0eLo2syMMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4011
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595960344; bh=ZhscnaZWb5h2DQ8PmNCl4jSdG3qvMdhS4W0S6lMfH14=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:
         X-MS-Exchange-Transport-Forked:X-OriginatorOrg;
        b=hCDz4NJG3ewT94yDgAx+WOcFAd68t8H0vMHqjRfpuDM76lg+MsGvi0qbbuxk8Y/TQ
         edMa7ifHnAG6E3w1gM39naLiS647ttx3Ys4+CMIPGYoXvqZ93QuQ1viEF6wyeRdUXP
         7RD6wltXUGRSd63HjP8oPr2uFDV+6su1DqyozxNHEopQdFID5OjN7wXANd0WFyHXif
         9cZd0izIy8ldOCHpHYH8+grVpBm4uiEWw0Nv27heR8cLImqvKYhVtpHbH0AJWTZMRo
         xRnz7m/Cd+k5AVt0DnPkoFC4ytJgpx5TFXJ/h4rRIHHLfPtijyCSTPMlTVRNapoq6+
         rbjo9C6c9/yig==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 06:48:12PM -0700, Jonathan Lemon wrote:

> While the current GPU utilized is nvidia, there's nothing in the rest of
> the patches specific to Nvidia - an Intel or AMD GPU interface could be
> equally workable.

I think that is very misleading.

It looks like this patch, and all the ugly MM stuff, is done the way
it is *specifically* to match the clunky nv_p2p interface that only
the NVIDIA driver exposes.

Any approach done in tree, where we can actually modify the GPU
driver, would do sane things like have the GPU driver itself create
the MEMORY_DEVICE_PCI_P2PDMA pages, use the P2P DMA API framework, use
dmabuf for the cross-driver attachment, etc, etc.

Of course none of this is possible with a proprietary driver. I could
give you such detailed feedback but it is completely wasted since you
can't actually use it or implement it.

Which is why the prohibition on building APIs to support out of tree
modules exists - we can't do a good job if our hands are tied by being
unable to change something.

This is really a textbook example of why this is the correct
philosophy.

If you are serious about advancing this then the initial patches in a
long road must be focused on building up the core kernel
infrastructure for P2P DMA to a point where netdev could consume
it. There has been a lot of different ideas thrown about on how to do
this over the years.

As you've seen, posting patches so tightly coupled to the NVIDIA GPU
implementation just makes people angry, I also advise against doing it
any further.

> I think this is a better patch than all the various implementations of
> the protocol stack in the form of RDMA, driver code and device firmware.

Oh? You mean "better" in the sense the header split offload in the NIC
is better liked than a full protocol running in the NIC?

Jason
