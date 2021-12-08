Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E812546CBC2
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhLHDyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:54:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:61793 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232748AbhLHDyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 22:54:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="236488472"
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="236488472"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 19:50:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="600442405"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Dec 2021 19:50:45 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 19:50:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 19:50:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 19:50:44 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 19:50:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4vHn3H21A6GlvYGSa1MiiCP7qGCV9nAzwKpiCb/Vl5zrjitIIw8MmAvzRefSAffkExpNHoF3Ugef7YaCDWAr6zmSHFgrUZdEvUq6vQWBHz6pAEfGsSABCfDTz3su/NpztmDCsT/U/+o9wSEny4tpKnbL2NYGyxWzREq0Ar2PRPRV02zlnNbomX+pLBvFQBY7MfKhA+ZC5rzE566KKF7a9eVjF6+AhIwJfgpVqsraVZrX9ynjTsCeWVB0/cFWPOzfz21J2uOzucmVnY45jOfEU22MBWi1VO0DeJdaYRHkxGkOQ1EUuCZ59NtrIBYykoYNLm/wOojl/g2cnA0rW1xgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFcAktQE0Q7yz5xqTgO0e2SOUPwpwgpOU1WHiIHXNEA=;
 b=VlEWKXr3S3Gli4o3zj4wmdiDxbAb8X9BO285Y8PNE8oU72DRehYLgDt+E5d0fs4T6Vzo7UJ9CybCWFLLakVsCNGZR8Q9jdKwxDM4u8UAypKlkD0MAvEc047qA8fADwOx+j8GqIkG99ljfvs8cbi8BVkhvll6XKGXULxVHIupOEkjv6JckWFbpT5aCiCP+D8gOZUaEE2DnhI10JRZdo/+t/KldeZYwn1rU6TnGgLIgjvy9+maf/X3wLSMs8aRHIaPRZC6V6IHylnXMnZNIeXtNVFHbSbFIjRQyeYQbdZOzXuPUcu/XvN5nM6pNAWm9A9zVe0hDJomprx7pSdNbTGohQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFcAktQE0Q7yz5xqTgO0e2SOUPwpwgpOU1WHiIHXNEA=;
 b=Yyl/PjQBu+9VAI3IE//Ac2C7IE9ybBnXh/HOL8lbAaBb8eViuOdpwko5gKI1lHiTLLJ/TTHRWLa5i5nZNMVQzuHjVBbx89CVZMUEn5ZYMLA8REheSGDnWDN+2R6kwZ2gApsmivUTMPl8cOx4UiR+i0MKwFRi4XDOmwlTKDV0BZc=
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 03:50:37 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420%3]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 03:50:37 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>, lkp <lkp@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>,
        "Li, ZhijianX" <zhijianx.li@intel.com>
Subject: Re: selftests/net/fcnal-test.sh: ipv6_ping test failed
Thread-Topic: selftests/net/fcnal-test.sh: ipv6_ping test failed
Thread-Index: AQHX6zdRJ6JEKasTYE2dMwaZQ7p10qwnMAUAgAC+i4CAAAVIDA==
Date:   Wed, 8 Dec 2021 03:50:36 +0000
Message-ID: <PH0PR11MB47924ED34AE948FB0E6CF933C56F9@PH0PR11MB4792.namprd11.prod.outlook.com>
References: <PH0PR11MB4792DFC72C7F7489F22B26E5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com>
 <20211207075808.456e5b4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2918f246-7a48-4395-42bb-d50b943480c6@gmail.com>
