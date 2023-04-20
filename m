Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CBD6E9D8B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjDTU7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjDTU72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:59:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5246AF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682024367; x=1713560367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+QP/S8wkP9WiIdY+h2aQVqpkChBYWdxBmYY3ck0Ol5o=;
  b=ZT18YEO1VbA+YwyVzryz0UPNULsdlQ1a6XxudupxKysOpgCE1chFa4oq
   BkuUm7TYs+0sYaqn54OXo2N2DX8uyB3MhpeJ2USlVSgclaciT90ydcfB4
   E/mKdp3ES5O9RSjsMTPMbZIzGuGop33U2nRAb/JzJCFYUd7idzRGQhRNn
   vOHdf3FSYw7XjQA/r9UGli2OeWf+gESlc0Oq7XaWHr4FJyNAHpT6JaFxo
   qlhpEQu3Zho4vPpPXdZvxuaDfaz4zNQw+LMbUwV24+G3M3HM2XkxIKb3o
   aSLV0xWyIuE75uw3q9XdRNQy94Y/UWuuGKg3NZ3gFJzQTmAYC5bYWWhCF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="334718974"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="334718974"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:59:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="724563776"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="724563776"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 20 Apr 2023 13:59:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:26 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:59:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC9w93Mnf/Nh+W+9tRbmCNzRKlJWePFLHL9ORkEXaCgZ8CALpHJvQsKRBSlhP69PxmqmtOMqNZLmFTgnNRhAd+sW4634ESin8+AKlT3HNj9ddz7nDaut0w0/NMuvk6qNzhtEtfGNPExtMO8ffaT45YuzoI9Oiz6JD+d5lQYA5WKLknZeIUMF8sqA/lqxB3BnX5fa14k5k7CnIAoLAG7iL6WvrEA4sV4+Ma142hYqUw5eqk4j+nBSyY1PvP7YInCatdj3ALN+CrrLhDU3jx+ByFqys3D1BvSQKkInXl1Ck+HhJS4sOKnwxkA9yvysvSRqw9Wyyqxg+vGEh+259IKLzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avaZOfM5+iyYpUlDTX3Gr0BTH37lL5wXRg3X5Mjp7MM=;
 b=ULmSNIx+LW1pX7uUgFMQCiDBXIYIjX9KX92ZVGZCiXufmY4bWDkpsefKO/v/wl3tdboQPL8YVkEwlJpfmatay6dvn1LjBOMyj5z6/NlNZ0oCiCPhGHxSrCVDOleo8Ff/JCGYQTFDbB895Pj0r4GaTmZ7PnNAdwBCVowm4bMJIAOBQ4w7TVWddsgJ7U4xOY74OWJQ9YRFuYDmoR/KgDPjM11I9+fdTAlc0/QjpoyjpeEOf706w1Q8QY8D8gYuDZoYopVEv6oDfX8nzEVnekqJ02yFC4rdLHgOwLQJpwTgWFVpDG6OIzpeSYYmYOCE0soK/i183bR2Vzv5khWwjnzQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12)
 by DM4PR11MB5472.namprd11.prod.outlook.com (2603:10b6:5:39e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 20:59:24 +0000
Received: from CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7]) by CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::bf74:c4e3:c731:b8c7%6]) with mapi id 15.20.6319.020; Thu, 20 Apr 2023
 20:59:24 +0000
From:   "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 0/6] ice: lower CPU usage
 with GNSS
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 0/6] ice: lower CPU usage
 with GNSS
