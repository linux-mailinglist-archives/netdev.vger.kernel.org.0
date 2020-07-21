Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DBC228C3F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgGUWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:52:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgGUWwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:52:17 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LMowJT022793;
        Tue, 21 Jul 2020 15:51:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WB4KQ7j37AuoU7UYpmKdi1pPbtiGnhuG61OpH45ZyR8=;
 b=lj009JeVgnw8etvWi6msQ/RQ/kJqvkKDnky9dxcg6tMadftVuWIXtjBzrvgUIYalTv+x
 vAAbN0dHLcCIOqAxQyd7HG7p9bzUX5y1oMxWKh0TgWEqCjXjJt6hHC19T8V+YXh8c6Vu
 6LRrNxwHKGPkCCchdlbtVwX4YuvpqUDKVJo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32chbnuusk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jul 2020 15:51:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 15:51:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOpkdb43DgZ+M+pC6tYrfSvRk7BHTTt5Sau/icE/dU0i4YHhf3ufQfS0Jle9Jb1BR9MgzNXdYLne55k+tDIf8frHa18y4leXeNWviB7QWTlQ6BOU7wzqzYwIAODkvANzEFbf283Be3vV/HVkbjNpCJKofWU7/dILQ4f5i3cUIPqkRs1wJ9QpL35j/VOwpLvTxXpUiAHyHyz0884GB2Kis4NeiA3Actoe34HvD7e/wQk0kGz7olzcp76BWD2nNt1/Pt8loE4hlFNWPof7wk5jcDKlR6aXekpFVkgeNVE517WL4IyXxGu0v4fvE4M2RF0VBnmljQSf6O76PjHLJZUiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB4KQ7j37AuoU7UYpmKdi1pPbtiGnhuG61OpH45ZyR8=;
 b=EPbW2Gqu5pZaQksOAkGjMs96QkZBfRJ8+pa5iVuHcOjQoFJG5fWEMrOp3D9UpfWsxIuuJDpKLeqmQakmCE+YUsnE787LLS+l34ygJtaP6DQrvA6oVCl1sH3lp0xGN4wC1UfkmlCf/A9IuAeljtwhRJeWYR22VvnOk2VsEgrZHSIJyaP1lkLPzh0OJxV1A4ayIWI2fEGw2fdPewvQMNTlt096rTP5uJG68CzAaRlYarQWQaCfTH2dWfDOH/GghST+UjLgnGDiRRP7WO5Fc7H7gronJHF6ydlNBiBFPPGxzOjJNLJZarxxKbP94Jxx5oTO7BdHz+NPH4cfYSK140lYjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB4KQ7j37AuoU7UYpmKdi1pPbtiGnhuG61OpH45ZyR8=;
 b=QPEDa6L4VtEUPIjCzik8f7MvD+wm56iXl6Yn50MfcuzKQtjUpU9U/HtghWlRc/SbeyF61aqPPGCuStrqy5UXIjuGlZ9+agiIzc1VyxZOLdJnA0i0UNPsQb+GxwYMWdRZTDPdtp6FgkgkKYULwFC2UaqolMd4OhH/4/Nd/HI5t2E=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2776.namprd15.prod.outlook.com (2603:10b6:a03:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 22:51:54 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 22:51:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid] for
 perf events BPF
Thread-Topic: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid]
 for perf events BPF
Thread-Index: AQHWW8VAnRb4OqAgyEOVqqMnP7xn/akSbY+AgAA6uICAAADggIAAAlmA
Date:   Tue, 21 Jul 2020 22:51:52 +0000
Message-ID: <A11D2C64-DD12-4ECD-99E5-EE9558BB73A7@fb.com>
References: <20200716225933.196342-1-songliubraving@fb.com>
 <20200716225933.196342-2-songliubraving@fb.com>
 <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
 <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
 <CAADnVQJPmo3He3cdUUbMm4DtTDNBeWRMRkNzPw8S3GdxxODemA@mail.gmail.com>
