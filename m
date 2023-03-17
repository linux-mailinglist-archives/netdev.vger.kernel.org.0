Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F856BF09D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjCQSXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCQSXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:23:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A713E5FE91;
        Fri, 17 Mar 2023 11:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679077378; x=1710613378;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uTW4sr7lCUfJR4t0hwev0wGQpnTddTEJIU+mBcRVTH8=;
  b=BjBjNMhiDuzBS25UemWP3ax4NC8iW9YRg2Laj36kUY3NNg6Za085gLWY
   BrBxqrZQghqun2DBaEY9ANQMzicAl2JRgX8eh/c22OZzjp6HRvjRIydZk
   LHWwjDkyB9VpLymk5ABtS3IMNgTwp7O/DSFaQ8h6+InNyjeset5JlmFZg
   YwpKlpoBV67nM7it0pcBcLAUOkZ1At0xBwYgYIxEMT1/j/ROT8VcznuMT
   ubEJL3cWCWULRZYJ66KPs98VlK7XijZ3HIgDAf7NXjOx++CWcAQXDVzoB
   wbGN+f6XUUQx+MRMYcjlktKK8VHIIX9uuD/0X8w9AyBV0D5PI7O3b0giH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="322182316"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="322182316"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 11:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="804188639"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="804188639"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 17 Mar 2023 11:22:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:22:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 11:22:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 11:22:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 11:22:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBx6jhVfGRY1SqiYF9Zq57tX361RaZZ2RWho/sUAXnoaWPa2+4CwtEnsOps1vYhv5nPmstm1wgx0XVHKqsvPyNqKAkOFRxfrhSABPVLS3NpxL4qe7xHe7wYP19anV8cgxoO2pQGw+GSvLeKVtcW0dqvkAY1W/8S0Kew9MdSVlN2au68o/wsEJInlveU030OM7wX52pAJHmlwPDhSyeyRYbV6JJXANym/zFCq8Mu75z0zkDecOhurzP6Lw2OklPhUcr7h8GoI1+1pTRZshZrU3yXKn+TzMf65E4w6pqO4jf4RmRL9nocG66HOCWUur6/xu8/pvgJG1Bzj5OiJJ9PGHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvesI2jOYNgw/HnYaNuiTTbTE5IZ36NcNAjJE0/rF5s=;
 b=W5cNtaiMzDjlt3lyqbwEedMCobgxQR+aK6broE/yNwlovMGmD0Zec+ADuspFNC7yqe1U1fHF33InDGsY/B2Q3f0QAiwomHpInQ/iO3ct/NUo8DQVORNA6JUO408MRVBDIJIEqMTzumnqHI5AUZuWnTfQKpve60wqSS19SBWhE6L/BdHZTnxDcwBJlHsFrbAzImJYhTKG7P2Jdum/J0SoLFu4XpVqmINfHH8QcAtPRc7LFJT/pvYqBfBf5mxjS4MVxyQ5JN/T/zPU6ESqeScix7q/pClyYP59LFvc5r9Ow7x+Ge3Fiz37d2DCyWziOo1XGTp0julc7acCkqsbrSOEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:22:47 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6178.029; Fri, 17 Mar 2023
 18:22:46 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Thread-Index: AQHZVIpWqQ/E3o2ZU0SoOV6Pk96rvK76Xc8AgAML3PCAAAhNAIAAnfVQgAC2+wCAAC320IAAOtgAgAAbziA=
Date:   Fri, 17 Mar 2023 18:22:46 +0000
Message-ID: <DM6PR11MB465709F2E30586AFCCE1461E9BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com> <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
 <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBQ7ZuJSXRfFOy1b@nanopsycho>
 <DM6PR11MB4657F48649CFEB92D28D4ED49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBSTUB7q8EsfhHSL@nanopsycho>
