Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF096A302D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfH3GlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:41:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4598 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfH3GlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 02:41:13 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7U6eoYu003068;
        Thu, 29 Aug 2019 23:40:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gfo2vDBGs05QB2AFn3unF1ou1hZsA8FPB+H9IK+IMPc=;
 b=hO8xxDLrHFrSS6j5BCxmqVzWEMEtu7WqW2stgvuxwiOEqdIG1JE5eSeoVuz0o4SuiT11
 sBe2CoAvXcC+XYCzOQRzgFAoLKp6Jt7rydHJTnw/PzyohKvECq1WkN8MfyqJEY6L6vQE
 j1o8N/fP1AX1ht49ccniJSBQDPx9OLc01gQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ups2kh5q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Aug 2019 23:40:50 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 23:40:38 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 23:40:38 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 23:40:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTDG8KmSoE1tCQ9oZPJFAEUgtxcxcuKlCCDMFFISTxZNpTS8a19+0hReWTUkAo9o2uISL5aHTRWhZm1EH8ni9cMv2RUlqDmvugEVw7FG0Jy/ht5guYGI7SVznhngbchxJW1fq0XTzY4dJ36zLV2OqNXnLHE8oRZGj/QmCxLujp7c7HKxyRLWI5rLOCbwFhUqrp33XkUDzDrEBBwryACTK5wSnXOnSgaoqOpYbPC6mE1ILHM6E5LH87sT0Clo8kzQ/CeaZW5neX0FolJkSJjRz8VS31C7rM9cGenS8NGiKGSpLKSQ7A1rvfsfyVsMBhDWL08182YWcJs+ZadDJS2mkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfo2vDBGs05QB2AFn3unF1ou1hZsA8FPB+H9IK+IMPc=;
 b=nVG+bchhft/qwY0IDxd2hktM7fU3rt1MwY9QHHzv5h2+gPgFifg++NSd6ULL99IpMRfdbw+yETlp6HZqsU+4RuX91D1KQTOkXp3gdI5+yGEWzW1ypEezqaD/3Sr02dM3Ng3Va5mt2T1KzTmKy8Z+dj6TPZO849ZIeTGPNMaIqsVANAwaK//9zvEDecNwUe3kbXufWjFDWUEfVGdkgHq2fJPauhxvxY5YToEozcdFlIawc4Hbp9NUEYXS3/lwFaC8zIN3fqIKrUX6xm+r/BEGcAPVTpJQCNNpqDOHNvOIK9bNKupzeDOwRwfmvdvpBvhmlbxovyrxI5pk9ihUARbNyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfo2vDBGs05QB2AFn3unF1ou1hZsA8FPB+H9IK+IMPc=;
 b=UOuZ4vfm3d+W53yvaJ+r68X+m64VQvtYHttDn1KuWkJ5/lbbFYHOu9ctJpGErsIj91hYnJyzFC3NQ2gfV/lubA2jK1i4JdrC8YIl/09aoa5aDvkI4j4E3g+J7okXtJxsGiDCKxxMC1lpDWSW8tW+IylNtEvx1arl2jwDEbEoVdI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3464.namprd15.prod.outlook.com (20.179.60.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Fri, 30 Aug 2019 06:40:36 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 06:40:36 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 01/13] bpf: add bpf_map_value_size and
 bp_map_copy_value helper functions
Thread-Topic: [PATCH bpf-next 01/13] bpf: add bpf_map_value_size and
 bp_map_copy_value helper functions
Thread-Index: AQHVXjVRQXrHozbC20COTOU1e//CDqcSrvMAgACQSAA=
Date:   Fri, 30 Aug 2019 06:40:36 +0000
Message-ID: <b2d6984c-1a20-8ec4-34a5-bbf989fb6365@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829064502.2750359-1-yhs@fb.com>
 <2DB6B840-9EF6-483D-8570-4BB9EB74F3DA@fb.com>
