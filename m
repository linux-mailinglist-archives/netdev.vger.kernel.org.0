Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4486546AB48
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356433AbhLFWSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:18:15 -0500
Received: from mail-eopbgr20099.outbound.protection.outlook.com ([40.107.2.99]:43142
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356335AbhLFWSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 17:18:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfVgNQZ1AurXg8KWWWKsBqBCB+JUbLpa05qyWwNkwrk+lzDihzaa+RdavC4Dz1nxoB17u8q7MYgyOSFLQ37FgXY14adc3KSH58zbP6OrrAzkcouXtctae2A4KFR1mRwTSGNLgOTJUmssctJwQyhGnB2NIuGCzsldlCNN2AdqECsY2FIsYFDJPrt2wnzh4ruU1uCM6hTOQyb9XgyLTJUuN/6KqKzQVA7SvNsAcjOpmgM1DbZ+PQchZ8feNwbpQz0NkUGX6elwITX80mrynT84f0+t+hp1chmG4sOxkL2By+EZEvi2p3U+nMuMrNlPsmrWI7C6kURIvOJfQAtdkCFijA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsV7hYiOFkUWJ9dYybQLT4F21L+ouF0hhccum/9MhjY=;
 b=JuUVYbgyKHpczD0SQwCIVBZ4w4fVurmXV4dTwkNOswhQdbaiyGMe7pNxl8yU2dYpPz+JPm3DeNvLZaQ1SKX/ZvcERt8U3j77zvx4UHlOA4qXM9DdB5NZhBbN2UAhkBij00TDzI/IPAWUcgbn7i0D6ckDy+xjfkU8bMKPL13fR949ESugL06OfdrR9Hfr5eyt69MLoG0L5mepkRq8rNgfcsGydGfNJHV6+Z5D6TlaGse+480w3PvSM0Z5UB/bz1zB7/R2v9dPa6S+He+y3Zk5S0JZfGkyjxdxlAjBIvTVVqYF2+Du8+Fr8lkfg+h1nuW59ecM8bm3rqAtk1aUkrdGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsV7hYiOFkUWJ9dYybQLT4F21L+ouF0hhccum/9MhjY=;
 b=WfjVXwQULCoxWYLD29/ipQlHlvBuPH6UaN8KavVOtzaPqq+CTTGFfyHVkqDQZiv5TpQ2XwRmUabFN2CT42q2WYI0nz3xkvq2eyIJ3q/TnKZfNFEYvsLo2akTl1onbA56rQJrodU7rkZQbP3Mk/20qkT+83T5tqqCjouPM86yhmMxCl7sPFa+Stndus6Pkmw9ZO7Uc+Awap6OzEUHCDacw8KnKHDxnOS7e0PUtql0x5ZP7uffNYR/9/yYr7yYibAFJqZ2APg4A4mBtt8fYkKqCqxKGympL9enmFUcUvjk9BLrPNYYx9vGLc8TB/P1yhygUVswqBACpDTh0O+9AFkvEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB8PR06MB6108.eurprd06.prod.outlook.com (2603:10a6:10:107::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 22:14:42 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 22:14:41 +0000
Message-ID: <cfd7a6c3-dee9-e0ba-e332-46dc656ba531@eho.link>
Date:   Mon, 6 Dec 2021 23:14:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 net 1/1] net: mvpp2: fix XDP rx queues registering
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Louis Amas <louis.amas@eho.link>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211206172220.602024-1-louis.amas@eho.link>
 <20211206125513.5e835155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <20211206125513.5e835155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0111.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::27) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a01:cb1c:80ae:d100:3374:b07f:907b:f9fa] (2a01:cb1c:80ae:d100:3374:b07f:907b:f9fa) by MR2P264CA0111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Mon, 6 Dec 2021 22:14:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a8084c4-723c-437f-a9e9-08d9b905cd00
