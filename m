Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2AC68B408
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 03:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBFCAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 21:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBFCAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 21:00:18 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D87F18B10;
        Sun,  5 Feb 2023 18:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675648814; x=1707184814;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wfY34p8O5dVQHdzdK88VpLRkhEgR2dDAi/ayForDLNU=;
  b=dv6lAiy0l/TDOL2jHzmdgwR/8LN0pO/bjAJuxxNbUnvXoa5cwp7zdAKP
   JrnpqR7KizRYkdZZKGo4tCK9F0o+KZ9YouPWBbtlX+xUmf34DBUEvbIno
   39965LO0DT8HjNjRq4rnvIGAAbrZlHZRVhSsrLhRtUtPrQ7iJ0U13E/YD
   hiHXutDxc+T+P2bs5es7GiJSWRld3lqvOlBCOWPpSkFYhoOQiqqDQd7Dx
   PMMooTqaYeTPslmm+aJgQQNgSOF0uT+CUEDzwzaEIxyZByp8ThF+Y5+WO
   tlVI+NVkpQpqPIU/f8O6lgxpNl01y3hCFr7uXq0vF+hK/lWaTPgrdtUZA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="308757593"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="308757593"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 18:00:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="668265211"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="668265211"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 05 Feb 2023 18:00:13 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 18:00:13 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 18:00:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 5 Feb 2023 18:00:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 5 Feb 2023 18:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMBai7CVjQ93rt1QQPVJR2RFYiDjgQ9BQFxjZzV7L1jiyz0YK+PMcBN+vXHpkXqIdRVbVP02i+ZIMItAFeZbhIrmg24oYIk9CFnqcA2DSQrfr/UPzRvraHitVoBQfl33xNtaG/gZEpGrpDNXUguVE8MK62iERF7pQfFB/VGSZ+C3fyIQFeQ6y5mJ3ppIdJox5CkG8nFxc30DXZl7wq8/m3I40yu35PU7mlf4RosyiA59cTFrcSD7RmS5PtoMAjTYPewOQlaSSKnhEagCJH6b7XRU46S6tVgG8efNKZuM0d8976tOvo1Ia06xY3uDH/VbCdeCtOoZQ/IIwXElF7JyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYJtH/uue6V0bHTne+BfEOvmMJOSmoEpdtwoNH2oYcU=;
 b=FP29o4RV1HJyd7uvQZigDHHUIuBAJKtGOUjF/M0YZ2C4L+t/nLQmlO0hbF5OCNWffYjzFhriyHk6I0Hs+meCjM+69sm1xaDqI/mTsU1FMuIMZxs5289f2bTGcOwWRJHG4N78QoHx0jn2aU/j1rcgf+L/QDD/PYBCSkEN0RbTMxZNPvHoSFnPGoao0FnAQSIyd5cbRYf0mdaPn9N9iLTeOaGulKvFkF7b0KC9kj/DJkCHMDgjy8FQMyyJEwmWvvhWztXNqTwWTqidnhoK/1PlO1IqFFiVBa9/KDi60SlHzxK4Gbt3mqXplToA3HffITl6yj8g65KjwhmKQ5LiFEBxSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CO1PR11MB5122.namprd11.prod.outlook.com (2603:10b6:303:95::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.31; Mon, 6 Feb 2023 02:00:09 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%8]) with mapi id 15.20.6064.028; Mon, 6 Feb 2023
 02:00:09 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZKp4K9cfIHTE4HkioJShQwVs1zK6l/jqAgAyiMiCABgMagIAIpJoQ
Date:   Mon, 6 Feb 2023 02:00:09 +0000
Message-ID: <DM6PR11MB46576B19A5DBA46C20AC26679BDA9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-2-vadfed@meta.com> <Y8l63RF8DQz3i0LY@nanopsycho>
 <DM6PR11MB46575F782A66620E1A2D04229BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y9ke/+0z3r6WOjWn@nanopsycho>
