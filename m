Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0A964089C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiLBOj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLBOj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:39:28 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E86D8C68E;
        Fri,  2 Dec 2022 06:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669991967; x=1701527967;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dCmd20s47bvrpKfBdy3QDF9uUHU07KB2K95dhwlu/Os=;
  b=AbfKO/TFWiKW7raO/QG+eX0fDpJN0FGMVSKQdhchIvK64oiSq/apWYQB
   +ZCNx0vhHotwxq5FrjO1x6vpFMW/7pLylGiKsPczYlZDPm0ievXkkSg59
   ZFsiZXoDzBvLQnmFstmUCNGkG+6ght5kJ18GUBeuGNW8amY4f3T7ho7GN
   I4vbelgLAkXs3/tPQM98Z+EEppqkA1wkNwQoM0KOT1Dwf/Cg/KSpSM8gr
   +Drppw+p0P1a51Rtf2YjERumq6CKD5gT1peZOJr6hQsyrAy52sHmfIrYY
   5r95lSLaQhRTkaFYOON63daWKIoh9lwOEfovpN5WfLIZ7V5gQZvN4oYBb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="314666508"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="314666508"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 06:39:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638767100"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="638767100"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 06:39:26 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 06:39:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 06:39:25 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 06:39:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ann+yRAJ2fiDEL7s2zUK4XU8TIPxqapcOdNwTTAtA5BEh/xa+Kn1iKPa5cmP06qZYC3QvdZYs+tt3Xu4maiSgVRUpzeGuMkDqAeauIlrj1o6BcU6mFSCzFUhc9U354YrkFWzb1HDJDQlb4AB7j0zPZ0k7PE+MLIbxNPkM5qarbYR6QSfVzBAtsrJZa/SyGUGrFVeH736o1dFrziIlLq1BXX+Obd31mnIeMD8ua6BOZMi5gbJJ77gAMzQDdha6NTZ6cKBG1ZY/Cya6/X66cFA6LKEfrs1gk7acwm6sWBgkpKMwxuaPR/ErM+S9Zxf5KlPTcN5X8Q0nr5t126tFa949Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFqpZfWkSjflnU0oIDkeskvjqTSDsstm1/wvoizgGpo=;
 b=IbJ6ObzhN6hoFFGIk0LW4NL3cyfzC0clZPv8Xiipll8yeuf6lktfVtrsBzqFd37W69dYwnRGhi21qQSoEVvWqT9pndi7lb+P5e5KBILN1mI66KRsisKHhufs0gw8tx4vSCoqiy0wpHeypx36P/CP8XtJyqFoj0hG/Yc4tVE7z8M3vH46GWIIim8BIN9krL5qGf/d18QKV1B/tbDvxJnykbvPoIXA1NKSGiaiCoKFEgxU1HbkSPja55NgS1ZjG6ZPbGznRbsyiXdCyh4SAZM+q9Jf4J2bebfjZYErIFmRxMNYKX5YOBNl/7SZhKoFmz//2jihRixVunktHBY5B7lfow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10; Fri, 2 Dec 2022 14:39:18 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 14:39:17 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Thread-Topic: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Thread-Index: AQHZBDry/jNi33oty0uFzAsT01mIf65XaZgAgAMHnuCAAB8XgIAAHepg