In-Reply-To: <ZBSTUB7q8EsfhHSL@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|BL3PR11MB6505:EE_
x-ms-office365-filtering-correlation-id: b569af21-6f72-4d27-0244-08db27149bbf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W4WLXeQ4nlOtLeA96PPzR48RUl8eeN7Sn55sOfL8X0kA8imuf0z1XHhVkO5lG6ujyJC8llvXYGr1whAvmscNVfJL893rIUHDB/kzcYJo7buwFYdErj1zZDkprf5KKDNe/FfAokmHTKwcYLqu8I4X66LiBiEBBFqB2/UnepSK0BZ0h+E9GTPKTEU8meU13m2J+gyNG6CDDMT3pa4xErPoR/lt1HyF0sBu1O3WvPGiXMt6m+IiYvc1+4BFNPQtUfePWIC6h7DQ1CQldvskWd6vDD/uhRo5bHU3crGsW5vxGNOrcGVsRaVSlLHQTda3//vkZCKN+DPHYpbvQ7dqKQQxJbL8wvxIdSEV4p+p7ZRoRpr+RZJerGo4hx7/wAEQr03VfeoXwmlwMCMn7oPmU6RbbsEqEx0nsPxlMudx7PMmAWIGRRdBd6Ju8IwJGNdWVUroecA7OkNQaSTMnttLrvFTNAIOAoHvqzOANsaNloKwunm3hRMV2TjZS51qTD6D36h4+ZUX2+PRUhgsrfdwGSSktJERlWU1MevcHbZnMFMfpfyv3Jfa8DMSBp2KSPyNhEzVIatjLQ8pmwYcuvKb8EzflzvuQ5CyH84Jplvhbeo5OO3nmh4KvSdaBmsJ/xLXhslDYFOAZErLzxMxuQvxZBy+xtc4/f8dxahGhYltzJVjfuvGTEop5OP3rgA/tkqZEGr97eK7XQYJZfmyd7Z0Wuj6RA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(33656002)(52536014)(7416002)(41300700001)(8936002)(2906002)(86362001)(38100700002)(38070700005)(82960400001)(122000001)(5660300002)(7696005)(66946007)(6916009)(66556008)(66476007)(478600001)(4326008)(107886003)(64756008)(66446008)(8676002)(76116006)(55016003)(71200400001)(54906003)(316002)(83380400001)(186003)(9686003)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lWCKehSeY6Pfv6MaSuHFjbxAVtesy8KVNOOEpuhnyKNuHfDcR60i6gmwXvQk?=
 =?us-ascii?Q?RVAV026KqZ9XyJ7ZL4NyWTD9Laq40cD5oOGKakCtMwPIXGwuE6CTF+6bdwKp?=
 =?us-ascii?Q?2pbq05tKXA+cdpslEw8nxhgcfdwP/gvwYlaaJLN7LcwEQ/HGkOISGO7t5f7m?=
 =?us-ascii?Q?VpgTkemapqFINEXIHRbXU2XHBCJRpJ7nWpXnSq1Wu+AcllJlyZUw5/sNLmMt?=
 =?us-ascii?Q?udwFzu/UC1ssrQqFMlS/wO7jE4cncDZdhITZkbQ8ERqfZiCVshJF8UuLgyCQ?=
 =?us-ascii?Q?XjROKdgUjbrRsFP3uNp9tHT6RO7K96X5TAFS7JrStfppcMr5tgmVcMSURRay?=
 =?us-ascii?Q?wzUi9XigmXqIOgORBU3Pg5DH+5a2MOxudeBKdioq3pbH4yF1WX+A470kQx5x?=
 =?us-ascii?Q?H6KP8tVcdkAmXU53COn/v23AMD6pDTJMTk3cMLSvG8PC938fHi1TCqW+NIkT?=
 =?us-ascii?Q?gafBHL0m0BoRTD0Q8bWuKDnez7Ziec/4TIgMJ8LfqHkOhneIaLGCmKTaG0Kg?=
 =?us-ascii?Q?v1L3QJHg1laOdW19Rwjlz744Iuk3pc3ByDYSZRW6OK5V3ZaSSNOYQWf2KDQd?=
 =?us-ascii?Q?coKIQYXEC/pijTrdpYjgD1LDiRVOL4Qur3xiRVt356/UKOjBrO+jXH5a1QAa?=
 =?us-ascii?Q?5Z/xYS3sjSIPcwjZDyLfbAjcD/7pFeeHoH5u07YUxS7cuN99XdDQIMcxGNs5?=
 =?us-ascii?Q?O4NHWvfrlysoN+9/JG79XDFdywAc7xYz/dUgl3c4R9dvDCXs++t7VnbSKFTa?=
 =?us-ascii?Q?djMsEQvmznqHc8r6sTHUkHxDaIGbT0JT5615vQJjSArR1wQXUezOxhSAth8C?=
 =?us-ascii?Q?5cZGtAYLfDpLCj9XAP8FdGY9LrEx4aV+yQDoDtsSmvieuIngkfUOLNKn9O5h?=
 =?us-ascii?Q?BEOQOlVgGKKfT4myNGWxhxA1bRgYtlVvCGzK4Hzz5RMRZi/Nqul2+LytenSI?=
 =?us-ascii?Q?mBRFm2y9U2zjT56C1U5fg5aBWS8+MrZDZ7xo+V2HRRDKUiJ4nzrmYliSKZKL?=
 =?us-ascii?Q?fc4Ud76CC1GS990RHjRaO34gIvgQSRfQaWoRhtjDnu7EugDu9swFPtrYWIqr?=
 =?us-ascii?Q?A+8sx/JBbpYIESgF2unQ/ksVBa81Rm2RMoUWQcAhFznF3LBCtEvQ0UTmo5vJ?=
 =?us-ascii?Q?HuO15NKgwzil65ZcABg/7sQGWuAt0tnwI0JOI8uWWBD4TExTPNgWG4/Qc1S6?=
 =?us-ascii?Q?3L0aaBEjc6YZZ432ApjtZFLARM9J9WcOGlHblsvj9kisyTgANATOKh5EZG74?=
 =?us-ascii?Q?lhEyP0LfUpfi1pFUo6ld3yXf3HFEmHr5gEfYiB482UkjTnJky0PNX+5FUvxV?=
 =?us-ascii?Q?h+KLT7AM9w82UXFJivikNwlWL6qjKsDE+F2gXz2lOA31jir9WM8gOVHxnQQe?=
 =?us-ascii?Q?Otvdkebyh/Yoe8KZtxusiAxIe5LmcrXzbs2VfdykQAKDerVA7VTLrr0qbIHg?=
 =?us-ascii?Q?z0LoUnRLiInymrZeObX4kMCJ/+o/4jdJk2eqQ4ND+1lq1k1p2hp7gn9ZWsvI?=
 =?us-ascii?Q?8D1cb0BtAix4SVp2l+EddmBL/Fd2i2OAk8YUCTckg/MSH5cZHcV+S2fJKS1z?=
 =?us-ascii?Q?VIPLKcG1UH7A8w/qPDRc6nRz4IVGIj5fcyKw5p8CkArFjq4WRwFYTlJX8zZg?=
 =?us-ascii?Q?Ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b569af21-6f72-4d27-0244-08db27149bbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 18:22:46.8247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DO6Fs2ij46FqsXO5MuGBBHo6iUYW597DyxZabejPMqbHaI2DjYIGHSCegdR46x5s1rr6+udhVNHnSMqtCHzD9Nk/eyzU4KoC1LeKdKNRNzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, March 17, 2023 5:21 PM
