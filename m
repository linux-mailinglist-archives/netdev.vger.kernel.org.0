Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CF457D4CE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGUUca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiGUUc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:32:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26EF8F50D
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658435547; x=1689971547;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FSiBI3yDOQXkxd19LFxnRkY7Qbx+SDp84Q7YREg1suU=;
  b=dqCwnSCWxX9B9C0W4MAlRfDMXvjh80am2XHoJ+Pd/My5v088uvtpLJDR
   jxRmzevVz84sSkPf7w5n7YvGTQ9C/M+3nEE+bcKHfMdPfj1p51HZeDMuP
   c/LcjoMRp4ufsRrKvkp4ywj2bVsgEkwcTifN7wilMPMOmpTVKoOe4xHlb
   i4AFIBCXDcMPysbZaKy5AOY8YjGMw/oVu0uXe16FwnhhYoZZSwPX1dEC0
   FBb/Zz2n4BzV8g+QTgMtTs2rIqzfhUc4wF5zG0fZbyfHvFeaMBCUUzapV
   lVwswcDyfLXE1uAij+hdasFIxYUOhTn/Xfm2KTX091Ul8RGeNmmOgo8qn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="288335121"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="288335121"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 13:32:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="598610838"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 21 Jul 2022 13:32:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 13:32:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 13:32:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 13:32:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4Njw53VcfHAPDKArgA2Nc1XwfeUKNke0+zbJMKaXil+jHCczkVnfXRSADBs0hIU3Y7uUD8qHp9Y2dEQKGOrBLbkTA8p5mzJhg4TjF8BSaR20S8jqc7vLfqeC4c9G+2on+TyB6uLy7uidCo7fMs/EguOjlBusLuyXMiGGs4nNpqPt6ovwjpxxwh2wZ3T7wbvQJ3luMxZvM6W3kEb0kHELZ3gVG8OI5gRswVuJ9q/1URVY9oJ6If7z8PbsBgLNnP4vioXlceWy629hrp1RNgHsvxCjMBUc0ghVdb/NNPk7tgvi756Yk7DL0NovwQhBTWTDHGjP/LXlxPyRThhbz3NOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/oWC9s3unEYqpbhqysHlR6FXIGBKtV7772wLnSSWNM=;
 b=Sm5JJSWQWdhLzIUod1mEIPUcOEj6NvTLLM7QWE6YHuvLkMVTjf+me8KyMYqVo/RAY/mMTNTAFEXCBy7pjJXmOLAWo4XpGn2w0NiVgeJpmmhTxoJSmo5b48H7w03t3RmEiBZqFttNziJ/Hjre9ge5BFRuMlh7ve2yJSTqhh2enNs7Jp9CDx6vNS3y7fmpLWFoDaKNFevFS6/J9OXO2B6LECy5ndNAH3gHBmXSCOwdz0a/FNBZkAKF7U01PBBDtdVpry+zfEJiCdbuIgrQuTKXHMAGqxXAajymz+4+g7FV2SYEZS2gnKFN3ubCvOuGn23ZOsLG8uKX4O83jZdeNbxcZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by MN2PR11MB3823.namprd11.prod.outlook.com (2603:10b6:208:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 20:32:25 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 20:32:25 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTA=
Date:   Thu, 21 Jul 2022 20:32:25 +0000
Message-ID: <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <YtjqJjIceW+fProb@nanopsycho>
In-Reply-To: <YtjqJjIceW+fProb@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36bb0154-bf9e-433d-04a4-08da6b581f37
x-ms-traffictypediagnostic: MN2PR11MB3823:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DdNdWHQcoCgiB8M33VoA70HUBSON5plk9JQCPCohuY1HLjCaA66KYCbBrSJRS/70ived5kzs/E9CdTpOBa6ZbmsgEta1myQwDBNsMgNRZIIdohSgdWbN6b9mIK10wPK76behG2SA90yBy0ujRX2ZGWIOGQfVj9t6UPAM8wTnfT6oQ22FA/V1jtFIm9R7cOkkpqGiRuq2neB8mjkmUFtHfLMsqB2N2ZWVtVcZexxGINLekiVa6N2UMn4sHpVIWbAWMlugKG0yb2kk5csyp8vm065yM/O5AMxm9I79tvnUVecEO5kV1yFueEUD6i5qZKNj8V3EpFjJNWWX25jLfQJhufyIz29CpP0HJn9aoa9gBMyfwfFO0RHani5Aj7lYnsVZO1dBENVXxIdcFIHKFVFlUVuZN4iwDAvu+f1mKPis5dXVYEUsH4iArtI8x9HhIkzU3tkAjjFsPS2TmXvp7S9ToVBbrjOp3SaxNvrKT340y6xWZMuaQrRuyr+mMvTxzK6FhpMsdZ72JbZk50ZsuG6XX342/tyvh8dwu6t472lfE4j0wwLeiC15wj7kO8WvA9CvDTocJYJpkFjYzievyuvzbjAeB6ZQQv9KcIe2E74sM3HiGrEG6aaRZWa8l0iBz7S3ecAgxUPS3+PXgBnxfMJDdAfaE57SJqLGeHhElfg5uYQvRsroFR0e9lh0GNt9IhtB3jAHC2YHXOTobOsMXfd1tHImUolaDde+duKxKg8N6Voo1GRJPLhJhuVciz9Skl4oRHZiec7TYsarVGOP5w4/T6lGmKkcAcOhswgxgMdUW+vghfp3qn3/sKfvWBl1MNwM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(76116006)(6916009)(8936002)(8676002)(4326008)(71200400001)(66946007)(5660300002)(316002)(15650500001)(54906003)(478600001)(122000001)(52536014)(66476007)(66446008)(64756008)(66556008)(6506007)(2906002)(7696005)(41300700001)(9686003)(26005)(186003)(53546011)(33656002)(55016003)(38070700005)(82960400001)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MOFeP8mBC7ASciOPuNPtaylqJ/qYBtyIbmnWu1GB3eo7pOWOX/UkgWM1uDFI?=
 =?us-ascii?Q?OfeFg2mbD6ncD6qsJZuNEjOtDMgOvp/JeUMAnSuwjVxiPxq0v5P4MY82cmGT?=
 =?us-ascii?Q?z3g+SIT1uOy1CeIjJxeOZ0RzxKHeflIBo9VsatcHNP5h5IHnDNfHE4MdjKF6?=
 =?us-ascii?Q?XMPv4p538905g4VTr3r6DBYyuoPvFXslQmjy0ny0KKsg5fxoRXhXelnXnGZK?=
 =?us-ascii?Q?KfC6dN5VM6CAgo7yV8hVjyoFmTgvICzdcnV4zIxqNbbOrd8IfuoSlesbM9zS?=
 =?us-ascii?Q?A7yvDpr0V5zHnq97CvyFhSFZRqWtgFmMnqotAmI2eh9S50GP6uNEfI3AyXlf?=
 =?us-ascii?Q?AY1oLMekAYvUMm4BPyXaDwlnLbbPI+2x9yCHFYwxu3cHodh683U3XhNvFHBN?=
 =?us-ascii?Q?g8kA3P0l7M3sxSZhzp6sorF8L+/7bsq2cEYymkqdusm/QvwjhVuFbi7aBvK+?=
 =?us-ascii?Q?r7JW21gVDk2dqpNwqETc+4FsroLKciOP6umZlCH/PjA8gCxHzzZWitg/bJc7?=
 =?us-ascii?Q?wLBvqAV8jqc8Uvjx+ZAWyH7j37N8Ah2dqn82iNmOH2gjKoxcP5mThW1kQwd4?=
 =?us-ascii?Q?009qhrBYdQ9QZdm3HmnV13/h41TuHVBn92575CxOH1bVcD3V2KNRCBQ2CaH3?=
 =?us-ascii?Q?kP3sTbsLNy2Vr2zutKEA6zMvDaQCFmmhbUzp3RDxdv/BiVJc+YEdXKuWINxj?=
 =?us-ascii?Q?yzmSnydTXA6LZwKBBKlerFCdu1TgYNTy6lHBmvhejC8EaqB435ETN6/r1K9L?=
 =?us-ascii?Q?ZV+UVhXq4lYtzsXJUqvbOo/Ydi3jUwIVLQgCnqTTKZmOhqXUN7Rdn2FoG2Ia?=
 =?us-ascii?Q?rJCb0QD0w/ckd8XZKBs4iHFSprnN0lImY0rMvKlfVaJKZdl/8/T/q15R7/wP?=
 =?us-ascii?Q?o8W5/H1PpOijfBKr6goDf3ypqkM1+fk3pzhFBeef1/e8e0PeZZ/gU3ZXAMQT?=
 =?us-ascii?Q?+ifNJPk56IH1Rjl5oxab6wXDOomrOn+1EZUb2QumV3JXRw5S3KireR9dymvn?=
 =?us-ascii?Q?WaLsVKY2R7dCg/wzGmrxP1XJmHW7DogLGG8d0azD9zpvXWEKR1nLt+9pq/iY?=
 =?us-ascii?Q?1XfRT7ZgWGUgB029JF3B89u5RuDKaspyFvtvv0jOr+ZwMv3i/h7Z2W1fX2Im?=
 =?us-ascii?Q?Ax47uBRsQK3lKJAvyxlvukAMcbPjEzDLDZWyNRG/dcbu9E5Voct2TAJXtg22?=
 =?us-ascii?Q?IZioRZIPUNb9NHewpLDw+XfeVzbAJMGhLIJGMr5loWalczTFmyHTzpcClv5d?=
 =?us-ascii?Q?ZRjbGAEmcqX4z2xpDNocQ6x/4zBnSk5aJcyXSQIwXpRSYI8cnTDi+Jn+F2lh?=
 =?us-ascii?Q?N4yGcjqn1LmX090HM5d0qgvP+NHSPJVOj4SzwzlY+1DL3p0FfkC2OeKSyD8p?=
 =?us-ascii?Q?AGhba+3ziii6qmWlFCgeqN1PDIMiRXlj5Kej505qvcYKRvfdbrFFgkR0ema3?=
 =?us-ascii?Q?hwbRdnEGL97kREUiHEYD5RAbkPCrNU+mdE9FwMyeP1FQ5jEPwczngzRG4Poh?=
 =?us-ascii?Q?UPPHDbs/mmbqpYiGUNeMvzzywkWR5noCrd1JQvZ+AQFasCaPqhx8yLvhVoFz?=
 =?us-ascii?Q?BEdXmudKCaH9/CptPUvhBaijDZftsJ1sEB9KlxXj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bb0154-bf9e-433d-04a4-08da6b581f37
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 20:32:25.1183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nUaXcfN/et2V8RH2ZHUTgKQQjwgXEMYEPnv96GR6UEHrCgwPJhbMF2BmmHtZ50PF9FDvko7h3g5NINVIi3xaMpDumhiSDoBKt89+xWA+iBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3823
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 20, 2022 10:55 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update

<...>

> > struct devlink_region;
> > struct devlink_info_req;
> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> >index b3d40a5d72ff..e24a5a808a12 100644
> >--- a/include/uapi/linux/devlink.h
> >+++ b/include/uapi/linux/devlink.h
> >@@ -576,6 +576,14 @@ enum devlink_attr {
> > 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> > 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> >
> >+	/* Before adding this attribute to a command, user space should check
> >+	 * the policy dump and verify the kernel recognizes the attribute.
> >+	 * Otherwise older kernels which do not recognize the attribute may
> >+	 * silently accept the unknown attribute while not actually performing
> >+	 * a dry run.
>=20
> Why this comment is needed? Isn't that something generic which applies
> to all new attributes what userspace may pass and kernel may ignore?
>=20

Because other attributes may not have such a negative and unexpected side e=
ffect. In most cases the side effect will be "the thing you wanted doesn't =
happen", but in this case its "the thing you didn't want to happen does". I=
 think that deserves some warning. A dry run is a request to *not* do somet=
hing.

Thanks,
Jake
