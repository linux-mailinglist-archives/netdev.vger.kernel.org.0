Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D29F22F9
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfKGABE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:01:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbfKGABE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 19:01:04 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6NuBOa009363;
        Wed, 6 Nov 2019 16:00:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=wj3W54T43z69CX76awPa0PZ03qwD1Klfdqe2CNj4Uks=;
 b=UgeSPZgIxdxXHVu8OqKr9tqqYvcYyPOVGGBMcaIC2/GpSfd02r81bXV4552ZNHZPW3Wr
 uvJShUoRpHGRBeJAFeldfmaChJNH0o5A5wvZdPqwkP2esDzZd7WgN5N7+IqzFUpo0+k5
 Kny+76oap598JTMghfAnzAFpVcBiQ+VqctZj8WqHc10BRygs0cKrKCr54HrNADdPXt/J
 DHfoXWYksbZGNjdPtZv6GO88sjOPPjWs0kSpFJ6/Iiy7Ie2vx5KvTQHMXF3WDRmrUOFk
 VD0be0UN0GqNcbplBs7U848tWUG1lUPxL4Eh6R4P7Pf22bSTuBuFeBW86AYtA3N24vTH mg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w46sarb6q-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 16:00:53 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 6 Nov
 2019 16:00:52 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 6 Nov 2019 16:00:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBiHC7S2Ege+JT8Uh4zwP+CXWik+vGF5zRsQnprLtlcXavcF9tWVWF0jReeTqHzm5YBL8evUBqCE6ofdsS7H7Ffzf4RrBIe7Wxrl6zhIZnadFwekt+7fMn4xWLnp70xn8kU11RVrkUFlNtBHYT7ttVDaXLXmz/CD66639vxEXmoKL2rqHoiTuiU6lnYeUJF1UFIpcj177YWyGXOyBI6Dv4uAT568CGsOPuXLSeyuls3OTfb4gr4OTTtB4NXnoYLVaYCasxa2upYjLNIVLREc3TGDrEp52Nidv0zn25FwVm/JSAz9ZFDSaVTlVtcd6mzx6gmvyITWzBGtWMD/jyhuXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj3W54T43z69CX76awPa0PZ03qwD1Klfdqe2CNj4Uks=;
 b=Sn6g8i8g4Gh4PZE7xz99IDHTTdVPRuPyHH9qt7KhvMN5I2o5y5DsEqBuaYS/QJ7cTaP2f9q3NJS2ftDR0Aefztxkb48rzIlbTupDadVcXIGvsP4PSi7A4VmjkNPFVnwtjFoY1grs4JXVNaUiXMsrnhYQCcxZPdqw00GnXRGx0VZ7B2hbUiOzm+8uNAW9r7SYnonSOEpMo1C6AUY4MBRyI5fhzMzUFPRAORQCPmAy2Fjpcp6dFxENk6TvC4XNhRuMMCwhJnQX8s2duyHRdxMMei/kia0p4juJS8CRI9pm1iH4r0W2ctEdvsW3geoTl9PcR8q9AwjkR7cLh7Cm1UT1yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj3W54T43z69CX76awPa0PZ03qwD1Klfdqe2CNj4Uks=;
 b=HsivuiHorpnGp3U6gZVwLdghU/Gl0nqx6EMqhtsocARw8ZzEQEa7ZiNAU1Pc0BZ4tDNnYEbsX9GD2Gexct9SRXziAawSNMk1LSsJeZ33q50rfDyc+XgJJfTlv06LqMhFfFD8/9Jha34STDA9c3Ouxhhs8NnkeII+pdP7iCKyokY=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB1002.namprd18.prod.outlook.com (10.168.116.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 00:00:51 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 00:00:51 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next] net: aquantia: fix return value check in
 aq_ptp_init()
Thread-Topic: [EXT] [PATCH net-next] net: aquantia: fix return value check in
 aq_ptp_init()
