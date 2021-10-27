Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6523743C53C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239342AbhJ0Iek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:34:40 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:8865
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239305AbhJ0Ieg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:34:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLxPtbR14tl2p7Zohv4ecqmohzW01iqLEza0Dg/n43v1p2S7PsiOzrl0kB0GFJrsI6w1xq9gyOCvkwFMGFr5ILPDw8R9UeY1dYqJgTgoF0i2Mp9Ayn5wd7Gky+BVGDETmg6dx2O++E/JzQOZEohsInFeSxJZ0+QEw+2XaPz6S484OCXiz4MSyq0YYheeJEzhjTJKRSLUeCUGDdnS2Ob5IbE6/Sy4BgmqhxFKrGwg7lTCt9sHjQ2dRy6bINdd8y/rUaPAd462NdasobgSDLR782/wLeRtmXMKiK4Mjhtp730M9B71Hhf5KS6yJnJ413SEL6XQncaaC0HgRc8aOQzctw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZWv7COSyFbhyZ0Wln6Wj5lAJU5Y7PGaxsHxd8TgXdc=;
 b=WpECWxuUrbYjiQU7jj9XriqP+DaycUI6Srn4XbYwINnCfNCEhuDOVdSj8RdI8h8Ja7OhStuCerqIUk6SINYnBrEnzRKWK9B1U+RnA8zLplM2liaxOXhd5X0qQL0x55MmO6U+rR8H8DAHm9zqxFzcIwBSwWqR1u1hQ35GCz93dCifWX1Smb91rL5A139CLgEPXJfWThxywZFyOLRIE8GDLR/+XC88wkhW3027E+A4UGQxn1gFMvbVyyAbhLsbY0RFNzZ/jUDC9BFiIRqQq4GeIcbc6Nv9rK+bSTIWoSl1yUdrWxuyauhVQwm024XqShQ9zO0owL+huvw/Qi/djfBG+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZWv7COSyFbhyZ0Wln6Wj5lAJU5Y7PGaxsHxd8TgXdc=;
 b=ujkqrTAXspdo0wzti7gwpH9YsEp2Gps/86USyHgg0TgkbFCO/q9aIEe28ZXeJ2mS9lGGQ58t/oBjv5GftRzhQ1uhGJhKJblwnbdQ4X4zfVv3wZU2uSFic/HkKY84Ab+Sw4cLVmGdNy83nUeZ6t7BCGzGoKoWWtYzkQsS/YOaqjyTVmeBdiFAAS4MbWvE3ySesDUC1zSd6tNjYbIarc6ReYjY57yXwoimlIh+hFS+9sDfvwVXf6Euh1+0701mImxBjcAl8+N83jB9Sy+apNecMv/uz+RNYOzzoVcHfBP2Jws7+EcF7s0GWNM+duEOAfCohoEKiItEE/d9Yz9nfP8vZg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:32:10 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:32:10 +0000
