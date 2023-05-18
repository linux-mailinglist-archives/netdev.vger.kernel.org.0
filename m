Return-Path: <netdev+bounces-3696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA386708595
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18894281917
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3463F21CFF;
	Thu, 18 May 2023 16:06:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D34D53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:06:18 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D6EEE;
	Thu, 18 May 2023 09:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684425970; x=1715961970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xEVs2P0GlXa52ZFiwl46gmywytYE5XEQsPFaKw60IjE=;
  b=S4LmCsPeotWE1T7m51f1mOhwTqIdKbrk9ZlFnrhZXYx45USRLHBOX+9h
   WWdVPCRbJRQVQXWKHTSslczY29QEyjbSK6OxffSr1RUAKtkYfJUm4FT5v
   XZFY5RzePbItDBkzBMaXZK9DVsZaC4b4YZv8pwq+w0l5GQIH/1cSfbdoJ
   +zFrOBpDXjUJTzDPSFYxpZ96yT2KikwsfGrN1gaV6ckvagjbHyOsocaJn
   S/LHa2F8SZJ1CK+IvrQrdh8I9DQaMcaMc9XMnO0/ChMJ8Kd3fNewrBRne
   mgRLw2Y9GYdM6W4lUy28g6XvUcQaTKMcdeStjIJ5XhN9AYKZKAoSCRdeV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="438453497"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="438453497"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 09:06:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="1032257021"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="1032257021"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 18 May 2023 09:06:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 09:06:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 09:06:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 09:06:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KN0lFYQ1ErIzkzkdlM65NfjLIXIRMDI6Xc6Nqd3hzXpI01LRQIExbyKFgwjHr+2rOR4N5FZRRSWiJ7BHqE7Y9gR+7vJGDrJrj9PeFRNXqoQEyB1SzEi6pfVW66zO+TYpz+iqXBr36C7poNhTnW5fCvbd7Oz9G7yVc+7Ckcn4+Yl3M5KU+/Qkttiqtw1QoRCDF6cwy/T59hE6CfTEsCU+iEcfeaHmGbDKrWWQTR43RTMtneeQdjhJNoSDOuJ5i4cvexJNVMldt+ZKc4O1fa9WEzefRUAFl4lcko3iEr2WeNqt6QA6WXbfIslpIznDar5u/nWIzTnVQnMQTPe79frnSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLDCJbEzxnqITx+i/jCWwkTi6PPHyYCTuvu/grKJQ8s=;
 b=Kz1HJZ/RrxkwisM2yJ0w0WRvT2HnTevaWRmTaCBUmmFCY6lqqpXexrtoHKqVzn7i4MnwiOFDKR5V1y16XGpmrIwhHh+9ZRHe+QD9vQPMPxigd1qQvflkn4Qf8ON1iYcq6spfGulUfnZGczQNIc2CVG7LVTHnyRa/rtlA97VjJJV6JrDrxxm5zo3jN+Am9i0nHmK33zK6k0wMz4aKcf3sK2lSD36kFZ6532Ird+spGd+HPqbvKBp7VyaDH37mjIS/hVcoK0lm90hXzsfXrvDJoSz3dEhVzaBYHMYA57L5mgTw8VqqhMNVqZOHtSD27fhKaWdNcKminmwvuJ1T9bnpIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6746.namprd11.prod.outlook.com (2603:10b6:510:1b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 16:06:04 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 16:06:03 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Index: AQHZeWdQDnOnlwLdVUynBqrraL/3s69If/yAgBOAjACAAItZgIADxo+g
Date: Thu, 18 May 2023 16:06:03 +0000
Message-ID: <DM6PR11MB4657F542DD71F61FD2A1C20B9B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com> <ZFJRIY1HM64gFo3a@nanopsycho>
 <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGMiE1ByArIr8ARB@nanopsycho>
In-Reply-To: <ZGMiE1ByArIr8ARB@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6746:EE_
x-ms-office365-filtering-correlation-id: 56807524-9bee-4cc0-b2c5-08db57b9c7df
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N1QEsnq6stsGoAZUnT0TJIjrr/u86GbKf2dvFp4edi8uEZHhCt/xcHySVL74ipDRd9b+lHC11A/phPXVf23SZQTfJmgCh9i3EKKz++pYp++hK0wYiPM078qKK5ii08fIkp5FYwQnOw7uaV+eGy75yM2w+sUh0gmwZNNXXyojIBColpP2hofDiIs6EEKY153eBZuJfg0sxPHNZlJjw+tLNXjR1lj0kOtzE6biya4jY4ib13HKQyT/08WerBBic2auBd4+oHNhz41TVLveB5E0uqhL1iKHf7lkyiY7HDE8/jecbxGvSAKqbUJAHwvCwIspLfiR287sOSvyMGXvzQ775ZNSFq/DQZddataTns3eW+BeT7+621+1p9unxn8LxBK+fXX5EWMsMx/yt9w+nzbT2qp5+hXytNaFa3qIk5tKG/NGJAUYBCN8bfYKza10iicrIO9HORRnBzpnTMQDwNe1SGl8aJjHrhE0bPiWq9CBsRBf/CM8FO+j1S9cxX9bSXzgxXuTmHlPbgK/vvRqwAKqP87sRgl/tvqdxb9XSrHVROyxiwk7BHUPT8y0tTWNbk2vlpPRohmw9yZ6/MpbDVFSKZPs4P4mKCcNHzjwEAb8MYUdcMByeN7m8HyqtzIYaJaG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199021)(2906002)(7416002)(8936002)(86362001)(8676002)(122000001)(9686003)(83380400001)(66946007)(52536014)(33656002)(478600001)(71200400001)(76116006)(6506007)(54906003)(66556008)(26005)(7696005)(66446008)(186003)(82960400001)(55016003)(38100700002)(38070700005)(5660300002)(66476007)(6916009)(64756008)(41300700001)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FbMoNfk/+gCkWh8yqUssuCLm0ap8kks9BSvUNypGTqyIbBud0sy798fBpKQv?=
 =?us-ascii?Q?xpramGuaTl5JB9oLafMwvaTGRJmhSSkdIywJTQz9QH1RKDSIGLZ8UyvERrA4?=
 =?us-ascii?Q?D+h3A7W7BxB+oO/6dpSHZ1Jssc0nTK/aMpgHMmWOivR48/ygijEAECMettbW?=
 =?us-ascii?Q?2wHRhmXickcqbZeMgmnV5r6no2Jl+ecY/JEGKi9o74MkkUVz1a/vGhiRHTAN?=
 =?us-ascii?Q?PLjjY+CEhV0daDHwCNVfxfv8U0pZmNbTIPJiUGJXrb9pA4LRhnUSauZXymyA?=
 =?us-ascii?Q?fjo2ImHPuzzngcHkXreIinj7cQFpbgiT25pA/13NMYSPFWKBMhmpovjgpj7G?=
 =?us-ascii?Q?HevVYU6JSu4XxJpJN8bvwR+KhXsypP1KsyWMO9ldvtqQZ2eNIgMXZU/kMXr7?=
 =?us-ascii?Q?V4w11YrvvXYsOyN/GD+Zj6u+FgxOe5kjIkmUdJ3ckMq4dvKZJMhSM5btQo/p?=
 =?us-ascii?Q?xN9yo+pvYVhciDuvWEsL8+sLUDCPxfh2xnPIB9942e1ELXDztWqwMCH3slob?=
 =?us-ascii?Q?sGZ/0ADOwn0Qf2lXyMfsz0ufmyj4aUj42XFwCi/zL7VIU0Az2+osDnkJ+zd8?=
 =?us-ascii?Q?uR0JoW9uuB733AjA/Asm2bi9Nadv2aFnqPdhkw5lZSv/iK/knQmeIH1WDG99?=
 =?us-ascii?Q?8RXm6ex3qNVC2HhwtxTUZfSPnRSCpF9AwGran0fS1ecEVoW2srw3qun3T8kW?=
 =?us-ascii?Q?6F+cdfIrcAZgnotc0RiGjLWeJE+0SjMl1yToufdFYj8fVcNOXGG/D3qJ4Fay?=
 =?us-ascii?Q?6o1xWrttiRN2T0ln7e9DyrRzIpL/G8WeAjAVsJ4xPxeI1C7DuTDVOxs90JYa?=
 =?us-ascii?Q?PMy04Exeuvosvf2PqBiUhbt6FfJ15kWx7OJRRdwgxB3nKh0Y/4yjQ9MxhAtl?=
 =?us-ascii?Q?pkHPV5CYmwQmmuk5DfjBn//87Ocpbv1gBWpfqzhjlD0yQKJeuwfmvW/7ceFT?=
 =?us-ascii?Q?T4z7sKz62TA+wIAnU4rYSkefAicVJ2t6CKgwwvDyYpXF1VjKpDcp8fCUAXoM?=
 =?us-ascii?Q?h+7FqEhvb+i4jfrdEVPLCeXoJ4hhppXWj2RuIGZf91pxSaftQG0GzxwBICDc?=
 =?us-ascii?Q?Q3nEO4xxJ/JkzYWnFKNWerVVRStAKr+6OrS59QWPflDXiPCjEgIHJbvPQ/KK?=
 =?us-ascii?Q?RmqkCrxT+iQzJPvsgHKw07xk6YvLcrHtpfBAzc4suiUr/QD+JObOoDX0W1Qy?=
 =?us-ascii?Q?HIvbmJj0GsnQIVhCvmOhQLwdovbS0u8VZdgdD3vpuDxUqo3v1JNzMA5nxKO+?=
 =?us-ascii?Q?tm1neQMjIH4NZpV8wD02ps89rxA8HodjrBU77pksT5fzfXzjnfguVPj4ab1V?=
 =?us-ascii?Q?v32a3khcPmvOJGb1R1ys123EfHMWvD7Z25NbxgaqDdbnp3rEALLAfRmUC//N?=
 =?us-ascii?Q?6fuKdZEwzq/0omXfyCal5H6O49rXV/LV8xKyN6vN9OlxtuOoF9ePo3KBZZKK?=
 =?us-ascii?Q?M49XFZdt9bLRbtMbHvA2VVhCrUSoXkUsdEp4uhRBqOXuPklMmeRxkqGRKNP0?=
 =?us-ascii?Q?zBrzLUY2YExWTTH0vA08KobIpO8T6zdfJ691wLlC/uxA7BVBb+d0HrRCa47O?=
 =?us-ascii?Q?0JD/1zodHoRjMERfR1K/DGkivkuY2TntvrdT7AqVOgVBIu8PCs82h+g+gHSH?=
 =?us-ascii?Q?6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56807524-9bee-4cc0-b2c5-08db57b9c7df
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 16:06:03.6744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7DXzUTH3ZzM5CcXp8E3rO18oKmfwqLvaUIPj1KfcFy23wpaFWmzMtzg5mBfjDR/1hwTmeI3dRpAUiIFiOg4vGinEZK5u2A7TyO8gr6MZh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6746
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, May 16, 2023 8:26 AM
>
>Tue, May 16, 2023 at 12:07:57AM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, May 3, 2023 2:19 PM
>>>
>>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>[...]
>
>
>>>>+ * ice_dpll_frequency_set - wrapper for pin callback for set frequency
>>>>+ * @pin: pointer to a pin
>>>>+ * @pin_priv: private data pointer passed on pin registration
>>>>+ * @dpll: pointer to dpll
>>>>+ * @frequency: frequency to be set
>>>>+ * @extack: error reporting
>>>>+ * @pin_type: type of pin being configured
>>>>+ *
>>>>+ * Wraps internal set frequency command on a pin.
>>>>+ *
>>>>+ * Return:
>>>>+ * * 0 - success
>>>>+ * * negative - error pin not found or couldn't set in hw  */ static
>>>>+int ice_dpll_frequency_set(const struct dpll_pin *pin, void *pin_priv,
>>>>+		       const struct dpll_device *dpll,
>>>>+		       const u32 frequency,
>>>>+		       struct netlink_ext_ack *extack,
>>>>+		       const enum ice_dpll_pin_type pin_type) {
>>>>+	struct ice_pf *pf =3D pin_priv;
>>>>+	struct ice_dpll_pin *p;
>>>>+	int ret =3D -EINVAL;
>>>>+
>>>>+	if (!pf)
>>>>+		return ret;
>>>>+	if (ice_dpll_cb_lock(pf))
>>>>+		return -EBUSY;
>>>>+	p =3D ice_find_pin(pf, pin, pin_type);
>>>
>>>This does not make any sense to me. You should avoid the lookups and rem=
ove
>>>ice_find_pin() function entirely. The purpose of having pin_priv is to
>>>carry the struct ice_dpll_pin * directly. You should pass it down during
>>>pin register.
>>>
>>>pf pointer is stored in dpll_priv.
>>>
>>
>>In this case dpll_priv is not passed, so cannot use it.
>
>It should be passed. In general to every op where *dpll is passed, the
>dpll_priv pointer should be passed along. Please, fix this.
>
>
>>But in general it makes sense I will hold pf inside of ice_dpll_pin
>>and fix this.
>
>Nope, just use dpll_priv. That's why we have it.
>

Ok, will propagate it.

>
>[...]
>
>
>>>>+/**
>>>>+ * ice_dpll_pin_state_set - set pin's state on dpll
>>>>+ * @dpll: dpll being configured
>>>>+ * @pin: pointer to a pin
>>>>+ * @pin_priv: private data pointer passed on pin registration
>>>>+ * @state: state of pin to be set
>>>>+ * @extack: error reporting
>>>>+ * @pin_type: type of a pin
>>>>+ *
>>>>+ * Set pin state on a pin.
>>>>+ *
>>>>+ * Return:
>>>>+ * * 0 - OK or no change required
>>>>+ * * negative - error
>>>>+ */
>>>>+static int
>>>>+ice_dpll_pin_state_set(const struct dpll_device *dpll,
>>>>+		       const struct dpll_pin *pin, void *pin_priv,
>>>>+		       const enum dpll_pin_state state,
>>>
>>>Why you use const with enums?
>>>
>>
>>Just show usage intention explicitly.
>
>Does not make any sense what so ever. Please avoid it.
>

Fixed.

>
>>>>+static int ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin,
>>>>+					  void *pin_priv,
>>>>+					  const struct dpll_pin *parent_pin,
>>>>+					  enum dpll_pin_state *state,
>>>>+					  struct netlink_ext_ack *extack) {
>>>>+	struct ice_pf *pf =3D pin_priv;
>>>>+	u32 parent_idx, hw_idx =3D ICE_DPLL_PIN_IDX_INVALID, i;
>>>
>>>Reverse christmas tree ordering please.
>>
>>Fixed.
>>
>>>
>>>
>>>>+	struct ice_dpll_pin *p;
>>>>+	int ret =3D -EFAULT;
>>>>+
>>>>+	if (!pf)
>>>
>>>How exacly this can happen. My wild guess is it can't. Don't do such
>>>pointless checks please, confuses the reader.
>>>
>>
>>From driver perspective the pf pointer value is given by external entity,
>>why shouldn't it be valdiated?
>
>What? You pass it during register, you get it back here. Nothing to
>check. Please drop it. Non-sense checks like this have no place in
>kernel, they only confuse reader as he/she assumes it is a valid case.
>

I have some background from Automotive, MISRA etc.
Removed.

>
>[...]
>
>
>>>
>>>
>>>>+			pins[i].pin =3D NULL;
>>>>+			return -ENOMEM;
>>>>+		}
>>>>+		if (cgu) {
>>>>+			ret =3D dpll_pin_register(pf->dplls.eec.dpll,
>>>>+						pins[i].pin,
>>>>+						ops, pf, NULL);
>>>>+			if (ret)
>>>>+				return ret;
>>>>+			ret =3D dpll_pin_register(pf->dplls.pps.dpll,
>>>>+						pins[i].pin,
>>>>+						ops, pf, NULL);
>>>>+			if (ret)
>>>>+				return ret;
>>>
>>>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..=
)
>>>here.
>>>
>>
>>No, in case of error, the caller releases everything
>ice_dpll_release_all(..).
>
>
>How does ice_dpll_release_all() where you failed? If you need to
>unregister one or both or none? I know that in ice you have odd ways to
>handle error paths in general, but this one clearly seems to be broken.
>

It doesn't have to, as release all would release all anyway.
Leaving it for now.

>
>
>
>
>>
>>>
>>>>+		}
>>>>+	}
>>>>+	if (cgu) {
>>>>+		ops =3D &ice_dpll_output_ops;
>>>>+		pins =3D pf->dplls.outputs;
>>>>+		for (i =3D 0; i < pf->dplls.num_outputs; i++) {
>>>>+			pins[i].pin =3D dpll_pin_get(pf->dplls.clock_id,
>>>>+						   i + pf->dplls.num_inputs,
>>>>+						   THIS_MODULE, &pins[i].prop);
>>>>+			if (IS_ERR_OR_NULL(pins[i].pin)) {
>>>>+				pins[i].pin =3D NULL;
>>>>+				return -ENOMEM;
>>>
>>>Don't make up error values when you get them from the function you call:
>>>	return PTR_ERR(pins[i].pin);
>>
>>Fixed.
>>
>>>
>>>>+			}
>>>>+			ret =3D dpll_pin_register(pf->dplls.eec.dpll, pins[i].pin,
>>>>+						ops, pf, NULL);
>>>>+			if (ret)
>>>>+				return ret;
>>>>+			ret =3D dpll_pin_register(pf->dplls.pps.dpll, pins[i].pin,
>>>>+						ops, pf, NULL);
>>>>+			if (ret)
>>>>+				return ret;
>>>
>>>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..=
)
>>>here.
>>>
>>
>>As above, in case of error, the caller releases everything.
>
>As above, I don't think it works.
>

It works, though not all error paths were probably test..
Will take another look on it later.

>
>[...]
>
>
>>>>+	}
>>>>+
>>>>+	if (cgu) {
>>>>+		ret =3D dpll_device_register(pf->dplls.eec.dpll, DPLL_TYPE_EEC,
>>>>+					   &ice_dpll_ops, pf, dev);
>>>>+		if (ret)
>>>>+			goto put_pps;
>>>>+		ret =3D dpll_device_register(pf->dplls.pps.dpll, DPLL_TYPE_PPS,
>>>>+					   &ice_dpll_ops, pf, dev);
>>>>+		if (ret)
>>>
>>>You are missing call to dpll_device_unregister(pf->dplls.eec.dpll,
>>>DPLL_TYPE_EEC here. Fix the error path.
>>>
>>
>>The caller shall do the clean up, but yeah will fix this as here clean up
>>is not expected.
>
>:) Just make your error paths obvious and easy to follow to not to
>confuse anybody, you included.
>

I am not confused :) it wasn't removed as it should.

Thank you!
Arkadiusz

>
>>
>>>
>>>>+			goto put_pps;
>>>>+	}
>>>>+
>>>>+	return 0;
>>>>+
>>>>+put_pps:
>>>>+	dpll_device_put(pf->dplls.pps.dpll);
>>>>+	pf->dplls.pps.dpll =3D NULL;
>>>>+put_eec:
>>>>+	dpll_device_put(pf->dplls.eec.dpll);
>>>>+	pf->dplls.eec.dpll =3D NULL;
>>>>+
>>>>+	return ret;
>>>>+}
>
>[...]

