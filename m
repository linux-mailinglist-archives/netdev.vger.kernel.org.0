Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2461238A9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfLQV2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:28:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5004 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfLQV2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:28:01 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHLMEba017847;
        Tue, 17 Dec 2019 13:27:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AXLOFBeFGrpk0ZJGFk/KETXQhAjnUUbPU6UuNRkOwts=;
 b=Fq/9oQeqJeu10/MutyH5vMM4N7gSsKS1EDxHsUsxM6uw3skqEOpo91juzxzek4qxYBjk
 mopPP+vVYOTXRzeKFUYHZwkoM+UfwIf7IX7TQaKNo3ec7CBuhpOqcEb8UlQZHW5bErPj
 BroIMaDsjq3GR8RGCw9M8h80894e9+BsYrQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxuptkab7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 13:27:49 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 13:27:48 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 13:27:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 13:27:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsZGQmX+1T1IgkGNPt7Stpo9gEO1zH79abnLfe4JMSeTyM4dZOavQYwnfkqITT4pdmj7FImyhzhdV6A31xtK0RmmPSzwYPDOxtFuMI0UTJ9U0np0HG5g1iHnEeBlFpftB9wxsI8wsanUgGiFdQpuNJQb25FCrlaO9621+xd7XbqotijOzB7bxg0jwT7K7ApAe9KAWYTDfXluNewJZN/+KQWMsv5OrhQtQ/UVvr/n3UdEqewd0MopOQ+nDCumH5wO95ecwktwpsWtpTest/WP+cTfWYNwyT6yh8EZBgWjcW7Olp0//B+QdIPkkac7lq0YDKgqJu3xPW+DLY++p4dobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXLOFBeFGrpk0ZJGFk/KETXQhAjnUUbPU6UuNRkOwts=;
 b=fXb6swsYkqrNDHY0tM4JGmlQ8Gb9DZSUBTBBxIBtEQjfMeY4NtIZ/6MzxtOOllDHFpOLrDIIC8bE2QGDLkUhvhap5rUWcA6P5C2hyA6PASjDV74nfsdXMHarwouEz2XN20o+lqcV4Rq3mqxKHwdz2GMhUL/MEDbuDvT0MhGPtHF5W5V6qyEXq2pNKALQM/Tp18i+iBmFdCdr4Whba6QnKip5eFmFksnW/b9KzQ1dipzzQ92BYm2cjIlJ5qXKv02mZkg1bD4htHwteWWzxC9f2uQbNQU5+Fy506F5G+dCubV+SPeuKu5h2vZ4qi9RMYFkIHe1H4bnrPalbIZ+Tt2rcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXLOFBeFGrpk0ZJGFk/KETXQhAjnUUbPU6UuNRkOwts=;
 b=NEiAbrdAfXFAjbrlbb2gkf9lvUgMXL/s+CqMoWdHD/tSlmKo9BMuTyxwmdrK7wRqBQYfpJ83EHnNQQuoTJMR1ede6+0yknH3wxsc0i8YA+2xuqBXhtUxf5GF5VM4KsXJJGA2r8Sln9UM7kJd0cRrGzQe3fVQRYjVKujEYibyBH4=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1482.namprd15.prod.outlook.com (10.173.223.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Tue, 17 Dec 2019 21:27:47 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 21:27:47 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] bpftool: add gen subcommand manpage
Thread-Topic: [PATCH bpf-next 3/3] bpftool: add gen subcommand manpage
Thread-Index: AQHVtJv3Vlj79qROakKRwYoNA6qQFae+2GsA
Date:   Tue, 17 Dec 2019 21:27:46 +0000
Message-ID: <a722caf8-a4af-4476-d560-396dd30dfb0a@fb.com>
References: <20191217053626.2158870-1-andriin@fb.com>
 <20191217053626.2158870-4-andriin@fb.com>
In-Reply-To: <20191217053626.2158870-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0041.namprd21.prod.outlook.com
 (2603:10b6:300:129::27) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:406]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a88c818c-d474-4931-b1cc-08d78337f5c8