X-MS-TrafficTypeDiagnostic: DB8PR06MB6108:EE_
X-Microsoft-Antispam-PRVS: <DB8PR06MB6108D83D7DF60CBA51CD3CF0FA6D9@DB8PR06MB6108.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8w67Ul+Bqewz+DNn+Aoro7lRiKq+uwgmaWcB7rgZTbjKMASU8rrdg4DscflS4hwxDKHd3ZEh4P7sQZSZD/d4aODla68pLwW3HfmuhT0g/XGL4EqdEXZl93mWtMaHq7v46DNV8gQG3Y528zs8fI7rZhSjY9i09ekWhhSczja8/sj/8axR655kh3BPqg8dtCrQNPktIOtk2lqofMPH4ARbvzjrwNx9jyiLrfiGnbvqgoZXt56ZQFWifoYn3JdAMHlYlmItZl0fnU/FeoC7s9QVRhTR0cO2ns5MWBCNpwqUxY7k2xmWag9BKgz0EeRcv8elFMvQmChsAWTsR1TzNFpJra9Rn3nZDgKlEpKAICenTdfqmuzWAfm3a8AGeKm8VvqsHsUdIckL4tsQKiPdfXiPe0e1HtlNBxuT1KIM7pQvt9Dsq92rg2/3s3cWXNhk0DPQCW+ZyB9Q07tLoU/bKXt5RgmQe3vgtxAx+fIiLbudEptgjK7MC3Oop3frzDDhX9F3iyzLMl5XNLQYzeqlnvGr0EX92/5MwOOm17aBIsZevnxiwuQBYofQCvTL3QIPGfH4ArBZc5C+LmYU16vdd5l51RpKI1w2+JdlW/OmPTd/MSNC/XeCYmV7I9TKMizV/DV+dj+fUvZBo0vUR5XwH0QfcXe9siNRPsH3z65MkLjWGPancXhSwaSjBIKe15vg6RjJT0j0hoi02NXN2QEgzPp73+SgyuHmD/38jzfZfWWRDiyPJMEon+PtbA3YRI8Tv7qpm86rrp1JQ+Qu/HkL+I9AIdyUQqlhieGBZ/N3Q59vmzr42ytdzH3PZRToB2V69KRR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(396003)(136003)(366004)(376002)(44832011)(86362001)(38100700002)(508600001)(66476007)(66556008)(5660300002)(6636002)(186003)(53546011)(8676002)(66946007)(36756003)(2616005)(31686004)(4326008)(966005)(2906002)(52116002)(6486002)(110136005)(316002)(8936002)(54906003)(31696002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3hZQ0VXUExMcithaGRnUWt1VG1ZN3FmNFQ1bmNPTHBXa0FPV3BldFFWekdJ?=
 =?utf-8?B?UVNubGEycTRMaDg1dWk0LytrVVVRQ25JRzUzZU1heE1yWiszTGN3Y2Z1Mlcx?=
 =?utf-8?B?c2hvRkR5dHNLdXo4VFcxbmFmOXBLRDhKTzFhWDU4eHIyc2VnLzRleGdFRGVs?=
 =?utf-8?B?OCtoZWM1bm9vc01aQ2dPZXhFNHM2a3V3alBPckxzTkgxNzFtUkRRTmpIYkM0?=
 =?utf-8?B?UmlIdVJXbGVwV21HRjQ4VDlUeFdCS25iNTJSOXBacHJMNmxpVXlLdXk0UTZr?=
 =?utf-8?B?R1EwYkJXbHBnUm9TS2sranYwMVhJMjdla3NRNHVQQnhZZWhHVGxqTkl4bm1s?=
 =?utf-8?B?aXZmaGUzVThra1ZPYWdIYzNNQVo1OWF2MUJMN2VheWhJRkN3cjJrTUc3OGJ1?=
 =?utf-8?B?aUFCaERJTGFtdlhPbWpHc1hmbHJuTkJsWFdQOGtDbTBHZkpXSnFncnhodUtU?=
 =?utf-8?B?ZWt3alpWUlRwM25PN1hIWU9Ia2Njb0oxdFN2STN0OEdYN1VpV0lCRnZqYnlY?=
 =?utf-8?B?TkhpWjNIL0IvUERVbFRwbmpXbUg3MzBwVWkrU2tHdU9VTTJkWHpJSDdGdWZy?=
 =?utf-8?B?c0sxRExPYVh3MmxUOU10U0t4cUJ4MkkrNXI0R0xVOGFqOTd2WEtpTHEwNWtF?=
 =?utf-8?B?UjVCMWZkVWplVGllbkZIcE1haUVoeVpCM3dvV3VDbndTNGJ1TTQzMndPYXlL?=
 =?utf-8?B?cGNjNVNvRWFQbnRSZ0JaMnhsajVEWWdnZU8vbEdVSmRPV0xOekswQ0tpVTd0?=
 =?utf-8?B?TEtkdUdwczFUQTdzSEplVjE5OENDQXB4VUNpamtCUlFIQVB5RmVuSmFyc1VE?=
 =?utf-8?B?Wk51UU9GUFJFM3NHUWxNL3Q1dElDb1NZWUdJUFJJTTBseDNGTjlycGFBWDM2?=
 =?utf-8?B?cDlxOXI2UlJaNENua29NNGxKOXlnU0JhdzRURnBqRTVDbzY0eHltVU1kQXls?=
 =?utf-8?B?aDlrWmJOa01QN3I5UGVjZnRUdCtNQVZQLys3ZERUMk5uUStKMXgxLyt4dUZV?=
 =?utf-8?B?WkNmcU9jYklYalJtanRNaitpZ25sTEIvZEpmdEVsUmE2cDNJY3NucUF6ZmNx?=
 =?utf-8?B?dVBueUJ1RDU0SmcrNnBNTnJqWFNRZHVsUXZiZi9ZMEtQcWsyc2xTbk5BeHhQ?=
 =?utf-8?B?ZXp6MG1NbjZjUkNJS0ZUdG1nMjlYOWtvMGNoRDgwLzk3cUdoWkZiajlyRGY0?=
 =?utf-8?B?YjM4akpGNGhhTVBzMzc5QVpnelE0MFdSa1NWK255UE9kTTBhb0crQ3pnQzRw?=
 =?utf-8?B?bUl4a29nbXJBUk1rVU9LT1pJVUFaeCt5MFlyWWlWcThCRFZCb2VhL3ovQ0Zx?=
 =?utf-8?B?R01YYXpGTFhlOVVxMXJjSVduUlV6dSt1UmxYOFdSL29yQVpib3M5eFdFdU1V?=
 =?utf-8?B?dkR6dk1rUnhEVTFlMHpmeWpPdkd6bVRrL1F5NFdLQnFBZ1FTUTgxNnkvSkxQ?=
 =?utf-8?B?cFZ1M2kwK3JRV29nT0hIbHhZYWY1WWp1bFhybUNCbmYxWUNoRGVpMlpIZFNB?=
 =?utf-8?B?QVdkdEdVUnYzNm5HeU1aU0t2a1ZZZnF6amtMNzNhc1BGb254NTIwTFdsK1Rl?=
 =?utf-8?B?U1dOTzFGRG9SN3JoYktXS09CcUJmU3Y0cTJEY0U0MFVzbHdtRzhSc2lvMzBw?=
 =?utf-8?B?R1QrSUt3a0VxSFEzWkFTRExwZHFseFBYMXhRVktqc1MvSjVSNVpvZ0lqS1dn?=
 =?utf-8?B?UGtuWGlwR1dTMTdmVlZwbTZIMno0dlVJdlNyN0xIRFlEd0QvaTJOYmFKUFlq?=
 =?utf-8?B?RGpSS2p3RnpFS0w4L0lBczRITkpvbzdlcTBITE5iWmUwQXpBVzFoNDM4dFJO?=
 =?utf-8?B?NmtWRmJqeXF4Vk4zRXFrNlNnYjVsd2RmNTBVdUN1dDJJek5kbTJUZXkrTkpJ?=
 =?utf-8?B?cFJuSUFwUnc5YmFIUUpvK00vM3NYTFJWZTdLYmRpKy8xaEFiampKNEoxbThU?=
 =?utf-8?B?dFR1UlZ2Zk8xbnpqSkxFcDdBV0dEM1B1M0NGR3dIZkw0VE9TcWdkWG1zRDVV?=
 =?utf-8?B?dG1TWXpDeGIvRWd5SmM4bVF4Qy9hbXpMaVA3WE9heS9wRytocmtvNTFaOHRj?=
 =?utf-8?B?OUc3bWNXU0ZUNEI1LzF0QkpxUG5rdzJTZ2xlakIvN1phTXQ2WDh0SFRKSjVV?=
 =?utf-8?B?MVA0S3E3RklDY21WL05TSms4d1ptZ2FZMVFRSUZ4ZGQ0SFhwSmZ3VUc2amZH?=
 =?utf-8?B?clJVZ2NiUnBJelZ5U3NFajk4VnZtS29GOGtMcFJ3SG81ZUcrcVQ3Y250SXFX?=
 =?utf-8?B?ZTNBLzFjOTM5ajN6OUwzbG5UWVV4VGdzNENJemJoZTI5Nk5mK0Q1VmlXK2ZU?=
 =?utf-8?B?b1E0d3R6aXUwV2x5MGl4M21xZHRFSVhFanIwTzJiTVhJSkxqRU5CNm1HdFU3?=
 =?utf-8?Q?/j3OoUZcM7mWbkVs=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8084c4-723c-437f-a9e9-08d9b905cd00
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 22:14:41.7114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3SzpadITb1XRYUdahjWjUkig2ZzY3tVuATADnQ4lvyq7KoQY3vBRTZG/GLXdNnrR2SQSnIYj2PnB1eJCTIQduY+hooE7Fm7psHCAZW+KAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR06MB6108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 06/12/2021 21:55, Jakub Kicinski wrote:
> On Mon,  6 Dec 2021 18:22:19 +0100 Louis Amas wrote:
>> The registration of XDP queue information is incorrect because the
>> RX queue id we use is invalid. When port->id == 0 it appears to works
>> as expected yet it's no longer the case when port->id != 0.
>>
>> The problem arised while using a recent kernel version on the
>> MACCHIATOBin. This board has several ports:
>>   * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
>>   * eth2 is a 1Gbps interface with port->id != 0.
> 
> Still doesn't apply to net/master [1]. Which tree is it based on?
> Perhaps you are sending this for the BPF tree? [2] Hm, doesn't apply
> there either...
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/

Strange...

AFAIK the commit was added on top of net/master (as cloned at 
approximately 17:30 CET). I'll check with Louis tomorrow morning. We may 
have messed-up something.

-- Emmanuel Deloget
