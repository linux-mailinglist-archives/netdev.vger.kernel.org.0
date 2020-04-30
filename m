Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175421BF29B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgD3IWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:22:36 -0400
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:23137
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbgD3IWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 04:22:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOZBz248Vl8AC8dEXA+BnOLlUn1M/Y0ZmqwYAIiXOnPyk9OPKjHQHJaax0jZvlGBEjFiSmPucwk/hgHKQ3GAgbeL+tw8SCapqLsSUPBIAB6o79xGn47IsK8RkwOzYqlcqj7yEIsweYXFHi2pPb9I396Ks7BysafDLyZh4TyzhkO2jL5R+JvPPqfHmUkJD05YbDX7GAsd608HiGPmtPJb6eNs16XkzPaqP8GdPaGVFO5z6UniF3wrT/qF2OQM8bH9ohMvydy2fpn+Tgk367vG4daK6qNykQiilbdaIpaSTByAK0pUIe+Jyoinr2Yk7wxDJVwJ259Lqvsrg5qBBg+jFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lUuHgoejoEg+jV8+4hgu4BOn8yJoc+xCm1T/+7qEY0=;
 b=ZF6FxMAqx58ACHb0/9Scol4VOXjgrhHjFJMiJkENk4FNm3DzmTQj05BRQpNlbNNrpbQLpXttXZxKVSHwk/y4Rvdot5riZsKuBKoTzn+jtNdAGaapc94agZ7VxSRf/0D7ICH8sHznifx3Ds6/JZBI0Gj18/Dee5QyqbizrD+lFCZ0M6/pUFd3VXdPWUYmqbWaYN27LLupsvY/pKtkdg86wAcjlhHs1egoqukdWebDtfCTJgG9bA4Sf3hwDaIvd+aCyzy1sGC/JIBUdIq5Sw9cxizG82ElrpMMMjmLTxTVIwyt5SJUaeF5eK+LLF1aPXlDS7HQ+PCd9JX+EbZC1OdUFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lUuHgoejoEg+jV8+4hgu4BOn8yJoc+xCm1T/+7qEY0=;
 b=FrFGrrUz0pwk9jWX5weXk3yh47H8yObLpXtTikF2ACXbhIhDjMBJ3Iq+xxfToE08VwjopTYDRe7PUXxTjTeQ8xz+d7F0RFTZWGwbx+4RUCkCeYvWrtqJD8jdYjL2UVY7Uf7+FbQfoXPy+bZi7FMyn0X313MskPz603pdDEjDe9w=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2448.eurprd05.prod.outlook.com
 (2603:10a6:800:68::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 08:22:33 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e%3]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 08:22:33 +0000
Subject: Re: [net 8/8] net/mlx5e: kTLS, Add resiliency to zero-size record
 frags in TX resync flow
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
 <20200429225449.60664-9-saeedm@mellanox.com>
 <20200429171238.3f3a552a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <00f2e766-a6eb-ce51-a787-ae9ab504dda6@mellanox.com>
