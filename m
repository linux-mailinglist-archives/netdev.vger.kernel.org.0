Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402D27154B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfGWJfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:35:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbfGWJfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:35:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N9ZWGs024168;
        Tue, 23 Jul 2019 02:35:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AU8x2pTG4nKBi6pU5b9LIqKTSEIkhOXyWf42lkvgV00=;
 b=RPNYIyNAKnKu8O380GoH3KwucCioW/n6xPiI4gphMw9ezSYKEsy4pJS5WQToopTMc4b2
 sGpdQd9P6dyjldsl3HeILtOOQ29cbA7Y2yRNETGd/BrEemo9LmipcjlkFryRZxu4ew+g
 UZD1u5mjl5lCRaiY0Ih0u4gLe9fAL0EBxxk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twv1m0n13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 02:35:32 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:35:29 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 02:35:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VR9oV5zxPXvkBEfd9ql7t57veHSTHRSzLDGEMa5wNVfvq0plRR9dYHv4nr8izg0Y5Q+gKmmllY4/3nPeTXXxoEZzdz1U9rxTlAcx9GWA3DH+/L0+P+JzDjStGUibYJv5hEUPTsZKNlT+6Z51au/UgF0DU7S5Nc5F74F9clYpNpxWzQJhlkja1H+236bii1xrM5oTCYohofA68vV2RbDTaKbDFLg6WIL5N9KnOTNvH0f7y0pLLO4WFmmoOhdZePV9Ue936WBG/qZt+qRiCgQo6ocS3BNQbyWFJdsffDKSvjHKoc6oqTQ5S2aiNpsMRXVocYO7SVq1IsZMGLuEGpNd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU8x2pTG4nKBi6pU5b9LIqKTSEIkhOXyWf42lkvgV00=;
 b=JGeJq5TNj4vqBx80yvT0/lIMOT7+H1Vjk5yR9/tVqjhyF41AFc7RPyfGi67nHzLxcOH9Y5onaxUpe2bqb2Gj5XyQNFbl2gq+AxzpQ7VCkn8PAEZn4o9Qpw3ewmyre2sd1q3nqnygQeVmtKegwEru6cLzwrts6yPEoJk/7eDtvD2O6kV546ca+dYXi7kC6uT6uZy83cC3i2b4LyydxlaapPvqwfumvUBns/jEvVPOtf0sJuTvLVYYfghdpIPJthBkPi5XmNUV4tbMz5dKZ5efhM8jkZzzRwo8knHbd5Ag3vU+7Nos/VbQ49V7Lmkyf+D6dM9OQltXqIhh1JchqG9hRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU8x2pTG4nKBi6pU5b9LIqKTSEIkhOXyWf42lkvgV00=;
 b=IYWmf5OE41HKO8N7vekh/DQS2zuJM5d+NwhMNyQhMItOyL8xs1ooF7HMbYy4VLCQzYsXW3BYzGeozmzkl8lX4YUYMDnoJ1dGdpYN1PZTycrXu7f8lKKwYxjnpeyCFl/0kOHkNDePaRrhvmysj7L5itQ42JVZkRq7/gZ6iJHFOHM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1840.namprd15.prod.outlook.com (10.174.99.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Tue, 23 Jul 2019 09:35:27 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:35:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/5] selftests/bpf: switch test_tcpnotify to
 perf_buffer API
Thread-Topic: [PATCH bpf-next 2/5] selftests/bpf: switch test_tcpnotify to
 perf_buffer API
Thread-Index: AQHVQQ+R8Qtvacy+jUO2cpZRwUZT96bX8csA
Date:   Tue, 23 Jul 2019 09:35:27 +0000
Message-ID: <D350A9B7-6275-40AB-A7FC-74ED49045F14@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
 <20190723043112.3145810-3-andriin@fb.com>
In-Reply-To: <20190723043112.3145810-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:2cda]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abb92be8-2432-4d42-9af5-08d70f5118b0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1840;
x-ms-traffictypediagnostic: MWHPR15MB1840:
x-microsoft-antispam-prvs: <MWHPR15MB184080F626093BB85C8CC808B3C70@MWHPR15MB1840.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(6116002)(57306001)(86362001)(6862004)(4326008)(5660300002)(81156014)(486006)(7736002)(99286004)(229853002)(446003)(46003)(305945005)(102836004)(476003)(2616005)(71200400001)(25786009)(11346002)(37006003)(53546011)(186003)(81166006)(316002)(6512007)(33656002)(76176011)(6436002)(8676002)(71190400001)(6246003)(14454004)(76116006)(66476007)(66946007)(66556008)(8936002)(50226002)(64756008)(478600001)(36756003)(66446008)(256004)(53936002)(54906003)(68736007)(558084003)(6506007)(6636002)(6486002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1840;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nbX5sDDEn0nK7LfQY+cS5m2I8uXw37Q2DBxMimj30v6GtSHIMfFWIcENQNZ/ojUOuX2y2zAKPfK3JlMFgkcbj4W0NX81UNDwcIsOsJGT+elN+mw+FxUP5f0kYk6l//3HX45i62MJ2vq2wmY73nnWWD5m5qvMjvvhRz7xRdcbWFc5eNR3aL08woJQIJRfOyfZoECBvakuwsO9iS3AuUPOZpRiZH4iN424ALFaleMsGGMUv67vdHSojh0/y+U4fAd6sCAHcoItScLi+LrIK2zqAhvhRlFU+P7vQdp14NiAoyzK8PtYEyTr/p4EXrNWNdCNFCqm8TOPR5Ye+PH8lT8FK3A7JhgDIKVpMnxXSFqRUFhDPquUUUeeV9bZ09AWAr186xljXwYcwvXDdr8A/R6Ns6+0kIPbkLeClM1k/9baCOY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BD4CB62A7C71F41B2357128C7FB444B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: abb92be8-2432-4d42-9af5-08d70f5118b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:35:27.5748
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
 mlxlogscore=680 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230090
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2019, at 9:31 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Switch test_tcpnotify test to use libbpf's perf_buffer API instead of
> re-implementing portion of it.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

