Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69B8547DE2
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbiFMDO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiFMDO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:14:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5304C1BEA5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFOp8vpxaAckVthqL8r53hGdId6WGywgCEluYkq1uZQNcS/7GLWVzIq4ztG4aY9PisD06r+KqbFiobBFpuWitabOWBF6XP08SiAvCe9UEEdpHSd/a6qhUeAX0ORxBzwOkl0iYVDHdO9GxpX29ABfq8qqjijsW+2NtP4woA6cd2+lAWPQzo/UNKICdYdiiDrHU6wOl7FD3NE7JNJxRd4o+L98l2jx5y2crsHaddzUdDt4PsjEx1S0L4ywWSQXaWuGPFqH2IUaRSOKoSF98AVO312p8EYbVhwnIkSSAsfuLdJHuPxhzls1WsjSDP/xzbeEqiv6wE4CV0Jw9v396CoGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1ypYWQoqqcsz6QhY9Q3KsoUQSTGWllTGSRrXWRzkqs=;
 b=HYNmD83qRtzTApntb+7AgycuNFw6qJK92FStKUJO/Wwqtqdp0I8Gl/1btllysspkOVhxXKP6xJIUGYDYLOvT5pnbW7Ou9xdVnzI6en7E6A02zo3N7KgpXDkqFL36GjVu110McwjFiUlX4zaDjk0/IruGp4hzMXPgwPJLc/SbNsWz4HAAmy4gJ3Cm3r49Sm194orbgHfDeEFdE0OLgB2KrunwRO0fwNaEstdaySD5yg59q406Jx8lRSfUrLl7dFk7kdjh6WV+haQbbRPBiY2Ar+n/MDTybUCQbzVWGyvHGvVIQhuIpRxz8E71RQ9fHg6yn4STc3IvQ9mU8HVaYFzmKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1ypYWQoqqcsz6QhY9Q3KsoUQSTGWllTGSRrXWRzkqs=;
 b=g4nulNunQk7hrk4fzFsCB9v05TQxuH0ep9De94ZYeOk/+s3scL1S3c0CtcYsZ71okc7VvOeS438VcZhyrvVIcAPQlnGaqo/sWi/VI8KHn2YHg21rhO/FcvlSJ4JbWkwXhUxYtGuE20VfwkkCieOG3Xte/ctt4kGmlN+6aI04xKIpwsa48q965nFq4DZWK2VuMjnc4+bEPaOsQ58vF/wNqcyMXWf1OXpciVmV0GkUu9tnZCifs8tV0Xb78wQ9d3WVbYh10rWt8T+84xlTZT9AQ+ngjgJyzQNkNKgu6oPEf7E01kM3A4NjcOOHYx7zMcEXvpGtuFLLQQzBgFUnHHGXfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by BN8PR12MB3122.namprd12.prod.outlook.com (2603:10b6:408:44::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Mon, 13 Jun
 2022 03:14:52 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e1b5:e575:d59e:91aa]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e1b5:e575:d59e:91aa%7]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 03:14:52 +0000
