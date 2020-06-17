Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D61FD384
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFQR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:29:47 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:6257
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgFQR3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:29:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcTYWDkhF+qO+TGJaDlS5uvhazARcZfUPTDHS8KfPWcG3UdBcbalvL/F8fuHE/m3ybxbFajXStN0xOSw7y+ba/aGTIRpqTDNdse097WgJ6ODawxMzroemHonwAStEjM+VBSq/+7lbwTx0pn+JcTAIEw1H8flx7qLEGcs5Gntl0UNnMMvHo8poY62V/WvgX44MXOKxBf+m21862lOkgvis3qhtIiE1mPkbLk1zcodxzWSXj/kbwRC3otUeMAmBBQ6fkveepcTEY/pvVPL9fEl7EvDSvjPLuB75iy4yecTcDpTFNnjbNohvKXd5QSWn+VvILP8vmNm0V3tonzvyzrQZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H53V2O8t14YvfY+kTJ8iDPeEYI3EtEb6mSz+J8AtsOc=;
 b=ZI9kuepJvfZ5MDE/dlDpTLm/i/KoV6c1f0PIRW++RsN2Sau+JJN62dR+rY9HpQn7IBOWyM/nr2TozjE9jlla99HDlRPPAeFg2u9pAdPUnUPEC+zU/mANz1LGaB3jF4fApMrdBJb10K3DDfEduHcYz9PDZSZwuupxDwje8AoS+qbN9Yd4KcF6gl8JprXUp24leQUpDOSyBD3/szZnmK9i2UbGNnVPBIhn82p9mBnt/xSlfYNTVz5aqQ8j0fWC+QxUYP5WF4SE6yn+1G5YtmlStFxFqltYiUdhceb95Ocaa9nmGFcSk3oWjKLjvZ+CA1pceVZSRCkuTQ+YWCOLSn+TDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H53V2O8t14YvfY+kTJ8iDPeEYI3EtEb6mSz+J8AtsOc=;
 b=IKYCmDQZnALkbArj5gPrZHnyU5TlQZDyahO+WZVJ2AlcgGZNQJITYAhGEM+CglHRxB6soOBCmB4yci3jiehXRRZHFkzdK7T0O4yAC6Ns/fXxdf2Fb1f1S9/yapWxXp/UHhyBuBvPWRlLwJYcnoq0EcmuCJRWyljaLM0EkIeSxWY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (2603:10a6:20b:15a::7)
 by AM0PR05MB4548.eurprd05.prod.outlook.com (2603:10a6:208:ae::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Wed, 17 Jun
 2020 17:29:42 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::c0cc:a656:610c:88f2]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::c0cc:a656:610c:88f2%3]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 17:29:42 +0000
Date:   Wed, 17 Jun 2020 20:29:34 +0300
From:   Ido Schimmel <idosch@mellanox.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 264/274] vxlan: Avoid infinite loop when
 suppressing NS messages with invalid options
Message-ID: <20200617172934.GA296888@splinter>
References: <20200608230607.3361041-1-sashal@kernel.org>
 <20200608230607.3361041-264-sashal@kernel.org>
 <20200609065548.GA2113611@splinter>
 <20200617162823.GR1931@sasha-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617162823.GR1931@sasha-vm>
