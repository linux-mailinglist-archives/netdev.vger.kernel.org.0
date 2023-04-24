Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8C36EC658
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 08:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjDXGfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 02:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDXGfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 02:35:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF7826A3
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 23:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682318133; x=1713854133;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=98uWcpYTll83npFf2zEn/PbT8DlynUQ708iA882nv5s=;
  b=WobRDpVb16uUGo0Oycu1dg5EGBPrPiuv1LAdQmv7aTwQuVzsbXa88zs8
   SvPRulzq+SoP2Ewn1Hle5QmDdN05ZpsvXVB6EzaHqED9/cg/xsndDv+gN
   TqCfhfzRYKKjTTAxg78Dj+kMakB2DLN9B19GGbnbHf4aQFi7HrFn7PWQh
   03rVBFC2g8etN5I7sICyYrXvGH8FhTuyDkItVtkbzPQPTpXKWQ60Q+bSj
   EXOW2E+l93ImZgOpL49DbIdw2Gg4+uGwomM4DNeUtl6VYJquVZpKM3dWf
   IpRrk48hC3emmz5MEz9UTccO3Wn+Il1cER6yiZErXSvrF9B+Wa9dApUY4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="346398820"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="346398820"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:35:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="1022590201"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="1022590201"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 23 Apr 2023 23:35:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:35:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:35:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 23:35:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 23:35:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uj3770z6xt8pTjrGRnNLJRM2HDKSb+EFJPhZJ9JraTSTiUFH0XuM/0wyaLkatV6DlhVbGFLFA+/y7O0UHt/v2nj0aHVhDDZG6HFIzs1S2/8Vxfkj/pkV7fvuzCd6bDasVWX7NYLXC4RoFqyTUYXtCLp9t0li3x2cqyA1t2aXNHWviwnwTjy1LYMbh1MWE0Yw7DTczZq+nUe21Z/mdNfUd5cjim/zULceQbRqzxgjuEQxs2SqZZlJPVGEQ1VbUdkyl0fTZFcarQwyfoX794WjuWmNcpmaWftAjA1w4fD49/zMDgIoVRWLvSpTo5fkyJr1GdNx6EOzyUoUqts/UXg4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyVAjMLwx8omZbi1DTsjKE0HUkZiGzOn5wMT/Wegg5s=;
 b=Cela2uouAMn/AkhJCkzoyMurb1I4dEnvpTuw9Zu5Ef+QyUHtehm5hABDHOlgHfEdEg/nQrxqkcpR3ItSQTFv6RJoQx1FoaICYBka5qn17daHI5uTj14PmMxOBPFWhmRga28DBNiBpROSmWhcIKcQk8Y3TgIhhFXWLerznmiISDn/pe8rhXMPu2VjzImWvd7La+UOOEnyZC3/6XVQ34omDKI3PM/mrI1wYlWx+4GmXG+mvt1sPh+1eFNPmLMIH6+RuhweR3bYRNkj1HNYxFjR0FHJKT8RReVIWBjVDbTTpros1jj41bcwhM9KmFVmyx1EJMj3OwCcv3UnlM7Rbs4MPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by PH7PR11MB7477.namprd11.prod.outlook.com (2603:10b6:510:279::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 06:35:11 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::4e56:57a:9d6d:476c%2]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:35:11 +0000
From:   "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v4 5/5] ice: use src VSI
 instead of src MAC in slow-path
Thread-Topic: [Intel-wired-lan] [PATCH net-next v4 5/5] ice: use src VSI
 instead of src MAC in slow-path
