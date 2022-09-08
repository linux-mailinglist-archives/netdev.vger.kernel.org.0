Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4E35B12D2
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 05:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIHDLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 23:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIHDLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 23:11:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85251A74D1;
        Wed,  7 Sep 2022 20:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662606673; x=1694142673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C3mJK6aThPw2f4TIQHdymRo6UmBfYl6lw4kUxV0DbnU=;
  b=HaCsS3EhLrWdyOe8bkNkBJzUH4P1LwFoizZK/Xuy/4r24qx7FeyQy5O9
   CfejbOwZxwPBO62RXlAbM6JhAO/se3xDk1xRcQQuFGn5b9/QHXgy+sL+9
   MVaCtg+nKceWl04MmWjL4xpYwtIQUtGBni5d23sEG12x8NdZ8yV0+uSOE
   g9CQnIGmTCss1GnGLudAYmpbVHadSmBozRjSBCGpNz6ydGLHG7tIRGhDi
   2XB6GzOuZCQ8dmzRY5Nxob17FxbaN/Bvc5ds9FoB8Ms2WfHnwDI/cwUOf
   x33iPhvvSyddA0E77lItvesC8e0qCrKIaDW005EPR9QCAVIsLQD8oKj6p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="361014791"
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="361014791"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 20:11:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="644890066"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 20:11:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 20:11:12 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 20:11:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 7 Sep 2022 20:11:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 7 Sep 2022 20:11:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHBLiQ9767Oucm04hQmQAPGEeoeSktFCcWnezRpU+M5L6X8bxOj0bbl6rpN2REzKolyse5MLC7XyqiEGZbIV7lADvshdHuVC7wXjPxAbsqIJDBOMNl8dLFOEJf5TfCLsqKk/cb3ArgYzPMJRxqjmKf/UUxplMTokZwr3mgFvaF2PqHayRISszu90Ocr3Mul7vNkOeLHxs2EH4SMg/mvfcvasOdgomv5iaNqfB1vgKztMULYD3iNgZ/6vbp1pRo6K1XBCPt3HbvVITVzclAyYexz8QSiNjr6/L0kFopQcQ8SLqjKcxGnQUQaqTF5tDXdQ/ECEAPtGyIEfY0KZp0UO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndCWrQ9K9znbAQ698wj8i5KXmsyHSHF63SLPCJULkPM=;
 b=Cz8M97Qh1Sygd7WpigOnVsUsnibljQLhcowOuCZNye8SBHRilmPM73JOqRCMQ++YiMckCBXXZqIQH+yg0eDWuot0Oh1oYYM7CNxcH3QjIl5Klbr40PQ5BqlI6Nv2m+L/LO62Te5g4JrnWCNVaeTDr9Jrbd0dkn9DxHkJ7AUSEI50/6ySnGfNcDBMG7qwA8lAQBo7mMIPWrvUnJJoCxa/C3upSAJ22c2SptwFOXUmu56a9RkxSKA60ipd03TKSNPhILGFa6Uejuvu+9x1g070x4Cn99k1H3o5wPDYne1D56aHYX0K/zinU8Vl0ljYTYahsOwalW/TxfQpIen7mukYfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21)
 by BYAPR11MB3078.namprd11.prod.outlook.com (2603:10b6:a03:87::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 03:10:51 +0000
Received: from CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539]) by CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539%6]) with mapi id 15.20.5588.012; Thu, 8 Sep 2022
 03:10:51 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     Ido Schimmel <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "andrii@kernel.org" <andrii@kernel.org>,
        "mykolal@fb.com" <mykolal@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Thread-Topic: test ./tools/testing/selftests/bpf/test_offload.py failed
Thread-Index: AQHYwnlSjM265E4AkkyO/WHWFY8XLa3ThXiAgAAjUx6AAHpSgIAAuFli
Date:   Thu, 8 Sep 2022 03:10:51 +0000
Message-ID: <CY4PR11MB132098D8E47E38FD945E6398C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
 <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxjB7RZvVrKxJ4ec@shredder>
