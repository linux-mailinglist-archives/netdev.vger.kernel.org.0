Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A98C439EB1
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhJYSwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:52:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:34757 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233224AbhJYSwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 14:52:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="210513247"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="210513247"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 11:37:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="723658828"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 25 Oct 2021 11:37:05 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 25 Oct 2021 11:37:04 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 25 Oct 2021 11:37:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 25 Oct 2021 11:37:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 25 Oct 2021 11:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3/1heDSJcoIkJvwODvkHGHGhPaQIz0dIkDcGhJXAPQAqHHx4L8YZAsppdJjKmk1M3zFk9Avb2bhhqPULd4GjF4WMXQ4WbIIW5EIIe+NpcHa2Re4T0Dw7hij0TTtg2QnhZNP3xy48CP2ZFEddYdwvSM+42h3kkV0NJ/8Ubvjb8RZTtjQHfwxikfIOdOVnFh4NzdFUEz0HYCs6yJLaXthT25d6D0WqHgsQryfKJKJyG56maurpMHgRpX+QHn0Inw91/LmwcAJbJI7wQdo8jQ09FiTM30MleJIYHuwf4/tycEaD4QcGiy2r5LuiNNtJcXT6I10uXkdn6t/FNq/igKWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5CdSQMKdLmLNXHpREER4XXg7X4aASgt2OUyZfFnH+I=;
 b=FtjicodQTFAGG92aqyI6and6JqvTeoqF5noSqRhYtuIPqAkCZm1BxQn0kKOje+lidNZHVcwz+Rv07U7T2to069XZFoqeM3az2ubqAm6WYtlaYYw4HU+FoXTClcjg7GHCaL0RBxoPOcpVgaGJCOFo+LbqN9sNb0uxMEqtHY6wq79v8/FmpZbFU6ei8On8MkDq14dUnxToGvPBRDBDcZpIrKbtWMXpSnvzexcTuS5g/DGyU3gGYD8sybSrh1Ma14z0Uk7dq99Re9YKQr1RpV/9mhaXa2nXhfLJDEL7YRHVXiIPShcOCUDZTKuBjUM9J+tsjXFpwAQb0dYLuBJKZBVYJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5CdSQMKdLmLNXHpREER4XXg7X4aASgt2OUyZfFnH+I=;
 b=HV+c9PX36Rwi0ltYAwryOJhfbUc8ivaE98jOEKdXlgjHxHyG2YWOvrJjotx0K0gBzH13wsU3H4uOfMXgtMwZphwjCvT4WLWcqB8iHpEw4fuJ3ZqnGZBKAx6dH8aTRmmRKYumhYfxnx+1megA/R4pRaEEy7o/hxyfb17nH+xydsU=
