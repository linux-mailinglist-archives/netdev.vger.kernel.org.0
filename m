Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F80121EC7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 00:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfLPXJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 18:09:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23592 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfLPXJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 18:09:14 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGN6HKM028471;
        Mon, 16 Dec 2019 15:09:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=t65S2psSN1Vkh8Jih7/zOoFGuUjOSFnQaJ2dxQ4H2fE=;
 b=nIB2InqUd9VyazjkGldJaDxJamA1t0uBizp8ZNGXQ8MaIHlSMdh8GkjlgfKQLmk5YlgF
 /d+x0fnTh9gBEaphM/WnQ3OWQtSxGzVS7xJkML/t5OvYh1VxnB9mdQMcoI1SY28VQi3s
 JNKRhVKAsxH7IBRsZrcZlF7NYpyv6I8ho4E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxhkr0gaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 15:08:59 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 15:08:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 15:08:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKBVjFoAlLwUEjFXzgeqe/wEjRdCg6ADSkBSUvesoTFeOfe4lOU66kREj0nGadG5YVDLTJMXWgpOfAIJtcebFgzbsqx0QUKo9bWPE+jsGBljy7DVYkSfy81CYtGQG9hlU6K69f5XfYsaaQ04R2MoWcE1AlgAfTKYLbQ/qeLbEYceRm6r9h4447umTH8FxmAucH283z77kpeOhbthinquoK3iXn4F/Szv75geFYyawMLv7u/BHhdvK5BxFbFRTkpouXYwfb/jQSKeam8tNdtoWAnvaw4YhcLCDONXqkTxZFu4yw83Zh8yqcZO4/msK41aX5jJYsKn9b8g84QkNbMzRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t65S2psSN1Vkh8Jih7/zOoFGuUjOSFnQaJ2dxQ4H2fE=;
 b=CxS4ANwT8KvNgpcNupzvNmUHEmd6IZTWM4y7+tJZ21ieOzlr3QAvTgVWnjoS0WEluOseTVr6lVYQSLb4YtPQNchrep+U8m+i4vvCOCcClMbXITGNH+kV38P+hf/p++7/7FuQkGR/3XbS22FlA/cx4dh7hDwxwFjbKMqXbvS266ESShE446fysCFLXdPznMs16xkxlCoVPG18FFq1la1B5N1w9qDIkiqBd+skMLKcsTZs1Nv68l2HlBvpOeh91M6ff5l3BmTR2ZONRaHevSYNa1OMd/ecHc9G/pdv9W6b6w8qbKbZSATXwsvZDr5JW71fp4aIwMl7DzoIKvCsWlO+PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t65S2psSN1Vkh8Jih7/zOoFGuUjOSFnQaJ2dxQ4H2fE=;
 b=OdT7lJf4V7zsqDEQ2Yxp4snnapAK3Y4wuuqaOKFg0YgUTCs8glm7qzA9biAhpNNHT1ckNgE4FuQOaRdmDda/BEdSsYg7p84m09pkGdu4iSd3XKtPtug44Nh0jk4vkotsgvFJkZNu9GQlT3ETzqmxIVbD1KIDdINzYrtsRyeGB7U=
