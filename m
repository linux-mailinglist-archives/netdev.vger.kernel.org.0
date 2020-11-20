Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6331C2BA349
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgKTHdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:33:04 -0500
Received: from mail-db8eur05on2087.outbound.protection.outlook.com ([40.107.20.87]:34401
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgKTHdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 02:33:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0HL1+GRncON+4UisymKIn+pj4FkSa+BoALyjEDjfUttGUuh9RfJZwRrR4CvquAfVb8z8MpeRiGDloF2ntFEEhBotAe3qWhu0FzjSJav4NxWPMecQ/t2z8JM+OVSOEWMctzu++e9ndhlDDXEBxbiEuBlLhfOX4x8QT9htCG1+6H4oBasa0JmCLwWWqEqnHeGjHFRdwL8IOkeje1p9XvXUbGA+LNRHoYuUxidMh5eP24d6A5LiloKKQGNSkLl7AP3Pov3Gkob5xAIaYtmjZogN87YpuMtRxTaMVoil3hiOD8foysNG1QCPTNq9L1JfAO9JbrYlmknj7ThLJo8vA5XLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn1Aqv/mNjvPDLjSqEmpvTdRoxkgMBCrQcjRoGw/B7g=;
 b=WCjJBxnnopRr52ZjjnbFRxfY2ABDCcI2br8rcCsHylE1eO7DSK73WPaRUCMEGug5lZ7YsV6GUnXgO01y3fR7tSNnoQ1d/A+o6J8++LyjAA9YUfDgMIBwpfksAD2mFUUwQVEb7lgSCDvm9oVu+aTTgAWGRJ6hWpBotQyZEtLB2CxgC2zEnx0zCMK0Y6PT3Fs1muw4P/bTS+iouQpzmFXQ1DD4Fdd2CCmsOrgsfbAF8p/OnCR8qxW9riS42oVebnslFNUC8GfFhoWBJStKMEEsS6DFHHj3ZxQpCoqcySK1VqukTGuqu1c7E/B5s0sd0hkQWN5RvpkENiEgQ1eoTVmZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn1Aqv/mNjvPDLjSqEmpvTdRoxkgMBCrQcjRoGw/B7g=;
 b=BqpIZeE12pRtdlBVmiFByspdqaFBIPjTe4OFgVFYRwN0wD15d4A8ZDJRTFk9EOTtsrIKs6/K/O7wBvWN0OIQsFBlRyG694QKHyRKpa2JOALycORfdQqmuUOi/W2BSg/TTKaDBrTzGi8gI7cNOq/4Q7T2KEuV72ttqiinuthgpZU=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Fri, 20 Nov
 2020 07:33:00 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::d08e:4103:c893:5742]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::d08e:4103:c893:5742%5]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 07:33:00 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: RE: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
Thread-Index: AQHWvKn0RlwN9xxeW0urW59aAoE16anMro+AgAFjCoCAApFxIA==
Date:   Fri, 20 Nov 2020 07:32:59 +0000
Message-ID: <DB8PR04MB5785668533329D4B012545D1F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
 <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
 <fc5d88d6-ca5e-59f5-cf3d-edfecce46dd4@mojatatu.com>
