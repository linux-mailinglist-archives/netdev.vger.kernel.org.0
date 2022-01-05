Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F022485769
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242403AbiAERkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:40:21 -0500
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:52768
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242394AbiAERkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 12:40:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCYMlatQl9gyH7b4SlClzYg9Lo7zzIsWhycOmD/6f3VTxj1qJrbsiwVz4+Hphg8h15TBI16ccWCiYlTF8QtfAyxOOt6ODZHv9bFkLvwsaNqrSOP8bSryt7QAnPh0mR4JdXV6dZVQ1z25v7IiHMyP2WVmR+Zquhxk4CwrSfKmvIc8Xxhf654J3Dy7FQnWhsR6TJcVrE/3vKX3GuVjQUKhshWNZMHwLocoMA5bC+A32yICQhaw7soiAC/U59x1QaGtJ4mwDzB7G5YLHJ5Cb96QqJWqbjAV5y2qcKegMzl9HLrXnqMQVEm/7DkefHbdjnT5DD1DXph2Z97wkSeMAO0cqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CMtlHGyFXyW2uJnaR27yMRJx8WoqP7AoHhaJi4NkZA=;
 b=O6MACzWxybrfYKGh9bFYjGqb5/a/1o+sDMshveBbwW7EhPB/WAjhL5Nzch9re8eIVPN+CWU5sbD34Zbd8TsjFKnKThSk4Pl1AbY5trt1DnC93nTqGqgqcc/v2MkyvFOo+D1GtbQesKEAWa+Guh3SlNv+w19DWXI1j3Vf0GhuwVAOPY99DSZA/+gzcfxMLYFY+xa7EAgh80xW0YGG3xKY1rP3/M8Kou3xtSqDOg/uCDwkt3sSHgiXAmWZI5L7kwbLSOxb0uPizDYT4B2YPrLG964v/kTNeKVnHcuzTukqzjmRSnbB9RsUD8BhuEK+SrNMUSsPiOxG9CyvMm7nO6lBGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.73) smtp.rcpttodomain=lunn.ch smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CMtlHGyFXyW2uJnaR27yMRJx8WoqP7AoHhaJi4NkZA=;
 b=KH1K44cJWrHoPQqvw/ldr6dpN/r9SyKwU3p1PqaR7P4dPBy68THZnE+EeDpYmv6H4JUZg6UHoXUjksHievcEPTqOe+C4MRcEcfvTNhC58A16WHbRL1KumQS6swYOYwaQPd6q540DT1xC9aNp6dO7EPpgz0qQi2esx64atrjNG76OXQhys97q/ZXfWvgfJFNMfZXXZlyPsoJeOMxWXlVZuH+XMHnw1B8eEyY8uL/pQLmKROKAuk0uF1vylBK9dx7bYns+o5BIE1INfalJcG1VLhRhqBIYUktEF3zzsTIxasbg8i13wCmhl5AM9o+A7mBlwbCAF3zGM06/nWsF7rcJKg==
Received: from AM5PR0601CA0063.eurprd06.prod.outlook.com (2603:10a6:206::28)
 by DB9PR10MB4458.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:22c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 17:40:13 +0000
