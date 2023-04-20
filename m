Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547466E9D8F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjDTU7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjDTU7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:59:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C644220
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682024376; x=1713560376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BazpryclG3GeRQFbGe7hwetrO+5gJO/g5mQ27TxjSaU=;
  b=mig21jN8TCAaYjcVyjXRiAmLFKi4IoRvFxy+xTxsLlMr67RNaHRjKWOL
   sWcuwLZ2WPBmu7Szg2pM/saGzMhBPm0rTaw/F0IGwc+wNZRxHZ8mOJeZO
   XwP+G9MaQGJq42uQ16AFtWgz7vISeKUpSQlh8/FfaYaImEEaOIxpi0j8o
   Dczv8hKivLSudS+RQKnln2xIH/GvUicMjgsNW1l0uCYOjNZq53mH7PXRd
   h/4gP18WAxI1FhkrBKUcS2E1wg+CXwmPXa2kIeSQ1JmdSSanmNhlQpff6
   ne63imbVf/8ZlpJJDnOpKKJSK9Fzm6CLXeQnYyCCdQKSEctTk7HqPThjP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="348640475"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="348640475"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:59:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="694713961"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="694713961"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2023 13:59:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:59:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfTOZg+L9TJoHdLlJcvZQBRGjIeho7yR5T2fNyZqk5rApYKRmniEw/DzB3naVyvZ/oCeuzjgyiSmTItAgRNnymsFqKR/dZS7kq9Rqvx5UA9oGQmtAD+MH1SJgGvSvJ/fdslwGfuUoTI9cBYCocc+qEYQ13kx7LjcK9nRQThSoyudug6sTZ8etF42D7EwbGc/sUqcjj2wxrQ2pYL9KK1P1thQOgwXueCB21CzwTAcx+V94wakeKmGCBvPat2+IpckBswLPLRf1rbpjDC4wyGKqJJt49eEvkvDNT+l4EJFjSIHgntV5qPhwA2Y1s3AgUVZTha5tAKASaaICJBhJUFWiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nna0KKeRFYAHA3uAw2e0k/SBppFqHcJvDfmCH48I2hg=;
 b=dWu+MQJGCOmuMvd/J89Lpo2/TNh0xVcarqB6WHE5I9LhCKuGE0Bn1Zb5x7VeYRcJSOpQT2/HYH6/Vi144TbH2dbiI/k0KgoGgVLsUz69luD/5kJa61ozQlpSKcZRavYSMtXHwDUw8HOHrTs7ZB/t31hW/lYcQKjf+CWgrWJ/Ao4plXGSIc2jOlqQUukgeqZAfgFv6Lut5ibRocth07kX1rRu8RWFuYN46VWdJnNgbVZXFpSilhP8+E2xi1Lth6p4e0Ju+ocfbmfJhR5Xkr2jvprotFTRm581tQmu+/CHOBW2eSbv5oP6DFwjNpIK6q7RJ/KS+ohZRNDoY3+rpIYWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12)
 by DM4PR11MB5472.namprd11.prod.outlook.com (2603:10b6:5:39e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 20:59:30 +0000
Received: from CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7]) by CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7%6]) with mapi id 15.20.6319.020; Thu, 20 Apr 2023
 20:59:30 +0000
From:   "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 5/6] ice: remove unused
 buffer copy code in ice_sq_send_cmd_retry()
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 5/6] ice: remove unused
 buffer copy code in ice_sq_send_cmd_retry()
