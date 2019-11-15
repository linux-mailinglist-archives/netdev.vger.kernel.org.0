Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7AFD1CC
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 01:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKOAEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 19:04:23 -0500
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:16455
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfKOAEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 19:04:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YklHV3stnHFG6Z8fanTwA+dZFHgByLsinYmB/BSzItjtgXUld/rFNxvT0uEHoOMoonv+1UNQV94qHp1wOJyxWSZPv74Eid3VS6i/9mu4x2lJIgrM7T4+zMrDzDaIOUhZnEh/rAZWZXS9ooG2spgs4SYkhtx9f5BdW6RDnq0dOwPKRTDViikiS0+9w2WXV0x/ir/9NEeeQlECd30Efex3CzITgyiyWYFbsMC7oSKtnoCzRHao2pdzeb3zg1SuHTmgva6Jolepdiw/noFlPza2bLABZO9uHcMCHRQJSfDsSxa+n049U6lRZqB7ByPpDJvMb2z1DeFJhCjh4/8wywAzdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoiQqo/hezt/bdJr7j4UZ39NP9aMGKgdZxjdHmqODMk=;
 b=JslHrFB0qoxHcrT1Cy81N65gxnzdk6lItKdf5CpiUSdPL8PuZLBaqMXBFxPBEjbvTNC1RUompfjITc9r/YlHKqSltgR9hbeId0/rdgL4XGy17guNfCFwTIS53+/4BhvI8mSKa5lCTOmxKuYDQd1nhO7evfgiJ1xY8eydiejG4vsgaa0Vls7/q+LZZiXrmwIgsrpIVbCvePE7SvjEOR0/L8j4sSVRtDNvmb4IwpwyK+f7VqEqfFkh9ngNdz0WYMiCDGRcxe3fPAJ6YiC0vLRrNRNiyOgYPCHmdspKtRrrxhyCO/8Soz57vGLd9S50erOq4F1MCwsQ1gGEybhSo5lxtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoiQqo/hezt/bdJr7j4UZ39NP9aMGKgdZxjdHmqODMk=;
 b=i6T5IPFoi7oWbmEKICHj98/aiO68pxHbiqtgJOHsTGN9AzFMF6Gy5rshpX3zqpr6niFo8A0eCTceOOe9FJCTUWHPnLu0bnVvCo8BYKoaJmQCtFc/9gveFMAMKX2JhKCrpfFmWfY4TsOpvCGTfpvAkRN/Ikd1Z+KrK/1mxNpK02U=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5776.eurprd05.prod.outlook.com (20.178.122.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Fri, 15 Nov 2019 00:04:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Fri, 15 Nov 2019
 00:04:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "christopher.s.hall@intel.com" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "stefan.sorensen@spectralink.com" <stefan.sorensen@spectralink.com>,
        "brandon.streiff@ni.com" <brandon.streiff@ni.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH net 12/13] mlx5: Reject requests to enable time stamping
 on both edges.
Thread-Topic: [PATCH net 12/13] mlx5: Reject requests to enable time stamping
 on both edges.
