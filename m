Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542B74545EB
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbhKQLyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:54:05 -0500
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:1409
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235112AbhKQLyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:54:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A71/fXdbX0KZaA/xdnqluJoY0jzSmyVSin5/D/78JQhW1z+tqsiB+yaAcLlFADZtv4Xv3N9EqXaSEG2s/tb/irYA7JY6sLNWMAbGKO6bbtaA02g3z5cF+vmzw4YqvD8YTSS3qP0pml30Rb5LkNhGk+7SZAPg7LlkGPYi3yBd9sqT+aregh8aImlpL0o/IQqvBGj7v2vLdBAG9lVy4X11kZMS16P8I12Gtgu50dR5RdUEmiHPiwMXMq2f+nG2P75abPzgPePYDZZQdMdIdEJyaQ/PVUkmOfNk2znZMaPYAMNAIvVPxNqn9L4GugJyXWx6uR1Z5fT9iZ6llqcMGxqaHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ywzj5ckhSkdfw2s45nkx4XxIax6S7lMiWZ/7x4q1yWQ=;
 b=ekxx4GvS6Jmy6xzBi+aEXtEz/ubT2ciByZLydUmCheTOxuqW/RbIjlu0oL6aJEKN3q4j2nR+BHfuxps7UFNZp5dgoiKXMGGb7SXyKqIUZsJRkKhDm4s9GGCAIbPDK7RdVwSIFXglnkOebcKezTBsf/FWxCMq2TXGqQDtepcFLvs1+bH0pjaNpzn3IlDHAfeDF/lgBDPM1ShOSCgSAevNwroh92+xgDPwp0o0eBgn0w3IJROViJWM3CTxGBfAZ8jENyXL9EPdwyI8fwFL4XtvTXroW4mlbcBHyFrsUMqYOpGkZGRs7yyOu4xl9n5aYtbdtkLbmrmqepv36oujVchggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ywzj5ckhSkdfw2s45nkx4XxIax6S7lMiWZ/7x4q1yWQ=;
 b=dvDy5eR4dawAV8LEJlS7pr9U8Y2ZPfkDRCVBXLgJ7VpYdeR9uq37BRh0qtD3jbdd+qY4movPNLUfi4KYikt5dXY879Hkcs2WnQjO+rG/dtm+Yk2MtbKvA7wXM3XPgAqj6cHzSGJ4FQ3YxmYtcd9EAgy2hknQZliFvKZorEAhD81yCEMWp9zudhSMTESAnU8a6skImJ7gGqDxMbao/hffbJZ13dh1efKMig+h3kyKeYP4PAgDjv3sMWFohO6SEPF0jvo0aaxzErm2NOHQuwFdaPUNdK4NtHD7wGn0P90oyK0YwHbA5AbvaM502xGhmjWCRY4tlUbViZUT53oy6uhZQA==
