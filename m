Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33514DAE26
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 11:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348359AbiCPKUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 06:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiCPKUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 06:20:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1214340DD;
        Wed, 16 Mar 2022 03:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3YT+uLo36S0NrTZZtniO/7qkMVmHtDqxmXYxYYjJ8hkUjGzvA1N5his9iZjeog2DIpWVUR5OrW6TsTOOKlY2ppOxbldA5xuQHvw4MSzjvcZV++FbwTiDsDXViVCa4To/S58fkmokueojGlXXyFk8MdhPXd8jlTOYOXV00gG3hoIGZxUTI5EDcvOFpsW7l0eA6jkHUSXKU00O0EcyKa0x69qlh1GSgVkfZW4v4VpNJ6osgiioL7DZYEFB7gEEJwK3bb/itt43vgY4Eq9JFgVxZqZvSQdYBtSqCHfPUQFOfeJ/DtqEt70p6vMxeb4LwD9tKkl85lYYKvTbq77OJpppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iAtSAgftE+nDmHQ8EYOlgBMsKVHCdlcwFB8+01zsPw=;
 b=IbTnOLG2Ig1Qst1S7XtWoghZWXIjRXi+sMlIuuSSUz8bhdYGamtk6940m4k06QyOupicA8X6Yd/y97vFNmWcocUShP5ji6DItlv5VNKYa5gMsE6Q8QjUikRNjRga1H/UCaHZwLZTz5D7hcFF1Bt4bAZI7W8lcR1dlmaQjfps7qAL4Ecq6FdvMsmQBosC1XRS6WoxwGP6eimd5aiim9c6V1siT5Rg6Mea89yV/NA2RHLQlpk9fth+DLrkFYVxw4Z4Jz6sXq7eVqQh+L/qJf230K9wzx7at5x1RIROsDpAW4mJZBG+lEh4dbBs0RIqkOvT7IQ4ovm2A3zBqsnlVYmL8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iAtSAgftE+nDmHQ8EYOlgBMsKVHCdlcwFB8+01zsPw=;
 b=a5OoR8PwCwGlnGKzx9BEwlAIOISeWp+eCWHGInTZeIAQplzH5tdU46t+qCt429Y5W6D5p6ehPkp2UNt8iJ0SyKHUSi/G3YQ/I+aDbT9SolqfMS11Jrz8DfazJOvl1/WEJSiWKHmlP5YgSh7cgKWLqnZREhheBHjgqT1Pi4UEdPI=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Wed, 16 Mar
 2022 10:18:55 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 10:18:55 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Thread-Topic: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Thread-Index: AQHYOGjtNze6uoFOtkeaYiQGh4M7eqzAwkyAgAAMu4CAAN51gIAAICwA
