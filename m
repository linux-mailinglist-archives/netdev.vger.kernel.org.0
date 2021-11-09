Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3B144AB99
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 11:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245361AbhKIKhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 05:37:54 -0500
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:62272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245347AbhKIKhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 05:37:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lhq6URG6Xbojl11wzPZFMwf0N+QWdw/MvC8J1AApv5V67Z8kFFxmdQ+GwmvOBu2X3RePaKgOAC7WKIlf/Co5nVpWmJYLRraEk+T0S0ciJf0g/+AqaMDuYxtkPANwHC7+JGPRt7bmMFTHlE6xpNlJ+/6zFq3Qs7ErDmb019RuuTV4LMv9jtxrA6MEOm7tRgtzm7002KW+O3Wj5hd+HGTyhgbr3YyKPZJdv8vPSbGpOD4kqZ0tPB4hMFHjTiDKXsm4CjppXwmIrZ2iiimbbtKwmVmT2WeH+JvEBA3/SW43ELcoaGG3sbNvmDAsD8i+REgm6po3mhyeaqCDPUzfP57UGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6HHmgsiTRMS/Us6oaYcxSaSqNDlre68lOtWZRNuewo=;
 b=DT0BHOuMVuqjxsd3mKW3HK40Zr5zygC3MDgkEj/pcJROk1gu8l1hY0PLhn6rf+Vl/MN2xQjMZAvySeAQr+u0wP68vTr8Aye23S19ZJa95LQCuX54sfNjJPCOSVWtyJhNMJHwPnHaNRQn7zu0Ihs+iLURYQdDMPl7AcQORPAFdw1SVDdpxWkYzPW9cajHvo/+HhgMF+KAiOPfli1bU9BevILfs+wTPlw5rAE3+FxEBNR0GOX/E8AxfAaOsgKr9QoyrPVTx9c1/lBxljy7huqoCjnseIVa/2w+Ez7ymjqTY3WC/uSQTTqVf0Ak5v0S1IKsgBuY8ma2nKWyecQ1GTzcVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6HHmgsiTRMS/Us6oaYcxSaSqNDlre68lOtWZRNuewo=;
 b=GKg9cdkI9Mwk/Fw4iSvZRQldpNFDBJzbw+fi7nzhJcTeVRXsIsDSsmut4jf1VmkL3orVvNy3ok4mYRYtBgFlpfiTBolBghmM+3FjZKQuJ8zUVaA/Pfjfq+fYk+ahyUbDs6XTv6KBae3D6EJitG0FuCRn69GWYfegtYGE7MzfaxM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 10:35:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 10:35:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