>
>Fri, Mar 17, 2023 at 04:14:45PM CET, arkadiusz.kubalewski@intel.com wrote:
>>
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Friday, March 17, 2023 11:05 AM
>>>
>>>Fri, Mar 17, 2023 at 01:52:44AM CET, arkadiusz.kubalewski@intel.com
>>>wrote:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Thursday, March 16, 2023 2:45 PM
>>>>>
>>>>
>>>>[...]
>>>>
>>>>>>>>+attribute-sets:
>>>>>>>>+  -
>>>>>>>>+    name: dpll
>>>>>>>>+    enum-name: dplla
>>>>>>>>+    attributes:
>>>>>>>>+      -
>>>>>>>>+        name: device
>>>>>>>>+        type: nest
>>>>>>>>+        value: 1
>>>>>>>>+        multi-attr: true
>>>>>>>>+        nested-attributes: device
>>>>>>>
>>>>>>>What is this "device" and what is it good for? Smells like some
>>>>>>>leftover
>>>>>>>and with the nested scheme looks quite odd.
>>>>>>>
>>>>>>
>>>>>>No, it is nested attribute type, used when multiple devices are retur=
ned
>>>>>>with netlink:
>>>>>>
>>>>>>- dump of device-get command where all devices are returned, each one
>>>>>>nested
>>>>>>inside it:
>>>>>>[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id':0=
},
>>>>>>             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id':1=
}]}]
>>>>>
>>>>>Okay, why is it nested here? The is one netlink msg per dpll device
>>>>>instance. Is this the real output of you made that up?
>>>>>
>>>>>Device nest should not be there for DEVICE_GET, does not make sense.
>>>>>
>>>>
>>>>This was returned by CLI parser on ice with cmd:
>>>>$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
>>>>--dump device-get
>>>>
>>>>Please note this relates to 'dump' request , it is rather expected that
>>>there
>>>>are multiple dplls returned, thus we need a nest attribute for each one=
.
>>>
>>>No, you definitelly don't need to nest them. Dump format and get format
>>>should be exactly the same. Please remove the nest.
>>>
>>>See how that is done in devlink for example: devlink_nl_fill()
>>>This functions fills up one object in the dump. No nesting.
>>>I'm not aware of such nesting approach anywhere in kernel dumps, does
>>>not make sense at all.
>>>
>>
>>Yeah it make sense to have same output on `do` and `dump`, but this is al=
so
>>achievable with nest DPLL_A_DEVICE, still don't need put extra header for=
 it.
