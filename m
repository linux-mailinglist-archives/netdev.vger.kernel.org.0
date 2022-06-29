Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867E455F920
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiF2HgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbiF2HgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:36:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE2B22BE4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656488168; x=1688024168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cpdp9sOYBUqsPEOyL2G/uTC3iZuf9HtMFlg+S9Tjp4Y=;
  b=EQoJmIAcOpAKyafSEBAojWdUlUKXVmv24meU5lifiUSlTloZEKlyELZV
   xHnPmeErMQZfvjfwra0uKp5Z/7r2aSm9OnFBhji1i0txSJwPgcJ4cyN0h
   NCfpxAd7ceJX2uBEPAPdMCTvGJOSaVBPRDNnFhhlb9JXBNYnqeKupvdff
   db8356kI3zA/tJ68mWoYDivQFlxAVC8kPuG99jH6K/fgSnycoK/ZXmgku
   uWNK6qhY+cPHEhbnR/PE2DB1vJVxjlGUldUU3K6u1y/CsoQaBf2VFbNtP
   ZevGFk92uWja1wkR/up4v23zwswsxBT5lIhs0vb4BCRIaeqtKKUf1ZrcD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261753628"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="261753628"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 00:36:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="617479175"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 29 Jun 2022 00:36:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 29 Jun 2022 00:36:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 29 Jun 2022 00:36:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 29 Jun 2022 00:36:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3033DByOlx2WBuv0OHb1EtzZAAbew1xOHoeX0xI6SXLopZdga9xtwCfWeX4L/LvOUCVppZAvgMDrVTatA9enut2bY3V5Ci2b5xpmf0l1iapE18Mk/paOf+gyyh+fFRp1seV1C28F0Y77F/zi7T519uERPN5+z/sT/MB1fEGOguiz8T+GmlLh2K6sakb67MaY8vtIQ1k52RLjT8sKzuF1qVNp/6nZkelsYjx+mwSyZPpDtRP78o68WARpV5T7Uhx74hKmWI5HwK15bv/O4SCz3CsSKsiQDxdDJeQ8PZWuoBvA5Qr2VQ/Wxiua1frZ5w211oD2GfUKnCMYLbZoW6okQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpdp9sOYBUqsPEOyL2G/uTC3iZuf9HtMFlg+S9Tjp4Y=;
 b=iR/JaPZenNDTCK77wFOHEsfFHAAxUUnYMChi/My/B3z0OyrjdHpvMp5fIcpLIGvTAm6M+Kf0pkN1stK/mlQdTPwWgz4CercF8qtkdhiI39ShmKID7kvrTLbC2KZZJ7qdsjLASiwEvIwZJgfO/hJmpq1iSXfTHXnSOp2JkL+0XlMatV+A+dG4+hAi1s/T+OEicRT/lQWSlrM8pVwIIvJL8imYAU7eYAFKRrxbj+lu3X8RPggtnNMJ7EczxsRu7qvcqbpURixOuAzLq8feKxRlunEYy1aaKcEDNZCIxvtSo5szUv6xkhc+rFckYyIKe4iSgZ5Nth2wOu+RwiUkWU+1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BN6PR1101MB2177.namprd11.prod.outlook.com (2603:10b6:405:50::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 07:36:04 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3c4d:6dcd:23be:520c]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3c4d:6dcd:23be:520c%7]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 07:36:04 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Moises Veleta <moises.veleta@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        linuxwwan <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        "Liu, Haijun" <haijun.liu@mediatek.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Subject: RE: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