In-Reply-To: <fc5d88d6-ca5e-59f5-cf3d-edfecce46dd4@mojatatu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71796479-69d8-4942-982e-08d88d2681f6
x-ms-traffictypediagnostic: DB8PR04MB5785:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB578500CAFDEC32F7AD433680F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ljxqQhabc1mRguQPnALFtW5DXU1A3SX9PGrZv1MJccCN5Yg9rNqWaypBkwMUnOMjzY/fUyWGOQvVdsV2XpaKkgzqwwngLR7nZH0HRf2xVCwP9rcVPn60RPsY3i6yIkNG+TqVPmFkfRnuwV3VmmTNzZNqcdgcIuVHu8BeKXiqgS/+PApAMH8XlN7GFJsZLTYHQICrzKhyQDU2TD0akLnQBsMZJBAwjzeM42M25yP9y1M4lvyTANfG6CLxne0tjrM5LCGGbfmQjSWfDJK+Jw4RKJMzem0W1O5xSKZKq0uDuzCuH6ypXGkLNRb7F8DEfUrGvg0SRkq+osQHA94UdTRQRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(71200400001)(52536014)(76116006)(5660300002)(86362001)(66476007)(4326008)(33656002)(66946007)(4001150100001)(66556008)(64756008)(110136005)(66446008)(186003)(26005)(478600001)(2906002)(54906003)(9686003)(53546011)(316002)(8676002)(7416002)(6506007)(7696005)(55016002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TJWtoAgA3aV3Gf0Wpf9Id97qs3n9P1Zann2LEJxWVn8zpdMQUjw2dDxpOdoIjJXfl3lHciZuZd0qKfG8F3WEGHWdocfUW1gSXipFGQxuZskEZ3Jah08H73FCGF72I3UBHYqnFHGLnpNOWpGSIrabwnO+rTDOSmZrpACmlXjxwbX+4ObDKYZAY373mkDbyqXp76+Iyd6yDmrLFGqKQP3Ld+nMzjrVaXyOpMXi7OVvoL+gDpyUGwUwj2UAabAowkbkcUyNbKiIbNpseg42PgFATctDo9E/4lArxFhQqgCkBg18THDcODafWSwJvwufw/fnRLIYO6SEEBRO0vA++eGzm61fnwUThh4rM6OfTrsfZey+WFmU0ZTyZAVnizWFUtKKEVN+qtV09uCEhE3HLyQfskWN2/Sz1SUXL/n3eRqiW4lb20kySjreadWDq8dqD7+XEaqiB/WqTR7zUqDVhebfKBqA95nEHzWkHWhxJNMSumTp+TLruJ9wpoE3S12aMli+135eildsCFlOh56syzvfIHF9HbDI+fpkcb9JdXDTjjxfuGsG2Pv9YNS660wOt7GtqO8owvfHtYdBkQhcDGvejQD73loHN1cwwnivVS5huIfjRoYXd4LBIfqEkjXzKliM346YO4pt7rwyMui96rKNPw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71796479-69d8-4942-982e-08d88d2681f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 07:33:00.0101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGq+2K44vapXFIYZgpBYKhwwPX02qzIW9c1UXcng+8ylp2jbK3P7Yk4J2pBlvvvR04/VnwkW8fU8jUeBP2WuGitA7IXasPHOOMSA4CxoU6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5785
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWwsDQoNCk9uIDIwMjAtMTEtMTkgMDoxMSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToN
Cj4gVGhlIDExLzE3LzIwMjAgMTQ6MzAsIFhpYW9saWFuZyBZYW5nIHdyb3RlOg0KPj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3UgDQo+PiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+DQo+PiBUaGlzIHBhdGNoIGludHJv
ZHVjZSBhIHJlZHVuZGFuY3kgZmxvdyBhY3Rpb24gdG8gaW1wbGVtZW50IGZyYW1lIA0KPj4gcmVw
bGljYXRpb24gYW5kIGVsaW1pbmF0aW9uIGZvciByZWxpYWJpbGl0eSwgd2hpY2ggaXMgZGVmaW5l
ZCBpbiBJRUVFIA0KPj4gUDgwMi4xQ0IuDQo+Pg0KPj4gVGhlcmUgYXJlIHR3byBtb2RlcyBmb3Ig
cmVkdW5kYW5jeSBhY3Rpb246IGdlbmVyYXRvciBhbmQgcmVjb3ZlciBtb2RlLg0KPj4gR2VuZXJh
dG9yIG1vZGUgYWRkIHJlZHVuZGFuY3kgdGFnIGFuZCByZXBsaWNhdGUgdGhlIGZyYW1lIHRvIA0K
Pj4gZGlmZmVyZW50IGVncmVzcyBwb3J0cy4gUmVjb3ZlciBtb2RlIGRyb3AgdGhlIHJlcGVhdCBm
cmFtZXMgYW5kIA0KPj4gcmVtb3ZlIHJlZHVuZGFuY3kgdGFnIGZyb20gdGhlIGZyYW1lLg0KPj4N
Cj4+IEJlbG93IGlzIHRoZSBzZXR0aW5nIGV4YW1wbGUgaW4gdXNlciBzcGFjZToNCj4+ICAgICAg
ICAgID4gdGMgcWRpc2MgYWRkIGRldiBzd3AwIGNsc2FjdA0KPj4gICAgICAgICAgPiB0YyBmaWx0
ZXIgYWRkIGRldiBzd3AwIGluZ3Jlc3MgcHJvdG9jb2wgODAyLjFRIGZsb3dlciBcDQo+PiAgICAg
ICAgICAgICAgICAgIHNraXBfaHcgZHN0X21hYyAwMDowMTowMjowMzowNDowNSB2bGFuX2lkIDEg
XA0KPj4gICAgICAgICAgICAgICAgICBhY3Rpb24gcmVkdW5kYW5jeSBnZW5lcmF0b3Igc3BsaXQg
ZGV2IHN3cDEgZGV2IHN3cDINCj4+DQo+PiAgICAgICAgICA+IHRjIGZpbHRlciBhZGQgZGV2IHN3
cDAgaW5ncmVzcyBwcm90b2NvbCA4MDIuMVEgZmxvd2VyDQo+PiAgICAgICAgICAgICAgICAgIHNr
aXBfaHcgZHN0X21hYyAwMDowMTowMjowMzowNDowNiB2bGFuX2lkIDEgXA0KPj4gICAgICAgICAg
ICAgICAgICBhY3Rpb24gcmVkdW5kYW5jeSByZWNvdmVyDQo+Pg0KDQo+IFBsZWFzZSBDQyBfYWxs
XyBtYWludGFpbmVycyBmb3IgYmVzdCBmZWVkYmFjayAoK0NjIENvbmcpIGFuZCBpdCBpcyB1bm5l
Y2Vzc2FyeSB0byBjYyBsaXN0cyBsaWtlIGxpbnV4LWtlcm5lbCAocmVtb3ZlZCkuDQo+DQo+IFdl
IGFscmVhZHkgaGF2ZSBtaXJyb3JpbmcgKyBhYmlsaXR5IHRvIGFkZC9wb3AgdGFncy4NCj4gV291
bGQgdGhlIGZvbGxvd2luZyBub3Qgd29yaz8NCj4NCj4gRXhhbXBsZSwgZ2VuZXJhdG9yIG1vZGU6
DQo+IHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgaW5ncmVzcyBwcm90b2NvbCA4MDIuMVEgZmxvd2Vy
IFwgYWN0aW9uIHZsYW4gcHVzaCBpZCA3ODkgcHJvdG9jb2wgODAyLjFxIFwgYWN0aW9uIG1pcnJl
ZCBlZ3Jlc3MgbWlycm9yIGRldiBzd3AxIFwgYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgbWlycm9yIGRl
diBzd3AyDQo+DQo+IHJlY292ZXJ5IG1vZGU6DQo+IHRjIGZpbHRlciBhZGQgZGV2IHN3cDAgaW5n
cmVzcyBwcm90b2NvbCA4MDIuMVEgZmxvd2VyIFwgc2tpcF9odyBkc3RfbWFjIDAwOjAxOjAyOjAz
OjA0OjA2IHZsYW5faWQgMSBcIGFjdG9wbSB2bGFuIHBvcA0KPg0KDQpBY3Rpb24gbWlycmVkIG9u
bHkgY29weSB0aGUgcGFja2V0cyBhbmQgZm9yd2FyZCB0byBkaWZmZXJlbnQgZWdyZXNzIHBvcnRz
LiA4MDIuMUNCIG5lZWQgdG8gYWRkIGEgcmVkdW5kYW5jeSB0YWcgYmVmb3JlIGZvcndhcmQuIFJl
Y292ZXJ5IG1vZGUgbmVlZCBwb3AgdGhlIHJlZHVuZGFuY3kgdGFnIGFuZCBjaGVjayBzZXF1ZW5j
ZSBpbiBSLVRBRywgZHJvcCB0aGUgcmVwZWF0IGZyYW1lcy4gU28gSSBhZGRlZCBhIG5ldyBhY3Rp
b24gdG8gZG8gdGhpcy4NCg0KVGhhbmtzLA0KWGlhb2xpYW5nDQo=
