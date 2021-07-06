Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1443BC79E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhGFIII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:08:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:26471 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhGFIIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 04:08:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="196356558"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="196356558"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 01:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="491235226"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 06 Jul 2021 01:05:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 01:05:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 01:05:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 6 Jul 2021 01:05:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 6 Jul 2021 01:05:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tt+9l9V9eZXuqG//PDsGkTbCQnUyCrYGH+6KBi3lO0GhC1L8fNDWPkdxQWKxruosFPc9mQKLDsyDlbktgK8kZ3lTHzuEMREJGXCdn6mnjOqpiHsltayQcfd+4Mmt31MLmUFKRGgrix0BjcgVllOObH6oE8UKDp4KtzTx+Bke/7vb06IE3kDTdjYKVpWygZ590hWZ3XPGBRpX7WpIhUWFwKh+aQodrUu6AVoRR+hlDaHp+3F+8Z8oQ3reFDNlJ8W58g5DvrHr2knBGACPddrJ7MTX4iT+vB/OHLyBmYC2Nl1k6kgbrmAHzYwrtOfn1FpOIfNGR6QFTTjAQbSZsRlmDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40gKujcbf/Bih3CBi3Vp+CLH3jBHyn9KiRQc2CKegvw=;
 b=Y+I5nh3W0kw/YXjuEG0OBIEPMNv3txUrEwsb+PW/G99L+2KnFStQcHXvGaP5zwTN8Yg834hq3IFu0C/qzOJ00nItbsYQ90GDb2wBeDAZo+S9FtJDahC+g80ERA5mt0Dz/cjr0O5EdkVOdvIUb1hmDgv7wEoy6JFltSXupmiQ6O1XHskstXmkcDEAFiIVZOsm5440/hu6d3EU0y12uSZOLMsX/P104a/3OENickSEAS42JjW/qLPMfBndEAJIrO/DoPIcZJzNfFerSzJaDCVVWFhdnQ/oIABCtWWHxnbxjrq5jV6XbAG7jW+ghJpYEGNB1hAY9BBSxiIBe+OuDgCaVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40gKujcbf/Bih3CBi3Vp+CLH3jBHyn9KiRQc2CKegvw=;
 b=cZZJL3ZsCyiv9Iqd0EOSKz0KCq2hZwjUUzWh+stD82m3ixIC0RiktjK//mw+GE9A/OQBrdEWufJwO3MWevzX9+TXiTGXTSyd73q/aRVEjGzhwT0gV5mzFJwZkAIzUrdC3mNp82WYekjNULfVxlqovYuL9DstM5LZ3/IS6HIwydg=
Received: from CY4PR11MB1576.namprd11.prod.outlook.com (2603:10b6:910:d::15)
 by CY4PR1101MB2262.namprd11.prod.outlook.com (2603:10b6:910:18::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Tue, 6 Jul
 2021 08:05:24 +0000
Received: from CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::b1bd:33e5:3890:e999]) by CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::b1bd:33e5:3890:e999%6]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 08:05:24 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: improve locking of
 mac_filter_hash
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: improve locking of
 mac_filter_hash
