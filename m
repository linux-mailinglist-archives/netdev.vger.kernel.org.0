Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE902F3760
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403925AbhALRio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:38:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:3029 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbhALRin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 12:38:43 -0500
IronPort-SDR: uTK0EbRs3rhRRY929sJZf8IrbK2/ExmipS43CfYOH/bQukfpoTswAEWCmdx7OAjwk/OVlZieCz
 sRPNfk4iPHwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="178172606"
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="178172606"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 09:37:56 -0800
IronPort-SDR: D+6fjQsk27L4AvKE6x4x0yTd//SA7Rn38LEKjM+hg7TXZU1C8PBa3vzAsU3XKKgH+MZ7Q6K9+T
 BoMQu3Gkk2Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="345273948"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jan 2021 09:37:56 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 09:37:55 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Jan 2021 09:37:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 12 Jan 2021 09:37:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTHxjNAqyK4RYTabFi7Zk5n30Jqg14WMJ7i0WJW+3KkN5U/D1JK8Mhwt4LR8N8+JK68Ub44HxYH8oukG0nqY5Ql8H58BrqOBmHByn4Pto1EdwQB4KZj9Lx5GOP3P8HNHILM7fcxhCPiS3KpnkPSi6xeYXAnA+yoInFA0C9+g+RVf83Ou1rWizXtqPr1F6mugP80/TPAnzYOCYXwpmuejin+aJLixJktNdHlYq1lulZ3Yss0WmH/4m1bSPUw8mJBo1RHHrQS9q2syoRFdiFXxu/Cc+An/16YWXtxOKrNXCmtN3Ku1C7SxHvNwaQb1jXOXAJgmHU3yq+zvA2hwxy6j5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEF1uzU6+YcmarESEp6sIy9uYOJ3T1/B7LmK9SSNcVE=;
 b=mnRaJnOMbabUczetqBGAYv4vQuNdzIkrdYT5mtaqUHJXkyZt7kdsXFn8J/XZjtNEoPfb2xiKBo556IQEZQNU28SoO0B+sPvtlZVJ3dwQe4vRKIAdf1VDzDbdkMTm6JBAlQq+uYW+xIdDZnPtoOKlxX3q9tnYW8ZivqQDoDbvFTmT02ZpO/1Efh/dA/EG+l28F4ojiT0g40iDg1hN0vdWfzD4gIlWvxSejLOitLQ4R2t+PulwGmBOpyJSjhlpQWUZqf3mPwnaYMEVj8DBPtx4y9LdCApLjfEYlfgZWI88xRXI3pnx6rZub89mo7Gopw1jyKZhCLoxLB1k3sxa+bdbKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEF1uzU6+YcmarESEp6sIy9uYOJ3T1/B7LmK9SSNcVE=;
 b=Ss0n2kLsIJYzYP/IUw29Rp/pkdIdBiKz5rc7gbaP5lEwd0vhDedDyG9+zUzneaTYPlYQCPf66SoWfcy95o0EkrZBPbAY9oshSX+jhktxi18xR1kw1yn+mpsWICUuECU0wUAbRT9DMj8pLvUrr6BYaHbjF5eL1tU+weGoi/7doJU=
