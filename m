Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B816A176A0B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 02:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCCBaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 20:30:07 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:60950
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbgCCBaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 20:30:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWVXQoTVMxRzssWbAHF3OyYn+NFXJYwBCyqgAywzKO1PlkM+Sp60Y7XColXGUxZ3lcMpag3eWPHwmUHq2wiVjjvTxSbKtmlXNKIuuNDamUO4cM9RGAVd1xxRr1AaY1qXNR2DCh8vlWX/n7kcpWqD8ornSWd4gpLb9VsENnQ0Ox3J/or4uM4jPj+QVT6y+mpXdHpxe9Xc5s1zxMfB53o7vkNyx4sYNztpnmAG0WwwvSeZDxaeRVTQGiIZATVUjct7BP/BlxEnffzZpISsRP8y/Qax0tfRd5iXR8LBR81VC2i5YG4a+2rJLYYikPnkSm2LT+TasamJoFsmbka76zel5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+MlwoE11xYq85NF9yrAnq05QHQyrwMqfdZGb4KMq08=;
 b=EWoeNMADpaihS2+P9LW9MYKucBxq8qC2LxdXAlJ0NKCdcanjDkwJAtEFEddFB9HkwsFPL4jR6gblMxqJpGTh/hoVEpaUmK6bDzwMzx8E8kZKtDnzwCFVpmrzwa82s3w0vy/aRrWB96xA8ZpRpR8c74J5JYqV4kBQmYh2XwV0l7A88xabhnRJY+XlVZhtPsyreeguP1/boEUi0WQc/xLLEQC3oaYncg2rxb8dNQ4FHNak7XC/V27yRQ4JlEJKAMX3KAUAFGoNiMRxGXR6CG2onT5oxSk6nHo9F/x/mkv/k1QWp2XS8sSlP4PsqTXoxxjrhcDETNAeowSxvBdz4DawJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+MlwoE11xYq85NF9yrAnq05QHQyrwMqfdZGb4KMq08=;
 b=LrUeooFFHUUfkWxDdBX2Wia9lkQFoFMCeCTFUs7m7Plxttb/j22ImIYmA4CXSIJrwt+b4Ui0osX8ZwPv0sEPeoPiWj9p+rb0Fkxdu3fbJBpVdhD8+PCynTPFNZa8bxoUgqapMNrbH9dyR++sJd4Z4z800Gk8VvbEq7OJ4LKS0lY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com (20.178.127.148) by
 VI1PR05MB3438.eurprd05.prod.outlook.com (10.170.236.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.19; Tue, 3 Mar 2020 01:30:02 +0000
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::30bb:bd37:e18:ef64]) by VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::30bb:bd37:e18:ef64%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 01:30:02 +0000
Date:   Tue, 3 Mar 2020 01:29:57 +0000
From:   Jianbo Liu <jianbol@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Message-ID: <20200303012957.GA32424@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
 <20200228004446.159497-9-saeedm@mellanox.com>
 <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <646c4248586b419fd9ca483aa13fb774d8b08195.camel@mellanox.com>
 <20200302113107.479f3171@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200302113107.479f3171@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: PR0P264CA0071.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::35) To VI1PR05MB6255.eurprd05.prod.outlook.com
 (2603:10a6:803:e6::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mellanox.com (37.142.13.130) by PR0P264CA0071.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 01:30:01 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9893ed55-bed2-481b-4460-08d7bf126503
X-MS-TrafficTypeDiagnostic: VI1PR05MB3438:|VI1PR05MB3438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB34384AC1C2EEA5FCAEE478E4C8E40@VI1PR05MB3438.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(199004)(189003)(26005)(81156014)(81166006)(8676002)(55016002)(54906003)(86362001)(8886007)(316002)(52116002)(2906002)(66476007)(66556008)(6666004)(4326008)(186003)(16526019)(8936002)(66946007)(478600001)(6916009)(956004)(7696005)(33656002)(36756003)(2616005)(5660300002)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3438;H:VI1PR05MB6255.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGn3/y7PXyoJL4MNZuVRB4R+Dqi0xAcZwlOdKJN5Tfe5FRK1HzXAqVBhCN9HDxiitSR+UMRkYITr7GmdKYlG4dYknqX7S4SMSo2yn2Y0BesSXUoBWk+xqTZzE/ZH9Oj2kQ5/SqfjM1kJyIcbOL8cMBmTxQBE5NCmTLWGH2qMMr5THavxXYtmR8I3I3IhSLo+R9iLrrksbqt/QIh5ZwKt/b686eADWxr3uHchrjXPhimiOXBu/QeWxbpQI438GvCOCUjoB/ip0vB83tuLUbLIpRowLCKT9WQyGFcGOsNCzoSOyPWz02M2Xq0h5gKfibC4MiEvfMWYtWIYAKQUioZ0BLMrN2Qko5nhoZsO3RxiPwA0oiobjYcAZZEih0H6Ch11kPodJde2OKQHwGKtc/7WsqgsWdFf6909kM3PfajxsdVx0g0Z1gf4/X62LtEHREJ9
X-MS-Exchange-AntiSpam-MessageData: /3L23Qfladde3E87+FWZBnWj5iOkrGp3uqavFJtmzbSUNoDDQ8TzPmCX/6fFqm8XyllHte2cBHiZpKb1bkFItqfiiD577ZXseGPCg+XqNoFxSbuZbgO3sM4sjZ12sDeo+CN2TBCTNOIB+jca3O+tog==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9893ed55-bed2-481b-4460-08d7bf126503
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 01:30:02.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYeTnGVT6lD8/P7xnwMRjcCEAvZQD/P9SBepLh374C4Rf6+bTVIJhkg8mnCF+0FQGPnd8BcQgPUx9yjP1dY3hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3438
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/02/2020 11:31, Jakub Kicinski wrote:
> On Mon, 2 Mar 2020 18:48:22 +0000 Saeed Mahameed wrote:
> > On Fri, 2020-02-28 at 11:10 -0800, Jakub Kicinski wrote:
> > > On Thu, 27 Feb 2020 16:44:38 -0800 Saeed Mahameed wrote:  
> > > > The size of each large group can be calculated according to the
> > > > following
> > > > formula: size = 4M / (fdb_large_groups + 1).
> > >
> > > Slicing memory up sounds like something that should be supported via
> > > the devlink-resource API, not by params and non-obvious calculations
> > > :(  
> > 
> > Hi Jakub, you have a point, but due to to the non-triviality of the
> > internal mlnx driver and FW architecture of handling internal FDB table
> > breakdown, we preferred to go with one driver-specific parameter to
> > simplify the approach, instead of 3 or 4 generic params, which will not
> > make any sense to other vendors for now.
> 
> Actually I was hoping this can be made into some resource attribute,
> rather than a generic parameter. The formula in the commit message looks
> very much like there is a resource of 4M "things" which is subdivided
> into "large groups".
> 
> Maybe if Jiri acked it it's not a great fit.

Actually it's Jiri's suggestion.

> 
> > As always we will keep an eye on what other vendors are doing and will
> > try to unify with a generic set of params once other vendors show
> > interest of a similar thing.
> 
> Ah, yes :)

-- 
