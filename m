Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F41C6003
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgEESZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:25:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728351AbgEESZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:25:18 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045IBPHI008778;
        Tue, 5 May 2020 11:24:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5qiY0srS9h9agIpM2Oxf1rm/mKaGuknD/3XFLB+T1hk=;
 b=pa64f3RfbfVBjan77fbcHB42ZmqwmwQ3zIq5iFPJsnegLm5Wrc8d6gPCMBXVTQLL5+4Y
 5its3hgZcQH9pyaC12KMV7YCXK8WEFPcaz+P2927nuNDVCyNgbdIfJeFRWvyT80q0t6Y
 4ueh2gKjqxaJxt+QHCNDDKENZjdJtz4Kjz4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30srvq4mmh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 11:24:58 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 11:24:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1ScWYdLF+OIL2JgNePaXfjriJIvAfPN1yr9/YIlus0mvU7VJmfoWsWC6AYvnzdYwLK+NbXzdr7Kd0wF5Xp7u8BmTU69MEdMCJm7Rf9U3B4Ey7ZbNkmwVFlfN7jf5H0IaHU3n1dqLWVIPg0hdte4VJWGIyCRg5oR3jL+wCLBkEEbsOcIYK/2mxjqyf1rUV4YU7W8Vl28CtUwszqmToMVTPfXGkJ8I3sCW1jMBH/SpWj8LYOw+AXq3Dg0W7vVR3RW+AeE2c8bEuScn2wMfpuzPNO5hpyOy/HARk7Wt/185DfZJH0ag1kLlRQHa9WifbUKALSuSgCpcWCUn4hxom5LIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qiY0srS9h9agIpM2Oxf1rm/mKaGuknD/3XFLB+T1hk=;
 b=fm8SJZFSLEs8M6Xj64F+tUl3Nd60+H5d8Fp5OVXFSvvNsffE7i70SOti1Facw0DVb+tNOLeJX3ntvk6L7DxKWsFGkR+SYsfZN8bNgW37g5E9wDYYpuGk0gmKb1ESz0SStYe9MCSGLfYuKYI805mWDhwQzIV+LodMss3V/MvMnffnabCdfN85W30zMYv8h31iWHtvZWZ72BB3fFkhaqVFBXo9lrFsKvp9NXM+n4U4dH74mjo+pjLsf9v3cphDCkIcZf65eiBMUGEni5j8Y3TJ0oYetSSUuvVxHk6J51fH0MsJLgexSMdxANZaxCB+kr4To0RXbs2VEI0Evs02yRoX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qiY0srS9h9agIpM2Oxf1rm/mKaGuknD/3XFLB+T1hk=;
 b=Q5GBM2aiDyzT8Owu1dF9+YzpewAMSZSf1JoyF2dSx3HzI+lrv1T6uIihX0flTt1dXsrUUyrB6pk/BrOhDV3ZVt4Y4UMdJCUkFudBrb0FyLQHV5uLJew+3uE6KjaUF+GjEc9tvLNtgkrbWjUO6rNv604BCTw/fhDS879QpQYiu3Q=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3095.namprd15.prod.outlook.com (2603:10b6:a03:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 18:24:55 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 18:24:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] sysctl: fix unused function warning
