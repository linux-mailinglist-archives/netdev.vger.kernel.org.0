Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1545A2BB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhKWMjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:39:15 -0500
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:63392
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231623AbhKWMjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:39:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbKPvjGBIlwz3JOFzUBtslxnsSys8+6smZkl5NXgA1Z7GZ1umbjo94piJwDtet5nT6zblBIGn+mSLkJjIzdjagMIVSsdNQkd+gZK3EHi82V0bY9UNnPdmOetD+MHyEfuFRLwQ9+XkOstHbkw2QccSQ28U+F496h7vOeq76WrVTjIHWE5s93L9npoJUvnvsKTTQ91rXyYCkNNR3g73FrBvTCm0h9pSm/dHLczKqGksGvTeMCaVRaH+oB0L4ghgPafLClPr9T/dg8VLte4klZ4r8Imr2PpEE/MelsT5FSjAd/F2zTMLPLte+TZT8GWusFmujz5KLSAuV2rmLTYUZUtfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lclFXwL+kz+HybaXiLZtk7zLzcE/5MVICrcFR3DXX0=;
 b=lI3miv6KeGNwF9LFgZiVNZeJ/d8oAJiOsZBsTOQt5aWKmiFs/N5KulybQyAnsRMiUQEbmakcpYGeR4b9+58PWD1mn0WY3Yu0WQgfXbevj8ayjvemCoBo6/6oNRzKzhbJwX55tTeQwgKlI9AecwKSdc7T1DsNrXCqkE+IhT+gV/jiRBmP/d1oEEzD57ekYozFsM8ETIpRLe76X9Y4Hz5+mw+2CL1459XvTHjdicwTdPfDdOzZNb2rnDZ/njAOURlVU/P1KwvZ2RTNUbMx/gzA/Wrk9JeNkuUalg85+lGY2eKTlg32aiiDxyeCcw1xpCk+pn5yoQ3G4qM5mYTym9l0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lclFXwL+kz+HybaXiLZtk7zLzcE/5MVICrcFR3DXX0=;
 b=rewtbOeoXu7lfjS1HuAH1y9FWjeikU+wS/HnPuY0+aYUqYMiCRWXHfXFOU1hAEDJfV/Ivkh7SZA0kMiy7GFm4BC9iBrLhK2ybEoRX2IQvkba6F5lc5m16rHIASvACfODua/14Y338kfdTQzfUaxnQ1usRmnlPVfsssXG5aUD1ErIzSLXYXs4qOKC79Zmk5Ty/oRwNCstYcQCV+mmr7k9+Uxsr9O1ehdTHN2jEteH5xN4SHHtFAlXOBtgc7V2qwEQHNWfS5HMO0m3/v8JbmW73BXMuqvLaEjkcra8dOGkiO+x4lcxGEUOkt7jxWJ4jboxgehQRwyp7AGXR8/pXwfPlQ==
