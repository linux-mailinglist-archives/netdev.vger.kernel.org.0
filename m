Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F30B3F7075
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhHYHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:35:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:58002 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhHYHf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 03:35:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="239648243"
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="239648243"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 00:35:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,349,1620716400"; 
   d="scan'208";a="473756890"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 25 Aug 2021 00:35:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 25 Aug 2021 00:35:08 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 00:35:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 00:35:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 00:35:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dw3kfZzHVd/4WTdEK2A7SugN0AXOMHfW88VqG1vnRQnS2wi95lwF4NiepyDBYAb/yI0K6AhxdVBoEcaml/RFAqvI49FJ8cTlJZIywDlXKijq3VVUlY+bQeXeGJ2evX5k1atn00rV3BHoqqRJ+03Yka6TNgBbmaWS91QHmrii2a5gDIXTrSfiUVtBh4BhCr2bvgELfl1rEa9JyQAiRwvjWtiJDUR06X+A+N4eM0oshHF9cTxEq3KIkjiXnsJDXtnDmcTLog23lm+1jiKAO7KBBTrBngRGQjSCCiyOxAHUCY5scIV8q7ntZiPmJfB1I1V6hGgFePCZzVykGCWIA2aHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhIX4v4oFYFR66aA2DPaS1wxZLrsL4bzffuNykw5PmU=;
 b=mr3CPve7zQEz2aeYKGs8LWDU9csLBKK6ppYlBkDom/I0AfeTlZP0mmYAvGTAdZYoDsW7uS+2HCCBKbxbxgz0Jr9/lfr0/3Bwkas4BdjVc6PRu3eGXty6FfgntiidggzhMbEtjK5Bho9/t7qZ0GiUp0GPTfws8E4EKjThPqDDTFSb2mjVJevwrHiQEY+rWNVgGBeeXPv0R7FAOnB2uRVg8QeFawldrXcDO0zwlayTVOKYx8d2LAppUitBYIvMQbtrzgANsI7sU/Lh+7cNdaKgK5Aqmi19dABZjoXZWCqpZbR6B1guqaFxJhXee3lCINgnADF3rC47hmJ7bIFbo8ScIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhIX4v4oFYFR66aA2DPaS1wxZLrsL4bzffuNykw5PmU=;
 b=uVlX8FLi4qk7aJDK9FdCylvJsDZVlLKX8oH236FgK0KN7d0O8UXIhBKpbBjkNBRlFg0C3EydW5W5shVIMsc1HlQ8NrkGTiGOmUy+8ygq+j5CnU9v+yfLMky0Vc3VqFssU0uf+taVCj5Ox0PK7Mbj7BouLK74h0J/F36B9da4Cck=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1933.namprd11.prod.outlook.com (2603:10b6:300:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 07:35:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::844a:8c75:cd50:c5b6]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::844a:8c75:cd50:c5b6%7]) with mapi id 15.20.4436.025; Wed, 25 Aug 2021
 07:35:06 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Thread-Topic: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Thread-Index: AQHXmOiflbVGXmdj2kG4CbJa8Uluk6uDSTWAgAABqsCAAAgdAIAAgjdA
Date:   Wed, 25 Aug 2021 07:35:06 +0000
Message-ID: <CO1PR11MB5089E122FEE8FEA720EE58B1D6C69@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210824130344.1828076-1-idosch@idosch.org>
        <20210824130344.1828076-2-idosch@idosch.org>
        <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089F1466B2072C6AD8614F1D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20210824164730.38035109@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824164730.38035109@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85645a7d-85eb-46e0-f67c-08d9679adbec
