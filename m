Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36FA47810A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhLQABs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:01:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:64660 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhLQABs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 19:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639699308; x=1671235308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HI2Oa7J6ETDRSF4EkcDm/1LuUi7mj0RpebwyGZuOx68=;
  b=Kr2qlb4h6zelXkwo4STUFZMTVhn4zNnwuzU0euCsnUpw3OEjArxfjz9P
   BwrkQqWOrmUhpaKEELNRR/j1Mr/CM108lVw8Pk4lt4jG8HMFVBMMXlAok
   Qmp4kcoXfPPOUvE6NKFBZBaBkWo+oRv7Tu6ktm0rdtCdcYsErA7G4v8f7
   G+mynHIQZBpKyk8GnpbudN25ngnPd6mYQR55o0RYjGwxfjVAsLqwyadIY
   1vezAXoo2fHn5lSF1yns6Ak1ZNlk5PxfvJw2nIqkdjIXM04QxAqGGKGMA
   fDl/XmZs+loar6wuBfcMNh/mVEFBx44UfaDk7bKjQPI9BrkTrk0Xtg3GA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="226495084"
X-IronPort-AV: E=Sophos;i="5.88,212,1635231600"; 
   d="scan'208";a="226495084"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 16:01:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,212,1635231600"; 
   d="scan'208";a="464907663"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2021 16:01:47 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 16:01:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 16 Dec 2021 16:01:47 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 16 Dec 2021 16:01:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2EhUYC5AaehW4GpAA5h+kUpvgTTTPfgH1lx5cW4IuvR6V+PLseSQ+bEvM+QNG3CX67uQMaD5z7Bodn1schYeyW0RAMvGG24HBllzdaqPjJ02i+jR5uLE2cJlqVEAuw97tMKkRayapR3DZk6gbJxa+1qI9q54rILwcHOYiiF9Z7hGqgr+a2viN4saZXyUJC3ZxVv0fEO+LoKe0iq+SjdyqO6yOnm2pFjCZ46/t2olZQIL0Lciivq9RueTFSNwx4GlC4Yu6niJhjZsX9q5VcIseZHJEU0KttGc9PFLA8DRl9WqEBi+3kIQrb29+/1IYlDZP8v474Mr/WCG2WQe3FAcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HI2Oa7J6ETDRSF4EkcDm/1LuUi7mj0RpebwyGZuOx68=;
 b=hHInYylqjXsgvhahqzMYxnWcd3olOgi23x81wmC+Gt/CzTjfB+hui46PP4gSyEe2CLThTWkcH4Rj52Emqv/6mcSCqNO4tGiwuakHs9TStDJiX88gCen4/s/wZWMJPEchEk4FehwJdckERkYPA00Fi66Cl7yQTGhoqF9nlGPsgsuvL2pWTAhesy2C1Jl0nDCZMZ52oc6CeFVDVpiz4ySwDNbrYF1viz0EPzG4DyAPuoPk9oGAXVgCeNPGQPkTokqp8p3sYmApejLO1rX92wj9MVqsZ84aMJ2WuojXQfwKeQ+PJZTodkZ4SfiyGr0PjixdJso1pb1rhKkypFqKsJn6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM5PR11MB1594.namprd11.prod.outlook.com (2603:10b6:4:5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Fri, 17 Dec 2021 00:01:44 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::8029:d3f4:4d28:6730]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::8029:d3f4:4d28:6730%9]) with mapi id 15.20.4778.017; Fri, 17 Dec 2021
 00:01:44 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Byagowi, Ahmad" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Topic: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Index: AQHX7c5gkbjtdDkUvk2JrP1IlaGkc6wr5xQAgAQ7IwCAA0az4IAAwXAAgAGsOSA=
