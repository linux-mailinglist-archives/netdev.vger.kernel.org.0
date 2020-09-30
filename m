Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA7327EBC7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgI3PFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:05:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28390 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgI3PFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:05:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UF0ljC011845;
        Wed, 30 Sep 2020 08:04:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qxGVpZlDLek7hS2aVralSIb6h0GnmOmK7vzP26UVprs=;
 b=bT/oW9F8lFti0HGRZWGmjt9s0N24ut4l4IGr6cOoQyXGcfTgaH/jy0xO3qIQlT2yP4+K
 26Dr11J3WkrMjnHoK4okBALXZ4xgcDtwrMvkYcHw3E69fsVcfW41XajzSM+4bpTIXWkA
 Y4CGLfehxJs1bPgmE1UOh4qJO4P/bSyR6/A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vty69d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 08:04:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 08:04:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hd59wcsJf99k7kMoWZFMXEmzfS7IKN819+iGOGIiTYbPHLU9kRwMNKvtPHnaJTSlgkmZ27Rg+Us7GJm7c+h183SxhDaLkNjtRO97++UnhCHEsIPdLzxn2u7TCf41WEdcDy64Td5aKcEd4/8RgweF7ftLhkLnKhn1QWZNQxvaZsR03mNPVuh5cEhPuzd/pAM0Hm5od477IPV1EKaQ5YbjibFoc/FkPJq11c8l4uJfqyU2Pxl+wcC27JA8VD1XW+UkNjii/Ggqi0qgPiYNml2PaQ4tfjh3BGimL7QqoCLQNvePxfkroFSwbkfl7uU+ViOEMa63SmufnrRlS9l24DqRGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxGVpZlDLek7hS2aVralSIb6h0GnmOmK7vzP26UVprs=;
 b=Fwu2Xrz6HeAzALbp9V0Ao/iRDngGg1xnBvzEyZNnkTA8O9AGhWDHaw+njWoqb2AoKRuw7d7OUBrW9jUTpzZNpfFS8LSj6bJwjqAVqPblW5MBlByuylFQmj7oxtiKnhN134i+H/fS1ufYRILh0m9K1++UAA3jkg4fDbAMjqrrmetH85qegtM82R5yK18uu8Oz2M8kXnG/AuFMj+A2etxV7g3g7gb45kbNdLcxkc5W6tnSp8r+xFrRZEl96hCrjbvrtzRSBNSdD52cNXBWyv+7gIyKYp1uhupozF5EPt29QCt6qKGdqyb9lMDYL0wVISfXxzCl/7QLAbIbcL6CQs7kWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxGVpZlDLek7hS2aVralSIb6h0GnmOmK7vzP26UVprs=;
 b=HpSgqIitXQuKj5i6kpeV1IQjkpkPqI6S8IPGZYLVj6/j8FYGBT+jFh5pVQZ3J7Kx8cMc4UrzbsVwg/r14j4sSTUdEIa6uLf0g0IGWbTrkdUzpHnKHBMaNv+5nFV42iWfmXVtDEUlR+3BvIr88hQd+QAjFB9aYQ0Cpg786V70Lcs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2199.namprd15.prod.outlook.com (2603:10b6:a02:83::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 15:04:14 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 15:04:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: introduce BPF_F_PRESERVE_ELEMS for
 perf event array
Thread-Topic: [PATCH v2 bpf-next 1/2] bpf: introduce BPF_F_PRESERVE_ELEMS for
 perf event array
Thread-Index: AQHWlquL7ewQxdWJ/kG0GdaDFHfHTamBRHKAgAAEHQA=
Date:   Wed, 30 Sep 2020 15:04:13 +0000
Message-ID: <08306754-3A1F-412C-98EB-448A1348A6DA@fb.com>
References: <20200929215659.3938706-1-songliubraving@fb.com>
 <20200929215659.3938706-2-songliubraving@fb.com>
 <c7b572d4-df22-db9d-6c01-d2b577c47116@iogearbox.net>
In-Reply-To: <c7b572d4-df22-db9d-6c01-d2b577c47116@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2d5b6f9-80aa-493b-505e-08d86552181e
x-ms-traffictypediagnostic: BYAPR15MB2199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2199A510CBEA11628604BBE0B3330@BYAPR15MB2199.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRijFee/0JVyfu38gI1MucNRtH9lElOCBXluVhOBbY0YzW2B2t6Obl69MJ71r0n8bUkskxNFTshKKTmHdWm1xN6hUH5lgftwT6XAz/dCCerq9j3sr8WFW8RoltqwhQ9R62j4a8LEkPQG9xHrvRc4+GNE6NVIeCrT5/EQf/eAV/s5KcXHG/AQlllBNoaVfl3wRDLhRvLZC/gDXC8zlNFeweh5oyjoeO2/MLFU4q4C8zHTnx0lYNkpbTMWKO9P9p/eRCJ5Oa1Nk84fTvGPrQcRrTXEi/Is1e6bEYUC/e1vcZnITtBbx1ag/FVwSblTk5rabPXTugKbK7Zvx4GZfyYNZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(8676002)(316002)(54906003)(86362001)(76116006)(91956017)(478600001)(66946007)(33656002)(4744005)(71200400001)(66476007)(66556008)(66446008)(64756008)(36756003)(186003)(6916009)(6506007)(5660300002)(53546011)(2906002)(4326008)(6512007)(2616005)(6486002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: D97cGzfRQCH+ahhSo7omh9ITwlafs1z7C3sh2XfFrggxHPNBT7DKIu82aGzB10KWzwrwZzsT/eO1uOg4bTVWBcZ9mirX19mK+HkP1rSGsL4mhVRLpNQR1NphEnVaKptRdVeQ/F6yireLCWh1VvppmiD2/061xW7OZ6PsYFCA/EJATuduv8i2PBlGnH/3LGfeRgXfWQ+VBYsP+drGVdUVqNppGSn5Sl+Mo/zMiG9K6/yEifYsjpro7UU0wtTxX4tuKerZsrNaheiGf21pn2ihGmvLR2fzJUwykYJYvq42VNKSvd/y0Cb2dGPJzKGYVdAF00HLXGXLP7j3PohEi9Rx1XrAaaD9uuLNfP0MO5cO3GsGzTiQDbWHydyzw3w+gerjVoc7dFucZsoIleP2Y66oSgcqheIKO/xpaLTeos1XkY4Dbf/us6ezaYdfkmWD+Fn5WZV9SQsFju/GleyM2XgW56SoXbmcqTqrzxPgpGS7+UnAqeSN0SWb/hLjJYxp9EJ+jnpESS3N6LbSBsw4RuF37/TbeqQG53hrKb37B/vXXOu+1knmej5J7QFCYdO9f5XL0MjI/Tql4XIeVkbr6rOp+lTvaWH+i1gTISWMkIVplvitMPmM26kMWgPRKjBHXGdlREs+o1qS0ndb5/+UgJg8ADSBouJaYFdkcs18NAb7jd2WL3PM58cD320mpuZFjrvB
Content-Type: text/plain; charset="us-ascii"
Content-ID: <03692F6773F30848B207CBC2BB85AF7C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d5b6f9-80aa-493b-505e-08d86552181e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 15:04:13.3591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lf4prmkYevylnG4gReGyy6e2lxoSwbG4lOC4EzTse2vztV6NZ86Zl30rDoe4Lncbb4fgPDL7W16AYr+HTzJStA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_08:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2020, at 7:49 AM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
> On 9/29/20 11:56 PM, Song Liu wrote:
> [...]
>>  +static void bpf_fd_array_map_clear(struct bpf_map *map);
>> +
>> +static void perf_event_fd_array_map_free(struct bpf_map *map)
>> +{
>> +	if (map->map_flags & BPF_F_PRESERVE_ELEMS)
>> +		bpf_fd_array_map_clear(map);
>> +	fd_array_map_free(map);
>> +}
>=20
> Not quite sure why you place that here and added the fwd declaration? If =
you
> place perf_event_fd_array_map_free() near perf_event_array_map_ops, then =
you
> also don't need the additional bpf_fd_array_map_clear declaration.

Yeah.. I misread the line number...

Fixing it in v3.

Thanks,
Song


