Return-Path: <netdev+bounces-1673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 631A16FEC1B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 717301C20F10
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3F41F19D;
	Thu, 11 May 2023 07:00:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E7D63F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:00:44 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2210D5BB2;
	Thu, 11 May 2023 00:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683788443; x=1715324443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7BeTkFPa3D2zQxZy5atdaRurpQ4t6WWMO9ZXt2iSjuk=;
  b=OKaZo8r9ajoRb2yZVafqABf1nmlgbX+MlLXaLgyPNqpTlN9qfmoCGQ0J
   PO907+iceCCaUxsrRBZ8t2xpio36cCJfXqg4/GxA4afYIWa1SGDyN079C
   7IkZvJdfQzjL9bNtkDaGqD2xDNSOlQO2GvPWbfVkXxkUK0OM5HXrfwHVM
   VZuiAd5V/+YNKR/QGY1xcMbraSMUJxVp15Nmf4jKBcQnrRDPU0XrIT/np
   ip54hARsAZScagVZfg0sp1+qSnmNGTP1y1DWQDOHAs+RAxs5qZvOxu2/9
   C1md/JOlTDItDQ594YRKZe5MSfl0uFbFA6WhF89hnR9Jv/0D6904CrEd4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="416007616"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="416007616"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 23:59:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029504153"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029504153"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 10 May 2023 23:59:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 23:59:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 23:59:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 23:59:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 23:59:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYefqWUz7bl1Beb/wF6nDitiTWGnNtmsvFdoanl2CkvPkw2/4mnQsalVbwZ1RRYKeWMxzoMrIHEjXWzfOIJn/f2CKGOmdxBB5r+yPRy9mBG5Z/p11IxX/R+DsQWjuVlZOlZf/8GRLjAKqbOVx8w0R3pdDSAVSBe9+m3ec4Q7bkUkPClPsbivj/nQKWDczhRJylixglQNPkQhB5yDsKatQ/eLSiMbbdWM2PeNDalGQtnTA4Eh2kJ4+zywP5pOQSlyLmj87AXaLSWohWppwpTwfiWPBS8f9iW3JKZLcdNKEdU1lJAOgpGOE/IEZKzorpwTnzxbI6qUl5TErwfuDltN6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BeTkFPa3D2zQxZy5atdaRurpQ4t6WWMO9ZXt2iSjuk=;
 b=C16B1AHznhiGR3gHXNKgAVbUw+ReJPAZJoQoX14sg3/xIiNJub/k/0YhPrzoPB6CQYDBgnF7x/HcjCKLmdSD4pB7Mqt5Npk4muiAugR45O/rpZd4dalWUB4kfCupTsWwwthgH1prgG61ekg2FEqMFT51Iv2FIhvrx5r1AsQ5BfX3m2n2O/acuPwftTAdGdRmC1sbEze1yrNuV1Fd0vtNZ23lZF0R9q6dKoFdea2e4Pl/atAfLnvQfvkt6Z5D3zmEpTHlA6VxW/LhDkpNh769vh5SYMxIGE2V06celiqbIChiupXGSWHxpVBY5Mzzs1mg+5IK+7UaUyZ7MgQo7WXgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA0PR11MB7355.namprd11.prod.outlook.com (2603:10b6:208:433::7)
 by MW5PR11MB5859.namprd11.prod.outlook.com (2603:10b6:303:19e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 06:59:19 +0000
Received: from IA0PR11MB7355.namprd11.prod.outlook.com
 ([fe80::1fb1:ceda:2d3a:39b9]) by IA0PR11MB7355.namprd11.prod.outlook.com
 ([fe80::1fb1:ceda:2d3a:39b9%7]) with mapi id 15.20.6387.021; Thu, 11 May 2023
 06:59:19 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C"
	<tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEA==
Date: Thu, 11 May 2023 06:59:19 +0000
Message-ID: <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR11MB7355:EE_|MW5PR11MB5859:EE_
x-ms-office365-filtering-correlation-id: 006ef820-62df-4cce-e7f8-08db51ed3e08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8H+066/dYAZAb6qAagG2Yxtf4ZfUJrwZp0RxTXRrU+YJ3FS94NbNcZ/qpBaS+KneFNdaI7WPkr2wR9hEhmT/ot+42VUjQj8Xj/DZO8MmHGcRqPRYgLie+4jBlUyfXFTveLF0AKa8JgUaI18G8qIQW+22HCiTtq4vkX2axCffAUlzofeaivLgv/z6e69CC23J1NItYkYEKgzR7CX9XpmcFUsJrKyB+zhOTeSa+yCs6P5ET0bfp8mUMuinbMwUibFPp+4jNAcLx714ydK2XP5p2u0JDuoG7D9UAt5PC4ZqZtMfgvSga0yBuV9YQ2SGlWPUq2kKh7X35or0eZhYsR/lIz/HTCSP8r7H3h/nK2b7aJi2UTpNTZZ657y5BWcohAQpGU8VyAR3BlKl9nMiYyUASJaSaLsAbkNs1cwpzEG0ToOQa27uAFKeBH4Rr0x3JUJA1T9sO9O///qZGTqhb89PlGjCFwz8ZXOy/uaPZZqy2jopAE1SsIkd7vKC9n00NcyT8ndmJ5cgsbazAlGqYHy/ymzyAlt+undWHv8LxRUPY/55CBu+wITC9vGibklY4JawESck3BMa34PffICVFnXA3O0dEpGa5OzupgcMiEfLWtHJH/7+OFbIUHxo7QjLZj1T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7355.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(2906002)(38070700005)(8936002)(38100700002)(8676002)(5660300002)(52536014)(33656002)(71200400001)(86362001)(55016003)(7696005)(26005)(478600001)(54906003)(6506007)(83380400001)(186003)(64756008)(9686003)(53546011)(6916009)(316002)(66446008)(66476007)(122000001)(76116006)(82960400001)(66946007)(41300700001)(66556008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTdVR2c2dTlPTGRvL2VUVmRhOUhpYzNad0U3RE0wM05pRVBIQk1MWmFDUWkx?=
 =?utf-8?B?U3RvSzF5NVhJZFFGR3VYcWJuREYwS1BPSE9sUUpRbDBWbFZoV0puSldmN1BK?=
 =?utf-8?B?Z0RZN3QzTndpOVlNc1BtaFJvcmJNZ3NqdlBzU3ZqQS9ENUd4N0hCRUVMb2xz?=
 =?utf-8?B?SmlrOGl4ZUZUL2pqQ0FFaGtEZjNJemhsWW9WM25rY09Ua040ekdrTXQzQTZh?=
 =?utf-8?B?VEl3aUVHaWF0MkkrcFJiTSsvdytxaW5sK0MwTnBnbEJUQ0Q1alQraTk4a0RL?=
 =?utf-8?B?aG1Fblkva29DNHBVTGdQNDNyWElvSHdPZmZOSXhBNFpRWVRLaGZSSS9oYjB6?=
 =?utf-8?B?RzNRNFFkd3RtbkZxYXJUcEtXL0FQVWNkUHNVbGljZ01JM1J2SUpYSG5iUVhi?=
 =?utf-8?B?Q1l1b3hwWkQxUHFBYmxYcklIRGluM0crQlo2N3VQeEViNlFPRXd6SGw1SjND?=
 =?utf-8?B?YUZiQnFRNldyTHNmTmQ2ck1PenBJaFNicFdTQ0hjR293NVI0dTd2cGlHdUk5?=
 =?utf-8?B?MzlHYVEwT3h3QTlBVnhNWTYwT0k4K21wMUN3a3lFTFRvOHg3Nkh0SnpEdUhS?=
 =?utf-8?B?TW1vdjkzSWs3M3RxZElwTVRpditlRW5pWmc1OHI3elJOSndoMHQyOUNOQWJI?=
 =?utf-8?B?djdzYjAxdjk1N29lNS9rUDJFY1ljb0dyVTNZeWxxT0ZYVE5aVGVSRkQ4UXc5?=
 =?utf-8?B?Nlpxa0g0TGJraXhSMThqVnFWa09lNjNXY3FnWnlSdnJyQXZFNWh3dUVZNXNH?=
 =?utf-8?B?ejdqSFVFaDZjQ0hOTW45V1NBTGtKQ09BbzY5T0wwa1hMMDAxNjZLbVNHTWZP?=
 =?utf-8?B?eXA4UHNZWjR1cE9pSmpzUDJPa2laRHZCNDlURkRWR2I1dERVM282UE94MEVO?=
 =?utf-8?B?WG5meWtGcDN1QXZMRERRV3FFYkJ0MW1YTmhUUTBFaXRIeURzWTlObDZCOXd1?=
 =?utf-8?B?ODlEVUhNTzFqUkNWZDJMcUVVbzhlQkx4cWtoM3ZaL0s2aWxBZUZ5OXhPNHF3?=
 =?utf-8?B?QjZoMHpMc0xueVBNTkhwOUFvbUExdGcvbnMyRHE4cmlBbEZyU21xQXAwWW5T?=
 =?utf-8?B?N05GZFpBdStLdndMcURGMHBjZGx6c0pwM0VjRjdwd3BPRGxuc2xwa24zdmNZ?=
 =?utf-8?B?WDNjTUlpV0cyTEpmbUlSZk80eW55bUhpa0o0Nm5rK2VqWFJtU2tDMnlnWG5R?=
 =?utf-8?B?NThiME5zRzdlUzdYWDNUN2ZIdFI4LzU5SGRzV0dOV0xJekxmOGVXOVpXV3F4?=
 =?utf-8?B?blZQaG1rLzdQRGJYY0lZdFhqR3VyWUxDODRiUjJ6MnM1bHQyakFQdnlDZWdO?=
 =?utf-8?B?dllFMFh5U1RFcWR0ZmRVTUtmODY2dGZUZzdzNGFodUNEaHdSbmxDVjB2Z1pI?=
 =?utf-8?B?bnVteUZTWVhhd1J0TVpPRGQ4YjA5cmVVdGNCald4NEZlekdFcDJUTHp4OVVr?=
 =?utf-8?B?NHJ2NFNmZGtqbHZXYThWREhqVUlDOFh5MjJlUzIvdmwxS0I5MUZUZkttL2s1?=
 =?utf-8?B?eW5XOTJ3dTNWelUzNFhjMG56Z2pvamgvamhjbFN2eEhXM0hoWmxiblJPM09l?=
 =?utf-8?B?UE5McUdEc2xycWEwQis5aUZLNnRkeW5GMHpIbythZ0JOdDRnMFEvemp3UDdN?=
 =?utf-8?B?N2NBWGZydTh1YVY3YzNoYTdHY21tVFJCSHVDS3U3TnBHeW9pcnE5eVgwaFo1?=
 =?utf-8?B?NTJrcnVrSWJMa3VrVkpuTlJUUU1RbnN6Q0krZk9UR0xUM0hudzRYbmw0ejBN?=
 =?utf-8?B?YlRZMmxrOXdCVC9xUXhrM2dsTmNWU3M5Z1BRK0tqSUdZRjlZUUhHNHlMaHEx?=
 =?utf-8?B?RTAwc2tCMnk1VXJlVXNRaHY2aU8zRXFMQ0VwcHRiWlg2R2hOL0N3RTE0L2Z4?=
 =?utf-8?B?SlhBaDF1R0JVUStoVlMxQlJVWklsUXBXdXZEWGxDZ1NOYTBqaHNGQ2hybDlx?=
 =?utf-8?B?RUU5UEpGY0RUR3h2enZGSjZMK2lsOGoxcnlCZFkzSUhBZ2RUQ0xQK3ByMkZJ?=
 =?utf-8?B?d2xDTm1aWnplNm9xTk1FL1U2Y29JblN3cXNjOS9IYVVOVFF5VUV0N2xqanVm?=
 =?utf-8?B?dWhUN0RXbHRBV3JBRy9RallqMkViU0p5YWxQM0VaRVVLb2xoeFViT2prUU1t?=
 =?utf-8?Q?NZbgU1Gc7HLJKUt0xoRw7oL7F?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7355.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006ef820-62df-4cce-e7f8-08db51ed3e08
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 06:59:19.2520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BQumduiqpOnju76URmY1xVBoNZkaggQmZ4QEcULwWt/TXtyaBV7oO171qOj2XFSOiFW9+H40UYI9Rue6minsjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5859
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWmhhbmcsIENhdGh5DQo+
IFNlbnQ6IFRodXJzZGF5LCBNYXkgMTEsIDIwMjMgODo1MyBBTQ0KPiBUbzogU2hha2VlbCBCdXR0
IDxzaGFrZWVsYkBnb29nbGUuY29tPg0KPiBDYzogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29n
bGUuY29tPjsgTGludXggTU0gPGxpbnV4LQ0KPiBtbUBrdmFjay5vcmc+OyBDZ3JvdXBzIDxjZ3Jv
dXBzQHZnZXIua2VybmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gQnJhbmRlYnVyZywgSmVz
c2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgU3Jpbml2YXMsIFN1cmVzaA0KPiA8c3Vy
ZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNv
bT47IFlvdSwNCj4gTGl6aGVuIDxMaXpoZW4uWW91QGludGVsLmNvbT47IGVyaWMuZHVtYXpldEBn
bWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IFtQQVRD
SCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBhIHByb3Bl
cg0KPiBzaXplDQo+IA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiBGcm9tOiBTaGFrZWVsIEJ1dHQgPHNoYWtlZWxiQGdvb2dsZS5jb20+DQo+ID4gU2VudDogVGh1
cnNkYXksIE1heSAxMSwgMjAyMyAzOjAwIEFNDQo+ID4gVG86IFpoYW5nLCBDYXRoeSA8Y2F0aHku
emhhbmdAaW50ZWwuY29tPg0KPiA+IENjOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5j
b20+OyBMaW51eCBNTSA8bGludXgtDQo+ID4gbW1Aa3ZhY2sub3JnPjsgQ2dyb3VwcyA8Y2dyb3Vw
c0B2Z2VyLmtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaQ0KPiA+IDxwYWJlbmlAcmVkaGF0LmNvbT47
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gQnJhbmRlYnVyZywNCj4g
PiBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBTcmluaXZhcywgU3VyZXNoDQo+
ID4gPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVuLCBUaW0gQyA8dGltLmMuY2hlbkBp
bnRlbC5jb20+OyBZb3UsDQo+ID4gTGl6aGVuIDxsaXpoZW4ueW91QGludGVsLmNvbT47IGVyaWMu
ZHVtYXpldEBnbWFpbC5jb207DQo+ID4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNrX2ZvcndhcmRfYWxs
b2MgYXMgYQ0KPiA+IHByb3BlciBzaXplDQo+ID4NCj4gPiBPbiBXZWQsIE1heSAxMCwgMjAyMyBh
dCA5OjA54oCvQU0gWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+ID4gd3Jv
dGU6DQo+ID4gPg0KPiA+ID4NCj4gPiBbLi4uXQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEhh
dmUgeW91IHRyaWVkIHRvIGluY3JlYXNlIGJhdGNoIHNpemVzID8NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IEkganVzIHBpY2tlZCB1cCAyNTYgYW5kIDEwMjQgZm9yIGEgdHJ5LCBidXQgbm8gaGVscCwg
dGhlDQo+ID4gPiA+ID4gb3ZlcmhlYWQgc3RpbGwNCj4gPiBleGlzdHMuDQo+ID4gPiA+DQo+ID4g
PiA+IFRoaXMgbWFrZXMgbm8gc2Vuc2UgYXQgYWxsLg0KPiA+ID4NCj4gPiA+IEVyaWMsDQo+ID4g
Pg0KPiA+ID4gSSBhZGRlZCBhIHByX2luZm8gaW4gdHJ5X2NoYXJnZV9tZW1jZygpIHRvIHByaW50
IG5yX3BhZ2VzIGlmDQo+ID4gPiBucl9wYWdlcw0KPiA+ID4gPj0gTUVNQ0dfQ0hBUkdFX0JBVENI
LCBleGNlcHQgaXQgcHJpbnRzIDY0IGR1cmluZyB0aGUgaW5pdGlhbGl6YXRpb24NCj4gPiA+IG9m
IGluc3RhbmNlcywgdGhlcmUgaXMgbm8gb3RoZXIgb3V0cHV0IGR1cmluZyB0aGUgcnVubmluZy4g
VGhhdA0KPiA+ID4gbWVhbnMgbnJfcGFnZXMgaXMgbm90IG92ZXIgNjQsIEkgZ3Vlc3MgdGhhdCBt
aWdodCBiZSB0aGUgcmVhc29uIHdoeQ0KPiA+ID4gdG8gaW5jcmVhc2UgTUVNQ0dfQ0hBUkdFX0JB
VENIIGRvZXNuJ3QgYWZmZWN0IHRoaXMgY2FzZS4NCj4gPiA+DQo+ID4NCj4gPiBJIGFtIGFzc3Vt
aW5nIHlvdSBpbmNyZWFzZWQgTUVNQ0dfQ0hBUkdFX0JBVENIIHRvIDI1NiBhbmQgMTAyNA0KPiBi
dXQNCj4gPiB0aGF0IGRpZCBub3QgaGVscC4gVG8gbWUgdGhhdCBqdXN0IG1lYW5zIHRoZXJlIGlz
IGEgZGlmZmVyZW50DQo+ID4gYm90dGxlbmVjayBpbiB0aGUgbWVtY2cgY2hhcmdpbmcgY29kZXBh
dGguIENhbiB5b3UgcGxlYXNlIHNoYXJlIHRoZQ0KPiA+IHBlcmYgcHJvZmlsZT8gUGxlYXNlIG5v
dGUgdGhhdCBtZW1jZyBjaGFyZ2luZyBkb2VzIGEgbG90IG9mIG90aGVyDQo+ID4gdGhpbmdzIGFz
IHdlbGwgbGlrZSB1cGRhdGluZyBtZW1jZyBzdGF0cyBhbmQgY2hlY2tpbmcgKGFuZCBlbmZvcmNp
bmcpDQo+ID4gbWVtb3J5LmhpZ2ggZXZlbiBpZiB5b3UgaGF2ZSBub3Qgc2V0IG1lbW9yeS5oaWdo
Lg0KPiANCj4gVGhhbmtzIFNoYWtlZWwhIEkgd2lsbCBjaGVjayBtb3JlIGRldGFpbHMgb24gd2hh
dCB5b3UgbWVudGlvbmVkLiBXZSB1c2UNCj4gInN1ZG8gcGVyZiB0b3AgLXAgJChkb2NrZXIgaW5z
cGVjdCAtZiAne3suU3RhdGUuUGlkfX0nIG1lbWNhY2hlZF8yKSIgdG8NCj4gbW9uaXRvciBvbmUg
b2YgdGhvc2UgaW5zdGFuY2VzLCBhbmQgYWxzbyB1c2UgInN1ZG8gcGVyZiB0b3AiIHRvIGNoZWNr
IHRoZQ0KPiBvdmVyaGVhZCBmcm9tIHN5c3RlbSB3aWRlLg0KDQpIZXJlIGlzIHRoZSBhbm5vdGF0
ZSBvdXRwdXQgb2YgcGVyZiB0b3AgZm9yIHRoZSB0aHJlZSBtZW1jZyBob3QgcGF0aHM6DQoNClNo
b3dpbmcgY3ljbGVzIGZvciBwYWdlX2NvdW50ZXJfdHJ5X2NoYXJnZQ0KICBFdmVudHMgIFBjbnQg
KD49NSUpDQogUGVyY2VudCB8ICAgICAgU291cmNlIGNvZGUgJiBEaXNhc3NlbWJseSBvZiBlbGYg
Zm9yIGN5Y2xlcyAoNTQzMjg4IHNhbXBsZXMsIHBlcmNlbnQ6IGxvY2FsIHBlcmlvZCkNCi0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KICAgIDAuMDAgOiAgIGZmZmZm
ZmZmODE0MTM4OGQ6ICAgICAgIG1vdiAgICAlcjEyLCVyYXgNCiAgIDc2LjgyIDogICBmZmZmZmZm
ZjgxNDEzODkwOiAgICAgICBsb2NrIHhhZGQgJXJheCwoJXJieCkNCiAgIDIyLjEwIDogICBmZmZm
ZmZmZjgxNDEzODk1OiAgICAgICBsZWEgICAgKCVyMTIsJXJheCwxKSwlcjE1DQoNCg0KU2hvd2lu
ZyBjeWNsZXMgZm9yIHBhZ2VfY291bnRlcl9jYW5jZWwNCiAgRXZlbnRzICBQY250ICg+PTUlKQ0K
IFBlcmNlbnQgfCAgICAgIFNvdXJjZSBjb2RlICYgRGlzYXNzZW1ibHkgb2YgZWxmIGZvciBjeWNs
ZXMgKDEwMDQ3NDQgc2FtcGxlcywgcGVyY2VudDogbG9jYWwgcGVyaW9kKQ0KLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KICAgICAgICAgOiAxNjAgICAgICAgICAg
ICAgIHJldHVybiBpICsgeGFkZCgmdi0+Y291bnRlciwgaSk7DQogICA3Ny40MiA6ICAgZmZmZmZm
ZmY4MTQxMzc1OTogICAgICAgbG9jayB4YWRkICVyYXgsKCVyZGkpDQogICAyMi4zNCA6ICAgZmZm
ZmZmZmY4MTQxMzc1ZTogICAgICAgc3ViICAgICVyc2ksJXJheA0KDQoNClNob3dpbmcgY3ljbGVz
IGZvciB0cnlfY2hhcmdlX21lbWNnDQogIEV2ZW50cyAgUGNudCAoPj01JSkNCiBQZXJjZW50IHwg
ICAgICBTb3VyY2UgY29kZSAmIERpc2Fzc2VtYmx5IG9mIGVsZiBmb3IgY3ljbGVzICgyNTY1MzEg
c2FtcGxlcywgcGVyY2VudDogbG9jYWwgcGVyaW9kKQ0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQogICAgICAgICA6IDIyICAgICAgICAgICAgICAgcmV0dXJuIF9f
UkVBRF9PTkNFKCh2KS0+Y291bnRlcik7DQogICA3Ny41MyA6ICAgZmZmZmZmZmY4MTQxZGY4Njog
ICAgICAgbW92ICAgIDB4MTAwKCVyMTMpLCVyZHgNCiAgICAgICAgIDogMjgyNiAgICAgICAgICAg
ICBSRUFEX09OQ0UobWVtY2ctPm1lbW9yeS5oaWdoKTsNCiAgIDE5LjQ1IDogICBmZmZmZmZmZjgx
NDFkZjhkOiAgICAgICBtb3YgICAgMHgxOTAoJXIxMyksJXJjeA0K

