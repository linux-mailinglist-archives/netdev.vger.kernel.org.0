Return-Path: <netdev+bounces-758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA8C6F9A0A
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 18:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A93E280E98
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 16:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80635246;
	Sun,  7 May 2023 16:32:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28A32FB3
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 16:32:38 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D0B120B5;
	Sun,  7 May 2023 09:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683477156; x=1715013156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=ltiPa5T02DpH0XabyuZz/fYM/yxik/aDS6cGVVZabuk=;
  b=BGb60ct0ll9EXcJwbSVPjt8uHxor0uz8OYxbOmy21u175KhdxHnQOyha
   VqQFA3xQgULuFmKJlyzoSBDYsrUJkcrOSQYP0+gJr5UgmlAavUExxrzUI
   3QfOUrZ471dUCMr5PE+zAFhUJkBfVP3lBNxX2rkMqAsQ4XMfd+MMpFCuF
   62Vl7bs5GPy+5biwv2OWed6e1GNEhCZsbU1tDQdBOwHoz6VaLy/QnQOle
   +SRA/VMkNtsAOc7pKQBjlyOB/sdWRBwOzpORK0NDADnpOiZCzWID1XyiC
   bIP0Tx2BAYUTeYwFiWXE4qkLKKfLsSgsSDxFei6mMVC7YVKdlOqvmBU7k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="346965078"
X-IronPort-AV: E=Sophos;i="5.99,257,1677571200"; 
   d="scan'208";a="346965078"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 09:32:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="675794924"