In-Reply-To: <2918f246-7a48-4395-42bb-d50b943480c6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: e69eac40-85f8-036f-541c-5c963f8af88d
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c24a1a0e-cb93-4c99-09ac-08d9b9fde511
x-ms-traffictypediagnostic: PH0PR11MB4965:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB49651D00BEC3CDD77848280FC56F9@PH0PR11MB4965.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iw/BlzBc4Q3jpj1gLO9FmDn/MPp1YdnCKlqqegdaOfvJYYvangUCY2eQvl0b03WgtLFJ8lY6RjS6R5sqzAG2l0nZ85oF8Hyx5EegEshtdGVK/ERRMlCciTsVbQa3kpc6/LfVpkuaAFFBeO8uQdsd6zKgHXn9KHNUTCsIwGdnMOlRV9XW4VuBLMr0tdkd0hJSA/fpTXfQk1WZGMnrfebxEklSt/UEEIyMRwb6N6ulBn6AZ4aDSrhK+pQMsPLASL4p5Wu0X5FuU5wPSap2koy2M4grE6NNba/tfJNKR0Cdp2Gr5wwfZhcnpwSJzyeTDc1acu8KRWRJReAofe8L6x/i3yhe4+I9OaH5OeUZqu4poa3n7t4REHLywyP3yKUgTFoEc7356hKVKP2/0SMxj9eCkJwP69533DPOelC8I4/7eFReghDFTW/so/Hpk93RpfIQWO2QvIFbMnvh2yQdhuqJPYDLrYsMw1HWAi0a9uGn9oYiGMCgXKKvh9vgYMn4fRE0vMS5SuwRxGZZV31+pTM3TbQENLVNLsla65Z+8QjBj1RcIA87NKvSlWJHIQAMqvkp5DD2WiUiB5H5YjTXNuPuq9cZ8Jd2Cf2gLhReFElF11IuOKWHkLEFg8kxjMwP/5qU27iEY9gcOYmuxPCPefB1YnqUZYrcVcQvg8otZauGlktswCjpFB2a3eYQuoCYVfTEyUF5KL2cbxRBPJUaCRhLZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(52536014)(38100700002)(66446008)(82960400001)(55016003)(6506007)(7696005)(8936002)(110136005)(66556008)(66476007)(4326008)(33656002)(54906003)(64756008)(2906002)(66946007)(316002)(5660300002)(107886003)(9686003)(71200400001)(86362001)(26005)(91956017)(508600001)(76116006)(186003)(122000001)(38070700005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dkflHGQTNXYDTjo5tc4nta1d159CXrXuEFsds1N32pc+jPl7TWk4xgfaVC97?=
 =?us-ascii?Q?tIMtZ4oWqqXEuuCBSHYlbPyV8QESTTiN1GsEWI3qgnopcHb/xaJEHqdtlKIQ?=
 =?us-ascii?Q?5w7hEzfjKksCv1icZ5QP7bcgHqChAZgznaa5C9x6Ao3hcN3Srg5ZK6bnHYep?=
 =?us-ascii?Q?K8lWks2yv+BpaUTwVi2OnHnc2ACWGkppuYt33rSM0cOPC5S/UiLw98pHVQsB?=
 =?us-ascii?Q?8Mw/inDuOOcIKIfkkjym2F2HDSnlz1P1oFmxcPI25XMOtdkq8VJPPaAeYA4H?=
 =?us-ascii?Q?HS/3REmyi3GQcrfXjE7N+A5tT93yHZuHVYR4g26glkRxAZgXFOPzFfUE9F8R?=
 =?us-ascii?Q?6lhliIP9ZF++TNwBWVaJFSujhVZmGnW24q11JRLAwhqENh19q3gUXpI9T/W9?=
 =?us-ascii?Q?T+TI+4n7LCTh1Nc8N6xLJQSu2AOgw3qX4uPgGeHgVKlMAwVieAe7QdtvUd3a?=
 =?us-ascii?Q?lhFZX4h/mpe+DLSn0pOus2q9syloa6ztx5yO4edY6dpVZTuVBhQUnWBu4/aP?=
 =?us-ascii?Q?WoMdM4G4oCTsjMsfyu1qos60w6oML8Ut9pwK5e3n7sjiVF7H22PzYdJUdQxL?=
 =?us-ascii?Q?iChIk6v+Kxw2iJMRvZ1bjqjk69l/elsMhoL4K0U6khg96zkA0yBYjoKaLJvf?=
 =?us-ascii?Q?KnRL+GmxS6RZQYDGF0OxFO1glQ+vesXkq0hFeRY0CoAYJpABDOOkyx41DQ4o?=
 =?us-ascii?Q?OPdAiS4b2Zxb4TJ8Jwr2JKlX+DfEAA1p61ALQYzrOxYk7lmzipRu/XV8/zks?=
 =?us-ascii?Q?6xIB9YnQlcQMsHJt8rK1EbPEEMFXuHfxmhJxVt2/m16n5xODgqTLNAuwICY+?=
 =?us-ascii?Q?/K2r0TJiYZCMQT8B5jaxh5g9C5jv1F187tk6FO5yP8zkkbZHlOmn+KkAhB5R?=
 =?us-ascii?Q?sr7ga04cxbUlxXdWLDUSGpe8yv59MAjlHg3Qi4U/3Zi6/Ouks4V2l1EvNA38?=
 =?us-ascii?Q?YdyUQGAfidRj+Hx8zygSDk3FKFmJYydPZ2Wk6zfBXLb9lqDdi8fMJjVYpr2D?=
 =?us-ascii?Q?NN0SjMtlozR2AQxcXMvSbbUP8uwPhLASzIxVjUkB164lg7RhxkVgopo0q3Oj?=
 =?us-ascii?Q?LCe2LSS5ycOojVnNygS3mHyNSdrXyXd4bHeAfCoDCCMGc487r0MSvFNZ8LUN?=
 =?us-ascii?Q?8uy0X1iEXEN5/wtKJhmmLPycjJhPgLvxQ+6aZ6SDh6j/Zhv5375oG2QC3fbg?=
 =?us-ascii?Q?WnjAYNHsyDACkK1UqRImosY4aP7hU4OkwB/GKEykQyjsTAGSbBf60N5LGYsh?=
 =?us-ascii?Q?FB3UD+Jo8D01DCcEIFCsKgFlAI6ipALnU2M/3+FEpHUbMC2nY5Zt76bUftfD?=
 =?us-ascii?Q?7cg1Rx2gqLCLBV18TM0rUQlVLwn9Y12ZgyV4t09C/0k3nNdvLrr1gxL4sWFw?=
 =?us-ascii?Q?JifYCA7SVJaTvpnVUBiFaQzWuWc2N/zmrrq9dSQUBEQ/lwIcFhB9WVl8NDaQ?=
 =?us-ascii?Q?XA9tyuU1WcrNvrmKiQ5aVDw517IoLqaWwHubqivc3JiGU1z9FhQ94aLAl6Gd?=
 =?us-ascii?Q?P0hPmaqtzaCoCmg9LbWLrZgGjU1VT23kza/Nd8/VaiT5Y/GcNUvcpgqtUzlJ?=
 =?us-ascii?Q?f2C2Bj3XuIDLSH8GiCYrOzZByx5JKmenvpk5pVNWC6fMTAJf17zAb0uH3l+1?=
 =?us-ascii?Q?0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c24a1a0e-cb93-4c99-09ac-08d9b9fde511
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 03:50:36.8528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZmlUzY7O6eroRBPUuwERlcE/UHZYss51dP0G/8eQLRho4WeNhWWAGag3j19BCHFrZVUgMtZrDd1ceou53V53w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

  man ip, the output about exit value is like following.
  "Exit status is 0 if command was successful, and 1 if there is a syntax e=
rror.  If an error was reported by the kernel exit status is 2."
  Did the following COMMAND have syntax error? If not, should I still chang=
e the expected rc from 2 to 1?

#######################################################
HINT: Fails since VRF device does not support linklocal or multicast

COMMAND: ip netns exec ns-A /bin/ping6 -c1 -w1 fe80::7c4c:bcff:fe66:a63a%re=
d
ping: sendmsg: Network is unreachable
PING fe80::7c4c:bcff:fe66:a63a%red(fe80::7c4c:bcff:fe66:a63a%red) 56 data b=
ytes

--- fe80::7c4c:bcff:fe66:a63a%red ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

TEST: ping out, VRF bind - ns-B IPv6 LLA                                   =
   [FAIL]

#######################################################
HINT: Fails since VRF device does not support linklocal or multicast

COMMAND: ip netns exec ns-A /bin/ping6 -c1 -w1 ff02::1%red
ping: sendmsg: Network is unreachable
PING ff02::1%red(ff02::1%red) 56 data bytes

--- ff02::1%red ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

TEST: ping out, VRF bind - multicast IP                                    =
   [FAIL]

#######################################################

 best regards,

________________________________________
From: David Ahern <dsahern@gmail.com>
Sent: Wednesday, December 8, 2021 11:20 AM
To: Jakub Kicinski; lizhijian@fujitsu.com
Cc: Zhou, Jie2X; davem@davemloft.net; shuah@kernel.org; netdev@vger.kernel.=
org; linux-kselftest@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Phi=
lip; lkp; Ma, XinjianX; Li, ZhijianX
Subject: Re: selftests/net/fcnal-test.sh: ipv6_ping test failed

On 12/7/21 8:58 AM, Jakub Kicinski wrote:
> Adding David and Zhijian.
>
> On Tue, 7 Dec 2021 07:07:40 +0000 Zhou, Jie2X wrote:
>> hi,
>>
>>   I test ipv6_ping by "./fcnal-test.sh -v -t ipv6_ping".
>>   There are two tests failed.
>>
>>    TEST: ping out, VRF bind - ns-B IPv6 LLA                             =
         [FAIL]
>>    TEST: ping out, VRF bind - multicast IP                              =
         [FAIL]
>>
>>    While in fcnal-test.sh the expected command result is 2, the result i=
s 1, so the test failed.
>>    ipv6_ping_vrf()
>>    {
>>     ......
>>         for a in ${NSB_LINKIP6}%${VRF} ${MCAST}%${VRF}
>>         do
>>                 log_start
>>                 show_hint "Fails since VRF device does not support linkl=
ocal or multicast"
>>                 run_cmd ${ping6} -c1 -w1 ${a}
>>                 log_test_addr ${a} $? 2 "ping out, VRF bind"
>>         done
>>
>>     The ipv6_ping test output is attached.
>>     Did I set something wrong result that these tests failed?
>>
>> best regards,

ping6 is failing as it should. Can you send a patch to change the
expected rc from 2 to 1?
