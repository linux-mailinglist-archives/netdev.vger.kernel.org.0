Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3701CDC51
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgEKN6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:58:23 -0400
Received: from mail-eopbgr20083.outbound.protection.outlook.com ([40.107.2.83]:31855
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730153AbgEKN6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 09:58:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axbLzXV4JYFP01dvZ9fPapdswcnvbaHfuPhtgoYShCHwGizamxujxbUgljx/MGUjPDI+OwlR7yZCNjvA0ULEhaEFaIZ1dCtcJf77mkddqb/qtIeAxywa6/rJFTRgePWPaNFfQ4ADa5v4Kn9NevUqEJMZfV7upRhYId97Pi6n9UnWvl87qEfWTXOd0NBIB08n+GvSgIZ2B43FHaRYtPZrvvXtxYU0zvCtsJULEedpUsQ6HBmhYZdA8YqeMDer8G1eKiKTuXyL0h0oZ+Rp7iQvghfZBshGsZ1DZMVBiN2DfF3Czsa5LXIXTfR34ArHz5wuzYVmef32lNL7unQcYNsamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOLbZ3UmbUowll4ZdmR+gDRr5We3ir4G0hBKTUh/OVU=;
 b=dTnZi8sMsr2AdU5btTS/qanoXzviugMovrvMxERLUMqcRSe1zaZn+SBO30jGdsuVmrnjLxbz6rAxYWQNlGdLPPrH1f02y83F/dC0Wqrz19yRfJro6BNJsa2Vbzn1OcpcRl8TeJBS7H5fnGxA6S/AY411GxTGjfDAbY8WdZFjbDneK8Oyl7TGmpEJx7MUb0OQvKwLhmvdilEIEnzPsyfzTOr4Eax/VEM3D8g5UWKNUoNtRY8xA4swg4fAfZWSAYD8GSEljQFBsm9Zz1NFhhGn+rZjmERFT1Veu/E8xY0gGEbrvgr3RGTEZMnYICynmbk0JKIoOvTrOYAM4oB1qH/jWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOLbZ3UmbUowll4ZdmR+gDRr5We3ir4G0hBKTUh/OVU=;
 b=GfS5JcgS6Uf8jpurok35lXgSF1+dWcVwP+c5fawxiPIeogENLvXKfWwSz7LRZFUjEn760kDp/wuti4iN93jOEq1dNqgWo6fZ6Up15ClD14jthTIvbove99d56PaDtCZIa+JGFvmkmqNsF3U3E2zf+loQGyDtwqlLZiVpdY9T/f4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB5066.eurprd05.prod.outlook.com (2603:10a6:10:15::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.33; Mon, 11 May 2020 13:58:17 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86%3]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 13:58:17 +0000
Subject: Re: [PATCH net] netfilter: flowtable: Add pending bit for offload
 work
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
References: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
 <20200510221434.GA11226@salvia>
 <9dff92fe-15cd-348d-ff1c-7a102ea9263c@mellanox.com>
 <20200511115939.GA19979@salvia>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <a06b3615-3765-a0e0-202a-71a018597a42@mellanox.com>
Date:   Mon, 11 May 2020 16:58:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200511115939.GA19979@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0003.eurprd03.prod.outlook.com
 (2603:10a6:208:14::16) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM0PR03CA0003.eurprd03.prod.outlook.com (2603:10a6:208:14::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 13:58:16 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1cb312ce-a3c7-40ff-5f63-08d7f5b35b4c
X-MS-TrafficTypeDiagnostic: DB7PR05MB5066:|DB7PR05MB5066:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB5066E27AD54E9BCE84CFAB9AB5A10@DB7PR05MB5066.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mrBmTAAy4a1CAqDHtF8q0d2KrflexuNSaa+nz6v7MPhyPLjGuWvrF7DWMl7qwwMwrqSfn0iYA9Z2/u9IV3/7l0ZCtIi8SYmvOkq1D6C67q3AyBXEFsDgRCaDufLO6s9pYLmdi8PpfWpzRzzHSNOxFLfmcsZVxY7ZpF1bIIaBd/jfKFHdAb4PuWh4HvlDwlQyw4Hm/Ip0HU6aJayYJnFl8l4DbR1GRpop4gnhFDdH3kvbu0LmApHDoNKUeP30ZwXiTqKD+X0CmEmVbT2yJqum98TTsg4wmTUT/RwQmLr9FGUf5YFfhU/67XhEd9LNQBEj02k9Qi518wryMGN7/e6B6yjH0pGCx8hE4caQlKPYyUXVT68ZdO2UuU95Sa6ucFY0L4b8CF/Tm1KAjS/az49nRpeus0MtbpblKrcRD0fePAocWO/kKDjDIwxSKScRK/pygM7BGbkneLvtCOOpRj+Eti3ufKhaBestvcKYJz2UApbIglWx7EhE52Vb4i/T5g3rRTevTy5tRUoLC3TUH8+lZVt0SFgB4BvJHSdqhPSQDy76j+FCpZhJVZ61eqqfD8a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(33430700001)(66946007)(66476007)(8936002)(4326008)(6636002)(2906002)(2616005)(956004)(186003)(52116002)(54906003)(16526019)(31686004)(36756003)(53546011)(26005)(316002)(8676002)(66556008)(16576012)(478600001)(6486002)(110136005)(31696002)(86362001)(33440700001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Xt7n6FJKoArAZP60WyFGuzDSEP9Zdv7zlG7QwnyMcS9vemRlfunUdGedg1MJmlJJCd6N0cemiiXkzcJogidm2ELFRXbadWvmniPUUonGsZymbyBX991NuzBtdKn+gW3K9huISI7SYeerqnybWg8PYMcJdnJVizjYU1d7nTy1Gx/TeBk8We2L9JYrlZfU3vX7u2VPsMq2LC5yiol5/jFYRVirpe+9oZGo++a0oeE9jMilwf6CMNE45AwnEfwZb7tAbGpXTEcR3jUN1wSRachzz+vTsv9ktqajPkIPDI0DuR0YOTQp9ECYkOJ3ooaQJlyAwTuxVqorz0ZPYko0als3LtRnsic0vCViFoVIHhIaVM2DCjLMbU2LXhwkFrCinBp9z7gtyVG3sT3IXbU+xmiLdcHKHR2JLxNludIcxwRtmTS1JzXrvnjBL4aMXw/CEO0+CGQJLllfbZ8Nw4vd16AAedS2FcDbhEF+slmRtYhyllKOs1FJzTomHUvWpMrnCS7p
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb312ce-a3c7-40ff-5f63-08d7f5b35b4c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 13:58:17.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0qM5epCWsPICugndhAzEJ8SOG6szkSsA7jz1WQhu5nh02cX6TOkwd/S9P7CZWftgM8Fs4O7wKKWdvBm/at4nhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-05-11 2:59 PM, Pablo Neira Ayuso wrote:
> On Mon, May 11, 2020 at 11:32:36AM +0300, Paul Blakey wrote:
>> On 5/11/2020 1:14 AM, Pablo Neira Ayuso wrote:
> [...]
>>>> @@ -831,9 +832,14 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
>>>>  {
>>>>  	struct flow_offload_work *offload;
>>>>  
>>>> +	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
>>>> +		return NULL;
>>> In case of stats, it's fine to lose work.
>>>
>>> But how does this work for the deletion case? Does this falls back to
>>> the timeout deletion?
>>
>> We get to nf_flow_table_offload_del (delete) in these cases:
>>
>>> -------if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
>>> -------    test_bit(NF_FLOW_TEARDOWN, &flow->flags) {
>>> ------->-------   ....
>>> ------->-------    nf_flow_offload_del(flow_table, flow);
>>
>> Which are all persistent once set but the nf_flow_has_expired(flow). So we will
>> try the delete
>> again and again till pending flag is unset or the flow is 'saved' by the already
>> queued stats updating the timeout.
>> A pending stats update can't save the flow once it's marked for teardown or
>> (flow->ct is dying), only delay it.
> 
> Thanks for explaining.
> 
>> We didn't mention flush, like in table free. I guess we need to flush the
>> hardware workqueue
>> of any pending stats work, then queue the deletion, and flush again:
>> Adding nf_flow_table_offload_flush(flow_table), after
>> cancel_delayed_work_sync(&flow_table->gc_work);
> 
> The "flush" makes sure that stats work runs before the deletion, to
> ensure no races happen for in-transit work objects, right?
> 
> We might use alloc_ordered_workqueue() and let the workqueue handle
> this problem?
> 

ordered workqueue executes one work at a time.
