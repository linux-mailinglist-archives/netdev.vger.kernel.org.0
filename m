Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECAE2B227E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgKMRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:31:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39918 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgKMRbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:31:52 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADHJ7SQ005901;
        Fri, 13 Nov 2020 09:31:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bxhL8ocMZi3ssBzv91+dn76iFdOJoNZXOPFKcBSr+qE=;
 b=SLpngYQX48Gft4B3zkWFfHVDZ92QEwQVL8IyVGQ44InBSl7dHw1CJ9O8/mJDuHyvRdhU
 g5GtMk3knY1QHRbbVew+Ygb68EVOO9i6UbZ8IeP9+k0lIqKhBysngMbttvatz2si1rh3
 ciBN/jZvVUTTfDw4EGoD/4CiGjefLcwfQeY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34sdenvnx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 09:31:35 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 09:31:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kv0GixEmrWUCvLpJCQLb8EjVw1RLsK2E0FdfL4XPrNtFnQCIeY0ULyizrJ9UKXnPT56NZLeeBzJkpjs3IzKxuxdpTNMI0IO6+dcTr6XEDmVj0EhrOmJRRGnGk37vzLRzFwmj7v2loSfsWT7TsHPHIpQqEy3PwLnv6iz+qlzRoUPBOj+3/1+qffglQP5NQlmIBOkBkTQtgmsnWREjIIp/I7N84GaKlS4xanEOfONJB7VA+ep0xgT5QNlfcGsnDWfnDrUvVMqyoxGgxF8oDWbVdvlHbKQeIeGYZ6gu/mMWGQcqMC2Kfgx7RYaaSjrFBaBtebIffwu//grrglhx0+obvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxhL8ocMZi3ssBzv91+dn76iFdOJoNZXOPFKcBSr+qE=;
 b=klSlUcMgLV7DbGYtBexS6ifMpVPvyHxML+rrs4ZM9qY+sU1d2+0D7OGOJOKqIZiUZyOWuFPxZ2fKv+MTz0J7eJDOp5wYw9jRI1R41odLsU2tQ22ql/1t4wrLkNTgoys0Od6ROw7v3KX6RidqtgdUJgPSHbz2NtZA5Gihki+yRZC51mYADQDnEy6t/SjhGPC7CiPxhF4pAevcdeWWnOR0VZZUhw1dTyY8oXGK6oec5p882yONH5f7jU7Z8X+yokUEmMl1k3fnh0SsHSaQEa3VEsVuLqtNHNSPcQFS8KlLozK7kU1kVeujvctB01YU49ltYg8obpm/Ab9/gV0o6RzM1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxhL8ocMZi3ssBzv91+dn76iFdOJoNZXOPFKcBSr+qE=;
 b=EuxsjEiw1P81MZJtS+gMukt8jm+MnHVT6cV6f/o7JpGGDiB3VE5pOCEyqdKN4h52V6SzW/4+1y/9jCW/uZk5HeJ7/60idGZf23x+E3eBPdoeiryzK6fzowkCI2swb+CXzfRdZEaNbCpry2A8sdV5EPkSDjXrNeMoaP2pHucf91g=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 13 Nov
 2020 17:31:29 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 17:31:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 05/34] bpf: memcg-based memory accounting for
 bpf progs
Thread-Topic: [PATCH bpf-next v5 05/34] bpf: memcg-based memory accounting for
 bpf progs
