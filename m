Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B132048A1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 06:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgFWEVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 00:21:37 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:30272
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725986AbgFWEVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 00:21:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBazji+rG1c/MfZ5cdfsKillEL8LWrEAnqDq7cHN9NgFmdv+bxFeFdfmaUpBh0rZ/+ySdpbxKWc1NeG/Ghz43CRgzTi82j0Mz9gn8KWjH1aS2/qq5cONvhsp6Slvvx/eePxsDdda4ykjkFr9kR9lUJ1V60OMdmDkzPX+y6efbEXU69bEAe0684BVmHIpF5+9YA2hM9MAJtliCnSbIOmoyGuVeLuLgyZ3CX3s0vovzrATjtnyMOdG+DnD+SaGrRHQyce2cE8ebp+4BkFiknyg2FCZbTPdecUbEEy9KNiBmTvnGn+vsjw0SRzlesf75oX/+x2/flfBEOdSwLlvn2zFFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mzvq+ma/L7IfQIIHxgO/jl476SYsWWYHDbWQSVLxeo=;
 b=Ttx0kgVa5hTcS8o2cRaPHUEq6kx3k93lrjoVDaxoBWVEHSP8dA/kALaRP/X+IeVgYYI5v1Xl2o4dzMr9lIakrNXsOsfw1a5s9dRBICCAnkH5Xfg1Uov9zzc4JYeP0r1hezqQbKn0K4eSY4lEEuVUyZG7uD7NyyOCwIN5MqPQP5obqhZfObCcVBYw36tx0QS7uqg4v8J/p31ke0IcDvJY2qge9j8CvFdTbQ+KiGIwIj9vO4h1FQS6QupK0j1OPdMgBEWUzSSnAVFxAClp3srO3ixZoMHhMk/Bez9F/SerNUn3eBUytvbkPUZJ4IoPRDs8M1kMkfN2uE2EdUik+25NGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mzvq+ma/L7IfQIIHxgO/jl476SYsWWYHDbWQSVLxeo=;
 b=Lb2Mtz6IsDRAoDzYh8zxVrIvaepcQNCu9WrX91VLW+f47/eJRBD3Q5rwzCZz1ywdLmv9sDhQoGMT8VqVGlieJv28XZGF1KfP33qew5Qsy9aNHgjDpHgwP3TIGxOdv5HKKexq7mvLUsKqzTyXK1PpcfqJ2oAUJntEkYC6xYNfdIU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR05MB5282.eurprd05.prod.outlook.com (2603:10a6:208:f0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 04:21:33 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 04:21:32 +0000
Date:   Tue, 23 Jun 2020 07:21:22 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     ozsh@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: mlx5e uplink hairpin forwarding
Message-ID: <20200623042121.GA65357@mtl-vdi-166.wap.labs.mlnx>
References: <CAMDZJNXW-SsgYiw8j1b5Rv8PhfGt=TxZZKjCPzsQWiADjy6zew@mail.gmail.com>
 <20200620183558.GA194992@mtl-vdi-166.wap.labs.mlnx>
 <CAMDZJNXgiRzLxnLg1ymTL0xSEh8wOgL4RWxTbcU=Y3vU-s=_Ng@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNXgiRzLxnLg1ymTL0xSEh8wOgL4RWxTbcU=Y3vU-s=_Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM0PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:208:122::38) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM0PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:208:122::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 04:21:32 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 160f107d-cab7-42be-4b37-08d8172ce8ed
X-MS-TrafficTypeDiagnostic: AM0PR05MB5282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB528269DD759E8726A3053A83C5940@AM0PR05MB5282.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u2N2JbdGdhS+qWNUd2/P4wwSax7T4SxHZ+yb6Zd7n3kxFVYZchzEVuaTpMP6AfSNjs7uBEAjuNRms7q2qDOM9PQsDU2CUVRzuKe3rqdS3/soaGX/cL/XVJ96Vs2if+ygyMRHwEwg4l2hQ2OOy6aF9tLZ34WP9Zvkw6byP88+N666rML06lPyYJkE2ZJebvZkI828xxwhz+XSx9uHQhKKVjWt3cc+fcaIQKaWOnCioi6pe1pR2eDwzcoCyHI8D10DEh29hKhkrjmCcljM992qj01ZIgObq2Sg8yfcfUv9jBtPIGuBA+xiNXDQebM1F7UnAXsPFggG6laae9mcvhcBCojtjlFOmPXPY09Q+62uD7ah8AdRGzdMcnFMwoCJTJFAtR9NRRIn2nTO5Q2NHJaMeZnHx50RoG+aSIL4Fc9HtbAARPGgzj7NziVXs+iyf8JWT4/E6gtztBUB1wu6XLeXnmFBNGdiqz4PSTkJa8RoEv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(6666004)(316002)(478600001)(4744005)(54906003)(7696005)(66946007)(8676002)(4326008)(52116002)(1076003)(26005)(83380400001)(66476007)(956004)(66556008)(8936002)(5660300002)(86362001)(6506007)(33656002)(16526019)(6916009)(966005)(186003)(55016002)(2906002)(9686003)(42413003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bOb2yZqsqPKNBKa3CAvuiXy0ylgTs7qSmoAFVGptGlPZH0Sv52vrwjfvWkDlHsKHq5U4jiTT5ttE8QzOK9I95H/2DcovGBclBao7ApaJiM8RAN4ZKTLoLL8uJzMT6271SHK85zzK2rV6/qQtTUybpCJO6y/O7YAS76LXEjEUGjuAOdzcQ1qYtFPOFNPH8eQ3r0MaKi1kGLfG5Momhqw6yZ501/9hv5rdZhqtEUCXjEj5gu0lEh3QzkZKJedrjSbcuE3VIU6LqH3U9AeGrnd9OJU1fBgRm2Nu0tVyNXS1PU0wpuoLKNMOJElDo0+XyZES2XB319O/xo/kU9r/uG3a8u2aOJMLOcFI+3DzOoLZeoLyLGc+53h36XPLP6jBwFLCw2PwpG0tGwdkDtN6tnrvR4g/vt9bmPQZUnV6awnRNPWpkId6NIa1QmxjIpmIUypvt9x0d/w7QPJlmtyXl4jWFrVnFWQhJb9ZglhcxhgRkXgjjImiqXjeZ5uaOiOYYpzf
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160f107d-cab7-42be-4b37-08d8172ce8ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 04:21:32.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r12iDJk+4bR8sVk9zX7ltxMFPoYrBQ7GS5AuFcteGIt8v77riXd1juNYx0ceQlEW5gxvOoYahRb3z1vLBXdB+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5282
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 09:24:25AM +0800, Tonghao Zhang wrote:
> Hi Eli
> Still not work
> 
> $ tc filter add dev enp130s0f0 protocol ip prio 1 root flower skip_sw
> dst_ip 11.12.13.14 action mirred egress redirect dev enp130s0f0
> Error: mlx5_core: devices are both uplink, can't offload forwarding.
> 
> $ tc filter add dev enp130s0f0 protocol ip prio 1 parent ffff: flower
> skip_sw dst_ip 11.12.13.14 action mirred egress redirect dev
> enp130s0f0
> Error: mlx5_core: devices are both uplink, can't offload forwarding.
> 
> The firmware used doesn't support that feature?
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=613f53fe09a27f928a7d05132e1a74b5136e8f04
> 

You need a newer firmware. I suggest you upgrade to the latest firmware.
