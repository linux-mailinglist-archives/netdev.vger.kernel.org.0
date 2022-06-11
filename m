Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B220547641
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiFKPxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 11:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiFKPxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 11:53:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2100.outbound.protection.outlook.com [40.107.243.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43F184;
        Sat, 11 Jun 2022 08:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiI+ma8ksNZGvO5LhydVkyuZ0CgofIwcI2NaYysAjd7fEOdeTRkl/JxQVhcDAQb9cLezAR3cttH1Xbhw6JR3QkPba2gqxIia9hR2DLcvKW+2WRkrkirSKvt6MMRWCEFimXRiqalg+vtDOffuMWBK0NlLULwyrCA3LjQ5Gyid4FFkWX2cuJaR+FJMyOJ52MEZK+kAB91C08KTEgcNYyuLjjz5Mpig6kggq85dsU7mvS2q4XH9nDytxusr3AKmfyPdTZiKVm5H8yHL7A0i6ubBBw+hgdbGqrFEHxRAFzEBP+DMslN/wUusR+3UR/ZJymE8VWIN178XOecpmoB/+R0CUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLHZhUEIzuAYAOI0Ibo95vqLwXIRj3ddyThO4VlhG4c=;
 b=ETtOzfxMB0D0UGMFkC3tWJe5q8uAcLcvi8uxfvJQmbnWRyy3vuITzvwS0hj65ZLAhjCvahLL78cLGgWgP3iGIYUUFB/L8UGrwYAJ1FnO8j6OAhq1qVPmreGLX5E1e0FVoL5JeN5LCM3kag52/Ors4XswiBiD13S099japLxL4cEodu/JpS1wB2S3avnyr8doPd+ICHmYsHAHkdomtDgAczQquDmJpaJqHTfw9shZG8l1wSU5PWiDr+5ssr2C6iUPRm0mfHsLoacjA1hjhfExZb8uWOXl1SDaKjeAdvk36RF8QGUkW8QxmuPRcA7Nxwj7da2rv7TSTvzgz4/ssaQEew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLHZhUEIzuAYAOI0Ibo95vqLwXIRj3ddyThO4VlhG4c=;
 b=NrW5pofmc2vajMuoJdI9HkNMSDXAS2Rr2FNiO52WJpUBb1qeh6S/YUuJu8uwklJaWP1fLlKMGAJucXHkftftytmURUdLAGcLjABdvLnpfzaZxjGuJbiHUK6zIOGkfQe3FV6SBoCoMaAq6iH1FWnPWBdGxTfScJORXYOJZrPX+t0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BY5PR10MB4145.namprd10.prod.outlook.com
 (2603:10b6:a03:208::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Sat, 11 Jun
 2022 15:53:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Sat, 11 Jun 2022
 15:53:43 +0000
Date:   Sat, 11 Jun 2022 08:53:34 -0700
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
Subject: Re: [PATCH v9 net-next 1/7] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220611155334.GA848433@euler>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
 <20220610175655.776153-2-colin.foster@in-advantage.com>
 <CAHp75VfHG7pqvTLcBu=vqx9PzXVrJhxyu6XHr9xaiMmhqke-Tg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfHG7pqvTLcBu=vqx9PzXVrJhxyu6XHr9xaiMmhqke-Tg@mail.gmail.com>
X-ClientProxiedBy: MWHPR19CA0067.namprd19.prod.outlook.com
 (2603:10b6:300:94::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 091398dd-4339-4cb4-94d7-08da4bc28f7a
X-MS-TrafficTypeDiagnostic: BY5PR10MB4145:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4145DF7D4A8C081ADBACC7B0A4A99@BY5PR10MB4145.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vT8T+e1dWhLc9ER9hdnNEMntWyJO0R1LTApZUHwvsMg+29uB4VI8kB3EjJ+lDBmvhFOpYAazIHniCUcQ0HUNVkZYAfmUUHQCengu6O5EWPSHnJAXxsUefAgoujtLr0x2PJ1I3B4oqbdgGJKL60Poh24xTVBax9vMlIW53UxTPSXZFr80EBbYHL8BlD+hxp28wkv7IBPtXLAwfl82IrSEtIwiPFmykxpqQt3QImhK9FbI5F07i/YAbmfuMu/R/EVB5Akh9zhc+nJeo8SPoldXhQl6Yc0cY7ejgNhYeM/q8BCTpgrwR+U3pm4z2PQrx1FzO9wnG3QAGDawonvNSuyWXsuFqEjGRhQ8icB6FQmMQ4TvoNovIH1qW3EFEq3ca/IDY+w8+tCaIYfMEEDcJLm9NAYRLk/pQg5tfSzvmUU+700Usd1sZlQX/8OuBRTYL0+n3SsPlAVVW35G+AkjIPskuvwUEa0EiuK1az+If2qeHKdXMvQI/Tgg/n68tnvhuwwGdqOY+vsGpxWEvatZ8Wox+t46KtSO5nqzyj9v1DCvJ49DQyFpVAfA+4Ct1qS+fW4Kqpfhz3e386/6jOqKLSOunanGcGMyhI7AQ11jqunFFo78SRNtaRtQV/JWWqxI1NmfkcXA6iXY62WLQpd/9Z+oNIJ5uq80PxWEfazrCRkV7UGxR46rzsjNFUHAY9BYkFxHGMT83mGfJfC5CRHPZ0Sl2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(39830400003)(346002)(136003)(1076003)(6666004)(53546011)(52116002)(6506007)(186003)(41300700001)(6512007)(26005)(9686003)(83380400001)(38350700002)(38100700002)(66946007)(33716001)(8936002)(7416002)(44832011)(5660300002)(4326008)(86362001)(8676002)(2906002)(66476007)(33656002)(316002)(66556008)(6486002)(508600001)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0HHFvRVJHmWpDWbEZYSkt+5OHU+d249t8mM2kPMx6UFWAYG6TyhVKpa3XTgq?=
 =?us-ascii?Q?lkxrihRR2p0JxSRHpHCU0eHbMhmk0BkBfeHTVxEfevuXqwcqMPD3cKPqjFec?=
 =?us-ascii?Q?ivIDGua7XcGun5p07i+CfTEF98qfDZHw0vMjdMrhru23fhLp/+bTC9NaN0/i?=
 =?us-ascii?Q?EK1hCV7qSBJhZuimr8Rse5fTkJu69RIRtCT4SyEMNuOtYlaiRP7rBgya/wwa?=
 =?us-ascii?Q?27XH4vg8h6Q1M3zYwZBeCBeIaIZxsvUCq7P0uEWfavqwMtdtWc4wFRQD0iFA?=
 =?us-ascii?Q?DGp8iUs0aFN5gO/JhWcjKE3unv7v4dsPh8yhnDqKBGLWX8/6AhTeV9UewXmZ?=
 =?us-ascii?Q?01TWACmZ/FvALOxhoi/fyp9ZthQFjSy+pY9l8Q+XElk+LmpipqLWgFYabxfE?=
 =?us-ascii?Q?R/Gv+ooHrhpc8zh6lGI/n4x0rtUJoycIggi4uqBCXmczZ2/iwf9IcsUFMftQ?=
 =?us-ascii?Q?cc/d4QoSegmuXgPpjMY4M20JmuT5RqkqSNvPswiTKKuDFfHzP2kuxFrTH9YY?=
 =?us-ascii?Q?SUNbK9lGKSODsdx7bDffcy8s53Tw34U9O6DaztAjN1WGpbchbetnTNC8bqg1?=
 =?us-ascii?Q?4/WRRn6zdnnhYAUYhDEhJ8NDVyIeoofuNU2Y/RKdqQwjj0/1PN4npXHlYk4X?=
 =?us-ascii?Q?vSvRXLgQ+jLcxlwTAYOK8OpnengDP7ho1PPcDUqZ0Pk+ojkTM0EMNewxkAUj?=
 =?us-ascii?Q?/0ue48sXLUiqO8cH6n5aCobIhT33qopEOV4twow48QspUUCaZstbsUQm78Sh?=
 =?us-ascii?Q?385R8d4r5zgxh+mnSrPnTvUWTWlog1tNJhLB30YfO0t5i0UuKn43XN99TYPs?=
 =?us-ascii?Q?5kBByL2kSxtyCny87AhxlMha/24rxTW8+JjwOQsZDeLPFaCWcQ3HkZWS5/+a?=
 =?us-ascii?Q?eOXYV60d174bWQqRzpjevPo7SG61u3Fhzwbk5t+I+E0fSTl9bsLC30PkjXFs?=
 =?us-ascii?Q?Ow2Gekh/ywH1dqVAS3AOl6YkrVQGxIv1DXJ+YteHKcdcH6D+z44DsHZCIXWz?=
 =?us-ascii?Q?CCL4Q8bpfx4FJPIBHZ2p8UpUa2djDl4jsMqyhLy7Kashe6icGti3a2APLCsH?=
 =?us-ascii?Q?YsEJhx7D2o74E91KNKylkmkspZYey5XCRWj6iXMyt/xpajYF0BaK2mkdC9vx?=
 =?us-ascii?Q?yKQBdWtpZBzA6Pq4LY6ZxQX9EnrfxBwzc3pmqWyuwdYxH8plBqz2tbXjKttI?=
 =?us-ascii?Q?dN12jQeEM+criRNnW7DeacfdnZe9TkKDshkfiQ9bMZtsMGrIKy37Lur+aS6h?=
 =?us-ascii?Q?wthAURqwHiJILnLDdhaajiBppdHMAxJ2y8qugnwQT+WKzPJuqL0rnUnH165X?=
 =?us-ascii?Q?J7O4ckVoq7ADv9Ft2YIrLBDhhVzT7rqqW+SmoYWnYUyWU0K0ehKoSKnz6gdo?=
 =?us-ascii?Q?v7mP8qxQpTeQr0i+TBr+qD5MP34sY8vDlSXjR1H79YQm74lfg8o1D5dwAd+T?=
 =?us-ascii?Q?6F7n53ec1300AueW4Ry8eknajNWCGEByW6PIuHgJsCsmFQE9MBPr+XCza9XJ?=
 =?us-ascii?Q?TXw6e0nfYkLJois8G2u0f2Zpjqk1gti5/p22yQHKb+YO9b1pKyKIF/MC18zd?=
 =?us-ascii?Q?qHde+3yEXIpKx0eCWbiYe05yAnfhXg56n4KRlxdflhE0BaeqY+rAu8IkKmI2?=
 =?us-ascii?Q?1tZpqJSQEzdOkeYtP449l77bHDyqnSyTuY2t4k5YOdtJW2VXws18NXwgYDAR?=
 =?us-ascii?Q?XknHLheiSF1haLiYSrNaQYvD44hoY8eiMiMZv/CV7+HGxDp5ebjuIpiAhIMG?=
 =?us-ascii?Q?8SM7kM53JpafpiGVs567eMGJWpCt9NcDEnhcv9YuvypRMe1aPVuL?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091398dd-4339-4cb4-94d7-08da4bc28f7a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 15:53:43.2229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YAba/Eug1VB/8g4kjkT3vinvcBV/4eVnd1VIoLfqNxE+S++09uI/JnqcJ8/Zt9233wnfnh2VxqcOlc97asWnVDLWghTmn27qZtt6v55T8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4145
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 12:26:31PM +0200, Andy Shevchenko wrote:
> On Fri, Jun 10, 2022 at 7:57 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Several ocelot-related modules are designed for MMIO / regmaps. As such,
> > they often use a combination of devm_platform_get_and_ioremap_resource and
> > devm_regmap_init_mmio.
> >
> > Operating in an MFD might be different, in that it could be memory mapped,
> > or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> > instead of IORESOURCE_MEM becomes necessary.
> >
> > When this happens, there's redundant logic that needs to be implemented in
> > every driver. In order to avoid this redundancy, utilize a single function
> > that, if the MFD scenario is enabled, will perform this fallback logic.
> 
> ...
> 
> > +#include <linux/err.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> 
> Since it's header the rule of thumb is to include headers this one is
> a direct user of. Here I see missed
> types.h
> 
> Also missed forward declarations
> 
> struct resource;

Ahh, thank you. Yes, you mentioned this in v8 but I misuderstood what
you were saying. I'll also include types.h.

> 
> ...
> 
> > +       if (!IS_ERR(regs))
> 
> Why not positive conditional?
> 
> > +               *map = devm_regmap_init_mmio(&pdev->dev, regs, config);
> > +       else
> > +               *map = ERR_PTR(ENODEV);
> 
> Missed -.

Fixed. Thanks.

> 
> -- 
> With Best Regards,
> Andy Shevchenko
