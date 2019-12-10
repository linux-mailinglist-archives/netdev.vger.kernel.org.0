Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEEC117CD8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfLJBCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:02:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15998 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727073AbfLJBCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:02:45 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA0x6Jn028598;
        Mon, 9 Dec 2019 17:02:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3Rp8iEB2P3ZH7cfy2jXrsQKKH4JyPBOY0uUHB+gUikk=;
 b=mh7wubC3TIW/wbyYI/Un+dDsT4oAFNgJoPKfYl79hg0DZFT9vjT5Gpesl21eiisxiXPc
 nypeQujrK7El2AvNvCpOGvizTgKlq7q+QvAnVeGWi6lS+6/kIVjpxi9b8UGXq6B4nRS0
 7Jm1fq34u0X6XA47i+UfAdCQq7bWigpYn8s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvye7x5j-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Dec 2019 17:02:28 -0800
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 17:02:27 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 17:02:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJG74e5yUJfMLy2pAqxuLX34WYd3w3oUQEl3b+FQ1J0Ufm3vZ73FD4OMKvZkgxafL94TPB0j1qG36dsPph1e3CxiC+KeQObSlSjSoj0qEPvMZPvEbByuXWmRxfJFCDMcSxjBFf7dFe/Ta2+Cs+OX31Sz+XFyKzuxVStepM78/Gs7JR6DfqKgxRRoffqqBL7S/WeixvpzJ5SCux+2EuOHey4DkbRTD6VxptBtlFq9RpEs0vp+qMgsTNFkuXcTMAmIcnbJWg7ltR3Kyn1mpbK0mWDNzU2aD/DICSqUF0kLgjQ8fLRKMDKHm+GKWViaiVZJ/GUHnGQIAcLlBfyR/HZIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Rp8iEB2P3ZH7cfy2jXrsQKKH4JyPBOY0uUHB+gUikk=;
 b=fJ672ncDHnQnGtVEqSP/JsGDMNDOQne42nZMZYloOyzCeam/YPF7fxLyGwhIC4pVzMmYDuApfoDrD5FNk7IeTpjPlEtFvTgj8tgylpJTCgxJwdgD3CSyXduMRXRgVDGZLR8cazGM0LJL7YZf2lDeAv9FTxSEmvv6NKoQ5VIpwujVYSLZsJRiBI8iLO6H9I6JL+WukIsQ3f6FklSeJU85CSlSPKmiYERAXJjSNf5+2vILMeifTLB1/MmXY3uP5utJb1JsCk5xjSaVOgWhevBGdGe1j2gH9PQrLu9HqFkX92msuaszU6Lhbv9t1FI5Vpv2yVzUUGITVvQq1MLi+3ropg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Rp8iEB2P3ZH7cfy2jXrsQKKH4JyPBOY0uUHB+gUikk=;
 b=f/xDM+R9pPjmH2SxEVB/7CGBPbGiuCmnfqfVxGsZvhDIgZTtOYmYgCJHe99NGv8ct9ZUDCqm0i0OSVNJ0km4mRHYZNmdoI7S3ny1iMfRQr1HFp7boF82etqiUwJDxYrZJxtAgBVWCaFk4txqRapheScdvIkGlCwQ/HggCs50sgY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2SPR01MB0040.namprd15.prod.outlook.com (10.255.90.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.18; Tue, 10 Dec 2019 01:02:24 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 01:02:24 +0000
From:   Martin Lau <kafai@fb.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next 00/12] xsk: clean up ring access functions
Thread-Topic: [PATCH bpf-next 00/12] xsk: clean up ring access functions
Thread-Index: AQHVrmZHCPZZOYEEE0ODTxQYQJcNfKeyjiUA
Date:   Tue, 10 Dec 2019 01:02:24 +0000
Message-ID: <20191210010220.r3ihujcv4lajjnub@kafai-mbp>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0020.namprd20.prod.outlook.com
 (2603:10b6:301:15::30) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:ba63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4e094b7-a0dd-459e-d444-08d77d0c9e21
