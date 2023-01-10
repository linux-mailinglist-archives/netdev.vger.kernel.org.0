Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BC4663F9D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbjAJMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 07:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjAJMAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:00:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DD18B09;
        Tue, 10 Jan 2023 04:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673352020; x=1704888020;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3YH1CPsNQI0X5/xKjWFBPpt8ARWLEOoAMiXHdXso+6w=;
  b=f3d/N1ShutdqRWnuYM9ezRnqDdrSTOY9caNen5zOU1j8HROIJG8LBLuL
   TkQcZ4RGWGbu8g7YOT6TbPL/qLgnZXnisGhHhlH41E3IT4TzBlGwlxfOR
   nUqm1a0RO4A1l/evHEiyFBlvgGvotHm5UFBXC4iQfEmP9J8FOCLh3Olf+
   nSkzfiNzfowQ81qvnghqw7YHSt+Uf3FYmmIs5WgQkLEImNrqjaJK5dqKG
   rC+BL/t7wCCuHKakdpgZvMTUiLSUZB5f5AmMNFbrG68Uv4+Gttxys9gnn
   8gsp2eaa4GMQ7PtiW/gmIPzJidWquRm7wlxHm/ZAlc9r8IJ1jrFmEv+qn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="303490962"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="303490962"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 04:00:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="657034521"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="657034521"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 10 Jan 2023 04:00:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 04:00:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 04:00:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 04:00:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQofqUuMq2xoXS9jUc8z4dBNxGROqMekKz/8pSOMnhC3jGPVbVOgW1kqOnUaTqRM9/GnbQk9X+hPGOZ2So1OYeOtXahH6HbfW+WouQlJtOrxroEOR8hw8lSFMdgvLbyoFKTzByQ6Z7Fv4kN6k/stwrMPi2OJ4ldRsu02ttv7PNSVsVAatiZSJpuZXBJLz21BQ8D45Ysu9c8fU97cLYHygDyBYtbsLAr6ur6yWshzqtSvcYiHoasE0EhfeDNHjYiwxd0NeD+HEZD5n+ZKNexZUEwDewhLcGBGvgBuNWBJUzH7zBAoOAMH3Dl5lKDKh0agJVoVXlRcnJkFHTps4jKGcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cC34TewJmKyhz48q4NHyCUvEFlD5S+KVyXCI3giaZuQ=;
 b=A+aNuemPE7mUt6V7nEL5PC+2vUq3Cd6s/2sKosLjbb//RSLP11HgZh2wGN+z+NjmPyVHrEvuTC315EO0+kvxQR9nwzATzAHGh4DK2m7j4wR0PFr+SlExT+CC5sj1/Zsu8NihakCUxB4RpRnE/lyh6RMnznJZHCjpHnR21VmOqNEGAyiRllIO3j0GZnIdVjBPopNVmMata5QXBFVPvpiP3LXN1F14peVz8X+9MlKt/iCkXteSwr6y9v+he7HcWgcVeXQSYVJGiaRxBpPHJ58wN6WHhQ7orLzkdoqNPDr0U5os++Qf3w1rY/zjAonfF5es0PQDsNud0c5TtU6oguj/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB7303.namprd11.prod.outlook.com (2603:10b6:8:108::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 12:00:17 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::fd3c:c9fc:5065:1a92]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::fd3c:c9fc:5065:1a92%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 12:00:11 +0000
Date:   Tue, 10 Jan 2023 13:00:04 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <tirthendu.sarkar@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 00/15] selftests/xsk: speed-ups, fixes, and
 new XDP programs