Received: from BN6PR11MB1572.namprd11.prod.outlook.com (2603:10b6:405:e::9) by
 BN6PR11MB1393.namprd11.prod.outlook.com (2603:10b6:404:3c::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.8; Tue, 12 Jan 2021 17:37:53 +0000
Received: from BN6PR11MB1572.namprd11.prod.outlook.com
 ([fe80::d89b:cd03:de56:6d9c]) by BN6PR11MB1572.namprd11.prod.outlook.com
 ([fe80::d89b:cd03:de56:6d9c%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 17:37:53 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: acquire VSI pointer only after VF
 is initialized
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: acquire VSI pointer only after
 VF is initialized
Thread-Index: AQHWxxusGWmKZMrqBkC6/aAqKEo8Q6okhGTA
Date:   Tue, 12 Jan 2021 17:37:53 +0000
Message-ID: <BN6PR11MB15729586015B697F769A2426ABAA0@BN6PR11MB1572.namprd11.prod.outlook.com>
References: <20201130131257.28856-1-sassmann@kpanic.de>
In-Reply-To: <20201130131257.28856-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [188.147.103.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf0236e6-ad28-4cb9-2e63-08d8b720ca6c
x-ms-traffictypediagnostic: BN6PR11MB1393:
x-microsoft-antispam-prvs: <BN6PR11MB139331CCEA6E50AD9D73F875ABAA0@BN6PR11MB1393.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EGOET5fxty1IMpfqgSDFm/I3iEEOyYp/NrovSEBLU0qsemOIQX3Y1sv3y2wv5OXMUFfzf9nvq4sghfuu+p3Iago2GzYaX0m9haTJxggV/qKyBU4nj6JAwtOpUXnYzvjTng459eLiIeoj1hra5Ja6f6Nl4IvQ5O6IzUOg71Wq+F6BGx7n8c4tcz3FKIhorsckK2Kd26zk6dyOoIxj4Xl3kmrDIW9sAK17v+ZBaSQs6GnM4f7vS5InffwRpbynqnzEEVUwJWw57de/ak1uA69QQ4wPXnOcotkovP96dbAedCBdTLo2SlWp34XyG2RvyfcyQ7xQ2csQPOSdxWFEPtv1mheDp3h9pvhscoknTTiKq2R+vDzdNeNaeXooLvUxGMSA383GPmRd65MAdk0J+BBN4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1572.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(55016002)(53546011)(186003)(478600001)(8676002)(2906002)(66446008)(86362001)(316002)(71200400001)(83380400001)(66556008)(64756008)(6506007)(8936002)(54906003)(9686003)(5660300002)(7696005)(4326008)(52536014)(26005)(66574015)(110136005)(66946007)(33656002)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-2?Q?n46H82qR1Zofh9QzddmgG6YAnGNL4lPepPquX06ftKCegxtZS63rroiJsg?=
 =?iso-8859-2?Q?2vtQNg+lT04t7QbGfLhRMf33WFa58EYLEP75WW/w03R+AqhZcatgC6TxvV?=
 =?iso-8859-2?Q?ABXMLyuTeURwOV6fKtkX82gDWVXQ4qZEppuTeyWYqVHLY31rmzhLbqY9E0?=
 =?iso-8859-2?Q?snl1m3w6rDonHF5s06WMzHiQAZUv6UHcvM/kJs2BEDmGyD1FII7rURljZG?=
 =?iso-8859-2?Q?HnmrRLDxhIMVYC1IZujEAaOLk4UKYVJyalrLexsatTXBCEB/y7SWjE3b1w?=
 =?iso-8859-2?Q?NS81fnshRQJ3UjhhEFgMnPeofNLnsJD5/mloDmoozdAfOLjaj7u9sMhoEK?=
 =?iso-8859-2?Q?dgZtt3xz3JDZq6p62G6QW1CfYPKb3gOJSh8yEtOhVbNwrdk/k/xhQ/oVx4?=
 =?iso-8859-2?Q?+o6yaq8Z8nndFeyBC4QxqLfCIifetyNr0NbZIwIjM/Ib/pns2870nMK9Xx?=
 =?iso-8859-2?Q?J6pPg0QwlwSlrZfQ5/WuzAt9wXu7wMl/qaxSZIzih84tV4kbMRvrxzADR5?=
 =?iso-8859-2?Q?EcsJWjim16NIzqhBEwURL0QIP21tnZ555OhYRtB0Fas03GlqS4sytInSEf?=
 =?iso-8859-2?Q?0n5NMpQFTuo0V4HjAHY50Dne0keZlh/PYDaGBo6eueTAQl39k0jelZgJa5?=
 =?iso-8859-2?Q?2VvUBaDuFRuLnf6U45oJSAbXnFRl72XAUXW/gCveC6pt0tp9SBKNS0H9ua?=
 =?iso-8859-2?Q?a72cZ66fzrEYOHvaiY6BkVurvEW6WlUz7q50QF6AV0A1WtPrL/GPh2A00q?=
 =?iso-8859-2?Q?IylM7RxGKFbUu5RgYK5rjdyMmWvL11vhPQYU8w1/CJ1+oe6MnxxzqKn6La?=
 =?iso-8859-2?Q?Wd9ys1xPjmgDtGJU/lF9Wo+3bodHi/hbc72UR+2bK97SpNK42yRn7cPkXo?=
 =?iso-8859-2?Q?Q0xO1zhnmd1aXwvbL1OLVROIE7GUhqWPysC5HkURmo4fyGzSiP2l5M4yKM?=
 =?iso-8859-2?Q?fonIugH2xpLCIgsAVRcnO8fZhDFiOvqG15OOQgXkZq4Vp2dvVYtIeu6CCL?=
 =?iso-8859-2?Q?KCspTo8zp8+LVocn4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1572.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0236e6-ad28-4cb9-2e63-08d8b720ca6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 17:37:53.3730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERgpVSwn2obouvHYUNxtSS96Szpiq15BeouL49jj+8udpM8Qpn+D7QxZgnymcNLT6kf0DrQvNldGkGn9XSzhh9lfZdLL5d1mrAMXBuRGQO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1393
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Stefan Assmann
> Sent: poniedzia=B3ek, 30 listopada 2020 14:13
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] i40e: acquire VSI pointer only after V=
F is
> initialized
> =

> This change simplifies the VF initialization check and also minimizes the=
 delay
> between acquiring the VSI pointer and using it. As known by the commit
> being fixed, there is a risk of the VSI pointer getting changed. Therefore
> minimize the delay between getting and using the pointer.
> =

> Fixes: 9889707b06ac ("i40e: Fix crash caused by stress setting of VF MAC
> addresses")
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> =

> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index 729c4f0d5ac5..bf6034c3a6ea 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -4046,20 +4046,16 @@ int i40e_ndo_set_vf_mac(struct net_device
> *netdev, int vf_id, u8 *mac)
>  		goto error_param;
> =

>  	vf =3D &pf->vf[vf_id];
> -	vsi =3D pf->vsi[vf->lan_vsi_idx];
> =

>  	/* When the VF is resetting wait until it is done.
>  	 * It can take up to 200 milliseconds,
>  	 * but wait for up to 300 milliseconds to be safe.
> -	 * If the VF is indeed in reset, the vsi pointer has
> -	 * to show on the newly loaded vsi under pf->vsi[id].
> +	 * Acquire the vsi pointer only after the VF has been
> +	 * properly initialized.
>  	 */
>  	for (i =3D 0; i < 15; i++) {
> -		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
> -			if (i > 0)
> -				vsi =3D pf->vsi[vf->lan_vsi_idx];
> +		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states))
>  			break;
> -		}
>  		msleep(20);
>  	}
>  	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) { @@ -4068,6
> +4064,7 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id,
> u8 *mac)
>  		ret =3D -EAGAIN;
>  		goto error_param;
>  	}
> +	vsi =3D pf->vsi[vf->lan_vsi_idx];
> =

>  	if (is_multicast_ether_addr(mac)) {
>  		dev_err(&pf->pdev->dev,

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gos=
podarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapi=
ta zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i mo=
e zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci=
, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek prz=
egldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). If you are not the intended recipient=
, please contact the sender and delete all copies; any review or distributi=
on by others is strictly prohibited.
=20

