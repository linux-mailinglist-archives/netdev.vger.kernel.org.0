Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D68E647977
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLHXGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiLHXF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:05:57 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F34998950;
        Thu,  8 Dec 2022 15:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670540753; x=1702076753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N2iec6QCJ9y17+j+vitCPJgEW/akn5gs3oGd+RCWkOw=;
  b=SC/mF4lEmYtlhFmucmmsFy2g/7CBfhak1prsr22BwfSyJ1The2/0+Fnt
   Y+I1CXHIEnZiyeGNJQVMV8JkvqfTzRcMQR8IGiLQhZVr9O4S/JiIfyvll
   PtrE6VuIq0fxWv98mmUKTWmvNTUxaX6g+QgFrp+w/8k8Yzo6ly8UyU2/h
   GswJBy3k+ja8ubTFcNl267Wro52mpF/M/ylDqzQcPR/O1a976o1GkRic8
   kbcvjeBBRwVh4Dk5NOKUMF5yiRaVP6m29yaDewK8I4RxI3Gmtdlmvyjrw
   ceTPaA8tSE5IXBBx1C0g4dF8e++Xqn2aZEWKkahxv39bNkN6MGeijFxoE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="297008522"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="297008522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:05:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677942855"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677942855"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 08 Dec 2022 15:05:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 15:05:46 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 15:05:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 15:05:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 15:05:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCd7Z4nd00zERf6OdcQtD/GYCAxOnspEtY06L1Q3CzQKCTCGjEyQlLGQLIFPlKf6O7216vA+E461i/blIDsEnp9KVujxChUr/YIYUoCGttDEluVyJRyaIr0vWArQUji+BNW8dfVVJJlK8HL9aUxVAzxi3E0olm8ZArhSaRoOopgVl0HCbFF1YofIeP5xPJTLEblYWNUBkQfr29Yg8BBNDSERvEYZT0mYG4oeFlV1fptUodcqfdc4Oz5UfHKowbpdezgVMdFVgGHWgGVrRZUT345+ifzuFcL36ulBvAHG8Be5gZ34bTTb9kyxKWrgEjJqw5I2TvacTciSdddwuPZ8IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaDWTGdw5dDu8lLyiv/chTM0/1no4kcRvZtLl2+YxPk=;
 b=gWcdrmUiG6q+TC+Fdgr82lUae28NwR0xtxiE8tGXH3iI4zWQPXmg4Mkuv6Hb2NVksDEJqFoflK62Z/BVnZg7tusjpC3Q7jABkndakcUG82vs5U/TKeREoa4k4SOjN/8a/Rs2fO3wo3CNG6rwCUy+60aCvj62GzbmmKASUlkspy1+7eyRZ1hDg5W+PLU2QaxWInyx3stau/q8b7T0nTk+5tSXoRZPjVMpl5t55QW3Wua6k9P5lzY162bRprxU1kF6lp4VpbH1XCQYBztXKN7rcFlrc0pSPHpnzLs4uLxuX1UE0wMrZG2PL1BF307yF1UOPUX7pUgu4eCija6BUHSMzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA2PR11MB4778.namprd11.prod.outlook.com (2603:10b6:806:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 23:05:44 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 23:05:43 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAIYWlQgADFyYCAAKp/IA==
Date:   Thu, 8 Dec 2022 23:05:43 +0000
Message-ID: <DM6PR11MB4657D2286838A5A287D20D3F9B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <DM6PR11MB4657E9B921B67122DC884A529B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y5HRc+B2s4APZ2n2@nanopsycho>
In-Reply-To: <Y5HRc+B2s4APZ2n2@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA2PR11MB4778:EE_
x-ms-office365-filtering-correlation-id: 7196913e-a22d-47ad-47f2-08dad970bbcc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SbTR3iillyjHI68hRGxKAK9k+ekEm7scA74m8sQD5AuehMtdaCpLb/cx3Hsm4Pb+xCk8Gd8vJFt8qaplraE2Km+lr8INtJZdppXuYEfTAWP0xrFBVa3pQnXEPs50ohLaeTppZG2uCAyJiNdaWGBxkT5oHrgEMacXtn+RjU1f5AlA4bkhWsghdtM/MR7fhYhLqItogcZziz8pw2VLp2DrKTl7ddHrHZ28lJfbt+gyeymfV7MrukrRnpVPPgtA4bleKIBme+SFdmT/8NS4I2RvHvO8w5QSFWcQOD6PsVuQLOddz1LwXOaDuCoKX9VJQWBwlGTT6PP+MOCRehIgNGzYswxj4sgaZZpOshnEAAuo8kjrUKHlbh0lh2C6c93XLDeswlZhcR4yHS2rKg100eQk7GDR/KoNwremaItC9y3ycv4UjNBZq+cb2hcPPh/kwHxIUB9SyOyko75wcKsI3YtiLgddLtB0vwpshZvuPpdEeAVoAHNSm9Pc7CCp3AFScvGCmDgIS5wIrNU9jITq+Ntq5d2V45QdzzIQ8gUWj+1s28vjdZDErfKerU226hvrjOy4n3IWgqOqY06ZoCnBVDFGlUlL+hQ8RN5WnGsxfD7duPloBlm1QHXahqcLJDFj+JM57MecynsrTuE3de5LUqk2Q64lhyxQywC4/CDn7bt/RQKqTdHq0An7Vcxk5JIlbhsSmjjOb9Qub2mhyA5y1cuISA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(38100700002)(122000001)(2906002)(82960400001)(52536014)(26005)(54906003)(83380400001)(8936002)(316002)(38070700005)(55016003)(9686003)(6916009)(7696005)(6506007)(478600001)(30864003)(71200400001)(5660300002)(186003)(33656002)(76116006)(86362001)(66556008)(4326008)(8676002)(66446008)(41300700001)(66476007)(66946007)(64756008)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G8Yla/N/dpcE3nHoooSXcgQh7jvSLPX+91uyOFThk33T9cFP+EqU+x/APj6d?=
 =?us-ascii?Q?IM6TrR3YCnzLIotneUH488HUdW5vVtflq/xfiUEnPMPoVF0ueSCq9Pg73HkN?=
 =?us-ascii?Q?2ggzHkvKPNDtdSq4m7Ek/Yv1FFP3805OWR4fO6A6y1lDcS5yc+gtsLFIoJnh?=
 =?us-ascii?Q?fRCqfrU1OWlMgJukcFGz5+1yMm2EV5BwlcZul/wfQ4nv0q42lcq+aJXDzZb6?=
 =?us-ascii?Q?4G+bzJqBPFVA38yf0k654tKuSfCkMggL+WI3fCxU29/7AgDkuoC6xqC+Su7C?=
 =?us-ascii?Q?tmqAb0XsT9+5WoK8XGhp30aZj1Pt8y6knnZoGo07MFIhM1ikxv0bwsqf/D32?=
 =?us-ascii?Q?cPrw74PU20IMrTxt8BMHrUy2JssbjM+22vGZKz1kSmQuiLCMMXh48jhwlIex?=
 =?us-ascii?Q?HBq8rVJK0aPezelLRja7sKOaTRLDRRIdT848Gm+JrF8wlKD9rZUpZGQUHpoX?=
 =?us-ascii?Q?v+8ITcAJCO7D+hOcvFkZrdFTJlehbeCHIeacwh2/G/rdG7uC8RM1C9rZO1SE?=
 =?us-ascii?Q?/tst98RZAz1ixnM1bpFDgEz5CiTAlIWms0Kuze2u3Jm5l8n42GrU8pw73fv7?=
 =?us-ascii?Q?pNFXHoMhs8e+8CwD3mf7Z8w7wX73vGRb+Dvbzrmn3SMwYzLWeLvUw1MjORL5?=
 =?us-ascii?Q?jCAl40dR4PArcOx9B5d6CzcbW5JorN6OdGY94IWdGhKTuSQhvBQ7PiFaVuHW?=
 =?us-ascii?Q?PwbgIyjrFruWSulcwFc192RudYbCbIXOU5oKrWMb6FiSlWaRMyPWJY0Xnz6J?=
 =?us-ascii?Q?rwHpVOTTFNDevpcuiqLxzIL5RMzX0Ph9CIa9roCY8W3b6aBPIwJAE52XkzF/?=
 =?us-ascii?Q?yLGdiFZwdDMgGvj/sL5rwqaQlGc9CnlM4w88KO8obPMgoYuW8g/Czy1Z+MKi?=
 =?us-ascii?Q?enSWE0gG7MA4uTh3IUTZvukaFVJC02kP6BwYJT/fZL4OAjSRKu3+4FIMgOrh?=
 =?us-ascii?Q?y+Ew0a+/z8UALKqVknnoC1VLjBfPpojwu1cOjtdcGea3Ku70bm7YoUFUXX+V?=
 =?us-ascii?Q?zN6BcZpZFO/E9HH4DWMxnmUCrVdDuifvkja+WM2pnA1kdLixL2jW1GyYnyz0?=
 =?us-ascii?Q?i9Ijapzk3/TCPi7W73bwk16277JiL3KQPW3bGml3k/b9sUexM3lKPNo6P1YW?=
 =?us-ascii?Q?uN9Zbrvqre7yf7S5HXCse/1GA/mi/vPxywod27d9ZHbskdcJG7STQ/+8NAJF?=
 =?us-ascii?Q?9yfCH0xqcCvc5T/MtcVAmDLKoBfOAua10zImyHUUiEVq7LBNVlg7KLrBfb+d?=
 =?us-ascii?Q?Vcx6JtwWtGNArOVo+K0NGt9y55CC5FNAgvGryvquzDAG2M6c0nDcAh0P25d5?=
 =?us-ascii?Q?aoMUiRsKgbz7nclYmlEKol+uRNHJ3d22Mg51r5AUA6UEMnsl9Nfdp4skCyNU?=
 =?us-ascii?Q?PiBhPm74aTq29+GXBf96vUt1aC5Hl+J7AQV2nr1mWL870Yb5xq15O2qARc/0?=
 =?us-ascii?Q?cSy/ep6JulXQlbmHOulKNtjZaWhvzSGf4zADa6BdiXkAAeB/deMj7Bm9hmeD?=
 =?us-ascii?Q?SFVlqRQkQIq4t9Uzgu1d+uifmSfrbyoU824aQvPHTtAM8Vu0I+5gkQIOzp0r?=
 =?us-ascii?Q?0WMxvR1BeJBtWwnLPiAFFJ7H6V98WkI9KHRcbsF1JeyIaVbxsnxm2MjAQ5Fe?=
 =?us-ascii?Q?nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7196913e-a22d-47ad-47f2-08dad970bbcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 23:05:43.6325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0E13RdLIGvgOT1Bbo3FhYZgFICZh/gJ0VKlXkLV6hiNbWYDtn7tOXlX6U6m6+kqtLuXre7ORSWg9bLK3bEUPWkUhuVjmS2QR+KVqPhrRrKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4778
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, December 8, 2022 12:59 PM
>
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Friday, December 2, 2022 5:12 PM
>>>
>>>Fri, Dec 02, 2022 at 12:27:24PM CET, arkadiusz.kubalewski@intel.com
>wrote:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Wednesday, November 30, 2022 1:32 PM
>>>>>
>>>>>Tue, Nov 29, 2022 at 10:37:20PM CET, vfedorenko@novek.ru wrote:
>>>>>>Implement common API for clock/DPLL configuration and status
>reporting.
>>>>>>The API utilises netlink interface as transport for commands and even=
t
>>>>>>notifications. This API aim to extend current pin configuration and
>>>>>>make it flexible and easy to cover special configurations.
>>>>>
>>>>>Overall, I see a lot of issues on multiple levels. I will go over them
>in
>>>>>follow-up emails. So far, after couple of hours looking trought this, =
I
>>>>>have following general feelings/notes:
>>>>
>>>>Hi Jiri,
>>>>
>>>>As we have been participating in last version, feel obligated to answer
>to
>>>>the concerns.
>>>
>>>Cool.
>>>
>>>
>>>>
>>>>>
>>>>>1) Netlink interface looks much saner than in previous versions. I wil=
l
>>>>>   send couple of notes, mainly around events and object mixtures and
>>>>>   couple of bugs/redundancies. But overall, looks fineish.
>>>>>
>>>>>2) I don't like that concept of a shared pin, at all. It makes things
>>>>>   unnecessary complicated. Just have a pin created for dpll instance
>>>>>   and that's it. If another instance has the same pin, it should
>create
>>>>>   it as well. Keeps things separate and easy to model. Let the
>>>>>   hw/fw/driver figure out the implementation oddities.
>>>>>   Why exactly you keep pushing the shared pin idea? Perhaps I'm
>missing
>>>>>   something crucial.
>>>>
>>>>
>>>>If the user request change on pin#0 of dpll#0, the dpll#0 knows about
>the
>>>>change, it reacts accordingly, and notifies the user the something has
>>>changed.
>>>>Which is rather simple.
>>>>
>>>>Now, if the dpll#1 is using the same pin (pin#0 of dpll#0), the
>>>complicated
>>>>part starts. First we have to assume:
>>>>- it was initialized with the same description (as it should, to preven=
t
>>>>confusing the user)
>>>>- it was initialized with the same order (this is at least nice to have
>>>from
>>>>user POV, as pin indices are auto generated), and also in case of
>multiple
>>>pins
>>>>being shared it would be best for the user to have exactly the same
>number
>>>of
>>>>pins initialized, so they have same indices and initialization order
>>>doesn't
>>>>introduce additional confusion.
>>>>
>>>>Thus, one reason of shared pins was to prevent having this assumptions
>>>ever.
>>>>If the pin is shared, all dplls sharing a pin would have the same
>>>description
>>>>and pin index for a shared pin out of the box.
>>>>
>>>>Pin attribute changes
>>>>The change on dpll#0 pin#0 impacts also dpll#1 pin#0. Notification abou=
t
>>>the
>>>>change shall be also requested from the driver that handles dpll#1. In
>>>such
>>>>case the driver has to have some dpll monitoring/notifying mechanics,
>>>which at
>>>>first doesn't look very hard to do, but most likely only if both dplls
>are
>>>>initialized and managed by a single instance of a driver/firmware.
>>>>
>>>>If board has 2 dplls but each one is managed by its own firmware/driver
>>>>instance. User changes frequency of pin#0 signal, the driver of dpll#0
>>>must
>>>>also notify driver of dpll#1 that pin#0 frequency has changed, dpll#1
>>>reacts on
>>>>the change, notifies the user.
>>>
>>>Right.
>>>
>>>
>>>>But this is only doable with assumption, that the board is internally
>>>capable
>>>>of such internal board level communication, which in case of separated
>>>>firmwares handling multiple dplls might not be the case, or it would
>>>require
>>>>to have some other sw component feel that gap.
>>>
>>>Yep, you have the knowledge of sharing inside the driver, so you should
>>>do it there. For multiple instances, use in-driver notifier for example.
>>>
>>
>>This can be done right now, if driver doesn't need built-in pin sharing o=
r
>>doesn't want it, it doesn't have to use it.
>>It was designed this way for a reason, reason of reduced complexity of
>drivers,
>>why should we want to increase complexity of multiple objects instead of
>having
>>it in one place?
>
>Nevermind, don't want to repeat myself. Looks like everyone wants this
>pin sharing infra in the core, let's now focus on designing it properly.
>
>
>>
>>>
>>>>
>>>>For complex boards with multiple dplls/sync channels, multiple ports,
>>>>multiple firmware instances, it seems to be complicated to share a pin
>if
>>>>each driver would have own copy and should notify all the other about
>>>changes.
>>>>
>>>>To summarize, that is certainly true, shared pins idea complicates stuf=
f
>>>>inside of dpll subsystem.
>>>>But at the same time it removes complexity from all the drivers which
>>>would use
>>>
>>>There are currently 3 drivers for dpll I know of. This in ptp_ocp and
>>>mlx5 there is no concept of sharing pins. You you are talking about a
>>>single driver.
>>>
>>>What I'm trying to say is, looking at the code, the pin sharing,
>>>references and locking makes things uncomfortably complex. You are so
>>>far the only driver to need this, do it internally. If in the future
>>>other driver appears, this code would be eventually pushed into dpll
>>>core. No impact on UAPI from what I see. Please keep things as simple as
>>>possible.
>>>
>>
>>The part of interface for drivers is right now 17 functions in total, thu=
s
>I
>>wouldn't call it complicated. References between dpll instances and pins,
>are
>>other part of "increased" complexity, but I wouldn't either call it
>>over-complicated, besides it is part of dpll-core. Any interface shouldn'=
t
>make
>>the user to look into the code. For users only documentation shall be
>important.
>>If kernel module developer is able to read header and understand what he
>needs
>>to do for his hardware, whether he want to use shared pins or not, and
>what
>>impact would it have.
>>
>>Thus real question is, if it is easy enough to use both parts.
>>I would say the kernel module part is easy to understand even by looking
>at
>>the function names and their arguments. Proper documentation would clear
>>anything that is still not clear.
>>
>>Netlink part is also moving in a right direction.
>>
>>>
>>>>it and is easier for the userspace due to common identification of pins=
.
>>>
>>>By identification, you mean "description" right? I see no problem of 2
>>>instances have the same pin "description"/label.
>>>
>>
>>"description"/label and index as they are the same pin. Index is auto-
>generated
>>and depends on initialization order, this makes unnecessary dependency.
>>
>>>
>>>>This solution scales up without any additional complexity in the driver=
,
>>>>and without any need for internal per-board communication channels.
>>>>
>>>>Not sure if this is good or bad, but with current version, both
>approaches
>>>are
>>>>possible, so it pretty much depending on the driver to initialize dplls
>>>with
>>>>separated pin objects as you have suggested (and take its complexity
>into
>>>>driver) or just share them.
>>>>
>>>>>
>>>>>3) I don't like the concept of muxed pins and hierarchies of pins. Why
>>>>>   does user care? If pin is muxed, the rest of the pins related to
>this
>>>>>   one should be in state disabled/disconnected. The user only cares
>>>>>   about to see which pins are related to each other. It can be easily
>>>>>   exposed by "muxid" like this:
>>>>>   pin 1
>>>>>   pin 2
>>>>>   pin 3 muxid 100
>>>>>   pin 4 muxid 100
>>>>>   pin 5 muxid 101
>>>>>   pin 6 muxid 101
>>>>>   In this example pins 3,4 and 5,6 are muxed, therefore the user know=
s
>>>>>   if he connects one, the other one gets disconnected (or will have t=
o
>>>>>   disconnect the first one explicitly first).
>>>>>
>>>>
>>>>Currently DPLLA_PIN_PARENT_IDX is doing the same thing as you described=
,
>>>it
>>>>groups MUXed pins, the parent pin index here was most straightforward t=
o
>>>me,
>>>
>>>There is a big difference if we model flat list of pins with a set of
>>>attributes for each, comparing to a tree of pins, some acting as leaf,
>>>node and root. Do we really need such complexicity? What value does it
>>>bring to the user to expose this?
>>>
>>
>>If the one doesn't need to use muxed pins, everything is simple, as you
>have
>>described. In fact in the example you have given, only benefit I can see
>from
>>muxid is that user knows which pins would get disconnected when one of th=
e
>mux
>>group pins is selected. But do user really needs that knowledge? If one
>pin
>>was selected why should he look on the other pins?
>
>Right. That would be probably valuable only for output pins.
>
>
>>
>>Anyway I see your point, but this is not only about identifying a muxed
>pins,
>>it is more about identifying connections between them because of hardware
>>capabilities they can bring, and utilization of such capabilities.
>>Please take a look on a comment below.
>>
>>>
>>>>as in case of DPLL_MODE_AUTOMATIC, where dpll auto-selects highest
>>>priority
>>>>available signal. The priority can be only assigned to the pins directl=
y
>>>>connected to the dpll. The rest of pins (which would have present
>>>>attribute DPLLA_PIN_PARENT_IDX) are the ones that require manual
>selection
>>>>even if DPLL_MODE_AUTOMATIC is enabled.
>>>>
>>>>Enabling a particular pin and sub-pin in DPLL_MODE_AUTOMATIC requires
>from
>>>user
>>>>to select proper priority on on a dpll-level MUX-pin and manually selec=
t
>>>one of
>>>>the sub-pins.
>>>>On the other hand for DPLL_MODE_FORCED, this might be also beneficial,
>as
>>>the
>>>>user could select a directly connected pin and muxed pin with two
>>>separated
>>>>commands, which could be handled in separated driver instances (if HW
>>>design
>>>>requires such approach) or either it can be handled just by one select
>>>call
>>>>for the pin connected directly and handled entirely in the one driver
>>>instance.
>>>
>>>Talk netlink please. What are the actual commands with cmds used to
>>>select the source and select a mux pin? You are talking about 2 types of
>>>selections:
>>>1) Source select
>>>   - this is as you described either auto/forces (manual) mode,
>>>   according to some prio, dpll select the best source
>>>2) Pin select in a mux
>>>   - here the pin could be source or output
>>>
>>>But again, from the user perspective, why does he have to distinguish
>>>these? Extending my example:
>>>
>>>   pin 1 source
>>>   pin 2 output
>>>   pin 3 muxid 100 source
>>>   pin 4 muxid 100 source
>>>   pin 5 muxid 101 source
>>>   pin 6 muxid 101 source
>>>   pin 7 output
>>>
>>>User now can set individial prios for sources:
>>>
>>>dpll x pin 1 set prio 10
>>>etc
>>>The result would be:
>>>
>>>   pin 1 source prio 10
>>>   pin 2 output
>>>   pin 3 muxid 100 source prio 8
>>>   pin 4 muxid 100 source prio 20
>>>   pin 5 muxid 101 source prio 50
>>>   pin 6 muxid 101 source prio 60
>>>   pin 7 output
>>>
>>>Now when auto is enabled, the pin 3 is selected. Why would user need to
>>>manually select between 3 and 4? This is should be abstracted out by the
>>>driver.
>>
>>Yes, this could be abstracted in the driver, but we are talking here abou=
t
>>different things. We need automatic hardware-supported selection of a pin=
,
>>not automatic software-supported selection, where driver (part of softwar=
e
>>stack) is doing autoselection.
>>
>>If dpll is capable of hw-autoselection, the priorities are configured in
>the
>>hardware, not in the driver. This interface is a proxy between user and
>dpll.
>
>Okay, this is very nice example, where the confusion appeared. Looking
>into your code, function dpll_pin_attr_from_nlattr(), it clearly allows
>userspace to set the prio over DPLLA_PIN_PRIO. Yet you claim the prio is
>configured in the hardware.
>

