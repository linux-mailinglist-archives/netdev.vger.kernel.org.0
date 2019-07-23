Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8639271565
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbfGWJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:40:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21892 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfGWJkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:40:21 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N9bxAn009804;
        Tue, 23 Jul 2019 02:40:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cEXbXSvbihqUwIiAI8mCbvnMhci4S7d+uKSl5sPZVKY=;
 b=Yb5vq5cj5lsWkrSPfFPQESY9a71/RKduK5vzIF9X2CfQDlt7URWSJkJ/nVh1DDYI727h
 PG9iUiKEMKZAfisPr46kFlZdKR6wpBx0LxXBoDkG+Moputi4LHATvLrYP+k1L2YZas/B
 rr9hgrlAe0Fm/Y495xNlF+Yrr6BaP2rCoo8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twmcea1y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 02:40:02 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:40:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 02:40:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XE6PwzElhlyho7DsJ9BXMb5mAoD418ubs65PMpxSpGxf6MUTpCSVdVr1SGjzSnjMer96ia1UqmKSMI+3bEfJ9uI2qHoMKkfXRq6dvZ/91wwSMyqIZ2nA5NFu++genGEfkrzvtMVgqJQkoGVU23dkP+iKHYUSFJChCOVYC7tZ5mJ9BAsQnXEnq7FujGlzJZ0hgZlS4LGywLHpFN2UYiiNNQbRxhzACkN3wC1rIHJHwQdomfQD//qdlN4DChuKnTZjFYt4i2mpGwgwV/E8hu8X7ZF4YqzTsroMjKNxYiQd5toW9DRASQf28vVa0opSYntARG74IqQzH7lWWvap7pAu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEXbXSvbihqUwIiAI8mCbvnMhci4S7d+uKSl5sPZVKY=;
 b=POJvmenYLhh257YQP551dmqzy03UF/xdPC0aZK+QS9uX310VEKrGSDu9MJXo287auc8U5VCFN2N3tKot93Xc2V/FS0bAdBAXh3B739Vv+VTn8x/Y+RoC+fMx2E9oR/BwFvM42GIXyX+jPS7d2vgKL+bLUspZSjPYwZ9n7VErTPeo0w1LCO7Tt6BdEN/AE5aL4yI/XGsHpVyHidWCQPOHhd5hiBoju/nSNU86FAeap3dN0EvksXY9CJmBRo/u7d22uDKc33XeuZLEdBOwO/tWo0x0zNHAmy1HruJPtnP5Am/b5xMYiiZpdd/dVmAGcxKqTvqqJxTJ9gCEF4SaGggLgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEXbXSvbihqUwIiAI8mCbvnMhci4S7d+uKSl5sPZVKY=;
 b=NiSbWOdxQ8vci/ugCMytZA+iLZsJqVbKQLbk2sz13D/exAQKeVV5yZlqGBW92yrVMHBwZ2aIMOTaN3TiCWeBnksR+/NtwOBAKcX+gR8PJCMOplALBQ5o3BN7HwsvgpQqzx9XZvXg0LuUHq8Azm5E40f+yc1LGQlFJ/ah9MxuGx4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1840.namprd15.prod.outlook.com (10.174.99.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Tue, 23 Jul 2019 09:39:58 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:39:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: remove perf buffer helpers
Thread-Topic: [PATCH bpf-next 5/5] selftests/bpf: remove perf buffer helpers
Thread-Index: AQHVQQ+SeLH0GLw7k06NP8qXygOTPabX8w6A
Date:   Tue, 23 Jul 2019 09:39:58 +0000
Message-ID: <369DE564-224D-4E7F-906F-40266A2C0B24@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
 <20190723043112.3145810-6-andriin@fb.com>
In-Reply-To: <20190723043112.3145810-6-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:2cda]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f2724aa-89d8-46b9-6fad-08d70f51ba3f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1840;
x-ms-traffictypediagnostic: MWHPR15MB1840:
x-microsoft-antispam-prvs: <MWHPR15MB1840E6C4E872B518A4C22225B3C70@MWHPR15MB1840.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(6116002)(57306001)(86362001)(6862004)(4326008)(5660300002)(81156014)(486006)(7736002)(99286004)(229853002)(446003)(46003)(305945005)(102836004)(476003)(2616005)(71200400001)(25786009)(11346002)(37006003)(53546011)(186003)(81166006)(316002)(6512007)(33656002)(76176011)(6436002)(8676002)(71190400001)(6246003)(14454004)(76116006)(66476007)(66946007)(66556008)(8936002)(50226002)(64756008)(478600001)(36756003)(66446008)(256004)(53936002)(54906003)(68736007)(558084003)(6506007)(6636002)(6486002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1840;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s4fZu1RMbl1pL6yZub4YEo8SuaBdJU1rGC9ASlA7/4kOG/TRR1OoAdwJx8oufMdEANdbYEj8Ma6VRgFw07cUAz3EpcyRGzisUGpwkDEYjg/TrNoSLE8eXFKDNzOL0KieYiq+Sw+HqmMLh4WsgBMYdqo3OURkFp5/qWHTTwoWli6LIsIqq3XNlcrnpE3iNux4OaGaea6a93IH5CLAggNT2fRRAYdPYHm+7G6FJaFqjCMglhHQvfjzmVW4QyKTUdOgrDc/nsIyRruEtbqUyW3CV6zYDglBgP6p51P3vfsaK0+yxEdy6IJB62nZil8Sb6vRFKBmf2ZKaNdvF+GFBuA2U0ZjjqiZQ2uH7+4tbm8V1hrxV8kXpONtCwecbchrsNQD5X7Gclg0dcYCx82IIUr58DB3geIh7vVhb5B12vdhTPE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <551DC7977C9A1F409B5B1D8D6737F716@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2724aa-89d8-46b9-6fad-08d70f51ba3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:39:58.6100
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
 mlxlogscore=896 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230091
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2019, at 9:31 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> libbpf's perf_buffer API supersedes trace_helper.h's helpers.
> Remove those helpers after all existing users were already moved to
> perf_buffer API.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

