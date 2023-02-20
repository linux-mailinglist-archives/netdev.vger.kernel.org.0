Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D7969C48A
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 04:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjBTDoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 22:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBTDoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 22:44:17 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2104.outbound.protection.outlook.com [40.92.99.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2361D93CA;
        Sun, 19 Feb 2023 19:44:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThVAOaFqvthaTcOF1tacrWhzfEvILlTLHzU73ueMuoW3ahxQ2K5hQFwhs3oZfF/ETXny0HbLEobdhC5FVuMTkCPa35HC+4qhmR1swR1GaFygMlc9JJ5QiOHsJpD4GES/ycQp/0lxi0NkQ0e7sw6b+PdmACQTo5yDX866rhJSHt71XVrP6iM61khAf92umLQXdjcY722jFzDyL7S4xjligQvaHJRvvOyAUeFgl/VoR/MJqnR3CzZDT5PpSxLup76UIlqoHr+ofLUkdM+oGH2IGQE5cc1gHrFDgNiLQkTmeWKqmsFxJKtvZCe2YYxhC06oDpF6E3fS0HVgQvO9JnIfIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnWH4LO5345ppKjZhSzPGHAleAw+IoxFMfJcNgidQXo=;
 b=gpcRANWKJkHECTBSbVAm7zxKjO2GZmW/7h2ulz+wpnACGfgeH7FO5rBPyT4MOLL4X1aLwZbiMxGV7PFjvc5t92RrENCHbkHTzCKZ97K9/yaBYcleoqhAcdBDjhZVf0zLIOpLFMgrB7wRv8xWKtAo2vxGKuEheinnq+Ya7nRmd6z//X4wyWLoyIG+VKAUTOyBXp0+Chlz7HSQSvhe6yK0LOXjwnfof5KY0LqgfKcfrHXfoBMxppBr862bnoIjWBlvIAvSJ1uWE5XTfjk5NEolqBuA7fSjqXD1XtSyoJ/arCwB+lJEerLkaJ3mwYjIBq178eqIGDJiAVIu5pnGpd46Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnWH4LO5345ppKjZhSzPGHAleAw+IoxFMfJcNgidQXo=;
 b=o4yUfxGqqxdLIAX8JnwHwl2qAVyIuZPENeA13fIbI/haxAldcGulni1CK0sV7Q3AqLtuvrY2RbNQ10Y5kncmQ7b4nIg/MaHBNemuHVgsQ8YOMi8xeayIaMntUp7Z55mJ6O2RMr6WcGKs+/JJfXHQual0AmM2T8IiSI7odFQnzpSgrcPnMNgcyZAB6aJFvMppRWP9jTqf7BwNkMHOI2OICgAmVtOg+IkXu9Es+syHkA9KL7boAYBUsM/gfxt4WYeOLi0e2OQW+uEMyZOT+ZcEVcHgQmm69MMme98RlLAP/tIoG5GND6TPqbAWmOxvXlOId+TZfBSS/Wj+QPzJexUGJg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB3211.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Mon, 20 Feb
 2023 03:44:12 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Mon, 20 Feb 2023
 03:44:12 +0000
Message-ID: <OS3P286MB22951D8802775CC6DBF243F3F5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Mon, 20 Feb 2023 11:44:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [ovs-dev] [PATCH net-next v1 1/1] net: openvswitch:
 ovs_packet_cmd_execute put sw_flow mainbody in stack
Content-Language: en-US
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y/IqJvWEJ+UNOs6i@corigine.com>
 <OS3P286MB22957AE85FC76EAB8988745BF5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <OS3P286MB22957AE85FC76EAB8988745BF5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [Pf72X1sSFFAdcchxzB8PSpn4kKq76So5]
X-ClientProxiedBy: TYWP286CA0001.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::12) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <b460bedb-afa2-2d46-7d5a-f613b5ea89d5@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB3211:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ea7ddb-6101-403b-8296-08db12f4bb3f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMHr6Dgn0tmUcTNpUJucsq2rwh1xUncRifBkmTVv0DOjbbB5RUUnftemdJnogFBU3ZuA7mmiPKnY0ydr3XETTI9jQ129Ug8jEg5Z/oappAJ2hLYEJMAjIdcIE4ZTBbdukVezGmGY643XySwU/2JrbYuYb9/qrS79iyo7sUFsfw7iJxuG9+13b3piy7mFCjgLT+dgN6rGt+lGqKzB7Oxt6zBchu1L5o03axreeYE137/N3dOW+b8idhwha+iMvhVXvMLaeKmn3D4BsmAMNGt0ofVOiBYfj053o3i1CXz2YYgZ5RBsejK6yiw2xCXaiVR1tG97vXFSswvibNG9/+nxoe7onqoa31Z5qESNJMUnAxkCIM3PeBU9k/xEi3M7+qDr2rOgvFWY59Bh2fEhz3VrGM55YoEv3kJPLrS47cHd9V7rG6uVdF+avZ1JJUE/Dq3gEfMJK3Vj52ncwPVS/Q3HezRSYgGdyuR9qON81rfaLXWde9KcadsZRFvI+Eq3OIg+tq9PTJ6tYpqLPlchsTEa5JlGKyhkgMjWP8BdMKWvfvgul9hQmLjbjqIZKRq40RVSV5lJIDA8HFx71GTL05So7yO1/gWVLG5fn6b6pavjJL4v6jluLW+c99tgC9rq5e/aTHJeEYbKvRqXuTT0clPhIQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3lrbU5hNmhWK0k4cnFDQy9aOTNxanF4Qzl1R2dvSUZCcFdDbVZpTHhpd0Mw?=
 =?utf-8?B?RCt5MGIrQ1c5T3dwcEZIM3FXNkdJTUlRSmdQV1Fzd0lSL0E5Wmc0ZGtqREZP?=
 =?utf-8?B?d0FseVZHSHRMYkhXa1RJdE1CbGlWRDYrbVZGUkZ2dXlZektHZjN4anNwMTdz?=
 =?utf-8?B?RUdBMzBDWUZieFlSVlljWGc5QUxWL2VEaDVpY0FZRVJxT3YwZWZyTENOL0xk?=
 =?utf-8?B?czFaTTA2ekVNalVqRFpkY2xtYkxqWFFWazRHb3VoaWRlbktZZVlJY1o3R1Av?=
 =?utf-8?B?K3NYaldhOGhseUEvMURQdWhGazFHMUNPSU11V0Z2bFgzYmV6WHNqVERIOTRX?=
 =?utf-8?B?Q1JIdFRvRGNzK0VENDhhR05wRXNwT1VMNmpYT3ZtdDJNeko0ZVhuTEEyWmsw?=
 =?utf-8?B?S1k4Vmo2VmEveTNLWDhzZ2xmRWtHSlJZZU9qSUEwMTZLbTkyY0pSNEoxcXJY?=
 =?utf-8?B?UjJPZ0hEK2NkWkxKaDAyMVM5UnZ6Q1pTZFpnRG9Zd3JFK2hBL0orZVd2TUo4?=
 =?utf-8?B?UExaY1Z2eFRrV1c1K3VkUTZkakI2a0VDZHJ0VWVFRVJHOUFMdlZtN1VTS0Ni?=
 =?utf-8?B?U05SeXpRRjBra3lBUERwSVIzVitBTWVTekNaQUVXOTdjZFRsTWFyeitJbmRj?=
 =?utf-8?B?RnJqWkxpSk0wWExhcWJHd0dMWThHamkybmNwdVduV2N1cHhGYzVrREtCaDM2?=
 =?utf-8?B?YWEraExmRm5OZnZLdEJQanFJQVkyMWlFZzRWbFNqSFB0RUMxTEl5d0cvNW1U?=
 =?utf-8?B?VFc2dDhtUk9UanAzNmtLSXJ3SllpbGsyTTl1aGlsZTRvYWtkalEzK281dE14?=
 =?utf-8?B?b1ZlMkVJREZnNFNqRTVMQUZCSkh2R29GVW1iSTkrb3FFcTh4STZFa3JHR25v?=
 =?utf-8?B?TTF3dGMzbmhhVGxFVmRwTzFwbjlMbGhtUGFjY2xiQVNSQ1Y5NmxvZmhjUnU5?=
 =?utf-8?B?TTFzTVo5b0Q2OG9WK3BFVmttdFRqK0Z0aXlRbEhxTmkvSS9UR2QvbEhoRldE?=
 =?utf-8?B?TytScVNQQWJkYUdoa1ZETUkzOWJNRHpRcFJmaTBQVStHNGYxemhaTWhhOGJC?=
 =?utf-8?B?YnZoZ2xsSzZzY0pvWUsxMU94alR3Z2o4b2lLSFM5OWxOSFNkemZ1bUozdFUy?=
 =?utf-8?B?cVl0cHlkQXBMU3lrOGpMV0loQXZPWXR5MEhNTXVIanl5WmcwTWJodlF6ZlBu?=
 =?utf-8?B?SG5sVEd4eGhIa0hUZWV6UnZna05WdHcxRk5ZcnlIL0FnbVNlNFlyZ3FsK3N6?=
 =?utf-8?B?cW1POTU0UWJCdFJPY1lEcTdGQTlTT0l5ekV5SmZhek0wa0w2alVaYnNFU296?=
 =?utf-8?B?VnFMdnZHTituTlg1MWlPSU5hWUw1WW5HdVVGMGNzU1VHT3dRZnZrQ1VkV0Qv?=
 =?utf-8?B?bm9mdVBLSXlCMTlyaWpDUUQ3dWpYeVpsd1VpUGgzaEl2Q3YzNUJ5bW5yekhp?=
 =?utf-8?B?bHBWUE5FVDhFdVdXNlN0c2I4NlV3WjZyaHhKdzhmVDZ5SWVzNDYyVUxiZ0ZK?=
 =?utf-8?B?QVZTRzc5L2lLYmF6ODNmRUc1eFZIQ3MyaEppenMvRHBqS0FLdDBWM2Q3Yy9p?=
 =?utf-8?B?amt0OEJMWXZiOU9SUnh6ZVgvTjJJMjZKNEdGZEk3OENmRFdXbG16dHBUTnRK?=
 =?utf-8?B?M2JiVUt0SWIxOUJoeE4vSW4vUGw0TDlXYWo0MllzcVQ1bXJnNE9uVzVMMHlW?=
 =?utf-8?B?Q0JyM1psL1RYMytIM3dIRS9TRXZNWG5Ja1hieTNTOGVwSGh5YVdyakV3PT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ea7ddb-6101-403b-8296-08db12f4bb3f
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 03:44:12.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB3211
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More explanation to the meaning of performance data

 >>Mode Iterations   Variance    Average