X-IronPort-AV: E=Sophos;i="5.99,257,1677571200"; 
   d="scan'208";a="675794924"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 07 May 2023 09:32:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 7 May 2023 09:32:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 7 May 2023 09:32:34 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 7 May 2023 09:32:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuTXZnIC6r2Ih9fsmY7m4uK/tBLlgVf1BwcAsrO/sItfPjapdLNtJlG9ip6nMG74q9UPoiydzPWTDGjTfC9RwrSjUYiHrulUNSugxuATGChi3kNzEIm0uRtSS9pbrpmuMi5i80vxYywCYvqmzyiDrv/UueiOw+ydzr8KhbhKLXOpQl24RranLfQWU9RaNrXAUEeTJsAxiT6N5HRyKOKxgECCLc9jyXltSBeVUjmHCMpFS2cv+QLYm1GJnWic/Tac4T2ELQoV/WygZXQR6EYhx6YwlTj9/DBdxLfoxElQERc5nqmmlNcds15KAe+GOwE1LgsZrbibKhBc3oI1df3s1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpuPCGPEXy642184aR4l1z3nkBHTcRp9lu7gRtXy8Sk=;
 b=Dgkx/53kSe9migPzgq5ZXmWzdtzH++llIBtfBDUSVAWpcaY77kn2c2hPe/x0ANKfIj1urQsgMmt3/lDKukgB1NI9ZQxvCqgbTi4k1p0WuZlXNX+RWhK8sN8eQdTYuQDlsQ0zlMMsvGTL9QAfgGEWyu+/1MCEM5QgSTTn/lv0NkGxshetkvuJISly1uU2QAUt+uX+mFTwWrqPbcWh6piDiewvuCqhgi0oo8smnet3tPiguxJRfErBroXvMNil6VjZIef/p0SC3E9SemnKTmGzDQT1QP5/y26JjxcCFwbhP4UPiSyWouWEfXpEnSTiyNjkI+W88fjGyPf1uh2TZdZkmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17)
 by SJ0PR11MB6719.namprd11.prod.outlook.com (2603:10b6:a03:478::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Sun, 7 May
 2023 16:32:26 +0000
Received: from SN7PR11MB6996.namprd11.prod.outlook.com
 ([fe80::338b:763a:ac40:d509]) by SN7PR11MB6996.namprd11.prod.outlook.com
 ([fe80::338b:763a:ac40:d509%7]) with mapi id 15.20.6363.032; Sun, 7 May 2023
 16:32:25 +0000
From: "Stern, Avraham" <avraham.stern@intel.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: "Greenman, Gregory" <gregory.greenman@intel.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "johannes@sipsolutions.net"
	<johannes@sipsolutions.net>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: pull-request: wireless-next-2023-03-30
Thread-Topic: pull-request: wireless-next-2023-03-30
Thread-Index: AQHZbbjNzP9gzb4bwEuw1qGhSN1B8K8xGe8AgAJ/PgCABVt224ACIUqAgAA5hgCAAFSOMIABUl4AgBHRHSA=
Date: Sun, 7 May 2023 16:32:25 +0000
Message-ID: <SN7PR11MB6996AC8973769149D0A7BA5CFF709@SN7PR11MB6996.namprd11.prod.outlook.com>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org> <ZCtXGpqnCUL58Xzu@localhost>
 <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
 <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
 <ZEC08ivL3ngWFQBH@hoboy.vegasvil.org>
 <SN7PR11MB6996329FFC32ECCBE4509531FF669@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEb81aNUlmpKsJ6C@hoboy.vegasvil.org> <ZEctFm4ZreZ5ToP9@hoboy.vegasvil.org>
 <SN7PR11MB6996324EBF976C507D382C3AFF649@SN7PR11MB6996.namprd11.prod.outlook.com>
 <ZEiP3LDTQ86c4HaN@hoboy.vegasvil.org>
In-Reply-To: <ZEiP3LDTQ86c4HaN@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB6996:EE_|SJ0PR11MB6719:EE_
x-ms-office365-filtering-correlation-id: 498a06b1-db5a-4e9c-8570-08db4f18a40e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UbmAMK66KZRSP9p7jVQpkBZbsPvp/TqP1h2ahlY0hDO0Elmz/g/TsZEGnsk3oFgGDpA9sdoqqCxwWtM0qmRa+BRs6pbXWW4QxMEL4TMf63Bb3bN2LGYW4nVbTfY79pxRp/UR8N3pBJ4QNavqJsG6sEsgHk2UmmDl2d3jDsmUQL059nrwQGXJ81MpY551qI82VpuSbOj6GDabNI4choa7ifpg7jFk5tSRLbBg5fyW8o3pwY/HdJsvFd6afq679zzTFsjPJXotYWdtqKt3ltY61/E7yYFJO8TZLUX2bRbQvUSMDqp1NHu7GSCZ46e+HVm0TwxAfytfN5JBq2AsCG1nannzmyCiDXWiWIMqIZpjKosrufZpfYp/F6H+Psg6OoMxfy8ejkDvSDlBvTH272sCFnHs2CQjrn3HPDtcQNUYhXpSx1qnfOa6k1/JXHhfV9vskPwkrz0DCtBC0t1SiEylZJdORGQ4b45ajzAXmaSJA1ViRi6jlk9frUDg0jW3wgzukg46Ed5bd04k03fqeaJ21Onj145mP5DI+Ur1gCum0P5k2gW4ItJldeXUYj6bTLUydQEAJsIVKmmiuReJwVsKMzSitYPd9V57iA4BN35gfpTQwDGDMzOQ8PbPlj7tjsP2a3cSaYt+W6yt0HBApf4+P1hkTgv+F3qOqoGA1V0CyNU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB6996.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199021)(6916009)(4326008)(30864003)(2906002)(86362001)(52536014)(5660300002)(316002)(8676002)(54906003)(8936002)(41300700001)(71200400001)(55016003)(66476007)(66946007)(66556008)(33656002)(66446008)(64756008)(76116006)(83380400001)(122000001)(478600001)(82960400001)(38100700002)(7696005)(53546011)(9686003)(6506007)(186003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?55v6LtedhH8nZ6SQ593rVgz/YZrNgIFp5PJH9tY5uXnp0hNvYSHJG5kSSmoj?=
 =?us-ascii?Q?4SXzuc7wLZpTZLdRDVlRKBW+HB+5Ij8WEhcmsfgZrSYjTjib0KXiKoWzeZtV?=
 =?us-ascii?Q?dg2tLumznXblzXeqeC6qbSMH6h1tOugckjgegB+a2fnmKqT2YOIqXui/NPfu?=
 =?us-ascii?Q?zHbTOoIMwQ3gXrNOJnXylAm5hE8HSYGKvOmCaMPW7I17iB9gIZ+Wti6aIYSj?=
 =?us-ascii?Q?cadbPIP/JVOv48r5TPwTmLpvuyqtBzmiq9LiZ5gZfQGwDE56Uqc+LGeAAQm8?=
 =?us-ascii?Q?wS+ezmXDey5ExxJOvuW/6OMc/3BsROJVJ1Qnnv6CZn/KXolKC+DfuutGq46M?=
 =?us-ascii?Q?E1KX7+Ds/NByFcpU29k24yMSOoMuU2dfO3cVkruLD7wDxaHO++iZ7xUkzTSL?=
 =?us-ascii?Q?iJml4uLS02jNo69C/YORUgu2yC044VgmoQ1Jh6onID35p8eSdMmZYp5WzXms?=
 =?us-ascii?Q?89SoMGDqr7hIqiuKTp5n88cNU/SaXS1TdPF/HHyBBAJSFzg/W4DVJQdPWi7T?=
 =?us-ascii?Q?+zHeDYvcfbAVMYitp+51TNSIBNM+wTQT27HnKXvJ+5U3bikQnympg0Gu50Kn?=
 =?us-ascii?Q?+IM7pyX79prSIt4+RPWPTD8a4ztg5qIpqJcEcAcF0vkHUSDmP4M9HASPlmOU?=
 =?us-ascii?Q?CiUUY0dGTtHJCuLfOWYW8ZCr40WdVjLuEzKIXUEKUOjrw4fhbYquunRNk8VQ?=
 =?us-ascii?Q?uEEQFElIutBxuEvwdhB3/Sb9OtuSzj9QS9wKDX3k8qcxJWpOHs+5s3OiizSM?=
 =?us-ascii?Q?7Q6gFwPVJePG4yTErtOAlQR3Tnm9Wt8RMqNpcNpp7C5GFV7c+hcdW9aARckR?=
 =?us-ascii?Q?ybjeGYDkLZatoYTjLCe1kxbLC1ocanaXs9dJmqZAoE0rHfa90NnpAd73JAw2?=
 =?us-ascii?Q?yY1Y6rqeFNxVn6M5Bap5DD2mIrPwbis+3wgbuTTz7O+ior3aNoMfzaCX16cL?=
 =?us-ascii?Q?xhY4ucd1UVUh+zbt4s2o5XZUIgT0TkjXn4/c351FZ2cRWs01+YzJZzJiuRPY?=
 =?us-ascii?Q?UwJcs06Ot15bTcW562Oz4U+m+Zc2+hb4aW54vS2Yr95oWXFn3svFaCPpgMfR?=
 =?us-ascii?Q?vuW7hhpXV9gRlCncqpZc8eiI6TurU8fxe7BbsfkYVazneNpvU0eKMkXK7aIN?=
 =?us-ascii?Q?ecBsbL6D1/b0RUFGYqJuRsulG70DzUB3lIy4HEfDQLSJcsJPebsNga7Bx7X8?=
 =?us-ascii?Q?Vk2VYC6TxA79ZD7WGnJcJYWe6di90cO/NRXOyNL6r9p+4rPit3dfa9pakcSw?=
 =?us-ascii?Q?MMAdyUpx460FKeQ/9oytaGrVRLvgUJMCQ/WK034sB6BWRZGWma4HniJPyHCx?=
 =?us-ascii?Q?yAxm0XYtIKJztGCaNEGc8uVVleRWFKQ8QLv8tOvv8IYjwBm2kHWaZpwD6EE6?=
 =?us-ascii?Q?2gQAJcgazDv8KbgLEHMIM406ppYtYlDFjEHu+7RnT7BOGOL4jmpinVrfbKg+?=
 =?us-ascii?Q?0AUspc4N4a1DkQdsrCFJzrl5AxpXb2S6M0Cnte8rOWH7ExE57uAcrRM8R7eC?=
 =?us-ascii?Q?vwUJdAEoUsgaf9lWGJxBbzHEwflhtS+4D2qQukJVFJoPlv7FCvTeY6ulb4WT?=
 =?us-ascii?Q?Z61XAWaDnbqMJ2QRtmt8TugEBtQwY+3YNsdsViE5gKs8Lsm4wc2U1sYOS2iw?=
 =?us-ascii?Q?yK3K6KnQ9tKptKxlmgJtCZa3fJMnGOf799lzzC3FiUPi?=
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB6996.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 498a06b1-db5a-4e9c-8570-08db4f18a40e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2023 16:32:25.2836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PRBdXEN0p8SzV7XnZ6eI//juc4o5Z6COQAF9Cmisjp8/GEOdWV4DuGjb+hsH6Q3aM2/YPSyEBNWItaXrqWY+WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6719
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Richard,

I will try to explain my point of view on the topic.
I tried to highlight the areas where wifi may be different from ethernet.
The below is only my perspective, in order to get everyone on the same page.
Please comment/correct me wherever you find fit as your perspective is defi=
nitely broader than mine.


The PTP protocol consists of 2 primary parts:
 a. best master selection algorithm using "general PTP messages" (messages =
that are not timestamped)
 b. time sync, using "event PTP messages" (messages that are timestamped)

A. Master selection algorithm
----------------------------------------
Regarding the master selection, PTP requires that announce messages are del=
ivered to all PTP ports within a ptp communication path (which may include =
switches, bridges etc.).
For that purpose, the 1588-2019 standard defines that "Announce messages ar=
e either sent in multicast or the Announce information is replicated to all=
 PTP Ports in the PTP
Communication Path using unicast PTP messages." (section 6.2). It seems tha=
t multicast frames are used to allow the announce messages to propagate thr=
ough transparent clocks or
components of the network that does not support PTP, but has not effect whe=
n the receiving PTP port is a boundary clock or an ordinary clock since the=
 standard specifies that
"All PTP messages except PTP management messages are terminated at a Bounda=
ry Clock" (and ordinary clocks only have 1 port).
In wifi networks, the usage of multicast frames is limited since only the A=
P can send multicast to all associated stations. A station that wants to se=
nd a multicast frame sends it as
a unicast frame to the AP and the AP then re-sends it as multicast to all o=
ther stations.
However, the 1588-2019 standard specifies that "Special Ports shall be used=
 to transfer time over a network where the time transfer is
not based on the use of PTP timing messages" (which is the case for wifi ne=
tworks. I will elaborate more on that in the time sync section) and that
"Special Ports shall be used only on Ordinary Clocks or Boundary Clocks" (s=
ection 11.5.1), so on wifi networks there will be only ordinary and boundar=
y clocks, which means using
unicast instead of multicast should work just the same. Since the stations =
must be associated to the AP (otherwise they cannot exchange data frames at=
 all, so can't send/receive the
announce messages to begin with), the unicast addresses are known both at t=
he station and the AP side.
So to summarize, using the unicast option for announce messages should work=
 on wifi networks without any changes required.
