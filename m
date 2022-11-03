Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1018C617DFC
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiKCNfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKCNfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:35:04 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA4C13F02;
        Thu,  3 Nov 2022 06:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667482503; x=1699018503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GZdtbq+FsSEWLMwzT765jcMQCp5SBeQ0ikVDVusz54Y=;
  b=Yr8ASm2w/PgU8nIYoChskEjmIeL02+wEFr6pSXM+3NzJUgF1bGgQ2ytt
   /87WVe2Pb0tPMxWKhb4RXS3SRxjhHGET0FDpXcjCvjmFK7cTFLytpiNok
   euLlQQuKfmPmxyah/M7WxAFKCL2TISc0EpbK2sOTekvChxAgnxBXDmy2x
   yJ3++w4LZJuD3fiOIb87wzS8Lt1jTY/tX6GqJ9w4vqQDUm+uMHzW08Fon
   p4HhgLsCrxsgZHXoLhbSKrX4TfB8ZXrhvjKXudqdVNVgoW9jFspWYNu6K
   NU8h6P+CUutVFP+Bg8/QLECwpHGl1sOD0bMIeObvO6ZRVLwEfeYXLXqr4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="373912147"
X-IronPort-AV: E=Sophos;i="5.96,235,1665471600"; 
   d="scan'208";a="373912147"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 06:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="637174841"
X-IronPort-AV: E=Sophos;i="5.96,235,1665471600"; 
   d="scan'208";a="637174841"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 03 Nov 2022 06:35:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 06:35:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 06:35:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 06:35:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfckQExc7HbfhY3CJBwf057NAEpZEZN+1FoBlxUJvC0Fno08vZsaipMBftdFFaH4ObtccnfAKt6GshrngUX76RhIYVkmIrEVCiOBOmSbUVXcJR0r+XAYehRH49q1+hVw8PK41JmYwLANBYU6utkH5CheRtnfk6Ko5lVqXVHIC/B8YUb51fQ4JYinm2kSa7McTIjTW1UGp9eGx7F5D5LCdR/o4P5t6jjkFFnK14ww3X5alDYMerOeiX2l9AnQW8DfkjqdOqPAYJHoawbGSw3gpCGj2JkFszdB5B1aCP/7rco8kM3xIy4ySVwbG/62vrKc20Kda+Y0j6OjSHEq639GLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZdtbq+FsSEWLMwzT765jcMQCp5SBeQ0ikVDVusz54Y=;
 b=XuR5aPQJcQ2/eMc7e09l82ZKFi6d87eYy0KxCvr7Hz0EO6JKTLjC1Jm3/xz5TQpuu3jDXZM/ovdbRTgAFgcBVJExkE4u+J+adbM2t3/af3eccgBYH1Wh4en0o7O0n3K5WC18Xff+2nLg1RXDf/bWVTlUaI1pVy6TBpzgOei76coEUfo5zaXWgiP1RQ9KsISwXyMiZlMDKz5fw58/Ktc6ugi7n5GgVF2FFqVRrQVUqyVb/0+TNMVHNn2YA3g8P72zBqSKrTqlazEsoq5mk+neCzlQVNn4sp8G4QlRzBoJ6pD1x9sm5wSZsGWtcwOMJHiBZl1Nmbtr0mFCUX4DEo3Zpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by SJ0PR11MB5894.namprd11.prod.outlook.com (2603:10b6:a03:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Thu, 3 Nov
 2022 13:34:59 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c9b5:9859:5a54:36ee]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c9b5:9859:5a54:36ee%5]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 13:34:59 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     "zhaoping.shu@mediatek.com" <zhaoping.shu@mediatek.com>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Liu, Haijun" <haijun.liu@mediatek.com>,
        "xiayu.zhang@mediatek.com" <xiayu.zhang@mediatek.com>,
        "lambert.wang@mediatek.com" <lambert.wang@mediatek.com>
