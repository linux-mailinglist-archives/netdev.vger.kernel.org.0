Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A0ABF63B
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 17:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfIZPvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 11:51:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43540 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfIZPvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 11:51:53 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8QFXAM7009237;
        Thu, 26 Sep 2019 08:51:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S1g0gcdaZuT/V/rEbetgzobMznuzrYzI7BythI7v7+0=;
 b=lXwAfK6hxl9Mlf+lD2CBfzTYAO+WyzsqKxKRRnueacGl1fQlObmJyF+bR4cVIW4B3pn2
 LnXDXHMe/3rz56DZ9/nbANcGt3Svzl2yyFxwgZ86tcEMtJjjf00vjjFB0VArymraRZeN
 DG9sEMbfUTUwJhm674TUXZ6tnx3AQ2wiEFk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v8cg2cyj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Sep 2019 08:51:50 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 26 Sep 2019 08:51:49 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 26 Sep 2019 08:51:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTswVakXoMPCMqowfL0G/dhnczAqU5ZFPpWmCr09eHexGMebW5JV8RS5mESusRptRes65guA3pIsYuRkWOa0qasGCk7/yHFjinxxVGs0y4WCetd5qM+hOXlVDuPL9lSyt9z0aOgtcW4mQ9gPQh84fANb2gq5/t0PQ9Zb0ZUpRgFyNxhUf+Yk73g+ez9Ydb2wQDKQppXzT+oRNPZGD1SIdfjhJWNce+LI/lHbEXwg3KQcKBfNHhUiheQEbon4BqOG4hgMHNj23Dmytxl+L/pwMG8nhGEu9rupNMhmv6bv8NVuQ86nvOvQHsIjyGTDM1WjVewwt8INTnBwSQ8nv5Ui0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1g0gcdaZuT/V/rEbetgzobMznuzrYzI7BythI7v7+0=;
 b=R5ywRuasq5qPiV/yUNGJJ3gzHqek0zqrKwBwyyQY0n4LaivLFhCBNGbUitG1yEQGNJxDG1X9pNgaWViIgxZq6BCEbqMj9YKIBafKdrNUzkz73/oyUlLysYl7JDwzvg5vSxFa7AAuqXXjqvoNF4ikQMvPU6NGTycUqNK9CnxgNRik8NQGP//3MvdcSYVIJPs2yMZQX9PfLaLZrslfmyM2toCPzI94gaQyV04zaM5xtDZnfc0x9caAFh8FfRPuobswFmMVcw63KX5F3OmwcnQ32rVd9C9aq3l9mHUR27WTbDRapAXl6t9n3L9Er2tCtQp2/YGzktRvDhzhxLxwHGAz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1g0gcdaZuT/V/rEbetgzobMznuzrYzI7BythI7v7+0=;
 b=FUuCP/3wkEEYa87JdA4Nv8LOfBK6xRKEnwFLy3c3zPmJvMnm9GXstX7oPwGhx+rIpdl6NHtNO8VOwfY2OwtZ6o4Zbbb3aMg9MGwmjKbRoka4Z1CyscTjd9nmYIXAycFYv3+sQRZwfXr1ktEt/8ASkufxWEYkgTN6JJ4YWutgxlU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2885.namprd15.prod.outlook.com (20.178.206.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.26; Thu, 26 Sep 2019 15:51:48 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2284.023; Thu, 26 Sep 2019
 15:51:48 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Carlos Neira <cneirabustos@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH V11 0/4] BPF: New helper to obtain namespace data from
 current task
Thread-Topic: [PATCH V11 0/4] BPF: New helper to obtain namespace data from
 current task
