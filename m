Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F78571534
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfGWJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:30:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726284AbfGWJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:30:18 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N9RRBh026922;
        Tue, 23 Jul 2019 02:29:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4AuXQKAUAth/DwIlIkDLBwpDiegU/dpAc0QkMTVCfCA=;
 b=K+hqSF1nEe6Ycg5zhVkcToLjw8SFu/D1aN13pVcvB09vvwanvIrWqP8fJAS2pqvZcBUN
 36/16QCNp8jYkX6+wC09/vFcZILyW+LZAB2HFQ8zLRfFX1/jmBrDaM72Ef1wEN2ndSIv
 1LM9+ozIGmIQrsZVrWrGIUpuZcZ2mUIfeFI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twkjpt8b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 02:29:57 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:29:57 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 23 Jul 2019 02:29:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 02:29:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2Q5eJN2eviHkOFZHjWNZiiW0HFl2QUPJKXy2SngoC2ZbfzEp30gThuG0t+uN3Bvwl08VmToEroPuDQcNpnZIdK9D3KBHXaCOHxS33DJP0O+/5hEj6ogb//yJ1BFUFxpSioapYy8+RqqmN1e71oHiqS8kQSlt36V1pYPGgzLYlgZ0WeaAgFFFOf5Vk0eNUqmdZ70KUvKuWpbnHsGA/Sp2aG0Wyj++MFwu7S3QpBI2HmpOyT0T0mei00J8yJ8Yhwt1c/XFuaLTzeoLzov9pg5TwxM7MX1PaaE0mh3WC1ggvh6HtN8L7UmBHgHoDFpPBu8JYuufn7COUdmKl21XoxKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AuXQKAUAth/DwIlIkDLBwpDiegU/dpAc0QkMTVCfCA=;
 b=CZ9tgwhG+PF5rZcHFDbkrXIGjA6H61QmjzUN4sa6cGzcQUR0V11actcHP9KC1I0xeRY5EZ5FYtujAoJoQs61hMly3H3uNut9Bc654zYzQP6VUfM56yuaNg9wVPgATBD4TGeS+OcKRv7cjUjD+eQmCeFyPtwpsuewTvGqPf5kxDEtGhR20PNwb4E4RT1o+OrjtSDaL5rjYijExzZ+sUyyVOPax3Il8yuQa9jZPYGbYwk8uRn5+/9i6MrrUtaPqAv9w+apkXiGs6ICQCgtQTcEkpw0oWJwsP/tHQaUuckg5yqPkxpm3oDo5HSPzn6kSbvCyQA0gbnpn9Q7vXlEJNGmow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AuXQKAUAth/DwIlIkDLBwpDiegU/dpAc0QkMTVCfCA=;
 b=bMxfaqBUvhriq+NGG39BTaz4Sna3vl/b3RWTH4gXaVuuYpTcqRmp5donZe12mAnpf8yMTN1p8OT9hlcgydCwiXmVcmqis0pv9dZm1hR2toXdiW5SjMgNM4KUvjYIoSw0ZET2z/u+F12KznNZHr+1BtZEr5F/4b871J0R9/qbwkA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1741.namprd15.prod.outlook.com (10.174.254.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 09:29:55 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 09:29:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/5] samples/bpf: switch trace_output sample to
 perf_buffer API
Thread-Topic: [PATCH bpf-next 4/5] samples/bpf: switch trace_output sample to
 perf_buffer API
Thread-Index: AQHVQQ+P2DRiHPGPVku0H+VtRgd3labX8D8A
Date:   Tue, 23 Jul 2019 09:29:55 +0000
Message-ID: <3ED4F7C4-CE2D-41D6-B26D-FFD1EDB23157@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
 <20190723043112.3145810-5-andriin@fb.com>
