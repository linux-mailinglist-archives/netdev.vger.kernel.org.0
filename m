Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7658357D3A2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiGUSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGUSzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:55:09 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC63BF6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658429708; x=1689965708;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ua4WgKb7NZXEcKqv8tEVE2EyjNjzq0Z3lBcHaZ7nLWk=;
  b=n1jRTYc1vISOojfqv4MP/W8rZPHA3ZHQDTQKSeS3NmAE7i+kSJSX6Cl2
   Cd4JVAlSo2Rcop0rdw5ksZ3fVmpZunN1e3cjmhrWuSVODyakFDxdszEEA
   86utHXls5oKgdgA56IwApo+SKlBYQ777rEege/M44tANqfd3HAV9zfOqR
   9t6lD/Y+v5NXzeuRDNY1ljxzddO8vJrzQmFomRc1tNveUMQxrkmnZMB6X
   ABC/XaARGeyaDd6yokGc13MxhBEGgH05XbCApxFHFdRHbdX/MKyBomty0
   BocAtTFw861kOXS89PCbe2KHbMpPzm3npAJwjreQkgzmmy0pTy5G0APDI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="273999152"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="273999152"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 11:55:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="548894824"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 21 Jul 2022 11:55:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:55:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 11:55:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 11:55:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ym9Rb8LQH+mUzDwidiXnXWbcodvhrqBUyfSH+e+lkFSGfqaWRdXdy6/gZIoN8qxrVP455PebRGJXcerL8HE7HFRN8ABfu+lmJQjIJb5MX4RgQRNGqcem2X3D4RUrTHZROtqzl+6KLEGl5t+Km4ykSdTA15XgeWDwH/s85VVZJhLg9OOSNqH1TxzcD6UdhaeNLfnsJ9nY+Z7r1oAjtFbgJRsLVN34VIRynOLJ/vXprDT2qtC62JV5YnY580Hq+bHXxSIKojNpPpBCZ8eCKuAQ6Ly9dp1n9OHKiccVi+lTrBf+QuqTPTxajhWR9m2hx8QgvaocxFuroUwINLM2ejC9qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ua4WgKb7NZXEcKqv8tEVE2EyjNjzq0Z3lBcHaZ7nLWk=;
 b=OTwddiVi7k+7eoASxquwGDNhPPSR5ZmqsCjMEjiJ3jhUX8JsZWYzqNpKGUiK/rf+L8JrVx7h6AcUSmS6GRiDDh18MuW9iBtIx688qaTbMyIAcA0UDlA5cjI32GGXAj/zfYj7wZgpZ8JKMaFCpyb2MbxqDNRmW/ZuHlrvcLEY9oVoaraCZSCx9olEM8Xrq5GMJqSC+Ac88Ik82+oj+tu1rA+1mhscq7wvYJPmO8e59HDDz2EkU5KLTbwmBpz9NoBMEUFsTGxWwiLAJ/2bDeXQaW7lWKg1ob4EJUgZRYC1EeEQoUn1heTbgVzN2qDBb45rgMMDO6IoTRR509P78s0erw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by DM5PR1101MB2139.namprd11.prod.outlook.com (2603:10b6:4:56::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Thu, 21 Jul
 2022 18:55:05 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 18:55:04 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "snelson@pensando.io" <snelson@pensando.io>
Subject: RE: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Thread-Topic: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Thread-Index: AQHYnEtCfyuRAdli106siPlhlDJO9K2H1O5QgAB8gwCAANx5YA==
Date:   Thu, 21 Jul 2022 18:55:04 +0000
Message-ID: <SA2PR11MB5100CD9D0CBCDB2D0F76271CD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <SA2PR11MB510087EB439262BA6DE1E62AD68E9@SA2PR11MB5100.namprd11.prod.outlook.com>
 <Ytjn3H9JsxLsPQ0Z@nanopsycho>
In-Reply-To: <Ytjn3H9JsxLsPQ0Z@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad78c28e-e024-441d-5337-08da6b4a8633
x-ms-traffictypediagnostic: DM5PR1101MB2139:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NF5s2tk4Cuhts/GC8Y6Qp7FZMqYZlwqY9q4fev/Lji3mN2V42LhRBh8ZWVkAdVFvJhPvd2uqj/wKw+gHDMj21z3bY/z2KPaGQGcnCiOntwD76vxukIc6tH1uqsZfBZXMOM7VxczGuVGnBJl4XsrVbO7utQrxaEK3FPLFjdC9ZoZWjQcmCzJBiLVBGYXqhhQ2gkeCLVlpbl/FE4poPp8DkU7NgkvjY21BgveVXkLd7X1P/0a0rl8eY1JHgwIPKYWzXKec23O/oNsMLymbnSdoWA7wlH04o5XXGRsOEUbEMYCrk+cspiDPjAIxvBQ3xtyIa0FNPhNcdECdntMk8eoeM5A36r5F83tbQynZXzZO0aBNQJXmqrzLMcl7ljGRaBE5YuI4C8LqnrBjK/EUv3q5AhuWZY6wB8IlcrGLI6jziokZBCEHbt/qm3GKj6VLevSe0aLCrlykEQG1SmXLKE6u29l5lknNcPtdbVptGUONe1w/aFlujSghrH54t/ni6PqFaO+17lTyQzuKwLNTjBlG1KwGR8ui/0TgIRlEg7bCa/v79wTRm4O70n7VBH9zquCdESSafcWLprVKlTBQ+VDE5prASfS2ZJ+XzgBlRvBN9pqQvlc9D+WNuGUFSoOYd66h8HHUGaIkEMUgJrhFWOA3WIp/MwRgaUhU44RBXM2D1NqLydNU5g6WV3az9iI2kvbLvxBsTXxNf8oNE+KVBJhX/C9K+e0TV0FESnTun/7G9eHFFUURDe3d57Sr/W64GmNzuJyjoxFPQZPwUR59rlaCrvN0BYH3yBr7hr2foBBqy1P9dGDV2PcBy634CrvFHySC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(136003)(396003)(39860400002)(8936002)(52536014)(66446008)(33656002)(86362001)(4326008)(64756008)(54906003)(66556008)(8676002)(66476007)(82960400001)(38100700002)(66946007)(76116006)(38070700005)(6916009)(7696005)(53546011)(478600001)(7416002)(9686003)(122000001)(6506007)(41300700001)(26005)(186003)(316002)(55016003)(71200400001)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xvdSe1gAJ9CtJEi8rSAq0qYmS+nU+LJs6N49agBDgzPrFFFE3JHbmLrcZjFT?=
 =?us-ascii?Q?/MH/4feSUcfNDMvNZ3HtrR6x+2fHWKQ//pA+KGd7ThI7cM7kE9tjfWJknAcd?=
 =?us-ascii?Q?kdz7MHRe3cU1nhR8BBXvCOtN6VAgarpdJH7NsA2iiadN1IXogqpvdhLthA3M?=
 =?us-ascii?Q?0SqmxfYC6KOdcBn83A/iqcKwpWzgxBN+EVwu43RpakQUrCHSqqguQxEmK8yS?=
 =?us-ascii?Q?2xYO5l5ustWd/3wSXFG9X2WKqz5djfYi62xSBnp4QJKHk6ZITrnQ5acaOFIf?=
 =?us-ascii?Q?ymumzW4bAR4akRepXvxUnvdi4pXRIow1Q6/qja7V8YRYAJvdNljPaQLlugFo?=
 =?us-ascii?Q?QuKV04XWzBWcFaS13bR85lM9iLld6pidXb2MqFkBV3DDFR4/me1ZPex/8EKQ?=
 =?us-ascii?Q?2kE7xm1v8OxSAO101SkyKROlppTO2/mZA+rJ8Y/t2IdRE7688a5xcof3ti+e?=
 =?us-ascii?Q?s5Y4V5c1/brGw7YUDtQnMVkQGco4znhQpGhETRij7oRagSjecaU35g4B9/6f?=
 =?us-ascii?Q?W7q1dD4ti+A8zhQnr2zNreEUbf0dc0m7ierMc7INqg8gH79/DL8aUXvwFbkt?=
 =?us-ascii?Q?6BGvFcqzUAGwUthYxyRoNw/NENzygvLvhkvyoZL0IAcbkeC1Y04Iqi6w8Vzz?=
 =?us-ascii?Q?oyPuDQ41mvDPJfthr8cxdl/QT6QlxY1FuUwBAe6mdsmgXvMkwYSE8M+Zh1/l?=
 =?us-ascii?Q?B9hpQ293qN4UG+1+WcyM5wA1Lo580WbKiu/Fwit6zR9Qzph4ToLivqHKkLgX?=
 =?us-ascii?Q?p5FOLawbeBnFHTl7JLdvcDI/2g3BHoGS9FDK232pbM2FAUV5hOmhK5rtuJDA?=
 =?us-ascii?Q?1OFTZCyzXnKy28WqElsO9j9Gbz7FgORMNEHyih+/Zk2LAjg3NO+RAMfNAkvq?=
 =?us-ascii?Q?Jcw+LW8FFmFy+SAaZo6npunLsf79VK0ddgeoUd1RWwpqPW2z4Ona9hAy6uBP?=
 =?us-ascii?Q?yLWapmVBpqLYGz7vCyBLoNjDAYYB1uJhY0a8hZP++agFYJBCGaJjNshrrWZn?=
 =?us-ascii?Q?WiwxE/e/YTB2LvEDHbY+L8uABxpAasnj5dk+6sGAD1oC7u07MQoPEBEcW7Zh?=
 =?us-ascii?Q?XILA78NM0dCChkhAGbFdO9gTsptMefHV5cDBi47N6UHQH0jlzmOVwY0BktrA?=
 =?us-ascii?Q?95MGfoywdn58b1zbRZpu1ROw8Xacy1J1IbjA55wicwOcBaThqhaoERgJEQBt?=
 =?us-ascii?Q?j2EPZF5hiErG0xp0AfA9doMrAIiK2rVM+D6AUOrKmDMBZ/5vlFtU8pTi5tUF?=
 =?us-ascii?Q?0KEZcK0cYQFG5ZkbSgVXM/JfzIuxYW3ejfWX6zNW5s1Q1EzOs2uxXeT9+IzR?=
 =?us-ascii?Q?YbL+TeZ/LHaYtqj0D4R0DwDnT+qpZIk9PVE3WnRs5ghibFAVgBrxwvq9LwQ9?=
 =?us-ascii?Q?hsKaWEbUgUu3xxksvMPIyHcfRSoYZkP8/3Ml7Gwqxm77D2y6e0vp7ri1nBzB?=
 =?us-ascii?Q?ofarC4/6yhRl7hDLp1ALlB1LmsLVYG1gjLJo8Xi0p40BS6KVrL7p96wwZpCH?=
 =?us-ascii?Q?LB3UJtMbPWhuvLYFAlnIFxWaXXmtwK/xfYx1bRnOEOMn8N9ep24t4vo0ouv+?=
 =?us-ascii?Q?/Fnn8PoOFPPf85L4SmxXKsVAtoOXKnXrTmhMOLhF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad78c28e-e024-441d-5337-08da6b4a8633
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 18:55:04.9140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d0o3PO+C2TrNQTsmx5VwspjkWo8nx6Up7FJz8HZQxGj+TRzKpoHlKX8Do0XbDR5uEG60ozj4T4VKBw7ViVX5de+FYWXSRuEVRfNdBSEjiAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2139
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 20, 2022 10:45 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> idosch@nvidia.com; petrm@nvidia.com; pabeni@redhat.com;
> edumazet@google.com; mlxsw@nvidia.com; saeedm@nvidia.com;
> snelson@pensando.io
> Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
> devlink_try_get() works with valid pointer during xarray iteration
>=20
> >Is it safe to rcu_read_unlock here while we're still in the middle of th=
e array
> processing? What happens if something else updates the xarray? is the
> for_each_marked safe?
>=20
> Sure, you don't need to hold rcu_read_lock during call to xa_for_each_mar=
ked.
> The consistency of xarray is itself guaranteed. The only reason to take
> rcu_read_lock outside is that the devlink pointer which is
> rcu_dereference_check()'ed inside xa_for_each_marked() is still valid
> once we devlink_try_get() it.
>=20

Excellent, ok. Basically we need the RCU for protecting just the pointer un=
til we get a reference to it separately.

Thanks!

In that case:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
