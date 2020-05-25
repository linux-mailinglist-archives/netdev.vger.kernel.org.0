Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2F1E11A9
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404150AbgEYPZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:25:59 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:30016
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404122AbgEYPZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:25:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJVkspIs5l8ogSmhele7YfYJ+fgc8T7dqn+i7mk73UDARhXvybPE/A/AR2tbGW+dTFDZ0doDqTLBhpuvP5z8oM9nN7StzxU3rtWzW7g/kKBPfUQEXg/GEk/vXNo11UHdBH34vXR0RhYNW2qPSENvbgRA0IdRq8Iy7gC3fg3WeMbECkUtwluWQIjSPm5UY8grJwWIuNdBU09B9b8dw5ekd3ykpAu52gqvMKgQg4jhOJoOFHd/TObNf6NYnp7thFnqc5K8bMTQZz+WSx7cXaUJyG2gIT9KbGbRgVm692W0Ah1TCd2itWHfXXWKdbnKdSKZSg9RFGsgXKmfrK/nCDNaQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpJ3DiZBKpTdjMHi4XaETzN5BNYtL4khqVnDzZS/j/g=;
 b=PwLZfz7r/IcBhl+7nqWrcn6cQwYp2YYYgRW9f1lLT1Gt/W2RT/JbDgwdXRV0fKkrKb4gjIL55WempZButTC8CZZSbL/04fv93FBD+VJP9mxu41ltpfnm1UpezzJNVLl+wkf2IZFV4SN4xniVemSlioz2YhQomyBh0oML0ZCpFQ/c0mcu+zWGS0FedemR8bNeWqDufJrkOmOyty8mwDXnCr89EanK+ZT3fEgUrf2h4Zzw9/9j1VkL++VNqkeUjwdjpb3shRtK6vmWYis/2cWsR9J8ERl1bLqzjrO5oWnQ+Hw2gdrMyQrC6JHFWAJmJDg44qzFLev5JPQ21PPtXGhhNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpJ3DiZBKpTdjMHi4XaETzN5BNYtL4khqVnDzZS/j/g=;
 b=CcB632Vic05AaXzNAsODjoHmtsWY7kIbUlbNfWiYMkhXbOR0e5+Vuu0s6z9GMbBd9OtSAlbhESttPSYE+Av3SkDhUFue6eaHRV2A30kbi2iTnAhCHEm19aGJyy/ClZG5VgV7pSX8a0Y9g6w1XKOYYGGpoKr2K4u3n4xDFKfAkcs=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB5188.eurprd05.prod.outlook.com (2603:10a6:208:f7::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Mon, 25 May
 2020 15:25:52 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::9c3f:57ee:7cd2:a4f4]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::9c3f:57ee:7cd2:a4f4%5]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 15:25:52 +0000
Subject: Re: [PATCH mlx5-next 01/14] net/mlx5: Export resource dump interface
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
References: <20200513095034.208385-1-leon@kernel.org>
 <20200513095034.208385-2-leon@kernel.org> <20200525142439.GA20904@ziepe.ca>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <418ffabb-c8d4-5999-e450-c527220d9784@mellanox.com>
Date:   Mon, 25 May 2020 18:25:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200525142439.GA20904@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0902CA0023.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::33) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.6] (93.173.18.107) by AM4PR0902CA0023.eurprd09.prod.outlook.com (2603:10a6:200:9b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Mon, 25 May 2020 15:25:43 +0000
X-Originating-IP: [93.173.18.107]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09b2c635-158b-4108-618b-08d800bfe8f2
X-MS-TrafficTypeDiagnostic: AM0PR05MB5188:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB51889D802913C84A968B717AD3B30@AM0PR05MB5188.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fd11nF5mkfqhFuSkAoa1nImK101tIuH2jozapNRROo24CHlod4X6CdM62pWPX+BmXy8yTi9TVDCe4FMQRehfQhqKZuM2idhISd7Veyg84tKCDzXvz+0e4al9t0yfEdz2UTDvJXQ4pqyP1WAvOWZz3n3mPTrgiqGOysQ+72zluJZfyN62tE34BRU5ebXpIQ9Gh1JlZhD6gZXdo/AT7Hq5KZNAyK5R9ymn0nZUQX/gRPkn+S408Y5sBf13g11nI7U3Wbsi/udUzK/R5Ke39xmpXLro9kHpxrJ6OcuLL63tGgobIFMpi6SLCxoKzRpKJ7sH5GkPNJpcqQIzaoKv1LavqHFnNqCekjkEiUPbo1FPZJKsuQES0Amav8Xl5KIfz9LV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(5660300002)(8676002)(2616005)(66556008)(4744005)(66476007)(66946007)(956004)(4326008)(110136005)(8936002)(6666004)(36756003)(478600001)(31686004)(53546011)(2906002)(6486002)(16526019)(54906003)(86362001)(186003)(316002)(52116002)(26005)(16576012)(107886003)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Gx5Jy088KNSdh02za+KyT8fAdJsTFD50LdCOFMKukQ14Xa5TtTAoN6mlMkn/p4Q3P4grxSly5fnEhTIfPTX3GLXj0G5tLJlmBNGWx+/Nl84NnN9671mHJPxiRMZNgskUHGFSM/pAW+tf2eIv9VfKcPymzfuhTnLpnRXIZIG1VXTgxVmANuNhBW7SOGw7rfjltq0BlR6gpY0fdUhCJVrC48OmYHD5r2A6/DHNjUWAMwCk2PQ4I/gzqip1MXjAclqNDMU4ioSWpg0M9QIHOHoB/xZLN5L/HJQRt4mX7gITSUC9LltG/g+Yd8SnZA4hEC4Dm4WQM67Pz/6QrLzJTbu45bo04IoaNQ/vptjtnVJ6NuYJPlaXwo53xi4l9kNg+nYz4uP/2H0TBgEVWye8OuV6Vfh10Zyn/9oaunohBXvzhQysnDIpmkhqh6tS378HUAlDHegP8V957N1f8CGzFXPuyyRBVmTQwi+zsjoUhEwqkvLOhv9lDD0Hm6g6pWaJSIEJ
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b2c635-158b-4108-618b-08d800bfe8f2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 15:25:52.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8LtCBHAQgx1Pi3EzW8Ppab6JCiZSgJpgZHF+FheGa8seSi/XJxw+XDfOpvJJlU0MU145bNKVdzZ4hyqtwiTKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5188
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/25/2020 5:24 PM, Jason Gunthorpe wrote:
> On Wed, May 13, 2020 at 12:50:21PM +0300, Leon Romanovsky wrote:
>> From: Maor Gottlieb <maorg@mellanox.com>
>>
>> Export some of the resource dump API, so it could be
>> used by the mlx5_ib driver as well.
> This description doesn't really match the patch, is this other stuff
> dead code?
>
> Jason

It is used in later patch, I can clarify it better in the commit message.
