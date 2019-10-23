Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DED0E196B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391151AbfJWLyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 07:54:25 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:52754
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733169AbfJWLyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 07:54:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSrOomg77Vy30ONNC/PlqR02INUyvfm1bOXCm/9vm42rW58LA2M+7QFsKC5Vixz7KtQbJcS5t+mR7FOOXNplOOLRXuNjgq/lbQtGvfwz3T1VSeIrFEhIKt2+eTcznd/EMDdNx+BK5tk/mhViMTfUcoeq+AYow7frFsuSvUAvh2W3CNHW18BmDDs7L8BILpHv24x7fcic93u56nc6vse87Kk7ONkvy6DuxaHN6zR8j42qLEH5lmPAhbZUTerSzKFkm41diTt3sq/+kH8FhrUXrfK9SOZ+IZGNLWD0R+rplSYSGuxoVE5b90jA98UuBPTpmDMTe1XvVncuWzt+GvDSqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNEdv9CnAQB4wIzj3rvG26oICmiCQ4jzPMg6qBZQa5s=;
 b=YyGxAuRjxj/l6dyjWUb9jc5kb2b5Goed6/ciu1l2tDFMUA+l4Z1ge6l3KesHjtFNDgw5Qk3dsuAlHiKm2rKzfHKXzZNqhpr37htGTojclyIIa2BKaYQCBdBL7a3IAOHqJXBc6DB+cL6VRBBySbVaD8KttxsTR38Y7tNUnaS8vXlf7S0KFIZ9/TyLD8n3C+ecb3GEX1YEajvLiaEw9x11qM6ju/MSz0e+WMFpwKbM4NsUFBXr/MsSrYQb2Tvl6auNHfTziEm//Tk1CD/8Qdeev9sj7mvkURcmxAEEbObL9AiXWXISLzNNuqfDdvxoNvwBKyYUzeQWYgeA+RAFqp4u9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNEdv9CnAQB4wIzj3rvG26oICmiCQ4jzPMg6qBZQa5s=;
 b=eW3Ff4wGVZ6h9gLIhMu2fxkog3FT8OeydXeRweCP0i9VCV9unzO3MxiFKtFKMCN4g5wqKPx7eEvrRnq/s1DzFsHA1e/SsiWF8yujFkzJ2zOxpKQT8i7Kqo+YSZ5zdruSnSNSZQZY/zk/TX9YWJPjXePlh771T+xiadF3NkLIfog=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB5358.eurprd04.prod.outlook.com (20.178.120.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 11:53:41 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Wed, 23 Oct 2019
 11:53:41 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     Robin Murphy <robin.murphy@arm.com>, "hch@lst.de" <hch@lst.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: Re: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Topic: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Index: AQHViNfyo/IzAF7o50+e1U9qS9i5xadmpruAgAF4mgA=
Date:   Wed, 23 Oct 2019 11:53:41 +0000
Message-ID: <50a42575-02b2-c558-0609-90e2ad3f515b@nxp.com>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
 <20191022125502.12495-2-laurentiu.tudor@nxp.com>
 <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
In-Reply-To: <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 662831db-6016-4aa9-8de4-08d757afa617
x-ms-traffictypediagnostic: VI1PR04MB5358:|VI1PR04MB5358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5358FB3DBAEE4B32D3B63CACEC6B0@VI1PR04MB5358.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(189003)(199004)(2616005)(446003)(476003)(186003)(11346002)(316002)(71190400001)(54906003)(44832011)(36756003)(6116002)(3846002)(2906002)(71200400001)(6636002)(31686004)(66066001)(110136005)(561944003)(26005)(486006)(5660300002)(2501003)(66476007)(81166006)(6436002)(229853002)(6512007)(305945005)(66946007)(64756008)(2201001)(6246003)(7736002)(66556008)(81156014)(66446008)(8676002)(8936002)(76116006)(4326008)(25786009)(478600001)(6506007)(53546011)(102836004)(256004)(86362001)(99286004)(31696002)(14454004)(6486002)(76176011)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5358;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8zF8o+RwJ1QDiYONjx9ZcucusaWvvrl5iZ9aPe0/leaPEn+ClNHc0PadCrNB97VGgByMxNdeMLe5QRH9YtUl0Uj6aTZqtN+UASAnWc+rt2rKiuXGdANzfmKee24PE5HksyptS3RBraPJ7EIpzdh1uVnkuC4sEIBPMIknFPHRTjrVAPlTm8tdREfxfLCbX17stVz6aGznjYd/yAq4lKLhcZDMfG0Fet5rZUEFRyncnHPDxb6RWx7gKY9ytzN4MkLYnn+Il/ZQNFGQbaFxFTHCkAbr4MeFlFR5kNcqPnH1ZtS4jpF+gwbRjyHsQFQI6rR9HPHSlO9JcSWhUAtWq0s7W7vs1gxzNceJgHqQ8D8/QIRONeA+9YNK4O4HebEmJicQGr3xERAAFvaocQ6vhagE50UQW5hocObUrDB9GNxFwSmZkYiCFd79WQv30l/MUGW0
Content-Type: text/plain; charset="utf-8"
Content-ID: <2679FB9EA0E4F3418A83611381CF1016@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662831db-6016-4aa9-8de4-08d757afa617
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 11:53:41.2130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZ9b3MBn2MpIjNUt7THnaogG+u+TbUAQlMHHKaO8tFPkZPKhlq208xycloTKIqFU45/SGb1WfjlP/LHI6JAuoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9iaW4sDQoNCk9uIDIyLjEwLjIwMTkgMTY6MjUsIFJvYmluIE11cnBoeSB3cm90ZToNCj4g
T24gMjIvMTAvMjAxOSAxMzo1NSwgTGF1cmVudGl1IFR1ZG9yIHdyb3RlOg0KPj4gRnJvbTogTGF1
cmVudGl1IFR1ZG9yIDxsYXVyZW50aXUudHVkb3JAbnhwLmNvbT4NCj4+DQo+PiBJbnRyb2R1Y2Ug
YSBuZXcgZG1hIG1hcCBvcCBjYWxsZWQgZG1hX2FkZHJfdG9fcGh5c19hZGRyKCkgdGhhdCBjb252
ZXJ0cw0KPj4gYSBkbWEgYWRkcmVzcyB0byB0aGUgcGh5c2ljYWwgYWRkcmVzcyBiYWNraW5nIGl0
IHVwIGFuZCBhZGQgd3JhcHBlciBmb3INCj4+IGl0Lg0KPiANCj4gSSdkIHJlYWxseSBsb3ZlIGl0
IGlmIHRoZXJlIHdhcyBhIG5hbWUgd2hpY2ggY291bGQgZW5jYXBzdWxhdGUgdGhhdCB0aGlzIA0K
PiBpcyAqb25seSogZm9yIGV4dHJlbWUgc3BlY2lhbCBjYXNlcyBvZiBjb25zdHJhaW5lZCBkZXNj
cmlwdG9ycy9wYWdldGFibGUgDQo+IGVudHJpZXMvZXRjLiB3aGVyZSB0aGVyZSdzIHNpbXBseSBu
byBwcmFjdGljYWwgd2F5IHRvIGtlZXAgdHJhY2sgb2YgYSANCj4gQ1BVIGFkZHJlc3MgYWxvbmdz
aWRlIHRoZSBETUEgYWRkcmVzcywgYW5kIHRoZSBvbmx5IG9wdGlvbiBpcyB0aGlzIA0KPiBwb3Rl
bnRpYWxseS1hcmJpdHJhcmlseS1jb21wbGV4IG9wZXJhdGlvbiAoSSBtZWFuLCBvbiBzb21lIHN5
c3RlbXMgaXQgDQo+IG1heSBlbmQgdXAgdGFraW5nIGxvY2tzIGFuZCBwb2tpbmcgaGFyZHdhcmUp
Lg0KPiANCj4gRWl0aGVyIHdheSBpdCdzIHRyaWNreSAtIG11Y2ggYXMgSSBkb24ndCBsaWtlIGFk
ZGluZyBhbiBpbnRlcmZhY2Ugd2hpY2ggDQo+IGlzIHJpcGUgZm9yIGRyaXZlcnMgdG8gbWlzdXNl
LCBJIGFsc28gcmVhbGx5IGRvbid0IHdhbnQgaGFja3MgbGlrZSANCj4gYmRmOTU5MjMwODZmIHNo
b3ZlZCBpbnRvIG90aGVyIEFQSXMgdG8gY29tcGVuc2F0ZSwgc28gb24gYmFsYW5jZSBJJ2QgDQo+
IHByb2JhYmx5IGNvbnNpZGVyIHRoaXMgcHJvcG9zYWwgZXZlciBzbyBzbGlnaHRseSB0aGUgbGVz
c2VyIGV2aWwuDQoNCldlIGhhZCBhbiBpbnRlcm5hbCBkaXNjdXNzaW9uIG92ZXIgdGhlc2UgcG9p
bnRzIHlvdSBhcmUgcmFpc2luZyBhbmQgDQpNYWRhbGluIChjYy1lZCkgY2FtZSB1cCB3aXRoIGFu
b3RoZXIgaWRlYTogaW5zdGVhZCBvZiBhZGRpbmcgdGhpcyBwcm9uZSANCnRvIG1pc3VzZSBhcGkg
aG93IGFib3V0IGV4cGVyaW1lbnRpbmcgd2l0aCBhIG5ldyBkbWEgdW5tYXAgYW5kIGRtYSBzeW5j
IA0KdmFyaWFudHMgdGhhdCB3b3VsZCByZXR1cm4gdGhlIHBoeXNpY2FsIGFkZHJlc3MgYnkgY2Fs
bGluZyB0aGUgbmV3bHkgDQppbnRyb2R1Y2VkIGRtYSBtYXAgb3AuIFNvbWV0aGluZyBhbG9uZyB0
aGVzZSBsaW5lczoNCiAgKiBwaHlzX2FkZHJfdCBkbWFfdW5tYXBfcGFnZV9yZXRfcGh5cyguLi4p
DQogICogcGh5c19hZGRyX3QgZG1hX3VubWFwX3NpbmdsZV9yZXRfcGh5cyguLi4pDQogICogcGh5
c19hZGRyX3QgZG1hX3N5bmNfc2luZ2xlX2Zvcl9jcHVfcmV0X3BoeXMoLi4uKQ0KSSdtIHRoaW5r
aW5nIHRoYXQgdGhpcyBwcm9wb3NhbCBzaG91bGQgcmVkdWNlIHRoZSByaXNrcyBvcGVuZWQgYnkg
dGhlIA0KaW5pdGlhbCB2YXJpYW50Lg0KUGxlYXNlIGxldCBtZSBrbm93IHdoYXQgeW91IHRoaW5r
Lg0KDQotLS0NClRoYW5rcyAmIEJlc3QgUmVnYXJkcywgTGF1cmVudGl1
