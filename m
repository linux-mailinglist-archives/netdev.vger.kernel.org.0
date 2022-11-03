Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B69617DFB
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKCNea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiKCNeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:34:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2054.outbound.protection.outlook.com [40.107.212.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CB363D5
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 06:34:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+W4sAnsu8HikBKUV7n/45DFZjk9XWbVKiNlXbGTTJpl28mU2HkiOPk3lrKWe819U0BWVVE92AvWEkiVusM9HdTmsbgh3NpytR8hGoEZFdBpJbnDOLbA2RXXuCb/7AmvDVFsSgTPC1JG05JPYpqf9SNHtqXgq+c1He3PqjwhWmbTc1N0QV0bA7uB1t/DZpA0xLZaNuRjBGM6gHbaqOrBoRgg7iYihJVu2LrE5Kd7+DeX758H19MOcwYKfAEwlEV50ckoUf1rfeLYro3oAX0+3fXOjN1LF+soUDEzi4lRtL/TbkvONQN9GCfi5MPAXGFUTWeaLfMI16vhGcsFM2U9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bf2xNbPE6kKs4KAaxy7Ku+5V6/T3wDGpjZRK6yB1IXk=;
 b=cRa2kPJyFBpXnARKewbW2wBlRovefd96tZguA83wUt/UBrdkVfB416XhFH43rvIY3dDEXgQvV7qiFalu7slS8oXmPXt3YCA61PQrsg4P616LY6ZNSgi12QNFIuH1N9YlCdD0p4xxlk3f83kT+ghSgtiVaxLkUQhmwIMRzhDN/N/8NzGarlboZn6ug97fhnvD2Sn/MTLcjYYOdwNoa2bn4rCBZ7jr7L4M2rcb4fAlJ8Bu27wU2fXLb7mn0VswU8Ub3Kxic06mS2FYC3+gmDMax90ikWijDRIZJ7WR8YPhR2k/im0CSdJDjJ+f9wNxIczXabkOoGEozIxDPo9IDlIJSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bf2xNbPE6kKs4KAaxy7Ku+5V6/T3wDGpjZRK6yB1IXk=;
 b=pVNVBTV0FqPHT+Zmql5i7rjoxH1vR0y9DG/GfYxSSt9DIjnh+XpRdVN3iXZHdjLsHcAhcBHqAcX4Cletqeo+fX8SpHZJYu2otVCg93zjObUekf/a0a11oB5mg0QF1q0CuEoVjcvsZardskSqJpV+5Gd5i11uBPHQc3m6HUFC1gG1X6e6fvdpfACIRDq2BgIv6lMwjshx5Y8QRuTLm3fHFIK9toenWG6QKPGGPSvvhWywU9eGMcmHMphWkv6cIIASpljacdC0Ck9I+FzFSK8ZPXAm2AA32VJiuikNg4vZAyagmNAeXUzKVqPsLqswkHMZmr7qJGBDha6vG75jvvIcUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM6PR12MB4074.namprd12.prod.outlook.com (2603:10b6:5:218::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Thu, 3 Nov 2022 13:34:20 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5746.028; Thu, 3 Nov 2022
 13:34:20 +0000
Message-ID: <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
Date:   Thu, 3 Nov 2022 15:34:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20221018203258.2793282-1-edumazet@google.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221018203258.2793282-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0661.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::15) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM6PR12MB4074:EE_
X-MS-Office365-Filtering-Correlation-Id: 2518f3c1-653e-4263-258f-08dabda01cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5XjWC9RFV9uO8dgyzQ/GftGUCvwBtYTIFvYYYZLxik5I5tcTtLiqg7EqzXAKoVGnywIQoVqTQazosFYBRUA3YZEPEPzXv3ku3C3Z1f0VESY+XwiDWw3nddanrZHYp+pWv48819SVYFZvhrqvWA3gOfPShIRXeVfbmIntwd+/wkr3uKjm4HZe6KlUX139GQfF6J5hFWhBRfMFYUyn2qLWW/gyFOuZuNNvskIo+E/P15pwmZ43TbgYF573oXnZKXxeH82C7KGzfjohXwJXuyzXjo+VxUb4pLLT+WroPDLPTrLHaHXUpqFQKBG8wuiiO4I6tbwkpMEn1uHbcXn62MselvUQSfCxpJwP9++yIidu5Rs5SpG8HuUgAOFLfee1cnsN41hFlqth/GrYHeMtqlTzUMBVcvwmG6PFETYcp7wAxY5NH3ms5YNUhKPzE01U7OTnsc7lPlXTCyjXzL0FXgS2Rn96Kk9ugLYG1Bqx4qTkAMPnzX/+maW7gSiOzLkLBXlsRVHadVfuQF1i41aMHx0JFuxNSoiKDhk5QYBSuUb4sbdaqMvil4A7Ke2ZMfjBwRM/lUmC4raKMFP5Ws1Pv6EOGYpsrcjJEyHbnrUibf5+QDTOgitpmJJ73NaBcjdb0EioX6zDCW0PdkEVpnYAcvNJkgMOidjGyLy+THVveqq3q59Mi+qEC45d85D9OKVqMysC4al0zZOUC/6wvGoiHp99eY4HaO4UCpr88Ln+hyXczOq1yMQk6zdWkEXS2EXj4B/vp6EV8GXa1rh7sO69IGoUQrqmpDeGdZxzc1VfNypKCx6eFcjK9+8/t+uBVpwr5tuH4eJ7HIPCHheP43sV65cwarxbe1MwXF+8kLufIV/mEJ8JLruXzLZ/kGyfBo6YDkL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(83380400001)(31686004)(31696002)(2906002)(38100700002)(966005)(6506007)(6666004)(107886003)(30864003)(6486002)(478600001)(36756003)(86362001)(186003)(26005)(6512007)(53546011)(2616005)(4326008)(66556008)(8936002)(8676002)(66946007)(316002)(110136005)(54906003)(66476007)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGo0SGk5QjBoMFRocXNWWFZlQlhOY0tPYnZmOFFlanZONGZQTVdLM1lLWEgx?=
 =?utf-8?B?bkJsUEw0cWFxejRPNW1OekNlcFZ1VUltdGFXa2VCVStQQ2s4WXVkc2tQWi8r?=
 =?utf-8?B?eWJQVDRGNDdhbWNPOEcxb2VNbm1FMzBjZE1EbE56UllYSVV0SFlwU3BwWXpv?=
 =?utf-8?B?bFRGbUdvbG9FTEduM3ZqT1VXMTczV3lSMDNSa1FDZjJtS21SZEk4TzhVZ1U5?=
 =?utf-8?B?Ri8rdzE4R1dsT2tqNVBjVHhQdjJ3OUQzL1o0TVdUNE82R0dEanRCem5YWjk3?=
 =?utf-8?B?OGNCWGtQWWVMRTlOYXdqeWFOc1JZd3FDS3JxSitXaEZTVlkwdjZlRDBjMGZw?=
 =?utf-8?B?VTRFRDZ1alpjZldHNm93OWtPTHNjTjJBUmdBTWU1SXIyL2tDQ3RRdGlDMmZp?=
 =?utf-8?B?SitKakV1ZzlYUU5PRnZIdVQvKzQ0Nk9hNVF6aUJCcUZjQ0pYWU9ER2pGakw0?=
 =?utf-8?B?d3hRQkJLS0JuZnFJLzBPVVJ6cGQ5a0F4MmJHL0dwU2ZjdUo3ZmF3VHpGRkNH?=
 =?utf-8?B?NU1NT29kM3FzZ2NOdXV2cEpOeEE5bVpjREYvSW9ZbnFRRU9Fc0crUXA0b2lt?=
 =?utf-8?B?dnRRc3p3NVFXWXVPSW8zOVo3K1ZJVGhZSlVYemUrSlV4MDI5cGlhL2ZlSFBo?=
 =?utf-8?B?ZGtzUWdkQ2RBUGlWUW81czNpMzdyZHBqdnNqNEtrOWlvS2pwWXl5OWd5Z2FQ?=
 =?utf-8?B?VHRqZEh1aWNZZjY4YlFvalZob2ZEc0RodTFPS2FJWTd1aWNFTFovK0FiVGdt?=
 =?utf-8?B?YkszaDloWFRDNWs2MkF4Qk9pb1BMWFhIUVROaElDTzh5K0F6UGl6Q3pvRFVl?=
 =?utf-8?B?a1M1VVh1WGJrRlE0T1ZudDZIMzU5bnJaUnZzYU9nRUhRSDdQWURTdWZZZWxm?=
 =?utf-8?B?c0ZralUwRW9RQXFaZVZGR1lFdGdTTUxzdGpnSE1zRWZHWXNVT2ppd052cUlr?=
 =?utf-8?B?eGFneGhaaWpQMlhneTJqbWRkOWpkMmlsYmZHclo3eUp1NGZXV3ZBb1JVWWRq?=
 =?utf-8?B?MnJmelVZeFJEQTJWQnlYcEFsMy9pNG1yRkE1dWlnYlBrQm1ubHg0b2NVdnZG?=
 =?utf-8?B?cjQ3WkhNa21aUWtrZmNoMEFVU3dRTzlzeXEySDg1anZFcGNiRlJWYmFMMWZy?=
 =?utf-8?B?dHBlWExQOUVYSVBXQ25ERVlDWmQ1TmY1NWhBaUhUaVpvSUMzSXl3OWpTOUh3?=
 =?utf-8?B?VDdKNkhSaHd0UWJjQ2gwUlcyMTFlTlZWb1l4YmViNHB4OHgvaVVuc2EzZjFy?=
 =?utf-8?B?WDUwajlhL1VUNm5lRGxuOWJHQ25sc3RmM1dmZmtjSUc0MFRkSHBGVFhlVHBL?=
 =?utf-8?B?TE02RHVVQW1uenhOUUFxQW9lOEFOU29SSGJYMVJRZFY0ajQyTklBamdNbWFz?=
 =?utf-8?B?RDNKdklUdDhhUzI3cXo5TTVzdXQ1NEdSOWtRUmw0N3V5TGdhUHFUQ3FhdG5D?=
 =?utf-8?B?ckxSRFp6ejJ5bnhQaTZiQngwaGpZdHRUNGlkWTJwTnVjbHMweHA1d0p0SnVO?=
 =?utf-8?B?NGdnUXE3a0h2V2RUZFQ1RUZ3OWZCMC9GZisxdjF4TTE3dzd1cTZDVnR0TS9Y?=
 =?utf-8?B?YkpFaS80Rm1OanNsL2sxT0p0L1kwVFJzKzUyMjVDd0hySXBxdEJmVnZmL0U4?=
 =?utf-8?B?b3JwanptKzl0M3M4ZFQ5UmZYUm1OZ0JtOGI5MGVmR3pTUG44b3JXbERadFhV?=
 =?utf-8?B?czA3VUlPRFkxVC91RFVuTGU0TnBOOTRUKzlJdCtBZzZlWXowcVpnbXFrbUFI?=
 =?utf-8?B?Z0JUQkU1Zmpqb1RlL2I1ZHZXeVB4a2hlTy8zMmp3czdCV1hkbVBNbkFtOFFo?=
 =?utf-8?B?N2JkaVhscWZEbWliWmdSblZ3N09PTTBOSkwxUjNVYlkwVDc3cXZQeVZ3aXpy?=
 =?utf-8?B?M1NEOVNLOGRQcDhQdGUvVHpWZ0JXRnd0dzhJc3NBTmJRZDNHTURldmc2ZjVF?=
 =?utf-8?B?NzN3bXVyOE9saUlTV25oeU9odk5CY1RKaCsyNldtUzBmS3MrRUY1clc1ZFRk?=
 =?utf-8?B?bTZHOWRMYmpiWDBWVk1tdUpNYTB6QUhCMFVIQXhMalpZU21vVkdWT25BWThv?=
 =?utf-8?B?WS9FandRZG1qUWd5dzlHZ2FJUS9qdktEYmppMitTdVpacnYybzNIZzFpNzRU?=
 =?utf-8?Q?TV6BqhB0t/FTt9Bh1PDPaaaPz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2518f3c1-653e-4263-258f-08dabda01cef
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 13:34:20.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JofHdxZkFLi/pb6aiPjOyztPkGzIXy6eNbGw7VzKVTu4IspoK/xXJv2Z/2e/xT/l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4074
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2022 23:32, Eric Dumazet wrote:
> We had one syzbot report [1] in syzbot queue for a while.
> I was waiting for more occurrences and/or a repro but
> Dmitry Vyukov spotted the issue right away.
>
> <quoting Dmitry>
> qdisc_graft() drops reference to qdisc in notify_and_destroy
> while it's still assigned to dev->qdisc
> </quoting>
>
> Indeed, RCU rules are clear when replacing a data structure.
> The visible pointer (dev->qdisc in this case) must be updated
> to the new object _before_ RCU grace period is started
> (qdisc_put(old) in this case).
>
> [1]
> BUG: KASAN: use-after-free in __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
> Read of size 4 at addr ffff88802065e038 by task syz-executor.4/21027
>
> CPU: 0 PID: 21027 Comm: syz-executor.4 Not tainted 6.0.0-rc3-syzkaller-00363-g7726d4c3e60b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:317 [inline]
> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
> __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
> __tcf_qdisc_find net/sched/cls_api.c:1051 [inline]
> tc_new_tfilter+0x34f/0x2200 net/sched/cls_api.c:2018
> rtnetlink_rcv_msg+0x955/0xca0 net/core/rtnetlink.c:6081
> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg+0xcf/0x120 net/socket.c:734
> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f5efaa89279
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5efbc31168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f5efab9bf80 RCX: 00007f5efaa89279
> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000005
> RBP: 00007f5efaae32e9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5efb0cfb1f R14: 00007f5efbc31300 R15: 0000000000022000
> </TASK>
>
> Allocated by task 21027:
> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> kasan_set_track mm/kasan/common.c:45 [inline]
> set_alloc_info mm/kasan/common.c:437 [inline]
> ____kasan_kmalloc mm/kasan/common.c:516 [inline]
> ____kasan_kmalloc mm/kasan/common.c:475 [inline]
> __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
> kmalloc_node include/linux/slab.h:623 [inline]
> kzalloc_node include/linux/slab.h:744 [inline]
> qdisc_alloc+0xb0/0xc50 net/sched/sch_generic.c:938
> qdisc_create_dflt+0x71/0x4a0 net/sched/sch_generic.c:997
> attach_one_default_qdisc net/sched/sch_generic.c:1152 [inline]
> netdev_for_each_tx_queue include/linux/netdevice.h:2437 [inline]
> attach_default_qdiscs net/sched/sch_generic.c:1170 [inline]
> dev_activate+0x760/0xcd0 net/sched/sch_generic.c:1229
> __dev_open+0x393/0x4d0 net/core/dev.c:1441
> __dev_change_flags+0x583/0x750 net/core/dev.c:8556
> rtnl_configure_link+0xee/0x240 net/core/rtnetlink.c:3189
> rtnl_newlink_create net/core/rtnetlink.c:3371 [inline]
> __rtnl_newlink+0x10b8/0x17e0 net/core/rtnetlink.c:3580
> rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg+0xcf/0x120 net/socket.c:734
> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Freed by task 21020:
> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> kasan_set_track+0x21/0x30 mm/kasan/common.c:45
> kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
> ____kasan_slab_free mm/kasan/common.c:367 [inline]
> ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
> kasan_slab_free include/linux/kasan.h:200 [inline]
> slab_free_hook mm/slub.c:1754 [inline]
> slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
> slab_free mm/slub.c:3534 [inline]
> kfree+0xe2/0x580 mm/slub.c:4562
> rcu_do_batch kernel/rcu/tree.c:2245 [inline]
> rcu_core+0x7b5/0x1890 kernel/rcu/tree.c:2505
> __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
>
> Last potentially related work creation:
> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
> call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
> qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1083
> notify_and_destroy net/sched/sch_api.c:1012 [inline]
> qdisc_graft+0xeb1/0x1270 net/sched/sch_api.c:1084
> tc_modify_qdisc+0xbb7/0x1a00 net/sched/sch_api.c:1671
> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg+0xcf/0x120 net/socket.c:734
> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Second to last potentially related work creation:
> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
> kvfree_call_rcu+0x74/0x940 kernel/rcu/tree.c:3322
> neigh_destroy+0x431/0x630 net/core/neighbour.c:912
> neigh_release include/net/neighbour.h:454 [inline]
> neigh_cleanup_and_release+0x1f8/0x330 net/core/neighbour.c:103
> neigh_del net/core/neighbour.c:225 [inline]
> neigh_remove_one+0x37d/0x460 net/core/neighbour.c:246
> neigh_forced_gc net/core/neighbour.c:276 [inline]
> neigh_alloc net/core/neighbour.c:447 [inline]
> ___neigh_create+0x18b5/0x29a0 net/core/neighbour.c:642
> ip6_finish_output2+0xfb8/0x1520 net/ipv6/ip6_output.c:125
> __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
> ip6_finish_output+0x690/0x1160 net/ipv6/ip6_output.c:206
> NF_HOOK_COND include/linux/netfilter.h:296 [inline]
> ip6_output+0x1ed/0x540 net/ipv6/ip6_output.c:227
> dst_output include/net/dst.h:451 [inline]
> NF_HOOK include/linux/netfilter.h:307 [inline]
> NF_HOOK include/linux/netfilter.h:301 [inline]
> mld_sendpack+0xa09/0xe70 net/ipv6/mcast.c:1820
> mld_send_cr net/ipv6/mcast.c:2121 [inline]
> mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2653
> process_one_work+0x991/0x1610 kernel/workqueue.c:2289
> worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> kthread+0x2e4/0x3a0 kernel/kthread.c:376
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>
> The buggy address belongs to the object at ffff88802065e000
> which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 56 bytes inside of
> 1024-byte region [ffff88802065e000, ffff88802065e400)
>
> The buggy address belongs to the physical page:
> page:ffffea0000819600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20658
> head:ffffea0000819600 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888011841dc0
> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3523, tgid 3523 (sshd), ts 41495190986, free_ts 41417713212
> prep_new_page mm/page_alloc.c:2532 [inline]
> get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
> __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
> alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
> alloc_slab_page mm/slub.c:1824 [inline]
> allocate_slab+0x27e/0x3d0 mm/slub.c:1969
> new_slab mm/slub.c:2029 [inline]
> ___slab_alloc+0x7f1/0xe10 mm/slub.c:3031
> __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
> slab_alloc_node mm/slub.c:3209 [inline]
> __kmalloc_node_track_caller+0x2f2/0x380 mm/slub.c:4955
> kmalloc_reserve net/core/skbuff.c:358 [inline]
> __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:430
> alloc_skb_fclone include/linux/skbuff.h:1307 [inline]
> tcp_stream_alloc_skb+0x38/0x580 net/ipv4/tcp.c:861
> tcp_sendmsg_locked+0xc36/0x2f80 net/ipv4/tcp.c:1325
> tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1483
> inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg+0xcf/0x120 net/socket.c:734
> sock_write_iter+0x291/0x3d0 net/socket.c:1108
> call_write_iter include/linux/fs.h:2187 [inline]
> new_sync_write fs/read_write.c:491 [inline]
> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
> ksys_write+0x1e8/0x250 fs/read_write.c:631
> page last free stack trace:
> reset_page_owner include/linux/page_owner.h:24 [inline]
> free_pages_prepare mm/page_alloc.c:1449 [inline]
> free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
> free_unref_page_prepare mm/page_alloc.c:3380 [inline]
> free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
> __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2548
> qlink_free mm/kasan/quarantine.c:168 [inline]
> qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
> kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
> __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
> kasan_slab_alloc include/linux/kasan.h:224 [inline]
> slab_post_alloc_hook mm/slab.h:727 [inline]
> slab_alloc_node mm/slub.c:3243 [inline]
> slab_alloc mm/slub.c:3251 [inline]
> __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
> kmem_cache_alloc+0x267/0x3b0 mm/slub.c:3268
> kmem_cache_zalloc include/linux/slab.h:723 [inline]
> alloc_buffer_head+0x20/0x140 fs/buffer.c:2974
> alloc_page_buffers+0x280/0x790 fs/buffer.c:829
> create_empty_buffers+0x2c/0xee0 fs/buffer.c:1558
> ext4_block_write_begin+0x1004/0x1530 fs/ext4/inode.c:1074
> ext4_da_write_begin+0x422/0xae0 fs/ext4/inode.c:2996
> generic_perform_write+0x246/0x560 mm/filemap.c:3738
> ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:270
> ext4_file_write_iter+0x44a/0x1660 fs/ext4/file.c:679
> call_write_iter include/linux/fs.h:2187 [inline]
> new_sync_write fs/read_write.c:491 [inline]
> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>
> Fixes: af356afa010f ("net_sched: reintroduce dev->qdisc for use by sch_api")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/sched/sch_api.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index c98af0ada706efee202a20a6bfb6f2b984106f45..4a27dfb1ba0faab3692a82969fb8b78768742779 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1099,12 +1099,13 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>  
>  skip:
>  		if (!ingress) {
> -			notify_and_destroy(net, skb, n, classid,
> -					   rtnl_dereference(dev->qdisc), new);
> +			old = rtnl_dereference(dev->qdisc);
>  			if (new && !new->ops->attach)
>  				qdisc_refcount_inc(new);
>  			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
>  
> +			notify_and_destroy(net, skb, n, classid, old, new);
> +
>  			if (new && new->ops->attach)
>  				new->ops->attach(new);
>  		} else {

Hi Eric,
We started seeing the following WARN_ON happening on htb destroy
following your patch:
https://elixir.bootlin.com/linux/v6.1-rc3/source/net/sched/sch_htb.c#L1561

Anything comes to mind?
I can provide the exact shell commands and more info if needed.

Thanks
