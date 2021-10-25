Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3228439E5D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhJYSXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:23:14 -0400
Received: from mail-mw2nam12on2113.outbound.protection.outlook.com ([40.107.244.113]:31841
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232658AbhJYSXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 14:23:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gW0kDQd9PGi+he3BWFPDakDBlT58iGB1pyn4bbzAqAfjnDAH4MdHNiVXHODVnlhlIIVU0TyG/xvUMAWtmMAHVp+54dxsw/+fsDl8yuSPx4C67CdtHzKS+OXw9cLdk5VWmKPLcoCbhhoz6nhexAdAkQsEJII8Pug7dIROc8m2LwaojrO+PedyY8FGTwdGdYQzdDxmnUZiY/QMpNTs1hD+SYJLPGBVqJgLd+p6KCkZK0gHv3P/xLn0PLLgWKqXYG83WbR3VA+ckgdq2DZihgTX2Wb5bVacU9fKzkSKGt/9c0LB9AvebP0oEC0U3R5qgvPe/ysjMMl4V3oOYNjb/TqzJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fp539HxF44tOmwRBNe6Woyi3i0CQf7P2I4MdOclU4m4=;
 b=YIJY9oWMm2UEHaCEUhnNZNDQ8BYiSVc5Yv1swXDsE/S2sJU6jBb9fIaZepkD7u04+g/13DDZ9lUijvEYiucU677xu16+f6dV0NSgXIbpgbVcSr2L+us1wqZU5Iq+NE3Qvs+On2mCaF3INomXkDtn8iMS7oFYJ0+poheKnxbSg7ZSQAvzWuURoxqMsHEN2J7o/wxJs7SFqKzPWHeX0kB95oSreAmwJvzNoDbkYW6f+5mrc3wFCLxX6IaDjxBTMSgfdPiyrbqatepZFTxfFJmdUB7Tu+X5Y6eiXjK+b4zk8S3z52+PZbiSPeu9fYCE0lanIEarZfBRZW5eFm8ng81o/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fp539HxF44tOmwRBNe6Woyi3i0CQf7P2I4MdOclU4m4=;
 b=WxpXZRqN6iPDGo2eANjak7KV/K6TceZvYDwYAwoBWiGQU8xWwGBqrjsNfso+yrq0sj/gjO6o7gcNcF7mbs9BbSGPq+cFN7EN0rMiEILqQ1DPaYE6jjlVUIRwVIsPA8Q5iV2h1WhgPEEDkFLE2j/JkY4tKB82HmBHM2y5Hm+sQ/228Jbk1LSb8/avjyWHhh0E8JZtFujhDTTiR7uBYW6fUr7F17zIJEbEfaaY3rnS/Xv6lpQtvsQdRYgizcm5pYcbPrKFXbDTthY9SjHe0mQ3XrMTJ/Wv3brBQXQxDsvdq4dmAyx6jvHuDv9INWTt+XePrxqOHJqmLml4IxdqGbOOxA==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB7476.prod.exchangelabs.com (2603:10b6:510:f3::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Mon, 25 Oct 2021 18:20:44 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::88df:62ca:347:917f]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::88df:62ca:347:917f%7]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 18:20:44 +0000
Message-ID: <e07e29ab-4cae-73b5-0836-c3cf39f3df00@cornelisnetworks.com>
Date:   Mon, 25 Oct 2021 14:20:36 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v6 04/12] drivers/infiniband: make setup_ctxt always get a
 nul terminated task comm
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        valentin.schneider@arm.com, qiang.zhang@windriver.com,
        robdclark@chromium.org, christian@brauner.io,
        dietmar.eggemann@arm.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-5-laoar.shao@gmail.com>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <20211025083315.4752-5-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0047.namprd03.prod.outlook.com
 (2603:10b6:208:32d::22) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
