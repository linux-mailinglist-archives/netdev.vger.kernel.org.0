Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345D3EC692
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 03:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhHOBJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 21:09:30 -0400
Received: from mail-bn8nam11on2113.outbound.protection.outlook.com ([40.107.236.113]:38464
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235342AbhHOBJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 21:09:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIIx92NwAWE8YbH51yGfyQBIRA2K472owoai8VNlItAyG/fT+KQOgn2ABr4FURp/8IW0XtMQukh4VlQkFcEpmQnxJiYpfQGr5yMxQApiaArW4e+vPTQQhEGz8uP8+htfNPu9WJahJ6MH2QDfrtd4Q3PRfFnWEl5LgxtRELzuHkblWrYTH4feNuSlE+VaU+2xT0ZrICTdDBmB2MOa7h6hyZ7UhQdF3wKe/YGR5JxdwORNTl8ptbP1h4ze7b5tiftG08xziySt0fuYVhYLmLXxntvIpBKOZEbI6vdL63kWVKRi7gQo0OWSI2CNVMk+d42xfEEugzNrCbtg00SrJETR/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRLzMVePvb2806rgRgG2sbH/9zHRTabN/C5BTtiUibs=;
 b=CQyyuwFqdDiVjV3swI7wxxkB01R+su18BJKaEC9DhPDFqHfB3TjmgAeoKHpQEGASyk5ffglRaIlhXeX41ki+UUnYKjtYFlIqVy4XUmlHOC/Fp9PVDwaUwdK4T6n5+tLSHCQ7sBWwdMLYhPp/JYFLam1fYYVPEySzR70mwB7eqc2yovDi3vjkUuun4DkhtBTxpZu8JQfFpYHJmqRhQRnBkZskKoz5n/0+OTD7G+XyZWl6CHzDWthJj2KbzhkZ/JdWNFhsZ9yrfyAkr4SJSnZydxOTpADnaZrWCJQ3vVTFfXWycdqbp3/9/wwrZyVcBp8EENFmFtv3KwsBbfFhkCAXWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRLzMVePvb2806rgRgG2sbH/9zHRTabN/C5BTtiUibs=;
 b=a765nCqBb8lwVEvULfmIRdBJqoEDF02Puxy4XdIVFS9TqqfM1NWFMcLbKG+xX791VonRyBT9LRkW4aE3wEW+xErMBdppafshOjPzV0I2iweqQ4eRsonvn5UVRQ5JCTspAwTIXI1PIwM1QvTBv1y5+b+tzvLOV9oIPuLQht8PrZA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1453.namprd10.prod.outlook.com
 (2603:10b6:300:22::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Sun, 15 Aug
 2021 01:08:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sun, 15 Aug 2021
 01:08:51 +0000
Date:   Sat, 14 Aug 2021 18:08:45 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <20210815010845.GA3263023@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
 <20210814114721.ncxi6xwykdi4bfqy@skbuf>
 <20210814184040.GD3244288@euler>
 <20210814190854.z6b33nfjd4wmlow3@skbuf>
 <20210814234158.GE3244288@euler>
 <20210815000041.77cdk2bu7qrm5fem@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815000041.77cdk2bu7qrm5fem@skbuf>
X-ClientProxiedBy: MWHPR2201CA0056.namprd22.prod.outlook.com
 (2603:10b6:301:16::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR2201CA0056.namprd22.prod.outlook.com (2603:10b6:301:16::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Sun, 15 Aug 2021 01:08:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79bcf92a-dee7-4c7b-5af9-08d95f893e10
X-MS-TrafficTypeDiagnostic: MWHPR10MB1453:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1453B1348E2E21C78CCD1796A4FC9@MWHPR10MB1453.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tcoDl/gJke/CGHeLFhi84fE2lwD7X1NagepfcpiMQVaZPcIIJ/RW/ICe+ZCOh0gfgjhXginYCtjxxQSw1sYWIiKtUGzanRLPINsDliErOqlIg+k8uiss96QMqaFhRurnrCV4G4/zvqHEMBSDnNkI/I0rrTROHIypHPRTievie/qnHZlFO6dJ6Q+NF34nMT+r4IKqGK7We1Mu1R5c+oddRBRFO2iUovwgEGhzSo7vnnsUsWa7GHvA9nYQZfrpoqDgTOxPfu0gv8twU9UM/RhUMDC2mR6vVoZsektIJzd01xg0YKrNUPUc81PhNlNcR71aL9xQ5lHLqxs2a2R00LRktJWRBXYnI+ymILPsWkFBqrmjdm6SGkmXZsbdZLMC2CS9Y9vSAIlTMUd8X2JcAuSEgKQ0OBCFWv0n0NdVUacyvNCyxWvBjJF6wHGgW2etk/Ijg1wxcv9Cefp92/ceA1G9kCr72UiOC1+Dwpf1pNTuimlvhR8dFIZhLexVAXSz8zo0OPgs0tKaylAinjk+W8S1Vt4PDZscdhIWb6GmAivffkHjgW3kYp/apmC1fuCnSPV2kPNydDhsGc3tUB1wDnikx9umwlPk/g+vBCg1FUt978NQnctbOHUDNtwZV3En8885LG83JMMyYAz8eaEh+i4PYCepU1nqiwPyG+Qs46T10SOdK1uPRLZRCp+c3CFcem9RVuNM5G+JO2G2LXemCvKHyS8ub3wCfXYhevB7uvn6QDU9srfrTfXdE0fFhtI1TpWJgVJjz+2LPOXEnEzEwbaxKOdMq26AOhTOqpDFxemBqaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(26005)(2906002)(55016002)(9576002)(186003)(316002)(52116002)(966005)(478600001)(9686003)(5660300002)(7416002)(44832011)(6496006)(1076003)(86362001)(8936002)(66946007)(83380400001)(66476007)(6916009)(66556008)(8676002)(956004)(38100700002)(38350700002)(6666004)(33656002)(33716001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meJhBIwy+LWCB5fvrPtMoHPqwLiWlp/vhS8JnWixWtpemhjpCOPnCDnpIwA9?=
 =?us-ascii?Q?gZXxs4YqqKKlOB7WQ0a1vtcZSYD2JGwItITB/Nr9t+vA6n44Sw7i2JGk99mA?=
 =?us-ascii?Q?3aWVdZGB3eUvC/h/P4o4DvNx5An8Ih6Qv4TiJeYd3p8MUZKSvMOMBdPba28K?=
 =?us-ascii?Q?WjerBXbNrTBFbiEhmD3BhOLfYKZHbfUNdIeDg4u+fnEcrNbdJ2oR2wUcUGZr?=
 =?us-ascii?Q?xNxUYLc2/nvYAeFsGmLvK8XZHTSI8rS827QUCdp7+iK2ih8nPcoIrHjjStzp?=
 =?us-ascii?Q?IDOfaxETw6DNCI12AUmU2TgcLt6/hf3F1mQppHua3Krcqw+cBjqKZ5+JY/jR?=
 =?us-ascii?Q?JtCd4tmaT0dmB7Ik184dE9pCyA7+N35SCSeycIdHSQSSEMpxTnMlHLKibXQX?=
 =?us-ascii?Q?ks5Zq+slEdaqHvLUh6BLmoE0PwEMqAABKmtPnnmnf3e7bfoNn+StTPV9BNAI?=
 =?us-ascii?Q?9mT7O5rF7pijSEB/y7aL0HvxUSbylkc+GSwWDi98mXZzsUCcGqYT9Qg6UKUy?=
 =?us-ascii?Q?1gr1UiqFIpc7/Jz8YspnC0e+kcrs0tc0msbVhplH96KaY10RJKNfY/3pF8Ke?=
 =?us-ascii?Q?eIY6BO+o/nu+X2mEWVZT95hq/58r1deVTwkJue0bM7qrubl8TCPdFlGNACzu?=
 =?us-ascii?Q?goAgFE1J16O27EkGW2xR1pHeVhlf9bf+qsoqw9sD6BUHyhbkW7cG5zcp/uXP?=
 =?us-ascii?Q?sir8APdtS0yn7i1mmJt0NnBZZo6iAj+B49FLb9jsx5Y7bbVwoRdP5YLyBSbw?=
 =?us-ascii?Q?Sj2aNPQbzNO9LKZ1BBWyl14dv9KoH7fh2JhrwEW69JLrMQM1WvOdWXkYUsT0?=
 =?us-ascii?Q?8F5Z3aPNaqEru057Eg6IGQvLyG/0eL6clmPwgyrql1tGFMVwA5uqELwvUEVR?=
 =?us-ascii?Q?NS/e3q4GkxqeEIEkSp8yBRJlWJyfq/1mqPiUqQU54kbwih836tSHHz1kPfK4?=
 =?us-ascii?Q?bKGKQFOKAV5+KMaL7LEx8y73b9hyfOiTLSt4ukdfBlxqaemoA61ZCHdvjcT8?=
 =?us-ascii?Q?M0zPU7m5od+q13vX0pMQulg+hYiTCFa8NfJem3XWnKlxo/tKvkN0cA9WzKxy?=
 =?us-ascii?Q?K4wneyxMLTsFQlEwREY2Q4Kp/nykqsZeotwTVw5cSyjFFd7HJLjIyI+VRa2x?=
 =?us-ascii?Q?JAHpsLpZPyMjzcsAedhNZqQQpL63+kKeLwbektD3u01AOOOEzKmw0z8j1pH/?=
 =?us-ascii?Q?avv72jcVqxKKCPy+irQNf936SwcEiXma8xlC1bVK+YkvN2Qq+09ePkS8goxt?=
 =?us-ascii?Q?26LzfWVEDX+WQLZq8zmEKhrCApV5LfE/xKx7WQSKTAqdxhbkH9zL3gGSUXNY?=
 =?us-ascii?Q?3zZv9s2Ad9JrWOjjeQ7aHeA6?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79bcf92a-dee7-4c7b-5af9-08d95f893e10
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 01:08:50.8581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u79XuIrkgrUr487mW6dvUKD06DGUgob8bc+KDe8F+dZ496yoRBcWx2WZgSJ9wkNmUUlrP+BPPGr0Yg3mC44uzRnGY2mVnNj3C+PHZ1r6gnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1453
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 03:00:41AM +0300, Vladimir Oltean wrote:
> On Sat, Aug 14, 2021 at 04:41:58PM -0700, Colin Foster wrote:
> > So DSA requires a fixed-link property.
> 
> How did you come to that conclusion? As mentioned twice already, DSA
> registers a phylink for the CPU port, and phylink works with either a
> phy-handle or a fixed-link.
> 
> Support for this has been added more than 2 years ago:
> https://patchwork.ozlabs.org/project/netdev/patch/1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com/
> 
> You have a PHY... so use a phy-handle.

My misunderstanding. I think I saw all the documentation / examples and
understood that to be "it must be this way". I shouldn't have drawn that
conclusion.

> 
> > And that makes sense... who in
> > their right mind would connect switches on a board using an RJ45
> > connection :) Then the only reason any of this is working is because I
> > have eth0 set up as an RJ45 connection, and because of that I need the
> > hack to enable the phy on the switch port 0...
> > 
> > Maybe that's a question:
> > Is my devicetree incorrect for claiming the connection is SGMII when it
> > should be RJ45?
> 
> Your device tree description is absolutely incorrect by all accounts.
> 
> First of all, "is SGMII" does not really preclude "is RJ45", because you
> can have an external PHY connected to your MAC via SGMII, and that
> external PHY would provide RJ45 access. That would be absolutely fine too.
> 
> That would be described as:
> 
> 	port@0 {
> 		phy-mode = "sgmii";
> 		phy-handle = <&external_phy>;
> 	};
> 
> It would be absolutely fine as well to describe the RJ45 port via an
> internal PHY if that's how things are hooked up in your eval board
> (really don't know what PHY you have, sorry):
> 
> 	port@0 {
> 		phy-mode = "internal";
> 		phy-handle = <&internal_phy>;
> 	};
> 
> But in the absence of a phy-handle and the presence of fixed-link, like
> the way you are describing it, you are telling Linux that you have an
> SGMII PHY-less system, where the SGMII lane goes directly towards the
> outside world.
> 

Understood, and thank you for the feedback. I am definitely not
currently running in a PHY-less system on this interface. I also had
some confusion about phy-mode = "internal" vs phy-mode = "sgmii". It
seems like I have ports 1-3 incorrectly confiugred as well - they are
internal to the VSC7512 chip.

> I think it is actually written somewhere in the documentation that
> describing a connection to a PHY using a fixed-link is wrong and
> strongly discouraged.

I have some reading to do. I made assumptions early on and now that
things seem to be getting close, it is becoming clear that those
misunderstandings were leading me down the wrong path.

> 
> > Or is my setup incorrect for using RJ45 and there's no
> > way to configure it that way, so the fact that it functions is an
> > anomaly?
> 
> No, the setup is not incorrect, it is just fine and both DSA and phylink
> support it as long as it is described properly, with the adequate
> phy-handle on the CPU port.

This is very good to know. Thank you. I'm sorry that you're having to
troubleshoot my devicetree, but it is incerdibly helpful to just know
"the devicetree is wrong" instead of "my implementation of the driver
has this shortcoming." I have another round of dev / testing ahead of
me.

Again, a sincere thank you for the feedback. I understand I'm making a
lot of mistakes. I'm hopeful that these mistakes can come off as
"inexperienced" and, frankly, that I'm not annoying everyone.
