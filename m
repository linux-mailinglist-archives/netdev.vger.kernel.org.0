Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C85A10B2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241968AbiHYMjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbiHYMjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:39:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E4DB441A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:39:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhiVgR3GiB4TEtQhABLvgd5HLyMWNAqHooVVzsNN45R98/q0RIaIoOI47Ecbj/SnFwAGmYIQbLSfWkpu+58J15JrUWBZX238wqiQwRTDFxx/dkDLZ5rpGut6HHWmT6kkg8cfJPv9XfYvfonlMcWi3Ciz//4roKWEZ3b+wh7SIgjQ5EVW9dlawCVUSiyK8Z2JFlFRmdoeTuhCcfhnaP5VzYZshHO5p588jWnG9opQ20FgQqVS2rN6JhQgg0jZFKasJVLBr7ZxWElJe8HkvEdUWS8bieyGza+7lryGW8LDn5Qh4cWjssLkYnhGS+ATGsyDiz8pCZDynaVcyzrtGkwNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbMOfm54PfEKKMrutHKpzixCxw5/VraMKU5djOyeQE4=;
 b=frHhKpye/auPYGVEao63FMTZtYOq55DkynsDcbih23YmzfxjcNeuFiA/2aZG7j55GJDpqg8ifmtmlgiPfQmsl2MrzEcqyGz174LdND5NXo5gbf/kSaNNHSRvhC8WILifOWaQeURU47hWt9Oo3VckKUHhLR1DhAhexfLxDyMbt5X9XXxPe6LqjDP8BsyPFjmGzHA6EEc/kPXsz619mQa+5HxUwRTlgg3Povzyp9aR3gbjULuj7+p75OyCUoqZ4RM2TyWD82znFfpq1OBmU+oVTmrWUlJfyKFvn5DFExPWth+WrPbikGROkZXKXRphXwJMM1n4nfcpOHN+LgiXJeRKNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=bestguesspass action=none header.from=nvidia.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbMOfm54PfEKKMrutHKpzixCxw5/VraMKU5djOyeQE4=;
 b=MNce/1FrcY/PME5nkEKBSnU0taBi7Q3r1/4x9qVO2tvLWsZwtYfEDHZ83PqpGAlXrofuxUs5sgLjlN+GMQCrIzWMh8nn34CsJjFA5+q19R8bK5SCirgqGu9WpA5sGtbXvwimXUnmKWsMDug5nl8RD+Jqbl3hEQvPMY3TYvyGKeFXRgqLjo7sJDqxdcEEIpyjOFp4LUj1u+SBDe3mNbOVYFLgBMmI/5Ud/A4KwxMW4L2/4DNV675apZdB3Jp/8H3+ASI/A0F1BX0A03ew54cEarXnPO8StnFV0KWCHqUArzXviKfpow14aFNCnUWk7NWfv8YqtzEq3E5n6gMXohQh3A==
Received: from MW4PR04CA0267.namprd04.prod.outlook.com (2603:10b6:303:88::32)
 by DM5PR12MB1947.namprd12.prod.outlook.com (2603:10b6:3:111::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 12:39:02 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::8a) by MW4PR04CA0267.outlook.office365.com
 (2603:10b6:303:88::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Thu, 25 Aug 2022 12:39:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Thu, 25 Aug 2022 12:39:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 25 Aug
 2022 12:39:00 +0000
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 25 Aug
 2022 05:38:56 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH RESEND v2 0/2] Improve virtio performance for 9k mtu
Date:   Thu, 25 Aug 2022 15:38:38 +0300
Message-ID: <20220825123840.20239-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8367ea30-fb94-48d3-f7b5-08da8696c989
X-MS-TrafficTypeDiagnostic: DM5PR12MB1947:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6bohjNJN38jIaPe0uAwddvC2qqG0DT8N04MolZWNJP6NUaHI3MKKwDXjuQTNfHjag924c/0lPuPqg5/7q+7xmHoG3JHdhCahLT2zx/RuSLfCCBP4CK/9R4cRQ5n5btSDjZfB5QErm5Nc5B4cgIE2doo4w695TqEM3580KK3XOG8unYY2bNPMn/mgufcpyfPZzFDGVjW95LDNTmY1MhI0qThb+3bvrIl8QgAbZfkAz4r2Kysh2AYKXR5pURes6sl3DDib6oen00qtdRgKg0TCB1BECsGBExhafs/yiJ67w/0bx/Pk0bI0CPaa/rJFPpZ+/sz10E+8p9ResW5rK8721Cw3RZ889d4tUPme1rTrKxlJc8nC+FA3HQ2GUReiVWB+IryLQTiAFskPitQXjgbTe5tS3wvaNN2ZZ1hJRW3sy1iRh1tnM8+d4vgBxlDW7IpA1btm2Pi9LNEIdW6NLtmqBDUc3GhRdgnVYCyvzZLFHKK3vAyFdwm64O9SfqKulizbjIfCXYUjGpyx4uLOGf7dqqqt1oRR5/yHQtb+5wa0PhqucAaX5lBQcwgQdsq75ygX7gVlnHuPxmcFORtT4VMEeeirpBo1GrwHkUjp5V1apxWI6eHUqJvtPVWA4ijmvHrOXplkPb096HLyTOsruf8/rzEWwDyRxDDR5QgAseHSvqCAhqeibJx+s/zRZCg4gumYLep140LisevniF97mjDsA+dDijUkfGJxRuzeyGmjr2Bg2dVNoYYmY9aH+WL2sFP0WoAxpAUqZEPQag9Bb0plTCwI9Rv1jXC2tg9WQi0V+ztqeY4eraUp/kJurUBTSLba
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(2906002)(7416002)(40460700003)(83380400001)(8936002)(4744005)(82310400005)(36860700001)(478600001)(2616005)(5660300002)(36756003)(426003)(921005)(186003)(47076005)(40480700001)(7696005)(70206006)(4326008)(16526019)(54906003)(70586007)(110136005)(1076003)(8676002)(336012)(55016003)(82740400003)(356005)(86362001)(6666004)(26005)(81166007)(107886003)(41300700001)(6286002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 12:39:00.9575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8367ea30-fb94-48d3-f7b5-08da8696c989
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1947
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series contains two patches that improves virtio netdevice
performance for 9K mtu when GRO/ guest TSO is disabled.

Gavin Li (2):
  virtio-net: introduce and use helper function for guest gso support
    checks
  virtio-net: use mtu size as buffer length for big packets

 drivers/net/virtio_net.c | 52 +++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 16 deletions(-)

-- 
2.31.1

