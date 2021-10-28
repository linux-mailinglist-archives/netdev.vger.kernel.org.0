Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F08B43DD2A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhJ1Ivc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:51:32 -0400
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:22049
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhJ1Iv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:51:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3C/2Z6C7hnpeOErQNUwVu1osM2yNEIuF30dRHPScNYQFz07pVpFgODEdGN+NOueOxVFHK0w7uE+edEMx7Aeaa1+jpgatYUXw5xEmyn5LVqKzF+mXVVvrkbwRoMhqluGvWwyROx+nvuWDjMvNGNg+F7TzvLei1LqNVeW8aY4ezc2VLlq95ePYsmSMR16y6JpjL3vRPhaJmgPFwve7+5R4zphsICcSU5TZ0bms2Wj2QyY65T61cR7dBEv46N7LdJ3KhQuXEk7kDMsWDKOMfBoEXvWBHYvuGUtjoUsXDqKt9Q0kR1Rdq28XVihM17A5NGwL/6e7kgAXb/4CspnJIQBhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHp9trOtMoH/1Uq2RbeQ2jYCBQ/Nipp+TAlLkgJagSI=;
 b=drfqsEx/gWqaWTzmU9nLOAwh50NRJNdJsq3pLIGeOB6/Dof8lF4FO1iUdPgAfwlvWCm8gnz8FbJGlxjU/lyALyFmaDX5yodSGxasYZPZnEvZX/3X6rcHCy9ugIg97aDKm2AknrZfe2maRfAV0OskPMlZQTio7lFEcwERd31JiEgV86ibWDbrXQANuJpDaR+3Exizt9N9G18QEvVw1K/sFUgY8QkdrWoBmOtwPOOuAV+LZagyJjKy04W587hULeCkcAerdtqb/4FPagms3cS3IBvs7RO8AfxLoP0FyKivd9kWZS03ZzmV9K16r988gsr1dzVW0YGN5TOsraj580M7aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHp9trOtMoH/1Uq2RbeQ2jYCBQ/Nipp+TAlLkgJagSI=;
 b=n6XEltHDSl1k/hG59F9hQrw1WCfi6TonoWbAe9eH3BDBSKgFLjqPp/1JW+qOBp/Jt6qF+Lm7fI19xKW6bltx2SPH82NY+YNSw9Sldxg3xI2uiKmktLlOOY1Xeueu/YxWXpAJorGqT08b0cp7Yl1CZ2Gx2xZggXJOKyxqxEyIRG4rLWo016+/fsL6tl8v3JLBSW4u7K/k33G7hZ8xdE3Jr2fXY0sXZpvXXtJ8cLUGh7WBDTGoUbaWQc/POJsaxSQCW/1kLYFl1SOYC3eDFBsTcu7WQ+5tjGecNIwiGmyCuD7F3r3WtKpRs0ukdt/WA9RcX9Kq/TKYpwbgoPgV57TXcg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5464.namprd12.prod.outlook.com (2603:10b6:8:3d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 08:49:01 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 08:49:01 +0000
Message-ID: <8a8a6831-abd5-4cea-3270-295899881c32@nvidia.com>
Date:   Thu, 28 Oct 2021 11:48:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 3/5] net: bridge: split out the switchdev portion
 of br_mdb_notify
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-4-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027162119.2496321-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 08:48:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 456073a8-5a02-4cda-41a2-08d999efc973
X-MS-TrafficTypeDiagnostic: DM8PR12MB5464:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5464AD48B9AA8AEEF376B748DF869@DM8PR12MB5464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3Nusikt2wOdMXLzDSZE5H8ktUeXw0cq4TzK/vdCnNBmqUlnEPv5uM1/jZMkx342XyAMW7t5v8zreiy/7BXdSmyBM61jRjXpA8occou58VI/1HlOHN49vMzp59rk1kxir8VDgJO0OQIDQia7SYDEM+T2uPipOgxhLdBkzb0lgyjgegkvuoa0tLjIMioV6s12EaQS+pnNa6m7co5R/ImgfFXT0YwVihfE/ilJU4D2sjT+oWmmiSFltnvo9jXCh5qwadF7BwRUojmmkJrzp97vvpxIsQcOieUnFEXLDzfscISjal1PuWSSLFCjyEiPhLtoYJlQJfFeCzEd193ZeOE14fbY0gzXuByvQUlKSprujckLRws6aYhYjEkslN5nWBbMuZC5gBfXJNCHXNrwy8t0m2zzqOMzW+8YAXsSwXV7Lap4fsHFJjalq4zu5gxz0xmH4WnCIuPZPFiOWY92T4vXzOVdvX3x+/PaI0URh9NwaiCW+NGbjXWgjQKKh7qL6k7zxYE71ITN8JeFkd1oC/jTogwSjH711T9P/w5bEb0hcYHZg1eIaiAuFRppBAiyT4FJwcVOyvqgX6IwpGfDTShprbwkG8ixvknzHgZPaLjRFJTYttWtT3s7kxwgClAc7FD932yjjG1FiRUJN9ZHgWeE5nou76iiUiFhgZqsuPPX0wRmAKI7LLZ0haejMgrRx5iwfJ8fWSNZ3H1ZwuyRIxSPMoISEFaY4HTWynRPcmSp9FwrPWuCIbPojydQs70V5YfX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(16576012)(36756003)(53546011)(316002)(4326008)(107886003)(66556008)(86362001)(31696002)(31686004)(66476007)(66946007)(508600001)(26005)(956004)(2616005)(6486002)(8676002)(54906003)(186003)(8936002)(6666004)(38100700002)(5660300002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGRsTWNSQjFBblJkWWYzN2djR1IyZEprU2xIbzRqNlphNDQzTENpZHplVmFO?=
 =?utf-8?B?bC85SEkwSlNRWm1iR2NiaUt2RFBkZy9sdXJiQmRvd0pzTGxZZkpoc09KRFBE?=
 =?utf-8?B?VUt3NXBrb0RSRjVoTW8yTnZvVEk3Z1ZPbStUeFhzZ3gyVjRxcDlLVUMyMnI4?=
 =?utf-8?B?ZThtZHhtZnZQcXRXRXFxR2h0RFAzUUhseUtqY05zRjNTQjJoemlCaVUvYlky?=
 =?utf-8?B?TlFYQXZKU1NTZ25ZQXVpZmdVZ3dpSnJoZjh4Y1VZY2NCdjNUODBjZTFTWnNk?=
 =?utf-8?B?N29UbFljZnhjcDJub0lHV1NGdWJSVXJ0WWFpbUlsem1yUDJ6V3FxQlF4Rnoy?=
 =?utf-8?B?SURRTkE2Njd1V0hJcldhbENDakhUQlJBT2NtbnlFeEU1WnNFNnllOEp1TC9V?=
 =?utf-8?B?VGZsZ1VRUTA4MFQ1dXNOMGRaVjk3Y2dpU1RiZHQ3b2g2Tmx0UFFENkROS09U?=
 =?utf-8?B?UU9Kd0F1NVA4UTRpTTI4WE9IaWZjMEZqYkZEaFA0N2tLdytJaS9QTzF1VGRv?=
 =?utf-8?B?bjhjaUdRZnB6MlhMeVdOR0FzNnRuZng4UTZCQWNKcGw0NXpJVFJia2Npa2VW?=
 =?utf-8?B?QWExNHJqaytvcnpyaGxLOFVocG12WkFGR0JMMlQrano5dTdydE9SMTZ5Vmo4?=
 =?utf-8?B?dTNmeGJObmpvWjdITkdKQS9RdWhic0lZZnlqRjNoaEVEWXU1TC9weEFwMVBI?=
 =?utf-8?B?dkRLckxMd3l5cVc2aWZzTEFsUnlRZzVZQk02NnhySjJpZ3Q0QnoyMG9rb0VB?=
 =?utf-8?B?bWM4bHEzZXM3TTVBT1gwT2cwemhoUWhJeUNVdWJhZ0syeUNtUVpONGlNelRi?=
 =?utf-8?B?dDdqa3lrRDFTU2lXcTdUVnFFZUY2aXhmWW0rR0RrZnJxMFFrMk04VUdoS2Jy?=
 =?utf-8?B?RzVNREl1VElMQ3FPQ3E5a2FtOWlURFB6anVFaVVCNS9oTFo2Z3lPK21CT0J3?=
 =?utf-8?B?dTRpbnhyeUQ3dkNaSFlyTHVnSmtLRGRzd2RUcXNWR29mRlpZMVNhQTVVMHJq?=
 =?utf-8?B?Q3F1ck9IenNRNi8xUEVkeitieW5SQ3Y1cWxlR3BTc2p0RHZ2bkYrOE44ME5F?=
 =?utf-8?B?L3lveGtKZmZJYXV2SEJZWm9GNndEcHJQdUtXazJRaHo4RkQ4MUticHBGditt?=
 =?utf-8?B?NFNack5QbTRHVGVITkhPTXM2YXYwUllwY1dkSGdndDdFb2xSUWc1N09GTXV0?=
 =?utf-8?B?TGtKVVBiUDBqeW1hMzRrT3hENE9GTVV4RjFoNmZZa1NmZ0J0ajNBem5OLzFh?=
 =?utf-8?B?QllVUnpkWGt0d2ZYZFBZZFpOUFRHNUxyajBBSW52V0UwSjZTSXRkYVQ2dkhi?=
 =?utf-8?B?Q2ZoclI0WEdTeCtnMmJkOURkYUFxYnR6MzB3V21GaDhPc3RrRCtQdHFVN0NW?=
 =?utf-8?B?N2J3cE0xc2IrVFpuVkJDSFZmSzlacTNsRFF6djNBbU8rWTFXM2psQUQ2Mjkv?=
 =?utf-8?B?OUpUcUtDdUhpM1UzaUJ3ZWpORjJKU2w0cjYvZTVlY0VnemhtN0YxRFIySVJL?=
 =?utf-8?B?MTVnSUo0YXRWK2xKN1lRQjgwSFZyNkJ2Q0Z2UEtvT0xncHdDWEdiajEvVDh3?=
 =?utf-8?B?dU9JUG4zODBXZStlY09qWDlzWSt5YlBVb2dMU09BNzg2eXVadzF4THlHbGV6?=
 =?utf-8?B?UU9Bbm40QWxQTVZNcTNDanVZQXcwemZNOUJrVS9PWEtLK3RLVU1EZGw1WEdy?=
 =?utf-8?B?T3BkSlZmN29ENng5c0crZGJFUTByZVpNYTNQQ3Nmc2JyTUxEdkJqc2JoOVRH?=
 =?utf-8?B?NWNCeGhWU0xNeDMzajBQQU1rbGhpb2F0M1huVmRScTQ5dXc4dXRPZ3BtejBS?=
 =?utf-8?B?UE9wdWFpbElXbFJ5Y3VPVFpESXNxVjB6SVNEWEZUemxaTHl2VHphU1p3SmtD?=
 =?utf-8?B?b1A0MktIRmk4WmhSaE9VVmV3R0dYVGg1ekFuMU5ZTFREdFlhN2JpeEdZTWYz?=
 =?utf-8?B?UzROY1RuUVZXYVczU0Nwd3crU3IwdUM2MjhkK0hCUHdLeXVZUVFzTWFjdDcy?=
 =?utf-8?B?Wmx5Yzlrajgya29FbFVJV2JiYWhnVWVuVWZNM2FBdURLNFExZXliS1JFNEpQ?=
 =?utf-8?B?RU1PRlI1RmVVcHVOZEtQaWphTDZzcklzdnZoalRuNEtIQmxDWXFwZmZjTWJ0?=
 =?utf-8?B?ZUllTHJwbyt4L2QwYnRWTThOOTFoTE5jMUtZcTN0ZFNGL2pubVZnaTdGMitZ?=
 =?utf-8?Q?Q4wDOBe+Q9bdGT+ig0cd5N8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456073a8-5a02-4cda-41a2-08d999efc973
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 08:49:01.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /v8gSch5tvYzp7t7IH0leNfkDTr3eRDjpbAnieYkeIvhpHQ8Z74Giap81HWYH7wbmP/xCBY9bxn3NCJvujcSCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 19:21, Vladimir Oltean wrote:
> Similar to fdb_notify() and br_switchdev_fdb_notify(), split the
> switchdev specific logic from br_mdb_notify() into a different function.
> This will be moved later in br_switchdev.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_mdb.c | 62 +++++++++++++++++++++++++--------------------
>  1 file changed, 35 insertions(+), 27 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

