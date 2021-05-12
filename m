Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2328137C7D4
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 18:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbhELQCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:02:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:31232 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhELPtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 11:49:09 -0400
IronPort-SDR: KUwjLnkhI/MXpDMUW1DSxnfQxJcOEKAiOwdXwbeYUatbUhTFgJeJGOQw97Kd0wooEYpWfDg5Xk
 j5minmYFTxuw==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="260988252"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="260988252"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 08:42:02 -0700
IronPort-SDR: fjrBtGqoK4V8G5u7oPpoUpxAHTxLogn60dzyAxw8pFXLEOK3f6GhOco2xBJX1bB3yH4Mr3GFGN
 JzbJrqGLdOEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="625446486"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2021 08:42:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 12 May 2021 08:42:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 12 May 2021 08:42:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 12 May 2021 08:42:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/xoLeV1XFqrV2WONWBmzYlCxvVdDBByoNlHUphAmDQFjVeEJQd16rJaU1gKjEWFRYF0hy8fk+J75kRPEZXgMTbjc7IxaBLchG2G8BY2fKt411MqdjV0ZzVDsqb3JeLIEkAmoC4djJlYiynmteYXtFW9bArihlhjYC438SLC248SKGJtLOdrLPZD0kUSiU3D1mytMu1RcUR2DIrVkQRMeZiCungy3lbD0OtsUXK7tiUMo5SjxUtd6Xfp2dFgyQI66xqO7AsC3qe3TKP08LEsKD6Y/MsSaD2Q0G9cXOE27gCyAI40SFsNGaL2ZH040Czv0R/Ec5wQZ7PulFpjj+11eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBgy5Byl5CNW7nC8ND4p7G07KwWWxd0BkDqjrayXah0=;
 b=BFVQw0KZbIP8TPuybum3rcu86rJfwilWQSiB/PzadzYTq7tEOA3IIGXtvnQDLiIjfJys8Z9IcPYRC/fgsjps63F8NICBLtfd9GZc422kfzSWkIPrPpFrJMyQ1TU6/HI7QbRngHOCUGu0mve19rTVoBVT67+rpNExHTYJPstpqfQ6mBlBIn83gsz7GomGBrEauvo2MUGVq+b1z3tkJ2JGYA/1i8aMh4t7PSjpB82Ha9xu17BITPB7iuQY1d77CrknWNXyeAbiLQWvrEYjVIslmWanCRxGiDeWEr6DGba4G+LzSFLRIgFxKxjHNty32G9SmQiFrWBk9U1CaUFMUh1PYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBgy5Byl5CNW7nC8ND4p7G07KwWWxd0BkDqjrayXah0=;
 b=MkyOGS3afxHqv+EWKg1//KOXwkKu3eGOiPE7qAPcfKUBsqzTUehncKn6ushzy2uDjZKD+VfWhbyWg1Mm4W5Mb4tiNhj0XQWQN7VZsIaf1gtJ4o6fJ79gnsrFY64RiYorWkRc2M/oi/PwBGIDS9Ovoo2R22vkAlKzt5VXnP8dSys=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by MWHPR1101MB2208.namprd11.prod.outlook.com (2603:10b6:301:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 15:42:01 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::4db9:fe34:a884:4e43]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::4db9:fe34:a884:4e43%7]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 15:42:01 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     Salil Mehta <salil.mehta@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH V3 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency
Thread-Topic: [Intel-wired-lan] [PATCH V3 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency
Thread-Index: AQHXN9QDou7gZFgUB0CklWx0l1e/j6rgGtUw
Date:   Wed, 12 May 2021 15:42:00 +0000
Message-ID: <CO1PR11MB510568A203307FF255D12771FA529@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210423000018.20244-1-salil.mehta@huawei.com>
In-Reply-To: <20210423000018.20244-1-salil.mehta@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad870d6d-c983-4f6b-1ccc-08d9155c7bf0
x-ms-traffictypediagnostic: MWHPR1101MB2208:
x-microsoft-antispam-prvs: <MWHPR1101MB220861BE082F6E85EB3813F3FA529@MWHPR1101MB2208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfV3kqV/giX3Vr6cSiNTDDJ+eChM231DolxhUkgFp+yL+NQxdXl38/VnW6+PVWTMY84tKi7+rQNC/P8FbRzhrtgfGLmZzYnlkJCGfebr0dnn85P9wMwCllYpnITSiZrNudNp72Z85r96ez7pC6aDeufP7X+CP8M9rwhbqj+OuXc/eGjxh0Fm+pc1ji6s3u2ox+CBxD2T3fHAn04qclMnKN2H2+d3QVgVYYW1mhxeoF81DhXiZt8jtuSlD5hVy1+bgEuzztg9aW1psqUvU9jFNiQfjMS92FMyIVutwQfSNZirANIKV3c6F75sc8akyWR6V9W+Z0JyIYhvM3KTG7IUu1zX1cn77pKqpVyfzas2uF/yBo3DPvpW2iQFQjEEbhIArWtvGtYYUzSe/wyM6MsIMWtjExtc26s6RMD5e8sOoqrmDhCAfrEjHZgC/KWNnsF72FXrECzbuq7HmEe6Ramo1igX4lvk3+dV2ma4kTfo44vaZs5bbhdc3TENvHHzzHKHmLXXjgVnhEWZEboPwW0f64jJOClEcQzbe3TOdVPmlG4O51Eb4yF6TyTN9emvYA5/nTwVJIKXbJoRF8PjQCRp0mjzT9Ssbrfon8PBdR0Q64GyM7mHCqzuTu+wHHP42DUzk5bbuabmut+bggPnQvkAbFpW2107D3MFfKtZEq+IOLKqR5ThSHwNbEJmdz2dMW9Df3d+hc7WG/IkXZz0E2EZgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39850400004)(346002)(136003)(376002)(396003)(86362001)(6506007)(53546011)(7696005)(26005)(33656002)(8676002)(38100700002)(122000001)(83380400001)(71200400001)(8936002)(316002)(52536014)(55016002)(9686003)(5660300002)(478600001)(2906002)(110136005)(966005)(54906003)(4326008)(66476007)(66946007)(66446008)(186003)(66556008)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gOjwP8hVU3Ym/8OTV5d9Aamt3MVurYXCTqVcvv4Wc2PWlDcQ6cImmwc7P1+b?=
 =?us-ascii?Q?TirqxNsWLbG4pIx/bPp5A1P2108pqGmKPBmk319A8mIlINAupmxYiAYMVrtl?=
 =?us-ascii?Q?BwzJmO3jhjtNQ4cdEqGaAsXvaOebJn/hVsX+O4Jot89QaxO0Mvhsm1S5zoXX?=
 =?us-ascii?Q?rjzoIr8+1wIrMajziaxlAfdYlJkW1aOMnPKOd0ia9FBNRl6ikryD3027eU1L?=
 =?us-ascii?Q?dPutQ2/qd2yrVf4cALdrcVDUoXLvqf1xGinTYxTtoDwRJRXEcNZKn3vGpi7H?=
 =?us-ascii?Q?5nAd0tGgrJpgXPimxIIpotbPAzv+y0eGFnKKcQXt78mHAJ5Nt/boh6b3Nt8R?=
 =?us-ascii?Q?SN+8EBresdrf0F0fQMHZS3eLsM/Glb9SwEHlcfFOSFrKarlEAu7Ev/S4g2+n?=
 =?us-ascii?Q?QoQQlAusjg0YyRGsfQd4J/gZzSx2I0w0uFGLI/pbeozt3jkG3/t7HwvAHJ7Y?=
 =?us-ascii?Q?v7r2RJCHbswJRrlPCWsRPesxpgO3l0JTlAsr0okoqiUjkuF/USTCUlYaGocB?=
 =?us-ascii?Q?m8g0G5ymLCmqLZWYg2btXcWEGu6GKRYD4dmLyQaU4fpCkDcCY7oNKZImkbVH?=
 =?us-ascii?Q?31BN0xpZO1m8tNNt3kUHCmM6ZQqUbmbJ68Y6MT1DVwwOfTEdon0P02pyOe5h?=
 =?us-ascii?Q?Zqa2fkflxEdI71Rbp3rQtvk0AH+Rm/wc6ywfu5n+17iZeoVIpUWPqpgES/z1?=
 =?us-ascii?Q?pd5POQCipbEILEOeoGDrXXZtiZTNarUIYnWKLPKRMUzatFwT+cZfb/LHTG+/?=
 =?us-ascii?Q?fFImEFdYSsR2D7R2YUkKS27TToAzERGzuWCwjovtv1573gFs1hHDMupd8jA/?=
 =?us-ascii?Q?PagXKAG8dOxKgtzE8zwZ2EtfzLl0OVGMe4736ew1busNmdMaIrbvwu3hp1yT?=
 =?us-ascii?Q?8bNT3NG0lQgOXQwzudH99a3PoEiqUKmZMlDOM9Ah4jRixuy4nl/vY9HYoJCw?=
 =?us-ascii?Q?nKWSFp3jC5TjoHqzE2yp2CGk92EsSbc40uf1yNe0WVCstmAoWAwMhlzLyYYd?=
 =?us-ascii?Q?iCzx0ywWiZZx4TCs6HEfSR4jECTxTpytSO9R6BJuU+NNXfykdDFVWDc18l1c?=
 =?us-ascii?Q?rPFVKwSzc1tp1Kye/DD3oBb7/1PaescTHuWdF+BGaLjI7+56dqF7CcHvhxyp?=
 =?us-ascii?Q?zNSnwes+slkJh/v2Q4U+WJ0nBc7KLXgSgSFAMTRybg4IL2eFKnk0zCR2hlNX?=
 =?us-ascii?Q?T2MfH9ZhVVv7WTh79kuOJYZ/tLMMEsNn5UOEevBHzpzPMRjfC7owIE8nYdsN?=
 =?us-ascii?Q?F8ktb0X7eZ2Bvf9fxpg3sEsPnXm5ZkITcUZuhwk2nysFd3cd5M/cEt2hZmfn?=
 =?us-ascii?Q?VX3c7g7n+xKxeBefRip/vE9f?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad870d6d-c983-4f6b-1ccc-08d9155c7bf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 15:42:00.9078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ntC9U1pQY1wlX2xsp31ayKIbV7elCFuA9Mxlsa5ITlU2M+ZzrPgssTs/aoWX/yETMAKbi9ijWXnJcqIedt/5xAURVCWXjPytVtD8CuIYdqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2208
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Salil Mehta
> Sent: Thursday, April 22, 2021 5:00 PM
> To: davem@davemloft.net; kuba@kernel.org
> Cc: salil.mehta@huawei.com; netdev@vger.kernel.org;
> linuxarm@huawei.com; linuxarm@openeuler.org; linux-
> kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: [Intel-wired-lan] [PATCH V3 net] ice: Re-organizes reqstd/avail =
{R,
> T}XQ check/code for efficiency
>=20
> If user has explicitly requested the number of {R,T}XQs, then it is
> unnecessary to get the count of already available {R,T}XQs from the PF
> avail_{r,t}xqs bitmap. This value will get overridden by user specified v=
alue in
> any case.
>=20
> Re-organize this code for improving the flow, readability and efficiency.
> This scope of improvement was found during the review of the ICE driver
> code.
>=20
> Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
> Cc: intel-wired-lan@lists.osuosl.org
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> ---
> Change:
> V2->V3
>  (*) Addressed some comments from Paul Menzel
>      Link: https://lkml.org/lkml/2021/4/21/136
> V1->V2
>  (*) Fixed the comments from Anthony Nguyen(Intel)
>      Link: https://lkml.org/lkml/2021/4/12/1997
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

Tested-by: Tony Brelinski <tonyx.brelinski@intel.com> (A Contingent Worker =
at Intel)