Received: from MN2PR11MB4224.namprd11.prod.outlook.com (2603:10b6:208:18f::10)
 by MN2PR11MB4349.namprd11.prod.outlook.com (2603:10b6:208:195::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 18:37:03 +0000
Received: from MN2PR11MB4224.namprd11.prod.outlook.com
 ([fe80::6508:6409:bd4e:bbcc]) by MN2PR11MB4224.namprd11.prod.outlook.com
 ([fe80::6508:6409:bd4e:bbcc%2]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 18:37:03 +0000
From:   "Brelinski, Tony" <tony.brelinski@intel.com>
To:     Yang Li <yang.lee@linux.alibaba.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] intel: Simplify bool conversion
Thread-Topic: [PATCH -next] intel: Simplify bool conversion
Thread-Index: AQHXtP8uZnwa1o12TUK8YCX0sGVS0qvkNHdA
Date:   Mon, 25 Oct 2021 18:37:02 +0000
Message-ID: <MN2PR11MB422476A7898C84BAA9840A0D82839@MN2PR11MB4224.namprd11.prod.outlook.com>
References: <1632898586-96655-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1632898586-96655-1-git-send-email-yang.lee@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 575f749e-0743-4d9e-0f50-08d997e6703f
x-ms-traffictypediagnostic: MN2PR11MB4349:
x-microsoft-antispam-prvs: <MN2PR11MB43494ED69568231D5894AE8982839@MN2PR11MB4349.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QnZ9wzajAEBEhHAti/mH64BSCrMXrYJGtXuXRJhYWH5zvLssgMmiR0Wy4aJccydk+NDhuXOKc5OT8H8T02kj9ypN8khv04R9QLItUIXB1SyjPyWb7DXQ6IIp5v86H9waKV6L9qlJigHRw0yqN43S2JzcReYZ7I2FTQi9FlvCSn7f+iTy9S2TFmyvDoxHcHSK+IPhIgvChMdYpu86WrULTpPdkgykPQg8kNjuyvyf0m9uouU6G8N42Dk3yCPdcq0iRp37c0Qoar7MWk30uvXikuBPhSnAj881Wgn/fLai+9UrCcq0Ely+WpRa0gAJplLixg2K97fQsnYuxaKApmlOdIS09wLElKeBDSsx6ky+bdJWOLHkrspC9AdIcGMwCmOBdahip2PybuZMmeCuf3dg9gePua22Uk/K04OQGtUCV25MQCuwDv1925Pt4tlkBFi6NjbOWhS05RsLo8XARyWyiGYla78JB1YLMkhrRy8DncldLd17Wu4mwlEYVXyHLBo2PFRU/D54mMJJcVPDnefXZDSdMEhWSfu571SbnxQzz3Wx9s9huR36JqC1sqYXiIc0LBo2F5nynROzNebvf8G4CFyo5w6SC4nm6862LvYtSSLm3bVso4jCmjdhxctkUXd490IMYvpInB4Fg9MvQZ/xVD1BVVFbIhUs+g3uKT1kKNE/DspBNd8Bj4XkDdfr9UpBEtDN4XOgdhjLI9y0zVw1pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(122000001)(38100700002)(26005)(186003)(7696005)(2906002)(82960400001)(316002)(66556008)(66476007)(66946007)(4326008)(66446008)(6506007)(53546011)(64756008)(76116006)(55016002)(9686003)(71200400001)(54906003)(33656002)(83380400001)(4744005)(5660300002)(508600001)(8676002)(8936002)(110136005)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iVH3us4sSXiDf7FLxjTwLWyhNogDhlv5V7ZawEir+MeBxJqvDZPZgPJoDLcK?=
 =?us-ascii?Q?C4fHOCt0XnFZvRdUfuadHLmEy4vMbVgNJB0DWb4d6yB4WS0fwYEr72CVN8OV?=
 =?us-ascii?Q?Hi/35sE6tUaQGrA5pSpa6cL6dtmWw9TKM4dvU7BQUk5ViuyX4aRoBuB9dUIz?=
 =?us-ascii?Q?XELaKZezd8tbV1SmKTeLChTiodZbWax1g48A5WCUV/zAbnNf8XSExGBP7bcA?=
 =?us-ascii?Q?ZL5JHyNKq/uAJA93n3LgxQ2TA+q6xAdF1HEqu1BcU3LsbD6D491GAwGKVTS0?=
 =?us-ascii?Q?HL98vgtTWwS90nnsjZ4RSw28iCvS7rB+An7jvoN2E24ZZ/7eUAa9nhnBLchL?=
 =?us-ascii?Q?Qr4Kv3ZmDhp3S0A32OO3vbDddgGJ3q9j//8x6X22hxu6c7AuPosuLpOiURGV?=
 =?us-ascii?Q?3GZXInQ/Y/vcnZIBiUM0hEaKY/Q6zi6RgWP6vQqHdDtMoe/dtNUrSxWiQmCA?=
 =?us-ascii?Q?hge5eOealsX3WDVK9E21KBBFJSbBIvmbB6vT72vAzwQMqTZ9RETYcWzApGbU?=
 =?us-ascii?Q?ELMPflHmVVxNZBH3jgjnygsVbrGw+VaUCzcBi8RYkJPDTgEVy8gdZcxBafUv?=
 =?us-ascii?Q?JAhU82+cSVYPZcXKIkiAgZl/lLQ6rz6MibCZvToYPExH+dXOrL0WU5fByKZo?=
 =?us-ascii?Q?rMS5jnjUMiHoFQTl0N3bmJqGtZNJi733tmqYwDRb/oMi3/ruP/3Jtxoq0vx2?=
 =?us-ascii?Q?T2cA7siYENsZAVCBkx+qFQPtFYunNOP3fimHvOKHDPufz/qXMwm/uw+AQJKH?=
 =?us-ascii?Q?mWLoksvPmBdJthqTY7PNCYSWDiezo9iw4Jro9f0duGm07I+cYeOeZoeCd4B1?=
 =?us-ascii?Q?6eRLbmToTgIBIR81EVFPKYt9cr5y7YCl8+H9pVmjNRhX9oKfcVuRN8R+f2U4?=
 =?us-ascii?Q?JZHgAJi4IK5lyJVenYJd+c/svfiRhG0Uz542tdF6ktdtHFR2wiSjdcoEnac8?=
 =?us-ascii?Q?88POJk99usglJ/RLs3cn1LzBzS/EVXAvuQPH4KYI+74lkYyMiSFFRRtAOPh+?=
 =?us-ascii?Q?PPz2iCtoTjyED+WrgB3/ZMZpbydiXaec1H0W01dkW3O9mM1VfzxNyntj2fa+?=
 =?us-ascii?Q?nGreKxJj4Dt8PvgqiOuIVh/vzujolpfQpSp2PVwUc7jfe/uSMvXNrbypMar6?=
 =?us-ascii?Q?N6iwrENSs3XPD8D1nrwq657cuoaUtptIl6lvwF9XuqARf6kOUI++7lxXHy4F?=
 =?us-ascii?Q?ankYAIeFwrffkmnCF+e8xCaE0nO3YEBpaen9KeNB8YTzGv/xj5cbOOpIKc2E?=
 =?us-ascii?Q?Nz9BoS6K8aQX2+9hi2efuiA+W3dOIh4m6ALI9W9kNtfVDZ+PCuNcoj1YNuYd?=
 =?us-ascii?Q?s7rXnuOG85RpY8tJFCp6PdsMVZlzctbdWO2a6+nxXuAVKFE1ObygET1I+f1o?=
 =?us-ascii?Q?+n4At5LzSASTtYodW1Uga9sL3HL2cl6koY44SM0kLja9bzi3doCpf1L9fjyw?=
 =?us-ascii?Q?8imkXNdDG5oZrsGfXU9PPfUgILZ3rgXvZ2QjiIsqoamJ0JPD1FyIC7tHOIqt?=
 =?us-ascii?Q?e3nKkhqxMi7CD0NLR/77XTlAhvRUOTdpSqhwRpmZpY6B5KkA+5nwXV6SJnU9?=
 =?us-ascii?Q?dL6ty+QuAXVfrEXyaYNKIeltvm/0ZIH60ObzO2BJrUVkBvLDTQazdPWLwAfj?=
 =?us-ascii?Q?5kDHluIzK1sXTrq9+hBVm8tAOPysEefq9k0gVQJNLSQD4oFyUq8KLZnC45ye?=
 =?us-ascii?Q?P+Q4DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575f749e-0743-4d9e-0f50-08d997e6703f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2021 18:37:02.9809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 82hEsv3x+Tfb8/FxyxADh4QxB6lH4bHZ8STpCZbxDn1i0XQXDN0IJQoWbN25XMOCozP2aW3zItmDnXqSNdVSat7qLBQ2M9e2CRmkdtoU5dQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4349
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Yang Li <yang.lee@linux.alibaba.com>
> Sent: Tuesday, September 28, 2021 11:56 PM
> To: kuba@kernel.org
> Cc: davem@davemloft.net; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yang Li
> <yang.lee@linux.alibaba.com>
> Subject: [PATCH -next] intel: Simplify bool conversion
>=20
> Fix the following coccicheck warning:
> ./drivers/net/ethernet/intel/i40e/i40e_xsk.c:229:35-40: WARNING:
> conversion to bool not needed here
> ./drivers/net/ethernet/intel/ice/ice_xsk.c:399:35-40: WARNING:
> conversion to bool not needed here
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Tested-by: Tony Brelinski <tony.brelinski@intel.com>