Thread-Topic: [PATCH] sysctl: fix unused function warning
Thread-Index: AQHWIuaL0VYevdo+b0WUUZxvV8sSKaiZzyaA
Date:   Tue, 5 May 2020 18:24:55 +0000
Message-ID: <F51BF018-3035-489D-8232-6D23A426D179@fb.com>
References: <20200505140734.503701-1-arnd@arndb.de>
In-Reply-To: <20200505140734.503701-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:182a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2bcf25f-2b91-4de0-b897-08d7f1219c7f
x-ms-traffictypediagnostic: BYAPR15MB3095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3095910783033C1E650A22F0B3A70@BYAPR15MB3095.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xpkBR2naYopRMJfrRkwmPs7f/OB/GgrOOzcrb8rnIBr6HIoU/p7KRaq8nfeKtwrrj2QRZz5wKyTWWvUMjr2ntwyODZMGP3Py+CeV7HbO6yXAOYbjA2GmnMlUDq4Hk8vEXQm2glZsDGCFkfW1FHfSEWLRmoBGmBT4bNqOpbEMWxRARAEawSy2pDV9tdescA00bYpNOtsTsjcqo0vB6dyvd0ymjhjenu4eVAoZ6RhgThoi0jy6x10vPRgNTrZ/0XS0ls3wzkd+VysM6OYMqYreJA8Z8HZlj3qk27fLr10bsulUfv21oBTNlk9ll9CgU8NcKnWjthq/+xF/G6a3js6PAdmbyfJU1BljUjDuaSUa+erI+A2hqpSqVt5epQCJSPPhksa2UKbzYG88i7prPCJiPa0vo1iCRAAaY228WukCZ3tQ+qGtdH5hyxmrpGyM9OQU31MwRaDQuYr2D2yLFBJQ1eHe/ij12JhyWwSie+9w2IQjHDVmi/Rc5NTf8cMPL2RWdEglbTS+Z0eT1YKeKWwEdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(186003)(53546011)(36756003)(2616005)(6512007)(498600001)(6506007)(8676002)(5660300002)(4744005)(33440700001)(33656002)(8936002)(6916009)(66556008)(66446008)(66476007)(66946007)(71200400001)(64756008)(7416002)(86362001)(6486002)(2906002)(54906003)(76116006)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YrIiBCmReANr/wLDnFx+Zhi8FEJP6UwU42b98xdJZgyCO2Lx9yukW3qt9uizZo4VEkSp7zhoDAyGxjXTDVXnEO0Wp578wFRg+/7Ooj5gDLRlL3ft0fIMhPfYPe2DDboZ0EFUbhY3rbfB/SMjl3MEv0WRUfGlIlwnukbwFX3wCvUkw3wUy7jUBL2vTItY+j0roD6elmCIxKpazfpDKCfJO5hg2u+hbI9hqug0YoD5WuH547XDUISIltG9etqAB8Nt8qN+HjbfUIpmbjfTpTbQqTrWsDiz6be5+j2IcHkoZD+67G6Sse7FZYxPIU1rU0EPO2SO7tO6w+86FzL6DBTgpyugiM9/3rhdZIihLVixTTfJ5YjtVdLlKIJJh0MY7Ec4QuRDAp54j6twcA8JeYqkD4ScrrnberOlwEEqrAyPwjcezMaR3NIrPR+GQb4yf6l+zS2bAWymZ72AhK924Ek0QLZU/qcRUG49vNubZWZPrFVdDvQBbDDs/VpRbajgfaH4WlKUJ++V0XSXvvXbPjPkOjbZmqqWjyFfuSolVwaTwetgzy92xZKiUBoKZpjVcUS8KYlIhqz5GN0/FCTaohkdcGGHSlNx6OGveGTPdK+P1GK4DW7au8Fr/NSHsA6aG+BbdAGuDU67yehX0LzlJ5RXUHoZm/Sb/QS66qTRq1t8v9qVJe7MVdc9VoUZGz7x5ZkFxUBKsKFxddAK2fpApKF88ECpfM7op6lV3GbiKT+8vPNyFfIys0ZUG8fz5rJk7b2fxE5Bs1qqT8HF+BryqGVgG1o98bgtQbVb8Lf4bYK5YsUSjnjMxnCoGD26HsLXGFdKhsRJcutVbnW0cpB6IS/xCA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54B066A8ACB88B4EBB983D4A2C8B4A45@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bcf25f-2b91-4de0-b897-08d7f1219c7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 18:24:55.7025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fGmwkGu4e9q+C7412U3XO25M0TxIJ8SkHUQhbomohNzn2rUSJpIwVnV5eXGkL9VNGZX5x2f/5OP2LV0F9fs5Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxlogscore=656 bulkscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 5, 2020, at 7:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> The newly added bpf_stats_handler function has the wrong #ifdef
> check around it, leading to an unused-function warning when
> CONFIG_SYSCTL is disabled:
>=20
> kernel/sysctl.c:205:12: error: unused function 'bpf_stats_handler' [-Werr=
or,-Wunused-function]
> static int bpf_stats_handler(struct ctl_table *table, int write,
>=20
> Fix the check to match the reference.
>=20
> Fixes: d46edd671a14 ("bpf: Sharing bpf runtime stats with BPF_ENABLE_STAT=
S")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