Date:   Mon, 13 Jun 2022 12:14:46 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Mike Manning <mvrmanning@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Saikrishna Arcot <sarcot@microsoft.com>,
        Craig Gallek <kraig@google.com>
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Message-ID: <YqarphOzFTnQRq29@d3>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
X-ClientProxiedBy: TYAPR01CA0171.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::15) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bdb1518-c8b3-4149-a924-08da4ceae190
X-MS-TrafficTypeDiagnostic: BN8PR12MB3122:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3122A99D3FDED7781ABCF129B0AB9@BN8PR12MB3122.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8I+SuttSjGTMO4FwiSciygfyVzEHpwZJRPlzlV1beE6o3y/bjwsVZqWEUvFZ9OGEUn9TD6T1U2WfH8iVCSz7zc6qSGuAC9d4G7UsVJ3C7ygpQYsYMl6808b4TtQXO1iz5FerkB1VIj6x83OwJkcxkHDxbHv3oj9lRxaV5RhDeH20hHx+6YTwXyEVvscP3VnpLT6lXRsHnBj9P6Is5XeZ4xEW0Yd3RETi+8jZmU/piy1VxwMN3BPChsWx1hDPmFAZ5VgrKNEuP1TqDlFjDup8SQQib2sqLklw8gjlgBXO4ttqAwzcdTt/c0FRdKldiiMCmBJ8ff6MvE7tZ/1053FyY1z1pdBBkdK2B/tWwBEX8dd5eSiCVvE36Nqpt3D/EZZUHxPHqUJtz2zVKZXycnhDx/9K6Xv9hqgMGjm/r52BEZdi2IpVcXL1DktMr96/xBfIeey+3sY6W06yRc+vSODy4iyXAaNORCkRxSCfvXpDyIBR5G/Ttrx3xj7hAXXY1CyfB+0NmS/SrJnvQ+WwUBuitzNBf1uQw0DsvhejEd9L/1vMaEatV0EFKvl6hScFPTvHJvPsuow0ytHtmeK+IId38nIiK0bXbu9L8DvH6a4ifmPGevWUJlj2J2eajYVHueXykxan3rZ38dorAAsPnVz8+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(26005)(6512007)(9686003)(316002)(186003)(53546011)(2906002)(54906003)(38100700002)(6506007)(6916009)(83380400001)(33716001)(86362001)(66476007)(6666004)(66556008)(8676002)(66946007)(4326008)(8936002)(5660300002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2hEVU5LMmVYRlhBQlNBeWFRd25zdmRJZC9EODRJNTFxdkdMS3poSWEyTFRy?=
 =?utf-8?B?UlB5TjFNeFNtdU4reFRxY1FYMmU1TzhidWN2aFVEQndiTi9UQ3VKbTFuTUh2?=
 =?utf-8?B?ODZIZEkvZWtiRmt4T0UyclhFbjJQTjhlM28xVS9sSEZNYnJPSEFlYmF6ek9O?=
 =?utf-8?B?OWNHUGFDMkl3Nk13WWt6MXpFaHpSandmWDFVT1FkOUR0YVovdmlGZUEwbmlN?=
 =?utf-8?B?Q2ZkbUVrODVhTGlEaFRsQjgyQnFwazlWTkNtaW5ncHo2Tzk4Q0k4YzRQUTAx?=
 =?utf-8?B?QVB0UHBjQk9VMzVRUlBlK1dMSHhTWUkvK3QyUHFhZitwZkhLelVvOVdEZ09S?=
 =?utf-8?B?dVNhWTAzSE0xaUNHS21hQys0R3REQWFPblhhS2l1RkUrbktTODV0NDZ3NFRY?=
 =?utf-8?B?ZjF2UGNRdlRYZU1kR09GbHhBMm5VeEt1TmlpTXc3V1dWZkRCOHF3SVB6NytC?=
 =?utf-8?B?emRIQWxWQmFZWG9SbUFrYTVvZ0taMm9RUitVQTBzWmJaRzJ6K0NkYUxmZ1Fy?=
 =?utf-8?B?VXFyRzRKbkM5bDhvYkEvamZPQ2MvNHR1dFk3dklZS1kvZUx3RTFPSVZFZVFx?=
 =?utf-8?B?d0ZiWlZDY1dPSytBSkR0eDJNSTNMRml3MVh2YjM2OVdTTm1mb09GNktjVURN?=
 =?utf-8?B?Z094Q1hkV2xzRURCbnBHNVJ4YVZxa2pacDZ4bGpPOUFVTVZYQXl0MmtIWWg0?=
 =?utf-8?B?QUF4QXJMTXNlK0hqSk9hYUozbWRZVlRQU0cwU1dzbWl3d0c2MEJiVzk1QmRj?=
 =?utf-8?B?SGJLQlBOOWlmRDlXOFhPQWRpOXd2WDZlR09idGtpc201T1U3akFSeGtNck05?=
 =?utf-8?B?anBRUHVudmlac2NXaEpGN1BvOXNtVVR6VjFYVENUV0dZRUM5U2ZLT1FMWFhD?=
 =?utf-8?B?Yys0MFRCR2dia3BJclBzRk9vNE9hRXhkMURIU1dPZ1V6YzJ6b1hVc1JkNnBK?=
 =?utf-8?B?SHZTSFlwTWtlenJoUFJrSU03UFZIbzZTMWRTdU1GcGVIci9VRmZtdzIzQThW?=
 =?utf-8?B?SVNubVk4Lzh4aGhmU0ZTOXBRenh1YkR3RzFnUzNBM2RWRGNlWG1xcVZFMXZI?=
 =?utf-8?B?K3VOSTdmcW1oOERsVGowSCtsUmt2NlBnTFlTU3N6bVJhZVNJU1cxTTJhRytF?=
 =?utf-8?B?bnhETURxTnlWZTdhdW9uL2tuNlpMSVI4MnF1VUZvTGIrMExDdXJuSkZEQUJ4?=
 =?utf-8?B?VklLMk5HR2JPUTRmRlNlcDExazdmNlpROUI2VVVWalBWSnB3TFNrZFRtenpY?=
 =?utf-8?B?L01NbzFNZVJkYjlxUTRkand5eE41cUF2ZDRqamExVkNCM2NOelh4dEs1ZWlG?=
 =?utf-8?B?OG03MkFoUFhuODRMMkRLYmV0WmdJNTVGQSs2T2h2MHFFYUQwVmswamY1Uk5v?=
 =?utf-8?B?MERKVnpGZlN0anhkenZsby9aOFpram5PSWZYZHd1eFlVc2NHYjI5aTBPQmhN?=
 =?utf-8?B?czErblRhMDdMM1RiWnBVUkJTWVRPZXZDS3ZFMkVjZmlBdUdkM3RJOEYwWlVU?=
 =?utf-8?B?MFFoYVZ6RVZHSVZ3dW0xdjlpeTZqZnFpckR4T3dLYlV6VWtBMzIzOXpZZFdZ?=
 =?utf-8?B?TGNMalptanVpRFJaN0QyS05jeUNiNG5NZEhicXh5WXRDa2Q1VWZPNjBmS21U?=
 =?utf-8?B?TjVIbmZBRm8vVyt6ZUVFNGxaNU55bk9lVktqc1hhZjYwcW9YZVhNY2hqKy9M?=
 =?utf-8?B?YzRVNjZCTlowcTZlT2NPWlNnVXdyOHBvR1lJOVc3VHRrNUI2TE9qaFNiemRT?=
 =?utf-8?B?WVhvcjRiT1hiS0hoZlVuMWNGdWVtY2RMb1I1MndOU0xucjJtVTZuamFKdURl?=
 =?utf-8?B?cEUwOW0zNkdmZlk5QW1xb2s2ZUJDOE9ZVDRFQXJDV1JzaFJwQ2VsZ3JEVGhP?=
 =?utf-8?B?eE16R3MyZzNaTEExNm8yMzhsVUtxZHQwT0pKLzI1c1hSM3Z2TDBkUGViTUdP?=
 =?utf-8?B?aGp6RGlkRjdWZDNKeGJrQkpCN2ZvMmRVQ1hVQ00wTEpGdjU5bW1jbGJjZ09O?=
 =?utf-8?B?QmdJdFJTdSt3QWFtQWUxb0tDYVloYXN3L0tnb2hPdVEyT1FJMlp4bUZDcllv?=
 =?utf-8?B?UmwzbE1XMnNsRHdMZWhaUDBUOWZ4OGY5VkYrTzltbm5va0lGMVRpTG5ZREt4?=
 =?utf-8?B?eFdudTBqNEhzNzZneUN3UTJQN1ZvdXhHMVJVN3VpcmVLOU96NkxQdFdVczhH?=
 =?utf-8?B?K1BBb0IxWE1TYjloZmdJcU04RHV6dU5Db3BhOWVJZ2x4WGJnYWRMOThlMCtL?=
 =?utf-8?B?UW81SUgvWkpuMkxVN3U4cFhmU0dNa3Q1YzNtNXN0dG9maFV1YzBLMHd2cStL?=
 =?utf-8?B?SHVBVENSMVdoMTJZY2hWYi9RMDFlMHdQaisvWkhBTDBUR3U5YTVEaDNMeVhP?=
 =?utf-8?Q?96TadBBmPxD8NgF0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bdb1518-c8b3-4149-a924-08da4ceae190
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 03:14:52.2070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cwgvcaDy63XmSkt/fsYW8LmiQlV5niUggBwqtAFsPW9Y5Dx9kQa0Dqyz+YX6LcqeF2kyuW6dkSjqhahQ0XJ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3122
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-05 14:03 +0100, Mike Manning wrote:
[...]
> 
> Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
> Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
> ---
> 
> diff nettest-baseline-9e9fb7655ed5.txt nettest-fix.txt
> 955,956c955,956
> < TEST: IPv4 TCP connection over VRF with SNAT                                  [FAIL]
> < TEST: IPv6 TCP connection over VRF with SNAT                                  [FAIL]
> ---
> > TEST: IPv4 TCP connection over VRF with SNAT                                  [ OK ]
> > TEST: IPv6 TCP connection over VRF with SNAT                                  [ OK ]
> 958,959c958,959
> < Tests passed: 713
> < Tests failed:   5
> ---
> > Tests passed: 715
> > Tests failed:   3
> 
> ---
>  net/ipv4/inet_hashtables.c  | 4 +++-
>  net/ipv4/udp.c              | 3 ++-
>  net/ipv6/inet6_hashtables.c | 2 +-
>  net/ipv6/udp.c              | 3 ++-
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 

Hi Mike,

I was looking at this commit, 8d6c414cd2fb ("net: prefer socket bound to
interface when not in VRF"), and I get the feeling that it is only
partially effective. It works with UDP connected sockets but it doesn't
work for TCP and UDP unconnected sockets.

The compute_score() functions are a bit misleading. Because of the
reuseport shortcut in their callers (inet_lhash2_lookup() and the like),
the first socket with score > 0 may be chosen, not necessarily the
socket with highest score. In order to prefer certain sockets, I think
an approach like commit d894ba18d4e4 ("soreuseport: fix ordering for
mixed v4/v6 sockets") would be needed. What do you think?

Extra info:
1) fcnal-test.sh results

I tried to reproduce the fcnal-test.sh test results quoted above but in
my case the test cases already pass at 8d6c414cd2fb^ and 9e9fb7655ed5.
Moreover I believe those test cases don't have multiple listening
sockets. So that just added to my confusion.

Running 9e9fb7655ed5,
root@vsid:/src/linux/tools/testing/selftests/net# ./fcnal-test.sh -t use_cases
[...]

#################################################################
SNAT on VRF

TEST: IPv4 TCP connection over VRF with SNAT                                  [ OK ]
TEST: IPv6 TCP connection over VRF with SNAT                                  [ OK ]

Tests passed:  16
Tests failed:   0


2) reuseport_bindtodevice test

I wrote a selftest based on
tools/testing/selftests/net/reuseport_addr_any.c It tests that listening
sockets that have SO_BINDTODEVICE set are preferred over ones that do
not. All of the sockets have SO_REUSEPORT set. I ran it over a few
relevant revisions:

               IPv4                       IPv6
HEAD           TCP  UDP unconn  UDP conn  TCP  UDP unconn  UDP conn
6a5ef90c58da^  ✔    ✔           ✔         ✔    ✔           ✔   
6a5ef90c58da   ✔    ✘           ✔         ✔    ✘           ✔   
fd1914b2901b   ✘    ✘           ✔         ✘    ✘           ✔   
7e225619e8af   ✘    ✘           ✘         ✘    ✘           ✘   
8d6c414cd2fb   ✘    ✘           ✔         ✘    ✘           ✔   

✔ pass
✘ fail

reuseport_bindtodevice.c:

// SPDX-License-Identifier: GPL-2.0

/* Test that listening sockets that have SO_BINDTODEVICE set are preferred
 * over ones that do not. All of the sockets have SO_REUSEPORT set.
 */

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <error.h>
#include <linux/in.h>
#include <linux/unistd.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>


static const int SEND_PORT = 8888;
static const int RECV_PORT = 8889;

static const char *get_family_name(int domain)
{
	if (domain == AF_INET)
		return "IPv4";
	else if (domain == AF_INET6)
		return "IPv6";
	else
		error(1, 0, "Unknown address family \"%d\"", domain);

	return "";
}

static void build_rcv_fd(int domain, int type, int *rcv_fds, int count,
			 const char *ifname, bool do_connect)
{
	struct sockaddr_storage saddr, daddr;
	int opt, i;

	if (domain == AF_INET) {
		struct sockaddr_in *saddr4 = (struct sockaddr_in *)&saddr,
				   *daddr4 = (struct sockaddr_in *)&daddr;

		saddr4->sin_family = AF_INET;
		saddr4->sin_addr.s_addr = htonl(INADDR_ANY);
		saddr4->sin_port = htons(RECV_PORT);

		daddr4->sin_family = AF_INET;
		daddr4->sin_addr.s_addr = htonl(INADDR_ANY);
		daddr4->sin_port = htons(SEND_PORT);
	} else if (domain == AF_INET6) {
		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)&saddr,
				    *daddr6 = (struct sockaddr_in6 *)&daddr;

		saddr6->sin6_family = AF_INET6;
		saddr6->sin6_addr = in6addr_any;
		saddr6->sin6_port = htons(RECV_PORT);

		daddr6->sin6_family = AF_INET6;
		daddr6->sin6_addr = in6addr_any;
		daddr6->sin6_port = htons(SEND_PORT);
	} else {
		error(1, 0, "Unsupported family %d", domain);
	}

	for (i = 0; i < count; ++i) {
		rcv_fds[i] = socket(domain, type, 0);
		if (rcv_fds[i] < 0)
			error(1, errno, "failed to create receive socket");

		opt = 1;
		if (setsockopt(rcv_fds[i], SOL_SOCKET, SO_REUSEPORT, &opt,
			       sizeof(opt)))
			error(1, errno, "failed to set SO_REUSEPORT");

		if (ifname && setsockopt(rcv_fds[i], SOL_SOCKET,
					 SO_BINDTODEVICE, ifname,
					 strlen(ifname)))
			error(1, errno, "failed to set SO_BINDTODEVICE");

		if (bind(rcv_fds[i], (struct sockaddr *)&saddr, sizeof(saddr)))
			error(1, errno, "failed to bind receive socket");

		if (do_connect &&
		    connect(rcv_fds[i], (struct sockaddr *)&daddr,
			    sizeof(daddr)))
			error(1, errno, "failed to connect receive socket");

		if (type == SOCK_STREAM && listen(rcv_fds[i], 10))
			error(1, errno, "failed to listen on receive socket");
	}
}

