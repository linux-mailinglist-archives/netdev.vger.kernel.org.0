Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0553228BE4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgGUWSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:18:23 -0400
Received: from mail-dm6nam11on2103.outbound.protection.outlook.com ([40.107.223.103]:64480
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726658AbgGUWSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 18:18:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/m09SWKXHp64JIzcVIFmOG5OOOj4PO6roC9EkWt4s7w8ZF69eTOn0zLS4MlGrLAsbWSUAjiyDOOMwcAei1TGqNreeI/Lq58dvTU0pxlFWsEKHGBQn37zvXi4Aeze/qBPMTzJGR+a5Z4g5WDO+FuGbV2FVPRWfbxg5kUOgazLKoFr/xgG1b5fHhqZNhgF7IvWur0MvDtQH5z9fY/DUeaQtplk/4a0QP99snP63vHy1MrJ6AOUYVcxkHNVOhLPBpQI458exE3dQOd485vuj4bIj3or7mKWuU4mGdFGcvcEP2cj2NulRIauDvK3fui/MHk+FtQAI2xtmwvG3Pr+pxRHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM32M47G+qBC1f13+dMokFGo7ZvtwnPEa9dnHu2OiOs=;
 b=YxL5LAcvUUSDPiSy8aWaPJ4frripzYl7d0195YlI1bCmHn3pR47l6OtyWFtB3Sms/cJzAY3Hmu3T79OvDQrkRs/itd/53QFDJSy+7wAk1SYMdF/5ErIKPlp8hXDswBG37koYRK6rSqFQo3cCPiAsagMlXJEr6T9ov8nQ9WGlgrXXMI3ecnjIl3BuorsxXsLhAO27dxL/BV0ppjR94pVAXy6kt1glnzofNxqsMvhdAOc6VYGwuuOmmIpemKtqzBwKaofrQu5gBm5k8Bow24SWQ26bKuE2Wm3mJFGmnrif0Ydqj5EERF7vqgnt6r7y+KdUAduf0gF0Qvs+X+jWVIA/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eM32M47G+qBC1f13+dMokFGo7ZvtwnPEa9dnHu2OiOs=;
 b=gow/0vlSB3bOzrzXMbkGv0GuvYm/G+dfsPdvZNPHw2je/POWYoCo73qU0Hc93CWfHHsIjBRPN6kT/Q0or8ft2HO/VoQRxdhTkSQULZxPCeMBmP6aHrqRHKK9XO3FVvAQLOqfC7pinTVp2YfmPk4pMqzXJ3aVuPn3g4uyZmfyOXA=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by MN2PR21MB1485.namprd21.prod.outlook.com
 (2603:10b6:208:205::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.5; Tue, 21 Jul
 2020 22:18:19 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.007; Tue, 21 Jul 2020
 22:18:19 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>,
        David Miller <davem@davemloft.net>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>,
        "Umesha G M (ugm)" <ugm@cisco.com>,
        "Niranjan M M (nimm)" <nimm@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Topic: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Index: AQHWXrU+cNEwHb7+0Uu0LFIibsmHIakRHT0AgACBNYCAAPll4A==
Date:   Tue, 21 Jul 2020 22:18:19 +0000
Message-ID: <BL0PR2101MB0930B942CE2E4EB875EC38C2CA780@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200720164551.14153-1-srirakr2@cisco.com>
 <20200720.162726.1756372964350832473.davem@davemloft.net>
 <292C3F77-60F5-4D24-8541-BCAE88C836AF@cisco.com>
In-Reply-To: <292C3F77-60F5-4D24-8541-BCAE88C836AF@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-21T22:18:18Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fea6b24a-7626-4acb-b693-05a572b613a6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 133155a5-b836-4e40-afd1-08d82dc3f950
x-ms-traffictypediagnostic: MN2PR21MB1485:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1485BA1AE30440EA5F5EBCF7CA780@MN2PR21MB1485.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d6PDJ2YQAJu+mzH8GLaCfitVtUFCbYLMnOY4wUJ+q+WqGTG+HMfufDDqok64tjdYq6IGraRg8V5ZEjnbvTXJyZ0FhCJPKvtq77OtxA6/mN98U6whb5cbRxLJiMrbI3b6FR5h/6mS5/00tlnIRMQuZQXBC13nf6L1L4cyfr1SGuHuYt7ATwdIUF4zadQMoo4qjoQsN5DSFrE/aU1oTlkYO07HyeKds63MxtC6EROv/yt0liVwp8W8SBVfr6lq+UQlJUsb4cw0vkCQj1KDTiJyBMvGL+Yjr3rUPPQXJmFysxqUIuToSdRSqQqZBpGcm4ZI/oOWcFl9Ew+ClRLQgc/AbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(6506007)(9686003)(82950400001)(82960400001)(53546011)(8990500004)(10290500003)(55016002)(54906003)(478600001)(8936002)(71200400001)(7416002)(86362001)(7696005)(2906002)(316002)(4326008)(5660300002)(186003)(66446008)(33656002)(76116006)(66476007)(26005)(66556008)(66946007)(64756008)(52536014)(8676002)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kJhTE2yiDRLoNEI+i0PvUJ4RAOtDNZa64aPZdeueQHY8rZ1ibb0C8h7KHorKXV7JzO/mo7eLxQKZ6MD2SUqIcyorxc4JFfwK5efkPiVw7wS0GusCrMbqHQWfqhjWDfUGt3piCocXEuuGILWpu8vt9zQneew936fK3EyXG92S4LCxhNKizGsz/+YSm40s1WHDCBkaiiBsAY50htRdu9shLaFoAmley+euUY0XRNzPnMUiRvu0Uc1zqKRucgQAWM0ySwzKo0tn+ET0+EKg0zsFvy/kAZKnFU+BbcUmN7rKhqgcoiiGJnMTzCp0zuVnlFskY/0dJgO+DOUPO7JrAOmOOw/NuBF5QeHmPCui2+qH0as7pYCJY/a2gh2NRqMHx7HJLPr+tRrGUzkXyPOwp/RTzL9JkjwU5GAMWu1GlQPXqqA38shx+9CxUT8c5J/bUjWIuiZfWVHBeh4oPsLhIAP/RqvOWcKrRKkNapbfDbQoQRc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133155a5-b836-4e40-afd1-08d82dc3f950
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 22:18:19.5933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GBb+xq1iitf3xqlWGMfKAv4/3yzaX1L3AQKxK5GONiZ7H5Owa62bdx3zQ4nFyXDk4VTWnKBZkkc9IGPPEWB+Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3JpcmFtIEtyaXNobmFu
IChzcmlyYWtyMikgPHNyaXJha3IyQGNpc2NvLmNvbT4NCj4gU2VudDogVHVlc2RheSwgSnVseSAy
MSwgMjAyMCAzOjEwIEFNDQo+IFRvOiBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
DQo+IENjOiBLWSBTcmluaXZhc2FuIDxreXNAbWljcm9zb2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcN
Cj4gPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBTdGVwaGVuIEhlbW1pbmdlciA8c3RoZW1taW5A
bWljcm9zb2Z0LmNvbT47DQo+IHdlaS5saXVAa2VybmVsLm9yZzsgTWFsY29sbSBCdW1nYXJkbmVy
IChtYnVtZ2FyZCkNCj4gPG1idW1nYXJkQGNpc2NvLmNvbT47IFVtZXNoYSBHIE0gKHVnbSkgPHVn
bUBjaXNjby5jb20+OyBOaXJhbmphbiBNDQo+IE0gKG5pbW0pIDxuaW1tQGNpc2NvLmNvbT47IHhl
LWxpbnV4LWV4dGVybmFsKG1haWxlciBsaXN0KSA8eGUtbGludXgtDQo+IGV4dGVybmFsQGNpc2Nv
LmNvbT47IGt1YmFAa2VybmVsLm9yZzsgbGludXgtaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsNCj4g
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIHYzXSBuZXQ6IGh5cGVydjogYWRkIHN1cHBvcnQgZm9yIHZsYW5z
IGluIG5ldHZzYyBkcml2ZXINCj4gDQo+IA0KPiANCj4g77u/T24gMjEvMDcvMjAsIDQ6NTcgQU0s
ICJEYXZpZCBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PiB3cm90ZToNCj4gDQo+ICAgICBG
cm9tOiBTcmlyYW0gS3Jpc2huYW4gPHNyaXJha3IyQGNpc2NvLmNvbT4NCj4gICAgIERhdGU6IE1v
biwgMjAgSnVsIDIwMjAgMjI6MTU6NTEgKzA1MzANCj4gDQo+ICAgICA+ICsJaWYgKHNrYi0+cHJv
dG9jb2wgPT0gaHRvbnMoRVRIX1BfODAyMVEpKSB7DQo+ICAgICA+ICsJCXUxNiB2bGFuX3RjaSA9
IDA7DQo+ICAgICA+ICsJCXNrYl9yZXNldF9tYWNfaGVhZGVyKHNrYik7DQo+IA0KPiAgICA+IFBs
ZWFzZSBwbGFjZSBhbiBlbXB0eSBsaW5lIGJldHdlZW4gYmFzaWMgYmxvY2sgbG9jYWwgdmFyaWFi
bGUgZGVjbGFyYXRpb25zDQo+ICAgID4gYW5kIGFjdHVhbCBjb2RlLg0KPiANCj4gICAgID4gKwkJ
CQluZXRkZXZfZXJyKG5ldCwiUG9wIHZsYW4gZXJyICV4XG4iLHBvcF9lcnIpOw0KPiANCj4gICAg
ID4gQSBzcGFjZSBpcyBuZWNlc3NhcnkgYmVmb3JlICJwb3BfZXJyIi4NCj4gDQo+IENvbnNvbGlk
YXRlZCBsaXN0IG9mIGNvbW1lbnRzIGFkZHJlc3NlZDoNCj4gPiAxLiBCbGFuayBsaW5lIGJldHdl
ZW4gZGVjbGFyYXRpb24gYW5kIGNvZGUuDQo+IERvbmUNCj4gDQo+ID4gMi4gRXJyb3IgaGFuZGxp
bmcgaXMgZGlmZmVyZW50IHRoYW4gb3RoZXIgcGFydHMgb2YgdGhpcyBjb2RlLg0KPiA+wqDCoCBw
cm9iYWJseSBqdXN0IG5lZWQgYSBnb3RvIGRyb3Agb24gZXJyb3IuDQo+IERvbmUNCj4gDQo+ID4g
SXQgc2VlbXMgbGlrZSB5b3UgYXJlIHB1dHRpbmcgaW50byBtZXNzYWdlLCB0aGVuIGRyaXZlciBp
cyBwdXR0aW5nIGl0DQo+ID4gaW50byBtZXRhLWRhdGEgaW4gbmV4dCBjb2RlIGJsb2NrLiBNYXli
ZSBpdCBzaG91bGQgYmUgY29tYmluZWQ/DQo+IE5vdCBkb25lDQo+IFRoaXMgd2FzIG9uIHB1cnBv
c2UuIE1lcmdpbmcgdGhlIHR3byBjb2RlIGJsb2NrcyBtaWdodCBicmVhayBleGlzdGluZw0KPiBm
dW5jdGlvbmFsaXR5Lg0KPiBUaGVyZSBjb3VsZCBiZSBvdGhlciBtb2RlcyB3aGVyZSB0aGUgcGFj
a2V0IGFycml2ZXMgd2l0aCA4MDIuMXEgYWxyZWFkeSBpbg0KPiB0aGUgU2tiIGFuZCB0aGUgc2ti
LT5wcm90b2NvbCBuZWVkbuKAmXQgYmUgODAyLjFxLg0KPiANCj4gPiBwYWNrZXQtPnRvdGFsX2J5
dGVzIHNob3VsZCBiZSB1cGRhdGVkIHRvby4NCj4gTm90IGRvbmUuDQo+IFRoZSB0b3RhbF9ieXRl
cyBuZWVkcyBiZSB0aGUgdG90YWwgbGVuZ3RoIG9mIHBhY2tldCBhZnRlciB0aGUgaG9zdCBPUyBh
ZGRzIHRoZQ0KPiA4MDIuMXEgaGVhZGVyIGJhY2sgaW4gYmVmb3JlIHR4LiBVcGRhdGluZyB0aGUg
dG90YWxfYnl0ZXMgdG8gLT0gVkxBTl9IRUFERVINCj4gd2lsbCBsZWFkIHRvIHBhY2tldCBkcm9w
IGluIHRoZSBIb3N0IE9TIGRyaXZlci4NCg0KSWYgeW91IG1ha2UgdGhpcyBjaGFuZ2UsIGRpZCB5
b3Ugc2VlIGFueSBkcm9wIGluIGEgbGl2ZSB0ZXN0PyBUaGUNCiJwYWNrZXQtPnRvdGFsX2J5dGVz
IiBpbiBzdHJ1Y3QgaHZfbmV0dnNjX3BhY2tldCAgaXMgZm9yIGJvb2sga2VlcGluZyANCm9ubHks
IHdoaWNoIGlzIHVzZWQgZm9yIHN0YXRzIGluZm8sIGFuZCBub3QgdmlzaWJsZSBieSB0aGUgaG9z
dCBhdCBhbGwuDQoNCkkgbWFkZSB0aGlzIHN1Z2dlc3Rpb24gYmVjYXVzZSB0aGUgInJlZ3VsYXIi
IHZsYW4gcGFja2V0IGxlbmd0aCB3YXMgDQpjb3VudGVkIGJ5IGJ5dGVzIHdpdGhvdXQgdGhlIFZM
QU5fSExFTig0KSAtLSB0aGUgdmxhbiB0YWcgaXMgDQppbiB0aGUgc2tiIG1ldGFkYXRhLCBzZXBh
cmF0ZWx5IGZyb20gdGhlIGV0aGVybmV0IGhlYWRlci4gSSB3YW50IHRoZSANCnN0YXRpc3RpY2Fs
IGRhdGEgZm9yIEFGX1BBQ0tFVCBtb2RlIGNvbnNpc3RlbnQgd2l0aCB0aGUgcmVndWxhciBjYXNl
Lg0KDQpzdHJ1Y3QgaHZfbmV0dnNjX3BhY2tldCB7DQogICAgICAgIC8qIEJvb2trZWVwaW5nIHN0
dWZmICovDQogICAgICAgIHU4IGNwX3BhcnRpYWw7IC8qIHBhcnRpYWwgY29weSBpbnRvIHNlbmQg
YnVmZmVyICovDQoNCiAgICAgICAgdTggcm1zZ19zaXplOyAvKiBSTkRJUyBoZWFkZXIgYW5kIFBQ
SSBzaXplICovDQogICAgICAgIHU4IHJtc2dfcGdjbnQ7IC8qIHBhZ2UgY291bnQgb2YgUk5ESVMg
aGVhZGVyIGFuZCBQUEkgKi8NCiAgICAgICAgdTggcGFnZV9idWZfY250Ow0KDQogICAgICAgIHUx
NiBxX2lkeDsNCiAgICAgICAgdTE2IHRvdGFsX3BhY2tldHM7DQoNCiAgICAgICAgdTMyIHRvdGFs
X2J5dGVzOw0KICAgICAgICB1MzIgc2VuZF9idWZfaW5kZXg7DQogICAgICAgIHUzMiB0b3RhbF9k
YXRhX2J1ZmxlbjsNCn07DQoNClRoYW5rcw0KLSBIYWl5YW5nDQo=
