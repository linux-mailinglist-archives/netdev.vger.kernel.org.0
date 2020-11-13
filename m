Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312832B2356
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKMSIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:08:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51764 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgKMSIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:08:16 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI0PfJ023856;
        Fri, 13 Nov 2020 10:07:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bZZEV21+2/ELcihWE95MzVVIM4hqdZPk+tg1Anaqs2s=;
 b=HTKlisABHiXO0y0AQwTpnYvZNz3DkQ039moaOd3yCvFUyUDp2+olz8xgTKm+nNUKCOqt
 pb/b7Cc6ZovpQRfK++3tJLfhKjh6GZxaWgWj5GS1MSiiy5x6GI74c8UFgnwt0/wGHOez
 QUgDnv2YsanO6LUTYdEUdYIvShSQDFlKWhQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34seqn4djk-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 10:07:58 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 10:07:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAMAZvYYT9lbV9ebc4iuzIFK6DjLtl0SCbkpKaffgK8ZxQaqI6tGrLUAdaLLsIKXIIBoLdjvyoYz0Akdzq8ouj8g+Ndmp1lnkeIY7459Hti84aXQqqyskXPEU4kfawj03USeyDs1/Wkm4SX94ciQXSJ6DEkQQeZOzorhRiC8WokaeMlK/1CAkzfmgC2Cn9bDsAH7HeEds1r3DQSC0aQDO9/8NUQ123wmPiSQZtendLayyq5qVAfxQHu7T7GbDGSqYSLk2vYz82k6gC3rgalBqCbz7Wmm3MNnufhfNyv8mme6+GPcqACqdO80sPILKzYnbBGHTjNudMaKqy580Agm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZZEV21+2/ELcihWE95MzVVIM4hqdZPk+tg1Anaqs2s=;
 b=nkj94w9ErECb241vxMeq0K18sZhnNWS7L23SfyhHmNq0Z1B2fMnQGhDyHUUWsok4ZVhxO+ORbqC8DLu0fyU1fQXFUc6W1xSD5Xw4fi+ah5JEuTSH5d/WwBYqafz6PmUkECkaJ8sl7LWaPMOppMJZLlrDDG5vDhmkuY9UVe+hGjB7r4zfcJAshMFN6v7FCkTDgTNlyIvTdRaUkqCU+vfVLmCd1n6mhJciPM4t0UIZ3llvPSMrKe7twlKZHvfpkXa+zhZX2qd+VZTTjPaOSlQrpyhAYJfOTb+2qJS/1lKgxJl985Idg22tem2Rme5YVnKtSB5YBa1EGVHXQdBC7KuyLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZZEV21+2/ELcihWE95MzVVIM4hqdZPk+tg1Anaqs2s=;
 b=XgIPhG284z4wZ7irAG64aDtpuHcMzx0zqjiv9ittv5nE+X84V4eY5OfTUCSOVBQP2D+1zZ94oyOrLereZU+vhuHwPILPyW2RyWNNcH/7jOWhYwcPlVdl24dtGYCwVkcfqTdzRpeHDQgIqAnhxOWs551RtMaa7/XR91GCI4okRJ4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3190.namprd15.prod.outlook.com (2603:10b6:a03:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Fri, 13 Nov
 2020 18:07:50 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 18:07:50 +0000
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
Subject: Re: [PATCH bpf-next v5 15/34] bpf: memcg-based memory accounting for
 bpf local storage maps
Thread-Topic: [PATCH bpf-next v5 15/34] bpf: memcg-based memory accounting for
 bpf local storage maps
Thread-Index: AQHWuURn5B+9snWWmUSVnAApJuKw9qnGXUGA
Date:   Fri, 13 Nov 2020 18:07:50 +0000
Message-ID: <A680A2E3-F354-4EC2-90B1-D2F14C2CB2FA@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-16-guro@fb.com>
In-Reply-To: <20201112221543.3621014-16-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 608a051c-c505-4f1c-ea51-08d887ff08c1
x-ms-traffictypediagnostic: BYAPR15MB3190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3190825F52BA0BFAA4087BCBB3E60@BYAPR15MB3190.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yEG9OSWgnd8ODzap130VOThLQInxjYt5tOT2usIQWDlw7vCccGmFLkVk+x36l+M3o0HE4rdFYj0w/vEOqZ5QtNZLtLkEOVFuFqQbozYpU7JDxozVQrp/+ld5+OJ/8GuhK7v1VjV1NkFKcniCXDs5Y5TfR3ezAuqfnAUp7bi2hlwJj3V6xE04YT/OG6oWELQy/8mXTTTm3kWIX29VbmDSYNdtQHb27bU/e2TJNQOTCNcJwYjyPmfOgxqDKayFjF2+cbhLJYLUYL0RNlYiMmiuJgvfQBfEYIuFCrb7UIqh4pOIrqP+zCXUE12cA85oeGXHSy5MpInmiF/a84Yrn/2s9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(136003)(39860400002)(53546011)(316002)(54906003)(6486002)(6636002)(66556008)(83380400001)(37006003)(66446008)(91956017)(76116006)(6862004)(8676002)(6512007)(186003)(4326008)(6506007)(33656002)(2616005)(66476007)(8936002)(64756008)(2906002)(71200400001)(5660300002)(86362001)(478600001)(558084003)(66946007)(36756003)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: X+dE0h07Pa9VOnas6lCfxvjnJPEp6vwtQfaQhnp4/O2YKltwcrsufxE5W6swrnhb432dbc4zG6U3r7vnOEJGqJ99YU9+3B3atcj5uzxigSVuYtO75wLUVML/GFkTIqjyterKVVvSpwevPoqS72LOoXraFHaBnYzSV1vRV9GRjosHe58fh81EEMvFMdL7h7b4JTA01WGwyoh8WoXH8wvR7Q5xQUBYQNc5gFt9uqf8Si2LzNOEpneNjp2rS7yGj5iSgMMiVKtAQnkbFHppCbFOh0hnFX4WgNkonvu7djbqCTkt9FxyXVETxeEs2foOVRBouun/g44ZmACImHt0SVAaQ9LggmkcZqf4nwp3JWMltEYmx7f48RSoERlumI/NJX5s8AUxE5JZItpG0gQfIUKkQElISr0WaoB8TWJwcVmdrownE5QTbI7xSn9u7TVwGfEWzQ3bT6fmw2WH7N5nONjeNIYD6mJIE9Z4ekQ6Rr7NrKweqbKm1eQEmR0CB5NtWSwrtxfVSe9XC/ztQHOnxGoSBVJma3WzECYXNwKom/sVIybrylHXyhmRuSi0evNqovxDNM89ApAuU7PFjHStK/KKuM3nTTOyGl6BlaW18qZmMKQh0Q1PCBbxyYUiSnLvq6BYmTOuP5W0NzK4h1EuZMtGmaDIu52Zk6Cs3SHqWxBQzU1V+P5dP1Ub0luuYgvu6CWCFuv7TLfMSrH7KN7msGaWgHOqvM4uCs34HL9WYeTvuRgEGKZeSi1iO+y44ZwnNDZP5HZK92gUGMd+9Bv7OvxJAj/NDn7VDO2hHS1TOoTVkA1pwiwr1F6BamEP0n61JoENxa2C9JgiynZM6e2N+o5OdwHzwD/Km0JGzHzBPvh7T2F8WL5BImhKT7A/JptNeB6rq6QWXC1zTk9MRNAElulvvxJszzZPjGRvAq/oyihzD5Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EC19CE8A6EF7B74C83D24324DD34D28C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608a051c-c505-4f1c-ea51-08d887ff08c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 18:07:50.4772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oa9IJDbQOmbR0h6UkqgbV+CwzmqdnGDqX54VPs1rXSKgHRFEtNQly2EDigH5jcTB6TPjPP29uKKGcW5JEiaDKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3190
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=936
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 adultscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011130117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Account memory used by bpf local storage maps:
> per-socket and per-inode storages.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
