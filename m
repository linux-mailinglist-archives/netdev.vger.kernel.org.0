Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF316582002
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiG0GYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiG0GYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466A119287
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO/GS8NK5NEKrZ6yRwSjwoxvFt863r3aHqQPHOuYix7x08wYecGRYJB/KguK+Vg+LTdOT+aSOeTWGvHtFBYZTzZUchJLzzS27/5tLO38aOng7euX6CA/zbmwquasJuVJo0rp5rOqVR1rZdTeufXvXF25QSNyucV0eNM58QXySMN1YasP7UbkXZpHiuBS/vbM3G0NgHvJ+owXmTqYCyAxhvPwXIkPZ6YO4eZEe4lVnhk3vl6se0sT4iB/pwk5T6a8yAwxgQKFlRNMvzdoE5VaLtHCsPEfNmp7F6qfDmUFLnJppDxss8huj3HDSprT41xdo/Z9qXE6lZeVCeNDf2JKGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNseujppjPX4Y0qvPhZ2dWYzWODRruqAvGSlV41en6E=;
 b=B7LAIl58xQIi+dSiS+cCPXG7gaVNxMbOKNOUArhq3q57e1fYgiQpDT9rpaKPYZNUIotAUb/Obmg5hX5NKaEZL6NEFGCPa01Y6l09gAL5g6Z+PagGJBQjLXdoF8L3xODRhyPX4RI6EsL7npfLkfZbq7lQHAs347Bt4ncRGhC86k6WjtfQHNiz5TWEideJtMS5iMaHXYVRp4qXQZB0sFn7oOefCWSJ3Cy071rUqIlu1FBaLzB8DyQJSPFGCz5xT/e4V5jKYGlftSqJ0L/WGiONRdcwMUzu2RvBBw4nxqAoDPXdGzBbPhzTq+lDT8y2fKGEVbEKGNv+unj+IRxJn/T6VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNseujppjPX4Y0qvPhZ2dWYzWODRruqAvGSlV41en6E=;
 b=JJ/tGPzaIHSQi9g4n1mCy0HGxDwU0RNgqSXW0H9qpfmfOyvMsDfrR+pE+BtLXVVtyCwts2cyjrATsOVwW9bTJK7ja8SaHHiCx8rdaGFhFuEeADH/YtdCYk2dnBqwroRl6MFma8kjjdB8irRUxqz+XaGn+6MRRNyVW1WDqN8xxHyAq+Y4PlXtGuwFwjspiCwZcDoVp3AFqzCxoMiMI+RVfTFgEAAVOyvtSR6UDEtFW3OkdFOY6aYPm35AxOcpQpzEF0WaTbP4l6IspLLkNdRdSSrWvcDpu+wvmWYKnuLkDOyRCQ7Or9MkEEG2smxeEXqwGjROD28mP+UCruev6dRUmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 27 Jul
 2022 06:23:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:23:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and newer ASICs