Thread-Index: AQHVlP5qspHeKmWWj0uhbAXsBNzeRA==
Date:   Thu, 7 Nov 2019 00:00:50 +0000
Message-ID: <bfca5f2b-9d37-b45f-3478-fb64d676d23a@marvell.com>
References: <20191106145921.124814-1-weiyongjun1@huawei.com>
In-Reply-To: <20191106145921.124814-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0052.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::16) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db2a82d4-b566-46fb-0467-08d763158d06
x-ms-traffictypediagnostic: DM5PR18MB1002:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1002E5ECB299108EDC907E63B7780@DM5PR18MB1002.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:275;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39840400004)(346002)(396003)(366004)(376002)(136003)(189003)(199004)(5660300002)(66556008)(256004)(14444005)(229853002)(99286004)(2906002)(81156014)(6246003)(3846002)(31696002)(6486002)(6116002)(25786009)(71190400001)(71200400001)(8676002)(81166006)(305945005)(6512007)(4326008)(6436002)(7736002)(31686004)(66066001)(64756008)(110136005)(86362001)(8936002)(102836004)(66946007)(76176011)(66446008)(478600001)(316002)(26005)(52116002)(386003)(6506007)(2616005)(11346002)(36756003)(14454004)(486006)(446003)(66476007)(54906003)(476003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1002;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rx5OYMNrg0Dd9ARa0Oezg7wu/i58Zux0nm5rfVtSR9du7RvahBfMkOe2/LsDZTDVK77zchd8xOpAC+Cdp+mnrVVq+8cFeUOai0kcBBS9jK9NIKCeOqChTEtwxev/x+oHmjZ/i46op5O2ZrjvaVRUWbqgB1vGFc54vJS1Fbnwcklo7Wfgw9sE4ZdqwjjYK/JIy3Iy24ZWKgMXRhBV66fobYF3iN3ofYm9H9uYuiIIgk0NR9wfr+n4BZ59xCvbLMqx4OfcdaFykZLLxjrzJ278+dCP+cr8ECqA+g8lpXY59xTVIHbySpiau/RDWvMQNX5yMTBuuXmdtJWf+u/ZmfjJjD1gE6PpxgE8OWfTE/ERcanTbDQUpz29owT5x3IDFJq/4WFLMFmjXiQt9f8ptZX00JRtKAReTX+hY0Gn8A+t9X3QM4mIrXlCFiURe2L75UW/
Content-Type: text/plain; charset="utf-8"
Content-ID: <2803688D42B1C7448A2B9335B135D7B4@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db2a82d4-b566-46fb-0467-08d763158d06
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 00:00:50.9558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CMek4q+BOTz2FgXDYRSt6/Hkcm6ONdc5weI2gNOQuWcocZjQ4WQa33/fFydu69RZCOw/OTlglj3RzDwrr0otmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1002
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZ1bmN0aW9uIHB0cF9jbG9ja19yZWdpc3RlcigpIHJldHVybnMgRVJSX1BUUigpIGFuZCBu
ZXZlciByZXR1cm5zDQo+IE5VTEwuIFRoZSBOVUxMIHRlc3Qgc2hvdWxkIGJlIHJlbW92ZWQuDQoN
ClRoYW5rcywgV2VpIQ0KDQpGdW5jdGlvbiBieSBpdHNlbGYgY291bGQgcmV0dXJuIG51bGwsIGJ1
dCB5b3UgYXJlIHJpZ2h0LCBzaW5jZSB0aGlzDQpjb2RlIGlzIG5vdyBhY3RpdmUgb25seSB3aGVu
IFBUUF8xNTg4X0NMT0NLIGlzIG9uIC0gdGhpcyBpcyBhIHVzZWxlc3MgY2hlY2sgdGhlbi4NCg0K
PiBTaWduZWQtb2ZmLWJ5OiBXZWkgWW9uZ2p1biA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT4NCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wdHAuYyB8
IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX3B0cC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcHRw
LmMNCj4gaW5kZXggM2VjMDg0MTVlNTNlLi4yNTJhODBiNmQzYjYgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3B0cC5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3B0cC5jDQo+IEBAIC0xMjA1
LDcgKzEyMDUsNyBAQCBpbnQgYXFfcHRwX2luaXQoc3RydWN0IGFxX25pY19zICphcV9uaWMsIHVu
c2lnbmVkIGludCBpZHhfdmVjKQ0KPiAgCWFxX3B0cC0+cHRwX2luZm8gPSBhcV9wdHBfY2xvY2s7
DQo+ICAJYXFfcHRwX2dwaW9faW5pdCgmYXFfcHRwLT5wdHBfaW5mbywgJm1ib3guaW5mbyk7DQo+
ICAJY2xvY2sgPSBwdHBfY2xvY2tfcmVnaXN0ZXIoJmFxX3B0cC0+cHRwX2luZm8sICZhcV9uaWMt
Pm5kZXYtPmRldik7DQo+IC0JaWYgKCFjbG9jayB8fCBJU19FUlIoY2xvY2spKSB7DQo+ICsJaWYg
KElTX0VSUihjbG9jaykpIHsNCj4gIAkJbmV0ZGV2X2VycihhcV9uaWMtPm5kZXYsICJwdHBfY2xv
Y2tfcmVnaXN0ZXIgZmFpbGVkXG4iKTsNCj4gIAkJZXJyID0gUFRSX0VSUihjbG9jayk7DQo+ICAJ
CWdvdG8gZXJyX2V4aXQ7DQoNCkFja2VkLWJ5OiBJZ29yIFJ1c3NraWtoIDxpcnVzc2tpa2hAbWFy
dmVsbC5jb20+DQoNCi0tIA0KUmVnYXJkcywNCiAgSWdvcg0K
