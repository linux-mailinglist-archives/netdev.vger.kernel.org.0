Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0870C5B6CA1
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 13:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiIMLzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 07:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiIMLzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 07:55:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5815E66B
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 04:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663070131; x=1694606131;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oqfo2ALWpdwpXCfE4HO/kD7VYW2aox78ZSCWEeCGbP0=;
  b=AULbcwvHAzRqXYqT1SUk01g+t4ieHeTHJhpKufFerHIao0wR5zP6MgIk
   F1GEH5DxBkO46vT7xI9PK4wgAF8hnuwt5xeLd3n7TUgSk1h4XPFexceoq
   gLl58jiQHI1PuqvnYnbJMjnzhU2vAPfX9i/gkdxrREuMZ8U4L5e63bhe3
   Uwt/spRDZGDW2l7WAS119rcJ1WQwtWbxwfrDgTay48z5S91Q57QbNT2vu
   CqzeKxbH8IvDikjqkKPFxKK5iFsHqDPoI4+F1ln63He4qDEwFE85ZkS5h
   Cxga1cV4ba8t1ZrZ0ky635W4GEkMor9Z9eV6WCAvNtj+PPQFqIvDw4UKB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="281134971"
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="281134971"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 04:55:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="616431995"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 13 Sep 2022 04:55:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 04:55:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 13 Sep 2022 04:55:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 13 Sep 2022 04:55:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kbnc6uYqKyQZcJ+yb/iDcWy7ePAeO1YNo5MwT1Yetv9FNm0MWpeyZqhw1yngKo3YQ6ZVJObmZZejhOARIpUkWntuLeYa5S0Y10x+F7hsY4NdHYtM8xVhv0q1T3mTufRui3Z+9r7NTQ/CnY0pNG8Kyh3urijnR5l9jsrAyPxdQV1iOHo2kPiLidxNftojlAYG+/0ruLMxz9M9QxobyzDI+6jjw0xqGzuWq4agGi3BCNV9/fgo/CCPrP+XM7RN/PGhNJpRhpXwBpY+iueTg35vxyZG9L5++A+9AUGrQTe6J5uwwtwkenr4PIECgS6vvZ0gHurEmwW9JP0Pd5kNTBOm/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/VMHluASivH1PSNz+/YmJAfjUkVaQUJoUcLHfyDy5U=;
 b=YkrgSVYDix12wIxBaBbOKspX0RATsqZzrjiAAgxH8KFWghlyZ1TzSRnsmTmxtWP7KMmScatIOnuzZpu4+vv4HMC/1V4wms0Lpm2KB1gxIK7o/P3JdtUWRAkpd5r12JWwd6XjBdH+m83aINklA1GZpUKdMnvl1QLRjCgfrjz2aYtY1nS1Ir1dtqF7qzwZ/P7dr3rYLUs7vVLFbLVTzndsgPsGVF0Hav8WSPAXNuE84Fh0E7uaii1UgQQMRbAPY84K1mIwdd0VrqJ7vZO2JG+AuCkdVwZA/hx9Y88ABVFg5zCnyKwflmk8r2Q+lrNwnUk+tk5DhJO3cNvcm7p2v2Qmaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5611.namprd11.prod.outlook.com (2603:10b6:510:ed::9)
 by MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Tue, 13 Sep
 2022 11:55:28 +0000
