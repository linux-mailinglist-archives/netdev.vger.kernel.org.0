Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF74441F13D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355058AbhJAPax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:30:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:1800 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355018AbhJAPaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:30:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="223566372"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="223566372"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 08:29:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="521153750"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 01 Oct 2021 08:29:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 1 Oct 2021 08:29:02 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 1 Oct 2021 08:29:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 1 Oct 2021 08:29:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 1 Oct 2021 08:29:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fk74wwIP1Xhd60Wea0MvUqnPR8i8E/mdi524eJk2wLEf9aSf9ZjnCTC0QlBKdb2GhlvMlgnsfOm4i1V6QlZSWfNUA3DWhMc1tO1/vKqYJaxsiRUxy0oonsk7FLzHbs3+sd/40vTchFyqY5XOMe3chwJwKuL9T3yEvbPoghz4AJa6MVZ3oNDqMMVVbhCJvuDBaHAm2GLSl+Sw7fGNK9G32J4mzABHTX4gild1ridTEvMHim+/cWg3NUkHKeugIz0+gKKnmCQsI04JkojKPPZfPcLF53f6xrbwgtLnKp5OuWqiSpT2AFuBeonHKOuZ9b1JAqv9MbinQcCBlA1nF2o1uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBWbutntv8MZ71SnENCsXIIuZJREVOuvsTuuMFkqzrI=;
 b=FrQ9Xy4818njEEOS0mMyCWHlR7Db4tc3r9FH0yeVQlK/1Pw6Zi3biRwun1NVX9rntClUk4FdOo4t1O8MvrpTTJ81ZH13E+A7DnhP/4wnYtkffThOaR7CD6CmDqBSRw/TYRCU6dHyCT6ER8OCODE5Tq2FiRIqiq7K5F1lsNp9pb+YbFtCH8VMS1hqRITK+fO0/99uz5oZj2sF9Bm4S7hkySw7mKZv8M4EOM02jXTu3QAA3dILHkUVi9yZpOCrLNx2UmkGaY+eGJDfzdgdMXRIxT/Vr1j5tNU2gmpvkagMSvk2lNbUSFsSy4kqmi8JMikJoe7SU0cE17vVGzV4gTSoxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBWbutntv8MZ71SnENCsXIIuZJREVOuvsTuuMFkqzrI=;
 b=K4sB7rVuK1ktpBhzzDAolwT8LclB5L3f68oyshY24SAX4GWjRR8H4g760I9FUiW4IMKiKbgewMs37xzt+cZ6YAMn0bQkKodbwx2ddmg/y3OQ9A8dpfTDDodt/4lfxN2VLVHpvMxM3WagR8k4NaqnoXkXx7i7GUA1bf+DkhL41aI=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3703.namprd11.prod.outlook.com (2603:10b6:a03:b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 1 Oct
 2021 15:29:00 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::90d0:abd2:bb85:56e2]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::90d0:abd2:bb85:56e2%3]) with mapi id 15.20.4566.015; Fri, 1 Oct 2021
 15:29:00 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Make use of the helper function
 devm_add_action_or_reset()
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Make use of the helper function
 devm_add_action_or_reset()
