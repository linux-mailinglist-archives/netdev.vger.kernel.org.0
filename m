Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA1145EE9
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVXC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:02:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33740 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgAVXC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:02:27 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MMsWdc004029;
        Wed, 22 Jan 2020 15:02:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S3du79657s3d2gxO4TUnFjbv4Gq6eANunNCVpmZREiw=;
 b=VCu/aGHx8o/MsI0LKj/4cjuEkjxiMxJB/XBE5UTrmiIK0w8FlpkwA/IaTniNoWPgqYlP
 CDBqmVgs/ilF7Tyzro655I73uk4lfGCVqY64AEc8gBnCIv8uavgikP1Y5wlDw/t5M86M
 DLaxEAc0qr8eTUFpQCeDSRZgU+lRO0GTHY4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpr4kaa1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 15:02:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 15:02:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFI3wXavl0wPjv5Q5UC9eqpNJSQKRJaoQCtFAPO/rTdv3jFfjA7/6kwxplyK+Q/gYqKoI7OEzoPhylYqqrAVIh9W/QAKTvezTaxKNK3s4hobVMPJbXeJw+Fn3Pt7sKqSStTpx/YZKfoQ0iszi+jFuVkMzDjACV8r847xUH0zaAyFhraI82ii1KKyg4u44f2lgyqh0SkszVKrEVII6k0JjbxaWQyHAuIrXjZaAv3Nx6eAo/Nq1NcsILqfpuE4kG0NMlP+MRQoRSP7sa+9OIRQZelMSPXYNJXP7JiaCXBIaqn+wnZbE+JBqyCaldtfKHyduPZLDXlkx6gzgK2FYHxWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3du79657s3d2gxO4TUnFjbv4Gq6eANunNCVpmZREiw=;
 b=ShHNEHJ3Wq1YKAfUcSy5IhKpu/IVKfpoSkYdukfx3VxYF5fxWRkNvMGaRQgfPrXZq2LjiEeaGu6D4NvocMf7LOpJxQGJ7xM9rOWG0txqxv3m4SiG/ISR2Qy9ykLvF96zwNzIeEwckD0NQ938nQlnpsBk5MZY2MZbtF/K99YUTbrK0ZZr5GKJ0TH1oVNFTgSdt1y8cVfRe1k51YeKRHOXP/CEI+FsDqKjInS1dVezT9oH7FTfpIzmz1VHeLVc+Sv5Vt5Wpi/ifsax3BStvd4XJdsaJEJWnjT9m3sy/3q0JH9e7edrSLgHFWOaYVkHcR/4CWL6C4EieTtRFYXkd1W/5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3du79657s3d2gxO4TUnFjbv4Gq6eANunNCVpmZREiw=;
 b=AQi8X9YA8s2tN29KJ44bthQ8gWVmWBDK0MTFJ7zJlvHU5LqZEVkRfmk7Jg9R86TSHcCSPyIHUyM+lM5hM6rtmZD4HRG15Ku1nZQS18sUF/WrAd2XtzFgxCtqZ/EjapbyUsMZyjP//n+iUDP4yX3wnB0yDMPVzIsUJUocG8cUTIU=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2575.namprd15.prod.outlook.com (20.179.146.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Wed, 22 Jan 2020 23:02:11 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 23:02:11 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by MW2PR16CA0032.namprd16.prod.outlook.com (2603:10b6:907::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19 via Frontend Transport; Wed, 22 Jan 2020 23:02:09 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 08/12] bpf, sockmap: Let all kernel-land
 lookup values in SOCKMAP
Thread-Topic: [PATCH bpf-next v3 08/12] bpf, sockmap: Let all kernel-land
 lookup values in SOCKMAP
Thread-Index: AQHV0SS29qR58PVSE06oQYWWHrhZC6f3TaaA
Date:   Wed, 22 Jan 2020 23:02:11 +0000
Message-ID: <20200122230207.p7btuiduvaty7ped@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-9-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-9-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0032.namprd16.prod.outlook.com (2603:10b6:907::45)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0c8b855-10c4-4239-9073-08d79f8f1cdc
x-ms-traffictypediagnostic: MN2PR15MB2575:
x-microsoft-antispam-prvs: <MN2PR15MB2575A5B4E660151BA38DD334D50C0@MN2PR15MB2575.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(5660300002)(478600001)(81166006)(8676002)(81156014)(4744005)(1076003)(64756008)(66556008)(66946007)(66446008)(66476007)(4326008)(6916009)(16526019)(316002)(86362001)(2906002)(71200400001)(8936002)(6506007)(54906003)(186003)(9686003)(7696005)(52116002)(55016002)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2575;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VRMrelCg+vYLV+YlTpmrDiVyywUruGgIGdPMnfHbHyQ2Tmuvvgmrx0bVXBrcAjdw5GgTqD21brQLjinOY+GUkxwz8bm2YokFyQ6k46fg0U+4V94VKlllxTX0YPLXR/zE1wGIDLK/bgnV8OOq/NoqGG8xkVIxE17JrEKNZWc9OXVHdHXTsKMTVs36udw/bKM+++NLndHdE+rDid/u1sr/lnSWhIDgqXcqK/JEezu0xY4VNgFcG5KKVZ9hWPJzQqWdkM02bss/56n1OnSOpFp4NYAELqNfMv1AERsV5Rdiwg1zvmyx+qbFfmDN7yg76f+atrd6v37OHkWL5LniFwtpV1O6rMDS9p7hTy3eh1FwuzNbE0hYZpT/ZQ+BU9j43+dGiYUd11kmv8Ag00RHN8GmC3A+9Koge3Bck/wJUakklvd8tNEoJcnfkXKNC21LAYOh
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89C3A2DB63643E4EAB0CF770588FB3AC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c8b855-10c4-4239-9073-08d79f8f1cdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 23:02:11.5247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z+tQvnPdwt2E/3Owmc0CxhLvfQ7I/AQQ/MnaYIOl47rNhiK4/gbhjklIiq7+omFP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2575
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=591 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:45PM +0100, Jakub Sitnicki wrote:
> Don't require the kernel code, like BPF helpers, that needs access to
> SOCKMAP map contents to live in net/core/sock_map.c. Expose the SOCKMAP
> lookup operation to all kernel-land.
>=20
> Lookup from BPF context is not whitelisted yet. While syscalls have a
> dedicated lookup handler.
Acked-by: Martin KaFai Lau <kafai@fb.com>
