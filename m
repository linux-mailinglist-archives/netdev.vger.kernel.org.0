Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93E2291747
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 14:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgJRMPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 08:15:44 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:45814
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbgJRMPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 08:15:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bmoriwz5POTmH+I8Cgs3CDSlcmn1n6wfX5mnIZ9xNrkTDGP2ZltIhhK38xqUkDi6p3TMLVeArxGaRgKv0LQ/pCCV6vVRuJLUEVRPlYMwTQ4N6CSQvexISm/Jk36t6dCIs1cSRVGGD00E7N2P2Ixjbsd9Zj+gqpBhv0jdwX0ZUyOxdrLwrkv51vAZ7GJeVNLGUHRsCCAIAGNKF3NGn2lgmAM0jaNRi6cANUBK07yGsX/fzeyzc+oajcyHzKCOh6xj/beUMor1J/8A1RnXAf+POl5K8eOS9EPs71SpPUgL+eL8IeuV8p4AEUaUyDWnBx+2QGIWnj0DhU1YLEGIkYrPbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqcRocs/IqPLFqGxJ7h+bTUu3UrUmUizwsHH2NvSjMc=;
 b=bie1NYR/ux0kdS40oEac0fYuF8mWcthMHUv/4iMqRdT9WygsSBfhZSpAIHPD1JiU7HPC93bfS4WYBCx9b9r4IENhQEIKUEEBHEEpDoF8Mpq6M1ggf9jzUdFUPh8EfUg+AjSECicCSZEP+yeh27vErBS6sNaE7fbYSRTutjXYa8kw+/OHEF3ZAj8jE8us+JmobmR52O8W/jCfAtwFtEkdZgTD1FgWZyNv3A9xrsprTkCTgy/+2FERAcg/vcLl9IwbyqzwjvPQSZFug3gsTkpU/P4YNaZqxSGd7ZUKcd98EL49ZeRC4TftqFNWK8CO7qLSe7V0B7j+E5Cg7XzZjgPJzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqcRocs/IqPLFqGxJ7h+bTUu3UrUmUizwsHH2NvSjMc=;
 b=LWvax34vtNVz7x8dAJ62/ehOXRtyG1FZAJmx9m56Fc4YEmVeHmJQDxGO5yZf/NcSSAcVZeAg3VzEZmfGcDCcp2OVHzvJZUPNQfL3PjCNkK3lDruOOMCkWyVEEGS7wuWoJKSRah6utpQeQoziS4jk5lxSVZoyd1ZstpDVXD1lVt8=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4429.eurprd04.prod.outlook.com (2603:10a6:803:6e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Sun, 18 Oct
 2020 12:15:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 12:15:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Christian Eggers <ceggers@arri.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAAIdQCAAByHAIAArfWAgAASc4CAAATtgIAABHIA
Date:   Sun, 18 Oct 2020 12:15:39 +0000
Message-ID: <20201018121538.usz7zzb5c7zsar42@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <2267996.Y80grUFxSa@n95hx1g2> <20201018114205.dk5mcr7mcnqgo65w@skbuf>
 <9012784.ALUgdZc4HQ@n95hx1g2>
In-Reply-To: <9012784.ALUgdZc4HQ@n95hx1g2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arri.de; dkim=none (message not signed)
 header.d=none;arri.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 511ba46a-d212-43be-589e-08d8735f86d1
x-ms-traffictypediagnostic: VI1PR04MB4429:
x-microsoft-antispam-prvs: <VI1PR04MB442909D94CEDE31415C85CA1E0010@VI1PR04MB4429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i1lrtBXWoFNjkvTje+hgIUGW1HICI4DsDHbK/H/N8e7YJbKzmmxJ0WUBi1FqqMdL8eZ6zRYFJAvn4ulX5rW4qJvEzIhRutz51vH82yGPRcX8prD/jNJeKUBMvAmi/bHWEH36QNghehzP91BYgN4T+PwmN60UYlcmuyCDoWl/DYVgo5KirM7OMgE8h58jeASwrhx8Z9CChck6++1UYZNsiE8o0cTC81EgttZxwHOaEwycgzUiZxstLVjvscwHm+QitwtBq/BbT7mf+ppGpma7iMADz4szltW3slc6J/Vl4IiHD5lRTNYYc9aDlFHdFNfr8vwyJk6GqHHFz0IPTr9Ylg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39850400004)(376002)(366004)(346002)(136003)(71200400001)(8676002)(66446008)(26005)(4326008)(64756008)(66556008)(66476007)(66946007)(316002)(44832011)(91956017)(6512007)(76116006)(186003)(8936002)(6486002)(9686003)(1076003)(86362001)(54906003)(2906002)(6506007)(33716001)(6916009)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /E7YX6Huxf51nIqP+G/Hiagr99Pvsb9DFFC06zN6deuOCm+cf9FGruk3bh4xhUmlp570FxleqpREWbqyo2sG4tbUkTry8jmjwGKK1CiaBaUAwG5uJohd5KdK+a5M9mFDnlfQcwUnZI2W3LL7cL8OCVSv4Aq20CjdGMDNG1OXSeQGPP83vra6rha5p1sU4Kv1RZAIrFu6fNuB7z1QTuRjVWNQ9XAsOIhAhKqosFDZ0iE+g5NWdfO02ja7ozmR5g7K3K2gLYEpGP7QB4B2NSvgZewHjXS1XgDHGL7nOH7AqnAVW55Sb9TaC1ph3Gy9YJeOhHFyPxS+vucZm77aa1NO0Yphvav4cHsrRFALz0a06kNVYmFsiWX2KybSYapVRUeMU6QJZOV9TpptHOiEQ5fG1TgYIrfkm9paW4pq00eG4Z1FdDbOAyGE3QLNSs1XmOsmtylMJE8ygyFSJ6UqfVdLg/xBJsRRYNevAiXOIfY+tEBoWyvDhwuG+RMrj7RUOAD+OTiv7+tMeT3acUYiA8fQ+qRU9HyaRPTG6sQntqMK4MTFlIjsoQDpthYNztd62fRSA+d/CknIMq+aoH70TOOx8DFMcc5I3BGmdUOGuQLNRqlTJ5nF2NEB/G5hMm5T6jlHyFa+l4+Bjk40e9PRCVKpBA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C496F84C18E264AB18F7E11A029E192@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511ba46a-d212-43be-589e-08d8735f86d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 12:15:39.2949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XQHUAbVCdVRVFloNmhKj1pgDwTnkWkPNxpb9nGKwd6DYQ2Njl3OJRcEPwb1K6bHKDFJHHnFLUQ2vtLRCTLhk0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 01:59:43PM +0200, Christian Eggers wrote:
> On Sunday, 18 October 2020, 13:42:06 CEST, Vladimir Oltean wrote:
> > On Sun, Oct 18, 2020 at 12:36:03PM +0200, Christian Eggers wrote:
> > > >       err =3D pskb_expand_head(skb, max(needed_headroom, 0),
> > > >
> > > >                              max(needed_tailroom, 0), GFP_ATOMIC);
> > >
> > > You may remove the second max() statement (around needed_tailroom). T=
his
> > > would size the reallocated skb more exactly to the size actually requ=
ired
> > > an may save some RAM (already tested too).
> >
> > Please explain more. needed_tailroom can be negative, why should I
> > shrink the tailroom?
> Because it will not be required anymore. This may lead to smaller memory
> allocations or the excess tailroom can be reused for headroom if needed. =
If
> none of both applies, the tailroom will not be changed.

Understand now, you're talking about the case where the tailroom in the
skb is already larger than what we estimate the packet will need through
its entire journey in the TX path. I still won't shrink it though, I'll
keep using the second approach you suggested.=
