Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09476475458
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 09:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhLOIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 03:36:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:15105 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240829AbhLOIga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 03:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639557390; x=1671093390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UvOUVDxF01Gak+DG7mnueiIGDljormIuv8ztm2CKmkE=;
  b=iyggeuY37hLivqfjEH6HCVwu+wPs009HEansiTWqGS+AGVczNwLQhPSw
   VJASn6zEGLpQY0VASpv9AjQmwIBzpSj1NIWi+LESdcBMqBKdLrnIexMEe
   qiKOunpHh5KhWIb+WjTCSTv28xr8qWdszsKvDxAgccjNUHbkRDPgCgeB2
   QRFwy4uMaju1d5tLYhAUh2Jgt3axzEOLe6E09nUza2Nz4IQD+dh82XuQL
   Lz3B5Yq0CHrdaIF7Zu7+m+tKKSkU68V1SpW2sOtSi00cpKM7ArHu6Xgca
   aJ7Jqy+A38LsRE0bi2SjDOB+h1s3XGxm3J3WeToRHFnKVCDaMIXuOyPKX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="325459357"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="325459357"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 00:36:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="755297151"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 15 Dec 2021 00:36:25 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 00:36:25 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 00:36:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 00:36:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOwqTDbm5Ut69xmBdepoSOMhQ9PUsiCXolwSlFMcSSU4Ul2JVT2CFBayqsAAz1M83iHp35eiPJ/4WGrvt6DrJRVvKmbLF5vDyG9IRu+7gnc/QY8MxvguOOvTVPspB2mqCsgvMJPTCVMwUz8JhCWSsvoUjycmbYMG1JJ9F6SfMJzzGZ5hUgr8z5YfsaCERZ7Hwf1rewfvhiWiS/Vw+eOfG73HJ03KaAYE9GbKcZsJwSjbKdVSI6ohrISUHfkP2rfUFmkVm8DHtblYT8DhF/FtojBkJfkZvcUwGVzRPNtCasgtnM5gFigECD87jKWrA1+Ww3pHvYKgmpBdv8T03eDs0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snplYRrLCEwmHME1ZJAPxau8IYyrZkcDtvlZrS+qd/0=;
 b=U534zboWsAWPRV06U2zZgWidbpb35VWnP7DVR1ZwMZSZG9UR86syYgCMgglh0q/XgUduA2WjTizW+gGB/B3W5hqMQNXlkxs/xuL6m2VIVL1+zNdOL4H3gCzkrOGoYVv4vzx3kpit/fBs9fJRB8soe4ieOiwKgyWOTiSccR8x7GazsDb3fARO9LySaQltQI6QoBa9u9qwjr9hdodq6uz7W64eEGiV/ucHxHiXpApKZ9UwQ6BgREAAEW0Jmk2my3We8YvjRQ4ChaFTEYHe1lth/NzkmLSh/VYxpI5Ykru6AlfORyrEArW0pLpNIkfOzVQ9mGk+ELOpS2fJILmg8pAoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR1101MB2143.namprd11.prod.outlook.com (2603:10b6:301:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 08:36:24 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%8]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 08:36:24 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Topic: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Index: AdfwtmkvCyrAW5M4S3mERBKDxICdHAAGBHqAADANSQA=