Yes, userspace is requesting this configuration in hardware. It doesn't
change anything, the hw-supported auto-selection works only on the source p=
ins
connected directly. Mux-type pin can have priority assigned by the user and
still need to select one of multiple pins associated with it.=20

>
>>The one could use it as you have described by implementing auto-selection
>>in SW, but those are two different modes, actually we could introduce
>modes
>>like: DPLL_MODE_HW_AUTOMATIC and DPLL_MODE_SW_AUTOMATIC, to clear things
>up.
>>Although, IMHO, DPLL_MODE_SW_AUTOMATIC wouldn't really differ from curren=
t
>>behavior of DPLL_MODE_FORCED, where the userspace is explicitly selecting
>a
>>source, and the only difference would be that selection comes from driver
>>instead of userspace tool. Thus in the end it would just increase
>complexity
>>of a driver (instead of bringing any benefits).
>
>Yeah, does not make sense to have DPLL_MODE_SW_AUTOMATIC as you describe
>it. I agree.
>
>>
>>>
>>>Only issues I see when pins are output. User would have to somehow
>>>select one of the pins in the mux (perhaps another dpll cmd). But the
>>>mux pin instance does not help with anything there...
>>>
>>>
>>>
>>>>
>>>>>4) I don't like the "attr" indirection. It makes things very tangled.
>It
>>>>>   comes from the concepts of classes and objects and takes it to
>>>>>   extreme. Not really something we are commonly used to in kernel.
>>>>>   Also, it brings no value from what I can see, only makes things ver=
y
>>>>>   hard to read and follow.
>>>>>
>>>>
>>>>Yet again, true, I haven't find anything similar in the kernel, it was
>>>more
>>>>like a try to find out a way to have a single structure with all the
>stuff
>>>that
>>>>is passed between netlink/core/driver parts. Came up with this, and to
>be
>>>>honest it suits pretty well, those are well defined containers. They
>store
>>>>attributes that either user or driver have set, with ability to obtain =
a
>>>valid
>>>>value only if it was set. Thus whoever reads a struct, knows which of
>>>those
>>>>attributes were actually set.
>>>
>>>Sorry for being blunt here, but when I saw the code I remembered my days
>>>as a student where they forced us to do similar things Java :)
>>>There you tend to make things contained, everything is a class, getters,
>>>setters and whatnot. In kernel, this is overkill.
>>>
>>>I'm not saying it's functionally wrong. What I say is that it is
>>>completely unnecessary. I see no advantage, by having this indirection.
>>>I see only disadvantages. It makes code harder to read and follow.
>>>What I suggest, again, is to make things nice and simple. Set of ops
>>>that the driver implements for dpll commands or parts of commands,
>>>as we are used to in the rest of the kernel.
>>>
>>
>>No problem, I think we will get rid of it, see comment below.
>>
>>>
>>>>As you said, seems a bit revolutionary, but IMHO it simplifies stuff,
>and
>>>>basically it is value and validity bit, which I believe is rather commo=
n
>>>in the
>>>>kernel, this differs only with the fact it is encapsulated. No direct
>>>access to
>>>>the fields of structure is available for the users.
>>>
>>>I don't see any reason for any validity bits whan you just do it using
>>>driver-implemented ops.
>>>
>>>
>>>>Most probably there are some things that could be improved with it, but
>in
>>>>general it is very easy to use and understand how it works.
>>>>What could be improved:
>>>>- naming scheme as function names are a bit long right now, although
>>>mostly
>>>>still fits the line-char limits, thus not that problematic
>>>>- bit mask values are capable of storing 32 bits and bit(0) is always
>used
>>>as
>>>>unspec, which ends up with 31 values available for the enums so if by
>any
>>>>chance one of the attribute enums would go over 32 it could be an issue=
.
>>>>
>>>>It is especially useful for multiple values passed with the same netlin=
k
>>>>attribute id. I.e. please take a look at
>>>dpll_msg_add_pin_types_supported(..)
>>>>function.
>>>>
>>>>>   Please keep things direct and simple:
>>>>>   * If some option could be changed for a pin or dpll, just have an
>>>>>     op that is directly called from netlink handler to change it.
>>>>>     There should be clear set of ops for configuration of pin and
>>>>>     dpll object. This "attr" indirection make this totally invisible.
>>>>
>>>>In last review you have asked to have rather only set and get ops
>defined
>>>>with a single attribute struct. This is exactly that, altough
>>>encapsulated.
>>>
>>>For objects, yes. Pass a struct you directly read/write if the amount of
>>>function args would be bigger then say 4. The whole encapsulation is not
>>>good for anything.
>>
>>If there is one set/get for whole object, then a writer of a struct
>(netlink
>>or driver) has to have possibility to indicate which parts of the struct
>were
>>actually set, so a reader can do things that were requested.
>>
>>But I agree this is probably not any better to the "ops per attribute"
>approach
>>we have had before, thus I think we shall get back to this approach and
>remove
>>dpll_attr/dpll_pin_attr entirely.
>>
>>>
>>>
>>>>
>>>>>   * If some attribute is const during dpll or pin lifetime, have it
>>>>>     passed during dpll or pin creation.
>>>>>
>>>>>
>>>>
>>>>Only driver knows which attributes are const and which are not, this
>shall
>>>
>>>Nonono. This is semantics defined by the subsystem. The pin
>>>label/description for example. That is const, cannot be set by the user.
>>
>>True, it is const and it is passed on pin init.
>>
>>>The type of the pin (synce/gnss/ext) is const, cannot be set by the user=
.
>>
>>It can, as input/source can change, thus the same way, type of pin could
>be
>>managed by some hardware fuses/switches/etc.
>
>Could you please describe this a bit more? For example how the user can
>change synce pin to ext pin? I still fail to understand how such thing
>is possible. How the HW could be rewired on user request?
>Perhaps we understand differently the "pin" object. I understand is as
>something out-facing. Not an actual pin of a chip.
>

