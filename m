Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043FFA7D83
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 10:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbfIDITW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 04:19:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41396 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbfIDITW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 04:19:22 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x848IN6X009483;
        Wed, 4 Sep 2019 01:18:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FNCwE5iUMncr/x7dY6z4xsaAjQfm41lVxBR6p+Olo7A=;
 b=AcJllW6oZJnXqgvVNgpaf284Zk4LjK7ptRXFGUCJX1cjU+4JxNjAq4Pe70t4S1ebmaKM
 EPUEQRUMLWM27RLOxDtqInSf1PYVeZNFr9AeZffXEJkpEVsEH7neETcfQQdSavwEs5me
 FA6sANoBcJe6XUFEsL/6yDq7IOJaLI7ePJ8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2usus0u86a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 01:18:46 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 4 Sep 2019 01:18:44 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 4 Sep 2019 01:18:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfTLDludVfq8FY2Ipq32FYUNV7vyrJImrtke3rfdbc5gzQrV89Qn0qLygpAvJ5CUPxVaQh4CTdenkT8EaSlu9HNXX60iaHS3wXtO8UplzFrhJYrB+RPUVXzIBvRQyOM3WtZjiqOTgDwNoGet5KaWpWK9WOoavBqPO9Zt32mHK6weA8hEAcvOv1WOAY7G2h1Gf6fbl4RQxmgnXqdQjS9suyPlzFosjxfHHms7iLw8MTgrhAj/a3NqIY3ObUiYiUJFW0Duze965cdBt+a49d8V6c6JtXZjiN7WICbe/xMMH6Pk798Y/ac095QgbuC7DDBaqExY4XBRGZKFPwm9b8P+KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNCwE5iUMncr/x7dY6z4xsaAjQfm41lVxBR6p+Olo7A=;
 b=HthcKbYc3pr0RwVc7B1+eyBsTn6YBFzYzxLJPn/Tk2VmBsIiRhX5d3p5AeA2K8QkeHSDLHcaQrSHX2yt1Ka7cGEnz98+ReiPGbq/mOx8/xdORT6HNrOnT5ZEo45psLvUGc9rDdUmIlC2tYvdxooJ598iQpae+lE7Q75LZ319JXRS2UJKVXkyPse/VoleYmmjpDP+22Z2sa3ltPSVPuNtnUqUuFW5tJgCG0MB3+7woT9weRm8WyZxwQXjOEVBUSB/rzV+ESY9qQ/CDx1s2dGnKMaPfqKJmCn7pvVgri2htVpaB4vJnk6XKvIiK8Zo/UxSXZg7J+sKMbeSmEUz6uLl1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNCwE5iUMncr/x7dY6z4xsaAjQfm41lVxBR6p+Olo7A=;
 b=b436RlCCYQurYBn+3U8EBieCcstIgvrw/U7Cn7Vj7jIN41YHei53Hptxz7IW0CBD5OjauXu5PF/quDchDIZ/wg3AUMSJXkK5Bm3IgMwrf27oDH3StjfmijraMkfjo/8pco4zVChuQpJCGdwCJA7OB2NR+Vnajv2/uC6UHFjnYNA=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1368.namprd15.prod.outlook.com (10.172.159.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 4 Sep 2019 08:18:44 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::c0da:c2ae:493b:11f2]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::c0da:c2ae:493b:11f2%11]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 08:18:44 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVYuYWdNZz14+q7UyDUNB5QgVi7qcbLNaA
