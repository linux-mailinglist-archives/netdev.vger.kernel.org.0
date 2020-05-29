Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB21E8A34
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 23:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgE2Vln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 17:41:43 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:5860
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2Vlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 17:41:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvTbM3Z6ZNIe0leP3YY0sa6M8we1ayeU11UZx4qTawrGp45lPttB1+ateO5S9JVn4EnQsKqVxPW55dQhRCGPG4AY5qcHViBN4P2cTjvoDVQL1G32f8PfXxJ2gXErzhapldeZGrrfjElJJyaj7TC/HdInrJvdXMRKcrq6DJL3Jblw3iq7wT5F5je56tudcuLzuBWiA3+4/jHUX6DRynJ66KXSsrunjFlN4W9gbRHgBjvi+2R4KbyVk7VIitWjy2pYJ0sMC41ffcAVqJHLvTFxOee0hhqS9MrDUmdnxOw0dKwsy5tiG7UWWFoNMMmRXapeN08+Pn/1T/9+lYJjmnF/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3buf3crAwpEWS+vikenX5bXOa9xjZ/ep+Re5wGaxWHc=;
 b=WTouWU+8eVg59cbf9AoT15OxFa4dmIwuFQ7vRCvhJFzeIdtKvIJKQxhC8f4jF8j7u5HNF5gtb0FN4kR07yqQSMPMo2HQL26BeUkT2LGVGYcgbcCICL4STc3rCAblVAb+YmxqomXepiFdlKOFvpuidpA1aUA3tvIEP8lSsVUTUnoaMEVuezau4jX5HinPsbbslkpRaSHOty+V7szKkPMFq/VtxtpUSbWP3PJnmDo0Bxg3a2Jm2n/+UjfHt9Lj0XdfFcdRuy5wXPoDZqppxg92P94z4d/UuUm6OK1MpuYp2EFvAI+RfJpdh6BNG+WaT7EEOBPC+uNIIfLkQwC3wF8qtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3buf3crAwpEWS+vikenX5bXOa9xjZ/ep+Re5wGaxWHc=;
 b=s4ibwNt2JZxkChelXb56vdilkUO9dnp5+9PhR0i70wdJKOycdqivE3OAmB0UHUIKJqaxz2WHB7TUXadyxPmTddJ5qfE67X6IbUmkDLyE4D+kMDiFlRzebTjZkw95Uu2M4nWjnWwODS1nSXaV5Yqkx5rObS9hZ+xUnoqnmZFcZUo=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3552.eurprd04.prod.outlook.com
 (2603:10a6:803:9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Fri, 29 May
 2020 21:41:39 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3021.030; Fri, 29 May 2020
 21:41:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Thread-Topic: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Thread-Index: AQHWNeDcv8exh059skO/bWrzCNqeMqi/kCcAgAAFHJA=
Date:   Fri, 29 May 2020 21:41:38 +0000
Message-ID: <VI1PR0402MB38715651664B9BF2D002DBDDE08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200529174345.27537-1-ioana.ciornei@nxp.com>
        <20200529174345.27537-3-ioana.ciornei@nxp.com>
 <20200529141310.55facd7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529141310.55facd7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9ae0241a-39fb-4008-7839-08d8041911c2
x-ms-traffictypediagnostic: VI1PR0402MB3552:
x-microsoft-antispam-prvs: <VI1PR0402MB355299AA38A7EAE0CE0B708EE08F0@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n2eAnBj+iKXqyzvMdsPfI3ybGmEfClFICjK+U0EHFfu3l1GAaccuRKuIxAZic4IQlzWABNGaB1cUfhOD7ESYjxmvSk+R6TpbciB7piOhmZswrD7+1WAcILKCaFI6HKHxsrl/cdXYvU/Z8kP62L320IaMJm9QKWjEjbC3rmsovTOba3y0aYIZ++lsUJFmGCKCPCYWdERvH6/UMMmEV99WAn47e78mWLvmgxTorTyXrq7wiSO8QeiArKEUj1oDZeee2DULe+vEsddrxj4cnhV7JYsmlSoKjQAYyGEuh6Vu+fTgaKzBP1khstJKHUOErBhW944IOKntjr5mpDq6dw/zEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(44832011)(64756008)(66556008)(66476007)(66446008)(8676002)(66946007)(76116006)(83380400001)(4326008)(8936002)(5660300002)(54906003)(316002)(6916009)(7696005)(478600001)(2906002)(52536014)(186003)(26005)(6506007)(86362001)(9686003)(33656002)(55016002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WCp4q9DOBljyeGb7vjQtmeLMq3v2fpO1MGEYN2qv/5D0kmF6DEyvJhZ6Oas/p8I+kRg/5aQTKQwJlZWurK34bHvKHUrjTgIfqtWPlQcd2+SGu7jbvgfjaV3YFwrOY2kFm/I2cI2QgwWN4TW08rqMpo8BSZh+v3KzDOTRvBHbUC9U3KOi/DWE97wm2KMxMCkDf/yRHxL4JOdIIJM1RQ1d6S8RaJF41o9igZbVt06sSoZdTYe0I2BL+KlIHRkVdh0WMpz4YqirJtMwVnLiOFl6B8+e2tQ9bcarZzptZGFTn4LoV7In5NqX7Jxxb1pm7pBZG8EZlqnQCpzDt4FGOpsV9+LWdfo7lgihXQOIsr4FZ9xxuFs8vEFk1IbA1AGpTGNNuQ8MTrtH9TUA2oKzhMjw3MH4ul3kCx4yQTqmvz66mYZ/bDHtdd/6eILthISM9oySVJL42I0mT0O+giRyn+ygPdLepwh4Xu3Rsca587rZ19vFspLbEkFUGzv6MbogwcXz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae0241a-39fb-4008-7839-08d8041911c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 21:41:39.0426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q90A2KAzvidkUzJJchnde/I2qFEl7sHY2g3l5kYgHq2D4V8SkP9wweJDsQ50kr7kdL8tRq/Qi7bAIC9NzHVvaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames=
 based
> on VLAN prio
>=20
> On Fri, 29 May 2020 20:43:40 +0300 Ioana Ciornei wrote:
> > From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> >
> > Configure static ingress classification based on VLAN PCP field.
> > If the DPNI doesn't have enough traffic classes to accommodate all
> > priority levels, the lowest ones end up on TC 0 (default on miss).
> >
> > Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v3:
> >  - revert to explicitly cast mask to u16 * to not get into
> >    sparse warnings
>=20
> Doesn't seem to have worked:
>=20
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22: warning:
> incorrect type in assignment (different base types)
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    expected
> unsigned short [usertype]
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    got restr=
icted
> __be16 [usertype]
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29: warning:
> incorrect type in assignment (different base types)
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    expected
> unsigned short [usertype]
> ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    got restr=
icted
> __be16 [usertype]

I don't' know what I am missing but I am not seeing these.


=20
