Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10056CB51
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 22:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGIUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIUJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 16:09:55 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF8F1A06F
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 13:09:51 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 269K1JMI004349;
        Sat, 9 Jul 2022 22:09:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=kyt4i3NaaWbPJx5YLVaCCoDNjTapIJAD1xX8/p2JfQE=;
 b=qHXl/r65Kx3QjentXhgbaMKO9XNSVdLkwrPfXpi9LSe32yRPIK08gzWyHJUwx+rf4Hc7
 rYJMF0DbnXsDkhsRR71qK1efdk3chC+GUnPlpf9vaDOQpHNC+/1lgNmHzReE1qezG/Q7
 EqhH3wmyxEHzfXjaNsa9UahHH/HdR3WWSFAZI1a+/azo7nnhPHI/oPhtcAiXf20J/lq2
 vxExoT15XDtSRcelAu4uhYK6aeNV0YUg8gJjRynSHY8gHfz1WztcvoJo8X1+ATr0qTij
 DY7NVMx2TruHC7H4bDkBZu5OlYIZ4SKu6EMiZnizll3T93O0ll/fhhWQEI+Q6Fi4QI3Q Jg== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6x1c8p7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 09 Jul 2022 22:09:18 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Sat, 9 Jul 2022 22:09:18 +0200
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (104.47.0.55) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Sat, 9 Jul 2022 22:09:18 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6Ylul15LmMItMrzp0GI2Rx1kM8HMl2SXATwWuSjt5/2YtqopbP74tTGWfVh0sErD1ZwmsLygT1uAFNyGoy1W81QyeUAVbVylO6E03ugfUOl/iGLVglR0pWLl2ayXIuNLHnko8WU8vt7r3lyt4OVT6XRPw3qMaulne/E+3hmlkke+7hanMOc9gpfQxfYLv0hzUauur74hmjiMsLAXJUuCyAyXnkJQZ8GUYDGfWqpE3urPUFpEsnd6DVfeiaVjrJD9ypvgh7AkXjnu6j1QKxA3l8FnXwnq078U4dEefPKEcGiX5eFBPMOt1gl12/L1kBpnwqQPZhrRnFcr7SxC3rkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyt4i3NaaWbPJx5YLVaCCoDNjTapIJAD1xX8/p2JfQE=;
 b=TTYFmUJJa1g9lkDT0La1JXY3/1L/xBx7JhlvU8b+rxxY9W1E9uVdLaBXtVecjzNHRxjB3Y2hj5WgHfzG/Z5J7zpahpMDjwfCqVCNGlE1UrGitQ9X8iBm2KReS/qooVmPHlxHUE3LRn5J+8koIHJtBWVFBauHvjsVI2tJu771QSw1nTbqRCK+BWsK3gtP8gHEc+o79k8MLoxnRJozGI8hy4p7OktdlmR7m2wwbMhN6UuEVjqN/QnaCJsfsJtz9SxrKA7SN0RtvoJdaEBohXUNJa53DvUHbMlUih2x7Ezctrg/PSG9mXvY4KtrF8SQfCfJ2P6EiqLoxghDn675A/YKVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyt4i3NaaWbPJx5YLVaCCoDNjTapIJAD1xX8/p2JfQE=;
 b=irb11i5ybpurciQRdCa8Ptmp30L/AhGZA5tQqLFQglKrLRs6nR7WvT57TRnqr+RNvZSiDHOi/qekTSAZrHUnJtjN3M4UA/irurZ2Ti19tAfsSGX7ZP3NlvRnguJ0NY6Koml44oYsG0We3o/mb+Cl7ZNzpEgoCuKtz+a8WFVxe8g=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by PRAP192MB1602.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:295::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Sat, 9 Jul
 2022 20:09:16 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%7]) with mapi id 15.20.5417.023; Sat, 9 Jul 2022
 20:09:16 +0000
