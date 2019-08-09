Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D541C882BF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437068AbfHISid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:38:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5396 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407180AbfHISic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:38:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79IMY7Z002238;
        Fri, 9 Aug 2019 11:38:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=pKaROT9riUMABTe9/A/bkbAlbCWLLD45LtqG66O0vXk=;
 b=FNdmoS3a95xc/5/1fu/J7Yrxj4MvRd+LhAm1peSAivAkX74NwdaG0RwSIVpT1U7J7UyS
 QuM4gb7gAOopRpOGv0j/HkvJSO4VioVWMKKAgwh0Cq1fOvi9T37zAb1Ap7nuHQIS/Kdy
 w5uoKXnZtTcPlMAEo9bUWVpgQny2mO6Khkk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u9a2ch9g8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 09 Aug 2019 11:38:12 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 9 Aug 2019 11:38:11 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 9 Aug 2019 11:38:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+Gr/IYgxqd6rxljInaGl71XAnK6RxUokqQTTjeNmmxuBKzBwS10z0UMSlVIBAv8nMy5W25r0oC2yIhFcXEJVugSuVhMyAGIRRQFm07q3PyqydodK5WWyNpAM4gP/Uf/72Jb1a7BEk7hWjugLbpuC1zJpH7j0u3/ZiyqdGN0HRqcra5y3eUkxCA+5CBN6H6ikZ0CGhDyQ3+sxd+Us4NxJb85ax5K0m2v7FNqqfoOwxfeDhwbj2A0eflUpmKu6uzCtUYWCUcPkPWarat8/+QyI+CkbL+k+FcUnYr0JiLohIFo79G+7jEiuhkRGxbhiikr4bIFjiR6jiQi5ePo87WrvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKaROT9riUMABTe9/A/bkbAlbCWLLD45LtqG66O0vXk=;
 b=e3BUhMw6b57E9K9lnkbKyFaPSiyGREdDuIraa/kxKU+goXt/8UYyIfhc7dAcDoV2o4q2wy/FsZAkuqB+BaJbh6dkiZZ953IBKR0qCWLmr1QvdgaCq9Meg+dd0U1BmzqwD6mWSTERfIdpEoYpyWyiYM3Z8o9tgT4fO/X4LHReSxsPvTxxwR+AnRp7Gp/iB4inv0btxUD9zCacDtkWJkkTBBl4lixVgb33K3wR71n9i6lSsnA1oybNexfxx80XKJPX9SJIgQy6QrlZog1rp4zhmBTNEKriM/Xj4CZm0t5NoJQWnPMZcxo9eXJuzuSsDe7pF0FwPB2LSPQP6SJ4A59GJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKaROT9riUMABTe9/A/bkbAlbCWLLD45LtqG66O0vXk=;
 b=ZXyyB/hYEiRFTRQ9OCfFmP861N6LAF5ZcnIX53A2tWIqli0+WqUdJq0ph8jOpJy3bvgh3D1HwBtZVFNkbQa6UGAKo7+U2LziFEqgCOyB/b1kmfYC3Pfeom0yfVXkCAsRzerynQZty0UJgHQYYt5Vf3OF7cWWuD3e4ZSFInObHMI=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1365.namprd15.prod.outlook.com (10.172.160.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Fri, 9 Aug 2019 18:38:10 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::8c93:f913:124:8dd0]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::8c93:f913:124:8dd0%8]) with mapi id 15.20.2136.022; Fri, 9 Aug 2019
 18:38:10 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        William Kennington <wak@google.com>
Subject: Re: [Potential Spoof] Re: [PATCH net-next] net/ncsi: allow to
 customize BMC MAC Address offset
Thread-Topic: [Potential Spoof] Re: [PATCH net-next] net/ncsi: allow to
 customize BMC MAC Address offset
