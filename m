Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81F66E295A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjDNR3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDNR3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:29:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6922959ED
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681493351; x=1713029351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ecpbvs6aOCa0awNs3iUM71ntCvzm2m0LmC2byVaIuM=;
  b=H+F+dp+RlEApp2h8djd3eOd4S+QaPEGtN/kPenEQ8y54F9CtMFLoX7Ta
   TLRWYTcwKMF/uDpC75dzs53xzIujjhPUa8QYhk7xM16zv/srRiNol49PG
   voDnua8HcP9/E+Hvwf5Ik5xb570Pp96oKjcTju0PXXasak0C91oTTrv91
   CMrhUA5gcnFwWkFM+5bEp2frrRdvxp/uBWVRK2sfCW+AW2TAxwnLpbmoa
   bx0uy9ic0kvIUYunnzLsTFaLfmcPBh7MdFpfB5FpdKm1SoTGy3LAoamqs
   X1sy8Q64vQBLivGHEwPOcteGocbBkn0NA+v1fY1FjXYRhycuyWFDoMuX2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="409724922"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="409724922"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 10:29:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="779252869"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="779252869"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Apr 2023 10:29:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 10:29:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVqlh9GCt5TJgitybESsJQj+ypTMdZjTt4tk0AxJJ+vBvHFFlI1bHwmYF+V2+7s9UNDL4NapUnKvans+cpfubJqsjUNgR4wqbo9CrMJUoodEqbRKWb1RTqTIlJqC0AEI7UdUskk5/qivikNsC9rLE6XHTHAyGVnd8vUnDIyDLNNZqiB5aOsPOsJK7IaG/dYIQ1CUmjp/OouB0pmICf3K1WOs8XAvehT5sRqqS2F4AsvYq0wow7XWEkSCWp92KGt7uhC0CXkF7NDDcLfrUvZwQrdHq2gkXylN6w+qArH0uU2yjnp65iZIDvoSMboAUEa/UqHeKwa3m94IDs6Z0EoU9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s99C7EVXISgUu4kWAMO0zC9CREqQteM9SoueOd4yksU=;
 b=cI09ci1a9pmawGx2Kdf5IY5lzgiEajqJNvW6/pQkDZH7hnCwDhT33OInMw4XA8aUo7ZH0M31hNgdir0XxV1AgBQbiFdaxzxUPLEVDnfS2biBIDPdxsEaAq4Lr52s4VQUOCeGy5gkM1n9AIchFB7VD1VuCwLmEwXVMsmTAvJKJPtqbRoo7g2NxwxhtL1eUjHjzCZHV2QBwmKl0ABCpKC6udnKDAoCBBvFacZtGkPoTtCRqwZF/QJ6eI6qQPuK7Ox/kkqALrTq0K/kgJws0LfIbHfMC1Xqwh0S6Q+vtsIAu2rTJamBeGiv+SchGEh/zH2oT+JU5AiKWT79KhJW/TBZ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6454.namprd11.prod.outlook.com (2603:10b6:8:b8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Fri, 14 Apr 2023 17:29:05 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 17:29:05 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        poros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net-next v2 3/6] ice: remove
 ice_ctl_q_info::sq_cmd_timeout
Thread-Topic: [PATCH net-next v2 3/6] ice: remove
 ice_ctl_q_info::sq_cmd_timeout
