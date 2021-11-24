Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1969B45C055
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 14:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347246AbhKXNHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 08:07:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:34087 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346829AbhKXNFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="296077017"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="296077017"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 05:02:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="607182025"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 24 Nov 2021 05:02:02 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 24 Nov 2021 05:02:02 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 24 Nov 2021 05:02:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 24 Nov 2021 05:02:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 24 Nov 2021 05:02:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxLPmUFRo6awI/ArLypnMroFlbSEYYlimi9dPSmV28NfIRgBNUymD7ZrIpUrlQpnGGFQqQvmT45xQjzPvT1Uu67WRzspVsVmuimZFqfyuVYOARm+vXgKzMZ8OswD3ioIVQfPj/1RdcrRmUImCMjuTkzJsT6Y71B/hoT1k0ChdZ+3n4XtUNgfEQBqISGZCrMvCkKsh6J/xIRjXr+qCXhRBzaRAO5G00xR9ZyEdCoxsjExmhpzpAAtO+KwaINDTHYlkEKNCA7YdQ97Qbh8t1EMS3WXozTCf8GbFeKad0FFn1H4u3A5BWsQmUdKVfsE7worbWQp+thRjrdopVq7Fh224g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOeOHgeRVlkujS6y81GOGfk4iXQeVdSsgGZcd9Kv0+U=;
 b=VFbkjI/X/hNonc1nMP86K4ZmvOHfqwpge7emike+A/K2r5rjTC1YZ3sEemVKniNh2Bng8aJe2qfjAR8yRRfa9/C2UfCq2Tr1IntbfA2jb3CUF0L/oK66jJlkNr/Co6zRBruXJr3zbp9QKKzeIU10j8Gp3XD+PyJJDEiHkr6hE83BDoWB9x4YM6cyXNIP3T30j0IKW6APLPV9/WYbX1KmvaZkHIXPuGsL1JBXxPlJUYr8Bh4/ztLqYBNlsRgSt+VdManld/eWS5BdyQb0JfQh/GBF7DBSwX4EGgJXkluX0DeatbV49VDLBMXkh4+GgTl8YFtHwHdon1PSA0tA0nsSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOeOHgeRVlkujS6y81GOGfk4iXQeVdSsgGZcd9Kv0+U=;
 b=R9p0eON9UwrRd8OR3Y5u4zLpF9504CwUIuIPdK50n9lnr4XE01sq/IcgMxIHHyjtkXSxyNBY0Zeg/iiTHwlo3gWGc1WmbvYUtWVXc4ensXc4JBDVSeT1YdBonCAMxTsD1gP58I31znssASzHB/8B7hGBGT3FURKxmGfdyv5fhIU=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3205.namprd11.prod.outlook.com (2603:10b6:a03:1e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 24 Nov
 2021 13:01:59 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce%7]) with mapi id 15.20.4690.027; Wed, 24 Nov 2021
 13:01:59 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Jason Wang <wangborong@cdjrlc.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] igb: remove never changed variable
 `ret_val'
Thread-Topic: [Intel-wired-lan] [PATCH] igb: remove never changed variable
 `ret_val'
