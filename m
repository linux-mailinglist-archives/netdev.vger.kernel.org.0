Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C571FEA8
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 07:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfEPFAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 01:00:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfEPFAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 01:00:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4G50Xps020176;
        Wed, 15 May 2019 22:00:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=w4C/hYWS/4TRMwpNT1FCkgCiLEzEtxq1prk0EnEATdU=;
 b=mLs0BPG9AmRvAX2XEC096U1+lshPoXMTh2jTwvRXXQp8Q6VTjA9LDuh/AXcOg68Atp4M
 yI2AJI5tVNzbjQOhaCelSEun/H07gXIdmTobs9iwZXsmhy2lYwvg+9/aqpOi1rxAkjwV
 5ApJLPS+LFTzUTF7wDmN0fRJDIpq7JjAP7g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sgsbq9fcf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 May 2019 22:00:40 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 May 2019 22:00:38 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 May 2019 22:00:38 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 15 May 2019 22:00:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4C/hYWS/4TRMwpNT1FCkgCiLEzEtxq1prk0EnEATdU=;
 b=QpdImaaap1ybd4+zVg3mpHa18z7e6trXQsB0jkEC99JqPhg3QcKM8JdHzOQGN3JVij41i5drEUnBeSrAp2lZahNPa8XJPIlx1phtF7FhOVYB/5b8O1N2t7EExMQ/6VO0t1Lnd/jyHZh0i8jHFEKB5DO4uXtEBIgyOBGA1o9SomY=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1229.namprd15.prod.outlook.com (10.175.2.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 05:00:35 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Thu, 16 May 2019
 05:00:35 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] ipv6: prevent possible fib6 leaks
Thread-Topic: [PATCH net] ipv6: prevent possible fib6 leaks
Thread-Index: AQHVC5C00MHBTNJzik2Hsh/7p94E76ZtMXIA
Date:   Thu, 16 May 2019 05:00:35 +0000
Message-ID: <20190516050032.ef7cfcjjgwjvm4nv@kafai-mbp>
References: <20190516023952.28943-1-edumazet@google.com>
In-Reply-To: <20190516023952.28943-1-edumazet@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:104:5::32) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d272]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6993381-a17a-4e02-4980-08d6d9bb6e62
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1229;
x-ms-traffictypediagnostic: MWHPR15MB1229:
x-microsoft-antispam-prvs: <MWHPR15MB12291FE9895D910265BCE4A9D50A0@MWHPR15MB1229.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(366004)(39860400002)(346002)(396003)(376002)(43544003)(189003)(199004)(86362001)(316002)(186003)(6246003)(46003)(4326008)(8936002)(386003)(66946007)(476003)(6506007)(486006)(6486002)(66476007)(54906003)(102836004)(52116002)(99286004)(76176011)(66556008)(446003)(5660300002)(53936002)(11346002)(4744005)(1076003)(73956011)(68736007)(64756008)(66446008)(14444005)(256004)(6436002)(229853002)(6512007)(9686003)(14454004)(2906002)(6116002)(6916009)(81166006)(81156014)(71190400001)(71200400001)(33716001)(8676002)(25786009)(305945005)(7736002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1229;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CXkAbaE/tk4onsfqfFhUt35GB5P+V0Dl1/lYVkftSfXjLMkTxlHbuh9ruMyursfTSkK5sypJ1VbJG6e7upUPaUG7+2K6+6+8KqnmDavU400KIe7UMPbCFEZ2FEtZPnZrVPiDYYpOPB9PEa5wPdulwKUIY7d0sdwDopKq00sQUU0BbCi76LZQv/fbljnvwE4ldX/6FcZCeH+FRhcOXK9ZbCzvbt6iIPAsaQjmsVGdUz2Pj4vK8zugexbPiML6eZQWOV/DfUyrdW4q1TZOvWwMgpziY1MnkAxW5h7H0Wx/zrzcyNV9thpP/VohuZNtcjSVa3GpPWEKhgWKzLTKtiWsSwS3S4fU9sUvGqSwdRVviqdcKnVmN/AXy0Sj2fLGEiefsmkbHq10bh69txexPcQj32ULgafk1vfjEcQ2k8MKnqM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9A70AE99733C0D409A7FE3BF58C095A3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6993381-a17a-4e02-4980-08d6d9bb6e62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 05:00:35.8144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1229
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=624 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 07:39:52PM -0700, Eric Dumazet wrote:
> At ipv6 route dismantle, fib6_drop_pcpu_from() is responsible
> for finding all percpu routes and set their ->from pointer
> to NULL, so that fib6_ref can reach its expected value (1).
>=20
> The problem right now is that other cpus can still catch the
> route being deleted, since there is no rcu grace period
> between the route deletion and call to fib6_drop_pcpu_from()
>=20
> This can leak the fib6 and associated resources, since no
> notifier will take care of removing the last reference(s).
>=20
> I decided to add another boolean (fib6_destroying) instead
> of reusing/renaming exception_bucket_flushed to ease stable backports,
> and properly document the memory barriers used to implement this fix.
>=20
> This patch has been co-developped with Wei Wang.
Nice fix!

Acked-by: Martin KaFai Lau <kafai@fb.com>