Thread-Index: AQHZaXQcGghuNAF9z0GF22rVuwgM1686GrxA
Date:   Mon, 24 Apr 2023 06:35:11 +0000
Message-ID: <PH0PR11MB5013728221A46185F0032B6496679@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-6-michal.swiatkowski@linux.intel.com>
In-Reply-To: <20230407165219.2737504-6-michal.swiatkowski@linux.intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|PH7PR11MB7477:EE_
x-ms-office365-filtering-correlation-id: 125ae2c7-e3c7-465d-db0d-08db448e0e16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3wUxhbZ9Fy+MOxFnQBuAIZFMNsxuW4BDNM/0b8iR3pPidnUjw6+yrFYqvzrgA0dHZOqI4r1ZKsg80oqOyMdyIlARjmIu3XGeB6B7DCNMiO2rQ8zEns69t0gNrSluYwsI5APX5rkJREN18h8wuO8ZoCUJUMFUc675KluAgyOU1vODMJr/Ket/HStc1idlz97/BeG4q2QGqK5KnuC4oBdBcfvxYqqcbJ99FV3QIOw9hOX23CaYSXkxldDFqo968rdZWeGT90HRG3sbpN/it/Wyh//+2dqTqJ03KuoB9PYGHY9pbMRYtkYhlVJWTQPFpOuRcc8T5HV3MfDAlEmqfmE1m69GkOtM/Ar97TG6uxfA4j7QvroVgE1tBy3BedtNSnip4fWPpsHRshvdrUoK0OZd+PYl/slqyd4cOihrYDr+KA2bYvLMYx80BePj0h0thUclmVhskJPV0jnsKphfw90f29ZfmCV1Seklv3Tx+q0joyDhC+f31WT27pqJPr6LK1M+dBp7Fcyw81xYSrQq2BiVQ9wdm7DGOlCw/cPs1+6FzWtiMfjovOYdzNB6D3XC4UbGE/neP3jbE5DDJhyo7tc+IzZ8OpYqUbOmh1g03XXOJsyoW5eGH+FlnTHaaMGwq7/s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(38100700002)(122000001)(82960400001)(6506007)(9686003)(53546011)(26005)(55016003)(186003)(83380400001)(33656002)(2906002)(8676002)(8936002)(52536014)(5660300002)(54906003)(478600001)(7696005)(71200400001)(38070700005)(110136005)(316002)(4326008)(41300700001)(64756008)(66446008)(66556008)(66946007)(76116006)(86362001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wEBYOwTXbQnCpzwcUrzY2Du0aW2mTszPaAWA+dasb6ye2mx1bgG8p6ZSEuGT?=
 =?us-ascii?Q?z0R94Mg2YV+P7Bw1ziN7h3EyDZJsN2o1UCcwRU+r+OJbGaZiK6He0eUCraTi?=
 =?us-ascii?Q?Xml2OnjXM/9VcHWsLVNyiQANYVwQT9JXVRjOuSJid7ykSGTJ3GQ9UW9RJDpy?=
 =?us-ascii?Q?xeR4BBrLpCNN7TQSYVpVXK19p4azI7FoVgPZBKHXRxCOK5OLEN7E8IPLZ50H?=
 =?us-ascii?Q?RrLsyqehQA+4p47ExlNEhCFijewOSprwtExjKCihuLJDwc7Z3GxCIpTIuS3I?=
 =?us-ascii?Q?lyNMKzIYNmhP4qyWU5ViXWnQPc8c7NsZqgwo21NAJ0eIXuBowKxQb2l2UoKU?=
 =?us-ascii?Q?0x2V2jBxANI/8zG8fNG/47OGxMI0SgLpZlcpZASekOsrQpr0qz+GgLc6O8fg?=
 =?us-ascii?Q?z4tKJC/ZbZjNAoI90dZHQ/fp0ZeXchP9ter7u1XnT8C2+qV8LgUCEsDZXq9v?=
 =?us-ascii?Q?m6KLMClnZQBWneoqQO9JJvdZWBUrdurVkc1wKJ1XUZrDCjyZLPd2tfXTrOoI?=
 =?us-ascii?Q?cvRvV38fKAki/WGBEcPHboHDgZ7VugNgwfNnam71z320nes7mNGmsLs/HAFh?=
 =?us-ascii?Q?HBENcbTerh5j3O0nUrPiy6kKpE18uZvuWMnWZ4qLk0gLzqh70dVJCmJ+5Nr9?=
 =?us-ascii?Q?61WM7SKbQgWUjEzKxz49ycokhGZc1HvSDodqs6IKP/Nco5SUxi5BrYGsPhtH?=
 =?us-ascii?Q?LUjE0fFLbpkqtgxyRwjaRfKgVDDtXf+HEOqlNBEQMA5/IdS2e/Hko36+FhnK?=
 =?us-ascii?Q?lggJ5n6/WE822so6ZrxUmWo/o6GaaKb0H0JEcbAWinb6e/Tmrx99Rsf3Az+N?=
 =?us-ascii?Q?MPWwiIKsud/mZcJ//f9BTicZpvzZspjDdBNHyZ0JGtE/hW24/9i3q+XUss19?=
 =?us-ascii?Q?SX0ykIc+kgcRwhoZ/CaYJNhtok5c0Gnm5vidAMLU+72MkDtGwTGOeYlelvEc?=
 =?us-ascii?Q?HpBz+n0WYiH28R3urE8dBTJi7QRdcuBj4eob303FNxqz6TbQC/0ybS2DICvN?=
 =?us-ascii?Q?6Dq9xkJy9YIREUD4yCTFE8EPZ1URZiq7QG/Vj5918ahPd3cD2Vi1lKFDiTwH?=
 =?us-ascii?Q?0zhlp3MaCOIB0Maht1wEqAKo0Z1x69OztbaVA/8HRcHZMnWH4QmVpQaDKMdN?=
 =?us-ascii?Q?wo3vkc4hUdOHpLaHvecqTB/QSkbtWNrXplTe1k9fcEp3ZDHgzmJs/kHrrnHu?=
 =?us-ascii?Q?BdyEcWjGvpUHK8exsr/ty0Oh23ITT+qhvm7aoW8DdwvuFDFWqG3cRT2hD46d?=
 =?us-ascii?Q?60gRVkuusuZxiM8kGKN0vsrzy2IpSoxga+xdsnYm2+eH2r0TspWdxvotq7L1?=
 =?us-ascii?Q?ApXe0IjGrBiLT17M+fh2WKccojNt7UjvPwFIasRlfx+iZAohNgS4ilh2EOlg?=
 =?us-ascii?Q?FOapYXBbseqwndBXNmBPLm5xlybPHlhkrfAyUqB6BwsTc+UPFVaJSkwew6PR?=
 =?us-ascii?Q?oDb9C8/BnFL0D3TpjWIbnRfRpClBklCSFvTiQJFaEGlk0yYIiQeV8y4VWPUR?=
 =?us-ascii?Q?zHq7PQWryIwNPmKSLOYX1Fvz2WZIGBsXEB4Z4dMM9CP4SG7D73r1vJjwOKIG?=
 =?us-ascii?Q?SSo+tnp7I7oDKnFBPZE/sv6zzmvthGA2D5fDc6vHizyHAsv9f8LEpm7s4ffJ?=
 =?us-ascii?Q?wA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125ae2c7-e3c7-465d-db0d-08db448e0e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 06:35:11.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xtJwcerCfYj4LV/aJuv5cbqNj8tX+qeuHK1Fc30psiuoGkHiYNRXiJb1oHY7RjunAT6tfMPL6YUc331TVUT1EXoBM1jqLoLohoxEoPji3lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Michal Swiatkowski
