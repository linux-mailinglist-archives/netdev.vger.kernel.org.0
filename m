Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4062CEA82F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfJaAWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:22:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727179AbfJaAWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:22:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9V0DnDA027170;
        Wed, 30 Oct 2019 17:22:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xodGfYnFmxOWG/VWclkSs5Un08lfgHF2M7KiLTpbgCc=;
 b=IYfyZ0avyq76ZOabgoQcxqioeXrzhd4ElZDna/6KBfsI4zqk29VC2JeT/kqwLrd1ln6T
 d7/5WLEnDSvR6Y9Yab4OY1uXQcRDqEf+LU5KBSumUNA+o6TI8koc3s2vrW6YxqGDgndp
 LtlcZj90XdiEnYmbaXrEdmVxvpB6xFcImuc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vybreb3x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Oct 2019 17:22:10 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 30 Oct 2019 17:22:09 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 30 Oct 2019 17:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjrhVhQoZRzpo5GGs1B2H9bYh5m9M+C+DwD07Cr2WyjRaMzKaJ0QQcAPi/EtUOF/jDaJW1clAqoiCNZcWNL/5T0WkdHsq+sr0i2UgnCREU1Qw+tTa0vULFbmLqOBhUphHAEm4CcatUf1WH/UYQ0h6HVtCsA39SZD708f3J2x8hQ3Oqs1Cd2GVFKKQ65ZFeKJg1mBQJrz1nKHNN+G45VfS6mh2OmHmCAfw94cHllvYi7yXC0FHn9eEu4WIATMgJOGxukyCh+nJ0eTxmXQwIOg+kUC0PRTS4AMMKLPTXIwnkaZck7l5lj5QuMv+pcZ9H9pscwngmJcSlSCbFabiM3SEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xodGfYnFmxOWG/VWclkSs5Un08lfgHF2M7KiLTpbgCc=;
 b=kRSlrGxX84SihRaIi+9unQf46U+LVJZSjffdxXZcUy/LGUCM36dMieEb6va3ihn78Xt1kkN9jC7m4ao8p1Uy355SmuveoItpLVRXDmU0jPF/K9qdlGPnlV2eRRdngRI5HlSypnzaQrmF+wJjmd2shBAMaW4wEzooj6JQS2ufr7vBHrDu9iptV54QENAkZcil5+E0bwSQwCui3JqxrQARQ6pOkzi0kMWRC1WaTAIORLZXNKW/yDnpRKjFwveK4AADJNnNWM6Ga9LffEvgVWtgAKUBXTDr2+yR6TrdKaCJ4KoyC9oYolxPwcg+nbYk0j0eG/H59YI4scMWD/q70II3tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xodGfYnFmxOWG/VWclkSs5Un08lfgHF2M7KiLTpbgCc=;
 b=YApWq8kMHyITeV+uNNrEJYxNjP9kOlZFOhpKX2OwAKpNkgyN/vdGRI3+HbZCujvNfXL2XH/1OMtfi1g3dTGDfTnJNIfDve6WPrOjAjoVxGbDaA2+yHjxHHC9qUfhrf6nzA/sRTomMvIJV+3FKzgdT46qv0u0Oe855Mkl1zBIiSM=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3390.namprd15.prod.outlook.com (20.179.21.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.18; Thu, 31 Oct 2019 00:22:07 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2387.028; Thu, 31 Oct 2019
 00:22:07 +0000
From:   Martin Lau <kafai@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/2] libbpf: add support for prog_tracing
Thread-Topic: [PATCH v2 bpf-next 2/2] libbpf: add support for prog_tracing
Thread-Index: AQHVj3Ht8GljvPl7N061laGGPs8F6adz44oA
Date:   Thu, 31 Oct 2019 00:22:07 +0000
Message-ID: <20191031002202.7bb4rt2jeigsatc6@kafai-mbp>
References: <20191030223212.953010-1-ast@kernel.org>
 <20191030223212.953010-3-ast@kernel.org>
In-Reply-To: <20191030223212.953010-3-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:300:6c::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::93dd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb1ac96e-a543-47a1-2e12-08d75d985cc6
x-ms-traffictypediagnostic: MN2PR15MB3390:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB339073B449C4BCE0A8A620F7D5630@MN2PR15MB3390.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(346002)(396003)(39860400002)(366004)(136003)(199004)(189003)(71190400001)(256004)(71200400001)(2906002)(4326008)(316002)(5024004)(25786009)(8936002)(33716001)(8676002)(81156014)(6116002)(81166006)(66946007)(66446008)(64756008)(66556008)(66476007)(14454004)(54906003)(11346002)(478600001)(52116002)(486006)(1076003)(476003)(6246003)(229853002)(6486002)(558084003)(186003)(6436002)(9686003)(6512007)(386003)(6506007)(446003)(305945005)(5660300002)(6916009)(99286004)(7736002)(86362001)(102836004)(46003)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3390;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lV5YkxPCaDkByPRok6Y3UuZgRp2f6y0gvtyJ/d5TR5Oi3gGCYy7pS+SMv1pEofLrSHe9Cj1PgAW6ddRdkS4OZgkXbbPfVM54153d3KhG79b69iPZO6iwLhrQGtR4Eg330JsJ6XSbwbAwtSLTIaI+Uzdjjr53MtBInI5g1e4+Bk8Lr6/WGbgHophPg6fdsP3LXyp99x5iSVJ7At+0SP15j9FNHEUHBeS+O8X9xQIgX5rxtlGAhlMm3h2BJxk12/iM0kY1YTxNWxEm3pYVUhGI/8U1Tx5yB3nDmOtiv6WMTOyBkxVfxGI3DwRFlNkaLlL4sQuIjwiM+rgjjoGE3olc4NHaYo6R4DpeQDz38ozrwVFjJUc078ZOhGsIBUOlvcYUBY2foWy11qPVv9fRwtf1hq2a1eyZh7o2qXEnXabXNAje4ze2FIJbwdtnKfM2KbIb
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3D2F6D81433E44EA906F72E155DB2CE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1ac96e-a543-47a1-2e12-08d75d985cc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 00:22:07.0417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +d/+JfrOtFSurRI3H3KE/4K2JFDOHnyGRU4MBGX19bIsvm2/ipHtM2DFyw6+SvEG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3390
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_10:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=655
 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910300218
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:32:12PM -0700, Alexei Starovoitov wrote:
> Cleanup libbpf from expected_attach_type =3D=3D attach_btf_id hack
> and introduce BPF_PROG_TYPE_TRACING.
Acked-by: Martin KaFai Lau <kafai@fb.com>