Thread-Index: AQHVdAWgq7haa1RJFUyRjOZj8chkCac+HI2A
Date:   Thu, 26 Sep 2019 15:51:48 +0000
Message-ID: <baafb22b-0dbc-bdcf-c692-c924d9d9671b@fb.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <87ef033maf.fsf@x220.int.ebiederm.org>
In-Reply-To: <87ef033maf.fsf@x220.int.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:301:5f::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:b920]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44db073f-d0ae-4c31-be5a-08d742997056
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2885;
x-ms-traffictypediagnostic: BYAPR15MB2885:
x-microsoft-antispam-prvs: <BYAPR15MB2885C17A030B67A8644D4760D3860@BYAPR15MB2885.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(396003)(39860400002)(366004)(199004)(189003)(11346002)(316002)(71200400001)(81166006)(81156014)(36756003)(46003)(2616005)(476003)(8936002)(386003)(102836004)(53546011)(6506007)(256004)(25786009)(71190400001)(110136005)(66946007)(8676002)(66556008)(6116002)(64756008)(66446008)(66476007)(186003)(486006)(54906003)(6436002)(446003)(6486002)(4326008)(6512007)(478600001)(229853002)(7736002)(6246003)(305945005)(14454004)(31696002)(86362001)(2906002)(31686004)(99286004)(52116002)(76176011)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2885;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pFbD2ztGQtrH7WE7BscsGE6VzlXfkSUqhomrx0sJqYnA5iU0kKCwaxqVkMm57Sd9uZCaxCQVBB5hC3N2teTPDdJrVgeVE1808qD1hpLIQNWoawwrHH1Po3gxhIpZvBEGNKvh38s67xf70eyORtul0t2dHM78ueafHoYJ6LL2/yBxfDLrIJmXrvdtDLvz5O8UDXqugO2TciHV+mz9ob0jQqo+suHYFpx56bn9WvWES7uDFjK5Olo5qzGJdNjYm1gCAuAs+CRybBQKyezUgGqCPtxGCSQnOsTcTIL9JUwygr0ojdGwqSF0UYxkdljYAklxkx88XssoghJAXzAorq7vW122Z8LqneRzCMayn/EqEMxpjEr7dGG5/TLdDuoGiz1If1PzUf8Gz7z8t3p+beZrSonx0bQyN0rtuXUX2+yhIT0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4244A1645CFD7D47AB47DA9175696BF9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 44db073f-d0ae-4c31-be5a-08d742997056
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 15:51:48.0705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u/Hlwc3FB1oCud71HXBiuB4uPuMJy9QLET65iAk2oOy989VrEzLYX+3033k74gI8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-26_07:2019-09-25,2019-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909260141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMjUvMTkgNTo1OSBQTSwgRXJpYyBXLiBCaWVkZXJtYW4gd3JvdGU6DQo+IENhcmxv
cyBOZWlyYSA8Y25laXJhYnVzdG9zQGdtYWlsLmNvbT4gd3JpdGVzOg0KPiANCj4+IEN1cnJlbnRs
eSBicGZfZ2V0X2N1cnJlbnRfcGlkX3RnaWQoKSwgaXMgdXNlZCB0byBkbyBwaWQgZmlsdGVyaW5n
IGluIGJjYydzDQo+PiBzY3JpcHRzIGJ1dCB0aGlzIGhlbHBlciByZXR1cm5zIHRoZSBwaWQgYXMg
c2VlbiBieSB0aGUgcm9vdCBuYW1lc3BhY2Ugd2hpY2ggaXMNCj4+IGZpbmUgd2hlbiBhIGJjYyBz
Y3JpcHQgaXMgbm90IGV4ZWN1dGVkIGluc2lkZSBhIGNvbnRhaW5lci4NCj4+IFdoZW4gdGhlIHBy
b2Nlc3Mgb2YgaW50ZXJlc3QgaXMgaW5zaWRlIGEgY29udGFpbmVyLCBwaWQgZmlsdGVyaW5nIHdp
bGwgbm90IHdvcmsNCj4+IGlmIGJwZl9nZXRfY3VycmVudF9waWRfdGdpZCgpIGlzIHVzZWQuDQo+
PiBUaGlzIGhlbHBlciBhZGRyZXNzZXMgdGhpcyBsaW1pdGF0aW9uIHJldHVybmluZyB0aGUgcGlk
IGFzIGl0J3Mgc2VlbiBieSB0aGUgY3VycmVudA0KPj4gbmFtZXNwYWNlIHdoZXJlIHRoZSBzY3Jp
cHQgaXMgZXhlY3V0aW5nLg0KPj4NCj4+IEluIHRoZSBmdXR1cmUgZGlmZmVyZW50IHBpZF9ucyBm
aWxlcyBtYXkgYmVsb25nIHRvIGRpZmZlcmVudCBkZXZpY2VzLCBhY2NvcmRpbmcgdG8gdGhlDQo+
PiBkaXNjdXNzaW9uIGJldHdlZW4gRXJpYyBCaWVkZXJtYW4gYW5kIFlvbmdob25nIGluIDIwMTcg
TGludXggcGx1bWJlcnMgY29uZmVyZW5jZS4NCj4+IFRvIGFkZHJlc3MgdGhhdCBzaXR1YXRpb24g
dGhlIGhlbHBlciByZXF1aXJlcyBpbnVtIGFuZCBkZXZfdCBmcm9tIC9wcm9jL3NlbGYvbnMvcGlk
Lg0KPj4gVGhpcyBoZWxwZXIgaGFzIHRoZSBzYW1lIHVzZSBjYXNlcyBhcyBicGZfZ2V0X2N1cnJl
bnRfcGlkX3RnaWQoKSBhcyBpdCBjYW4gYmUNCj4+IHVzZWQgdG8gZG8gcGlkIGZpbHRlcmluZyBl
dmVuIGluc2lkZSBhIGNvbnRhaW5lci4NCj4gDQo+IEkgdGhpbmsgSSBtYXkgaGF2ZSBhc2tlZCB0
aGlzIGJlZm9yZS4gIElmIEkgYW0gcmVwZWF0aW5nIG9sZCBnb3VuZA0KPiBwbGVhc2UgZXhjdXNl
IG1lLg0KPiANCj4gQW0gSSBjb3JyZWN0IGluIHVuZGVyc3RhbmRpbmcgdGhlc2UgbmV3IGhlbHBl
cnMgYXJlIGRlc2lnbmVkIHRvIGJlIHVzZWQNCj4gd2hlbiBwcm9ncmFtcyBydW5uaW5nIGluIGBg
Y29uYWluZXJzJycgY2FsbCBpdCBpbnNpZGUgcGlkIG5hbWVzcGFjZXMNCj4gcmVnaXN0ZXIgYnBm
IHByb2dyYW1zIGZvciB0cmFjaW5nPw0KDQpSaWdodC4NCg0KPiANCj4gSWYgc28gd291bGQgaXQg
YmUgcG9zc2libGUgdG8gY2hhbmdlIGhvdyB0aGUgZXhpc3RpbmcgYnBmIG9wY29kZXMNCj4gb3Bl
cmF0ZSB3aGVuIHRoZXkgYXJlIHVzZWQgaW4gdGhlIGNvbnRleHQgb2YgYSBwaWQgbmFtZXNwYWNl
Pw0KDQoNClRvZGF5LCB0eXBpY2FsIGJwZiBwcm9ncmFtIGdldHRpbmcgcGlkIGxpa2U6DQogICAg
dWludDY0X3QgcGlkX3RnaWQgPSBicGZfZ2V0X2N1cnJlbnRfcGlkX3RnaWQoKTsNCiAgICBwaWRf
dCBwaWQgPSBwaWRfdGdpZCA+PiAzMjsNCiAgICBwaWRfdCB0aWQgPSBwaWRfdGdpZDsNCg0KICAg
IC8qIHBvc3NpYmxlIGZpbHRlcmluZyAuLi4gKi8NCiAgICBpZiAocGlkID09IDx1c2VyX3Byb3Zp
ZGVkIHBpZD4pIC4uLi4NCiAgICAuLi4NCg0KICAgIC8qIHJlY29yZCBwaWQgaW4gc29tZSBwbGFj
ZXMgKi8NCiAgICBtYXBfdmFsLT5waWQgPSBwaWQ7DQogICAgLi4uDQoNClRoZSBicGZfZ2V0X2N1
cnJlbnRfcGlkX3RnaWQoKSBpcyBhIGtlcm5lbCBoZWxwZXINCiAgICBCUEZfQ0FMTF8wKGJwZl9n
ZXRfY3VycmVudF9waWRfdGdpZCkNCiAgICB7DQogICAgICAgICBzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KnRhc2sgPSBjdXJyZW50Ow0KDQogICAgICAgICBpZiAodW5saWtlbHkoIXRhc2spKQ0KICAgICAg
ICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCg0KICAgICAgICAgcmV0dXJuICh1NjQpIHRhc2st
PnRnaWQgPDwgMzIgfCB0YXNrLT5waWQ7DQogICAgfQ0KDQpTbyB0aGUgYnBmX2dldF9jdXJyZW50
X3BpZF90Z2lkKCkgZ2V0cyB0aGUgdGdpZC9waWQgb3V0c2lkZSBhbnkNCnBpZCBuYW1lc3BhY2Vz
Lg0KDQpUbyBtYWtlIHRoZSBwcm9ncmFtIHdvcmsgaW5zaWRlIHRoZSBjb250YWluZXIsIGp1c3Qg
Z2V0IG5hbWVzcGFjZQ0KcGlkL3RnaWQgbm90IGVub3VnaC4gWW91IG5lZWQgdG8gbWFrZSBzdXJl
IHRoZSBuYW1lc3BhY2UgeW91IGFyZQ0KdHJhY2tpbmcgaXMgdGhlIG9uZSB5b3UgYXJlIGluLiBU
aGF0IGlzIHdoYXQgdGhlIG5ldyBwcm9wb3NlZA0KaGVscGVyIHRvIGRvLg0KDQpEbyB5b3Ugc3Vn
Z2VzdCB3ZSBjaGFuZ2UNCiAgICBicGZfZ2V0X2N1cnJlbnRfcGlkX3RnaWQoKQ0KdG8gcmV0dXJu
IG5hbWVzcGFjZWQgdGdpZC9waWQ/DQpGaXJzdCwgdGhpcyB3aWxsIGJyZWFrIHVzZXIgQVBJIChr
ZXJuZWwgaGVscGVyIGlzIGFuIEFQSSkgYW5kIHNlY29uZCwNCmV2ZW4gaWYgd2UgZG8gZ2V0IHBp
ZC90Z2lkLCB3ZSBzdGlsbCBub3Qgc3VyZSB3aGV0aGVyDQp0aGlzIGlzIGZvciBteSBuYW1lc3Bh
Y2Ugb3Igbm90Lg0KDQpEbyB5b3UgaGF2ZSBzb21ldGhpbmcgaW4gbWluZCB0byBhZGRyZXNzIHRo
aXMgaXNzdWU/DQoNCj4gDQo+IFRoYXQgbGF0ZXIgd291bGQgc2VlbSB0byBhbGxvdyBqdXN0IG1v
dmluZyBhbiBleGlzdGluZyBhcHBsaWNhdGlvbiBpbnRvDQo+IGEgcGlkIG5hbWVzcGFjZSB3aXRo
IG5vIG1vZGlmaWNhdGlvbnMuICAgSWYgd2UgY2FuIGRvIHRoaXMgd2l0aCB0cml2aWFsDQo+IGNv
c3QgYXQgYnBmIGNvbXBpbGUgdGltZSBhbmQgd2l0aCBubyB1c2Vyc3BhY2UgY2hhbmdlcyB0aGF0
IHdvdWxkIHNlZW0NCj4gYSBiZXR0ZXIgYXBwcm9hY2guDQo+IA0KPiBJZiBub3QgY2FuIHNvbWVv
bmUgcG9pbnQgbWUgdG8gd2h5IHdlIGNhbid0IGRvIHRoYXQ/ICBXaGF0IGFtIEkgbWlzc2luZz8N
Cj4gDQo+IEVyaWMNCj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBDYXJsb3MgTmVpcmEgPGNuZWlyYWJ1
c3Rvc0BnbWFpbC5jb20+DQo+Pg0KPj4gQ2FybG9zIE5laXJhICg0KToNCj4+ICAgIGZzL25zZnMu
YzogYWRkZWQgbnNfbWF0Y2gNCj4+ICAgIGJwZjogYWRkZWQgbmV3IGhlbHBlciBicGZfZ2V0X25z
X2N1cnJlbnRfcGlkX3RnaWQNCj4+ICAgIHRvb2xzOiBBZGRlZCBicGZfZ2V0X25zX2N1cnJlbnRf
cGlkX3RnaWQgaGVscGVyDQo+PiAgICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGY6IEFkZCBz
ZWxmLXRlc3RzIGZvciBuZXcgaGVscGVyLiBzZWxmIHRlc3RzDQo+PiAgICAgIGFkZGVkIGZvciBu
ZXcgaGVscGVyDQo+Pg0KPj4gICBmcy9uc2ZzLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDggKw0KPj4gICBpbmNsdWRlL2xpbnV4L2JwZi5oICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgIDEgKw0KPj4gICBpbmNsdWRlL2xpbnV4L3Byb2NfbnMuaCAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIDIgKw0KPj4gICBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmggICAg
ICAgICAgICAgICAgICAgICAgfCAgMTggKystDQo+PiAgIGtlcm5lbC9icGYvY29yZS5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+PiAgIGtlcm5lbC9icGYvaGVscGVycy5j
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAzMiArKysrDQo+PiAgIGtlcm5lbC90cmFjZS9i
cGZfdHJhY2UuYyAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArDQo+PiAgIHRvb2xzL2luY2x1
ZGUvdWFwaS9saW51eC9icGYuaCAgICAgICAgICAgICAgICB8ICAxOCArKy0NCj4+ICAgdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL01ha2VmaWxlICAgICAgICAgIHwgICAyICstDQo+PiAgIHRv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9icGZfaGVscGVycy5oICAgICB8ICAgMyArDQo+PiAg
IC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfcGlkbnNfa2Vybi5jICAgICB8ICA3MSArKysr
KysrKw0KPj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9waWRucy5jICAgICAg
fCAxNTIgKysrKysrKysrKysrKysrKysrDQo+PiAgIDEyIGZpbGVzIGNoYW5nZWQsIDMwNyBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfcGlkbnNfa2Vybi5jDQo+PiAgIGNyZWF0
ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9waWRucy5jDQo=
