Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6832DFB1A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 11:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgLUKit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 05:38:49 -0500
Received: from mail-eopbgr50090.outbound.protection.outlook.com ([40.107.5.90]:61861
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbgLUKis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 05:38:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOB3ZLjdW++iKd9rBaU/8hf8qtQS07j5PBvtxj9zY8KpEmoV1HngqsozIDfDHTcmww9ZBEkt9n6l15w2O1BLp4qPLEDN49lBz7xhLc7x250B+dbPsuht7+/buPjbjE86icdJRPSIbYXCUxAsEcwmJ7LroHiTfqQFPNNjbSJPsfSFkkdrALjl/ALcNG6tQKGKLkEscZuxFu4xZDOuN9lq3wexxIMhW0CO0ohNuysJio7eAwl1XnpQaBdKm2c4j70sVNBKHPvkOyR4nNcI5O2lP/eJ6Fs+uNJ9QefgSCnGK2QUfjUBM4g2D1O2bCcxPKIpUtL4gqUle2CEfuDux4REpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1T4sr3U+DbigZdtlc54vQib/NEyfXH4YbOQmlZNQM0=;
 b=VNBrQtsAuxPEjsWoQyCyPAhPi9XBEITcRQVLTJIigTKI8DNVrtIi0VU8zaRz23vDlLqkhgRNHLJh/UuLfgO3EGK4+B0Zaxl88I2pb7kU9/YZyrb6wbLE8V1sPJjcagvYP+abmTnWeclLu4qLsiqSh17whtlGyWYn0Yk63jeQnwTWoOxpqMqgDZYNrB2WztLHlRJQi/lk8QOlBClvfclHFIBM3Uq3vze9Z4CK9yYcqHjYL0J9wR+hlYH/ilkyVe9XDrxtfzV6CZvWMe1+2MPAMlpc3IHoZLOqM8W7HbaeVGl9H2Nt6LXyJlyv0Ot8nr6NmlobiMUDE4+yjMHxn/cvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom.dk; dmarc=pass action=none header.from=silicom.dk;
 dkim=pass header.d=silicom.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1T4sr3U+DbigZdtlc54vQib/NEyfXH4YbOQmlZNQM0=;
 b=oG5/KBhggmPumEcT0gxuj6RjGxYz1nzCIySlHhsDja8MGE98SsT+kmEjq9JxGilJ8l4aR4hRXlRxx6KbJf8gZeXD9R87LU7Ouy4VVQEGysIE+xOXO94cwuyBHrJJcjl9uD5/sRATq4S8VBL3Z/uQbQWiywV/AT4abP5OrnO+Z3E=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=silicom.dk;
Received: from AM0PR0402MB3426.eurprd04.prod.outlook.com
 (2603:10a6:208:22::15) by AM0PR04MB6882.eurprd04.prod.outlook.com
 (2603:10a6:208:184::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Mon, 21 Dec
 2020 10:37:57 +0000
Received: from AM0PR0402MB3426.eurprd04.prod.outlook.com
 ([fe80::58c9:a2cd:46c5:912e]) by AM0PR0402MB3426.eurprd04.prod.outlook.com
 ([fe80::58c9:a2cd:46c5:912e%5]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 10:37:57 +0000
To:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
From:   =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <mhu@silicom.dk>
Subject: Reporting SFP presence status
Message-ID: <5db3cbd8-ec1c-a156-bcb9-50fb3b8391b0@silicom.dk>
Date:   Mon, 21 Dec 2020 11:37:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.184.138.169]
X-ClientProxiedBy: AM6PR04CA0024.eurprd04.prod.outlook.com
 (2603:10a6:20b:92::37) To AM0PR0402MB3426.eurprd04.prod.outlook.com
 (2603:10a6:208:22::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.8.20] (85.184.138.169) by AM6PR04CA0024.eurprd04.prod.outlook.com (2603:10a6:20b:92::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Mon, 21 Dec 2020 10:37:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e01ec19e-8152-400c-dd58-08d8a59c7b58
X-MS-TrafficTypeDiagnostic: AM0PR04MB6882:
X-Microsoft-Antispam-PRVS: <AM0PR04MB68822240A1561BE33E7AE245D5C00@AM0PR04MB6882.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J577cdNfIrcDJC5XSoH6/+R+VU8UzWWlBt+lWU/iW1r5Euind+pN0v9LaQbNoJCXAklzL6hCqb44enVLWsApBXe3Ie3Ws4ptvGBlRbvncuPdvVw7AClYZYP5QHaD2kZ6pc7xjqREjO0n7yYFiq9bFpKYM7/X7aPexvW52dXmyuMxDpjAdrA9o5ixGBPqMpPRBoDyyNDn8Anb9eW1u4lU9B1s71Z4gkBVQyqO6tcQM2ymmK/v7aIkoEimsB0bOXGA6yHWXoqL0M7+l3czvEa0ARUPHPBzNae9S1oEP1ZixFZ41EM6OWfHUp6VX6NZDJlMaMtATnTR0inqUWnkEYxL3+hvrW5QxxDzl7YAZ/GBfNhtZH0tE3YHES4IXiUwxYhavF8jn9QVsjiTIzb16CntQIlrt0Xj3RT2EkkPBL4ZWqsUthHFNXQM1Olyf3X3eqLh+l+i/GJiZNO2ZO08NwYa8vZIjMLm/0JmCBTcZ1Fm30w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(396003)(376002)(346002)(366004)(6486002)(86362001)(5660300002)(8676002)(2906002)(956004)(558084003)(26005)(2616005)(31696002)(16526019)(66556008)(66946007)(31686004)(186003)(36756003)(66476007)(110136005)(8976002)(3480700007)(52116002)(8936002)(16576012)(316002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RFVwMjZwelNSS1RpYndHS0pwR05kTlJxUThOZ0RSVjRiMlh4ajRvblRVb0Rn?=
 =?utf-8?B?VkRDbDFQeGdKeVVkU0VkRldoUVVEVzVkTjk2TFVVU3NPSjVHdExSN0JqTGpY?=
 =?utf-8?B?UWlFUU1oZENodmUya0hVYVl0QWVCNUhMS2pLWjErV1BkS2t2S1dSZWczUzMw?=
 =?utf-8?B?RE1LcTJMWVBveTlWc1NxMStTNGhrSU8wTFI2VmNVYzFVOE9BYk8zeWhnNnEx?=
 =?utf-8?B?QlJwRE44c3dIOWMwSW9EeGVXRXB4cE9hQ09KOHUzME5seWtGYjhwT2pCSjdS?=
 =?utf-8?B?bVRmNkRKaHNtaXVrNTdFV1F6UGpacDRTc0U4S1dwL1NLV0wxL2NpeXMwMEln?=
 =?utf-8?B?SWt3Q3hrK0dqb1M0ei9jb1o1Y0o5Rk9NNnN3clB6Qk1OVEhIaTA3R0tyYVhS?=
 =?utf-8?B?TFBwQkRtQzN5K3Bxa1R4UUdsOUUzUEFNbjNiK2RRUkw5ckxOUDIra3paY2FM?=
 =?utf-8?B?ZFF5M0RsL2hnUmJxWlFZcDY1dENCNitwTUVCRitmdEVTakE3RkozSkRwSmQ2?=
 =?utf-8?B?UzFMeUNQVUhlNHh5OXgwcTY0U01adXBIUnJsQTdxMkIyYlRIL2pTRTRDNTRx?=
 =?utf-8?B?b25WRDhzdkpSVStSL083eVdGRW01T2M1MUlQTW9MWnZTbUFqVStrMXJlZ3BT?=
 =?utf-8?B?ZEl4SFNEbXVBQ3I1Z3kzeURRNk9mOXZGRWMzWjc3a3crbVFaNU5McGlTcllW?=
 =?utf-8?B?S0hBWldHNmQ2M1J6K1VYWmw2YWYyZHBhVm9BaWhyNFlwempaYWlCYnBPaS9C?=
 =?utf-8?B?VHEvckxmQWtYbVovVkIzRXpNYklYbGRkOUtVL3NTdEhQK05IbkJZczJTQWRh?=
 =?utf-8?B?a0s3RG5NV3dnYXRjdHpoZkpvb1ZqVSsrL3pFVjErT01iVmw5NkJoMWVWVzBl?=
 =?utf-8?B?UkFRbkhOQndrZ093Zk5SZzM0a3lidVRIN3R6VFRTUTYramcva3k3OURNUGFp?=
 =?utf-8?B?dEw3aDJnemF2eWFuOUErRmR2eVorVWc5c3lIOVhBbkdsaFNRM0NKYXFSTTF5?=
 =?utf-8?B?Tjd5NnluU093TElxNEdBeDBGdHA2TDVKUHlTT3k4VXhSbTVYbVBpTmNwOG5E?=
 =?utf-8?B?WXZxbjdjWXA2YTB1b3U2NEZSY1pTVjJEUFU5ZVVMNGl3S0dvcE9FOUpnVEl1?=
 =?utf-8?B?bnZHK3lTOGlONExyM3BTMXBROHBheU0wM2F6UjdubDZLenBMUllDMGJ2QU03?=
 =?utf-8?B?bDVwZjBQbi9vOWExQW9FSDc2UGlxUnFPQWZDZXFLMy8rME1wTGtTZHY0Rmlv?=
 =?utf-8?B?aTlQYU9mVnlYUnoyL2ZYVjZRT2liTWU0Y3JmNTltSkU0N3pkKzhOaUg1a005?=
 =?utf-8?Q?t0zHns8UWnkxXL4rYqh3dja+rejh194Vgt?=
X-OriginatorOrg: silicom.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2020 10:37:57.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-Network-Message-Id: e01ec19e-8152-400c-dd58-08d8a59c7b58
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouyhuiT6S1iQy8pL+7NkKEX+Ioph/Rk+DL6Qycj+sD6LLiifobfZmVsAkZrQUwaQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

I've browsed the code in drivers/net/phy, but haven't found a place 
where the SFP module status/change is reported to user-space. Is there a 
"standard" way to report insert/remove events for SFP modules, or should 
we just add a custom sysfs attribute to our driver?

Thanks,
Martin
