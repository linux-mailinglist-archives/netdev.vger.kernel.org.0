Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A260366F6A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244096AbhDUPsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:48:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45616 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243667AbhDUPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:48:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LFePJO176671;
        Wed, 21 Apr 2021 15:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GM2g1QJjJ9vKwEienjcbeAtqSd/T1o7rPbxCRzSPXJc=;
 b=elVZcvV6IdtP23AlogaDQxV/A/nd/YLiJpEg5isqXGt8+B5XXdeVRY0Kdw/tJFAuySck
 vwQXXBQ7qCl2wZcH0Gw9ps+jS2W1YPbcarVnCoYwyKDma4iAlfFEjfGYHDSn5bp+42bY
 LAn+P+7Fhl270vmuZb61tDsaTgn5fXP9hwqk37C72O/jSbfiBANASOs+eHIv+Ii/mq4r
 szhThpvamZzqodEcMjPKeCeDf50C78U7cx7lU3v91GCYdHDWiQ0vObIJvlbCzmtw8gWy
 2623t8f+Cubqi4aMANdGwl0DZNSG8YoW3ImO9mQih83eS6/fOWuzd63ycg++k0j9QlcN 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37yn6catkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 15:47:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LFexHM150103;
        Wed, 21 Apr 2021 15:47:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3030.oracle.com with ESMTP id 38098rwrgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 15:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezVLnPfB12c96E0YzQnh1GP0Yrcot+Nx1MCVJHtJiNOI+ZOIBR6ElXQFMmomODqlpu9mLt/KHnNMaxDsZ4iffQpWcr8vgy62V/tV+n6TIY+I4V8qZazB0PR7IAZemHGuc0do4LKsTWyJCM7LJmI8z42SA8U5J3j7dPWX/L00oLS9ABw6Vzd4R9gkensvshaK0leW/kaJGQE2xsI1dxj0Bmk84c3unxI2scOuux+R3Fn/PkitWf98Xfx7g7B5ql3M7/B7QTn8/Y/2HMJFz/Za4QgPEJ7vNnYL4XOxPzNBlUPxz4EaoD8z2vUsyLBRMP4ay8GA+91FpSUYUbG1aKM+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM2g1QJjJ9vKwEienjcbeAtqSd/T1o7rPbxCRzSPXJc=;
 b=Vio/iKlvYjX7ctSRYNYjopcY6Qivos9F7ETGCJOckqIEzHTlzHawyk12hRdMmubE0qNowhCTYIGh1GkXFplKsm0yInZNTYK8VS04y+naFfJ7hXTR6uv9vFnF2vwTSUVWJ03bE018Ug132wKDll7qO48M1bye6q6OS275TGnms0AnfH7E3NBmLxusOLqFuHSEoAzFf+TXhk3kxhuEWN7NkQTqHqsVS8rNNF0H35l33sgZVedrdn1mQ+n1H/M0IvFJLOc6xCkRuTj/zMUGBV0ib56LEBA6JqxrkkEn2d4H0Tyuwnaen/xDL34Za4KQQxmYzpTdaIEcSDD/XVIG3rqMyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM2g1QJjJ9vKwEienjcbeAtqSd/T1o7rPbxCRzSPXJc=;
 b=xGKuYqzdyI0nF1Zvg4c/idKlbgdom6pzVZ2dPAJDsAbFtOvgEj7fw4NiY35K5h8q1YK2eIS0rGGQnOnPMctZ8f6QESRTelNWdeJJ7ByyTOhRy4AzeRrHc7pLLFEeDjXMSOip8tDiDy/6KNvWqzLEiHYFcfrFwkCRvPkGY7RCRKI=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR1001MB2080.namprd10.prod.outlook.com (2603:10b6:301:35::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.22; Wed, 21 Apr
 2021 15:47:21 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 15:47:21 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     kernel test robot <lkp@intel.com>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Grall <julien.grall@arm.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Thread-Topic: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Thread-Index: AQHXNgU7pAWIynV4NUyh79ZCugEeMKq96l4AgAE0zAA=
Date:   Wed, 21 Apr 2021 15:47:21 +0000
Message-ID: <20210421154716.z65ergzd3pylpbvl@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <202104210515.VoF3YT1J-lkp@intel.com>
In-Reply-To: <202104210515.VoF3YT1J-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76329b60-167e-4774-96ac-08d904dcc07d
x-ms-traffictypediagnostic: MWHPR1001MB2080:
x-microsoft-antispam-prvs: <MWHPR1001MB208094148FAB2A3DA9F4D4F1FD479@MWHPR1001MB2080.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j6oXXPalR5Z0y5yG3Xu4UmtDaYUJ7vXX5ZQ0b3oYMg9Rr+WaMEUSOtyQCu/yl4MtDB3Ou06uHhelK0fkzy/0h2csJcC8Tn6Isfl8MTBs8h7uhNAKXX3Skn/pMusdVLvTnnv5H24EBpN3IL/EtqaNNXW9zmRmRtQ1+kQhfDA7Tcn6lPRT4MFt1+OoJlCP3QEJ0pEU0FFfQHrW8xDMf6Eb0keFD8Dsdl9U8yd00TK9rt1/nA0Jnw1c48n6/0W+4QkDbKjfcgRzjxRWHLLpQx0qbI4td6jepguDblg6zndNdsr+nctC0ANllePD3wwAoRfFofXlzFoiW6NeWn6YGG8BgRkEl3u4+vfD2iApYCMYAA2MB0XHjyRbF3tD9dPHE78Fhkwdujo0u+AWIadatW2SbOFZfKsJ2y9fHABjT7ISOjcV3wnk0FJeTBQ65CjSTbQxbK000cf8wLn6WbYYW8z59BopkKBUapHsumDrCDPTHOhT2JekwZ1C8TPDQl8knb4uEQByzoS5pg9amXmp5eeB5mDvd+YZb0bhgK0yeC9KeDOwSqmrEm4gMxrUZcOYHQgUPv9UAmiVF2PejlAaeEVILDX/uGNSWUNo7Dtt2Rq6WvhCK8izwLbfdNSlbyTDPLTWvgNaMqIg18Ay+dBAsBqbz2D8Yo/ScrIWYwjy5TFDxmU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(136003)(396003)(39860400002)(376002)(366004)(346002)(6916009)(8936002)(54906003)(9686003)(6512007)(316002)(7416002)(5660300002)(33716001)(122000001)(86362001)(38100700002)(4326008)(6486002)(966005)(26005)(83380400001)(44832011)(186003)(6506007)(66556008)(66946007)(478600001)(8676002)(1076003)(66476007)(76116006)(2906002)(64756008)(66446008)(71200400001)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IK1dJ64n17qO5T8K/bZVx2U9DOXl8h+TwqZUCyYvufxryq1l0lWJcFXXGru5?=
 =?us-ascii?Q?xQyOUcCyJkXKXFCGCftsnCIogd9M29nwusDN3ebeU5rLy549/O1wT7MNzk6/?=
 =?us-ascii?Q?DosXpIVgVEfqC6fewkkHIa3buqjKwf0ntqAsZO8Zpxz+eC4eF1wadjHA7gG5?=
 =?us-ascii?Q?n00KNhT878MVVkCEm2Ce3TJVBooVIuEgzTXMV+AYbagvMudh6c6x0Z7I2NKy?=
 =?us-ascii?Q?C6xlMscNqR00X7bLZ7KIaDWMLDXaI0CqWTSfZkoZXeWDjSP+wNMyy2BCqOUS?=
 =?us-ascii?Q?NAEcKNcpPwzbcZfw8XByoCaS/koMOi7vGRCUIGPuF5K802l04SX/A6emmlTp?=
 =?us-ascii?Q?0/AAWaFq8Vloae/HV9nTYVvIc1vQszklUvcVSEfs2wn9IBN/eccXnDJsPQ5a?=
 =?us-ascii?Q?m0ophGBi6QJ+orTNjTuU78rf+5UCOAfuu1Gpa5S84D7QX9JmRw3k4wqHEPni?=
 =?us-ascii?Q?7F1JUh3OTVK3gTUiNFi0nprfgU8UQUUumB6eJxE2GfH/l2fAtcXxyoSLCbml?=
 =?us-ascii?Q?H4LI/zBdxDjRalR6aVKyYUurkbJL7oUk6t/v0oPGs4NmVn+OxK4mxB571v7S?=
 =?us-ascii?Q?97GvF/orfoO5W0pPoOdjhCTJ7mgGtPHt44eeGDS/DByfu9U62LHNlC0UFGyp?=
 =?us-ascii?Q?62+EZW+T3M0JS/SK0pwZSgjTCPoZbp9tZ81TLeEceFCRKtog/To+WJPcUbHL?=
 =?us-ascii?Q?luAXpdK+uIBQ1v1fMGFez69NsK4U4g5oiRs0m5VLA/lQ8bjWJfOSLOmpXuZ0?=
 =?us-ascii?Q?joqHRp36c7oMGstHM0aAKa8kjdk2Nz3Vc1kcXhiYCsjm8m7EV6ox9Eu2i2tH?=
 =?us-ascii?Q?gk+wqkyKl9zbOzsDXVZ0vK/2x9+lUVknXKZ+JJg2DN6yB3du65IlF1Lax1my?=
 =?us-ascii?Q?go/tleAZ4XIxMGgQByo4eSdjCiJpfcQ6ZVxbaJFz29Zat5339DLKArtebySv?=
 =?us-ascii?Q?DWK827OAaaIHqjGIqZ9k0l/rfGHrfEiRDm3HIV3texeHtJC4XZhM0wK+USpF?=
 =?us-ascii?Q?Tq+JdNLmCKfMwekZ5I/pAsKcNi+KHOqTvwHlSfYRuyb4onteHxY08SGy6N10?=
 =?us-ascii?Q?poKhiZKtz6jiJsXfiKzd+6dhAOL2WzrstwovgoafCPeQoxodAxaZMatKtmOL?=
 =?us-ascii?Q?0w5YumXpK6FaGtAXR2B/dEFDHvcQTnfpLJNz7jTcns0eJQP1lBK357FgSeA2?=
 =?us-ascii?Q?F1EIL/sdfbRzchzuOI83jsM9sQ6Xdms9c9wGDl6TxaWT3N+n2DaOVDXqJf3A?=
 =?us-ascii?Q?9Zm+S92DjMmAsPVGDqmt284z/6VirwmV4e0xP9izsBPhCeptjID+6v/766KP?=
 =?us-ascii?Q?E1bAdhKP8LJMWLmp0TVKCERB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9C66899E7684C40AC75B5F81EE1C5E5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76329b60-167e-4774-96ac-08d904dcc07d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 15:47:21.5439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZ6835TXsO/hOS0XZeJ/GJgqC8zzBFbhUEgaO8j+7na2/nggjutocbYunntSvgCg8qIbrOgZeWyxT8T/hbVL2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2080
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=942 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210117
X-Proofpoint-GUID: K7KbAM0BpHRYpSVYUEyHUdEcboO9y9AX
X-Proofpoint-ORIG-GUID: K7KbAM0BpHRYpSVYUEyHUdEcboO9y9AX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* kernel test robot <lkp@intel.com> [210420 17:22]:
> Hi Liam,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on arm64/for-next/core]
> [also build test WARNING on arm-perf/for-next/perf xlnx/master arm/for-ne=
xt soc/for-next kvmarm/next linus/master v5.12-rc8 next-20210420]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>=20
> url:    https://github.com/0day-ci/linux/commits/Liam-Howlett/arm64-armv8=
_deprecated-Fix-swp_handler-signal-generation/20210421-005252
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git f=
or-next/core
> config: arm64-allyesconfig (attached as .config)
> compiler: aarch64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/96a011695861072d32851ba=
3a104b19106955869
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Liam-Howlett/arm64-armv8_depreca=
ted-Fix-swp_handler-signal-generation/20210421-005252
>         git checkout 96a011695861072d32851ba3a104b19106955869
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-9.3.0 make.cros=
s W=3D1 ARCH=3Darm64=20
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
>    arch/arm64/kernel/armv8_deprecated.c: In function 'swp_handler':
> >> arch/arm64/kernel/armv8_deprecated.c:418:11: warning: suggest parenthe=
ses around assignment used as truth value [-Wparentheses]
>      418 |  else if (res =3D -ENXIO) /* Unaligned pointer */
>          |           ^~~
>=20

Ah, I hadn't had the correct config enabled for this code to be
compiled.  I will wait for any other comments then I'll send out a v2
with this fix.

Thanks,
Liam
