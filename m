Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326D159C4BB
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiHVRKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbiHVRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:10:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E786013CF3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661188178; x=1692724178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=65Yhm7P7gX7lDnpOWGw7oEMNT5RIuWaAkVdJyC9Xh34=;
  b=Nzg6FeWKhIFmOoN8tBH1l9LCZQ9BwDlwAc37mT0tfWi297lvuDSmy7sv
   eEXCQeEvMjnuB7GWT3iwvnhVyPPhY8xVMgUoeFUsFQGV3V088AUr3Xu0Y
   661udY5hDxuqJ4WcGHsaHbPlfhavE07kMgXFJTmVOWT87eJv3cmg+QKUl
   Zgnd+8bO6FEzqdzaKS2tU/bqaNTOxcwjisx+RMd6EnHaB/LXpom4wLk3x
   AN60ttl1k/cnGRXI4F7WNroG8zMLgtF2djWfV8+Ac8K080ggM/oATrxMr
   u3j0KsvRwQjkuKATsZn/ifv6+Xq9rAHdnr/L9qkqXuBJdvvtRmU8M//gc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="273858192"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="273858192"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 10:09:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="585605659"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2022 10:09:37 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 10:09:37 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 10:09:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 10:09:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 10:09:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjOm9aC0WnuUIajY2wLjLCvhfOnU/jm5byfjy73EQv5NqdjF7CVKiQ8vZbUS+S1t69bv8hs63yIfmgMtfCf3CWvvFnhCp7DMyYYKY9CLo6Zdke/mUJVVGqSA8H8+htILTUBOrx1dCpCu1fxgyZFVGb6YNX2O42DAXEMoz+l+/hOeYcgyKmlLQmIlqSEsSXXjTW8FqQVKw//fVeKFtnCrmQ047nH3nEknndMKGruhvILTCg8ldFzBymsnmZH8ni9GbtPe3VEuw0c+4edecNpmaVuVQT7zgeIiSGaCAPxsC4e8WiX6zoASN6MNz29NZ5Z/Yjt2F5GgcX4ts9gCMc6MXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65Yhm7P7gX7lDnpOWGw7oEMNT5RIuWaAkVdJyC9Xh34=;
 b=eYiyd50uLOVNoCRknIhss3XX9f9FI+gMOssnK1GqM5xAFYeAknM2zBhHaaiCHMnluToLVA/HFwRenVJiZI821eUtpDvjhwsZXBavh8KAQBowL5fW0tfURkpSAGW+HkbgCV1szO/sYg6fguwwKwzDY8D78vbCIBhrZyxyLKLVxKM+YS1i5r3/rDhuivq69DKNTSyw3N4ivrVPFaK026JxJ3m+o3SZjZWutxNIXiLMcCM4HnTsIl4PK3PlaSYH9YL3WE+pRCUqBiXtcACrQXWaNFebwSmPBNpEioMLwntqa/VBNl64bKdUXnRr8m1Mf1ffU/Vb0oACJAFQQIFUjT7xAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY4PR11MB1367.namprd11.prod.outlook.com (2603:10b6:903:2d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Mon, 22 Aug
 2022 17:09:35 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 17:09:35 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next 4/4] net: devlink: expose default flash update
 target
Thread-Topic: [patch net-next 4/4] net: devlink: expose default flash update
 target
Thread-Index: AQHYswKc72t683aiKEGZcmtd4DX0Tq21h5GAgAEvM/CAAA1JgIAABYYwgACA6oCAA+MeYA==
Date:   Mon, 22 Aug 2022 17:09:35 +0000
Message-ID: <CO1PR11MB5089CDBD5B989C45FDA80B77D6719@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818130042.535762-5-jiri@resnulli.us>
 <20220818195301.27e76539@kernel.org>
 <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220819144545.1efd6a04@kernel.org>
 <CO1PR11MB5089655E5281C29FA1AC19BAD66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <YwB1T8GJgi+dezIH@nanopsycho>
