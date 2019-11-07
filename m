Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E68F3C39
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKGX27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:28:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726118AbfKGX27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:28:59 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA7NQdcY023830;
        Thu, 7 Nov 2019 15:28:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J1YhkR7V+mcZJUwsf0RUJBGELrqZInL7derj2/twxcs=;
 b=VH0evexf6xvpPWRRjJxc6kqNZMRIa88wxDxS4cTe7ELc89BXQOiSxG82KGWB9oNCBpCq
 kAMxRrbWZR7aaLLGit8yuRoRfBzr88kzYrViE5ywBvQp9C3kba0YhLMngcoM97bIJcDh
 BYhFj8s3Rk5LuBNn1SpEdZceCNFs7PtB4nE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w4tyjgp5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 15:28:43 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 15:28:42 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 15:28:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUVyGulftl+wr29NVgTr9ZqOUTLXLeNmjdRiO8YUXO6Z/iQZASzGOa0bufcmllY5yKYtqsG2/70ngg9GX2pUhhmj0dyMxvYqp9JTcdC5J3r+xCdEIV2W777gLczX6lDZT7G1ZG33YU8cu0PRPenmm4l+D6VG2/WBVQ/rgyFh4wnWoIHG5oFRucF4r6PDIDIJ/fY5I/apxgBIpyNmPnyKfEBhZWptKnQVw02a2ch8IUM/vITpPDkONt9vpt2HeQ3F5m3hK6N5ooswJ2dKzZritjFVtQ6jbkgBHsW2KXGG70v8zorohMUe8xPcBPXFs2uizVT+g0IuET3BYb72UY91Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1YhkR7V+mcZJUwsf0RUJBGELrqZInL7derj2/twxcs=;
 b=CW+fjpSFAbdTinRFz0UqUaYXvJt2ROePY1zK9MygbixMgMTrV1aFUiiWAWya4PyH1XFVykYtARcJvJ1oiISZfPaU5ecJeNmO3bsjA/hqpfeLs5yXkQEX2luFWAOvIZkN2PSm1RWEKXu+ReksSXVRn+n6+yI1ec5CF+AHNmgykQUwOZizf0OGyO7RI+5EYDVqN/ry75aaXoy/FoHio3Coku2xmZ7yi/EwZMBKwpdqgkTAx/dnvj2zDca5Lh5vPOKPAWQogZM5/f0nyrWIxP9hmcUOMCcEGg2wzLRRu+41aP/oBS8baWgbwGjQsVEgGsfFgftt5xnLCxQ5EkwWzVxm8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1YhkR7V+mcZJUwsf0RUJBGELrqZInL7derj2/twxcs=;
 b=MR1Z66LSZPL0YmNnLZ0E3Xnezh1iqLoqLHBjgCv3VgVhQunCVhEOnw5VqLEcwTJbfplvC9RPSvlDhls9aLn6E7by61bkpa4T+nn1jvp3BO10QA0yrYLsOMjBW8pPbtcPkGPGR2YqdAKy1h9WyR0Xq12wpi8yZNSr+V58YoQFQGM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1503.namprd15.prod.outlook.com (10.173.234.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 23:28:41 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 23:28:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 06/17] bpf: Add kernel test functions for
 fentry testing
Thread-Topic: [PATCH v2 bpf-next 06/17] bpf: Add kernel test functions for
 fentry testing
Thread-Index: AQHVlS7qIYReVB+/Q0mffTpI5Hn2K6eAW84A
Date:   Thu, 7 Nov 2019 23:28:40 +0000
Message-ID: <B3C921F1-276C-4C99-90F8-7FAAE089B80B@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-7-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-7-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1737581f-7f9f-4bb2-3c08-08d763da3949
x-ms-traffictypediagnostic: MWHPR15MB1503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB15034D438FE9467484FC23D3B3780@MWHPR15MB1503.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(346002)(366004)(396003)(189003)(199004)(11346002)(66476007)(6436002)(7736002)(478600001)(36756003)(558084003)(99286004)(229853002)(256004)(8936002)(6916009)(186003)(6116002)(4326008)(14454004)(46003)(316002)(2906002)(54906003)(6506007)(81156014)(305945005)(50226002)(76116006)(86362001)(76176011)(6486002)(81166006)(53546011)(66946007)(66446008)(25786009)(5660300002)(102836004)(33656002)(71190400001)(6512007)(6246003)(486006)(476003)(71200400001)(2616005)(446003)(8676002)(66556008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1503;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FUGgpMTDnFjyLkLLrBThpuz1iA4GLKphdVt4vsryesZDIlZTwsP8lN/K3XuFSCNnefIgGxt+yJRGPg75GDWvQdGmTvdbaVq6i1Jro0VFWj5yI6NwmmwPTX0ZB0GECvtAkjNE35tD16JsqcNJgukBBU4Zdm9fKJehWGADVz7PpvLyJtN3fNkxQYhx+BK0hnIPq2tZE9hX+vmxF2EV8xsEDBpjI1WhkcPzvHS6qo2f2XGq9L7dZcOBMe3vjN5JD2fLtnazW8i0Vzqv7s1WdUo1GFLoaV+n64/TCIp28KHxTgc1ahLO8SCCqiYnsLQYRowGBOFvCwnk+mijKF1rI/W7FBYaDmGlKfoNURgIU4xZxKmJxwqxT6kG/wQ928NfmIv4xM8giCDkvyFdLGWT1EJsHWXEcpbXrgom1OD/nuzyyLfoFnjHTHygrQIXBDKeoRkE
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B9208CF9A3400439D7B6E63C37186F2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1737581f-7f9f-4bb2-3c08-08d763da3949
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 23:28:40.9286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ClGzzmJje/2Is1W0MZ6/CAE6muDB/R1zSxyqg3hKGpxvV4iuUW39ZA456y4nrGI9d722QUgiDYppNbucFGX48g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1503
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=882 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add few kernel functions with various number of arguments,
> their types and sizes for BPF trampoline testing to cover
> different calling conventions.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
