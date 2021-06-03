Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F9399E2A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFCJyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:54:32 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:55521
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229665AbhFCJyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 05:54:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daRz73fVJ5N8HiAebKbF1m3JfpHoj4rX8NRhpRPUeVnABxveKCBDSP+U1tIvMhdZ71IO5AAME6KTdzMlsSCCldo2raseg1RK9su2W6cZIiCxcLG9X7vU6qJMQEvygQyhmzJskLvuR7DgfpUytENmrNTlEQIPBPpgNtpAHIt8FHoJAl7zf4gn1uFT8emMX6i+Ph2/gQDrvpBGJZJZwCmb460AIpGEBZRmUy//cpnOPZoCMpmknhvYkkrwhLPSClIbql63eq97FB7G2g0TDxU5KsWsh+S+JcI2kDJ/t8TMOfO1eDlrlvjtry2+HdKclcSliC9zt6qDhNn2q//XnnW/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGcV+xkA6QiyL6yIctASMBBNxMYxpVYqEnEDJ8ACL98=;
 b=Ee51MwOLpIfyI3ddiP7sT6iQKryonW7o8/V+wp7fd0V7bvDYx9WjvQkwds9FQv09QZQJ1HvmkvTIU6ZNimeSFaLHj/kICjsLUd2zp+5iQ3Ab+zcZWrvmWin4UTXpi1ePOhvUQC9+P4fIdyMCTwGNyzzIvLOAvlf8pol2+Ch7EiiWEGKUe9fwo9Gss+TfrirQfbXdCuqIBmAXWZJ7ogJ0AAm2ZzCeCrjiDqmaSHHADCTiVbpd29/SBBZvOKO94hhALshWq0KedHB3A2rwopOE6QFTdsSx5omKvuauRBcMNyz9+gMW10a8tTf+rVLPG6JKuNNwlOmBRgqEEdiXbSC4rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGcV+xkA6QiyL6yIctASMBBNxMYxpVYqEnEDJ8ACL98=;
 b=Nkxtz7FhQRWVXBxQJOXJ6kSAz6BYCTn9kJFJa6S7EiV24zM65pOoj49YkU9p+i2sx0ClhuVgcTFtvsSWUTirCtyaCYQ6/rY8XLVBI0RFYedFNUUX/ZbCYMIZ/NvviQ5MM8c7GkYkcEFuaEEcotri7sV98NwOkGsEbI4zjBz96qhjHJ0YOkYnrAqf3GOOxUxML6aATv1EUuVrYplT2LFHyC1bdmSyv0TFeYiSCV8Glh+TpZDbFAyYXOk+q+YxoolSp43dkNZgzvag7ZCvZF0FQ1Zynpv4X7PzTRrEaRcdX0Tq4oTktlpdjPrCN+e5QDIisKn3Cd38q00h/IkOQ6G2WQ==