Received: from MWHPR15MB1678.namprd15.prod.outlook.com (10.175.137.19) by
 MWHPR15MB1374.namprd15.prod.outlook.com (10.173.234.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Mon, 16 Dec 2019 23:08:57 +0000
Received: from MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8]) by MWHPR15MB1678.namprd15.prod.outlook.com
 ([fe80::9496:6fad:96ac:4de8%9]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 23:08:57 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Martin Lau <kafai@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Topic: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Index: AQHVshg+O75fdw9s60exf/TN3zpX+ae44CoAgARFmwCAAEGegA==
Date:   Mon, 16 Dec 2019 23:08:56 +0000
Message-ID: <d7bcc8c2-f531-91f5-47e6-d18d8a99c1e1@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0002.namprd17.prod.outlook.com
 (2603:10b6:301:14::12) To MWHPR15MB1678.namprd15.prod.outlook.com
 (2603:10b6:300:11e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:48aa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 378f1fa4-4f69-47a6-a090-08d7827ced60
x-ms-traffictypediagnostic: MWHPR15MB1374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1374793BDA85C6431AE2BED3D7510@MWHPR15MB1374.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(39860400002)(376002)(199004)(189003)(2616005)(66946007)(110136005)(66476007)(53546011)(6512007)(66556008)(2906002)(64756008)(66446008)(54906003)(4744005)(6486002)(4326008)(186003)(71200400001)(52116002)(8936002)(6506007)(5660300002)(81156014)(81166006)(86362001)(478600001)(31696002)(31686004)(8676002)(316002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1374;H:MWHPR15MB1678.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5jxpHhywjI00RNOwfWd33yygOM5cQm8FgHNBmQWeyGfckahVXJTr/JsFapKz/1VUVbCdEu/R8iOt2gMeFrOw3UBkOM1uhHnYq0U3IN9re7AxqzTqn6TXMZQm39em4kS0LJtajuJwErEK9aWB1knfYHAbDAXvBqXCyUO+puuznvse2YGAT+wHCId2/Y27yQya3cRMTUEwRI+At0di4lPJuD1mZMIkoAnsVEBxXLQCT/9turUoS2KYeUnFFggkUGCpFpcjZx8ORo611yx1TBiU8/JFiRP/JDJtrMaE1SicRVPnHE2jy2ESknLUVls6PmqJueaQ2pS6loEmoNrhKYreagogpZ9nXvRwfqsqCRjLW/ET1wziST8eLrORqdWwHXE4dEnr5qFbmcdRDVcBQ2tpYqT51Jj86ROqIW3K0QyqFz2qGGghQXeyJedBbPI0yA0Q
Content-Type: text/plain; charset="utf-8"
Content-ID: <587A7BA82ACE8D48802F9885037E72F2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 378f1fa4-4f69-47a6-a090-08d7827ced60
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 23:08:56.9951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bhCjRwBX8TO8WnUdz7OOaVWPBPgKUDuWPpF1tGI0Apw+ZjheyRnesoJqmLgt3Ezx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1374
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=773 spamscore=0 impostorscore=0
 clxscore=1011 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160193
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTYvMTkgMTE6MTQgQU0sIE1hcnRpbiBMYXUgd3JvdGU6DQo+IEF0IGxlYXN0IGZvciBi
cGZfZGN0Y3AuYywgSSBkaWQgbm90IGV4cGVjdCBpdCBjb3VsZCBiZSB0aGF0IGNsb3NlIHRvIHRj
cF9kY3RjcC5jDQo+IHdoZW4gSSBqdXN0IHN0YXJ0ZWQgY29udmVydGVkIGl0LiAgdGNwX2N1Ymlj
L2JwZl9jdWJpYyBzdGlsbCBoYXMgc29tZSBUQkQNCj4gb24gamlmZmllcy9tc2VjLg0KPiANCj4g
QWdyZWUgdGhhdCBpdCBpcyBiZW5lZmljaWFsIHRvIGhhdmUgb25lIGNvcHkuICAgSXQgaXMgbGlr
ZWx5DQo+IEkgbmVlZCB0byBtYWtlIHNvbWUgY2hhbmdlcyBvbiB0aGUgdGNwXyouYyBzaWRlIGFs
c28uICBIZW5jZSwgSSBwcmVmZXINCj4gdG8gZ2l2ZSBpdCBhIHRyeSBpbiBhIHNlcGFyYXRlIHNl
cmllcywgZS5nLiByZXZlcnQgdGhlIGtlcm5lbCBzaWRlDQo+IGNoYW5nZXMgd2lsbCBiZSBlYXNp
ZXIuDQoNCkkndmUgbG9va2VkIGF0IGJwZl9jdWJpYy5jIGFuZCBicGZfZGN0Y3AuYyBhcyBleGFt
cGxlcyBvZiB3aGF0IHRoaXMNCnBhdGNoIHNldCBjYW4gZG8uIFRoZXkncmUgc2VsZnRlc3RzIG9m
IHRoZSBmZWF0dXJlLg0KV2hhdCdzIHRoZSB2YWx1ZSBvZiBrZWVwaW5nIHRoZW0gaW4gc3luYyB3
aXRoIHJlYWwga2VybmVsIGNjLXM/DQpJIHRoaW5rIGl0J3MgZmluZSBpZiB0aGV5IHF1aWNrbHkg
ZGl2ZXJnZS4NClRoZSB2YWx1ZSBvZiB0aGVtIGFzIHNlbGZ0ZXN0cyBpcyBpbXBvcnRhbnQgdGhv
dWdoLiBRdWl0ZSBhIGJpdCBvZiBCVEYNCmFuZCB2ZXJpZmllciBsb2dpYyBpcyBiZWluZyB0ZXN0
ZWQuDQpNYXkgYmUgYWRkIGEgY29tbWVudCBzYXlpbmcgdGhhdCBicGZfY3ViaWMuYyBpcyBsaWtl
IGN1YmljLCBidXQgZG9lc24ndA0KaGF2ZSB0byBiZSBleGFjdGx5IGN1YmljID8NCg==
