Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7067AF5315
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKHR5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:57:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55414 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfKHR5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:57:32 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8Hnvk5015608;
        Fri, 8 Nov 2019 09:57:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JFuw5ia8j8ftRFTZ/qZ2G7CLDyiBmOaq7yoTr7y2Kew=;
 b=mCZXKqgnd9s4SZUfdrKV6M2HUyXiTHxFgw/uqcmLajox9eEOBTTQzZvkUhOT/FN/0a5Q
 Wtgsxqtnf3KYZWoU5mnF96RYhUTkEhZJNLyhAERM5KEsli2ajLHF5YkpUqNTUg1d/It+
 3LYXNDEJUeFuhp29RJTp79icY+RU2WWixMs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0vkye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 09:57:14 -0800
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 09:57:11 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 09:57:11 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 09:57:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJTAUurExCyj7qIUmTcFgxt8lXvaggBBPMZC2hoZMuN15puKtlIhTgJwqHNKa6Ai5fQzQfTbgCduNys2wmA3yJezkfdQEa51jQfZlQd9yKnfxZXTKifn0hmeOfiasRd5ARzsqKCBbqHK9W6uXdYkOKj054t6EjDLL877xlxJITdickJEHjfy20TCIkJUvPsv7LNRFYpgO0ZmEMyRmOUdButQ4APJsE+DnBEdaV8rk8qtfWGk7mWtuQesIGgNrW7CYwfKZaLHqhG2pAhXHpUvj1EHRmDDpqqUavIVj1/5zZRbv3wx3t5Flffeg6tjtqNxBTGDktXE0k51EZEHjy3fBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFuw5ia8j8ftRFTZ/qZ2G7CLDyiBmOaq7yoTr7y2Kew=;
 b=lyDSJeFk8+PuU72Oga4lo35mjKWO4FtZok7mEL3io9AzaQaN8VZifemjWF9xwnwq3Q+TwapWnbhvF7uW7CYfCLpbpzNskuLn1dmwAPNafm4y1Irx2EZ/ijllFEgbMPFA49ci9AjQFCXsUlyJ7MjPwBLtUf9r4MTCodzd4CRX0Ip5hnrcD/yEsua0mRuaZDKc9Z3MNqCBfgezVjAMQnnPH9YxKA9okffYLzZ3jSRMEcMACTsv8jpW8DrZ1YX//d1893YiTCxT42WiFiBSeTyaJ1IQ4yaRaHmhYhTPEnKwyhfWROb5pIxkzitL5evzlKwuvlpD30dXrwsykpbwsztuhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFuw5ia8j8ftRFTZ/qZ2G7CLDyiBmOaq7yoTr7y2Kew=;
 b=iK4S6RrqUtZizZlSfWFlqONvEeuWuEcLNn+7a0yhZecR4/wPFevMKVytsbeL++xNLAe3rcu9dYuDj0hBCG5u8NlgIHlK+F8JXYhfgaa1G7dEaMqkgOhn2WNsvUWRSgGOPtWjDzOpHOJxZsax3fJmesAgkmwpDIqqNQd4ngQ9El0=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2997.namprd15.prod.outlook.com (20.178.239.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 17:57:09 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 17:57:09 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
Thread-Topic: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
Thread-Index: AQHVlf+a45eMndfYaEWseX3SuBD4AKeBh9kAgAABKgCAAAbbAA==
Date:   Fri, 8 Nov 2019 17:57:09 +0000
Message-ID: <a95217de-16b2-4150-51a1-513f190e2079@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-15-ast@kernel.org>
 <0A1C27F0-25D9-455C-86DF-97AC19674D8D@fb.com>
 <0E317F4C-F81F-43D2-9B8E-D8EE93C98A07@fb.com>
In-Reply-To: <0E317F4C-F81F-43D2-9B8E-D8EE93C98A07@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0074.namprd17.prod.outlook.com
 (2603:10b6:300:c2::12) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9599f744-f082-4b36-3574-08d764751326
x-ms-traffictypediagnostic: BYAPR15MB2997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2997A61706C22569DD6AE975D77B0@BYAPR15MB2997.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(36756003)(6116002)(316002)(99286004)(7736002)(31686004)(54906003)(110136005)(81156014)(8936002)(81166006)(46003)(86362001)(25786009)(8676002)(76176011)(6486002)(305945005)(6436002)(71190400001)(52116002)(71200400001)(478600001)(229853002)(6246003)(186003)(2906002)(14454004)(5024004)(256004)(53546011)(14444005)(486006)(102836004)(6512007)(31696002)(64756008)(66946007)(66476007)(2616005)(446003)(66556008)(66446008)(386003)(6506007)(4326008)(5660300002)(476003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2997;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0UlNBlyeZpbknWPj9XzLoFEDKSiFVb6KzkuCVDb9m5xa7uigT96kBzLjmurwtSQNXGE6r8PwX+oAjG4CMEz6LKGsFn5zwXf7Q5pem+KO8AsUDqAhcEv3pcS/U/OuqiFAfs4XLqDjiv7sV4z+jrCNNCnViujf+Irbi7/86IULOAhwMGE35Vnu4EXjnz6NJC7O0sVwg9FbriyWEZO/c/kZcZsL7Ycvo6R6/NAN0VGq+RAFNzh16S6ldPuVQ/QmkJCgfIU+OCtwN9ZmxliMxmRTTPrmWxQft7r1ooEWhBpFkfk+LpPPSHjnuqHWsqlW2YEzXRWrBbe8NU0RdhkgOihVNPoIQIXanHJdUD8RmfqF/3fAHKhUEK884trE+ka/UJOHGUw19CpQpo+Ig8m7p8rXY/6Vve8eGkye+0g4NFo1ehyAg7S4pjAzhByRotXi2Ty0
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5DFF83A5728864492A66F37B6F45C8C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9599f744-f082-4b36-3574-08d764751326
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 17:57:09.4755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dRfIG1ox/8urP/v7ijMgATgdacIRJ0lLf6EsEVzleVNazT+NFDJ3uTYvMxxlCHn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2997
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_06:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=589
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvOC8xOSA5OjMyIEFNLCBTb25nIExpdSB3cm90ZToNCj4gDQo+IA0KPj4gT24gTm92IDgs
IDIwMTksIGF0IDk6MjggQU0sIFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+IHdyb3Rl
Og0KPj4NCj4+DQo+Pg0KPj4+IE9uIE5vdiA3LCAyMDE5LCBhdCAxMDo0MCBQTSwgQWxleGVpIFN0
YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4NCj4+PiBNYWtlIHRoZSB2ZXJp
ZmllciBjaGVjayB0aGF0IEJURiB0eXBlcyBvZiBmdW5jdGlvbiBhcmd1bWVudHMgbWF0Y2ggYWN0
dWFsIHR5cGVzDQo+Pj4gcGFzc2VkIGludG8gdG9wLWxldmVsIEJQRiBwcm9ncmFtIGFuZCBpbnRv
IEJQRi10by1CUEYgY2FsbHMuIElmIHR5cGVzIG1hdGNoDQo+Pj4gc3VjaCBCUEYgcHJvZ3JhbXMg
YW5kIHN1Yi1wcm9ncmFtcyB3aWxsIGhhdmUgZnVsbCBzdXBwb3J0IG9mIEJQRiB0cmFtcG9saW5l
LiBJZg0KPj4+IHR5cGVzIG1pc21hdGNoIHRoZSB0cmFtcG9saW5lIGhhcyB0byBiZSBjb25zZXJ2
YXRpdmUuIEl0IGhhcyB0byBzYXZlL3Jlc3RvcmUNCj4+PiBhbGwgNSBwcm9ncmFtIGFyZ3VtZW50
cyBhbmQgYXNzdW1lIDY0LWJpdCBzY2FsYXJzLiBJZiBGRU5UUlkvRkVYSVQgcHJvZ3JhbSBpcw0K
Pj4+IGF0dGFjaGVkIHRvIHRoaXMgcHJvZ3JhbSBpbiB0aGUgZnV0dXJlIHN1Y2ggRkVOVFJZL0ZF
WElUIHByb2dyYW0gd2lsbCBiZSBhYmxlDQo+Pj4gdG8gZm9sbG93IHBvaW50ZXJzIG9ubHkgdmlh
IGJwZl9wcm9iZV9yZWFkX2tlcm5lbCgpLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGVp
IFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4NCj4+DQo+PiBBY2tlZC1ieTogU29uZyBMaXUg
PHNvbmdsaXVicmF2aW5nQGZiLmNvbT4NCj4gDQo+IE9uZSBuaXQgdGhvdWdoOiBtYXliZSB1c2Ug
InJlbGlhYmxlIiBpbnN0ZWFkIG9mICJ1bnJlbGlhYmxlIg0KPiANCj4gK3N0cnVjdCBicGZfZnVu
Y19pbmZvX2F1eCB7DQo+ICsJYm9vbCByZWxpYWJsZTsNCj4gK307DQo+ICsNCj4gDQo+ICsJYm9v
bCBmdW5jX3Byb3RvX3JlbGlhYmxlOw0KPiANCj4gU28gdGhlIGRlZmF1bHQgdmFsdWUgMCwgaXMg
bm90IHJlbGlhYmxlLg0KDQpJIGRvbid0IHNlZSBob3cgdGhpcyBjYW4gd29yay4NCk9uY2UgcGFy
dGljdWxhciBmdW5jIHByb3RvIHdhcyBmb3VuZCB1bnJlbGlhYmxlIHRoZSB2ZXJpZmllciB3b24n
dCBrZWVwIA0KY2hlY2tpbmcuIElmIHdlIHN0YXJ0IHdpdGggJ2Jvb2wgcmVsaWFibGUgPSBmYWxz
ZScNCmhvdyBkbyB5b3Ugc2VlIHRoZSB3aG9sZSBtZWNoYW5pc20gd29ya2luZyA/DQpTYXkgdGhl
IGZpcnN0IHRpbWUgdGhlIHZlcmlmaWVyIGFuYWx5emVkIHRoZSBzdWJyb3V0aW5lIGFuZCBldmVy
eXRoaW5nDQptYXRjaGVzLiBDYW4gaXQgZG8gcmVsaWFibGUgPSB0cnVlID8gTm8uIEl0IGhhcyB0
byBjaGVjayBhbGwgb3RoZXINCmNhbGxzaXRlcy4gVGhlbiBpdCB3b3VsZCBuZWVkIGFub3RoZXIg
dmFyaWFibGUgYW5kIGV4dHJhIHBhc3MgPw0KDQo=