Received: from MWHPR22CA0011.namprd22.prod.outlook.com (2603:10b6:300:ef::21)
 by DM6PR12MB3354.namprd12.prod.outlook.com (2603:10b6:5:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 09:52:45 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::aa) by MWHPR22CA0011.outlook.office365.com
 (2603:10b6:300:ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Thu, 3 Jun 2021 09:52:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 09:52:45 +0000
Received: from [172.27.12.193] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 09:52:41 +0000
Subject: Re: [PATCH net] sch_htb: fix null pointer dereference on a null new_q
To:     wangyunjian <wangyunjian@huawei.com>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <chenchanghu@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
References: <1617114468-2928-1-git-send-email-wangyunjian@huawei.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <7a0ea3a1-0d31-83f4-0ba1-80154c37d048@nvidia.com>
Date:   Thu, 3 Jun 2021 12:52:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1617114468-2928-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6974cc9d-e826-46f2-6346-08d9267556a4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3354:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3354E257F31C29D7FCF2A5F1DC3C9@DM6PR12MB3354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCjgPUJABjinGWQFCaYWbkAFcgPhULH27C3xi/Jz45OYbStAfRtwypE5bZVd/glOqg2RTbEYcrfd3Uj5QYB0W7Y3YEoU8TuXrqp2rQTjrM91S5oBIm0DMHsuaLDwnRCqFvkcRo9WU/e5UN0NaqjeNpzd7ioV9lDgvN8ThWBv8tWUnfb1EvCV23Nr69bPUPGRUJtRbqypPLDgNIb9aEBwkt3d9FLmw9mySvMxabWqmC+Na7Gt1YWWvaovKRMCC+7OIg3TAswYBJ/bDPe+TR0lutqryTJ6VYUFkeheI685/2mgp5tbL33pOupfQrIcMRXBAQECv8F2EbfaLS5tdrESaVhdhu1mqwO+csV9ePOfzs1lCZtCgu64aX41egu7a2G0MyyJGneRd9EC9gPjuW9rxa98T9F61Wd2n0O4d4OPYo/rO1G7ugzOjPnjyU5SMX/aG3vkijXOqplQxlQBQqbv2jSv0mv9DKQTcj3ByrS/Tfz1oTCZhe1uF7yNDFWjYugYWtLfxKBW1B2pI/a6HOmWbzvmpWIbN6Xb+QCENaTWRZYuRofHM7ztSeGY0J4+btxBH6PFjKRpo418MoSSOU0eP8x3ExPlo6dQzyhkePjQnq7Atd4Iyc3w0N1MaiYELJxEPF6HGXiuTE5vQKK2zPFe8rJGTcIzSE9WTfG0yxv2rYDYHPyf4Vuneo9wEjXgw/sk
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(36840700001)(46966006)(47076005)(2906002)(70206006)(70586007)(356005)(36756003)(31686004)(16526019)(186003)(53546011)(336012)(4326008)(5660300002)(54906003)(110136005)(86362001)(16576012)(426003)(36860700001)(26005)(316002)(36906005)(31696002)(2616005)(6666004)(82310400003)(82740400003)(7636003)(83380400001)(8676002)(8936002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 09:52:45.5149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6974cc9d-e826-46f2-6346-08d9267556a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3354
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-30 17:27, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> sch_htb: fix null pointer dereference on a null new_q
> 
> Currently if new_q is null, the null new_q pointer will be
> dereference when 'q->offload' is true. Fix this by adding
> a braces around htb_parent_to_leaf_offload() to avoid it.

I admit there is a NULL pointer dereference bug, but I believe this fix 
is not correct.

> 
> Addresses-Coverity: ("Dereference after null check")
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")

Please Cc the authors of the patches you fix, I found your commit 
accidentally.

> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   net/sched/sch_htb.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 62e12cb41a3e..081c11d5717c 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1675,9 +1675,10 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
>   					  cl->parent->common.classid,
>   					  NULL);
>   		if (q->offload) {
> -			if (new_q)
> +			if (new_q) {
>   				htb_set_lockdep_class_child(new_q);
> -			htb_parent_to_leaf_offload(sch, dev_queue, new_q);
> +				htb_parent_to_leaf_offload(sch, dev_queue, new_q);

Yes, new_q can be NULL at this point, which will crash in 
qdisc_refcount_inc, however, dropping the rest of the code of 
htb_parent_to_leaf_offload creates another bug. For example, 
htb_graft_helper properly handles the case when new_q is NULL, and by 
skipping this call you create an inconsistency: dev_queue->qdisc will 
still point to the old qdisc, but cl->parent->leaf.q will point to the 
new one (which will be noop_qdisc, because new_q was NULL). The code is 
based on an assumption that these two pointers are the same, so it can 
lead to refcount leaks.

The correct fix would be to add a NULL pointer check to protect 
qdisc_refcount_inc inside htb_parent_to_leaf_offload.

(Also, while reviewing this code, I found out that leaf.q being 
noop_qdisc isn't handled well in other places that read 
leaf.q->dev_queue - I'll have to address it myself.)

Thanks,
Max

> +			}
>   		}
>   	}
>   
> 

