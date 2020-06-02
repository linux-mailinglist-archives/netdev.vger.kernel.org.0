Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9590D1EB44A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 06:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFBEYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 00:24:18 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:6046
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgFBEYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 00:24:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkIKdOaga5NVKdfNJ6QqWsbfx2PFTiUYycV8qCqJdXyJKkDIbzNEhc7pqW0eIGhiIg1U/usggefhQ/9kbricQk3HPPMF23kqTG8pAlwC4D844TO80I+2QAi+bHnu4Bufl73JQpmUGxArxwh1Zlpf8/1QBl/R1Q4w+yotlk87gPYbVUAnUl5dP2H2+JpHYHxr+EO+oN/Gull1EmFGIoEguL8n5RKYhQabIG38V0CpXj48BpFHbjtX49gCHO1CHjPCEN7u8uAiFmdenWWBQP+EXjEsORADf6F4kJFN3kL7evn5OEfR4RcQmGPFjqQaLbUFIqHghqVzmFZXPO8B3AMXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udfppQiuzqMAcmNlREM0/Cp7djt31f2YAyluS3qM02M=;
 b=BJEkXDKthVB4J8EzthoHUk75wA362GftILOzuM5VSqTl1QgW/vNiE/YEVZ/zU2Pt4h3tcffZ11iev04sqRsNyZz69utigPVMbhQSsnHo7NigOXZPBboAw3zZBdWvrOwJdnbyMhcF0GjAChn5vENn2IzFQu0l+0EbyY6tmPr6B7c3KpRceYqd6lKs/GzEvhrJ2wTpoygvvOTovvLmKt7ywdk8MrQXgrUs3Rvzscj6vZ1oRnuW4Kmtb70GhNhQoX6OnOTUPsDIV1prEpJsJNq3oilCVBrGZ7D6WeCOqjVOBQ9qM7i5XgUkOCj1UeG1XzaCGUxV/kyo6QgP9p16tVCbyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udfppQiuzqMAcmNlREM0/Cp7djt31f2YAyluS3qM02M=;
 b=bd7ZG7bqL4Vj/oNC3LPGUXS49MVFCjaA0AVBLafzupv6XucO7LRsQQQmIZ45beLjOKC1+8d3Ksk82Wu3FEOM7M1goO2pCwcABa38gM7VoD/eLaYfdaCI8CFc+DYRZ6fyk/MnJULbCdaPbFzrgYwb5IjsetIKcvL5U3wvDzErNe0=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DBAPR05MB7095.eurprd05.prod.outlook.com (2603:10a6:10:18e::21)
 by DBAPR05MB7112.eurprd05.prod.outlook.com (2603:10a6:10:18c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Tue, 2 Jun
 2020 04:24:14 +0000
Received: from DBAPR05MB7095.eurprd05.prod.outlook.com
 ([fe80::18fc:e79:48a8:fb5a]) by DBAPR05MB7095.eurprd05.prod.outlook.com
 ([fe80::18fc:e79:48a8:fb5a%5]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 04:24:13 +0000
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
 <20200529194641.243989-11-saeedm@mellanox.com>
 <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
 <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
 <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <c58e2276-81a1-5d4a-b6e1-b89fe076e8ba@mellanox.com>
Date:   Tue, 2 Jun 2020 07:23:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0104.eurprd02.prod.outlook.com
 (2603:10a6:208:154::45) To DBAPR05MB7095.eurprd05.prod.outlook.com
 (2603:10a6:10:18e::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM0PR02CA0104.eurprd02.prod.outlook.com (2603:10a6:208:154::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Tue, 2 Jun 2020 04:24:12 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a224057e-aab1-4ce7-ca8c-08d806acce27
X-MS-TrafficTypeDiagnostic: DBAPR05MB7112:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR05MB7112997694DB41C0AB5A8E56B08B0@DBAPR05MB7112.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snSZOlbVSv/mQZ1fop7iSghHyj/TM4h7K+sFTmSoZ0sbIB5tclQ0WoCat2IwrujVr1iohMVzMfJFbFLkZXczvZcqmoLxl6LtQf6lC6Mc0aDmJ94DlQMh6vrybGouw/YmlHA8SdMpAwEUS1jApXeqR5T/yG5wJBfFpdyZMtglcWAwT5tcPlqIeGSlcLAnwm3HCzytOssYIi+ZUQC+5Ize8/6zAIE7Eebosprh5I5inZbyA3zNSa/ToUtPCGoZe7gw95Ttnt03xTILBDvfYJYbeKkrTwQEb7gcyXzyQwzZN6MYaRGzBO9nX5LpW/W15aoIM6YzVSOHqHRcBT4xlRZdbhsHBgS703oz7U0Hut6JycjLVJqcvQZUJN+UwZ5ItiDb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR05MB7095.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(5660300002)(54906003)(316002)(83380400001)(53546011)(2906002)(6916009)(6486002)(956004)(26005)(8676002)(31686004)(2616005)(52116002)(478600001)(8936002)(186003)(16526019)(16576012)(6666004)(107886003)(4326008)(66946007)(66476007)(66556008)(86362001)(4744005)(31696002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JOcFDJV9DuLNiZ6mt63dMQhC+hpuUVA7s2SDrZqAtLhJ+1rTIVlaPOyBLXnp3T0xKEF5VEt2t/nzJq29zOjU4fd+bv8nEB1asMCY748HP4C6VaWZqaAzVmVS/ybCHtzHHlaRcX33thweqcGB3MJCfE73dYpqh1fUjweCpNP5qHibaVhfIumiPmtq4mfZ6erzEiNsLuZZc0eMqFzQFBiuALU+fzemyah3DY5FAmR0vq/UobvxrGF9jP3PHgXBJY/11Tmwniz7Mnr3tS0boOOshdEVVpHtrQ2y/SMeqi8m6wbjvrj6AxPvULV2qOVqVI4dA0KtjsWbAJnpGnWnMhkY7XicdY5Cs2VPAE9VlfHcSLe/dQ0fa52c66JYMbhNAYbdHTM9TDuGK98sUa81gKScgqX7z624y1OetLekrJLBRVE774NdtkCPiWK9lMt872CxSNmhMEjsoC0bKsDRGlApSQ7s/8tzDUi53c6tUP9znRa37ESJSHAnXs34yi/vaNsY
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a224057e-aab1-4ce7-ca8c-08d806acce27
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 04:24:13.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQ5WzcH7mCuLjvITFAJczv2F2k+ujcocXHsV137gbIc9eLTBpE0nnR8nvQyKy/UGeuxEJN3fOayrcA+xUqrcww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/06/2020 1:12, Jakub Kicinski wrote:
> On Sun, 31 May 2020 15:06:28 +0300 Boris Pismenny wrote:
>> On 30/05/2020 0:50, Jakub Kicinski wrote:
>>
>>> IIUC every ooo packet causes a resync request in your
>>> implementation - is that true?
>>>   
>> No, only header loss. We never required a resync per OOO packet. I'm
>> not sure why would you think that.
> I mean until device is back in sync every frame kicks off
> resync_update_sn() and tries to queue the work, right?
>
Nope, only the first frame triggers resync_update_sn, so as to keep the process efficient and avoid spamming the system with resync requests. Per-flow, the device will try again to trigger resync_update_sn only if it gets out of sync due to out-of-sequence record headers.