Received: from BN9PR03CA0742.namprd03.prod.outlook.com (2603:10b6:408:110::27)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 12:36:04 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::32) by BN9PR03CA0742.outlook.office365.com
 (2603:10b6:408:110::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Tue, 23 Nov 2021 12:36:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Tue, 23 Nov 2021 12:36:04 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 23 Nov 2021 12:35:38
 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6i3t2zg.fsf@nvidia.com>
 <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
 <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c240e0e0-256c-698b-4a98-47490869faa3@huawei.com>
 <8735nstq62.fsf@nvidia.com>
 <daae2fe3-997c-a390-afae-15ff33ba3d1c@huawei.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
CC:     Petr Machata <petrm@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        <davem@davemloft.net>, <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
In-Reply-To: <daae2fe3-997c-a390-afae-15ff33ba3d1c@huawei.com>
Date:   Tue, 23 Nov 2021 13:35:35 +0100
Message-ID: <87k0gzrqw8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2fe3d1b-e967-41fd-3df4-08d9ae7dd083
X-MS-TrafficTypeDiagnostic: MW3PR12MB4458:
X-Microsoft-Antispam-PRVS: <MW3PR12MB445855BE7AC7CE7D8BFE8AABD6609@MW3PR12MB4458.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QweXO2P116aGe3Qu1kWWkI3NFsV9HjQBxRGEFmrm7wgR8SVS8GVmaCzLrau9n3QTNKemzc92V0OLrNDafVfUPyjg6R/WBMDaaunVOfw5B8d/8VwrmANbkpsbwOxF0RTULXjeLLh6NzzkhM9g5AFrfBCWYP2xwmbTAGU1xZ8E7eq+BSPH9UmHeZWBTDkAWuMH8DkEZ7mBpIc9kfEFD1qooER1PKnqGewu6HnDXWLM9QrNNh+ueoYCg286aybQVb9hBI/8ocTsOo87F24qSSuhkceBem5WffdfnYpsy/3vnBAHc+ifPU5Y58u3Zt2WNzpqmcnzZ/tVKW46KXwxn0dOW1u6bCXXZzkfz+CrCMWF3x/CZ2GijgO5COSjVZuqVD+UJhYioFbYp5a/2/H9n1rGb63/HvMGBeLAzzQniFXdZV3xndaFnKB46kydMziFJYCWLXOBJm/KJFPMV4jexxRs91zXGv4QY6EogwlWuDIUTbEsZ6ta17cWKTXftmvv0ZgmcUhJUZNaEuuRN65IZwdmsFuvrnPhXPhhOnjuSAXw65E1Dz5PjSOQfJ4RjWvN41JPQudI6++n0d5uArPxvKcQ2LQtOUmfD9INO02t/dQSbgE6ExQS5floQYH18DSoZS530xfdsHoHTKWidt5OQhwl4SqFAmWjOztdl/LJJLNzd9Ym+z7o9kQaWWi6y5gmI/KsrMpcA57ED+b+ewr8MymKuQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(336012)(4326008)(2616005)(26005)(186003)(16526019)(82310400004)(508600001)(6666004)(7636003)(5660300002)(2906002)(356005)(47076005)(83380400001)(54906003)(36860700001)(316002)(8936002)(86362001)(70206006)(8676002)(36906005)(6916009)(36756003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 12:36:04.0293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fe3d1b-e967-41fd-3df4-08d9ae7dd083
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:

>> 
>> Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:
>> 
>>> I need some time to test my some ideas. And anyone has good ideas, please
>>> do not be stingy.
>> 
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>>> I think we should move the dev_hold() to ndo_init(), otherwise it's
>>> hard to reason if destructor was invoked or not if
>>> register_netdevice() errors out.
>> 
>> That makes sense to me. We always put real_dev in the destructor, so we
>> should always hold it in the constructor...
>
> Inject error before dev_hold(real_dev) in register_vlan_dev(), and execute
> the following testcase:
>
> ip link add dev dummy1 type dummy
> ip link add name dummy1.100 link dummy1 type vlan id 100 // failed for error injection
> ip link del dev dummy1
>
> Make the problem repro. The problem is solved using the following fix
> according to the Jakub's suggestion:
>
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index a3a0a5e994f5..abaa5d96ded2 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -184,9 +184,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
>         if (err)
>                 goto out_unregister_netdev;
>
> -       /* Account for reference in struct vlan_dev_priv */
> -       dev_hold(real_dev);
> -
>         vlan_stacked_transfer_operstate(real_dev, dev, vlan);
>         linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
>
> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> index ab6dee28536d..a54535cbcf4c 100644
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -615,6 +615,9 @@ static int vlan_dev_init(struct net_device *dev)
>         if (!vlan->vlan_pcpu_stats)
>                 return -ENOMEM;
>
> +       /* Get vlan's reference to real_dev */
> +       dev_hold(real_dev);
>
>
> If there is not any other idea and objection, I will send the fix patch later.
>
> Thank you!

This fixes the issue in my repro, and does not seems to break anything.
We'll take it to full regression overnight, I'll report back tomorrow
about the result.
