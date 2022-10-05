Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5935F550F
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 15:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJENLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 09:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJENLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 09:11:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1A2233A8;
        Wed,  5 Oct 2022 06:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664975467; x=1696511467;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=hTd1O6IbTPfORd7+Me11klWtmrpW7aSqBc3X11ezxRw=;
  b=hb2vGaWljBU98qvoepRiForsPKVO4O65FVmV/oJ7ufvnMOnSs/5JYqq7
   2azM2J79GOo87f1PGQ3srBFAcVYTzwvEVf2uIENb4TYZPsBMmI6DofjyA
   qfQt1TDjvbkp/so8FWXVWzGI3EVGWJquBa/mhsQlYyrvi3f4fYHasnpYx
   1UUquTAcJfAl7L3MQ1fh7bOw5TiCOAz09aw1Gg4L8MDQqb9t6W+uc2TRO
   5kQKe9hZ6BEprgtFuvIcbUn+bDqFN9ILYUEnJN1g3HhKBTSzW0tIZO0+I
   olY73rNFLuBMIflBryV7krqHptb1NA6PqDPGMqy+B5JP66rZIUdvU0xKc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="367268016"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="xz'?yaml'?scan'208";a="367268016"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 06:11:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="655161241"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="xz'?yaml'?scan'208";a="655161241"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 05 Oct 2022 06:11:01 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 06:11:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 06:11:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 06:11:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 06:10:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0SJrvsrJgTf+4zJQsDJcRvy7k2Hai7TYn9bNxPykRVbwW4Qw03o5piaBVrrO+5uWTwd0RDNDjwXt7fsGXRwsJ9z9/Q4sa/81FBTHdW+6gReNrGxotVUQ2s453LUIedVEaObgPKvZM3bhNG5zkhjfcglUeN1fTytti04l3kWbe27tkBfGohFwgiX6S+uhSQgG+l+fsZwxXA4auI21iWml3dn/KqBXVvFOwMppVwJ3vtv4OJBlseipp8OStzVtIx1EO4i1e9iQ5cwK6MYJZ7MyNadyQyeGQTK2gLShnrsVPJXmIYq3E44ws3cH56/2B5k2oPVrgFhjwkBO+NQDaDGfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZPPR7Q1GvSHfWgEuxsHGrWivX6uBNC+kFodaI998a4=;
 b=XuzELm9CbBE1oBwQpwURwkQDUAZ2JAd80z9R49Wh1+dvG4XK3FZDCeY7u7qe3LhzRZJTOjO6EXRKe5AD65OWNobyaPj+f11VrA/vrWF6A/hE7mJ/Dg6TamN8w6mDlMlL3tB3Rjx/lDukLQUCj4xZYbw2ZAXrteRpib1OUmsO3v3iLNbTRFekNKHTvdSlpAFlRuSJhlg+ShXQTnwT8YdWloWM7nRXIL9CV3qXFQAUNPgKTtYo7zoqNgPsnadmA/yrouXl/yJkZ31gUhaaUi5Tp0TiyHNGyxVKix/cNRnEfMJwQVzLolwiUBAUq5BhVDQ7p+Kt0pN3ydpK9FLWpZ4Akw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH8PR11MB7093.namprd11.prod.outlook.com (2603:10b6:510:217::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Wed, 5 Oct
 2022 13:10:56 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e1c4:1741:2788:37d0]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e1c4:1741:2788:37d0%3]) with mapi id 15.20.5676.030; Wed, 5 Oct 2022
 13:10:56 +0000
Date:   Wed, 5 Oct 2022 21:10:46 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     <lkp@lists.01.org>, <lkp@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David Laight" <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: [proc]  5336f1902b: BUG:KASAN:global-out-of-bounds_in_memchr
Message-ID: <202210052104.561159b8-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="uOTRYISOpz+FLY8y"
Content-Disposition: inline
In-Reply-To: <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR01CA0114.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::18) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH8PR11MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: f453d740-c450-4da7-65e5-08daa6d309c3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8IiyTRRt6pg4oWnd5awMUZ967sWsX8DymbVbuHNOJhADkm57ygO//prSpmSXxysfiRBTX1dzOGdmR41HBkuUujWkIUbaf9tlQaZC+K6KW+cTmjwZZaMmsWEuSo682lnnZywMYoRUu4RowUBA+zuF1HsXUF+tIPs6DqK+oSVvV3K9wxGUh1+QPUxhy6D/eM/Ih/X4SwZB0ozwaZrdZ28EwZb6ZIfe4BdnW8Iar2dfg+R2Jv0fubFJPYEpnR8QP8m3fss/UDt6xAbiXjdpE0hWGGWfvDnH20i7ah+qxg/R8gYl8Dtow49QvHlsl9DW6npJWauMmGNcfRTh0yL9LlCJhliMeAjuBHKXjQxRIr9oTReTH2kRS3Ip9wl2E7838BFa5RZEG2OZhuLEdCk3nDz5jO7DDAxt9Z6zUa7gV+Hx6ziHuScLCybQa3t/Mj2MBLHsrxbP1rI+Dcq5W7zZ6hN+QcDacXkientpg4KLBtQ3XoZKrfRN2FAgZyYKszo/sCAFo+pPpXHrW4BbnrQwktNIq/6AdSn4Q+bmSKVRaWTnAEQzE0dP0UaknPXH2Ix/7t0JoNqcekREVb6oVNIUs65NwVdcYFNhlMi/wfYzjq6hixcINxtxX4Ry1XPFSJhl4x8EKDtBPb5VMK44SAS0MKOzDOd/maweDNq4OBPbAWUh/X2Qg1dtOxyV+iWVdY148AiEc1yVTjANNjYqn9Y5yozJmRPITh+vRiI2giPhZW+C5AHaK58OyCTKS8TbEE9+CKWbPAF4AHA0qvp7hu3OY/HvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199015)(66556008)(4326008)(66946007)(66476007)(8676002)(8936002)(36756003)(186003)(41300700001)(6512007)(86362001)(2906002)(6916009)(54906003)(26005)(316002)(2616005)(1076003)(82960400001)(966005)(6486002)(6666004)(44144004)(478600001)(83380400001)(38100700002)(6506007)(21490400003)(235185007)(30864003)(5660300002)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8cZaRJluWfmVCVH3AdCJXzUAivZxKWlLEXEja8ppvx779pzk+J1v/aK0fEc0?=
 =?us-ascii?Q?z/+QXFm6UyqU7Mw2ACjCz8kqWTFWBwzyx2jkDyC7Z6lVNQmVl/eV3paXsQKl?=
 =?us-ascii?Q?gcnX1QBUygwQi5ojJVY8fh+jx+pMA7zovD58UADEsxVScUyHylZlvRU04lsR?=
 =?us-ascii?Q?W08Nkv/sWSLSjlpT3YSSXovZ/8y7QorVHHIwrn3fwFji2vEMAt6gLuOeaD1u?=
 =?us-ascii?Q?10VLlxghQ9VhhodKkFw7IOJSrbsIfAcyZnreB3PP0wX+gRYHlrFjXMcjF+PK?=
 =?us-ascii?Q?CThK0posZZDiP0m8Km1xVBP5I3FHkaw2QT8+TKE4wTSnqVdwBMK7f85zQ4Z5?=
 =?us-ascii?Q?OtF/RwAjat2H974MtBpE/OOHAWw9+nSRaWvVCthnLXzcDlDgm/43EyeGkPsf?=
 =?us-ascii?Q?J5HwuWYIgaU6dvgPA4+egHV0r+Xn3HEVnPs6iLYQlrH31htxug5Zht7QnuWn?=
 =?us-ascii?Q?WJrEcA4owcmAPM0DzlQQTfC9ZyZPZTjyN1JKEhSUoWr1n9d8YxjHluJLjYyl?=
 =?us-ascii?Q?41gMGwC93Wvc36zzJ9hkgXeewOUynxD1QHU04x7vu10kngFIKH4Wdfz7mNke?=
 =?us-ascii?Q?WFJwctpdUwHjOvhK4r4fdBufn0X+k9am+TJ70IS5xzUJTNowo6X0kJVXh593?=
 =?us-ascii?Q?pyVLDFBRBY0gQ6UQNs/7UJB45WD0PefvSbW3TphrRwK4VOKJwxd/YyM6EJMe?=
 =?us-ascii?Q?rIs/86Y6ugZmykdBuZ0J+stnB8QjSV3CboRzuL8qgNUeuzwQcx4k48+d5JSl?=
 =?us-ascii?Q?/nl3SIGTNfxiTlTWQpGGI9TbHuZaUkuFSQjHa7/mQSi/1Wvj+eSozaWDUizQ?=
 =?us-ascii?Q?41N0XOWIaxRz21WYkXZFDMmSr+6cP9j0QuLUiLltW8Ic3lxB8CwFLyE5Xa4m?=
 =?us-ascii?Q?PgDVddaDI+gJF3anaDUiF8nJn/Ce6JqZxg08UGRu/RPx3Qas5KQn4KX5NWhJ?=
 =?us-ascii?Q?nTriGe39mYu/fJ4J8lOET8nGnh3gXCtP5vvY6U1MS5UIF/eWbxUYFMrYlY4F?=
 =?us-ascii?Q?urOQ0M3O4B85F9YRUu4j+fD9Xi4RLoIz1AlYgKFXfh9VEXaaVj7RshpfOmZD?=
 =?us-ascii?Q?Uhb4WlLv/7XSupjGedve6USqrNr/e4XG9+RePG11ZM0i3M+2OuQmgkqsDB90?=
 =?us-ascii?Q?IEkEjZ9p5r0zGq/IqcpIeCahE62Do0xVRtIEkN9ux+3PCKMGc2usA1hdU8Ta?=
 =?us-ascii?Q?ZjtJ9K3g94EgWzVMN6sjpQIwd6yq90H93YZCwkF9q6w3h/8ahdP220MBS7HZ?=
 =?us-ascii?Q?VMwu0w9ZxbtqbzvM84qZ4A0v0PDfqqp0MoHoPrNW19VnldKB/BMSnyeFmTxZ?=
 =?us-ascii?Q?r1qvyHbJR0iAuqPWwEfaRbSbSv6sb94C8n9g4rKzwoWvrn9MvarbtOR73pBT?=
 =?us-ascii?Q?IKHfcpKwHx6Tyb/TO1JdRz7GU0TjzCJ2ktwyUzXTS/AwemjIOR3wDsWfaxRd?=
 =?us-ascii?Q?DsKGDyxQEcQCL8hcqZTLVAstWLkIEmcrTXtRcOIXPjJJgno1RmB0D3cm+ICp?=
 =?us-ascii?Q?nVn6d6vs3fKZAOAjQWPaVZADkW8+YtwZQi8zCZfdmfxBIQWZkURAJzXZfNn5?=
 =?us-ascii?Q?58GbEQkYdn2usFcm2d4XdzOqBhA0hXHqNkhmrYecM1Mp81mD6Afxi7gbMxq3?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f453d740-c450-4da7-65e5-08daa6d309c3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 13:10:56.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J42vKQYQf+Ojbhj33SCh4eMBY4BCBtmjObdmCF84f/7jSko26hIn68Nt/WI8nwExJQ6YKf34P5Hco2zVgY/Q5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7093
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--uOTRYISOpz+FLY8y
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


Greeting,

FYI, we noticed the following commit (built with gcc-11):

commit: 5336f1902b4ba8a646f082f32fbb183850a13080 ("[CFT][PATCH] proc: Update /proc/net to point at the accessing threads network namespace")
url: https://github.com/intel-lab-lkp/linux/commits/Eric-W-Biederman/proc-Update-proc-net-to-point-at-the-accessing-threads-network-namespace/20220930-065017
base: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git 987a926c1d8a40e4256953b04771fbdb63bc7938
patch link: https://lore.kernel.org/lkml/87ill53igy.fsf_-_@email.froward.int.ebiederm.org

in testcase: xfstests
version: xfstests-x86_64-5a5e419-1_20220927
with following parameters:

	disk: 6HDD
	fs: btrfs
	test: btrfs-group-21

test-description: xfstests is a regression test suite for xfs and other files ystems.
test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git


on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 8G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


+------------------------------------------+------------+------------+
|                                          | 987a926c1d | 5336f1902b |
+------------------------------------------+------------+------------+
| BUG:KASAN:global-out-of-bounds_in_memchr | 0          | 78         |
+------------------------------------------+------------+------------+


If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Link: https://lore.kernel.org/r/202210052104.561159b8-oliver.sang@intel.com


[ 71.510417][ T7965] BUG: KASAN: global-out-of-bounds in memchr (lib/string.c:883) 
[   71.517984][ T7965] Read of size 1 at addr ffffffff83b51604 by task killall/7965
[   71.526948][ T7965]
[   71.530801][ T7965] CPU: 1 PID: 7965 Comm: killall Tainted: G S                 6.0.0-rc7-00133-g5336f1902b4b #1
[   71.541870][ T7965] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
[   71.550663][ T7965] Call Trace:
[   71.554659][ T7965]  <TASK>
[ 71.558263][ T7965] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 71.563451][ T7965] print_address_description+0x1f/0x200 
[ 71.570717][ T7965] print_report.cold (mm/kasan/report.c:434) 
[ 71.576191][ T7965] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 71.582283][ T7965] ? memchr (lib/string.c:883) 
[ 71.586903][ T7965] kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:497) 
[ 71.591946][ T7965] ? memchr (lib/string.c:883) 
[ 71.596524][ T7965] memchr (lib/string.c:883) 
[ 71.600908][ T7965] verify_dirent_name (include/linux/fortify-string.h:432 fs/readdir.c:114) 
[ 71.606310][ T7965] filldir64 (fs/readdir.c:320) 
[ 71.611049][ T7965] ? folio_add_lru (arch/x86/include/asm/preempt.h:85 mm/swap.c:491) 
[ 71.616173][ T7965] proc_pid_readdir (fs/proc/base.c:3509) 
[ 71.621607][ T7965] ? proc_pid_lookup (fs/proc/base.c:3486) 
[ 71.627090][ T7965] ? proc_readdir_de (arch/x86/include/asm/atomic.h:165 arch/x86/include/asm/atomic.h:178 include/linux/atomic/atomic-instrumented.h:147 include/asm-generic/qrwlock.h:113 include/linux/rwlock_api_smp.h:232 fs/proc/generic.c:321 fs/proc/generic.c:284) 
[ 71.632617][ T7965] iterate_dir (fs/readdir.c:65) 
[ 71.637581][ T7965] __x64_sys_getdents64 (fs/readdir.c:370 fs/readdir.c:354 fs/readdir.c:354) 
[ 71.643287][ T7965] ? __ia32_sys_getdents (fs/readdir.c:354) 
[ 71.649053][ T7965] ? handle_mm_fault (mm/memory.c:5157) 
[ 71.654497][ T7965] ? __x64_sys_getdents (fs/readdir.c:312) 
[ 71.660169][ T7965] ? do_user_addr_fault (arch/x86/mm/fault.c:1426) 
[ 71.665863][ T7965] ? exit_to_user_mode_loop (include/linux/sched.h:2305 include/linux/resume_user_mode.h:61 kernel/entry/common.c:169) 
[ 71.671798][ T7965] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[ 71.676678][ T7965] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 
[   71.682981][ T7965] RIP: 0033:0x7f7f3cbe5387
[ 71.687826][ T7965] Code: 0f 1f 00 48 8b 47 20 c3 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 fa ff ff ff 7f b8 ff ff ff 7f 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 d9 aa 10 00 f7 d8 64 89 02 48
All code
========
   0:	0f 1f 00             	nopl   (%rax)
   3:	48 8b 47 20          	mov    0x20(%rdi),%rax
   7:	c3                   	retq   
   8:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
   f:	00 00 00 
  12:	90                   	nop
  13:	48 81 fa ff ff ff 7f 	cmp    $0x7fffffff,%rdx
  1a:	b8 ff ff ff 7f       	mov    $0x7fffffff,%eax
  1f:	48 0f 47 d0          	cmova  %rax,%rdx
  23:	b8 d9 00 00 00       	mov    $0xd9,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 01                	ja     0x33
  32:	c3                   	retq   
  33:	48 8b 15 d9 aa 10 00 	mov    0x10aad9(%rip),%rdx        # 0x10ab13
  3a:	f7 d8                	neg    %eax
  3c:	64 89 02             	mov    %eax,%fs:(%rdx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 01                	ja     0x9
   8:	c3                   	retq   
   9:	48 8b 15 d9 aa 10 00 	mov    0x10aad9(%rip),%rdx        # 0x10aae9
  10:	f7 d8                	neg    %eax
  12:	64 89 02             	mov    %eax,%fs:(%rdx)
  15:	48                   	rex.W
[   71.708650][ T7965] RSP: 002b:00007ffe0194edd8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
[   71.717564][ T7965] RAX: ffffffffffffffda RBX: 00005566e677e3a0 RCX: 00007f7f3cbe5387
[   71.726016][ T7965] RDX: 0000000000008000 RSI: 00005566e677e3d0 RDI: 0000000000000004
[   71.734485][ T7965] RBP: 00005566e677e3d0 R08: 0000000000000030 R09: 00007f7f3ccf0be0
[   71.742941][ T7965] R10: fffffffffffffd18 R11: 0000000000000293 R12: ffffffffffffff80
[   71.751511][ T7965] R13: 00005566e677e3a4 R14: 0000000000000000 R15: 00005566e67863e0
[   71.759971][ T7965]  </TASK>
[   71.763468][ T7965]
[   71.766290][ T7965] The buggy address belongs to the variable:
[ 71.772827][ T7965] proc_fs_parameters+0xcc4/0xd60 
[   71.778272][ T7965]
[   71.780980][ T7965] Memory state around the buggy address:
[   71.787003][ T7965]  ffffffff83b51500: 03 f9 f9 f9 f9 f9 f9 f9 00 f9 f9 f9 f9 f9 f9 f9
[   71.795510][ T7965]  ffffffff83b51580: 05 f9 f9 f9 f9 f9 f9 f9 00 04 f9 f9 f9 f9 f9 f9
[   71.803973][ T7965] >ffffffff83b51600: 04 f9 f9 f9 f9 f9 f9 f9 00 00 00 00 04 f9 f9 f9
[   71.812459][ T7965]                    ^
[   71.816899][ T7965]  ffffffff83b51680: f9 f9 f9 f9 00 f9 f9 f9 f9 f9 f9 f9 07 f9 f9 f9
[   71.825394][ T7965]  ffffffff83b51700: f9 f9 f9 f9 05 f9 f9 f9 f9 f9 f9 f9 07 f9 f9 f9
[   71.833858][ T7965] ==================================================================
[   71.842353][ T7965] Disabling lock debugging due to kernel taint
[   73.113893][ T7993] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   73.122970][ T7993] BTRFS info (device sdb2): disk space caching is enabled
[   73.249734][  T353] btrfs/212       _check_dmesg: something found in dmesg (see /lkp/benchmarks/xfstests/results//btrfs/212.dmesg)
[   73.249753][  T353]
[   73.265812][  T353]
[   73.265821][  T353]
[   73.290165][ T1650] run fstests btrfs/213 at 2022-10-02 03:09:04
[   73.975400][ T8186] BTRFS info (device sdb1): using crc32c (crc32c-intel) checksum algorithm
[   73.984538][ T8186] BTRFS info (device sdb1): disk space caching is enabled
[   74.305018][ T8250] BTRFS: device fsid 7b1643d2-a0ef-4a60-a3a1-7dfaa39dabb2 devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (8250)
[   74.338350][ T8261] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   74.347523][ T8261] BTRFS info (device sdb2): disk space caching is enabled
[   74.359821][ T8261] BTRFS info (device sdb2): checking UUID tree
[   78.669924][ T8302] BTRFS info (device sdb2): balance: start -d
[   78.676960][ T8302] BTRFS info (device sdb2): relocating block group 2177892352 flags data
[   80.486450][ T8302] BTRFS info (device sdb2): balance: canceled
[   80.569587][ T8311] BTRFS info (device sdb2): balance: start -m -s
[   80.578570][ T8311] BTRFS info (device sdb2): relocating block group 30408704 flags metadata|dup
[   80.728132][ T8311] BTRFS info (device sdb2): found 74 extents, stage: move data extents
[   80.845157][ T8311] BTRFS info (device sdb2): relocating block group 22020096 flags system|dup
[   81.002861][ T8311] BTRFS info (device sdb2): found 1 extents, stage: move data extents
[   81.161533][ T8311] BTRFS info (device sdb2): balance: ended with status: 0
[   83.031379][ T8342] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   83.040869][ T8342] BTRFS info (device sdb2): disk space caching is enabled
[   83.140497][  T353] btrfs/213        10s
[   83.140507][  T353]
[   83.177038][ T1650] run fstests btrfs/214 at 2022-10-02 03:09:14
[   83.520920][ T8539] BTRFS info (device sdb1): using crc32c (crc32c-intel) checksum algorithm
[   83.530034][ T8539] BTRFS info (device sdb1): disk space caching is enabled
[   83.795491][ T8591] BTRFS: device fsid 047db66e-9c5a-43b9-a0ed-a59a5a54c01a devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (8591)
[   83.828333][ T8602] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   83.837501][ T8602] BTRFS info (device sdb2): disk space caching is enabled
[   83.849771][ T8602] BTRFS info (device sdb2): checking UUID tree
[   84.553095][ T8643] BTRFS: device fsid 2b3475c1-7363-46bb-b5be-3b7de42f32b5 devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (8643)
[   84.587062][ T8657] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   84.596436][ T8657] BTRFS info (device sdb2): disk space caching is enabled
[   84.609434][ T8657] BTRFS info (device sdb2): checking UUID tree
[   85.519592][ T8718] BTRFS: device fsid 1489ff22-2c49-4e57-9c0b-ec0e45befbb1 devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (8718)
[   85.552817][ T8732] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   85.562090][ T8732] BTRFS info (device sdb2): disk space caching is enabled
[   85.574899][ T8732] BTRFS info (device sdb2): checking UUID tree
[   86.469477][ T8795] BTRFS: device fsid e3efb665-e701-41d2-a531-ffb2423afdc9 devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (8795)
[   86.503705][ T8809] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   86.513013][ T8809] BTRFS info (device sdb2): disk space caching is enabled
[   86.525302][ T8809] BTRFS info (device sdb2): checking UUID tree
[   87.419276][ T8872] BTRFS: device fsid 2e2cffbe-0236-4737-889d-f93e6a2de77b devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (8872)
[   87.452360][ T8886] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   87.461728][ T8886] BTRFS info (device sdb2): disk space caching is enabled
[   87.474447][ T8886] BTRFS info (device sdb2): checking UUID tree
[   88.348072][  T353] btrfs/214        5s
[   88.348082][  T353]
[   88.384248][ T1650] run fstests btrfs/215 at 2022-10-02 03:09:19
[   88.728498][ T9138] BTRFS info (device sdb1): using crc32c (crc32c-intel) checksum algorithm
[   88.737813][ T9138] BTRFS info (device sdb1): disk space caching is enabled
[   88.994029][ T9188] BTRFS: device fsid c723a7a3-6fd5-4421-bee8-2f5ae485be5d devid 1 transid 5 /dev/sdb2 scanned by mkfs.btrfs (9188)
[   89.035307][ T9202] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   89.044653][ T9202] BTRFS info (device sdb2): disabling disk space caching
[   89.057213][ T9202] BTRFS info (device sdb2): cleaning free space cache v1
[   89.093093][ T9202] BTRFS info (device sdb2): checking UUID tree
[   89.231074][ T9248] BTRFS info (device sdb2): using crc32c (crc32c-intel) checksum algorithm
[   89.251683][   T59] BTRFS warning (device sdb2): csum failed root 5 ino 257 off 0 csum 0x656bd64e expected csum 0x4ef41b07 mirror 1
[   89.265224][   T59] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[   89.275939][   T59] BTRFS warning (device sdb2): csum failed root 5 ino 257 off 0 csum 0x656bd64e expected csum 0x4ef41b07 mirror 1
[   89.289527][   T59] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[   89.312524][   T59] BTRFS warning (device sdb2): csum failed root 5 ino 257 off 0 csum 0x656bd64e expected csum 0x4ef41b07 mirror 1
[   89.326147][   T59] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[   89.336731][   T59] BTRFS warning (device sdb2): csum failed root 5 ino 257 off 4096 csum 0x656bd64e expected csum 0x4ef41b07 mirror 1
[   89.350710][   T59] BTRFS error (device sdb2): bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
[   89.361254][   T59] BTRFS warning (device sdb2): csum failed root 5 ino 257 off 8192 csum 0x656bd64e expected csum 0x4ef41b07 mirror 1


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--uOTRYISOpz+FLY8y
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.0.0-rc7-00133-g5336f1902b4b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.0.0-rc7 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-5) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23890
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23890
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING_USER=y
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
# CONFIG_BPF_SYSCALL is not set
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_FORCE_TASKS_RCU=y
CONFIG_TASKS_RCU=y
# CONFIG_FORCE_TASKS_RUDE_RCU is not set
CONFIG_TASKS_RUDE_RCU=y
CONFIG_FORCE_TASKS_TRACE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# CONFIG_TASKS_TRACE_RCU_READ_MB is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=1024
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
# CONFIG_X86_CPU_RESCTRL is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
CONFIG_INTEL_TDX_GUEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_HYGON is not set
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_ZHAOXIN is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_LATE_LOADING=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_X86_MEM_ENCRYPT=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_KERNEL_IBT is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
# CONFIG_X86_INTEL_TSX_MODE_OFF is not set
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
CONFIG_X86_INTEL_TSX_MODE_AUTO=y
# CONFIG_X86_SGX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_RETPOLINE=y
CONFIG_RETHUNK=y
CONFIG_CPU_IBRS_ENTRY=y
# CONFIG_SLS is not set
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_USERSPACE_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_PFRUT is not set
CONFIG_ACPI_PCC=y
CONFIG_PMIC_OPREGION=y
CONFIG_ACPI_PRMT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_AMD_PSTATE is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_CC_PLATFORM=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=19
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_GET_FREE_REGION=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
# CONFIG_USERFAULTFD is not set

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
# CONFIG_MPTCP is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
# CONFIG_EFI_COCO_SECRET is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_UBLK is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_VERBOSE_ERRORS is not set
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_AUTH is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
# CONFIG_NVME_TARGET_TCP is not set
# CONFIG_NVME_TARGET_AUTH is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_GSC is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_DM_AUDIT=y
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=m
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_AMT is not set
CONFIG_MACSEC=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
# CONFIG_IXGBE_IPSEC is not set
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_TXGBE is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_OCTEON_EP is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
# CONFIG_SFC_SIENA is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_NETLINK=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_CAN327 is not set
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA7280_HAPTICS is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_IQS626A is not set
# CONFIG_INPUT_IQS7222 is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
CONFIG_RANDOM_TRUST_CPU=y
CONFIG_RANDOM_TRUST_BOOTLOADER=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_METEORLAKE is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SY7636A is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_WMI_EC is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SIMPLE_MFD_I2C is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_LIRC=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_IR_IMON_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_IR_ENE=m
CONFIG_IR_FINTEK=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_ITE_CIR=m
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_TOY is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_RC_XBOX_DVD is not set

#
# CEC support
#
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# end of Media drivers

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
# CONFIG_DRM_DEBUG_MODESET_LOCK is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
# CONFIG_HID_LETSKETCH is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SIGMAMICRO is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_UCSI_STM32G0 is not set
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_STUSB160X is not set
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_FSA4480 is not set
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_INFINIBAND_ERDMA is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# CONFIG_DMABUF_SYSFS_STATS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MEM is not set
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_INTEL_ISHTP_ECLITE is not set
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_VSEC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_SERIAL_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
CONFIG_P2SB=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_IOMMU_SVA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_IRQ_REMAP=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_CLK is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEPRECATED_API is not set
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_KEY_NOTIFICATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
# CONFIG_CRYPTO_DH_RFC7919_GROUPS is not set
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3_GENERIC is not set
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_GENERIC is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
# CONFIG_FIPS_SIGNATURE_SELFTEST is not set

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_LIB_MEMNEQ=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=m
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_PERNUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_OBJTOOL=y
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
# CONFIG_FPROBE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
# CONFIG_RV is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAULT_INJECTION_USERCOPY is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAIL_SUNRPC is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--uOTRYISOpz+FLY8y
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='xfstests'
	export testcase='xfstests'
	export category='functional'
	export need_memory='3G'
	export job_origin='xfstests-btrfs.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis
bm_initrd_keep'
	export queue='vip'
	export testbox='lkp-hsw-d01'
	export tbox_group='lkp-hsw-d01'
	export submit_id='633857912c3ef55c3b4b3326'
	export job_file='/lkp/jobs/scheduled/lkp-hsw-d01/xfstests-6HDD-btrfs-btrfs-group-21-debian-11.1-x86_64-20220510.cgz-5336f1902b4ba8a646f082f32fbb183850a13080-20221001-23611-1iwtdw6-2.yaml'
	export id='daa29bfbac75f682c94f590170eb5b3783d843da'
	export queuer_version='/zday/lkp'
	export model='Haswell'
	export nr_node=1
	export nr_cpu=8
	export memory='8G'
	export nr_ssd_partitions=1
	export nr_hdd_partitions=6
	export hdd_partitions='/dev/disk/by-id/ata-ST4000NM0035-1V4107_ZC12HHHW-part*'
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040015800RGN-part2'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040015800RGN-part1'
	export brand='Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz'
	export need_kconfig='BLK_DEV_SD
SCSI
{"BLOCK"=>"y"}
SATA_AHCI
SATA_AHCI_PLATFORM
ATA
{"PCI"=>"y"}
BTRFS_FS'
	export commit='5336f1902b4ba8a646f082f32fbb183850a13080'
	export ucode='0x28'
	export need_kconfig_hw='{"PTP_1588_CLOCK"=>"y"}
{"E1000E"=>"y"}
{"ATA_SFF"=>"y"}
{"ATA_BMDMA"=>"y"}
ATA_PIIX
DRM_I915'
	export bisect_dmesg=true
	export kconfig='x86_64-rhel-8.3-func'
	export enqueue_time='2022-10-01 23:06:58 +0800'
	export _id='633857912c3ef55c3b4b3326'
	export _rt='/result/xfstests/6HDD-btrfs-btrfs-group-21/lkp-hsw-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080'
	export user='lkp'
	export compiler='gcc-11'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='24f4d246aba73fd5b757feb7fcbeefba15fdc964'
	export base_commit='f76349cf41451c5c42a99f18a9163377e4b364ff'
	export branch='linux-review/Eric-W-Biederman/proc-Update-proc-net-to-point-at-the-accessing-threads-network-namespace/20220930-065017'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export result_root='/result/xfstests/6HDD-btrfs-btrfs-group-21/lkp-hsw-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/3'
	export scheduler_version='/lkp/lkp/.src-20221001-230515'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/xfstests/6HDD-btrfs-btrfs-group-21/lkp-hsw-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/3
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/vmlinuz-6.0.0-rc7-00133-g5336f1902b4b
branch=linux-review/Eric-W-Biederman/proc-Update-proc-net-to-point-at-the-accessing-threads-network-namespace/20220930-065017
job=/lkp/jobs/scheduled/lkp-hsw-d01/xfstests-6HDD-btrfs-btrfs-group-21-debian-11.1-x86_64-20220510.cgz-5336f1902b4ba8a646f082f32fbb183850a13080-20221001-23611-1iwtdw6-2.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3-func
commit=5336f1902b4ba8a646f082f32fbb183850a13080
max_uptime=2100
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/fs_20220526.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/xfstests_20220927.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/xfstests-x86_64-5a5e419-1_20220927.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20220804.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='4.20.0'
	export repeat_to=6
	export schedule_notify_address=
	export stop_repeat_if_found='xfstests.btrfs.212.fail'
	export kbuild_queue_analysis=1
	export bm_initrd_keep=true
	export kernel='/pkg/linux/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/vmlinuz-6.0.0-rc7-00133-g5336f1902b4b'
	export dequeue_time='2022-10-01 23:09:55 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-hsw-d01/xfstests-6HDD-btrfs-btrfs-group-21-debian-11.1-x86_64-20220510.cgz-5336f1902b4ba8a646f082f32fbb183850a13080-20221001-23611-1iwtdw6-2.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup nr_hdd=6 $LKP_SRC/setup/disk

	run_setup fs='btrfs' $LKP_SRC/setup/fs

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test test='btrfs-group-21' $LKP_SRC/tests/wrapper xfstests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env test='btrfs-group-21' $LKP_SRC/stats/wrapper xfstests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time xfstests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--uOTRYISOpz+FLY8y
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
AAAAAARZWg==

--uOTRYISOpz+FLY8y
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="xfstests"

2022-10-01 15:10:59 export TEST_DIR=/fs/sda1
2022-10-01 15:10:59 export TEST_DEV=/dev/sda1
2022-10-01 15:10:59 export FSTYP=btrfs
2022-10-01 15:10:59 export SCRATCH_MNT=/fs/scratch
2022-10-01 15:10:59 mkdir /fs/scratch -p
2022-10-01 15:10:59 export SCRATCH_DEV_POOL="/dev/sda2 /dev/sda3 /dev/sda4 /dev/sda5 /dev/sda6"
2022-10-01 15:10:59 sed "s:^:btrfs/:" //lkp/benchmarks/xfstests/tests/btrfs-group-21
2022-10-01 15:10:59 ./check btrfs/210 btrfs/211 btrfs/212 btrfs/213 btrfs/214 btrfs/215 btrfs/216 btrfs/217 btrfs/218 btrfs/219
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 lkp-hsw-d01 6.0.0-rc7-00133-g5336f1902b4b #1 SMP Sat Oct 1 16:12:31 CST 2022
MKFS_OPTIONS  -- /dev/sda2
MOUNT_OPTIONS -- /dev/sda2 /fs/scratch

btrfs/210        1s
btrfs/211        3s
btrfs/212       _check_dmesg: something found in dmesg (see /lkp/benchmarks/xfstests/results//btrfs/212.dmesg)

btrfs/213        10s
btrfs/214        5s
btrfs/215        2s
btrfs/216        1s
btrfs/217       [not run] FSTRIM not supported
btrfs/218       - output mismatch (see /lkp/benchmarks/xfstests/results//btrfs/218.out.bad)
    --- tests/btrfs/218.out	2022-09-27 02:20:22.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//btrfs/218.out.bad	2022-10-01 15:11:42.390652512 +0000
    @@ -13,6 +13,7 @@
     [SCRATCH_DEV].flush_io_errs    0
     [SCRATCH_DEV].corruption_errs  0
     [SCRATCH_DEV].generation_errs  0
    +
     [SCRATCH_DEV].write_io_errs    0
     [SCRATCH_DEV].read_io_errs     0
     [SCRATCH_DEV].flush_io_errs    0
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/btrfs/218.out /lkp/benchmarks/xfstests/results//btrfs/218.out.bad'  to see the entire diff)
btrfs/219       [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//btrfs/219.out.bad)
    --- tests/btrfs/219.out	2022-09-27 02:20:22.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//btrfs/219.out.bad	2022-10-01 15:11:43.860652527 +0000
    @@ -1,2 +1,4 @@
     QA output created by 219
    -Silence is golden
    +We couldn't mount the old generation
    +(see /lkp/benchmarks/xfstests/results//btrfs/219.full for details)
    +umount: /fs/sda1/219.mnt: not mounted.
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/btrfs/219.out /lkp/benchmarks/xfstests/results//btrfs/219.out.bad'  to see the entire diff)
Ran: btrfs/210 btrfs/211 btrfs/212 btrfs/213 btrfs/214 btrfs/215 btrfs/216 btrfs/217 btrfs/218 btrfs/219
Not run: btrfs/217
Failures: btrfs/212 btrfs/218 btrfs/219
Failed 3 of 10 tests


--uOTRYISOpz+FLY8y
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/xfstests-btrfs.yaml
suite: xfstests
testcase: xfstests
category: functional
need_memory: 3G
disk: 6HDD
fs: btrfs
xfstests:
  test: btrfs-group-21
job_origin: xfstests-btrfs.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-hsw-d01
tbox_group: lkp-hsw-d01
submit_id: 6337f4242c3ef546e94f07a2
job_file: "/lkp/jobs/scheduled/lkp-hsw-d01/xfstests-6HDD-btrfs-btrfs-group-21-debian-11.1-x86_64-20220510.cgz-5336f1902b4ba8a646f082f32fbb183850a13080-20221001-18153-ef4119-0.yaml"
id: 00ac78e5fb4e51087669c64eb8902b5b9b42cf4d
queuer_version: "/zday/lkp"

#! hosts/lkp-hsw-d01
model: Haswell
nr_node: 1
nr_cpu: 8
memory: 8G
nr_ssd_partitions: 1
nr_hdd_partitions: 6
hdd_partitions: "/dev/disk/by-id/ata-ST4000NM0035-1V4107_ZC12HHHW-part*"
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040015800RGN-part2"
swap_partitions:
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL42040015800RGN-part1"
brand: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz

#! include/category/functional
kmsg:
heartbeat:
meminfo:

#! include/disk/nr_hdd
need_kconfig:
- BLK_DEV_SD
- SCSI
- BLOCK: y
- SATA_AHCI
- SATA_AHCI_PLATFORM
- ATA
- PCI: y
- BTRFS_FS

#! include/queue/cyclic
commit: 5336f1902b4ba8a646f082f32fbb183850a13080

#! include/testbox/lkp-hsw-d01
ucode: '0x28'
need_kconfig_hw:
- PTP_1588_CLOCK: y
- E1000E: y
- ATA_SFF: y
- ATA_BMDMA: y
- ATA_PIIX
- DRM_I915
bisect_dmesg: true

#! include/fs/OTHERS
kconfig: x86_64-rhel-8.3-func
enqueue_time: 2022-10-01 16:02:44.828041099 +08:00
_id: 6337f4242c3ef546e94f07a2
_rt: "/result/xfstests/6HDD-btrfs-btrfs-group-21/lkp-hsw-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080"

#! schedule options
user: lkp
compiler: gcc-11
LKP_SERVER: internal-lkp-server
head_commit: 24f4d246aba73fd5b757feb7fcbeefba15fdc964
base_commit: f76349cf41451c5c42a99f18a9163377e4b364ff
branch: linux-devel/devel-hourly-20220930-132755
rootfs: debian-11.1-x86_64-20220510.cgz
result_root: "/result/xfstests/6HDD-btrfs-btrfs-group-21/lkp-hsw-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/0"
scheduler_version: "/lkp/lkp/.src-20220930-114750"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-11.1-x86_64-20220510.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/xfstests/6HDD-btrfs-btrfs-group-21/lkp-hsw-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/vmlinuz-6.0.0-rc7-00133-g5336f1902b4b
- branch=linux-devel/devel-hourly-20220930-132755
- job=/lkp/jobs/scheduled/lkp-hsw-d01/xfstests-6HDD-btrfs-btrfs-group-21-debian-11.1-x86_64-20220510.cgz-5336f1902b4ba8a646f082f32fbb183850a13080-20221001-18153-ef4119-0.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-func
- commit=5336f1902b4ba8a646f082f32fbb183850a13080
- max_uptime=2100
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw

#! runtime status
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/modules.cgz"
bm_initrd: "/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/fs_20220526.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/xfstests_20220927.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/xfstests-x86_64-5a5e419-1_20220927.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20220804.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /cephfs/db/releases/20220930220620/lkp-src/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
last_kernel: 4.20.0
schedule_notify_address:

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-8.3-func/gcc-11/5336f1902b4ba8a646f082f32fbb183850a13080/vmlinuz-6.0.0-rc7-00133-g5336f1902b4b"
dequeue_time: 2022-10-01 16:44:50.594093809 +08:00

#! /cephfs/db/releases/20221001004130/lkp-src/include/site/inn
job_state: finished
loadavg: 1.59 0.66 0.25 1/187 10825
start_time: '1664613960'
end_time: '1664614008'
version: "/lkp/lkp/.src-20220930-114825:5505f0429:e3460de8e"

--uOTRYISOpz+FLY8y
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="reproduce"

dmsetup remove_all
wipefs -a --force /dev/sda1
wipefs -a --force /dev/sda2
wipefs -a --force /dev/sda3
wipefs -a --force /dev/sda4
wipefs -a --force /dev/sda5
wipefs -a --force /dev/sda6
mkfs -t btrfs /dev/sda2
mkfs -t btrfs /dev/sda1
mkfs -t btrfs /dev/sda4
mkfs -t btrfs /dev/sda5
mkfs -t btrfs /dev/sda6
mkfs -t btrfs /dev/sda3
mkdir -p /fs/sda1
mount -t btrfs /dev/sda1 /fs/sda1
mkdir -p /fs/sda2
mount -t btrfs /dev/sda2 /fs/sda2
mkdir -p /fs/sda3
mount -t btrfs /dev/sda3 /fs/sda3
mkdir -p /fs/sda4
mount -t btrfs /dev/sda4 /fs/sda4
mkdir -p /fs/sda5
mount -t btrfs /dev/sda5 /fs/sda5
mkdir -p /fs/sda6
mount -t btrfs /dev/sda6 /fs/sda6
export TEST_DIR=/fs/sda1
export TEST_DEV=/dev/sda1
export FSTYP=btrfs
export SCRATCH_MNT=/fs/scratch
mkdir /fs/scratch -p
export SCRATCH_DEV_POOL="/dev/sda2 /dev/sda3 /dev/sda4 /dev/sda5 /dev/sda6"
sed "s:^:btrfs/:" //lkp/benchmarks/xfstests/tests/btrfs-group-21
./check btrfs/210 btrfs/211 btrfs/212 btrfs/213 btrfs/214 btrfs/215 btrfs/216 btrfs/217 btrfs/218 btrfs/219

--uOTRYISOpz+FLY8y--
