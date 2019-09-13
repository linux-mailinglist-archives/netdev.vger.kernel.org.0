Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD991B1761
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 04:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfIMC4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 22:56:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726032AbfIMC4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 22:56:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8D2qigv029377;
        Thu, 12 Sep 2019 19:56:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CO5zvAoHgkb3bpHx9QsDhDEEt3JfL520t573RAcDTBA=;
 b=RaXOu+iG/buMKn0Sbxh3UIS0hxBL92ocujXsrXLfpfZfavCreYz60IMXG9NDI5Nwee+h
 6PEmtio4ImbagKM1sE1XzFEtIeAcuH1W16zlZuywD6BbpOK2/3V4SP01LK/btaLvmb5b
 6iHcz78jXETNj6PPNSqHFAD2BCTHH0nYy4U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2uytctt5t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Sep 2019 19:56:45 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Sep 2019 19:56:44 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Sep 2019 19:56:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i16GwyvUo37LOWdeG6gTkHD+N9MxPKJ8yrCKDl3z49jvwP1nwJWjSk8L8rR8eC7zZ0igTJxanOxoOohh7sLS+ZaqQgqYF56TEuUdlob7bYNyHxsx6t8D36NdITW2Im6sm/qSmu4jrfpkT56jWVN0E8FeE/MxJf1NZaw88JLsx0RPXW2R+6TvuIBp20pgwYh8OdtZTFFLU6q6+aACGtSg60enZQ2TWbQQJ8ts0URu6XzJWpQyQefIFCkj9JhZfh7qDTib/WkmjID7g/2Bh86t7ZFbBgv09kpjo8VLRwve53i0iNpRcnPekTN2LDaIuco4t/gGw3XvZ+eku3gWhxBpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CO5zvAoHgkb3bpHx9QsDhDEEt3JfL520t573RAcDTBA=;
 b=VwGq69PiE1Izq8XLXu5DVoM7TcHIat+LqvbVjQ7O8XhMIELa8rc8Xdep6dJBiPGLcf+Yzswgy6vbPL35TslcDC8HzYLpM2zhnuVLcVka9DlAcE1VlUv3MjZi0UleD2V3jCng/5kqFEH+4Vy6Uea2hj5mzmpmOqpBrhJGFbvxci49Hmw+rB9tvRoYCpdTlJHZBpmn/uFqa3aZbi5JeY+sYZ4h5CSAkPtNmvmB8M6t53mVqBcwFojtmqM6Wi4JAO8Yeqy4sLbFNiQKyJEsCz9ChJ2Gmb50xGu8W0sMTAE18qZmTVkOgVBxNfbZV9OTVYWw4D3cse0VNu5Ehw/sIkCiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CO5zvAoHgkb3bpHx9QsDhDEEt3JfL520t573RAcDTBA=;
 b=B7e+PiBb68CJesey28GOohev7sVollF6e0RLdzE534AxpopxLcl4bzfeFrgtHl7lHZ1ysSQ1a+DsNBrz2dPbyP2zkRxbNGWDr2WV0asn2CW46hMFXOvMqmyt7zkGwsaAukydCh7Okad/C4GQ0mEeD1QlQhdCD0lOenmAQRs69R8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2888.namprd15.prod.outlook.com (20.178.206.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.20; Fri, 13 Sep 2019 02:56:43 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.016; Fri, 13 Sep 2019
 02:56:43 +0000
From:   Yonghong Song <yhs@fb.com>
To:     carlos antonio neira bustos <cneirabustos@gmail.com>
CC:     Eric Biederman <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data
 from current task New bpf helper bpf_get_current_pidns_info.
Thread-Topic: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Thread-Index: AQHVZQnHC5SFgtm26kSgAiqJpjAzqqcfV1wAgABrMACAA+AVAIABbemAgACAjACAAJdbyoABaP+AgACKRICAANfxAA==
Date:   Fri, 13 Sep 2019 02:56:43 +0000
Message-ID: <91327e6c-2ea7-de0e-4459-06a9e0075416@fb.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
 <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
 <20190909174522.GA17882@frodo.byteswizards.com>
 <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
 <20190910231506.GL1131@ZenIV.linux.org.uk>
 <87o8zr8cz3.fsf@x220.int.ebiederm.org>
 <7b0a325e-9187-702f-eba7-bfcc7e3f7eb4@fb.com>
 <CACiB22j9M2gmccnh7XqqFp8g7qKFuiOrSAVJiA2tQHLB0pmoSQ@mail.gmail.com>
In-Reply-To: <CACiB22j9M2gmccnh7XqqFp8g7qKFuiOrSAVJiA2tQHLB0pmoSQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:180::39) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::e1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 819fb9d7-f4ab-487f-219c-08d737f6020d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2888;
x-ms-traffictypediagnostic: BYAPR15MB2888:
x-microsoft-antispam-prvs: <BYAPR15MB28883AD1412ACB04203D8D2DD3B30@BYAPR15MB2888.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39860400002)(376002)(136003)(199004)(189003)(25786009)(4326008)(81156014)(8936002)(305945005)(81166006)(6116002)(8676002)(4744005)(476003)(76176011)(7736002)(52116002)(6246003)(53546011)(6506007)(386003)(2616005)(102836004)(66946007)(66476007)(66556008)(64756008)(229853002)(66446008)(6512007)(36756003)(46003)(446003)(11346002)(99286004)(478600001)(54906003)(14454004)(31686004)(316002)(486006)(6436002)(6486002)(31696002)(256004)(1411001)(5660300002)(186003)(86362001)(53936002)(6916009)(71190400001)(2906002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2888;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6EclcRU+8d4NavX+LMNAUrHtlsMANqFMBuL+BWoABx0qOdELGJe1ZowD+EFTduG0LJV1rV7yCeegdEYAXHmWmyvB5tvgPzxLN0NMhvW8rC8Mvhz/K5Rs007zL2G4iqDJiyrlx5L4av8k/euWq+1jVKUXuxqUIyrYofW+qK65nhGqe6JuwJUU8zRV4PKTvjWYackTDw0JazD8bZg5s34bZmq1nw47IFgSJVjTOIhJxfnhRKnY3UQCZ7w9aeGdmptHL6eBYBE5Zn+jDuebkFpSjPZV0rFTWWNE9pzLqUVUIcJa6zgIrwHUypbcDiGUzl7QyOJ0khkHMJzHzyPrLrY2cfoWjEH19wEEfKo6+dO+EpjLDN/TdArbiIEBLgUG7//rMceWxgYYliFmH6otubm3ywkygrNb8FyRuKt/MgAacxw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B90B4CAEE680341818F2F969C46ACCA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 819fb9d7-f4ab-487f-219c-08d737f6020d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 02:56:43.4710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lIj0714X5WrBVaYTdPff3lorHIR8pfPLEDqJ0FdfhYXanD3L/7cG5V1HMDHtK10l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_02:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTIvMTkgMzowMyBQTSwgY2FybG9zIGFudG9uaW8gbmVpcmEgYnVzdG9zIHdyb3Rl
Og0KPiBZb25naG9uZywNCj4gDQo+IEkgdGhpbmsgYnBmX2dldF9uc19jdXJyZW50X3BpZF90Z2lk
IGludGVyZmFjZSBpcyBhIGxvdCBiZXR0ZXIgdGhhbiB0aGUgDQo+IG9uZSBwcm9wb3NlZCBpbiBt
eSBwYXRjaCwgaG93IGFyZSB3ZSBnb2luZyB0byBtb3ZlIGZvcndhcmQ/IFNob3VsZCBJIA0KPiB0
YWtlIHRoZXNlIGNoYW5nZXMgYW5kIHJlZmFjdG9yIHRoZSBzZWxmdGVzdHMgdG8gdXNlIHRoaXMg
bmV3IGludGVyZmFjZSANCj4gYW5kIHN1Ym1pdCB2ZXJzaW9uIDEyIG9yIGFzIHRoZSBpbnRlcmZh
Y2UgY2hhbmdlZCBjb21wbGV0ZWx5IGlzIGEgbmV3IA0KPiBzZXQgb2YgcGF0Y2hlcz8uDQoNClRo
aXMgaXMgdG8gc29sdmUgdGhlIHNhbWUgcHJvYmxlbS4gWW91IGNhbiBqdXN0IHN1Ym1pdCBhcyB2
ZXJzaW9uIDEyLg0KVGhpcyB3YXksIHdlIHByZXNlcnZlcyBkaXNjdXNzaW9uIGhpc3RvcnkgY2xl
YXJseS4NCg0KPiANCj4gRXJpYywNCj4gVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgZXhwbGFpbmlu
ZyB0aGUgcHJvYmxlbSBhbmQgeW91ciBoZWxwIHRvIG1vdmUgDQo+IGZvcndhcmQgd2l0aCB0aGlz
IG5ldyBoZWxwZXIuDQo+IA0KPiANCj4gQmVzdHMNCg==
