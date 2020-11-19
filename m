Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB4E2B93EE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgKSNuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:50:54 -0500
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:30654
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727285AbgKSNuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 08:50:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHsb3cpNU0pvuGYn0Vsv5xqANs9wlOlrQWQ+zpa0aXstvXCVJP+ain2YKJtIMwWF6FAgrquWF0PVoEr45BvaRzc3ajJIBctf5K/1pJIAJPn9b9gaOvCgcFaB1Gm/B6JkGXAE0p5whSDygiG6b/k2znh4spNb8ytRYx1H+7rxnJ46awW4tMJhKWQafCMVC7/oFIkmU4sTTwbeIAkeMxBaxUgbg2x8CvYEWTZxRJbkevQ6ZjrM3k/uQuInOxaPL3/25oe+fBlkLEODiai5XDpEvV97tf7t+DZdLaksGKwskhXsRbIKWDwaBfo56cKPpPuFhMK3Txg614TQ8sSjPMg88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlnZcuoVlCt0MQsxKHN4gg5e1qWqgIOdE+65Mk6Hvdw=;
 b=DTyz5ZsD7tCJogu0OXqgujXRYCftRdPaHEKNCvxepjeEOBYlAy648CJMqcO1F9pYgbHImOPwMUsT/seNX3cC8a0HqWro8WifIjR73+AVHxFPkB0s74H+fAcxe/SjvR/L4BrNH5QO1Js8ipv8gLGPAVal1ev8ApnR3ZAOCVEJ0Lnd6wfhQ7UxJkrAsWYGnsCaky61e02FuJ88GCJZsALrc6OS5WBqe0Ae7hndz3IIeq3Fc+zB2fUQh3ug2FARxd009Eh3PBtJ7OAUQC7kkv1hvbrfbgJg+Xdn6wHhoPcuSN7ZYXTyezzkANR2OPQOctvl1G1ikSL21NFDsdwJNFJmnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlnZcuoVlCt0MQsxKHN4gg5e1qWqgIOdE+65Mk6Hvdw=;
 b=e1R2tZUoli904eD3UkzuC9mxxuN/tc5b0IoLqwyyA8MXTIct/gqx0VPiUYdFXll3OmxJs3DyYQdB5KOYmBVgOmOBYiqZUkw5rMtXwed48Yy4RlHhCy/3KulArrsfDaK4mTVwEYL5xfnAm1juzGawD67vl5+USLJIip/wGMdWVZo=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB5808.eurprd04.prod.outlook.com (2603:10a6:803:e4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Thu, 19 Nov
 2020 13:50:50 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3564.030; Thu, 19 Nov 2020
 13:50:50 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/7] dpaa_eth: add basic XDP support
Thread-Topic: [PATCH net-next v2 2/7] dpaa_eth: add basic XDP support
Thread-Index: AQHWvCa9ctCJzsNW6U6AL6ijCKrD2KnOm5WAgADhvFA=
Date:   Thu, 19 Nov 2020 13:50:50 +0000
Message-ID: <VI1PR04MB58074E743AF8D28D85EC1D7AF2E00@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
        <e8f6ede91ab1c3fa50953076e7983979de04d2b5.1605535745.git.camelia.groza@nxp.com>
 <20201118162137.149625e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118162137.149625e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd7744e9-86dd-4534-d22e-08d88c922023
