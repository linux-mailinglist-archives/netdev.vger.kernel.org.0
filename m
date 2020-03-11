Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743C31816D4
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 12:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgCKL2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 07:28:40 -0400
Received: from mail-eopbgr40070.outbound.protection.outlook.com ([40.107.4.70]:53987
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbgCKL2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 07:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfUPBQ3YDh0GHbex+430nhADcTjFlTucrpAqCfaw1CiaERLmTsJR2BwSOCQEdfioBMVh9VsYVeKUoGsrDy19LKJCyXwBaHTRQWqq7Vi1CtTW1NyzBiBPl5g9BFC0ZJrm1KmYT6pfKqvki0I8Bhr4IlLDAP3NrwebOo9ZP30SPmQz+CEnks1dSuaIldgncYOWPjSb5xEe4IaSSNXiDA7HC5FxxqPrJRudEWLjyzZ49D1PHztBFeyljBjMKw1r0VIvTI9WJRJxpZRhS+r91rsiazV2NIAkCmqNhL8LfIPcMSoqJiW762DB57iuQLVmNAp4GIlhvNkoRQA3hceqMqDSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FDCgK9QntRL0SGWTjUNlfiKCR6JSZKdt+pMYACSGPQ=;
 b=AyyrIVhTyCfEukIoqtgpKMZu5seNin9etvAUfBsF5gzGW83FazLtP80HNg84IusfrXHVEn+QeNeo3Us24G356tQO914uAML2SkXryQb1hsathnDawATq7TfCq3cCLZbUig3n3N9iI0TWSUQiz21GsQyb9fomDGmGedopyYkx/F7WfDRGMZLvsTSXzWFBLtcIxxHc+klF7ayEEt6JniMe7okEdScml+Dn4496bY3MvAoM7ZvLYkXTBXv1xN1pOjF7Eu4nvpjy777H2BTuPbbMrGfRU35JuL+vdRACT7Iz9/f6QIRQLjO3p4hdpguvie1r9/TxO/Q9j8gofZgNmosmUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FDCgK9QntRL0SGWTjUNlfiKCR6JSZKdt+pMYACSGPQ=;
 b=J6Jl8guIvUo/2cXK8aNRskPBSf62bpGVhOrQbO/RAo7UWNl0wmGIP0vyXjKAIxkIy8WFLMX3TG8OHP2bDlU7epv7q0mI0kCB4/od8H/fl+A6lbeDs+ZYwbw2ubQe3bbJixb9n8ieDjAvu/3dhQj0Rzgh4fM6nXTgTwHlF7TFdNE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (10.186.174.71) by
 AM0PR05MB4258.eurprd05.prod.outlook.com (52.134.125.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 11:28:36 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 11:28:35 +0000
Date:   Wed, 11 Mar 2020 13:28:33 +0200
From:   Ido Schimmel <idosch@mellanox.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>, jiri@mellanox.com,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kbuild@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: drop_monitor: use IS_REACHABLE() to guard
 net_dm_hw_report()
Message-ID: <20200311112833.GA284417@splinter>
References: <20200311062925.5163-1-masahiroy@kernel.org>
 <20200311093143.GB279080@splinter>
 <20200311104756.GA1972672@hmswarspite.think-freely.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311104756.GA1972672@hmswarspite.think-freely.org>
X-ClientProxiedBy: AM3PR05CA0140.eurprd05.prod.outlook.com
 (2603:10a6:207:3::18) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by AM3PR05CA0140.eurprd05.prod.outlook.com (2603:10a6:207:3::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Wed, 11 Mar 2020 11:28:35 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dd838ad-a7ea-446f-e6c4-08d7c5af565f
X-MS-TrafficTypeDiagnostic: AM0PR05MB4258:|AM0PR05MB4258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4258BF77C91A5A2119F6E810BFFC0@AM0PR05MB4258.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(199004)(86362001)(186003)(478600001)(33656002)(54906003)(2906002)(8676002)(8936002)(26005)(81156014)(16526019)(956004)(81166006)(6916009)(66476007)(52116002)(66946007)(33716001)(316002)(5660300002)(66556008)(1076003)(6486002)(6496006)(9686003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4258;H:AM0PR05MB6754.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vaueLhaj1plfy+nMW5Gp7MkOdRFME94v7D48RYsF7QD7Ilgzr7gdnKuaCeVOi6XOhZRYif2qUXxMiyYzcipFeHYD7hFqI8bsvlHAQzYgZDAQZmpv4VmHLGEBUGadw4Q9a/mVKd/9D6ozyFVtVmoVLFHkxUGDQAv7ffTD0SzYi2Ily5VM+8iY3KqqIlyE/vLYRiOQQfX02/cyONxMt1w4oXRVXH10Yz1bDa3Smoo6ho7Gh7jT1uJbk+6cKQ0Jo+E4aqf3PzKma4HMTDIFEyFT8Lq69noaYBQgoQbVWV6ikez4bAagD7seYmRFxM7aezaQzPv1c+Lo0Tu5ZMfwfnO/ZenaozaZ5kBTfz0Iy5cVIPIqNp/AU+StTFN98VV89V/FbXPFeTOeQYDmUE6qRTzvmMkmLSQK5ntdqco0FBTFIoOKVmi9g0oMECSK5NFOAVRV
X-MS-Exchange-AntiSpam-MessageData: c9Kqqo4I9tr1EXUaDaZak2baA8ol2rIRP5DMykQFFtD1wAxxM1FLZW8mtqYxY/MM710CD4f+e96qBTtWmdcvFismNIM6RqlE7yn1wP7+f6v+gOG2hAr9Gm64mvFF2mJV3ngPR23NZivMT13J0xDjnA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd838ad-a7ea-446f-e6c4-08d7c5af565f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 11:28:35.7927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KobMHe5wkS4FS2umfT1FTH1r82EvGJ8OdHgtXQZ4Zv7U6wn8wxWMGfbx/bDQQ2wmGAPDwP1G+1cEnYBQN8oCjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4258
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 06:47:56AM -0400, Neil Horman wrote:
> On Wed, Mar 11, 2020 at 11:31:43AM +0200, Ido Schimmel wrote:
> > On Wed, Mar 11, 2020 at 03:29:25PM +0900, Masahiro Yamada wrote:
> > > In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.
> > > 
> > > The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
> > > from being 'm' when NET_DEVLINK=y.
> > > 
> > > With the planned Kconfig change that relaxes the 'imply', the
> > > combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.
> > > 
> > > Use IS_REACHABLE() to avoid the vmlinux link error for this case.
> > > 
> > > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > 
> > Thanks, Masahiro.
> > 
> > Neil, Jiri, another option (long term) is to add a raw tracepoint (not
> > part of ABI) in devlink and have drop monitor register its probe on it
> > when monitoring.
> > 
> > Two advantages:
> > 1. Consistent with what drop monitor is already doing with kfree_skb()
> > tracepoint
> > 2. We can remove 'imply NET_DROP_MONITOR' altogether
> > 
> > What do you think?
> > 
> Agreed, I think I like this implementation better.

OK, but I don't want to block Masahiro. I think we can go with his patch
and then I'll add the raw tracepoint in the next release.
