Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC218A776D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 01:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfICXId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 19:08:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19930 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbfICXId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 19:08:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83N82X5024721;
        Tue, 3 Sep 2019 16:08:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NPaatCBYrZlr1twnJMS5UWdb8Hh1IkS7Nj9rCQdjeMA=;
 b=S2tu5NKe9d4YS30rRjjtS6/JoGBg8ZyVBW06Z7EgQUCQinl5z5B+TCKkHZhtRgYhiCd/
 nUf8Na1XJzTaEdv+e+0HMmHbZqOXtUaJiq67Q4zy6btqCnpAL0qxCuNykznwvOPajOgU
 JRlvPcHVWoqbQ+LWwG0rqfNX/rxEgjcVWyA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2usu2fj05g-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 16:08:07 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 3 Sep 2019 16:07:57 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 3 Sep 2019 16:07:56 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 3 Sep 2019 16:07:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9e/w30WNarkr51FQ8hKTJHAiraCHPAlLwPaQVNFjp/oGakVWoDgB9mCsTc2FDPRiepFzCoYnjt5qnv2Z0ImSjHCF9E9aXTCb5CYx1AoccVyckn6wHPHGU+1yK9Q+lKBynlbHDTzMsVyl+zuhBTu5AZ7sm3OzEwCjWbc2oLEmKjKCETnLodjvmv+TrGX6TDYQtIRO526x/NtnTLe8oMMIX/IQXEVEhe4qhDth0SVBqKn5wRoXZSCOJc3e6djmO4JSBABc9A65I1SH1xCWsa7RtNB5TdL0TkLOHU8E7WVN52d5jf334WyWmO52cRVHRpQsdaHREa7avyUuo+nJqRgzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPaatCBYrZlr1twnJMS5UWdb8Hh1IkS7Nj9rCQdjeMA=;
 b=jzvTu3u/HW5SIpJpV+5Ctx88kJx7HexM8z3uARv2THOQrGFo3upugQTGbhRnf/oMKSOEWpkU+Zfyp/1dzX13/Xoa0mgxq5Vx1mpIYo2+msTM3vqTXxWAeWaeFcoiqGajELFmwKNBUe2VeeXmlvmdcsA42NSNuRWet1pFsYTskhsC3OHouC6jiKsb8IM6ny3R+CE7DKT3dxe0wIki8BHKtERhF0djkCqsTkn6DkKpvLYAPo381OSH/Sbkkg9iGGCzg64AjV0eXO8bFGKuSDC5R96LZHJpBxVD4YVIk5dbajl58g5wPr5U3mHvwWkt72GJlKFyhXJjpvKhzIL9MeFC3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPaatCBYrZlr1twnJMS5UWdb8Hh1IkS7Nj9rCQdjeMA=;
 b=YDvcX+3GWhlexqzWnHHDZXNIraC8LJqghT8q3xczchiUbZYwyjHaVYYahsfYbBXn3FaO/WS9axAIBdumgL7z0IlRnzlfu+2jl4SuidQGisHRiJBS+efNXibdytPzVaTYYHLKmDfNplKR60BzP5u9bR8kKh+vX04KkX0uTaH570k=
Received: from BN8PR15MB3380.namprd15.prod.outlook.com (20.179.76.22) by
 BN8PR15MB3332.namprd15.prod.outlook.com (20.179.74.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Tue, 3 Sep 2019 23:07:55 +0000
Received: from BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::ac59:4764:67d5:8f09]) by BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::ac59:4764:67d5:8f09%7]) with mapi id 15.20.2220.022; Tue, 3 Sep 2019
 23:07:55 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Topic: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Index: AQHVXjVV7RBe3Y+1zUuAbrXegepHf6cSdccAgABMroCAABEcgIABT0aAgAALQgCABksQh4AAGN6AgAAKXgA=
Date:   Tue, 3 Sep 2019 23:07:54 +0000
Message-ID: <83be02e1-badb-0749-4278-a07bc5b76e78@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
 <20190830211809.GB2101@mini-arch>
 <20190903210127.z6mhkryqg6qz62dq@ast-mbp.dhcp.thefacebook.com>
 <20190903223043.GC2101@mini-arch>
