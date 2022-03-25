Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E4D4E711A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358823AbiCYK0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbiCYK0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:26:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF79A996E;
        Fri, 25 Mar 2022 03:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648203871; x=1679739871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CXURqy5pZMFQks4k5mYSlygBUDaAk/vpOqyC1Kx5R48=;
  b=io7Sve/p9HvplC1CdHS/T01lLZWPZ77Bm5M02S9+pG0nmJZFjcZ5kwct
   W1LEMB8wKFRGVbbLgoRhxvcz+gEC0/o+jtn3OnqZ+MofFQUTTjZ5R5QDg
   YVrDgQ8RWhKUVvkfECieRDSgys8qTkJY59KbkGb72UZSmz2gBLg6V8dY9
   8ggy9LrDREo6XHUUvMXTLeT/Mf4BwrkJ/Z1pp66r0hTaKXejmPY78JZzv
   SO9+M8iiU+zsZwNkwrlz3OwwBf3IcgDR0ks88g0EvX4VnVKMM2mB6VY05
   TqNzkrb/vxIj0vVguAX2g0mJkDDxfrhFNzUUhBFKMFwCWXEesLoQln9Tv
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="246081607"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="246081607"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 03:24:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="648217788"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2022 03:24:30 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:24:29 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 03:24:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 25 Mar 2022 03:24:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 25 Mar 2022 03:24:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckhfZGBMAehjbpxAy5R8DC7zG82CI0U1nus+/xH6ruReIEnwcBQFr7x1ucuIu6ryLuP95qEJzKwM+zaF8YBGnysFMGE/nvNC2f4njrLlZRQI5/EzCN34zqsnXT/53W2l+etGq7UHsJgybCh0v4Z2suGmEaeLUU26qcvOLXwmQZUhYhaPIHq5Lol7Gq10ee9PcGy7sjqrgtvuWOJJGCP1X4BASSBXTXse6JDSYpCT87kIhS6tpNLzKSo4LQ5j3WaVM6YpSsAqZHk5vz7/S5H5x5eSnOn/mHe6oVEQ4/emajGw9bNCk08taLEaQU2aLezMh9FEQoEX282dBHvFz//Q4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXURqy5pZMFQks4k5mYSlygBUDaAk/vpOqyC1Kx5R48=;
 b=gCbqHJ1V5bDnusOwJnkPN4IEitRuwJNdYPcGoKMW5bBh+iTL83VBGfCz6RqA17pwu1qzVzTaW3BhMvb5WOCPLIOF479+vDwEJcZXTFa75QsjTM6xgsamPfnPaq1VobRkMgEdsSxVgTXz8FRoyEiaOsJgG/j5ONKEaJ0/fDBX2u7o2wvkHSL12S5kraIECesAye02wLb33mYVmdMzOedLm8gi559EQX0ulPaAb6g6swiQTB77VNyHeFLH4BkHH7hg/Hzzr/xzS4HwHZUODlt4o/wg4v50i0WtLtzb9BA7NhU7NsU4xdO5VLgLGt3o5QzO1WorkCmRQyv0jn61KLpDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by DM4PR11MB5342.namprd11.prod.outlook.com (2603:10b6:5:391::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Fri, 25 Mar
 2022 10:24:27 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::55b3:8a73:16bc:77df%7]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 10:24:27 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 2/5] ice: switch:
 unobscurify bitops loop in ice_fill_adv_dummy_packet()
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 2/5] ice: switch:
 unobscurify bitops loop in ice_fill_adv_dummy_packet()
Thread-Index: AQHYPRMQkGTQa1VV4kiuVyJ0OBqO7qzP6sfg
Date:   Fri, 25 Mar 2022 10:24:26 +0000
Message-ID: <MW3PR11MB4554564C2B9EB60EFD7D4D289C1A9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com>
 <20220321105954.843154-3-alexandr.lobakin@intel.com>
