Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380C57155D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbfGWJja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:39:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44688 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbfGWJj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:39:29 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6N9axSn008386;
        Tue, 23 Jul 2019 02:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3Pw1vzE+JadbU5xPdKLuZsv21/k4JG5vRwKBpRWlG18=;
 b=mhXUM0leB8NpbiGAer0aNqrUpY3Z3HjBk2xgZeYEjTykIqb75Fk/giGHer0qKCDrC5jl
 FAmrinNpiOA+ta7Obh3mIr+JLTUEkInrjQn8PotZ3ayCw1//ajorCGOwXFGu+vKh0qJi
 InUav4veNlGeZevFmGI2SUUc4JxkSZVWdUg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2twjyn2c8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 02:39:10 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:39:09 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 02:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQqQ0VHd+Ve3hYg0e9orm4EIU2ffArqM0MaMzMx8KJfPdpTu8EMPeRhoESMG2twKJjPencW4Ka3N+EVtu3YTIcH8NeNpaF4h1DXSTcVnXFmSjaLiYFsK2ca4ZY5cv2iQ3ZdNfAC5evp1o2KHVAg7E0ADLK5VYH2oLFFflcUx/EHokZN0qDGQswh1q3wzVIIFcVQ2yBLOThBhZZNpoPSjvR7X5noEZz39Tk6tPfcyQOGl+IGk/k2lXfuJD0IBILXmNag6ZGJnFYJJwVRmTWiJ85x0KinR0AhqgHXhcT50oqfEWMkXW+F+e73DGxPIuoNX9dhB+XG2vkERp6HXlgWcew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Pw1vzE+JadbU5xPdKLuZsv21/k4JG5vRwKBpRWlG18=;
 b=A7w3QoHnDCqFrrJOMGv4vfXlthBb2XqRu6ehRV081nhM77RQRucdK/llZxQMQJhiGl4oEb9gdVuF+gKEufj9iNyA/ylrnbsg7Sn1EjSbJVYGHZZ0eqbhzcT7ZDoFhMhFJL3XI28QZdMHmrzocmB/Wjy5KIH80rtSG67AJS2WIxD9o9XLL5ATQJ5a2d7X0efVuZMGPWowPpq27/UI4DAXoa+RVEa16uSw299Gcwl+ijmojmvWOrtC5QR+BkGq+xQTFEBAjfulZOfQXj/KPgUhLDmwJ7MEQlT4/1cfF4EXn8YOxCT+CAvC0882cX/8gT3vj1d6pn7CuTXi1NhVAHV/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Pw1vzE+JadbU5xPdKLuZsv21/k4JG5vRwKBpRWlG18=;
 b=ivBnrbhcFIN6YupPZ/02Wu1ypbmOeIvj2x8iaAxgUVKEcnCeH1E8SsN8za/iYK7IsPUIB6ug613g5hqBbICRUbsJARMa5iwhQHQ8UICmGeACkCBlZjKRcL5/0dDLY8IwVwcwricbjbz09FiKzHCb2N+vsvZRA2gyjg/3hqF5ZkA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1840.namprd15.prod.outlook.com (10.174.99.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Tue, 23 Jul 2019 09:39:08 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:39:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/5] samples/bpf: convert xdp_sample_pkts_user to
 perf_buffer API
Thread-Topic: [PATCH bpf-next 3/5] samples/bpf: convert xdp_sample_pkts_user
 to perf_buffer API
Thread-Index: AQHVQQ9+8FUH9P1tEU2AYIRcjqpVHqbX8tKA
Date:   Tue, 23 Jul 2019 09:39:07 +0000
Message-ID: <FCCDE150-69E5-4204-8F7A-270DAFB5B5FD@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
 <20190723043112.3145810-4-andriin@fb.com>
In-Reply-To: <20190723043112.3145810-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:2cda]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e57037d-edbf-4af9-e621-08d70f519bfb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1840;
x-ms-traffictypediagnostic: MWHPR15MB1840:
x-microsoft-antispam-prvs: <MWHPR15MB184003A307BED602A7A8BAD2B3C70@MWHPR15MB1840.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(6116002)(57306001)(86362001)(6862004)(4326008)(5660300002)(81156014)(486006)(7736002)(99286004)(229853002)(446003)(46003)(305945005)(102836004)(476003)(2616005)(71200400001)(25786009)(11346002)(37006003)(53546011)(186003)(81166006)(316002)(6512007)(33656002)(76176011)(6436002)(8676002)(71190400001)(6246003)(14454004)(76116006)(66476007)(66946007)(66556008)(8936002)(50226002)(64756008)(478600001)(36756003)(66446008)(256004)(53936002)(54906003)(68736007)(558084003)(6506007)(6636002)(6486002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1840;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WfI+q2IjpBp7yfMQ5OIbCz8EIlnmLYE6ws+uzwMkCjqwUNO/WZpf6TVSLCzII98BjwFblAnExjgwtnuFO4Zc1V1okltSmu0zUuiA0cZnipGXVTG9Ntuckd474ZmFelY73yLUqOkWmy+L2wPAW9RjxVeP975WudAMYp9uzGlFgFsVfUtoUs4Scf2q+k+Ds9GElMQWPIM+RyFgj5hp1I8ZrvNDUN+qhp1spWYjKQih604z+RoOjqupMLgG2+gXKRbsQFRMyIuEKFT+SMz+IZIkJ3fjUMWHSQ6c3Lc5OcL0g8e1NqJgBwRVKvkoTEWst4JgIRAWCteI2/rCkhOOlU7N4jk01BtQzpUIYHp+MhPxUBZr25LCkxw8vTQyT1OmLljI1kVIeiZ5qwupKuTFOaXCQujFOu2KEzttM5oAt/5feU0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <846C0EC871B0DB4685E595DC5B35817B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e57037d-edbf-4af9-e621-08d70f519bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:39:07.7887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=723 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230091
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2019, at 9:31 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Convert xdp_sample_pkts_user to libbpf's perf_buffer API.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
