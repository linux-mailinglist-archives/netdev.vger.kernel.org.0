Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9B1BD7CD
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD2JBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:01:37 -0400
Received: from mail-eopbgr00069.outbound.protection.outlook.com ([40.107.0.69]:12033
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD2JBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 05:01:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvDgtGNN3oGnYSvc92kPX+w6ltxFGSiuyHJzWUsCW4RTevvRfbKl1c+FPdlf/u9T5jRVtYiFSvtdDAnZWU4iLmOY0Mgq/g8SaCANE8CiZx6LlUpapml+X+ail9Rjh+4h4h+KBvJkpKu5QkeBkiNjFZ4j/BpDUxg7tUviBYeuAQYjQEoJCdL7rRaLBvt1IYc9tdxtsRzGnwUs6haTPh0WhPs98qCDUtzj2QdJDd7/dVAQgTxoO+/oRuJaV+PRwGjEkV1QP9fFySOKAtvIM2RpsKV9P7gADN6fiCAry7K5DiNyUViPjZvxnkSUJKKEIPSpgS5EgVgX8rC8cIkrfAltJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpFIj4Cajz2NB2djHCMoE8ZqO65P+avMTNbETQPp9Ek=;
 b=AbFpS5N1zf63Q0A+X0AFonKsIHYvi1d8lMLLaK5QVHBiW8wLO0YNXpXyRsK0CJh8kQg7vHwwoQUkl0VxBVNCNonTDQBuxlW2JB+6RYBfTn3ubPdImCqzGkbdROO/bgs6xPdfgVlefh5l5NCbO5N+42SMruNjeK8PX59Q+QtW3ULal516d0ilpnCfLbqMiyOy9zW93o6Y00+HP6GnbuMpvGWMtI8URmYXL4Ibz18jdyxo5OT1TZOVOpWHM2CBsBWE2jawvtvx0H0LsctNXap8fABDwq9K6mOi0dZA2U/o7vHHbYNmY0Rq/5UJ6Apj305Fx9xs6JdYZ4nQYHuzsDmb8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpFIj4Cajz2NB2djHCMoE8ZqO65P+avMTNbETQPp9Ek=;
 b=Efnj02nQdPEJ5xHCy6A7V838M4Ciu1oZ3rZbLX2nWXZSw9bfV65O9lbCuEO0SNT/B1Dnq+YzLKOW2gBhGtS4jKkdZ3NmQT/bylYuZln+Vd8AafQnL861H8m/6oV8+AaWYZMel3rCCUwTZJCgD9td5nZh2NakeJ1UIsEPxmR7thg=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB4628.eurprd05.prod.outlook.com (2603:10a6:208:ae::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 09:01:32 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 09:01:32 +0000
Subject: Re: [PATCH V6 mlx5-next 11/16] RDMA/core: Add LAG functionality
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-12-maorg@mellanox.com>
 <20200428231525.GY13640@mellanox.com> <20200428233009.GA31451@mellanox.com>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <a7503b0d-68e7-3589-33fc-cf9b516d71b7@mellanox.com>
Date:   Wed, 29 Apr 2020 12:01:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200428233009.GA31451@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::23) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 09:01:30 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ce675b5-202e-48ed-6e76-08d7ec1be97d
X-MS-TrafficTypeDiagnostic: AM0PR05MB4628:|AM0PR05MB4628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4628DE7C4372FA27FABE65E8D3AD0@AM0PR05MB4628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39850400004)(16526019)(4326008)(86362001)(6486002)(31686004)(478600001)(31696002)(6666004)(37006003)(26005)(52116002)(53546011)(186003)(5660300002)(316002)(8676002)(16576012)(2616005)(956004)(66946007)(66556008)(6862004)(6636002)(66476007)(2906002)(107886003)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ptuXLw1fRfloTJjgEk83BhOz8h1ux4jqh/Hc0R1NhXF8ImXuTsXhSnhrKx0OQju8FDsQixJNZDB63Ene4JmZOSJCSlSTM9I+FTE7cSd1lf8l9A2+ymqcfAeMHkiF0eSd3WiiinOaUR4UvNG6uLIyAyv6L6lVkDq+EYMPUqePmpSZNmHL4efrOETKK3VjR0lQ8rtHCmY3jBGzsqk3Pcv5irrvP+97HlQReVELakMqYa9Xr3O40x4Z4u53w7apFl2CVl7omUOqBHwXI6gdE28gpDhr5uLdeLZ9PWqSjvuXz+OZqAUdz8bcsorVOx3FpDh5yV3rB1qQb0GC6hKjcTWqdqjkPXbxgktg8M5zdYa11nx033oo0mAYzPayszKpXXiWB18BJBpr4W4aEBN++QhZgVQDJqfUzSC21664izrkh1KsvBvPwbFioF/AGD9GCW9u
X-MS-Exchange-AntiSpam-MessageData: cfLvvcfZ4oviyBYPZNLoTCU0aN99Y682JfM5Ld5QsJ9EaM3MjhbBBnCzt+0uva8mRMz/mg6LzvrimMsCs2Ev+Hq5m5VWp3FM/dtqSpNg/V8X4/ghZpVst0u/VD3nE17g/wnICxe5FkAgOcqQytUiyQyRQ9JOJYbqDAjStdlIkJLZ0sH/zKpMIcaCk9elkM/ZjVKHGQrp5aABtKGsepSIleDRbzjRx6kde+0hU8d+bV8meZuY8xuLqHXyC69Y2yVvkedFTUoik6E/QpIQKUaKC5DYYCFTzOSKaMwZ80nkaybCVdgv4SK+S5m6AlKMh+UpaTLlEMs0QuJlqHuoChZXohR2RtmjPf42T600viHkpviHPSwlvhLOaaJ3uSxPDau/K/oV1yhvJRfAmyfWyGx/BCrIT77ZPAQIRIbxpEfYbUN6GqIzOUxbuiy1HaW/BhuEiy0Jzpr9st5ttY5+QSISQ0+UgBWPr8afW9h8C6Kms8eBH8DM4Z5zXnUz/DT/J5IjcMqS1Azo1Hlotm3K0MKiqJ77RsPoErpkTyd/aYVQOIIZ/lJrqzaD/N1C4SlsfOodRM4uGoabTwywDpzqtROW8i4AwLGEqxwoa+bT+t0e7yMNXDEb2P3RwrqduVgcQi9SZC+jULU+tjrDnc07u/2oS9nXt3D6NfryQ8JBT2faXtniB7Ju4Zw30P8yVWdka4yFxItAFGmEptgZhYlUN2EFs13aphub+UOyRtAKOY2BweeWx4PAFUidL5PaIfxcs4ZMP2Ddu7EzoKdDFWMy90bz2wPYgxIC0Gcr0DmYJqmPPN8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce675b5-202e-48ed-6e76-08d7ec1be97d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 09:01:32.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt6U7cQCDymXEKKm5jeWvqlSXctl4WYe7xteKiy2Qu+RW3UIzMxI/dwsK8ymg0+EVAfuFti2IXQhEKs+Kn3oDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/29/2020 2:30 AM, Jason Gunthorpe wrote:
> On Tue, Apr 28, 2020 at 08:15:25PM -0300, Jason Gunthorpe wrote:
>> On Sun, Apr 26, 2020 at 10:17:12AM +0300, Maor Gottlieb wrote:
>>> +int rdma_lag_get_ah_roce_slave(struct ib_device *device,
>>> +			       struct rdma_ah_attr *ah_attr,
>>> +			       struct net_device **xmit_slave)
>> Please do not use ** and also return int. The function should return
>> net_device directly and use ERR_PTR()

