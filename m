Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D638D2517C8
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgHYLiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:38:09 -0400
Received: from mail-eopbgr00128.outbound.protection.outlook.com ([40.107.0.128]:13643
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728993AbgHYLgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:36:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrANEibkEnG16aDSP3OfyU2posevf7CwatgnLntKJfuyVQkZlWzuAPwmV96aNxbOJxg/P9jpZRZqxhtUMsffH24UwvPN7FqYv7lX/mDTUXYu7pwNsYw/d1gieYKLsogIQ/qeAmr5aIevTZzocdmN/hdQgD1T/hID4tZxperl51laZB/KfoundkL1lJDlC0OiOM8D6SEHM4ZWXiXpyUpJbiZV0QS/OujVqc7yNIkh/VbjnHUyIV4TFNreBXrsMCSnL8+W3l7uoxWa16S8p0lQRIRO460vkqjQ+IOWp/cx7TfW0VTwOX1hX57eicfL/j7Pv8MtQS/syn2iNJYuHtpDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdU6JtlnamnZT+MiISdP1WnrSUhtNHhbNSwlc0857YA=;
 b=m6mweur3CCp6ic2GJ/oQtV9WkF3ffbFBbDLixoiG0LxlRQp2xun9hZ5n0TuLudQzftgO+qVETXT4tDw79r2doH5WuLNjTk4ShF9XPnt+z1ALUT8JrdEyanOh4gfvf36ahTde2Z3qWHTODmH0xfXmc59+ymfB03PiWnp/nrZwZnGJIUXfW1des/ti652nZfZE7bfF55PouPG8XUDE/i6J7wDdkeguVRFDZHThIW62uI0KDDt89Hu5t7zW5zOFb4hbmydRLhYJdvfyGwjBgRkB881Jr0x5qU/ESpHb2n9bAaA2zDH7DtmTHn3QlZkm8a7FfLdrMM5gctRlV+PPTcx2og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdU6JtlnamnZT+MiISdP1WnrSUhtNHhbNSwlc0857YA=;
 b=ms0Mu7I1wV/vGxWVAulzLjWWc/lmiPs1BsJOoAWByGT5qZuyzH1RfUIB04nUFziuqgCvLkHpNkHCoQD92U6JLxSIAnnmelwLjmC4B8wZloxcju2trnOK5BKJ3aFAd4bZT4hlpBEeT7YrAE+y+wHeZzJqI1I/bndUXzGdBaQr3yY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Tue, 25 Aug 2020 11:36:19 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 11:36:19 +0000
Date:   Tue, 25 Aug 2020 14:36:09 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [EXT] Re: [net-next v4 1/6] net: marvell: prestera: Add driver
 for Prestera family ASIC devices
Message-ID: <20200825113559.GA2688@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li>
 <20200814082054.GD17795@plvision.eu>
 <20200814120536.GA26106@earth.li>
 <20200814122744.GF17795@plvision.eu>
 <20200814131815.GA2238071@lunn.ch>
 <20200820083131.GA28129@plvision.eu>
 <BN6PR18MB1587EB225C6B80BF35A44EBFBA5A0@BN6PR18MB1587.namprd18.prod.outlook.com>
 <20200822163408.GG2347062@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822163408.GG2347062@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0301CA0020.eurprd03.prod.outlook.com
 (2603:10a6:206:14::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0301CA0020.eurprd03.prod.outlook.com (2603:10a6:206:14::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 11:36:17 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f83b0cf6-848d-4cf9-a1f3-08d848eb15b5
X-MS-TrafficTypeDiagnostic: HE1P190MB0026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00266ECEB8A8A81AD83D7B1D95570@HE1P190MB0026.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfSHnPw9jzSdZZzsBg1/QM4JNzn3yz89w4IzONlPgrEnPA+gvm+eOJgTM98/7t8HWPvIE8V2q3IM9QWqXVynY8XDOI4ukytolQbigkJVIL5sSdkC4VsI9epNg06oxDDnKw+dq6sf68jWK5ya7mNAsBheBD53bchKDlJm3Rs/lN677O+MA2UvxDEM8oNtsqxjTtArPhKQsOaXARzZ2BxfCZqD0+Ew1eoMfpruXuC93+/8EpC8eQgcognpnMqKuTEK4V4oOQFFcXh1b88oIBlvQsi6Ps2rFWnpKPp99k3rSqt9U1eZr1HNzhiqQXcRzJgCW415DN/Y/vMc0moJC/IGOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39830400003)(396003)(478600001)(16526019)(5660300002)(316002)(26005)(956004)(6666004)(186003)(2906002)(86362001)(6916009)(54906003)(8676002)(33656002)(55016002)(36756003)(52116002)(8936002)(66476007)(1076003)(66556008)(66946007)(8886007)(4326008)(7696005)(44832011)(2616005)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gobjQd+M+Rczab4LThUw40ugptXAIHi2ECYlfe3E2UsyoHTt6CYc56cVzx/uX3VGGCCqWVjhb4Op7r0GUCcfxt0nxJ62EFYy30mzqIuBwtQVVBq46FwSQS1z7H+dSl3uMrI/XyqbWxQE4IreS58iL/G8geAJgFXfm4Y6xw/agX7s0XlnHAguBrySGZ7dn4TvvSDM0OGsY0rlooOBohUrgLzwek9GLvd3wjUpyHgyRCLfYY7JQjqRB91uGOwgrOEf/RNG5OMHMZhRw85+w9Lnl1eJKSnk/wJ5JkNdnwKN6QD42aRq87Reg6UT6cFYbwWrcLwPIprXOUvN9IzPE+jcuDgbs5GO4NVw0v/GiFQi5WAiqHzbRqQVryIVzimWIgfFK5c+CSJharXQtCHisCrSyy67hfEfo6lGaEFzp9qmVXLJNsPxnBszruGh9Q/9W5yHDy3us6QMhEnNo3rHk+wyRiM5paczb6Jt2MnqbI8q2HxfpE0mB3sc/PxqAbELtTl1bZPCqg275MuZKskYbiobX+KkFKfU0puiCL1qEYm9ofLYcCK/h3ryFGywvRnilnfq0bLxsq0h6HWqobIfkumLnZ1g6E1PCfIVAO7b34nYOQNq931YHxeLqcqn0lZDWHYpffJH4M/ghVPyexkH3062GQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f83b0cf6-848d-4cf9-a1f3-08d848eb15b5
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 11:36:19.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8EbJRLCraFlgW2LvRvKy/cQQVlMQODeGG0LqLwn9g9QySlWjtHG+cY2MBFMlah2UbFrRxZHTOKSQ2XWkfuCvGMr3dmn7aBpXcJfsyJ3plwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Aug 22, 2020 at 06:34:08PM +0200, Andrew Lunn wrote:
> On Thu, Aug 20, 2020 at 10:00:21AM +0000, Mickey Rachamim wrote:
> 
> > > ASIC device specific handling is serviced by the firmware, current
> > > driver's logic does not have PP specific code and relies on the FW
> > > ABI which is PP-generic, and it looks like this how it should work
> > > for boards with other ASICs, of course these boards should follow
> > > the Marvell's Switchdev board design.  >
> >
> > All Marvell Prestera (DX) devices are all based on CPSS SDK. This is one SDK 
> > and one build procedure that enables the Prestera driver to support all devices. 
> > This unified support enables us (and our customers) to have one SW 
> > implementation that will support variety of Prestera devices in same build/real-time 
> > execution. 
> > This approach also lead us with the implementation of the Prestera Switchdev drivers.
> > As having detailed familiarity (20Y) with Marvell Prestera old/current/future devices - 
> > this approach will be kept strictly also on the future.
> 
> So if i understand this correctly, the compatibility is not to
> Prestera, but to the firmware running on the Prestera? You want to
> express a compatibility to the ABI this firmware supports for the
> switchdev driver to use?
> 
> 	  Andrew

This 'compatible' string is just for parsing the DTS node related to
this driver. There is no any relation in this name matching for fw
compatibility but only to describe some properties which might be
applied by the driver.

Regards,
Vadym Kochan
