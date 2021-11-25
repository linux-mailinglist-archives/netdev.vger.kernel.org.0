Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7847445D815
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 11:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348831AbhKYKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 05:20:21 -0500
Received: from mail-os0jpn01on2121.outbound.protection.outlook.com ([40.107.113.121]:18290
        "EHLO JPN01-OS0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350040AbhKYKSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 05:18:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irDs9XLgFjycP0NkWwQQ/wf45WslrSpNF2qzS2XdlLUsF9ex6GO4ho+6iDdfg7so5CGsoWIQL8KvwPQ87dUu186b17GSCv9rG57hJZTW9InO59RoK0IjlrnnY6ET6yzfDRolw2GLvdyU49xHwNfN74bOCel76PwLIMGdqP+bRfszIO9S6uw1ZRjUbXOKvTKJc/tbpC0P0pOx8kybVLcUuvRykA+v22qrqRZGf5Q5hFld0SmwFPsnF6rDq5z7Orx/3EKT9Hj7mdNXgQlMusGmMwOHAwKt7Xlzoe0PCOp6CPp7XPm5JIbnps9pBU41yojacH9Pz407/Wb9+pB8SIBXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4opWQpZzxcLU5B5Tg9WNK9RbHS56z3YWLGJ1dsJc+yk=;
 b=dZEPQFXmTu7ZoM4SYfWCkHVD91E1MTmbRU5nHAza+km2rcxctRDXDizWMTF+5Xhcpr0IyY4izB5r+YiauBipE17a+zjlH9mwgiVJ2QstCN2fub74H8yt8DkboM6PLSIGPQ9K2nf4kEBIGVrjehPzcILWqQhfCJ2IgUcPHBLQkgD3/Yvc+oRpGgcDDmoQc/Q6I08y5Agw0ZztVvTCTGBWIfmOyWipPNThy6WdGAKjzmh8JfWSH1Pc7EVxJ6rR0B5jcjYSIkJEn6f71D8fFjTn9zb3RZCmJGwBBbuNyxNQg7SbMvgeSOdqPQFERXtpKAJ6Q+eMAQMyMPejohZv57UdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4opWQpZzxcLU5B5Tg9WNK9RbHS56z3YWLGJ1dsJc+yk=;
 b=El010JIf99lx8zLkSLmV4ESPU9PStxEna81rW98X4imNfabxOv+QAG6Lh+7/2LWBFpJj2C2AZSuHsZwcwlbwRACPNRKELSbmu7GIuRyEniqTdLh2MnF5kofVuMP9uLs0PkZ0G2GVBo09T4wWs5uXGSURTablFY8USU/ECrnMZjA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5441.jpnprd01.prod.outlook.com (2603:1096:604:a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 25 Nov
 2021 10:15:26 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c0bd:405a:cdd3:f153]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c0bd:405a:cdd3:f153%9]) with mapi id 15.20.4713.027; Thu, 25 Nov 2021
 10:15:25 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC 2/2] ravb: Add Rx checksum offload support
Thread-Topic: [RFC 2/2] ravb: Add Rx checksum offload support
Thread-Index: AQHX4G6Emzh94LJ00ESfpS9HZfXtlqwTHd+AgADnsyA=
Date:   Thu, 25 Nov 2021 10:15:24 +0000
Message-ID: <OS0PR01MB592276607BD57AD29DEDB57F86629@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
 <20211123133157.21829-3-biju.das.jz@bp.renesas.com>
 <912abe7c-3097-4d39-01b6-82385f001fa8@omp.ru>
