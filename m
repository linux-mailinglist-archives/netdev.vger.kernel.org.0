Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E136B464775
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347058AbhLAG6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:58:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:40774 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237081AbhLAG6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 01:58:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="216414399"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="216414399"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 22:54:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="477434863"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 30 Nov 2021 22:54:45 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 22:54:45 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 30 Nov 2021 22:54:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 30 Nov 2021 22:54:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um6jddt3SBhXih5QHudrHtbapctgPMEVSVRZa73/epcQAQDDuV9CeTEnYtLqU88QY1wEaRZVgqrPso0Gj03llSbpeqFG0PPNkbeYzPLq/yQNuhF8758n/KZa7XCVKapaQVGCQy/++VnCug07LKN32TodMd9zrJjHE5IcJ3snhX9uzGLjle6GmULJL5Dvte+L81QN1HpykpWXEQ/xapmTIDdMcCyeP4O+bJCUXvZMOAMvK4ujBxDIMXvrXb4DiOtmN2m3gb3vslgECoP7pS9eJBy2TIVF7dXNpYRZ/aBl4iVT9ha55uaDQhfRlle9vj03HSAq77mO2Qfh7LoZHTJPnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uk8MaQ4tKb1H62tXLf6ah5RS5cgiF6ZE7PVYaQdg/0k=;
 b=C00JpIRKtlmu/qvvVUWrd7TVTerC4ZL5fqRWdh3SeDsc992xTYY/OI1yDDSvB4FBSZ7eECxlktZeqLPXTlW28JODkVeLIIF3gmorUfAbpE2ZhuponVlSGJEwwlp3sTSj/AsWhBZ5h8AGBAwZbgBC7+SGz1mW+8IDqOsWp/vIyA+ydVzDUH34YElJ3VU0BDks3VaRqj4fG5XQJoxIfmq6caTZkgEHRtcRn+0e5f6/M+GO65fAex2Xw7yikE6m8IqOiPCKIKU1trYy/zkElohG3e8J71BE58J7HKd7deECHkEFYsp80vreEf5FSij9LHLxwq4SMkLyYK6/4/I9L7nu1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk8MaQ4tKb1H62tXLf6ah5RS5cgiF6ZE7PVYaQdg/0k=;
 b=NCZDJ3o8ZF81CfQio496Aa7YKmuu7p+/RkVU/n+uR5jJdOIm66AHHSXfwVpPbe0O0kXiUc5N2fFnsLIhE7EZln/FYzZpflBAIImQwlWM0YqYGX1dow3yMkIsPyTfO+ssBxdfPLCoBZZPSqcbYFzsK0qf7Bmk6k5qnUWv7pE+fLo=
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 06:54:39 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420%3]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 06:54:39 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>, lkp <lkp@intel.com>,
        "Li, Philip" <philip.li@intel.com>
