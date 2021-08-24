Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B283F3F581E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 08:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhHXGXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 02:23:50 -0400
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:24222
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229854AbhHXGXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 02:23:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsW0noQqhKHCWhRfVy+r7W6lr98NRfPNmDxRELyPyjylwA1tq+fC+P5TgcAcTorVvJ/yHP1EeNcFUFkQnAdQvyH9/5KUMj5EJzptB2u4Y7rYTr8FomtJDXqmNBX0/21XH6CI/P1nDjQHKGBC7eRaVN8SNQVclOcd8YWyShAW3QQ7C2DdLUN5DqF1+mrj0LZBKtwGKrahqg4SVohVIhRtOQfLHU26ZcPIyXHO8zR78MQ0VWCVJGFsdALENkNKLb1hQnde2Sje4qu7gJ73PnJYdEOmKbaBX02vVSBcBaB49RZCI/ykjtpKXbR7kbhrSXVNsKyxlPfs845v+kzEKyuwMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQoxIUOFRFDHL/1iUhlMcFYV5mSGLqlTVXko29CdRKU=;
 b=K2jLogtZsVZGIzOpgcNwdn9IwlEIlkTt0HNbPpqhlyeQvwYMa4kDe0TIqjFQa7UOHZ54MpOqFLYEtS6DhzY+YJUhyUCrAVfpdAJMncgZRqyCssfHbDMp/NJgP51zgcd+legTlFMked/8UB4qKK2qkjszAmZ7dN4INZ5YLluZcpGU8WCdgcjokRzOYVrM+OZP2sctDOnqS6h1iS1Ldg1BkpYcV6T7VclrGu6YnJzLPTufhs7hcQyl3dFUqVatOC4lhBezSTPw2zrVHG+kqg0NsZzSim3nxw0b17z2oounydOdEqEI7HLFjIsBAzV9TfzLwsgbdreoQ/9L+9uWmb7tLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQoxIUOFRFDHL/1iUhlMcFYV5mSGLqlTVXko29CdRKU=;
 b=hr7wBPiEj+19AVrNB3pevHMWCFHA1Fj4j2LKf4EmDNMXpjXceZdoz0IiymYIO6XODCLIY/CiKudE+wqM1kGTMU8ADj0X3dxpCCxjIzzFMUxzEB5Qw1oCbIrvr4xMdosVwVgzTINz2RaV+YozUpD/QaFwMta/fgwwQsaMguxS438GWydb+SE4iz2MGafm7LnnE4Q5Q9qPKzZhkoterCh5drbEgK4VjXBoy4WLRWdkzFmzyOM1at30D6HX5H9EndTS+bSpoRZf5hF0di+BEioApDisbZdaLLYpI4ZBwl9yQvyJAIRDa0yAJPDJDgs6zWqz/aOnvhN7ZfE1E6sNfpsMoQ==
