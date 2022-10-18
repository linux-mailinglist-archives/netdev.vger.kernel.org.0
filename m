Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97BA160336C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJRTns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJRTnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:43:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530A37A524;
        Tue, 18 Oct 2022 12:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666122224; x=1697658224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xCESRguzM/KCVjM1UZvMWYEuUGm/wf29Za14UfRh7kQ=;
  b=SCxT//iD7fcrF4AJzA7miSg86HEJFjrv9ZXZrixMYVy1saO9Bz3/O3TY
   Du0SbOy9wqTDEFoemetdm700KbpwjeBRAiDeZ9YtwqA7QetvsDYW1OtQC
   x4ls4qJP5DDdSlz1HuyZblrI609L2FIcw5VhBCKBK1KB/ZcVD1tMoTxi+
   rUsmK5Y3CBNfuqBYChoMbgQqcZs/cFGNHQAzKEakibuwoWF8bVOlHABhe
   KjT1GnoD+NrrRDEc/MqvBSOFXLnKjleUQqaiy0NH0mbD0ze+WO3MD8OTz
   Di6cxJVFe5MWjRkU/7r0pZjdz3JjeclWz+CEPU9cVl+EQCl/Rm7QHyxnW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="293612145"
X-IronPort-AV: E=Sophos;i="5.95,194,1661842800"; 
   d="scan'208";a="293612145"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 12:43:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="691987323"
