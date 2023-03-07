Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5AB6ADEA1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjCGMYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjCGMYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:24:31 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86742509B8;
        Tue,  7 Mar 2023 04:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678191854; x=1709727854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=16i7FhQPl1Bv2Ytfh13MjaKwAF5L8LLHnN/ScaNMOok=;
  b=SlW2tb7KfC2W+CJDyIDTk0x29yf/dDhMeq1VU/kgMLepUPWA53T3Z1vc
   Gw85mqUZlVFTEIZoYs21g5licbh60g7zzWc3naRhppIsWKP7NekH6t+fS
   vgYghhEFuWcxOunGjGuwyKtu3xv0p0jcxv3iAQ+1upDiVDVa/IPnrisG2
   cH542w/QPSqInpJrACyFWfW22kdIlvdA3pJSuM8488Fnxq11ZS/YaAZyk
   nhuJPJEhNBZHSOdNKLCmLhpEgcTftQn826nNagP4+95YOxxdXVsL2vcKr
   0o+epN9pi6I9aG8HJuUy39+ZDk1GoZDhSx1ub0D8WlENaqpK9iOMviG4S
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="333308907"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="333308907"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 04:24:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="740703613"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="740703613"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 07 Mar 2023 04:24:13 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 04:24:13 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 04:24:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 04:24:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 04:24:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUIVz4hQrNvaO0yzdyHzG3c/lpnomLDv/xDVZZgKk6Faw5ltMEtlr9uSmBIzXqeb+pyMEiPRwFjmSaP/H6/Xp3m4xwLrvp6+gawI7wm7v7KFTNmS6ki7SKp4gMwYPRS3UgXVdK3AD5+I551km8pZ9FQuwLQBq/o//8jmpjW45iIi7Pj0CkUV76MhimnZ5TR1cITbma6cDnyaLewiu+1+helHqGpRtDcSoxxejCM6at0ANdi+tXBJgdeOB4e6liq345UYKpONn7rbZGub1CDiVr0PTJEkILbDohubbTvBbHzbdSi8T/SyYBhRgbFAY8435h7x4auwJttygef+GIUSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G+BAHygVRAYs6iA0eGUx6cOQrU/uTd54ryh7cyLuyY=;
 b=FTk/TgqJgYSBMieeN/ThWvc1UojLNpCdino0gprcPcVIyyVy/4Vc0fP3XVBN04c/cHJ4wHvIxCsaiczUXBmWKEG4ToDttIInhnUkKrDxlWhEkrI69sNk90jdeEGVcw01wHfe7bHtEVftJdJMmHDq9WQXkGhDWANZtg5eI55TciKdEz+cICzHx7UdTNS9Tg7XyetjCwVfPqaf7p9IQUyyZXCmTV8WW5QrUMuy5a51hQVacUHmNCxq+DsTYVxSi0ygFLoReu6FLRQ2GPkWb4zGf3u4l22rh/DMNbOKz75O0kF1ZZybZLWiYsqwBpxfsXmnAd4eWq1pjt2dM/i2ujK/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7593.namprd11.prod.outlook.com (2603:10b6:510:27f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Tue, 7 Mar 2023 12:24:10 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 12:24:10 +0000
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
Subject: RE: [RFC PATCH v5 4/4] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v5 4/4] ice: implement dpll interface to control cgu
Thread-Index: AQHZKp3NB3+z9/Hbn06pYsw7Q84CVK6l1pCAgAzKLSCABfITAIA29HxQ
Date:   Tue, 7 Mar 2023 12:24:10 +0000
Message-ID: <DM6PR11MB4657E804602158A60BF23C679BB79@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-5-vadfed@meta.com> <Y8lZl+U0Bll4BAKE@nanopsycho>
 <DM6PR11MB46570EA36A31F636BFA14EC19BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y9kQ+uWAYZHhqtW2@nanopsycho>
