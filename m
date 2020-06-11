Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737571F6170
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 08:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgFKGBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 02:01:31 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:24565
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726147AbgFKGBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 02:01:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S29bDqNM4YAuDMe8rWpVaMlLYfRr+OjEfCD/Tj0oo7NHOt0HyOxxkt5Lxa73DlLwbpPTSnwVWBs4DCcObs/YrgigbjosGrkn8i/F6RoEVFtFvpd7HUBDd7LsQ/B7UfOr/xv2tCjiwcOd9/z7m5Fs4q1pmSx20TlMe8HPwE1D3eNDOOun1KA0GyApW0gcUjwTNb500FmMaOlRJRYWQ5oPqF9ns7rcmx8hNouIFhuztyvfpo0POvncFnMjuu6iaTdTc9EncRzqiy/3u0FXVii6utLkNqTzq9ZXPAI5h6b88GwKjZMQHtqozQyCNmJ8AnAB0thczeeVf6NQwLnhaNEvTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIUuMuufzeJCP5/X4cdbBuK6gIImn+i/fxafbMOiNIg=;
 b=YE0OLMxsKIIoAbp8c01qsuD/jyTZnMt4K6ina/22+3SMHrMCl2gy3rcQIlALyv9XFTHM3KVv2WkNJPx1RLy9ZBKlOavB1fkRw9JGGe5AqmXQ/RDrBe7Fczys0AByMnTaP5GEWCLZRwnV2Fwk4iuJg9Y0zw7cZ7MCvRjfrpO9PKXvp4GGxhQO0qX/PKtWZUiOn02zwFUh5eIuHcXHI6nRhLdZ2znQLM2DX/9tPBjA86a9o0+JkAbR0KD4/NwFST78cMrY+CjS7K2cdd6CKsojPvC6WItRHk0dfrnPvhram5O4N0Ikec0gdC16cL+tNrJbtDwwAhHt/XyhgJWPrEFeQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIUuMuufzeJCP5/X4cdbBuK6gIImn+i/fxafbMOiNIg=;
 b=GeYdPkiOmBlwszAHXNpss074+/fK55o8M9LiUnpLcxRuOagwPBrnW2TgZznVTyoocWrUnPzch0J2R/Ym+nJs5pmn6KFcvk5zSD59CXgaZxriHvHaRiUyfrqNxyJaa1bT7mdzBXQMqAbXoB/vurwcHDQmR0ClCUEfr5UCXARpXxw=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5234.eurprd04.prod.outlook.com (2603:10a6:208:cf::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Thu, 11 Jun
 2020 06:01:26 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 06:01:26 +0000
Date:   Thu, 11 Jun 2020 11:31:18 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v2 6/9] net: phy: add support for probing MMDs >= 8
 for devices-in-package
Message-ID: <20200611060118.GA25091@lsv03152.swis.in-blr01.nxp.com>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
 <20200610161633.GA22223@lsv03152.swis.in-blr01.nxp.com>
 <20200610163417.GR1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610163417.GR1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2P153CA0012.APCP153.PROD.OUTLOOK.COM (2603:1096::22) To
 AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2P153CA0012.APCP153.PROD.OUTLOOK.COM (2603:1096::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.0 via Frontend Transport; Thu, 11 Jun 2020 06:01:24 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd12b046-884b-4c68-5512-08d80dcce012
X-MS-TrafficTypeDiagnostic: AM0PR04MB5234:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB52346AD6ECC075366019210AD2800@AM0PR04MB5234.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MNIXrv7IL4lZhrkg6bSu7Wi2QffQSv7anL0ZsgmJzVar1SYRhMqJmQtyKgZBFjnT6H9yUE9amTq88qCX/mz/D4ZZNjgJc3F8PT3ReCwGW4y027acOMTt1wQSPeRsAsIF7Arf6DJIP+jyqY/Wan9bCsENIgki0rkZcj/jFjw/uToyBM0O8uWAp0FhhW9Pr+LMF50MHSXFVWq7P5w6aG3WkX6JLVkhxCeEODh/qzpFALmPSMvL9V6gOFh7nh3Aqn7kw5zVwE/cIk80P/hVJHAW5ya6zGm/8I78Rz48PMoTcso8uwpSDgyzqyN/XF7KVpGG29hnPabtHObn0zhag7ZPJuDP7G8ord7jUtkZWxRthQSY+OkVP42F9iac05mDIO2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(1006002)(66556008)(55236004)(83380400001)(6506007)(9686003)(2906002)(4326008)(26005)(52116002)(7696005)(16526019)(186003)(1076003)(5660300002)(6666004)(54906003)(6916009)(956004)(44832011)(478600001)(316002)(66476007)(8936002)(66946007)(8676002)(33656002)(86362001)(55016002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HzwXwhND9gtmu7hoq4+qVDvB2/XN/9W9EF0NDzSKNEnva7v4CqVT+2gu+E+3Ggu7fzfXpuleKURDshpS1j8OJAMVv7kVerP1MbHBKrigaHx+Opa+bHUWjO8hBWkAsg/nRd96Tci6MSmNNSR2d8pvjg7noyHeZ3DYYk/l0gZELu2EjCNahBeknUJAPIZU0upBR1kxj3H7Mobvf/mcdguJewrQX97ZZ7XU66S31kS0FN4wOZGxV6oJoiQbI5/8jWe2jNyC95NUz0JkR6WxA93u+1IhyTueKZjkjeD6RuApsRH0VqIHjoGjVmQeHYpOc+Tdn5BLkhhUC3N5ve6FjQDvdwwuWlOB7mHav6tsRve1iNP7ZPvVO8z8r5wC1cKg2unnKgMaHMOsfS00gOQAmBQh1j08OF4/bEnvR0YVS1RraZK+XsoE/2to7tGSR+ION91bT3ui+yIAogUDdWWiKzpLNiZ1tSXTEIq0ur7YCmmTk3lYHvw8oQ7AYaQKQaZWRFBz
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd12b046-884b-4c68-5512-08d80dcce012
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 06:01:26.2399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGs7d7m41NiN5N40Q7UlamxvMAVFnGQ0FZY5upqJYYXvQJI0aqwt5X0Z5fwfcG1gq81Km5gZ5j8GOMQMXffXjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 05:34:17PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 10, 2020 at 09:46:33PM +0530, Calvin Johnson wrote:
> > Hi Russell,
> > 
> > On Wed, May 27, 2020 at 11:34:11AM +0100, Russell King wrote:
> > > Add support for probing MMDs above 7 for a valid devices-in-package
> > > specifier, but only probe the vendor MMDs for this if they also report
> > > that there the device is present in status register 2.  This avoids
> > > issues where the MMD is implemented, but does not provide IEEE 802.3
> > > compliant registers (such as the MV88X3310 PHY.)
> > 
> > While this patch looks good to me, commit message doesn't seem to align
> > with the code changes as it is dealing with MMD at addresses 30 & 31.
> > Can you please clarify?
> 
> IEEE 802.3 does not define the "device-is-present" two bits in register
> 8 for all MMDs - it is only present for MMDs 1, 2, 3, 4, 5, 30 and 31.
> None of the other MMDs, even those that have been recently defined (at
> least in IEEE 802.3-2018) have these bits.
> 
> Hence, we can't use them except on the MMDs where they are defined to
> be present.
> 
> I considered also checking them in MMDs 1, 2, 3, 4, 5, but decided that
> the risk of regression was too high for this patch; that's something
> which could be added in a separate patch though, to avoid having to
> revert the entire thing if a regression is found at a later date.
 
It makes sense to me now.

Thanks
Calvin
