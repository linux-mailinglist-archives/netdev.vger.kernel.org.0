Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B22537EEA5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442264AbhELV5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:57:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:62957 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1391505AbhELVta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:49:30 -0400
IronPort-SDR: eLHo0CSDsCmIsMfXFecXSRQwUUq6SjqKS8+4wh8vlrDK2FxXN52lT5nRilVm4JZJ52akwB254p
 owHIrfnFCMIQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="261062425"
X-IronPort-AV: E=Sophos;i="5.82,295,1613462400"; 
   d="scan'208";a="261062425"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 14:48:18 -0700
IronPort-SDR: 4xOzcugXdt3uWlgi7ujm2HQh1QvPEsDB4ZAqIzc4jfqgd71lR4b4G47TfeWMfmQMoWm9AGknx/
 qt/02AhAhtuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,295,1613462400"; 
   d="scan'208";a="610109473"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2021 14:48:18 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 12 May 2021 14:48:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 12 May 2021 14:48:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 12 May 2021 14:48:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqgqiH3kXKLggoow5xAAWvWwuXloM7k2N36dNkIUyjo1ma42dd5eQ0I9+i8IC7FNmHL1tEkCE16VI/APupUdAhr1LJfiqIMTe29XswFlqGt50WifQeiNkWxzO0ntzPNqh6NOo6Ws+LLv7jRFzcEUa+gAYQnluv4wP08/Qn2xNxsmXjpcRFu1Zk+oeD71ZtuTonCozCCqYmxTIzX0J61t9DHARmnbsuCEsjSLMtT5hcPo//f0E7VrzCpuJPNaoX4cZLEUUF6idPQje1+R9SflJvoDRYg2I8OlOp7kT5UPzV04+MofcG+9Ksd7IVR//snodMxMIbRNMt1eKBfFY5eCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DcyUMlvj7liLPUeR+lCslylKB5cLu1RzMqMqDlTXnQ=;
 b=IzCBO+/JAaDexs7caZtzuO5A5u23XT5R0lsudJSwefJsNC1GWncC4w6tCFmn00ZCogwAODsvLDWF7ujbqIzYvXA2OLhSU55w4FnreyxoEleoUuXj68LqGkk0eh9PJHPhrWDNB8e+PZtRrfl+wy3LSv0FQyug6MzgPFSZLqJiV9qK4Gh4J789jb/Bf/g5Oiz4V2NmRWJI+5XDdiU3fFChFpK7sCgL+e0VQYogDeW4Pvvf4U5teo9wgXipw17ManFmChS2NmzkhYjfBd//naSSbUDCNug1Cwjg8+Fu8DUsCpgfG3SHZEOQQFZ+3SoavoBZiyU75X0gIMiRA8jxJwKGww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DcyUMlvj7liLPUeR+lCslylKB5cLu1RzMqMqDlTXnQ=;
 b=CPcdGpSkOFpQlDshwVoPCnPCcLFrUL5+/mw0sz+LcfCJrX1LccmG0DSVaOQALW62CX2PGouvpcuPc5ibZtSQ73xWZ/oOxQkt+U+htSNLqAX9tmI5q9A/m3nxnX/0LDDVl0yKA/82Bf40Cv2hGeTROyVnV2V/gsP55WYk/9JDe14=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Wed, 12 May
 2021 21:48:16 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::4db9:fe34:a884:4e43]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::4db9:fe34:a884:4e43%7]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 21:48:16 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     Liwei Song <liwei.song@windriver.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     Jakub <kuba@kernel.org>, David <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: set the value of global config
 lock timeout longer
Thread-Topic: [Intel-wired-lan] [PATCH] ice: set the value of global config
 lock timeout longer
