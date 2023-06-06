Return-Path: <netdev+bounces-8594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C536B724AF7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 419A9281000
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E1122E36;
	Tue,  6 Jun 2023 18:12:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321B41ED43
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:12:07 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AE819BE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686075104; x=1717611104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hYkjgRixhiHTJdAYrGDLbs1oR+gqcb91NkcrwinIxvM=;
  b=epoOtDBN4Y65Qp9Ctx7kj8aqte6VseaOZAuWcbI380d6dtY7A8ojM2cu
   CR0ZGj42c7ldoG6pV+QMsW836LMj0EjLDxnwtJQlt+LQ45Taa/mjV+mvi
   VL1MePjq5H7iiPf+PsAW/Y2HcIJESQOdicvWoy2XlgX3eCJBVTLPSkK/d
   0GVyeRWMl4iF+0WNMYz2kR6QWHkJxXk3P3d58WWi91U9UnSpgidIssbfA
   dmAL2fY/3F4qBA7nmhobUmKCXLsAn2Acw7w8jOa/0xuHS3TlXk9NJDoQ5
   TteXvZWIFzozNAXbIZj8PqYUknFFSNcDdSk2VcWUCW1kryz/3q5ZHLwKD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420309957"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="420309957"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 11:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="883443970"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="883443970"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2023 11:11:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:11:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 11:11:33 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 11:11:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSc9TRj8RJ6VyLm4ayAuOWx7Jlcns5W+HKM7y/LNuej/WoA9eXSNrlFCAqP8OiWi0XOzQrzTLJ/XaPnl/IBd1IWgzENk7pvnS7JuNGE2bzLMe6iXBEp/rVwWCIFQdQIa+UrueU5AaoJUHURbsPaLCmk6nmiF8sukEZt9bzmuBjw2FuZ94VQu3ON3B7HkXh1bllMk2c1pNNkOzQkIDXg+6bh/gzaKn7ZOk6NqsbEyjzVBC1WWYHxQPVj9EQOfiEXFlfLFHggzrXKskrevM7UGSs0wrR54VZszuBzK1s7GuRUO31aIaVTCSoe7NxqUUJVd+MjURGkhaTfvn0CWCZMMXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJjgkIK/A94ACIE9Wp5I85QCiaFK9ucjsw7oZYpznt4=;
 b=bWDYvwn/WII5LTyaUnYjo80Iv3sV0ElHj0p2rGLX+Auv1T8rsF0XB4Rst1kLy9EGRhVsgr3D+I9eBN5PFwfMKCPB2QTlmEVqADLzifQiAqOCG50QjctLCF1QNp6VZIdONyEjERKV52ACBrbNP++1A7lUXn0YrDJy1h1E8ZNwEyeP89uyjC1vVOdM5yYCDiWv+NWTpOi6uDp3kobqUbSIy+AgZAfwe3nikgXxuNKKkD0GubHZPpRsfEeuvWTtBzPRfz0OwnMc07eGQZiU/s6nDTMv4imtBCnKbxywTNWg6D06273+80pAi1MIeX7+rlkjHfDIfn/FY9qJpSDkl2vR8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by CY5PR11MB6234.namprd11.prod.outlook.com (2603:10b6:930:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 18:11:31 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5c8b:6d4d:5e21:f00f]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5c8b:6d4d:5e21:f00f%6]) with mapi id 15.20.6455.027; Tue, 6 Jun 2023
 18:11:31 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2 03/10] ice: changes to the interface with the HW
 and FW for SRIOV_VF+LAG
Thread-Topic: [PATCH net v2 03/10] ice: changes to the interface with the HW
 and FW for SRIOV_VF+LAG
Thread-Index: AQHZl9qycV0p6E9DkUGp1Jrb/h70vK99hRmAgACNuOA=
Date: Tue, 6 Jun 2023 18:11:30 +0000
Message-ID: <MW5PR11MB58114F8654F4E94C10E3524DDD52A@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-4-david.m.ertman@intel.com>
 <20230606093643.ntrpa4wqilntkw4i@DEN-LT-70577>