Thread-Index: AQHZbRe3U/dpfa9jj0a5yo/eevoFea80urWQ
Date:   Thu, 20 Apr 2023 20:59:30 +0000
Message-ID: <CO1PR11MB502865B08CA323B215F99A55A0639@CO1PR11MB5028.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-6-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-6-mschmidt@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5028:EE_|DM4PR11MB5472:EE_
x-ms-office365-filtering-correlation-id: f321ea7c-3e59-44fb-a240-08db41e222cb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZhpuGZgOgU/zP6XlR0GZXUq6GDwLlvTFKbfn9u9hJKdBGvUVFtdBhaiPYqt225VotKAroa7Jc7y6sj2dEYyLH/FgWyU52iMev7uDH5mAIUg0LSyKD+tdAPoPbZMn8nn+PnM8SZ1AR7XRjtaxtB2VGqZa+MsgPrvt0C8Y7eS92n9DATT6sczGOgjvULYICCW/o3i7XpPcTbOLUanSJhjsPmtrAD7PvzK5FnlWpn+QRkq8di6DAyUsPoLT/NuK2w4WsiqbefmEbkn4PuhT+BHoLc3G/Q5Cd9y+GIyNhWKNLqKWFRK6UBkthv6E8eP1An5BubPIZEmUgE7C2eqBw7ba/lViSajZwkIxje4wvHFY7W3fY2UBslIApkqSkSbt7feBJIi1ybBBXLgV4iyyokEdqPFqtOA2KsHisf/jOUY4yJHNSr2Z9JHu0A8TzYecSZO0v1TEutzurd63Z3VvK28bGgCH8IxK4X6UN8ZLTeAXHLgwsdufBQY/was3O8RkWJ5bbfwItPhVXCGHDyaR7O2fa0xnz2/Crf/aMq30g++XO1u0jF4SMJ4f8suTunMWrqkiLnzAoPo4DiWQu641e9jMry5uwlHtSTtumqmLz2sgriC0EfAocof7GXZpvIsOgmv9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5028.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199021)(41300700001)(76116006)(66476007)(64756008)(66946007)(66556008)(66446008)(110136005)(54906003)(316002)(26005)(4326008)(478600001)(8936002)(8676002)(83380400001)(5660300002)(33656002)(9686003)(6506007)(53546011)(52536014)(71200400001)(186003)(7696005)(38070700005)(2906002)(4744005)(122000001)(38100700002)(82960400001)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tQBrr+XDeKrLrRSwpNAvloKS0AT09xUlggDVehQeDlAqLjVU7TIVNVAtCweg?=
 =?us-ascii?Q?OheU4bA9VdltdRkwkFpwJtpkM+S5rK5CcXF+4Gdep6XqhEIZb9S23e1042ij?=
 =?us-ascii?Q?m+I7SxX5CXHIKSA39u1D9lwCZxZxV9V7Ppl6RDBGu0/RkeklbicWmRn9j5yr?=
 =?us-ascii?Q?K/r2NJuy0HnUvva6NSo+82M/Uh+6WNBQR3iL0y2btHTAceN+GbgRt7WdjCNL?=
 =?us-ascii?Q?sI+hx+6p6gbu4cthTLPpzEzjQagjlzpZuA16ulJUs58zX9WtVPbi2tG8dgfd?=
 =?us-ascii?Q?44wwl7V1NBRmE8+MquN68ailtLvLbeL3uYZO8jTVGGAG01lmwfwcXNDuHIYr?=
 =?us-ascii?Q?bWOln8jCRgm4VLUsUGe2ahCkhEsxhWV1u5vYXXIKpzIrECbxuE6kWpE8PFdQ?=
 =?us-ascii?Q?/ig4pwr7w3CXj7xEqeYJhavzCMsdG7BGhizuleV7J9Py42KyBQ8imJKcl64A?=
 =?us-ascii?Q?A1lQaGq303rOPpwaRiHtX0jhkfaEMIpZP//sUdEiC74FqAFIv3nrJZkR3bgV?=
 =?us-ascii?Q?A8oskzCJhm1Wfk0Pvkw2VmHNF+rsEk7DdCi8LCVLTcI6B5O3XmUni4oRgtsb?=
 =?us-ascii?Q?xH4PFf8VZ6eUnQfh3vjIOOfoqUSnN2Atb9rpEOqYbNl67TTOAmpnGKXGLwFO?=
 =?us-ascii?Q?vYjW7HAwY+yU9HXybMvMvxaB1Ri8Sd10qwZOPdOGRWTzoo72pa6uUvs4kw3l?=
 =?us-ascii?Q?CFiAwxGT74LxsxAnDY9BqCNuHZKlXNPK16FTU3K101dNdOFy0U1DS2dppqC6?=
 =?us-ascii?Q?FMKEt248DLO8hnD2XOL3/blWIl+pqfpmXDPSsDeN2RJiR/F3oNhfN5v22u2d?=
 =?us-ascii?Q?GifGOnpHDmEFX4A+coZNctJjFceQ2UWm6yQ3YnIhNMpfH1uHUv1lPg9MDCDn?=
 =?us-ascii?Q?hHUnpy31LPjeJcODmWIQe9Xpd7qrPfVi74JpnzV8mbW+ZV7v7gA8EvIQcwV5?=
 =?us-ascii?Q?H9xxbbCHa8oBhOHUs3AIw6lNdIuilb7670/2hHSYBBDo9PHgBnIv9u1y9eQa?=
 =?us-ascii?Q?skaqlaBpP25VuFrDXcrSZX0BXe1benHnx9A4WVLgEgQzNCyqDxX3/b2uBUD1?=
 =?us-ascii?Q?tbDUl0hjegFj0HGBIZf5B3igeAUmYWcCynvtNff9Z7zv/+lt1nZYX1ohIUci?=
 =?us-ascii?Q?4xk/uZcAxdEuKd4OhY5l6G8fiY5Ave2qycWb+rS7ePyi+87XhZC6DHwZjYxf?=
 =?us-ascii?Q?5GJtkLqW8ZVMDY+eNReQKfY1/n6qcbAnMkGfGrd/SqphJq+8I1iOI8wYzmJs?=
 =?us-ascii?Q?upjfHY6YyE9wwL+zMa9OKEKjiHpFPB2X641rV2vbks+KPyt4DXCbdVwioNpL?=
 =?us-ascii?Q?sznpasGVjBlCjKUtrCP6m2LQr6vlunCtbYxnMKWPdHHWXpJOrK5zh9l6ab4v?=
 =?us-ascii?Q?HCf0AS4f6D3NK0LKCAAEO8vCUiL7dQ3tmN+CZAITYpg2L3TZOW0d9RkG9SQ8?=
 =?us-ascii?Q?fFQVlDxFNvxUp1D272YmhJnqzOkgItldP9U35BOhfw99wCM+sk7p+bjF5S/m?=
 =?us-ascii?Q?M4Pvv5jXk5Eoeo7CfXptWXmvMbz0HDCBx/8rVI11hLUS0mrPVmNMFDzeoRw/?=
 =?us-ascii?Q?Amtxq+/dcYCZSMLKebsxkoFWBUxkR2b7VbqQtU+vBLi9SS/a8BeTUxpqbr7A?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5028.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f321ea7c-3e59-44fb-a240-08db41e222cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 20:59:30.4838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvGZnCvzDqBtGXjkHTQ1QvniQSG/KoTmgOnMNgQfAJQemmXB5qNf/nNKSl2JK2gwYv5wpOV8XLb+WKX+o13a4NSioTsqXK4wKtUdM++dkdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5472
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
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
ichal Schmidt
> Sent: Wednesday, April 12, 2023 1:19 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Andrew Lunn <andrew@lunn.ch>; netdev@vger.kernel.org; Brandeburg, Jes=
se <jesse.brandeburg@intel.com>; Kolacinski, Karol <karol.kolacinski@intel.=
com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Simon Horman <simon.h=
orman@corigine.com>
> Subject: [Intel-wired-lan] [PATCH net-next v2 5/6] ice: remove unused buf=
fer copy code in ice_sq_send_cmd_retry()
>
> The 'buf_cpy'-related code in ice_sq_send_cmd_retry() looks broken.
> 'buf' is nowhere copied into 'buf_cpy'.
>
> The reason this does not cause problems is that all commands for which 'i=
s_cmd_for_retry' is true go with a NULL buf.
>
> Let's remove 'buf_cpy'. Add a WARN_ON in case the assumption no longer ho=
lds in the future.
>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_common.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worke=
r at Intel)
