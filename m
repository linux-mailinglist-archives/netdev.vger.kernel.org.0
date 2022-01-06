Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F57485FFF
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiAFErD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:47:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:34836 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231971AbiAFErD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 23:47:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641444423; x=1672980423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aoMk7GEG4Dkm9eK6hrZczUMF+TRldly1mF36m38KnKc=;
  b=G5kcLXiZt09OvDs6l/aBfaf4q/BorjAkeShMhQ9DSZbPqcFw5/dYhyZx
   JrKYQK57QUdbwJmqgUXbIkBTksFM0ACBShp43IJofaQ1NucmjzCRhKw8d
   IgT+llwhMfzcdXUF67QX/IxPaB3ynWYdCOARM3kEsoXuyYDwdS/KA8GUs
   WSTc3DEiNVbm33yoyX9vpOA22gZwNZk+DDkXc7SgqYswxbqTN9HsGrwP+
   BwpUYm7zh4rTBPhii17S9v7MSzBTES5uEtAQEEG+SB/euZuCmgtPx6zPY
   qarHSNm0KardbDlb2SnzrvJq0hqa3eGco6R1/GcfkGekPjgfEd9DIHuku
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="266875296"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="266875296"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 20:47:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="556801611"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 Jan 2022 20:47:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 20:47:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 20:47:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 5 Jan 2022 20:47:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 5 Jan 2022 20:47:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilcbX5IHdHwjk9UIlfijM7FJ6z4wAO7NfEmBUiHihvJ6nKi5m+7me92nQ9JFq3tFhgxF/izDOvgsNxjgtDW51h7Ta9KApIA8lP1ht9pWojGkH9prlky3Rcwr9tZ54lz+fJ7rrdIsPbSAWoc1yDqa+MbPya6E6LE0Hme5qO05JpdzYzW5eg4XyfbDQCYUXi+B0yfWYaMfu4poZ3zfcmWmKGRi1a1psbV0Z1WyXMJT+/EXUgjeKJbcSMeDotpg/FC4MGdKaVpMub0YxmkePk3aBxRCW0qpaNUwweTHwJ4v19EGfSKlGjERE5ehEK1U+CenfOVY6lG3DtXyG8bdF0j90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoMk7GEG4Dkm9eK6hrZczUMF+TRldly1mF36m38KnKc=;
 b=fkgXQRYcYb1vON16Rzrej8b6H1jvu3DKg56Qt3hRYDHwBYTdnQo7K7buCAM5mHkHgboV7TsoFP11V5eS97o8ClWvAX+ckb+mIZ7c18kcM7xIyA5/mhvl5GvITz2+1I1hiQLLR+0hP9sXWsQBiyM3GrWLkQy4JO9NjhQ97+Ndi5HWRDhdGrXVmx4dSm0ZGgpetqQys3SSD8mx1hHTJg0gsa9tO1OveX4Y4W6s+sAlXRsGHS/iGHnFWSPWKrYdOScQs/5assJOq8EgQHL5lfxhiSdaU91dCiqTf87Cjn3TnkTJ5i8Xbrmwj615QgxZggjzXXSKRRw5mPkSDZsTeGcF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by CO1PR11MB5171.namprd11.prod.outlook.com (2603:10b6:303:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 04:47:00 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::42f:73e3:ecb1:3b75]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::42f:73e3:ecb1:3b75%8]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 04:47:00 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Slightly simply
 ice_find_free_recp_res_idx
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Slightly simply
 ice_find_free_recp_res_idx
