Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176BF522307
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245756AbiEJRq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245718AbiEJRq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:46:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7409F267C0C
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWkzh8hZwBoc6VTqEmlEvDXnfwRNrJcnpF3N/fUHddYU996uxZhkNDp8pEyGZ5byRueHCDQncHxBPhpANC4bFq9Sh/rVkQUuk5qzUh+S3cBf7wUtwzyd2GqZBFm+QYcIJHHiI8i8zhTy4evHc+kjycP0tc3/eOI4L+ZWdheoijQDd10qWmdSNnV9SRAAgPriaKZNeTdD9yNxKhofefxmge7QqmY1GRG/+zMaDc18NyTuLSQJ6VsHcze7uvYOrzjnuVf+hwmKtgVwhMrs1cbvu+8IlPvqY8rpWimMgVPf0x8iheH004GS08OPOvnI3a0fd+zlB6PbWAVI/AC2sII0HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxeU6yY9NlJjEqebDV66nCieXf2rb/Kt8QgmJIii+cg=;
 b=bFdMvauLfbNWVD3Dqo299DBfOX1d0yaRX6MDEn/S43JdKwerpnND9V0MGtF0zqtbzkVLz3XmDM6Gaw1PVLM6u988INcM8ZW3jq98nSewSta79kqLzvEMe3zumuqAP9sUyPMCin/s+J+m+UFji+lLB1jX98nZdqJIyRVrxSAsGYPxhzcsC4Vzm2SFQJkHzHxKQCarxgOHhKnkvKiedVSqtV2qULeBj8iR6Z1ERSN0fHiTJQwu2qp/s+Mj3Hdn6WcuaeAu9rYEkY5ds3r+45MeLTdfW2Cy5PSXNv1/uRRHidxqMrAZDx1s2B6JufPbw5+8Rnl6M5B07IO+KIc1T7R9ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.80.198) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxeU6yY9NlJjEqebDV66nCieXf2rb/Kt8QgmJIii+cg=;
 b=bU0KKuBUhV8a/a9BhJBGeaPtsPDkNvUcu6Qu+3B7WwSBeAWNpGngdIPY+lvUU0UXu5Ja1dJMXZHTmG3SlfsypOgqJW/7nwqFILSY59xFOtbrfg3GI7S/QDPsqTXK8nr+MaiYECuQ0b5Tjnf6V52OI8ZgqTju3iZ0WRbgspkk1KY=