static int connect_and_send(int domain, int type)
{
	struct sockaddr_storage saddr, daddr;
	int fd;

	if (domain == AF_INET) {
		struct sockaddr_in *saddr4 = (struct sockaddr_in *)&saddr,
				   *daddr4 = (struct sockaddr_in *)&daddr;

		saddr4->sin_family = AF_INET;
		saddr4->sin_addr.s_addr = htonl(INADDR_ANY);
		saddr4->sin_port = htons(SEND_PORT);

		daddr4->sin_family = AF_INET;
		daddr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
		daddr4->sin_port = htons(RECV_PORT);
	} else if (domain == AF_INET6) {
		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)&saddr,
				    *daddr6 = (struct sockaddr_in6 *)&daddr;

		saddr6->sin6_family = AF_INET6;
		saddr6->sin6_addr = in6addr_any;
		saddr6->sin6_port = htons(SEND_PORT);

		daddr6->sin6_family = AF_INET6;
		daddr6->sin6_addr = in6addr_loopback;
		daddr6->sin6_port = htons(RECV_PORT);
	} else {
		error(1, 0, "Unsupported family %d", domain);
	}

	fd = socket(domain, type, 0);
	if (fd < 0)
		error(1, errno, "failed to create send socket");

	if (bind(fd, (struct sockaddr *)&saddr, sizeof(saddr)))
		error(1, errno, "failed to bind send socket");

	if (connect(fd, (struct sockaddr *)&daddr, sizeof(daddr)))
		error(1, errno, "failed to connect send socket");

	if (send(fd, "a", 1, 0) < 0)
		error(1, errno, "failed to send message");

	return fd;
}

