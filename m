Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38ED3F55A9
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 04:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhHXCKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 22:10:43 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:16257
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233700AbhHXCKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 22:10:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ky774cyaCwzDHdOj6AFNO1+D9a5CpgmfDUSXmSo/6KaUZvART95mlg5lbNnmKHB1FTO+T6M1U5m1UXNsB4700KWWk/kknK4+JTT8a5O6D0m4DUwxBA0AH+3Q3vt/YMGwMtB49qIK5XqbP4boxC+wegcfovkzlC8sKy2RlDN6mXANsRHekW1OHeFLDVUs3k6ZhZhVq/VkenmC56L0IJoySGJEGDzkkv/P2WwAHvGV5TRKcikelOrJ9Pz3kMQHJ4bVGTGH45orknKLZiSeAPSdgEgM5C4Am8PUpzahhJNrzp5m7F7t8UJ2ciDGWZNa34fiCjRaBCm+11r7PJKQAKCejA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA5YYO6nSxZfmoX5uSlA0TDZJxhUQ/iSF6A3mmmi9rY=;
 b=AYGidugeawrVRtkXlmn7ZlVF0l04T+TqOKEVi0CbNdYPKDSopUJHv7XO0SsayCG1Mg1QPNVFb3hm4GPqRcVdsO9UNWFawrTBr8ta2saPlg8yjBSut5Y5H2QXaCFiuJr4c5dF6oOTs34WmeLvpwTJ8G9K2E6YdAiaD5zZSb+KnyC9DcH0HpcL3OtPW/Z+2Q7LpcUSGt6MQCauCtM7mZ7iS5HzHU5Gzrg7uinupIBdjG45b6aEogF1v1pyx25ALmy+zupLlm1oyE3G8NaheBDuMLNa+49mVlKhya28dS41IfCjoLPPdSV/PqQQaxMIF3zftrzr6mj4oTOhyGmQur0q0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DA5YYO6nSxZfmoX5uSlA0TDZJxhUQ/iSF6A3mmmi9rY=;
 b=jxJcIeFm8l3XjNi1CQ8bWiAS02kxPUtdZhmsc64fQWEk/7vPvpVD/iBiTiRZ21SR9FU2K0wfVM2CTHK04N6yF0iBu+Rp8+rcXxZlPxUeqaWmyagkLRYXjcGsu6vi1F8JoRHev9lLvbDeBAK/bvIWJNisIyj0xOYROEi3oTTEDljodZme9T2MtpUzBFtNWfVVEnSlXe79VWM0l2mg4xLPyZwEV30Tnx46ROmEEMzcigcAnWMjh5sHg86Uu8ekMdAIPHA8jf6hYVcQs6g6hIZIn0ivFFBieWADwgGTrXOmasszFXq78gAOwsjDWP8q2jTFhgTf34rvMr3dTF7Bd0BTVg==