Let's examine some basic topologies:
1. The basic wifi network consists of an AP and several stations:
     Station A <---------   AP --------> station B
     =

     In the common case, the AP will be master and stations A and B will fo=
llow.

2. In a Case like:
     GPS Radio ------> Station-A ~~~~~~ AP ~~~~~~ Station-B
           1PPS              WiFi      WiFi

    The AP will act as a boundary clock, with the port connected to station=
 A as a slave, and the port connected to station B as master.

In addition, the AP can also bridge Ethernet and wifi networks, acting as t=
he boundary clock, e.g. as a slave on the ethernet port and master on the w=
ifi port.


B. Time synchronization
--------------------------------
     PTP defines two mechanisms for time synchronization which are used ove=
r ethernet: The delay request-response mechanism and The peer-to-peer delay=
 mechanism.
     Both use a similar mechanism to measure the path (or link) delay:
     1. transmit a data frame from peer A to peer B, save the transmission =
time (t1) and reception time (t2).
     2. transmit a data frame from peer B to peer A, save the transmission =
time (t3) and reception time (t4).
     3. send (t1, t4) or (t2, t3) to the other peer.

     Using these mechanisms as is over a wifi link is subject to the follow=
ing drawbacks:
	(i)      The 1588-2019 standard outlines that these mechanisms "assume tha=
