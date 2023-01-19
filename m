Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5657A674AC3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjATEfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjATEfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:35:00 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772A4C131E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189198; x=1705725198;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SB2r3nmPc6cNoh2PGlhwPgnmUDuIavYbAxjIVESJzzg=;
  b=lwkZI1t/m1NXNBOzFD4FR3x6y+7mMB6ImYOJ+ISnxfBy/UpL4oEBzdrj
   VJQhErjql9T/Cq6Ac2d3Dm21fcVVMzaoqgvwKLmiu6nCkZ0vvZEL3En4q
   vMNJ+5TRKrYDEoIW4wQ8HdcgXBtcvsnMLSJzOU3fCK5Nicr7vjkNLWtUz
   ULaN7AhPCEthwgJeoDca0IxrU0rlygg3dNLroURV1jaI3Fvo64/ESwR4Y
   uubYtu58XM2QxcKlVRPsFf8f3xRBVTubOE3Ydbrfm3ZLmZ5VW0NgxQAbh
   bgf+DbpAgxqAy6eyxVgcCmra9s7KUOQGI+cYGWusg1bYznJZ1yVUAbaun
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411506196"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="411506196"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 04:11:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="690606693"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="690606693"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Jan 2023 04:11:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 04:10:57 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 04:10:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 04:10:57 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 04:10:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=db0pFSQPqemxunCvK0vCMHKaNYxuYIzOXxKRDB3WwXBU1t2iOBwtrkC16fUaFciQV6DcbD6LOHjMBX0vrvtuJwyErGf5Hhp1cX/pMBD28mIC8P0MQGieX6AjdBfq5bIKcE6HwagfU1L+VPLJXkJp2sWGZPvHqRMQZmZJwjL5frrBGQWIqVmXJAhT2YW/fQq4vPxZbz4J2+xYFtdma/JAxQa3CxYaif5NLaGmc6sCiw6GHCkDX2G/Hsmj/cA3lpd0LYdBWB+WlEVBS5N6Nw5KDdaeXH4eUYSuq+j6a53+dRDaFVKlcaDDllxma6UgezIeogkL0vBh4ajTupdGQOZmww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElzbQoa0OKgLoR6fkSkdeHBiOY/WS8+H0u8TWQBIXn8=;
 b=Ye1aeKSEozrfVXsfmfeDl81//I0Jl7CEjJwf6l0OLWDdbTwMw+bvqzF9UFnxYOLVdaFFqvNJSVuLMHMznl/+9COA6RYsFIOetO1MQAnwc2c+A4381mbQKssbTGQHTNmRE6zmJsLuS0x/Pgy5BS741JEKUETQDd8DzuXiLyAsdsa6Pxo8SMbBd/PzvwuChTLEpwe2oWFAhzQJS0byQvHLLtFXwcCQjlKNaPHmQmm6847nqoyUhSvkDoir+h/j/L5KRw2bvROi3WU5qJtFYnpEOHBHsrhSFgtvqR/5+EvEHoGYEcvS7bodgAS199bSgeDTVYUKajz8E6dGhQViOlYYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32)
 by SA0PR11MB4671.namprd11.prod.outlook.com (2603:10b6:806:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 12:10:49 +0000
Received: from BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::6665:be07:921b:30eb]) by BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::6665:be07:921b:30eb%3]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 12:10:49 +0000
From:   "Romanowski, Rafal" <rafal.romanowski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net 1/2] iavf: fix temporary deadlock
 and failure to set MAC address
Thread-Topic: [Intel-wired-lan] [PATCH net 1/2] iavf: fix temporary deadlock
 and failure to set MAC address
Thread-Index: AQHZENfeu36AULThxUS6a+j+Y7XGs66l0N9A
Date:   Thu, 19 Jan 2023 12:10:49 +0000
Message-ID: <BL0PR11MB3521150D2DB45BBD32A453CD8FC49@BL0PR11MB3521.namprd11.prod.outlook.com>
References: <20221215225049.508812-1-mschmidt@redhat.com>
 <20221215225049.508812-2-mschmidt@redhat.com>
