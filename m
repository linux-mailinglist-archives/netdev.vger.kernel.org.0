Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875A711D61E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfLLSo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:44:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730096AbfLLSo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:44:57 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCIhaLt000798;
        Thu, 12 Dec 2019 10:44:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mEXHx6RgfushLae7SObbVKzlhHhZZbV6/JbM7NadO4A=;
 b=QlQK/CGSwRsg16MnyVovx+oKdnrrNKgclK4yUdhm9Cz2llyFX6CNZ96IJAPiF+o31dDa
 tAfMcs7aygeFw58Znv/9f06gM6E+UKKDH9HSNbm6li9+qVhNzE5E1kfRtJLeaUJLB6JB
 M+kkU9BKQ3sa6H24d/xJv+XjIiQRMFwdes4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu404e1uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 10:44:42 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 12 Dec 2019 10:44:41 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Dec 2019 10:44:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEiHRS/5U3ZIWWXVybgDdLMcY7d/vW0YjfUiUj2b3slZB7W90C/5SnA6H4lMqatiNHK36W1d33agfRW1b/5t88d6YjpKDaR1reDdCojvoAWsUaT0LAnziecckcy56zdrGjXtbWyLUZoWuh9nCWpDPnlEj0BqrCbyQghwx9ZUmyKpGed68fvTHFuw+1qC8hGYkJtNn9sdoEEHMwWpyxUba2L+93lpfkyqaUhypS2mlFYFeV7BJxeOPJ/JSX4alPYImGvJbx1SNbITNH2I2EKrdjNQAOfpdUUDheHbUUa/Bhjo4+auQrfTvlO/7CZ0xZZ2uANvopaDTLW9F2rRJ/dkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEXHx6RgfushLae7SObbVKzlhHhZZbV6/JbM7NadO4A=;
 b=jH/B/5wcbC0xowLJ/gf3eRfXYEU28Cqc0D8v+wPoOjmIXEOVFaJeedfClWGiSk0EfClLgHhHtJ/xtRT0/2lhK9YaWvNohfVI36iUl+XC1v3DPjLThZpwUSEmqspXYZOtymx+bPKDxo4ulwEXDC6tLbSaNpeJl8NHv6kyuuln3ck9JTjm9Mke4Wh9HD5t7W1tFvSLsDNKn7NrxItriQWxnEPoIAEmMfMBj3yvR+tWluAtn5RkTyZQBThYE3HSI018e5TNMShSQ7qHJ1fFuP0/AxtDntq3D1fNvnk8VLyzZrEl0tvRlZlm+4DsG7FQvyXBd82J8fXQ/qrIJng/5r/z1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEXHx6RgfushLae7SObbVKzlhHhZZbV6/JbM7NadO4A=;
 b=R5NmYm9EikQaXhnBI0ec8FCsvJx/cJM9dHwdqKIFoZR57r+HMh9PYlGsAFHPaVoBOhbRYaPID4RuSpDmJeq2GytDdygFg/nkX03LvXuRkgBdWIYQ+1LKLQMp+yYviFxpH4bp9Nm0ni9kMGkl74Sx9ldRoKs/+4jCRub4i7iuVJw=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2799.namprd15.prod.outlook.com (20.179.147.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Thu, 12 Dec 2019 18:44:40 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 18:44:40 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: test wire_len/gso_segs in
 BPF_PROG_TEST_RUN
Thread-Topic: [PATCH bpf-next 2/2] selftests/bpf: test wire_len/gso_segs in
 BPF_PROG_TEST_RUN
Thread-Index: AQHVsEv66kbXHvagTE+z7fjFeyqwgqe2188A
Date:   Thu, 12 Dec 2019 18:44:40 +0000
Message-ID: <20191212184436.6kdpgvctihuvprpo@kafai-mbp>
References: <20191211175349.245622-1-sdf@google.com>
 <20191211175349.245622-2-sdf@google.com>
In-Reply-To: <20191211175349.245622-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:300:103::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::97ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba36530b-4370-42ec-b694-08d77f335866
x-ms-traffictypediagnostic: MN2PR15MB2799:
x-microsoft-antispam-prvs: <MN2PR15MB2799855D582C08D7124F5E6AD5550@MN2PR15MB2799.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(346002)(396003)(136003)(366004)(376002)(199004)(189003)(4326008)(1076003)(558084003)(478600001)(52116002)(6506007)(6512007)(9686003)(66946007)(71200400001)(66476007)(33716001)(6916009)(86362001)(81166006)(81156014)(5660300002)(316002)(54906003)(8936002)(6486002)(2906002)(66556008)(64756008)(66446008)(186003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2799;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8PDQZwOHTtYsptmbH7d5mAmU+RFbmApBw6JOdoPwDPZLchtPrXc2cH0lC6CrrLgdXeBvMokLvr4j9m2omwIPNB09syOD4I4aWJnrmbG2UOIulb/m0AZdcJZlLAZxr6WgwXHsavrLWoLkWw3ABC455LMjsvqV8TSXspnaIY20uPE66yv7Z7RS4Wl061qaANGWW5d0zBbpOMcFSfw5OnMEvYI+6Q2E+FSQlK8gPIJYoKMj+DeCCOF+QLwUTquJGSUpLNJvC2ajktcRPiDe11Gdi0NFmcl3YIPSZ4Py1ot/rLbwdSD7u5mz2i9mCVbPAdKh88kHQyf0ISPgbjPpLQtZbGS82nIyCFvKLP2Kdrj5CJYtPFTfwE88l2QHW8bgK7s7qC3hZsEwXheBs5b/e9akp7oSWMrHhgkgtjFrgo4gIIvvN71xsKIghkztY3kfbFeL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7862B4E23C185B4D893B7E5E5CBA2D20@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ba36530b-4370-42ec-b694-08d77f335866
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 18:44:40.1969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xUwtsnLA+HiadfJSztsjpQeWo6m8fVVhT7K3rG0VikNDOnCiEBRBUDCd+MglT59g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2799
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_06:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 mlxlogscore=585 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 09:53:49AM -0800, Stanislav Fomichev wrote:
> Make sure we can pass arbitrary data in wire_len/gso_segs.
Acked-by: Martin KaFai Lau <kafai@fb.com>
