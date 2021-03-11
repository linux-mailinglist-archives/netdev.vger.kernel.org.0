Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A0C337A57
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhCKRDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:03:45 -0500
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:12985
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229578AbhCKRDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 12:03:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJpmd6SO4AIpUL2mSAWDFP+0EhY6XQY2ZUgcwDgMdGY33fCfAnLm0xmsCtONdUZIM8P07ZqIDWb3YKFcXC96Wa1Ph+et/aW7twe8GDeiKFLr9KrcL1Hsb+1DV4XRhP6PoZgiajJUb+I4s4KugCDZJxeVqekZS8+q6spaN6gJh5Y6lqm/aU4hwKiagFnBRVM6dlsTTlxtr4bVnbnWAvm1Bg0tomzY9luI3IJKBxR71OV7PJ3cWPI/oH1EdlY+q3W0EpIX3yMGixNAbpjBjveHNoSHU2V8fvzk0gZI3Z9f4yZRMi9UczMxSYhs0Ho4u1/kJknWo0bHJkqyMOgriFBTxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwckWWMXLKDW/SlY9AZftD75V0CzvGAwGxmuRqAoJiU=;
 b=UcOcPruVQl4w8OaYuRGT/wKfXE/E9vYE0ql9pDqyyzBPDNqAB0012mEkX5xfOKwwqURZgYeUgkTNwOm8y5/fkHD0sfEZMnAGj65OGlJnNuDlnOQhBnwKTYEG/C8rlXXKYRvbkNNSwbHwy0nUuqRESeYhB1CP6PAhTEel56jGbvGQkYJNLzE+j+JxBhamXX0E4pOQct0wmScBxYZqQpVkckbnvtM5O65U1DLmqK5Tj62MQoYMbv8jHgHlBett3O1Z2hDXkb/DGLCKDTDnJFmFwKdPz+y0Us8TC12pkX9PkngLY00OMHnBPwv/CfPcSZhf/BUEUIN0CONTnqbuFSY5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwckWWMXLKDW/SlY9AZftD75V0CzvGAwGxmuRqAoJiU=;
 b=duI4p/NGtpnwmU2ndqirFp7YPRkEvMYxTP5TSBh9Psq4lip6GiJQYXz4iYj1k3mm5UthKCFOVM6GdRWjt44VG1y+rFoinbBdK8rzWcAv6tPj2WEleEeu4WpApz+V+Aa/SZ4OoEMSrwkzLLBtI3JLxnMMj62QfaJFp91nNxeqfDU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7155.eurprd04.prod.outlook.com (2603:10a6:208:194::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 17:03:19 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 17:03:19 +0000
Date:   Thu, 11 Mar 2021 22:33:03 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v7 07/16] net: mii_timestamper: check NULL in
 unregister_mii_timestamper()