Received: from VE1EUR01FT009.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::51) by AM5PR0601CA0063.outlook.office365.com
 (2603:10a6:206::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7 via Frontend
 Transport; Wed, 5 Jan 2022 17:40:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.73)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.73 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.73; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.73) by
 VE1EUR01FT009.mail.protection.outlook.com (10.152.2.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 17:40:13 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SNA.ad011.siemens.net (194.138.21.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 18:40:13 +0100
Received: from md1za8fc.ad001.siemens.net (139.25.68.217) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 18:40:12 +0100
Date:   Wed, 5 Jan 2022 18:40:10 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Aaron Ma <aaron.ma@canonical.com>, <kuba@kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220105184010.058955dc@md1za8fc.ad001.siemens.net>
In-Reply-To: <YdXVoNFB/Asq6bc/@lunn.ch>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdXVoNFB/Asq6bc/@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.25.68.217]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa39bea7-bf84-4a65-c8d6-08d9d0726db3
X-MS-TrafficTypeDiagnostic: DB9PR10MB4458:EE_
X-Microsoft-Antispam-PRVS: <DB9PR10MB445828EF71711237C0865F7E854B9@DB9PR10MB4458.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5eZu2faIMbtnhmL7qW+zUelzg1DM0E/lcjSokSMVLptPn+2nTXOwpOCFi85q4yKp4fNZ0g3DYVNRdSn9z+Hudk8rC5MaoZJXLW2v08AX7xSKz8UrKocuYIykhL1KkOgyJZHt0VBsRKEhyB30ZxsvtQfjsEY9pT1tzQxpQKspBkmn2JsBsZlzG4qAmGtVG1EfspvKkCPYb/qNIUTlWC7VFmsGwp0vRHdwEsUX7aqj4qusNQ/qOwTX7DpMzg5aNFYB1qu36gZMwPj+DJDK6/IbvKBTJ0remroMzww/DMDj0UFtjxInmWFls8tdCJXBOSzRCvU9V2wFxti9TlB98j9FvUP+1C5wezjU4tGETN5UzSC3WEz4FccKNwg6Xk6C/NjC4JSMk2kgVwBtxJfQpiInfHlKKLY94A7nScDslFW+ABq3X9mcrZCBzKw+N+kkeQ9/t9A3DqziYeaApDFogL51i5+EC/n1y0PdKIvvRVo9Ex3s0ujDWCxTpFH/FZlbas3C7fnbAt+QRw98xzBO4Na6MNCXAPGwUNL56s8rgZcplNz5OJGfOu+qdrsVhzNDgkqDJmxIZrxDt0VKH0tyEyTVAWnMwPkXxwLA+rMIDQtsyUMxvupwSXfvQXR452LCFCKHfnrSSNB3bDqKddwo84jS3QIG0COGd9+Da7N/CWx5CBYmr6ypdxL7owTWC9Sqmg2cTi7OXB6xUKW12McuFF0+9BighsgwxX8/WDskMjpfbw8U4vOgNXr6eo6P61TrGbaKfbHkT6JtsGqjWn70jd85aUIwdEsIPQLwcXbKz6Kqpw=
X-Forefront-Antispam-Report: CIP:194.138.21.73;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(4326008)(4744005)(356005)(16526019)(8936002)(8676002)(7696005)(316002)(44832011)(70586007)(36860700001)(508600001)(82960400001)(9686003)(26005)(5660300002)(186003)(47076005)(86362001)(55016003)(70206006)(82310400004)(1076003)(83380400001)(2906002)(40460700001)(54906003)(336012)(81166007)(6916009)(956004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 17:40:13.4454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa39bea7-bf84-4a65-c8d6-08d9d0726db3
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.73];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT009.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB4458
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, 5 Jan 2022 18:30:08 +0100
schrieb Andrew Lunn <andrew@lunn.ch>:

> On Wed, Jan 05, 2022 at 11:14:25PM +0800, Aaron Ma wrote:
> > When plugin multiple r8152 ethernet dongles to Lenovo Docks
> > or USB hub, MAC passthrough address from BIOS should be
> > checked if it had been used to avoid using on other dongles.
> > 
> > Currently builtin r8152 on Dock still can't be identified.
> > First detected r8152 will use the MAC passthrough address.  
> 
> I do have to wonder why you are doing this in the kernel, and not
> using a udev rule? This seems to be policy, and policy does not belong
> in the kernel.

Yes, the whole pass-thru story should not be a kernel feature in the
first place, i could not agree more, udev would be the way better place!
But it is part of the driver and Aaron did not introduce it but just
extend it.

Henning

>    Andrew

