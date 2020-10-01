Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CBB280B5F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbgJAXgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:36:33 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:8609
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726855AbgJAXgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:36:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0Jx3oX8A7u9b2qBRg/TCtPo4R5pfSQFvPr8YmcCJSfubRBh4d98TeLASDvDV2EDXqydYRTXgxU8DYRrZ2tDbDCLf9ICHHgjMm6tZh5L7dIR373eTqdlDQ1xpHC//LexJ77rEMLOOYfOuOnlSk+dui4hng1446CxHlezFIm2iUccLAMnSYV5NrDVoNrNM0RWvI8W7RAw74Qs1sJr7jgFobh9LcfoRKGkfNq/1LFIzrgGNceG7TzjjkBZA0pGRamUP6QkWO/wN0yUAU1evFnuxGYqV5+d8hnY7AuOvof+KnArFg6Esx8Tr8KnVTL9U8cqjr3gXjabUNHK4z/xlRr0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7PcnNaZfexejOJ/CsBt9JlVrT80F94rT03OYSXoGoA=;
 b=RPxsTnVF+HAOwnuSkzTSDEhLhdssaE/ZNtr1A16ojuS5DDgWcGzhuHIXt8kP6l9L+rNOlB4phUupA7c7p5OYGcajoRbm2P/wWaZQoIJ4l9VsPKw/2x5553g1kPLRLkXUF6uhX/HgAKoDQs6N3IS4bo0+/xDlc2cPkgR2/YeIMuM4YWQAteFYwqBYtlJgduDzKjE3kzEMrm9c338c0y0CeHrNdiWsY86fmqH0sW1jIkb+FCwodAA55bthYCqVmqeuFWNIq6b5LaFtfxyB/O3eubSyUuM35owqrmar5Uc+PQQPPFqa0MEoWmQHqKK1y5VR/C0E3ODNEgOJzbEwVliQig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7PcnNaZfexejOJ/CsBt9JlVrT80F94rT03OYSXoGoA=;
 b=eanWqw9LHEqVkiATiRdm4WAPgAqWSkdXJgNlXXL9WIOccSQND/GnuKbNCFgQOKS8Rtkd9QD1Dq6a8CLeqSY7ZW8FpZYnPiH6wT9yEe+bu/83rxwKvJpwr3eN1yuRq1DVdxPM0F5oqshR5gflYhy3wCBshNEac8C+LhBH8aJZJi0=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Thu, 1 Oct
 2020 23:36:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 23:36:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: dsa: Support bridge 802.1Q while
 untagging
Thread-Topic: [PATCH net-next v2] net: dsa: Support bridge 802.1Q while
 untagging
Thread-Index: AQHWl5/dhVmGK5kbOEm6gGxCRTuWC6mDZKQAgAADegA=
Date:   Thu, 1 Oct 2020 23:36:28 +0000
Message-ID: <20201001233628.amqctjli7wblq2rk@skbuf>
References: <20201001030623.343535-1-f.fainelli@gmail.com>
 <20201001232402.77gglnqqfsq6l4fj@skbuf>
In-Reply-To: <20201001232402.77gglnqqfsq6l4fj@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c7220b5-9474-4d3a-0f76-08d86662d1f6
x-ms-traffictypediagnostic: VE1PR04MB6639:
x-microsoft-antispam-prvs: <VE1PR04MB6639D5FCEA4F369B88D489DAE0300@VE1PR04MB6639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rg930F2omVdOyOOjBrvnzFOvAdGCkvFgKVLXq6cwQYe2JkO2J+Ldloe1lzkI4Hwa2lLQCNyuJCPmk6TwUTarsiD9ybYM1MFtA1T1nAlOo+txkBlAXs8lA01sk6wJem2Hk51OurvDVLdJdOOHaNjDFaeDhzmPrPykpsW6YSLBPVI4hwUZ6gYniDHTKKV3mJOIQwtuo6E8M6E0IFFFWWSqcJPCEnTBY1QbCuDo26gzfmrmbcR1M80CWnM6x6YMekltJ2atzs4wlU5MrxJXMHSb9yn6A84hDUijKGID+ULTvzoebRamHo0UIW/Gy7AR4ahjSrzfcDFfSkG9F36Vd2B/3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(136003)(366004)(396003)(39850400004)(2906002)(66476007)(66556008)(64756008)(66446008)(66946007)(91956017)(76116006)(4326008)(6486002)(6506007)(86362001)(6916009)(478600001)(44832011)(316002)(54906003)(5660300002)(186003)(8676002)(1076003)(71200400001)(4744005)(8936002)(9686003)(26005)(6512007)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pwSgBoBEoKNhN0cybsZ1J8LBD96UZBFeKzHeCD5EZ0B0hH/Ii9CAEgoeAk2bAI5byWJtdg8nPtiY8prqsHTpFRzSFE/kiHufvb9Mlq9IeL9EABPttX95R1s+JXYztIiGhsSGv1ukluNg+4x9G8RW9GzzgWBbiL5gkIyS0RCUIYzzCmoDZzaXs2OyKWBPTwWa+TNB7HLLnjbzaPCxJHd8uBIdS9jhYfEh98V5o7vBcfKst1uy0AwJ/qYyziOY3MKfzHNFoXO9RcyVKZGJwjWRCI0YYgNJq2nEsihi6CdJrHwnz3eD+D10re7u2h5YxZeCJ4qjf+Z5Gyp4TtNLUdUDDR9eZhSYX/V4oUyoL3cN83FHaxTZGLk4gDa/WqA4ub53YgQI9wn4FUfHSvxqrcsuT4kHiq1phSVe4VDiLzxIrRGIfVPL0+eeT1ko9eRfL36ceK1oH9WctTBMpeDwe+rdwOfkLAdpbVnXsJ3zLYpHYL+LZxV7p1xYKGjQkNZA/DSDnOd/5O/k9cXKlufT5vmJ0NUwsdw6H36MeRTSbFPYQljSDQ6yhxmRsdWh9QIyIUJqdUnaWYtzwhnODihPT4Ub+4PPPH0xd/tx/VlBVWZm4bMrRd4L3oobRnSu5wZyPsqvEniGb1EEhWxl+qLRXfFaGw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A25A2DA063D99542A8B3402462A5830C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7220b5-9474-4d3a-0f76-08d86662d1f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 23:36:28.7217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t7Ba87WBYP9ivBR27wPQm1tQFlUQ/2YEZYpgiUtYMDQVRAE4cs7sNnp7QZ7RgXoHu3gMtwOnhDULI15SXYt8yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 02:24:02AM +0300, Vladimir Oltean wrote:
> The explanation is super confusing, although I think the placement of
> the "skb->vlan_proto =3D vlan_dev_vlan_proto(upper_dev)" is correct.

No, I think it _is_ wrong, after all, I think you're repairing
skb->vlan_proto only for that particular 8021q upper, but not for the
rest. I think the correct approach would be to say "skb->protocol =3D
hdr->h_vlan_proto" right before calling skb_vlan_untag().=