Thread-Topic: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
Thread-Index: AQHYiw9GHdm6VBwzgkOD4lqibbhwga1l/yrA
Date:   Wed, 29 Jun 2022 07:36:04 +0000
Message-ID: <SJ0PR11MB5008CD6D11D9D098F0251BBAD7BB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220628165024.25718-1-moises.veleta@linux.intel.com>
In-Reply-To: <20220628165024.25718-1-moises.veleta@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03055471-31c8-4337-57f2-08da59a205f7
x-ms-traffictypediagnostic: BN6PR1101MB2177:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aEJNEmzP2CAnPZk/jnYtG7kGSZJk0YxYhklJ2p90m01xC3UVEVPglcRY++o+XTeDzCPc/6U8qbung+u+F4A6RX9qU+jHeEagcMNAsWWNriQ5z8uznFOwi9TuWECdhjFk9K5nDEdcTwCvCDa8RpW51UbBlTwkZNm6Q7bO/mSnWDrP9NG74eM7Me5lch8IlMNymE7c7UB8EHqBfDPeq8i70pfXIlZxN3092wChO7fzlBkFFOYPjLkP2bkGWnIJ/Tz+hwM92tt+MOL6GgV0dA2vhurWnJ/i6gtdrL51wVbClpEikwZu6N6xeDOHxy8INmowHXLMb6qstzCZFXPfUG7ACnA5IEZ7iEzx20b/kpGe94pGNapbVW14XQ2p0l1dt7QKKWrTMD0eC6DTB/Mq8GX343Zxvbamw3V173mgitBtF8W/+chapW8brSeJ12SoQgdATI8TUlzXF2mno3rYa2RhBPzUTzyRckOlkU1tVnt1taE9zQb17PfiSPzpJHkiY5Md2nCwG2TBeBGJRu9Zg9NF1DlNmgHsE0fSkNzfRGt3IXqfszOgfC2qUpey4ir4FgFM2I69oWKH2p24ceHdohr9kV8/lqrKAvvgSAgeVhtpF6L4Y2enFYl3gVVJP39WdDehNXdQitPhLfIommnmuCjODHoGMqDDn3fE7nSdUmzV7dYzWeXFfjEAsNDpXGG3Y08C9HskP6FzCOcd/FvRWeFBzsXMwfyuH23rTFNmsGeJHXndJnY0z/ZhVIbHREVj3adJQQcig0jzUB0+1batWPEuKWHR0dsohfDExsOBmVcjyc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(39860400002)(346002)(376002)(7416002)(4326008)(66476007)(66556008)(52536014)(66946007)(5660300002)(64756008)(8676002)(8936002)(66446008)(55016003)(86362001)(2906002)(83380400001)(38070700005)(122000001)(82960400001)(38100700002)(71200400001)(33656002)(478600001)(76116006)(110136005)(6506007)(316002)(41300700001)(54906003)(53546011)(186003)(7696005)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BnS4mBwrC1u0l68Pi8t1TWOYBT/nCUSbI2kiz1GpIuCrmCzfXLTdelYRx110?=
 =?us-ascii?Q?slIhVuGR6J1q+BSY0dKY0BEOzjN5kkjRssl4b5Ov6FWF5NBThes7FP1pHPW6?=
 =?us-ascii?Q?Ego4gBNXb90xE/sNr0MJx19KRpztraf1q8bUJhm1JrFeFyETQMjW0B/f4GXE?=
 =?us-ascii?Q?RqlfiOaWHRxl9GIi/6YgVGYIdlz8M+Q/lirc5fJrSwvAdYEmCNOcXNU+uRIm?=
 =?us-ascii?Q?wYqxHSb0gMUmFnPV23gzErIzVF7TRvxFMFe9Azswe6JFpE5ZP5nYiO1Wzb4M?=
 =?us-ascii?Q?tTU9NNgdFCqVy+PlcwoIdFna1kx5RpWrk9ZTuefG1g/+Lu6DN+Zv+80HJr3g?=
 =?us-ascii?Q?tiIDEJFsayL6fmq51XE08WgfIAxmP/OTgMk/q47p/sXVgcpy9fpiphsELk8q?=
 =?us-ascii?Q?3tHb8J3sW2jyBecZhI45PsDsejSrfNWv/HZsf+hCDZwGGzFjznjkrd8Ukhz3?=
 =?us-ascii?Q?v2s9WRErEWLi3WxZxcJAeVa5A2RRYI9ayXvBodhkz4OR2+vzWoMsZt5VVntG?=
 =?us-ascii?Q?JcquGurnYSN9yqUsePvqMM+RgX0b6deONEAtP+mt2dUJKiB9a4mVLarqGFTF?=
 =?us-ascii?Q?uA+Xlz0SllOebkUQYqWfDXTBWuQ1kCUQSqTz20ochQxmYmnCH83etGm9BMj+?=
 =?us-ascii?Q?2gwkhtZXSmQPfjT4VbvDX+X+E1ps5JoVH3X+YlKXd53VfQB7ANBphPeVOPPq?=
 =?us-ascii?Q?k/AkdgqNXYKPptoF6U1mY2+3Yr/hNQ0WgyOX7B98XAF35miuhOrjTDdF7sBG?=
 =?us-ascii?Q?perI1+Q8leB2ZNYRKyqnc7hDsvIyZJo3kAiFItVqVBSx7gO1aNzNNbeJYBYl?=
 =?us-ascii?Q?xZ7kuvQWZ4qbD7EgOmL98gSD6v3qXUPwBuPOm87LCpRClgC4BhSaIExLME5S?=
 =?us-ascii?Q?049OtIFHex2BI3XeRK6nB6Lkr2zAzEO9veNn+FMW3gvGHfzOJrJtF5tmZLe8?=
 =?us-ascii?Q?hc4MseDDcAtriVwH/raPJ7TwrhHEDlUSjKjH0GE1C1BOWhL67kvnDms9QALg?=
 =?us-ascii?Q?UEljyinMnGMOg3JZP8TkKyAixx8EXbeQq6l+TwF97yXgCWzBHDf5oQM1LZ2B?=
 =?us-ascii?Q?RcthpvCsDTXaFw6ZJc5RddY6FuHVy7rBK+c5JVc2TXRRc5Dh4NoIrGSzOjmZ?=
 =?us-ascii?Q?10jLZgomKiBbUqiSbQzKIWdgZUEjmfVn1XBjkwsltNetU7/dnZs718fMhz28?=
 =?us-ascii?Q?qbXNjKGiDx8B+kmlNylFyO8jWD/3em24TheeaZikpf5pThMGfgEELaxK1j9g?=
 =?us-ascii?Q?fN9sj/BfuupAUC5ngrO4YT2Y8CCpQq39sXK1mIhievD9BYjLAvsYsy97zc/K?=
 =?us-ascii?Q?He+IXD4/nV1rG3vtTfkgVO/Vl8Oel4AuLpxLJAXG+rB2zfwaxhJ7hVy+6TUB?=
 =?us-ascii?Q?xAKjYS+QKPf4vr4ADGff6FKVNOLp3eDYIK8sgNCW3hyTiUWwfgs7u0EkEJqS?=
 =?us-ascii?Q?TOjH3B5dv1qXGHdkv6d+Z1MeaYg2/7Ba5D5cLywsPeWNXLBLTkfsp/ilywsh?=
 =?us-ascii?Q?N7NsJHtkmIQQDtKhZsBEv+uUOy5l2Wn3F6kpTbppWrG/z9yrRg3GarAVlTuH?=
 =?us-ascii?Q?WK+oAiDnMX1Y64BbB4QeqNFYqIFbOJDZjybJ6ajk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03055471-31c8-4337-57f2-08da59a205f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 07:36:04.5704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2UZUXpGerVIQCRsZe1g0enGgJSgfvtpl0PbB9uASZ391nrlUouuW3mkPkxvCjzXSo3rHhSQ7whjSH8IvwiahGKfYlL/FiXK5K7IWz/YNyyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2177
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Moises Veleta <moises.veleta@linux.intel.com>
> Sent: Tuesday, June 28, 2022 10:20 PM
> To: netdev@vger.kernel.org
> Cc: kuba@kernel.org; davem@davemloft.net; johannes@sipsolutions.net;
> ryazanov.s.a@gmail.com; loic.poulain@linaro.org; Kumar, M Chetan
> <m.chetan.kumar@intel.com>; Devegowda, Chandrashekar
> <chandrashekar.devegowda@intel.com>; linuxwwan
> <linuxwwan@intel.com>; chiranjeevi.rapolu@linux.intel.com; Liu, Haijun
> <haijun.liu@mediatek.com>; ricardo.martinez@linux.intel.com;
> andriy.shevchenko@linux.intel.com; Sharma, Dinesh
> <dinesh.sharma@intel.com>; ilpo.jarvinen@linux.intel.com; Veleta, Moises
> <moises.veleta@intel.com>; Moises Veleta <moises.veleta@linux.intel.com>;
> Sahu, Madhusmita <madhusmita.sahu@intel.com>
> Subject: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
> port
>=20
> From: Haijun Liu <haijun.liu@mediatek.com>
>=20
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only MD-
> CLDMA was being used, this patch enables AP-CLDMA and the GNSS port
> which requires such channel.
>=20
> GNSS AT control port allows Modem Manager to control GPS for:
> - Start/Stop GNSS sessions,
> - Configuration commands to support Assisted GNSS positioning
> - Crash & reboot (notifications when resetting device (AP) & host)
> - Settings to Enable/Disable GNSS solution
> - Geofencing
>=20
> Rename small Application Processor (sAP) to AP.
>=20
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