Thread-Topic: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
Thread-Index: AQHX1N9HLp/45dXZAUyXM5qWRykZXav6262AgAAlfgA=
Date:   Tue, 9 Nov 2021 10:35:05 +0000
Message-ID: <20211109103504.ahl2djymnevsbhoj@skbuf>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt>
In-Reply-To: <87bl2t3fkq.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0da6d43-92a7-41d1-6b46-08d9a36c982e
x-ms-traffictypediagnostic: VE1PR04MB7216:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VE1PR04MB7216719F387E826E88E1726EE0929@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IVU/MV2NmVXY6spkiU6dEa+vt4dU1oZLjbo8B6UeUlZ40d3Lo9U0pzvU+uDzWKKIjXDO+6oeGeMdOlX27b3DOCcEZXbcp90tJdQGolfNfcMfNjY6QeA7zlX7KAtVHztwe6eSDPZyl1NxRlLrP+Ipwy6LrIrIL/FpqlujVUcl4nswTTrwA9Jup6Yta6C69qv7JkCJmQGp7/5hrESSA/RhDm00B/5hMao7+K/XCFTS0+7JNOFPDCD02bSpXggCu5LjTYio1EosGzMGjLC6bWVw2ZS9WMPRk8SvEfWEnhdyG6+/QwJ6o5/H0RdJGyruN/wsz45ZSxlNmjz0qRYhlaWbog27wr5JQj1WiLFWr5NTJSJoGn/9R/+NlQWDnzQXjoONB2nLwuqDu8HfjJz9y6ulxoedzxH3I1o4x5mXX6HtZ2NC5x8tmDZEKTHPsMT+Y2zE0wAm5k0gm/zxrUssAdhq5LUtvcfUMV+eA4iUYDYcU89rPr/0tJU2f49y1/c97Yc1sVzXyfvGnDXYx3UD/As3k1JCNrL0D/ZSgHOKiVVYPXuLSdkcFall5hPytcLEUlc5qQmWaidDidUhMaQHyszqrkmaJok7xSITeBqIrrpJy8ePkbiqNvdzcx6boQK6feKrHvFFTr/HTW8oi7MojTmDj0qCbaJNQV89tr/wSsgxJYNnOfeRXYqmql/dMfPwsuRc+SmqioyWCovFFyLcM9hgvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6916009)(508600001)(6506007)(2906002)(83380400001)(44832011)(66476007)(66446008)(64756008)(54906003)(6486002)(122000001)(38100700002)(33716001)(5660300002)(66556008)(9686003)(71200400001)(38070700005)(66946007)(4744005)(6512007)(316002)(8676002)(4326008)(8936002)(1076003)(186003)(86362001)(76116006)(7416002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GkMXd/Za5lL9rk836MnEB4zkDzt+qOOqXa6uwCaJsOZr5ZGI7X8hz50rl2c4?=
 =?us-ascii?Q?v28ftcmu1g8NC4NAFMwAnK9hMiemBjjxyE5OeVtbsKA2ds4Uocxmjt8CH4su?=
 =?us-ascii?Q?fiWSrzs8VZmecLnhEZSNtR/QaH5nV3e6AXrbJUMqES0FO1C/YlPNtGFCBj+9?=
 =?us-ascii?Q?CBFYau7me4VolaVByy79OsKGdxchRkthPJlAjrBHlKLD8ALVBuqlT/rpjtmc?=
 =?us-ascii?Q?gI44WBwM5P53dztXkb3dMKuOSQawTPVacxVilsQBjUS7laAk4fLuN5lYHp7X?=
 =?us-ascii?Q?EbOWK2tbz8qUUbP13gTNeqReA/Obol191AV0kPY74e6g8V5/37RQEPR7AvZ3?=
 =?us-ascii?Q?LJW049OIeYr1Otft3C+FZXeRyon0PoubsTkAQC7CDJwpGKtFEem3ZaM0Q/NV?=
 =?us-ascii?Q?gn+kVC65UixovB6hqGkUhd3w8Cttx4Gu/tOoWgvYAfSN6Hdgjf85j7No6MPC?=
 =?us-ascii?Q?7BIxobwKE1PI1BSRBIlC3Hqb0lhYs4fkHphaQcCfiEL0krBD3CLZrUivcwVV?=
 =?us-ascii?Q?xe2hyIy+o7vjdLO0X9q7NLhKPlaOqupCiyBeWpv1GF8P2SfKOMnw46NZ8jbT?=
 =?us-ascii?Q?HyUkAwuUU6k/gmtRTgm68o36Vv5yp/hg2OilBq2rJoIzK1JJ7AqK4vXpT3am?=
 =?us-ascii?Q?GQDFUO9hxw0f5182v8AER28xpL2HYhIP8fx7ONS49ChVWQBx0IZphTikg0WZ?=
 =?us-ascii?Q?j2jyDK5oUtP8ekWxujdcmtvlyKNY66g5tvJPvsAHhhcAJIZRc54lA6pOcHwv?=
 =?us-ascii?Q?yqMuUKKheMqq0fyGA0rf//BK/PySQINg5IiB2jI1XtlLmZU0vPyMqWWYnzn9?=
 =?us-ascii?Q?sADhLlcOenEPerRB+NBxPHeXepzdRMkmp4J2KftdirVM12Tjo67sbHuiYyWZ?=
 =?us-ascii?Q?C5Osb0PrIDmEar9Oa2c6Kz2t2XQWuFrapFhRJKFUDB2e2Hx1+oik6CbcnHjK?=
 =?us-ascii?Q?4XmkYJIMkiAQnTx3a0sTlJ6Xjx6wWnA25GI+gXga2YnZZgDN/jHJMtgilDgR?=
 =?us-ascii?Q?i7DovSrekVCdkibXu9ePVtTFK11Og3fOuOOYOKEtCF14rQbvLEGnxsfjdqOL?=
 =?us-ascii?Q?YVxvxMOz+Y3LD26S3jiK6gGAk6pR2w52/X27V/G61GNwjtb4blKErBGqvuh+?=
 =?us-ascii?Q?PaUbq6FP7yN26zpYp/AMRgwt4xO2cDmjJVCBKdyb7feNiv6HU2fSxoUB9Kb5?=
 =?us-ascii?Q?gx0bgj14e5LOmp8XiXxGrN2O2T7JnOUXiqeTAaQ9LlDcvXhFfIugB+kK8rU0?=
 =?us-ascii?Q?z2OiTCDk3lcLaNynpRsE3mv8HsSMitebxk/X1l6Ne/0eGpFxr750jLgcZc9h?=
 =?us-ascii?Q?RAWoZ+pd+WXFsJCkmycpBJW1ch9tFkDGNF6UPxczMbn73XTJHHScRZk1Kd/i?=
 =?us-ascii?Q?SJl1cmY4ZjVHjxnf4Unj9W51BQfKd+AcVMcu+l4bBfEeXqxSr7khy6oSJeRL?=
 =?us-ascii?Q?Tb9ynlwiSAlnmxp40SCQPBn0/ohrzRX0ptdmSm0iROFyyXM2OAGHA/7rgT4M?=
 =?us-ascii?Q?5yyOjjwkuby0ENaJ91azly8x5q5WzB6lyQ8+sUBnji8bZZUGYvMEyLbQEGai?=
 =?us-ascii?Q?6I5AIVOJKGU6qrLDQ0BMeJcwnwuf59iJuYMz6S52nGTOLma7UEHof8gqQ7mC?=
 =?us-ascii?Q?nJOQxPTv1n/xLobAwz3lJec=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <454B2C1895498F429D0633220734591E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0da6d43-92a7-41d1-6b46-08d9a36c982e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 10:35:05.3221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Dle7zr/4Nmw2OCezrwWZKQPSvG47c2f339VDMyQx1ZgIKFp2fBJfNOKqTu2AdBxrAQmBYbWh4x7fG/ESzn/Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
> Hi Vladimir,
>=20
> On Mon Nov 08 2021, Vladimir Oltean wrote:
> > Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
> > base_time is in the past") allowed some base time values in the past,
> > but apparently not all, the base-time value of 0 (Jan 1st 1970) is stil=
l
> > explicitly denied by the driver.
> >
> > Remove the bogus check.
> >
> > Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler =
API")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> I've experienced the same problem and wanted to send a patch for
> it. Thanks!
>=20
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

Cool. So you had that patch queued up? What other stmmac patches do you
have queued up? :) Do you have a fix for the driver setting the PTP time
every time when SIOCSHWTSTAMP is called? This breaks the UTC-to-TAI
offset established by phc2sys and it takes a few seconds to readjust,
which is very annoying.=
