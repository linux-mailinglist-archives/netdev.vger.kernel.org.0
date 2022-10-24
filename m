Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266B260BF2F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJYADl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJYADU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:03:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABCCBC784
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 15:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666649925; x=1698185925;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KmLMyjGvXiMzko+fYqtjb8QT3end50Z2AC7XuUk3r/4=;
  b=TVbzVJw4fg95dXu+iwIYDfwN3orF5osUjRIeKw8im4U/pFK/dZdKnZ5t
   VdhBVzubpFC1pjRAXywilnHY1naSamj4HyAev/UYFzGH91/iHWG2HVk9N
   cuqtOOio1lkMNORlf/CNtU46v0v4LI9RiDcFsnM0+w/3Pc4ZH20WmZukh
   Mkg3HvUn0GsTpv1eNm+zdh/3N3QLpcHEHIi+N9tQtY2RA+0RIe5/xmISL
   2B4tiYBtKqTXlbLCI3VdaTBzuT5+KhRGasuBGCoT9JgNgx8FdLyI6IJIh
   ypwlKjTG1wJgsNO9G7FkhNSq1LqG7RSCEgjCLwVloKEIgQsq3zPCN8jDc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="290837989"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="290837989"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:18:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="960591352"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="960591352"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2022 15:18:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 15:18:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 15:18:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 24 Oct 2022 15:18:43 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 24 Oct 2022 15:18:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhVzpbZql1SbahvXBj2o7orAp0WCfY9nfaf//QfxsIVm1yJCQjlIcA2zNozxF8oAuiHIABj6qSwVW2HKtgLIRjfqXv1MXsjLxynfz25l8oMKKGFW7hKfGfjowX1HF8i/SV0JfweD/ItXffKifek8RPgAtjGM1lm3/BoNKSvzoAmBUewadTWSNx72kbJfotBSuIInYt37iRF2g68Z2o1lLtD4kG2J+QNAdYSy/2snq2xOgoMFYSgSRoQqorqDM6GeR3oxaxV/DT6kGjVRGfYEibXct5chQjFIBAlXsOLBi8cTie+w/kulIEXNHi1IvXeTTeLle9RfHThTBwOTM9FQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG/3iGrOAjrUhAks5OLZUKTIO8f2MWqBZysPtuy6Ndg=;
 b=mSl/QF4wcSChJZPIcM3rKv+GeXtpHm/TuNCmQMw1XICK+TnyBwecMW2YWUZMLDj+bd8bGMFqnlgwiNFuscaXAr+qBdVte/ITX70QZMQOoE84zP+eNsqfVqwiUyAR92abtFCWhAw7elZEdY0aPqerH1ycahkSA0zG9aV5/3XOyS2vVrOLMOwXAr62rq9cJY/kIeOc+yNs2soc41z7V5FB07rj6r45JJVDEitjV2PQYMuWTCMW5urZf96OM4uUQVBpcmK2fxB3cWGakmzPRl7G5wV6I0yZ6oRiwItKj9qJgIpJZq7Vus0X8f7GGZOx57i1JDARqvHOI/MAci1B4QCDQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB5912.namprd11.prod.outlook.com (2603:10b6:303:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Mon, 24 Oct
 2022 22:18:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%4]) with mapi id 15.20.5746.027; Mon, 24 Oct 2022
 22:18:41 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Laba, SlawomirX" <slawomirx.laba@intel.com>,
        "Jaron, MichalX" <michalx.jaron@intel.com>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH v2 1/3] i40e: Fix ethtool rx-flow-hash setting for X722
