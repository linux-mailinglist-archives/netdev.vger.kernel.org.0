Return-Path: <netdev+bounces-3705-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B941708624
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:42:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34FB4281A02
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D645209B6;
	Thu, 18 May 2023 16:42:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E6223C70
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:42:23 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2079F5;
	Thu, 18 May 2023 09:42:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxaoLHfv9x3d8RuDRjCelsrbCTBy6oFAeKGm1EV3mvhSDSHwPcPboV4h/JNM/ZhXu24QfV0Pk9kNu+xHrD3j0ffL7RXoOdyTCMV4ZIdSJQjCLODoGOaagA/E8v06B+ZcAFT+dnmX094TTwp6CG/3MHfH4ZnyRD63gAKl7aTKgg1aGVssxGZwf9dY7/TNG8UBqsOjF9qywMoq9KMJ5qLLdf3ObVTeu991M30LcfDF8R1KQZizSaYyRXN0rAcBlt/S1YF4iDvy9dIgA0lKk430BrKv3dzEX0LcKWe9/7WtnFePG59dyv7b1wdEg3ocJ60Bl72fLV3+Fr3KWxMrP55fUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6AC67PE9Rn95sNol8qsPQ695tw5/b0/kKwiRAgarMw=;
 b=naGTl9LVeVNtyoSMNzPMWH2mDwNeN0C6yHMTdjkpaNP2G/WYm9FuOx+DZzWZy2myWhhmBvE3YZ+a8gNOWbq/CJ2ZMegXKAB71eI9KEUujhthwq/R584QRQdx5hfqOTLZX6g0A+HKba5Eyqv4aYstaj2n05caFHlvxxcdEwsO55eWEWvTsw4NhSMUsXJEoFJne+mecJZEdBjTIL/bLNEbp+OGju3XW78ddr9xygGVz9bV2IN73PtEK0MCYlduWt4Q7k06UMD9RRXITEFYccDN39QWm64fbYIhijMeA3ZhMizRLi1En7ma+g4A7vdXfPkxyE0oLmP4uXDUdrY/zgqzDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6AC67PE9Rn95sNol8qsPQ695tw5/b0/kKwiRAgarMw=;
 b=M7wrKNXmfKfATm4faHM3KyHYClEjJA1b42PeiRQFL+5Lm4F1nwZFI2vFcP5o6z5JhDnMsmtjeal6x/ElNxOTvMQHoo9l1nsLIRcmF06NwdyovwmVOt6SJfj4o1RV076gee6SKpIVgRMJknvwet56UYNOoQHYGbV+pOyu/EZS6bA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5600.namprd13.prod.outlook.com (2603:10b6:a03:426::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 16:42:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 16:42:18 +0000
Date: Thu, 18 May 2023 18:42:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: bjorn@mork.no, joneslee@google.com, oliver@neukum.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+9f575a1f15fc0c01ed69@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: cdc_ncm: Deal with too low values of dwNtbOutMaxSize
Message-ID: <ZGZVYx3k77Z3/9YQ@corigine.com>
References: <87wnklivun.fsf@miraculix.mork.no>
 <20230517133808.1873695-1-tudor.ambarus@linaro.org>
 <20230517133808.1873695-2-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517133808.1873695-2-tudor.ambarus@linaro.org>
X-ClientProxiedBy: AS4PR10CA0016.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: 7801ac4d-a1da-4421-2c20-08db57bed7d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7vohQAyV/IfpJEaEkLwwd6zm2+Td8HUekMPIE1Nvg3Fzz6ePKwNOnDl3TD1jB3rhP0vvPfLKnxYIAWE1hftIKNAgfj1KRQdx2Ks41Wv/D6m+ToWNtSszHtvuqpnU9umEY5dLRNYAIe3k1W+w+kxpR1H5JtZWGMy093ps3KLx+NRwb77olD302HyCnWxzVWBGrOSE8zayni5EPLyLowPrY9ehdW1ORCc6CmYBPK4jfzphBP7sIExIfZIEzelqUwRSP+VZvYAXgxXr+pjPy+btsDhY+vx4ZmuptyrTku/aPqoopTz2zuJfFkRtNc9AK1BkRMlFdyT308f+XA6zILfMqljOymjsKFraefJYo0BUjck2m93qQM0/9/KxXRU0nG53U3pQU2XiSDTdjqwcigOOCTpCrYw0eIBKxuopge3dx/Az+9KAoYa17u/nSVg1xA4by983tmtIeRnhOzQbTdti/7qJi000oYGbzAr+aClRq5/QbC4n4ZPq3KCScqHvCl7IcyBdH/ENRvBX4SUYpco1HBgbozhBoutCDdfTIlSs3Mdb/Pp4jqaUNCO2mx3NEV8JUoR97wgoouz9PR7LXHfXmB93Uj3BmwhpQC2Sd+YYuseKy5o+pby/SobH+BQx6Ah6R4ZRpYRy+tQnnBrWENe+pw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39840400004)(376002)(346002)(366004)(451199021)(66556008)(66476007)(66946007)(4326008)(6916009)(8676002)(8936002)(966005)(316002)(478600001)(66899021)(6666004)(41300700001)(6486002)(2906002)(86362001)(6512007)(6506007)(36756003)(7416002)(44832011)(38100700002)(5660300002)(2616005)(186003)(145543001)(145603002)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZYH+QmPyu2eESwpYGCocdtXDx0L2fQix2N9LZRGIbVoYAFklH1XgCdsbCZGl?=
 =?us-ascii?Q?fWOVy1nMPAsYOr/uYJ5COJoP0whCPkXahy62r7FNA3c0JGVKHoyCZbM8nx7r?=
 =?us-ascii?Q?f16UbXj1wUqH/xnRow/tsFi1MqeaOx+ygR992t6+GhzCZxmDK34ULlzYIPtr?=
 =?us-ascii?Q?MbH8LM1whJo+ub7AxhnhSU7p4xKpJcH0OcX6AjcoTmJDsPLZ2McdYF5elLdS?=
 =?us-ascii?Q?rr5KGNQEP46Vef5dCrYRLiruI1Pwr23K3ga4wPXDPQ+V+rVePp/l4hMr4b2n?=
 =?us-ascii?Q?aYB6eZqMAYUXwQpsy4qMRIiXMomPNN+NsnLsE2X54oNYGuIN6O9dMP6qwrnA?=
 =?us-ascii?Q?9i7f7EsWEa4GIwR/bMame9YjNVRHSd7z+1OARtKdtJK3WVb01yU8MmR2ddGK?=
 =?us-ascii?Q?JbGlFjG00xlQhMCsGmWtDDc+qMXUuVvt1S32IHSvpONmpgpHA7naOBm1Ojj+?=
 =?us-ascii?Q?ZVcOJaRFQgap48L2+IAJMyI6e8ZgYvG72LENiTbzRyG7pHVRMRKdSDyx1vg2?=
 =?us-ascii?Q?OJwgwvZsFFNhaMC14EmbKfiukXb9tOfhNZDYzq1OWm/+N2S4GQqAdzwIB3uN?=
 =?us-ascii?Q?QIlRA8Jj0WHjXsT0yU31CGaZFc3Fyif32rGnVfZ4GPI6xZ927kuHrsQ6wE8H?=
 =?us-ascii?Q?sL1JYtvI283MuIE94NNadO+pmJB6OEeyfPaL1wQSCK6hjSerZpLo6ly0jk9Q?=
 =?us-ascii?Q?BQQ7b0dRl+Pmk1vfIhVLYoJ7d3PNg0n7t5B5gq1FCs/yy3MzHrWlUbnJ1h84?=
 =?us-ascii?Q?GhPDUwSo5nwxHsItXH+fEwzgH+0wC/HDNWpE9CDOJJb56AuE/mpbhVr2s5u9?=
 =?us-ascii?Q?at7qhYvD+7r9f8ZPgfL22xGknmUiDegq6TIUuqbK2i1CbiM6pkkTGQGa5PRY?=
 =?us-ascii?Q?nHucHapynygLqvcskjQixpiXTPR2pTnWeEncw9muQ9VYRNQShauBiKDeWdCO?=
 =?us-ascii?Q?5vFVvXtRYSjbsbTXwXHXt11gzM/2Oj0nlKO+TVDM1ijihu3x0AH93t8/P87O?=
 =?us-ascii?Q?ZsFwopjOTq5k1mfPstGDIiO6TN4NioPEyEbVNvkHE/MmgX3/pOkjabG2Odue?=
 =?us-ascii?Q?8X+/fjFzo328gtfj1puYhIHUPo51VW6yxuTmeIINXPL7oUMaIGmn+U7DlPou?=
 =?us-ascii?Q?fh3c5v6gZgSgi0Mj4/+TrPyzl8EHrF6lvaykc/voL687QOvPOfpUzgaG2DFJ?=
 =?us-ascii?Q?7YKbaPD7KoqN14LAPSvRrcY5sys4mQ2m1zYn/65JJS53jY9gYL75HbmXP0Gd?=
 =?us-ascii?Q?BAuPCugCSmnY0ITdHTZqGPyYP7FQNwKnP2gqeRUvKFy2lULCoXrnOoNWQrd/?=
 =?us-ascii?Q?D2fDNtswJBDNAmUKd6mx+TRQJvRx4gII5+n2UGP3bea72xgUsgaroj8tdW+S?=
 =?us-ascii?Q?uCCC0dfsfrIaC+EBiHLa+JL21S0Byi6KAZuW+rtj9TELtgEwcljcOUvnuj+N?=
 =?us-ascii?Q?dqt8CV8M5dKDIColqzBLbZ2h1qf+Ss7QIZSpv8YHLgsIsGl93pIKbUnjR6S9?=
 =?us-ascii?Q?rKDszHrxmh3q3U0NWhwr+Zc7tafjv5MWG5twMpddWj3qTbKq/45MlmF4gekO?=
 =?us-ascii?Q?hV1PrkXYurcCHAscC0o3hYWrQjGZU0cSEeKYLJHm0jyJLVtIyldMVf85AF5w?=
 =?us-ascii?Q?aBx0l/FG95apUJQvfscJ4wyjPdF0Jl7axA0F3weu2k34w8sZLkBoABE/TyJ4?=
 =?us-ascii?Q?SNU8vA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7801ac4d-a1da-4421-2c20-08db57bed7d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 16:42:18.1361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0P0vGK8jgysYvZYnS6npoH1/rZWhY+uUM/sWw9eXjd+8yNB+W+hBLK1v3bJC0oAW6AC730Cr2JMM6ksp4W5mIG6UohVSMxxlcncgHrwFgBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5600
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 01:38:08PM +0000, Tudor Ambarus wrote:
> Currently in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is lower than
> the calculated "min" value, but greater than zero, the logic sets
> tx_max to dwNtbOutMaxSize. This is then used to allocate a new SKB in
> cdc_ncm_fill_tx_frame() where all the data is handled.
> 
> For small values of dwNtbOutMaxSize the memory allocated during
> alloc_skb(dwNtbOutMaxSize, GFP_ATOMIC) will have the same size, due to
> how size is aligned at alloc time:
> 	size = SKB_DATA_ALIGN(size);
>         size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> Thus we hit the same bug that we tried to squash with
> commit 2be6d4d16a084 ("net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero")
> 
> Low values of dwNtbOutMaxSize do not cause an issue presently because at
> alloc_skb() time more memory (512b) is allocated than required for the
> SKB headers alone (320b), leaving some space (512b - 320b = 192b)
> for CDC data (172b).
> 
> However, if more elements (for example 3 x u64 = [24b]) were added to
> one of the SKB header structs, say 'struct skb_shared_info',
> increasing its original size (320b [320b aligned]) to something larger
> (344b [384b aligned]), then suddenly the CDC data (172b) no longer
> fits in the spare SKB data area (512b - 384b = 128b).
> 
> Consequently the SKB bounds checking semantics fails and panics:
> 
> skbuff: skb_over_panic: text:ffffffff831f755b len:184 put:172 head:ffff88811f1c6c00 data:ffff88811f1c6c00 tail:0xb8 end:0x80 dev:<NULL>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:113!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 57 Comm: kworker/0:2 Not tainted 5.15.106-syzkaller-00249-g19c0ed55a470 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
> Workqueue: mld mld_ifc_work
> RIP: 0010:skb_panic net/core/skbuff.c:113 [inline]
> RIP: 0010:skb_over_panic+0x14c/0x150 net/core/skbuff.c:118
> [snip]
> Call Trace:
>  <TASK>
>  skb_put+0x151/0x210 net/core/skbuff.c:2047
>  skb_put_zero include/linux/skbuff.h:2422 [inline]
>  cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1131 [inline]
>  cdc_ncm_fill_tx_frame+0x11ab/0x3da0 drivers/net/usb/cdc_ncm.c:1308
>  cdc_ncm_tx_fixup+0xa3/0x100
> 
> Deal with too low values of dwNtbOutMaxSize, clamp it in the range
> [USB_CDC_NCM_NTB_MIN_OUT_SIZE, CDC_NCM_NTB_MAX_SIZE_TX]. We ensure
> enough data space is allocated to handle CDC data by making sure
> dwNtbOutMaxSize is not smaller than USB_CDC_NCM_NTB_MIN_OUT_SIZE.
> 
> Fixes: 289507d3364f ("net: cdc_ncm: use sysfs for rx/tx aggregation tuning")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+9f575a1f15fc0c01ed69@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=b982f1059506db48409d
> Link: https://lore.kernel.org/all/20211202143437.1411410-1-lee.jones@linaro.org/
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


