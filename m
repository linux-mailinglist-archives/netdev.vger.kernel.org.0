Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7123230A19
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgG1MaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:30:22 -0400
Received: from mail-db8eur05on2092.outbound.protection.outlook.com ([40.107.20.92]:2017
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729127AbgG1MaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 08:30:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5e/mggsL93FI5GvaoUdMvVZbjkE9NnwKqzNH3dXu1Lj3jzrYyAd7DYX/y7sb6qR2Ntvy3kXMhdRILe2ultw8e4pQa8NDHY6oTTl+GgZloc0CNJp6RSLxtlJUeq6BPuIkvV2WT57BhLu0QHj9T8Ua1apG/ex4TV1jRG0rbi5w1ZBwM6a0WZJI9NEJOKvZwSSwvey59rKDRz/Q717/zCt4UUg/VUGuKzupqiWq+4qY+diVRi/6MQ/gfM0xmaBvwtL3AeEKNTSEXXHx3pUBu7kuv7Neaica2QMz8nNf6JceguhVuWOF4yXm4WxEVzMXQgplDqjWBKny+EfQJPqe36ygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyuZ5IGMtyLq0VyrUeXQbHrMZTLH0sBePvfU0aUEqP8=;
 b=IpwVTKvg8H7q3NBtKGULMAAZHVG+7aAEO1QtPNo6XxvRHA91uLXXsQLjNLx5KuJFOrMBhwB5LQ5vXy8KbKvKcLS0yi4ilzaIUSgoF70kZ/ffwNoOU0BD9C0U1eS9zoC4CUV6JGdukzZdh2CvpIYbrPve1RDGcBOEnL3rbj4z76Dqi1Vj4S1a0hTwUDMhnYZ9EtN5Cn/vYw5E/9WAhzudSUcJIrDaHsGCsTSctrriT2pOFwwq7/N8lzylYjLU9oKYEgIN+YiMjoMXCGRTya17kqdt5yK0s/56/4YkbknJMS2alcV5aV+ar/Ej6jaes9NDGRsMNI96MC0rY1RGN0eSRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyuZ5IGMtyLq0VyrUeXQbHrMZTLH0sBePvfU0aUEqP8=;
 b=LFsNdT2A4tlTpCV/F8CXHTgrR3FPkqKi8uCEQnjO0yfvrayeoB6/WdU2g+5F2YmZwnHSBXSSD5dNYyIchr40nP0SUNkDqW9a8lnn5TqGfWg8gDr5bl7QitGEKKkSvuTFZe2oICmFrQglqHTKVBZ8P3kxTwi0q97sm5HRunWDAKQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0541.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2f::31)
 by VI1P190MB0766.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:125::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Tue, 28 Jul
 2020 12:30:15 +0000
Received: from VI1P190MB0541.EURP190.PROD.OUTLOOK.COM
 ([fe80::448f:1adf:ada0:3c0d]) by VI1P190MB0541.EURP190.PROD.OUTLOOK.COM
 ([fe80::448f:1adf:ada0:3c0d%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 12:30:14 +0000
Date:   Tue, 28 Jul 2020 15:30:06 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v4 3/6] net: marvell: prestera: Add basic devlink
 support
Message-ID: <20200728123006.GA10391@plvision.eu>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-4-vadym.kochan@plvision.eu>
 <CAHp75Vcaa0-s6FEUw0YqoEDi=uVRcJiDvwA+ye4cNxwkK6eb+g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vcaa0-s6FEUw0YqoEDi=uVRcJiDvwA+ye4cNxwkK6eb+g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR01CA0046.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::23) To VI1P190MB0541.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR01CA0046.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 12:30:12 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29e701ce-0f15-465c-36de-08d832f1fa71
