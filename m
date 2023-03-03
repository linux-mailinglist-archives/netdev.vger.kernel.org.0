Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094126A9D83
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjCCRXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbjCCRW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:22:56 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439F7FE;
        Fri,  3 Mar 2023 09:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677864169; x=1709400169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MW3HjR7ioc9Xy//65Oj2VXm39eHGUwFACZCeOJCsNME=;
  b=FhTVQHttAbq3zqq8Wo2Ky40lr9fifE7yJiNdPMkE7tAzT0CeZOvmC/E0
   RSNbfqCOumoWIyHDaNwcHuiS54Yrhtvf9qH99m1xgzbBm6T7FP3IYRjYr
   +QwD5vwi2G6FUMS+H+LhxlQC6T+JJrvffoE70VtNlK1mwaWNnoq3t3Ibe
   V+H+8FBVvM/WwGIwZuCHfDXSrOfGzfNxr/RVA5RfSY3dxdnpH0aN1+2l2
   lsc8BWJYn7OcfJRVsOmuUM0kkQKgydy1Z0Rh6v5jkuiJ9af3NkJSuNzYP
   tLs1ZIA/YJHlKceOpZSew38Wi9lJf9jCQoxb/7++qSCkv4OI5Q1ywYGOm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="397686521"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="397686521"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 09:22:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="677716394"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="677716394"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 03 Mar 2023 09:22:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:22:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 09:22:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 09:22:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 09:22:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQwO8eETpROEki7jiuLZOzSlf23t4m4O/jzR0Vg5KkXUfMZW8q/kGvfAnDrbjatIHKF+vkYeb+silhC1u7jcQgz77gkdFrhSdyKz/+ohIjzoqqj4DkYx3tBCKerJJitnmqe5GHu7bPEHvoU10CmLW5kwFF0fIeRZyGdkAnfdK3Qxyie1sFEL+l6CaTtCuzQ5ssL1SwKQ5bg+/TSfGuwQIPmiczJxamGF1lz5Lla8L4HiGiAR6k7ZYsp/7/ALQUWErC2E18CgsPqDHNddZh5cOTtMkTOn5FAS6//wkJGfM4LVpQbiMrW6oCU7COAHK/t11lBr+HRRqW4wrRKz1cxCJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AiF3Z3r38HnvQTVKUkWblkX2BxxmlCvgEtA17GJSX0=;
 b=AISmRagNR22yyzTm4809Hnv8ZnUvngseJo9Ya/G0rfZIi5uIJjsoPJDK/rL5/maqWTJ0mT4w8emtmz3aO/oR/xYQ+8W2geEU3A2wUe6Pjeyl9nUYfpy8/fWQSpMSYnii0UZQ/bnsacUQNhmMrIIrJSq9Quo/oVPNC0FkOT8dg8y0ubtCWLaFyMybk89P5OCnXJigiGrSnwql4S6m0xh85F96GtAg2Kmk5nBJdX2tBO/Z79JvMP92EnLtn9etE8W0WT85AMeoPsDTKR27b+7e0cO0G9Fyp1ADSEFweUA6TAJfQ+BbPFUqxs44oONhHDHknceISex9QV4QfPGHTm7SMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by IA0PR11MB7883.namprd11.prod.outlook.com (2603:10b6:208:3de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 17:22:44 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::6b67:1c73:161e:9444%7]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 17:22:44 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next v6 6/8] i40e: introduce
 next_to_process to i40e_ring
Thread-Topic: [Intel-wired-lan] [PATCH intel-next v6 6/8] i40e: introduce
 next_to_process to i40e_ring
Thread-Index: AQHZQwny7T3a5cHoSkO/y8gBWohbR67pYw/Q
Date:   Fri, 3 Mar 2023 17:22:44 +0000
Message-ID: <MN2PR11MB4045BF46546AE64EDD08E76AEAB39@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <20230217191515.166819-1-tirthendu.sarkar@intel.com>
 <20230217191515.166819-7-tirthendu.sarkar@intel.com>