Message-ID: <20210311170303.GB5031@lsv03152.swis.in-blr01.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
 <20210311062011.8054-8-calvin.johnson@oss.nxp.com>
 <CAHp75VdMhBf8MsO+QqMOt_u3+BAiYsT2OeG5qOKnhCbZt1ygmQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdMhBf8MsO+QqMOt_u3+BAiYsT2OeG5qOKnhCbZt1ygmQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HK2PR02CA0186.apcprd02.prod.outlook.com
 (2603:1096:201:21::22) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HK2PR02CA0186.apcprd02.prod.outlook.com (2603:1096:201:21::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 17:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81d73b8c-1759-4d74-9a7b-08d8e4af91a8
X-MS-TrafficTypeDiagnostic: AM0PR04MB7155:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71555670162090CD3A526FCDD2909@AM0PR04MB7155.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIuslhsjaH6dk5kD5B/PLHqc0tHSAWjBpSvMZZELJ9XzgBkSm8IppgtGwCa8xcN0o0Iy+hJCodT26iM03n2ixf5d42cEBgoK6s0JngZM2l18oZeclWQWrKoj/gSoZK2XFVyWex03hbb2YNeaYA1e0ejqgVQG/qTt1QpTAQukVsioyvmj5cKTjxFuwLEgu1WDtYC2ZAbQQnh+zLZJaiS13qnpdWQNwSpeR0phXT0SMdKfxYCjx5w47RFr0InYinooa+drGJH60XjnqaHQ2HOF1cd4TEFi23obkMe7/MWr9+XSDKP4W8PO0tix6/wE64EeZcIx4pGGCs0SIC0+o71hafaJvVcxIevqOYYG/8dXxVWgDMyuXYRe3vRJ2yg9jg7wa2XpbSapqNdwv4VtDfrKap622wLtkNYbRArWNfIlGfS8Ugr5u/qmOJUx8hPmXAdlt//MOhlMUNiU2p8svRbEpUXvB3Aac/PG6mmwdb1i+mwPqpP9VfZWZ8TILZEXnZr1UiFXcCSzUgfXxQuAzRcQhwFNw5sB3NVuXYwf4PdYdiAH7IZjrLWTdgDSZoStvKRSK0IrVUOxzmON6WuUrl5dS2Toqv38PTzJGPWism1ewfDJBZ8Tt8L75ejuAXshV2EgWFrzhqAY6p73xTynlCf7Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(66556008)(6506007)(44832011)(8676002)(66946007)(66476007)(52116002)(4326008)(7416002)(966005)(5660300002)(53546011)(478600001)(956004)(9686003)(83380400001)(86362001)(55016002)(2906002)(33656002)(6666004)(6916009)(55236004)(7696005)(1006002)(16526019)(1076003)(54906003)(186003)(26005)(316002)(8936002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rlMnP0LREGDc+MTryhH/uTrHcl3Gw7u8JdS0ojGfQdExspIqayJcxqijuUwy?=
 =?us-ascii?Q?xev/0ROYY+JPeh0eH0WNvgciUbnu94vvzT6XogdpgpS7R4QNtdrpGXh5stHk?=
 =?us-ascii?Q?pdaaI704HZ7IvxFgHwPjQ86D6PCTupQ3/6IdV6Uh3xzUL606jnYwXycyfwDw?=
 =?us-ascii?Q?dBTj0H09jFfPFJEPftI1VlROZQ59voXVRREYoYpVx4s5GGSetm4jUxoAenuR?=
 =?us-ascii?Q?a0GjtSD2eJM5lyDhidNmuCbynwVfUeP7HhtFeq1JAHI1kb/CZvG256UJ8Tog?=
 =?us-ascii?Q?XVI4RBp3n6rntQvNxwiywZ775Cr2aJMK3/2dJgzZIlQaXJApPePuvMzDAliO?=
 =?us-ascii?Q?qMZQJ2OSRFAoyQyK6u4HuGLEXmFt76CQyeKPj4jDwqaaUJYeW9icoBT3I1RI?=
 =?us-ascii?Q?nxGQutah3f9RY/Otwyg8TFirVzNNxO8ySMzt8Q1Hlhte6HRFDDlt1ZpnNdwh?=
 =?us-ascii?Q?uHOYKtFpyhsphZSTZFOM9EmLgJ8LIaoNhpcIRBRZMW98iRGPGApvTf7E/F6y?=
 =?us-ascii?Q?nqROJ7VO2MCTZHK4VeUTn4FrXaJI12GDhEXxzqScI61RyYTO9Ur5MMywBjcO?=
 =?us-ascii?Q?BDHillye/nqdWC2gI38zdGvSCQowIDtkMesDL+KJPgBMtdHk6b7W+9jvl8Q+?=
 =?us-ascii?Q?Lh2Y9z0xpTBs2NWkFO09vh57+5m3mvKtaewnvQSN6wmp3Iu1DRSr+HiZog8p?=
 =?us-ascii?Q?6N+GUjM5p21uyZKwu++XtwrJyzueu/hafVgmUonPut0R/y8CqBQOTyn5vCfY?=
 =?us-ascii?Q?Gi2frIlhqgT33khQqmfN2AHAkRUmyEcunjyWBnh/NT0Uv/yQzrOXK5hxZYg8?=
 =?us-ascii?Q?JVAGH4mzB6NYd9VsHf13phkoi5PvR6e5smMQKmVGz3UJzQU1roSH86N8w5m/?=
 =?us-ascii?Q?8BVJHrrKbcoHeRrWIvyN8xTDmbZFzBLLBWJoxPagG81sYpSghE7dsPnV9JE+?=
 =?us-ascii?Q?wYFM+Azyelfh5D0FRj2rxg/6c2VT3+HLjDvvK5m+uXadk6dAfDXAAXfiKOEs?=
 =?us-ascii?Q?JvSkzfiK76XuX0JJhU8ds9V+Xw3DbrutztAk3e7tIQJd2xbL83Alj5A18B/O?=
 =?us-ascii?Q?IgyqAQinsjIPOg6FtyNDnx7i+kjpK6XVa3kxfnMcAxC0tKndKP690ffpSEVr?=
 =?us-ascii?Q?j8STrizQVxsxLz5zEVbkwk65bOKe5pdwYAtiesRjkprO0dkG81a+CK8dyerk?=
 =?us-ascii?Q?AqEKO21BKpMQ0QrVThseOYtvYmB7HryR/YLdAkhZ5sBzZ5L/M54c2SyPwuzt?=
 =?us-ascii?Q?DvUB/fDQwNMBLk4xj165lU4S+0NJ77eq6E1AQFLRXKSpguE6xi04N7Fvpmw0?=
 =?us-ascii?Q?Jybt5HdTC0Mqrj2LIanwkjBX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d73b8c-1759-4d74-9a7b-08d8e4af91a8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 17:03:19.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XybxUnLozHXYV/55rmgXWM84yHtS8Lwebddo1Bpu2mMUWW85PW6HK1PQMGlfbCc/3aWQmsWadCQDawB6CXeM9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 02:04:48PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2021 at 8:21 AM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> >
> > Callers of unregister_mii_timestamper() currently check for NULL
> > value of mii_ts before calling it.
> >
> > Place the NULL check inside unregister_mii_timestamper() and update
> > the callers accordingly
> 
> FWIW,
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> 
> (Don't remember if it has been suggested by somebody, in that case
> perhaps Suggested-by?)

It is the result of your suggestion[1]. So, I'll keep both Suggested-by and
Reviewed-by with your name.

[1] https://lore.kernel.org/linux-arm-kernel/20210218052654.28995-1-calvin.johnson@oss.nxp.com/T/#m8d209f08f97fe1dc7249a63ad97b39311d14a9b3

Thanks
Calvin

> 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> >
> > Changes in v7:
> > - check NULL in unregister_mii_timestamper()
> >
> > Changes in v6: None
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2: None
> >
> >  drivers/net/mdio/of_mdio.c        | 6 ++----
> >  drivers/net/phy/mii_timestamper.c | 3 +++
> >  drivers/net/phy/phy_device.c      | 3 +--
> >  3 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> > index 612a37970f14..48b6b8458c17 100644
> > --- a/drivers/net/mdio/of_mdio.c
> > +++ b/drivers/net/mdio/of_mdio.c
> > @@ -115,15 +115,13 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
> >         else
> >                 phy = get_phy_device(mdio, addr, is_c45);
> >         if (IS_ERR(phy)) {
> > -               if (mii_ts)
> > -                       unregister_mii_timestamper(mii_ts);
> > +               unregister_mii_timestamper(mii_ts);
> >                 return PTR_ERR(phy);
> >         }
> >
> >         rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
> >         if (rc) {
> > -               if (mii_ts)
> > -                       unregister_mii_timestamper(mii_ts);
> > +               unregister_mii_timestamper(mii_ts);
> >                 phy_device_free(phy);
> >                 return rc;
> >         }
> > diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
> > index b71b7456462d..51ae0593a04f 100644
> > --- a/drivers/net/phy/mii_timestamper.c
> > +++ b/drivers/net/phy/mii_timestamper.c
> > @@ -111,6 +111,9 @@ void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
> >         struct mii_timestamping_desc *desc;
> >         struct list_head *this;
> >
> > +       if (!mii_ts)
> > +               return;
> > +
> >         /* mii_timestamper statically registered by the PHY driver won't use the
> >          * register_mii_timestamper() and thus don't have ->device set. Don't
> >          * try to unregister these.
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index f875efe7b4d1..9c5127405d91 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -928,8 +928,7 @@ EXPORT_SYMBOL(phy_device_register);
> >   */
> >  void phy_device_remove(struct phy_device *phydev)
> >  {
> > -       if (phydev->mii_ts)
> > -               unregister_mii_timestamper(phydev->mii_ts);
> > +       unregister_mii_timestamper(phydev->mii_ts);
> >
> >         device_del(&phydev->mdio.dev);
> >
> > --
> > 2.17.1
> >
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
