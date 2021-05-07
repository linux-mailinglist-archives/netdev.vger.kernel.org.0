Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8B3764AF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhEGLto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:49:44 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:17888
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235328AbhEGLtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 07:49:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMMKUa5r5fZrKOkr8p0LjaO6qBjAN7Pz3sg1xxxz/m6TqYj+aw7s2pKpzpQFeItwHVSN0T6AkUgeOH6kIlTXOAiqbQ4OkI+EVX44rqIm2A61fW0wU6PpRRk/bdJbO9a/ZTmysaKf+v5t6Z/2WP0Rv86l1uGpt99FF5PmFxL4/+MePflMcz3B27PGrPbRiDvWHJk3LkMC+tL1L7FIzBkoL3gggOjzVTrJAAcBFLh6OGU1ST3EVNEjO9zkWZxZT8XD3YZ0Zsg2UKrfPCQibxDGFHXwTSbbJ/pyHCoY6vEau1fd94iZ2vQQvgA3bDai803yo4P2gOznTGuGrCSY1qxFMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01f437XOs2KyHgQWDEagqS5C/UDWO8zr6WF743JjPbQ=;
 b=bJ5yq/s93fHK9ox/ld05H8/cPTeryRs+Ex2vop3j1K4o94Q7pjlduTB/VDMSNe97DxB+GiKqJwjTJUxbIYSewHtBWvxs1XFnqKTL5Kri6FjNKFTmROTyvZGCMESlIj+esJW5ihc+JiqeZ7ewyBp5h6gMg6KeXM48OYvovZLI4IY3/siEkCWXqQAh7fZdYV8Wr3rz4g/wH1Ekvx93TzOs60m83bM1RbCWY+zovmnfwNVIi/wwJkplqCSU+BYmS1efLjdoyAJ83M4leDMr1nmhse/2wgCba6FlrYBZYVuceNHQFBqvqd4wliz9uBMQwqnxD8zeWVvYZBjANZxrtqPfbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01f437XOs2KyHgQWDEagqS5C/UDWO8zr6WF743JjPbQ=;
 b=TKcenVuJ2urCyfRyqWTaV7vL2XBV42fFUNUvjWpo7TX4cLcKTjdsxeWrR+NvMZEJ7+P9kP5OTJh3fbnEMhQDCGVVbWzfSkhJ8ZhfUSI4xImq0ML8y+k5tABCzClSWxrjYtttyffSWs6a/hWy6xeuMHFjI8yLkEYqgsz/fRKEAYY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Fri, 7 May
 2021 11:48:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.4108.028; Fri, 7 May 2021
 11:48:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Topic: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Index: AQHXOn8JAwAhGEvKKUeIpvbpNi0+oarKZYAAgA2NKwCAAAYrgA==
Date:   Fri, 7 May 2021 11:48:37 +0000
Message-ID: <20210507114837.aybpln6twhstelqd@skbuf>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com> <87y2d2noe5.fsf@waldekranz.com>
 <DB7PR04MB5017DD1C470A06A66ADBB5DEF8579@DB7PR04MB5017.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB5017DD1C470A06A66ADBB5DEF8579@DB7PR04MB5017.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.127.41.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08e510c4-a534-466f-bfc6-08d9114e0d81