Message-ID: <Y71TRPNezv9woeEr@boxer>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0189.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::12) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: 615ab658-fa2c-444b-9fbd-08daf30239f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ej2MumPhqB6pZ9p82R6FwKDSlvSGFV1hzrc9d0iOoHifX5aO2zTQEBSZ5csWZ7TXkz5QR2u95bH/48hgG0IYo1Iy68M1DJpp1SNWd4CP0Q6kNdEMqPskwvlGkixYHRddbymJkT/3demDkem5KApquasW/tnSAJtEHu4eQd6PHPy24dSKTl0XcQ2eKlLF4CQI9N1stm7ZqlMFnTFvdn85zTI7rgJ6d+h0PC+j+D31AH5/iXVKZGvYacpY3gcRc9FbedKyu1mOVwMO9YYTu23/HWjKPFvyF0GY4N8lcYZjzyb+ZbF0ddI+iyIXs1KUuIQN90a6oGn/dKN2l2vnDMIaFfQpYL6biSMI7ADv284iAxpbCiQXM+o5WIKggz0hJaMOy7YPBHaApO3KZ6PikmA7aA8Z11Gj+sEimS+nQENnkBz0S8MhyO6JptdRITaXEmEDa0NNl7fJYVPUAMInWyPwMmIF+GPyt+huYEII4wqZLgohS9yf94NFwzuVYnw9FOzwnX4Q4z4A9wVN/9v0ffq4ISY57Xckxzd209st0cFaIXUfXbb4MY0EDIHIt3KAU1c/JS6XRRIdUoiu8tJEVd2lh15RBKz/SIDV4gxWMcYLJeWmjikkBdn+JxLfHIEJEFS77li95VLez+/Tu2J7QTujYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199015)(6916009)(38100700002)(82960400001)(83380400001)(86362001)(66946007)(41300700001)(8676002)(4326008)(66476007)(66556008)(44832011)(8936002)(2906002)(5660300002)(316002)(7416002)(6512007)(9686003)(33716001)(66574015)(26005)(186003)(6506007)(478600001)(6486002)(6666004)(66899015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?k5A0wy5mJ/IEHGhNN87+mPvZXTTArP2Sb9BhFcfqw07ZZT5Ho1YCbNe5Cz?=
 =?iso-8859-1?Q?mLPH+KE4B3QUPvtR0k6Z4Wu1m6xDnKB1ikbyn/Owjo/vcvNQ+qCTzAMvYc?=
 =?iso-8859-1?Q?4hHOJgWLV9mjYEsqKFbfcMstzp8W+3dK1fnUPjFgx2quKbTktgD4BrCCpO?=
 =?iso-8859-1?Q?HIRMdKMLxiScDBOOYYFtVApO9FATwF86HAqr50FgCt/BR33/vMAjKzH0rT?=
 =?iso-8859-1?Q?79gMrKazPLmBr6gIoIpkteWCFIHsaPA3HTTG7E1JBy+ZaEQBplNQNTe136?=
 =?iso-8859-1?Q?vOVd5JkLl6qeD+aOkGKUZD+lB6d+ULZs0f7yJVxK1oxftCKhJCjqSn3rGf?=
 =?iso-8859-1?Q?OMINNmmH6tjjt56ZpnVE0ci8zDOWGctDfZtW/Az22p+MGiEM0gtMtlPmVd?=
 =?iso-8859-1?Q?9Z81mk9LC9fHUn8ea0lJjdFYHFEQIVTPA9ognViPVD7KKiWWgrtKzgZu0B?=
 =?iso-8859-1?Q?2uHVQRAx7daiVYqWjYLTmE244jhuOJ+ZA2HwMVXMSEMZ+3RR8WRi7SoMZ4?=
 =?iso-8859-1?Q?UjZRsy3bJAhnwwp6MibBp329gVR6BxbkWJFzFeYYCweYUEAV8lSxMtQNf8?=
 =?iso-8859-1?Q?/b/Owu1QrwOCaY70awug7xL7ScQtkXQpUI2T8JWh2V1D3n5Ze37mN61q0O?=
 =?iso-8859-1?Q?ABYoU69cnuZsOZ6pumXZzqCeQWJYWKnb5Z6ffRILZ/TNw4dl4JWvYfwQ6P?=
 =?iso-8859-1?Q?3QcIRyTua4x4GY7lb5IFUo63ilosW6TqSDJZDfDOWDfzaXhSl7Xn5Gh27g?=
 =?iso-8859-1?Q?kbAf/JBHsqTJgq+1r29uRgX8Mu7vXs+vV0+GPZVBz1NeEvf94FW/SGoJ/I?=
 =?iso-8859-1?Q?E235+8vCCsM+/9gvnM09DDTndYjfbT5ah7E7IQC2lAulGqR9PNKKTf2FqG?=
 =?iso-8859-1?Q?lVKjCfzWo19rHNpE94r5CtKIDjMmmHBY/CpuznULXicON09OQgJwVZvt2T?=
 =?iso-8859-1?Q?EISyX/1p1ox9pDRqxxlzuMlMeFQjF4eVOqXVLc7QdqoBzDYJrWAZFtWJuz?=
 =?iso-8859-1?Q?/g1IY/VTfzO8hYZZ4sEz/ZosJVOQXodX6nk08E9PYIIKwyGvTTExqpQUMJ?=
 =?iso-8859-1?Q?sbkPuyLEP59dLrEdMOSN4iE43V4otroTLAxaGSxmGsPM5BkXEbD1liQmn3?=
 =?iso-8859-1?Q?Kht5nKE0ETG5XdpFIWRkrOqnCK25AhrzY3Ro5V5BNotlL7s43EEIJ0xAOz?=
 =?iso-8859-1?Q?K6NDYly5r8QZ36H9yaBkVKwdkyWYIVyBiWADbeAW5XFQroFtHx8wFbryWF?=
 =?iso-8859-1?Q?wy/Jt+PmV3PHA8guLaBRl+uc5H+E/fCn3mim0zuRx4n6FCrf1mNhBkQLH3?=
 =?iso-8859-1?Q?9cWJCtS/HQ4xok2yW6YI6fkkvWaO8/NnCp//bhi8bY7hi93eOFU3kNoj3g?=
 =?iso-8859-1?Q?7EUS1ycsX2HedcLLBi39jRTEre6MuUDW4YwQfieuhOU0dAZGOewdmGdc0E?=
 =?iso-8859-1?Q?MDhdWsL8R/K/w4s0yZoqzHr8WyOk5Pu5Yb42L8OcgpeO+J026Mau+CWFY+?=
 =?iso-8859-1?Q?+SanQ2POV2GOGMu1cYT0rtGnLKP0c5kK2rQEwcH7g3MsHA5FDBPjdmSmhP?=
 =?iso-8859-1?Q?Jmw/BUuydznRzquV1SZ8uDX65jhxOzSFzGB7zt+eC8LH/gc75w0hrilj91?=
 =?iso-8859-1?Q?myjCTFpdaZ7cLcQ6CcqQ6LiF6jmRfHcBq+NuvSFi7K+toH23TiFnYkBEMo?=
 =?iso-8859-1?Q?TipEXcwdxF0zI/2rOr8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 615ab658-fa2c-444b-9fbd-08daf30239f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 12:00:11.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24dmTPjOgb215GjbvZFE+z6gMWVm9R/s7U8pSfoeknB5/qfbZh2dslVSVDKbCjFsAAt27RvidQF7UjOncW5NdE30JtZhYWEPgW5l9IPS9Pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7303
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 01:17:29PM +0100, Magnus Karlsson wrote:
> This is a patch set of various performance improvements, fixes and the
> introduction of more than one XDP program to the xsk selftests
> framework so we can test more things in the future such as upcoming
> multi-buffer and metadata support for AF_XDP. The new programs just
> reuses the framework that all the other eBPF selftests use. The new
> feature is used to implement one new test that does XDP_DROP on every
> other packet. More tests using this will be added in future commits.
> 
> Contents:
> 
> * The run-time of the test suite is cut by 10x when executing the
>   tests on a real NIC, by only attaching the XDP program once per mode
>   tested, instead of once per test program.
> 
> * Over 700 lines of code have been removed. The xsk.c control file was
>   moved straight over from libbpf when the xsk support was deprecated
>   there. As it is now not used as library code that has to work with
>   all kinds of versions of Linux, a lot of code could be dropped or
>   simplified.
> 
> * Add a new command line option "-d" that can be used when a test
>   fails and you want to debug it with gdb or some other debugger. The
>   option creates the two veth netdevs and prints them to the screen
>   without deleting them afterwards. This way these veth netdevs can be
>   used when running xskxceiver in a debugger.
> 
> * Implemented the possibility to load external XDP programs so we can
>   have more than the default one. This feature is used to implement a
>   test where every other packet is dropped. Good exercise for the
>   recycling mechanism of the xsk buffer pool used in zero-copy mode.
> 
> * Various clean-ups and small fixes in patches 1 to 5. None of these
>   fixes has any impact on the correct execution of the tests when they
>   pass, though they can be irritating when a test fails. IMHO, they do
>   not need to go to bpf as they will not fix anything there. The first
>   version of patches 1, 2, and 4 where previously sent to bpf, but has
>   now been included here.
> 
> v1 -> v2:
> * Fixed spelling error in commit message of patch #6 [Björn]
> * Added explanation on why it is safe to use C11 atomics in patch #7
>   [Daniel]
> * Put all XDP programs in the same file so that adding more XDP
>   programs to xskxceiver.c becomes more scalable in patches #11 and
>   #12 [Maciej]
> * Removed more dead code in patch #8 [Maciej]
> * Removed stale %s specifier in error print, patch #9 [Maciej]
> * Changed name of XDP_CONSUMES_SOME_PACKETS to XDP_DROP_HALF to
>   hopefully make it clearer [Maciej]
> * ifobj_rx and ifobj_tx name changes in patch #13 [Maciej]
> * Simplified XDP attachment code in patch #15 [Maciej]

I had minor comments on last patch which you can take or not.
From my side it is an ack for whole series:

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

However you probably would like to ping Daniel against patch 7.
Also, usage of printf vs ksft_print_msg seems sort of random throughout
this series but it's not a big deal.

Thanks!

> 
> Patches:
> 1-5:   Small fixes and clean-ups
> 6:     New convenient debug option when using a debugger such as gdb
> 7-8:   Removal of unnecessary code
> 9:     Add the ability to load external XDP programs
> 10-11: Removal of more unnecessary code
> 12:    Implement a new test where every other packet is XDP_DROP:ed
> 13:    Unify the thread dispatching code
> 14-15: Simplify the way tests are written when using custom packet_streams
>        or custom XDP programs
> 
> Thanks: Magnus
> 
> Magnus Karlsson (15):
>   selftests/xsk: print correct payload for packet dump
>   selftests/xsk: do not close unused file descriptors
>   selftests/xsk: submit correct number of frames in populate_fill_ring
>   selftests/xsk: print correct error codes when exiting
>   selftests/xsk: remove unused variable outstanding_tx
>   selftests/xsk: add debug option for creating netdevs
>   selftests/xsk: replace asm acquire/release implementations
>   selftests/xsk: remove namespaces
>   selftests/xsk: load and attach XDP program only once per mode
>   selftests/xsk: remove unnecessary code in control path
>   selftests/xsk: get rid of built-in XDP program
>   selftests/xsk: add test when some packets are XDP_DROPed
>   selftests/xsk: merge dual and single thread dispatchers
>   selftests/xsk: automatically restore packet stream
>   selftests/xsk: automatically switch XDP programs
> 
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  .../selftests/bpf/progs/xsk_xdp_progs.c       |  30 +
>  tools/testing/selftests/bpf/test_xsk.sh       |  42 +-
>  tools/testing/selftests/bpf/xsk.c             | 674 +-----------------
>  tools/testing/selftests/bpf/xsk.h             |  97 +--
>  tools/testing/selftests/bpf/xsk_prereqs.sh    |  12 +-
>  tools/testing/selftests/bpf/xskxceiver.c      | 382 +++++-----
>  tools/testing/selftests/bpf/xskxceiver.h      |  17 +-
>  8 files changed, 308 insertions(+), 948 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> 
> 
> base-commit: bb5747cfbc4b7fe29621ca6cd4a695d2723bf2e8
> --
> 2.34.1