In-Reply-To: <Y9ke/+0z3r6WOjWn@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CO1PR11MB5122:EE_
x-ms-office365-filtering-correlation-id: f8f2f1c4-0f37-4abb-ebed-08db07e5e04a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MjbtQ5EAw579MKGB4YK/+UdbVMUEEhmfBHqZKkh5GGIfgtES8fxAX+c7tCa2J5WlvQnmBIB/VYKFXNbQ3kuYNkUj0MdsvJovgoz76AW6tGktnCbCdNhVzfuyxgS9vBWjO5nfJAglEC+opCXJ2TezRaqzZMoDmt/5Ag+x+39c0SCX4B+jeATsfAytF7nSXRdzMjYVHUmKZGkjsgH2HuYxHcgEj7L2TSMnuFgIBGjE11WmLDa6HiXlmeswSmEUy+oibS/9I72Dm/9TGlfNLELsmh5wxcDtFgul77lTQ3i6gXzafXBLC+y/f8FsdSuGUCqwwFHZpxhDOVqe/4f3JzytowOi5j8DbXr+ZC0DxuY/GgslvS31lHm4c3nX0Zfj2QiX8JpDGDp97S2qk0UMdJEQv9h8RRmgkJdWaG7yT677IOdubJyGfhlVhi7zIN4mNwKszTjB+RdUtHW5CEM/cbb7AeMuxbtzMqjVLU2Qal91Ou6paNkfRRhsCJrsOFtEk/zaRtiuEJ6N9u/QWoIMH6OtRVBJLL+mo/Lg9j1t9SLSDFHvzzzpvklwBRhI0KyLBx5tm0KZehabii8QiLLYUOfOL0AmK5WSsltSIaMaDupIqLs4osWgzqoML6IKS2QgKSVGnkz8WQjqO0clV7dF3Mb9IUKqpojdZEA29oDlqcOsTnsXj4GF1MGAnne1pw/R/TK3aWpzKVAtjJkxgPYuLnfEGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(2906002)(30864003)(82960400001)(26005)(7696005)(6506007)(9686003)(55016003)(186003)(66476007)(66556008)(76116006)(4326008)(66446008)(66946007)(64756008)(38070700005)(316002)(8676002)(86362001)(5660300002)(52536014)(6916009)(33656002)(478600001)(54906003)(8936002)(83380400001)(71200400001)(41300700001)(38100700002)(122000001)(107886003)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V7KwCZobP+QaLqLMrYSv/N+cCmLnyFx1gOtYQo5CLQBNCMHuRQ9k0NBU82+F?=
 =?us-ascii?Q?pmb9ufq+UAslyKuMIBAOTmBmMC+rWK1pEa5BEjIf24QFoVCEDRE4+Auinsp3?=
 =?us-ascii?Q?pnM+jsctZLsArXdJcka/ngksWrbOQvVj9NSg4d4Ffe6QUMBo49/PN15uLunG?=
 =?us-ascii?Q?NhipglW9qcn4jt/yrC6b1pgRBEuymlE6HOxGlVh110AOgIGpfj4yPNCldpi4?=
 =?us-ascii?Q?r85om+WBcUXtMP4vU55QdXRl2lUBk9l94fZqLieumLrJrcn6QmOoVpyN6FeI?=
 =?us-ascii?Q?5MbMaMJOm7MyDhcgdO+mxQfZD5F/JKNv0SzV5l/4PaCxhKX8EP+9HBWzFDnq?=
 =?us-ascii?Q?g/pXYjhFQk2SBEMlfHkKJDj3DOyEuCfRCislcVCIcRkIgG0Gpys5bAlz3wLi?=
 =?us-ascii?Q?2XzfGH9hnAV12saZPkv3VQugsZHP+JFjZRmRyZr561W3/+sfcpyBjE+Tbbcg?=
 =?us-ascii?Q?ZfKKxHz6chwXiq8ZUJ9wtx/jVZkRTlDTJuRIBpF8uZ4h0ZOYzL2/oo7ghv8n?=
 =?us-ascii?Q?p46U1kwFV2quxtYKiI9imdU/tubd9Cmh2vNZgTR7XQ83VHAJ5MQq50sPolyX?=
 =?us-ascii?Q?5pZHPRLiU7pp+6q8WMHcAwS5lCWQEssRQ3N7MlHaq0iz6ZtaP+Dg0/AiZDTs?=
 =?us-ascii?Q?P/k6SNFXNOHNZ+D+fTFvXqvq/BA56rlyU6uSMaaJy3scJnXzvi1FS9sDqeCt?=
 =?us-ascii?Q?18ItFCjatv+9edIJzZQrbsDlP6PYyoSirL84Jhxc6NeCs2BkIIwum15vYtk4?=
 =?us-ascii?Q?kouve9D9s8M+IDmLGkXdgNAoRrp6ar2Gv7MqZgkD5I0dQ5/2UINNVyl+Kz5/?=
 =?us-ascii?Q?yqJt1XEvDluvkysAIsSNt0vsz9p28Vo8rIatmtGJnkGgYXdfihhUcnlXTWQw?=
 =?us-ascii?Q?wIJQEa8g2T2qugj9a/E7TscWrKikt5bMJuFnpuknO5uPtIZ8bw6bgwK1+k9i?=
 =?us-ascii?Q?7/RJHxztIeSBHXvt2UqaC+l75D+koKsfas7nns49VTSB3MNpeijc+rWj+XoY?=
 =?us-ascii?Q?94q2KDe7/fo59kP5/Oez6KrtVGghoaRTcLrOHoLORG6Qhp95E7Cstn4C6Wdn?=
 =?us-ascii?Q?aDE57cINoyDcVAXypuSC/qH4b97YKFbjC0dKcSMqK80wrNeSrIuQhCIHf598?=
 =?us-ascii?Q?yuqM+6HowJxsUwuzXnkfGZN6KZDic0RIc8R1fQ2F7zOhL9saV5tCru69EuUL?=
 =?us-ascii?Q?ZvUgNa9Q/E5609QRl051HkY6gmohgeOWkEhWG7XXM7icllIcU7PYnFP/A4Zh?=
 =?us-ascii?Q?tQyO/chYHp/TODVvqDKBW9uHK7pg1DWsOxq594A0jDrVXeBjdFUWZNf9xU7a?=
 =?us-ascii?Q?fMjVEg88F3i3J178bhWbcHbCucr2PEzNHc820eTgQ6o6HO/gIWDjOLBGuNNT?=
 =?us-ascii?Q?MbX2NQA0ZSXDcT9PXUG0ddRBi56jEHLquTnG3lR0VbJHSRrL/2MOH4S7BksG?=
 =?us-ascii?Q?SryuJvf5UleL1W4YddwWbG7RL+ILibyv7DAOK0Kntk73uZk+drZGw+KWemTn?=
 =?us-ascii?Q?qPIf5qmwhuFmmJmvUQrl+XQKIYodRVofW+fbcqO/NPCNr+Uk0dDs6O44fut1?=
 =?us-ascii?Q?TrjLgF55mZXYJjuzYmJyiAuwSIt8zmuh2Lotcfa2ziLqjeTzCEj0k7RkJigS?=
 =?us-ascii?Q?EA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f2f1c4-0f37-4abb-ebed-08db07e5e04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 02:00:09.4500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /nzOpaPtWxxDax3PQVyxkDaMsbsir1zy8NUGFze+HIa43XZQI6V9cZvKTYBpNfN+Gh5g9Z7KbkOCC5fcTl3nA2mhZhJUlB9jpdUb8S++Rq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5122
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
>Sent: Tuesday, January 31, 2023 3:01 PM
>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>Cc: Vadim Fedorenko <vadfed@meta.com>; Jakub Kicinski <kuba@kernel.org>;
>Jonathan Lemon <jonathan.lemon@gmail.com>; Paolo Abeni <pabeni@redhat.com>=
;
>netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>clk@vger.kernel.org; Olech, Milena <milena.olech@intel.com>; Michalik,
>Michal <michal.michalik@intel.com>
>Subject: Re: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
>
>Fri, Jan 27, 2023 at 07:12:41PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Thursday, January 19, 2023 6:16 PM
>>>
>>>Tue, Jan 17, 2023 at 07:00:48PM CET, vadfed@meta.com wrote:
>
>[...]
>
>
>>>>+struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
>>>
>>>Hmm, don't you want to put an owner module as an arg here as well? I
>>>don't see how could 2 modules sanely work with the same dpll instance.
>>>
>>
>>Sorry, I don't get it.
>>How the driver that needs to find a dpll would know the owner module?
>
>Something like:
>dpll =3D dpll_device_get(ops, THIS_MODULE, ...)
>if (IS_ERR(dpll))
>	..
>

Oh yeah, sure, probably can do this.

>
>>The idea of this is to let another driver instance to find a dpll device
>>already registered in OS.
>>The driver that is searching dpll device is not the same as the one that
>>has
>>created the device, otherwise it wouldn't make any sense?
>
>You have to distinguish driver/driver_instance. It it is not the same
>driver(module), something is seriously wrong here.
>

Sure, will try to use THIS_MODULE as suggested in next version.

