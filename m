Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1314C378F76
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhEJNlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:41:47 -0400
Received: from mail-eopbgr60130.outbound.protection.outlook.com ([40.107.6.130]:61949
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240324AbhEJMub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:50:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXzKVgt6WiG1KzQLmDCDyjoEtb0iOLI3t+Zechc//5nsprHyFVAg5xcgp1MXdDAG0Zf7o7aScdIGEm6R0HtnAdHdE4g3kOTnq1DlbGPDUzT83oRa3GWzi+FkXx9cel0tHUXGPb2ZwzdNXhfysl6vHbFC3IdI9hzgZLRYz1JVYpbGV0W0U7ox7EhT5L3NsjPlu8P2aJGnynNl6/zob3/03j91HCrIvA5m8GDmTJH6vajEHB2Pf47r8CFovRTUyOVtDzdig4b6cgq77ra0O4yTYFqr3O56mmUyiW63SPE0ldpmnWxE9/4GRM3xBKiDiMr1hYD6veBte8EepCqv5O/Z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfDoNMlyLlqM38w6/wIaGsd4J46AuCUQR+R2auTcA4w=;
 b=cpiJk3hdfO8SmvHaeE+jhhGgwd7vuQHFeJAZ8KkpKPyj8dlQ34IXNN0xXrH+sX5TjN41jm2H4V0KR9L0UZn0Z/Hv/KFC0Lm5U1H9BBKZE5C3LbZVWSF+Fm/c2b1pY0uINavcpVNZsNZv61pcgL8QnzArYmCg+sWq9V7ccfftVEt+KD6lyNLIzBapQSnuKpp+k5xRcivK/d4N+DIn7PNMdtkNWFWJSBA2ZQlTzdCjYAjSx+bbjnSYcPJ2sUC8qNWZE6xr5uC4X5OoXb+JLN2rPEQHK42V6ht7vP4/vC5S6TZw/vtLqkr1rf4UmmDPlOsk+1Bbb1vhMJCX59PdIVcV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfDoNMlyLlqM38w6/wIaGsd4J46AuCUQR+R2auTcA4w=;
 b=EbUjr85aG1GB+K6LqlbByaseqUHj6LbqriAgOKQ39NqkKDd/9pBGEoPAg/3582rhrQXxsGsIsfMqkJ/a+QIEmNvxEcE4Gb5N037tWU+wX6Le7hO85e8NBBP1cpD3TJNC3MDjzKBHpNulguZt2emH8h6/9eczlHkoQ9aSCS/nEq4=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM8PR10MB4628.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:362::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Mon, 10 May
 2021 12:49:24 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 12:49:24 +0000
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Dave Taht <dave.taht@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <CAA93jw6bWOU3wX5tubkTzOFxDMWXdgmBqnGPAnzZKVVFQTEUDQ@mail.gmail.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <c9f26a11-bb53-e3aa-606c-a592365a9a1e@kontron.de>
Date:   Mon, 10 May 2021 14:49:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CAA93jw6bWOU3wX5tubkTzOFxDMWXdgmBqnGPAnzZKVVFQTEUDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.142.79.33]
X-ClientProxiedBy: AS8PR05CA0021.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::26) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (46.142.79.33) by AS8PR05CA0021.eurprd05.prod.outlook.com (2603:10a6:20b:311::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 12:49:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 524142e7-4953-4076-3cab-08d913b20a3e
X-MS-TrafficTypeDiagnostic: AM8PR10MB4628:
X-Microsoft-Antispam-PRVS: <AM8PR10MB46289A5429E6CBD73FF0F022E9549@AM8PR10MB4628.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAcTkiWFblLYya4CkuzSmUK3SsgW+Bgj/qk94Z78ND8egPGpfTlQnkijXhxQcbbA2LmbHd5/QTqksEeiKRecZ+GNP0mXSE0eetQFOfQkbkdnbhbb7KDib+mpouEyFnMU9d0z6LDgQdcB2LgjOYRkVWTR3863vqtzskvQY8CtbPZPHoa+a6UZ3R7KVD/mgvT7FCkEl9R+QX/WWT93aIp0j2zsVnbM2f3lrY8YNrwfY5CYNhLx9SWw6kQttEdGfda7NKixDUxBxxdOeFBAUnTvPKhDuF5UJzo5Ewea9WbkQsrpb8UNQtKVK7UVbWCOo+wYWFHar+H8tySQBKTfAuZrF73AnoWrOnS82+piUGpFP3phhMvJCSmRyMf6VAR/ErjP7qjr79PyqncUmh0vpAXNffkDsaC3a0nVSh+Lza+gHzvaLspBk0fRelQDTumdKtNt425IvmnCyy2Wa9JJiYYRQO6hdtLGUKoxHxcFJOeAnaqeuhejSSAoqRD0ZWgPoVGdlmeYlkrvHWmwkMbPOpKM+HyxH12i14XwVpJ4Vnv/4MCmeVTmEGJ0xwt/uNxYEAgPhzB+XJ47lz8ROgb0CP2lge5uDpUFtCR0yDOD8HIMYjVSh5bfs6L5UJVm06jIufKAOlZ/zRA3ME4y0qB/n54UzmIRn5pyYSUbrJCf+Yb1stKp1WDEbrVxGSeGDufm435A5b7QFb9YBj/4Ft0azMZ9fHsdPbpCnVv4Us6eSNb7S2giM/b6rVzHv3G1JQdibzieB5lvqXkza+OEg6IAAMToiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(16526019)(6486002)(8676002)(66476007)(316002)(966005)(186003)(2906002)(66556008)(16576012)(4326008)(44832011)(31696002)(83380400001)(956004)(6916009)(2616005)(478600001)(38100700002)(5660300002)(45080400002)(86362001)(31686004)(26005)(54906003)(66946007)(53546011)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTRPTGZYT3c3NmRaeDlVeE9VSlhuMlYrc21laDJ5Z29YZG43TzlJWnY3RnNv?=
 =?utf-8?B?RkNDajhFNUtHQmJYRFFydktXbTB4SE5jRGRRR2lMby8vQUVFejBlOFVZYWxR?=
 =?utf-8?B?MWdCbVRjWFBIcXhmbDMrVndtNGJySzRaTmVseWpoWTdPeGlhYUN1WWk4ZjBH?=
 =?utf-8?B?QjI0VW8zTHgwTU9Ec0NxaU83T25XcXcrOUh1UXM5RXRvQkhWeXFDNE55NVFo?=
 =?utf-8?B?NzBxNnZyNmRtak9LaGhLVU5hcFhsZEFUTnB1VlI1Zmd1QmQxVWdZRDBVWGdo?=
 =?utf-8?B?WllqcnY0RVM4OUhtZlNldXkvcFkvQU5CT0MvdmtVbmJ5VDcrSUwvaUhZVFYz?=
 =?utf-8?B?dysxS2pGb1kwdGc5TmVDWmdYQ2xXbFhld21DM2s3QXMvS0krMWlVT0lubmVt?=
 =?utf-8?B?N1dPT3d6bms1NkdMdW1SQ1VpelR0YnVWN1JaR3ZZZkI3a0VCdGNIVVF1THJR?=
 =?utf-8?B?enQvL0xqeTlvRDExTmxIUkx6ZVNtZ2pRMms4RkVzQ3kzYlQ1U1QyVFZHd3d4?=
 =?utf-8?B?ZDNlTVVLcVZZS1RqQktWSG1hNStxZUNUb3QxMmNUeEJRakwzTS9WSVdTUHpu?=
 =?utf-8?B?WTFGMysxZUlJVEhwaDBjVDZnRzJiazZkeEY0RVlnVDBqSncycThKSUNQYWdW?=
 =?utf-8?B?ZVBNWTVzM0I0TU1SaDZQTUhQZkh2MHBkM1dINk9vcU9VVkxtbXdMRXcwV2p1?=
 =?utf-8?B?VWxsMTFEMHhOZFBXaHJUbG1jcUVuZTRUejVEOXVvN05iNDljT3dVRU84SXR0?=
 =?utf-8?B?QkNmUVFMd3NMUUhrZkFRL0xOQWdKbHQxakxLL1AzQ210Z1AzMlNlR3diZUZJ?=
 =?utf-8?B?ckx4c2xHcU9xYmxWcm9wYk40M01IR1FPZ2hLZkZZQU5kRVpmRVU4UVVpL2tG?=
 =?utf-8?B?djN0UjVIWGNQTythdGsyT2ZqcmZRRmlPMVhEWU9WVnhsV3FEMkRuckFmbUdQ?=
 =?utf-8?B?MzVxY0V3M2oybHJLbUpTczhNdmVSQnhMMTZOa1E3MVZaOElwK2djdWJTRytL?=
 =?utf-8?B?RWt5RU43d256WVlxZEEzN1VZYXJBOCtIcU0yNUxBYnVLc3piVEU5cEFpeVUy?=
 =?utf-8?B?VEltSEtaV045SStyOEIwSXlpRzMvSkFuVFdLaWlyR040bEJXNHBjQjhPVlVG?=
 =?utf-8?B?ZHY1QWMvUSs0WGU1L3pLQVlkVUFjWFd4dndOYkJDT1FYNGZZNW50YWNWSnd4?=
 =?utf-8?B?U1ZPczBPODVFMzdQVEpURzNqWEJvTVZnNG12QjVWOWVmVGxYNmY3bG94TEpB?=
 =?utf-8?B?NllNTGxyMlJJRVB0V3BZZVA5c01ya2l6b1RWcWdOQlhCNzVGVk9PVmdhSUpk?=
 =?utf-8?B?UDdWWjZCWWN5V0xuSW9sb0dseExQa1IwR29idDgyc2tlNHorMUkyS291Wmhn?=
 =?utf-8?B?eEp3ZHBtU3lBbmhyV1BPaGFXaTR2akRVY20zL1JobU9TUFZxcmtDQUxmVUZx?=
 =?utf-8?B?Ym1QTHYwbmV6SXVXOGdrSmV2TWhKcmFja3JBVFRoN0hub1czVWlJTlpjbFQ1?=
 =?utf-8?B?aTd2V01XQ09MVE0rSHh0R2JpOWV4STBlQW1UUmtMMGp0eUc2N2pUSlhOL1U2?=
 =?utf-8?B?b01GL3FVQThkTGhmY1dHWnNlUVVnclM0Z3VxdnRmUDFKZnE5SG1pTGNRMHR3?=
 =?utf-8?B?MXZCa1FhTHlKTVJPNkxyblFBNmpuTjZRejd4c2JXM3FKbXBSYkgxY1Z5YjdC?=
 =?utf-8?B?RG5hZE1OMk9rTU1aYjFxVXZPUTVYQVVhTVlZWDlNY0gwdU1KaEh6Z1FqTEto?=
 =?utf-8?Q?RNY61AKqhmtg6eKSq0UCH/SDLOwxad1JI8x1+GI?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 524142e7-4953-4076-3cab-08d913b20a3e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 12:49:24.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xt/SmDwvQP1nrWKVPp4O1q+96pgNM0cfaQKQy4xSWqgBnDWXSvQf8GZHVt/Pfk+m2HdOzkjCS2qzyAGbl84I/F460GVBogoxaqs3DooyQUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4628
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

thanks for the input. I really don't know much about the networking stack, so at the moment I can only provide the values requested below, without knowing what it really means.

What's so strange is, that the performance is actually good in general and only "snaps" to the "bad" state and back after some time or after repeated test runs.

And by the way, the ethernet driver in use is the FEC driver at drivers/net/ethernet/freescale/fec_main.c.

On 06.05.21 16:53, Dave Taht wrote:
> I am a big fan of bql - is that implemented on this driver?
> 
> cd /sys/class/net/your_device_name/queues/tx-0/byte_queue_limits/
> cat limit

~# cat /sys/class/net/eth0/queues/tx-0/byte_queue_limits/limit
0

> 
> see also bqlmon from github
> 
> is fq_codel running on the ethernet interface? the iperf bidir test
> does much better with that in place rather than a fifo. tc -s qdisc
> show dev your_device

~# tc -s qdisc show dev eth0
RTNETLINK answers: Operation not supported
Dump terminated

Best regards
Frieder

> 
> Also I tend to run tests using the flent tool, which will yield more
> data. Install netperf and irtt on the target, flent, netperf, irtt on
> the test driver box...
> 
> flent -H the-target-ip -x --socket-stats -t whateveryouaretesting rrul
> # the meanest bidir test there
> 
> flent-gui *.gz
> 
> On Thu, May 6, 2021 at 7:47 AM Frieder Schrempf
> <frieder.schrempf@kontron.de> wrote:
>>
>> Hi,
>>
>> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini boards. It happens quite often that the measured bandwidth in TX direction drops from its expected/nominal value to something like 50% (for 100M) or ~67% (for 1G) connections.
>>
>> So far we reproduced this with two different hardware designs using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
>>
>> To measure the throughput we simply run iperf3 on the target (with a short p2p connection to the host PC) like this:
>>
>>         iperf3 -c 192.168.1.10 --bidir
>>
>> But even something more simple like this can be used to get the info (with 'nc -l -p 1122 > /dev/null' running on the host):
>>
>>         dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
>>
>> The results fluctuate between each test run and are sometimes 'good' (e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M link).
>> There is nothing else running on the system in parallel. Some more info is also available in this post: [1].
>>
>> If there's anyone around who has an idea on what might be the reason for this, please let me know!
>> Or maybe someone would be willing to do a quick test on his own hardware. That would also be highly appreciated!
>>
>> Thanks and best regards
>> Frieder
>>
>> [1]: https://eur04.safelinks.protection.outlook.com/?url=https%3A%2F%2Fcommunity.nxp.com%2Ft5%2Fi-MX-Processors%2Fi-MX8MM-Ethernet-TX-Bandwidth-Fluctuations%2Fm-p%2F1242467%23M170563&amp;data=04%7C01%7Cfrieder.schrempf%40kontron.de%7C157b00b2686447fd9a7108d9109ecbc6%7C8c9d3c973fd941c8a2b1646f3942daf1%7C0%7C0%7C637559096478620665%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=SFT%2Boic9C1sirw%2BT1o1qRNNUe4H9bk2FHkLQpdy489I%3D&amp;reserved=0
> 
> 
> 
