Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F7362D11A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiKQCW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbiKQCW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:22:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEA622B3B;
        Wed, 16 Nov 2022 18:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668651775; x=1700187775;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tKYwmgWlCeETKZE/POIZUDfmTUkN6LBLSbqeWr8C5NI=;
  b=gamfgJx81t1Wy4eQOyDWU46YCU7tB7u38tfjAl46G0lMOXHJ7IldCBT5
   KGwsTDAJ1bYC2SRw8D93UxVfwgZuSfekgNBA3y+nclna6si+VsOcdgMew
   cctYk+ly2OLGCTwXU23pIKNXFQ/OZSFKq7hhFD4HvhN7dm03AN6f53jVK
   enbsr4bW0ag47v7p97GST2WSutGFNuX4oQg4ZkKSx74fm4v9UG2pb/iXj
   NLUJuw4/qYawyPHePEdBL28vSl9jShTg1P5k2K5qzodr1XYKAbP+9M8bI
   OVTkYS6F7t91I386sEADmhbSRK0DNbVxxHkhhJxQQ/gseXVDoP58NiTVb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="313879622"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="313879622"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 18:22:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="814329211"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="814329211"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 16 Nov 2022 18:22:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 18:22:54 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 18:22:54 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 18:22:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cA+89ArGwYnXkYup/rNJtzblnng8b/FwmOVwPUlAN2/2jLXuZiYpisYPe8LjrU5PEeSWVbrtldhgmeu5CIzAwc5SLyA8FF1xdsrBzHjMHHe04zp0oGb+L5aoYcF0g1NbQIN/MxvvUng58W+jsUcdTtEh2fz9Mr9w95PfDAOIiYKqxV1+dSVJOwji5/kUOZARdPtzMd74M9NP/MgZ392SE3uDEzD0aKzqSxCr/0yVHbQr5XjA0hkXsHuTED19Ww9bAbDmbpI7X3p7pwEKP6LrUgI9Tb9N5FewnfuSwIhoWeqtDXP1Dq+xD+U0y5CJCG86vKlD8KkGSXISses73yfbSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5BQ+tRnCRtJdajgJMirwlSNXdFPljDXOdNXDSRWxDo=;
 b=S0J3W78S4VUM9gtN2UzhJPoqpB/sLM3hnlelMO5OFQaV3ga0926BNIQFM8gllxCgc9YeoDM+0/Z61QGG5NctLR+Q846gKsZKEK0I77uGRhJAa3aLITxDmXivjtyxUP6I/J3sJWpxKn+5JxS1YpbN5YCbXVj8qDSxj7DHlP45PQcCkqRDF4AkY4AfLXPW7CG+qQ0WlwzBBdYtmPcmstZ1k21gDmIvQfF3J8cflpT1sF7bGYrcaRd9JUYpcVRguTDpMhiaCitYARmxXm7HtlgVkVNK3Ftg0OSMoJbKFvawVKvpcvjLysLWhBJ4YgRQ1b1xK5yqVe1H2gsqBePOYVoZtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 02:22:46 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::78af:67f1:f3ad:a5]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::78af:67f1:f3ad:a5%6]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 02:22:46 +0000
Date:   Thu, 17 Nov 2022 10:23:01 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>,
        "Joanne Koong" <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Mat Martineau" <mathew.j.martineau@linux.intel.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <dccp@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 net 4/4] dccp/tcp: Fixup bhash2 bucket when connect()
 fails.
Message-ID: <Y3WbBb/cWSopB6j6@xpf.sh.intel.com>
References: <20221116222805.64734-1-kuniyu@amazon.com>
 <20221116222805.64734-5-kuniyu@amazon.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221116222805.64734-5-kuniyu@amazon.com>
X-ClientProxiedBy: SG2PR02CA0073.apcprd02.prod.outlook.com
 (2603:1096:4:90::13) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|DM4PR11MB5536:EE_