Received: from BN9P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::6)
 by BN8PR12MB3428.namprd12.prod.outlook.com (2603:10b6:408:47::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 02:09:53 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::87) by BN9P221CA0013.outlook.office365.com
 (2603:10b6:408:10a::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 24 Aug 2021 02:09:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 02:09:53 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 02:09:52 +0000
Received: from [172.27.8.76] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 02:09:50 +0000
Subject: Re: [PATCH rdma-next 06/10] RDMA/nldev: Add support to add and remove
 optional counters
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <dledford@redhat.com>, <saeedm@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-7-markzhang@nvidia.com>
 <20210823194230.GB1006065@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <abcb4753-7bf9-54de-29a2-f384ac283faf@nvidia.com>
Date:   Tue, 24 Aug 2021 10:09:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823194230.GB1006065@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13765739-7d85-48be-e5d4-08d966a4431c
X-MS-TrafficTypeDiagnostic: BN8PR12MB3428:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3428D4E42CA3EF36A655B5A4C7C59@BN8PR12MB3428.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTfeEAmNCdO4et1E2KdGsJv/deOAL8kUTGa9LlmX4Vfeq/TUiql9cZUgoxhNdjKZ70KZ9j0Aik0Ob5zOHU+a1v+SBkR4+DfPlbgxgm4yPStC9v57N3MeOqrSulLcJvLQ8gkfpAnv+h005R0sF0D6w2QVNPM8lLCp5RcQ0C2g13ZQ6Els+/xmpd5PhZ138QabjOYCGycSCZlW/JHuPHUG683lRJSQqCeJjCJ7s6a/Z3oV1VEEMTram7NLEocFhaFbB7dJ/DcqrzaJBImmEcdMurEODW24jOIEdCIVLATIwcY6m4BZTzI5cJDA/CmA2pIVPiX2vsUQBP8OUV04WQqhpOVjtFeMg0gFa190yBDtZs/L+ml9PHoTG1ooal59NAx7/G5vef/opetnHQeqbXZBGDtNqhFvJYb2R1AJtLJiBTELM8TZZpQJhB2HXXc5uTzw138kmLedErKxUUkMsAvYN4oRwokD0zmjXQa10Eh28LfVZc5ul4T3T7xxhg3frw5NIsPT/fV2H4xgoHuuajKoo73MKYE4a6w1MU0FZMHfO97km3WLO5RDXpowoQYL575W9xdZiu1CCC2vQc7VfvN3vIZIMsGEuQhl94B0DYDEgajzpJuByBmKKjhNMONs2Ql6YpzI+700u4MuLJAC6muhGmhZWcEi8A8IdWq4FkmXK+8kDtZp17gO+dBoidpnRNfuk27ymH3X7Na+ll8UQeBtNObYO1o+AA5c1MwvRFxHkKE=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(336012)(6636002)(6666004)(508600001)(2906002)(47076005)(26005)(53546011)(16526019)(186003)(4326008)(36756003)(426003)(82310400003)(70586007)(54906003)(6862004)(86362001)(70206006)(316002)(16576012)(36906005)(2616005)(107886003)(31696002)(37006003)(5660300002)(356005)(8936002)(36860700001)(7636003)(31686004)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 02:09:53.4733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13765739-7d85-48be-e5d4-08d966a4431c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/2021 3:42 AM, Jason Gunthorpe wrote:
> On Wed, Aug 18, 2021 at 02:24:24PM +0300, Mark Zhang wrote:
>> From: Aharon Landau <aharonl@nvidia.com>
>>
>> This patch adds the ability to add/remove optional counter to a link
>> through RDMA netlink. Limit it to users with ADMIN capability only.
>>
>> Examples:
>> $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
>> $ sudo rdma statistic remove link rocep8s0f0/1 optional-set cc_rx_ce_pkts
>>
>> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
>> Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
>> Signed-off-by: Mark Zhang <markzhang@nvidia.com>
>>   drivers/infiniband/core/counters.c | 50 ++++++++++++++++
>>   drivers/infiniband/core/device.c   |  2 +
>>   drivers/infiniband/core/nldev.c    | 93 ++++++++++++++++++++++++++++++
>>   include/rdma/ib_verbs.h            |  7 +++
>>   include/rdma/rdma_counter.h        |  4 ++
>>   include/rdma/rdma_netlink.h        |  1 +
>>   include/uapi/rdma/rdma_netlink.h   |  9 +++
>>   7 files changed, 166 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c

...

>> +static int nldev_stat_set_op_stat(struct sk_buff *skb,
>> +				  struct nlmsghdr *nlh,
>> +				  struct netlink_ext_ack *extack,
>> +				  bool cmd_add)
>> +{

...

>> +
>> +	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
>> +			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
>> +					 (cmd_add ?
>> +					  RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER :
>> +					  RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER)),
>> +			0, 0);
>> +
>> +	if (cmd_add)
>> +		ret = rdma_opcounter_add(device, port, opcounter);
>> +	else
>> +		ret = rdma_opcounter_remove(device, port, opcounter);
>> +	if (ret)
>> +		goto err_msg;
>> +
>> +	nlmsg_end(msg, nlh);
> 
> Shouldn't the netlink message for a 'set' always return the current
> value of the thing being set on return? Eg the same output that GET
> would generate?

May I ask why can't just return an error code?

>> +static int nldev_stat_add_op_stat_doit(struct sk_buff *skb,
>> +				       struct nlmsghdr *nlh,
>> +				       struct netlink_ext_ack *extack)
>> +{
>> +	return nldev_stat_set_op_stat(skb, nlh, extack, true);
>> +}
>> +
>> +static int nldev_stat_remove_op_stat_doit(struct sk_buff *skb,
>> +					  struct nlmsghdr *nlh,
>> +					  struct netlink_ext_ack *extack)
>> +{
>> +	return nldev_stat_set_op_stat(skb, nlh, extack, false);
>> +}
>> +
>>   static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>>   			       struct netlink_ext_ack *extack)
>>   {
>> @@ -2342,6 +2427,14 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
>>   		.dump = nldev_res_get_mr_raw_dumpit,
>>   		.flags = RDMA_NL_ADMIN_PERM,
>>   	},
>> +	[RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER] = {
>> +		.doit = nldev_stat_add_op_stat_doit,
>> +		.flags = RDMA_NL_ADMIN_PERM,
>> +	},
>> +	[RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER] = {
>> +		.doit = nldev_stat_remove_op_stat_doit,
>> +		.flags = RDMA_NL_ADMIN_PERM,
>> +	},
>>   };
> 
> And here I wonder if this is the cannonical way to manipulate lists of
> strings in netlink? I'm trying to think of another case like this, did
> you reference something?

For add/remove, we only support one op-counter at one time (for 
simplicity), so it's just a string, not a list of string.

This is supported:
#  rdma stat add link mlx5_0/1 optional-set cc_rx_ce_pkts

This is not supported:
# rdma stat add link mlx5_0/1 optional-set cc_rx_ce_pkts cc_tx_cnp_pkts

> Are you sure this shouldn't be done via some set on some counter
> object?

Currently we don't support do on a counter object, just per-port.

> Jason
> 