Date:   Fri, 2 Dec 2022 14:39:17 +0000
Message-ID: <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru> <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4n0H9BbzaX5pCpQ@nanopsycho>
In-Reply-To: <Y4n0H9BbzaX5pCpQ@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SJ0PR11MB6695:EE_
x-ms-office365-filtering-correlation-id: 674292bb-c6a1-4117-3826-08dad472fdff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vAJqjPAkMqtkt9AOWwAcDS/JI1xT+kcysQKDeMWkt/B2ElnoaPCFR1dJ69kuprBPXXYnJR5Gg8/AOVZDbv8GglM8oB1aiGJgQzqPeT11zAquhC8jmEFOex8o6hrmLdnUKRwl4sZcYUpUKvwUteEUVjBhFDWPdoGQyJ1MuWbQjVApRTWb+jXTJEwPvKMsSCK100p2hkM2dEpEIOhIGeJqTrqCw3nlXFQRlhvlCJ13p3Ru4nA862myQsY66fIWpp8fAdaGU557ALxYQnIWBBKkrxO2G8YYmcD89gx2bEqcJ/ggo7jgbzTFjWCp/LfSChKAgYXHn5+i3CLb+dXV2AzOE3L99rBlh8iajBadLUj+EXhr3AzdC4zY46bKkET4Gl/+NJviAsVwci6rIv6gmgR7jqvBmHvc+gn4ngZ3VEs+cgdoGFuJxBCp7P7LZSlyKQs0YcDpKTZnqVoWW5C33YnoddcF4BCB9pN5ZaNWMsE0VZNActSFiESCPsR1t31lrbBmfaPChxmM+ynTfQzq2jYYluXhOGOtgGU34iHG40cHc1w8g97hIITafvJckvHUAZEUUVw7WWQ9Z8KPn9NxnvNPwtyTM55xQuXq4kMS200DsuTkPuIPKnNql3JZTTiyUMbzlqlokLimuqZtjMEaTkoiTbLpzZrO9culxR3NGlSlqkI0jBWl2t/X/mCfqXjNo22gkcO8jczuVZUUmQNgdMFEBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(38100700002)(82960400001)(5660300002)(8936002)(41300700001)(4326008)(2906002)(38070700005)(83380400001)(86362001)(33656002)(122000001)(66556008)(64756008)(66476007)(76116006)(66946007)(66446008)(478600001)(54906003)(6916009)(316002)(71200400001)(55016003)(52536014)(186003)(9686003)(8676002)(6506007)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4dFSiJluTuXWoLZ3PGXvuJV9EQiIvY1VZWAmjSE/RqYBTZKaYJSvxocgnhwC?=
 =?us-ascii?Q?Oco8cUbpK7ApSnqMRNtCjBebfJg/ivWg6MG330wyfvytoBwqUrX+E0VkGSXL?=
 =?us-ascii?Q?DCd8nmUcBZVcYWXw68T2B0dCCku2gSDjSiJXZawRe2yMiSA1KYwLLw2ernuh?=
 =?us-ascii?Q?pVHgeDimtwZfcWOF8dc6Q1Au6q1aVir74p7YhWeAOa0bJLfyU/7v2tNSlZWU?=
 =?us-ascii?Q?qjmSYE2OY7eBaHi5io6hcWM3JV7c550+wsOIXnv9Fkou9sS1K1/bHUE7bNsX?=
 =?us-ascii?Q?7Y+p1R120HCZ8uJfGjhBCTyb/8WVT/wxJPlL3n/jWzmdM69r5gOr4jRvSwV5?=
 =?us-ascii?Q?N4J9qCecHvqn3KkfFPigQ9UqDM0pmniCu/y57IZ6Q2VhKKQlr/9kXq9mWQTH?=
 =?us-ascii?Q?ohbnIpwvhxlIAEKECtC+mC22R3cXIScwwKdiBJ9eaUTkyMyE5OjqPgSyldUA?=
 =?us-ascii?Q?sbqBwanCF7ItrQApON2gxXzCH7HK4IE7Tp7RuxnY6efJSqJTH+CzCwpSxd96?=
 =?us-ascii?Q?or5wwiKGDVmgVcQg/wadF5ZU/CrGMulKxKyTnWgfRLUyK2kj/LI4Fr6sHa4i?=
 =?us-ascii?Q?+rNj/yX+D3wuntcVF9j2e3uAzIOiIu0JSexAaJKj3ys/58+kNM24axBWLm54?=
 =?us-ascii?Q?sXh+NsaWEkfn6zUzS0ciI4C+Vqz4TaSu8Y11E53EAIHZ0g9xq6M2YyTHlPqj?=
 =?us-ascii?Q?x+eFQHnHrcig+BpW5eOgWDU3Sx73vu88Dz/A8dmeqbUvV8qSQrGMjUoo55bf?=
 =?us-ascii?Q?T2eIk5xPXaYL+vzfHFdyasT6MZhKCyDR3xf1KhmIpoLBAAmQ5S5kmnKoSbjH?=
 =?us-ascii?Q?72LrENqoSWo4YAVAS9brCca3IYQKTaVi/c7nKIFplBku7nNyCH85UUqCTHmX?=
 =?us-ascii?Q?m6lM8bG35iJHc8pKB7KYmWI+VDgTe77gZU3RiFQTA4/uVti3D8Ekn0qGujJY?=
 =?us-ascii?Q?EANBGuFHeLz+5mphn9Jlu6Mv809fOzU2H3hYCLzAPZ/dBjsZP2cJ5279BROG?=
 =?us-ascii?Q?4D46XbcwrBbRJfphOQljKh9hrJZnOU3e/kYPEo7JYVZwdBvD1BVV1JAPIxNt?=
 =?us-ascii?Q?Dnsi+8oCmsCNVzgwtRqLmWkQri1+voSSLB+Jj31hD1zllNJ1vLtoRL0FlH9a?=
 =?us-ascii?Q?PMlNH2uKeCuE0lahvmUyOlwOlrCn8Y/U2DtuP0FjzYWSSiVuYcGPWgcYBU0C?=
 =?us-ascii?Q?RnoryXE7LthkO5h2jqNbp0zI/LNcKzQXR5cBrcSZXP2osuYZ32X6yqtjFHc6?=
 =?us-ascii?Q?XCEna9uGrBZ8CDHY9q9Xz83O+rm2VN1/qRNnlP4I9K+N7CU2lw2maLtru79q?=
 =?us-ascii?Q?njbHb7hFJAoRQNEKOX90nD5TxEaex2qE1dcMyDgptrDznan9ZeW963T0T6Yq?=
 =?us-ascii?Q?4/RBvKFn8ph7B1kgY8rT1GEbE/EyKgy+7VN3DGc3c8RmeMV/cf2/v/m0uUpF?=
 =?us-ascii?Q?SxRRVbmSsuGVae+EJ3VRuI99kk8qnkUUgBCy0t26NJRxYYBVusbEAuvxxK30?=
 =?us-ascii?Q?fu4eUhPzkUSIg0gnYlgd0ZmY3MsGTF/3/XDoNTYkSsJQ8/aWhORvTFcThu1v?=
 =?us-ascii?Q?LQYFVNTQbRDvLj9t8oSdSIwbDE+q3FR5RhJNpnTBdgOnVfQd4qMaqo44Zumx?=
 =?us-ascii?Q?VQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 674292bb-c6a1-4117-3826-08dad472fdff
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 14:39:17.8756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+Pqaomi0OzO9gKhezRhpsTKrnqNUfoUW/6csS0Yc0slszNlh6iZv6tjWbDFUr8FdRkPLaMdBdC+mSTi89edFjty5davE2909qtxgsS+iy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, December 2, 2022 1:49 PM
>
>Fri, Dec 02, 2022 at 12:27:32PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, November 30, 2022 1:41 PM
>>>
>>>Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>>>>From: Vadim Fedorenko <vadfed@fb.com>
>
>[...]
>
>
>>>>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct
>>>dpll_attr *attr)
>>>>+{
>>>>+	struct ptp_ocp *bp =3D (struct ptp_ocp *)dpll_priv(dpll);
>>>>+	int sync;
>>>>+
>>>>+	sync =3D ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>>>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED :
>>>DPLL_LOCK_STATUS_UNLOCKED);
>>>
>>>get,set,confuse. This attr thing sucks, sorry :/
>>
>>Once again, I feel obligated to add some explanations :)
>>
>>getter is ops called by dpll subsystem, it requires data, so here value
>>shall be set for the caller, right?
>>Also have explained the reason why this attr struct and functions are
>>done this way in the response to cover letter concerns.
>
>Okay, I will react there.