>>The difference would be that on `dump` multiple DPLL_A_DEVICE are provide=
d,
>>on `do` only one.
>
>Please don't. This root nesting is not correct.
>
>
>>
>>Will try to fix it.
>>Although could you please explain why it make sense to put extra header
>>(exactly the same header) multiple times in one netlink response message?
>
>This is how it's done for all netlink dumps as far as I know.

So we just following something but we cannot explain why?

>The reason might be that the userspace is parsing exactly the same
>message as if it would be DOIT message.
>

This argument is achievable on both approaches.

[...]


>>>>>>>
>>>>>>>Hmm, shouldn't source-pin-index be here as well?
>>>>>>
>>>>>>No, there is no set for this.
>>>>>>For manual mode user selects the pin by setting enabled state on the
>one
>>>>>>he needs to recover signal from.
>>>>>>
>>>>>>source-pin-index is read only, returns active source.
>>>>>
>>>>>Okay, got it. Then why do we have this assymetric approach? Just have
>>>>>the enabled state to serve the user to see which one is selected, no?
>>>>>This would help to avoid confusion (like mine) and allow not to create
>>>>>inconsistencies (like no pin enabled yet driver to return some source
>>>>>pin index)
>>>>>
>>>>
>>>>This is due to automatic mode were multiple pins are enabled, but actua=
l
>>>>selection is done on hardware level with priorities.
>>>
>>>Okay, this is confusing and I believe wrong.
>>>You have dual meaning for pin state attribute with states
>>>STATE_CONNECTED/DISCONNECTED:
>>>
>>>1) Manual mode, MUX pins (both share the same model):
>>>   There is only one pin with STATE_CONNECTED. The others are in
>>>   STATE_DISCONNECTED
>>>   User changes a state of a pin to make the selection.
>>>
>>>   Example:
>>>     $ dplltool pin dump
>>>       pin 1 state connected
>>>       pin 2 state disconnected
>>>     $ dplltool pin 2 set state connected
>>>     $ dplltool pin dump
>>>       pin 1 state disconnected
>>>       pin 2 state connected
>>>
>>>2) Automatic mode:
>>>   The user by setting "state" decides it the pin should be considered
>>>   by the device for auto selection.
>>>
>>>   Example:
>>>     $ dplltool pin dump:
>>>       pin 1 state connected prio 10
>>>       pin 2 state connected prio 15
>>>     $ dplltool dpll x get:
>>>       dpll x source-pin-index 1
>>>
>>>So in manual mode, STATE_CONNECTED means the dpll is connected to this
>>>source pin. However, in automatic mode it means something else. It means
>>>the user allows this pin to be considered for auto selection. The fact
>>>the pin is selected source is exposed over source-pin-index.
>>>
>>>Instead of this, I believe that the semantics of
>>>STATE_CONNECTED/DISCONNECTED should be the same for automatic mode as
>>>well. Unlike the manual mode/mux, where the state is written by user, in
>>>automatic mode the state should be only written by the driver. User
>>>attemts to set the state should fail with graceful explanation (DPLL
>>>netlink/core code should handle that, w/o driver interaction)
>>>
>>>Suggested automatic mode example:
>>>     $ dplltool pin dump:
>>>       pin 1 state connected prio 10 connectable true
>>>       pin 2 state disconnected prio 15 connectable true
>>>     $ dplltool pin 1 set connectable false
>>>     $ dplltool pin dump:
>>>       pin 1 state disconnected prio 10 connectable false
>>>       pin 2 state connected prio 15 connectable true
>>>     $ dplltool pin 1 set state connected
>>>       -EOPNOTSUPP
>>>
>>>Note there is no "source-pin-index" at all. Replaced by pin state here.
>>>There is a new attribute called "connectable", the user uses this
>>>attribute to tell the device, if this source pin could be considered for
>>>auto selection or not.
>>>
>>>Could be called perhaps "selectable", does not matter. The point is, the
>>>meaning of the "state" attribute is consistent for automatic mode,
>>>manual mode and mux pin.
>>>
>>>Makes sense?
>>>
>>
>>Great idea!
>>I will add third enum for pin-state: DPLL_PIN_STATE_SELECTABLE.
>>In the end we will have this:
>>              +--------------------------------+
>>              | valid DPLL_A_PIN_STATE values  |
>>	      +---------------+----------------+
>>+------------+| requested:    | returned:      |
>>|DPLL_A_MODE:||               |                |
>>|------------++--------------------------------|
>>|AUTOMATIC   ||- SELECTABLE   | - SELECTABLE   |
>>|            ||- DISCONNECTED | - DISCONNECTED |
>>|            ||               | - CONNECTED    |
>
>"selectable" is something the user sets.

Yes.

>"connected"/"disconnected" is in case of auto mode something that driver
>sets.
>

No. Not really.
"CONNECTED" is only set by driver once a pin is choosen.
"SELECTABLE" is set by the user if he needs to enable a pin for selection,
it is also default state of a pin if it was not selected ("CONNECTED")
"DISCONNECTED" is set by the user if he needs to disable a pin from selecti=
on.

>Looks a bit odd to mix them together. That is why I suggested
>to have sepectable as a separate attr. But up to you. Please make sure
>you sanitize the user/driver set of this attr in dpll code.
>

What is odd?
What do you mean by "sanitize the user/driver set of this attr in dpll code=
"?


Thank you,
Arkadiusz

>
>>|------------++--------------------------------|
>>|MANUAL      ||- CONNECTED    | - CONNECTED    |
>>|            ||- DISCONNECTED | - DISCONNECTED |
>>+------------++---------------+----------------+
>>
>>Thank you,
>>Arkadiusz
>>
>>>
>>>>
>>>>[...]
>>>>
>>>>>>>>+
>>>>>>>>+/* DPLL_CMD_DEVICE_SET - do */
>>>>>>>>+static const struct nla_policy
>dpll_device_set_nl_policy[DPLL_A_MODE +
>>>>>>>>1]
>>>>>>>>=3D {
>>>>>>>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>>>>>>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>>>>>>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>>>>>>>+	[DPLL_A_MODE] =3D NLA_POLICY_MAX(NLA_U8, 5),
>>>>>>>
>>>>>>>Hmm, any idea why the generator does not put define name
>>>>>>>here instead of "5"?
>>>>>>>
>>>>>>
>>>>>>Not really, it probably needs a fix for this.
>>>>>
>>>>>Yeah.
>>>>>
>>>>
>>>>Well, once we done with review maybe we could also fix those, or ask
>>>>Jakub if he could help :)
>>>>
>>>>
>>>>[...]
>>>>
>>>>>>>
>>>>>>>>+	DPLL_A_PIN_PRIO,
>>>>>>>>+	DPLL_A_PIN_STATE,
>>>>>>>>+	DPLL_A_PIN_PARENT,
>>>>>>>>+	DPLL_A_PIN_PARENT_IDX,
>>>>>>>>+	DPLL_A_PIN_RCLK_DEVICE,
>>>>>>>>+	DPLL_A_PIN_DPLL_CAPS,
>>>>>>>
>>>>>>>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with t=
he
>>>>>>>enum name.
>>>>>>
>>>>>>Sure, fixed.
>>>>>
>>>>>
>>>>>Thanks for all your work on this!
>>>>
>>>>Thanks for a great review! :)
>>>
>>>Glad to help.
