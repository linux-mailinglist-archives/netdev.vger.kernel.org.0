Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D30581989
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiGZSQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGZSQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:16:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34862A943
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 11:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658859388; x=1690395388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0cLAVNKY8EYxtJTbB4TxmTATLQE2l5nebNHadPTLMsM=;
  b=I7krh+FT7euMDeaJP1MGXFM7G68Ak/9x4hDiXHJCioC+YdYNdznYUP36
   k1ireHaHtJSyXVZjSTOyp4iv6DeAaJLQSMqjGnIFDKgYixpbyQBYVCbC4
   x4FeARH/eiqqfMjV2MgS7JxoyTFiwHpmZ5RSGKeu3dmP+qnNbIvVFD8W4
   eXUn0OaKTrCvu+2x95G+J/tGiszb2lnST9TB4WC+cSNvlR7j/5db0O2Cn
   ldqZV49IhYKxSJaojK60VYfR/hnVv6MwLUA0OBgZKjgxAIyDErXsXFGcP
   cxBLYys6bJr1PSRZMcUl16JrkxiHhf9FMqyhzh40O2tXhDLA13NHmhKOn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="285573884"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="285573884"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 11:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="597116085"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga007.jf.intel.com with ESMTP; 26 Jul 2022 11:16:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 11:16:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 11:16:27 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 11:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3DdrTb31omRFR1SKTi6lLf2CL+CJ0UevTKBtm8Ww5HG6Bhlf1e63eDsDUSnVAhB87WLeZHJs1eUTmdJMWXAzm7gYpqkGYq6Kbet408IWbnUmPkVpmHtD7s3n29dYAK0PyvtUYhO3kgGcOsXoEb6ly2iVA4d8Q5qASMAWdtziBFX/j0/zOkb5wNsFs0kxoaWggkT3Vk8MLnrd/RAzUXNHOK9GKbEgyA/oVRaa/e1fL2za8f5f1Bt2UggOfhFFlJEI2qaXTeEvSryWZKE+vM0W8wuaYhQf2ynjWsHQdUiOLPNKBIa7Vjtj+Soi8zHFb4sNGyOoNnDVx6fpy8ezr4TXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JHr2050OTDBsdsDGDH6s5VvkpRQNr0yn9DilrK0xXI=;
 b=M9Kqk+Y1jEB79fE4Q+yW57sAYl4/caNNgfIu6BVcDv06nBO+/H0Y/N/mZ9WHap4MIj5VkuUKH9240M0I32hwZYYIRb6RTivKtsoBldgDgxSB8ZuX1CzBN6nICmcNCO6ktD66D+nW8EmcKT/uNkIcPA7N3qtDl779RWT8OeIZtQNdRYZGbe3ROBPqI88+GCvlHLvHFN2ElPCJMgtERi69sHcmxCESeaMFvr52xAhNqB9jHwtSkTLDLdM99E5Tf9zHDlTu1P9BonWPBmMiYMp/L3cLG9eTyQIlU13CtffhpU+qYWD9UTDxcqaXAdDCYD8PibqnECAyLXY7UP8jHw617w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by MWHPR11MB1760.namprd11.prod.outlook.com (2603:10b6:300:10e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 18:16:25 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::a0d8:c7a2:c336:ac7e]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::a0d8:c7a2:c336:ac7e%9]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 18:16:25 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Gerasymenko, Anatolii" <anatolii.gerasymenko@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net 2/2] ice: do not setup vlan
 for loopback VSI
Thread-Topic: [Intel-wired-lan] [PATCH intel-net 2/2] ice: do not setup vlan
 for loopback VSI
Thread-Index: AQHYketK5dNfSR7/l0+3Cunt8t6YPq2RE36Q
Date:   Tue, 26 Jul 2022 18:16:25 +0000
Message-ID: <PH0PR11MB514490778B638C88143AD4AEE2949@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20220707102044.48775-1-maciej.fijalkowski@intel.com>
 <20220707102044.48775-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20220707102044.48775-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0e4a5d3-3e48-4e24-91cf-08da6f32f3c9