t the master-to-slave and slave-to-master propagation times are equal.
                        Any asymmetry in propagation time introduces an err=
or in the computed value of the clock offset. The computed mean propagation=
 time differs
                        from the actual propagation times due to the asymme=
try."  (section 6.6.3).
                        However, in wifi networks the station may be moving=
, which makes the propagation delay change over time due to the changing di=
stance.
                        Because of wifi power save mechanisms, the time bet=
ween two data frames may be relatively large (e.g. an AP with a typical bea=
con interval of 100 TUs
                        and DTIM of 3, the station may be in power save for=
 more than 300TUs, so the time between the sync message and the delay reque=
st message may get close to
                        even 500ms). So when using data frames the propagat=
ion delay is likely to be asymmetric, which will lead to time sync error.
             (ii)      over wifi, a frame may be retransmitted (if not acke=
d by the receiving station). This may lead to a situation where station A t=
akes the timestamp t1 on the
                        first transmission while station B takes timestamp =
t2 on one of the retransmissions (or vice versa). This will introduce a sig=
nificant error since t1 and t2 are not
                        referring to the same event.


    The 802.11 standard defines mechanisms for measuring the path delay, ca=
lled Timing Measurement (TM) and Fine Timing Measurement (FTM).
    These mechanisms use a similar principle for calculating the path delay=
 as the PTP mechanisms, but the timestamps are recorded on a management fra=