Thread-Index: AQHVTuGXHjHtT+ykCUKY8HIEPjfSiA==
Date:   Fri, 9 Aug 2019 18:38:10 +0000
Message-ID: <471DEF3F-CDB1-4B21-A05C-6787BFD5CCED@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:6506]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82414290-8c0b-49fc-d304-08d71cf8ba8d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1365;
x-ms-traffictypediagnostic: CY4PR15MB1365:
x-microsoft-antispam-prvs: <CY4PR15MB1365E83942717A2A00D76B44DDD60@CY4PR15MB1365.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(366004)(396003)(199004)(189003)(64756008)(53546011)(91956017)(6506007)(8936002)(14454004)(5660300002)(478600001)(229853002)(102836004)(2906002)(8676002)(36756003)(81156014)(81166006)(86362001)(6116002)(6436002)(33656002)(71190400001)(4326008)(6512007)(46003)(71200400001)(6246003)(66446008)(486006)(186003)(66556008)(66946007)(54906003)(316002)(76116006)(6486002)(66476007)(14444005)(25786009)(7736002)(110136005)(99286004)(53936002)(476003)(256004)(2616005)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1365;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ba8U0lPGbx9FQURfrBhMpSIcXwW22uDTGqUd0rUI7PlkLGppN8X1ymCKW4EJy5ovV2/c1DE3l02RDmX2xUGXU12j9M8N2+/yWe3LNkLxHnfKdmYtsdzeO3aCplFXKKk4lNo/fqdb4+Z9pRcr2A5uApLOKZrDKzyqkkcqYB/Q1owDWJzUAmeu3PopbagHn88e3szo8/hkgOc5F4V4WLbNuNF68b+vYBuFO/+11OKccW165ZynVndKJnpazkOvrHaJQ3bLkTdv5VA1VyuhmD64ZzDPU8WGM5HFAN7otNJN2fn8o0xPs5FVgQrL8MNUrqKZk3jpOm52k4qqLwOlm01+AaoLufOODxzRRc5BlMGWlnnzIVt9v+fjHnfdTbEOTDBqWiu3Vb6umuvQVGfFC+Sqnde+lJ6GzguHLW+/ALwTBF0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB8B3414867DC043A907A89816732876@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 82414290-8c0b-49fc-d304-08d71cf8ba8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 18:38:10.1879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vijaykhemka@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1365
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDgvOC8xOSwgMzoyNyBQTSwgIm9wZW5ibWMgb24gYmVoYWxmIG9mIFRhbyBSZW4i
IDxvcGVuYm1jLWJvdW5jZXMrdmlqYXlraGVta2E9ZmIuY29tQGxpc3RzLm96bGFicy5vcmcgb24g
YmVoYWxmIG9mIHRhb3JlbkBmYi5jb20+IHdyb3RlOg0KDQogICAgT24gOC84LzE5IDI6MTYgUE0s
IEFuZHJldyBMdW5uIHdyb3RlOg0KICAgID4gT24gVGh1LCBBdWcgMDgsIDIwMTkgYXQgMDc6MDI6
NTRQTSArMDAwMCwgVGFvIFJlbiB3cm90ZToNCiAgICA+PiBIaSBBbmRyZXcsDQogICAgPj4NCiAg
ICA+PiBPbiA4LzgvMTkgNjozMiBBTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQogICAgPj4+PiBMZXQg
bWUgcHJlcGFyZSBwYXRjaCB2MiB1c2luZyBkZXZpY2UgdHJlZS4gSSdtIG5vdCBzdXJlIGlmIHN0
YW5kYXJkDQogICAgPj4+PiAibWFjLWFkZHJlc3MiIGZpdHMgdGhpcyBzaXR1YXRpb24gYmVjYXVz
ZSBhbGwgd2UgbmVlZCBpcyBhbiBvZmZzZXQNCiAgICA+Pj4+IChpbnRlZ2VyKSBhbmQgQk1DIE1B
QyBpcyBjYWxjdWxhdGVkIGJ5IGFkZGluZyB0aGUgb2Zmc2V0IHRvIE5JQydzDQogICAgPj4+PiBN
QUMgYWRkcmVzcy4gQW55d2F5cywgbGV0IG1lIHdvcmsgb3V0IHYyIHBhdGNoIHdlIGNhbiBkaXNj
dXNzIG1vcmUNCiAgICA+Pj4+IHRoZW4uDQogICAgPj4+DQogICAgPj4+IEhpIFRhbw0KICAgID4+
Pg0KICAgID4+PiBJIGRvbid0IGtub3cgQk1DIHRlcm1pbm9sb2d5LiBCeSBOSUNzIE1BQyBhZGRy
ZXNzLCB5b3UgYXJlIHJlZmVycmluZw0KICAgID4+PiB0byB0aGUgaG9zdHMgTUFDIGFkZHJlc3M/
IFRoZSBNQUMgYWRkcmVzcyB0aGUgYmlnIENQVSBpcyB1c2luZyBmb3IgaXRzDQogICAgPj4+IGlu
dGVyZmFjZT8gIFdoZXJlIGRvZXMgdGhpcyBOSUMgZ2V0IGl0cyBNQUMgYWRkcmVzcyBmcm9tPyBJ
ZiB0aGUgQk1Dcw0KICAgID4+PiBib290bG9hZGVyIGhhcyBhY2Nlc3MgdG8gaXQsIGl0IGNhbiBz
ZXQgdGhlIG1hYy1hZGRyZXNzIHByb3BlcnR5IGluDQogICAgPj4+IHRoZSBkZXZpY2UgdHJlZS4N
CiAgICA+Pg0KICAgID4+IFNvcnJ5IGZvciB0aGUgY29uZnVzaW9uIGFuZCBsZXQgbWUgY2xhcmlm
eSBtb3JlOg0KICAgID4+DQogICAgPiANCiAgICA+PiBUaGUgTklDIGhlcmUgcmVmZXJzIHRvIHRo
ZSBOZXR3b3JrIGNvbnRyb2xsZXIgd2hpY2ggcHJvdmlkZSBuZXR3b3JrDQogICAgPj4gY29ubmVj
dGl2aXR5IGZvciBib3RoIEJNQyAodmlhIE5DLVNJKSBhbmQgSG9zdCAoZm9yIGV4YW1wbGUsIHZp
YQ0KICAgID4+IFBDSWUpLg0KICAgID4+DQogICAgPiANCiAgICA+PiBPbiBGYWNlYm9vayBZYW1w
IEJNQywgQk1DIHNlbmRzIE5DU0lfT0VNX0dFVF9NQUMgY29tbWFuZCAoYXMgYW4NCiAgICA+PiBl
dGhlcm5ldCBwYWNrZXQpIHRvIHRoZSBOZXR3b3JrIENvbnRyb2xsZXIgd2hpbGUgYnJpbmdpbmcg
dXAgZXRoMCwNCiAgICA+PiBhbmQgdGhlIChCcm9hZGNvbSkgTmV0d29yayBDb250cm9sbGVyIHJl
cGxpZXMgd2l0aCB0aGUgQmFzZSBNQUMNCiAgICA+PiBBZGRyZXNzIHJlc2VydmVkIGZvciB0aGUg
cGxhdGZvcm0uIEFzIGZvciBZYW1wLCBCYXNlLU1BQyBhbmQNCiAgICA+PiBCYXNlLU1BQysxIGFy
ZSB1c2VkIGJ5IEhvc3QgKGJpZyBDUFUpIGFuZCBCYXNlLU1BQysyIGFyZSBhc3NpZ25lZCB0bw0K
ICAgID4+IEJNQy4gSW4gbXkgb3BpbmlvbiwgQmFzZSBNQUMgYW5kIE1BQyBhZGRyZXNzIGFzc2ln
bm1lbnRzIGFyZQ0KICAgID4+IGNvbnRyb2xsZWQgYnkgTmV0d29yayBDb250cm9sbGVyLCB3aGlj
aCBpcyB0cmFuc3BhcmVudCB0byBib3RoIEJNQw0KICAgID4+IGFuZCBIb3N0Lg0KICAgID4gDQog
ICAgPiBIaSBUYW8NCiAgICA+IA0KICAgID4gSSd2ZSBub3QgZG9uZSBhbnkgd29yayBpbiB0aGUg
Qk1DIGZpZWxkLCBzbyB0aGFua3MgZm9yIGV4cGxhaW5pbmcNCiAgICA+IHRoaXMuDQogICAgPiAN
CiAgICA+IEluIGEgdHlwaWNhbCBlbWJlZGRlZCBzeXN0ZW0sIGVhY2ggbmV0d29yayBpbnRlcmZh
Y2UgaXMgYXNzaWduZWQgYSBNQUMNCiAgICA+IGFkZHJlc3MgYnkgdGhlIHZlbmRvci4gQnV0IGhl
cmUsIHRoaW5ncyBhcmUgZGlmZmVyZW50LiBUaGUgQk1DIFNvQw0KICAgID4gbmV0d29yayBpbnRl
cmZhY2UgaGFzIG5vdCBiZWVuIGFzc2lnbmVkIGEgTUFDIGFkZHJlc3MsIGl0IG5lZWRzIHRvIGFz
aw0KICAgID4gdGhlIG5ldHdvcmsgY29udHJvbGxlciBmb3IgaXRzIE1BQyBhZGRyZXNzLCBhbmQg
dGhlbiBkbyBzb21lIG1hZ2ljYWwNCiAgICA+IHRyYW5zZm9ybWF0aW9uIG9uIHRoZSBhbnN3ZXIg
dG8gZGVyaXZlIGEgTUFDIGFkZHJlc3MgZm9yDQogICAgPiBpdHNlbGYuIENvcnJlY3Q/DQogICAg
DQogICAgWWVzLiBJdCdzIGNvcnJlY3QuDQogICAgDQogICAgPiBJdCBzZWVtcyBsaWtlIGEgYmV0
dGVyIGRlc2lnbiB3b3VsZCBvZiBiZWVuLCB0aGUgQk1DIHNlbmRzIGENCiAgICA+IE5DU0lfT0VN
X0dFVF9CTUNfTUFDIGFuZCB0aGUgYW5zd2VyIGl0IGdldHMgYmFjayBpcyB0aGUgTUFDIGFkZHJl
c3MNCiAgICA+IHRoZSBCTUMgc2hvdWxkIHVzZS4gTm8gbWFnaWMgaW52b2x2ZWQuIEJ1dCBpIGd1
ZXNzIGl0IGlzIHRvbyBsYXRlIHRvDQogICAgPiBkbyB0aGF0IG5vdy4NCiAgICANCiAgICBTb21l
IE5DU0kgTmV0d29yayBDb250cm9sbGVycyBzdXBwb3J0IHN1Y2ggT0VNIGNvbW1hbmQgKEdldCBQ
cm92aXNpb25lZCBCTUMgTUFDIEFkZHJlc3MpLCBidXQgdW5mb3J0dW5hdGVseSBpdCdzIG5vdCBz
dXBwb3J0ZWQgb24gWWFtcC4NCiAgICANCiAgICA+PiBJJ20gbm90IHN1cmUgaWYgSSB1bmRlcnN0
YW5kIHlvdXIgc3VnZ2VzdGlvbiBjb3JyZWN0bHk6IGRvIHlvdSBtZWFuDQogICAgPj4gd2Ugc2hv
dWxkIG1vdmUgdGhlIGxvZ2ljIChHRVRfTUFDIGZyb20gTmV0d29yayBDb250cm9sbGVyLCBhZGRp
bmcNCiAgICA+PiBvZmZzZXQgYW5kIGNvbmZpZ3VyaW5nIEJNQyBNQUMpIGZyb20ga2VybmVsIHRv
IGJvb3QgbG9hZGVyPw0KICAgID4gDQogICAgPiBJbiBnZW5lcmFsLCB0aGUga2VybmVsIGlzIGdl
bmVyaWMuIEl0IHByb2JhYmx5IGJvb3RzIG9uIGFueSBBUk0gc3lzdGVtDQogICAgPiB3aGljaCBp
cyBoYXMgdGhlIG5lZWRlZCBtb2R1bGVzIGZvci4gVGhlIGJvb3Rsb2FkZXIgaXMgb2Z0ZW4gbXVj
aCBtb3JlDQogICAgPiBzcGVjaWZpYy4gSXQgbWlnaHQgbm90IGJlIGZ1bGx5IHBsYXRmb3JtIHNw
ZWNpZmljLCBidXQgaXQgd2lsbCBiZSBhdA0KICAgID4gbGVhc3Qgc3BlY2lmaWMgdG8gdGhlIGdl
bmVyYWwgZmFtaWx5IG9mIEJNQyBTb0NzLiBJZiB5b3UgY29uc2lkZXIgdGhlDQogICAgPiBjb21i
aW5hdGlvbiBvZiB0aGUgQk1DIGJvb3Rsb2FkZXIgYW5kIHRoZSBkZXZpY2UgdHJlZSBibG9iLCB5
b3UgaGF2ZQ0KICAgID4gc29tZXRoaW5nIHNwZWNpZmljIHRvIHRoZSBwbGF0Zm9ybS4gVGhpcyBt
YWdpY2FsIHRyYW5zZm9ybWF0aW9uIG9mDQogICAgPiBhZGRpbmcgMiBzZWVtcyB0byBiZSB2ZXJ5
IHBsYXRmb3JtIHNwZWNpZmljLiBTbyBoYXZpbmcgdGhpcyBtYWdpYyBpbg0KICAgID4gdGhlIGJv
b3Rsb2FkZXIrRFQgc2VlbXMgbGlrZSB0aGUgYmVzdCBwbGFjZSB0byBwdXQgaXQuDQogICAgDQog
ICAgSSB1bmRlcnN0YW5kIHlvdXIgY29uY2VybiBub3cuIFRoYW5rIHlvdSBmb3IgdGhlIGV4cGxh
bmF0aW9uLg0KICAgIA0KICAgID4gSG93ZXZlciwgaG93IHlvdSBwYXNzIHRoZSByZXN1bHRpbmcg
TUFDIGFkZHJlc3MgdG8gdGhlIGtlcm5lbCBzaG91bGQNCiAgICA+IGJlIGFzIGdlbmVyaWMgYXMg
cG9zc2libGUuIFRoZSBEVCAibWFjLWFkZHJlc3MiIHByb3BlcnR5IGlzIHZlcnkNCiAgICA+IGdl
bmVyaWMsIG1hbnkgTUFDIGRyaXZlcnMgdW5kZXJzdGFuZCBpdC4gVXNpbmcgaXQgYWxzbyBhbGxv
d3MgZm9yDQogICAgPiB2ZW5kb3JzIHdoaWNoIGFjdHVhbGx5IGFzc2lnbiBhIE1BQyBhZGRyZXNz
IHRvIHRoZSBCTUMgdG8gcGFzcyBpdCB0bw0KICAgID4gdGhlIEJNQywgYXZvaWRpbmcgYWxsIHRo
aXMgTkNTSV9PRU1fR0VUX01BQyBoYW5kc2hha2UuIEhhdmluZyBhbiBBUEkNCiAgICA+IHdoaWNo
IGp1c3QgcGFzc2luZyAnMicgaXMgbm90IGdlbmVyaWMgYXQgYWxsLg0KICAgIA0KICAgIEFmdGVy
IGdpdmluZyBpdCBtb3JlIHRob3VnaHQsIEknbSB0aGlua2luZyBhYm91dCBhZGRpbmcgbmNzaSBk
dCBub2RlIHdpdGggZm9sbG93aW5nIHN0cnVjdHVyZSAobWFjL25jc2kgc2ltaWxhciB0byBtYWMv
bWRpby9waHkpOg0KICAgIA0KICAgICZtYWMwIHsNCiAgICAgICAgLyogTUFDIHByb3BlcnRpZXMu
Li4gKi8NCiAgICANCiAgICAgICAgdXNlLW5jc2k7DQogICAgICAgIG5jc2kgew0KICAgICAgICAg
ICAgLyogbmNzaSBsZXZlbCBwcm9wZXJ0aWVzIGlmIGFueSAqLw0KVGFvLCBJIGxpa2UgdGhpcyBp
ZGVhIGJ1dCBrZWVwIHRoaXMgb25seSBoYXJkd2FyZSBzcGVjaWZpYy4gDQogICAgDQogICAgICAg
ICAgICBwYWNrYWdlQDAgew0KICAgICAgICAgICAgICAgIC8qIHBhY2thZ2UgbGV2ZWwgcHJvcGVy
dGllcyBpZiBhbnkgKi8NCiAgICANCiAgICAgICAgICAgICAgICBjaGFubmVsQDAgew0KICAgICAg
ICAgICAgICAgICAgICAvKiBjaGFubmVsIGxldmVsIHByb3BlcnRpZXMgaWYgYW55ICovDQogICAg
DQogICAgICAgICAgICAgICAgICAgIGJtYy1tYWMtb2Zmc2V0ID0gPDI+Ow0KDQpFdmVyeSBOSUMg
dmVuZG9yIGRvZXNuJ3QgbmVlZCB0aGlzIG9mZnNldCBzbyBpdCBpcyBzcGVjaWZpYyB0byBCQ00g
Y2FyZCBvbmx5IGFzIHlvdSBzZWUgdGhpcyANCmluY3JlbWVudCBoYXMgYmVlbiBkb25lIG9ubHkg
Zm9yIEJDTSBjYXJkIHNvIHlvdSBtYXkgd2FudCB0byBwYXNzIGJjbSBzcGVjaWZpYyBvbmx5Lg0K
DQogICAgICAgICAgICAgICAgfTsNCiAgICANCiAgICAgICAgICAgICAgICBjaGFubmVsQDEgew0K
ICAgICAgICAgICAgICAgICAgICAvKiBjaGFubmVsICMxIHByb3BlcnRpZXMgKi8NCiAgICAgICAg
ICAgICAgICB9Ow0KICAgICAgICAgICAgfTsNCiAgICANCiAgICAgICAgICAgIC8qIHBhY2thZ2Ug
IzEgcHJvcGVydGllcyBzdGFydCBoZXJlLi4gKi8NCiAgICAgICAgfTsNCiAgICB9Ow0KICAgIA0K
ICAgIFRoZSByZWFzb25zIGJlaGluZCB0aGlzIGFyZToNCiAgICANCiAgICAxKSBtYWMgZHJpdmVy
IGRvZXNuJ3QgbmVlZCB0byBwYXJzZSAibWFjLW9mZnNldCIgc3R1ZmY6IHRoZXNlIG5jc2ktbmV0
d29yay1jb250cm9sbGVyIHNwZWNpZmljIHNldHRpbmdzIHNob3VsZCBiZSBwYXJzZWQgaW4gbmNz
aSBzdGFjay4NCiAgICANCiAgICAyKSBnZXRfYm1jX21hY19hZGRyZXNzIGNvbW1hbmQgaXMgYSBj
aGFubmVsIHNwZWNpZmljIGNvbW1hbmQsIGFuZCB0ZWNobmljYWxseSBwZW9wbGUgY2FuIGNvbmZp
Z3VyZSBkaWZmZXJlbnQgb2Zmc2V0L2Zvcm11bGEgZm9yIGRpZmZlcmVudCBjaGFubmVscy4NCiAg
ICANCiAgICBBbnkgY29uY2VybnMgb3Igc3VnZ2VzdGlvbnM/DQogICAgDQogICAgDQogICAgVGhh
bmtzLA0KICAgIA0KICAgIFRhbw0KICAgIA0KDQo=