Thread-Index: AQHX2/k12szPKuN+O0OywKu54W98OqxVuKJg
Date:   Thu, 6 Jan 2022 04:47:00 +0000
Message-ID: <MW3PR11MB4554704CA84792B1E75110E69C4C9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <dc5cd04eed7dd3100f5860acaa995efa40ddecc8.1637183999.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <dc5cd04eed7dd3100f5860acaa995efa40ddecc8.1637183999.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 594d6074-fd2c-47d2-68f1-08d9d0cf93d0
x-ms-traffictypediagnostic: CO1PR11MB5171:EE_
x-microsoft-antispam-prvs: <CO1PR11MB5171F28AFE559FA72D1AD71C9C4C9@CO1PR11MB5171.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: adD5wqfhD2rWyGYskwh5UXDgql5QqZXzrn25/5L8L+H9H+NPAKyY0dPdEQroh3CEoMbhEJONBcbIMviM0uYRzPyMRSIiSDqBu5YxIbGqW9hdZhB9oN3sTZqyrU0H0izPEsfaHQd72C7RoAeFsGFesViXLSnGK9uCa71g4dzizWTF4trgs02ewI/7gS7C1l660T7zRoUK4kyKDBzyyZlAcq30Qi13NumOEj8umKVwc9cGpt0T+eJeR84FglIj0EDmyxdmqq9RcEQHM5ohvrxX6OT9FiQqUgZ2T4ZKlQ1dzd8XbjmrVOKc5yJmyXtufONi0zYJiTD5VxmDw7ywUclRngCLdogrmaRl0O2HsC9S9RZjOHldoMGhXHGm0b/Xqbn0Z19RUiQb6gv1rzExGKiwDN+ZHboDSTL/IbIo3LrFbnFzjoUvbKOWx3Zftu31y0adxIP5GNqau+EYP1zJ2tASnuh/HglMGb4vjmErqBA3yiWesStNdq+T0dk46NqQQyd+LsCBbdp3S2rZNkeNvKaT6xbACMRZtIcbs3XQSqP0MAuxFfi387cE7zQ5SC15nyaG1ErJib71QmqKz1XSvz60M1tc5HDuKaldzu/EiC/vm6Wc7oXp6u7vA7nmjmJWm/tteEYmfkp4usyvQMlOoaoNbQ0pB1lS1Z0ZBN/xTgCTKcvQPCJne6fFgxPwX6Qo5mPqxKI9XktIqDVuw3ah12WDfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(6506007)(52536014)(4326008)(86362001)(5660300002)(55016003)(2906002)(122000001)(316002)(38070700005)(110136005)(9686003)(71200400001)(83380400001)(66446008)(38100700002)(66556008)(26005)(66476007)(508600001)(186003)(66946007)(76116006)(54906003)(8676002)(8936002)(82960400001)(33656002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oU6TtqnUQPdOHSoHxbXDuPzWwlyhASxDgdu5ptRE4bfq033ZSnxFUHdkDpqs?=
 =?us-ascii?Q?n44j4H+MaVVJEgm8M4ROkOnhA4J8BOqhNhPsWQ9Vy9qIA+nRFGGCrHRFYgBX?=
 =?us-ascii?Q?SYq7LFsEOcSaQpB1T4ZN4jup7ZiaZLuYDYXDQtjSusknUVUSkNiD4xBN7S91?=
 =?us-ascii?Q?kZzNH6YevYFKKz4sEMINzYjSE+i0JbBFhBF+lWZ9FNjXmiNVxauLIRlyh2qq?=
 =?us-ascii?Q?9jqMKMzzKM08owMvOFeyvhEU8aSUup5/cQOcRTsLylf4K/alszHqRe3XN3O4?=
 =?us-ascii?Q?1Uz2HyTEjbxURKmxAn+2Ww/gtKVc9hlj50MA4UW+yHGxPJBuj/7KX8vAx4cE?=
 =?us-ascii?Q?TngRcdJNA/rANlu9VVwrteYETWAz8VAL4ZrXbp7C9uQCniurXVw2RP85RfI0?=
 =?us-ascii?Q?gJlaFjuI/RtTd1esiZZRPKV3sKLEjxPOskOqlhOyLLcbVK4iNAo0+Utbf74w?=
 =?us-ascii?Q?L1RPUJYU9/ygy/k8ncCGmUjqAwnEHOoU8Edp9rYH512GYR1HyMFZqd63QPpq?=
 =?us-ascii?Q?mWLFFXLtvn60MJsxJv58hL86A7OPAuz+E1OZnbFLYHN437Y4Exl9f6SoV7Qd?=
 =?us-ascii?Q?pK2ytXDdhrcDWu2lhP9dwnc93AVsGeadIdERn2hLV1jRIRoE89kRumlSCmzN?=
 =?us-ascii?Q?N1ww2YOpf4x4QPRudi7BMKz2gBvx1cNVsICPg5rs72vAmvZ8igjQUWUl7Rmb?=
 =?us-ascii?Q?/ZuO/W7TMJpRqtO+dXyljwsTr6BF3IWnv1NigPYMEiMvsUtV1ZW6SI72S20y?=
 =?us-ascii?Q?+whi/OwEtKqvYw7xuGNeGlyJtstGHdyw44Nd72/fFn6TZZa0QPl4I8HUamno?=
 =?us-ascii?Q?QSwpD+4AWH1ZzpGJ8OEZDgD+iAsT+JB5SmH1nZDvuo/4PbmrnltuZhm6H7lJ?=
 =?us-ascii?Q?wyiUd1V/ocjrt6rBk+lbLvdBJIPM9TVxH/UXj35RT8J7yEV3BV0BqfkGAhE0?=
 =?us-ascii?Q?UJ4L5YRoUNzGTHG57ruwELaEy0/um2YwWkyTzO3nvRylE2vlDMHhN1RP5AZb?=
 =?us-ascii?Q?VhgNQPOm4vxdDHHtfDKmfEKa8RlgnlnBWPjtGMWl/ZXyV0im3OosymQkaZ2X?=
 =?us-ascii?Q?cqGO4zfG9XV09dtjUI32bvYSyfYRsEyUBAo6qvsPvWUHXbzFvY+RriB9FRT4?=
 =?us-ascii?Q?V2/0ZBEwnR53i8RJaahMDBLmjcw47he6oMFFbzBvB+U6jUGcHIgwBkYFtSXg?=
 =?us-ascii?Q?/J4x59gk4ACPRJ4mV8byFY09B72vZPCBpTgQEBslRa+Fbd6eqNdiwZE4FiH/?=
 =?us-ascii?Q?AgtQrB3RqG4wnwBq4Yjzt6zqodEwyVIuxcmhE0hVUhhfhln3sknmmI841rhJ?=
 =?us-ascii?Q?nJRGJSX0ILebivLAxU9qkoj10r3lWRp9cGm+IRHn2nIHz4IzYHHk6bcz/AG4?=
 =?us-ascii?Q?/U30dchbaktMdYIYBnCJRH0MIKS1yx3nN9acd3QZY6kd1Ol0G1VArM/qL497?=
 =?us-ascii?Q?fnu3fcRkTHm/MxuLXgj7dH13b4qnrF50rOOwXi/9P3ar52nP6QlwnlPRp57E?=
 =?us-ascii?Q?q7a9hD5Wj6sWcDL3qChaO3RaiFLAP86LplKuXCto/kCrYvYyTEcKYPscX2n5?=
 =?us-ascii?Q?6p+aJvjLlZH2L4HnvxJnQWXcpLU7USp5dAHJKqltTbHRUtFcerT+7FZRcEqd?=
 =?us-ascii?Q?gyCwcP32Rfw10tqQX7wrOx2slyYiXw7qxOe1YZXrAXh7/QQy+Og0fzWS0w4I?=
 =?us-ascii?Q?Cu6CHQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594d6074-fd2c-47d2-68f1-08d9d0cf93d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 04:47:00.4946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZcFPnGUNwqN5byEsUiGx6m8cgEH3KuJXEWCW93rt/1SToIooYO5GMokFWk512K/gOtToiDkF59Wt8u7Z9T3q6fYX4IGXYPBOOPLfTxGXOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5171
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Christophe JAILLET
>Sent: Thursday, November 18, 2021 2:51 AM
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org
>Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe
>JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org;
>linux-kernel@vger.kernel.org
>Subject: [Intel-wired-lan] [PATCH] ice: Slightly simply
>ice_find_free_recp_res_idx
>
>The 'possible_idx' bitmap is set just after it is zeroed, so we can save t=
he first
>step.
>
>The 'free_idx' bitmap is used only at the end of the function as the resul=
t of a
>bitmap xor operation. So there is no need to explicitly zero it before.
>
>So, slightly simply the code and remove 2 useless 'bitmap_zero()' call
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>---
>I don't think it will make any differences in RL. ICE_MAX_FV_WORDS is just=
 48
>(bits), so 1 or 2 longs
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 2 --
> 1 file changed, 2 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