X-MS-Office365-Filtering-Correlation-Id: 37f29842-a65d-4be0-e835-08dac8429cc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sa4SKXWJIyC9sWQcqe+m9vGCGgwItwpUwKO/SBIOlVNlPH5F6+6Xuof+U1ycNt+GwAL/hjvAyGozEDSgBssjAPxjChC0OCrHlTE8L9FOxqxLuxlpHSAxrviYOqD96CBvOd/A6TUmZujgK+I6ErIaJhVnmRz4dkpAytD2oWMZgZYtMSlCuDRRpI362CL68FrUt7cKF00Vbt7+F4wEWBjMTeo30d1nkZm7YRxFwoCG9Umcu7xAI62IFwbzmEiVu/KsSWbhCUDJ08cjbJh3ISiNQi2sDzj+aRAnLoZd8Uu7RKkVrDi3/1S3qgqxi+9unierdOEp7LkLwFATxX/YtIAh/LPCa0EIxYM+3C+sd2npGWLxGXFGT5TVntgA07JHvBf/nxtA9hHZ0f7wYb8+LwyzDJP9PLVEbFzWOF+uhC6OYMUfDXmkj6uUWcv3v8BOMTnlkRCv9+Ai/B9SsWULE7ZIMJ2LNOOKgbuRBoagMmtZ8qoFem6+BGaWrEA+WnpBaZfLRluBg5atW1MUvOSFjU1ByfC3IWaCxw46JImJPF6K60AYYfY5bAgu0aK+cu6hzZ/8WwAxH4+F961hgOYuXOoL+rTDwG7tQxX6lIJATvYlTlpSKmsCcmVFyZNEJzkESC+PQdNBbTV3BxFVMh0CIT4n/UQhsqGHui3K4oB5ZaQVfTvXis8t+XtKObSejelGORjY6iSdeWqhCw01gHjnb/VrReY+omt6+KS39SMIuC38TqagY9CpvVlqoBnNo3Ie00hj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(478600001)(6486002)(83380400001)(86362001)(82960400001)(7416002)(8936002)(5660300002)(44832011)(66946007)(4001150100001)(2906002)(66476007)(66556008)(4326008)(8676002)(38100700002)(6666004)(6506007)(26005)(53546011)(186003)(41300700001)(6512007)(45080400002)(316002)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9VRhSiLWQrUkIshMGGci6pSamCv2JLEGv51504wfHDjI3jHCuqseeeHFql9?=
 =?us-ascii?Q?VUsO9BsTMMqmUC5K1fVZiKXss7nVeVN99bNRu47oBanpN5OlGp75aoR3u1ou?=
 =?us-ascii?Q?LiAGobpPHcruJHDaj1Yr5Xp/2YnRjTD4LPEkG8cAnKcGK8CtxBCBU2JijG16?=
 =?us-ascii?Q?g1IXZmnTfgzg1F2zXHAArY6MchnVS4gOHDVEfVnSI12ykvOV8kwgfu0YeJZT?=
 =?us-ascii?Q?4c4tZ+W0nKMsEseHEZfI3lnN+IcXTYBjRjflr0m58hrlm+WJVMCeOuehhXoA?=
 =?us-ascii?Q?WZX2qa0PxHUtJ51P08uDZIKxwl9nBeKzMYZSHQRfbwt/2/oY3puptcaqZGh3?=
 =?us-ascii?Q?b4tp81B00bj/3sF+rTPPBoWflzqrYC2TuDxxdaDLjyG0qk5nYO3TE1DKC0Nl?=
 =?us-ascii?Q?fEab2lqN3z+2w3PWsVH6cEHwXBOjF4fnx2rqMri8eoVfXMbHgjDadfQXdPpe?=
 =?us-ascii?Q?uYwty3RS3Xcvg+uCLyTFIlyPHF9eRKtHJfU4lMB7U1xQk+LKk/8oIqhHDkYc?=
 =?us-ascii?Q?BwLn5DfcAx8ttXJw1mnzOTyQPKaQPA+eI7AQkQpYdO43/0DeOogATS5ayNWD?=
 =?us-ascii?Q?R5rWuIGMoruqXZfX3U8i8GQQQ9uC8+7hYpSWYF40cTjq7PH02vL0zzx3o94T?=
 =?us-ascii?Q?Y7BPulV4TIMXcthGT40Vx6xyLwlGp/OYGiUoMTR6T+ojS1WACki+jyJb89a6?=
 =?us-ascii?Q?cXtwzdFKjf/jv6rH3CeAXcltK8aB3/IGpb+JNmD5ATnP1xuyMHGclTHaZRTE?=
 =?us-ascii?Q?4CPtM0Pkz8BdJmXpOz8ogem8k8+g0vCZ8yAZgCxHbbiKpC+UYZb5SRqG2mbS?=
 =?us-ascii?Q?7Ux7eciIr4FB69//NnMz874itfTNhi1bNL4hI8yzIuO664ZXoVX8smoYmBSf?=
 =?us-ascii?Q?8Fhs7NCAzRmFl61f3NOqHozCoDyDKnlUlsGnGpUOuA0CworYPjfm3oP1He+X?=
 =?us-ascii?Q?GEnmJSUtbAdnetNdX1biKwYoLCMcufEYDhqghXQ1Og+Eto+YGbVRFN+K1jXS?=
 =?us-ascii?Q?CF9/FKsaYrANVhRXLEo6aE4+5Fx6UZ6lC4OIbvRScs+s13j4C/phwrmvQ+Ib?=
 =?us-ascii?Q?q0/jj20fQvRH6tj+Nbl2/d+M73gJvG5SuesbEEdY5AfUriEYtX3TKYsAfEgk?=
 =?us-ascii?Q?ka7mflyhGJx9qFCuc7IBxl72dFePOfs9XM8sAv5OfkkiH/YuTfsR957/sMp3?=
 =?us-ascii?Q?O2dPc7j7JJzR40l87YRJN5VeQBCm0hpmjqrh39X0eUvEVorTY0yix+W8pELW?=
 =?us-ascii?Q?S8dDuwrdzEtMD25tH5BNB3S2y+JeSCeoKBzC0H3dWqmwEDmUL6yVxby1VV42?=
 =?us-ascii?Q?A3dklrWs6f+NkcnBQ0JCtc8qa/SrHieZq4TU59Ww7TsylWyvHvY5wr02lSE1?=
 =?us-ascii?Q?G7d9u5V/uoPu4m1cNwRy6J1AhA8zGPTgYKaD9Kw/wyvuJNPQb5DVzDH6lcGK?=
 =?us-ascii?Q?HVz5aeAxVak4gCYlJxP4tdZM6wEh9esTjmzJuwETN/NKCDOFtNarLRyZwV2T?=
 =?us-ascii?Q?+SWEK7i8fMYSI72CJg2qvRyYUUCqJWcaNtZtJXIIKniBBf92o1DGsF95J4pD?=
 =?us-ascii?Q?g6b3MtM1SFsQtL9hqEJa8ZkjhOlD+bfUK03b7CkMzmn3OJn63RVucuR4dfWL?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f29842-a65d-4be0-e835-08dac8429cc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 02:22:46.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jdH+nuvjoBDsWSBTAmxLNJSQw4reqQlkWhvrTaHW+VDza0o6R2YQrJBpmtI2S76ROzMHhzGDEzrCfvVJ9s81g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki Iwashima,

