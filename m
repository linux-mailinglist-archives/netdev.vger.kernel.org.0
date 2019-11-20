Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FDA103473
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 07:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfKTGsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 01:48:06 -0500
Received: from mail-eopbgr800078.outbound.protection.outlook.com ([40.107.80.78]:30592
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727653AbfKTGsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 01:48:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cflh3nuIbmam+J9xSg6BswMABhJK04JAi4UUNZtLWN+QsAN817z/3DsMRaclJ6ghbIqst0m58NvIPQVWRwxAbn2UdRsU286aoJKHqbdDiyxgTkDdeD/yv9bxulzyoeTOkFd/yL8eTUDkqtNuSP2I8HFjOwnUwyxAkm73PMV5gXMCIeVOUNNHixaQNtUpkQl1QJ9Z42OTWoKUDyVDVKtUSFD/aycuLl0djLOKhP7U8EIkPXkLDc6No/J1eiuVR/7Sf+5qHwW5mmR/mpbxSZ+8bcFfVLUwaUZZCkSMZsZnIHawhCYz7mR31YhF/4GQ3qmRY9ipDoph3doNelFvbEj7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Udku058SngQ7wpfOosf9pc5TwObQvXMpjT5bhsyST58=;
 b=hF9nvbPBU89YMXoMLr01UBfEc2qK35gIwrEHKn5G6rfp5oMNQCA18FLgfbKvtOk6VkAw6IpxFJeRgLYB+yGEsRa0v668WyJ6uClhOUbuBWnTRB7BQRt1Djh6VL0ToOVvRDWZNOWfjFre92XzeYFF4oRNHPU7XDW+Lalq9p8aJqP/DTrzAR5trS071TisPPym+GUwDVzc2QkHMNpslgAXt77nlu5mxHZQ3VXDNgXauOm2gi50i+PCrKYfdCP6VbLxHPzNENPwe2wskdndiqblIRuWX+SjLH9blgapmj7IoaDo3LSyK+nvFgVDowwiBA3+HOqxFygJwkoLBYqPCrWggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Udku058SngQ7wpfOosf9pc5TwObQvXMpjT5bhsyST58=;
 b=L3/S1C1YeD1wFlYZvjK1s7EDo/904l7Be0lZHcYXKV54roP072nboJu1GXhftzu8yJy8rFKgRuq+G+rqZsr135rCqFjQ+MCIGlU5cR9aIFkIxCyPghKE3J5Pm+ihMpKBqyExsCcvCFXj2UqzaMDEdmc6mK+Lri4xo+jqg52rmE8=
Received: from CY4PR02CA0046.namprd02.prod.outlook.com (2603:10b6:903:117::32)
 by BYAPR02MB3973.namprd02.prod.outlook.com (2603:10b6:a02:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Wed, 20 Nov
 2019 06:47:59 +0000
Received: from BL2NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by CY4PR02CA0046.outlook.office365.com
 (2603:10b6:903:117::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Wed, 20 Nov 2019 06:47:59 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT011.mail.protection.outlook.com (10.152.77.5) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Wed, 20 Nov 2019 06:47:59 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iXJmQ-00062q-Dp; Tue, 19 Nov 2019 22:47:58 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <michal.simek@xilinx.com>)
        id 1iXJmL-0004C6-AR; Tue, 19 Nov 2019 22:47:53 -0800
Received: from xsj-pvapsmtp01 (smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xAK6llBk027319;
        Tue, 19 Nov 2019 22:47:48 -0800
Received: from [172.30.17.107]
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <michals@xilinx.com>)
        id 1iXJmF-0004BZ-Mo; Tue, 19 Nov 2019 22:47:47 -0800
Subject: Re: [PATCH] phy: mdio_bus: Check ENOTSUPP instead of ENOSYS in
 mdiobus_register_reset
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, monstr@monstr.eu, git@xilinx.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
References: <8712e54912598b3ca6f00d00ff8fbfdd1c53e7e8.1574170028.git.michal.simek@xilinx.com>
 <99a8ea54-9a27-9e0a-9aaa-8aeef7feabe2@gmail.com>
From:   Michal Simek <michal.simek@xilinx.com>
Message-ID: <3435da8a-6942-d292-c901-df1bd7fb5d94@xilinx.com>
Date:   Wed, 20 Nov 2019 07:47:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <99a8ea54-9a27-9e0a-9aaa-8aeef7feabe2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(189003)(199004)(186003)(14444005)(478600001)(486006)(70206006)(2486003)(44832011)(966005)(4744005)(58126008)(316002)(2906002)(50466002)(23676004)(8676002)(6636002)(8936002)(36386004)(31696002)(4326008)(70586007)(6306002)(110136005)(31686004)(76176011)(305945005)(54906003)(106002)(81166006)(81156014)(356004)(426003)(336012)(36756003)(26005)(476003)(229853002)(47776003)(65956001)(446003)(65806001)(230700001)(6246003)(2616005)(11346002)(9786002)(53546011)(126002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB3973;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1496eb9a-8d26-4448-de99-08d76d8594dc
X-MS-TrafficTypeDiagnostic: BYAPR02MB3973:
X-MS-Exchange-PUrlCount: 1
X-LD-Processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR02MB3973017E6259B733F73B9C96C64F0@BYAPR02MB3973.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-Forefront-PRVS: 02272225C5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09r8u3uxM9m+ZywnCgoUONYsVwy2avbatkXGFj3KXIJ5rjfJYGkquz1HtdJN1N7TMoDLWK9UYfNOaQwblmTKuwpOZ+C2almP40tH8uKBLUQ+gUcw3yD1xLyHT1cQxnY/aNsqcv/xN7PMzLIYsUjkOa6EbNgzNtnrnQqKKg1u6sNTkHurreKgz4kFOcnA7r5WGGBdSNlu0H6IPWakW9wknNdSO9q6Lwns1U7Jdu8X3Hxw1ifEDpXP1Y83z15MvnvvwTOLPj9R0Za6RhUTxPehEeK185wV740PAvAJun4xWyDPmIRWxQjRbHPgs3AccRyA7STCdo9OtoxEEjsl6Z1fKA6PJb59AbMbhhWkW/CGBGjMucnTn5L2L23+5eN5EycbYRjjZJR5HYzK5v3XLstVpmqtJLa2bYOf+7Y0OjpXpUCeEiu0eQ8FN8regX6z2lWeXH5/ALbMu1bFyD6gj2KLwuV1nVoje/OcIdpqTNr5yUc=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2019 06:47:59.0043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1496eb9a-8d26-4448-de99-08d76d8594dc
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB3973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19. 11. 19 19:04, Florian Fainelli wrote:
> On 11/19/19 5:27 AM, Michal Simek wrote:
>> Origin patch was using ENOTSUPP instead of ENOSYS. Silently changing error
>> value ends up in an access to bad area on Microblaze with axi ethernet
>> driver.
>>
>> Fixes: 1d4639567d97 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> This has been fixed in the "net" tree already:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=075e238d12c21c8bde700d21fb48be7a3aa80194
> 

Works for me.

Thanks,
Michal
