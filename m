Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699328F7D1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHPAHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:07:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11682 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbfHPAHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:07:38 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7G04bmi014228;
        Thu, 15 Aug 2019 17:07:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vvxb8dywXEIu3tGxVQPeysTzapN5cjrzEXOWsQAKQHk=;
 b=hjH1R0hQMuMnY1q1T4qXZUsYFcqf8i9mvFo9zWfTdcMaKq/LxYDQ4R5GT4E0xA9x/fwe
 kgu06nYmEDghotTG5QyjVP1/Rbhs8Tibxlvvf8w+HIh4wh5gaHFaMeQ4wwjZse7Rm/Dg
 iMgj9zNrSMcasu5rua0J5vaXo/m6qaB85QE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2udehmgxbn-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 15 Aug 2019 17:07:01 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 15 Aug 2019 17:06:59 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 15 Aug 2019 17:06:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VigKAG5hRHOm35b8e7BOhMnkpTCsYho6XzurL3aK0SvW5/0bkkQgVclIelci3SoTuzHLQqrBKzEdrKURl4cWgrEw7xC184Szp/Xfl8oVhWG1/5FRbjD5mNqmJLC0/7QAAhFu1ptssjDp5aEJkX2JvGTpPeNrxSqINfk2NblVUi+JXClltmtGLpdMYy3jVypfwkLxb/oC7U5HBT6eKX4OtywLpwDNZMsaDrFCYSjh/TCyP88flS0h3l4ozX6zUVHrjBo0AGKJXRRRk5ozpa4GTusFpnVTkyMbk6ebp6IhQsg5akFHIJbL7e9XARiW6C85KscyMM9SLUdL+hIZAdAq1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvxb8dywXEIu3tGxVQPeysTzapN5cjrzEXOWsQAKQHk=;
 b=Fl2WU8uex1mf5Qw7rceS7eE5swjlUCZTcSZLPP3YbiBbjhLOnVmDlNTNJIFcew81q7UqtCDyDr7+WrfjmnvL/MGenNXQ5/u+tRmYv77oLR4leXkA7jHX0gAbOk5ChXVjg5a47n3iod3SWz18hOLj0LDQjeVuQhy3gSKoGxS4hTVc7kI9PDPNatCIm2L652lBu3bmlwIbKYrhQ8AoseUfxEgbv+A1G+sRvgxNyOthAWcB/0EdUjN4d6D8SqTwMlMisKyVXpktjjHcPOycJEGMXswL7AqoNeTQtVJ5Oc0QEjF86MKRpnsuwCsEjQ12KFteSN3o4BjPcpQSKGKN1CCmDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vvxb8dywXEIu3tGxVQPeysTzapN5cjrzEXOWsQAKQHk=;
 b=h+TVQs2XzJKoJnBZAqbgaHZguGZDLRLr7pLoQkvaSCDNmnuBzVfwqMNU/OE3lPHRm1gCWqT3c/6db0z6r6IAfvASnRw4q0p3rZt5UYsPaa3SKV7Mm+Qe2G01HcrX8XnU8uYeIQl0lTzIDUYPGr8GAQfSg3sw21DoZ9k+HBwmcqM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2424.namprd15.prod.outlook.com (52.135.198.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Fri, 16 Aug 2019 00:06:58 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 00:06:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlemon@flugsvamp.com" <jlemon@flugsvamp.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] libbpf: use LFS (_FILE_OFFSET_BITS)
 instead of direct mmap2 syscall
Thread-Topic: [PATCH bpf-next v2 1/3] libbpf: use LFS (_FILE_OFFSET_BITS)
 instead of direct mmap2 syscall
Thread-Index: AQHVU8aF/QvS/xH1r0S6gYrkS1Hn9A==
Date:   Fri, 16 Aug 2019 00:06:57 +0000
Message-ID: <7e323b73-8ed1-349f-4c08-49450854be0d@fb.com>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190815121356.8848-2-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0104.namprd15.prod.outlook.com
 (2603:10b6:101:21::24) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:11f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 262d26f6-b640-4772-bd84-08d721dda769
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2424;
x-ms-traffictypediagnostic: BYAPR15MB2424:
x-microsoft-antispam-prvs: <BYAPR15MB24249009FF95057218789220D3AF0@BYAPR15MB2424.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(39860400002)(366004)(396003)(189003)(199004)(4326008)(52116002)(386003)(31686004)(102836004)(53546011)(6506007)(486006)(316002)(71190400001)(476003)(186003)(2616005)(76176011)(6246003)(110136005)(53936002)(6116002)(71200400001)(11346002)(81156014)(25786009)(2906002)(81166006)(99286004)(54906003)(8936002)(66946007)(8676002)(64756008)(36756003)(478600001)(66476007)(229853002)(46003)(7736002)(14454004)(2201001)(7416002)(66556008)(6486002)(14444005)(6436002)(86362001)(31696002)(256004)(5660300002)(446003)(6512007)(4744005)(2501003)(305945005)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2424;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WUwJ7595xX2WmCSa1BaT6gq3XBJPwdH63Lxzs7f2FNAJt/kC2FUiz8CDSd9hNIZly4wqe4Zk3g4Qg/79tjRKFQIn6fgdJ4MAJbzmhVE+rF5UBejAYjlryOYoKezqxrAc17KlD+/8XYm90UDwmiD6MU1U6H/VlBny3Kxdg2hYVTfw6T6imlVN8HzjZ2GOHvHdViornjj4VIMn/hbfaJkHdT1AUEBVauETsTz2sNguoDHz/I/aUJa4kde6cFq74e7tyNJiFr0W6o7F0xhs7qxb4QS6TA10meSaUh5BHVfRjqYWbxNMO/fDw/GK8EK/TXlQvIznEi0Kd7HwkZFgXtlPD+HK1U763h0tvAhOqeicXyo8GDF6ARN4rOw7Io5PXHG8AeOp/ubMjRu4BkeSeM1LMOHYb6mjf4rlMPqR/5qhxdI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9A6445D787AF145A235E478231C6746@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 262d26f6-b640-4772-bd84-08d721dda769
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 00:06:57.8497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0VspcJshEQWC3r2QAIyoO0iEOzIVXkN8rc++C8ktNYlOSd04SiXkknxeSiE0nevn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2424
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=891 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150232
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTUvMTkgNToxMyBBTSwgSXZhbiBLaG9yb256aHVrIHdyb3RlOg0KPiBEcm9wIF9f
TlJfbW1hcDIgZm9yayBpbiBmbGF2b3Igb2YgTEZTLCB0aGF0IGlzIF9GSUxFX09GRlNFVF9CSVRT
PTY0DQo+IChnbGliYyAmIGJpb25pYykgLyBMQVJHRUZJTEU2NF9TT1VSQ0UgKGZvciBtdXNsKSBk
ZWNpc2lvbi4gSXQgYWxsb3dzDQo+IG1tYXAoKSB0byB1c2UgNjRiaXQgb2Zmc2V0IHRoYXQgaXMg
cGFzc2VkIHRvIG1tYXAyIHN5c2NhbGwuIEFzIHJlc3VsdA0KPiBwZ29mZiBpcyBub3QgdHJ1bmNh
dGVkIGFuZCBubyBuZWVkIHRvIHVzZSBkaXJlY3QgYWNjZXNzIHRvIG1tYXAyIGZvcg0KPiAzMiBi
aXRzIHN5c3RlbXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJdmFuIEtob3JvbnpodWsgPGl2YW4u
a2hvcm9uemh1a0BsaW5hcm8ub3JnPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZi
LmNvbT4NCg==