X-ClientProxiedBy: AM4PR05CA0009.eurprd05.prod.outlook.com (2603:10a6:205::22)
 To AM0PR05MB6754.eurprd05.prod.outlook.com (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (79.179.90.32) by AM4PR05CA0009.eurprd05.prod.outlook.com (2603:10a6:205::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 17:29:42 +0000
X-Originating-IP: [79.179.90.32]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc7f35a3-1ac6-4775-0023-08d812e4055e
X-MS-TrafficTypeDiagnostic: AM0PR05MB4548:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4548448E255F660211210E1BBF9A0@AM0PR05MB4548.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVq3wlUpJAjNXwhIqC4mMCXJYaM5zfPRhxz3xqoqscSt8o1vfMfQaqJIGLEOolt+kTbYYm+Bw2mnXWcXzwB0JetA8g8GVJvPbCeTLj0ZrxsUw5f/FNl8BaicRJYwsw2WXJ9f2Rd7ovS8IyvyKonPj0AlAJ6IgsUHK2QHU3pChItJ3vBjsLkqq8+cCLEycT4GpFTT5zeiyaooxbed/VrX8k93ip4S1uGvbWgj0KqqxkgAsU/vwY79dQH6E74f1al/E7IL+kt5wswPgXgraNCmym5caRrneALI2H93q9JAHB+MurtofWWTMPm9JoZN/fBbohG7iAjjSPkXaBhy+X4x4qbqnyA+Cou/x+APrtRl+ZZT5KgRjJLejLGH9dOBTjktiBptGQ17e3JDJESfS9Rd/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6754.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(4326008)(6486002)(316002)(33656002)(6496006)(52116002)(956004)(966005)(66476007)(16526019)(186003)(6666004)(66556008)(54906003)(6916009)(8936002)(478600001)(86362001)(5660300002)(33716001)(1076003)(66946007)(26005)(9686003)(2906002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: K+iK/wL3wQYPsQPs7HzaIkX1WZfg+XXF9s2HbphNCw98ZD5XdRP9vvYM10i7klSnyD0PfdfcmdqhmQbkfveILEx72d4LYPpVfJDcXEhHhhaIYmn4bj0j7DGOGholgOfgvrquc2mhe1KlIhKKgdRzJm11osNzOFUNtNuOtYEswzKrfoPE4GddQVtV9+Xc6bjjge8r+bIih4jjajEd6GPuoqQnWT9t8h8HgK37raXIQNsAj+agbwHfYvt9ur+WxV33MI1bQnAC57jusXVugHN5BfY9tqVFflH7ScYP7BHSXrTv/emsnYwcFt/0Mcz4v8oCNfPP68CRXbnNSKwN21FZHhuB5gA4eV2cqWmjlRr0YZePeMqe0Qjm/ig2esXuZPZwQkCZenHDRQASHLbNdh99VjoThm21/HnHrBLvZ4qaPhuQ/MQFqgxYIakL7zZPePhn2381w2/rChvT00PuSrkEGE5Kn1l9hPt9vdMn1b3WwqI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7f35a3-1ac6-4775-0023-08d812e4055e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 17:29:42.6487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXelFj/cjLcNIjema3T1MEFVUFQtyUTLNZkes81z0y6UD52ZU7vqm49c5UspbEfDJc75/2Rpkx93Jl1HIBBtsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4548
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 12:28:23PM -0400, Sasha Levin wrote:
> On Tue, Jun 09, 2020 at 09:55:48AM +0300, Ido Schimmel wrote:
> > On Mon, Jun 08, 2020 at 07:05:57PM -0400, Sasha Levin wrote:
> > > From: Ido Schimmel <idosch@mellanox.com>
> > > 
> > > [ Upstream commit 8066e6b449e050675df48e7c4b16c29f00507ff0 ]
> > 
> > Hi,
> > 
> > In the same patch set I also included a similar fix for the bridge
> > module:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53fc685243bd6fb90d90305cea54598b78d3cbfc
> > 
> > But I don't see it in the patch sets you sent.
> > 
> > Don't see it here as well:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.7
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-5.7.y
> > 
> > Did it get lost or it's just pending somewhere else?
> 
> AUTOSEL ignores net/ patches that are maintained by David Miller.
> 
> I can pick it up manually.

No need. Dave queued both patches to stable and they are already in
5.7.y:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.7.y&id=f3f4183f6d36df54f5a867653c30852ec6b5ab9d
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.7.y&id=ecf0b3c5a6684fcf27073365d576164390bc000e

> 
> -- 
> Thanks,
> Sasha
