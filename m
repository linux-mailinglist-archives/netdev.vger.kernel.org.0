Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85CC18BD00
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgCSQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:47:15 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:7209
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbgCSQrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:47:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsoTIaV+uQ9n4iKjKTQxPPYuvzrJ42T71zaqX6VVkxP57pA3fW8jW3Yfp0b3AixYTjM+bpRQsJdqY+sifQBuU4Er89tw9MdMziOzgF0eXlA/KtMehOMYCt6Mg2PYhzn9P5oGtsdGamWOjWmsOQBvcBCMP8mEAYgrk828XPckJxqAoGXZWr/FZ3AINmC4E3Bo+M2GNBJxXDo8S9fAlvNuIgFt3dBMk87eaaqmMrtRwXFVsoaVw3Uhf7wHvRn/i7rYyfQtWzOnmlVf/d+cja+sR1kaf9/EC+jo3C0ABG1zVo27SCmGeLqJE5TyJ6paZI2edYW+8CzI/Jh6o4vxXzsdMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bT9qw5gaakQjllV27SsUUDfrJBt40VzWJZnJ+a8yfkI=;
 b=XVnxXsoYenWsG6AB+YulC1NJXaFVk9R5nUxfQVMoMppUo0qCzMco4NCrDDHta/2EnMV6n9RJSYu2Ch6En6ZMHcU9f66IED/3LibCiWIu3R38+uCLTZwQeOHcgx3M7I6ac+9X/981uiSGJ42ChHdcicBevoRrBEvOBqn+K0xISbEqNkhjO50nd+7ty/t5DTL14v3IJsx3nBCuqlgvOeHPbwhTpbSDJDwhgeWeYLJulDYymHiAbBKjc8DDcvXq8DhLonKTj9+5XkLo15ElD6TnISpHeRGF1odFa8xyNSQ5dhc6YDhFx7vpbuGxAhLCB7KUt5FBfawwS72JTDFk8NB8TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bT9qw5gaakQjllV27SsUUDfrJBt40VzWJZnJ+a8yfkI=;
 b=CHF3jmS98Ag50IH7zU2lncbpwT8TDgrldyYP/3Qv+Isa6G+JBCNm1k4/7svZRvrCH1sGEMsL0E7hv2vsorCkZZwe37PIt9P7NGi46dUdbSiW53J59PSbU5zdW+dUEfE/ibwdosX9gl3gMcLFk7IAAzWqHhaJHsIv+QCBOC3Aoyo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4918.eurprd05.prod.outlook.com (20.177.34.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.15; Thu, 19 Mar 2020 16:47:11 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.025; Thu, 19 Mar 2020
 16:47:11 +0000
Subject: Re: [PATCH net-next 6/6] netfilter: nf_flow_table: hardware offload
 support
To:     Edward Cree <ecree@solarflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ozsh@mellanox.com,
        majd@mellanox.com, saeedm@mellanox.com
References: <20191111232956.24898-1-pablo@netfilter.org>
 <20191111232956.24898-7-pablo@netfilter.org>
 <64004716-fdbe-9542-2484-8a1691d54e53@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <87cc5180-4e84-753f-0acf-1c7a0fa8549d@mellanox.com>
Date:   Thu, 19 Mar 2020 18:47:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <64004716-fdbe-9542-2484-8a1691d54e53@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::22) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Thu, 19 Mar 2020 16:47:10 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e09649e-745b-4a6b-d3c5-08d7cc252b85
X-MS-TrafficTypeDiagnostic: AM6PR05MB4918:|AM6PR05MB4918:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB491845B977E86A6C1AA031C8CFF40@AM6PR05MB4918.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(199004)(36756003)(956004)(6666004)(81166006)(8936002)(81156014)(8676002)(16576012)(110136005)(186003)(2616005)(316002)(16526019)(26005)(66946007)(53546011)(478600001)(66476007)(52116002)(66556008)(2906002)(86362001)(31686004)(31696002)(107886003)(4326008)(5660300002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4918;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6ITdbmU26OOr/QiEr6NC79CAiIK48NPiNQJ8tSsioHOsTRykhzDma90vG9d74LgBZ24WFDRaqPkH/UGgWlc+uJHXQMkpbsjklefD6+aWadyLWGigVQPlXiVj/22A8CRXJEyTM/ODDkcnnLg7aaixRfp0D42qFvC35YNmMrGO7oyaqudlDLzA6Yu7F4zpoLNXVuGD/xa9R3hGf9QbZB0s8cz2lpU5y7Ba9DLwCT2tdkAddSeBBzfcWCgQdCclp4drrIJGYCpk72jmI6fGGH2RcZxb8z4lmZlMh7YCEk20ii7WIW8xArCVDM2guhnqA/mgza1x7ltzrWIMRGmTwLpu1vk06WMZ+qB2QHJai1kMx6ERPzIdxvtd6yzyZ/BZC5QElDhykzFH7KirP6I9uuaBTsIxeHjO+kBTh5YH3k0I8qZ8iHtiT3LzwT1P4a6DeW4
X-MS-Exchange-AntiSpam-MessageData: FhqlI+ySKezb5S1k6VkWugnzjqY20bE4nGXJ45Ogo2NmzoxnHG4T1659gK15cuFADhusolEo8T/7DnnGzYAa/7LV1dKGBJHQ1qM0ZE812xUkikGeInOTDcqMql8WgQGnmX33wOz2gqq2jSLzL/Jx6Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e09649e-745b-4a6b-d3c5-08d7cc252b85
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 16:47:11.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9sOa+XXNlKayde1gTtNOKnX5eyZEYg9xUhUqK6HNVfT2Y6ojFIpTo9oQmsUj2M56KIITqUf+uxblrVQfO7fLlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/03/2020 17:57, Edward Cree wrote:
> On 11/11/2019 23:29, Pablo Neira Ayuso wrote:
>> This patch adds the dataplane hardware offload to the flowtable
>> infrastructure. Three new flags represent the hardware state of this
>> flow:
>>
>> * FLOW_OFFLOAD_HW: This flow entry resides in the hardware.
>> * FLOW_OFFLOAD_HW_DYING: This flow entry has been scheduled to be remove
>>   from hardware. This might be triggered by either packet path (via TCP
>>   RST/FIN packet) or via aging.
>> * FLOW_OFFLOAD_HW_DEAD: This flow entry has been already removed from
>>   the hardware, the software garbage collector can remove it from the
>>   software flowtable.
>>
>> This patch supports for:
>>
>> * IPv4 only.
>> * Aging via FLOW_CLS_STATS, no packet and byte counter synchronization
>>   at this stage.
>>
>> This patch also adds the action callback that specifies how to convert
>> the flow entry into the flow_rule object that is passed to the driver.
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> <snip>
>> +static int nf_flow_rule_match(struct nf_flow_match *match,
>> +			      const struct flow_offload_tuple *tuple)
>> +{
>> +	struct nf_flow_key *mask = &match->mask;
>> +	struct nf_flow_key *key = &match->key;
>> +
>> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
>> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
>> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
>> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
>> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
>> +
>> +	switch (tuple->l3proto) {
>> +	case AF_INET:
>> +		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> Is it intentional that mask->control.addr_type never gets set?
It should be set.
>
> -ed