>
>>
>>>
>>>>+						enum dpll_type type, u8 idx)
>>>>+{
>>>>+	struct dpll_device *dpll, *ret =3D NULL;
>>>>+	unsigned long index;
>>>>+
>>>>+	mutex_lock(&dpll_device_xa_lock);
>>>>+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
>>>>+		if (dpll->clock_id =3D=3D clock_id) {
>>>>+			if (dpll->type =3D=3D type) {
>>>>+				if (dpll->dev_driver_idx =3D=3D idx) {
>>>>+					ret =3D dpll;
>>>>+					break;
>>>>+				}
>>>>+			}
>>>>+		}
>>>>+	}
>>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>>+
>>>>+	return ret;
>>>>+}
>>>>+EXPORT_SYMBOL_GPL(dpll_device_get_by_clock_id);
>>>>+
>>>>+static void dpll_device_release(struct device *dev)
>>>>+{
>>>>+	struct dpll_device *dpll;
>>>>+
>>>>+	mutex_lock(&dpll_device_xa_lock);
>>>>+	dpll =3D to_dpll_device(dev);
>>>>+	dpll_device_unregister(dpll);
>>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>>+	dpll_device_free(dpll);
>>>>+}
>>>>+
>>>>+static struct class dpll_class =3D {
>>>>+	.name =3D "dpll",
>>>>+	.dev_release =3D dpll_device_release,
>>>
>>>Why do you want to do this? Why the driver cannot do
>>>dpll_device_unregister/free() manually. I think it makes things easier
>>>to read then to rely on dev garbage collector.
>>>
>>
>>This was in the first version submitted by Vadim.
>>I think we can remove it, unless someone has different view?
>
>Cool.
>
>
>>
>>>
>>>>+};
>>>>+
>>>>+struct dpll_device
>>>>+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
>>>>+		   const u64 clock_id, enum dpll_clock_class clock_class,
>>>>+		   u8 dev_driver_idx, void *priv, struct device *parent)
>>>>+{
>>>>+	struct dpll_device *dpll;
>>>>+	int ret;
>>>>+
>>>>+	dpll =3D kzalloc(sizeof(*dpll), GFP_KERNEL);
>>>>+	if (!dpll)
>>>>+		return ERR_PTR(-ENOMEM);
>>>>+
>>>>+	mutex_init(&dpll->lock);
>>>>+	dpll->ops =3D ops;
>>>>+	dpll->dev.class =3D &dpll_class;
>>>>+	dpll->parent =3D parent;
>>>>+	dpll->type =3D type;
>>>>+	dpll->dev_driver_idx =3D dev_driver_idx;
>>>>+	dpll->clock_id =3D clock_id;
>>>>+	dpll->clock_class =3D clock_class;
>>>>+
>>>>+	mutex_lock(&dpll_device_xa_lock);
>>>>+	ret =3D xa_alloc(&dpll_device_xa, &dpll->id, dpll,
>>>>+		       xa_limit_16b, GFP_KERNEL);
>>>>+	if (ret)
>>>>+		goto error;
>>>>+	dev_set_name(&dpll->dev, "dpll_%s_%d_%d", dev_name(parent), type,
>>>>+		     dev_driver_idx);
>>>>+	dpll->priv =3D priv;
>>>>+	xa_init_flags(&dpll->pins, XA_FLAGS_ALLOC);
>>>>+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>>>
>>>What is exactly the point of using this mark?
>>>
>>
>>I think this can be also removed now, as there is no separated
>>alloc/register
>>for newly created dpll device.
>
>Cool.
>
>
>>
>>>
>>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>>+	dpll_notify_device_create(dpll);
>>>>+
>>>>+	return dpll;
>>>>+
>>>>+error:
>>>>+	mutex_unlock(&dpll_device_xa_lock);
>>>>+	kfree(dpll);
>>>>+	return ERR_PTR(ret);
>>>>+}
>>>>+EXPORT_SYMBOL_GPL(dpll_device_alloc);
>
>[...]
>
>
>>>>+			return -EEXIST;
>>>>+	}
>>>>+
>>>>+	ret =3D xa_alloc(pins, &pin->idx, pin, xa_limit_16b, GFP_KERNEL);
>>>>+	if (!ret)
>>>>+		xa_set_mark(pins, pin->idx, PIN_REGISTERED);
>>>
>>>What is exactly the point of having this mark?
>>>
>>
>>Think this could be now removed, we got rid of separated alloc/register
>>for
>>dpll device.
>
>Cool.
>
>
>>
>>>
>>>>+
>>>>+	return ret;
>>>>+}
>>>>+
>>>>+static int dpll_pin_ref_add(struct dpll_pin *pin, struct dpll_device
>>>>*dpll,
>>>>+			    struct dpll_pin_ops *ops, void *priv)
>>>>+{
>>>>+	struct dpll_pin_ref *ref, *pos;
>>>>+	unsigned long index;
>>>>+	u32 idx;
>>>>+
>>>>+	ref =3D kzalloc(sizeof(struct dpll_pin_ref), GFP_KERNEL);
>>>>+	if (!ref)
>>>>+		return -ENOMEM;
>>>>+	ref->dpll =3D dpll;
>>>>+	ref->ops =3D ops;
>>>>+	ref->priv =3D priv;
>>>>+	if (!xa_empty(&pin->ref_dplls)) {
>>>
>>>Pointless check. Just do iterate.
>>>
>>
>>Sure, will do.
>>
>>>
>>>>+		xa_for_each(&pin->ref_dplls, index, pos) {
>>>>+			if (pos->dpll =3D=3D ref->dpll)
>>>>+				return -EEXIST;
>>>>+		}
>>>>+	}
>>>>+
>>>>+	return xa_alloc(&pin->ref_dplls, &idx, ref, xa_limit_16b,
>>>>GFP_KERNEL);
>>>>+}
>>>>+
>>>>+static void dpll_pin_ref_del(struct dpll_pin *pin, struct dpll_device
>>>>*dpll)
>>>>+{
>>>>+	struct dpll_pin_ref *pos;
>>>>+	unsigned long index;
>>>>+
>>>>+	xa_for_each(&pin->ref_dplls, index, pos) {
>>>>+		if (pos->dpll =3D=3D dpll) {
>>>>+			WARN_ON_ONCE(pos !=3D xa_erase(&pin->ref_dplls, index));
>>>>+			break;
>>>>+		}
>>>>+	}
>>>>+}
>>>>+
>>>>+static int pin_deregister_from_xa(struct xarray *xa_pins, struct
>>dpll_pin
>>>>*pin)
>>>
>>>1) dpll_ prefix
>>
>>Sure, will do.
>>
>>>2) "deregister" is odd name
>>
>>Rodger that, will fix.
>>
>>>3) why don't you have it next to dpll_alloc_pin_on_xa() as it is a
>>>   symmetric function?
>>
>>Will do.
>>
>>>4) Why exactly just xa_erase() would not do?
>>
>>Might do, but need to rethink this :)
>
>Great :)
>
>
>>
>>>
>>>>+{
>>>>+	struct dpll_pin *pos;
>>>>+	unsigned long index;
>>>>+
>>>>+	xa_for_each(xa_pins, index, pos) {
>>>>+		if (pos =3D=3D pin) {
>>>>+			WARN_ON_ONCE(pos !=3D xa_erase(xa_pins, index));
>>>
>>>You have an odd pattern of functions getting pin as an arg then
>>>doing lookup for the same pin. I have to be missing to see some
>>>black magic here :O
>>>
>>
>>The black magic was done to target correct pin in case pin index differs
>>between dplls it was registered with. It would depend on the way shared
>>pins
>>are going to be allocated.
>>If mixed pins approach is allowed (shared + non-shared pins) on any dpll,
>>we
>>would end up in situation where pin index for the same physical pin on
>>multiple
>>devices may be different, depending on registering pins order.
>>
>>As desribed in below comments, I can see here one simple solution: allow
>>kernel
>>module (which registers a pin with dpll) to control/assign pin index.
>>The kernel module would only need take care of them being unique, when
>>registers with first dpll - which seems not a problem. This way we would
>>also
>>be albe to get rid of searching pin function (as indexes would be known
>>for all
>>driver instances), different driver instances would use that index to
>>share a
>>pin.
>>Also all the blackmagic like you described wouldn't be needed, thus
>>simplifing
>>a dpll subsystem.
>
>Good.
>
>
>>
>>>
>>>>+			return 0;
>>>>+		}
>>>>+	}
>>>>+
>>>>+	return -ENXIO;
>>>>+}
>>>>+
>>>>+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
>>>>+		      struct dpll_pin_ops *ops, void *priv)
>>>>+{
>>>>+	int ret;
>>>>+
>>>>+	if (!pin || !ops)
>>>>+		return -EINVAL;
>>>>+
>>>>+	mutex_lock(&dpll->lock);
>>>>+	ret =3D dpll_alloc_pin_on_xa(&dpll->pins, pin);
>>>>+	if (!ret) {
>>>>+		ret =3D dpll_pin_ref_add(pin, dpll, ops, priv);
>>>>+		if (ret)
>>>>+			pin_deregister_from_xa(&dpll->pins, pin);
>>>>+	}
>>>>+	mutex_unlock(&dpll->lock);
>>>>+	if (!ret)
>>>>+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_ADD);
>>>>+
>>>>+	return ret;
>>>>+}
>>>>+EXPORT_SYMBOL_GPL(dpll_pin_register);
>>>>+
>>>>+struct dpll_pin *dpll_pin_get_by_idx_from_xa(struct xarray *xa_pins,
>>>>int
>>>>idx)
>>>>+{
>>>>+	struct dpll_pin *pos;
>>>>+	unsigned long index;
>>>>+
>>>>+	xa_for_each_marked(xa_pins, index, pos, PIN_REGISTERED) {
>>>>+		if (pos->idx =3D=3D idx)
>>>>+			return pos;
>>>>+	}
>>>>+
>>>>+	return NULL;
>>>>+}
>>>>+
>>>>+/**
>>>>+ * dpll_pin_get_by_idx - find a pin by its index
>>>>+ * @dpll: dpll device pointer
>>>>+ * @idx: index of pin
>>>>+ *
>>>>+ * Allows multiple driver instances using one physical DPLL to find
>>>>+ * and share pin already registered with existing dpll device.
>>>>+ *
>>>>+ * Return: pointer if pin was found, NULL otherwise.
>>>>+ */
>>>>+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx=
)
>>>>+{
>>>>+	return dpll_pin_get_by_idx_from_xa(&dpll->pins, idx);
>>>>+}
>>>>+
>>>>+	struct dpll_pin
>>>>+*dpll_pin_get_by_description(struct dpll_device *dpll, const char
>>>>*description)
>>>>+{
>>>>+	struct dpll_pin *pos, *pin =3D NULL;
>>>>+	unsigned long index;
>>>>+
>>>>+	xa_for_each(&dpll->pins, index, pos) {
>>>>+		if (!strncmp(pos->description, description,
>>>>+			     DPLL_PIN_DESC_LEN)) {
>>>>+			pin =3D pos;
>>>>+			break;
>>>>+		}
>>>>+	}
>>>>+
>>>>+	return pin;
>>>>+}
>>>>+
>>>>+int
>>>>+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
>>>>+			 struct dpll_device *dpll,
>>>>+			 const char *shared_pin_description,
>>>
>>>I don't follow why you need to pass the string. You have struct dpll_pin
>>>* in the driver. Pass that instead, avoid string to refer to kernel
>>>object. But this is something I wrote multiple times.
>>>
>>
>>I wrote this so many times :) Separated driver instances doesn't have the
>>pin
>>object pointer by default (unless they share it through some unwanted
>>static/
>>global contatiners). They need to somehow target a pin, right now only
>>unique
>>attributes on dpll/pin pair are a description and index.
>>Desription is a constant, index depends on the order of initialization an=
d
>>is
>>internal for a dpll device.
>>Previously there were a function to obtain a pin index by its description=
,
>>then
>>register with obtained index, now this is merged into one function.
>>
>>Altough I agree this is still not best aproach.
>>I will fix by: fallback to targeting a pin to be shared by its index, wit=
h
>>one
>>slight design change, the pin index would have to be given by the driver
>>instance which registers it with the first dpll.
>>All the other separated driver instances which are using that pin will
>>have to
>>know the index assigned to the pin that is going to be shared, which seem=
s
>>like a best approach to fix this issue.
>
>>
>>>
>>>>+			 struct dpll_pin_ops *ops, void *priv)
>>>>+{
>>>>+	struct dpll_pin *pin;
>>>>+	int ret;
>>>>+
>>>>+	mutex_lock(&dpll_pin_owner->lock);
>>>>+	pin =3D dpll_pin_get_by_description(dpll_pin_owner,
>>>>+					  shared_pin_description);
>>>>+	if (!pin) {
>>>>+		ret =3D -EINVAL;
>>>>+		goto unlock;
>>>>+	}
>>>>+	ret =3D dpll_pin_register(dpll, pin, ops, priv);
>>>>+unlock:
>>>>+	mutex_unlock(&dpll_pin_owner->lock);
>>>>+
>>>>+	return ret;
>>>
>>>I don't understand why there should be a separate function to register
>>>the shared pin. As I see it, there is a pin object that could be
>>>registered with 2 or more dpll devices. What about having:
>>>
>>>pin =3D dpll_pin_alloc(desc, type, ops, priv)
>>>dpll_pin_register(dpll_1, pin);
>>>dpll_pin_register(dpll_2, pin);
>>>dpll_pin_register(dpll_3, pin);
>>>
>>
>>IMHO your example works already, but it would possible only if the same
>>driver
>>instance initializes all dplls.
>
>It should be only one instance of dpll to be shared between driver
>instances as I wrote in the reply to the "ice" part. There might he some
>pins created alongside with this.
>

pin =3D dpll_pin_alloc(desc, type, ops, priv)
dpll_pin_register(dpll_1, pin);
dpll_pin_register(dpll_2, pin);
dpll_pin_register(dpll_3, pin);
^ there is registration of a single pin by a 3 dpll instances, and a kernel
module instance which registers them has a reference to the pin and all dpl=
ls,
thus it can just register them all without any problems, don't need to call
dpll_shared_pin_register(..).

Now imagine 2 kernel module instances.
One (#1) creates one dpll, registers pins with it.
Second (#2) creates second dpll, and want to use/register pins of dpll
registered by the first instance (#1).

>My point is, the first driver instance which creates dpll registers also
>the pins. The other driver instance does not do anything, just gets
>reference to the dpll.
>
>On cleanup path, the last driver instance tearing down would unregister
>dpll pins (Could be done automatically by dpll_device_put()).
>
>There might be some other pins (Synce) created per driver instance
>(per-PF). You have to distinguish these 2 groups.
>
>
>>dpll_shared_pin_register is designed for driver instances without the pin
>
>I think we need to make sure the terms are correct "sharing" is between
>multiple dpll instances. However, if 2 driver instances are sharing the
>same dpll instance, this instance has pins. There is no sharing unless
>there is another dpll instance in picture. Correct?
>

Yes!
If two kernel module intances sharing a dpll instance, the pins belong
to the dpll instance, and yes each kernel module instance can register pins
with that dpll instance just with: dpll_pin_register(dpll_1, pin);

dpll_shared_pin_register(..) shall be used when separated kernel module
instances are initializing separated dpll instances, and those instances ar=
e
physically sharing their pins.

>
>>object.
>>
>>>Then one pin will we in 3 xa_arrays for 3 dplls.
>>>
>>
>>As we can see dpll_shared_pin_register is a fancy wrapper for
>>dpll_pin_register. So yeah, that's the point :) Just separated driver
>>instances
>>sharing a pin are a issue, will fix with the approach described above (pi=
n
>>index given by the registering driver instance).
>
>Yeah, driver instances and dpll instances are not the same thing. I dpll
>instance per physical dpll. Driver instances should share them.
>

Sure thing, we aim that.

>
>>
>>>
>>>>+}
>>>>+EXPORT_SYMBOL_GPL(dpll_shared_pin_register);
>
>[...]
>
>
>>>>+/**
>>>>+ * dpll_pin_parent - provide pin's parent pin if available
>>>>+ * @pin: registered pin pointer
>>>>+ *
>>>>+ * Return: pointer to aparent if found, NULL otherwise.
>>>>+ */
>>>>+struct dpll_pin *dpll_pin_parent(struct dpll_pin *pin)
>>>
>>>What exactly is the reason of having one line helpers to access struct
>>>fields for a struct which is known to the caller? Unneccesary
>>>boilerplate code. Please remove these. For pin and for dpll_device as
>>>well.
>>>
>>
>>Actually dpll_pin is defined in dpll_core.c, so it is not known to the
>>caller
>>yet. About dpll_device, yes it is known. And we need common approach here=
,
>>thus
>>we need a fix. I know this is kernel code, full of hacks and performance
>>related
>>bad-design stuff, so will fix as suggested.
>
>You are in the same code, just multiple files. Share the structs in .h
>files internally. Externally (to the drivers), the struct geometry
>should be hidden so the driver does not do some unwanted magic.
>

Yes, will do.

>
>>
>>>
>>>
>>>>+{
>>>>+	return pin->parent_pin;
>>>>+}
>>>>+
>
>[...]
>
>
>>>>+static int dpll_msg_add_pin_modes(struct sk_buff *msg,
>>>>+				   const struct dpll_device *dpll,
>>>>+				   const struct dpll_pin *pin)
>>>>+{
>>>>+	enum dpll_pin_mode i;
>>>>+	bool active;
>>>>+
>>>>+	for (i =3D DPLL_PIN_MODE_UNSPEC + 1; i <=3D DPLL_PIN_MODE_MAX; i++) {
>>>>+		if (dpll_pin_mode_active(dpll, pin, i, &active))
>>>>+			return 0;
>>>>+		if (active)
>>>>+			if (nla_put_s32(msg, DPLLA_PIN_MODE, i))
>>>
>>>Why this is signed?
>>>
>>
>>Because enums are signed.
>
>You use negative values in enums? Don't do that here. Have all netlink
>atrributes unsigned please.
>

No, we don't use negative values, but enum is a signed type by itself.
Doesn't seem right thing to do, put signed-type value into unsigned type TL=
V.
This smells very bad.
=20
>
>>
>>>
>>>>+				return -EMSGSIZE;
>>>>+	}
>>>>+
>>>>+	return 0;
>>>>+}
>>>>+
>
>[...]
>
>
>>>>+static struct genl_family dpll_family __ro_after_init =3D {
>>>>+	.hdrsize	=3D 0,
>>>
>>>No need for static.
>>>
>>
>>Sorry, don't get it, why it shall be non-static?
>
>Static is already zeroed, you don't need to zero it again.
>

Sure, got it.

>
>>
>>>
>>>>+	.name		=3D DPLL_FAMILY_NAME,
>>>>+	.version	=3D DPLL_VERSION,
>>>>+	.ops		=3D dpll_ops,
>>>>+	.n_ops		=3D ARRAY_SIZE(dpll_ops),
>>>>+	.mcgrps		=3D dpll_mcgrps,
>>>>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_mcgrps),
>>>>+	.pre_doit	=3D dpll_pre_doit,
>>>>+	.parallel_ops   =3D true,
>>>>+};
>
>[...]
>
>
>>>>+
>>>>+#define DPLL_FILTER_PINS	1
>>>>+#define DPLL_FILTER_STATUS	2
>>>
>>>Why again do we need any filtering here?
>>>
>>
>>A way to reduce output generated by dump/get requests. Assume the
>>userspace
>>want to have specific information instead of everything in one packet.
>>They might be not needed after we introduce separated "get pin" command.
>
>That's right, not needed.
>
>
>>
>>>
>>>>+
>>>>+/* dplla - Attributes of dpll generic netlink family
>>>>+ *
>>>>+ * @DPLLA_UNSPEC - invalid attribute
>>>>+ * @DPLLA_ID - ID of a dpll device (unsigned int)
>>>>+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH
>>>size)
>>>>+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
>>>>+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum
>>>dpll_mode)
>>>>+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
>>>
>>>IDX
>>>
>>
>>Sure, will fix.
>>
>>>
>>>>+ *	(unsigned int)
>>>>+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
>>>>+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
>>>
>>>Hmm, wouldn't it be better to have it as 1/10 of Celsius degree for
>>>example?
>>>
>>
>>As we are not using it, I don't have any strong opinon on this, but seems
>>resonable to me, will add a divider into uAPI like:
>>
>>#define DPLL_TEMP_DIVIDER	10
>
>Okay.
>
>
>>
>>>
>>>>+ * @DPLLA_CLOCK_ID - Unique Clock Identifier of dpll (u64)
>>>>+ * @DPLLA_CLOCK_CLASS - clock quality class of dpll (enum
>>>dpll_clock_class)
>>>>+ * @DPLLA_FILTER - filter bitmask for filtering get and dump requests
>>>>(int,
>>>>+ *	sum of DPLL_DUMP_FILTER_* defines)
>>>>+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
>>>>+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
>>>>+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by
>>>>driver
>>>>+ *	(char array of PIN_DESC_LEN size)
>>>>+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
>>>>+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
>>>>+ *	(enum dpll_pin_signal_type)
>>>>+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
>>>>+ *	(enum dpll_pin_signal_type)
>>>>+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for
>>>>DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
>>>>+ *	(unsigned int)
>>>>+ * @DPLLA_PIN_MODE - state of pin's capabilities (enum dpll_pin_mode)
>>>>+ * @DPLLA_PIN_MODE_SUPPORTED - available pin's capabilities
>>>>+ *	(enum dpll_pin_mode)
>>>>+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
>>>>+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
>>>>+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
>>>>+ * @DPLLA_CHANGE_TYPE - type of device change event
>>>>+ *	(enum dpll_change_type)
>>>>+ **/
>>>>+enum dplla {
>>>>+	DPLLA_UNSPEC,
>>>>+	DPLLA_ID,
>>>>+	DPLLA_NAME,
>>>>+	DPLLA_MODE,
>>>>+	DPLLA_MODE_SUPPORTED,
>>>>+	DPLLA_SOURCE_PIN_IDX,
>>>>+	DPLLA_LOCK_STATUS,
>>>>+	DPLLA_TEMP,
>>>>+	DPLLA_CLOCK_ID,
>>>>+	DPLLA_CLOCK_CLASS,
>>>>+	DPLLA_FILTER,
>>>>+	DPLLA_PIN,
>>>>+	DPLLA_PIN_IDX,
>>>>+	DPLLA_PIN_DESCRIPTION,
>>>>+	DPLLA_PIN_TYPE,
>>>>+	DPLLA_PIN_SIGNAL_TYPE,
>>>>+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
>>>>+	DPLLA_PIN_CUSTOM_FREQ,
>>>>+	DPLLA_PIN_MODE,
>>>>+	DPLLA_PIN_MODE_SUPPORTED,
>>>>+	DPLLA_PIN_PRIO,
>>>>+	DPLLA_PIN_PARENT_IDX,
>>>>+	DPLLA_PIN_NETIFINDEX,
>>>
>>>I believe we cannot have this right now. The problem is, ifindexes may
>>>overlay between namespaces. So ifindex without namespace means nothing.
>>>I don't see how this can work from the dpll side.
>>>
>>
>>I am a bit confused, as it seemed we already had an agreement on v4
>discussion
>>on this. And now again you highligheted it with the same reasoning as
>>previously. Has anything changed on that matter?
>
>Not sure what we discussed, but ifindex alone is not enough as ifindexes
>from multiple namespaces overlap.
>
>
>>
>>>Lets assign dpll_pin pointer to netdev and expose it over RT netlink in
>>>a similar way devlink_port is exposed. That should be enough for the
>>>user to find a dpll instance for given netdev.
>>>
>>>It does not have to be part of this set strictly, but I would like to
>>>have it here, so the full picture could be seen.
>>>
>>
>>A "full picture" is getting broken if we would go with another place to
>>keep
>>the reference between pin and device that produces its signal.
>>
>>Why don't we add an 'struct device *' argument for dpll_pin_alloc, create
>>new attribute with dev_name macro similary to the current name of dpll
>>device
>>name, something like: DPLLA_PIN_RCLK_DEVICE (string).
>>This way any device (not only netdev) would be able to add a pin and poin=
t
>>to
>>a device which produces its signal.
>
>Okay, that sounds good.
>
>
>>
>>>
>>>
>>>>+	DPLLA_CHANGE_TYPE,
>>>>+	__DPLLA_MAX,
>>>>+};
>>>>+
>>>>+#define DPLLA_MAX (__DPLLA_MAX - 1)
>>>>+
>>>>+/* dpll_lock_status - DPLL status provides information of device statu=
s
>>>>+ *
>>>>+ * @DPLL_LOCK_STATUS_UNSPEC - unspecified value
>>>>+ * @DPLL_LOCK_STATUS_UNLOCKED - dpll was not yet locked to any valid
>>(or
>>>is in
>>>>+ *	DPLL_MODE_FREERUN/DPLL_MODE_NCO modes)
>>>>+ * @DPLL_LOCK_STATUS_CALIBRATING - dpll is trying to lock to a valid
>>>signal
>>>>+ * @DPLL_LOCK_STATUS_LOCKED - dpll is locked
>>>>+ * @DPLL_LOCK_STATUS_HOLDOVER - dpll is in holdover state - lost a
>>valid
>>>lock
>>>>+ *	or was forced by DPLL_MODE_HOLDOVER mode)
>>>>+ **/
>>>>+enum dpll_lock_status {
>>>>+	DPLL_LOCK_STATUS_UNSPEC,
>>>>+	DPLL_LOCK_STATUS_UNLOCKED,
>>>>+	DPLL_LOCK_STATUS_CALIBRATING,
>>>>+	DPLL_LOCK_STATUS_LOCKED,
>>>>+	DPLL_LOCK_STATUS_HOLDOVER,
>>>>+
>>>>+	__DPLL_LOCK_STATUS_MAX,
>>>>+};
>>>>+
>>>>+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
>>>>+
>>>>+/* dpll_pin_type - signal types
>>>>+ *
>>>>+ * @DPLL_PIN_TYPE_UNSPEC - unspecified value
>>>>+ * @DPLL_PIN_TYPE_MUX - mux type pin, aggregates selectable pins
>>>>+ * @DPLL_PIN_TYPE_EXT - external source
>>>>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT - ethernet port PHY's recovered clock
>>>>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR - device internal oscillator
>>>>+ * @DPLL_PIN_TYPE_GNSS - GNSS recovered clock
>>>>+ **/
>>>>+enum dpll_pin_type {
>>>>+	DPLL_PIN_TYPE_UNSPEC,
>>>>+	DPLL_PIN_TYPE_MUX,
>>>>+	DPLL_PIN_TYPE_EXT,
>>>>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>>>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>>>>+	DPLL_PIN_TYPE_GNSS,
>>>>+
>>>>+	__DPLL_PIN_TYPE_MAX,
>>>>+};
>>>>+
>>>>+#define DPLL_PIN_TYPE_MAX (__DPLL_PIN_TYPE_MAX - 1)
>>>>+
>>>>+/* dpll_pin_signal_type - signal types
>>>>+ *
>>>>+ * @DPLL_PIN_SIGNAL_TYPE_UNSPEC - unspecified value
>>>>+ * @DPLL_PIN_SIGNAL_TYPE_1_PPS - a 1Hz signal
>>>>+ * @DPLL_PIN_SIGNAL_TYPE_10_MHZ - a 10 MHz signal
>>>
>>>Why we need to have 1HZ and 10MHZ hardcoded as enums? Why can't we work
>>>with HZ value directly? For example, supported freq:
>>>1, 10000000
>>>or:
>>>1, 1000
>>>
>>>freq set 10000000
>>>freq set 1
>>>
>>>Simple and easy.
>>>
>>
>>AFAIR, we wanted to have most commonly used frequencies as enums +
>>custom_freq
>>for some exotic ones (please note that there is also possible 2PPS, which
>>is
>>0.5 Hz).
>
>In this exotic case, user might add divider netlink attribute to divide
>the frequency pass in the attr. No problem.
>
>
>>This was design decision we already agreed on.
>>The userspace shall get definite list of comonly used frequencies that ca=
n
>>be
>>used with given HW, it clearly enums are good for this.
>
>I don't see why. Each instance supports a set of frequencies. It would
>pass the values to the userspace.
>
>I fail to see the need to have some fixed values listed in enums. Mixing
>approaches for a single attribute is wrong. In ethtool we also don't
>have enum values for 10,100,1000mbits etc. It's just a number.
>

In ethtool there are defines for linkspeeds.
There must be list of defines/enums to check the driver if it is supported.
Especially for ANY_FREQ we don't want to call driver 25 milions times or mo=
re.

Also, we have to move supported frequencies to the dpll_pin_alloc as it is
constant argument, supported frequencies shall not change @ runtime?
In such case there seems to be only one way to pass in a nice way, as a
bitmask?

Back to the userspace part, do you suggest to have DPLLA_PIN_FREQ attribute
and translate kernelspace enum values to userspace defines like=20
DPLL_FREQ_1_HZ, etc? also with special define for supported ones ANY_FREQ?

>
>>
>>>
>>>>+ * @DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ - custom frequency signal, value
>>>>defined
>>>>+ *	with pin's DPLLA_PIN_SIGNAL_TYPE_CUSTOM_FREQ attribute
>>>>+ **/
>>>>+enum dpll_pin_signal_type {
>>>>+	DPLL_PIN_SIGNAL_TYPE_UNSPEC,
>>>>+	DPLL_PIN_SIGNAL_TYPE_1_PPS,
>>>>+	DPLL_PIN_SIGNAL_TYPE_10_MHZ,
>>>>+	DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ,
>>>>+
>>>>+	__DPLL_PIN_SIGNAL_TYPE_MAX,
>>>>+};
>>>>+
>>>>+#define DPLL_PIN_SIGNAL_TYPE_MAX (__DPLL_PIN_SIGNAL_TYPE_MAX - 1)
>>>>+
>>>>+/* dpll_pin_mode - available pin states
>>>>+ *
>>>>+ * @DPLL_PIN_MODE_UNSPEC - unspecified value
>>>>+ * @DPLL_PIN_MODE_CONNECTED - pin connected
>>>>+ * @DPLL_PIN_MODE_DISCONNECTED - pin disconnected
>>>>+ * @DPLL_PIN_MODE_SOURCE - pin used as an input pin
>>>>+ * @DPLL_PIN_MODE_OUTPUT - pin used as an output pin
>>>>+ **/
>>>>+enum dpll_pin_mode {
>>>>+	DPLL_PIN_MODE_UNSPEC,
>>>>+	DPLL_PIN_MODE_CONNECTED,
>>>>+	DPLL_PIN_MODE_DISCONNECTED,
>>>>+	DPLL_PIN_MODE_SOURCE,
>>>>+	DPLL_PIN_MODE_OUTPUT,
>>>
>>>I don't follow. I see 2 enums:
>>>CONNECTED/DISCONNECTED
>>>SOURCE/OUTPUT
>>>why this is mangled together? How is it supposed to be working. Like a
>>>bitarray?
>>>
>>
>>The userspace shouldn't worry about bits, it recieves a list of
>attributes.
>>For current/active mode: DPLLA_PIN_MODE, and for supported modes:
>>DPLLA_PIN_MODE_SUPPORTED. I.e.
>>
>>	DPLLA_PIN_IDX			0
>>	DPLLA_PIN_MODE			1,3
>>	DPLLA_PIN_MODE_SUPPORTED	1,2,3,4
>
>I believe that mixing apples and oranges in a single attr is not correct.
>Could you please split to separate attrs as drafted below?
>
>>
>>The reason for existance of both DPLL_PIN_MODE_CONNECTED and
>>DPLL_PIN_MODE_DISCONNECTED, is that the user must request it somehow,
>>and bitmask is not a way to go for userspace.
>
>What? See nla_bitmap.
>

AFAIK, nla_bitmap is not yet merged.

>Anyway, why can't you have:
>DPLLA_PIN_CONNECTED     u8 1/0 (bool)
>DPLLA_PIN_DIRECTION     enum { SOURCE/OUTPUT }

Don't get it, why this shall be u8 with bool value, doesn't make much sense=
 for
userspace.
All the other attributes have enum type, we can go with separated attribute=
:
DPLLA_PIN_STATE		enum { CONNECTED/DISCONNECTED }
Just be consistent and clear, and yes u8 is enough it to keep it, as well a=
s
all of attribute enum values, so we can use u8 instead of u32 for all of th=
em.

Actually for "connected/disconnected"-part there are 2 valid use-cases on m=
y
mind:
- pin can be connected with a number of "parents" (dplls or muxed-pins)
- pin is disconnected entirely
Second case can be achieved with control over first one, thus not need for =
any
special approach here. Proper control would be to let userspace connect or
disconnect a pin per each node it can be connected with, right?

Then example dump of "get-pins" could look like this:
DPLL_PIN	(nested)
	DPLLA_PIN_IDX		0
	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_EXT
	DPLLA_PIN_DIRECTION	SOURCE
	...
	DPLLA_DPLL			(nested)
		DPLLA_ID		0
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		CONNECTED
	DPLLA_DPLL			(nested)
		DPLLA_ID		1
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		DISCONNECTED

DPLL_PIN	(nested)
	DPLLA_PIN_IDX		1
	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_MUX
	DPLLA_PIN_DIRECTION	SOURCE
	...
	DPLLA_DPLL			(nested)
		DPLLA_ID		0
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		DISCONNECTED
	DPLLA_DPLL			(nested)
		DPLLA_ID		1
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		CONNECTED

DPLL_PIN	(nested)=09
	DPLLA_PIN_IDX		2
	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_MUX
	DPLLA_PIN_DIRECTION	SOURCE
	...
	DPLLA_DPLL			(nested)
		DPLLA_ID		0
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		DISCONNECTED
	DPLLA_DPLL			(nested)
		DPLLA_ID		1
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		DISCONNECTED

(similar for muxed pins)
DPLL_PIN	(nested)
	DPLLA_PIN_IDX		3
	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_SYNCE_ETH_PORT
	DPLLA_PIN_DIRECTION	SOURCE
	DPLLA_PIN_PARENT		(nested)
		DPLLA_PIN_IDX		1
		DPLLA_PIN_STATE		DISCONNECTED
	DPLLA_PIN_PARENT		(nested)
		DPLLA_PIN_IDX		2
		DPLLA_PIN_STATE		CONNECTED
		=09
DPLL_PIN	(nested)
	DPLLA_PIN_IDX		4
	DPLLA_PIN_TYPE		DPLL_PIN_TYPE_SYNCE_ETH_PORT
	DPLLA_PIN_DIRECTION	SOURCE
	DPLLA_PIN_PARENT		(nested)
		DPLLA_PIN_IDX		1
		DPLLA_PIN_STATE		CONNECTED
	DPLLA_PIN_PARENT		(nested)
		DPLLA_PIN_IDX		2
		DPLLA_PIN_STATE		DISCONNECTED

For DPLL_MODE_MANUAL a DPLLA_PIN_STATE would serve also as signal selector
mechanism.
In above example DPLL_ID=3D0 has only "connected" DPLL_PIN_IDX=3D0, now whe=
n
different pin "connect" is requested:

dpll-set request:
DPLLA_DPLL	(nested)
	DPLLA_ID=3D0
	DPLLA_NAME=3Dpci_0000:00:00.0
DPLLA_PIN
	DPLLA_PIN_IDX=3D2
	DPLLA_PIN_CONNECTED=3D1

Former shall "disconnect"..
And now, dump pin-get:
DPLL_PIN	(nested)
	DPLLA_PIN_IDX		0
	...
	DPLLA_DPLL			(nested)
		DPLLA_ID		0
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		DISCONNECTED
...
DPLL_PIN	(nested)
	DPLLA_PIN_IDX		2
	...
	DPLLA_DPLL			(nested)
		DPLLA_ID		0
		DPLLA_NAME		pci_0000:00:00.0
		DPLLA_PIN_STATE		CONNECTED
	=09
At least that shall happen on hardware level, right?

As I can't find a use-case to have a pin "connected" but not "selected" in =
case
of DPLL_MODE_MANUAL.

A bit different is with DPLL_MODE_AUTOMATIC, the pins that connects with dp=
ll
directly could be all connected, and their selection is auto-controlled wit=
h a
DPLLA_PIN_PRIO.
But still the user may also request to disconnect a pin - not use it at all
(instead of configuring lowest priority - which allows to use it, if all ot=
her
pins propagate invalid signal).

Thus, for DPLL_MODE_AUTOMATIC all ablove is the same with a one difference,
each pin/dpll pair would have a prio, like suggested in the other email.
DPLLA_PIN	(nested)
	...
	DPLLA_DPLL	(nested)
		...
		DPLLA_PIN_CONNECTED	<connected value>
		DPLLA_PIN_STATE		<prio value>

Which basically means that both DPLL_A_PIN_PRIO and DPLLA_PIN_STATE
shall be a property of a PIN-DPLL pair, and configured as such.


>DPLLA_PIN_CAPS          nla_bitfield(CAN_CHANGE_CONNECTED,
>CAN_CHANGE_DIRECTION)
>
>We can use the capabilitis bitfield eventually for other purposes as
>well, it is going to be handy I'm sure.
>

Well, in general I like the idea, altough the details...
We have 3 configuration levels:
- DPLL
- DPLL/PIN
- PIN

Considering that, there is space for 3 of such CAPABILITIES attributes, but=
:
- DPLL can only configure MODE for now, so we can only convert
DPLL_A_MODE_SUPPORTED to a bitfield, and add DPLL_CAPS later if required
- DPLL/PIN pair has configurable DPLLA_PIN_PRIO and DPLLA_PIN_STATE, so we
could introduce DPLLA_PIN_DPLL_CAPS for them
- PIN has now configurable frequency (but this is done by providing list of
supported ones - no need for extra attribute). We already know that pin sha=
ll
also have optional features, like phase offset, embedded sync.
For embedded sync if supported it shall also be a set of supported frequenc=
ies.
Possibly for phase offset we could use similar CAPS field, but don't think =
will
manage this into next version.

>
>
>>
>>
>>>
>>>>+
>>>>+	__DPLL_PIN_MODE_MAX,
>>>>+};
>>>>+
>
>[...]
>
>
>>>>+/**
>>>>+ * dpll_mode - Working-modes a dpll can support. Modes differentiate
>>>>>how
>>>>+ * dpll selects one of its sources to syntonize with a source.
>>>>+ *
>>>>+ * @DPLL_MODE_UNSPEC - invalid
>>>>+ * @DPLL_MODE_MANUAL - source can be only selected by sending a reques=
t
>>>>to dpll
>>>>+ * @DPLL_MODE_AUTOMATIC - highest prio, valid source, auto selected by
>>>>dpll
>>>>+ * @DPLL_MODE_HOLDOVER - dpll forced into holdover mode
>>>>+ * @DPLL_MODE_FREERUN - dpll driven on system clk, no holdover
>>>>available
>>>>+ * @DPLL_MODE_NCO - dpll driven by Numerically Controlled Oscillator
>>>
>>>Why does the user care which oscilator is run internally. It's freerun,
>>>isn't it? If you want to expose oscilator type, you should do it
>>>elsewhere.
>>>
>>
>>In NCO user might change frequency of an output, in freerun cannot.
>
>How this could be done?
>

I guess by some internal synchronizer frequency dividers. Same as other out=
put
(different then input) frequencies are achievable there.

Thanks,
Arkadiusz

>
>[...]