In-Reply-To: <20230217191515.166819-7-tirthendu.sarkar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB4045:EE_|IA0PR11MB7883:EE_
x-ms-office365-filtering-correlation-id: f3bbbc27-e6ad-46b4-520d-08db1c0be6f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFsAopeWi1bjUfN9neM1T1SdxHjL66f+L8B/ynN8wsY5KcN0Z8XuK7BE+FOIAnqw2rNyUQnAnS0B7DAEF7+q/BBm6/0xDRSukB9g0BiPfI8raWku69a/Vzdch8HmBVGkDf4TtX9SwNPi7A/p4q5WMK6iTZjVOAAN1sgjRGXtCc4RzrnW2M/SD40Lt6l7HQisF+9BSH3s4Phy1XAGWnxOZgW5k72Ua0CvPJUKWNHpNPR2LTWt3I8wOors7StY43w35ViwloHF6SrfdH9x41ZhzJ/UPviU5RPU2Pm05TzAfW8nWnTOyOQucPC72y27psrZUNI7fcqKbCfXoeZrTknjKlfG01KAnEp/G6cdxF0DuxoUnMmjMAOQnSWFn5CMilXzd+g6CdKSj5Gpdp+ny2N6dGgQnseMPgVw1hBBbSuyWWUFS16bPM8LJ5L0A30uLBtBxHWs5NhPPYEs6xESyn89v/7hmRKvnHPotO2qwlYCvpie9I1WN+u3L/r5XI5eUr5HqxVxCifVq8eTx5XiycEfuvF0AHRq2kcIYf3ukWEb4Z6bxs2qmAvnj0SioKzOzWDDfjW2jmunXDUiFKdadZn++izi9jwiaQL7qnRmhRJ1TMuKMsQZiTAgxjGYlTIJiCtQBy2CNxZc/sstgWr+ZrPy6oqHq2ApnYmwR3VnE9kIV7onUc3OJXmM1HubzpiI3C33fv0u0NG3TfS9n2c0oRUa8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(7696005)(186003)(26005)(71200400001)(9686003)(478600001)(8676002)(4326008)(64756008)(54906003)(66946007)(76116006)(66476007)(66556008)(66446008)(55236004)(107886003)(110136005)(6506007)(83380400001)(316002)(41300700001)(52536014)(8936002)(5660300002)(122000001)(82960400001)(38100700002)(2906002)(55016003)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GIes9lAtTXLuWCAeXTtq7nM88Az9RgUDtNpywFPvREmKrJJ2Fsqiqo645BgT?=
 =?us-ascii?Q?Nyis11YgeDWXCbAiFyeJHzSdflPUfDkBuVcGCPDWrUkiPFgx3CV4obFkR+N1?=
 =?us-ascii?Q?NmOC4YC8sNlJXR53EhlBMRBwmv8Kjymb8R35/dbzjne3bSguD8QuNppOlW3V?=
 =?us-ascii?Q?7Ewqon2dimaESzy9gs7HXMNcwYzA0tqVmiH+R1TDd+Okc/VP0iDYRSXbbomW?=
 =?us-ascii?Q?HTO7tRqKQ0eRWfS/5+Hpp6+VEshVn9ZPuF87oTlCCnJpKA+uLPl5XsnqvLYH?=
 =?us-ascii?Q?AIPGnYIjJvaCkK+AjEe8t9I7dR/gk5Yt57+kcUfqmcMgC44y2pIJGD0m2onP?=
 =?us-ascii?Q?3qt6UxJhWIelFRt7YULkyBKN2Mj8oiSyjMLKYUiME+gONP/wfhUwrf7LxJ4Y?=
 =?us-ascii?Q?msPaflpJ3KXp6ug/aDXTc/kAARwPC+te+JoyWLmImf+JlWlGO6jw5LTtxmM+?=
 =?us-ascii?Q?JaeLHUWy/RcF12iLBdb8CljdqmvT9mbfyDdZP/QcEiwAfWcv4FK6a/o5RrPx?=
 =?us-ascii?Q?Awi/RYiEUY66aEHTHGW3hxnwboLQOUXDa+rKTp41clhG9tqBF0z/gK5Y6vln?=
 =?us-ascii?Q?2Txg6FxrvSTunLV4/ZVVh8X89oTCv/ilB+pjq++Bh0xZPuM/v3iZHbRs6n1f?=
 =?us-ascii?Q?6nOJIuPJeEC4PUG8gIYJtoBESzbKfkjZ/WVaRjEDJ3XHaxHXZzgaON2xMF+K?=
 =?us-ascii?Q?0Escy2/1a3PON0VQbfXAO+EC0YRhuivdVWeZRjWoPKWH6vQyLIYSzn38Ky+6?=
 =?us-ascii?Q?tGY243LRES15RWdc9yUV6EtmPzJ4BNztN2w+Tg2/+zA2ANlTKna1mJGhQT64?=
 =?us-ascii?Q?UNMvBIx/Zg38AFDz6I8wYom8mGBRr9uPGlaEt6b27zRcxOd/WietlusceuBg?=
 =?us-ascii?Q?q/AbrmdWvLUf+HIvsPSlLgFd047s3qhp5VBZal97OdxN52SpdXs3HZrMOQKr?=
 =?us-ascii?Q?AvVOpB9sR2waJt3AKAbQpE9JCTVwizIqVejvF9GCxg/Zlxnw7oTDinNPqNhE?=
 =?us-ascii?Q?QZoHwB9RmjA0kEHcpYYqvW+lNL5QGkvtgfUeILhi4zvgKvkwfO4I5X+KY+Qy?=
 =?us-ascii?Q?LPEAMDKxCE7gkOZZa/vNTPeKdUpFpkbNImQMjpM1Wtf9X5ox+OGvBkehW7ZQ?=
 =?us-ascii?Q?f5hhJf/F6n2EgLxUWOcS1Gsx1U/ZtT9/pppDRQ2kK1H/lYBxAwWuj0qS3h1y?=
 =?us-ascii?Q?YnseSuXOObnCuHBVx4Sijfub0iBASH91mOsyVA10u6LCCZJ53qLc3woXOhjJ?=
 =?us-ascii?Q?UpnpHbE1L5dA8aiGZUVUVtaPpWEDA6uNe06YRifgJLq5OQnop9/hoNLuBpsd?=
 =?us-ascii?Q?rT5gvGr5/OMQzhZNGAOTHRn5jB0ExSYtpglTvPOiV07FbmIMR5p5HwG5JuHL?=
 =?us-ascii?Q?4vD1wi2YbylRjXR88HtEfSHHoIZ/je7CT4zFEx8cpBQAexux9X6BkSkybbA5?=
 =?us-ascii?Q?h9ubZ9PQt2n8yfTqlFYW6iEwWVXqVUQbH5FUdLhTZnQ+3Go+8vA3yK/jbc4p?=
 =?us-ascii?Q?0nJc20gom++Pcw39hIV1dHJ9QRL63MiBYyA5D6zJx7w7ALPHiN9QZtz5b+Kq?=
 =?us-ascii?Q?4s7A+dbfpFZnod84SU+WRWU5QuP0MyviJR9/uK95?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bbbc27-e6ad-46b4-520d-08db1c0be6f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 17:22:44.7159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uzZu2yZtumc++qGhNtZGc3chZE01zRIQz2GAWoKEoigHz990kUD4YLBzCMe0Vi4nk56AiUIdxDt7ROfuGFvZxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7883
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Sarkar, Tirthendu
>Sent: 18 February 2023 00:45
>To: intel-wired-lan@lists.osuosl.org
>Cc: Sarkar, Tirthendu <tirthendu.sarkar@intel.com>; netdev@vger.kernel.org=
;
>Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; bpf@vger.kernel.org; Karlsson, Magnus
><magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH intel-next v6 6/8] i40e: introduce
>next_to_process to i40e_ring
>
>Add a new field called next_to_process in the i40e_ring that is advanced f=
or
>every buffer and change the semantics of next_to_clean to point to the fir=
st
>buffer of a packet. Driver will use next_to_process in the same way
>next_to_clean was used previously.
>
>For the non multi-buffer case, next_to_process and next_to_clean will alwa=
ys
>be the same since each packet consists of a single buffer.
>
>Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_txrx.c | 26 ++++++++++++---------
>drivers/net/ethernet/intel/i40e/i40e_txrx.h |  4 ++++
> 2 files changed, 19 insertions(+), 11 deletions(-)
>

Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worke=
r at Intel)