In-Reply-To: <2DB6B840-9EF6-483D-8570-4BB9EB74F3DA@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0041.namprd07.prod.outlook.com
 (2603:10b6:a03:60::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5364]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd224e1e-91ae-4648-da3c-08d72d14f732
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3464;
x-ms-traffictypediagnostic: BYAPR15MB3464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3464BE715EDC45F4C13D92BED3BD0@BYAPR15MB3464.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(376002)(346002)(396003)(189003)(199004)(478600001)(6862004)(6512007)(25786009)(99286004)(6116002)(2906002)(36756003)(6246003)(66446008)(66556008)(4326008)(66476007)(64756008)(4744005)(86362001)(6436002)(66946007)(256004)(81166006)(8936002)(31696002)(8676002)(81156014)(7736002)(54906003)(14454004)(305945005)(53936002)(6636002)(5660300002)(71190400001)(71200400001)(76176011)(52116002)(446003)(2616005)(229853002)(37006003)(46003)(102836004)(6506007)(386003)(11346002)(31686004)(486006)(6486002)(476003)(316002)(186003)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3464;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8Th4ywe0s0ii+u0c1rX67sLRs4rW4TjWghSXLvNcbmAjN1z7ukaVdS3HHT2OFkCw4RvtvCzM2ju6XsR6+wAay6OWC3bIqFOjSDleowQMuyeQMyRurqUZSUZec2vlKWoyvsi0X8r0ni+1NTpsNcAxZzyg+GQY4FXx2OIgORctBzhE1v41AuWacyAXtGjvDMUj09gJgB+8hnynZ67yaY/27IgB5RicnuJ/lKmWaJe0OpBl0Wri3HfIO4RZyNtonhYMMwWIzXHP68sBiJQ+JIpxDxH9CH06WzkmDy6uzMY6BzdhX1snv/1nUfmck0M2VzOR+iRkZOPGLYgDUye33BaAqOU7p+uS6aLwfSlOy0G8QKU3oUptb9TO3peLqRgXYXO1a8BkH6Omt0rAZPQeZvwYsnEun5wN4ET0AMeQ2jfVRVQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <653ADC8892CD704EACB5B8D848AF708B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd224e1e-91ae-4648-da3c-08d72d14f732
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 06:40:36.7864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jAIHs25z4WUL9tjSynQhyoKxRpnf38cDTwHGbKkuAq0ytmmcknAPxybru6gXqubT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_03:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 mlxlogscore=448
 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300070
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjkvMTkgMzowNCBQTSwgU29uZyBMaXUgd3JvdGU6DQo+IA0KPiANCj4+IE9uIEF1
ZyAyOCwgMjAxOSwgYXQgMTE6NDUgUE0sIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdyb3Rl
Og0KPj4NCj4+IEZyb206IEJyaWFuIFZhenF1ZXogPGJyaWFudnZAZ29vZ2xlLmNvbT4NCj4+DQo+
PiBNb3ZlIHJldXNhYmxlIGNvZGUgZnJvbSBtYXBfbG9va3VwX2VsZW0gdG8gaGVscGVyIGZ1bmN0
aW9ucyB0byBhdm9pZCBjb2RlDQo+PiBkdXBsaWNhdGlvbiBpbiBrZXJuZWwvYnBmL3N5c2NhbGwu
Yw0KPj4NCj4+IFN1Z2dlc3RlZC1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNv
bT4NCj4+IFNpZ25lZC1vZmYtYnk6IEJyaWFuIFZhenF1ZXogPGJyaWFudnZAZ29vZ2xlLmNvbT4N
Cj4gDQo+IA0KPiBBY2tlZC1ieTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4NCj4g
DQo+IFlvbmdob25nLCB3ZSBhbHNvIG5lZWQgeW91ciBTb0IuDQoNClRoYW5rcyBmb3IgcmVtaW5k
aW5nIG1lIG9mIHRoaXMuIFdpbGwgYWRkIG15IFNvQiBpbiBuZXh0IHJldmlzaW9uLg0K
