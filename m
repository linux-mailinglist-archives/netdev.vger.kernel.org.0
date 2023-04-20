Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD046E99AF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjDTQkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbjDTQkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:40:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4130106
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682008798; x=1713544798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tq8Qb/uERZr8MtEaaty7AOODwhXQtObJOZ0n7IuEdbo=;
  b=mpIH3I72Glcp5VJScsCK3utdZ0G/b/aZ/ac56Gw3CJssb/m7J+PIONnC
   wkrPVH6KBkdbu/qDOJyL5nt1jwOij3lh2EbvIRt5MQbOXBLmZzHLmb3rH
   W8gFejgd1LUadZbxEyKClB+z+2nKKE63mFfFwil01Hn8yjNGaEkz21yvr
   HMQpK9FPrtRCmkDA5c7wJlH8vQ5cdEeTkJZ1VE5JFWw8MmtAI01ABQ3NQ
   rHZZCUD+b+6wq1bmHigx3cmUstZDVcf3UIKbY6j/NKVmnOH6prICBzNCA
   m9Ho/sp5USUz8hUs8Cs6Dhy8lHcx6D3l6x3Ip2DfBt7cSVn5JkfJ4i/pQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432067907"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="432067907"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 09:39:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="866355213"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="866355213"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2023 09:39:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 09:39:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 09:39:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 09:39:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwmoWF1LuPTfjEL0lp50isAj5TcTIBvZZNwl5RZGTqLInFNHV2ZZjkDeWqwj4yN3QqFGZkdXzTr7YYHHc2/x3GQoj5oinEhtKmI/mC191qn7ZCM0AQ9huNfpwsTulszUCyHw9RqKvvxXQpRBddwLZYy9fynRc2T2rgEoEBPwcRwdf7ZV4+nA9swGNReT9m3PAzYMqXnVMwz1Tc5IekGDO9l5yx9cf1Dv6lJAa+Soqzc5wQhYMSLC0tseKH+bK3ZPD2LnS4dNodU1m5rMfGB1SCoOF3DY+9kHQOFB8Ci+v4Pb4iLvIqvYRuRmsbrOqw7IMKU68nAVbjK7U5mpLUPpbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmdcKew9ePJizQu4GUCIy94mEe48pTHWIAw8rCwMhVU=;
 b=ZvYMHLtl1nLiXv+1oHys3m+AE+cF2huDewpCsbeuA6JSHRoaOtnTmrd10TMvW5A8bqEK0Y1sUh585yzUTbqCEVj9gD3J+ljnR1cQhTbvPVsRBMrOA6IYWfz05yA4rpNG+3LngG/BjETpGpo27HCZtkVklcqZxp0/PjPIeBs2GkRHUO0nJZZS9tOL8MzzzFOTmPWE75OSxrczVOLO7gT8QR16TgPeqAWXd+Ou1YqLVJg4NAeh6LoRvz1W3MBWjdHNt5jg2jVV4/2N82NjNrvgFEU92157nGlOML52ktRQL4XTT7gdWv2Mh67FMye227OpY0gJM+guOoMDJi7cTTO9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by SA3PR11MB7583.namprd11.prod.outlook.com (2603:10b6:806:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 16:39:53 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41%6]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 16:39:53 +0000
From:   "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To:     Joe Damato <jdamato@fastly.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net v2 2/2] ixgbe: Enable setting RSS
 table to default values
Thread-Topic: [Intel-wired-lan] [PATCH net v2 2/2] ixgbe: Enable setting RSS
 table to default values
Thread-Index: AQHZcJeH4zKPVBuoUEqaMOci4k21+K8u8WcAgAV5lXA=
Date:   Thu, 20 Apr 2023 16:39:52 +0000
Message-ID: <BL0PR11MB31228261472A683DF589C61EBD639@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230416191223.394805-1-jdamato@fastly.com>
 <20230416191223.394805-3-jdamato@fastly.com>
 <20230417045847.GB43796@fastly.com>