Thread-Topic: [PATCH v2 1/3] i40e: Fix ethtool rx-flow-hash setting for X722
Thread-Index: AQHY55ArGmXo0OLvbUWJE3OVAqIXv64eHekA
Date:   Mon, 24 Oct 2022 22:18:41 +0000
Message-ID: <CO1PR11MB50892671BA9380FBA2D9EEB1D62E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221024100526.1874914-1-jacob.e.keller@intel.com>
In-Reply-To: <20221024100526.1874914-1-jacob.e.keller@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW4PR11MB5912:EE_
x-ms-office365-filtering-correlation-id: acb339b2-88c4-4faa-8829-08dab60db4eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HRSv4xtPiYcolQIjpERzfB7JIxLTOxrAwnxKuAdk5iDDA4Js8cgyWleIBkkuZ87CnTR5QIJGT1Mw57RctKKBbmWaHhFIQsSTJ+BtACvYmBVlwJj+4LuWM7QmNpCW5ci4kLNRm8Q8jUzZE2ruB4VXb9roPKfK02eXdj7HekCfKDppMFVqfVQuDC3L8x5sJ9AAVfj6VFJqFXQD8Ed/nwGlcqy937SvFVu5Ytww9B/JzehoqoTsp/eLZiu9TH9WDfl+IbTmOd0VfcMx4v0uLBY7i019b9Xbp1jn/WgfdMFvMGzVjynoZs/ZZ00qFhzKyr1ohPgqlYVWf+2ZE79TCB1M0sB41c15S0aPcjKndD+FwieCorZDfaTDhw+QTOlFRts9zNxs6lj8szr6iv9Mp5dFFcGcqASua8S78rYsSiFdl2MLk5mNfuxdY9o6OKtJYPxS56HJKcaCiXsFBaiCCMS5NwbEbaOwAzKmFen7KA0iN7ZOUv1dkBee/Z1Lk/DV2Kndo0E4Q8Tqj5PM+/63l1lkvopN4ifQGKUy6TT2fD/IKLNgTmnGviyizpXZv5UfLeLL92ZN3OdN7qXCgDLIggAUBMGqQNY3SqzERgf4Tdg4FmGCMlNdBj44hF7drScIGUiwmtDuyOpBOGYjcu5kMxr2a0wf85sqmUfZKsQTC5aOUoTyX3MXw3ojdcNeigqIzPCjhOCYAIPNf/WakCI568Z79OcfeOwNe1SZZpkQe0NT5Qc8CKyuRk/OjB3MxuJRtjsz+FOylfIP+fBFHqNnp4y33w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(82960400001)(38070700005)(33656002)(86362001)(107886003)(55016003)(38100700002)(83380400001)(122000001)(71200400001)(76116006)(54906003)(66946007)(316002)(66556008)(5660300002)(110136005)(52536014)(6506007)(66476007)(2906002)(8676002)(186003)(478600001)(64756008)(7696005)(53546011)(26005)(4326008)(9686003)(66446008)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JqIpy4KG4F2zIrkX2r2jlvOkVHBDxhiRRNbe2wCr7oeARaHliq+3oGLds89b?=
 =?us-ascii?Q?aTXhKYxOq8fAJ2wlhJByHubo6Fi7Ja301AVZl0C66rnf5mX/gZsI9PnLUoJL?=
 =?us-ascii?Q?kjgdPOSW0aphhU0h3o57w4zhxmzhvcJnhYzCv0qKFvbI2Qt6vgfBhNNYUeO6?=
 =?us-ascii?Q?dcwszTQdQy5EZgfZVmaVtgEFWK+YUFe3Nq8ocE0JZ35mdar0WiGgVTDRbRTC?=
 =?us-ascii?Q?dU5ht01jn5OSXS7gKSuK5BxArv+opnbBwgclY9khuyGwwiTVHy4O1KZk/UCN?=
 =?us-ascii?Q?ZBMeUwx/Mh1wnjuW46vaz6/n+PwLk+HPOmwfafu0Gs4imCrn27pyVkm1Z93l?=
 =?us-ascii?Q?paankunB4ky10fAH8HbSzCE5GI94qzHsEBeg0suBBuyVdxEzgnz238ckSL2j?=
 =?us-ascii?Q?r54dHZzxEccmfva45vLBzyZugOLCPr6ksKg0qiN9pFKwTZcjdYvG10zVX+6h?=
 =?us-ascii?Q?Ljsrq4PN9CnQyln+RzhlZ6zBdd22Jinp9bicrpATvUlkRI9Zv0v3P0EqzjAD?=
 =?us-ascii?Q?6Vg854SADsTp5Oz4FN4csz8rneqmdpQ7HPPKwbapDcdn0WeLi7EBJ5BP2Twt?=
 =?us-ascii?Q?QHIr8ilcL6JkmQdW8GzdovZgQHHn6bA2qKVoPJR1MrlGR1YPgDYoOhwhiGfK?=
 =?us-ascii?Q?IoxDxfSieD1N2JgjSLwBqn6WYo51D3BWDK9KVszfSgPLO46YsBv8gmOqbyjS?=
 =?us-ascii?Q?gOLLmSb8qeTPxIhluqTsA6yIwjye4gnR8Eg5OYrlhPGwarI7NwVlqhjeC9IA?=
 =?us-ascii?Q?20sNjOuBtWnoqfJVO3rS3kGA7BF7/EOuxUhttyzdNg9ihzdK7LC1QE/x3gG2?=
 =?us-ascii?Q?kZln3kyYK4WYAksFk3pfghD5X63zhA2S/vIitYXhPl4A8mordbmRBqMqyZaE?=
 =?us-ascii?Q?SBS3qOkkD9LliOikb5oP53aktAPk/h6zrDPKms8qspEsF6YpCc0cxCEhQLX5?=
 =?us-ascii?Q?M073mRX4+V/0EXa4s9+78avGNmCeiLXn8fwp4dp0czJPkC1Aicbs+frv+RMg?=
 =?us-ascii?Q?tEyrSGcLEfgAhyjaDcUsbFhP5sZ79OAZB6uX7BvBBI95+qXlecqFBoUvlGk6?=
 =?us-ascii?Q?hAn1Mv9xPA+vS1+v5v7gfcuY+H1Uisj5V/hw6IVMOzbvEivcUd/56mUQSaKO?=
 =?us-ascii?Q?2tYPOinC0vpUOLO+m9VN9R/Gib4+G5D3+jScDiOgZVuY3C9o9DYS4AigVtOf?=
 =?us-ascii?Q?y5pr4+Ru+AyZEmODf2nPBR8rJW7lrlIvOPb01nC1tl73IxgFfD2RKWb7kx2B?=
 =?us-ascii?Q?Zt4oTS90YgGutgKqGYf8iUr99r0tVtBYteDyxnn+lhP3xx2+ahTpvm4I3Br2?=
 =?us-ascii?Q?xNasWF1eorwPfo5D2ZAe3k02ITB/yy93XBSSQkJVAkj4hvTC/Jv++Xxc5nlm?=
 =?us-ascii?Q?ucM5GPVqNLnfzyq4CwTX36Nco7+HfUo1/reKY1kEHAz64rerKg8iocVFTuAR?=
 =?us-ascii?Q?5p4plAhJ/S7w9QRWX4FZXCMIcEp1XztW9S03RPibhu6IvKdKzHh4OtwZZ2qf?=
 =?us-ascii?Q?6GdMORLlSTNCeipvUfOE1TNDkKafw//ZmpmR+VRnhoRgQy8UQn1BTLH2ooGD?=
 =?us-ascii?Q?axvgmg6mkYpv3BEak76lV83gdpAIG/xZ7VtBHCf4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb339b2-88c4-4faa-8829-08dab60db4eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 22:18:41.2198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKvCwQ4ozvEoG/8fLRt3Ra1RfIqpkxLNjmOfPPufdEN4xbBXWDyWeUxz1slFEwaY8fx5QC3K4m0I/BxIKaiWX2jREI5ezHvcpkeaxo8Xnr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5912
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Keller, Jacob E <jacob.e.keller@intel.com>
> Sent: Monday, October 24, 2022 3:05 AM
> To: Jakub Kicinski <kuba@kernel.org>; David Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org; Laba, SlawomirX <slawomirx.laba@intel.com>;
> Jaron, MichalX <michalx.jaron@intel.com>; Palczewski, Mateusz
> <mateusz.palczewski@intel.com>; G, GurucharanX <gurucharanx.g@intel.com>;
> Keller, Jacob E <jacob.e.keller@intel.com>
> Subject: [PATCH v2 1/3] i40e: Fix ethtool rx-flow-hash setting for X722
>=20

