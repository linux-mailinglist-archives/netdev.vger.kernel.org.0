Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C77F4112
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfKHHNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:13:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9158 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbfKHHNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:13:14 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA879Eu3011471;
        Thu, 7 Nov 2019 23:12:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UwOQGkiignE2TruUNZEEYN+mH8nmjjuc3DltenxTYSE=;
 b=jtgHhGqfnltL1U2q+Q3/oA7Vm7C8SwbJpkhjtPsjO3fB2QMgH2iYj74WNjnAY/zGelne
 UrT2fM2AIsYmenoD2xD1bbnOysnCaNLSHWwkS/J0X9TYpcJdsh5eQG4nTU+O5sIv7INR
 Qp2nQvcTRJ3ROd5dQzG7J0mLvL228HEa1gQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0sr61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 23:12:59 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 23:12:58 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:12:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gk4PM0DB5JsoqvTS8g4gmITkyepinEWt18T2Q6mp6yvzmPia0V2kEjOfYOdD74WCCbhqtAVx3yJumvcRPp0OVxgR1Va4Qp44ZqhylWTwmlgIdy74A+Sdtp7SUKQGFy5y+bPq3J6CqDFfiqQpoxOi8byUJZWOzGRgJZhmSlWUWaogyFmLFaRmApdeedxzFs0aw2sYzLm53TziB4JzJ5YmhSJkDohDnao9Vk6mAJk0x/e31KdSeWnRPjJkliDghu6vhfO2459hNwhc5buuHL227WRaMF0vC2bUaIyt92p1kNwjDHxkzI4QwmiYGtJbsaky1QEcRJdDtunRJxOh+ggs5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwOQGkiignE2TruUNZEEYN+mH8nmjjuc3DltenxTYSE=;
 b=n0SFAtuQUpcGH9CroXGIt9MDTrdx6OqV8o0F+LjGrmX875ww283BDyaQTphN8jvS7TNz3/slbGbdLwZF866nFSvkv3oXM4T2uhytZwuEDID3Q+mv+Aj9LWhYF8tkMGW22C6D5ZtDxM33fo1PUVrVIypEgu2i2p4xlS53cUNZ1qo6rTVJxT5wFjO95SU4xWGqJq1Lkx6rrFVRNfQKzeSchhu2zq0BkdtnZq84UM+gC/dPpyasyD8+YsNkWGnGKlWtKpNx9SNfRBzu9963V7fSDu7qzYDR0eMzVjqHf/qfXQTIFq1PvkFvu5P9NEjJp48iKdJ6DWKdHgfjtJ/vlDmkrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwOQGkiignE2TruUNZEEYN+mH8nmjjuc3DltenxTYSE=;
 b=LWLdWNEfcGOwtInW3Bq17fvE6UbDeQ9eDtm4UNlwurlqSf3f/QCdrVLIRwJmSDkHeAQz5mjE3xM7ENdaAkoHpB3KlkHCRBtmYX04QKaBsg/DaxKlFYBQ6awTwnnCP6UwQ8RoWuTSNKQ4xgUP4jLsN7p4EiZKNq9j92eBl+ZLzrQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1696.namprd15.prod.outlook.com (10.175.135.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 07:12:57 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:12:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 05/18] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Topic: [PATCH v3 bpf-next 05/18] libbpf: Add support to attach to
 fentry/fexit tracing progs
Thread-Index: AQHVlf+CIR8C4aHsD06MVQZZfsiW2KeA2+WA
Date:   Fri, 8 Nov 2019 07:12:57 +0000
Message-ID: <2F2B7DB6-DEAC-4F04-B6C1-147569220BEF@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-6-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-6-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f1f1f4d-fa11-47e5-92fc-08d7641b150c
x-ms-traffictypediagnostic: MWHPR15MB1696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1696E5EEA9154D958298E23DB37B0@MWHPR15MB1696.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(446003)(11346002)(2616005)(5660300002)(25786009)(5024004)(256004)(486006)(476003)(86362001)(71190400001)(71200400001)(36756003)(46003)(558084003)(54906003)(6486002)(2906002)(6246003)(4326008)(8936002)(305945005)(53546011)(6506007)(478600001)(316002)(81156014)(76176011)(186003)(6116002)(102836004)(50226002)(7736002)(33656002)(6916009)(8676002)(66946007)(66476007)(66556008)(64756008)(66446008)(14454004)(6436002)(229853002)(6512007)(99286004)(76116006)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1696;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WokWhfNpZXKQ7lmTBKEN7BzETcQHunbu58MPhmN30FxTFK2+VAGqn7dkdJvjLARvf+TUpf8Suxp/jDHamt8p3eF8CwzQ+9Z0+GZPhBnLdsC6yDpJt0jFtGr7fxpSw//jpkoiAg0vgZA9ZlRFmM07Tqa/QhwHRDTg61yp0X71brVoUqrSG5NwAxSpuu75AsGwu8kyvY+umFTiVwcXlDfNGd+uc3qQwHRKjw460ZY0oMfYU/6zBC9pKr8oCnBVIwZkDqOKhZipsFctNJjtZT0VcMj3PEe8B71+cNfwHxXwY51U29jKhxHy8nonfbYw7ETgf5LX3sPP8nuWLCvzk/XWaE4t9zQBRRhD28Tud3uDyRP3BWRSlRoDVK2KP8NAJmEP8RKkKjMkmYpJ+MTJ7jj7DNJviSJ+951HRSvhnfd+5EVHrhqwZ3BcgsmYn8916FCV
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B752068D92DB9B4BA80BA3EC313F0BB7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1f1f4d-fa11-47e5-92fc-08d7641b150c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:12:57.4575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zODHD5mKSN6ErhgHzRoC9Fs8eyElZTTyF5Ah1FOAX84UqmklipYCg4RuY0Ao+llj3b8nPixvZRh13JYLjTZX4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=583
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080070
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Teach libbpf to recognize tracing programs types and attach them to
> fentry/fexit.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

