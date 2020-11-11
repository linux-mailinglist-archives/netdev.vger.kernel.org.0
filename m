Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC062AE82A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 06:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgKKFbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 00:31:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:25217 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgKKFbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 00:31:16 -0500
IronPort-SDR: CWw85/2yGlIxcUwwO8d6907xHblRwGRJJXmM1ycf6ZAZCOeqGA7puC8RcMqQBQybGbDywyi3vv
 PXYhxKPVrjIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="157105525"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="157105525"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 21:31:15 -0800
IronPort-SDR: b11KHysW+ON/LUL+CzrsRxR4I5omu6kU/ST1wfQSasQ7qUpDt6D9Eft8KxzGSw2bkulP9qzyEe
 jkUFI8iWdiDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="308333970"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 10 Nov 2020 21:31:15 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 21:31:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Nov 2020 21:31:14 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 10 Nov 2020 21:31:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBTYZjd1vYcvi29BQbLDWHnsnJjizMpM19f/UkDxlKqkJ3272r8dh1B1MZbK3samQPElsC1AkYVQlP1Ls7TSIy0/dP2mDOD5Sisb8DL+YBaSwpIEFrLAix7I8ymDBV7kJPuSiR6VeOhTMbbeGdpiCUKRID9yWfWf8QDW18huSnX4yGTalWjeyqY2nBNXZ7WLsJDT8pepH00Wh/jFs+3V/EcdHfPJOR8jjBb2ZUV+g2b7XUh9sRgo9SX8liMIwmrMKwEHi5JD1DWPsJTEOV3h9kSMFwcQWlU5PDaZuKE/m2j0ctCFGl3r3pAr2EnvRyZCnAYPXPdmzw/MXLmcyYRRSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge8/FP5g/ZNqBr8VgU0/POyqHkTG9zFqUppau0XxqDE=;
 b=EZkm1cdwRf7m6QoUEH6SEpA4bvZAU+4BvXM/p6e2SFuFKgsjUFGGupAa8LFfXxn+cY8nzmLGD1F14EY9KHGVC2v1KMcBNFVKox/WVDXfPkGroxcK91gHJlooj57YBbU2RpYM1/CUklUxV7r63IyaDCUx4UBWGefHlL8kPCiuORb2fvCRYhr5dagojLfzHC0Bix341qE3kggNiw6AYSIAADaaytILRnRJlCjqk946pmYgqMJxdZVqdZNxdRMn3fGHeIJkLZhGII+HoqZs/Jt4j516+dspIFcccd7Zd/En3SJ4AUg/K+lKfnF20IFKv2BSTNsxT/PGeUO6tZc9gnSxQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge8/FP5g/ZNqBr8VgU0/POyqHkTG9zFqUppau0XxqDE=;
 b=ozBkFcZXslIxPKhZFMrd2kcMreHyhE7slaxqDHvgBv5dauPSo93CTmIaCIvmjQTMlfOHPxHObYnytWpOfN7BX8SdQ4k1Zns1OiQ+viQHI7uOqn7A8GhrEMD4k5zS/znUsqIqnklkQt5nGvxEFOOMgGWo/8AoInVgAI6JIEfdZM8=
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 05:31:10 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::7dc3:6311:ac6:7393%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 05:31:10 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: RE: [PATCH net v3 3/6] igb: XDP extack message on error
Thread-Topic: [PATCH net v3 3/6] igb: XDP extack message on error
Thread-Index: AQHWpe67sqkMB/n9FUu8Pd4UYlHfkanCixYw
Date:   Wed, 11 Nov 2020 05:31:10 +0000
Message-ID: <MW3PR11MB45546AAC75C837E4C487873A9CE80@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
 <20201019080553.24353-4-sven.auhagen@voleatech.de>