Date:   Wed, 15 Dec 2021 08:36:23 +0000
Message-ID: <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YbhmTcFITSD1dOts@lunn.ch>
In-Reply-To: <YbhmTcFITSD1dOts@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5330d040-96e8-415c-bb67-08d9bfa5fa65
x-ms-traffictypediagnostic: MWHPR1101MB2143:EE_
x-microsoft-antispam-prvs: <MWHPR1101MB21436760D766F48BD55EB50BD5769@MWHPR1101MB2143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xe7v5uMhByPDa5gN15HkOlinoBB0rbD2seibIAtD+xsb+ERkYtiCYJ3AmrsJIUTFyaSt3NQAG97PP3a8vLL9aAzAFz4+jwsue0udefut9S7hPDRHZj15D4GImmXHmypFlJb26aos4odFEVAqyA1ggatLYw/9WtFoeS5wkQAUcG+9YsPK1qaIx62yfSpsKXw3Y9zJcmS8/HI5iD9wFouibCZLDE9y0yoKM3TNQqw8FgYn7BoIQ891lbjla9xHwKYhDt2p1pycael1Ci6y2ce1haq6EyDSxIkPjeAJ9XZX41n2cr2V+nkFNQc8msVazNTibC/rNZhYf+vmA+kK/2sOKp/OJNAqfy6irbg/aeAEys5v64zfPaJsK1/URGYCtrCuPiCJ8WqsXi9nr5NafYoNx9OmErHWqXvnZuwX5sU3gDu/K3YNNQ39jEvzjDQ8XDv7rkpeYdtKxFIvYEk/rTLjoBOsYfDuXFTUDGqM7SiN5A/k/Qu7nNFcftyjqgxKulXyPQnkQU9tnWu3rdLlv8Y/Jfmo4jggbX7eqYPUGAYuZTqYihptLxOJ0qlyTbIjEn+I4EfQ+xYAlcdF0YfPLuOOqEQDdG/RvpLYzoRX8Z2KWXjRWIFv4Pu4yzECUlqv7Da/mpr9MyEWNRYyGFi+vbukVjjX7U78vmre88efEnOygXslQm6nbgeoqSa+ptTAHrNWfmOaBbv5BV2qmzS5b8YBhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(52536014)(508600001)(6916009)(6506007)(53546011)(55016003)(2906002)(64756008)(107886003)(7696005)(86362001)(26005)(66946007)(76116006)(66446008)(5660300002)(66476007)(66556008)(4326008)(9686003)(38100700002)(122000001)(38070700005)(82960400001)(316002)(83380400001)(71200400001)(33656002)(54906003)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DvKbqU5nXMs26WsJyCipYaAcZDD9vHcEvDCUsQhNkk41flzj35q2jxsZ6FZI?=
 =?us-ascii?Q?Il1k+7/9gWZXQdCTiRTsnCtgSzB179UDpN//ngmqqixZckgn9Qh+oay06K9u?=
 =?us-ascii?Q?dPn+6ef6VmWgcwgMmtgpl12lbRnRhGWs1t2OLwyC7uozhOhR+4Adqt93lh6C?=
 =?us-ascii?Q?8ncs8DuplCjWetvr5YuBCBti/rH6IXZMX6z2wX/IXZb8TP1sWkSZNZ87Ggkk?=
 =?us-ascii?Q?wX3wgDL/zrpFZg946vDoBpjrj3UE3wxXz7QCXUnfm50jxT9UOOL3vMJyy9HD?=
 =?us-ascii?Q?PucKROTEjMHel2p2lTlP/hYK+wEwAV8TOsqYgGq9LcRVyepHn/Uzls8q1SJN?=
 =?us-ascii?Q?jJduFLX7IDv6u02g2+IpSePvgAM//MW/ww/IbBvSljBg0rjhYFiZKvlWBREe?=
 =?us-ascii?Q?+tw0GNGl9KkTrKWRu/pPZmJiqSnYWEHweS8RV9FJPgAE8xxXgJuMfJa9VVYm?=
 =?us-ascii?Q?LQXqZySBy3FmxDt8agDicfcfQCpQ/ICVHwfownRZ7PmkbUmKvL7N69UKvRJU?=
 =?us-ascii?Q?BwxYpzHqJd8jYiv3NGXHYRDtUS4Qg/qa/9jSo2p9mJ8zsXljmUY05qE5iCii?=
 =?us-ascii?Q?LYIMVy+wR+NNZWPBq26D0HUibaLVP+HAe04TJTF2qGQJF4qbetkvZA5eZxUo?=
 =?us-ascii?Q?o6u5EI3pSjFEfRCOixahxs9VWs20jLVPQs7pHLXjBI8sJJ/kKc7tYlwB/D5l?=
 =?us-ascii?Q?hKMtlvm0Mk3XLOKQE1lS+Kt1J3GADvBOXORb+j0SWSHVN9DQr05K+jDULuvS?=
 =?us-ascii?Q?s6uBKspr6uIQ2DmjAUs9+VbmccyOZHiFCn9L9kTWcnoUiS44M8KUsnC+1fjw?=
 =?us-ascii?Q?Xki5VHQluTvAAy/g7dZfIwBXv1dc4sXAoCqiwOMoSf7cBa6ZwFGmM/+7aIxz?=
 =?us-ascii?Q?tUwDhp4+y1ni1/7Vgq7eV2E+uaJH0DSS4g/KZmmeke97YE1CcxzvQ7qFKTWK?=
 =?us-ascii?Q?PQb7V3zgtH4SPbkh+COyXUyF54BtBsD8MIeY3BdITR9p8KdEz7rJaeCkrDSm?=
 =?us-ascii?Q?j1bIJubC8SHGbhknsNm43ADFGmH9DTY7KHC1qMDfhIkN67zatA9Md8sNCLzc?=
 =?us-ascii?Q?D0jpP7YW7FN/qMvm5XCgM1JUmJPmBSM1qQ7yv7jxz+b1DfscZJFmwAFTM4H7?=
 =?us-ascii?Q?XApQzsASVfYSCYUOAhRgaLPyT4H9NhUe+sbO58fUSFYs3doh6q88l3sT/Aiy?=
 =?us-ascii?Q?N4GHNXp+Ct47caYzFwUw/7rdEK/Ox7VpQjyBz35nznFKEqAS/WXUujVKkNtM?=
 =?us-ascii?Q?vHhpc3NLYKXueQ33wH17Rz3tLwETmMorNixQO6iRLwGvtYcgxR0PusqqPUTQ?=
 =?us-ascii?Q?V/qaq0xIq+bM+GiVG+ZZev4n61UAHRK9f+AfbmmiSzegpp6kiX/6PNDwdzNE?=
 =?us-ascii?Q?JPDefKnDdgIRZ2yZCusAzHJKrmQdtE6lN6cBXNMDM2AUOtNOEmR4CImsThZQ?=
 =?us-ascii?Q?uCEqaQBr6Pw7DVSEQe+44tA3FcVKsMAp+GKBSFa7UpfQ+i5zIOdjaYnhHXy/?=
 =?us-ascii?Q?vVgcdghAOXETALNztizIdVpQ8wf6+VGl3qrVJSdT+2pg5OrSeWT3O5kpRyC1?=
 =?us-ascii?Q?HCJpwavouu4vcMV2Mmww7D9HlFC1PJPwadZXQTTJUGN+AA/JDBgpqXyH1nyN?=
 =?us-ascii?Q?WMY5147OtTnOSwm6Zy3VVUjiSwJX6PYKOPSEIKVxs843zigWfWHSncWVJRSo?=
 =?us-ascii?Q?ovEexGeL4dPiHFjzON+8QMOw8Z4Z/JnaxXcHTpAWiy7M7r8a?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5330d040-96e8-415c-bb67-08d9bfa5fa65
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 08:36:24.0080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qubVJLKPO5SuiWnQuxjnrxBANeV9STck+x3vjYLptOx+nDrMKj2wc3xMkjmjPBta/TXGXwK4kjsAfxEAjHzXDEAMuc/cHi0znbbqbhK73lq9UqVaWsu1/dzXBIF0TM88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2143
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, December 14, 2021 5:39 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Voon, Weifeng <weifeng.voon@intel.com>;
> Wong, Vee Khee <vee.khee.wong@intel.com>
> Subject: Re: [BUG] net: phy: genphy_loopback: add link speed configuratio=
n
>=20
> On Tue, Dec 14, 2021 at 07:00:37AM +0000, Ismail, Mohammad Athari wrote:
> > Hi Oleksij,
> >
> > "net: phy: genphy_loopback: add link speed configuration" patch causes
> Marvell 88E1510 PHY not able to perform PHY loopback using ethtool
> command (ethtool -t eth0 offline). Below is the error message:
> >
> > "Marvell 88E1510 stmmac-3:01: genphy_loopback failed: -110"
>=20
> -110 is ETIMEDOUT. So that points to the phy_read_poll_timeout().
>=20
> Ah, that points to the fact the Marvell PHYs are odd. You need to perform=
 a
> software reset after changing some registers to actually execute the chan=
ge.
>=20
> As a quick test, please could you try:
>=20
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 74d8e1dc125f..b45f3ffc7c7f 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2625,6 +2625,10 @@ int genphy_loopback(struct phy_device *phydev,
> bool enable)
>=20
>                 phy_modify(phydev, MII_BMCR, ~0, ctl);
>=20
> +               ret =3D genphy_soft_reset(phydev);
> +               if (ret < 0)
> +                       return ret;
> +
>                 ret =3D phy_read_poll_timeout(phydev, MII_BMSR, val,
>                                             val & BMSR_LSTATUS,
>                                     5000, 500000, true);
>=20
> If this fixes it for you, the actual fix will be more complex, Marvell ca=
nnot use
> genphy_loopback, it will need its own implementation.

Thanks for the suggestion. The proposed solution also doesn't work. Still g=
et -110 error.

-Athari-

>=20
>        Andrew
