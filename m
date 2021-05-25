Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786A338FD34
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 10:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhEYIyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 04:54:09 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:32256
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230471AbhEYIyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 04:54:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+YOGooONLX0QRvVUM1EypBmTAmBAftaztC57vaZtgUu5tIaZIOy4WyzftmiRwuBX1EuKGimmPa1vmHfPVote+V5rbilOh0CLgh6d+0Pn5Yqegl5UYzeAtmnkFe2/VF4vHPMNw515LEca67uo30PwyiLaOyYhvC8m6j9Hid9V0jSlhC6Us6xkkfNMRsBwzJbYVf5Ysf3SZH1Mbs1jS4jHX1ALmaqm5bJ6o5V718a5/J5fGGagJoWlOh/TLAJP3kwmF9N8D+vk30RVrzL0YMC5KW1N9FNyiPtZ14VCxrWt/8xBNduLFDI5bRAYgMJOuOBPeBkXrQO+m/trIDHqWtd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lpuYq+B5jYqSYs3cXwcubl0A0rn3HUOUtMhWzAsuNc=;
 b=oLd7hco4xjvk8WbhVm8MG8tmnJUAosFzwys5zQz5NHAphz6tLDcfnUYCVTuv3H3U1x3UHTiR/eL7uoayV4RU2ip+AtQ0J7LrOg3a+5a8NMnTMBksxWHaY2210QBFOYgucBSiDBb2ZJcBcCNZiO0xKvTljfU1kZAVaQs/MZS6nIHrX2NcYny9HU7cb+CeCa7feBGzwQpjncU2Nkm3RIVldaVPgbYDaTgB0K2I/l0P3JbS0QDJElDZKDq8ia6S/kCbC6ZmdwEioaBdxy95bKx09Zz/yoI6Ll8er4du2JM9+OUPtmv5XWEmphsgAH41yuAb4LATuA6fkCBJJwl+OpgjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lpuYq+B5jYqSYs3cXwcubl0A0rn3HUOUtMhWzAsuNc=;
 b=F9Xrf7DKLHmiAMrce2iCMXO6yhUwWlp168nCfE7H96edI1SZczOtF6whiBCctRPpmiDLRB6cxVV7I16vb/IZ2IsrC5lA2Oo/XZx5RIewdcGG+AOFsjJOBsAoVxh4TpdGN6ZuQ933JqAQnJQYX4JrCZIi2NWXMlck8+N3dSak8OdHyK414ebQAPT+2HxjrFFAP3po4uU3BoWQfOMsFcMpCxzAK8IL8X0pOkN/Gzh7ZJfPlE1tT6ri1wiJlCR+Cmqpg643JV6OYhtcInXNII1XM5vKPq8RKwF3loGLV49UWB3cicoaahBvhDMRoihusD7UJyVZf0AzvFGtsknXy4DWLw==
