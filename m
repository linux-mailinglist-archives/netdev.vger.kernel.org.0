Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB56815B0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbjA3P6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbjA3P6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:58:11 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0015F126DD;
        Mon, 30 Jan 2023 07:58:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMsVLFtm19djoG8GKntOj2mmrtvPQStj/sS+X0M7RxA0JgEaQQS7jKseiD6hRFQBlc0VcDB+FKiFCKjT6Bzux5a4EUE3x3B0k9nW4YFuoa/5zRwLPy268UmmAY17szMfLbv7QgXaTFAGu7cV8XqnhgEUgDFMlDx1O3kOSoX+oWjcTxGWClOmTYLM3x1mCHp8umm5QJXyDS54KWd45QFwBhUct9XJAnkVnXoQHoEECB0IPwI9HS4Btl15yMDOJSnRkWVX82gxg/mA8bDOElpKbCqeUOMnmUFwMO9AbWs5hGu4xBakqLzt3/VGQKMQ7V7rJg/P+Hz3zlfa9dQIToVaww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XubIOGUXV39izAf99aI9nDczchTciAZ7WPlcFxA6S8U=;
 b=gHcPFAJ8q8pSvPPoMdbJbhIMyRvXSJ02WOZ8VrOLQ/UALrZtFmEFXdcB9tDyPeu00X85ofsHfhH8Y7uHVV/3gfhFOyJTU83bBhBVlaeZ4pWVWjgwwX90J1imQSAwLKgC++nqYHHb5QCLlJiwQkr9dCjpGxz4NqTot7PPYV+UbK3xp3Rs5qyMmlzfh1pbAWNBwcmmG202rxew7xihNDzyb2CT5Yy/UBWHu4rJvfSuR8yMotJ3IAhSBLmriolHy7uK7D/OEs4G/GLvkItUngseUdcJ5SLmLBle2nO3+r7IJvZiQdpfllOusEj7rhlBOsuqZ93izTPNsnZv4qy074v7Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XubIOGUXV39izAf99aI9nDczchTciAZ7WPlcFxA6S8U=;
 b=eSegMNTqTjF59Lx0ZGErrriFu+Oeg/Qd9JnmzYBvzCmKEfMmHppJYCgCEbzImGj4Dex7XGqpF3ibW3RNzXEyAw8y/ygdsB3vmU6vvqMGylWzk85sV9bC7k29n3vnPpuQ3z7P1BWPucM9wPrFCId2GqJGwJl+UeP1FZ7jfZLNXYVGbfVmcxVgNUJGxoyFERTIBZXVBaBcDjfUqm3/AAbHjyO8TADr3yoxQ1VsRqhz9Rt2DKMZ/s+OvBOVd6k2Hh9IjzT0cSnh0g92sSynLo7Xdoj5e7iTBqTjq274VZFYPMiAAFCF0WxOL+y5GmwhdQTGPEkGVKelEvv2yRMJ+MdE/g==
Received: from DM6PR02CA0083.namprd02.prod.outlook.com (2603:10b6:5:1f4::24)
 by CY5PR12MB6645.namprd12.prod.outlook.com (2603:10b6:930:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 15:58:08 +0000
Received: from DM6NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::3) by DM6PR02CA0083.outlook.office365.com
 (2603:10b6:5:1f4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 15:58:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT100.mail.protection.outlook.com (10.13.172.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36 via Frontend Transport; Mon, 30 Jan 2023 15:58:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 07:57:55 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 07:57:52 -0800
References: <cover.1674752051.git.petrm@nvidia.com>
 <ed2e2e305dd49423745b62c0152a0b85bc84a767.1674752051.git.petrm@nvidia.com>
 <20230126125344.1b7b34e2@gandalf.local.home>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
        "Nikolay Aleksandrov" <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 06/16] net: bridge: Add a tracepoint for MDB
 overflows
Date:   Mon, 30 Jan 2023 16:50:32 +0100
In-Reply-To: <20230126125344.1b7b34e2@gandalf.local.home>
Message-ID: <87ilgof20x.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT100:EE_|CY5PR12MB6645:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fe1986e-1922-4fbe-1524-08db02dac7f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpsTB9Ax52+nTCDKw1pRX0WpVO1ScBILIUhtr449cuITDH2CmQMIma4hVXSQuU3p4FIij5lN80B+fH0xmavKe3w4s/5zoXk5oLnMW1lPsRfk/+R6YDUWUmf7J+bfWT2ed5YhNMdI2n74geCLNk1ECC23sOAnTZI2BWDZPeKHMFd89coRHCTB8E8VYbZH1AditfnKL5YexOpzLVOXfLIW+Jq46E2yMGLhIVc1CzsZdw4uzKZT8zHHui+MPLp/euCtZMqD43CRYpGB73Hyt4qa9wN3nKq79xBczk9k98D9pclP8u875i1O/EB3k4TSScua9Lp3+kQw5SpceewpMKIlFw2LvzBXrz8vE7//N50cf47q1Zz7LljQxOPtBEMtNN1V4ZlR46z+JLhrqG+IgsCBUJhFhWokcYywtszilC7VXqP/meFodgnqHWAYXRwXMawdG2AASxLXwOiDkEZETNrAHPZyL5mBt28dEFtrCerbV79izDc7IHDN0J6KPB1zbXf6jCis33XSw9fbqwzOkV6kBECBw1qQ2djz+7x/VRBZmF7OVcvjtNIeca5VC79Int6h8033nAipaIZkpCVXZt5Ub96+E7dUzRwm0g2gKbK7otmx0aWvXRhMdbcteSTPCYD/amD9cNIIbpmewXwbgB2aw8FsEwo04QSO3jTXcIDscWQ1EAJfG4z8zF0W/4VkfMLtGJHis4JZgKGYwj+UsYEk+A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199018)(36840700001)(46966006)(40470700004)(4326008)(6916009)(70586007)(70206006)(41300700001)(8676002)(40480700001)(6666004)(8936002)(316002)(54906003)(5660300002)(83380400001)(40460700003)(36860700001)(2906002)(36756003)(26005)(186003)(16526019)(478600001)(86362001)(426003)(47076005)(2616005)(82310400005)(356005)(336012)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 15:58:08.2348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe1986e-1922-4fbe-1524-08db02dac7f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6645
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Steven Rostedt <rostedt@goodmis.org> writes:

> On Thu, 26 Jan 2023 18:01:14 +0100
> Petr Machata <petrm@nvidia.com> wrote:
>
>> +	TP_printk("dev %s af %u src %pI4/%pI6c grp %pI4/%pI6c/%pM vid %u",
>> +		  __get_str(dev), __entry->af, __entry->src4, __entry->src6,
>> +		  __entry->grp4, __entry->grp6, __entry->grpmac, __entry->vid)
>
> And just have: 
>
> 	TP_printk("dev %s af %u src %pI6c grp %pI6c/%pM vid %u",
> 		  __get_str(dev), __entry->af, __entry->src, __entry->grp,
> 		  __entry->grpmac, __entry->vid)
>
> As the %pI6c should detect that it's a ipv4 address and show that.

This means the IP addresses will always be IPv6, even for an IPv4 MDB
entries. One can still figure out the true protocol from the address
family field, but it might not be obvious. Plus the IPv4-mapped IPv6
addresses are not really formatted as IPv4, though yeah, IPv4 notation
is embedded in that.

All the information is still there, but... scrambled? Not sure the
reduction in clarity is worth the 8 bytes that we save. The tracepoint
is unlikely to trigger often.

What say you?