In-Reply-To: <YwB1T8GJgi+dezIH@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5eedb83-2308-4836-4c6e-08da84611691
x-ms-traffictypediagnostic: CY4PR11MB1367:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CAMT7RNwmEJUpE7Wm5JWJf053BfUDbzNYy+gwY8H05otfHejhasf+FRqaNAQuolhb5VWIlaXS2ae9GPfbQEgC1IkrgCWLVhm5yiZOivvAAIKLg+XqVt6feOPpiEgotxM0yZy2kHHwXJWehYRgWzjEN+TPqEWN78pX8F6nBlHqW5PhP0Lp5MPYWQ4S8q/ZMAyMmIBqakNjyAlJBg4gzcHXLnzYaaI/glSMxmro8TAY5RIv8XAdPiJDJQsFf0+HEq8RyVrPT4j9UT72pEYEeohNG3IqKOtyyfJQTifefagQKnEwnadhxfC6QGdLKnPE7TXIfoXspEZVkrc377PcHbVDwR/Rwwn/TuSiEc+NNauTd2cz7fLVBt5QqiKiRLsZ844wxkXCKNoxjCrcbLgo6X+aiP3RXDs96MBRxGBQAaaJN9kV4W6XrodVqmPKhI5wUDfW+rqM4AjE9DMhOZ0PGUP62VO7+pmwWuof6l8ZTLJfC0mWIH/Hn9gfczgCORhijFCQbxpwz6hmfTiNSiyopSmE7x55+svxCXHVGsug3cup20Er+n3OYHSHEHcRbhJ0GnrpyGMMN9zE/6nmYac1R+456yRHRG2h4hPk46D2vFi+c3cZV+iLIo2AH3KzGE2Lv+uFJCi2eyniLUaYtUTrVAbGNlB+tzEriCEcpwPVOM6zk8mKOYFHFxZYSCMjEZKIgLEanhlEHjftAiIQmKL8u0jd+LahUEAJRqLybVXc82b+lfS0OoyyYR/LEalv+wbdEJ79cRLJUcFPKU54ZKX06cfPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(396003)(376002)(366004)(41300700001)(5660300002)(52536014)(8936002)(33656002)(71200400001)(316002)(7416002)(66476007)(66446008)(76116006)(478600001)(64756008)(66556008)(66946007)(55016003)(186003)(8676002)(26005)(4326008)(86362001)(83380400001)(15650500001)(82960400001)(38070700005)(9686003)(122000001)(6506007)(7696005)(53546011)(2906002)(38100700002)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OlPm5NhATOUPOZoBkFYuyQfDFkOzUUCQnP1BJKtN6iIMq8fGXI2ObZCoHAXy?=
 =?us-ascii?Q?5sfec3WQ9SHLe7ptatxVysnRI8iGt7FM8kkP4YiGDbDznR16NTazD05c06T2?=
 =?us-ascii?Q?mxHodX5kCvrIuK99f6Iqg2yRXm98rWPUkdGVU9jL8NZH6nq7pan69+IfTYsA?=
 =?us-ascii?Q?s0hCWb0MtC19t/HfgljGFXRBN70Mc1CqdIc5JWEd+uVAWUQzhA7AIrnXPLkZ?=
 =?us-ascii?Q?9PcEOau8inup8fKqcJ8A/3X7Bg+v0X98sE/WWyb92znZ16iPRlggXKum82mg?=
 =?us-ascii?Q?8V4/HjCfErT1QPs4l+yuLFSD45yrr4k2PzSN2bUIaHMBHYFq0yqCuJg13jrE?=
 =?us-ascii?Q?vgXrDUIdPis7CBdZkExWUWVCcqctFppTPvSnYidnDlW4YinlMLQKX3AdzxeW?=
 =?us-ascii?Q?T/ZzzQe5H+M0GNaYzT6aS4+D/l+pWnHbLuw1YPD5MY6ehge59N87FLQlX7PP?=
 =?us-ascii?Q?ftTboxFOCvrnWPH8u7VqUYy83v3BSgyC1jp4w61PehYZgvuqNEqLvLax0KC3?=
 =?us-ascii?Q?PW8caKi3E7+KN8AhHuLoTFyDN8KlzTv8/odr94NHverBk9bpBxi530s3aqkh?=
 =?us-ascii?Q?w90ZKZ/egu1BYdnu2QmYi+4rXvHmFnz5a1tBGO1TbkvkD2YiCeRI61juzco9?=
 =?us-ascii?Q?FLzStxKxzUqUDW8GzLECpj9qRWS8jK93soLvR/2LoM/oNSXDck8840g9VI4Z?=
 =?us-ascii?Q?hKmVRX4dVt7nhKcaVsu3/6xN4gz2P7NDvu1H9QRPSfqGqfUDIX62F4z5HygB?=
 =?us-ascii?Q?QYAPao6wDDYV1jjdiO+JLlGgDCzQ5X1C8IgafyDFhUcsJI6Ba2lubVqwt8IS?=
 =?us-ascii?Q?0lntjrGQBz+Hs7DqYOYcUSxwf3gfwx0uaJvqvUuyUgM0m2Hc4u0Qtf7NSrZb?=
 =?us-ascii?Q?X6Egeqc9YZnAEdwM61uksvDbqNUq8S/kSXowokNTjkats+XOnGEAYtVC4Rvd?=
 =?us-ascii?Q?kRUPV4FkBPw5KSSzdWDTij1J1syhF4g43sxmvaA2fhWFlLlni5RDnU7uwSHo?=
 =?us-ascii?Q?I/R3MsL8C/shOXpP0B0EGjltorkj/Iy2wrikAWgsG8gxaWZShKpXmb4p0RnB?=
 =?us-ascii?Q?2g64ns4Hk8CTlShQNQi+l4zTwiEhftANUKVnSUyoKZEO+6uc2UGWvfSzKAUb?=
 =?us-ascii?Q?7LoM40AteEQNPAv3U25tz00kA6jXoD9GiAvBvUe/pqgvOIaXSGDqf1Kqqyl8?=
 =?us-ascii?Q?s6Fd1HWphO5we0/ZMxHNbhh/q0AwUr/HunTJuRstn7TS45uj7JfsRZuTVSiD?=
 =?us-ascii?Q?FprPer2+OLrY8TkblPJgRYNm9e75khpXq76nJaoJilOlqwWywypTWD3WFzYO?=
 =?us-ascii?Q?bcgxcYr8eXdQ9JGe1iVRTa2aNLTuP9jWB+gqS3r4g4gK50mUWcSnXksUi/jR?=
 =?us-ascii?Q?YQZZuNWsKZ7iDs0OKNueX286I+e+xAfkGpPBzr6ZFK27wts+rTc9a0Bjk8co?=
 =?us-ascii?Q?23IT8+OgspTVU0cyu/gtQnf1fk3uZzO4DUT6aSL19OG0Bfv75P5F0R/AOzaq?=
 =?us-ascii?Q?L/jDQ0hHsFZHcIhvlHTzfVuNyDCcCGDgb/5QC+9uWGh55bImpgdbGaHJER02?=
 =?us-ascii?Q?JjwYL/HYAuk7LrYZiAxskQcW5Pm5Wk01v6es3nkb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5eedb83-2308-4836-4c6e-08da84611691
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 17:09:35.1193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DvxDkOTRZBs5zV2VVa2YuhfY3/7DUpee7iSV8nhhjANke81UONIVX4Lbsbv0UV4BIBNkqozWoR/qX1kLek5R/laJmg68jjENGigZPagqZxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1367
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, August 19, 2022 10:47 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org;
> davem@davemloft.net; idosch@nvidia.com; pabeni@redhat.com;
> edumazet@google.com; saeedm@nvidia.com; vikas.gupta@broadcom.com;
> gospo@broadcom.com
> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash upda=
te target
>=20
> Sat, Aug 20, 2022 at 12:07:41AM CEST, jacob.e.keller@intel.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jakub Kicinski <kuba@kernel.org>
> >> Sent: Friday, August 19, 2022 2:46 PM
> >> To: Keller, Jacob E <jacob.e.keller@intel.com>
> >> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org;
> davem@davemloft.net;
> >> idosch@nvidia.com; pabeni@redhat.com; edumazet@google.com;
> >> saeedm@nvidia.com; vikas.gupta@broadcom.com; gospo@broadcom.com
> >> Subject: Re: [patch net-next 4/4] net: devlink: expose default flash u=
pdate
> target
> >>
> >> On Fri, 19 Aug 2022 20:59:28 +0000 Keller, Jacob E wrote:
> >> > > My intuition would be that if you specify no component you're flas=
hing
> >> > > the entire device. Is that insufficient? Can you explain the use c=
ase?
> >> > >
> >> > > Also Documentation/ needs to be updated.
> >> >
> >> > Some of the components in ice include the DDP which has an info
> >> > version, but which is not part of the flash but is loaded by the
> >> > driver during initialization.
> >>
> >> Right "entire device" as in "everything in 'stored'". Runtime loaded
> >> stuff should not be listed in "stored" and therefore not be considered
> >> "flashable". Correct?
> >
> >Yes I believe we don't list those as stored.
> >
> >We do have some extra version information that is reported through multi=
ple
> info lines, i.e. we report:
> >
> >fw.mgmt
> >fw.mgmt.api
> >fw.mgmt.build
> >
> >where the .api and .build are sub-version fields of the fw.mgmt and can
> potentially give further information but are just a part of the fw.mgmt
> component. They can't be flashed separately.
>=20
> Yep, in my patchset, this is accounted for. The driver can say if the
> "version" is flashable (passed as a compenent name) or not. In this case,
> it is not and it only tells the user version of some fw part.
>=20

I think we can just go with "is this flashable or not?" and then document t=
hat if no component is flashed, the driver should be flashing all marked co=
mponents?

Then we don't need a "default" since the default without component is to fl=
ash everything.

> >
> >Thanks,
> >Jake
