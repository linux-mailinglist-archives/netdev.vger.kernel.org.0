Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C371179A3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfLIWqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:46:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8302 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfLIWqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:46:07 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9MjoZP021179;
        Mon, 9 Dec 2019 14:45:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cqf56TMBRmeeQ7BtOTMrWyuglaxDDtUQct1vSkwaAzg=;
 b=GTPiNmGIjwjL0sM7vKaLGSW/ZMIKutotwDbqozBJLVOGP7rtAQVA/mVx0bRMpKihVXcG
 galT4J04teoinn6CP83RX3WGMII6Z4VnAQPBHUp7w4AcBIkC49mBOUHsuncAhX4vwC9D
 p/GUyRBq32munYenLV7YbcOyPmMsFdsQVE0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wsu71989q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 14:45:54 -0800
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Dec 2019 14:45:16 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Dec 2019 14:45:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 14:45:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jM2wGN5nyV4GYTTj5fjYiRPdvMrm8b8KEYUeVmGnbbnIrdkmF0osC8iEfSs90D1zrmHT2BRKl1H7DRfPt/40EEXcl3uzoffQxSFZGUiRKLkig0Vu8RJilH1CpHmE+xrvFeqPZ5nY37j6A10gpZ9ZFKgAccIoab4cGz7TKMxtD1DduQxUmd/awfqOQDxaOf4foHZUCNb6VqDa644dx7tHxmLCSM5IYJF9Q48oypXrP2qjkNKLk+VmFwU5hoi2KtUeyprADXDtA9oHeOMWFyZg1JTldXUwABHYz7b0JyFkNXSkRA2tWzyCfPTSZrQ0v9Qs9KWq20+ZzTnVrf1i9A6u8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqf56TMBRmeeQ7BtOTMrWyuglaxDDtUQct1vSkwaAzg=;
 b=H8SnLMjYhyn3UfGcd/CnkxvxhjYHwjMl3dMj3Y2844d/r7mbnb6j/vB9YELAEoCrlmOmfyxbxPQ4bUkEtC14/yqgyelX2C01e25W4uezcT9o/oGwXt8M2NTN6RGqZORoYKLkMbRUOb+el/WCtBs1mBe9fhNbj/bpfl9z5Fvk9ENcmi6UF7d3q6WWdow6Qc/UGP+6LUxtbqUiuxVMexfitAK4ugodk8YAn+nNatjNH2SvXEiRuk/RaRXANggZy7BtDj/ss6QoF4L6edmo4QxvMcoDtskjXPO/Svt1yFC+ZFZG6qbCeX29VfAIfUXlMHjlsIwoXeh6GJ317jsEDCy89A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqf56TMBRmeeQ7BtOTMrWyuglaxDDtUQct1vSkwaAzg=;
 b=kpfgRx0SFNOJI5g2NrloiBY+QCrq7E8Snjui9n+ZVoOviDdg+fLRPcZXt+imReQftw0Xd9hFiaK9k8SvOJcZoB3Lfll7BlP1S9OifmCzwWlnA3zkElhf8SAT61e9LniAAAApVczOmV4XjI+EU0XwQvzHvEq3GDSTeXstDUfPl1I=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3582.namprd15.prod.outlook.com (52.132.172.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Mon, 9 Dec 2019 22:45:14 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 22:45:14 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf] libbpf: Bump libpf current version
 to v0.0.7
Thread-Topic: [Potential Spoof] [PATCH bpf] libbpf: Bump libpf current version
 to v0.0.7
Thread-Index: AQHVruG2F0yBBAb5TUCd37CPIGDdFaeyZtsA
Date:   Mon, 9 Dec 2019 22:45:14 +0000
Message-ID: <20191209224510.ca4glg42tvy2ivrx@kafai-mbp>
References: <20191209224022.3544519-1-andriin@fb.com>
In-Reply-To: <20191209224022.3544519-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0061.namprd22.prod.outlook.com
 (2603:10b6:300:12a::23) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:ba63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 481df342-abf5-47d2-0de3-08d77cf97481
x-ms-traffictypediagnostic: MN2PR15MB3582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB35828D9DEFEB7D084F8CEDF6D5580@MN2PR15MB3582.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(366004)(346002)(136003)(396003)(376002)(199004)(189003)(6862004)(6512007)(54906003)(52116002)(2906002)(71200400001)(71190400001)(9686003)(316002)(33716001)(6486002)(66476007)(4326008)(66946007)(66556008)(66446008)(64756008)(229853002)(6636002)(305945005)(8936002)(478600001)(5660300002)(86362001)(6506007)(81166006)(81156014)(1076003)(558084003)(186003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3582;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9z6ZuJLR8leuDywhe/+c0jUF4sviLhiTbKd0hdSBRIeBhQychzYEndagys+y/U8s5eie5zjlbC6fGcectdF3bsejDe9cL2HlEz+nqUzElJtXsMbSRpyCMw79YBTbfx6wj7u9HTqnNeTeVqSvJcTvqJoENg11NGb3W6ePEQYyIRm9P2km0BjPHFZS6nE4lpegxG+KfCvFUQ7dZfDAqqTWUVISthx3J+IlXni1JSSkdkEVjUDOIou0WE3HvBJ7Zo0r2HYLSw/Ks5a7c6gQC6+IQejYdZuVEZwrgID7zpUdQfTJEvhsSlTyMHKgLj/Q16P8KMUaSYqp2L6VnvD6JoMRyINsYFJvcjVskpje5pfcKZiLeP/Qi/e+fxd5vIMe4XjUIR20PDaORn1rTpDq5+WqCKigyubnuGF8rGVULUlsGiBxs6/tFCkYEbZu1HOjPte
Content-Type: text/plain; charset="us-ascii"
Content-ID: <95404BEB0CDCE94CB2630A1C629D4A3A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 481df342-abf5-47d2-0de3-08d77cf97481
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 22:45:14.0719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/8P/iLcZStmO1bXyMZKDkfwv31yRBApCOF4snfktKJJk1eMBkH9KU8SxerwZw+K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 clxscore=1015 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=622 spamscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:40:22PM -0800, Andrii Nakryiko wrote:
> New development cycles starts, bump to v0.0.7 proactively.
Acked-by: Martin KaFai Lau <kafai@fb.com>