Received: from BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::17)
 by MN2PR12MB2912.namprd12.prod.outlook.com (2603:10b6:208:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 11:51:04 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::e0) by BN9P222CA0012.outlook.office365.com
 (2603:10b6:408:10c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend
 Transport; Wed, 17 Nov 2021 11:51:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Wed, 17 Nov 2021 11:51:04 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 17 Nov 2021 11:51:02
 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        <davem@davemloft.net>, <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
In-Reply-To: <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 17 Nov 2021 12:50:59 +0100
Message-ID: <87a6i3t2zg.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cf1f4a7-652c-4255-9aad-08d9a9c0891e
X-MS-TrafficTypeDiagnostic: MN2PR12MB2912:
X-Microsoft-Antispam-PRVS: <MN2PR12MB2912FB0C9F491AE6336D411ED69A9@MN2PR12MB2912.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otyNsYERDTNvLSM4uT5r3/7UXPoTyCPldBoW7gv4gKiu1e52vm0l8F/UCC9jnU0QjUNg5mbQWofXcmTPsWf5ZxSojGrNkaHK/t7labI53/vYpcBfItB6P0Q0EI5wb9HjcptfEOnUn+GM7H5UkfehXr17jzyszxChIHiN8hhx1lt2X9rDYiEteRYfVBBPXjL5IBQoqkSnNu2uqD14dwsE1YPyGIXlwzR3cjF8ixuHO9tjSXKZ+tRTXzV0WrQLHOeiqHEaVGfXJXOCft0M00HNY8cxQHrv6TmSGMlBuwrHPW/+r6YSOSMhzPonpR4YVyVOO2sxE53Z8VC4SKp556/Jeb1jgEjF1698J37afatFZ+CXxRI/dp9OzmIR/9638KBpDJHbeNt6rIGZ18pYDfEfq5goEStbB4wZKDajRmG0QEisL7mKKgwqUl8W6KAB6MsyUKyKoFnz7seaLhCZ2G8q6tbMA44AddH1sSAlruqO2x/EABA2X4A3SU+yz3/MNJ1cOaSPrUGFppvXrhvxb9F1j1giC1hjm/XBPLU17C8a7c4HQN+pDf6PRf0xk5EqncahB2Ut9yuFMVrYj1Glt+NDPQzfmwD0y3gG6i12EoLCWer98WA7Fnt/vSi0tz976KW+pCGSB+ObWCiMaV+grISX1N644PNduBiklVGrYS3nSfUWc085D/fmOA7KHLhZNKDhr20J9IagrprOfJNEp9LuZA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(2906002)(26005)(6916009)(4326008)(36906005)(316002)(54906003)(82310400003)(6666004)(70206006)(70586007)(426003)(336012)(186003)(2616005)(36860700001)(508600001)(16526019)(5660300002)(36756003)(8676002)(8936002)(47076005)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 11:51:04.7146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf1f4a7-652c-4255-9aad-08d9a9c0891e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 15 Nov 2021 18:04:42 +0100 Petr Machata wrote:
>> Ziyang Xuan <william.xuanziyang@huawei.com> writes:
>> 
>> > diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
>> > index 55275ef9a31a..a3a0a5e994f5 100644
>> > --- a/net/8021q/vlan.c
>> > +++ b/net/8021q/vlan.c
>> > @@ -123,9 +123,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
>> >  	}
>> >  
>> >  	vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
>> > -
>> > -	/* Get rid of the vlan's reference to real_dev */
>> > -	dev_put(real_dev);
>> >  }
>> >  
>> >  int vlan_check_real_dev(struct net_device *real_dev,
>> > diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
>> > index 0c21d1fec852..aeeb5f90417b 100644
>> > --- a/net/8021q/vlan_dev.c
>> > +++ b/net/8021q/vlan_dev.c
>> > @@ -843,6 +843,9 @@ static void vlan_dev_free(struct net_device *dev)
>> >  
>> >  	free_percpu(vlan->vlan_pcpu_stats);
>> >  	vlan->vlan_pcpu_stats = NULL;
>> > +
>> > +	/* Get rid of the vlan's reference to real_dev */
>> > +	dev_put(vlan->real_dev);
>> >  }
>> >  
>> >  void vlan_setup(struct net_device *dev)  
>> 
>> This is causing reference counting issues when vetoing is involved.
>> Consider the following snippet:
>> 
>>     ip link add name bond1 type bond mode 802.3ad
>>     ip link set dev swp1 master bond1
>>     ip link add name bond1.100 link bond1 type vlan protocol 802.1ad id 100
>>     # ^ vetoed, no netdevice created
>>     ip link del dev bond1
>> 
>> The setup process goes like this: vlan_newlink() calls
>> register_vlan_dev() calls netdev_upper_dev_link() calls
>> __netdev_upper_dev_link(), which issues a notifier
>> NETDEV_PRECHANGEUPPER, which yields a non-zero error,
>> because a listener vetoed it.
>> 
>> So it unwinds, skipping dev_hold(real_dev), but eventually the VLAN ends
>> up decreasing reference count of the real_dev. Then when when the bond
>> netdevice is removed, we get an endless loop of:
>> 
>>     kernel:unregister_netdevice: waiting for bond1 to become free. Usage count = 0 
>> 
>> Moving the dev_hold(real_dev) to always happen even if the
>> netdev_upper_dev_link() call makes the issue go away.
>
> I think we should move the dev_hold() to ndo_init(), otherwise 
> it's hard to reason if destructor was invoked or not if
> register_netdevice() errors out.

Ziyang Xuan, do you intend to take care of this?