X-MS-TrafficTypeDiagnostic: VI1P190MB0766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0766A787B5A38E4F1D6A056295730@VI1P190MB0766.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EtruvloviQ/uJxSf5+6OFWW1paY6MS88DR5Q97OHja1szSSOq61xEIiePU6EL3zZfOV7b3lr6OY+rT4Ziv1dJfXJW4nr1dGslG2ennenXNuqpELnjP/UqYk/Z49ZgbJ9JC5twab5XSj163zyw9pGoteauTKyK5iCfYH8dCNktAU133lxGfKg6dYfgRCbssbfBFpNqE9UMWiSq60zS2ljvdGMr+qXu9W4K9hFY4cOoeIUDku3QtJE3gOXfSRKeaPbwIWPkC/oFFRaqNiXJzi/fcPq26cMsWli2lCisej0UkwkpRKWnQ7Y5O/p8T8E72ZUktAZSr7/2p1XnLSPsfe78w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0541.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(396003)(136003)(346002)(39830400003)(33656002)(1076003)(36756003)(26005)(7696005)(5660300002)(508600001)(4326008)(86362001)(8676002)(52116002)(44832011)(53546011)(6916009)(54906003)(8936002)(2906002)(186003)(66476007)(66556008)(6666004)(66946007)(55016002)(8886007)(316002)(16526019)(2616005)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sWDsiZc0BG7EjzaUDNB4vhN3PAy1WuLFxJRvSUKo/g7y/1g2/T2M5di6b7xs/2SAIAG7bQ8P4FXg1YSq6qxctT+Wv2eSBm7ZDjFDVzGzRXtBSHv82xxquR/iOfIa4HdiKgCkliCivpynZ1v0MCwjVvfgwW0zCU37i86YZutSb/ULhrZCkTVyiioKW9jZln5W5LEAGb+YbjFGSupo3X33Zkwg2+GbKNnBMqfBYTniVKReOswNWlSwlnd0cpIyfolcfjgrZwyR7MZi6gekrse2oVujjvZNZrd2hDaTOdgviUTdIPmal2wz1DqSylubnS+Us8gaFmYMT5L5Rgk1vA4X9wcRzOgyzkyT3YCOnpEwxIWuCpjFwwMwT9uHYYtoq++U0LXmI3lNzgPUrHIe92hdR+icqswevRtFGM+0IQF7x/ERJcYUDfA3Msebhty3/UbtIjzLMnCzNPp2hCvdhx+QPbvw8Z5N21Co9cOqcC8Du+s=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e701ce-0f15-465c-36de-08d832f1fa71
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0541.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 12:30:14.6983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9g4OLtKtRH/ib2TcjUZERqA18wfCI4bQEsWLdlUA4oqyCFJbrM8LIqm9St0/K9yudRzsk5cGq4aHTMwWhcfBwhKz+EwuCXQ/SbEcbbUW8Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0766
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Mon, Jul 27, 2020 at 04:07:07PM +0300, Andy Shevchenko wrote:
> On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> >
> > Add very basic support for devlink interface:
> >
> >     - driver name
> >     - fw version
> >     - devlink ports
> 
> ...
> 
> > +static int prestera_dl_info_get(struct devlink *dl,
> > +                               struct devlink_info_req *req,
> > +                               struct netlink_ext_ack *extack)
> > +{
> > +       struct prestera_switch *sw = devlink_priv(dl);
> > +       char buf[16];
> 
> > +       int err = 0;
> 
> Redundant assignment. When you got a comment the rule of thumb is to
> check your entire contribution and address where it's applicable.
> 
> > +       err = devlink_info_driver_name_put(req, PRESTERA_DRV_NAME);
> > +       if (err)
> > +               return err;
> > +
> > +       snprintf(buf, sizeof(buf), "%d.%d.%d",
> > +                sw->dev->fw_rev.maj,
> > +                sw->dev->fw_rev.min,
> > +                sw->dev->fw_rev.sub);
> > +
> 
> > +       err = devlink_info_version_running_put(req,
> > +                                              DEVLINK_INFO_VERSION_GENERIC_FW,
> > +                                              buf);
> > +       if (err)
> > +               return err;
> > +
> > +       return 0;
> 
> return devlink_...
> 
> > +}
> 
> ...
> 
> > +       err = devlink_register(dl, sw->dev->dev);
> > +       if (err) {
> > +               dev_warn(sw->dev->dev, "devlink_register failed: %d\n", err);
> > +               return err;
> > +       }
> > +
> > +       return 0;
> 
>   if (err)
>     dev_warn(...);
> 
>   return err;
Would not it better to have 'return 0' at the end to visually indicate
the success point ?

> 
> -- 
> With Best Regards,
> Andy Shevchenko

Thanks!