static int receive_once(int epfd, int type)
{
	struct epoll_event ev;
	int i, fd;
	char buf[8];

	i = epoll_wait(epfd, &ev, 1, 3);
	if (i < 0)
		error(1, errno, "epoll_wait failed");
	else if (i == 0)
		error(1, errno, "no socket is ready");

	if (type == SOCK_STREAM) {
		fd = accept(ev.data.fd, NULL, NULL);
		if (fd < 0)
			error(1, errno, "failed to accept");
		i = recv(fd, buf, sizeof(buf), 0);
		close(fd);
	} else {
		i = recv(ev.data.fd, buf, sizeof(buf), 0);
	}

	if (i < 0)
		error(1, errno, "failed to recv");

	return ev.data.fd;
}

static int test(int *rcv_fds, int count, int domain, int type, int fd)
{
	int epfd, i, send_fd, recv_fd;
	struct epoll_event ev;

	epfd = epoll_create(1);
	if (epfd < 0)
		error(1, errno, "failed to create epoll");

	ev.events = EPOLLIN;
	for (i = 0; i < count; ++i) {
		ev.data.fd = rcv_fds[i];
		if (epoll_ctl(epfd, EPOLL_CTL_ADD, rcv_fds[i], &ev))
			error(1, errno, "failed to register sock epoll");
	}

	send_fd = connect_and_send(domain, type);

	recv_fd = receive_once(epfd, type);

	close(send_fd);
	close(epfd);

	return recv_fd == fd;
}