Received: from PH0PR11MB5611.namprd11.prod.outlook.com
 ([fe80::44a1:dd85:8d3b:56fd]) by PH0PR11MB5611.namprd11.prod.outlook.com
 ([fe80::44a1:dd85:8d3b:56fd%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 11:55:28 +0000
From:   "Staikov, Andrii" <andrii.staikov@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "Gawin, JaroslawX" <jaroslawx.gawin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net-next 2/3] i40e: add description and modify interrupts
 configuration procedure
Thread-Topic: [PATCH net-next 2/3] i40e: add description and modify interrupts
 configuration procedure
Thread-Index: AQHYwjt/lu/S/S0+RUia6ZaY37kXqa3dSlzA
Date:   Tue, 13 Sep 2022 11:55:27 +0000
Message-ID: <PH0PR11MB5611B3C60DA630820565ED3685479@PH0PR11MB5611.namprd11.prod.outlook.com>
References: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
 <20220906215606.3501995-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20220906215606.3501995-3-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5611:EE_|MW3PR11MB4602:EE_
x-ms-office365-filtering-correlation-id: 70898b6d-6fe0-4832-6d87-08da957ed9e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9Qf3gJ9yI0pQA+Gn9ooC/mkwZSuyWL1Awcr7oZalX5CfTHaH9hjFYF/dNw5x5XqoVBX5XEqU1p46gBbY8b6f1k+Ol1BHwMK/NXcMh7yXuA2B3JfRH/Ckk70nedkn4O6BnP3BwfUmpVo2PN0TrOgu2OHizSk+Y+VizyuSxH0UVH0nM3TIVXXXrwvPMtyb71AmmzviQLutajd6i3KAi9lqx16G2GdpfLIe7Ie321qUxuDo7ZoS6RZlOlLKzF6AFS8FN3g9JUB64jY7hZGy0OMYpxp6jYEYcX//36ygyfs+S0uCjGQC3vUsO/GfrntWvTBUSv69fHxlrggOPSiSQQKSsevbJAlcsKWvwRq0fYmiPz+BXWANu2m77a1Ut//0cbfy+LvtacrT/kr+aQutjntlCC9pZVthYvDfpWTFHM8lCKP0r6n0XFk+7Qgv82HF8GylPPsqBHIc2SXEmSPXrG3wQZRTCT2AdGaUoMcJx7Zi72b/Hvbaf0koKYHoiQIMG+HqIXCeQylCPaR1fRPeIU+EK0OJq4NvHzwnQlzWKUbbjotriFituWOSb4NRy+csL8DUpSxdHaVNX1vKxBdKHNZ0+fVH+Gv9VfDqSbRelTOj0z6fVukSq5eBmhlR7aZUAa3sgVUExHQ9j/BtOi3osW53Cr856MG1eCwI6HUeK7mARtBPLG09SahDe+Qi4XrYyStycA+67puNEebcshqTBM/NMjoEIrcAkUOMQQaPAz7bcz3udcFRIfo54CsevqJ6OygHuW2EVDsoY9WkATngHxivA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5611.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199015)(107886003)(186003)(86362001)(9686003)(53546011)(316002)(41300700001)(71200400001)(478600001)(110136005)(7696005)(33656002)(122000001)(83380400001)(8936002)(54906003)(38100700002)(52536014)(4326008)(66446008)(76116006)(66556008)(6506007)(5660300002)(66946007)(26005)(82960400001)(64756008)(8676002)(66476007)(38070700005)(55016003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aiSarMqPl9s/9qBPw1WJ+gXWJxY0khfSjKnXfv/tO45koeVCZjUnCpv1+G9u?=
 =?us-ascii?Q?OqR4x13BjqFG+AekqYEZAZVLb1BoS+cOd0MSLsVOdSqikPGyG3NSR3gTcqHX?=
 =?us-ascii?Q?enJb8L5F6iDZTIb1xOzUPCZgvmXZxeH7omeo3JIfxGoLAl1oet+HAfi1Vlnf?=
 =?us-ascii?Q?Jz4+7X5VfO8d2trAfsmPJIZmyL0c32xJX7ZtOJBMMjQm/thLmBb7rvV+xdHw?=
 =?us-ascii?Q?VcglKiT0XME7GWhh69x2qBD6wxAo19BTXlRV5IhnADHryuzZB9newJ1bBUkD?=
 =?us-ascii?Q?8k7TGOB2patBzgO9uUVUDM9VScdAe1jeUafCzWSQwNtt9KTyWkWFdMTPW+SX?=
 =?us-ascii?Q?zzwM+sz42WU9YfJSqDETJmjQCz3Fmik1fnUmt6j73GnJyrojh7wjeK64AR0u?=
 =?us-ascii?Q?UiUMLuQZdet7B4Bt5AuV9jGuHO7nStASSA58YmBRJZR39FMOKDezYcMHvO+S?=
 =?us-ascii?Q?Xu8742jxDFc3zoxdyjWPMx9AXwSaxRvbZKf7Azw1AtrnaSyLkxu02LNGgrnm?=
 =?us-ascii?Q?2r87WRgSZoBGharYuWRqbWE/tNJgl/KQNDjAG7QAM28c8RH3jP39kXOD1mKO?=
 =?us-ascii?Q?yecZRam1N8Rt5b0v8d0DOFzjeS2EMyLwQmBr7AtPkWBKxxvncCKJ1oIdZx8l?=
 =?us-ascii?Q?Vg98xrMUpShISiWE1ocGhKqXo7VlYIc+pa7he9Vr2N3jWn33Ihube0GhJizj?=
 =?us-ascii?Q?suIWbEtQ5M8Gfpk0gFFgtif1OO8mk7namBpVsDs7qPFocKFUKRCXyyVeAqcq?=
 =?us-ascii?Q?tX2CZ17LZ5dBUDZgnxU38GyxYsuxSRG5rSWVKQjV1drO7FvPbcdzY4uzzDNV?=
 =?us-ascii?Q?LedkLFY/i9+BQ40ad5okZCWNevvgdbSSyV4Orb0dAWJ62s53f9XrtjgPDf6v?=
 =?us-ascii?Q?rdUMB/E7DZQ5uj83KP2KqsXHi1j9+ee5l3Q5mk3j7Tdehhaz/JAKtwnnsyCL?=
 =?us-ascii?Q?YXxLGsHVrXhWomEQUboElf5dn+GxNfM0gJPvI2RNIfOtuLDkc4dw3AcIB31G?=
 =?us-ascii?Q?L6WVBuf36CPjorzYaNEgriGXnxMYGML5E+DD7wAMwU1j7AnekyrInNqOL77u?=
 =?us-ascii?Q?aSI77aTxRi8xxvcoiO46Ko16tBsa3fP907NYZQ/fcvK+CX8AZ4ZOQyPgARnq?=
 =?us-ascii?Q?R/1p7bpRBxaU+5PUgDY+dwL9XqPQUcmo5wxgMLwbwCCEg32OVe41fKCQQTUT?=
 =?us-ascii?Q?k24qdShDNfwGFgiABLtYE/iqVoS/b7OOHKODlvNSjZidVQQJ0WXSoSn4yPtq?=
 =?us-ascii?Q?UzvN/pXb2tsPhGGurgLhPhWeslq5jhOqxquRY/COauG05Ppwi1nToFYEVw47?=
 =?us-ascii?Q?45/AZ/sX/JK/4IletLEggb7lgruIYuh3driPDF4ReS1jmTgDxUEJ0J+jYMO8?=
 =?us-ascii?Q?6d3dodJZVnM8E8DlNjlw34X2xDzosW2LDvuoRX/yfaXPI5jbHpfb5nyin6eo?=
 =?us-ascii?Q?qy3oXDT8/gsh+PDrq6WyR0Ew25mL4Dpoedee3zkle9VXhCB2y3AeyK5LBRKN?=
 =?us-ascii?Q?H51t+Z6C71fUggSU4S9029qroGw7QafR4KuvixOcYcDvZQQTCKAU4hssTiHo?=
 =?us-ascii?Q?U0dLuhzvGZVfP1FTdm+T4LKqIKoP+pyYXGuQcBWd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5611.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70898b6d-6fe0-4832-6d87-08da957ed9e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 11:55:27.9724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HKhTp5OLTHrEo5zjncMoHn3VqrpqjfMO3nfvIuR5/Vdqjb6IaWJabw+8Na+DEjYK6RZabMbEzMWp5Lu2itYXPOkMUP+JVqw2/6Yo0ghCeuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4602
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Do I have to take any additional care of this HSD or I may consider it read=
y?

Regards,
Staikov Andrii

-----Original Message-----
From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>=20
Sent: Tuesday, September 6, 2022 11:56 PM
To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com; edumazet@googl=
e.com
Cc: Gawin, JaroslawX <jaroslawx.gawin@intel.com>; netdev@vger.kernel.org; N=
guyen, Anthony L <anthony.l.nguyen@intel.com>; Staikov, Andrii <andrii.stai=
kov@intel.com>; G, GurucharanX <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/3] i40e: add description and modify interrupts c=
onfiguration procedure

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

