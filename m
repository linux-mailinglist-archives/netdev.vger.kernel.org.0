Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03535333452
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCJETa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 23:19:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:21990 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhCJETF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 23:19:05 -0500
IronPort-SDR: kC/XKaOrWkeeAcxFB32uAi94e/SaDLfKbmI0oeQLAiBy1IFjASe7nBSSAszyZkmIZdx6jn4/L8
 K/MCqsXVKr2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="167655413"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="167655413"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 20:19:04 -0800
IronPort-SDR: iqm2F0aJMnYKr6pnbC1r5Wa0wyiMr5FTwOacyZHZlo53Bn6SK8rF+6Ci7IM0BzXj2urXiZNUL5
 ItFk6oHhJ/Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="431048267"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 09 Mar 2021 20:19:04 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 20:19:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 20:19:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 20:19:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZBilb7EmgVB7O5ZAv0oBoknBaEnFn2Kz1rtJ4z8gbh1ri8nzMUcXiY5nWyQWX/5dRcIf5a/bWzDQGvFugQsAPC8dPpt2s/fAKNst5MQhFalDkae8z9R3GN+vCc5pHNc1a/zfJkXJGJ3+8UOnDRLs5XuJkOQDYux0PK7kAAi6+pVO7UkfP0tb35RuwPf1RY83ue11CWHpX9iRvM9lAupZnUfUx2JsqYl9e6cdfofXmEvsEIaOtn0/+XbL+QeeHhIz+qrKaSZV1qfciu2IrYM34Re4T6SBT1ifcSa+kIrPR6Qf78Foj6QHDtxkFZ5mTNP5fSL3o1DRypJOIkRGMIptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iK7lGqcjU/e1smJ1eI8m3RjdZuZtc1ah3sovKIAIDwo=;
 b=mzbU12eVu5icKGClnntQfdOOP3LqlcwzGPO45XfXtb2GbVmnMlrHS4fX63OfnIXFajL2/9x6haSPNvXQTBgWWPeNOXXlcF/6SCRXPu2V01mHi3GiCgPneOHDK9TkiAbyDs7IG2TbMQhjXt2r6LePksXp54WjYtIyZTx/5Vj5TXpHC99/HzbSvfzcchU06IxKS9r3RnPI8/JwQ7mD5rSqdVq5yecyp5f+8Ota3LZQ6xFJEndIR3cd62GKPzPbz+RD+tNAzMGPPUMy6SOUSk0E/5HpAFGSx0Ha6nwq+NaVdkqBRvVVwNrJtuiLKzKy7vdzrIT5I/+ZdiswVo70o3xc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iK7lGqcjU/e1smJ1eI8m3RjdZuZtc1ah3sovKIAIDwo=;
 b=eZ+ZVmAu2hox1YO7UAq40/03IpAJYsVvP8Z41JqpyVaxpSMBYMn/u+kfZQgJUTXsQlhQU2IFnOcT1jz5fiDccZ7+UoGc18E5Cr2E2e8GZH4VF/m3d62p89Xhwyg2+WVQduWJnc5Lf2TiczlfnvMnW6nBvTEOjK5LNrpt4wA2wyE=
Received: from SA2PR11MB4940.namprd11.prod.outlook.com (2603:10b6:806:fa::13)
 by SA0PR11MB4768.namprd11.prod.outlook.com (2603:10b6:806:71::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Wed, 10 Mar
 2021 04:19:02 +0000
Received: from SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::c5d3:e5b4:55f7:e4e7]) by SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::c5d3:e5b4:55f7:e4e7%6]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 04:19:02 +0000
From:   "Jambekar, Vishakha" <vishakha.jambekar@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next 2/3] ixgbe: optimize for
 XDP_REDIRECT in xsk path
Thread-Topic: [Intel-wired-lan] [PATCH net-next 2/3] ixgbe: optimize for
 XDP_REDIRECT in xsk path
Thread-Index: AQHWyLzwBRk2mx6gV0KVo6KbVKXjfap9NtDA
Date:   Wed, 10 Mar 2021 04:19:01 +0000
Message-ID: <SA2PR11MB49408999700F78B1B3844A14FF919@SA2PR11MB4940.namprd11.prod.outlook.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
 <20201202150724.31439-3-magnus.karlsson@gmail.com>
