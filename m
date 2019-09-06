Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A91AAF91
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 02:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389898AbfIFAHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 20:07:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37444 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733029AbfIFAHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 20:07:45 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8604Xfs026183;
        Thu, 5 Sep 2019 17:07:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kN2Xvnm6Hl5JsZSV4uuvkY8u7qTFXSld+3/9oLVeHkE=;
 b=afSHrmH1V0HAwsYn66G1jG1DATO0x/EdrHroNNmLaXs9/GK97snI16WLWwUq5hSCbxvB
 oDk0aDkpMKu5FZyBTgHNlh40UmOfZORzEkNBqvxsxNFWv+o6OctBPjd8tO/9KL9Emp+x
 9RwmI1r1jEAnm5wVNeCHoLlv6CHTk2vUu0s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2utksg6j3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Sep 2019 17:07:41 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Sep 2019 17:07:40 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Sep 2019 17:07:40 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Sep 2019 17:07:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYCtRHX3BuuLVdgpuq+b+5haOKdX5uM1gYCmUJWmjup77jXpC+38BdBb3UJsZy/b6PYAX/Ez7YvilzvP8a+SDO3Ol6Hap6w0TZfjUf2LsylsPDuF4S2prbGFx0TTfh+w8+D2xlq+WuzKHb8WyT8jPIVokaQfQg/WFx/sEkJ0yQ+AFK+5yzhU6rK7GOTnj3P5QqbDjUov6Yc3NB1g1nHryQyPWOpOA4ZEOB3RCzQta0aaKWXMCmZDCaZqCAPq/XW/6hxqAhksJ+CAUQkYymRxpNP8Ch7x8tx74t2ON8VClFq2usWo+0koSkZnP6WilFPA7bvFWjgIPJdarV7VwZjOqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kN2Xvnm6Hl5JsZSV4uuvkY8u7qTFXSld+3/9oLVeHkE=;
 b=M7ZsRmDn02yXfgScSIsrwmPR3XPN4q/uu5Oz8ymvHs9sHBe1t0WGGNhV+MaWf0IctIUCoKhM1e6hlrrDt4Zjibb2AFptPiMdhrDffFbIQxsMODf9d85pw1Z8uqiGS6vIEs/lpiptXjprrjEojHPxxl36VrAJoqItK0rhki166pUezB8B+YLU/VJL0eGvmZmSNPmtzVlp8EPY81qU7bkn1WckV7AoyyRQ1JQVzrLiYZDJd0a5acKzgJT2FugLoV/Zcq8J8EJbx11DL4Ai9ZdUH8Ax1XfYCjH/478FDuU7W2f952Kci0AYTOJAxuYcG6Q7V1c3m0HWqdqkYfOi0X+moQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kN2Xvnm6Hl5JsZSV4uuvkY8u7qTFXSld+3/9oLVeHkE=;
 b=BnWgN3gLQWxKzEVY/I+gDeuxfK/VzBm8vKD5bvXkAskfSBOLolSjldKisJ5WHzr/42cSQ5hyIBMmQJv+DEzirwPZFCcJFGD/7NhtT8i9I8xHLLoyfOa9JZCOHv1ckvhvpsmoLy3aQyEMyX+lDfcydLIbjbtsUR87JLnmOdPOTQk=
