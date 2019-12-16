Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D045511FE66
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfLPGRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:17:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3120 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfLPGRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:17:23 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBG6HKAA027166;
        Sun, 15 Dec 2019 22:17:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=isi2U5f38t4Elzc3uToUmz/9L/uhNkP+kX9e6hgfR/E=;
 b=dy26gIdmIYmfpy+YatkkTrK7SnwxAmN3UOC/dWShMVFuEKGGuKRiur3k8Evjekje5BKj
 ah2ttIccMR9rq4/j0GLUfLBUiEw7blyz6ZO9XBUMUjZmAY9pYg0x60tbX2r9HGIG+bja
 A/L9T4ApYXDpbKxP+LJv5aB5LygmO8Ufju4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwtq11cwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 22:17:20 -0800
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 15 Dec 2019 22:17:03 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 15 Dec 2019 22:17:02 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Dec 2019 22:17:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vh4CmCmVNc3qlEfLXmi03HM9yPSZnGm2M8LnpMQ3x5zFOdz1ck5fxsF5g0wsrBfZJxUivr56eC/d6xZWatzvNQReCIKcHQ/XeG5pG1XnfO9/6FD13GoJNLCkNMDDu9zkKe0PFKL6HXV7IMMZq0Pt6swYZJd8ivW3i8DURVHUElhF84TDctLEZHVFrEUYJoquN4YfTlO+x5V72lBsioTeYs2sGp+vLa8Q56JiDdyYZQkolu7Jo35+9tvOtC+7BYzK5ieVxKkaKF4m78+OX8C4iHZEMMQkKvsWB8xJhXvTsnMvdzqBsbdg2vjg7Td6EwQU1op/9A7Lw8Oevn+Dd+qLlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isi2U5f38t4Elzc3uToUmz/9L/uhNkP+kX9e6hgfR/E=;
 b=emfJFO6jeokcHX9vZwUAKLzGmQCbAyAHum0d9o20PLmhRH2pUmznIjlZPj3IDIHePe84zNVVPOmOWxdP/RDskhE1AL4bbr7UGbLAyP3TV0Dk6LRQOF4tE0/coKP6NsgJ97gIyRPUO4gLUKsuraD9fUM3oA46cthIC3eddZ9uE/yP3jdcs4lZGN7H3tXCoDsGmjdtBmYjX3X6tlX/0KnJz7L3X8SZquuYhNNYo/47KeiN84i8c997jpivCgTGbklYcAu4O1adABobAKQiPA5dsVvKdWoF9Vgm1DS1t0/grQUlIZayLwTqpIyoGpTVOOHzQw26TNmMGyIWeqL69EbtcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isi2U5f38t4Elzc3uToUmz/9L/uhNkP+kX9e6hgfR/E=;
 b=TEZ8ksj19yzjLpDvR2hxsy6+fIXimQCzM+utVjLY29ziysnBLaIQ6z4qWxylXl4SOZnWyNZKSmpOYcVpUBx2gMRHS4fQTDWZsdjb8KCKX5iACoTHBr+lo37wO4qp2oB7VbZWEZD24MGpQkqDYHteVxwwStxj6WQQijcHkGcLuc4=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1482.namprd15.prod.outlook.com (10.173.223.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 06:17:01 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 06:17:01 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jules Irenge <jbi.octave@gmail.com>,
        "bokun.feng@gmail.com" <bokun.feng@gmail.com>
CC:     Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: bpf: add __release sparse annotation
Thread-Topic: [PATCH] kernel: bpf: add __release sparse annotation
Thread-Index: AQHVs5+2HhiAKBeViECR7jMbivMnZKe7vrWAgACK3YA=
Date:   Mon, 16 Dec 2019 06:17:01 +0000
Message-ID: <9d195192-551f-377c-d440-8156dfe20b7b@fb.com>
References: <20191215233046.78212-1-jbi.octave@gmail.com>
 <dd0b6577-aaf6-a557-4cdd-ddc490995c38@fb.com>
In-Reply-To: <dd0b6577-aaf6-a557-4cdd-ddc490995c38@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0033.prod.exchangelabs.com (2603:10b6:300:101::19)
 To DM5PR15MB1675.namprd15.prod.outlook.com (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::67a9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 059d3859-e456-4351-1857-08d781ef9023
x-ms-traffictypediagnostic: DM5PR15MB1482:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB148219EFFBEF4F0188BAB263D3510@DM5PR15MB1482.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(6486002)(86362001)(54906003)(4744005)(66946007)(31696002)(66476007)(6512007)(8936002)(6506007)(53546011)(64756008)(66446008)(186003)(2906002)(66556008)(5660300002)(36756003)(52116002)(31686004)(316002)(4326008)(478600001)(71200400001)(8676002)(110136005)(81156014)(81166006)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1482;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k3p423nuGClFMpg8FArSoumUHchR1/jJmxYyWuyLSs7jOzLUo+CAfxe1HTjkOBoEtEoyzg0ajBNK0gQBx2uWB9+x2VWrx1MQ8z78nwJY+9SC4OqWf+pa8bTw9c9xDFhDmSrun/jL3PVtO1TzzB6vXCw5LaoRi4qx4/PcL7GvGvNQrQmCLGEFnbFH0sZzFqDZd/QXwRjsUOipOjegpIPfvHthQeajH0qkEZqE584zm4cXLUuFcX38aZFwZm4l7d7F81agNM2mlMETzbWcty9dMEvm3tGg61pvFFuXx7er0Z1it+9NdAUsGnvX3SGV6OnnXIGufMzTeB2ogLkBxqAosTr7StusrfMvPum6YcRvAfnQKdP8urg7pPOh8O4HtNOyP2ncIFummHmoqO38d4nVMlaThGRWIExZufg9DTYkskAFZqfceV4YyjnA16eOw42B
Content-Type: text/plain; charset="utf-8"
Content-ID: <68377C18D38DE84FAFB6DF6870189460@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 059d3859-e456-4351-1857-08d781ef9023
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 06:17:01.4439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8d/06jaUmhXWbbkCXHI40kOnLGnEf4144V1L7IlyMbiNIklBCkYJoslXNhphLAZU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1482
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_01:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=661
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVzZW5kIGR1ZSB0byBpbmNvcnJlY3QgYnBmIHZnZXIgZW1haWwgYWRkcmVzcyBpbiB0aGUgb3Jp
Z2luYWwgZW1haWwuDQoNCk9uIDEyLzE1LzE5IDk6NTkgUE0sIFlvbmdob25nIFNvbmcgd3JvdGU6
DQo+IA0KPiANCj4gT24gMTIvMTUvMTkgMzozMCBQTSwgSnVsZXMgSXJlbmdlIHdyb3RlOg0KPj4g
QWRkIHNwYXJzZSBhbm5vdGF0aW9uIHRvIHJlbW92ZSBpc3N1ZSBkZXRlY3RlZCBieSBzcGFyc2Ug
dG9vbC4NCj4+IHdhcm5pbmc6IGNvbnRleHQgaW1iYWxhbmNlIGluIGZ1bmN0aW9uIF9fYnBmX3By
b2dfZXhpdCAtIHVuZXhwZWN0ZWQgDQo+PiB1bmxvY2sNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBK
dWxlcyBJcmVuZ2UgPGpiaS5vY3RhdmVAZ21haWwuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcg
U29uZyA8eWhzQGZiLmNvbT4NCg==