Thread-Index: AQHXENqT0RGb9oqT0EKJMtq5UAkn6Ks2WXog
Date:   Tue, 6 Jul 2021 08:05:24 +0000
Message-ID: <CY4PR11MB157684F676290E6B6544F961AB1B9@CY4PR11MB1576.namprd11.prod.outlook.com>
References: <20210304093430.42421-1-sassmann@kpanic.de>
In-Reply-To: <20210304093430.42421-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [188.147.96.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87502323-1cd5-44eb-e96c-08d94054ceee
x-ms-traffictypediagnostic: CY4PR1101MB2262:
x-microsoft-antispam-prvs: <CY4PR1101MB2262A2D5EB6596D9F4E847BFAB1B9@CY4PR1101MB2262.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fq1bPZK99X7OVkw7cA4xOBtBoupzyQUncg53FcuHKCXChbjS33tTzMrYcYvMq4HibBH/86QpCw6HawWuXw2F7HsKLlEaJ3J5XiYo2GCG2LL52cBg3ZmJ+4X9vijtx/osraHYzOvNM90oJdkZuDHs81lMpIJmZoXRmVk1cbxafeaJEhFXadcnpb10eSFQ3pFSydmGNQWiOIaIZDbw+N5ipJXb7bDpKinD6nSCHQ4IXh9P2GVsbCZf9G+nMBxWgegp12ENBHRvIvkfVUgHmOMhZtqPpfxrDnu2Hq0AkP2VPXsaAEpRFqUKjzw8DPXlixO+OfrzyQ1USoCMKSmu4dNltXcD4AptzzNzynMj446h1BJ+24j3CuCYSDMQpeBDMHB9sQD77Jgp+dLp1TheKbNBYLcFmiaNXKmmb5tjMPRO/DYRptfSFmXWuFO4pQV66xadAfCMPsSz51AdLzexXRGvCGynUoGKptCMm1uuZk7fyxU2PjVMCrIiM1m5j/yT5eEChRXZb8qGBXoMrgKYoPnsTxLlb97oCXrx1mLiwLlw4Hdn5YF+E7x56oBD71AQZDk+NR9tPDIMHZQw5XRcZldsgGk2L6dvymNVDWhcE99IBwQtzdUrcOf9+Ql4iSDOsKcE9VjCY6qN+KXjChd/kibmzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1576.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(8936002)(33656002)(186003)(55016002)(6506007)(83380400001)(7696005)(64756008)(66946007)(26005)(52536014)(8676002)(478600001)(54906003)(4326008)(110136005)(71200400001)(9686003)(66476007)(38100700002)(76116006)(66446008)(53546011)(5660300002)(316002)(2906002)(86362001)(122000001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x+i1j5bJM9ryqkc3rQu/xvs3yfME+ELmUE8taAZJgDI7d3BdW2u+3F6q72fw?=
 =?us-ascii?Q?8M5A7CRcbI5pD4Rds/M+IYljsjEuBao8PN+K1Jxgoii3eWZA0c04dXQGDWee?=
 =?us-ascii?Q?leLOpW1BUcirUl7cVsl2b1cgpdYE1er8Z2S1Qxg6tgfBjYhFth7Z4dIuwT20?=
 =?us-ascii?Q?jaypSnD6ibM0MG04PaNzioV0wcCs6EEP+xBqkSY8QjwJLsLJoFBTXUDp/MxG?=
 =?us-ascii?Q?rdeiLq5i1OeksAS/tE0dYnn834nWe/j9A4ITeh0mgDjSw1GulRddP5rkpGQy?=
 =?us-ascii?Q?bp8Cf6rR63oa6lyAypUhAJEwtDmGSNxGyuepRjNdiBqpePUvyDy8FxwJ5qkG?=
 =?us-ascii?Q?w2hf7zsKQ8qgpwFmXG95sFGX9iG21zInHcvkacSLvwtc29Mwh7Fcvs80T/SB?=
 =?us-ascii?Q?RjygaxwisNaihcC3uL7dw3+NfmJ014ph3UIjurCuahUWEdwcj3p/v4NO+go5?=
 =?us-ascii?Q?4pAFqirb847rBuSKJzCaxYlIKIkvGzjzzGdQMu/KyKJQS9C/s4oZqB1qSaS+?=
 =?us-ascii?Q?qC1MHe5nLsfNgwihX1ySSh5kxS5P43o6fGEit8ZBXHyRFBqKiT5nHOd8tI02?=
 =?us-ascii?Q?DgNSxPogBpGyodFzJN5otO0Hdmit27czdRXmLCtHIpDu7y+diLNoqLoMMGcI?=
 =?us-ascii?Q?tAviXDSe6z53av9AbpPHthkO4B1vE6T9nu3crtsVE4usC+d4ra13NOwe5knv?=
 =?us-ascii?Q?XaCTK7hqEsrYkd7dYdSuSLA02Uf/v0KYBc6VPeWPrKLCbae43RDJOG6yBhbk?=
 =?us-ascii?Q?ysFvbqMv9ngAFYcCrVFGI70680WbzNlewP6SJ+2RKjzGCTI/v4H27m4fLwRJ?=
 =?us-ascii?Q?clv32OPdC+HPnGkbbqBAipCcg8f1o+p0/AJ80fnk778lWhreQxb+E5XxwvZH?=
 =?us-ascii?Q?ZHpuWVWdDVnh6b4hIylKhykyujCicVauqt+ikQ68R9tRMXsR+iEHWyj3Sf8F?=
 =?us-ascii?Q?BGp0IffxGOXY0V486QzUNnCsNZBeWO5h1lV5ysulplRFMokIln/8eaArfkBT?=
 =?us-ascii?Q?UXCWS45+FDe2Zvs3TmYwEWcmTA6P5a9Xt1Lt1WmnxWd3IakSgYVRg6oOh+gz?=
 =?us-ascii?Q?Z2KIWIKRdfxJiwRo32sUI1hcLXwZ5EqifKM+91Nt7q+q7fChADyrZIERyfSv?=
 =?us-ascii?Q?snYJkOtrFjtBItXYlYmYA68Ie/feWE9eQkrtdLweh4OoywK6D39PRQZZXlG9?=
 =?us-ascii?Q?nAWamEiVAbRKsLAHe9cOtXMUJc7dIktqNz68x74wMtlJiEpJhXjtDg7l86g/?=
 =?us-ascii?Q?XeyvmIUW5ujk6WXAThOwqjXJLy5OHyl/HODa5qLOdT4SOzylS1fsv9pT03CG?=
 =?us-ascii?Q?nOT3fHBpxfKmoiAipBilUFA7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1576.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87502323-1cd5-44eb-e96c-08d94054ceee
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2021 08:05:24.1940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n312t/6WXvUW0vS/EG9niLJP+bU5fTJ+UzpUpFEIH46hzgs7BmdC/yO0Yokuhu8FvYTaEltJ/P/oP2fK0O2vtDO2lXJhJTGGzlC/Af/FFYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2262
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Stefan Assmann
> Sent: czwartek, 4 marca 2021 10:35
> To: intel-wired-lan@lists.osuosl.org
> Cc: pabeni@redhat.com; netdev@vger.kernel.org; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] i40e: improve locking of mac_filter_ha=
sh
>=20
> i40e_config_vf_promiscuous_mode() calls
> i40e_getnum_vf_vsi_vlan_filters() without acquiring the
> mac_filter_hash_lock spinlock.
>=20
> This is unsafe because mac_filter_hash may get altered in another thread
> while i40e_getnum_vf_vsi_vlan_filters() traverses the hashes.
>=20
> Simply adding the spinlock in i40e_getnum_vf_vsi_vlan_filters() is not
> possible as it already gets called in i40e_get_vlan_list_sync() with the
> spinlock held. Therefore adding a wrapper that acquires the spinlock and =
call
> the correct function where appropriate.
>=20
> Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
> Fix-suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index 1b6ec9be155a..61d3e9a00f65 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -1101,12 +1101,12 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf=
)
> }
>=20
>  /**
> - * i40e_getnum_vf_vsi_vlan_filters
> + * __i40e_getnum_vf_vsi_vlan_filters
>   * @vsi: pointer to the vsi
>   *
>   * called to get the number of VLANs offloaded on this VF
>   **/
> -static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
> +static int __i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
>  {
>  	struct i40e_mac_filter *f;
>  	u16 num_vlans =3D 0, bkt;
> @@ -1119,6 +1119,23 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct
> i40e_vsi *vsi)
>  	return num_vlans;
>  }
>=20
> +/**
> + * i40e_getnum_vf_vsi_vlan_filters
> + * @vsi: pointer to the vsi
> + *
> + * wrapper for __i40e_getnum_vf_vsi_vlan_filters() with spinlock held
> +**/ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi) {
> +	int num_vlans;
> +
> +	spin_lock_bh(&vsi->mac_filter_hash_lock);
> +	num_vlans =3D __i40e_getnum_vf_vsi_vlan_filters(vsi);
> +	spin_unlock_bh(&vsi->mac_filter_hash_lock);
> +
> +	return num_vlans;
> +}
> +
>  /**
>   * i40e_get_vlan_list_sync
>   * @vsi: pointer to the VSI
> @@ -1136,7 +1153,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi
> *vsi, u16 *num_vlans,
>  	int bkt;
>=20
>  	spin_lock_bh(&vsi->mac_filter_hash_lock);
> -	*num_vlans =3D i40e_getnum_vf_vsi_vlan_filters(vsi);
> +	*num_vlans =3D __i40e_getnum_vf_vsi_vlan_filters(vsi);
>  	*vlan_list =3D kcalloc(*num_vlans, sizeof(**vlan_list), GFP_ATOMIC);
>  	if (!(*vlan_list))
>  		goto err;
> --
> 2.29.2

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>