Thread-Index: AQHVmxuzvm7+hsz/F06moyyH5jeV/6eLWjqA
Date:   Fri, 15 Nov 2019 00:04:19 +0000
Message-ID: <23131f95a2afeb32e49d4db797855b17ea24444e.camel@mellanox.com>
References: <20191114184507.18937-13-richardcochran@gmail.com>
In-Reply-To: <20191114184507.18937-13-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ceaf25c5-6e0e-41b3-6c4c-08d7695f5cb1
x-ms-traffictypediagnostic: VI1PR05MB5776:|VI1PR05MB5776:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5776163640AAC564609E6A6FBE700@VI1PR05MB5776.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(189003)(199004)(71190400001)(2906002)(4326008)(6512007)(91956017)(58126008)(66946007)(110136005)(4001150100001)(66066001)(54906003)(76116006)(118296001)(305945005)(7416002)(14454004)(7736002)(6246003)(36756003)(6436002)(2501003)(478600001)(76176011)(6486002)(486006)(66446008)(64756008)(66556008)(66476007)(71200400001)(446003)(14444005)(316002)(81166006)(81156014)(229853002)(5660300002)(6506007)(476003)(8936002)(2616005)(25786009)(26005)(102836004)(186003)(99286004)(256004)(8676002)(6116002)(3846002)(86362001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5776;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pdaRKI9QC+PE1/DYzwRZi80GRPBnau0LzuUROt48ym4OGyfxCB/nbhRlRyhkyHyptoUkw0RNMBJlakDDQIIGFJv2Tp4Pmzk3XKuU17LgfkuqlkY49U9feTq+Bb+Ex2KmCIA0GloETC4dHOCwyeev5o7FgsS3vQ4O9sDViZPz8h43QM+P2W0tw2ji8/ttFLuE/4bdNwyQ4GSb+R/OutaGyj8Bby3eFAuPz9DQLRFT/sxiP8uEQY50Hu94wFFFlk6hDXTWDU0FGILmgehY/RRoZSeqHLG0IiIg/NO0G3Ie1w/jzzsGOvepptTwa1zo9Wx0+80BTYALtC0uSIcchn+lgIlmGK9xoDTEZoUS1LobLv1SJW3TOUcUcVgxX4mwwGb72hTT2bljYZ3guW6aASkGyOxgkiJFxCE+aLB+zg/pObLtgRa2IbKkrlOrOqWtyKK6
Content-Type: text/plain; charset="utf-8"
Content-ID: <45CDF6797FA10B4F9FCC56755697FFDA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceaf25c5-6e0e-41b3-6c4c-08d7695f5cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 00:04:19.3306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +SGWka8+MnzpLOlo2J5ya6nJJDUbW/S0qAlHwjOVGdRbGkJkJ7JYC7Chx0AqLgxOrYm/RjxgShtE3JvBLIrpDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5776
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTE0IGF0IDEwOjQ1IC0wODAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6
DQo+IFRoaXMgZHJpdmVyIGVuYWJsZXMgcmlzaW5nIGVkZ2Ugb3IgZmFsbGluZyBlZGdlLCBidXQg
bm90IGJvdGgsIGFuZCBzbw0KPiB0aGlzIHBhdGNoIHZhbGlkYXRlcyB0aGF0IHRoZSByZXF1ZXN0
IGNvbnRhaW5zIG9ubHkgb25lIG9mIHRoZSB0d28NCj4gZWRnZXMuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gLS0tDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2Nsb2NrLmMgfCA2
ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvY2xvY2su
Yw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvY2xvY2su
Yw0KPiBpbmRleCA4MTkwOTdkOWI1ODMuLjQzZjk3NjAxYjUwMCAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9jbG9jay5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvY2xvY2suYw0KPiBA
QCAtMjQzLDYgKzI0MywxMiBAQCBzdGF0aWMgaW50IG1seDVfZXh0dHNfY29uZmlndXJlKHN0cnVj
dA0KPiBwdHBfY2xvY2tfaW5mbyAqcHRwLA0KPiAgCQkJCVBUUF9TVFJJQ1RfRkxBR1MpKQ0KPiAg
CQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICANCj4gKwkvKiBSZWplY3QgcmVxdWVzdHMgdG8gZW5h
YmxlIHRpbWUgc3RhbXBpbmcgb24gYm90aCBlZGdlcy4gKi8NCj4gKwlpZiAoKHJxLT5leHR0cy5m
bGFncyAmIFBUUF9TVFJJQ1RfRkxBR1MpICYmDQo+ICsJICAgIChycS0+ZXh0dHMuZmxhZ3MgJiBQ
VFBfRU5BQkxFX0ZFQVRVUkUpICYmDQo+ICsJICAgIChycS0+ZXh0dHMuZmxhZ3MgJiBQVFBfRVhU
VFNfRURHRVMpID09IFBUUF9FWFRUU19FREdFUykNCj4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0K
PiArDQo+ICAJaWYgKHJxLT5leHR0cy5pbmRleCA+PSBjbG9jay0+cHRwX2luZm8ubl9waW5zKQ0K
PiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gIA0KDQoNClJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVl
ZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0K