In-Reply-To: <Y9kQ+uWAYZHhqtW2@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7593:EE_
x-ms-office365-filtering-correlation-id: 93657aba-f3b4-4ef5-fc60-08db1f06db0b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l6ql2HnLOtxsGpZzqVXx5SVkGzXSkdcdVqoELMGUXEUFPfzpFdqbZ5T33rlxreWiyq2aTsrwx6+D/dsowsueM/yZSi6KtYmoUh3Rkjfjs18vH39BrZgoALjTnD0cUB7dRpa0dNx31FgnafK6Wq1Og3ueqG8OWW4lN2Fg+fKQUxMaFGCUAoRcYfr3qMX4Gbt3Rtfg1N6znP61OCz3wUC2bY3GD9+7kst7jLJ5oUVZ0vfdiUXRuoFgcC46HuIE7NVxmavgMX0y/w+hYCkCXSnu0J5rd1jdcIe09Xp9S8To7JjD4u94X/D60f8fRoe4tt/TzNjsQV/XT1l4HnGx/4U8QHyf/S4Kcjy/IDF5E5g+PYM5SjghCsLRQ5kTh7T6b6VA5iJheAKdfJj7qiKYq1aiu87PNZ1icW365iUvWeV/AnlVJ6NCp4xoE4THjhX21XEfi3Q2vyMgan6jKhoIBm+0Mu6mTR+kD1XHvUqvDz0193d/ex1QNIOxIUr+A0f0S9kqA6LeGf7p6vqhmkOD7CkgQ7PDqPxY4VzhXqzWBCxh5k9ZsNXBM4RKcfOZBIYCWe4T2tInmrt7qSLs2cCdcYSt0LulzUMn1KEo8cKcjX0Cd1lpn6OVe4PaQ+XXppEM/D2PxptqbVL0qMMqjnP+Eqc5NMXAhjGEpwBBjNzEe3+X3QtgaHz7/f/9c+7cTa587ty6mhPz68BjjlsnNyZnQLHR3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(316002)(83380400001)(54906003)(55016003)(86362001)(33656002)(64756008)(9686003)(186003)(82960400001)(76116006)(5660300002)(26005)(478600001)(66946007)(66556008)(8936002)(66476007)(8676002)(2906002)(41300700001)(4326008)(6506007)(107886003)(66446008)(71200400001)(7696005)(6916009)(122000001)(38100700002)(52536014)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WiEp35/dZCCj3FEchiNGvnR1oRD7OWn49eU6y0VMUqvzpZ+EjIdmUPvZWFg1?=
 =?us-ascii?Q?BVO5FmGSSeyToWyyZ6fZdG4Pog47hnpVkmTtrTE/PKQaUm5npmJITn8WDQSm?=
 =?us-ascii?Q?8uNLmuWz2CP3tD+fb8ziMOXB/khzFnNmEBpxzjdjYvSeeYq0M5fhZV8FFPm0?=
 =?us-ascii?Q?xAEaZ2WGFDlhY+DOuZsMgXfIC3rnmwkar3mM1lTT+P7JeRHBao1uWubdAfzT?=
 =?us-ascii?Q?7KoI2oykxOtz5sQDp+KEBPBQgZK4t2caKQX2mBi+DU8lkqtZwh+e+TH3BRV/?=
 =?us-ascii?Q?TEP0FHh8vZtpiCdKAeCWJIJocECFDlRL8oDvNfZ26kU97oVJoBNi8P0KbnkX?=
 =?us-ascii?Q?3i8PmbgWQTWiYXFky1t5K/GIMP0iQfIiHSo9CW3ohTnRjwFBrKAXAJ/AqsyG?=
 =?us-ascii?Q?ETfOT11FACpf7yZFRjSe2GH6INLptZD2rUNM7lzY4pyPtjmMtbWRInOSGfUJ?=
 =?us-ascii?Q?lkaAD3w2/fCPjdOvxEyYgqveLGrOt48zsiR7AldfQj3uxNyHDWLrmlzM97vy?=
 =?us-ascii?Q?pru4R9xnAZConki0J+FWgZmy6KyJtsrHVq1Hk9cgCMZopwZMErHwRkHFyGF/?=
 =?us-ascii?Q?y1HXTIfE1hLB/ZAiyeLrNkxYj3Nlm9uMTcHJWdj0D8Spy3VelYbneQp01syl?=
 =?us-ascii?Q?0Zj5ga1njeCSMtN5ID9x03NjD0bggcqtwtuaQnDTb27KkiOsfgisstF7GBTl?=
 =?us-ascii?Q?YFCvrg8H/hWC2TeHCvHDNM3Zm6ujGR83JgQTMz+Q6x/mKsE5Jzl2uROD61Zi?=
 =?us-ascii?Q?RWkIXT9m1uaHjT14l5quel9Rep/68lCBY1UdLEc51RUGmEz13wFexe9VbMiK?=
 =?us-ascii?Q?wMkPpQXU51UJoP90ZcI2XgV8IN1EZ7lLveYeTDTqZrAW2B+g7P+d6u+8zPYC?=
 =?us-ascii?Q?KMhOhsS4d2IVB+JryLg6YMiPZHy1OLFQqjBN0jeWVvVjGy+fIb++e3MbGFcQ?=
 =?us-ascii?Q?TCCvW7+owVrx89o7ot1cRtgB/KiEEmE25Cv8yTf3fWeakhrUiAhtqVvN49ql?=
 =?us-ascii?Q?yBkiSgS8l4Sio9G6p508THc4soXREwYYBydiZRjxi1w48urJsWP8Y/oTToHg?=
 =?us-ascii?Q?E1h265rlUqNMkqXcau9KLIHFKAxShSwegB4DVnAdyXxPfZZDiW2wUa4Xvm4s?=
 =?us-ascii?Q?jkNUHe6ruTmwIDeKoKBPBAj8BejvyIV9UoeeyvMbBBpkz4Q6Dn1rWJUqB9tk?=
 =?us-ascii?Q?9RQGSqJC1QsXvoceZ2g+FTryhpBl0KT0m76zcfoS9bvJavEFMl6HVoLgjJck?=
 =?us-ascii?Q?bbbM9yweJh4P9UBXZ9xjG9IqZ+vYr6wDJP7pUxnCaLnRGVjI5SF16FFztp2S?=
 =?us-ascii?Q?37yh5CXKFPO4y0DvjFolcMGxhLRMG1gGJdTpNnKC7wC2og0Hlg8SHE7h2kC/?=
 =?us-ascii?Q?tJQelQPka4pi6u8VyGa9JX5bf/VYngVHHTEN0tdpoPPSnZAjtn50ZRHzI7Wm?=
 =?us-ascii?Q?aDb3Wx+CGSL6fA7cK1JcXu/sB3X6o85zVygab1KZ/ZZU65lF4k+wdyIXBWA0?=
 =?us-ascii?Q?3tld/6upb7UlgSFud2LBf6bjum77vSRklgdIKTIQjmd6/XsevIVCB3b8W5X7?=
 =?us-ascii?Q?pQap7WE3ZR57o3TxmS1jgQN27pxSMudQqvr++PYwRYoKtRCxc+UuQYULTvwo?=
 =?us-ascii?Q?qA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93657aba-f3b4-4ef5-fc60-08db1f06db0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 12:24:10.7848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EUKv9ZK42tCdi51XmkM3YdYCY641PWKRorAFqtFlYKHEuhvhpcxNt3SjqClTQ09QiiZMHXOt4Ir0SO6KogMW19JQzjLVw+1JMNEU6uPB378=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, January 31, 2023 2:01 PM
