Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8779230E750
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhBCX1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:27:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:48928 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhBCX1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:27:46 -0500
IronPort-SDR: /hFp+0JS3SDM+XQCRvHKtron76iB+oy9UBUWKOjmhL68g4O/bpHOWYaGw0nLuzh3IOd6LqD0PR
 39Z9w/AdzIiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="168818220"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="168818220"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:27:02 -0800
IronPort-SDR: z3zwkvSdmDim37+NX22SESgTf5QkR4pEO6qIDcIAhdt45dl+ounw2CZuyiCrf8F4nkzpOkGjgR
 0QwLBCP+R+4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="372624412"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2021 15:27:01 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 15:27:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 15:27:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 15:27:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 15:27:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y96HlQAwbGeDOHx59xvb2hfaJ0fZ+nFwyBUtmKvYnk7CMdwA3svW1QPwqCVmXrQu4EG5IAiDrrX06UYKdVu4K6eGqI1SNxnhCImzVfOvcgakySQoOg1uObcilrMdYztsGzLQhLodjR5Lrte6zuajdMZIQmb+WKk7UVJHR/Or+TgBk2zQN3/8Gp/AuTXmA4rvAFr+A1IohsbvPwJg0nAMBKvXC5oSrRjGekjZga3f3KVk0KxbudzB9ZW9dL7Ad2Ah5Z2Qae/odRrKMGvwdTyzw9NjHphLS7UG082jkgXowEKg6ZdNBa6ZNqH+7teIV4hF65nCUVAB3xHCPXfTIijGbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGUCMZlwSGz+W22JSinjlMB0hyCGqcEHnWhqvRFZ69w=;
 b=Pe0tCvp4J3z5ypM+E8jMQZ7g1SMXTEfY9tNRDTkNIc8/zySroW53guhcURHvJ+8rzlr3uXJyWLidAIMo4kzx2el8+P9Il2d2U2/lBlx5DHhCaviiw76DjqWrsqxnpxkwKlBsXixG8BNSr6WoG7ynrdJEoCXM4L4MNK7Xtzsf8qH2IqzlvY1lrcwD9l5FsPA8a2P9sKVbxDJY5MQ9tbUEhowJwiqYA8e7g7gCkKXRLuxvfiyCuQ3BqozQ2BeCqJ6fQ8uhE9ZmFngDS4U0XyOANZyMCoW8hBf2GEdn9m9zZzM5ynwCwrR58IFBiHmwcHVLjwiUll36xos9PKmbkOlspA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGUCMZlwSGz+W22JSinjlMB0hyCGqcEHnWhqvRFZ69w=;
 b=UakyC6CQDfN8Lmbg9vqC5Gj+s+GT9zseqslMJQg4NxIUwLbxXZBDFS3D9yt/hAbdiGVJEEqnfT/9pIItl1IlTDZm6OAIz72B4oGygoLSu5K4l2t4+rccugwkaNPVnQP4VQt13KdKPYmGfOmwTYb56hmeXvM0S1S4KeO/mmamA0U=
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM5PR11MB1353.namprd11.prod.outlook.com (2603:10b6:3:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.24; Wed, 3 Feb 2021 23:26:55 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::519:e12e:e1e1:517b]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::519:e12e:e1e1:517b%6]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 23:26:55 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
Subject: RE: [PATCH net-next 5/6] i40e: Add info trace at loading XDP program
Thread-Topic: [PATCH net-next 5/6] i40e: Add info trace at loading XDP program
Thread-Index: AQHW+QpxBEoCi9GInUKx4Tg4yRhaSKpGMgfwgACRzYCAAFDLsA==
Date:   Wed, 3 Feb 2021 23:26:55 +0000
Message-ID: <DM6PR11MB465733FAB1743B925E4A3AC49BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
        <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
        <DM6PR11MB4657968657193183F2082BC79BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20210203103241.7e86ca2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203103241.7e86ca2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [5.173.176.249]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fbdb634-260a-44e0-6374-08d8c89b31ef
