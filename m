Return-Path: <netdev+bounces-2980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 737FE704D58
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B6DF1C20CA3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215D824EBC;
	Tue, 16 May 2023 12:05:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A48E24EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:05:44 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E12159EB;
	Tue, 16 May 2023 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684238742; x=1715774742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YIWZqXf4HHzoNtQY7oOIo41y/nKSq234f+rEaRbkZGk=;
  b=d+LkLmoZ6h9w+c/VI3iJpC3VFG3imzsD9/9ldrkNBC5F0Zj0dDPwZFPC
   xm52eg2+VotdwBpZOtyBvIKfaQqOcgbhmKH7jpR3KWyOPSOWkCpGw2pcm
   ve0ZFszPNPtmx1lTlOBxJVR4H35YvaJOFYljCFJ3GG5cqJET8TVluk5WD
   Bs+b4e1cc+mwb9maTDIt7b75U/2qMorBb03W7OwRAKT53hhqpcdiBhlgy
   Ud3Q3bK03ng/wL4sKSI9SYqpqhPkYdFpmRvOYpCKLLx9O+AmKSbmQRx9L
   5c5c5FPQLYD+XJNuJ4Zunh3cI5JdsyjxB7ngW2x0b7vog0IL/X3I0ezFr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331821082"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331821082"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 05:05:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="875593982"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="875593982"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2023 05:05:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 05:05:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 05:05:40 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 05:05:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNeWheMYi8gWuRMGChDDzJhBDWy65QzRdfbS3sKl0B+3HBa0k4WMl8ZUFdgSIw7KflXBGKGgjZoUfoSp45sWO0XSRxYjxVdAEqYa2K+tA7N3WWoqL7Y2b4b/YS0eyF/l9Gpe6l/0HPFpgs0pmKgrBWlHziwyS85MTz1gQBQxPdN07cfCX3IN1Guw+hkzWXHPvBN3uvEhYELCarQR86j/eb+Zdvpuo8oyUYfc3/v64Y6jbyq7x2Z9UUcuzclZggq2EGlNNjWjIpr/Vh5sdjxn8J9V3E2Ez2t1+XjJ4is1br8CGlZ8s8JEJ90/9q/3JEfO6X0XjRkjtokbloeHmH3Fiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJsIb01ONcV6I/KG6Uj9Ku6PFDqpSDYIFD7eSS6ugMI=;
 b=Pnf/xxr2rqo6BmRru/pOqh4Aq0Z+aMY7EhqHJog7bMElq0DEm+RoN5RuRs9CzCB69ExYuyhuDlWGBqGls33uIkLOdVe2W5NgafvL3eJH8vse9s8jwoaoOi7xSvt0dD5rGy7wwQPHaRKxqYBgzh6NpJDV9N/OsgBiJE/TG0of4+TbKr87V/myYw7H/Q8whYYaWvHoam/CnjPYksCwPOgHoKsb+IjP73am0mA6S5RwLZftvzbR0/nQbzuiR9LQQpn31ws0ZQd8bUoNlStadNHkRBzhD5G/CRJk2/U0z6xALrlP01RFbJpSNQeTzBlLnX1G3hqZa25BcfgWE/QgQ2NGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 MW4PR11MB5869.namprd11.prod.outlook.com (2603:10b6:303:168::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.32; Tue, 16 May 2023 12:05:38 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 12:05:38 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAChnlwIAABXaAgACPXPCABdNcAIABvNIA
Date: Tue, 16 May 2023 12:05:38 +0000
Message-ID: <DM6PR11MB4657670163F45823F66B28619B799@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com> <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
 <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <ZFygbd1H+VdvCTyH@nanopsycho>
 <DM6PR11MB4657924148B84F502A44903D9B749@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGH7uvxD55Pan0gf@nanopsycho>
In-Reply-To: <ZGH7uvxD55Pan0gf@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|MW4PR11MB5869:EE_
x-ms-office365-filtering-correlation-id: d4c5411a-1b42-4a0e-82b2-08db5605dce1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mukTX484AmO7K/KS0T+W9+MR51/R2CZ4VXON4elogV2Uoa5wXUOPIq+iGm53jJFhmG08KA0hf4qaej9+aTWanithwEMVUmF2+kq3eJStySEWgQpYfcGCYng+ic5pAb979C9UBvT57Uct//JSrHlnwoU/RiQZrhr/cBOFId5k/4ZRO9XCQVi4oiIs+TvBE0ejiv4t5PASgWw1mqmQl+jLrAYz/FZc6sIx8ktHSQj5JSMcz1KbI1/hlB9pQDRNCiFJQsLg8emwPwb3/YsebkrBf1E6vJniCwv90LGg3aLhKVH0j/1VwFXSzF9qNE0lgVf+0WOTbnP5rfNAn1N+tZY9PMGMP0Sazb5TrrGGKw8kcbeDKxu/LiQ6iyxJeDyaIzTL/OhOWFHe6dHi4rNocdLySu+KcwaV52zLJGqxEcerXYI7KPsHfb2qFFID5nSeCwbvVEVJrtui0OX69XJWJkvUS5fHkl+PbkkuhJWNNdUcwCfswhENyUybZTnARpUn0hqdAExA9wyroMCB7xVgxWN65d/3qTN33DkPTbU27l008A68IVPe7r9wEhKHKE2uyRRNrL6xAhbWOxA4wREjbnU1EVVF4TEDMnij93V6gpAM9uZQkCf100OYtt7XLShHGXd3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199021)(66446008)(6916009)(2906002)(316002)(7416002)(52536014)(5660300002)(8936002)(4326008)(8676002)(76116006)(66556008)(64756008)(66476007)(66946007)(41300700001)(54906003)(33656002)(55016003)(7696005)(478600001)(71200400001)(186003)(26005)(6506007)(82960400001)(86362001)(9686003)(83380400001)(38070700005)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K+V2kwitMleMQ2cyxWf94J2ESpQd83Jnvg7Gj1w29U0ckKwjx/fwdTJO3VmA?=
 =?us-ascii?Q?4AlU1VMHaWgkoD6QMExe00KsalAXAkkjED/LqT71sb6vsJud5XWjVgCRRIN4?=
 =?us-ascii?Q?6bDjP7mSxPzTiE1XVNndq86yhOvHQOyqKKFm7qY3o/sn2QlggxlaPAL6DZc2?=
 =?us-ascii?Q?ImsFdFe2bRIUFQE+t5KZTdAsSBDjIKp+RQXeg0hh1ij0UwIn9MuNyL06lKmH?=
 =?us-ascii?Q?mrCpDjhLQbFBbJhcJr/GRJDMif+kMcAZ8LfHU3Rigckooxiwt+ivfGZEKOQK?=
 =?us-ascii?Q?gPXXaKsh4Ink0ZxoKn5qqQ8Dr1PieqSqqw3rH/gQsNUOTS0Pw5cNoHi3yt60?=
 =?us-ascii?Q?rroFGEK2FXk518ToeJjEcx3wbkqx2GpuuDY/XzaKdTevKbKAob7Zf9KBHg8r?=
 =?us-ascii?Q?afwIw5xjegXHYr5O3rDTcWEs3jgxYU5RGS9DM4u7dIhBfUyuDCkankK/NoYB?=
 =?us-ascii?Q?veqIM/z+o6MwB1thwYTOwZ95Slafj/b0naJNVLqgtjYarscM0aV5Gg3N6Tl+?=
 =?us-ascii?Q?1ELFVo/xVo7//BmQa0CP9fEqUC29VQ1O3271FuyE2rnq4qN3W/Q/jrWUAVh1?=
 =?us-ascii?Q?qiQPVImoIPTrWX+xDt0/tZerknIMbyyuNU1eI33bPlfXpn4zjtRi2FdMCEQI?=
 =?us-ascii?Q?pA8Gl+ndCGRFFSMkmDPYesAIvwZNqYvFRLyZO4QoK6ijmAOlMPa7eLFtrw1J?=
 =?us-ascii?Q?N2phEKYwPXNBG5n6N2MaT4xH9/1DL0PU/cAozGKYsvsAtnK6TenOKr5wHRlr?=
 =?us-ascii?Q?JLSKrwLJgN/K6rIJrCQo9g2Bjtf3MTM9ydeYx1Av+lKgZzvgFi6tqSPfb+qA?=
 =?us-ascii?Q?tnlo30WuvXnhsYCgHv+tmdS5pJEArX/Cuo3O5cOdPNIxEyknGlN/KxDqHneF?=
 =?us-ascii?Q?+8f7MOdSpYjgVMuqGZB8WUK2AAh0H+ZEv4XzFMeQUyultWPaTh0emVTpi2mK?=
 =?us-ascii?Q?p9IgGQR+kUdey0dU6z+FlIGcUsTg+nh4hc20YEexue0NoyxX4WYEkpBvzxCO?=
 =?us-ascii?Q?h1T4y4EJYBlEI5pMMq8LFiZpPGbg12DZUvCWH12Hzwvc3QstBtfV54AoYuq/?=
 =?us-ascii?Q?7BCPG/bxgQxcs5jzcydb7iWXRafXs49tBSvMltd+mWCpVazr237yFiIJrqiS?=
 =?us-ascii?Q?x/EtHFifhK3rb4L6OOQPro377aq+9SJU/FSwZ1pL8eRKJZbrTKMAvK45o3al?=
 =?us-ascii?Q?EHlFrRZZutJ5wTfW67qqTY08ohO0A4t6wStRb0Q5KXInqpDScRTQ5hQdnK7t?=
 =?us-ascii?Q?ZyJ9eFudBlHS6/JsnKAtOjytsXHYta7v+kZr+UXy3Lff3Pv53ohfT7vhEdF2?=
 =?us-ascii?Q?DBqIG+GghdXslldGnnAI5ku4Ke726MRzdfJUFRkp5PV9cuM8eJf+gSQSbreC?=
 =?us-ascii?Q?AaSr6qvGEuKhJ3jzB09i2YfH/rXi0MCuo7fem4SxNLqNkJgHIShWzTySlZ4b?=
 =?us-ascii?Q?Ua4UpNk35ciodUTzJTr8JVBINN/4nyMASb0OhADC1eK8/CMy/6EA+Z3F93B5?=
 =?us-ascii?Q?Bjl4yYChv5q3cCMp0OvQsWrIlBpde0xvXopVhWu226XE3BoN27DANMPf+RP7?=
 =?us-ascii?Q?Gmg9dt0f1jLLhss78dVBDZELE5uZTl3tIB9ac9HcULCuVGuESQxzQbo6nZdV?=
 =?us-ascii?Q?hg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c5411a-1b42-4a0e-82b2-08db5605dce1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 12:05:38.3538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qW5RK5r6kE5J0K5Rb+dQw8vjxqQd0K7ceoKzIeNm3xeUUFH/fc5VxvTlW89bYms6sRKay5C+uH9jvsLNe7xwQXh0urz7O1hrlMSex/cYAHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Monday, May 15, 2023 11:31 AM
>
>Thu, May 11, 2023 at 10:51:43PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Thursday, May 11, 2023 10:00 AM
>>>
>>>Thu, May 11, 2023 at 09:40:26AM CEST, arkadiusz.kubalewski@intel.com wro=
te:
>>>>>From: Jakub Kicinski <kuba@kernel.org>
>>>>>Sent: Thursday, May 4, 2023 11:25 PM
>>>>>
>>>>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>>>>>> >+definitions:
>>>>>> >+  -
>>>>>> >+    type: enum
>>>>>> >+    name: mode
>>>>>> >+    doc: |
>>>>>> >+      working-modes a dpll can support, differentiate if and how d=
pll
>>>>>>selects
>>>>>> >+      one of its sources to syntonize with it, valid values for
>>>>>>DPLL_A_MODE
>>>>>> >+      attribute
>>>>>> >+    entries:
>>>>>> >+      -
>>>>>> >+        name: unspec
>>>>>>
>>>>>> In general, why exactly do we need unspec values in enums and CMDs?
>>>>>> What is the usecase. If there isn't please remove.
>>>>>
>>>>>+1
>>>>>
>>>>
>>>>Sure, fixed.
>>>>
>>>>>> >+        doc: unspecified value
>>>>>> >+      -
>>>>>> >+        name: manual
>>>>>
>>>>>I think the documentation calls this "forced", still.
>>>>>
>>>>
>>>>Yes, good catch, fixed docs.
>>>>
>>>>>> >+        doc: source can be only selected by sending a request to d=
pll
>>>>>> >+      -
>>>>>> >+        name: automatic
>>>>>> >+        doc: highest prio, valid source, auto selected by dpll
>>>>>> >+      -
>>>>>> >+        name: holdover
>>>>>> >+        doc: dpll forced into holdover mode
>>>>>> >+      -
>>>>>> >+        name: freerun
>>>>>> >+        doc: dpll driven on system clk, no holdover available
>>>>>>
>>>>>> Remove "no holdover available". This is not a state, this is a mode
>>>>>> configuration. If holdover is or isn't available, is a runtime info.
>>>>>
>>>>>Agreed, seems a little confusing now. Should we expose the system clk
>>>>>as a pin to be able to force lock to it? Or there's some extra magic
>>>>>at play here?
>>>>
>>>>In freerun you cannot lock to anything it, it just uses system clock fr=
om
>>>>one of designated chip wires (which is not a part of source pins pool) =
to
>>>>feed the dpll. Dpll would only stabilize that signal and pass it furthe=
r.
>>>>Locking itself is some kind of magic, as it usually takes at least ~15
>>>>seconds before it locks to a signal once it is selected.
>>>>
>>>>>
>>>>>> >+      -
>>>>>> >+        name: nco
>>>>>> >+        doc: dpll driven by Numerically Controlled Oscillator
>>>>>
>>>>>Noob question, what is NCO in terms of implementation?
>>>>>We source the signal from an arbitrary pin and FW / driver does
>>>>>the control? Or we always use system refclk and then tune?
>>>>>
>>>>
>>>>Documentation of chip we are using, stated NCO as similar to FREERUN, a=
nd
>>>>it
>>>
>>>So how exactly this is different to freerun? Does user care or he would
>>>be fine with "freerun" in this case? My point is, isn't "NCO" some
>>>device specific thing that should be abstracted out here?
>>>
>>
>>Sure, it is device specific, some synchronizing circuits would have this
>>capability, while others would not.
>>Should be abstracted out? It is a good question.. shall user know that he=
 is
>>in
>>freerun with possibility to control the frequency or not?
>>Let's say we remove NCO, and have dpll with enabled FREERUN mode and pins
>>supporting multiple output frequencies.
>>How the one would know if those frequencies are supported only in
>>MANUAL/AUTOMATIC modes or also in the FREERUN mode?
>>In other words: As the user can I change a frequency of a dpll if active
>>mode is FREERUN?
>
>Okay, I think I'm deep in the DPLL infra you are pushing, but my
>understanding that you can control frequency in NCO mode is not present
>:/ That only means it may be confusing and not described properly.
>How do you control this frequency exactly? I see no such knob.
>

The set frequency is there already, although we miss phase offset I guess.

But I have changed my mind on having this in the kernel..
Initially I have added this mode as our HW supports it, while thinking that
dpll subsystem shall have this, and we will implement it one day..
But as we have not implemented it yet, let's leave work and discussion on
this mode for the future, when someone will actually try to implement it.

>Can't the oscilator be modeled as a pin and then you are not in freerun
>but locked this "internal pin"? We know how to control frequency there.
>

Hmm, yeah probably could work this way.


Thank you!
Arkadiusz

>
>>
>>I would say it is better to have such mode, we could argue on naming thou=
gh.
>>
>>>
>>>>runs on a SYSTEM CLOCK provided to the chip (plus some stabilization an=
d
>>>>dividers before it reaches the output).
>>>>It doesn't count as an source pin, it uses signal form dedicated wire f=
or
>>>>SYSTEM CLOCK.
>>>>In this case control over output frequency is done by synchronizer chip
>>>>firmware, but still it will not lock to any source pin signal.
>>>>
>>>>>> >+    render-max: true
>>>>>> >+  -
>>>>>> >+    type: enum
>>>>>> >+    name: lock-status
>>>>>> >+    doc: |
>>>>>> >+      provides information of dpll device lock status, valid value=
s for
>>>>>> >+      DPLL_A_LOCK_STATUS attribute
>>>>>> >+    entries:
>>>>>> >+      -
>>>>>> >+        name: unspec
>>>>>> >+        doc: unspecified value
>>>>>> >+      -
>>>>>> >+        name: unlocked
>>>>>> >+        doc: |
>>>>>> >+          dpll was not yet locked to any valid source (or is in on=
e of
>>>>>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>>>>> >+      -
>>>>>> >+        name: calibrating
>>>>>> >+        doc: dpll is trying to lock to a valid signal
>>>>>> >+      -
>>>>>> >+        name: locked
>>>>>> >+        doc: dpll is locked
>>>>>> >+      -
>>>>>> >+        name: holdover
>>>>>> >+        doc: |
>>>>>> >+          dpll is in holdover state - lost a valid lock or was for=
ced by
>>>>>> >+          selecting DPLL_MODE_HOLDOVER mode
>>>>>>
>>>>>> Is it needed to mention the holdover mode. It's slightly confusing,
>>>>>> because user might understand that the lock-status is always "holdov=
er"
>>>>>> in case of "holdover" mode. But it could be "unlocked", can't it?
>>>>>> Perhaps I don't understand the flows there correctly :/
>>>>>
>>>>>Hm, if we want to make sure that holdover mode must result in holdover
>>>>>state then we need some extra atomicity requirements on the SET
>>>>>operation. To me it seems logical enough that after setting holdover
>>>>>mode we'll end up either in holdover or unlocked status, depending on
>>>>>lock status when request reached the HW.
>>>>>
>>>>
>>>>Improved the docs:
>>>>        name: holdover
>>>>        doc: |
>>>>          dpll is in holdover state - lost a valid lock or was forced
>>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>>	  if it was not, the dpll's lock-status will remain
>>>
>>>"if it was not" does not really cope with the sentence above that. Could
>>>you iron-out the phrasing a bit please?
>>
>>
>>Hmmm,
>>        name: holdover
>>        doc: |
>>          dpll is in holdover state - lost a valid lock or was forced
>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>          if dpll lock-state was not DPLL_LOCK_STATUS_LOCKED, the
>>          dpll's lock-state shall remain DPLL_LOCK_STATUS_UNLOCKED
>>          even if DPLL_MODE_HOLDOVER was requested)
>>
>>Hope this is better?
>
>Okay.
>
>>
>>
>>Thank you!
>>Arkadiusz
>>
>>[...]