Date:   Thu, 30 Apr 2020 11:22:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200429171238.3f3a552a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0110.eurprd07.prod.outlook.com
 (2603:10a6:207:7::20) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.37.56) by AM3PR07CA0110.eurprd07.prod.outlook.com (2603:10a6:207:7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Thu, 30 Apr 2020 08:22:32 +0000
X-Originating-IP: [77.125.37.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3682ef3f-7090-4413-fae7-08d7ecdfa1f4
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:|VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24486BAA26C5F58E1228DA5FAEAA0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ma3oSlIBXWNXVbaZqBC5/DXEb5kVPwQdd4q7nIWyTktrmaiZ042dwgooVk9AKnycDJRLRSTDkiXCZJuymTyaidGBg5pzUtGSDDKJRjwFfkVGK1qfj8db5Ou1oMCKNh8WGRSt6+c+xABc0K9ZQ3J7jkpDkdSIpWVsMhtdIn+2BaYnyrluxbA8NmjVgOkRJSP7KAysLXoVoUPgzj9EnzEZz0LqdpD/Iey6SvG+xECkB2TjEaXVMM6mZiXh2gGrEH3nNj73TndPv1+1raRBURXFZwbIAFNDSysM5XpNEC5dyIfBmhneyFzjyX+LroqBYOW8ww7HVsQzNecDWec6/S4aexO/7pzMJ3FUSwHnEBdY2eZjkfd/M8stFWiEPP4RehQ+fqw/xmj535VP+I8CZIDu0O+1wY6tOHToa+vdLdSaAda90OxdODcOBXT9oWcgQw+T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(66476007)(31696002)(6636002)(107886003)(86362001)(8676002)(66946007)(6666004)(53546011)(36756003)(26005)(2906002)(5660300002)(478600001)(186003)(52116002)(16526019)(4326008)(66556008)(6486002)(110136005)(316002)(16576012)(31686004)(4744005)(8936002)(54906003)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LbD8nbFaJaoxbZzepg8TBHLlZcDUXkTGGA6jK0J4WyIu38E8MwHV+9uwffM+3RgLbwxuuAxmcrUZnAoDIFCKsICSUjWAfEa4yhRVdzSgr00InnxmqhxCH2THMHkstzS0c66BKPZ/3XPdQTRXFaHELReDEYELeE+TguEoXjcZ0b7rsdRGB8mKMBzyH7BwPtVwQ2vCZFkPNT3eZCfC929fzYxdPypfbuy1DHkYovLkZSWYwxP0RMS78Hoi/IJBvC/qzDEO2XOgwxZK/9E0JYB4VqgrnvRwRzqXTAYh+sbQOrw8iaxVLSCI6SBrrD96u9Nev9N4vW8eqAkMDOilvGSC1LQmck4a0So+yKlK7OlKYqQf0NgcRTiO/4ZD+KRWpkf24sHaYr1mLBvBom4zGVRlZW8ZjgdWTNO8THfheUp3zoBT6XKg7r7vq1/i3Enp3dYt2YIZ0aJEK6peGZxj0Iw9OyG7Ay8z1dxoHLzptEOsnefulObguFlzCNIcDDX30mRFeK9MYyGhXdBiHuvUnSQoh7IlLz5RLVq+MQn7YctntrmFejSkilrljTTlg48GiRhDDNIIUC0ZdD0XaBuzvBfpT27f67a1LpIR0AEwCcdrT6AG1RS/upDNa8UYR+NXXuEeTcaUFfsg8Dp5AhD7mIvXw9airQFSq4v4tEp3Q1wx4kC55mEvkAbVrfAbOgxHb+7PhzCauML8i53wmaJT7oWTzjeoC5/8ybrvzomghjm5PhsTgXN7POFgJgrNg4B+hTAnU/k+R4KNSShjRiOrtIjNDhgKeG4dJ4EsKgm/x4m7ioc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3682ef3f-7090-4413-fae7-08d7ecdfa1f4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:22:33.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1/IpaRc6pbXs28Gq5ioFtuJYjQVYIONY45gyC3zAMQQW3JlUsOl2eIa+VJfnITbnLnwt+58LGahHEMh1ttMDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/2020 3:12 AM, Jakub Kicinski wrote:
> On Wed, 29 Apr 2020 15:54:49 -0700 Saeed Mahameed wrote:
>> From: Tariq Toukan <tariqt@mellanox.com>
>>
>> SKBs of TLS records might have empty zero-sized frags.
> 
> Why? Let's fix that instead of adding checks to drivers.
> 

Hi Jakub,

The HW spec requires the DUMP size to be non-zero, this patch comes to 
guarantee this in driver.
In kernel stack, having zero-side fragments is for sure non-optimal 
practice, but still could be considered valid and tolerated.
I agree that we should find the source of this practice in stack and 
enhance it.

Thanks,
Tariq

>> Posting a DUMP WQE for such frag would result an error completion.
>> Add in-driver resiliency and skip such frags.
>>
>> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
