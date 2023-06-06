Return-Path: <netdev+bounces-8602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD47724BBE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4E941C20BC3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F10E200DE;
	Tue,  6 Jun 2023 18:50:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BEC1ED3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:50:35 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC8583;
	Tue,  6 Jun 2023 11:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686077433; x=1717613433;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1whVtt5wqxmN1xZjOvp8UrHojNzFGvx21B8QH5u02Q8=;
  b=UhhZ6WbgCCg25cODr5GalPxPtaN7Nlc5uj1B0NlTEq48PY7G7Mz+d/kd
   B8QL55mnJ6JQuAaAK50ru4dPzETRYaVk+gmBtd7rEIPhpoFFkbpRH+6UV
   MYsSokZz8wrxOk5/2H3/a76zNAH3tvr6R0RO7mn7R7ECx0De6zkd57u9H
   fATIAz6BAWqkcfgMeLsCqMZkqxQNXfvPpCYi/hCtW3vZGYv34HbaphnA/
   v577RSkEkwFOcWDOWk8fdBWBoleO4LZB4HadRmKhj1W5yiQVTfwsb/Y3N
   33jijNP64PnzEvh8Sw6YmpqF/ePzWu2GKPzOA5Fl0YfJNmwDpr48t5axP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="360092981"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="360092981"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 11:50:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="686647211"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="686647211"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2023 11:50:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:50:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 11:50:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 11:50:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 11:50:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYIxtB/J62QPn8tFtWx7NrVLYkyvTqyHLwr7ZWfTrTh6zgkLkvMh82FMajGOx0rJKBi29xggBDUUJmsKyxkSi5xmHD2PkLl62AjYosm+GvbPoVmR7z8HdNL5M1S2dyir+PAy0Loa1+oRtf6H77+E6ZFz6+0DwgKG4bwE8Gluw7JYP1kVBeXW+RiEyo0a8vlLk9JnoiQhLDenSkK+zwsUlXMIiBPE8TDWSo7+7/5t5PcZb9hhjrr3z2d5GxfmZpeTlzzoUN2rBThxXZrYMnZsxLdi15WuhgXjTXeTAxyTeI3wQ59I6XbWFRUl+AQcAQnXfnU/0Kfq6OhHZYIbH/OaGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5ifddIIk5ZPxNldDEkOeU/NDgXYwQCSy9wWPs7Paro=;
 b=QZmENSrv5hqjFab78CJc55RbaXYLOpmpv78evRPx3Cq4Qv9wvt71reo0p3Zbb+b0S2jkBjshx0CqxxJB9p1edXkwk6OOf9CU76Si4bj5hvTrKGVf97xazMPewJqqAixRk/ZfOimdOh7YDLd8YtmJxDMBSIKIhDkztWQn+oWfXgocsFuX4pXv5Z87D3sGMETMuNHyC4Fh6h4VbxPEj6D+nGELWMrU1oRXvp9NeZRrbC48BvETDzmdnacFldr3lEHRkVlm9pUMqIVacNIh+a2kkWyQbqiOieble+gSTzVCL9H7qfYgMxkw+hYYPgA5Bm+qtfGWiYxONiFwTUwk4XgN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CO6PR11MB5604.namprd11.prod.outlook.com (2603:10b6:303:138::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 18:50:29 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 18:50:29 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Index: AQHZeWdERHWnlPmo9kOdLErcTLxvj69IOjkAgDYiV+A=
Date: Tue, 6 Jun 2023 18:50:29 +0000
Message-ID: <DM6PR11MB4657EB1CC7A6141632A11BC29B52A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com> <ZFIWnDjVQ1YrHBRg@nanopsycho>
In-Reply-To: <ZFIWnDjVQ1YrHBRg@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CO6PR11MB5604:EE_
x-ms-office365-filtering-correlation-id: ab5e7dee-651f-4b7d-16da-08db66bee656
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7QZXyV243x1ueMnxpanb9feDeeh5eoCJWUvF2hOG94y0o4j5BpGucVnYlWZtHym31+50MD5GcvyXH7/azHGxpbAm306hdDvGuYLqr3LFCipn+PcYvhSylRbTsaCfJFm4oijA47l59nWmKe0yaywPhP3pxRD90liC9rP0FqwmZ8pPTTeHMd13d1fCfhzauswa5XgRElZhpacOkCJ4WFIggjEs216edpaFiz4UToyA8u6qIFRiQojNppKMgPA0CgLSqW5xoWiOLtmLf5HW8y6eC8JithOYGmMp3vSgWKFG6LXQWTA7BkXnAmK/9iuUBC4kO5mSDMsxxgVRL1FqnfrCbfV6rJUXDUF0LceuD7gxFU1wF9OclC91QZHGKLLWeSeiRBxoK2MFZgV+OAwxsXLK9UwjZeR3oX+DJ4ErBGmxby8zWqV0htj/B5g5ZuY1tB1hfWssBfgbCyyq8ii+FwUgnpoPZdVOvUEK3kvLt2MGXHHxwc75CiXJwjepMh906/bfH6ZEGiOqYRmZ0r8NZK6qVWxjEf0650ES3oNDshWOJ5CPfidcZdYqyXFX1XIXVf8wBBBroK+ffqktmFaLDmT89LSdSze9kxIIDVN0vsDdx5tbfmm1GiKqLfLL/uvFzsOB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(86362001)(52536014)(122000001)(83380400001)(54906003)(110136005)(4326008)(64756008)(76116006)(38100700002)(66476007)(66946007)(66446008)(66556008)(7696005)(71200400001)(478600001)(2906002)(186003)(38070700005)(8936002)(41300700001)(8676002)(33656002)(316002)(55016003)(82960400001)(5660300002)(7416002)(26005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SXdx6lBWfE05E3ORbf5jUjceEYLoPHTvL0lUN+9wT7CilREf5M5V2VvtUisL?=
 =?us-ascii?Q?s0TKTYV5Nvf+fN7QELYuhRph5XuZnpiHSpFuZeZG2IohxFNw4h2u44boZHE/?=
 =?us-ascii?Q?Nmh7j4/G+KGbaTYfDNwkILBx5+AeXG26v75VkCiZJy6UeFThiOKmZy314usv?=
 =?us-ascii?Q?GTZRNR0ZrxK1Xq+PP5cUTFh40BAeo4auQVqXsqs6qeeqnM3mfrR112k2CCWk?=
 =?us-ascii?Q?+AneQQ7eYMn5LTxTIHQ9m4p0t9vQYRGZmXCsLCVWwox9stHlMc2p0T2WsjxV?=
 =?us-ascii?Q?WDdBCdGHzIqhAUGG4cRjXQu3B02BmbiZGI1HP6R+ExK+XcmzWuX2wZAWIci0?=
 =?us-ascii?Q?0FCvqJFkpTvApQn2O4/VMgYi+EoCppWZPwkDdTkr6bGApWVYF64KfUpxjGi7?=
 =?us-ascii?Q?AN+8Vb9RathUXzSoEdKgb7hb9vWGtXXDJ0Z9m9wmkym3y4M0E9h1MGU9f2Uw?=
 =?us-ascii?Q?24gJKK09HxbYsUaHhCroctbl9OJDGySqX8WWKG59XWFVqSwC02GilrUPMkG8?=
 =?us-ascii?Q?xcDhCI1txjRxjiwl9KUNTfcJNVPICANYtysxUC40I36e79m6G5zff5X6i447?=
 =?us-ascii?Q?z1BlSufavIWWdNngWyhG+aOzViZsrD8E4d9wGqv+qua39p+xnr/9OSngD/y4?=
 =?us-ascii?Q?i5U8yJE+t98s/me8LmypqeZo0usjMBE6liT+CSXAmnIN40FnlPe/l9CrtdOi?=
 =?us-ascii?Q?G3DO4rQ3rGXA29nEB3iRxbWnStUIAM9SZQDRdiXvJY20VTctxbFrT+W62bKG?=
 =?us-ascii?Q?DFPWUdYYI1LuX86pl2EC+oFEzW6mMD15RN0lwvD+a3uhqh03KpmDxjaJi5hC?=
 =?us-ascii?Q?mj7VRt0lTLnI3SYAfqadxEXlKVBSpBHPClzQWXS9bRwHqyq/EgT/5d9tD9b8?=
 =?us-ascii?Q?LFvxgPAipnW0T+fXeJ9NIgwZFBxE8kpzHEMr14CwAuCpPLh6NnDG6lyqDw52?=
 =?us-ascii?Q?fKEeMnWuypz/lLMJj56CLyWKvGj8y43ZPfBEchxyT0HYwDn394HIW7A1UPv6?=
 =?us-ascii?Q?x7SS34GlS1yZ2grYvO+BK4hGQNijzWt2NDL74Z4yhTtflGS9At+z0YpOB7Gx?=
 =?us-ascii?Q?ekTkxMgegCx9Sl8tO2VbeRs6Al70lGfD+LKGA8OaS4+QQl08EDd6V6/sqPw1?=
 =?us-ascii?Q?QvmJ3qiIoNQm4fnAoI7wYU2hRJuJ/Ik+DYQNDLEs86Ch18YxYikOTE3t2JKx?=
 =?us-ascii?Q?MtBX20V9aCD9ozFEWSSY7vYRedupTFFqyz/ZZABsEMxp1EAy1+GLepy+H6k+?=
 =?us-ascii?Q?zDGgdfYScHsq2ZRGXLtsprZYRh8p7F2oEmxRRbQS5dO0s0u4uSzl798Nj2FV?=
 =?us-ascii?Q?iZroxnPqdpUqHyB5etQ+2kcAh+FNPksHKq/oi8sw7E3GU1fxFVSVltfiOkc0?=
 =?us-ascii?Q?9gaMN5qRNELmUThYziW6iLgHlcO4ZuGeRz4n7hyjFOiZN9reyGTyZSSD0BV7?=
 =?us-ascii?Q?z9FBRJHWsDP48iwkgQ15D9iHsVsBvVAg4urHsBCCSj5tF+KijzFInFgbPFiB?=
 =?us-ascii?Q?y1Sswwvb9vzohZu/+RlxO44Y4ndN8VAz/smP/pylTkHttJ4XU5As3i1cWPlX?=
 =?us-ascii?Q?YLbb+Wi7pjST4pZ3ddWe708lciJfX3s8Vx9dScKcP1D9RT3qQQfQVocwT+XK?=
 =?us-ascii?Q?Yg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5e7dee-651f-4b7d-16da-08db66bee656
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 18:50:29.7136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qz2C5Rleusk+lx90pyssx3FudaMouIIA8erIYgfcokhoLW/bW/l644B/GAIFieWYzAsep5sIPBPok2xcpQfDnQRFdRboPJu8BjW2ldou3Po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5604
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, May 3, 2023 10:09 AM
>
>Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>
>[...]
>
>
>>+static struct dpll_pin *
>>+dpll_pin_alloc(u64 clock_id, u8 pin_idx, struct module *module,
>>+	       const struct dpll_pin_properties *prop)
>>+{
>>+	struct dpll_pin *pin;
>>+	int ret, fs_size;
>>+
>>+	pin =3D kzalloc(sizeof(*pin), GFP_KERNEL);
>>+	if (!pin)
>>+		return ERR_PTR(-ENOMEM);
>>+	pin->pin_idx =3D pin_idx;
>>+	pin->clock_id =3D clock_id;
>>+	pin->module =3D module;
>>+	refcount_set(&pin->refcount, 1);
>>+	if (WARN_ON(!prop->label)) {
>
>Why exactly label has to be mandatory? In mlx5, I have no use for it.
>Please make it optional. IIRC, I asked for this in the last review
>as well.
>

Fixed.

>
>>+		ret =3D -EINVAL;
>>+		goto err;
>>+	}
>>+	pin->prop.label =3D kstrdup(prop->label, GFP_KERNEL);
>
>Labels should be static const string. Do you see a usecase when you need
>to dup it? If not, remove this please.
>

Fixed.

Thank you,
Arkadiusz
>
>
>>+	if (!pin->prop.label) {
>>+		ret =3D -ENOMEM;
>>+		goto err;
>>+	}
>
>
>[...]