x-ms-traffictypediagnostic: VI1PR04MB5808:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5808FA7F3AAD70E238DF475CF2E00@VI1PR04MB5808.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWCYcNA6wuqeeLk8dL0YF7O5GitfubDpG+K0iTxTbI29VIFM9qNavBRUt+AIp73R8YUrrY6noweWRBDG1+E+pFRv3N8JXfy6V0hl8P0c07iSS5o/dHsYqEVniUsH9/TXZDn1tTBrwb4hBKieT7Wb/NZG236EScfex+qsHHjjHWgA/sDJlWDnl8hdsxmFm9Bp2UD02jsJp60GjDRr2CxYJE4Z9mWxHZ5pU6z/UJ3f36qr8s/FBNVz3qkp1b7/G7zRLfQaxO1pwPd89XjSF0YUXP7h8ji/InxCo6dcGLxtRKxFfXXJsBkf/nmh+GhRQ3LJ0SawapcTV91CrKi+swV9lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(366004)(376002)(136003)(8676002)(5660300002)(54906003)(26005)(316002)(2906002)(7696005)(8936002)(55016002)(86362001)(186003)(71200400001)(76116006)(4326008)(52536014)(9686003)(6506007)(33656002)(66446008)(64756008)(66556008)(66476007)(53546011)(83380400001)(6916009)(478600001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sobGz5pffX7niMKhg8bav56yKsHdzlbUtTdKAxq0MQaid2Zkdx5e5FiER9aSKtx4sa1TIQuO3F/DNalTqeXVVL9GX12ruT0msL2qKWhmVdCMo3yrgezbYz4XCeMSaWrBaEM6wL6GIu1ru+YyxLkP+GBa2dI3OLBV630P0Oi112Jhmha9zoe1qHEzCerfokJuKrRLXkCo5vYzL6BP3wneCFVG/YYUE10/8n2pqhWMadqj5koeyqQrT8PEyruwt7r9F2tzXV2D2m6bBEoJeVaGrDnm9UEdGkmHoD84bthgucvYrs+QwezUaaAOrKGFPP4e2jjX3lwyXX3Fq6vDzrMVQG80utxBxWiuQ0fhZFiu0f4N7b9WyPXggdB9KZ7vbDgxbykj9FHgz3M2vl08OZd/32rY6DJ9LopzHQSDSzZsXmmSs66BYtmHAfrvq4yIl1xJl6TlHmtUCJ85N3eIBNRht++bZpx6seY+sFDkkXh2S3Jy/gJbWo/+dwjOswkQAM4wnr58LXNlymxwqxv+e8zYGjH3so3QlKUrCOb5NMYNEVNznmypvaSI/eog0HGXNSC8FVl+5JFFCqz7/udNCtIIzUf/Hcf89EE7bxNBc+EwY2J4PFhl3Vp5qCcnMAii5CyWDunXs2h4JGOEKVs5iEIvMajV4fWvLeht6lr4MW3zDyvkZgLxFQhyNurZmJP+aaty6e1j6eJz9Q6fyEqn87OovDdCrIFknvUCW8qBlnTbYnU6br4jrzau5KsNDtxvFZo1OfVJsRfkVgGfOVXQMCECuWuBbnICn9+eik2s0MFVJ2ChFi6J9llIS8eytGexuMcz16hInyfBKHKPv1M3+UkPpORftpkpKC6S+tI3sSbrwUDm3++BFVYaowdEPCJdL7Ym+A3a72HlvcOD3HjDz9k8Hw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7744e9-86dd-4534-d22e-08d88c922023
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 13:50:50.4507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cIuRxSIKYP8ACGYQJfPLcaLNjLKkC7GPkDP9XVmJs63Y8Q9XbD0wD+y8A0Z8Osdg8gi/KewTufV35WISIQL4Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5808
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, November 19, 2020 02:22
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: brouer@redhat.com; saeed@kernel.org; davem@davemloft.net;
> Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; Ioana Ciornei
> <ioana.ciornei@nxp.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v2 2/7] dpaa_eth: add basic XDP support
>=20
> On Mon, 16 Nov 2020 16:42:28 +0200 Camelia Groza wrote:
> > +	if (likely(fd_format =3D=3D qm_fd_contig)) {
> > +		xdp_act =3D dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > +				       &xdp_meta_len);
> > +		if (xdp_act !=3D XDP_PASS) {
> > +			percpu_stats->rx_packets++;
> > +			percpu_stats->rx_bytes +=3D qm_fd_get_length(fd);
> > +			return qman_cb_dqrr_consume;
> > +		}
> >  		skb =3D contig_fd_to_skb(priv, fd);
> > -	else
> > +	} else {
> > +		WARN_ONCE(priv->xdp_prog, "S/G frames not supported
> under XDP\n");
> >  		skb =3D sg_fd_to_skb(priv, fd);
>=20
> It'd be safer to drop the packet if the format does not allow XDP
> to run. Otherwise someone can bypass whatever policy XDP is trying
> to enforce.

I agree on the policy enforcement issue. I'll drop instead. Thanks.