Thread-Index: AQHZbRelXwSRe8ufUkCZBiYY1g7/m680uijQ
Date:   Thu, 20 Apr 2023 20:59:24 +0000
Message-ID: <CO1PR11MB5028938B5F57E9AEE0ED1578A0639@CO1PR11MB5028.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-1-mschmidt@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5028:EE_|DM4PR11MB5472:EE_
x-ms-office365-filtering-correlation-id: 1c9309f7-a753-407e-fc7b-08db41e21f0a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWaK81GNhHM5+WFeKwldwO2o26A6XGGviiOUAfuHkUZJg0XjdE3w35zsjdVf8p3SDnjvwQwMILxD68M9eMgCp7JZObes/UCIBcQ70+uBHMeazjgjKgjDjdrxomFbw3/Lx57OumL4piZ5CWRpnBGAhJQ8m1LwN54S2moE1dCHyl4JJQiju2mxdxAifTPkFGxRY1DPnBLo0ZoYZFjHtRNOtwLWOrltoznPrnRJA/aEfFDmXCRDY5Guf3mfr8uHxGew4STSzj32PZClpVVBRwXCw0G4FllMFC7j+30ZUfdpUj5JwaRl+CJUetIwsMsSAjM6Q7oKs3vCqrbsI/fFgYQ0BaItTHd3p8gvbG5Z94faEgZ6gmjBaJA3d8peEnESieIEt8EwQWdNF5Q6MYSAdOFNKMjj8AcOYcEC6LXPWDhpp85T+FuDlLQD40mkg9C+wxO7MBOw9jht2L5WIdgkY9hzR8JGmtzP/8Qkq+G+tsw4Y4PIihqXWIFNwXbu126HyYRuxbcxijpwwflu1jfbkNLoQzAbEnXXGmcaL2jWGeiitVno/tYTtst1DZIBb5GcDbuhDVzC+Mxap/vBo58fUaiwHlDwSoHQ2pt7uXuNhgFv92n4tQOurFKdO5sM28pwoMWL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5028.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199021)(41300700001)(76116006)(66476007)(64756008)(66946007)(66556008)(66446008)(110136005)(54906003)(316002)(26005)(4326008)(478600001)(8936002)(8676002)(83380400001)(5660300002)(33656002)(9686003)(6506007)(53546011)(52536014)(71200400001)(186003)(7696005)(38070700005)(2906002)(122000001)(38100700002)(82960400001)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SU5/Pg77nqG/hOS7h2iK6S/yz4fr1YSoxg9OjH+0DgDSXENGIjfocpPJ8rxj?=
 =?us-ascii?Q?apLxzH+rXahNyhcH94MpJJ5FU7022SL5cjHhxTgdavrj7eMeFzKUeHg4mfjG?=
 =?us-ascii?Q?wziXtFS9ZQ9bdadsWUcLhPR6Yfe9zDH5C7TUbi8OKGQjTfR44B7snAju0bsO?=
 =?us-ascii?Q?RTKBCK/2Fie1/UM4wbUuRBxGdzZu883/rsasxOrHAlEJiaXHxKn2ewZjngLu?=
 =?us-ascii?Q?TlGuLANAJ6ACyJ8kB7bf4Qslv0D0lmSxIeqo5lc7HqbDEf0kF7SIEJXhNbYz?=
 =?us-ascii?Q?/AY3MbTMekEzs4P6qiYx1/onjMYdpmn3sRFxyqCXDByHrFJX8cL+4hf9ENs3?=
 =?us-ascii?Q?o5FI+OBgGD7x6z5c3P3zHvLu8U5BNDazdRJBLc9cOD844IaRrukmt0xjzlRP?=
 =?us-ascii?Q?cQ/TvGxlqtdNGroJlnudX5fxs4uXOxezuDe2uKe0pXNHhOyCyvWsMmmi33DW?=
 =?us-ascii?Q?0a2LDIoxwAfwjZ3Afd6hALC/6gfe5L1VgEUPMJF9vFThqAMOApgpDGSppEFH?=
 =?us-ascii?Q?ZhKwYunTX9aUPtGaYBYWSyEmzYqm/WdUX/BrbLlchZDzey1rvW2WNeEioFd0?=
 =?us-ascii?Q?QD+isXeSPPEn4yNaH4PmNCl3cQkYztfuY+jSH73nnFH1thmhuE9fXjLS86Td?=
 =?us-ascii?Q?ip8NtHbPtGike5g49cnuZHIQQCTT+jaAoW5f2RAPkN9qxdP2lTSmUB6jiy7s?=
 =?us-ascii?Q?Bphb/4L2MTQHHmtF2VXwRypzPtyYBDis4J0GnJ4Di0utf4WqCn6jKBq7r1Q+?=
 =?us-ascii?Q?Mmhho3mPQ08qGw+iB2cmmm7fE+kZ7SnI8g++6byAcaY+eLVORovOtLFUc/Wf?=
 =?us-ascii?Q?44azdcGg6BOT9giLvw1an5mike3KrVRidPnyfGPNDU55Zeaf2Rw8o56tE/Zf?=
 =?us-ascii?Q?X9IbkjohjcG/xnuRBdwmZdIOQF/W6aMK1i37ySZIA0F2uH6eYr8A9xyFqx47?=
 =?us-ascii?Q?dXovhdygtG1ZoIQJcK1X+6ryQb7Ix8qpS+Fifo70uq1D+g3zO00e11tZi1lW?=
 =?us-ascii?Q?djW9tOPiLT1oeSsiAM/s0yOnjp2MwEzYuUZSAW9izPJaNARR3rItIobDUh9r?=
 =?us-ascii?Q?1nYk3kEo+EA50lVXy74AYqx9J7V6m2kTcnPWYGCET687g8/rFu61nK2lsYNF?=
 =?us-ascii?Q?n52e2oH7h3CFVItBXpJNTM4oWQSuVcq3nDaxPrLevO4Hv+XNP7bxWdophNfd?=
 =?us-ascii?Q?WrzM23vicx+g34STU2QGIgGOtPeH4FjOuAe3ewKXfblZ+g4cQJzXqWTZsZHu?=
 =?us-ascii?Q?joYUXYqIZ6jnPogdFgex0MWY4vTk0VysNLHDQt87aKZW11LyjuJbi6dwwUsf?=
 =?us-ascii?Q?4p6QU1BIfR2up5rKra/Ohf508nkrXOd/NhYg4cWC4beG2ot4hxV0dQycA4L6?=
 =?us-ascii?Q?YhtR+P7q0giqiLRd6luBx0ND+M6AUVnakow4Q3tzZxBMw3unfx66aJvq8/eO?=
 =?us-ascii?Q?auFXuVGIHuy+/p6kyWnNDokylUpdANAZsR2djleAz9tudQx8Qmg3SOITMmAH?=
 =?us-ascii?Q?YXrgn3eiP+IFDGrIG7MAyN6p7JrX+mB2oBgtmPZ5utMeCPVqHw9/t/7TRI+z?=
 =?us-ascii?Q?QZBCQtnci1HbdNj9BYzq4oyXYlYVXpYX6LvED+uwvUf9FZyM+/8NeWrgbMem?=
 =?us-ascii?Q?kQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5028.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9309f7-a753-407e-fc7b-08db41e21f0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 20:59:24.2126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOybb3kE4tuABr/CG1sIjz3aTomVyqpLatTUS+xRjZsoMhty9ckYsMOcEdYicyvFBHb1mHqccyKs8vgICpdfMOWT357mH2vSkz8gJ1Phh7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5472
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
> Subject: [Intel-wired-lan] [PATCH net-next v2 0/6] ice: lower CPU usage w=
ith GNSS
>
> This series lowers the CPU usage of the ice driver when using its provide=
d /dev/gnss*.
>
> v2:
>  - Changed subject of patch 1. Requested by Andrew Lunn.
>  - Added patch 2 to change the polling interval as recommended by Intel.
>  - Added patch 3 to remove sq_cmd_timeout as suggested by Simon Horman.
>
> Michal Schmidt (6):
>  ice: do not busy-wait to read GNSS data
>   ice: increase the GNSS data polling interval to 20 ms
>   ice: remove ice_ctl_q_info::sq_cmd_timeout
>   ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
>   ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
>   ice: sleep, don't busy-wait, in the SQ send retry loop
>
>  drivers/net/ethernet/intel/ice/ice_common.c   | 29 +++++--------
>  drivers/net/ethernet/intel/ice/ice_controlq.c | 12 +++---  drivers/net/e=
thernet/intel/ice/ice_controlq.h |  3 +-
>  drivers/net/ethernet/intel/ice/ice_gnss.c     | 42 +++++++++----------
>  drivers/net/ethernet/intel/ice/ice_gnss.h     |  3 +-
>  5 files changed, 36 insertions(+), 53 deletions(-)
>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worke=
r at Intel)=20