In-Reply-To: <20220321105954.843154-3-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7da4eda9-dbd1-43af-046e-08da0e49a3e1
x-ms-traffictypediagnostic: DM4PR11MB5342:EE_
x-microsoft-antispam-prvs: <DM4PR11MB53428B8AEE265A39AF75053D9C1A9@DM4PR11MB5342.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h28Ust1v+BpgYCEyZIO4Vui2EvVhurZwkb6wMi64ZV7lx+yCI5wwjdVun7a+4IuVUwfxfW2R42uLuXhZp3fp1wDdEHRVs6Dt2aZP+Fn+UvnsET1HJOnSUBLl3YTXQ/bglNwIBfmPndnSQ9/2Xy8us6iMwO/ilBiS+zPN4tCBtXNA3/LAW6k9LrVEsfXX2D1pFq43SKG4TGnkXpo1pHV9YS63nLcUxezpGCh4WbFvzA4bSCH1OfoO/kTvJxgZF8qgLbXBbpINz8nW4/bE8bjZEMtF9KaZljlkFKMOVgQkEL0r0nFe64r3ENTPx6IE3bF0n0b/TpOWKAVM9UvDcxiWEg/1aKUBQF41M9CUGpZRV5nK1gAPrHERVcO3Zt/SM5azqnxuJgUVkhX1YGbGgZM1wOl6aw3mu7bc+AhivGUOdNSgZhwn47nD9G5bmRN1ERhJ8tnafvn6vrsGygMC/39FLjo9j2Rti5J3iXlOiXupBzrN37+hMZcAXH6y64oZahVXAz0Y1goreSAx8H/KbY0wRJCol2HhyhxJEGfhKi/HG33JKAYqbQMHujgHfJ/WhYuLsYe7F69QOBy1qU3AVyAZJAmhmc9sIWq3/N1bW7RcE9mgMfR6Y/rrwXrjKLTJba+n7jUEZnAFcFdpU6injJM9BNOVO/vdW6g9zrtAutU4DiTLrNy3mBJeEdc/vz+eKrVjqROgZZuEkDowLAs/ac1fnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(4744005)(8936002)(82960400001)(6506007)(122000001)(52536014)(26005)(54906003)(316002)(110136005)(186003)(9686003)(508600001)(71200400001)(38100700002)(4326008)(38070700005)(83380400001)(7696005)(8676002)(66556008)(66476007)(64756008)(66446008)(66946007)(76116006)(86362001)(33656002)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6uv28mrIrZ/gMSanUHFVCaZZl2cU4RbR2CLvdMY/UG5U81pGb3GgAqX2vMJv?=
 =?us-ascii?Q?yIEUA947RzeXpxL8RENPoGLLwzBblIHlsoJ54KLN1+fIBDgHgunh6g2lF7DY?=
 =?us-ascii?Q?gLFlSbpa03xjCfXgnyi/Q4QgNE/ZltPZVaEQTnLm/vq/f2f1JwMyr3q5njRh?=
 =?us-ascii?Q?LAMWuOVks2z+hK2CVyAMY12Ban21ld0MGOFrxrQQDy09jZpxNWmzNIWjoMJc?=
 =?us-ascii?Q?GT9k6LDU8arICZ+16rc66gB/QqZkpqzJqT7f0GIwKd3lC00jlvtipIMaGQ21?=
 =?us-ascii?Q?bhcRSUB1fXJ5lzesXae6NuUjlg/XAYlKUp9oHXAZaa26Bkzd6BDOHwqHD7BY?=
 =?us-ascii?Q?k3hQha+JDV6TmBdl1hIEG8/khZuqvwTeSjNNXf+X6WzudpgnQhXelHESrObA?=
 =?us-ascii?Q?vMa2vg43uhWfAWWCwYIYjWlUYxhv61+AlkvkWjngErlRW8UymTorsakDaOVR?=
 =?us-ascii?Q?hyb1GEx599TWu5jd4eDgNBRQO/D1bdo6HW+qBz66NN8ZmiJ9PEBNOG5ZZmxk?=
 =?us-ascii?Q?VTn/fsdlWH6VLqunz6CRTmB4NIkbtjSd5hSUKW9iXmV3cfqM1eim0W11/cvk?=
 =?us-ascii?Q?8y+mWrWfr4ZctaKL5j93XjujZgjlBe7tiBx7Sxf2EWwJablf6zH5sET+HKfG?=
 =?us-ascii?Q?htNhxkKGoIcbp6HRuehEPNtkMnafww6YbrSVw8QxoTWdVUaxt3kF7WhtDC9I?=
 =?us-ascii?Q?gSiE81r2nFcctg2Xb5IY3FS35RXzNPyj3A6Z1IN78QAu/NwArmnytArTSg6p?=
 =?us-ascii?Q?sb+kUXHkW1zGR58fH99DdWhqBsdJCkHmFYEPFpW0T/C7huNxfNcnc7YlN/S/?=
 =?us-ascii?Q?5695+sPKZ2u+6Of9+E3ZQXxsvLPioRLnzZfMGlutTW9x3NnKSD81KlOsA0TV?=
 =?us-ascii?Q?irAhmIGySE9sVu2SMKiehggeUX3E18b1JLuhikwCxFfyYLIJcRyCIB64bqVX?=
 =?us-ascii?Q?jn53+w3ejjDSjwkNwaXu5r0ffU1mX6aZqDZkDMl03zeZ4BLW8AOwLIRA1RIm?=
 =?us-ascii?Q?Y+hjNci21X6flpDVfgzo/5/q2/mWGLQrruBdSqlZogajH4xnFFTU342HDd+9?=
 =?us-ascii?Q?rliag5+bsLHDMs6JOHpac3K4C1KyUyGienIoznypLvCkUxuZ2Ze6khWYL6vi?=
 =?us-ascii?Q?ZwkfZA78EMBbkvOgOPFT1X/ZGY4pNjn73EJ4zHaFkopHvsdvMM3Enc+2UZU2?=
 =?us-ascii?Q?0NsDzLBZ26L30OMuAmVmUxfkOrikFWVpD9cQVig/32rmaajk/4qbYPk9tsIR?=
 =?us-ascii?Q?1LXmNgf7GM6BgR5rqWTa7oV3lg77q28M46JueV4i/QOUOd3XnlHTVGYFslsP?=
 =?us-ascii?Q?m9Ns6R5YXrGgko51X3HT+o6LWcamA1mpoUZIqSTp4itmvO9zieAapgpqEq2Q?=
 =?us-ascii?Q?FUnYTZrvRYZmHe6wPwlh2vhcwlfviFDDywAJmPkTSphM2E4ug3MPwPk3wkhN?=
 =?us-ascii?Q?rPsAsGyPYlovhHPY44l/sikc4Isuml6jYXtoTR1CYOgTLPeuks4gUtF2TyaA?=
 =?us-ascii?Q?Pznxs07S/yD3DdPO1IP6Yaooiu15NeT3BQCXkoIGSqfKoiR5KxOPesnjrKq5?=
 =?us-ascii?Q?VIk8scrbaiIwZx9h4B+j2zXvdvjEG6ghfAnzlM7qcLETFnpfFmT+kfQsNcww?=
 =?us-ascii?Q?yaZUYYstoLwQHYw/798ZNjdvzuTPecFoBc4I8Qi3HY7U1ThAyGNua6o8Wn0h?=
 =?us-ascii?Q?/o4e3NRI4fqOUp8HIhOFAg/Ch6gma35Ffv3m6k033QTxh07KBF2agnq3D4XB?=
 =?us-ascii?Q?9VGTDuRt5Ce5O0jsv8TqGZWonEr0B6s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da4eda9-dbd1-43af-046e-08da0e49a3e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 10:24:26.9917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W8OvlCKvOs7tKu91pqDYtsY8CBS/4fdGbPzLj5RApauxA7VzO27mFfDhMbHZB6NrnENiwcXVpYIvYtwcUD5Rk8NDRHlv6H56+KxlDj0ebvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Monday, March 21, 2022 4:30 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
><kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
><davem@davemloft.net>
>Subject: [Intel-wired-lan] [PATCH v4 net-next 2/5] ice: switch: unobscurif=
y
>bitops loop in ice_fill_adv_dummy_packet()
>
>A loop performing header modification according to the provided mask in
>ice_fill_adv_dummy_packet() is very cryptic (and error-prone).
>Replace two identical cast-deferences with a variable. Replace three struc=
t-
>member-array-accesses with a variable. Invert the condition, reduce the
>indentation by one -> eliminate line wraps.
>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_switch.c | 16 +++++++++-------
> 1 file changed, 9 insertions(+), 7 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
