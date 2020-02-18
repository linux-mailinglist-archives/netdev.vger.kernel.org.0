Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0A016266F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 13:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgBRMsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 07:48:45 -0500
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:29051
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbgBRMsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 07:48:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEe0EMAcyAMDNpXzHeiMBqDpK71YlRR6y/yxOWK3j9ZwrcYrufOulYJKzN7MZj1rrrEIWJmTeyTZ6b1JRwgFPvpDPWdzm1hG2duuiiYncHSZr7hPawGVkpyyc+ZVnnrb6XTsB6F4LWvqHTLM4vtfvYBweaCIP+JgBxDK5W9odB3PWjf/26qkIY949CEB9G19fepeZX2Aw+0LvXTK2NS35NkFmSj3T0/kmX8i+XMHaOocY12y0wBLqye14gG5HQ6EbQsleUxxuU3tfOw2ZEG/cP1f14shuZ2mbmPypZzb2FdOp2T+BXyU1kbdv6DuVJK0d35+pKP7VNSFt1BXBAq2tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYcVTViYBGsSqB+VO5DjojJV6+iGDxqjCfxruYX/JdY=;
 b=NWRt9pzPiS74XW0AmbzjHJvesfCietJ7jCG4wIkoIJYLJF/qWhDvQwh7BHmxX++PUHwqMr+w0XCNgMzNd2jc5J/qfPQheBP9AU8BotRMsHrsDjdZNH8yVMV4Gz7jewk4tUkYzvCY8Y23tC8Q252I4qJL8Un8cERYSNRzHsYOsl/F6d9L+RmKyPyvz53yYGGo0eMwHyrTdtqdZ71i3jgFbr9qFMYazjH+ckevNbqryEHXN6chP2S2xmAhd02vcWO/BxCl8P2GwDMOVEFDBeZL+HNe5lLR8Ixc2ru6qsVJwXsNCywlu1/c6oUwsjUaE428E1qbdjrdyIQrD7ia5ggHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYcVTViYBGsSqB+VO5DjojJV6+iGDxqjCfxruYX/JdY=;
 b=b27rHQmlgvoGfMDQtq7+dnrRFfeB5KHCYLj9k6gy0tEVmwhhTNtCsJL1W90SHL3ol/2wXDlS7pXAsTN+I0OVn8ZAnrc3gS60EYt6u+yUBnyT817cw8qyzyE2821WKEyK2RLm/5X/Y1ZIzwg1TamoDnuvL6kM//ChSb8YefBZ0BU=
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com (20.177.52.139) by
 VI1PR04MB5679.eurprd04.prod.outlook.com (20.178.204.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Tue, 18 Feb 2020 12:48:39 +0000
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19]) by VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19%6]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 12:48:39 +0000
From:   "Pankaj Bansal (OSS)" <pankaj.bansal@oss.nxp.com>
To:     Hanjun Guo <guohanjun@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Will Deacon <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Topic: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Index: AQHV5lZ7Xi36FCZsh0O+fGt3c05hNagg5R2w
Date:   Tue, 18 Feb 2020 12:48:39 +0000
Message-ID: <VI1PR04MB513558BF77192255CBE12102B0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
References: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <615c6807-c018-92c9-b66a-8afdda183699@huawei.com>
In-Reply-To: <615c6807-c018-92c9-b66a-8afdda183699@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.bansal@oss.nxp.com; 
x-originating-ip: [92.120.1.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d8bd4d1f-a583-4669-b0fe-08d7b470e07b
x-ms-traffictypediagnostic: VI1PR04MB5679:|VI1PR04MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5679B6B06B0F91EE268FB452B0110@VI1PR04MB5679.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(199004)(189003)(55016002)(966005)(66446008)(7416002)(9686003)(66556008)(478600001)(71200400001)(64756008)(33656002)(52536014)(66946007)(86362001)(76116006)(186003)(81166006)(26005)(4326008)(5660300002)(66476007)(81156014)(8676002)(8936002)(110136005)(2906002)(54906003)(7696005)(6506007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5679;H:VI1PR04MB5135.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDBi4HWLhLrIsPrOxANEvgNUiF4Bdn8K7zs9lwscGyxVUFo/PbpohUFUNAELTxXVUCNMCmeqX9m/zGmjxhQrS+WUbJ7L4lqCHM5DGT8wLmWTcPzHcfaYrIQsLFtQAui2nmSivVFr+zT6c6S/hFv7jrnQUcX89LSwX7Y/6rRKoJ3FjwgC6Y1y+rqHyQ2q/zCFLxdjOZKE0MD5cbZsp5LiVFGSKbvgIju1BWBY1gDKPqnloKM/iIssIfZspXQxktvOf5ArCcZdcXfdUs7x/Zk4ZaGMeHwHR3pCNSZh2wn3tFs+r9e22LRRPKP1DHkmQgVKu8TkrhB9CPDbKP8NsL7pskiCbOv79LFZGdCAGXqlXhRnG0a2R0SWBsh0D9tsh/SYX9rAUpGhZgWpMHbqPosrgTrT+ORy25BBX4raKzRnv+RkxK6Hor4KxjMirbd3fCtWypEMCIOLh8VO3GRraLIVKPKV+DAM03nkXwbnexUiugan/HGGxdf98d0NnVZrRyiXCiG9NPSXVuTvBLim2JWToA==
x-ms-exchange-antispam-messagedata: Yse2htim+PlHP/Mc4MP47q3uJbQn93CcinVMGKRxuv7NscsspTwh3EKoGODpAlljjU41kHyaB0iV62j/giEQIJsw38auv/+FbBCxyYy+2e/QZON74fe9B/cfbXkLjTMenT0+Y0deoTl4FXPGPio1Hw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8bd4d1f-a583-4669-b0fe-08d7b470e07b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 12:48:39.0794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tRsOruYEPEGwXSOol6bOT0B9vVcJumAvGr4kZDTIVRQWZ9j0ZF8bAAXK5/VvmxJbqqAhzO1n0I3LPGooAmTaBwheGT79UB1GjCUhXD9leJHVYR60+/Dexu9fLakhsA8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+Pj4+PiBBcyBzdGF0ZWQgYWJvdmUsIGluIExpbnV4IE1DIGlzIGEgYnVzIChqdXN0IGxpa2Ug
UENJIGJ1cywgQU1CQSBidXMgZXRjKQ0KPiA+Pj4+PiBUaGVyZSBjYW4gYmUgbXVsdGlwbGUgZGV2
aWNlcyBhdHRhY2hlZCB0byB0aGlzIGJ1cy4gTW9yZW92ZXIsIHdlIGNhbg0KPiA+Pj4+IGR5bmFt
aWNhbGx5IGNyZWF0ZS9kZXN0cm95IHRoZXNlIGRldmljZXMuDQo+ID4+Pj4+IE5vdywgd2Ugd2Fu
dCB0byByZXByZXNlbnQgdGhpcyBCVVMgKG5vdCBpbmRpdmlkdWFsIGRldmljZXMgY29ubmVjdGVk
IHRvDQo+ID4+IGJ1cykNCj4gPj4+PiBpbiBJT1JUIHRhYmxlLg0KPiA+Pj4+PiBUaGUgb25seSBw
b3NzaWJsZSB3YXkgcmlnaHQgbm93IHdlIHNlZSBpcyB0aGF0IHdlIGRlc2NyaWJlIGl0IGFzIE5h
bWVkDQo+ID4+Pj4gY29tcG9uZW50cyBoYXZpbmcgYSBwb29sIG9mIElEIG1hcHBpbmdzLg0KPiA+
Pj4+PiBBcyBhbmQgd2hlbiBkZXZpY2VzIGFyZSBjcmVhdGVkIGFuZCBhdHRhY2hlZCB0byBidXMs
IHdlIHNpZnQgdGhyb3VnaCB0aGlzDQo+ID4+IHBvb2wNCj4gPj4+PiB0byBjb3JyZWN0bHkgZGV0
ZXJtaW5lIHRoZSBvdXRwdXQgSUQgZm9yIHRoZSBkZXZpY2UuDQo+ID4+Pj4+IE5vdyB0aGUgaW5w
dXQgSUQgdGhhdCB3ZSBwcm92aWRlLCBjYW4gY29tZSBmcm9tIGRldmljZSBpdHNlbGYuDQo+ID4+
Pj4+IFRoZW4gd2UgY2FuIHVzZSB0aGUgUGxhdGZvcm0gTVNJIGZyYW1ld29yayBmb3IgTUMgYnVz
IGRldmljZXMuDQo+ID4+Pj4NCj4gPj4+PiBTbyBhcmUgeW91IGFza2luZyBtZSBpZiB0aGF0J3Mg
T0sgPyBPciB0aGVyZSBpcyBzb21ldGhpbmcgeW91IGNhbid0DQo+ID4+Pj4gZGVzY3JpYmUgd2l0
aCBJT1JUID8NCj4gPj4+DQo+ID4+PiBJIGFtIGFza2luZyBpZiB0aGF0IHdvdWxkIGJlIGFjY2Vw
dGFibGU/DQo+ID4+PiBpLmUuIHdlIHJlcHJlc2VudCBNQyBidXMgYXMgTmFtZWQgY29tcG9uZW50
IGlzIElPUlQgdGFibGUgd2l0aCBhIHBvb2wgb2YNCj4gSURzDQo+ID4+ICh3aXRob3V0IHNpbmds
ZSBJRCBtYXBwaW5nIGZsYWcpDQo+ID4+PiBhbmQgdGhlbiB3ZSB1c2UgdGhlIFBsYXRmb3JtIE1T
SSBmcmFtZXdvcmsgZm9yIGFsbCBjaGlsZHJlbiBkZXZpY2VzIG9mIE1DDQo+ID4+IGJ1cy4NCj4g
Pj4+IE5vdGUgdGhhdCBpdCB3b3VsZCByZXF1aXJlIHRoZSBQbGF0Zm9ybSBNU0kgbGF5ZXIgdG8g
Y29ycmVjdGx5IHBhc3MgYW4gaW5wdXQNCj4gaWQNCj4gPj4gZm9yIGEgcGxhdGZvcm0gZGV2aWNl
IHRvIElPUlQgbGF5ZXIuDQo+ID4+DQo+ID4+IEhvdyBpcyB0aGlzIHNvbHZlZCBpbiBEVCA/IFlv
dSBkb24ndCBzZWVtIHRvIG5lZWQgYW55IERUIGJpbmRpbmcgb24gdG9wDQo+ID4+IG9mIHRoZSBt
c2ktcGFyZW50IHByb3BlcnR5LCB3aGljaCBpcyBlcXVpdmFsZW50IHRvIElPUlQgc2luZ2xlIG1h
cHBpbmdzDQo+ID4+IEFGQUlDUyBzbyBJIHdvdWxkIGxpa2UgdG8gdW5kZXJzdGFuZCB0aGUgd2hv
bGUgRFQgZmxvdyAoc28gdGhhdCBJDQo+ID4+IHVuZGVyc3RhbmQgaG93IHRoaXMgRlNMIGJ1cyB3
b3JrcykgYmVmb3JlIGNvbW1lbnRpbmcgYW55IGZ1cnRoZXIuDQo+ID4NCj4gPiBJbiBEVCBjYXNl
LCB3ZSBjcmVhdGUgdGhlIGRvbWFpbiBET01BSU5fQlVTX0ZTTF9NQ19NU0kgZm9yIE1DIGJ1cyBh
bmQNCj4gaXQncyBjaGlsZHJlbi4NCj4gPiBBbmQgdGhlbiB3aGVuIE1DIGNoaWxkIGRldmljZSBp
cyBjcmVhdGVkLCB3ZSBzZWFyY2ggdGhlICJtc2ktcGFyZW50Ig0KPiBwcm9wZXJ0eSBmcm9tIHRo
ZSBNQw0KPiA+IERUIG5vZGUgYW5kIGdldCB0aGUgSVRTIGFzc29jaWF0ZWQgd2l0aCBNQyBidXMu
IFRoZW4gd2Ugc2VhcmNoDQo+IERPTUFJTl9CVVNfRlNMX01DX01TSQ0KPiA+IG9uIHRoYXQgSVRT
LiBPbmNlIHdlIGZpbmQgdGhlIGRvbWFpbiwgd2UgY2FuIGNhbGwgbXNpX2RvbWFpbl9hbGxvY19p
cnFzIGZvcg0KPiB0aGF0IGRvbWFpbi4NCj4gPg0KPiA+IFRoaXMgaXMgZXhhY3RseSB3aGF0IHdl
IHRyaWVkIHRvIGRvIGluaXRpYWxseSB3aXRoIEFDUEkuIEJ1dCB0aGUgc2VhcmNoaW5nDQo+IERP
TUFJTl9CVVNfRlNMX01DX01TSQ0KPiA+IGFzc29jaWF0ZWQgdG8gYW4gSVRTLCBpcyBzb21ldGhp
bmcgdGhhdCBpcyBwYXJ0IG9mIGRyaXZlcnMvYWNwaS9hcm02NC9pb3J0LmMuDQo+ID4gKHNpbWls
YXIgdG8gRE9NQUlOX0JVU19QTEFURk9STV9NU0kgYW5kIERPTUFJTl9CVVNfUENJX01TSSkNCj4g
DQo+IENhbiB5b3UgaGF2ZSBhIGxvb2sgYXQgbWJpZ2VuIGRyaXZlciAoZHJpdmVycy9pcnFjaGlw
L2lycS1tYmlnZW4uYykgdG8gc2VlIGlmDQo+IGl0IGhlbHBzIHlvdT8NCj4gDQo+IG1iaWdlbiBp
cyBhbiBpcnEgY29udmVydGVyIHRvIGNvbnZlcnQgZGV2aWNlJ3Mgd2lyZWQgaW50ZXJydXB0cyBp
bnRvIE1TSQ0KPiAoY29ubmVjdGluZyB0byBJVFMpLCB3aGljaCB3aWxsIGFsbG9jIGEgYnVuY2gg
b2YgTVNJcyBmcm9tIElUUyBwbGF0Zm9ybSBNU0kNCj4gZG9tYWluIGF0IHRoZSBzZXR1cC4NCg0K
VW5mb3J0dW5hdGVseSB0aGlzIGlzIG5vdCB0aGUgc2FtZSBjYXNlIGFzIG91cnMuIEFzIEkgc2Vl
IEhpc2lsaWNvbiBJT1JUIHRhYmxlDQpJcyB1c2luZyBzaW5nbGUgaWQgbWFwcGluZyB3aXRoIG5h
bWVkIGNvbXBvbmVudHMuDQoNCmh0dHBzOi8vZ2l0aHViLmNvbS90aWFub2NvcmUvZWRrMi1wbGF0
Zm9ybXMvYmxvYi9tYXN0ZXIvU2lsaWNvbi9IaXNpbGljb24vSGkxNjE2L0QwNUFjcGlUYWJsZXMv
RDA1SW9ydC5hc2wjTDMwMA0KDQp3aGlsZSB3ZSBhcmUgbm90Og0KDQpodHRwczovL3NvdXJjZS5j
b2RlYXVyb3JhLm9yZy9leHRlcm5hbC9xb3JpcS9xb3JpcS1jb21wb25lbnRzL2VkazItcGxhdGZv
cm1zL3RyZWUvUGxhdGZvcm0vTlhQL0xYMjE2MGFSZGJQa2cvQWNwaVRhYmxlcy9Jb3J0LmFzbGM/
aD1MWDIxNjBfVUVGSV9BQ1BJX0VBUjEjbjI5MA0KDQpUaGlzIGlzIGJlY2F1c2UgYXMgSSBzYWlk
LCB3ZSBhcmUgdHJ5aW5nIHRvIHJlcHJlc2VudCBhIGJ1cyBpbiBJT1JUIHZpYSBuYW1lZCBjb21w
b25lbnRzIGFuZA0Kbm90IGluZGl2aWR1YWwgZGV2aWNlcyBjb25uZWN0ZWQgdG8gdGhhdCBidXMu
DQoNCj4gDQo+IFRoYW5rcw0KPiBIYW5qdW4NCg0K
