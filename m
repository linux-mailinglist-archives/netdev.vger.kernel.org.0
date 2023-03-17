Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1DD6BF106
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCQSu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCQSu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:50:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8624FAAE;
        Fri, 17 Mar 2023 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679079025; x=1710615025;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OUt4CKM8wJQytWoETPIyiJLoo43dtdvKj2aQBqgMhD8=;
  b=X1FrjPTVAMwSMMNsgpfBY7Y+r1YDhAROLwLcqozNkESsVPxMms2U6w/M
   4UrKb7HBTROCHd90V/OOyRlw/J7jT7ZefyZRL+ZD51LOVcPh3/h5pHRzg
   dBm1Sp0Nxh60GXBo+09EvBOEV88puPdYgcYl9GSfwZ050/91UwL+rswd0
   q+BPN/uM1dOlbPwYResjbvvD1NY8yk3aFFn85BGKJJq20MNu5bn+Jk9kB
   6skvA3BV0/HDyreTfGAId2Qi+WNFPRiCdciUjqfdfzAame+suyuNOUPVW
   A9tt33l/lafirUye8SCIKjf1j0uLziCa7uZqO7wvlAXm//4hzQRuKep00
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="326699945"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="326699945"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:50:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="854543000"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="854543000"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 17 Mar 2023 11:50:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:50:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:50:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:50:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBMpFvAS2P+nqZ5ZBRFVuDhefoH8nfIdqv1pD0msp6J/2Sc9X8EKp32Kt6CHavGBFVeCTS8iPCPHeZqa9taEfBGigTQUzfuI//3sms25HCp0cr46PiBUQCxxiIe7MYu5aoYYnIaRHf/psAURPsX8JmdkFQHXOikNm2HRLqdlezAK/c4cIrSo0ohOGU0ROHRVgY/WjKD3qUrSDTmqdMXCu/uNE7thWStPCtRP0o6qrOq8mWKpoGQsryVakFQa9qzwkQLIsBd6/lFZa9CTRZMm7rVJ17E5WwgCfaUNg7Bb+ShDJGCvyMy29L3dNhB7a2CjVc3bn9KmT8io9XttaIT8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlKQrP0CVXCCZ38xHfkvu8CVKniCEIWOPbAChW/eSbA=;
 b=MVwUubsO2eJtFEnJufCUItKOG6kEPdDAMHKnj2MiuBfel/96xjGpTqWdkV8+X43pBZudrn54GQNtSYVKiSJ9dWs9+kagaqNWJHQLFiC92s9tKfkDZd7Zq7CR20Vy50DErcUJMFncMB1WLU9bKNVxMmGBBG4JITKg+SW4kK6gNLMu0T9IskCppM+bxJtBqO+fnLB9orDI0w8XdfH83irQXLfICRWGrZSmIU+2ekMWFokszak04/6mAePW6m4bFwSo5Oddl5G+frmnbMru2cGBRnDHJWn+Cynt9y7dlovssAazeBJTUd96q3CaFGkF7l+MM8tEJwfoTzsvHJy+HkorxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 MW4PR11MB6667.namprd11.prod.outlook.com (2603:10b6:303:1ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:50:19 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6178.029; Fri, 17 Mar 2023
 18:50:19 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZVIpWqQ/E3o2ZU0SoOV6Pk96rvK7/OPaAgAAebjA=
Date:   Fri, 17 Mar 2023 18:50:19 +0000
Message-ID: <DM6PR11MB4657757B44F3AC7AD79C43A49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com> <ZBSbE+8p/u9hl0JI@nanopsycho>
In-Reply-To: <ZBSbE+8p/u9hl0JI@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|MW4PR11MB6667:EE_
x-ms-office365-filtering-correlation-id: 780a9278-9e37-437a-6cf8-08db271874ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LyNoEoF6i+srbycL2b4UwhmK6C/N2vyFkJqUzRiVLYPOVu9vueQpCOSj8gba3Zkb9hmj1vLXk5JOCZzTKZuMlWNJ4fCMT4nsuaVCX3dSGovTZ0WxJJzaEV3zTU54BcHtIydl63txnra7cRXF4UpbiWJRwTJxpnY2ohC8O3bljY4aPw5Pb5eTddF2SzS2PskgQmEukcEDNBwx71C9+8/h8Z3kekZ0URoLI/YVdVt/SNinM/VSVS4PrBGkKaqLycHiYDZjVefGAQLak0HzR2NGnOUI3EGPVcOC77MRStaQmRzgODSnGlQLU8UEb38aK6aoHNkTFWzMXz+HiAzSUNoBGCuGoNsbdbJHyjSzUs1dHi7DLypNnyBmhXpBa0otzb6N7LsDmNdBUdBqAgVjQjaAmwr/S4ChjzvX0hIACZFJgpTOy3LoOnowymYBZvI7hq8B3osm7tzAZU+GelKbFWEGazUMGNtkuCBW63J1il8FcxGFgAgoFxLJDWLBp5FhyilcUjGHYE17FJYw08YUSG3ScFBknSKKearhhK5zYQ8fXPAy75pUE2y3Il+5wnIx/WTR7eP5NqzVPBrExdal0IkDp/tnTPM+rNnUqbphIfbV/7Nh4GN8ji522sw987zc4zGiLvjzeLAczPEoFv7mEdqIo7jRgN626b1DvRu1Nt/RuRRR4Ms46uTqpmsjIY0FXaBXad20KYRmOl0hFf821hpvKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(52536014)(8936002)(41300700001)(2906002)(122000001)(38100700002)(76116006)(66946007)(4326008)(66476007)(316002)(7416002)(66446008)(5660300002)(64756008)(8676002)(110136005)(54906003)(66556008)(6506007)(9686003)(26005)(38070700005)(107886003)(83380400001)(55016003)(82960400001)(186003)(86362001)(33656002)(7696005)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b1bXOQuIHcpXWtZ3KPLI4Xk6+Xa7EkIgcYPb6plRmKlT0gd2LuH+f4BPPMGf?=
 =?us-ascii?Q?BBa1hyUw3lTWEEsqx5sIPLJmN/+iB2BMI1IXKnOgrsPNud9VPdSMwdld9lsw?=
 =?us-ascii?Q?oum88RU5vU/pZBJNeJ7PU9udP6pAiwjcKxOR55J1Bgke6IzLyTOxoLvBbhC7?=
 =?us-ascii?Q?ZkFqqVVak8A4tAFG27ghP5GT37W96aJgGVGj0eYGXxwdS+iQxjyEGsBKgcfe?=
 =?us-ascii?Q?85xZ0UDUXglusCgy/5OE//e/ySKkh+nrdNyRXOLVsJ12YpwtAV4NC5tIcEnb?=
 =?us-ascii?Q?JwZfPrXdIjPw8P52EcGuHdc973R22J6CABsjcObF4xPo17R1JsuMxVKpgg4U?=
 =?us-ascii?Q?il2iCZPR8PgPquLs9nFIubG+wAfnrWElE1vb3LtFloe0jqenRaY37Vjror4Q?=
 =?us-ascii?Q?g2P0zisNBoAslQYD5jGs4EwDac1tufEp5axTgLYgpszlAqsDpeRF8jFtRYXE?=
 =?us-ascii?Q?dKVvdRV4zuELtrk77O6wX5T2Th02bLKWoZSu9MViaJM8PpkCdj8QPRbvwN4O?=
 =?us-ascii?Q?9898BJO31p189CEANH25ZXekkxU8HwOpXtJChsGQjTNMHf50yocIDU9s6ZSP?=
 =?us-ascii?Q?vv6M2HSUWyeTi66HmmnjNozsNJlxilzPboJ6I0nOYgA6pjcTpwqDcTkuY7+/?=
 =?us-ascii?Q?8b3gQi8kfWT84Zy46UxMMcA1nVd3wQcGBV8OD/vC/u3e/qStL1Ew68O98CN6?=
 =?us-ascii?Q?8KxpyyrrpZenNpVVhgKVcool/BI010bAFd0sTtPzVXyzPnYP55ZCwSs7AXED?=
 =?us-ascii?Q?GTfZ8duHwVREOuQi2CUfk9gc0u/r6wR8DH3/xgvHO+WNp9Ye+m1/vFln4nRd?=
 =?us-ascii?Q?ah+Nrkz8j+KvelKwKBCBgF7oPm0TuwvoQUDlmGMQisWXHzPVq5qdmkI+K6jp?=
 =?us-ascii?Q?IgBZOcW40M5gqo7s3aCaPAcIIiLviI5Y2+0EgjHdWlYEzd4HZxvf35HBiSIw?=
 =?us-ascii?Q?IpfmLMWHdhkz5eryYDKjkCli0fp6TbAPEw+aTme6XWAnaWujRqL7EXTub9XF?=
 =?us-ascii?Q?AFLZB47PVOZA0v51GkGS+iZtRnABT/HWss8WFQCJGioV5xm+136LAAkMMHML?=
 =?us-ascii?Q?F5E96zZ/Njgj+WTxiwZk0MSJsX49d2py33pfw2WojyHqA12HWH/UdbQprvgM?=
 =?us-ascii?Q?ujZaWFYa75KwcYJIHWOBWnUUC7A+PKpvZrlqHBrFg/a4fbimJ+e1V+FfLr4W?=
 =?us-ascii?Q?J7QwrF7bMRcYeWY7yN77+j5f8CUAsdmhCBMgx2zDuYCPUpbzxCRqYj//hWUi?=
 =?us-ascii?Q?OGfgi49wknV6DeNOE90/RK5BAWiJ5ngpdfwae0R98IT0n5lmbvO0ElKCdI2O?=
 =?us-ascii?Q?LdtZjfCbo5/TdNu9goZhLn5NvsRii083T+I2W44tBxC34seV2NGhqJgD7qcz?=
 =?us-ascii?Q?rulIgz8Kghcg3iX9WWWoJa/g3b4syDMI6TN0QVdZ7CMoaU/cbcx3Th1aE90z?=
 =?us-ascii?Q?KvoRaCwMgzsJqjgTSL4/dbn+Gkxn3r64iH5Zrs9SI3j64R6oVGtLY252AChj?=
 =?us-ascii?Q?jRtL2lc1bvUruZMolIFwqb5QHFy98xrYIkfmKa4Xc5OI7nOh+rka3kJpq1ag?=
 =?us-ascii?Q?7a8eXDkOq9x1SVRor1S4yZjwmDvXge0vEGlT9u/cAcBa8TL779yjij02cPfK?=
 =?us-ascii?Q?Ew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780a9278-9e37-437a-6cf8-08db271874ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 18:50:19.5128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zSsLi3WpxWLQ8ztm2F9TBRnYxOVWrZv6JvwrDFNBPN7hoMNwBvigVhEURKF2m2w2PGG1tnk9mMH2geUlW6BPEbXy/3ZMRDZVDlTuwQE4Vgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6667
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, March 17, 2023 5:54 PM
>
>Sun, Mar 12, 2023 at 03:28:02AM CET, vadfed@meta.com wrote:
>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>
>[...]
>
>
>>+      name: device-get
>>+      doc: |
>>+        Get list of DPLL devices (dump) or attributes of a single dpll
>>device
>>+      attribute-set: dpll
>>+      flags: [ admin-perm ]
>>+
>
>[...]
>
>
>>+    -
>>+      name: pin-get
>>+      doc: |
>>+        Get list of pins and its attributes.
>>+        - dump request without any attributes given - list all the pins
>>in the system
>>+        - dump request with target dpll - list all the pins registered
>>with a given dpll device
>>+        - do request with target dpll and target pin - single pin
>>attributes
>>+      attribute-set: dpll
>>+      flags: [ admin-perm ]
>
>Any particular reason to have admin cap required for get operations?
>If not, please remove.

Yes, security reasons, we don't want regular users to spam-query the driver
ops. Also explained in docs:
All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
any spamming/D.o.S. from unauthorized userspace applications.

Thank you,
Arkadiusz