Received: from DM3PR12CA0113.namprd12.prod.outlook.com (2603:10b6:0:55::33) by
 BY5PR12MB3937.namprd12.prod.outlook.com (2603:10b6:a03:194::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 08:52:38 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::d0) by DM3PR12CA0113.outlook.office365.com
 (2603:10b6:0:55::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Tue, 25 May 2021 08:52:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 25 May 2021 08:52:37 +0000
Received: from [172.27.14.13] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 08:52:34 +0000
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS device
 goes down and up
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
 <20210524121220.1577321-3-maximmi@nvidia.com>
 <20210524091528.3b53c1ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <578ddba5-f23a-0294-c6f3-d7801de0cda3@nvidia.com>
Date:   Tue, 25 May 2021 11:52:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524091528.3b53c1ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f489159-c26f-4add-476c-08d91f5a7296
X-MS-TrafficTypeDiagnostic: BY5PR12MB3937:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3937367C710C12CC8F0CAB6EDC259@BY5PR12MB3937.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vawCkLWouzdhU47xDPZBrT74KEMHZ+5WXkRglzIX5eU/EO0JzTGspXgIGE6x51qSBYZOAF/hm4cIfiGbZqbpNUVCFFNtp60mxWE1oe0oErqkdj4U2XtU13hCfx9A8IsjcuD+oQIXkBiHFYIhr8AtIxhb1UYVkNr1TxpjPAY53E62RXdFiva65fm+cDgbRC2c0+El5VQ2CR7PJjSRiSLdV8kX7j9kNT6lUd3b81eEumB4pgvNWA8+UiSxBXdIDWTm0bnW49ZbH3d9DHWIPmr4TzXC1iuJgfaqYw51Q9KSCr5yuNIrUu1BnnmQwx6rKnFzADKjIJYw0oKJiIfSdwIAL5aHIA5Zf55d/TfvUoqghALaDax0MTn3mZg0glQRQgLws20dg8DTp5KD2TeD0PCVKI91pOK/skcYpokpbc1by0cjNYaWvyiq8d65KfNLeFz/NLOAADDhZyeKnsAd0a+9JBTbo/92bNM0tUjToR6Y9GKb7Ddqw6WZrJZR323l7nSkYYD/HqNhNSSidGi9QGvTGtLC+gRwHTrOmrbWxqg32atK597DbCKkN7BuMrteOjwOQ4JQ874rPTayiUUOvc929JR12xGc7PVw8AMWwEPuoKgb+IVKC7gWJl2/+kgvAwFPeGKkv9ncqEmVrtlh6PwSZVs6ujZXiNBiOeoaUXxDXsByh3byUr4LmRQe39u31X2c
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(46966006)(36840700001)(82310400003)(6916009)(26005)(31686004)(6666004)(47076005)(36756003)(4326008)(36860700001)(186003)(16576012)(478600001)(70586007)(16526019)(86362001)(426003)(2616005)(31696002)(2906002)(54906003)(53546011)(356005)(83380400001)(336012)(316002)(82740400003)(7636003)(70206006)(8936002)(8676002)(5660300002)(36906005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 08:52:37.8395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f489159-c26f-4add-476c-08d91f5a7296
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-24 19:15, Jakub Kicinski wrote:
> On Mon, 24 May 2021 15:12:20 +0300 Maxim Mikityanskiy wrote:
>> @@ -1290,6 +1304,26 @@ static int tls_device_down(struct net_device *netdev)
>>   	spin_unlock_irqrestore(&tls_device_lock, flags);
>>   
>>   	list_for_each_entry_safe(ctx, tmp, &list, list)	{
>> +		/* Stop offloaded TX and switch to the fallback.
>> +		 * tls_is_sk_tx_device_offloaded will return false.
>> +		 */
>> +		WRITE_ONCE(ctx->sk->sk_validate_xmit_skb, tls_validate_xmit_skb_sw);
>> +
>> +		/* Stop the RX and TX resync.
>> +		 * tls_dev_resync must not be called after tls_dev_del.
>> +		 */
>> +		WRITE_ONCE(ctx->netdev, NULL);
>> +
>> +		/* Start skipping the RX resync logic completely. */
>> +		set_bit(TLS_RX_DEV_DEGRADED, &ctx->flags);
>> +
>> +		/* Sync with inflight packets. After this point:
>> +		 * TX: no non-encrypted packets will be passed to the driver.
>> +		 * RX: resync requests from the driver will be ignored.
>> +		 */
>> +		synchronize_net();
>> +
>> +		/* Release the offload context on the driver side. */
>>   		if (ctx->tx_conf == TLS_HW)
>>   			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
>>   							TLS_OFFLOAD_CTX_DIR_TX);
> 
> Can we have the Rx resync take the device_offload_lock for read instead?
> Like Tx already does?

I believe you previously made this attempt in commit 38030d7cb779 
("net/tls: avoid NULL-deref on resync during device removal"), and this 
approach turned out to be problematic, as explained in commit 
e52972c11d6b ("net/tls: replace the sleeping lock around RX resync with 
a bit lock"): "RX resync may get called from soft IRQ, so we can't use 
the rwsem".

> 
>> +EXPORT_SYMBOL_GPL(tls_validate_xmit_skb_sw);
> 
> Why the export?

Because tls_validate_xmit_skb was also exported. Now I see it's needed 
for tls_validate_xmit_skb, because tls_is_sk_tx_device_offloaded needs 
its address and can be called from the drivers. There is no similar 
public function for tls_validate_xmit_skb_sw, so you are probably right 
that we don't need to export it.

> 

