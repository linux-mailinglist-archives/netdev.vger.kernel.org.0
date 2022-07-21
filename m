Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F0C57D3B8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiGUS6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiGUS5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:57:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDF68C16E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658429872; x=1689965872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yIU1AJN+zFZzPnz7C2agldKh35I31J6ga+zSRWtfn6o=;
  b=M80HIGkpfiEgCloFyGnyM8wSxNRDo7BLWz5VhQYD/LoeErFqkJeaYeNS
   hSAWZDg1BwUwNFYe4RCk7ZE0qMX8/ImSe8Ri32JXwwAtZjFFFfcQMUszR
   kQ6mPSw8qrIBwk2mlGrnZUX1BtYDN4Mx6KND7lD0LlCqWxH09wPrLcGS9
   Svub1IDW3I3bjHxCmPbPAw8dzd/T0yCGVV0R6HXYMr1zgt+3PyWkjofSi
   blbZ5cPAXEmQ+y9ydXkHiNu/pR5T8szD5Njd2N45CpD3wlIlUUA01L0CU
   eydcJAvXiitBMsmRy4DV0GoSnl+RA6BEKcqAapzlWDrHvCsNd1+X2l15o
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="373448820"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="373448820"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 11:57:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="626251401"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 21 Jul 2022 11:57:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:57:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:57:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 11:57:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 11:57:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIDI8V+5zbK6IXaCLUFXzdvepIGpe2T4bwS3VfPcSL3tmQ+S1dsIdGMvdRorMfADtspuGyk5yTiSzQ85NyWf1QusSNf1050hWwcrlQBRj5LdHJs5M22NBiWZ38E/jMkyMChejdqExBN/A5pRqdxVWlP1q1SrhjdbfY0BMFVuMnXTPxt3bS+Y6/MVOGD5g3GdfL/5dvtDZ47K9e3KtKyR80RYPZd8Pv8Bz+6yWdpaKX21wU4HaUkljF/5OqLh0E7USGl08a636KGJpWJVJjt/9V7HIunDgus9YliCOrH/ianpxVc2V1fB5kngJObdK8NFpwxU28qq+Fe0+lY3qthSKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnwhogXacaVQnyhnSdvkZhk7MN5fYQKNhTRb8MoFa4I=;
 b=bnBpwztl2/SGsQL8WujRRg1LLCJS1Y50ZuZR+q9xL0TW7ip5ksP0lwebt1r+hPeHQ3eimSMHxnEAmJQfbmgkwf4CL+g05zE6b5Hrst5r8hs8ypSwRJGFSgvFWOZzw5+C0SCRDkVt4pumKp8cIcWsmPY3H+M/pj7KMJXL3PwwuJCyPNP2oRv/9jH1MxO2Jc9nZOk69e2zTvQuXdN+5o9webdzOchQaixHn6iQgxReddTezhM/BsYUzu8UPKZ8NKOeTz8Y6BGnjK5EL8BgsV3Z5FsPcr7xzAQrobv8cxy/ZCjyYQAA9tm0SwqPnusTMvqgLKmGaNh0FM/yXmt1vRQe4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BYAPR11MB2855.namprd11.prod.outlook.com (2603:10b6:a02:ca::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Thu, 21 Jul
 2022 18:57:47 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 18:57:44 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2JCmWAgAAkR4A=
Date:   Thu, 21 Jul 2022 18:57:44 +0000
Message-ID: <SA2PR11MB51008B53EE77ADF3ADA5D8E1D6919@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <20220721094745.18c1900b@kernel.org>
In-Reply-To: <20220721094745.18c1900b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dbd182f-16ce-4116-143a-08da6b4ae580
x-ms-traffictypediagnostic: BYAPR11MB2855:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rp5M3A4ru09vrnKXrWlgUfRT6o0TCJ83n01XGSZA45ypqIqggc2Wr6KN0FCQnbwgD0z89yEpwZGGOyTJsLW+nWnoO/12PnvACyoUJGUtmQt2Xwop0oo7pK0QrOi825333N27U8sdvagWpUohjRdgzr7n1J1Cun50gIji65wyysX0oH4dnoPELGJgZYVWQe32fd/VeNFnxoGVPl/j4B5PcNY3SbWFtIhdxBk06Lg+XVLKk6Z4XMsx5E1BYqzvfHH0oSeK4MfA/fJesWUjRN2yGnygU+wLOqbp4gCN4Vc4dawZJwEF7uWn40KQF2B5rHaDaKi+k+euZhdGgl2eAcKAe7wPxqeJWyZA7670mnW56VjznA6Du1GYzEL3Gh1OrgoFG71qD+kryrqq6MZw9ZSA9SL7TkFsGAZV7gcq6Qskc42iXeJhq2Mh1uX/TOXgwXtUNyNScCLV8Kgstl0LSMJmsnhVOtn6mPkB+QZRMZhz1gAi+oAu6xeYUhNU04tHLLE8ulApzUBns13xOXuY8BzIFyuaE7N8Nso5FmMHJyKQb0LE2NcVvAnx3M6sY6Pw2nO0UASF+nvEZINPt7mrqibTp1IU0XlLOHHWhfFy8ZqFfx5BSXLbITwowuE9VGvoPUZE4MKP8ycKogAtdQ0adpDEbBEluAWtWnLhCmwOc5CLWSDWRx72CClPJAwTdIjyq+fmai8MJ1LfFZN5tJzY+B+Lw+yt8eKDGpl+b1AQvaTZFwUo/9E32dl5rdhSIJv9QFx+C0sKxEc+xzsW4jcFhDRPxhNfU6mECVUTS4U5OuNQVXbWaetmovUj77Z5fSLvxZs2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(376002)(39860400002)(346002)(186003)(316002)(478600001)(26005)(6506007)(4744005)(9686003)(55016003)(5660300002)(83380400001)(86362001)(41300700001)(122000001)(4326008)(64756008)(8676002)(66556008)(8936002)(66476007)(66446008)(38100700002)(33656002)(53546011)(82960400001)(15650500001)(76116006)(66946007)(7696005)(2906002)(38070700005)(6916009)(52536014)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KqDlK82pgmXWcwHPy4derR8agveQg/DEri06tUykeeXkWhqXwwUD66sCbLCW?=
 =?us-ascii?Q?SobDWbsTXLxl2nYcTqfXI0nQJV7dfNGdASL2GmcYsmInD5Op7bHQcg27mKdA?=
 =?us-ascii?Q?ymOBMTBwD9rOF39s9AOKgajkJwn1tZLvBJDB+Fv5ruYhLtzctZsl+WHJr9ht?=
 =?us-ascii?Q?aOdK8KMsx7wWAxgLoZNS61jXaECiPtpcA1zDpGeDzFxoLbDC7YEo3Hew//2U?=
 =?us-ascii?Q?dkFiTBjIBPAY5yivCtZ99niq0bNRnWKn3RcdBYPeazAafmQiODTpNzrQphTf?=
 =?us-ascii?Q?6MHIQhpHL0SulSgfcc/JKgAGgFfrXMhpS+gVWTDRQBXGHwpOY8rRFL8uEsGY?=
 =?us-ascii?Q?wrlGd9l6rrMhRPULBBevjSSQICWgiMHxjICPbu3w/eBi7NEi4zPYoQIAOoAt?=
 =?us-ascii?Q?+Q2esRtOGK5PYzqWXOjJThqer0cIeWn1ijbYANUKAvLQ1hly6YivAows1XXK?=
 =?us-ascii?Q?MxPWL+G56qF+EQhedp7sJeHYWokTaknSX/YkJECsClcJr89Rjxcihn78GDM6?=
 =?us-ascii?Q?P+b9/QaJ+945NsZRrRqEQyUWCIfmIVTFxgoT3nTzYy/q2R9m8nnx2UJqpHsC?=
 =?us-ascii?Q?MfhNJIlnt6jNY3tqTpimY6pl/+yhPZ9un+DdUYSuYsODrZgdOvgcNioGvW/Y?=
 =?us-ascii?Q?8vAPIslbenbOXF9i0pp41PGSKy6O6GFGiSiPYVW3HnmwyK6kwhR/Zf4eFOby?=
 =?us-ascii?Q?lnV74lliNZ/5ulV3Evh3+zjoISnOShi3L4vWmtQRWNEMVvaxxxtj29oHMTMY?=
 =?us-ascii?Q?bQoUGv4cwUe8hqK49tvzHtp6u7s36qdtctowF0K/B2Bhk3qqRu4XgTYwzpU6?=
 =?us-ascii?Q?jNn/V10AVZR4pse4QyZF1G1P6HZThaBuwXqfIf1WZH/hxSRIwY9b0plIvBZ4?=
 =?us-ascii?Q?Ju3bJFlAiBsDMvA57rEFLxT4OB2Az8gYnLgAfxN1P316FzDNXOoMK+to+552?=
 =?us-ascii?Q?lpJIEZxXyv/CNIVS53x6xrr9fw9+oRmvuBS5YK6CCjMQ5PSbjKNkScWt3nCH?=
 =?us-ascii?Q?zU6X/gnEMdvIO5Nb/910rBc75riqmzhRdCrQn0781BgRlG29PHtDJtVOtrMZ?=
 =?us-ascii?Q?qW0GSS1gnkBdtO9yiu/ereRr5xUQlnRM+XrI8Yc783GlWYbthHXzlh8Lj49u?=
 =?us-ascii?Q?ZJtHZwWZQasAQ15GRuQokgyYN9rAzW9m/ZlodVbKbNDSz2qdTpharSaEo8IL?=
 =?us-ascii?Q?/QM4zWljvYgnmR//O+bxcGoEDCjzh8vnBf9+Z7qOk13bzdFfm4s6nzP5/1Wx?=
 =?us-ascii?Q?ZuNpYDn2zNH5VA/Z9E+/H+Twd7VewA48ER/nNCnYwkleZXf8gOXgPh7gFwcV?=
 =?us-ascii?Q?NqIaf5f4pGtAbJlYuH3OpdVGvaqzPmr18sFmXU766DL+HbFDqyINhsh3ruJL?=
 =?us-ascii?Q?/hyMlriX8WMQ4NZGskcwatVjUcBX9r+R/L2QhAyZrrfQ/CwXq93KJmoma/Mz?=
 =?us-ascii?Q?/JM2nju4kf47CSfOYGGJEmHU3eGMxGpeVwnbZ95sgqz2JbDv2PvGTvmAxTrE?=
 =?us-ascii?Q?3mb1wvB860XuWo2rR2ix1GlVzsnrgcjOcIvT4C7rcTr5gvqGkfaWKEs3YbWd?=
 =?us-ascii?Q?SAgnTlHLkWBmB2SbnXDUBnvSmerjLdO6x/6zjEVj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dbd182f-16ce-4116-143a-08da6b4ae580
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 18:57:44.7849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PLTPCP/MhlkdDX0ZuuUlznM80IiqsDZPYfPcczHoQb5P0EC1qTbxBTl4821ZbDDDD0egptOPNIGqVY+Z8g1k8DB/83G5LyuiKvN9eXEEWlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2855
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, July 21, 2022 9:48 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>=20
> On Wed, 20 Jul 2022 11:34:32 -0700 Jacob Keller wrote:
> > +	nla_dry_run =3D info->attrs[DEVLINK_ATTR_DRY_RUN];
> > +	if (nla_dry_run) {
> > +		if (!(supported_params &
> DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
> > +			NL_SET_ERR_MSG_ATTR(info->extack, nla_dry_run,
> > +					    "flash update is supported, but dry run
> is not supported for this device");
> > +			release_firmware(params.fw);
> > +			return -EOPNOTSUPP;
> > +		}
> > +		params.dry_run =3D true;
> > +	}
>=20
> Looks over-indented. You can do this, right?
>=20
> 	params.dry_run =3D nla_get_flag(info->attrs[DEVLINK_ATTR_DRY_RUN]);
> 	if (params.dry_run &&
> 	    !(supported_params &
> DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
> 		/* error handling */
> 	}

Yea that makes more sense.

Thanks,
Jake