Date:   Wed, 27 Jul 2022 09:23:19 +0300
Message-Id: <20220727062328.3134613-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0143.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c3794e7-608b-4816-0ed6-08da6f9896c4
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sM5PiKex3RA5nRGaEDGk38MaRU129fiHqQwFMY0fhN4hpFG9fiaDtvn02Iz0xWPB5lGwoICPMJvPbUxedzRvxs1JjSwdnE4HKMinN5NFCpDCdfdvwNrw2aw4HJhYJba8poqJtvPokN9JY5CutLMHPKGKI6r//+yRz5QEb9aWWdEJeEzUKIJDk90dfdnWF8LXHYDvV9EMTqr287vp0PSMul3jtTV3MxRyvCWnwNp3qt34AeWZMxJzzl0IDLjqGEQK0xvPflUzM4vRwvI2bBd29LZCuMNLbyyY6zJ4DHkIbNO86eZ+RbrT9KzTUtH4jOQiWVlym4VJoznkRqh3UylPj3OWR1vRP+YexXJ/wza4J2tITUbjgfSyW4bPAokw0yGEE9TkcyacRLfxrXk4AiikSNdBFDsYvgy8us2Lh5NClx0x1mmbWawb5QPr3WWyyp4HaYJm2Upw5ieE85RsLRBi8ShzbDGGhD3cdZgtpGNDMCZRTAjdzmxCYFypPD+JEVG+4iUJxA6KMTUMSAyGMoCqzGCIYcMQQANMaQeBPvRSNj2P+oKlRl3YkIFQw15FobckZQ/XaX3G7JWKB1fPTz7UxFO/SzSosX1SmWpIZVHv54ZjrSlZHny2Kp7t5HDlJkH9M3ZUmvdAPWGrES2PhgqE2jcVWVlZ7qUA0mX/YQs0qCiKLxyecjqyqk1tvIdxWBUYCwqxkK4vn88omwMFxBaOSPSy/1XQgm+VjMe+v3Y2KoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(41300700001)(66476007)(38100700002)(6486002)(2616005)(66946007)(1076003)(107886003)(478600001)(6506007)(186003)(6666004)(8676002)(83380400001)(26005)(6916009)(8936002)(2906002)(5660300002)(316002)(86362001)(4326008)(36756003)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bq1BMlMc8kJhX4veqNXX1FtfNTJ1vL0M7fAq4QfI3FLx7gMBYL7iSp1WDl/l?=
 =?us-ascii?Q?EF3SDgjZnS8JJXzbRNo8FxKN7enjfoAGesBnkpOVlIJFSjb51GxzGggLGJvK?=
 =?us-ascii?Q?Ie+YPVM58nEE2AKhJlmJRzlIFny7zHvjlCnqjBl7+6FLvknP8/XfQdqmGGr/?=
 =?us-ascii?Q?doSTg8EkTacG4DaLrGvxrU2GQ+H6HyunPjY+jg00MSwHws8pip43lSqx75nF?=
 =?us-ascii?Q?4Imdbrq0blfHEETkPgOzcd10mO3wmD+jScQUAEwJeO1jBz55Qp+MH4ki1R/S?=
 =?us-ascii?Q?MS2L350GBrSUfAbB/JgUo/dFnr3SFtY7oBqsCY6v1wioFrhDYWYABDx/SOyM?=
 =?us-ascii?Q?Js74uQVffuTVAzLfpjtIdoMXJc7bpL2qN97EUeWMFTIiDkS42mi8xhy53IcF?=
 =?us-ascii?Q?HBYBpzgp87zvsOCivqNRlgxbl1cW0yU1dQtQQUxPp5hEHqlQvBicu3tEkNMw?=
 =?us-ascii?Q?H6U6KbRMSCno/VIHcNjMS92MwV7FLtLXPReaN7nwJGuqpAjAQwHVdAJff/z3?=
 =?us-ascii?Q?T6ndUkzURz/hdhQbp8nDc/m0Cid/wuk/NI0WeUbNrMAbyQJEdpf3MYScHHIf?=
 =?us-ascii?Q?BRTwR/1VWAdrmCDzoMO2RPXWP8Gk7Hn3ObNUWE7gawGG6PbRdVTFpXWsyYJc?=
 =?us-ascii?Q?E8qWRLX/6aeFp4T0hVLJ0h6iJ+1ffAfbtNp9+yQXDCB6d44hPrZJvcuFOxID?=
 =?us-ascii?Q?cI8TqfxpO4ik5LrRfikchq4A077JmiTvuKGXSWvCmgfYAWT4tfoa39/f+qGS?=
 =?us-ascii?Q?aTeBkwyQFfDAIlzxb93WjY+zTmcAHf4icnGlHIAJv2f+HXQnDotRu+KcqU81?=
 =?us-ascii?Q?aphKh02xmhMlSySkDHaKYPBPQTfH8c/8qhENA3vCzH69smNrERZ+6wu02R5h?=
 =?us-ascii?Q?RLtmJh+2JcJ75znOX37r7SW32gM7JZqTY78TKfeGtSgx/j2UvooncaV/2KyP?=
 =?us-ascii?Q?vw5SwYwQPzfI0uLVd8pyD2pc4shpjA2Sbro0ad0qYBso6jr7PXZceGBBTrb8?=
 =?us-ascii?Q?rblJ4JcGu1GJSx6T1GguuMOL+WTotcNKa3UAXPZs9l7Y7JUaZeb5TsSYxH0X?=
 =?us-ascii?Q?JXCXA+PLn+QmhP/zhaOC24w82dvvxGgmP8qUA5L19HIHByegoKpY36JHEHsp?=
 =?us-ascii?Q?H8Giu01QLAkmgySvtGyN4prTQZO+EVwO1gr7Lfrs2AHJuuMpMEjr0GMXWebT?=
 =?us-ascii?Q?9KGbPFcG73+/W6YjdurEGF9+EtZhvhaUC7kE/dtjesaLUGX92qZPxc+ItDXn?=
 =?us-ascii?Q?/trrCt7HwR/Z5y4l6QpuBtrtguVh3QsjAE73D5PYfAbppxMfA3c5BuMNT4h7?=
 =?us-ascii?Q?eJ/35ZhTVgX1qS/py8g7tLXfLUhAFhoLxQ9PAnkS8Yq0geE2hbAgHh3DoMCD?=
 =?us-ascii?Q?Srw1/oppv4HfJUd+MffxyuNxKm2JsMP4/hogacutePDlqWdOu9ljkJGlgnJK?=
 =?us-ascii?Q?0cYD4i6COHoogPY0V0sPD5Qrl1hgvLykupJQoJph3jVevRJhyPZywByB91Yr?=
 =?us-ascii?Q?hbSHSUKI2IdJEJVFjJXCv0pL64QCyqiLAd0C1/xd3SiQ15+n0bA+GmNlLHox?=
 =?us-ascii?Q?4MbDhiZQYUju7o8Zdd/x9jY/8NEXcKaYr8dHawUe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3794e7-608b-4816-0ed6-08da6f9896c4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:23:58.2740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HuAd00QCclEWrqFeV0S8ZAthZfNRYl7HxWdCaNL1ftb0e3fe3lohgSzKEPBMiugxvpETOnVQogW8ZxlZKB8x5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds PTP support for Spectrum-{2,3,4} switch ASICs. They
