Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F5754768F
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 18:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiFKQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 12:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiFKQp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 12:45:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2108.outbound.protection.outlook.com [40.107.236.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A07C36B63;
        Sat, 11 Jun 2022 09:45:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQ/+QkBgjJDjtMCs738cpd5+zO3mwLcwIgq+OoSABasBuEmvdC2I/0AQ+9UVQKcIzHHgE4yl+l1Y15Hkta969KnXiGpn7hCnRxuzigpu0Ow6C5o+RAlmbENb0OKon1QNrNI2Lr0BFxvN5RqiqFUmWudmg7jZYl5pJ2zw+JzGlBwT3TjtyYAK4cwJAbhvilKqJSMl023I7hrJDRmuo9BgrLL/pbmQ6hZU1PFUkNE9f0RFCXTZjXl82CjQ4PSHG3uEusV+Ky/5k24zjQYslY2btJtW4+2hjbizZivbwwpX0rvfI8ocyB5dIeD8g+Jj048Fz03HDZlJGaf00BAe8JX+uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n88ziDngUp9AKvP4jV9QpCPJ0Z0kM0VtXHiFwC/ZGJY=;
 b=TM/QDmLoIm61mwLjKBJlMQQMROu9PkJO+sM6+vsqA9h+uYxU/xzq3aWzBkUhWeyr/CyI+1Lg2tegwFYUUMDFQ/ue5kvLzE262oeNYRk51PbZ4U0RzGK1RGrxQbDnsiv4PYJAwcveLBfnB38xyGFSf0MKGqO8yoUkI3oy91hTmda/FOufq8HUWHXvuHO4tExFBxqdRmXs15ipwm/MMuLbS0lSXUNoCy1uehxnHGOVPywyZ8ffw2DYLc6W7CmBh7rLc6mvoCLcZ6xN4tHEJzdsT2WBlWOPfLqGr+a+MGDuumeyrqyLmwpx91pOOX+IUQECyIp2v53PpcoDL79YPmPQkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n88ziDngUp9AKvP4jV9QpCPJ0Z0kM0VtXHiFwC/ZGJY=;
 b=abpWCDjAgEg4pgt7h5UQxCqVq5UC+50BxAzYniJ93pA+eOVRIWKjt3xAQVCeLefI7LD/3Z0WdAr4UWBPx3vT9Gv1xztUaB790dnpMu/3aIxky23Y8Csk1+xfkShYRzoZvvGZLCfsSHQgqH5DMKnEGHpuHCmd1S7+saxiwdzBqwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 DM6PR10MB2922.namprd10.prod.outlook.com (20.177.219.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Sat, 11 Jun 2022 16:45:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Sat, 11 Jun 2022
 16:45:23 +0000
Date:   Sat, 11 Jun 2022 09:45:20 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>
Subject: Re: [PATCH v9 net-next 2/7] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
Message-ID: <20220611164520.GB848433@euler>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
 <20220610175655.776153-3-colin.foster@in-advantage.com>
 <CAHp75Vd0ZhP3TcpH2LGsb7=6Bqe1hoNU5i6DRyovKm7Vnz=HCw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vd0ZhP3TcpH2LGsb7=6Bqe1hoNU5i6DRyovKm7Vnz=HCw@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0213.namprd04.prod.outlook.com
 (2603:10b6:303:87::8) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4d18d3b-8b56-440c-2509-08da4bc9c766
X-MS-TrafficTypeDiagnostic: DM6PR10MB2922:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2922919B75DFB1FB305938B4A4A99@DM6PR10MB2922.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pQjpYWTG3ZTQNtinLSlFmP5JDZqYN3X5UZejnnId9XAhymXbxza1ao4XL3V24qW41oB/CQ4Gx4cg4ibg98BpSIDKhqLRX/w4lwn2NkE5rLlVvGlqULwRpHMR+E//cIuRNMhwnK55UGqMpWruD0HR9pxnAzqCX3dJRw7ZhAoM7SNU4SA4vbxdFO/TzY1/tzbt0J3PGpqwfpC+8x1NoFEBm1LczbZRrDVxpV/do4VYzob5q2NUk/TRuOssCOGyKsDDZiqk3VOzUSXTMOetNwiFpEsl4C/7DL67zqNm/YzYEEjValkMJMr30RbNeHK01IDTFRlx8YlbaFIP9QuEj/UEmDCn1xUvAPBtsQvDYIoI7l6sDdO0B9tEVZC07LxfBFpHA1kB6/YK3EQ6WnsY9vLUlpYocrw/M027iU77vk2cpeF7SNXnS5oHDVpJZFhEdWCgX7eyQHvzev3mpCPgO6ZjqR+HUSwbxuGQZrvpjckyZvkDrL/5ztABLIjj4XNefBk1hv+lOSILAkVAS2t4GcAeN695nI0R8M2yLW2HJGSsCxAKX9VT1gBU3Q7nNRuzVuGmMl9LdMVdpwnYyFyjPLuKYVynjRggrIkVFB4lEBO2fdEO6b2V6WE9HfyGS+blj9BfVxz7zv4GLJlgQbzCiXZQcHonpHtBxIPRqbvTHCdfm5nPaUE5XGEICryA1Kz0pF1GhWxvgaNMbmVW4d1wJij84A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(396003)(366004)(136003)(346002)(1076003)(186003)(53546011)(52116002)(6506007)(41300700001)(6512007)(26005)(9686003)(83380400001)(38350700002)(38100700002)(5660300002)(8936002)(7416002)(44832011)(8676002)(4326008)(86362001)(33716001)(2906002)(66476007)(33656002)(316002)(508600001)(6486002)(66556008)(6916009)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UUCqs/8RDwQpfCEKc83PjcX2DSdC8d+PxrPxZSS5FdvL+JqDZdRcsZBVs815?=
 =?us-ascii?Q?JyKLAZ/todWwmOTo+GqLEIffFptATklOafFuDPxdtbZN360qdIwCILeumJSW?=
 =?us-ascii?Q?SNwFCtyeub4PFwGARjQEyQxUKp4ls7F2qJjXvL03AFF5s0bGYAbsKMgex8db?=
 =?us-ascii?Q?VbgKgXVT2VoZkcPu9m+i3+eY7jJMZP6J6z/DZYIjiMKwRrXMyJLFC1d4/ndF?=
 =?us-ascii?Q?Q8KlFhybaxPI8yw2PqxipH0KNcseuS2C0kNDelk+etRGssmcO+RNsfbPZqMC?=
 =?us-ascii?Q?QdkqAZHTPCeNsxKpjxyW94XkfsEo/kt4HjS9asvbrsTSB23fgJOkgaLpgUW/?=
 =?us-ascii?Q?KHvfrTZR8rR9yVY/K4w1wTKvYAdoGuuZyBvsLedTvxx8w27BKTcXzH94qgSW?=
 =?us-ascii?Q?3CS+m9LB3kDMkPPOhHlfkLEguC8yWXoS3SFiLqbGiVYM7HsEwV98pqYU5gjM?=
 =?us-ascii?Q?9Pz0kzhpTYdWhTGC3DTEckPtM9GIThS9k9F/mcJg2zp2Nj0/51ptGqdhjejE?=
 =?us-ascii?Q?FtLJHKSCk8z3OhAepj/ui7QPI/FS+Kp4rZigGaaVm9ezgicA1a/BZ7xQH8lH?=
 =?us-ascii?Q?uzawEnkEK5kSVC1jDCvj4ALGSnxlpe/yt+yKIF/R8jUOo8KSY/+igKWb27mj?=
 =?us-ascii?Q?AIHMiWKnGUVe7AVtPXEyrUfxnqpuJAPUxbnN8vVlH5SUUXOXKeLZfXj96cQ1?=
 =?us-ascii?Q?gg+SgE7PMSQYp6uMW/9NPz3Qo725RLaAxZhDaejTzwXOxI6cMv4EhIq3US0V?=
 =?us-ascii?Q?ssa83ZRnnEtcIbyQDG2XPQOUlQghVSZQoMiBbz043fE46HopfhI6P+Rb95jZ?=
 =?us-ascii?Q?DA5mFRP0YeMr8QsGOTgHa6KxBSnDi94iImANBZFj5K9l1kGKLvt+ykjni8CZ?=
 =?us-ascii?Q?lSI9MobxKFLrLUsa+dQnLOTLHZuWakt53CCYC6XZQmnBurtveBboXczySCym?=
 =?us-ascii?Q?cY4efCjrD7Ksr5SQzScp+ykqgESdGdYIHYmBhA5q9gY14hlzsRsNqdPCssep?=
 =?us-ascii?Q?2oVWk5zWn1FDKcDkJi8YodjxIW40Tk8VKYmNi5ydJ4ykbtmpm8ToNofb0w0n?=
 =?us-ascii?Q?FXs6zjhO8/ow/4oNk3DuZZKAJv+GnuVyeVN8Mf2opmcCXHi3++GRhPp83SFD?=
 =?us-ascii?Q?ZCHDGtHguGnxoQVONMtXD9+RzRqBpRzgcqEtFdizw4oNOh7vupK1QnnSuLhc?=
 =?us-ascii?Q?J7EkCEkt3PvjBNIzzNsw5gXPll1/vauF8CNmuIOAs+UoPwPvuyokLV7eWHt7?=
 =?us-ascii?Q?VaY9/pxxJGEuNk+2J8cZacyTyA0nKkmeXxsY09vLWEa3OCgJuAdVgRjLAYKq?=
 =?us-ascii?Q?FS199rk9xvOzj38jYNeSRMzdskDjCDQAgPv9Z9Q1muNOk2gee97VY6Ba623u?=
 =?us-ascii?Q?X2fmCmhq8IzgHXUYJQWfQ0wnxzTYg5TZiGWfPKv8unGbHWBxlrbcX/aEiPa1?=
 =?us-ascii?Q?a6vRNVw7fv4N7uMORS3TwuS0mVf7FK2aDceS71qO8GFslvUBuSbjKAdipuqK?=
 =?us-ascii?Q?uM1BBHVvb/UEKoY4Ef8gqaz7z3wqMNGavDuKmrVZfgTRZMe9MseQZstRVrv9?=
 =?us-ascii?Q?4YLly63foeEvqG4reAqET0N+chzd/DMReD/7wIzr7ddoNRpXpnWvz5p5De5M?=
 =?us-ascii?Q?1XhYUPzogdSYqIl5SY63MJtL57x1xBaf6VEet8WdixzdDbVmSniZzhsf4rSl?=
 =?us-ascii?Q?Tp2JULXWrOBB6bxEy8DSHDxn/KrvTYqIsJDQ0fCeJczN65SLJHj+f36m5/n9?=
 =?us-ascii?Q?v5aefxHk7d9gvwV6gT7AFNP6qHfyMi4q7aSVodI24QSxAcxpWBiu?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d18d3b-8b56-440c-2509-08da4bc9c766
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 16:45:23.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEt5olGnPZ6XmuHLrGSLaKkqornuaCbsOhirIcvnNCMMVJ08saxASPi3BwZRIyWokD+6t1v2BtmPrM46Y82VBmuMLazWYzjJjAgF+SUarhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2922
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Sat, Jun 11, 2022 at 12:34:59PM +0200, Andy Shevchenko wrote:
> On Fri, Jun 10, 2022 at 7:57 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > There are a few Ocelot chips that contain the logic for this bus, but are
> > controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> > the externally controlled configurations these registers are not
> > memory-mapped.
> >
> > Add support for these non-memory-mapped configurations.
> 
> ...
> 
> > +       ocelot_platform_init_regmap_from_resource(pdev, 0, &mii_regmap, NULL,
> > +                                                 &mscc_miim_regmap_config);
> 
> This is a bit non-standard, why not to follow the previously used API
> design, i.e.
> 
> mii_regmap.map = ...
> 
> ?

I see your point. It looks like there's no reason to pass in &mii_regmap
and it can just be returned.

> 
> ...
> 
> > +       ocelot_platform_init_regmap_from_resource(pdev, 1, &phy_regmap, &res,
> > +                                                 &mscc_miim_phy_regmap_config);
> 
> Ditto.
> 
> Also here is the question how '_from_'  is aligned with '&res'. If
> it's _from_ a resource then the resource is already a pointer.

Yes, this is probably worth a second look. During v8 you noted that I
was repeating a lot of the same logic across several files, so I created
ocelot_platform_init_regmap_from_resource.

The "gotcha" is while most of those scenarios have a required resource,
the phy_regmap is optional - so a scenario where the resource doesn't
exist could be considered valid.

Would it make sense to make the init_regmap_from_resource function
return ERR_PTR(-ENOENT) if regs doesn't exist? That would clean up the
API quite a bit:

phy_regmap = ocelot_platform_init_regmap_from_resource(pdev, 1,
                                                       &map_config);
if (IS_ERR(phy_regmap) && phy_regmap != -ENOENT) {
        dev_err(); ...
}

It looks like none of the two functions that would get returned
otherwise (devm_regmap_init or devm_regmap_init_mmio) would return that
value...

> 
> ...
> 
> >         if (res) {
> > -               phy_regs = devm_ioremap_resource(dev, res);
> > -               if (IS_ERR(phy_regs)) {
> > -                       dev_err(dev, "Unable to map internal phy registers\n");
> > -                       return PTR_ERR(phy_regs);
> > -               }
> > -
> > -               phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
> > -                                                  &mscc_miim_phy_regmap_config);
> >                 if (IS_ERR(phy_regmap)) {
> >                         dev_err(dev, "Unable to create phy register regmap\n");
> >                         return PTR_ERR(phy_regmap);
> >                 }
> 
> This looks weird. You check an error here instead of the API you
> called. It's a weird design, the rationale of which is doubtful and
> has to be at least explained.

I agree. With the changes I'm suggesting above this block of code would
become:

if (IS_ERR(phy_regmap)) {
        if (phy_regmap == -ENOENT) {
                phy_regmap = NULL;
        } else {
                dev_err(dev, "...");
                return PTR_ERR(phy_regmap);
        }
}

That seems easier to follow than the if(res) block...


Thanks for the feedback!

> 
> > +       } else {
> > +               phy_regmap = NULL;
> >         }
> 
> --
> With Best Regards,
> Andy Shevchenko
