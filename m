Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FAA33CE2B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 07:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhCPG4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 02:56:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:30469 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233790AbhCPG4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 02:56:35 -0400
IronPort-SDR: K8lrkcm7JhyDRv9lCPnBITiEx41jsAux3rA4TofzxMiqKsr2js5FCEykGGVp0vOT42XOpvP/5o
 ii3Km6OSWSmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="176806885"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="176806885"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 23:56:34 -0700
IronPort-SDR: RYCrnG2fvWvPBOTWV33X0/fcxITmfAy9JvnOzvv/A75gSCI3Sc+O2t/deU0yHqYk/jKbeJlHCh
 6blMpjukntsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="410945633"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2021 23:56:34 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 23:56:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 15 Mar 2021 23:56:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 15 Mar 2021 23:56:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2hec0/RH0YUBaIScPWeDVSdXPzOdI+la0sKI7mZAZJqzOJwugXTBiOri389Ef0tFWVbu/l2Aa3gHcAqxAUFag33Ga+8LzrFs7fWY3P3U1PmSIW5+CaXfRz+LbluP3xzoMcA6Ap+G3fOYtoub8x0KfuQLHk86Ac3uaKzPnoY84NzzYtthlNz0scqL3nHfIQ7hNgRj9LGT9aeNYp0IGeFDvgP4zarIghPwd3wjtr0qcpMp4R/t1cLxp3sp4IhEHFD6coyr5+mjT9bhUQrvC9QGOJYIB74Zg+/3Hdf9GmzoZ8T583eM5T/DXMtVlie2946Uj1ngnSZUNt9i6tpFhkXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJhBTOnduIEBRy0//IV6ttbQDwxZaKmalzS/lLDm5zg=;
 b=TE2ic0CZn9St5gXfVqCf7Bmq8Rl3Cb/TM1s7yXJ1xcxLnNUVwlUF3MatB+8A3rAbJInvqVWczS876dULyj+cb88fROgYwC6VWW5DlZHOLcnm9Fr2IX6LTjxYBYNjqUz13SxYQeH0M5PFdgjF7Sbes8DO4x4ZvIaMv7TSbugaEkAE8SHRnhjmLUG1jtQygwICNyHJOe/B5V8e9oCMnBmyvFF6YOvlxK2HbikpDz5sZgAj037ausoUu83TLJoFz7qkEqrjgjlU7NbFu5fzb3G9ywRLgRIQr9ChErXClixNEa2dORvg78bgyrltLM7U98KIwJzvvq6A4I05hJFIASMCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJhBTOnduIEBRy0//IV6ttbQDwxZaKmalzS/lLDm5zg=;
 b=lggmoZpeyezwBgCff27y2gQuor7eFOi4TT8mmEifwvfGRbQeKaQpT53RfDb25tH3xKAIknn8Y6fuwINt/UwfGr9kXvMvkGfyeLMysxVaZ0b93HqfDULPyTVtEtbVV8YuVYLsOwHdT1kIEUHnft+327MPAfvVDAotn3oyRwEFMZc=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN6PR11MB1842.namprd11.prod.outlook.com (2603:10b6:404:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 06:56:32 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::ec6a:25a8:8c59:89e]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::ec6a:25a8:8c59:89e%2]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 06:56:32 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "doshir@vmware.com" <doshir@vmware.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kernel-team@fb.com" <Kernel-team@fb.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netanel@amazon.com" <netanel@amazon.com>,
        "saeedb@amazon.com" <saeedb@amazon.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "skalluru@marvell.com" <skalluru@marvell.com>
Subject: RE: [Intel-wired-lan] [net-next PATCH 02/10] intel: Update drivers to
 use ethtool_sprintf
Thread-Topic: [Intel-wired-lan] [net-next PATCH 02/10] intel: Update drivers
 to use ethtool_sprintf
Thread-Index: AQHXF2f+U7+k+NBRpEO2cn2D2idATaqGM7uA
Date:   Tue, 16 Mar 2021 06:56:32 +0000
Message-ID: <BN8PR11MB37957A1DA6915E9E6A532A69F76B9@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
 <161557129416.10304.13389129491117212311.stgit@localhost.localdomain>