In-Reply-To: <20230606093643.ntrpa4wqilntkw4i@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|CY5PR11MB6234:EE_
x-ms-office365-filtering-correlation-id: a810d78b-b67d-47aa-6d45-08db66b97474
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6OCn0wun2DAQaxIfs5AjiKqIV2CwZsol6jQHvnPrIW1EYTesUjJzxvuJZTMadweacZaaIwd5EFyi3EVP2LuMmQu/BnJ2pUYA/Y8OIXnap/lQjOu7xqtrtceH643I5StKlPypz3YYaVR9H0EyIXby+d5uYD+n/E/IsJl4JDOe2AlUK7+J55C0fuCMwqeDzVsclNImDlQbpJin0iNlKVDf0Ms28wQ41o5FQbreaeKuYfFqZxYzCDUvENZ2RFeJQvJDzPHe+wFfb3rKWO6bZ1umm7YuDefe9C/a0m/iPyYsuwdC6lpyBoHr5pvewlLzPo/eB4xr/npbHZGLoTNDcdaFuVaxewH6dbJ4JMXFk3mOSn7Hq9DpyCa1KH9naP8keelCG9WN4Bu1Kx8VsLt38aYT5/s9D6FG/Ii64S6b6IE5cEgZciavziCvt3zF9VkHw1nxrA+eXYu978CKSDyBPkkCciRMRlyiTXW2aJGprOgLbH/CjLkTGGJSAsDVLFlmvzFgUQqxMx9f6/oLkU1dRBllpzBozXXXDMnhgFxCmbqd5UsK52OMlSk1IrkKGlp9day2fVY//dxgJ5HT8pJKFQZwVntXqhnHx3kmACoBGzLig9zOtynjwgVOBR+OFUEzW/3n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(2906002)(54906003)(71200400001)(478600001)(52536014)(8936002)(4326008)(5660300002)(38070700005)(8676002)(86362001)(33656002)(66446008)(66556008)(64756008)(6916009)(122000001)(66476007)(76116006)(316002)(66946007)(82960400001)(55016003)(38100700002)(41300700001)(53546011)(9686003)(6506007)(186003)(26005)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/nV9egDuFwuR6VNn8JDqrZAO+wapxGOoK8afHlxkJn+6M9ap3wGSta2VDIQJ?=
 =?us-ascii?Q?USH1wsWELt/F0C3qlCpzO5bfKarG39W7fSS5eSAhjwK7ApDjnZeLx+qfxVYf?=
 =?us-ascii?Q?b97ddwzkBXuz9m31LtIc1lgQeNG1t8v1od2R06H985c9z9W9luceQ5Ychkm+?=
 =?us-ascii?Q?+jktui7dIdiMshURkXNuHuhBtWI/S+xiesEuLlFn3/u3iymFRu7k5R2ZCbx+?=
 =?us-ascii?Q?z+CQRTOwx+x2tZK/Ii6kO/RWnBeQa8l94vDy1M1AIS9mlMlYfmbEqai5xGMH?=
 =?us-ascii?Q?lqdUnWThsB+CK85T0v3W9aUMojTbd5brJHtUtv0dlQl0cEDmp0xJM0nMQNNJ?=
 =?us-ascii?Q?OmEtQYeDulD5j479Kbz1pY/jU/ewq5xLYDjjzW4XumJbnFYAc+pEX8DlAYoT?=
 =?us-ascii?Q?IerVVWHhmhkQdQDsoUTDBcfdFt+x/fT7QA4elUvMSItQ/RSU2PwNr5UAyNMe?=
 =?us-ascii?Q?H1CTdR6PK8ZZlN3wrecTvwjodzdrzANdkEYJdOrYUySjQbfuiVPEDSWSj1ki?=
 =?us-ascii?Q?jVeb4b86BTbW9mpv/WJu5GWvG/ilFVODsxfLMx4IKEBMqAp5SmuBfdIx1wN8?=
 =?us-ascii?Q?vh0DoUkcbR63fcK09W57oFKIzWcUFk0eM8z5rkKWdfmKmcmJIUtMYEiDZFkM?=
 =?us-ascii?Q?Kfo7p/KdJxg/au0UV3ChqM3Pfn/Bg2tz2CUQV+qV9LRXQISAEd1gN5Ld8Y1t?=
 =?us-ascii?Q?F3l3L/PmxRM6X+rPZK3rbmoG8l5WyHMzIDtIvmjN/wIHM5JFMBd7pWHOwT+C?=
 =?us-ascii?Q?fSW2kveUpKry8whEf1OPYDJ76vMmV7d3dryXdelmKtKsvgT4EbYOnAupXj36?=
 =?us-ascii?Q?F4WfTTKx2ggkvZwvWQXAoPbZouM3r4WobuCNy7cSlupj5GnWPmN0qBC/73rw?=
 =?us-ascii?Q?hdBWuXJi7tY0Wy81VGO5kXzIo8bwkrzGinChVSpbdbdolle00FvVzWYF1UOx?=
 =?us-ascii?Q?BW1lWoP3tv/8KrBgB9iurCVVAU9l4VMSl+GwjamC9ZEV359qqczFJlshy/s0?=
 =?us-ascii?Q?HPx+4I3LKAwfN9zu+QJjgF9f+bOCeh6gYHdHMj3nyRM5+uUzj1wKdYXbVK9U?=
 =?us-ascii?Q?L+cUE5uhuGFy7gPHuRlnLzlV8lzVdvbcOy83w1ZakrjkCJsazfgFrE1XZyV7?=
 =?us-ascii?Q?5z6raRLlwJ3/l9kthzZOn/eDcJP6FUsETIgPWuBX5NR/C4/ycTMW52C0lhC0?=
 =?us-ascii?Q?TguUr4P4KYGj4F2o+mSQMElbUcwYKHJ5fmlOwqm9ri0Cw9vwBRiQrrqpJh9A?=
 =?us-ascii?Q?ZbUHA9Bb/a90DBnA1GZwM2TZn1DWtiGtujuhPfwN+XTm8l3pesiisDEATXh6?=
 =?us-ascii?Q?CkjlMOE9CNz0d2HKjbisWOUAQRTlzx1PiN7rJnQwhcLTVCv2xErMKLVKZPBs?=
 =?us-ascii?Q?ERfNbgrl+ADGataV1gM352p/R7eNHL0VVotcqLVlwZ/iLfFTHoGNqRrWonaU?=
 =?us-ascii?Q?T4H5+NmwkmxMiGPza729v8xlLODSE8IWHV0xqb9cefoCATZJ5nz3dGiVF1hq?=
 =?us-ascii?Q?1SAmFt3FU0GUBP4CAk48xYgjG9MravaOk2opEOpnTce4BaSUdzRXhPyvisHN?=
 =?us-ascii?Q?t6f2O2jHwcHswh1i4BVC9YWT6vcdCAdgRHOaKlNH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a810d78b-b67d-47aa-6d45-08db66b97474
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 18:11:30.8476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9IYkJstCbf+TBdogtRka/bYokK/ltbzxij9zEfLjmOe6EHA0rogpD6g6B/SGWfyi0KhDXJWkA8582wztKeBUi298YJAR8+dJS0uOCO5aU9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6234
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Daniel Machon <daniel.machon@microchip.com>
> Sent: Tuesday, June 6, 2023 2:37 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: Re: [PATCH net v2 03/10] ice: changes to the interface with the =
HW
> and FW for SRIOV_VF+LAG
>=20
> > Add defines needed for interaction with the FW admin queue interface
> > in relation to supporting LAG and SRIOV VFs interacting.
> >
> > Add code, or make non-static previously static functions, to access
> > the new and changed admin queue calls for LAG.
> >
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > ---
> >  .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 50 +++++++++++-
> >  drivers/net/ethernet/intel/ice/ice_common.c   | 47 +++++++++++
> >  drivers/net/ethernet/intel/ice/ice_common.h   |  4 +
> >  drivers/net/ethernet/intel/ice/ice_sched.c    | 14 ++--
> >  drivers/net/ethernet/intel/ice/ice_sched.h    | 21 +++++
> >  drivers/net/ethernet/intel/ice/ice_switch.c   | 79 ++++++++++++++-----
> >  drivers/net/ethernet/intel/ice/ice_switch.h   | 26 ++++++
> >  7 files changed, 212 insertions(+), 29 deletions(-)
> >


