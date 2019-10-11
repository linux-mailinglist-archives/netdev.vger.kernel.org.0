Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF28D4549
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfJKQVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:21:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15472 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728213AbfJKQVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:21:37 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BGJRF0003301;
        Fri, 11 Oct 2019 09:21:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dFPbNoIOYzKP9XmL4zg4IcelN2CwkwZQ6qrGRhAbYjU=;
 b=jh+4YATYHEgtzcKS2ZipaxjO2LX4NiXXJFxYTnzG4tzwCP+k0DGNc3qY7WDi921j4lk3
 FB3w0gPd7cOU2xJxX0e+DjhGQcLLZ568SAAnndM4OxhWrpWCoqFYGW3unHPmPw3IdcUH
 zlVhqESJZULOuyWgrm5MbVnNFXBCkZAzwus= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhy7hg1re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 09:21:23 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 09:21:22 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 09:21:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewagOrTSsUGdxqX8Os9pZ+Fig4kK9/XEQNNF7Tty+AfRHVHt8feWTja6PT68JLMiDT2zXhA7tpzUQq322fG21tb0YglBdEAyx5hTgOwTYlCxVIedg8IUXcYQK0m8SdGNr1uhgQi2QV8gQQzOZtJeTFkuP2qLblT6BnahAgXoS5NV/AXBh9PNDFRckpnPOMV+BK4FQYXUsx5aAZjvIYwWmXCVTl2nlQFEIKiwJwnDhf6Qh8nOQ3DPdAlLAPaeqXRCcZbSucf/MUd5kEPwkyoqfXdZPiYFzRDtWibdBcJHcVuBFjN3PPbFwKvF1GnExAoGHxtHXY7LAAOZM7Vl7zoCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFPbNoIOYzKP9XmL4zg4IcelN2CwkwZQ6qrGRhAbYjU=;
 b=ODeXxfRTijY/RG7Y1QqxRJDshHudjNThAAsKhhZv8sSl9QQk9dYUCReGEveNupjrp7eVv0bxmnI5lVc6CL98J3fuSTeR06ZAIVBypjx664mflESghbdZYR3DCgYXdc3cec7yqp1YVBHyu5ATN4fvq37Rv4A1B+R+2CugOiAaa1km4WAHBDshd+dlh13JJvX2fPhOaCApAC0gEQsLqkoETd3ifR2c27vaw9I/Me9KIvg0sI/JCGcU6RAcudmAGvLeWuUxzMFP+5O0qa32HiXXkQRrSdG0Idyah4ym9I1nrSEAVZe8phsflFghMVJsA9wwHeU3MOqeMcbTPRC7hBrS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFPbNoIOYzKP9XmL4zg4IcelN2CwkwZQ6qrGRhAbYjU=;
 b=TEq027IvHzfTXuPPIc8teuNvV+7yFYGD8mUITIlMfdBbtMH3BGQ/44SZRS0WGsDhJqq0bTw7bcMQYp4zBpIzKY1sKfVG7QnqilEm/j4lrCjBqhT8sWISasn9tRLX+3zvzdul3pjiJ+Vz6bExUFvq7cVT9AnFAXk3iWlJ3/D3Fys=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3677.namprd15.prod.outlook.com (52.132.175.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Fri, 11 Oct 2019 16:21:21 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 16:21:21 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 2/2] selftests/bpf: remove
 obsolete pahole/BTF support detection
Thread-Topic: [Potential Spoof] [PATCH bpf-next 2/2] selftests/bpf: remove
 obsolete pahole/BTF support detection
Thread-Index: AQHVf+HlxUkxFTkOd02RdnzvekPkjadVoA2A
Date:   Fri, 11 Oct 2019 16:21:21 +0000
Message-ID: <20191011162117.ckleov43b5piuzvb@kafai-mbp.dhcp.thefacebook.com>
References: <20191011031318.388493-1-andriin@fb.com>
 <20191011031318.388493-3-andriin@fb.com>
In-Reply-To: <20191011031318.388493-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:301:60::40) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e08f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77674fad-3e85-4d7a-118d-08d74e670d7f
x-ms-traffictypediagnostic: MN2PR15MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3677204D27E8B08FD00CCE51D5970@MN2PR15MB3677.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(39860400002)(366004)(189003)(199004)(71200400001)(5660300002)(71190400001)(6862004)(6506007)(86362001)(229853002)(386003)(256004)(81156014)(1076003)(4326008)(81166006)(4744005)(8676002)(8936002)(6636002)(486006)(76176011)(54906003)(66476007)(66556008)(11346002)(6246003)(14454004)(25786009)(66946007)(446003)(476003)(316002)(66446008)(64756008)(2906002)(305945005)(6486002)(46003)(52116002)(99286004)(6436002)(6512007)(9686003)(6116002)(7736002)(102836004)(478600001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3677;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ASYnuADFM3HBQNZ5gB9F3j9dASQ+RPAhLHggTTKtJFneZWo3vCcLxVPkLlJWMPnn1a0XuLh0sKlYZ6D3dcvJf82ikZUasgq95nCocfVYjrTvCaFVYreAu+CftsjZ+RMN8IVW493vliW2Qgfk0+Z9t0gsbTsoLXkOUYNmi+BKn7d5Drfqcl9VEs3WQkx8JDJ7s+w7mOlf/TROmLllF1obukbFCb7aeeg3BjowsPNOsDftZGpjp/AS8Z9iF0wL4z5wj20l6V89c1s2pbFObQky9EGPlvYI/LyMdQ+kGK/+SXPOHa1LCQq0/1/aI9em5PsioHIqTNIyDJhni+OPs4uRrT42i7hqW5tB2ZhNTACJj24jagcDd9ZZsQdiWftpwwY6O/353niAA7YqRPgtEaKRDIywOw1Byz+hqVtyYd3vGM8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <33F9ADF43B39AD49B26CBD6F6BED1CB1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 77674fad-3e85-4d7a-118d-08d74e670d7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 16:21:21.3362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yD18B+YdIgSkD+ravaHTxAkCPtWXe1ymIVbC68lJ352XXV51bMvHD4LNMj3GjMci
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3677
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_09:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=906 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910110147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:13:18PM -0700, Andrii Nakryiko wrote:
> Given lots of selftests won't work without recent enough Clang/LLVM that
> fully supports BTF, there is no point in maintaining outdated BTF
> support detection and fall-back to pahole logic. Just assume we have
> everything we need.
May be an error message to tell which llvm is needed?

$(CPU) and $(PROBE) are no longer needed also?
