Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B6D11FF2
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEBQQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:16:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53364 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbfEBQQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:16:26 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42FqUZ3000935;
        Thu, 2 May 2019 09:03:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jhC52U5ERQoxFB33P22d6fxaugFMI5uXIdZXmP8X+yw=;
 b=XgcF4DMwCcLsDIOVGVDrEd5xJJr4IPkLiSPCGiSZk5k7OSnOu/tWrRuRr0o+oOB7eaxy
 pxgxp+5hz0Hok3Ol+umv02yC4StI26jdwzOCW6Dy50c3qlbHjhQhvCZbzGYNGeD1OhQW
 xN8hThtip454ZC1Hm6qgvD9QR6d77MblBEU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2s7qmm1ybs-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 May 2019 09:03:48 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 May 2019 09:03:33 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 2 May 2019 09:03:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhC52U5ERQoxFB33P22d6fxaugFMI5uXIdZXmP8X+yw=;
 b=iT6++5EhIaRzK/ZEir+h82nXVFEh9ngLqrg5AMJewgG1MC9me4CgR45xieH0/TqUAstJpDje/cX4s9eP+oKxmfr01EenvgU+ipfpFz6SyIf1hV7/8jZCIoeTlo6835XNvH1+N6q6YW4UHqenexKiECFszYpbPoID52RgUKScP5Q=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1359.namprd15.prod.outlook.com (10.173.232.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Thu, 2 May 2019 16:03:30 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1856.008; Thu, 2 May 2019
 16:03:30 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] libbpf: always NULL out pobj in bpf_prog_load_xattr
Thread-Topic: [PATCH bpf] libbpf: always NULL out pobj in bpf_prog_load_xattr
Thread-Index: AQHVAP7AoiYaIV3SIkmRog/KiBzbz6ZX/yYA
Date:   Thu, 2 May 2019 16:03:30 +0000
Message-ID: <20190502160324.uroud3xrggnfgvrp@kafai-mbp.dhcp.thefacebook.com>
References: <20190502154932.14698-1-lmb@cloudflare.com>
In-Reply-To: <20190502154932.14698-1-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0057.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::34) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::378c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bc97070-4f84-49e0-6ca7-08d6cf17b81e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1359;
x-ms-traffictypediagnostic: MWHPR15MB1359:
x-microsoft-antispam-prvs: <MWHPR15MB135938D6A7C56E1D7A782FACD5340@MWHPR15MB1359.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(376002)(346002)(199004)(189003)(71190400001)(71200400001)(7736002)(8936002)(486006)(53936002)(6486002)(6916009)(99286004)(11346002)(476003)(6246003)(6436002)(229853002)(1076003)(64756008)(66446008)(66556008)(66476007)(2906002)(14454004)(186003)(66946007)(73956011)(86362001)(46003)(68736007)(54906003)(76176011)(386003)(316002)(52116002)(4326008)(81156014)(446003)(25786009)(478600001)(6506007)(6116002)(102836004)(6512007)(5660300002)(9686003)(256004)(305945005)(14444005)(8676002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1359;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kDOacQqawGOkijEM0E4eTkiYRrw5x5H8R9qzZMXMmQB9wNWCxw3O8aQd810YddXL8GAAbPesDU9YQJZm3jdvzu8/xx7bEhDiFyxSGWmLSTX3e4bIbXOT8plTddFJHcnUc+LdpKqRT5clA5z/z3S7Is1ogGymhApaOzeFd6Dd+4kbxEa0zpoA+OXcVw1yv/53zCRXwfvtkObcwEWzzY0TGM+kIw2D9HW72Orsf1H6yTLfjqxIFSWICOddVH/gmXasLCIEOpfikRNoZTsCepYg/0xAJDAECYdCYq2XUsybedFfycpM/45l0mWknjkyyrYZdf6/SZzYdK3xGvhBWDVlTPQiGuCB4/dgfusk2OJopbB3SwntuHyMyTAjCQJ9EeVpCMixwlI1wbB+WDcFfk3FuCtSi1rYo2LeY0+hhMtwYWw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC0010F7FDE1C145A1862B77BF8744A0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc97070-4f84-49e0-6ca7-08d6cf17b81e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 16:03:30.6798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1359
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905020105
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 11:49:32AM -0400, Lorenz Bauer wrote:
> Currently, code like the following segfaults if bpf_prog_load_xattr
> returns an error:
>=20
>     struct bpf_object *obj;
>=20
>     err =3D bpf_prog_load_xattr(&attr, &obj, &prog_fd);
>     bpf_object__close(obj);
This is a bug.  err should always be checked first before
using obj or prog_fd.  If there is err, calling bpf_object__close(NULL)
is another redundancy.

>     if (err)
>         ...
>=20
> Unconditionally reset pobj to NULL at the start of the function
> to fix this.
Hence, this change is unnecessary.

>=20
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 11a65db4b93f..2ddf3212b8f7 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3363,6 +3363,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_=
attr *attr,
>  	struct bpf_map *map;
>  	int err;
> =20
> +	*pobj =3D NULL;
> +
>  	if (!attr)
>  		return -EINVAL;
>  	if (!attr->file)
> --=20
> 2.19.1
>=20