static int run_one_test(int domain, int type, bool do_connect)
{
	/* Below we test that a socket listening with SO_BINDTODEVICE set is
	 * always selected in preference over a socket listening without. Bugs
	 * where this is not the case often result in sockets created first or
	 * last to get picked. So below we make sure that there are always
	 * sockets with SO_BINDTODEVICE created before and after a specific
	 * socket is created.
	 */
	int rcv_fds[10], i, result;

	build_rcv_fd(AF_INET, type, rcv_fds, 2, NULL, do_connect);
	build_rcv_fd(AF_INET6, type, rcv_fds + 2, 2, NULL, do_connect);
	build_rcv_fd(domain, type, rcv_fds + 4, 1, "lo", do_connect);
	build_rcv_fd(AF_INET, type, rcv_fds + 5, 2, NULL, do_connect);
	build_rcv_fd(AF_INET6, type, rcv_fds + 7, 2, NULL, do_connect);
	result = test(rcv_fds, 9, domain, type, rcv_fds[4]);
	for (i = 0; i < 9; ++i)
		close(rcv_fds[i]);
	if (result)
		fprintf(stderr, "pass\n");
	else
		fprintf(stderr, "fail\n");
	return result;
}

static int test_family(int domain)
{
	int result = 1;

	fprintf(stderr, "%s TCP ... ", get_family_name(domain));
	result &= run_one_test(domain, SOCK_STREAM, false);

	fprintf(stderr, "%s UDP unconnected ... ", get_family_name(domain));
	result &= run_one_test(domain, SOCK_DGRAM, false);

	fprintf(stderr, "%s UDP connected ... ", get_family_name(domain));
	result &= run_one_test(domain, SOCK_DGRAM, true);

	return result;
}

int main(void)
{
	int result = 1;

	result &= test_family(AF_INET);
	result &= test_family(AF_INET6);

	if (result) {
		fprintf(stderr, "SUCCESS\n");
		return 0;
	}
	fprintf(stderr, "FAIL\n");
	return 1;
}
