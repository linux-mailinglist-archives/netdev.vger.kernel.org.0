Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60B5F56EE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbfKHTNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:13:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42140 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732699AbfKHTNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:13:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8J9np3026873;
        Fri, 8 Nov 2019 11:13:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EvtYG6i5v8/N3tlqFvgRpHX3TRL1rgtlhs7q20lTxyM=;
 b=RqF89k8mICB94ww2NW1zDRCQNk3a/t/fEvepNogDnyq4cRhfjBUvDecNoCGrlnGYwhsn
 ZQ57wLb59ZehT7aKPNEiKe5bYLJRODOEzANZT0ISacnTtwcvZbjm7Br/G886GGDlSWfG
 uOvn1GjQUIyQrAlXybTu7Lt5X/ZMOQBo8W0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0w194-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:13:34 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 11:13:32 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:13:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcDRvlW8av+wz/Gs5INh5RaGlLTsW85x/TSpaqFxtSLv61qxGi1csAFFcxp26WU8JCFDQNEFMf2C2b/Dny9xWMuWgdrrYvgmXJ51V4IXFKHTDKRlGDD0gwzF9D6Cbw+Pir8NWnG1sTDCfkRJDWTgjoSTl5lCyyBKeGUH3nvmQC3rM6ypeJLfFAuX0ANuDux/EUIeW8TrPX7eVAJ4QfU+cMGnUOJD3VzfXvluZcty4i3CdG7qeyCx/bCNscRti7M04eDkoJPJt0GQZ15P5+TT/9exVYbRYv1sOBeGmPMqj0QLatUz4iCPZ5yAG2Q4OXEoZf/cLratOt6jFbY7DWXMxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvtYG6i5v8/N3tlqFvgRpHX3TRL1rgtlhs7q20lTxyM=;
 b=IYfCXQdo369UresS9Uf7MN/Evyn/hDK6HW8jWSJ3uwe5TOCUcQ7pY7r2/EozZ527m3jQLqu/wUOUTqfZ4gjPwh/qYtG83dEloZB6oUhkDK/x0+Xrp4ZZ5x/MKRvbpqKOEtN0sXLMSDkHcSpi4TW10DkdgEydVghCt9Zw5cNPqVBxAEw5ABfblINqSKCyIngyVjHY3FbMSso6ws9n1+hUKwwXeko560032a9wpj3+IbGyZwOKBbtNiZcMu6Lh9Lip4qwfrVpWv6HvBfbMejGm7aNB1sgPOkWs1Xz+crqlc2P75k0/q2fPefogCt+qtlhFo+mm/FUH7baa6QaJUZdVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvtYG6i5v8/N3tlqFvgRpHX3TRL1rgtlhs7q20lTxyM=;
 b=ffI+oqTlHFAyvNBoqJ8SnnPMnv1qgmRW1s/AEMQM5IIHdg/qY45+fSnorMjIPteYhdXY8v9SQmkxhQgsxMLPaRxrAy+z7tqDysNbgZQPCkgnRrPkbGa5eK7oTMKQuD7U62Wn/xZ8vtVioi9aiy6wgzez8hRkatjtmcZtvO+aTYI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1565.namprd15.prod.outlook.com (10.173.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 19:13:29 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:13:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 18/18] selftests/bpf: Add a test for attaching
 BPF prog to another BPF prog and subprog
Thread-Topic: [PATCH v3 bpf-next 18/18] selftests/bpf: Add a test for
 attaching BPF prog to another BPF prog and subprog
Thread-Index: AQHVlf+Zy6FgkqFhJEi8iKIRQlwWeqeBpTWA
Date:   Fri, 8 Nov 2019 19:13:29 +0000
Message-ID: <EFA2A4DE-ABC5-48E6-AECB-12B200D49D62@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-19-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-19-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f24e5346-5d29-4079-4595-08d7647fbd72
x-ms-traffictypediagnostic: MWHPR15MB1565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1565354CBD650B66E5A0AC88B37B0@MWHPR15MB1565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(396003)(366004)(136003)(199004)(189003)(99286004)(6916009)(54906003)(50226002)(6486002)(6436002)(64756008)(7736002)(25786009)(4326008)(6512007)(36756003)(14454004)(229853002)(316002)(86362001)(46003)(76176011)(6116002)(71200400001)(53546011)(66556008)(66476007)(186003)(102836004)(478600001)(2616005)(76116006)(4744005)(2906002)(71190400001)(446003)(6246003)(8676002)(66446008)(5024004)(476003)(8936002)(305945005)(486006)(256004)(5660300002)(66946007)(33656002)(81156014)(81166006)(6506007)(11346002)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1565;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YQuOWq+D8ONN5DPWTk0QK+RCUtDHG0r+bNIW0x9m0tII0k+OzTHuCteQl5qLI19WLjH8sqSuw9LuM6qfHYz/CUPK/o73pbT1MbpAhhP9imZS8m6OX8zKn5irLYGtszdsX+anvdUwG8FcZ6kucCV5ful9XK1TAJoqMfSOivYj5PseZNaqhuV5Gfox14g/aKpPhgrzLLo4iaAUj/mrht8rMw9w3dBfkv3+UEmqjgdTirVSAJuwDDflgLu+bYNGff39gg/Ilb2PbEE0pZ/zVXFNpYR6puT9ghA8TiiD2r0sWAOTitH0tJAsa82nFmdeGsz4WxHYUIoq9zdT7vCKFUCO7fd5A01Q/FcpXhFJVNiTLUoC98WKy/5CQjWWwKFe5E6M9dLZES3N4s6ahcRZTJaXiBd76MPyCbX88d/x05CAgsIt4UkpfcQA62bfwWHUS6mw
Content-Type: text/plain; charset="us-ascii"
Content-ID: <80E643F52280E348AB68286BE9F28535@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f24e5346-5d29-4079-4595-08d7647fbd72
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:13:29.6252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mrgCzs3KBgEFw0+nZuXcMsiEFFYpVFw5HqDbP0t2nA7s2oX88iARA9ZchuIILDPY/WbZ3p2pRIUfYqTiFO1qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=769
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add a test that attaches one FEXIT program to main sched_cls networking p=
rogram
> and two other FEXIT programs to subprograms. All three tracing programs
> access return values and skb->len of networking program and subprograms.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>=
