Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB282DAF80
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgLOOsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:48:19 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:25274 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729912AbgLOOsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:48:00 -0500
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFEblXu002240;
        Tue, 15 Dec 2020 09:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=R+Rwk1iYimBIAGEMQecUuOrMvhJKa3UAOC+nUGQv9YA=;
 b=iigdU1MUF6RnyoYGmsy33TPPKz1+PQdEcXaywlms+gC/M9n06kd5baV7n6fV/SMg4uv8
 gxorIY5DvHQOkgdso7PpBpLBtNFRST2ARYWJNHsW7Uw8ikJWCl31mPyZ6UQsC6ubdk5H
 HPZ2IqjHyfulT1s8iXXk6bsFs7gIn0egJDG8QifUfTtKVZyenIfdavp1IUTUfCDlJUuY
 BaZXHQvn5KcSUOPH8mUueo0hPZusRKUG05fFFMg9Hgmh0ejSBxUp+mP6ISp9XUJhU3ks
 sZDeJsxi4e0S7M4MTZBxlIj6BrYsH4kYb4XU8AjOywA6NlWnfBn2csxpBIWFh/aEniqV kA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 35esansdgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 09:47:10 -0500
Received: from pps.filterd (m0134318.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFEe8uu038478;
        Tue, 15 Dec 2020 09:47:09 -0500
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-00154901.pphosted.com with ESMTP id 35exd6h2bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 09:47:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsRpZa3pdew6qDevCxB/T7xCrCSdpROWCb6Dz/UY4Uc4YlVfNuG6bAeHHlkKYKMh69e2v8FQsjat+8yOkAJ0QRyUN0/SEcH6nkIsWsT+ZQkKu4Zqu4e5nPuevdzD+HtbZDqebVAqUD12h2FyDcnOTGvH5/fz/uHVXaOvG9ABQjdXhTrwl2P5eZgbnAeYADvTlaKre0V3IicgDKGcSBpUuVZ3jYZaGXhJoewo33vEqXk9JafnOtJxv7lgbLw6dzAE5OcoMx/0R2DgC6NDOD2sQ3k58ur1g3ijN3w5X+rN8PoK2lrS6JrS30F82b/ClPisldM+eV30/L5dMNxhlyZw1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+Rwk1iYimBIAGEMQecUuOrMvhJKa3UAOC+nUGQv9YA=;
 b=gL2vr6v8EvsdLtKHKRCxKVqlhXlA+wdgWzc3ZZbxKckOWkYfQPgH4iFqqfc0VXyGOGPf+jpqFK53nHqwUDVg127oQqmCjQqtatngzUEmQUi50koFSnXzWLbqodCgXaTnGpxV77mFqyiz1byjlDbpyokqLwdNZ0ced6pxVS7WoIsuMqKDE8fJLCqDDwOOnn+TI+5k2PnLZkODIgtizy+EQUB+okYVJCGtBJDZnU/+QvDN/NSGb10NeSgE186i0+i6OOG6670+3DqwaSVi9KxI5PAR34UrkE3L3H3H1i1fpSRaHHpJgpxhwcxtg4ste+8JbUWtpTFYuZ0oJ6bbRypsWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+Rwk1iYimBIAGEMQecUuOrMvhJKa3UAOC+nUGQv9YA=;
 b=Dvlp/pFIWQPG9rerCptSIb9VecLAGSEt0r0aPYE03VXbruvcdjUH9CZd3PUbI3Q1WsLjJlCeO0fLR7+grwB5euFtuhIvt9ryI2y7kfcoUTFJKCgB+A4LgcdZgGlvSpY66ybX8olPg90b8oFLODdhrwa03119DplfmjpiYp0F47Q=
Received: from SJ0PR19MB4463.namprd19.prod.outlook.com (2603:10b6:a03:282::9)
 by BY5PR19MB3953.namprd19.prod.outlook.com (2603:10b6:a03:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 14:47:07 +0000
Received: from SJ0PR19MB4463.namprd19.prod.outlook.com
 ([fe80::6d3e:acc:b93c:11ef]) by SJ0PR19MB4463.namprd19.prod.outlook.com
 ([fe80::6d3e:acc:b93c:11ef%9]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 14:47:07 +0000
From:   "Shen, Yijun" <Yijun.Shen@dell.com>
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Aaron Ma <aaron.ma@canonical.com>,
        Mark Pearson <markpearson@lenovo.com>
Subject: RE: [PATCH v5 2/4] e1000e: bump up timeout to wait when ME
 un-configures ULP mode
Thread-Topic: [PATCH v5 2/4] e1000e: bump up timeout to wait when ME
 un-configures ULP mode
Thread-Index: AQHW0k+BeNPICSb5VU2QGfFhaQjRPKn4PPyA
Date:   Tue, 15 Dec 2020 14:47:07 +0000
Message-ID: <SJ0PR19MB4463FFE194AC6662975C23909AC60@SJ0PR19MB4463.namprd19.prod.outlook.com>
References: <20201214192935.895174-1-mario.limonciello@dell.com>
 <20201214192935.895174-3-mario.limonciello@dell.com>
In-Reply-To: <20201214192935.895174-3-mario.limonciello@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: Dell.com; dkim=none (message not signed)
 header.d=none;Dell.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [101.86.22.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5be1cb2-b077-4c5c-3a28-08d8a1084be8
x-ms-traffictypediagnostic: BY5PR19MB3953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR19MB3953C8E7ED1341C0074E72859AC60@BY5PR19MB3953.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ucRBrYOYWLW6KB7y5LcPWs30oIAO8lMO6O+afmrlmLNAGpneHAcIkPWdyY/pcwZetpTAFFqImaGkbakBJmXKbhamtXMbI14xCFJ8TPAujmgIp6TksTusPHD4OkTnT+PXt8NggmELk2UEqTb7tt0qz0C4JHPA02Ihew8uzk04paUQd4ZKL+pSAo8O9RD+qcrOuoW0kNoSlUlBcdhWeXxGTrY2uWm0W8+GrodX5yYQICFcyDwKEyNHKyd/Pw4RZ+Ua7yG+o0kg2QBw/RvPZWLfV3Vba371AvIRoLlx1tpMVM3OzcQc2TRCCMf9GJrC6X9IF3vu+y4kp2bLjNGQOtpR1MjkvySRB51gZBZHHV2u3u7lSWnXdUQsjT67AP56gCJa8UHdrvWv5y0W7hF79sIWqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB4463.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(66556008)(186003)(86362001)(66446008)(966005)(83380400001)(64756008)(66946007)(66476007)(53546011)(71200400001)(2906002)(7696005)(5660300002)(508600001)(33656002)(6506007)(786003)(8936002)(8676002)(7416002)(54906003)(52536014)(110136005)(55016002)(9686003)(76116006)(4326008)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6wVJwM1oVCEhstUwD25s9Sp5T6GMsXkDf7CWlCztJz+qgt1ymrx5MzkW3XfL?=
 =?us-ascii?Q?SED0Xx/iX9KLGAL8/vQAKKoKaXT/57V2D2P5Qmngd21umqQ4DWyVPqsXBjzM?=
 =?us-ascii?Q?kRUpUioe9kVxn1O80HivTU1R1tjnx7Tf4QJ8CRCLxC5TGNE0s4VzYwbPR1mP?=
 =?us-ascii?Q?GEaAc/ipGFPr4VtP2eEBgG87U1pRsfNC+DDNot9a8SP33GBdGuEWyIuNpdn5?=
 =?us-ascii?Q?w2x+XaWYUO01pdDQRoRDETTp7c9aSycENv6qU0oxQIKo1hHuz29/h0AQXJjK?=
 =?us-ascii?Q?cVCnRPSoSQGBzMQC7+b0EUdfB4/Sxi33qM5duVfQdRN9lJNCbvllqGSEd0xu?=
 =?us-ascii?Q?RxihlJ/2yFvhybXWNYybvHFhKyFiaceO00NW7Jp2srrR58bDpjO7FunGLBbc?=
 =?us-ascii?Q?+f+VQ7kwb4NDoYmQCC076UXmaKoDDdHJF8Hl8q9DEKgkur1eO9s6P4V7OjIs?=
 =?us-ascii?Q?earZ/+uICBHU216fIJTC7H+oa60crSJ1lDvulju+xjRNqfhYVMaA40LqCQ1v?=
 =?us-ascii?Q?yh2FYQtvecG1RknvnxTaKC7TjfCx6gXfrGDtAxaHGgqfcTKMqrSh+7+kIc1k?=
 =?us-ascii?Q?Iil2lAVVfj7XKcq6O+INx6CC29CpZXKKgFFwql6Id5yFi8w2bq1jP6dqNkiK?=
 =?us-ascii?Q?kOL1ETO5CMrs5+ZWTQ4uxXPQLK89Ew4pjZuZhcS3zK4R9a7TK9Qb44m4LIEB?=
 =?us-ascii?Q?4XsE7pNRYnuJOsyS0eQkZ/zRX7u9sjJjsdJghCA9lTjtQ9ZVYGN74FMiSC7u?=
 =?us-ascii?Q?y8UCvZLn01PY9VQavn76NF3wDaOrv6WF2hbb+Y6o/CKNBktmTbe3LTxs6/yS?=
 =?us-ascii?Q?QSjtkbIItm+1IagOeeQ9wF2Hvjr07NvVf1IFjQ3NLqlQTZ1EzNsUjS41cov0?=
 =?us-ascii?Q?uI4Zrq1s43HJErvqNvP9zJOup40cQsjCR2ngMSvNoyzcXlo2WcdhuvganSvb?=
 =?us-ascii?Q?lYP42zx5JGpzGddhC/GJAfjMHyoSoAMIMG+CAhiS3gc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB4463.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5be1cb2-b077-4c5c-3a28-08d8a1084be8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 14:47:07.6642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oPLbokCbYNs1lCCLpvHBjNwAReVV0BihzKHSBDfyyo9ZpY3T+mW8NF7Vx9jXv9EHZVQz2I+b8QlCwn9CYT27CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3953
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0
 spamscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150105
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Limonciello, Mario <Mario_Limonciello@Dell.com>
> Sent: Tuesday, December 15, 2020 3:30 AM
> To: Jeff Kirsher; Tony Nguyen; intel-wired-lan@lists.osuosl.org
> Cc: linux-kernel@vger.kernel.org; Netdev; Alexander Duyck; Jakub Kicinski=
;
> Sasha Netfin; Aaron Brown; Stefan Assmann; David Miller;
> darcari@redhat.com; Shen, Yijun; Yuan, Perry;
> anthony.wong@canonical.com; Hans de Goede; Limonciello, Mario; Aaron
> Ma; Mark Pearson
> Subject: [PATCH v5 2/4] e1000e: bump up timeout to wait when ME un-
> configures ULP mode
>=20
> Per guidance from Intel ethernet architecture team, it may take up to 1
> second for unconfiguring ULP mode.
>=20
> However in practice this seems to be taking up to 2 seconds on some Lenov=
o
> machines.  Detect scenarios that take more than 1 second but less than 2.=
5
> seconds and emit a warning on resume for those scenarios.
>=20
> Suggested-by: Aaron Ma <aaron.ma@canonical.com>
> Suggested-by: Sasha Netfin <sasha.neftin@intel.com>
> Suggested-by: Hans de Goede <hdegoede@redhat.com>
> CC: Mark Pearson <markpearson@lenovo.com>
> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
> BugLink: https://bugs.launchpad.net/bugs/1865570
> Link: https://patchwork.ozlabs.org/project/intel-wired-
> lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
> Link: https://lkml.org/lkml/2020/12/13/15
> Link: https://lkml.org/lkml/2020/12/14/708
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>

Verified this series patches with Dell Systems.

Tested-By: Yijun Shen <Yijun.shen@dell.com>

> ---
>  drivers/net/ethernet/intel/e1000e/ich8lan.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index 9aa6fad8ed47..fdf23d20c954 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -1240,6 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct
> e1000_hw *hw, bool force)
>  		return 0;
>=20
>  	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
> +		struct e1000_adapter *adapter =3D hw->adapter;
> +		bool firmware_bug =3D false;
> +
>  		if (force) {
>  			/* Request ME un-configure ULP mode in the PHY */
>  			mac_reg =3D er32(H2ME);
> @@ -1248,16 +1251,23 @@ static s32 e1000_disable_ulp_lpt_lp(struct
> e1000_hw *hw, bool force)
>  			ew32(H2ME, mac_reg);
>  		}
>=20
> -		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
> +		/* Poll up to 2.5 seconds for ME to clear ULP_CFG_DONE.
> +		 * If this takes more than 1 second, show a warning indicating
> a firmware
> +		 * bug */
>  		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
> -			if (i++ =3D=3D 30) {
> +			if (i++ =3D=3D 250) {
>  				ret_val =3D -E1000_ERR_PHY;
>  				goto out;
>  			}
> +			if (i > 100 && !firmware_bug)
> +				firmware_bug =3D true;
>=20
>  			usleep_range(10000, 11000);
>  		}
> -		e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
> +		if (firmware_bug)
> +			e_warn("ULP_CONFIG_DONE took %dmsec.  This is a
> firmware bug\n", i * 10);
> +		else
> +			e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n",
> i * 10);
>=20
>  		if (force) {
>  			mac_reg =3D er32(H2ME);
> --
> 2.25.1

