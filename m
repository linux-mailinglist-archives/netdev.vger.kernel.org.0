Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061CC276284
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWUvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:51:55 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:41151
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgIWUvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 16:51:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgRpUcmLf757aiHghGXFftaqeyzCLd70gDwkETJWWtrvPvsrekCsMfO2lvESGXS3xDJ8BSlTiHdtiDvGknxO0wrPk6yMzaAQO1U2a8xqrbRQMVy88OxyzMpCl5Z/NCrJK+H1p6ehxA3NTUByoD1YoXdTDCGgggfLkxHn1F3LaUY0Y2jNuf9oSmyQ0GGfOuMgB6qSfMkQRMfWWU2mgKA2WGKlt72ctwPn9s/arIbG+LHE2PtZUr34ZkZ8+W5/MbHgsRqcKjYWWW1WbtzomonASNMFlrSibb0kvftoQcM+XD0ULUiCwQMdGJ8aUM9yZt1rvQfIndwY+nOQwRNYbqJiDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49e7YB9OjsqESSwvGeSLQJAqwvG4aoEyW9GZqPy8lgw=;
 b=jpyfp+ZXI93tP4ejqx50bTYoQTELFljS4YswUkw3azN6E+7dOJtlYRMyLiDX89G43earfbzcIanFhho19A27z0siGWBlLfu68OnhcCP5UgGnaMuEv51ow1GWFEo+Q+9DMTAfO4LESQ5c0T3zC7HL93RM5zzfhA+ORlAYI5sBNbas2saZzHIHfV7S/Vm7d9OXRBZmbI0X9rvBz/d6TRd3MDf1E3pO+ol3u74j9JDdjHfvuuowFb5RJJrKCEBQTNcub/WSxfmgjzC15YSBU4gf8yytku9u/HIKaT3r/Ir0QLUQtQQqKR+vx2czfJyI6duj6LW8e+4wxRwynt4ckziTqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49e7YB9OjsqESSwvGeSLQJAqwvG4aoEyW9GZqPy8lgw=;
 b=VaUxxc7qOm3jypO2iIclHXS4tkGGz4nCg23hA+vlwSDtd3WPnTZEN75RJIwlWCDJnenu6rJu6pGiGBKy8BtPl9tzFIg1hXmeMKJZCBr6wIitettMpl0pSCjaiuiFzKlW0mxkFjY+PI2XS+kgQc7z81REUgqZm9dr7z/ygoGNskM=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 23 Sep
 2020 20:51:49 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 20:51:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] net: dsa: b53: Configure VLANs while not
 filtering
Thread-Topic: [PATCH net-next v2 0/2] net: dsa: b53: Configure VLANs while not
 filtering
Thread-Index: AQHWkep9slBbVOU5dkCcJWZHJ5RCvKl2slgAgAAAiAA=
Date:   Wed, 23 Sep 2020 20:51:49 +0000
Message-ID: <20200923205148.guukg3k7wanuua3c@skbuf>
References: <20200923204514.3663635-1-f.fainelli@gmail.com>
 <bfccb4fd-0768-79e8-0085-df63ecc0d376@gmail.com>
In-Reply-To: <bfccb4fd-0768-79e8-0085-df63ecc0d376@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05e968a9-8498-4245-1aaf-08d860027e5b
x-ms-traffictypediagnostic: VI1PR04MB6269:
x-microsoft-antispam-prvs: <VI1PR04MB6269310EC41E5C4A0E68DCB5E0380@VI1PR04MB6269.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JbnIWzBYPFeQYC+nPHXqTCjePn9utTXpmp4ZG73gyZoGdUvjPBNtStSpcnTIKl3XEnyqv+0rGhtt46EOPItVxSa58mHWklOuBwxnH6TTAuH4iMSFUUIVO7K2vAVamV6a4nUWTj6kKwn+qmUk/713aGTA4Bs6KJ+g2RDodLNocOCoiAP3gl4ZGoDbry26yTzhkKICG7fKjjSJtn36WeLBNtKHvSTZ/Y8h+SOF+reGiMvYldVeXMQ0G8TE6tlrbz0inpqKeaQaGNDcqbWpK2RBJcbf/a3mmAATbbRqwunTAG7HEaXCj4ubkymzszxWWkgyfIr6a6jSIJ1DD8kcYBTAlq10puxz4t1d8mQURtHnIlCYnpo/siiW5dE2VAeyNqw5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(366004)(376002)(136003)(39860400002)(4744005)(4326008)(44832011)(6486002)(26005)(8936002)(186003)(316002)(33716001)(54906003)(91956017)(86362001)(76116006)(71200400001)(9686003)(83380400001)(66476007)(2906002)(66946007)(64756008)(6512007)(8676002)(1076003)(66556008)(478600001)(5660300002)(66446008)(6506007)(53546011)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ce7xt4SCidkn542RwEI3iwyLyYVq9vWRLr+yAdwV/Afc+xzOt1rvzf1WIAdXGF5oQYDCStewTBix6IlIsnYtjHBQNCD/eTILxIAE4a+nqIdF+qCpKin0pfjQ+OSuTqTy6aVNyLktkRu6XtIjeZFY2R7bIozLNVRYYBGVin2+b2k8sLH9Hw0IJu/P/1WpO4YXZTKq4+YPVZCYFUNohoSdKHOTNVcDptR1S4LuFCKX1kqt7923AVZ1+3TrZ+7nLpHtSNdxnd2L7O4esZe+l0d0Sn4vXMuVCU8uocx6EFf4Dr+3GKax0oniOeNkyD99z0mvcq16+GJLKz6jAYDmlSSehBexoxzXAysEgWDf/pLav0xyG/mB2LRk5UkXgKmwgAKFMqVNqT5SThP/ktMzAwYORPvgo2kSy3uxl1cne3rdo+a3nKus8HmYPpnorQhaU9hwQ5zqmS8c+omUkw37A0BRvRizKE/1axmPYIzkJLAfVgnXxDfJkDdsiHQmEhSF8UrQp1il8+nqti1M9zZnfrM8I30KLDTchBoSiVcgUVQM6JfjysLYwHPLHP6Kx+UwMg2ySaMt/8b0nZaK5ZpEaZKOjHQlODETg0KHg452VBmBaKayha+GSmlnTAVA3eXk9D8ED+nRsnV1yCOizlwyJwnQQA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF5DB39E0678CF4CB03891EAC3533730@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e968a9-8498-4245-1aaf-08d860027e5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 20:51:49.8106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDdL4BopwbtiLqbHdVFs3crJrA1u0GXHVB0YQq24Y4dzanf1gHCPjeOVrYWnvG5Iq3qyRJg0JN1iqRp64yAhWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 01:49:54PM -0700, Florian Fainelli wrote:
> On 9/23/20 1:45 PM, Florian Fainelli wrote:
>=20
> David, Jakub, there is an unnecessary header inclusion in
> net/dsa/tag_brcm.c in the second patch and the description at the end of
> the commit was not updated, let me send a v3 right away.
> --=20
> Florian

Wait a few minutes, I don't think anybody has had a chance to look at it..

Thanks,
-Vladimir=