x-ms-traffictypediagnostic: MWHPR11MB1760:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJDeWskAh6KhIHurEqvRJlLFs3cibsN0rrrE8aklyOQyZkXzh9zSTcNk0zGkFP6mPKPAqATsLIJY8CH8GtjqQ2sRPkfVJSNDxcWClCJK7tWzOjzSncjY3nEWgVmkqclyQkRLLNPpOMUigrT06Nv3b6Im9BN5iA0ISQ/kw9YnS6n7HsG7SWlMkRnBJjmXle7Xtleo6QTRS1CHa68tUfwxqLhDOpZ05SrCDmirrIwN7IEp5aFf9xzwjGiNJN6xxFDBUt8a1kfrH6OQtGQB8hoBcU08pY3gZ/uPrc4QtSdDbg4hBj9rVS7Ck91ovODfY0RgPeqNPdY2jBPOFuYuxtXTK6KHzcFtZ35sFLzcCCcI0OXEfYRYj+UHS85nDvZ4doWNeckc42BbguzOrnOU4jPH0E1VfSEVUkBVv8QyUEpMgP7+PIwoUJ/3oAPu+RXVqvbMN17P9Mlw54ai1obd1EKYKY2/N7U4O+i+lDW6K8FMw0FtKuWfnqrZnE7FM3V8XMJfOw6U2cjuMDjVijBNaICVVnWZr+S5qyUIelIoktRSt86/s3zUlllHHZPZeN0AdZc8+aPpJLCl393dPCN2pTQsL6zV+pMKpF4HGW98mAMP5dRbsgEabSvOJujxC4voFOCxYUoLIDyvRTpzUy4+np3W7Pk3LmN/Rf0qevMlPsPwwGDR2ZDaLI0vLWCrBb+wMDf05GvdhPsJQQy1+hymLMsGL7gJww+/bIrngCKeo9sFb3mCweTVpG8lh6osMuHQGQSSLKkfO9umDhw8FY3vDis1hay7O7fyekAqLRNf3Hzlb9m/Msy2DuHLTPWfReRk3YrF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(396003)(136003)(376002)(316002)(4744005)(55016003)(122000001)(5660300002)(38070700005)(110136005)(54906003)(33656002)(83380400001)(38100700002)(86362001)(107886003)(8676002)(4326008)(71200400001)(186003)(66476007)(76116006)(82960400001)(66946007)(66556008)(64756008)(66446008)(52536014)(8936002)(478600001)(26005)(41300700001)(2906002)(53546011)(9686003)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4nO08ZvJiQGV+8LW0PScUaAAKgrNgHF/Jjwtr6Lex6x0muVpFoC8WisuKQdW?=
 =?us-ascii?Q?qSarOFX5KNJ0kt6o1/4PwUDJnauKczclzdht94zy9WdAneEO8rlD78E7opXS?=
 =?us-ascii?Q?AnCOqc0q6x/9XAnAEtEJdffJNGobkmXRJzSAdHZchL0wtgDhcRFVmui5Lba4?=
 =?us-ascii?Q?dz6tut8kLqOlsGEm78gVA7vhx/ExHgToFdkN1I+2UrKCoynX8y8uTkTo1n8y?=
 =?us-ascii?Q?C8HZhKK20rNO9DGJv2BWBQm9EKR9cqfjtGmP7lB9NNLfH2F73T89/44e0jrU?=
 =?us-ascii?Q?cwM0rM40zQkWJ5nYR6HHB3K+eQmkjzEvLr6XKr5wuH78w4/pL2m7DiLZwCIt?=
 =?us-ascii?Q?RUwQyHiRboj+76Jy6QUFjGflO881luxUhjmQFLpB61R/f4C3Ee5NN0TtLTVz?=
 =?us-ascii?Q?q1RVpgva1fRnL1rD4Ru0A7DTgZDsQsLzAMA1mn5HPVsxbTJCOenR6KsjBWk5?=
 =?us-ascii?Q?RkyVIyGtagrCY/+EWvDp2QEMy+tTp00nUPbBL1/74x9NEMDfw2IP5wZge2FD?=
 =?us-ascii?Q?A6E5F6oQRfIOG2mQFhctHPoweBmBYeLHaA5U80oxWMz0/hAJyHlBuZYfT8U4?=
 =?us-ascii?Q?xwy4Kvyn8LcLmimqaE1m5LBjWVWLgNbZib5xK+4nJXV6HtPRVKH1FexiO56u?=
 =?us-ascii?Q?T5HBRmLO2QDK3W+Jgkq9o5Q+dbdqY6SHGTeJPuN0B6qdmKhin/pO2kg10JWu?=
 =?us-ascii?Q?Yhtumq8d1Ute6WwyQN6EIlJWzjyC8/WjNVg0OnoW38jmruIaSaI0EodZ0vVa?=
 =?us-ascii?Q?vKbNVSidzNutBmyQRvcL3PePyuwLAJnPZjTAXUsk1bYTfJKU1IaqV0j4K+pt?=
 =?us-ascii?Q?cZX5IqI38DWSV1BIfyWai83Y9fMwvpCmuA4mhNkXz/Nf/VFrKqQkoFS0QmuA?=
 =?us-ascii?Q?+ToazmOel5jeUc9e3aY86l+2+Fcmpgixf75J7+3HTImx7TuKatnKcr5ZHnVd?=
 =?us-ascii?Q?hc2BxGtyTbCTURt27bNswTl0RpDjKxCAVfgUhlPVBaqsoIG5IVGVlYzJ5Umm?=
 =?us-ascii?Q?LjJCmlgZ+6/Dm7q/sZiJyNt2kl/c+CmMjJiCwzb8xmOZabH8T7wRmo4n9txy?=
 =?us-ascii?Q?RICmeRb/wRt6haNiJMpbs3WiFuVu/SmV7y3lU1cZLqaMDUsrApaXmALASvO7?=
 =?us-ascii?Q?81XQb5aw/u0Xq4Ua0daZU32Sfb6/VyjdUKGdl3OCqopf41h/1zdbh/AqJzCg?=
 =?us-ascii?Q?gSher71zIkqA+bheBQwyxYIn+tsyDz15Ws5mX7nlpj2VHSMO48EkkKlzNXKB?=
 =?us-ascii?Q?3m1S9QRi05DC6koUZ6kdJPRvzXEtoeksed2TR/BRYVF2bzuurHHkH5AM56hs?=
 =?us-ascii?Q?1411LEUSWj2EkAPSpnznU503f6WaeKzlMh+X68KB7NDRRtr6sAoqfOTCPIMz?=
 =?us-ascii?Q?NXrMpAaSs7wDka45ZOfoxAFRfoZ8Wsyz13GR9D9T7QlzUJZQz2UXIhtk/SXN?=
 =?us-ascii?Q?ayvzP0k8iYkm7vTrKG7NQYBde+bI85FAZ++gZD3Ojje/0S6sV3BZTR9K9Ll0?=
 =?us-ascii?Q?xphS6+X2SIUn1trqC+OFoujSfd10k82bOso/3/CjKRuV7dHRVFPnV4bEmxnk?=
 =?us-ascii?Q?RLpBsAtXyQxGZ1MY0S0aW+i7As7P9OlwGBaaUL0JdoMWMSmmEKWsMfsZwubQ?=
 =?us-ascii?Q?6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e4a5d3-3e48-4e24-91cf-08da6f32f3c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 18:16:25.4843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iaDmituzNNNxcQRH0ym49LpRoSniz8f/Z5NoxCpmOID4vOU7bTurt7g3GUEMcA3qRIP1Vu5mN2zEUH01d40wZoIfhMLQYrwBV+RhWtPQaRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, July 7, 2022 3:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; john.fastabend@gmail.com; Gerasymenko, Anatol=
ii
> <anatolii.gerasymenko@intel.com>; kuba@kernel.org; davem@davemloft.net;
> Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net 2/2] ice: do not setup vlan f=
or loopback VSI
>=20
> Currently loopback test is failiing due to the error returned from ice_vs=
i_vlan_setup().
> Skip calling it when preparing loopback VSI.
>=20
> Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
