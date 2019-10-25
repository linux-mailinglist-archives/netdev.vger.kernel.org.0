Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8FD9E42C7
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 07:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392554AbfJYFKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 01:10:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58814 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391798AbfJYFKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 01:10:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9P55HV6020465;
        Thu, 24 Oct 2019 22:10:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dljN4+4X6kQIpN9cI5/XBTJnbehZJIVwkjHCy7zsya4=;
 b=jACi1ERUEeZ5sraBDSApL3B9+YHIEUnfneVaNg+eaHouHsdNx7S5ZYIbdtymys1k5+YP
 7CVe7JC+XxRZjEhLnxtoWJw6e3bWrEkCgsCoiDimWH7le/krN2FpnkRZsoAkO6MwQ3Lg
 JMKn5aaKzyBPgF9lNB2O9xfbudek8SwOur8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vu01p6yd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Oct 2019 22:10:36 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 24 Oct 2019 22:10:34 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Oct 2019 22:10:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ResL2fyCUT/RhMCqK0/GLCc+vFKOScsgUPcnycV49JmJ49XymTRwBk4xBsyYXNAOHa7QgC3AMxhOgTNgo86UI/DWMITtUd4Gk44WA+QMdTvQl/ZYJiajxgW7CXiusdBatEDqNo+1SV7eoHBlvlEX8YZhoEnmnYdDoJbcwQSvxFkm4uNq+zqUibL/SPpwYjA1aZ8fifog/8/MJZdlqltGLIM9wJiFi+fbMUmYzEm0y9cFf38HBOifdQY9JpTFSV2+3iMFJA7wD0fgfBOQ7XKeglh441/9SK6ak8ZvrRfr0JUeSrBDDOLkglOWXpzwvOJJ5S96uGoVzIlhI74ndPOmLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dljN4+4X6kQIpN9cI5/XBTJnbehZJIVwkjHCy7zsya4=;
 b=SNLlDZEUyDDB00afVLdWlXIl5CptRSqOCKO8Akh/uKXqW9bQ5mnPDDnu+ztuMFEq0EccHboaqYbxuIGfSM6f/78quLdN2QSxDN8cd//BPxAHxljT7B23Hycjy28jUgw31YW9cuhG8mvz+gOCLePrwKRnvz3FV/+i6hOg4E8Tx8+MqIkZn9MyttqrEu7N8W06Emk0AYgDfy5fOrfUA4XM4048aKSCskva5TNB//8njGn+X7eECDmMtB1MmGlQp3o7Je52g3DkAa2trxh25YQIqgKwzRt5dKdK+MvihWH13IpxC9C+H/v2Br9P43GMMovDvinUka2/GYq0QUYnbVAOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dljN4+4X6kQIpN9cI5/XBTJnbehZJIVwkjHCy7zsya4=;
 b=AE3a6uL0wk3va7gjlGktknpddPd2mBQTAWLdvhMJnC8u2gJWuc2ZnU8Jan9Khj7QZvLE6wA35Ef/RHAfJUeVhGSXpm4v3zG+ZwwqGQ4PnSFhOdc+OV6wLl20UhV12bANR0RU3+32R6JzmyHs0La7HqlUQfsoYh0sIJP6D5SVcJs=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1447.namprd15.prod.outlook.com (10.172.155.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 25 Oct 2019 05:10:31 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2347.030; Fri, 25 Oct 2019
 05:10:31 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH] bpftool: Allow to read btf as raw data
Thread-Topic: [PATCH] bpftool: Allow to read btf as raw data
Thread-Index: AQHVim83WKrVGwfEYE23NjvFYS+Li6dq0CkA
Date:   Fri, 25 Oct 2019 05:10:31 +0000
Message-ID: <69f99d56-4738-5e94-4bf5-73b60fe03312@fb.com>
References: <20191024133025.10691-1-jolsa@kernel.org>
In-Reply-To: <20191024133025.10691-1-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:300:ee::21) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f95b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c4f8fa6-4772-44ad-8192-08d75909a872
x-ms-traffictypediagnostic: CY4PR15MB1447:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB14472296812B5FC2EA3DA3A7C6650@CY4PR15MB1447.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(39860400002)(366004)(136003)(396003)(376002)(346002)(199004)(189003)(65956001)(66476007)(4326008)(66556008)(66446008)(478600001)(65806001)(66946007)(2906002)(31686004)(14454004)(81156014)(54906003)(8676002)(6486002)(81166006)(316002)(6512007)(7736002)(25786009)(6116002)(8936002)(6436002)(486006)(46003)(76176011)(64756008)(6246003)(71190400001)(256004)(86362001)(14444005)(5660300002)(102836004)(386003)(53546011)(36756003)(229853002)(110136005)(446003)(99286004)(2616005)(71200400001)(476003)(52116002)(31696002)(58126008)(186003)(305945005)(11346002)(6506007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1447;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:3;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vEawRguO+Bg9qIDLz/NNwIwSvJFMabuslcon5VoafmEp8LIYb/bUvYGqJJGJFwXkdAMzTXQM1+xEqzqakfop2lSbUNuJSSba+C+GO6H/TOoEbBovG9lFCCvHeXSsn5HDKPNQmk4htl6Rkf/jsU3IDAowphtRHBUz0Vokyzcw1uYnxkfJ3/cRG1f2dnFhh0+Q02oWkcMGE+Q4o7eybO9qaqgWH8o6UwUXHW8JpPL8YlHChmfcGzrfg/ZyTgbhVOcY8tk6pE3v4gFJ3N8Okga4lu63/R953c0FwydxqXRUvTwYnWLPUTlK4Hny7Q0Kt72I3u6pbVayKph3ViYMYsQFC761bdsP2vOZKiR5ZfDL4IUahrB1nLtKSf9WPeQ2GiOlvY1yMrAp+/EgRAcR2k8D82bQt/EtiOnu3XUi6UlnOEtv9yvGBAA/HNJazi87dTAS
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <021151EAB659214F89A94BACAAE93D21@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4f8fa6-4772-44ad-8192-08d75909a872
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 05:10:31.3558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iy6dae/+LaFWCXVagCZZJ+msAivUxkFIwALXWPUlhsWxtr/hPwx41UX/pVGsvnPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1447
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_02:2019-10-23,2019-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910250049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 6:30 AM, Jiri Olsa wrote:
> The bpftool interface stays the same, but now it's possible
> to run it over BTF raw data, like:
>=20
>    $ bpftool btf dump file /sys/kernel/btf/vmlinux
>    [1] INT '(anon)' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3D(non=
e)
>    [2] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 enco=
ding=3D(none)
>    [3] CONST '(anon)' type_id=3D2
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> v3 changes:
>   - fix title

The subject (by now) should be "[PATCH v3 bpf-next] ...". Include both=20
version and intended tree (bpf-next usually).

>=20
> v2 changes:
>   - added is_btf_raw to find out which btf__parse_* function to call
>   - changed labels and error propagation in btf__parse_raw
>   - drop the err initialization, which is not needed under this change
>=20
>   tools/bpf/bpftool/btf.c | 57 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 56 insertions(+), 1 deletion(-)
>=20


Overall looks good. It's kind of sad that we re-open that file twice,=20
but we can optimize that later, if it ever is a problem. We should=20
probably eventually implement btf__parse_raw as libbpf API with mmap2().
But perfect is the enemy of the good, so:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index 9a9376d1d3df..a7b8bf233cf5 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -12,6 +12,9 @@

[...]

