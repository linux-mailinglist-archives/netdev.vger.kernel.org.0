Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB02158C13
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgBKJts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:49:48 -0500
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:22796
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727966AbgBKJtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 04:49:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNEC2iXo1noQHpikdPOieHUZj+rIY75cxoHHptaqdyN0IONGqQ5rVD5DTnHUBRXLcLh8fvWaW/dnRrVK3HKagB81gZMasK1pMLTFAOR9Ba42iknPdekgo5d7b3TLwaqz0epJMtyoT+ujo3wjRC4Xu2Sk50lW6oTtPr6/N4T94nOTIAF7zMFFCnW8CxgGImS6d4zdhW9Ujc7NrkfAw4UZ31alLUKIR3GfAxUsXyLjvleI+/KYppQpOLpzYAtRFzyxmyWRiYN/8kN1I59o72DATilDVS0AQcpRpHnhaSXIfAWSAm+S8T74N349BYUXPzshT6MihMpVI03gVadF3kFudA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UefWr7a+IyvQbFJhpnq1wlR8t6er7riLjRo1pag15k=;
 b=b107AMRUqO2RMuZxD9J4Dv3cCxo1ZG+uvd8f/3fVMaykqoCIMZG8fRkWijpOSBisCeoL2BQ2pLc0XvlBND4ssQZdxTf8hsIRNdBdExXz/xefNbeL6NUlymSrtIsdgg+wFd1VmnI4KcLLeJjfrYZMmyWpAWCu3EB/FuVQMhuJpNa2z1qLpiH0UOwjsEnap/h3C8sTSilsFLpF0+JTXS9CII/pqf05X4QbAxKRGFkvgwRRYRMv7KdxC7yPiqFUGYCK5YpJW0/MRvlsYW4pJinVHSW5wKW4z3idsoCl4Ys+SSEpWzpLoLAOkac7UEH/P9Ko1os5q0G05bwlzWgQVz551Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UefWr7a+IyvQbFJhpnq1wlR8t6er7riLjRo1pag15k=;
 b=T4+rc25f3O9/FEf7wdxoT/A2zcEPXR89n4wiKiB6qjxbm8NxBRgMuQa3QeWz9AwP4QQh6xx83ZoaRh70+WM3OGrqNM5zSRIWMs+YAUcNdgdl4evWo59tTuS+NOvwHwRYlNV8Q/M4HsjoVql0LYFreNDhSSJm/5weaK4WqyeOvmA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB3437.eurprd05.prod.outlook.com (10.170.239.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 09:49:44 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::e417:36ea:e4c7:6de6]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::e417:36ea:e4c7:6de6%5]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 09:49:43 +0000
References: <20200211091918.20974-1-vladbu@mellanox.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 0/4] Remove rtnl lock dependency from flow_action infra
In-reply-to: <20200211091918.20974-1-vladbu@mellanox.com>
Date:   Tue, 11 Feb 2020 11:49:39 +0200
Message-ID: <vbfa75p8nd8.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0188.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::32) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0188.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 09:49:42 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 070b7d1d-d09c-4cb8-a4c2-08d7aed7b8c4
X-MS-TrafficTypeDiagnostic: VI1PR05MB3437:
X-Microsoft-Antispam-PRVS: <VI1PR05MB343758BBD98E3B14B4C8E851AD180@VI1PR05MB3437.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(189003)(199004)(2616005)(956004)(6666004)(478600001)(7696005)(52116002)(966005)(2906002)(4326008)(186003)(36756003)(16526019)(5660300002)(8936002)(86362001)(66476007)(66946007)(26005)(8676002)(66556008)(6486002)(316002)(6916009)(558084003)(81166006)(81156014)(15302535012);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3437;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHGhF7edgMKOjqwHaCf/t3XfvuGTo0tRKQHFdEBsEBdzp4wfvbKBtlgY7+Wh3QfIUxzsXIrRCdqLEgw9fF8Qw5YD9/WTG8eJPEx5hxJdKyl+u3BVRtCeDMByY82MhQsg1a6lNJU90EWxrisCvEGjF1uLM7F7vRSix+ZZ70ah7GsiCTRC8gf0M9cAisD/4KiFTQxFEauLzP0MLSGlpNyNc1aE+X/N22yCeKDeqhUTpx5TBVEeTGEN6RMqU8xxnUOdN+pSu8k3+lfV8KBVPFswO+1PTxk0dNbtCMSmNgbnxeULfSNEvdaTSdZipal4g5jrjpNcOtBWVhf0k+mTchriARFqCI4uHudbsdc9qSvrxTCj3FcKPiCUHoedx4HAs2u9pKkxvBZJxRssay6Mk5MU+7/FZNLlNrkcqeKkSc11t+BqdOZGMAKZaoB/z5ljf9C4ZZZxR4MlREglpYgS2CfbJJScWRiz1dvJ3FFen2oUowmkzA1XdpR5CZV9HsQn6bhoe4hrLtTqBOgNQgKO/qX+iPj5lYjByaHpgGTsd3mMCcliaied1ewl/xjHuy2AuQKfFm4x60W92q/CubWDlAlgbA==
X-MS-Exchange-AntiSpam-MessageData: kB77haVbhiTEMCEe1RVWYWXnfQfpqGEFUNuO4n0Sq2tpImn/CCdJIDnhRe1cfraRp9aNqfgB5OTPhzUBb2T+NrjMwFnqfAYsoA0gVzVObvPX3diSgfYKgmyjB2dYPKYk1NlqAlYuuprey7TQJRxVTA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070b7d1d-d09c-4cb8-a4c2-08d7aed7b8c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 09:49:43.8960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tjSpDZqrMrcl4fTMGALJAmJPXneKUN7HJoDaQrxAf8rS4+EJaqt7cy9EiV6aOKR3L7hoU1crFx6ntqhgilsF5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3437
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've just noticed that http://vger.kernel.org/~davem/net-next.html is
still "closed".
Sorry for sending it early. I can resubmit when net-next is open again.

Regards,
Vlad

On Tue 11 Feb 2020 at 11:19, Vlad Buslov <vladbu@mellanox.com> wrote:
[...]