Add description for values written into registers QINT_XXXX and small cosme=
tic changes for MSI/LEGACY interrupts configuration in the same way as for =
MSI-X.
Descriptions confirm the code is written correctly and make the code clear.=
 Small cosmetic changes for MSI/LEGACY interrupts make code clear in the sa=
me manner as for MSI-X interrupts.

Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 14 +++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 34 ++++++++-------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/=
intel/i40e/i40e.h
index d86b6d349ea9..9a60d6b207f7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -399,6 +399,20 @@ struct i40e_ddp_old_profile_list {
 				 I40E_FLEX_54_MASK | I40E_FLEX_55_MASK | \
 				 I40E_FLEX_56_MASK | I40E_FLEX_57_MASK)
=20
+#define I40E_QINT_TQCTL_VAL(qp, vector, nextq_type) \
+	(I40E_QINT_TQCTL_CAUSE_ENA_MASK | \
+	(I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) | \
+	((vector) << I40E_QINT_TQCTL_MSIX_INDX_SHIFT) | \
+	((qp) << I40E_QINT_TQCTL_NEXTQ_INDX_SHIFT) | \
+	(I40E_QUEUE_TYPE_##nextq_type << I40E_QINT_TQCTL_NEXTQ_TYPE_SHIFT))
+
+#define I40E_QINT_RQCTL_VAL(qp, vector, nextq_type) \
+	(I40E_QINT_RQCTL_CAUSE_ENA_MASK | \
+	(I40E_RX_ITR << I40E_QINT_RQCTL_ITR_INDX_SHIFT) | \
+	((vector) << I40E_QINT_RQCTL_MSIX_INDX_SHIFT) | \
+	((qp) << I40E_QINT_RQCTL_NEXTQ_INDX_SHIFT) | \
+	(I40E_QUEUE_TYPE_##nextq_type << I40E_QINT_RQCTL_NEXTQ_TYPE_SHIFT))
+
 struct i40e_flex_pit {
 	struct list_head list;
 	u16 src_offset;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_main.c
index 89dd46130c03..9b2f18dfd0c4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3879,7 +3879,7 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *=
vsi)
 		wr32(hw, I40E_PFINT_RATEN(vector - 1),
 		     i40e_intrl_usec_to_reg(vsi->int_rate_limit));
=20
-		/* Linked list for the queuepairs assigned to this vector */
+		/* begin of linked list for RX queue assigned to this vector */
 		wr32(hw, I40E_PFINT_LNKLSTN(vector - 1), qp);
 		for (q =3D 0; q < q_vector->num_ringpairs; q++) {
 			u32 nextqp =3D has_xdp ? qp + vsi->alloc_queue_pairs : qp; @@ -3895,6 +=
3895,7 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *vsi)
 			wr32(hw, I40E_QINT_RQCTL(qp), val);
=20
 			if (has_xdp) {
+				/* TX queue with next queue set to TX */
 				val =3D I40E_QINT_TQCTL_CAUSE_ENA_MASK |
 				      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) |
 				      (vector << I40E_QINT_TQCTL_MSIX_INDX_SHIFT) | @@ -3904,7 +3905,7=
 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *vsi)
=20
 				wr32(hw, I40E_QINT_TQCTL(nextqp), val);
 			}
-
+			/* TX queue with next RX or end of linked list */
 			val =3D I40E_QINT_TQCTL_CAUSE_ENA_MASK |
 			      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) |
 			      (vector << I40E_QINT_TQCTL_MSIX_INDX_SHIFT) | @@ -3973,7 +3974,6 =
@@ static void i40e_configure_msi_and_legacy(struct i40e_vsi *vsi)
 	struct i40e_q_vector *q_vector =3D vsi->q_vectors[0];
 	struct i40e_pf *pf =3D vsi->back;
 	struct i40e_hw *hw =3D &pf->hw;
-	u32 val;
=20
 	/* set the ITR configuration */
 	q_vector->rx.next_update =3D jiffies + 1; @@ -3990,28 +3990,20 @@ static =
void i40e_configure_msi_and_legacy(struct i40e_vsi *vsi)
 	/* FIRSTQ_INDX =3D 0, FIRSTQ_TYPE =3D 0 (rx) */
 	wr32(hw, I40E_PFINT_LNKLST0, 0);
=20
-	/* Associate the queue pair to the vector and enable the queue int */
-	val =3D I40E_QINT_RQCTL_CAUSE_ENA_MASK		       |
-	      (I40E_RX_ITR << I40E_QINT_RQCTL_ITR_INDX_SHIFT)  |
-	      (nextqp	   << I40E_QINT_RQCTL_NEXTQ_INDX_SHIFT)|
-	      (I40E_QUEUE_TYPE_TX << I40E_QINT_TQCTL_NEXTQ_TYPE_SHIFT);
-
-	wr32(hw, I40E_QINT_RQCTL(0), val);
+	/* Associate the queue pair to the vector and enable the queue
+	 * interrupt RX queue in linked list with next queue set to TX
+	 */
+	wr32(hw, I40E_QINT_RQCTL(0), I40E_QINT_RQCTL_VAL(nextqp, 0, TX));
=20
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		val =3D I40E_QINT_TQCTL_CAUSE_ENA_MASK		     |
-		      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT)|
-		      (I40E_QUEUE_TYPE_TX
-		       << I40E_QINT_TQCTL_NEXTQ_TYPE_SHIFT);
-
-		wr32(hw, I40E_QINT_TQCTL(nextqp), val);
+		/* TX queue in linked list with next queue set to TX */
+		wr32(hw, I40E_QINT_TQCTL(nextqp),
+		     I40E_QINT_TQCTL_VAL(nextqp, 0, TX));
 	}
=20
-	val =3D I40E_QINT_TQCTL_CAUSE_ENA_MASK		      |
-	      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) |
-	      (I40E_QUEUE_END_OF_LIST << I40E_QINT_TQCTL_NEXTQ_INDX_SHIFT);
-
-	wr32(hw, I40E_QINT_TQCTL(0), val);
+	/* last TX queue so the next RX queue doesn't matter */
+	wr32(hw, I40E_QINT_TQCTL(0),
+	     I40E_QINT_TQCTL_VAL(I40E_QUEUE_END_OF_LIST, 0, RX));
 	i40e_flush(hw);
 }
=20
--
2.35.1

