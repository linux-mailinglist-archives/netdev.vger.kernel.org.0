Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213E280B71
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgJAXwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:52:02 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:13901
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727017AbgJAXwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:52:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW5lqDHab04JOdbrzOkAsoQQ55HE90k16J6Y99tgA9hFh5fAXkNJG2OjHoX78QFW6Okk1jM+qOMLWAYm/hzD7qT9DxxkZRamnqS9vQec6kA6umYWHveYWnU3F3AeqULBgBta/OmVQ6VZ9x5TUeiakVlgMEuNRx7Jb9nAiNaglCJONdDgZlu4Fem4UB2KGgz5PP3Zez8aI4NkXSoiOPu+4m80FQVC8nciKlgQeQuU6HtJRJ50xCiuoSFRnUWk5S5jkhcjnqCgoh4Z0siJHLcA7o5oFTqEjer/68KeU8gEXsUYssgO7pTuCbCOc1gaohzJ0JQCeHCPPA+EzzOffs0+Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDcX4FwocfEgtRJHvKdMqrhQDxVurVXetPPET8lEvqY=;
 b=Sv/lcK2fcNIR5jXw5gPGQIEjX+/kAB6FN1R3yxTi2vgybevf1Z46YDxesor8N6CyAxUx0Gsd5JNMv1AF/LkQpU7XP5ZWkITJmkmcV4KQDbKdNt/ZYwFR0a66skGNm38xiv0Fohs1rOp8HYqEo9Dzbfa+kR0Ny+k8jUFLhTlyJdzeEdC68woHTJNP+nAUT+T/1vFoQh2zkQ5XnmkhgG7QoB7mBUwlUvVtxIqfkeQXt6cmHG7aSqh3QLTcK8FFvBzJYGLsiwS1gLdtebkTrp/jwJhUpqdwyMjWCczTcADTY/ctXKwXmfB30cGGMIWhUk1IFUgqQVioWrgn8qHplqZcVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDcX4FwocfEgtRJHvKdMqrhQDxVurVXetPPET8lEvqY=;
 b=LyLPwyYNtsukuzECdMTNG6ZZvyW6aW45Rzo6+uXqy99JPv+zURivpwg5kiE5oAQxyGBhZf0hGhIi87XUZGLzvlgxVx8H2/3++kIhAwuzQqHivTyYQXL++dtB80RziZB+VBjtmBZu4HRnrHP7NGDIwMEvESmTCXBjio+KPCPGP6s=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 1 Oct
 2020 23:51:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 23:51:58 +0000
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
Thread-Index: AQHWl5/dhVmGK5kbOEm6gGxCRTuWC6mDZKQAgAAG5oCAAADmAA==
Date:   Thu, 1 Oct 2020 23:51:57 +0000
Message-ID: <20201001235156.qtaftzw7oelfucci@skbuf>
References: <20201001030623.343535-1-f.fainelli@gmail.com>
 <20201001232402.77gglnqqfsq6l4fj@skbuf>
 <8610459d-3700-bf80-edea-c9ee24b38bc2@gmail.com>
In-Reply-To: <8610459d-3700-bf80-edea-c9ee24b38bc2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: adc0601e-48b2-4f0c-ad4a-08d86664fbca
x-ms-traffictypediagnostic: VI1PR04MB5504:
x-microsoft-antispam-prvs: <VI1PR04MB55043A901EF8653C0C7AEE04E0300@VI1PR04MB5504.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lwAzXHTcSzJaWcaJUitvQQL+NLgowmGYrsqtDQN4zkpKJ15d7MY7w+sGEoKASdfnt9PspqETalnXe6m32qlj/NlPDzevjuzsvB6NwSuu6G+JbEAqG+3aM8QdZL3OqFp6iqk1LR9jpTc4KPOIXnrN8GPBatufOAUovMArcY8IEzcLWFWihWjueaP5Ogp6ZaQCbysQPxwMonDotf757JqZgydcvdDRIYEjvkxTiKHtHcnIA5YNpKBu7jwrLIc3VTH24HAcgeDNqD8DGrUtuLP9aJZoOkR7kghO4ItBAfUX+669zqhkuUzLCbwgIaWby5XIH/lzsoowlfERd7IdXuM1UwKlwZIr3iJ4gcWAsg0zUvcgCB1zOfg8KcDfkL/thO1t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(366004)(396003)(376002)(346002)(39850400004)(66446008)(66556008)(5660300002)(64756008)(76116006)(4744005)(6512007)(316002)(1076003)(9686003)(91956017)(33716001)(71200400001)(86362001)(44832011)(4326008)(26005)(6486002)(54906003)(2906002)(478600001)(66946007)(8936002)(8676002)(6916009)(186003)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MbmEKHuf1MhGDdN9jisgJ2MiI3IrwP9nOuZ920FiwKmDyZeSNIc0/7eQyjWegBTWb0XBMoZuWM1wrafnoXolzdyt+WWKYpA27Qrl6tjKY6KWVDr13cz9Wl3PONOTsIbWp4qoCEP2TxxJcYwgTDUezJd9ezjCr7fGI7WOubQ+DJR4hno5IiZKkfzHJ8F9aLPMWkzdLHuE235zlKEoRG6NOJh9V8SG3MNdNGAnKjB5oqSPl9OO1rKRsA7pWURom7izsw3ATF+SVIZGF4zTL7D4UcSJyCB/TjxJ/BjGfK4wyXsd1/Kaw+YWOpIWlkJ7BXFB5oWVTIx0gRCVrs3GbrURLyWkee+rw1JHCVN9hTftQZE+KkHllsP1xlupo5NqkoLJ+1g1OulZa8yDwxB9ilyKMmaRI2eoniC2UsXJzbw9vP3DjyHCaLEpV11KfBts61PGx+D7AMI3X+3TQL6BAUHqbSx9LH4FCYp9NQMm9CjhQBKnU66vw+yeMARb/uD2D0H/C5aRiIbSA8zvm6JVCWK7UJE8SBPvnlpfNJ6cdFkTcX11NnUYqtV8MPzdeEVNRWPxooIgyYdnOOe4+cttdaKB5pGJmnX+NX1+pHZG5GB5ICznrtHw1DTsT5sZQV232dAPUelGFKuA/nOOl/yyVoSGnA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF6A0DE4AA061641A9FB4024B1639AB2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc0601e-48b2-4f0c-ad4a-08d86664fbca
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 23:51:57.9002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HRAXMYZgix9620ShI7cmSsF9lluqK92gRL/gvEHZjb1J4ysMPz0+J8NHqr/VrjQFH7Mm4K7tzrUsUEzdAf732Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 04:48:43PM -0700, Florian Fainelli wrote:
> > - move dsa_untag_bridge_pvid() after eth_type_trans(), similar to what
> >    you did in your initial patch - maybe this is the cleanest
>
> This would be my preference and it would not be hurting the fast-path tha=
t
> much.

Ok, let's do that. You can also replace the hdr->h_vlan_proto with
skb->protocol in that case, and remove this:

	struct vlan_ethhdr *hdr =3D vlan_eth_hdr(skb);

Thanks!
-Vladimir=
