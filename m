Return-Path: <netdev+bounces-1348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2CC6FD8CC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50E521C20CAF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2A26AB1;
	Wed, 10 May 2023 08:01:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C742597
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:01:08 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2110.outbound.protection.outlook.com [40.107.243.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B314FF0
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:01:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZkcgzn4N6fd+ydicp0YnI7sK1z5w5pNwUM3YkqByJsp/HWpYaqRjPLG6dXXs7s0w/gG7bj7puSg/on0LfikDzAOExdykSkf5ggg2t934y11yi2FW3SfOJj/c6ey0JRdbwohKMefBevzka337hPkE7XCq13hgrcgoCXpSCsgpPQWH6mDfl8SJ1sWmsxqj4XoDWIUF3pC7VKM0hcB2ZYfLpiFWOBTOOaLwZZiogxwMZTxSRYjeIgLfe6jFUfzOSCry66NnLOqYq+EjBGgcevZrwtMgbeboqGqKxdMD8lcqOOxaTybbgWwDDSPjy6tAi7/FPdMd5PC1GF0INtTvn3xQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8c4fiqkqA50IXCcx/sS59YmUHZ0BkV2wCyqqcS47zI=;
 b=nocTEmKKBz5qpOiEgqmOrNFRflz+veazyK9HYBL9LmsuT44Kowy+/01lHleDQm5CNJviaVQ2wJZRhqENXjgR6NRGSw1TmsrNXrc60xfKrTDkdb5CchOZhIg9jedYoUbjtHROa+16qkEkYmhk04FWTiTxZlT+R9BvzCjFsMbhgRoFKruOPjldyi+pk5ituXxvXtYjhMsqj9Y8achieW/OKvcRmFSKjK9xlwYQF9HSku+j0flH0lZmAR6Trdeys96y/svPybWUkACzbMdZihws4wuL7calFYt35jEo9M9mO88bx+aIciU2obtwofsleQvlveq9k5hWWjFPymVFbQra3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8c4fiqkqA50IXCcx/sS59YmUHZ0BkV2wCyqqcS47zI=;
 b=FkKrWbWDnSqyMz7xWBsxgDUOJtr4NGW50F56uOEw+D2MT3FMDLUy2qgXXGEMls1zxQ/ojuV+LO4U7gsRfhqvf/79dUnsvVeQ6UiRrTeEWFeomcD8CV8UpOYDYby7AYqL+BO/LjIq1MSKM1q0nfduSvDrdSmCuiJnNfPS86/BTj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6122.namprd13.prod.outlook.com (2603:10b6:a03:4eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 08:01:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 08:01:02 +0000
Date: Wed, 10 May 2023 10:00:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	syzbot <syzkaller@googlegroups.com>,
	Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] net: add vlan_get_protocol_and_depth() helper
Message-ID: <ZFtPOCEPoW1NsGHN@corigine.com>
References: <20230509131857.2947439-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230509131857.2947439-1-edumazet@google.com>
X-ClientProxiedBy: AM0PR01CA0136.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: c88d57a7-f0ed-4d3f-787b-08db512cb2e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kqz1MYJKkSNc+hfXgJ6TEzpnyAYek/gljFnLeNMJLsjDC222Ts2cZIPo62jv3Oxu24AjmA2ODJapo7E+EOEkcA7W14HESXzzXjZ/yGdmEzEU0rV2SDKFSXTZ38pT05tg69k8vvJk/ghbt9QgVptVahyBIzUnYUEovgmv2GHLnnYvFUYDkTHr0zLPZYbvfcBeXH9ZdYJ70EwiwZ0kZBtB5F2ADl91bcs5Ifu5HgHDc3cph1VNIzjaFhyt6wM5NmGwofm05OEOPQhpmROZKrUquqfS3ZHIU8BkGq+FrUre3Q37ar5P46XmvonnWpTMhNmXbuDWTGMD/mGr2UpaaknRKVCtwxbui0fbxG9lC4XHWkXiDqco2FlHukGVU/TmcK3VR8u39omWRF048ZPincbty5rm6TzxypJYlXu//Gwg/MvaCJmbpsh/cYSjNUxQzflaBF6a/4Utx8C4iQngFPfHDf3KCTzg3ziJu4/dCc9tRg3yq42akGm1ltPhdoV9qg/MwBEgguwUwu3jk1dEYBUzKuSBKdn7GtjX6DL/Lst99JDAfC2UnBAkY4yC5q4L2BrnAiZsOVbc8YyBV2wAO5oPDzmihbGo2BM8HMRU7judPkQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199021)(6506007)(6512007)(6486002)(66574015)(83380400001)(36756003)(2616005)(38100700002)(86362001)(186003)(44832011)(54906003)(316002)(8676002)(8936002)(41300700001)(478600001)(4326008)(5660300002)(66476007)(66556008)(66946007)(6916009)(6666004)(2906002)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2VvOWJGeWJxcStnNStIWWhTYTg0OUdCSFo3V2ZDbDd0Q1BEMUpFb0x3U0lB?=
 =?utf-8?B?elBHTG14SUJVK0JHeERUZFdnc3g0QVhBRnN5a0lrc1EyaDR4R082NVBwdk4z?=
 =?utf-8?B?UllCaGlSVk5lMXl3NjY4NzlJYWo0MDJlT3h0RDExL3YxRi9qeE4xSXgvT0Fz?=
 =?utf-8?B?RmxCQys1UkpyTnpuUy9KR1VybXRGYmNoY1BBZlRuTnhMazVYZ25Fb1VsM2RM?=
 =?utf-8?B?Mkd5WUpXY3RzRHowcElTRUo2bHgrMUx3VGJrd1kwR1hER1hhY3JaSXVyS21T?=
 =?utf-8?B?MWxsMkc3VjZKUnJlVitPdDhoUVNreTFCUURKck9mSlR0S0xUMEM2NExqNXNS?=
 =?utf-8?B?c0VYdzFiVFczbmZRRDhJZTJmV09KcFRvWHNYWFdBRTFCdks4bXNPSFc5ODBM?=
 =?utf-8?B?RElmR3B5WUJzemx3NUZobGVXcUU2RWxzWkpJQVF5L3JiZjUveGpsS1ljaUJ3?=
 =?utf-8?B?byt4a29kY0ZlWjJGb1lKd3hIWVQ2dHlMYUxpRGNNN1R3SnhNajNoeW9yWEZ3?=
 =?utf-8?B?dEV3aVd1V0J1UE9qMkNmZUpoR1JDUnN4WHlNOXNtVDNJdzlmSDRQSytxa0Vv?=
 =?utf-8?B?NEZjMEpucW5LU2dZazFhMUw0TytxLzM5dXd0VUQ0UTZYUkd0RGN1cEhad2kz?=
 =?utf-8?B?TURIdGxPYW5Lajl4SWJ4dDZEcDBmZmpDU1lNQW96Q1FSbWNOM0ZuNjBGcjBR?=
 =?utf-8?B?UGJnZk5oMU9DNGN4NDIxTkdmcW40REk4R2F1Mlo4dUhaZUhHdTUrMWJ3QU9u?=
 =?utf-8?B?NUJaZTA0Z3V0SXRtcmVjUy9ETGlRK3hORVAxKzJPV0RSRytUdVlQanBQbnpL?=
 =?utf-8?B?NzdIdkJyL1BkWWlVbnR1WWZiVUpVR2M0UlZadzBlMHVDSWcvcDAzVTlqekpw?=
 =?utf-8?B?T2lUSWk2dVpFZGgweENtMmVybWVGMUVkNG45Vk81VDlZc2lVWGpvWjBQdi9q?=
 =?utf-8?B?MEJWV2I2NVVmMnZkQWxBVGhOQ3BXRTZHVEE4bDJGRU9CZ3hDOC9CUnE4SkJE?=
 =?utf-8?B?U2YwejAxdEhpWUpVMEpic2Y5K2k0NDNqc1d0YUVYTzBtNmxRN2dST09tMVc2?=
 =?utf-8?B?ZE12QlI1cDFiL3ltN1UzMy9ST3NMZlB3TERkSjQvYjM0MjNPejJjdXY0UXVz?=
 =?utf-8?B?WHpSdUdPQzNFQ1Z5M0NsUGpNZ1owTGpOTjJURXdyTnMxU2cyeW1oeExWNUl5?=
 =?utf-8?B?ajdVc2syc2NUbzBna1ZUcTE1aGFPaERiNnFUUzJBU0ZpbkU2blUvVjRBRnlR?=
 =?utf-8?B?NFZxVW9iZGdkRC9WSGpVc0FmV285ZUMwb0pRR2pZRjRHV05qQklrZkdCWjc2?=
 =?utf-8?B?azBKVnR1dlpzNXBvZzNKbDJaUFdQOUVZTnNUUm5aQTVmRlRnZFUzb3laakxs?=
 =?utf-8?B?eVJvODF4VkZ6clZKTi9NemtEYy9OTGtUTGplWFpTdnl5eVdKYTRyMHJEVXpo?=
 =?utf-8?B?amF2cUYyd3llck9LOWZoWWxkeWtGbnJnNnZ3ZXpiY1JzTEFhQTg5c08vSCtR?=
 =?utf-8?B?MnNXRHdoaCtZYnNXYk1KMXNvd1lPbEJBNlgvNnZzNCt0dFdmdGptSEYwQzF0?=
 =?utf-8?B?K3YyNmowdFNnczBNM0JQbTZpSitxS1FtdkZiNlUzdXFsZmVnOXpvbXl3UWdY?=
 =?utf-8?B?bGppSUlRR1htV3VMUFRJaXpDNlBjbERSQWRwZ0ZtN1hHTDNBMDZIUVo4RDdG?=
 =?utf-8?B?OWRJRUNGZnE5cWNWeXBRTXVBQmZTTVVLUVVRQkFYR291Ty81Mnp2V08wczhX?=
 =?utf-8?B?ei8wQ0lLQlRGczVrbHl3NXB5S3F5Qi9HbW1HMzhhMU5Uc0hYeEhOb0Rkaysv?=
 =?utf-8?B?VForV1hndHZDNFJLdlVrTUk2THppQzFBTUJDOCttZjhHa3RXelE3ZGhVSVkr?=
 =?utf-8?B?UVBDM2ZMbW02RUN2bjFscmM2UldXUy81SzRJdVdNcmhqOWlnQjkwMFg0ZVdj?=
 =?utf-8?B?NkJLbG5UZzJLZ0dJa0NTTlc2azA2d0RLRUFsc1lrTUNuSytCR1pNK0gvcldq?=
 =?utf-8?B?b3NjZ2NhYUtFNlhyQmVFbUpUaU1jZ3N1aU9wb2s2cHRickgycWhzZVVoUENT?=
 =?utf-8?B?ZjlhUStBT0tQTG1qMmVac2kvZjNzQjk3VktCMEJ5Y2UzUVMyVUk1dVRTMVZz?=
 =?utf-8?B?ai8ybnFGb00rOWhOMFdjOGcxRkl1RFRCT0lkbDhzT1oxUDc0RU0xckxLMFlO?=
 =?utf-8?B?OHUyTSt3UzRQdE01S2J0dElSRVhQODQ1TXgwRkhKbkN4K05pN3VGRXpUbFBJ?=
 =?utf-8?B?ZllLQzRYenVBZndCd1R0eTZQTmR3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c88d57a7-f0ed-4d3f-787b-08db512cb2e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:01:02.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSjuann3Ru15lfoffiljGKms584klyQp2NPBaAViP/kh/rg3A4kjFTwixllcnRzugYQlllplzD2Y3YZVDw98twgGu8YX9zxO68Diz/I/Rhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6122
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 01:18:57PM +0000, Eric Dumazet wrote:
> Before blamed commit, pskb_may_pull() was used instead
> of skb_header_pointer() in __vlan_get_protocol() and friends.
> 
> Few callers depended on skb->head being populated with MAC header,
> syzbot caught one of them (skb_mac_gso_segment())
> 
> Add vlan_get_protocol_and_depth() to make the intent clearer
> and use it where sensible.
> 
> This is a more generic fix than commit e9d3f80935b6
> ("net/af_packet: make sure to pull mac header") which was
> dealing with a similar issue.
> 
> kernel BUG at include/linux/skbuff.h:2655 !
> invalid opcode: 0000 [#1] SMP KASAN
> CPU: 0 PID: 1441 Comm: syz-executor199 Not tainted 6.1.24-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
> RIP: 0010:__skb_pull include/linux/skbuff.h:2655 [inline]
> RIP: 0010:skb_mac_gso_segment+0x68f/0x6a0 net/core/gro.c:136
> Code: fd 48 8b 5c 24 10 44 89 6b 70 48 c7 c7 c0 ae 0d 86 44 89 e6 e8 a1 91 d0 00 48 c7 c7 00 af 0d 86 48 89 de 31 d2 e8 d1 4a e9 ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
> RSP: 0018:ffffc90001bd7520 EFLAGS: 00010286
> RAX: ffffffff8469736a RBX: ffff88810f31dac0 RCX: ffff888115a18b00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90001bd75e8 R08: ffffffff84697183 R09: fffff5200037adf9
> R10: 0000000000000000 R11: dffffc0000000001 R12: 0000000000000012
> R13: 000000000000fee5 R14: 0000000000005865 R15: 000000000000fed7
> FS: 000055555633f300(0000) GS:ffff8881f6a00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000000 CR3: 0000000116fea000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> [<ffffffff847018dd>] __skb_gso_segment+0x32d/0x4c0 net/core/dev.c:3419
> [<ffffffff8470398a>] skb_gso_segment include/linux/netdevice.h:4819 [inline]
> [<ffffffff8470398a>] validate_xmit_skb+0x3aa/0xee0 net/core/dev.c:3725
> [<ffffffff84707042>] __dev_queue_xmit+0x1332/0x3300 net/core/dev.c:4313
> [<ffffffff851a9ec7>] dev_queue_xmit+0x17/0x20 include/linux/netdevice.h:3029
> [<ffffffff851b4a82>] packet_snd net/packet/af_packet.c:3111 [inline]
> [<ffffffff851b4a82>] packet_sendmsg+0x49d2/0x6470 net/packet/af_packet.c:3142
> [<ffffffff84669a12>] sock_sendmsg_nosec net/socket.c:716 [inline]
> [<ffffffff84669a12>] sock_sendmsg net/socket.c:736 [inline]
> [<ffffffff84669a12>] __sys_sendto+0x472/0x5f0 net/socket.c:2139
> [<ffffffff84669c75>] __do_sys_sendto net/socket.c:2151 [inline]
> [<ffffffff84669c75>] __se_sys_sendto net/socket.c:2147 [inline]
> [<ffffffff84669c75>] __x64_sys_sendto+0xe5/0x100 net/socket.c:2147
> [<ffffffff8551d40f>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> [<ffffffff8551d40f>] do_syscall_64+0x2f/0x50 arch/x86/entry/common.c:80
> [<ffffffff85600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: 469aceddfa3e ("vlan: consolidate VLAN parsing code and limit max parsing depth")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