Thread-Index: AQHXNP7Terxi6PVDU0yarXCQw89LCqrghrBQ
Date:   Wed, 12 May 2021 21:48:16 +0000
Message-ID: <CO1PR11MB51059B08F5B1A7EA207FC3E9FA529@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210419093106.6487-1-liwei.song@windriver.com>
In-Reply-To: <20210419093106.6487-1-liwei.song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60d1f23c-7494-47de-ac5b-08d9158fa62d
x-ms-traffictypediagnostic: MWHPR11MB1693:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1693DE1BF7E3149E769FB4EEFA529@MWHPR11MB1693.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V1Z+p4ZY1S0GTikcZYwvAltWynDx1wSiw/ZFHAZQopk0FZzrVt6Wro7jQVoyZb8xW3+YkAUGjHK7sFIzv1hDjFUPKqX7nRivLr6d9iggZ2wJ5m5dmrc9z2xyJnepYL9NSI0XYfaiTeMGiVrx5fVEM0GtIXXU1ig7EkBLc7cWETSs9Od6DFWOcmJ+aiVwoGWOFl0YE16n6yOXLEsummhCQHPDr4s9i+fUZG3Df4O8dSSY0atjhEXNgL13CNZoNRbVcQGdGczcpvoPCxGFlpgiCUt0KFhVB9k0zkJ4n20smERRSAiP7y3j4IYPrrwtmIVVhpw0g8eNf9PHLBrcVkfniPAc2CPsyHeBgfsA6YGgu5oRo6EYw4n6QavalVVQGJcBDhuFIIEux8pPle1YgItGOslYTSSuoU8QaqfUW1TMKI3Tzsk2dSduMTGuku90Zh+sRO9FJR798E4M5lNuVuCVgRVuq+VII2luv4f7l336wJv17i/PeiPVIcwDkO1FhcVuYIGI94eV4qsYFUuZ+FrU6idjxYDC2bLlEl0F6uenQB6dPtUeRKWWMoK3JgR8ix2kh7D4xrj+REo0gNl42VGcsOVp0N+kBN6GBTq6BhyXuqoycddKxykJ7bYG1D+qokKfCGWLM+8bvVp4jyWslFCElu97/ziRZZm8od6J1ewu0uc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(39860400002)(396003)(71200400001)(8676002)(33656002)(76116006)(122000001)(316002)(7696005)(186003)(66946007)(54906003)(26005)(5660300002)(110136005)(6506007)(86362001)(66446008)(66556008)(52536014)(2906002)(53546011)(64756008)(66476007)(8936002)(478600001)(55016002)(4326008)(83380400001)(38100700002)(6636002)(9686003)(148743002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?O+jGfnDVSMu+7QXhiBK+THpa4rNOylMCAk1+KaclybTFvP5OZJQgApMF8+J5?=
 =?us-ascii?Q?2v023asoD6s0JhmbFx9KjqLH4apzrdq4Jryb0jkyvt1LGfnG8dQzHdnfgQb5?=
 =?us-ascii?Q?ydoJcCTheWuHD3O/b//W+C29RmvrOu4JFMZMYq5c2kRkkBkmwOsIqgmjMuAm?=
 =?us-ascii?Q?/onsUyKy5veIbZktoGor42cJtCVH5GkAJA2kTwXNrrxFWpyF8QYfYk+3lazG?=
 =?us-ascii?Q?Oi+FlhXtDTMgU530N6LfJGaQ0V2CIF2TiQcEX+FqXffmfyzphh3KmAsIib05?=
 =?us-ascii?Q?CZWGdlSvXcnXsczZMLBmHGVJ5vLTlRf4+Iqdvkd4zSJwiXDRtaVKJ4W+EccC?=
 =?us-ascii?Q?4iyVoOgBgoFtzA3kdItVREFWmP65mUE67+xNLDGS2Z/jESV3pvXvbhRtoduk?=
 =?us-ascii?Q?6v55v140Qsr4TALI8f88IhnNElU8+ZU/ebp1CF8oCNJfyNa/5gHWQpQYaz6E?=
 =?us-ascii?Q?sFEvO1jmiyOykM0IYE/d8aKJVkESdlIbtma3igSbDz54DoakQZ6XZNfxq18a?=
 =?us-ascii?Q?FcVEVgr7Fo6hChDAgO/mO9ZWzR7IbCUMeQFPgF02gQxIDIClFYoZCH8PTiZR?=
 =?us-ascii?Q?3/TfbSwMcTxgXH6NCEWlOiyNdT0z9qMAIy1QMyIr80ccS1ve84MbgsctfKdp?=
 =?us-ascii?Q?J7hxJCx4tpHqOR0hlswvVl8s43Ui/hb3UJGoQEpsVpM/V4+R07yBwu4fVUHk?=
 =?us-ascii?Q?sjmZ1sOugIvibQAUUIpSaA/GmQ1t2NKym6pwTo8XYBqQHvYbBprOtIefPXkk?=
 =?us-ascii?Q?O4k5kcRNSS03fBIMhLJTIkTGM3N4CaFk8sPNLmO3wJBNvMeJRaaEiY9DP90q?=
 =?us-ascii?Q?USw07sYA4yoULwSVg9sXrQeeZlL1jRo9AE2nOKGK5ANpjDpLq567O+ZQpdkq?=
 =?us-ascii?Q?CMlhl325IjB6saiRqf/nPSQkYPb0KBxLdG+bKz4gmL9ijq4KQQnuy8HJ78rF?=
 =?us-ascii?Q?QhLC6ntVq8Ln1Tg8YDX0fa+RQzJpgjyUgOdDl5hIJghh1iF4UPjHTNP75BQr?=
 =?us-ascii?Q?lGFEyC+mOMUDNKZ4+eoLbutGMvyt0xARUj/yP0PMBwx2KDAxlS+WwdJhSN1J?=
 =?us-ascii?Q?rMh72J5O+9T/XQ9qLWUj1WIfQW5Ovtl4bubxaPB8w6Y7xkL0wB1VWjLrPw7Z?=
 =?us-ascii?Q?+T35WNy/r1lFHBqg336hR7GOPHiBjEBGer4IT1Gz5g/qt49/mWQ0dfFoKYCf?=
 =?us-ascii?Q?GHLafkYNkE7rb3Z++PRP8bOyt6+rxQ0sysKrsdyh6eXcb3hc5GM9zX7KzUCt?=
 =?us-ascii?Q?IrvtXN3BdNRlPvbTc7abrjF0kxhx54yaFdxdqO+Z2loNz7pbarnPkqAkrKLk?=
 =?us-ascii?Q?88jlSsnoSMwrhjdt/PJMbCp0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d1f23c-7494-47de-ac5b-08d9158fa62d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 21:48:16.0809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHE7X1SUzwwEBidM0GoO4OfspOBVpAhykvmqN7x6IYfMEKLAwLAW1ltFXgXAMY4JEkbL9ehYX/bNYZwOgEZG8MMrZetFTVFgtWxo0E3JHI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1693
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Liwei Song
> Sent: Monday, April 19, 2021 2:31 AM
> To: intel-wired-lan <intel-wired-lan@lists.osuosl.org>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Cc: Jakub <kuba@kernel.org>; David <davem@davemloft.net>; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] ice: set the value of global config lo=
ck
> timeout longer
>=20
> It may need hold Global Config Lock a longer time when download DDP
> package file, extend the timeout value to 5000ms to ensure that download
> can be finished before other AQ command got time to run, this will fix th=
e
> issue below when probe the device, 5000ms is a test value that work with
> both Backplane and BreakoutCable NVM image:
>=20
> ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG ice
> 0000:f4:00.0: Failed to delete VSI 12 in FW - error: ICE_ERR_AQ_TIMEOUT i=
ce
> 0000:f4:00.0: probe failed due to setup PF switch: -12
> ice: probe of 0000:f4:00.0 failed with error -12
>=20
> Signed-off-by: Liwei Song <liwei.song@windriver.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_type.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Tony Brelinski <tonyx.brelinski@intel.com> (A Contingent Worker =
at Intel)


