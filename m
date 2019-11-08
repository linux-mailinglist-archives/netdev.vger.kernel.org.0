Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0008EF40C2
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHGuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:50:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41380 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbfKHGuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:50:13 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86mEnk023718;
        Thu, 7 Nov 2019 22:50:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uUK/lGDqYCZArwJmwQUFDD6ir+e8r6I8OaK/It/cnD4=;
 b=W2PFnwC21iT6/9tcPZxgk042+UOfZQbPCNQ7usACVrPmjs1MLTP6diUKtyfT8E+oXkMJ
 MNHrxoiyOiej/hVEM86g8cwoTZhYl6oP1ittdcw9aUVG0dyFHSE5c/im+U9MKaI9aH/X
 YBYy14aHWkWbb2BdaMsTq96cXtgjV3KVdCY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy1x0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 22:50:00 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 22:49:59 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 22:49:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbSsXRinRx449Vk8QvWiHM6VvecYWNeqqrsGc/txYXww8ViU5MuTL/Vvyy+jtFRqnpzhro55o7CfQH7XYDr5tVS1bH1jF6rZ4hjDdveV5Dec5yzBcG0BvzmcnH4o3hbZFXnJtvUttXzFOgnrOygbiEXEMgqu8GaVvCsaRf/9dbubg86D7vAfsNLNvrEqpr145HX9cbkRs6FcZLI5YlLncQ5foUQv8iRhFAXzIA6ulwlki8WUldHPlAbUrIIZNV0bJjvtHJQRHuTTNAPC2elJLYEnDuHN2rcE7+uKu3Pb+qoZPVRSOoRQoZZaCa8lVFHW3E9Kackw0+LjFCi8mnl70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUK/lGDqYCZArwJmwQUFDD6ir+e8r6I8OaK/It/cnD4=;
 b=k9hR/VmvkQQY+863yI2tY/tdsXghiC00voO+rHSXUEuPk3mSxMyBN4Ba4uu4aksYmTyf475NBYN0M5bDDEqGvGOty2LCETJiB1yke/0WDfybSEwbduzx3Mnv88ACFDZrTv08uartW7lbrUlbio9l/3IrKPkKxMj8w+OJTG2yR8j8JmN0eY85b0ZHjsI61ndMPRHv5aVRRT6ueLRGhmp/9m3Qs9TJoIBGLD5Q4wAfEhHX+iEkoSSh/Zumv2Ghhve3x6TDFK+ltzVoa0DJYQLD8s+oyE3/Hk36YQdx9FBbxivNwAWIM11+Lwhoe9L/W9Xo3hcbHddPxZxbo5sIZTNxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUK/lGDqYCZArwJmwQUFDD6ir+e8r6I8OaK/It/cnD4=;
 b=TMM9/fqHqo6irXH2oLoVsGvwRqLgKbrOvTUp+eKjlssFU4KjzLpuZTJS48m+vdLCUjrhAiUu0Q8sW1kdBqzCs5B8ZrsykHbJyJ6WpYKLJY83yZR7O1p97ie2h1sIy0F3FS5YToYIbFv+xkTOJrjzjv78rUzNIzuNH1Tde/dqODs=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1503.namprd15.prod.outlook.com (10.173.234.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 06:49:58 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 06:49:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add BPF_TYPE_MAP_ARRAY mmap()
 tests
Thread-Topic: [PATCH bpf-next 3/3] selftests/bpf: add BPF_TYPE_MAP_ARRAY
 mmap() tests
Thread-Index: AQHVlev4V944v8tgGEKz9ht6ThJmI6eA1aAA
Date:   Fri, 8 Nov 2019 06:49:58 +0000
Message-ID: <06B57C22-0537-4A3E-A7B7-739BAF622BB7@fb.com>
References: <20191108042041.1549144-1-andriin@fb.com>
 <20191108042041.1549144-4-andriin@fb.com>
In-Reply-To: <20191108042041.1549144-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3864ba30-c42d-4c5b-a1d6-08d76417df18
x-ms-traffictypediagnostic: MWHPR15MB1503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1503E9B0EB98BE8AB5257193B37B0@MWHPR15MB1503.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(39860400002)(396003)(376002)(199004)(189003)(66476007)(66556008)(7736002)(11346002)(478600001)(36756003)(6436002)(558084003)(99286004)(229853002)(8936002)(256004)(186003)(6116002)(4326008)(46003)(2906002)(37006003)(316002)(54906003)(6636002)(81156014)(305945005)(76116006)(50226002)(81166006)(86362001)(76176011)(6486002)(33656002)(53546011)(66946007)(66446008)(14454004)(25786009)(446003)(5660300002)(102836004)(6862004)(6246003)(71190400001)(6512007)(64756008)(486006)(2616005)(476003)(8676002)(71200400001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1503;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K9UcjIEkDm+I36/tcTuRcvL6Fa5FSEEBse+4ctx+oXdPg4G6rOcsU8cbVSY99wCUd80F4dhl2/JyfHYGgTkhjfduBr2ZLh7di7FKwCZy2Xlc6JH3TdKMjlLNckRzxAt8Aatk86CPPMVkSUNsrQzEqhxHpTqhWUUo2e9UinRijhEzfhjvPHtVKfKOEZLWEZJui5N99BgBnMrjwxfPzn+eluqB5Hg3IQ+EhniVSUffe2C5ABm3mhpRJnRdQ1U9kr3QhEeUEY6VYoeaNZovSa8ipzUDF/jwWkVBTmudYp6rzSmdMUA1XMkDmN+1ZE8XnzLvsVe0Hs/6xGepQ0pvx+YTl4gd8CPLU0SVQuEJ+8cdCKZsX0eSP9iOnm83D3bRfyNS4/Bl8Mnux2abbdCen+XFtas8yRxgUHYsUz+O4r5YoO08/YXWsXmIKPVoM4VJIZP6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A423347E0DF2D4B900E724BBB324499@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3864ba30-c42d-4c5b-a1d6-08d76417df18
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 06:49:58.3884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2smmjdN1uCHZNJAGaHZw43WO1FYGRdoEiOTRdUzvGJvIG7a4+VGqX7CcCxpXSSafO4763VDcCooRj/1bRH9gBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1503
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=546
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add selftests validating mmap()-ing BPF array maps: both single-element a=
nd
> multi-element ones. Also convert CO-RE relocation tests to use memory-map=
ped
> views of global data.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>=
