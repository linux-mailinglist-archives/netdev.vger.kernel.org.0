Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7662E85976
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 06:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfHHEsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 00:48:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbfHHEsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 00:48:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x784mGQP016384;
        Wed, 7 Aug 2019 21:48:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=akI7jzae2xyTpZOx4fUT//R1DEwHHlVoh4ALmYLhwGc=;
 b=quXdo+5vvDCd1CFz5CIhAviwgcKFN05Z0zWXLpDEhkGDGwdkoKm6tW6nv5X7bEGK8nPH
 kpGrXqEC8FLc7NCud/apqSgShE0X0TrFJBqecjpuYCiZ+28gPT8dOsBBbQ06FBtneRhK
 9soDH+Jta1WIQ9oTjLg/V3dnCyGuH3fEgZs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u8cta818n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Aug 2019 21:48:27 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 21:48:26 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 21:48:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlGfb6xpG5bs3TTD1NC2Y5IbJiabW/PdEBcvxFnhAnQ16cbV/KzkfbR0RxspUlqeLExhfhUbRATMac9XRGmATwUnR6NftDG0c9q4v/Z1BB5uNNST/jlmBSS3IESEW264XpChRT6NmDL6CPP3A2ubbIzbDKsS3GFuzPns8KhPb7Hz7tuo641CP/28JdHexgvLBUbbD0PO27xGfQBhs5gJSehYHKG5ar0558f68XUQB+okTWF0kNhPDi8uEGQj53XzVPnsR7E/zlk/TYAkHiY3GMashth94fEl/pbxQa58Q3Iky/vC7hhsxKeuvxqiGXKd8EMZPCL7E3uSgPPt6Q7WrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akI7jzae2xyTpZOx4fUT//R1DEwHHlVoh4ALmYLhwGc=;
 b=NleGdoUORhTBzHDVYbl2NpWD2eUUvJsoUwXlnxYfso2lC4XxqsAbV+WJGijN11OmqYf9LwL/2G5cHBwUAqKeT9Vpn14slECLG5BlsbHsoCvBw3tujjJdpP/dGCcQ/saAuCk5pOqlaF3HfHtvr7BYPwD/ZPHBwzuYR7Ys7eOwQJoLbXTZGRrdZKhS4BLVRG7pD4k6tqUyh2zdi55nRG+wqV/OBy/P7s+yFQuUfR2FRtjyUquy7e8JgIBHFWb8lmVwGdDux87mTeRZab/K52SxI5S65XCRFb9igAfxTvJWZ1e6oyuibjq/b7ArV2D+zrDukeDkiEXa16qOsNYeYNhUFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akI7jzae2xyTpZOx4fUT//R1DEwHHlVoh4ALmYLhwGc=;
 b=XmW7o0Fdf4dbe8Ncef5ydKxAnXsvp5ZH0dpSOBYj+JmYB6jFJepSRg6ROBltNsmheYmv3Qx/zwtsQVIBdUwbp+qGnN7MUszO6DwPFEXgDBU8jLPYBFA10tq+/2mzj6g69NhluwKsVcAIMWHB1fjuqiy6sF9RJZTjfDkLHV05FxM=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1454.namprd15.prod.outlook.com (10.173.235.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Thu, 8 Aug 2019 04:48:25 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.011; Thu, 8 Aug 2019
 04:48:25 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Topic: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Index: AQHVTLYXvEPb5D4KhEGV/bPPR833MKbwAYEAgAAEloCAAKl/AA==
Date:   Thu, 8 Aug 2019 04:48:25 +0000
Message-ID: <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
In-Reply-To: <20190807184143.GE26047@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0021.namprd17.prod.outlook.com
 (2603:10b6:301:14::31) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f857]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0927822-6cc3-458e-5c14-08d71bbba5b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1454;
