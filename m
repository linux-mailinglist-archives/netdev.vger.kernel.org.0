Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527C51814ED
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 10:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgCKJbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 05:31:50 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:62625
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728932AbgCKJbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 05:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7WQSbWrWsGkadN1PTiHBOxmlcPouBmjVG3sbmwvmXIBJh7lAy/o28yyH8HZRmiPLL2/wcvi/dZZSBxcOG7Xtaq1tvYSWDPHpPawCHCVBWBp31m3NM50aOAaWcrPXn8VT/waawebk6No6Bn8/Wq+fEHuk10A7s5DXHrzOn4Lhgx+LYBX6BsQl8ltVowdBFdjuJIuK2LXapNwvSx8hw5G47hYChT2CTWxzOvqqwjU1QGD1pA8wPPQa0rZMjqvTRQKfiZKfmAoS9nl7l5FKpBWSecbP9Ui2sHwY5TX4J9UP7qq3Oc5G9NBbmvGOZB2XRHSYRlYzttk1OTKexiynyjQoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9/wpP3YFizt+2x6g5MAtAGm1D7DxR+cruxzmnUJXAI=;
 b=mD9Os24dch4UlFsafmHkyTBuik56u8DftqBhqH567Gvrvm2Wv/qvCNYqdro91nO8DNre8YsuSMFnowX7iKxs9psmGAsCTOqGRtvQ6Y+/1MytLMCEC5k+5fx1GUUG3WqAxJBKNnstetujXLvQ8nTS7QZjPatg7xnklZc6ztPm6hzgJpbdpiCR9ArGuITVEjQQC1DowxTwMvl1ChXP7CegNraD88UQy8NayvRHLCVvtEtXt0DfE6k5X1VrkJ5MVb4l2MjyvZisDbwzqgvMPhigw8ca2/XHSM2HZ64BWXGo99BtpSRi0GPTSIP/qvaYv8Jyoqys7J1ab37543jgBIP8Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9/wpP3YFizt+2x6g5MAtAGm1D7DxR+cruxzmnUJXAI=;
 b=sDw8T31wQ8NuA/QOxxoMmwMYVYbGeC0Bz3zNtWsyhXmllI+2z1gYezhE15EQtbGO/lJy/YiF3a555QrGyx+BT49nknjgZqiH4Lnpp18wB9lWl4n49gR4GGrsroOk8FvcKlUiPYRhu+QI98n1B2gqNwcjZNhvdkbH2y5FxCQf3DY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (10.186.174.71) by
 AM0PR05MB4689.eurprd05.prod.outlook.com (52.133.55.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 09:31:45 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 09:31:45 +0000
Date:   Wed, 11 Mar 2020 11:31:43 +0200
From:   Ido Schimmel <idosch@mellanox.com>
To:     Masahiro Yamada <masahiroy@kernel.org>, nhorman@tuxdriver.com,
        jiri@mellanox.com
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kbuild@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: drop_monitor: use IS_REACHABLE() to guard
 net_dm_hw_report()
Message-ID: <20200311093143.GB279080@splinter>
References: <20200311062925.5163-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311062925.5163-1-masahiroy@kernel.org>
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 09:31:45 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d45942c-5260-46a9-b382-08d7c59f03e4
X-MS-TrafficTypeDiagnostic: AM0PR05MB4689:|AM0PR05MB4689:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4689CE5161EAA058E8F1D69CBFFC0@AM0PR05MB4689.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(199004)(81166006)(81156014)(33656002)(33716001)(4326008)(66946007)(1076003)(6636002)(8676002)(956004)(66556008)(66476007)(9686003)(26005)(54906003)(316002)(4744005)(6496006)(6486002)(86362001)(5660300002)(16526019)(186003)(52116002)(478600001)(2906002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4689;H:AM0PR05MB6754.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHguJD3c6oAbFBYOmZi3mrAn2S8WRwiBpmoxqydOjxGBDk/BuLFAxAAoUT9x2N+19mM42FiqLDT/WRCI42rI2NJVcvDFbNCZW5Tzbn7p6g4dBU95y00hyC8RCKtVybDCjBW4b6vNMZUQyEaE0V3bpGZrsZbT+ZbhxdZKuMU4c3gL5Bl3Ks/Y+fda3xuqX9Wmj26GZpRPYlIygvUNaysYiSOedUoBu8Joa47ECmo+0WFfRZmuFEoHm1R0bGMONwh7Rm31T9Y0x5vrauMgmtxQtPLlSj+DwgUTyxKDJCyc2dU/g7cjG4cZH09W4l0k59kwyc5QgDcyTphZD+t2fjYRbEZ0amQdEV9eudvBwm7eMqqY0YNP+Y4a+01gRwrrULevjMFICiOCw08SV/++wf876iis8h6AylKzH53gDDKrJPDwtqLFRMfHUKXlJkkJb24u
X-MS-Exchange-AntiSpam-MessageData: nEYCmgcBcMMVv8AhyWBpGBHWDFQvvnbLFVRH2ly6566hIZQ6G00JoJBTcgXgQsXBDR7Nwcb3dgx4ffNmzy+eTuSfL5pPq6oVWRPIz6IxGtBswjw80wVJuVGmJy2p2bhi1M+bANgQRxeNq88JfTyDtg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d45942c-5260-46a9-b382-08d7c59f03e4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 09:31:45.3579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVRJDoWXBruj/jhNnQSCTVV4FGCjw88ltfr5XUxednIm9XIAukZZ+p9a66s6bkKPILpucFi8gbSi1zOVmteASw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4689
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 03:29:25PM +0900, Masahiro Yamada wrote:
> In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.
> 
> The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
> from being 'm' when NET_DEVLINK=y.
> 
> With the planned Kconfig change that relaxes the 'imply', the
> combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.
> 
> Use IS_REACHABLE() to avoid the vmlinux link error for this case.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Thanks, Masahiro.

Neil, Jiri, another option (long term) is to add a raw tracepoint (not
part of ABI) in devlink and have drop monitor register its probe on it
when monitoring.

Two advantages:
1. Consistent with what drop monitor is already doing with kfree_skb()
tracepoint
2. We can remove 'imply NET_DROP_MONITOR' altogether

What do you think?
