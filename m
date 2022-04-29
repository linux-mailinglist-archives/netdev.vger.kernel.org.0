Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2237D514A50
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 15:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357852AbiD2NRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 09:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiD2NRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 09:17:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32D6C6F20
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 06:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651238056; x=1682774056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GqrM07c8vCgyspju2JftLjczqqdMKFmGG0dP3oltvgg=;
  b=D9k5y8pbI5qmHrnnj5vSQ7wqVcrhrYq2v/LtF0LaUAJGfK/20uughX54
   f2/vi4wEXXBKQjaMY7iV3vgS1l7JnlskFrVD2E5sshs82muuoL/03LiZK
   BsHYL35VHN8j9PCIaHINmRU2zPWMzYWN4Wbm3kB05G7xRLL79iDc+SlZ+
   zKDgjgGTqFHk6WUXogMlRf+D6b/WdHwwGV1JBQs/Gpe1SQTO07ytNInAl
   vrwAxr0n8z5/6JjSh5bdjdH1c60ProDbSS5zg1mXx9zest1aUwVGl+g71
   TC6B9sFRD3CCGp7nD3AXXKSGOYpU5L2rJ+ff/uHTdS1mTsqTGyyjgZej5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266167899"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="266167899"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 06:14:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582120458"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 29 Apr 2022 06:14:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 06:14:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 06:14:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 06:14:15 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 06:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWhAxl/KGtVgZhVdPIACuudge5sTXh5L4xaDr/WI6B1/pTOtJI8KYwm58PMMX+VbsxkO+Bs4/yHAoy/EYMqM90bYIa57Z4/D2qTejK6cfqFvmQk6UT/3OQykWpmbhh7ZRtaaQ5HJowRQjEZ+rN/I/SeUMY3p0C9R//N/PsmJfujyxq8BcrPPmmUpAMvCIiFQx4eksZL/ENPWIxCsVsCzBk4QuB5cCwQES48hTRvjOeec7xYMCs06tdrFVS8OU1grO9O8IsKRHvl6YNvmUCzQxFtJMLPnsYMuhi8FLa6LYY68ojyniZUntL5w+RHUxlR4w86v7zntIpiNSNHLFLXRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqrM07c8vCgyspju2JftLjczqqdMKFmGG0dP3oltvgg=;
 b=W4b/3P/jR/qFd20wB5W1uqdboeQ50DNrOw1VHpgmTbHRmd33Srhr6mK+X9ReSoC8rRj12ZuQ6YKQnrag/4R3hY0lMcLb3WSC01MXfhYhlSJbYqk98++Dz1y+O8OTMJ2xYka3itKoyXuECeEZcDjC5sJEPsqSCOsgOhjgYus6fDs592WvSlzc1yAUT6TihtdzA9fuNnMOU2SPCl16CmZlMo9Q59w11MKPYpEcsQkU9QP3EZWNcvE5P+OeqBP2z0Im4mN30xWEVL/8Yd4dB5fedpxB8yHFiMFjDv6ouCZFJYPra/6MkVwLm0eyZDL/LlJQMTKv8XW6+isQ3jkZDWNVBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5430.namprd11.prod.outlook.com (2603:10b6:208:31e::24)
 by DM6PR11MB3546.namprd11.prod.outlook.com (2603:10b6:5:13e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 13:14:13 +0000
Received: from BL1PR11MB5430.namprd11.prod.outlook.com
 ([fe80::49c5:bec3:a36:c4e5]) by BL1PR11MB5430.namprd11.prod.outlook.com
 ([fe80::49c5:bec3:a36:c4e5%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 13:14:13 +0000
From:   "Maloszewski, Michal" <michal.maloszewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: RE: [PATCH net 1/2] iavf: Fix error when changing ring parameters on
 ice PF
Thread-Topic: [PATCH net 1/2] iavf: Fix error when changing ring parameters on
 ice PF
Thread-Index: AQHYVNwqx8tU1ZUFuEyko1AvZMprh6z8jEYAgAkgk5CAAATnAIABNlZw
Date:   Fri, 29 Apr 2022 13:14:12 +0000
Message-ID: <BL1PR11MB54308512D3CB817F76DFBCF686FC9@BL1PR11MB5430.namprd11.prod.outlook.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
        <20220420172624.931237-2-anthony.l.nguyen@intel.com>
        <20220422154752.1fab6496@kernel.org>
        <BL1PR11MB5430A4AD0469C1C4BDCBB5C486FD9@BL1PR11MB5430.namprd11.prod.outlook.com>
 <20220428112820.4f36b5e6@kernel.org>
In-Reply-To: <20220428112820.4f36b5e6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 487ed520-1cce-4841-0380-08da29e2279e
x-ms-traffictypediagnostic: DM6PR11MB3546:EE_
x-microsoft-antispam-prvs: <DM6PR11MB3546E18422AFF81EEFD63F4286FC9@DM6PR11MB3546.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fz6K5Ki+NitI7E/Y4eda70nxmfCSgFoyUi570dn1ZvjvnHhkXl0gE0AITznBJia9YB4Ek9fCAwyWI/rfdG3374/y1P7uH0UrzcTqC6YXeXsnMWAbVvA+sIrGkh0Ofr6qpqpKx4dHDjw28Gg8fF8k1l+lCxCmjeQPu//Sl5yrXeFVeZgrdsmHt4WVt8wbxVIZaqaoeL8gdhdSepWE4ZddSV2CVgGVyr8t36s9WbVM/wwrYo+ZsyTbSt+evwPnsuH3qvkzcxGEak7s2qw8wIfj/elr+pbfklzy5f5rMI4y16deDWOvVWWnreoHtboh61mZbohy/NXYj2Kr0vIXGpbVu7sedqw/l3o7QbUZum3KDPKmBQN5iwb9kkl9RRpuB0OXJatwMoA20g6Ip92I4FRkzz1kHNvHjSc/3S8248qSR1xyAJnm2ssFsACv/m+Vt/z86vZrzLTuKKfSniUxSptfO0BANb4acx5rhTS3JYdFLTEncPNzOpdEhyk4iz5qAvnQnR35SYXC+lguY57KQAwAEVBSDnrp9me+m97BIm9U/iWYpZLT4/9r4hNI/iQu/NmY/yGdXr33Z0IghLCohtpPfkKfXeoVeFONYVguSvKuzFGptMTdpbs+Z6b9zgTRUnP/DF2P+cx5OKb1MFYxz79RIx2hzVaf+kCKobWpa0QpgaxtMKh8ze/DTLHaf6bI00n5L+mNCyyNahfDSSHziss1yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5430.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(7696005)(2906002)(5660300002)(186003)(107886003)(8936002)(4744005)(83380400001)(26005)(9686003)(508600001)(55016003)(33656002)(4326008)(316002)(54906003)(6916009)(52536014)(122000001)(66946007)(38100700002)(71200400001)(38070700005)(66476007)(8676002)(66556008)(66446008)(86362001)(64756008)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DhvtNUzRQYi7WQMV/scdHGSppsdi+yEhBHwX7DhWbE5F4NBQBxHIprqvu05O?=
 =?us-ascii?Q?82R0ysZx6r8uMukbLNoPmlIBGL2DywfpbkQPp62JG4pF2dOKlMBSNdp76Tgv?=
 =?us-ascii?Q?SxVFDrW8aDAo4VeBjyPLEuGbHsS+9zvn9yt5qnpFbWJOJf4qYmLcV13QTS8e?=
 =?us-ascii?Q?2dLFMOscKyFbZvIe7f4VrbGqB7LwEopaErxNcl4MV3C6UdzPRwttlr7E8IOW?=
 =?us-ascii?Q?perY/sJS0bGf1j7O6+8hU3R1agU3LrdODOVM3LOPAPqixFizHYWlze0BT6MM?=
 =?us-ascii?Q?peNb8J2WtAKaJvlZvu5t3P3TG4F5IeIpzJNO3PQoZ/pFrfXZWm6K5esoSEFf?=
 =?us-ascii?Q?2g5QGwImqdHf1pXAw4MUG2l3kwpo+V62LQ6JnplX5xLZj0zz22LFyHTNp7Vs?=
 =?us-ascii?Q?9JkqPhCsIAtBhwnCjG5iDwlEx0ZC6KiYDX0ehLo4mgw4sCITbJzBCkNBAwcH?=
 =?us-ascii?Q?i1WKGMiBS2MNPg4AwLMh3AquIdTaLZ2fgFszQTAvLZv8JvjfMBt5RJmzGV+e?=
 =?us-ascii?Q?e+D5iMy++x8K11uDuM9qjsED4OsZHoS8Qp/uG9qYPNvwvirpScMrW3EQQEZ1?=
 =?us-ascii?Q?KM1itv7290I1hIaCj88O/iiZXDSm9VaO0sbt4bWXBluG61yv38Wisbb8Bzv4?=
 =?us-ascii?Q?Zqqx05v3DB9LGo1rdZ66hg92zeIb93u3NSehTM92zDcr2zVnCxtFGHwL6Exi?=
 =?us-ascii?Q?POOZQ0T2AgXu63FKEeGVAYAyeB8pW4CDWwIzBpoc45DhEo4BY+nIfSSSjmgh?=
 =?us-ascii?Q?I/2N/wPfdW+puWtAzKiYNqcqaFnMxoY+TjK6QCk/Vg9piaQ6QxtYjV7GVkoQ?=
 =?us-ascii?Q?zHx4dSWENqC3r07xu+F8Y3DHntiIL0rpBEUhTK+hbxKLTfdY5vmjpFycv8JR?=
 =?us-ascii?Q?PGiUGFsr0odxb70gN1QwHqyCCO+0NI+2aiODi6VTdtK99WTJarV3OH7VWizZ?=
 =?us-ascii?Q?SYAhWZmWUcIOK/Ryja7i8g7zkCDFbc8nzM9JypuAif5SjVAv1ihQXS0sTNGA?=
 =?us-ascii?Q?6hy1vBkLHdMtHMCqFBBoNFRWqaknvI1k5zT5NDsy/W6cj0LfiEhXFKgVNCsI?=
 =?us-ascii?Q?HgStZp2EH3KQgCCpB6R6/5afP0v/tg7D+VRpmz0TY0v3T7580F1dZ8djsvcK?=
 =?us-ascii?Q?HiKuaOTVfUO3+mGGzr88U+3pWk/SjUgDEqTaBPw3N8xa4rtFYBBYxaKY8R73?=
 =?us-ascii?Q?PU09fg7b/Ha3rsVskyBxpcX1/QrDSPFCto1RSiiAlgHuvTUOgIcmoxyc0pN7?=
 =?us-ascii?Q?GOCMWypXPwUw2g4G1UyMynGaM6WukaKuVl9Mjrku41QiBV5y+APNGxgAruJg?=
 =?us-ascii?Q?dVBlLBAcllrwj3/CTz1p2rV7uz9bd7CR9AVsEEIPbnIxwWNjQ48JACWntArZ?=
 =?us-ascii?Q?L5jOMSP4uIHTjhSqyT3Z+qpzDzLoiHi/1OFmbqLe1fz2KVP/pZe5PQenZ1Sl?=
 =?us-ascii?Q?3+IVC0H8lCpQxannnWVW2nwFNxwfNNRVsVXO546kXytoqQGYP3XYHIiVgrSE?=
 =?us-ascii?Q?qXO8UHvLNXqKuNnlBPae8ZI9R0tYjXihEc3BbmNrzq+yIIgyz6CPA/jX3xJy?=
 =?us-ascii?Q?Mnn4zqMIUjGg/B9Mgtr/bcHuyj2soapU6Jku1kUEqh1YleKYUciUsPqb/9v1?=
 =?us-ascii?Q?L8O/S0fzlOi6pxMvfk6/6+Q+klRjJ3XvSxovfVTrpZIy75afo3FTeX9m3NGb?=
 =?us-ascii?Q?3p3ILRy2CvYV9g9jDxeKDNyo9br0vHuQ4UBgkcbgHG82WKU6DrbsuoFuuQF2?=
 =?us-ascii?Q?k1wZhXRP66Lwj0jaPCsz6SGOpzKJPZ0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5430.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 487ed520-1cce-4841-0380-08da29e2279e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 13:14:13.0048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5MVdwrEloOYMtRup3MUJfNeuDU/xltkgdgGlFwvu2ENcRZyy0bhFnoZVm+N4A6YUduLOCVq72tafUjWPj+y/GpgEBKf+F5PRBZBXPH5jV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3546
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Thu, 28 Apr 2022 18:10:49 +0000 Maloszewski, Michal wrote:
>>> Can't we wait for the device to get into the right state?
>>> Throwing EAGAIN back to user space is not very friendly. =20
>>=20
>> When we have state which is running, it does not mean that we have=20
>> queues configured on PF. So in order to configure queues on PF, the=20
>> IAVF_FLAG_QUEUES has to be disabled. I use here EAGAIN, because as=20
>> long as we are not configured with queues, it does not make any sense=20
>> to trigger command and we are not sure when the configuration of=20
>> queues will end - so that is why EAGAIN is used.
>
>Let me rephrase the question. Does getting out of the state where error is
>reported require user to change something, or is it something that happens
>automatically behind the scenes (i.e. the state is transient).

It is something that happens automatically behind the scenes.=20
It takes some time and there is no guarantee that it will be finished.