>
>Fri, Jan 27, 2023 at 07:13:20PM CET, arkadiusz.kubalewski@intel.com wrote:
>>
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Thursday, January 19, 2023 3:54 PM
>>>
>>>Tue, Jan 17, 2023 at 07:00:51PM CET, vadfed@meta.com wrote:
>>>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>[...]
>
>
>>>>+/**
>>>>+ * ice_dpll_periodic_work - DPLLs periodic worker
>>>>+ * @work: pointer to kthread_work structure
>>>>+ *
>>>>+ * DPLLs periodic worker is responsible for polling state of dpll.
>>>>+ */
>>>>+static void ice_dpll_periodic_work(struct kthread_work *work) {
>>>>+	struct ice_dplls *d =3D container_of(work, struct ice_dplls,
>>>>work.work);
>>>>+	struct ice_pf *pf =3D container_of(d, struct ice_pf, dplls);
>>>>+	struct ice_dpll *de =3D &pf->dplls.eec;
>>>>+	struct ice_dpll *dp =3D &pf->dplls.pps;
>>>>+	int ret =3D 0;
>>>>+
>>>>+	if (!test_bit(ICE_FLAG_DPLL, pf->flags))
>>>
>>>Why do you need to check the flag there, this would should not be ever
>>>scheduled in case the flag was not set.
>>>
>>
>>It's here rather for stopping the worker, It shall no longer reschedule
>>and bail out.
>
>How that can happen?
>

You might be right, I will take a closer look on this before final submissi=
on.

>
>
>>
>>>
>>>>+		return;
>>>>+	mutex_lock(&d->lock);
>>>>+	ret =3D ice_dpll_update_state(&pf->hw, de);
>>>>+	if (!ret)
>>>>+		ret =3D ice_dpll_update_state(&pf->hw, dp);
>>>>+	if (ret) {
>>>>+		d->cgu_state_acq_err_num++;
>>>>+		/* stop rescheduling this worker */
>>>>+		if (d->cgu_state_acq_err_num >
>>>>+		    CGU_STATE_ACQ_ERR_THRESHOLD) {
>>>>+			dev_err(ice_pf_to_dev(pf),
>>>>+				"EEC/PPS DPLLs periodic work disabled\n");
>>>>+			return;
>>>>+		}
>>>>+	}
>>>>+	mutex_unlock(&d->lock);
>>>>+	ice_dpll_notify_changes(de);
>>>>+	ice_dpll_notify_changes(dp);
>>>>+
>>>>+	/* Run twice a second or reschedule if update failed */
>>>>+	kthread_queue_delayed_work(d->kworker, &d->work,
>>>>+				   ret ? msecs_to_jiffies(10) :
>>>>+				   msecs_to_jiffies(500));
>>>>+}
>
>[...]
>
>
>>>>+/**
>>>>+ * ice_dpll_rclk_find_dplls - find the device-wide DPLLs by clock_id
>>>>+ * @pf: board private structure
>>>>+ *
>>>>+ * Return:
>>>>+ * * 0 - success
>>>>+ * * negative - init failure
>>>>+ */
>>>>+static int ice_dpll_rclk_find_dplls(struct ice_pf *pf) {
>>>>+	u64 clock_id =3D 0;
>>>>+
>>>>+	ice_generate_clock_id(pf, &clock_id);
>>>>+	pf->dplls.eec.dpll =3D dpll_device_get_by_clock_id(clock_id,
>>>
>>>I have to say I'm a bit lost in this code. Why exactly do you need
>>>this here? Looks like the pointer was set in ice_dpll_init_dpll().
>>>
>>>Or, is that in case of a different PF instantiating the DPLL instances?
>>
>>Yes it is, different PF is attaching recovered clock pins with this.
>>
>>>If yes, I'm pretty sure what it is wrong. What is the PF which did
>>>instanticate those unbinds? You have to share the dpll instance,
>>>refcount it.
>>>
>>
>>It will break, as in our case only one designated PF controls the dpll.
>
>You need to fix this then.
>

Yeah, with v6 we did the refcounts.

>
>>
>>>Btw, you have a problem during init as well, as the order matters.
>>>What if the other function probes only after executing this? You got
>>>-EFAULT here and bail out.
>>>
>>
>>We don't expect such use case, altough I see your point, will try to fix
>it.
>
>What? You have to be kidding me, correct? User obviously should have free
>will to use sysfs to bind/unbind the PCI devices in any order he pleases.
>
>
>>
>>>In mlx5, I also share one dpll instance between 2 PFs. What I do is I
>>>create mlx5-dpll instance which is refcounted, created by first probed
>>>PF and removed by the last one. In mlx5 case, the PFs are equal,
>>>nobody is an owner of the dpll. In your case, I think it is different.
>>>So probably better to implement the logic in driver then in the dpll
>core.
>>>
>>
>>For this NIC only one PF will control the dpll, so there is a designated
>owner.
>>Here owner must not only initialize a dpll but also register its pin,
>>so the other PFs could register additional pins. Basically it means for
>>ice that we can only rely on some postponed rclk initialization for a
>>case of unordered PF initialization. Seems doable.
>
>My point is, you should have one DPLL instance shared for muptiple PFs.
>Then, you have pin struct and dpll struct to use in pin_register and you
>can avoid this odd description magic which is based obviously on broken
>model you have.
>

v6 shall fix it.

>
>>
>>>Then you don't need dpll_device_get_by_clock_id at all. If you decide
>>>to implement that in dpll core, I believe that there should be some
>>>functions like:
>>>dpll =3D dpll_device_get(ops, clock_id, ...)  - to create/get reference
>>>dpll_device_put(dpll)                       - to put reference/destroy
>>
>>Sure, we can rename "dpll_device_get_by_clock_id" to "dpll_device_get"
>>(as it is only function currently exported for such behavior), and add
>>"dpll_device_put", with ref counts as suggested.
>>
>>>
>>>First caller of dpll_device_get() actually makes dpll to instantiate
>>>the device.
>>>
>>
>>Maybe I am missing something.. do you suggest that "dpll_device_get"
>>would allocate dpll device and do ref count, and then
>>dpll_device_register(..) call
>
>No need for separate register, is it? just have one dpll_device_get()
>function allocate-register/getref for you. Why do you need anything else?
>

v6 shall fix it.

Thank you,
Arkadiusz

>
>>would assign all the arguments that are available only in the owner
>>instance?
>>Or i got it wrong?
>
>[...]