Received: from SA0PR12CA0027.namprd12.prod.outlook.com (2603:10b6:806:6f::32)
 by BN0PR02MB8240.namprd02.prod.outlook.com (2603:10b6:408:157::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Tue, 10 May
 2022 17:42:25 +0000
Received: from SN1NAM02FT0045.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:6f:cafe::23) by SA0PR12CA0027.outlook.office365.com
 (2603:10b6:806:6f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Tue, 10 May 2022 17:42:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.80.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.80.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.80.198; helo=xir-pvapexch01.xlnx.xilinx.com;
Received: from xir-pvapexch01.xlnx.xilinx.com (149.199.80.198) by
 SN1NAM02FT0045.mail.protection.outlook.com (10.97.5.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 17:42:24 +0000
Received: from xir-pvapexch02.xlnx.xilinx.com (172.21.17.17) by
 xir-pvapexch01.xlnx.xilinx.com (172.21.17.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 10 May 2022 18:42:23 +0100
Received: from smtp.xilinx.com (172.21.105.198) by
 xir-pvapexch02.xlnx.xilinx.com (172.21.17.17) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 10 May 2022 18:42:23 +0100
Envelope-to: lucien.xin@gmail.com,
 kuba@kernel.org,
 netdev@vger.kernel.org,
 davem@davemloft.net,
 ecree@solarflare.com
Received: from [10.108.8.172] (port=49292)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <edward.cree@xilinx.com>)
        id 1noTsN-00057B-45; Tue, 10 May 2022 18:42:23 +0100
Message-ID: <11f25fef-e551-f72c-223d-c3d072a3a94d@xilinx.com>
Date:   Tue, 10 May 2022 18:42:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] Documentation: add description for
 net.core.gro_normal_batch
Content-Language: en-GB
To:     Xin Long <lucien.xin@gmail.com>, Jakub Kicinski <kuba@kernel.org>
CC:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        "Edward Cree" <ecree@solarflare.com>
References: <e448120735d71f16ca3e1e845730f7fc29e71ea1.1651861213.git.lucien.xin@gmail.com>
 <20220509180712.22f4a3a7@kernel.org>
 <CADvbK_dKQSnmn3z41=88Zoa4xGf55G59Y_ocAtoaJh=Y4JGw+A@mail.gmail.com>
From:   Edward Cree <edward.cree@xilinx.com>
In-Reply-To: <CADvbK_dKQSnmn3z41=88Zoa4xGf55G59Y_ocAtoaJh=Y4JGw+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c572c4f5-4280-4065-9a14-08da32ac71c6
X-MS-TrafficTypeDiagnostic: BN0PR02MB8240:EE_
X-Microsoft-Antispam-PRVS: <BN0PR02MB8240930C481632BC2A80A153C3C99@BN0PR02MB8240.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: subUfUeysDgDxm4MhkMcv5JJWhcxxcYHderDvxXsumXY23vUTjFDofYjk6Ga1cn5nV4emhAy3AP5j+0FhskLUZNILYioMAdnfgc604F1zCkMEMbj8BMFB2FHGbauMuEdHlzfPLl7zJo+NPbBsegmRKpOu/8WZIrGcUmFQcEgXfRQs242CWam6kvmozo/68m2eMHdG+mBu8/6kY929rs3opcPyaKhT3Mt7RZnQvvW71OXbHK4yE0QGMvTF17LXXa4BZCNRzDcD9OY0pFuStCucmR3xCgxFy4xCq/xgQxoauWi2L7FeorNcrRG+K0UQl4A9gwpC7UNcYsYvsg/xeHqjL6/C/RaYsZsROD25kAQRjJ4X7NNH4z3iqwIT/BUlKRTkIVHwiEtE7eDsJI/YlQQzjhwCAnNatY2gJpaFj50Ge/6/eesMSW9YxRpLpkTcQBlxhFEAuBDC1CrLt8AKu8mzPDtAGMkWLaurFVqTYoadMA8rOQQLHrwrimN0+FqKp67c15mMneW8Or8YfvKeLbkgI8GvYXUeSCIGgPJVeyIwwQTMnwjDWxDhqSLT9yKWSmzKjAqmqJgLOg0Sxk8Ausn6GJzqjZKuaXyPkvNoUeknhqk99ttEZXKHZIyGLpcJajX7ZTWUGaP/81sjoQhH6R2JLqer7/D9O/hBtrLn9thDRZjzsOen7UBPH05+4MPw0FsrAbbKhX57veRfcYtZyDyFPfULHWp6CLlXEDlpFoaty8=
X-Forefront-Antispam-Report: CIP:149.199.80.198;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:xir-pvapexch01.xlnx.xilinx.com;PTR:unknown-80-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(508600001)(9786002)(8936002)(5660300002)(316002)(82310400005)(107886003)(336012)(7636003)(426003)(54906003)(47076005)(110136005)(186003)(31686004)(36756003)(70206006)(70586007)(4326008)(36860700001)(2616005)(8676002)(4744005)(31696002)(26005)(356005)(83380400001)(44832011)(2906002)(53546011)(40460700003)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 17:42:24.8138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c572c4f5-4280-4065-9a14-08da32ac71c6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.80.198];Helo=[xir-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0045.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8240
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2022 18:10, Xin Long wrote:
> On Mon, May 9, 2022 at 9:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> That makes it sounds like only packets which were not coalesced
>> go on the list. IIUC everything goes on that list before traveling
>> up the stack, no?
> I think the difference is these ones held/merged go to gro_list first
> and get merged there, then go to the list. I can change it to:
> 
> "place it on a list where the coalesced packets also eventually go"
> 
> looks good?

Maybe it'd be clearer to say something like
"when a packet exits GRO, either as a coalesced superframe or as an
 original packet which GRO has decided not to coalesce, it is placed on
 a per-NAPI list.  This list is then passed to the stack when..." etc.
Ideally also mention the fact that a coalesced superframe counts as
 napi_gro_cb.count towards the gro_normal_batch limit, not just 1.

-ed