If you consider bisect commit or some other info from below link is useful:
"https://lore.kernel.org/lkml/Y2xyHM1fcCkh9AKU@xpf.sh.intel.com/"
could you add one more Reported-by tag from me, if no, please ignore the
email.

Thanks!
BR.

On 2022-11-16 at 14:28:05 -0800, Kuniyuki Iwashima wrote:
> If a socket bound to a wildcard address fails to connect(), we
> only reset saddr and keep the port.  Then, we have to fix up the
> bhash2 bucket; otherwise, the bucket has an inconsistent address
> in the list.
> 
> Also, listen() for such a socket will fire the WARN_ON() in
> inet_csk_get_port(). [0]
> 
> Note that when a system runs out of memory, we give up fixing the
> bucket and unlink sk from bhash and bhash2 by inet_put_port().
> 
> [0]:
> WARNING: CPU: 0 PID: 207 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> Modules linked in:
> CPU: 0 PID: 207 Comm: bhash2_prev_rep Not tainted 6.1.0-rc3-00799-gc8421681c845 #63
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
> RIP: 0010:inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
> Code: 74 a7 eb 93 48 8b 54 24 18 0f b7 cb 4c 89 e6 4c 89 ff e8 48 b2 ff ff 49 8b 87 18 04 00 00 e9 32 ff ff ff 0f 0b e9 34 ff ff ff <0f> 0b e9 42 ff ff ff 41 8b 7f 50 41 8b 4f 54 89 fe 81 f6 00 00 ff
> RSP: 0018:ffffc900003d7e50 EFLAGS: 00010202
> RAX: ffff8881047fb500 RBX: 0000000000004e20 RCX: 0000000000000000
> RDX: 000000000000000a RSI: 00000000fffffe00 RDI: 00000000ffffffff
> RBP: ffffffff8324dc00 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000001 R14: 0000000000004e20 R15: ffff8881054e1280
> FS:  00007f8ac04dc740(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020001540 CR3: 00000001055fa003 CR4: 0000000000770ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
>  inet_listen (net/ipv4/af_inet.c:228)
>  __sys_listen (net/socket.c:1810)
>  __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
>  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
>  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> RIP: 0033:0x7f8ac051de5d
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffc1c177248 EFLAGS: 00000206 ORIG_RAX: 0000000000000032
> RAX: ffffffffffffffda RBX: 0000000020001550 RCX: 00007f8ac051de5d
> RDX: ffffffffffffff80 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007ffc1c177270 R08: 0000000000000018 R09: 0000000000000007
> R10: 0000000020001540 R11: 0000000000000206 R12: 00007ffc1c177388
> R13: 0000000000401169 R14: 0000000000403e18 R15: 00007f8ac0723000
>  </TASK>
> 
> Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/inet_hashtables.h |  1 +
>  net/dccp/ipv4.c               |  3 +--
>  net/dccp/ipv6.c               |  3 +--
>  net/dccp/proto.c              |  3 +--
>  net/ipv4/inet_hashtables.c    | 38 +++++++++++++++++++++++++++++++----
>  net/ipv4/tcp.c                |  3 +--
>  net/ipv4/tcp_ipv4.c           |  3 +--
>  net/ipv6/tcp_ipv6.c           |  3 +--
>  8 files changed, 41 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index ba06e8b52264..69174093078f 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -282,6 +282,7 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
>   * rcv_saddr field should already have been updated when this is called.
>   */
>  int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family);
> +void inet_bhash2_reset_saddr(struct sock *sk);
>  
>  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
>  		    struct inet_bind2_bucket *tb2, unsigned short port);
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index 95e376e3b911..b780827f5e0a 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -143,8 +143,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * This unhashes the socket and releases the local port, if necessary.
>  	 */
>  	dccp_set_state(sk, DCCP_CLOSED);
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> -		inet_reset_saddr(sk);
> +	inet_bhash2_reset_saddr(sk);
>  	ip_rt_put(rt);
>  	sk->sk_route_caps = 0;
>  	inet->inet_dport = 0;
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index 94c101ed57a9..602f3432d80b 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -970,8 +970,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  
>  late_failure:
>  	dccp_set_state(sk, DCCP_CLOSED);
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> -		inet_reset_saddr(sk);
> +	inet_bhash2_reset_saddr(sk);
>  	__sk_dst_reset(sk);
>  failure:
>  	inet->inet_dport = 0;
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index c548ca3e9b0e..85e35c5e8890 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -279,8 +279,7 @@ int dccp_disconnect(struct sock *sk, int flags)
>  
>  	inet->inet_dport = 0;
>  
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> -		inet_reset_saddr(sk);
> +	inet_bhash2_reset_saddr(sk);
>  
>  	sk->sk_shutdown = 0;
>  	sock_reset_flag(sk, SOCK_DONE);
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index dcb6bc918966..d24a04815f20 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -871,7 +871,7 @@ static void inet_update_saddr(struct sock *sk, void *saddr, int family)
>  	}
>  }
>  
> -int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> +static int __inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family, bool reset)
>  {
>  	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
>  	struct inet_bind2_bucket *tb2, *new_tb2;
> @@ -882,7 +882,11 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
>  
>  	if (!inet_csk(sk)->icsk_bind2_hash) {
>  		/* Not bind()ed before. */
> -		inet_update_saddr(sk, saddr, family);
> +		if (reset)
> +			inet_reset_saddr(sk);
> +		else
> +			inet_update_saddr(sk, saddr, family);
> +
>  		return 0;
>  	}
>  
> @@ -891,8 +895,19 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
>  	 * allocation fails.
>  	 */
>  	new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
> -	if (!new_tb2)
> +	if (!new_tb2) {
> +		if (reset) {
> +			/* The (INADDR_ANY, port) bucket might have already been
> +			 * freed, then we cannot fixup icsk_bind2_hash, so we give
> +			 * up and unlink sk from bhash/bhash2 not to fire WARN_ON()
> +			 * in inet_csk_get_port().
> +			 */
> +			inet_put_port(sk);
> +			inet_reset_saddr(sk);
> +		}
> +
>  		return -ENOMEM;
> +	}
>  
>  	/* Unlink first not to show the wrong address for other threads. */
>  	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> @@ -902,7 +917,10 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
>  	inet_bind2_bucket_destroy(hinfo->bind2_bucket_cachep, inet_csk(sk)->icsk_bind2_hash);
>  	spin_unlock_bh(&head2->lock);
>  
> -	inet_update_saddr(sk, saddr, family);
> +	if (reset)
> +		inet_reset_saddr(sk);
> +	else
> +		inet_update_saddr(sk, saddr, family);
>  
>  	/* Update bhash2 bucket. */
>  	head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> @@ -922,8 +940,20 @@ int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
>  
>  	return 0;
>  }
> +
> +int inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family)
> +{
> +	return __inet_bhash2_update_saddr(sk, saddr, family, false);
> +}
>  EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
>  
> +void inet_bhash2_reset_saddr(struct sock *sk)
> +{
> +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +		__inet_bhash2_update_saddr(sk, NULL, 0, true);
> +}
> +EXPORT_SYMBOL_GPL(inet_bhash2_reset_saddr);
> +
>  /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
>   * Note that we use 32bit integers (vs RFC 'short integers')
>   * because 2^16 is not a multiple of num_ephemeral and this
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 54836a6b81d6..4f2205756cfe 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3114,8 +3114,7 @@ int tcp_disconnect(struct sock *sk, int flags)
>  
>  	inet->inet_dport = 0;
>  
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> -		inet_reset_saddr(sk);
> +	inet_bhash2_reset_saddr(sk);
>  
>  	sk->sk_shutdown = 0;
>  	sock_reset_flag(sk, SOCK_DONE);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 23dd7e9df2d5..da46357f501b 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -331,8 +331,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * if necessary.
>  	 */
>  	tcp_set_state(sk, TCP_CLOSE);
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> -		inet_reset_saddr(sk);
> +	inet_bhash2_reset_saddr(sk);
>  	ip_rt_put(rt);
>  	sk->sk_route_caps = 0;
>  	inet->inet_dport = 0;
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2f3ca3190d26..f0548dbcabd2 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -346,8 +346,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  
>  late_failure:
>  	tcp_set_state(sk, TCP_CLOSE);
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> -		inet_reset_saddr(sk);
> +	inet_bhash2_reset_saddr(sk);
>  failure:
>  	inet->inet_dport = 0;
>  	sk->sk_route_caps = 0;
> -- 
> 2.30.2
> 
