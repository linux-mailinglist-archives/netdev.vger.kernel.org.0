Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE326671DB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjALMQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjALMPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:15:42 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C5DDEC9;
        Thu, 12 Jan 2023 04:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673525740; x=1705061740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S/CsC1crUsHX+7qdWyQgxbmLypY6YkFCeiYk/iwwmSI=;
  b=R1a6s8Pv9hGeC3MF2KmHR56q+kYA/DXSRxyYDsAhR+5auPLViB3Jw/sy
   RjoY77jmIjhe+1+cKxfou1p96g9m1nfeNAbcnkOPSJLYxGEZ7BIkeFHbK
   nAeC05rnx3DbkZcCNIbmcbyK98UTx/lMdZ6fNrfcRtfzTQX8SQZ9rKwBa
   U0ksjqfCbKbX2jdCUf6ySYdr7swmYesKhxKPYkcMwFw1nA52NQmfi6FAX
   DmqZPbzy2kaCZokFDy/GcxuO1R+JmbPBVlhpEuFRLeqD+whnp9CKDjfU8
   mze74snH6APe96YMyzkMTHgcSVSZtwyeL/R8jJ7L9y8GbVHlOnUrJxJrd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="324926049"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="324926049"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 04:15:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="657781862"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="657781862"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 12 Jan 2023 04:15:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 04:15:38 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 04:15:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 04:15:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 04:15:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSPX5JuEjcx5PhVuPHag/NJ8a9cQENARhMFPrFWVw/QVhoYYSNt60F3y8viIZ8tFJMSNbKGmyT1a9+h21fWu1gJZYMeaThrC46hZB7+Onyzdxaorl5+HynCU4AC1+nYRTXA7HFSoa4QGTVx6Bz7NjQU4RqjJcL3GA0A4u+2bqd/5R9VwMfl196MhX6wsoCiDn6/mFaf1sgvcQVZ2HBAV69TeVpDfsJH8JdtnMq95QCNOWHqm2tre2zoa2GiwBNirxfKOfVtvF4IFNjnHJq2fJbKYSOZ7skpLR13iKMI95RkMUv6LvLMibW2+LNtf7W4kIEM3j9gu5//ZIv+XComGdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMs/B5Osu/hioH4in5cKDWvFEQaRPPe+0VJaKAxkbEQ=;
 b=KvhwcMQIAfhju7V3jU2XzSPtQ2srY7Ohy/Eu5w5Yuu+I+bx3aH1PZdvXhG93GmW2XKhExdFEL+XGq+91ccPARiCOn7DK0I2yxpIa+x6eSmTl2xpEi/4sw23n+zXf9FZ0YbEoNUEKh5vymo9A6T/kpOPb1LFunKKymXWJFV8aOeH20pEkbV8fkhG5QnXYicpspMGpQWdNbQcaamnFVqM+e+0saqIcE0Hu3iC8AHY9/1+t80uj30GAm85AeJFBBDhb4vopbK0S50giUpItFQw5A28G0fHt6ivY4FoW0nbglL7Pp3TXTpw+M0hhlkLilXZ1htYUNuz8BRO5hFhDn2QSmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7549.namprd11.prod.outlook.com (2603:10b6:510:27b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 12:15:30 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 12:15:30 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        "'Jonathan Lemon'" <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAG+ucAgAC+YICAAJp7gIABOqIAgAEc44CAADKwAIAAJ6gAgASMcoCALA0RgIAB7ReAgADNAgCAAF4QcIAAEyqAgAAChKCAABESgIAAA3/A
Date:   Thu, 12 Jan 2023 12:15:30 +0000
Message-ID: <DM6PR11MB4657A41D59E6B1162EA6AFDB9BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org> <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230110120549.4d764609@kernel.org> <Y75xFlEDCThGtMDq@nanopsycho>
 <DM6PR11MB4657AC41BBF714A280B578D49BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y77QEajGlJewGKy1@nanopsycho>
 <DM6PR11MB4657DC9A41A69B71A42DD22F9BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y77gf1ekbSMdY83b@nanopsycho>
In-Reply-To: <Y77gf1ekbSMdY83b@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7549:EE_
x-ms-office365-filtering-correlation-id: 15b9a662-b6d1-4733-77a8-08daf496b29c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8S3lOQT1wWWY1bzPWDLP/F/j90LqVjE2WiM6QzQ2vSBBF1jDWvwjR/1/kUakLNaDqOXLLvPg1L1dYtEU+huCn6xXEinLsNUcAVp5yqQy5ufK6ZOzmxNiA3QZH6cjSsIJm/UjtIHN5gUN3P/pLH7RLsXMi16dVxzLRtArgX55n4jAk0qEPYW9Kj/TWSGWEqv/wrGCAwC17dU2duvKRwaKnMbNE0tKpsfQ8bMxqzYJaEyVJADuY8o1stjV2SLYIUS8twjW5ZDbibfDZ4jREudmt2hgtEU52KH+zgq3juj5gO9lybGtKuxejLmddwMiuQvPpWIaREGQWhhM4V39IQ6ms9GEVi7SCFIMmBtgbnyrZZ7+7hDrP9xOFopTfCd85nqUZvaoucOiVVHaTWESn5AGDlirbwnJZm5lnXhpGxBAUJoj99XZEVuKfZRHWlNUSzmlZVRIOp52/cuyLvD4N3anSUc9iSg8ARSy5YX/RiPnIsE10ojGCcJRhHmuNR22z3BS6O8OMq+4lr4bVU7BeFg5sh5Si1bD+FUQnI44L6Yq7kd2KIhXKvGb94/sPlnAAZxNf/I4jGSpoW+EKQVHk5E3QJYAuiZi5jPQbaZLFPSSvNmU/eUqVGa9q0Ab/w7F9Ht3p8dSK/4Wa8Mzvx8VCYY77mQtHWzMrAZAN/f8JoKVOB4+I99EjUCTlODueUotRVaQb1PQuRKngoM+FZSrCXY3nABEF6ODzuDmdoSEzdSU1cU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199015)(2906002)(71200400001)(6506007)(7696005)(26005)(478600001)(9686003)(186003)(55016003)(8676002)(83380400001)(66446008)(66946007)(64756008)(54906003)(316002)(76116006)(66556008)(66476007)(6916009)(4326008)(41300700001)(33656002)(82960400001)(122000001)(38100700002)(52536014)(38070700005)(86362001)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hr5DRquMq02BCIv+pjwNDB4t6C1nfcdopfXVLCElrPyv5/JNYUFb909CJ5n9?=
 =?us-ascii?Q?FTyxaISOu6xBLCSMd4/QDkwnyvlqwxuPXrq9Mng65gAsevJ8bWerF1W6RN3l?=
 =?us-ascii?Q?t8JR2UgZM1J2FW1LB5TFQzYlGvHVN3+pGpk68kmw/QXcAre07XJy2kK7p6bK?=
 =?us-ascii?Q?9T3MNSLGZhiHrYCzayV/9hlTtl7AABq4gohiNRibaoh4Ys1xtWhUcNAkJYiV?=
 =?us-ascii?Q?z0rX0BJ5hYBySA01bUfkI/LOAHKuC8vHwOppUowHhR0UYjvTzA58LcIQwWHy?=
 =?us-ascii?Q?E3ljCUxq5mCkgx3+vhJoMoHljAGOPoiz3kpSm7DbqX40ivTyVgrGeYLVR6Nl?=
 =?us-ascii?Q?5DTtbqiJzERGr2+AbRDNf8dXyNOqR4kOcmSdWU0ILZUTysTz8OBRDnrKopzu?=
 =?us-ascii?Q?TOWWgAUGddvqHi40NwhD8f24E2jMXP7TFXxTtD/HLYeyj3XTIzKksWQoPHRe?=
 =?us-ascii?Q?ZZMDu7o3x030+7egjYgbRZcKgGNazRmlx8YvmaPhT7S5fkrUw+2psqKdaEoQ?=
 =?us-ascii?Q?pX5T1cSLCeu2E9XuV1vHcGJVs9ph4cumzb964dOG1XWRQsLkjPhFmd+MEaSj?=
 =?us-ascii?Q?6DIDikwydlWB3i5xN/WqNhTdd82YjEAPu10Ywb7vWP9jWok9JXukAH5GNRo9?=
 =?us-ascii?Q?FpDgHWENuqD5KTVsNrEVMbH0qqT9FyMDqoLKbFr0/j3GULHSGtlC/m+GR4an?=
 =?us-ascii?Q?42X5aOxeTiPeUREGXBFDg2yPbIPjMqTQgjdAXOyyTVJSfbVkRBNsng9aGYS6?=
 =?us-ascii?Q?vQi7z5L72+N1MrLbHh4gD3/nkhDzHmA9FQnqk7iDPrSMjxd+4Q3bmvQrON9K?=
 =?us-ascii?Q?mfNStaaxaJsMpOceHpUiHavYSskm/VTlMJULq5IMvaJVUxUdtqCnhQvJeKqc?=
 =?us-ascii?Q?AHtNJAy7MwSdPsgU2qGvyxqrWR0dWf85mbL38EArGPzvpe0xU8D+EuH5mLO1?=
 =?us-ascii?Q?gh/BfTvWff35mViNFaxJFTohVPl8/ZsLalgZue96bf3I1dCnCLVpgjgiZDt+?=
 =?us-ascii?Q?gxqg9rWqp9m2YQqocjbW0O+vHgvH5+smssgndmOOSkA8umY0Ivrj8PcEp3Pn?=
 =?us-ascii?Q?3y6w5lVCG9N9lAvk4U76otjwfC7vnv8bTxCPKQslLlQslDOO/zJipSBVbJWr?=
 =?us-ascii?Q?d79riGQWkisUL3bgYw+Vc9eW9jmtAaIZuTNYSgKMKmCEbIuofhMJUCRvwAYr?=
 =?us-ascii?Q?T383Hnyy7LBrGkZvg6Kk88XoF1QNOnT8M6dTFogYjEbgjSrzfJLFfA6XI/MK?=
 =?us-ascii?Q?0TXsQUOYpv3Ng6+MUgESylM+F2OMZqS236e2QTeNM9rfuZ4yHWPTf/zOwSwo?=
 =?us-ascii?Q?73MgwXJRhfcPhB01tc3ddlRdbwCW+zSOZlw6YWaThWcBNKV4XRGQnUnSUOQg?=
 =?us-ascii?Q?lTRV8U9PW+pDZ+aR8MQO7yRU+p4N67WutK0kFbnEcCBabUaV+OwDKLisX49S?=
 =?us-ascii?Q?RnDD6voMwuMxz040cIAKnysSxkdpmAkotn/oicvX4kyrI8CE9b37r13tftS1?=
 =?us-ascii?Q?K7/jF+WIVJssd37H25jfQOvEWiJLMmqdxeGwbnNoyYynF8AuJ0iIdH5xjku8?=
 =?us-ascii?Q?8XIJc3Q7wiegTiaZcCpplWRo6CO1ieASZ1tFz+FQMP5gM23Li62kbPSi1y4p?=
 =?us-ascii?Q?bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b9a662-b6d1-4733-77a8-08daf496b29c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 12:15:30.4735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QIvmlFHGduILk1Ta0Yjehb5rWxY4IXBYF30ftfJMtRH7k409Kq1IjE/fNYU4/XGfuL9yAKBOjhzviN8AmjJu3bOMskxljeoM40DuXdzRHDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7549
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, January 11, 2023 5:15 PM
>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>
>Wed, Jan 11, 2023 at 04:30:44PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, January 11, 2023 4:05 PM
>>>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>>>
>>>Wed, Jan 11, 2023 at 03:16:59PM CET, arkadiusz.kubalewski@intel.com
>wrote:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Wednesday, January 11, 2023 9:20 AM
>>>>>
>>>>>Tue, Jan 10, 2023 at 09:05:49PM CET, kuba@kernel.org wrote:
>>>>>>On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
>>>>>>> This is a simplified network switch board example.
>>>>>>> It has 2 synchronization channels, where each channel:
>>>>>>> - provides clk to 8 PHYs driven by separated MAC chips,
>>>>>>> - controls 2 DPLLs.
>>>>>>>
>>>>>>> Basically only given FW has control over its PHYs, so also a contro=
l
>>>>>over it's
>>>>>>> MUX inputs.
>>>>>>> All external sources are shared between the channels.
>>>>>>>
>>>>>>> This is why we believe it is not best idea to enclose multiple DPLL=
s
>>>>>with one
>>>>>>> object:
>>>>>>> - sources are shared even if DPLLs are not a single synchronizer
>chip,
>>>>>>> - control over specific MUX type input shall be controllable from
>>>>>different
>>>>>>> driver/firmware instances.
>>>>>>>
>>>>>>> As we know the proposal of having multiple DPLLs in one object was =
a
>>>try
>>>>>to
>>>>>>> simplify currently implemented shared pins. We fully support idea o=
f
>>>>>having
>>>>>>> interfaces as simple as possible, but at the same time they shall b=
e
>>>>>flexible
>>>>>>> enough to serve many use cases.
>>>>>>
>>>>>>I must be missing context from other discussions but what is this
>>>>>>proposal trying to solve? Well implemented shared pins is all we need=
.
>>>>>
>>>>>There is an entity containing the pins. The synchronizer chip. One
>>>>>synchronizer chip contains 1-n DPLLs. The source pins are connected
>>>>>to each DPLL (usually). What we missed in the original model was the
>>>>>synchronizer entity. If we have it, we don't need any notion of someho=
w
>>>>>floating pins as independent entities being attached to one or many
>>>>>DPLL refcounted, etc. The synchronizer device holds them in
>>>>>straightforward way.
>>>>>
>>>>>Example of a synchronizer chip:
>>>>>https://www.renesas.com/us/en/products/clocks-timing/jitter-
>attenuators-
>>>>>frequency-translation/8a34044-multichannel-dpll-dco-four-eight-
>>>>>channels#overview
>>>>
>>>>Not really, as explained above, multiple separated synchronizer chips
>can
>>>be
>>>>connected to the same external sources.
>>>>This is why I wrote this email, to better explain need for references
>>>between
>>>>DPLLs and shared pins.
>>>>Synchronizer chip object with multiple DPLLs would have sense if the
>pins
>>>would
>>>>only belong to that single chip, but this is not true.
>>>
>>>I don't understand how it is physically possible that 2 pins belong to 2
>>>chips. Could you draw this to me?
>>>
>>
>>Well, sure, I was hoping this is clear, without extra connections on the
>draw:
>
>Okay, now I understand. It is not a shared pin but shared source for 2
>pins.
>

