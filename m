Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDC7C1B44
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfI3GHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:07:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62766 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbfI3GHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:07:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8U5xQbZ030608;
        Sun, 29 Sep 2019 23:07:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=O3vCMFHvmEuomKeeuP4grlPG+rEue+VNS31I8W0eE3k=;
 b=MrQEk54vIzOkCQ3pqDArus4pPsPJ2BqVwYOT+JiUChz8f2kg/eTeeiUEDiUKpBcqf6+j
 5rEI2CYnCn1uLPgk8kaTGAU6uKKlJpVsWMhfPtyx+ePnnZq4c8k/WOfBbqiUps6F4zN/
 gZH2YIFhgVu1cP6RJIIirQA8AhQA9NNlKmI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2va51nxxsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 29 Sep 2019 23:07:10 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 29 Sep 2019 23:07:09 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 29 Sep 2019 23:07:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwicwkTyyWNBRLxEFNTym09Ues6sA7vtByGM0E/rjgSolkmhascZCQ/XWIIHv4FI5rhGJPVHbW53dx/yhoFqhE0MViDbzQXITJLUZPxbSd7n14qRcbYg2lmDXf4pYvZttUKF/9pr6jzYpdWARFkN/U5MIT+OBv+He/jyjEPfC4s7mR37cmX8cyyhtHEu1kmNnZ/jKrCkw8mMUy8XrGZWKSpLp9okOUOwtwinAc9IEEOgNl8RD8ojpVhYhKxfV2FSyVlQbvr+ao5bAOg2D9Yk4slD7chF23csyOs2Bah5KvcwAOyntQnKDkfkNQ0C7VHs9dYS9gM6KXfWvSu0eYPtsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3vCMFHvmEuomKeeuP4grlPG+rEue+VNS31I8W0eE3k=;
 b=dl8Ydt1Q9KsaFxeUSA3Gao5WpOVTKuZypUwmGQx3sQVw77fvfGQZeahBaBOAgFaIAgRKTZ/1EdPqkWB/ikdmFuhg0obR3zIC4sDVNPIBuaDKRGmhLOzZj/NVx5KQJlQ2ImrS5KOu9JSk2H816kflc2bL/9uP+n2psq9+NKDAyLseQFSy1iCVbFCAGir4WCSzbn6+yNUIRtXS/kApF5fEk9GBaLqc3ZhbwMTIRQNtvTU9PxofPckj3UQ7UpJ8nUBtsFVYLSxKiYhFxI0rq78f5TBuygtBuzVIFc74KLna8MPB/hQFmaJEUuGB7meJ0zYXDB/3sO7RwXm2kbddygKFEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3vCMFHvmEuomKeeuP4grlPG+rEue+VNS31I8W0eE3k=;
 b=KqldAg6vQLJpngtxZ5OgSJR4n3ErBztGvGW6jBX+8KO6nfxGqLk8c9TVEKeuW1LfK084j3JKcVrkzd5VCOAf3jXRzqkntPE/THjD8XBUE8B5Wg7WMk0Tu5Rtt3WGQCMoZF2UiRWsxsKOvP7aPV3RQ498E55/UYTESdQwL9cJA2A=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Mon, 30 Sep 2019 06:06:54 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 06:06:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically
 possible
Thread-Topic: [PATCH bpf] libbpf: count present CPUs, not theoretically
 possible
Thread-Index: AQHVdcY+HVQrmFlMQkCK3+rYCoZVh6dDvvaA
Date:   Mon, 30 Sep 2019 06:06:54 +0000
Message-ID: <05329A22-363F-4C12-9B6D-F9A2941C749E@fb.com>
References: <20190928063033.1674094-1-andriin@fb.com>
In-Reply-To: <20190928063033.1674094-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::387f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33ae3ebf-6ed9-435a-3aa8-08d7456c6491
x-ms-traffictypediagnostic: MWHPR15MB1165:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1165D277FE9FFEE15446E910B3820@MWHPR15MB1165.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(39860400002)(346002)(136003)(199004)(189003)(66556008)(446003)(66476007)(76176011)(478600001)(6512007)(476003)(64756008)(8936002)(81156014)(14444005)(256004)(99286004)(76116006)(6862004)(486006)(81166006)(305945005)(2616005)(4326008)(66946007)(8676002)(6436002)(5660300002)(11346002)(316002)(25786009)(71200400001)(71190400001)(46003)(14454004)(2906002)(6486002)(102836004)(6636002)(229853002)(6246003)(186003)(66446008)(7736002)(6116002)(50226002)(86362001)(33656002)(6506007)(36756003)(37006003)(53546011)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1165;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f8RT7Ro7yTpql2Tc+rceMtsHWfRDLvaAjmffvnzS6hBioIkXWz5b0HWMGaujraUnlJJm4HL/1ryKf/4Yc4BgzrEI2p7M/q5sa549tfRdev4XrUVPVdbw/G9c7YTAI7ErmXNfYea+3u5hihqLu8kKQLKz9RHiLT29LY8tGbOo55ixYrmcliLhxTxUZyx9zDZa4G9WMJxO8UcAR6JvwI7fvX8TxOS73AQotBI23+6dcj8Z+PynHxe1QOFOeVuRjnD59y//34amGGOOcC5zKaT2a0tJg8J/UBxqBJ5MkCE+pVTIljQ2SQYFQI5+IO87iTRM7cD+choCoe5G6hNyekuwziWEb1rQCxRmNJmhObr8gn+eF45XGx2xEu8SdV8bGbYHkAvK51fj1AzeRJHXfoZ0O7AftOovoQ7vp17gyx7DiiU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9BE49EF32E886349BADDF44DDDE28BD3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ae3ebf-6ed9-435a-3aa8-08d7456c6491
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 06:06:54.0819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M8yKL7EfUG6rzMbkgkbU5YmLRp9ksKQOKrArgrzJxbrKUjWB+iuMexyxhhL4TgSCUssrfqJWgGoBYKwZb5HOsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1165
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_02:2019-09-25,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909300063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 27, 2019, at 11:30 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> This patch switches libbpf_num_possible_cpus() from using possible CPU
> set to present CPU set. This fixes issues with incorrect auto-sizing of
> PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.
>=20
> On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> be a set of any representable (i.e., potentially possible) CPU, which is
> normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> tested on, while there were just two CPU cores actually present).
> /sys/devices/system/cpu/present, on the other hand, will only contain
> CPUs that are physically present in the system (even if not online yet),
> which is what we really want, especially when creating per-CPU maps or
> perf events.
>=20
> On systems with HOTPLUG disabled, present and possible are identical, so
> there is no change of behavior there.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e0276520171b..45351c074e45 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog=
_info_linear *info_linear)
>=20
> int libbpf_num_possible_cpus(void)
> {
> -	static const char *fcpu =3D "/sys/devices/system/cpu/possible";
> +	static const char *fcpu =3D "/sys/devices/system/cpu/present";

This is _very_ confusing. "possible cpus", "present cpus", and "online=20
cpus" are existing terminologies. I don't think we should force people=20
to remember something like "By possible cpus, libbpf actually means=20
present cpus".=20

This change works if we call it "libbbpf_num_cpus()". However, =20
libbpf_num_possible_cpus(), should mean possible CPUs.=20

Thanks,
Song

