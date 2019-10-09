Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B3D0C30
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbfJIKGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:06:16 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:48091
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbfJIKGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:06:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=busMzihIkZvFRqLT24Nxld+vkaQhngaibRF4AT95XVPTyaYfvIpemwPbdJjC571/lwcFtshpQLwFhD0Z5tr/dgav2AHhGsKc3aP4Ddj3FOXUOBS09xWly1y2dPAk1hKVnMZ2JByR/NIw9StChxOXDyM9G/BITLqy8GrRfT+j/mV46R5VFlsxo+bhmjqMogrs1Ftj6rbjrPmDribRC+6WeDL2gc57bgHqHlg2+pRuuDEPD7urmkgSGp/HpI1Xic6dVg0h6/4uMTPb84ZOiSm1gfgOHJz1kjrOGW2rmkVntMxoN1CJjmOJ9vb0GWFjMD5IxLNHJqGYQVued+qXDwjpIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZT9u+RBMF7VJB8rHfS+hh8hXsxwlSDetzzMFroy8pg=;
 b=K05kw/ffdO6N+s8Xbf/loZo6qIzJpjSwTLv4FSqA3/N6bYh3UZWobbqIoBtiiFIiJdP/rVIADloJGBQAjyOWLXvb4tQDwCGrZN0P/Jbwd74TYST+gRySHOt0SNQz3o15M47tJAp7T2yNd0DMaCCGbl9WvqMwbeEUT6qLrknJFGgkmxJnW6GywH3pcOeGHOv3A2qozGUpqiUKUDxZVO0zOuk1WdCm1v9gYXQJ61rbnCeeA/GwI4JLkCqER41Wmj2V8MRgejJSkiuQ1JS+HBd0O93VuEBI90yw3LOhA+Zz0FqoNURAqp5kE5kf/VF4TD18Fh/EdFA5cGGfrctZzni3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZT9u+RBMF7VJB8rHfS+hh8hXsxwlSDetzzMFroy8pg=;
 b=NtwYq9c0ocEkWeOHluq/B88O2HGtBRMq9ZFZImnyJk/O8q6fwOtpi2NOKqOwzsIbY9exQxOIgUkjCK17BGLxqVMIiRnLgAEu/vjq80mwCdRJhhfgwhUDF42bRHd+h0kVA/HcCrW4yVL9efCTTKUlNaGBx1W8eq39h30sNeY9F+Y=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4400.eurprd04.prod.outlook.com (20.177.55.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 10:06:12 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 10:06:12 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
Thread-Topic: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
Thread-Index: AQHVfdGJ8BuiEujlUEakPeKI2HGGx6dR7bYAgAApAYA=
Date:   Wed, 9 Oct 2019 10:06:12 +0000
Message-ID: <43b4dba2-cf0a-8f8f-e44a-d76833e28dd2@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
 <1570536641-25104-20-git-send-email-madalin.bucur@nxp.com>
 <20191009073926.GA6916@infradead.org>
In-Reply-To: <20191009073926.GA6916@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47de30cf-c49f-4f86-2651-08d74ca050a6
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB4400:|VI1PR04MB4400:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4400C07EC25E3E43DF8771A8EC950@VI1PR04MB4400.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(189003)(199004)(486006)(99286004)(446003)(476003)(966005)(2616005)(11346002)(76176011)(14454004)(478600001)(76116006)(25786009)(6116002)(26005)(91956017)(229853002)(66946007)(3846002)(66446008)(64756008)(66556008)(66476007)(86362001)(186003)(6512007)(2906002)(6246003)(31686004)(6506007)(53546011)(31696002)(4326008)(44832011)(6436002)(102836004)(6486002)(6636002)(7736002)(36756003)(110136005)(6306002)(81156014)(81166006)(54906003)(66066001)(5660300002)(71200400001)(71190400001)(8676002)(305945005)(316002)(256004)(4744005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4400;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 57n5dgbSKs0auHVu7ntUPEYSqeooHTyF1VsLI6dJ4VThyVIqh3poG2S12VfrxzneH3r1yHFzQR4ca90IovqxdQcoyqdZLyqKNs6EQ3W+CiHLDTVTn5m6G9duCUeRBZYF/BjzVICy1bGK9RF0tkK0nB/oSMGTqtfDUKRrp5Kgy9/sQQ0BvC3jLO01CB8vbyQ0BZwjMV8GAOaiMaHkb1xttxiUL1QZao0Ftdp5US+Dcu9LrpDPiu4dal+DoSUvQ1B2wAXgC/UxYKaUSWPbpvc2x2+oeHYZyWkqMnFMpISdzLk/8iNEnhP9vjaNYh/+v+nzs48g8/Xbl4IsK8XONMH7A7sJnN0YLMbVqpquHKQiTdC7neTIgDq8TzVWiekoa0x+3CtiDz9q7BMKgl2vV/Mr7ukp2xACxoNIevQ/pJp9z6WmERJmqcLCcT2LqYAO5a+W4lL9LwA/fJ54HL6F7jsX7Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <130FB95E19AFDD4D806208373DE41922@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47de30cf-c49f-4f86-2651-08d74ca050a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 10:06:12.5740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jzrC5QPrQ/dcEUlWSTFD2/IV3QCxax9NeH7L3wxllzV1Lp3Ym07VR7WPSYT2uZqQ2A/jHuFULS1EY9bceqOJTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4400
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkuMTAuMjAxOSAxMDozOSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE9uIFR1ZSwg
T2N0IDA4LCAyMDE5IGF0IDAzOjEwOjQwUE0gKzAzMDAsIE1hZGFsaW4gQnVjdXIgd3JvdGU6DQo+
PiBDZW50cmFsaXplIHRoZSBwaHlzX3RvX3ZpcnQoKSBjYWxscy4NCj4gDQo+IFlvdSBkb24ndCBu
ZWVkIHRvIGNlbnRyYWxpemUgdGhvc2UsIHlvdSBuZWVkIHRvIGZpeCB0aGVtLiAgQ2FsbGluZw0K
PiBwaHlzX3RvX3ZpcnQgb24gYSBkbWFfYWRkciBpcyBjb21wbGV0ZWx5IGJvZ3VzLg0KPiANCg0K
WWVhaCwgdGhhdCdzIG9uIG15IFRPRE8gbGlzdCBbMV0gZm9yIHF1aXRlIGEgd2hpbGUsIGFtb25n
IG90aGVycy4gSSdsbCANCnJldHVybiB0byBpdCBhcyBzb29uIGFzIEknbSBkb25lIHdpdGggdGhl
IGJ1cm5pbmcgc3R1ZmYgSSdtIGN1cnJlbnRseSBvbi4NCg0KWzFdIGh0dHBzOi8vcGF0Y2h3b3Jr
Lmtlcm5lbC5vcmcvcGF0Y2gvMTA5Njg5NDcvDQoNCi0tLQ0KQmVzdCBSZWdhcmRzLCBMYXVyZW50
aXU=
