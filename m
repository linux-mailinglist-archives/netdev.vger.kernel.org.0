Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81BB4225E7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhJEMGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:06:44 -0400
Received: from mail-eopbgr1410114.outbound.protection.outlook.com ([40.107.141.114]:19918
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234495AbhJEMGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:06:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gm72jSFhRo4HLO2XiUn+oLPgUrmjf+vURIIx/qdLHfWZ41JHFmKXlC/k2maMc3fd9ZlK7KSlRqnZgVXH5wrlOggAC01tX/IFnpxdkf64mq3goszDgSvvylyXrEmbHVegRAazuLTKEKmCFKBRTCpSDs7qxXx1sinkyanJ4LXXQdxSJ710EkOei7G2y8X25056hjBNALjI3XYPpXkTsu587CAZSwptitt4LbypY0cMyYHRjjdfWHY3uTjTNStv3d8Sfj9jFLkAXZbxD+B8tt4ZLFRRwBCXGi0oiVJws908EETOjaVvQO9dlOkCoujUWk8ISeEAB+gX1mhcHF4whKQAcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avQ92XK5W5ropRoXs6vzOk4HZuZ9go4dte0W4wVOYwU=;
 b=XBbllWyxwtaCqEOVZtRLxiDsHZELoeaMlbWsVvRBywnj5K/ceQYS+/Kh15yuYvrUwpdEJkQThXdfKRKTw0ICCla5eAFDqaYCW2CqKMUK4yqHZ+vaY4gLeFcfOvTfa0BnlJ8mdry8qbKU+eeCVdfWWzu2HClP6hZpNotMgVYariUxCqqwsDqAI9OPx66zsRl/bCKbjrQJg9xk3M/bSjgYkhNXbQuOoJbuT9ayCQrq6PeClTOYp3RdI1QYt39uhq1C7W6tCcWxkhBkQhXtNYkQorhz6ycIYO6wbPsxbhLt10c96azyqgQpH8QXmvPl3szny7FTYXjWILu6YhRDdCbonw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avQ92XK5W5ropRoXs6vzOk4HZuZ9go4dte0W4wVOYwU=;
 b=BHG4auIA6hfHeyvGaQXXUOS8kMr1c5ZzU4zWvG6fH/RyxPmyhLpVtDpdX9mnKWqI+z7dUSuGhCAUsMvwg9x8yA2G0/xsa9uIFgd02mkA7G1idSYN+r3NC8xw9XeEgOq7hk+pBcgfFZmHpR4THmN8JXNlmqwyeBOMeO6hQRq1Ppc=
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com (2603:1096:400:47::11)
 by TYCPR01MB6527.jpnprd01.prod.outlook.com (2603:1096:400:93::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 12:04:50 +0000
Received: from TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::a922:31be:a34f:e41a]) by TYCPR01MB5933.jpnprd01.prod.outlook.com
 ([fe80::a922:31be:a34f:e41a%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 12:04:50 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC 00/12] Add functional support for Gigabit Ethernet driver
Thread-Topic: [RFC 00/12] Add functional support for Gigabit Ethernet driver
Thread-Index: AQHXudkYuZS3xsSv20asA8nFjta8CavES9cAgAAB2uA=
Date:   Tue, 5 Oct 2021 12:04:49 +0000
Message-ID: <TYCPR01MB59338FE5758C97280292590586AF9@TYCPR01MB5933.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <0239b412-c769-747b-4ac8-88d2bbb5f0c2@omp.ru>
In-Reply-To: <0239b412-c769-747b-4ac8-88d2bbb5f0c2@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2717979-4521-4b04-401f-08d987f8553f
x-ms-traffictypediagnostic: TYCPR01MB6527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYCPR01MB652711B35C896457974EF30386AF9@TYCPR01MB6527.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xkc1cLQW6GSstJbHgRz+v6+Zt094z6GDcvAqtlMUkHAO6l+/mw9WTAbzkgJSnU5yqPaw+girWNhCG7y/FB8RhA7rh5HkWHiLo4zuPvj0+Nl7eyPxFxMRqqFvda9+O67Uor59bhJPk+G171i+hssUaz7GlW4W7DWoEB4L9OfFfRkK3k5H7JaVjvmM8XnSgV2GlBK4j6B6c01TFwqm/lTQQofqaEdiOAORYTjX23QsuXGm3qR4tolOUSqP00g8Q81QQZGsMeeoRCAyPdEEuyIHtZoB0xuMrO9VlqHVy6L7MCnLbVPuhBGzRazpHaYxxnwX4txu5zxUgsEy8DMgezgzbS9hcC84k9fG5vbLFeMidrBhPC68BtTvgoKB2T2sua5Sj+fD7mN016H5m6zBOb1jIJlskiVhVtlecoBrXDDcF5cWgXrI8gJDQw3EdZYQXWhVBpmDx9M3SObD7W830JnjazS3mAGdTFbluUMm431bEAPZh0jVa3nyxLbCLFMQkv171d6+vZsZwhrNcSklZ5eDzmHBIHIckmFlwVrbOwr+oQulZDONbI6FT9acb9ze/4Bvv2n7qUqmN0o5fDhFNHZ5XvQnqfxku6ZhZggXqESdzLgKPoiWGKR60vUKL4ZVBcS1xaxglCdZeTT7Y3r/eo6HOjShhJFfJHcK0atPXQMMJlVO2EXi0W6L6Bb8aOmfymt4BiI3cKZvqIpv76niAFbcqkmWI+ZVREBM6YJYoLXsX8vjiCd6opfHaXlrCkYlDh29lBBSzDanzWf4QcEec8SFaFesWfK4KcNxLaW1O0q3Y8aaN4F9mQ4qC2v/vsCblF3ZAqmDcfT62Ti3UDRm+Fmjlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB5933.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(316002)(71200400001)(66476007)(122000001)(4326008)(52536014)(110136005)(55016002)(38100700002)(45080400002)(54906003)(508600001)(64756008)(107886003)(66946007)(66446008)(66556008)(76116006)(5660300002)(38070700005)(26005)(8936002)(86362001)(186003)(6506007)(53546011)(7696005)(33656002)(83380400001)(2906002)(8676002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fnJHeWvsePeXvoED/2i225SznQdRVhgOgFsuiqdzWtmtmczqQGKODVWas3pY?=
 =?us-ascii?Q?S9wAzshPbuIbc7GiXBaEapPLvK8lKI1JJ0dELfjDOEKUsRrP/Sqnh7jO1VWB?=
 =?us-ascii?Q?0dLH/P5wRCHe8FFJNufjNVKWFQjaeRqxU9zstCpu5tnwxuAcRylS+ETXerWl?=
 =?us-ascii?Q?0tJpSf1nJPcUfyr+kcoS6LWxPYncsq2Nx3gaOxzz530dLBaPLMfp05Nux1Sa?=
 =?us-ascii?Q?SLVo0BljPg40TvOL9MXqkYoj1H1Ik/jjtjtYY/K6CPYwzaKH8tcgUDtD7loM?=
 =?us-ascii?Q?jpTR6fa3Zop/gO6EzyKdswHhY7jwmlV8qjVRZKmOhZLKDN26lQfNb0Ch9E3Q?=
 =?us-ascii?Q?dSccXb3eB8BD7E41IGKpAURvPT0hppitMkuXIrWtW0ul6ppJ6TZGKWz5e8s+?=
 =?us-ascii?Q?iejrmIZy/yjZzuJLOcOF0xwipNLIRf4nKvbzk7rs9kbYKWBUKYEh16IKlrgW?=
 =?us-ascii?Q?UWIYh41u/qa+GOHezvD1dtTjri0rsScPBP7TV49evHXChGYxAbZNhRl45ZXI?=
 =?us-ascii?Q?iNDIg+3/j8p5dsUARyAlUXXGQqTFQqVu/aurOt4hrv3DFmuAHllRomzakymE?=
 =?us-ascii?Q?cq9yHTCLIbDne2FCJTWkJbym9pi8Qbos76hVVIlKdekAi3+t7vp3tlhX8uyX?=
 =?us-ascii?Q?RmmWp+uVQSht4JCtgvdjakRAYSv/JEjVcJBQJAl27Gv4JfTLQWjwBnis8/+7?=
 =?us-ascii?Q?NCbC2PUq1Ri6pZ8/hM5PXHCEc4B2eHOxj0CdqqcnowF96BAUwo0vHnC4D6rw?=
 =?us-ascii?Q?0ivvGRF/9RVWL2081kespx5YYnRUf7WZq0CFixCTHDhUPL+slllwnGXDGL07?=
 =?us-ascii?Q?Rjb8VnimRFIECLvkVmI1ClIFnDFY3vAFCmF+Cj65HV4b83KApjWtfmbOQGC7?=
 =?us-ascii?Q?YZcZet0i0/8q0IxsfGGk3D1iKW9+BAzlLpoKgOis9bV3unFHFf973WOYvtJ7?=
 =?us-ascii?Q?B8pa7Wg5qMearWlkTzkl61Xe1GHle4Q6XaykeZORXVrFzUpjVicuuk1CpWZs?=
 =?us-ascii?Q?c04i/yKDaAkWXxvirbeAis2kaHDg3iS3snuUihjxJTB+ZqYOJnoZ1mS5h7Bj?=
 =?us-ascii?Q?WIg4U/a7r+IKRh+viqnXeQ15ZWUOC/ZasKlsK2ez1y7FtrmHbgobpbJ7u9OU?=
 =?us-ascii?Q?TV2PpOz3m1dsXG484v5EdePCQR6aAbUPtPk63YK2N0vhPBTKFPlGmlEY5wlm?=
 =?us-ascii?Q?53qiG/iuKcDdqwaTpm8BXNqIxQ9FQ4oXjZ8U5tT4ZxvYWHgyC2M8VQgWjmzu?=
 =?us-ascii?Q?ZMKnE6vYJuizG6fPS+kvme8xJVwtWKOORV28j2LipT8VWnUhmJb2qzV8+vWl?=
 =?us-ascii?Q?iJt+fPK17EWmhnxXVY5WBTFZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB5933.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2717979-4521-4b04-401f-08d987f8553f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 12:04:49.9332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9kpEZ0EGpDP953nICntW7+jQK4UEoPIDYsKxoI8tF0qlDmZQEMb1NZgn4wW5I4tCy9bXzbN07p/QWbzNOmiSVSye/HUXD1mqW/ReVQ4wBGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6527
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> Subject: Re: [RFC 00/12] Add functional support for Gigabit Ethernet
> driver
>=20
> On 10/5/21 2:06 PM, Biju Das wrote:
>=20
> > The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC
> > are similar to the R-Car Ethernet AVB IP.
> >
> > The Gigabit Ethernet IP consists of Ethernet controller (E-MAC),
> > Internal TCP/IP Offload Engine (TOE)  and Dedicated Direct memory
> > access controller (DMAC).
> >
> > With a few changes in the driver we can support both IPs.
> >
> > This patch series is aims to add functional support for Gigabit
> > Ethernet driver by filling all the stubs.
> >
> > Ref:-
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flor=
e
> > .kernel.org%2Flinux-renesas-soc%2FOS0PR01MB5922240F88E5E0FD989ECDF386A
> > C9%40OS0PR01MB5922.jpnprd01.prod.outlook.com%2FT%2F%23m8dee0a1b14d505d
> > 4611cad8c10e4017a30db55d6&amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas=
.
> > com%7C880ddc38cf254b0a81fc08d987f6ea17%7C53d82571da1947e49cb4625a166a4
> > a2a%7C0%7C0%7C637690316835703147%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wL
> > jAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata
> > =3DWmbtErppjUTywkNet%2FtDKw9v5gqaqRlcHGjI3PZ1UN8%3D&amp;reserved=3D0
> >
> > RFC changes:
> >  * used ALIGN macro for calculating the value for max_rx_len.
> >  * used rx_max_buf_size instead of rx_2k_buffers feature bit.
> >  * moved struct ravb_rx_desc *gbeth_rx_ring near to
> ravb_private::rx_ring
> >    and allocating it for 1 RX queue.
> >  * Started using gbeth_rx_ring instead of gbeth_rx_ring[q].
> >  * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
> >  * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
> >  * renamed ravb_rx_ring_format to ravb_rx_ring_format_rcar
> >  * renamed ravb_rcar_rx to ravb_rx_rcar
> >  * renamed "tsrq" variable
> >  * Updated the comments
> >
> > Biju Das (12):
> >   ravb: Use ALIGN macro for max_rx_len
> >   ravb: Add rx_max_buf_size to struct ravb_hw_info
> >   ravb: Fillup ravb_set_features_gbeth() stub
> >   ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
> >   ravb: Fillup ravb_rx_ring_free_gbeth() stub
> >   ravb: Fillup ravb_rx_ring_format_gbeth() stub
> >   ravb: Fillup ravb_rx_gbeth() stub
> >   ravb: Add carrier_counters to struct ravb_hw_info
> >   ravb: Add support to retrieve stats for GbEthernet
> >   ravb: Rename "tsrq" variable
> >   ravb: Optimize ravb_emac_init_gbeth function
> >   ravb: Update/Add comments
> >
> >  drivers/net/ethernet/renesas/ravb.h      |  51 +++-
> >  drivers/net/ethernet/renesas/ravb_main.c | 349
> > +++++++++++++++++++++--
> >  2 files changed, 367 insertions(+), 33 deletions(-)
>=20
>    I dodn;'t expect the patchset to be reposted so soon but I'll switch t=
o
> reviewing it insted of the previously posted 8-patch series...

Previous patchset posted as actual patch and there is a suggestion[1] to se=
nd it as RFC.
That is the reason I have send it as RFC. I have incorporated your lastest =
comment from previously
posted 8-patch series in this new RFC patchset.

[1] https://lore.kernel.org/linux-renesas-soc/OS0PR01MB5922240F88E5E0FD989E=
CDF386AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com/T/#m8dee0a1b14d505d4611ca=
d8c10e4017a30db55d6

Regards,
biju

>=20
> MBR, Sergey
