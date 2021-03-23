Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74244345757
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 06:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCWF2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 01:28:16 -0400
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:42183
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229452AbhCWF2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 01:28:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHfrxUX+J3LKylS2bE9jkMrgWwN/HTZqWYpnM6tgFJtBXkrzQUIqWvyuBlo7nvqX+s5TEOQ/Cb/Z8UEjtuJXfTfzMQHCIOX3TXXhedcsjfglxTERuJYjeRFkcZTE6N9jFyQ38WchQH2xk7m5YL3yG+A/DKp3EYF9kJ53F0HAmbIR3HHmcCHkPrW3Jfkd4pDC6nVUG1+1CNX3eh/8QspacoPgo5/tA5fvvRMHCW2R3BMY5vdumeJdexgNNpBY/D3dO8gfSkhEx0/ruus05Ctqf9XbnKJwSk4SfaVlxNyLr+5R45q4V9oBEcJbJ3OzUza6XU3AydQSJoQoO22uYWX9yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47MOGerl3zXcRgDWTl4nKvNKoz4tKGefu/7gHy4zCUg=;
 b=TDEp32s+sDSBvNQM8JMHkGvDtzLdJvY8eNDMI9Bd4BQTezmf9/xNh8OG/FjSKyzpiCmshPiozzLT4rxmiHiIoTzdqPqZaJg3UhAeuqf/0iLW6ga1+7NrTIHDBXcH4TsHHo9j3aff/jCE3zxnNJUFFFnm+Dx3lIYHLARy1J84AUdLP4VYPd+gm4eKYlPTciefblCU6xeyLWRBCOsJCMabAe/9gQGv1rTIdrvapncD4dt1zWdi4X/gISi8+e12JsVTpwllXl3ynKgT2GImU21d2tsgyjX7oZT+nNf0oGFpbZpdBIX17ybNTwiGV+CuD+ZCr4f06S+R/9RlmAg+9HxGEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47MOGerl3zXcRgDWTl4nKvNKoz4tKGefu/7gHy4zCUg=;
 b=DnuegtiXM2mL/8sskCC7JPwgAmuOxhfOkSPbrnIsir5SKF2Gaa47s3dYGZEOskh1Lh/Gvy5UP2Ag0WSex9axqK15RpPAHUiBNv3lecE+fQusKjPbW1ZmRl3UVRZeM7S+YqfNWTV2Mwb4nV4Ka+EyuVX8zRYEytPxhx0j/fZjB6A=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AS8PR04MB8229.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::11)
 by AM5PR0402MB2833.eurprd04.prod.outlook.com (2603:10a6:203:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 05:28:00 +0000
Received: from AS8PR04MB8229.eurprd04.prod.outlook.com
 ([fe80::d3e:5eb7:9d88:c997]) by AS8PR04MB8229.eurprd04.prod.outlook.com
 ([fe80::d3e:5eb7:9d88:c997%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 05:28:00 +0000
Date:   Tue, 23 Mar 2021 10:57:40 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 04/16] of: mdio: Refactor of_phy_find_device()
Message-ID: <20210323052740.GA12040@lsv03152.swis.in-blr01.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-5-calvin.johnson@oss.nxp.com>
 <20210316191719.d7nxgywwhczo7tyg@holly.lan>
 <20210317084433.GA21433@lsv03152.swis.in-blr01.nxp.com>
 <20210319112115.7l46p3mtptxgjvsf@maple.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319112115.7l46p3mtptxgjvsf@maple.lan>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: MAXPR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::33) To AS8PR04MB8229.eurprd04.prod.outlook.com
 (2603:10a6:20b:3b3::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by MAXPR01CA0091.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 05:27:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a507b0b-6bfb-4a29-61f5-08d8edbc6c7f
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2833:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0402MB283344EC8DF5729608C5E98AD2649@AM5PR0402MB2833.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovt9CdNZq+vf3e96QGtev73HJv9/KyiV0GMdeWY8uFDcDVefzgkmt6o8LCcvfpZhWc0AbDp1Hwffe+q70NwlOHajzq8tssendklUmi95BIKYNen5DQ/rbEOXOFDQY8VXTfeHop5yJ4V0ieh7Hk/n9E/7YLIChz1U9/JOnSnJaS3C3MAM0nRA6RbLIPGIBuKhdHfSc8WP87tL9QfEGIj60CpWipRgRfEf7KXX/4SjtuL4+Xp2HEp9l8uTSXQDTJpiXKV3XWN46el1ZnGg9qB4me17dlpGHEjoPsGyYP/t8dnSXWytdVqClSNvwC1ARS4WjktXght7fqJ7Z+64pC6O4rK7F39jLOrJbq8B3z4qCuAa/9afgzRNIAdNqnjeMRbjwAzcxbUo8qp8bDytlIwmOFt4QQptwYaP6d7/JKPRs+knco9zAg/ePcRUi4c4I4EATe45IYhwZiYBZVnH4vDXtfrhpg5R8CY0KM+XH2rNHP1zAkyJBOGFG/OdXcqOegTuHWRATIXDFetTF5/l2B23gUoY1tA5tveZ5s2nR5zhFKQeglLj7QYPnaNGhmSobBGacgOe/k+CqRQV3TMVnkUELa5InzhhqGeK0e6/QMTBC3w09gWuleVK3s9PwJSCSWXf0IQzX4fqid1v7ShZDCYJUtaSkmYLwy6ZFqj7YO86QJkFiksUIsKFNqtAKolsvMwefUK/sDXT4enj94Lu/vrpqtgToH9cY4GZvLe32X9TN0dycKyBVolRP0lWz1fY93gA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8229.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(478600001)(2906002)(5660300002)(26005)(8936002)(1006002)(44832011)(6506007)(54906003)(55016002)(83380400001)(86362001)(4326008)(186003)(6666004)(16526019)(966005)(9686003)(66556008)(66946007)(66476007)(7416002)(6916009)(52116002)(7696005)(55236004)(316002)(1076003)(38100700001)(956004)(33656002)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ir3DowFWPsUzSBt65LIQlFaGDMflOtTOQuzPoVdx8S6GPzXp8cGW//6//auP?=
 =?us-ascii?Q?iwtHoyANtnCShHyhmFHAZU4Pe1mbj25UuJZsIVEdnJanjo8AxZvbI3ir0Dh4?=
 =?us-ascii?Q?MukSaGSlafo/qCEap7TGQWq7Omm5nyeH6PI7sr5XAZXfj9tJcttDg1lscUlX?=
 =?us-ascii?Q?q0C00qzmWhWoo1wOLIyPrjoYyBQjygKD9TDlAoZXE44i2REAQdMoEc9dGb9q?=
 =?us-ascii?Q?sjlENeqE2FE4sCMWHVM3f9yvC9/+nK53g3SORQ/PSfQqeEWaJ4ELnaJndVfH?=
 =?us-ascii?Q?47uYeyQJ1G4MGKzs51hIy9EHuIThtaSWpU2yYD5fmwP5nx2uceUvNwuqvD8W?=
 =?us-ascii?Q?oygRsaeWa6F9+lydT9XF64PiSyNcIvzr+0GnV1aFH5TZ0TK0t1DH+3ENWHvc?=
 =?us-ascii?Q?KAKq0N5nmts8RCTm7l1KCDn2gnLpEsta2HN7tqJ5jqFjbpf9+ETHZqjFeuz4?=
 =?us-ascii?Q?pB8aszdKrEpLeczvDwh1uMfG5tAtsxbW3+LBLcAmkmTTfDf78fmJP9V4h2S0?=
 =?us-ascii?Q?0D0p6Fnh3ld+1weihH0ZDD59rO3FrrNToiK841Qafzu28Zv2YlRcQoZl0mA5?=
 =?us-ascii?Q?LCl+xo12b/lIA/Nfl3MTOBL3V5ZOioEL0t8C74YXkduyOuTO0SKRCq5RWg+5?=
 =?us-ascii?Q?kLil+TAu5pcEUfJlMsWIx5DlHUHXWH8/V64z2DOIYj5VAC7psgF69xrDEpeQ?=
 =?us-ascii?Q?ectHwA+5JIbDu9hja3UJ/skl1JN7AMlp0SsgRPW0ryhMY94UuX/VF2VUuXmk?=
 =?us-ascii?Q?AMXrx0QLuR7Beb37SwCRUFeRCFqfA0SCYzTHAmR7zx45O96O1ZDrUdTskvA7?=
 =?us-ascii?Q?xCiSNmZfniSVYlnZy24OpR/OXNe8yZ/MQngH1BMJys5Dt2ft1yGYqVMSyHrG?=
 =?us-ascii?Q?K3//4K8Al+ow3tTWJ3oZOQN0lNv/jqAzhIllK7CMXNtIf4kMtsrB1/FPN+63?=
 =?us-ascii?Q?ZXeI5dpZ2ROjndNmTCEW73Pv61wKRjvoHUTqVKbN1WFwKXIaDShueS7o6QUX?=
 =?us-ascii?Q?xDqvf4emMiKdrhFvktvAghc13XuGgNGH5ejBYRQgtAOx1Q/Lc2MMtIApuTpZ?=
 =?us-ascii?Q?wZCL5InlRKprY6gpg36UOHS7X7EPDg5wnOWuUn7FR0k1Du2gTJgzZBIPnd9w?=
 =?us-ascii?Q?pA1DqITjKkH2FMPakRYvfx63HPUPb5HwcmEWL4JcyGzR4PAHQ12gDFBVLInF?=
 =?us-ascii?Q?ImeVkRchcMOmHfkE1atzmM25B+5BZX7Lt5iB02dyBr7uWEUA49NpPRhJXP4o?=
 =?us-ascii?Q?JcnCRJBRwU0eiia8iTHzDjPHsNhhYuyA/bufdEqC6O/xvhawrUyM0EWR9g6i?=
 =?us-ascii?Q?//FJu/dYIxxr3jteUaf/Foc3?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a507b0b-6bfb-4a29-61f5-08d8edbc6c7f
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8229.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 05:28:00.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0IqF8FR1UvJGtcyQvFAYkbDJHHzEgB7K7dEXyU1KyquE/bKkXjY12Kg4P0J+z7jzkDgK/tZ0IrVRnz/dA5uow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2833
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 11:21:15AM +0000, Daniel Thompson wrote:
> On Wed, Mar 17, 2021 at 02:15:20PM +0530, Calvin Johnson wrote:
> > Hi Daniel,
> > 
> > On Tue, Mar 16, 2021 at 07:17:19PM +0000, Daniel Thompson wrote:
> > > On Thu, Mar 11, 2021 at 11:49:59AM +0530, Calvin Johnson wrote:
> > > > Refactor of_phy_find_device() to use fwnode_phy_find_device().
> > > > 
> > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > 
> > > This patch series is provoking depmod dependency cycles for me and
> > > it bisected down to this patch (although I think later patches in
> > > the series add further cycles).
> > > 
> > > The problems emerge when running modules_install either directly or
> > > indirectly via packaging rules such as bindeb-pkg.
> > > 
> > > ~~~
> > > make -j16 INSTALL_MOD_PATH=$PWD/modules modules_install
> > > ...
> > >   INSTALL sound/usb/misc/snd-ua101.ko
> > >   INSTALL sound/usb/snd-usb-audio.ko
> > >   INSTALL sound/usb/snd-usbmidi-lib.ko
> > >   INSTALL sound/xen/snd_xen_front.ko
> > >   DEPMOD  5.12.0-rc3-00009-g1fda33bf463d
> > > depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> > > depmod: ERROR: Found 2 modules in dependency cycles!
> > > ~~~
> > > 
> > > Kconfig can be found here:
> > > https://gist.github.com/daniel-thompson/6a7d224f3d3950ffa3f63f979b636474
> > > 
> > > This Kconfig file is for a highly modular kernel derived from the Debian
> > > 5.10 arm64 kernel config. I was not able to reproduce using the defconfig
> > > kernel for arm64.
> > > 
> > Thanks for catching this. I'm able to reproduce the issue and will fix it.
> > 
> > By the way, is there any integration tool/mechanism out there to which I can
> > submit the patch series and build for various possible configs like these?
> 
> Not sure which autotester would be most likely to pick this up.
> 
> This issue is slightly unusual because it broke the install rather then
> the build... and lots of people (including me) primarily run build
> tests ;-) .
> 
> Anyhow, I guess the best way to pick up module problems like this is
> going to be an `allmodconfig` build followed up with `rm -rf modtest;
> make modules_install INSTALL_MOD_PATH=$PWD/modtest`.

Thanks Daniel for the info.

To resolve this issue, I need to add more fwnode MDIO functions.
I'm working on these. Meanwhile, will separately send out two patches
that got Reviewed-by tag.

Regards
Calvin
