Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D2D1BD3FF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgD2Fcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:32:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726158AbgD2Fcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:32:32 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T5TomU031645;
        Tue, 28 Apr 2020 22:32:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gs0eek7KyFz6jTWzrSSa74wPsoeHpZrzc/xMiL5LrDo=;
 b=n6UYm6FV8ZAvAqFmBMme6TCXCWGl550IyA+QXN9PtqhWpWnfYN4kOHY3ygYxppmZAtq4
 7UMrwzV2K0Yf722z7nQ6Rp/iLsHqPR9ShfqbMlbCV8XyGzlq0ds+OPK1+e+wxVt99gf3
 C1PE4xYpgsUkDe7Q06lUa0UOY9z38Bgcfkk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ntjvxua3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 22:32:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 22:32:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFlFzDdVDxOSO4510WwwuNuvYjJgGo7F57R1+hntc2lMFg7DMeT27lifyBaQnhNNBKNTVgXol/LYHpJoGcDmQRpm7oU3qW6ig7BV90SwmBmmRB1pbXy43+SToZ2F6aFzz6K2xzNpt9BNnyF+KtlrQGvgO/fGY1mvFNC6iy/3OUGpWzSKP4FcCiWCT7VnDEUM8mad31wvTScJNZGX8PnAhTUNRli8+U+87/GqIecow0Bwczm38zBCAS+e8bcx1yw+NdSKTFXPQMmuof46AUJooIha7V7n7g4aFym9DisQTbbkxXlGOo40t8aibtA2cIXKsnXA+RzbQaYKoLe8j4UuIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gs0eek7KyFz6jTWzrSSa74wPsoeHpZrzc/xMiL5LrDo=;
 b=bmPw1xNhA+YKwu7yT4x10JK3GGAtdYjoTSePpGlfxqAsc5Khi558PEtwOy00qDC+eV/bfi0XHwxNpwzYWIx+O8eyedRl4CVgWxBvvnbpvJx0c5SCFKpeItwmi1H/DbciTAH8ESM3SUGeTKlG7MyV6DeRGnzB0UZYO74kCJ9BylpxUdxR0d00eY/Wl75B5DBgiLSaHfLNVtTQ4yfyDvqc44dGv+pwhhTuaDejJB0r9kndR265LnfNbC2G66r0+CtXzhXPEz1UgAdihkX6+Vi+GesC8C45ZaQvgp8hvSDJER2XQTvkgVm+NRfEbK3y4DmUBLLfiej3cxaU5zypqvWyAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gs0eek7KyFz6jTWzrSSa74wPsoeHpZrzc/xMiL5LrDo=;
 b=Onek3Aa6gGSTtwavqcai0hujbMNsCy1gCtmvSXFTC05s110JFSb8qTlm6MZNzOpr01mppblFx2siktUDa3x4/ZAEwN4luAETIiUia5PRGTHl7079csHituPgWpuotlQ98pTEmoVHkDpdzaOUd3tjkyn9GutkeUYU+PDDhQJMWEA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2677.namprd15.prod.outlook.com (2603:10b6:a03:153::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 05:32:06 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 05:32:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v7 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Topic: [PATCH v7 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Index: AQHWHdqChmT8FqtfmUC1Y8DWLenVIaiPiZ4AgAAJtYA=
Date:   Wed, 29 Apr 2020 05:32:05 +0000
Message-ID: <E7637E2B-049B-45BF-8F1E-A3D509FDF675@fb.com>
References: <20200429035841.3959159-1-songliubraving@fb.com>
 <20200429035841.3959159-4-songliubraving@fb.com>
 <20200429045720.kl737inpxduutemn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200429045720.kl737inpxduutemn@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:b1c4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 723b1ab1-43e9-4d56-4f7d-08d7ebfea769
x-ms-traffictypediagnostic: BYAPR15MB2677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2677920473C04010CAD1CC1FB3AD0@BYAPR15MB2677.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(186003)(6506007)(53546011)(478600001)(6512007)(5660300002)(86362001)(71200400001)(2906002)(6486002)(2616005)(8936002)(33656002)(66476007)(66556008)(6916009)(316002)(64756008)(66446008)(91956017)(66946007)(76116006)(8676002)(4326008)(36756003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8peq3uV3mKDQdlKNIctUjzbPEnR41bl6F2p0H2pawkmSSs05UuaKBZ2PFSV/POCBcJF5W6Mjx4L4YWGyjhkTQ9sl2MWohd20u5/8KTptJlO+5ntT8h5gcGAnY9dLaPB3kUkg6HINKZm2vE2vY7i6sBuYyj/6avGBS0XSY36K76f8j7ezlz+0+bbRZFPh9w5PhP1UgFi31yLnh31RFe+VxBTJxfFCzQQJ6xpdsQd/NmfagKA41J419tL7luqhWbMrDdpjrf+RFTpBzQRFijcW2gnEO7TzGunZps2TUMfDNMmtwRTguiKD3ZARaNocCcHizirqXnsVcbgOYWrxAbj9xhCsKup0ar0Nj8H/iLI07W67TlR6W61cw44N7d8ysyOscohz6qshRvya0o8EpyXSrO8/axhB93v0JbTSojrZsMN/Klqt6AkCYO99txFw5dlU
x-ms-exchange-antispam-messagedata: 4QYwgcEZhayDy4nOcC8rR+mYvCInHn2bGcceCol2CO02mfaxiYmnwHwCJBjMuKL5LWURchMAF6xDZYZr+C439JwH6YtVK2Cua3Pf53KH7QVB/lVpF/tJMAlo2cMMmKeP/AhWmnalrAz8QwEm7ZsAH6z1Dr/2J3J51jW+la7D+8JPoq1aRHLjzs3Ws3ZF8H1cNokTewdYOcgEZzFvGzOZgcA9axNeIf0c6oWzH5JV7LwxZibpIhlt2g8gebq398T8DE6QneGgga/qcrXMbztGpI6kZ8oguEkAOA5O4/Ni2Z66k8xGWKSfb5qZahtuzEV1hcP46HxOYpLn989rInnE1olIscFeHBJkniHJvQprIkkniEeAqsQWpyaPWSjYhTebJcihAMgge5DHHmKN+37OmKWcsv9HxpWO1GPKLHbbNi/Vtc8+PlsMTmcNtxi9yrGZ674kGZ/SQMYQt3BICW/B8t8gwLANjUNhrOLU0Rigv0bfRGJ1ezo/PWYOEs4CXehTPDyD5UoD9xTOxo+QiBSZxoToZDfjwRR0wyD2THO6jQjnvnEOl8wc7RrabVIrRiHc0lRZTCjyjnXyR4kk497hLIJpn8Z8+YQ/cx+utPTGbZ/K1KFewfvDLIEvP1B+sAObVAYuc44SycM06n/YAnKwtmLP6XGSmifdbkGLXc8J9Oh2Xj/w3n7bFE1NV43NMK2UJ/qXhPa4kkj5Of2t7S1/ieLM7/6NBK0JiCM62cTaPRoIEXdMEN+vjm+LItDZ9O0QzD0hPVNBJp9c7X4okDeIJtcOJnGjvDXVxlCfS5DCR8UKsExCSFUsSaIEM3ZSY0oR/W/VklpywlinF3vlk5Vnzw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCC424E2BAB53B4CB50A9C93EC79C570@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 723b1ab1-43e9-4d56-4f7d-08d7ebfea769
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 05:32:05.7612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z4UUMjQ5IIWkLY94dOmIhdcwUJ1lK82YX1ycXfJCcKcDlHf+MsX/yFle4G0Cm3jkPvx3Ji1oGNzNkaQJrQDPgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2677
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 28, 2020, at 9:57 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Apr 28, 2020 at 08:58:41PM -0700, Song Liu wrote:
>> +
>> +	skel =3D test_enable_stats__open_and_load();
>> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
>> +		return;
>> +
>> +	stats_fd =3D bpf_enable_stats(BPF_STATS_RUNTIME_CNT);
>=20
> Just realized that the name is wrong.
> The stats are enabling run_cnt and run_time_ns.
> runtime_cnt sounds like 'snark' from 'The Hunting of the Snark' :)
> May be BPF_STATS_RUN_TIME ?

Will fix.=20

[...]

>> +
>> +	CHECK(info.run_cnt !=3D count, "check_run_cnt_valid",
>> +	      "invalid run_cnt stats\n");
>=20
> what happens if there are other syscalls during for(i<100) loop?
> The count will still match, right?
> Then why 100 ? and why usleep() at all?
> test_enable_stats__attach() will generate at least one syscall.

We don't really need usleep. I was thinking if it matches after=20
many calls it really matches... I will remove it.

>=20
>> +
>> +cleanup:
>> +	test_enable_stats__destroy(skel);
>> +	close(stats_fd);
>=20
> May be close(stats_fd) first.
> Then test_enable_stats__attach(skel); again.
> Generate few more syscalls and check that 'count' incrementing,
> but info.run_cnt doesnt ?
> That check assumes that sysctl is off. Overkill?

I thought about this. However, close(stats_fd) cannot guarantee=20
the stats is not enabled by other fd or the sysctl. I think this
will generate noise on specific systems.=20

Thanks,=20
Song=