Date:   Wed, 4 Sep 2019 08:18:43 +0000
Message-ID: <9efed407-7fb7-f7fe-58e3-df90397e623e@fb.com>
References: <20190904160021.72d104f1@canb.auug.org.au>
In-Reply-To: <20190904160021.72d104f1@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:a03:60::14) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c095:180::1:addb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c393e31-c783-48a0-c8ff-08d731108057
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1368;
x-ms-traffictypediagnostic: CY4PR15MB1368:
x-microsoft-antispam-prvs: <CY4PR15MB13688DAB8131E96E5563040CC6B80@CY4PR15MB1368.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(136003)(376002)(396003)(189003)(199004)(53754006)(386003)(6246003)(25786009)(11346002)(486006)(46003)(99286004)(2616005)(71190400001)(86362001)(446003)(53546011)(71200400001)(476003)(31696002)(6116002)(8936002)(53936002)(7736002)(305945005)(6506007)(6512007)(4326008)(81156014)(6436002)(81166006)(5660300002)(8676002)(6486002)(36756003)(478600001)(316002)(31686004)(229853002)(66446008)(64756008)(66556008)(66476007)(66946007)(102836004)(52116002)(256004)(76176011)(58126008)(110136005)(65956001)(65806001)(2906002)(14444005)(54906003)(14454004)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1368;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GL1UaZ5Dh+yoRB1cARscZ3K36LwbRx8Tu+h1KEG+EgzSn4ygaQpGKUzFUUoaH80/kwwaBwFDF+yaUpOdPEwf7bRsww6SjiQzB1UXvy8jYY5Qya2eSIDp+zB5/msCLTTWaXTdBBO3Ox5tt6bVuU8bQcqA7K75Yx+fWffmQj7cuxXKnSYbYsa9DM1z5PVy1yewpa4VfNZWE0m5PfJrEYmZWtfK45gzh+cijkyMznvCNTF7q8lut7iFrDMMHV8m4Ux4kMQn109fL0+d7MiNqtSkAJc+tfJT74eDQyFcG/Sb6m+5be/iQYViKvnUMNx7EmHxL36rNqdeNsU3WlceDpS70JmT2lxLMYA0utd56W/z8sxPfID93QjMSKD0GmY7OqjpeS/xS+3sV2m/H7F7LolYpaheDoqaZPuctPx9IIDgh7A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <FA7B040BB77D874BA79B9E7E6578859F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c393e31-c783-48a0-c8ff-08d731108057
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 08:18:43.9848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nyHtUZJZD84DKqUynCYp91XfdT5ndn+clWdnrLmhjvR0dingdovBqEaH3J9FIwOc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_02:2019-09-03,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909040085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/19 11:00 PM, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> scripts/link-vmlinux.sh: 74: Bad substitution
>=20
> Caused by commit
>=20
>    341dfcf8d78e ("btf: expose BTF info through sysfs")
>=20
> interacting with commit
>=20
>    1267f9d3047d ("kbuild: add $(BASH) to run scripts with bash-extension"=
)
>=20
> from the kbuild tree.
>=20
> The change in the net-next tree turned link-vmlinux.sh into a bash script
> (I think).

Hi Stephen,

Sorry about this breakage. Indeed, ${@:2} is BASH-specific extension,=20
unfortunately. I'm verifying a simple fix with shift and $@, I'll post=20
and CC you as soon as I've verified everything.

With that your temporary fix shouldn't be necessary.

>=20
> I have applied the following patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 4 Sep 2019 15:43:41 +1000
> Subject: [PATCH] link-vmlinux.sh is now a bash script
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>   Makefile                | 4 ++--
>   scripts/link-vmlinux.sh | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index ac97fb282d99..523d12c5cebe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1087,7 +1087,7 @@ ARCH_POSTLINK :=3D $(wildcard $(srctree)/arch/$(SRC=
ARCH)/Makefile.postlink)
>  =20
>   # Final link of vmlinux with optional arch pass after final link
>   cmd_link-vmlinux =3D                                                 \
> -	$(CONFIG_SHELL) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
> +	$(BASH) $< $(LD) $(KBUILD_LDFLAGS) $(LDFLAGS_vmlinux) ;    \
>   	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
>  =20
>   vmlinux: scripts/link-vmlinux.sh autoksyms_recursive $(vmlinux-deps) FO=
RCE
> @@ -1403,7 +1403,7 @@ clean: rm-files :=3D $(CLEAN_FILES)
>   PHONY +=3D archclean vmlinuxclean
>  =20
>   vmlinuxclean:
> -	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> +	$(Q)$(BASH) $(srctree)/scripts/link-vmlinux.sh clean
>   	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
>  =20
>   clean: archclean vmlinuxclean
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index f7edb75f9806..ea1f8673869d 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>   # SPDX-License-Identifier: GPL-2.0
>   #
>   # link vmlinux
>=20