In-Reply-To: <20201019080553.24353-4-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: voleatech.de; dkim=none (message not signed)
 header.d=none;voleatech.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [106.51.234.17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbf7bbd1-140a-4306-0fa6-08d88602ff53
x-ms-traffictypediagnostic: CO1PR11MB4914:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4914F0CB32A45DCD2F4B7AF39CE80@CO1PR11MB4914.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxrub96v9kqsW0ueEc5qZYZTU0fHxz3xqDRnLclmFTWlhA8WtrmNFx8bFOncQnfjhzIQpFKyFCCKMfJe9xyZZLNxSwvaVLcPpBjiMW29fWuR46JigvsG4MmBfbRCBCUwjYNm0AxaEjKr0mOQU10MEqK/H70HLWAsk0JPmvmbatl6pChJdjnr17XEv2Nbwj8J+sb5meL/W7Xc4GxJMucGGhVUzKId9euSbFvy6OJ26w1DItsMX4ReLap65zeBvr9T+sCt5phPVJsx4TVltG0RcvMsZsL0BmWEz7RAxS6CtNEhv1PnLN1sW9dWmkfM+jo3pS25GPhdjH9ap1miU7uGwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(76116006)(110136005)(4744005)(86362001)(54906003)(316002)(64756008)(15650500001)(4326008)(66476007)(66556008)(66446008)(55016002)(9686003)(66946007)(5660300002)(52536014)(83380400001)(7696005)(33656002)(8936002)(53546011)(478600001)(71200400001)(8676002)(55236004)(6506007)(186003)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UKf8E9TGFLLbOU6HBhWFdc9W7cVNYHWZ76TdjdQP7wZuOtQCffolA7sIBtxOGbO0/GwPoLLRTvQHNz3G9kqe5Wfj/RM4QKewPYzrCd0p24GGodf4FaeFMnjUmWd5GOPDWNbdKz9QYYqoiv06FdV3YAZAKK/BdIBXA4a81/6d6RXvTQYGUbKpB+gFKI2z++KLeZNcesyjuXelvYz+9Wc6yKOIfSB21iKjLtdJaDdi3hGWNCj+J7LhMit1ljjpw9rSuTn1l13InJoE4J/PPXsqOV/5W3v+R66geMonJvmiWSp9P+Fe8uoKgXk4MDeUp7v7O5RAEG4BHLtL4P/QVpFWumz+0wwaUs/d4RwjJIIjrhJ0z1iUuE5UcO5pDyShK8s7zME4SYXJfdSAmdkaoNwmkS2kXRVNkeCtUVC4TY8lR4AeGNorbwb2Ln9HpWXB4Now2FhN4uaEgb+SZphQbj1ImVQ74BiJL2EXaBxoou96RRxKJZKewWLOIXmBVDZky+A/629M1mB9Lss9WZacT3r1LrWVnPZH2vmV4O/1UAux0OUATZhYwMquXpbWb1qgzxKAl7U0nzFtWeTmhlQy4C31R4kVp0e88rT7U4fTTC2PCQNlW05/HtVvkU8xAmmDshUlTD6POs4G+kDE3hQpAApyVdqe4qegQSYYxPqjCDeGt+LCEagdVXDhnwk840BSi6UnQ1khnOFmW5bWutEhEoWiF3d7op19dKusuKxFpF3iCfmnNKpe+hbdh54IPoS6NZ32/x917yTbPTu1vZBh2SDXKUSQzWhHK0JOkKrQn62loAqDWPnOeIMZZLvzBpJUD4EFhAZDN8u/VfcCQXWPwnOCEA07g6WuSGpEAGM1FrWoP0EYEMKeEXgnydcODfOtCea/elsdELZgAKHWu8+4oT+Ucg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf7bbd1-140a-4306-0fa6-08d88602ff53
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 05:31:10.2166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xKEPz6+uRGTgAQtrsuELzOTeMMn3nInyRMM7nnWLXlGMsctzcQO7c4tP8+zLchqFdQaFD9kkzDsn4t9XPl6/Wq3FnDVWjpmKIAQBvgQ+b1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4914
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sven.auhagen@voleatech.de <sven.auhagen@voleatech.de>=20
Sent: Monday, October 19, 2020 1:36 PM
To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Fijalkowski, Maciej <ma=
ciej.fijalkowski@intel.com>; kuba@kernel.org
Cc: davem@davemloft.net; intel-wired-lan@lists.osuosl.org; netdev@vger.kern=
el.org; nhorman@redhat.com; sassmann@redhat.com; Penigalapati, Sandeep <san=
deep.penigalapati@intel.com>; brouer@redhat.com
Subject: [PATCH net v3 3/6] igb: XDP extack message on error

From: Sven Auhagen <sven.auhagen@voleatech.de>

Add an extack error message when the RX buffer size is too small for the fr=
ame size.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