> Sent: Friday, April 7, 2023 10:22 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org; Simon Horman
> <simon.horman@corigine.com>
> Subject: [Intel-wired-lan] [PATCH net-next v4 5/5] ice: use src VSI inste=
ad of
> src MAC in slow-path
>=20
> The use of a source MAC to direct packets from the VF to the correspondin=
g
> port representor is only ok if there is only one MAC on a VF. To support =
this
> functionality when the number of MACs on a VF is greater, it is necessary=
 to
> match a source VSI instead of a source MAC.
>=20
> Let's use the new switch API that allows matching on metadata.
>=20
> If MAC isn't used in match criteria there is no need to handle adding rul=
e
> after virtchnl command. Instead add new rule while port representor is be=
ing
> configured.
>=20
> Remove rule_added field, checking for sp_rule can be used instead.
> Remove also checking for switchdev running in deleting rule as it can be
> called from unroll context when running flag isn't set. Checking for sp_r=
ule
> covers both context (with and without running flag).
>=20
> Rules are added in eswitch configuration flow, so there is no need to hav=
e
> replay function.
>=20
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c  | 83 ++++++-------------
> drivers/net/ethernet/intel/ice/ice_eswitch.h  | 14 ----
>  .../ethernet/intel/ice/ice_protocol_type.h    |  5 +-
>  drivers/net/ethernet/intel/ice/ice_repr.c     | 17 ----
>  drivers/net/ethernet/intel/ice/ice_repr.h     |  5 +-
>  drivers/net/ethernet/intel/ice/ice_switch.c   |  6 ++
>  drivers/net/ethernet/intel/ice/ice_switch.h   |  1 +
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  3 -
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c |  8 --
>  9 files changed, 40 insertions(+), 102 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
