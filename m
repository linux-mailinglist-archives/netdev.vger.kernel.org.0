Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5C12A4368
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKCKvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:51:08 -0500
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:42052
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726058AbgKCKvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 05:51:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqUAYvs9dgk4O/HrxjlopUNl2K091/PEwxNuZHaRWFpKbyZdFhceBSEU4RedRhZ/1X6ZNaq5jLPAlxtrrOTo0GLTZ6Sr6h2am2Kf8XODJCnyHCo+Qnst4+cxPJdosSVUU+K4GtUbNh8U4DVasoRFa5fYDf3+cILprhH3uHVgka9MDR4JexOQvzMepnR2m++pmaOeeI3BBvzAGRA+JRnYhUMy6m2a4pgIeHp/Bpctcle/spcOn8cKd4pFZ6zJNSfNlC1FFxMiWnlRkZ2TBfBdOrAeVJQgClebeWWAOspU3C6EIcMOwLcGWlYs7UeGxVFmmXsbSuM7TB+XlANCHRkJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+c1e2cpRG/5d5T/XaOA7rDB2VVNPDwfHkiUREt4ksk=;
 b=VjkwOgcvysCDWLuNxgCzq0ubkMRxnIwIewpQ2f27+EQIb8evJd16xbcTk1s5M5+vsFj4cZwvNVS+KDu6et40dPBW86gfDQPNpp27lRtHlm0n4mcDcbu0pHzoIDzWLmCCwG8jowdhkYRitwkigX/Z/Uwcfq3UIObyTbxQHvbgoUvC9dONxTOf6fiUmAQGmhmmfMM5LZFQegmMKRa4gDct1PMzALGttt3q+LAvSVzpI4di9DVWsFRgS49AXo3BPH6iHW2VRV08ePuxxyUcE95BDkxTZEQ8hcUc51XMoZo4RCslHmqlbXUJQcQVXPt/PBlsRrYXVJl4ylWDvqydncI3nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+c1e2cpRG/5d5T/XaOA7rDB2VVNPDwfHkiUREt4ksk=;
 b=kZn48lWAvGOmUoMTxJDL8zuHoab6LETwXkTelU1fyEy6nuPmLpPQDn9/2l5D4CecLugOk8p7OWs+mI42n+JD+7BrFR2LNsZC6qY+eqy6Ma0gRiDyNvWsuYpWPeOfGCTneeCbWtMdyJkttLrVB0N+EwEV2fOsZGVbkNfh8RpDyf0=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 10:51:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 10:51:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Thread-Topic: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
Thread-Index: AQHWsIORA0PhHKt4BUWPz2Nre8xYCKm1TgOAgADvY4A=
Date:   Tue, 3 Nov 2020 10:51:00 +0000
Message-ID: <20201103105059.t66xhok5elgx4r4h@skbuf>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-10-vladimir.oltean@nxp.com>
 <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
In-Reply-To: <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c2aed69-b19a-45d1-b219-08d87fe65a88
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-microsoft-antispam-prvs: <VI1PR04MB48167625994381A71A000D3AE0110@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:352;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: isaK/IV7m8gnUEyUEHOtQIzpSuQ02ET+nA23Oomonbtku42lHx5ccOtMLB5bI9eAMGGIIWZ5xbRvIUC/Lm164kzkDonlxXUfU/4boXJqa62lUXxUWuLowRcQt7kwXz9eMtt5WVGUAGiI4wDutqMf8a56zdAasib7tcMgZ9cR1fiY5KXhDtfGQn82pH7mdICFsgIomkQEFfbU2YAwI2e/yspyQXtOOxOFsoI5MEqs1GJh65A8TDKgKKgGCVplSu/fIrahuyKZ7iVzcMmmKgPBFu2TRDyqX69KeB692HdQq6eZ2ILYgHjDsCrUF7oBy/ko
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(136003)(346002)(396003)(39860400002)(2906002)(33716001)(8676002)(186003)(5660300002)(64756008)(8936002)(54906003)(1076003)(66556008)(66446008)(66476007)(66946007)(76116006)(91956017)(44832011)(71200400001)(26005)(6916009)(6506007)(53546011)(9686003)(316002)(86362001)(6486002)(4326008)(83380400001)(478600001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ORi9DOlL8WHkJMxGNpUgO50Z/WOdhx/1mL8UQoFfmWbQFmGYxg6b7/pV6BNY8NZjKzhcNt8+/sZNAMPBPRqK+lkEosm0wyew/vmm6Y8unQN6U5I5Fb1PFrOiIzdHbnxQOCAbaXef0oRFnQb3RXP76YNKsSRhDhm2BF790sgrg3tU5jyV4uaKxvGur473ym8nNXP92Cm22RRa96e9YdF7uKH6TJU1/PUbLwcBTqmXQ2bYOGZL6PFtZtj0BMCrCq1gZPOzC0ImCcWXT6QPSQUev3PET7+TwGM78BdhIhgC304fIaTJflEOoL9VmmHxgFE7qu3eET1kd21owzpGVkl4Q8HAvPN01AFkZP2NmuVaFsfGO2DOWXjJS3zhkiU0tx4iYdAVeYRsSvowxd3FklGjPU06MKI9JDHLZled5VfBDdW/uYGhcTsZ2Q1sN+U1Pb2kZr7em71HSda6jIBQYYxyVyHOE17BHzD3bFHEqFDSmP8ILMZzE4anYqY2hlXSC21aFZFppLUhTVedZWp8IL4uzApzq28HhCoMPfLg48W7SodoSSbxKm1KCe3ljk9YRvZGiggTLTamBEXH6KqYavgz/jCFlwwxGkmgfdz8jsqyu3sFTiK4liVfKAEnibCwPe/Flot3GJ8gBDXawb4rh1JxnA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DD3E0371A3364246A970944807A33046@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2aed69-b19a-45d1-b219-08d87fe65a88
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 10:51:00.9799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UewJF5RwT8HIZP2M5B2TU7wUirHtCwWUWa22LnCwBQ8g+RxP5++siVfpmu9fyKhx3cW+RfBp5BxNjQ8Pi04qig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 12:34:11PM -0800, Florian Fainelli wrote:
> On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> > Now that we have a central TX reallocation procedure that accounts for
> > the tagger's needed headroom in a generic way, we can remove the
> > skb_cow_head call.
> >
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Florian, I just noticed that tag_brcm.c has an __skb_put_padto call,
even though it is not a tail tagger. This comes from commit:

commit bf08c34086d159edde5c54902dfa2caa4d9fbd8c
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed Jan 3 22:13:00 2018 -0800

    net: dsa: Move padding into Broadcom tagger

    Instead of having the different master network device drivers
    potentially used by DSA/Broadcom tags, move the padding necessary for
    the switches to accept short packets where it makes most sense: within
    tag_brcm.c. This avoids multiplying the number of similar commits to
    e.g: bgmac, bcmsysport, etc.

    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Do you remember why this was needed?
As far as I understand, either the DSA master driver or the MAC itself
should pad frames automatically. Is that not happening on Broadcom SoCs,
or why do you need to pad from DSA?
How should we deal with this? Having tag_brcm.c still do some potential
reallocation defeats the purpose of doing it centrally, in a way. I was
trying to change the prototype of struct dsa_device_ops::xmit to stop
returning a struct sk_buff *, and I stumbled upon this.
Should we just go ahead and pad everything unconditionally in DSA?=