How about return NULL in failure as well (will add debug print)? Not 
fail the flow if we didn't succeed to get the slave, let the lower 
driver to do it if it would like to.
>>
>>> +{
>>> +	struct net_device *master;
>>> +	struct net_device *slave;
>>> +	int err = 0;
>>> +
>>> +	*xmit_slave = NULL;
>>> +	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
>>> +	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
>>> +		return 0;
>>> +
>>> +	rcu_read_lock();
>>> +	master = rdma_read_gid_attr_ndev_rcu(ah_attr->grh.sgid_attr);
>>> +	if (IS_ERR(master)) {
>>> +		err = PTR_ERR(master);
>>> +		goto unlock;
>>> +	}
>>> +	dev_hold(master);
>> What is the point of this dev_hold? This whole thing is under
>> rcu_read_lock()
>>
>>> +
>>> +	if (!netif_is_bond_master(master))
>>> +		goto put;
>>> +
>>> +	slave = rdma_get_xmit_slave_udp(device, master, ah_attr);
>> IMHO it is probably better to keep with the dev_hold and drop the RCU
>> while doing rdma_build_skb so that the allocation in here doesn't have
>> to be atomic. This isn't performance sensitive so the extra atomic for
>> the dev_hold is better than the unnecessary GFP_ATOMIC allocation
> Though if you do this be mindful that the create_ah call site is
> conditionally non-sleeping, the best thing to do would be to make the
> GFP_ATOMIC conditional on !RDMA_CREATE_AH_SLEEPABLE - ie pass in a gfp
> flags argument.
>
> Jason

Will go with your suggestion above.
