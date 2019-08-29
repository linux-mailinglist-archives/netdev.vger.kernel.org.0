Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23B3A114C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfH2GAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:00:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11904 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbfH2GAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:00:48 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T603MW022697;
        Wed, 28 Aug 2019 23:00:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SpOVCw9KQEy/hmZWXM9nnmUt6o+d57cNpJwThkDymLw=;
 b=oDmM+csBUIjFV4WE2IVo1oq5lE01wIZQwZSB2n0AfubalB48QtVOlQUInOokNFcW3DO8
 J/9pSWnHlLmxsjjLYhZPnq7TvUG/extpapjdeMeP6wh+c0avqpv7jQsFzo53+zqvDPPF
 +k/SdWleWuHRJG2lN1meyOcAVH1e9trmAPI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvnk37fk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Aug 2019 23:00:12 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:00:03 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 28 Aug 2019 23:00:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0+fwxt51i+sebDhbNrRdWIIy5rX8aEgCNMZaUyRB9Wf4gpMZ0k9r7jqecfF3fJ82Oz7Pk2xhqEjUBGJciF8KG6u8sOQ29CJE6w5a4Zw7SAktmGxZCT4Bd7gaN+CBOhjv2j9rVmM1RJv9u2JzLkwlov395cbjEaiB/piD9LtyUr4ymtmkr9GtKhoEXsYl1XT53oxCctYRNwqgYW+fehdOcMhkF64T2UdlbTGooH+0SCpd8TWWIzbNz0Gxa6A7v4v9Qql4NFhNGiCjdK+MsrHJj+1o28BluUxKeD7hJw6x6ZAxRrWNckpixieN092onpuhKyl+p8wpnxMZmuqmpgWVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpOVCw9KQEy/hmZWXM9nnmUt6o+d57cNpJwThkDymLw=;
 b=a9amvOMH3vix41vAudcXacqrLQIDuAYU0Ckb0Dg2LOBQSKk4kO21LKEO8NF5+mReJQqocqWORGZSxhG+op2ft+KXnQCFvPIj61G3DFnI1mINq5CPRf+lySQyGQgKX843SBm/nqxeljZ3GWm5GS6ENs7nwHO4OaFm5XN3sfklV/h+6WIQMK+4BCSrMz6kg8zahLGJZ08xT28y8iLIRoxQ8gotBOs9I6HEDL6de0VxMxEYpMph+x3v7IpfJ/7ovAM0fcPBDmuV9SwppuIHMp6Eo7Pu11ubO+VG+u/Dv8SksgDz2+Qsie4/3KeZDqvj/NufUWjqd1e8YObJKnssA5B9IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpOVCw9KQEy/hmZWXM9nnmUt6o+d57cNpJwThkDymLw=;
 b=OgSy6G4ZNALJtcbJ7jBI5HqYpFsPGoFQLF5zLd79tiJYaKjAEnhZXR9+rV1uuK1cVx4Jdnsu9FCtAYH6naOxS099on1Bq9f0ci8goMzBT285dsklCob7fOeBNLohaXF1NF57OGzh2Lc6T7BrX2+yvYQZsNl/P/Yiwmf5LVLVpMc=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1248.namprd15.prod.outlook.com (10.175.3.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 06:00:02 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 06:00:01 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Andy Lutomirski <luto@amacapital.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Thread-Topic: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Thread-Index: AQHVXihsvq41notu3UCsny+JVxUfAqcRoayA
Date:   Thu, 29 Aug 2019 06:00:01 +0000
Message-ID: <5B8A0EFA-661B-4223-A59C-E16053BBAB81@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6d75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b2a2023-9f64-41df-abaf-08d72c4621a0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1248;
x-ms-traffictypediagnostic: MWHPR15MB1248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB124894BBD999BABA282B6E76B3A20@MWHPR15MB1248.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(346002)(366004)(39860400002)(136003)(376002)(199004)(189003)(54906003)(53936002)(446003)(11346002)(478600001)(2906002)(2616005)(46003)(229853002)(476003)(5024004)(14454004)(86362001)(6246003)(6436002)(305945005)(6916009)(6512007)(486006)(256004)(316002)(7736002)(50226002)(4326008)(53546011)(25786009)(6486002)(5660300002)(558084003)(186003)(14444005)(33656002)(8936002)(8676002)(81156014)(99286004)(66946007)(66476007)(81166006)(66446008)(64756008)(66556008)(91956017)(102836004)(71190400001)(36756003)(71200400001)(6116002)(76116006)(6506007)(57306001)(76176011)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1248;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 34qEUmkCseI3OEcPi3wCdG84x6THtz1zlgEgia2EU3+Ys2N1Zbe0mqGmRMSWhXnAYhJYBhWdMmXwwl0VtaqW7drM3Shy5NrUrYVAdUIRuVZeDziOtgaPlc6TFsVelz+/3cNK0wmeXazusmi/HaGItEfNksYG3aom6jwHMirgGaYSli0vn2dNPNnK+xNdyafUApXP9UkACw4omJMI/wsWedf60sXA7Ru9R/O1KWYM+o75nCVzEzkJXT9/Rp461gaagsh+mgZVEmkquGkXgPV4eTTTkTthT6RpdFc5ocCscfyXUaHD8cZ9MVMMaeJ3Xajzb+oCArxLuUcL+vr0Dis+L3yXrPqKmEKGQBjlyGS33O6paaFdx26N0/Z3vmFpzuP0kQEeyChK4TNnJ09CMEtSRDM1GCzs/6StPgbmtd0HDi4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB2ABC2C42A04D4D818BE91564DF3278@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2a2023-9f64-41df-abaf-08d72c4621a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 06:00:01.8675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jrOuZL92Zj44iI6bDZdQ3UUx25NV1befPexvNj3oOav89nzONkQBGy3TjycVVfFg4fVZNV/wJ2d2zGin1pbvQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1248
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=758
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20

[...]

> - Creation of [ku][ret]probe
> - Accessing arbitrary kernel memory via kprobe + probe_kernel_read
> - Attach tracing bpf programs to perf events
> - Access to kallsyms
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

