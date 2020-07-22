Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBB6229018
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 07:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgGVFvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 01:51:12 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:6581
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726696AbgGVFvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 01:51:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqNsTY8QgGWkB4f4EcBnYuea8Nq+rQBuk2DW2N5BMUCMwEMmsadqDjtCN/dB7K4y7dIwSA0EdkP6Vq6hIE2INlxeEaVRmDZJbgrvXCwwOOvD60hfU9dZQ7PAAqoLOjAZRb1hsQlA6qRwAypyl/QsSmqpmRImg9pI53EFrk4m/hsPeDKEgxfcVu5bsabGTPVzhy3+LKwfCOA4aTXpyUMe6j7OgCwSkuy0pWzPVcXHLVNuRz5EBv3bCi4SL8jGA/jxaSyIlM37DDG+XvnrLpZ8sm3t5h3ZxR3mo7cxwlQPOwu0v5r4zA9nSc8BGXNxMquyrztgGAaV3hHkfu9TDP/wug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jsox7AyRBmsmUDNT1vBINDujvgr4gegjQJQdhcDSKB4=;
 b=gDHE2p/3p3p2CsMJPlxrXmi9MuBCwlfJPL7F5bdxEgS6R7CE7psdCdyiinbhEawxHUab7lax70J4RMZy2utfUSmITTGfZhK6JyB9BHTl5j3qc5hsIapvCdc43vV4oOs5vGopbYGS0K9t7AtgbyY5p0y1FZ36A6PHnNwZa453K9ZsKVtes9bP5I3REnHCvRas7xa4VnQmXBUs8KuOKFQgu7ETZVteu2etKErV09otitVp3WQkxmw4yNl3W7xl+ZAT5nx+abvCJZwMCgjcLKZsuKWBSo3bK35aHvAPoFgE30kO6n2uvhyKpLqJluiCfNjzfRoN2FjuSgpwn3iZsTQ/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jsox7AyRBmsmUDNT1vBINDujvgr4gegjQJQdhcDSKB4=;
 b=PEulbgQ/ZV5zT+zuJIo87BoYV8UKdUG/9k+qVed5swtCIH2qbKsGfU/akqzT2VjGL8hLLtf8sr9lMuCIkNXF2eJrVB2oog8lCpC87Lblb0wEGkJYQ35Gpaa+SAqwZZ6vzpCHJCYiqs7Kef3ZIjSeFYh6mRtvTF6hiRUleYiRWR0=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB7199.eurprd04.prod.outlook.com (2603:10a6:800:11d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Wed, 22 Jul
 2020 05:51:07 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 05:51:07 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH] net: dsa: Add protocol support for 802.1AD when
 adding or deleting vlan for dsa switch and port
Thread-Topic: [EXT] Re: [PATCH] net: dsa: Add protocol support for 802.1AD
 when adding or deleting vlan for dsa switch and port
Thread-Index: AQHWX04EMH7CLqtpZku3cp2AmKugOqkSUZOAgADHLiA=
Date:   Wed, 22 Jul 2020 05:51:07 +0000
Message-ID: <VI1PR04MB5103BD1A1ED530D0720CE594E1790@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200721110214.15268-1-hongbo.wang@nxp.com>
 <eaf6e25a-4e64-1ffe-972a-9d309d307294@gmail.com>
