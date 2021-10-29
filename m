Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC5243FA57
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 11:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhJ2KB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 06:01:29 -0400
Received: from mail-bn8nam08on2076.outbound.protection.outlook.com ([40.107.100.76]:57106
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231569AbhJ2KB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 06:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOoN6lptnVOQKUUULdqngM5SQPx+P3lD2RKszeuXWC1SMdHU9tl7atmobDqeKzO0sInjvs2s8D4Xv/Rrv6NXJMpz6PJN1L5PvPy7jsfg5GAxHbE9qCn5b5VovkciqlEw/l0ug+LcvCAjj5Cdr4oR92dlMXGr2IZsx/hJ6ABzZDiRFlCnJcIpalgtkkbKFAskgN7/6OdXYvILE9JSwYf0P49vCu3HF0lCVEALvC2O+07jy4xdDuB60SGeZxBjO6zJH2wKyJPKup8Fnazr4QZ6IcATJjfmrgT6jPkUJtmGQIT4yMTw+NjvmEygQR4d9kZ9//EO9RaY97NPXcfPPRoMPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjoYd08joD2Vfs4fFfKkYIuRX4kHiZ6Qi1kizG6dsZE=;
 b=Is7J/up7kWUMyvrWKlqfowLV7qcu0JaM5vxTG/FJ8ybXo6tsAbVNGenH0uxWss+FxYY0ExBGYe5sY8KIlJ4EDBFAyRIpwz3cXAJoD0mj+PYDTbK2dOdBXnLUD/sm0pJd1jlcoxuaj1ER6oztGjk2AlInHGovvrVEn4bp0dTkp5kgJ5A6TDB3vMbUyb6jGF4QJAkMGhQBZGRP0h1fmTtNlW9N5tW21f2SFbj59dl98MPDDEzlByXK7FXfBxJoYpDr/1EVSBurtdrRw8c+taXZQSTxPp/QskM382XQvpHlsvK2UO/0Dtig1S+OOnA+u96c1OT0eHFw3gjQ+IIaCe3PNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=idosch.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjoYd08joD2Vfs4fFfKkYIuRX4kHiZ6Qi1kizG6dsZE=;
 b=ODfzZmv6W7MRYz3yCWKB+YOydw2d1lrYyNms49VFLmM2w+889JS1DY3ZOf/3kGtt8VAy/3JHaSbUYqhUqSHHofjjz7DxayA2JQ3J0bgfr4lYbSBeEhIuGHnjAprxJW3+5njWpNWMPs7NeoZdYLEgrhMi4WiNVqNw4jjNhVP6oK/A5KHOj9cvAmCA0+KGd9tylRb4YW0KFUwV4asTLbn3jUClHe3yArSgQgvF4ogZmQIBYJxtc9Sq30R/RKhlcPorE4J+cirClFwhbVoXSFHZkbAE9rJbcT4OtMDsQ1kxI9PtxRaVP4gI7naWTe1hYVENTWXklZpMIOCTw0RN10iOpg==
Received: from BN6PR19CA0063.namprd19.prod.outlook.com (2603:10b6:404:e3::25)
 by DM4PR12MB5151.namprd12.prod.outlook.com (2603:10b6:5:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 09:58:59 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::38) by BN6PR19CA0063.outlook.office365.com
 (2603:10b6:404:e3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Fri, 29 Oct 2021 09:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 09:58:58 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 09:58:54
 +0000
References: <20211027152001.1320496-1-idosch@idosch.org>
 <20211027152001.1320496-2-idosch@idosch.org>
 <20211028200804.63164d3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <petrm@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] mlxsw: spectrum_qdisc: Offload root TBF as
 port shaper
In-Reply-To: <20211028200804.63164d3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <874k90dueb.fsf@nvidia.com>
Date:   Fri, 29 Oct 2021 11:58:52 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c8f8755-445f-49cb-f6f0-08d99ac2ba28
X-MS-TrafficTypeDiagnostic: DM4PR12MB5151:
X-Microsoft-Antispam-PRVS: <DM4PR12MB51515235F35167B380141AD2D6879@DM4PR12MB5151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8jHFWVEwWm6n4hHKMJa1QI2Lrca8x3PwTYptidbgj3BuSnJi3XHypAoxVpKyixkjm1mnHD9rh1nQ3R5MHF9ac8QrkQYKGZPY2t8wJjDFN7vYsfdewv4tqEC0yIlgK3rkGtP61TgWynviSry8ooEECvuYvHyQkkvV/cjfLcjjoWGC/nlSJXCNVgkg5WYc+aJcm8ngmyT8VKJt5WICV3SexsPkxhkrNxoxTNfwgiIAFQNGnGAD2R3erPFTfXqWW5ttu0wnX6toGECk9nZ0VdZcQo61RfZ8GsUEVIUUtvEs8uIGMd8A0u1pZaRo4KPzL+/LPm5QwpEKkLo9SIs4R0yRJWMzAy8HAF/8WcIFVIU0mc7h3aURnSLqZuQkobHGQ+PKIBwJg5giJneSSjveFn8tPZLcamhib9hx+tV5AWlZJXA7UZVT/XorkEu+QNiBV2p2bOyNGPW+tfiwWV8kzWzL2jy0ys+4c/EtV/91c8RjpL10oXr3rMC9YzltHT8ldKGZGlW42MytcNm7cMBZ+ztmXrxwJH1KuNfqlrfViGet0FTakR0STx3Vtt6j2R3Bb9KJ8p/hf6FD7t157Hn0Kp/g3Rifz2UOOcoL0+A5SVBhdF8xwO58vxfUSaSiFTswhnDUz4I5o4cvWJwdIR0yhW35LXE9QvJw7CxQAPUkt+itKYMU19csamC0Ww3R2ahe5coTQGrI0P3iVIOk9EJ3L7/Og==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(336012)(508600001)(426003)(6916009)(2616005)(82310400003)(4744005)(86362001)(36860700001)(47076005)(107886003)(2906002)(8676002)(4326008)(356005)(54906003)(316002)(70206006)(8936002)(36756003)(70586007)(7636003)(16526019)(186003)(26005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 09:58:58.4986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8f8755-445f-49cb-f6f0-08d99ac2ba28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 27 Oct 2021 18:19:59 +0300 Ido Schimmel wrote:
>> +	 * shaper makes sense. Also note that that is what we do for
>
> That that that. checkpatch is sometimes useful.. :)

I think that that that is legit. The first that in that that that is a
conjunction, the second a pronoun.