Thread-Index: AQHX2aMTDm3JzCi0XEunlaYyJbVHMqwSs4YA
Date:   Wed, 24 Nov 2021 13:01:59 +0000
Message-ID: <BYAPR11MB33678E55E77438B1B16B990EFC619@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211114060222.231075-1-wangborong@cdjrlc.com>
In-Reply-To: <20211114060222.231075-1-wangborong@cdjrlc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dbe4a5c-522e-4205-a111-08d9af4a9a13
x-ms-traffictypediagnostic: BYAPR11MB3205:
x-microsoft-antispam-prvs: <BYAPR11MB3205E0CBB6927316808A9B91FC619@BYAPR11MB3205.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OKrkUhkIMk+p7ea5iB37gWEGaMfmvMIvQD/dzR8qW9j+LEKXADLqeUFOPmjefZqLVJG3tFgEvqjTnT/2P8peGjlujOOlpRVuIsRBF4j7PKhck8g55Xen5m9tJQEDiqjyCT04iE/DtzvWkwbjgEeVcEBvhf5dT+Ykyg7rciXBxCQro/FWbwMTdYiLwnBjurlSH7nGehWrLPFP8lCRamj6dU7BwRSnoo/FfEQtKvtzM+MCgjj+65Zeg2YVxp/7pW2xqeWc7w/qNOxawshXXz5/oRDbFytu661jXqw4cOFGchONU9Bu0fmppgS9jGpyD4jwvCfPELCDCopHw7mAZvkSrmBJQ8R2+bi3QbjoORJGqNoUmFaBQ2JOyOAJ1EZshr+JfOkta8CBFDfj7I/7bYJJWoboJYPoPKKjaB8tcG7OFpoDHTla8lXxSxJ1TEDJtO3nQEnQ2h1pAe6tXOzM269w3oIs1LLckKZji4Pe25VgO3ahpsEyvzQp+SV9LcwxwXdtUFtpxYzi/24tPksL82bXUHFc7/2lLkSRsPjEhLNs2Mk7KrA9NQSNIUcMv4qgR0fDmL3pqTSCc5BFvytFb1M11HafyqS4FUrxLDOobcJilaE+k3cMduTsG9CpbAhc606ycDwg6S8/AgbQcKGk8ahCEnlQQGtaYzwpKtr5W8YTGpnTf6Zki31X/H0/wwHYK74DZjBF195Nn7SfcA5FR31Pdho8KMqmnlgaax+4C8BC/ns=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(66446008)(76116006)(7696005)(26005)(2906002)(122000001)(66476007)(64756008)(38070700005)(4744005)(186003)(66946007)(53546011)(71200400001)(52536014)(6506007)(316002)(83380400001)(5660300002)(110136005)(8676002)(66556008)(55016003)(33656002)(8936002)(9686003)(508600001)(86362001)(4326008)(38100700002)(54906003)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LjEYgCi5RO04MjshfgPz96vcnoFDxnNlyFVhVpjQdEhm6arDga/hoFyzAHe4?=
 =?us-ascii?Q?dB1INL8sOSGkUo385KoTGe6Wt9F4/mG6WInTNb0y7OxBUdUSzPoAjWwB4/cS?=
 =?us-ascii?Q?DzJlnnyAA7KJvRxXhWiGj7QtMczvEiL9vtv8/47M1ZkAIZ5I4T27iRpNKc5b?=
 =?us-ascii?Q?WFs+NMcrc3SJpeubKfzKqaVjIQddOJlZF2O3ZlIj3u/cc1lwp3gGeEMhKkFt?=
 =?us-ascii?Q?K/eubONJjFW6vrymsDX8CDYqW69LgHvIlvaNJYfr0ZjaRYV5+uM8iICXGVG7?=
 =?us-ascii?Q?w/9CKWWe0TgJNTVBO1JxiPXxt/npBhV8mrKowAkDlpW9kqza2w8T1Gc3viaM?=
 =?us-ascii?Q?CRHbRqEueJ4DZYzBgXbXc5Z9B4bj1c3hXVpU4NVwSAoUAWeSOjrE3fWxIr9P?=
 =?us-ascii?Q?YTcH/PplmFWkJv1IgrPAja7nYsLDqdaQjyD1sLidtzQnGFZ/8s50Am6zr3RY?=
 =?us-ascii?Q?w/chAP9CKvEbJSz9lE+j+mcd8E/RizX0r3VkoqleobTsfL6MqrJHNpx6HFih?=
 =?us-ascii?Q?5qiJarB6C0aoHj7L4fD/9dTnzAPduHbetnVt16X4GE1SUFKzx0+R+te/nWxP?=
 =?us-ascii?Q?vInzr/OEnUTQqOHsLK/rcgfJJ94vZT3Ef8GtJycngsTpQpyxPl2xkcFx35pV?=
 =?us-ascii?Q?OqRONpmmSpDKg/eBzuOGPZ/fKx9plv1WcdSrVhN6FzU0nXLcDAUzEuPss5Lw?=
 =?us-ascii?Q?NuujjfU567JGshKkWV7uB2xZMLn3l+zXhr0QR3fybHBVjMsq5zW9mgess+Ox?=
 =?us-ascii?Q?DY3iQxr4CIoJt0g7hOs/od73ygtXXuHROWpWeFREmE5aKyVl/8G4N88y566q?=
 =?us-ascii?Q?iVOkjsKXhxma5SBbcyUVfGDhFEip9NccU/YJWAvABJySQIjAqfuEv5C/i3e/?=
 =?us-ascii?Q?rX3XLHW33lerF2mJxv0w80hNji8abIRV6g+nXsEc4fu4RqVfzGeVAJTMXkmp?=
 =?us-ascii?Q?LwfVZMWp3zPHTCZFxKI0pblcOzkGowuV4J/OpnTnZ2jgnuq2f8x1q1c5AxlF?=
 =?us-ascii?Q?JiAj0Gm9BtSTz/BSpSsncnqvER7L851ZuXBJfD3Wu9vTcJV74hH88VtmAbmF?=
 =?us-ascii?Q?eDPQIm9iGP7QqFYgsMPn/3aAzCuoQhVFL+VvefMt/qhqCorF86taoI6WTZ8U?=
 =?us-ascii?Q?Y/ovhIOBVKWfZZTfKzxgFQXgSxMV6XTu/f3J/BFHcM4MmrNg+Axr3PaxIOyD?=
 =?us-ascii?Q?sARx3ot1BU7WdpExDQJ/vup7ivz6eCcwNh7td4pjZn9q8+AP4jXpsagoi7eU?=
 =?us-ascii?Q?AmxlRnHvIwxrVdL3WYhJGjJ1HhfDETLdvqDhEGfoWlOwHI52gzz+r/dhXosA?=
 =?us-ascii?Q?/4ApSGZ5+Vkv8xwF7ltbpqqTwWrzE1jMrrxMy4OSVn8wyN8yMzMbngcTn0iN?=
 =?us-ascii?Q?kRERIwrSNXASnJUdSAKorOlZeNOFvDqw6G8JtCIQxVgkPvPmjvMjvwgTIXvX?=
 =?us-ascii?Q?q7TJeNipVsdXn14XzRvL0lBa7z5ki9dPyNY/BHamcYSAyQCIJ6461hNtPd4Q?=
 =?us-ascii?Q?mN+luFXehCRtbaMxVH/Fgsl6iEMcuf62iuWHL/duWXtwDIKe5oDbuGpXJUMD?=
 =?us-ascii?Q?uapdj8RiqRXampraKiQhkzNay4/aJ9fH5aixEyvdB0yHF7lvjyToe3Kr4by5?=
 =?us-ascii?Q?CmyC9e18FjLUFWF2ISRaXA4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbe4a5c-522e-4205-a111-08d9af4a9a13
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 13:01:59.5605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nHP11bF/2/xj9N2aY4qMf7M6XO7w8z7kHBtakKvHC7A9rrobfzFv8EGAl0GIDJJXuLrvvTiO9gzfMbZuP+DH9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3205
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Jason Wang
> Sent: Sunday, November 14, 2021 11:32 AM
> To: kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jason Wang
> <wangborong@cdjrlc.com>; intel-wired-lan@lists.osuosl.org;
> davem@davemloft.net
> Subject: [Intel-wired-lan] [PATCH] igb: remove never changed variable `re=
t_val'
>=20
> The variable used for return status in `igb_write_xmdio_reg' function is =
never
> changed  and this function is just need return 0. Thus, the `ret_val' can=
 be
> removed and return 0 at the end of the `igb_write_xmdio_reg' function.
>=20
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ethernet/intel/igb/e1000_i210.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
