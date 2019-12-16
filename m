Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B5511FE52
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLPGAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:00:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfLPGAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:00:45 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBG60gga005933;
        Sun, 15 Dec 2019 22:00:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XV/KH5y5Wwhvs4O0l74bJAeX+00z+E1xmvKexUoF7Dw=;
 b=W5ZxnUOdym6QSzi4Nv6iVMSYBL7WNMJGd6hm7TaKQK/2cwFgBYMLacTLzqYGGnVMZEp4
 8HY0FeX3BDaaRZyNestGmT7kSDzhmJUuox5B6L0Yu3y7aj/rLyaUQxO2tBsPYHZ6R22R
 T3dj3bBoD9n7mo05WMMnbJku9HFu32D88to= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgc0js05-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 22:00:43 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 15 Dec 2019 22:00:12 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 15 Dec 2019 22:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtagY5g4LFygAJmiov7XNLzSKXvATAdxjxoXiMX4mwIIZu49RLh1XzxNv7TwH9bNTlyaH6eEDmseM6fhA/aYtXoM4L633XwJJNMcEwPHiQ1LuwldpV9nf3jdHK9Eu74lK1/QQ6e/Jd12VY43MNH/d2xGMTtY9T6sjHEAqI8gbE1fbULiZVQaCeWBGs0ykBTIlp6wEOx8yr6PSnHdLjc+t9+Mn1kYN0zNYV5gd8/PnayEkk/Tgf04CeIm2SskcqR6w7ggDjo2oaXl8KVPyet0vRjHZJ69P3JO7/lYUEfYy+USOqd+LJWJSnB4UmW0NQXBAZHKjdn1QYcrzGPO70wnZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XV/KH5y5Wwhvs4O0l74bJAeX+00z+E1xmvKexUoF7Dw=;
 b=iwWjP5lgv+7jaP4NvW5pJNPxbbPIjqHOAAnHHH9T0b2UU8lNAVDGXhZeEx/v6aW+OLoxPZoZ4UY7MurJiKVZ5ZyUst5qnkQULtQlZc0HEUyr6z2IF5UJuy406rmbsaG8HNg3WO3V0lsPeLGdmcVI2/0S3Y9bquUl8bYiS1Q3AAQKeVPTElyZCgSh+RO8FjUhAbGRk+KzGpBNwMqG3v5QPxe2P+KQAaPQWnxaP5ne9R9eY+v2EXTKlfU+ASfVBzUOpjm6jqDP8mnB1iueKMTEYX8e4c4GyP+IKd7l/ZqDrFxi4XR5EJqslLKIH/yT6fdMK8jl63ww0PXW37PA4vJhhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XV/KH5y5Wwhvs4O0l74bJAeX+00z+E1xmvKexUoF7Dw=;
 b=HBC5vWxOZjhG/y9y5UiZWrkwVcoX8dV6FDeVnarL3gOI3QI7oiXSIddKvpJu9CAVfGaoUCFwg3McWI/XMiE8os7XaV99yb0l25RsPBfj/Ckvme1Vb/2FkHzyAgsco+Yjpp3yuLRxl/n7nb8VKF52uNPv+JUhuy6x8WpDJV+WjMk=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1452.namprd15.prod.outlook.com (10.173.225.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 05:59:57 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 05:59:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jules Irenge <jbi.octave@gmail.com>,
        "bokun.feng@gmail.com" <bokun.feng@gmail.com>
CC:     Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "\"bpf@vger.kernel\"@vger.kernel.org" 
        <"bpf@vger.kernel"@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: bpf: add __release sparse annotation
Thread-Topic: [PATCH] kernel: bpf: add __release sparse annotation
Thread-Index: AQHVs5+2HhiAKBeViECR7jMbivMnZKe8RNKA
Date:   Mon, 16 Dec 2019 05:59:57 +0000
Message-ID: <dd0b6577-aaf6-a557-4cdd-ddc490995c38@fb.com>
References: <20191215233046.78212-1-jbi.octave@gmail.com>
In-Reply-To: <20191215233046.78212-1-jbi.octave@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:300:117::29) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a11e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc8391b9-5a84-438f-af6f-08d781ed2db7
x-ms-traffictypediagnostic: DM5PR15MB1452:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1452B0BE8D15FC6876C9BB10D3510@DM5PR15MB1452.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39860400002)(136003)(366004)(189003)(199004)(8676002)(5660300002)(186003)(8936002)(558084003)(81156014)(81166006)(6486002)(66446008)(66476007)(66556008)(64756008)(2906002)(53546011)(6506007)(6512007)(36756003)(71200400001)(86362001)(4326008)(110136005)(2616005)(478600001)(52116002)(31686004)(31696002)(316002)(66946007)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1452;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1vy/F6EPRKhXy3eeu3bZXWFmQInZy6h0l/fCeuwNb2u6w0aDDl7SjwL2e2I31V0Tdg2K/YFbCqxOMvAyLMfuy7tbMVlF438FbQ6c8pLOaEqyS9pGRIyRIjirVJZJPIRBCFBEtekvedd20rD9d0aYpx5MxL93hqUPjcryHIu9te8HdhhVMxduuFjMtzRa8sV1HBk97wMmfwHmG1vJCWWnEe6agj3AMbqi5eLDx/kRB9vr4N9Yh7CerLaeAp/M+bswbu9UJGilPJbjyi8AqcK2nADFMi/px9HOsmE0HX6PUgnXVd8KrNU4KPByD6MiXbB57KeeDfgkIvgOcIJVNqaVcKh+08h43flTGhwhr47zBcK1YQ/3rOyaZ0a6hop4KyGQam8kr3xce9PwDU1SBiBAIRHtPLkFKD91aH8ZeTajE7WgSla4jefTsSGYQ9c4933
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E71F68C8F2F50479B47BAAF37210AD1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8391b9-5a84-438f-af6f-08d781ed2db7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 05:59:57.5317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 76jCpPvkcxsw2xcmbz4afOupQ0vJo0xnD02wsaR5KHcMiHFvoBRs4zTE+TTNt9z8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1452
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_01:2019-12-16,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011 suspectscore=0
 mlxlogscore=591 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE1LzE5IDM6MzAgUE0sIEp1bGVzIElyZW5nZSB3cm90ZToNCj4gQWRkIHNwYXJz
ZSBhbm5vdGF0aW9uIHRvIHJlbW92ZSBpc3N1ZSBkZXRlY3RlZCBieSBzcGFyc2UgdG9vbC4NCj4g
d2FybmluZzogY29udGV4dCBpbWJhbGFuY2UgaW4gZnVuY3Rpb24gX19icGZfcHJvZ19leGl0IC0g
dW5leHBlY3RlZCB1bmxvY2sNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEp1bGVzIElyZW5nZSA8amJp
Lm9jdGF2ZUBnbWFpbC5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29t
Pg0K
