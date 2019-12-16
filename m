Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65F3121BA5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 22:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfLPVRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 16:17:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33972 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbfLPVRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 16:17:53 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGLAMRW013384;
        Mon, 16 Dec 2019 13:17:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Oft8QkQul/6ClH1/Mr9jtBHWTm61Ioa7QFuLhKPFE2U=;
 b=bS5CjxvoRsYVDEGIj4o3taAFBFFIIUGoXTral7oz5HbJr/OrmDiHja8qWOfsJpO9VEpf
 N4FYCQJfn3Ng+rVdIy+SkYs3dxuHcBxXH5DikGrOfTL5itBhxqfGNZjXy8v8wal8Kwm4
 7RssBMvy9U3mgGWz20U+AAPRaVg6hP49wLE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxcwy1jf8-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 13:17:35 -0800
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 13:17:34 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 13:17:34 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 13:17:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j30pbvollEzZVEr5Mn3LzBoHR5HxZhc6FTkimJIGRJZNXDjDgivYJdw1y2liA51gXtqzgC3tZ8WWQbikOuecZoMPvWI/9WRzL/hc28q3bALLPQihOmP0B6th42BQdrNE7140zgRJRidVZl3WIIibSXiEfaJi2GBe2asl2BOEiH0VmFeklHHVTPy/jlgDIBf7yzIzYdRpaQHg3u+p6+9/Z05shQz7hrZG/kFy8p2JRCD8XyxwX1uRJ+Pz2iAQRrTRB6lFDpsz/Lvi68HiOUSBO2NnRrcUboPTujRfYGb9sINLjHtInt+yeO9AwgrPmW63x0hsU+tf8QnaqsvRqHCAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oft8QkQul/6ClH1/Mr9jtBHWTm61Ioa7QFuLhKPFE2U=;
 b=QWg+8PizZbrWxdSN/PcVobpOfUzHHVJVh0ywl6A+GAGCuC1GsTlamI/yc0+HFh1ZJltTcFeft6fSCjG/9vsvkFZ7/A6qSPfh6ktq67M5XgEFiRfYiNCytS4V7T/I4634I99L+O3EeiWM7cS8MuRiJvuYoO4uGUVvkoCHhdptcs47jlX7bWi1Xcp7TuwU2P4D7T8C39TpPlUTcfl/RPAXYgnMjxYcVmrDUwBqBGAuLjfi1duYzHuLp5OOzQrvutIYSBbIJLhJCxOHh2fA9/fPh7NDaatke2Tj1ZlyQCMKO+pOPULTxFUvWgRKZovbEaqLIoLB+BEyMXtaNXC7+yU0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oft8QkQul/6ClH1/Mr9jtBHWTm61Ioa7QFuLhKPFE2U=;
 b=SdY/nZeeJjDCxILFGQuPeeye92OnPDYeRLMZUe+hLu95nZXGO8a5hlv5KwkiAO3DdX7PUar6SH1f8x+4FhxlUeHuCUp2no6532U+8T+wJN/emp7RXsd71ivE5Nldbmt38I798smmCmGjtvZImUM16UMt4IHOQJQvcj55mFgnIg0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2896.namprd15.prod.outlook.com (20.178.251.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 21:17:19 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 21:17:19 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Topic: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Index: AQHVsiI0ihgHNw98P02gRrT2dQLnz6e9JamAgAAFVICAAB0fgA==
Date:   Mon, 16 Dec 2019 21:17:19 +0000
Message-ID: <20191216211715.uxzcnj4zc3ba2rly@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <20191216191357.ftadvchztbpggcus@kafai-mbp.dhcp.thefacebook.com>
 <a2d8d888-16e1-243d-92c9-56ba3a3e1b18@gmail.com>
In-Reply-To: <a2d8d888-16e1-243d-92c9-56ba3a3e1b18@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0045.prod.exchangelabs.com (2603:10b6:300:101::31)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:71b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a8017c0-132d-429e-6102-08d7826d5511
x-ms-traffictypediagnostic: MN2PR15MB2896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2896D4FB4CD0E431E1B05F84D5510@MN2PR15MB2896.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(376002)(346002)(136003)(51914003)(199004)(189003)(71200400001)(54906003)(478600001)(2906002)(52116002)(186003)(6916009)(1076003)(6506007)(53546011)(5660300002)(6486002)(8936002)(86362001)(81166006)(8676002)(81156014)(66946007)(64756008)(66446008)(316002)(66476007)(66556008)(4326008)(6512007)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2896;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WSk88rvpanJzKkKInf6dvIBFe2hC6lOlJJZU0Tv41tBz3wQlYHAkaBJ1O9mIwYgjTUgsPciMR5baJpqadyhnlqZzeYWmGLNgETiLKtlbtG+TUACd8i9q1gZTcvYkA7sxMjwGLKqOwUPNThgazx3+yRQ9whpfQWZ11Q063e5fiF+s2t4r3pX4EEG5wUzyfweHWo7QC8xg8TpFNwK2m3SLAAwyaDGbS6t3X2FIrMHUoDoA6VVM/cCtUOk2Y98lGukbjnvxaIoiLEmyyQF255QenRY5Vg25uL/qyMahSFLZucJ2+hdthVSEwgYSke5iIO4Jw0dyGI82LgHMgWPrDv0yEWxJ1R9uMWIsWtV2ALa0FdjbzdI/44Ey8BuZaHxX0hwP0m374qZ/ThY6AwJIBbClauA0MDrOnS/nBjiFFF3260F5cJ70cgTbNvpNXzKKwvbz26t2TplKTwyBU6ADO2LFNnlMcKHNDe8+uRRlDcyyLj2R+/DJlLyeZUKL98dO+0Bs
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A7CE62B465BC2408D707E9B5F36875D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a8017c0-132d-429e-6102-08d7826d5511
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 21:17:19.2979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RSZJgqx8QHOkcqh6CCmkfrUnRxObcjbYcbF2QV+v0EEeKHPVxRN0v2pGEXFJ61nm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2896
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=365 phishscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 11:33:01AM -0800, Eric Dumazet wrote:
>=20
>=20
> On 12/16/19 11:14 AM, Martin Lau wrote:
> > On Fri, Dec 13, 2019 at 05:59:54PM -0800, Eric Dumazet wrote:
> >>
> >>
> >> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> >>> This patch adds a helper to handle jiffies.  Some of the
> >>> tcp_sock's timing is stored in jiffies.  Although things
> >>> could be deduced by CONFIG_HZ, having an easy way to get
> >>> jiffies will make the later bpf-tcp-cc implementation easier.
> >>>
> >>
> >> ...
> >>
> >>> +
> >>> +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
> >>> +{
> >>> +	if (!flags)
> >>> +		return get_jiffies_64();
> >>> +
> >>> +	if (flags & BPF_F_NS_TO_JIFFIES) {
> >>> +		return nsecs_to_jiffies(in);
> >>> +	} else if (flags & BPF_F_JIFFIES_TO_NS) {
> >>> +		if (!in)
> >>> +			in =3D get_jiffies_64();
> >>> +		return jiffies_to_nsecs(in);
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> >>
> >> This looks a bit convoluted :)
> >>
> >> Note that we could possibly change net/ipv4/tcp_cubic.c to no longer u=
se jiffies at all.
> >>
> >> We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be =
converted to ms.
> > Thanks for the feedbacks!
> >=20
> > I have a few questions that need some helps.
> >=20
> > Does it mean tp->tcp_mstamp can be used as the "now" in cubic?
>=20
> TCP makes sure to update tp->tcp_mstamp at least once when handling
> a particular packet. We did that to avoid calling possibly expensive
> kernel time service (Some platforms do not have fast TSC)=20
>=20
> > or tcp_clock_ns() should still be called in cubic, e.g. to replace
> > bictcp_clock() and tcp_jiffies32?
>=20
> Yeah, there is this lsndtime and tcp_jiffies32 thing, but maybe
> we can find a way to fetch jiffies32 without having to call a bpf helper =
?
Loading a kernel global variable is not yet supported.
Thus, helper is needed but it could be inlined like array_map_gen_lookup().
