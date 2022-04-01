Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A784EFBFA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 23:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352733AbiDAVEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 17:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiDAVEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 17:04:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F001F6F0E
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 14:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648846982; x=1680382982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cAbYqik5qCmjcUGIBD33DWuYREwm3O2qhlxoXXFUqYc=;
  b=d5s3cdeCGWPflp5LCmzpqYg2eNeAjjy2G6mk4jrckPxitOiYJ0CvBjdg
   gKwAbAgR4k+aQT5FeTNCohPwCdCIA6TNWtdyUDd+sAZdw9/8N7812Gvzm
   L+jo53Yi2L++sleipmPyAzglRyYbGYG//VD+sV+KkH1kIAcfNjOhkx+yV
   nTibGhr9QXdVNpntlUVhv18ojvzch1lpJ5nNBteIboRlOGy91pyAiZfkg
   gUy5MGxDNlZD9OPT9H6t9YuaT5E2P1a4Fhmj+MK5PoBmMKVOwo8A6sWfu
   iyjiiUu+UBPfuT+zO2aqZF9AnhWHHX/NMMRBb7bRDoCFazpjg6qKsyQzq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="242375044"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="242375044"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 14:03:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="650855538"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 01 Apr 2022 14:03:01 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 14:03:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Apr 2022 14:03:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Apr 2022 14:03:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fj4rAf1LQFtlGPNWgIkDAltnRmYzpPEtc9o+99z/VBWi92iFiL4FlRH3x1Evdz9beEUZfBWERh8no+MyOtXBKZjQK87aV5QfFJHW0pJdtx/eTmrPU3cKRvxJ7wQ/i2EFqjjz/rUUOJpRgUct7HZQp1a25sWq0NwYtiY+u6H6a2c7GGeL3HE71398LatkPW1kMSRW3njbcuuhs12SKCYZuPAZ8XFqSwFQEQjE0YZV0OtOrf2pms59uwFm1CEIu01WHQjKS530S08VBQ70O9hIcmBCH8tZHLEE3p5bnK+u0FDsoDfYdCXVDDyBba4yqJPul6Yg+bCx6IIzCVmTYvxeGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKlPBuUordh0SBPkyEpbuZgAprdwGZeJdrrGgR/S3zc=;
 b=cEu5Gvqu52r+3RJ9lyl8NvVnHbmDWwXmMVFBwaG9dqIfbbF9uizz3ZCLWE+aiE2En9mhmlovczkJ134SmO5KUSLS9ha5ijzSSMnZUoe8WPp3vJQgylG6y6eX8s+tY6g5Az6APGXLNFk2RsZw7CmmPCE/pBR4n3NHeonvwX6D9BY3VxE0ahfEGIM9paIEB9NcnFAXUMNwhGIaJ+JkDcpfMcu/XE86ShZ0n5AFBL+pEL5CgkD4u/mqxZT6JOuPA5Qj7Ozg/32EG3POy3RDDYX2X8v88lJmIZnDrpLyocP5qKY3c6awiYhyeOO7P4KMKVSGj2IyAalltYlUJiMEVSb2ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0062.namprd11.prod.outlook.com (2603:10b6:301:67::34)
 by MN2PR11MB4079.namprd11.prod.outlook.com (2603:10b6:208:153::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 21:02:58 +0000
Received: from MWHPR11MB0062.namprd11.prod.outlook.com
 ([fe80::c3c:359:d9c4:3a54]) by MWHPR11MB0062.namprd11.prod.outlook.com
 ([fe80::c3c:359:d9c4:3a54%4]) with mapi id 15.20.5123.021; Fri, 1 Apr 2022
 21:02:58 +0000
From:   "Michael, Alice" <alice.michael@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net PATCH 0/2] ice bug fixes
Thread-Topic: [net PATCH 0/2] ice bug fixes
Thread-Index: AQHYRgrDo5/4pylVR0yKH/5fuNN/v6zbiwng
Date:   Fri, 1 Apr 2022 21:02:58 +0000
Message-ID: <MWHPR11MB0062049CF0EAEC82CF187066E4E09@MWHPR11MB0062.namprd11.prod.outlook.com>
References: <20220401121453.48415-1-alice.michael@intel.com>
In-Reply-To: <20220401121453.48415-1-alice.michael@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d43df0ba-3af2-436e-c0c7-08da14230041
x-ms-traffictypediagnostic: MN2PR11MB4079:EE_
x-microsoft-antispam-prvs: <MN2PR11MB4079501B0D2724EE257A9ABAE4E09@MN2PR11MB4079.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 87HzQCidh+uGfMPf8yVHRcynjMddzAtsTf8sD2Hba5crPgJ0/zHBcdtQY2JMdb9lir/5w9fN28B8OUIgD1ZgiOZwkc5fMoXAyMAfHAxNw0iRDSh/fL5rzNYFdB6ay080HHd5kuX1doyfo7oZLJf0dbopwbyP3yiYDFdSqetyZFBMLurveWc8hjuOy0jLapwITIJDbYSMSuN6CSbXBpw7vJ+2jLY3nkfx2iqER3ADHxAJjqvzrFJ2vxgR5eodu4yrNsDL3AI9JcDa2diR2LPh/HsRpKJwtIcV715zd9zcFv6zb+YsTjdwLSAlu0GaVk1nR6V2/oKDcWxZBaEEIaaMwqB9l2Ss37yje1JY92kOty0gD0iUqNi3LzknFd75eP3ekAsSIxba6fHsofRc870xfMu7vWvMgl3KiROP2VSGHdUsmMIvMsvU9nEYLmXvAeJmyhnjAQnNHdgvHH9uVH6PgYV+BKI3u1K0oVG0JHi4fQJYn9AP2DUF+b4rODqIk5Dn2aQVKla8oY4EEc3FR+81cYgcqPXzve0dxBrNtcQ3/Nnc6NY8rglL/AOfzK3e7f+t3vk4is6llkt0ICM8LUZREO4pEBvRy66++UFcax0eU3VZYW07XShZoYeTOXK1sqO5u/jGxeE2+Bc8LTer44MWBA7mAtsVsOv9OC2V1wFJnAiT/1w5S/+uNtQzNYp1ULZG2ID6/07ALe9HQRTJ6yQjQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0062.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(4326008)(66556008)(8676002)(64756008)(66946007)(55016003)(38100700002)(5660300002)(76116006)(66446008)(186003)(26005)(38070700005)(508600001)(71200400001)(8936002)(9686003)(86362001)(33656002)(52536014)(110136005)(54906003)(316002)(83380400001)(6506007)(53546011)(7696005)(2906002)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j1Oxl+fAzKvC/J+WJSg4uHVD1zG6fsINhYVM+NjyIhahk09rojRpMH/4Titm?=
 =?us-ascii?Q?fI9tEkpEnFvBB0xUHzsr8C3B6AEM/Tm1p2pEPi5QVNOCjtdWhZfEqLLrrbe8?=
 =?us-ascii?Q?pQ2DGeJ2sIZwJLuNOeTwQLYfwFBW3g1LblkwQTYvKCCMP10WObmuH2oeVTBD?=
 =?us-ascii?Q?PoytdYTDgisA9/k/z104DzQ3vqrKx6/SbdOu1SUEqjUgOpCsli1mAVgoFcn4?=
 =?us-ascii?Q?NY3iFkw3ypAqsqkMc16R51HmBydFGnHrNY4J4S1qgWt4Qy3YzboO2s6/7+uW?=
 =?us-ascii?Q?r6CWAi72pprd2pP4iMaTUtkyhhCZ9X/C8Em7gfGaKqDB+rsSIv2AgEVmIr/l?=
 =?us-ascii?Q?4RuCIuMJfCoKzYwBmVdBX2diLY3GqmatLrra9roAUYSuiUSa409QzNnjRac2?=
 =?us-ascii?Q?i4NkjgFuF5LKq/sK877ix0hGFfNpdShyjjWN4GSuRoLdLaHcMV9cMwI8xIqY?=
 =?us-ascii?Q?Or9PhERBDuI2cM7YR0BcRgPI6jgA7gXErIz8El++mtkIpPLcv63VWtWgQDzo?=
 =?us-ascii?Q?VnTzaLjyUjCQ9RFh8mt6VmnPmuGgA2Sf8bqRYEO1cxICY8uTANFQqxXlBnMk?=
 =?us-ascii?Q?7sYItgEilXdjcBp0bDuSKS6JfTIpLsmvRVLHjx6nl+xwNznLW2VAq+cxlYHq?=
 =?us-ascii?Q?yieFC+eBvQYdTRa6fHZuxJbmTcVcd2erVTmE0HDAqwUBOGl179skYthFB2ev?=
 =?us-ascii?Q?2bscHg9ygYFqCydb30SKeRIrpeBzq3SQ1J/WUF0xH1y6SwpzQDTQB9krVHYE?=
 =?us-ascii?Q?q+AEfrXlEvTtQZFmGVni588BzoYgXIoLC38YSXqvrW4yHUn1aMcclkSVVz8b?=
 =?us-ascii?Q?DFkBsGZDT6LxkQ1b8Up5H9DUPg8kW96QT9ZFabW1gWOEx3jxuFHbqd7ncMFJ?=
 =?us-ascii?Q?f1fDAeKk5agPAkAxTyjQek9GvUTDBfoiyDJG5TRt/0mCqTXjVhVdxfhqo/41?=
 =?us-ascii?Q?pd/L/uy+GlVvEM29ZB/TwV6LX26FCkJCwmoxHp7aJ5jGUNLHZQkm027Yj3pT?=
 =?us-ascii?Q?onGQvnLbmLNQUmGywc1cdccqjRAwR/16lwYdL/SgVP6t4jzrKCQNy5aa4R1H?=
 =?us-ascii?Q?0gdMZDYSEqvobCOSeJNvbV4Ejm/ik1LkQe5mT7DpPNJseuaaB2fB2U6WxYzL?=
 =?us-ascii?Q?QZiPnQBNaE5xAuwY5nvn4f+CeMGcnCJtFd/99+AIV8rKinR/wdO7myFBljFY?=
 =?us-ascii?Q?DdGfOAJr/84/9ey32Gp4DSkHDZdfAk7m0Xgjz/wjHnowUeayTghxjM8u5jNK?=
 =?us-ascii?Q?W2nnNnOqBnNsFMCK051a7i3ZZYIikuRYCShmpcUNLP9zZMJWz3nTyHGdr6bt?=
 =?us-ascii?Q?ukhhalIFhzIUuOBMhS9nFauXEi60TYLTOizPujG3s5WVlrwyiuScdwtfTJxU?=
 =?us-ascii?Q?b54U59Z73vaST6A8QGq6ggYmf2d9CTbNMpkXFvp5XAROmWSW3NMDJAyGN8FZ?=
 =?us-ascii?Q?c7y/wlB//Hn5eYpr35t4sIkE1Jz35W0Rb06uTJ/uSPUE9J6Vf0O5WL2BXiQC?=
 =?us-ascii?Q?OoK6puCP4f9/OW1nt5YArIDhEjWMTZITK+QimINGtIS8HKJxJU2Tfj4owbxJ?=
 =?us-ascii?Q?h1iTCYrwNBjT255jCCz9U7oWuBuB2/2MOdwZZb5UZd7JAtwEhmgbZa4R1jlZ?=
 =?us-ascii?Q?NZ4TLCCTmScxDV8kfPnh72l2x9BOk5sd+ORUo+oHxEHRJjUzBCFgaQ5ROG/9?=
 =?us-ascii?Q?xBtZ6WVX0ePwPFJkJJrYYdwhHhfOjeQ0jUlm5pGj6bS2uzrwYyxTNR3PyJZz?=
 =?us-ascii?Q?J1F3KvMwPQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0062.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43df0ba-3af2-436e-c0c7-08da14230041
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 21:02:58.6441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yXza7ax1ncFQqtYHYQP9ENDrFY2wSp+JQWx8+3xX1c825l7B9JE73s5gWr8lttQAorreePl0fQFsXQIOwR8OfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4079
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michael, Alice <alice.michael@intel.com>
> Sent: Friday, April 1, 2022 5:15 AM
> To: Michael, Alice <alice.michael@intel.com>; davem@davemloft.net;
> kuba@kernel.org; pabeni@redhat.com
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> netdev@vger.kernel.org
> Subject: [net PATCH 0/2] ice bug fixes
>=20
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
I had permission to use Tony's machine while formatting patches as his=20
coverage, but it was my work in sending this series.

If the maintainers would like me to resend with an updated cover letter
I can resend this series or the cover letter as well.
Thanks,
Alice

>=20
> There were a couple of bugs that have been found and fixed by Anatolii in
> the ice driver.  First he fixed a bug on ring creation by setting the def=
ault
> value for the teid.  Anatolli also fixed a bug with deleting queues in
> ice_vc_dis_qs_msg based on their enablement.
>=20
> Anatolii Gerasymenko:
>   ice: Set txq_teid to ICE_INVAL_TEID on ring creation
>   ice: Do not skip not enabled queues in ice_vc_dis_qs_msg
>=20
>  drivers/net/ethernet/intel/ice/ice_lib.c      | 1 +
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> --
> 2.31.1