Thanks!

>
>
>>
>>>
>>>
>>>>+
>>>>+	return 0;
>>>>+}
>>>>+
>>>>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll,
>>>>+struct
>>>dpll_pin *pin,
>>>>+				     struct dpll_pin_attr *attr) {
>>>>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
>>>
>>>This is exactly what I was talking about in the cover letter. This is
>>>const, should be put into static struct and passed to
>>>dpll_device_alloc().
>>
>>Actually this type or some other parameters might change in the
>>run-time,
>
>No. This should not change.
>If the pin is SyncE port, it's that for all lifetime of pin. It cannot tur=
n
>to be a EXT/SMA connector all of the sudden. This should be definitelly
>fixed, it's a device topology.
>
>Can you explain the exact scenario when the change of personality of pin
>can happen? Perhaps I'm missing something.
>

Our device is not capable of doing this type of switch, but why to assume
that some other HW would not? As I understand generic dpll subsystem must n=
ot
be tied to any HW, and you proposal makes it exactly tied to our approaches=
.
As Vadim requested to have possibility to change pin between source/output
"states" this seems also possible that some HW might have multiple types
possible.
I don't get why "all of the sudden", DPLLA_PIN_TYPE_SUPPORTED can have mult=
iple
values, which means that the user can pick one of those with set command.
Then if HW supports it could redirect signals/setup things accordingly.

>
>
>>depends on the device, it is up to the driver how it will handle any
>>getter, if driver knows it won't change it could also have some static
>>member and copy the data with: dpll_pin_attr_copy(...);
>>
>>>
>>>
>>>>+	return 0;
>>>>+}
>>>>+
>>>>+static struct dpll_device_ops dpll_ops =3D {
>>>>+	.get	=3D ptp_ocp_dpll_get_attr,
>>>>+};
>>>>+
>>>>+static struct dpll_pin_ops dpll_pin_ops =3D {
>>>>+	.get	=3D ptp_ocp_dpll_pin_get_attr,
>>>>+};
>>>>+
>>>> static int
>>>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>> {
>>>>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] =3D { "OCP" };
>>>>+	char pin_desc[PIN_DESC_LEN];
>>>> 	struct devlink *devlink;
>>>>+	struct dpll_pin *pin;
>>>> 	struct ptp_ocp *bp;
>>>>-	int err;
>>>>+	int err, i;
>>>>
>>>> 	devlink =3D devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev-
>>>>dev);
>>>> 	if (!devlink) {
>>>>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const
>>>>struct
>>>pci_device_id *id)
>>>>
>>>> 	ptp_ocp_info(bp);
>>>> 	devlink_register(devlink);
>>>>+
>>>>+	bp->dpll =3D dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS, dpll_cookie,
>>>pdev->bus->number, bp, &pdev->dev);
>>>>+	if (!bp->dpll) {
>>>>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>>>+		goto out;
>>>>+	}
>>>>+	dpll_device_register(bp->dpll);
>>>
>>>You still have the 2 step init process. I believe it would be better
>>>to just have dpll_device_create/destroy() to do it in one shot.
>>
>>For me either is ok, but due to pins alloc/register as explained below
>>I would leave it as it is.
>
>Please don't, it has no value. Just adds unnecesary code. Have it nice and
>simple.
>