Sorry, but I don't have any real-life example of it. I don't think someone
would design this as a choice between ext and synce, but hardware design ma=
y
allow user such thing, more likely it would be a pin where the user selects=
 if
it is ext or gnss.

I agree, you are right that this can be modeled with the mux-type pin
instead of changing the pin-type.

Although there is small benefit of reduced complexity of a driver, by allow=
ing
change of pin-type instead of having mux type pin and additional pins
associated with it, I won't insist on any of those solutions.
If there is no other objections we can change dpll_pin_type attribute
to become a const pin init parameter.

>
>>
>>>This you have to clearly specify when you define driver API.
>>>This const attrs should be passed during pin creation/registration.
>>>
>>>Talking about dpll instance itself, the clock_id, clock_quality, these
>>>should be also const attrs.
>>>
>>
>>Actually, clock_quality can also vary on runtime (i.e. ext/synce). We
>cannot
>>determine what Quality Level signal user has connected to the SMA or was
>>received from the network. Only gnss/oscilattor could have const dependin=
g
>>on used HW. But generally it shall not be const.
>
>Sec. I'm talkign about the actual dpll quality, means the internal
>clock. How it can vary?

Yes, the DPLL has some holdover capacity, thus can translate this into QL a=
nd
it shall not ever change. Sure, we could add this.