X-IronPort-AV: E=Sophos;i="5.95,194,1661842800"; 
   d="scan'208";a="691987323"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 18 Oct 2022 12:43:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:43:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 12:43:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 12:43:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 12:43:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZCbCtKM+O3WVBOgSiU38N3q2IeCIJyye27uHza/szZFaojdQbSrHiE1y/8QptLt8TgtbCPZhovxDhQomfjM/006ZT5GEvcyzR0/y0LOXxdCm7oIXCAcva//Nge2tIWhgt3Q2g+OMkiF9+kv9DgWi09UEcM16JLjRCIjAOyInSA4y6RmiUNWTJxzee+oWLUjGvTUqyqzwMsAveyeZV8AKNpWh3lUa55AIQ+PCbzzER1FeiE1f0i4M4LwztPKyHw+gi+fZc1u3a0dXmd9ZcG6MGon6qaEmgYF/pv2v1b0ay9PalIiQkfieJYVYWX1OaBLro6BwnG+RiQw/MgDwQv9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8v709TrImX/Akdemy9ue1W+xbyR8hEEHR8VHMb5GvM=;
 b=BZjwbb9jo1YfEuWuDJ1E8zg4bEZEJpu3XsUwug8tyIX6FjKT+avsNalH32WN9XkAmA6c0bpYs+T4ETkffDuRQCjB0qfvbMaBBsmEuTRfiJj65nPHPW934NiBaB3p4T5rXyB6saE4K9M2sUPylqjkl0u7B7qM2pravdZU1O/+1Oou4moS4WBJKZGWYQpQFn0JGmCYaD9Sys4dxlo+i1uWLdP5cBOqYDo7VKyneER+NXgTXE0yMpdZq3w+H2YF3TSQuZeVsgvTvBPBv50+39YMoWz9HJqrf6vTdFD5c0kmiaVIeTpk3n8hdK9AkKamaGrlxZ+iyfMjLXAxsynl13byBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5162.namprd11.prod.outlook.com (2603:10b6:806:114::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 19:43:39 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 19:43:39 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "yexingchen116@gmail.com" <yexingchen116@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "joe@perches.com" <joe@perches.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ye xingchen <ye.xingchen@zte.com.cn>
Subject: RE: [PATCH linux-next v2] iavf: Replace __FUNCTION__ with __func__
Thread-Topic: [PATCH linux-next v2] iavf: Replace __FUNCTION__ with __func__
Thread-Index: AQHY4pRmP/aRRZzjzkSYKlQ3Cy9uc64UjpSg
Date:   Tue, 18 Oct 2022 19:43:39 +0000
Message-ID: <CO1PR11MB5089B2FA5C1CB0E2064E4E34D6289@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221018015204.371685-1-ye.xingchen@zte.com.cn>
In-Reply-To: <20221018015204.371685-1-ye.xingchen@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SA2PR11MB5162:EE_
x-ms-office365-filtering-correlation-id: 0bdb8398-ac66-4041-a1fe-08dab1410dec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YFt+ftpAfZifB/jHaCrNyVf6uW5w+pYSvY6r726yK6/A318kHxjEykTcQx7b3BQOKRqxhwWgAbbC/4qqXbTRoeI31DH/sr1BOZ7NFxYDgIWgKTSzIhVebOsGx3NiZQdU7Wc+lA4BWIVlRRTKNq1m10ixG33s9ZC0oGUq0Hmje26WYre1avt3OmfQw2v1rKHCinDPJF0CRHmW8CyEelCvFLlhDmSWyFGYzHL/8ELslpfix+Hs4WXidKVl8l0F78PTL+2SkxtBMGgooE5uhlygIzZWceiRauP+QR0o0uWxFLSaSVCDyIoEnrrVnVUufP2FL/68mDzCIgLNwafRy1RSEsrhvZ/K67sTWJhlCC0bzNUp3AAUNEO3Y7KnWVv/EPI+IHRm60qtcVmCc15fTmPPlf4Df/i524X/T+/fc7TIqVAco5rj8RbcBuf0bYh4An+245vDtPo6jq2DiBcraNl7i62YAicfLNNL2VA1IQPCMtfkuXEVENK0JpESavtpJpZxKPIItjmDidQCAo290nNpK9ZeQZEvWIR3rPsRP3s2w0d67qJuflvdvED6bUVgHZr3PtcVKggXJXuWjFS9GcAx538zBcfJrlOEgpPJW0fIJdcwHHfyjUCCSqbSfZJ2tZvY3uRU2R0mi1Zbhr4fb9fQ8eyyeIcnyJZIw0YCMzU5qVdy4BFOFN0lOBj0Nigdof/7hbhlci2FPqZqc8TzPcdsbBhwUk2+prB3K5mK8UZZfYm9rmya2WK2iD+Ap2h9qWgKCG4+DQIYxQTsufv4Lf9aUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199015)(6506007)(2906002)(8936002)(5660300002)(52536014)(53546011)(86362001)(33656002)(7416002)(4326008)(41300700001)(26005)(9686003)(38070700005)(186003)(478600001)(66946007)(66446008)(64756008)(8676002)(71200400001)(55016003)(76116006)(83380400001)(66476007)(66556008)(82960400001)(7696005)(38100700002)(6636002)(54906003)(122000001)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?94GCX8IxW97hobJ0woEtZDv+k+oQD7ClNf7egPr3BbTJ/UhyWP5AIUlkrbKa?=
 =?us-ascii?Q?l1uniLNNXDbkasgqqWQ8Uvn9R6hEHBu32aHrX+gNDptm03W93XxLGVKN29Uo?=
 =?us-ascii?Q?DvZT7lyDcHVSV487x+nojjTN1038yhBo61wXwFOqB11Mfe93054P4f6xOgjn?=
 =?us-ascii?Q?mFzMyDDMfFqqMxC41k4jTQw3KBELCqO/ns+fgA2sY2UNbO37+Idl+rPKIZSO?=
 =?us-ascii?Q?k0kJUvqDh5i4su/qFsG2Ibz8LfpX2pZ0nT4yKIPCjQ7oCVstB0zMJI95roOY?=
 =?us-ascii?Q?Lc5oleCBibKcfyy3NwmKV0HWAB98R+HVyajM44HVlfsnMJ08hWpnP8zZudsX?=
 =?us-ascii?Q?kbNK3liZhwhZ0lPzxwigjFN7EBDDKa4F6yapf2iyK4t9qK0dVWe81FDsQdGz?=
 =?us-ascii?Q?8+xRFC4ncbhm1fmmA8ZIgdPn961Z8FgbPVJHDzckpc9boHkOjzOIQ2x4jcBG?=
 =?us-ascii?Q?PsiXWk1abj39fBDccQvm4yxc+wMe+rIbQ+jeixxD8yCWUBLp2+sjoTf6ByIh?=
 =?us-ascii?Q?8tV+VabitUig0dVW+yhYPQyFHcs3Gz/bvucSb92iQIhnioGosLvWxiQlqz+m?=
 =?us-ascii?Q?KslbBeprmQ6Dhg2hy1Nz/lzOjIDbRpVnO+HtwVnaSSZj6TzK1N6Ky4X5lvlV?=
 =?us-ascii?Q?Xtcl5Lj2rhjzN33d/EpOdmrAHAvjsK6NqdghMIpPcSIFss+mJMjFwVOkXTab?=
 =?us-ascii?Q?RL5YYBgnwfsZpvQdNQzhp8ab4BbfNd3KT7SNQrSghLWwsOK2Eqy5E79drXUx?=
 =?us-ascii?Q?PC3OSP7/sbcvobYYmUqLdxd/qbcJx2hPW8QRlDLZPti/rJ6oL6u5XxbIzvO1?=
 =?us-ascii?Q?nvrs33aiOjZub8rb4wGOiiz5pmFsCUgLb572egHEAN4fjsBEtDN/5aiCzk/G?=
 =?us-ascii?Q?J1IAHMZ0Q3YAfRp+9tLhbbdyTp+B06bfhrnZ5DusXO88fTllJg0v/GC9nmme?=
 =?us-ascii?Q?nIGLW9jkLltrfBzoniWyQQbgXyliYZo02UgAp5UoImY65MiGCbbFIDF1XHo0?=
 =?us-ascii?Q?E3lN3q2T3dYHeANpUDbe9HL7HZyNCd7rpDxVBdFJvA7r7+2j9S972KbyKe/e?=
 =?us-ascii?Q?2waW4za8pdkDKCuWlnFNhLdxSYT4KA4KWUcZIE6CDb0SWrt7iAj/WlVObmad?=
 =?us-ascii?Q?HbLevFfc0ECuV9EjXGw+KGyr0DQMATr2OpmshDzora5YKy796GUF4uMjfm68?=
 =?us-ascii?Q?+rISMtNprmmXIKvdudy+8xImciEFr+uaVl0baIpahc+AsT8dOVT+oTXUoRNe?=
 =?us-ascii?Q?c/V1xkwSvtRzFnEyLF0BXzxPu6WZaSIK615RJn3ClcWytgcm5PM7n/vLVS+3?=
 =?us-ascii?Q?aRJODNhpUFq1qebkC3RuL/LlysufmTm/sVvpZAyYyoCuMkj5DXQSUpta1W34?=
 =?us-ascii?Q?9eXIfANLvuGs4LLfUoNtn4yhVjOHyhmPT4lkSAIEtwWMQBKWWI3V1aRGMQtP?=
 =?us-ascii?Q?w3XZ9hZ+J1v/EpP+wtovrq67VwDjhDrH4C8EjkQRp7BAlBmPpu0GH+ngMc/i?=
 =?us-ascii?Q?hxiwgE1KIe5/eFER9s2hbXVo+h+6mTNu1FuBzbenxNQtpgzSsVH5GX0zFuqZ?=
 =?us-ascii?Q?J64pwUuo3I3CxfoYhuLRovV4dgQdhg58b0TM7XpC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdb8398-ac66-4041-a1fe-08dab1410dec
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 19:43:39.0792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VC6nQ9V09CTHksJ25cgXYDJo0yZM0I3jpOPGxDE8uwsWngMPcrnk0eKRz3Fee+7rpjm3nvxws5q5EuqSMHCizWltLCiZF28S1MCIinDpQ8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5162
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: yexingchen116@gmail.com <yexingchen116@gmail.com>
> Sent: Monday, October 17, 2022 6:52 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; Keller, Jacob E
> <jacob.e.keller@intel.com>; joe@perches.com; intel-wired-lan@lists.osuosl=
.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; ye xingchen
> <ye.xingchen@zte.com.cn>
> Subject: [PATCH linux-next v2] iavf: Replace __FUNCTION__ with __func__
>=20
> From: ye xingchen <ye.xingchen@zte.com.cn>
>=20
> __FUNCTION__ exists only for backwards compatibility reasons with old
> gcc versions. Replace it with __func__.
>=20
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thanks for cleaning this up!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
> v1 -> v2
> Fix the message up to use ("message in %s\n", __func__)
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3fc572341781..efa2692af577 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
>  		iavf_close(netdev);
>=20
>  	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
> -		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in
> %s\n", __FUNCTION__);
> +		dev_warn(&adapter->pdev->dev, "%s: failed to acquire
> crit_lock\n", __func__);
>  	/* Prevent the watchdog from running. */
>  	iavf_change_state(adapter, __IAVF_REMOVE);
>  	adapter->aq_required =3D 0;
> --
> 2.25.1

