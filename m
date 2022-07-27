Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE3B582367
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiG0JoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiG0JoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:44:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4303FA1D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtWJA2y5ABQhA7AcOd3jUt3e6IzDNvGXwmThd7vjAmAs8mQXohHvlLfBTtf05IN0/aSgI2ufXwVisEc1jmFbF/HDMQVvni3PnmvHA0PqxCMXiEW/med4S5pjOMYgeKHreypVawktVhUJUPG5/Xk/lZmBo4bpaoBc2WsRZaxkB4vj1Rp49nOvvCGoiUpIVY4aSY/xSGAaaOfXt44AVlQHCVOPazNCT0Z/Eh1Yxob4Xwwsz1YOEY4QD8skRTibtSwXSAd+0zewj5xNY1ai1PtqsEFimo7mxvd//fSngpTt/rcLDrSOeMv3H/1siaxXDrsowI9eVjxZgEgpBNchmmAvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwlxTpD4mZkHVKEzcV7kaJP2VesG8lzH7vCHIFWfq0M=;
 b=TGgVpLWDTZ5naniujhfGUWRXgSpJO9KjtgFBIj0MC+gMajNGuSYJgyvlC1WKZ72oCa1RIFGFSbnXDaM++5+VUx+W47nY0I0USac2bX560hnykdfp6xtdRygnpUtVr+GnIsYkSS/l+SYSArQnK5s7oKkmQL9KhXVwCh2AoLzZZ/nSiD+je96087sYuBcNVjpU/WI+mWnCjThLoQb1nLrv98wcnC1Olm/mTqZAKLEQvKgY1iPBGlwEkxlGnPlI4A3XdfT+xH1cyAO5mrIGlnNsLfnwfUVyu/gMqWmQAJzyjupN6j2A6DjD5iHsapDMWwkok9QmuxYcKkw6hOdNb8+LzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwlxTpD4mZkHVKEzcV7kaJP2VesG8lzH7vCHIFWfq0M=;
 b=mikcgmKfpWJauZxgyrdXLKmGnUUEeIkId+r5nIqFvGHVoJWXe+SEbOu2vypD+IKQ6cBOY9FzDSZ/jCrxg3bMEXDaRKFl5tB09FRRuG5j7mC9S4Bj7xrr1iItELy88fuH8djSDmNThHaKQOs7/g8EkdrsvxMHDMLIAHzcLrtnJ4UCCoOWVnUMHo10TIMMante6DQljNLZmu1N2UVY8MnThU7bJwVJjXz0ToEu4Mf4kr2MOMXe8rK3cyuSN0HkbWlbYg8anMgfKzB4GOto5CPfBBteav8MbRp2ElclC59zmiUo1pEsAhGl0M20h6HUmd8FneN7Z7yLh44vklnLVowwpw==
Received: from DM6PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:100::16)
 by MN2PR12MB3903.namprd12.prod.outlook.com (2603:10b6:208:15a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 09:44:07 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::f2) by DM6PR03CA0039.outlook.office365.com
 (2603:10b6:5:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Wed, 27 Jul 2022 09:44:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 09:44:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 09:44:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 02:44:05 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 02:44:03 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 0/6] mlx5e use TLS TX pool to improve connection rate
