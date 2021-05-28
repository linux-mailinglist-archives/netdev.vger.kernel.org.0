Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B78393C46
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 06:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhE1ETi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 00:19:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:15653 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhE1ETe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 00:19:34 -0400
IronPort-SDR: fgzg8Id3r7i0yWbsibT5FkuveAjyCFFgl96J7i89sFzsqMdHNNG/FmJgb1bOWPzRf+vdfK/B98
 dKKIOtqKB1kA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264085947"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264085947"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 21:16:50 -0700
IronPort-SDR: cmN6MOSHH6VinIMLikSrYxrMuo2jrHrijOnftYI3tdtczKAeNn9Go6HrIY/Vu+0M6BI4riru8t
 fw+yuFBUjuhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="443848585"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 27 May 2021 21:16:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 27 May 2021 21:16:49 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 27 May 2021 21:16:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 27 May 2021 21:16:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 27 May 2021 21:16:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iY3c1oWSKd+FnWFvg4H0RtX8FRvDMyVEhRjy95Tad8Bdya6Afg6hKnOEU3nLqlD7mjfYUi7gCKqi7ROLunwsHy7GPtc8Hau6T1dnFWoSJfuB+cE9zBixL1Gnsxchyf+kbsVAFhDUTILKj6uu/91ZWgtnQpEcHg+verIhNVq5X59OGN3PWcCQoILwTh1y4DGSWXuLKJae7aZKTf/p2eImCv2AFFELGolO5M5wJp+bYOws0PS8h7885f8TaZgOVhP3oKbuYVMqEbasxhfFOqa9cLU2XPCXmFJwerNwujflb8Lq5G7y0PLyAR7yQ7n7RSiUmRn3uIJyul5pKWEeTh1RJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPEUEU/k7XS8A0YEqe0BQCFgHGFsjAWtW2GPub0hZMA=;
 b=Iwxr9anylH/GJPJsWsAqBB3m+rytqDOKBnYl6H+r5MaWHnMonw1kH7GFR8BDhbPluuxXcca1LrmYEOSVh0uM4Sm7pdPWd49N4yVzCTdZjFhandWxXXpthc6UQKwe6SU4w2RD7hzRGGfUTK8HdFrQGenpMLZwYjF0e0E86zGYRuRzSq4jaQhLHH80hxxEU9egbM/pr4bhwMpXrlJcsP69p7a1kvaSsBh/1lLGFZEW+ZdVXSyTqONR5QjNZwgedfuuy0UBpFrNPSAEOd3bQ+iF27tTuDK/pHd/VFnjAdnPh8lmMjAD/fRAYeKAD4pIGzLmdTzaZCZ77/L7hGr9KH06tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPEUEU/k7XS8A0YEqe0BQCFgHGFsjAWtW2GPub0hZMA=;
 b=PhfDCPttmQDshmk9ha+2bA55e/ecUnZb72N8qv/MeoerVbB9G0G1DbFD7U4pKd0eCtu5Q06FYotYAF2ZmER69OfxhtDkGG3oR0/oNLZ14KkzRtuhjoglBR84HahVZn4BlGZN1Nnkh1CGPBrCnXOSxHHxoPF6Vcof0fLnxYKMzn4=
Received: from SA2PR11MB4940.namprd11.prod.outlook.com (2603:10b6:806:fa::13)
 by SA0PR11MB4624.namprd11.prod.outlook.com (2603:10b6:806:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 04:16:47 +0000
Received: from SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::2852:d6e4:3f0b:b949]) by SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::2852:d6e4:3f0b:b949%7]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 04:16:47 +0000
From:   "Jambekar, Vishakha" <vishakha.jambekar@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net v2 3/6] ixgbe: add correct
 exception tracing for XDP
Thread-Topic: [Intel-wired-lan] [PATCH intel-net v2 3/6] ixgbe: add correct
 exception tracing for XDP
Thread-Index: AQHXRYBsCAjqVYIOx0+WyyjLvif/VKr4Y+Qw
Date:   Fri, 28 May 2021 04:16:46 +0000
Message-ID: <SA2PR11MB49400C2397D9B13A1BEDB54BFF229@SA2PR11MB4940.namprd11.prod.outlook.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
 <20210510093854.31652-4-magnus.karlsson@gmail.com>
