Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF17D282B52
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJDOvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 10:51:02 -0400
Received: from mail-eopbgr40114.outbound.protection.outlook.com ([40.107.4.114]:7940
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbgJDOvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 10:51:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIveTHZlPIqxdfvsI5kgVidNSFJK0Ci/q77FFZSrwfeF6LuQO2BEwjc5GgxO3RIwGCStI2eh/jDOytJ25is94xEUuVBlvDDls8hEDqFHKIGRsd5LiD36k/7yjiJz8kE+46l30NhFLYA32GvkoXK/u9EWBiBOwOQBxb8MkiYkEGGNs3uKdp0OabJf6aI3jy0MghzH6ArXqTeFJFP6pSOL1J2h1gfCDkcKWxsB2dj3z3nLDvabffsmM3SamvIr5umD5LLNfAd3AT8Ab3tR0NenAw6pF2PB3/eMV2KTwPL1O+4NgIfT0DmmNxkHP/ggKjhGadf9c6G6hGGMGmeU/KDebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDLXA5o9OIuheXdRvBcDvjnkJI2quJQbRsyagciUhCs=;
 b=Y4RwgiTdWRU1aOdKxmzvzkjUNEpgq2BaPKJsc4D5W6KUWX8dSJ9go//cymjRBxhPw8E0DN0sqnxXkQqFjQRIci1Rs2h0bbns8LN+hmaFsIlASxRr9/ay8cYT94ObSj6vGg2vO8pcjjqqj/L/HqZ9Hu/4lz+QHPnitzqE85SjFP5o9KI69M9Afl/HncVeongNq34RKDa+bWi5IwZZVzT9KA+sfJODTAVAqSTmwT0LsacjWmn0XYbLcYflV/4vKPt1ztg5UCW+KHG2lyQdpPji5AVlXCkANcWLUytDbdsxrXi8nU2R7Mn+WnCM25PrbWZGfjY1baCMuMpoHjS7PNdgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDLXA5o9OIuheXdRvBcDvjnkJI2quJQbRsyagciUhCs=;
 b=tspragmqsOT+hSpcebYIvo3w8kfBF1oKOD/7wJ6sxoaGRms/U7QFW3S4RHoCqBMIP1/6lRLsgwaMwRXNpWB4xgMA4jYAR7g/RptprWSB9d0PKBa487karn7MK79yrjTN5KHlFAR6vqEsgOVZdQzJEStSI+K2OHpsOtOba86yZQc=
Received: from DB7PR07MB3883.eurprd07.prod.outlook.com (2603:10a6:5:c::11) by
 DB7PR07MB4920.eurprd07.prod.outlook.com (2603:10a6:10:55::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.19; Sun, 4 Oct 2020 14:50:58 +0000
Received: from DB7PR07MB3883.eurprd07.prod.outlook.com
 ([fe80::7c1d:7f4d:3966:5ff8]) by DB7PR07MB3883.eurprd07.prod.outlook.com
 ([fe80::7c1d:7f4d:3966:5ff8%7]) with mapi id 15.20.3455.017; Sun, 4 Oct 2020
 14:50:58 +0000
From:   "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Davide Caratti <dcaratti@redhat.com>
Subject: RE: [PATCH net] net/core: check length before updating Ethertype in
 skb_mpls_{push,pop}
Thread-Topic: [PATCH net] net/core: check length before updating Ethertype in
 skb_mpls_{push,pop}
Thread-Index: AQHWmPWrcKoArAH2+Ue9HJIFwusMoKmHh0AQ
Date:   Sun, 4 Oct 2020 14:50:58 +0000
Message-ID: <DB7PR07MB388310D80E3D8AF484EEB266ED0F0@DB7PR07MB3883.eurprd07.prod.outlook.com>
References: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
In-Reply-To: <71ec98d51cc4aab7615061336fb1498ad16cda30.1601667845.git.gnault@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [42.109.128.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5568de9d-378b-4510-1dd6-08d86874e7a3
x-ms-traffictypediagnostic: DB7PR07MB4920:
x-microsoft-antispam-prvs: <DB7PR07MB492082F1553E1C0820DA0513ED0F0@DB7PR07MB4920.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gO8FKDjqfLhzk0V5cvd1MnEHEro/wOjqVYTQWifgdxL/NVlbye+ySMQ5bM+tUaanwb8ikNJAk+s1l5TgA/itRnYlKMkX6P1O0Qk3OkR0rVB7j1NkwYqRyRD9FC6qsvOAKYmuJeDoa4//rRGXMnWx8l64haR1prIwiF4VWurUmryoryJf2sKpijpMJJKUR2S8HH3zS7UQYDg7OdDsvuqubyk0+f/tC5IYGJBwI/UU9URU3y9TFS8hYQSFZisEIqm+RiHzZZzbyYS4NYn3GjFxyzqdYX3i9MGUQL/emneRqT7zaf4yZNKQc9vUWg/z+x5epJDFfHe259Kg/uTvqQpF3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR07MB3883.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(33656002)(76116006)(5660300002)(8676002)(478600001)(66946007)(86362001)(8936002)(66446008)(64756008)(66476007)(66556008)(83380400001)(71200400001)(2906002)(52536014)(6506007)(26005)(7696005)(186003)(55016002)(4744005)(9686003)(4326008)(54906003)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: y6tJos9U9Ra3xkjp+d0JTYZhWMbwxJDY+eafxitJ8mAaQIDqD1PlBYbIzWpWpIZz9th6x/PotQ+tL8W74/LCeCxBCEdXH7zi5kW/eyCswpoIkADjynhgnMlsw96Ft20Vd8Q6qi9exG8AxcqDFfVQeDhcK2dipklWVfjfXuP1pTjJ5oh5o1gnezsjXaTzB24bK2xlZQDVoSoiGiRowwMI0yk/GkcwSdoN1eLxAvUCyEQ4nzP1YoVh1PhzHPdJXhjeTkKCvUit1hDqH5Gi267wEngJV5TjJcRIQeBtnk83e+7qoAYTiECDET3jf3dq+m6UcxvWe1r4Ea48r83ef17JIavFXgMedO9Ay7ZBsOX7PhIoHQcqF7eddtg+GL4k/AS1B1WEbtuWK1T5OfGdSVDiNQMH7EqEO5BLSyGWrXThvO2r3tf8a9z+3r82+g1agJv+vM3g/N9Q/eRQnMHTazHJrXKZ5MhphK0MWI2k89DNnxOlqFJV6pfUBXlapZ1Mss2usyWwhEjbN1rg7C0JgoKY84NX6oyWV2Ze6aOnvHBWDLfqWmoTZZ+m/FvSyWSMI8a3Xry4ebZDNoxJD+p4vq5s57yLyKlXlXXLkpYzY2CAyyRsyqWLPsQvs1PsqalTN507z+Q2dcYacD9PEA9P5uSW3Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR07MB3883.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5568de9d-378b-4510-1dd6-08d86874e7a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 14:50:58.3857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rzvPwi6qyYKHGzcZjcpcudPFKMJE9hMYc/tf27Kefx7ut6egPHBdtC5YXjot4IqWC3b7zRJ3PRksOYAC/exsAh+9CLNW5Qgf3lFuLhB8JfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB4920
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 21:53 +0200, Guillaume Nault wrote:
> Openvswitch allows to drop a packet's Ethernet header, therefore
>skb_mpls_push() and skb_mpls_pop() might be called with ethernet=3Dtrue an=
d mac_len=3D0. In that case the pointer passed to skb_mod_eth_type()     >d=
oesn't point to an Ethernet header and the new Ethertype is written at unex=
pected locations.

>Fix this by verifying that mac_len is big enough to contain an Ethernet he=
ader.

>Fixes: fa4e0f8855fc ("net/sched: fix corrupted L2 header with MPLS 'push' =
and 'pop' actions")
>Signed-off-by: Guillaume Nault <gnault@redhat.com>

Is this check redundant. I believe Openvswitch already takes care of it ?