Received: from DM6PR15MB3387.namprd15.prod.outlook.com (20.179.51.80) by
 DM6PR15MB3322.namprd15.prod.outlook.com (20.179.52.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Fri, 6 Sep 2019 00:07:39 +0000
Received: from DM6PR15MB3387.namprd15.prod.outlook.com
 ([fe80::6145:2a97:12be:e75d]) by DM6PR15MB3387.namprd15.prod.outlook.com
 ([fe80::6145:2a97:12be:e75d%6]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 00:07:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Herbert <tom@herbertland.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kcm: use BPF_PROG_RUN
Thread-Topic: [PATCH] kcm: use BPF_PROG_RUN
Thread-Index: AQHVZC8bc+pmpGy1ok6fORwh6k7nd6cdxc4A
Date:   Fri, 6 Sep 2019 00:07:39 +0000
Message-ID: <0f77cc31-4df5-a74f-5b64-a1e3fc439c6d@fb.com>
References: <20190905211528.97828-1-samitolvanen@google.com>
In-Reply-To: <20190905211528.97828-1-samitolvanen@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:300:103::27) To DM6PR15MB3387.namprd15.prod.outlook.com
 (2603:10b6:5:16d::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:fc2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4d4e1ea-dcc8-4699-bb87-08d7325e3aec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB3322;
x-ms-traffictypediagnostic: DM6PR15MB3322:
x-microsoft-antispam-prvs: <DM6PR15MB332236349F35A10990624B7BD3BA0@DM6PR15MB3322.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(376002)(346002)(199004)(189003)(478600001)(99286004)(31686004)(305945005)(53936002)(6246003)(66446008)(36756003)(64756008)(66556008)(4744005)(6116002)(76176011)(6486002)(71190400001)(71200400001)(14444005)(2616005)(229853002)(446003)(256004)(186003)(11346002)(7736002)(86362001)(66946007)(2906002)(66476007)(8676002)(52116002)(81166006)(6436002)(6512007)(486006)(8936002)(25786009)(476003)(81156014)(14454004)(316002)(386003)(110136005)(5660300002)(54906003)(4326008)(31696002)(102836004)(53546011)(46003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3322;H:DM6PR15MB3387.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f+QAn0dAnZQmE4JchokUxGqGWXTR0koRp+taOP/KhTiFfidH0Sy3uCeM7OObTmKixNZhqipcmv9g4ffoQP/GNHyOu4pvSoeZxeM4wPr7xtPaTbGaawFMKIt7zGi7MlSbsDYSd2gHd/wZceMwbSpzLOP9ACpqJYSlc1dGBrm4G2uCidU05/Dv3cUoCHF3oxf50oo3kSqaGg/FaVyVwiTbhz0WwaSVgzfz3eqLDLrdwb2aLZvgfs9345L+6xkjgqPpNl3UZqi2G0mgujGGpzi2UVzE4euqUove4JSIfFp+fdy64mYSjrxCw0JmXqTkRqADdOmdKKVM5YAl7Xtdz2MFE3jXOLULyxgoOWJr0bZyBC749zhowYhCpAJV6IxgZYMMLCgLc914DQm3CiKJIVIfjnU2qTv5UOnJ3Y9dNI0jBbU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1C31A7C5F35A04D879C0B1BD52BE007@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d4e1ea-dcc8-4699-bb87-08d7325e3aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 00:07:39.5011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUUIvO5r6pGTZVXeje03Jz2jPXTK5Bfh6RTWL93ZLNvfV/WdXDH+TP3dS2syEgry
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3322
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_10:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 impostorscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909050225
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvNS8xOSAyOjE1IFBNLCBTYW1pIFRvbHZhbmVuIHdyb3RlOg0KPiBJbnN0ZWFkIG9m
IGludm9raW5nIHN0cnVjdCBicGZfcHJvZzo6YnBmX2Z1bmMgZGlyZWN0bHksIHVzZSB0aGUNCj4g
QlBGX1BST0dfUlVOIG1hY3JvLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2FtaSBUb2x2YW5lbiA8
c2FtaXRvbHZhbmVuQGdvb2dsZS5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNA
ZmIuY29tPg0KDQo+IC0tLQ0KPiAgIG5ldC9rY20va2Ntc29jay5jIHwgMiArLQ0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL25ldC9rY20va2Ntc29jay5jIGIvbmV0L2tjbS9rY21zb2NrLmMNCj4gaW5kZXggNWRiYzBj
NDhmOGNiLi5mMzUwYzYxM2JkN2QgMTAwNjQ0DQo+IC0tLSBhL25ldC9rY20va2Ntc29jay5jDQo+
ICsrKyBiL25ldC9rY20va2Ntc29jay5jDQo+IEBAIC0zNzksNyArMzc5LDcgQEAgc3RhdGljIGlu
dCBrY21fcGFyc2VfZnVuY19zdHJwYXJzZXIoc3RydWN0IHN0cnBhcnNlciAqc3RycCwgc3RydWN0
IHNrX2J1ZmYgKnNrYikNCj4gICAJc3RydWN0IGtjbV9wc29jayAqcHNvY2sgPSBjb250YWluZXJf
b2Yoc3RycCwgc3RydWN0IGtjbV9wc29jaywgc3RycCk7DQo+ICAgCXN0cnVjdCBicGZfcHJvZyAq
cHJvZyA9IHBzb2NrLT5icGZfcHJvZzsNCj4gICANCj4gLQlyZXR1cm4gKCpwcm9nLT5icGZfZnVu
Yykoc2tiLCBwcm9nLT5pbnNuc2kpOw0KPiArCXJldHVybiBCUEZfUFJPR19SVU4ocHJvZywgc2ti
KTsNCj4gICB9DQo+ICAgDQo+ICAgc3RhdGljIGludCBrY21fcmVhZF9zb2NrX2RvbmUoc3RydWN0
IHN0cnBhcnNlciAqc3RycCwgaW50IGVycikNCj4gDQo=
