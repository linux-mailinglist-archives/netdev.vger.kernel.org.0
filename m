Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58A21478C7
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgAXHDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:03:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgAXHDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 02:03:35 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00O73MSK014349;
        Thu, 23 Jan 2020 23:03:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yryOsSghsTT0rm8ZoPYfFwUhcmrZyGodMicIYMo1Zbs=;
 b=MV53Ib2FF1c4IqcTWPtSgC0rFHwobmkQcoXwCK6MxJ4Y9TxwNTHkX8As+o4l/dgUscih
 zd9lcmdWl/VKyjxWAVUfUvbGkDXa903DQcZ15YHmKLN8JftT0JXaofM86Fqv87s05prr
 Jv3xaVHX2ReybmFIBBAesOsq+bJ5SlqRCvM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xq49c5sdx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 23:03:22 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 23:03:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f585tnr3ZVJuwEwzedp36KlwpxGzFjJsQhseCCaiQmenmMwiyWiInUCvPosxqDIfCW6ajY6TmjE5ozys/ifqpR3lnfiSW3xIGuxsHDgNQq8EsZsy8ogsVJoz6qX1BO2Dmk7LBQaIVTm8W3neyEl0Zx3m0N2KqHvbfCnTPVpU2k9NTDWbNW2d7hmrR+1gK3zVqvU5YoKs61rjmJsz8gj9JddwQhK3fX2HUQxzRCEacaMpQ/NuALjBIyPkp/LGpBs5FrCouasxt1qK+ezpIhPnx+zsb9/mwsdNi0WzHu2phahzBIVYHOFMX1iuOSmJwMqN6axI23Mh/Je4k4uOsgJLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yryOsSghsTT0rm8ZoPYfFwUhcmrZyGodMicIYMo1Zbs=;
 b=TwMXBaWnf6a5nxxuDSUN8CAwTERPyQyn299DjHSL5nvhH7E9fBUMiUjlX7IXvIaJkdSqFlDuG0afTav++zMtdnM7K4G3ZsXxwgOJsvfrfRvLTxvco871qHyJdTIA4YvZA9j7SkuFM4mSA9LSnqZsWxAZvWB85r46kYf/fEN348NmatYDjh6+m2n5rX0VPwOPsaeDD9r/EVwehxVAe6Ok1Gccb559Zh3FApSZGowpDX/cr/PKj7yf5waPyZdcLYLgcChrt9Nd+APtE9pBY8sjiJZUY/ibHTV18X96JOqST4R4f+AkJYRzLrriU7c21HL6INiGwIZD0ArID25Y4UxNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yryOsSghsTT0rm8ZoPYfFwUhcmrZyGodMicIYMo1Zbs=;
 b=KMdkK4W//zKlxUv52UfvGaJnJqy4jxX9KES25KK3sE7vdKD+LQ+n8dc5pjYk0bEmb934mQCjObOh9RMEY8nbMdHLXctypIg554asZLY3k0/84kXA7PVAJu+04VF9Dpif9f0FpJslGoNbYkZyO4d9fzcGm6uUq73cdbSALDWjSI8=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2893.namprd15.prod.outlook.com (20.178.250.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 24 Jan 2020 07:03:00 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 07:03:00 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::d6ea) by MW2PR2101CA0007.namprd21.prod.outlook.com (2603:10b6:302:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.10 via Frontend Transport; Fri, 24 Jan 2020 07:02:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] selftests/bpf: improve bpftool
 changes detection
Thread-Topic: [Potential Spoof] [PATCH bpf-next] selftests/bpf: improve
 bpftool changes detection
Thread-Index: AQHV0nkG2i4DXA7ZV0K0SyfAVmoLC6f5Y6kA
Date:   Fri, 24 Jan 2020 07:03:00 +0000
Message-ID: <20200124070256.wdxgfx2gnxnhdfyw@kafai-mbp.dhcp.thefacebook.com>
References: <20200124054148.2455060-1-andriin@fb.com>
In-Reply-To: <20200124054148.2455060-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:302:1::20) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d6ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07d13b26-b63e-4965-9e4e-08d7a09b72c1
x-ms-traffictypediagnostic: MN2PR15MB2893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB28937CE2E2BB223B0643BEE7D50E0@MN2PR15MB2893.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(376002)(366004)(396003)(189003)(199004)(64756008)(66446008)(66476007)(66946007)(8676002)(66556008)(6666004)(2906002)(478600001)(16526019)(5660300002)(81166006)(1076003)(81156014)(8936002)(6506007)(7696005)(52116002)(71200400001)(55016002)(186003)(6636002)(9686003)(316002)(558084003)(6862004)(4326008)(54906003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2893;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z55jVMnx5HTNbwZZPA2ZFejiHmJTbgr7u/wnehApGBCxFwzRFeYMVukLNUEDCq9jvJssGtvOsbds4I+WABstVSRxHMEW0eggjVKQ9AcVIA0JgMPIWXPRzPeRl+R4IxV6+zMAbVJeFsHLxgZdtpEbcx+DYCK803RGVs09uvUEyp811Rl6KbcAcKJSVmTxZerDuEkHk4lb/VDSTDRn3xfVufs2S+lrXDO8Og6LdhP46esUC/gV+JY50vQrgj2n3K6KMMKHdIjxPkru0EC7e226MDs9U290iBvgult/wvBNpu9nUC4ySGI3rYtSOfe6lFXan5TrlrG/zQFsjqNHmzAcPmHgNCh7cOE5ntRY9OiQ+o4wSr9oSH+A2yCQa1MQ0lIXd4ubkgqREFmG2rFDsaHuSrGFqN18ghpC7TjSSFTVW/DoTiT2MCbJr+ftlxfdpHER
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BDA31CB05F34A5499399CCC123C478E3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d13b26-b63e-4965-9e4e-08d7a09b72c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 07:03:00.2890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFQVm/X3JIpawtvcDReExh66Cl1eDXpNN/OruRJn0y22N3XZ0DkxEz8MxuKh8eFW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2893
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=654
 impostorscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 09:41:48PM -0800, Andrii Nakryiko wrote:
> Detect when bpftool source code changes and trigger rebuild within
> selftests/bpf Makefile. Also fix few small formatting problems.
Acked-by: Martin KaFai Lau <kafai@fb.com>
