Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6086B9EBA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCNSh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCNSh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:37:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DAFB6D1A;
        Tue, 14 Mar 2023 11:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678819041; x=1710355041;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mc3CvgO9+vW5SKSK14iWN4+zokXelYDrb+I59gvVTSQ=;
  b=kJbzlxKf1/01L2zZL2dYsCxpiusK/aY8Cev/qR8LZZttpYdlgFBSwSIm
   WEG+XrGUC+eFGT2RD1Z0hUmEv59YUu90eKZq/Cq8UI+7CD+3A2ehKuKKI
   Ve6DJ0qW+TjFG/wKUe7vI26TyKEsqA9pIqffl5V4XZv0e+WbKh9bVUKmK
   WPGFHQ2AAzVqd9WwnoZ78A/ZGXnkzW7ziHqaVWYy61DEoigLTwSgWPWQD
   58a4oc42pOOsZjRElG/FJZ3mX/PSlWDqcmFgMagQH6Z/xIxLCtVz9eEA7
   xfcicaoPtL/DtDgVJk7myUXdW2eCQjGSLF1WsdU2yEVfs58B6vX5O1x2J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365183014"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="365183014"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:36:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="853316732"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="853316732"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2023 11:36:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 11:36:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 11:36:02 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 11:36:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0Tm4dB9k49yZsDMIrWmO55bWZxh9dpp8NSV0U9GDv7N8h0S2+mfxpFNrkF6PFWMvmEzXiUItni5Xl8wUdzQYcNmnHQD4x7HrzicCVJaQ/KE/TNswoldpyDH4mvxKFyh7u3a+OCcM/wr8YYcU03JppNI8U0XCBL6KX7xNsMP0AGxamEP8b0RShoCt0uWbNzPvypDQrdBn5HW/Pj8tufldB7yqEjZATv22RggxXPFoCPoEEAvUZ91TQwPbH1JEW/zykTnIEtJy89O8KOCbN3dnLrrInnfUBNZQdPNdlBn2FREd+FyZR+1B6mx/Cm6hQ0DmyhT1rYa3idrEZ1cMEeaUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fbc4jOTbIDESYRT0LLaivbpigfzL/bur39cyQPE+iBs=;
 b=Da4uMFehjgTVVpd1sppstH0H34PLZbvSejLuyweASJNU3ONyyY2KETVMTB0S7nuTDb2VCSWYPav/UF1fLVB1sU/Oa7F4LVKe26f8Hy3EQ2tWxJsdUXBxyjEbJYllLJ5pB8CqtSNkUR7Xt70Hk4uFFdbSFljMNDC03dAx785nrQ8wRE75/AYVSnmjtVY2bN1+Bpv2pjM6+2c0J+CzlwF7Nfx2OHqwdbnCpDgG31wyj7cMDV3ZYmcYZ02D0vRlHUXYuu3QTNJneSLUFzFYBkItoLefX+c/sq04KhmnCR9SSSfInP84rPrFym+V6pcdfVdwpb3qDxCLROiFJl1yRM4dSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CYYPR11MB8385.namprd11.prod.outlook.com (2603:10b6:930:c1::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 18:35:56 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%8]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:35:56 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Thread-Topic: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Thread-Index: AQHZVIponzEP4/hw1kCkgXiNnI8keq76buQAgAAjgIA=