Subject: Re: kernel-selftests: make run_tests -C bpf cost 5 hours
Thread-Topic: kernel-selftests: make run_tests -C bpf cost 5 hours
Thread-Index: AQHX5O7bT3828GpkZkSj1OkzXBfzKawdNdir
Date:   Wed, 1 Dec 2021 06:54:38 +0000
Message-ID: <PH0PR11MB4792C2AC6C5185FBC95B9C21C5689@PH0PR11MB4792.namprd11.prod.outlook.com>
References: <PH0PR11MB479271060FA116D87B95E12DC5669@PH0PR11MB4792.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB479271060FA116D87B95E12DC5669@PH0PR11MB4792.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 538c7fd3-cbfd-7a74-2df2-9f81012c447a
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db9390d8-4949-4c51-8ef8-08d9b49771be
x-ms-traffictypediagnostic: PH0PR11MB5095:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB509512D16FB510A01D42B89CC5689@PH0PR11MB5095.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tIgYe9bBIvQ7VdvcxgyLublvIv540vlTzMG6FENo574xR2CinUnb7jraWOt7si7osoU0dVonWzHj/XnHRV8BICRJwA8g4MGnHBkm3Qv25/E4NJPH5JZFkutO38kszYDtIVTOXPV1+IqVCk5zwSVt+63thzQHSVLQiYFBgJlZVk/A1DZ7ynABBwW+aF+kZ7eZW7EhCHCVF52A+6KQHKSBlaske7384D/QbtKefAxTDfwoJO5fHwtJqhi/x3cX1jQBPMIeMoknTYK0l8AxMQ/dMQV/vulEh9b4XqIWc5/l2Lq7mdx+MS2ZMz0bcMIwhFySJhwn8qxy0hSZau3qEHIyEglHN+/fHGnt+0lLF99vYuZTl1U+DUA+iZZRS5oq97os0vJfm+rPyjwpf8VUAtiZYAUCHzV+9whixWC40GaiN0l++nEj8ABtGeedjWLDUIay4io0Z/7DohgasQx+5y2tMG0p/CVndTeDQjGjhhdCtQ1XXViZCl1db9EmBkhIBeInB+W35KVieJNsI6CdUNeM0Ao8bljU5pP8/5XYTFt0JAIjFDsrj5dbdUhoVVJgAPwkJbjPsVYjxUSrsbZ9ir2gOukvNW7/q24fWDhyiYKt/ZE1c953inZCHC3oT8P/CCvLoGX4/2DKVayzk11+KjBMIbiBaoQURJXVGsyeQNonnnXru6K22y3oB0v/kd5vuSTgFA9jwjdbQQhz8elst2xwLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016003)(7416002)(4326008)(26005)(33656002)(53546011)(7696005)(54906003)(38100700002)(6506007)(110136005)(316002)(508600001)(186003)(2906002)(9686003)(122000001)(107886003)(8936002)(66446008)(76116006)(66476007)(66556008)(64756008)(66946007)(8676002)(86362001)(82960400001)(91956017)(38070700005)(52536014)(5660300002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Rfv7yUfoZURw6YvhUtOc4LOW+Hivw5K4jQ/DzHbakkYLNQmA+A25JZMjdU?=
 =?iso-8859-1?Q?h9GbLr1QNVrAbNDPyHdvWO9wbHXE7p3gVEjMR39RcxMiBTW3ts9ycNJb7Z?=
 =?iso-8859-1?Q?o3IAjGhKyNv/pxBV/7rLKVaBtgIcBC3BSDn1oLClfaYegwmKdtct7ku3yk?=
 =?iso-8859-1?Q?hP/bkAJPxg6BE7VUb3CLsIiXeX9S5Zs713n2l6ldd4KirnTOKXAPzeSg32?=
 =?iso-8859-1?Q?HBjEjRTyvHjrEkW8mAlmcytcFx1+qtFsHv2OoahL+qovEXMvk8T6bd0uNA?=
 =?iso-8859-1?Q?f03D4HSTaVY/tCzdLmm43uxCPjvS7MthFZUcQvK9jWuCGlGx8YPRuaVFSD?=
 =?iso-8859-1?Q?DiXH++5YbeYoGIY1p6SOHzozDfTuZluZ8nQoAC0I33SAYj9N7SNOOLHEgY?=
 =?iso-8859-1?Q?Yh1e2VIIjOGAWPsOk03JzaQRXO8tq1apiqPkrOZa0MDqp7h0yJeTV1V7tk?=
 =?iso-8859-1?Q?lfIhsATHY98mCkzIXIpg+VmmRlGqXvGRVASSLuxkAk9hSPcIGghD7alxcH?=
 =?iso-8859-1?Q?ahFcDqzfp0S+Xmds0K8H9EyrjYAnSGaGIkofkHGEyqGqqQDzw9OZx9Ki12?=
 =?iso-8859-1?Q?IwsqNimlRgQ2tpnYTx2OSS8gkrkniTZzvdCk5dY5GEE0rEDZVznydrfrDc?=
 =?iso-8859-1?Q?GxLG5+DWneV5kmfEnklMXRWM7CNWBYeo5yBdjwAZKLDZpNJXj0TiypZ3wg?=
 =?iso-8859-1?Q?7DUQhYAUbkpKOJmNY2VcIUIC6Zu0NeaBR2aH9IIL9LQE6a0XxxbHNG3g42?=
 =?iso-8859-1?Q?Ej5AKZ52wTBlIX9P6XmrYApyRB3sIjQWZm+6aELKtdFWDmkaS8Dw0o6KWl?=
 =?iso-8859-1?Q?k4svQhk9+K6cnr7jc7LA/4mBOOhfM/6okZuIOScaWqVFWfLGgW2M+/zBE2?=
 =?iso-8859-1?Q?1epOBjFO+/8CcIF4mpv1m5ScIgkO5rImFklMW+O8ijkFW37Cd39UBAHPj9?=
 =?iso-8859-1?Q?LL48Ack6Nl80LF9yOVZndSyJGgwk6HGK6AhP+8E95YATAhMNE04LpXgCpK?=
 =?iso-8859-1?Q?x/SbnPY5cWHcUn2/K943a2I188YcuDQG63zUItp9xRC8psQrNGW7jHUh4U?=
 =?iso-8859-1?Q?gaHllb0xAfzrHegfuvYsIqhu5TWPgBdsgrDdjaf9VB2L2lg8qJ8cijESXO?=
 =?iso-8859-1?Q?O/2f+tl2a2pB/09aHFFFpN2j//W+HJt3pYMBqjap2Mw+ldEPxU1f22mpaX?=
 =?iso-8859-1?Q?F8Xp74Py2am+VZW0us10bmRgZS4RBNNcFwtO9JsQ1OOs/wo4Si5KpF6l9v?=
 =?iso-8859-1?Q?x5nW+BOYEPHGlkmZJ5X7bo3vl8emwjsEVFvzmWWXQ8/DLNchGjX8ibH/S/?=
 =?iso-8859-1?Q?AwKc3LtRBCH8VcHSvf86F8Z0qyyjiyYlnEhlLJV0H2gZPrqQ0XaM64FC1y?=
 =?iso-8859-1?Q?5KipveOnTaUSX1Kglq1gq7jtqud+8LyKEhCMXvv2VsTVnoxjMqpw2Hlilv?=
 =?iso-8859-1?Q?oB4b+K4hykhvWj4wo32/tocoE6hfOrDyWM/gGI+NoYSGsnykrks9xubxkE?=
 =?iso-8859-1?Q?0R00zLz76cUFHPM4Ml+sWEGmpE2T2tBTT3+emMD4NZakDoHmFu3UOuy523?=
 =?iso-8859-1?Q?qCgt8Ekpkt+OtJAPXoc/tMyD7pAqBh52LP8+lmVpZq0Kje/c3t32twwIdx?=
 =?iso-8859-1?Q?GVqBUDpOSU5pEEB5mLyJcFFC8PqlFgqLxfEaKkuUrd9yhvt/+Oy3eYHQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9390d8-4949-4c51-8ef8-08d9b49771be
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 06:54:38.9119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rzg32QWd8w+Nd1qwjrqpXe5oqHe5fIA9jLoDH2EviL3h1N1xM3A8bZdNq5KBKZEe6pApVl+ch4w3Lxc0/iup5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5095
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping=0A=
=0A=
________________________________________=0A=
From: Zhou, Jie2X=0A=
Sent: Monday, November 29, 2021 3:36 PM=0A=
To: ast@kernel.org; daniel@iogearbox.net; andrii@kernel.org; kafai@fb.com; =
songliubraving@fb.com; yhs@fb.com; john.fastabend@gmail.com; kpsingh@kernel=
.org=0A=
Cc: netdev@vger.kernel.org; bpf@vger.kernel.org; linux-kernel@vger.kernel.o=
rg; Li, ZhijianX; Ma, XinjianX=0A=
Subject: kernel-selftests: make run_tests -C bpf cost 5 hours=0A=
=0A=
hi,=0A=
=0A=
   I have tested v5.16-rc1 kernel bpf function by make run_tests -C tools/t=
esting/selftests/bpf.=0A=
   And found it cost above 5 hours.=0A=
=0A=
   Check dmesg and found that lib/test_bpf.ko cost so much time.=0A=
   In tools/testing/selftests/bpf/test_kmod.sh insmod test_bpf.ko four time=
s.=0A=
   It took 40 seconds for the first three times.=0A=
=0A=
   When do 4th test among 1009 test cases from #812 ALU64_AND_K to  #936 JM=
P_JSET_K every test case cost above 1 min.=0A=
   Is it currently to cost so much time?=0A=
=0A=
kern :info : [ 1127.985791] test_bpf: #811 ALU64_MOV_K: all immediate value=
 magnitudes=0A=
kern :info : [ 1237.158485] test_bpf: #812 ALU64_AND_K: all immediate value=
 magnitudes jited:1 127955 PASS=0A=
kern :info : [ 1341.638557] test_bpf: #813 ALU64_OR_K: all immediate value =
magnitudes jited:1 155039 PASS=0A=
kern :info : [ 1447.725483] test_bpf: #814 ALU64_XOR_K: all immediate value=
 magnitudes jited:1 129621 PASS=0A=
kern :info : [ 1551.808683] test_bpf: #815 ALU64_ADD_K: all immediate value=
 magnitudes jited:1 120428 PASS=0A=
kern :info : [ 1655.550594] test_bpf: #816 ALU64_SUB_K: all immediate value=
 magnitudes jited:1 175712 PASS=0A=
......=0A=
kern :info : [16725.824950] test_bpf: #931 JMP32_JLE_X: all register value =
magnitudes jited:1 216508 PASS=0A=
kern :info : [16911.555675] test_bpf: #932 JMP32_JSGT_X: all register value=
 magnitudes jited:1 178367 PASS=0A=
kern :info : [17101.466163] test_bpf: #933 JMP32_JSGE_X: all register value=
 magnitudes jited:1 191436 PASS=0A=
kern :info : [17288.359154] test_bpf: #934 JMP32_JSLT_X: all register value=
 magnitudes jited:1 165714 PASS=0A=
kern :info : [17480.615048] test_bpf: #935 JMP32_JSLE_X: all register value=
 magnitudes jited:1 172846 PASS=0A=
kern :info : [17667.472140] test_bpf: #936 JMP_JSET_K: imm =3D 0 -> never t=
aken jited:1 14 PASS=0A=
=0A=
   test_bpf.ko dmesg output is attached.=0A=
=0A=
best regards,=0A=