I was thinking about a source Quality Level. If that would be available her=
e,
the ptp-profiles implementation would be simpler, as ptp daemon could read =
it
and embed that information in its frames.
Although, this would have to be configurable from user space, at least for =
EXT
and SYNCE pin types.

Thanks,
Arkadiusz

>
>
>>
>>Thanks,
>>Arkadiusz
>>
>>>
>>>
>>>>be also part of driver implementation.
>>>>As I understand all the fields present in (dpll/dpll_pin)_attr, used in
>>>get/set
>>>>ops, could be altered in run-time depending on HW design.
>>>>
>>>>Thanks,
>>>>Arkadiusz
>>>>
>>>>>
>>>>>>
>>>>>>v3 -> v4:
>>>>>> * redesign framework to make pins dynamically allocated (Arkadiusz)
>>>>>> * implement shared pins (Arkadiusz)
>>>>>>v2 -> v3:
>>>>>> * implement source select mode (Arkadiusz)
>>>>>> * add documentation
>>>>>> * implementation improvements (Jakub)
>>>>>>v1 -> v2:
>>>>>> * implement returning supported input/output types
>>>>>> * ptp_ocp: follow suggestions from Jonathan
>>>>>> * add linux-clk mailing list
>>>>>>v0 -> v1:
>>>>>> * fix code style and errors
>>>>>> * add linux-arm mailing list
>>>>>>
>>>>>>
>>>>>>Arkadiusz Kubalewski (1):
>>>>>>  dpll: add dpll_attr/dpll_pin_attr helper classes
>>>>>>
>>>>>>Vadim Fedorenko (3):
>>>>>>  dpll: Add DPLL framework base functions
>>>>>>  dpll: documentation on DPLL subsystem interface
>>>>>>  ptp_ocp: implement DPLL ops
>>>>>>
>>>>>> Documentation/networking/dpll.rst  | 271 ++++++++
>>>>>> Documentation/networking/index.rst |   1 +
>>>>>> MAINTAINERS                        |   8 +
>>>>>> drivers/Kconfig                    |   2 +
>>>>>> drivers/Makefile                   |   1 +
>>>>>> drivers/dpll/Kconfig               |   7 +
>>>>>> drivers/dpll/Makefile              |  11 +
>>>>>> drivers/dpll/dpll_attr.c           | 278 +++++++++
>>>>>> drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
>>>>>> drivers/dpll/dpll_core.h           | 176 ++++++
>>>>>> drivers/dpll/dpll_netlink.c        | 963
>+++++++++++++++++++++++++++++
>>>>>> drivers/dpll/dpll_netlink.h        |  24 +
>>>>>> drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
>>>>>> drivers/ptp/Kconfig                |   1 +
>>>>>> drivers/ptp/ptp_ocp.c              | 123 ++--
>>>>>> include/linux/dpll.h               | 261 ++++++++
>>>>>> include/linux/dpll_attr.h          | 433 +++++++++++++
>>>>>> include/uapi/linux/dpll.h          | 263 ++++++++
>>>>>> 18 files changed, 4002 insertions(+), 37 deletions(-) create mode
>>>>>> 100644 Documentation/networking/dpll.rst create mode 100644
>>>>>> drivers/dpll/Kconfig create mode 100644 drivers/dpll/Makefile create
>>>>>> mode 100644 drivers/dpll/dpll_attr.c create mode 100644
>>>>>> drivers/dpll/dpll_core.c create mode 100644 drivers/dpll/dpll_core.h
>>>>>> create mode 100644 drivers/dpll/dpll_netlink.c create mode 100644
>>>>>> drivers/dpll/dpll_netlink.h create mode 100644
>>>>>> drivers/dpll/dpll_pin_attr.c create mode 100644 include/linux/dpll.h
>>>>>> create mode 100644 include/linux/dpll_attr.h create mode 100644
>>>>>> include/uapi/linux/dpll.h
>>>>>>
>>>>>>--
>>>>>>2.27.0
>>>>>>
