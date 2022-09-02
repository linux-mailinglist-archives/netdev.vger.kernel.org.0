Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47FE5AA6C4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiIBEHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBEHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:07:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12647A5C6C;
        Thu,  1 Sep 2022 21:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662091665; x=1693627665;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9NZ4cgtI94wbvm/jPNeSOyfp0mYv2G1MQmil/jeZjTM=;
  b=DYqyJ78JhkFIG4YsawCX6xT9+3bYgHr91kGsD1aVVLFnhIfs1VIWSEte
   YbEW5juwpZy+ZJzU73G1oINmt+OkF3Be84XRM1QiTtRhzXHfQopnOZmv3
   mhwK4PXs2HDdPAj0fEMCykoAVumFlvJmHHb+0eK1eb5bJUPSLUhO1UJ1R
   OZwygFS3kn7TrWZ2Ny1oxsY7vkwBV6m8oMobaBAPaZtF9lQLbAxs1UolB
   ULx6aBEB6XQ8Sh3ifL83IpV781qdo0St5LNrNiweAzJk76oOK99dsWPIK
   IMQmCQetttl5oQumdKgZ1vmoOxtX88gVejv78VuYBqc9vmrTLgMwXqT5Q
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="359847873"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="359847873"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 21:07:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674188260"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 21:07:39 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 21:07:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 21:07:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 21:07:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 21:07:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGN+axY4J3Gf+d6DbYOx7ckWIHgwKsw9cZKtoQI2MlYkNmFS1r7K3SOqhnhQEumcokiZLr4qzivOGjH8W6WCx+TtrkjpeDMsjWVmeu16PrCYLAb0yvRttc9Cr6iwoWMsNjHTowctLnjtJpZHXQ4slXkixD6Ue7blfUh14H6R+XqRtCd3vir6kNkqzyf6/dO/BufgHXShQdsSwFAL97yV5K/6xfdRFEHxKwT91uXZBCnYqvgLBeEP47TMH1vx5cR0rc5wqxoVpsYJiy+HCY1Si1OSwla0BLpyI1GYIHu3LuqX+4dIVjsbjV1XW7tpNnBwC9fE+HQG1xHohipc4sjjCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1/ZfTiOPUNKoNMiyPqiu6vX14JIXFNBPQV4a3IybiI=;
 b=f5X7VYVIlQvtEmYefvzGHkhNYXGyEZzQ1tHkzlXDdZqQaRd7/WHojrHYbgswBZXbE6SnbTkBdzVRzaJ1T0Ep7nTzeQ9WMfazysw247KTGxyklldliLoZFt89vL9Wk82ZOjtENQJ9XjBLD6VUBAPjzRLVZBoHGncVf0wwYYwTL3Vn4F8BN/Q2cD7sXztUxnLKs5v0THuISr3yCwhGBugh9x8K525mLL71EecFF+ZV/SQU3MFOmuXN5Vxe8GkYMI+xEZjQDAtdmBJVb75p2UYe6JPdqmvowLjelcI9BtiEexcDb0hnU+o2BBjVy0f/5V9zfQp44nrhS2OVlZG/CCidlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5359.namprd11.prod.outlook.com (2603:10b6:5:396::21)
 by SA1PR11MB7112.namprd11.prod.outlook.com (2603:10b6:806:2b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 2 Sep
 2022 04:07:36 +0000
Received: from DM4PR11MB5359.namprd11.prod.outlook.com
 ([fe80::537:b02b:c656:524b]) by DM4PR11MB5359.namprd11.prod.outlook.com
 ([fe80::537:b02b:c656:524b%6]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 04:07:36 +0000
From:   "Arland, ArpanaX" <arpanax.arland@intel.com>
To:     "Ding, Hui" <dinghui@sangfor.com.cn>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gerasymenko, Anatolii" <anatolii.gerasymenko@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [net v3 1/1] ice: Fix crash by keep old cfg
 when update TCs more than queues
Thread-Topic: [Intel-wired-lan] [net v3 1/1] ice: Fix crash by keep old cfg
 when update TCs more than queues
Thread-Index: AQHYsifFpRD2FOfI4Eieal5e+16MXK3LnJHQ
Date:   Fri, 2 Sep 2022 04:07:36 +0000
Message-ID: <DM4PR11MB5359FA8C8D7923F212B80847807A9@DM4PR11MB5359.namprd11.prod.outlook.com>
References: <20220817105318.5426-1-dinghui@sangfor.com.cn>
In-Reply-To: <20220817105318.5426-1-dinghui@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63756c11-bf76-4efc-fc09-08da8c98ab3f
x-ms-traffictypediagnostic: SA1PR11MB7112:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: No+tHzboVDz3vf8RJYpxYnu6CtVlZPi0ED7J6sDUhsAZ7xFYXlaCUc0WmkF3+3zzmO6otdFQjxInpVOIqZV54PtPdZxXP4fwqkCPjGfP+Y9dKNqhcE8FPeQn7KAlBKOrgpizVwWTshI8o+nDpizAD7l1RMEZcdqoCJvO+9EolaORXbdxIDECyCz1DGUFQC68437LgbkcamxoxEXNLfIUGzcfGEIQ/h/suK0ZMHy2Ccbwpkk/rj2/qddw2Yx1v/0j17m0bIaknIe+XR6lu4actBWH2W4cUzpFeY7I1CY2zQDibzrJ0WP8pFBCXY0+1n0UBacvQci6GAOTl78FoSfqkHCRa5ResfCcBnVcqFRiL5vRH6M8Jwm6DcXaOOkpDU31FtuQ+O8O1KsBAXJvKww+usMnuyUzqU7ipBcAkDre89C2UKTVALeSek1JdL4z5kXbl86298ky+d2vWcZ8W7J1F7tzx4tqiO24T/g/2MxLfZkU9EOoGv6kEeSnm2HnJIcWcclmUW++LuZh/HBVimiFiSQhNaNYlIUKhk/Un36H93GQtXxHp30VwPjRLDrzzZRh11aEhFvZ+6YKdnd1iHu3Il3H4gSvOvd2dM6/ZY58kngYQZdIZ17sccMtfdGnzM60LLw9vlft9RWkkbVHgrXUYeuDWJN0fNd1aHNdaJwIonzzzD1xTxdGpsZN95hT8vV7qVoh40j2/AtrPGrsQ2eFE2SZ1GmXgj/fZCss4LFQD1kt03VGWPNXZynektuCu0s4S08O6h8WH1INBxjctrk2aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5359.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(366004)(39860400002)(376002)(8676002)(76116006)(316002)(38100700002)(66476007)(66556008)(110136005)(66446008)(54906003)(6636002)(4326008)(55236004)(41300700001)(9686003)(66946007)(86362001)(26005)(33656002)(186003)(64756008)(83380400001)(53546011)(7416002)(82960400001)(2906002)(38070700005)(921005)(8936002)(5660300002)(55016003)(15650500001)(478600001)(52536014)(6506007)(122000001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Ze0rgSQZ4YpglmsVSwlwRIMms0IFj0wQA30KHElV8rCauc9FzRDQTCUN3og?=
 =?us-ascii?Q?gYMmNzJnX0vAOyR8PASVwuzso0V1M7I1C69ZWOfxDF1YPUceUUX5eYbCt0iS?=
 =?us-ascii?Q?4/ju5Je2LAw2Ir64a3QOHe9Jk3KTzZEa+cG1cooy2/GPx6omiJ45Q4Dke1A2?=
 =?us-ascii?Q?WbU8KyioftKZjokO14dIOjxYRRWs0dI90sU7BlAeHfXdiekp50VggjOUJPoa?=
 =?us-ascii?Q?8Nk8yr8T9TzMmPFQ9X6K4QYFwtUT32a2JRQ1onPLi+/oaOwNHtUHe3h725y/?=
 =?us-ascii?Q?jc1WMcVW2+g8gyTkw7NPumxvUALy25ewT4Fy/zWNiHjCFkNbVOE0D2Sr/TQp?=
 =?us-ascii?Q?8ehURoQU1f/m7rHA+uq6m6a/LLd8JZfAitk1QPPKyU/4WNkqafTR+AEuAeMD?=
 =?us-ascii?Q?x+c4cpIh9wnD8X0GtdtZBk+QoPFKMQbHsOCE0njOrLP9MJXOf5JwDRreMenJ?=
 =?us-ascii?Q?NCf8WP7tjkolPMJw3I154em3ZhIMSi5pFrAihBRZsHxIcszydSUlVgIBcMRc?=
 =?us-ascii?Q?/6aRh0jIoFtCP5U6lw0afNM2jPoqPu8tp5yxOZxZpM3zO/nV1VVwuBEy0OAA?=
 =?us-ascii?Q?GyHUDOF8Xb3bfehuLda502uH3Cckr2f7V5BxR84vZjhl7OBIResZUIE7Mbet?=
 =?us-ascii?Q?zbxoy7JEv0WtHO6HOPGks849UDJVCpnRiFTxF9CuY8fJIOkse3lZgXYYP1EV?=
 =?us-ascii?Q?hKTqLlAqp+6GVnw7ESf4+5p3x39yqV//g1XJuR9JHiGkYqr/FvaGeKKp9cCs?=
 =?us-ascii?Q?r1OCXx+XQZFSwKxYe5ps/+c37HDeOZXcLoEp9eCXKZNJ49Mwu4NiUpEGnPoh?=
 =?us-ascii?Q?IO/koj+yij0GIt9y7sWQ0AICILqE536WDLCfWJ7v7C70XwN5nFf2Z2qBHAbH?=
 =?us-ascii?Q?yKXVlaChV+PuSX5aN21LSfh3BksPptrYy/4mKwQVzu8uC5oMcFGy2V5ucC2/?=
 =?us-ascii?Q?xJlIdKts2qqDuNyXUYG0ZWUFtXSNnTdYP9uLT9T46cZDsSCqN20aMCoPY7jH?=
 =?us-ascii?Q?kVEPn4WT1zO8GJjFkr76lQGXK9aWrn3o7f7sKXZGZSNnIq5wqX3TjXLUgpij?=
 =?us-ascii?Q?HvWzjxg6TOd4Hh9sLKFrmA8cxduImKRBEc/ugI9dwQXvsREuvwXwOWVqwjTG?=
 =?us-ascii?Q?Q6tnZ3D2A+31V1rZMvlYQ1WwQJpvUzyIZeVY4fi4PUT6IsSYwwkgWcHd54ur?=
 =?us-ascii?Q?rvZKVg0CHG6iX5G+B/IR/VLpxA4as8h8iOGqsfhMlJQ/rNOsX4AH5WHUkoMs?=
 =?us-ascii?Q?aUlefUeZt4CDq8mAIJfLKcT9vLJ4OfafIYREtBphDiu0mvz4FmFw44+Iv3ff?=
 =?us-ascii?Q?SOK1PYc4et1ALmA1d5O7jx7V5g3EAY/zSodf7jEKH7tgjmDoVHC1ugHJVEgm?=
 =?us-ascii?Q?JbeEFXFWjbv2z7i9pGU/0qAt1UP2HNPyHkvnmKUGQOvlSrvq9ujLIxwMCBd4?=
 =?us-ascii?Q?VyvGq6gYNRGzeAUR8ic3o+VEdAgnyBq4FulOf1/my35mCDVgjOlM8pPwmsip?=
 =?us-ascii?Q?5ori8p/0g4L3sx4MHTVx5230/lLiQZZUN6gitfvGPwUVf42HlyY/oUPgW0NW?=
 =?us-ascii?Q?t5AJGXzt+frDUe5BAE5spQqOPTMmvJBeMhzDIfBP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5359.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63756c11-bf76-4efc-fc09-08da8c98ab3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 04:07:36.1893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yocRcC9kIWXw3mgeR9ASViILCkHrZZA6+KGr1Gc47AyCmR+jAm2KTLrVfNYg2C5HgfwNX/n1U4RoT39w74ogytnfNOtOzR/M0zBXZ00Yct0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7112
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of D=
ing, Hui
> Sent: Wednesday, August 17, 2022 4:23 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L <an=
thony.l.nguyen@intel.com>; davem@davemloft.net; edumazet@google.com; kuba@k=
ernel.org; pabeni@redhat.com;  keescook@chromium.org; intel-wired-lan@lists=
.osuosl.org; Gerasymenko, Anatolii <anatolii.gerasymenko@intel.com>
> Cc: netdev@vger.kernel.org; Ding, Hui <dinghui@sangfor.com.cn>; linux-ker=
nel@vger.kernel.org; linux-hardening@vger.kernel.org
> Subject: [Intel-wired-lan] [net v3 1/1] ice: Fix crash by keep old cfg wh=
en update TCs more than queues
>
> There are problems if allocated queues less than Traffic Classes.
>
> Commit a632b2a4c920 ("ice: ethtool: Prohibit improper channel config for =
DCB") already disallow setting less queues than TCs.
>
> Another case is if we first set less queues, and later update more TCs co=
nfig due to LLDP, ice_vsi_cfg_tc() will failed but left dirty num_txq/rxq a=
nd tc_cfg in vsi, that will cause invalid porinter access.
>
> [   95.968089] ice 0000:3b:00.1: More TCs defined than queues/rings alloc=
ated.
> [   95.968092] ice 0000:3b:00.1: Trying to use more Rx queues (8), than w=
ere allocated (1)!
> [   95.968093] ice 0000:3b:00.1: Failed to config TC for VSI index: 0
> [   95.969621] general protection fault: 0000 [#1] SMP NOPTI
> [   95.969705] CPU: 1 PID: 58405 Comm: lldpad Kdump: loaded Tainted: G   =
  U  W  O     --------- -t - 4.18.0 #1
> [   95.969867] Hardware name: O.E.M/BC11SPSCB10, BIOS 8.23 12/30/2021
> [   95.969992] RIP: 0010:devm_kmalloc+0xa/0x60
> [   95.970052] Code: 5c ff ff ff 31 c0 5b 5d 41 5c c3 b8 f4 ff ff ff eb f=
4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 89 d1 <=
8b> 97 60 02 00 00 48 8d 7e 18 48 39 f7 72 3f 55 89 ce 53 48 8b 4c
> [   95.970344] RSP: 0018:ffffc9003f553888 EFLAGS: 00010206
> [   95.970425] RAX: dead000000000200 RBX: ffffea003c425b00 RCX: 000000000=
06080c0
> [   95.970536] RDX: 00000000006080c0 RSI: 0000000000000200 RDI: dead00000=
0000200
> [   95.970648] RBP: dead000000000200 R08: 00000000000463c0 R09: ffff888ff=
a900000
> [   95.970760] R10: 0000000000000000 R11: 0000000000000002 R12: ffff888ff=
6b40100
> [   95.970870] R13: ffff888ff6a55018 R14: 0000000000000000 R15: ffff888ff=
6a55460
> [   95.970981] FS:  00007f51b7d24700(0000) GS:ffff88903ee80000(0000) knlG=
S:0000000000000000
> [   95.971108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   95.971197] CR2: 00007fac5410d710 CR3: 0000000f2c1de002 CR4: 000000000=
07606e0
> [   95.971309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [   95.971419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [   95.971530] PKRU: 55555554
> [   95.971573] Call Trace:
> [   95.971622]  ice_setup_rx_ring+0x39/0x110 [ice]
> [   95.971695]  ice_vsi_setup_rx_rings+0x54/0x90 [ice]
> [   95.971774]  ice_vsi_open+0x25/0x120 [ice]
> [   95.971843]  ice_open_internal+0xb8/0x1f0 [ice]
> [   95.971919]  ice_ena_vsi+0x4f/0xd0 [ice]
> [   95.971987]  ice_dcb_ena_dis_vsi.constprop.5+0x29/0x90 [ice]
> [   95.972082]  ice_pf_dcb_cfg+0x29a/0x380 [ice]
> [   95.972154]  ice_dcbnl_setets+0x174/0x1b0 [ice]
> [   95.972220]  dcbnl_ieee_set+0x89/0x230
> [   95.972279]  ? dcbnl_ieee_del+0x150/0x150
> [   95.972341]  dcb_doit+0x124/0x1b0
> [   95.972392]  rtnetlink_rcv_msg+0x243/0x2f0
> [   95.972457]  ? dcb_doit+0x14d/0x1b0
> [   95.972510]  ? __kmalloc_node_track_caller+0x1d3/0x280
> [   95.972591]  ? rtnl_calcit.isra.31+0x100/0x100
> [   95.972661]  netlink_rcv_skb+0xcf/0xf0
> [   95.972720]  netlink_unicast+0x16d/0x220
> [   95.972781]  netlink_sendmsg+0x2ba/0x3a0
> [   95.975891]  sock_sendmsg+0x4c/0x50
> [   95.979032]  ___sys_sendmsg+0x2e4/0x300
> [   95.982147]  ? kmem_cache_alloc+0x13e/0x190
> [   95.985242]  ? __wake_up_common_lock+0x79/0x90
> [   95.988338]  ? __check_object_size+0xac/0x1b0
> [   95.991440]  ? _copy_to_user+0x22/0x30
> [   95.994539]  ? move_addr_to_user+0xbb/0xd0
> [   95.997619]  ? __sys_sendmsg+0x53/0x80
> [   96.000664]  __sys_sendmsg+0x53/0x80
> [   96.003747]  do_syscall_64+0x5b/0x1d0
> [   96.006862]  entry_SYSCALL_64_after_hwframe+0x65/0xca
>
> Only update num_txq/rxq when passed check, and restore tc_cfg if setup qu=
eue map failed.
>
> Fixes: a632b2a4c920 ("ice: ethtool: Prohibit improper channel config for =
DCB")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Reviewed-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 42 +++++++++++++++---------
>  1 file changed, 26 insertions(+), 16 deletions(-)
>
Tested-by: Arpana Arland < arpanax.arland@intel.com> (A Contingent worker a=
t Intel)