me and the corresponding ack.
    This eliminates issue (i) , since the ack must be transmitted 16us afte=
r the frame is received (802.11 definitions). This make the path delay symm=
etric for any practical use-case.
    Using the ack for measuring the path delay also implies better usage of=
 the network: while in the delay request-response mechanism, 4 frames are p=
otentially needed for 1 measurement,
    in FTM 3 frames yield 2 measurement results (which can be averaged to g=
et better accuracy, for example).
    In addition, the 802.11 standard defines the retransmissions behavior f=
or these specific frame types to eliminate issue (ii).

    In order to use the pre-defined 802.11 mechanisms to measure the path d=
elay over wifi, the 1588-2019 defined a new port type - the special port.
    (as stated in 11.5.2.2.2: "This interface is new to this edition and is=
 introduced to facilitate the use within the PTP protocol of media
     that implement their own methodology for measuring path delay and tran=
sferring time, for example, IEEE Std 802.11").

    A special port has a media-dependent and media-independent parts.
    The media-independent part is responsible for managing the master slave=
 states and calculating the time synchronization using the inputs from the =
media dependent layer.
    The media-dependent layer measures mean path delay and sends and receiv=
es time synchronization information (passed to the media-independent part).
    The 1588-2019 defines the interface between the two parts, called MDMI =
interface.
    The operation of the media-dependent part for 802.11 is further defined=
 in the 802.1AS-2020 standard, which defines also the state-machines for us=
ing TM or FTM
    to measure the path delay, the measurement parameters etc.

    To summarize, the standards (1588 and 802.1AS) mandate the usage of spe=
cial ports and TM/FTM for time sync over wifi, for the former mentioned rea=
sons (and probably more).

    The 1588-2019 also defines the usage of a special port for boundary clo=
ck and ordinary clock only (but not transparent clock). This is a results o=
f using a medium specific method to measure
    the path delay, which is defined point to point, which is not suitable =
for a transparent clock.
    This makes the "AP as transparent clock" option not supported by the st=
andard (the AP can be a boundary clock in the station -> AP -> station topo=
logy).
    (theoretically, the AP could be used as transparent clock if unicast da=
ta frames where used for timestamping, but it would be subject to the probl=
ems mentioned).

There are also implementation considerations to favor the usage of TM/FTM o=
ver timestamping data frames:
Recording an accurate Rx timestamp on a wifi packet is difficult because th=
e received signal may have interference, reflections etc.
Multipath detection algorithms are usually used to calculate a more accurat=
e timestamps. There algorithms are relatively heavy for network cards. Havi=
ng to calculate them
for each data packet will introduce an unnecessary overhead.  Of course, th=
is can be minimized by calculating the Rx timestamp only on data packets th=
at are used for time sync,
but network cards usually don't inspect data packets for their content, so =
they may not be able to easily tell which data packets should be timestampe=
d.
On the other hand, many network cards already support FTM (for ranging) so =
they already have the ability to timestamp FTM frames.

After deciding to follow the standards, the next question is which protocol=
 should be preferred, TM or FTM?
As implied by its name, FTM has better accuracy. While TM has units of 10ns=
, FTM has units of picoseconds.
And as formerly mentioned, many wifi vendors already support FTM for rangin=
g (which TM is of course not suitable for because of the low accuracy).
So it seems FTM should be preferred if possible. (in fact, TM is probably o=
nly left for backward compatibility, but  I don't know anyone who already u=
ses it for time sync?)
Anyway, adding support for both is also an option, since the building block=
s are the same and the TM protocol is fairly simple.


Kernel interfaces
------------------------
The kernel currently have 2 interfaces for the PTP time sync.
The first one is the PHC interface for devices to expose clock operations.
This interface is related only to the media-independent part of the port, a=
nd thus can be used as-is for wifi interfaces too.

The second interface is the SO_TIMESTAMPING socket options, for timestampin=
g data frames sent/received over a socket.
This kernel API is not suitable for wifi which will use TM/FTM, since TM/FT=
M uses 802.11 management frames for time sync,
not data frames. 802.11 management frames are not sent over a regular socke=
t but using NL80211 APIs.
In addition, for TM/FTM the timestamp of the ack is also needed, which is n=
ot supported by the SO_TIMESTAMPING socket options.
Thus another interface is needed for TM/FTM timestamping.

The kernel already has NL80211 APIs for triggering FTM measurements. Howeve=
r, these APIs are tailored for measuring the range
from the AP, and the result reports only the distance from the AP, but not =
the timestamps collected for the FTM frames. As such,
it is not useful as is for time sync because for time sync the timestamps a=
re needed for the media-independent part to calculate the sync.
In addition, as specified in 802.1AS-2020, for time sync the FTM frames nee=
d to include a vendor IE with all the PTP data (sync or followup messages).
The current APIs do not allow adding IEs to the frames used in the measurem=
ent.
Extending these APIs to support time sync also seems wrong since the measur=
ement API triggers a burst (i.e. many FTM frames, each one produces a measu=
rement results,
and the driver reports one accumulated result according to it's own logic -=
 e.g. average) while for time sync each FTM frame should have a different P=
TP data, so this will
make the API complicated and will require massive changes in drivers to sup=
port.

Another option is to add to NL80211 the capability to timestamp TM/FTM fram=
es. This is equivalent to the SO_TIMESTAMPING socket options in a sense - t=
elling the driver to
timestamp the required frames only and report the timestamps to userspace.
This is the interface we introduced in our change.

This API change requires small effort from drivers/NICs - timestamp TM/FTM =
frames only, per request. Since many hw vendors already support FTM which m=
eans they have the
ability to timestamp these frames, supporting the new API comes down to rep=
orting these timestamps to the driver. It is likely that any vendor that su=
pports FTM will be able to
support the new API with minimal effort.


So the basic idea was to provide userspace similar APIs to what's used over=
 ethernet - the PHC clock and a way to get timestamps for the desired frame=
s (data over ethernet, TM/FTM over wifi).
From that point on, the userspace implementation, which already has the med=
ia-independent part, will just need to add the wifi media dependent part (i=
.e. the TM/FTM state machine define in 802.1AS)
and pass the reported timestamps to the media-independent part.
Then time-sync will be supported by all vendors that implement the timestam=
ping and the PHC clock  APIs.
(but that is of course just a suggestion and will require more in-depth des=
ign. Just added it here to describe how I imagined the big picture).


>> IMO, the simplest way that will unlock many use cases is to provide time=
 stamps for single unicast frames, like in ieee80211_rx_status.device_times=
tamp and expose an adjustable PHC using timecounter/cyclecounter over the f=
ree running usec clock.  Then you could synchronize client/AP over unicast =
IPv4 PTP >> (for example) with no user space changes needed, AND it would w=
ork on all radios, even those that don't implement FTM.

I Agree, this would work without any userspace changes, but it is not with =
accordance to the standards (which have their considerations , which I trie=
d to review some of above).
And it still requires devices to timestamp data frames. The suggested API a=
lso doesn't require devices to implement FTM, only to timestamp FTM frames.

I hope this makes things a little bit more clear.
Please let me know what you think.

Thanks,
Avi.





     =




-----Original Message-----
From: Richard Cochran <richardcochran@gmail.com> =

Sent: Wednesday, April 26, 2023 05:44
To: Stern, Avraham <avraham.stern@intel.com>
Cc: Greenman, Gregory <gregory.greenman@intel.com>; kuba@kernel.org; linux-=
wireless@vger.kernel.org; johannes@sipsolutions.net; netdev@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-03-30

On Tue, Apr 25, 2023 at 07:03:50AM +0000, Stern, Avraham wrote:

> Having the timestamps of the frames seemed like a basic capability that u=
serspace will need to implement ptp over wifi, regardless of the selected a=
pproach.

Having time stamps on unicast PTP frames would be a great solution.
But I'm guessing that you aren't talking about that?

> Apparently you had other ways in mind, so I would love to have that discu=
ssion and hear about it.  =


Let's back up a bit.  Since you would like to implement PTP over Wifi in Li=
nux, may I suggest that the first step is to write up and publish your desi=
gn idea so that everyone gets on the same page?

Your design might touch upon a number of points...

- Background
  - Difficulty of multicast protocols (like PTP) over WiFi.
  - What do the networking standards say?
    - IEEE Std 802.11-2016
      - Timing Measurement (TM)
      - Fine Timing Measurement (FTM)
    - IEEE 1588
      - Media-Dependent, Media-Independent MDMI
      - Special Ports
    - 802.1AS
      - Fine Timing Measurement Burst
  - Which of the above can be used for a practical solution?
    - What are the advantages/disadvantages of TM versus FTM?
    - What alternatives might we pursue?
      - unicast PTP without FTM
      - AP as transparent clock
- Existing Linux interfaces for time synchronization
  - What can be used as is?
  - What new interaces or extensions are needed, and why?
- Vendor support
  - How will we encourage broad acceptance/coverage?

IMO, the simplest way that will unlock many use cases is to provide time st=
amps for single unicast frames, like in ieee80211_rx_status.device_timestam=
p and expose an adjustable PHC using timecounter/cyclecounter over the free=
 running usec clock.  Then you could synchronize client/AP over unicast IPv=
4 PTP (for example) with no user space changes needed, AND it would work on=
 all radios, even those that don't implement FTM.

Thanks,
Richard
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


