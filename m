Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D56555CB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbfFYRV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:21:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726455AbfFYRV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:21:56 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5PHHBG9023411;
        Tue, 25 Jun 2019 10:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rqcx32n6K2xAKMtXyAyeuWA6VIPTpUiWVMsw/7fsvQw=;
 b=NpFGSSW0d2vQvlHJI0oyUe8RDeE60f0R/vTblRvg5YfHiGEHqmGIMiJxLH2lD4TjFZ4h
 EZrmxjMbwlJ3rdVmX8hxw9c612eRJDkYO3zagslb7tyG8UVXUTAtkA5bMPOlLWYJVXKn
 iOM7mWHB2b324/5wA1YwOEM/Op9BqU6bsac= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2tbpv809r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 10:21:34 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 10:21:33 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 10:21:33 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Jun 2019 10:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqcx32n6K2xAKMtXyAyeuWA6VIPTpUiWVMsw/7fsvQw=;
 b=dLgmccoqO7ysOOQd7ocKacwRQWtsF5J4Wte9GWt2alDgVAyDbtc1nCaAp4fCd8ToUy3K9ZnbfNjekNdMPNdDL2Cgpd1o11OhkYd5nCME7IYxHQ5JCVtKVckz/mCGaSadZ9LdR1vfoXNHgn/bGsxB8Q/Tor8ZlGlugmRyRfEjyD0=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2817.namprd15.prod.outlook.com (20.179.140.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:21:32 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad%6]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:21:32 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "sdf@google.com" <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf] tools: bpftool: use correct argument in cgroup errors
Thread-Topic: [PATCH bpf] tools: bpftool: use correct argument in cgroup
 errors
Thread-Index: AQHVK3cLg1ptJQtzdka48vOr6rDzjqasnegA
Date:   Tue, 25 Jun 2019 17:21:31 +0000
Message-ID: <20190625172126.GB6128@tower.DHCP.thefacebook.com>
References: <20190625165631.18928-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190625165631.18928-1-jakub.kicinski@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:102:2::33) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::40d1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d983023a-185a-4aa2-f3eb-08d6f99190e7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB2817;
x-ms-traffictypediagnostic: BN8PR15MB2817:
x-microsoft-antispam-prvs: <BN8PR15MB28179EC2FCB1B6C7FF262BCEBEE30@BN8PR15MB2817.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(396003)(39860400002)(346002)(366004)(136003)(199004)(189003)(14454004)(71190400001)(5660300002)(71200400001)(102836004)(1076003)(46003)(52116002)(7736002)(73956011)(86362001)(66946007)(6246003)(446003)(76176011)(305945005)(486006)(11346002)(99286004)(64756008)(66446008)(66556008)(66476007)(81166006)(4326008)(256004)(54906003)(81156014)(478600001)(5024004)(6436002)(476003)(316002)(8936002)(6916009)(68736007)(6512007)(6486002)(2906002)(9686003)(386003)(6506007)(186003)(229853002)(33656002)(25786009)(6116002)(53936002)(8676002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2817;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y8xkEL3mekwjCi1mrVREITUn3kPSj8TmOSbXLWiIHbvUeqVivKlo72mzR5jfI8K1Yf7pPRW5yTFvyW5DOm2Jy6j2oABPn8mJ9I/kPfXd7ueGr9e6YaCQ/vsBruDpanyIXEtCsJ9GqWPYAWUmInTi32pjfirj9Aibjt3+r7j2oPLCGiZTg5635sNwvDo7xcVk8vFpO4S++ucvu3XfOQdQHtbk3Zmqxs/5G1pPHNLiexBQafYpXXHiiVOw+c8HN/jDCubni+n+VIOOpEOyLSSuA3Rt4RB0kKliqUB4CCv0pSN1h6pG5ibD1KkmV6l/ATIEQsWulPv66jeoGbRRB3ZU+cPqNrxX9+mRGBWCKt6D2gxc3w0XKF7xQB4kxdIqFGJo1rlvWHHXjaH1t3TVY0KXUUJKpKjMZNEw3UTITU9MWYI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68D81D19146CC04D97069BBF479708AF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d983023a-185a-4aa2-f3eb-08d6f99190e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:21:31.9566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2817
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=613 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250130
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 09:56:31AM -0700, Jakub Kicinski wrote:
> cgroup code tries to use argv[0] as the cgroup path,
> but if it fails uses argv[1] to report errors.
>=20
> Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks, Jakub!

> ---
>  tools/bpf/bpftool/cgroup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
> index 73ec8ea33fb4..a13fb7265d1a 100644
> --- a/tools/bpf/bpftool/cgroup.c
> +++ b/tools/bpf/bpftool/cgroup.c
> @@ -168,7 +168,7 @@ static int do_show(int argc, char **argv)
> =20
>  	cgroup_fd =3D open(argv[0], O_RDONLY);
>  	if (cgroup_fd < 0) {
> -		p_err("can't open cgroup %s", argv[1]);
> +		p_err("can't open cgroup %s", argv[0]);
>  		goto exit;
>  	}
> =20
> @@ -356,7 +356,7 @@ static int do_attach(int argc, char **argv)
> =20
>  	cgroup_fd =3D open(argv[0], O_RDONLY);
>  	if (cgroup_fd < 0) {
> -		p_err("can't open cgroup %s", argv[1]);
> +		p_err("can't open cgroup %s", argv[0]);
>  		goto exit;
>  	}
> =20
> @@ -414,7 +414,7 @@ static int do_detach(int argc, char **argv)
> =20
>  	cgroup_fd =3D open(argv[0], O_RDONLY);
>  	if (cgroup_fd < 0) {
> -		p_err("can't open cgroup %s", argv[1]);
> +		p_err("can't open cgroup %s", argv[0]);
>  		goto exit;
>  	}
> =20
> --=20
> 2.21.0
>=20