In-Reply-To: <20210510093854.31652-4-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [150.129.164.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23dc4241-b00d-4929-ecd1-08d9218f68bd
x-ms-traffictypediagnostic: SA0PR11MB4624:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB46240CEF72DB16E2DAE83CE8FF229@SA0PR11MB4624.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P9TvuRRoxFH5T32V0xnGLC4ms8POc25nKjeq2cJFJtzirIf9yzUQX6/uzHbpc8RLYW82zGz3LOA1+IKNK/hWLGj8PRUFSDGvHE/1HfTr7gqspadjS03B92J3veeygkglcEASVyxL4j37mTADTHOtMvz1E1b6kjI+3nnl2aBJuJzLCkB8Dv3D2NTav1jSaATZ9N6dOiYopACu6grgVvE5aCL8ZrLEyscB6iY75zfGYJkTUak9+A9aoN/GW6NrIYgurEHGCNOz/04cQm2UgaxcPrs05GD7LY/+/UI1y8/ObFOQHpp3Y4vUROf77G21MFhcSi4yafC6xP44Zi1+8WMi0sxZ1APxxCwgIWw8+mz7VFcJhjM4wvvO26Y5mWHgjrs0l31B4a8okLY68rJLegt3Q3t/lvFL/N/TtHjailxLRUj47++C/OU1Gt1VGjCKyu99S1FaXfgcAr5eAwukjSS9EdWTurgmlNk4XsV1VIiWt1WLnPXQEiDd4/wETwnUl9/WTpWNDFywy67p4g6dsGYsrueqptDx+f3BVDU3lB45JR1yQ+aOX6INpLszefq7/y0z2aYT3tQZMN38oEz2zqWmCnky4PcqSl7QqyLpuPM1/2k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(136003)(39860400002)(346002)(64756008)(66556008)(7696005)(66946007)(66476007)(6506007)(8936002)(52536014)(5660300002)(9686003)(86362001)(6636002)(186003)(66446008)(33656002)(53546011)(76116006)(38100700002)(83380400001)(55016002)(478600001)(2906002)(122000001)(4326008)(316002)(71200400001)(8676002)(54906003)(26005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0wIsjObwJF1Q45YxAHFBsYUynhrSpZ/yg3LB28qmauAYbGDW2bqdghBwnki9?=
 =?us-ascii?Q?PjgWQsoRun2HE9JH+ZunxaoyQT53P9EFW9Epq7U36Ux2vHrLVjkNwUBq7EJL?=
 =?us-ascii?Q?1cHwypjKhTZnO576CAANDRDVLmgOCblu5KMLQ4J+yr0pldHunIOrEMOM+Z7y?=
 =?us-ascii?Q?xnxVUgvSoEDfO5pPfAdkMFZXvmAF0WxUyOE03EqKRXenVDQEqrFcWwFs/EgT?=
 =?us-ascii?Q?niyJjBaeKafKhustuauaWyLQyOLJYVBwDNquaTdrc9dj8uSJHFEL6Dw4RaNB?=
 =?us-ascii?Q?R+1YWbgI6Fevf98JdRt04vHb0CYbXHWzpBXrIW3BfmV+N+0jzgk2w/6G1j2H?=
 =?us-ascii?Q?FflGCCTxDE66hBY27ckokjAQqkbt+7TX1lwJJl77Lpi2LpweIJcIc5+vu5u2?=
 =?us-ascii?Q?CM8Po3h5DSNof0fYXxr5uILl9pb9OXJNnrQn6ehQNGYPW3J8ow3ocUsYE2mH?=
 =?us-ascii?Q?ZmVeV/kT/NfLqx1b0l8CP2lw8V7P+6nwA9x8xmmSov5ljD37VbX5GVTCK6x0?=
 =?us-ascii?Q?N8LuHt/adlJ4vxMKNRTms4EjqDm3/pRlexfFGm9Q/f2FYl1gz8n959RtV/Qj?=
 =?us-ascii?Q?T940cZD/V+bm7J+ZQ5v+olXLuOgK0RsyoVNrbTCZlJ168F08fWo4SKNFbMZb?=
 =?us-ascii?Q?9MiGLKWUBXOFnyPLHO1MJb+hE23Zv4+yIB8h5IZdAfTD/JEBNrHTitw30kl3?=
 =?us-ascii?Q?dKAxp3s20w86sqPYIP+e4NpYMrAG5rElfRfulPoLrmbOygDSEofOg5uXbwHe?=
 =?us-ascii?Q?7oaT11kRPQ7J3UwiIAL3YSrrPKNGO0AzPa0BCPKh0CAAiqHZ01SqtqWjBG9t?=
 =?us-ascii?Q?5khgyCi9wpIIQgDwVZlZFWC43q3b/pSHRRww7LK/BetYOkrl8I7Q0TpCsHN1?=
 =?us-ascii?Q?yqS3WVyuhTNCzuXQZJCEIKF8ZkKygI2r0c630j3JrI5zbl1leP5alIkoa8Zy?=
 =?us-ascii?Q?JQvxI8ijNZCURI97g6Sz1NmNqRz48Q8iGsj9s9kWYKfdgCIiZ5ds5XneK5Je?=
 =?us-ascii?Q?DmDIKlBajRnrW+pGCbgthkFWjRiujJijNDj+NKi/yt+zIjltmd8CGj7Q439B?=
 =?us-ascii?Q?9dLWCQEh4Z8f/bE92LU67GzzG2Hatl69JuJpeHxIo1fWhdjFJxZVyu1u/8XT?=
 =?us-ascii?Q?VFDoikvsx9D/5lIVbID8PCj9nGU2iYaKK94kVKtyMzzhoncVaz9qn5FS115r?=
 =?us-ascii?Q?tivnF5Y3oSJuw1rQWdXaHL0+uP7IGaFSXLMR7xdMc+i+8bDO78CfwDet8lzW?=
 =?us-ascii?Q?x6nFhKCJPgKSG/X2kOtHjh8miDJDY1+B0CXxjzma4CuCYRs7p9+/Jt6zsCdN?=
 =?us-ascii?Q?HqRh89B8FoSBp0TWm8250dc7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4940.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23dc4241-b00d-4929-ecd1-08d9218f68bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 04:16:46.9947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4QFD5/CYwjDHzoL4tgVk/XkvpkCFUryg6WO5gywyeMgYSPwCHvCQ47E4ep2cGHl/oxGrHK3VgARxAa6owd2txMBMsWC0CUO4wYr+GNvd12c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4624
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Monday, May 10, 2021 3:09 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; intel-wired-
> lan@lists.osuosl.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; brouer@redhat.com
> Subject: [Intel-wired-lan] [PATCH intel-net v2 3/6] ixgbe: add correct
> exception tracing for XDP
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Add missing exception tracing to XDP when a number of different errors ca=
n
> occur. The support was only partial. Several errors where not logged whic=
h
> would confuse the user quite a lot not knowing where and why the packets
> disappeared.
>=20
> Fixes: 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
> Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 ++++++++--------
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 14 ++++++++------
>  2 files changed, 16 insertions(+), 14 deletions(-)
>=20

Tested-by: Vishakha Jambekar<vishakha.jambekar@intel.com>
