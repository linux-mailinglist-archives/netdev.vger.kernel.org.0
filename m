Return-Path: <netdev+bounces-1727-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 798536FEFD3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 826011C20F3F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B19B1C77D;
	Thu, 11 May 2023 10:23:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470081C747
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:23:16 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23943E5A;
	Thu, 11 May 2023 03:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683800594; x=1715336594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KUXLhP5n1q6m/RJjVJUtKBwAgDT9hdHpSKx2HCXFQZ8=;
  b=LtwvpAZB9IZpeo40srIm06yU5SXtBBgI6kcWNrlje21HUXj5wkm7T2UB
   JLa9fwlQA9Fx+ZG1WO7xN2qEKQU2z6EGhJcdeTcdA93Gb9bqUPYcD4OHd
   kd+jynojsj0rheeR76uOKdTvvYPQocyUuvqIz40Rvic3S+d9r+xuhgfTD
   88K0Cwzg0qnsEmO0uak7XgXHMPIHoz/tEBY67l6v/sOVsCQ8EZBex96bt
   MXe8tSB8e4X1e/VhBQyHxLSMLJiNbwzVXSqqpPyjBWsURjrNGDWRTHRJA
   q4KNXutmNPAMoqY34YFmjlUe/ly91tCWSI5F3VEnCLx4JHAm/qfhjRqkM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="330082554"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="330082554"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 03:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="650109203"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="650109203"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2023 03:23:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 03:23:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 03:23:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 03:23:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 03:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFRuyiR+fOeLt8zU5ty68Lj7wyWB7YUpRVOLO9nHiEKpByYGulrM3P50yF2+bm9YHcBFSI5zlAX4NxeUWp/DTjFUNHIDeiZNV9u1zdvgcuXkNzUkw2jEeCkOC+eBbZsQb57aTJOHPW6lT3gXuuQwefjzq9S2XI0aCDbD4zTMZKHIBUlnd4FlE6+UYEbj0sfiWkkcJqPkG4sr/sVWC1XDaNU03E0MTauJEDQkUDye0SWEgTFaHBYuSE4bhoyUXlb0hTxz1mSz4RN4d8VwGk4kW7hCcozXN2y4en3RMAQ1X303pysffaWFTbe2tX6YSPuUk1NlWgLrnxk91raKWgaA+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMpRAlVgVk6RU5G5xT5axW/r6EG/PMLSo3tOpxoZ8WI=;
 b=gr1uwc/DvGKkWdN2XVfo4TGs8MnylgyzbbcCyOxi4GtH++eP15FJ+VCAqERgVeYFkC5edotuvskzv6ZGi81O/vkp85GY0Gct/JDqTeV6h6sUzkWBc1svYnOmUnH9/e7FfytFCY3a00uNOgPfFHKMkQSZwuxVp9SP2V2byA6Sc72GJeKWPMIMzhM1SznGf824hdZm+V0Y/qmnhjr8kt3KbG83HK1DorTQlxvd4pHJQWoOj3OIr78rwYJEOn72Ia7vw9sNzdoCfdgzmrDOtph67QVOkeq6HmL+7c50arZwPWCfBUZNNGIZptCzMLgJGR0Y5LUqmbU7ZgqYlH+BJFUObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SN7PR11MB6601.namprd11.prod.outlook.com (2603:10b6:806:273::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:23:07 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.022; Thu, 11 May 2023
 10:23:06 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
CC: Vadim Fedorenko <vadfed@meta.com>, Jiri Pirko <jiri@resnulli.us>,
	"Jonathan Lemon" <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 3/8] dpll: documentation on DPLL subsystem
 interface
Thread-Topic: [RFC PATCH v7 3/8] dpll: documentation on DPLL subsystem
 interface
Thread-Index: AQHZeWdHKMdPMbaEvUGy14WAo+ctW69Kg7SAgAExNICAACUUgIAJEtPA
Date: Thu, 11 May 2023 10:23:06 +0000
Message-ID: <DM6PR11MB4657E8F5D86C1FA5AA38758E9B749@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-4-vadfed@meta.com>
	<20230504120431.036cb8ba@kernel.org>
	<7be22f4a-3fd5-f579-6824-56b4feafdb03@linux.dev>
 <20230505082935.24deca78@kernel.org>