In-Reply-To: <161557129416.10304.13389129491117212311.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.0.76
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9a23387-fca6-4e84-30f1-08d8e848a1e0
x-ms-traffictypediagnostic: BN6PR11MB1842:
x-microsoft-antispam-prvs: <BN6PR11MB18427B2608718DE494EBB236F76B9@BN6PR11MB1842.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xEQzczvJVNwmKop/u/aKxfRbHNf85WVzv9D56OO9EybRMnZ7ZCmzS4KWZymggXSTvoODDN8g0L6NZbOEWlj95aWnVHCw3gF5Adv2DaLY9zpcNVnjjGhN7rW37RQEufS+quUQ3gwWbhQMMmNdKHlRew4uO8KLV8pFGyjFp9guS0p8mlxx5MHoOBBKBkMRrP5L7gLy6WKXFzM9ftyOM6T5qq3O4oNUAez5t/B0UQVxqNSqMA8NzRbAXI9zjDJVt2whDnqjdnD4nZAi+hy6KNc1B2pFCkFpkvzdBXd0QyJey+DjkqOl2hfquyLAgRNG8MppqJ14Ly4SlSCImTwYlii9vB/wsmt4f3E+lKvDG7hiJ2+VBSB2qBlPbMF3xORtxuySAdbFaP7JF2+jy7aDxcCf+P867eUelX7EeR23ZusdBaTMqZ46KsZreELZzWm+9nk/SS+lTx3p8UHWuCB7hEk6m/WgpD01nW8XDZQSla7C4/Dv0+e2St21PISqARgacAUtCbM5QNuWb0+D13cLaUYu2Brf3JSgmfDOqcEJCfyOIpqGAuMR5ODVZltV2w5+dIvDVLssizZhNu89F2hZu1jAyYWboGx0Ooh/+9hAjyiVdNWOZr8fPP4JIyOA/dy/XJz+bYC4h0Uf1i63U8oDyFYbaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(346002)(396003)(71200400001)(26005)(83380400001)(8676002)(7416002)(7696005)(186003)(4326008)(2906002)(33656002)(54906003)(15650500001)(966005)(8936002)(53546011)(110136005)(66556008)(55016002)(5660300002)(86362001)(66946007)(45080400002)(52536014)(64756008)(316002)(66446008)(66476007)(6506007)(76116006)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VtrVS+WicNky3Q97uC+3PEUwDi0w52yzRv+WrSghyc1Fw5ezB70ahhW58vi7?=
 =?us-ascii?Q?XnnDBpn12g+GZSgmTZOCHNCCrgRrCUTrQX2oBYDl008zZFaAEkjYnQngC/86?=
 =?us-ascii?Q?beKq/VH+umjk4xrSLVorDOOqUKOqO3nLqpeGyzXp70H9Razr1zDATKgOmt6M?=
 =?us-ascii?Q?SItEzuNBqt080SFWS/Vx5h39jB3VX3hWgNqcS8VFt/A8+bZdHfKEwluG/vo2?=
 =?us-ascii?Q?yDasSDC3y0eF24oI1crN0KWPhv2aoPdKzQgNR18I6jc6/MHqYYV4KGVgEznY?=
 =?us-ascii?Q?l5OyVvb7fCsFIWaWla9G0RHCCYcBY2H2SehYjBv7Fs6m4e4hJACQ3EETYANW?=
 =?us-ascii?Q?HWYpt7oOh8Dk8ANwGdKBaCz7wYQH543uee/bpbNJ5r9XXOxUt4MNOCvsl+U6?=
 =?us-ascii?Q?QObK0oh7I+1HBe4obQOfxTLazM8hk/+JpT9i28+Smk/+fu4pggTgMN2zZivK?=
 =?us-ascii?Q?NJYwlUJq3BkIsNYrEKVutNuZrJwgTXyIL0REtlwhNm8SYB+FpN+VWYt3jf/w?=
 =?us-ascii?Q?+rKHZ8VaKgtA6Ma44Dedp9y7A4jSABQJ5P/oD67lcrx41yv4TSa5TBZ63H+5?=
 =?us-ascii?Q?PoRuSeBzEPSd5eiGRIkBYo1PgEVAfQQ70KVRKMSAvij6btOAnmVoapveGbsQ?=
 =?us-ascii?Q?FIgQ9yVdSfJxDFY0Q/mBc59Q1WWfp+Kd2DxIYC6iXuaZc8BXXvZsAXVfH7PR?=
 =?us-ascii?Q?DWks7ZLk7h07fbIuCcdxHjfJeHLL79wrGD23r8gRpXU1tjFGfMOa68F22v0S?=
 =?us-ascii?Q?XB3T/+yKim1srRyujTzJtqI8VEu2fdRwHm3BlrzVVzFoHtyKhJCxHk/CDHdS?=
 =?us-ascii?Q?RYZ1nEE6qnxvzaxpgGchf/na1Bv+xqlmXXkLtRj2UNstd/d3m1vPjdppAjfG?=
 =?us-ascii?Q?C2DLfZ4wq84IPC1taZSeVdErtZQnHd9kyBnhUK7mT7g0msHrostYxpc5iYfx?=
 =?us-ascii?Q?wIdeF3VyZJdmpU8pPkd6n/LzgAmz5O798DxRSwxU22LUGM7bh5s/xUGcY3QU?=
 =?us-ascii?Q?XcM1ywCJRSYq9I3/FkrWzboC7eHgIBvqhX8/u8y+RcsIp2o2TzKHJnM7pjXg?=
 =?us-ascii?Q?n/GSF+6Sb2Bp42xdqHWdaQ/DbQTstOROFkRPNTNfWu7hxv/2dAAkLsDtPA64?=
 =?us-ascii?Q?QS+gNZK+eHDRbDVzwmqa5tKTIGbCENecI/QyI978rWpT49Dmh0k/PFbhOO6V?=
 =?us-ascii?Q?hEreh4YBEYirqufAcQnpvUcq45H0dFWxm22M1uDota2LmnDVvBa28OBFLm6D?=
 =?us-ascii?Q?1Dm+l8A5NaMcg4gWLDAzCBhj4Wvyrmdom2jsq/PIvjbColEKGk2hDHmSzg1E?=
 =?us-ascii?Q?BKad8ehCd3wjr46fQKuMULh6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a23387-fca6-4e84-30f1-08d8e848a1e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 06:56:32.2339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z+lPnHJl/g5gOlLSMcqRXAubVR3o/NnxvKFw2e6z2xVVN0GOxip65FxcjPDwuGDPalA+frFcdjf8QrJC4W2kQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1842
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of A=
lexander Duyck
> Sent: Saturday, March 13, 2021 01:48
> To: davem@davemloft.net; kuba@kernel.org
> Cc: doshir@vmware.com; mst@redhat.com; oss-drivers@netronome.com; jasowan=
g@redhat.com;
> alexanderduyck@fb.com; akiyano@amazon.com; wei.liu@kernel.org; sthemmin@m=
icrosoft.com; pv-
> drivers@vmware.com; intel-wired-lan@lists.osuosl.org; Kernel-team@fb.com;=
 yisen.zhuang@huawei.com;
> gtzalik@amazon.com; simon.horman@netronome.com; haiyangz@microsoft.com; d=
rivers@pensando.io;
> salil.mehta@huawei.com; GR-Linux-NIC-Dev@marvell.com; rmody@marvell.com; =
netdev@vger.kernel.org;
> netanel@amazon.com; saeedb@amazon.com; snelson@pensando.io; skalluru@marv=
ell.com
> Subject: [Intel-wired-lan] [net-next PATCH 02/10] intel: Update drivers t=
o use ethtool_sprintf
>=20
> From: Alexander Duyck <alexanderduyck@fb.com>
>=20
> Update the Intel drivers to make use of ethtool_sprintf. The general idea
> is to reduce code size and overhead by replacing the repeated pattern of
> string printf statements and ETH_STRING_LEN counter increments.
                                   ^
                               ETH_GSTRING_LEN
>=20
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---


>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
