Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F7837AC6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbfFFRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:17:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbfFFRRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:17:53 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56H7MT1007457;
        Thu, 6 Jun 2019 10:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Wj8ELLARzE1mTJq2p7LH10zZdupNyT9FtwhFSZEppxY=;
 b=JY0qu8mTj6ZHb9uWEP2VsSq2nMHj+EZ/8g0xJoyeylvGsAToklXHNEoWECGr8p6y0im7
 DS0gH3jG0xxDOEsT71gdOrW5OvBj1fzL62Dkgc+NVLyWfYCSol/tpNsGMNl443D28bpP
 yWwNmxS82x+a02lJaOFIbLzk6uNrjlTP+po= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy07a9kjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jun 2019 10:17:51 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 10:17:47 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 10:17:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj8ELLARzE1mTJq2p7LH10zZdupNyT9FtwhFSZEppxY=;
 b=F1E5q4hS/jjAUkG6ffKUeKvZ+oi3xc+eNLOt2CvEpPfLYcs8a/PymhaHV0EqUpinWeoN57iD0csFOM9AttwvxbBq8f46Ba8xV1Mw6/F0l+TVJjud1aH0rM7y+PQt/gaZzhJ8vBViVl9orRCpYZkD8jdtaC2ooHpqGjkAMJawBUQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1263.namprd15.prod.outlook.com (10.175.2.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 17:17:45 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 17:17:45 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Hechao Li <hechaol@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/2] bpf: use libbpf_num_possible_cpus in
 bpftool and selftests
Thread-Topic: [PATCH v2 bpf-next 2/2] bpf: use libbpf_num_possible_cpus in
 bpftool and selftests
Thread-Index: AQHVHIlfB45LrsDQrEOIdC3wdcxrZaaO3m8A
Date:   Thu, 6 Jun 2019 17:17:45 +0000
Message-ID: <AED5E1DA-DBD4-41C8-A78F-44A4ED19C06F@fb.com>
References: <20190606165837.2042247-1-hechaol@fb.com>
 <20190606165837.2042247-3-hechaol@fb.com>
