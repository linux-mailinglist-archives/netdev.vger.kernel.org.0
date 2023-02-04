Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE72768AAAA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 15:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjBDOrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 09:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBDOrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 09:47:15 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2093.outbound.protection.outlook.com [40.92.107.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C3E5FEA;
        Sat,  4 Feb 2023 06:47:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgFJ+PTopEuZbHnpI3ZJx96pN1FbKLs8/H7cixN6TZOcuQ3ddVPLEkC3+UPcgp8XiWbUriwRfxVFKGykJssDiWmUKbu8pmZ1ow62oQOdVvbLA37nyA6AVayIsHpeaQIQPE7GU8pMZf5JMWT/O+ip+tS4lWShRBFiyhsFYJPbZv9Lpvs90z1ayYXt9j3DVmMmRNNVjJFZMKfBLF5Jj9tbbiu+UAIatKjdWleR44ZSVjOY8LZTRODc3Zsi9oUANbstUPcTn5g4r2NQuY8hTVcWk5thKfNxHLvwaYe6GR5JXlj4h+VB54kCPKWiLlpTcqMVPe6aABq7lWd5guWPSCi3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciONhQCgkB4YqGTj7FRNwnJKTZVQKYK6tqLQ4d7Qku8=;
 b=O3xcan4jfYrljeVmeslioQM1l9WURmyvGCtR2inzohgB1j3HKGmJRN8PfBQq40PiaC8xS0O068mnmE/7l3uBs6J9nL6C4tyKDZT90aqgevnGa3V8U71UC51aSU62vKoiroQyCOq/S/cDJ6ZTPFNC/XSS2qETtYUlb9ppJvhXrbGrCUhUGizXO2vqOWAmTmOxxEWn+c+16Gg3o4LZ5TvMnlSHt9Np5zoTs+ze/ojI4u+NuP4cxtEI0SiLjDL+M67PwIGzol7gWAur7Spa6xaAtmKScKUiAQoxHN0oK4EOzINsQZDVbqLGkTUQweoRrW2DS4WG8PiC0nA10qNMOH5Niw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciONhQCgkB4YqGTj7FRNwnJKTZVQKYK6tqLQ4d7Qku8=;
 b=Ei+H+qMOtwOz0PW+hOjiMLErpiF1yAQVrqg9vu0l4j4Um+uOPILh3gBLK7ppYIDLz4CoSt67eWWENX35Z7Ap37Fdb4fTnsVG+IFuPN/WHLfXtbKGMgFu8fp8NLx7/auZ1ZFSjp5kPD00eWYHDNq3kSjJqAgASV1T2eDt6FuLNYyCrnM9dN1eFB6aSpOiJ0qmmoOEH2QAsgACsxARJeKtz8ySjdmr3aaSBCUXJRQUG/3eYDvJsu6c+2iIEl9uFpDLHTh+XjRUAkpTI+WYhR7nmOV+7edOIZc3dZ+I2dkjWQ+3VFoat0aT5K9JMiRxbGZ4M9uzhV7jOztBfp2FQN/l0A==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB2165.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:194::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 14:47:10 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6064.031; Sat, 4 Feb 2023
 14:47:10 +0000
Message-ID: <OS3P286MB2295A2F3A8B58054ECD87D8CF5D49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Sat, 4 Feb 2023 22:47:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v7 1/1] net:openvswitch:reduce cpu_used_mask
 memory
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB22957550350801F37FB56DFFF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y95ddddYhqkR7b1o@corigine.com>
Content-Language: en-US
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <Y95ddddYhqkR7b1o@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [932KRS+5qeK0geHOoGglp1oEf3nm2GBc]
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <6cf03bf9-a3d8-5375-3dfb-27013c2072b9@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB2165:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bb1575-a837-4049-b73d-08db06beb225
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kv78iYxasOruSKxeTJguyLrZrQt9ftRpi5qBbQdKpO3GBuFZW3HcBJpiB3ed4LSVmCrAIZwQgXAOPFxtbSN/l2LkAzhh5IFP0E+F3XdTQcYiC3mfMt8klehs/C7ScI8RtUyUyZbqnkM8Q4wJsIKUCu7NAcYku51eCipkM5/krGAOkCClHE5gTCdoGKJ/zXBLu5xfFIHTo/1Qq6leltoD0R+x8BolywVG7XmThWvvHS1aAxc0UKPY3Wb/ATEtvlH4TccCF7gMbGq9W0IBaA1eGJCtMhCpDakdlv/ar6SPcSJNuHQWcMUUcZCLj90Z84JAPVxOZ363gyqYETr53IAlqXc2qPzjSSW+eJ9Vq2nhUH1fgCxq3qypi5kfNirh6dfJ73CdP7n7Cle8YHnbcpOAWYsW0+STcIwBq8BofI84XCuc5qekPQsK+rkatBQwhOkY5IO+Q3iywOnfIA5rEECkwQiqXsbkjcOJ4Wy714xjPX1naTjRXw5x+mr5egBs5q5ZcM7e1bwmJogjqXRHML3pv3QgC0MQajgDNxSriQygWA+O7QvmhfI8LebdpRDs3JDrLESJ1x4HMmcttrzHSEhLfT7MeOoCFGfpXrjGSQz+B1LyV4i0wO5NvKbXGE7ZsP4hvjnlsUbsAjfVSI6vMkjvDQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mmw3K01NaEdrNlBWNmd6TnJnVXRlK1RoYTVTaUVid3dQYVdvMTRTTUdaRnhU?=
 =?utf-8?B?eXk2QlpHT1R1dTZ2VFhUTUc0bFN0dTl6dXROM0MwdDhZV1BTQnR2Vm9mOXE5?=
 =?utf-8?B?bmcxTUF1aU1lOERIZ0RKcmhyMEdGK3hJTVRWUjYvUXRaOHRlQVVvcjRsalJo?=
 =?utf-8?B?WU5SSktETENqT0N5eUxodzl6Z1M3Y1FDU2N4M0JhUjhlUDRXQjRGMzBRSVBS?=
 =?utf-8?B?UktyTDc0WDNYZGN6TGY2WktKSHNXYitKTDd1WUhuNldCUVFmS1B2OG5CQlJZ?=
 =?utf-8?B?bHphQTdNd0Vkbk1xV2twWlhLK21sVmlMWXdlUi9wZDhYZ3FrNG5HbnNmdDRz?=
 =?utf-8?B?TDZzV2wzTzFqSGJidHFkSG1XSkx0RGZUczFjTVBud0dZa3dLcy9uT2pkbVBF?=
 =?utf-8?B?QXRDZ1VMdWdFL1JCamZyVmFIcElZaTFIdEFaNkNYZ0lxcEZRczUyaVpCQ2pO?=
 =?utf-8?B?dms4L2VrZUF2Nm54NHNrQVpJTHZneHhYMVNETmtQOFdkZGtubTlGMW5xRUlE?=
 =?utf-8?B?em9nMmRrZDNGNWtJcStYbkVoeDVjbWlCa1ErUkhDdGZaYUlHaFV3cEtwNmVI?=
 =?utf-8?B?TzRKSVpoRmJ6eHFhV1pQWTFPQ0NLN1FTWHRHMGl4K0hrVnltY3J4YldrKzBh?=
 =?utf-8?B?angxV1cyR21pLzZqU1lGRkYyY1JwN1p1emlYVWJkMVM1WWVWYm0zTFdUUjQv?=
 =?utf-8?B?d3E3TWovcnNrY1hlTk8rL3dRa25iRlc1RllsYWVoVWdGb3M5ZW9yTDYyeWFi?=
 =?utf-8?B?ZVhMZVZsdTZ0YW81K3czSWc3TWRwbkRkOWVYRGNiVkZjY3FtWEZGWmhaQk15?=
 =?utf-8?B?NWFvTGNBZUx3VDBqK2xVTkx5dUI3OHBRNFAxeG1ic1FsWDh0SW1Gb3lzdzcx?=
 =?utf-8?B?d3EvcWpMTnBjSVJqVlUwTUZrSytMYlJQK0RFOTVPYmpLNDhYSlBzN1JhQ3JL?=
 =?utf-8?B?dFhsYWhtTTlNc2hUS2xhd2hiQjlpUXhCSGtnWlV2dTlTb0dhZFFNOG9LUi8z?=
 =?utf-8?B?VEFtTDF3dE5tMTQzZ3pXRlZYL3c4UTZwRlZDRXJ1cjI0WHZZaHF2aGkvWjdn?=
 =?utf-8?B?NWFwYlJZR3ZickFNY1pSZFhCd0xYS0duWTNnRlZiQzY0SWFURDlGOXFUNWVS?=
 =?utf-8?B?QTVTeUxWYlVUb1RzNklWVExNR2g2UHVrbHhxYUt3NUlNaVF5bU9IRzRyeDVp?=
 =?utf-8?B?K2dvdTZiak9SYStoVTZ5b3RkeFNuMGxHTC9uWkt1UnlWTTBjaEo1WmdFSEtY?=
 =?utf-8?B?UDRHSmRacmxrMElNZkk0ZCtQZDMra2gxSHZwNDFET0d1dlJYSFlPYThQeS95?=
 =?utf-8?B?M05yNWNxRGZHRVFHdlV3QU9UOHFnbXpBbjNzbmRKMGFBaG9aNUlVTXlsdWUw?=
 =?utf-8?B?dzdoZVowblUwZ05JK0FBaHVxSzJuVEh6S2dLRGhDSUZnOEIxL25WWC83QjVy?=
 =?utf-8?B?YkVacWx0MU9NY3NweFJaMDZvbzgwVGNFMXVhYXIwRGl4V0pvRFU4MWx2VGpH?=
 =?utf-8?B?bjltbG5JcE1ObE5FTjIrUi9hRlN0amo4UWtTdlRVY2dGOGtObkxrQVkrTWo3?=
 =?utf-8?B?VzRaM0pnWHFmeCsrTFdseC94cWtvdjIrWnRHclh4Qm5NRmJjVUVYbVV3a0Yw?=
 =?utf-8?B?UEQyQ1JJZU9FV25kMjVncHJiUTNZMXdyYWNaOTR4LzZKenQrVkptS3F5UzZy?=
 =?utf-8?B?YUhSV1QrVlVtc09Gd0RhazU2RnJWZHBORVBhWnQvbXlhMUFLekk1NkF3PT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bb1575-a837-4049-b73d-08db06beb225
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 14:47:10.8082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2165
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Simon:

     Thank you for the time on the review.

and i looked into net folder and get various results

'net:', 'net: gre:', 'net: bridge:', 'net: thunderx', 'net: sock', 'net: 
genetlink', and there is also examples as you suggested like 'devlink:'

similarly, in other folders i see similar inconsistency, mm folder is an 
example.

I turned below links and did not find item regarding to the prefix 
definition

Link: https://docs.kernel.org/process/maintainer-netdev.html

Link: 
https://docs.kernel.org/process/submitting-patches.html#submittingpatches

Going through the git log in file net/openvswitch/flow.c, the 'net: 
openvswitch: ' prefix were used in previous commits.


I think the fix contained 'net' keep the prefix from name collision and 
better keeps it consistent with its neighbors in the same file

And yes, there should be a blank space after the colon, i miss it, will 
update the revision, after we nail down the wording of the prefix.


Thanks

eddy

On 2023/2/4 21:28, Simon Horman wrote:
> nit: I think the correct prefix for the patch subject is 'openvswitch:'
>       And there should be a space after the prefix.
>
> [PATCH net-next v8 1/1] openvswitch: reduce cpu_used_mask
