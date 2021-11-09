Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF5044B74A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344802AbhKIWdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:33:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57726 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344922AbhKIWbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 17:31:03 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9LvjHZ019790;
        Tue, 9 Nov 2021 14:28:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=PQt+PR2GVPJfy9FU+k8wZtZaje7gh1Io18CuQ9fuZHM=;
 b=rh8mG4UvQUxnam6PCMXfCEfTm/+PaAwXu8KuSH5n0NVonDV6LUquPlptXgFb9z8NTg0X
 VNCGUN4zrYtn8onWnbvTf4ML1yrFBX4yok20qF26DMdz0NmrSiQZOtVViu5JoG+PNa1b
 2SEm7ECloBgRp0t664fH8FPR1oGysY2o410= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c7ys2s3aa-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Nov 2021 14:28:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 9 Nov 2021 14:28:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/x7aAvRH/jOLrcIVqmNC9AQJTgMQs8TbPIoCkuoeN6wRfYsRS9QIJ9qXCj3HPyCb4DaDCSt8Tih/HpfkIIMiheup2pSSAtGWKfYUXmF7biVp54jBP+slZrLXAgQWpdouyVH3KVj5+EqQ1KczE6TYr+M2geiB2A1jx9aIEI60mjMesGT53FRkIP73GRIDA2zPg86cDmSB/LFro16HUBiNh09/1jAaGx2mU24jNqZMmSjMWIri/1gtyzdUObQlARAn6041Xc44HsfcwjFmSRB12tHz9qliNDc8rrfZnm+e5BWLPEoeVoVpHKtdDnFtfUQDd9P7JycbGKqdqKfEDhNLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQt+PR2GVPJfy9FU+k8wZtZaje7gh1Io18CuQ9fuZHM=;
 b=TRZg9NSt+IBoagwxs2ysCDYJGm1n7IPwqtZU4reSCpJuF8S2EdKXMa5rzbnRCTdyZts+QvUGWsYFiIf2ADbKICiS+c2ndtN5nQL+sJo8Kj5sTmZ9OJJZjg4mhjRhEFfIVyYjUWSlOfoH1SMSUcq3RajgxhFxz2KNM+EsRzFHdCyMIsg9NnchrCW6w+NxU9i3D9Yaz906McbYQTBF6GXZQ4un10V2hwjPzYoC5lNu5qrNicnSocmQH3ME8vK8KadYCl4JyXOXid5aarhZlZJWwRpg0aKXboM3n+khrXbSp0TY70ub/Xe14fKCHNUGfLRsfHQypCoZhf2ABTDfEYETuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by PH7PR15MB5152.namprd15.prod.outlook.com (2603:10b6:510:13c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 22:28:11 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::3102:269:96e6:379c%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 22:28:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, "Joe Stringer" <joe@cilium.io>,
        Peter Wu <peter@lekensteyn.nl>, Roman Gushchin <guro@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and
 .gitignore
Thread-Topic: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and
 .gitignore
Thread-Index: AQHX0pMrvFlnauX5ZEGqTw/c9XAmB6v7zP+A
Date:   Tue, 9 Nov 2021 22:28:11 +0000
Message-ID: <6B3D0391-7DF5-43DB-87C9-F22374022804@fb.com>
References: <20211105221904.3536-1-quentin@isovalent.com>
In-Reply-To: <20211105221904.3536-1-quentin@isovalent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: isovalent.com; dkim=none (message not signed)
 header.d=none;isovalent.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 324004f0-a053-4b98-88a7-08d9a3d036ad
x-ms-traffictypediagnostic: PH7PR15MB5152:
x-microsoft-antispam-prvs: <PH7PR15MB5152338DBF3D58A37F7AF804B3929@PH7PR15MB5152.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3mWffFBBC290kTG+uMffrv5Qtwll/IwX2qAYSwTpu8S4WoNxncZ68m4DvzGsGphb/x2hsFR8nF482XXHgGyYndN6axSK32Y7/FnJuDafmLmBPy8AB1PKQshiZicy57YNWf6qgNN1v9eT66PFv2GZDTNvMZQxWl9NYppOt+Wpt3fNkfSIk2KZW4m81hSP0m4G1SFOqe4StXzAYVdyPGCc2yFRexjfAJICJra5ebOmgi96J1lZ+kXl6h0+JTXRzWO2boxRBfKxHLlPCnMPipXIpGoQTdvV4L73pzCF+gZFKKqMAlEKX5JMjTmWXKM4bMqPLwfdUVS4iPpKQNIDtOUJl7Oulj+9IXgd50DElLBnQPMVlOmCfwt3aPXPvNNEtZjElWKeD20AcOyKgy5y60NdmZv8xSTKEWPCxxmZH6mLNHYjfMh/mmb5xX2R2zCpkoNA+HGWNfpmYgCDUHzBBkm3C385bOjAB9LQNdTaCHfn9fnKpsLX9jaL6xttmnwfRhaENOBI8z5NOk04nQCe6Q3GHIcuKHPpT6M3HvqqMIGcwsgz7wo597UiBFPKB2LE3mAXSkmYgL3lIbfF0R93Y8kQISh52vavXIgzi3billVE0MW2siMr9qZ9150mdWKlC5TsZScNt6F1wgEfXYP1QesX5rZMz5NGqXGuZpWBCfBa/P/5OB1PRFoAPnkLtzsOH2JxQcUOL2zz0OKxEE8MD1XWfcffFPyCVDS8P5+fOgSPZXRIj4+q+zmOPWwusmLJEYgw/KUDBhX5tl0qgXnuxpJaLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(83380400001)(8936002)(6486002)(6506007)(2616005)(76116006)(91956017)(4744005)(2906002)(7416002)(71200400001)(54906003)(316002)(66946007)(6916009)(508600001)(66556008)(66476007)(64756008)(66446008)(36756003)(38100700002)(186003)(6512007)(122000001)(53546011)(86362001)(5660300002)(8676002)(4326008)(38070700005)(142923001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QK0+3466dlUJNTDo0fL8I81OaL/brS/OC4X0RWLWqgBiQqhoLKRvXl14XCU/?=
 =?us-ascii?Q?QKnJ2j1CyMLtu3MRfP/VzefGe+yYF3Zpc/Cc9eTLoMT/canIzhfIJQynNqAr?=
 =?us-ascii?Q?rutjD9VhFePtAdmw4zwMHuz/JtblpVNwmv+AvMS2xvxao1zRYcctc/NkR6ef?=
 =?us-ascii?Q?DN/sj7DoAoLiWq4p7aAOYYHZ6uPbs6x7LtMefxWMwBff4hiXxYodTYKfaoWt?=
 =?us-ascii?Q?xwqQ0TJ0r1Id9ObWO0UG9+BYBw/VpLbH4ibocrkDRO6pPs1q2ArILccUHjqR?=
 =?us-ascii?Q?aQFOmqVlcdZBHN6Qqm3mXNEyEoK1OX99z7RkWPov1qNbrPJjSGCKTXvY5jR7?=
 =?us-ascii?Q?/ltlHVaMQmhRG4apTARVm6GBeytzvcDZLYvV8Q/fkijzPQUbRahA8DH3WPga?=
 =?us-ascii?Q?vqOgTN0Se42CXV2IRT8wm571NvTA1tfIcoEpr2NPlU1jgl9If8ymiT/2rNCz?=
 =?us-ascii?Q?3ebeNEs+MmjmaduIVBfMyZiV4aiYUhgLbPy+SKg7BAbzvMwUgCIYUJNhJgPH?=
 =?us-ascii?Q?leqb/KM9ono8qXkIoGdrBpCeXZONk9t4nyjRXu53TkdPmN2e2hmpOIIqUs0y?=
 =?us-ascii?Q?A0FNISy5ulCpl8u/Wha14ChdIZpAdX+OidJNiHP1LUXGWWOM9NCDstZgQkqF?=
 =?us-ascii?Q?Cfbbl8qzQYumZc6xhEpdamvR6cfie15Isi8fKkHJSWH49jVkZhr3vM4f9Ftv?=
 =?us-ascii?Q?+1HF5nAGMfOEhbcB5hbxjHk4Xy0/n5LaTeQ4CL7msMZ+eyrqEpK9wE7AJRty?=
 =?us-ascii?Q?e7XTTYO+XNpVzKtYyzh3jNI3izkJDPlkCeT07hoKS6cP7ZZHUG96YnuRaJmE?=
 =?us-ascii?Q?4u2vAd9dOMbheGjN84Q63MxiiUOL7pH2Jlrxlv2ffndqn69BGjophtqHeQoK?=
 =?us-ascii?Q?vhjpB3+WPaPskQickJ9iMKfO79pjoCbyEP6xM5jL6GGtlLBOGMNIO6QAURrW?=
 =?us-ascii?Q?1Qes83VK131OcDh4DHLg+GgMroA5n8lBMgu6OHL8JHaWIFtnKehbmsfBtYuo?=
 =?us-ascii?Q?jyP1I10oeaLI/lK4Xc/UF3ekpjlwBo8XSU8nRMJOVj1dpXnC50RUB4WIpXm8?=
 =?us-ascii?Q?ljTK2fDmpEtv9fMYLXNn/EueEPHbnLcbxa+Aa3FUeao+7eBtbnbsfBRqBc5X?=
 =?us-ascii?Q?hsWfTxooO9jGtHeq0JpvFMrFSCt93ho2Lz/KK52L5HNP02Zyml9ieZ4364WK?=
 =?us-ascii?Q?f1+FZxbQJtignPoqAy/yFa7STj6xYlNLpvyx43S5aAhQMEw3z8XuWLXhkJny?=
 =?us-ascii?Q?VX+RKRBhzcaTyoVCc0ooG4Em0TIxgwOGU1Q4p6hYQRSZNbBYmcNMpY+HE+ow?=
 =?us-ascii?Q?Mzqjz2F8w++naBX3s7nU45SpJ1oBPk0I1sJ3alQdvszqBlbxABsdZaq+qMUP?=
 =?us-ascii?Q?hYYD3lcEI4QkGv8K9gDeRtP7SLFBBRQdvf2wCup3WJiNthMSq2EOeDC2hECd?=
 =?us-ascii?Q?kYoi0T6VclauFGpQA2B07B9oTSAzDj5lq84lpKfOPVzLf57RruZfW6x68Y1T?=
 =?us-ascii?Q?WjLAFu+jIzSbA32gtPGBY/qJSZaS8jvRzpPVPbJVEgo/h60RltKG7ZygNNPv?=
 =?us-ascii?Q?qz7inZAvztqXpa9qg7MJJFMbSBFPCX3/Q7o2l0R9jw/jS+R5az1seAN6SJgE?=
 =?us-ascii?Q?BUitr9zSCBiuov5m/aD4Kt5sqzRCtqcDLdGD/evK917/dWicEXiDqamLs9u+?=
 =?us-ascii?Q?bOc3CQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C709E17687D1BA4C9A44A0C884507531@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324004f0-a053-4b98-88a7-08d9a3d036ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 22:28:11.3790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YM8OiErsL+VhJ5J10GLIgh56YrE+CXkqLt2bXrBO/+S6//46RFfTNKZ/1h4UmX7tUVF3Eg4I8y6tutNvmsIZuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5152
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: fp0HELz31UFQO_u4YvqivhlyGgxUoPMA
X-Proofpoint-GUID: fp0HELz31UFQO_u4YvqivhlyGgxUoPMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 5, 2021, at 3:19 PM, Quentin Monnet <quentin@isovalent.com> wrote:
> 
> Bpftool is dual-licensed under GPLv2 and BSD-2-Clause. In commit
> 907b22365115 ("tools: bpftool: dual license all files") we made sure
> that all its source files were indeed covered by the two licenses, and
> that they had the correct SPDX tags.
> 
> However, bpftool's Makefile, the Makefile for its documentation, and the
> .gitignore file were skipped at the time (their GPL-2.0-only tag was
> added later). Let's update the tags.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Joe Stringer <joe@cilium.io>
> Cc: Peter Wu <peter@lekensteyn.nl>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Tobias Klauser <tklauser@distanz.ch>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Song Liu <songliubraving@fb.com>