x-ms-traffictypediagnostic: DM5PR15MB1482:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB14826E94DC26A24924BBB4B3D3500@DM5PR15MB1482.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(136003)(39860400002)(189003)(199004)(6486002)(54906003)(6506007)(6512007)(66446008)(53546011)(86362001)(66476007)(64756008)(66946007)(5660300002)(4744005)(31686004)(2616005)(36756003)(52116002)(31696002)(316002)(4326008)(8936002)(186003)(66556008)(81166006)(110136005)(81156014)(71200400001)(478600001)(2906002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1482;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zm0Q++dOPdKooiVdvVZWPoVdbqVbtAPX2qJI00iMkBg9knK3pZXP3KxMu13TqPv5FCzB6oklxOJHh4gMUise/yUJmZkG1gR4WkSfA1VouuzFKvYkr0fgSQUXHThIh52M07f5UMpGmLzn6snuGUfZ1x6zqoSczG4FM+I9a7lC+KqwIuscGoIEN/h1XwIPISWg6olVKTKzIOgiqesBAKDx/6TRynBVYRZBMp/+t0oL1t+qTlrRBlK9owwuprWEe1u5Ze+4dK62QVKOFJ4asB1yrgLvMZzP9rp7zpOIA2+BKrsILpL0Xg6bLoGA+pTRzNkXxDLJOwRwGxY2TePhWAKQf9SKXgP4FN/xycWpb9lgWemfJlq1po3g88cgCgfCKB5QXG44GPuZT2mLoQq5x3PnzDGgBWTKQpGs8kpeO05BFQJvGhApT2hDH1TzKk8ikfqs
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0D92E669F95764CB17CB88DFAFAB21B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a88c818c-d474-4931-b1cc-08d78337f5c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 21:27:46.8324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iWUhrFpiWqznny7kRD9iHFJjH6gFHV19OfGRAr7fyd7ggf8udgPTZk+hEWSoscBO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1482
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=876 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDk6MzYgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gQWRkIGJw
ZnRvb2wtZ2VuLnJzdCBkZXNjcmliaW5nIHNrZWxldG9uIG9uIHRoZSBoaWdoIGxldmVsLiBBbHNv
IGluY2x1ZGUNCj4gYSBzbWFsbCwgYnV0IGNvbXBsZXRlLCBleGFtcGxlIEJQRiBhcHAgKEJQRiBz
aWRlLCB1c2Vyc3BhY2Ugc2lkZSwgZ2VuZXJhdGVkDQo+IHNrZWxldG9uKSBpbiBleGFtcGxlIHNl
Y3Rpb24gdG8gZGVtb25zdHJhdGUgc2tlbGV0b24gQVBJIGFuZCBpdHMgdXNhZ2UuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KDQpXaGVuIGFw
cGx5aW5nIHRoZSBwYXRjaCBsb2NhbGx5IChnaXQgYXBwbHkgPD4pLCBJIHNlZSBiZWxvdzoNCi1i
YXNoLTQuNCQgZ2l0IGFwcGx5IH4vcDMudHh0DQovaG9tZS95aHMvcDMudHh0OjE4MzogdHJhaWxp
bmcgd2hpdGVzcGFjZS4NCg0KL2hvbWUveWhzL3AzLnR4dDoxODc6IHRyYWlsaW5nIHdoaXRlc3Bh
Y2UuDQoNCi9ob21lL3locy9wMy50eHQ6MTg5OiBzcGFjZSBiZWZvcmUgdGFiIGluIGluZGVudC4N
CiAgICAgICAgIF9fdWludCh0eXBlLCBCUEZfTUFQX1RZUEVfSEFTSCk7DQovaG9tZS95aHMvcDMu
dHh0OjE5MDogc3BhY2UgYmVmb3JlIHRhYiBpbiBpbmRlbnQuDQogICAgICAgICBfX3VpbnQobWF4
X2VudHJpZXMsIDEyOCk7DQovaG9tZS95aHMvcDMudHh0OjE5MTogc3BhY2UgYmVmb3JlIHRhYiBp
biBpbmRlbnQuDQogICAgICAgICBfX3R5cGUoa2V5LCBpbnQpOw0Kd2FybmluZzogc3F1ZWxjaGVk
IDc3IHdoaXRlc3BhY2UgZXJyb3JzDQp3YXJuaW5nOiA4MiBsaW5lcyBhZGQgd2hpdGVzcGFjZSBl
cnJvcnMuDQotYmFzaC00LjQkDQoNCnNwYWNlIGJlZm9yZSB0YWIgbWlnaHQgYmUgZmluZSBzaW5j
ZSBpdCBpcyBhbiBjb2RlIGluIHRoZSBleGFtcGxlIGZpbGUuDQpCdXQgdGFpbGluZyB3aGl0ZXNw
YWNlcyBwcm9iYWJseSBzaG91bGQgYmUgZml4ZWQuDQoNCldpdGggdGhlIGFib3ZlIGluIG1pbmQs
DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
