Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01D964757B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLHSXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiLHSXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:23:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC71654C7;
        Thu,  8 Dec 2022 10:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670523788; x=1702059788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hvA3zphQYm4+SEujXYh5wvyScG9bv+NKp/2KJvtrE9w=;
  b=BXIHATGamlP01UKcJ5jUxb8y1kQPTy3WYSxFCCKErmbq8zhGBxcZ8mjK
   FLPNOrEJplCWrnKOLBz0HRhHjcxWgMnyWWCehWQWwp8qZCcbwnQEiuXh2
   iC51XABwH8wn/FIL2zKz60PtXHxTOFBPEDOsWw1uDAfIFC5Ylxv4IBLXN
   QGlGJQ6GuM0GpySIMMT4sxwsW8FjwKmcAxKoDVFghINbOGDwkcf2IDkYc
   u9GdpC4j1mS0buxBN5iMMR+CTvFfimSu++CCJLegzLrEWinEUl9Cy0aM0
   Vce7ci6WVji04+XUCVl5Tr+ES+4iQsj2tUB5rDKfNVTjUHM4y6TePaWRJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="296939878"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="296939878"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 10:23:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="640728778"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="640728778"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 08 Dec 2022 10:23:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 10:23:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 10:23:07 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 10:23:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7KF1UXsSVKm9BX0jeMsgMJWTMR1RmX1FbtbziRurnnYIUv5XRpivMEyT3v12r7AVagvT5EipJDLNEMEcwadgpHH+7rfVQRDkrebEzDaUWtlWkPbud4vmKWf6xdxTMmJiPkJaQZc06oGyEg34VPJV8f6F3kIvkrRZ+R0LV8PjZRhMTFU6oZg/f4pdOAgtRP1zNyX1IE1mbynoanfhSasNWplqSovyKmhDBKfHJh+qS7WVdPrTLHG/C+LX0fNagnpf8ANWTTx16kXjT3fur/aRwSqxIO/cPOC3V7ZNV+3AjBlDX7ud9HSnuwRJ8PZPZWAWOXALWBHRSIqSs11xcoxPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dT/KmshpL3YHNBq+MmK4zD/F57M8Uc6mQQMu8rEFgQw=;
 b=YS7XZIV7uzm4jdRKJSkCJeP855nl+dW3xqdAospQFm5eWTK25hc6TqTp0GFmUbFoTpksifK5yRMa3DhdrxCW+77PLSPE8Z64M1fH0C6kisWsPvfFDfqClncmhiLLMMvI1m5OMkQDzIu3x8LCC9aVa24NWrghnDYAfQXkreNlxb6lP/eW7zpybMlQQ2YkuYJNK1twRbO5t/KYFkqSUDjE8MseijNXD6upjGGasuQyPuTcIDhBJSl5qi9OlBqWKGd2w2balQGYcA8yEB4lo80gJXXsEHugqF0sIbs/TRlCGWiD7amNZtxaaE29oHRSNuO5223CJ/L9q+Z3D/963NPvFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 IA0PR11MB7933.namprd11.prod.outlook.com (2603:10b6:208:407::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 18:23:05 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 18:23:04 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAG+ucAgADKSwCAACleAIABo2oQ
Date:   Thu, 8 Dec 2022 18:23:04 +0000
Message-ID: <DM6PR11MB4657874C5C1AAA5845C6B9DF9B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>   <20221206184740.28cb7627@kernel.org>
        <Y5CofhLCykjsFie6@nanopsycho> <20221207091946.3115742f@kernel.org>
In-Reply-To: <20221207091946.3115742f@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|IA0PR11MB7933:EE_
x-ms-office365-filtering-correlation-id: f1bd59fc-ac38-4194-4a75-08dad9493f91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qg2eEbdyGEy6HjymIto3QAhIE6JEXQ4JvE/Z9O3m36rNryzwsc7/JXQHYW7jPqIkbiR/VFyOBjSP38Ljs0yjlrPOU0wVhkpKEiy61l2Jew7SbX+rmce1sV+Np3E2XwTEtZAi2p5jbo7xYt2K43luBJF+sE2lh2Pyp1Nsuck0wY0Kw1uZxtsRlz2i8OZm/PMJct/6efPiZMT/s992gHMMjk4jkkoYhIYIWAwklMQ4AX5gBPPKJa6SjS30ySURMA2k5YXIZX9JKudUJVXNNGkh/u6GS03PPAMzUNTStLb7TCgqbVVIZblJETAbZNe8thYj7Z9l0Lczv476RPMd8QqAXr3GcvJNgymq5K4i/GzSYK+IS4oMWGru+kqkw/zBsyxd0Cv3+JNlamw2TPWx88Ve0/M/q4H/HAA2n7xLNgbgG+fI5IedUkhFDOkXf/QiTQmlTdW0GsWzZuCtTrlYInc44hYvUWDi16QATKfeSGiXpcvtvUVuNbOz+4WCyNlqszZMGpHnp+ho2/CTub425NScy5j5r6RhQFLNueJh4H4BzjYl1bJcxu4do9jBO7t8uyt9m0OUQn8LfWvvdhDpW1tDzTynmM3TXc7jcsMZLnCYZOdfFeQAebZHHKV+ab8o2d+e3UT6fv3bbYu6ql5Bq6LmM4NaVEEelB0kLUGsNpDvI89tL5mvNFMimOQr9s2AQswKhwaWzYLJBpuPK2O5k8R7Tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199015)(2906002)(5660300002)(66556008)(316002)(8936002)(52536014)(66476007)(66946007)(76116006)(54906003)(4326008)(8676002)(64756008)(41300700001)(66446008)(110136005)(33656002)(71200400001)(478600001)(26005)(86362001)(6506007)(7696005)(9686003)(186003)(82960400001)(55016003)(38100700002)(83380400001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+G2mpASX+MXZWkhiiTiM55b62Zq8wEYYhZ8RZ1waVbmCyFtmgfSi9yQsK+4S?=
 =?us-ascii?Q?cFrJsODGapq4EIO0pQqYE4r4M0HgoxvZjQKzCjuZnXh95eIxQDHKmNO11GZ4?=
 =?us-ascii?Q?Dzypgf/pPWiXGbKLKssXwr42AvfF0jZUsB73qq+cIr5OF5o+/Mb+bQAdtVUP?=
 =?us-ascii?Q?XdJxrtBX6fKw62zxF3EVBh9ktN8Dq9B6NtvDvNQ35tFpsHovo8jTJGuNL4nP?=
 =?us-ascii?Q?lGbOhOpA14X8Bl5nJqs/fiV9LZW8C1Cc+o+H7cCMFWP6Q/EIbqAwidHYRA7t?=
 =?us-ascii?Q?fY9eA0Zo6FAf3RSwWYujWMn6PNMmPAdSCAWDqmlQsXpXGt9nvfNVC+9AcMH4?=
 =?us-ascii?Q?sWB+ydwDV1DvnI93YV8WI8UDshn7UpHOYx1qnOMwxlsd0sGozg8BZ3bjQ9Jn?=
 =?us-ascii?Q?TyMWGIeA6xEkT/sat34tSZaNGylaFXJ3T2vpQ9iDPKxXlffDXpMOgrHLc8ut?=
 =?us-ascii?Q?FfwLaCUt2ye5YYkmaH4+6DtMDiW/5jr75p/x2bILQ9JIFB1ZUS80/+QXdKKD?=
 =?us-ascii?Q?g5QSUaBtPzfaXyN5nFg1KrPWhuKrFuGQYFWcxb5rF35SSzZr63G0/25Npyp6?=
 =?us-ascii?Q?IZajNmZlhcWRb7S0iDBYykhVeh2/0mBC7yAyhi7J9vqgE9Fvn599P12FvhkZ?=
 =?us-ascii?Q?zRMVG3/QPG6n/AF9chAXqNTwjfdEDeKX4x2oFBkfkhXQ8b+wzQkNxXH/SY8/?=
 =?us-ascii?Q?yjI9Dcmqiqmv0Jm6HAIX742hSSWNT7UwenrS84aXA0DLbOVJ5PlTOyg8GC9q?=
 =?us-ascii?Q?y7zIqA5MX5zYIbQo+bH5mW4T/8jjf6N6+T52qI8/Sc6tfV8gw8K+UYSfguPc?=
 =?us-ascii?Q?MH3CqbXUgL3SqIA/kNt5OOowoWCJ9G1MFdPqCXE4Mmiph2v+tGpV3aKKbbjI?=
 =?us-ascii?Q?ibfw8nKmtqv1+uFl1fxvyu1l84pSTQ+z/cwkigWjkWISw1fJz+wyvOzjxmqz?=
 =?us-ascii?Q?U2oVOEqAJ7QL/QejSFnAmzbkRedDdqqE3HZLS7Y93sPgAWxl489eTfEAL6wc?=
 =?us-ascii?Q?pkQRZzKhwCrAKTnRFhjN7p4tA6LlxK2WJAwb9ubLgElTE2qpVvhAIc4ENFM0?=
 =?us-ascii?Q?mJttw3+3oDYds29aMihy+KBhFzKAh8lFFboMFrRawiaKbDSuCAENhSu2xv8i?=
 =?us-ascii?Q?T0n/vsuIA95VKAeo9wCcA0gc/sQZBdkPXybnBdEeqqQHuFsVSg1Gfv8u1Xh2?=
 =?us-ascii?Q?bG5U4MWb66wtuOkveV2pQ9My3uWsF5TUoxQyvmuf6a7B5NB8pyM6yMWBLJn8?=
 =?us-ascii?Q?+sTM2y0+g+ZQbCqavdkBGGvBYpY/CmUY1bi8fj098wkNat4dOlqhRQFQgsl9?=
 =?us-ascii?Q?5+kLxWXN82EK9sGoaY14NCMWTrFlCCIgO9Bwy/BEXZf5HgNj5VNH/1oALiIu?=
 =?us-ascii?Q?1KWE1CoZKEFDM1NKbBgI7v3s+FHucfHV8vtcrGmL8Z5X8c2g5P4NBHkbg+mF?=
 =?us-ascii?Q?+uFkRD5UY+doIba+wfbysehlpaYZArm+81m1GQjOvFS2VY7Wu0d7QHwRqtNe?=
 =?us-ascii?Q?+zhtsNgOmXLgxB4207h+NGDhKQgwQtohHbkNPy6BxcYqp07Ev0skcK+5Q4gz?=
 =?us-ascii?Q?mHxXAPybpBPZcmbBk+IPfCV8gQLo6Tx/LXvDoAnwaUzGtWGxxSF4m07Mk8j6?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bd59fc-ac38-4194-4a75-08dad9493f91
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 18:23:04.8204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9ki4owlhQvTR3WdwSlbK75RMOHk8YrV7R0umxcR6whx40K/aykAwPO8rrBZRQauWhZjdiWu7j2Bee0fjAaOLMcHOXfs81Qol9NM0Z6k3cQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7933
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, December 7, 2022 6:20 PM
>On Wed, 7 Dec 2022 15:51:42 +0100 Jiri Pirko wrote:
>> Wed, Dec 07, 2022 at 03:47:40AM CET, kuba@kernel.org wrote:
>> >On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:
>> >> Yep, you have the knowledge of sharing inside the driver, so you
>should
>> >> do it there. For multiple instances, use in-driver notifier for
>example.
>> >
>> >No, complexity in the drivers is not a good idea. The core should cover
>> >the complexity and let the drivers be simple.
>>
>> Really, even in case only one driver actually consumes the complexicity?
>> I understand having a "libs" to do common functionality for drivers,
>> even in case there is one. But this case, I don't see any benefit.
>
>In the same email thread you admit that mlx5 has multiple devlink
>instances for the same ASIC and refuse to try to prevent similar
>situation happening in the new subsystem.
>
>> >> There are currently 3 drivers for dpll I know of. This in ptp_ocp and
>> >> mlx5 there is no concept of sharing pins. You you are talking about a
>> >> single driver.
>> >>
>> >> What I'm trying to say is, looking at the code, the pin sharing,
>> >> references and locking makes things uncomfortably complex. You are so
>> >> far the only driver to need this, do it internally. If in the future
>> >> other driver appears, this code would be eventually pushed into dpll
>> >> core. No impact on UAPI from what I see. Please keep things as simple
>as
>> >> possible.
>> >
>> >But the pin is shared for one driver. Who cares if it's not shared in
>> >another. The user space must be able to reason about the constraints.
>>
>> Sorry, I don't follow :/ Could you please explain what do you mean by
>> this?
>
>We don't wait with adding APIs until there is more than one driver that
>needs them.
>
>> >You are suggesting drivers to magically flip state in core objects
>> >because of some hidden dependencies?!
>>
>> It's not a state flip. It's more like a well propagated event of a state
>> change. The async changes may happen anyway, so the userspace needs
>> to handle them. Why is this different?
>
>What if the user space wants conflicting configurations for the muxes
>behind a shared pin?
>
>The fact that there is a notification does not solve the problem of
>user space not knowing what's going on. Why would the user space play
>guessing games if the driver _knows_ the topology and can easily tell
>it.
>> >> There is a big difference if we model flat list of pins with a set of
>> >> attributes for each, comparing to a tree of pins, some acting as leaf=
,
>> >> node and root. Do we really need such complexicity? What value does i=
t
>> >> bring to the user to expose this?
>> >
>> >The fact that you can't auto select from devices behind muxes.
>>
>> Why? What's wrong with the mechanism I described in another part of this
>> thread?
>>
>> Extending my example from above
>>
>>    pin 1 source
>>    pin 2 output
>>    pin 3 muxid 100 source
>>    pin 4 muxid 100 source
>>    pin 5 muxid 101 source
>>    pin 6 muxid 101 source
>>    pin 7 output
>>
>> User now can set individial prios for sources:
>>
>> dpll x pin 1 set prio 10
>> etc
>> The result would be:
>>
>>    pin 1 source prio 10
>>    pin 2 output
>>    pin 3 muxid 100 source prio 8
>>    pin 4 muxid 100 source prio 20
>>    pin 5 muxid 101 source prio 50
>>    pin 6 muxid 101 source prio 60
>>    pin 7 output
>>
>> Now when auto is enabled, the pin 3 is selected. Why would user need to
>> manually select between 3 and 4? This is should be abstracted out by the
>> driver.
>>
>> Actually, this is neat as you have one cmd to do selection in manual
>> mode and you have uniform way of configuring/monitoring selection in
>> autosel. Would the muxed pin make this better?
>>
>> For muxed pin being output, only one pin from mux would be set:
>>
>>    pin 1 source
>>    pin 2 output
>>    pin 3 muxid 100 disconnected
>>    pin 4 muxid 100 disconnected
>>    pin 5 muxid 101 output
>>    pin 6 muxid 101 disconnected
>>    pin 7 output
>
>Sorry, can't parse, could you draw the diagram?
>
>To answer the most basic question - my understanding is that for
>prio-based selection there needs to be silicon that can tell if
>there is a valid clock on the line. While mux is just a fancy switch,
>it has no complex logic, just connects wires.
>
>Arkadiusz, is my understanding incorrect? I may have "intuited" this.
>

Yes, exactly.

    +--+       +-----------+
p8---  |   p0---           |
    |  |       |           -----p5
p9---  ----p1---           |
    |  |       |           -----p6
p10--  |   p2---           |
    |  |       |           |
    +--+   p3---           -----p7
               |           |
           p4---           |
               +-----------+
Silicon is configured with priorities for each of the directly connected
source pins (p0-p4, assume p5-p7 are outputs). Thus it can select highest
priority and valid signal of those.
Silicon is responsible to determine if the signal is present and valid for
clock recovery. If so, it can lock to it. If signal is not valid, then sili=
con
would try to lock to the next highest priority, and so on.
MUX-type pin is here aggregator for additional sources, They cannot be
autoselected by silicon, as they are external for silicon.
If the user want to have dpll "running" on p10, it requires to select p10 a=
nd
configure p1 as the highest priority pin.


>IDK if there are any bidirectional pins after a mux, but that'd be
>another problem. Muxes are only simple for inputs.

Same here, haven't heard about such design yet.
IMHO mux-pin is either source that has multiple sources connected or an out=
put
with multiple outputs.
i.e. extending above with:
        +----+=20
        |    ----p11
        |    |=20
---p5---|    ----p12
        |    |=20
        |    ----p13
        +----+
Where p11-p13 are muxed outputs.
The user is able to change i.e. frequency of p11/p12/p13 for some needs, or
connect/disconnect only one of it. Of course all depends on HW.

Thanks,
Arkadiusz

>
>> >The HW topology is of material importance to user space.
>>
>> Interesting. When I was working on linecards, you said that the user
>> does not care about the inner HW topology. And it makes sense. When
>> things could be abstracted out to make iface clean, I think they should.
>
>I recall only the FW related conversations, but what I think is key
>is whether the information can be acted upon.
>
>> >How many times does Arkadiusz have to explain this :|
>>
>> Pardon my ignorance, I don't see why exactly we need mux hierarchy
>> (trees) exposed to user.
