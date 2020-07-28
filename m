Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2572E230E26
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgG1PkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:40:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59334 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730679AbgG1PkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:40:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SFTVK7006415;
        Tue, 28 Jul 2020 08:39:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=fvVBU0g647CdPCbr5Osxw39x7UgyFS0lbWRfQhNA8lU=;
 b=s2t9+YqtOoa5OaZMhqH1PTpFt2sE3D5TkSQC1/VDyu74op8c9e5qK7b93eogj/xSIo8h
 /Nv8lzuqW1W5g1GgFtZG7qr4mHw5DPoobaB2JUnZYVrIZ9A84g+LpZPEhZYhRvPgLz/d
 o5YvI93gBnJtE1cQXxBMePanljqauBDMu3jp3rw/mVWeIL7GO2zhebaZScF4VtKdiesi
 nvFtoWxIUCS4+ORJ+hrgnSvbbXadzBhujs5V1fG4I3IyefeECiL5tvFVrB45RLE09o3X
 buVMIiRmD+DuTSASHgTrdnH/dp9E316mtt9Banh1aKkpxJFE5cPSd65XfQ3StI1IjoSO /A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qvm0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 08:39:52 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 08:39:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 28 Jul 2020 08:39:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrB8eGhv0ZO47cyCTWSWs97Bo3qQJcRuN3y5ZxSIbDlTTS3SigRfBUKzKItchHwUawYdhrAHWp4DsTOxX7irwyvBBXNcrjwnAkfrsWHswi4kHzjmcr69y9yEeSrvAIfHzaNs+LXa/qCZ9trX22AddATrvWXeMMJF0HxJBfCoBogyHdjtdkAOwRMTuxbO5O6WHropAKv9vXWwZ8svZzCtvCl+dBY4aVkeDrOZWI8rYydv8+HKihxoR+OdGPM7jUH9AP3y6ZO0TV9lxaXZIwy9v7mYcxxBVq623fP31xYVfJ5aPH7uwYYzDm3uoGHOhoh4E7mtBjj0ttDB0SdqBbBXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvVBU0g647CdPCbr5Osxw39x7UgyFS0lbWRfQhNA8lU=;
 b=dBcFaRGxS676vb7R5CO4qegoLDJbwKnofxtH3D7NRF7/qxT0RfMcs2qt7/SLkCrjRDCPTfCriEvWAZQ0E2W+gyf95uy+5uHYIHxO99lvwp7e4+882TndjuPovHfeTDmVKdXIVsaewMv/81CsxM+WjbPSmlE3IzftAlU6yGqaWQ/48mkmrMUo8mcICFWIs9IYf2vTfeLVKZ/KdC33dLRjJ8nUKj5w228Lu7RRpnLQYOdXzITNFzKiPw6AJwrT1+9gTc/xVoZ9iepy4SbS1bxdDCwUDrRnyZqLfubAJgIa9d90NbfYq54L2wZhXgN9bXJ1LfHY8KnyqWddfciTuRf/Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvVBU0g647CdPCbr5Osxw39x7UgyFS0lbWRfQhNA8lU=;
 b=CeYtLCXkfb9P8EyAJKCif1g23lvAGCO0v/fAAzHr0EQb/Ue6JaRZKv7fbX72hsSmcIYs3af6CDlXVwAj7GqynaHPu11H5nnEyNHCMNFxqmM1XmvQZ4zrWmJk3zXnAROPaKXYMZ8AAKMkncR/da72AWFVikFFsbguk5rGMmmN58Y=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by BYAPR18MB2360.namprd18.prod.outlook.com (2603:10b6:a03:12c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.28; Tue, 28 Jul
 2020 15:39:49 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 15:39:49 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     "wanghai (M)" <wanghai38@huawei.com>,
        Joe Perches <joe@perches.com>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
Thread-Topic: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
Thread-Index: AdZk6P1xxM+rVDfISEWynrTkxawr6g==
Date:   Tue, 28 Jul 2020 15:39:49 +0000
Message-ID: <BYAPR18MB24230A8301FD9849F9943B9DAC730@BYAPR18MB2423.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2601:646:8d01:7c70:75c5:f7c5:1663:bfbd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba143104-77c6-408f-32ef-08d8330c76bd
x-ms-traffictypediagnostic: BYAPR18MB2360:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB23603F77E34222C251F0128FAC730@BYAPR18MB2360.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tNRQ6ATAgyOXaplIsw8qMBW8IjBTLZOS55dCJ95Bcz5feEFN7lsKhdT++cuC/CMluU4YpvZXIj6j5SqDlRbrg0Rdsk+JzSYhncm48cupv/Id2zOEJWjThMxYMTbIJ/PDXmigfrJCbsIGNmC0aCliwU5ekHqyxOkEZ5W90N94Y2UIYDIDDRAURqIAGy9odtmMDPOqd86iDQB8HPD3SeooeDMXx3pdHjc32WzdJQ+tT2nXRPADbyqGVckKC3SG5tvGoWqY6U7rck/Q5r6hf9mPyzoDi+WLL64Lp1jbeR5Oji9kceEYQwouwW5D6z5z28iSdm5zSWXvxacv/a15tdL9pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(7696005)(186003)(86362001)(83380400001)(2906002)(8936002)(76116006)(55016002)(54906003)(110136005)(478600001)(9686003)(8676002)(4326008)(71200400001)(66946007)(33656002)(316002)(66476007)(66556008)(64756008)(66446008)(52536014)(5660300002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5JLyV05N1K4aPQDoUdIMhvquN/Dc7Fo1wwhrtMPpt6KO9OGI3MyegSGlEK6M3Jr/8ObW3VEibDXQHfswstC0jePDIW/xKhOJL/LXNyOi3S8aLCjrwkQcrky9trdp0UJvpadkTLkn6K41rytsitr3DMrKlASP/UwEZukX910wVe3qfF6MXa4ZYGJeGoyT++Fak1x5IrysCqD/r8BSc4ASqbVwLq2Q9cAY7si3ehmUZ3VMbIFbVHXXGkMOvbYQg63f9TXY71thAe7DtgjaeTxD9oA1BXt08bZd3FpU9dgTQ7QZqEm8uRz5N45Rx2jmbtYDzQUn4U60mgzwz1mNeDsOPBFNHoOJiHCUlFOu3Ms/m+hZByNKLT/DKhTofvx/FPFdYR2TjEOFzplgv3hut3RPpF6GFcVCGl5HEQhHI5+EpyK1FI0XdRezAmZ1+/l4qTgUw47AzftVK3D8MFjEgBDcf8wtGnVvBa9D+XFn6Qve7r+3t5qp+xnsehGfO1lyNZw1a3Lda6FLc6RT44j2vjQMUrN7EPWHdlx3upQDQlUKRSD8euUVeCD5FbIKyDCOC52x
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba143104-77c6-408f-32ef-08d8330c76bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 15:39:49.6630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/PXUuR3HTsf4B/sSEu3/51eTO9wb1UBlE4tnVrPr9Kd8pVVx0pdgfN2wT5lqdGlB49A8u5lCGSQBKY9T2IVZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2360
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_13:2020-07-28,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiB3YW5naGFpIChNKSA8d2FuZ2hhaTM4QGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFtF
WFRdIFJlOiBbUEFUQ0ggbmV0LW5leHRdIGxpcXVpZGlvOiBSZW1vdmUgdW5uZWVkZWQgY2FzdCBm
cm9tDQo+IG1lbW9yeSBhbGxvY2F0aW9uDQo+IA0KPiDlnKggMjAyMC83LzI4IDE3OjExLCBKb2Ug
UGVyY2hlcyDlhpnpgZM6DQo+ID4gT24gVHVlLCAyMDIwLTA3LTI4IGF0IDE2OjQyICswODAwLCB3
YW5naGFpIChNKSB3cm90ZToNCj4gPj4g5ZyoIDIwMjAvNy8yNSA1OjI5LCBKb2UgUGVyY2hlcyDl
hpnpgZM6DQo+ID4+PiBPbiBGcmksIDIwMjAtMDctMjQgYXQgMjE6MDAgKzA4MDAsIFdhbmcgSGFp
IHdyb3RlOg0KPiA+Pj4+IFJlbW92ZSBjYXN0aW5nIHRoZSB2YWx1ZXMgcmV0dXJuZWQgYnkgbWVt
b3J5IGFsbG9jYXRpb24gZnVuY3Rpb24uDQo+ID4+Pj4NCj4gPj4+PiBDb2NjaW5lbGxlIGVtaXRz
IFdBUk5JTkc6DQo+ID4+Pj4NCj4gPj4+PiAuL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9s
aXF1aWRpby9vY3Rlb25fZGV2aWNlLmM6MTE1NToxNC0zNjoNCj4gV0FSTklORzoNCj4gPj4+PiAg
ICBjYXN0aW5nIHZhbHVlIHJldHVybmVkIGJ5IG1lbW9yeSBhbGxvY2F0aW9uIGZ1bmN0aW9uIHRv
IChzdHJ1Y3QNCj4gb2N0ZW9uX2Rpc3BhdGNoICopIGlzIHVzZWxlc3MuDQo+ID4+PiBbXQ0KPiA+
Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vbGlxdWlkaW8vb2N0
ZW9uX2RldmljZS5jDQo+ID4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vbGlxdWlk
aW8vb2N0ZW9uX2RldmljZS5jDQo+ID4+PiBbXQ0KPiA+Pj4+IEBAIC0xMTUyLDggKzExNTIsNyBA
QCBvY3Rlb25fcmVnaXN0ZXJfZGlzcGF0Y2hfZm4oc3RydWN0DQo+ID4+Pj4gb2N0ZW9uX2Rldmlj
ZSAqb2N0LA0KPiA+Pj4+DQo+ID4+Pj4gICAgCQlkZXZfZGJnKCZvY3QtPnBjaV9kZXYtPmRldiwN
Cj4gPj4+PiAgICAJCQkiQWRkaW5nIG9wY29kZSB0byBkaXNwYXRjaCBsaXN0IGxpbmtlZCBsaXN0
XG4iKTsNCj4gPj4+PiAtCQlkaXNwYXRjaCA9IChzdHJ1Y3Qgb2N0ZW9uX2Rpc3BhdGNoICopDQo+
ID4+Pj4gLQkJCSAgIHZtYWxsb2Moc2l6ZW9mKHN0cnVjdCBvY3Rlb25fZGlzcGF0Y2gpKTsNCj4g
Pj4+PiArCQlkaXNwYXRjaCA9IHZtYWxsb2Moc2l6ZW9mKHN0cnVjdCBvY3Rlb25fZGlzcGF0Y2gp
KTsNCj4gPj4+IE1vcmUgdGhlIHF1ZXN0aW9uIGlzIHdoeSB0aGlzIGlzIHZtYWxsb2MgYXQgYWxs
IGFzIHRoZSBzdHJ1Y3R1cmUNCj4gPj4+IHNpemUgaXMgdmVyeSBzbWFsbC4NCj4gPj4+DQo+ID4+
PiBMaWtlbHkgdGhpcyBzaG91bGQganVzdCBiZSBrbWFsbG9jLg0KPiA+Pj4NCj4gPj4+DQo+ID4+
IFRoYW5rcyBmb3IgeW91ciBhZHZpY2UuICBJdCBpcyBpbmRlZWQgYmVzdCB0byB1c2Uga21hbGxv
YyBoZXJlLg0KDQpJIHRoaW5rIHRoYXQgaXMgZmluZSBhcyB3ZWxsLiBXZSBqdXN0IHVzZWQgdm1h
bGxvYyBzaW5jZSB0aGVyZSBpcyBubyBuZWVkDQpmb3IgYSBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMg
cGllY2Ugb2YgbWVtb3J5Lg0KDQouLi4NCg0KPiANCj4gQ2FuIGl0IGJlIG1vZGlmaWVkIGxpa2Ug
dGhpcz8NCj4gDQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS9saXF1aWRpby9v
Y3Rlb25fZGV2aWNlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2F2aXVtL2xpcXVp
ZGlvL29jdGVvbl9kZXZpY2UuYw0KPiBAQCAtMTE1MiwxMSArMTE1Miw4IEBAIG9jdGVvbl9yZWdp
c3Rlcl9kaXNwYXRjaF9mbihzdHJ1Y3QNCj4gb2N0ZW9uX2RldmljZSAqb2N0LA0KPiANCj4gIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZGJnKCZvY3QtPnBjaV9kZXYtPmRldiwN
Cj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIkFkZGlu
ZyBvcGNvZGUgdG8gZGlzcGF0Y2ggbGlzdCBsaW5rZWQgbGlzdFxuIik7DQo+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGRpc3BhdGNoID0gKHN0cnVjdCBvY3Rlb25fZGlzcGF0Y2ggKikN
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZt
YWxsb2Moc2l6ZW9mKHN0cnVjdCBvY3Rlb25fZGlzcGF0Y2gpKTsNCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZGlzcGF0Y2ggPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3Qgb2N0ZW9uX2Rp
c3BhdGNoKSwNCj4gR0ZQX0tFUk5FTCk7DQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKCFkaXNwYXRjaCkgew0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgZGV2X2Vycigmb2N0LT5wY2lfZGV2LT5kZXYsDQo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIk5vIG1lbW9y
eSB0byBhZGQgZGlzcGF0Y2ggZnVuY3Rpb25cbiIpOw0KPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMTsNCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB9DQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGlzcGF0
Y2gtPm9wY29kZSA9IGNvbWJpbmVkX29wY29kZTsNCg0KTG9va3MgZmluZSB0byBtZS4NCg0KVGhh
bmtzLA0KRGVyZWsNCg0K