Message-ID: <f3aa61ec-9dd2-f72e-7ab8-d7d7d1f4f060@nvidia.com>
Date:   Wed, 27 Oct 2021 11:32:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 4/8] net: bridge: rename br_fdb_insert to
 br_fdb_add_local
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-5-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026142743.1298877-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0054.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::31) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by AM6P191CA0054.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 08:32:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d9407f1-5ad1-41eb-c500-08d999244498
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50404E84AE6F0F61FCD1FE5DDF859@DM4PR12MB5040.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZheE+HoybfU1VRpOHdooVkBBdSbcaKLf0zmgeu6Q88JjIIjVStfcQvEmAWW7pn/6A6MO9Q60+IV9IH2NlEHrwcA0P3ClTEp0mg/vuXwV1fC91cxneDGUx0T4Q/gLs7PYAEYjZUu0IsH80ja/GjUi/amqgNBCG/e1Q1GVs4gnrBBL/qWcKStXJWDRdI710/jAdSeRgLxQNxpkDh11mY7gQzAXIRMPk1NmKfuRiM6jPO+Wh9eYnWnz+uL0Yq18tO+tHM/wErlVky+k64Fmv4Q190/lbjyQ/3jiwbZCa6IOaa0YSTO/ykayzfLl4KkcIzBIGW0MTtiugNT38Jsvpc4Ul3uELqx2lBBpV0wuk5jtnGMtifcRNqFtBgKlnP3gewSD+bfubOw/w53Mq4zJSI1Kvgq40CF7wjPlPHIroLas/6BfXRzUYS40atyjw+UmOJwEQ+W7e+L8+Sv1/PKWSdsbvYWkU5WBOgwUOV1ETLu2elo/W6OLllA1hKyQfUkjkLqOPs7zntJkz4N7W4pCjMc/00HGyrzzX3afkyuXP5JstOgOs5G5IZQ2JrrpRHdk2NJxrD+EInpg7mUuKa8mXqgWpA8/0A5VXz8+eL84YiJKaPj9Z2X036P0wnHmShSrCUkDO1sSaxg1aC4+66uX3iX5lPQurjmxjwHzeJeXLXz5RvLqzehZK40pnbWnpUDdXZKO8J9GX7k10D3kSta1Q7IHYqMdUbHAdz2rsOo7GRPpxPQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(53546011)(86362001)(31696002)(107886003)(8936002)(4326008)(66556008)(2906002)(66476007)(66946007)(26005)(186003)(4744005)(83380400001)(6486002)(31686004)(38100700002)(6636002)(508600001)(16576012)(36756003)(316002)(6666004)(54906003)(956004)(2616005)(110136005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3Bxd1FBUFV1RGQ2Rkh5VjhGVWFib1d5M2VSYzRRM1lVdzdMQkl6eEZDRjN0?=
 =?utf-8?B?cDV3aXF6bGdUL1c2Rmd0REtiSHcwMnFnTXdPTDhJUWhHbkJ2dmpySjdBbERz?=
 =?utf-8?B?b3MzdTN3bVpKQUFXdGZZYlZrUU5QMlJJV21ObC9JUTFEcThtSEthekowSTNF?=
 =?utf-8?B?L2ZVZUxwR2ptK3ZRVnRjUzRaZmladVZFOGhYVmxpOTRGd3FBTHBkQWNPeWdZ?=
 =?utf-8?B?b1hxc1dBV3cyTFFZOHh5SHAvU3NVYXlPdDJYSm84b0xpK0dJL3V3ZWxETGV1?=
 =?utf-8?B?S0VKQ0dZakFGWEZMYmZrR2JDVjNFYWpHSGFvQVNHeG5xTXBOUlJDd0VhS082?=
 =?utf-8?B?U2owK1hGVFdHd1FwQUc5emlmYVlXTFZhb2w0TVVaTnRTbE1QWGh3S1kwT043?=
 =?utf-8?B?eG96WGxPL1VUQ0lPeit3ZjhoSG9kU2t5SHZBK3lYZDF2V0htN1dFTk15SUFO?=
 =?utf-8?B?NStibi9oSlh0L3NaUHhobDZSZDd5Y0c0Q3RWZSsvSkVQYmNoL2pWUFRLbFcv?=
 =?utf-8?B?V2xvTXBDUUVxTVYwUmNTWWJ0S0Vja2ovckU3YUEyQzJ0VHJzQUVuSHFGQzUr?=
 =?utf-8?B?MkVjbU92M1gycEpTTVhlbUxNNDBiVmxGME1mVkYvUVhqWkVIeDFIOHB3R3Jh?=
 =?utf-8?B?U25SdXY3dVpjR1JjcytFV2tUdkE3Q2NiazlUbit2S2xLaGlrY215YU9hR2o5?=
 =?utf-8?B?Q0luRWQvaHlKQnVLWGVtOTdxYlp1VzFvMFBVa21oV0d4eittWUxBUThzQUlW?=
 =?utf-8?B?WnNrSCtWU2QvR0dZUUNlY0h0NkpiTTZXODQxSDY1aGxzUHFxdm1HWUZxY0JS?=
 =?utf-8?B?bWdaTC84bGY1MWJKLytwc2tIMnlCazJCMWE1Nm43K0d4QVQ4NHJEdzhQOTJZ?=
 =?utf-8?B?M1RnYk9pSzl6OFpYY24wVDlmMExNT0grZWJCRjBGeXlSVVI4QlRUNFpRNzhi?=
 =?utf-8?B?Uk5WUkFVSnBsMWV5dzJ2UHhSZEZBNEJWalR5cGlPZHRFejdOM0hUTjJlN0xw?=
 =?utf-8?B?dllKaEZVT0YrQ1loR1RycWlFZWdqYkFXZVdYVEV2RElDZEJETU1ialBqUWpT?=
 =?utf-8?B?b0doOUtVTWZNbXdkTCsySzlnMU5ZQ3RpZHQzNWlrYVFhMmNBMnBmazl0M2Nq?=
 =?utf-8?B?UnUxeFMrK2FnQTQ1WWFadVBWeUIwTTcxME5taDRQT3RXN3lIQ2c4NHEwdGNS?=
 =?utf-8?B?REplTEVCTFY1ZkJrY253U2hwY01BZTJTejY4Q0d4ZHpSK1F6Vk41WWFxNHg3?=
 =?utf-8?B?NTJpQ3ZzMFY0NDFEYmNFdTNLMVdUanJhczg5ckdOTEh6elMrTkZNOWgxWEJS?=
 =?utf-8?B?aHYrMWpvMUNLdGhjY240S09ZTnowWU1RSStKbkpDTVAzajdnOUY3QUdaSWF3?=
 =?utf-8?B?WGtsK0xzRlN5dFg5MEI1cXNMOHlUOVE1V3IrR2p6R2o2UmphZkpEZ1NVRlhC?=
 =?utf-8?B?dTBDSjZyYXo2OEZHc2p3blZOZG9uWXBEOEFZT3RrZjBhaWpMaG5WZGM5MWpV?=
 =?utf-8?B?TUs4NHlKa3VYN1pnZFh1Q3JaTmVZSUI3T3IzRDE2L0QrbTN0Y21MZFpqSU1L?=
 =?utf-8?B?cmQvNGIrUUlmUDZ6KzB2aXlvVXVheDBpY3RJb2dHencyTEdETGFLZGJQa3hk?=
 =?utf-8?B?MGlzQStkTG5tYnZEM3ZLSFhFTzhMaEN6Q3R4ZlVXdStUL2N6WjdTZTczbGNW?=
 =?utf-8?B?ZjArc1ZBY2Rua3RNZWRzOGJiWHRuTFZ6M3YwUkNxNFVFSHluZWRzNS8vcUUw?=
 =?utf-8?B?djd0RWZrTktHSXJiNm0rcXJJSXVVWDdhZDd0dmdCNDJlVDRpYkRhZU8xdXp4?=
 =?utf-8?B?K25zVWFJTWszNGE2M21tQnpoMTFhb1crRlRqWVIvZFpSQ1U3UlFRTDlVdlMx?=
 =?utf-8?B?c21FTlJ0cytONHRkQnFQMS9uaWhCTmxsUGt1YWlUVVBPU1NnUzJKZW1YbEZR?=
 =?utf-8?B?NXdmbU54aVZ2MjdTU25oSjJrcDlWZzdjU0VXMGR1d2RnRWVPUXp3ZzBRSE1H?=
 =?utf-8?B?OTl2RFZTS1VOR01GcHBNZ2wxVGMvV0VucXFWNnhnazlwT2RKbVBTRmxLSWlX?=
 =?utf-8?B?MVFCVWVzZm5zOXN2cGwvenFRMGs3R3Zoemg4c1NITndpUFdtWGdFSFNsbzly?=
 =?utf-8?B?WCtpOTFqbGJBYXl3NGgyZ3NlbkFlcjhSOXo5dVRxOWovcDAxZ2V1bGhERFpT?=
 =?utf-8?Q?W7aIsx5Z/53mT97/vMJcVm4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9407f1-5ad1-41eb-c500-08d999244498
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:32:10.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHWSdhA9790TP7wjnetm7ylYYlki36/BiJkjt5KIa9PFa+rY0DtJ0miKQSX0mDNWRSlaSd1yuud6mPQPcVGVEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 17:27, Vladimir Oltean wrote:
> br_fdb_insert() is a wrapper over fdb_insert() that also takes the
> bridge hash_lock.
> 
> With fdb_insert() being renamed to fdb_add_local(), rename
> br_fdb_insert() to br_fdb_add_local().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c     | 4 ++--
>  net/bridge/br_if.c      | 2 +-
>  net/bridge/br_private.h | 4 ++--
>  net/bridge/br_vlan.c    | 5 ++---
>  4 files changed, 7 insertions(+), 8 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


