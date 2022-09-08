Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BD65B15E0
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiIHHo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiIHHo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:44:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9EBE67;
        Thu,  8 Sep 2022 00:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662623065; x=1694159065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tVe3MYTlq8BGmSFgNllxI5Y4fqIs+KXmapZPvXEVmHk=;
  b=WBQrcimxT1T8dJ4WlddigyqMM2c1wLrbO5GjShpss4G7rSxk7SjqBj2U
   zosRsTd/Zt9xxH7p3g0AAigvycLWq86c3dEp5xBLxfCC9fPAH7G3alSU2
   iuFNCZ5qSRANEuYAl930fXanXysvOz1r9b3Eb+I6EEAZ12qYVXCm2RJap
   sZ+9KrwwCSbHl6oJAZ7I/GqEo0ILjOU47YF3/YTKO1bzvBZ9cCvx9kCbg
   f/bLC34HK3iUhUl3QZZbLNvHx0SB9NccftkOKclKsWQ4LEWg+8vVqSVwY
   6nXL0wyNIrhg1//qNxggluz74WE61VlKdGaeB55YjyejdsPFQBichL/+u
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="323290851"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="323290851"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:44:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="614794680"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 08 Sep 2022 00:44:24 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 00:44:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 00:44:23 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 00:44:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S67sZMf4BF5S7rGnDUCttorTSzkd8ppvm/sc8nYIYFf6UGZwq4jJJYaPdslaXOqIxIDPgrJts1PLZ6T8Yj53Q7C+TJuJPbbEOIwNiVZeTnqpV9OikzLnz+gNahAEc6HI54Au83gEGpICeS0A9OBjGl+MUagzwXrGTQcOn/YDWFarINaRuUAaYGluKgewkFA8KBYMu0Dpz1joERYkuD1R4BHmwD/7emj44eVeemnYXDubVIgouyG0Jptb/c3HZFkws9c/ncjyQrvD3r766t8/dVnkOgRxOBrzDdvG8brIV8MkyqkLk9J/pUh6yt1PlSe9aQgKrPYaficU2boU7mlg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfW+lfi2JPWuM7sj7b5vi1oqaMj16CM2mpYz/9XBFS4=;
 b=GSiKSKghjiBtLX0/gO6h3rpTTbl8gYAVN/+UIjmtZvwjDZIzgnXLiXP9099lFbV4fj5+yeOD5zofDuBBVAVqNcSBa17yz0oG/jXtnOXZpA05X95Tv4T0REylLQx8gC1bJTGe6wys5YLXNFYk3TCE3v9ptzqD2n9ZzmSLrcE0UignwGib2xxIP5YkBLU84WwpxoqpyK4SrIRjNJA1bvh6DVPlm6YMzKap+2WVMNK9GUDgldyJHhoMHjkc2eNAuqVzNwAxWKZJUrQKjHJZzuH9njD0jRkN5+qEeiDwFYOVImYra6eEi0y36lILPx9+rnLl/zSfuPdwiIVodFhs2fOY7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21)
 by MN2PR11MB4256.namprd11.prod.outlook.com (2603:10b6:208:17b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 07:44:06 +0000
Received: from CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539]) by CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539%6]) with mapi id 15.20.5588.012; Thu, 8 Sep 2022
 07:44:06 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
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
Thread-Index: AQHYwnlSjM265E4AkkyO/WHWFY8XLa3ThXiAgAAjUx6AAHpSgIAAuFligAA2swCAABSnxw==
Date:   Thu, 8 Sep 2022 07:44:06 +0000
Message-ID: <CY4PR11MB1320BB40A48D230A1A196318C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
 <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxjB7RZvVrKxJ4ec@shredder>
 <CY4PR11MB132098D8E47E38FD945E6398C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxmKdBVkNCPF4Kob@shredder>
In-Reply-To: <YxmKdBVkNCPF4Kob@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e556d16-c47e-4393-fd00-08da916de852
x-ms-traffictypediagnostic: MN2PR11MB4256:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XJOsBzWraul10qvzo8qyz499XUjzy2HBoF8ktCKKwwBtfN2EruBXKOB/zVZtAtbBbC00Y8PKAKj1Vhp875wnGE4y2NZK5EI+BRzOqjtaF9B+eA5p2OnrsqoxzODzD6OfPm81WeLcldqlaMnF0CPDsavITY4jaabZLDgsJUU6yStJ4d0DUn+MjohUkkV4xLRyJvZBnFVPc/IeZKFg0J7jO3CqynF8zR/RFiW+F3fIUrAHQU6AQ2pZvsZoQiHVwq5DG1lAfzNePlQ6A2TTSQz+yJi3z1z7JWTQT4DvZZFo0a6dqAVsfKrVqc1ULx/FbIDf9wiX4eY7Snvnf7RX0rkCdoM5PHb4XLrTBNW2+6kzcxG7n7K6jEv+dyfgbfLJ8vHfXPNOjk6yUkdkzat1/NOfNmT/kBFTIQ/zibuLGjgfpfsNUtSHjIlKqf56dCC+Aq3XqcdCa47VHjQaNLcxKZbARXcknwc39AAeGFQ9cCrF+3C0O0cwviu/dj55yZIgcPMFwC+90+Sn364/a4ZWNvD/QhPkB9CzqXbnDC3zeXNHL9mQJNfcOKQjYvVwc6tiOxkDVGeFaXxGrVAnDFe/rnIs1Y9bBLS/6peOqC5sUM6kljbRo/VQuvUqMdI+3E/W7XVBVdQfuz1ktbJJHU8obTtoi3kfP8mnJIW+AmAZdI51chxNseMzTvA5ZOHlqKtSM2yFBcYRYK1m859/N69u8rsVvcsCefvPAaBQNCh/lS/+Ot+NoqGkU6jw8DZl9oQJfpoIkMUsncqvxItWUFRncyDDyxEf0otwn9zLbCJb7EY+SlM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(41300700001)(6916009)(55016003)(71200400001)(316002)(2906002)(38100700002)(38070700005)(82960400001)(83380400001)(9686003)(26005)(122000001)(54906003)(186003)(66946007)(66556008)(66476007)(76116006)(8676002)(4326008)(53546011)(64756008)(66446008)(478600001)(91956017)(6506007)(86362001)(33656002)(5660300002)(7416002)(7696005)(8936002)(52536014)(579124003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HeEtBKOraM3r1CzjYxG9yuRPsABtDmA9/VGMZ4diK4XoNWbuLjUvCxEPDF95?=
 =?us-ascii?Q?GX5GJ496UTShbXE+y52CS2neGgJzQRlMrV845Wc68bjGSEmgz65O8prOG6BL?=
 =?us-ascii?Q?N0HTufzP1xd70p99s71Dv2aZIrkmJFZ9yHhLCe5fIri0MJk71vudvB9tjZIO?=
 =?us-ascii?Q?DrPHjssRUUJLzVGD9ASICF1vVFoKWmGlSTo24j4LWy100iKwOgNOXcY5Tqd8?=
 =?us-ascii?Q?zWFLqdzY6Moq/TOUx3hJXeypG7gC7JDmaEn8tcSeJzolZa0OOjHngZ4RAFbn?=
 =?us-ascii?Q?oAqVn1at3foCevJP7CGAynwuK0elrljs4kjOgSl11Doy6KtYtAuxnzheu7uK?=
 =?us-ascii?Q?wcS0XOnku5/u2pFptrC25XHdCMwi3fok/BQnQvjspKvNe0ZCtckeMbJK2Cjj?=
 =?us-ascii?Q?NROCTaT+7wnsTnPPkaDuCrJ2a7+wLjHSwTUWHgLDaEUfEAJ9QYToJehAKVgX?=
 =?us-ascii?Q?+M3X4vMwXiony7Q+mVEgWyYJmTF3IhEgDiCEnbSUW3lJGLZeJSvp62HckNr6?=
 =?us-ascii?Q?Du19MTRbXoMcJ3SJxTh6wevqlclccGB5bgExK573gB0Nc4buv7rFaboywzWt?=
 =?us-ascii?Q?mtmcrlU9AmezZCXrpPUKKzRnvAPYvEX8QzmLlZANR8DGJdgumdidFMlfwifM?=
 =?us-ascii?Q?iogOnlEJwwlXEcjtbTP8EfDigF1fgwZ3yi0ZBnBWYHeTc+LOMKdDZFQQdpUk?=
 =?us-ascii?Q?q0U9gTpthVbM4pHvNwf5Rk2HITs+y1to6jrujVA8urUTR2DSTXbmcvF1okiB?=
 =?us-ascii?Q?L1rBRgfKLzxuaHQAIXVAyByftsqI3lrv5mAcVLrTRCVDc6F5FIk/nWQdzxs9?=
 =?us-ascii?Q?MUSv1qO8AebsZRH+kCZFhIEstG4iHo0Ugup1KgnHrkVTySVf8ePIWeGSHxQL?=
 =?us-ascii?Q?PbHb/rBZJ6Gcmm+sSS6YhiH91l2TVWan12e4HyG2eShg7+9NIiZVDMJakKn3?=
 =?us-ascii?Q?AFbSNF+TJA0eMdCgI+iEGqr3lMgqNm4Y9CDSVg+Wl4ZuiarFS+M9R3zo8MZ4?=
 =?us-ascii?Q?Bap+EorTcuX+hwEDSIHCSjfiKqnZyUNQ4GI24na3O7V93YQMjfHDJYghPOG/?=
 =?us-ascii?Q?qKvtP1NDSed4nfCYe8kxQBwTGFiJvIxJVkdhhhegjYFxo8LYxrpRRF8KdrcF?=
 =?us-ascii?Q?RPkR7+/XpDrECCKck9dBPRmCZnh4Y7NnnXCJ+Z1j0DDApIH0fg+1iJf6o91V?=
 =?us-ascii?Q?zpxPL/90tZBrKc3pZ28cDnxZHAQINzXDSzTJBsLno4DyEu5u6ynGiGRfghgm?=
 =?us-ascii?Q?1OBBMjFUoMRzIb1zkIF+nJL202aFVwAOCKQKF8Gn9/MF19wgQNvIdh9vitW6?=
 =?us-ascii?Q?v/AjFo1ePvlXrVgFBR0uSIzEfDEamgJ5iAzRXr9P8PyuBL+neKfktJ7fXD5a?=
 =?us-ascii?Q?xWGPlL2InOUDcyJ7OP1UjmW65lHqW02hsRH/iIpP1Yf+fDH+ELrYfY6aDh37?=
 =?us-ascii?Q?AN79w7KhxFdWDsDI6jlV+kZjzmFk5Si2qThVic7zKbHjW312XIobBPPE52oj?=
 =?us-ascii?Q?7gBwTRPFGQNonaGP4+DSkyT2yo+XOu2yp7R+psWuU7RAftnYl2WgBZQm7/YC?=
 =?us-ascii?Q?GqXHKt5sYQ91fzD4P5JwgxfgkbvQguNR1qiWWoIV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e556d16-c47e-4393-fd00-08da916de852
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 07:44:06.1249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0P6D6oSnTdpS5jNUxO30oLXT2Kcgy937YRBEn9u5n+f90yPw2DaZgRd4XKIesvsDnUV8j3GGZJvAz9Mlm2q/BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi ido,

>> My error is  "Exception: Command failed: cat /sys/kernel/debug/netdevsim=
/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex"
>This one is solved by the netdevsim patch ([2]).
Thanks for your reply.
About netdevsim patch ([2]), do you commit it to kernel mail list?

best regards,

________________________________________
From: Ido Schimmel <idosch@idosch.org>
Sent: Thursday, September 8, 2022 2:23 PM
To: Zhou, Jie2X
Cc: kuba@kernel.org; andrii@kernel.org; mykolal@fb.com; ast@kernel.org; dan=
iel@iogearbox.net; martin.lau@linux.dev; davem@davemloft.net; hawk@kernel.o=
rg; netdev@vger.kernel.org; bpf@vger.kernel.org; linux-kselftest@vger.kerne=
l.org; linux-kernel@vger.kernel.org; Li, Philip; petrm@nvidia.com
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed

On Thu, Sep 08, 2022 at 03:10:51AM +0000, Zhou, Jie2X wrote:
> My error is  "Exception: Command failed: cat /sys/kernel/debug/netdevsim/=
netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex"

This one is solved by the netdevsim patch ([2]).

> Do you get [1]error, after patch [2]?

Yes. Maybe you do not see it because you have an older bpftool without
"libbpf_strict" feature:

$ bpftool --version
bpftool v6.8.0
using libbpf v0.8
features: libbfd, libbpf_strict, skeletons

> [1]
> # bpftool prog load /home/idosch/code/linux/tools/testing/selftests/bpf/s=
ample_ret0.o /sys/fs/bpf/nooffload type xdp
> Error: object file doesn't contain any bpf program
> Warning: bpftool is now running in libbpf strict mode and has more string=
ent requirements about BPF programs.
> If it used to work for this object file but now doesn't, see --legacy opt=
ion for more details.
>
> [2]
> diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwst=
ats.c
> index 605a38e16db0..0e58aa7f0374 100644
> --- a/drivers/net/netdevsim/hwstats.c
> +++ b/drivers/net/netdevsim/hwstats.c
> @@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev=
)
>                 goto err_remove_hwstats_recursive;
>         }
>
> -       debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hws=
tats,
> +       debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hws=
tats,
>                             &nsim_dev_hwstats_l3_enable_fops.fops);
> -       debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hw=
stats,
> +       debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hw=
stats,
>                             &nsim_dev_hwstats_l3_disable_fops.fops);
> -       debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, h=
wstats,
> +       debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, h=
wstats,
>                             &nsim_dev_hwstats_l3_fail_fops.fops);
>
>         INIT_DELAYED_WORK(&hwstats->traffic_dw,