In-Reply-To: <20190606165837.2042247-3-hechaol@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:bed9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c5d4a0c-3ee1-4ab7-3074-08d6eaa2e447
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1263;
x-ms-traffictypediagnostic: MWHPR15MB1263:
x-microsoft-antispam-prvs: <MWHPR15MB1263511F9BA0EA35B5D6179BB3170@MWHPR15MB1263.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:159;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(66556008)(66476007)(66446008)(102836004)(86362001)(486006)(186003)(76116006)(53546011)(73956011)(66946007)(83716004)(57306001)(6636002)(6116002)(71190400001)(71200400001)(2906002)(14444005)(5660300002)(256004)(8676002)(6862004)(25786009)(6246003)(33656002)(36756003)(68736007)(4326008)(450100002)(478600001)(6512007)(6436002)(50226002)(14454004)(81166006)(8936002)(81156014)(53936002)(446003)(99286004)(305945005)(37006003)(7736002)(54906003)(316002)(229853002)(46003)(11346002)(6486002)(76176011)(82746002)(476003)(2616005)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1263;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e3ZL4whBwVGdtcU1rCWrn/VSkGUp+uzg4UzGtliGLR0OII76ajiG+nwCSk4OK1qR11PNTcfgVk40S9r81oNYLhofqN0oGTn1et7OnE5MtXzQsmVHKc8n7iA1m8hw8H3gy94sT1k+v13ID2zkvaxRRfxVUkuGHVcq/NNg7uziszOsuEKOVb5WXe7DWV9txkaJ6T1lq03aAM4y84lj9mDeobp6/mO7oG+ve9cAjc5O/t32Buc4U8t2jtf4N+DabwniOOJfzt50v19/z6RQfjOPNYe9iXnB2vyNUgTigSIAmH/AkDNJwGV7Z6tm7/2j2gBoBNe2cdGsbYICL6Qe7Disu+oPqpOdr32M3X6noPNGwa0pZbLZ1z7oK1BGkBEUmN0avYb7E//F1tr9ZnUNW6Uw0plBTb8gxVDO8eNft2f5gR8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E306DA8B780738429153467D251C2A2C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5d4a0c-3ee1-4ab7-3074-08d6eaa2e447
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 17:17:45.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 6, 2019, at 9:58 AM, Hechao Li <hechaol@fb.com> wrote:
>=20
> Use the newly added bpf_num_possible_cpus() in bpftool and selftests
> and remove duplicate implementations.
>=20
> Signed-off-by: Hechao Li <hechaol@fb.com>
> ---
> tools/bpf/bpftool/common.c             | 53 +++-----------------------
> tools/testing/selftests/bpf/bpf_util.h | 37 +++---------------
> 2 files changed, 10 insertions(+), 80 deletions(-)
>=20
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index f7261fad45c1..0b1c56758cd9 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -21,6 +21,7 @@
> #include <sys/vfs.h>
>=20
> #include <bpf.h>
> +#include <libbpf.h> /* libbpf_num_possible_cpus */
>=20
> #include "main.h"
>=20
> @@ -439,57 +440,13 @@ unsigned int get_page_size(void)
>=20
> unsigned int get_possible_cpus(void)
> {
> -	static unsigned int result;
> -	char buf[128];
> -	long int n;
> -	char *ptr;
> -	int fd;
> -
> -	if (result)
> -		return result;
> -
> -	fd =3D open("/sys/devices/system/cpu/possible", O_RDONLY);
> -	if (fd < 0) {
> -		p_err("can't open sysfs possible cpus");
> -		exit(-1);
> -	}
> -
> -	n =3D read(fd, buf, sizeof(buf));
> -	if (n < 2) {
> -		p_err("can't read sysfs possible cpus");
> -		exit(-1);
> -	}
> -	close(fd);
> +	int cpus =3D libbpf_num_possible_cpus();
>=20
> -	if (n =3D=3D sizeof(buf)) {
> -		p_err("read sysfs possible cpus overflow");
> +	if (cpus <=3D 0) {
> +		p_err("can't get # of possible cpus");
> 		exit(-1);
> 	}
> -
> -	ptr =3D buf;
> -	n =3D 0;
> -	while (*ptr && *ptr !=3D '\n') {
> -		unsigned int a, b;
> -
> -		if (sscanf(ptr, "%u-%u", &a, &b) =3D=3D 2) {
> -			n +=3D b - a + 1;
> -
> -			ptr =3D strchr(ptr, '-') + 1;
> -		} else if (sscanf(ptr, "%u", &a) =3D=3D 1) {
> -			n++;
> -		} else {
> -			assert(0);
> -		}
> -
> -		while (isdigit(*ptr))
> -			ptr++;
> -		if (*ptr =3D=3D ',')
> -			ptr++;
> -	}
> -
> -	result =3D n;
> -
> -	return result;
> +	return cpus;
> }
>=20
> static char *
> diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selft=
ests/bpf/bpf_util.h
> index a29206ebbd13..9ad9c7595f93 100644
> --- a/tools/testing/selftests/bpf/bpf_util.h
> +++ b/tools/testing/selftests/bpf/bpf_util.h
> @@ -6,44 +6,17 @@
> #include <stdlib.h>
> #include <string.h>
> #include <errno.h>
> +#include <libbpf.h>
>=20
> static inline unsigned int bpf_num_possible_cpus(void)
> {
> -	static const char *fcpu =3D "/sys/devices/system/cpu/possible";
> -	unsigned int start, end, possible_cpus =3D 0;
> -	char buff[128];
> -	FILE *fp;
> -	int len, n, i, j =3D 0;
> +	int possible_cpus =3D libbpf_num_possible_cpus();
>=20
> -	fp =3D fopen(fcpu, "r");
> -	if (!fp) {
> -		printf("Failed to open %s: '%s'!\n", fcpu, strerror(errno));
> +	if (possible_cpus <=3D 0) {
> +		printf("Failed to get # of possible cpus: '%s'!\n",
> +		       strerror(-possible_cpus));

strerror(0) is "Success". This is a little weird.=20

Thanks,
Song

> 		exit(1);
> 	}
> -
> -	if (!fgets(buff, sizeof(buff), fp)) {
> -		printf("Failed to read %s!\n", fcpu);
> -		exit(1);
> -	}
> -
> -	len =3D strlen(buff);
> -	for (i =3D 0; i <=3D len; i++) {
> -		if (buff[i] =3D=3D ',' || buff[i] =3D=3D '\0') {
> -			buff[i] =3D '\0';
> -			n =3D sscanf(&buff[j], "%u-%u", &start, &end);
> -			if (n <=3D 0) {
> -				printf("Failed to retrieve # possible CPUs!\n");
> -				exit(1);
> -			} else if (n =3D=3D 1) {
> -				end =3D start;
> -			}
> -			possible_cpus +=3D end - start + 1;
> -			j =3D i + 1;
> -		}
> -	}
> -
> -	fclose(fp);
> -
> 	return possible_cpus;
> }
>=20
> --=20
> 2.17.1
>=20