In-Reply-To: <20230417045847.GB43796@fastly.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|SA3PR11MB7583:EE_
x-ms-office365-filtering-correlation-id: e3ddfce1-e270-450d-5521-08db41bdddd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jP5HgqGJkuWtTz8a75v9t1yAyakDx5UHCDrridBMJFyKL0xw2WKQ3FRRrEZTwmODog6WkfV+PL2arsh6JAtD8sFhbsmDPyhvPzeQKpSkuinc6DvjA2sSfBour0MaFgsKhi1g58Bl6hMv9NPP+RrQgWoFUL8jdNi4ExjDyOzD3n/NVtaKgq9lPBhkRPeRpjkyBfyIfqjHNCgcTlgfXhwj0VP4uFj32lciNiWwX+UaDOEsd5x/gIitjgq8ueFDA6DYE6GouUd8+rZMeVJG/P3Mci69k8YPY0ZKx/m1M8NRBHb55xSJNBPo7ag+mzJLtV9iYWDW97lt3HHVHJLzDCkmpE/Thr4D0Ier+ZuqVoVqni8DnWT6Fjo0c4wRi/EfH6tqzoukfIkEZ6MalDeZssROBLgSnO9CSO4qrpRy0TnuZvHTNyxf+n29tjqjw0JCyJdCV0Ag/nNxzbwxj7WHkpRcoY0ludLWMXd4iwVgtKVVjPwvk1eRInxRV3NGEiaw7k3xJYa6VKd/uNpVOWf5HLkz5p2qpHmRq+GwyRZp9/RJjFYYDlc4anZiQNdbuwTWBdZCi4gLJt0WkfpTiGkXcD8+BrSKBuIuflX6GG+rAKv27oqE37WDDrXbGpdxbNbXyIQx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(186003)(6506007)(71200400001)(9686003)(53546011)(26005)(7696005)(52536014)(5660300002)(316002)(4326008)(41300700001)(66556008)(66476007)(76116006)(66446008)(66946007)(8936002)(8676002)(110136005)(54906003)(478600001)(82960400001)(38070700005)(38100700002)(2906002)(64756008)(86362001)(33656002)(83380400001)(122000001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r1pif3rkeRkidRlJF//n1tkHN5oShRWmUEj7Q3No8TbDSjwZ3HfMe718x+bJ?=
 =?us-ascii?Q?jy9f/15iJsuVZkoyzOP+QrbGb/Tuk1V1HJe+f+DRwaAzuMcfWdbS41+ufcoU?=
 =?us-ascii?Q?Ooi2AQqmlmp8hbVyifTvBcaJyLZlVvNEE12X4IyZ8AKFIo3IGiqD+HtJcaI8?=
 =?us-ascii?Q?PMEXhoZcm8g0jasVpGYOQImjVXG/J00xgZLcOMGC4hTU0NgMHnlTlBB3LdV/?=
 =?us-ascii?Q?HFIRtYNGBWb0iRaoeNJeVOCOHIGUu2HnEoKUu71jWA5gcBMLSqpeOdXqTPmi?=
 =?us-ascii?Q?k8kQW9MTQfXuSLS/aqrtMwtoLxuxfR15lKNJ9vkQb8iauPWVAEscxUPnY0rg?=
 =?us-ascii?Q?0+lvMJ18ehl9wZ6XgVRRpL0fc24ADpQmqpQ8hLF0csiDENfAtGCZFn+m15a5?=
 =?us-ascii?Q?oXB4CWKDb0osmMWrZLLjq5eexbcfgt45frWzfn/ghhwMH39A/CIt+j8BlI1v?=
 =?us-ascii?Q?pUfoRZqi4NpPUgeh3rOJkJT38SxIMKQRSLeQudvujJsl8vTjA786f+j+Sj1I?=
 =?us-ascii?Q?cPoOjWlSK7j2ycgI/OtChjXujj862KWXUOsG30P5B84HZNwCdd8p+V/J2XPt?=
 =?us-ascii?Q?TG6nkA3WfLfDdqb93E87xseactqb6mOs2kpLhZ5ra+3goBFOPyhUQNdNSlK7?=
 =?us-ascii?Q?mqIgJvzSJUF92eG8jiCUdwkWgnewE1rffFHl41BKyeuYjD2KBsvHEuMVjrEm?=
 =?us-ascii?Q?YAiUM3yCpcrW7nKeRTADGZYDVcOFLv1vKL3Dnk6m8xiIH3nEsT9uIq9xPHZ1?=
 =?us-ascii?Q?l49orfKmjbXmOrPORNZdqSMLazynul5FMBeYR78wPWDiNaT9MgNfaTr6gq5w?=
 =?us-ascii?Q?a40UdFVdcgTxpx04yPQbQ6gOUeM2iZooMIsGeJEa7c16H/HoKpJs9OGlHucu?=
 =?us-ascii?Q?HrW1Ua2ijOQ+jmoIbjCCGUun07DQJE1GMfEJI/Qmr5PKeZ+ryAS0kzyT+QvE?=
 =?us-ascii?Q?FX7Aabnc6gVCYuXmTU6y4jLvxAFWTaNyGVFznn4Aedqc0RaHtNcaXpw8oESF?=
 =?us-ascii?Q?VszRc1+Gk132qGcKFwHtSwHBdFD1+y1ml/xCXeAuOa6tYEVYYry2TqoWHvts?=
 =?us-ascii?Q?lrMQelmAfrPwQq6io3nJCOKQNdV/yQNQS4IQHjOfmtnzxjrlYx0dfBfs9YH1?=
 =?us-ascii?Q?W7Q+5fUO/NIVwyEy0tQVdQmhjJYLx8ewLL6Dh2V07js69kYFcpD7TECMugWy?=
 =?us-ascii?Q?faqVWssxLuIoorhN26rGJL+SQs5CUplrkYHzmzm84eljRy4jUHV2uStD1Nkb?=
 =?us-ascii?Q?70HWzM2YPxHmpE+MHPwYJtzSPQdqS6rEepUcP7v9sOaAc1vMwFfraALXq6/Y?=
 =?us-ascii?Q?OWItm9NJdoub9lPyHWtIJw8NdRFWaEySJbP862KYtE8luRGb2lqUvyRFKNmg?=
 =?us-ascii?Q?zY1AYFT1g2d+k3HvlNRTr/Q95gXu6SLm6Jy1GWUzm93PvtFGBt6NGocOulwb?=
 =?us-ascii?Q?qWhXFEEMrI8xuS33YHy6k8AvJ9JQxzUKZ+WKjqWiaWWh9NYQLAxS3t0Fz/+p?=
 =?us-ascii?Q?yI+b+rJmz9pdFR8sZ4+f4/zopkk1/8hZeSlDheFw8aB4dfB28V3WpbGCDJ8P?=
 =?us-ascii?Q?URz/0yWe/Z+O6icTkGYStEVAnVtchaePOxVYKcAeYCifMrgVnFBOfvZcGa2Y?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ddfce1-e270-450d-5521-08db41bdddd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 16:39:52.9080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bLE9DcO6ckBc0LJAwB1KuvADDIoC0E7yuj2eQl9TqG3cyMw9ZK39W1gobTuB3M1AVCgY+VOSnsKEmfMfqv0Cq38Q/Z/x9H7Q1gsZdyUWdNRNHxz9cNu6CczLuTGuF4A+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7583
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
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of J=
oe Damato
> Sent: Monday, April 17, 2023 10:29 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com=
>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; kuba@kernel.org
> Subject: Re: [Intel-wired-lan] [PATCH net v2 2/2] ixgbe: Enable setting R=
SS table to default values
>=20
> On Sun, Apr 16, 2023 at 07:12:23PM +0000, Joe Damato wrote:
> ethtool uses `ETHTOOL_GRXRINGS` to compute how many queues are=20
> supported by RSS. The driver should return the smaller of either:
>   - The maximum number of RSS queues the device supports, OR
>   - The number of RX queues configured
>=20
> Prior to this change, running `ethtool -X $iface default` fails if the=20
> number of queues configured is larger than the number supported by=20
> RSS, even though changing the queue count correctly resets the=20
> flowhash to use all supported queues.
>=20
> Other drivers (for example, i40e) will succeed but the flow hash will=20
> reset to support the maximum number of queues supported by RSS, even=20
> if that amount is smaller than the configured amount.
>=20
> Prior to this change:
>=20
> $ sudo ethtool -L eth1 combined 20
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 20 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:      0     1     2     3     4     5     6     7
>    24:      8     9    10    11    12    13    14    15
>    32:      0     1     2     3     4     5     6     7
> ...
>=20
> You can see that the flowhash was correctly set to use the maximum=20
> number of queues supported by the driver (16).
>=20
> However, asking the NIC to reset to "default" fails:
>=20
> $ sudo ethtool -X eth1 default
> Cannot set RX flow hash configuration: Invalid argument
>=20
> After this change, the flowhash can be reset to default which will use=20
> all of the available RSS queues (16) or the configured queue count,=20
> whichever is smaller.
>=20
> Starting with eth1 which has 10 queues and a flowhash distributing to=20
> all 10 queues:
>=20
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 10 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9     0     1     2     3     4     5
>    16:      6     7     8     9     0     1     2     3
> ...
>=20
> Increasing the queue count to 48 resets the flowhash to distribute to=20
> 16 queues, as it did before this patch:
>=20
> $ sudo ethtool -L eth1 combined 48
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 16 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:      0     1     2     3     4     5     6     7
> ...
>=20
> Due to the other bugfix in this series, the flowhash can be set to use=20
> queues 0-5:
>=20
> $ sudo ethtool -X eth1 equal 5
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 16 RX ring(s):
>     0:      0     1     2     3     4     0     1     2
>     8:      3     4     0     1     2     3     4     0
>    16:      1     2     3     4     0     1     2     3
> ...
>=20
> Due to this bugfix, the flowhash can be reset to default and use 16
> queues:
>=20
> $ sudo ethtool -X eth1 default
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 16 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:      0     1     2     3     4     5     6     7
> ...
>
> Fixes: 91cd94bfe4f0 ("ixgbe: add basic support for setting and getting nf=
c
controls")
>
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 19=20
> ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>=20

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)