Yes, exactly.

>
>>+----------+
>>|i0 - GPS  |--------------\
>>+----------+              |
>>+----------+              |
>>|i1 - SMA1 |------------\ |
>>+----------+            | |
>>+----------+            | |
>>|i2 - SMA2 |----------\ | |
>>+----------+          | | |
>>                      | | |
>>+---------------------|-|-|-------------------------------------------+
>>| Channel A / FW0     | | |     +-------------+   +---+   +--------+  |
>>|                     | | |-i0--|Synchronizer0|---|   |---| PHY0.0 |--|
>
>One pin here               ^^^
>
>>|         +---+       | | |     |             |   |   |   +--------+  |
>>| PHY0.0--|   |       | |---i1--|             |---| M |---| PHY0.1 |--|
>>|         |   |       | | |     | +-----+     |   | A |   +--------+  |
>>| PHY0.1--| M |       |-----i2--| |DPLL0|     |   | C |---| PHY0.2 |--|
>>|         | U |       | | |     | +-----+     |   | 0 |   +--------+  |
>>| PHY0.2--| X |--+----------i3--| +-----+     |---|   |---| ...    |--|
>>|         | 0 |  |    | | |     | |DPLL1|     |   |   |   +--------+  |
>>| ...   --|   |  | /--------i4--| +-----+     |---|   |---| PHY0.7 |--|
>>|         |   |  | |  | | |     +-------------+   +---+   +--------+  |
>>| PHY0.7--|   |  | |  | | |                                           |
>>|         +---+  | |  | | |                                           |
>>+----------------|-|--|-|-|-------------------------------------------+
>>| Channel B / FW1| |  | | |     +-------------+   +---+   +--------+  |
>>|                | |  | | \-i0--|Synchronizer1|---|   |---| PHY1.0 |--|
>
>And second pin here        ^^^
>
>There are 2 separate pins. Sure, they need to have the same config as
>they are connected to the same external entity (GPS, SMA1, SMA2).
>
>Perhaps we need to have a board description using dts to draw this
>picture so the drivers can use this schema in order to properly
>configure this?
>
>My point is, you are trying to hardcode the board geometry in the
>driver. Is that correct?
>

Well, we are trying to have userspace-friendly interface :)
As we discussed yesterday dts is more of embedded world thing and we don't
want to go that far, the driver knows the hardware it is using, thus it
shall be enough if it has all the information needed for initialization.
At least that is what I understood.

BR,
Arkadiusz

>
>>|         +---+  | |  | |       |             |   |   |   +--------+  |
>>| PHY1.0--|   |  | |  | \---i1--|             |---| M |---| PHY1.1 |--|
>>|         |   |  | |  |         | +-----+     |   | A |   +--------+  |
>>| PHY1.1--| M |  | |  \-----i2--| |DPLL0|     |   | C |---| PHY1.2 |--|
>>|         | U |  | |            | +-----+     |   | 1 |   +--------+  |
>>| PHY1.2--| X |  \-|--------i3--| +-----+     |---|   |---| ...    |--|
>>|         | 1 |    |            | |DPLL1|     |   |   |   +--------+  |
>>| ...   --|   |----+--------i4--| +-----+     |---|   |---| PHY1.7 |--|
>>|         |   |                 +-------------+   +---+   +--------+  |
>>| PHY1.7--|   |                                                       |
>>|         +---+                                                       |
>>+---------------------------------------------------------------------+
>>
>>>
>>>>As the pins are shared between multiple DPLLs (both inside 1 integrated
>>>circuit
>>>>and between multiple integrated circuits), all of them shall have
>current
>>>state
>>>>of the source or output.
>>>>Pins still need to be shared same as they would be inside of one
>>>synchronizer
>>>>chip.
>>>
>>>Do I understand correctly that you connect one synchronizer output to
>>>the input of the second synchronizer chip?
>>
>>No, I don't recall such use case. At least nothing that needs to exposed
>>in the DPLL subsystem itself.
>>
>>BR,
>>Arkadiusz
>>
>>>
>>>>
>>>>BR,
>>>>Arkadiusz