Received: from DM6PR02CA0141.namprd02.prod.outlook.com (2603:10b6:5:332::8) by
 MWHPR12MB1614.namprd12.prod.outlook.com (2603:10b6:301:f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Tue, 24 Aug 2021 06:22:58 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::99) by DM6PR02CA0141.outlook.office365.com
 (2603:10b6:5:332::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 24 Aug 2021 06:22:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 06:22:58 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 06:22:57 +0000
Received: from [172.27.8.76] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 06:22:55 +0000
Subject: Re: [PATCH rdma-next 03/10] RDMA/counters: Support to allocate
 per-port optional counter statistics
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <dledford@redhat.com>, <saeedm@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-4-markzhang@nvidia.com>
 <20210823193020.GA1002624@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <736545a9-c5a8-5f0c-8051-9f519c8bad89@nvidia.com>
Date:   Tue, 24 Aug 2021 14:22:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823193020.GA1002624@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16398c90-66a5-4417-2489-08d966c79e1b
X-MS-TrafficTypeDiagnostic: MWHPR12MB1614:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1614A87402E4FA2272C7804AC7C59@MWHPR12MB1614.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GBW0TtU4lD4Ve47OerCJTyWToAuxn6wrRFzQ8SiA1c8HqTP4pbkxIYQBPo1bmNT8fDpV9mYIwmeOaJmbm7mBzWERQQXGTxgMofoXkLvS4ntOTuBVt3PrcP+/XGQOxJ5POdZeJ5ulBPzKDsdMXOugev+iD9JPodYbr2KmYag8OICYMGQ8K91CYqUBJsUE+rH7RwzUuI/tU57Ujq4XQ0/Z1EQiD++KakVwx1BIiW1RKG3lwAPp0b8y+KyWrqXp62+s7lSv5cS9fNXLn5WbjABzDmue9+0ug7l1hDj0CSTHmVPfktbVmBCxouzQ1YvfJUYb5OgXrBiPomUZXZOkXvi2BI/r6qIH0E3safFeombIUSkb5w+wWK2E/25X238LFfV0nNpBCLo53sS5QTo4lnnacnk9GHsBD/1f+MVMSImGs8lu0fpIWw79Q4+Mii3Z4mQrBTsEpHBJS0Ky5eqeTMA9tT7VgQ7ljNZngicimxSMAtr+A0+cdxxAxMheZvOy2Meog2Wjmn37M+L3zXgtNy7DjsItE5sYYat3bCukQJp81Bc2E8mntLL7EJQ5h01am+odNFlJetfhyUroW/BaeTJ70jCyeghIZqYmHG46Gn9gysQ5NWAXmGehU5kkCJnqfyBIyPRKNm/bBW3RbzCkE+7avyn5tkAEgOvZM/Z5XhA5Xgl7QZ+2KyoQQnmI0vMfPrvJqP14B+r+pM1RAukJhzus6f39R8Ymi73UQfXBrGZrcPY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(82740400003)(4326008)(83380400001)(31686004)(7636003)(107886003)(8676002)(2616005)(6862004)(31696002)(36756003)(356005)(36860700001)(47076005)(86362001)(6636002)(82310400003)(53546011)(26005)(186003)(16526019)(426003)(37006003)(16576012)(478600001)(5660300002)(36906005)(54906003)(316002)(336012)(70206006)(6666004)(2906002)(70586007)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 06:22:58.5580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16398c90-66a5-4417-2489-08d966c79e1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1614
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/2021 3:30 AM, Jason Gunthorpe wrote:
> On Wed, Aug 18, 2021 at 02:24:21PM +0300, Mark Zhang wrote:
>> From: Aharon Landau <aharonl@nvidia.com>
>>
>> Add an alloc_op_port_stats() API, as well as related structures, to support
>> per-port op_stats allocation during counter module initialization.
>>
>> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
>> Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
>> Signed-off-by: Mark Zhang <markzhang@nvidia.com>
>>   drivers/infiniband/core/counters.c | 18 ++++++++++++++++++
>>   drivers/infiniband/core/device.c   |  1 +
>>   include/rdma/ib_verbs.h            | 24 ++++++++++++++++++++++++
>>   include/rdma/rdma_counter.h        |  1 +
>>   4 files changed, 44 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
>> index df9e6c5e4ddf..b8b6db98bfdf 100644
>> +++ b/drivers/infiniband/core/counters.c
>> @@ -611,6 +611,15 @@ void rdma_counter_init(struct ib_device *dev)
>>   		port_counter->hstats = dev->ops.alloc_hw_port_stats(dev, port);
>>   		if (!port_counter->hstats)
>>   			goto fail;
>> +
>> +		if (dev->ops.alloc_op_port_stats) {
>> +			port_counter->opstats =
>> +				dev->ops.alloc_op_port_stats(dev, port);
>> +			if (!port_counter->opstats)
>> +				goto fail;
> 
> It would be nicer to change the normal stats to have more detailed
> meta information instead of adding an entire parallel interface like
> this.
> 
> struct rdma_hw_stats {
> 	struct mutex	lock;
> 	unsigned long	timestamp;
> 	unsigned long	lifespan;
> 	const char * const *names;
> 
> Change the names to a struct
> 
>   const struct rdma_hw_stat_desc *descs;
> 
> struct rdma_hw_stat_desc {
>     const char *name;
>     unsigned int flags;
>     unsigned int private;
> }
> 
> and then define a FLAG_OPTIONAL.
> 
> Then alot of this oddness goes away.
> 
> You might also need a small allocated bitmap to store the
> enabled/disabled state
> 
> Then the series basically boils down to adding some 'modify counter'
> driver op that flips the enable/disable flag
> 
> And the netlink patches to expose the additional information.

Maybe it can be defined like this:

struct rdma_stat_desc {
         bool enabled;
         const char *name;
         u64 value;
};

struct rdma_hw_stats {
         struct mutex    lock; /* Protect lifespan and values[] */
         unsigned long   timestamp;
         unsigned long   lifespan;
         int             num_counters;
         unsigned int    private;  // ?
         u64             flags;    // 0 or FLAG_OPTIONAL
         struct rdma_stat_desc descs[];
         //const char * const *names;
         //u64           value[]; 
 

};

What does the "private" field mean? Driver-specific? Aren't all counters 
driver-specific?

Thanks.