In-Reply-To: <CAADnVQJPmo3He3cdUUbMm4DtTDNBeWRMRkNzPw8S3GdxxODemA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:bb45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30b54855-933a-4417-a394-08d82dc8a90e
x-ms-traffictypediagnostic: BYAPR15MB2776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2776F634A24898F992EF9332B3780@BYAPR15MB2776.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QrPQzQI5N3sTNjLTDaLcfgDDgPZE4tyenqctOBXWl3BxjjvtSUJB/UPo/vUcjRqhaQHKr8J5R/0YrpLjzErXLGeim0sUXNO/zVysZKvbPuyvlDShhZOh4r6Nlg8+v2yImVX8K2qUIvLccX1MZ/3V6f8aaunJ45+Hx6SJ8l4h1JwMW4apZqQu2mzUQo802Orv3j0HpDY3fD9xASzonrR2er2ErKiEveviAGPQzEfEifHOw3hdkNIlsJzv7OZNWuT5TggFSGB/xBjb4nVlxxHtW4ILJd52WOeNw5kgiJu2+gaL68Jk5R58t3QhTGnjCQHhhmucSRITu0ZWIfX42GGIAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(136003)(39860400002)(396003)(376002)(86362001)(71200400001)(2906002)(478600001)(6506007)(2616005)(53546011)(6916009)(4326008)(186003)(66556008)(8936002)(66446008)(64756008)(7416002)(83380400001)(5660300002)(54906003)(6486002)(36756003)(8676002)(6512007)(66946007)(316002)(33656002)(4744005)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v6+OPe8KJJxehqUs1hW+lC1HCvg/Yt8NXV2epSlhsuFcBS9CimjijtLsKaB3pXYN7rceMk3TfSyPTX7ieY1qDYSWgY32eyDn+GaaHWlqVNZM0VXW7dTxMGRbI0dzpnXd+F2ID6UxrXIYij9ev+vlXY0iWN1eK2OxJ9306qTUa56qhrE0JFXGnsTvNq/MiSLf29zuQi+p8IPSzJS6ngbdL+2yQhOt6JiTGKYYB9vEL/5LhgqeqDZuVfZXacQ2GEKBbN7K/MJSVofyEPplZrguM24y5T1lPeNqbhNxY9pLq7Z7FVzwfMr4mPu5mrXxKxgEYt+rL0I83/jd46lnDQp2o9lBlTR+lctVfuCEPntpNf7VrGw8BN9/aSdO6sSGQdZcmejhKAnLxtKt3ck09kCXdszGZvhlqLIBBYWWLLk6IF4ECaupAV5gf61ypLxz3nLzw5jF+/Zxb/HzBfrDArmtjv0dtJ44SWK+PvqabC4WYv1iPdCw01a0busyYKTpLHNyxeZHIEGtP/Zat3f1l0GacA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6660011528DDBD42AF77EAA8A020459E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b54855-933a-4417-a394-08d82dc8a90e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 22:51:52.4014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5KjRVUP6fm650ytdAe/fnGuAeNioRlvW2DoJAOM6HELdwxmUoHNOn86UTO1/7sQZ9T0keBXJOMUzA14/Q3uHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2776
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_15:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 21, 2020, at 3:43 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Jul 21, 2020 at 3:40 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> We only need to block precise_ip >=3D 2. precise_ip =3D=3D 1 is OK.
>=20
> Are you sure?
> intel_pmu_hw_config() has:
> if (event->attr.precise_ip) {
>    if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
>            event->attr.sample_type |=3D __PERF_SAMPLE_CALLCHAIN_EARLY;
> }

The bit that breaks the unwinder was in setup_pebs_fixed_sample_data():

                if (x86_pmu.intel_cap.pebs_format >=3D 2) {
                        set_linear_ip(regs, pebs->real_ip);
                        regs->flags |=3D PERF_EFLAGS_EXACT;
                }=20

"real_ip" causes the issue.=20

But on a second thought, it is probably better also blocks precise_ip =3D=
=3D 1,=20
to match the logic in intel_pmu_hw_config().=20

Thanks,
Song=