Date:   Wed, 27 Jul 2022 12:43:40 +0300
Message-ID: <20220727094346.10540-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e626915-29cf-496e-ef39-08da6fb48c89
X-MS-TrafficTypeDiagnostic: MN2PR12MB3903:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7LlZxe4iZM4Vm6JZGCR7Gc9Dd+In0o9z6l8w6bAwnFhTxP8eyBOmtp+i1xwA5yDATnV++Orv72eoBlpyE8ooCQJTLEC7u2QNrr73soU3+0dOKdtJr8ZPA8vijpSFrPQebSMw0fFZSImnQha+PQcmXGLGYp8SPsueRXu9FZXSBmPRFFdwMG9ixbzG8ll8jxnjNYN1S+nL660NeekDIgo4bOyx98WnORecfZ+T07NYv+QQ6aTZrGtVLZhUH0qfDh633gzYrM9E9teI2NFjp8rBuTD5tCFcGAEN9eJan9uy0+duL9/GUBCBfOwLNSaSHT9Gkci6SCQLWkbyrUj66Cjv9OyswMOYufTexotyQSBBvkb+LZCoMguc13Zreug3qHlpNhQXsCgsz1lQKAJ2w8Ek4F5px02SsnZphPjMHpu4digPmQvtzIglHFACmQW7NIj1udiumaLgae2dbKI3zfz8UkAh2mgJdKNiiBNLr0nZvVvdB/L7s9ExP1FEPXSfAJ0N2NwshhhJXRS3HJdW5JFr+HVPN5uvreJTgtyGjjBs31b2Lv57GFcMkqNFReJlY26YoeXqRY9vDlatNmjjOhVYcp0CBJTAVw+uWe7S4jZn8dfZsJ+b6mvVyoW89LG0eORVIj4m6rfUf2Vhs6OblatAfB1loV4S7KphuMWVtmsHZnTtTQeaaZVPyRf0kYaTEAfZPjq4dCc/mQVu4UrPTSP/gaBYHMI54oXbxSAQq5Eh0ApgVSuOPaBvKIroAG5xPanPKmZV8ALixw9DkFzBMF6j6UfcOlcqwt0x47cJwcD71/6RtU4UiiFAl1z3T6Xtd9C1gl8F20RrM75DubzH2XUNKlsXssQcOc/FgVcv/XrYiMJKiRBzil4qSYXLT0ftXp9IoE5yrRiQj36Ffjnxn8ZpmQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(40470700004)(46966006)(36840700001)(8936002)(4326008)(40480700001)(8676002)(316002)(2616005)(70586007)(36860700001)(26005)(82740400003)(70206006)(7696005)(2906002)(81166007)(82310400005)(41300700001)(356005)(5660300002)(83380400001)(47076005)(110136005)(186003)(1076003)(40460700003)(6666004)(86362001)(478600001)(54906003)(36756003)(107886003)(336012)(426003)(42413004)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:44:06.7742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e626915-29cf-496e-ef39-08da6fb48c89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3903
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To offload encryption operations, the mlx5 device maintains state and
keeps track of every kTLS device-offloaded connection.  Two HW objects
are used per TX context of a kTLS offloaded connection: a. Transport
interface send (TIS) object, to reach the HW context.  b. Data Encryption
Key (DEK) to perform the crypto operations.

These two objects are created and destroyed per TLS TX context, via FW
commands.  In total, 4 FW commands are issued per TLS TX context, which
seriously limits the connection rate.

In this series, we aim to save creation and destroy of TIS objects by
recycling them.  Upon recycling of a TIS, the HW still needs to be
notified for the re-mapping between a TIS and a context. This is done by
posting WQEs via an SQ, significantly faster API than the FW command
interface.

A pool is used for recycling. The pool dynamically interacts to the load
and connection rate, growing and shrinking accordingly.

Saving the TIS FW commands per context increases connection rate by ~42%,
from 11.6K to 16.5K connections per sec.

Connection rate is still limited by FW bottleneck due to the remaining
per context FW commands (DEK create/destroy). This will soon be addressed
in a followup series.  By combining the two series, the FW bottleneck
will be released, and a significantly higher (about 100K connections per
sec) kTLS TX device-offloaded connection rate is reached.

Regards,
Tariq

v3:
Rebased on top of relevant fixes in TLS module.

Tariq Toukan (6):
  net/tls: Perform immediate device ctx cleanup when possible
  net/tls: Multi-threaded calls to TX tls_dev_del
  net/mlx5e: kTLS, Introduce TLS-specific create TIS
  net/mlx5e: kTLS, Take stats out of OOO handler
  net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX
    connections
  net/mlx5e: kTLS, Dynamically re-size TX recycling pool

 .../mellanox/mlx5/core/en_accel/en_accel.h    |  10 +
 .../mellanox/mlx5/core/en_accel/ktls.h        |  14 +
 .../mellanox/mlx5/core/en_accel/ktls_stats.c  |   2 +
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 513 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 include/net/tls.h                             |   2 +
 net/tls/tls_device.c                          |  79 +--
 7 files changed, 527 insertions(+), 102 deletions(-)

-- 
2.21.0