Actually this comment relates to the other commit, could we keep comments
in the threads they belong to please, this would be much easier to track.
But yeah sure, if there is no strong opinion on that we could change it.

>
>>
>>>
>>>
>>>>+
>>>>+	for (i =3D 0; i < 4; i++) {
>>>>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>>>>+		pin =3D dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>>>>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
>>>
>>>Same here, no point of having 2 step init.
>>
>>The alloc of a pin is not required if the pin already exist and would
>>be just registered with another dpll.
>
>Please don't. Have a pin created on a single DPLL. Why you make things
>compitated here? I don't follow.

Tried to explain on the cover-letter thread, let's discuss there please.

>
>
>>Once we decide to entirely drop shared pins idea this could be probably
>>done, although other kernel code usually use this twostep approach?
>
>No, it does not. It's is used whatever fits on the individual usecase.

Similar to above, no strong opinion here from me, for shared pin it is
certainly useful.

>
>
>>
>>>
>>>
>>>>+	}
>>>>+
>>>> 	return 0;
>>>
>>>
>>>Btw, did you consider having dpll instance here as and auxdev? It
>>>would be suitable I believe. It is quite simple to do it. See
>>>following patch as an example:
>>
>>I haven't think about it, definetly gonna take a look to see if there
>>any benefits in ice.
>
>Please do. The proper separation and bus/device modelling is at least one
>of the benefits. The other one is that all dpll drivers would happily live
>in drivers/dpll/ side by side.
>

Well, makes sense, but still need to take a closer look on that.
I could do that on ice-driver part, don't feel strong enough yet to introdu=
ce
Changes here in ptp_ocp.

Thank you,
Arkadiusz

>
>
>>
>>Thanks,
>>Arkadiusz
>>
>>>
>>>commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
>>>Author: Jiri Pirko <jiri@nvidia.com>
>>>Date:   Mon Jul 25 10:29:17 2022 +0200
>>>
>>>    mlxsw: core_linecards: Introduce per line card auxiliary device
>>>
>>>
>>>
>>>
>>>>
>>>> out:
>>>>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>>>> 	struct ptp_ocp *bp =3D pci_get_drvdata(pdev);
>>>> 	struct devlink *devlink =3D priv_to_devlink(bp);
>>>>
>>>>+	dpll_device_unregister(bp->dpll);
>>>>+	dpll_device_free(bp->dpll);
>>>> 	devlink_unregister(devlink);
>>>> 	ptp_ocp_detach(bp);
>>>> 	pci_disable_device(pdev);
>>>>--
>>>>2.27.0
>>>>