Received: from [192.168.40.173] (24.154.216.5) by BLAPR03CA0047.namprd03.prod.outlook.com (2603:10b6:208:32d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Mon, 25 Oct 2021 18:20:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bff85a7-4515-4627-275e-08d997e4286f
X-MS-TrafficTypeDiagnostic: PH0PR01MB7476:
X-Microsoft-Antispam-PRVS: <PH0PR01MB7476C29755B177CE515380C5F4839@PH0PR01MB7476.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRCb5gVhKCqifggviULiAHoU6jGgXiHcnagOSDdYi4DbpnKhK4c8DCONfDZEStpcPxSjxtAq1YcvLxUGge/1DjT3vBq4tW5wZNBLt4kLI0wNe+NeJ6aEEf+XbuLcZQPo5mXiZAAlkRGGVy+wMF6mEGE9jSgy2ntLQf9Dq+4E7WtS6IYqiINeX4hidQFU84WMBtesRFCH+qWrSn+3QLwUwJ8UCfl4L7wlC+92rcYyOp1QZ2gRsSD2/L+p7SC2Hpst7AgUKcz2ThWFGkjuw+kiRs+TV40EmqqkuYOw65BrNkO/sBQvskshyi+FRudJaRWV7dKSxlmeFzZzns+lcTIQLzdRrZRfBKfGsrgpr8A9FMYLWo/FCdIEmgHkXFJGs7D5ajmVjMDcjSNPfjW7GQddfIWy/8e8LGBjW15oTSBZaZbBZg9U6xLAUPDQkgp0JGgpV16v21TqR/MgduA8HJ0/BfOllldsR2iwGmXTMKZxhAj/b7cxDxMhgSlq+fgWaJyZMtMaElzhOkn3YQYf5IW9irxgpPdUgkBKytva3Sv0dKBVwDvDV+OAQjNuUWM2WQCk9keIL0un06YE+E3eK9kr57y/DBWBlAdQqgMg2oiPmzOik7jEz2skbjtlFLLqLsRjfAFciavBaEFBEgQXtJke3sgyTFGGSet3WaQR0oU2RDvLVQSnnhQEDk6LVy4ZZuLj0nC5fRg1tsIYPzOCUk3I5JddH0BJP9IjPXXFJDrbnk+d7Lm+MUifNQc0y+Idww0e7a9paWye08Ujh7PbD/JwBlMJyEMH6LbngYTvoU+AKCo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39840400004)(396003)(8936002)(508600001)(2906002)(52116002)(7416002)(36756003)(7406005)(6666004)(316002)(4326008)(38350700002)(8676002)(38100700002)(31686004)(921005)(4744005)(16576012)(2616005)(44832011)(5660300002)(956004)(83380400001)(6486002)(66476007)(66556008)(66946007)(186003)(86362001)(26005)(31696002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2tsT1ppU0ZuZE90RkpYeEd1bE5KN1RwNHpscFhlUElhc3BEVlpLZHNpdkZ1?=
 =?utf-8?B?ZHRxNmVWcTBlUFFhWnppSXRwYmVvTTBQSXMzMzFEUVpKU3dWdmdOMmpieFV6?=
 =?utf-8?B?My9wd0tLQ2I5dXMxRTJ1TmlaVFlNOVBVZnpBUEh3MXY4dkxqempyUUVzU0xH?=
 =?utf-8?B?TS9QdERkaUw1Wnl1OG9iTmxhNW9GZ1h6cUtrN2xaV1o4Ums2NDFwWGRFalNp?=
 =?utf-8?B?R21EQ0xZR0ZxNWs5VnVTZ2dvUE5PV1JnVEhRVnkxYTFGZklmVjdkREhpRUFj?=
 =?utf-8?B?Y25MSzJwUGE0U25jVWV2clNzUzFqWlRPSW4zL2RXa0crUTZpVHZDNWhLaEhi?=
 =?utf-8?B?ZUZVK3FNTDVDZFp2RGZVZE1mblJFLyt4RFJOU0hUaVpDTmxoV1kwdjVpc2VD?=
 =?utf-8?B?dXRGbzJhRDRFeStPNTJ4eGVaRWFqRXA5R29qendIRnpELzIvMFNWZ1hGS2RK?=
 =?utf-8?B?K3pjSGZPdGVZcUhXOFh0Q0ZBcWNsdVBPMWlPWnBvTjY0OHM4RGRGQU9LK3I0?=
 =?utf-8?B?VWV1clRCWXAxTjN4Qk11empVYk5zdHcvZTcwMms5d0ZaMTg3VTlDdVRybXJk?=
 =?utf-8?B?STFFYnJTQThxakVQQ1dNcGFrWHRFUDRuR3ZuTXQxbVVEV3J2a051emZ2QSth?=
 =?utf-8?B?clZYWjFYWk9aRC9ZQWh4Qm81bUhuSDhJanNLV0hrRVdyN0Y2Tkpmb1ZmV0FF?=
 =?utf-8?B?TXJOMCtuKzE3cGQ2VDVFem90dVVUd0FkR09lN1BQaHl3b2tyczArVzNJOVNZ?=
 =?utf-8?B?Vm9kenpHQk9KdjkvNTJ2a0gzL1g1TmJnTS81NWRoeG5CbVdwZHpPQ3N2K05N?=
 =?utf-8?B?UUw4TXM1SjU1KzlOUjBaLzNqZW8xZlVPRnJheHNUaEhBRzRTbVEzUDN2TVJD?=
 =?utf-8?B?NUVvNUpoUmhtVlYyVGExd1pLSFVMaHd5bzNqOFEwOWRQZ3d2cWdjSDh2cURk?=
 =?utf-8?B?Y3V0bzUrKzVDSGVlZHVDL3kzeHBlVDZqa2dvYnAzay9KRHJqaE9uUjZ2N3FK?=
 =?utf-8?B?NnlGQ240ejdYMW9FazZzbkZJRHRXdzA1QWQveEJEWXAwUXpEVVdYdzRYSXNx?=
 =?utf-8?B?eWUvL1FWTHBIWTd0N2dIT05FVGJhb2FOeEgwSDRlYk1VSUZSc2V5WWFCTVpJ?=
 =?utf-8?B?OEo0VlhoTXVRSzdWdUtVZktTWGVldmtGNWJhSWRNeEgrL0RxdWhlUGdqbjZ2?=
 =?utf-8?B?clRnMlhFYStCVnViZU1XL3FJRDdLSzQwcVhoT01FSXZ6b2JIVWttejI3cUxE?=
 =?utf-8?B?NW1ScWhWUDJPQkF0QjVWRUdDd0dTZTRERXZ2SW9wV3Rsak11OVZsVTR1YXg3?=
 =?utf-8?B?aHFQcTBnSWZMWlZkQ2JJUTdZR284MDlUVk1VMG1zZThxQzJqL0c1NXZTOXNH?=
 =?utf-8?B?TDlwbStseG5ERFRFamp1bE5FYWU4a25YOVNleEJyd05Ob1poaU5FdUxaU2Yz?=
 =?utf-8?B?WXoyV3R3OVV5Y0NaNDIyamhzei9TeEZJUWMyRTVmSGFPZ2pKZGpvSVQ0QUFG?=
 =?utf-8?B?WUtBLzA0cHFFUWZ0SDRGQzVEYmRNTkliaFEvVmNSUmJWUHp5cWE0TnVIUnFw?=
 =?utf-8?B?ZVNEcHhaZERzcEhzM2lBQ1M4SUE0dkgvREtLUEJkaHJXVEFnbnUrU09lZ2gz?=
 =?utf-8?B?aGFuVSt0c3pWbHpONXd5bHp1Vkhjdmx0TGt4T1JjdVRjZTVIMFQ0TjR6Q3Y2?=
 =?utf-8?B?VHdIZDJOWjE0NWEwV3oyWVc5b2VuVDd3OFZDRXB0VUp1OEh3OFU3WGZQemRM?=
 =?utf-8?B?ZUtyaDk2YUNDMC83R0hWQkVyY0QvK3dHVEFMVTR3N0poUnlPZzlGVnVuLzNF?=
 =?utf-8?B?SmVxeVd1UGJ1d2tGRDIyeTFXOUd4TlJSQkRXc2dTSnR5ZTlrc0Fkd2VSZFlj?=
 =?utf-8?B?dS9tem9YdWJPY0lMT0g0TkNDTEZ1cHp3SmwwSWwwQ2Z6R3hYQ0dTODBaYlBM?=
 =?utf-8?B?ZCs4QjZFRStLMHVlTW91MFZsSytkcm1yaUVucEFxOTdQa1pMWnpZWjVDV1RJ?=
 =?utf-8?B?bWpiaE5XMWZlelhHeDdIb1k1Znkrd3pZS1NCcnY2UDQ1Ry9rMzZEWGZQeTlW?=
 =?utf-8?B?ZytRNVIra2lZQWExU2QzUm40SXVkZHJrSkYrMUh2MXYxVXBPVFYxb1VpcFF6?=
 =?utf-8?B?TUlsOGNTL3VHMXRPOFE2TTRCVVYvVHZ0REltL2NuQlFUdXFyd2tIR1YrOFov?=
 =?utf-8?B?WmVJZHBDV0ZLT0MwUU5nWkY4VlRVVFVqU09PamoxMk83S25vOTR5aFlERERM?=
 =?utf-8?B?RXM5NVN0czQvenVJL1hEdDNiMml4Y1N0ZmFUNTdTNjRrZm1BRmNubmxwYzFI?=
 =?utf-8?B?ZWNJTWhleDBjYmxLdU02VjVKSWMxWnUxSVkxNEYwZWFTMm4vK0FrQT09?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bff85a7-4515-4627-275e-08d997e4286f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 18:20:44.0359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUTTpQj2VqJ/riel8HbpjyHdadlzpyWpIpH6diahkVfxLqdSJd51Ux5gWNgfhYNiYFerfkMsVR5SJJxyZ1m94uZPu6KsQoB09RDl2R7+4l8wRrPcRuyL7rDEV1ccTVjm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7476
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/21 4:33 AM, Yafang Shao wrote:
> Use strscpy_pad() instead of strlcpy() to make the comm always nul
> terminated. As the comment above the hard-coded 16, we can replace it
> with TASK_COMM_LEN, then it will adopt to the comm size change.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  drivers/infiniband/hw/qib/qib.h          | 2 +-
>  drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This qib patch looks fine.

Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