Message-ID: <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
Date:   Sat, 9 Jul 2022 22:09:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
From:   Matthias May <matthias.may@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
In-Reply-To: <20220707170145.0666cd4c@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TYxM0hpGWGxrd2wJNtJs6lt0"
X-ClientProxiedBy: GV3P280CA0036.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::23) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b21c7ccc-c2b8-48fe-ce08-08da61e6e64f
X-MS-TrafficTypeDiagnostic: PRAP192MB1602:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: miCDDCBhxW8m5+yS7z8rc9XAdzbj2/8/bVxu/th4LT7KpkQctc2BGNhEUtF2KstK7f5nwsR5iw9qevzdTxLswAK3eTgL/ElxrjDs/1YPDXzMAiWrUezAkynQ95o9ifS5zIHSjE+wUxPa5+zlEt2tcwFyBu1OItMwuY4HE9vlPHmJ3et/BSTJ759PZbizvfusC0D6eU/pUMAH9RjSS1jhqV+k2I7A1ckQQtFtsWt64YXFuJ+9qSUxGPyx7f3HF2LIcsUfssyI+qY3uZ/L1GqNudxyv6HIafuNqpm6xAF44oHuD6a25GrIsRftTe7zykYkEv649rEgR6TPaTz626J/ZY9GJZ/MDIZd81h8n1hRnR61+/fMOOcyKbreupNCxtlNkGu1vMKgYDMTJfu4zF3W8LYfV+5rR7NFc8fDUkp24c+bJbjJOns9V9T+wXUXp9jqJrhOFdb3kMgggZsxRXW9Hu/Y68g3voL4EFbiriIKLBnGmAdf1OkUk/dGA3xVwSFwOjmMPaypiMNoC0weyCtoYS7uGVJdjJUzf6xBmZh3W5kAOjAVfy+BBWwGqbrxVZSUhJOpOyQ7FRUyjqPWIIwAyQxMhtMziUJu67hY9KELt3bXlSeG8vml21cTOZVvPoFYJKtLQqmE/abHVBP6ddcgJjEcbm2EP7ete85FlcXUgaGBl8QP8nkgJjTjF5tguK/xrt+0UsZI+35EuXN4SLoeoLB62bO6Wo9I5+E8alhJO3lfKu7a3epHOuczWwYTx2gCrXp6qkRUSBxFQ9apJejMyQXhtKEA1SQ1SZYLwQZMB8CYevYxjZru2f+XmpxLEIonjXANc9ruWqjuNAHz57bgOl1v9A/PH/oK/GSpYfy0VV0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39830400003)(366004)(346002)(478600001)(6486002)(31686004)(36756003)(44832011)(66476007)(66556008)(66946007)(316002)(6916009)(41300700001)(83380400001)(6666004)(8676002)(235185007)(8936002)(4326008)(5660300002)(6512007)(2906002)(52116002)(33964004)(6506007)(2616005)(186003)(53546011)(26005)(21480400003)(31696002)(86362001)(38100700002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmgvWlZVcnNzdjZaZjJEUE5laWJqUnBqVDJoTm1EWVV6SmtKcnpNVk5UMDR0?=
 =?utf-8?B?ZWVTemJidUZuK1BzSjZCMmdiNUo5WGxQbnlEM2ZmbUU1OVRaLzNCR3NLbUZj?=
 =?utf-8?B?UEZnMWFBTm5IWncvWmF4ekkxcmU4ZThhOEsvdllTMjlScG5BMG8zL3RGSE9N?=
 =?utf-8?B?RE9zQVRYQnNXRmdmV0pkRzhsSlRIc1B4MVlJNkc4cCtJUjkyV1JSMTVReVl4?=
 =?utf-8?B?VjEwZmg4a1JFQ3p3RWJDUVQzNXhFY1NOQVlnUUExV0VmQmNEMnhrdUZNNXkw?=
 =?utf-8?B?VFVmTW5jQ2NtVmZFMnQ2K2F0UU1oZ1VoOHZFL2pyQ1V5WlUvTk9tNDlZTWlz?=
 =?utf-8?B?NnZFZ2lidGRoRWpmWlp1UjRnN0F0eGp5bjNEZ2RpQ1J0VHBWc1UwaDBjZ3F0?=
 =?utf-8?B?cTJVL0pqMGh1NitKejc0Tnh1WkZiSlpMalV6U0ZORFdFSmVNN3JWRTlGWmJU?=
 =?utf-8?B?a2NHbVUxUXN2eWlqd2lWMEp0ZTJ2dWhjSSs0OFNoNDR3RjFVQnVOTXBPVEU5?=
 =?utf-8?B?Yk1KcjJJMnRFYVRuMUptY2JackZXMytlWTNLTUtHMkE3ekhTdU1DRVVKOFJq?=
 =?utf-8?B?Z1pReHBsTDh3UzMrRVdNdHppaGRXMzFRb1JSTUFMMmpUS2kyTFVKRDByV1g5?=
 =?utf-8?B?VDBXamNUcTJGaEVWbmFzd0J4TU9WT2VvWldLWGM2MTBWMDVMa1hhaTRrNWQr?=
 =?utf-8?B?S1FFVW5pUHVMYlpTb0R0UDB4WTFEbkdleXZxWVRueHlFWW5xZmFyYXpnMi9s?=
 =?utf-8?B?RVliRC9OMTBuUVBaWVg5NFNHK3Nod29EN3B0WDBmOFFGT0N5OWxqWGhlT08r?=
 =?utf-8?B?UUFDYUF5Z29CeUI4Lzh1T2JmOUt2Z2t1V2FrZkpBT2t2WXlaVnVhZFQ5UFg0?=
 =?utf-8?B?K3Jrdlp1RmZpS21PYkZOdE5OQXhzdFUwL2xOZ2ZjWnhqcmNtT2NrMmN2am5w?=
 =?utf-8?B?a3NncmpibzNSbmp4bmpsSU10QmxmR0ZRWGlrcXN5emNFZnBwSGdobXZDQkpM?=
 =?utf-8?B?SzV2YVFRUklPU2UrSVFFZnBUZzBweXlvYWpTKytaSEE1UUxpandGUi9jZG1h?=
 =?utf-8?B?NmttMVZYbDdneFQ1SDlaTm9TbEkrdzB2WllweWxFbmdhOHBOODVsYzhseVYr?=
 =?utf-8?B?UWQrTzBrN1FDM1F2YzV1WEhLSGRaQnJuanRCelRSM3I0NnpWMlUzRkxDdkV2?=
 =?utf-8?B?dHBLdEp6aEJkOEh3MWFmOEZxSnRpdmd3ZUExTWFoRlZqR2o1bGc0RWpqT3VF?=
 =?utf-8?B?YnAvTkMxYW13WUZ3TU51Yk5ReFlsRHNiUERtUU92Yml6N3FUUFNzNEVEcjUr?=
 =?utf-8?B?SFRKa3EzdUFCM1Z4bmVvb1JHQ0ExODJRL1czWThkcWttVktvdGhZUkgyUGpi?=
 =?utf-8?B?bEswdHVKdFRKUExQTFN1QUNHS0Jyek5XTkp6enJCcllxNmc2VFhqL002aklJ?=
 =?utf-8?B?RU14MERyR3dCZTJEUE8rbEtVSVV2MURLSXBGQnZIczJqTkZFVHdIMnlmNFdY?=
 =?utf-8?B?bm5ScGR2clU1VVdHMTFwTVhOQ0U2RGtqVURkbEY2SWVTRHhiNFYyUmFIbWRQ?=
 =?utf-8?B?bXNrQ2RIZ2E5SUpuYzVXYW81dnZZQkphalYwYWtXb3ZKaXRjK2lnc1hPOFpQ?=
 =?utf-8?B?R1ZzVjA3Nzh1Ynl0bUl4UjV0bG1rSzVwTnRSQzVWazNyQ2ptVXl6Z2wrcHVV?=
 =?utf-8?B?MUZoM2dhZ0NQN3dqbGkwTklFRFJFdWQ2U01YVUhiZ0tFczQvWGJ1Y1RMYmRN?=
 =?utf-8?B?dEZaWnRGdURUcUJ3N1hPa2pRSUlYcC84N2VyOGhiTlh6MGM3Wm5hL2pIRk1K?=
 =?utf-8?B?RU5ITVZoQUdON0l3YUVjdmh1TklPQUpOblN4Y0UrMVU1Q1h2cHZsTk01bUdR?=
 =?utf-8?B?WVJHZDVwOUdxNzgwUHN0R28rZVdMREV2TDY3V3l4RmlUd3FBTUlWeWdpOEpD?=
 =?utf-8?B?YzZXNVhBS2lUQTA2R1I5VVFwVGNaaXUrT21FZkxvNllEcFNwdHBHaG13Vndw?=
 =?utf-8?B?ZVpjYkZnQ3pVcXlHeGc0bHZjMnVQbm5Sek1MbWRmQWJvaFpwUUw4NWkzRThw?=
 =?utf-8?B?VzdDR0dBMFphWjNNUEtzNlI1Qjlja3l5ZzFMSFRFZ0dFY3M5Yzh5NWtDQ2hG?=
 =?utf-8?Q?SVOvbD/FBZUGQGW8alLLxb0EV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b21c7ccc-c2b8-48fe-ce08-08da61e6e64f
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 20:09:16.2270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuQ9gAs8wGqiBausoNlxxzN0STzpkPghjILQJ9w0ujKv1c/Vmkl5+p0EwJwHvv7Jyw+PQZblb5jRvjTGzjDe+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PRAP192MB1602
X-OrganizationHeadersPreserved: PRAP192MB1602.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-ORIG-GUID: GL5QbHQIzwTiNFEDQ86FdsSzCzWwZNp-
X-Proofpoint-GUID: GL5QbHQIzwTiNFEDQ86FdsSzCzWwZNp-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------TYxM0hpGWGxrd2wJNtJs6lt0
Content-Type: multipart/mixed; boundary="------------VFhUE2gQUutwGcD8eSq7U7UT";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com
Message-ID: <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
In-Reply-To: <20220707170145.0666cd4c@kernel.org>

--------------VFhUE2gQUutwGcD8eSq7U7UT
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpPbiAwOC8wNy8yMDIyIDAyOjAxLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVGh1
LCA3IEp1bCAyMDIyIDE1OjU5OjEwICswMjAwIE1hdHRoaWFzIE1heSB3cm90ZToNCj4+IEhh
cyBzZXR0aW5nIHRoZSBUT1MgZm9yIGlwNmdyZXRhcCBldmVyIHdvcmtlZD8NCj4gDQo+IE5v
dCBzdXJlLCBsb29rcyBsaWtlIHRoZSBjb2RlIGlzIHRoZXJlLCBidXQgSSBoYXZlbid0IHVz
ZWQgaXQgbXlzZWxmLg0KPiBJIHByZXN1bWUgIjB4YTAiIGlzIG5vdCB0cnlpbmcgdG8gc2V0
IHRoZSBFQ04gYml0cz8gSSBuZXZlciByZW1lbWJlcg0KPiB3aGljaCBlbmQgaGFzIHRoZSBF
Q04gYml0cywgdGhvc2UgbWF5IHdlbGwgZ2V0IG51a2VkIG9uIHRoZSB3YXkuDQo+IA0KVGhl
IEVDTiBiaXRzIGFyZSB0aGUgbG93ZXN0IDIgYml0cy4NClRoZSBEU0NQIHZhbHVlIGhhcyB0
byBiZSBhIG11bHRpcGxlIG9mIDQuDQoNCj4+IEhvdyBzaG91bGQgaSBnbyBmb3J3YXJkIHdp
dGggdGhpcz8NCj4gDQo+IEkgdGhpbmsgeW91ciBleGFtcGxlIGFib3ZlIHNob3dzIHRoYXQg
InRvcyAweGEwIiBkb2VzIG5vdCB3b3JrIGJ1dCB0aGUNCj4gY29udmVyc2F0aW9uIHdhcyBh
Ym91dCBpbmhlcml0YW5jZSwgZG9lcyAidG9zIGluaGVyaXQiIG5vdCB3b3JrIGVpdGhlcj8N
Cg0KWWVzIGluaGVyaXQgZG9lcyBub3Qgd29yayBlaXRoZXIuIFRoaXMgaXMgd2h5IGkgc3Rh
cnRlZCBzZXR0aW5nIGl0IHN0YXRpY2FsbHkuDQpIb3dldmVyIEkgdGhpbmsgSSBmaWd1cmVk
IG91dCB3aGF0IGlzIGdvaW5nIG9uLg0KU2V0dGluZyB0aGUgVE9TIHN0YXRpY2FsbHkgdG8g
MHhhMCBkb2VzIHdvcmsuLi4gd2hlbiB0aGUgcGF5bG9hZCBpcyBJUHY0IG9yIElQdjYsDQp3
aGljaCBpcyBhbHNvIHdoZW4gaW5oZXJpdGluZyB3b3Jrcy4gRm9yIGV2ZXJ5dGhpbmcgb3Ro
ZXIgdHlwZSBvZiBwYXlsb2FkLCBpdCBpcyBhbHdheXMgMHgwMC4NClRoaXMgaXMgZGlmZmVy
ZW50IHRoYW4gd2l0aCBhbiBJUHY0IHR1bm5lbC4NClNob3VsZCBpIGNvbnNpZGVyIHRoaXMg
YSBidWcgdGhhdCBuZWVkcyB0byBiZSBmaXhlZCwgb3IgaXMgdGhhdCB0aGUgaW50ZW5kZWQg
YmVoYXZpb3VyPw0KDQpCUg0KTWF0dGhpYXMNCg==

--------------VFhUE2gQUutwGcD8eSq7U7UT--

--------------TYxM0hpGWGxrd2wJNtJs6lt0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYsngaAUDAAAAAAAKCRDfdrYEUzwNvowu
AP4kQx99uPzbXPPVamqQO+0PfXbO2xi8H10j1iL636FXIAEAq1u/JA/WSvTbNDkivpt4JfFIAx1A
yIfG2/lKKSThiwc=
=A88w
-----END PGP SIGNATURE-----

--------------TYxM0hpGWGxrd2wJNtJs6lt0--