x-ms-traffictypediagnostic: MN2SPR01MB0040:
x-microsoft-antispam-prvs: <MN2SPR01MB00401219A15507351010A609D55B0@MN2SPR01MB0040.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(189003)(199004)(1076003)(71190400001)(71200400001)(52116002)(6506007)(8936002)(54906003)(81166006)(81156014)(110136005)(8676002)(305945005)(186003)(5660300002)(498600001)(229853002)(33716001)(6486002)(86362001)(66556008)(2906002)(66446008)(7416002)(64756008)(6512007)(9686003)(4326008)(66946007)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2SPR01MB0040;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dxq6VPJezMfOye9CrM+rV2PS6SjrX0znT9HB5YP2nK37c+NpQmQJ9JExlksJ6IBti005ustlUHYhY8Qgl35kNB+lVUQnqtFtaIFEDqmMSyh2tjOhGSxh0yIoqkZNYYZqE8ubqLLkuI9q8ejKf6Xu0H1dckKaOwierRmz42jqkBnQk4ci+k2WBSTHlhD5ps+JD5jLOXEkZO/AnJcqypYu/ITmNvA4epu+PZvyHt3IL01VNxix//w4FJN3ubjJKENQt+T19NBwnwtl2tvl/O2CgaZ59lEa+I2aeK4H1j2R903or/GqPIqNbVIOHTDcgjuzrjF7CVDKjgYA+ZN6Wwc5YgktpDQl2u5RTm70C+Q3b//v/26WriuRw94TgiFoeTISG7HiQqK055Lue427zvdFTx4LmKLg6TAayHjpTVggI1WDB2ohNxRrDfyQCPRAdpoP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB8F9A35E9B802489E613F93A51E2F3A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e094b7-a0dd-459e-d444-08d77d0c9e21
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 01:02:24.6228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UT7cT+MQQsSYAtVK0YoM8La8AHxx32zQJaUlUAmX6+KBqfJtjF2DGkP4mDba6YXX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2SPR01MB0040
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912100007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 08:56:17AM +0100, Magnus Karlsson wrote:
> This patch set cleans up the ring access functions of AF_XDP in hope
> that it will now be easier to understand and maintain. I used to get a
> headache every time I looked at this code in order to really understand i=
t,
> but now I do think it is a lot less painful.
>=20
> The code has been simplified a lot and as a bonus we get better
> performance. On my 2.0 GHz Broadwell machine with a standard default
> config plus AF_XDP support and CONFIG_PREEMPT on I get the following
> results in percent performance increases with this patch set compared
> to without it:
>=20
> Zero-copy (-N):
>           rxdrop        txpush        l2fwd
> 1 core:     4%            5%            4%
> 2 cores:    1%            0%            2%
>=20
> Zero-copy with poll() (-N -p):
>           rxdrop        txpush        l2fwd
> 1 core:     1%            3%            3%
> 2 cores:   22%            0%            5%
>=20
> Skb mode (-S):
> Shows a 0% to 1% performance improvement over the same benchmarks as
> above.
>=20
> Here 1 core means that we are running the driver processing and the
> application on the same core, while 2 cores means that they execute on
> separate cores. The applications are from the xdpsock sample app.
>=20
> When a results says 22% better, as in the case of poll mode with 2
> cores and rxdrop, my first reaction is that it must be a
> bug. Everything else shows between 0% and 5% performance
> improvement. What is giving rise to 22%? A quick bisect indicates that
> it is patches 2, 3, 4, 5, and 6 that are giving rise to most of this
> improvement. So not one patch in particular, but something around 4%
> improvement from each one of them. Note that exactly this benchmark
> has previously had an extraordinary slow down compared to when running
> without poll syscalls. For all the other poll tests above, the
> slowdown has always been around 4% for using poll syscalls. But with
> the bad performing test in question, it was above 25%. Interestingly,
> after this clean up, the slow down is 4%, just like all the other poll
> tests. Please take an extra peek at this so I have not messed up
> something.
It overall makes sense to me.

Jonathan, can you also help to review?
