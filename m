Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727DDD3185
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfJJTmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:42:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfJJTmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:42:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9AJebkZ031114;
        Thu, 10 Oct 2019 12:42:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/Yg7GM0zYVa0fjKU/4Q7wMms7/VzfJoblLu8eRXIo8k=;
 b=OQI1GElW9rzfGtXifXPUa14ig1SaKAcMOrEG3/xdyU3s2fxw0FICBgivBqDJB8TNkfTI
 uZlOUUBSbZ0IyhKpunvwGPpFNwTlrHJtBhNLeZ3heqkGY6bE9q9dGYjHhB9p0zRdHkXB
 EZjpCTvkbFia1MKphGk9jtdYXjUNxCnfzKY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vj65ea1cp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Oct 2019 12:42:42 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Oct 2019 12:42:07 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 12:42:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOLWYXaGYxu59brhQuMgNgt1XpnZZF885x0w9jtFQdK0sEcgPs+aZmoOBD4ymc+f6TM0PRjMCbndzpZeCDvG9MhFioq1O5zZn+9uHPApS/gZH1qw/QwoYJ+NT+XeQu7U2Uqkv8RS/ybHTnDyeBThjN5Z1xmpsJV/3vgTRJnpR5p8G1gm4AGlxRiFEM32tBbXnveWhwjPwmLhruPzqlbPg7WR7Y8NAIDw5CIw0sSfPJ9mJ5nXN0Eg3D1/hbli2AJG/1WukaBtbbbi5u1iI9FEYOqqaIslPFnJWrvAV+Th8GEvY5x11ikghjFZx1nUQZ+LVXBlLwV6OB+qBVuUY5ollw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Yg7GM0zYVa0fjKU/4Q7wMms7/VzfJoblLu8eRXIo8k=;
 b=GG1H1y1VetzosSgLeyUpJzFEVu5QSPQ/+hkTf+lxzkepnCuL/vtD33GbIcrpZJ8cK1ZlEMV8PYF8FC2xwMNaWEXs8GLAPcW1WcjaSQuF2qdt/A2axJKf8ZKQVmQI4NXAFXRMlLPRJy/V6MI2TjDOi2SSfDliyZUlJcIdavJb5iKtzasIdCVEB+zikBAG6orqJdV0UqmXd34uHFZXMWGLCZvlg0Cejzdig1KCpo2wUn+cfCsVWGbBRi1fa15HMBsOlOCm0qf2Cmf+2IuAoXn636I7vZipYbxakjdsbyh3UjdMgFW2k5uiUB5SEAthTxBrXvW5mqhiNtzl/4YS1HaKZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Yg7GM0zYVa0fjKU/4Q7wMms7/VzfJoblLu8eRXIo8k=;
 b=Mv/jW5ie/a59cWgBQUG7uC2s5pBWFBGfAsZiJLc285V5VIa+3Vs7ECYEs0VMFK+GAC4Wv52kEVtzIUCuNSMDhvNCoxYqHlQZFWolRUll7AOxz8BtxYgdN1kD84uxIY/oJNIE1kzyeAIw6Q5UsmzXX5s/iu0GRX7yYw8FHb/eco4=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3389.namprd15.prod.outlook.com (20.179.21.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 19:42:07 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 19:42:07 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: Check that flow dissector
 can be re-attached
Thread-Topic: [PATCH bpf-next v2 2/2] selftests/bpf: Check that flow dissector
 can be re-attached
Thread-Index: AQHVf5cYwsW6UYhmA0+mhSKk5kW8RadURmaA
Date:   Thu, 10 Oct 2019 19:42:06 +0000
Message-ID: <20191010194203.d7t7fudexe2v3bib@kafai-mbp.dhcp.thefacebook.com>
References: <20191010181750.5964-1-jakub@cloudflare.com>
 <20191010181750.5964-3-jakub@cloudflare.com>
In-Reply-To: <20191010181750.5964-3-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:301:4c::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::f49f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e59d0a9d-0961-483b-3746-08d74db9eed4
x-ms-traffictypediagnostic: MN2PR15MB3389:
x-microsoft-antispam-prvs: <MN2PR15MB3389ACE57636D351ACF40940D5940@MN2PR15MB3389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(136003)(39860400002)(189003)(199004)(14454004)(66946007)(478600001)(64756008)(66446008)(5024004)(256004)(66476007)(66556008)(6116002)(186003)(446003)(46003)(11346002)(229853002)(81166006)(8936002)(8676002)(71190400001)(86362001)(71200400001)(81156014)(486006)(476003)(7736002)(6916009)(1076003)(4326008)(52116002)(25786009)(6506007)(386003)(102836004)(6486002)(99286004)(6436002)(558084003)(2906002)(5660300002)(6246003)(76176011)(9686003)(316002)(305945005)(54906003)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3389;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fitbfte+rkvAV41N0KU6BTXn3YVh6t9gfAbEYKxaKG0mito6I/vOYiiZZKVcy85dKUSber2DQpHFoSXYUhR7f9JvrHF1/cjhIViIDz16lExnNHGXL4oPvWiAVzbwEeJ8S2hL6YR0WeZgpMY+/7j7Fa/fkn58Idn+LFxR3fWy3HaIbpKzDebwgk06atNnHaAowpwn/LUmgiA+VBi7dLmchS3HamqE6XfpEjMRdreGHEiV1q6O0sVS589E/tcpPzY2kXv9t8kz5QlbCG+akBKy/yT1LzzAviqRRLSz93qRkmHwwnJILTisQLWRCH3ObAhqMppkqdtLeBGye1Q1E/zYPRF1UqhsSW9569FQajZvS6GlIE1i7lKMRCluWxlccZOZDuhYSW3K+9cDUET6NmYVYpYKzlyYSgNqOvbCrmOrOhE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <02AAC40BC164844F9393DC0963AA96A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e59d0a9d-0961-483b-3746-08d74db9eed4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 19:42:06.9626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4x0epjq+L0XZrPghp1kDNY9ypY0WfvBnpyEl/K302mIjISFp8SMgW0Nxcnbn7naC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_06:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=484 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:17:50PM +0200, Jakub Sitnicki wrote:
> Make sure a new flow dissector program can be attached to replace the old
> one with a single syscall. Also check that attaching the same program twi=
ce
> is prohibited.
>=20
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