> > diff --git a/drivers/net/ethernet/intel/ice/ice_common.c
> b/drivers/net/ethernet/intel/ice/ice_common.c
> > index fd21b5e38600..46b5de358a93 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_common.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> > @@ -4236,6 +4236,53 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8
> num_qgrps,
> >         return status;
> >  }
> >
> > +/**
> > + * ice_aq_cfg_lan_txq
> > + * @hw: pointer to the hardware structure
> > + * @buf: buffer for command
> > + * @buf_size: size of buffer in bytes
> > + * @num_qs: number of qeueues being configured
>=20
> nit s/qeueues/queues

Change made.

>=20
> > + * @oldport: origination lport
> > + * @newport: destination lport


> > +       status =3D ice_aq_alloc_free_res(hw, 1, buf, buf_len,
> > +                                      ice_aqc_opc_share_res, NULL);
> > +
> > +       if (status)
> > +               ice_debug(hw, ICE_DBG_SW, "Could not set resource type =
%d id
> %d to %s\n",
> > +                         type, res_id, shared ? "SHARED" : "DEDICATED"=
);
>=20
> Likewise: type, res_id and shared are all unsigned here - consider %u.

Set type and res_id to %u, but shared is being used in a test to print a st=
ring.

Changes to come in v3 of patches.

>=20
> > +
> > +       kfree(buf);
> > +       return status;