In-Reply-To: <20230505082935.24deca78@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SN7PR11MB6601:EE_
x-ms-office365-filtering-correlation-id: f9744fd0-6308-4fc6-e34b-08db5209b610
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s5mdEMOeSykwXs9vkm8TO6ECiiKLN3awufr358Vld7ym5o82IiRKQ4JRg7ckZUsl+KkyhnuIGzm4HNhrIhIbc/PJRGG2nrare6H3dJ8gM3vfejf3Hpo+Lrnld1p8eZFAMo4gdMroqToFTBCBPo2DoxHjG/JMKXjXcb9eoSRahXTKuPypzHjdOZjTOuL2Oa9stYUyUUnyxRvDYtOo+poWZfOLBvKaBfifS+erhnRk0hlJkUEZnKnuyclyB7QJix+dUeGXnQk5Vj1LkrLBRxM0gbpiSznnCvEj4btlCCLslslK/BJavmd15/eQo1wt7pbZY4m4R9/jcBJrP0UE0WifhZqmsp7RSEw6cfVPRJlAiNSBaNIxD/ADTS5bzLz85Ml+a46rcilWegLF9fVZiCpI4jkQBQxATzJfBJ8cPZwokpHos5PW/HGFU86mmXBq/RYFqyebRBDLDYyqE3B71ofEFsxKZvMd/LLvrU2yZKDZzd+UN8pycwdJMJOJZeOzffaG/14G6H7XETJPPbsDtZLd0m/umMX2LnSXWbn0dqA+uWIVt3YPAaLuLaz4gCEE8+ipk2hR05HOFaNdFUCSkbKCRVfTn5zgS5dOyUTColmYnz6Nzmiv6ufqDDyw8g21WYNp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(66899021)(7416002)(38100700002)(64756008)(2906002)(66476007)(8676002)(38070700005)(66446008)(86362001)(316002)(5660300002)(66946007)(82960400001)(122000001)(55016003)(8936002)(66556008)(41300700001)(52536014)(4326008)(76116006)(71200400001)(54906003)(83380400001)(110136005)(9686003)(6506007)(33656002)(7696005)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W0Y+z0vLcMa1oAY8bo3R/TboPA5PmOYxtOSUNIZtMav1QY20Dpr+u+3faJF4?=
 =?us-ascii?Q?N8U2q21ZzWhok2IFfGRRRZzqzNqv5aG2PrmQv1GAdbP9jzxJJdBZmCF0NSt+?=
 =?us-ascii?Q?qqlFDkIS6LLn8COREqqUoaVsjlQdDbGZBtuWYdd9tVlcFpamo1hY8riiQsAM?=
 =?us-ascii?Q?4SWuqq+BU80Uv4py+MiiddvCWwPIUchATuSzoaGgSTxX9KYt1ySGiNYCE2kE?=
 =?us-ascii?Q?qjyNBGT+s2+2dMdSe2YoMss6+9sgNASBxRIMsr8QmAa2BKSpMkItBSIcYy4M?=
 =?us-ascii?Q?OP2lz7NPXuD82PK8qpq/+NcHzxNRbXZvf1tHDbr2ejq0JbMwHKqGlLjr/dq1?=
 =?us-ascii?Q?M8joFdgyCUaIM9FKmhHqQ+qni5cBNi+GC6rHgk2Dc/eVWq6U4lU3Pi9SGnTX?=
 =?us-ascii?Q?x1LcU8llCb5qe+47JmNOTsZ+BbyOoImsjwMNackV6aN5kttE6dIReRnXiV3U?=
 =?us-ascii?Q?X86Ha45u7fkPeCawI6mR76VjmaUN2S+OYcESDE0UmlW1whUdAho3BN1DOsGv?=
 =?us-ascii?Q?qJ8O+ppt30SvfYDPr8VeXHI6DYnt/vlvwcpqsbpZntSFp+GmjBkYchM/0qir?=
 =?us-ascii?Q?XRHTn9/lSyp8elNt34Zk50QjE7t+xcq55mxTnZM/8I0H2t5TpoZpAGXbJJgl?=
 =?us-ascii?Q?w47drG6ly6z4VDZHKltVHJ3Yl5s/rBftcHJbzmatK85IA3SHzHvXSFUSKhQ6?=
 =?us-ascii?Q?bP38GDYenOno1GGZB2lWzXw3QHJIma/oqLL5OC+j6ncPHNcJaG/C736VpXa1?=
 =?us-ascii?Q?A7DIWArSxN4xt9wTcKE3bsA50a5hNM8k7v0s8KE/sXKfBgUX81lGshIeyD27?=
 =?us-ascii?Q?wD/4Dl5Fv+mYh6YoYPioPf2U0j2BjQ7JhLxo6M+D4XTTMGxmEL3vxk3Wo+jj?=
 =?us-ascii?Q?hi4dKr3qaK72PNvHzdu+l29gsCVgV8z+4Zfk1gSfxcGyklef7EDPTUSm1uLz?=
 =?us-ascii?Q?xlqxEwV4ZMLi7iT8XkBaVJidPdsfN8nUWcyeACJNZU9TGzjfWZi+bdd8UrMV?=
 =?us-ascii?Q?/1lZMdFUbpu+b4n3tcDMmgn/XMJeB8EDdcbaCPitvgfmEPN5mlTI5iJdftSG?=
 =?us-ascii?Q?azpOdNGmbVwiBI+uZI5IUPiO6mLiBffppDFefF/i7aiZZeOmUmKLWecfiZWt?=
 =?us-ascii?Q?dmj5OZax4IXPxknxToKYN88fqzygwzuF1Xocle01ObpD2/2WhihBWXeJ0sbm?=
 =?us-ascii?Q?53cseRiyNy+u6Y7NpIYwYMpZmfDE5N0MxXeLpbz7KY2eLJSlLHdHT3uwlgyb?=
 =?us-ascii?Q?UKU4MV4L3BZlXuWXXqksKJkFUDY+7g6pmwXeoFe/D5TBXqdd29qkvuaFHRCH?=
 =?us-ascii?Q?3lmcVFmwN836r2aTyui3pAtEE8fCqU3fIgzSaoD0cOyqdLLAIwsaDGZagTXb?=
 =?us-ascii?Q?ShSi3jJbN4G8Nq8scJ5RF/08qtbceZZDOcjMGoP4bYXceg9Oywj3IMdczgrk?=
 =?us-ascii?Q?yKFPXUYoKZTdl//q3166LjTm3K3zBOiDpaMGHUuQdWuWZHaLJHqRpm+c1WlX?=
 =?us-ascii?Q?wTt1YDU24KAoFZKR3U0uGLtEtZ5W3Sr8o9/+kvoVfRStIPhYbALHJHN3D7Z7?=
 =?us-ascii?Q?oy10ujDYuj+LFBCFygh1UJcYOO25gXJcM434yKkq?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f9744fd0-6308-4fc6-e34b-08db5209b610
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 10:23:06.5400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t9xmig+Uf7aSKiexrXBE+qdeoKjUb96ehRoJLF31qWtiuS+zphLthw0d0dByBtqR2DK98YnQ9GRxR7ujlgLPjSFj1vzIaKlIL/vLNmX2LK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, May 5, 2023 5:30 PM
>
>On Fri, 5 May 2023 14:16:53 +0100 Vadim Fedorenko wrote:
>> >> +Then there are two groups of configuration knobs:
>> >> +1) Set on a pin - the configuration affects all dpll devices pin is
>> >> +   registered to. (i.e. ``PIN_FREQUENCY``, ``PIN_DIRECTION``),
>> >
>> > Why is direction set on a pin? We can't chain DPLLs?
>>
>> We can chain DPLLs using pins only. We don't have any interface to
>> configure 2 pins to connect 2 different DPLLs to each other at the same
>> time. The configuration should take care of one pin being input and
>> other one being output. That's why we have direction property attached
>> to the pin, not the DPLL itself.
>
>Makes sense.