x-ms-traffictypediagnostic: VE1PR04MB6640:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6640881FFFFE0B18FDEA7247E0579@VE1PR04MB6640.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0sUDGPwPEx5EqbtTPLCNYf/Lnvc+3vVaQq/Qbv2lmmpAXRa2y5qsQ54NjFJbhuLZ3ak7RKQyX4VkawCDrpRyFPbqKk8FZToe/GCIJXva3pQdMnQPmJy8lIBOTAawKxDg8HTSSl15YxLVXvMdzhZ4lZCUYuA7lO+M+5HAJ6dxcZi+cSZgp6gYx8mvROUk+/OuKz0hFLBihkZA71ZDB49/ypGvDeHTuC+5n7LhLipogW5tuNPSeQ4Z8BlRg+3PnH6MeiBH/s6ObYvaW4aYemqc1qjFT3NBdH+Quoihj1f+isaeOdPCZ+vyYlqhG7ZEYCNdrDZIdoPdMoX79Wy3ezms4zmpGB2Sycubpu2Qh2z0KxyADOQsbwVXQ8ZeQqgK0bTkZrO5VLkAwXFgxGNxP4rLR+RoxnnztsedF9QUyofFxyA4jvUEqQkCPHL+5T5CJ4AHLdILbrPbsaKBGA0XjQGiFzemEJhUyyGnX3ra+JuJQIBSkTAZhEY+aRX+ic9pHeLD6YK78Ja+YYsoSJJIbxOeGBjraBgMyP736F4+s4D5BXxePY8TzMvqJg6GIoQVzyiNJHGb9C4IY0sDjW2nIcgUJjUopoCmxy/oFWCxFjzZxn9iFhVGdFsBEX6l5bWkGMScuttZLY7YOf3kEaDAX2y6SOSQvyONMSAeeN2mWPSYm8+DuFzpfxRTu1Qc1B2Ga96k
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(64756008)(66556008)(66446008)(6512007)(66476007)(66946007)(76116006)(86362001)(9686003)(71200400001)(4326008)(54906003)(33716001)(186003)(53546011)(6506007)(316002)(44832011)(8936002)(478600001)(966005)(6636002)(8676002)(122000001)(38100700002)(1076003)(7416002)(5660300002)(26005)(2906002)(6862004)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ry2F+RTqwKoGUs4iLwkvEz1YwGM82SD/lkarUrtBgGHSucYmfcfcP5yP42JF?=
 =?us-ascii?Q?rV0AFha2I6+495nAkx6VWRm9SO3qvlUbwpWTihO7yS6O2XaqVkdSXyHFkse4?=
 =?us-ascii?Q?jh2XRJz6APhnk23oQnffM6Va8jmsTN1TRn62Oajbp4MsAWLFSOFvDvJOdIe2?=
 =?us-ascii?Q?Sm8RBthih0U+GTDnQBLWezZolqqs7UOrXHkJx+0yFr2tk/eWBMCY7znSFtMo?=
 =?us-ascii?Q?X762G0MKGbsf/xTgwWPEvI2KXmDSZJ1zJNoSzeVdpDVRSlHmMlooTiFQkTDx?=
 =?us-ascii?Q?jqOBSVtcOQLYzLJPGtrAoMeB2HlmDYDVMFBm9ATujf+UmYpMXgtRuJ3x/0M/?=
 =?us-ascii?Q?C/0Vt44CKnunM6Ve4YZIVAUhbmziQD+1x1rsOP1Zq8oMS2vZDT4dwwvn1PZb?=
 =?us-ascii?Q?84nOlX4pY/qnXVvJEjtRbzUOcXwIUMaWzMEgNX1sJx48r5NADW9AJzcrfK96?=
 =?us-ascii?Q?5QT+vz/iHF6B/qj/8lB/sUVtvoM31shFtRgbquwgcNMtgR8+P1/xABib6vqG?=
 =?us-ascii?Q?IYDyS44cywQIyhLw18ROxwqJD35guZahxaWPgycXiCCKwlzhI31ADx8w5vJp?=
 =?us-ascii?Q?3FFDfdRvycTQUHZ5GiDAope8ISwc3+F7N+et2/W3pw8lxas5L/4abSlMXgss?=
 =?us-ascii?Q?a8jh3Df6sxCmjkXjtU9ZIfGrxnAl7aNGcGEGijeAOc1f8Q+Zu+fOcv4ME0GS?=
 =?us-ascii?Q?HS65LWJC79vkj3iJpSSZNGjTlKPqRyrUGO8oPWWuWH86gE3+/wcKqiBYQ4pb?=
 =?us-ascii?Q?BIm47nZ53u5fBPO3jxt875L1qtive49YNmlxBYdX/bOCdYZqGOD1uCI5XVWs?=
 =?us-ascii?Q?TtodQDvlZ9Ca1fAz23WNLowmn86E4lwDWhLo9SRLoZ+mcJsbaIcJ0ZQVICnO?=
 =?us-ascii?Q?uk+z7hM4nRvkH/spCPI0KQtte+YemfctH4icGEoForwFaY24gij/Dgoaglz+?=
 =?us-ascii?Q?vLulbPWWS2j5bWClxR5Lt2e8Ua+p/prwiFK6Mc3MTKPOaEyntdWuPTKRMypL?=
 =?us-ascii?Q?IhabDnJ8UxiKvtrApkOnFmXnJgUTRbjL/D72456CSPc0DaQp+yTTgqhJGb8s?=
 =?us-ascii?Q?C1AGF0j1H+FB38RbxFx8GhJKEf6iWpt6Wx2GMo+C3Bk0+Z8wROibrVA9rFaT?=
 =?us-ascii?Q?rBRpM+Q/X+Ur3EbfhmjEcpZvxfxOzM85Mel7vfmSOqUJxcEWon45VJdsJiiH?=
 =?us-ascii?Q?jRWD0PcqiobpSdAg9Ns+tXKbb7p2rRnE8sixT8PtGckLK0VHd9R1cTKLYLYY?=
 =?us-ascii?Q?qCZRyUnaRSDJ0+kMD4zlzWjbhPBjaW48rr8He/3gAeSW1df1Av8z3zC40jhE?=
 =?us-ascii?Q?7QcXrvQ3tOxmxn0E42AvAtN0?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCB6125002829E4396D20FF43E7339DB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e510c4-a534-466f-bfc6-08d9114e0d81
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 11:48:37.9645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0iNzVljQ3Qm1vxoMENrOTVNv9lBi+eYUJjm6N9x9SS5swcRw3OsV6RPUBf10WPck0NVw1nOefU9vTqgwX33Qbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 11:26:32AM +0000, Y.b. Lu wrote:
> > From: Tobias Waldekranz <tobias@waldekranz.com>
> > On Mon, Apr 26, 2021 at 17:37, Yangbo Lu <yangbo.lu@nxp.com> wrote:
> > > Free skb->cb usage in core driver and let device drivers decide to us=
e
> > > or not. The reason having a DSA_SKB_CB(skb)->clone was because
> > > dsa_skb_tx_timestamp() which may set the clone pointer was called
> > > before p->xmit() which would use the clone if any, and the device
> > > driver has no way to initialize the clone pointer.
> > >
> > > Although for now putting memset(skb->cb, 0, 48) at beginning of
> > > dsa_slave_xmit() by this patch is not very good, there is still way t=
o
> > > improve this. Otherwise, some other new features, like one-step
> >
> > Could you please expand on this improvement?
> >
> > This memset makes it impossible to carry control buffer information fro=
m
> > driver callbacks that run before .ndo_start_xmit, for
> > example .ndo_select_queue, to a tagger's .xmit.
> >
> > It seems to me that if the drivers are to handle the CB internally from=
 now on,
> > that should go for both setting and clearing of the required fields.
>
> For the timestamping case, dsa_skb_tx_timestamp may not touch
> .port_txtstamp callback, so we had to put skb->cb initialization at
> beginning of dsa_slave_xmit.
> To avoid breaking future skb->cb usage you mentioned, do you think we
> can back to Vladimir's idea initializing only field required, or even
> just add a callback for cb initialization for timestamping?

I would like to avoid overengineering, which a callback for skb->cb
initialization would introduce, given the needs we have now.

FWIW, we may not even be able to touch skb->cb in .ndo_select_queue for
Tobias's use case, that discussion is here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210426170411.1789186=
-7-tobias@waldekranz.com/=
