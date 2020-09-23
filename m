Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F691276323
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWVbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:31:00 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:10899
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgIWVbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 17:31:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5GGv8B/drcVxWNPdpO70YUOb01VZPBSoZghMXjgTwhjsWKszQGesjw4O6meWoww/uIEexShYdokhFXjsUAC5ZbU6mzpFo85ff7zCAjHs705rNHg2tDnvv0SEqARUg8Du57G466N4Y/NlkPaU6NS3BcDxqA0n31oLnXegaIiCpDCaaAZWlabLbZ+ge2gOyV9gZ81lqH0izrVUc5h0Oig9lpRLiCTy5TqqCx2COWRVHEvQDbw/fMPCTQRA+U6g1L0m/p1Lr5nc/sLyFeBm4IewnTe/DJKtpB++z9bKje94wyXWp+6dDjsyLcUXo8plkvGl5f+gHm7CLhQHFAb+t+qZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9it4fm6CSD9TxNDfH1tP9yektMtF7v03zJsLwicBDjY=;
 b=ViHPGvs7pymrfPy3YiztAliovtZSfoRSdC13kpTj+y6BiIFyVo6J4dQqtofhkxroe5lhMrlbma5dzqSnpWS9a2but1A+K+iftlLIbSg28/S42d+Qhd2SOAbOfrpFek38RsUNST6zXE3odonDE3JzfeoogTpYRLeZcY9rNxXqI59GpMe1W6UDYUeHxLAB7e4+DST9roaNZIWAWKi+evmK8lWeJvBC7xlgbGOXDtufa8mnmMz1JPawyAyec1ZxOCV9+1Mp9eJc1YrhV+fcTDboUartsOluOLd5HoJhxnqJEBq6r/3SOdu03+o6Uk+TPd1SFrdVBSDhNJQF5uE7RFrbnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9it4fm6CSD9TxNDfH1tP9yektMtF7v03zJsLwicBDjY=;
 b=rQYViituggRXG9mLBHBasz/gRmlN09NtUm4VqnvKdna5siIcc7YDakL0lH+OUJirvMurmZP3FEW8lGVqnAIv1BVY1RAx7c9777/Ouqs7Eh05D2uNhcBaVgeXSsW/Gbf9o4MFoNTMejFU8vwZQ0FUc18TxRpsWIZkb2CrjotCcus=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6703.eurprd04.prod.outlook.com (2603:10a6:803:129::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Wed, 23 Sep
 2020 21:30:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 21:30:56 +0000
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
Thread-Index: AQHWkep9slBbVOU5dkCcJWZHJ5RCvKl2slgAgAAAiACAAArugA==
Date:   Wed, 23 Sep 2020 21:30:56 +0000
Message-ID: <20200923213055.t7hqzuar2nivatzz@skbuf>
References: <20200923204514.3663635-1-f.fainelli@gmail.com>
 <bfccb4fd-0768-79e8-0085-df63ecc0d376@gmail.com>
 <20200923205148.guukg3k7wanuua3c@skbuf>
In-Reply-To: <20200923205148.guukg3k7wanuua3c@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: edc0e7dc-e23f-47f3-cc29-08d86007f4e1
x-ms-traffictypediagnostic: VE1PR04MB6703:
x-microsoft-antispam-prvs: <VE1PR04MB67038C607E0A797DC61AE43DE0380@VE1PR04MB6703.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bn0VqY4yYCMij/zcnZNsX3Iaf2I4LUiOnwVLnp+r4qt5AjEskmLCL9/LWf/ZpHCgjVYlyfrUzPlsNaqO7ELYfjEOCz2Z8hqNz+557FNRxSzI66FauMSI4KnKrvudoM4dbMxeiUmkv1nwy/lC1qjTbR9M0Y9BC486r0zQ6/GoD0TIxrIc1wDdLI42UkFUSYs6Llmwpc6pLtitkC1Y00z0byUFHw+LZEnhJYbh6mBjRAsRD2xDPQKVrJTvStOgXiwijfn+Xpk6WkI+deSy9ZjUNcjeBjWHlHStbN33i+/2yTSUvWlcrxU5W1VxyHP+J52i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39860400002)(376002)(366004)(136003)(346002)(316002)(66446008)(54906003)(76116006)(66556008)(71200400001)(91956017)(86362001)(8936002)(8676002)(5660300002)(66946007)(478600001)(66476007)(6916009)(1076003)(64756008)(83380400001)(4744005)(26005)(2906002)(33716001)(53546011)(4326008)(44832011)(6506007)(9686003)(6512007)(6486002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ecSHvBKWgPd9Z8pcDOZPr1AGYDGiioPw3xhwHsUWUcDK7rICthJM9xStk+j24PpLDtbIx2irtgKZ8kVVgw+7mfJ27oLYlkhSV0Oq5ZHNUHCcKALtdmr4Rpc0IMy63njzuBspliGDu1H3J7/93sV5WHMtWeNSoSUwwpMCqQGx1Fqy2YvxwxB03Se1MXhkkpxi3Jws3EhJ6nbj4BewN85iGEdYapF9gGhK5p/lUPp/aqAkqolmh83KBl98OFKlkVocI0pZ5xhxUc5JzFxNWtrDnWgZzqFb453VoWqaiwJp9zgf+4XLO/q9BDJBcOS0ttjjfNExpXm1q/qc7F0vgHXLFAzQIq8jbgRai8iiY0cvJ49YWce2uv5iWifrLqX2jrVSK8gQcXs0npH/7Z1iWxzAdL2oC7BJGNB7xywPDgNaKjUhCNR7yc/nlzsMoEmX3Zh6UohuccgI7ESbdw3PhlxSuiIgC9MPQ9piVIcirLrRQxlxU79uGBQwnRZOKBO3h1MlLrtFpRudySO/XChW3U3vULeMu7mfAaIvdqP6t8wZ/P5MzfzPzyN2+tZd9EkW1vd71UHrbLW+ckfk5cdfl+TzawY+YulgDxoQkX0JpV7g9oXhNTbOn2PKdJ65CEo40QwjcRCT+ZeOkC7WOmMaUAqLcA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C21CE00FE4129E4F88C75C4C00C127C1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc0e7dc-e23f-47f3-cc29-08d86007f4e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 21:30:56.1491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JNQbBiKDtNTcn12VPyAFznim3zKMryrEsfuW1vcuBze/I1jAvIJLdK/YvHXW89HD89msMZCZh3dFiinNucj/3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 11:51:48PM +0300, Vladimir Oltean wrote:
> On Wed, Sep 23, 2020 at 01:49:54PM -0700, Florian Fainelli wrote:
> > On 9/23/20 1:45 PM, Florian Fainelli wrote:
> >
> > David, Jakub, there is an unnecessary header inclusion in
> > net/dsa/tag_brcm.c in the second patch and the description at the end o=
f
> > the commit was not updated, let me send a v3 right away.
> > --
> > Florian
>
> Wait a few minutes, I don't think anybody has had a chance to look at it.=
.

So I studied a little bit the situation with the MAC header pointer in
the second patch, especially since there are 2 call paths, but it's ok,
since at that point the skb->data points to its final position already,
then the MAC header is naturally 14 bytes behind.
I've been testing with the ocelot driver which resets the MAC header
manually, that explains why I missed that. Anyway, if there are no other
comments I think you can resend.=