In-Reply-To: <20190903223043.GC2101@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0080.namprd17.prod.outlook.com
 (2603:10b6:300:c2::18) To BN8PR15MB3380.namprd15.prod.outlook.com
 (2603:10b6:408:a8::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:1b1f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6b56421-226f-4574-d959-08d730c38d89
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB3332;
x-ms-traffictypediagnostic: BN8PR15MB3332:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB3332F0E2851E65BA4C450287D3B90@BN8PR15MB3332.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(366004)(396003)(136003)(189003)(199004)(6306002)(6512007)(25786009)(6116002)(31686004)(386003)(53546011)(186003)(6506007)(6436002)(4326008)(86362001)(31696002)(102836004)(5660300002)(6246003)(14454004)(966005)(53936002)(6486002)(8936002)(2906002)(316002)(476003)(2616005)(110136005)(54906003)(229853002)(81166006)(486006)(81156014)(11346002)(446003)(99286004)(52116002)(8676002)(305945005)(561944003)(256004)(14444005)(76176011)(71190400001)(71200400001)(66946007)(66446008)(36756003)(7736002)(478600001)(46003)(64756008)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3332;H:BN8PR15MB3380.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ABrH1Fu6etWHZJd2DDMSCv25VeoCGH7jCSTrmg6wev/yxt70x6r45t3ZUs+yO9X74bd7jfNs6nX0VjC74brvBRHksa4bKyaDOyF+2E8n7tN2Lk9/W06cYYanGjluS1N6Y0Svjq13k6HjjRNxXn8pVtGE5si8YrND+w3gF/icuCYA/XsocFcTgcMq6sWt2nxkYTrIEpS9bX/lZ9F26p+vj/pgh7MTq9lBYk7lzf3i41U65SafXz86eQgwit1Apca3zkCFS/ThYdQANg8VfHUoB6MagutFt11qGEj3rzUxNONttrBVX8TxgtlA0h7ppOwl3iRqNR6VJUdbPgPGo+wmrl3uIddl+XfSDlZrastlFZPNsQl59Aq879sgLqg8eBQP7IDB/OYEMQDILCjlRMR923LezyfO/i4uB4dJU8BzFfE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C07E2DEC87426744A7DF8BD435D81B00@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b56421-226f-4574-d959-08d730c38d89
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 23:07:55.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k8cLS9LXnZE9/zFSqELksT0aOhS87nyPSI4qsscKYg3G6nYT7xjJLdIm4PEGpcuz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3332
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_05:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1011 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030232
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMy8xOSAzOjMwIFBNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IE9uIDA5
LzAzLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+PiBPbiBGcmksIEF1ZyAzMCwgMjAxOSBh
dCAwMjoxODowOVBNIC0wNzAwLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+Pj4+Pg0KPj4+
Pj4gSSBwZXJzb25hbGx5IGxpa2UgSmFrdWIncy9RdWVudGluJ3MgcHJvcG9zYWwgbW9yZS4gU28g
aWYgSSBnZXQgdG8gY2hvb3NlDQo+Pj4+PiBiZXR3ZWVuIHRoaXMgc2VyaWVzIGFuZCBKYWt1Yidz
IGZpbHRlcitkdW1wIGluIEJQRiwgSSdkIHBpY2sgZmlsdGVyK2R1bXANCj4+Pj4+IChwZW5kaW5n
IHBlci1jcHUgaXNzdWUgd2hpY2ggd2UgYWN0dWFsbHkgY2FyZSBhYm91dCkuDQo+Pj4+Pg0KPj4+
Pj4gQnV0IGlmIHdlIGNhbiBoYXZlIGJvdGgsIEkgZG9uJ3QgaGF2ZSBhbnkgb2JqZWN0aW9uczsg
dGhpcyBwYXRjaA0KPj4NCj4+IEkgdGhpbmsgd2UgbmVlZCB0byBoYXZlIGJvdGguDQo+PiBpbW8g
SmFrdWIncyBhbmQgWW9uZ2hvbmcncyBhcHByb2FjaCBhcmUgc29sdmluZyBzbGlnaHRseSBkaWZm
ZXJlbnQgY2FzZXMuDQo+Pg0KPj4gZmlsdGVyK2R1bXAgdmlhIHByb2dyYW0gaXMgYmV0dGVyIHN1
aXRlZCBmb3IgTFJVIG1hcCB3YWxrcyB3aGVyZSBmaWx0ZXIgcHJvZw0KPj4gd291bGQgZG8gc29t
ZSBub24tdHJpdmlhbCBsb2dpYy4NCj4+IFdoZXJlYXMgcGxhaW4gJ2RlbGV0ZSBhbGwnIG9yICdk
dW1wIGFsbCcgaXMgbXVjaCBzaW1wbGVyIHRvIHVzZSB3aXRob3V0DQo+PiBsb2FkaW5nIHlldCBh
bm90aGVyIHByb2cganVzdCB0byBkdW1wIGl0Lg0KPj4gYnBmIGluZnJhIHRvZGF5IGlzbid0IHF1
aXRlIHJlYWR5IGZvciB0aGlzIHZlcnkgc2hvcnQgbGl2ZWQgYXV4aWxpYXJ5IHByb2dzLg0KPj4g
QXQgcHJvZyBsb2FkIHBhZ2VzIGdldCByZWFkLW9ubHkgbWFwcGluZywgdGxicyBhY3Jvc3MgY3B1
cyBmbHVzaGVkLA0KPj4ga2FsbHN5bXMgcG9wdWxhdGVkLCBGRHMgYWxsb2NhdGVkLCBldGMuDQo+
PiBMb2FkaW5nIHRoZSBwcm9nIGlzIGEgaGVhdnkgb3BlcmF0aW9uLiBUaGVyZSB3YXMgYSBjaGF0
dGVyIGJlZm9yZSB0byBoYXZlDQo+PiBidWlsdC1pbiBwcm9ncy4gVGhpcyBmaWx0ZXIrZHVtcCBj
b3VsZCBiZW5lZml0IGZyb20gYnVpbHRpbiAnYWxsb3cgYWxsJw0KPj4gb3IgJ2RlbGV0ZSBhbGwn
IHByb2dzLCBidXQgaW1vIHRoYXQgY29tcGxpY2F0ZXMgZGVzaWduIGFuZCBhc2tzIGV2ZW4NCj4+
IG1vcmUgcXVlc3Rpb25zIHRoYW4gaXQgYW5zd2Vycy4gU2hvdWxkIHRoaXMgYnVpbHRpbiBwcm9n
cyBzaG93IHVwDQo+PiBpbiAnYnBmdG9vbCBwcm9nIHNob3cnID8gV2hlbiBkbyB0aGV5IGxvYWQv
dW5sb2FkPyBTYW1lIHNhZmV0eSByZXF1aXJlbWVudHMNCj4+IGFzIG5vcm1hbCBwcm9ncz8gZXRj
Lg0KPj4gaW1vIGl0J3MgZmluZSB0byBoYXZlIGxpdHRsZSBiaXQgb3ZlcmxhcCBiZXR3ZWVuIGFw
aXMuDQo+PiBTbyBJIHRoaW5rIHdlIHNob3VsZCBwcm9jZWVkIHdpdGggYm90aCBiYXRjaGluZyBh
cGlzLg0KPiBXZSBkb24ndCBuZWVkIHRvIGxvYWQgZmlsdGVyK2R1bXAgZXZlcnkgdGltZSB3ZSBu
ZWVkIGEgZHVtcCwgcmlnaHQ/DQo+IFdlLCBpbnRlcm5hbGx5LCB3YW50IHRvIGhhdmUgdGhpcyAn
YmF0Y2ggZHVtcCcgb25seSBmb3IgbG9uZyBydW5uaW5nIGRhZW1vbnMNCj4gKEkgdGhpbmsgdGhl
IHNhbWUgYXBwbGllcyB0byBiY2MpLCB3ZSBjYW4gbG9hZCB0aGlzIGZpbHRlcitkdW1wIG9uY2Ug
YW5kDQo+IHRoZW4gaGF2ZSBhIHN5c19icGYoKSBjb21tYW5kIHRvIHRyaWdnZXIgaXQuDQo+IA0K
PiBBbHNvLCByZWxhdGVkLCBpZiB3ZSBhZGQgdGhpcyBiYXRjaCBkdW1wLCBpdCBkb2Vzbid0IG1l
YW4gdGhhdA0KPiBldmVyeXRoaW5nIHNob3VsZCBzd2l0Y2ggdG8gaXQuIEZvciBleGFtcGxlLCBJ
IGZlZWwgbGlrZSB3ZQ0KPiBhcmUgcGVyZmVjdGx5IGZpbmUgaWYgYnBmdG9vbCBzdGlsbCB1c2Vz
IGdldF9uZXh0X2tleStsb29rdXANCj4gc2luY2Ugd2UgdXNlIGl0IG9ubHkgZm9yIGRlYnVnZ2lu
Zy4NCj4gDQo+PiBIYXZpbmcgc2FpZCB0aGF0IEkgdGhpbmsgYm90aCBhcmUgc3VmZmVyaW5nIGZy
b20gdGhlIGltcG9ydGFudCBpc3N1ZSBwb2ludGVkIG91dA0KPj4gYnkgQnJpYW46IHdoZW4ga2Vy
bmVsIGRlbGV0ZXMgYW4gZWxlbWVudCBnZXRfbmV4dF9rZXkgaXRlcmF0b3Igb3ZlciBoYXNoL2xy
dQ0KPj4gbWFwIHdpbGwgcHJvZHVjZSBkdXBsaWNhdGVzLg0KPj4gVGhlIGFtb3VudCBvZiBkdXBs
aWNhdGVzIGNhbiBiZSBodWdlLiBXaGVuIGJhdGNoZWQgaXRlcmF0b3IgaXMgc2xvdyBhbmQNCj4+
IGJwZiBwcm9nIGlzIGRvaW5nIGEgbG90IG9mIHVwZGF0ZS9kZWxldGUsIHRoZXJlIGNvdWxkIGJl
IDEweCB3b3J0aCBvZiBkdXBsaWNhdGVzLA0KPj4gc2luY2Ugd2FsayB3aWxsIHJlc3VtZSBmcm9t
IHRoZSBiZWdpbm5pbmcuDQo+PiBVc2VyIHNwYWNlIGNhbm5vdCBiZSB0YXNrZWQgdG8gZGVhbCB3
aXRoIGl0Lg0KPj4gSSB0aGluayB0aGlzIGlzc3VlIGhhcyB0byBiZSBzb2x2ZWQgaW4gdGhlIGtl
cm5lbCBmaXJzdCBhbmQgaXQgbWF5IHJlcXVpcmUNCj4+IGRpZmZlcmVudCBiYXRjaGluZyBhcGku
DQo+Pg0KPj4gT25lIGlkZWEgaXMgdG8gdXNlIGJ1Y2tldCBzcGluX2xvY2sgYW5kIGJhdGNoIHBy
b2Nlc3MgaXQgYnVja2V0LWF0LWEtdGltZS4NCj4+ICBGcm9tIGFwaSBwb3YgdGhlIHVzZXIgc3Bh
Y2Ugd2lsbCB0ZWxsIGtlcm5lbDoNCj4+IC0gaGVyZSBpcyB0aGUgYnVmZmVyIGZvciBOIGVsZW1l
bnQuIHN0YXJ0IGR1bXAgZnJvbSB0aGUgYmVnaW5uaW5nLg0KPj4gLSBrZXJuZWwgd2lsbCByZXR1
cm4gPD0gTiBlbGVtZW50cyBhbmQgYW4gaXRlcmF0b3IuDQo+PiAtIHVzZXIgc3BhY2Ugd2lsbCBw
YXNzIHRoaXMgb3BhcXVlIGl0ZXJhdG9yIGJhY2sgdG8gZ2V0IGFub3RoZXIgYmF0Y2gNCj4+IEZv
ciB3ZWxsIGJlaGF2ZWQgaGFzaC9scnUgbWFwIHRoZXJlIHdpbGwgYmUgemVybyBvciBvbmUgZWxl
bWVudHMgcGVyIGJ1Y2tldC4NCj4+IFdoZW4gdGhlcmUgYXJlIDIrIHRoZSBiYXRjaGluZyBsb2dp
YyBjYW4gcHJvY2VzcyB0aGVtIHRvZ2V0aGVyLg0KPj4gSWYgJ2xvb2t1cCcgaXMgcmVxdWVzdGVk
IHRoZSBrZXJuZWwgY2FuIGNoZWNrIHdoZXRoZXIgdXNlciBzcGFjZSBwcm92aWRlZA0KPj4gZW5v
dWdoIHNwYWNlIGZvciB0aGVzZSAyIGVsZW1lbnRzLiBJZiBub3QgYWJvcnQgdGhlIGJhdGNoIGVh
cmxpZXIuDQo+PiBnZXRfbmV4dF9rZXkgd29uJ3QgYmUgdXNlZC4gSW5zdGVhZCBzb21lIHNvcnQg
b2Ygb3BhcXVlIGl0ZXJhdG9yDQo+PiB3aWxsIGJlIHJldHVybmVkIHRvIHVzZXIgc3BhY2UsIHNv
IG5leHQgYmF0Y2ggbG9va3VwIGNhbiBzdGFydCBmcm9tIGl0Lg0KPj4gVGhpcyBpdGVyYXRvciBj
b3VsZCBiZSB0aGUgaW5kZXggb2YgdGhlIGxhc3QgZHVtcGVkIGJ1Y2tldC4NCj4+IFRoaXMgaWRl
YSB3b24ndCB3b3JrIGZvciBwYXRob2xvZ2ljYWwgaGFzaCB0YWJsZXMgdGhvdWdoLg0KPj4gQSBs
b3Qgb2YgZWxlbWVudHMgaW4gYSBzaW5nbGUgYnVja2V0IG1heSBiZSBtb3JlIHRoYW4gcm9vbSBm
b3Igc2luZ2xlIGJhdGNoLg0KPj4gSW4gc3VjaCBjYXNlIGl0ZXJhdG9yIHdpbGwgZ2V0IHN0dWNr
LCBzaW5jZSBudW1fb2ZfZWxlbWVudHNfaW5fYnVja2V0ID4gYmF0Y2hfYnVmX3NpemUuDQo+PiBN
YXkgYmUgc3BlY2lhbCBlcnJvciBjb2RlIGNhbiBiZSB1c2VkIHRvIHNvbHZlIHRoYXQ/DQo+IFRo
aXMgYWxsIHJlcXVpcmVzIG5ldyBwZXItbWFwIGltcGxlbWVudGF0aW9ucyB1bmZvcnR1bmF0ZWx5
IDotKA0KPiBXZSB3ZXJlIHRyeWluZyB0byBzZWUgaWYgd2UgY2FuIHNvbWVob3cgaW1wcm92ZSB0
aGUgZXhpc3RpbmcgYnBmX21hcF9vcHMNCj4gdG8gYmUgbW9yZSBmcmllbmRseSB0b3dhcmRzIGJh
dGNoaW5nLg0KDQpUaGUgYmVsb3cgaXMgYSBsaW5rIHRvIGZvbGx5IGN1cnJlbnQgaGFzaG1hcCBp
bXBsZW1lbnRhdGlvbjoNCmh0dHBzOi8vZ2l0aHViLmNvbS9mYWNlYm9vay9mb2xseS9ibG9iL21h
c3Rlci9mb2xseS9jb25jdXJyZW5jeS9Db25jdXJyZW50SGFzaE1hcC5oDQpJdCB1c2VzIHNlZ21l
bnQgbGV2ZWwgYmF0Y2hpbmcgYW5kIGVhY2ggc2VnbWVudCBjYW4gY29udGFpbiBtdWx0aXBsZSAN
CmJ1Y2tldHMuIEl0IHN1cHBvcnQgY29uY3VycmVudCBpdGVyYXRpbmcgdnMuIGRlbGV0aW9uLg0K
SSBhbSB5ZXQgdG8gZnVsbHkgdW5kZXJzdGFuZCBpdHMgaW1wbGVtZW50YXRpb24uIEJ1dCBteSBn
dWVzcyBpcw0KdGhhdCBvbGQgZWxlbWVudHMgYXJlIHNvbWVob3cga2VwdCBsb25nIGVub3VnaCB1
bnRpbCBhbGwgdGhlDQpxdWVyaWVzLCByZWFkLCBldGMuIGRvbmUgYW5kIHRoZW4gZ2FyYmFnZSBj
b2xsZWN0aW9uIGtpY2tzIGluDQphbmQgcmVtb3ZlcyB0aG9zZSBvbGQgZWxlbWVudHMuDQoNCktl
cm5lbCBidWNrZXQtbGV2ZWwgbG9ja2luZyBzaG91bGQgYmUgb2theS4gSW5kZWVkLCBwZXItbWFw
IA0KaW1wbGVtZW50YXRpb24gb3IgdHdlYWtpbmcgZXhpc3RpbmcgcGVyLW1hcCBpbnRlcmZhY2Vz
IHdpbGwgYmUgbmVjZXNzYXJ5Lg0KDQo+IA0KPiBZb3UgYWxzbyBicmluZyBhIHZhbGlkIHBvaW50
IHdpdGggcmVnYXJkIHRvIHdlbGwgYmVoYXZlZCBoYXNoL2xydSwNCj4gd2UgbWlnaHQgYmUgb3B0
aW1pemluZyBmb3IgdGhlIHdyb25nIGNhc2UgOi0pDQo+IA0KPj4gSSBob3BlIHdlIGNhbiBjb21l
IHVwIHdpdGggb3RoZXIgaWRlYXMgdG8gaGF2ZSBhIHN0YWJsZSBpdGVyYXRvciBvdmVyIGhhc2gg
dGFibGUuDQo+PiBMZXQncyB1c2UgZW1haWwgdG8gZGVzY3JpYmUgdGhlIGlkZWFzIGFuZCB1cGNv
bWluZyBMUEMgY29uZmVyZW5jZSB0bw0KPj4gc29ydCBvdXQgZGV0YWlscyBhbmQgZmluYWxpemUg
dGhlIG9uZSB0byB1c2UuDQo=