Date:   Wed, 16 Mar 2022 10:18:55 +0000
Message-ID: <20220316101854.imevzoqk6oashrgg@skbuf>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
In-Reply-To: <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 099245f5-9ae6-4089-3542-08da0736607e
x-ms-traffictypediagnostic: DBAPR04MB7432:EE_
x-microsoft-antispam-prvs: <DBAPR04MB7432E50F491185CAE73C464AE0119@DBAPR04MB7432.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ivq8MuMExPwFQWdCGyLgORwuDWu/KwxSKLPNPG0Y7ngCMsgwVCElDbhTy0OspnKyznnbrft0MMCKqzQAY8GTPGs6JwAjwemNHp0wjGPIfobg6zhG7F4NTLrlqBCJJtPjUuprS4Iidn9EJEJjXzlSE/k6n04wuybQvbM3BjSF00AUUheZ621a0Nkb3wXH//GUWnyAmC2Lw0dc5bhtzmyLrY06b/jrQ7+movUmBpsh/TVWOM3HsgkNZX96sdEzsXqAQvCTes+kOf/HhJVZG5uKsLWmBBpy92u7aLUWQ1TMi5PB/bo2KFclP7oQhMtqJszHcM76Qh6cLlgUuEJj5bCuS6+hWluMxJkk5yfaxhlvO4F7WbYCvh257bDH2wZH6SY5a1QPDdJXcG0feRdPYhH/9WMB4PUqo1+gQMLYKiEfOg85FoZEcRkUZ/6FzDull/h1oSOqDtIRhFyFrhtn0HK7ZC5HkKY34SH2XyLy7wTJplzh2mfoYBSUAFuB235NO+PTIERneJeWLezAhIp2YScjzuqAp2f/FO5x68LmCUNhC64AyNj4TvR6EYpRj4ZaWX1nSybrz+boJ4CgU8Es7iif0dEg4zCBulKPfBmS0CzaF1l6blm4aop7hS2GUTkxrazDyJS9tKkc7aL5Wm/v5XCQCFvXzJGkvlL2vSWl8RofhdHN5PDbQ6tbfsN8tC6TBku4hMoD4c3ITuDCXNNcioUTBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(38070700005)(186003)(83380400001)(1076003)(2906002)(33716001)(5660300002)(8936002)(44832011)(316002)(53546011)(76116006)(91956017)(54906003)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(86362001)(6506007)(9686003)(6512007)(38100700002)(122000001)(508600001)(71200400001)(6486002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/7I6tW84vntjWudO0amBoRlSV2cQJcqvRim/g2lXhWungHr7qRJHM92Kj2JN?=
 =?us-ascii?Q?2zH0E+xm/UDa/BpmrCK7vGOlyl4UPRx4iJBMAvAWmWsic4vlsNCmZAVntV38?=
 =?us-ascii?Q?14Omwft2eVzc+WzrD2p716+VGmoetLUIHha+pdA5yGSHwVyMSl/TUPd3xMwy?=
 =?us-ascii?Q?kTfmNco3Rr9NnpEiGzFG8PQpPZqxfRSjtOTsOodRVW/v46tyjBb2k/Yd9nAD?=
 =?us-ascii?Q?PLUhLpRXeykAnaCAzvNAG1GlvkCfwY2SGMjf5DZXPQw6MS8kyQpgi4LrupkK?=
 =?us-ascii?Q?Pf3KRz+2J4iiX1EkzYeVIRukc03DMOBokgAviI0ucMAmggSxBdVYL00143CB?=
 =?us-ascii?Q?JXzIbBrb4jR4Fff7ODxN+bT2yBMfhYaCq6dFoiiohy9r3ZiiPWi1afjnwiXL?=
 =?us-ascii?Q?4ZRMBK/OCCSzL/JrG4CwxiQLDKwAEmwV80HAssw2jRiIwKzHE22yAZ5TAXP2?=
 =?us-ascii?Q?+D6s6Nr0OYiSSSWX+qyR8BdlvavjKh8bgo+k8ZwWoIYLjZCjrMY2USC8R15V?=
 =?us-ascii?Q?KPg6+TaERW9ETAB0AXcYEWVLq4eu6ai8hu0O15lDbBorgNo4yx+Sr9us8G4S?=
 =?us-ascii?Q?gUT/wmxLDwwr1ooHMKKSqfHfJUhUb3Hh0KLKd2bnECUWHTmrxJEQeCb/oS13?=
 =?us-ascii?Q?agEPuoXKQWW2Bo8khQHPpNtlSWojlzcXlgxZt3HbG2FXiloqzO8558REP9Jp?=
 =?us-ascii?Q?V9Swhq7mtqe5F4+5dGlRwNS+DBiWEaTLGXItozUcbiYnPKIQbvKKQhEBrtzb?=
 =?us-ascii?Q?GgPvVv7AsEJa8Jn2Ahx7ml4a5XJD3RRp83NqWFtnDIm+i3Ix9lHsqjEULX1L?=
 =?us-ascii?Q?gNGdyUw87CbUPiVErObCwcsqI8e+90ckcxfJ1MdhW6cTF8ZOvNNWwlNIAfKA?=
 =?us-ascii?Q?7AKuyeTtKkx8/EnQn/MP5ur+WnMEF6PTz1DhjBPhLFHFgGmfGi2tM3tC0PLY?=
 =?us-ascii?Q?ftZDEQnjj46JOZIMPsNTC4+1nHq5EMT3qeDna/s7YFTnQ3xMdE1KFFZVMa+e?=
 =?us-ascii?Q?MAeuZlGc9Ga5sC/InpNNGDTrCIqv7oyj6JSy3qwqWMZazk3ocakVBw3zBVdg?=
 =?us-ascii?Q?iRYL3UjxjTpbI/Sg3lGQ0uQKt+B5HAlMXIdk6grhHw/maCMnkHfsMZZj14bh?=
 =?us-ascii?Q?JrDsKrvnXRjthjmYFP/1v9G8WI+/WDzZTPQYAMFGqonGhqeuOlerDw5hehGX?=
 =?us-ascii?Q?OI2ZLvmw8HCs2BafLvlCPPSnTFNfQrVf1X8LBC4ohV3C/mYrd0ADgKUL9dbJ?=
 =?us-ascii?Q?PkzoNyO9JEaCjyVqGJAvQ2Rj/DYfkfthRIMLmLkgMS5K1lT+TFZ8txv5YBZD?=
 =?us-ascii?Q?IwGod7bsXueW+Q6yOlbzKqbLZ9j4qDIoAWKoleX5GVeqxX3ZcHxEzZ652fdc?=
 =?us-ascii?Q?jmNT5Kg0O28ADaRuVWMJpsEyEGTxseTCrMqVL331OoeABb9VWPGyQOenAelC?=
 =?us-ascii?Q?yODiw1pkOYgZQlfNxRc5M7U48DtKJ+4yZ/qDiJ33A98ovONQpbl6JA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <652D1C2124EAE049B4C7A48F087893F8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099245f5-9ae6-4089-3542-08da0736607e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 10:18:55.4390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KqboTLEIzeUN9CVQzNgTMMqPGhna9Xpuc+rFINC87akmH1gJMnJs+TROiq/lyCPnQuCRenVEYcYCnLnjw8B2Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 09:23:45AM +0100, Krzysztof Kozlowski wrote:
> On 15/03/2022 20:07, Ioana Ciornei wrote:
> > On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
> >> On 15/03/2022 13:33, Ioana Ciornei wrote:
> >>> Convert the sff,sfp.txt bindings to the DT schema format.
> >>>
> >>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> >>> ---
> >=20
> > (..)
> >=20
> >>> +maintainers:
> >>> +  - Russell King <linux@armlinux.org.uk>
> >>> +
> >>> +properties:
> >>> +  compatible:
> >>> +    enum:
> >>> +      - sff,sfp  # for SFP modules
> >>> +      - sff,sff  # for soldered down SFF modules
> >>> +
> >>> +  i2c-bus:
> >>
> >> Thanks for the conversion.
> >>
> >> You need here a type because this does not look like standard property=
.
> >=20
> > Ok.
> >=20
> >>
> >>> +    description:
> >>> +      phandle of an I2C bus controller for the SFP two wire serial
> >>> +
> >>> +  maximum-power-milliwatt:
> >>> +    maxItems: 1
> >>> +    description:
> >>> +      Maximum module power consumption Specifies the maximum power c=
onsumption
> >>> +      allowable by a module in the slot, in milli-Watts. Presently, =
modules can
> >>> +      be up to 1W, 1.5W or 2W.
> >>> +
> >>> +patternProperties:
> >>> +  "mod-def0-gpio(s)?":
> >>
> >> This should be just "mod-def0-gpios", no need for pattern. The same in
> >> all other places.
> >>
> >=20
> > The GPIO subsystem accepts both suffixes: "gpio" and "gpios", see
> > gpio_suffixes[]. If I just use "mod-def0-gpios" multiple DT files will
> > fail the check because they are using the "gpio" suffix.
> >=20
> > Why isn't this pattern acceptable?
>=20
> Because original bindings required gpios, so DTS are wrong, and the
> pattern makes it difficult to grep and read such simple property.
>=20
> The DTSes which do not follow bindings should be corrected.
>=20

