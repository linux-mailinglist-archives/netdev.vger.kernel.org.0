Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B849E468C92
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 19:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhLESQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 13:16:11 -0500
Received: from mga18.intel.com ([134.134.136.126]:27794 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231982AbhLESQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 13:16:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="224072613"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="224072613"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 10:12:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="542163733"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 05 Dec 2021 10:12:42 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 5 Dec 2021 10:12:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 5 Dec 2021 10:12:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 5 Dec 2021 10:12:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKM6XplHRWPhLriAD4ak9V4pNGNFlboMr7wgrCCkGn+1M8QLzZUBq8p5clqXel+kPjGH4HRUcmmsVtqGcnVk9pb7odUkhN7CkaomWgB1OVdLnVJyRdJSZ0TfXUCDey8OnlGetOwidV8dC5ul6XoxH5W0BABdrWhtMmSrG5zVZIcB0qZyDazDxsVr+yw9pPLFkchKz4MxJk1WbiYWudpiK+oCizRchBPdy9zMPQ1LggzMiHRYG1DC8iCbQuVPjX8oNkxpXK+oFf4B48ouNuaVUkv9U8wAH24KPvkLp0OX62VqWEmIIDWUS7TZ10YjVKNe+BhNHfOkfahwH34fmVbMIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sx1ZOnlopATn6UyHFT5Xi0o8JaDk5GmUf65LW+TB2M=;
 b=dVui23c2nR3wRGowYcXIm5QHhg8aPFh6I4j2KC2hvy0pxZ4ZTNedHcBNptOlv1xd4zlpJsu3npwa+ODIqEA1AP8POnPejWxokkZawTypWJwPM7E8ar4FMaRm1z3s2dvqQzhikl98VDuwzj1YKeVbE3BbMJuOy+B53YXxha9mpepvx9nOjcYreAylHTWPt2KpIZSLX4h4+3q8uVTx0ZzuZot3uiHiKb1cqzcKKUt+VSmkcFIIt0TU/x4v7oCl+UfgNesJA4b9EEepFmFVxdBAJnU4xHU1jiCqrZNRpPTK18cfEVEDfIg6EDz7wqltJY3Oz8iaYPHn+x4+WiGfmcVcbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sx1ZOnlopATn6UyHFT5Xi0o8JaDk5GmUf65LW+TB2M=;
 b=ojJ231OAcIrqrznFbeRhVKrJHCjfMD4QZlq4CVuOuWKUIPzrIRfZTKALe55YCiUgToet7N275CVXos+bc5rPiSmJSRe2TKaywz85NFiAmUlss3Fp7hGdm2xLMrh3NZg4WryNtkilZmKAN+6LNdkpQGnRUhgJp/Hac4KiUhBrsXM=
Received: from SA1PR11MB5825.namprd11.prod.outlook.com (2603:10b6:806:234::5)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sun, 5 Dec
 2021 18:12:40 +0000
Received: from SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::787a:2f03:efff:c273]) by SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::e814:a13b:4bbf:ef2%9]) with mapi id 15.20.4669.016; Sun, 5 Dec 2021
 18:12:40 +0000
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: mei: allow tracing to be disabled
Thread-Topic: [PATCH] iwlwifi: mei: allow tracing to be disabled
Thread-Index: AQHX6dpboJ3VcAING0q/5rZW+mljFawkM0pA
Date:   Sun, 5 Dec 2021 18:12:40 +0000
Message-ID: <SA1PR11MB58258B179D8ABB7738DCE76CF26C9@SA1PR11MB5825.namprd11.prod.outlook.com>
References: <20211205131637.3203040-1-arnd@kernel.org>
In-Reply-To: <20211205131637.3203040-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8594f6fc-6ed7-43f8-cc97-08d9b81ad39e
x-ms-traffictypediagnostic: SA2PR11MB4795:
x-microsoft-antispam-prvs: <SA2PR11MB4795AA9566A9ACE5A3AAAD6CF26C9@SA2PR11MB4795.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: om77fNQPg0gyuJO5HKIIB40SMFkaBuzYyKvqb0y5Shsuddt1aO3rYCdOoOjaPg94tV0CAJUa+VJQ/2ebz40wLVUam/KNCU7Kj7Rp3coxduVfrHjjFDnb3aAPs3nRAG5v2JDXb8DU2mnBxmFBZbthQ+kpmZhln869qX6jxD5LOgFBkE4YQU/YPN1InzUP+FBvk3wHy8djKAmuFuJ4rWddSeihg7GXnH0VupCPCiDpLbiDY6EifjHX8SG8605Mj6JqvIqof4a6xTB/JY/MFwfns8SRYDjkcE8cnrp87W123PdHJvg1TgoVZuPvQcG7PD6h6oh7wQwib20AGEZTpYG6x+wTvD07F3OWoS5p4zfXJujxlVxS6HAcXDYlL9tCxU06XZn9bJ6HHESSroO8mN5IYT8LobEHe3/KjDNch6kCSPt1DuTqp3QAorbETMT13MlMHelsKRajkygCSVlq2AQr1wm6TFpaShps8WGW3d/V+MgxicFTXOZjRY1GSay9KXoJTXIOs7Lw9quzC5/EbTkmBnj1RmZ3rtna1F9opjsbPmYPteuhj7LLRig4psHoT9xUdmLK3f6CFPdn/UVYvbvUUzhoy+0WpNqntajH41wlTrtfKcKvXQngHVhlWMPAphBHNkJJOwd0276DWE4wcXsBvxGIy0mMP8+ZZfKVDb+UwmuZnAcwy8543OohGaVRwRfou4bfV+6QMmxEcwdV4fw56Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5825.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(64756008)(110136005)(508600001)(8936002)(66446008)(71200400001)(6506007)(5660300002)(38070700005)(9686003)(66556008)(8676002)(66476007)(52536014)(4326008)(76116006)(26005)(2906002)(316002)(122000001)(38100700002)(86362001)(186003)(6636002)(66946007)(55016003)(33656002)(82960400001)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8o5UahrwUYgRpnb7JN1Ao+7/cafdDU4oNCK8d0sx8W/wFgzIRFUZtt2uVALx?=
 =?us-ascii?Q?1XBtf6fxq16nI71Xcl2k9kUIYPhdlhAj6yNvMv1iy92HXyGUKnDiHxHdGCp0?=
 =?us-ascii?Q?1j+Tza3zG8VjWT82hFStkQnGemU6L7nnJ9qSS9uQSRhRhQd5pAePTblhEDQO?=
 =?us-ascii?Q?BI7kJB1hLXxyGIlCt6qgzca8b8fH0UB/Hn2/7mUJ/RJeO1gUMlfcVC3DMPfl?=
 =?us-ascii?Q?BmawI0/P2QIaQcyMspNdZXU8FK5zz/Io8z6M/fRlyuK8HRjZz0qVeeWLpk15?=
 =?us-ascii?Q?ZmVVka0/N1RIrjiQmkrXRvRX3xgZKYOdkGAh8rm70A4GXNygTdXB5nRk6ZD6?=
 =?us-ascii?Q?XBf3SQluubL+PGdSypW8gDm2UFq6rbFxiH2LZoawT+ztIEold47w2nD1Tydo?=
 =?us-ascii?Q?lCyxVuM8XAxlkitFts+SPCawj+ebcIZv90/xROCREh+Q4RIzL7ugAKJenQqt?=
 =?us-ascii?Q?F08qAsQ3GFBCVVpFaIVk5jpeyCQvTYHMfQNdWfqP4PFORWH/rlxRwp2+7w0P?=
 =?us-ascii?Q?RpxFxFIO6eKZmsbyT+lRVkZYIfk8/3uHhqzcP2K6PnOHB1vw62ZVQ+DgWOVX?=
 =?us-ascii?Q?WPfhTEWftv0xcwv80C2AKTkNcg/sgdHyyTjgyoXeZwddEu9gBzYSszAJttZA?=
 =?us-ascii?Q?PbUElpWGFHj/JEHTLFuWYvFyGLwaWXaMFRaVROCwxxo08DA0dvpspzrARhrm?=
 =?us-ascii?Q?7iPmi5Z3uCZLol8GP7UJ8fsnaNewshovM79yxh9QWBhH6lYFmACAtXIyOiuu?=
 =?us-ascii?Q?ndrU6D8JuQRXEghqKD+5MiC7C24iAYdJxwwsDz54BYBW9alRiHcg33vmP3Co?=
 =?us-ascii?Q?vf9pi+9x7PEsJSEAPmsAgflBZGEuusipUG8faTqKE+vgHdwmG1XLXF6+dm9I?=
 =?us-ascii?Q?tJFPRj6yurUSiMn+tWsywXRiC5J88ArtEXCSe2IPtgCU+EkICrKLneg8Cr7N?=
 =?us-ascii?Q?e9txPtCSmiZBc0WSieXO2VZlP+njV9qVG7i/j/ROZDpLrZe+XmdR5WmMo5kK?=
 =?us-ascii?Q?XVMCnLQUruklu7qV7b1wODJ4WLqljCC7KOrjy1Wkct6pOyIpXzoEJh/A9NbH?=
 =?us-ascii?Q?8wBrpOpB1TfoPA1q74VN1z8MDgPFpdaeubKsa+JDE916uomDfoT7uwy7nRf6?=
 =?us-ascii?Q?ZL10RV9ZkURSJfoNoX4c66kx2Lv9mjQVcLrRtYvT449EoUnE7bdifKVs/1Wq?=
 =?us-ascii?Q?l7Y1UamlVzqG3xsdNHTcqQbWrDYwVK4P4xrVXIUAgsTfV3K1uLfIbz+kvic/?=
 =?us-ascii?Q?58vx8enJKa+jZwBoO9UCNT/jT7yfIbKsiW7DZvT9g90KIUxhD4P222aMEuKi?=
 =?us-ascii?Q?96XrgPJqxZfU/7DdZMqr9m9/37uHptKxq4J+vh+8AK/joKTXNtX4YxgdNWao?=
 =?us-ascii?Q?MmOoSHRc7sGrD15/DFcFqFh0KxGp0jVuSl0uwpjL3oY10BPcVHpoFd75ls/B?=
 =?us-ascii?Q?FM6bHLwQef3UwssK32lFo/mhokOXQ/5DKmxvfCybF/8xz/ptokmQ4+vwuuz0?=
 =?us-ascii?Q?/w1unh0FhrYvOmzOBEUY9wqutkFlkjYQ7sTlRG1VmnfIduPxTM85RhGhYJ+m?=
 =?us-ascii?Q?KQ7wDo7HLrsNblZmDHIZZ94fRxnr9oz6BqUIo6dpbMjnGUHCkk0izK5p3mln?=
 =?us-ascii?Q?k5hK12sHFMA7xAoWmA6se3fFXfxAfNbTlxhOWaapZRSDPs8cAO4Tw5ZnxnzR?=
 =?us-ascii?Q?p4MHkw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5825.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8594f6fc-6ed7-43f8-cc97-08d9b81ad39e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2021 18:12:40.6684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vcl0nZ8Tq5iKFdr3zG2iiAqYsBTT8/VW/8lCrFiBx+NI6a1oi99E6Ff1A1oBIczLbAIbSB7AIThobBsw2acTs/SOKlSw2gLKAQHZOVIN+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] iwlwifi: mei: allow tracing to be disabled
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The Makefile conditionally leaves out the trace implementation, but it ge=
ts
> called unconditionally:
>=20
> ERROR: modpost: "__SCT__tp_func_iwlmei_me_msg"
> [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
> ERROR: modpost: "__tracepoint_iwlmei_me_msg"
> [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
> ERROR: modpost: "__SCT__tp_func_iwlmei_sap_cmd"
> [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
> ERROR: modpost: "__tracepoint_iwlmei_sap_cmd"
> [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
> ERROR: modpost: "__SCT__tp_func_iwlmei_sap_data"
> [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
> ERROR: modpost: "__tracepoint_iwlmei_sap_data"
> [drivers/net/wireless/intel/iwlwifi/mei/iwlmei.ko] undefined!
>=20
> Use the same macro incantation that is used in the main iwlwifi driver to
> leave out the tracing when CONFIG_IWLWIFI_DEVICE_TRACING is disabled.
>=20
> Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation w=
ith
> CSME")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for this, but Kalle just merged a fix I had already sent.
=20