Thread-Index: AQHXr7kAEFcgchZxTk6u+23VQnSSJqu+Uojg
Date:   Fri, 1 Oct 2021 15:28:59 +0000
Message-ID: <BYAPR11MB3367C4843DB61D410B095341FCAB9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20210922125947.480-1-caihuoqing@baidu.com>
In-Reply-To: <20210922125947.480-1-caihuoqing@baidu.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1be58da-5cdd-48bc-e5e3-08d984f0311f
x-ms-traffictypediagnostic: BYAPR11MB3703:
x-microsoft-antispam-prvs: <BYAPR11MB3703F3DACF4576BDE39CF738FCAB9@BYAPR11MB3703.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlxo4s/DjRspHnCm9rJY1ty1Ahv4BIHYmTCF7r9CSpVzLErMX4NjMYsm7H5KSHocFWwa1pcs7Ix3E3DBObudp5Gk0W39a6t7kDHIZMywV3zM2C+Xh4ZJIBi+y89GmikZln2BC5OYM51xSNg9chSJMq/NnPcIF+EsJ9VeFTxI2XN5Srtm10miPfvlSDNyp5rHv4hBZ+G1liHLa0pEorYH7RXOhQKkxbOxbRVPi1gc+D/bAIA6VDKdAKmea4kp5CPajbFXzi4yKnUQbCSsm+bmJ3xCPGc/yyzK+hFeUwgk6yottfU8nJ06d+YEJpQ6agT5wNSwpyFiwP6sLPJWuJfS4CaLeoqAxO+PY27hbC4ZZIvu7KZUB0zf3gbDVIMUjocLtihD4gP/7FcaaCNL2O5IhH2sR6vb8Or4QDBPbLNLurhec0gzostA5vKreAG6L2r0qf1dsARLNX9cvpkNdUF+IxbcADq7teJC/GsAc+ieId+F3gSs86g5nSgaDYXxzfcOgSEvPZK3agWxeY8fV4Izwj9IAF0qvyikCxA8dG4x5bxmw4Jdk/sjYZDOngav8JJGKBjcqdwcnAemQZvaWxO2LBXNT6zC1OwduFM67LBmTg9/pQjluVMpqu5kj7eZZ+mEMGkaDS7BAtcgBWpaukp9BDRXzpXbKfbkcHaGMJSu+oBJYDcuIp6Z2e/24jrr4raaYQnAFSItdzOeIe8KrXDo+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(316002)(55016002)(9686003)(8936002)(4326008)(33656002)(66556008)(26005)(4744005)(38070700005)(38100700002)(8676002)(66446008)(64756008)(66476007)(54906003)(7696005)(86362001)(83380400001)(2906002)(66946007)(53546011)(122000001)(6506007)(52536014)(5660300002)(186003)(76116006)(6916009)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2YX1xcTTSap4eY9je7N08ouPfBFCk199idxdDv5FxQDO83eiRcjgvRvYzc9y?=
 =?us-ascii?Q?na8cZNYsL8hofwtCnKdar7Q/lUf6BXM9kQFMVDkIlxY6F+FWRZo6NzhCObW1?=
 =?us-ascii?Q?Ce/J1TFyoWMV719m/S9YowucmxvMox0VVTEoTXngPz6MHZWXjMc30LM/IDkY?=
 =?us-ascii?Q?OKh+1yeHca2oZgQ7Ov7kqtvLguvOyAsn4/uT2YvQxOV7eIhieLIAgHbRsu/z?=
 =?us-ascii?Q?2pE5If2N8754rZChHru0m0t+62l7KBffoTEnqkdp7GnhRbG06YFo8P2FZZUW?=
 =?us-ascii?Q?U5kgMHyiAZBVDhC6O0xZJvcVKiHM2vB11L/bGWLn1PIqQNO1/ek3RGl0iAyF?=
 =?us-ascii?Q?j8CugR5CG9UYXgCmlnmlbu0FQ3FLusyVkgkf4EV1r/E7cX+W/lvO38tvUkaZ?=
 =?us-ascii?Q?WPHJu5/aiQF8bt/7UvLaAL/tSTYn3TL33PKgkDkMiYrwF1Ap7P9f5X06j6XF?=
 =?us-ascii?Q?Rit28w0CU/ngLsqaFvE7RossCnaCO0/SyIYoDODWk+yqDJpyEe78UmCtpb4j?=
 =?us-ascii?Q?ss4z4fjcnSo+GRRAEHgPGrD7C2y1jubH/dFm3TmHTyLrTQ7wq5ibOxYulOOq?=
 =?us-ascii?Q?s1LeFKSXWZID2mL8t1aaN0S40vCh6sz78fiF53UCZ7Adf0JtQpfFxb0Nsrq3?=
 =?us-ascii?Q?7lV6R2s6KHyW4Qc0443hk2ak8tIYXpYVYVl53sc3M34S20F/9ShLx422z5hV?=
 =?us-ascii?Q?wS1e+MpQgKjd36w+JWH47P0JymSf9f3OH1ZisJ5luCpzEbLbEt3yJhC0fB8S?=
 =?us-ascii?Q?dwIuKrlVwjDXm1Bqvr4iBndhLcFgLUQ3H8HUiYK8VRhknuv9WqUO0JHoW8nL?=
 =?us-ascii?Q?9bHAczSc/fOe4aoZYM7DlBetBdWTxivUjJHye9vZ+Bxe/EiBaNjyjlr2L6iM?=
 =?us-ascii?Q?0Z4LncLanp93VNzG3UqhXqrejFqNayT5oiwFlN8Lbdc1hyVrr3ZSjFTcJ/Go?=
 =?us-ascii?Q?o8J36zDuMqXhMfuFWvlic/b5t9L407rmdWC5hRuXu3XU4nQI5DVRNobke/v8?=
 =?us-ascii?Q?RldxlWI3OXZoY6H4FZDUycyoiXoWXJ9AlmHfHARzdWAYZgVGgqsdFFJv44GG?=
 =?us-ascii?Q?gvc+JaNPhplT+Gn2kkI7+klfppH6QxZBrWdqZXcF6pjCa3mtVmXKL2tsgkly?=
 =?us-ascii?Q?/mECtqZr3rhOHSJqGQGc/w6SObQuwhoIur6bg5+MB/zrDtGxX6RdJvo5GvCa?=
 =?us-ascii?Q?B7L9P9uJv2sHZaRxRR1q82Ci2glYXkQLBG9yUC+WK5RqWEV1q7ReMqS2sscS?=
 =?us-ascii?Q?6+6DX4RaAcZ6BB2s6l+g4jucutcS8GO2K+DEq0KgIU8Q8KcCigE/LkDPpn+V?=
 =?us-ascii?Q?Rzmfm6eFBJE5GtKuRzrpupnX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1be58da-5cdd-48bc-e5e3-08d984f0311f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 15:29:00.0127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RHr7FCyA0m4FzH67OHYZO8ZsnRLkVdJ0Qw7dPqB5nxIkS3MoNKQMkH6KERQXLAGZ5ZqaaNCpLqEkTsw8SbTOIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3703
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Cai Huoqing
> Sent: Wednesday, September 22, 2021 6:30 PM
> To: caihuoqing@baidu.com
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; Jakub Kicinski <kuba@kernel.org>; David S. Miller
> <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] ice: Make use of the helper function
> devm_add_action_or_reset()
>=20
> The helper function devm_add_action_or_reset() will internally call
> devm_add_action(), and if devm_add_action() fails then it will execute th=
e
> action mentioned and return the error code. So use
> devm_add_action_or_reset() instead of devm_add_action() to simplify the
> error handling, reduce the code.
>=20
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
