Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E3787177
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405298AbfHIF3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:29:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17788 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbfHIF3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:29:55 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x795Qkw3011952;
        Thu, 8 Aug 2019 22:29:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vt9CRAytbZvrqszQorLb5zv2ktngrvUeToEKNcFVeaM=;
 b=VJcrma6pgNUHNH25G0ohQPfsxIDwEblbi9ezB1TJkiCKuaT/VoXJ7A0NRBqzU6kJsa0u
 WMNrYu74tsT5yZfZWZ6aNojJz7STf18fK9fizh/QodH++FEXKAt15j5uiq7ye1LB5VPd
 ask8uUuB/PUtxxr5n229pRbcMGRIg2+eyzc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u90nkrafj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 22:29:41 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 22:29:40 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 22:29:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4wFuQax3l/c8Ovv5+UBbAxME8JxK/mbRDYW93dRNnI1fsW/u+/jDkxrRUFo7U7CrEbtFAc6LymlhIk/5zFQRywvbmK/Qf0mb2I2jMV3hPPT98/ZXIm84CUBz7EeeW9EUhnSicTXix6DSz8QjUBpNfWjNyOxOUCwWjUQrwFykpG/BIMn86UNuHJcrPbze5YJKg3dssIvWa0wnVyT4RpDUReip1JK4zQLCf3vtYtMh4C9AAy8prows+XJa93TBA2xsDdAHeNSLk3H0l0An6cLX1LMOnQ2NihC52E1L+VyLGYy2sHGomlrKhoWwuB54OCX3QajwmXcNKvTXBvQpaTveQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vt9CRAytbZvrqszQorLb5zv2ktngrvUeToEKNcFVeaM=;
 b=PJDJvO3mqDpwGQ8RSQbgS3NsYSoiAtou9FoTdocy1hc0cg41oruP5mbY6/AH8mgqTyb+aYxI4pXglFOdb9M0IL5TbzFjHzjLVEGp9uJ8og6ceiwjikLYICm+mytTtCQNZNQgaj46REctmpgcf/IbljJGtdn7cxX2y9VQHfv2dszMMnuuwFhYXTv8bMYbXU88ihzca6NyPVxdBw8GsQIt17AjOrCk6MAuv6SuPUlJfSFJk94P0pWINrTXyQAZWGRS7pMN8Fpl3PMZc5sA9VdnFskhDEjsNCS+1uvdL7T/lPAS6qb7OSKnNzM3RE+fPx8esLYh2WyF+gmHp4+GWWBOvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vt9CRAytbZvrqszQorLb5zv2ktngrvUeToEKNcFVeaM=;
 b=KytP3GIimbIfEjrNlpZY8b9LKMZVyF+FDfFCiHGufpwPLMTHqueckg7B7g6t/qbMVpZ7unVimsRDBcVuCIn7F3s86ViRj9ewoueUYTHwpqUVw3pQya42MgSj6MhhVBRlnFXYjHUQzpCxoTxbn8NYr6mA8IwUUGD9Gtkr+vrI8i8=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1567.namprd15.prod.outlook.com (10.173.235.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 05:29:39 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.015; Fri, 9 Aug 2019
 05:29:39 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        William Kennington <wak@google.com>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Topic: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Index: AQHVTLYXvEPb5D4KhEGV/bPPR833MKbwAYEAgAAEloCAADQnAIABB7CA///nDgCAAJqugIAAE4WAgAAKTACAAGv1AA==
Date:   Fri, 9 Aug 2019 05:29:39 +0000
Message-ID: <f1519844-4e21-a9a4-1a69-60c37bd07f75@fb.com>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
 <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
 <20190808211629.GQ27917@lunn.ch>
 <ac22bbe0-36ca-b4b9-7ea7-7b1741c2070d@fb.com>
 <20190808230312.GS27917@lunn.ch>
In-Reply-To: <20190808230312.GS27917@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0165.namprd04.prod.outlook.com
 (2603:10b6:104:4::19) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::89dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d67bc72-abf6-46dc-e753-08d71c8a92ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1567;
x-ms-traffictypediagnostic: MWHPR15MB1567:
x-microsoft-antispam-prvs: <MWHPR15MB15672FA7C138810A3F30E9CFB2D60@MWHPR15MB1567.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(366004)(136003)(396003)(189003)(199004)(6116002)(76176011)(2616005)(8676002)(25786009)(81156014)(81166006)(229853002)(8936002)(53546011)(5660300002)(6916009)(102836004)(65956001)(4326008)(65826007)(65806001)(6506007)(386003)(486006)(476003)(6436002)(7736002)(58126008)(305945005)(46003)(446003)(6512007)(31686004)(64126003)(6246003)(2906002)(316002)(54906003)(36756003)(99286004)(186003)(11346002)(6486002)(53936002)(52116002)(66446008)(66556008)(64756008)(66476007)(66946007)(478600001)(71190400001)(71200400001)(86362001)(31696002)(14454004)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1567;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aHzW7F/Ck9H/2Iyb5zTVcq6lqsWE2rPbzbe53ITR7of46nw+d2YyoHTKGPGOAnXkk4PgNswKIqLaPD0w/HfYPxzLdNdBvlvy1uFeCIb6nu77YXORxCTdlrLFb9iaELGWm96K9xIaVK28RaIsYYW0PoMSyUvHIYQBMTQT2e8mmcYHh1vH2zjwYaeF/OfpMdCw//bwHMxzFU0/uSrtLjKo/VsIqv968bHTeWuOe/6lrRknuUZqYGjx+UJhW5B46IJZQMvsDLgR5iDoiNQpYC9XTNRTY8b6qfSiPGeFW/eFeyEzDJNMzuZ5eGmvGlhP6wXkdTVbeRle/n7NTaitHTkqQFQkG3fMweZEE7CElO7/DfZY5nxIN3QOvn7J1Vu+flNG7CtwLoa7RStK1fhXw4hJsiZKwsIbscAxz8gdw9ycVew=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <026A55FB10137040B9D4664AD6C63A0E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d67bc72-abf6-46dc-e753-08d71c8a92ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 05:29:39.2261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aeTl0gMehyZNqLV4MIAXCuIi1LOzdSLGsR8knKo31W771fqETLf1ZDx+n3ocrcbg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC84LzE5IDQ6MDMgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4gQWZ0ZXIgZ2l2aW5nIGl0
IG1vcmUgdGhvdWdodCwgSSdtIHRoaW5raW5nIGFib3V0IGFkZGluZyBuY3NpIGR0IG5vZGUNCj4+
IHdpdGggZm9sbG93aW5nIHN0cnVjdHVyZSAobWFjL25jc2kgc2ltaWxhciB0byBtYWMvbWRpby9w
aHkpOg0KPj4NCj4+ICZtYWMwIHsNCj4+ICAgICAvKiBNQUMgcHJvcGVydGllcy4uLiAqLw0KPj4N
Cj4+ICAgICB1c2UtbmNzaTsNCj4gDQo+IFRoaXMgcHJvcGVydHkgc2VlbXMgdG8gYmUgc3BlY2lm
aWMgdG8gRmFyYWRheSBGVEdNQUMxMDAuIEFyZSB5b3UgZ29pbmcNCj4gdG8gbWFrZSBpdCBtb3Jl
IGdlbmVyaWM/IA0KDQpJJ20gYWxzbyB1c2luZyBmdGdtYWMxMDAgb24gbXkgcGxhdGZvcm0sIGFu
ZCBJIGRvbid0IGhhdmUgcGxhbiB0byBjaGFuZ2UgdGhpcyBwcm9wZXJ0eS4NCg0KPj4gICAgIG5j
c2kgew0KPj4gICAgICAgICAvKiBuY3NpIGxldmVsIHByb3BlcnRpZXMgaWYgYW55ICovDQo+Pg0K
Pj4gICAgICAgICBwYWNrYWdlQDAgew0KPiANCj4gWW91IHNob3VsZCBnZXQgUm9iIEhlcnJpbmcg
aW52b2x2ZWQuIFRoaXMgaXMgbm90IHJlYWxseSBkZXNjcmliaW5nDQo+IGhhcmR3YXJlLCBzbyBp
dCBtaWdodCBnZXQgcmVqZWN0ZWQgYnkgdGhlIGRldmljZSB0cmVlIG1haW50YWluZXIuDQoNCkdv
dCBpdC4gVGhhbmsgeW91IGZvciB0aGUgc2hhcmluZywgYW5kIGxldCBtZSB0aGluayBpdCBvdmVy
IDotKQ0KDQo+PiAxKSBtYWMgZHJpdmVyIGRvZXNuJ3QgbmVlZCB0byBwYXJzZSAibWFjLW9mZnNl
dCIgc3R1ZmY6IHRoZXNlDQo+PiBuY3NpLW5ldHdvcmstY29udHJvbGxlciBzcGVjaWZpYyBzZXR0
aW5ncyBzaG91bGQgYmUgcGFyc2VkIGluIG5jc2kNCj4+IHN0YWNrLg0KPiANCj4+IDIpIGdldF9i
bWNfbWFjX2FkZHJlc3MgY29tbWFuZCBpcyBhIGNoYW5uZWwgc3BlY2lmaWMgY29tbWFuZCwgYW5k
DQo+PiB0ZWNobmljYWxseSBwZW9wbGUgY2FuIGNvbmZpZ3VyZSBkaWZmZXJlbnQgb2Zmc2V0L2Zv
cm11bGEgZm9yDQo+PiBkaWZmZXJlbnQgY2hhbm5lbHMuDQo+IA0KPiBEb2VzIHRoYXQgbWVhbiB0
aGUgTkNTQSBjb2RlIHB1dHMgdGhlIGludGVyZmFjZSBpbnRvIHByb21pc2N1b3VzIG1vZGU/DQo+
IE9yIGF0IGxlYXN0IGFkZHMgdGhlc2UgdW5pY2FzdCBNQUMgYWRkcmVzc2VzIHRvIHRoZSBNQUMg
cmVjZWl2ZQ0KPiBmaWx0ZXI/IEh1bW0sIGZ0Z21hYzEwMCBvbmx5IHNlZW1zIHRvIHN1cHBvcnQg
bXVsdGljYXN0IGFkZHJlc3MNCj4gZmlsdGVyaW5nLCBub3QgdW5pY2FzdCBmaWx0ZXJzLCBzbyBp
dCBtdXN0IGJlIHVzaW5nIHByb21pc2MgbW9kZSwgaWYNCj4geW91IGV4cGVjdCB0byByZWNlaXZl
IGZyYW1lcyB1c2luZyB0aGlzIE1BQyBhZGRyZXNzLg0KDQpVaGgsIEkgYWN0dWFsbHkgZGlkbid0
IHRoaW5rIHRvbyBtdWNoIGFib3V0IHRoaXM6IGJhc2ljYWxseSBpdCdzIGhvdyB0byBjb25maWd1
cmUgZnJhbWUgZmlsdGVyaW5nIHdoZW4gdGhlcmUgYXJlIG11bHRpcGxlIHBhY2thZ2VzL2NoYW5u
ZWxzIGFjdGl2ZTogc2luZ2xlIEJNQyBNQUMgb3IgbXVsdGlwbGUgQk1DIE1BQyBpcyBhbHNvIGFs
bG93ZWQ/DQpJIGRvbid0IGhhdmUgdGhlIGFuc3dlciB5ZXQsIGJ1dCB3aWxsIHRhbGsgdG8gTkNT
SSBleHBlcnQgYW5kIGZpZ3VyZSBpdCBvdXQuDQoNCg0KVGhhbmtzLA0KDQpUYW8NCg==
