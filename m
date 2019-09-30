Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABB7C2988
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfI3W2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:28:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53068 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbfI3W2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:28:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UMHpJQ015998;
        Mon, 30 Sep 2019 15:27:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YGE1qkesxM8283tZEAiKj/5BtMdJPMiHzfaDUmjJF/Y=;
 b=FAtmd1Aq4D67Molqbm7JcZIpDJ+ZFHcvED1GbgczKx1maegEFQ0sU7ZfB9Q14izBFbQu
 VBNMCIqP9mBp4TIQB06TLWATIol+1NiLgXtNpFxOJVMsezcRRlcpt/xtHtPjnTSS/X3M
 CMNqQH+MwUsDS5nVUodn6BgAMEOJLbUxcYE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2va5bg2mnc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 15:27:58 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 15:27:57 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 15:27:57 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 15:27:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIdWLzXmVzxw6ayZKTu+BBuozax2RPWWLSWk63b+Zvl4QhuP3EfExniX7SrmmznrKc3NFxiQlItLf4AN/ELZzu/LbsqnpjwFnQ3V5nC+BjpcqB9kKEfSdAn/uQvrhinKC0PTeWlo0U6LLW+tzsbYwoMLn7zjAoRM9VwF19vEDa38eeuVMBXQA5UixH93YCMeBLfulROsCPszf+v2wxU1daO0BAJWD2h6hgIOgsyfoPA1EbXtaB5ttkZw9+cufOPaik9wU+WFCNQP1uL45pQAnen2Vz6EHRBk7JZ8uV0/41mDeLuoUEBRn7QIJCexm/8/u7YOjt0M3yz4jWfYSVO4gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGE1qkesxM8283tZEAiKj/5BtMdJPMiHzfaDUmjJF/Y=;
 b=c5cGBjSIJqc2Vp1oaKlARJrEjXWIg4R+vf+Z2qccWsxQ7MHiA7rRmQsVa+VYS1iKKnMlIizxBTh8J5qyIaCf8rZ7JLvEhGknETkK+Csy5NhVTHjYnK51SnI/lmwQzxODdLlLOsFSM6XfnY33lrXuuOpoPrQ9MECm1X98mQ/0pHkh8ir+HvDib0xEx85tN0V39gICLZWQiLDlHuE0aX/n89CqeCO+CxtHbwz4wBF9qUohGnQKrlefxo6fUoOrR2BCJ5ys7XjIVVs/Cr39s48jMIuxIP2c4ak4acfwUNVVjenayyXjGjd+p56kMrunXBw804RkuczlIsgZDUiQe+r4Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGE1qkesxM8283tZEAiKj/5BtMdJPMiHzfaDUmjJF/Y=;
 b=RwpsAMJmq33Z4e37nRFX+xOHv9c53tayAPnEuEMs2tj08uHJFuFgIrY3mojfn41/gHlmP7mT34LBJrm9HzjXAj1iGSQ+u7++bnlKpdSYoKeFDj0vVwoNc0nkSbnE2EPFYCaA2bQhlR8EvUomllFu40wIkdDGiquxPAnPSlq8REU=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3493.namprd15.prod.outlook.com (20.179.56.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 22:27:53 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 22:27:53 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf v5] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Topic: [PATCH bpf v5] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Index: AQHVd9JeR64q48tW30m3jo97OwQzYKdEzPKA
Date:   Mon, 30 Sep 2019 22:27:53 +0000
Message-ID: <b16a18c0-bd16-4b2f-1ee6-f7bc6477da44@fb.com>
References: <20190930210203.3196501-1-yhs@fb.com>
In-Reply-To: <20190930210203.3196501-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0064.namprd19.prod.outlook.com
 (2603:10b6:300:94::26) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::c799]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c44f9856-278d-4f79-e498-08d745f56f4e
