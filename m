Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE68687F0B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjBBNq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjBBNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:46:56 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04AA8494C;
        Thu,  2 Feb 2023 05:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D99qPRN4LI7ih64TjqF3mokzC2SizWG4jXgQgh1GsuJetWu+F3amPCBgENmUWy0QO/WXCaKF4c8jXJQDljREy/7FlK408Z1uN9CUdN21B+s+m/wQsvGclwJAS8+fqkhAO2FnVLjvvt1gvG2vBErE7ihQhcalFQGIoN70Vg1X0MvMpIyoB25Pv/KZO45vXJwu3pdMeK0ssNcfn20DrNQuXymO2F3xMQJ8G47nSiSqrXYVPiv71/MB1oeDEs2DRgIIbXQ7RWaFLpDw5RalECx32bg0HvtBfCJBsRXXQ6J2bUbDABgejB5t5QlbWgASgDWxxAkyyPOR3CFUzIsvqMUg9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Gb70/0OCBm65vg5e1eACxl2NwtYBe6Om7HgQKGz25s=;
 b=WKm7Ll7AgHJ4rIvbeeM1ydkdwMfDf20EMhUU0Xq5019oLFuZ1T26eqmoSOFB4Hor6x1Bcm5Vnu4s8FsIXYCSUk9UsxmHbl2X/qDYFEmxt1jKhjWaG+dgmfg7zJVDTHIFuvEZHLB9fzutEhRqh43xx9Ce7wCxm1bm0Se2/cuRESI3ckjzS1R6gmTLxEEbwSzDogD5LS5c5sBM87BaPur9j+e2N9Kni9Jc817VJdEyAPNsLv2lI3c012rNo2+5b9gQK2WR5tmaNCtiZJacJcg05aVZwUYhCOt4e+qY6t8NxrXjidsYTPQYvAv8VF29ZK0PQ11nxdQ8QShAix51ha8Dvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Gb70/0OCBm65vg5e1eACxl2NwtYBe6Om7HgQKGz25s=;
 b=rttLkfMIexW5Dw+tnbKA75FsK+/Bj6XNnDlVx5xfYxTaiQ/XVvs8vG5JGxyWk6yirutod5Qe0Sd4qjWMHUig+3+8EBDY8tKcXKcZttbGLSIFo4SNkVDoaYpLzXvmX5gKhi19GUqSO1L7am262qJ+utjNu5sIFnZQpFwkf2CBQ/o=
Received: from BN9PR03CA0636.namprd03.prod.outlook.com (2603:10b6:408:13b::11)
 by BY5PR12MB4935.namprd12.prod.outlook.com (2603:10b6:a03:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 13:46:49 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::be) by BN9PR03CA0636.outlook.office365.com
 (2603:10b6:408:13b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 13:46:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 13:46:48 +0000
Received: from [10.254.241.50] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 07:46:44 -0600
Message-ID: <e426613f-b7ac-fd09-2476-ee4a991ffbf3@amd.com>
Date:   Thu, 2 Feb 2023 14:46:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] net: macb: Perform zynqmp dynamic configuration only for
 SGMII interface
Content-Language: en-US
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <andrew@lunn.ch>
CC:     <git@amd.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT038:EE_|BY5PR12MB4935:EE_
X-MS-Office365-Filtering-Correlation-Id: edd770b7-4294-4036-1721-08db0523ee70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SAzcVxVr++uM/feVnju77K5q0IfJva8rUK8RCMp798Ipb0Vlm/RLbcI5B/gnae55G6SQ+eYgc0muVJ6Rhoo9tznQvKQ78vaufnOgTsqbz6LBYTUKKt+AAIkUdnFY1Gfs9rrVwncFWTqyM/bfKTIitAhtFzztIMUh0onwRWO/SyZstypnmGXE+yMXCjmlYcdTwiEm4nWj9qfAUg9axg1XuVgWeKLl1bW91vuBOV8gEH/ilrPyMWdKrb2XJA68am39ldxMRowru4+HP2iamgDQ/+P/MA/VzsDypy49FBv5QyoE7SWPG8Bhv8x+U+ynyqR9k2TJPFY9rnZO5Y8n562jsu1IW6Q8g3CrtyOnyt/5eWOxbW+eK98aC3lFu6Xbzr2XNq/vKoWpVeic6tE68ULErIjPp61LlD3v8+kNbnllOeN7Asr2hT7eo5nBYgFdTK43fhE9HL/6H00dWYw2dU79cx6lsDj9wybYW8bcB2ItF+ZV4FgLpTHlBbO1Fc0U/no8Ry49EIJw8ITSSsFfFJTrLuvKbh9QboL8F7YpkfhfuDgwIURzK8xHkfoZoUbhbRyV4pMGep+QJzPTbjiS/lV6OOPyAGHq0l10yeIMFW64Vq9UGKDekPe0Bqg+ccrH5mWhLhoyiDyZXPEft+TmSjDF/jDho8td/gg8DkWZtCFf13w1YcPNQ7KCDA6QtatL7IciF66C3M6XciRW0pgcxYmR2A8zj8s2wSczIFUwtaqZ6nkfjJzLGAflI1L1PtGVjhB/8XILlGiuJvayGs/MWwZI8w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199018)(46966006)(40470700004)(36840700001)(16526019)(47076005)(186003)(426003)(26005)(36860700001)(110136005)(356005)(2906002)(82310400005)(478600001)(2616005)(86362001)(44832011)(54906003)(6666004)(16576012)(5660300002)(53546011)(8936002)(31686004)(316002)(81166007)(8676002)(31696002)(82740400003)(4326008)(36756003)(40480700001)(40460700003)(70586007)(70206006)(4744005)(336012)(41300700001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 13:46:48.4906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edd770b7-4294-4036-1721-08db0523ee70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4935
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/23 13:26, Radhey Shyam Pandey wrote:
> In zynqmp platforms where firmware supports dynamic SGMII configuration
> but has other non-SGMII ethernet devices, it fails them with no packets
> received at the RX interface.
> 
> To fix this behaviour perform SGMII dynamic configuration only
> for the SGMII phy interface.
> 
> Fixes: 32cee7818111 ("net: macb: Add zynqmp SGMII dynamic configuration support")
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

Reported-by: Michal Simek <michal.simek@amd.com>
Tested-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal
