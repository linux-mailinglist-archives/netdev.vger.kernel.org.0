Return-Path: <netdev+bounces-9973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A88B872B800
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42A4D281041
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745AA3C1D;
	Mon, 12 Jun 2023 06:17:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A262566
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:17:22 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F31BB;
	Sun, 11 Jun 2023 23:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686550631; x=1718086631;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=tcqb6QX8ApEpj7y2vpmIA0hFVYH56jfXG035pA2lGKw=;
  b=DpCPg/kLinHU86/vKzvZ2d5RMSRAdHWTsJi2UKKes5XKeuMXZSLWTpZ9
   JPAkvSJGlmJxbE7YbHt3TUl+xUichzsFFGhsvqbzHQNbXOVpcsWVeinRk
   BeVR6ZG1NvTZffBdw18oDDHPLfpJUUTNyJQb3wNP6Sy/olKQqSBCcjdEh
   S5l0WqiSvkIRSkwPtD1XbCGR6kqkyqI8KWm86c2/8UtCCDRtsxHwMfaRo
   9KI14gN57yFfQnUhMMQZTW62Zh1r+uf46tRMeQT1nojioodX+aF0gssvC
   F2/wqJmM/TZl3e5e6QNcO4w66A9mhREgbeU+HayOyc03j7hrRUGSqT8T8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="357951621"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="xz'341?yaml'341?scan'341,208,341";a="357951621"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 23:16:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="688492745"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="xz'341?yaml'341?scan'341,208,341";a="688492745"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 11 Jun 2023 23:16:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 23:16:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 23:16:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 23:16:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 23:16:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgPcURZxGyJNWnnnmWXPwthozhChliY4yr8dc0/S6BrDhxrY5/S6rHboqxhxsBh02OoiCR3MnsDXt0iXJ/64J13O4p5ZqVuOUGhaJsBV0kiO+T18no0AaSLuDj2Gm6DjPiEB2mt6f4roFIZuIdedq9qGLlTNVENx7CdjOfeRjtuCtqdcgxnALiEDg7c5XDNuUV9itH9msa+cnh3205TnI5Wl+1vrJvy20iKbUbPLsA4mLOA0xZOE37vO8cJhvDc5gdqhdaWaqbklg83k08HB3Chs5UBKY3jkFBj7g49APojfemJv4noCaX+s0qGXnWtT+3yy5hpBZJQKkI0m0vcF9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abxwIXdBFhltyoTOuZ/YaOKSW5AKpFfiX1QfjRlTo5k=;
 b=Tmb4nS1yZFNhwz57q2W/Rbp4W7IQvcoEYKneDHOuWEvvniqRRjpiZTe6IJXA0VmhoAnivdlSI530bgiS2cz9qcQGsvoSa3aUbL0V7zdmeyAQwi7tiEF+Y4o/pMmtwUQ3pZqjdcTvNymzOy9Zlv6nSYJlHG/a1fwhy7KpKSl4Lnw1aZW32Q3QNuXgYOKVLemJxXc7JXSR/3wuWIsR+EIc7KdKikjCjboBimpyp/8Kaf4XB6qR2YUpsLUQXEfaLROfBTqVCDzGA+nvchSshVVfEWc37vhC22CyKtEBhQPhgENlh0qgOKntdThiLWgE9gNrfTrtOZ3Cx/vG/UR12GyJfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SA0PR11MB4624.namprd11.prod.outlook.com (2603:10b6:806:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 06:16:44 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::35cf:8518:48ea:b10a]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::35cf:8518:48ea:b10a%6]) with mapi id 15.20.6455.028; Mon, 12 Jun 2023
 06:16:44 +0000
Date: Mon, 12 Jun 2023 14:16:28 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Richard Weinberger <richard@nod.at>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, <netdev@vger.kernel.org>,
	<keescook@chromium.org>, Richard Weinberger <richard@nod.at>, Petr Mladek
	<pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky
	<senozhatsky@chromium.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
	<alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, "Boqun
 Feng" <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
	<benno.lossin@proton.me>, Alexei Starovoitov <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [RFC PATCH 1/1] vsprintf: Warn on integer scanning overflows
Message-ID: <202306121011.2487b7a9-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="WlSHMmdA2LHDp38i"
Content-Disposition: inline
In-Reply-To: <20230607223755.1610-2-richard@nod.at>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SA0PR11MB4624:EE_
X-MS-Office365-Filtering-Correlation-Id: e2278349-0c44-4ddd-8f16-08db6b0c978e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPXdCtsWudpP0bkXUwpjVhLdF31dD8h3ALhcdJGxMfSGIV+E508mzsdOuH0xuFmJJgAec9bw2ysVIciY9uR58QZZ4LjUjasX8BPw13dlJf9YNpxXUk2K44lq7iRj/bGoKCOJFODCF/wmOZEgBAV/y1/x8KtiIjIrdRyxBIvmfJxxMqJsifQzIg2KYO9dXT4ievx1vWHxKLCxBGP0Lbl74pvJtA2RQYTAjkrTom7Y4LRro/EudCHGIiGlbO238p1fmIQEKputR74ucYvw/EdGB67mCXO6SFLi8G0i0+b9yB2HzWY6nZuKkgpqS0q+yjohK6/0jvh4QqA+sgWkypcVjgDnUSFc+6N/WbYCHPhnFhF8H57kmEmZXzJJEag/oBeEmz6ES2a1LJimgDAAK1OSArPeYTm1Iqt7VtZEeyE9FpI4vm38Yo+jPVpZdddP78hsJ1s038sf7BazfnGBrbwuSNkbSoFIuhWkktKbXRalIwuetZ241ZGSnR0ST3eLsX5/m1MuOv2QGgtCnAU4ivfq0eVf2+Wd/QPLMm5oI7F8Le3swbIGPL1CO3IWlH0lL/yAZPLJVZ5GDkcWTodbxAuj3Pzc9E3TyG0WhQrWui7dbbqJk5PSKjn/WMgpzQkLuhmyjHiO5QwXOeijbexD07wHiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(5660300002)(54906003)(4326008)(66946007)(66556008)(6916009)(8936002)(316002)(8676002)(41300700001)(235185007)(7416002)(2906002)(186003)(66476007)(478600001)(45080400002)(6666004)(21490400003)(966005)(44144004)(6486002)(1076003)(6506007)(6512007)(26005)(83380400001)(36756003)(86362001)(82960400001)(2616005)(38100700002)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zvWf6xgThCsQgTLTq8r8M6QZpDN0MZsmApfVfheeiSfJvNkp///yKoVZdyy8?=
 =?us-ascii?Q?X+kKOCMtVk84UPGjvE1LqhLSJjDmXgnPy4QuxEGAiV6sJJLXnwiN7zUDfwxU?=
 =?us-ascii?Q?1XeT5dtE4AZRJf7t857t9OzFP1S3EmAH+q0/v6b2bBTiG05KkYKk76qYofcy?=
 =?us-ascii?Q?0f50DvqWkGc9MzzEbVNZT2LXQe54p3+6hHIYNsRGstGKH7NoiChRjU7LeAcd?=
 =?us-ascii?Q?vMq7b+D2uLSuhbaR6SYqfFaq8vPThxpAyQP5JihmXPGQvG9c0n8IdSrw6tMM?=
 =?us-ascii?Q?WNrRKXpuqKeJlwFKJpJKhEY5QyjRkl6FujqpttEPkxnpU3o9HL5SYMrKAeq7?=
 =?us-ascii?Q?5JV3abkc5XRg5C47m/zpO18ZOBWkJY5uq7hSBylWMs/TDEwiqdzg0oqEqMcO?=
 =?us-ascii?Q?uaEdokRVN1Vv2OrcVJOWtx7Ppbp3HSRYo93AHeECh5QDZrA5NpZOrfXL/P9Q?=
 =?us-ascii?Q?XEHtsdSYOFJ3aI+bnJBbkMo+4/TtsuZ0pSs+EDo0XtpynSZ6MbN0NUGPHChI?=
 =?us-ascii?Q?/dGoqVfA3wOLcwhXIG/nsCJjVt1sruxgWvD8pdFX2QJi6aSwpxkDRjd9JUaa?=
 =?us-ascii?Q?apjQsqR6fTwQpxsEQpM3BjHHZbT3c4yRo2c6LSwRKOWPRO4D3axHGR5qNylX?=
 =?us-ascii?Q?WbB5jdYx2LwVLyu8ZzP/aKrXwG06OG4mTclVDV2govnYL/RHlWUsEMtZ5CSE?=
 =?us-ascii?Q?1kfBqlNwlJ2R6wCeiRn3GFGouQSxMTY1iJ3epdjqbo3wLdyhLiC66SFX555f?=
 =?us-ascii?Q?sGCS68fOcxDMdSmp04FDHB+kXPls7sve1OxTno8sdwuYmKiZM08lJFMCXHI7?=
 =?us-ascii?Q?1Z21MXE1yEvjJuEV/3jdTkbXcGqNK2oTPk6gD9tSklIWRiGDe7AWyQByRtkb?=
 =?us-ascii?Q?6GGrdumxr0e/r8ROLVVxb+j0bezUJj1gc2tVf7TbjeiiP//itCN/CH+uNkyY?=
 =?us-ascii?Q?YVztPn/J3cMV+4Ips8kRsyerh3c1iBudKVbr/dUgX5tL6MywhQh3Y+9OmKDS?=
 =?us-ascii?Q?geA9PBXQDXNR2LbC1r8wUqSIPV51rkYD388JjfbcmfjDFxCWjsZxBzMc8tUg?=
 =?us-ascii?Q?BHYbkX1yno+9M9A3H4dF35Dfzzo41TqwEHuPxtelf5kLlIM89MHXwgYe6xW+?=
 =?us-ascii?Q?O+yv1S7JhjXD+gpqD07OjJOXXDQGqbGnEp1/tU9Kf7y2At/ZJfRHYCbgEHD9?=
 =?us-ascii?Q?4IKmF1AAymRnnHPiK1XkSW3Nd0fX8TpFxtIZvgOKD+QSVN41/Do5JnZcpNFE?=
 =?us-ascii?Q?2WGUuqD2S2wyS0K7bxMaJVTnyd1JBPOKKa8ukcV+LqRHwDW30jaqfE7Umtzf?=
 =?us-ascii?Q?/rozZrppDSh9pSSvgxQxaSYfIHA+ZV244KKG8G3u8eT+a6/WoebahVQdrqr4?=
 =?us-ascii?Q?iDTDoO2c/rKYIiF+6wDyaWMHMxhp2Q5GG2ysS7Ea6y2W8XJYs8PbicoLAFND?=
 =?us-ascii?Q?TjxaNHgp5sC/rkqSbQhcuYlcTJJ+SOHikj9Esm+CDATcrLABK7rY0ZLpc2ND?=
 =?us-ascii?Q?aYLu7IBXBbUBJustXUUCL6WD2yUVC2cM6dvEZOZFuUyU8PYMARYQZgLyeXJo?=
 =?us-ascii?Q?lOaUqP77D1sSWprxnFAtPdQkfiDmY6pOJJ6OS1uXlSaksxMd9bq7t41uwSib?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2278349-0c44-4ddd-8f16-08db6b0c978e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 06:16:43.9888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQuffbg3yGOxrKEkpMQ/GdCw3ZLA65+wWW50CD8pfp6djo0yimSNwqVADEv3gry80IKTLdHl5qnx8FYRAja/PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4624
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FAKE_REPLY_C,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--WlSHMmdA2LHDp38i
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


hi Richard Weinberger,

we noticed the new warning added in this patch was hit.
we know this commit should not be the real root cause, just send out this
report FYI.

Hello,

kernel test robot noticed "WARNING:at_lib/vsprintf.c:#vsscanf" on:

commit: 5f4287fc4655b77bfb9012a7a0ed630d65d01695 ("[RFC PATCH 1/1] vsprintf: Warn on integer scanning overflows")
url: https://github.com/intel-lab-lkp/linux/commits/Richard-Weinberger/vsprintf-Warn-on-integer-scanning-overflows/20230608-064044
base: https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git for-next/pstore
patch link: https://lore.kernel.org/all/20230607223755.1610-2-richard@nod.at/
patch subject: [RFC PATCH 1/1] vsprintf: Warn on integer scanning overflows

in testcase: kunit
version: 
with following parameters:

	group: group-01



compiler: gcc-12
test machine: 16 threads 1 sockets Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz (Broadwell-DE) with 48G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202306121011.2487b7a9-oliver.sang@intel.com


[  105.244690][  T819] ------------[ cut here ]------------
[ 105.253891][ T819] WARNING: CPU: 11 PID: 819 at lib/vsprintf.c:3701 vsscanf (lib/vsprintf.c:3701 (discriminator 1)) 
[  105.272240][  T819] Modules linked in: test_scanf(N+) intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 btrfs blake2b_generic xor raid6_pq libcrc32c crc32c_intel rapl sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg ipmi_ssif intel_cstate ast drm_shmem_helper ahci drm_kms_helper libahci acpi_ipmi intel_uncore mei_me syscopyarea libata ipmi_si ioatdma joydev sysfillrect gpio_ich intel_pch_thermal sysimgblt mei mxm_wmi ipmi_devintf dca ipmi_msghandler wmi acpi_pad drm fuse ip_tables [last unloaded: test_static_key_base]
[  105.380736][  T819] CPU: 11 PID: 819 Comm: modprobe Tainted: G S               N 6.4.0-rc1-00002-g5f4287fc4655 #1
[  105.392450][  T819] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
[ 105.402710][ T819] RIP: 0010:vsscanf (lib/vsprintf.c:3701 (discriminator 1)) 
[ 105.409007][ T819] Code: 4c 89 ef e8 4c ef eb fd 48 0f ba b4 24 a0 00 00 00 00 44 8b 4c 24 10 e9 7e ef ff ff 0f 0b e9 dd fc ff ff 0f 0b e9 d6 fc ff ff <0f> 0b e9 5b f8 ff ff 0f 0b e9 1b f9 ff ff 0f 0b e9 14 f9 ff ff 0f
All code
========
   0:	4c 89 ef             	mov    %r13,%rdi
   3:	e8 4c ef eb fd       	callq  0xfffffffffdebef54
   8:	48 0f ba b4 24 a0 00 	btrq   $0x0,0xa0(%rsp)
   f:	00 00 00 
  12:	44 8b 4c 24 10       	mov    0x10(%rsp),%r9d
  17:	e9 7e ef ff ff       	jmpq   0xffffffffffffef9a
  1c:	0f 0b                	ud2    
  1e:	e9 dd fc ff ff       	jmpq   0xfffffffffffffd00
  23:	0f 0b                	ud2    
  25:	e9 d6 fc ff ff       	jmpq   0xfffffffffffffd00
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	e9 5b f8 ff ff       	jmpq   0xfffffffffffff88c
  31:	0f 0b                	ud2    
  33:	e9 1b f9 ff ff       	jmpq   0xfffffffffffff953
  38:	0f 0b                	ud2    
  3a:	e9 14 f9 ff ff       	jmpq   0xfffffffffffff953
  3f:	0f                   	.byte 0xf

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	e9 5b f8 ff ff       	jmpq   0xfffffffffffff862
   7:	0f 0b                	ud2    
   9:	e9 1b f9 ff ff       	jmpq   0xfffffffffffff929
   e:	0f 0b                	ud2    
  10:	e9 14 f9 ff ff       	jmpq   0xfffffffffffff929
  15:	0f                   	.byte 0xf
[  105.431369][  T819] RSP: 0018:ffffc9000120f730 EFLAGS: 00010206
[  105.438770][  T819] RAX: 00000000ffffffff RBX: 00000000ffffffff RCX: 000000000000000f
[  105.448085][  T819] RDX: 00000000ffffffff RSI: ffffc9000120f6c0 RDI: 00000000fffffff0
[  105.457422][  T819] RBP: 1ffff92000241eee R08: ffff8881f4af5fff R09: 00000000ffffffff
[  105.466692][  T819] R10: 00000000000000ff R11: 0000000000000010 R12: dffffc0000000000
[  105.475991][  T819] R13: 0000000000000000 R14: ffffc9000120f8d0 R15: ffffffffc0a2ca42
[  105.485326][  T819] FS:  00007f4bfafd0540(0000) GS:ffff888ab9b80000(0000) knlGS:0000000000000000
[  105.495578][  T819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  105.503457][  T819] CR2: 00005645746ea122 CR3: 000000016b904002 CR4: 00000000003706e0
[  105.512757][  T819] DR0: ffffffff8635204c DR1: ffffffff8635204d DR2: ffffffff8635204e
[  105.522075][  T819] DR3: ffffffff8635204f DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  105.531423][  T819] Call Trace:
[  105.536017][  T819]  <TASK>
[ 105.540310][ T819] ? simple_strtol (lib/vsprintf.c:3433) 
[ 105.546195][ T819] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:543 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:186 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 105.552848][ T819] ? _raw_read_unlock_irqrestore (kernel/locking/spinlock.c:161) 
[ 105.559938][ T819] ? vsnprintf (lib/vsprintf.c:2768) 
[ 105.565718][ T819] ? check_ushort (lib/test_scanf.c:120) test_scanf
[ 105.572801][ T819] _test (lib/test_scanf.c:44) test_scanf
[ 105.579005][ T819] ? check_ull (lib/test_scanf.c:33) test_scanf
[ 105.585851][ T819] ? kasan_save_stack (mm/kasan/common.c:46) 
[ 105.591946][ T819] ? snprintf (lib/vsprintf.c:2948) 
[ 105.597318][ T819] numbers_simple (lib/test_scanf.c:242 (discriminator 8)) test_scanf
[ 105.604512][ T819] ? _test (lib/test_scanf.c:218) test_scanf
[ 105.610909][ T819] selftest (lib/test_scanf.c:771 lib/test_scanf.c:800) test_scanf
[ 105.617312][ T819] ? selftest (lib/test_scanf.c:811) test_scanf
[ 105.623967][ T819] test_scanf_init (lib/test_scanf.c:811) test_scanf
[ 105.630968][ T819] do_one_initcall (init/main.c:1246) 
[ 105.636828][ T819] ? trace_event_raw_event_initcall_level (init/main.c:1237) 
[ 105.644758][ T819] ? kasan_unpoison (mm/kasan/shadow.c:160 mm/kasan/shadow.c:194) 
[ 105.650593][ T819] do_init_module (kernel/module/main.c:2529) 
[ 105.656423][ T819] load_module (kernel/module/main.c:2980) 
[ 105.662145][ T819] ? post_relocation (kernel/module/main.c:2829) 
[ 105.668227][ T819] ? __x64_sys_fspick (fs/kernel_read_file.c:38) 
[ 105.674383][ T819] ? __do_sys_finit_module (kernel/module/main.c:3099) 
[ 105.680880][ T819] __do_sys_finit_module (kernel/module/main.c:3099) 
[ 105.687189][ T819] ? __ia32_sys_init_module (kernel/module/main.c:3061) 
[ 105.693654][ T819] ? randomize_page (mm/util.c:533) 
[ 105.699366][ T819] ? ksys_mmap_pgoff (mm/mmap.c:1445) 
[ 105.705319][ T819] ? __fdget_pos (arch/x86/include/asm/atomic64_64.h:22 include/linux/atomic/atomic-long.h:29 include/linux/atomic/atomic-instrumented.h:1310 fs/file.c:1045) 
[ 105.710712][ T819] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[ 105.716060][ T819] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 
[  105.722870][  T819] RIP: 0033:0x7f4bfb0f19b9
[ 105.728156][ T819] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a7 54 0c 00 f7 d8 64 89 01 48
All code
========
   0:	00 c3                	add    %al,%bl
   2:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
   9:	00 00 00 
   c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 8b 0d a7 54 0c 00 	mov    0xc54a7(%rip),%rcx        # 0xc54e1
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	retq   
   9:	48 8b 0d a7 54 0c 00 	mov    0xc54a7(%rip),%rcx        # 0xc54b7
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W


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
https://github.com/intel/lkp-tests/wiki



--WlSHMmdA2LHDp38i
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.4.0-rc1-00002-g5f4287fc4655"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.4.0-rc1 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-12 (Debian 12.2.0-14) 12.2.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=120200
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=24000
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=24000
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=125
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
# CONFIG_WATCH_QUEUE is not set
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
CONFIG_TIME_KUNIT_TEST=m
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
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=125
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
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
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# CONFIG_RCU_LAZY is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
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
CONFIG_GCC11_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_SCHED_MM_CID=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
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
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
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
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y

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
CONFIG_GENERIC_CSUM=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
# CONFIG_INTEL_TDX_GUEST is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
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
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_PERF_EVENTS_AMD_UNCORE is not set
# CONFIG_PERF_EVENTS_AMD_BRS is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_LATE_LOADING=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
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
CONFIG_X86_KERNEL_IBT=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
# CONFIG_X86_SGX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_HANDOVER_PROTOCOL=y
CONFIG_EFI_MIXED=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_MAP=y
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
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
# CONFIG_ADDRESS_MASKING is not set
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
CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_RETPOLINE is not set
CONFIG_CPU_IBPB_ENTRY=y
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
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_TABLE_LIB=y
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
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_HMAT=y
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
# CONFIG_ACPI_FFH is not set
# CONFIG_PMIC_OPREGION is not set
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
# CONFIG_X86_AMD_PSTATE_UT is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
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
CONFIG_CPU_IDLE_GOV_HALTPOLL=y
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
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
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
CONFIG_HAVE_KVM_DIRTY_RING_TSO=y
CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL=y
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
CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_KVM_SMM=y
# CONFIG_KVM_XEN is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y
CONFIG_AS_GFNI=y

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
CONFIG_HAVE_RUST=y
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
CONFIG_MMU_LAZY_TLB_REFCOUNT=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
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
CONFIG_ARCH_SUPPORTS_CFI_CLANG=y
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
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
# CONFIG_MODULE_DEBUG is not set
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
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_CGROUP_PUNT_BIO=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
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
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
CONFIG_BINFMT_ELF_KUNIT_TEST=y
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
CONFIG_ZSMALLOC_CHAIN_SIZE=8

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
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
CONFIG_ARCH_WANT_OPTIMIZE_VMEMMAP=y
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
CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1
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
# CONFIG_CMA is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
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
# CONFIG_DMAPOOL_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
# CONFIG_USERFAULTFD is not set
# CONFIG_LRU_GEN is not set
CONFIG_ARCH_SUPPORTS_PER_VMA_LOCK=y
CONFIG_PER_VMA_LOCK=y

#
# Data Access Monitoring
#
CONFIG_DAMON=y
# CONFIG_DAMON_KUNIT_TEST is not set
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_VADDR_KUNIT_TEST=y
CONFIG_DAMON_SYSFS=y
CONFIG_DAMON_DBGFS=y
CONFIG_DAMON_DBGFS_KUNIT_TEST=y
# CONFIG_DAMON_RECLAIM is not set
# CONFIG_DAMON_LRU_SORT is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
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
# CONFIG_NET_KEY is not set
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_NET_HANDSHAKE=y
# CONFIG_NET_HANDSHAKE_KUNIT_TEST is not set
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
CONFIG_INET_TABLE_PERTURB_ORDER=16
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
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_MPTCP_KUNIT_TEST=m
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
CONFIG_NETFILTER_BPF_LINK=y
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
CONFIG_NF_CONNTRACK_OVS=y
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
CONFIG_NF_NAT_OVS=y
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
# CONFIG_NETFILTER_XTABLES_COMPAT is not set

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

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

# CONFIG_IP_SET is not set
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
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
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
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
CONFIG_NET_SCH_MQPRIO_LIB=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
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
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
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
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
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
CONFIG_MAX_SKB_FRAGS=17
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
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
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
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
CONFIG_PAGE_POOL=y
# CONFIG_PAGE_POOL_STATS is not set
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_NETDEV_ADDR_LIST_TEST=m

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
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_DOE=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
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
CONFIG_PCI_HYPERV_INTERFACE=m

#
# Cadence-based PCIe controllers
#
# end of Cadence-based PCIe controllers

#
# DesignWare-based PCIe controllers
#
# CONFIG_PCI_MESON is not set
# CONFIG_PCIE_DW_PLAT_HOST is not set
# end of DesignWare-based PCIe controllers

#
# Mobiveil-based PCIe controllers
#
# end of Mobiveil-based PCIe controllers
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

CONFIG_CXL_BUS=m
CONFIG_CXL_PCI=m
# CONFIG_CXL_MEM_RAW_COMMANDS is not set
CONFIG_CXL_ACPI=m
CONFIG_CXL_PMEM=m
CONFIG_CXL_MEM=m
CONFIG_CXL_PORT=m
CONFIG_CXL_SUSPEND=y
CONFIG_CXL_REGION=y
CONFIG_CXL_REGION_INVALIDATION_TEST=y
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
CONFIG_FW_LOADER_DEBUG=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_PM_QOS_KUNIT_TEST=y
CONFIG_HMEM_REPORTING=y
CONFIG_TEST_ASYNC_DRIVER_PROBE=m
CONFIG_DRIVER_PE_KUNIT_TEST=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
# CONFIG_REGMAP_KUNIT is not set
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# CONFIG_FW_DEVLINK_SYNC_STATE_TIMEOUT is not set
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
CONFIG_EFI_SOFT_RESERVE=y
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_APPLE_PROPERTIES=y
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
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
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
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_AUTH is not set
# CONFIG_NVME_TARGET is not set
# end of NVME Support

#
# Misc devices
#
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_SGI_XP is not set
CONFIG_HP_ILO=m
# CONFIG_SGI_GRU is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
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

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_GSC is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
# CONFIG_VMWARE_VMCI is not set
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# CONFIG_GP_PCI1XXXX is not set
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
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
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
CONFIG_HYPERV_STORAGE=m
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
# CONFIG_AHCI_DWC is not set
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
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_PARPORT is not set

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
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
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
CONFIG_DM_AUDIT=y
# CONFIG_TARGET_CORE is not set
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
# CONFIG_DUMMY is not set
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
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
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
# CONFIG_JME is not set
CONFIG_NET_VENDOR_ADI=y
# CONFIG_ADIN1110 is not set
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
# CONFIG_VCAP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_MICROSOFT_MANA is not set
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
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
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
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

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
# CONFIG_MICROCHIP_T1S_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_CBTX_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_NCN26000_PHY is not set
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
# CONFIG_PSE_CONTROLLER is not set
# CONFIG_CAN_DEV is not set
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
# CONFIG_WLAN is not set
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_USB4_NET is not set
CONFIG_HYPERV_NET=y
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
# CONFIG_INPUT_KUNIT_TEST is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
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
# CONFIG_KEYBOARD_CROS_EC is not set
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
# CONFIG_INPUT_MISC is not set
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
CONFIG_HYPERV_KEYBOARD=m
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
CONFIG_LEGACY_TIOCSTI=y
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
CONFIG_SERIAL_8250_PCILIB=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_PCI1XXXX is not set
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
# CONFIG_SERIAL_JSM is not set
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
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
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
CONFIG_I2C_SMBUS=y
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
CONFIG_I2C_I801=y
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
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_CROS_EC_TUNNEL is not set
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
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_MICROCHIP_CORE_QSPI is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PCI1XXXX is not set
# CONFIG_SPI_PXA2XX is not set
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
CONFIG_SPI_LOOPBACK_TEST=m
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
# CONFIG_PINCTRL_CY8C95X0 is not set
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
# CONFIG_GPIO_FXL6408 is not set
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
# CONFIG_GPIO_ELKHARTLAKE is not set
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
# CONFIG_GPIO_LATCH is not set
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
# CONFIG_GENERIC_ADC_BATTERY is not set
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
# CONFIG_CHARGER_CROS_USBPD is not set
CONFIG_CHARGER_CROS_PCHG=m
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
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
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
# CONFIG_SENSORS_IIO_HWMON is not set
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
# CONFIG_SENSORS_MAX31760 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MC34VR500 is not set
CONFIG_SENSORS_MCP3021=m
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
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
# CONFIG_SENSORS_OCC_P8_I2C is not set
# CONFIG_SENSORS_OXP is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC2305 is not set
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
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_ACPI=y
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
CONFIG_INTEL_TCC=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
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
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ADVANTECH_EC_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
# CONFIG_EXAR_WDT is not set
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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_SMPRO is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
CONFIG_MFD_CROS_EC_DEV=m
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
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
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
# CONFIG_MFD_MT6370 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_OCELOT is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RT5120 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
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
# CONFIG_MFD_INTEL_M10_BMC_SPI is not set
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

CONFIG_MEDIA_HIDE_ANCILLARY_SUBDRV=y

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_VIDEO_CMDLINE=y
CONFIG_VIDEO_NOMODESET=y
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_KUNIT_TEST_HELPERS=m
CONFIG_DRM_KUNIT_TEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
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
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
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
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_VIRTIO_GPU_KMS=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_AUO_A030JTN01 is not set
# CONFIG_DRM_PANEL_ORISETECH_OTA5601A is not set
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
# CONFIG_DRM_HYPERV is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
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
CONFIG_FB_HYPERV=m
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
# CONFIG_BACKLIGHT_KTZ8866 is not set
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

# CONFIG_DRM_ACCEL is not set
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
# CONFIG_SND_OSSEMUL is not set
CONFIG_SND_PCM_TIMER=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_CTL_FAST_LOOKUP=y
# CONFIG_SND_DEBUG is not set
# CONFIG_SND_CTL_INPUT_VALIDATION is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SE6X is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_SCODEC_CS35L41_I2C is not set
# CONFIG_SND_HDA_SCODEC_CS35L41_SPI is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CS8409 is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
# CONFIG_SND_HDA_GENERIC is not set
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
CONFIG_SND_INTEL_SOUNDWIRE_ACPI=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_BCD2000 is not set
# CONFIG_SND_USB_POD is not set
# CONFIG_SND_USB_PODHD is not set
# CONFIG_SND_USB_TONEPORT is not set
# CONFIG_SND_USB_VARIAX is not set
CONFIG_SND_FIREWIRE=y
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
# CONFIG_SND_ISIGHT is not set
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
# CONFIG_SND_SOC_TOPOLOGY_KUNIT_TEST is not set
CONFIG_SND_SOC_UTILS_KUNIT_TEST=m
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_SOC_AMD_RENOIR is not set
# CONFIG_SND_SOC_AMD_ACP5x is not set
# CONFIG_SND_SOC_AMD_ACP6x is not set
# CONFIG_SND_AMD_ACP_CONFIG is not set
# CONFIG_SND_SOC_AMD_ACP_COMMON is not set
# CONFIG_SND_SOC_AMD_RPL_ACP6x is not set
# CONFIG_SND_SOC_AMD_PS is not set
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_BCM63XX_I2S_WHISTLER is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_FSL_XCVR is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
# CONFIG_SND_SOC_INTEL_CATPT is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
# CONFIG_SND_SOC_INTEL_SKYLAKE is not set
# CONFIG_SND_SOC_INTEL_SKL is not set
# CONFIG_SND_SOC_INTEL_APL is not set
# CONFIG_SND_SOC_INTEL_KBL is not set
# CONFIG_SND_SOC_INTEL_GLK is not set
# CONFIG_SND_SOC_INTEL_CNL is not set
# CONFIG_SND_SOC_INTEL_CFL is not set
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_INTEL_AVS=m

#
# Intel AVS Machine drivers
#

#
# Available DSP configurations
#
# CONFIG_SND_SOC_INTEL_AVS_MACH_DA7219 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DMIC is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_HDAUDIO is not set
CONFIG_SND_SOC_INTEL_AVS_MACH_I2S_TEST=m
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98927 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98357A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98373 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_NAU8825 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PROBE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT274 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT286 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT298 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5682 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_SSM4567 is not set
# end of Intel AVS Machine drivers

CONFIG_SND_SOC_INTEL_MACH=y
# CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES is not set
# CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH is not set
# CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH is not set
# CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH is not set
# CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH is not set
# CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH is not set
# CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH is not set
# CONFIG_SND_SOC_MTK_BTCVSD is not set
# CONFIG_SND_SOC_SOF_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1372_I2C is not set
# CONFIG_SND_SOC_ADAU1372_SPI is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4375 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_AW8738 is not set
# CONFIG_SND_SOC_AW88395 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CROS_EC_CODEC is not set
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
# CONFIG_SND_SOC_CS35L41_SPI is not set
# CONFIG_SND_SOC_CS35L41_I2C is not set
# CONFIG_SND_SOC_CS35L45_SPI is not set
# CONFIG_SND_SOC_CS35L45_I2C is not set
# CONFIG_SND_SOC_CS35L56_I2C is not set
# CONFIG_SND_SOC_CS35L56_SPI is not set
# CONFIG_SND_SOC_CS42L42 is not set
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS42L83 is not set
# CONFIG_SND_SOC_CS4234 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CX2072X is not set
# CONFIG_SND_SOC_DA7213 is not set
# CONFIG_SND_SOC_DMIC is not set
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
# CONFIG_SND_SOC_ES8316 is not set
# CONFIG_SND_SOC_ES8326 is not set
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDA=m
# CONFIG_SND_SOC_ICS43432 is not set
# CONFIG_SND_SOC_IDT821034 is not set
# CONFIG_SND_SOC_INNO_RK3036 is not set
# CONFIG_SND_SOC_MAX98088 is not set
# CONFIG_SND_SOC_MAX98090 is not set
# CONFIG_SND_SOC_MAX98357A is not set
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
# CONFIG_SND_SOC_MAX98927 is not set
# CONFIG_SND_SOC_MAX98520 is not set
# CONFIG_SND_SOC_MAX98373_I2C is not set
# CONFIG_SND_SOC_MAX98390 is not set
# CONFIG_SND_SOC_MAX98396 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM5102A is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_PEB2466 is not set
# CONFIG_SND_SOC_RK3328 is not set
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
# CONFIG_SND_SOC_RT5640 is not set
# CONFIG_SND_SOC_RT5659 is not set
# CONFIG_SND_SOC_RT9120 is not set
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIMPLE_MUX is not set
# CONFIG_SND_SOC_SMA1303 is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SRC4XXX_I2C is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2518 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
# CONFIG_SND_SOC_SSM4567 is not set
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2764 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS2780 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS5805M is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TFA989X is not set
# CONFIG_SND_SOC_TLV320ADC3XXX is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
# CONFIG_SND_SOC_TLV320AIC3X_SPI is not set
# CONFIG_SND_SOC_TLV320ADCX140 is not set
# CONFIG_SND_SOC_TS3A227E is not set
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731_I2C is not set
# CONFIG_SND_SOC_WM8731_SPI is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
# CONFIG_SND_SOC_WM8804_I2C is not set
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8940 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8961 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_ZL38060 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
# CONFIG_SND_SOC_NAU8315 is not set
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
# CONFIG_SND_SOC_NAU8821 is not set
# CONFIG_SND_SOC_NAU8822 is not set
# CONFIG_SND_SOC_NAU8824 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
# CONFIG_SND_SOC_LPASS_WSA_MACRO is not set
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
# CONFIG_SND_SOC_LPASS_TX_MACRO is not set
# end of CODEC drivers

# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=y
# CONFIG_HDMI_LPE_AUDIO is not set
# CONFIG_SND_VIRTIO is not set
CONFIG_HID_SUPPORT=y
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
# CONFIG_HID_PRODIKEYS is not set
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
# CONFIG_HID_EVISION is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GOOGLE_HAMMER is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
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
# CONFIG_HID_PXRC is not set
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
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_TOPRE is not set
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
CONFIG_HID_KUNIT_TEST=m
# end of Special HID drivers

#
# HID-BPF support
#
# CONFIG_HID_BPF is not set
# end of HID-BPF support

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

CONFIG_I2C_HID=m
# CONFIG_I2C_HID_ACPI is not set
# CONFIG_I2C_HID_OF is not set

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support

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
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
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

#
# USB dual-mode controller drivers
#
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
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
# CONFIG_TYPEC_MUX_GPIO_SBU is not set
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
# CONFIG_LEDS_BD2606MVV is not set
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
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
# CONFIG_LEDS_TRIGGER_AUDIO is not set
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
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
CONFIG_RTC_LIB_KUNIT_TEST=m
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
# CONFIG_RTC_DRV_CROS_EC is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
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
# CONFIG_XILINX_XDMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
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
# CONFIG_UIO is not set
CONFIG_VFIO=m
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_VIRQFD=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
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
CONFIG_VHOST_TASK=y
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_HYPERV_VTL_MODE is not set
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_ACPI is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_CHROMEOS_PSTORE is not set
# CONFIG_CHROMEOS_TBMC is not set
CONFIG_CROS_EC=m
# CONFIG_CROS_EC_I2C is not set
# CONFIG_CROS_EC_SPI is not set
# CONFIG_CROS_EC_LPC is not set
CONFIG_CROS_EC_PROTO=y
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
CONFIG_CROS_EC_CHARDEV=m
CONFIG_CROS_EC_LIGHTBAR=m
CONFIG_CROS_EC_DEBUGFS=m
CONFIG_CROS_EC_SENSORHUB=m
CONFIG_CROS_EC_SYSFS=m
# CONFIG_CROS_HPS_I2C is not set
CONFIG_CROS_USBPD_NOTIFY=m
# CONFIG_CHROMEOS_PRIVACY_SCREEN is not set
CONFIG_CROS_TYPEC_SWITCH=m
CONFIG_CROS_KUNIT=m
# CONFIG_MELLANOX_PLATFORM is not set
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
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMF is not set
# CONFIG_AMD_PMC is not set
# CONFIG_AMD_HSMP is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
# CONFIG_ASUS_WMI is not set
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_X86_PLATFORM_DRIVERS_HP is not set
# CONFIG_WIRELESS_HOTKEY is not set
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_LENOVO_YMC is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_THINKPAD_LMI is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_IFS is not set
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
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_VSEC is not set
# CONFIG_MSI_EC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
# CONFIG_ACPI_TOSHIBA is not set
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
CONFIG_CLK_KUNIT_TEST=m
CONFIG_CLK_GATE_KUNIT_TEST=m
# CONFIG_HWSPINLOCK is not set

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
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_PERF_EVENTS=y
CONFIG_IOMMUFD=m
CONFIG_IOMMUFD_TEST=y
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y
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

# CONFIG_WPCM450_SOC is not set

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
CONFIG_IIO=m
# CONFIG_IIO_BUFFER is not set
# CONFIG_IIO_CONFIGFS is not set
# CONFIG_IIO_TRIGGER is not set
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL313_I2C is not set
# CONFIG_ADXL313_SPI is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL355_I2C is not set
# CONFIG_ADXL355_SPI is not set
# CONFIG_ADXL367_SPI is not set
# CONFIG_ADXL367_I2C is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_BMI088_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD06 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
# CONFIG_FXLS8962AF_I2C is not set
# CONFIG_FXLS8962AF_SPI is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_IIO_KX022A_SPI is not set
# CONFIG_IIO_KX022A_I2C is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MSA311 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_SCA3300 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD4130 is not set
# CONFIG_AD7091R5 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7280 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_ENVELOPE_DETECTOR is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX11205 is not set
# CONFIG_MAX11410 is not set
# CONFIG_MAX1241 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_RICHTEK_RTQ6056 is not set
# CONFIG_SD_ADC_MODULATOR is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS7924 is not set
# CONFIG_TI_ADS1100 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_ADS8344 is not set
# CONFIG_TI_ADS8688 is not set
# CONFIG_TI_ADS124S08 is not set
# CONFIG_TI_ADS131E08 is not set
# CONFIG_TI_LMP92064 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_TI_TSC2046 is not set
# CONFIG_VF610_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# CONFIG_AD74115 is not set
# CONFIG_AD74413R is not set
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
CONFIG_IIO_RESCALE=m
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# CONFIG_ADA4250 is not set
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_ATLAS_EZO_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SCD30_CORE is not set
# CONFIG_SCD4X is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SENSIRION_SGP40 is not set
# CONFIG_SPS30_I2C is not set
# CONFIG_SENSEAIR_SUNRISE_CO2 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

# CONFIG_IIO_CROS_EC_SENSORS_CORE is not set

#
# Hid Sensor IIO Common
#
# CONFIG_HID_SENSOR_IIO_COMMON is not set
# end of Hid Sensor IIO Common

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD3552R is not set
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_LTC2688 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5766 is not set
# CONFIG_AD5770R is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7293 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8801 is not set
# CONFIG_DPOT_DAC is not set
# CONFIG_DS4424 is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MAX5522 is not set
# CONFIG_MAX5821 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# CONFIG_VF610_DAC is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Filters
#
# CONFIG_ADMV8818 is not set
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# CONFIG_ADF4377 is not set
# CONFIG_ADMV1013 is not set
# CONFIG_ADMV1014 is not set
# CONFIG_ADMV4420 is not set
# CONFIG_ADRF6780 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS290 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
# CONFIG_HDC2010 is not set
# CONFIG_HID_SENSOR_HUMIDITY is not set
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16475 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_BOSCH_BNO055_I2C is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
# CONFIG_INV_ICM42600_SPI is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# CONFIG_IIO_ST_LSM9DS0 is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3010 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9960 is not set
# CONFIG_AS73211 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP002 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
# CONFIG_HID_SENSOR_ALS is not set
# CONFIG_HID_SENSOR_PROX is not set
# CONFIG_JSA1212 is not set
# CONFIG_ROHM_BU27034 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR501 is not set
# CONFIG_LTRF216A is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2591 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# CONFIG_TI_TMAG5273 is not set
# CONFIG_YAMAHA_YAS530 is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set
# end of Multiplexers

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set
# end of Inclinometer sensors

CONFIG_IIO_RESCALE_KUNIT_TEST=m
CONFIG_IIO_FORMAT_KUNIT_TEST=m

#
# Linear and angular position sensors
#
# CONFIG_HID_SENSOR_CUSTOM_INTEL_HINGE is not set
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5110 is not set
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
# CONFIG_HID_SENSOR_PRESS is not set
# CONFIG_HP03 is not set
# CONFIG_ICP10100 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_CROS_EC_MKBP_PROXIMITY is not set
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9310 is not set
# CONFIG_SX9324 is not set
# CONFIG_SX9360 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
# CONFIG_VL53L0X_I2C is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
# CONFIG_HID_SENSOR_TEMP is not set
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TMP117 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX30208 is not set
# CONFIG_MAX31856 is not set
# CONFIG_MAX31865 is not set
# end of Temperature sensors

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
# CONFIG_PWM_CROS_EC is not set
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
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
CONFIG_IDLE_INJECT=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
CONFIG_USB4=y
# CONFIG_USB4_DEBUGFS_WRITE is not set
CONFIG_USB4_KUNIT_TEST=y
# CONFIG_USB4_DMA_TEST is not set

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
CONFIG_NVDIMM_SECURITY_TEST=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_HMEM=m
CONFIG_DEV_DAX_CXL=m
CONFIG_DEV_DAX_HMEM_DEVICES=y
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# Layout Types
#
# CONFIG_NVMEM_LAYOUT_SL28_VPD is not set
# CONFIG_NVMEM_LAYOUT_ONIE_TLV is not set
# end of Layout Types

# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
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
CONFIG_LEGACY_DIRECT_IO=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_EXT4_KUNIT_TESTS=m
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_SUPPORT_ASCII_CI=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DRAIN_INTENTS=y
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_REPAIR is not set
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
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
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
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
CONFIG_NETFS_SUPPORT=m
# CONFIG_NETFS_STATS is not set
# CONFIG_FSCACHE is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
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
CONFIG_FAT_KUNIT_TEST=m
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
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_CHOICE_DECOMP_BY_MOUNT is not set
CONFIG_SQUASHFS_COMPILE_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI_PERCPU is not set
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
# CONFIG_MINIX_FS is not set
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
# CONFIG_NFSD_V2 is not set
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
CONFIG_RPCSEC_GSS_KRB5_CRYPTOSYSTEM=y
# CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_DES is not set
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA1=y
# CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_CAMELLIA is not set
# CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA2 is not set
# CONFIG_RPCSEC_GSS_KRB5_KUNIT_TEST is not set
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
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
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
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
# CONFIG_DLM is not set
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
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
CONFIG_SECURITY_APPARMOR_INTROSPECT_POLICY=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
CONFIG_SECURITY_APPARMOR_EXPORT_BINARY=y
CONFIG_SECURITY_APPARMOR_PARANOID_LOAD=y
CONFIG_SECURITY_APPARMOR_KUNIT_TEST=m
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
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
# CONFIG_INIT_STACK_NONE is not set
# CONFIG_INIT_STACK_ALL_PATTERN is not set
CONFIG_INIT_STACK_ALL_ZERO=y
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
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
# end of Crypto core or helper

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
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SM4_GENERIC is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_HCTR2 is not set
# CONFIG_CRYPTO_KEYWRAP is not set
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m
CONFIG_CRYPTO_ESSIV=m
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=m
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_POLY1305 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3_GENERIC is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_VMAC=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_XXHASH=m
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
# CONFIG_CRYPTO_CURVE25519_X86 is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
# CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64 is not set
CONFIG_CRYPTO_CHACHA20_X86_64=m
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
# CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
# end of Accelerated Cryptographic Algorithms for CPU (x86)

# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_FIPS_SIGNATURE_SELFTEST=y

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
CONFIG_LINEAR_RANGES=m
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=m
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
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
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
CONFIG_INTERVAL_TREE_SPAN_ITER=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=m
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
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
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
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
CONFIG_AS_HAS_NON_CONST_LEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_OBJTOOL=y
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
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
# CONFIG_PER_VMA_LOCK_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
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
CONFIG_KASAN_KUNIT_TEST=m
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
CONFIG_KFENCE=y
CONFIG_KFENCE_SAMPLE_INTERVAL=100
CONFIG_KFENCE_NUM_OBJECTS=255
# CONFIG_KFENCE_DEFERRABLE is not set
CONFIG_KFENCE_STRESS_TEST_FAULTS=0
CONFIG_KFENCE_KUNIT_TEST=m
CONFIG_HAVE_ARCH_KMSAN=y
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
# CONFIG_DEBUG_PREEMPT is not set

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

# CONFIG_NMI_CHECK_CPU is not set
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
CONFIG_DEBUG_MAPLE_TREE=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_CPU_STALL_CPUTIME is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_CGROUP_REF is not set
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
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_OBJTOOL_NOP_MCOUNT=y
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
CONFIG_FPROBE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
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
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
# CONFIG_USER_EVENTS is not set
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_FTRACE_SORT_STARTUP_TEST=y
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
CONFIG_KUNIT=y
CONFIG_KUNIT_DEBUGFS=y
# CONFIG_KUNIT_TEST is not set
# CONFIG_KUNIT_EXAMPLE_TEST is not set
CONFIG_KUNIT_ALL_TESTS=m
CONFIG_KUNIT_DEFAULT_ENABLED=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAULT_INJECTION_USERCOPY is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_FAULT_INJECTION_CONFIGFS is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_TEST_DHRY is not set
# CONFIG_LKDTM is not set
CONFIG_CPUMASK_KUNIT_TEST=m
CONFIG_TEST_LIST_SORT=m
CONFIG_TEST_MIN_HEAP=m
CONFIG_TEST_SORT=m
CONFIG_TEST_DIV64=m
# CONFIG_KPROBES_SANITY_TEST is not set
CONFIG_FPROBE_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=m
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
CONFIG_STRING_SELFTEST=m
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
CONFIG_TEST_PRINTF=m
CONFIG_TEST_SCANF=m
CONFIG_TEST_BITMAP=m
CONFIG_TEST_UUID=m
CONFIG_TEST_XARRAY=m
CONFIG_TEST_MAPLE_TREE=m
CONFIG_TEST_RHASHTABLE=m
CONFIG_TEST_IDA=m
# CONFIG_TEST_LKM is not set
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
CONFIG_BITFIELD_KUNIT=m
CONFIG_HASH_KUNIT_TEST=m
CONFIG_RESOURCE_KUNIT_TEST=m
CONFIG_SYSCTL_KUNIT_TEST=m
CONFIG_LIST_KUNIT_TEST=m
# CONFIG_HASHTABLE_KUNIT_TEST is not set
CONFIG_LINEAR_RANGES_TEST=m
CONFIG_CMDLINE_KUNIT_TEST=m
CONFIG_BITS_TEST=m
CONFIG_SLUB_KUNIT_TEST=m
CONFIG_RATIONAL_KUNIT_TEST=m
CONFIG_MEMCPY_KUNIT_TEST=m
# CONFIG_MEMCPY_SLOW_KUNIT_TEST is not set
CONFIG_IS_SIGNED_TYPE_KUNIT_TEST=m
CONFIG_OVERFLOW_KUNIT_TEST=m
CONFIG_STACKINIT_KUNIT_TEST=m
CONFIG_FORTIFY_KUNIT_TEST=m
CONFIG_HW_BREAKPOINT_KUNIT_TEST=y
CONFIG_STRSCPY_KUNIT_TEST=m
CONFIG_SIPHASH_KUNIT_TEST=m
CONFIG_TEST_UDELAY=m
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_DYNAMIC_DEBUG=m
# CONFIG_TEST_KMOD is not set
CONFIG_TEST_MEMCAT_P=m
CONFIG_TEST_LIVEPATCH=m
CONFIG_TEST_MEMINIT=m
CONFIG_TEST_HMM=m
CONFIG_TEST_FREE_PAGES=m
CONFIG_TEST_FPU=m
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--WlSHMmdA2LHDp38i
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='kunit'
	export testcase='kunit'
	export category='functional'
	export job_origin='kunit.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis'
	export queue='validate'
	export testbox='lkp-bdw-de1'
	export tbox_group='lkp-bdw-de1'
	export submit_id='648668c6a4336baa094895cc'
	export job_file='/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-43529-13huwyx-5.yaml'
	export id='40a3500f9259b89b81f79770ce676b15b768064f'
	export queuer_version='/zday/lkp'
	export model='Broadwell-DE'
	export nr_node=1
	export nr_cpu=16
	export memory='48G'
	export nr_hdd_partitions=1
	export nr_ssd_partitions=1
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BA800G4_BTHV410402GY800OGN-part2'
	export hdd_partitions='/dev/disk/by-id/ata-ST9500620NS_9XF26EB5-part1'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2BA800G4_BTHV410402GY800OGN-part1'
	export brand='Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz'
	export commit='5f4287fc4655b77bfb9012a7a0ed630d65d01695'
	export ucode='0x700001c'
	export need_kconfig_hw='{"PTP_1588_CLOCK"=>"y"}
{"IGB"=>"y"}
{"NETDEVICES"=>"y"}
{"ETHERNET"=>"y"}
{"NET_VENDOR_INTEL"=>"y"}
{"PCI"=>"y"}
SATA_AHCI
SATA_AHCI_PLATFORM
ATA
{"HAS_DMA"=>"y"}'
	export need_kconfig='{"STRING_SELFTEST"=>"m"}
{"TEST_DIV64"=>"m"}
{"TEST_BPF"=>"m"}
{"TEST_MIN_HEAP"=>"m"}
{"TEST_USER_COPY"=>"m"}
{"TEST_STATIC_KEYS"=>"m"}
{"TEST_SCANF"=>"m"}
{"TEST_PRINTF"=>"m"}
{"TEST_KSTRTOX"=>"m"}
{"TEST_STRING_HELPERS"=>"m"}
{"TEST_BITMAP"=>"m"}
{"TEST_UUID"=>"m"}
{"TEST_XARRAY"=>"m"}
{"TEST_OVERFLOW"=>"m"}
{"TEST_RHASHTABLE"=>"m"}
{"TEST_IDA"=>"m"}
{"TEST_MEMCAT_P"=>"m"}
{"TEST_UDELAY"=>"m"}
{"TEST_VMALLOC"=>"m"}
{"DYNAMIC_DEBUG"=>"y"}
{"DYNAMIC_FTRACE_WITH_REGS"=>"y"}
{"LIVEPATCH"=>"y"}
{"TEST_LIVEPATCH"=>"m"}
{"TEST_MEMINIT"=>"m"}
{"TRANSPARENT_HUGEPAGE"=>"y"}
{"MEMORY_HOTPLUG"=>"y"}
{"MEMORY_HOTREMOVE"=>"y"}
{"ZONE_DEVICE"=>"y"}
{"DEVICE_PRIVATE"=>"y"}
{"TEST_HMM"=>"m"}
{"TEST_FREE_PAGES"=>"m"}
{"KCOV_INSTRUMENT_ALL"=>"n"}
{"TEST_FPU"=>"m"}
{"TEST_BITOPS"=>"m"}
{"TEST_ASYNC_DRIVER_PROBE"=>"m"}
{"SPI"=>"y"}
{"SPI_MASTER"=>"y"}
{"SPI_LOOPBACK_TEST"=>"m"}
{"GLOB_SELFTEST"=>"m"}
{"CRC32"=>"y"}
{"CRC32_SELFTEST"=>"m"}
{"ATOMIC64_SELFTEST"=>"m"}
{"TEST_MAPLE_TREE"=>"m"}
{"SND"=>"m"}
{"SND_SOC"=>"m"}
{"SND_SOC_INTEL_AVS"=>"m"}
{"SND_SOC_INTEL_AVS_MACH_I2S_TEST"=>"m"}
{"KALLSYMS"=>"y"}
{"FUNCTION_TRACER"=>"y"}
{"DYNAMIC_FTRACE"=>"y"}
{"BUILDTIME_MCOUNT_SORT"=>"y"}
{"FTRACE_SORT_STARTUP_TEST"=>"y"}
{"PHYLIB"=>"y"}
{"INET"=>"y"}
{"NET_SELFTESTS"=>"y"}
{"ASYMMETRIC_KEY_TYPE"=>"y"}
ASYMMETRIC_PUBLIC_KEY_SUBTYPE
X509_CERTIFICATE_PARSER
PKCS7_MESSAGE_PARSER
{"FIPS_SIGNATURE_SELFTEST"=>"y"}
{"PCI"=>"y"}
CXL_BUS
{"SPARSEMEM"=>"y"}
{"CXL_REGION"=>"y"}
{"CXL_REGION_INVALIDATION_TEST"=>"y"}
{"DEBUG_KERNEL"=>"y"}
{"FAULT_INJECTION"=>"y"}
IOMMUFD
{"IOMMUFD_TEST"=>"y"}
{"BLOCK"=>"y"}
{"BLK_DEV"=>"y"}
{"PHYS_ADDR_T_64BIT"=>"y"}
LIBNVDIMM
{"KEYS"=>"y"}
ENCRYPTED_KEYS
{"NVDIMM_KEYS"=>"y"}
{"NVDIMM_SECURITY_TEST"=>"y"}
{"PROC_FS"=>"y"}
{"DEBUG_FS"=>"y"}
{"PRINTK"=>"y"}
{"DYNAMIC_DEBUG"=>"y"}
{"TEST_DYNAMIC_DEBUG"=>"m"}'
	export kconfig='x86_64-rhel-8.3-kunit'
	export enqueue_time='2023-06-12 08:37:26 +0800'
	export _id='648668dca4336baa094895cf'
	export _rt='/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695'
	export user='lkp'
	export compiler='gcc-12'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='12449fc3eb711d743a99cac5ddc28fbb8a6a4771'
	export base_commit='9561de3a55bed6bdd44a12820ba81ec416e705a7'
	export branch='linux-review/Richard-Weinberger/vsprintf-Warn-on-integer-scanning-overflows/20230608-064044'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export result_root='/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/2'
	export scheduler_version='/lkp/lkp/.src-20230611-212538'
	export arch='x86_64'
	export max_uptime=1200
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/2
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655
branch=linux-review/Richard-Weinberger/vsprintf-Warn-on-integer-scanning-overflows/20230608-064044
job=/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-43529-13huwyx-5.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3-kunit
commit=5f4287fc4655b77bfb9012a7a0ed630d65d01695
initcall_debug
nmi_watchdog=0
max_uptime=1200
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
earlyprintk=ttyS0,115200
systemd.log_level=err
console=ttyS0,115200
console=tty0
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20230406.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='4.20.0'
	export repeat_to=6
	export stop_repeat_if_found='dmesg.WARNING:at_lib/vsprintf.c:#vsscanf'
	export kbuild_queue_analysis=1
	export kernel='/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655'
	export dequeue_time='2023-06-12 08:38:36 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-43529-13huwyx-5.cgz'

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

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper kmemleak
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='group-01' $LKP_SRC/tests/wrapper kunit
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env group='group-01' $LKP_SRC/stats/wrapper kunit
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper kmemleak

	$LKP_SRC/stats/wrapper time kunit.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--WlSHMmdA2LHDp38i
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--WlSHMmdA2LHDp38i
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="kunit"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 6.4.0-rc1-00002-g5f4287fc4655 (kbuild@2976777e=
3e93) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2=
.40) #1 SMP PREEMPT_DYNAMIC Mon Jun 12 05:33:32 CST 2023
[    0.000000] Command line:  ip=3D::::lkp-bdw-de1::dhcp root=3D/dev/ram0 R=
ESULT_ROOT=3D/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510=
.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/=
2 BOOT_IMAGE=3D/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb90=
12a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655 branch=3Dlinux-r=
eview/Richard-Weinberger/vsprintf-Warn-on-integer-scanning-overflows/202306=
08-064044 job=3D/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-=
x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-43529=
-13huwyx-5.yaml user=3Dlkp ARCH=3Dx86_64 kconfig=3Dx86_64-rhel-8.3-kunit co=
mmit=3D5f4287fc4655b77bfb9012a7a0ed630d65d01695 initcall_debug nmi_watchdog=
=3D0 max_uptime=3D1200 LKP_SERVER=3Dinternal-lkp-server nokaslr selinux=3D0=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 net.ifnames=3D0 printk.devkmsg=3Don panic=3D-1 softlockup_panic=3D1 nmi_=
watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 drbd.mino=
r_count=3D8 earlyprintk=3DttyS0,115200
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 by=
tes, using 'standard' format.
[    0.000000] signal: max sigframe size: 1776
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009abff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000796e0fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000796e1000-0x00000000798affff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000798b0000-0x00000000799adfff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x00000000799ae000-0x0000000079e5efff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x0000000079e5f000-0x000000007bdb4fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000007bdb5000-0x000000007bdb5fff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x000000007bdb6000-0x000000007be3bfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000007be3c000-0x000000007bffffff] usabl=
e
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000c7fffffff] usabl=
e
[    0.000000] printk: bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/=
02/2016
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2100.095 MHz processor
[    0.001686] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.008832] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.015088] last_pfn =3D 0xc80000 max_arch_pfn =3D 0x400000000
[    0.021235] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT=
 =20
[    0.029631] last_pfn =3D 0x7c000 max_arch_pfn =3D 0x400000000
[    0.035462] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.041412] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.047305] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.077878] found SMP MP-table at [mem 0x000fd970-0x000fd97f]
[    0.084056]   mpc: fd670-fd8ec
[    0.087832] Using GB pages for direct mapping
[    0.095475] RAMDISK: [mem 0xc69bbe000-0xc7a3fffff]
[    0.100707] ACPI: Early table checksum verification disabled
[    0.107033] ACPI: RSDP 0x00000000000F0580 000024 (v02 SUPERM)
[    0.113444] ACPI: XSDT 0x00000000799FE0A0 0000BC (v01 SUPERM SMCI--MB 01=
072009 AMI  00010013)
[    0.122636] ACPI: FACP 0x0000000079A15CA0 00010C (v05 SUPERM SMCI--MB 01=
072009 AMI  00010013)
[    0.131825] ACPI: DSDT 0x00000000799FE1F0 017AAD (v02 SUPERM SMCI--MB 01=
072009 INTL 20091013)
[    0.141004] ACPI: FACS 0x0000000079E5DF80 000040
[    0.146289] ACPI: APIC 0x0000000079A15DB0 000138 (v03 SUPERM SMCI--MB 01=
072009 AMI  00010013)
[    0.155476] ACPI: FPDT 0x0000000079A15EE8 000044 (v01 SUPERM SMCI--MB 01=
072009 AMI  00010013)
[    0.164662] ACPI: FIDT 0x0000000079A15F30 00009C (v01 SUPERM SMCI--MB 01=
072009 AMI  00010013)
[    0.173848] ACPI: SPMI 0x0000000079A15FD0 000040 (v05 SUPERM SMCI--MB 00=
000000 AMI. 00000000)
[    0.183034] ACPI: MCFG 0x0000000079A16010 00003C (v01 SUPERM SMCI--MB 01=
072009 MSFT 00000097)
[    0.192221] ACPI: UEFI 0x0000000079A16050 000042 (v01                 00=
000000      00000000)
[    0.201406] ACPI: DBG2 0x0000000079A16098 000072 (v00 SUPERM SMCI--MB 00=
000000 INTL 20091013)
[    0.210592] ACPI: HPET 0x0000000079A16110 000038 (v01 SUPERM SMCI--MB 00=
000001 INTL 20091013)
[    0.219779] ACPI: WDDT 0x0000000079A16148 000040 (v01 SUPERM SMCI--MB 00=
000000 INTL 20091013)
[    0.228964] ACPI: SSDT 0x0000000079A16188 00ED8B (v01 AMI    PmMgt    00=
000001 INTL 20120913)
[    0.238150] ACPI: SSDT 0x0000000079A24F18 002285 (v02 SUPERM SpsNm    00=
000002 INTL 20120913)
[    0.247338] ACPI: SSDT 0x0000000079A271A0 000064 (v02 SUPERM SpsNvs   00=
000002 INTL 20120913)
[    0.256524] ACPI: PRAD 0x0000000079A27208 000102 (v02 SUPERM SMCI--MB 00=
000002 INTL 20120913)
[    0.265711] ACPI: DMAR 0x0000000079A27310 0000C4 (v01 SUPERM SMCI--MB 00=
000001 INTL 20091013)
[    0.274896] ACPI: HEST 0x0000000079A273D8 0000A8 (v01 SUPERM SMCI--MB 00=
000001 INTL 00000001)
[    0.284081] ACPI: BERT 0x0000000079A27480 000030 (v01 SUPERM SMCI--MB 00=
000001 INTL 00000001)
[    0.293267] ACPI: ERST 0x0000000079A274B0 000230 (v01 SUPERM SMCI--MB 00=
000001 INTL 00000001)
[    0.302455] ACPI: EINJ 0x0000000079A276E0 000130 (v01 SUPERM SMCI--MB 00=
000001 INTL 00000001)
[    0.311638] ACPI: Reserving FACP table memory at [mem 0x79a15ca0-0x79a15=
dab]
[    0.319350] ACPI: Reserving DSDT table memory at [mem 0x799fe1f0-0x79a15=
c9c]
[    0.327063] ACPI: Reserving FACS table memory at [mem 0x79e5df80-0x79e5d=
fbf]
[    0.334776] ACPI: Reserving APIC table memory at [mem 0x79a15db0-0x79a15=
ee7]
[    0.342488] ACPI: Reserving FPDT table memory at [mem 0x79a15ee8-0x79a15=
f2b]
[    0.350201] ACPI: Reserving FIDT table memory at [mem 0x79a15f30-0x79a15=
fcb]
[    0.357914] ACPI: Reserving SPMI table memory at [mem 0x79a15fd0-0x79a16=
00f]
[    0.365627] ACPI: Reserving MCFG table memory at [mem 0x79a16010-0x79a16=
04b]
[    0.373340] ACPI: Reserving UEFI table memory at [mem 0x79a16050-0x79a16=
091]
[    0.381053] ACPI: Reserving DBG2 table memory at [mem 0x79a16098-0x79a16=
109]
[    0.388766] ACPI: Reserving HPET table memory at [mem 0x79a16110-0x79a16=
147]
[    0.396479] ACPI: Reserving WDDT table memory at [mem 0x79a16148-0x79a16=
187]
[    0.404192] ACPI: Reserving SSDT table memory at [mem 0x79a16188-0x79a24=
f12]
[    0.411906] ACPI: Reserving SSDT table memory at [mem 0x79a24f18-0x79a27=
19c]
[    0.419617] ACPI: Reserving SSDT table memory at [mem 0x79a271a0-0x79a27=
203]
[    0.427330] ACPI: Reserving PRAD table memory at [mem 0x79a27208-0x79a27=
309]
[    0.435044] ACPI: Reserving DMAR table memory at [mem 0x79a27310-0x79a27=
3d3]
[    0.442757] ACPI: Reserving HEST table memory at [mem 0x79a273d8-0x79a27=
47f]
[    0.450470] ACPI: Reserving BERT table memory at [mem 0x79a27480-0x79a27=
4af]
[    0.458182] ACPI: Reserving ERST table memory at [mem 0x79a274b0-0x79a27=
6df]
[    0.465895] ACPI: Reserving EINJ table memory at [mem 0x79a276e0-0x79a27=
80f]
[    0.473641] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.480466] No NUMA configuration found
[    0.484736] Faking a node at [mem 0x0000000000000000-0x0000000c7fffffff]
[    0.492144] NODE_DATA(0) allocated [mem 0xc7ffd5000-0xc7fffffff]
[    0.499942] Zone ranges:
[    0.502908]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.509755]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.516600]   Normal   [mem 0x0000000100000000-0x0000000c7fffffff]
[    0.523447]   Device   empty
[    0.526999] Movable zone start for each node
[    0.531950] Early memory node ranges
[    0.536187]   node   0: [mem 0x0000000000001000-0x0000000000099fff]
[    0.543119]   node   0: [mem 0x0000000000100000-0x00000000796e0fff]
[    0.550053]   node   0: [mem 0x00000000798b0000-0x00000000799adfff]
[    0.556986]   node   0: [mem 0x000000007bdb5000-0x000000007bdb5fff]
[    0.563918]   node   0: [mem 0x000000007be3c000-0x000000007bffffff]
[    0.570850]   node   0: [mem 0x0000000100000000-0x0000000c7fffffff]
[    0.577801] Initmem setup node 0 [mem 0x0000000000001000-0x0000000c7ffff=
fff]
[    0.585521] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.585931] On node 0, zone DMA: 102 pages in unavailable ranges
[    0.642272] On node 0, zone DMA32: 463 pages in unavailable ranges
[    0.649880] On node 0, zone DMA32: 9223 pages in unavailable ranges
[    0.656558] On node 0, zone DMA32: 134 pages in unavailable ranges
[    0.668946] On node 0, zone Normal: 16384 pages in unavailable ranges
[    2.001810] kasan: KernelAddressSanitizer initialized
[    2.014619] ACPI: PM-Timer IO Port: 0x408
[    2.019112] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    2.025760] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    2.032432] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    2.039105] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    2.045779] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    2.052451] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    2.059124] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    2.065797] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    2.072470] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    2.079143] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    2.085816] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    2.092489] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    2.099163] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    2.105836] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    2.112508] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    2.119180] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    2.125868] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-=
23
[    2.133399] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24=
-47
[    2.141024] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    2.148042] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC =
INT 02
[    2.155926] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    2.163205] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC =
INT 09
[    2.171094] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC =
INT 01
[    2.178979] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC =
INT 03
[    2.186865] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC =
INT 04
[    2.194751] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC =
INT 05
[    2.202637] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC =
INT 06
[    2.210524] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC =
INT 07
[    2.218410] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC =
INT 08
[    2.226296] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC =
INT 0a
[    2.234183] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC =
INT 0b
[    2.242070] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC =
INT 0c
[    2.249955] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC =
INT 0d
[    2.257842] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC =
INT 0e
[    2.265728] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC =
INT 0f
[    2.273620] ACPI: Using ACPI (MADT) for SMP configuration information
[    2.280723] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    2.286540] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please =
update microcode to version: 0x700000e (or later)
[    2.298138] smpboot: Allowing 16 CPUs, 0 hotplug CPUs
[    2.303867] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    2.309839] mapped IOAPIC to ffffffffff5fa000 (fec01000)
[    2.315882] PM: hibernation: Registered nosave memory: [mem 0x00000000-0=
x00000fff]
[    2.324055] PM: hibernation: Registered nosave memory: [mem 0x0009a000-0=
x0009afff]
[    2.332283] PM: hibernation: Registered nosave memory: [mem 0x0009b000-0=
x0009ffff]
[    2.340516] PM: hibernation: Registered nosave memory: [mem 0x000a0000-0=
x000dffff]
[    2.348749] PM: hibernation: Registered nosave memory: [mem 0x000e0000-0=
x000fffff]
[    2.356986] PM: hibernation: Registered nosave memory: [mem 0x796e1000-0=
x798affff]
[    2.365220] PM: hibernation: Registered nosave memory: [mem 0x799ae000-0=
x79e5efff]
[    2.373448] PM: hibernation: Registered nosave memory: [mem 0x79e5f000-0=
x7bdb4fff]
[    2.381684] PM: hibernation: Registered nosave memory: [mem 0x7bdb6000-0=
x7be3bfff]
[    2.389918] PM: hibernation: Registered nosave memory: [mem 0x7c000000-0=
x7fffffff]
[    2.398147] PM: hibernation: Registered nosave memory: [mem 0x80000000-0=
x8fffffff]
[    2.406378] PM: hibernation: Registered nosave memory: [mem 0x90000000-0=
xfed1bfff]
[    2.414612] PM: hibernation: Registered nosave memory: [mem 0xfed1c000-0=
xfed1ffff]
[    2.422844] PM: hibernation: Registered nosave memory: [mem 0xfed20000-0=
xfeffffff]
[    2.431078] PM: hibernation: Registered nosave memory: [mem 0xff000000-0=
xffffffff]
[    2.439314] [mem 0x90000000-0xfed1bfff] available for PCI devices
[    2.446071] Booting paravirtualized kernel on bare hardware
[    2.452313] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 1910969940391419 ns
[    2.531814] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:16 nr_cpu_ids:16 =
nr_node_ids:1
[    2.543139] percpu: Embedded 69 pages/cpu s244136 r8192 d30296 u524288
[    2.550126] pcpu-alloc: s244136 r8192 d30296 u524288 alloc=3D1*2097152
[    2.557119] pcpu-alloc: [0] 00 01 02 03 [0] 04 05 06 07=20
[    2.563099] pcpu-alloc: [0] 08 09 10 11 [0] 12 13 14 15=20
[    2.569195] Kernel command line:  ip=3D::::lkp-bdw-de1::dhcp root=3D/dev=
/ram0 RESULT_ROOT=3D/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-2=
0220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65=
d01695/2 BOOT_IMAGE=3D/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b=
77bfb9012a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655 branch=3D=
linux-review/Richard-Weinberger/vsprintf-Warn-on-integer-scanning-overflows=
/20230608-064044 job=3D/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debia=
n-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-2023061=
2-43529-13huwyx-5.yaml user=3Dlkp ARCH=3Dx86_64 kconfig=3Dx86_64-rhel-8.3-k=
unit commit=3D5f4287fc4655b77bfb9012a7a0ed630d65d01695 initcall_debug nmi_w=
atchdog=3D0 max_uptime=3D1200 LKP_SERVER=3Dinternal-lkp-server nokaslr seli=
nux=3D0 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 net.ifnames=3D0 printk.devkmsg=3Don panic=3D-1 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 =
drbd.minor_count=3D8 earlyprintk=3DttyS0
[    2.570253] sysrq: sysrq always enabled.
[    2.665634] ignoring the deprecated load_ramdisk=3D option
[    2.671781] Unknown kernel command line parameters "nokaslr RESULT_ROOT=
=3D/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_6=
4-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/2 BOOT_IMA=
GE=3D/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed63=
0d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655 branch=3Dlinux-review/Rich=
ard-Weinberger/vsprintf-Warn-on-integer-scanning-overflows/20230608-064044 =
job=3D/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-202=
20510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-43529-13huwyx-5=
.yaml user=3Dlkp ARCH=3Dx86_64 kconfig=3Dx86_64-rhel-8.3-kunit commit=3D5f4=
287fc4655b77bfb9012a7a0ed630d65d01695 max_uptime=3D1200 LKP_SERVER=3Dintern=
al-lkp-server softlockup_panic=3D1 prompt_ramdisk=3D0", will be passed to u=
ser space.
[    2.742711] random: crng init done
[    2.760747] Dentry cache hash table entries: 8388608 (order: 14, 6710886=
4 bytes, linear)
[    2.776265] Inode-cache hash table entries: 4194304 (order: 13, 33554432=
 bytes, linear)
[    2.786451] Fallback order for Node 0: 0=20
[    2.786470] Built 1 zonelists, mobility grouping on.  Total pages: 12360=
253
[    2.798543] Policy zone: Normal
[    2.802803] mem auto-init: stack:all(zero), heap alloc:off, heap free:of=
f
[    2.810025] stackdepot: allocating hash table via alloc_large_system_has=
h
[    2.819267] stackdepot hash table entries: 1048576 (order: 11, 8388608 b=
ytes, linear)
[    2.827545] software IO TLB: area num 16.
[    3.691513] Memory: 2056592K/50226420K available (47104K kernel code, 14=
607K rwdata, 9556K rodata, 3452K init, 8648K bss, 7619972K reserved, 0K cma=
-reserved)
[    3.708756] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D16, =
Nodes=3D1
[    3.716383] Kernel/User page tables isolation: enabled
[    3.725863] ftrace: allocating 50739 entries in 199 pages
[    3.732271] ftrace section at ffffffff860b4bb8 sorted properly
[    3.772078] ftrace: allocated 199 pages with 5 groups
[    3.783881] Dynamic Preempt: voluntary
[    3.791039] rcu: Preemptible hierarchical RCU implementation.
[    3.797218] rcu: 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=
=3D16.
[    3.804759] 	RCU CPU stall warnings timeout set to 100 (rcu_cpu_stall_ti=
meout).
[    3.812730] 	Trampoline variant of Tasks RCU enabled.
[    3.818450] 	Rude variant of Tasks RCU enabled.
[    3.823649] 	Tracing variant of Tasks RCU enabled.
[    3.829109] rcu: RCU calculated value of scheduler-enlistment delay is 1=
00 jiffies.
[    3.837429] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D16
[    3.961640] NR_IRQS: 524544, nr_irqs: 960, preallocated irqs: 16
[    3.971670] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    3.979272] kfence: initialized - using 2097152 bytes for 255 objects at=
 0x(____ptrval____)-0x(____ptrval____)
[    3.992231] calling  con_init+0x0/0x6f0 @ 0
[    3.998881] Console: colour VGA+ 80x25
[    4.003073] printk: console [tty0] enabled
[    4.007833] printk: bootconsole [earlyser0] disabled
[    4.013475] initcall con_init+0x0/0x6f0 returned 0 after 0 usecs
[    4.013591] calling  hvc_console_init+0x0/0x20 @ 0
[    4.013704] initcall hvc_console_init+0x0/0x20 returned 0 after 0 usecs
[    4.013838] calling  univ8250_console_init+0x0/0x30 @ 0
[    4.013977] printk: console [ttyS0] enabled
[    5.826636] initcall univ8250_console_init+0x0/0x30 returned 0 after 0 u=
secs
[    5.835903] ACPI: Core revision 20230331
[    5.843805] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 133484882848 ns
[    5.853840] APIC: Switch to symmetric I/O mode setup
[    5.859623] DMAR: Host address width 46
[    5.864267] DMAR: DRHD base: 0x000000fbffc000 flags: 0x1
[    5.870584] DMAR: dmar0: reg_base_addr fbffc000 ver 1:0 cap 8d2078c106f0=
466 ecap f020de
[    5.879427] DMAR: RMRR base: 0x0000007bb28000 end: 0x0000007bb36fff
[    5.886555] DMAR: ATSR flags: 0x0
[    5.890721] DMAR: RHSA base: 0x000000fbffc000 proximity domain: 0x0
[    5.897810] DMAR-IR: IOAPIC id 8 under DRHD base  0xfbffc000 IOMMU 0
[    5.904975] DMAR-IR: IOAPIC id 9 under DRHD base  0xfbffc000 IOMMU 0
[    5.912131] DMAR-IR: HPET id 0 under DRHD base 0xfbffc000
[    5.918335] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt out=
 bit.
[    5.918340] DMAR-IR: Use 'intremap=3Dno_x2apic_optout' to override the B=
IOS setting.
[    5.935498] DMAR-IR: IRQ remapping was enabled on dmar0 but we are not i=
n kdump mode
[    5.944180] DMAR-IR: Enabled IRQ remapping in xapic mode
[    5.950286] x2apic: IRQ remapping doesn't support X2APIC mode
[    5.956843] Switched APIC routing to physical flat.
[    5.962529] masked ExtINT on CPU#0
[    5.967548] ENABLING IO-APIC IRQs
[    5.971813] init IO_APIC IRQs
[    5.975576]  apic 8 pin 0 not connected
[    5.980319] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    5.994664] IOAPIC[0]: Preconfigured routing entry (8-1 -> IRQ 1 Level:0=
 ActiveLow:0)
[    6.003416] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:30 Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.017763] IOAPIC[0]: Preconfigured routing entry (8-2 -> IRQ 0 Level:0=
 ActiveLow:0)
[    6.026566] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.040905] IOAPIC[0]: Preconfigured routing entry (8-3 -> IRQ 3 Level:0=
 ActiveLow:0)
[    6.049679] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.064017] IOAPIC[0]: Preconfigured routing entry (8-4 -> IRQ 4 Level:0=
 ActiveLow:0)
[    6.072794] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.087128] IOAPIC[0]: Preconfigured routing entry (8-5 -> IRQ 5 Level:0=
 ActiveLow:0)
[    6.095948] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.110286] IOAPIC[0]: Preconfigured routing entry (8-6 -> IRQ 6 Level:0=
 ActiveLow:0)
[    6.119063] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.133397] IOAPIC[0]: Preconfigured routing entry (8-7 -> IRQ 7 Level:0=
 ActiveLow:0)
[    6.142175] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.156509] IOAPIC[0]: Preconfigured routing entry (8-8 -> IRQ 8 Level:0=
 ActiveLow:0)
[    6.165286] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.179623] IOAPIC[0]: Preconfigured routing entry (8-9 -> IRQ 9 Level:1=
 ActiveLow:0)
[    6.188423] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.202768] IOAPIC[0]: Preconfigured routing entry (8-10 -> IRQ 10 Level=
:0 ActiveLow:0)
[    6.211723] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.226058] IOAPIC[0]: Preconfigured routing entry (8-11 -> IRQ 11 Level=
:0 ActiveLow:0)
[    6.235008] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.249343] IOAPIC[0]: Preconfigured routing entry (8-12 -> IRQ 12 Level=
:0 ActiveLow:0)
[    6.258292] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.272628] IOAPIC[0]: Preconfigured routing entry (8-13 -> IRQ 13 Level=
:0 ActiveLow:0)
[    6.281599] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.295931] IOAPIC[0]: Preconfigured routing entry (8-14 -> IRQ 14 Level=
:0 ActiveLow:0)
[    6.304890] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[    6.319227] IOAPIC[0]: Preconfigured routing entry (8-15 -> IRQ 15 Level=
:0 ActiveLow:0)
[    6.328084]  apic 8 pin 16 not connected
[    6.332804]  apic 8 pin 17 not connected
[    6.337519]  apic 8 pin 18 not connected
[    6.342233]  apic 8 pin 19 not connected
[    6.346948]  apic 8 pin 20 not connected
[    6.351660]  apic 8 pin 21 not connected
[    6.356374]  apic 8 pin 22 not connected
[    6.361089]  apic 8 pin 23 not connected
[    6.365804]  apic 9 pin 0 not connected
[    6.370432]  apic 9 pin 1 not connected
[    6.375060]  apic 9 pin 2 not connected
[    6.379688]  apic 9 pin 3 not connected
[    6.384314]  apic 9 pin 4 not connected
[    6.388942]  apic 9 pin 5 not connected
[    6.393570]  apic 9 pin 6 not connected
[    6.398199]  apic 9 pin 7 not connected
[    6.402826]  apic 9 pin 8 not connected
[    6.407455]  apic 9 pin 9 not connected
[    6.412083]  apic 9 pin 10 not connected
[    6.416797]  apic 9 pin 11 not connected
[    6.421512]  apic 9 pin 12 not connected
[    6.426223]  apic 9 pin 13 not connected
[    6.430938]  apic 9 pin 14 not connected
[    6.435652]  apic 9 pin 15 not connected
[    6.440367]  apic 9 pin 16 not connected
[    6.445081]  apic 9 pin 17 not connected
[    6.449798]  apic 9 pin 18 not connected
[    6.454512]  apic 9 pin 19 not connected
[    6.459226]  apic 9 pin 20 not connected
[    6.463940]  apic 9 pin 21 not connected
[    6.468655]  apic 9 pin 22 not connected
[    6.473369]  apic 9 pin 23 not connected
[    6.478220] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    6.489749] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles:=
 0x1e458a5f268, max_idle_ns: 440795290373 ns
[    6.501111] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4200.19 BogoMIPS (lpj=3D2100095)
[    6.502107] pid_max: default: 32768 minimum: 301
[    6.506366] LSM: initializing lsm=3Dcapability,yama,apparmor,integrity
[    6.507389] Yama: becoming mindful.
[    6.508884] AppArmor: AppArmor initialized
[    6.512044] Mount-cache hash table entries: 131072 (order: 8, 1048576 by=
tes, linear)
[    6.513401] Mountpoint-cache hash table entries: 131072 (order: 8, 10485=
76 bytes, linear)
[    6.525596] CPU0: Thermal monitoring enabled (TM1)
[    6.526352] process: using mwait in idle threads
[    6.527117] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    6.528105] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    6.530116] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user=
 pointer sanitization
[    6.531124] Spectre V2 : Kernel not compiled with retpoline; no mitigati=
on available!
[    6.531130] Spectre V2 : Vulnerable
[    6.533105] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB=
 on context switch
[    6.534106] Speculative Store Bypass: Vulnerable
[    6.535140] MDS: Vulnerable: Clear CPU buffers attempted, no microcode
[    6.536105] TAA: Vulnerable: Clear CPU buffers attempted, no microcode
[    6.538105] MMIO Stale Data: Vulnerable: Clear CPU buffers attempted, no=
 microcode
[    6.548322] Freeing SMP alternatives memory: 44K
[    6.551581] Using local APIC timer interrupts.
               calibrating APIC timer ...
[    6.654294] ... lapic delta =3D 625028
[    6.655100] ... PM-Timer delta =3D 357971
[    6.655100] ... PM-Timer result ok
[    6.655100] ..... delta 625028
[    6.655100] ..... mult: 26843545
[    6.655100] ..... calibration result: 100004
[    6.655100] ..... CPU clock speed is 2100.0094 MHz.
[    6.655100] ..... host bus clock speed is 100.0004 MHz.
[    6.655113] smpboot: CPU0: Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz (family=
: 0x6, model: 0x56, stepping: 0x3)
[    6.660127] cblist_init_generic: Setting adjustable number of callback q=
ueues.
[    6.661106] cblist_init_generic: Setting shift to 4 and lim to 1.
[    6.663444] cblist_init_generic: Setting shift to 4 and lim to 1.
[    6.664427] cblist_init_generic: Setting shift to 4 and lim to 1.
[    6.665419] calling  init_hw_perf_events+0x0/0x730 @ 1
[    6.666108] Performance Events: PEBS fmt2+, Broadwell events, 16-deep LB=
R, full-width counters, Intel PMU driver.
[    6.668108] ... version:                3
[    6.669107] ... bit width:              48
[    6.671105] ... generic registers:      4
[    6.672105] ... value mask:             0000ffffffffffff
[    6.673105] ... max period:             00007fffffffffff
[    6.674105] ... fixed-purpose events:   3
[    6.675105] ... event mask:             000000070000000f
[    6.677608] initcall init_hw_perf_events+0x0/0x730 returned 0 after 1100=
0 usecs
[    6.678108] calling  do_init_real_mode+0x0/0x20 @ 1
[    6.679142] initcall do_init_real_mode+0x0/0x20 returned 0 after 0 usecs
[    6.680107] calling  trace_init_perf_perm_irq_work_exit+0x0/0x20 @ 1
[    6.682105] initcall trace_init_perf_perm_irq_work_exit+0x0/0x20 returne=
d 0 after 0 usecs
[    6.683106] calling  bp_init_aperfmperf+0x0/0xc0 @ 1
[    6.684154] Estimated ratio of average max frequency by base frequency (=
times 1024): 1267
[    6.686105] initcall bp_init_aperfmperf+0x0/0xc0 returned 0 after 2000 u=
secs
[    6.688105] calling  register_nmi_cpu_backtrace_handler+0x0/0x20 @ 1
[    6.689106] initcall register_nmi_cpu_backtrace_handler+0x0/0x20 returne=
d 0 after 0 usecs
[    6.691105] calling  kvm_setup_vsyscall_timeinfo+0x0/0xf0 @ 1
[    6.693106] initcall kvm_setup_vsyscall_timeinfo+0x0/0xf0 returned 0 aft=
er 0 usecs
[    6.694106] calling  spawn_ksoftirqd+0x0/0x40 @ 1
[    6.696482] initcall spawn_ksoftirqd+0x0/0x40 returned 0 after 0 usecs
[    6.697108] calling  migration_init+0x0/0xf0 @ 1
[    6.698107] initcall migration_init+0x0/0xf0 returned 0 after 0 usecs
[    6.699105] calling  srcu_bootup_announce+0x0/0x80 @ 1
[    6.701105] rcu: Hierarchical SRCU implementation.
[    6.702105] rcu: 	Max phase no-delay instances is 400.
[    6.703105] initcall srcu_bootup_announce+0x0/0x80 returned 0 after 2000=
 usecs
[    6.704105] calling  rcu_spawn_gp_kthread+0x0/0x3a0 @ 1
[    6.705624] initcall rcu_spawn_gp_kthread+0x0/0x3a0 returned 0 after 0 u=
secs
[    6.707106] calling  check_cpu_stall_init+0x0/0x20 @ 1
[    6.708105] initcall check_cpu_stall_init+0x0/0x20 returned 0 after 0 us=
ecs
[    6.709105] calling  rcu_sysrq_init+0x0/0x30 @ 1
[    6.710105] initcall rcu_sysrq_init+0x0/0x30 returned 0 after 0 usecs
[    6.711105] calling  trace_init_flags_sys_enter+0x0/0x20 @ 1
[    6.712105] initcall trace_init_flags_sys_enter+0x0/0x20 returned 0 afte=
r 0 usecs
[    6.713105] calling  trace_init_flags_sys_exit+0x0/0x20 @ 1
[    6.714104] initcall trace_init_flags_sys_exit+0x0/0x20 returned 0 after=
 0 usecs
[    6.715106] calling  cpu_stop_init+0x0/0x2c0 @ 1
[    6.716477] initcall cpu_stop_init+0x0/0x2c0 returned 0 after 0 usecs
[    6.717114] calling  init_kprobes+0x0/0x340 @ 1
[    6.723064] initcall init_kprobes+0x0/0x340 returned 0 after 4000 usecs
[    6.724106] calling  init_trace_printk+0x0/0x10 @ 1
[    6.725105] initcall init_trace_printk+0x0/0x10 returned 0 after 0 usecs
[    6.726105] calling  event_trace_enable_again+0x0/0xe0 @ 1
[    6.727105] initcall event_trace_enable_again+0x0/0xe0 returned 0 after =
0 usecs
[    6.729105] calling  irq_work_init_threads+0x0/0x10 @ 1
[    6.730105] initcall irq_work_init_threads+0x0/0x10 returned 0 after 0 u=
secs
[    6.731105] calling  static_call_init+0x0/0xa0 @ 1
[    6.733105] initcall static_call_init+0x0/0xa0 returned 0 after 0 usecs
[    6.734105] calling  jump_label_init_module+0x0/0x20 @ 1
[    6.735105] initcall jump_label_init_module+0x0/0x20 returned 0 after 0 =
usecs
[    6.736107] calling  init_zero_pfn+0x0/0xf0 @ 1
[    6.737105] initcall init_zero_pfn+0x0/0xf0 returned 0 after 0 usecs
[    6.738105] calling  init_fs_inode_sysctls+0x0/0x30 @ 1
[    6.739147] initcall init_fs_inode_sysctls+0x0/0x30 returned 0 after 0 u=
secs
[    6.740105] calling  init_fs_locks_sysctls+0x0/0x30 @ 1
[    6.741125] initcall init_fs_locks_sysctls+0x0/0x30 returned 0 after 0 u=
secs
[    6.742105] calling  init_fs_sysctls+0x0/0x20 @ 1
[    6.744143] initcall init_fs_sysctls+0x0/0x20 returned 0 after 1000 usec=
s
[    6.745113] calling  dynamic_debug_init+0x0/0x4c0 @ 1
[    6.750567] initcall dynamic_debug_init+0x0/0x4c0 returned 0 after 4000 =
usecs
[    6.751114] calling  efi_memreserve_root_init+0x0/0x50 @ 1
[    6.752106] initcall efi_memreserve_root_init+0x0/0x50 returned 0 after =
0 usecs
[    6.753105] calling  efi_earlycon_remap_fb+0x0/0x110 @ 1
[    6.755105] initcall efi_earlycon_remap_fb+0x0/0x110 returned 0 after 0 =
usecs
[    6.756105] calling  idle_inject_init+0x0/0x20 @ 1
[    6.758476] initcall idle_inject_init+0x0/0x20 returned 0 after 0 usecs
[    6.767859] smp: Bringing up secondary CPUs ...
[    6.770879] x86: Booting SMP configuration:
[    6.771144] .... node  #0, CPUs:        #1
[    2.499090] masked ExtINT on CPU#1
[    6.785139]   #2
[    2.499090] masked ExtINT on CPU#2
[    6.796451]   #3
[    2.499090] masked ExtINT on CPU#3
[    6.807691]   #4
[    2.499090] masked ExtINT on CPU#4
[    6.818893]   #5
[    2.499090] masked ExtINT on CPU#5
[    6.830151]   #6
[    2.499090] masked ExtINT on CPU#6
[    6.841473]   #7
[    2.499090] masked ExtINT on CPU#7
[    6.852751]   #8
[    2.499090] masked ExtINT on CPU#8
[    6.861390] MDS CPU bug present and SMT on, data leak possible. See http=
s://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more de=
tails.
[    6.862362] TAA CPU bug present and SMT on, data leak possible. See http=
s://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html=
 for more details.
[    6.863105] MMIO Stale Data CPU bug present and SMT on, data leak possib=
le. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processo=
r_mmio_stale_data.html for more details.
[    6.867469]   #9
[    2.499090] masked ExtINT on CPU#9
[    6.878548]  #10
[    2.499090] masked ExtINT on CPU#10
[    6.890022]  #11
[    2.499090] masked ExtINT on CPU#11
[    6.901432]  #12
[    2.499090] masked ExtINT on CPU#12
[    6.912778]  #13
[    2.499090] masked ExtINT on CPU#13
[    6.924074]  #14
[    2.499090] masked ExtINT on CPU#14
[    6.935448]  #15
[    2.499090] masked ExtINT on CPU#15
[    6.944146] smp: Brought up 1 node, 16 CPUs
[    6.945306] smpboot: Max logical packages: 1
[    6.946107] smpboot: Total of 16 processors activated (67203.04 BogoMIPS=
)
[    7.143591] node 0 deferred pages initialised in 179ms
[    7.159105] devtmpfs: initialized
[    7.162207] x86/mm: Memory block size: 128MB
[    7.409725] calling  bpf_jit_charge_init+0x0/0x50 @ 1
[    7.410114] initcall bpf_jit_charge_init+0x0/0x50 returned 0 after 0 use=
cs
[    7.411110] calling  ipc_ns_init+0x0/0x150 @ 1
[    7.412132] initcall ipc_ns_init+0x0/0x150 returned 0 after 0 usecs
[    7.413106] calling  init_mmap_min_addr+0x0/0x30 @ 1
[    7.414105] initcall init_mmap_min_addr+0x0/0x30 returned 0 after 0 usec=
s
[    7.415105] calling  pci_realloc_setup_params+0x0/0x50 @ 1
[    7.417108] initcall pci_realloc_setup_params+0x0/0x50 returned 0 after =
0 usecs
[    7.418105] calling  inet_frag_wq_init+0x0/0x50 @ 1
[    7.419400] initcall inet_frag_wq_init+0x0/0x50 returned 0 after 0 usecs
[    7.421260] calling  e820__register_nvs_regions+0x0/0x1d0 @ 1
[    7.422127] ACPI: PM: Registering ACPI NVS region [mem 0x799ae000-0x79e5=
efff] (4919296 bytes)
[    7.439614] initcall e820__register_nvs_regions+0x0/0x1d0 returned 0 aft=
er 17000 usecs
[    7.440107] calling  cpufreq_register_tsc_scaling+0x0/0x90 @ 1
[    7.441105] initcall cpufreq_register_tsc_scaling+0x0/0x90 returned 0 af=
ter 0 usecs
[    7.443106] calling  cache_ap_register+0x0/0x30 @ 1
[    7.445106] initcall cache_ap_register+0x0/0x30 returned 0 after 0 usecs
[    7.446107] calling  reboot_init+0x0/0xc0 @ 1
[    7.447118] initcall reboot_init+0x0/0xc0 returned 0 after 0 usecs
[    7.449105] calling  init_lapic_sysfs+0x0/0x50 @ 1
[    7.451106] initcall init_lapic_sysfs+0x0/0x50 returned 0 after 0 usecs
[    7.452106] calling  alloc_frozen_cpus+0x0/0x30 @ 1
[    7.454125] initcall alloc_frozen_cpus+0x0/0x30 returned 0 after 0 usecs
[    7.455105] calling  cpu_hotplug_pm_sync_init+0x0/0x20 @ 1
[    7.456107] initcall cpu_hotplug_pm_sync_init+0x0/0x20 returned 0 after =
0 usecs
[    7.457105] calling  wq_sysfs_init+0x0/0x60 @ 1
[    7.459613] initcall wq_sysfs_init+0x0/0x60 returned 0 after 1000 usecs
[    7.460112] calling  ksysfs_init+0x0/0xa0 @ 1
[    7.462389] initcall ksysfs_init+0x0/0xa0 returned 0 after 0 usecs
[    7.463106] calling  schedutil_gov_init+0x0/0x20 @ 1
[    7.464106] initcall schedutil_gov_init+0x0/0x20 returned 0 after 0 usec=
s
[    7.465106] calling  pm_init+0x0/0xd0 @ 1
[    7.467476] initcall pm_init+0x0/0xd0 returned 0 after 1000 usecs
[    7.468110] calling  pm_disk_init+0x0/0x50 @ 1
[    7.469200] initcall pm_disk_init+0x0/0x50 returned 0 after 0 usecs
[    7.470106] calling  swsusp_header_init+0x0/0x40 @ 1
[    7.471107] initcall swsusp_header_init+0x0/0x40 returned 0 after 0 usec=
s
[    7.472106] calling  rcu_set_runtime_mode+0x0/0x60 @ 1
[    7.473112] initcall rcu_set_runtime_mode+0x0/0x60 returned 0 after 0 us=
ecs
[    7.474105] calling  init_jiffies_clocksource+0x0/0x20 @ 1
[    7.475106] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 1911260446275000 ns
[    7.476108] initcall init_jiffies_clocksource+0x0/0x20 returned 0 after =
1000 usecs
[    7.477105] calling  futex_init+0x0/0x260 @ 1
[    7.478131] futex hash table entries: 4096 (order: 6, 262144 bytes, line=
ar)
[    7.479249] initcall futex_init+0x0/0x260 returned 0 after 1000 usecs
[    7.480106] calling  cgroup_wq_init+0x0/0x30 @ 1
[    7.482217] initcall cgroup_wq_init+0x0/0x30 returned 0 after 1000 usecs
[    7.483106] calling  cgroup1_wq_init+0x0/0x30 @ 1
[    7.484279] initcall cgroup1_wq_init+0x0/0x30 returned 0 after 0 usecs
[    7.485106] calling  ftrace_mod_cmd_init+0x0/0x10 @ 1
[    7.486107] initcall ftrace_mod_cmd_init+0x0/0x10 returned 0 after 0 use=
cs
[    7.487107] calling  init_wakeup_tracer+0x0/0x40 @ 1
[    7.488159] initcall init_wakeup_tracer+0x0/0x40 returned 0 after 0 usec=
s
[    7.489105] calling  init_graph_trace+0x0/0xa0 @ 1
[    7.490112] initcall init_graph_trace+0x0/0xa0 returned 0 after 0 usecs
[    7.491106] calling  trace_events_eprobe_init_early+0x0/0x30 @ 1
[    7.492106] initcall trace_events_eprobe_init_early+0x0/0x30 returned 0 =
after 0 usecs
[    7.493105] calling  trace_events_synth_init_early+0x0/0x30 @ 1
[    7.494106] initcall trace_events_synth_init_early+0x0/0x30 returned 0 a=
fter 0 usecs
[    7.496105] calling  init_kprobe_trace_early+0x0/0x30 @ 1
[    7.497107] initcall init_kprobe_trace_early+0x0/0x30 returned 0 after 0=
 usecs
[    7.498106] calling  kasan_memhotplug_init+0x0/0x20 @ 1
[    7.499106] initcall kasan_memhotplug_init+0x0/0x20 returned 0 after 0 u=
secs
[    7.500105] calling  memory_failure_init+0x0/0x350 @ 1
[    7.501107] initcall memory_failure_init+0x0/0x350 returned 0 after 0 us=
ecs
[    7.502105] calling  fsnotify_init+0x0/0x90 @ 1
[    7.504249] initcall fsnotify_init+0x0/0x90 returned 0 after 1000 usecs
[    7.505107] calling  filelock_init+0x0/0x1e0 @ 1
[    7.506696] initcall filelock_init+0x0/0x1e0 returned 0 after 0 usecs
[    7.507106] calling  init_script_binfmt+0x0/0x20 @ 1
[    7.508106] initcall init_script_binfmt+0x0/0x20 returned 0 after 0 usec=
s
[    7.509106] calling  init_elf_binfmt+0x0/0x20 @ 1
[    7.510105] initcall init_elf_binfmt+0x0/0x20 returned 0 after 0 usecs
[    7.511105] calling  init_compat_elf_binfmt+0x0/0x20 @ 1
[    7.512105] initcall init_compat_elf_binfmt+0x0/0x20 returned 0 after 0 =
usecs
[    7.513106] calling  configfs_init+0x0/0x100 @ 1
[    7.514355] initcall configfs_init+0x0/0x100 returned 0 after 0 usecs
[    7.516106] calling  debugfs_init+0x0/0xd0 @ 1
[    7.517129] initcall debugfs_init+0x0/0xd0 returned 0 after 0 usecs
[    7.518105] calling  tracefs_init+0x0/0x70 @ 1
[    7.519127] initcall tracefs_init+0x0/0x70 returned 0 after 0 usecs
[    7.520106] calling  securityfs_init+0x0/0xd0 @ 1
[    7.522484] initcall securityfs_init+0x0/0xd0 returned 0 after 1000 usec=
s
[    7.523109] calling  pinctrl_init+0x0/0xc0 @ 1
[    7.524105] pinctrl core: initialized pinctrl subsystem
[    7.526606] initcall pinctrl_init+0x0/0xc0 returned 0 after 2000 usecs
[    7.527107] calling  gpiolib_dev_init+0x0/0x140 @ 1
[    7.529130] initcall gpiolib_dev_init+0x0/0x140 returned 0 after 1000 us=
ecs
[    7.530133] calling  virtio_init+0x0/0x30 @ 1
[    7.531378] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    7.532107] calling  iommu_init+0x0/0x60 @ 1
[    7.533154] initcall iommu_init+0x0/0x60 returned 0 after 0 usecs
[    7.534108] calling  component_debug_init+0x0/0x30 @ 1
[    7.535168] initcall component_debug_init+0x0/0x30 returned 0 after 0 us=
ecs
[    7.536113] calling  cpufreq_core_init+0x0/0xd0 @ 1
[    7.537149] initcall cpufreq_core_init+0x0/0xd0 returned 0 after 0 usecs
[    7.539106] calling  cpufreq_gov_performance_init+0x0/0x20 @ 1
[    7.540106] initcall cpufreq_gov_performance_init+0x0/0x20 returned 0 af=
ter 0 usecs
[    7.541105] calling  cpufreq_gov_powersave_init+0x0/0x20 @ 1
[    7.542106] initcall cpufreq_gov_powersave_init+0x0/0x20 returned 0 afte=
r 0 usecs
[    7.543106] calling  cpufreq_gov_userspace_init+0x0/0x20 @ 1
[    7.544106] initcall cpufreq_gov_userspace_init+0x0/0x20 returned 0 afte=
r 0 usecs
[    7.545105] calling  CPU_FREQ_GOV_ONDEMAND_init+0x0/0x20 @ 1
[    7.546106] initcall CPU_FREQ_GOV_ONDEMAND_init+0x0/0x20 returned 0 afte=
r 0 usecs
[    7.547105] calling  CPU_FREQ_GOV_CONSERVATIVE_init+0x0/0x20 @ 1
[    7.548105] initcall CPU_FREQ_GOV_CONSERVATIVE_init+0x0/0x20 returned 0 =
after 0 usecs
[    7.549106] calling  cpuidle_init+0x0/0x20 @ 1
[    7.550207] initcall cpuidle_init+0x0/0x20 returned 0 after 0 usecs
[    7.551107] calling  sock_init+0x0/0xa0 @ 1
[    7.557802] initcall sock_init+0x0/0xa0 returned 0 after 5000 usecs
[    7.558134] calling  net_inuse_init+0x0/0x30 @ 1
[    7.559273] initcall net_inuse_init+0x0/0x30 returned 0 after 0 usecs
[    7.560106] calling  net_defaults_init+0x0/0x50 @ 1
[    7.561107] initcall net_defaults_init+0x0/0x50 returned 0 after 0 usecs
[    7.562105] calling  init_default_flow_dissectors+0x0/0x60 @ 1
[    7.564107] initcall init_default_flow_dissectors+0x0/0x60 returned 0 af=
ter 0 usecs
[    7.565106] calling  netpoll_init+0x0/0x30 @ 1
[    7.566107] initcall netpoll_init+0x0/0x30 returned 0 after 0 usecs
[    7.567105] calling  netlink_proto_init+0x0/0x330 @ 1
[    7.568691] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    7.570139] initcall netlink_proto_init+0x0/0x330 returned 0 after 2000 =
usecs
[    7.571106] calling  genl_init+0x0/0x50 @ 1
[    7.573229] initcall genl_init+0x0/0x50 returned 0 after 1000 usecs
[    7.574140] calling  bsp_pm_check_init+0x0/0x20 @ 1
[    7.575106] initcall bsp_pm_check_init+0x0/0x20 returned 0 after 0 usecs
[    7.578435] calling  irq_sysfs_init+0x0/0x140 @ 1
[    7.583684] initcall irq_sysfs_init+0x0/0x140 returned 0 after 4000 usec=
s
[    7.584106] calling  audit_init+0x0/0x200 @ 1
[    7.585344] audit: initializing netlink subsys (disabled)
[    7.587215] audit: type=3D2000 audit(1394352715.110:1): state=3Dinitiali=
zed audit_enabled=3D0 res=3D1
[    7.587233] initcall audit_init+0x0/0x200 returned 0 after 2000 usecs
[    7.589106] calling  release_early_probes+0x0/0x80 @ 1
[    7.591108] initcall release_early_probes+0x0/0x80 returned 0 after 0 us=
ecs
[    7.593105] calling  bdi_class_init+0x0/0x80 @ 1
[    7.594302] initcall bdi_class_init+0x0/0x80 returned 0 after 0 usecs
[    7.595107] calling  mm_sysfs_init+0x0/0x60 @ 1
[    7.596146] initcall mm_sysfs_init+0x0/0x60 returned 0 after 0 usecs
[    7.598106] calling  init_per_zone_wmark_min+0x0/0x30 @ 1
[    7.599129] initcall init_per_zone_wmark_min+0x0/0x30 returned 0 after 0=
 usecs
[    7.600105] calling  mpi_init+0x0/0x210 @ 1
[    7.601287] initcall mpi_init+0x0/0x210 returned 0 after 0 usecs
[    7.602109] calling  acpi_gpio_setup_params+0x0/0x1b0 @ 1
[    7.603111] initcall acpi_gpio_setup_params+0x0/0x1b0 returned 0 after 0=
 usecs
[    7.604105] calling  pcibus_class_init+0x0/0x20 @ 1
[    7.605216] initcall pcibus_class_init+0x0/0x20 returned 0 after 0 usecs
[    7.606106] calling  pci_driver_init+0x0/0x30 @ 1
[    7.608187] initcall pci_driver_init+0x0/0x30 returned 0 after 1000 usec=
s
[    7.609106] calling  backlight_class_init+0x0/0x120 @ 1
[    7.610238] initcall backlight_class_init+0x0/0x120 returned 0 after 0 u=
secs
[    7.612105] calling  tty_class_init+0x0/0x20 @ 1
[    7.613221] initcall tty_class_init+0x0/0x20 returned 0 after 0 usecs
[    7.614106] calling  vtconsole_class_init+0x0/0x240 @ 1
[    7.616451] initcall vtconsole_class_init+0x0/0x240 returned 0 after 100=
0 usecs
[    7.617109] calling  iommu_dev_init+0x0/0x20 @ 1
[    7.619146] initcall iommu_dev_init+0x0/0x20 returned 0 after 1000 usecs
[    7.620106] calling  mipi_dsi_bus_init+0x0/0x20 @ 1
[    7.621506] initcall mipi_dsi_bus_init+0x0/0x20 returned 0 after 0 usecs
[    7.622109] calling  devlink_class_init+0x0/0x50 @ 1
[    7.624210] initcall devlink_class_init+0x0/0x50 returned 0 after 1000 u=
secs
[    7.625106] calling  software_node_init+0x0/0x60 @ 1
[    7.627145] initcall software_node_init+0x0/0x60 returned 0 after 0 usec=
s
[    7.628105] calling  wakeup_sources_debugfs_init+0x0/0x30 @ 1
[    7.630148] initcall wakeup_sources_debugfs_init+0x0/0x30 returned 0 aft=
er 1000 usecs
[    7.631106] calling  wakeup_sources_sysfs_init+0x0/0x30 @ 1
[    7.632239] initcall wakeup_sources_sysfs_init+0x0/0x30 returned 0 after=
 0 usecs
[    7.633106] calling  regmap_initcall+0x0/0x20 @ 1
[    7.635132] initcall regmap_initcall+0x0/0x20 returned 0 after 1000 usec=
s
[    7.636130] calling  spi_init+0x0/0xd0 @ 1
[    7.637483] initcall spi_init+0x0/0xd0 returned 0 after 0 usecs
[    7.639106] calling  i2c_init+0x0/0x110 @ 1
[    7.641290] initcall i2c_init+0x0/0x110 returned 0 after 1000 usecs
[    7.642106] calling  thermal_init+0x0/0x2d0 @ 1
[    7.643108] thermal_sys: Registered thermal governor 'fair_share'
[    7.643116] thermal_sys: Registered thermal governor 'bang_bang'
[    7.644107] thermal_sys: Registered thermal governor 'step_wise'
[    7.645106] thermal_sys: Registered thermal governor 'user_space'
[    7.646243] initcall thermal_init+0x0/0x2d0 returned 0 after 3000 usecs
[    7.648108] calling  init_menu+0x0/0x20 @ 1
[    7.649144] cpuidle: using governor menu
[    7.650117] initcall init_menu+0x0/0x20 returned 0 after 1000 usecs
[    7.651185] calling  init_haltpoll+0x0/0x30 @ 1
[    7.652105] initcall init_haltpoll+0x0/0x30 returned 0 after 0 usecs
[    7.653105] calling  pcc_init+0x0/0xe0 @ 1
[    7.654109] initcall pcc_init+0x0/0xe0 returned -19 after 0 usecs
[    7.656105] calling  amd_postcore_init+0x0/0x280 @ 1
[    7.657105] initcall amd_postcore_init+0x0/0x280 returned 0 after 0 usec=
s
[    7.658105] calling  kobject_uevent_init+0x0/0x10 @ 1
[    7.659217] initcall kobject_uevent_init+0x0/0x10 returned 0 after 0 use=
cs
[    7.661908] calling  bts_init+0x0/0x160 @ 1
[    7.662205] initcall bts_init+0x0/0x160 returned -19 after 0 usecs
[    7.664105] calling  pt_init+0x0/0x300 @ 1
[    7.667428] initcall pt_init+0x0/0x300 returned 0 after 1000 usecs
[    7.668106] calling  boot_params_ksysfs_init+0x0/0xa0 @ 1
[    7.669198] initcall boot_params_ksysfs_init+0x0/0xa0 returned 0 after 0=
 usecs
[    7.670107] calling  sbf_init+0x0/0x100 @ 1
[    7.671106] initcall sbf_init+0x0/0x100 returned 0 after 0 usecs
[    7.672105] calling  arch_kdebugfs_init+0x0/0xa0 @ 1
[    7.673323] initcall arch_kdebugfs_init+0x0/0xa0 returned 0 after 0 usec=
s
[    7.674106] calling  xfd_update_static_branch+0x0/0x50 @ 1
[    7.675105] initcall xfd_update_static_branch+0x0/0x50 returned 0 after =
0 usecs
[    7.676105] calling  intel_pconfig_init+0x0/0xc0 @ 1
[    7.677105] initcall intel_pconfig_init+0x0/0xc0 returned 0 after 0 usec=
s
[    7.678106] calling  mtrr_if_init+0x0/0xc0 @ 1
[    7.680130] initcall mtrr_if_init+0x0/0xc0 returned 0 after 0 usecs
[    7.681105] calling  activate_jump_labels+0x0/0x40 @ 1
[    7.682106] initcall activate_jump_labels+0x0/0x40 returned 0 after 0 us=
ecs
[    7.683105] calling  init_s4_sigcheck+0x0/0xa0 @ 1
[    7.684106] initcall init_s4_sigcheck+0x0/0xa0 returned 0 after 0 usecs
[    7.685105] calling  ffh_cstate_init+0x0/0x70 @ 1
[    7.686247] initcall ffh_cstate_init+0x0/0x70 returned 0 after 0 usecs
[    7.687108] calling  kvm_alloc_cpumask+0x0/0x270 @ 1
[    7.688105] initcall kvm_alloc_cpumask+0x0/0x270 returned 0 after 0 usec=
s
[    7.689106] calling  activate_jump_labels+0x0/0x40 @ 1
[    7.690105] initcall activate_jump_labels+0x0/0x40 returned 0 after 0 us=
ecs
[    7.691105] calling  gigantic_pages_init+0x0/0x50 @ 1
[    7.692114] initcall gigantic_pages_init+0x0/0x50 returned 0 after 0 use=
cs
[    7.693105] calling  uv_rtc_setup_clock+0x0/0x3c0 @ 1
[    7.694105] initcall uv_rtc_setup_clock+0x0/0x3c0 returned -19 after 0 u=
secs
[    7.695105] calling  kcmp_cookies_init+0x0/0xb0 @ 1
[    7.696110] initcall kcmp_cookies_init+0x0/0xb0 returned 0 after 0 usecs
[    7.697105] calling  cryptomgr_init+0x0/0x20 @ 1
[    7.698106] initcall cryptomgr_init+0x0/0x20 returned 0 after 0 usecs
[    7.699106] calling  acpi_pci_init+0x0/0x170 @ 1
[    7.700105] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    7.701108] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    7.702105] initcall acpi_pci_init+0x0/0x170 returned 0 after 2000 usecs
[    7.703106] calling  dma_channel_table_init+0x0/0x210 @ 1
[    7.705975] initcall dma_channel_table_init+0x0/0x210 returned 0 after 1=
000 usecs
[    7.707107] calling  dma_bus_init+0x0/0x280 @ 1
[    7.709945] initcall dma_bus_init+0x0/0x280 returned 0 after 1000 usecs
[    7.710114] calling  iommu_dma_init+0x0/0x50 @ 1
[    7.711326] initcall iommu_dma_init+0x0/0x50 returned 0 after 0 usecs
[    7.713111] calling  dmi_id_init+0x0/0x1a0 @ 1
[    7.716065] initcall dmi_id_init+0x0/0x1a0 returned 0 after 1000 usecs
[    7.717106] calling  pci_arch_init+0x0/0x150 @ 1
[    7.718170] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000=
-0x8fffffff] (base 0x80000000)
[    7.719110] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved as E82=
0 entry
[    7.745087] PCI: Using configuration type 1 for base access
[    7.746116] initcall pci_arch_init+0x0/0x150 returned 0 after 28000 usec=
s
[    7.747973] calling  init_vdso_image_64+0x0/0x20 @ 1
[    7.749127] initcall init_vdso_image_64+0x0/0x20 returned 0 after 0 usec=
s
[    7.750106] calling  init_vdso_image_32+0x0/0x20 @ 1
[    7.751142] initcall init_vdso_image_32+0x0/0x20 returned 0 after 0 usec=
s
[    7.752105] calling  fixup_ht_bug+0x0/0x430 @ 1
[    7.753105] initcall fixup_ht_bug+0x0/0x430 returned 0 after 0 usecs
[    7.754106] calling  topology_init+0x0/0xc0 @ 1
[    7.766985] initcall topology_init+0x0/0xc0 returned 0 after 11000 usecs
[    7.768110] calling  intel_epb_init+0x0/0x110 @ 1
[    7.772312] initcall intel_epb_init+0x0/0x110 returned 0 after 3000 usec=
s
[    7.773107] calling  mtrr_init_finialize+0x0/0x80 @ 1
[    7.774110] initcall mtrr_init_finialize+0x0/0x80 returned 0 after 0 use=
cs
[    7.775105] calling  uid_cache_init+0x0/0x110 @ 1
[    7.777598] initcall uid_cache_init+0x0/0x110 returned 0 after 0 usecs
[    7.778106] calling  param_sysfs_init+0x0/0x50 @ 1
[    7.779158] initcall param_sysfs_init+0x0/0x50 returned 0 after 0 usecs
[    7.780106] calling  user_namespace_sysctl_init+0x0/0x150 @ 1
[    7.782261] initcall user_namespace_sysctl_init+0x0/0x150 returned 0 aft=
er 0 usecs
[    7.783107] calling  proc_schedstat_init+0x0/0x30 @ 1
[    7.784136] initcall proc_schedstat_init+0x0/0x30 returned 0 after 0 use=
cs
[    7.786105] calling  pm_sysrq_init+0x0/0x20 @ 1
[    7.788140] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    7.789106] calling  create_proc_profile+0x0/0xd0 @ 1
[    7.790105] initcall create_proc_profile+0x0/0xd0 returned 0 after 0 use=
cs
[    7.791107] calling  crash_save_vmcoreinfo_init+0x0/0x770 @ 1
[    7.792250] initcall crash_save_vmcoreinfo_init+0x0/0x770 returned 0 aft=
er 0 usecs
[    7.793106] calling  crash_notes_memory_init+0x0/0x40 @ 1
[    7.794251] initcall crash_notes_memory_init+0x0/0x40 returned 0 after 0=
 usecs
[    7.795107] calling  cgroup_sysfs_init+0x0/0x50 @ 1
[    7.797111] initcall cgroup_sysfs_init+0x0/0x50 returned 0 after 1000 us=
ecs
[    7.798105] calling  cgroup_namespaces_init+0x0/0x10 @ 1
[    7.799105] initcall cgroup_namespaces_init+0x0/0x10 returned 0 after 0 =
usecs
[    7.801105] calling  user_namespaces_init+0x0/0x40 @ 1
[    7.803176] initcall user_namespaces_init+0x0/0x40 returned 0 after 1000=
 usecs
[    7.804106] calling  init_optprobes+0x0/0x30 @ 1
[    7.805107] kprobes: kprobe jump-optimization is enabled. All kprobes ar=
e optimized if possible.
[    7.806105] initcall init_optprobes+0x0/0x30 returned 0 after 1000 usecs
[    7.807105] calling  hung_task_init+0x0/0x80 @ 1
[    7.808377] initcall hung_task_init+0x0/0x80 returned 0 after 0 usecs
[    7.809115] calling  ftrace_check_for_weak_functions+0x0/0x70 @ 1
[    7.810357] initcall ftrace_check_for_weak_functions+0x0/0x70 returned 0=
 after 0 usecs
[    7.812106] calling  trace_eval_init+0x0/0xb0 @ 1
[    7.813347] initcall trace_eval_init+0x0/0xb0 returned 0 after 0 usecs
[    7.814106] calling  send_signal_irq_work_init+0x0/0x1d0 @ 1
[    7.816107] initcall send_signal_irq_work_init+0x0/0x1d0 returned 0 afte=
r 0 usecs
[    7.817105] calling  dev_map_init+0x0/0x180 @ 1
[    7.818109] initcall dev_map_init+0x0/0x180 returned 0 after 0 usecs
[    7.819106] calling  cpu_map_init+0x0/0x180 @ 1
[    7.820106] initcall cpu_map_init+0x0/0x180 returned 0 after 0 usecs
[    7.821105] calling  netns_bpf_init+0x0/0x20 @ 1
[    7.822107] initcall netns_bpf_init+0x0/0x20 returned 0 after 0 usecs
[    7.823105] calling  oom_init+0x0/0x50 @ 1
[    7.824340] initcall oom_init+0x0/0x50 returned 0 after 0 usecs
[    7.825115] calling  default_bdi_init+0x0/0x30 @ 1
[    7.828221] initcall default_bdi_init+0x0/0x30 returned 0 after 2000 use=
cs
[    7.829107] calling  cgwb_init+0x0/0x30 @ 1
[    7.831217] initcall cgwb_init+0x0/0x30 returned 0 after 1000 usecs
[    7.832106] calling  percpu_enable_async+0x0/0x20 @ 1
[    7.833112] initcall percpu_enable_async+0x0/0x20 returned 0 after 0 use=
cs
[    7.834105] calling  kcompactd_init+0x0/0xb0 @ 1
[    7.835329] initcall kcompactd_init+0x0/0xb0 returned 0 after 0 usecs
[    7.836111] calling  init_user_reserve+0x0/0xa0 @ 1
[    7.837169] initcall init_user_reserve+0x0/0xa0 returned 0 after 0 usecs
[    7.838106] calling  init_admin_reserve+0x0/0xa0 @ 1
[    7.839105] initcall init_admin_reserve+0x0/0xa0 returned 0 after 0 usec=
s
[    7.841107] calling  init_reserve_notifier+0x0/0x30 @ 1
[    7.842106] initcall init_reserve_notifier+0x0/0x30 returned 0 after 0 u=
secs
[    7.843105] calling  swap_init_sysfs+0x0/0xa0 @ 1
[    7.844171] initcall swap_init_sysfs+0x0/0xa0 returned 0 after 0 usecs
[    7.846105] calling  swapfile_init+0x0/0x180 @ 1
[    7.847128] initcall swapfile_init+0x0/0x180 returned 0 after 0 usecs
[    7.848105] calling  hugetlb_init+0x0/0x1260 @ 1
[    7.849156] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 page=
s
[    7.850105] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    7.851107] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 page=
s
[    7.852105] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    7.854416] initcall hugetlb_init+0x0/0x1260 returned 0 after 5000 usecs
[    7.855107] calling  ksm_init+0x0/0x290 @ 1
[    7.858284] initcall ksm_init+0x0/0x290 returned 0 after 2000 usecs
[    7.859146] calling  memory_tier_init+0x0/0x150 @ 1
[    7.862095] initcall memory_tier_init+0x0/0x150 returned 0 after 0 usecs
[    7.863131] calling  numa_init_sysfs+0x0/0xa0 @ 1
[    7.864169] initcall numa_init_sysfs+0x0/0xa0 returned 0 after 0 usecs
[    7.865108] calling  hugepage_init+0x0/0x1d0 @ 1
[    7.867713] initcall hugepage_init+0x0/0x1d0 returned 0 after 1000 usecs
[    7.869108] calling  mem_cgroup_init+0x0/0x4c0 @ 1
[    7.870127] initcall mem_cgroup_init+0x0/0x4c0 returned 0 after 0 usecs
[    7.871105] calling  mem_cgroup_swap_init+0x0/0x60 @ 1
[    7.872115] initcall mem_cgroup_swap_init+0x0/0x60 returned 0 after 0 us=
ecs
[    7.873106] calling  page_idle_init+0x0/0x60 @ 1
[    7.874150] initcall page_idle_init+0x0/0x60 returned 0 after 0 usecs
[    7.875106] calling  damon_init+0x0/0x50 @ 1
[    7.876348] initcall damon_init+0x0/0x50 returned 0 after 0 usecs
[    7.877107] calling  damon_va_initcall+0x0/0x1b0 @ 1
[    7.878107] initcall damon_va_initcall+0x0/0x1b0 returned 0 after 0 usec=
s
[    7.879105] calling  damon_pa_initcall+0x0/0x100 @ 1
[    7.880106] initcall damon_pa_initcall+0x0/0x100 returned 0 after 0 usec=
s
[    7.881107] calling  damon_sysfs_init+0x0/0x1b0 @ 1
[    7.882244] initcall damon_sysfs_init+0x0/0x1b0 returned 0 after 0 usecs
[    7.883106] calling  seqiv_module_init+0x0/0x20 @ 1
[    7.884106] initcall seqiv_module_init+0x0/0x20 returned 0 after 0 usecs
[    7.885105] calling  rsa_init+0x0/0x50 @ 1
[    7.886109] initcall rsa_init+0x0/0x50 returned 0 after 0 usecs
[    7.887106] calling  hmac_module_init+0x0/0x20 @ 1
[    7.888105] initcall hmac_module_init+0x0/0x20 returned 0 after 0 usecs
[    7.889105] calling  crypto_null_mod_init+0x0/0x80 @ 1
[    7.890113] initcall crypto_null_mod_init+0x0/0x80 returned 0 after 0 us=
ecs
[    7.891105] calling  md5_mod_init+0x0/0x20 @ 1
[    7.892107] initcall md5_mod_init+0x0/0x20 returned 0 after 0 usecs
[    7.893105] calling  sha1_generic_mod_init+0x0/0x20 @ 1
[    7.894107] initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 0 u=
secs
[    7.895105] calling  sha256_generic_mod_init+0x0/0x20 @ 1
[    7.896115] initcall sha256_generic_mod_init+0x0/0x20 returned 0 after 0=
 usecs
[    7.897107] calling  sha512_generic_mod_init+0x0/0x20 @ 1
[    7.898109] initcall sha512_generic_mod_init+0x0/0x20 returned 0 after 0=
 usecs
[    7.899105] calling  crypto_ecb_module_init+0x0/0x20 @ 1
[    7.900106] initcall crypto_ecb_module_init+0x0/0x20 returned 0 after 0 =
usecs
[    7.902106] calling  crypto_cbc_module_init+0x0/0x20 @ 1
[    7.903105] initcall crypto_cbc_module_init+0x0/0x20 returned 0 after 0 =
usecs
[    7.905105] calling  crypto_cfb_module_init+0x0/0x20 @ 1
[    7.907105] initcall crypto_cfb_module_init+0x0/0x20 returned 0 after 0 =
usecs
[    7.908105] calling  crypto_ctr_module_init+0x0/0x20 @ 1
[    7.909106] initcall crypto_ctr_module_init+0x0/0x20 returned 0 after 0 =
usecs
[    7.910106] calling  crypto_gcm_module_init+0x0/0xb0 @ 1
[    7.911125] initcall crypto_gcm_module_init+0x0/0xb0 returned 0 after 0 =
usecs
[    7.912105] calling  cryptd_init+0x0/0x260 @ 1
[    7.914260] cryptd: max_cpu_qlen set to 1000
[    7.915125] initcall cryptd_init+0x0/0x260 returned 0 after 2000 usecs
[    7.916109] calling  aes_init+0x0/0x20 @ 1
[    7.917108] initcall aes_init+0x0/0x20 returned 0 after 0 usecs
[    7.918106] calling  deflate_mod_init+0x0/0x50 @ 1
[    7.919113] initcall deflate_mod_init+0x0/0x50 returned 0 after 0 usecs
[    7.920105] calling  crc32c_mod_init+0x0/0x20 @ 1
[    7.921108] initcall crc32c_mod_init+0x0/0x20 returned 0 after 0 usecs
[    7.922106] calling  crct10dif_mod_init+0x0/0x20 @ 1
[    7.923108] initcall crct10dif_mod_init+0x0/0x20 returned 0 after 0 usec=
s
[    7.925105] calling  lzo_mod_init+0x0/0x50 @ 1
[    7.926111] initcall lzo_mod_init+0x0/0x50 returned 0 after 0 usecs
[    7.927105] calling  lzorle_mod_init+0x0/0x50 @ 1
[    7.929111] initcall lzorle_mod_init+0x0/0x50 returned 0 after 0 usecs
[    7.930106] calling  drbg_init+0x0/0x100 @ 1
[    7.931217] initcall drbg_init+0x0/0x100 returned 0 after 0 usecs
[    7.933105] calling  ghash_mod_init+0x0/0x20 @ 1
[    7.934110] initcall ghash_mod_init+0x0/0x20 returned 0 after 0 usecs
[    7.935107] calling  init_bio+0x0/0x140 @ 1
[    7.938950] initcall init_bio+0x0/0x140 returned 0 after 2000 usecs
[    7.939109] calling  blk_ioc_init+0x0/0x30 @ 1
[    7.941346] initcall blk_ioc_init+0x0/0x30 returned 0 after 0 usecs
[    7.942106] calling  blk_mq_init+0x0/0x1f0 @ 1
[    7.943107] initcall blk_mq_init+0x0/0x1f0 returned 0 after 0 usecs
[    7.944105] calling  genhd_device_init+0x0/0x50 @ 1
[    7.946497] initcall genhd_device_init+0x0/0x50 returned 0 after 1000 us=
ecs
[    7.947124] calling  blkcg_punt_bio_init+0x0/0x30 @ 1
[    7.949447] initcall blkcg_punt_bio_init+0x0/0x30 returned 0 after 1000 =
usecs
[    7.950112] calling  io_wq_init+0x0/0x40 @ 1
[    7.951132] initcall io_wq_init+0x0/0x40 returned 0 after 0 usecs
[    7.952106] calling  sg_pool_init+0x0/0x210 @ 1
[    7.955303] initcall sg_pool_init+0x0/0x210 returned 0 after 2000 usecs
[    7.956106] calling  irq_poll_setup+0x0/0x1a0 @ 1
[    7.957108] initcall irq_poll_setup+0x0/0x1a0 returned 0 after 0 usecs
[    7.958105] calling  gpiolib_debugfs_init+0x0/0x30 @ 1
[    7.959162] initcall gpiolib_debugfs_init+0x0/0x30 returned 0 after 0 us=
ecs
[    7.960106] calling  pwm_debugfs_init+0x0/0x30 @ 1
[    7.961152] initcall pwm_debugfs_init+0x0/0x30 returned 0 after 0 usecs
[    7.963106] calling  pwm_sysfs_init+0x0/0x20 @ 1
[    7.964223] initcall pwm_sysfs_init+0x0/0x20 returned 0 after 0 usecs
[    7.966106] calling  pci_slot_init+0x0/0x50 @ 1
[    7.967147] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    7.968106] calling  fbmem_init+0x0/0xe0 @ 1
[    7.970635] initcall fbmem_init+0x0/0xe0 returned 0 after 1000 usecs
[    7.971108] calling  scan_for_dmi_ipmi+0x0/0x60 @ 1
[    7.973468] initcall scan_for_dmi_ipmi+0x0/0x60 returned 0 after 1000 us=
ecs
[    7.974132] calling  acpi_init+0x0/0x2c0 @ 1
[    7.976151] ACPI: Added _OSI(Module Device)
[    7.977107] ACPI: Added _OSI(Processor Device)
[    7.978208] ACPI: Added _OSI(3.0 _SCP Extensions)
[    7.979106] ACPI: Added _OSI(Processor Aggregator Device)
[   15.242243] ACPI: 4 ACPI AML tables successfully acquired and loaded
[   15.743100] Scheduler frequency invariance went wobbly, disabling!
[   15.774815] ACPI: Dynamic OEM Table Load:
[   22.824931] ACPI: Interpreter enabled
[   22.829695] ACPI: PM: (supports S0 S4 S5)
[   22.835275] ACPI: Using IOAPIC for interrupt routing
[   22.844670] HEST: Table parsing has been initialized.
[   22.851167] probe of GHES.0 returned 0 after 1000 usecs
[   22.857603] probe of GHES.1 returned 0 after 0 usecs
[   22.874417] GHES: APEI firmware first mode is enabled by APEI bit and WH=
EA _OSC.
[   22.882124] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   22.892108] PCI: Using E820 reservations for host bridge windows
[   22.950222] ACPI: Enabled 6 GPEs in block 00 to 3F
[   28.019740] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus ff])
[   28.027610] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI HPX-Type3]
[   28.111113] acpi PNP0A03:03: _OSC: platform does not support [SHPCHotplu=
g LTR]
[   28.194277] acpi PNP0A03:03: _OSC: OS now controls [PCIeHotplug PME AER =
PCIeCapability]
[   28.203109] acpi PNP0A03:03: FADT indicates ASPM is unsupported, using B=
IOS configuration
[   28.215533] PCI host bridge to bus 0000:ff
[   28.221357] pci_bus 0000:ff: root bus resource [bus ff]
[   28.227687] pci 0000:ff:0b.0: [8086:6f81] type 00 class 0x088000
[   28.235410] pci 0000:ff:0b.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.243114] pci 0000:ff:0b.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.252558] pci 0000:ff:0b.1: [8086:6f36] type 00 class 0x110100
[   28.260410] pci 0000:ff:0b.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.268113] pci 0000:ff:0b.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.278119] pci 0000:ff:0b.2: [8086:6f37] type 00 class 0x110100
[   28.285368] pci 0000:ff:0b.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.293114] pci 0000:ff:0b.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.302819] pci 0000:ff:0b.3: [8086:6f76] type 00 class 0x088000
[   28.310398] pci 0000:ff:0b.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.318107] pci 0000:ff:0b.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.327756] pci 0000:ff:0c.0: [8086:6fe0] type 00 class 0x088000
[   28.335410] pci 0000:ff:0c.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.343107] pci 0000:ff:0c.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.352603] pci 0000:ff:0c.1: [8086:6fe1] type 00 class 0x088000
[   28.360404] pci 0000:ff:0c.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.368108] pci 0000:ff:0c.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.377726] pci 0000:ff:0c.2: [8086:6fe2] type 00 class 0x088000
[   28.385317] pci 0000:ff:0c.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.393114] pci 0000:ff:0c.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.403137] pci 0000:ff:0c.3: [8086:6fe3] type 00 class 0x088000
[   28.410275] pci 0000:ff:0c.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.418179] pci 0000:ff:0c.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.428186] pci 0000:ff:0c.4: [8086:6fe4] type 00 class 0x088000
[   28.435327] pci 0000:ff:0c.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.443194] pci 0000:ff:0c.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.453246] pci 0000:ff:0c.5: [8086:6fe5] type 00 class 0x088000
[   28.460407] pci 0000:ff:0c.5: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.468110] pci 0000:ff:0c.5: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.478286] pci 0000:ff:0c.6: [8086:6fe6] type 00 class 0x088000
[   28.485397] pci 0000:ff:0c.6: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.493119] pci 0000:ff:0c.6: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.502991] pci 0000:ff:0c.7: [8086:6fe7] type 00 class 0x088000
[   28.510375] pci 0000:ff:0c.7: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.518110] pci 0000:ff:0c.7: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.528006] pci 0000:ff:0f.0: [8086:6ff8] type 00 class 0x088000
[   28.535372] pci 0000:ff:0f.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.543108] pci 0000:ff:0f.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.552906] pci 0000:ff:0f.4: [8086:6ffc] type 00 class 0x088000
[   28.560394] pci 0000:ff:0f.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.568113] pci 0000:ff:0f.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.578259] pci 0000:ff:0f.5: [8086:6ffd] type 00 class 0x088000
[   28.585393] pci 0000:ff:0f.5: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.593109] pci 0000:ff:0f.5: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.603288] pci 0000:ff:0f.6: [8086:6ffe] type 00 class 0x088000
[   28.610399] pci 0000:ff:0f.6: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.618118] pci 0000:ff:0f.6: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.628506] pci 0000:ff:10.0: [8086:6f1d] type 00 class 0x088000
[   28.635408] pci 0000:ff:10.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.643108] pci 0000:ff:10.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.653491] pci 0000:ff:10.1: [8086:6f34] type 00 class 0x110100
[   28.660404] pci 0000:ff:10.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.668108] pci 0000:ff:10.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.678412] pci 0000:ff:10.5: [8086:6f1e] type 00 class 0x088000
[   28.685398] pci 0000:ff:10.5: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.693113] pci 0000:ff:10.5: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.703095] pci 0000:ff:10.6: [8086:6f7d] type 00 class 0x110100
[   28.710282] pci 0000:ff:10.6: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.718107] pci 0000:ff:10.6: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.728010] pci 0000:ff:10.7: [8086:6f1f] type 00 class 0x088000
[   28.735323] pci 0000:ff:10.7: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.743174] pci 0000:ff:10.7: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.753065] pci 0000:ff:12.0: calling  pci_invalid_bar+0x0/0x80 @ 1
[   28.760110] pci 0000:ff:12.0: pci_invalid_bar+0x0/0x80 took 0 usecs
[   28.767112] pci 0000:ff:12.0: [8086:6fa0] type 00 class 0x088000
[   28.774357] pci 0000:ff:12.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.782110] pci 0000:ff:12.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.791856] pci 0000:ff:12.1: [8086:6f30] type 00 class 0x110100
[   28.799409] pci 0000:ff:12.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.807107] pci 0000:ff:12.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.816793] pci 0000:ff:13.0: [8086:6fa8] type 00 class 0x088000
[   28.824400] pci 0000:ff:13.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.832107] pci 0000:ff:13.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.841690] pci 0000:ff:13.1: [8086:6f71] type 00 class 0x088000
[   28.849297] pci 0000:ff:13.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.857110] pci 0000:ff:13.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.867169] pci 0000:ff:13.2: [8086:6faa] type 00 class 0x088000
[   28.874283] pci 0000:ff:13.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.882112] pci 0000:ff:13.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.891618] pci 0000:ff:13.3: [8086:6fab] type 00 class 0x088000
[   28.899412] pci 0000:ff:13.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.907109] pci 0000:ff:13.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.916575] pci 0000:ff:13.4: [8086:6fac] type 00 class 0x088000
[   28.924399] pci 0000:ff:13.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.932107] pci 0000:ff:13.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.941508] pci 0000:ff:13.5: [8086:6fad] type 00 class 0x088000
[   28.949403] pci 0000:ff:13.5: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.957113] pci 0000:ff:13.5: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.966667] pci 0000:ff:13.6: [8086:6fae] type 00 class 0x088000
[   28.974403] pci 0000:ff:13.6: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   28.982108] pci 0000:ff:13.6: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   28.991793] pci 0000:ff:13.7: [8086:6faf] type 00 class 0x088000
[   28.999401] pci 0000:ff:13.7: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.008107] pci 0000:ff:13.7: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.018479] pci 0000:ff:14.0: [8086:6fb0] type 00 class 0x088000
[   29.025413] pci 0000:ff:14.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.033107] pci 0000:ff:14.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.043435] pci 0000:ff:14.1: [8086:6fb1] type 00 class 0x088000
[   29.050406] pci 0000:ff:14.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.058107] pci 0000:ff:14.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.068348] pci 0000:ff:14.2: [8086:6fb2] type 00 class 0x088000
[   29.075401] pci 0000:ff:14.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.083112] pci 0000:ff:14.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.093060] pci 0000:ff:14.3: [8086:6fb3] type 00 class 0x088000
[   29.100315] pci 0000:ff:14.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.108107] pci 0000:ff:14.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.117972] pci 0000:ff:14.4: [8086:6fbc] type 00 class 0x088000
[   29.125402] pci 0000:ff:14.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.133119] pci 0000:ff:14.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.143081] pci 0000:ff:14.5: [8086:6fbd] type 00 class 0x088000
[   29.150289] pci 0000:ff:14.5: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.158145] pci 0000:ff:14.5: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.168181] pci 0000:ff:14.6: [8086:6fbe] type 00 class 0x088000
[   29.175313] pci 0000:ff:14.6: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.183143] pci 0000:ff:14.6: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.193140] pci 0000:ff:14.7: [8086:6fbf] type 00 class 0x088000
[   29.200302] pci 0000:ff:14.7: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.208112] pci 0000:ff:14.7: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.218198] pci 0000:ff:15.0: [8086:6fb4] type 00 class 0x088000
[   29.225326] pci 0000:ff:15.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.233147] pci 0000:ff:15.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.243157] pci 0000:ff:15.1: [8086:6fb5] type 00 class 0x088000
[   29.250279] pci 0000:ff:15.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.258176] pci 0000:ff:15.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.268544] pci 0000:ff:15.2: [8086:6fb6] type 00 class 0x088000
[   29.275417] pci 0000:ff:15.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.283107] pci 0000:ff:15.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.293466] pci 0000:ff:15.3: [8086:6fb7] type 00 class 0x088000
[   29.300416] pci 0000:ff:15.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.308108] pci 0000:ff:15.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.318584] pci 0000:ff:1e.0: [8086:6f98] type 00 class 0x088000
[   29.325399] pci 0000:ff:1e.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.333113] pci 0000:ff:1e.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.343214] pci 0000:ff:1e.1: [8086:6f99] type 00 class 0x088000
[   29.350340] pci 0000:ff:1e.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.358110] pci 0000:ff:1e.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.368217] pci 0000:ff:1e.2: [8086:6f9a] type 00 class 0x088000
[   29.375337] pci 0000:ff:1e.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.383122] pci 0000:ff:1e.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.393280] pci 0000:ff:1e.3: calling  quirk_intel_brickland_xeon_ras_ca=
p+0x0/0xb0 @ 1
[   29.402109] pci 0000:ff:1e.3: quirk_intel_brickland_xeon_ras_cap+0x0/0xb=
0 took 0 usecs
[   29.411109] pci 0000:ff:1e.3: calling  pci_invalid_bar+0x0/0x80 @ 1
[   29.418106] pci 0000:ff:1e.3: pci_invalid_bar+0x0/0x80 took 0 usecs
[   29.425106] pci 0000:ff:1e.3: [8086:6fc0] type 00 class 0x088000
[   29.432366] pci 0000:ff:1e.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.440107] pci 0000:ff:1e.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.449832] pci 0000:ff:1e.4: [8086:6f9c] type 00 class 0x088000
[   29.456397] pci 0000:ff:1e.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.465107] pci 0000:ff:1e.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.474496] pci 0000:ff:1f.0: [8086:6f88] type 00 class 0x088000
[   29.481416] pci 0000:ff:1f.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.490109] pci 0000:ff:1f.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   29.499423] pci 0000:ff:1f.2: [8086:6f8a] type 00 class 0x088000
[   29.506395] pci 0000:ff:1f.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   29.515107] pci 0000:ff:1f.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.245667] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[   31.253532] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI HPX-Type3]
[   31.310112] acpi PNP0A08:00: _OSC: platform does not support [SHPCHotplu=
g PME AER LTR]
[   31.413357] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PCIeCapa=
bility]
[   31.422714] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using B=
IOS configuration
[   31.479963] PCI host bridge to bus 0000:00
[   31.485333] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window=
]
[   31.493134] pci_bus 0000:00: root bus resource [io  0x1000-0xffff window=
]
[   31.500132] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[   31.509132] pci_bus 0000:00: root bus resource [mem 0x90000000-0xfbffbff=
f window]
[   31.517109] pci_bus 0000:00: root bus resource [bus 00-fe]
[   31.524603] pci 0000:00:00.0: calling  quirk_mmio_always_on+0x0/0x80 @ 1
[   31.533689] pci 0000:00:00.0: quirk_mmio_always_on+0x0/0x80 took 0 usecs
[   31.541113] pci 0000:00:00.0: [8086:6f00] type 00 class 0x060000
[   31.548607] pci 0000:00:00.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.557108] pci 0000:00:00.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.571329] pci 0000:00:01.0: calling  quirk_cmd_compl+0x0/0x120 @ 1
[   31.578117] pci 0000:00:01.0: quirk_cmd_compl+0x0/0x120 took 0 usecs
[   31.586120] pci 0000:00:01.0: calling  quirk_no_aersid+0x0/0x110 @ 1
[   31.593107] pci 0000:00:01.0: quirk_no_aersid+0x0/0x110 took 0 usecs
[   31.600106] pci 0000:00:01.0: [8086:6f02] type 01 class 0x060400
[   31.607371] pci 0000:00:01.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.615112] pci 0000:00:01.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.623107] pci 0000:00:01.0: calling  pci_fixup_transparent_bridge+0x0/=
0xc0 @ 1
[   31.632107] pci 0000:00:01.0: pci_fixup_transparent_bridge+0x0/0xc0 took=
 0 usecs
[   31.640196] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[   31.655533] pci 0000:00:02.0: calling  quirk_cmd_compl+0x0/0x120 @ 1
[   31.662455] pci 0000:00:02.0: quirk_cmd_compl+0x0/0x120 took 0 usecs
[   31.670114] pci 0000:00:02.0: calling  quirk_no_aersid+0x0/0x110 @ 1
[   31.677107] pci 0000:00:02.0: quirk_no_aersid+0x0/0x110 took 0 usecs
[   31.684106] pci 0000:00:02.0: [8086:6f04] type 01 class 0x060400
[   31.691368] pci 0000:00:02.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.699113] pci 0000:00:02.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.708107] pci 0000:00:02.0: calling  pci_fixup_transparent_bridge+0x0/=
0xc0 @ 1
[   31.716106] pci 0000:00:02.0: pci_fixup_transparent_bridge+0x0/0xc0 took=
 0 usecs
[   31.724194] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[   31.739428] pci 0000:00:02.2: calling  quirk_cmd_compl+0x0/0x120 @ 1
[   31.746334] pci 0000:00:02.2: quirk_cmd_compl+0x0/0x120 took 0 usecs
[   31.754108] pci 0000:00:02.2: calling  quirk_no_aersid+0x0/0x110 @ 1
[   31.761106] pci 0000:00:02.2: quirk_no_aersid+0x0/0x110 took 0 usecs
[   31.768107] pci 0000:00:02.2: [8086:6f06] type 01 class 0x060400
[   31.775429] pci 0000:00:02.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.783108] pci 0000:00:02.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.791113] pci 0000:00:02.2: calling  pci_fixup_transparent_bridge+0x0/=
0xc0 @ 1
[   31.800118] pci 0000:00:02.2: pci_fixup_transparent_bridge+0x0/0xc0 took=
 0 usecs
[   31.808181] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[   31.823571] pci 0000:00:03.0: calling  quirk_cmd_compl+0x0/0x120 @ 1
[   31.830110] pci 0000:00:03.0: quirk_cmd_compl+0x0/0x120 took 0 usecs
[   31.837108] pci 0000:00:03.0: calling  quirk_no_aersid+0x0/0x110 @ 1
[   31.845112] pci 0000:00:03.0: quirk_no_aersid+0x0/0x110 took 0 usecs
[   31.852275] pci 0000:00:03.0: [8086:6f08] type 01 class 0x060400
[   31.859376] pci 0000:00:03.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.868111] pci 0000:00:03.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.877108] pci 0000:00:03.0: calling  pci_fixup_transparent_bridge+0x0/=
0xc0 @ 1
[   31.885106] pci 0000:00:03.0: pci_fixup_transparent_bridge+0x0/0xc0 took=
 0 usecs
[   31.893203] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[   31.907923] pci 0000:00:05.0: [8086:6f28] type 00 class 0x088000
[   31.915458] pci 0000:00:05.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.924732] pci 0000:00:05.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.934924] pci 0000:00:05.1: [8086:6f29] type 00 class 0x088000
[   31.942421] pci 0000:00:05.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.950107] pci 0000:00:05.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.964591] pci 0000:00:05.2: [8086:6f2a] type 00 class 0x088000
[   31.971371] pci 0000:00:05.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   31.980113] pci 0000:00:05.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   31.989922] pci 0000:00:05.4: [8086:6f2c] type 00 class 0x080020
[   31.997123] pci 0000:00:05.4: reg 0x10: [mem 0xfb418000-0xfb418fff]
[   32.004379] pci 0000:00:05.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.012107] pci 0000:00:05.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.022243] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[   32.029134] pci 0000:00:14.0: reg 0x10: [mem 0xfb400000-0xfb40ffff 64bit=
]
[   32.037489] pci 0000:00:14.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.045119] pci 0000:00:14.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.053144] pci 0000:00:14.0: PME# supported from D3hot D3cold
[   32.066560] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[   32.073133] pci 0000:00:16.0: reg 0x10: [mem 0xfb417000-0xfb41700f 64bit=
]
[   32.081355] pci 0000:00:16.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.089110] pci 0000:00:16.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.098151] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[   32.111534] pci 0000:00:16.1: [8086:8c3b] type 00 class 0x078000
[   32.118134] pci 0000:00:16.1: reg 0x10: [mem 0xfb416000-0xfb41600f 64bit=
]
[   32.126313] pci 0000:00:16.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.134107] pci 0000:00:16.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.142151] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[   32.156837] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[   32.163131] pci 0000:00:1a.0: reg 0x10: [mem 0xfb414000-0xfb4143ff]
[   32.171432] pci 0000:00:1a.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.179276] pci 0000:00:1a.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.187158] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[   32.201240] pci 0000:00:1c.0: calling  quirk_cmd_compl+0x0/0x120 @ 1
[   32.208328] pci 0000:00:1c.0: quirk_cmd_compl+0x0/0x120 took 0 usecs
[   32.215108] pci 0000:00:1c.0: calling  quirk_no_aersid+0x0/0x110 @ 1
[   32.223107] pci 0000:00:1c.0: quirk_no_aersid+0x0/0x110 took 0 usecs
[   32.230106] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[   32.237321] pci 0000:00:1c.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.245530] pci 0000:00:1c.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.254108] pci 0000:00:1c.0: calling  pci_fixup_transparent_bridge+0x0/=
0xc0 @ 1
[   32.262112] pci 0000:00:1c.0: pci_fixup_transparent_bridge+0x0/0xc0 took=
 0 usecs
[   32.270110] pci 0000:00:1c.0: calling  quirk_apple_mbp_poweroff+0x0/0x18=
0 @ 1
[   32.278107] pci 0000:00:1c.0: quirk_apple_mbp_poweroff+0x0/0x180 took 0 =
usecs
[   32.286188] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[   32.301073] pci 0000:00:1c.4: calling  quirk_cmd_compl+0x0/0x120 @ 1
[   32.308109] pci 0000:00:1c.4: quirk_cmd_compl+0x0/0x120 took 0 usecs
[   32.315113] pci 0000:00:1c.4: calling  quirk_no_aersid+0x0/0x110 @ 1
[   32.323107] pci 0000:00:1c.4: quirk_no_aersid+0x0/0x110 took 0 usecs
[   32.330106] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[   32.337364] pci 0000:00:1c.4: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.345112] pci 0000:00:1c.4: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.353107] pci 0000:00:1c.4: calling  pci_fixup_transparent_bridge+0x0/=
0xc0 @ 1
[   32.361106] pci 0000:00:1c.4: pci_fixup_transparent_bridge+0x0/0xc0 took=
 0 usecs
[   32.370192] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[   32.384796] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[   32.391131] pci 0000:00:1d.0: reg 0x10: [mem 0xfb413000-0xfb4133ff]
[   32.399442] pci 0000:00:1d.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.407122] pci 0000:00:1d.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.415155] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[   32.428939] pci 0000:00:1f.0: [8086:8c54] type 00 class 0x060100
[   32.436492] pci 0000:00:1f.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.445108] pci 0000:00:1f.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.459206] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[   32.466130] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[   32.473115] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[   32.479116] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[   32.486115] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[   32.492115] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[   32.498116] pci 0000:00:1f.2: reg 0x24: [mem 0xfb412000-0xfb4127ff]
[   32.505364] pci 0000:00:1f.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.514253] pci 0000:00:1f.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.522155] pci 0000:00:1f.2: PME# supported from D3hot
[   32.534585] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[   32.542135] pci 0000:00:1f.3: reg 0x10: [mem 0xfb411000-0xfb4110ff 64bit=
]
[   32.549134] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[   32.556383] pci 0000:00:1f.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.564113] pci 0000:00:1f.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.578687] pci 0000:00:1f.6: [8086:8c24] type 00 class 0x118000
[   32.585135] pci 0000:00:1f.6: reg 0x10: [mem 0xfb410000-0xfb410fff 64bit=
]
[   32.593412] pci 0000:00:1f.6: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.601107] pci 0000:00:1f.6: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.651281] acpiphp: Slot [1] registered
[   32.658521] pci 0000:00:01.0: PCI bridge to [bus 01]
[   32.700275] pci 0000:02:00.0: [8086:6f50] type 00 class 0x088000
[   32.707297] pci 0000:02:00.0: reg 0x10: [mem 0xfb306000-0xfb307fff 64bit=
]
[   32.715724] pci 0000:02:00.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.724108] pci 0000:02:00.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.738814] pci 0000:02:00.1: [8086:6f51] type 00 class 0x088000
[   32.746135] pci 0000:02:00.1: reg 0x10: [mem 0xfb304000-0xfb305fff 64bit=
]
[   32.754300] pci 0000:02:00.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.762113] pci 0000:02:00.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.778009] pci 0000:02:00.2: [8086:6f52] type 00 class 0x088000
[   32.784133] pci 0000:02:00.2: reg 0x10: [mem 0xfb302000-0xfb303fff 64bit=
]
[   32.793286] pci 0000:02:00.2: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.801113] pci 0000:02:00.2: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.815427] pci 0000:02:00.3: [8086:6f53] type 00 class 0x088000
[   32.823129] pci 0000:02:00.3: reg 0x10: [mem 0xfb300000-0xfb301fff 64bit=
]
[   32.830462] pci 0000:02:00.3: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.839108] pci 0000:02:00.3: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.854221] pci 0000:00:02.0: PCI bridge to [bus 02]
[   32.861110] pci 0000:00:02.0:   bridge window [mem 0xfb300000-0xfb3fffff=
]
[   32.905918] pci 0000:03:00.0: calling  quirk_f0_vpd_link+0x0/0x220 @ 1
[   32.913109] pci 0000:03:00.0: quirk_f0_vpd_link+0x0/0x220 took 0 usecs
[   32.920110] pci 0000:03:00.0: [8086:15ad] type 00 class 0x020000
[   32.927130] pci 0000:03:00.0: reg 0x10: [mem 0xfbc00000-0xfbdfffff 64bit=
 pref]
[   32.935139] pci 0000:03:00.0: reg 0x20: [mem 0xfbe04000-0xfbe07fff 64bit=
 pref]
[   32.943119] pci 0000:03:00.0: reg 0x30: [mem 0xfb280000-0xfb2fffff pref]
[   32.951639] pci 0000:03:00.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   32.959113] pci 0000:03:00.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   32.968222] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[   32.975165] pci 0000:03:00.0: reg 0x184: [mem 0x00000000-0x00003fff 64bi=
t]
[   32.983107] pci 0000:03:00.0: VF(n) BAR0 space: [mem 0x00000000-0x000fff=
ff 64bit] (contains BAR0 for 64 VFs)
[   32.994118] pci 0000:03:00.0: reg 0x190: [mem 0x00000000-0x00003fff 64bi=
t]
[   33.002106] pci 0000:03:00.0: VF(n) BAR3 space: [mem 0x00000000-0x000fff=
ff 64bit] (contains BAR3 for 64 VFs)
[   33.020483] pci 0000:03:00.1: calling  quirk_f0_vpd_link+0x0/0x220 @ 1
[   33.028326] pci 0000:03:00.1: quirk_f0_vpd_link+0x0/0x220 took 0 usecs
[   33.036111] pci 0000:03:00.1: [8086:15ad] type 00 class 0x020000
[   33.042130] pci 0000:03:00.1: reg 0x10: [mem 0xfba00000-0xfbbfffff 64bit=
 pref]
[   33.051139] pci 0000:03:00.1: reg 0x20: [mem 0xfbe00000-0xfbe03fff 64bit=
 pref]
[   33.059118] pci 0000:03:00.1: reg 0x30: [mem 0xfb200000-0xfb27ffff pref]
[   33.067137] pci 0000:03:00.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   33.075111] pci 0000:03:00.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   33.083188] pci 0000:03:00.1: PME# supported from D0 D3hot D3cold
[   33.090159] pci 0000:03:00.1: reg 0x184: [mem 0x00000000-0x00003fff 64bi=
t]
[   33.098107] pci 0000:03:00.1: VF(n) BAR0 space: [mem 0x00000000-0x000fff=
ff 64bit] (contains BAR0 for 64 VFs)
[   33.108119] pci 0000:03:00.1: reg 0x190: [mem 0x00000000-0x00003fff 64bi=
t]
[   33.116106] pci 0000:03:00.1: VF(n) BAR3 space: [mem 0x00000000-0x000fff=
ff 64bit] (contains BAR3 for 64 VFs)
[   33.134859] pci 0000:00:02.2: PCI bridge to [bus 03]
[   33.140186] pci 0000:00:02.2:   bridge window [mem 0xfb200000-0xfb2fffff=
]
[   33.148112] pci 0000:00:02.2:   bridge window [mem 0xfba00000-0xfbefffff=
 64bit pref]
[   33.189575] pci 0000:00:03.0: PCI bridge to [bus 04]
[   33.203713] pci 0000:05:00.0: calling  quirk_f0_vpd_link+0x0/0x220 @ 1
[   33.211296] pci 0000:05:00.0: quirk_f0_vpd_link+0x0/0x220 took 0 usecs
[   33.218110] pci 0000:05:00.0: [8086:1521] type 00 class 0x020000
[   33.225133] pci 0000:05:00.0: reg 0x10: [mem 0xfb120000-0xfb13ffff]
[   33.232137] pci 0000:05:00.0: reg 0x18: [io  0xe020-0xe03f]
[   33.239120] pci 0000:05:00.0: reg 0x1c: [mem 0xfb144000-0xfb147fff]
[   33.246404] pci 0000:05:00.0: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   33.255111] pci 0000:05:00.0: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   33.263265] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[   33.270183] pci 0000:05:00.0: reg 0x184: [mem 0x90000000-0x90003fff 64bi=
t pref]
[   33.278107] pci 0000:05:00.0: VF(n) BAR0 space: [mem 0x90000000-0x9001ff=
ff 64bit pref] (contains BAR0 for 8 VFs)
[   33.289132] pci 0000:05:00.0: reg 0x190: [mem 0x90020000-0x90023fff 64bi=
t pref]
[   33.297106] pci 0000:05:00.0: VF(n) BAR3 space: [mem 0x90020000-0x9003ff=
ff 64bit pref] (contains BAR3 for 8 VFs)
[   33.316069] pci 0000:05:00.1: calling  quirk_f0_vpd_link+0x0/0x220 @ 1
[   33.324178] pci 0000:05:00.1: quirk_f0_vpd_link+0x0/0x220 took 0 usecs
[   33.331120] pci 0000:05:00.1: [8086:1521] type 00 class 0x020000
[   33.338134] pci 0000:05:00.1: reg 0x10: [mem 0xfb100000-0xfb11ffff]
[   33.345138] pci 0000:05:00.1: reg 0x18: [io  0xe000-0xe01f]
[   33.351120] pci 0000:05:00.1: reg 0x1c: [mem 0xfb140000-0xfb143fff]
[   33.359406] pci 0000:05:00.1: calling  quirk_igfx_skip_te_disable+0x0/0x=
1a0 @ 1
[   33.367110] pci 0000:05:00.1: quirk_igfx_skip_te_disable+0x0/0x1a0 took =
0 usecs
[   33.375232] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[   33.382180] pci 0000:05:00.1: reg 0x184: [mem 0x90040000-0x90043fff 64bi=
t pref]
[   33.391107] pci 0000:05:00.1: VF(n) BAR0 space: [mem 0x90040000-0x9005ff=
ff 64bit pref] (contains BAR0 for 8 VFs)
[   33.402131] pci 0000:05:00.1: reg 0x190: [mem 0x90060000-0x90063fff 64bi=
t pref]
[   33.410105] pci 0000:05:00.1: VF(n) BAR3 space: [mem 0x90060000-0x9007ff=
ff 64bit pref] (contains BAR3 for 8 VFs)
[   33.428121] pci 0000:00:1c.0: PCI bridge to [bus 05]
[   33.434150] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[   33.441110] pci 0000:00:1c.0:   bridge window [mem 0xfb100000-0xfb1fffff=
]
[   33.449112] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x900fffff=
 64bit pref]
[   33.457113] pci 0000:00:1c.0: bridge has subordinate 05 but max busn 06
[   33.466550] pci 0000:06:00.0: [1a03:1150] type 01 class 0x060400
[   33.474831] pci 0000:06:00.0: supports D1 D2
[   33.480106] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   33.493664] pci 0000:00:1c.4: PCI bridge to [bus 06-07]
[   33.500504] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[   33.507109] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfb0fffff=
]
[   33.515244] pci_bus 0000:07: extended config space not accessible
[   33.523699] pci 0000:07:00.0: [1a03:2000] type 00 class 0x030000
[   33.531146] pci 0000:07:00.0: reg 0x10: [mem 0xfa000000-0xfaffffff]
[   33.538123] pci 0000:07:00.0: reg 0x14: [mem 0xfb000000-0xfb01ffff]
[   33.545133] pci 0000:07:00.0: reg 0x18: [io  0xd000-0xd07f]
[   33.552780] pci 0000:07:00.0: calling  efifb_fixup_resources+0x0/0x4e0 @=
 1
[   33.560110] pci 0000:07:00.0: efifb_fixup_resources+0x0/0x4e0 took 0 use=
cs
[   33.568108] pci 0000:07:00.0: calling  pci_fixup_video+0x0/0x2c0 @ 1
[   33.575119] pci 0000:07:00.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[   33.584106] pci 0000:07:00.0: pci_fixup_video+0x0/0x2c0 took 8789 usecs
[   33.592167] pci 0000:07:00.0: supports D1 D2
[   33.597106] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[   33.612146] pci 0000:06:00.0: PCI bridge to [bus 07]
[   33.617125] pci 0000:06:00.0:   bridge window [io  0xd000-0xdfff]
[   33.624113] pci 0000:06:00.0:   bridge window [mem 0xfa000000-0xfb0fffff=
]
[   33.767058] ACPI: PCI: Interrupt link LNKA configured for IRQ 11
[   33.775108] ACPI: PCI: Interrupt link LNKA disabled
[   33.787951] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[   33.795108] ACPI: PCI: Interrupt link LNKB disabled
[   33.808750] ACPI: PCI: Interrupt link LNKC configured for IRQ 5
[   33.816107] ACPI: PCI: Interrupt link LNKC disabled
[   33.827767] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[   33.835107] ACPI: PCI: Interrupt link LNKD disabled
[   33.847697] ACPI: PCI: Interrupt link LNKE configured for IRQ 0
[   33.854112] ACPI: PCI: Interrupt link LNKE disabled
[   33.866899] ACPI: PCI: Interrupt link LNKF configured for IRQ 0
[   33.873107] ACPI: PCI: Interrupt link LNKF disabled
[   33.887915] ACPI: PCI: Interrupt link LNKG configured for IRQ 0
[   33.895584] ACPI: PCI: Interrupt link LNKG disabled
[   33.908634] ACPI: PCI: Interrupt link LNKH configured for IRQ 0
[   33.915112] ACPI: PCI: Interrupt link LNKH disabled
[   33.927004] initcall acpi_init+0x0/0x2c0 returned 0 after 25952000 usecs
[   33.935571] calling  adxl_init+0x0/0x290 @ 1
[   33.940153] initcall adxl_init+0x0/0x290 returned -19 after 1000 usecs
[   33.948107] calling  hmat_init+0x0/0x210 @ 1
[   33.953108] initcall hmat_init+0x0/0x210 returned 0 after 0 usecs
[   33.960106] calling  pnp_init+0x0/0x20 @ 1
[   33.965350] initcall pnp_init+0x0/0x20 returned 0 after 0 usecs
[   33.972107] calling  misc_init+0x0/0xf0 @ 1
[   33.977331] initcall misc_init+0x0/0xf0 returned 0 after 0 usecs
[   33.984113] calling  tpm_init+0x0/0x2a0 @ 1
[   33.990137] initcall tpm_init+0x0/0x2a0 returned 0 after 1000 usecs
[   33.997113] calling  iommu_subsys_init+0x0/0x250 @ 1
[   34.003105] iommu: Default domain type: Translated=20
[   34.008104] iommu: DMA domain TLB invalidation policy: lazy mode=20
[   34.015127] initcall iommu_subsys_init+0x0/0x250 returned 0 after 12000 =
usecs
[   34.023111] calling  cn_init+0x0/0x1a0 @ 1
[   34.028262] initcall cn_init+0x0/0x1a0 returned 0 after 0 usecs
[   34.035108] calling  dax_core_init+0x0/0x120 @ 1
[   34.041829] initcall dax_core_init+0x0/0x120 returned 0 after 2000 usecs
[   34.050112] calling  dma_buf_init+0x0/0xd0 @ 1
[   34.055686] initcall dma_buf_init+0x0/0xd0 returned 0 after 1000 usecs
[   34.063108] calling  init_scsi+0x0/0x90 @ 1
[   34.071702] SCSI subsystem initialized
[   34.076107] initcall init_scsi+0x0/0x90 returned 0 after 8000 usecs
[   34.084106] calling  phy_init+0x0/0x80 @ 1
[   34.088881] initcall phy_init+0x0/0x80 returned 0 after 1000 usecs
[   34.096107] calling  usb_common_init+0x0/0x30 @ 1
[   34.102163] initcall usb_common_init+0x0/0x30 returned 0 after 0 usecs
[   34.109122] calling  usb_init+0x0/0x1a0 @ 1
[   34.114201] ACPI: bus type USB registered
[   34.119406] usbcore: registered new interface driver usbfs
[   34.126393] usbcore: registered new interface driver hub
[   34.132492] usbcore: registered new device driver usb
[   34.139108] initcall usb_init+0x0/0x1a0 returned 0 after 25000 usecs
[   34.146112] calling  xdbc_init+0x0/0x240 @ 1
[   34.151119] initcall xdbc_init+0x0/0x240 returned 0 after 0 usecs
[   34.158106] calling  typec_init+0x0/0xa0 @ 1
[   34.163555] initcall typec_init+0x0/0xa0 returned 0 after 1000 usecs
[   34.171119] calling  serio_init+0x0/0x40 @ 1
[   34.176393] initcall serio_init+0x0/0x40 returned 0 after 0 usecs
[   34.183113] calling  input_init+0x0/0x140 @ 1
[   34.188320] initcall input_init+0x0/0x140 returned 0 after 0 usecs
[   34.197107] calling  rtc_init+0x0/0x80 @ 1
[   34.201259] initcall rtc_init+0x0/0x80 returned 0 after 1000 usecs
[   34.209106] calling  pps_init+0x0/0xf0 @ 1
[   34.214252] pps_core: LinuxPPS API ver. 1 registered
[   34.219105] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   34.229116] initcall pps_init+0x0/0xf0 returned 0 after 15000 usecs
[   34.236119] calling  ptp_init+0x0/0xc0 @ 1
[   34.241288] PTP clock support registered
[   34.246111] initcall ptp_init+0x0/0xc0 returned 0 after 5000 usecs
[   34.253107] calling  power_supply_class_init+0x0/0x70 @ 1
[   34.260256] initcall power_supply_class_init+0x0/0x70 returned 0 after 0=
 usecs
[   34.268106] calling  hwmon_init+0x0/0x1a0 @ 1
[   34.273240] initcall hwmon_init+0x0/0x1a0 returned 0 after 0 usecs
[   34.280111] calling  md_init+0x0/0x170 @ 1
[   34.286596] initcall md_init+0x0/0x170 returned 0 after 1000 usecs
[   34.293112] calling  edac_init+0x0/0x80 @ 1
[   34.298118] EDAC MC: Ver: 3.0.0
[   34.304131] initcall edac_init+0x0/0x80 returned 0 after 6000 usecs
[   34.311115] calling  leds_init+0x0/0xa0 @ 1
[   34.316212] initcall leds_init+0x0/0xa0 returned 0 after 0 usecs
[   34.323107] calling  dmi_init+0x0/0x160 @ 1
[   34.328248] initcall dmi_init+0x0/0x160 returned 0 after 0 usecs
[   34.335107] calling  efisubsys_init+0x0/0x850 @ 1
[   34.340105] initcall efisubsys_init+0x0/0x850 returned 0 after 0 usecs
[   34.348106] calling  hv_acpi_init+0x0/0x140 @ 1
[   34.353105] initcall hv_acpi_init+0x0/0x140 returned -19 after 0 usecs
[   34.360106] calling  ras_init+0x0/0x20 @ 1
[   34.365219] initcall ras_init+0x0/0x20 returned 0 after 1000 usecs
[   34.373114] calling  nvmem_init+0x0/0x20 @ 1
[   34.378368] initcall nvmem_init+0x0/0x20 returned 0 after 0 usecs
[   34.385107] calling  proto_init+0x0/0x20 @ 1
[   34.390144] initcall proto_init+0x0/0x20 returned 0 after 0 usecs
[   34.397111] calling  net_dev_init+0x0/0xc90 @ 1
[   34.406471] initcall net_dev_init+0x0/0xc90 returned 0 after 4000 usecs
[   34.414109] calling  neigh_init+0x0/0x90 @ 1
[   34.419179] initcall neigh_init+0x0/0x90 returned 0 after 0 usecs
[   34.426108] calling  fib_notifier_init+0x0/0x20 @ 1
[   34.432126] initcall fib_notifier_init+0x0/0x20 returned 0 after 0 usecs
[   34.439106] calling  netdev_genl_init+0x0/0x40 @ 1
[   34.445318] initcall netdev_genl_init+0x0/0x40 returned 0 after 0 usecs
[   34.452109] calling  fib_rules_init+0x0/0xc0 @ 1
[   34.458163] initcall fib_rules_init+0x0/0xc0 returned 0 after 0 usecs
[   34.465112] calling  init_cgroup_netprio+0x0/0x20 @ 1
[   34.471119] initcall init_cgroup_netprio+0x0/0x20 returned 0 after 0 use=
cs
[   34.479112] calling  bpf_lwt_init+0x0/0x20 @ 1
[   34.484105] initcall bpf_lwt_init+0x0/0x20 returned 0 after 0 usecs
[   34.491106] calling  pktsched_init+0x0/0x120 @ 1
[   34.497239] initcall pktsched_init+0x0/0x120 returned 0 after 0 usecs
[   34.504113] calling  tc_filter_init+0x0/0x110 @ 1
[   34.510315] initcall tc_filter_init+0x0/0x110 returned 0 after 0 usecs
[   34.517117] calling  tc_action_init+0x0/0x60 @ 1
[   34.523156] initcall tc_action_init+0x0/0x60 returned 0 after 0 usecs
[   34.530107] calling  ethnl_init+0x0/0x70 @ 1
[   34.535662] initcall ethnl_init+0x0/0x70 returned 0 after 1000 usecs
[   34.543107] calling  nexthop_init+0x0/0x100 @ 1
[   34.548285] initcall nexthop_init+0x0/0x100 returned 0 after 0 usecs
[   34.556109] calling  cipso_v4_init+0x0/0x140 @ 1
[   34.561133] initcall cipso_v4_init+0x0/0x140 returned 0 after 0 usecs
[   34.568106] calling  netlbl_init+0x0/0x90 @ 1
[   34.573110] NetLabel: Initializing
[   34.578105] NetLabel:  domain hash size =3D 128
[   34.583105] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[   34.590365] NetLabel:  unlabeled traffic allowed by default
[   34.596109] initcall netlbl_init+0x0/0x90 returned 0 after 23000 usecs
[   34.604107] calling  pci_subsys_init+0x0/0x190 @ 1
[   34.609106] PCI: Using ACPI for IRQ routing
[   34.624003] PCI: pci_cache_line_size set to 64 bytes
[   34.630343] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[   34.637164] e820: reserve RAM buffer [mem 0x796e1000-0x7bffffff]
[   34.644152] e820: reserve RAM buffer [mem 0x799ae000-0x7bffffff]
[   34.650145] e820: reserve RAM buffer [mem 0x7bdb6000-0x7bffffff]
[   34.657145] initcall pci_subsys_init+0x0/0x190 returned 0 after 48000 us=
ecs
[   34.665106] calling  vsprintf_init_hashval+0x0/0x20 @ 1
[   34.671108] initcall vsprintf_init_hashval+0x0/0x20 returned 0 after 0 u=
secs
[   34.679106] calling  efi_runtime_map_init+0x0/0x210 @ 1
[   34.685109] initcall efi_runtime_map_init+0x0/0x210 returned 0 after 0 u=
secs
[   34.693106] calling  vga_arb_device_init+0x0/0x90 @ 1
[   34.699552] pci 0000:07:00.0: vgaarb: setting as boot VGA device
[   34.700100] pci 0000:07:00.0: vgaarb: bridge control possible
[   34.700100] pci 0000:07:00.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dio+mem,locks=3Dnone
[   34.722110] vgaarb: loaded
[   34.726105] initcall vga_arb_device_init+0x0/0x90 returned 0 after 27000=
 usecs
[   34.734106] calling  watchdog_init+0x0/0x1b0 @ 1
[   34.740236] initcall watchdog_init+0x0/0x1b0 returned 0 after 1000 usecs
[   34.748655] calling  nmi_warning_debugfs+0x0/0x60 @ 1
[   34.754233] initcall nmi_warning_debugfs+0x0/0x60 returned 0 after 0 use=
cs
[   34.762111] calling  save_microcode_in_initrd+0x0/0xe0 @ 1
[   34.768118] initcall save_microcode_in_initrd+0x0/0xe0 returned 0 after =
0 usecs
[   34.776118] calling  hpet_late_init+0x0/0x1a0 @ 1
[   34.782137] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[   34.789109] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[   34.798103] initcall hpet_late_init+0x0/0x1a0 returned 0 after 16000 use=
cs
[   34.805106] calling  init_amd_nbs+0x0/0x240 @ 1
[   34.811206] initcall init_amd_nbs+0x0/0x240 returned 0 after 0 usecs
[   34.818110] calling  iomem_init_inode+0x0/0xb0 @ 1
[   34.824756] initcall iomem_init_inode+0x0/0xb0 returned 0 after 1000 use=
cs
[   34.832115] calling  clocksource_done_booting+0x0/0x50 @ 1
[   34.839174] clocksource: Switched to clocksource tsc-early
[   34.845485] initcall clocksource_done_booting+0x0/0x50 returned 0 after =
6384 usecs
[   34.853900] calling  tracer_init_tracefs+0x0/0x1a0 @ 1
[   34.859920] initcall tracer_init_tracefs+0x0/0x1a0 returned 0 after 66 u=
secs
[   34.867806] calling  init_trace_printk_function_export+0x0/0x30 @ 1
[   34.874933] initcall init_trace_printk_function_export+0x0/0x30 returned=
 0 after 52 usecs
[   34.883950] calling  init_graph_tracefs+0x0/0x30 @ 1
[   34.889779] initcall init_graph_tracefs+0x0/0x30 returned 0 after 46 use=
cs
[   34.897485] calling  trace_events_synth_init+0x0/0x50 @ 1
[   34.903751] initcall trace_events_synth_init+0x0/0x50 returned 0 after 5=
5 usecs
[   34.911896] calling  bpf_event_init+0x0/0x20 @ 1
[   34.917319] initcall bpf_event_init+0x0/0x20 returned 0 after 2 usecs
[   34.924574] calling  init_kprobe_trace+0x0/0x410 @ 1
[   35.403914] initcall init_kprobe_trace+0x0/0x410 returned 0 after 473562=
 usecs
[   35.412010] calling  init_dynamic_event+0x0/0x30 @ 1
[   35.417863] initcall init_dynamic_event+0x0/0x30 returned 0 after 71 use=
cs
[   35.425583] calling  init_uprobe_trace+0x0/0x60 @ 1
[   35.431365] initcall init_uprobe_trace+0x0/0x60 returned 0 after 95 usec=
s
[   35.438982] calling  bpf_init+0x0/0xb0 @ 1
[   35.443934] initcall bpf_init+0x0/0xb0 returned 0 after 40 usecs
[   35.450752] calling  secretmem_init+0x0/0x70 @ 1
[   35.456184] initcall secretmem_init+0x0/0x70 returned 0 after 0 usecs
[   35.463441] calling  init_fs_stat_sysctls+0x0/0x40 @ 1
[   35.469470] initcall init_fs_stat_sysctls+0x0/0x40 returned 0 after 80 u=
secs
[   35.477363] calling  init_fs_exec_sysctls+0x0/0x30 @ 1
[   35.483337] initcall init_fs_exec_sysctls+0x0/0x30 returned 0 after 29 u=
secs
[   35.491222] calling  init_pipe_fs+0x0/0x70 @ 1
[   35.497487] initcall init_pipe_fs+0x0/0x70 returned 0 after 1017 usecs
[   35.504864] calling  init_fs_namei_sysctls+0x0/0x30 @ 1
[   35.510941] initcall init_fs_namei_sysctls+0x0/0x30 returned 0 after 36 =
usecs
[   35.518912] calling  init_fs_dcache_sysctls+0x0/0x30 @ 1
[   35.525057] initcall init_fs_dcache_sysctls+0x0/0x30 returned 0 after 22=
 usecs
[   35.533115] calling  init_fs_namespace_sysctls+0x0/0x30 @ 1
[   35.539527] initcall init_fs_namespace_sysctls+0x0/0x30 returned 0 after=
 28 usecs
[   35.547854] calling  cgroup_writeback_init+0x0/0x30 @ 1
[   35.554063] initcall cgroup_writeback_init+0x0/0x30 returned 0 after 180=
 usecs
[   35.562128] calling  inotify_user_setup+0x0/0x1c0 @ 1
[   35.568300] initcall inotify_user_setup+0x0/0x1c0 returned 0 after 304 u=
secs
[   35.576190] calling  eventpoll_init+0x0/0x170 @ 1
[   35.582421] initcall eventpoll_init+0x0/0x170 returned 0 after 717 usecs
[   35.589958] calling  anon_inode_init+0x0/0xa0 @ 1
[   35.596431] initcall anon_inode_init+0x0/0xa0 returned 0 after 957 usecs
[   35.603972] calling  init_dax_wait_table+0x0/0x40 @ 1
[   35.609906] initcall init_dax_wait_table+0x0/0x40 returned 0 after 70 us=
ecs
[   35.618808] calling  proc_locks_init+0x0/0x30 @ 1
[   35.624353] initcall proc_locks_init+0x0/0x30 returned 0 after 29 usecs
[   35.631805] calling  init_fs_coredump_sysctls+0x0/0x30 @ 1
[   35.638181] initcall init_fs_coredump_sysctls+0x0/0x30 returned 0 after =
38 usecs
[   35.646415] calling  iomap_init+0x0/0x30 @ 1
[   35.652786] initcall iomap_init+0x0/0x30 returned 0 after 1259 usecs
[   35.659965] calling  dquot_init+0x0/0x190 @ 1
[   35.665134] VFS: Disk quotas dquot_6.6.0
[   35.671241] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[   35.678978] initcall dquot_init+0x0/0x190 returned 0 after 13844 usecs
[   35.686349] calling  quota_init+0x0/0x30 @ 1
[   35.691688] initcall quota_init+0x0/0x30 returned 0 after 263 usecs
[   35.698786] calling  proc_cmdline_init+0x0/0xd0 @ 1
[   35.704503] initcall proc_cmdline_init+0x0/0xd0 returned 0 after 22 usec=
s
[   35.712123] calling  proc_consoles_init+0x0/0x30 @ 1
[   35.717923] initcall proc_consoles_init+0x0/0x30 returned 0 after 19 use=
cs
[   35.725635] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[   35.731343] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 19 usec=
s
[   35.738962] calling  proc_devices_init+0x0/0x80 @ 1
[   35.744675] initcall proc_devices_init+0x0/0x80 returned 0 after 25 usec=
s
[   35.752299] calling  proc_interrupts_init+0x0/0x30 @ 1
[   35.758272] initcall proc_interrupts_init+0x0/0x30 returned 0 after 19 u=
secs
[   35.766157] calling  proc_loadavg_init+0x0/0x70 @ 1
[   35.771859] initcall proc_loadavg_init+0x0/0x70 returned 0 after 18 usec=
s
[   35.779478] calling  proc_meminfo_init+0x0/0x70 @ 1
[   35.785185] initcall proc_meminfo_init+0x0/0x70 returned 0 after 18 usec=
s
[   35.792806] calling  proc_stat_init+0x0/0x30 @ 1
[   35.798248] initcall proc_stat_init+0x0/0x30 returned 0 after 19 usecs
[   35.805608] calling  proc_uptime_init+0x0/0x70 @ 1
[   35.811236] initcall proc_uptime_init+0x0/0x70 returned 0 after 22 usecs
[   35.818776] calling  proc_version_init+0x0/0x70 @ 1
[   35.824545] initcall proc_version_init+0x0/0x70 returned 0 after 20 usec=
s
[   35.832167] calling  proc_softirqs_init+0x0/0x70 @ 1
[   35.837961] initcall proc_softirqs_init+0x0/0x70 returned 0 after 23 use=
cs
[   35.845680] calling  proc_kcore_init+0x0/0x2c0 @ 1
[   35.851507] initcall proc_kcore_init+0x0/0x2c0 returned 0 after 224 usec=
s
[   35.859129] calling  vmcore_init+0x0/0x360 @ 1
[   35.864386] initcall vmcore_init+0x0/0x360 returned 0 after 0 usecs
[   35.871468] calling  proc_kmsg_init+0x0/0x30 @ 1
[   35.876916] initcall proc_kmsg_init+0x0/0x30 returned 0 after 20 usecs
[   35.884277] calling  proc_page_init+0x0/0x60 @ 1
[   35.889753] initcall proc_page_init+0x0/0x60 returned 0 after 53 usecs
[   35.897111] calling  init_ramfs_fs+0x0/0x20 @ 1
[   35.902451] initcall init_ramfs_fs+0x0/0x20 returned 0 after 2 usecs
[   35.909619] calling  init_hugetlbfs_fs+0x0/0x370 @ 1
[   35.917476] initcall init_hugetlbfs_fs+0x0/0x370 returned 0 after 2080 u=
secs
[   35.925372] calling  aa_create_aafs+0x0/0x940 @ 1
[   35.935012] AppArmor: AppArmor Filesystem Enabled
[   35.940547] initcall aa_create_aafs+0x0/0x940 returned 0 after 9663 usec=
s
[   35.948174] calling  dynamic_debug_init_control+0x0/0x80 @ 1
[   35.954780] initcall dynamic_debug_init_control+0x0/0x80 returned 0 afte=
r 134 usecs
[   35.963272] calling  acpi_event_init+0x0/0x70 @ 1
[   35.969021] initcall acpi_event_init+0x0/0x70 returned 0 after 230 usecs
[   35.976563] calling  pnp_system_init+0x0/0x20 @ 1
[   35.982284] initcall pnp_system_init+0x0/0x20 returned 0 after 209 usecs
[   35.989868] calling  pnpacpi_init+0x0/0xf0 @ 1
[   35.995126] pnp: PnP ACPI init
[   36.055401] system 00:01: [io  0x0500-0x057f] has been reserved
[   36.064398] system 00:01: [io  0x0400-0x047f] has been reserved
[   36.071447] system 00:01: [io  0x0580-0x059f] has been reserved
[   36.078233] system 00:01: [io  0x0600-0x061f] has been reserved
[   36.085017] system 00:01: [io  0x0880-0x0883] has been reserved
[   36.091818] system 00:01: [io  0x0800-0x081f] has been reserved
[   36.098668] system 00:01: [mem 0xfed1c000-0xfed3ffff] could not be reser=
ved
[   36.106524] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
[   36.114027] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
[   36.121528] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[   36.129026] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
[   36.136529] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
[   36.144026] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[   36.151695] probe of 00:01 returned 0 after 96646 usecs
[   36.186610] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[   36.193420] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[   36.200208] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[   36.206995] system 00:02: [io  0x0a30-0x0a3f] has been reserved
[   36.213796] system 00:02: [io  0x0a40-0x0a4f] has been reserved
[   36.220681] probe of 00:02 returned 0 after 35635 usecs
[   36.251959] pnp 00:03: [dma 0 disabled]
[   36.286696] pnp 00:04: [dma 0 disabled]
[   36.337170] pnp: PnP ACPI: found 5 devices
[   36.342088] initcall pnpacpi_init+0x0/0xf0 returned 0 after 346962 usecs
[   36.349638] calling  chr_dev_init+0x0/0x160 @ 1
[   36.406925] initcall chr_dev_init+0x0/0x160 returned 0 after 51945 usecs
[   36.414589] calling  hwrng_modinit+0x0/0x100 @ 1
[   36.420820] initcall hwrng_modinit+0x0/0x100 returned 0 after 795 usecs
[   36.428294] calling  firmware_class_init+0x0/0x100 @ 1
[   36.434443] initcall firmware_class_init+0x0/0x100 returned 0 after 191 =
usecs
[   36.442419] calling  map_properties+0x0/0x370 @ 1
[   36.447933] initcall map_properties+0x0/0x370 returned 0 after 0 usecs
[   36.455291] calling  init_acpi_pm_clocksource+0x0/0x100 @ 1
[   36.466199] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[   36.475902] initcall init_acpi_pm_clocksource+0x0/0x100 returned 0 after=
 14221 usecs
[   36.484486] calling  powercap_init+0x0/0x20 @ 1
[   36.491219] initcall powercap_init+0x0/0x20 returned 0 after 1393 usecs
[   36.498669] calling  sysctl_core_init+0x0/0x30 @ 1
[   36.504429] initcall sysctl_core_init+0x0/0x30 returned 0 after 153 usec=
s
[   36.512060] calling  eth_offload_init+0x0/0x20 @ 1
[   36.517673] initcall eth_offload_init+0x0/0x20 returned 0 after 1 usecs
[   36.525119] calling  ipv4_offload_init+0x0/0xa0 @ 1
[   36.530802] initcall ipv4_offload_init+0x0/0xa0 returned 0 after 1 usecs
[   36.538333] calling  inet_init+0x0/0x3b0 @ 1
[   36.544903] NET: Registered PF_INET protocol family
[   36.551661] IP idents hash table entries: 262144 (order: 9, 2097152 byte=
s, linear)
[   36.582916] tcp_listen_portaddr_hash hash table entries: 32768 (order: 7=
, 524288 bytes, linear)
[   36.592715] Table-perturb hash table entries: 65536 (order: 6, 262144 by=
tes, linear)
[   36.601927] TCP established hash table entries: 524288 (order: 10, 41943=
04 bytes, linear)
[   36.613467] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes,=
 linear)
[   36.622801] TCP: Hash tables configured (established 524288 bind 65536)
[   36.633866] MPTCP token hash table entries: 65536 (order: 8, 1572864 byt=
es, linear)
[   36.643489] UDP hash table entries: 32768 (order: 8, 1048576 bytes, line=
ar)
[   36.652149] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes,=
 linear)
[   36.663551] initcall inet_init+0x0/0x3b0 returned 0 after 120140 usecs
[   36.670934] calling  af_unix_init+0x0/0x220 @ 1
[   36.676843] NET: Registered PF_UNIX/PF_LOCAL protocol family
[   36.683502] initcall af_unix_init+0x0/0x220 returned 0 after 7228 usecs
[   36.690959] calling  ipv6_offload_init+0x0/0x90 @ 1
[   36.696648] initcall ipv6_offload_init+0x0/0x90 returned 0 after 2 usecs
[   36.704178] calling  init_sunrpc+0x0/0x90 @ 1
[   36.712721] RPC: Registered named UNIX socket transport module.
[   36.719543] RPC: Registered udp transport module.
[   36.725059] RPC: Registered tcp transport module.
[   36.730574] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   36.737830] initcall init_sunrpc+0x0/0x90 returned 0 after 28489 usecs
[   36.745202] calling  vlan_offload_init+0x0/0x30 @ 1
[   36.750892] initcall vlan_offload_init+0x0/0x30 returned 0 after 1 usecs
[   36.759521] calling  xsk_init+0x0/0x220 @ 1
[   36.764528] NET: Registered PF_XDP protocol family
[   36.770152] initcall xsk_init+0x0/0x220 returned 0 after 5641 usecs
[   36.777261] calling  pcibios_assign_resources+0x0/0x320 @ 1
[   36.783746] pci 0000:00:01.0: PCI bridge to [bus 01]
[   36.789540] pci 0000:00:02.0: PCI bridge to [bus 02]
[   36.795316] pci 0000:00:02.0:   bridge window [mem 0xfb300000-0xfb3fffff=
]
[   36.803035] pci 0000:03:00.0: BAR 7: no space for [mem size 0x00100000 6=
4bit]
[   36.811006] pci 0000:03:00.0: BAR 7: failed to assign [mem size 0x001000=
00 64bit]
[   36.819350] pci 0000:03:00.0: BAR 10: no space for [mem size 0x00100000 =
64bit]
[   36.827404] pci 0000:03:00.0: BAR 10: failed to assign [mem size 0x00100=
000 64bit]
[   36.835829] pci 0000:03:00.1: BAR 7: no space for [mem size 0x00100000 6=
4bit]
[   36.843792] pci 0000:03:00.1: BAR 7: failed to assign [mem size 0x001000=
00 64bit]
[   36.852131] pci 0000:03:00.1: BAR 10: no space for [mem size 0x00100000 =
64bit]
[   36.860179] pci 0000:03:00.1: BAR 10: failed to assign [mem size 0x00100=
000 64bit]
[   36.868677] pci 0000:00:02.2: PCI bridge to [bus 03]
[   36.874464] pci 0000:00:02.2:   bridge window [mem 0xfb200000-0xfb2fffff=
]
[   36.882085] pci 0000:00:02.2:   bridge window [mem 0xfba00000-0xfbefffff=
 64bit pref]
[   36.890730] pci 0000:00:03.0: PCI bridge to [bus 04]
[   36.896516] pci 0000:00:1c.0: PCI bridge to [bus 05]
[   36.902295] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[   36.909198] pci 0000:00:1c.0:   bridge window [mem 0xfb100000-0xfb1fffff=
]
[   36.916815] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x900fffff=
 64bit pref]
[   36.925393] pci 0000:06:00.0: PCI bridge to [bus 07]
[   36.931164] pci 0000:06:00.0:   bridge window [io  0xd000-0xdfff]
[   36.938068] pci 0000:06:00.0:   bridge window [mem 0xfa000000-0xfb0fffff=
]
[   36.945702] pci 0000:00:1c.4: PCI bridge to [bus 06-07]
[   36.951729] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[   36.958630] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfb0fffff=
]
[   36.966259] pci_bus 0000:00: Some PCI device resources are unassigned, t=
ry booting with pci=3Drealloc
[   36.976205] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[   36.983202] pci_bus 0000:00: resource 5 [io  0x1000-0xffff window]
[   36.990192] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[   36.997896] pci_bus 0000:00: resource 7 [mem 0x90000000-0xfbffbfff windo=
w]
[   37.005600] pci_bus 0000:02: resource 1 [mem 0xfb300000-0xfb3fffff]
[   37.012681] pci_bus 0000:03: resource 1 [mem 0xfb200000-0xfb2fffff]
[   37.019761] pci_bus 0000:03: resource 2 [mem 0xfba00000-0xfbefffff 64bit=
 pref]
[   37.027809] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[   37.034192] pci_bus 0000:05: resource 1 [mem 0xfb100000-0xfb1fffff]
[   37.041268] pci_bus 0000:05: resource 2 [mem 0x90000000-0x900fffff 64bit=
 pref]
[   37.049319] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[   37.055696] pci_bus 0000:06: resource 1 [mem 0xfa000000-0xfb0fffff]
[   37.062771] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[   37.069145] pci_bus 0000:07: resource 1 [mem 0xfa000000-0xfb0fffff]
[   37.083555] initcall pcibios_assign_resources+0x0/0x320 returned 0 after=
 299907 usecs
[   37.092849] calling  pci_apply_final_quirks+0x0/0x3d0 @ 1
[   37.099589] pci 0000:00:05.0: calling  quirk_disable_intel_boot_interrup=
t+0x0/0x270 @ 1
[   37.109118] pci 0000:00:05.0: disabled boot interrupts on device [8086:6=
f28]
[   37.116994] pci 0000:00:05.0: quirk_disable_intel_boot_interrupt+0x0/0x2=
70 took 7694 usecs
[   37.126144] pci 0000:00:14.0: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.134023] pci 0000:00:14.0: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.141917] pci 0000:00:14.0: calling  quirk_usb_early_handoff+0x0/0x2f0=
 @ 1
[   37.158476] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   37.172988] IOAPIC[0]: Preconfigured routing entry (8-19 -> IRQ 19 Level=
:1 ActiveLow:1)
[   37.190363] pci 0000:00:14.0: quirk_usb_early_handoff+0x0/0x2f0 took 396=
13 usecs
[   37.198627] pci 0000:00:16.0: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.206517] pci 0000:00:16.0: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.214424] pci 0000:00:1a.0: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.222306] pci 0000:00:1a.0: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.230186] pci 0000:00:1a.0: calling  quirk_usb_early_handoff+0x0/0x2f0=
 @ 1
[   37.249629] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   37.264002] IOAPIC[0]: Preconfigured routing entry (8-18 -> IRQ 18 Level=
:1 ActiveLow:1)
[   37.281064] pci 0000:00:1a.0: quirk_usb_early_handoff+0x0/0x2f0 took 419=
86 usecs
[   37.289347] pci 0000:00:1c.4: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.297236] pci 0000:00:1c.4: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.305131] pci 0000:00:1d.0: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.313014] pci 0000:00:1d.0: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.320902] pci 0000:00:1d.0: calling  quirk_usb_early_handoff+0x0/0x2f0=
 @ 1
[   37.338166] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   37.352533] IOAPIC[0]: Preconfigured routing entry (8-18 -> IRQ 18 Level=
:1 ActiveLow:1)
[   37.372513] pci 0000:00:1d.0: quirk_usb_early_handoff+0x0/0x2f0 took 427=
07 usecs
[   37.380904] pci 0000:00:1f.2: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.388792] pci 0000:00:1f.2: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.396682] pci 0000:00:1f.3: calling  quirk_remove_d3hot_delay+0x0/0x50=
 @ 1
[   37.404562] pci 0000:00:1f.3: quirk_remove_d3hot_delay+0x0/0x50 took 0 u=
secs
[   37.412498] pci 0000:03:00.0: calling  quirk_e100_interrupt+0x0/0x2c0 @ =
1
[   37.420117] pci 0000:03:00.0: quirk_e100_interrupt+0x0/0x2c0 took 0 usec=
s
[   37.427743] pci 0000:03:00.0: CLS mismatch (64 !=3D 32), using 64 bytes
[   37.435004] pci 0000:03:00.1: calling  quirk_e100_interrupt+0x0/0x2c0 @ =
1
[   37.442634] pci 0000:03:00.1: quirk_e100_interrupt+0x0/0x2c0 took 0 usec=
s
[   37.450262] pci 0000:05:00.0: calling  quirk_e100_interrupt+0x0/0x2c0 @ =
1
[   37.457885] pci 0000:05:00.0: quirk_e100_interrupt+0x0/0x2c0 took 0 usec=
s
[   37.465513] pci 0000:05:00.1: calling  quirk_e100_interrupt+0x0/0x2c0 @ =
1
[   37.473135] pci 0000:05:00.1: quirk_e100_interrupt+0x0/0x2c0 took 0 usec=
s
[   37.480776] initcall pci_apply_final_quirks+0x0/0x3d0 returned 0 after 3=
81711 usecs
[   37.489265] calling  acpi_reserve_resources+0x0/0x2d0 @ 1
[   37.495598] initcall acpi_reserve_resources+0x0/0x2d0 returned 0 after 1=
19 usecs
[   37.504138] calling  populate_rootfs+0x0/0x50 @ 1
[   37.509688] initcall populate_rootfs+0x0/0x50 returned 0 after 30 usecs
[   37.510787] Trying to unpack rootfs image as initramfs...
[   37.517139] calling  pci_iommu_init+0x0/0x60 @ 1
[   37.517391] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   37.536002] software IO TLB: mapped [mem 0x00000000756e1000-0x0000000079=
6e1000] (64MB)
[   37.544754] initcall pci_iommu_init+0x0/0x60 returned 0 after 27603 usec=
s
[   37.552373] calling  ir_dev_scope_init+0x0/0x70 @ 1
[   37.558065] initcall ir_dev_scope_init+0x0/0x70 returned 0 after 0 usecs
[   37.565609] calling  nhi_init+0x0/0x50 @ 1
[   37.570601] ACPI: bus type thunderbolt registered
[   37.576865] initcall nhi_init+0x0/0x50 returned 0 after 6344 usecs
[   37.584752] calling  ia32_binfmt_init+0x0/0x20 @ 1
[   37.590415] initcall ia32_binfmt_init+0x0/0x20 returned 0 after 54 usecs
[   37.597949] calling  amd_ibs_init+0x0/0x480 @ 1
[   37.603286] initcall amd_ibs_init+0x0/0x480 returned -19 after 0 usecs
[   37.610643] calling  msr_init+0x0/0x90 @ 1
[   37.615854] initcall msr_init+0x0/0x90 returned 0 after 305 usecs
[   37.622762] calling  register_kernel_offset_dumper+0x0/0x20 @ 1
[   37.629493] initcall register_kernel_offset_dumper+0x0/0x20 returned 0 a=
fter 1 usecs
[   37.638063] calling  i8259A_init_ops+0x0/0x30 @ 1
[   37.643583] initcall i8259A_init_ops+0x0/0x30 returned 0 after 1 usecs
[   37.652034] calling  init_tsc_clocksource+0x0/0x170 @ 1
[   37.658080] initcall init_tsc_clocksource+0x0/0x170 returned 0 after 7 u=
secs
[   37.665969] calling  add_rtc_cmos+0x0/0x1c0 @ 1
[   37.671308] initcall add_rtc_cmos+0x0/0x1c0 returned 0 after 1 usecs
[   37.678468] calling  i8237A_init_ops+0x0/0x40 @ 1
[   37.684003] initcall i8237A_init_ops+0x0/0x40 returned 0 after 26 usecs
[   37.691466] calling  umwait_init+0x0/0xf0 @ 1
[   37.696629] initcall umwait_init+0x0/0xf0 returned -19 after 0 usecs
[   37.703788] calling  msr_init+0x0/0x110 @ 1
[   37.723714] initcall msr_init+0x0/0x110 returned 0 after 14935 usecs
[   37.730947] calling  cpuid_init+0x0/0x110 @ 1
[   37.750844] initcall cpuid_init+0x0/0x110 returned 0 after 14722 usecs
[   37.758220] calling  ioapic_init_ops+0x0/0x20 @ 1
[   37.763760] initcall ioapic_init_ops+0x0/0x20 returned 0 after 18 usecs
[   37.771278] calling  register_e820_pmem+0x0/0x80 @ 1
[   37.777063] initcall register_e820_pmem+0x0/0x80 returned 0 after 9 usec=
s
[   37.784699] calling  add_pcspkr+0x0/0xe0 @ 1
[   37.790313] initcall add_pcspkr+0x0/0xe0 returned 0 after 529 usecs
[   37.797410] calling  start_periodic_check_for_corruption+0x0/0x80 @ 1
[   37.804666] initcall start_periodic_check_for_corruption+0x0/0x80 return=
ed 0 after 0 usecs
[   37.813764] calling  audit_classes_init+0x0/0xc0 @ 1
[   37.819730] initcall audit_classes_init+0x0/0xc0 returned 0 after 187 us=
ecs
[   37.827533] calling  sha1_ssse3_mod_init+0x0/0x380 @ 1
[   37.833504] initcall sha1_ssse3_mod_init+0x0/0x380 returned 0 after 26 u=
secs
[   37.841381] calling  sha256_ssse3_mod_init+0x0/0x380 @ 1
[   37.847534] initcall sha256_ssse3_mod_init+0x0/0x380 returned 0 after 37=
 usecs
[   37.855586] calling  iosf_mbi_init+0x0/0x30 @ 1
[   37.861225] initcall iosf_mbi_init+0x0/0x30 returned 0 after 303 usecs
[   37.868588] calling  proc_execdomains_init+0x0/0x30 @ 1
[   37.874651] initcall proc_execdomains_init+0x0/0x30 returned 0 after 29 =
usecs
[   37.882617] calling  register_warn_debugfs+0x0/0x30 @ 1
[   37.888702] initcall register_warn_debugfs+0x0/0x30 returned 0 after 57 =
usecs
[   37.896669] calling  cpuhp_sysfs_init+0x0/0x180 @ 1
[   37.903807] initcall cpuhp_sysfs_init+0x0/0x180 returned 0 after 1449 us=
ecs
[   37.911634] calling  ioresources_init+0x0/0x50 @ 1
[   37.917310] initcall ioresources_init+0x0/0x50 returned 0 after 47 usecs
[   37.924849] calling  snapshot_device_init+0x0/0x20 @ 1
[   37.931372] initcall snapshot_device_init+0x0/0x20 returned 0 after 575 =
usecs
[   37.939367] calling  irq_pm_init_ops+0x0/0x20 @ 1
[   37.944909] initcall irq_pm_init_ops+0x0/0x20 returned 0 after 1 usecs
[   37.952276] calling  klp_init+0x0/0x60 @ 1
[   37.957228] initcall klp_init+0x0/0x60 returned 0 after 49 usecs
[   37.964051] calling  proc_modules_init+0x0/0x30 @ 1
[   37.969784] initcall proc_modules_init+0x0/0x30 returned 0 after 25 usec=
s
[   37.977409] calling  timer_sysctl_init+0x0/0x20 @ 1
[   37.983162] initcall timer_sysctl_init+0x0/0x20 returned 0 after 57 usec=
s
[   37.990794] calling  timekeeping_init_ops+0x0/0x20 @ 1
[   37.996746] initcall timekeeping_init_ops+0x0/0x20 returned 0 after 1 us=
ecs
[   38.004541] calling  init_clocksource_sysfs+0x0/0x30 @ 1
[   38.011629] initcall init_clocksource_sysfs+0x0/0x30 returned 0 after 96=
2 usecs
[   38.019806] calling  init_timer_list_procfs+0x0/0x40 @ 1
[   38.025961] initcall init_timer_list_procfs+0x0/0x40 returned 0 after 31=
 usecs
[   38.034026] calling  alarmtimer_init+0x0/0x120 @ 1
[   38.039850] initcall alarmtimer_init+0x0/0x120 returned 0 after 214 usec=
s
[   38.047475] calling  init_posix_timers+0x0/0x30 @ 1
[   38.053447] initcall init_posix_timers+0x0/0x30 returned 0 after 281 use=
cs
[   38.061158] calling  clockevents_init_sysfs+0x0/0x200 @ 1
[   38.074614] initcall clockevents_init_sysfs+0x0/0x200 returned 0 after 7=
244 usecs
[   38.083051] calling  proc_dma_init+0x0/0x30 @ 1
[   38.088465] initcall proc_dma_init+0x0/0x30 returned 0 after 60 usecs
[   38.095848] calling  kallsyms_init+0x0/0x30 @ 1
[   38.101249] initcall kallsyms_init+0x0/0x30 returned 0 after 52 usecs
[   38.108529] calling  pid_namespaces_init+0x0/0x50 @ 1
[   38.114692] initcall pid_namespaces_init+0x0/0x50 returned 0 after 298 u=
secs
[   38.122578] calling  ikconfig_init+0x0/0x50 @ 1
[   38.127935] initcall ikconfig_init+0x0/0x50 returned 0 after 22 usecs
[   38.135183] calling  audit_watch_init+0x0/0x50 @ 1
[   38.140800] initcall audit_watch_init+0x0/0x50 returned 0 after 19 usecs
[   38.148331] calling  audit_fsnotify_init+0x0/0x50 @ 1
[   38.154204] initcall audit_fsnotify_init+0x0/0x50 returned 0 after 17 us=
ecs
[   38.161997] calling  audit_tree_init+0x0/0xe0 @ 1
[   38.167764] initcall audit_tree_init+0x0/0xe0 returned 0 after 249 usecs
[   38.175293] calling  seccomp_sysctl_init+0x0/0x30 @ 1
[   38.181225] initcall seccomp_sysctl_init+0x0/0x30 returned 0 after 76 us=
ecs
[   38.189027] calling  utsname_sysctl_init+0x0/0x20 @ 1
[   38.195004] initcall utsname_sysctl_init+0x0/0x20 returned 0 after 101 u=
secs
[   38.202902] calling  init_tracepoints+0x0/0x30 @ 1
[   38.208502] initcall init_tracepoints+0x0/0x30 returned 0 after 2 usecs
[   38.215942] calling  init_lstats_procfs+0x0/0x40 @ 1
[   38.221774] initcall init_lstats_procfs+0x0/0x40 returned 0 after 58 use=
cs
[   38.229483] calling  stack_trace_init+0x0/0xb0 @ 1
[   38.235239] initcall stack_trace_init+0x0/0xb0 returned 0 after 152 usec=
s
[   38.242863] calling  perf_event_sysfs_init+0x0/0x140 @ 1
[   38.254706] initcall perf_event_sysfs_init+0x0/0x140 returned 0 after 57=
18 usecs
[   38.262954] calling  system_trusted_keyring_init+0x0/0xa0 @ 1
[   38.269509] Initialise system trusted keyrings
[   38.274804] initcall system_trusted_keyring_init+0x0/0xa0 returned 0 aft=
er 5295 usecs
[   38.283473] calling  blacklist_init+0x0/0x1f0 @ 1
[   38.288983] Key type blacklist registered
[   38.293847] initcall blacklist_init+0x0/0x1f0 returned 0 after 4865 usec=
s
[   38.301471] calling  kswapd_init+0x0/0x60 @ 1
[   38.307047] initcall kswapd_init+0x0/0x60 returned 0 after 414 usecs
[   38.314230] calling  extfrag_debug_init+0x0/0x60 @ 1
[   38.320202] initcall extfrag_debug_init+0x0/0x60 returned 0 after 190 us=
ecs
[   38.328022] calling  mm_compute_batch_init+0x0/0x60 @ 1
[   38.334066] initcall mm_compute_batch_init+0x0/0x60 returned 0 after 2 u=
secs
[   38.341950] calling  slab_proc_init+0x0/0x30 @ 1
[   38.347399] initcall slab_proc_init+0x0/0x30 returned 0 after 25 usecs
[   38.354758] calling  workingset_init+0x0/0x100 @ 1
[   38.360356] workingset: timestamp_bits=3D36 max_order=3D24 bucket_order=
=3D0
[   38.367627] initcall workingset_init+0x0/0x100 returned 0 after 7271 use=
cs
[   38.375334] calling  proc_vmalloc_init+0x0/0x70 @ 1
[   38.381038] initcall proc_vmalloc_init+0x0/0x70 returned 0 after 22 usec=
s
[   38.388668] calling  procswaps_init+0x0/0x30 @ 1
[   38.394144] initcall procswaps_init+0x0/0x30 returned 0 after 45 usecs
[   38.401525] calling  init_frontswap+0x0/0xa0 @ 1
[   38.407184] initcall init_frontswap+0x0/0xa0 returned 0 after 229 usecs
[   38.414635] calling  slab_debugfs_init+0x0/0x70 @ 1
[   38.420380] initcall slab_debugfs_init+0x0/0x70 returned 0 after 61 usec=
s
[   38.427997] calling  init_zbud+0x0/0x30 @ 1
[   38.432996] zbud: loaded
[   38.436332] initcall init_zbud+0x0/0x30 returned 0 after 3336 usecs
[   38.443404] calling  zs_init+0x0/0x80 @ 1
[   38.448559] initcall zs_init+0x0/0x80 returned 0 after 346 usecs
[   38.455375] calling  damon_dbgfs_init+0x0/0x430 @ 1
[   38.461474] initcall damon_dbgfs_init+0x0/0x430 returned 0 after 417 use=
cs
[   38.469187] calling  fcntl_init+0x0/0x30 @ 1
[   38.474573] initcall fcntl_init+0x0/0x30 returned 0 after 306 usecs
[   38.481675] calling  proc_filesystems_init+0x0/0x30 @ 1
[   38.487732] initcall proc_filesystems_init+0x0/0x30 returned 0 after 25 =
usecs
[   38.495699] calling  start_dirtytime_writeback+0x0/0x70 @ 1
[   38.502085] initcall start_dirtytime_writeback+0x0/0x70 returned 0 after=
 2 usecs
[   38.510318] calling  dio_init+0x0/0x40 @ 1
[   38.515453] initcall dio_init+0x0/0x40 returned 0 after 231 usecs
[   38.522365] calling  dnotify_init+0x0/0xb0 @ 1
[   38.528133] initcall dnotify_init+0x0/0xb0 returned 0 after 520 usecs
[   38.535392] calling  fanotify_user_setup+0x0/0x230 @ 1
[   38.542278] initcall fanotify_user_setup+0x0/0x230 returned 0 after 938 =
usecs
[   38.550261] calling  aio_setup+0x0/0xa0 @ 1
[   38.556706] initcall aio_setup+0x0/0xa0 returned 0 after 1456 usecs
[   38.563793] calling  mbcache_init+0x0/0x40 @ 1
[   38.569290] initcall mbcache_init+0x0/0x40 returned 0 after 243 usecs
[   38.577651] calling  init_grace+0x0/0x20 @ 1
[   38.582780] initcall init_grace+0x0/0x20 returned 0 after 49 usecs
[   38.589804] calling  init_v2_quota_format+0x0/0x30 @ 1
[   38.595757] initcall init_v2_quota_format+0x0/0x30 returned 0 after 0 us=
ecs
[   38.603550] calling  init_devpts_fs+0x0/0x40 @ 1
[   38.609041] initcall init_devpts_fs+0x0/0x40 returned 0 after 60 usecs
[   38.616408] calling  ext4_init_fs+0x0/0x1c0 @ 1
[   38.626679] initcall ext4_init_fs+0x0/0x1c0 returned 0 after 4934 usecs
[   38.634135] calling  journal_init+0x0/0x130 @ 1
[   38.640836] initcall journal_init+0x0/0x130 returned 0 after 1360 usecs
[   38.648297] calling  init_nfs_fs+0x0/0x1c0 @ 1
[   38.656962] initcall init_nfs_fs+0x0/0x1c0 returned 0 after 3403 usecs
[   38.664351] calling  init_nfs_v3+0x0/0x20 @ 1
[   38.669518] initcall init_nfs_v3+0x0/0x20 returned 0 after 1 usecs
[   38.676510] calling  init_nlm+0x0/0x70 @ 1
[   38.681505] initcall init_nlm+0x0/0x70 returned 0 after 91 usecs
[   38.688324] calling  init_nls_cp437+0x0/0x20 @ 1
[   38.693746] initcall init_nls_cp437+0x0/0x20 returned 0 after 1 usecs
[   38.700991] calling  init_nls_ascii+0x0/0x20 @ 1
[   38.701124] tsc: Refined TSC clocksource calibration: 2099.998 MHz
[   38.706415] initcall init_nls_ascii+0x0/0x20 returned 0 after 0 usecs
[   38.706425] calling  init_autofs_fs+0x0/0x40 @ 1
[   38.706550] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1e4=
52ea631d, max_idle_ns: 440795244572 ns
[   38.707286] initcall init_autofs_fs+0x0/0x40 returned 0 after 651 usecs
[   38.744378] calling  efivarfs_init+0x0/0x20 @ 1
[   38.749736] initcall efivarfs_init+0x0/0x20 returned 0 after 4 usecs
[   38.756916] calling  ipc_init+0x0/0x30 @ 1
[   38.761871] clocksource: Switched to clocksource tsc
[   38.762466] initcall ipc_init+0x0/0x30 returned 0 after 628 usecs
[   38.774553] calling  ipc_sysctl_init+0x0/0x30 @ 1
[   38.780196] initcall ipc_sysctl_init+0x0/0x30 returned 0 after 135 usecs
[   38.787734] calling  init_mqueue_fs+0x0/0x100 @ 1
[   38.794563] initcall init_mqueue_fs+0x0/0x100 returned 0 after 1321 usec=
s
[   38.802194] calling  key_proc_init+0x0/0x80 @ 1
[   38.807578] initcall key_proc_init+0x0/0x80 returned 0 after 42 usecs
[   38.814828] calling  selinux_nf_ip_init+0x0/0x70 @ 1
[   38.820595] initcall selinux_nf_ip_init+0x0/0x70 returned 0 after 0 usec=
s
[   38.828219] calling  init_sel_fs+0x0/0x250 @ 1
[   38.833467] initcall init_sel_fs+0x0/0x250 returned 0 after 0 usecs
[   38.840539] calling  selnl_init+0x0/0x110 @ 1
[   38.845846] initcall selnl_init+0x0/0x110 returned 0 after 143 usecs
[   38.853030] calling  sel_netif_init+0x0/0xe0 @ 1
[   38.858459] initcall sel_netif_init+0x0/0xe0 returned 0 after 0 usecs
[   38.865704] calling  sel_netnode_init+0x0/0x130 @ 1
[   38.871388] initcall sel_netnode_init+0x0/0x130 returned 0 after 0 usecs
[   38.878911] calling  sel_netport_init+0x0/0x130 @ 1
[   38.884597] initcall sel_netport_init+0x0/0x130 returned 0 after 0 usecs
[   38.892120] calling  aurule_init+0x0/0x50 @ 1
[   38.897306] initcall aurule_init+0x0/0x50 returned 0 after 20 usecs
[   38.904383] calling  apparmor_nf_ip_init+0x0/0x50 @ 1
[   38.910445] initcall apparmor_nf_ip_init+0x0/0x50 returned 0 after 205 u=
secs
[   38.918338] calling  jent_mod_init+0x0/0x40 @ 1
[   38.958218] initcall jent_mod_init+0x0/0x40 returned 0 after 34543 usecs
[   38.965781] calling  af_alg_init+0x0/0x50 @ 1
[   38.970955] NET: Registered PF_ALG protocol family
[   38.976551] initcall af_alg_init+0x0/0x50 returned 0 after 5598 usecs
[   38.983807] calling  algif_skcipher_init+0x0/0x20 @ 1
[   38.989687] initcall algif_skcipher_init+0x0/0x20 returned 0 after 24 us=
ecs
[   38.997482] calling  rng_init+0x0/0x20 @ 1
[   39.002408] initcall rng_init+0x0/0x20 returned 0 after 17 usecs
[   39.009226] calling  algif_aead_init+0x0/0x20 @ 1
[   39.014781] initcall algif_aead_init+0x0/0x20 returned 0 after 45 usecs
[   39.022257] calling  asymmetric_key_init+0x0/0x20 @ 1
[   39.028120] Key type asymmetric registered
[   39.033012] initcall asymmetric_key_init+0x0/0x20 returned 0 after 4893 =
usecs
[   39.040978] calling  x509_key_init+0x0/0x20 @ 1
[   39.046318] Asymmetric key parser 'x509' registered
[   39.051994] Running certificate verification selftests
[   39.062504] Loaded X.509 cert 'Certificate verification self-testing key=
: f58703bb33ce1b73ee02eccdee5b8817518fe3db'
[   39.077372] initcall x509_key_init+0x0/0x20 returned 0 after 31054 usecs
[   39.084924] calling  blkdev_init+0x0/0x30 @ 1
[   39.090866] initcall blkdev_init+0x0/0x30 returned 0 after 774 usecs
[   39.098155] calling  proc_genhd_init+0x0/0x50 @ 1
[   39.103746] initcall proc_genhd_init+0x0/0x50 returned 0 after 72 usecs
[   39.111205] calling  bsg_init+0x0/0x130 @ 1
[   39.116380] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 247)
[   39.124606] initcall bsg_init+0x0/0x130 returned 0 after 8410 usecs
[   39.131683] calling  throtl_init+0x0/0x50 @ 1
[   39.137411] initcall throtl_init+0x0/0x50 returned 0 after 564 usecs
[   39.144589] calling  deadline_init+0x0/0x20 @ 1
[   39.149925] io scheduler mq-deadline registered
[   39.155256] initcall deadline_init+0x0/0x20 returned 0 after 5332 usecs
[   39.162701] calling  kyber_init+0x0/0x20 @ 1
[   39.167778] io scheduler kyber registered
[   39.172587] initcall kyber_init+0x0/0x20 returned 0 after 4810 usecs
[   39.179753] calling  bfq_init+0x0/0xa0 @ 1
[   39.185258] io scheduler bfq registered
[   39.189911] initcall bfq_init+0x0/0xa0 returned 0 after 5256 usecs
[   39.196911] calling  io_uring_init+0x0/0x40 @ 1
[   39.202469] initcall io_uring_init+0x0/0x40 returned 0 after 221 usecs
[   39.209834] calling  blake2s_mod_init+0x0/0x10 @ 1
[   39.215438] initcall blake2s_mod_init+0x0/0x10 returned 0 after 0 usecs
[   39.222884] calling  crc_t10dif_mod_init+0x0/0x60 @ 1
[   39.228862] initcall crc_t10dif_mod_init+0x0/0x60 returned 0 after 120 u=
secs
[   39.236757] calling  percpu_counter_startup+0x0/0x60 @ 1
[   39.243424] initcall percpu_counter_startup+0x0/0x60 returned 0 after 54=
5 usecs
[   39.251576] calling  digsig_init+0x0/0x40 @ 1
[   39.256777] initcall digsig_init+0x0/0x40 returned 0 after 35 usecs
[   39.263862] calling  pcie_portdrv_init+0x0/0x50 @ 1
[   39.281510] IOAPIC[9]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:002C SQ:0 SVT=
:1)
[   39.295890] IOAPIC[1]: Preconfigured routing entry (9-2 -> IRQ 24 Level:=
1 ActiveLow:1)
[   39.311779] probe of 0000:00:01.0 returned 0 after 41322 usecs
[   39.328940] IOAPIC[9]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:002C SQ:0 SVT=
:1)
[   39.343670] IOAPIC[1]: Preconfigured routing entry (9-8 -> IRQ 26 Level:=
1 ActiveLow:1)
[   39.352714] probe of 0000:00:02.0 returned 0 after 34230 usecs
[   39.371309] probe of 0000:00:02.2 returned 0 after 11945 usecs
[   39.390378] IOAPIC[9]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:002C SQ:0 SVT=
:1)
[   39.404772] IOAPIC[1]: Preconfigured routing entry (9-16 -> IRQ 27 Level=
:1 ActiveLow:1)
[   39.421348] probe of 0000:00:03.0 returned 0 after 43384 usecs
[   39.440586] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   39.454962] IOAPIC[0]: Preconfigured routing entry (8-16 -> IRQ 16 Level=
:1 ActiveLow:1)
[   39.466360] probe of 0000:00:1c.0 returned 0 after 38321 usecs
[   39.485644] probe of 0000:00:1c.4 returned 0 after 12621 usecs
[   39.492581] probe of 0000:06:00.0 returned 19 after 269 usecs
[   39.499317] initcall pcie_portdrv_init+0x0/0x50 returned 0 after 229762 =
usecs
[   39.507297] calling  pci_proc_init+0x0/0x80 @ 1
[   39.514374] initcall pci_proc_init+0x0/0x80 returned 0 after 1734 usecs
[   39.522182] calling  pci_hotplug_init+0x0/0x10 @ 1
[   39.527789] initcall pci_hotplug_init+0x0/0x10 returned 0 after 0 usecs
[   39.535235] calling  shpcd_init+0x0/0x60 @ 1
[   39.540780] probe of 0000:06:00.0 returned 19 after 324 usecs
[   39.547565] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   39.555100] initcall shpcd_init+0x0/0x60 returned 0 after 14786 usecs
[   39.562361] calling  pci_stub_init+0x0/0x230 @ 1
[   39.568046] initcall pci_stub_init+0x0/0x230 returned 0 after 261 usecs
[   39.575499] calling  vmd_drv_init+0x0/0x20 @ 1
[   39.581008] initcall vmd_drv_init+0x0/0x20 returned 0 after 258 usecs
[   39.588266] calling  vesafb_driver_init+0x0/0x20 @ 1
[   39.594239] initcall vesafb_driver_init+0x0/0x20 returned 0 after 203 us=
ecs
[   39.602048] calling  efifb_driver_init+0x0/0x20 @ 1
[   39.607975] initcall efifb_driver_init+0x0/0x20 returned 0 after 236 use=
cs
[   39.615712] calling  intel_idle_init+0x0/0x5f0 @ 1
[   39.624309] Monitor-Mwait will be used to enter C-1 state
[   39.632642] Monitor-Mwait will be used to enter C-2 state
[   39.639316] ACPI: \_SB_.SCK0.CP00: Found 2 idle states
[   39.683356] initcall intel_idle_init+0x0/0x5f0 returned 0 after 62045 us=
ecs
[   39.691190] calling  ged_driver_init+0x0/0x20 @ 1
[   39.696920] initcall ged_driver_init+0x0/0x20 returned 0 after 217 usecs
[   39.704463] calling  acpi_ac_init+0x0/0x80 @ 1
[   39.710358] initcall acpi_ac_init+0x0/0x80 returned 0 after 648 usecs
[   39.717630] calling  acpi_button_driver_init+0x0/0xe0 @ 1
[   39.725701] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[   39.736129] ACPI: button: Power Button [PWRB]
[   39.741440] probe of PNP0C0C:00 returned 0 after 17299 usecs
[   39.749401] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[   39.759260] ACPI: button: Power Button [PWRF]
[   39.764624] probe of LNXPWRBN:00 returned 0 after 16702 usecs
[   39.771450] initcall acpi_button_driver_init+0x0/0xe0 returned 0 after 4=
7612 usecs
[   39.779863] calling  acpi_fan_driver_init+0x0/0x20 @ 1
[   39.786014] initcall acpi_fan_driver_init+0x0/0x20 returned 0 after 200 =
usecs
[   39.793997] calling  acpi_processor_driver_init+0x0/0x100 @ 1
[   39.810034] probe of cpu0 returned 0 after 9417 usecs
[   39.827013] probe of cpu1 returned 0 after 11083 usecs
[   39.842155] probe of cpu2 returned 0 after 9139 usecs
[   39.859258] probe of cpu3 returned 0 after 10053 usecs
[   39.874494] probe of cpu4 returned 0 after 9268 usecs
[   39.891537] probe of cpu5 returned 0 after 10563 usecs
[   39.909017] probe of cpu6 returned 0 after 11287 usecs
[   39.925828] probe of cpu7 returned 0 after 10198 usecs
[   39.942862] probe of cpu8 returned 0 after 10734 usecs
[   39.959780] probe of cpu9 returned 0 after 10956 usecs
[   39.976670] probe of cpu10 returned 0 after 9922 usecs
[   39.992733] probe of cpu11 returned 0 after 10081 usecs
[   40.009285] probe of cpu12 returned 0 after 9749 usecs
[   40.024948] probe of cpu13 returned 0 after 9417 usecs
[   40.042297] probe of cpu14 returned 0 after 10939 usecs
[   40.059047] probe of cpu15 returned 0 after 10697 usecs
[   40.066118] initcall acpi_processor_driver_init+0x0/0x100 returned 0 aft=
er 265555 usecs
[   40.075849] calling  acpi_thermal_init+0x0/0x80 @ 1
[   40.082667] initcall acpi_thermal_init+0x0/0x80 returned 0 after 1122 us=
ecs
[   40.090551] calling  acpi_battery_init+0x0/0x80 @ 1
[   40.096276] initcall acpi_battery_init+0x0/0x80 returned 0 after 33 usec=
s
[   40.103894] calling  acpi_hed_driver_init+0x0/0x20 @ 1
[   40.110463] probe of PNP0C33:00 returned 0 after 387 usecs
[   40.116976] initcall acpi_hed_driver_init+0x0/0x20 returned 0 after 7136=
 usecs
[   40.125051] calling  bgrt_init+0x0/0x1d0 @ 1
[   40.130135] initcall bgrt_init+0x0/0x1d0 returned -19 after 0 usecs
[   40.137218] calling  erst_init+0x0/0x570 @ 1
[   40.142861] ERST: Error Record Serialization Table (ERST) support is ini=
tialized.
[   40.151211] pstore: Registered erst as persistent store backend
[   40.158006] initcall erst_init+0x0/0x570 returned 0 after 15711 usecs
[   40.165260] calling  gpio_clk_driver_init+0x0/0x20 @ 1
[   40.171423] initcall gpio_clk_driver_init+0x0/0x20 returned 0 after 209 =
usecs
[   40.179393] calling  plt_clk_driver_init+0x0/0x20 @ 1
[   40.185506] initcall plt_clk_driver_init+0x0/0x20 returned 0 after 250 u=
secs
[   40.193426] calling  dw_pci_driver_init+0x0/0x20 @ 1
[   40.199487] initcall dw_pci_driver_init+0x0/0x20 returned 0 after 285 us=
ecs
[   40.207290] calling  virtio_pci_driver_init+0x0/0x20 @ 1
[   40.213659] initcall virtio_pci_driver_init+0x0/0x20 returned 0 after 24=
6 usecs
[   40.221814] calling  n_null_init+0x0/0x20 @ 1
[   40.226976] initcall n_null_init+0x0/0x20 returned 0 after 0 usecs
[   40.233971] calling  pty_init+0x0/0x20 @ 1
[   40.239787] initcall pty_init+0x0/0x20 returned 0 after 898 usecs
[   40.246720] calling  sysrq_init+0x0/0x70 @ 1
[   40.251901] initcall sysrq_init+0x0/0x70 returned 0 after 100 usecs
[   40.259022] calling  serial8250_init+0x0/0x3d0 @ 1
[   40.264633] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   40.272381] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   40.282569] probe of 00:03 returned 0 after 10549 usecs
[   40.288941] 00:04: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200) =
is a 16550A
[   40.299071] probe of 00:04 returned 0 after 10448 usecs
[   40.309128] probe of serial8250 returned 0 after 337 usecs
[   40.315606] initcall serial8250_init+0x0/0x3d0 returned 0 after 50973 us=
ecs
[   40.323420] calling  serial_pci_driver_init+0x0/0x20 @ 1
[   40.330026] initcall serial_pci_driver_init+0x0/0x20 returned 0 after 47=
9 usecs
[   40.338181] calling  exar_pci_driver_init+0x0/0x20 @ 1
[   40.344395] initcall exar_pci_driver_init+0x0/0x20 returned 0 after 264 =
usecs
[   40.352370] calling  dw8250_platform_driver_init+0x0/0x20 @ 1
[   40.359121] initcall dw8250_platform_driver_init+0x0/0x20 returned 0 aft=
er 196 usecs
[   40.367699] calling  lpss8250_pci_driver_init+0x0/0x20 @ 1
[   40.374281] initcall lpss8250_pci_driver_init+0x0/0x20 returned 0 after =
277 usecs
[   40.382657] calling  mid8250_pci_driver_init+0x0/0x20 @ 1
[   40.389236] initcall mid8250_pci_driver_init+0x0/0x20 returned 0 after 3=
64 usecs
[   40.397494] calling  pericom8250_pci_driver_init+0x0/0x20 @ 1
[   40.404330] initcall pericom8250_pci_driver_init+0x0/0x20 returned 0 aft=
er 275 usecs
[   40.412914] calling  random_sysctls_init+0x0/0x30 @ 1
[   40.418845] initcall random_sysctls_init+0x0/0x30 returned 0 after 67 us=
ecs
[   40.426641] calling  hpet_init+0x0/0x90 @ 1
[   40.436369] probe of PNP0103:00 returned 19 after 3862 usecs
[   40.443335] initcall hpet_init+0x0/0x90 returned 0 after 11706 usecs
[   40.450571] calling  nvram_module_init+0x0/0x90 @ 1
[   40.457435] Non-volatile memory driver v1.3
[   40.462609] initcall nvram_module_init+0x0/0x90 returned 0 after 6305 us=
ecs
[   40.470417] calling  virtio_rng_driver_init+0x0/0x20 @ 1
[   40.476912] initcall virtio_rng_driver_init+0x0/0x20 returned 0 after 37=
0 usecs
[   40.485420] calling  init_tis+0x0/0x170 @ 1
[   40.490827] initcall init_tis+0x0/0x170 returned 0 after 412 usecs
[   40.497829] calling  crb_acpi_driver_init+0x0/0x20 @ 1
[   40.504153] initcall crb_acpi_driver_init+0x0/0x20 returned 0 after 375 =
usecs
[   40.512315] calling  cn_proc_init+0x0/0x40 @ 1
[   40.517661] initcall cn_proc_init+0x0/0x40 returned 0 after 90 usecs
[   40.524870] calling  topology_sysfs_init+0x0/0x30 @ 1
[   40.536996] initcall topology_sysfs_init+0x0/0x30 returned 0 after 6253 =
usecs
[   40.544985] calling  cacheinfo_sysfs_init+0x0/0x30 @ 1
[   40.579749] initcall cacheinfo_sysfs_init+0x0/0x30 returned 0 after 2879=
8 usecs
[   40.587937] calling  devcoredump_init+0x0/0x20 @ 1
[   40.593712] initcall devcoredump_init+0x0/0x20 returned 0 after 164 usec=
s
[   40.601343] calling  lpc_ich_driver_init+0x0/0x20 @ 1
[   40.608973] ACPI Warning: SystemIO range 0x0000000000000428-0x0000000000=
00042F conflicts with OpRegion 0x0000000000000428-0x000000000000042F (\GPE0=
) (20230331/utaddress-204)
[   40.625356] ACPI: OSL: Resource conflict; ACPI support missing from driv=
er?
[   40.633178] ACPI Warning: SystemIO range 0x0000000000000500-0x0000000000=
00052F conflicts with OpRegion 0x000000000000052C-0x000000000000052D (\GPIV=
) (20230331/utaddress-204)
[   40.649540] ACPI: OSL: Resource conflict; ACPI support missing from driv=
er?
[   40.658488] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   40.666787] probe of 0000:00:1f.0 returned 0 after 59248 usecs
[   40.673667] initcall lpc_ich_driver_init+0x0/0x20 returned 0 after 66460=
 usecs
[   40.681735] calling  intel_lpss_init+0x0/0x30 @ 1
[   40.687310] initcall intel_lpss_init+0x0/0x30 returned 0 after 60 usecs
[   40.694758] calling  intel_lpss_pci_driver_init+0x0/0x20 @ 1
[   40.701864] initcall intel_lpss_pci_driver_init+0x0/0x20 returned 0 afte=
r 634 usecs
[   40.710360] calling  intel_lpss_acpi_driver_init+0x0/0x20 @ 1
[   40.717114] initcall intel_lpss_acpi_driver_init+0x0/0x20 returned 0 aft=
er 207 usecs
[   40.725703] calling  hmem_init+0x0/0x30 @ 1
[   40.730700] initcall hmem_init+0x0/0x30 returned 0 after 10 usecs
[   40.737596] calling  mac_hid_init+0x0/0x30 @ 1
[   40.742951] initcall mac_hid_init+0x0/0x30 returned 0 after 103 usecs
[   40.750247] calling  rdac_init+0x0/0x80 @ 1
[   40.755242] rdac: device handler registered
[   40.761068] initcall rdac_init+0x0/0x80 returned 0 after 5826 usecs
[   40.768198] calling  hp_sw_init+0x0/0x20 @ 1
[   40.773278] hp_sw: device handler registered
[   40.778347] initcall hp_sw_init+0x0/0x20 returned 0 after 5070 usecs
[   40.785505] calling  clariion_init+0x0/0x40 @ 1
[   40.790842] emc: device handler registered
[   40.795746] initcall clariion_init+0x0/0x40 returned 0 after 4905 usecs
[   40.803184] calling  alua_init+0x0/0x70 @ 1
[   40.808936] alua: device handler registered
[   40.814028] initcall alua_init+0x0/0x70 returned 0 after 5861 usecs
[   40.821119] calling  blackhole_netdev_init+0x0/0xe0 @ 1
[   40.827506] initcall blackhole_netdev_init+0x0/0xe0 returned 0 after 349=
 usecs
[   40.835603] calling  phylink_init+0x0/0xc0 @ 1
[   40.840858] initcall phylink_init+0x0/0xc0 returned 0 after 1 usecs
[   40.847932] calling  phy_module_init+0x0/0x20 @ 1
[   40.855144] initcall phy_module_init+0x0/0x20 returned 0 after 592 usecs
[   40.862685] calling  fixed_mdio_bus_init+0x0/0x280 @ 1
[   40.872771] initcall fixed_mdio_bus_init+0x0/0x280 returned 0 after 4143=
 usecs
[   40.880836] calling  phy_module_init+0x0/0x20 @ 1
[   40.889960] initcall phy_module_init+0x0/0x20 returned 0 after 3610 usec=
s
[   40.897611] calling  cavium_ptp_driver_init+0x0/0x20 @ 1
[   40.904006] initcall cavium_ptp_driver_init+0x0/0x20 returned 0 after 27=
1 usecs
[   40.912160] calling  e1000_init_module+0x0/0x80 @ 1
[   40.917843] e1000: Intel(R) PRO/1000 Network Driver
[   40.923519] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   40.930424] initcall e1000_init_module+0x0/0x80 returned 0 after 12581 u=
secs
[   40.938308] calling  e1000_init_module+0x0/0x40 @ 1
[   40.943997] e1000e: Intel(R) PRO/1000 Network Driver
[   40.949761] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   40.957010] initcall e1000_init_module+0x0/0x40 returned 0 after 13012 u=
secs
[   40.964968] calling  igb_init_module+0x0/0x50 @ 1
[   40.970485] igb: Intel(R) Gigabit Ethernet Network Driver
[   40.976682] igb: Copyright (c) 2007-2014 Intel Corporation.
[   41.073585] igb 0000:05:00.0: added PHC on eth0
[   41.079122] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connecti=
on
[   41.086829] igb 0000:05:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 0c:c4:7a:c4:=
ab:7a
[   41.094874] igb 0000:05:00.0: eth0: PBA No: 010A00-000
[   41.100813] igb 0000:05:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 t=
x queue(s)
[   41.109413] probe of 0000:05:00.0 returned 0 after 126187 usecs
[   41.119948] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   41.134506] IOAPIC[0]: Preconfigured routing entry (8-17 -> IRQ 17 Level=
:1 ActiveLow:1)
[   41.230831] igb 0000:05:00.1: added PHC on eth1
[   41.236442] igb 0000:05:00.1: Intel(R) Gigabit Ethernet Network Connecti=
on
[   41.244143] igb 0000:05:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 0c:c4:7a:c4:=
ab:7b
[   41.252196] igb 0000:05:00.1: eth1: PBA No: 010A00-000
[   41.258139] igb 0000:05:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 t=
x queue(s)
[   41.266730] probe of 0000:05:00.1 returned 0 after 150562 usecs
[   41.273669] initcall igb_init_module+0x0/0x50 returned 0 after 303184 us=
ecs
[   41.281473] calling  igc_init_module+0x0/0x50 @ 1
[   41.286989] Intel(R) 2.5G Ethernet Linux Driver
[   41.292341] Copyright(c) 2018 Intel Corporation.
[   41.298162] initcall igc_init_module+0x0/0x50 returned 0 after 11173 use=
cs
[   41.305904] calling  ixgbe_init_module+0x0/0xc0 @ 1
[   41.311594] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver
[   41.318492] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[   41.330362] ACPI Warning: \_SB.PCI0.BR2C._PRT: Return Package has no ele=
ments (empty) (20230331/nsprepkg-94)
[   41.367523] pmd_set_huge: Cannot satisfy [mem 0xfbc00000-0xfbe00000] wit=
h a huge-page mapping due to MTRR override.
[   42.792544] ixgbe 0000:03:00.0: Multiqueue Enabled: Rx Queue count =3D 1=
6, Tx Queue count =3D 16 XDP Queue count =3D 0
[   42.931664] ixgbe 0000:03:00.0: MAC: 5, PHY: 7, PBA No: 020C00-000
[   42.938691] ixgbe 0000:03:00.0: 0c:c4:7a:c4:ad:e6
[   43.075175] ixgbe 0000:03:00.0: Intel(R) 10 Gigabit Network Connection
[   43.087761] probe of 0000:03:00.0 returned 0 after 1761087 usecs
[   43.096486] ACPI Warning: \_SB.PCI0.BR2C._PRT: Return Package has no ele=
ments (empty) (20230331/nsprepkg-94)
[   43.119562] IOAPIC[9]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:002C SQ:0 SVT=
:1)
[   43.134886] IOAPIC[1]: Preconfigured routing entry (9-12 -> IRQ 67 Level=
:1 ActiveLow:1)
[   44.905314] ixgbe 0000:03:00.1: Multiqueue Enabled: Rx Queue count =3D 1=
6, Tx Queue count =3D 16 XDP Queue count =3D 0
[   45.044624] ixgbe 0000:03:00.1: MAC: 5, PHY: 7, PBA No: 020C00-000
[   45.051653] ixgbe 0000:03:00.1: 0c:c4:7a:c4:ad:e7
[   45.188207] ixgbe 0000:03:00.1: Intel(R) 10 Gigabit Network Connection
[   45.200845] probe of 0000:03:00.1 returned 0 after 2106211 usecs
[   45.207886] initcall ixgbe_init_module+0x0/0xc0 returned 0 after 3896291=
 usecs
[   45.215955] calling  i40e_init_module+0x0/0xd0 @ 1
[   45.221559] i40e: Intel(R) Ethernet Connection XL710 Network Driver
[   45.228629] i40e: Copyright (c) 2013 - 2019 Intel Corporation.
[   45.236451] initcall i40e_init_module+0x0/0xd0 returned 0 after 14890 us=
ecs
[   45.244278] calling  rtl8169_pci_driver_init+0x0/0x20 @ 1
[   45.250856] initcall rtl8169_pci_driver_init+0x0/0x20 returned 0 after 3=
57 usecs
[   45.259126] calling  rtl8152_driver_init+0x0/0x40 @ 1
[   45.265230] usbcore: registered new device driver r8152-cfgselector
[   45.272543] usbcore: registered new interface driver r8152
[   45.278840] initcall rtl8152_driver_init+0x0/0x40 returned 0 after 13841=
 usecs
[   45.286898] calling  asix_driver_init+0x0/0x20 @ 1
[   45.292745] usbcore: registered new interface driver asix
[   45.298952] initcall asix_driver_init+0x0/0x20 returned 0 after 6458 use=
cs
[   45.306667] calling  ax88179_178a_driver_init+0x0/0x20 @ 1
[   45.313224] usbcore: registered new interface driver ax88179_178a
[   45.320130] initcall ax88179_178a_driver_init+0x0/0x20 returned 0 after =
7156 usecs
[   45.328531] calling  usbnet_init+0x0/0x30 @ 1
[   45.333697] initcall usbnet_init+0x0/0x30 returned 0 after 2 usecs
[   45.340691] calling  netvsc_drv_init+0x0/0x70 @ 1
[   45.346203] hv_vmbus: registering driver hv_netvsc
[   45.351798] initcall netvsc_drv_init+0x0/0x70 returned -19 after 5595 us=
ecs
[   45.359591] calling  usbport_trig_init+0x0/0x20 @ 1
[   45.365305] initcall usbport_trig_init+0x0/0x20 returned 0 after 28 usec=
s
[   45.372966] calling  mon_init+0x0/0x1b0 @ 1
[   45.379170] initcall mon_init+0x0/0x1b0 returned 0 after 1214 usecs
[   45.386267] calling  ehci_hcd_init+0x0/0x1b0 @ 1
[   45.391748] initcall ehci_hcd_init+0x0/0x1b0 returned 0 after 49 usecs
[   45.399103] calling  ehci_pci_init+0x0/0x60 @ 1
[   45.404861] initcall ehci_pci_init+0x0/0x60 returned 0 after 419 usecs
[   45.412267] calling  ohci_hcd_mod_init+0x0/0xb0 @ 1
[   45.418010] initcall ohci_hcd_mod_init+0x0/0xb0 returned 0 after 56 usec=
s
[   45.420706] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   45.425642] calling  ohci_pci_init+0x0/0x60 @ 1
[   45.425840] IOAPIC[0]: Preconfigured routing entry (8-18 -> IRQ 18 Level=
:1 ActiveLow:1)
[   45.426186] initcall ohci_pci_init+0x0/0x60 returned 0 after 278 usecs
[   45.440910] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   45.445544] calling  uhci_hcd_init+0x0/0x150 @ 1
[   45.447050] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus =
number 1
[   45.455048] initcall uhci_hcd_init+0x0/0x150 returned 0 after 596 usecs
[   45.461883] ehci-pci 0000:00:1d.0: debug port 2
[   45.461934] calling  xhci_hcd_init+0x0/0x30 @ 1
[   45.466526] ehci-pci 0000:00:1d.0: irq 18, io mem 0xfb413000
[   45.468129] initcall xhci_hcd_init+0x0/0x30 returned 0 after 58 usecs
[   45.476174] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   45.481678] calling  xhci_pci_init+0x0/0x70 @ 1
[   45.492525] IOAPIC[8]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:F0FF SQ:0 SVT=
:1)
[   45.496617] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 6.04
[   45.499969] IOAPIC[0]: Preconfigured routing entry (8-19 -> IRQ 19 Level=
:1 ActiveLow:1)
[   45.500122] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   45.565251] usb usb1: Product: EHCI Host Controller
[   45.570938] usb usb1: Manufacturer: Linux 6.4.0-rc1-00002-g5f4287fc4655 =
ehci_hcd
[   45.579161] usb usb1: SerialNumber: 0000:00:1d.0
[   45.588892] hub 1-0:1.0: USB hub found
[   45.593867] hub 1-0:1.0: 2 ports detected
[   45.601940] probe of 1-0:1.0 returned 0 after 13395 usecs
[   45.609100] probe of usb1 returned 0 after 21828 usecs
[   45.615893] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   45.616636] probe of 0000:00:1d.0 returned 0 after 211909 usecs
[   45.623306] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus =
number 2
[   45.636971] ehci-pci 0000:00:1a.0: debug port 2
[   45.646496] ehci-pci 0000:00:1a.0: irq 18, io mem 0xfb414000
[   45.659172] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   45.667889] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 6.04
[   45.677013] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   45.685076] usb usb2: Product: EHCI Host Controller
[   45.690761] usb usb2: Manufacturer: Linux 6.4.0-rc1-00002-g5f4287fc4655 =
ehci_hcd
[   45.698976] usb usb2: SerialNumber: 0000:00:1a.0
[   45.708805] hub 2-0:1.0: USB hub found
[   45.714241] hub 2-0:1.0: 2 ports detected
[   45.736686] probe of 2-0:1.0 returned 0 after 28231 usecs
[   45.744976] probe of usb2 returned 0 after 38070 usecs
[   45.752644] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   45.753475] probe of 0000:00:1a.0 returned 0 after 348802 usecs
[   45.760213] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 3
[   45.775430] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x1=
00 quirks 0x0000000000009810
[   45.792244] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   45.799580] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 4
[   45.807959] xhci_hcd 0000:00:14.0: Host supports USB 3.0 SuperSpeed
[   45.817076] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 6.04
[   45.826189] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   45.834238] usb usb3: Product: xHCI Host Controller
[   45.839922] usb usb3: Manufacturer: Linux 6.4.0-rc1-00002-g5f4287fc4655 =
xhci-hcd
[   45.848153] usb usb3: SerialNumber: 0000:00:14.0
[   45.853582] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   45.861741] hub 3-0:1.0: USB hub found
[   45.866750] hub 3-0:1.0: 8 ports detected
[   45.883460] probe of 3-0:1.0 returned 0 after 22096 usecs
[   45.890716] probe of usb3 returned 0 after 30722 usecs
[   45.899987] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003, bcdDevice=3D 6.04
[   45.909127] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   45.917335] usb usb4: Product: xHCI Host Controller
[   45.923019] usb usb4: Manufacturer: Linux 6.4.0-rc1-00002-g5f4287fc4655 =
xhci-hcd
[   45.931241] usb usb4: SerialNumber: 0000:00:14.0
[   45.942807] hub 4-0:1.0: USB hub found
[   45.947822] hub 4-0:1.0: 6 ports detected
[   45.963002] probe of 4-0:1.0 returned 0 after 20566 usecs
[   45.970395] probe of usb4 returned 0 after 29514 usecs
[   45.977322] probe of 0000:00:14.0 returned 0 after 495506 usecs
[   45.983188] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   45.984272] initcall xhci_pci_init+0x0/0x70 returned 0 after 502584 usec=
s
[   45.993141] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
8000, bcdDevice=3D 0.05
[   45.999036] calling  ucsi_acpi_platform_driver_init+0x0/0x20 @ 1
[   45.999193] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   45.999609] initcall ucsi_acpi_platform_driver_init+0x0/0x20 returned 0 =
after 303 usecs
[   46.013495] hub 1-1:1.0: USB hub found
[   46.015198] calling  i8042_init+0x0/0x1b0 @ 1
[   46.015877] hub 1-1:1.0: 4 ports detected
[   46.024020] i8042: PNP: No PS/2 controller found.
[   46.037938] probe of 1-1:1.0 returned 0 after 24915 usecs
[   46.041730] initcall i8042_init+0x0/0x1b0 returned 0 after 18470 usecs
[   46.042704] probe of 1-1 returned 0 after 32181 usecs
[   46.046708] calling  serport_init+0x0/0x30 @ 1
[   46.076502] initcall serport_init+0x0/0x30 returned 0 after 1 usecs
[   46.083587] calling  input_leds_init+0x0/0x20 @ 1
[   46.089356] initcall input_leds_init+0x0/0x20 returned 0 after 253 usecs
[   46.096925] calling  mousedev_init+0x0/0xf0 @ 1
[   46.104204] mousedev: PS/2 mouse device common for all mice
[   46.110638] initcall mousedev_init+0x0/0xf0 returned 0 after 8340 usecs
[   46.118117] calling  evdev_init+0x0/0x20 @ 1
[   46.124846] initcall evdev_init+0x0/0x20 returned 0 after 1641 usecs
[   46.132051] calling  atkbd_init+0x0/0x30 @ 1
[   46.137653] initcall atkbd_init+0x0/0x30 returned 0 after 498 usecs
[   46.138001] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
8008, bcdDevice=3D 0.05
[   46.144799] calling  psmouse_init+0x0/0xa0 @ 1
[   46.144950] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   46.146213] initcall psmouse_init+0x0/0xa0 returned 0 after 1156 usecs
[   46.159293] hub 2-1:1.0: USB hub found
[   46.159410] calling  cmos_init+0x0/0x90 @ 1
[   46.160002] hub 2-1:1.0: 4 ports detected
[   46.168004] rtc_cmos 00:00: RTC can wake from S4
[   46.183593] probe of 2-1:1.0 returned 0 after 24764 usecs
[   46.190143] probe of alarmtimer.2.auto returned 0 after 693 usecs
[   46.195957] probe of 2-1 returned 0 after 39661 usecs
[   46.203397] rtc_cmos 00:00: registered as rtc0
[   46.217189] usb 3-1: new full-speed USB device number 2 using xhci_hcd
[   46.219727] rtc_cmos 00:00: setting system clock to 2014-03-09T08:12:39 =
UTC (1394352759)
[   46.236617] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram
[   46.244296] probe of 00:00 returned 0 after 76650 usecs
[   46.250476] initcall cmos_init+0x0/0x90 returned 0 after 83021 usecs
[   46.257649] calling  smbalert_driver_init+0x0/0x20 @ 1
[   46.263781] initcall smbalert_driver_init+0x0/0x20 returned 0 after 186 =
usecs
[   46.271756] calling  i2c_i801_init+0x0/0x130 @ 1
[   46.277598] initcall i2c_i801_init+0x0/0x130 returned 0 after 405 usecs
[   46.285053] calling  thermal_throttle_init_device+0x0/0x60 @ 1
[   46.296841] i801_smbus 0000:00:1f.3: SPD Write Disable is set
[   46.296966] initcall thermal_throttle_init_device+0x0/0x60 returned 0 af=
ter 5262 usecs
[   46.296992] calling  esb_driver_init+0x0/0x20 @ 1
[   46.303610] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   46.309166] usb 1-1.3: new high-speed USB device number 3 using ehci-pci
[   46.312497] initcall esb_driver_init+0x0/0x20 returned 0 after 297 usecs
[   46.339379] calling  iTCO_wdt_driver_init+0x0/0x20 @ 1
[   46.345953] iTCO_wdt iTCO_wdt.0.auto: Found a Lynx Point TCO device (Ver=
sion=3D2, TCOBASE=3D0x0460)
[   46.357768] iTCO_wdt iTCO_wdt.0.auto: initialized. heartbeat=3D30 sec (n=
owayout=3D0)
[   46.362843] usb 3-1: New USB device found, idVendor=3D14dd, idProduct=3D=
1005, bcdDevice=3D 0.00
[   46.367338] probe of iTCO_wdt.0.auto returned 0 after 21956 usecs
[   46.368996] i2c i2c-2: 3/4 memory slots populated (from DMI)
[   46.369952] probe of 0000:00:1f.3 returned 0 after 92527 usecs
[   46.375038] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[   46.375049] usb 3-1: Product: D2CIM-VUSB
[   46.375056] usb 3-1: Manufacturer: Raritan
[   46.375372] initcall iTCO_wdt_driver_init+0x0/0x20 returned 0 after 3005=
2 usecs
[   46.382059] usb 3-1: SerialNumber: EFFB212D0A6EC00
[   46.390802] usb 1-1.3: New USB device found, idVendor=3D05e3, idProduct=
=3D0610, bcdDevice=3D32.98
[   46.395227] calling  iTCO_vendor_init_module+0x0/0x40 @ 1
[   46.395243] iTCO_vendor_support: vendor-support=3D0
[   46.395247] initcall iTCO_vendor_init_module+0x0/0x40 returned 0 after 4=
 usecs
[   46.395351] usb 1-1.3: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[   46.395448] calling  ghes_edac_init+0x0/0x130 @ 1
[   46.395576] usb 1-1.3: Product: USB2.0 Hub
[   46.395677] initcall ghes_edac_init+0x0/0x130 returned -19 after 1 usecs
[   46.399658] hub 1-1.3:1.0: USB hub found
[   46.400912] probe of 3-1 returned 0 after 16800 usecs
[   46.403740] calling  intel_pstate_init+0x0/0xb70 @ 1
[   46.414181] hub 1-1.3:1.0: 4 ports detected
[   46.421666] intel_pstate: Intel P-state driver initializing
[   46.429860] probe of 1-1.3:1.0 returned 0 after 30496 usecs
[   46.515740] probe of 1-1.3 returned 0 after 118364 usecs
[   46.518110] usb 3-4: new high-speed USB device number 3 using xhci_hcd
[   46.535515] initcall intel_pstate_init+0x0/0xb70 returned 0 after 113903=
 usecs
[   46.543563] calling  haltpoll_init+0x0/0x150 @ 1
[   46.549474] initcall haltpoll_init+0x0/0x150 returned -19 after 0 usecs
[   46.556897] calling  dmi_sysfs_init+0x0/0x240 @ 1
[   46.572435] initcall dmi_sysfs_init+0x0/0x240 returned 0 after 10027 use=
cs
[   46.580133] calling  fw_cfg_sysfs_init+0x0/0xa0 @ 1
[   46.585914] initcall fw_cfg_sysfs_init+0x0/0xa0 returned 0 after 117 use=
cs
[   46.593604] calling  sysfb_init+0x0/0x1c0 @ 1
[   46.599024] initcall sysfb_init+0x0/0x1c0 returned 0 after 277 usecs
[   46.606183] calling  esrt_sysfs_init+0x0/0x270 @ 1
[   46.611763] initcall esrt_sysfs_init+0x0/0x270 returned -38 after 0 usec=
s
[   46.619356] calling  efivars_pstore_init+0x0/0xa0 @ 1
[   46.625195] initcall efivars_pstore_init+0x0/0xa0 returned 0 after 0 use=
cs
[   46.632875] calling  hid_init+0x0/0x50 @ 1
[   46.637940] hid: raw HID events driver (C) Jiri Kosina
[   46.643891] initcall hid_init+0x0/0x50 returned 0 after 6136 usecs
[   46.650859] calling  hid_generic_init+0x0/0x20 @ 1
[   46.655557] usb 3-4: New USB device found, idVendor=3D0557, idProduct=3D=
7000, bcdDevice=3D 0.00
[   46.656528] initcall hid_generic_init+0x0/0x20 returned 0 after 91 usecs
[   46.656561] usb 3-4: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   46.656674] calling  magicmouse_driver_init+0x0/0x20 @ 1
[   46.658763] hub 3-4:1.0: USB hub found
[   46.665825] initcall magicmouse_driver_init+0x0/0x20 returned 0 after 81=
 usecs
[   46.665832] calling  sensor_hub_driver_init+0x0/0x20 @ 1
[   46.673429] hub 3-4:1.0: 4 ports detected
[   46.674537] initcall sensor_hub_driver_init+0x0/0x20 returned 0 after 13=
6 usecs
[   46.684791] probe of 3-4:1.0 returned 0 after 26144 usecs
[   46.688429] calling  hid_init+0x0/0x70 @ 1
[   46.688847] probe of 3-4 returned 0 after 31428 usecs
[   46.701947] input: Raritan D2CIM-VUSB Keyboard as /devices/pci0000:00/00=
00:00:14.0/usb3/3-1/3-1:1.0/0003:14DD:1005.0001/input/input2
[   46.804678] input: Raritan D2CIM-VUSB Mouse as /devices/pci0000:00/0000:=
00:14.0/usb3/3-1/3-1:1.0/0003:14DD:1005.0001/input/input3
[   46.818676] hid-generic 0003:14DD:1005.0001: input,hidraw0: USB HID v1.1=
1 Keyboard [Raritan D2CIM-VUSB] on usb-0000:00:14.0-1/input0
[   46.831576] probe of 0003:14DD:1005.0001 returned 0 after 131762 usecs
[   46.838955] probe of 3-1:1.0 returned 0 after 145835 usecs
[   46.845304] usbcore: registered new interface driver usbhid
[   46.851662] usbhid: USB HID core driver
[   46.856282] initcall hid_init+0x0/0x70 returned 0 after 163211 usecs
[   46.863436] calling  pmc_atom_init+0x0/0x90 @ 1
[   46.868801] initcall pmc_atom_init+0x0/0x90 returned -19 after 46 usecs
[   46.876224] calling  sock_diag_init+0x0/0x40 @ 1
[   46.881809] initcall sock_diag_init+0x0/0x40 returned 0 after 176 usecs
[   46.889253] calling  init_net_drop_monitor+0x0/0x450 @ 1
[   46.895352] drop_monitor: Initializing network drop monitor service
[   46.902548] initcall init_net_drop_monitor+0x0/0x450 returned 0 after 71=
96 usecs
[   46.910754] calling  blackhole_init+0x0/0x20 @ 1
[   46.916161] initcall blackhole_init+0x0/0x20 returned 0 after 1 usecs
[   46.923389] calling  fq_codel_module_init+0x0/0x20 @ 1
[   46.929306] initcall fq_codel_module_init+0x0/0x20 returned 0 after 0 us=
ecs
[   46.937072] calling  init_cgroup_cls+0x0/0x20 @ 1
[   46.942561] initcall init_cgroup_cls+0x0/0x20 returned 0 after 0 usecs
[   46.949891] calling  xt_init+0x0/0x350 @ 1
[   46.954835] initcall xt_init+0x0/0x350 returned 0 after 66 usecs
[   46.961650] calling  tcpudp_mt_init+0x0/0x20 @ 1
[   46.967085] initcall tcpudp_mt_init+0x0/0x20 returned 0 after 35 usecs
[   46.974427] calling  gre_offload_init+0x0/0x60 @ 1
[   46.977141] usb 3-4.1: new low-speed USB device number 4 using xhci_hcd
[   46.980008] initcall gre_offload_init+0x0/0x60 returned 0 after 0 usecs
[   46.980013] calling  sysctl_ipv4_init+0x0/0x50 @ 1
[   47.000607] initcall sysctl_ipv4_init+0x0/0x50 returned 0 after 190 usec=
s
[   47.008254] calling  cubictcp_register+0x0/0x90 @ 1
[   47.013922] initcall cubictcp_register+0x0/0x90 returned 0 after 1 usecs
[   47.021442] calling  xfrm_user_init+0x0/0x40 @ 1
[   47.026866] Initializing XFRM netlink socket
[   47.031982] initcall xfrm_user_init+0x0/0x40 returned 0 after 5116 usecs
[   47.039494] calling  inet6_init+0x0/0x4c0 @ 1
[   47.045389] NET: Registered PF_INET6 protocol family
[   47.055564] Segment Routing with IPv6
[   47.060076] In-situ OAM (IOAM) with IPv6
[   47.064896] initcall inet6_init+0x0/0x4c0 returned 0 after 20262 usecs
[   47.072230] calling  packet_init+0x0/0x90 @ 1
[   47.077378] NET: Registered PF_PACKET protocol family
[   47.083226] initcall packet_init+0x0/0x90 returned 0 after 5859 usecs
[   47.090453] calling  strp_dev_init+0x0/0x40 @ 1
[   47.094681] usb 3-4.1: New USB device found, idVendor=3D0557, idProduct=
=3D2419, bcdDevice=3D 1.00
[   47.096069] initcall strp_dev_init+0x0/0x40 returned 0 after 304 usecs
[   47.104931] usb 3-4.1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[   47.114637] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb=
3/3-4/3-4.1/3-4.1:1.0/0003:0557:2419.0002/input/input4
[   47.120441] calling  init_p9+0x0/0x30 @ 1
[   47.137584] 9pnet: Installing 9P2000 support
[   47.142653] initcall init_p9+0x0/0x30 returned 0 after 5233 usecs
[   47.149535] calling  p9_trans_fd_init+0x0/0x30 @ 1
[   47.155114] initcall p9_trans_fd_init+0x0/0x30 returned 0 after 0 usecs
[   47.162534] calling  p9_virtio_init+0x0/0x60 @ 1
[   47.168024] initcall p9_virtio_init+0x0/0x60 returned 0 after 90 usecs
[   47.175360] calling  dcbnl_init+0x0/0x50 @ 1
[   47.176034] hid-generic 0003:0557:2419.0002: input,hidraw1: USB HID v1.0=
0 Keyboard [HID 0557:2419] on usb-0000:00:14.0-4.1/input0
[   47.180430] initcall dcbnl_init+0x0/0x50 returned 0 after 18 usecs
[   47.180614] probe of 0003:0557:2419.0002 returned 0 after 68041 usecs
[   47.180637] calling  mpls_gso_init+0x0/0x30 @ 1
[   47.180790] probe of 3-4.1:1.0 returned 0 after 69625 usecs
[   47.180822] mpls_gso: MPLS GSO support
[   47.180824] initcall mpls_gso_init+0x0/0x30 returned 0 after 2 usecs
[   47.184321] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb=
3/3-4/3-4.1/3-4.1:1.1/0003:0557:2419.0003/input/input5
[   47.193325] calling  nsh_init_module+0x0/0x20 @ 1
[   47.193330] initcall nsh_init_module+0x0/0x20 returned 0 after 0 usecs
[   47.195192] hid-generic 0003:0557:2419.0003: input,hidraw2: USB HID v1.0=
0 Mouse [HID 0557:2419] on usb-0000:00:14.0-4.1/input1
[   47.200418] calling  handshake_init+0x0/0x90 @ 1
[   47.200574] probe of 0003:0557:2419.0003 returned 0 after 17673 usecs
[   47.200812] initcall handshake_init+0x0/0x90 returned 0 after 192 usecs
[   47.207928] probe of 3-4.1:1.1 returned 0 after 26497 usecs
[   47.207961] calling  pm_check_save_msr+0x0/0x70 @ 1
[   47.208378] probe of 3-4.1 returned 0 after 102787 usecs
[   47.213444] initcall pm_check_save_msr+0x0/0x70 returned 0 after 51 usec=
s
[   47.313291] calling  mcheck_init_device+0x0/0x270 @ 1
[   47.329806] initcall mcheck_init_device+0x0/0x270 returned 0 after 10673=
 usecs
[   47.337871] calling  dev_mcelog_init_device+0x0/0x200 @ 1
[   47.344343] initcall dev_mcelog_init_device+0x0/0x200 returned 0 after 2=
86 usecs
[   47.352894] calling  kernel_do_mounts_initrd_sysctls_init+0x0/0x30 @ 1
[   47.360246] initcall kernel_do_mounts_initrd_sysctls_init+0x0/0x30 retur=
ned 0 after 17 usecs
[   47.369493] calling  tboot_late_init+0x0/0x260 @ 1
[   47.375065] initcall tboot_late_init+0x0/0x260 returned 0 after 0 usecs
[   47.382483] calling  sld_mitigate_sysctl_init+0x0/0x30 @ 1
[   47.388760] initcall sld_mitigate_sysctl_init+0x0/0x30 returned 0 after =
12 usecs
[   47.396961] calling  mcheck_late_init+0x0/0xc0 @ 1
[   47.402625] initcall mcheck_late_init+0x0/0xc0 returned 0 after 87 usecs
[   47.410148] calling  severities_debugfs_init+0x0/0x30 @ 1
[   47.416353] initcall severities_debugfs_init+0x0/0x30 returned 0 after 1=
8 usecs
[   47.424465] calling  microcode_init+0x0/0x250 @ 1
[   47.430471] microcode: Microcode Update Driver: v2.2.
[   47.430476] initcall microcode_init+0x0/0x250 returned 0 after 526 usecs
[   47.443827] calling  hpet_insert_resource+0x0/0x30 @ 1
[   47.449754] initcall hpet_insert_resource+0x0/0x30 returned 0 after 2 us=
ecs
[   47.457520] calling  start_sync_check_timer+0x0/0xc0 @ 1
[   47.463625] initcall start_sync_check_timer+0x0/0xc0 returned 0 after 1 =
usecs
[   47.471569] calling  update_mp_table+0x0/0x820 @ 1
[   47.477140] initcall update_mp_table+0x0/0x820 returned 0 after 0 usecs
[   47.484559] calling  lapic_insert_resource+0x0/0x50 @ 1
[   47.490564] initcall lapic_insert_resource+0x0/0x50 returned 0 after 1 u=
secs
[   47.498417] calling  print_ipi_mode+0x0/0x40 @ 1
[   47.503815] IPI shorthand broadcast: enabled
[   47.508869] initcall print_ipi_mode+0x0/0x40 returned 0 after 5053 usecs
[   47.516373] calling  print_ICs+0x0/0x230 @ 1
[   47.521442] ... APIC ID:      00000000 (0)
[   47.522441] ... APIC VERSION: 01060015
[   47.522441] 000000000000000000000000000000000000000000000000000000000000=
0000
[   47.522441] 000000000000000000000000000000000000000000000000000000000000=
0000
[   47.522441] 000000000000000000000000000000000000000000000000000000000000=
1000

[   47.556741] number of MP IRQ sources: 15.
[   47.561535] number of IO-APIC #8 registers: 24.
[   47.566847] number of IO-APIC #9 registers: 24.
[   47.572159] testing the IO APIC.......................
[   47.578084] IO APIC #8......
[   47.581744] .... register #00: 08000000
[   47.586356] .......    : physical APIC id: 08
[   47.591497] .......    : Delivery Type: 0
[   47.596287] .......    : LTS          : 0
[   47.601070] .... register #01: 00170020
[   47.605691] .......     : max redirection entries: 17
[   47.611524] .......     : PRQ implemented: 0
[   47.616576] .......     : IO APIC version: 20
[   47.621717] .... IRQ redirection table:
[   47.626337] IOAPIC 0:
[   47.629407]  pin00, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.638212]  pin01, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.648109]  pin02, enabled , edge , high, V(02), IRR(0), S(0), remapped=
, I(0001),  Z(0)
[   47.657002]  pin03, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.665815]  pin04, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.674620]  pin05, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.683426]  pin06, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.692231]  pin07, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.701036]  pin08, enabled , edge , high, V(08), IRR(0), S(0), remapped=
, I(0007),  Z(0)
[   47.709927]  pin09, enabled , level, high, V(09), IRR(0), S(0), remapped=
, I(0008),  Z(0)
[   47.718821]  pin0a, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.727625]  pin0b, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.736431]  pin0c, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.745235]  pin0d, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.754041]  pin0e, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.762864]  pin0f, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.771668]  pin10, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.780474]  pin11, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.789279]  pin12, enabled , level, low , V(12), IRR(0), S(0), remapped=
, I(004D),  Z(0)
[   47.798172]  pin13, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.806977]  pin14, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.815791]  pin15, disabled, edge , high, V(54), IRR(0), S(0), remapped=
, I(6C04),  Z(2)
[   47.824684]  pin16, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.833487]  pin17, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.842292] IO APIC #9......
[   47.845956] .... register #00: 09000000
[   47.850574] .......    : physical APIC id: 09
[   47.855715] .......    : Delivery Type: 0
[   47.860508] .......    : LTS          : 0
[   47.865302] .... register #01: 00170020
[   47.869919] .......     : max redirection entries: 17
[   47.875752] .......     : PRQ implemented: 0
[   47.880803] .......     : IO APIC version: 20
[   47.885943] .... register #02: 00000000
[   47.890562] .......     : arbitration: 00
[   47.895346] .... register #03: 00000001
[   47.899956] .......     : Boot DT    : 1
[   47.904655] .... IRQ redirection table:
[   47.909274] IOAPIC 1:
[   47.912326]  pin00, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.921131]  pin01, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.929939]  pin02, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.938743]  pin03, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.947548]  pin04, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.956352]  pin05, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.965157]  pin06, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.973964]  pin07, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.982768]  pin08, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   47.991573]  pin09, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.000382]  pin0a, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.009184]  pin0b, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.017989]  pin0c, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.026811]  pin0d, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.035618]  pin0e, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.044422]  pin0f, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.053229]  pin10, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.062034]  pin11, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.070857]  pin12, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.079662]  pin13, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.088467]  pin14, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.097272]  pin15, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.106078]  pin16, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.114900]  pin17, disabled, edge , high, V(00), IRR(0), S(0), physical=
, D(0000), M(0)
[   48.123704] IRQ to pin mappings:
[   48.127707] IRQ0 -> 0:2
[   48.130939] IRQ1 -> 0:1
[   48.134165] IRQ3 -> 0:3
[   48.137397] IRQ4 -> 0:4
[   48.140621] IRQ5 -> 0:5
[   48.143843] IRQ6 -> 0:6
[   48.147069] IRQ7 -> 0:7
[   48.150301] IRQ8 -> 0:8
[   48.153525] IRQ9 -> 0:9
[   48.156749] IRQ10 -> 0:10
[   48.160147] IRQ11 -> 0:11
[   48.163543] IRQ12 -> 0:12
[   48.166940] IRQ13 -> 0:13
[   48.170339] IRQ14 -> 0:14
[   48.173756] IRQ15 -> 0:15
[   48.177160] IRQ16 -> 0:16
[   48.180564] IRQ17 -> 0:17
[   48.183961] IRQ18 -> 0:18
[   48.187359] IRQ19 -> 0:19
[   48.190756] IRQ24 -> 1:2
[   48.194068] IRQ26 -> 1:8
[   48.197405] IRQ27 -> 1:16
[   48.200813] IRQ67 -> 1:12
[   48.204218] .................................... done.
[   48.210144] initcall print_ICs+0x0/0x230 returned 0 after 688717 usecs
[   48.217477] calling  setup_efi_kvm_sev_migration+0x0/0x10 @ 1
[   48.224012] initcall setup_efi_kvm_sev_migration+0x0/0x10 returned 0 aft=
er 0 usecs
[   48.232382] calling  create_tlb_single_page_flush_ceiling+0x0/0x60 @ 1
[   48.239754] initcall create_tlb_single_page_flush_ceiling+0x0/0x60 retur=
ned 0 after 40 usecs
[   48.248999] calling  pat_memtype_list_init+0x0/0x70 @ 1
[   48.255026] initcall pat_memtype_list_init+0x0/0x70 returned 0 after 16 =
usecs
[   48.262970] calling  create_init_pkru_value+0x0/0x60 @ 1
[   48.269061] initcall create_init_pkru_value+0x0/0x60 returned 0 after 0 =
usecs
[   48.276998] calling  aesni_init+0x0/0x260 @ 1
[   48.282138] AVX2 version of gcm_enc/dec engaged.
[   48.287672] AES CTR mode by8 optimization enabled
[   48.293391] initcall aesni_init+0x0/0x260 returned 0 after 11253 usecs
[   48.300731] calling  kernel_panic_sysctls_init+0x0/0x30 @ 1
[   48.307116] initcall kernel_panic_sysctls_init+0x0/0x30 returned 0 after=
 25 usecs
[   48.315402] calling  kernel_panic_sysfs_init+0x0/0x50 @ 1
[   48.321604] initcall kernel_panic_sysfs_init+0x0/0x50 returned 0 after 1=
4 usecs
[   48.329720] calling  kernel_exit_sysctls_init+0x0/0x30 @ 1
[   48.336014] initcall kernel_exit_sysctls_init+0x0/0x30 returned 0 after =
22 usecs
[   48.344235] calling  kernel_exit_sysfs_init+0x0/0x50 @ 1
[   48.350338] initcall kernel_exit_sysfs_init+0x0/0x50 returned 0 after 11=
 usecs
[   48.358377] calling  param_sysfs_builtin_init+0x0/0xb0 @ 1
[   48.407074] initcall param_sysfs_builtin_init+0x0/0xb0 returned 0 after =
42411 usecs
[   48.415823] calling  reboot_ksysfs_init+0x0/0xa0 @ 1
[   48.422587] initcall reboot_ksysfs_init+0x0/0xa0 returned 0 after 1011 u=
secs
[   48.430759] calling  sched_core_sysctl_init+0x0/0x30 @ 1
[   48.436982] initcall sched_core_sysctl_init+0x0/0x30 returned 0 after 12=
7 usecs
[   48.445148] calling  sched_fair_sysctl_init+0x0/0x30 @ 1
[   48.451252] initcall sched_fair_sysctl_init+0x0/0x30 returned 0 after 10=
 usecs
[   48.459274] calling  sched_rt_sysctl_init+0x0/0x30 @ 1
[   48.465204] initcall sched_rt_sysctl_init+0x0/0x30 returned 0 after 9 us=
ecs
[   48.472969] calling  sched_dl_sysctl_init+0x0/0x30 @ 1
[   48.479962] initcall sched_dl_sysctl_init+0x0/0x30 returned 0 after 9 us=
ecs
[   48.487727] calling  sched_clock_init_late+0x0/0x130 @ 1
[   48.493821] sched_clock: Marking stable (45995726177, 2498090866)->(5152=
4413211, -3030596168)
[   48.503257] initcall sched_clock_init_late+0x0/0x130 returned 0 after 94=
35 usecs
[   48.511471] calling  sched_init_debug+0x0/0x280 @ 1
[   48.517452] initcall sched_init_debug+0x0/0x280 returned 0 after 318 use=
cs
[   48.525134] calling  cpu_latency_qos_init+0x0/0x40 @ 1
[   48.531343] initcall cpu_latency_qos_init+0x0/0x40 returned 0 after 291 =
usecs
[   48.539306] calling  pm_debugfs_init+0x0/0x30 @ 1
[   48.544823] initcall pm_debugfs_init+0x0/0x30 returned 0 after 17 usecs
[   48.552244] calling  printk_late_init+0x0/0x290 @ 1
[   48.557923] initcall printk_late_init+0x0/0x290 returned 0 after 23 usec=
s
[   48.565513] calling  init_srcu_module_notifier+0x0/0x30 @ 1
[   48.571874] initcall init_srcu_module_notifier+0x0/0x30 returned 0 after=
 1 usecs
[   48.580070] calling  swiotlb_create_default_debugfs+0x0/0xd0 @ 1
[   48.586921] initcall swiotlb_create_default_debugfs+0x0/0xd0 returned 0 =
after 55 usecs
[   48.595644] calling  tk_debug_sleep_time_init+0x0/0x30 @ 1
[   48.601931] initcall tk_debug_sleep_time_init+0x0/0x30 returned 0 after =
14 usecs
[   48.610135] calling  bpf_ksym_iter_register+0x0/0x20 @ 1
[   48.616233] initcall bpf_ksym_iter_register+0x0/0x20 returned 0 after 7 =
usecs
[   48.624175] calling  kernel_acct_sysctls_init+0x0/0x30 @ 1
[   48.630456] initcall kernel_acct_sysctls_init+0x0/0x30 returned 0 after =
13 usecs
[   48.638657] calling  kexec_core_sysctl_init+0x0/0x30 @ 1
[   48.644762] initcall kexec_core_sysctl_init+0x0/0x30 returned 0 after 12=
 usecs
[   48.652786] calling  bpf_rstat_kfunc_init+0x0/0x20 @ 1
[   48.658710] initcall bpf_rstat_kfunc_init+0x0/0x20 returned 0 after 0 us=
ecs
[   48.666478] calling  debugfs_kprobe_init+0x0/0x80 @ 1
[   48.672380] initcall debugfs_kprobe_init+0x0/0x80 returned 0 after 71 us=
ecs
[   48.680163] calling  kernel_delayacct_sysctls_init+0x0/0x30 @ 1
[   48.686905] initcall kernel_delayacct_sysctls_init+0x0/0x30 returned 0 a=
fter 11 usecs
[   48.695537] calling  taskstats_init+0x0/0x40 @ 1
[   48.700989] registered taskstats version 1
[   48.705866] initcall taskstats_init+0x0/0x40 returned 0 after 4931 usecs
[   48.713371] calling  ftrace_sysctl_init+0x0/0x30 @ 1
[   48.719127] initcall ftrace_sysctl_init+0x0/0x30 returned 0 after 10 use=
cs
[   48.726803] calling  init_hwlat_tracer+0x0/0x120 @ 1
[   48.733075] initcall init_hwlat_tracer+0x0/0x120 returned 0 after 525 us=
ecs
[   48.740854] calling  bpf_key_sig_kfuncs_init+0x0/0x20 @ 1
[   48.747041] initcall bpf_key_sig_kfuncs_init+0x0/0x20 returned 0 after 0=
 usecs
[   48.755066] calling  bpf_global_ma_init+0x0/0x30 @ 1
[   48.763232] initcall bpf_global_ma_init+0x0/0x30 returned 0 after 2419 u=
secs
[   48.771094] calling  bpf_syscall_sysctl_init+0x0/0x30 @ 1
[   48.777290] initcall bpf_syscall_sysctl_init+0x0/0x30 returned 0 after 1=
3 usecs
[   48.785400] calling  kfunc_init+0x0/0x100 @ 1
[   48.790539] initcall kfunc_init+0x0/0x100 returned 0 after 0 usecs
[   48.797504] calling  bpf_map_iter_init+0x0/0x30 @ 1
[   48.803176] initcall bpf_map_iter_init+0x0/0x30 returned 0 after 12 usec=
s
[   48.810767] calling  task_iter_init+0x0/0x380 @ 1
[   48.816267] initcall task_iter_init+0x0/0x380 returned 0 after 15 usecs
[   48.823682] calling  bpf_prog_iter_init+0x0/0x20 @ 1
[   48.829431] initcall bpf_prog_iter_init+0x0/0x20 returned 0 after 5 usec=
s
[   48.837017] calling  bpf_link_iter_init+0x0/0x20 @ 1
[   48.842768] initcall bpf_link_iter_init+0x0/0x20 returned 0 after 5 usec=
s
[   48.850359] calling  init_trampolines+0x0/0x70 @ 1
[   48.855953] initcall init_trampolines+0x0/0x70 returned 0 after 1 usecs
[   48.863372] calling  bpf_offload_init+0x0/0x20 @ 1
[   48.868954] initcall bpf_offload_init+0x0/0x20 returned 0 after 8 usecs
[   48.876373] calling  bpf_cgroup_iter_init+0x0/0x30 @ 1
[   48.882298] initcall bpf_cgroup_iter_init+0x0/0x30 returned 0 after 5 us=
ecs
[   48.890070] calling  cpumask_kfunc_init+0x0/0xf0 @ 1
[   48.895965] initcall cpumask_kfunc_init+0x0/0xf0 returned 0 after 144 us=
ecs
[   48.903733] calling  load_system_certificate_list+0x0/0x60 @ 1
[   48.910355] Loading compiled-in X.509 certificates
[   48.917149] Loaded X.509 cert 'Build time autogenerated kernel key: 8c5c=
83ce2c0f6f96b59b9ba5024ec02319397016'
[   48.927871] initcall load_system_certificate_list+0x0/0x60 returned 0 af=
ter 17516 usecs
[   48.936684] calling  fault_around_debugfs+0x0/0x30 @ 1
[   48.942622] initcall fault_around_debugfs+0x0/0x30 returned 0 after 20 u=
secs
[   48.950472] calling  max_swapfiles_check+0x0/0x10 @ 1
[   48.956308] initcall max_swapfiles_check+0x0/0x10 returned 0 after 0 use=
cs
[   48.963982] calling  zswap_init+0x0/0x20 @ 1
[   48.969036] initcall zswap_init+0x0/0x20 returned 0 after 0 usecs
[   48.975916] calling  hugetlb_vmemmap_init+0x0/0x1d0 @ 1
[   48.981936] initcall hugetlb_vmemmap_init+0x0/0x1d0 returned 0 after 14 =
usecs
[   48.989872] calling  slab_sysfs_init+0x0/0x100 @ 1
[   49.041655] initcall slab_sysfs_init+0x0/0x100 returned 0 after 46211 us=
ecs
[   49.049431] calling  kasan_cpu_quarantine_init+0x0/0x50 @ 1
[   49.056270] initcall kasan_cpu_quarantine_init+0x0/0x50 returned 215 aft=
er 483 usecs
[   49.064823] calling  kfence_debugfs_init+0x0/0x20 @ 1
[   49.070710] initcall kfence_debugfs_init+0x0/0x20 returned 0 after 51 us=
ecs
[   49.078478] calling  split_huge_pages_debugfs+0x0/0x30 @ 1
[   49.084764] initcall split_huge_pages_debugfs+0x0/0x30 returned 0 after =
20 usecs
[   49.092961] calling  memory_failure_sysctl_init+0x0/0x30 @ 1
[   49.099411] initcall memory_failure_sysctl_init+0x0/0x30 returned 0 afte=
r 14 usecs
[   49.107779] calling  kmemleak_late_init+0x0/0xc0 @ 1
[   49.113799] kmemleak: Kernel memory leak detector initialized (mem pool =
available: 13559)
[   49.113803] kmemleak: Automatic memory scanning thread started
[   49.113933] initcall kmemleak_late_init+0x0/0xc0 returned 0 after 409 us=
ecs
[   49.137168] calling  pageowner_init+0x0/0x40 @ 1
[   49.142567] page_owner is disabled
[   49.146743] initcall pageowner_init+0x0/0x40 returned 0 after 4176 usecs
[   49.154252] calling  check_early_ioremap_leak+0x0/0xb0 @ 1
[   49.160524] initcall check_early_ioremap_leak+0x0/0xb0 returned 0 after =
0 usecs
[   49.168636] calling  set_hardened_usercopy+0x0/0x30 @ 1
[   49.174642] initcall set_hardened_usercopy+0x0/0x30 returned 1 after 0 u=
secs
[   49.182496] calling  fscrypt_init+0x0/0xd0 @ 1
[   49.188605] Key type .fscrypt registered
[   49.193319] Key type fscrypt-provisioning registered
[   49.199070] initcall fscrypt_init+0x0/0xd0 returned 0 after 11352 usecs
[   49.206492] calling  pstore_init+0x0/0x90 @ 1
[   49.211824] pstore: Using crash dump compression: deflate
[   49.218021] initcall pstore_init+0x0/0x90 returned 0 after 6390 usecs
[   49.225264] calling  init_root_keyring+0x0/0x20 @ 1
[   49.231025] initcall init_root_keyring+0x0/0x20 returned 0 after 103 use=
cs
[   49.238705] calling  init_trusted+0x0/0x2c0 @ 1
[   49.244246] initcall init_trusted+0x0/0x2c0 returned 0 after 228 usecs
[   49.251588] calling  init_encrypted+0x0/0x170 @ 1
[   53.336047] Freeing initrd memory: 270600K
[   53.365010] Key type encrypted registered
[   53.369829] initcall init_encrypted+0x0/0x170 returned 0 after 4112758 u=
secs
[   53.377705] calling  init_profile_hash+0x0/0x120 @ 1
[   53.383493] AppArmor: AppArmor sha1 policy hashing enabled
[   53.389758] initcall init_profile_hash+0x0/0x120 returned 0 after 6293 u=
secs
[   53.397625] calling  integrity_fs_init+0x0/0x60 @ 1
[   53.403331] initcall integrity_fs_init+0x0/0x60 returned 0 after 26 usec=
s
[   53.410930] calling  crypto_algapi_init+0x0/0x20 @ 1
[   53.416726] initcall crypto_algapi_init+0x0/0x20 returned 0 after 32 use=
cs
[   53.424409] calling  blk_timeout_init+0x0/0x20 @ 1
[   53.430015] initcall blk_timeout_init+0x0/0x20 returned 0 after 0 usecs
[   53.437459] calling  kunit_init+0x0/0x90 @ 1
[   53.442574] initcall kunit_init+0x0/0x90 returned 0 after 46 usecs
[   53.449539] calling  init_error_injection+0x0/0x70 @ 1
[   53.461465] initcall init_error_injection+0x0/0x70 returned 0 after 5988=
 usecs
[   53.469531] calling  pci_resource_alignment_sysfs_init+0x0/0x20 @ 1
[   53.476615] initcall pci_resource_alignment_sysfs_init+0x0/0x20 returned=
 0 after 35 usecs
[   53.485592] calling  pci_sysfs_init+0x0/0x80 @ 1
[   53.493073] initcall pci_sysfs_init+0x0/0x80 returned 0 after 950 usecs
[   53.500534] calling  bert_init+0x0/0x810 @ 1
[   53.505746] initcall bert_init+0x0/0x810 returned 0 after 141 usecs
[   53.512799] calling  clk_debug_init+0x0/0x150 @ 1
[   53.518424] initcall clk_debug_init+0x0/0x150 returned 0 after 124 usecs
[   53.525927] calling  dmar_free_unused_resources+0x0/0x2a0 @ 1
[   53.532471] initcall dmar_free_unused_resources+0x0/0x2a0 returned 0 aft=
er 0 usecs
[   53.540860] calling  sync_state_resume_initcall+0x0/0x20 @ 1
[   53.547316] initcall sync_state_resume_initcall+0x0/0x20 returned 0 afte=
r 0 usecs
[   53.555611] calling  deferred_probe_initcall+0x0/0xd0 @ 1
[   53.561891] initcall deferred_probe_initcall+0x0/0xd0 returned 0 after 8=
2 usecs
[   53.570008] calling  firmware_memmap_init+0x0/0x60 @ 1
[   53.576839] initcall firmware_memmap_init+0x0/0x60 returned 0 after 870 =
usecs
[   53.584775] calling  register_update_efi_random_seed+0x0/0x30 @ 1
[   53.591663] initcall register_update_efi_random_seed+0x0/0x30 returned 0=
 after 0 usecs
[   53.600414] calling  efi_shutdown_init+0x0/0x80 @ 1
[   53.606093] initcall efi_shutdown_init+0x0/0x80 returned -19 after 0 use=
cs
[   53.613791] calling  efi_earlycon_unmap_fb+0x0/0x70 @ 1
[   53.619813] initcall efi_earlycon_unmap_fb+0x0/0x70 returned 0 after 0 u=
secs
[   53.627683] calling  itmt_legacy_init+0x0/0x50 @ 1
[   53.633272] initcall itmt_legacy_init+0x0/0x50 returned -19 after 0 usec=
s
[   53.640889] calling  bpf_kfunc_init+0x0/0x100 @ 1
[   53.646408] initcall bpf_kfunc_init+0x0/0x100 returned 0 after 0 usecs
[   53.653749] calling  xdp_metadata_init+0x0/0x20 @ 1
[   53.659440] initcall xdp_metadata_init+0x0/0x20 returned 0 after 0 usecs
[   53.666957] calling  bpf_sockmap_iter_init+0x0/0x60 @ 1
[   53.673010] initcall bpf_sockmap_iter_init+0x0/0x60 returned 0 after 27 =
usecs
[   53.680974] calling  bpf_sk_storage_map_iter_init+0x0/0x60 @ 1
[   53.687627] initcall bpf_sk_storage_map_iter_init+0x0/0x60 returned 0 af=
ter 24 usecs
[   53.696175] calling  sch_default_qdisc+0x0/0x20 @ 1
[   53.701836] initcall sch_default_qdisc+0x0/0x20 returned 0 after 3 usecs
[   53.709355] calling  bpf_prog_test_run_init+0x0/0x100 @ 1
[   53.715543] initcall bpf_prog_test_run_init+0x0/0x100 returned 0 after 0=
 usecs
[   53.723577] calling  tcp_congestion_default+0x0/0x20 @ 1
[   53.729687] initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 =
usecs
[   53.737635] calling  ip_auto_config+0x0/0xb90 @ 1
[   53.946624] pps pps0: new PPS source ptp2
[   53.953026] ixgbe 0000:03:00.0: registered PHC device on eth2
[   54.200385] pps pps1: new PPS source ptp3
[   54.205660] ixgbe 0000:03:00.1: registered PHC device on eth3
[   56.788597] igb 0000:05:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Fu=
ll Duplex, Flow Control: RX
[   56.798653] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   56.818220] Sending DHCP requests ...., OK
[   69.045122] IP-Config: Got DHCP answer from 192.168.3.1, my address is 1=
92.168.3.82
[   69.053591] IP-Config: Complete:
[   69.057617]      device=3Deth0, hwaddr=3D0c:c4:7a:c4:ab:7a, ipaddr=3D192=
.168.3.82, mask=3D255.255.255.0, gw=3D192.168.3.200
[   69.068702]      host=3Dlkp-bdw-de1, domain=3Dlkp.intel.com, nis-domain=
=3D(none)
[   69.076413]      bootserver=3D192.168.3.200, rootserver=3D192.168.3.200,=
 rootpath=3D
[   69.076416]      nameserver0=3D192.168.3.200
[   69.136938] ixgbe 0000:03:00.0: removed PHC on eth2
[   70.263431] ixgbe 0000:03:00.1: removed PHC on eth3
[   71.750081] initcall ip_auto_config+0x0/0xb90 returned 0 after 18006943 =
usecs
[   71.758057] calling  tcp_bpf_v4_build_proto+0x0/0x110 @ 1
[   71.764260] initcall tcp_bpf_v4_build_proto+0x0/0x110 returned 0 after 0=
 usecs
[   71.772303] calling  udp_bpf_v4_build_proto+0x0/0xb0 @ 1
[   71.778412] initcall udp_bpf_v4_build_proto+0x0/0xb0 returned 0 after 0 =
usecs
[   71.786368] calling  bpf_tcp_ca_kfunc_init+0x0/0x20 @ 1
[   71.792393] initcall bpf_tcp_ca_kfunc_init+0x0/0x20 returned 0 after 1 u=
secs
[   71.800260] calling  pci_mmcfg_late_insert_resources+0x0/0xd0 @ 1
[   71.807151] initcall pci_mmcfg_late_insert_resources+0x0/0xd0 returned 0=
 after 2 usecs
[   71.815890] calling  software_resume+0x0/0x40 @ 1
[   71.821389] initcall software_resume+0x0/0x40 returned -2 after 1 usecs
[   71.828808] calling  ftrace_check_sync+0x0/0x20 @ 1
[   71.834530] initcall ftrace_check_sync+0x0/0x20 returned 0 after 28 usec=
s
[   71.842122] calling  latency_fsnotify_init+0x0/0x40 @ 1
[   71.848279] initcall latency_fsnotify_init+0x0/0x40 returned 0 after 135=
 usecs
[   71.856311] calling  trace_eval_sync+0x0/0x20 @ 1
[   71.861864] initcall trace_eval_sync+0x0/0x20 returned 0 after 9 usecs
[   71.869198] calling  late_trace_init+0x0/0xb0 @ 1
[   71.874748] initcall late_trace_init+0x0/0xb0 returned 0 after 0 usecs
[   71.882074] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x150 @ =
1
[   71.889950] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x150 re=
turned 0 after 268 usecs
[   71.899601] calling  fb_logo_late_init+0x0/0x20 @ 1
[   71.905267] initcall fb_logo_late_init+0x0/0x20 returned 0 after 0 usecs
[   71.912787] calling  clk_disable_unused+0x0/0x1f0 @ 1
[   71.918637] clk: Disabling unused clocks
[   71.923353] initcall clk_disable_unused+0x0/0x1f0 returned 0 after 4717 =
usecs
[   71.931299] KTAP version 1
[   71.934782] 1..9
[   71.937613]     KTAP version 1
[   71.941451]     # Subtest: hw_breakpoint
[   71.946171]     1..9
[   71.949561]     ok 1 test_one_cpu
[   71.951510]     ok 2 test_many_cpus
[   71.956083]     ok 3 test_one_task_on_all_cpus
[   71.961095]     ok 4 test_two_tasks_on_all_cpus
[   71.966755]     ok 5 test_one_task_on_one_cpu
[   71.972550]     ok 6 test_one_task_mixed
[   71.978354]     ok 7 test_two_tasks_on_one_cpu
[   71.983750]     ok 8 test_two_tasks_on_one_all_cpus
[   71.989489]     ok 9 test_task_on_all_and_one_cpu
[   71.995153] # hw_breakpoint: pass:9 fail:0 skip:0 total:9
[   72.000642] # Totals: pass:9 fail:0 skip:0 total:9
[   72.006840] ok 1 hw_breakpoint
[   72.016366]     KTAP version 1
[   72.020221]     # Subtest: damon-operations
[   72.025184]     1..6
[   72.028374]     ok 1 damon_test_three_regions_in_vmas
[   72.028788]     # damon_test_apply_three_regions1: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 5 (0x5)
[   72.034927]     # damon_test_apply_three_regions1: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 27 (0x1b)
[   72.061286]     # damon_test_apply_three_regions1: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 45 (0x2d)
[   72.088678]     # damon_test_apply_three_regions1: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 55 (0x37)
[   72.115193]     # damon_test_apply_three_regions1: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 73 (0x49)
[   72.142558]     # damon_test_apply_three_regions1: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 104 (0x68)
[   72.168958]     not ok 2 damon_test_apply_three_regions1
[   72.196592]     # damon_test_apply_three_regions2: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 5 (0x5)
[   72.202967]     # damon_test_apply_three_regions2: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 27 (0x1b)
[   72.229319]     # damon_test_apply_three_regions2: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 56 (0x38)
[   72.256703]     # damon_test_apply_three_regions2: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 57 (0x39)
[   72.284363]     # damon_test_apply_three_regions2: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 65 (0x41)
[   72.311911]     # damon_test_apply_three_regions2: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 104 (0x68)
[   72.338301]     not ok 3 damon_test_apply_three_regions2
[   72.365980]     # damon_test_apply_three_regions3: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 5 (0x5)
[   72.372636]     # damon_test_apply_three_regions3: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 27 (0x1b)
[   72.398960]     # damon_test_apply_three_regions3: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 61 (0x3d)
[   72.426312]     # damon_test_apply_three_regions3: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 63 (0x3f)
[   72.452805]     # damon_test_apply_three_regions3: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 65 (0x41)
[   72.480173]     # damon_test_apply_three_regions3: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 104 (0x68)
[   72.506641]     not ok 4 damon_test_apply_three_regions3
[   72.534376]     # damon_test_apply_three_regions4: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 5 (0x5)
[   72.540928]     # damon_test_apply_three_regions4: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 7 (0x7)
[   72.567258]     # damon_test_apply_three_regions4: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 30 (0x1e)
[   72.594454]     # damon_test_apply_three_regions4: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 32 (0x20)
[   72.620948]     # damon_test_apply_three_regions4: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:148
                   Expected r->ar.start =3D=3D expected[i * 2], but
                       r->ar.start =3D=3D 0 (0x0)
                       expected[i * 2] =3D=3D 65 (0x41)
[   72.648326]     # damon_test_apply_three_regions4: EXPECTATION FAILED at=
 mm/damon/vaddr-test.h:149
                   Expected r->ar.end =3D=3D expected[i * 2 + 1], but
                       r->ar.end =3D=3D 4096 (0x1000)
                       expected[i * 2 + 1] =3D=3D 68 (0x44)
[   72.674856]     not ok 5 damon_test_apply_three_regions4
[   72.702400]     ok 6 damon_test_split_evenly
[   72.708500] # damon-operations: pass:2 fail:4 skip:0 total:6
[   72.713567] # Totals: pass:2 fail:4 skip:0 total:6
[   72.720022] not ok 2 damon-operations
[   72.730150]     KTAP version 1
[   72.733985]     # Subtest: damon-dbgfs
[   72.738531]     1..3
[   72.741809]     ok 1 damon_dbgfs_test_str_to_ints
[   72.742017]     ok 2 damon_dbgfs_test_set_targets
[   72.747864] damon-dbgfs: input: 3 10 20

[   72.760183] damon-dbgfs: input: 1 10 20
                1 14 26

[   72.769908] damon-dbgfs: input: 0 10 20
               1 30 40
                0 5 8
[   72.780139]     ok 3 damon_dbgfs_test_set_init_regions
[   72.780146] # damon-dbgfs: pass:3 fail:0 skip:0 total:3
[   72.786102] # Totals: pass:3 fail:0 skip:0 total:3
[   72.792130] ok 3 damon-dbgfs
[   72.801449]     KTAP version 1
[   72.805285]     # Subtest: binfmt_elf
[   72.809728]     1..1
[   72.812942]     ok 1 total_mapping_size_test
[   72.812946] ok 4 binfmt_elf
[   72.821662]     KTAP version 1
[   72.825493]     # Subtest: compat_binfmt_elf
[   72.830554]     1..1
[   72.833762]     ok 1 total_mapping_size_test
[   72.833766] ok 5 compat_binfmt_elf
[   72.843123]     KTAP version 1
[   72.846951]     # Subtest: fprobe_test
[   72.851494]     1..6
[   72.898533]     ok 1 test_fprobe_entry
[   73.005719]     ok 2 test_fprobe
[   73.109588]     ok 3 test_fprobe_syms
[   73.213437]     ok 4 test_fprobe_data
[   73.317497]     ok 5 test_fprobe_nest
[   73.421676]     ok 6 test_fprobe_skip
[   73.426132] # fprobe_test: pass:6 fail:0 skip:0 total:6
[   73.430581] # Totals: pass:6 fail:0 skip:0 total:6
[   73.436587] ok 6 fprobe_test
[   73.445875]     KTAP version 1
[   73.449705]     # Subtest: qos-kunit-test
[   73.454489]     1..3
[   73.457671]     ok 1 freq_qos_test_min
[   73.457850]     ok 2 freq_qos_test_maxdef
[   73.462609]     ok 3 freq_qos_test_readd
[   73.467397] # qos-kunit-test: pass:3 fail:0 skip:0 total:3
[   73.472120] # Totals: pass:3 fail:0 skip:0 total:3
[   73.478414] ok 7 qos-kunit-test
[   73.488018]     KTAP version 1
[   73.491870]     # Subtest: property-entry
[   73.496678]     1..7
[   73.500089]     ok 1 pe_test_uints
[   73.500570]     ok 2 pe_test_uint_arrays
[   73.505293]     ok 3 pe_test_strings
[   73.510456]     ok 4 pe_test_bool
[   73.515126]     ok 5 pe_test_move_inline_u8
[   73.519600]     ok 6 pe_test_move_inline_str
[   73.525055]     ok 7 pe_test_reference
[   73.530134] # property-entry: pass:7 fail:0 skip:0 total:7
[   73.534666] # Totals: pass:7 fail:0 skip:0 total:7
[   73.540949] ok 8 property-entry
[   73.550741]     KTAP version 1
[   73.554591]     # Subtest: thunderbolt
[   73.559139]     1..38
[   73.562678]     ok 1 tb_test_path_basic
[   73.563597]     ok 2 tb_test_path_not_connected_walk
[   73.569071]     ok 3 tb_test_path_single_hop_walk
[   73.576142]     ok 4 tb_test_path_daisy_chain_walk
[   73.583828]     ok 5 tb_test_path_simple_tree_walk
[   73.593520]     ok 6 tb_test_path_complex_tree_walk
[   73.604289]     ok 7 tb_test_path_max_length_walk
[   73.611629]     ok 8 tb_test_path_not_connected
[   73.618056]     ok 9 tb_test_path_not_bonded_lane0
[   73.624337]     ok 10 tb_test_path_not_bonded_lane1
[   73.631701]     ok 11 tb_test_path_not_bonded_lane1_chain
[   73.639071]     ok 12 tb_test_path_not_bonded_lane1_chain_reverse
[   73.647383]     ok 13 tb_test_path_mixed_chain
[   73.656468]     ok 14 tb_test_path_mixed_chain_reverse
[   73.663138]     ok 15 tb_test_tunnel_pcie
[   73.670064]     ok 16 tb_test_tunnel_dp
[   73.677544]     ok 17 tb_test_tunnel_dp_chain
[   73.684744]     ok 18 tb_test_tunnel_dp_tree
[   73.695168]     ok 19 tb_test_tunnel_dp_max_length
[   73.702855]     ok 20 tb_test_tunnel_port_on_path
[   73.709963]     ok 21 tb_test_tunnel_usb3
[   73.716013]     ok 22 tb_test_tunnel_dma
[   73.721484]     ok 23 tb_test_tunnel_dma_rx
[   73.726722]     ok 24 tb_test_tunnel_dma_tx
[   73.733059]     ok 25 tb_test_tunnel_dma_chain
[   73.738760]     ok 26 tb_test_tunnel_dma_match
[   73.744989]     ok 27 tb_test_credit_alloc_legacy_not_bonded
[   73.751125]     ok 28 tb_test_credit_alloc_legacy_bonded
[   73.758606]     ok 29 tb_test_credit_alloc_pcie
[   73.765722]     ok 30 tb_test_credit_alloc_without_dp
[   73.772022]     ok 31 tb_test_credit_alloc_dp
[   73.778880]     ok 32 tb_test_credit_alloc_usb3
[   73.785029]     ok 33 tb_test_credit_alloc_dma
[   73.791595]     ok 34 tb_test_credit_alloc_dma_multiple
[   73.798192]     ok 35 tb_test_credit_alloc_all
[   73.805747]     ok 36 tb_test_property_parse
[   73.811377]     ok 37 tb_test_property_format
[   73.816984]     ok 38 tb_test_property_copy
[   73.822132] # thunderbolt: pass:38 fail:0 skip:0 total:38
[   73.827095] # Totals: pass:38 fail:0 skip:0 total:38
[   73.833292] ok 9 thunderbolt
[   73.862163] Freeing unused kernel image (initmem) memory: 3452K
[   73.878182] Write protecting the kernel read-only data: 57344k
[   73.885244] Freeing unused kernel image (rodata/data gap) memory: 684K
[   73.902205] Run /init as init process
[   73.906658]   with arguments:
[   73.910423]     /init
[   73.913491]     nokaslr
[   73.916732]   with environment:
[   73.920667]     HOME=3D/
[   73.923821]     TERM=3Dlinux
[   73.927321]     RESULT_ROOT=3D/result/kunit/group-01/lkp-bdw-de1/debian-=
11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb901=
2a7a0ed630d65d01695/2
[   73.943019]     BOOT_IMAGE=3D/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4=
287fc4655b77bfb9012a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655
[   73.956878]     branch=3Dlinux-review/Richard-Weinberger/vsprintf-Warn-o=
n-integer-scanning-overflows/20230608-064044
[   73.968040]     job=3D/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-deb=
ian-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230=
612-43529-13huwyx-5.yaml
[   73.984002]     user=3Dlkp
[   73.987329]     ARCH=3Dx86_64
[   73.990918]     kconfig=3Dx86_64-rhel-8.3-kunit
[   73.996074]     commit=3D5f4287fc4655b77bfb9012a7a0ed630d65d01695
[   74.002790]     max_uptime=3D1200
[   74.006726]     LKP_SERVER=3Dinternal-lkp-server
[   74.011969]     softlockup_panic=3D1
[   74.016164]     prompt_ramdisk=3D0
[   74.071688] systemd[1]: RTC configured in localtime, applying delta of 0=
 minutes to system time.
[   74.082603] systemd[1]: System time before build time, advancing clock.
[   74.097696] calling  ip_tables_init+0x0/0x1000 [ip_tables] @ 1
[   74.104411] initcall ip_tables_init+0x0/0x1000 [ip_tables] returned 0 af=
ter 69 usecs
[   74.756318] calling  fuse_init+0x0/0x2b0 [fuse] @ 296
[   74.762521] fuse: init (API version 7.38)
[   74.764147] initcall fuse_init+0x0/0x2b0 [fuse] returned 0 after 1626 us=
ecs
[   74.790310] calling  drm_core_init+0x0/0x1000 [drm] @ 294
[   74.796786] ACPI: bus type drm_connector registered
[   74.802656] initcall drm_core_init+0x0/0x1000 [drm] returned 0 after 610=
3 usecs
[   76.261062] calling  acpi_pad_init+0x0/0x1000 [acpi_pad] @ 322
[   76.269846] probe of ACPI000C:00 returned 0 after 556 usecs
[   76.272144] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 335
[   76.276908] initcall acpi_pad_init+0x0/0x1000 [acpi_pad] returned 0 afte=
r 8518 usecs
[   76.289461] probe of PNP0C14:00 returned 0 after 4458 usecs
[   76.300457] calling  ipmi_init_msghandler_mod+0x0/0x1000 [ipmi_msghandle=
r] @ 324
[   76.302428] probe of PNP0C14:01 returned 0 after 2169 usecs
[   76.309049] IPMI message handler: version 39.2
[   76.315246] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned 0 after 619=
7 usecs
[   76.320628] initcall ipmi_init_msghandler_mod+0x0/0x1000 [ipmi_msghandle=
r] returned 0 after 11580 usecs
[   76.342452] calling  dca_init+0x0/0x30 [dca] @ 340
[   76.348061] dca service started, version 1.12.1
[   76.353692] initcall dca_init+0x0/0x30 [dca] returned 0 after 5630 usecs
[   76.354957] calling  init_ipmi_devintf+0x0/0x1000 [ipmi_devintf] @ 324
[   76.368034] calling  mxm_wmi_init+0x0/0x1000 [mxm_wmi] @ 345
[   76.368712] ipmi device interface
[   76.368811] initcall mxm_wmi_init+0x0/0x1000 [mxm_wmi] returned 0 after =
0 usecs
[   76.374425] initcall init_ipmi_devintf+0x0/0x1000 [ipmi_devintf] returne=
d 0 after 5614 usecs
[   76.405283] calling  intel_pch_thermal_driver_init+0x0/0x1000 [intel_pch=
_thermal] @ 336
[   76.420074] calling  ichx_gpio_driver_init+0x0/0x1000 [gpio_ich] @ 328
[   76.434910] gpio_ich gpio_ich.1.auto: GPIO from 512 to 587
[   76.435146] calling  joydev_init+0x0/0x1000 [joydev] @ 348
[   76.436687] calling  mei_init+0x0/0xb0 [mei] @ 323
[   76.440893] calling  ioat_init_module+0x0/0x1000 [ioatdma] @ 340
[   76.440912] ioatdma: Intel(R) QuickData Technology Driver 5.00
[   76.441203] initcall mei_init+0x0/0xb0 [mei] returned 0 after 292 usecs
[   76.441295] initcall joydev_init+0x0/0x1000 [joydev] returned 0 after 8 =
usecs
[   76.441379] probe of gpio_ich.1.auto returned 0 after 13197 usecs
[   76.441703] initcall ichx_gpio_driver_init+0x0/0x1000 [gpio_ich] returne=
d 0 after 416 usecs
[   76.443565] probe of 0000:00:1f.6 returned 0 after 27002 usecs
[   76.444592] initcall intel_pch_thermal_driver_init+0x0/0x1000 [intel_pch=
_thermal] returned 0 after 3305 usecs
[   76.471590] calling  init_ipmi_si+0x0/0x300 [ipmi_si] @ 342
[   76.521853] ipmi_si: IPMI System Interface driver
[   76.527761] ipmi_si dmi-ipmi-si.0: ipmi_platform: probing via SMBIOS
[   76.534944] ipmi_platform: ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1=
 irq 0
[   76.543044] ipmi_si: Adding SMBIOS-specified kcs state machine
[   76.551602] probe of dmi-ipmi-si.0 returned 0 after 24092 usecs
[   76.561264] ipmi_si IPI0001:00: ipmi_platform: probing via ACPI
[   76.561376] calling  acpi_cpufreq_init+0x0/0x30 [acpi_cpufreq] @ 321
[   76.563008] calling  ata_init+0x0/0xa0 [libata] @ 329
[   76.564284] libata version 3.00 loaded.
[   76.564287] initcall ata_init+0x0/0xa0 [libata] returned 0 after 1208 us=
ecs
[   76.573561] ipmi_si IPI0001:00: ipmi_platform: [io  0x0ca2] regsize 1 sp=
acing 1 irq 0
[   76.575428] acpi-cpufreq: probe of acpi-cpufreq failed with error -17
[   76.609349] probe of acpi-cpufreq returned 17 after 34118 usecs
[   76.620634] initcall acpi_cpufreq_init+0x0/0x30 [acpi_cpufreq] returned =
-19 after 45500 usecs
[   76.634196] calling  intel_uncore_init+0x0/0xe60 [intel_uncore] @ 389
[   76.634438] calling  acpi_ipmi_init+0x0/0x1000 [acpi_ipmi] @ 401
[   76.634959] calling  mei_me_driver_init+0x0/0x1000 [mei_me] @ 323
[   76.635404] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
[   76.635465] probe of 0000:00:16.0 returned 19 after 249 usecs
[   76.636944] initcall mei_me_driver_init+0x0/0x1000 [mei_me] returned 0 a=
fter 1960 usecs
[   76.644126] probe of 0000:ff:0b.1 returned 0 after 2002 usecs
[   76.653463] initcall acpi_ipmi_init+0x0/0x1000 [acpi_ipmi] returned 0 af=
ter 5176 usecs
[   76.657163] probe of 0000:ff:0b.2 returned 0 after 1978 usecs
[   76.687355] ipmi_si dmi-ipmi-si.0: Removing SMBIOS-specified kcs state m=
achine in favor of ACPI
[   76.695604] probe of 0000:ff:10.1 returned 0 after 2338 usecs
[   76.699817] ipmi_si: Adding ACPI-specified kcs state machine
[   76.704272] probe of 0000:ff:12.1 returned 0 after 4351 usecs
[   76.709633] probe of IPI0001:00 returned 0 after 149549 usecs
[   76.717163] calling  ahci_pci_driver_init+0x0/0x1000 [ahci] @ 329
[   76.717367] probe of 0000:ff:14.0 returned 0 after 1425 usecs
[   76.718732] probe of 0000:ff:14.1 returned 0 after 1357 usecs
[   76.720069] probe of 0000:ff:15.0 returned 0 after 1328 usecs
[   76.721431] probe of 0000:ff:15.1 returned 0 after 1357 usecs
[   76.722901] ipmi_si: Trying ACPI-specified kcs state machine at i/o addr=
ess 0xca2, slave address 0x20, irq 0
[   76.729182] ahci 0000:00:1f.2: version 3.0
[   76.780549] calling  ast_pci_driver_init+0x0/0x1000 [ast] @ 338
[   76.788802] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3f impl SATA mode
[   76.791062] ast 0000:07:00.0: vgaarb: deactivate vga console
[   76.799634] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
 ems apst=20
[   76.804164] ipmi_si IPI0001:00: The BMC does not support clearing the re=
cv irq bit, compensating, but the BMC needs to be fixed.
[   76.829155] Console: switching to colour dummy device 80x25
[   76.836296] scsi host0: ahci
[   76.838087] ast 0000:07:00.0: [drm] Using P2A bridge for configuration
[   76.843673] scsi host1: ahci
[   76.847105] ast 0000:07:00.0: [drm] AST 2400 detected
[   76.847119] ast 0000:07:00.0: [drm] Using analog VGA
[   76.853306] ipmi_si IPI0001:00: IPMI message handler: Found new BMC (man=
_id: 0x002a7c, prod_id: 0x086d, dev_id: 0x20)
[   76.853777] scsi host2: ahci
[   76.856459] ast 0000:07:00.0: [drm] dram MCLK=3D408 Mhz type=3D1 bus_wid=
th=3D16
[   76.856861] scsi host3: ahci
[   76.866816] [drm] Initialized ast 0.1.0 20120228 for 0000:07:00.0 on min=
or 0
[   76.876545] scsi host4: ahci
[   76.893641] ipmi_si IPI0001:00: IPMI kcs interface initialized
[   76.898938] scsi host5: ahci
[   76.899389] initcall init_ipmi_si+0x0/0x300 [ipmi_si] returned 0 after 1=
08733 usecs
[   76.907926] ata1: SATA max UDMA/133 abar m2048@0xfb412000 port 0xfb41210=
0 irq 87
[   76.925945] ata2: SATA max UDMA/133 abar m2048@0xfb412000 port 0xfb41218=
0 irq 87
[   76.925950] ata3: SATA max UDMA/133 abar m2048@0xfb412000 port 0xfb41220=
0 irq 87
[   76.925952] ata4: SATA max UDMA/133 abar m2048@0xfb412000 port 0xfb41228=
0 irq 87
[   76.925954] ata5: SATA max UDMA/133 abar m2048@0xfb412000 port 0xfb41230=
0 irq 87
[   76.925956] ata6: SATA max UDMA/133 abar m2048@0xfb412000 port 0xfb41238=
0 irq 87
[   76.925994] fbcon: astdrmfb (fb0) is primary device
[   76.926201] probe of 0000:00:1f.2 returned 0 after 197126 usecs
[   76.926448] initcall ahci_pci_driver_init+0x0/0x1000 [ahci] returned 0 a=
fter 135791 usecs
[   76.953613] Console: switching to colour frame buffer device 128x48
[   77.052088] ast 0000:07:00.0: [drm] fb0: astdrmfb frame buffer device
[   77.234553] ata6: SATA link down (SStatus 0 SControl 300)
[   77.240726] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   77.247671] ata3: SATA link down (SStatus 0 SControl 300)
[   77.253832] ata2: SATA link down (SStatus 0 SControl 300)
[   77.259987] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   77.266998] ata4: SATA link down (SStatus 0 SControl 300)
[   77.273259] ata1.00: ATA-9: INTEL SSDSC2BA800G4, G2010150, max UDMA/133
[   77.280621] ata1.00: 1562824368 sectors, multi 1: LBA48 NCQ (depth 32)
[   77.287888] ata5.00: ATA-8: ST9500620NS,     AA09, max UDMA/133
[   77.294553] ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 32)
[   77.302229] ata1.00: configured for UDMA/133
[   77.307427] ata5.00: configured for UDMA/133
[   77.996052] initcall intel_uncore_init+0x0/0xe60 [intel_uncore] returned=
 0 after 1205395 usecs
[   77.996470] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BA80 01=
50 PQ: 0 ANSI: 5
[   77.997833] probe of 0000:02:00.0 returned 0 after 1553921 usecs
[   78.016334] probe of 0000:07:00.0 returned 0 after 1225612 usecs
[   78.024715] scsi 4:0:0:0: Direct-Access     ATA      ST9500620NS      AA=
09 PQ: 0 ANSI: 5
[   78.026781] initcall ast_pci_driver_init+0x0/0x1000 [ast] returned 0 aft=
er 1236124 usecs
[   78.659568] microcode: Attempting late microcode loading - it is dangero=
us and taints the kernel.
[   78.670334] microcode: You should switch to early loading, if possible.
[   79.127542] microcode: updated to revision 0x700001c, date =3D 2021-06-1=
2
[   79.136756] microcode: Reload succeeded, microcode revision: 0x7000009 -=
> 0x700001c
[   79.148086] x86/CPU: CPU features have changed after loading microcode, =
but might not take effect.
[   79.159133] x86/CPU: Please consider either early loading through initrd=
/built-in or a potential BIOS update.
[   79.194064] calling  cstate_pmu_init+0x0/0x1000 [intel_cstate] @ 348
[   79.194422] calling  init_ipmi_ssif+0x0/0x1000 [ipmi_ssif] @ 324
[   79.212859] ipmi_ssif: IPMI SSIF Interface driver
[   79.220764] initcall init_ipmi_ssif+0x0/0x1000 [ipmi_ssif] returned 0 af=
ter 7905 usecs
[   79.232249] calling  init_sg+0x0/0x1000 [sg] @ 386
[   79.239861] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[   79.247978] scsi 4:0:0:0: Attached scsi generic sg1 type 0
[   79.255637] initcall init_sg+0x0/0x1000 [sg] returned 0 after 16539 usec=
s
[   79.275390] calling  crc64_rocksoft_mod_init+0x0/0x1000 [crc64_rocksoft]=
 @ 326
[   79.301640] calling  crc64_rocksoft_init+0x0/0x1000 [crc64_rocksoft_gene=
ric] @ 506
[   79.311354] initcall crc64_rocksoft_init+0x0/0x1000 [crc64_rocksoft_gene=
ric] returned 0 after 15 usecs
[   79.338881] initcall crc64_rocksoft_mod_init+0x0/0x1000 [crc64_rocksoft]=
 returned 0 after 27542 usecs
[   79.362698] calling  init_sd+0x0/0x1000 [sd_mod] @ 326
[   79.370873] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 1007 u=
secs
[   79.374763] sd 4:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB=
/466 GiB)
[   79.377397] ata1.00: Enabling discard_zeroes_data
[   79.401287] sd 0:0:0:0: [sdb] 1562824368 512-byte logical blocks: (800 G=
B/745 GiB)
[   79.401327] sd 4:0:0:0: [sda] Write Protect is off
[   79.402737] sd 0:0:0:0: [sdb] 4096-byte physical blocks
[   79.402805] sd 0:0:0:0: [sdb] Write Protect is off
[   79.402827] sd 0:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   79.402912] sd 0:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   79.405605] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   79.406927] sd 0:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
[   79.409434] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   79.416936] ata1.00: Enabling discard_zeroes_data
[   79.488834] sd 4:0:0:0: [sda] Preferred minimum I/O size 512 bytes
[   79.785651]  sdb: sdb1 sdb2
[   79.785667]  sda: sda1
[   79.791004] probe of 0000:02:00.1 returned 0 after 1793156 usecs
[   79.794214] sd 4:0:0:0: [sda] Attached SCSI disk
[   79.794869] initcall cstate_pmu_init+0x0/0x1000 [intel_cstate] returned =
0 after 425002 usecs
[   79.809680] IOAPIC[9]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:002C SQ:0 SVT=
:1)
[   79.810025] sd 0:0:0:0: [sdb] Attached SCSI disk
[   79.810214] probe of 0:0:0:0 returned 0 after 439682 usecs
[   79.841312] probe of 4:0:0:0 returned 0 after 470733 usecs
[   79.854923] IOAPIC[1]: Preconfigured routing entry (9-13 -> IRQ 89 Level=
:1 ActiveLow:1)
[   79.908020] calling  rapl_pmu_init+0x0/0xee0 [rapl] @ 334
[   80.010814] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @ 5=
46
[   80.020068] initcall crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] ret=
urned 0 after 41 usecs
[   80.040990] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 548
[   80.049857] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned =
0 after 28 usecs
[   80.068289] calling  init_module+0x0/0x1000 [raid6_pq] @ 548
[   80.093097] raid6: avx2x4   gen() 15235 MB/s
[   80.116097] raid6: avx2x2   gen() 15021 MB/s
[   80.139099] raid6: avx2x1   gen() 13264 MB/s
[   80.145706] raid6: using algorithm avx2x4 gen() 15235 MB/s
[   80.170103] raid6: .... xor() 5274 MB/s, rmw enabled
[   80.177350] raid6: using avx2x2 recovery algorithm
[   80.184254] initcall init_module+0x0/0x1000 [raid6_pq] returned 0 after =
107860 usecs
[   80.200001] calling  calibrate_xor_blocks+0x0/0xe80 [xor] @ 548
[   80.208188] xor: automatically using best checksumming function   avx   =
   =20
[   80.217476] initcall calibrate_xor_blocks+0x0/0xe80 [xor] returned 0 aft=
er 9303 usecs
[   80.232419] calling  blake2b_mod_init+0x0/0x1000 [blake2b_generic] @ 548
[   80.241394] initcall blake2b_mod_init+0x0/0x1000 [blake2b_generic] retur=
ned 0 after 27 usecs
[   80.503408] calling  init_btrfs_fs+0x0/0x250 [btrfs] @ 546
[   80.542627] Btrfs loaded, zoned=3Dno, fsverity=3Dno
[   80.549380] initcall init_btrfs_fs+0x0/0x250 [btrfs] returned 0 after 38=
146 usecs
[   80.567831] BTRFS: device fsid 21fcb276-f63f-4128-acdc-e5cc590f69c8 devi=
d 1 transid 18 /dev/sdb2 scanned by systemd-udevd (326)
[   80.583747] BTRFS: device fsid 6a7321b0-ab2e-4dab-b594-38875c26340a devi=
d 1 transid 16082 /dev/sdb1 scanned by systemd-udevd (386)
[   81.403229] RAPL PMU: API unit is 2^-32 Joules, 2 fixed counters, 655360=
 ms ovfl timer
[   81.403615] probe of 0000:02:00.2 returned 0 after 1603492 usecs
[   81.405104] RAPL PMU: hw unit of domain package 2^-14 Joules
[   81.411881] IOAPIC[9]: Set IRTE entry (P:1 FPD:0 Dst_Mode:0 Redir_hint:1=
 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000000 SID:002C SQ:0 SVT=
:1)
[   81.416788] RAPL PMU: hw unit of domain dram 2^-16 Joules
[   81.419914] IOAPIC[1]: Preconfigured routing entry (9-14 -> IRQ 91 Level=
:1 ActiveLow:1)
[   81.421388] initcall rapl_pmu_init+0x0/0xee0 [rapl] returned 0 after 910=
154 usecs
[   81.483402] calling  sha512_ssse3_mod_init+0x0/0x1000 [sha512_ssse3] @ 3=
93
[   81.494002] initcall sha512_ssse3_mod_init+0x0/0x1000 [sha512_ssse3] ret=
urned 0 after 38 usecs
[   81.523201] calling  ghash_pclmulqdqni_mod_init+0x0/0x1000 [ghash_clmuln=
i_intel] @ 390
[   81.555364] initcall ghash_pclmulqdqni_mod_init+0x0/0x1000 [ghash_clmuln=
i_intel] returned 0 after 20826 usecs
[   81.596720] calling  crc32_pclmul_mod_init+0x0/0x1000 [crc32_pclmul] @ 3=
39
[   81.637367] initcall crc32_pclmul_mod_init+0x0/0x1000 [crc32_pclmul] ret=
urned 0 after 30280 usecs
[   81.669559] calling  crct10dif_intel_mod_init+0x0/0x1000 [crct10dif_pclm=
ul] @ 348
[   81.680924] initcall crct10dif_intel_mod_init+0x0/0x1000 [crct10dif_pclm=
ul] returned 0 after 30 usecs
[   81.873560] calling  kvm_x86_init+0x0/0x70 [kvm] @ 332
[   81.881059] initcall kvm_x86_init+0x0/0x70 [kvm] returned 0 after 1 usec=
s
[   81.951321] calling  vmx_init+0x0/0x690 [kvm_intel] @ 389
[   81.991928] initcall vmx_init+0x0/0x690 [kvm_intel] returned 0 after 329=
94 usecs
[   82.012870] calling  coretemp_init+0x0/0x1000 [coretemp] @ 334
[   83.091179] initcall coretemp_init+0x0/0x1000 [coretemp] returned 0 afte=
r 1068886 usecs
[   83.091901] probe of 0000:02:00.3 returned 0 after 1685146 usecs
[   83.114077] initcall ioat_init_module+0x0/0x1000 [ioatdma] returned 0 af=
ter 1091785 usecs
[   83.120691] calling  powerclamp_init+0x0/0x1000 [intel_powerclamp] @ 345
[   83.141654] initcall powerclamp_init+0x0/0x1000 [intel_powerclamp] retur=
ned 0 after 2105 usecs
[   83.162077] calling  pkg_temp_thermal_init+0x0/0x1000 [x86_pkg_temp_ther=
mal] @ 345
[   83.179366] initcall pkg_temp_thermal_init+0x0/0x1000 [x86_pkg_temp_ther=
mal] returned 0 after 6000 usecs
[   83.202091] calling  sbridge_init+0x0/0x1000 [sb_edac] @ 334
[   83.211441] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   83.220366] EDAC sbridge: Seeking for: PCI ID 8086:6fa0
[   83.229328] EDAC sbridge: Seeking for: PCI ID 8086:6f60
[   83.238288] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   83.245903] EDAC sbridge: Seeking for: PCI ID 8086:6fa8
[   83.253490] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   83.261125] EDAC sbridge: Seeking for: PCI ID 8086:6f71
[   83.268765] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   83.276420] EDAC sbridge: Seeking for: PCI ID 8086:6faa
[   83.283936] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   83.291520] EDAC sbridge: Seeking for: PCI ID 8086:6fab
[   83.299036] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   83.306549] EDAC sbridge: Seeking for: PCI ID 8086:6fac
[   83.313983] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   83.321315] EDAC sbridge: Seeking for: PCI ID 8086:6fad
[   83.328669] EDAC sbridge: Seeking for: PCI ID 8086:6f68
[   83.336016] EDAC sbridge: Seeking for: PCI ID 8086:6f79
[   83.343303] EDAC sbridge: Seeking for: PCI ID 8086:6f6a
[   83.350543] EDAC sbridge: Seeking for: PCI ID 8086:6f6b
[   83.357746] EDAC sbridge: Seeking for: PCI ID 8086:6f6c
[   83.364943] EDAC sbridge: Seeking for: PCI ID 8086:6f6d
[   83.372083] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   83.379152] EDAC sbridge: Seeking for: PCI ID 8086:6ffc
[   83.386191] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   83.393184] EDAC sbridge: Seeking for: PCI ID 8086:6ffd
[   83.400166] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   83.407048] EDAC sbridge: Seeking for: PCI ID 8086:6faf
[   83.416198] EDAC MC0: Giving out device to module sb_edac controller Bro=
adwell SrcID#0_Ha#0: DEV 0000:ff:12.0 (INTERRUPT)
[   83.429704] EDAC sbridge:  Ver: 1.1.2=20
[   83.435140] initcall sbridge_init+0x0/0x1000 [sb_edac] returned 0 after =
223703 usecs
[   83.455440] calling  rapl_init+0x0/0x1000 [intel_rapl_common] @ 345
[   83.463939] initcall rapl_init+0x0/0x1000 [intel_rapl_common] returned 0=
 after 550 usecs
[   83.480759] calling  intel_rapl_msr_driver_init+0x0/0x1000 [intel_rapl_m=
sr] @ 386
[   83.491001] intel_rapl_common: Found RAPL domain package
[   83.500911] intel_rapl_common: Found RAPL domain dram
[   83.510568] probe of intel_rapl_msr.0 returned 0 after 20191 usecs
[   83.518780] initcall intel_rapl_msr_driver_init+0x0/0x1000 [intel_rapl_m=
sr] returned 0 after 28536 usecs
[   85.375308] is_virt=3Dfalse

[   86.572334] BTRFS info (device sdb1): using crc32c (crc32c-intel) checks=
um algorithm
[   86.581677] BTRFS info (device sdb1): disk space caching is enabled
[   86.611796] BTRFS info (device sdb1): enabling ssd optimizations
[   86.619969] BTRFS info (device sdb1): auto enabling async discard
[   86.654192] lkp: kernel tainted state: 262148

[   87.114739] LKP: stdout: 472: Kernel tests: Boot OK!

[   88.390534] kmemleak: Automatic memory scanning thread ended
[   89.545535] calling  string_selftest_init+0x0/0xb30 [test_string] @ 743
[   89.770393] String selftests succeeded
[   89.775723] initcall string_selftest_init+0x0/0xb30 [test_string] return=
ed 0 after 221544 usecs
[   89.943069] calling  test_div64_init+0x0/0xc70 [test_div64] @ 747
[   89.950935] test_div64: Starting 64bit/32bit division and modulo test
[   89.960601] test_div64: Completed 64bit/32bit division and modulo test, =
0.001556191s elapsed
[   89.970727] initcall test_div64_init+0x0/0xc70 [test_div64] returned 0 a=
fter 19792 usecs
[   90.253923] calling  test_bpf_init+0x0/0xca0 [test_bpf] @ 751
[   90.261458] test_bpf: #0 TAX jited:1 39 41 41 PASS
[   90.277171] test_bpf: #1 TXA jited:1 10 10 10 PASS
[   90.286123] test_bpf: #2 ADD_SUB_MUL_K jited:1 10 PASS
[   90.295155] test_bpf: #3 DIV_MOD_KX jited:1 31 PASS
[   90.304763] test_bpf: #4 AND_OR_LSH_K jited:1 11 11 PASS
[   90.314817] test_bpf: #5 LD_IMM_0 jited:1 12 PASS
[   90.324159] test_bpf: #6 LD_IND jited:1 385 440 158 PASS
[   90.350217] test_bpf: #7 LD_ABS jited:1 23 22 22 PASS
[   90.359133] test_bpf: #8 LD_ABS_LL jited:1 40 41 PASS
[   90.369196] test_bpf: #9 LD_IND_LL jited:1 27 25 25 PASS
[   90.379140] test_bpf: #10 LD_ABS_NET jited:1 38 37 PASS
[   90.388153] test_bpf: #11 LD_IND_NET jited:1 25 24 24 PASS
[   90.397518] test_bpf: #12 LD_PKTTYPE jited:1 11 11 PASS
[   90.406413] test_bpf: #13 LD_MARK jited:1 10 10 PASS
[   90.416180] test_bpf: #14 LD_RXHASH jited:1 10 10 PASS
[   90.425176] test_bpf: #15 LD_QUEUE jited:1 10 10 PASS
[   90.434551] test_bpf: #16 LD_PROTOCOL jited:1 14 14 PASS
[   90.444818] test_bpf: #17 LD_VLAN_TAG jited:1 10 10 PASS
[   90.454707] test_bpf: #18 LD_VLAN_TAG_PRESENT jited:1 10 10 PASS
[   90.464150] test_bpf: #19 LD_IFINDEX jited:1 11 11 PASS
[   90.473937] test_bpf: #20 LD_HATYPE jited:1 12 12 PASS
[   90.483755] test_bpf: #21 LD_CPU jited:1 13 12 PASS
[   90.493154] test_bpf: #22 LD_NLATTR jited:1 16 27 PASS
[   90.502113] test_bpf: #23 LD_NLATTR_NEST jited:1 58 168 PASS
[   90.511445] test_bpf: #24 LD_PAYLOAD_OFF jited:1 472 481 PASS
[   90.521710] test_bpf: #25 LD_ANC_XOR jited:1 10 10 PASS
[   90.531163] test_bpf: #26 SPILL_FILL jited:1 12 12 12 PASS
[   90.541254] test_bpf: #27 JEQ jited:1 24 12 12 PASS
[   90.550152] test_bpf: #28 JGT jited:1 25 12 12 PASS
[   90.558635] test_bpf: #29 JGE (jt 0), test 1 jited:1 24 12 12 PASS
[   90.569127] test_bpf: #30 JGE (jt 0), test 2 jited:1 12 12 12 PASS
[   90.579016] test_bpf: #31 JGE jited:1 20 20 20 PASS
[   90.588632] test_bpf: #32 JSET jited:1 21 22 24 PASS
[   90.598066] test_bpf: #33 tcpdump port 22 jited:1 23 27 33 PASS
[   90.608692] test_bpf: #34 tcpdump complex jited:1 53 27 43 PASS
[   90.619165] test_bpf: #35 RET_A jited:1 10 10 PASS
[   90.628129] test_bpf: #36 INT: ADD trivial jited:1 10 PASS
[   90.637860] test_bpf: #37 INT: MUL_X jited:1 10 PASS
[   90.644246] LKP: stdout: 472: HOSTNAME lkp-bdw-de1, MAC 0c:c4:7a:c4:ab:7=
a, kernel 6.4.0-rc1-00002-g5f4287fc4655 1

[   90.647058] test_bpf: #38 INT: MUL_X2 jited:1 10 PASS
[   90.670501] test_bpf: #39 INT: MUL32_X jited:1 143 PASS
[   90.692207] test_bpf: #40 INT: ADD 64-bit jited:1 29 PASS
[   90.702146] test_bpf: #41 INT: ADD 32-bit jited:1 29 PASS
[   90.711163] test_bpf: #42 INT: SUB jited:1 28 PASS
[   90.720181] test_bpf: #43 INT: XOR jited:1 16 PASS
[   90.728855] test_bpf: #44 INT: MUL jited:1 23 PASS
[   90.737848] test_bpf: #45 MOV REG64 jited:1 13 PASS
[   90.746129] test_bpf: #46 MOV REG32 jited:1 13 PASS
[   90.754997] test_bpf: #47 LD IMM64 jited:1 27 PASS
[   90.763144] test_bpf: #48 INT: ALU MIX jited:1 30 PASS
[   90.772168] test_bpf: #49 INT: shifts by register jited:1 13 PASS
[   90.782076] test_bpf: #50 check: missing ret PASS
[   90.790542] test_bpf: #51 check: div_k_0 PASS
[   90.798133] test_bpf: #52 check: unknown insn PASS
[   90.806108] test_bpf: #53 check: out of range spill/fill PASS
[   90.814702] test_bpf: #54 JUMPS + HOLES jited:1 14 PASS
[   90.824730] test_bpf: #55 check: RET X PASS
[   90.832130] test_bpf: #56 check: LDX + RET X PASS
[   90.840853] test_bpf: #57 M[]: alt STX + LDX jited:1 49 PASS
[   90.853176] test_bpf: #58 M[]: full STX + full LDX jited:1 17 PASS
[   90.864075] test_bpf: #59 check: SKF_AD_MAX PASS
[   90.872180] test_bpf: #60 LD [SKF_AD_OFF-1] jited:1 23 PASS
[   90.882033] test_bpf: #61 load 64-bit immediate jited:1 12 PASS
[   90.891860] test_bpf: #62 ALU_MOV_X: dst =3D 2 jited:1 10 PASS
[   90.901778] test_bpf: #63 ALU_MOV_X: dst =3D 4294967295 jited:1 9 PASS
[   90.911185] test_bpf: #64 ALU64_MOV_X: dst =3D 2 jited:1 9 PASS
[   90.921139] test_bpf: #65 ALU64_MOV_X: dst =3D 4294967295 jited:1 10 PAS=
S
[   90.930634] test_bpf: #66 ALU_MOV_K: dst =3D 2 jited:1 9 PASS
[   90.939437] test_bpf: #67 ALU_MOV_K: dst =3D 4294967295 jited:1 9 PASS
[   90.948818] test_bpf: #68 ALU_MOV_K: 0x0000ffffffff0000 =3D 0x00000000ff=
ffffff jited:1 10 PASS
[   90.960589] test_bpf: #69 ALU_MOV_K: small negative jited:1 9 PASS
[   90.970004] test_bpf: #70 ALU_MOV_K: small negative zero extension jited=
:1 10 PASS
[   90.980748] test_bpf: #71 ALU_MOV_K: large negative jited:1 10 PASS
[   90.990600] test_bpf: #72 ALU_MOV_K: large negative zero extension jited=
:1 9 PASS
[   91.001262] test_bpf: #73 ALU64_MOV_K: dst =3D 2 jited:1 10 PASS
[   91.010479] test_bpf: #74 ALU64_MOV_K: dst =3D 2147483647 jited:1 10 PAS=
S
[   91.020127] test_bpf: #75 ALU64_OR_K: dst =3D 0x0 jited:1 11 PASS
[   91.030150] test_bpf: #76 ALU64_MOV_K: dst =3D -1 jited:1 10 PASS
[   91.040154] test_bpf: #77 ALU64_MOV_K: small negative jited:1 10 PASS
[   91.050750] test_bpf: #78 ALU64_MOV_K: small negative sign extension jit=
ed:1 10 PASS
[   91.062531] test_bpf: #79 ALU64_MOV_K: large negative jited:1 147 PASS
[   91.083207] test_bpf: #80 ALU64_MOV_K: large negative sign extension jit=
ed:1 9 PASS
[   91.094500] test_bpf: #81 ALU_ADD_X: 1 + 2 =3D 3 jited:1 9 PASS
[   91.104160] test_bpf: #82 ALU_ADD_X: 1 + 4294967294 =3D 4294967295 jited=
:1 10 PASS
[   91.115749] test_bpf: #83 ALU_ADD_X: 2 + 4294967294 =3D 0 jited:1 28 PAS=
S
[   91.126175] test_bpf: #84 ALU64_ADD_X: 1 + 2 =3D 3 jited:1 9 PASS
[   91.135252] test_bpf: #85 ALU64_ADD_X: 1 + 4294967294 =3D 4294967295 jit=
ed:1 9 PASS
[   91.146048] test_bpf: #86 ALU64_ADD_X: 2 + 4294967294 =3D 4294967296 jit=
ed:1 10 PASS
[   91.156790] test_bpf: #87 ALU_ADD_K: 1 + 2 =3D 3 jited:1 10 PASS
[   91.166125] test_bpf: #88 ALU_ADD_K: 3 + 0 =3D 3 jited:1 9 PASS
[   91.173292] install debs round one: dpkg -i --force-confdef --force-depe=
nds /opt/deb/ntpdate_1%3a4.2.8p15+dfsg-1_amd64.deb

[   91.176039] test_bpf: #89 ALU_ADD_K: 1 + 4294967294 =3D 4294967295=20
[   91.178764] Selecting previously unselected package ntpdate.
[   91.191226] jited:1=20

[   91.194512] 10=20
[   91.197862] (Reading database ... 16440 files and directories currently =
installed.)
[   91.203622] PASS

[   91.206739] test_bpf: #90 ALU_ADD_K: 4294967294 + 2 =3D 0=20
[   91.208835] Preparing to unpack .../ntpdate_1%3a4.2.8p15+dfsg-1_amd64.de=
b ...
[   91.215585] jited:1=20

[   91.219834] Unpacking ntpdate (1:4.2.8p15+dfsg-1) ...
[   91.222082] 10=20

[   91.224583] Setting up ntpdate (1:4.2.8p15+dfsg-1) ...
[   91.226927] PASS

[   91.229884] test_bpf: #91 ALU_ADD_K: 0 + (-1) =3D 0x00000000ffffffff=20
[   91.230503] NO_NETWORK=3D
[   91.232547] jited:1=20

[   91.242068] 10=20
[   91.245834] 12 Jun 00:40:29 ntpdate[563]: step time server 192.168.1.200=
 offset +38724292.536180 sec
[   91.246847] PASS

[   91.249815] test_bpf: #92 ALU_ADD_K: 0 + 0xffff =3D 0xffff jited:1 10 PA=
SS
[   91.338162] test_bpf: #93 ALU_ADD_K: 0 + 0x7fffffff =3D 0x7fffffff jited=
:1 10 PASS
[   91.349712] test_bpf: #94 ALU_ADD_K: 0 + 0x80000000 =3D 0x80000000 jited=
:1 11 PASS
[   91.361150] test_bpf: #95 ALU_ADD_K: 0 + 0x80008000 =3D 0x80008000 jited=
:1 10 PASS
[   91.372186] test_bpf: #96 ALU64_ADD_K: 1 + 2 =3D 3 jited:1 9 PASS
[   91.381427] test_bpf: #97 ALU64_ADD_K: 3 + 0 =3D 3 jited:1 9 PASS
[   91.390785] test_bpf: #98 ALU64_ADD_K: 1 + 2147483646 =3D 2147483647 jit=
ed:1 10 PASS
[   91.401717] test_bpf: #99 ALU64_ADD_K: 4294967294 + 2 =3D 4294967296 jit=
ed:1 11 PASS
[   91.412459] test_bpf: #100 ALU64_ADD_K: 2147483646 + -2147483647 =3D -1 =
jited:1 9 PASS
[   91.424172] test_bpf: #101 ALU64_ADD_K: 1 + 0 =3D 1 jited:1 10 PASS
[   91.433521] test_bpf: #102 ALU64_ADD_K: 0 + (-1) =3D 0xffffffffffffffff =
jited:1 10 PASS
[   91.445156] test_bpf: #103 ALU64_ADD_K: 0 + 0xffff =3D 0xffff jited:1 10=
 PASS
[   91.455392] test_bpf: #104 ALU64_ADD_K: 0 + 0x7fffffff =3D 0x7fffffff ji=
ted:1 10 PASS
[   91.466594] test_bpf: #105 ALU64_ADD_K: 0 + 0x80000000 =3D 0xffffffff800=
00000 jited:1 10 PASS
[   91.478284] test_bpf: #106 ALU_ADD_K: 0 + 0x80008000 =3D 0xffffffff80008=
000 jited:1 10 PASS
[   91.489974] test_bpf: #107 ALU_SUB_X: 3 - 1 =3D 2 jited:1 9 PASS
[   91.500142] test_bpf: #108 ALU_SUB_X: 4294967295 - 4294967294 =3D 1 jite=
d:1 9 PASS
[   91.510992] test_bpf: #109 ALU64_SUB_X: 3 - 1 =3D 2 jited:1 9 PASS
[   91.520777] test_bpf: #110 ALU64_SUB_X: 4294967295 - 4294967294 =3D 1 ji=
ted:1 13 PASS
[   91.531747] test_bpf: #111 ALU_SUB_K: 3 - 1 =3D 2 jited:1 10 PASS
[   91.541165] test_bpf: #112 ALU_SUB_K: 3 - 0 =3D 3 jited:1 9 PASS
[   91.550345] test_bpf: #113 ALU_SUB_K: 4294967295 - 4294967294 =3D 1 jite=
d:1 10 PASS
[   91.562042] test_bpf: #114 ALU64_SUB_K: 3 - 1 =3D 2 jited:1 10 PASS
[   91.572127] test_bpf: #115 ALU64_SUB_K: 3 - 0 =3D 3 jited:1 10 PASS
[   91.582437] test_bpf: #116 ALU64_SUB_K: 4294967294 - 4294967295 =3D -1 j=
ited:1 10 PASS
[   91.593217] test_bpf: #117 ALU64_ADD_K: 2147483646 - 2147483647 =3D -1 j=
ited:1 10 PASS
[   91.605133] test_bpf: #118 ALU_MUL_X: 2 * 3 =3D 6 jited:1 28 PASS
[   91.628141] test_bpf: #119 ALU_MUL_X: 2 * 0x7FFFFFF8 =3D 0xFFFFFFF0 jite=
d:1 10 PASS
[   91.639356] test_bpf: #120 ALU_MUL_X: -1 * -1 =3D 1 jited:1 9 PASS
[   91.648789] test_bpf: #121 ALU64_MUL_X: 2 * 3 =3D 6 jited:1 10 PASS
[   91.659137] test_bpf: #122 ALU64_MUL_X: 1 * 2147483647 =3D 2147483647 ji=
ted:1 9 PASS
[   91.669957] test_bpf: #123 ALU64_MUL_X: 64x64 multiply, low word jited:1=
 10 PASS
[   91.680976] test_bpf: #124 ALU64_MUL_X: 64x64 multiply, high word jited:=
1 10 PASS
[   91.693051] test_bpf: #125 ALU_MUL_K: 2 * 3 =3D 6 jited:1 10 PASS
[   91.703172] test_bpf: #126 ALU_MUL_K: 3 * 1 =3D 3 jited:1 10 PASS
[   91.713141] test_bpf: #127 ALU_MUL_K: 2 * 0x7FFFFFF8 =3D 0xFFFFFFF0 jite=
d:1 10 PASS
[   91.723746] test_bpf: #128 ALU_MUL_K: 1 * (-1) =3D 0x00000000ffffffff ji=
ted:1 10 PASS
[   91.735138] test_bpf: #129 ALU64_MUL_K: 2 * 3 =3D 6 jited:1 10 PASS
[   91.744593] test_bpf: #130 ALU64_MUL_K: 3 * 1 =3D 3 jited:1 9 PASS
[   91.754074] test_bpf: #131 ALU64_MUL_K: 1 * 2147483647 =3D 2147483647 ji=
ted:1 9 PASS
[   91.765132] test_bpf: #132 ALU64_MUL_K: 1 * -2147483647 =3D -2147483647 =
jited:1 9 PASS
[   91.776296] test_bpf: #133 ALU64_MUL_K: 1 * (-1) =3D 0xffffffffffffffff =
jited:1 10 PASS
[   91.787547] test_bpf: #134 ALU64_MUL_K: 64x32 multiply, low word jited:1=
 40 PASS
[   91.799153] test_bpf: #135 ALU64_MUL_K: 64x32 multiply, high word jited:=
1 10 PASS
[   91.809959] test_bpf: #136 ALU_DIV_X: 6 / 2 =3D 3 jited:1 13 PASS
[   91.820177] test_bpf: #137 ALU_DIV_X: 4294967295 / 4294967295 =3D 1 jite=
d:1 13 PASS
[   91.831140] test_bpf: #138 ALU64_DIV_X: 6 / 2 =3D 3 jited:1 19 PASS
[   91.840567] test_bpf: #139 ALU64_DIV_X: 2147483647 / 2147483647 =3D 1 ji=
ted:1 19 PASS
[   91.851672] test_bpf: #140 ALU64_DIV_X: 0xffffffffffffffff / (-1) =3D 0x=
0000000000000001 jited:1 19 PASS
[   91.864259] test_bpf: #141 ALU_DIV_K: 6 / 2 =3D 3 jited:1 13 PASS
[   91.873617] test_bpf: #142 ALU_DIV_K: 3 / 1 =3D 3 jited:1 13 PASS
[   91.883337] test_bpf: #143 ALU_DIV_K: 4294967295 / 4294967295 =3D 1 jite=
d:1 13 PASS
[   91.894171] test_bpf: #144 ALU_DIV_K: 0xffffffffffffffff / (-1) =3D 0x1 =
jited:1 14 PASS
[   91.905529] test_bpf: #145 ALU64_DIV_K: 6 / 2 =3D 3 jited:1 19 PASS
[   91.915142] test_bpf: #146 ALU64_DIV_K: 3 / 1 =3D 3 jited:1 20 PASS
[   91.924773] test_bpf: #147 ALU64_DIV_K: 2147483647 / 2147483647 =3D 1 ji=
ted:1 19 PASS
[   91.936157] test_bpf: #148 ALU64_DIV_K: 0xffffffffffffffff / (-1) =3D 0x=
0000000000000001 jited:1 20 PASS
[   91.948997] test_bpf: #149 ALU_MOD_X: 3 % 2 =3D 1 jited:1 13 PASS
[   91.958159] test_bpf: #150 ALU_MOD_X: 4294967295 % 4294967293 =3D 2 jite=
d:1 128 PASS
[   91.969752] test_bpf: #151 ALU64_MOD_X: 3 % 2 =3D 1 jited:1 20 PASS
[   91.980157] test_bpf: #152 ALU64_MOD_X: 2147483647 % 2147483645 =3D 2 ji=
ted:1 48 PASS
[   91.991331] test_bpf: #153 ALU_MOD_K: 3 % 2 =3D 1 jited:1 14 PASS
[   92.001565] test_bpf: #154 ALU_MOD_K: 3 % 1 =3D 0 jited:1 13 PASS
[   92.011754] test_bpf: #155 ALU_MOD_K: 4294967295 % 4294967293 =3D 2 jite=
d:1 14 PASS
[   92.023207] test_bpf: #156 ALU64_MOD_K: 3 % 2 =3D 1 jited:1 20 PASS
[   92.032739] test_bpf: #157 ALU64_MOD_K: 3 % 1 =3D 0 jited:1 19 PASS
[   92.042347] test_bpf: #158 ALU64_MOD_K: 2147483647 % 2147483645 =3D 2 ji=
ted:1 20 PASS
[   92.053522] test_bpf: #159 ALU_AND_X: 3 & 2 =3D 2 jited:1 11 PASS
[   92.062782] test_bpf: #160 ALU_AND_X: 0xffffffff & 0xffffffff =3D 0xffff=
ffff jited:1 10 PASS
[   92.074644] test_bpf: #161 ALU64_AND_X: 3 & 2 =3D 2 jited:1 9 PASS
[   92.084090] test_bpf: #162 ALU64_AND_X: 0xffffffff & 0xffffffff =3D 0xff=
ffffff jited:1 10 PASS
[   92.095872] test_bpf: #163 ALU_AND_K: 3 & 2 =3D 2 jited:1 10 PASS
[   92.106287] test_bpf: #164 ALU_AND_K: 0xffffffff & 0xffffffff =3D 0xffff=
ffff jited:1 9 PASS
[   92.118161] test_bpf: #165 ALU_AND_K: Small immediate jited:1 9 PASS
[   92.128128] test_bpf: #166 ALU_AND_K: Large immediate jited:1 9 PASS
[   92.137913] test_bpf: #167 ALU_AND_K: Zero extension jited:1 10 PASS
[   92.147935] test_bpf: #168 ALU64_AND_K: 3 & 2 =3D 2 jited:1 10 PASS
[   92.157512] test_bpf: #169 ALU64_AND_K: 0xffffffff & 0xffffffff =3D 0xff=
ffffff jited:1 9 PASS
[   92.169508] test_bpf: #170 ALU64_AND_K: 0x0000ffffffff0000 & 0x0 =3D 0x0=
000000000000000 jited:1 10 PASS
[   92.182061] test_bpf: #171 ALU64_AND_K: 0x0000ffffffff0000 & -1 =3D 0x00=
00ffffffff0000 jited:1 10 PASS
[   92.194697] test_bpf: #172 ALU64_AND_K: 0xffffffffffffffff & -1 =3D 0xff=
ffffffffffffff jited:1 10 PASS
[   92.207551] test_bpf: #173 ALU64_AND_K: Sign extension 1 jited:1 10 PASS
[   92.217496] test_bpf: #174 ALU64_AND_K: Sign extension 2 jited:1 10 PASS
[   92.227582] test_bpf: #175 ALU_OR_X: 1 | 2 =3D 3 jited:1 10 PASS
[   92.236703] test_bpf: #176 ALU_OR_X: 0x0 | 0xffffffff =3D 0xffffffff jit=
ed:1 9 PASS
[   92.247582] test_bpf: #177 ALU64_OR_X: 1 | 2 =3D 3 jited:1 9 PASS
[   92.256952] test_bpf: #178 ALU64_OR_X: 0 | 0xffffffff =3D 0xffffffff jit=
ed:1 9 PASS
[   92.268016] test_bpf: #179 ALU_OR_K: 1 | 2 =3D 3 jited:1 9 PASS
[   92.278125] test_bpf: #180 ALU_OR_K: 0 & 0xffffffff =3D 0xffffffff jited=
:1 9 PASS
[   92.288766] test_bpf: #181 ALU_OR_K: Small immediate jited:1 20 PASS
[   92.299767] test_bpf: #182 ALU_OR_K: Large immediate jited:1 9 PASS
[   92.310129] test_bpf: #183 ALU_OR_K: Zero extension jited:1 10 PASS
[   92.319937] test_bpf: #184 ALU64_OR_K: 1 | 2 =3D 3 jited:1 10 PASS
[   92.329414] test_bpf: #185 ALU64_OR_K: 0 & 0xffffffff =3D 0xffffffff jit=
ed:1 9 PASS
[   92.340486] test_bpf: #186 ALU64_OR_K: 0x0000ffffffff0000 | 0x0 =3D 0x00=
00ffffffff0000 jited:1 10 PASS
[   92.352870] test_bpf: #187 ALU64_OR_K: 0x0000ffffffff0000 | -1 =3D 0xfff=
fffffffffffff jited:1 10 PASS
[   92.365639] test_bpf: #188 ALU64_OR_K: 0x000000000000000 | -1 =3D 0xffff=
ffffffffffff jited:1 10 PASS
[   92.378869] test_bpf: #189 ALU64_OR_K: Sign extension 1 jited:1 10 PASS
[   92.389430] test_bpf: #190 ALU64_OR_K: Sign extension 2 jited:1 10 PASS
[   92.399296] test_bpf: #191 ALU_XOR_X: 5 ^ 6 =3D 3 jited:1 9 PASS
[   92.408487] test_bpf: #192 ALU_XOR_X: 0x1 ^ 0xffffffff =3D 0xfffffffe ji=
ted:1 9 PASS
[   92.419369] test_bpf: #193 ALU64_XOR_X: 5 ^ 6 =3D 3 jited:1 9 PASS
[   92.428888] test_bpf: #194 ALU64_XOR_X: 1 ^ 0xffffffff =3D 0xfffffffe ji=
ted:1 9 PASS
[   92.440144] test_bpf: #195 ALU_XOR_K: 5 ^ 6 =3D 3 jited:1 9 PASS
[   92.449667] test_bpf: #196 ALU_XOR_K: 1 ^ 0xffffffff =3D 0xfffffffe jite=
d:1 9 PASS
[   92.460408] test_bpf: #197 ALU_XOR_K: Small immediate jited:1 9 PASS
[   92.470331] test_bpf: #198 ALU_XOR_K: Large immediate jited:1 9 PASS
[   92.480028] test_bpf: #199 ALU_XOR_K: Zero extension jited:1 11 PASS
[   92.489825] test_bpf: #200 ALU64_XOR_K: 5 ^ 6 =3D 3 jited:1 9 PASS
[   92.500133] test_bpf: #201 ALU64_XOR_K: 1 ^ 0xffffffff =3D 0xfffffffe ji=
ted:1 10 PASS
[   92.511819] test_bpf: #202 ALU64_XOR_K: 0x0000ffffffff0000 ^ 0x0 =3D 0x0=
000ffffffff0000 jited:1 10 PASS
[   92.525290] test_bpf: #203 ALU64_XOR_K: 0x0000ffffffff0000 ^ -1 =3D 0xff=
ff00000000ffff jited:1 10 PASS
[   92.537803] test_bpf: #204 ALU64_XOR_K: 0x000000000000000 ^ -1 =3D 0xfff=
fffffffffffff jited:1 12 PASS
[   92.550099] test_bpf: #205 ALU64_XOR_K: Sign extension 1 jited:1 10 PASS
[   92.560228] test_bpf: #206 ALU64_XOR_K: Sign extension 2 jited:1 10 PASS
[   92.570388] test_bpf: #207 ALU_LSH_X: 1 << 1 =3D 2 jited:1 9 PASS
[   92.580186] test_bpf: #208 ALU_LSH_X: 1 << 31 =3D 0x80000000 jited:1 10 =
PASS
[   92.590492] test_bpf: #209 ALU_LSH_X: 0x12345678 << 12 =3D 0x45678000 ji=
ted:1 9 PASS
[   92.601407] test_bpf: #210 ALU64_LSH_X: 1 << 1 =3D 2 jited:1 9 PASS
[   92.610849] test_bpf: #211 ALU64_LSH_X: 1 << 31 =3D 0x80000000 jited:1 1=
0 PASS
[   92.621423] test_bpf: #212 ALU64_LSH_X: Shift < 32, low word jited:1 10 =
PASS
[   92.632020] test_bpf: #213 ALU64_LSH_X: Shift < 32, high word jited:1 10=
 PASS
[   92.642483] test_bpf: #214 ALU64_LSH_X: Shift > 32, low word jited:1 10 =
PASS
[   92.652957] test_bpf: #215 ALU64_LSH_X: Shift > 32, high word jited:1 10=
 PASS
[   92.663421] test_bpf: #216 ALU64_LSH_X: Shift =3D=3D 32, low word jited:=
1 10 PASS
[   92.673897] test_bpf: #217 ALU64_LSH_X: Shift =3D=3D 32, high word jited=
:1 10 PASS
[   92.684855] test_bpf: #218 ALU64_LSH_X: Zero shift, low word jited:1 10 =
PASS
[   92.695153] test_bpf: #219 ALU64_LSH_X: Zero shift, high word jited:1 10=
 PASS
[   92.705806] test_bpf: #220 ALU_LSH_K: 1 << 1 =3D 2 jited:1 10 PASS
[   92.716152] test_bpf: #221 ALU_LSH_K: 1 << 31 =3D 0x80000000 jited:1 19 =
PASS
[   92.727746] test_bpf: #222 ALU_LSH_K: 0x12345678 << 12 =3D 0x45678000 ji=
ted:1 9 PASS
[   92.739502] test_bpf: #223 ALU_LSH_K: 0x12345678 << 0 =3D 0x12345678 jit=
ed:1 20 PASS
[   92.751629] test_bpf: #224 ALU64_LSH_K: 1 << 1 =3D 2 jited:1 9 PASS
[   92.762442] test_bpf: #225 ALU64_LSH_K: 1 << 31 =3D 0x80000000 jited:1 9=
 PASS
[   92.772550] test_bpf: #226 ALU64_LSH_K: Shift < 32, low word jited:1 10 =
PASS
[   92.782941] test_bpf: #227 ALU64_LSH_K: Shift < 32, high word jited:1 10=
 PASS
[   92.794159] test_bpf: #228 ALU64_LSH_K: Shift > 32, low word jited:1 10 =
PASS
[   92.804443] test_bpf: #229 ALU64_LSH_K: Shift > 32, high word jited:1 10=
 PASS
[   92.815153] test_bpf: #230 ALU64_LSH_K: Shift =3D=3D 32, low word jited:=
1 10 PASS
[   92.825476] test_bpf: #231 ALU64_LSH_K: Shift =3D=3D 32, high word jited=
:1 10 PASS
[   92.835740] test_bpf: #232 ALU64_LSH_K: Zero shift jited:1 10 PASS
[   92.846162] test_bpf: #233 ALU_RSH_X: 2 >> 1 =3D 1 jited:1 10 PASS
[   92.855178] test_bpf: #234 ALU_RSH_X: 0x80000000 >> 31 =3D 1 jited:1 9 P=
ASS
[   92.865298] test_bpf: #235 ALU_RSH_X: 0x12345678 >> 20 =3D 0x123 jited:1=
 9 PASS
[   92.875720] test_bpf: #236 ALU64_RSH_X: 2 >> 1 =3D 1 jited:1 10 PASS
[   92.885164] test_bpf: #237 ALU64_RSH_X: 0x80000000 >> 31 =3D 1 jited:1 1=
0 PASS
[   92.895548] test_bpf: #238 ALU64_RSH_X: Shift < 32, low word jited:1 10 =
PASS
[   92.906768] test_bpf: #239 ALU64_RSH_X: Shift < 32, high word jited:1 10=
 PASS
[   92.917174] test_bpf: #240 ALU64_RSH_X: Shift > 32, low word jited:1 10 =
PASS
[   92.928169] test_bpf: #241 ALU64_RSH_X: Shift > 32, high word jited:1 10=
 PASS
[   92.938676] test_bpf: #242 ALU64_RSH_X: Shift =3D=3D 32, low word jited:=
1 126 PASS
[   92.949210] test_bpf: #243 ALU64_RSH_X: Shift =3D=3D 32, high word jited=
:1 10 PASS
[   92.959983] test_bpf: #244 ALU64_RSH_X: Zero shift, low word jited:1 10 =
PASS
[   92.970221] test_bpf: #245 ALU64_RSH_X: Zero shift, high word jited:1 10=
 PASS
[   92.981163] test_bpf: #246 ALU_RSH_K: 2 >> 1 =3D 1 jited:1 10 PASS
[   92.991163] test_bpf: #247 ALU_RSH_K: 0x80000000 >> 31 =3D 1 jited:1 10 =
PASS
[   93.002237] test_bpf: #248 ALU_RSH_K: 0x12345678 >> 20 =3D 0x123 jited:1=
 10 PASS
[   93.013144] test_bpf: #249 ALU_RSH_K: 0x12345678 >> 0 =3D 0x12345678 jit=
ed:1 10 PASS
[   93.024134] test_bpf: #250 ALU64_RSH_K: 2 >> 1 =3D 1 jited:1 9 PASS
[   93.034128] test_bpf: #251 ALU64_RSH_K: 0x80000000 >> 31 =3D 1 jited:1 9=
 PASS
[   93.045109] test_bpf: #252 ALU64_RSH_K: Shift < 32, low word jited:1 10 =
PASS
[   93.055186] test_bpf: #253 ALU64_RSH_K: Shift < 32, high word jited:1 10=
 PASS
[   93.065801] test_bpf: #254 ALU64_RSH_K: Shift > 32, low word jited:1 10 =
PASS
[   93.076699] test_bpf: #255 ALU64_RSH_K: Shift > 32, high word jited:1 10=
 PASS
[   93.087149] test_bpf: #256 ALU64_RSH_K: Shift =3D=3D 32, low word jited:=
1 10 PASS
[   93.098182] test_bpf: #257 ALU64_RSH_K: Shift =3D=3D 32, high word jited=
:1 10 PASS
[   93.109179] test_bpf: #258 ALU64_RSH_K: Zero shift jited:1 10 PASS
[   93.119190] test_bpf: #259 ALU32_ARSH_X: -1234 >> 7 =3D -10 jited:1 10 P=
ASS
[   93.129132] test_bpf: #260 ALU64_ARSH_X: 0xff00ff0000000000 >> 40 =3D 0x=
ffffffffffff00ff jited:1 38 PASS
[   93.141642] test_bpf: #261 ALU64_ARSH_X: Shift < 32, low word jited:1 10=
 PASS
[   93.151838] test_bpf: #262 ALU64_ARSH_X: Shift < 32, high word jited:1 1=
0 PASS
[   93.162537] test_bpf: #263 ALU64_ARSH_X: Shift > 32, low word jited:1 10=
 PASS
[   93.172851] test_bpf: #264 ALU64_ARSH_X: Shift > 32, high word jited:1 1=
0 PASS
[   93.184129] test_bpf: #265 ALU64_ARSH_X: Shift =3D=3D 32, low word jited=
:1 10 PASS
[   93.194953] test_bpf: #266 ALU64_ARSH_X: Shift =3D=3D 32, high word jite=
d:1 10 PASS
[   93.205609] test_bpf: #267 ALU64_ARSH_X: Zero shift, low word jited:1 10=
 PASS
[   93.216176] test_bpf: #268 ALU64_ARSH_X: Zero shift, high word jited:1 1=
0 PASS
[   93.226695] test_bpf: #269 ALU32_ARSH_K: -1234 >> 7 =3D -10 jited:1 10 P=
ASS
[   93.237142] test_bpf: #270 ALU32_ARSH_K: -1234 >> 0 =3D -1234 jited:1 9 =
PASS
[   93.247256] test_bpf: #271 ALU64_ARSH_K: 0xff00ff0000000000 >> 40 =3D 0x=
ffffffffffff00ff jited:1 10 PASS
[   93.260160] test_bpf: #272 ALU64_ARSH_K: Shift < 32, low word jited:1 10=
 PASS
[   93.271159] test_bpf: #273 ALU64_ARSH_K: Shift < 32, high word jited:1 1=
0 PASS
[   93.281648] test_bpf: #274 ALU64_ARSH_K: Shift > 32, low word jited:1 10=
 PASS
[   93.292124] test_bpf: #275 ALU64_ARSH_K: Shift > 32, high word jited:1 3=
8 PASS
[   93.302585] test_bpf: #276 ALU64_ARSH_K: Shift =3D=3D 32, low word jited=
:1 10 PASS
[   93.313124] test_bpf: #277 ALU64_ARSH_K: Shift =3D=3D 32, high word jite=
d:1 10 PASS
[   93.323722] test_bpf: #278 ALU64_ARSH_K: Zero shift jited:1 10 PASS
[   93.334127] test_bpf: #279 ALU_NEG: -(3) =3D -3 jited:1 9 PASS
[   93.343143] test_bpf: #280 ALU_NEG: -(-3) =3D 3 jited:1 9 PASS
[   93.353172] test_bpf: #281 ALU64_NEG: -(3) =3D -3 jited:1 10 PASS
[   93.363075] test_bpf: #282 ALU64_NEG: -(-3) =3D 3 jited:1 10 PASS
[   93.373169] test_bpf: #283 ALU_END_FROM_BE 16: 0x0123456789abcdef -> 0xc=
def jited:1 10 PASS
[   93.384613] test_bpf: #284 ALU_END_FROM_BE 32: 0x0123456789abcdef -> 0x8=
9abcdef jited:1 10 PASS
[   93.396524] test_bpf: #285 ALU_END_FROM_BE 64: 0x0123456789abcdef -> 0x8=
9abcdef jited:1 10 PASS
[   93.408563] test_bpf: #286 ALU_END_FROM_BE 64: 0x0123456789abcdef >> 32 =
-> 0x01234567 jited:1 10 PASS
[   93.421146] test_bpf: #287 ALU_END_FROM_BE 16: 0xfedcba9876543210 -> 0x3=
210 jited:1 10 PASS
[   93.432909] test_bpf: #288 ALU_END_FROM_BE 32: 0xfedcba9876543210 -> 0x7=
6543210 jited:1 10 PASS
[   93.445350] test_bpf: #289 ALU_END_FROM_BE 64: 0xfedcba9876543210 -> 0x7=
6543210 jited:1 10 PASS
[   93.457239] test_bpf: #290 ALU_END_FROM_BE 64: 0xfedcba9876543210 >> 32 =
-> 0xfedcba98 jited:1 10 PASS
[   93.469946] test_bpf: #291 ALU_END_FROM_LE 16: 0x0123456789abcdef -> 0xe=
fcd jited:1 10 PASS
[   93.482151] test_bpf: #292 ALU_END_FROM_LE 32: 0x0123456789abcdef -> 0xe=
fcdab89 jited:1 10 PASS
[   93.494046] test_bpf: #293 ALU_END_FROM_LE 64: 0x0123456789abcdef -> 0x6=
7452301 jited:1 9 PASS
[   93.506132] test_bpf: #294 ALU_END_FROM_LE 64: 0x0123456789abcdef >> 32 =
-> 0xefcdab89 jited:1 25 PASS
[   93.518449] test_bpf: #295 ALU_END_FROM_LE 16: 0xfedcba9876543210 -> 0x1=
032 jited:1 19 PASS
[   93.537031] test_bpf: #296 ALU_END_FROM_LE 32: 0xfedcba9876543210 -> 0x1=
0325476 jited:1 19 PASS
[   93.554946] test_bpf: #297 ALU_END_FROM_LE 64: 0xfedcba9876543210 -> 0x1=
0325476 jited:1 20 PASS
[   93.572976] test_bpf: #298 ALU_END_FROM_LE 64: 0xfedcba9876543210 >> 32 =
-> 0x98badcfe jited:1 10 PASS
[   93.585941] test_bpf: #299 BPF_LDX_MEM | BPF_B, base jited:1 22 PASS
[   93.595539] test_bpf: #300 BPF_LDX_MEM | BPF_B, MSB set jited:1 11 PASS
[   93.605063] test_bpf: #301 BPF_LDX_MEM | BPF_B, negative offset jited:1 =
14 PASS
[   93.615272] test_bpf: #302 BPF_LDX_MEM | BPF_B, small positive offset ji=
ted:1 11 PASS
[   93.628608] test_bpf: #303 BPF_LDX_MEM | BPF_B, large positive offset ji=
ted:1 10 PASS
[   93.639412] test_bpf: #304 BPF_LDX_MEM | BPF_H, base jited:1 11 PASS
[   93.648739] test_bpf: #305 BPF_LDX_MEM | BPF_H, MSB set jited:1 10 PASS
[   93.658513] test_bpf: #306 BPF_LDX_MEM | BPF_H, negative offset jited:1 =
10 PASS
[   93.668787] test_bpf: #307 BPF_LDX_MEM | BPF_H, small positive offset ji=
ted:1 11 PASS
[   93.679870] test_bpf: #308 BPF_LDX_MEM | BPF_H, large positive offset ji=
ted:1 11 PASS
[   93.691081] test_bpf: #309 BPF_LDX_MEM | BPF_H, unaligned positive offse=
t jited:1 10 PASS
[   93.702351] test_bpf: #310 BPF_LDX_MEM | BPF_W, base jited:1 10 PASS
[   93.712000] test_bpf: #311 BPF_LDX_MEM | BPF_W, MSB set jited:1 10 PASS
[   93.724009] test_bpf: #312 BPF_LDX_MEM | BPF_W, negative offset jited:1 =
10 PASS
[   93.735120] test_bpf: #313 BPF_LDX_MEM | BPF_W, small positive offset ji=
ted:1 10 PASS
[   93.745748] test_bpf: #314 BPF_LDX_MEM | BPF_W, large positive offset ji=
ted:1 11 PASS
[   93.756798] test_bpf: #315 BPF_LDX_MEM | BPF_W, unaligned positive offse=
t jited:1 10 PASS
[   93.768175] test_bpf: #316 BPF_LDX_MEM | BPF_DW, base jited:1 10 PASS
[   93.777820] test_bpf: #317 BPF_LDX_MEM | BPF_DW, MSB set jited:1 10 PASS
[   93.787827] test_bpf: #318 BPF_LDX_MEM | BPF_DW, negative offset jited:1=
 14 PASS
[   93.798410] test_bpf: #319 BPF_LDX_MEM | BPF_DW, small positive offset j=
ited:1 10 PASS
[   93.809497] test_bpf: #320 BPF_LDX_MEM | BPF_DW, large positive offset j=
ited:1 10 PASS
[   93.820425] test_bpf: #321 BPF_LDX_MEM | BPF_DW, unaligned positive offs=
et jited:1 10 PASS
[   93.831856] test_bpf: #322 BPF_STX_MEM | BPF_B jited:1 15 PASS
[   93.841114] test_bpf: #323 BPF_STX_MEM | BPF_B, MSB set jited:1 14 PASS
[   93.850936] test_bpf: #324 BPF_STX_MEM | BPF_H jited:1 15 PASS
[   93.860141] test_bpf: #325 BPF_STX_MEM | BPF_H, MSB set jited:1 15 PASS
[   93.869980] test_bpf: #326 BPF_STX_MEM | BPF_W jited:1 43 PASS
[   93.879221] test_bpf: #327 BPF_STX_MEM | BPF_W, MSB set jited:1 14 PASS
[   93.889111] test_bpf: #328 ST_MEM_B: Store/Load byte: max negative jited=
:1 10 PASS
[   93.900124] test_bpf: #329 ST_MEM_B: Store/Load byte: max positive jited=
:1 10 PASS
[   93.910865] test_bpf: #330 STX_MEM_B: Store/Load byte: max negative jite=
d:1 10 PASS
[   93.921943] test_bpf: #331 ST_MEM_H: Store/Load half word: max negative =
jited:1 10 PASS
[   93.933177] test_bpf: #332 ST_MEM_H: Store/Load half word: max positive =
jited:1 9 PASS
[   93.944325] test_bpf: #333 STX_MEM_H: Store/Load half word: max negative=
 jited:1 10 PASS
[   93.955539] test_bpf: #334 ST_MEM_W: Store/Load word: max negative jited=
:1 10 PASS
[   93.966429] test_bpf: #335 ST_MEM_W: Store/Load word: max positive jited=
:1 10 PASS
[   93.979425] test_bpf: #336 STX_MEM_W: Store/Load word: max negative jite=
d:1 10 PASS
[   93.991082] test_bpf: #337 ST_MEM_DW: Store/Load double word: max negati=
ve jited:1 10 PASS
[   94.002798] test_bpf: #338 ST_MEM_DW: Store/Load double word: max negati=
ve 2 jited:1 10 PASS
[   94.014391] test_bpf: #339 ST_MEM_DW: Store/Load double word: max positi=
ve jited:1 10 PASS
[   94.025805] test_bpf: #340 STX_MEM_DW: Store/Load double word: max negat=
ive jited:1 10 PASS
[   94.037688] test_bpf: #341 STX_MEM_DW: Store double word: first word in =
memory jited:1 10 PASS
[   94.049549] test_bpf: #342 STX_MEM_DW: Store double word: second word in=
 memory jited:1 10 PASS
[   94.061660] test_bpf: #343 STX_XADD_W: X + 1 + 1 + 1 + ... jited:1 34998=
 PASS
[   94.108154] test_bpf: #344 STX_XADD_DW: X + 1 + 1 + 1 + ... jited:1 4688=
3 PASS
[   94.167156] test_bpf: #345 BPF_ATOMIC | BPF_W, BPF_ADD: Test: 0x12 + 0xa=
b =3D 0xbd jited:1 24 PASS
[   94.178998] test_bpf: #346 BPF_ATOMIC | BPF_W, BPF_ADD: Test side effect=
s, r10: 0x12 + 0xab =3D 0xbd jited:1 22 PASS
[   94.193163] test_bpf: #347 BPF_ATOMIC | BPF_W, BPF_ADD: Test side effect=
s, r0: 0x12 + 0xab =3D 0xbd jited:1 22 PASS
[   94.206698] test_bpf: #348 BPF_ATOMIC | BPF_W, BPF_ADD: Test fetch: 0x12=
 + 0xab =3D 0xbd jited:1 20 PASS
[   94.219422] test_bpf: #349 BPF_ATOMIC | BPF_W, BPF_ADD | BPF_FETCH: Test=
: 0x12 + 0xab =3D 0xbd jited:1 23 PASS
[   94.232526] test_bpf: #350 BPF_ATOMIC | BPF_W, BPF_ADD | BPF_FETCH: Test=
 side effects, r10: 0x12 + 0xab =3D 0xbd jited:1 24 PASS
[   94.248007] test_bpf: #351 BPF_ATOMIC | BPF_W, BPF_ADD | BPF_FETCH: Test=
 side effects, r0: 0x12 + 0xab =3D 0xbd jited:1 39 PASS
[   94.264171] test_bpf: #352 BPF_ATOMIC | BPF_W, BPF_ADD | BPF_FETCH: Test=
 fetch: 0x12 + 0xab =3D 0xbd jited:1 22 PASS
[   94.277936] test_bpf: #353 BPF_ATOMIC | BPF_DW, BPF_ADD: Test: 0x12 + 0x=
ab =3D 0xbd jited:1 24 PASS
[   94.290338] test_bpf: #354 BPF_ATOMIC | BPF_DW, BPF_ADD: Test side effec=
ts, r10: 0x12 + 0xab =3D 0xbd jited:1 22 PASS
[   94.304244] test_bpf: #355 BPF_ATOMIC | BPF_DW, BPF_ADD: Test side effec=
ts, r0: 0x12 + 0xab =3D 0xbd jited:1 21 PASS
[   94.318998] test_bpf: #356 BPF_ATOMIC | BPF_DW, BPF_ADD: Test fetch: 0x1=
2 + 0xab =3D 0xbd jited:1 21 PASS
[   94.332151] test_bpf: #357 BPF_ATOMIC | BPF_DW, BPF_ADD | BPF_FETCH: Tes=
t: 0x12 + 0xab =3D 0xbd jited:1 24 PASS
[   94.345603] test_bpf: #358 BPF_ATOMIC | BPF_DW, BPF_ADD | BPF_FETCH: Tes=
t side effects, r10: 0x12 + 0xab =3D 0xbd jited:1 21 PASS
[   94.362072] test_bpf: #359 BPF_ATOMIC | BPF_DW, BPF_ADD | BPF_FETCH: Tes=
t side effects, r0: 0x12 + 0xab =3D 0xbd jited:1 22 PASS
[   94.378737] test_bpf: #360 BPF_ATOMIC | BPF_DW, BPF_ADD | BPF_FETCH: Tes=
t fetch: 0x12 + 0xab =3D 0xbd jited:1 28 PASS
[   94.392997] test_bpf: #361 BPF_ATOMIC | BPF_W, BPF_AND: Test: 0x12 & 0xa=
b =3D 0x02 jited:1 30 PASS
[   94.405600] test_bpf: #362 BPF_ATOMIC | BPF_W, BPF_AND: Test side effect=
s, r10: 0x12 & 0xab =3D 0x02 jited:1 22 PASS
[   94.419815] test_bpf: #363 BPF_ATOMIC | BPF_W, BPF_AND: Test side effect=
s, r0: 0x12 & 0xab =3D 0x02 jited:1 21 PASS
[   94.434205] test_bpf: #364 BPF_ATOMIC | BPF_W, BPF_AND: Test fetch: 0x12=
 & 0xab =3D 0x02 jited:1 20 PASS
[   94.447446] test_bpf: #365 BPF_ATOMIC | BPF_W, BPF_AND | BPF_FETCH: Test=
: 0x12 & 0xab =3D 0x02 jited:1 22 PASS
[   94.461079] test_bpf: #366 BPF_ATOMIC | BPF_W, BPF_AND | BPF_FETCH: Test=
 side effects, r10: 0x12 & 0xab =3D 0x02 jited:1 21 PASS
[   94.477946] test_bpf: #367 BPF_ATOMIC | BPF_W, BPF_AND | BPF_FETCH: Test=
 side effects, r0: 0x12 & 0xab =3D 0x02 jited:1 23 PASS
[   94.494847] test_bpf: #368 BPF_ATOMIC | BPF_W, BPF_AND | BPF_FETCH: Test=
 fetch: 0x12 & 0xab =3D 0x02 jited:1 21 PASS
[   94.509298] test_bpf: #369 BPF_ATOMIC | BPF_DW, BPF_AND: Test: 0x12 & 0x=
ab =3D 0x02 jited:1 23 PASS
[   94.522281] test_bpf: #370 BPF_ATOMIC | BPF_DW, BPF_AND: Test side effec=
ts, r10: 0x12 & 0xab =3D 0x02 jited:1 22 PASS
[   94.536799] test_bpf: #371 BPF_ATOMIC | BPF_DW, BPF_AND: Test side effec=
ts, r0: 0x12 & 0xab =3D 0x02 jited:1 22 PASS
[   94.551257] test_bpf: #372 BPF_ATOMIC | BPF_DW, BPF_AND: Test fetch: 0x1=
2 & 0xab =3D 0x02 jited:1 20 PASS
[   94.564554] test_bpf: #373 BPF_ATOMIC | BPF_DW, BPF_AND | BPF_FETCH: Tes=
t: 0x12 & 0xab =3D 0x02 jited:1 22 PASS
[   94.578363] test_bpf: #374 BPF_ATOMIC | BPF_DW, BPF_AND | BPF_FETCH: Tes=
t side effects, r10: 0x12 & 0xab =3D 0x02 jited:1 27 PASS
[   94.595434] test_bpf: #375 BPF_ATOMIC | BPF_DW, BPF_AND | BPF_FETCH: Tes=
t side effects, r0: 0x12 & 0xab =3D 0x02 jited:1 22 PASS
[   94.612610] test_bpf: #376 BPF_ATOMIC | BPF_DW, BPF_AND | BPF_FETCH: Tes=
t fetch: 0x12 & 0xab =3D 0x02 jited:1 21 PASS
[   94.627221] test_bpf: #377 BPF_ATOMIC | BPF_W, BPF_OR: Test: 0x12 | 0xab=
 =3D 0xbb jited:1 24 PASS
[   94.640838] test_bpf: #378 BPF_ATOMIC | BPF_W, BPF_OR: Test side effects=
, r10: 0x12 | 0xab =3D 0xbb jited:1 21 PASS
[   94.655841] test_bpf: #379 BPF_ATOMIC | BPF_W, BPF_OR: Test side effects=
, r0: 0x12 | 0xab =3D 0xbb jited:1 21 PASS
[   94.670798] test_bpf: #380 BPF_ATOMIC | BPF_W, BPF_OR: Test fetch: 0x12 =
| 0xab =3D 0xbb jited:1 21 PASS
[   94.685330] test_bpf: #381 BPF_ATOMIC | BPF_W, BPF_OR | BPF_FETCH: Test:=
 0x12 | 0xab =3D 0xbb jited:1 22 PASS
[   94.700068] test_bpf: #382 BPF_ATOMIC | BPF_W, BPF_OR | BPF_FETCH: Test =
side effects, r10: 0x12 | 0xab =3D 0xbb jited:1 22 PASS
[   94.718032] test_bpf: #383 BPF_ATOMIC | BPF_W, BPF_OR | BPF_FETCH: Test =
side effects, r0: 0x12 | 0xab =3D 0xbb jited:1 23 PASS
[   94.735656] test_bpf: #384 BPF_ATOMIC | BPF_W, BPF_OR | BPF_FETCH: Test =
fetch: 0x12 | 0xab =3D 0xbb jited:1 21 PASS
[   94.749823] test_bpf: #385 BPF_ATOMIC | BPF_DW, BPF_OR: Test: 0x12 | 0xa=
b =3D 0xbb jited:1 23 PASS
[   94.762757] test_bpf: #386 BPF_ATOMIC | BPF_DW, BPF_OR: Test side effect=
s, r10: 0x12 | 0xab =3D 0xbb jited:1 22 PASS
[   94.777143] test_bpf: #387 BPF_ATOMIC | BPF_DW, BPF_OR: Test side effect=
s, r0: 0x12 | 0xab =3D 0xbb jited:1 21 PASS
[   94.791189] test_bpf: #388 BPF_ATOMIC | BPF_DW, BPF_OR: Test fetch: 0x12=
 | 0xab =3D 0xbb jited:1 20 PASS
[   94.804054] test_bpf: #389 BPF_ATOMIC | BPF_DW, BPF_OR | BPF_FETCH: Test=
: 0x12 | 0xab =3D 0xbb jited:1 23 PASS
[   94.817974] test_bpf: #390 BPF_ATOMIC | BPF_DW, BPF_OR | BPF_FETCH: Test=
 side effects, r10: 0x12 | 0xab =3D 0xbb jited:1 30 PASS
[   94.834375] test_bpf: #391 BPF_ATOMIC | BPF_DW, BPF_OR | BPF_FETCH: Test=
 side effects, r0: 0x12 | 0xab =3D 0xbb jited:1 23 PASS
[   94.852048] test_bpf: #392 BPF_ATOMIC | BPF_DW, BPF_OR | BPF_FETCH: Test=
 fetch: 0x12 | 0xab =3D 0xbb jited:1 22 PASS
[   94.866099] test_bpf: #393 BPF_ATOMIC | BPF_W, BPF_XOR: Test: 0x12 ^ 0xa=
b =3D 0xb9 jited:1 24 PASS
[   94.878817] test_bpf: #394 BPF_ATOMIC | BPF_W, BPF_XOR: Test side effect=
s, r10: 0x12 ^ 0xab =3D 0xb9 jited:1 22 PASS
[   94.893029] test_bpf: #395 BPF_ATOMIC | BPF_W, BPF_XOR: Test side effect=
s, r0: 0x12 ^ 0xab =3D 0xb9 jited:1 21 PASS
[   94.907152] test_bpf: #396 BPF_ATOMIC | BPF_W, BPF_XOR: Test fetch: 0x12=
 ^ 0xab =3D 0xb9 jited:1 21 PASS
[   94.920437] test_bpf: #397 BPF_ATOMIC | BPF_W, BPF_XOR | BPF_FETCH: Test=
: 0x12 ^ 0xab =3D 0xb9 jited:1 23 PASS
[   94.933981] test_bpf: #398 BPF_ATOMIC | BPF_W, BPF_XOR | BPF_FETCH: Test=
 side effects, r10: 0x12 ^ 0xab =3D 0xb9 jited:1 21 PASS
[   94.951165] test_bpf: #399 BPF_ATOMIC | BPF_W, BPF_XOR | BPF_FETCH: Test=
 side effects, r0: 0x12 ^ 0xab =3D 0xb9 jited:1 23 PASS
[   94.968479] test_bpf: #400 BPF_ATOMIC | BPF_W, BPF_XOR | BPF_FETCH: Test=
 fetch: 0x12 ^ 0xab =3D 0xb9 jited:1 22 PASS
[   94.982538] test_bpf: #401 BPF_ATOMIC | BPF_DW, BPF_XOR: Test: 0x12 ^ 0x=
ab =3D 0xb9 jited:1 23 PASS
[   94.995320] test_bpf: #402 BPF_ATOMIC | BPF_DW, BPF_XOR: Test side effec=
ts, r10: 0x12 ^ 0xab =3D 0xb9 jited:1 49 PASS
[   95.009332] test_bpf: #403 BPF_ATOMIC | BPF_DW, BPF_XOR: Test side effec=
ts, r0: 0x12 ^ 0xab =3D 0xb9 jited:1 22 PASS
[   95.023577] test_bpf: #404 BPF_ATOMIC | BPF_DW, BPF_XOR: Test fetch: 0x1=
2 ^ 0xab =3D 0xb9 jited:1 21 PASS
[   95.036871] test_bpf: #405 BPF_ATOMIC | BPF_DW, BPF_XOR | BPF_FETCH: Tes=
t: 0x12 ^ 0xab =3D 0xb9 jited:1 22 PASS
[   95.050714] test_bpf: #406 BPF_ATOMIC | BPF_DW, BPF_XOR | BPF_FETCH: Tes=
t side effects, r10: 0x12 ^ 0xab =3D 0xb9 jited:1 27 PASS
[   95.068306] test_bpf: #407 BPF_ATOMIC | BPF_DW, BPF_XOR | BPF_FETCH: Tes=
t side effects, r0: 0x12 ^ 0xab =3D 0xb9 jited:1 23 PASS
[   95.085288] test_bpf: #408 BPF_ATOMIC | BPF_DW, BPF_XOR | BPF_FETCH: Tes=
t fetch: 0x12 ^ 0xab =3D 0xb9 jited:1 22 PASS
[   95.099630] test_bpf: #409 BPF_ATOMIC | BPF_W, BPF_XCHG: Test: 0x12 xchg=
 0xab =3D 0xab jited:1 23 PASS
[   95.112438] test_bpf: #410 BPF_ATOMIC | BPF_W, BPF_XCHG: Test side effec=
ts, r10: 0x12 xchg 0xab =3D 0xab jited:1 23 PASS
[   95.128807] test_bpf: #411 BPF_ATOMIC | BPF_W, BPF_XCHG: Test side effec=
ts, r0: 0x12 xchg 0xab =3D 0xab jited:1 21 PASS
[   95.143316] test_bpf: #412 BPF_ATOMIC | BPF_W, BPF_XCHG: Test fetch: 0x1=
2 xchg 0xab =3D 0xab jited:1 20 PASS
[   95.157079] test_bpf: #413 BPF_ATOMIC | BPF_DW, BPF_XCHG: Test: 0x12 xch=
g 0xab =3D 0xab jited:1 23 PASS
[   95.169933] test_bpf: #414 BPF_ATOMIC | BPF_DW, BPF_XCHG: Test side effe=
cts, r10: 0x12 xchg 0xab =3D 0xab jited:1 22 PASS
[   95.186465] test_bpf: #415 BPF_ATOMIC | BPF_DW, BPF_XCHG: Test side effe=
cts, r0: 0x12 xchg 0xab =3D 0xab jited:1 22 PASS
[   95.203138] test_bpf: #416 BPF_ATOMIC | BPF_DW, BPF_XCHG: Test fetch: 0x=
12 xchg 0xab =3D 0xab jited:1 21 PASS
[   95.217192] test_bpf: #417 BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test success=
ful return jited:1 20 PASS
[   95.229995] test_bpf: #418 BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test success=
ful store jited:1 22 PASS
[   95.242635] test_bpf: #419 BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test failure=
 return jited:1 20 PASS
[   95.255259] test_bpf: #420 BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test failure=
 store jited:1 23 PASS
[   95.267982] test_bpf: #421 BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test side ef=
fects jited:1 30 PASS
[   95.280189] test_bpf: #422 BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test succes=
sful return jited:1 23 PASS
[   95.293032] test_bpf: #423 BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test succes=
sful store jited:1 22 PASS
[   95.305834] test_bpf: #424 BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test failur=
e return jited:1 21 PASS
[   95.318413] test_bpf: #425 BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test failur=
e store jited:1 23 PASS
[   95.330932] test_bpf: #426 BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test side e=
ffects jited:1 21 PASS
[   95.343710] test_bpf: #427 JMP32_JEQ_K: Small immediate jited:1 9 PASS
[   95.353858] test_bpf: #428 JMP32_JEQ_K: Large immediate jited:1 10 PASS
[   95.364163] test_bpf: #429 JMP32_JEQ_K: negative immediate jited:1 10 PA=
SS
[   95.374656] test_bpf: #430 JMP32_JEQ_X jited:1 10 PASS
[   95.382938] test_bpf: #431 JMP32_JNE_K: Small immediate jited:1 9 PASS
[   95.393503] test_bpf: #432 JMP32_JNE_K: Large immediate jited:1 10 PASS
[   95.403565] test_bpf: #433 JMP32_JNE_K: negative immediate jited:1 10 PA=
SS
[   95.413989] test_bpf: #434 JMP32_JNE_X jited:1 10 PASS
[   95.422677] test_bpf: #435 JMP32_JSET_K: Small immediate jited:1 10 PASS
[   95.432881] test_bpf: #436 JMP32_JSET_K: Large immediate jited:1 10 PASS
[   95.443091] test_bpf: #437 JMP32_JSET_K: negative immediate jited:1 10 P=
ASS
[   95.453883] test_bpf: #438 JMP32_JSET_X jited:1 10 PASS
[   95.462608] test_bpf: #439 JMP32_JGT_K: Small immediate jited:1 9 PASS
[   95.473026] test_bpf: #440 JMP32_JGT_K: Large immediate jited:1 9 PASS
[   95.483246] test_bpf: #441 JMP32_JGT_X jited:1 139 PASS
[   95.504909] test_bpf: #442 JMP32_JGE_K: Small immediate=20
[   95.505037] LKP: stdout: 472:  /lkp/lkp/src/bin/run-lkp /lkp/jobs/schedu=
led/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-20220510.cgz-5f4287fc4655=
b77bfb9012a7a0ed630d65d01695-20230612-43529-13huwyx-5.yaml
[   95.505945] jited:1=20

[   95.509783] 10=20
[   95.515694] RESULT_ROOT=3D/result/kunit/group-01/lkp-bdw-de1/debian-11.1=
-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a=
0ed630d65d01695/2
[   95.518554] PASS

[   95.523686] test_bpf: #443 JMP32_JGE_K: Large immediate=20
[   95.529505] job=3D/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-=
11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-=
43529-13huwyx-5.yaml
[   95.545766] jited:1=20

[   95.606435] 25 PASS
[   95.611162] test_bpf: #444 JMP32_JGE_X jited:1 10 PASS
[   95.619288] test_bpf: #445 JMP32_JLT_K: Small immediate jited:1 10 PASS
[   95.629067] test_bpf: #446 JMP32_JLT_K: Large immediate jited:1 10 PASS
[   95.638913] test_bpf: #447 JMP32_JLT_X jited:1 10 PASS
[   95.647076] test_bpf: #448 JMP32_JLE_K: Small immediate jited:1 10 PASS
[   95.656761] test_bpf: #449 JMP32_JLE_K: Large immediate jited:1 9 PASS
[   95.666345] test_bpf: #450 JMP32_JLE_X jited:1 10 PASS
[   95.674882] test_bpf: #451 JMP32_JSGT_K: Small immediate jited:1 9 PASS
[   95.684833] test_bpf: #452 JMP32_JSGT_K: Large immediate jited:1 10 PASS
[   95.694739] test_bpf: #453 JMP32_JSGT_X jited:1 10 PASS
[   95.702681] test_bpf: #454 JMP32_JSGE_K: Small immediate jited:1 9 PASS
[   95.712265] test_bpf: #455 JMP32_JSGE_K: Large immediate jited:1 10 PASS
[   95.721820] test_bpf: #456 JMP32_JSGE_X jited:1 10 PASS
[   95.730001] test_bpf: #457 JMP32_JSLT_K: Small immediate jited:1 10 PASS
[   95.739967] test_bpf: #458 JMP32_JSLT_K: Large immediate jited:1 10 PASS
[   95.749800] test_bpf: #459 JMP32_JSLT_X jited:1 10 PASS
[   95.758126] test_bpf: #460 JMP32_JSLE_K: Small immediate jited:1 9 PASS
[   95.767492] test_bpf: #461 JMP32_JSLE_K: Large immediate jited:1 10 PASS
[   95.777128] test_bpf: #462 JMP32_JSLE_X jited:1 19 PASS
[   95.789620] test_bpf: #463 JMP_EXIT jited:1 9 PASS
[   95.797890] test_bpf: #464 JMP_JA: Unconditional jump: if (true) return =
1 jited:1 10 PASS
[   95.809172] test_bpf: #465 JMP_JSLT_K: Signed jump: if (-2 < -1) return =
1 jited:1 10 PASS
[   95.820608] test_bpf: #466 JMP_JSLT_K: Signed jump: if (-1 < -1) return =
0 jited:1 10 PASS
[   95.831410] test_bpf: #467 JMP_JSGT_K: Signed jump: if (-1 > -2) return =
1 jited:1 10 PASS
[   95.842192] test_bpf: #468 JMP_JSGT_K: Signed jump: if (-1 > -1) return =
0 jited:1 10 PASS
[   95.853283] test_bpf: #469 JMP_JSLE_K: Signed jump: if (-2 <=3D -1) retu=
rn 1 jited:1 10 PASS
[   95.864425] test_bpf: #470 JMP_JSLE_K: Signed jump: if (-1 <=3D -1) retu=
rn 1 jited:1 10 PASS
[   95.875785] test_bpf: #471 JMP_JSLE_K: Signed jump: value walk 1 jited:1=
 11 PASS
[   95.885874] test_bpf: #472 JMP_JSLE_K: Signed jump: value walk 2 jited:1=
 11 PASS
[   95.896470] test_bpf: #473 JMP_JSGE_K: Signed jump: if (-1 >=3D -2) retu=
rn 1 jited:1 21 PASS
[   95.908888] test_bpf: #474 JMP_JSGE_K: Signed jump: if (-1 >=3D -1) retu=
rn 1 jited:1 20 PASS
[   95.921844] test_bpf: #475 JMP_JSGE_K: Signed jump: value walk 1 jited:1=
 11 PASS
[   95.932183] test_bpf: #476 JMP_JSGE_K: Signed jump: value walk 2 jited:1=
 10 PASS
[   95.942430] test_bpf: #477 JMP_JGT_K: if (3 > 2) return 1 jited:1 10 PAS=
S
[   95.952090] test_bpf: #478 JMP_JGT_K: Unsigned jump: if (-1 > 1) return =
1 jited:1 11 PASS
[   95.963756] test_bpf: #479 JMP_JLT_K: if (2 < 3) return 1 jited:1 10 PAS=
S
[   95.973573] test_bpf: #480 JMP_JGT_K: Unsigned jump: if (1 < -1) return =
1 jited:1 10 PASS
[   95.985009] test_bpf: #481 JMP_JGE_K: if (3 >=3D 2) return 1 jited:1 10 =
PASS
[   95.995038] test_bpf: #482 JMP_JLE_K: if (2 <=3D 3) return 1 jited:1 10 =
PASS
[   96.004570] test_bpf: #483 JMP_JGT_K: if (3 > 2) return 1 (jump backward=
s) jited:1 10 PASS
[   96.015826] test_bpf: #484 JMP_JGE_K: if (3 >=3D 3) return 1 jited:1 10 =
PASS
[   96.025652] test_bpf: #485 JMP_JGT_K: if (2 < 3) return 1 (jump backward=
s) jited:1 10 PASS
[   96.036905] test_bpf: #486 JMP_JLE_K: if (3 <=3D 3) return 1 jited:1 10 =
PASS
[   96.046788] test_bpf: #487 JMP_JNE_K: if (3 !=3D 2) return 1 jited:1 10 =
PASS
[   96.056338] test_bpf: #488 JMP_JEQ_K: if (3 =3D=3D 3) return 1 jited:1 1=
0 PASS
[   96.066268] test_bpf: #489 JMP_JSET_K: if (0x3 & 0x2) return 1 jited:1 1=
0 PASS
[   96.076076] test_bpf: #490 JMP_JSET_K: if (0x3 & 0xffffffff) return 1 ji=
ted:1 10 PASS
[   96.087085] test_bpf: #491 JMP_JSGT_X: Signed jump: if (-1 > -2) return =
1 jited:1 10 PASS
[   96.097990] test_bpf: #492 JMP_JSGT_X: Signed jump: if (-1 > -1) return =
0 jited:1 10 PASS
[   96.108980] test_bpf: #493 JMP_JSLT_X: Signed jump: if (-2 < -1) return =
1 jited:1 10 PASS
[   96.120050] test_bpf: #494 JMP_JSLT_X: Signed jump: if (-1 < -1) return =
0 jited:1 10 PASS
[   96.131443] test_bpf: #495 JMP_JSGE_X: Signed jump: if (-1 >=3D -2) retu=
rn 1 jited:1 11 PASS
[   96.142698] test_bpf: #496 JMP_JSGE_X: Signed jump: if (-1 >=3D -1) retu=
rn 1 jited:1 10 PASS
[   96.153841] test_bpf: #497 JMP_JSLE_X: Signed jump: if (-2 <=3D -1) retu=
rn 1 jited:1 10 PASS
[   96.165264] test_bpf: #498 JMP_JSLE_X: Signed jump: if (-1 <=3D -1) retu=
rn 1 jited:1 10 PASS
[   96.176116] test_bpf: #499 JMP_JGT_X: if (3 > 2) return 1 jited:1 10 PAS=
S
[   96.185333] test_bpf: #500 JMP_JGT_X: Unsigned jump: if (-1 > 1) return =
1 jited:1 10 PASS
[   96.196331] test_bpf: #501 JMP_JLT_X: if (2 < 3) return 1 jited:1 10 PAS=
S
[   96.205798] test_bpf: #502 JMP_JLT_X: Unsigned jump: if (1 < -1) return =
1 jited:1 10 PASS
[   96.216907] test_bpf: #503 JMP_JGE_X: if (3 >=3D 2) return 1 jited:1 10 =
PASS
[   96.226699] test_bpf: #504 JMP_JGE_X: if (3 >=3D 3) return 1 jited:1 10 =
PASS
[   96.236163] test_bpf: #505 JMP_JLE_X: if (2 <=3D 3) return 1 jited:1 11 =
PASS
[   96.245685] test_bpf: #506 JMP_JLE_X: if (3 <=3D 3) return 1 jited:1 10 =
PASS
[   96.255234] test_bpf: #507 JMP_JGE_X: ldimm64 test 1 jited:1 10 PASS
[   96.264157] test_bpf: #508 JMP_JGE_X: ldimm64 test 2 jited:1 10 PASS
[   96.273603] test_bpf: #509 JMP_JGE_X: ldimm64 test 3 jited:1 10 PASS
[   96.282860] test_bpf: #510 JMP_JLE_X: ldimm64 test 1 jited:1 10 PASS
[   96.291806] test_bpf: #511 JMP_JLE_X: ldimm64 test 2 jited:1 10 PASS
[   96.300581] test_bpf: #512 JMP_JLE_X: ldimm64 test 3 jited:1 10 PASS
[   96.309857] test_bpf: #513 JMP_JNE_X: if (3 !=3D 2) return 1 jited:1 10 =
PASS
[   96.319527] test_bpf: #514 JMP_JEQ_X: if (3 =3D=3D 3) return 1 jited:1 1=
1 PASS
[   96.329482] test_bpf: #515 JMP_JSET_X: if (0x3 & 0x2) return 1 jited:1 1=
0 PASS
[   96.339624] test_bpf: #516 JMP_JSET_X: if (0x3 & 0xffffffff) return 1 ji=
ted:1 11 PASS
[   96.350357] test_bpf: #517 JMP_JA: Jump, gap, jump, ... jited:1 10 PASS
[   96.360004] test_bpf: #518 BPF_MAXINSNS: Maximum possible literals jited=
:1 10 PASS
[   96.372291] test_bpf: #519 BPF_MAXINSNS: Single literal jited:1 10 PASS
[   96.383693] test_bpf: #520 BPF_MAXINSNS: Run/add until end jited:1 1682 =
PASS
[   96.396146] test_bpf: #521 BPF_MAXINSNS: Too many instructions PASS
[   96.404587] test_bpf: #522 BPF_MAXINSNS: Very long jump jited:1 10 PASS
[   96.416388] test_bpf: #523 BPF_MAXINSNS: Ctx heavy transformations jited=
:1 1838 1872 PASS
[   96.433347] test_bpf: #524 BPF_MAXINSNS: Call heavy transformations jite=
d:1 27424 26245 PASS
[   96.501005] test_bpf: #525 BPF_MAXINSNS: Jump heavy test jited:1 9886 PA=
SS
[   96.531433] test_bpf: #526 BPF_MAXINSNS: Very long jump backwards jited:=
1 141 PASS
[   96.545160] test_bpf: #527 BPF_MAXINSNS: Edge hopping nuthouse jited:1 1=
8883 PASS
[   96.576050] test_bpf: #528 BPF_MAXINSNS: Jump, gap, jump, ... jited:1 33=
 PASS
[   96.588161] test_bpf: #529 BPF_MAXINSNS: jump over MSH PASS
[   96.598026] test_bpf: #530 BPF_MAXINSNS: exec all MSH jited:1 8025 PASS
[   96.629160] test_bpf: #531 BPF_MAXINSNS: ld_abs+get_processor_id jited:1=
 11082 PASS
[   96.657660] test_bpf: #532 LD_IND byte frag jited:1 73 PASS
[   96.668167] test_bpf: #533 LD_IND halfword frag jited:1 45 PASS
[   96.677146] test_bpf: #534 LD_IND word frag jited:1 44 PASS
[   96.685643] test_bpf: #535 LD_IND halfword mixed head/frag jited:1 78 PA=
SS
[   96.695728] test_bpf: #536 LD_IND word mixed head/frag jited:1 77 PASS
[   96.704865] test_bpf: #537 LD_ABS byte frag jited:1 74 PASS
[   96.713216] test_bpf: #538 LD_ABS halfword frag jited:1 47 PASS
[   96.721970] test_bpf: #539 LD_ABS word frag jited:1 44 PASS
[   96.730553] test_bpf: #540 LD_ABS halfword mixed head/frag jited:1 50 PA=
SS
[   96.740364] test_bpf: #541 LD_ABS word mixed head/frag jited:1 49 PASS
[   96.750144] test_bpf: #542 LD_IND byte default X jited:1 54 PASS
[   96.759144] test_bpf: #543 LD_IND byte positive offset jited:1 18 PASS
[   96.768556] test_bpf: #544 LD_IND byte negative offset jited:1 17 PASS
[   96.778020] test_bpf: #545 LD_IND byte positive offset, all ff jited:1 1=
8 PASS
[   96.788567] test_bpf: #546 LD_IND byte positive offset, out of bounds ji=
ted:1 23 PASS
[   96.799280] test_bpf: #547 LD_IND byte negative offset, out of bounds ji=
ted:1 23 PASS
[   96.810347] test_bpf: #548 LD_IND byte negative offset, multiple calls j=
ited:1 72 PASS
[   96.821021] test_bpf: #549 LD_IND halfword positive offset jited:1 47 PA=
SS
[   96.831010] test_bpf: #550 LD_IND halfword negative offset jited:1 20 PA=
SS
[   96.840722] test_bpf: #551 LD_IND halfword unaligned jited:1 20 PASS
[   96.850007] test_bpf: #552 LD_IND halfword positive offset, all ff jited=
:1 21 PASS
[   96.860746] test_bpf: #553 LD_IND halfword positive offset, out of bound=
s jited:1 23 PASS
[   96.871917] test_bpf: #554 LD_IND halfword negative offset, out of bound=
s jited:1 24 PASS
[   96.883138] test_bpf: #555 LD_IND word positive offset jited:1 20 PASS
[   96.892550] test_bpf: #556 LD_IND word negative offset jited:1 20 PASS
[   96.902078] test_bpf: #557 LD_IND word unaligned (addr & 3 =3D=3D 2) jit=
ed:1 21 PASS
[   96.913111] test_bpf: #558 LD_IND word unaligned (addr & 3 =3D=3D 1) jit=
ed:1 20 PASS
[   96.923520] test_bpf: #559 LD_IND word unaligned (addr & 3 =3D=3D 3) jit=
ed:1 21 PASS
[   96.934108] test_bpf: #560 LD_IND word positive offset, all ff jited:1 2=
1 PASS
[   96.944121] test_bpf: #561 LD_IND word positive offset, out of bounds ji=
ted:1 23 PASS
[   96.956221] test_bpf: #562 LD_IND word negative offset, out of bounds ji=
ted:1 23 PASS
[   96.968159] test_bpf: #563 LD_ABS byte jited:1 12 PASS
[   96.976159] test_bpf: #564 LD_ABS byte positive offset, all ff jited:1 1=
1 PASS
[   96.986131] test_bpf: #565 LD_ABS byte positive offset, out of bounds ji=
ted:1 24 PASS
[   96.996914] test_bpf: #566 LD_ABS byte negative offset, out of bounds lo=
ad PASS
[   97.006842] test_bpf: #567 LD_ABS byte negative offset, in bounds jited:=
1 25 PASS
[   97.017358] test_bpf: #568 LD_ABS byte negative offset, out of bounds ji=
ted:1 24 PASS
[   97.028217] test_bpf: #569 LD_ABS byte negative offset, multiple calls j=
ited:1 71 PASS
[   97.039146] test_bpf: #570 LD_ABS halfword jited:1 12 PASS
[   97.047930] test_bpf: #571 LD_ABS halfword unaligned jited:1 12 PASS
[   97.057516] test_bpf: #572 LD_ABS halfword positive offset, all ff jited=
:1 12 PASS
[   97.068186] test_bpf: #573 LD_ABS halfword positive offset, out of bound=
s jited:1 24 PASS
[   97.079553] test_bpf: #574 LD_ABS halfword negative offset, out of bound=
s load PASS
[   97.090008] test_bpf: #575 LD_ABS halfword negative offset, in bounds ji=
ted:1 27 PASS
[   97.100934] test_bpf: #576 LD_ABS halfword negative offset, out of bound=
s jited:1 26 PASS
[   97.112076] test_bpf: #577 LD_ABS word jited:1 12 PASS
[   97.120496] test_bpf: #578 LD_ABS word unaligned (addr & 3 =3D=3D 2) jit=
ed:1 12 PASS
[   97.130952] test_bpf: #579 LD_ABS word unaligned (addr & 3 =3D=3D 1) jit=
ed:1 11 PASS
[   97.141113] test_bpf: #580 LD_ABS word unaligned (addr & 3 =3D=3D 3) jit=
ed:1 11 PASS
[   97.151471] test_bpf: #581 LD_ABS word positive offset, all ff jited:1 1=
2 PASS
[   97.161601] test_bpf: #582 LD_ABS word positive offset, out of bounds ji=
ted:1 23 PASS
[   97.172816] test_bpf: #583 LD_ABS word negative offset, out of bounds lo=
ad PASS
[   97.183055] test_bpf: #584 LD_ABS word negative offset, in bounds jited:=
1 27 PASS
[   97.193830] test_bpf: #585 LD_ABS word negative offset, out of bounds ji=
ted:1 24 PASS
[   97.204791] test_bpf: #586 LDX_MSH standalone, preserved A jited:1 12 PA=
SS
[   97.214822] test_bpf: #587 LDX_MSH standalone, preserved A 2 jited:1 16 =
PASS
[   97.224886] test_bpf: #588 LDX_MSH standalone, test result 1 jited:1 13 =
PASS
[   97.234708] test_bpf: #589 LDX_MSH standalone, test result 2 jited:1 13 =
PASS
[   97.244755] test_bpf: #590 LDX_MSH standalone, negative offset jited:1 2=
3 PASS
[   97.254964] test_bpf: #591 LDX_MSH standalone, negative offset 2 jited:1=
 26 PASS
[   97.265479] test_bpf: #592 LDX_MSH standalone, out of bounds jited:1 24 =
PASS
[   97.275666] test_bpf: #593 ADD default X jited:1 10 PASS
[   97.284169] test_bpf: #594 ADD default A jited:1 10 PASS
[   97.292243] test_bpf: #595 SUB default X jited:1 10 PASS
[   97.300339] test_bpf: #596 SUB default A jited:1 317 PASS
[   97.308852] test_bpf: #597 MUL default X jited:1 10 PASS
[   97.317166] test_bpf: #598 MUL default A jited:1 10 PASS
[   97.325147] test_bpf: #599 DIV default X jited:1 10 PASS
[   97.332954] test_bpf: #600 DIV default A jited:1 13 PASS
[   97.341098] test_bpf: #601 MOD default X jited:1 108 PASS
[   97.349609] test_bpf: #602 MOD default A jited:1 15 PASS
[   97.357686] test_bpf: #603 JMP EQ default A jited:1 10 PASS
[   97.366074] test_bpf: #604 JMP EQ default X jited:1 10 PASS
[   97.374125] test_bpf: #605 JNE signed compare, test 1 jited:1 10 PASS
[   97.383063] test_bpf: #606 JNE signed compare, test 2 jited:1 10 PASS
[   97.392142] test_bpf: #607 JNE signed compare, test 3 jited:1 10 PASS
[   97.401368] test_bpf: #608 JNE signed compare, test 4 jited:1 10 PASS
[   97.410831] test_bpf: #609 JNE signed compare, test 5 jited:1 9 PASS
[   97.419798] test_bpf: #610 JNE signed compare, test 6 jited:1 10 PASS
[   97.428892] test_bpf: #611 JNE signed compare, test 7 jited:1 10 PASS
[   97.438065] test_bpf: #612 LDX_MEM_B: operand register aliasing jited:1 =
9 PASS
[   97.447863] test_bpf: #613 LDX_MEM_H: operand register aliasing jited:1 =
10 PASS
[   97.457913] test_bpf: #614 LDX_MEM_W: operand register aliasing jited:1 =
10 PASS
[   97.467774] test_bpf: #615 LDX_MEM_DW: operand register aliasing jited:1=
 10 PASS
[   97.477897] test_bpf: #616 ALU64_IMM_AND to R8: no clobbering jited:1 13=
 PASS
[   97.487646] test_bpf: #617 ALU64_IMM_AND to R9: no clobbering jited:1 13=
 PASS
[   97.497431] test_bpf: #618 ALU64_IMM_OR to R8: no clobbering jited:1 13 =
PASS
[   97.507194] test_bpf: #619 ALU64_IMM_OR to R9: no clobbering jited:1 13 =
PASS
[   97.516925] test_bpf: #620 ALU64_IMM_XOR to R8: no clobbering jited:1 13=
 PASS
[   97.526333] test_bpf: #621 ALU64_IMM_XOR to R9: no clobbering jited:1 16=
 PASS
[   97.536122] test_bpf: #622 ALU64_IMM_LSH to R8: no clobbering jited:1 13=
 PASS
[   97.545585] test_bpf: #623 ALU64_IMM_LSH to R9: no clobbering jited:1 13=
 PASS
[   97.555344] test_bpf: #624 ALU64_IMM_RSH to R8: no clobbering jited:1 14=
 PASS
[   97.564964] test_bpf: #625 ALU64_IMM_RSH to R9: no clobbering jited:1 13=
 PASS
[   97.574755] test_bpf: #626 ALU64_IMM_ARSH to R8: no clobbering jited:1 1=
3 PASS
[   97.584428] test_bpf: #627 ALU64_IMM_ARSH to R9: no clobbering jited:1 1=
3 PASS
[   97.594389] test_bpf: #628 ALU64_IMM_ADD to R8: no clobbering jited:1 13=
 PASS
[   97.603837] test_bpf: #629 ALU64_IMM_ADD to R9: no clobbering jited:1 13=
 PASS
[   97.613582] test_bpf: #630 ALU64_IMM_SUB to R8: no clobbering jited:1 13=
 PASS
[   97.623179] test_bpf: #631 ALU64_IMM_SUB to R9: no clobbering jited:1 18=
 PASS
[   97.632786] test_bpf: #632 ALU64_IMM_MUL to R8: no clobbering jited:1 13=
 PASS
[   97.642252] test_bpf: #633 ALU64_IMM_MUL to R9: no clobbering jited:1 14=
 PASS
[   97.652029] test_bpf: #634 ALU64_IMM_DIV to R8: no clobbering jited:1 24=
 PASS
[   97.661416] test_bpf: #635 ALU64_IMM_DIV to R9: no clobbering jited:1 23=
 PASS
[   97.671061] test_bpf: #636 ALU64_IMM_MOD to R8: no clobbering jited:1 24=
 PASS
[   97.680483] test_bpf: #637 ALU64_IMM_MOD to R9: no clobbering jited:1 23=
 PASS
[   97.690528] test_bpf: #638 ALU32_IMM_AND to R8: no clobbering jited:1 13=
 PASS
[   97.700018] test_bpf: #639 ALU32_IMM_AND to R9: no clobbering jited:1 13=
 PASS
[   97.709511] test_bpf: #640 ALU32_IMM_OR to R8: no clobbering jited:1 13 =
PASS
[   97.719086] test_bpf: #641 ALU32_IMM_OR to R9: no clobbering jited:1 13 =
PASS
[   97.728467] test_bpf: #642 ALU32_IMM_XOR to R8: no clobbering jited:1 13=
 PASS
[   97.738228] test_bpf: #643 ALU32_IMM_XOR to R9: no clobbering jited:1 13=
 PASS
[   97.747586] test_bpf: #644 ALU32_IMM_LSH to R8: no clobbering jited:1 13=
 PASS
[   97.757203] test_bpf: #645 ALU32_IMM_LSH to R9: no clobbering jited:1 18=
9 PASS
[   97.766827] test_bpf: #646 ALU32_IMM_RSH to R8: no clobbering jited:1 13=
 PASS
[   97.776335] test_bpf: #647 ALU32_IMM_RSH to R9: no clobbering jited:1 13=
 PASS
[   97.785833] test_bpf: #648 ALU32_IMM_ARSH to R8: no clobbering jited:1 1=
3 PASS
[   97.795642] test_bpf: #649 ALU32_IMM_ARSH to R9: no clobbering jited:1 1=
3 PASS
[   97.805144] test_bpf: #650 ALU32_IMM_ADD to R8: no clobbering jited:1 13=
 PASS
[   97.814711] test_bpf: #651 ALU32_IMM_ADD to R9: no clobbering jited:1 13=
 PASS
[   97.824122] test_bpf: #652 ALU32_IMM_SUB to R8: no clobbering jited:1 13=
 PASS
[   97.833793] test_bpf: #653 ALU32_IMM_SUB to R9: no clobbering jited:1 14=
 PASS
[   97.843466] test_bpf: #654 ALU32_IMM_MUL to R8: no clobbering jited:1 13=
 PASS
[   97.853003] test_bpf: #655 ALU32_IMM_MUL to R9: no clobbering jited:1 13=
 PASS
[   97.862685] test_bpf: #656 ALU32_IMM_DIV to R8: no clobbering jited:1 21=
 PASS
[   97.871951] test_bpf: #657 ALU32_IMM_DIV to R9: no clobbering jited:1 19=
 PASS
[   97.881609] test_bpf: #658 ALU32_IMM_MOD to R8: no clobbering jited:1 17=
 PASS
[   97.891128] test_bpf: #659 ALU32_IMM_MOD to R9: no clobbering jited:1 17=
 PASS
[   97.900639] test_bpf: #660 ALU64_REG_AND to R8: no clobbering jited:1 13=
 PASS
[   97.910181] test_bpf: #661 ALU64_REG_AND to R9: no clobbering jited:1 13=
 PASS
[   97.919867] test_bpf: #662 ALU64_REG_OR to R8: no clobbering jited:1 13 =
PASS
[   97.929250] test_bpf: #663 ALU64_REG_OR to R9: no clobbering jited:1 13 =
PASS
[   97.938901] test_bpf: #664 ALU64_REG_XOR to R8: no clobbering jited:1 13=
 PASS
[   97.948601] test_bpf: #665 ALU64_REG_XOR to R9: no clobbering jited:1 13=
 PASS
[   97.958113] test_bpf: #666 ALU64_REG_LSH to R8: no clobbering jited:1 14=
 PASS
[   97.967874] test_bpf: #667 ALU64_REG_LSH to R9: no clobbering jited:1 13=
 PASS
[   97.977860] test_bpf: #668 ALU64_REG_RSH to R8: no clobbering jited:1 14=
 PASS
[   97.987216] test_bpf: #669 ALU64_REG_RSH to R9: no clobbering jited:1 44=
 PASS
[   97.996740] test_bpf: #670 ALU64_REG_ARSH to R8: no clobbering jited:1 1=
3 PASS
[   98.006187] test_bpf: #671 ALU64_REG_ARSH to R9: no clobbering jited:1 1=
4 PASS
[   98.015965] test_bpf: #672 ALU64_REG_ADD to R8: no clobbering jited:1 13=
 PASS
[   98.025353] test_bpf: #673 ALU64_REG_ADD to R9: no clobbering jited:1 14=
 PASS
[   98.034759] test_bpf: #674 ALU64_REG_SUB to R8: no clobbering jited:1 13=
 PASS
[   98.044115] test_bpf: #675 ALU64_REG_SUB to R9: no clobbering jited:1 13=
 PASS
[   98.053386] test_bpf: #676 ALU64_REG_MUL to R8: no clobbering jited:1 14=
 PASS
[   98.063035] test_bpf: #677 ALU64_REG_MUL to R9: no clobbering jited:1 14=
 PASS
[   98.072540] test_bpf: #678 ALU64_REG_DIV to R8: no clobbering jited:1 23=
 PASS
[   98.081952] test_bpf: #679 ALU64_REG_DIV to R9: no clobbering jited:1 24=
 PASS
[   98.091546] test_bpf: #680 ALU64_REG_MOD to R8: no clobbering jited:1 24=
 PASS
[   98.101196] test_bpf: #681 ALU64_REG_MOD to R9: no clobbering jited:1 23=
 PASS
[   98.111163] test_bpf: #682 ALU32_REG_AND to R8: no clobbering jited:1 13=
 PASS
[   98.120911] test_bpf: #683 ALU32_REG_AND to R9: no clobbering jited:1 13=
 PASS
[   98.130268] test_bpf: #684 ALU32_REG_OR to R8: no clobbering jited:1 14 =
PASS
[   98.140011] test_bpf: #685 ALU32_REG_OR to R9: no clobbering jited:1 13 =
PASS
[   98.149398] test_bpf: #686 ALU32_REG_XOR to R8: no clobbering jited:1 13=
 PASS
[   98.158732] test_bpf: #687 ALU32_REG_XOR to R9: no clobbering jited:1 13=
 PASS
[   98.168272] test_bpf: #688 ALU32_REG_LSH to R8: no clobbering jited:1 13=
 PASS
[   98.177917] test_bpf: #689 ALU32_REG_LSH to R9: no clobbering jited:1 13=
 PASS
[   98.187619] test_bpf: #690 ALU32_REG_RSH to R8: no clobbering jited:1 13=
 PASS
[   98.196760] test_bpf: #691 ALU32_REG_RSH to R9: no clobbering jited:1 13=
 PASS
[   98.206618] test_bpf: #692 ALU32_REG_ARSH to R8: no clobbering jited:1 1=
4 PASS
[   98.215951] test_bpf: #693 ALU32_REG_ARSH to R9: no clobbering jited:1 1=
3 PASS
[   98.225860] test_bpf: #694 ALU32_REG_ADD to R8: no clobbering jited:1 13=
 PASS
[   98.235597] test_bpf: #695 ALU32_REG_ADD to R9: no clobbering jited:1 13=
 PASS
[   98.245032] test_bpf: #696 ALU32_REG_SUB to R8: no clobbering jited:1 13=
 PASS
[   98.254485] test_bpf: #697 ALU32_REG_SUB to R9: no clobbering jited:1 13=
 PASS
[   98.264177] test_bpf: #698 ALU32_REG_MUL to R8: no clobbering jited:1 13=
 PASS
[   98.273412] test_bpf: #699 ALU32_REG_MUL to R9: no clobbering jited:1 13=
 PASS
[   98.283180] test_bpf: #700 ALU32_REG_DIV to R8: no clobbering jited:1 17=
 PASS
[   98.292439] test_bpf: #701 ALU32_REG_DIV to R9: no clobbering jited:1 17=
 PASS
[   98.302170] test_bpf: #702 ALU32_REG_MOD to R8: no clobbering jited:1 17=
 PASS
[   98.311395] test_bpf: #703 ALU32_REG_MOD to R9: no clobbering jited:1 21=
 PASS
[   98.321120] test_bpf: #704 Atomic_BPF_DW BPF_ADD: no clobbering jited:1 =
22 PASS
[   98.330917] test_bpf: #705 Atomic_BPF_DW BPF_AND: no clobbering jited:1 =
22 PASS
[   98.340809] test_bpf: #706 Atomic_BPF_DW BPF_OR: no clobbering jited:1 2=
2 PASS
[   98.350152] test_bpf: #707 Atomic_BPF_DW BPF_XOR: no clobbering jited:1 =
23 PASS
[   98.359996] test_bpf: #708 Atomic_BPF_DW BPF_ADD | BPF_FETCH: no clobber=
ing jited:1 22 PASS
[   98.370974] test_bpf: #709 Atomic_BPF_DW BPF_AND | BPF_FETCH: no clobber=
ing jited:1 23 PASS
[   98.381669] test_bpf: #710 Atomic_BPF_DW BPF_OR | BPF_FETCH: no clobberi=
ng jited:1 22 PASS
[   98.392593] test_bpf: #711 Atomic_BPF_DW BPF_XOR | BPF_FETCH: no clobber=
ing jited:1 22 PASS
[   98.403524] test_bpf: #712 Atomic_BPF_DW BPF_XCHG: no clobbering jited:1=
 22 PASS
[   98.413187] test_bpf: #713 Atomic_BPF_DW BPF_CMPXCHG: no clobbering jite=
d:1 22 PASS
[   98.423242] test_bpf: #714 Atomic_BPF_W BPF_ADD: no clobbering jited:1 2=
2 PASS
[   98.432973] test_bpf: #715 Atomic_BPF_W BPF_AND: no clobbering jited:1 2=
2 PASS
[   98.442757] test_bpf: #716 Atomic_BPF_W BPF_OR: no clobbering jited:1 22=
 PASS
[   98.452795] test_bpf: #717 Atomic_BPF_W BPF_XOR: no clobbering jited:1 2=
2 PASS
[   98.462665] test_bpf: #718 Atomic_BPF_W BPF_ADD | BPF_FETCH: no clobberi=
ng jited:1 22 PASS
[   98.473599] test_bpf: #719 Atomic_BPF_W BPF_AND | BPF_FETCH: no clobberi=
ng jited:1 22 PASS
[   98.484063] test_bpf: #720 Atomic_BPF_W BPF_OR | BPF_FETCH: no clobberin=
g jited:1 22 PASS
[   98.494778] test_bpf: #721 Atomic_BPF_W BPF_XOR | BPF_FETCH: no clobberi=
ng jited:1 22 PASS
[   98.505626] test_bpf: #722 Atomic_BPF_W BPF_XCHG: no clobbering jited:1 =
22 PASS
[   98.515564] test_bpf: #723 Atomic_BPF_W BPF_CMPXCHG: no clobbering jited=
:1 22 PASS
[   98.526050] test_bpf: #724 ALU32_MOV_X: src preserved in zext jited:1 10=
 PASS
[   98.535999] test_bpf: #725 ALU32_AND_X: src preserved in zext jited:1 10=
 PASS
[   98.546030] test_bpf: #726 ALU32_OR_X: src preserved in zext jited:1 10 =
PASS
[   98.555390] test_bpf: #727 ALU32_XOR_X: src preserved in zext jited:1 11=
 PASS
[   98.565128] test_bpf: #728 ALU32_ADD_X: src preserved in zext jited:1 10=
 PASS
[   98.574742] test_bpf: #729 ALU32_SUB_X: src preserved in zext jited:1 11=
 PASS
[   98.584658] test_bpf: #730 ALU32_MUL_X: src preserved in zext jited:1 11=
 PASS
[   98.594125] test_bpf: #731 ALU32_DIV_X: src preserved in zext jited:1 15=
 PASS
[   98.603866] test_bpf: #732 ALU32_MOD_X: src preserved in zext jited:1 15=
 PASS
[   98.613506] test_bpf: #733 ATOMIC_W_ADD: src preserved in zext jited:1 2=
2 PASS
[   98.623390] test_bpf: #734 ATOMIC_W_AND: src preserved in zext jited:1 2=
2 PASS
[   98.633028] test_bpf: #735 ATOMIC_W_OR: src preserved in zext jited:1 21=
0 PASS
[   98.643170] test_bpf: #736 ATOMIC_W_XOR: src preserved in zext jited:1 2=
2 PASS
[   98.652701] test_bpf: #737 ATOMIC_W_CMPXCHG: src preserved in zext jited=
:1 50 PASS
[   98.663165] test_bpf: #738 JMP32_JEQ_K: operand preserved in zext jited:=
1 10 PASS
[   98.673429] test_bpf: #739 JMP32_JNE_K: operand preserved in zext jited:=
1 197 PASS
[   98.684002] test_bpf: #740 JMP32_JSET_K: operand preserved in zext jited=
:1 10 PASS
[   98.694238] test_bpf: #741 JMP32_JGT_K: operand preserved in zext jited:=
1 11 PASS
[   98.704688] test_bpf: #742 JMP32_JGE_K: operand preserved in zext jited:=
1 39 PASS
[   98.714665] test_bpf: #743 JMP32_JLT_K: operand preserved in zext jited:=
1 10 PASS
[   98.725053] test_bpf: #744 JMP32_JLE_K: operand preserved in zext jited:=
1 10 PASS
[   98.735502] test_bpf: #745 JMP32_JSGT_K: operand preserved in zext jited=
:1 10 PASS
[   98.745644] test_bpf: #746 JMP32_JSGE_K: operand preserved in zext jited=
:1 10 PASS
[   98.756174] test_bpf: #747 JMP32_JSGT_K: operand preserved in zext jited=
:1 10 PASS
[   98.766177] test_bpf: #748 JMP32_JSLT_K: operand preserved in zext jited=
:1 10 PASS
[   98.776689] test_bpf: #749 JMP32_JSLE_K: operand preserved in zext jited=
:1 10 PASS
[   98.780904] result_service: raw_upload, RESULT_MNT: /internal-lkp-server=
/result, RESULT_ROOT: /internal-lkp-server/result/kunit/group-01/lkp-bdw-de=
1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655=
b77bfb9012a7a0ed630d65d01695/2, TMP_RESULT_ROOT: /tmp/lkp/result

[   98.786559] test_bpf: #750 JMP32_JEQ_X: operands preserved in zext jited=
:1=20
[   98.794415] run-job /lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debia=
n-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-2023061=
2-43529-13huwyx-5.yaml
[   98.816460] 12=20

[   98.819143] PASS
[   98.855175] test_bpf: #751 JMP32_JNE_X: operands preserved in zext jited=
:1 11 PASS
[   98.865229] test_bpf: #752 JMP32_JSET_X: operands preserved in zext jite=
d:1 11 PASS
[   98.876000] test_bpf: #753 JMP32_JGT_X: operands preserved in zext jited=
:1 11 PASS
[   98.886658] test_bpf: #754 JMP32_JGE_X: operands preserved in zext jited=
:1 11 PASS
[   98.897152] test_bpf: #755 JMP32_JLT_X: operands preserved in zext jited=
:1 11 PASS
[   98.907456] test_bpf: #756 JMP32_JLE_X: operands preserved in zext jited=
:1 11 PASS
[   98.917648] test_bpf: #757 JMP32_JSGT_X: operands preserved in zext jite=
d:1 11 PASS
[   98.928087] test_bpf: #758 JMP32_JSGE_X: operands preserved in zext jite=
d:1 11 PASS
[   98.938794] test_bpf: #759 JMP32_JSGT_X: operands preserved in zext jite=
d:1 11 PASS
[   98.949143] test_bpf: #760 JMP32_JSLT_X: operands preserved in zext jite=
d:1 11 PASS
[   98.959796] test_bpf: #761 JMP32_JSLE_X: operands preserved in zext jite=
d:1 12 PASS
[   98.970213] test_bpf: #762 ALU64_MOV_K: registers jited:1 22 PASS
[   98.979180] test_bpf: #763 ALU64_AND_K: registers jited:1 22 PASS
[   98.987969] test_bpf: #764 ALU64_OR_K: registers jited:1 24 PASS
[   98.996818] test_bpf: #765 ALU64_XOR_K: registers jited:1 23 PASS
[   99.006933] test_bpf: #766 ALU64_LSH_K: registers jited:1 24 PASS
[   99.015753] test_bpf: #767 ALU64_RSH_K: registers jited:1 23 PASS
[   99.024557] test_bpf: #768 ALU64_ARSH_K: registers jited:1 24 PASS
[   99.033573] test_bpf: #769 ALU64_ADD_K: registers jited:1 24 PASS
[   99.042891] test_bpf: #770 ALU64_SUB_K: registers jited:1 23 PASS
[   99.051777] test_bpf: #771 ALU64_MUL_K: registers jited:1 22 PASS
[   99.060670] test_bpf: #772 ALU64_DIV_K: registers jited:1 113 PASS
[   99.069938] test_bpf: #773 ALU64_MOD_K: registers jited:1 114 PASS
[   99.080199] test_bpf: #774 ALU32_MOV_K: registers jited:1 19 PASS
[   99.088954] test_bpf: #775 ALU32_AND_K: registers jited:1 19 PASS
[   99.097919] test_bpf: #776 ALU32_OR_K: registers jited:1 20 PASS
[   99.106796] test_bpf: #777 ALU32_XOR_K: registers jited:1 19 PASS
[   99.115813] test_bpf: #778 ALU32_LSH_K: registers jited:1 19 PASS
[   99.124826] test_bpf: #779 ALU32_RSH_K: registers jited:1 20 PASS
[   99.133672] test_bpf: #780 ALU32_ARSH_K: registers jited:1 19 PASS
[   99.143012] test_bpf: #781 ALU32_ADD_K: registers jited:1 20 PASS
[   99.152174] test_bpf: #782 ALU32_SUB_K: registers jited:1 21 PASS
[   99.160799] test_bpf: #783 ALU32_MUL_K: registers jited:1 21 PASS
[   99.169769] test_bpf: #784 ALU32_DIV_K: registers jited:1 58 PASS
[   99.178645] test_bpf: #785 ALU32_MOD_K: registers jited:1 61 PASS
[   99.187646] test_bpf: #786 ALU64_MOV_X: register combinations jited:1 22=
7 PASS
[   99.197984] test_bpf: #787 ALU64_AND_X: register combinations jited:1 22=
1 PASS
[   99.208692] test_bpf: #788 ALU64_OR_X: register combinations jited:1 209=
 PASS
[   99.219032] test_bpf: #789 ALU64_XOR_X: register combinations jited:1 24=
2 PASS
[   99.229167] test_bpf: #790 ALU64_LSH_X: register combinations jited:1 25=
8 PASS
[   99.239674] test_bpf: #791 ALU64_RSH_X: register combinations jited:1 20=
9 PASS
[   99.250186] test_bpf: #792 ALU64_ARSH_X: register combinations jited:1 3=
53 PASS
[   99.260422] test_bpf: #793 ALU64_ADD_X: register combinations jited:1 21=
1 PASS
[   99.270598] test_bpf: #794 ALU64_SUB_X: register combinations jited:1 21=
0 PASS
[   99.280893] test_bpf: #795 ALU64_MUL_X: register combinations jited:1 22=
2 PASS
[   99.291543] test_bpf: #796 ALU64_DIV_X: register combinations jited:1 11=
64 PASS
[   99.302702] test_bpf: #797 ALU64_MOD_X: register combinations jited:1 12=
75 PASS
[   99.313873] test_bpf: #798 ALU32_MOV_X: register combinations jited:1 22=
1 PASS
[   99.323921] test_bpf: #799 ALU32_AND_X: register combinations jited:1 20=
2 PASS
[   99.334251] test_bpf: #800 ALU32_OR_X: register combinations jited:1 207=
 PASS
[   99.344449] test_bpf: #801 ALU32_XOR_X: register combinations jited:1 20=
9 PASS
[   99.354553] test_bpf: #802 ALU32_LSH_X: register combinations jited:1 21=
8 PASS
[   99.364928] test_bpf: #803 ALU32_RSH_X: register combinations jited:1 22=
8 PASS
[   99.375506] test_bpf: #804 ALU32_ARSH_X: register combinations jited:1 2=
11 PASS
[   99.385880] test_bpf: #805 ALU32_ADD_X: register combinations jited:1 19=
4 PASS
[   99.397371] test_bpf: #806 ALU32_SUB_X: register combinations jited:1 23=
0 PASS
[   99.408008] test_bpf: #807 ALU32_MUL_X: register combinations jited:1 19=
6 PASS
[   99.418284] test_bpf: #808 ALU32_DIV_X: register combinations jited:1 55=
0 PASS
[   99.429118] test_bpf: #809 ALU32_MOD_X register combinations jited:1 575=
 PASS
[   99.439447] test_bpf: #810 ALU64_LSH_K: all shift values jited:1 295 PAS=
S
[   99.449242] test_bpf: #811 ALU64_RSH_K: all shift values jited:1 306 PAS=
S
[   99.459148] test_bpf: #812 ALU64_ARSH_K: all shift values jited:1 294 PA=
SS
[   99.469001] test_bpf: #813 ALU64_LSH_X: all shift values jited:1 329 PAS=
S
[   99.478929] test_bpf: #814 ALU64_RSH_X: all shift values jited:1 309 PAS=
S
[   99.488904] test_bpf: #815 ALU64_ARSH_X: all shift values jited:1 314 PA=
SS
[   99.498927] test_bpf: #816 ALU32_LSH_K: all shift values jited:1 140 PAS=
S
[   99.508552] test_bpf: #817 ALU32_RSH_K: all shift values jited:1 128 PAS=
S
[   99.518273] test_bpf: #818 ALU32_ARSH_K: all shift values jited:1 139 PA=
SS
[   99.527830] test_bpf: #819 ALU32_LSH_X: all shift values jited:1 243 PAS=
S
[   99.537629] test_bpf: #820 ALU32_RSH_X: all shift values jited:1 133 PAS=
S
[   99.548051] test_bpf: #821 ALU32_ARSH_X: all shift values jited:1 176 PA=
SS
[   99.557719] test_bpf: #822 ALU64_LSH_X: all shift values with the same r=
egister jited:1 52 PASS
[   99.569022] test_bpf: #823 ALU64_RSH_X: all shift values with the same r=
egister jited:1 49 PASS
[   99.580518] test_bpf: #824 ALU64_ARSH_X: all shift values with the same =
register jited:1 51 PASS
[   99.592142] test_bpf: #825 ALU32_LSH_X: all shift values with the same r=
egister jited:1 29 PASS
[   99.603481] test_bpf: #826 ALU32_RSH_X: all shift values with the same r=
egister jited:1 28 PASS
[   99.615068] test_bpf: #827 ALU32_ARSH_X: all shift values with the same =
register jited:1 28 PASS
[   99.626630] test_bpf: #828 ALU64_MOV_K: all immediate value magnitudes j=
ited:1 151195 PASS
[   99.651162] test_bpf: #829 ALU64_AND_K: all immediate value magnitudes j=
ited:1 156312 PASS
[   99.678063] test_bpf: #830 ALU64_OR_K: all immediate value magnitudes ji=
ted:1 107556 PASS
[   99.702164] test_bpf: #831 ALU64_XOR_K: all immediate value magnitudes j=
ited:1 143585 PASS
[   99.726174] test_bpf: #832 ALU64_ADD_K: all immediate value magnitudes j=
ited:1 116465 PASS
[   99.752156] test_bpf: #833 ALU64_SUB_K: all immediate value magnitudes j=
ited:1 133804 PASS
[   99.778755] test_bpf: #834 ALU64_MUL_K: all immediate value magnitudes j=
ited:1 108493 PASS
[   99.802158] test_bpf: #835 ALU64_DIV_K: all immediate value magnitudes j=
ited:1 254912 PASS
[   99.843990] test_bpf: #836 ALU64_MOD_K: all immediate value magnitudes j=
ited:1 320672 PASS
[   99.873625] test_bpf: #837 ALU32_MOV_K: all immediate value magnitudes j=
ited:1 111262 PASS
[   99.899130] test_bpf: #838 ALU32_AND_K: all immediate value magnitudes j=
ited:1 146453 PASS
[   99.923764] test_bpf: #839 ALU32_OR_K: all immediate value magnitudes ji=
ted:1 125675 PASS
[   99.947806] test_bpf: #840 ALU32_XOR_K: all immediate value magnitudes j=
ited:1 111842 PASS
[   99.971130] test_bpf: #841 ALU32_ADD_K: all immediate value magnitudes j=
ited:1 122310 PASS
[   99.995049] test_bpf: #842 ALU32_SUB_K: all immediate value magnitudes j=
ited:1 103165 PASS
[  100.019165] test_bpf: #843 ALU32_MUL_K: all immediate value magnitudes j=
ited:1 173053 PASS
[  100.042900] test_bpf: #844 ALU32_DIV_K: all immediate value magnitudes j=
ited:1 228300 PASS
[  100.072178] test_bpf: #845 ALU32_MOD_K: all immediate value magnitudes j=
ited:1 225293 PASS
[  100.116161] test_bpf: #846 ALU64_MOV_X: all register value magnitudes ji=
ted:1 174108 PASS
[  100.151146] test_bpf: #847 ALU64_AND_X: all register value magnitudes ji=
ted:1 205799 PASS
[  100.206017] test_bpf: #848 ALU64_OR_X: all register value magnitudes jit=
ed:1 177200 PASS
[  100.241147] test_bpf: #849 ALU64_XOR_X: all register value magnitudes ji=
ted:1 176682 PASS
[  100.276654] /usr/bin/wget -q --timeout=3D1800 --tries=3D1 --local-encodi=
ng=3DUTF-8 http://internal-lkp-server:80/~lkp/cgi-bin/lkp-jobfile-append-va=
r?job_file=3D/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86=
_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-43529-13=
huwyx-5.yaml&job_state=3Drunning -O /dev/null

[  100.277167] test_bpf: #850 ALU64_ADD_X: all register value magnitudes=20
[  100.280336] target ucode: 0x700001c
[  100.311697] jited:1=20

[  100.313260] 278357=20
[  100.315970] LKP: stdout: 596: current_version: 700001c, target_version: =
700001c
[  100.317296] PASS
[  100.318184] test_bpf: #851 ALU64_SUB_X: all register value magnitudes=20

[  100.345266] jited:1=20
[  100.351607] 	Internal Reference Designator: IPMI_LAN
[  100.353134] 288579=20

[  100.355138] PASS
[  100.357455] 	External Reference Designator: IPMI_LAN
[  100.364683] test_bpf: #852 ALU64_MUL_X: all register value magnitudes=20

[  100.391900] jited:1=20
[  100.394082] IPMI Device Information
[  100.400778] 213042=20

[  100.402947] PASS
[  100.406187] BMC ARP Control         : ARP Responses Enabled, Gratuitous =
ARP Disabled
[  100.408123] test_bpf: #853 ALU64_DIV_X: all register value magnitudes=20

[  100.439584] jited:1=20
[  100.443187] 2023-06-12 00:40:32 modprobe test_string
[  100.444795] 427157=20

[  100.446266] PASS
[  100.448418] 2023-06-12 00:40:33 rmmod test_string
[  100.452212] test_bpf: #854 ALU64_MOD_X: all register value magnitudes=20

[  100.483894] jited:1 463300 PASS
[  100.485292] 2023-06-12 00:40:33 modprobe test_div64
[  100.487167] test_bpf: #855 ALU32_MOV_X: all register value magnitudes=20

[  100.509577] 2023-06-12 00:40:33 rmmod test_div64

[  100.520753] 2023-06-12 00:40:33 modprobe test_bpf

[  100.520877] jited:1 206321 PASS
[  100.536132] test_bpf: #856 ALU32_AND_X: all register value magnitudes ji=
ted:1 194981 PASS
[  100.572162] test_bpf: #857 ALU32_OR_X: all register value magnitudes jit=
ed:1 174596 PASS
[  100.610243] test_bpf: #858 ALU32_XOR_X: all register value magnitudes ji=
ted:1 156427 PASS
[  100.660169] test_bpf: #859 ALU32_ADD_X: all register value magnitudes ji=
ted:1 220098 PASS
[  100.695157] test_bpf: #860 ALU32_SUB_X: all register value magnitudes ji=
ted:1 176326 PASS
[  100.729141] test_bpf: #861 ALU32_MUL_X: all register value magnitudes ji=
ted:1 165513 PASS
[  100.783166] test_bpf: #862 ALU32_DIV_X: all register value magnitudes ji=
ted:1 223783 PASS
[  100.816148] test_bpf: #863 ALU32_MOD_X: all register value magnitudes ji=
ted:1 223072 PASS
[  100.845146] test_bpf: #864 LD_IMM64: all immediate value magnitudes jite=
d:1 40156 PASS
[  100.922149] test_bpf: #865 LD_IMM64: checker byte patterns jited:1 363 P=
ASS
[  100.932737] test_bpf: #866 LD_IMM64: random positive and zero byte patte=
rns jited:1 300 PASS
[  100.944263] test_bpf: #867 LD_IMM64: random negative and zero byte patte=
rns jited:1 336 PASS
[  100.956159] test_bpf: #868 LD_IMM64: random positive and negative byte p=
atterns jited:1 415 PASS
[  100.968166] test_bpf: #869 ATOMIC_DW_ADD: register combinations jited:1 =
1544 PASS
[  100.980563] test_bpf: #870 ATOMIC_DW_AND: register combinations jited:1 =
1622 PASS
[  100.993158] test_bpf: #871 ATOMIC_DW_OR: register combinations jited:1 1=
556 PASS
[  101.005286] test_bpf: #872 ATOMIC_DW_XOR: register combinations jited:1 =
1672 PASS
[  101.017869] test_bpf: #873 ATOMIC_DW_ADD_FETCH: register combinations ji=
ted:1 1587 PASS
[  101.030945] test_bpf: #874 ATOMIC_DW_AND_FETCH: register combinations ji=
ted:1 1547 PASS
[  101.043818] test_bpf: #875 ATOMIC_DW_OR_FETCH: register combinations jit=
ed:1 1588 PASS
[  101.057255] test_bpf: #876 ATOMIC_DW_XOR_FETCH: register combinations ji=
ted:1 1587 PASS
[  101.070589] test_bpf: #877 ATOMIC_DW_XCHG: register combinations jited:1=
 1576 PASS
[  101.083171] test_bpf: #878 ATOMIC_DW_CMPXCHG: register combinations jite=
d:1 1577 PASS
[  101.096261] test_bpf: #879 ATOMIC_W_ADD: register combinations jited:1 1=
675 PASS
[  101.109559] test_bpf: #880 ATOMIC_W_AND: register combinations jited:1 1=
695 PASS
[  101.122166] test_bpf: #881 ATOMIC_W_OR: register combinations jited:1 15=
40 PASS
[  101.134721] test_bpf: #882 ATOMIC_W_XOR: register combinations jited:1 1=
680 PASS
[  101.147134] test_bpf: #883 ATOMIC_W_ADD_FETCH: register combinations jit=
ed:1 1577 PASS
[  101.160222] test_bpf: #884 ATOMIC_W_AND_FETCH: register combinations jit=
ed:1 1609 PASS
[  101.173146] test_bpf: #885 ATOMIC_W_OR_FETCH: register combinations jite=
d:1 1598 PASS
[  101.186063] test_bpf: #886 ATOMIC_W_XOR_FETCH: register combinations jit=
ed:1 1625 PASS
[  101.199101] test_bpf: #887 ATOMIC_W_XCHG: register combinations jited:1 =
1684 PASS
[  101.211622] test_bpf: #888 ATOMIC_W_CMPXCHG: register combinations jited=
:1 1636 PASS
[  101.224287] test_bpf: #889 ATOMIC_DW_ADD: all operand magnitudes jited:1=
 220503 PASS
[  101.254030] test_bpf: #890 ATOMIC_DW_AND: all operand magnitudes jited:1=
 179643 PASS
[  101.282141] test_bpf: #891 ATOMIC_DW_OR: all operand magnitudes jited:1 =
210046 PASS
[  101.326168] test_bpf: #892 ATOMIC_DW_XOR: all operand magnitudes jited:1=
 253977 PASS
[  101.354960] test_bpf: #893 ATOMIC_DW_ADD_FETCH: all operand magnitudes j=
ited:1 195387 PASS
[  101.384156] test_bpf: #894 ATOMIC_DW_AND_FETCH: all operand magnitudes j=
ited:1 233001 PASS
[  101.421163] test_bpf: #895 ATOMIC_DW_OR_FETCH: all operand magnitudes ji=
ted:1 231749 PASS
[  101.461140] test_bpf: #896 ATOMIC_DW_XOR_FETCH: all operand magnitudes j=
ited:1 258406 PASS
[  101.516167] test_bpf: #897 ATOMIC_DW_XCHG: all operand magnitudes jited:=
1 227912 PASS
[  101.544523] test_bpf: #898 ATOMIC_DW_CMPXCHG: all operand magnitudes jit=
ed:1 272557 PASS
[  101.581157] test_bpf: #899 ATOMIC_W_ADD: all operand magnitudes jited:1 =
225393 PASS
[  101.609865] test_bpf: #900 ATOMIC_W_AND: all operand magnitudes jited:1 =
210768 PASS
[  101.638156] test_bpf: #901 ATOMIC_W_OR: all operand magnitudes jited:1 1=
98391 PASS
[  101.667039] test_bpf: #902 ATOMIC_W_XOR: all operand magnitudes jited:1 =
241584 PASS
[  101.696150] test_bpf: #903 ATOMIC_W_ADD_FETCH: all operand magnitudes ji=
ted:1 184256 PASS
[  101.725880] test_bpf: #904 ATOMIC_W_AND_FETCH: all operand magnitudes ji=
ted:1 207653 PASS
[  101.758144] test_bpf: #905 ATOMIC_W_OR_FETCH: all operand magnitudes jit=
ed:1 225913 PASS
[  101.789671] test_bpf: #906 ATOMIC_W_XOR_FETCH: all operand magnitudes ji=
ted:1 254966 PASS
[  101.837147] test_bpf: #907 ATOMIC_W_XCHG: all operand magnitudes jited:1=
 178770 PASS
[  101.880158] test_bpf: #908 ATOMIC_W_CMPXCHG: all operand magnitudes jite=
d:1 324107 PASS
[  101.920170] test_bpf: #909 JMP_JSET_K: all immediate value magnitudes ji=
ted:1 115463 PASS
[  101.942154] test_bpf: #910 JMP_JEQ_K: all immediate value magnitudes jit=
ed:1 118340 PASS
[  101.967084] test_bpf: #911 JMP_JNE_K: all immediate value magnitudes jit=
ed:1 107456 PASS
[  101.989157] test_bpf: #912 JMP_JGT_K: all immediate value magnitudes jit=
ed:1 114163 PASS
[  102.012175] test_bpf: #913 JMP_JGE_K: all immediate value magnitudes jit=
ed:1 138320 PASS
[  102.034954] test_bpf: #914 JMP_JLT_K: all immediate value magnitudes jit=
ed:1 111536 PASS
[  102.058153] test_bpf: #915 JMP_JLE_K: all immediate value magnitudes jit=
ed:1 110976 PASS
[  102.081114] test_bpf: #916 JMP_JSGT_K: all immediate value magnitudes ji=
ted:1 113650 PASS
[  102.104871] test_bpf: #917 JMP_JSGE_K: all immediate value magnitudes ji=
ted:1 109447 PASS
[  102.128151] test_bpf: #918 JMP_JSLT_K: all immediate value magnitudes ji=
ted:1 111354 PASS
[  102.164730] test_bpf: #919 JMP_JSLE_K: all immediate value magnitudes ji=
ted:1 105216 PASS
[  102.197926] test_bpf: #920 JMP_JSET_X: all register value magnitudes jit=
ed:1 171182 PASS
[  102.231163] test_bpf: #921 JMP_JEQ_X: all register value magnitudes jite=
d:1 158271 PASS
[  102.265146] test_bpf: #922 JMP_JNE_X: all register value magnitudes jite=
d:1 167600 PASS
[  102.310122] test_bpf: #923 JMP_JGT_X: all register value magnitudes jite=
d:1 183840 PASS
[  102.357168] test_bpf: #924 JMP_JGE_X: all register value magnitudes jite=
d:1 168903 PASS
[  102.389161] test_bpf: #925 JMP_JLT_X: all register value magnitudes jite=
d:1 167837 PASS
[  102.421142] test_bpf: #926 JMP_JLE_X: all register value magnitudes jite=
d:1 173170 PASS
[  102.467165] test_bpf: #927 JMP_JSGT_X: all register value magnitudes jit=
ed:1 167775 PASS
[  102.500162] test_bpf: #928 JMP_JSGE_X: all register value magnitudes jit=
ed:1 168867 PASS
[  102.532142] test_bpf: #929 JMP_JSLT_X: all register value magnitudes jit=
ed:1 211269 PASS
[  102.577126] test_bpf: #930 JMP_JSLE_X: all register value magnitudes jit=
ed:1 167680 PASS
[  102.626163] test_bpf: #931 JMP32_JSET_K: all immediate value magnitudes =
jited:1 108778 PASS
[  102.647805] test_bpf: #932 JMP32_JEQ_K: all immediate value magnitudes j=
ited:1 95123 PASS
[  102.670174] test_bpf: #933 JMP32_JNE_K: all immediate value magnitudes j=
ited:1 108649 PASS
[  102.690162] test_bpf: #934 JMP32_JGT_K: all immediate value magnitudes j=
ited:1 113015 PASS
[  102.711160] test_bpf: #935 JMP32_JGE_K: all immediate value magnitudes j=
ited:1 112068 PASS
[  102.732140] test_bpf: #936 JMP32_JLT_K: all immediate value magnitudes j=
ited:1 114699 PASS
[  102.753183] test_bpf: #937 JMP32_JLE_K: all immediate value magnitudes j=
ited:1 123476 PASS
[  102.776440] test_bpf: #938 JMP32_JSGT_K: all immediate value magnitudes =
jited:1 119027 PASS
[  102.797161] test_bpf: #939 JMP32_JSGE_K: all immediate value magnitudes =
jited:1 110798 PASS
[  102.818671] test_bpf: #940 JMP32_JSLT_K: all immediate value magnitudes =
jited:1 142240 PASS
[  102.839580] test_bpf: #941 JMP32_JSLE_K: all immediate value magnitudes =
jited:1 103240 PASS
[  102.862166] test_bpf: #942 JMP32_JSET_X: all register value magnitudes j=
ited:1 152933 PASS
[  102.892154] test_bpf: #943 JMP32_JEQ_X: all register value magnitudes ji=
ted:1 150537 PASS
[  102.925168] test_bpf: #944 JMP32_JNE_X: all register value magnitudes ji=
ted:1 193592 PASS
[  102.952977] test_bpf: #945 JMP32_JGT_X: all register value magnitudes ji=
ted:1 182863 PASS
[  102.985149] test_bpf: #946 JMP32_JGE_X: all register value magnitudes ji=
ted:1 187697 PASS
[  103.013154] test_bpf: #947 JMP32_JLT_X: all register value magnitudes ji=
ted:1 206469 PASS
[  103.041138] test_bpf: #948 JMP32_JLE_X: all register value magnitudes ji=
ted:1 209959 PASS
[  103.084117] test_bpf: #949 JMP32_JSGT_X: all register value magnitudes j=
ited:1 168987 PASS
[  103.113322] test_bpf: #950 JMP32_JSGE_X: all register value magnitudes j=
ited:1 197672 PASS
[  103.142130] test_bpf: #951 JMP32_JSLT_X: all register value magnitudes j=
ited:1 178665 PASS
[  103.171164] test_bpf: #952 JMP32_JSLE_X: all register value magnitudes j=
ited:1 225996 PASS
[  103.199845] test_bpf: #953 JMP_JSET_K: imm =3D 0 -> never taken jited:1 =
10 PASS
[  103.209738] test_bpf: #954 JMP_JLT_K: imm =3D 0 -> never taken jited:1 9=
 PASS
[  103.219763] test_bpf: #955 JMP_JGE_K: imm =3D 0 -> always taken jited:1 =
9 PASS
[  103.229745] test_bpf: #956 JMP_JGT_K: imm =3D 0xffffffff -> never taken =
jited:1 9 PASS
[  103.240139] test_bpf: #957 JMP_JLE_K: imm =3D 0xffffffff -> always taken=
 jited:1 9 PASS
[  103.250376] test_bpf: #958 JMP32_JSGT_K: imm =3D 0x7fffffff -> never tak=
en jited:1 10 PASS
[  103.261143] test_bpf: #959 JMP32_JSGE_K: imm =3D -0x80000000 -> always t=
aken jited:1 9 PASS
[  103.271688] test_bpf: #960 JMP32_JSLT_K: imm =3D -0x80000000 -> never ta=
ken jited:1 10 PASS
[  103.282513] test_bpf: #961 JMP32_JSLE_K: imm =3D 0x7fffffff -> always ta=
ken jited:1 9 PASS
[  103.293404] test_bpf: #962 JMP_JEQ_X: dst =3D src -> always taken jited:=
1 9 PASS
[  103.303484] test_bpf: #963 JMP_JGE_X: dst =3D src -> always taken jited:=
1 10 PASS
[  103.314943] test_bpf: #964 JMP_JLE_X: dst =3D src -> always taken jited:=
1 9 PASS
[  103.325031] test_bpf: #965 JMP_JSGE_X: dst =3D src -> always taken jited=
:1 9 PASS
[  103.335157] test_bpf: #966 JMP_JSLE_X: dst =3D src -> always taken jited=
:1 9 PASS
[  103.344779] test_bpf: #967 JMP_JNE_X: dst =3D src -> never taken jited:1=
 9 PASS
[  103.354580] test_bpf: #968 JMP_JGT_X: dst =3D src -> never taken jited:1=
 9 PASS
[  103.364393] test_bpf: #969 JMP_JLT_X: dst =3D src -> never taken jited:1=
 10 PASS
[  103.374340] test_bpf: #970 JMP_JSGT_X: dst =3D src -> never taken jited:=
1 10 PASS
[  103.384182] test_bpf: #971 JMP_JSLT_X: dst =3D src -> never taken jited:=
1 9 PASS
[  103.393839] test_bpf: #972 Short relative jump: offset=3D0 jited:1 9 PAS=
S
[  103.403174] test_bpf: #973 Short relative jump: offset=3D1 jited:1 9 PAS=
S
[  103.412832] test_bpf: #974 Short relative jump: offset=3D2 jited:1 10 PA=
SS
[  103.422190] test_bpf: #975 Short relative jump: offset=3D3 jited:1 10 PA=
SS
[  103.431680] test_bpf: #976 Short relative jump: offset=3D4 jited:1 10 PA=
SS
[  103.440572] test_bpf: #977 Long conditional jump: taken at runtime jited=
:1 10 PASS
[  103.455182] test_bpf: #978 Long conditional jump: not taken at runtime j=
ited:1 11 PASS
[  103.470129] test_bpf: #979 Long conditional jump: always taken, known at=
 JIT time jited:1 10 PASS
[  103.485625] test_bpf: #980 Long conditional jump: never taken, known at =
JIT time jited:1 39 PASS
[  103.501142] test_bpf: #981 Staggered jumps: JMP_JA jited:1 78628 PASS
[  103.516913] test_bpf: #982 Staggered jumps: JMP_JEQ_K jited:1 144584 PAS=
S
[  103.534823] test_bpf: #983 Staggered jumps: JMP_JNE_K jited:1 159459 PAS=
S
[  103.552974] test_bpf: #984 Staggered jumps: JMP_JSET_K jited:1 147395 PA=
SS
[  103.570675] test_bpf: #985 Staggered jumps: JMP_JGT_K jited:1 153019 PAS=
S
[  103.588984] test_bpf: #986 Staggered jumps: JMP_JGE_K jited:1 164771 PAS=
S
[  103.607424] test_bpf: #987 Staggered jumps: JMP_JLT_K jited:1 174078 PAS=
S
[  103.626681] test_bpf: #988 Staggered jumps: JMP_JLE_K jited:1 200420 PAS=
S
[  103.645163] test_bpf: #989 Staggered jumps: JMP_JSGT_K jited:1 145258 PA=
SS
[  103.662921] test_bpf: #990 Staggered jumps: JMP_JSGE_K jited:1 155502 PA=
SS
[  103.681006] test_bpf: #991 Staggered jumps: JMP_JSLT_K jited:1 145335 PA=
SS
[  103.698923] test_bpf: #992 Staggered jumps: JMP_JSLE_K jited:1 154045 PA=
SS
[  103.716825] test_bpf: #993 Staggered jumps: JMP_JEQ_X jited:1 164874 PAS=
S
[  103.735037] test_bpf: #994 Staggered jumps: JMP_JNE_X jited:1 143901 PAS=
S
[  103.752861] test_bpf: #995 Staggered jumps: JMP_JSET_X jited:1 132971 PA=
SS
[  103.771001] test_bpf: #996 Staggered jumps: JMP_JGT_X jited:1 134480 PAS=
S
[  103.789029] test_bpf: #997 Staggered jumps: JMP_JGE_X jited:1 147633 PAS=
S
[  103.806988] test_bpf: #998 Staggered jumps: JMP_JLT_X jited:1 155760 PAS=
S
[  103.825134] test_bpf: #999 Staggered jumps: JMP_JLE_X jited:1 159013 PAS=
S
[  103.843054] test_bpf: #1000 Staggered jumps: JMP_JSGT_X jited:1 155490 P=
ASS
[  103.861399] test_bpf: #1001 Staggered jumps: JMP_JSGE_X jited:1 152428 P=
ASS
[  103.879283] test_bpf: #1002 Staggered jumps: JMP_JSLT_X jited:1 162794 P=
ASS
[  103.898165] test_bpf: #1003 Staggered jumps: JMP_JSLE_X jited:1 153116 P=
ASS
[  103.916965] test_bpf: #1004 Staggered jumps: JMP32_JEQ_K jited:1 181437 =
PASS
[  103.935657] test_bpf: #1005 Staggered jumps: JMP32_JNE_K jited:1 183577 =
PASS
[  103.954163] test_bpf: #1006 Staggered jumps: JMP32_JSET_K jited:1 178471=
 PASS
[  103.972738] test_bpf: #1007 Staggered jumps: JMP32_JGT_K jited:1 180126 =
PASS
[  103.991178] test_bpf: #1008 Staggered jumps: JMP32_JGE_K jited:1 173999 =
PASS
[  104.009960] test_bpf: #1009 Staggered jumps: JMP32_JLT_K jited:1 174743 =
PASS
[  104.028746] test_bpf: #1010 Staggered jumps: JMP32_JLE_K jited:1 166458 =
PASS
[  104.047342] test_bpf: #1011 Staggered jumps: JMP32_JSGT_K jited:1 141797=
 PASS
[  104.065164] test_bpf: #1012 Staggered jumps: JMP32_JSGE_K jited:1 148253=
 PASS
[  104.083622] test_bpf: #1013 Staggered jumps: JMP32_JSLT_K jited:1 155662=
 PASS
[  104.102157] test_bpf: #1014 Staggered jumps: JMP32_JSLE_K jited:1 147378=
 PASS
[  104.119761] test_bpf: #1015 Staggered jumps: JMP32_JEQ_X jited:1 140320 =
PASS
[  104.137965] test_bpf: #1016 Staggered jumps: JMP32_JNE_X jited:1 146305 =
PASS
[  104.156253] test_bpf: #1017 Staggered jumps: JMP32_JSET_X jited:1 146805=
 PASS
[  104.174276] test_bpf: #1018 Staggered jumps: JMP32_JGT_X jited:1 152923 =
PASS
[  104.192795] test_bpf: #1019 Staggered jumps: JMP32_JGE_X jited:1 156155 =
PASS
[  104.210859] test_bpf: #1020 Staggered jumps: JMP32_JLT_X jited:1 149505 =
PASS
[  104.228857] test_bpf: #1021 Staggered jumps: JMP32_JLE_X jited:1 156226 =
PASS
[  104.247073] test_bpf: #1022 Staggered jumps: JMP32_JSGT_X jited:1 148378=
 PASS
[  104.265171] test_bpf: #1023 Staggered jumps: JMP32_JSGE_X jited:1 147866=
 PASS
[  104.283162] test_bpf: #1024 Staggered jumps: JMP32_JSLT_X jited:1 152598=
 PASS
[  104.301882] test_bpf: #1025 Staggered jumps: JMP32_JSLE_X jited:1 172984=
 PASS
[  104.320309] test_bpf: Summary: 1026 PASSED, 0 FAILED, [1014/1014 JIT'ed]
[  104.335730] test_bpf: #0 Tail call leaf jited:1 9 PASS
[  104.335750] test_bpf: #1 Tail call 2 jited:1 15 PASS
[  104.342477] test_bpf: #2 Tail call 3 jited:1 24 PASS
[  104.348838] test_bpf: #3 Tail call 4 jited:1 34 PASS
[  104.355359] test_bpf: #4 Tail call load/store leaf jited:1 10 PASS
[  104.361745] test_bpf: #5 Tail call load/store jited:1 17 PASS
[  104.369334] test_bpf: #6 Tail call error path, max count reached jited:1=
 327 PASS
[  104.376849] test_bpf: #7 Tail call count preserved across function calls=
 jited:1 28316 PASS
[  104.414072] test_bpf: #8 Tail call error path, NULL target jited:1 11 PA=
SS
[  104.424155] test_bpf: #9 Tail call error path, index out of range jited:=
1 319 PASS
[  104.433441] test_bpf: test_tail_calls: Summary: 10 PASSED, 0 FAILED, [10=
/10 JIT'ed]
[  104.465168] test_bpf: #0 gso_with_rx_frags PASS
[  104.471560] test_bpf: #1 gso_linear_no_head_frag PASS
[  104.478588] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED
[  104.486359] initcall test_bpf_init+0x0/0xca0 [test_bpf] returned 0 after=
 14224916 usecs
[  104.539558] 2023-06-12 00:40:47 rmmod test_bpf

[  104.614510] 2023-06-12 00:40:48 modprobe test_min_heap

[  104.653837] calling  test_min_heap_init+0x0/0xac0 [test_min_heap] @ 807
[  104.662008] min_heap_test: test passed
[  104.667165] initcall test_min_heap_init+0x0/0xac0 [test_min_heap] return=
ed 0 after 5180 usecs
[  104.717549] 2023-06-12 00:40:48 rmmod test_min_heap

[  104.799629] 2023-06-12 00:40:48 modprobe test_user_copy

[  104.838325] calling  test_user_copy_init+0x0/0x1000 [test_user_copy] @ 8=
11
[  104.880461] test_user_copy: tests passed.
[  104.886104] initcall test_user_copy_init+0x0/0x1000 [test_user_copy] ret=
urned 0 after 39243 usecs
[  104.928888] 2023-06-12 00:40:48 rmmod test_user_copy

[  104.962311] test_user_copy: unloaded.
[  105.018404] 2023-06-12 00:40:48 modprobe test_static_key_base

[  105.057521] calling  test_static_key_base_init+0x0/0x1000 [test_static_k=
ey_base] @ 815
[  105.067222] initcall test_static_key_base_init+0x0/0x1000 [test_static_k=
ey_base] returned 0 after 19 usecs
[  105.116292] 2023-06-12 00:40:48 rmmod test_static_key_base

[  105.185566] 2023-06-12 00:40:48 modprobe test_scanf

[  105.231059] calling  test_scanf_init+0x0/0x750 [test_scanf] @ 819
[  105.238963] test_scanf: loaded.
[  105.244690] ------------[ cut here ]------------
[  105.253891] WARNING: CPU: 11 PID: 819 at lib/vsprintf.c:3701 vsscanf+0x1=
f16/0x2650
[  105.272240] Modules linked in: test_scanf(N+) intel_rapl_msr intel_rapl_=
common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm=
 irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 b=
trfs blake2b_generic xor raid6_pq libcrc32c crc32c_intel rapl sd_mod t10_pi=
 crc64_rocksoft_generic crc64_rocksoft crc64 sg ipmi_ssif intel_cstate ast =
drm_shmem_helper ahci drm_kms_helper libahci acpi_ipmi intel_uncore mei_me =
syscopyarea libata ipmi_si ioatdma joydev sysfillrect gpio_ich intel_pch_th=
ermal sysimgblt mei mxm_wmi ipmi_devintf dca ipmi_msghandler wmi acpi_pad d=
rm fuse ip_tables [last unloaded: test_static_key_base]
[  105.380736] CPU: 11 PID: 819 Comm: modprobe Tainted: G S               N=
 6.4.0-rc1-00002-g5f4287fc4655 #1
[  105.392450] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BI=
OS 1.1 03/02/2016
[  105.402710] RIP: 0010:vsscanf+0x1f16/0x2650
[  105.409007] Code: 4c 89 ef e8 4c ef eb fd 48 0f ba b4 24 a0 00 00 00 00 =
44 8b 4c 24 10 e9 7e ef ff ff 0f 0b e9 dd fc ff ff 0f 0b e9 d6 fc ff ff <0f=
> 0b e9 5b f8 ff ff 0f 0b e9 1b f9 ff ff 0f 0b e9 14 f9 ff ff 0f
[  105.431369] RSP: 0018:ffffc9000120f730 EFLAGS: 00010206
[  105.438770] RAX: 00000000ffffffff RBX: 00000000ffffffff RCX: 00000000000=
0000f
[  105.448085] RDX: 00000000ffffffff RSI: ffffc9000120f6c0 RDI: 00000000fff=
ffff0
[  105.457422] RBP: 1ffff92000241eee R08: ffff8881f4af5fff R09: 00000000fff=
fffff
[  105.466692] R10: 00000000000000ff R11: 0000000000000010 R12: dffffc00000=
00000
[  105.475991] R13: 0000000000000000 R14: ffffc9000120f8d0 R15: ffffffffc0a=
2ca42
[  105.485326] FS:  00007f4bfafd0540(0000) GS:ffff888ab9b80000(0000) knlGS:=
0000000000000000
[  105.495578] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  105.503457] CR2: 00005645746ea122 CR3: 000000016b904002 CR4: 00000000003=
706e0
[  105.512757] DR0: ffffffff8635204c DR1: ffffffff8635204d DR2: ffffffff863=
5204e
[  105.522075] DR3: ffffffff8635204f DR6: 00000000fffe0ff0 DR7: 00000000000=
00600
[  105.531423] Call Trace:
[  105.536017]  <TASK>
[  105.540310]  ? simple_strtol+0x70/0x70
[  105.546195]  ? _raw_spin_lock_irqsave+0x8b/0xe0
[  105.552848]  ? _raw_read_unlock_irqrestore+0x50/0x50
[  105.559938]  ? vsnprintf+0x760/0x1530
[  105.565718]  ? check_ushort+0x210/0x210 [test_scanf]
[  105.572801]  _test+0xf4/0x180 [test_scanf]
[  105.579005]  ? check_ull+0x1f0/0x1f0 [test_scanf]
[  105.585851]  ? kasan_save_stack+0x33/0x50
[  105.591946]  ? snprintf+0xab/0xe0
[  105.597318]  numbers_simple+0x1b3c/0x5180 [test_scanf]
[  105.604512]  ? _test+0x180/0x180 [test_scanf]
[  105.610909]  selftest+0xbf/0x270 [test_scanf]
[  105.617312]  ? selftest+0x270/0x270 [test_scanf]
[  105.623967]  test_scanf_init+0x22/0x750 [test_scanf]
[  105.630968]  do_one_initcall+0xa0/0x300
[  105.636828]  ? trace_event_raw_event_initcall_level+0x1a0/0x1a0
[  105.644758]  ? kasan_unpoison+0x44/0x70
[  105.650593]  do_init_module+0x22e/0x720
[  105.656423]  load_module+0x1826/0x25e0
[  105.662145]  ? post_relocation+0x370/0x370
[  105.668227]  ? __x64_sys_fspick+0x2a0/0x2a0
[  105.674383]  ? __do_sys_finit_module+0xfc/0x190
[  105.680880]  __do_sys_finit_module+0xfc/0x190
[  105.687189]  ? __ia32_sys_init_module+0xb0/0xb0
[  105.693654]  ? randomize_page+0x60/0x60
[  105.699366]  ? ksys_mmap_pgoff+0x118/0x480
[  105.705319]  ? __fdget_pos+0x70/0xc0
[  105.710712]  do_syscall_64+0x38/0x80
[  105.716060]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  105.722870] RIP: 0033:0x7f4bfb0f19b9
[  105.728156] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a7 54 0c 00 f7 d8 64 89 01 48
[  105.749694] RSP: 002b:00007fff0a556148 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[  105.759009] RAX: ffffffffffffffda RBX: 000055dcaddcfcb0 RCX: 00007f4bfb0=
f19b9
[  105.767858] RDX: 0000000000000000 RSI: 000055dcac456260 RDI: 00000000000=
00004
[  105.776689] RBP: 0000000000040000 R08: 0000000000000000 R09: 000055dcadd=
d1920
[  105.785514] R10: 0000000000000004 R11: 0000000000000246 R12: 000055dcac4=
56260
[  105.794334] R13: 0000000000000000 R14: 000055dcaddcfe50 R15: 000055dcadd=
cfcb0
[  105.803151]  </TASK>
[  105.807006] ---[ end trace 0000000000000000 ]---
[  105.813591] ------------[ cut here ]------------
[  105.819867] WARNING: CPU: 11 PID: 819 at lib/vsprintf.c:3672 vsscanf+0x1=
f1d/0x2650
[  105.829128] Modules linked in: test_scanf(N+) intel_rapl_msr intel_rapl_=
common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm=
 irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 b=
trfs blake2b_generic xor raid6_pq libcrc32c crc32c_intel rapl sd_mod t10_pi=
 crc64_rocksoft_generic crc64_rocksoft crc64 sg ipmi_ssif intel_cstate ast =
drm_shmem_helper ahci drm_kms_helper libahci acpi_ipmi intel_uncore mei_me =
syscopyarea libata ipmi_si ioatdma joydev sysfillrect gpio_ich intel_pch_th=
ermal sysimgblt mei mxm_wmi ipmi_devintf dca ipmi_msghandler wmi acpi_pad d=
rm fuse ip_tables [last unloaded: test_static_key_base]
[  105.893281] CPU: 11 PID: 819 Comm: modprobe Tainted: G S      W        N=
 6.4.0-rc1-00002-g5f4287fc4655 #1
[  105.904773] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BI=
OS 1.1 03/02/2016
[  105.914834] RIP: 0010:vsscanf+0x1f1d/0x2650
[  105.920918] Code: fd 48 0f ba b4 24 a0 00 00 00 00 44 8b 4c 24 10 e9 7e =
ef ff ff 0f 0b e9 dd fc ff ff 0f 0b e9 d6 fc ff ff 0f 0b e9 5b f8 ff ff <0f=
> 0b e9 1b f9 ff ff 0f 0b e9 14 f9 ff ff 0f 0b e9 46 f8 ff ff 0f
[  105.942906] RSP: 0018:ffffc9000120f730 EFLAGS: 00010206
[  105.950136] RAX: 000000000000ffff RBX: 000000000000ffff RCX: 00000000000=
0000f
[  105.959296] RDX: 000000000000ffff RSI: ffffc9000120f6c0 RDI: 00000000000=
0fff0
[  105.968429] RBP: 1ffff92000241eee R08: ffff8881f4af5fff R09: 00000000fff=
fffff
[  105.977538] R10: 0000000000000068 R11: 0000000000000010 R12: dffffc00000=
00000
[  105.986672] R13: 0000000000000000 R14: ffffc9000120f8d0 R15: ffffffffc0a=
2cb83
[  105.995798] FS:  00007f4bfafd0540(0000) GS:ffff888ab9b80000(0000) knlGS:=
0000000000000000
[  106.005920] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.013759] CR2: 00005645746ea122 CR3: 000000016b904002 CR4: 00000000003=
706e0
[  106.022953] DR0: ffffffff8635204c DR1: ffffffff8635204d DR2: ffffffff863=
5204e
[  106.032155] DR3: ffffffff8635204f DR6: 00000000fffe0ff0 DR7: 00000000000=
00600
[  106.041349] Call Trace:
[  106.045858]  <TASK>
[  106.050010]  ? simple_strtol+0x70/0x70
[  106.055825]  ? _raw_spin_lock_irqsave+0x8b/0xe0
[  106.062424]  ? _raw_read_unlock_irqrestore+0x50/0x50
[  106.069439]  ? vsnprintf+0x760/0x1530
[  106.075135]  ? check_uchar+0x210/0x210 [test_scanf]
[  106.082084]  _test+0xf4/0x180 [test_scanf]
[  106.088284]  ? check_ull+0x1f0/0x1f0 [test_scanf]
[  106.095057]  ? kasan_save_stack+0x33/0x50
[  106.101160]  ? snprintf+0xab/0xe0
[  106.106552]  numbers_simple+0x2889/0x5180 [test_scanf]
[  106.113763]  ? _test+0x180/0x180 [test_scanf]
[  106.120203]  selftest+0xbf/0x270 [test_scanf]
[  106.126603]  ? selftest+0x270/0x270 [test_scanf]
[  106.133207]  test_scanf_init+0x22/0x750 [test_scanf]
[  106.140166]  do_one_initcall+0xa0/0x300
[  106.145983]  ? trace_event_raw_event_initcall_level+0x1a0/0x1a0
[  106.153897]  ? kasan_unpoison+0x44/0x70
[  106.159722]  do_init_module+0x22e/0x720
[  106.165518]  load_module+0x1826/0x25e0
[  106.171229]  ? post_relocation+0x370/0x370
[  106.177294]  ? __x64_sys_fspick+0x2a0/0x2a0
[  106.183439]  ? __do_sys_finit_module+0xfc/0x190
[  106.189913]  __do_sys_finit_module+0xfc/0x190
[  106.196224]  ? __ia32_sys_init_module+0xb0/0xb0
[  106.202689]  ? randomize_page+0x60/0x60
[  106.208399]  ? ksys_mmap_pgoff+0x118/0x480
[  106.214343]  ? __fdget_pos+0x70/0xc0
[  106.219754]  do_syscall_64+0x38/0x80
[  106.225098]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  106.231902] RIP: 0033:0x7f4bfb0f19b9
[  106.237190] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a7 54 0c 00 f7 d8 64 89 01 48
[  106.258717] RSP: 002b:00007fff0a556148 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[  106.268025] RAX: ffffffffffffffda RBX: 000055dcaddcfcb0 RCX: 00007f4bfb0=
f19b9
[  106.276874] RDX: 0000000000000000 RSI: 000055dcac456260 RDI: 00000000000=
00004
[  106.285706] RBP: 0000000000040000 R08: 0000000000000000 R09: 000055dcadd=
d1920
[  106.294528] R10: 0000000000000004 R11: 0000000000000246 R12: 000055dcac4=
56260
[  106.303350] R13: 0000000000000000 R14: 000055dcaddcfe50 R15: 000055dcadd=
cfcb0
[  106.312166]  </TASK>
[  106.316021] ---[ end trace 0000000000000000 ]---
[  106.322500] ------------[ cut here ]------------
[  106.328776] WARNING: CPU: 11 PID: 819 at lib/vsprintf.c:3662 vsscanf+0x1=
f0f/0x2650
[  106.338034] Modules linked in: test_scanf(N+) intel_rapl_msr intel_rapl_=
common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm=
 irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 b=
trfs blake2b_generic xor raid6_pq libcrc32c crc32c_intel rapl sd_mod t10_pi=
 crc64_rocksoft_generic crc64_rocksoft crc64 sg ipmi_ssif intel_cstate ast =
drm_shmem_helper ahci drm_kms_helper libahci acpi_ipmi intel_uncore mei_me =
syscopyarea libata ipmi_si ioatdma joydev sysfillrect gpio_ich intel_pch_th=
ermal sysimgblt mei mxm_wmi ipmi_devintf dca ipmi_msghandler wmi acpi_pad d=
rm fuse ip_tables [last unloaded: test_static_key_base]
[  106.402227] CPU: 11 PID: 819 Comm: modprobe Tainted: G S      W        N=
 6.4.0-rc1-00002-g5f4287fc4655 #1
[  106.413718] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BI=
OS 1.1 03/02/2016
[  106.423781] RIP: 0010:vsscanf+0x1f0f/0x2650
[  106.429857] Code: 78 fe be 08 00 00 00 4c 89 ef e8 4c ef eb fd 48 0f ba =
b4 24 a0 00 00 00 00 44 8b 4c 24 10 e9 7e ef ff ff 0f 0b e9 dd fc ff ff <0f=
> 0b e9 d6 fc ff ff 0f 0b e9 5b f8 ff ff 0f 0b e9 1b f9 ff ff 0f
[  106.451828] RSP: 0018:ffffc9000120f730 EFLAGS: 00010202
[  106.459054] RAX: 00000000000000ff RBX: 00000000000000ff RCX: 00000000000=
0000f
[  106.468200] RDX: 00000000000000ff RSI: ffffc9000120f6c0 RDI: 00000000000=
000f0
[  106.477341] RBP: 1ffff92000241eee R08: ffff8881f4af5fff R09: 00000000fff=
fffff
[  106.486476] R10: 0000000000000048 R11: 0000000000000010 R12: dffffc00000=
00000
[  106.495592] R13: 0000000000000000 R14: ffffc9000120f8d0 R15: ffffffffc0a=
2ccc4
[  106.504719] FS:  00007f4bfafd0540(0000) GS:ffff888ab9b80000(0000) knlGS:=
0000000000000000
[  106.514824] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.522615] CR2: 00005645746ea122 CR3: 000000016b904002 CR4: 00000000003=
706e0
[  106.531794] DR0: ffffffff8635204c DR1: ffffffff8635204d DR2: ffffffff863=
5204e
[  106.540989] DR3: ffffffff8635204f DR6: 00000000fffe0ff0 DR7: 00000000000=
00600
[  106.550191] Call Trace:
[  106.554698]  <TASK>
[  106.558826]  ? simple_strtol+0x70/0x70
[  106.564643]  ? _raw_spin_lock_irqsave+0x8b/0xe0
[  106.571211]  ? _raw_read_unlock_irqrestore+0x50/0x50
[  106.578239]  ? vsnprintf+0x760/0x1530
[  106.583958]  ? 0xffffffffc10d3000
[  106.589331]  _test+0xf4/0x180 [test_scanf]
[  106.595487]  ? check_ull+0x1f0/0x1f0 [test_scanf]
[  106.602236]  ? kasan_save_stack+0x33/0x50
[  106.608329]  ? snprintf+0xab/0xe0
[  106.613722]  numbers_simple+0x3526/0x5180 [test_scanf]
[  106.620913]  ? _test+0x180/0x180 [test_scanf]
[  106.627346]  selftest+0xbf/0x270 [test_scanf]
[  106.633731]  ? selftest+0x270/0x270 [test_scanf]
[  106.640334]  test_scanf_init+0x22/0x750 [test_scanf]
[  106.647302]  do_one_initcall+0xa0/0x300
[  106.653128]  ? trace_event_raw_event_initcall_level+0x1a0/0x1a0
[  106.661034]  ? kasan_unpoison+0x44/0x70
[  106.666855]  do_init_module+0x22e/0x720
[  106.672671]  load_module+0x1826/0x25e0
[  106.678375]  ? post_relocation+0x370/0x370
[  106.684448]  ? __x64_sys_fspick+0x2a0/0x2a0
[  106.690574]  ? __do_sys_finit_module+0xfc/0x190
[  106.697048]  __do_sys_finit_module+0xfc/0x190
[  106.703359]  ? __ia32_sys_init_module+0xb0/0xb0
[  106.709805]  ? randomize_page+0x60/0x60
[  106.715508]  ? ksys_mmap_pgoff+0x118/0x480
[  106.721436]  ? __fdget_pos+0x70/0xc0
[  106.726802]  do_syscall_64+0x38/0x80
[  106.732139]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  106.738926] RIP: 0033:0x7f4bfb0f19b9
[  106.744202] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a7 54 0c 00 f7 d8 64 89 01 48
[  106.765722] RSP: 002b:00007fff0a556148 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[  106.775029] RAX: ffffffffffffffda RBX: 000055dcaddcfcb0 RCX: 00007f4bfb0=
f19b9
[  106.783868] RDX: 0000000000000000 RSI: 000055dcac456260 RDI: 00000000000=
00004
[  106.792695] RBP: 0000000000040000 R08: 0000000000000000 R09: 000055dcadd=
d1920
[  106.801514] R10: 0000000000000004 R11: 0000000000000246 R12: 000055dcac4=
56260
[  106.810329] R13: 0000000000000000 R14: 000055dcaddcfe50 R15: 000055dcadd=
cfcb0
[  106.819146]  </TASK>
[  106.822968] ---[ end trace 0000000000000000 ]---
[  106.833599] test_scanf: all 2545 tests passed
[  106.839622] initcall test_scanf_init+0x0/0x750 [test_scanf] returned 0 a=
fter 1600659 usecs
[  106.891256] 2023-06-12 00:40:50 rmmod test_scanf

[  106.926967] test_scanf: unloaded.
[  106.988140] 2023-06-12 00:40:50 modprobe test_bitmap

[  107.028081] calling  test_bitmap_init+0x0/0x450 [test_bitmap] @ 829
[  107.036117] test_bitmap: loaded.
[  107.041192] test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Ti=
me: 446
[  107.051198] test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
               ', Time: 2360
[  107.068731] test_bitmap: all 6550 tests passed
[  107.074923] initcall test_bitmap_init+0x0/0x450 [test_bitmap] returned 0=
 after 38805 usecs
[  107.115955] 2023-06-12 00:40:50 rmmod test_bitmap

[  107.146239] test_bitmap: unloaded.
[  107.195336] 2023-06-12 00:40:50 modprobe test_uuid

[  107.233705] calling  test_uuid_init+0x0/0x1000 [test_uuid] @ 833
[  107.241540] test_uuid: all 18 tests passed
[  107.247404] initcall test_uuid_init+0x0/0x1000 [test_uuid] returned 0 af=
ter 5867 usecs
[  107.291782] 2023-06-12 00:40:50 rmmod test_uuid

[  107.359964] 2023-06-12 00:40:50 modprobe test_xarray

[  107.420752] calling  xarray_checks+0x0/0xe0 [test_xarray] @ 837
[  115.413036] XArray: 30809610 of 30809610 tests passed
[  115.420073] initcall xarray_checks+0x0/0xe0 [test_xarray] returned 0 aft=
er 7991532 usecs
[  115.469545] 2023-06-12 00:40:58 rmmod test_xarray

[  115.522026] 2023-06-12 00:40:58 modprobe test_rhashtable

[  115.550315] calling  test_rht_init+0x0/0x1320 [test_rhashtable] @ 871
[  115.559466] Running rhashtable test nelem=3D8, max_size=3D0, shrinking=
=3D0
[  115.568140] Test 00:
[  115.572851]   Adding 50000 keys
[  115.598287]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.618976]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.629545]   Deleting 50000 keys
[  115.647240]   Duration of test: 69091517 ns
[  115.653371] Test 01:
[  115.657715]   Adding 50000 keys
[  115.682349]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.703172]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.713583]   Deleting 50000 keys
[  115.731294]   Duration of test: 68425812 ns
[  115.737628] Test 02:
[  115.741936]   Adding 50000 keys
[  115.769587]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.790244]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.800650]   Deleting 50000 keys
[  115.818072]   Duration of test: 70847318 ns
[  115.824248] Test 03:
[  115.828634]   Adding 50000 keys
[  115.853558]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.874155]   Traversal complete: counted=3D50000, nelems=3D50000, entri=
es=3D50000, table-jumps=3D0
[  115.884386]   Deleting 50000 keys
[  115.902062]   Duration of test: 68292332 ns
[  115.913040] test if its possible to exceed max_size 8192: no, ok
[  115.921379] Average test time: 69164244
[  115.927357] test inserting duplicates
[  115.933269]=20
               ---- ht: ----
               bucket[1] -> [[ val 21 (tid=3D1) ]] -> [[ val 1 (tid=3D0) ]]
               -------------
[  115.954087]=20
               ---- ht: ----
               bucket[1] -> [[ val 21 (tid=3D1) ]] -> [[ val 1 (tid=3D2),  =
val 1 (tid=3D0) ]]
               -------------
[  115.976634]=20
               ---- ht: ----
               bucket[1] -> [[ val 21 (tid=3D1) ]] -> [[ val 1 (tid=3D0) ]]
               -------------
[  115.997396]=20
               ---- ht: ----
               bucket[1] -> [[ val 21 (tid=3D1) ]] -> [[ val 1 (tid=3D2),  =
val 1 (tid=3D0) ]]
               -------------
[  116.019046] Testing concurrent rhashtable access from 10 threads
[  116.297388] test 3125 add/delete pairs into rhlist
[  116.334355] test 3125 random rhlist add/delete operations
[  116.371237] Started 10 threads, 0 failed, rhltable test returns 0
[  116.378989] initcall test_rht_init+0x0/0x1320 [test_rhashtable] returned=
 0 after 820204 usecs
[  116.409060] 2023-06-12 00:40:59 rmmod test_rhashtable

[  116.460971] 2023-06-12 00:40:59 modprobe test_memcat_p

[  116.483525] calling  test_memcat_p_init+0x0/0x1000 [test_memcat_p] @ 888
[  116.494065] test_memcat_p: test passed
[  116.501059] initcall test_memcat_p_init+0x0/0x1000 [test_memcat_p] retur=
ned 0 after 8935 usecs
[  116.531376] 2023-06-12 00:40:59 rmmod test_memcat_p

[  116.584320] 2023-06-12 00:41:00 modprobe test_udelay

[  116.606355] calling  udelay_test_init+0x0/0x1000 [test_udelay] @ 892
[  116.614609] initcall udelay_test_init+0x0/0x1000 [test_udelay] returned =
0 after 37 usecs
[  116.644981] 2023-06-12 00:41:00 rmmod test_udelay

[  116.693472] 2023-06-12 00:41:00 modprobe test_klp_livepatch

[  116.713742] test_klp_livepatch: tainting kernel with TAINT_LIVEPATCH
[  116.723688] calling  test_klp_livepatch_init+0x0/0x20 [test_klp_livepatc=
h] @ 896
[  116.734418] livepatch: enabling patch 'test_klp_livepatch'
[  116.745935] livepatch: 'test_klp_livepatch': starting patching transitio=
n
[  116.781382] initcall test_klp_livepatch_init+0x0/0x20 [test_klp_livepatc=
h] returned 0 after 48237 usecs
[  116.815624] 2023-06-12 00:41:00 rmmod test_klp_livepatch

[  116.855429] 2023-06-12 00:41:00 modprobe test_klp_shadow_vars

[  116.877472] calling  test_klp_shadow_vars_init+0x0/0x12c0 [test_klp_shad=
ow_vars] @ 903
[  116.887829] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR1, id=3D0x1234=
) =3D PTR0
[  116.897151] test_klp_shadow_vars:   got expected NULL result
[  116.905189] test_klp_shadow_vars: shadow_ctor: PTR3 -> PTR2
[  116.914358] test_klp_shadow_vars: klp_shadow_get_or_alloc(obj=3DPTR1, id=
=3D0x1234, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR2=
 =3D PTR3
[  116.930664] test_klp_shadow_vars: shadow_ctor: PTR6 -> PTR5
[  116.938490] test_klp_shadow_vars: klp_shadow_alloc(obj=3DPTR1, id=3D0x12=
35, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR5 =3D PT=
R6
[  116.954812] test_klp_shadow_vars: shadow_ctor: PTR8 -> PTR7
[  116.962769] test_klp_shadow_vars: klp_shadow_alloc(obj=3DPTR9, id=3D0x12=
34, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR7 =3D PT=
R8
[  116.978747] test_klp_shadow_vars: shadow_ctor: PTR11 -> PTR10
[  116.986628] test_klp_shadow_vars: klp_shadow_alloc(obj=3DPTR9, id=3D0x12=
35, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR10 =3D P=
TR11
[  117.003460] test_klp_shadow_vars: shadow_ctor: PTR13 -> PTR12
[  117.011523] test_klp_shadow_vars: klp_shadow_get_or_alloc(obj=3DPTR14, i=
d=3D0x1234, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR=
12 =3D PTR13
[  117.028718] test_klp_shadow_vars: shadow_ctor: PTR16 -> PTR15
[  117.036887] test_klp_shadow_vars: klp_shadow_alloc(obj=3DPTR14, id=3D0x1=
235, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR15 =3D =
PTR16
[  117.053340] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR1, id=3D0x1234=
) =3D PTR3
[  117.062656] test_klp_shadow_vars:   got expected PTR3 -> PTR2 result
[  117.071456] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR1, id=3D0x1235=
) =3D PTR6
[  117.080708] test_klp_shadow_vars:   got expected PTR6 -> PTR5 result
[  117.089545] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR9, id=3D0x1234=
) =3D PTR8
[  117.098802] test_klp_shadow_vars:   got expected PTR8 -> PTR7 result
[  117.107650] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR9, id=3D0x1235=
) =3D PTR11
[  117.117084] test_klp_shadow_vars:   got expected PTR11 -> PTR10 result
[  117.126049] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR14, id=3D0x123=
4) =3D PTR13
[  117.135646] test_klp_shadow_vars:   got expected PTR13 -> PTR12 result
[  117.144725] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR14, id=3D0x123=
5) =3D PTR16
[  117.154217] test_klp_shadow_vars:   got expected PTR16 -> PTR15 result
[  117.163177] test_klp_shadow_vars: klp_shadow_get_or_alloc(obj=3DPTR1, id=
=3D0x1234, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR2=
 =3D PTR3
[  117.179771] test_klp_shadow_vars:   got expected PTR3 -> PTR2 result
[  117.188543] test_klp_shadow_vars: klp_shadow_get_or_alloc(obj=3DPTR9, id=
=3D0x1234, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR7=
 =3D PTR8
[  117.205541] test_klp_shadow_vars:   got expected PTR8 -> PTR7 result
[  117.214459] test_klp_shadow_vars: klp_shadow_get_or_alloc(obj=3DPTR14, i=
d=3D0x1234, size=3D8, gfp_flags=3DGFP_KERNEL), ctor=3DPTR4, ctor_data=3DPTR=
12 =3D PTR13
[  117.231619] test_klp_shadow_vars:   got expected PTR13 -> PTR12 result
[  117.240744] test_klp_shadow_vars: shadow_dtor(obj=3DPTR1, shadow_data=3D=
PTR3)
[  117.250103] test_klp_shadow_vars: klp_shadow_free(obj=3DPTR1, id=3D0x123=
4, dtor=3DPTR17)
[  117.260134] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR1, id=3D0x1234=
) =3D PTR0
[  117.269835] test_klp_shadow_vars:   got expected NULL result
[  117.277888] test_klp_shadow_vars: shadow_dtor(obj=3DPTR9, shadow_data=3D=
PTR8)
[  117.287149] test_klp_shadow_vars: klp_shadow_free(obj=3DPTR9, id=3D0x123=
4, dtor=3DPTR17)
[  117.297122] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR9, id=3D0x1234=
) =3D PTR0
[  117.306714] test_klp_shadow_vars:   got expected NULL result
[  117.314767] test_klp_shadow_vars: shadow_dtor(obj=3DPTR14, shadow_data=
=3DPTR13)
[  117.324068] test_klp_shadow_vars: klp_shadow_free(obj=3DPTR14, id=3D0x12=
34, dtor=3DPTR17)
[  117.334098] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR14, id=3D0x123=
4) =3D PTR0
[  117.343533] test_klp_shadow_vars:   got expected NULL result
[  117.351602] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR1, id=3D0x1235=
) =3D PTR6
[  117.360902] test_klp_shadow_vars:   got expected PTR6 -> PTR5 result
[  117.369725] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR9, id=3D0x1235=
) =3D PTR11
[  117.379088] test_klp_shadow_vars:   got expected PTR11 -> PTR10 result
[  117.387976] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR14, id=3D0x123=
5) =3D PTR16
[  117.397429] test_klp_shadow_vars:   got expected PTR16 -> PTR15 result
[  117.406043] test_klp_shadow_vars: klp_shadow_free_all(id=3D0x1235, dtor=
=3DPTR0)
[  117.415054] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR1, id=3D0x1235=
) =3D PTR0
[  117.424127] test_klp_shadow_vars:   got expected NULL result
[  117.431783] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR9, id=3D0x1235=
) =3D PTR0
[  117.440819] test_klp_shadow_vars:   got expected NULL result
[  117.448706] test_klp_shadow_vars: klp_shadow_get(obj=3DPTR14, id=3D0x123=
5) =3D PTR0
[  117.457925] test_klp_shadow_vars:   got expected NULL result
[  117.465927] initcall test_klp_shadow_vars_init+0x0/0x12c0 [test_klp_shad=
ow_vars] returned 0 after 578119 usecs
[  117.497581] 2023-06-12 00:41:00 rmmod test_klp_shadow_vars

[  117.550347] 2023-06-12 00:41:01 modprobe test_hmm

[  117.573081] calling  hmm_dmirror_init+0x0/0x1000 [test_hmm] @ 907
[  117.601452] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x3fff=
f0000 0x400000000)
[  117.629021] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x3fff=
e0000 0x3ffff0000)
[  117.640503] HMM test module loaded. This is only for testing HMM.
[  117.648789] initcall hmm_dmirror_init+0x0/0x1000 [test_hmm] returned 0 a=
fter 67185 usecs
[  117.678741] 2023-06-12 00:41:01 rmmod test_hmm

[  117.788347] 2023-06-12 00:41:01 modprobe test_free_pages

[  117.810005] calling  m_in+0x0/0x40 [test_free_pages] @ 911
[  117.817579] test_free_pages: Testing with GFP_KERNEL
[  118.304233] livepatch: 'test_klp_livepatch': patching complete
[  119.413769] test_free_pages: Testing with GFP_KERNEL | __GFP_COMP
[  120.052021] rmmod: ERROR: Module test_klp_livepatch is in use

[  120.410807] test_free_pages: Test completed
[  120.416801] initcall m_in+0x0/0x40 [test_free_pages] returned 0 after 25=
99221 usecs
[  120.446976] 2023-06-12 00:41:03 rmmod test_free_pages

[  120.499146] 2023-06-12 00:41:03 modprobe test_fpu

[  120.520023] calling  test_fpu_init+0x0/0x1000 [test_fpu] @ 924
[  120.529266] initcall test_fpu_init+0x0/0x1000 [test_fpu] returned 0 afte=
r 1089 usecs
[  120.558947] 2023-06-12 00:41:04 rmmod test_fpu

[  120.614328] 2023-06-12 00:41:04 modprobe test_bitops

[  120.633904] calling  test_bitops_startup+0x0/0x1000 [test_bitops] @ 928
[  120.642912] test_bitops: Starting bitops test
[  120.649142] test_bitops: Completed bitops test
[  120.655743] initcall test_bitops_startup+0x0/0x1000 [test_bitops] return=
ed 0 after 12829 usecs
[  120.685690] 2023-06-12 00:41:04 rmmod test_bitops

[  120.735019] 2023-06-12 00:41:04 modprobe test_async_driver_probe

[  120.754648] calling  test_async_probe_init+0x0/0x1000 [test_async_driver=
_probe] @ 932
[  120.764931] test_async_driver_probe: registering first set of asynchrono=
us devices...
[  120.786060] test_async_driver_probe: registering asynchronous driver...
[  120.795597] test_async_driver_probe: registration took 0 msecs
[  120.803486] test_async_driver_probe: registering second set of asynchron=
ous devices...
[  120.820311] platform test_async_driver.31: registration took 6 msecs
[  120.829167] test_async_driver_probe: registering first synchronous devic=
e...
[  120.838776] test_async_driver_probe: registering synchronous driver...
[  126.253516] probe of test_async_driver.7 returned 0 after 5458339 usecs
[  126.253664] probe of test_async_driver.13 returned 0 after 5458334 usecs
[  126.253817] probe of test_async_driver.12 returned 0 after 5458495 usecs
[  126.253974] probe of test_sync_driver.0 returned 0 after 5406608 usecs
[  126.254130] probe of test_async_driver.23 returned 0 after 5437063 usecs
[  126.254278] probe of test_async_driver.4 returned 0 after 5459157 usecs
[  126.254434] probe of test_async_driver.1 returned 0 after 5459403 usecs
[  126.254579] probe of test_async_driver.2 returned 0 after 5459511 usecs
[  126.254724] probe of test_async_driver.16 returned 0 after 5440476 usecs
[  126.254861] probe of test_async_driver.28 returned 0 after 5436171 usecs
[  126.255007] probe of test_async_driver.30 returned 0 after 5435128 usecs
[  126.255154] probe of test_async_driver.31 returned 0 after 5434339 usecs
[  126.255299] probe of test_async_driver.17 returned 0 after 5440679 usecs
[  126.255451] probe of test_async_driver.29 returned 0 after 5436178 usecs
[  126.255604] probe of test_async_driver.15 returned 0 after 5460258 usecs
[  126.255761] probe of test_async_driver.3 returned 0 after 5460653 usecs
[  126.255921] test_async_driver_probe: registration took 5408 msecs
[  126.255924] test_async_driver_probe: registering second synchronous devi=
ce...
[  126.256075] probe of test_async_driver.21 returned 0 after 5439628 usecs
[  126.256238] probe of test_async_driver.14 returned 0 after 5460897 usecs
[  126.256399] probe of test_async_driver.26 returned 0 after 5438366 usecs
[  126.256556] probe of test_async_driver.11 returned 0 after 5461239 usecs
[  126.256713] probe of test_async_driver.24 returned 0 after 5439282 usecs
[  126.256862] probe of test_async_driver.5 returned 0 after 5461726 usecs
[  126.257021] probe of test_async_driver.22 returned 0 after 5440248 usecs
[  126.257183] probe of test_async_driver.10 returned 0 after 5461874 usecs
[  126.257500] probe of test_async_driver.20 returned 0 after 5441410 usecs
[  126.257657] probe of test_async_driver.0 returned 0 after 5462636 usecs
[  126.257856] probe of test_async_driver.18 returned 0 after 5442880 usecs
[  126.258012] probe of test_async_driver.8 returned 0 after 5462813 usecs
[  126.258270] probe of test_async_driver.9 returned 0 after 5462971 usecs
[  126.258459] probe of test_async_driver.25 returned 0 after 5440766 usecs
[  126.258631] probe of test_async_driver.19 returned 0 after 5443325 usecs
[  126.258804] probe of test_async_driver.27 returned 0 after 5440406 usecs
[  126.258935] probe of test_async_driver.6 returned 0 after 5463771 usecs
[  131.373473] probe of test_sync_driver.1 returned 0 after 5116110 usecs
[  131.383162] test_sync_driver test_sync_driver.1: registration took 5127 =
msecs
[  131.393176] test_async_driver_probe: completed successfully
[  131.400364] initcall test_async_probe_init+0x0/0x1000 [test_async_driver=
_probe] returned 0 after 10635432 usecs
[  131.452179] 2023-06-12 00:41:14 rmmod test_async_driver_probe

[  131.543209] 2023-06-12 00:41:14 modprobe spi-loopback-test

[  131.583134] calling  spi_loopback_test_driver_init+0x0/0x1000 [spi_loopb=
ack_test] @ 1012
[  131.593477] initcall spi_loopback_test_driver_init+0x0/0x1000 [spi_loopb=
ack_test] returned 0 after 578 usecs
[  131.642454] 2023-06-12 00:41:15 rmmod spi-loopback-test

[  131.709685] 2023-06-12 00:41:15 modprobe globtest

[  131.747378] calling  glob_init+0x0/0x1000 [globtest] @ 1016
[  131.754615] glob: 64 self-tests passed, 0 failed
[  131.760749] initcall glob_init+0x0/0x1000 [globtest] returned 0 after 61=
41 usecs
[  131.798351] 2023-06-12 00:41:15 rmmod globtest

[  131.872747] 2023-06-12 00:41:15 modprobe crc32test

[  131.912687] calling  crc32test_init+0x0/0x19a0 [crc32test] @ 1020
[  131.921187] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[  131.927930] crc32: self tests passed, processed 225944 bytes in 355947 n=
sec
[  131.936866] crc32c: CRC_LE_BITS =3D 64
[  131.942106] crc32c: self tests passed, processed 112972 bytes in 178058 =
nsec
[  131.972962] crc32_combine: 8373 self tests passed
[  132.002128] crc32c_combine: 8373 self tests passed
[  132.008693] initcall crc32test_init+0x0/0x19a0 [crc32test] returned 0 af=
ter 88232 usecs
[  132.049072] 2023-06-12 00:41:15 rmmod crc32test

[  132.119183] 2023-06-12 00:41:15 modprobe atomic64_test

[  132.157976] calling  test_atomics_init+0x0/0xe00 [atomic64_test] @ 1024
[  132.166511] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[  132.175223] initcall test_atomics_init+0x0/0xe00 [atomic64_test] returne=
d 0 after 8718 usecs
[  132.212336] 2023-06-12 00:41:15 rmmod atomic64_test

[  132.342546] 2023-06-12 00:41:15 modprobe snd-soc-avs-i2s-test

[  132.378857] calling  init_soundcore+0x0/0x1000 [soundcore] @ 1032
[  132.388353] initcall init_soundcore+0x0/0x1000 [soundcore] returned 0 af=
ter 1404 usecs
[  132.412316] calling  alsa_sound_init+0x0/0x90 [snd] @ 1032
[  132.420329] initcall alsa_sound_init+0x0/0x90 [snd] returned 0 after 342=
 usecs
[  132.440364] calling  alsa_timer_init+0x0/0x1000 [snd_timer] @ 1032
[  132.450038] initcall alsa_timer_init+0x0/0x1000 [snd_timer] returned 0 a=
fter 1329 usecs
[  132.478292] calling  alsa_pcm_init+0x0/0x1000 [snd_pcm] @ 1032
[  132.486441] initcall alsa_pcm_init+0x0/0x1000 [snd_pcm] returned 0 after=
 99 usecs
[  132.539538] calling  snd_soc_init+0x0/0xa0 [snd_soc_core] @ 1032
[  132.549440] probe of snd-soc-dummy returned 0 after 538 usecs
[  132.558059] initcall snd_soc_init+0x0/0xa0 [snd_soc_core] returned 0 aft=
er 10499 usecs
[  132.573869] calling  avs_i2s_test_driver_init+0x0/0x1000 [snd_soc_avs_i2=
s_test] @ 1032
[  132.584631] initcall avs_i2s_test_driver_init+0x0/0x1000 [snd_soc_avs_i2=
s_test] returned 0 after 649 usecs
[  132.623850] 2023-06-12 00:41:16 rmmod snd-soc-avs-i2s-test

[  132.702729] 2023-06-12 00:41:16 modprobe test_dynamic_debug

[  132.743960] calling  test_dynamic_debug_init+0x0/0x1000 [test_dynamic_de=
bug] @ 1042
[  132.753607] initcall test_dynamic_debug_init+0x0/0x1000 [test_dynamic_de=
bug] returned 0 after 0 usecs
[  132.795844] 2023-06-12 00:41:16 rmmod test_dynamic_debug


--WlSHMmdA2LHDp38i
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kunit.yaml
suite: kunit
testcase: kunit
category: functional
kunit:
  group: group-01
job_origin: kunit.yaml

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-bdw-de1
tbox_group: lkp-bdw-de1
submit_id: 64863b2da4336ba14b69d94a
job_file: "/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-41291-1bdctv8-0.yaml"
id: bb5323c7218cdf43c6d23fcc6c6754fca6bccc92
queuer_version: "/zday/lkp"

#! /db/releases/20230608210739/lkp-src/hosts/lkp-bdw-de1
model: Broadwell-DE
nr_node: 1
nr_cpu: 16
memory: 48G
nr_hdd_partitions: 1
nr_ssd_partitions: 1
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BA800G4_BTHV410402GY800OGN-part2"
hdd_partitions: "/dev/disk/by-id/ata-ST9500620NS_9XF26EB5-part1"
swap_partitions:
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2BA800G4_BTHV410402GY800OGN-part1"
brand: Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz

#! /db/releases/20230608210739/lkp-src/include/category/functional
kmsg:
heartbeat:
meminfo:
kmemleak:

#! /db/releases/20230608210739/lkp-src/include/queue/cyclic
commit: 5f4287fc4655b77bfb9012a7a0ed630d65d01695

#! /db/releases/20230608210739/lkp-src/include/testbox/lkp-bdw-de1
ucode: '0x700001c'
need_kconfig_hw:
- PTP_1588_CLOCK: y
- IGB: y
- NETDEVICES: y
- ETHERNET: y
- NET_VENDOR_INTEL: y
- PCI: y
- SATA_AHCI
- SATA_AHCI_PLATFORM
- ATA
- HAS_DMA: y

#! /db/releases/20230608210739/lkp-src/include/kunit
need_kconfig:
- STRING_SELFTEST: m
- TEST_DIV64: m
- TEST_BPF: m
- TEST_MIN_HEAP: m
- TEST_USER_COPY: m
- TEST_STATIC_KEYS: m
- TEST_SCANF: m
- TEST_PRINTF: m
- TEST_KSTRTOX: m
- TEST_STRING_HELPERS: m
- TEST_BITMAP: m
- TEST_UUID: m
- TEST_XARRAY: m
- TEST_OVERFLOW: m
- TEST_RHASHTABLE: m
- TEST_IDA: m
- TEST_MEMCAT_P: m
- TEST_UDELAY: m
- TEST_VMALLOC: m
- DYNAMIC_DEBUG: y
- DYNAMIC_FTRACE_WITH_REGS: y
- LIVEPATCH: y
- TEST_LIVEPATCH: m
- TEST_MEMINIT: m
- TRANSPARENT_HUGEPAGE: y
- MEMORY_HOTPLUG: y
- MEMORY_HOTREMOVE: y
- ZONE_DEVICE: y
- DEVICE_PRIVATE: y
- TEST_HMM: m
- TEST_FREE_PAGES: m
- KCOV_INSTRUMENT_ALL: n
- TEST_FPU: m
- TEST_BITOPS: m
- TEST_ASYNC_DRIVER_PROBE: m
- SPI: y
- SPI_MASTER: y
- SPI_LOOPBACK_TEST: m
- GLOB_SELFTEST: m
- CRC32: y
- CRC32_SELFTEST: m
- ATOMIC64_SELFTEST: m
- TEST_MAPLE_TREE: m
- SND: m
- SND_SOC: m
- SND_SOC_INTEL_AVS: m
- SND_SOC_INTEL_AVS_MACH_I2S_TEST: m
- KALLSYMS: y
- FUNCTION_TRACER: y
- DYNAMIC_FTRACE: y
- BUILDTIME_MCOUNT_SORT: y
- FTRACE_SORT_STARTUP_TEST: y
- PHYLIB: y
- INET: y
- NET_SELFTESTS: y
- ASYMMETRIC_KEY_TYPE: y
- ASYMMETRIC_PUBLIC_KEY_SUBTYPE
- X509_CERTIFICATE_PARSER
- PKCS7_MESSAGE_PARSER
- FIPS_SIGNATURE_SELFTEST: y
- PCI: y
- CXL_BUS
- SPARSEMEM: y
- CXL_REGION: y
- CXL_REGION_INVALIDATION_TEST: y
- DEBUG_KERNEL: y
- FAULT_INJECTION: y
- IOMMUFD
- IOMMUFD_TEST: y
- BLOCK: y
- BLK_DEV: y
- PHYS_ADDR_T_64BIT: y
- LIBNVDIMM
- KEYS: y
- ENCRYPTED_KEYS
- NVDIMM_KEYS: y
- NVDIMM_SECURITY_TEST: y
- PROC_FS: y
- DEBUG_FS: y
- PRINTK: y
- DYNAMIC_DEBUG: y
- TEST_DYNAMIC_DEBUG: m
kconfig: x86_64-rhel-8.3-kunit
enqueue_time: 2023-06-12 05:22:53.407514959 +08:00
_id: 64863b2da4336ba14b69d94a
_rt: "/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695"

#! schedule options
user: lkp
compiler: gcc-12
LKP_SERVER: internal-lkp-server
head_commit: 12449fc3eb711d743a99cac5ddc28fbb8a6a4771
base_commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
branch: linux-devel/devel-hourly-20230610-050149
rootfs: debian-11.1-x86_64-20220510.cgz
result_root: "/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/0"
scheduler_version: "/lkp/lkp/src"
arch: x86_64
max_uptime: 1200
initrd: "/osimage/debian/debian-11.1-x86_64-20220510.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/kunit/group-01/lkp-bdw-de1/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655
- branch=linux-devel/devel-hourly-20230610-050149
- job=/lkp/jobs/scheduled/lkp-bdw-de1/kunit-group-01-debian-11.1-x86_64-20220510.cgz-5f4287fc4655b77bfb9012a7a0ed630d65d01695-20230612-41291-1bdctv8-0.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-kunit
- commit=5f4287fc4655b77bfb9012a7a0ed630d65d01695
- initcall_debug
- nmi_watchdog=0
- max_uptime=1200
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
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/modules.cgz"
bm_initrd: "/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20230406.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /cephfs/db/releases/20230609191406/lkp-src/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
last_kernel: 6.4.0-rc5-08197-gf1a83bc74022

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-8.3-kunit/gcc-12/5f4287fc4655b77bfb9012a7a0ed630d65d01695/vmlinuz-6.4.0-rc1-00002-g5f4287fc4655"
dequeue_time: 2023-06-12 05:59:09.800290288 +08:00

#! /db/releases/20230611211930/lkp-src/include/site/inn
job_state: finished
loadavg: 4.07 1.69 0.63 1/281 1153
start_time: '1686520840'
end_time: '1686520884'
version: "/lkp/lkp/.src-20230611-212619:2b41ffff829d:a9e929fd6be9"

--WlSHMmdA2LHDp38i
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="reproduce"

modprobe test_string
rmmod test_string
modprobe test_div64
rmmod test_div64
modprobe test_bpf
rmmod test_bpf
modprobe test_min_heap
rmmod test_min_heap
modprobe test_user_copy
rmmod test_user_copy
modprobe test_static_key_base
rmmod test_static_key_base
modprobe test_scanf
rmmod test_scanf
modprobe test_bitmap
rmmod test_bitmap
modprobe test_uuid
rmmod test_uuid
modprobe test_xarray
rmmod test_xarray
modprobe test_rhashtable
rmmod test_rhashtable
modprobe test_memcat_p
rmmod test_memcat_p
modprobe test_udelay
rmmod test_udelay
modprobe test_klp_livepatch
rmmod test_klp_livepatch
modprobe test_klp_shadow_vars
rmmod test_klp_shadow_vars
modprobe test_hmm
rmmod test_hmm
modprobe test_free_pages
rmmod test_free_pages
modprobe test_fpu
rmmod test_fpu
modprobe test_bitops
rmmod test_bitops
modprobe test_async_driver_probe
rmmod test_async_driver_probe
modprobe spi-loopback-test
rmmod spi-loopback-test
modprobe globtest
rmmod globtest
modprobe crc32test
rmmod crc32test
modprobe atomic64_test
rmmod atomic64_test
modprobe snd-soc-avs-i2s-test
rmmod snd-soc-avs-i2s-test
modprobe test_dynamic_debug
rmmod test_dynamic_debug

--WlSHMmdA2LHDp38i--

