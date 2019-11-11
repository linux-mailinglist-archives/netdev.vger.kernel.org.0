Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F818F78FD
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKKQku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:40:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24768 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfKKQkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:40:49 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xABGcDva018455;
        Mon, 11 Nov 2019 08:40:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BNSLygC7vaO1h8Ss2S4u4ievSqBY/ePaxsgmtELrOnc=;
 b=p5fe6qE/vh27SrdIrQ0p8tLbMpHQf1dotxw75gN7CSulakQhZqOHpsAmLMd97Zt4QsA0
 Sg8xwHPFViLMf6BkGYL2uwANbI/L8xyTcwwtQU0ZqpbS0e4FkokX0a0/Q5fnCk4UpBxE
 E0NbS0nJcqSGF4b6Zr6IsCPe5VxJe75HcQg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5v5jswhb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Nov 2019 08:40:33 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 11 Nov 2019 08:40:30 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 11 Nov 2019 08:40:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9RvE7U1De/YhwYv2/k9kZbBcek4KPw7bHlGuLhhk6hWYfuPoR8WQeMvMpPnSg1FZSuj+JmRml5XMKwRpMGp1xtiGbHwjCpusuBJzQ7q8v7PPl998NFTTHm9TPtO9T0JoG/Z4XWDAgZQB0PyL784wltSsw+avRkqxm26ZbrXPWoBA758VtChkD+Kc+I6f+Rmket3qOmARQl5gXNnFHZIsEWJnEJPz8yoJ19BdQFY3yDZtoY2CS5jemIgfEV8l/QHmVfhCI7VqBP7oVDIyVMDYlIRS9zHJ3WIcRCSmQQqsHzPXja0iERvp0/XGSNHMNGKyoRGgYuOZjz/MC7VC1Dk+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNSLygC7vaO1h8Ss2S4u4ievSqBY/ePaxsgmtELrOnc=;
 b=bIIIrWZhlM5Pl6h5p7Z2BQA4drVulmfKnG1EOf8/fG0p7Nt0h36hELpWqpKM3cKZMbgXKpEpS6I9g+Klfl+V1/oQRKqmlYL5Z1An0+iRqWgzlLmCxm6t0CvuygTABM0dafQ975RJyZwPOu4zxlwHXBegDCJrCoH/VN3Kg54BhZ0ZctjeBjPoMJTdvI079I/66zQgaJiEEdM2aNbM0FiD/ly51eS2/2m+jcSwr5rFQwyj1UTkuoDKuS2ozkHYdwPuz/ppCnLkf1yykOtaJ76GVd1/gNUPSKDWfm3u7HcL35rZDlI0BUh5B+j5nZqzt1LfYGlXnZMDe1tBioKVdoER6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNSLygC7vaO1h8Ss2S4u4ievSqBY/ePaxsgmtELrOnc=;
 b=ZFSbnxvzWq0Rtq6hZoP+9PRIqri3QbV3tiVzzUTSfWCHnnz4xpsNmnY5MrKo5V7XXd8Yoi1gcZZLgtUZrW4UjcUaj5n3JnBaPCMlRkgjMyXDpCGS+LcS3q6/J2UULE/5UONwd1iXU8B414ttG7IK5K6XVeaJkrloJlNsvkjW77A=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1454.namprd15.prod.outlook.com (10.173.235.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Mon, 11 Nov 2019 16:40:29 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 16:40:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Topic: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Index: AQHVltSv5fGgsOJ7m0CeIYf1LWjTP6eGL8qA
Date:   Mon, 11 Nov 2019 16:40:29 +0000
Message-ID: <D7B3FE47-B8E6-4FDB-BB69-F8E3475FCBDA@fb.com>
References: <20191109080633.2855561-1-andriin@fb.com>
 <20191109080633.2855561-2-andriin@fb.com>
In-Reply-To: <20191109080633.2855561-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:1a5a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5d6bf35-5395-4761-6ed4-08d766c5dd0c
x-ms-traffictypediagnostic: MWHPR15MB1454:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1454A58DCF3D975DF17380CBB3740@MWHPR15MB1454.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(376002)(346002)(366004)(189003)(199004)(64756008)(66476007)(4326008)(81166006)(81156014)(66446008)(316002)(71190400001)(66556008)(66946007)(6862004)(54906003)(76116006)(14444005)(305945005)(6512007)(256004)(7736002)(37006003)(71200400001)(14454004)(86362001)(6246003)(8676002)(33656002)(4744005)(53546011)(478600001)(6506007)(76176011)(6636002)(6436002)(6486002)(186003)(2906002)(8936002)(229853002)(46003)(446003)(5660300002)(6116002)(2616005)(476003)(486006)(11346002)(50226002)(99286004)(36756003)(102836004)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1454;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ArJVMq7KS+UkPCd2Ze//ID6BEfcOyBqOIW4Efi3nkAKK4r3kV0gR2ChJ++5zqPMmkzfRveLzSstp+OFykHK+Dpm/cLU0anBQUBsFJtwVc/mpk8a1+N5VvolT2kqHsMoEcZ7WC9OSy06VC54ukNdiDPJWxFJsAIp88nddAaCFLz+shT6iYixZXptngzr9BVOjdSeWYbjJphtreTnofWIS2tmoOxktBdqNGQlQAfasoj0HQG/j5wbcYkDnxS2/aQxT1DVaPl0zCCOAhjGtOHdlpUkWtSfBYFxeTMs0TOZ3lV2mjKe1V9LPs3PemBZeSSk52OWANMI1C1rxjTcYSnhRO7ldyTY1fuouHlh9r4E9SmFtB2Ip/FACkkIsncKRsmiCaff51Y3UxJTw54GjpsIszu0SlDQnuI3KroG+ocFsm7PF01AcpJnxEELjVhv1aPKs
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7473AC7E2A857647BA551BDD04CF3CD0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d6bf35-5395-4761-6ed4-08d766c5dd0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 16:40:29.6235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UAScNDmngQuy5387e2BMtLhDnqUepDsi1h2UsiYEeO16Nxl1/2Orelfu0BWBUqWfvohyfjj2JeybkxYjBYZAkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-11_05:2019-11-11,2019-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=418 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911110151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2019, at 12:06 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add ability to memory-map contents of BPF array map. This is extremely us=
eful
> for working with BPF global data from userspace programs. It allows to av=
oid
> typical bpf_map_{lookup,update}_elem operations, improving both performan=
ce
> and usability.

[...]

>=20
> Generated code for memory-mapped array:
>=20
> ; p =3D bpf_map_lookup_elem(&data_map, &zero);
>  22: (18) r1 =3D map[id:27]
>  24: (07) r1 +=3D 400			/* array->data offset */
>  25: (79) r1 =3D *(u64 *)(r1 +0)		/* extra dereference */
>  26: (61) r0 =3D *(u32 *)(r2 +0)
>  27: (35) if r0 >=3D 0x3 goto pc+3
>  28: (67) r0 <<=3D 3
>  29: (0f) r0 +=3D r1
>  30: (05) goto pc+1
>  31: (b7) r0 =3D 0
>=20
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>=