In-Reply-To: <YxjB7RZvVrKxJ4ec@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29db33c6-1aaa-432e-06c3-08da9147bc55
x-ms-traffictypediagnostic: BYAPR11MB3078:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jb8m6gsPWCzACMkmCFkRpaV0kn03wjIuSMH/WBUM9PupIruPZmro2q+1q8iqTCAx7pm3HyqoSV63JZOdWX+ezpuLYG81yK6qVVm4pqg9zK9kmLdzRTCkB+R1eX33A6CllxivzpWhLSv71zLG+kA0pbJceYLn8E/ieIlmCqweA0BtkSXCY5qmBzEn2QoW1kHHYkdOK3m9b6CPcWaAwn1kIWVjjv8YwbEYNbDF/xC5TH9UeGKJ14OEsZfaOwKHEsXdasFkUMW+g29e7kPhCP4oByLW1lnnY7kELj/TrCDyCh9lciBkjOsqWHEaL+e5d8R5h/kn3D4o/x/WVVgBRM42U9mJmCnA2xYW09xJxDSue7cCHKgeG2aR+zYlerDyo6rfWF7qVGdBEEYCXXUXDVdvZ+8K46XVDz+W/ZeUas1IdFGK33E/KtkXPFYeUl4R7n5cdowlGGyix6y4TdWbRNiXVOLbEpduy/9+dX9pmFAh2NbaxxrYFh+fxnvzUR8w1qsybCIkgExx9FbsjZMYuw9lUK1Bihpw8OqkXSJu7KmEHle+AsZHU9aruI+GKyQ4FUXPteUI61b+GXuuOeN+v1UUxglRX86tCLlR4azYEHKIn4dz+mjjXSHWeo3WobdsXkAbuRZ2VXDmW5aXPD8v+gXWRZrkBDEUq/gNUJxFi1V+BunTOED/n575PWSUniCwRoq/mzpAKdoGfIfax1sd5d7SuZeBYUUdEUnzroW0GPrxwZuagPTIaoigIjB/jxbgAOYxDqBhLXPPDKU19NnfJJGf2WH/DUWoRUEj6T4yOqiwE+w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(136003)(39860400002)(366004)(5660300002)(41300700001)(33656002)(7416002)(26005)(9686003)(53546011)(2906002)(52536014)(86362001)(6506007)(7696005)(55016003)(38100700002)(82960400001)(8936002)(122000001)(38070700005)(66946007)(64756008)(66476007)(83380400001)(186003)(8676002)(4326008)(54906003)(478600001)(110136005)(66446008)(91956017)(76116006)(71200400001)(66556008)(316002)(579124003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k389zG9LEX+FuM287J/MwyOvF+ocoryxanKGXst8c8DhfgvJ4WBmqRIpNj/H?=
 =?us-ascii?Q?PrGNVGHWQy+Qjgdlms32iK+lW9Y++UceLB8+OAQfOworlYU5tBcLunXOUF7d?=
 =?us-ascii?Q?Y3t71vbdcwb6BpWZp7yFRl6z4MPBpxtHihTA3FY0U9kY1VgrLxAXZQqD1252?=
 =?us-ascii?Q?VjVxeDXt8t5S+v3DS6XeaY/CmK/AvsfpSfE2BgOPJBfqSmRCUwyvTOfJTZVH?=
 =?us-ascii?Q?JomrdU3ySaAq0P1cG8s2ilEk/szsNhr/5GkgdO5NwGbVusvqoIE5iwJmqPpO?=
 =?us-ascii?Q?bqQRguSGORECxF9Zb2+Q2DaHGCGTapru5ESJvxQzbzY/71nGVTbgSzoe5Jh9?=
 =?us-ascii?Q?9vRDP4fyUCptBu5t7gY4/qvyT7dEp02knRS364nOjP++p+XI4DlbZnORMJAL?=
 =?us-ascii?Q?gme4VYPX4Ft+FN8n9z9RMVkc9w0PIzYGrxsQkAxG2VFlAdGD0/TQ0N9DgGl8?=
 =?us-ascii?Q?NVCYXStZSM/8246fj8BI/0e2p2tqJNGxq0I17XtVS0cJj14IfSVC77TJQs45?=
 =?us-ascii?Q?q7IDqaRhnWal7BwPWI5lQORee8yGDVsmKzvG3RH4T3CNm2NDm98W2pQ5jKno?=
 =?us-ascii?Q?6RoP7KdRIiCu6ZoXL+4lS7fPcVIVqxf+4hVyA8ZVsAlpiToCcl84HtS/DhFC?=
 =?us-ascii?Q?CjG3g5P+6jMZs0Y+ImNZXBFGAEfiegyGHnq+iO3QTyfP09oJWgLxHSNckS8v?=
 =?us-ascii?Q?y0k2NoXKU3P2um9Kg7STPKRTwsOZx3NqBEhD7xMJCg34HyRDODIo0aq9LvjR?=
 =?us-ascii?Q?/TsEHdBewA/yh4QQU7l+uCoohMRowFU6EEmCUYi2/7eCYlKGUCUd9jKh2/qF?=
 =?us-ascii?Q?a0VmTs9CfJA2GxfN7TCoMPdprkjUXOLuYLRqJUpD3E8aJlhPrZPPBGvlp1su?=
 =?us-ascii?Q?vUr3mkWcJL8I5pmcgPZkGwOx6edkQpiirhbIuybIh57mVuWmGPuL1z1+gMRS?=
 =?us-ascii?Q?px+0zWyGtGkQtB8rtBosUaORI1LJRNNoxhsPy/6t9yoWUuW5vIc++3s6tT5+?=
 =?us-ascii?Q?ZFBKWQbcN2FGJYlJkXBQ02phP/6y4hAzdo6mmkKHYmLRaCiEZ3C4heFjDM8H?=
 =?us-ascii?Q?xn3otBz4oJHA9jSBl6M01+eYlgE6oHrdk9WhyLq2PIrWXQgpRPEv02fTyfkN?=
 =?us-ascii?Q?SXcmOqaTq8BEioVz5LE6EuCABnGcrwPb5JRB8q3l50uZr4LuQLJ1Cu9SpPal?=
 =?us-ascii?Q?23dZog7aQuhnFBMaqa05V9LsbvXOj/nPooUzpYPyZG5Ua/sfb9gX8iBigJ2G?=
 =?us-ascii?Q?hdb4QwqaMhH/rfIrdkzuzVgoRpzizW99KXdKoPGTixFt8sqY6cDDJUkofIwQ?=
 =?us-ascii?Q?c2FLl9yN1sBtJgopMQEtW56jX6psVrtE6InakM7P4QTeU1t9IwCnsEMXJxwj?=
 =?us-ascii?Q?Yr/+F9nVtSUlk0sjTPJYGOdOk7u4yIaH2W06AcNDY1pSbyV5D7sm87CkHSTk?=
 =?us-ascii?Q?t4U11RKuu46pUc/fSv0AAgqbPBi57cP//MOBH5UZ4eiY5DIuzbbLZV5E5a+Y?=
 =?us-ascii?Q?wTUZVEm2cM1chHQqAAtlAD+kh2fICXG0X5Lyf2hZAhlMw3ag9YSxGcKSu+rf?=
 =?us-ascii?Q?PNIb3UnMk4T8M3NHikgyEEG5X8OJXPbAP+44YPrE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29db33c6-1aaa-432e-06c3-08da9147bc55
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 03:10:51.4272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 01HeS56jIM/MYhv8pI8XOGKHCUyCQO5q4TsDYCKRLu/Wf3I49FzQ1bTAg5ccatQRXz7xlkAIfNM5eVvb7DrIgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3078
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

hi ido,

My error is  "Exception: Command failed: cat /sys/kernel/debug/netdevsim/ne=
tdevsim0//ports/0/dev/hwstats/l3/disable_ifindex"

Do you get [1]error, after patch [2]?

[1]
# bpftool prog load /home/idosch/code/linux/tools/testing/selftests/bpf/sam=
ple_ret0.o /sys/fs/bpf/nooffload type xdp
Error: object file doesn't contain any bpf program
Warning: bpftool is now running in libbpf strict mode and has more stringen=
t requirements about BPF programs.
If it used to work for this object file but now doesn't, see --legacy optio=
n for more details.

[2]
diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstat=
s.c
index 605a38e16db0..0e58aa7f0374 100644
--- a/drivers/net/netdevsim/hwstats.c
+++ b/drivers/net/netdevsim/hwstats.c
@@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
                goto err_remove_hwstats_recursive;
        }