In-Reply-To: <eaf6e25a-4e64-1ffe-972a-9d309d307294@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e79d85c1-4fbf-43b6-5133-08d82e033ab5
x-ms-traffictypediagnostic: VI1PR04MB7199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7199353F4FBDAC6C8633B16FE1790@VI1PR04MB7199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AFIKgVNTlaFlnuyT3qMGN/PGhOEAyKAjCSMnZvrDJYgUpuuJlNK2lvFafx7js9DaLn8vv0RcQRZVJsb3WbooRBiEEa6xrk2IFqNbhEb4HtJh74+Mv3TE05TAdssghYV6Qy3bw2jmRk++EwFepstNXIjiTIWWUYr2NYLP1kjgh/J1iPQFHOhJQX1QTiL98qef0UQKO7RupGiwXRpbNVlzH5i3Y0YJRAB8DZ1gK4ntUYOvn5KHPXRQCJxiDCywm0bDcqyo1N8VUAzLhO9mtdlzjfBqWxJDUrPts8/zIn8LX1o3U6yfMiNGu9wjd+AfikSG1X0v6FG0EJu77twdevCW2nVRdzRdIBXLgPRbC0Pf2oHxBalysRpFaGEKOL1ZNrTD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(2906002)(64756008)(66476007)(76116006)(55016002)(66946007)(66446008)(66556008)(86362001)(5660300002)(52536014)(7416002)(71200400001)(26005)(316002)(110136005)(186003)(8676002)(7696005)(53546011)(9686003)(44832011)(8936002)(6506007)(33656002)(83380400001)(478600001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DSPJz0wnT9V4KtugKpoVR0Fy1ndu7DRrs+y9kdj8QIsxFuQQRVyH3ntHXSF3Z+G3741dKjTaH00teOiz2mgoWArpJVqkyKgXth2cgkzJ8sK2jWQhTeWJC/ARHUg4LextL5BN5zV3KTQk48ef3giqLDiI08sQ3nKEjlzHvJU9Gqi7+WYxE466OzFIDa1Y8kDEuWqQM5qUCkzssxxA0EY0fi78CYn/1+GFwYkdOEbWsUgCiG/K5n8qVLfTcmJc3EQQD3rv+aNmz22CZ4WueqzG41w5YuDz4emehDdg8cUS1Rp2PBdS9bC36ryZZiDphDRrkLWRGg6izJysxu/rjW6KKhVeXxcGgPDSQbYI1voYBymz87tP+V+9iDvKEMmCJ48kqVuvRM1fbk6F1jQmzvLJdVyxLHNN1hR+t56UeNgBpbnOitReEdBMLn30XOAtZp7TqhTU7+AyvvmkZ2qh0kNTRKScv/7wcw95MOyU/t8Vl7I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79d85c1-4fbf-43b6-5133-08d82e033ab5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 05:51:07.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vSVmH4j3y7I3nO1z6q1+NdCcpJCIM1VtqASMcfI9CVQ+eVxPvq6kY3w96iYd5wdvtdRVJMAkRGGYHPeFFBkjAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbiwNCg0KVGhhbmtzIGZvciB5b3VyIHJlcGx5IQ0KDQpJIGhhZCBwb3N0ZWQgbXkg
cGF0Y2ggZm9yIHN3aXRjaCBwb3J0IGRyaXZlciwgdGhlIGVtYWlsIHRpdGxlIGlzICJuZXQ6IGRz
YTogb2NlbG90OiBBZGQgc3VwcG9ydCBmb3IgUWluUSBPcGVyYXRpb24iLA0KDQpCZXN0IFJlZ2Fy
ZHMhDQpob25nYm8NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEZsb3JpYW4g
RmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPiANClNlbnQ6IDIwMjDlubQ35pyIMjLml6Ug
MTo1NQ0KVG86IEhvbmdibyBXYW5nIDxob25nYm8ud2FuZ0BueHAuY29tPjsgWGlhb2xpYW5nIFlh
bmcgPHhpYW9saWFuZy55YW5nXzFAbnhwLmNvbT47IGFsbGFuLm5pZWxzZW5AbWljcm9jaGlwLmNv
bTsgUG8gTGl1IDxwby5saXVAbnhwLmNvbT47IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9p
bEBueHAuY29tPjsgQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAu
Y29tPjsgVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IExlbyBMaSA8
bGVveWFuZy5saUBueHAuY29tPjsgTWluZ2thaSBIdSA8bWluZ2thaS5odUBueHAuY29tPjsgYW5k
cmV3QGx1bm4uY2g7IHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgamlyaUByZXNudWxsaS51czsgaWRvc2NoQGlkb3NjaC5vcmc7IGt1YmFAa2VybmVsLm9yZzsg
dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyBuaWtvbGF5QGN1bXVsdXNuZXR3b3Jrcy5jb207IHJv
b3BhQGN1bXVsdXNuZXR3b3Jrcy5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGhvcmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb207IGFsZXhh
bmRyZS5iZWxsb25pQGJvb3RsaW4uY29tOyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBs
aW51eC1kZXZlbEBsaW51eC5ueGRpLm54cC5jb20NClN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0hd
IG5ldDogZHNhOiBBZGQgcHJvdG9jb2wgc3VwcG9ydCBmb3IgODAyLjFBRCB3aGVuIGFkZGluZyBv
ciBkZWxldGluZyB2bGFuIGZvciBkc2Egc3dpdGNoIGFuZCBwb3J0DQoNCkNhdXRpb246IEVYVCBF
bWFpbA0KDQpPbiA3LzIxLzIwIDQ6MDIgQU0sIGhvbmdiby53YW5nQG54cC5jb20gd3JvdGU6DQo+
IEZyb206ICJob25nYm8ud2FuZyIgPGhvbmdiby53YW5nQG54cC5jb20+DQo+DQo+IHRoZSBmb2xs
b3dpbmcgY29tbWFuZCB3aWxsIGJlIHN1cHBvcnRlZDoNCj4gQWRkIFZMQU46DQo+ICAgICBpcCBs
aW5rIGFkZCBsaW5rIHN3cDEgbmFtZSBzd3AxLjEwMCB0eXBlIHZsYW4gcHJvdG9jb2wgODAyLjFh
ZCBpZCANCj4gMTAwIERlbGV0ZSBWTEFOOg0KPiAgICAgaXAgbGluayBkZWwgbGluayBzd3AxIG5h
bWUgc3dwMS4xMDANCj4NCj4gd2hlbiBhZGRpbmcgdmxhbiwgdGhpcyBwYXRjaCBvbmx5IHNldCBw
cm90b2NvbCBmb3IgdXNlciBwb3J0LCBjcHUgcG9ydCANCj4gZG9uJ3QgY2FyZSBpdCwgc28gc2V0
IHBhcmFtZXRlciBwcm90byB0byAwIGZvciBjcHUgcG9ydC4NCg0KTXkgcHJldmlvdXMgZmVlZGJh
Y2sgaGFzIGJlZW4gcGFydGlhbGx5IGFkZHJlc3NlZCwgY2FuIHlvdSBhbHNvIHBvc3QgdGhlIHN3
aXRjaCBkcml2ZXIgY2hhbmdlcyB0aGF0IGFyZSBnb2luZyB0byBpbXBsZW1lbnQgdGhlIGRyaXZl
ciBzaWRlIGNoYW5nZXM/IFByZXN1bWFibHkgeW91IG11c3QgYWN0IG9uIHRoZSA4MDIuMUFEIHBy
b2dyYW1taW5nIHJlcXVlc3QgaW4gdGhlIHN3aXRjaCBkcml2ZXIgc29tZWhvdywgcmlnaHQ/DQot
LQ0KRmxvcmlhbg0K