In-Reply-To: <20190723043112.3145810-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:2cda]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 080e2833-8938-474e-9c53-08d70f50529e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1741;
x-ms-traffictypediagnostic: MWHPR15MB1741:
x-microsoft-antispam-prvs: <MWHPR15MB17415C0A7F13B3D15F38DFDFB3C70@MWHPR15MB1741.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(478600001)(68736007)(6486002)(53936002)(33656002)(446003)(6436002)(76176011)(316002)(37006003)(81166006)(2616005)(186003)(6862004)(25786009)(57306001)(6512007)(50226002)(81156014)(8936002)(99286004)(46003)(54906003)(11346002)(476003)(4326008)(229853002)(6636002)(71200400001)(71190400001)(36756003)(6506007)(7736002)(53546011)(6246003)(66476007)(102836004)(66946007)(66556008)(64756008)(2906002)(305945005)(66446008)(76116006)(8676002)(14444005)(256004)(5660300002)(6116002)(86362001)(14454004)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1741;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I6hYKwI1L2GuL4McDK1couU/Xmq1FLcmSx4gm3R3aYwGprLk5A7p9nfIeIpx4wY2KOeDMYZMtCnrDsJ3dQNeegYPeNIlNU4HFSPV5/AYUU8n47YAk51dUHqK4RNHjPPcFwqgvek51/QoHAZsF4gRnJ/laXAoNN5Yd8bnNoXarLjLXeCyHo6kboqrX7d/Rg1qeUwowAlta5ubyCOQxzA/Oaw1VqLEnn0UA6Q5yiPwbk17Koz0IgLRWxZItV6I3pJ/haEtsSfLo69uIdPRef96ILVR5M8wnzm3j0foNkQw9Xc8VaemDYHXGP7LVjHAjYDyJx4eyEzzQW+M5hOyM4OXDoeMI90IwTbMvK5/Y4ItGdqLcjuTJVslsfMT5wvofsmAYRBrdNpt2ibwjXQM1KfnYChtV4+7w3T1U6WVE2w/eEs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <45DF4C9B6B520C46A74390972E06AF64@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 080e2833-8938-474e-9c53-08d70f50529e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 09:29:55.2479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1741
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230089
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2019, at 9:31 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Convert trace_output sample to libbpf's perf_buffer API.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> samples/bpf/trace_output_user.c | 43 +++++++++++----------------------
> 1 file changed, 14 insertions(+), 29 deletions(-)
>=20
> diff --git a/samples/bpf/trace_output_user.c b/samples/bpf/trace_output_u=
ser.c
> index 2dd1d39b152a..8ee47699a870 100644
> --- a/samples/bpf/trace_output_user.c
> +++ b/samples/bpf/trace_output_user.c
> @@ -18,9 +18,6 @@
> #include <libbpf.h>
> #include "bpf_load.h"
> #include "perf-sys.h"
> -#include "trace_helpers.h"
> -
> -static int pmu_fd;
>=20
> static __u64 time_get_ns(void)
> {
> @@ -31,12 +28,12 @@ static __u64 time_get_ns(void)
> }
>=20
> static __u64 start_time;
> +static __u64 cnt;
>=20
> #define MAX_CNT 100000ll
>=20
> -static int print_bpf_output(void *data, int size)
> +static void print_bpf_output(void *ctx, int cpu, void *data, __u32 size)
> {
> -	static __u64 cnt;
> 	struct {
> 		__u64 pid;
> 		__u64 cookie;
> @@ -45,7 +42,7 @@ static int print_bpf_output(void *data, int size)
> 	if (e->cookie !=3D 0x12345678) {
> 		printf("BUG pid %llx cookie %llx sized %d\n",
> 		       e->pid, e->cookie, size);
> -		return LIBBPF_PERF_EVENT_ERROR;
> +		return;
> 	}
>=20
> 	cnt++;
> @@ -53,30 +50,14 @@ static int print_bpf_output(void *data, int size)
> 	if (cnt =3D=3D MAX_CNT) {
> 		printf("recv %lld events per sec\n",
> 		       MAX_CNT * 1000000000ll / (time_get_ns() - start_time));
> -		return LIBBPF_PERF_EVENT_DONE;
> +		return;
> 	}
> -
> -	return LIBBPF_PERF_EVENT_CONT;
> -}
> -
> -static void test_bpf_perf_event(void)
> -{
> -	struct perf_event_attr attr =3D {
> -		.sample_type =3D PERF_SAMPLE_RAW,
> -		.type =3D PERF_TYPE_SOFTWARE,
> -		.config =3D PERF_COUNT_SW_BPF_OUTPUT,
> -	};
> -	int key =3D 0;
> -
> -	pmu_fd =3D sys_perf_event_open(&attr, -1/*pid*/, 0/*cpu*/, -1/*group_fd=
*/, 0);
> -
> -	assert(pmu_fd >=3D 0);
> -	assert(bpf_map_update_elem(map_fd[0], &key, &pmu_fd, BPF_ANY) =3D=3D 0)=
;
> -	ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> }
>=20
> int main(int argc, char **argv)
> {
> +	struct perf_buffer_opts pb_opts =3D {};
> +	struct perf_buffer *pb;
> 	char filename[256];
> 	FILE *f;
> 	int ret;
> @@ -88,16 +69,20 @@ int main(int argc, char **argv)
> 		return 1;
> 	}
>=20
> -	test_bpf_perf_event();
> -
> -	if (perf_event_mmap(pmu_fd) < 0)
> +	pb_opts.sample_cb =3D print_bpf_output;
> +	pb =3D perf_buffer__new(map_fd[0], 8, &pb_opts);
> +	ret =3D libbpf_get_error(pb);
> +	if (ret) {
> +		printf("failed to setup perf_buffer: %d\n", ret);
> 		return 1;
> +	}
>=20
> 	f =3D popen("taskset 1 dd if=3D/dev/zero of=3D/dev/null", "r");
> 	(void) f;
>=20
> 	start_time =3D time_get_ns();
> -	ret =3D perf_event_poller(pmu_fd, print_bpf_output);
> +	while ((ret =3D perf_buffer__poll(pb, 1000)) >=3D 0 && cnt < MAX_CNT) {
> +	}
> 	kill(0, SIGINT);
> 	return ret;
> }
> --=20
> 2.17.1
>=20

