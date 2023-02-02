Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB686874DF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjBBFBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBBFBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:01:30 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E33577FB;
        Wed,  1 Feb 2023 21:01:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jthc8E/IAn3rVTyIO6cQ7b9iQvpRnRwHUjsREBaaO6hl6LqTjJd4AvyECE0wsDkLPumv+jLnR3cXxvLTAvsvObSDeSknyW46dgmOwU/ok/RptGniM2+WPwz+umT0kiDVsPWBhWc9jYHknIFyInpbEFCTNteYAXWTjTmj4bBzCOHj+YQP2C3tBzxvnL3isn2vJTjGdREvxBF+7J4hQXi+tzlltw6B5Lq/+tVrtpuNGFRgpeliufg4hEEW1yS3OYYQVuXY298tR0N4F9s3h3e1YRZbbOlRpvgKoRVZ37U2NxzmQ8YdH4ltuctMQppPtXaBPYoGnwwgB6k6y+3zRNBAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I/diG3QnC7clJPYiRr0UXMWSF6BiaRsvuJPmh+r5m8=;
 b=dRL9xvUb8+qdNnwA7UsecyeyBYbHgZZ+mS6HpvM8BmuO1vTxb8XsZ5GckZdagQ61GVSGWjXuayCKROmy1yH4C5ZXpygBQLINxjCxmuQoksK+qGqIWjXkL/n5b6Nj9m9tqvZEbew9JLtXQZDsn4wlwDyDzySclisQVUmylMCj/G8J/zWvZVbv4Fl54p5Rpif0vs2MtQ13MwIBKfGM48mAFVFw99a0FvLXlT4cv59fNosNInc+A82/b4XAhwxYZjKYnCjA5S5uNM0ELUsqPdrbuZw9XfLtM76PzsOJ0VbCTDalEuQctG9wYK2GfCGF7bQk6JzPdAkR/Uin7Mdzpp7XAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4I/diG3QnC7clJPYiRr0UXMWSF6BiaRsvuJPmh+r5m8=;
 b=KSLjgc2S1xhtO6vUALAM+RWGTZbgPMmJ+naV7jBabG9DpE2arIoFkfZV8u5oBXsHJecOvzGN3dXzhc7FMMGT5/EMESuNCMnRoWwawZoDmd6R4dX9QIXj7NSCqR+hXSgEMGMg/Dq0Qbt3j7ch8r/Onmxkz/5mEdSp8wIN5HIV+UMe7tND4gpelLRMYxlaWrGl7OAVwgiHGLQpUd4WZJGh13S8ABByMt47zmXMzquz0d+yn1p8DUYauJ1vq37vrUXdPgFS1Xg0ckza7TjiIoHz1/j3hSrdOAXbZdwIsnru9nKu/ytmHSV01dBOAwnJW7WVr4Xmj4Qd2zPNngdbEKblaQ==
Received: from BN9PR03CA0480.namprd03.prod.outlook.com (2603:10b6:408:139::35)
 by MN0PR12MB5787.namprd12.prod.outlook.com (2603:10b6:208:376::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 05:01:18 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::23) by BN9PR03CA0480.outlook.office365.com
 (2603:10b6:408:139::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 05:01:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 05:01:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 21:00:58 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 21:00:56 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        "Parav Pandit" <parav@nvidia.com>
Subject: [PATCH 0/2] virtio-net: close() to follow mirror of open()
Date:   Thu, 2 Feb 2023 07:00:36 +0200
Message-ID: <20230202050038.3187-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|MN0PR12MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 89cee5f3-4e1d-4480-d751-08db04da84db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lP/okB+6Jey7nkxmzQloRQ/0q0eW/rxYqiEUERy8eRLvGhNE3rxnnbNuWW1jqNMFvH0xa9Mw4H3v6DCMzB9+UV736HbJTdgdUElRM9UavhsYqgrGCyn/qKhcp85uqh0fqjOHUdV1k6Obt5pvyfH7VCMpsvhkyBiEI2E2i5peIu4EFP2blYTUKnGW6qbxyJ4W8tJxI0CGfFB6Mrd/d/H5SnG06U2Xk9THu9okxPyKYxqLM+Gvtn6hZHMc04/sr6++u98BhLUzl8zDKqJNNEPoKO8AQHptIzxwWrwXRAXVJxUtFw9hsGgcVL+L4xNaQ79JfUTqto+63dmnp5S6S1pXuZT5WPNC+0cWaR+AkOgsJ1GjzUE213lw8ppfcWAKtAbPNceUGJ9gMI0XKr9SKc6r5PK55cFLAm7RGKWtkSV6UGGD/mHnoDYKiIQhFOyJ72Lmgfuzqdnrba7DrvQ6IIryeHBaqGAnkiNRzXU8SMpMQA8DZO2duayawPgU0M7Tuj52aR4X0IVNhF0zCHf/XjYfedjl+ZiDK872pGb5aDu8zKVJl8+4FjJyVSsOxpP1ix5pS3wyHFdAsAiUmTLvmtVzIgNu5acOuM8/bAtBYPrvibt9xNgg7C1eY5cr3PahsGFOvcuD5qfNWWzDhpD4fY9sYp622CqtMP2Me71gogX8zZIs+TRo65orQwvoW9HbOj2OQBlhySr5UsPxiG9NnyuiQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(5660300002)(4744005)(7416002)(41300700001)(8936002)(478600001)(36860700001)(4326008)(47076005)(70206006)(70586007)(8676002)(107886003)(6666004)(26005)(36756003)(1076003)(16526019)(186003)(83380400001)(336012)(110136005)(2616005)(2906002)(7636003)(82740400003)(40480700001)(40460700003)(86362001)(356005)(54906003)(316002)(426003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 05:01:17.9407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89cee5f3-4e1d-4480-d751-08db04da84db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5787
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This two small patches improves ndo_close() callback to follow
the mirror sequence of ndo_open() callback. This improves the code auditing
and also ensure that xdp rxq info is not unregistered while NAPI on
RXQ is ongoing.

Please review.

Patch summary:
patch-1 ensures that xdp rq info is unregistered after rq napi is disabled
patch-2 keeps the mirror sequence for close() be mirror of open()

Parav Pandit (2):
  virtio-net: Keep stop() to follow mirror sequence of open()
  virtio-net: Maintain reverse cleanup order

 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.26.2

