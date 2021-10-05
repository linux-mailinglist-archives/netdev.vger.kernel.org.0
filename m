Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4077422811
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhJENjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:39:11 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:26977
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234201AbhJENjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:39:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW178oiAVs20+N/fhrb64uzvdACMyhSPIEBCmVPfeHt/uNNqGLq7EsVLhMgDJNJlBXHkcJLRV+JbNX/hRpWsL9wehvlevDMTA+NpseBFaUQVBR6PHunEtjqugtRqu3Y5zV205qK/5A5tz9Moo9v8Fm6RJn57FEB9oCqa2gNiBvUPx8l5sF9qJO6OEMlUkB22WbDJaXcD/B+mwFyUpuxYJSi7ytYhcM+9/9T9KD53rdirZz3xf4SU3bBGdTx9NofSM+c1kBRB6puNbghl0Bsyyw3K9Ih/sfNJaPOmjnpf6tbhUwGGxek5sVtx5yxa0tZWffqXtkBgW/hIzOGw+lzu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V031AI/6vioSVBGOOFyZKM1gug0jXBzs00+PE0UO6VA=;
 b=L8G+nFMyendQ/uQ5Q/iJ8GDOOBIRXX5DR0NeOcnNNCeabIrOgnIq94nN8GVMyA6KXw1QfdVDsUl7GNHHYc2zVKb9vGGsaFUbg7ojsLlCUYMvx7q0SOP4MYN/NPCQY8XtmobVbKYREap7aezvYRWGR06TLmFXW4o9nqQ0bwe/sF1XgnRcFwJTHNpq41ptKAwwPMWD5skBBgShrn2CjyS8/4yP/DvdnBZMeFTDevtPIHSI3FWhDCdAUtkG8bvGn91pijMapOp+NbFXDGRTuozog27B4efRhryD2UXgWzcJc91xIleL5gEYg2imAYytqXRvbj04mxbcws4T0KoYxsZuGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V031AI/6vioSVBGOOFyZKM1gug0jXBzs00+PE0UO6VA=;
 b=Ka9UpEHfeEqty0XAUSbDad5mne4Nbk4tC7WLalhSeDwiYL1SAErEL4fYr2AA8idiLI0nPHPjXXoQ27aLTRF2cBLfMp1u/I8MXBarkBMLWUYXd9xe/R1SQCQnA9b0YkUTcVFAy/T9FX75o5sdIReQURaejuYkzFZecEIwlitcX1k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4911.eurprd04.prod.outlook.com (2603:10a6:803:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 13:37:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:37:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: DSA: some questions regarding TX forwarding offload
Thread-Topic: DSA: some questions regarding TX forwarding offload
Thread-Index: AQHXucaemV05T+14+0C6ajjHlibfJavEL5CAgAAgAgCAABbYAIAAAkEA
Date:   Tue, 5 Oct 2021 13:37:17 +0000
Message-ID: <20211005133716.adna4x6475aiasg3@skbuf>
References: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
 <20211005101253.sqvsvk53k34atjwt@skbuf>
 <f6974437-4e5c-802f-a84c-52b1e9506660@bang-olufsen.dk>
 <20211005132912.bkjogbbv7gpf6ue7@skbuf>
In-Reply-To: <20211005132912.bkjogbbv7gpf6ue7@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bang-olufsen.dk; dkim=none (message not signed)
 header.d=none;bang-olufsen.dk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0582ed9-8385-4de9-e97e-08d988053fd7
x-ms-traffictypediagnostic: VI1PR04MB4911:
x-microsoft-antispam-prvs: <VI1PR04MB4911C0D202F7B14565745AD4E0AF9@VI1PR04MB4911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J6Uohy6lKtk0f3IeBVWhTfYuCYPxA1alaXy2KN1YAhR3OItyVlzMYlJJOUC6R8VxkzuJdu50C/MfQWQpxAV9IAL46uKKK51aVZwemGP+rZYLSqjDfGF3PHypnPrMWfd3G8+d1K4XQZ3AIMovPI0jnvc+Oj0I/8Iz/OfuwQRDJvo85oZCLxlsrmXXBKA0bRaTesNzJR7HYKP2zsTMwl8sKwyK6qluCbOVoiivI58MevA0D6PTOOVrlQbpJZWxFN7e0u1WPt82h7WbGjuXoCbUvem7E9rfBLPR3CIYw2XZRkqdlMoOJLO/PqqdtQc77wEUrurd0OQVzdWNPrBctn6VNmXe27dLDHaehjXeklmnOudTgK/My1TJQQnnMzsNeDp55GvzqS0aT4GkCdhCYFOK1/xBvH+NkHT074ez+luVzcISeWVoAAPy4Eg25J1Ru041xij0+Z1X86e8htOVKJLTM9MxkmdUhGODH5Y9OX8drHk63ouQrtNPp1pBDakhITQxN58bq2faqXadzBd7RWExg1XO07BEFcNPttci9cFb/EQpgklMP6GX10ACS3HrNY87ueLP04RDvzmLpQSnYZconKpYPf7x8QR0cL6ikyqWEERh1J5b2vr50T7udYjJCSYlkYpstzRpZTgdp1bYdeLrLvaALAGgxg9CwGT2JBGZ+uaR/wHrvGAMs8k3oeQ7VpAWcrBtSpLZEK5Z04Z5/AaG0lbWQNr9jJYpVCkT7aS6ijGMr2SagfcWX0gZr/cNYSj7sTfta6PxTSer6t0QusYoUzBSuChiPIAqfWkote9w5e8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(38070700005)(316002)(508600001)(966005)(38100700002)(66476007)(44832011)(8676002)(91956017)(8936002)(6486002)(6512007)(64756008)(76116006)(5660300002)(1076003)(86362001)(66946007)(71200400001)(33716001)(54906003)(4326008)(66446008)(26005)(9686003)(66556008)(2906002)(4744005)(186003)(6506007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?N/lSVqByaJlNQR8jRlm6Njc0NJ7fwaJRIC89Xr4w+ttqSDennUwCcSBB?=
 =?Windows-1252?Q?b/lKhkjck+Or5MH/9go1Cr3EKEqaDGz2wtjMTAVtVIU+uj4vcIS3tNnI?=
 =?Windows-1252?Q?OJeGtBU/xaLdOT6HYejATi9pMBrrfXkKMgmw35BiAxNxvr7gIxndt3Qj?=
 =?Windows-1252?Q?t0K4et9eL1hJ9Z6HuDS4alg3Bl6x+sIG75wmUy6tRVGNqlJSr+qwnwE1?=
 =?Windows-1252?Q?agUeLvtbNOfeuraIRsSbGvQTOj93iH0mg9ZBFW326/nC/7y+jOkQJ95h?=
 =?Windows-1252?Q?cdsMrXiNHMZaA0ZFKEV/ND4pCkEMA+A+slohB3XP6fDhhxb+5TqiBQlp?=
 =?Windows-1252?Q?JjGdm9OmrthCla2/frtGgm4ua/2pZ5bvJ+4mYQqe/E2QWLN2ri9qpYj0?=
 =?Windows-1252?Q?WZlI9/yfa9NcJIGwksK+K6oOJuzfD1duSF+zD3uqZUz391/5S7ge8zU3?=
 =?Windows-1252?Q?W3xTEHwYSgyKi+MVo1rOp+nZtxuEYzfLVGdFFchdRBeFJOQQAF6Nx2C+?=
 =?Windows-1252?Q?CfKcbLgEHmwvGFpotpQ3DxXPhNjs16W9oK/46vE7XqBTeCru625LrXyr?=
 =?Windows-1252?Q?q+4y7gYv17tJbknMrwZ9FVTu1dmV9knfZxPtouWKXzjsV2EOVvRbHq7q?=
 =?Windows-1252?Q?f6N7/xD3yyELE/T7CheFkklCKGxRm9m5f+2D8TWR4/uWtDAh69nOHeFL?=
 =?Windows-1252?Q?LOuNVL+IEs6LjwBMcT3HX84ZUVps5dzjws6uTf2l2GIG/JXtBaZQX7mK?=
 =?Windows-1252?Q?WLTYzoyhuZYsEq1xP7bcercDIhvgBzISiV2bKHz2u8XfGDsf0fiWgKuk?=
 =?Windows-1252?Q?KFFmcP9o4x++FrajXR1vXN7mWBj1/nlx+Yj0Di7yfpgDklxReV+DlVQy?=
 =?Windows-1252?Q?PsrDbB9r/gycYtA60gPi6yqEFUPsR25hkDAPjO0eq8nPNiB5Oq8onbQF?=
 =?Windows-1252?Q?bKVkrhzLHrhg9VW7rcQ2v7KMBKmP4M1ZNilUjfqj/8+GgsYIpFySrI09?=
 =?Windows-1252?Q?di8rDL5QibCOpk72gIOGjRxh+snF69TLioBcuMHhcm1cND8Xeh8IxZNP?=
 =?Windows-1252?Q?eRC+eOQ5QXxqLXPLC9mDIclyaUOuZ9xB0Z2nvLFNJ5CcFQ+6gGqQZl5g?=
 =?Windows-1252?Q?XaQTfpsi7Y4VNKj+gvehqCisxx1EqH60nZCxkTI03alpyK4nH5pMYXoM?=
 =?Windows-1252?Q?ulF5aiA+DzVa9mJo59di18v0IWDY1qWJ/hs/lOeJhPcLJ94JsF0Xt3kJ?=
 =?Windows-1252?Q?SXW+9MI2NETEVLajVsPr9KlDk9lRQDVTCF3kn4hYFBCJ7wylXe9IlIcb?=
 =?Windows-1252?Q?0Ss9PFapS44XMlbpPrX4o3uQXT88qK4GAZ0gXMmwidKvqgA1woChICjB?=
 =?Windows-1252?Q?pacDhezYggZoPTAl7u/gBvqykdQodBwkEwfrEyT5uEmwl69y+dsKwKsd?=
 =?Windows-1252?Q?qkR+5FfrdsSIRmCI2uGE2g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9A57464378DC1F489B57126BCE21274C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0582ed9-8385-4de9-e97e-08d988053fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 13:37:17.5955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Gsc2qQRt3Cm9OjHW8nUbPHUF3EC0B16OtETOk3exvHWme20U6Ye+K7dp5rJm6rniCuq4P++PjtD7kvXJAi+6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 04:29:12PM +0300, Vladimir Oltean wrote:
> Hope this helps and is not overwhelming.

Ah, I forgot. You cannot use from the tagger driver symbols that are
exported by the switch driver, otherwise you create circular dependencies.
Been there, done that.
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/=