Russell, do you have any thoughts on this?
I am asking this because you were the one that added the "-gpios" suffix
in the dtbinding and the "-gpio" usage in the DT files so I wouldn't
want this to diverge from your thinking.

Do you have a preference?

> >=20
> >>> +
> >>> +  "rate-select1-gpio(s)?":
> >>> +    maxItems: 1
> >>> +    description:
> >>> +      GPIO phandle and a specifier of the Tx Signaling Rate Select (=
AKA RS1)
> >>> +      output gpio signal (SFP+ only), low - low Tx rate, high - high=
 Tx rate. Must
> >>> +      not be present for SFF modules
> >>
> >> This and other cases should have a "allOf: if: ...." with a
> >> "rate-select1-gpios: false", to disallow this property on SFF modules.
> >>
> >=20
> > Ok, didn't know that's possible.
> >=20
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - i2c-bus
> >>> +
> >>> +additionalProperties: false
> >>> +
> >>> +examples:
> >>> +  - | # Direct serdes to SFP connection
> >>> +    #include <dt-bindings/gpio/gpio.h>
> >>> +
> >>> +    sfp_eth3: sfp-eth3 {
> >>
> >> Generic node name please, so maybe "transceiver"? or just "sfp"?
> >>
> >=20
> > Ok, I can do just "sfp".
> >=20
> >>> +      compatible =3D "sff,sfp";
> >>> +      i2c-bus =3D <&sfp_1g_i2c>;
> >>> +      los-gpios =3D <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> >>> +      mod-def0-gpios =3D <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> >>> +      maximum-power-milliwatt =3D <1000>;
> >>> +      pinctrl-names =3D "default";
> >>> +      pinctrl-0 =3D <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> >>> +      tx-disable-gpios =3D <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> >>> +      tx-fault-gpios =3D <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> >>> +    };
> >>> +
> >>> +    cps_emac3 {
> >>
> >> This is not related, so please remove.
> >=20
> > It's related since it shows a generic usage pattern of the sfp node.
> > I wouldn't just remove it since it's just adds context to the example
> > not doing any harm.
>=20
> Usage (consumer) is not related to these bindings. The bindings for this
> phy/mac should show the usage of sfp, but not the provider bindings.
>=20
> The bindings of each clock provider do not contain examples for clock
> consumer. Same for regulator, pinctrl, power domains, interconnect and
> every other component. It would be a lot of code duplication to include
> consumers in each provider. Instead, we out the example of consumer in
> the consumer bindings.
>=20
> The harm is - duplicated code and one more example which can be done
> wrong (like here node name not conforming to DT spec).

I suppose you refer to "sfp-eth3" which you suggested here to be just
"sfp". In an example, that's totally acceptable but on boards there can
be multiple SFPs which would mean that there would be multiple sfp
nodes. We have to discern somehow between them. Adding a unit name would
not be optimal since there is no "reg" property to go with it.

So "sfp-eth3" or variants I think are necessary even though not
conforming to the DT spec.

>=20
> If you insist to keep it, please share why these bindings are special,
> different than all other bindings I mentioned above.

If it's that unheard of to have a somewhat complete example why are
there multiple dtschema files submitted even by yourself with this same
setup?
As an example for a consumer device being listed in the provider yaml
file is 'gpio-pca95xx.yaml' and for the reverse (provider described in
the consumer) I can list 'samsung,s5pv210-clock.yaml',
'samsung,exynos5260-clock.yaml' etc.

Ioana