x-ms-traffictypediagnostic: BYAPR15MB3493:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3493FFDB20F701F4F2F1531AD7820@BYAPR15MB3493.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(39860400002)(346002)(366004)(54534003)(199004)(189003)(4326008)(86362001)(31696002)(46003)(2616005)(2906002)(11346002)(25786009)(486006)(446003)(71190400001)(71200400001)(316002)(6116002)(54906003)(110136005)(305945005)(52116002)(2501003)(4744005)(53546011)(14454004)(6512007)(5660300002)(76176011)(6436002)(6486002)(386003)(8936002)(476003)(6506007)(36756003)(99286004)(229853002)(478600001)(6246003)(8676002)(186003)(2201001)(256004)(81156014)(66446008)(102836004)(64756008)(66556008)(7736002)(66946007)(81166006)(66476007)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3493;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wA+HvU/1NyPjxspLQeJ3vwdUpF/KIYaCr/Eqnpa5V4/FEpt64wnBQdhmAgnwfoZk+7tVpIdzdD6ZJ0uKYeMVqeZBxhzsqZM/BiswUoC0+fWM+3aewlOVjuSiSbhrANu0cjaoMWjSTr9Fd8jqQnplqijpj+IAnVVyp241LrfBvPT5WfAHht690HFxFGG2/fRfaScfezTw3w31cqNiMbCjCeO9yMZIaiX7ilju5u/9LXQONkMbSeXt6jPpOiN8DsnNUF2rMkDgwsjMny4eeMCaVL3ozw9az6f4NNyaBqTge01IpKpFfO9VehLXL+mO/MxCHZmEXae4nN5L52I52k43vulSFalnRHYk0dWUGwSEPEwZVQm8BZcB/R10hnQfbUo742nAqn1fTbhlj+66bkTtClQqde+cqmI+i76TtUtV3eQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61703C11D91AEE479C569FAD0A5AC54B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c44f9856-278d-4f79-e498-08d745f56f4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 22:27:53.5118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/bkyNPJ+tzm6ytbFowlFl6BJTF8eduRCoruiHpDmxe8l7buDw4jTBty6c8DSkTH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3493
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_12:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=735
 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8zMC8xOSAyOjAyIFBNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiBGaXhlczogMTBkMzBl
MzAxNzMyICgibGliYnBmOiBhZGQgZmxhZ3MgdG8gdW1lbSBjb25maWciKQ0KPiBDYzogS2V2aW4g
TGFhdHo8a2V2aW4ubGFhdHpAaW50ZWwuY29tPg0KPiBDYzogQXJuYWxkbyBDYXJ2YWxobyBkZSBN
ZWxvPGFjbWVAcmVkaGF0LmNvbT4NCj4gQ2M6IEFuZHJpaSBOYWtyeWlrbzxhbmRyaWluQGZiLmNv
bT4NCj4gQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbzxhbmRyaWluQGZiLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogWW9uZ2hvbmcgU29uZzx5aHNAZmIuY29tPg0KPiAtLS0NCj4gICB0b29scy9saWIv
YnBmL01ha2VmaWxlICAgICAgICAgIHwgMjcgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQo+
ICAgdG9vbHMvbGliL2JwZi9saWJicGZfaW50ZXJuYWwuaCB8IDE2ICsrKysrKysrKysrKysrKysN
Cj4gICB0b29scy9saWIvYnBmL3hzay5jICAgICAgICAgICAgIHwgIDQgKystLQ0KPiAgIDMgZmls
ZXMgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pDQo+IA0KPiBDaGFu
Z2VMb2c6DQo+ICAgIHY0IC0+IHY1Og0KPiAgICAgICAtIFRoaW5rIHR3aWNlLiBVc2luZyB3ZWFr
IHN5bWJvbCBmb3IgdGhlIGxpYmJwZi5hIEFQSSBmdW5jdGlvbg0KPiAgICAgICAgIHhza191bWVt
X19jcmVhdGUoKSBpcyBub3QgcmlnaHQuIExldCB1cyBtYWtlIGl0IGFzIGEgbm9uLXdlYWsNCj4g
ICAgICAgICBnbG9iYWwgc3ltYm9sIHNvIHVzZXJzIGNhbm5vdCBhY2NpZGVudGFsbHkgcmVkZWZp
bmUgaXQuDQoNCkFwcGxpZWQuIFRoYW5rcw0K
