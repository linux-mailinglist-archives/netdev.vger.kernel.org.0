Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929E051EC55
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbiEHJOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 05:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbiEHJNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 05:13:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50093DF1C
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/CiGE5W9VHAwO31M75xs5jzFVKOKeC7WYi7VUt7+5ISvNrm8X35eZI1njsanSufXKjiQabLtOb+EmKgAbqvxvhwaLUY/6VZ4ox/nDc2Kdj+n10puVY0M6d7BgdKRo30tCOCiVgiGoHO9xK2EkItTqBykhEFsl37a8jBqebMRcY95VNY0IF6SNLXpHuHVGqVWfRiosypnqI1BE5CohyekBY9R4fd2E+Q0M5ZgdGjvIR+DUkMc12bBorPb0rkcQe0uGyOzzvy7QbO7CQN54PyhmNta7T0Z2vtltep7cQdRCgZhseWltKb9T+Ko6ghbieDf/2kSQImH+V3nWCglYAjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FI8tDYeHnQvZ7AGpnrT4pedSw2GjD+Z91ATYcBruMzU=;
 b=IpElCBnVEtvsAqSBbl1G8L6Ysh1GkUV7I/2TUqL6PwF9lMCmBtiL/jFnPnq7o0NPfTNXdmviLo8EaimDIimPdNMhzymvngWuiR2yzjCFBzK+oV8DB3r6DLs7SCHPBdt8sLxLwzNopyQMhQtLLBqzbL8Eo+NyWWePw9EjThMVJiugZma66Nc69UFEVomiD/YbH+sdZ78iwq+OW59Y6e30BkHmUPz7ozqZXWAHI2lAbSJem4XB34jStzajr/ls78FQQA2oPzR1D2d1cBLkspgS8JVyZ/qbBReitZoewaZGq4hRSsSo8+Gri4DUjWFEGVX8R1mu+eut3BW5/FBAiIpOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FI8tDYeHnQvZ7AGpnrT4pedSw2GjD+Z91ATYcBruMzU=;
 b=avbisETDthK0jBoZenk1X/M4zfhao63uvfdqHe2qvFo6UVNQrFiBFSUnXs9S1pPr78CgSDoAzEbKbMqVJdxOFd4JQ3IXE2o1K1UdUEK/cmBnoFRYYZWD5U4LQ98neVE85qAM/Ljjaaq8QnF5EPvUjw4KM5h63k6bPs1tgOyqpGWtnUo2ABtZ2r20fYzC4mUpBeoJCIqdnmbt+5c3Gx477QoDaNM4xE8xFagBeItxx60yZ51I4EmlYm3r4nlNfowN7cHBNtDg4/NeiWMFGcv/2MQY/TCQ1RIqITVRYgoVS6X9HaXus1C7tNCys1SclFbKKb/m9q9zgztPEN8QqIiAjw==
Received: from DM6PR07CA0117.namprd07.prod.outlook.com (2603:10b6:5:330::32)
 by IA1PR12MB6307.namprd12.prod.outlook.com (2603:10b6:208:3e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 09:10:03 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::46) by DM6PR07CA0117.outlook.office365.com
 (2603:10b6:5:330::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21 via Frontend
 Transport; Sun, 8 May 2022 09:10:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 09:10:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 09:10:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 02:10:00 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 8 May 2022 02:09:58 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net-next v1 00/3] Introduce MACsec offload SKB extension