In-Reply-To: <20201202150724.31439-3-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [103.228.147.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bc1782b-4658-4999-b191-08d8e37ba2f1
x-ms-traffictypediagnostic: SA0PR11MB4768:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB47681014B8F1D90A7EF3F359FF919@SA0PR11MB4768.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aTcOik6yOp8i5fxc/aOeWYlDvKjFVQHVfX5G7MEgKUvk2adpW1Urc5GRc2Yac2UdBMk8XY41fih8zeQ7cwqM38M/AAq6Yd6AgehFPNn//xhhdC9wnww+wGShXfNeWKTa2XFXxbDsQ7Wohm0pfaelmSoMh4sfptbrIj4USvUwGtarynMeNx/mqUf99zbGjsBx1Su+RGWvV30LL3zobOiZa/HGqGRzkl2cn14FpelPReq8e8J6yiSns4h6d6F23qk6pmOxnE65qP+R5K0uxApIe1xkKzrkk49cWWI3zyzt6VtRLPwg0ObeS5xYXMUisxKuGyebf489KNm3lExs9IkzTreS76K048h0SzwDmkjsobZQAasw3HK5wWkb+BhUYwsDtQ1Sd6DUF97t43M3YXZw3txwrpUDsAOTn3o15Ge0kOKwZzgOxhTkqx0smxUVhWxQbXSEcHSzWS9IfOXVL4ojFCdm+GiD0j9HEWjlACE7Ftd7nrGJjNz5ibLXgZSQmWI1553u1B1sEElozARQsb/shA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(366004)(396003)(66446008)(76116006)(8676002)(66556008)(64756008)(66946007)(83380400001)(71200400001)(66476007)(7696005)(53546011)(6636002)(33656002)(478600001)(4744005)(52536014)(110136005)(2906002)(54906003)(4326008)(186003)(5660300002)(26005)(86362001)(8936002)(9686003)(55016002)(6506007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JSWGh2B7P7LSJ6OxY3Y5suKc5P0K9MZL3xY2QjCmPGQyC6PmkR0Vh68yWhZn?=
 =?us-ascii?Q?wmsAqu1/GDiilTnmZf3dLhXI3+6wBSkZOPilkNU0GBpABT0761AjoJ5quX7a?=
 =?us-ascii?Q?6GbpVUosXX2EgMh7xRu+OQ0ziuN7fBdL2ap9ibvdcN1tBTvdBgxASeZ8eh2U?=
 =?us-ascii?Q?BWBXZPCwKtKfEx4lfixFOL2JXdbg8GUqTzPO7TC++QP87nAdXVE1R7pi4Dd+?=
 =?us-ascii?Q?pTprw6cTM1U48M1mXJhGGR1Z7dhywct4J8ahMTUoz/6083yaN+V0aO0nEhET?=
 =?us-ascii?Q?QBX8qGM0Bf0FYpY01E+21lE5QtiB8UPqiBp4BMM9V+P+gtKwIgOkkKYmIzwi?=
 =?us-ascii?Q?pfNizh35Cu4IK5wYyNJFG3IAAZYg1f3uIkaNU18lrNpJd8dJb4NhpbBfOmYc?=
 =?us-ascii?Q?Ktr5eaBEKYhL22z/MBg92sBRrz+JFDUPYifjZnE3V/FVfAsJ96TECcGzUWb8?=
 =?us-ascii?Q?Rs3XoncBx63jMCeEXR4sDiCaLLe1w5avw49qHTkDqPHJQ2T2cj+ggAXIY7vU?=
 =?us-ascii?Q?M2IcKZYwV3vj/uTwlt9BSUi3rJynNlmPujiWoukUS/azjlx/leKzYXz+rxbz?=
 =?us-ascii?Q?ek6t45h1mflgbiYLUFGQlSKwglcV1D9mbRbu0+VJaXyRIICqkiwb26nqiXuQ?=
 =?us-ascii?Q?SbK9l8oOyJq/wXUUQ0Bls5Os/2SQy2i0BwZ1c37cvG+vh5vpl9RrpLxL7sas?=
 =?us-ascii?Q?1A9ji7eRl1FmodxVgLf5ZAwCJkPQ9wepjy8iYc7hesjfj2OvDEovMi0xLnn6?=
 =?us-ascii?Q?iEY3EqUZgmDwtLi7s/4CuDvTl8gXzhausSbe3A75sv7/BiTIycethv2i+fKW?=
 =?us-ascii?Q?SaGYlSD0+lka+Kmhq7tpW3MmXLVium6MbwjxGW4yXB+FpUC4bRP+45/duHDk?=
 =?us-ascii?Q?rkSNL6MD0xXcM/7CrnKdtbG/F/nK66NKbgjTgZCrjswUy/8RNc5Wk8WwfZeT?=
 =?us-ascii?Q?vBHQVRsvRBIU6hpBvgfDM4sdjBhTHVV/4xW880lOewH8+C4+kmke+cFCGk2N?=
 =?us-ascii?Q?0x/EQx32rv40w78BoHD+8pZGaaU7HUYb3ja8gu9+aHh7BqDrARGRKSZRAQM/?=
 =?us-ascii?Q?5yKxZbTI2+t/hqJZDnPe2V8P4eMMjrmR5+Rm1Hg3EoVVl6LHYRlk0YtZ3u42?=
 =?us-ascii?Q?rLFDVaIt4427fmzozB3YuBs3NH2+tLV1A8CVEx7rj3eMSYx1UR6WYyw/pAVZ?=
 =?us-ascii?Q?T9kzTr1TNFnZ3PtXlV/Tx+WQcsq1/ThuS8norHWNQ7o/UnW9KvjkJX0k+dgP?=
 =?us-ascii?Q?KmA1uw4cpuA24Cf6vawq5y8RPo1Ve2sXiKyFBBC6NQ/YngcFkdSTr+SQ3kCy?=
 =?us-ascii?Q?eqmiJCLyHT8HqsJ99moBUjbb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4940.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc1782b-4658-4999-b191-08d8e37ba2f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 04:19:02.3273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nUtRHW4/dDQwn6pJvwT5i4u/ETLuZ+5PnQbyzIfxI2WzyF8iUv2BHGabbm67OYujc//QlVk2Fv4S6B1SqJ5zEK8wC2c19IQVrOdle+AVh4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4768
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Wednesday, December 2, 2020 8:37 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Nguyen, Anthon=
y L
> <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; maciejromanfijalkowski@gmail.com
> Subject: [Intel-wired-lan] [PATCH net-next 2/3] ixgbe: optimize for
> XDP_REDIRECT in xsk path
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Optimize ixgbe_run_xdp_zc() for the XDP program verdict being XDP_REDIREC=
T
> in the zsk zero-copy path. This path is only used when having AF_XDP zero=
-copy
> on and in that case most packets will be directed to user space. This pro=
vides a
> little under 100k extra packets in throughput on my server when running l=
2fwd in
> xdpsock.
>=20
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
