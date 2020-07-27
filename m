Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF4D22E911
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgG0Jef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:34:35 -0400
Received: from mail-db8eur05on2125.outbound.protection.outlook.com ([40.107.20.125]:3361
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbgG0Jee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:34:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AingQ05x8d/I8bNhweo6A9YUzyydJqKcOHCdSEP33pccMde8YSektVIwDk9r+h3dbVYAPrh8Rd9+LlHcXf9t/t4EqYG6o9TaoDG1DNg0DvML6DCZfHDPVk5T3Q+gh+G0Fbw2lzDyp1UPofz8oxVDGAlgiVoyDNlV4YQeC6Z8KH/PTX07/KeNB9oFXCqa6Rn0LY39+4m0VK042yvB71vQGHW4xVIf5+tvQIKahS2hbZttKjcOpfLHLmy/V3DvrikpziYlwAOewK6JEUBpVhCnjyZOsqyNiKBjqsZOx0ozmUqy/Z2zDCUYB6ruJOBCtvfPl2K50Qti0dksI6rDweFEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CshXgtEjRUyAo9vzB/4KWS5cS1ulpLSDJ2yFESKI9GI=;
 b=iYAXxqLarEkx/6yd3RG5GmOAlzGWRGP2QIExeNO3Tm2UFmS8HwHRKQt4pnDqNjs00SKDyuF5njLh/DPhZpOhNEZ5t83DVZDKjAf6tylC402ughHPqaT3/F+Zm7fWRnm29IjCdqOJ/wUii7S5PehsTeTlhpjACXiAbN+xznwuR2+dDqEc17ht1l2n4jSUCObvzygpbJF+pKosIh4IPCcSRX6WqErTHHR47iW0thyLLx/5jWWM5xCVSrkoOsyn6sqYVaLrnCGLrhu2jpvF71OOEqBdIh6bmNy05YmMknqNPRhMm3fpSy6EviBj0z2W7vv7aRnHK9hbvfe/ZT0YQjBXcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CshXgtEjRUyAo9vzB/4KWS5cS1ulpLSDJ2yFESKI9GI=;
 b=fIGOMfl/1blPEBHMW+sRDMewOTcXbfELiHVk9//YWtrFrmRxrviJYIE/LA71p1B0uVAd0pfQ+6xF/r8vriTl7b+HOTngnOde6j9StABLnom6eZhyv/EzsPKLsi1wHgSHRsBdYnDHWKFzMouKsA1tw0oaOQZHzavjIqcECV0QrpA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0296.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:35::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.22; Mon, 27 Jul 2020 09:34:30 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 09:34:30 +0000
Date:   Mon, 27 Jul 2020 12:34:21 +0300
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
Subject: Re: [net-next v3 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200727093421.GA21360@plvision.eu>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
 <20200725150651.17029-3-vadym.kochan@plvision.eu>
 <CAHp75VeLS+-QkHuee8oPP4TDQoQPGFHSVpzi0e4m3Xhy2K+d1g@mail.gmail.com>
 <20200726225545.GA11300@plvision.eu>
 <CAHp75Vea6eWUqvXAKtu5Qv3Q0Oo=mxD+zf+zogZdcYOFtRe17g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vea6eWUqvXAKtu5Qv3Q0Oo=mxD+zf+zogZdcYOFtRe17g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0602CA0022.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::32) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0602CA0022.eurprd06.prod.outlook.com (2603:10a6:203:a3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Mon, 27 Jul 2020 09:34:28 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b01d0bd-f0e3-4064-e059-08d832104335
X-MS-TrafficTypeDiagnostic: DB6P190MB0296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB0296A97D1B8AAE14FC601D0A95720@DB6P190MB0296.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5w+FnpvsPV3fz9VcMC7+OT4ukQ2jkJMOYVT3dss11mqZg2+4pUQ+epqjVdEyw+3s44ILKkz0ThSrYo3pZPWz5WB6aHJ1qAtZgkdNB2SMwZDo1j/QpZdzUPo0hX9OBaEpjP4tKRCJUukHySV70tOUeiewAV7b+dc3sqLZlGUHsD32NCWB8j8NMfOViu51V9CT397hyU1bh68q7gunbqSZNBuzUTZjmKdgUwTkBfjZKcTVW0j3Ii0va3tV2x7WWGTKwMvZYCGQ75yYCVWJWkOTMcBAjHQMUWgPb/4ndWDyCyANDF6CoVLimzYw4MWrNTKi/EgbI+19w2U0pEzxs5AZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(39830400003)(376002)(346002)(396003)(316002)(1076003)(8676002)(44832011)(508600001)(956004)(2616005)(4326008)(66946007)(8886007)(66476007)(66556008)(2906002)(6666004)(5660300002)(8936002)(6916009)(33656002)(16526019)(36756003)(86362001)(54906003)(186003)(83380400001)(53546011)(55016002)(52116002)(26005)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: URTK5LMYKggRBCE6TKdC0Ibbnx93doRzXKohzDurR2QVda7IHqEFV36WIL+XTtJEYDiwKBjmRoVGQQfcADxrA1MDrq/Nxpb5HFBq9xtZlRrwcYLoEVAOEBvECUxiFfyBFDK24oKueWrnWxJept3n8bsr17NCMsPLq7VU4rkKo4GdHPxhATVNYb+AH+a26icHejIMppbASxRHQcWHYy2+IMxdgkbD+uImevnhi+RbCvSAMzMX5ekWS0FE7Mlg4Oh0vQq3l8Sdy94ystvfy4O50GXHUa1lkXvcf5aLWqPwDyeDDkh8pBHRg1gb7H7scP4ZV6SmTNKVr7J4EPv1rUOk7GCZ7NxFNwXmRAHiGOyX9suGsCxpeP0c4JpfKJ2Tc9GWbOX7bi/954fL39B3y6Cjpq7bSzblT7wFvWtYSUP7ZvEO1Ogsl+cHvTDQjnu6vCXPRzIF7DcoAg0s3K02CF5P3bTXIXK+aTQji6UigNSqpUU=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b01d0bd-f0e3-4064-e059-08d832104335
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 09:34:30.4053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVzzX81KxsyRO5mZklrs45VnKH3G1uhw3GoPj13OapvONPBv6xGcIERoPauA5CSboeOpdld/AbsOC8PBHswhRvaYcC8kdpum6l+j53bfV0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Mon, Jul 27, 2020 at 11:04:56AM +0300, Andy Shevchenko wrote:
> On Mon, Jul 27, 2020 at 1:55 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> > On Sun, Jul 26, 2020 at 01:32:19PM +0300, Andy Shevchenko wrote:
> > > On Sat, Jul 25, 2020 at 6:10 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> 
> ...
> 
> For the non-commented I assume you are agree with. Correct?
> 
Yes

> ...
> 
> > > > +config PRESTERA_PCI
> > > > +       tristate "PCI interface driver for Marvell Prestera Switch ASICs family"
> > > > +       depends on PCI && HAS_IOMEM && PRESTERA
> > >
> > > > +       default m
> > >
> > > Even if I have CONFIG_PRESTERA=y, why as a user I must have this as a module?
> > > If it's a crucial feature, shouldn't it be rather
> > >   default CONFIG_PRESTERA
> > > ?
> >
> > The firmware image should be located on rootfs, and in case the rootfs
> > should be mounted later the pci driver can't pick this up when
> > statically compiled so I left it as 'm' by default.
> 
> We have for a long time to catch firmware blobs from initrd (initramfs).
> default m is very unusual.
> 
For example drivers/net/ethernet/mellanox/mlxsw/pci.c also uses 'm' as
default, but may be in that case the reason is that there are several
bus implementations - i2c, pci.

> ...
> 
> > > > +#define PRESTERA_FW_PATH \
> > > > +       "mrvl/prestera/mvsw_prestera_fw-v" \
> > > > +       __stringify(PRESTERA_SUPP_FW_MAJ_VER) \
> > > > +       "." __stringify(PRESTERA_SUPP_FW_MIN_VER) ".img"
> > >
> > > Wouldn't it be better to see this in the C code?
> >
> > I have no strong opinion on this, but looks like macro is enough for
> > this statically defined versioning.
> 
> The problem is that you have to bounce your editor to C code then to
> macro then to another macro...
> (in case you are looking for the code responsible for that)
> In many drivers I saw either it's one static line (without those
> __stringify(), etc) or done in C code dynamically near to
> request_firmware() call.
> 
> Maybe you may replace __stringify by explicit characters / strings and
> comment how the name was constructed?
> 
> #define FW_NAME "patch/to/it/fileX.Y.img"
> 
I used snprintf, and now it looks simpler.

> ...
> 
> > > > +static void prestera_pci_copy_to(u8 __iomem *dst, u8 *src, size_t len)
> > > > +{
> > > > +       u32 __iomem *dst32 = (u32 __iomem *)dst;
> > > > +       u32 *src32 = (u32 *)src;
> > > > +       int i;
> > > > +
> > > > +       for (i = 0; i < (len / 4); dst32++, src32++, i++)
> > > > +               writel_relaxed(*src32, dst32);
> > > > +}
> > > > +
> > > > +static void prestera_pci_copy_from(u8 *dst, u8 __iomem *src, size_t len)
> > > > +{
> > > > +       u32 __iomem *src32 = (u32 __iomem *)src;
> > > > +       u32 *dst32 = (u32 *)dst;
> > > > +       int i;
> > > > +
> > > > +       for (i = 0; i < (len / 4); dst32++, src32++, i++)
> > > > +               *dst32 = readl_relaxed(src32);
> > > > +}
> > >
> > > NIH of memcpy_fromio() / memcpy_toio() ?
> > >
> > I am not sure if there will be no issue with < 4 bytes transactions over
> > PCI bus. I need to check it.
> 
> I didn't get it. You always do 4 byte chunks, so, supply aligned
> length to memcpy and you will have the same.
> 
> ...
Yes, I converted code to use these helpers.

> 
> > > > +static int prestera_fw_rev_check(struct prestera_fw *fw)
> > > > +{
> > > > +       struct prestera_fw_rev *rev = &fw->dev.fw_rev;
> > > > +       u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
> > > > +       u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
> > > > +
> > >
> > > > +       if (rev->maj == maj_supp && rev->min >= min_supp)
> > > > +               return 0;
> > >
> > > Why not traditional pattern
> > >
> > > if (err) {
> > >  ...
> > > }
> >
> > At least for me it looks simpler when to check which version is
> > correct.
> 
> OK.
> 
> > > ...
> > > return 0;
> > >
> > > ?
> > >
> > > > +       dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
> > > > +               PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
> > > > +
> > > > +       return -EINVAL;
> > > > +}
> 
> ...
> 
> > Thanks Andy for the comments, especially for pcim_ helpers.
> 
> You are welcome!
> 
> -- 
> With Best Regards,
> Andy Shevchenko

Thanks!