Thread-Index: AQHZbRefxEt9vroxMUm1P7tr5uZoOq8q6Jlw
Date:   Fri, 14 Apr 2023 17:29:05 +0000
Message-ID: <DM6PR11MB46576BF9C476045F93378E229B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-4-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-4-mschmidt@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6454:EE_
x-ms-office365-filtering-correlation-id: 6331ee8a-7b8e-4b2e-dfbb-08db3d0dbf0a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(38070700005)(7696005)(71200400001)(41300700001)(55016003)(86362001)(8936002)(26005)(2906002)(186003)(52536014)(33656002)(6506007)(5660300002)(76116006)(478600001)(66946007)(66446008)(64756008)(66556008)(4326008)(8676002)(9686003)(66476007)(110136005)(54906003)(82960400001)(38100700002)(122000001)(316002)(83380400001);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6331ee8a-7b8e-4b2e-dfbb-08db3d0dbf0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 17:29:05.1581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HmLzIt/xvULjZIj0v5ISWTdqSh4RhdcqsUWcsbOTkWtZ3IX3Gij8iBNfubzc+48aIaT1CAmeW3xIwZw/BwANR1InA7tgQ2ZGI666GzmDLgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Michal Schmidt <mschmidt@redhat.com>
>Sent: Wednesday, April 12, 2023 10:19 AM
>
>sq_cmd_timeout is initialized to ICE_CTL_Q_SQ_CMD_TIMEOUT and never
>changed, so just use the constant directly.
>
>Suggested-by: Simon Horman <simon.horman@corigine.com>
>Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
>---
> drivers/net/ethernet/intel/ice/ice_common.c   | 2 +-
> drivers/net/ethernet/intel/ice/ice_controlq.c | 5 +----
> drivers/net/ethernet/intel/ice/ice_controlq.h | 1 -
> 3 files changed, 2 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_common.c
>b/drivers/net/ethernet/intel/ice/ice_common.c
>index c2fda4fa4188..f4c256563248 100644
>--- a/drivers/net/ethernet/intel/ice/ice_common.c
>+++ b/drivers/net/ethernet/intel/ice/ice_common.c
>@@ -2000,7 +2000,7 @@ void ice_release_res(struct ice_hw *hw, enum
>ice_aq_res_ids res)
> 	/* there are some rare cases when trying to release the resource
> 	 * results in an admin queue timeout, so handle them correctly
> 	 */
>-	while ((status =3D=3D -EIO) && (total_delay < hw->adminq.sq_cmd_timeout)=
)
>{
>+	while ((status =3D=3D -EIO) && (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT))
>{
> 		mdelay(1);
> 		status =3D ice_aq_release_res(hw, res, 0, NULL);
> 		total_delay++;
>diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c
>b/drivers/net/ethernet/intel/ice/ice_controlq.c
>index 6bcfee295991..c8fb10106ec3 100644
>--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
>+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
>@@ -637,9 +637,6 @@ static int ice_init_ctrlq(struct ice_hw *hw, enum
>ice_ctl_q q_type)
> 		return -EIO;
> 	}
>
>-	/* setup SQ command write back timeout */
>-	cq->sq_cmd_timeout =3D ICE_CTL_Q_SQ_CMD_TIMEOUT;
>-
> 	/* allocate the ATQ */
> 	ret_code =3D ice_init_sq(hw, cq);
> 	if (ret_code)
>@@ -1066,7 +1063,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct
>ice_ctl_q_info *cq,
>
> 		udelay(ICE_CTL_Q_SQ_CMD_USEC);
> 		total_delay++;
>-	} while (total_delay < cq->sq_cmd_timeout);
>+	} while (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT);
>
> 	/* if ready, copy the desc back to temp */
> 	if (ice_sq_done(hw, cq)) {
>diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h
>b/drivers/net/ethernet/intel/ice/ice_controlq.h
>index c07e9cc9fc6e..e790b2f4e437 100644
>--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
>+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
>@@ -87,7 +87,6 @@ struct ice_ctl_q_info {
> 	enum ice_ctl_q qtype;
> 	struct ice_ctl_q_ring rq;	/* receive queue */
> 	struct ice_ctl_q_ring sq;	/* send queue */
>-	u32 sq_cmd_timeout;		/* send queue cmd write back timeout */
> 	u16 num_rq_entries;		/* receive queue depth */
> 	u16 num_sq_entries;		/* send queue depth */
> 	u16 rq_buf_size;		/* receive queue buffer size */
>--
>2.39.2

Looks good, thank you Michal!

Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