In-Reply-To: <912abe7c-3097-4d39-01b6-82385f001fa8@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00590670-ee07-4910-9a27-08d9affc7f48
x-ms-traffictypediagnostic: OS0PR01MB5441:
x-microsoft-antispam-prvs: <OS0PR01MB5441B7FF412417561FB8F5C586629@OS0PR01MB5441.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bGSAg0b69Oq6UDCv1ZX1+NG9u4Ex/l9crLEAJDiK1ug0Y3E3tYcOoiA1d3rrZKZf/ABYnHvuDNeGfsfWRDT7prEFolN2bqm2yxsVr+ZbRvi/JEIfXkThSENxC8ZeGS1CcJeSeMLWG+NPuBxlG7kFiW9z49oe1yAbtZ2B+W5Qel01QVCQarOOPg6+IfKq55JBW7b1UnFvYtxgwOWemF0IZ8LJsD9n1cWwElZ1+21TTsGLAPhHpsbqnosb7CQ9sNigyQFyJNmPJBKY7vMp5Inq3c9zHroHNopEkExYjcL1octeOUHcdeMCDH/ECXds5b3kOWfvebS9UGWPcOM9L8K7C6fo1OhyWBwjL1f+R5Mn3Z601IlerLnJszibKAejLaeTN+YRhLkQ/Hj0P5KuseFIDevBCYGVT8LBIkCD2v6JAXeEQpEK5rQ9GSUVOwkLl7LAtBz89neDNKaBMXBoSAhNS1BMAKFzYNH0qQ+hOZseUJfZGXkFdUXpqzk1kpA4XUXrDSY42eMv+y8jYA+6UTCrnIBE6Zlvt0CzoxCIZbO8NyQRRmYOfQY409DBpnhwu0B4rnc2ZyYqdHIvDL9+ZkiGNSo3G+Mxzq9VfSM8NxaLYdcLoXtCx2qPWfwLOz/lWSBuc1Ougk92bz3eJ3ndRQfNRdqLfWuBKYDWtf4BJCRwyGfxuGm7oF1zICSO38tXwo+B2OrLfQOQbZ/aYIGKlwV/JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(186003)(86362001)(8676002)(107886003)(66446008)(122000001)(508600001)(2906002)(38100700002)(33656002)(5660300002)(26005)(64756008)(316002)(54906003)(9686003)(76116006)(6506007)(8936002)(71200400001)(55016003)(110136005)(66556008)(66476007)(7696005)(38070700005)(53546011)(4326008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWxjRU4vNFR2L3N4YUxUaG1YL0I0SFdWa1phd2owM29vUFV5U0Fwdzl2WGR2?=
 =?utf-8?B?b25vRUwxYSszNnZyb1plaUNpQU1lWERnc0dMREYxR1JlNE9EUEJxVlIxQWFC?=
 =?utf-8?B?NUVCaEIrMGJ0SXNIUXdtRGx0Z0dURDQ0K2xzSm4yd0d4dXlaajZuRTBMY2xD?=
 =?utf-8?B?c0JaT1BpZTFudHYvSXJ5bmk2Y2FnY1IveFF2aUxmak4xN05aYkEwQTNhczNL?=
 =?utf-8?B?SGxBVTFMalhiS0w4L21VN2dZYUpWbEpYL01xVXFCN3oxeFdHWDkwVmZrSWpy?=
 =?utf-8?B?bEtqODh6Zko1bTlOSlNGWlBvVXlkeEFOeENXbDc1WFFybVQ0UDgwME5SQ0ds?=
 =?utf-8?B?Y1ZCT1R5WTBZWHgxUWgxS3UrcjQyUUVTeUd2bDdNV2FTK1ZvSU93Y0Y5d3RU?=
 =?utf-8?B?L1FCdm5IOVhkS2JPWStHbFZ3NWxmRE1wUlhGTTROZFNFL0sxTnJ2MGJSTVdJ?=
 =?utf-8?B?dVVoL20zU3RJQU0zSkJuRVJ6aTg2aWd0VjZGajFLMjRTMHVvUlFJdnZBc2VY?=
 =?utf-8?B?VWV1V01DUjYwMkV6T3J2bTNSMlpRWTJPV0U4NVBFQ05mcGtLRWRoKzAxNDJZ?=
 =?utf-8?B?M295VkxHZzlyLzZYTlJOUzh1NDI0TkROc2hWTmhDRlBKd2NIc3hnMGlxeU5j?=
 =?utf-8?B?YkRQQXlzV2ZLLytJc0wra3o2RGE5LytUVVlFN1l3QU5VMVpjcnEwN1lyVmlB?=
 =?utf-8?B?NlZnNjlFUlhSNmlLVCtFejZ5SXRKYXdUZkNtem5rdlQ4bmtEeXhNUS9qMllU?=
 =?utf-8?B?STFUWjR5d2xtUXl6eit6Rkc1SnFWeDNEZjNJbEVhcGNuUDFRYmdQTFFiL3Ru?=
 =?utf-8?B?c2FmeDVXVWo0Q1lZS1RLZW44bFVyM0lZaUt3dUI0bWhtbkhxeTQya3B2U1N0?=
 =?utf-8?B?dGs5aTBHSzkvbUkwcWluc0lzS2FIVlJxOWVUSkZ5aE1kUzVLU2o4MVVzRzNY?=
 =?utf-8?B?QlV4NDlPdGpOLzR5b3Y0dCtMYzRwOFhyYmtkQzRqN1d6dVJLUTZ3by9vUDBo?=
 =?utf-8?B?eXArbGFLOHZpMHR6VGx3WUg3cVRtYUIxTlV3NEdOVGx4cGVLQWVES3VUV1ZY?=
 =?utf-8?B?bDJ6L1VpMTF2TG02ay9kLzR5RlZlVUpVTDdJZ3VhK092cEFxMVBDMmRlSHYx?=
 =?utf-8?B?NmdoZldYa3FnS2tvV3BmVG1pS2FnSVpJV0tOV1piRzkwdTZaYzVpQ25ubThh?=
 =?utf-8?B?eWxjbHl0dlppaVZCZUtVWG1SN0pJTm9tUWpxSFZYck1POGRoVEd1VlNFWHNC?=
 =?utf-8?B?T1hESjFSOUxjTHFNOHVOMUlLSkJWeDhZMVEvNkZ3TW50K3crcmxQcW9WVXZk?=
 =?utf-8?B?c0lDYktXdTF1SkFXQVdiTUZLbnc3dXFLNE1VQ3dOcHg5c3hLOGI2RU1PK0VP?=
 =?utf-8?B?R3JJSHEzZFFRQkNONnluVllGcUt1RnJnMnNVYnlnZ0M5MjJaWnJGNW1Ldk9k?=
 =?utf-8?B?WjVxbnRPSlJxSksyMm95ZjNucFBDZkpXUW15d3RhYndiWXRhTnA1eVgvdkxi?=
 =?utf-8?B?QnZXSlVVdjc2Q0U4cDE3Mkt2dmpMbW9HQXB5d25VdDB6SzZIMjBiM3NGSFhY?=
 =?utf-8?B?YUtYa3FpeG53WURsR2F5V05QRGZBUXllVzhUck4yZlczeURrZnhwVldpVHlS?=
 =?utf-8?B?OW1sajlmbWk0UnJBb2xwYmIxd0o0SUxhQTF3dWxxSFNUSjRDWVd6bmIwR2JS?=
 =?utf-8?B?T2orbkg3NFgxa3JZZVFWWFJiSFpUdTY4V3BvZDBaL01nczY2NzQ5d3ZBeTV6?=
 =?utf-8?B?bklXbkI0RFNWTmNvd0ZKSjlzeHBWZHdtL2YxUDN4cC9RM20wZW1vM3A3Q3FN?=
 =?utf-8?B?UGtmOVNqd3MxcUMvbVowRTNzdng1V01hLzdGTzU5QjlMZzRkSVhjb0Rhb0h4?=
 =?utf-8?B?UDJYWG5GTjkzTHVDZ0xmRGp4eXRBdC9pZWN0ZHdjMnYwbm1wakQ2eU55RDJy?=
 =?utf-8?B?L2ZkMnlmWE5iUDVmYVc4L0V1TldPZDhQRHlqK0Vjd0t2bkc0MzV5ajNrWWJQ?=
 =?utf-8?B?dk9Cemc1VEt3UDQ0NGtLdXdaTVFSR1UycXgyTkc2NS8wNm1EK2NxUGVIcEw1?=
 =?utf-8?B?a0tCQkZMNXU2TGxHWXJyVWNQSXVkeStuZ1ROUXFrVjFNRmxqUWRCZjhsZGcv?=
 =?utf-8?B?aG9rZ0lEK0pQQmtsYnozQkpXYUoyREZBVEd3ZGVOYmJYZnQrQ1d0dUpVd05i?=
 =?utf-8?B?MmRKUTdkU1pRTlBJd29NSnY3QTR2ZEVIK2hzUzFqb1Roc2FNTUFQSlNzRlNw?=
 =?utf-8?B?QzhSN3Ayc2xVcEpIbyt4TVc3TXlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00590670-ee07-4910-9a27-08d9affc7f48
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 10:15:25.0335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cokS8HW+tCt1Q8/Gmva8PJ25WFVXeYD76dlBoF2Cwp24MNg2yz2pndLxQpRe7/U8UDV69nNwyWS+QeIHJ99EqacsZ7MWIyYfiVxoYqkTZ6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5IFNodHlseW92LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDIvMl0gcmF2YjogQWRk
IFJ4IGNoZWNrc3VtIG9mZmxvYWQgc3VwcG9ydA0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiAxMS8y
My8yMSA0OjMxIFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gVE9FIGhhcyBodyBzdXBwb3J0
IGZvciBjYWxjdWxhdGluZyBJUCBoZWFkZXIgY2hlY2t1bSBmb3IgSVBWNCBhbmQNCj4gPiBUQ1Av
VURQL0lDTVAgY2hlY2tzdW0gZm9yIGJvdGggSVBWNCBhbmQgSVBWNi4NCj4gPg0KPiA+IFRoaXMg
cGF0Y2ggYWRkcyBSeCBjaGVja3N1bSBvZmZsb2FkIHN1cHBvcnRlZCBieSBUT0UuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+
ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAg
NCArKysNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDMx
DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzUg
aW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+IGluZGV4IGE5NjU1MjM0OGUyZC4uZDBlNWVlYzA2MzZlIDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAtNDQsNiArNDQsMTAgQEANCj4gPiAg
I2RlZmluZSBSQVZCX1JYVFNUQU1QX1RZUEVfQUxMCTB4MDAwMDAwMDYNCj4gPiAgI2RlZmluZSBS
QVZCX1JYVFNUQU1QX0VOQUJMRUQJMHgwMDAwMDAxMAkvKiBFbmFibGUgUlggdGltZXN0YW1waW5n
DQo+ICovDQo+ID4NCj4gPiArLyogR2JFdGhlcm5ldCBUT0UgaGFyZHdhcmUgY2hlY2tzdW0gdmFs
dWVzICovDQo+ID4gKyNkZWZpbmUgVE9FX1JYX0NTVU1fT0sJCTB4MDAwMA0KPiA+ICsjZGVmaW5l
IFRPRV9SWF9DU1VNX1VOU1VQUE9SVEVECTB4RkZGRg0KPiANCj4gICAgVGhlc2UgYXJlIGhhcmRs
eSBuZWVkZWQgSU1PLg0KDQpPSy4NCg0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IGMyYjkyYzZhNmNkMi4uMjUz
M2UzNDAxNTkzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gQEAgLTcyMCw2ICs3MjAsMzMgQEAgc3RhdGljIHZvaWQgcmF2Yl9nZXRfdHhf
dHN0YW1wKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZGV2KQ0KPiA+ICAJfQ0KPiA+ICB9DQo+ID4N
Cj4gPiArc3RhdGljIHZvaWQgcmF2Yl9yeF9jc3VtX2diZXRoKHN0cnVjdCBza19idWZmICpza2Ip
IHsNCj4gPiArCXUzMiBjc3VtX2lwX2hkciwgY3N1bV9wcm90bzsNCj4gDQo+ICAgIFdoeSB1MzIg
aWYgYm90aCBzdW1zIGFyZSAxNi1iaXQ/DQpPSywgd2lsbCBtYWtlIGl0IDE2LWJpdC4NCg0KPiAN
Cj4gPiArCXU4ICpod19jc3VtOw0KPiA+ICsNCj4gPiArCS8qIFRoZSBoYXJkd2FyZSBjaGVja3N1
bSBpcyBjb250YWluZWQgaW4gc2l6ZW9mKF9fc3VtMTYpICogMiA9IDQNCj4gYnl0ZXMNCj4gPiAr
CSAqIGFwcGVuZGVkIHRvIHBhY2tldCBkYXRhLiBGaXJzdCAyIGJ5dGVzIGlzIGlwIGhlYWRlciBj
c3VtIGFuZCBsYXN0DQo+ID4gKwkgKiAyIGJ5dGVzIGlzIHByb3RvY29sIGNzdW0uDQo+ID4gKwkg
Ki8NCj4gPiArCWlmICh1bmxpa2VseShza2ItPmxlbiA8IHNpemVvZihfX3N1bTE2KSAqIDIpKQ0K
PiA+ICsJCXJldHVybjsNCj4gPiArCWh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSBz
aXplb2YoX19zdW0xNik7DQo+ID4gKwljc3VtX3Byb3RvID0gY3N1bV91bmZvbGQoKF9fZm9yY2UN
Cj4gPiArX19zdW0xNilnZXRfdW5hbGlnbmVkX2xlMTYoaHdfY3N1bSkpOw0KPiA+ICsNCj4gPiAr
CWh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSAyICogc2l6ZW9mKF9fc3VtMTYpOw0K
PiA+ICsJY3N1bV9pcF9oZHIgPSBjc3VtX3VuZm9sZCgoX19mb3JjZQ0KPiA+ICtfX3N1bTE2KWdl
dF91bmFsaWduZWRfbGUxNihod19jc3VtKSk7DQo+ID4gKw0KPiA+ICsJc2tiLT5pcF9zdW1tZWQg
PSBDSEVDS1NVTV9OT05FOw0KPiA+ICsJaWYgKGNzdW1fcHJvdG8gPT0gVE9FX1JYX0NTVU1fT0sp
IHsNCj4gPiArCQlpZiAoc2tiLT5wcm90b2NvbCA9PSBodG9ucyhFVEhfUF9JUCkgJiYgY3N1bV9p
cF9oZHIgPT0NCj4gVE9FX1JYX0NTVU1fT0spDQo+ID4gKwkJCXNrYi0+aXBfc3VtbWVkID0gQ0hF
Q0tTVU1fVU5ORUNFU1NBUlk7DQo+ID4gKwkJZWxzZSBpZiAoc2tiLT5wcm90b2NvbCA9PSBodG9u
cyhFVEhfUF9JUFY2KSAmJg0KPiA+ICsJCQkgY3N1bV9pcF9oZHIgPT0gVE9FX1JYX0NTVU1fVU5T
VVBQT1JURUQpDQo+ID4gKwkJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fVU5ORUNFU1NBUlk7
DQo+IA0KPiAgICBDaGVja3N1bSBpcyB1bnN1cHBvcnRlZCBhbmQgeW91IGRlY2xhcmUgaXQgdW5u
ZWNlc3Nhcnk/DQoNCg0KRG8geW91IG1lYW4gdGFrZW91dCB0aGUgY2hlY2sgZm9yIHVuc3VwcG9y
dGVkIGhlYWRlcmNzdW0gZm9yIElQVjYgYW5kIHRoZSBjb2RlIGxpa2Ugb25lIGJlbG93Pw0KDQpJ
ZighY3N1bV9wcm90bykgew0KCWlmICgoc2tiLT5wcm90b2NvbCA9PSBodG9ucyhFVEhfUF9JUCkg
JiYgIWNzdW1faXBfaGRyKSB8fCBza2ItPnByb3RvY29sID09IGh0b25zKEVUSF9QX0lQVjYpKQ0K
CQlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX1VOTkVDRVNTQVJZOw0KfQ0KDQpTbmlwcGV0IGZy
b20gSC9XIG1hbnVhbCBmb3IgcmVjZXB0aW9uIGhhbmRsaW5nDQoNCigxKSBSZWNlcHRpb24gSGFu
ZGxpbmcNClRoZSByZXN1bHQgb2YgQ2hlY2tzdW0gQ2FsY3VsYXRpb24gaXMgYXR0YWNoZWQgdG8g
bGFzdCA0IGJ5dGUgb2YgRXRoZXJuZXQgRnJhbWVzIGxpa2UgRmlndXJlIDMwLjI1LiBBbmQgdGhl
biB0aGUgDQpoYW5kbGVkIGZyYW1lcyBhcmUgdHJhbnNmZXJyZWQgdG8gbWVtb3J5IGJ5IERNQUMu
IElmIHRoZSBmcmFtZSBkb2VzIG5vdCBoYXZlIGNoZWNrc3VtIGVycm9yIGF0IHRoZSBwYXJ0IG9m
IElQdjQgDQpIZWFkZXIgb3IgVENQL1VEUC9JQ01QLCB0aGUgdmFsdWUgb2Yg4oCcMDAwMGjigJ0g
aXMgYXR0YWNoZWQgdG8gZWFjaCBwYXJ0IGFzIHRoZSByZXN1bHQgb2YgQ2hlY2tzdW0gQ2FsY3Vs
YXRpb24uIFRoZSANCmNhc2Ugb2YgVW5zdXBwb3J0ZWQgRnJhbWUsIHRoZSB2YWx1ZSBvZiDigJxG
RkZGaOKAnSBpcyBhdHRhY2hlZC4gRm9yIGV4YW1wbGUsIGlmIHRoZSBwYXJ0IG9mIElQIEhlYWRl
ciBpcyB1bnN1cHBvcnRlZCwgDQrigJxGRkZGaOKAnSBpcyBzZXQgdG8gYm90aCBmaWVsZCBvZiBJ
UHY0IEhlYWRlciBhbmQgVENQL1VEUC9JQ01QLiBUaGUgY2FzZSBvZiBJUHY2LCBJUHY0IEhlYWRl
ciBmaWVsZCBpcyBhbHdheXMgc2V0IHRvIA0K4oCcRkZGRmjigJ0uIA0KDQogDQo+IA0KPiA+ICsJ
fQ0KPiANCj4gICAgTm93IHdoZXJlJ3MgYSBjYWxsIHRvIHNrYl90cmltKCk/DQoNCkN1cnJlbnRs
eSBJIGhhdmVuJ3Qgc2VlbiBhbnkgaXNzdWUgd2l0aG91dCB1c2luZyBza2JfdHJpbS4NCg0KT0ss
IGFzIHlvdSBzdWdnZXN0ZWQsIHdpbGwgY2hlY2sgYW5kIGFkZCBza2JfdHJpbSB0byB0YWtlb3V0
IHRoZSBsYXN0IDRieXRlcy4NCg0KUmVnYXJkcywNCkJpanUNCg==
