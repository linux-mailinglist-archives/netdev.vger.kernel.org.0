Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA92322BF
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgG2Qbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:31:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:45857 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgG2Qbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:31:45 -0400
IronPort-SDR: atb7hDaS48WYMyvc7zqwti8hFJCsznlrOyV8DMU78Q0uGAIm086qp73xYBV1QNgukNDg13GQLl
 0BJN9AnDmLkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="169572974"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="169572974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:31:40 -0700
IronPort-SDR: ICyL9FE9NcWFVwj6m8KD4sFWlJO1F1j3gcgcSRXODhxLp+/R0+O8YPXHOKJfFDyXpIVCB3ULsH
 85+zRm6/DmGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="394709730"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2020 09:31:39 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 09:31:30 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Jul 2020 09:31:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 29 Jul 2020 09:31:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9jPvP5EoWCyz1+3K6+cmG1Kfwzxa8LEbqmU9+9JEQuMR5FufEkAEmG8ieqq6/gK7BwCfSmuaFv7uN0lXwUCTBiCqZz5ya3TkHPDMQo3vM/HsE2ynC1IZ17MhZcBlpg37jI/UW6G9GMAodgZHSOkEYZ2wHVQHe5CoN31Cp/H5f7dVYmZH4IMbEoMrz+kJAy1SbyUSlqdkQXunogOjf4zEusPzdxa9wSjbCccxY/SrBSCjLy1r6Mb/0e+1H+ztfUSf1AOv3M0uyrP2dBWJHErS6cXd+L6Bgiq/3LCcmwT4uTVcEKuZRaWP3LKikmGVK8qPG/am4jgAoFuSC1Z3RNVMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiolrPyD/+t4mHmqI20bwRy2xgq/+i8XDpoARTbzT30=;
 b=TRPP0bXVHbjTjIHgTOE3tY/wjFdafYWTQzMZ0dRicDj9ocEudOoufCFzXS2dNrB47cKUfsAeXxRhi6AXP6PbcjR/W0xzQLVh/xKnyZX7VPaOLJqOs/0tZndveGVeAr7UUXtuWp7+cZnMjil4y81C+3e4P0b3rFVa3TGpNR8T2qS/p6ke/pzEtcOEzPCeW+Q/8RbqmWny+jFg1gT6P2YplJUP8OiZM+cOQ1zSRG2FYntkLHCvQGopRUtexFKbPwnuMAv8PsCua0wCbphg4aeYlRcnzj7oAIT4ms6MgZ/OPxR01mY+U9AhhdXyjswOYuNOQm0fc8skfgQz/du3UHBkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiolrPyD/+t4mHmqI20bwRy2xgq/+i8XDpoARTbzT30=;
 b=VflDnN0b7GxQ6pT1htW0vVYUN4Owcyvh+qPACaj2TIiuBVWK13cBDPVE0+2vijyDHoQoJXpRoMMl3HLx9V/GYporPmtVDOnxqj9SbWYJPG8DjzrnCnM0AR//TVKodWJQd761AyDLqAieNxnkt+4elc0/Sz+jDi2Km01/K5r58Xw=
