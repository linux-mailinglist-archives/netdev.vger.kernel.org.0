Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4991F3562
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389843AbfKGRFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:05:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387476AbfKGRFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:05:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7H5GKF031124;
        Thu, 7 Nov 2019 09:05:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oo6f2L6dP3vLkVe1S52eRUwN7JAdlIHsiMnopmIR0Ww=;
 b=UqC+6irUALLz/zUM6e++9laNFoAdWW9baCvgtZoZnwR5xZACwykzJW+CP51+BrQgqtj4
 5ewLdukxYb8yqnyW0Vs4x2BBM8iKsGqvhdYTIbaqDlrb2San8VhPua+O3+dmwtkhz2BN
 ZlhzGYGxf7iXc2u1aqTp/Ds5Ljfgl7a+wUM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41uje4ev-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 09:05:27 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:05:11 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 09:05:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/isa3NTh8f74R1E9i/1OMcXHOXd9AuPvTarKJzuv1TOjePT1kNf4DqMfwtuFAHj7XepKWlQsajCmXSNlFjXsqO/RUcMMXyjKiMpd1bran36qH0+bRqWXx24keG/Qg5+Uf7ZdwCd1/pI7DACpf06yCl34p3CUpGjPgYZ1bO8+t9zkKF0uTwFX3I+ykYKlW59mRl04fUopk1vR2Y7MNv17ZYNn26PpmysQbIlx0TVtqiIu5p59e4OgeelNdY1d4NIzUJrseVbJjImMsnUDjaepPHwWKw9rdnM7bajgkvIxiurPeWsYOtfiNY51jqotZ4d2jIv3vL/4+eaMcxqpuD+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oo6f2L6dP3vLkVe1S52eRUwN7JAdlIHsiMnopmIR0Ww=;
 b=l4f3mAKy8SLyI5/UyBRpzBobP9Napaq78I/ZBYsENZ/t7SD2PfizszRaPvYuLnt9iRt74XMPk5/CP9ZDCBn3Jd8RkDbzA9HbRjoPF6VTokqN98X0Kyhkd2Xd03lOqUuAzvBpOgpA/QznD84UP4WH+3nmQXRkaOStdbPMXKno3xa/VZslgj6xMCR22g1optM8quKEq72DfzclTuMKJU1EICFjI2VMO1uaQGwKkf3s8g2F1Zmv6LJl3ZJLjFGsniiFKdg+t9VCteeKwQQ5lgVQjQCGRJaoOJ3uYMVjToWnKHXmRQMCjAYmZ2VLiSTJBunCsQ7++eTj8nkCZi6bhEzzgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oo6f2L6dP3vLkVe1S52eRUwN7JAdlIHsiMnopmIR0Ww=;
 b=Gcj6YIilLBCOjYhRfuSVUvfx8lHh8OhCLgW7kL6L1gjXvHu3VQMDivOrE/8K6R/AsOtIQ5UFRstGUHjTxsq4VyGLAc3f84YJhezYKzYyzLB364DALb/LvZHPUgl9Z09pIXiUL4zs1J93uLNxaxqxrUcp/zc5bSMoDKtdjdbcIgo=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1341.namprd15.prod.outlook.com (10.175.3.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 17:05:10 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 17:05:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 01/17] bpf: refactor x86 JIT into helpers
Thread-Topic: [PATCH v2 bpf-next 01/17] bpf: refactor x86 JIT into helpers
Thread-Index: AQHVlS7FWI/IxDiN9UyOirE3iNlQN6d/8KeA
Date:   Thu, 7 Nov 2019 17:05:10 +0000
Message-ID: <4C45A71B-8FB9-4E84-A87C-4299AEC985DE@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-2-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: deb78a95-9d41-4aa2-5a22-08d763a4a5ca
x-ms-traffictypediagnostic: MWHPR15MB1341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB13418CB3B9FDAA77575C6DFFB3780@MWHPR15MB1341.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(366004)(396003)(346002)(199004)(189003)(229853002)(6512007)(14454004)(5660300002)(6436002)(6486002)(478600001)(71200400001)(6246003)(2906002)(33656002)(4326008)(4744005)(71190400001)(81166006)(64756008)(186003)(99286004)(6116002)(2616005)(316002)(76116006)(86362001)(46003)(102836004)(446003)(11346002)(54906003)(66946007)(6916009)(66446008)(8936002)(81156014)(50226002)(66476007)(25786009)(6506007)(76176011)(36756003)(8676002)(53546011)(66556008)(305945005)(476003)(7736002)(486006)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1341;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ihRevsMzwnEFMNeCfpsmUq+b9OIyZ6k1kRBZbL316TCKYTixueNBTCWUJtzcbFAVewv4JAhK1xzZ4YRtVftk+bKFqc/T6LcKMbNvodgWUXAyEv4+CrZI0tA8IVGvgweZFbwHs+Ld0ZKWRpi039Ui9aoBWUY19N8oIkeAj1jTRVvDJ7ieltAGIbKdFV/bR4JZuIT752k+dN5lol7Zw4+tAiuRFoeN+F2/zi/4b7zMXSltmBIFIC+FEyyXJoJS2giXQNFD0i9RuZ4uZFZrfrpgRcfK3NlaCM3fGiQvqgjkiw5GNgfKB8YJMldnXoeb0lBwHbThv71SqM9ERFpUNfxL4fz6rj0H+Hks2mt+WNWUTa5dan2zU8/KTZcRrjwRxxIci8vgPp5uPFgWztg2f7fGaul3lVYviuZ31XYTTTu5DSstLAfy1RvuypT4UxThwFcd
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F86ACE454293A7429A125925189707F3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: deb78a95-9d41-4aa2-5a22-08d763a4a5ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:05:10.2173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vIr0ESVHEtBuc60EFm0bdmEkphQ8BayQNCauQCPUScJzJizAygv1vxscu7KLP0dE68m9Lg7b0ucxFX/M6fgEFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1341
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=697
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Refactor x86 JITing of LDX, STX, CALL instructions into separate helper
> functions.  No functional changes in LDX and STX helpers.  There is a min=
or
> change in CALL helper. It will populate target address correctly on the f=
irst
> pass of JIT instead of second pass. That won't reduce total number of JIT
> passes though.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com> =