Date:   Sun, 8 May 2022 12:09:51 +0300
Message-ID: <20220508090954.10864-1-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 919e8327-efbc-4fc6-29d8-08da30d28872
X-MS-TrafficTypeDiagnostic: IA1PR12MB6307:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB6307E260603312240C9D3824BFC79@IA1PR12MB6307.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fPd4YI4Mt7soHawnvp78h9juTPLb2oo9oUCX7D0M2XaF1rMzmq55i7h1V3VO+8GrcVFVrjh/7GQUJBKIKMeyXVoVUHpY1/BjFniqIPYwIQtdM0cKhVHMf5e/VVT04mJVH61r7nG1cgVTEfKLzpfbByvOtEynpiGBq1qmndotp1l9y+MqlBzQGq1123nlq6YhqAaan2+V3dn3mQNSg//PIaum5XvHezg3SCQBNbWfnjwcQZl+BSbgmdL5YW4svhJycQ8mJJf5LVBoveyNziJWuvQ8kAu98Av1TMvP8EWJc9zjC02LHnPlwo7xRlPLYzP5+dD0ta2EBEV0QFL9spTrFWzWbZQN8imd8JOu0aesxRBokpzDg4jJup146rQLSyzNumdU/9mPFj4Ovk/UgGB0odph+8FN71JQuyNwqIKAogOXMeCBApzJcgvWF+ovZQLNBffj6lFWB+gPi4Jyc/LDVqYJG5D5j8D6DKMy+gCFx/7W5LjQBernQdth+srDAmyuTPcDrI4Y9cW4zhJESIUBOaHSuCIGeNIRtDxZ8dmCsHxCBMIWEkxsTYWmxmqObB3qQ/qSxDPFfygO6YP8oarvfdfdUBqT2dkILi1WH1nY4shpmwky7f3YGQRHzyN68eK88ZN4ghGM8r74eVx7Y+uelIq7usPCzb5AHnOXKRQx2B9Q9b9u/FduPY284qzTNObuaIZbanLoYdgx2Olvqq38ow==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70586007)(81166007)(8676002)(26005)(70206006)(4326008)(8936002)(86362001)(5660300002)(508600001)(2906002)(110136005)(36860700001)(6666004)(2616005)(1076003)(316002)(36756003)(54906003)(40460700003)(82310400005)(336012)(107886003)(426003)(186003)(83380400001)(356005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 09:10:01.5545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 919e8327-efbc-4fc6-29d8-08da30d28872
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6307
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces MACsec SKB extension to lay the ground
for MACsec HW offload.

MACsec is an IEEE standard (IEEE 802.1AE) for MAC security.
It defines a way to establish a protocol independent connection
between two hosts with data confidentiality, authenticity and/or
integrity, using GCM-AES. MACsec operates on the Ethernet layer and
as such is a layer 2 protocol, which means it’s designed to secure
traffic within a layer 2 network, including DHCP or ARP requests.

Linux has a software implementation of the MACsec standard and
HW offloading support.
The offloading is re-using the logic, netlink API and data
structures of the existing MACsec software implementation.

For Tx:
In the current MACsec offload implementation, MACsec interfaces are
sharing the same MAC address of their parent interface by default.
Therefore, HW can't distinguish if a packet was sent from MACsec
interface and need to be offloaded or not.
Also, it can't distinguish from which MACsec interface it was sent in
case there are multiple MACsec interface with the same MAC address.

Used SKB extension, so SW can mark if a packet is needed to be offloaded
and use the SCI, which is unique value for each MACsec interface,
to notify the HW from which MACsec interface the packet is sent.

For Rx:
Like in the Tx changes, packet that don't have SecTAG
header aren't necessary been offloaded by the HW.
Therefore, the MACsec driver needs to distinguish if the packet
was offloaded or not and handle accordingly.
Moreover, if there are more than one MACsec device with the same MAC
address as in the packet's destination MAC, the packet will forward only
to this device and only to the desired one.

Used SKB extension and marking it by the HW if the packet was offloaded
and to which MACsec offload device it belongs according to the packet's
SCI.

1) patch 0001-0002, Add support to SKB extension in MACsec code:
net/macsec: Add MACsec skb extension Tx Data path support
net/macsec: Add MACsec skb extension Rx Data path support

2) patch 0003, Move some MACsec driver code for sharing with various
drivers that implements offload:
net/macsec: Move some code for sharing with various drivers that
implements offload

Follow-up patchset for Nvidia MACsec HW offload will be submitted
later on.

-- 
2.25.4

