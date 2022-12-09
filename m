Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3965647B0D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLIA45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIA44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:56:56 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16005A5076;
        Thu,  8 Dec 2022 16:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670547416; x=1702083416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+TnYWR1vfJPRJy7qfuOEcSrjnnG8s1YlmitUda7kIpQ=;
  b=Un4RIkIfebi+f6OWY0eZE3xzm4WgNRaUHSGfCiv1fbWKS7VwK+31eEHR
   OIXGb36fOAPXVKRqrYyaqYKKD5MIp7QaY926b74GDBx4+v8mMcd9GD6S4
   azJ41TsRqUZDd+qvyujiOZ5Xf+CzYNVqlhR9gRzD+jLZgJPm3IpaPyYpP
   7rKo1PyuFJFSV4FFZHjEzAtYD/AY+8CpLarop9uMluG/Zihw7ei75et6n
   50ZIT3h6mGR66gse1O+CqPvegIyGrOW2D7uqfeSEN8AKRLJvAkrxkhUre
   xoqhCZcttHofs/404KfdgE2VmImXHMd2gxl9q1OuMYrbpixXz3dA/iJ7E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="304990068"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="304990068"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:56:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="710706437"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="710706437"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 08 Dec 2022 16:56:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 16:56:54 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 16:56:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 16:56:54 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 16:56:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAPs/VHFg7W+2GmxL8yOHycYCWBJmb+AwuPdzOsJvW61nQcCGIwygaDG7Pd8EaLx/CEhWCXx/AjSgj8cZFvVTt2BFelRQ8tIL9P/VKnLnV/AscYF8vB98BWflMEoaYWRZ7R8dq8fKj+FYv63PKFcoGfMLNkdQSewso9NBVKhbQGCDlYTBbNAsWkz4UQAFZlkS5sSeH0FIy2WBOGg46Nef4Ujos7TFLPw3c1jTb0jwRV1QpmNjD+QblYOPWUcJ9BJjcOhoBlIxyp2D8oorxrEWTBFpzEbJR66sgTlZz1n+59LUzfxYBGrnYrSI+Hix4bYul/co7NQQigiDqABLYMNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXLYErO8ozVOeddtjlNbZZ2vWuOxLa/fuciEfJnbAVU=;
 b=O7JJe60dIF+AJ7yT9dnMW5YLZe1Ox14grvP2z5QyRgLkPrrxv8GuSiehf8URXu97aA7NHcnLxOgeZwIMd0LNbHyJ9MBS6NA2V76ZWmfioeIrhNJOXpSWNcU3E/OyENa0fg4nXDrwOr7wArXK8mcqFoQTptQyqsgu+KT56aI2ZA21C0G19BpA/p6geOKvx7q6yPtN97Ek6t7D4W5X9jXcC0mUo0QGpy31mxVBysUIq+31EdVUQj+TEZzBFjadaZA+2BxewsvC3yWeoKc1v71h7aF8DTDezdvvNSeOHE6G8H6puIuv7+UTNi4RlRYc8IWyZo3RpRkOENG06XNO+MrdaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 MN2PR11MB4520.namprd11.prod.outlook.com (2603:10b6:208:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 00:56:47 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 00:56:47 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "netdev.dump@gmail.com" <netdev.dump@gmail.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAG+ucAgAC+YICAAJp7gIAAyxiAgADc/oCAAAQyUA==
Date:   Fri, 9 Dec 2022 00:56:47 +0000
Message-ID: <DM6PR11MB4657B5EA8DBC50E9852EF2929B1C9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>   <20221206184740.28cb7627@kernel.org>
        <10bb01d90a45$77189060$6549b120$@gmail.com>
        <20221207152157.6185b52b@kernel.org>    <Y5HKczFwRnfRVtnR@nanopsycho>
 <20221208163949.3833fe7b@kernel.org>
In-Reply-To: <20221208163949.3833fe7b@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|MN2PR11MB4520:EE_
x-ms-office365-filtering-correlation-id: 19be3b91-5306-4bbd-9fff-08dad9803faa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwAlZoHXZld0GcgzfL9kimIe1PHSr/zrEyoMHxtl2mWojqrPBTbVf/X9rbH+13AciV1ljrgvReHMJQZXTkANdv8/ZNr+9XtR3z8kp7G397XaRLdLhqD+GtVq3KTLAzFiJWHFmTjw2MVQtmaZFOFkYmS2Sx3Coy/VP/OTisIM/dTMk44o4DDwS+UtjKmwaWsZY4B9+PDBLwKHZn/DlscMBCnmTDkEtH6mCDEf0d+fIuQFrkrJ3+2fzHg2DumQtJndzeI94Dpj5z9aN3NOv1NfVe3S0wFb0OLU404RLHPJU3Y18FovsmQYBRhr2kvGMAUITEchBNK/1F8KdcpehePYNtheCZ2tvDKM/DLyAgpf1zRJ9N8AVrCP2qiPxRuxesSkhNjVoSqwsat0oaEoX+t68cW1OAqBW9K8Y2VLuX5Dp1Cv6z2ZwkcFcqp2j4FG3srvh9nUQ7YlkazR2wPrksaI1lRKdp42uRKj6TXaUkDZugm+bIBBmi2iIMVDJXJ+LObjfRvJacupbhOKPmEsnO2s6o68p3SLkcGMy55PXw2HDc5185P54NUtdIOI9unIXl5KMAz6gZLndnqrukAklfjX0Qy3+lJ+vuFwpAHR5eIqp4l8T/+e/TUhUAhBKWH10ioi/Xm8+YCxUEeB6NsDhdbytHkStrXrNaZu1QHKQxAMn5efvYyih0b4wNXOEUeOf11WC2jjSNJSceYUu2EqzTiBoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(41300700001)(38100700002)(82960400001)(186003)(2906002)(8936002)(5660300002)(122000001)(478600001)(38070700005)(52536014)(6506007)(7696005)(66946007)(71200400001)(66556008)(9686003)(66446008)(86362001)(8676002)(64756008)(66476007)(76116006)(26005)(55016003)(54906003)(110136005)(33656002)(316002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2pIokAmHAbln3ZzD/Zt/3CQCNOTqUrtYJp6IHa7U6gWgcD0z7o4PkWzSkMrh?=
 =?us-ascii?Q?jWgeax/vVRHe1X0/f39AC3Ko4C/PcPIFk/uHz/dqnd0iEUnszipo0+rLd48Y?=
 =?us-ascii?Q?AohREZsw3omk2vO6Ruqc5lKpVJZNvsDTlmZYX6J8pnNnqfLRR0eArF2Q3Vt+?=
 =?us-ascii?Q?ruMjK/FOe3YzSMIY6zPv4Tqd2wfEFDD3NA1ZnFlz3/AvIYvfVMpilMweOZtD?=
 =?us-ascii?Q?cyTeykJg4jayMkeQWy49DKUyX2eYtuaXRAY/2DKKHvG0YdElIj6U2xKfZW+h?=
 =?us-ascii?Q?vI9Yicv0+bipWGngyAMZqbDIHidltWKs2ORs2JOE0j/Sylccr/wpyzorBhsn?=
 =?us-ascii?Q?w9u5cFuN/fZu8AyrtFlO+xAJP+trZ3HW/fCnwRVk72e96Jz5yJtWbq6mS9zu?=
 =?us-ascii?Q?aEuUgPrAm2ZGqRrCTffWT3WLSFi7r5QIRr0J9uc4FrV1Gy0M8a+OJczEnylL?=
 =?us-ascii?Q?6P+kfTMX90jxvOE1owYpceFI9F5KLRVJl5MDQ6ju4Ui6rFpkR642gX4jmzH7?=
 =?us-ascii?Q?raQpYhB6eyNNWrgw1Rn6Wy3b78C6aBqAezv41fQjqUGj5OBANtRrCSzZnQA8?=
 =?us-ascii?Q?kHjhXIhP5CP1sOfe+XxLAhuqL44rMHz6PITFaniQd18Lxleje1OPXoZMwzdB?=
 =?us-ascii?Q?kD0HDUOsBiis0BkXipcZtKC2w+71UH+s7h+aZDP8kEvixXSdlfOQEYloifRn?=
 =?us-ascii?Q?Juuj/A1DUcdOBCRWuTmXjzaOmh5n0PJU0dhidP/7/TvxPSnbvCAIMGP+Eo80?=
 =?us-ascii?Q?/9Qdg22eBwTOWOspOgXThPRf8U1xGGBAlh5aF4yT0vQ44dYx3wa6G7AJVe22?=
 =?us-ascii?Q?MFvsNleYgVsxPIpWnXDgK+9ufbhXijOVUPGYAgBbuVKA7yE3NAmZS3doCemr?=
 =?us-ascii?Q?BANiBndDd17KC6XP4+h/JXibHJBHlX3Qo161ROrI4u2LrdN5zFnid/lBViCH?=
 =?us-ascii?Q?UMBKFBmcuxshtpsCUoq+QHXMADzPfngDAv6c1hNyNRzNE4FwJVBItdxme38a?=
 =?us-ascii?Q?oBbUvoiLOap98Mtd4uz/p64UQrtUNH4nkCeAuWDPYgBU3FMEf4XY/cP43B/S?=
 =?us-ascii?Q?9/JIHTsDZlQb8NmHlTqdmNuh7bUYxys8UCfnAjrwUD7MTp1TDO/fqrx1Fqr3?=
 =?us-ascii?Q?yzgKP6Afk1atn95CdTXajp55o4GplmUSLxkK6514btIQsKz2sH21y7XJvJJm?=
 =?us-ascii?Q?fFRULT6wkYTPx4idcZtx3XBox/clvGEYhBzQy2VBcy354FIj1cTAq/ahfHk4?=
 =?us-ascii?Q?3WwcbqZwDC41Pf7nlz+vDNwT6GucItNsbsxScRcY5953RG9ayPIHd0S1lF7F?=
 =?us-ascii?Q?ZTmfIjKDTi9RTFCDrVLRVU3iv21Np6UrQP67u3RPJupPlw5z0dPY3MlMBwJd?=
 =?us-ascii?Q?ZQLebWIK28lY5VvtiFUEQifLlCjFInyQ0KGE3uWKU6Ifj1ILhLYZAtmqbzmn?=
 =?us-ascii?Q?GUwZP5ddVrJtD+RvEtNgS/YGDxcSN83IFnKQO4x7e1Ogzqu/P7ASK0yLCLOK?=
 =?us-ascii?Q?qMttbabUtrUvF84dmfTioVVRGPrOHaANQAbTwnWaAqqhLrCyIBdCww0k7rnZ?=
 =?us-ascii?Q?0AQlXTvC84gvT41uhfcNY6+lkf81/sKCFQ3a2Hi0KaPMEhzqX64u8Hz+jAqh?=
 =?us-ascii?Q?gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19be3b91-5306-4bbd-9fff-08dad9803faa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 00:56:47.2895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fpNZ+8HrX6tzcE9/Cbgtk+gODsS9CuKNlXOKBy/naRJm+ejZg2d+pgkuiU4CgA0RhaqNZyEWCzYnqKO15FU6dKf6fV99I7c/AWxh8/fvags=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4520
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

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, December 9, 2022 1:40 AM
>On Thu, 8 Dec 2022 12:28:51 +0100 Jiri Pirko wrote:
>> >I think we discussed using serial numbers.
>>
>> Can you remind it? Do you mean serial number of pin?
>
>Serial number of the ASIC, board or device.
>Something will have a serno, append to that your pin id of choice - et
>voila!

Right now, driver can find dpll with:
struct dpll_device *dpll_device_get_by_cookie(u8 cookie[DPLL_COOKIE_LEN],
                                              enum dpll_type type, u8 idx);=
=20

Where arguments would be the same as given when first instance have allocat=
ed
dpll with:
struct dpll_device
*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
                   const u8 cookie[DPLL_COOKIE_LEN], u8 dev_driver_idx,
                   void *priv, struct device *parent);

Which means all driver instances must know those values if they need to sha=
re
dpll or pins.

Thanks,
Arkadiusz

>
>> >Are you saying within the driver it's somehow easier? The driver
>> >state is mostly per bus device, so I don't see how.
>>
>> You can have some shared data for multiple instances in the driver
>> code, why not?
>
>The question is whether it's easier.
>Easier to ensure quality of n implementations in random drivers.
>Or one implementation in the core, with a lot of clever people paying
>attention and reviewing the code.
>
>> >> There are many problems with that approach, and the submitted patch
>> >> is not explaining any of them. E.g. it contains the
>> >> dpll_muxed_pin_register but no free counterpart + no flows.
>> >
>> >SMOC.
>>
>> Care to spell this out. I guess you didn't mean "South Middlesex
>> Opportunity Council" :D
>
>Simple matter of coding.
