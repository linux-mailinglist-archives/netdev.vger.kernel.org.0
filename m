Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9956894F8
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 01:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfHKXyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 19:54:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbfHKXyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 19:54:37 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7BNr0GO022172;
        Sun, 11 Aug 2019 16:54:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uoWJ1L0O5HXrxkkmGxBkphgzK3Y1IGtMs+27uis9iZo=;
 b=jAjWMqVnpffp5JxzEMcXeK8qhO3+82YbrgwUdDHs1tGwgE+ppPZ/jLmpyEH4NqvhiB0E
 KEC+6UlB/2GNMvSiuPvSgW6bREF6c6dpgeZOI3XhTvWEMSS1tZklOiV4IedClO9oGhqS
 bjl+Rlk5jiEeNTKZhPZCa0kKfsPUHnmLNxE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uagfjhqd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 11 Aug 2019 16:54:13 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 11 Aug 2019 16:54:12 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 11 Aug 2019 16:54:12 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 11 Aug 2019 16:54:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDeE+gkwW92043KhclAs1yVdaU4tufutwqwPIMXwfcj5bnFcTpEO7UgiK5MGpV5HFKI+UbYltzLyhsvOTtRi7ih60SxDqwWRsYI1Pkj3Znx05Oeebgpji+UODZ7irritlzntlITDTJn9/fiQf/QvnVDZEauvxHWfRU9rILppOpIihHase7T6XwwOQhLrsaHe8NZ1qHJ0hZOv+E0C+vMxIH/Ys+QEKBKxjNlFpsthxAZy6vWCMSlgo6eVHw6dOVhl2LcMw3Km6MVHT5g5ptbH2fHQo5cTNS9mOouQPLmSRzc5nTKvVILLp4aFH7tZcOphqEdfGcsep29SCQxHao7nUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoWJ1L0O5HXrxkkmGxBkphgzK3Y1IGtMs+27uis9iZo=;
 b=AUfxK947nMrUxrQ4eetOP6efDo+PGx+d2MIXS98r7qtzXMn9iQzROaDwuMfHM58tq/PsZzfwWknoI4g2+R2Bl0ebujVfpbgTn5zU1jBo7+8Rjn4l7MwKY7IVXo7gOdvBCnH9JXRmC7QDq+LBLYo7a/TXbbpGCNx4G1VXyWFXanqrWdL1y44w1jI4eDNWK8e2QQZcyXesJ6zRoSPo4lGpO7SrJogEiWb/PF0k3otmuCTjTIiJA+4qdQlm2GlBvsaZ1A+P/v+W/aLV+B0PK8tpQFs6TJyDzWX9NJ1Bb70FZL/CV8PvV5qUsVl7jmyeSCtPGDiO0VoAEc9LAvjbZzJ9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoWJ1L0O5HXrxkkmGxBkphgzK3Y1IGtMs+27uis9iZo=;
 b=KHHHCAR9aEe9VdFRY+mWiZiKVUia+oDSc/j3nM3Na4lWXRqlc+JVLBoTST1ziJHjme3cAjIzvrKZ6GaatrUq/hm9Hk89akYXkJWtmXGR/RaS3YpoweJQrCK5iARxFa0M740zhMbaT0HFhhXMeQvSYCcvQnaMQ8dWfDoZl4RwG3Y=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2583.namprd15.prod.outlook.com (20.179.155.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Sun, 11 Aug 2019 23:53:57 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.020; Sun, 11 Aug 2019
 23:53:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 1/4] bpf: export bpf_map_inc_not_zero
Thread-Topic: [PATCH bpf-next v2 1/4] bpf: export bpf_map_inc_not_zero
Thread-Index: AQHVTs0It+Sr57LJbEKmZvxJ0XoZmKb2onWA
Date:   Sun, 11 Aug 2019 23:53:56 +0000
Message-ID: <98176c16-ca5f-1263-3be7-ebee5aa13aa7@fb.com>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-2-sdf@google.com>
In-Reply-To: <20190809161038.186678-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0039.prod.exchangelabs.com (2603:10b6:300:101::25)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f361]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3294a22e-ba41-44df-7e81-08d71eb72c51
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2583;
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25832EDD44D59B6E9F0162D5D3D00@BYAPR15MB2583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:199;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(366004)(346002)(39860400002)(199004)(189003)(66556008)(53936002)(66446008)(66946007)(31686004)(64756008)(316002)(478600001)(229853002)(7736002)(186003)(76176011)(8936002)(14454004)(8676002)(81156014)(81166006)(6512007)(110136005)(66476007)(4744005)(6116002)(305945005)(54906003)(6486002)(6436002)(2906002)(36756003)(2201001)(86362001)(25786009)(52116002)(486006)(2501003)(71190400001)(71200400001)(46003)(14444005)(446003)(476003)(2616005)(11346002)(99286004)(4326008)(102836004)(6246003)(53546011)(6506007)(386003)(31696002)(5660300002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2583;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cLIuu5v0S9zHH80AdssUiyHEmmd+aHbJXXoxHdWGmjeiJXNYYnUSs1QSxrvFBPntziJ/dhvCKQqw3NaJiafZdSOlbQZLzoewYhNvjRJGz13aQH9m4mEb75ebCdj0Zpeg+m6q01Uc5AkabgISUT3OdaYvYJKSmLYsIYdsewlOcrngYJIStxLUk21RnPxuTVeMOhndVdmkHanC7LbMTxddsmRNUcvzHCH4KQEsmQR4ADf0D9iI7tC5lXY7VHgBUcMSlITkNH3RAaIqCcvICY2EY4ON+BAibkyEX4NY1kpzkfosnX08SA/jRXfvwuXJiSQMZYk7+T6ofBjoP5a0vI56qzco1M4deLNjkylKAlOJvtuJZnlhn75G+tCNo8Nc8A8i+qFo+9AsMD5kEzq1V/XFKfreeWsZDDDGhMl6tbSC5/g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1047730D5312FA4EA6FD4F73B1B3C934@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3294a22e-ba41-44df-7e81-08d71eb72c51
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 23:53:57.0789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +hqHqNHm3iPNBmC5N1PczpNKwOYWEePy1YKGT5tp5RIEb77jtIvMs+X/hsHaE6L3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-11_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=688 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908110267
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvOS8xOSA5OjEwIEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IFJlbmFt
ZSBleGlzdGluZyBicGZfbWFwX2luY19ub3RfemVybyB0byBfX2JwZl9tYXBfaW5jX25vdF96ZXJv
IHRvDQo+IGluZGljYXRlIHRoYXQgaXQncyBjYWxsZXIncyByZXNwb25zaWJpbGl0eSB0byBkbyBw
cm9wZXIgbG9ja2luZy4NCj4gQ3JlYXRlIGFuZCBleHBvcnQgYnBmX21hcF9pbmNfbm90X3plcm8g
d3JhcHBlciB0aGF0IHByb3Blcmx5DQo+IGxvY2tzIG1hcF9pZHJfbG9jay4gV2lsbCBiZSB1c2Vk
IGluIHRoZSBuZXh0IGNvbW1pdCB0bw0KPiBob2xkIGEgbWFwIHdoaWxlIGNsb25pbmcgYSBzb2Nr
ZXQuDQo+IA0KPiBDYzogTWFydGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29tPg0KPiBDYzogWW9u
Z2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU3RhbmlzbGF2IEZvbWlj
aGV2IDxzZGZAZ29vZ2xlLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5j
b20+DQo=