-       debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwsta=
ts,
+       debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hwsta=
ts,
                            &nsim_dev_hwstats_l3_enable_fops.fops);
-       debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwst=
ats,
+       debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hwst=
ats,
                            &nsim_dev_hwstats_l3_disable_fops.fops);
-       debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hws=
tats,
+       debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, hws=
tats,
                            &nsim_dev_hwstats_l3_fail_fops.fops);

        INIT_DELAYED_WORK(&hwstats->traffic_dw,

best regards,

________________________________________
From: Ido Schimmel <idosch@idosch.org>
Sent: Thursday, September 8, 2022 12:08 AM
To: Zhou, Jie2X; kuba@kernel.org
Cc: andrii@kernel.org; mykolal@fb.com; ast@kernel.org; daniel@iogearbox.net=
; martin.lau@linux.dev; davem@davemloft.net; kuba@kernel.org; hawk@kernel.o=
rg; netdev@vger.kernel.org; bpf@vger.kernel.org; linux-kselftest@vger.kerne=
l.org; linux-kernel@vger.kernel.org; Li, Philip; petrm@nvidia.com
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed

On Wed, Sep 07, 2022 at 08:51:56AM +0000, Zhou, Jie2X wrote:
> What is the output of test_offload.py?

This output [1], but requires this [2] additional fix on top of the one
I already posted for netdevsim. Hopefully someone more familiar with
this test can comment if this is the right fix or not.

Without it, bpftool refuses to load the program [3].

[1]
# ./test_offload.py
Test destruction of generic XDP...
Test TC non-offloaded...
Test TC non-offloaded isn't getting bound...
Test TC offloads are off by default...
[...]
test_offload.py: OK
# echo $?
0

[2]
diff --git a/tools/testing/selftests/bpf/progs/sample_map_ret0.c b/tools/te=
sting/selftests/bpf/progs/sample_map_ret0.c
index 495990d355ef..91417aae6194 100644
--- a/tools/testing/selftests/bpf/progs/sample_map_ret0.c
+++ b/tools/testing/selftests/bpf/progs/sample_map_ret0.c
@@ -17,7 +17,8 @@ struct {
 } array SEC(".maps");

 /* Sample program which should always load for testing control paths. */
-SEC(".text") int func()
+SEC("xdp")
+int func()
 {
        __u64 key64 =3D 0;
        __u32 key =3D 0;
diff --git a/tools/testing/selftests/bpf/progs/sample_ret0.c b/tools/testin=
g/selftests/bpf/progs/sample_ret0.c
index fec99750d6ea..f51c63dd6f20 100644
--- a/tools/testing/selftests/bpf/progs/sample_ret0.c
+++ b/tools/testing/selftests/bpf/progs/sample_ret0.c
@@ -1,6 +1,9 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause) */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>

 /* Sample program which should always load for testing control paths. */
+SEC("xdp")
 int func()
 {
        return 0;
diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/se=
lftests/bpf/test_offload.py
index 6cd6ef9fc20b..0381f48f45a6 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -235,7 +235,7 @@ def tc(args, JSON=3DTrue, ns=3D"", fail=3DTrue, include=
_stderr=3DFalse):
 def ethtool(dev, opt, args, fail=3DTrue):
     return cmd("ethtool %s %s %s" % (opt, dev["ifname"], args), fail=3Dfai=
l)

-def bpf_obj(name, sec=3D".text", path=3Dbpf_test_dir,):
+def bpf_obj(name, sec=3D"xdp", path=3Dbpf_test_dir,):
     return "obj %s sec %s" % (os.path.join(path, name), sec)

 def bpf_pinned(name):

[3]
# bpftool prog load /home/idosch/code/linux/tools/testing/selftests/bpf/sam=
ple_ret0.o /sys/fs/bpf/nooffload type xdp
Error: object file doesn't contain any bpf program
Warning: bpftool is now running in libbpf strict mode and has more stringen=
t requirements about BPF programs.
If it used to work for this object file but now doesn't, see --legacy optio=
n for more details.