all act largely the same with respect to PTP except for a workaround
implemented for Spectrum-{2,3} in patch #6.

Spectrum-2 and newer ASICs essentially implement a transparent clock
between all the switch ports, including the CPU port. The hardware will
generate the UTC time stamp for transmitted / received packets at the
CPU port, but will compensate for forwarding delays in the ASIC by
adjusting the correction field in the PTP header (for PTP events) at the
ingress and egress ports.

Specifically, the hardware will subtract the current time stamp from the
correction field at the ingress port and will add the current time stamp
to the correction field at the egress port. For the purpose of an
ordinary or boundary clock (this patchset), the correction field will
always be adjusted between the CPU port and one of the front panel
ports, but never between two front panel ports.

Patchset overview:

Patch #1 extracts a helper to configure traps for PTP packets (event and
general messages). The helper is shared between all Spectrum
generations.

Patch #2 transitions Spectrum-2 and newer ASICs to use a different
format of Tx completions that includes the UTC time stamp of transmitted
packets.

Patch #3 adds basic initialization required for Spectrum-2 PTP support.
It mainly invokes the helper from patch #1.

Patch #4 adds helpers to read the UTC time (seconds and nanoseconds)
from the device over memory-mapped I/O instead of going through firmware
which is slower and therefore inaccurate. The helpers will be used to
implement various PHC operations (e.g., gettimex64) and to construct the
full UTC time stamp from the truncated one reported over Tx / Rx
completions.

Patch #5 implements the various PHC operations.

Patch #6 implements the previously described workaround for
Spectrum-{2,3}.

Patch #7 adds the ability to report a hardware time stamp for a received
/ transmitted packet based off the associated Rx / Tx completion that
includes a truncated UTC time stamp.

Patches #8 and #9 implement support for the SIOCGHWTSTAMP /
SIOCSHWTSTAMP ioctls and the get_ts_info ethtool callback, respectively.

Amit Cohen (1):
  mlxsw: spectrum_ptp: Add helper functions to configure PTP traps

Danielle Ratson (8):
  mlxsw: Support CQEv2 for SDQ in Spectrum-2 and newer ASICs
  mlxsw: spectrum_ptp: Add PTP initialization / finalization for
    Spectrum-2
  mlxsw: Query UTC sec and nsec PCI offsets and values
  mlxsw: spectrum_ptp: Add implementation for physical hardware clock
    operations
  mlxsw: Send PTP packets as data packets to overcome a limitation
  mlxsw: spectrum: Support time stamping on Spectrum-2
  mlxsw: spectrum_ptp: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls
  mlxsw: spectrum: Support ethtool 'get_ts_info' callback in Spectrum-2

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  18 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  14 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  64 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 118 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  10 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 576 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  60 +-
 7 files changed, 820 insertions(+), 40 deletions(-)

-- 
2.36.1

