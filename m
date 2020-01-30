Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD88914DEE9
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgA3QUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 11:20:44 -0500
Received: from mail-eopbgr00078.outbound.protection.outlook.com ([40.107.0.78]:37795
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727191AbgA3QUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 11:20:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsphNGX3hK6FrmGAJd9A9N9JIQmaUK4mkzFeOrR8ZOfvte8I0L9gB7sPeu+nCOo94Ofyg4ZKSgRdwyzgvfPxVb12/Z1Mx8Rf6k7HaTwSpxDVJZX7TgETvNvBYT5n0dWck2vnnEvkqVX436M6an9EVDU0qUNXqz5vzzI36zIwNIAxbDDI16mbWw5aBr0uwykYOQte/GvKnDQUuiFE60nCyjG+ZFdQwKgWsgAnDVwW5HSVRr3XEzPatZfJLMLtANTTzoEx/8MPk4GqewycJNEhkKv5Jwqhl01W47MeHz7lAGUDYVsHwjsRrVVjlwcVbYuP0lY8Z1bPcaJUCUk57TskMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=673ch+MoMWJK2UM2kVv3TIlpiuXv64VjWUi4nOT0Vi4=;
 b=kZUfvsQW9s7UHrH90rCY91UujSOh+G/I2kZi2q2o+q2eINELD63CiyZ0aljnk0qcB16N8q0HzV114XxAq3q6TuF3x8hcAQRc7jpLcqssuTS4mTz2CHRP1AQ6haekzAhib4/mulxm200T/kNq/brCh7kdkbdE4CHMCfamdPxZqWtiJPHeSv29SH7kFP8nk3w50cY/K+oAEtknc6o8wYSFvLkLEzN5Fm2kMwTp4Z6asAtMD0pTypCv+yTYW8hhxXQgf2rvKWmJMxcIUEu+OIdRxXcjxiUBK+nv0mvJpaOcdi3Rj5ouN4pDx/ZlzGy/cWsp/t9yM8tzr0Sc/9vGyWxoVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=673ch+MoMWJK2UM2kVv3TIlpiuXv64VjWUi4nOT0Vi4=;
 b=B97/s/SJLtF6elgsWpsIuSO6FMMGO0zPwlVK8lXYtup4QiV7yTMuNp5eNukivTtNjK6bnFRv9ASvYkfP6F42s0yVRTVCOtxDp2qBpJJXDlVB6eUQVc+t5efwbQDsTI26sGZL8hzA9/zBg+fM1pa96/RSHjuWFXrgXLmQSUZJlT8=
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com (10.168.21.32) by
 DB6PR05MB3431.eurprd05.prod.outlook.com (10.175.233.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Thu, 30 Jan 2020 16:20:38 +0000
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::bcf1:4f61:998d:690]) by DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::bcf1:4f61:998d:690%7]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 16:20:38 +0000
From:   Yossi Kuperman <yossiku@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: [RFC] Hierarchical QoS Hardware Offload (HTB)
Thread-Topic: [RFC] Hierarchical QoS Hardware Offload (HTB)
Thread-Index: AQHV14k1YKFz4TW8yUeDBvvYqkHi+w==
Date:   Thu, 30 Jan 2020 16:20:38 +0000
Message-ID: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yossiku@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8cb4dba-36f8-4f09-eadc-08d7a5a057fd
x-ms-traffictypediagnostic: DB6PR05MB3431:|DB6PR05MB3431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR05MB3431CBE8D4532B04E3E02555C4040@DB6PR05MB3431.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(189003)(199004)(2906002)(6486002)(36756003)(316002)(5660300002)(186003)(71200400001)(86362001)(33656002)(54906003)(66946007)(64756008)(66556008)(66476007)(66446008)(478600001)(91956017)(6506007)(76116006)(81156014)(107886003)(4326008)(6512007)(2616005)(8676002)(26005)(6916009)(8936002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB3431;H:DB6PR05MB4775.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AF3WUwgorHcqFT4v1jglvej1tVygUgWsOTGtPBwbdDWnhnRQev+0203a9uJrfb07CvduKwR/B8+LIrOAFFTlQxO9xTcU8PBNCCw2xeWW9vw0KIwYGQo2yg36AV0w9U+rA7uoHKEOshufHWaSER7c/jDrFkNP42Z6j8C45/yu5qrNTZct1EEYVHv/9MAHyKvD8maqWQklhTYV8hjauQPN2L5xNhGZL/Wf5vEqjymIodAjjRhyFrT/pJtP2DVTAZTGklWZWeLeuZfptlw2HS0DxwAq5on2sgbdBck2AuJAtK/a+1OoQHe7InbwThNnem5y0dSGc2URJDdDly8pqdt62vFLuhjGGjE9sMyOpzzDEjsjOC4I/Ww6JSCbJ2Nl5kterUs7LjT2IJ9MFvHwxH8n9OIqb7eyz2T/2C8VEIQvGygrlHw9nzXlrud7AydO+NiH
x-ms-exchange-antispam-messagedata: AKVRmclLMZ1UxKlmIiXFfs+jPlSfjbEftUhaAWLbyCVn2szffhx1jSiY23QV6mwQeHm40r22lr4T5QwskuoYP1KhC5Z8Ccg6uwZHOfjkNdiOASOFV8ztTV9LRWOKQQeq1ukx5Yend8T7tJG0auOGwA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3C58541A542E246A10BA0D5599C81AD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8cb4dba-36f8-4f09-eadc-08d7a5a057fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 16:20:38.4674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x6SF/6fElTxfGJg0GX9dDxqKTeKSRBWbtzx7FZ5omUfDZwXSEW4W4/LAv4wiFYhDNmBhEsO31icFqYV5HQd6ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3431
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rm9sbG93aW5nIGlzIGFuIG91dGxpbmUgYnJpZWZseSBkZXNjcmliaW5nIG91ciBwbGFucyB0b3dh
cmRzIG9mZmxvYWRpbmcgSFRCIGZ1bmN0aW9uYWxpdHkuDQoNCkhUQiBxZGlzYyBhbGxvd3MgeW91
IHRvIHVzZSBvbmUgcGh5c2ljYWwgbGluayB0byBzaW11bGF0ZSBzZXZlcmFsIHNsb3dlciBsaW5r
cy4gVGhpcyBpcyBkb25lIGJ5IGNvbmZpZ3VyaW5nIGEgaGllcmFyY2hpY2FsIFFvUyB0cmVlOyBl
YWNoIHRyZWUgbm9kZSBjb3JyZXNwb25kcyB0byBhIGNsYXNzLiBGaWx0ZXJzIGFyZSB1c2VkIHRv
IGNsYXNzaWZ5IGZsb3dzIHRvIGRpZmZlcmVudCBjbGFzc2VzLiBIVEIgaXMgcXVpdGUgZmxleGli
bGUgYW5kIHZlcnNhdGlsZSwgYnV0IGl0IGNvbWVzIHdpdGggYSBjb3N0LiBIVEIgZG9lcyBub3Qg
c2NhbGUgYW5kIGNvbnN1bWVzIGNvbnNpZGVyYWJsZSBDUFUgYW5kIG1lbW9yeS4gT3VyIGFpbSBp
cyB0byBvZmZsb2FkIEhUQiBmdW5jdGlvbmFsaXR5IHRvIGhhcmR3YXJlIGFuZCBwcm92aWRlIHRo
ZSB1c2VyIHdpdGggdGhlIGZsZXhpYmlsaXR5IGFuZCB0aGUgY29udmVudGlvbmFsIHRvb2xzIG9m
ZmVyZWQgYnkgVEMgc3Vic3lzdGVtLCB3aGlsZSBzY2FsaW5nIHRvIHRob3VzYW5kcyBvZiB0cmFm
ZmljIGNsYXNzZXMgYW5kIG1haW50YWluaW5nIHdpcmUtc3BlZWQgcGVyZm9ybWFuY2UuwqANCg0K
TWVsbGFub3ggaGFyZHdhcmUgY2FuIHN1cHBvcnQgaGllcmFyY2hpY2FsIHJhdGUtbGltaXRpbmc7
IHJhdGUtbGltaXRpbmcgaXMgZG9uZSBwZXIgaGFyZHdhcmUgcXVldWUuIEluIG91ciBwcm9wb3Nl
ZCBzb2x1dGlvbiwgZmxvdyBjbGFzc2lmaWNhdGlvbiB0YWtlcyBwbGFjZSBpbiBzb2Z0d2FyZS4g
QnkgbW92aW5nIHRoZSBjbGFzc2lmaWNhdGlvbiB0byBjbHNhY3QgZWdyZXNzIGhvb2ssIHdoaWNo
IGlzIHRocmVhZC1zYWZlIGFuZCBkb2VzIG5vdCByZXF1aXJlIGxvY2tpbmcsIHdlIGF2b2lkIHRo
ZSBjb250ZW50aW9uIGluZHVjZWQgYnkgdGhlIHNpbmdsZSBxZGlzYyBsb2NrLiBGdXJ0aGVybW9y
ZSwgY2xzYWN0IGZpbHRlcnMgYXJlIHBlcmZvcm0gYmVmb3JlIHRoZSBuZXQtZGV2aWNl4oCZcyBU
WCBxdWV1ZSBpcyBzZWxlY3RlZCwgYWxsb3dpbmcgdGhlIGRyaXZlciBhIGNoYW5jZSB0byB0cmFu
c2xhdGUgdGhlIGNsYXNzIHRvIHRoZSBhcHByb3ByaWF0ZSBoYXJkd2FyZSBxdWV1ZS4gUGxlYXNl
IG5vdGUgdGhhdCB0aGUgdXNlciB3aWxsIG5lZWQgdG8gY29uZmlndXJlIHRoZSBmaWx0ZXJzIHNs
aWdodGx5IGRpZmZlcmVudDsgYXBwbHkgdGhlbSB0byB0aGUgY2xzYWN0IHJhdGhlciB0aGFuIHRv
IHRoZSBIVEIgaXRzZWxmLCBhbmQgc2V0IHRoZSBwcmlvcml0eSB0byB0aGUgZGVzaXJlZCBjbGFz
cy1pZC4NCg0KRm9yIGV4YW1wbGUsIHRoZSBmb2xsb3dpbmcgdHdvIGZpbHRlcnMgYXJlIGVxdWl2
YWxlbnQ6DQoJMS4gdGMgZmlsdGVyIGFkZCBkZXYgZXRoMCBwYXJlbnQgMTowIHByb3RvY29sIGlw
IGZsb3dlciBkc3RfcG9ydCA4MCBjbGFzc2lkIDE6MTANCgkyLiB0YyBmaWx0ZXIgYWRkIGRldiBl
dGgwIGVncmVzcyBwcm90b2NvbCBpcCBmbG93ZXIgZHN0X3BvcnQgODAgYWN0aW9uIHNrYmVkaXQg
cHJpb3JpdHkgMToxMA0KDQpOb3RlOiB0byBzdXBwb3J0IHRoZSBhYm92ZSBmaWx0ZXIgbm8gY29k
ZSBjaGFuZ2VzIHRvIHRoZSB1cHN0cmVhbSBrZXJuZWwgbm9yIHRvIGlwcm91dGUyIHBhY2thZ2Ug
aXMgcmVxdWlyZWQuDQoNCkZ1cnRoZXJtb3JlLCB0aGUgbW9zdCBjb25jZXJuaW5nIGFzcGVjdCBv
ZiB0aGUgY3VycmVudCBIVEIgaW1wbGVtZW50YXRpb24gaXMgaXRzIGxhY2sgb2Ygc3VwcG9ydCBm
b3IgbXVsdGktcXVldWUuIEFsbCBuZXQtZGV2aWNl4oCZcyBUWCBxdWV1ZXMgcG9pbnRzIHRvIHRo
ZSBzYW1lIEhUQiBpbnN0YW5jZSwgcmVzdWx0aW5nIGluIGhpZ2ggc3Bpbi1sb2NrIGNvbnRlbnRp
b24uIFRoaXMgY29udGVudGlvbiAobWlnaHQpIG5lZ2F0ZXMgdGhlIG92ZXJhbGwgcGVyZm9ybWFu
Y2UgZ2FpbnMgZXhwZWN0ZWQgYnkgaW50cm9kdWNpbmcgdGhlIG9mZmxvYWQgaW4gdGhlIGZpcnN0
IHBsYWNlLiBXZSBzaG91bGQgbW9kaWZ5IEhUQiB0byBwcmVzZW50IGl0c2VsZiBhcyBtcSBxZGlz
YyBkb2VzLiBCeSBkZWZhdWx0LCBtcSBxZGlzYyBhbGxvY2F0ZXMgYSBzaW1wbGUgZmlmbyBxZGlz
YyBwZXIgVFggcXVldWUgZXhwb3NlZCBieSB0aGUgbG93ZXIgbGF5ZXIgZGV2aWNlLiBUaGlzIGlz
IG9ubHkgd2hlbiBoYXJkd2FyZSBvZmZsb2FkIGlzIGNvbmZpZ3VyZWQsIG90aGVyd2lzZSwgSFRC
IGJlaGF2ZXMgYXMgdXN1YWwuIFRoZXJlIGlzIG5vIEhUQiBjb2RlIGFsb25nIHRoZSBkYXRhLXBh
dGg7IHRoZSBvbmx5IG92ZXJoZWFkIGNvbXBhcmVkIHRvIHJlZ3VsYXIgdHJhZmZpYyBpcyB0aGUg
Y2xhc3NpZmljYXRpb24gdGFraW5nIHBsYWNlIGF0IGNsc2FjdC4gUGxlYXNlIG5vdGUgdGhhdCB0
aGlzIGRlc2lnbiBpbmR1Y2VzIGZ1bGwgb2ZmbG9hZC0tLW5vIGZhbGxiYWNrIHRvIHNvZnR3YXJl
OyBpdCBpcyBub3QgdHJpdmlhbCB0byBwYXJ0aWFsIG9mZmxvYWQgdGhlIGhpZXJhcmNoaWNhbCB0
cmVlIGNvbnNpZGVyaW5nIGJvcnJvd2luZyBiZXR3ZWVuIHNpYmxpbmdzIGFueXdheS4NCg0KDQpU
byBzdW1tYXJpZXM6IGZvciBlYWNoIEhUQiBsZWFmLWNsYXNzIHRoZSBkcml2ZXIgd2lsbCBhbGxv
Y2F0ZSBhIHNwZWNpYWwgcXVldWUgYW5kIG1hdGNoIGl0IHdpdGggYSBjb3JyZXNwb25kaW5nIG5l
dC1kZXZpY2UgVFggcXVldWUgKGluY3JlYXNlIHJlYWxfbnVtX3R4X3F1ZXVlcykuIEEgdW5pcXVl
IGZpZm8gcWRpc2Mgd2lsbCBiZSBhdHRhY2hlZCB0byBhbnkgc3VjaCBUWCBxdWV1ZS4gQ2xhc3Np
ZmljYXRpb24gd2lsbCBzdGlsbCB0YWtlIHBsYWNlIGluIHNvZnR3YXJlLCBidXQgcmF0aGVyIGF0
IHRoZSBjbHNhY3QgZWdyZXNzIGhvb2suIFRoaXMgd2F5IHdlIGNhbiBzY2FsZSB0byB0aG91c2Fu
ZHMgb2YgY2xhc3NlcyB3aGlsZSBtYWludGFpbmluZyB3aXJlLXNwZWVkIHBlcmZvcm1hbmNlIGFu
ZCByZWR1Y2luZyBDUFUgb3ZlcmhlYWQuDQoNCkFueSBmZWVkYmFjayB3aWxsIGJlIG11Y2ggYXBw
cmVjaWF0ZWQuDQoNCkNoZWVycywNCkt1cGVybWFuDQoNCg0K