In-Reply-To: <20221215225049.508812-2-mschmidt@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3521:EE_|SA0PR11MB4671:EE_
x-ms-office365-filtering-correlation-id: 393f51f3-2e29-43f1-3d66-08dafa1633e9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lMWxIAhYInbmSY9kkvJjE/7jqBfZfQF487t7X+yGKAyhjtapsX5OMGCA6YMpbJeCoRXbZouLbYNG2Lrm12AjDYPn56QmGqF4/5JIqk573P9x+ypeNU0A59Cu+hO/fwgOGCjw4NoP90LCbP/ym54DPUqC5hjMBnKFL2NwwJQMaWvpVqdZZAo/lWHENl5mn5wsGZYKkLu/AEJWTS8H9gcpgbsPkdk+L+EQDYY8i1QRRdv5sf/xogzknPFAfEclJZohz1aVFxFk0Vh+pU7gnubk86Eq6vw/hFiA5Rhaz5nybUkBd2/Lj7APzUXg9wme4QVG32BKSHmyYPHRtAnQ2yvZGZQUfrPlT6bbP7pGuOR7+SD3KYqt2ycYdfnSddMsOBMnfU6+Xf+BK8Xu+5qxU6zpkn3W8wTcded/+Wbd/f0u1xEal51gCmd+e/5tpXpbP3QI0N2ItVXvnpgLEOFxtodiTFN5q6aisg9B3Id+q8aQrDMPqRkoIqwqMWNiplhyWKInDtN2aPmLXkHqH+37Dnc7w4Snh6XEyQzuyeTlXnf+310FUykpkxz91wqiRVLY0ys9tcb/SiXH5Yz/TZPZRp7pKfcjIR3p63MgdlbYqQCEg3UMb6+OXD2I+35nDnEL1rZNCG0CT+eMIM2u6aP3zG0k4O4cjCuvNXKcGlHxlXjozLZITJrdj3TpDS5JxA2qRbAOqCDy+45MOx7hopm1Iby2Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(9686003)(186003)(66556008)(33656002)(26005)(53546011)(66476007)(86362001)(76116006)(4326008)(64756008)(66946007)(41300700001)(8676002)(66446008)(6506007)(55016003)(107886003)(71200400001)(316002)(110136005)(54906003)(7696005)(2906002)(478600001)(38070700005)(122000001)(82960400001)(52536014)(83380400001)(5660300002)(38100700002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H/qPoB9BjzfUZBqL2r8ggPtwzvFQraqYiTuknL8y75XMZ4cUVcF1EX86ySLV?=
 =?us-ascii?Q?Z4aH8QNulcFPox4FD3jceQ6Z6+Tc7CuF6WF3Etv3yF+x9QQqRC1gk9t7rHoC?=
 =?us-ascii?Q?coKRdggBWSHWbRU0N5dY0RbKHWw8KSYG0gJp9u3monSa0KIln/IQy/TFbCLP?=
 =?us-ascii?Q?kgxEwZzBbgNGMjP77O2Op2zawYM7H+SaF83aUYf17D4VWIYl6aALyy/3b+ZO?=
 =?us-ascii?Q?BcMQq0RTabTDW+3pfjl2ZYDBaeQmB7Q/xSnsqZxIkPtnVEomtXbAb62DUxYx?=
 =?us-ascii?Q?8wpG9Z/HCxQMxILypggglgnarBTSBpO7UaYMz+DWvkJ5wyfiLlt9ye97dLAp?=
 =?us-ascii?Q?zSiVjdUi14oLeTHW/7A7bnxQbO1kBmYsDF4hrAVducjxvuav631ivX6qRlPO?=
 =?us-ascii?Q?dTi5KEV87MHUf1s1LzQJnS8i1kn8oRiHAo1DWivIfF23+RScghiVEV/0Ytz1?=
 =?us-ascii?Q?wVfuqWYg0ApEVFffeAmPkOGr8rSgfBtNWyteOwbl6yOnl5iRKhFGOw3jbxeZ?=
 =?us-ascii?Q?eRwtFpmk/kumXM6PRhWIvUf+qlkEOXWT++t9DdDjYzvyMDFVoPYGtMuCzQR6?=
 =?us-ascii?Q?5VDyLPxtHIUmjx8XBazcQEDgOX4O/59MonPvs5guqNXYvCaGBXBwtQaEwkET?=
 =?us-ascii?Q?HQQxWQOXcpdkTsF2PJOzHKDnQcySsmk/Q7myhk3ldQZByRW5+X7FpsDobVzN?=
 =?us-ascii?Q?zNpP3VIoEiE+MsTvqGLAZUQbOC15NdBpYm/0V6TDBXCyWrKN0o3MSVHhDfM9?=
 =?us-ascii?Q?lKj6sXMUfzoK4aYJxd+5tpmG2u1LT5RnyKVx0lVkd62QYqPm0pqPsO5vS7P7?=
 =?us-ascii?Q?X7qrsdZ4g/YjnnOA2AZ94oD5JbRAbFKd6KHMxEWoaa/lv/id3Uai31wfe0J9?=
 =?us-ascii?Q?dJrsItcLgk0i0gj5fRn3WhM7bG1b3Ux6t3wXqOXosuJoQmPIeOdKSqoJCqIn?=
 =?us-ascii?Q?3OGN/kx8afYPwbYhMv1Brf6yOHlHl16f8Y2NB6A6MtPFR+/PSZ4IJdyNTBeM?=
 =?us-ascii?Q?QQlVKpLMYNfDhyW2GuthcGTAHr08MsfO/+SbNQemzdrhj4k8C4uQiOyDv0BK?=
 =?us-ascii?Q?EyCtcARTGlXPfOXu9kTN/5KhA5EVhre4fqPwO0Fm8A7bzGd2ZXZ2hscItGaq?=
 =?us-ascii?Q?7i+WwpNH01H8yqxvAXoCGdp+73uM4fuCSRemroaMd/NiVCCywq5SrQZk5qZh?=
 =?us-ascii?Q?PYszqV2lRGyQ9YOtPvCXDbqNJpXUl0J1rWtMiqrCtJlvFX3AFuBZlhHdhjLm?=
 =?us-ascii?Q?1iFal4bbDdwPIQN6JS/Iqh8am8wPvTEmQpLMpfa0yeylEfSuwVXGh0XsZfRf?=
 =?us-ascii?Q?UqTnBcpPpBQF0C74d1aSnW55oogfDuTLyeHvkn0Kxrjjn8Y8FDJXW3GpX4CR?=
 =?us-ascii?Q?l4OHNhPjcxvwOxXuFluwzIuybktJKL15farY6hPhrY5YFnxUAJ47/ID7ziUV?=
 =?us-ascii?Q?42avkjaouknynHq7Pte1mk9+ErWmoxslpIx/M+9ig5PrAIleXSPSbqKFRjSZ?=
 =?us-ascii?Q?dlBsfoqafi6bwCJ3FoF3QYAmStgHRz8oLrTNivnj084VJxpO0dP4Nh3vYd5h?=
 =?us-ascii?Q?+Ts9o/bwuEsbnoYCxySFR7/Yzi2p7zuBixM/UYlGAb7SVaGL5PDqCXhyIVDv?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393f51f3-2e29-43f1-3d66-08dafa1633e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 12:10:49.3025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZBGl7+bFOcr3A3lWAoHtGI/sf5Na6n7YtD0MBPh5q8Q09wnWI8rH+VKmvbCuQkOgrqydjKEG82Lk0X7OXX0LEJ3Cgk0WKE2p//V0pkhais8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4671
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Michal Schmidt
> Sent: czwartek, 15 grudnia 2022 23:51
> To: intel-wired-lan@lists.osuosl.org
> Cc: ivecera <ivecera@redhat.com>; netdev@vger.kernel.org; Piotrowski,
> Patryk <patryk.piotrowski@intel.com>
> Subject: [Intel-wired-lan] [PATCH net 1/2] iavf: fix temporary deadlock a=
nd
> failure to set MAC address
>=20
> We are seeing an issue where setting the MAC address on iavf fails with
> EAGAIN after the 2.5s timeout expires in iavf_set_mac().
>=20
> There is the following deadlock scenario:
>=20
> iavf_set_mac(), holding rtnl_lock, waits on:
>   iavf_watchdog_task (within iavf_wq) to send a message to the PF,  and
>   iavf_adminq_task (within iavf_wq) to receive a response from the PF.
> In this adapter state (>=3D__IAVF_DOWN), these tasks do not need to take
> rtnl_lock, but iavf_wq is a global single-threaded workqueue, so they may
> get stuck waiting for another adapter's iavf_watchdog_task to run
> iavf_init_config_adapter(), which does take rtnl_lock.
>=20
> The deadlock resolves itself by the timeout in iavf_set_mac(), which resu=
lts
> in EAGAIN returned to userspace.
>=20
> Let's break the deadlock loop by changing iavf_wq into a per-adapter
> workqueue, so that one adapter's tasks are not blocked by another's.
>=20
> Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
> Co-developed-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
>  .../net/ethernet/intel/iavf/iavf_ethtool.c    | 10 +--
>  drivers/net/ethernet/intel/iavf/iavf_main.c   | 86 +++++++++----------
>  .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 +-
>  4 files changed, 49 insertions(+), 51 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h
> b/drivers/net/ethernet/intel/iavf/iavf.h
> index 0d1bab4ac1b0..2a9f1eeeb701 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h

Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