Date:   Fri, 17 Dec 2021 00:01:43 +0000
Message-ID: <DM6PR11MB465758ECC87273A56CA2826F9B789@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
 <20211210081654.233a41b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <MW5PR11MB58126A8F6466A8EAD1293D5EEA749@MW5PR11MB5812.namprd11.prod.outlook.com>
 <DM6PR11MB4657CE134223B65B5F2EF5F29B769@DM6PR11MB4657.namprd11.prod.outlook.com>
 <4d4f5c27-90a3-c411-ea2f-e6f44ec74148@novek.ru>
In-Reply-To: <4d4f5c27-90a3-c411-ea2f-e6f44ec74148@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b8c0ef5-87cf-4f81-ec65-08d9c0f06947
x-ms-traffictypediagnostic: DM5PR11MB1594:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR11MB159452B7D8BED84D90ED3F139B789@DM5PR11MB1594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /M5qd/saXrgXdzVOktRlw0VbI4GpIEM3HmcDKFcdln5QuJgdDgDJDqPiOY+j5aDDGoc2L/6ozy1ZLcd36PRTE/uRH+5y72gtkesmAQ3Z2nMMhQwl+zD1VIR94zySgOtf1aDnzJ0XW+ftIS6l6P3hJnBIEPNBv500cVYu0qjrHPWggPDvu6yfHLh0TkVI5gc5kfprnF5CXDdpYMpAFpobF16qHLCRAco7iF9Rlycc9lqWXVRSQ8BJ0+SRQ8ZS/BMjNE+ZSTQVp596sZaBMXn3YKQqS5JmJBWV/NwFSaWkHWVm4AZlk4Y0+AXsWwaCbNplt8yXmmunqGLqe9N0Qw7dt2Be2sKuWTZNHi8dM3dCsOORyntdMoBzaqhOGOqQodMqG0ArVgXDUrgynC0fbYhQPTtf43JNsA9jYEwMtYOj07XPGV4R8JxKJt3pYpZclsYQUm7X8J1VwqUYa54uBC6eOpV8Pq9wIjRZmSw6ILTYOEz7fnfus8+lZj5lXfUXqKZniqZxWQ+g0i4VjBUVANsDSCX4IVMBOp1cCwmXeO95rE49b2BB37caPcDweREDWlYfqvzU1ZxaJfzB19U43AhY1zaCQHgwr+3zi27Ca9GPrNTd0qXGQrnVpQ/mnuR2SlwpuXbvX7Sldqtvs0FFZp/l7TCarmlt5k140hBq9tL7l1oN6SEIc0Y8k7LGzGjXJydHX0MjZj38d1EDXYxvFkhVtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(38100700002)(26005)(8676002)(122000001)(186003)(5660300002)(6506007)(53546011)(71200400001)(52536014)(66476007)(66446008)(86362001)(8936002)(66556008)(64756008)(110136005)(76116006)(33656002)(9686003)(83380400001)(66946007)(54906003)(82960400001)(55016003)(508600001)(7416002)(316002)(2906002)(7696005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?yR/uP+APf4qC/VDR/Xzl0Cz+706tN2dh2rAEmLIIsOyPVxgkJgZOYC5Lak?=
 =?iso-8859-2?Q?ndHZka2e8lYXRbahYyvFMdTRMgkbyBxq4uL1u2CD3mRXzip8WNCiRLrQMF?=
 =?iso-8859-2?Q?4J/A7Kg6BfdsCDjo/zvZWQVU9/bWH6P9ht6c4UTdHxWQ6p/LnH36OD6dDE?=
 =?iso-8859-2?Q?K1w7tSTkwHoCVifBox3fh+tLRRWfzzgFVZtLs772GWVF93HVB0w40SQcOh?=
 =?iso-8859-2?Q?86dNMB6CfgncgUVJPKK+Wl5kcQrUH388PXAZN+Bmncc244vrBa0VJVgqwe?=
 =?iso-8859-2?Q?0V40EwxkHjcKNivVSzvx+oL5X2xDyk0hp/VkkBRxs2v+1r8l7Gb8tgQ46k?=
 =?iso-8859-2?Q?UvE9jgKS5Q2C+Tgth155dtO2t90hIBYtW7+Jb2zRA4RLaa1VqyGqeiu1pO?=
 =?iso-8859-2?Q?ifXEJTvpZ1bvGpG6bzws1L+jn9ihQwODsNLqpOhnO9sqDKzb+MSzmRtfRu?=
 =?iso-8859-2?Q?5klJZFMoGITYSDhgth2Xcmkx3CJLMhPN0Bwc6mjqx4wq5m3vOkzmJmVhJv?=
 =?iso-8859-2?Q?4EsQujwkuPr3wzLp4E+jaSfkjLmIlWgYgepApmnKun1PEDgAZdsC8EQv7r?=
 =?iso-8859-2?Q?k1DONsJwVdN2eomEoEm0Yhr6eDr8CRyqA4WNLMdrwAD/iM9wrL0WxrSH+s?=
 =?iso-8859-2?Q?bKPTiPSZikcYKj42AZJZFod6I6+ObkpGqBWfm3BbXblOP+925Xv4jZplov?=
 =?iso-8859-2?Q?iW59nJts5Ni9e6CdgcKJGcNkltt1MuD7mzmx5oPoXeztbGGck0jtvWsMKm?=
 =?iso-8859-2?Q?X+ElAYsxSqAqdkmLXNLiFukX/BAHVFDdCaM+hmuddIppFGHXOD21vD/Ji0?=
 =?iso-8859-2?Q?e6xwm6NdyoDekuZf3bvJ9N9fSY2nYejRLLwMjHl9A39W2wu8YarFt+e9P3?=
 =?iso-8859-2?Q?60BxvBdmhhG8/aWlgC3CbWkSnIOSr+8OilDllZ8S6Pxe1VzD7LqvjGqHjp?=
 =?iso-8859-2?Q?ag4NMKn7hdbbkxdAmNjr9dL54oEqJ/Q++RkhK361LY7fN5FvCMHabaqagU?=
 =?iso-8859-2?Q?itD87bhtvdcVXWU8GaRK0IKTNinHL+Oqaw84tQPhsAPkgsCFaB8Q5xvZsf?=
 =?iso-8859-2?Q?B1uU3y60j6UeAQjEE8yOJwyxiugEYIaIzSUXSFNM5tPDwzS5XlmliJU8gT?=
 =?iso-8859-2?Q?ci2fJyrRO2GkzXPLs9B24mJw1XqN8Rec/IbnjJMc5vwPO64UJo+9fYIwbj?=
 =?iso-8859-2?Q?JJ4BZwHMILL68SPUzHWyo4uO280TTdGxXnbMFlynTr93rDaUH/1d3gtNaF?=
 =?iso-8859-2?Q?lr4bAMXR2R2mFyMwaCu7OkrNZk6RXHOUWrKgfOVGwfQCCehrJUAZhoTusa?=
 =?iso-8859-2?Q?IV6CUPkycC0SYMdcznEPzvC2MR+BO+bHg6IDLoaoY9eRfMVbzC0oXISru9?=
 =?iso-8859-2?Q?QMmMpkFSoRVAMEDGQBIZEWljdGawoitKvREthTl5pnKaGMfykf/hZA1els?=
 =?iso-8859-2?Q?NbBd4J8L1R2uC78guUroShdBZq8bcUnvZoMJVkZTrOquKrDqFEI3t4RG0M?=
 =?iso-8859-2?Q?4+LcySSLFGVi6f8Rvbrzwy74pT70FK19T28//a/bW8OL2bxmO8D1LICqRy?=
 =?iso-8859-2?Q?WOWsW8m6Amup+lJ4rY2CktJPeslwyyeAEL4QchEVYfiZRXXqVQGZEhng9X?=
 =?iso-8859-2?Q?SIRf4E2N/5cSgykfaTx/gWLstzZsezcamp+Y9mRS91haW2dlxT124dZiQb?=
 =?iso-8859-2?Q?WjV2oz02gsW8UU9sti/AbvVEvJIiULVmVxvc0q4a11E6EoBhDR+Gs2Xa19?=
 =?iso-8859-2?Q?UGzw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8c0ef5-87cf-4f81-ec65-08d9c0f06947
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 00:01:43.9038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hi2dpkArBVuxtI0cbu9gCHtnjkt+255L7R8pcLiS5ZPCbbBZh7gf/z75HUwdb4YFhuvODhgQuOsQAIYNrUNZRi7O/BsYyIUQg+HqBpGJaE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1594
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On 15.12.2021 12:14, Kubalewski, Arkadiusz wrote:
>>> -----Original Message-----
>>> From: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>>> Sent: poniedzia=B3ek, 13 grudnia 2021 09:54
>>> To: Jakub Kicinski <kuba@kernel.org>
>>> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kubalewsk=
i, Arkadiusz <arkadiusz.kubalewski@intel.com>; richardcochran@gmail.com; By=
agowi, Ahmad <abyagowi@fb.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.c=
om>; davem@davemloft.net; linux-kselftest@vger.kernel.org; idosch@idosch.or=
g; mkubecek@suse.cz; saeed@kernel.org; michael.chan@broadcom.com; petrm@nvi=
dia.com; Vadim Fedorenko <vfedorenko@novek.ru>
>>> Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
>>>
>>>> -----Original Message-----
>>>> From: Jakub Kicinski <kuba@kernel.org>
>>>> Sent: Friday, December 10, 2021 5:17 PM
>>>> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>>>> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
>>>> Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>;
>>>> richardcochran@gmail.com; Byagowi, Ahmad <abyagowi@fb.com>; Nguyen,
>>>> Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; linux-
>>>> kselftest@vger.kernel.org; idosch@idosch.org; mkubecek@suse.cz;
>>>> saeed@kernel.org; michael.chan@broadcom.com; petrm@nvidia.com; Vadim
>>>> Fedorenko <vfedorenko@novek.ru>
>>>> Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
>>>>
>>>> On Fri, 10 Dec 2021 14:45:46 +0100 Maciej Machnikowski wrote:
>>>>> Synchronous Ethernet networks use a physical layer clock to
>>>>> syntonize the frequency across different network elements.
>>>>>
>>>>> Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
>>>>> Equipment Clock (EEC) and have the ability to synchronize to
>>>>> reference frequency sources.
>>>>>
>>>>> This patch series is a prerequisite for EEC object and adds ability
>>>>> to enable recovered clocks in the physical layer of the netdev object=
.
>>>>> Recovered clocks can be used as one of the reference signal by the EE=
C.
>>>>>
>>>>> Further work is required to add the DPLL subsystem, link it to the
>>>>> netdev object and create API to read the EEC DPLL state.
>>>>
>>>> You missed CCing Vadim. I guess Ccing the right people may be right up
>>>> there with naming things as the hardest things in SW development..
>>>>
>>>> Anyway, Vadim - do you have an ETA on the first chunk of the PLL work?
>>>
>>> Sounds about right :) thanks for adding Vadim!
>>>
>>=20
>> Good day Vadim,
>>=20
>> Can we help on the new PLL interfaces?
>> I can start some works related to that, although would need a guidance
>> from the expert.
>> Where to place it?
>> What in-kernel interfaces to use?
>> Any other high level tips that could be useful?
>> Or if you already started some work, could you please share some
>> information?
>>=20
>Hi!
>
>I'm going to publish RFC till the end of the week and we will be able to
>continue discussion via this mailing list. I think that netlink is a good
>option for in-kernel interface and is easy to implement.
>

Oh, that sounds great!
Thank you!
