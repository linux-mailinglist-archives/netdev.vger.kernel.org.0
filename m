Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDCB5220D6
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347152AbiEJQR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243193AbiEJQR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:17:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2102.outbound.protection.outlook.com [40.107.244.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D51AD11A;
        Tue, 10 May 2022 09:13:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNZzJt/wjTayK8BZ7Dn/a2EgLjUT9PK5Z6jZL9eA5oQGdINcopxVnBfYY4TvWKN8kVGE30VlFcfTJoTkR6IJwRpa8648KhGS8zLhFu2NIXkNlvEWCp2BwcgTaQZpZJHj9KkQf3nMkwbckbDDJCx+1w06tQ7sX/mJKMQVQ6Wyn+YfQFMtVWT5n9lJGEj9iDYTaV7+8T0JJHx5UQHJF1NnKcD7Vjaj9kYdX8xUcZgU+X0slhwTZ0gQGHkwlRDKqlDsTldTtbO+85V7BO4MroYlwcEkvCgCcqZXIqMAQCdP7ZAey5x9ygVSx266J/N9yIMxVy/i8qYb4Ge+R22DNiZmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XI1BiCG8RzAfhfxSni7TCvrzJ0msCojx0Drb18Ek6Rs=;
 b=UABHRyYMH0q5QNpG98ufd8y3AjCHJL8iutJGi7t9dzSuTr0ooXUtDnq9g1pr/QeC+jWof+jiUJvSOA8t2CsQ9CPMLC55zgrXXHV884+56S7FDPI/BRkCtbtSzx4HbwIsLmRfvQTg0Lt8Ah25CLxl7/7u3Zwgy9hUjQMS9C5uSrpnxJUsFQGl+WYwux8E8WBbJlmhiwbS4nUfS+BI6+K2dTESgIhUfoCcf68/iDdOb+y+YshYv2bkT7bFULv4lO0kZ1rZ9d2P1zVj94qRtjEfdHnfonoo7aXavpCpuQhmAgZtqFuD21Jfqhv+JPzYTikXRhnT/DqBt6bEptaKLeLqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XI1BiCG8RzAfhfxSni7TCvrzJ0msCojx0Drb18Ek6Rs=;
 b=SWaFOpumaezmHLTPd40IpKUKMch7tcQfAnsBEVfwdYJS/f/mRfWya48jzhEhyk0kvYyogrf6Mm+2szEgUk0SjX0NU4X+Py0cuvnMP+eL3Im0p+2pV9nkMghrykhogWP4AtKRZcvR9e5+RM9v40qH3WmlRT6rdTqQwAsH778YWHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1574.namprd10.prod.outlook.com
 (2603:10b6:903:2f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 16:13:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Tue, 10 May 2022
 16:13:23 +0000
Date:   Tue, 10 May 2022 09:13:19 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <20220510161319.GA872@COLIN-DESKTOP1.localdomain>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
 <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
 <20220509172028.qcxzexnabovrdatq@skbuf>
 <YnqFijExn8Nn+xhs@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YnqFijExn8Nn+xhs@google.com>
X-ClientProxiedBy: MW4PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:303:8d::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fb0d4a4-d03e-47da-a6fd-08da32a001eb
X-MS-TrafficTypeDiagnostic: CY4PR10MB1574:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1574FC78198AF240AF62E7A9A4C99@CY4PR10MB1574.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKctzsu/rB06qetNkYWe2n0QTaL765Ti+oCl+2o4QFFF2/jFQkLbaS9oH52+3XWVIqavtIgHv+zCosCvLUe5rP4+G6mjgsafj4T+atNrAEekiGzyX1UFHqh/E+p66FgaJHsdZywH0JHyNuMssv8/LK98uyPcBLlpsBUhux2OZIecMQ3rQ8wtrWYF9lpnT46rsUVwR/ZP8NR4rDwxgnIMxI2t+at1KXXz7dasW7B3gJBx54hYdR9FhYYGXJvstlhKodyyuSQyEV44IF93PVYmo1j+NT3XA+RkvBgiMOYOzjEUaT2w1LM71If4kLzE8RPEenexXlMYM52xR9J1JPatMOKC431CfdL5fCfeXXMHFg7eWmv9PnkahlGpsHxDiqpQYgIf0gAMUYE+kUcO5pe59+jlAjLPBQxIdJuMK7ZAyqdfVyszpVsn5EaRCAm2u36LvhvxgRTPG+AZ/c1ns0fgA6RECdjyfAPYcWLK3T7inzBFBSjkysAN97jw2307ZW6Nn1VFm1zPN0TwkxJpNim2yxKesxauUQo5guaiGuHjTWZBiaXuAE1saOEyDHHaPRuWTu64G42MIOw7yThQSnMfbczuPbD6CqR2MXxhM4C/nA2fzI+TVV0HANlaKzJledgKMkL/R5WXn0PrpV90/BpGiAFIuU6QSHIHgnKDzt9H49Nrr0DQ2XHuJKAqRgbrmoNrU3tSnL8UZieUeJe5s+y9lw+oyeh96r+O7fzdhHmQqL3kz2cBbeVP3skCko9mIX2KSJgZLvBoVWlBrwXVlUQE9De0s93WJ80hrWoIso8ZkNE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(366004)(346002)(376002)(136003)(396003)(316002)(83380400001)(33656002)(1076003)(186003)(66556008)(66476007)(4326008)(8676002)(66946007)(6512007)(26005)(38100700002)(38350700002)(8936002)(6486002)(2906002)(9686003)(52116002)(5660300002)(86362001)(44832011)(6916009)(6506007)(54906003)(966005)(6666004)(508600001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFlsekRIeStFbFYvNUoyeEFsSWRPYlJkUUhBQWtGRkIzYzlra0lsaUdkOWc2?=
 =?utf-8?B?cUZKcXc3ZTBoeEhtQVNJcnllckJUZlhWT1VVVldqS0RFWnN2T2JRamtLOGdy?=
 =?utf-8?B?UlZBTFl6bUh0c3NnU3JNOTlJTE9lck5RQ1Y4NGFZeWZuczl4MW8vaHVsNWpu?=
 =?utf-8?B?KzZNcXVReGFGaWtleDRwN2U4VGdjTVQraEpwQWdWQnpyc3Y0eVZCbzJEUjN5?=
 =?utf-8?B?dGpFVXdiS3RVL1Azby8rQmhBR0MyaUtvYWgyK2dRZ2VXZUwyS3h6WnhsUG5a?=
 =?utf-8?B?Nk5BTVNSdlNJc3l4Umc2Z05hMUowVzZ5MWx1Qnp0UmpjaDFFaEh1ZFIwUVlT?=
 =?utf-8?B?VUk5WTNjb2lkUkFHRjhDV0VyelgvMHRoUWNGbWVpdmVXMGxuc0U5VnI2UlE4?=
 =?utf-8?B?U0xXK0tWNmd0ZER1TjYvNHd4RWVPVlBXa202MGFQRERIdFNuZEE1NCtYT2dH?=
 =?utf-8?B?QlNmeEtMckdFSTlER1p3R2E3dFNHeDN4TVFCbENHTE43Y3k3ZGFKV0Flb2Fs?=
 =?utf-8?B?NzQ0TVBJeksyaEJoYXZpZEFlNVBROXdEa0VtOVZaTDgrSkMyUC9pUEJHVzk2?=
 =?utf-8?B?amh2TEVlSVVORHBFZGVBS21SOTVxaXYvdFhUdTUyWklQMjRuMjBpV0IrcnY4?=
 =?utf-8?B?a3hHQ2NTUzNMWDc1SzB5TUJwSGQ3UFlIQzVmbEVnU2Nscm1Sa3cyUVg1ZGFJ?=
 =?utf-8?B?Wit6UXN0MUFPcVhMTnhuS2ZDODFSa1E5L2tBS240SUp5SUJLcW13WkF2RjNq?=
 =?utf-8?B?NGVUVldKS1pZMktFcE8wVjQ1dHVMTVB3MVNMcmd6UGp2ekF5RXh6eWYxNzJD?=
 =?utf-8?B?RGZWdmtzcERGbCtlUFcrSitibENhRWQyOW93WnNVNUNvUm9UeVk1Y2FQa0Uy?=
 =?utf-8?B?YWdGZjlBYWNobWZrQ1N2ZVgvNmVMaVJ6K1pwWkJ0dDNPVHFab3RYaUozdFZ3?=
 =?utf-8?B?M1N0RCs5T25nSHVDNmthcXlvUzVjYndtYUVXRnJocFFZWW9DUkF2NEc0ZWxp?=
 =?utf-8?B?eGJ3aVd6NFlHZlQrQTRFdUQzbU00Q0ZZR012MHVxelVNOXo1Z0RjSG5jQ2tn?=
 =?utf-8?B?dHV0bS9YZ1ZSUmFod2J0SjBhMjZSVnFrV2FhS2xTL0FGdllISmJjNEZ4TVp5?=
 =?utf-8?B?RzhSWVdtWHRGOXUzb1ZaQ0ZoZkZNSWRiem1kT21tY1o0SkozYmpBT1Q4SHdv?=
 =?utf-8?B?eHBHNkE3YTJlZlk4UHZYS3JMTWR2M3RHKzg4UnZRdU53WGxLMlVhYm5VelIr?=
 =?utf-8?B?TGVqZTk1dkZJdnRxdGhEQ2xabDZuNDEyNkV5NDcyNDdmZFNISXdOVEViZjl2?=
 =?utf-8?B?SWl6U1hlOW5xSDR2K0VvelFYbnRRVlErMDZhTkZMbUhlVlJpelQ3bGdNczBB?=
 =?utf-8?B?T2YxWDdSOTFnSkpiVFdDZEsrRWpNZDFWWlpqaTJEbGg3REsvMzR5Q1dLaTlw?=
 =?utf-8?B?SzZSUEp0b1pKMmdHbkdnaWY3RnZEb0pTTVd2eHdaWmVnd2hWZUVvandQTlZz?=
 =?utf-8?B?ZlRPZFM3dXNPYWpiUGZaWjJOTXFwbkpOK0VEN016WTNsM3hsMTR3ZDMyRmRK?=
 =?utf-8?B?aUo5ZXREVkd4a1M2bUxZaWtneEZ6UGp2M1AyaHBGQk5SaVphV2RHcWJRd1dj?=
 =?utf-8?B?NSsya05KVi92UVMzZEJCTE5tdjRSSHBnd2VwN2hSckpxMVpTcUVnekVLNGNK?=
 =?utf-8?B?aGZUbTQ2dEV4M3BCMERLMC96bno4NURRRVdaeUNVYzRKUnlqWXI4YjNxU1A0?=
 =?utf-8?B?OFNSSmd2YlltTytwM0hxMlR3N3BUOGFoQUtueGhwRFJ6MkFiRGpyZ0JXeWpm?=
 =?utf-8?B?MmI3Z1ZNWHlYMFF6N2FrT2R3aEdZNnh5VWJFbCtYSkZsQ24yT2xSczBhcSsv?=
 =?utf-8?B?UzdNRVppYXBPNjdUZHpHenE1YmZyZEdCMVFMMkVoU3hZSnZMV2xveE9pK1h0?=
 =?utf-8?B?VVdGYXppNUE3MWtiSlowQitVcC9LdDlLMGhRV0ROMXhsQTllODFUTktvZC9I?=
 =?utf-8?B?cFlzZ3lNdXIrT25POU9ydldyWkxFMnprL2kwT2RLYWFoN2JlV1pBQndpdkpJ?=
 =?utf-8?B?Z3NNYXdDYW5FTGswM2l5YWpPc1Rya2lyeVg5bmQ0UzJWcElFcEc5aVh0VUpw?=
 =?utf-8?B?SnJrSTJxKysveFptcWEraFBMUkUvUFdYMTdxTDRrS1FlRkxZRXgvOFQzOEF3?=
 =?utf-8?B?MU1tV2dCQnBmbUJ1Vm1YYUsrZTNjUzQ4aStiS1YvNEkwcEhodGZNd1I2RE11?=
 =?utf-8?B?SzNxd2s4eHhSQTRONWVWcDdKQlhPanNhNnE0Q2E4Y240TGZYaGE3Z3Erb3kz?=
 =?utf-8?B?ZkdzM1FyaFNsTlc4SmpNNDRKTThhSVlvZ29vVGJEbU5FaXV5ZUZIcjR1Q3Yy?=
 =?utf-8?Q?P1TsmFvksbQToS14LcwuZ3kajFE55KxwLzN9M?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb0d4a4-d03e-47da-a6fd-08da32a001eb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:13:23.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lzj/7kD52MSTob3AJwtNq2jV5X9RYaoUcqOS03eWZwjNpifhnCa2GlB6eV7F/wUhdoZprUJh5CQ4IYrOtuGuu/FgxVE2Z6UX6zYT96qmYAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1574
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 04:32:26PM +0100, Lee Jones wrote:
> On Mon, 09 May 2022, Vladimir Oltean wrote:
> 
> > On Mon, May 09, 2022 at 04:49:22PM -0700, Colin Foster wrote:
> > > > > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > > > > +						const struct resource *res)
> > > > > +{
> > > > > +	struct device *dev = child->parent;
> > > > > +
> > > > > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> > > > 
> > > > So much for being bus-agnostic :-/
> > > > Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
> > > > via a function pointer which is populated by ocelot-spi.c? If you do
> > > > that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.
> > > 
> > > That was my initial design. "core" was calling into "spi" exclusively
> > > via function pointers.
> > > 
> > > The request was "Please find a clearer way to do this without function
> > > pointers"
> > > 
> > > https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/
> > 
> > Yeah, I'm not sure what Lee was looking for, either. In any case I agree
> > with the comment that you aren't configuring a bus. In this context it
> > seems more appropriate to call this function pointer "init_regmap", with
> > different implementations per transport.
> 
> FWIW, I'm still against using function pointers for this.
> 
> What about making ocelot_init_regmap_from_resource() an inline
> function and pushing it into one of the header files?
> 
> [As an aside, you don't need to pass both dev (parent) and child]

I see your point. This wasn't always the case, since ocelot-core prior
to v8 would call ocelot_spi_devm_init_regmap. Since this was changed,
the "dev, dev" part can all be handled internally. That's nice.

> 
> In there you could simply do:
> 
> inline struct regmap *ocelot_init_regmap_from_resource(struct device *dev,
> 						       const struct resource *res)
> {
> 	if (dev_get_drvdata(dev->parent)->spi)
> 		return ocelot_spi_devm_init_regmap(dev, res);
> 
> 	return NULL;
> }

If I do this, won't I have to declare ocelot_spi_devm_init_regmap in a
larger scope (include/soc/mscc/ocelot.h)? I like the idea of keeping it
more hidden inside drivers/mfd/ocelot.h, assuming I can't keep it
enclosed in drivers/mfd/ocelot-spi.c entirely.

> 
> Also, do you really need devm in the title?

Understood. I figured adding devm made it clearer about what is going
on. I don't have a strong opinion one way or another. If nothing else,
it'll shorten my function names which can be wordy... But as I say this
I noticed "ocelot_init_regmap_from_resource" doesn't have devm. I'll
remove it.

> 
> > Or alternatively you could leave the "core"/"spi" pseudo-separation up
> > to the next person who needs to add support for some other register I/O
> > method.
> 
> Or this.  Your call.

I do like having them separate. Even as I've been working on v8, it has
been clear that "these commits go toward improving the spi section"
while others are implementing core features (serdes, for example.)

I feel like v8 has landed in a pretty good spot between keeping
everything completely separate and having everything be one file.

> 
> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
