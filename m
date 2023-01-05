Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E3865E509
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 06:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjAEFXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 00:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjAEFXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 00:23:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728F14858B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 21:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672896211; x=1704432211;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=txMIvAVl2GszasSa3ceKjEGazobHV+a2nqyFqycSdoE=;
  b=PPIg4JGbhTrPwgQ0nY3RyI2Cclwn5X3wEQ9PU8pH//5ITaHuqJJFlPTA
   2h85UV/1+OJVC9kLb/JdNvjL3xw0HS+aV92Nf1GuJauSqVktviklOo32O
   FQ1FDHWm2NFPBW24PiXPUzH/yNwtOr7BYDYFxvoCGdX0gBqL5bBhkU5Ex
   HJJelUuV8ISQJ3pt6D9AmZ57sUgpIyf1RiEtlpMdZTaRDMDUy27AFe3cv
   f5ZqEuaU+VaiWON1pE7PBZvgyb9I2u4S+gLhkDyOVvrtl/Ek7Y22jU2LY
   3U3tximteFjtPqvJQq9EfCzreM2/r/w//5be9mBXZbu+TslLGETgKIkz2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="302490132"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="302490132"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 21:15:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="829416518"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="829416518"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 04 Jan 2023 21:15:53 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 21:15:52 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 21:15:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 21:15:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 21:15:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giS49otwFziJDtRAqpA9IfYAL4Z2qALDBFAjkC1FNQrDqgDtUALxnHvlwczuD1W/1Z/87e0obDL2xG+3DgA6CmCz3OW39oTulJ5VuHO1I4cj75SeBeBXSgrv7hwTMlgeHvYC51YHvsIYcjI10nhxo2eETEOdgcyhM4m/UA0ns4fPttUbLSOxzNhs3hfV9D+tijBb3YANU+bdanjvVP1vqGDfPxEFZ8CUVzY7jaeDbKJXngXlWpOwAHJsRlYoiM4Jb+qX5+Pq5VrlSX+SjgPPdf0CwPn7uRCSdVyFKtIGnLPbWiBbi8L3P9SGQ+82Am9v7y9MS30KHyOcCq0mn6kS6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txMIvAVl2GszasSa3ceKjEGazobHV+a2nqyFqycSdoE=;
 b=BcntM8LiACyOv7rTBLeB+R81KRsBCsN2kVfx/gnk9Ef03cc8cO4rrlRCvGa8QXZMs32VpLvyhsURyWz9BHp1h9HBJhs2reLLRP1kLv9Z+CC3Bqlvo/GFYiu4/c87+5oD+i3FRqkz0lKFwL+RDpHoo/pleYU+gwvfdnWcVstFM0IGHocIXKNLKAFDDEFZibzAph9lEICAgGhOxkP9cRJpFAcvh3DmMpaq/CS15B6UHGSX6bmIzrHTYXNAhGrjm5vwFUk37A6etNc8CvWMAZxAkcxckMyg0+IyDGzwJQeyz4NvuLUai3OANDvSBxRZKArr+hUmGiXdoR9x/6oUq1Rt5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB6026.namprd11.prod.outlook.com (2603:10b6:208:391::8)
 by MW5PR11MB5761.namprd11.prod.outlook.com (2603:10b6:303:195::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 05:15:43 +0000
Received: from BL1PR11MB6026.namprd11.prod.outlook.com
 ([fe80::b5e4:f18a:ba6b:55c1]) by BL1PR11MB6026.namprd11.prod.outlook.com
 ([fe80::b5e4:f18a:ba6b:55c1%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 05:15:37 +0000
From:   "Stany V, Vasanth" <vasanth.stany.v@intel.com>
To:     Yuan Can <yuancan@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: Fix potential memory leak in
 ice_gnss_tty_write()
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: Fix potential memory leak in
 ice_gnss_tty_write()
Thread-Index: AQHZIMS+sxEYNMzwEkqXnzLXLKxT1Q==
Date:   Thu, 5 Jan 2023 05:15:37 +0000
Message-ID: <BL1PR11MB6026D470BD7383780B114A87BFFA9@BL1PR11MB6026.namprd11.prod.outlook.com>
References: <BL1PR11MB60269BCA60850BE10D747990BFF59@BL1PR11MB6026.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB60269BCA60850BE10D747990BFF59@BL1PR11MB6026.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB6026:EE_|MW5PR11MB5761:EE_
x-ms-office365-filtering-correlation-id: d8dad1a5-ff7f-4bd8-fa37-08daeedbe16b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZEq/JWQIqOc1EWYzhq2/uvopcp/ZCkCzNjrR+PGJWBHf6vUNk7tBAModheC4iyvKg2VgZb0XyqcSbS36XtmjEmhylH8qVq1Ic0kL3lCyYaP/2gtRq3++WdGa8or7ciUXoihEdaHSeGXkQoJQVffg3n1ZFiYNqkMD6itRXycP5BOcX8ocI6mVpGIbIAqGTMNWw7w6rC0xirBLknCyn7wPdxW3FTkPU3aXaBLjEuj4lIXHXryi7pmk8kJ2Mm0cKtiEXzpqMuoMFOnwARXFEfoBFk2G34yLZguX2P4P/58R49MzilSfhWeJwssUPcanhAXmFGmDlngnSDd5AUa1ewOJHjVrEU+PTBShi7V+XfwF0R5k/OiUS0NKKy1vF55jUVeF0oGFPF/5fHHyycb03TLhy9MIF8h5LNBnoqXwzU16h9ZoHBh6kxH2fxcPRcaTnt+VEWlF1qDFmPdBYORX2OmFVlofdnwvN9b60/uFFJaA5mndy+dLs6Zp7OTAr0Eg2IZiWLyxgWhskbz3W9dQ/C0tQaK+AytqUOXBCeSiszwedMZAxfOLUGPll4EG6s8jNkaryMQyJzWnxICkRFmmn3NhMH7661rtLEQGTdUCDG9VyrDOftyP61OozeZjWdtzym/vhQmzWKs2wCcDuK9KJScFnCbIfgXkWHIX932/HmjBzFsim9AKCw3+slQd9wpmqaMBjxaI4naYtOAPlO+EkJAEWt8WyQ3YcXOwuly5cqtL12jqhCc5AH1IMLUPv+ayuUQu3SOzLk9toJCKVgNrQwc6lA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB6026.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(26005)(83380400001)(186003)(9686003)(86362001)(55016003)(33656002)(38070700005)(921005)(38100700002)(122000001)(82960400001)(66556008)(64756008)(316002)(2906002)(110136005)(52536014)(66946007)(4744005)(8936002)(41300700001)(8676002)(5660300002)(76116006)(66446008)(66476007)(478600001)(53546011)(6506007)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?2XtMXVtIIcP5CCYpz4XjXhs8f5AhL5E8U2BLj8geODlcXQHd5d8obedsa0?=
 =?iso-8859-1?Q?EJT4wm6ssD8A8QiN5Kb4kxTJQAgAgXuLwnvQFgLT+94bPSiar9SOlspjhV?=
 =?iso-8859-1?Q?kzpUzhAHffDTb0KIM7cWMPwgQSyEWI6TOqEnkxhM/v6p6TS6tYS+8+a7LF?=
 =?iso-8859-1?Q?XDipKIAOpQz0vxc17JJZKyhmAJnRDioHte2U6/LSyp28nSZ2/97FUn9G8s?=
 =?iso-8859-1?Q?e5aLcI2J5SNxT5x2xrxgxjPwB2Dztt7cg02gFolMfLVhADRwDinqf0hBxy?=
 =?iso-8859-1?Q?J9XB4BUEIB0it/uJewGmUeXqJ5rLFYskSn1jBx8Kb9l9n/+7JAiZBYvrs6?=
 =?iso-8859-1?Q?SSPbLaKNZmxMfERf5QXwgqODjGmVvDoVcv0bHai7lP5kzwicHG5cqW6dVJ?=
 =?iso-8859-1?Q?UTdlk+0gNnLy9MEZ7XZtR8rp/+XGxPqB2nSEGXzP3v9xaiMfi8ujiVoy20?=
 =?iso-8859-1?Q?oMPgkYvyPjT6FodusW3IT6aXCrFjkS2KlzLPL2TyQhvSBuWLAzrG2zDdOc?=
 =?iso-8859-1?Q?jOSJqz6FcohcboAwl2zBKEeMcPeFeSYNKmsKxQx1uLTqmN4zR/PrJYd9NC?=
 =?iso-8859-1?Q?XPUJh41eQODBJZrHQ3/NuDYb19APTPUDuSeFMnn6xzgS0SMrRtHZizg4GF?=
 =?iso-8859-1?Q?7QehNenE/X/F3JxoaztdDYkMGQaHerypXEsurt77rVOa0MbJJbrDdKThLl?=
 =?iso-8859-1?Q?Q4UPHmVY+M0ewYid3pslL5OLBXI1hPdfmYS4xZ3Qmo/HH1NuouLd4q9HxV?=
 =?iso-8859-1?Q?rihJllhw9Mla8oUHe41qgJnw4AaqT16ueWnIJQxACS7j/4nMKcqSQcRYf2?=
 =?iso-8859-1?Q?x/E0GMPW/iRcRhodOzaMHEQIR89XtEZlyl1ywo/RcH/0gdY1dYpvwZDQc7?=
 =?iso-8859-1?Q?bImo6FVOP6VMHDaMtqdr0O+inUkY+IXKLWO6uIVokb918Z3l3FSwkkcR3O?=
 =?iso-8859-1?Q?LBOmzEeZqv4cUcM0v3XvFNLoYl3KO/vFda6KMEXnS3jIMdDVE3dlnLRbMO?=
 =?iso-8859-1?Q?FYiY+58/dauvrqT2dsvzq4obj15pYiJpZ0b8uSD1sGH6AAs/Sarw0dgx2k?=
 =?iso-8859-1?Q?plOJsG+qZ0f0B8fciA3UtmedBoNgvYq/9Ccdi9aztRYEim2mi6vcYxfMnn?=
 =?iso-8859-1?Q?4H3w80uz6pPxY8Gsnp7ENmpfMemFnYAKzftIwDSn5F3Q5A+92vAA0a+XZP?=
 =?iso-8859-1?Q?TA2BdB9l8ZfglxwqkaOjHbIDpoXUn9YMlwFDiFtmtkBw9h/PTWx5zgYiPr?=
 =?iso-8859-1?Q?jJJzu/echYe216c3UWxhRz/M40LU3U8IXRoRvIAtlqd+Jc61ki3iP9kYaT?=
 =?iso-8859-1?Q?GUxr/bXYWJkLGninEV1iMGB8t98+fefko9kFSCMqZEUtoqeHTfbYbyiU2R?=
 =?iso-8859-1?Q?LNo4jF3aYVl75SRTFuzXEPiyhKzlSvWpA5e5Wh6kj1s+Nla0dccGjiKrDn?=
 =?iso-8859-1?Q?cJvMA3EoarzLafy8OURQfuE67lUen22BFohsHCZz6TK11ys3vMjlxEUwWk?=
 =?iso-8859-1?Q?YxWlCXURQbBfeafIHkfAEkIdNU0ufonlbVr4eiR0Fpa6Er+DODiefPjiE2?=
 =?iso-8859-1?Q?f7lJs7MvVBK111DdQSQblj/M9rR5dtxM774CO4jFi+0ySRf+p2IpMoDeaA?=
 =?iso-8859-1?Q?5jmpfeDWbFoUvagENEw1vi5W7Gb9/hS2qojU93om2ajs7oRVL3rddaNg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB6026.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8dad1a5-ff7f-4bd8-fa37-08daeedbe16b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 05:15:37.3076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSYmM2IqbC7fye3msrPhYEkQcZ8p48QsB4tHblf90cZSdynevEGUrLgPZ1ijl583scUveNcPqnSh2sk+C62zKmisYIo6ew2yghn+OQ3Jge8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <mailto:intel-wired-lan-bounces@osuosl.org> On Beha=
lf Of Yuan Can
> Sent: Wednesday, December 7, 2022 12:55 AM
> To: Brandeburg, Jesse <mailto:jesse.brandeburg@intel.com>; Nguyen, Anthon=
y L <mailto:anthony.l.nguyen@intel.com>; mailto:davem@davemloft.net; mailto=
:edumazet@google.com; mailto:kuba@kernel.org; mailto:pabeni@redhat.com; Kol=
acinski, Karol <mailto:karol.kolacinski@intel.com>; mailto:intel-wired-lan@=
lists.osuosl.org; mailto:netdev@vger.kernel.org
> Cc: mailto:yuancan@huawei.com
> Subject: [Intel-wired-lan] [PATCH net] ice: Fix potential memory leak in =
ice_gnss_tty_write()
>
> The ice_gnss_tty_write() return directly if the write_buf alloc failed, l=
eaking the cmd_buf.
>
> Fix by free cmd_buf if write_buf alloc failed.
>
> Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
> Signed-off-by: Yuan Can <mailto:yuancan@huawei.com>
> ---
> drivers/net/ethernet/intel/ice/ice_gnss.c | 1 +
> 1 file changed, 1 insertion(+)
Tested-by:=A0 Vasanth Stany < mailto:vasanth.stany.v@intel.com >=20