Received: from BYAPR11MB3174.namprd11.prod.outlook.com (2603:10b6:a03:76::27)
 by BYAPR11MB2567.namprd11.prod.outlook.com (2603:10b6:a02:c5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Wed, 29 Jul
 2020 16:31:22 +0000
Received: from BYAPR11MB3174.namprd11.prod.outlook.com
 ([fe80::dd5c:bfd6:5504:9acc]) by BYAPR11MB3174.namprd11.prod.outlook.com
 ([fe80::dd5c:bfd6:5504:9acc%6]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 16:31:22 +0000
From:   "Creeley, Brett" <brett.creeley@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 11/15] ice: Allow all VLANs in safe mode
Thread-Topic: [net-next 11/15] ice: Allow all VLANs in safe mode
Thread-Index: AQHWZcTELOTx/aJptkuOSe/NWpcwOakev9Hw
Date:   Wed, 29 Jul 2020 16:31:22 +0000
Message-ID: <BYAPR11MB317440BB64EA1D3289B66EA6F5700@BYAPR11MB3174.namprd11.prod.outlook.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
 <20200729162405.1596435-12-anthony.l.nguyen@intel.com>
In-Reply-To: <20200729162405.1596435-12-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.63.206.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a548dc0-c425-434a-c9ab-08d833dcd47f
x-ms-traffictypediagnostic: BYAPR11MB2567:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2567D3A4D0B4C603BFB5D219F5700@BYAPR11MB2567.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mbm9vnvk0uogPYKf9rzaagnWOTqcfjhcNghl2rtP/SepOMfVLAwXegzomC+BvDT2QA+vN7LFoF3kUqvoTrQPWjNfetfKgdpHyvFnWAqnYjAyMJYLuSjWtBD4insu+Io3JpR9+6rUk3P6QWYrukg1CecyPTJLAae5fDdTqmu7RzmZyPtXsQjau91xLi9i6LMPBacZ9Vqex4hFNUyW2utpz9U04u/+d+iSwC0tlfRforehfqgGDC8LHgnSR/sG4gW6VVG2TGJjilmWg+5Xm0VMJvYf3ZEHfn61Xksgxv5RIVuiiEVV6fLDdxWKDIHgJs7JbtPdSjEbsFM22GuOHZacxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3174.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(52536014)(8936002)(5660300002)(8676002)(55016002)(66946007)(66556008)(107886003)(83380400001)(64756008)(66476007)(4326008)(66446008)(54906003)(86362001)(478600001)(2906002)(110136005)(76116006)(186003)(53546011)(33656002)(6506007)(26005)(71200400001)(316002)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: y615vJgedGYjiNM9bSEvWOmDjkEt0aPjy5Q+0on7r0YJIvtzqrs+vN6Er/o+U/+nOiVJdAg3qycOkWddFgpaSIoQtRmGj1oSjQJhomjNnH+J6WlXJnBdO7A96mI9yTCOCBPLbtfQwftbQImNq7fCPQ8rwpmRivruE5CXFSJargAluTT4/YkP5GqNlIvB9Xz3vUz3vmvbPFTmak5ROIdMMOBLwYweAP5lytubB/MXmbH1ijHQ/Gx80BCV8/48i/pHiYTk+aqSbJJJkLfSRUJbDgb8p21zhZUdaXHT0wVVLhKJLX/pLEixE9ktC/N+9+25llWJtLWeXhl93FVx9NnuM+zsCi+jc/1fOd4AkiKb++j23ae+EucAgVuI943u3f6tqNlR9eqR68ktm9gcj2boP3wzk3HBptJs+IhCdgS213Y2m0+XA5Ud7YsC6HxrAQNZIYyh1AzeHIw9OaoI5cd2hXVVDXQERLJCpzZat1u/6DU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3174.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a548dc0-c425-434a-c9ab-08d833dcd47f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 16:31:22.2672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OCrBbLgk1anIFop2SZEFwXE5F5P3Lwd27+d8VGJvEtIi8jMgkp1IUs/MqDjCYoAwT3w1x5A6WJ2HZcf3Gg452g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2567
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACK.

Thanks,

Brett

> -----Original Message-----
> From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Sent: Wednesday, July 29, 2020 9:24 AM
> To: davem@davemloft.net
> Cc: Creeley, Brett <brett.creeley@intel.com>; netdev@vger.kernel.org; nho=
rman@redhat.com; sassmann@redhat.com; Kirsher,
> Jeffrey T <jeffrey.t.kirsher@intel.com>; Nguyen, Anthony L <anthony.l.ngu=
yen@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: [net-next 11/15] ice: Allow all VLANs in safe mode
>=20
> From: Brett Creeley <brett.creeley@intel.com>
>=20
> Currently the PF VSI's context parameters are left in a bad state when
> going into safe mode. This is causing VLAN traffic to not pass. Fix this
> by configuring the PF VSI to allow all VLAN tagged traffic.
>=20
> Also, remove redundant comment explaining the safe mode flow in
> ice_probe().
>=20
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 59 ++++++++++++++++++++++-
>  1 file changed, 57 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethe=
rnet/intel/ice/ice_main.c
> index 9b9e30a7d690..a68371fc0a75 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3583,6 +3583,60 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_=
rx, int new_tx)
>  	return err;
>  }
>=20
> +/**
> + * ice_set_safe_mode_vlan_cfg - configure PF VSI to allow all VLANs in s=
afe mode
> + * @pf: PF to configure
> + *
> + * No VLAN offloads/filtering are advertised in safe mode so make sure t=
he PF
> + * VSI can still Tx/Rx VLAN tagged packets.
> + */
> +static void ice_set_safe_mode_vlan_cfg(struct ice_pf *pf)
> +{
> +	struct ice_vsi *vsi =3D ice_get_main_vsi(pf);
> +	struct ice_vsi_ctx *ctxt;
> +	enum ice_status status;
> +	struct ice_hw *hw;
> +
> +	if (!vsi)
> +		return;
> +
> +	ctxt =3D kzalloc(sizeof(*ctxt), GFP_KERNEL);
> +	if (!ctxt)
> +		return;
> +
> +	hw =3D &pf->hw;
> +	ctxt->info =3D vsi->info;
> +
> +	ctxt->info.valid_sections =3D
> +		cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
> +			    ICE_AQ_VSI_PROP_SECURITY_VALID |
> +			    ICE_AQ_VSI_PROP_SW_VALID);
> +
> +	/* disable VLAN anti-spoof */
> +	ctxt->info.sec_flags &=3D ~(ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
> +				  ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
> +
> +	/* disable VLAN pruning and keep all other settings */
> +	ctxt->info.sw_flags2 &=3D ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
> +
> +	/* allow all VLANs on Tx and don't strip on Rx */
> +	ctxt->info.vlan_flags =3D ICE_AQ_VSI_VLAN_MODE_ALL |
> +		ICE_AQ_VSI_VLAN_EMOD_NOTHING;
> +
> +	status =3D ice_update_vsi(hw, vsi->idx, ctxt, NULL);
> +	if (status) {
> +		dev_err(ice_pf_to_dev(vsi->back), "Failed to update VSI for safe mode =
VLANs, err %s aq_err %s\n",
> +			ice_stat_str(status),
> +			ice_aq_str(hw->adminq.sq_last_status));
> +	} else {
> +		vsi->info.sec_flags =3D ctxt->info.sec_flags;
> +		vsi->info.sw_flags2 =3D ctxt->info.sw_flags2;
> +		vsi->info.vlan_flags =3D ctxt->info.vlan_flags;
> +	}
> +
> +	kfree(ctxt);
> +}
> +
>  /**
>   * ice_log_pkg_init - log result of DDP package load
>   * @hw: pointer to hardware info
> @@ -4139,9 +4193,10 @@ ice_probe(struct pci_dev *pdev, const struct pci_d=
evice_id __always_unused *ent)
>  	/* Disable WoL at init, wait for user to enable */
>  	device_set_wakeup_enable(dev, false);
>=20
> -	/* If no DDP driven features have to be setup, we are done with probe *=
/
> -	if (ice_is_safe_mode(pf))
> +	if (ice_is_safe_mode(pf)) {
> +		ice_set_safe_mode_vlan_cfg(pf);
>  		goto probe_done;
> +	}
>=20
>  	/* initialize DDP driven features */
>=20
> --
> 2.26.2

