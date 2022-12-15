Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7B64E1E4
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiLOTjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLOTjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:39:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEF848777
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671133158; x=1702669158;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lJ8Xh57nMaaXySYbBzQuQ5jP2JeWJu6Egi+HkEvTom4=;
  b=l+930uuLJUVt9U12aBL83H8q3tdC/1A/s6sv7eCB02cuByVd7gQ9GsVU
   Qwny/wZe3whhWx9KNUb6wvTTBqomU1R508aEb8QFZ7h/xF/CiZ4AaK0eT
   zFE4KGc8ZTTjHz0bYN2jmxiDKQtrWDIHRT+NJbtaSa76OeiN2NJ+30nL5
   ZdiljdVhw2vwV9LmFPcYegkJ5kKiR/k8tOWHzhAIoLdrPZzuXqI7/BuGv
   ZnuaFr+fSgO79qZwxi7HJudSJik7V/hgnMFXXVvJl/Kzg3dLt1lOg5Jmg
   AanMIK0qbwxA+uIH6Pn1+5Ir3r0T1ftVu3XCHNXqw0OR1GNFoHio2CHPG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="319953391"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="319953391"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 11:39:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="627318964"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="627318964"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2022 11:39:17 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:39:17 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:39:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 11:39:16 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 11:39:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYkZR7Hn+gqXuBFjC5cqOmSlUgErIQ7k7dpImCdHAMAvoJVWABMEJgVn1bqG25SYCj4M+K4Rt3CMxFSq4FBCHS5pKTcEnhyWr7fgN8naoaokczN7l5g+qpwP6mxQf89mF5Jt2tIJvLAq1cwBBwiAkE2fBuTAhWAb0Ncg9lbIfj8egyrHOCppuDnwmG4ZRx71hpcwD1ECrZoCgkd57PTPgNK7aEJsQ3p4P9luuYC2m6P1Z2BEVnyAn6LJ4NVfKczSwxCinx7B8kzUYNkxUt+4DumPd7KB9CKfVoa0guuTnPRQIopIbYRkmFiqb5co0ObkeW6dsuZoGJe803N0fkthJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=przBIothJTpy+3vBXpdDNtxa0ndrbfr2aQ7unPzt4c0=;
 b=IfefwsiL3jgPybcyvY9efncXDiTNsBq71e5Bh3d4eTK0/Q+ER511OikmjOzqFRTx+7J6nyna2xsRVmMh+sEKGp08jM6O8lP8IX2UjWCCoX+AfAqqaW+66vky+1RL47qndbGDu38xRWvz0FI5p2uZ/XGlfW6IAXFGzDdrJIABIF8gN9TCkBmKs+Syq/RnSNpaAPis2M2HZzhk1ew3qqhK3+A3nop0hVda7jo9/lyMdJlG29sDTWLf9oUA6pqfOldssdu8ak3IXr76bArZaL6TzembVMnVa5EGOPcWf1FxLaBih9+8Lea4VbO2gfPL1NFaruI+Ru4xa+vgYtREhquL4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6163.namprd11.prod.outlook.com (2603:10b6:930:28::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 19:39:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 19:39:14 +0000
Message-ID: <b6601ffc-049d-75da-ba75-aa828655db72@intel.com>
Date:   Thu, 15 Dec 2022 11:39:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 00/15] devlink: code split and structured instance
 walk
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:74::19) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6163:EE_
X-MS-Office365-Filtering-Correlation-Id: 2490d629-3eef-4fec-7264-08daded40c02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEwko8thnj3KB+GMTAx++V4CSupo+I9efq819FF+1FqCcfJDRg8f8bd2XHLi/qz9d3rpqniaHNSiCUAS2/8gRsiL9T+rUAkonDuHk2qTwzfgq3oOi6mhuhxPcUb9liXkiIULGhszXGTqjEfjEwdtVCy0Yto6zwdA0cEL8eg/FxL01DpXvWvHBn5Mfmnk3ugpNm8oDOLe5ad1wllCMf9976pW9tByr/YUFy5Ut911LpvhthD6FsfeFK/L9m97/2fa5YMEqz1wkA847SGObvZjO6nr+31pFPwxe48Rk6x+HOzscdUPAnmNqGoLeAoKoGKvWXxXWsobTqNVsHIuPxvekcw09j5EdNxMVOVil19vxj1U8mBbSZtpJ2o2dqMxh3hM1JA7+FC7fvEb1KO/HTbKpKxSb1f40JPcmVZzHKptSZNDYS+Xx3Jc749rrJuMKmNaZtSXheZ0zVfQvL6jfIRf9cwc0PYCg9MQK+JhChEVDgAUBbbwVJnu0G8K4gM980mNII8xJa0yVWL4jwFJZ9urNQxtwgCj3rx7v79Ye8tDSV6y8XNDlyQe76/gEufNKkGOmrZ/69rw7OI7BUgsap5tquGRVAsqAwn3RY++exPjfNB63Nf/wjbDANB5GDtmIvxF49KiuhwDr8bplnMz+OpC/kv1XSQOmw7ZfqgRqTeq2ndohxrSNxlabb/GiGSCFN2anyn3nkTln8NFqM2DPplZ1hmL9P+qDPnvf3uns3jykfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(66476007)(6512007)(66556008)(41300700001)(86362001)(4326008)(26005)(31696002)(8676002)(66946007)(186003)(2616005)(478600001)(6486002)(53546011)(316002)(6666004)(38100700002)(82960400001)(8936002)(83380400001)(6506007)(2906002)(5660300002)(66899015)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TktpNVd6V1lENEZHTkMvUzdCT1dqL3ZObGZJck9xdWtUUUFlQi9nbnZSU0s5?=
 =?utf-8?B?eS9lSjlvYXNrYnJqdkREUFlCQzlXNXJVMXRmQ3VBQkYxMzg5QmdRY3BwWGhN?=
 =?utf-8?B?eVVDYzFzT09TOUo0VktrcEx5VWFoaEU1VUt5VWFVNnNSOVZRbmpndGwvQXpI?=
 =?utf-8?B?OThZR1hOclBjNXF4RmIyN01jMkpQSm5aM0FEN1dCNFYvbEJjZXJGVlpnb0lw?=
 =?utf-8?B?NnpxazBlSGdRQ3NqeHdqVUJKWDlGRC95bHBLczVKczhoYkZmZmpmOEMxUVJx?=
 =?utf-8?B?Tk5DL1dIdmFkUTJrVDdCTkJBVHRhYkhqUkhTZnc3UWhGSFpGbjFPQnc1WHZJ?=
 =?utf-8?B?YW5Rc0JmNWhndnRpWnFNOGZmdTJUd0pqcksvRFNCREsvSGFUcVdtQXYwSFp2?=
 =?utf-8?B?SnRKWnhoMGpyTXBXS3dXREovdWxVMVZjTEFUbzZwMUo2SC9SWmxVcnorbW5K?=
 =?utf-8?B?ajRkMDFscXBPZG5uMk5OVjNCWTZkN0N0OWI5YlVTK3FVeVZGY3dpdklNU2tU?=
 =?utf-8?B?MmVqcjVwc2cvajhMd1d3RUVWbHVFUEdENmppU3VJblhZaFNiM3RtTGsxL3Fk?=
 =?utf-8?B?QUNVVElpM211R1dUZmYwck4rYyszN2ZBazZ4OEFnbzdSYjF6c2RtcGFoVDlo?=
 =?utf-8?B?RmVnaUUrOTdSYkQ5Rk4waDVxQ0lNVHZRcnRoMGZJMGxLb0lUdE9iWUFqSDNL?=
 =?utf-8?B?L29lSUw4OFBESlNOZ1pqRnVyb2pkSGE3WmZzVW5DQ2RqWXRIUzF0QkhVMnpi?=
 =?utf-8?B?Z21WNks4VVNJdklqV0txTHhFOEdUSWVqTXNscEcxOGhJU2pCWS93TzhwKy9D?=
 =?utf-8?B?MTcxTDh0KzVzTTcxZWlOYjZBUFNPR2pXelhnZUNFL05sdVpHOUZqSjNTcEIw?=
 =?utf-8?B?UTJOLzlPRzR1L2Y4US91bVVuRXNTZVpJeFIySE8xNUttOUpVU2RhRHQ5N0Fq?=
 =?utf-8?B?Vlo1VFFIcWR4UjJTRzgzbFhIejBZR1poT1MydHFkNTRDWUdlRWtCN1Q2NExB?=
 =?utf-8?B?NTlheGVhc213RTBtdEFrbnVZNndGM2N0Q0FTeGcxaU1EeTBxd01xbmtueG00?=
 =?utf-8?B?endTcENsY1E2WjdXbUppUTJHMGIzam51MEorNXQvZVVwNVZYaUlkMDVXRitV?=
 =?utf-8?B?UllnNDZwTVJrYytlYzU0ZjlOS201TTRpMmsvb2tlU2JUK2kzT0Q5QUJYbk5m?=
 =?utf-8?B?MFBlSnpxbXJQMkZ5WnZzSTlvOU4xZVMrRHFMNzN1d0JvelRtWkMybjdISGNC?=
 =?utf-8?B?YjFYbkdUelpCSUlDS0REUHczelNEOTNYTEVZODN1dEpSL2pqWGI2Y0V4ZWVH?=
 =?utf-8?B?My8reVR1Z2s4aUZRZjErSVcrNjBLWCtQaU1GNThuUlFSVlpwQU9UQkdUMjBM?=
 =?utf-8?B?Yk81S292MnMvSnlwSmFmdmxMai83My9RUFdTdE4rOEhMcFJxM0RVMXJrR1lk?=
 =?utf-8?B?M29pdDZnRzk0cWhRN2RRc25jR2VkZlFxajFZTEpMVjBUSEhpRmUvcU1Kak5Y?=
 =?utf-8?B?NllvNS9jR3NISHhrZnpiR1lqZ3hMUG1RMFBvSFJZS09DVlpzdHRxWUNvLzJr?=
 =?utf-8?B?UjdzWjZUbUNQc0JTUzBCU3FxNHB3eGJkRGFyTEFCdGxYNHJYWE1VTkxjZ3h2?=
 =?utf-8?B?elhtM29XTmFsdld0b3Bla1N1cjhIZ1k1ek5xbkFZaEg5cUZiTjBSMDB4bnJH?=
 =?utf-8?B?Lys5Q0dObFFERHN1SkxTc0NRemFXZmd0dENrSDg1U28zZCs2LzArNGdvMFZB?=
 =?utf-8?B?WGdpSVprb0FxTDlZWVlrMHJZT2VSTjYzQzVRZ3lFRFI0cnRodjZ0K3l1WWxE?=
 =?utf-8?B?dVdRZHpnWHpRRksvbWxKMUgyM2tOWVd3TEQ5Vy96eTgyeGZXdnh0UmJ2THNK?=
 =?utf-8?B?UzArb1dZbFlTU0RZUmRSSzJGQ0gyNWFyYXZpMzB5aWxMMUl3NUsxdVlOdC90?=
 =?utf-8?B?bXBQd0xxbXMzTktaREVUaFRQTmtZTW1hNURkZ2hJUHJWdjFINm9CVDh6d3Fm?=
 =?utf-8?B?OGtJUlZ0REViUzc2NHFEUlI5bHBmQ3JjNDQ5TVBRRk0vZ0VneWl1RkJXNWcw?=
 =?utf-8?B?SG01UTNKSnR5L1FaRTI5U3NvUkUxTDZ2NzJvdnpXbDVuZUV0ZHVORW53Rno0?=
 =?utf-8?B?VEJOUW5pWEdvNVhxcTJrS3FsaC93UHAxYnRVL1NQS3lidmlZZURibDBMTjc1?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2490d629-3eef-4fec-7264-08daded40c02
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:39:14.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kHVNMRwVnfAnaN3W/YvwtRH8EckWaD6hLTJSYhwYVbWTITa9liloP6tFN27jPuBsqWm7uWpg6K0q1OQ7k2rptwxjZiM22xhe4tG8aqamfoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6163
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> Hi!
> 
> I started working on the refcounting / registration changes
> and (as is usual in our profession) I quickly veered off into
> refactoring / paying technical debt. I hope this is not too
> controversial.
> 
> ===
> 
> Split devlink.c into a handful of files, trying to keep the "core"
> code away from all the command-specific implementations.
> The core code has been quite scattered before. Going forward we can
> consider using a source file per-subobject, I think that it's quite
> beneficial to newcomers (based on relative ease with which folks
> contribute to ethtool vs devlink). But this series doesn't split
> everything out, yet - partially due to backporting concerns,
> but mostly due to lack of time. 
> 
> Introduce a context structure for dumps, and use it to store
> the devlink instance ID of the last dumped devlink instance.
> This means we don't have to restart the walk from 0 each time.
> 
> Finally - introduce a "structured walk". A centralized dump handler
> in devlink/netlink.c which walks the devlink instances, deals with
> refcounting/locking, simplifying the per-object implementations quite
> a bit.
> 

I'm fine with the series as-is.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Moving the dumpit_one thing into generic netlink files seems ok, but I
trust you may have already thought about and decided it was too devlink
specific.

Thanks,
Jake
