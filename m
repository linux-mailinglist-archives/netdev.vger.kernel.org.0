Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF782B9FE0
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKTBkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:40:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26300 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbgKTBkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:40:00 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1Zbpt006281;
        Thu, 19 Nov 2020 17:39:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sW5ZUy6bkJO4UJ8WK8faZE5z0sRSOiA2hPtWUD7m1yg=;
 b=D1oz3VA8HFQCmwIJc880ONhkTBWPBjpP9bhK/f2YNKmnHfv1tRbvJi54cNIQhcXJfqW8
 7G3dEQUWCnqEYOOZVAAkso9UPe1BpKYZsqOvgLwm7PQAQhr75wqgfLhD8tP1mMiED0vA
 1qspz1zpC3oW2A4RYyQB3l15ai7tUWuC3uU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34wsge450c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:39:46 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:39:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzIQ/rAmuDiCAU6hi1TRZ4J4RCRzHPoQqcB+PWyTpy9tjyCzG7aPi6kxTBtxJiZQEEW1/zbngHpWXMkoblIVmXnS3iZoK3IT3llo2+MdALu5rf0RlRxQUlNx2CWbH5yKlsbMONtZJ2TahvFVT97DJWFMst5mlc45mMUyL9RBAU86WtBtndplLdvd82/Ulg9/04/5N37idxb8U1HgXf2R8bAasgyaPkRtVoqjYpGb3uqzpIY0P1NKw8Zb1xFNL7fMRyphgVry4D0u4Kp2/EKTpWUaunbeA86peVo864Sr4Rrs/8ysKmxHWxgYHqfUIvd6u2Vi1nuABC1WD0vGem7JDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW5ZUy6bkJO4UJ8WK8faZE5z0sRSOiA2hPtWUD7m1yg=;
 b=DsPp5apJnVhz9fibMasCJrDEcq9HM9b9erUqJrn7o+oI0HPpMMqFQTK+gJpsGvVRr+5PTjqsbVcRXEulwh6RCy1vpG4CuRExE0gMTtSnwkjH9KFv/eJa5OlgFd5Rwv30VVHNGMBM8oqR7SLni1PKWUyhLG65THW+744TJ6tN3NnnNIXmaxOJIcJoz9daFZgi6SLGC9QBALqgvjgo+wYw/zAChZcifPgqe+pbliDdLCQSBL2oUupX793WI8i60KP7F4NZGSrRjyiKnaLM4Adqe3PNvZGqhFqJbDGr2/7etJQ/luberDoy8LzNTaWII9aooSfcEcsrQRG/aEYuDPQWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW5ZUy6bkJO4UJ8WK8faZE5z0sRSOiA2hPtWUD7m1yg=;
 b=FXAULuZYSlyUetKGAb85QaYNJuQ6l3MwWA3VREPMDNDrVTVN/XvUN2eXaVA+1PLYN3gVKjxshHPdDkq3FGe/w24nAucOkwHS2xS+jkbXAAngMOAf2NPIAqqdsSVLHpZ78+s9TyxhVy2uJEOskVSt/8DEadLl9DTHkYSK2t41RRE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3715.namprd15.prod.outlook.com (2603:10b6:a03:1fe::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Fri, 20 Nov
 2020 01:39:40 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:39:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 13/34] bpf: memcg-based memory accounting for
 lpm_trie maps
Thread-Topic: [PATCH bpf-next v7 13/34] bpf: memcg-based memory accounting for
 lpm_trie maps
Thread-Index: AQHWvprPoinFKSzMFU6xkEi7OcYjQ6nQPs+A
Date:   Fri, 20 Nov 2020 01:39:40 +0000
Message-ID: <11A07AD0-F6E8-4E56-BEBF-6E750BE3F597@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-14-guro@fb.com>
In-Reply-To: <20201119173754.4125257-14-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 506f77f8-4068-4858-ce81-08d88cf525c8
x-ms-traffictypediagnostic: BY5PR15MB3715:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB371590CED98173E10594B7D5B3FF0@BY5PR15MB3715.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yT9MUxiJ546Vb5VE7z/ob2t+eR/PBS4B/vvb2eM4pJ8jmohVrZzo/cE95rNMQO2iAINrZEKdS2vro9Vnm2t7LJbsSc/Ff70HmMvSqSSN7l6WZ3HwE6s2leFwgTwBinF8MngSwtC1hdpIFz/q4Cwba4rpd9kOfKKfdMUufi54daxx0AhO3oZIOkljbo1Be4qgXQGUTwEUv1SyDrjzqPigmGXKz2TtGA9oXDw3pS1wx+8lNQFA4awXXZrYVzy+8iiCuIEl4UsMgvp3QoNCpSDvlvJlkMMucwQoukSkNYpD53AmgbL+MqokPXojlHAIvPasBadaI3GMtFpVSurISUZu1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39860400002)(366004)(376002)(478600001)(6512007)(2906002)(316002)(91956017)(54906003)(64756008)(33656002)(76116006)(558084003)(6636002)(15650500001)(66476007)(6506007)(37006003)(66946007)(71200400001)(6486002)(8676002)(5660300002)(53546011)(2616005)(86362001)(66556008)(83380400001)(6862004)(66446008)(36756003)(8936002)(186003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gbpwhW0FCEozM2a5SfB6697X9ubmZq6NW4XN94QIIP1J/xRPtUmQ3U/a3iHbGPlBE7qRsHPx3e8st9WKql8ptXnCRSw1ADP8gKV5+fD/h0QIQn5AdXOXjNmL3KxUmr693jkY82e9+bfZWSff5UR5gdzqTn/n/rM/0IP9dzRZ7+kh3JogYiY/RYiE0RqM0MrSKW0E4e2JcOVxvCkXE0wgcsoMdAmzQsfaV3H9RGkgiLHxnzpMYS+vNUr6Mxx3P3ZVoooq+WtbUGU5il9uvoxaLaItI1Phh1ZK7RmVVP743xS4I/aRgkuRZ3/sTmeAkM2eB4yD4QG5YkpCinhK9WTqUhG1bbZ7ztU0Zygv0wGVakuKR2GLETmb2cO37oaZtKTNY3Jrxzl7QK24r1uYTJe7SuyqizilVnZnpfBF236SMtYMMmMDb0YoNHKZUxbHoNWZ9l+nWGOwZX3L5vermpIF8g77WsJrUAQtXVPpXomnBsvh71bzLKkXwWHft/TqZozAOKh3KGVhLOGpdS5na5LiNTz4+N7KOhuA4EjQu0U6VUhCSoU6LydA5TbIcSksB+u8ZTL0UGKft+AXLv7MzkeYY6/BuKnFV8cd3SjUeAuNk/8iJJ5CzzR/9CYOw0mbIMnTpLI3UWzjbs9NNAfP4j6ERXu9Wl32xOoVc+1pOLFdaLDHHzezRBx5AJ9Hq6a7RVwQ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <582583A31BBC9E4EA490FF9EAA108B99@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506f77f8-4068-4858-ce81-08d88cf525c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:39:40.1148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KlwQPR5Bc08RYxfRW6yxNjfuW1Q7SEgVqsveko2WWrSn1bVuTM/MYWTMDeOrcHUxQCYVhhYruR5SWHyM+bfMkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3715
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=727 suspectscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Include lpm trie and lpm trie node objects into the memcg-based memory
> accounting.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


