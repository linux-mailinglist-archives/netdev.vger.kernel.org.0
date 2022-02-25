Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDB84C4CFB
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiBYRzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiBYRzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:55:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0EB1BBF76
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645811669; x=1677347669;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A449FlpV3aCd0OMyF6W6poZnLCO7IsiIS8oePe9/q38=;
  b=b2GY03u15+/SyCssW2MKcK1I+vh8VSIKZWzQqFwziOmzgvk+/qTxPrYl
   f4okU+SO1Nkcq9gipMdzXtqyvmnFtELec6YaCw291WpmlZc0rwaMxmVX7
   H4Q7XBz2l3hGEAvN+tPrX2vtxoOs4my6A+B4VX0DdmjDg1EvVe5QqUE8x
   ZxHMwYsT/rOi5IPv9pH0WPN0X8UWvg6kzLCLRr6/je7af7l2We7Edw66C
   Tw26J+hq2NDyYXHP6QPCNPIF7YxOWQksfNsjwHmmIxsXUZ8VfBGzBFGWM
   fGjdjO5aJLSWYF/2Wa+7auE/R2Fmal7Jc1NmZGri9AJL7FgATPe6t+AeW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="236053413"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="236053413"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 09:54:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="684715682"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 25 Feb 2022 09:54:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 09:54:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 25 Feb 2022 09:54:28 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 25 Feb 2022 09:54:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyqONXVb4n0cFb7H1ojzchzgtaM0uRTGbY9EHWbTQafpU8g7r6eylRyCZKLo6E9dutcQmhbaD7Tu09WmFj4KyweAOoWlp3v7tg2E5E8bp6kpGrPd7VWQlGzaVSj3V+W3y/+Grlos2NWJLyHKiGH+WhE+HCphFNE4luTp43xvZOWZNCpej4dHxPKKmPgTUw1+Q3vU6uriTH02ZGcq4tuCXX6Cn06JZ2DIYd04b1a5fhFa5aUhben2I03RhazhSFq9MP8SZXahlQN5DoNHaYEP0THOSf7dI5QuDi37vbMkcYzbQvO+VTGFtACYZPUe7I/cd5ucV1WiBdDnxdq/ZVeUPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A449FlpV3aCd0OMyF6W6poZnLCO7IsiIS8oePe9/q38=;
 b=cUKkQxLJ53Ec02WTRm1GSqZSk6o5ul22FTL2YK6jb9/urhdX5WHlEN3q96sZV9R+z2hFDxvZDqcukIaru1cGlnFcMrldS7X9iRUDL0NBQgzBRiZrJlulzKBiqgPPU/OXiODtuYt2crB7+bAoHi67Gv+8pGYhSH2LMwJyHcYWKYvEZIihS/++iLGS5C0julefddArZysM40gc/hZNfPMQd4WzADyIVXdYpRdl62OZo/bTTVvEkuerbmMoAejERimGhP+z4E72lkkNTNnznbnh7lW+kf8dwjOSKJ+AZryyahVXbHtGGkbG6HF/35asBn6AAvOqSUpvmk+ouF6hAtDYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BL0PR11MB3364.namprd11.prod.outlook.com (2603:10b6:208:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 17:54:26 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5017.024; Fri, 25 Feb 2022
 17:54:26 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>,
        "Mishra, Sudhansu Sekhar" <sudhansu.mishra@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Thread-Topic: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Thread-Index: AQHYIfjMIAqwVc5cC0iQPJ4y7+ObuKyTvxGAgAE+s4CADJM9gIAAFWaAgAFc9YCAAA3EgIABjHCA
Date:   Fri, 25 Feb 2022 17:54:26 +0000
Message-ID: <1f87f6c4173c239d2c082500509736cf5f18357d.camel@intel.com>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
         <20220215001807.GA16337@hoboy.vegasvil.org>
         <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
         <19a3969bec1921a5fde175299ebc9dd41bef2e83.camel@intel.com>
         <20220223203729.GA22419@hoboy.vegasvil.org>
         <2da98bc3f97ef42dc6a054acc74894cd25031cd6.camel@intel.com>
         <20220224101543.707986e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220224101543.707986e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f64c6a3c-0636-4121-2781-08d9f887dd04
x-ms-traffictypediagnostic: BL0PR11MB3364:EE_
x-microsoft-antispam-prvs: <BL0PR11MB336421A13A8CD9F226BB3FFAC63E9@BL0PR11MB3364.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7VRQTKKTpxjvGjXs2AETjn7do6qIkF4PTyEnKHkR49TFKq8UADxAMFCkziNYonXitVR4Kn6cJ80mkFIow9Kggd99nWfWOqUvF0EZuRnFn0kVw+H1QVDx6qq3vpp6lAuB8GoRuZW7gZNdfMI0nzWD0eGr9l7ne07bcN/7HU5VdBuGJNR7emCDwseQhL1Uo/O9hPZYaQk/sOM6HQbrNPKAwIg64w4qAPUegAMcoDcu76TwSC2KpAHZgdYdixHuL2fJdMBXN3x43oS7WAQhPltnBAWUwlJAX7phUorx/1jcbtW44i2E3uRBQ7UlJfY61/ZHgiK+0H8Es51GrY5dBvWsgMM/0kOCQOEXXKCMXw4Nhkt8yvC3Y0vJvCgm7zCLQRCbm3Yj2Ch9tk/+NmoX9P2Mr3EReYjQVISZFv5PTmgz7VBQbRU2FUKMD/OKfjLP3g7HcQS7RbR/VhTkb3Y/2gctnEAPkkFW4HRG3QKbnbls80BG3joCShm+weCUxVp6QcFTfG28Z9TCF/wP/Ew2rsFpWhTABsqEid9yEI5paJBy0ZMZjH7n2WuUGIVnbISpPg50sgGTnycSvIbLVhckgzahw0IwKRV2nQVJ74SDaQ2BoJnnFaEABmy/zHuR6SRYJzX2jliVHx1E2SmfMZ+kJdT42byt/i4ksLHRE7ac8tzwgqJtHbRu13ax+0fyOd4l1P+wGODgqQcVmCYo5mCQ7fM/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(5660300002)(54906003)(38070700005)(316002)(91956017)(66446008)(8936002)(66556008)(66476007)(83380400001)(66946007)(64756008)(76116006)(8676002)(4326008)(38100700002)(508600001)(6916009)(82960400001)(122000001)(186003)(2906002)(2616005)(6486002)(6506007)(26005)(36756003)(6512007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFQ1d0U4RTcyb0FGL2tNd2tnMGZXOTRYdmFTZzBYcWwwU0tpT1dQS0toY2tk?=
 =?utf-8?B?UEZaTGorUTNYYWU1TVcwaXphUnNWYlEydzM4QWs4LzN2N1Jscld0WUd5N0sy?=
 =?utf-8?B?V0dWeXdsMUpTQkRSN1kwWFJ5b0xVUDIwRDd1Zm5hVitvTHc4Y0xCRzN0aHRL?=
 =?utf-8?B?WG0wRTRZRktTOFpueURScVpVcUJsSEhLL3phZS9XUmpUK3ZhV3ZWWGVsdStj?=
 =?utf-8?B?RnR5WTc0WTVyTDZYRUVJaUM3SUt2ano4MUFGWlgyekxoOC9pVmZhRWliM2RP?=
 =?utf-8?B?SUFIRU1HT0QvYUxnTDNCbVlyWGxFQ3lPRml4L1pjc1QwUG9oc2s0c3RLSlRy?=
 =?utf-8?B?RHk3N2JOVkVuT1E2ZXU2Sk1raG1WL2hQYzlVV2xlTlpiMmwvQkk5Rnc1U2Qy?=
 =?utf-8?B?TEpZSzU4c1YxVkhkQkovclMvZTRCMWZ2SGFSOHNLUGl4MHpEanRCS3QweUFW?=
 =?utf-8?B?OElOWE1RMUxhMURMRTJ6a0VJeUdyeGtnbHN4anhreUVPWENDaCtZZjdkUkNp?=
 =?utf-8?B?TlEwSHZJQVJzWGJzazJTdVlLMVYzcFE1cjlRSHFuOHBRc2tiakorZmU0dmxN?=
 =?utf-8?B?dXdEaUZXMlpBKzZtUjlWelcyR2d2ZEdoQXY0RzVyQWEvSERGWnNjb0VRSk5p?=
 =?utf-8?B?ZWhjZzArQ1B0TE43Vmk2ekdDVm5SRFB3OVlrUktQNVFjdk5FaldQTzl1dE5w?=
 =?utf-8?B?Y2s5TUdMd0hVYTAybFd3ZytnV1RLSTZjWHY1cU9sVjgxb00xRW9PY3g1ZERX?=
 =?utf-8?B?QmF2RTFJYVFVd1dTWVdPaER3QnYvWW41SWk1OHV2MFJCa0g0WnhWNFhBRk9a?=
 =?utf-8?B?OWlrL2JNTlBJZi9Rd2M2ZUFwU1Q4UzRtWlpJL3UyVHZybE1ZaDlMemZsMjN6?=
 =?utf-8?B?Z3JaTy9nQkhBV2oyL2N3SDFkSDdDREpMMzBuaTc3Z1YwRG9nWWVOWDlmU3Iv?=
 =?utf-8?B?S29lVy93K2xrZEFreUxUb0FnTGRTRmFDRHZvd0JSMFhyS3l6eXBmYXJmSEx1?=
 =?utf-8?B?Rk5Ud1pnOGtHbC80SUkrSXFrbExGU2hVSWtYckpRWEx5clhzTEtCWXFBVTlo?=
 =?utf-8?B?YVFiVEVld3YvWEFScWtta3l0NzZOMGhubWVPZEZubC9lRWI4Mko3M2FiMkVG?=
 =?utf-8?B?UW1iaXAzazFWS3BrZWdSNHdSbUs2bnhhSFl6L2ZCQ21FYWVMc3RVbStDaGRM?=
 =?utf-8?B?dW1KOXlleERMSEgrYlJFQWFMeHc4a0FsaFlKb3pvcExFVDE1eGwzRXhiTzVB?=
 =?utf-8?B?a0paNDZOcmhjeldDdkcwVEtia2RMU3lndUZyMWgzYjJ6L2NQelRCWkdCTUdI?=
 =?utf-8?B?MnZvaHhmdU16aXNuS2ZmUnpUaXNBL2wrOE5vQUlCM25xUFRMQWo2WHUyUjNm?=
 =?utf-8?B?TGYvRWVjVmpSZHk4ZE94TWhMTlJmQzVWSWJudGN2dEwzeHh0MHZBYVk5ZFRS?=
 =?utf-8?B?b2p4R0hHZnpHamxYRmh5VHZ1SWVlNzd4dGpoWWtycWtnSEwxa2VnZitwUm05?=
 =?utf-8?B?a3lKaW13UTV0c2M4a281QU12TkpCOC83V09JYjg3YW9jbWVWWUppYzZyQ3RO?=
 =?utf-8?B?aElEQ1g2NkM3aEJpbnhhVWlYNERuVUpKY0JPeUd4aWxhZExGWEFlSTJGdVJL?=
 =?utf-8?B?YzFwNGk3TitPYjY2TmRwcjlFUC92RVRxZ3dWcjR6bUEvVk5FaGlJSHBYck1C?=
 =?utf-8?B?SUNFWDNiaHJyNkUyeWJpZmZWUXpWUng1YkhxSGI0MmdCY3dwSXhUOWZ5MDJ5?=
 =?utf-8?B?U0NoQUlraXJJNThxM2Z6L0VNQzlkODFxcW5TeFFEeVNCTTJ0NUpZUVh3WE44?=
 =?utf-8?B?clg2MmxJZTZZTGVoZHRaQjFJeFl2eDNIOFFMOFJuYjFNU2I3NmpBUTdoR0Mv?=
 =?utf-8?B?VThHS3JVM0dOcmZsYjZLV2s5QVlaQlR1U243V1c2eElCMndhTkNIQTc0QkJV?=
 =?utf-8?B?R2gzaTZhcnJHdTR2KzRWWVVGVzRNb3pmc2JjckI4Mys3bS9kMUxMYk9wVVd2?=
 =?utf-8?B?NkJiS0NmcXdsQWFSc24rQzhFbDRHay9uZVlncVpVOEoyclNMdHYzSk5qckdk?=
 =?utf-8?B?bE5ZTXZXcS91MXZDT1dLMWlrRHNpNTNqdXRMMEpXZmtJNHZPcmVjUm5nZ1Ir?=
 =?utf-8?B?aVlhK0ozUEwxdHFRbyswYWNSQzJPdis5VmozMDg4K2pkckEzU1ZSY0xRQVh5?=
 =?utf-8?B?RE0vOGVZNTVlL2N0UExXcFlnUG5FV1BGM3pGMXlreElnNlAybDN2MTFpWDFy?=
 =?utf-8?Q?4b5KvUGsyFf4vjn6aq3hm5qSb5WvX6FDi7j3noMCEU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36356E4D1624CA4BBA72D15460881F27@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64c6a3c-0636-4121-2781-08d9f887dd04
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 17:54:26.1633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xWBYpcNG/d8ZZcyicsJ2LFx07r7vKfK5dMq9pxzsKEUZKX5WDpvskrhoA9YFq4Ca0jOedmCXKI9el5XTAjFic4w3h82ddfVttblsdx0n0GQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3364
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAyLTI0IGF0IDEwOjE1IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyNCBGZWIgMjAyMiAxNzoyNjoxNSArMDAwMCBOZ3V5ZW4sIEFudGhvbnkgTCB3
cm90ZToNCj4gPiBJZiB5b3UncmUgb2theSB3aXRoIHRoaXMsIGl0IGxvb2tzIGxpa2UgdGhpcyBw
YXRjaCBzdGlsbCBhcHBsaWVzDQo+ID4gY2xlYW5seS4gV291bGQgeW91IGxpa2UgbWUgdG8gcmVz
ZW5kIGl0IG9yIGRpZCB5b3Ugd2FudCB0byB1c2UgdGhpcw0KPiA+IG9uZT8NCj4gDQo+IEFyZSB3
ZSB0YWxraW5nIGFib3V0IHRoaXM/DQo+IA0KPiArc3RydWN0IGljZV9hcWNfaTJjIHsNCj4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IGljZV9hcWNfbGlua190b3BvX2FkZHIgdG9wb19hZGRyOw0KPiAr
wqDCoMKgwqDCoMKgwqBfX2xlMTYgaTJjX2FkZHI7DQo+ICvCoMKgwqDCoMKgwqDCoHU4IGkyY19w
YXJhbXM7DQo+ICsjZGVmaW5lIElDRV9BUUNfSTJDX0RBVEFfU0laRV9TwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAwDQo+ICsjZGVmaW5lIElDRV9BUUNfSTJDX0RBVEFfU0laRV9NwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAoMHhGIDw8DQo+IElDRV9BUUNfSTJDX0RBVEFf
U0laRV9TKQ0KPiArI2RlZmluZSBJQ0VfQVFDX0kyQ19VU0VfUkVQRUFURURfU1RBUlTCoEJJVCg3
KQ0KPiArwqDCoMKgwqDCoMKgwqB1OCByc3ZkOw0KPiArwqDCoMKgwqDCoMKgwqBfX2xlMTYgaTJj
X2J1c19hZGRyOw0KPiArwqDCoMKgwqDCoMKgwqB1OCByc3ZkMls0XTsNCj4gK307DQo+IA0KPiBZ
b3UgY2FuIGRlZmluaXRlbHkgaW1wcm92ZSBpdCwgZXZlbiB3aXRoIHRoZSBkZWZpbmVzICJpbmxp
bmUiIEknbSANCj4gbm90IHN1cmUgbG9va2luZyBhdCB0aGlzIGNvZGUgd2hpY2ggZmllbGQgdGhv
c2UgZGVmaW5lcyBwZXJ0YWluIHRvLg0KDQpJJ2xsIGFkZCBhIG5ld2xpbmUgYmVmb3JlIHRoZSBy
c3ZkIHRvIG1ha2UgdGhlIHNlcGVyYXRpb24gY2xlYXJlci4NCg0KPiBJJ20gZ3Vlc3NpbmcgaXQn
cyBpMmNfcGFyYW1zIGJlY2F1c2UgdGhlIG5leHQgb25lIGlzIHJzdmQuIFBsdXMgeW91IA0KPiBz
aG91bGQgdXNlIGtlcm5lbCBGSUVMRF8qIG9yIGZpbGVkXyogYWNjZXNzb3JzIGluc3RlYWQgb2Yg
ZGVmaW5pbmcNCj4gbWFza3MgYW5kIHNoaWZ0cyBzZXBhcmF0ZWx5LiBJIHRoaW5rIEknbSB3aXRo
IFJpY2hhcmQuDQoNCldpbGwgbWFrZSB0aGUgRklFTERfKiBjaGFuZ2VzIGluIHRoZSBuZXh0IHZl
cnNpb24uDQoNClRoYW5rcywNClRvbnkNCg0K
