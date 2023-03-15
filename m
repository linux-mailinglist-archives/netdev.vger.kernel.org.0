Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C3B6BAADF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjCOIfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjCOIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:35:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE966700B;
        Wed, 15 Mar 2023 01:35:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQdK8PNAMnJQRn/l4AQRcZbqOf25yjQQfaEgTupt3vRP1h0eoWIqjZm3FzuIoXUUTv7SrW3PLXTzhA+YppeoDWKPtav6esEJTCObKK7HXxNxm+lPX0YBgfe7abd41PG6pLeiBwzDobbbKJ0cLXevNIL8XmZhOu6MRxzEJ1ATfosjk90gP227cjdWWj/vJUF50EG0WnFOWnO29PNDkE4BVab7PCPBM4aDVwyHKY4j+c2dHMHtoLVXB1I4qFpRb38+jcrg55nqMxwAz6JYoILl6r5PDnqTpBkgNbZtytdVrWnDB1VghPuGCVxvOyjHL86dNmPetB5Nb98+SVXAjIfTlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+WVG9GQG16dgubbwWX9vkz5rEUgV2C7+S0x+w/w2xA=;
 b=YqyEKYkQo+2HQx7wvYRk0/V4b2B7r2LNfEnZB9O9vbA7vtesSvcdVSFRgcjmarGY9Y6JlAROMJaH2Dx7LL2foKjz64wVOMX0D/d9FkqaJOwQUC2plZES5B3qKiPnSThPdM+MJv+hPGRC9nuUjwlt7j7xX8mHKqT1zAvJDPPfBlumRIUvhPha6hE0Ozt4CCBun2Az2yAfkXD9SvQB+2PPytGBfHJFfHb//GuOVxRUskDVyroq+ZCycGJK/8thb5EiBbiIy/eAbOqglraO38/H2PHrgLDDZ7wX8PkDLBFLr7HBujtzIKXDZFk4/3MP6ej+cEY8KOsjyDkp+TS1bCUJFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WVG9GQG16dgubbwWX9vkz5rEUgV2C7+S0x+w/w2xA=;
 b=Wo0ZFe8U+IzIz1SWngykfZhT7nVbJvYgMQdDL0P+Tkb8rEzWVwxP5w1mg7C7OIr3akaIfGYxG8uNywV0GAH/YSTkY9Xh82ukQ0eSYQYsVR4sm5/59q5Rn1Um4dOqvwrE+j8rmhH7YtNxrEyUMBB0LH5VW8jk5dmn9Z+XOEG1HX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6053.namprd13.prod.outlook.com (2603:10b6:806:33a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 08:35:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 08:35:12 +0000
Date:   Wed, 15 Mar 2023 09:35:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: Use of_property_read_bool() for boolean properties
Message-ID: <ZBGDNlelN0WFBaq6@corigine.com>
References: <20230310144718.1544169-1-robh@kernel.org>
 <ZAxrBtNdou28yPPB@corigine.com>
 <CAL_JsqJTsgmdwZZTfcMRnqaUfCNbgjO2mshxtAQK-qwoFqwCyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJTsgmdwZZTfcMRnqaUfCNbgjO2mshxtAQK-qwoFqwCyw@mail.gmail.com>
X-ClientProxiedBy: AM4PR07CA0033.eurprd07.prod.outlook.com
 (2603:10a6:205:1::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6053:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a21e76e-9097-4f70-2db4-08db25303130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1Nm8tSp+cN/CqWBydj5jewXt2IcaxgcJMI0BWk5P0qhZSxXdCzovpiZt/2wWHD90/GLEyvV19e074mZDp9mZnli7r4YGjaPVzCflx8PtoQK08vLFpYMBpKGgkGlPnugtOzi2FbCK3Wc/kVP+Z46Rhh4HrR9Tz6yHrZRz7YXUjyiseEYRWvz5ci2WsA0gLPOhqQZvcwNeGxQxFtka4G0GlaBsoCXAhOxIGwXxFu7QfhqXLyKffZBGG7E4HGzrx2krzQzPypaMsrhJOQqRfYp65PFNRxlTya7r5tAP0qmEbUIKwzcTm5qF+iZ7/nlkV4IMDcB7HeVIH5mz42qV9Zwlp7JplipL98C5RX2AG73MkElaj1lAlktBVHUL09LxSX+uQeYFbpvtdw2d88kw3OA5djkiAEyJ0SVY8yIOg0W5z9XWzMe8Kc//ktY6L6GSUmyLymoh1NSCOS1I3UIlYckpj1PXTqP8//JfLrVAEXo3Cgqm1dJp8giZj6T2QTu2+nlL0Ba6GR6H05nJNo/yiktovVGnasdQCnPxkT7fXWe+xEv/MxtHSw/zyAD4tTILB+8GzqmxnnOfcMH88FXHUfdkJVro/CsWztLcyz9v+Ca7EBYBKvNZ55emYZ4A0txVeZfWE3QgesFLFGIIXQ6QCrzEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(366004)(376002)(136003)(396003)(346002)(451199018)(7406005)(2906002)(316002)(53546011)(7416002)(44832011)(8936002)(478600001)(54906003)(38100700002)(86362001)(6486002)(2616005)(36756003)(41300700001)(66946007)(66556008)(6666004)(66476007)(6916009)(8676002)(6506007)(6512007)(4326008)(186003)(5660300002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1FzQ2Y2ZFdYWENoWVBJaGx0aS9tKytCMXJ6aE9KT1dlZjRtQjR4eVhtWGxL?=
 =?utf-8?B?Wm0xMS9EcW1USlozeEYxRzgrVGZUYmVOejVYajBNYzFxQWNPRWsxdnhwVWRQ?=
 =?utf-8?B?ZlRZNVRvTTZQOXF3bUFOMURmNE9LYmVScDJpSGFYaGQ2WlpRTXZRZmNXNFdo?=
 =?utf-8?B?NnVxYXh5TTVzWERsQTRjWnB1Q1ozRUp1M2NLc2hUYUhkZnhaZ1EwR0g2czZ1?=
 =?utf-8?B?NGFZMWRaVEtHRHI5ZHpiU01mMVpndGdLdFV2ekZUYzMzOXR1d09zbW5YeDAx?=
 =?utf-8?B?SnhpdmxCMWpLS3hRRm9RSko3RUtCbDJBdTJRT3p0U0F1VzloVktTRjlQWnNW?=
 =?utf-8?B?OEV2SnloYU9MSXBEKzlDTjNnTGJ2d25RLzlEMXJhakRpem5WZUNzOVl4c1pT?=
 =?utf-8?B?aG5jRGNsRXBkMWZUYmRmNjFFQWZZK0xUVTgvNGYyck9Sc3N4cFJ5UXIxb1dZ?=
 =?utf-8?B?Z0J4WHVtYStJbFhiMW1wMHlibzVHWHNJWkFzNldGNUFwdWJobkJWWDVDSklX?=
 =?utf-8?B?d0d2MVNDNllrSktjcUYvUDBLMEhwTkRsTE5ZOFRvM0hlYTJYeEpzU3QxRWxC?=
 =?utf-8?B?NHBJVFVrYzRRdWt6Q1N1Yzc2bFd2SEdtMWZTWUFpWGQrQzFUV0hNazdCRDFn?=
 =?utf-8?B?VXN0dU95Zmx3bmV5MU1Qb0ZVdzFGaHZWM1dtbGxFeW9MdXlwOEQ4TUs4bGZN?=
 =?utf-8?B?V25pNXN0RG1kTHVCek1VWnNNNzljSUtBMFZNUnZ0K3FtU29vMkpEMjRNVzcz?=
 =?utf-8?B?UjF6blJRQ3pPNjZiZ0dmdjluR3J1NEsxZmlXYkVpM2NxOS9kUklHM0hsQ1M1?=
 =?utf-8?B?b0c4c3Fidmg2ckpMZmErUTNhOFJDQUhUUEdvOUFaSGJrUXV2dU8vbEhveitE?=
 =?utf-8?B?K3VYb0xmT1BEdlJqSVBsRkY0VjZRdGFmSjhLTW1wd25zQytWdFlXR3VvN2k2?=
 =?utf-8?B?ZURoYkwvMkxrUlhoWk9DRG1lMFVkRlZtWXRYaEVnOTFJQ2NhalBGSVE1QWgz?=
 =?utf-8?B?K1J0dzIyQ2p3azFKemNTcWRBQlJseHJMMGxrcTFCd2ZFbTZISjFUS1VZWlVt?=
 =?utf-8?B?RkNuUVJqZkM0YVNCRDFibThEWmc0djlucGRkRGdtMTVUS2FreHRScmRyNmE1?=
 =?utf-8?B?eDVSS0dNbDVkZmJkb3Awb1g3Z0N5RXcveDJjRkV4bWkxeE52WkNXNGRqdWxO?=
 =?utf-8?B?bnJiN1FWbFNsaU9WbTBUM29jckZwdmhSK1g1ZDQ3TUFaaFFYRTFrajBKTEdH?=
 =?utf-8?B?ME80MGZaTFVQTTMvdEdQZzlFbFNvSmFNWjB4UGFPeUhBbFptd3hEandoZmxF?=
 =?utf-8?B?TkZ5aHc0YXY0cFBoSWd6S08vK01MOUNlOFBkUllZWTZka1FibUE5RVBjdmhQ?=
 =?utf-8?B?T3lkaDJQd1VVbm02aGFwK2dSRmx4ZnZUQ1U4NlZES0FkdUJWMDM2cEg5a3hm?=
 =?utf-8?B?aEZsZVBCRzR6T2UyeVFiVmdnQUxiOS9MZjVPaXZ2TWpzQXU1RDY2L25YaVEw?=
 =?utf-8?B?YmtjYTNtUkY1KzZFMEs1ZDMwZjJpY3FXRzR1ZzJuVDVIR2hkMHFxN3J3bldq?=
 =?utf-8?B?Y09MaFNHN1VLbUxBQnJ6TTZDd0dCN1ZtQzcxc2FJS0c0RjI5NkZENlZVOGZQ?=
 =?utf-8?B?Zk5kMTVUbmZ3UzFvNjh6SVlsU3FuMU9uYU5kZjJrZHliVUxQSU5uN1BlNzV5?=
 =?utf-8?B?eFhOTHBRcjdxOXErR2tybG9sVDhHRWREQnhiWHM5RVp0R09tWU9Vdlg3bmJj?=
 =?utf-8?B?ZjI4aUNXcmFaSkw0M2gzV05oWDdxdDh1eDREdUxGYzJjT29nczAvUkFJNUVV?=
 =?utf-8?B?d3pzYjIyRE1kcDVsUFY4OGNmcmhNNndOcDdCL1VSVTZ0UUVwMUo1ZG90Vy84?=
 =?utf-8?B?Nm9qbzByYU9BZXJLSXlWNGZkeU9pR01VZkk4UkRDVUx5MGFjZVBwRFBVVjhl?=
 =?utf-8?B?RFdDemxqblZ0bzJlSzU5TGZKOUd2eFRUYStlck0zekRmaDJtbmQ4Z01qWFA0?=
 =?utf-8?B?ZVRlcUp5azcvcGYydWdUeG01RDBnQ0FGS3lNS2FYRmFINEhxT0RLTDFCR3N1?=
 =?utf-8?B?MmcvZEh0VnVrMG84MjVEaEZ1UkRTTnJ4NDlaNkdBTTFFVlMwck8zRkt2Q1d6?=
 =?utf-8?B?a1dOWU1BbDAvbXdGZmR5Z2QvTE5od0hXeTBpenV3enhSNWdMcU1OK3NOOElR?=
 =?utf-8?B?bGsxNGNoZXJ5R3VWK3Ftc2lMcGhKRk9QQVR4VjV2VmRVckliUVREN3VJYldJ?=
 =?utf-8?B?cDY4K2hqZVR3REFJNGdxWSs5ZnVRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a21e76e-9097-4f70-2db4-08db25303130
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 08:35:11.8674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bb7YzuZoBKahmnvFKIYzQ7COHjRqbRgcIm2g5LuBmZM568jCzQm6Tqj3sDoWFQkuq40t3+NBBdTDjjTgF78WaLepAQUK8Udi7mV1A3D5niQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6053
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:14:37PM -0500, Rob Herring wrote:
> On Sat, Mar 11, 2023 at 5:50 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Fri, Mar 10, 2023 at 08:47:16AM -0600, Rob Herring wrote:
> > > It is preferred to use typed property access functions (i.e.
> > > of_property_read_<type> functions) rather than low-level
> > > of_get_property/of_find_property functions for reading properties.
> > > Convert reading boolean properties to to of_property_read_bool().
> > >
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> >
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> > ...
> >
> > > diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
> > > index a502812ac418..86f7843b4591 100644
> > > --- a/drivers/net/ethernet/via/via-velocity.c
> > > +++ b/drivers/net/ethernet/via/via-velocity.c
> > > @@ -2709,8 +2709,7 @@ static int velocity_get_platform_info(struct velocity_info *vptr)
> > >       struct resource res;
> > >       int ret;
> > >
> > > -     if (of_get_property(vptr->dev->of_node, "no-eeprom", NULL))
> > > -             vptr->no_eeprom = 1;
> > > +     vptr->no_eeprom = of_property_read_bool(vptr->dev->of_node, "no-eeprom");
> >
> > As per my comment on "[PATCH] nfc: mrvl: Use of_property_read_bool() for
> > boolean properties".
> >
> > I'm not that enthusiastic about assigning a bool value to a field
> > with an integer type. But that is likely a topic for another patch.
> >
> > >       ret = of_address_to_resource(vptr->dev->of_node, 0, &res);
> > >       if (ret) {
> >
> > ...
> >
> > > diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
> > > index 1c53b5546927..47c2ad7a3e42 100644
> > > --- a/drivers/net/wan/fsl_ucc_hdlc.c
> > > +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> > > @@ -1177,14 +1177,9 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
> > >       uhdlc_priv->dev = &pdev->dev;
> > >       uhdlc_priv->ut_info = ut_info;
> > >
> > > -     if (of_get_property(np, "fsl,tdm-interface", NULL))
> > > -             uhdlc_priv->tsa = 1;
> > > -
> > > -     if (of_get_property(np, "fsl,ucc-internal-loopback", NULL))
> > > -             uhdlc_priv->loopback = 1;
> > > -
> > > -     if (of_get_property(np, "fsl,hdlc-bus", NULL))
> > > -             uhdlc_priv->hdlc_bus = 1;
> > > +     uhdlc_priv->tsa = of_property_read_bool(np, "fsl,tdm-interface");
> >
> > Here too.
> 
> These are already bool.

Sorry, I thought I checked. But clearly I messed it up somehow.

> Turns out the only one that needs changing is
> no_eeprom. netdev folks marked this as changes requested, so I'll add
> that in v2.

Thanks.
