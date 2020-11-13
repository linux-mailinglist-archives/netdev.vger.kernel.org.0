Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107652B2389
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKMSR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:17:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbgKMSRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:17:55 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADIAPTn010417;
        Fri, 13 Nov 2020 10:17:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=B7H+42a7aRyzVZtYtkdGC5TVQBLAuHzG+3+h66Mb0Iw=;
 b=KJvynGnMZhiZVGRHz46M+qZOXmlniuzM+dCtYb7Kd6S8f9rJiFlfaugDLqAH7d4kv5ui
 OynvH9d5hiIWseN/Z2ML7gyc+3nbs8+oB1p+6kXvtd7JsJq+iHGfwMRMlCepVaq+Zccs
 RdLQUBEli2FS4G0gtCo94QbJS9B/J9i1HuA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34seqn4f9m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 10:17:38 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 10:17:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/PKKe8zEy3lI44/lw9J3D0PfQ020VmOftgWZxSz0Icc9UJtuDqP6oErv+kHCX78HMnSo7+R8rLBPNVbS+GV/0zaxLMSaEs+mMVyg9px2BMYu3Okc22CGe1EkC3D9K5SL/ltL8nYHXKjtaML71BVGvXISsi33BiPhRnrOVEo53ZOEt53+7v/DQc/24sL/g2vPqwX841sQ7zIHgMMVwYlm0EAgJJHvEm8sYm2Ym16uSnzwH9gFmF/FD6UlJJ71b/pOQT/e2FpWlXBExc/VJUCwCPUFTZRNHLFIbfJWo9uJihKBcTxudUrnSd5PI6ESL36O4fPBy/WtXsdVptEYytKsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7H+42a7aRyzVZtYtkdGC5TVQBLAuHzG+3+h66Mb0Iw=;
 b=HwTr/8kGifqvmXicIehcsXDf9xOxuNgd8p+uEdEmsqkzJ9Q6+3UPZM3WzN4mqAAxhU3CBcLuK1UQBmvQ53mx6cTC2HRWd0RMDBgStES8g+uxxW9uJSAH+TACavd0IhKlOkCtURlz8IQdb9BgaY0B/eAtDopW53PK6J3KlPdV9VI1hgkI1ZPGPRHEu3FAacSyOuqGWyt8OErpOpooqYX1l8/xNpxLBPoGSRWzBdsJX7yLEON0mjjTKL7VinJe9ifFnewUPQ+psekt16JGUG2BK9+RWGLISS2gMV8HDyQl+3wK6o6Qtp2dr5/Xg11ngypr+L+ktUdAjSPq2mjQcQ/JSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7H+42a7aRyzVZtYtkdGC5TVQBLAuHzG+3+h66Mb0Iw=;
 b=G3iy0uEAUzFDlyvNC2ZVnGDSCVvLgxMWyB6rv8AXXYq0gDaPXN1oljLzo7HizhIPioLVID48zfYDhABXrmbFNz/v4PPHaHkDn9qmoLRJAlRpyau54WAaadCNPOpGzB2/Dko7CyC6NPd2N86nx5RBv7TSRazf0hXjmUoejTrIt7E=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 18:17:33 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 18:17:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Linux MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 32/34] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Thread-Topic: [PATCH bpf-next v5 32/34] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Thread-Index: AQHWuUGKwFc8iMwj5kmXv8I1XCn24KnGX/4A
Date:   Fri, 13 Nov 2020 18:17:33 +0000
Message-ID: <C9A6EFC4-A2B9-4CA2-9BC8-6A5A4A3C6E57@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-33-guro@fb.com>
In-Reply-To: <20201112221543.3621014-33-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 170e3867-78cb-408d-4174-08d88800646f
x-ms-traffictypediagnostic: BY5PR15MB3617:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB36171A11B6C7374DF8C83E9AB3E60@BY5PR15MB3617.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zH1MTHcssgemUOCW1xhB1W46pAO/1t9XMFVQeLjI33Q4wL1Vew3PPFxv5S/CQL0IISNIyG2EFo6RhjhUrguxwdUrfwrlfMduqoKJxSL+9+ZtmqZcm5bYfEEKQGTSc4DH6EQlRiTO/8CYI52O0+m7CmGW0b25N5vAp7tyRMrjDSTdkZ2zwPiCBgBfeKr/v6oVJYSFRaMIEoi+sMK0c3/OYuDMDdnjTEb2lyl8QF3qzIR+MifYLwJMYWMm59E8az7PrzrsDqQl+ZXjl859pWEPvH5CGNqfqx6vt4x6ieUnIlGpRzd/iepZO/h3bEAQa/eN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(54906003)(5660300002)(4326008)(86362001)(6636002)(83380400001)(33656002)(316002)(478600001)(6486002)(37006003)(76116006)(2906002)(2616005)(186003)(6506007)(6512007)(8676002)(53546011)(8936002)(66556008)(66476007)(36756003)(64756008)(66446008)(66946007)(15650500001)(558084003)(71200400001)(91956017)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NJCbtGBeYGEQt2LeVHsTmrjB7/OCbNtcnj9O0gPiS9YQYzYKp2jQXEI8T34b4tjN/xA9R45cuUOA2D0IrbHz1xQKE6clALC83HPRgld0k9zQUhRN0T9ftXAIflokCD9Ro5MHXY+VynJHwlzm4I8OIjLUre7Vwm+daxCwbWhJJ2KVsDDbecbCBholQsrMHw5fKeBAORun1e9wPIvBZGVsZCuV7GLLWMi8k3UFWJZlEKlOQ5hZpZL7ArKfG5DRU3cSIhfKypFbhg54VSe92lpNAYB18ShStE0YfaTzhGAwxMBLK51Vx/RZsXYjlL1ljluUp9IfeW9uPVOdz+5KT0goF+ECU7KGm1e18/KLsE5w+mBi4bZ8k9lWbAr2A5vYVW9j5TkmUY1RVNlYqeCQmrK24tpNOMaW5SqLEdTMcUGi9F+XXiVUi6ZBKqIiZGvCz5muFzwmqojUsj2XpHTi87E+/bUXyBoYolzeNUTr1j9jsKuZ50e9IsIslZ0NFwc5nhB5m1PVvZKT5fCnLSBD6B7PlAv+2Q+lOyJ+8064n1BchN99UTvCQ7oCXf2GOi90NDibgUDyNFGXehCLTnzuOredekL+km5MtdXgdBYPKa8EipZbHDDH4aQM/2a1nQs/18svKY8cu7+V05CVwf/LNN+vogNgVCpQEUJujUiA9REwiCsUeQBjhyprKQMy5Llvtd9WsiLRbNr9zyk9Hr8XBGecBLsY0e9S8LEzlArOgu+4DcuyGkXvUSK2wWhsNKXkTAT1iGK1nn0tDj/IyH9fE/+4ntdM8lsepw1hFFSvz2GQBoufWDbiXu+SFuEECf6+wlF6htV1uqPsCh8TsfChRl46QsLQIxYxWE4lVZrfpsyMhsVg/HxXPqM2C7230KPQioA4GZuwDU4ZC2/YmY80ai495LH+KYKnLiBKYHnTpWYR/gI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3AA19D219825504180735509316416E1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 170e3867-78cb-408d-4174-08d88800646f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 18:17:33.7926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4t9nV6ySsfZhnDrGON0d/8IR5kttLnXf9IalFY9vqV9OYSxUDqqz9R3S8XTxqcEeZogk6KFJM/7M6QCUJ5hQ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=737
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 adultscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011130118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Remove rlimit-based accounting infrastructure code, which is not used
> anymore.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
