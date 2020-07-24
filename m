Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A3D22BAC5
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgGXAHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:07:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:65246 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgGXAHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:07:50 -0400
IronPort-SDR: lbEMvDWNbeKng7cMFFp4XT4R28HXoryQpJIUiB9BIIYZX4SBx/sZyTsHndmjaAKD/q3Q9CxLo/
 iphr3VEMurRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130714970"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130714970"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 17:07:45 -0700
IronPort-SDR: VYPYPoY4PJnojcknpX3WLrdBVUD/C641TKz6gqsDZH+h52wRUiV+U2zmv65C0meD0zD6bsw8HA
 bSYEJJnDQ4pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="311214938"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga004.fm.intel.com with ESMTP; 23 Jul 2020 17:07:45 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 17:07:44 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX113.amr.corp.intel.com (10.22.240.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 17:07:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 23 Jul 2020 17:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSmiXyyUmADAHqC6xf3Ql/0XPKlar871liLB2kco+HBnRVV57DiE69p4DMimS3V2QibhmF4NQ6gpVW2VOIL8rBlExaQo9ltSQpWxLJW4pSSn9+Bi4mXBiap3NX0tI+0tI/jl125kGsY6HKFSscH8z0s+SqE7Lwzf86vjpElvygOmgZpXywdLZQJ3mzpNNM02DvPb52jcoZWkYRlMNJrHD+2V1m7lfFlUQ+2LjF6ukzLUaJR9/EzEtXRbrOwCpQyWGFjlfvOUkKuSKOrz1X3Z93/d5G1s5GrRawRQyQhDRt8zc4MrLbOmRO/olPaHzNAnwoOo4gOJJ43Pp5WkV4ppRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cb0JsLZ9uCDYN9pCtFb6yWvd/n4JU0YGHTNbg9df0a8=;
 b=QJ1LPH3YuiZ+1WIdlASvuoMcec2fDZ3VwmRslVOUO7TSVB881a553n+6v79LHJvKycg7H/wYeLbqgPrLxqtKtIQT2hGgeX87gQxszNGYm0xzQaVHe/F3wxOtjkgWDRi570Kl0g0fvwJwPZufLuKlnr3uN9DSMfQ7ZARwKaID3cLpPw2ZGs8tYqHheeIUhgfEKeI1SAvkaT26kJgs/jhzBy4Y79FloYzomh/IAPxn92BSOp9Z35DmNrP2TbXWjw+UZ98/6BXfyoSYRdfBtB6krl1jxrEZsRmIDkngRysilJHEATr1dODn6eodnO7AwLALbXydmSRXDQGLehSSr4Q7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cb0JsLZ9uCDYN9pCtFb6yWvd/n4JU0YGHTNbg9df0a8=;
 b=pPQ2BqnTAUk3vMQWAC12d3RiKg+PaUnJgeW3BlOz3BxOKHpNXaDkT2jYNcfbqwJuCKfAHO7U2DLKBkmA5us/lKDJurgwaTQTgqbIVpOdt/pEEednKf0WtN4gIcZp0I3qkDBXokIrx9/iZEaLvE/FeaKjbcItsEyQVSp+mVBxcE8=
Received: from BY5PR11MB4452.namprd11.prod.outlook.com (2603:10b6:a03:1bf::19)
 by BY5PR11MB4071.namprd11.prod.outlook.com (2603:10b6:a03:18c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 24 Jul
 2020 00:07:42 +0000
Received: from BY5PR11MB4452.namprd11.prod.outlook.com
 ([fe80::dce:3bb0:16bf:8ef5]) by BY5PR11MB4452.namprd11.prod.outlook.com
 ([fe80::dce:3bb0:16bf:8ef5%6]) with mapi id 15.20.3216.023; Fri, 24 Jul 2020
 00:07:42 +0000
From:   "Stillwell Jr, Paul M" <paul.m.stillwell.jr@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 15/15] ice: add 1G SGMII PHY type
Thread-Topic: [net-next 15/15] ice: add 1G SGMII PHY type
Thread-Index: AQHWYUukuuCKgVU1P0ad1w71B0Idr6kV2kDw
Date:   Fri, 24 Jul 2020 00:07:42 +0000
Message-ID: <BY5PR11MB445222D4DF27B02D7DA7E621E0770@BY5PR11MB4452.namprd11.prod.outlook.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
 <20200723234720.1547308-16-anthony.l.nguyen@intel.com>
In-Reply-To: <20200723234720.1547308-16-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.190.115.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1716b966-6b15-4e06-5cfd-08d82f6595e6
x-ms-traffictypediagnostic: BY5PR11MB4071:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4071E8B401F55B82C239235FE0770@BY5PR11MB4071.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NCVqQo0pHCS0Jk3R34217knwcoURIbLcTaNsVHKE3WU020/o/eo1zLHrZqb6MzMO0r8WJM5K0GTi2soa9SlomO5UvlZTQEI98SEblQrqci7nRYBIh3VRfcv1qa2/Rz6CkxAVqxRhfO2+JpQ5A1dflyg0vd3Geds06bT9mcZjgvqP0Eo/JmlG9XwXaKg7fiYwQIZBKpDZkwiR7H2eVgk96V9Tu2Dn1MN8AbaBEt0kQehjYRn5CJu1bGqf6dTuisnsKhhjhjpKfIWvNbAwjYZsr2lAFDa0tuSA+UoojtKvhr3Q1K4cuisMG5Lpq5r3/rZx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4452.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(55016002)(9686003)(110136005)(76116006)(66946007)(4326008)(5660300002)(71200400001)(53546011)(6506007)(52536014)(54906003)(8936002)(8676002)(26005)(107886003)(186003)(7696005)(83380400001)(66476007)(66556008)(86362001)(64756008)(478600001)(2906002)(33656002)(316002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: R8z5//9T9JClmzK22FSLMwcPr0mPx9EQTuHZby21KWDc8E4ymywunQOfieybazktFPGx+Na/s7UsTJ0qE3PArJ3W0flMu1JczmjApalzV4NFZ9GKCcTcDKPvtS4+No8G2e+sWTV30+hxW486lKmCbNUOdh82h5XXlNzZ5a+cz1U3YE5/TlqigLFMf7Gpevh05Na4egYbWU0tospFDNlAzdOcl96LJN2r/aX2bUbTucUrpybGCkCcVCzvxDcfHkBLsXWLhSJ31B9lq10njIbru+qHEnTs5lZVnApiji9iEjfB7omljSvHybJv6RZf6znIsN3k0EM24Jcm59Z3ojTaXE4mb2/jtx8BKKKBH2mM9n2rebUF2j/7tfUEYL/WgAlWbWBa627i4q4wk5weEcQHPodgDnlghCpiMBEdNxDWgBqETacUyOEaZyoA8NOP5G4CQPOeAyqekL5YNhWSlnQSOsQocS84lhNu8H92kCFBZ1I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4452.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1716b966-6b15-4e06-5cfd-08d82f6595e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 00:07:42.4200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6qQlbSFtI6Y3gtAbUHgpT4l5SgPv/JRLsk9Jur6w2lRHvUQLjap3ZK2xNPXTMobaOf98B5mOwlTvp7h2p0oN1uThsC9Pue6nmJIDcG6BcgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4071
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ack, thanks!

Paul

> -----Original Message-----
> From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Sent: Thursday, July 23, 2020 4:47 PM
> To: davem@davemloft.net
> Cc: Stillwell Jr, Paul M <paul.m.stillwell.jr@intel.com>; netdev@vger.ker=
nel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: [net-next 15/15] ice: add 1G SGMII PHY type
>=20
> From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
>=20
> There isn't a case for 1G SGMII in ice_get_media_type() so add the handli=
ng for
> it.
>=20
> Also handle the special case where some direct attach cables may report t=
hat
> they support 1G SGMII, but that is erroneous since SGMII is supposed to b=
e a
> backplane media type (between a MAC and a PHY). If the driver doesn't han=
dle
> this special case then a user could see the 'Port' in ethtool change from=
 'Direct
> attach Copper' to 'Backplane' when they have forced the speed to 1G, but =
the
> cable hasn't changed.
>=20
> Lastly, change ice_aq_get_phy_caps() to save the module_type info if the
> function was called with ICE_AQC_REPORT_TOPO_CAP. This call uses the medi=
a
> information to populate the module_type. If no media is present then the =
values
> in module_type will be 0.
>=20
> Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  1 +
>  drivers/net/ethernet/intel/ice/ice_common.c     | 17 ++++++++++++++---
>  2 files changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> index 4315a784b975..b363e0223670 100644
> --- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> +++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> @@ -993,6 +993,7 @@ struct ice_aqc_get_phy_caps_data {
>  	u8 module_type[ICE_MODULE_TYPE_TOTAL_BYTE];
>  #define ICE_AQC_MOD_TYPE_BYTE0_SFP_PLUS			0xA0
>  #define ICE_AQC_MOD_TYPE_BYTE0_QSFP_PLUS		0x80
> +#define ICE_AQC_MOD_TYPE_IDENT				1
>  #define ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_PASSIVE	BIT(0)
>  #define ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_ACTIVE	BIT(1)
>  #define ICE_AQC_MOD_TYPE_BYTE1_10G_BASE_SR		BIT(4)
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c
> b/drivers/net/ethernet/intel/ice/ice_common.c
> index bb9952038efa..c72cc77b8d67 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -194,6 +194,8 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool
> qual_mods, u8 report_mode,
>  	if (!status && report_mode =3D=3D ICE_AQC_REPORT_TOPO_CAP) {
>  		pi->phy.phy_type_low =3D le64_to_cpu(pcaps->phy_type_low);
>  		pi->phy.phy_type_high =3D le64_to_cpu(pcaps->phy_type_high);
> +		memcpy(pi->phy.link_info.module_type, &pcaps-
> >module_type,
> +		       sizeof(pi->phy.link_info.module_type));
>  	}
>=20
>  	return status;
> @@ -266,6 +268,18 @@ static enum ice_media_type
> ice_get_media_type(struct ice_port_info *pi)
>  		return ICE_MEDIA_UNKNOWN;
>=20
>  	if (hw_link_info->phy_type_low) {
> +		/* 1G SGMII is a special case where some DA cable PHYs
> +		 * may show this as an option when it really shouldn't
> +		 * be since SGMII is meant to be between a MAC and a PHY
> +		 * in a backplane. Try to detect this case and handle it
> +		 */
> +		if (hw_link_info->phy_type_low =3D=3D
> ICE_PHY_TYPE_LOW_1G_SGMII &&
> +		    (hw_link_info->module_type[ICE_AQC_MOD_TYPE_IDENT]
> =3D=3D
> +		    ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_ACTIVE ||
> +		    hw_link_info->module_type[ICE_AQC_MOD_TYPE_IDENT] =3D=3D
> +		    ICE_AQC_MOD_TYPE_BYTE1_SFP_PLUS_CU_PASSIVE))
> +			return ICE_MEDIA_DA;
> +
>  		switch (hw_link_info->phy_type_low) {
>  		case ICE_PHY_TYPE_LOW_1000BASE_SX:
>  		case ICE_PHY_TYPE_LOW_1000BASE_LX:
> @@ -2647,9 +2661,6 @@ enum ice_status ice_update_link_info(struct
> ice_port_info *pi)
>=20
>  		status =3D ice_aq_get_phy_caps(pi, false,
> ICE_AQC_REPORT_TOPO_CAP,
>  					     pcaps, NULL);
> -		if (!status)
> -			memcpy(li->module_type, &pcaps->module_type,
> -			       sizeof(li->module_type));
>=20
>  		devm_kfree(ice_hw_to_dev(hw), pcaps);
>  	}
> --
> 2.26.2

