Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90D1453002
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 12:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhKPLPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 06:15:30 -0500
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:63168
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234738AbhKPLP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 06:15:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5bZUbqWIRrzhwT2OAzVsyYtYRe+iHovheoRIdMfBa/sMowEN7U9yYY4KyjKkqkNkgjhWodJuDimhgZ3aPH4JIBTfGMr/v98J59aq+7vsGb7YvFLHj1BthFlgsr599S+elC1GCStZONkHx1QuDSJF7FZc4AxTev9Z591ezsQMj53/oEZ/xco5ZT8Pow/wZDfWrhqEWK5FnKET8seryMRMsmrGDHYUadZ2k0cQ+IZQNonkOSewMxLyOJ9VXO6RcwgI69qgDHOsIKjxXsRDj26YwPEnppci6aanCoNKSHR8sD3d4ph9rwMH7p3rcJf7BpjtXXQTiJo+t3f1c6HRy3R1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOOZu+GnbcQd5oev5HojNlA/jfnhr9JPqV+tL7UmfMY=;
 b=Ub1AqfvHOERdROEf51HRFXm0sxHxxrS9jK4zDiavjcIcp4spnnPBJoeGMESqjDcbTebpfaNquAL2Lze2E4r0Bms9rVlB+4DXgRZ1OV4+F4MKWWrDRgtb+ogwR8f6hu8KVqqV9i/IWCZz4SLd+RMoPLotIBTI4XdZPa5EWqQAfaQhAt6LxNC4MW8O5LcBRXTqC6aXtGXSmGkSXShyNq4QHJlfCz6CveDLab2thWeOljMg/1c0rCOMaKPx3rPUFmkuNoxIfYB7WfngfAjlfSxLlBrs64g19W9BgrSxWAVvuM7WZX19mluEZCWktKKInyBehHuKTHiGiwVm7QhEyPDy3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=armlinux.org.uk smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOOZu+GnbcQd5oev5HojNlA/jfnhr9JPqV+tL7UmfMY=;
 b=h/pKam4a/D6DaYYHvqm7qLv2TIhfOBW5Rxb3yvdQE4NOz9NYIrvQuA+fSXblprRxKzoK3n4MlahYLCkFkPs9GBsqon0lQFpJ3xmVvPIsX3VfU18Pr6gv635D6ydZwu+yJ2a6YeioWPmpBXfTg317rpVN6UbSTozDaDjh/em1iVM=
Received: from BN9PR03CA0344.namprd03.prod.outlook.com (2603:10b6:408:f6::19)
 by SJ0PR02MB7550.namprd02.prod.outlook.com (2603:10b6:a03:31a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 16 Nov
 2021 11:12:27 +0000
Received: from BN1NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::8f) by BN9PR03CA0344.outlook.office365.com
 (2603:10b6:408:f6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend
 Transport; Tue, 16 Nov 2021 11:12:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT057.mail.protection.outlook.com (10.13.2.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.19 via Frontend Transport; Tue, 16 Nov 2021 11:12:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 16 Nov 2021 03:12:26 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 16 Nov 2021 03:12:26 -0800
Envelope-to: linux@armlinux.org.uk,
 andrew@lunn.ch,
 hkallweit1@gmail.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 netdev@vger.kernel.org
Received: from [10.254.241.49] (port=56282)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1mmwO1-000C2P-Tn; Tue, 16 Nov 2021 03:12:26 -0800
Message-ID: <95c7730f-bd08-5766-64d4-7b851988533e@xilinx.com>
Date:   Tue, 16 Nov 2021 12:12:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 0/3] net: xilinx: phylink validate implementation
 updates
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
References: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d50f456d-86f9-4d55-2f97-08d9a8f1f952
X-MS-TrafficTypeDiagnostic: SJ0PR02MB7550:
X-Microsoft-Antispam-PRVS: <SJ0PR02MB7550803715BE3BC44C627BD2C6999@SJ0PR02MB7550.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8uOQSDZsxMqeyGYhCq27ipcOM8AkswBOQ+xJoPNOHWa0PP6vXa+b3fAAFW1qH1GLYQef7efvZezppNEaDsQv0+adCzkm0zi06/0lphvAhAPqqQPIhw3zpNFGN5MChCUshUYvDeaeT1J7H/5a8AWdf+3H1R1f2UybEI+1Tu20AelIcoZhZPNiQ/AQV3dsX+ki3/k7oF7GgSkoYcfjEsSOTqYu4rym3bw8YfYGZa9b05x/tbrGHW78iT1b0BjOtlI97doGvulwDx8q9malUSkJeGoivtDGnGqGZqhcHvm/JXL1cco9+JvfRbiev2h+gy8wmvfN7FxH0QG+k4wk69ev2sdoNUuKWE8HA/9Cf3zuFNT0oev+FQ2VT3WKDRors8G4RDY1jonFIY9XFdoLYwCgKkpIZOOVrcJN02FTR0NJy+8zCjnnM2Ezg9fJxoNdslKAFSs7YcOPY+cQd+l+aYnoxzY1A44HuOoVe7d5V/Z/sXknuuZ6cBLWyljicnDptMgdLeTBchR9YplPzvjHwXMPZ6OYn7QZdjWUZe0aUopBUysx/LbY1NrkTqYSTt4hbZeb/qgk2tOx6xDmP6HMWdZ0IYbFL5mKbcSVhzY4a++A7EoGFFvWE5ihDls1Yvy+GQC5OrtFTsrgK2jUhQh887ClyVWMMzCkUQvz0GInL+szKFaNLB+q2isn+kC4RrlgJA4BFDH+IdW+ja0d3v+x7CP3bBVLCm4/MJrk65XW+gBnzLL4PLY9nS4B/JC6fNeqzvc
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(36840700001)(46966006)(36756003)(7636003)(336012)(70586007)(44832011)(9786002)(356005)(31686004)(26005)(4744005)(83380400001)(2616005)(31696002)(426003)(508600001)(15650500001)(36906005)(2906002)(316002)(82310400003)(70206006)(110136005)(36860700001)(54906003)(6636002)(8676002)(6666004)(186003)(53546011)(4326008)(8936002)(47076005)(5660300002)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 11:12:27.1284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d50f456d-86f9-4d55-2f97-08d9a8f1f952
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT057.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Harini

On 11/16/21 10:54, Russell King (Oracle) wrote:
> Hi,
> 
> This series converts axienet to fill in the supported_interfaces member
> of phylink_config, cleans up the validate() implementation, and then
> converts to phylink_generic_validate().
> 
>   drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 71 ++++-------------------
>   1 file changed, 11 insertions(+), 60 deletions(-)
> 

Harini: Please review this series.

Thanks,
Michal
