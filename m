Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C24114C79
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 07:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLFGzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 01:55:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbfLFGzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 01:55:39 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB66tAb0017743;
        Thu, 5 Dec 2019 22:55:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Y55UDsezzaZvKIAgdJFkTgMIrP9jqbtTUZmRemsyT6A=;
 b=K0dKJ3ifY6/rd/MEgd/HMEmU6VYPM0IFiWxAFG6Bt5NXE2At9HxZTE4S62hmy/hVvHKC
 1jt/I5JWJgmCDrRp/DhUMCIecl4vMmXmyQODtYVEDFUM3HtaU2sIeaIxnsN4ZHBisSOs
 cDDxfRYKN40efv/I4Rkpc2M5TQQdNKHDFU0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wq3vyv0sa-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Dec 2019 22:55:12 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 5 Dec 2019 22:55:07 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 22:55:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0ZNIk3GYEcCRbc979wt89YLgSOGIsNwkypNMuTkAkUwBSMkO5zl1sv3MdAz6O5QxqrROFpSztk5PNattYGLdISQC/2v7TB/bWW9Oxpio9awWPCrS8ETEHEkO+E0vlyxESZUlhFiD9b5pSjJq3wxjboXqMIqRo7cmk2IcQTrKRFqyyWhsPxEsU8NupDocDS1cd0ArTXh53fKqdBNUZhW4Y0Bb8CN2G+392ac9aG1Z6/2/6bAqWE/2lcoG9oMnF0M+R+K3chqTjnFM7X7FWNwEyWBfCMfeE9G3oKsht5Pwo+n+aq7SGAZiWoEEvW6SBtwwjmxQIveFV+Ly24up57rjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y55UDsezzaZvKIAgdJFkTgMIrP9jqbtTUZmRemsyT6A=;
 b=Jye6q2GJ/82ooNFD58qi+6NpchQA6VjpKz8VVpDYcEULwVrxu4m5LU5bbZxzo06Vv6I9Al3lLgdDPv39OQ9+Tx8X9UWNmBsTN2pKgZcZhKC14UhFg34qbonchxAERDXo/Ke5CH4pIILkhmJM3q6QpSIKNXUioiqRRbWONpTcdg1sAPdoxPpUX2UkZr664BO388yHTCmnAGkM4DL6/5/2cgJrJyLCZujdcXqetb+WT+OXiArsauV8UxP8H+QtRXWDHshZMGm2YfpKzz1+iZoQYETRb5kondbe5XK769b2oQEBgIv1CQBj0LK3xAeUpnys0hZvuKLD+GDuyPKFdvdvNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y55UDsezzaZvKIAgdJFkTgMIrP9jqbtTUZmRemsyT6A=;
 b=gzyNrOHVQYGR+mf3RcB15AlyfVlCFshBi28KvzZBuOj5+Nyti9TdY/Bj/JMIe9rjgON6HO9W6SebSEVdWt5JuKYIUF6/rfa7m/isYWzxBTrsCpHShIwUWPNwcodFokkDwUchOdD3VeVOlapKIx96xqLzYSxpkAqjwmDaI0uoXqE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2605.namprd15.prod.outlook.com (20.179.145.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Fri, 6 Dec 2019 06:55:05 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2495.026; Fri, 6 Dec 2019
 06:55:05 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Xu <dxu@dxuuu.xyz>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog
 context
Thread-Topic: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog
 context
Thread-Index: AQHVq8n1PpTs4XsEb0SDfCAf1CVgp6esrI4A
Date:   Fri, 6 Dec 2019 06:55:05 +0000
Message-ID: <20191206065456.6pqjxdvldxiab6t5@kafai-mbp>
References: <20191206001226.67825-1-dxu@dxuuu.xyz>
In-Reply-To: <20191206001226.67825-1-dxu@dxuuu.xyz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0065.namprd07.prod.outlook.com (2603:10b6:100::33)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1dcf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b260ee35-5329-45a0-e5e1-08d77a193921
x-ms-traffictypediagnostic: MN2PR15MB2605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2605855620ABBDFE2371E0FFD55F0@MN2PR15MB2605.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(39860400002)(376002)(346002)(366004)(136003)(189003)(199004)(86362001)(11346002)(25786009)(6916009)(305945005)(66556008)(6506007)(9686003)(6512007)(186003)(102836004)(1076003)(66446008)(66476007)(5660300002)(14444005)(66946007)(8936002)(478600001)(81166006)(81156014)(6486002)(8676002)(64756008)(71190400001)(33716001)(2906002)(71200400001)(4326008)(316002)(229853002)(76176011)(14454004)(99286004)(52116002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2605;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bI89zEhBhw5WZAxR1Cq85F9Di7TjsVjpOs5Mg9PRLEB7G/5Ri8DnrTHziPco5Kwg0UY5aVNPiYn/AQ9MAeQYXbOhl5Iida0xEo/ENd3gfhIAZkNDZUGgfvGzR1GMPyhqsZq5Vnn4nG3Jx3Nf7pFrheVtzVdNAW2JFe/5jMWktH5YHGhccQhKJmjWTUT14c9iyJPRxglK/y3mB5Mv9aVYBPd3EY+8oabD7KKsCWKAhzZn6iM6kp6Qhi6zshutqukT5H41+tSNylAdaY4c14pZ55of6bW+Hobx5izQnnGRHdb1h1BECHpKmZ86pIxzrWGgEgFzjCtkosIElGErpXuH4vWTnZYjAtNS014Nb0+AfPmQvtSUHEzPUKI2mpeU8BFCdhcuTzn5oZKX60c7sj7JPuzsAXm+Txbs6+iHvMaCE6zod6nXNH4r+NFER33/D6+E
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCB73F34274B38479D385E9FF4C6B1DF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b260ee35-5329-45a0-e5e1-08d77a193921
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 06:55:05.1016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tLEnHYq4Wf9DoND6x6Hh7yyPv5Uk8RS6razaX0EDReNSQn+WKyrTDmUNt8cA6cx+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2605
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-06_01:2019-12-04,2019-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=900 spamscore=0 mlxscore=0 phishscore=0 clxscore=1011
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912060059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 04:12:26PM -0800, Daniel Xu wrote:
> Last-branch-record is an intel CPU feature that can be configured to
> record certain branches that are taken during code execution. This data
> is particularly interesting for profile guided optimizations. perf has
> had LBR support for a while but the data collection can be a bit coarse
> grained.
>=20
> We (Facebook) have recently run a lot of experiments with feeding
> filtered LBR data to various PGO pipelines. We've seen really good
> results (+2.5% throughput with lower cpu util and lower latency) by
> feeding high request latency LBR branches to the compiler on a
> request-oriented service. We used bpf to read a special request context
> ID (which is how we associate branches with latency) from a fixed
> userspace address. Reading from the fixed address is why bpf support is
> useful.
>=20
> Aside from this particular use case, having LBR data available to bpf
> progs can be useful to get stack traces out of userspace applications
> that omit frame pointers.
>=20
> This patch adds support for LBR data to bpf perf progs.
Please re-submit when bpf-next opens.
