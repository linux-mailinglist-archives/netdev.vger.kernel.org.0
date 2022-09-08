Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F735B206C
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiIHOXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiIHOXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:23:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2049.outbound.protection.outlook.com [40.107.22.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2415BA5721;
        Thu,  8 Sep 2022 07:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjivMmXDZGzJajzawUXjaWlYY5C+4k8sXGky9mX20fCeNAPwo6Y+nLF7xHDiYau51ihlQTvEbfkoJH/Tsy+9stL8CQXbRaaDlnRmPY30V6Xt7pWFg3UkJFNxhdMW0cxeH0nWkzyN0usSnEOhz9ChEGjIYrj/PCjN4Hc9sNabM97Kz5DA3AtfPXwTeXGQNYOFbbjeRz1+7akLx/yIIVtI5dA7kVY9UStUvVvKp40dwNSxDoCqUmfFRfjZ1urezGpbrQXk4yZI9VFhklsx3ck8HMGtWRz/Zq/sV3Mm7GZN12h6Wz+Hpe6DRuFM+q0/gMHb+FjSabtj1+Qr9by5SDN/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjEqt/po8qpBZHKLR5lzdqWsc9H5IhpUShSJnxTJ8QM=;
 b=nR18kVAcMkq8Cy/g0rR/WJAUsOQFwwI2VwdvuHCCwxj2idh5tLq2T993PwClkAa/QZXnJY6cb1ChTEi4v5FAVWN1t8gmc4Xk9au+NiNqJI8RHfHNgeIX3V0i+wxZBQqp+gPxARTaCI//QNvnpbV7mF56va614N217uYCQ8GkRn3UUpHE2x4q9NUY+dtFQVdlwiD0w/hcsggsgydnF7Wrxb3D7NZPulhJsZy/U7gBAPVtLL+z874vEG7Ncg8ImKuICksfX3Q2xSkEWQ4S7zojsBC6XOd9yeDRZpnjQs7h70OM5GjVMrhC49Hhjvm12qvewqpwsnBiwcvWPIzPf7RcMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjEqt/po8qpBZHKLR5lzdqWsc9H5IhpUShSJnxTJ8QM=;
 b=hAu1kFlp6eKfBrIP3PmTmFM5PAVf0tJE6ACg4fMlkQpmLElpymi+L82wKmYfgO43QVmlUU8TVkTpTxi8TryT1pR2ktCejJRVWEUhmemWgKw2aQQOlEru3Gpo4hN4jHQw1RBTIgFoYO4Oy6DrEHlLEbFDPkpsiCN/MKW3aVDDuWg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8496.eurprd04.prod.outlook.com (2603:10a6:10:2c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.15; Thu, 8 Sep
 2022 14:22:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 14:22:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Topic: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Index: AQHYwUOdDJSLJ7OoIUmdxm/qLSQnvK3VS58AgABO1AA=
Date:   Thu, 8 Sep 2022 14:22:56 +0000
Message-ID: <20220908142256.7aad25k553sqfgbm@skbuf>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-2-colin.foster@in-advantage.com>
 <Yxm4oMq8dpsFg61b@google.com>
In-Reply-To: <Yxm4oMq8dpsFg61b@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41f3c8d1-c464-49c9-6a8f-08da91a5a00e
x-ms-traffictypediagnostic: DB9PR04MB8496:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8n1S6FXtBnkVVaaKgGxmgKQVZkmFkDCBK+s8dFpBIrteX5z/8kp8YsQqqTgCk8o+f2UHx2CrlAJ1+Yq0K9ZOHb0KWkUo//nH/ss5ozD8wWbuhTOqKrkoCnwAGyAcqigDjHm6XlQ/SnPGxZkr9gG1Ms7fKw+ffAazmwDfcWi3yrtpTpkx27SJ55UBXqRD1hoJsciE/nWtbPugxnHS2V6BcQ5mrJ0aLuScZvIdAz5ixICCzRorrqxSKPDPwgMR53s86Vj7kuMVJysXF8LO7h9N4IwpLPZ0gBbL6n6erGfQOFp/bqbqVm5dFErUVEme6V6Pyr1aLWw7zMbuPDKgt/+UeR2fbKVk5WqNiMEMT9sr3CJliGs6+eLtToRJlJocW75tzUE5oSgzexWzi122rDHzzlGcxvHtIS+6E1c13uUJDPrgWCqATh55CRYh/nC0+uTFVw0YYEl5AUyb7RgINKZU8cNz+fWq3rCN+KBXaRBc+eOY5CSMnDnivxScuTyqtlk/gix9lyk3Q9jh/BHHIR4YGLHiv05cDQK7VmCjkiD7H3fFEpk4iu80Dr4KW9FZfGmWvGeWyiMS7cQCWc7/RV0o4NsnvynCQN9wKi6y+szrqDbeOwCOJ3M8B6L/j0Jsh+cUc95UHRSDjXsGEZ05uLX1iIZtdNRcQh29Sl3qaM6jYme4z/mZLz0DaPOHoDrE8Gs9NWpbC80nh8QZ7/+yuo6bo2pdPa46MoJ7iWh2VjMCWtYlOz5B2MUSlQwNS6ZoYWv7PLAI2f6oISk8hWcEX68MgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(1076003)(122000001)(186003)(38100700002)(2906002)(33716001)(83380400001)(66946007)(54906003)(86362001)(110136005)(41300700001)(316002)(66556008)(66446008)(66476007)(64756008)(8676002)(76116006)(91956017)(4326008)(5660300002)(6486002)(38070700005)(7416002)(44832011)(71200400001)(478600001)(4744005)(6512007)(8936002)(6506007)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?obgf8DMVO859bn0bBPAcU2qWbi/7MEWrJ1rIkN8AiBLjMCR1cVk9MRUessgo?=
 =?us-ascii?Q?Dbpsm0D5KGlGGaiYVjiKEP685Jgnb5FXzOLCXtdDy4COAGjgWHS3y3BaBeTQ?=
 =?us-ascii?Q?siXahbnkcjDwCKah9YKL4REE/fM7vajB1GTZAgHAgco+koSxvwmmIC2NWlgW?=
 =?us-ascii?Q?rrHvuDbX2x5ymp/sdopiTTmeZwX7AImyh44ZgSPmiHZ+eLd3IUKNnbsPwM/d?=
 =?us-ascii?Q?NZHcSgDXb4tJsG3P0hfkRBK3Pxha9GSkI5sGtd626A9Ne9zQc+wSaunqPRVT?=
 =?us-ascii?Q?mVxk+h5UGWt/Ox9yfQIzu9dPZGVdtv/nWtu0pZxn7KJlpEfkJ/HdlehBg1zg?=
 =?us-ascii?Q?YQ2WZorX92Yq56DhucJjFQG179312Cpmop9GKRWuBBA8ltahWTDDFLuElnn+?=
 =?us-ascii?Q?yp18lnZfoTYI14IOZgTfkrxaV/UHkOuhMmX0ocAR1cHdQKFhCRty56UOazGB?=
 =?us-ascii?Q?moICkHWkBL3kcOXRSnDMoFVTkIXBqV7t7wpLlFppswARRHdCjgr0+wO7R9cT?=
 =?us-ascii?Q?gA+2xV4Kv6e18juTPmXqfJUPtuSVdI4yDevdy5fiDzeTsIKYI84CYB5LRxG/?=
 =?us-ascii?Q?lzoXZTrPMqsH9AK6nZ5tMdurzlvsbs/lsTXfzYIz18jYMiDgnuHyNY8rgZ3o?=
 =?us-ascii?Q?h33PESnvXc2lrWHEF3G1gDBoBJATpoLcYtiwHW/Dip+U3wxrBade9rrKrVY3?=
 =?us-ascii?Q?Ww10W9a7n2cppqpJQOwJbDILGuT/v2VKCZh2wSRHZDi6Qu1WsTfHkUSY6kjV?=
 =?us-ascii?Q?fHACDyA3dqKYi1A/doT+52+++rYEVvDveUBAYHFFeZ0RfWYH+hyVO1mlDTL7?=
 =?us-ascii?Q?m/ry0hFtl84ab8KqHWRfV0XOEGFsmGfpwZ+W1Ln6A96Q65syyf3ZNHm3xyp1?=
 =?us-ascii?Q?qdJR9E5kWzCHKDPVW3rDsSYBCwIvlqfrcwcxSaIynIBWQ2pxU/ZbeFS2e9yC?=
 =?us-ascii?Q?M5amWoIfPKwMeQhB5OuxN0PaCE1Q0pwntI5TG+Ffiybj1/RFIJhEadzqPwpI?=
 =?us-ascii?Q?I0gOBhBUh7SWBsqMK4fV6S+g/GeAWy0JDWWmy6lAF8rX2eKcOUI5VQrj18GG?=
 =?us-ascii?Q?cqKUGLoNzWfKYtFBL3QCYKzvJwSOR7BSiwQrYS/siiW2oHQK0m155tm3ChRb?=
 =?us-ascii?Q?eG1Lconn/GQN1ITyrV3GfCQggAT6zdXormd6psU2nlXLlRVsIbjlUt3jfOfH?=
 =?us-ascii?Q?pQj2I6oxMn/nT1mdmTGaG4dmAEneUgqhUNRRTj+mm9kHAUFqk8LIoouihz5y?=
 =?us-ascii?Q?KioQGfD4eDoQ8LABKDQV8JWfRvOn/eyS6unb8MQCQrBdroGvNluvYMLAyotk?=
 =?us-ascii?Q?vBYMPHrK9Ra5v0cIDzXBrtUBIhQEnVYiC6u0w1aJfDppnRvlov4olharehkU?=
 =?us-ascii?Q?OOyjp6z2nWycxIdX4EWdcLeHALiDMRrJBpt0gRIs4/RTtenrCrYtH0Xe20WI?=
 =?us-ascii?Q?bSMDWpCSrQE40C5aClo27OWKQkTBNyBfzeoyLKOZf12CzQYxL1fzNJXOTISZ?=
 =?us-ascii?Q?Jeuo3M+nkS3CFlnuKZXvMTC5QpWMZiFoWuIU6Nw3gj3JQBEE53xjmizVenDU?=
 =?us-ascii?Q?NYChbg4I1Qb3Hb5y314EKaXeFW49V4sOnmH1lwAvAaE2XWTEEa/PlMkjskX/?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <164EF5490D348A42A22F589C31CD3AB6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f3c8d1-c464-49c9-6a8f-08da91a5a00e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 14:22:56.6652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zOPqOv3MX80ktPNcd+pYmN9218KgVQHK3kBE25A5trKYANA3CTl76ejeua5nDsIuKivbZah5TMzgvL2S2R1WSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8496
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 10:40:48AM +0100, Lee Jones wrote:
> Applied, thanks.

Hurray!

Colin, what plans do you have for the rest of VSC7512 upstreaming?
Do you need Lee to provide a stable branch for networking to pull, so
you can continue development in this kernel release cycle, or do you
expect that there won't be dependencies and you can therefore just test
on linux-next?=