x-ms-traffictypediagnostic: MWHPR11MB1933:
x-microsoft-antispam-prvs: <MWHPR11MB19331197B2189BCD4112705AD6C69@MWHPR11MB1933.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jWvJPmBofJ+yu5TDKVf3nVoxRDmqFdbIMFQsbK1GllvIu5Dou2uVwPSNMPCx9NDe60OZPvloRi7zf0k8XeaofQDI7coraKOJPKy5KhOvpj3MD8sK/PJlThmlIclprogZobEiduRrIln6hqrwcwhaK2o1CYu7ebhfWShrXqTDUNZ8ubUlYQpDiJ+abxt5L85+5ycJkY6/rt7Bjm4MmfeZV5mWV4CZLXX7+jfaCTVzb+ePgvHwcxzdik+y0uUvTrYbww8LbfpajmI+mQcNcYv0LaaZNH/c137jtpLQlTsIZ1hb6KMF5n8K32ZMm04UKEzuzUYvo51o0jwsaNB0dRAWRh8FbMfUJ7zdr/LTU/rajfT13mghUlUR+8eEQCt7ONDd7mnnUxf0VTWIa9l91vKNCLFLVq1WecuCuT+yf75qcYh+MVNnHSFPsk22aJuBXabbGnQEgnK3rGABc90iDquOJTKxfx8j+HDyIYsS3eE7KHnwb4SuEyTHP+nAVL0bFOOEbNeF/AEWUgVBQ5n6ZXo6Cb5TgT6qBmplq2MG5Fl3fg4ghFSd4R41nsPXwX9skLb6EJQH4PMr6d6mZk5Vt+xC3YDCfY1lTFh47quDoBP3WLk4E+ZxkOPYj7nyqg1qLtLOBmp+EYLzgUMvE6+dStzkkSYQ1jh72FbqLIeDtFaDsE4eT70o4iDFK7QmQ4N1Yjbgzj6Z/Y1gJYK3f/SHPYiW2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(6916009)(6506007)(4326008)(5660300002)(8936002)(26005)(52536014)(53546011)(478600001)(8676002)(38100700002)(7696005)(122000001)(83380400001)(2906002)(316002)(54906003)(7416002)(86362001)(33656002)(76116006)(66556008)(66946007)(71200400001)(186003)(55016002)(66446008)(64756008)(66476007)(38070700005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SzRpbzNuhZjJE+eqQY299wRUjh/Eyt8LoOXnXzLoDBfG99J4u5ppMeHZA87k?=
 =?us-ascii?Q?l1XGU63F+84+cQdTxr9nosIHucNrMh6TwKZYAnaf+6F0Xvgje3aNruaAPFOM?=
 =?us-ascii?Q?iBdeXSXxaZKEhLEQHXvSfuw/ne/NF4W06PHT4W66HfPeNzS+NuUuP8oJCr3F?=
 =?us-ascii?Q?1KO+aXjvigm3atxSF70KTM/ijSTMl7uA3NZef6+ZVOfuqAT3B4pcj8AgeNvi?=
 =?us-ascii?Q?4l7l2aKzmD7X+ndY1ibyHljQ1bhYJf+uR2NnYatFII15EoE7XUfuUBFysBtj?=
 =?us-ascii?Q?DvOppURbBp4fyEXEBdUGgHtoLRKJ/Q50TAQJLqwGvCitgefFqOa1xQ7f3D6n?=
 =?us-ascii?Q?fSkYDkpoYo3gb2PiQbE1dON3dEc4pQlAV5tGCK7PoGqNZ/j8vGSLsO+rfMOP?=
 =?us-ascii?Q?xKjynwi8CEzcV6pdhYyh98InNiujG1coM3Qfjm9n0Bw3SMGl1nWaEfc9qvj3?=
 =?us-ascii?Q?j/7iA/WiURO8CquM2pA0WLJmKiKJrsY60FYB7HPRqvp089OeXnNttRf8RnfU?=
 =?us-ascii?Q?ePm/yh/SrfV+vIe6qgiJ/Enz9BAl9UNzBTc8XIZUHuHYSp5oLLVyPUmbLVnI?=
 =?us-ascii?Q?zBbukkNmz9XSS6cNoLxuWGR9CJUqGm5X9N4Omva1lTFO/NHCd9/liAEzbPQX?=
 =?us-ascii?Q?CAp12Swlw4NhvqTjQEaoJB8kyX7iuXcwJfF4ifFywn0Dp0OU5dZ1fOhK/1d9?=
 =?us-ascii?Q?iCLU7oR61WG8DZl9b6NPwbdMvo8RB5BE0XIfE76x9/LkhJiwXiTU8vlflhvP?=
 =?us-ascii?Q?9/+5yo6p0YVtVjv20d+HOkxxT7MtO5lPTlq24Tinlyjku/T69Iz5vcBvsaU2?=
 =?us-ascii?Q?D9LBAz5PlY+ToNIlwPgsgxi1atbE/3too6+ohcB61CmSNt2naju1bYOpGtAV?=
 =?us-ascii?Q?9KR3ghAyrnmPgsIvaB1IAlVcaPa8PepOp+FlLAQITfxFmMMxdEWPuojjxtO5?=
 =?us-ascii?Q?KDB/gWsQzDFIUiTUq0c2hD1ziSkLECqon2IULv61hqhVCgskHgoTQU0Vb7d8?=
 =?us-ascii?Q?D7U7BMkfx1tjIcmzzwArkFKnUI4xh+CcdDaekxbj8T/cUdwEW4SpZEPt40T2?=
 =?us-ascii?Q?yj/gXYIraw2+CxlpVltBUhabFcVa7syGYsYGldKmV46b/6WsodxabhQTne7E?=
 =?us-ascii?Q?AHiqrDqR/f84+R2lSW4KQrdosH0yJDWLE7pPhpnNrnZj/MEIPiAScaWX7jsx?=
 =?us-ascii?Q?dx4z3MTTBrecQB3OGnNz7WAiW47CEg/pUvvTgWOQj+c4LnzlNfxYmMhP7CXN?=
 =?us-ascii?Q?bNILVF0HUL02eJ4VbrqFeIhHjTmA9i2noeRSZM0FHBii7t3RZqkt2ljAxFrL?=
 =?us-ascii?Q?bJs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85645a7d-85eb-46e0-f67c-08d9679adbec
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2021 07:35:06.1273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NHqgEHzQvFlv2A8wjN44hKE8SfsuHarTy7lSYRVLmBtLaiScRyM4TWTLrhU5IKanRZvPyuA1rYWcT0FeS1jYrPlK9pOiSUkcU4R7J9tOPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1933
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 24, 2021 4:48 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Ido Schimmel <idosch@idosch.org>; netdev@vger.kernel.org;
> davem@davemloft.net; andrew@lunn.ch; mkubecek@suse.cz; pali@kernel.org;
> jiri@nvidia.com; vadimp@nvidia.com; mlxsw@nvidia.com; Ido Schimmel
> <idosch@nvidia.com>
> Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
> transceiver modules' power mode
>=20
> On Tue, 24 Aug 2021 23:18:56 +0000 Keller, Jacob E wrote:
> > > > + * @mode_valid: Indicates the validity of the @mode field. Should =
be set
> by
> > > > + * device drivers on get operations when a module is plugged-in.
> > >
> > > Should we make a firm decision on whether we want to use these kind o=
f
> > > valid bits or choose invalid defaults? As you may guess my preference
> > > is the latter since that's what I usually do, that way drivers don't
> > > have to write two fields.
> > >
> > > Actually I think this may be the first "valid" in ethtool, I thought =
we
> > > already had one but I don't see it now..
> >
> > coalesce settings have a valid mode don't they? Or at least an "accepte=
d
> modes"?
>=20
> That's a static per-driver bitmask 'cause we don't trust driver writers
> to error out on all the unsupported fields. The driver code doesn't
> operate on it in the callbacks.

Ahh. Right. Ok yea this is different here.

If we can keep it simple in the drivers, great! I usually like the valid ap=
proach, but mostly if its kernel-core code doing it since we're more likely=
 to catch and review that as opposed to individual drivers.

If we're expecting drivers to set validity, a simpler interface would be pr=
eferable.

Thanks,
Jake