x-ms-traffictypediagnostic: DM5PR11MB1353:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB135356276E793615DBFD7EA69BB49@DM5PR11MB1353.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f6buYaDW0piAcVc9PMU9ipqZinkq60oW+opPFRYYtnzr07nxiz2mjRl7vvjnX0G7fhN3QTyMa3/FH/s+H3KFhDnztoQ04HTghWbX49ydjsT8/EkxHACHaJD3TprAaOA+6n5iTbnf4CK2RaxsuHMHDhst/dH8wykdtblAaNBP7PihP0PqzKMh0FRhRVDrgOd5tx+waYRLHuxQ38sDrR51pPqI6YW7yvrMEkJnNuNgX5DBryob+s9OduNKe4uqYLu4qNz/PeKOLSCgASUtDGJN4bZFMOeijcwqgfMnnHGIK9Kg2Qp2JGYr+2JRDcrm2iYvT9tw2aThEfo57phLiXoAv6lJktEZpmRSFERCHlzPuBFGKa4QXtf5rG1BRqykhk2iAxKrnJ/DF/9MGKxV2KarxKP8tWwRIPWfMBzTvetoVX36sEfTACHdLbDV7ZQCDXohwq3oTmkEuMNp7TiZGqkwATDMPsEoZ4fIq5/FpDe2qHPxwgJbUm9WwlcBp34YvMsGjqoXZwVV9aR2IQ1sRxU0yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(6916009)(66476007)(52536014)(9686003)(66446008)(76116006)(66946007)(33656002)(2906002)(55016002)(107886003)(478600001)(66556008)(26005)(83380400001)(7696005)(5660300002)(86362001)(4326008)(54906003)(316002)(8936002)(71200400001)(64756008)(8676002)(6506007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GcEzl9M/aoCApmXm+gQv32be4oTSTKvgM7/NJcYWOw+ZuWbAmKGj+r0ChUBd?=
 =?us-ascii?Q?0V1A86Jx5gCSbDW2EcLkb5CQhIoKRNzVjuj8UOjhnBHbl2sup6EC41EUq0UP?=
 =?us-ascii?Q?1Ia0c4eMXm3DqSDnkOxac91EGYTkQW6Opxhr6tZKQ+xdFsTZV816hUu6DGp7?=
 =?us-ascii?Q?5tsO7ikxLjMC1HOKzQxXHTfkruXNPbndavfLTA2G1zI93hBdB0oragJo5LzO?=
 =?us-ascii?Q?LqhbN817OldM+fumdj6qJtAtH8nBcYTzcETcSr1q/G/YtQG3ZjIjDY9cXoSv?=
 =?us-ascii?Q?QS6mZHd/gvgQffNGCG+iRo5M/bAa2x5iBiLhZgGlbbV+tZcMntqbseKCj8Wo?=
 =?us-ascii?Q?A8+KOCSL23xIZAVwMiqCqRjDXyw3He9jdS8OfZfUNqnD484jEdgK/YHAWZST?=
 =?us-ascii?Q?HcSS47ghPsZne4t2PvxlMkCZ28lgdqYU+AWjCjkJ7RbzMMh6vGy1auU9URAz?=
 =?us-ascii?Q?YCJ6xOP9k/ZDTRQlrpCu8bEfHjePQVKRcV3VbqwhH2KK4O7AWQ44I1CqHbMK?=
 =?us-ascii?Q?pGh/IdA2kdTpqxVRbfrPsYIyBC2keSSPI1LbLKhN64E/dfrXomaAEVuQ2j7e?=
 =?us-ascii?Q?uvVmL6Uz9KNS2GUdGj7zML/01v+F7SIeUOppt046OShVPU0PYGGKxBfklygg?=
 =?us-ascii?Q?jshlJn13lwo7pLBB0gle/0dxpxclXz1lXwz5VuaK90pLQmNSQdkXfu9mWCoc?=
 =?us-ascii?Q?Jzext4SawOFkmeEWPj2YOsdVI4SECov2vH1jU4OeEELz6chMLrJg8+6IJmK9?=
 =?us-ascii?Q?faSvT9RrHblMVyzfZpqYeKfyZqNODJ67Bp10nqzWnqulnT6Rvd8Mp6C7V5a9?=
 =?us-ascii?Q?gZk+oJJSf1YkIOzcpuvUJurqazKaaYqMSOh3PMvpqa/+sZAkuUhmLgXxpnYs?=
 =?us-ascii?Q?KVG9L+3mSk7J8ZzeDbsVkGr48ZOVPZrkJl+1tSUKb5LeJrIyJXQy/Eg9w+ax?=
 =?us-ascii?Q?MJajFxa5nSocDMbtSBOERugAgH96zxxuFEWV+YoZQ4wIaA4KQSGj72UFJMFd?=
 =?us-ascii?Q?aahqxHxpa52+UVvW+NBcWM3pC4tZ02lft6ML4t61d/+HfeJprLIZjQnnHjHT?=
 =?us-ascii?Q?azyQOl4p?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbdb634-260a-44e0-6374-08d8c89b31ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 23:26:55.5237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /k+m5lliLFU7+g81iQS81ttR2MUILxdPbwwc/prJyvCAKiBUVccgzD9V7/y0PVTxOzQI5Zn9/+ymei6bid54JnhnE3p44PtAMFhgaC2DY2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1353
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Wed, 3 Feb 2021 10:00:07 +0000 Kubalewski, Arkadiusz wrote:
>> >> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c=20
>> >> b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> >> index 521ea9df38d5..f35bd9164106 100644
>> >> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> >> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> >> @@ -12489,11 +12489,14 @@ static int i40e_xdp_setup(struct i40e_vsi *=
vsi,
>> >>  	/* Kick start the NAPI context if there is an AF_XDP socket open
>> >>  	 * on that queue id. This so that receiving will start.
>> >>  	 */
>> >> -	if (need_reset && prog)
>> >> +	if (need_reset && prog) {
>> >> +		dev_info(&pf->pdev->dev,
>> >> +			 "Loading XDP program, please note: XDP_REDIRECT action=20
>> >> +requires the same number of queues on both interfaces\n");
>> >
>> >We try to avoid spamming logs. This message will be helpful to users=20
>> >only the first time, if at all.
>>=20
>> You are probably right, it would look like a spam to the one who is=20
>> continuously loading and unloading the XDP programs.
>> But still, want to remain as much user friendly as possible.
>> Will use dev_info_once(...) instead.
>
>Not exactly what I meant, I meant that it's only marginally useful the fir=
st time the user sees it. Not first time since boot.
>
>The two options that I think could be better are:

Well, I know that this is far from being perfect.
If I understand your comments correctly:

> - work on improving the interfaces in terms of IRQ/queue config and
>   capabilities so the user is not confused in the first place;

Improved interface would allow the driver which is being loaded with=20
the xdp program to receive configuration of the other NICs=20
on the system. (its number of queues/IRQs), and in such case we could
warn the user about possible drops.


> - detect that the configuration is in fact problematic=20
>   (IOW #Qs < #CPUs) and setting extack. If you set the extact and
>   return 0 / success the extact will show as "Warning: " in iproute2
>   output.
>

It seems like this is the same idea? Detect number of queues of other NIC.
Then warn the user.


In general I agree and that was my first idea... but after all, we decided
to just try hint the user, that proper configuration is required.


(Hopefully) the proper solution..=20
With my current knowledge and understanding of how XDP_REDIRECT works:
It cannot be loaded with iproute2, it uses bpf maps thus it also
requires an loader application to create ones
(i.e. the one from samples/bpf/)
The sample uses /tools/lib/bpf library calls, which uses netlink to=20
eventually do the .ndo_bpf call on two ports. The one responsible
for the RX and the other TX one. Although XDP can redirect to more then
one TX. Thus proper solution has to work for both cases.
In case of two or more devies used for redirecting TX (i.e. properly
implemented xdp_redirect_map). The interface which is used for RX shall
receive the lowest number of queues/IRQs of all the possible TX interfaces.
Then it can properly warn the user.

I think this is doable, but it requires changes on all the way from
bpf program loader, through: libbpf, netlink, net/core..
Probably finally extending netdev_bpf with a field that stores
the lowest number of queues of the interfaces which are used for TX.


Real proper solution..
Please, let me know if this is good approach, especially all the XDP expert=
s.
Maybe there are similar problems that I am not aware of?


This patch..
So we end up with the user which has to properly implement its
bpf xdp redirect loader to pass the proper number of queues to the
RX interface. Even with all the above changes in the kernel and its
interfaces he still might not know that something is wrong with his
configuration/code.
Thus, even then information added in this patch might be useful.
At least that is what I think.