Iterations: the number of executions of the same test case (each 
iteration get a performance value of perf[n] )

Average:  sum of all execution and then divided by 'n_iterations'. Below 
is the pseudo code

                for (sum=0,i=0;i<iterations;i++) sum+= perf[i];

                average = sum/iterations

Variance: A percentage value describing the overall deviation of 
performance results from average. Below is the pseudo code

                for (deviation=0,i=0;i<iterations;i++) deviation+= 
square(perf[i] - average);

                variance = ((square_root(deviation/iterations)) * 
100)/average


On 2023/2/20 11:04, Eddy Tao wrote:
> Hi， Simon:
>
>     To have better visibility of the effect of the patch, i did 
> another test below
>
> Disabling data-path flow installation to steer traffic to slow path 
> only, thus I can observe the performance on slow path, where 
> ovs_packet_cmd_execute is extensively used
>
>
> Testing topology
>
>             |-----|
>       nic1--|     |--nic1
>       nic2--|     |--nic2
> VM1(16cpus) | ovs |   VM2(16 cpus)
>       nic3--|     |--nic3
>       nic4--|     |--nic4
>             |-----|
> 2 netperf client threads on each vnic
>
> netperf -H $peer -p $((port+$i)) -t TCP_STREAM  -l 60
> netperf -H $peer -p $((port+$i)) -t TCP_RR  -l 60 -- -R 1 -r 120,240
> netperf -H $peer -p $((port+$i)) -t TCP_CRR -l 60 -- -R 1 -r 120,240
>
>   Mode Iterations   Variance    Average
>
> TCP_STREAM     10      %3.83       1433 ==> before the change
> TCP_STREAM     10      %3.39       1504 ==> after  the change
>
> TCP_RR         10      %2.35      45145 ==> before the change
> TCP_RR         10      %1.06      47250 ==> after  the change
>
> TCP_CRR        10      %0.54      11310 ==> before the change
> TCP_CRR        10      %2.64      12741 ==> after  the change
>
>
> Considering the size and simplicity of the patch, i would say the 
> performance benefit is decent.
>
> Thanks
>
> eddy
>
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