Subject: RE: [PATCH net v1] net: wwan: iosm: Remove unneeded if_mutex lock
Thread-Topic: [PATCH net v1] net: wwan: iosm: Remove unneeded if_mutex lock
Thread-Index: AQHY7bX5vZQ9B2OaeUWy5bsZkYn9Ja4tLyVg
Date:   Thu, 3 Nov 2022 13:34:59 +0000
Message-ID: <SJ0PR11MB5008E87F9635347AC0EB2B20D7389@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20221101055033.47837-1-zhaoping.shu@mediatek.com>
In-Reply-To: <20221101055033.47837-1-zhaoping.shu@mediatek.com>
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
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|SJ0PR11MB5894:EE_
x-ms-office365-filtering-correlation-id: 4418311f-5a5e-44c3-2024-08dabda03408
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V1c4xo0SS1urT4wll/XNTdOCd7blGEbYyz0tsn2YP7GkWoPgkjZW5mPEV+TzVwW2nlL1iURTSRBdyv0zcXendxWMYkFlAPxM1TrFn5h2mBE78p09MMHoHf0iZLEIJPQ5PN2pr3fpgdCBUB60pR6MBbPr0DU79VUkndyfP6jjxPbSut4TU58Hbx4L1hxyQcet3jix7recotj49QUS8Duyo1gQ73KI5Zr4YZZ5UXIbJilr8JIJaRueoFUSZVQ1/Oc4XMa0HWB5/gfJ09mlRzqjvez1H8rbOo95DsO/r37OKiD+IbQMieVgNcMFcFkvVYpjR1tEaJFMRGcbEbKeKZijpsoxsna/SyajU8EiexmsxUuGiqGExvGerpVgd3eUROAOTTlwK16HzoKO1YSuWXXRljAs+qQtgV3y1yAyZkvr/hueNkaflkAfc5o8/RH5rRJE23hjtq2ruHoKjuOxpOXo9RLOtghEeJt8wLeFX1eb3V/hHCHMM3l7fEoEJpgMa9ZxdPza5QF+s/yD/hnWHCfVFuRAPchhBTuNKL9+t3ytEAit/BZf7JzXIJMKz0LBMwh5FJL8GgyjxYE46yGPm3e8ILcRordL/e7yjQBDCkc95eadgdYAIUsVoOwTG1u5FEGy7/jpbp+/lwK5bAcK3VID3h4yGbA7M2Y2a/H2cfrSgSvieDtNgwN4S0vn/W6gE8YdDT9Fnvg6IMIekNe4v5vD796kYoqupFJJdejL6cXrebnHHdpvVvpOxq73p5tRnI50fiafVrJv3OQvwEJhwOfeRom/1cVdGwAjnAf1oUPM09A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(4326008)(110136005)(64756008)(66556008)(66946007)(66476007)(66446008)(54906003)(76116006)(8676002)(8936002)(316002)(41300700001)(7416002)(5660300002)(52536014)(921005)(478600001)(38070700005)(71200400001)(26005)(186003)(6506007)(7696005)(82960400001)(2906002)(9686003)(53546011)(122000001)(83380400001)(38100700002)(33656002)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WcQbR7XUke6Pch+jRJjcn7JUnAU8hjls+kVpRxJNol3CaTvs26ezmwrG++4m?=
 =?us-ascii?Q?xBVjTDdXHLh3gLR7DIv2xVsjz9jSsqobv/Bu/BsTEUNgJR5XA9OqyozG9qvG?=
 =?us-ascii?Q?EJiAJ2Oxp8rY4EUYUXwOSIU/eg0EP40N/qRyYJvDsDAK+mN3Qrm0eZUw/OQc?=
 =?us-ascii?Q?OA68dfOEIF6Hf7GohhzUOrJKM/rqhGDkFOX8jHE0brNqJk6IBRjLKUz5+1zK?=
 =?us-ascii?Q?W7AworV5/S0YdDZVVxaxctQdEPny7Sg8H6H3XjUs+97WM/IRTCwMWneN2Rjs?=
 =?us-ascii?Q?pTiivWvfMLGNH3R0LTEo/jG1a8qgnMSR2TcKnv5VpDotAIEJQPxPKBru+mT3?=
 =?us-ascii?Q?VsGh1xnlHL6XGpEMkKnWjfxy0bUtWRjTxCCIAUlBb52pEL6Mh5ss1sJzRrPu?=
 =?us-ascii?Q?UdW4axK0Aw/b7Ia7OtsZMlEk7IpAXIMNBDwIQHV4WMQfmHffORdeiHkF2eda?=
 =?us-ascii?Q?6fUHqwqzuUEddT7FISCN8U2RU7OZb9OaheMR02KmfX1Ey9pWpM/LHkEruop4?=
 =?us-ascii?Q?lyxQG0hPGqFRbQUtfw806JG206cjOOYm10nsxeig9/2oK+kwEqwm3q2iIEV1?=
 =?us-ascii?Q?AFDjlkcTWwSA9dCA3CE2YrEEiv1gxm+lVSbKzTxthDulWW7bTwWfZMgMiC3r?=
 =?us-ascii?Q?HQsrGkNzXDHSl72+2VGhW42+TtoSDQOqvSEqsvKWiPKkHyKzDBel3dvfZ9Qv?=
 =?us-ascii?Q?pRgo3Xb2LHIxlTD4u6ug4Q09QO0dEW1Apt1c5nF0wgQkmpzUaxJYNx+ikMjm?=
 =?us-ascii?Q?ZJGuhd2YjaU+UbhQpTgyog8j8s/uDB9qaHeUqOG8cJhbxMkeWqBs8edJQrRg?=
 =?us-ascii?Q?HYgLUn0daFsgoa91+c6I3ne7MJpM3btNuEOvd3XKFx4JWIiXQj0I1j0ta29w?=
 =?us-ascii?Q?oqmaDTKpBJKZRKO+TzQEpQH6SjiEczVk//H4+tUG5dI3ycz5biNp2Rqmf/Ea?=
 =?us-ascii?Q?R+7UYpMQHi7ZwA83iTuv0rjXrJfgw8ZcqwKsNfvA3XIEyzyptOApiHyvUuE9?=
 =?us-ascii?Q?n3nhGSnhr1aQx5hc0La77/YJsQRTXAEScmEJMtgywsjZ6MB5ASZnLmJl+lZA?=
 =?us-ascii?Q?y9m909m7B3uhUaGFaMxayl5sWf5QMHg2Qpeug0jRwcSLXjp2dqL0H6e8qdLz?=
 =?us-ascii?Q?JnXuDyvGir7Wbnv6OzhCtFqdFxQhkXC92h/HAzsrTKbzB4Qi02SxGmkvtpFX?=
 =?us-ascii?Q?HYV6DRNvdUxRpCqIjvs+XNiFbpfZrPYcjLpo1umhhhMrtTc6hKajKPOfQtX1?=
 =?us-ascii?Q?PZptMGZfN3Lr5tRp/YwecPsXYFOrkS8V0Kbb58tXiufK8/cBSeoC0Do8kVeq?=
 =?us-ascii?Q?FBUMLyKRBhwLRkULuVM7nnoWcp7lJEOZMLo72scDyMu2KJVnogQUItsQdrQq?=
 =?us-ascii?Q?GEprkkDsk9AjD2pfUF78O0P3Roplo7JRZUUAjjl/dEqwcyWAvWTS5pFul7hl?=
 =?us-ascii?Q?6mRRXd31MpUzORM2eY1mduFqX5xqYfeb1nqwdkk7n8yCGiMAdA0oSaMRst1R?=
 =?us-ascii?Q?zE0E264orI5YtKMbOcYP784hWkzosEZ9I4Io5iPskrYMGI9dO7CFQ0IVBCWs?=
 =?us-ascii?Q?wuZKhxEfYEXN5z384gn/UimrlMMmo33lR1x/AzVq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4418311f-5a5e-44c3-2024-08dabda03408
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 13:34:59.1242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H+kQK2pecR6KsfOIuNJcfWWLdLG0QDrApWs0C5s5SS5q3GqCqdKJSTRpnhBCNLMQZvO97RkZ7Y9SXT9CF5xYrufmi6+nrYDgJ8iEdRsbiMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5894
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: zhaoping.shu@mediatek.com <zhaoping.shu@mediatek.com>
> Sent: Tuesday, November 1, 2022 11:21 AM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>; linuxwwan
> <linuxwwan@intel.com>; loic.poulain@linaro.org; ryazanov.s.a@gmail.com;
> johannes@sipsolutions.net; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; matthias.bgg@gmail.com
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-mediatek@lists.infradead.org; Liu, Haij=
un
> <haijun.liu@mediatek.com>; xiayu.zhang@mediatek.com;
> lambert.wang@mediatek.com; zhaoping.shu
> <zhaoping.shu@mediatek.com>
> Subject: [PATCH net v1] net: wwan: iosm: Remove unneeded if_mutex lock
>=20
> From: "zhaoping.shu" <zhaoping.shu@mediatek.com>
>=20
> These WWAN network interface operations (create/delete/open/close) are
> already protected by RTNL lock, i.e., wwan_ops.newlink(),
> wwan_ops.dellink(), net_device_ops.ndo_open() and net_device.ndo_stop()
> are called with RTNL lock held.
> Therefore, this patch removes the unnecessary if_mutex.
>=20
> Signed-off-by: zhaoping.shu <zhaoping.shu@mediatek.com>

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>

