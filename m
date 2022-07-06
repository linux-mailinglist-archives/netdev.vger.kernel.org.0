Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750BD567EB3
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 08:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiGFGhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 02:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiGFGhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 02:37:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7030518345
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 23:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657089456; x=1688625456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jjdR/fGrwNg1iE86v7SEd5UYcZeZICtbmS3ZZ+yO6EQ=;
  b=Z9cF41//Np4/qbHjXo94AaAe75z83ZlQegDgz4EvnzafJrclFICHL9hI
   jysp4cbBVFfoNpbRWBcie7W15Zn366AmyK62D6f6bmpdpBYejpyCN1noV
   9kA/NI9a+hMinUc0fLFe/WjefAIRXItwxrlFh68K4kQFbr7RZd1MqziJt
   DBH+/mqEP1uH4FP69hOXJarOalCl5uZQlarZVSMFs/aAxkJD1pgusWR99
   WpmqxTuRPxXo4kE7Ti4ysllMn/fLxg3ReB9b5KB0seyzoEMFRxFkAINGe
   V1kvL15reKR3PKbX9SIudYpSIdGna8PpFmsm5nxTeyFjk4/GVRzvkiN3w
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="283684532"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="283684532"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 23:37:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="650527368"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 05 Jul 2022 23:37:32 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Jul 2022 23:37:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 5 Jul 2022 23:37:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 5 Jul 2022 23:37:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBigZYjyB3lapF5esNYo87/eYjPwkFqJlzPOM2YyOzlsrcH0kHZOFXdvN6+2mEjD18P7JGdPfb17paWaYdpc+FS3JvVGZL5CKYkIF7GiIUHLs6TdqsTf3y+Pom41yvpfVSqU5//ITs103uhHc4nBDZ75lM+dM0ABfViZshjhbPXyg/YBj8vT9rfqaeJRZuK58/7bqk60unA+CWNK6CaKCrbz/lE379jrGZuhv76DqTFe21LTQQ3VtPSLml5uul1hVcJ765OIf3QlkFE1xqzxfE2wfzZM1z8QyATxDAulSC6C1A7kGT+XMpgcZiM0KtSo12t5aQKh8nypDlmLYmO6PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjdR/fGrwNg1iE86v7SEd5UYcZeZICtbmS3ZZ+yO6EQ=;
 b=XZERJBHKuzaKI4Vv8Be4cUgFzHYg32O4Vt+hpXxKRtGVyE8eIujcjL8i181Ba92vlxCHctI2Fz87faQ8dxRFnus5h7fgjYDBQckBXncfkr9TdRlnNrqXTr/JQOeeVYC2QTyE60sRiCP6/ZMC0s4uMqSo2cgTh04ynDb2TSeggRr0/K/u2HZYFfzrXhJfFELqlNBnXthzYgQlp3DdqcX2KxGSmiasRuKhn0UGuL6SAtHFxgHwUx6lI5WV/bfNqAqDhUrPx5uEpEpIkPBwzjVxSYngMnhKK/Av0WyzmhxmTCDzhJv8YmykSkvueASyxAP284Kseu0FITBjQbnw1pVgPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4045.namprd11.prod.outlook.com (2603:10b6:208:135::27)
 by MWHPR11MB1311.namprd11.prod.outlook.com (2603:10b6:300:2a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 06:37:30 +0000
Received: from MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::44e3:9766:8ce3:4696]) by MN2PR11MB4045.namprd11.prod.outlook.com
 ([fe80::44e3:9766:8ce3:4696%3]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 06:37:30 +0000
From:   "Rout, ChandanX" <chandanx.rout@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jbrouer@redhat.com" <jbrouer@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next] igb: add xdp frags support to
 ndo_xdp_xmit
Thread-Topic: [Intel-wired-lan] [PATCH net-next] igb: add xdp frags support to
 ndo_xdp_xmit
Thread-Index: AQHYgD6dwl1hcwrRP0ah+N+cPoG8U61xA+bw
Date:   Wed, 6 Jul 2022 06:37:30 +0000
Message-ID: <MN2PR11MB40453D71C3AFCD96F5B1631BEA809@MN2PR11MB4045.namprd11.prod.outlook.com>
References: <3cd4bb394267b48b019fa6ccd4088577833051cb.1655245561.git.lorenzo@kernel.org>
In-Reply-To: <3cd4bb394267b48b019fa6ccd4088577833051cb.1655245561.git.lorenzo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a56826e4-be3a-44fe-1208-08da5f1a0066
x-ms-traffictypediagnostic: MWHPR11MB1311:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qI6rQE+YDdZUoNKNAYMecqJezzPbADO22VKxhjeWaKEQ5lN+Cbn0zJOEp/1irg2eLYilBxy+CNimtUiL8EEjojKSgkJ13Zow9ln6/gZbJbhg/EDqRKM6/dbK57RAa+Ej/IS0Y6WK6lITU2Np9K3k+kOZED4ec2zyURHxW7K8D6qXvpxb/nG+qQuFiBQ2E9a3/WNreTcZ2TOvgX32lsPwvfIaCIT9Shve1unn/ZHGE1n2LhNmkq49Rt4vU4CLFsBmsAU8kNriu0AYUl7JPiqj8vybLdozpL5ug9ggoMCttUsHepvc+8qaUSmjnWPjbiTkZysK+GkdyszkYZGrMldyOTjB8TMFpwBPwBTxYRRhrospQGnX39OrdaF2jQsTsbsjJmPXltB+Kgh45Z2g7JvRYijNSKnYLEMdNlxUaBxeNCIlv5cn4o2inGcry1Xh3jAE9D4PA8lMRJzhsCnbW0wZ1TiIAD9vKdIJvsg+xvw/mHl/yMggIxutfufN6iKMA8c8oAoPZ8kuzgKeB9WxL8KfMELFgd1nmtrX+Otu8cjCbpc0wLc4fk082oYUNRdm/BNJxphz4kddXYLt9Wqudao3xIkpmicadsUwWu0sNahgpkeestgyTAvfIcDqRQf1/oc+YZbhFou3FpwTiixzP8AoBG9WfsMeL7vrqPYq2ALwrPb0bXNrP16yAhR1+hWpofT0G/UwQ7s1E3x1tcK/V8IDLoC/M8RRWPslBEEyw+riMJLGFEY/dM/neRQ/yqDtaaHSTGPWMXj81t1/o9YEKjgPz9iDmMY2PK3y+d/saiVhANBR9QkYdcBR9gkXRfC4Zezi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4045.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(136003)(396003)(366004)(376002)(186003)(71200400001)(55016003)(26005)(6506007)(83380400001)(41300700001)(2906002)(54906003)(38070700005)(110136005)(316002)(7696005)(122000001)(38100700002)(52536014)(8936002)(107886003)(82960400001)(5660300002)(86362001)(4744005)(66556008)(33656002)(478600001)(66946007)(4326008)(8676002)(9686003)(64756008)(66446008)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vSsDV1JZ7jqfismZK8QshOEKB7EBXzoH9vXv/XBPjiTjesBd2ARuBv4t8T4N?=
 =?us-ascii?Q?1jZ/iyPvYt2DdhmH1YN8Qqjo5TLal+1KMEbSznDDZ37KDqhKlTARe7GwTW/L?=
 =?us-ascii?Q?2X3ENkwcAdF43ltAtK9LJdDYsC3wrK2l/IJ2Hdf0Dmf9qjAySPNBFkuKyIEE?=
 =?us-ascii?Q?Fq4SWQy+fKeThP3nbO50+Iq0Ul0RN/TlcE5w0yLEX8f9NznGxDjtCHtagODi?=
 =?us-ascii?Q?p9GdPI1QmMMi92/XffnogwXoxdetnrM4Mi5MsGpvQRF/Rp0TifWNnDPM6+lr?=
 =?us-ascii?Q?PEKmSmTunetC/VuP5ghDevKcJdq7Bltv3u9UFq9Zc1ZZl6PTwqoiKcyIXNlQ?=
 =?us-ascii?Q?T7ueB7/11yeRl7Y+6AdTeFzFcrUONpOX2kgCiyi8R2Ag+b9ZahIOUZHg0NGZ?=
 =?us-ascii?Q?VfmDHaMqV1L4/XlzEYeOTe4TEa6s6RLi5trmO2gRE3gWTqC7eJEgQzfKTqhT?=
 =?us-ascii?Q?LdCsntXm/4DhJJw7QeNHW5nDkK9hm9nvoXcc+evTLHmOiWTH6FETiCglZ6or?=
 =?us-ascii?Q?VmalZXhtC86xuf6+kI/uW8aiiwh4UXugHDbsLM0irLs9AkDaqw4z/IrS7Eix?=
 =?us-ascii?Q?a1M1RLy9Ugw750NsD0cZc2HxlvznpvPsHKgVn+mQNuFU5/VXz94lhbw6X8SO?=
 =?us-ascii?Q?Mgy/wHKn2OG6O6IOicQT0bct46RndffoRY3m+6fGlUdSALbDSFUBzbltgeJI?=
 =?us-ascii?Q?w5hkPD07kRgjMZUWXFzYQlg/ydARQrkQhvNS0Xu1ljsXPij+5F0keGd0UEAH?=
 =?us-ascii?Q?8WDK9g8EtaDX6pLTIUlL21Te6wsNgfWkibgQSIMqux9MMGUXLM7TTFiJlw8V?=
 =?us-ascii?Q?Of2c8F/4D4ivJ1XF7E+9Rjved13KLEXIermwM5ZlPjeslFHMTB2LwEyGrpMD?=
 =?us-ascii?Q?u4FaumQtX09/m60UK3izcUXI8hIzGZWmFxLiGgVJ0jM3bOP6m8Aha0Az0Myc?=
 =?us-ascii?Q?dpjP3uMo7BF9+QpT4/mB8d7G/ksnTBkHD41pU13CBypT4hLilh54OXqQ4iaZ?=
 =?us-ascii?Q?cvy8Lh5y5DL8waKkuEnfTbFoAr5d1WxN5zmTBowveiLuJi3w9JIjt8fOjX8X?=
 =?us-ascii?Q?56k+CjblqBSrbimkFs1IgQuhVEZzLjH6b/D0hVuQBiTtpxbHGqmTzlAfa2wT?=
 =?us-ascii?Q?Z0CYOcg/ro9F/QRirwmOY9l9O2/eGQUEaDXXg8nJMLx9VoErhfn+FYKofMYl?=
 =?us-ascii?Q?DbdPf37KE9rIW977YM6V84/+y7iG3C/ujFg8ndZz10hpLaqMqWZuShKgm1pG?=
 =?us-ascii?Q?I3ETTvx6JwF3cEDE1c125o13TiZFHcN6rztbkPfptT41fkcpp3k2u4oSD25q?=
 =?us-ascii?Q?2LuLPYngYwnyQXJjf8qk//2VSYmhL1nx+B4E2SXw+yXbBOotREamcJqLaefz?=
 =?us-ascii?Q?ZWmHk35KmHWFTWyvuTqeddQ7EQfBS4/6X14KIxcS6op2uMp/f52tMXJAzHsK?=
 =?us-ascii?Q?2IWUqn5uxHY74y8JPp3Ir4u1cZ7XpIVaQy84A9UEbP4j1sL+mvf5qjXKR91F?=
 =?us-ascii?Q?BMx+zn3l64ISIj0rgGa+V7dhmvLcnDAkbKjuwJrBCZoox47eviAgBJSGFK8v?=
 =?us-ascii?Q?Xb4JW4PLNriO48t+7FhlwrCwDGxYwBTxBWF1dm2C?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4045.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56826e4-be3a-44fe-1208-08da5f1a0066
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 06:37:30.6667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxEZcDs2g28Bsg12sJnAnxA8k60njk7jj6Z1jTV+31c9AGOa7NEOKBf5gSckc5PsImnxxWeTvKel/EgLcu24CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1311
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Lorenzo Bianconi
>Sent: Wednesday, June 15, 2022 4:01 AM
>To: netdev@vger.kernel.org
>Cc: intel-wired-lan@lists.osuosl.org; jbrouer@redhat.com;
>edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>davem@davemloft.net; Karlsson, Magnus <magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH net-next] igb: add xdp frags support to
>ndo_xdp_xmit
>
>Add the capability to map non-linear xdp frames in XDP_TX and
>ndo_xdp_xmit callback.
>
>Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>---
> drivers/net/ethernet/intel/igb/igb_main.c | 121 ++++++++++++++--------
> 1 file changed, 78 insertions(+), 43 deletions(-)
>
Tested-by: Chandan Kumar Rout< chandanx.rout@intel.com > (A Contingent work=
er at Intel)