Date:   Tue, 14 Mar 2023 18:35:55 +0000
Message-ID: <DM6PR11MB4657175A833B5DD7B84D54269BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com> <ZBCWkhRaUztjMapa@nanopsycho>
In-Reply-To: <ZBCWkhRaUztjMapa@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CYYPR11MB8385:EE_
x-ms-office365-filtering-correlation-id: 6a76e69b-14fd-45df-0b08-08db24baf2b4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7FN9Lao9TItZyF/MTDkj+aySvT/7Zyf07cX5Vc61Ccv9WZJBPZV46qSxdCaa9+RNBlaY7xShLKqNv9qJ5YXfePCjNFFVrWYWUQSf+/lnVT+JXkrZth8eurH1QqIHcpFXUv0aVtH0ACmDNZs63lSbmdmvI+RhN9egRc6aCD+K9Cu3LXJ5kaH889PpnD1tqz14f3yXv6Gnpk2IOFmXRALLA9jjq+saejBFG9g/Cwpa2TfefZM4I4NuG+WNGUXOcphOPE7aJ6orxqEP8MCWiO+7poXvJWUCO10wYAkEvrkuRotBpZeXatn6tc6nsYydHBSFPfYCQ7Q+WefQ8jIhrHqYGQZe0c0KR+nwFEmQM9gTKpZtCk7tHmOZv+4pj9ZNSpSvX4HUmbiYE+prYdOLltjzHUOQjO51Xk5jCJzop4iU5QWZx1sWdYW+gC6fkQ3Vfe+Oxc+X8VDnXvZwWel3yCci1s5bRujBch+V5gJQIEmZuvm/IE6D9eCnap3V7v7vUYZRjySxKO4nYXBoyxVNGedEM73FsdfZjGHz4WiBoI1mJKoNE4iOO/yYTT66GM+2MxAjNImn3X+Xu5hCUAhyO+/QPjkxDH1kYk9i22GDPD4/Ffrudb5N2o7m9PFnQ2m22bcrkKJn+VREcM3S+X1lae2LeqiaNWxbht5mm72EkhU0elxgKsgYe5caM9sOAVfKQiPuNTitx7ev+ZHYptI1oFlxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(107886003)(82960400001)(83380400001)(7696005)(316002)(38100700002)(478600001)(110136005)(54906003)(8936002)(186003)(52536014)(9686003)(55016003)(86362001)(33656002)(6506007)(71200400001)(5660300002)(7416002)(8676002)(66446008)(76116006)(66946007)(66476007)(66556008)(64756008)(26005)(38070700005)(4326008)(122000001)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bnYKNiK6hss6e2CZARBX4LaUTr5F19SDD6oi4+ZydTrxMGWLjXmLr/OwPfH/?=
 =?us-ascii?Q?zjii5IPebFq5OAKsFgINx4Bpz+CeULvE7c5lB5T/FfAyIXzyy4QQwjrZ0Wtd?=
 =?us-ascii?Q?yihdqXz3jqyWd2D4GhFUQyPByrjaYFUIvM3IGOOqLViNeNpEKDEWLM/UxE6d?=
 =?us-ascii?Q?cdewxKWkMH1x1gJlQWU13gcqy2Sqjyu/V8DehIAxTFM3SiX7kK6wdH9lL3Pn?=
 =?us-ascii?Q?afdI6jd5DEJfn+TsYLJrUx3bGuD+Gcju6NxsFByzKOGCtMAqU1KggpJEnqvV?=
 =?us-ascii?Q?dU9rvDsltLyWjKM++b2Dx3QnVOmVw4+DdlgfPBiQ/azhxglbYwJsaJmXtEaZ?=
 =?us-ascii?Q?IujKHIbXKFohsQVF1zryN3fda69PpzMOLTypzaMOu/S63RiVIIlnCJsCbjQi?=
 =?us-ascii?Q?DOVvJ1Y6Dv15cZyWBGKWmGa2WUDnZCOVqN9FOdgCoFGotj1cnZGFlLMI8cJ9?=
 =?us-ascii?Q?i8/d8eYxSBKdMN4eU4EPHnNbF0wZDG6YvnfHaJ/F3vooh4+7niqaeRIuKN8w?=
 =?us-ascii?Q?3MLvjuwALf7t8WIlKcsdx5/hzzJHj2ADKQnlXZ4h+R5MWTlY3KXdMzehCpyo?=
 =?us-ascii?Q?UUAZOQCRI8Cpnlo47U8g8SzxJAHHOWdPlSoqYLYkE9Lmqu2IGq7KL6e+gntw?=
 =?us-ascii?Q?jUBM2x5NBpjR3Kycp0ZRYHBQxcGjgkamd3Lx6pvvb5eaYlVXxjbU0KyCLePD?=
 =?us-ascii?Q?tvE7ynTP0l4hjnGICANtiZ0lWgdLtIjJuB5d19q/nN+dOFNXVtfwx1RqxTcp?=
 =?us-ascii?Q?XuQiBQrwH3sWSZ6jHfahNyi63v96BPS89zuDrMGb4wNjP022JD4L7v553wMi?=
 =?us-ascii?Q?rxfT7ZGmnfJBQExNjmPU1cQ5N/xcSIZXuDu7Nu1eeqPRezwmdddeDfJ2G497?=
 =?us-ascii?Q?sp6aYk4wbTpDaHVhBNfR/+/ApTaCGJKst5QUajmybAenqpQjs0xG9hmQ0GXM?=
 =?us-ascii?Q?dZrNzMHsm33bh/6JmP7Ocvw+ENHkWJ+kHKOvR43sfwMoYqDLakcwvYaBnqJB?=
 =?us-ascii?Q?PxE8f+tygBgIWAIr5bPmS5cHMosenzSSNJ6TQMnG7N8/v9AEYRfu26cuCkUN?=
 =?us-ascii?Q?CY6CQ4micGKJv5OkuOmQtxbfSz9EMLZUQNj+GRrRjDGewdMg5Amyl5F/2nle?=
 =?us-ascii?Q?/FRppeN5kZ24qaztJLJ3XPqXni6NxAv9t+f7D3Fb5RlIM1OmzAwJlIHv8lgV?=
 =?us-ascii?Q?Vtb8XHXaiy2mhkmebIfUZJyqPMX/WnXREoQOXbCO8YPEe2y2cDf0usPyn3JJ?=
 =?us-ascii?Q?EDDA73CYxPxXavmnAjVnQfXincBYQhP3A2s5tXVoBxzLIw8O5nzdj7GlH2OF?=
 =?us-ascii?Q?gnjPqwKcXqDaFWLHuWLBkJm5A75zF/ZBhNWO5U4ycBxa8Hm8g56OEQoql/4G?=
 =?us-ascii?Q?UZfb8qQJZ6uTj5bi98Hz7yzYr0hPdXR1q325v/P7d1THA0zybTFgBnq0hreK?=
 =?us-ascii?Q?7x1r56S7MxyYjalMRtQqNv70M7/IzNOfXaMU/GUzHC/fK6MkxCTLUKwq+ePt?=
 =?us-ascii?Q?ck1Nws8PHpunTcUyqNelQB/NJd4dk8WNH4KYtqGd1EnmyENSD9bnY2opncmF?=
 =?us-ascii?Q?7H5d+0OHlXdTtj8DbCgveBL2uCAU0Ki3IkckKuZIRSt9cO20tnPrdGhDtpFJ?=
 =?us-ascii?Q?hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a76e69b-14fd-45df-0b08-08db24baf2b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 18:35:55.7303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PoopIpNwb6/m208uEUpBkRp9P9AwcPbMXELcJ8I/9V0ln6q6CK3QuBuWSbgj1kA2oCf0iAROyNRQu1Cs3t2y8SxMXhopGS19fiVvYIoEd2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8385
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, March 14, 2023 4:45 PM
>
>[...]
>
>
>>diff --git a/MAINTAINERS b/MAINTAINERS
>>index edd3d562beee..0222b19af545 100644
>>--- a/MAINTAINERS
>>+++ b/MAINTAINERS
>>@@ -6289,6 +6289,15 @@ F:
>	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/swit
>ch-drive
>> F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
>> F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
>>
>>+DPLL CLOCK SUBSYSTEM
>
>Why "clock"? You don't mention "clock" anywhere else.
>
>[...]
>
>
>>diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>>new file mode 100644
>>index 000000000000..3fc151e16751
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_core.c
>>@@ -0,0 +1,835 @@
>>+// SPDX-License-Identifier: GPL-2.0
>>+/*
>>+ *  dpll_core.c - Generic DPLL Management class support.
>
>Why "class" ?
>
>[...]
>
>
>>+static int
>>+dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
>>+		      struct netlink_ext_ack *extack, bool dump_any_freq)
>>+{
>>+	enum dpll_pin_freq_supp fs;
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+	u32 freq;
>>+
>>+	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
>>+		if (ref && ref->ops && ref->dpll)
>>+			break;
>>+	}
>>+	if (!ref || !ref->ops || !ref->dpll)
>>+		return -ENODEV;
>>+	if (!ref->ops->frequency_get)
>>+		return -EOPNOTSUPP;
>>+	if (ref->ops->frequency_get(pin, ref->dpll, &freq, extack))
>>+		return -EFAULT;
>>+	if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY, freq))
>>+		return -EMSGSIZE;
>>+	if (!dump_any_freq)
>>+		return 0;
>>+	for (fs =3D DPLL_PIN_FREQ_SUPP_UNSPEC + 1;
>>+	     fs <=3D DPLL_PIN_FREQ_SUPP_MAX; fs++) {
>>+		if (test_bit(fs, &pin->prop.freq_supported)) {
>>+			if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED,
>>+			    dpll_pin_freq_value[fs]))
>
>This is odd. As I suggested in the yaml patch, better to treat all
>supported frequencies the same, no matter if it is range or not. The you
>don't need this weird bitfield.
>
>You can have a macro to help driver to assemble array of supported
>frequencies and ranges.
>

I understand suggestion on yaml, but here I am confused.
How do they relate to the supported frequency passed between driver and dpl=
l
subsystem?
This bitfield is not visible to the userspace, and sure probably adding mac=
ro
can be useful.

>
>>+				return -EMSGSIZE;
>>+		}
>>+	}
>>+	if (pin->prop.any_freq_min && pin->prop.any_freq_max) {
>>+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MIN,
>>+				pin->prop.any_freq_min))
>>+			return -EMSGSIZE;
>>+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MAX,
>>+				pin->prop.any_freq_max))
>>+			return -EMSGSIZE;
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>
>[...]
>
>
>>+static int
>>+dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
>>+			 struct dpll_device *dpll,
>>+			 struct netlink_ext_ack *extack)
>>+{
>>+	struct dpll_pin_ref *ref;
>>+	int ret;
>>+
>>+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
>>+		return -EMSGSIZE;
>>+	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
>>+		return -EMSGSIZE;
>>+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
>>+		return -EMSGSIZE;
>>+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
>>+		return -EMSGSIZE;
>>+	ret =3D dpll_msg_add_pin_direction(msg, pin, extack);
>>+	if (ret)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_freq(msg, pin, extack, true);
>>+	if (ret && ret !=3D -EOPNOTSUPP)
>>+		return ret;
>>+	ref =3D dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
>>+	if (!ref)
>
>How exactly this can happen? Looks to me like only in case of a bug.
>WARN_ON() perhaps (put directly into dpll_xa_ref_dpll_find()?

Yes, makes sense.

>
>
>>+		return -EFAULT;
>>+	ret =3D dpll_msg_add_pin_prio(msg, pin, ref, extack);
>>+	if (ret && ret !=3D -EOPNOTSUPP)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
>>+	if (ret && ret !=3D -EOPNOTSUPP)
>>+		return ret;
>>+	ret =3D dpll_msg_add_pin_parents(msg, pin, extack);
>>+	if (ret)
>>+		return ret;
>>+	if (pin->rclk_dev_name)
>
>Use && and single if
>

Make sense to me.

>
>>+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
>>+				   pin->rclk_dev_name))
>>+			return -EMSGSIZE;
>>+
>>+	return 0;
>>+}
>>+
>
>[...]
>
>
>>+static int
>>+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
>>+		  struct netlink_ext_ack *extack)
>>+{
>>+	u32 freq =3D nla_get_u32(a);
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+	int ret;
>>+
>>+	if (!dpll_pin_is_freq_supported(pin, freq))
>>+		return -EINVAL;
>>+
>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>+		ret =3D ref->ops->frequency_set(pin, ref->dpll, freq, extack);
>>+		if (ret)
>>+			return -EFAULT;
>
>return what the op returns: ret

Why would we return here a driver return code, userspace can have this info
from extack. IMHO return values of dpll subsystem shall be not dependent on
what is returned from the driver.

>
>
>>+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_FREQUENCY);
>>+	}
>>+
>>+	return 0;
>>+}
>>+
>
>[...]
>
>
>>+static int
>>+dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
>>+		       struct netlink_ext_ack *extack)
>>+{
>>+	enum dpll_pin_direction direction =3D nla_get_u8(a);
>>+	struct dpll_pin_ref *ref;
>>+	unsigned long i;
>>+
>>+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop.capabilities))
>>+		return -EOPNOTSUPP;
>>+
>>+	xa_for_each(&pin->dpll_refs, i, ref) {
>>+		if (ref->ops->direction_set(pin, ref->dpll, direction, extack))
>
>ret =3D ..
>if (ret)
>	return ret;
>
>Please use this pattern in other ops call code as well.
>

This is the same as above (return code by driver) explanation.

>
>>+			return -EFAULT;
>>+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_DIRECTION);
>>+	}
>>+
>>+	return 0;
>
>[...]

Thanks,
Arkadiusz