Fix one thing, screw up another... I forgot to tag these as [net]..

> From: Slawomir Laba <slawomirx.laba@intel.com>
>=20
> When enabling flow type for RSS hash via ethtool:
>=20
> ethtool -N $pf rx-flow-hash tcp4|tcp6|udp4|udp6 s|d
>=20
> the driver would fail to setup this setting on X722
> device since it was using the mask on the register
> dedicated for X710 devices.
>=20
> Apply a different mask on the register when setting the
> RSS hash for the X722 device.
>=20
> When displaying the flow types enabled via ethtool:
>=20
> ethtool -n $pf rx-flow-hash tcp4|tcp6|udp4|udp6
>=20
> the driver would print wrong values for X722 device.
>=20
> Fix this issue by testing masks for X722 device in
> i40e_get_rss_hash_opts function.
>=20
> Fixes: eb0dd6e4a3b3 ("i40e: Allow RSS Hash set with less than four parame=
ters")
> Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
> Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at
> Intel)
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changes since v1
> * Rebased to fix conflicts, sent as series properly
> * Added my missing signed-off-by
>=20
>  .../net/ethernet/intel/i40e/i40e_ethtool.c    | 31 ++++++++++++++-----
>  drivers/net/ethernet/intel/i40e/i40e_type.h   |  4 +++
>  2 files changed, 27 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> index 87f36d1ce800..314ef40aa260 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> @@ -3185,10 +3185,17 @@ static int i40e_get_rss_hash_opts(struct i40e_pf =
*pf,
> struct ethtool_rxnfc *cmd)
>=20
>  		if (cmd->flow_type =3D=3D TCP_V4_FLOW ||
>  		    cmd->flow_type =3D=3D UDP_V4_FLOW) {
> -			if (i_set & I40E_L3_SRC_MASK)
> -				cmd->data |=3D RXH_IP_SRC;
> -			if (i_set & I40E_L3_DST_MASK)
> -				cmd->data |=3D RXH_IP_DST;
> +			if (hw->mac.type =3D=3D I40E_MAC_X722) {
> +				if (i_set & I40E_X722_L3_SRC_MASK)
> +					cmd->data |=3D RXH_IP_SRC;
> +				if (i_set & I40E_X722_L3_DST_MASK)
> +					cmd->data |=3D RXH_IP_DST;
> +			} else {
> +				if (i_set & I40E_L3_SRC_MASK)
> +					cmd->data |=3D RXH_IP_SRC;
> +				if (i_set & I40E_L3_DST_MASK)
> +					cmd->data |=3D RXH_IP_DST;
> +			}
>  		} else if (cmd->flow_type =3D=3D TCP_V6_FLOW ||
>  			  cmd->flow_type =3D=3D UDP_V6_FLOW) {
>  			if (i_set & I40E_L3_V6_SRC_MASK)
> @@ -3546,12 +3553,15 @@ static int i40e_get_rxnfc(struct net_device *netd=
ev,
> struct ethtool_rxnfc *cmd,
>=20
>  /**
>   * i40e_get_rss_hash_bits - Read RSS Hash bits from register
> + * @hw: hw structure
>   * @nfc: pointer to user request
>   * @i_setc: bits currently set
>   *
>   * Returns value of bits to be set per user request
>   **/
> -static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
> +static u64 i40e_get_rss_hash_bits(struct i40e_hw *hw,
> +				  struct ethtool_rxnfc *nfc,
> +				  u64 i_setc)
>  {
>  	u64 i_set =3D i_setc;
>  	u64 src_l3 =3D 0, dst_l3 =3D 0;
> @@ -3570,8 +3580,13 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_r=
xnfc
> *nfc, u64 i_setc)
>  		dst_l3 =3D I40E_L3_V6_DST_MASK;
>  	} else if (nfc->flow_type =3D=3D TCP_V4_FLOW ||
>  		  nfc->flow_type =3D=3D UDP_V4_FLOW) {
> -		src_l3 =3D I40E_L3_SRC_MASK;
> -		dst_l3 =3D I40E_L3_DST_MASK;
> +		if (hw->mac.type =3D=3D I40E_MAC_X722) {
> +			src_l3 =3D I40E_X722_L3_SRC_MASK;
> +			dst_l3 =3D I40E_X722_L3_DST_MASK;
> +		} else {
> +			src_l3 =3D I40E_L3_SRC_MASK;
> +			dst_l3 =3D I40E_L3_DST_MASK;
> +		}
>  	} else {
>  		/* Any other flow type are not supported here */
>  		return i_set;
> @@ -3686,7 +3701,7 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf=
,
> struct ethtool_rxnfc *nfc)
>  					       flow_pctype)) |
>  			((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1,
>  					       flow_pctype)) << 32);
> -		i_set =3D i40e_get_rss_hash_bits(nfc, i_setc);
> +		i_set =3D i40e_get_rss_hash_bits(&pf->hw, nfc, i_setc);
>  		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_pctype),
>  				  (u32)i_set);
>  		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_pctype),
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h
> b/drivers/net/ethernet/intel/i40e/i40e_type.h
> index 7b3f30beb757..388c3d36d96a 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_type.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
> @@ -1404,6 +1404,10 @@ struct i40e_lldp_variables {
>  #define I40E_PFQF_CTL_0_HASHLUTSIZE_512	0x00010000
>=20
>  /* INPUT SET MASK for RSS, flow director, and flexible payload */
> +#define I40E_X722_L3_SRC_SHIFT		49
> +#define I40E_X722_L3_SRC_MASK		(0x3ULL <<
> I40E_X722_L3_SRC_SHIFT)
> +#define I40E_X722_L3_DST_SHIFT		41
> +#define I40E_X722_L3_DST_MASK		(0x3ULL <<
> I40E_X722_L3_DST_SHIFT)
>  #define I40E_L3_SRC_SHIFT		47
>  #define I40E_L3_SRC_MASK		(0x3ULL << I40E_L3_SRC_SHIFT)
>  #define I40E_L3_V6_SRC_SHIFT		43
>=20
> base-commit: c99f0f7e68376dda5df8db7950cd6b67e73c6d3c
> --
> 2.38.0.83.gd420dda05763