Hmmm, actually we already can register the same pin with 2 dplls, and it co=
uld
identify itself as an input for one dpll and as an output for the other. It
makes sense as change on one pin would again inform both dplls.

The dpll_pin_direction_get/set callbacks are already called with dpll, so
we are good, only one change would be needed is to move PIN_DIRECTION to th=
e
pin-dpll configuration tuples on `pin-get`.

Thus, actually it looks like a bug now:
- pin-dpll tuple may report different direction for each dpll pin was
registered with
- userspace see this as pin specific property, but it would return differen=
t
values depending on which dpll was given as arg for pin-get command.

I will fix it, as it relates to the modifying spec in first place.

>
>> >> +Device driver implementation
>> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> >> +
>> >> +Device is allocated by ``dpll_device_get`` call. Second call with th=
e
>> >> +same arguments doesn't create new object but provides pointer to
>> >> +previously created device for given arguments, it also increase refc=
ount
>> >> +of that object.
>> >> +Device is deallocated by ``dpll_device_put`` call, which first decre=
ases
>> >> +the refcount, once refcount is cleared the object is destroyed.
>> >
>> > You can add () after the function name and render the kdoc at the end
>> > of this doc. The `` marking will then be unnecessary.
>> >
>> Mmm... any examples of such a way of creating documentation? I was
>> following tls*.rst style, but without copying code-blocks.
>
>net_dim.rst, maybe?  driver.rst ? Feel free to ping me 1:1 if you're
>struggling, it should be fairly straightforward.