x-ms-traffictypediagnostic: MWHPR15MB1454:
x-microsoft-antispam-prvs: <MWHPR15MB1454B69F64ECA2A58EDDC5D7B2D70@MWHPR15MB1454.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(366004)(376002)(39860400002)(189003)(199004)(110136005)(6246003)(316002)(53936002)(86362001)(31696002)(446003)(65956001)(8936002)(4326008)(256004)(478600001)(7736002)(25786009)(65806001)(229853002)(2906002)(6512007)(5660300002)(65826007)(54906003)(486006)(58126008)(81166006)(66476007)(31686004)(6436002)(81156014)(64126003)(66446008)(14454004)(66946007)(36756003)(71190400001)(476003)(53546011)(71200400001)(305945005)(66556008)(6506007)(386003)(102836004)(52116002)(186003)(76176011)(64756008)(2616005)(46003)(6486002)(11346002)(8676002)(6116002)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1454;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WbPvl6JKJ3vKnAnAxvUpTP4kRRsy9HxMzm3JXncsxTpIvVol9nZ0z6A/O9oy8hVf+jOaDVw0g4arqdHOZa/+RGekRdqH0QihlsW+JTuhCug82AZxr4EwECbDeIDSka7LZMDMNmDCjCyW4Sc+1BgcE4KA51xIaKU9Nyz+At/VIprhOq8Tq6pZ5p8idD+5eRHPu8AXpTW6bYP2m4RQH7xJkyEv1EZB0vQvMxJnRgAtoOjw3KvhBo/mjHt4/7+V7e0XkfVyQK/1VBiKexrIBNKFvi1ZAZm6E1vxiaqFu2C85kqHsBU/02v1V4kyH2nM0s63moXkcF/X5QqnjLgwxq7WJdzNfEcxeIEp9W/VyFus7VVlptxySrU8TAmb4Eg92v4iapRzcMcp78zwOw+awSrAC/x+rGmSb78aDKkjoqV6Fr0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FA91FAD7F1B7148AD0861C767D1249F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0927822-6cc3-458e-5c14-08d71bbba5b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 04:48:25.1007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AfuTO0CriywRMcC4TTkOV3q4V5khazXp9ucyqkp6xLyl+VtEZIJ+xC1fl5ITkzFN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC83LzE5IDExOjQxIEFNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gV2VkLCBBdWcgMDcs
IDIwMTkgYXQgMTE6MjU6MThBTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+PiBPbiBU
dWUsIDYgQXVnIDIwMTkgMTc6MjE6MTggLTA3MDAsIFRhbyBSZW4gd3JvdGU6DQo+Pj4gQ3VycmVu
dGx5IEJNQydzIE1BQyBhZGRyZXNzIGlzIGNhbGN1bGF0ZWQgYnkgYWRkaW5nIDEgdG8gTkNTSSBO
SUMncyBiYXNlDQo+Pj4gTUFDIGFkZHJlc3Mgd2hlbiBDT05GSUdfTkNTSV9PRU1fQ01EX0dFVF9N
QUMgb3B0aW9uIGlzIGVuYWJsZWQuIFRoZSBsb2dpYw0KPj4+IGRvZXNuJ3Qgd29yayBmb3IgcGxh
dGZvcm1zIHdpdGggZGlmZmVyZW50IEJNQyBNQUMgb2Zmc2V0OiBmb3IgZXhhbXBsZSwNCj4+PiBG
YWNlYm9vayBZYW1wIEJNQydzIE1BQyBhZGRyZXNzIGlzIGNhbGN1bGF0ZWQgYnkgYWRkaW5nIDIg
dG8gTklDJ3MgYmFzZQ0KPj4+IE1BQyBhZGRyZXNzICgiQmFzZU1BQyArIDEiIGlzIHJlc2VydmVk
IGZvciBIb3N0IHVzZSkuDQo+Pj4NCj4+PiBUaGlzIHBhdGNoIGFkZHMgTkVUX05DU0lfTUNfTUFD
X09GRlNFVCBjb25maWcgb3B0aW9uIHRvIGN1c3RvbWl6ZSBvZmZzZXQNCj4+PiBiZXR3ZWVuIE5J
QydzIEJhc2UgTUFDIGFkZHJlc3MgYW5kIEJNQydzIE1BQyBhZGRyZXNzLiBJdHMgZGVmYXVsdCB2
YWx1ZSBpcw0KPj4+IHNldCB0byAxIHRvIGF2b2lkIGJyZWFraW5nIGV4aXN0aW5nIHVzZXJzLg0K
Pj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogVGFvIFJlbiA8dGFvcmVuQGZiLmNvbT4NCj4+DQo+PiBN
YXliZSBzb21lb25lIG1vcmUga25vd2xlZGdlYWJsZSBsaWtlIEFuZHJldyBoYXMgYW4gb3Bpbmlv
biBoZXJlLCANCj4+IGJ1dCB0byBtZSBpdCBzZWVtcyBhIGJpdCBzdHJhbmdlIHRvIGVuY29kZSB3
aGF0IHNlZW1zIHRvIGJlIHBsYXRmcm9tDQo+PiBpbmZvcm1hdGlvbiBpbiB0aGUga2VybmVsIGNv
bmZpZyA6KA0KPiANCj4gWWVzLCB0aGlzIGlzIG5vdCBhIGdvb2QgaWRlYS4gSXQgbWFrZXMgaXQg
aW1wb3NzaWJsZSB0byBoYXZlIGEgJ0JNQw0KPiBkaXN0cm8nIGtlcm5lbCB3aGljaCB5b3UgaW5z
dGFsbCBvbiBhIG51bWJlciBvZiBkaWZmZXJlbnQgQk1Dcy4NCj4gDQo+IEEgZGV2aWNlIHRyZWUg
cHJvcGVydHkgd291bGQgYmUgYmV0dGVyLiBJZGVhbGx5IGl0IHdvdWxkIGJlIHRoZQ0KPiBzdGFu
ZGFyZCBsb2NhbC1tYWMtYWRkcmVzcywgb3IgbWFjLWFkZHJlc3MuDQoNClRoYW5rIHlvdSBBbmRy
ZXcgYW5kIEpha3ViIGZvciB0aGUgZmVlZGJhY2suIEkgcGlja2VkIHVwIGtjb25maWcgYXBwcm9h
Y2ggbWFpbmx5IGJlY2F1c2UgaXQncyBhbiBPRU0tb25seSBleHRlbnRpb24gd2hpY2ggaXMgdXNl
ZCBvbmx5IHdoZW4gTkNTSV9PRU1fQ01EX0dFVF9NQUMgaXMgZW5hYmxlZC4NCg0KTGV0IG1lIHBy
ZXBhcmUgcGF0Y2ggdjIgdXNpbmcgZGV2aWNlIHRyZWUuIEknbSBub3Qgc3VyZSBpZiBzdGFuZGFy
ZCAibWFjLWFkZHJlc3MiIGZpdHMgdGhpcyBzaXR1YXRpb24gYmVjYXVzZSBhbGwgd2UgbmVlZCBp
cyBhbiBvZmZzZXQgKGludGVnZXIpIGFuZCBCTUMgTUFDIGlzIGNhbGN1bGF0ZWQgYnkgYWRkaW5n
IHRoZSBvZmZzZXQgdG8gTklDJ3MgTUFDIGFkZHJlc3MuIEFueXdheXMsIGxldCBtZSB3b3JrIG91
dCB2MiBwYXRjaCB3ZSBjYW4gZGlzY3VzcyBtb3JlIHRoZW4uDQoNCg0KVGhhbmtzLA0KDQpUYW8N
Cg==