Thread-Index: AQHWuULtNs9OFs4YQkuFkIZd2mepmqnGUxuA
Date:   Fri, 13 Nov 2020 17:31:28 +0000
Message-ID: <AB3B80F6-82D4-4796-88D4-56A8E9D4C7BB@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-6-guro@fb.com>
In-Reply-To: <20201112221543.3621014-6-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0309ef6a-a47f-4f3c-2bb7-08d887f9f46d
x-ms-traffictypediagnostic: BYAPR15MB2376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB237646EDAC85EEC69E95A45CB3E60@BYAPR15MB2376.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jFKdFgQkBhJEZu2GNu3UxsoCkGM0rNcbNsfiYBzErwtjWRiTshgkQJdkXOR908N33gMAgky5p9OYo/lbT63qtDsFUEGucNOQtoxC27aWhNknyL7r1Y9DjD6QZfaEUjfbjCvKtK0F5OYevzElUbe9gXCexP+QcKdHs/DOUJpNYA35+LQ5X9cLla34OgSvsmrFmyPCAMErSDorPAjIkqeHtVwqo8K1rOaYoR701vBKVNghx0gO25p6Z9PqZwOGWyFJ9Gcwvlu+FXJXg9NmfbrWqUclrGQxwcVXqW1t0N4sCTO4rHUx8ErlFjcmNZxzb/33DkbqKPJjP2/2gaiVmPJNfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(376002)(366004)(2616005)(53546011)(36756003)(71200400001)(8676002)(66446008)(6636002)(86362001)(316002)(6486002)(54906003)(6862004)(4326008)(6506007)(4744005)(15650500001)(5660300002)(66556008)(6512007)(37006003)(8936002)(83380400001)(91956017)(76116006)(186003)(66946007)(64756008)(478600001)(33656002)(66476007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wZe8MgdEG5EOeYkVe9MEL1rpL++jSI861KXb0TzzUFqVgwkHfnLnaKmki9keYZtYuChRN+px/r/EhecFjv3MWW94/qx1xMIxsVPyN7RkLyRaufGjnvpuxvGyeUO95911/Sxqcj7A7TZJj8vF783vjl+AY0O8o8v+SMnPE8wRgFmKT3Xk8/oWpuVQQex3V2iXHD3IY1jzZnac8vH5Nz+rCbp0SndAhoAa/I8TASadtcsfC4aDMB3f63ZfbPFnE6jCqB2zTuTM4TeAS42qWqK/u9CxcC+goc9rx98Dif90AW73c+D7lgKqg/IayYLVzIFd6H0+bTekxULYfKY+FTi3Io8dN0sbWRCgmn/rszkRt6HjnGUZKZ1h02nQYU8J0BftV0ltOIPI3PKMMpkvegh5ebZvjx7ok5xraHFGTVb+IPIAGuzggUDv/7l7zZ0jbBe7y90Zvn+qNww7xTb2QF3yXWwvjL6HNuu323zTgHPhWx0Oz2l0pcC2cYLWEq+FXeFwLoXOLqEeW39Cd+Vu+kLppmZNmvrKa/sq6NGjxzTbq3WTLD+BeCWYst8oq17bEpTLlgdWWDyQjJ720OHMcV8kiXCnJbhqCIO5ZEP+0F95lfKiX/1P7us9ZdyoBKp0ycLfioPwJzOo5QCcXPmOrY8H+ZD4WgUg8o+fjuiNgpl87HRZsfTTOGbECHePcsppM25hklX2QGxN0DrX/PVr+sIt4IP/1f2d/bJwk5UmcmOHghxt6qJQ4JEK4ujPZY22lrP3EX21PX79/nVa2Rnwp9GRqUO0MUGZyQbmLCbak4Acmy2WmFlo91h205lggSgpUBpgZub7s5tw57u1WXOJcuNTbuQX2fsd9REeWcmEt8JdXTag7dZZAhK/puAi8C+teb5LP1gJSuW4KViaJEAWuO5WNlf+OXp9WSrlpjwPmodErlQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ADFE3AA1E7845545A5A8CA6FBFFE946B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0309ef6a-a47f-4f3c-2bb7-08d887f9f46d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 17:31:28.8737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blrFhIJMxGItuzpf50kpMpGreFImnCbpTnjEEBJfCvBWdXFBI+rcKxFmpv4ft1jlRm0kw5EkD2xNOyI2YoXBoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=854
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Include memory used by bpf programs into the memcg-based accounting.
> This includes the memory used by programs itself, auxiliary data,
> statistics and bpf line info. A memory cgroup containing the
> process which loads the program is getting charged.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

