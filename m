Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6257F3E4
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiGXIFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbiGXIFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FC5BBC
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rt3HvhKW/WP4excXHNkQxCsXPxsmNbcLTJdK3RC3xIxhwK49kFBB6YA7Vxm13Z2E8ZJTh41ehDy0vnxekGwUinRDP6/Gux1vKQJiO9M9xRCBmW5Yih/46mey1G5LgpIOIkoN8z29oK3lRSKjh3EU+6qE0zlvUGuHrA6njeKISzvsuohYrDyzsezvDmSrGbMMJE5W86cJqR/opmrLC3EBNb3N6wDOTnKxgWO2UP8rAsAYXHP7tDhDo7UEcxEaxriIDFORwJrIjsI0+x8jM8n684xmG2T55TfIBla96WS2b1o50cTDmIKFsThfFUmsBpMEYnnu3bQjMJaE8RlXRM2cMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FOUbNoqBigw4lTINdg8OPtBLdDIGkRll8r9EmK6aipw=;
 b=YVCxIxi4f6t+VpMFPXpmUfoLLrlQ9vu+LmTwWquhidwOEy+UOTKLYRLRpBK2NXzJV4sj43ZPVgFoaJxS2fgW+Zo+39fzy/PISEK3hKX+6H9x/yJ6C9ObhQfI0zTs/J/yKIi1Ko38UNsHIzdEf7hdFzlbbZkaRfOZPSZXdeJVXg/K0vk2lh+Eya8MzlV7E2ZEYszAJ6keKQoBkKB/p38Fe8DKGiMzP/HfrlhbYX4I/+f8WsKG6TcnidNXOqqjrQAw7YI5P/kS8qPG8SOaACPRV5k0pVPXjsdPhD6o806Ixy68dOP7p4WKQbaDpqcAMnEbtIaR76ixnZo1/yQIUiPGSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOUbNoqBigw4lTINdg8OPtBLdDIGkRll8r9EmK6aipw=;
 b=r4/N2PAtznT+4ksUhkE56Z69HCNMer9D1kQ5xavb2owJiKPVIzL/MGmAIKQU7ydTgRhtS+iqZg50I6LWUJu6k8yl3/ZNoxU9gSypq5ZwvZtv0NWWRpvMbwr/CmyDOL6a+0rdvtZmhkoF1BCgp+NWejSM3FhOr3x0oiE/c+Rbdmhm701p64RuDHeqChENMwZWAAKa95OB1yuex5tC94XputcgtW7faj9eMW12XeLzDY+HLN0NDWxqi6y4DpT1EKe0MxPcS5NcxW4m/vz9OSe6Spxj5W0PWcJpPtPMVW7dKVarC+xwOcuwyG7RA17TauH53aN2i/Sd8729aWTCVB17UA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:05:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/15] mlxsw: resources: Add resource identifier for maximum number of FIDs
Date:   Sun, 24 Jul 2022 11:03:22 +0300
Message-Id: <20220724080329.2613617-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfedcab0-1cb2-42f1-e4ba-08da6d4b37ed
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wmaj0Z1sBsXPde1V9zFhRB7kFkmlGcD5sLYJ4HdlNEu/D3sMPzIjgBguo2k0Kv1iCMaHlfC2Qi57yxziwTvTa9MnGmqtM15yC/7FzpQ9yS1u+s4/GSJ3zUVJNjldi8TGGwrsI6co2LRRKoM1BoHoNSNbuT6IAikoBRzrqh11g2IPZIQjwsaqpcnQY8GnvmdKgG5fMf5hm6F2BMvQbBesoSue7m/4XUCYQjkiB+/dK7JIDi32ZtbYI7G/j89sAEfTvOjTfaJ0JbgwDbxPSRFyvbgdiB+XGyjZT1Bwf/qAi8ZhaC9hRx/YB5JEiCp+1nCnU9ebkqwSvBxAzNEihrYRjKxGh0kJ+w7lWoNHO97OVLaGC2G8gyLp6KQruftKON1zRRHfwKLM+WOT2MGyg6uC1UpptAR8cJi4rQ2nnZYAm/onxPv5FH0FMN/IjzdQ0q771oPTpi0a053INfzJTigJW70CibZJ2WQpo3TA9+ocOW4WLhLdAvr/3RR0DibtRYuwN3aKDAAEo2wcVj5BMylK4FL5N4/d18ErQY1dc68ecIZqsxOxT2652442Yd33xiWdIxEQaWtx+7ahrGiXMX41ApmXQ7kKfpi3N0MDCq1EWoAjZSqo3Gd8EivhT79vlYmrXdq8VqP0iO/bXhHnmmUJI5uRnjVAR8KGEdKtH6oK7DGCaITescXNrQ9nCw0d4aGQroSSiZMA3P7ID2JK+v5SStfMa4i5sn74LzqydkirAjb2Xgz9s4PFNzNACNu6qNr+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(66574015)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rE7/EfSUbtdXiuRWzBvgy+dsd4YRFV5R76jDtaWWcXoKyDpFE98l1lNw0F6l?=
 =?us-ascii?Q?OOMZbHi2p+jsgqBRUnNRUf72haYXbhSsbB5vkl9VRt/ma9pnxgQVW2wjzjAy?=
 =?us-ascii?Q?I2+QTiH0llNRkSZ6e67fi1/rj6Yclrfv/n6EhUhRPijjKE2OqZe5pAL+pNlq?=
 =?us-ascii?Q?/ufqmQ4yVMu54Sw7tZH0HHfoEMkKP23oVPnf69vhagEXCnLpqE4uQac59DdT?=
 =?us-ascii?Q?5TGhAcUIgswP8IXrn01VTnGvCYGZk4OtiTI1kWswz8Zq2P9yTKvc7he6fqZK?=
 =?us-ascii?Q?fjVR+5SHjwvpJHQsDtT4UTHHPQphhK1qwOa8Y5ekGfB/DFmZMm3Nech+M3/9?=
 =?us-ascii?Q?N0IPobPaKaId95JQ8N3hSOiVJiBXrCNKD+mKW7imxGb/2oAjJTZ7f6xuwkz/?=
 =?us-ascii?Q?TIjdCnhlBYI5pLdJfuiq0IG52WLJiFqvYHrQw3g3rueGrcMATz/qBSWA2ybm?=
 =?us-ascii?Q?FFCLQgV1qhYxzPIHXpsSi65VoDnqmK1sut4mY50z7FaC6YMf/Mhb1AshlXFv?=
 =?us-ascii?Q?sQfCJi6Yatl3XNhZks7w2m3D2qMdmTE2mJaXgUv4O5g9mSXW2D4mrSwWWyED?=
 =?us-ascii?Q?S/KNf7ujxa6Atd2evRfPZ9R7Wk1cWn5aWtyjlTu/PNqyeqcNtBFbJ0D7o0h/?=
 =?us-ascii?Q?GV3PXckbsLlbRvdLX3nEpF1o7knrqQ2Wu2tbAJL2XWRCkJY1EsJD1WVx5dd/?=
 =?us-ascii?Q?iC9VpeRzGyRsW/C1bjQyUyceH0JgvEQazl5e/S5SkFzF7ratEPkhVj7GyfZo?=
 =?us-ascii?Q?/ktrmVPCaCXCbztjDQQRyuDIu8jveBOgiqGFr/gMLuVMt85ZCI9vs4qTBDOf?=
 =?us-ascii?Q?WqWY4EzrmBqzXgjZ9H/m9LxgD0xXEQc9zTsqDupMae/gEp9A6n8EenrBAMXj?=
 =?us-ascii?Q?eLF5Ss4kNphIO/iZsU929WJdznhsQjjAEATxrhbpy68gkHLcE2SWmloINntp?=
 =?us-ascii?Q?3N82cOCMiNKly6QvN7pqW46VjifVR9ZtXHrQaCGR5PuxoaFml/IKJQ1eNtGw?=
 =?us-ascii?Q?ROrzHCIuZZeoRGwSVbGg+1YCZN6KKNsPQr5644auE0XcZrGePqjMcSatQawX?=
 =?us-ascii?Q?q8JM7iBWCBO8DyvwKzQO4+1Yf6JIZtEuUIN8bzNUnntHrErnYXnZAc3LQRwC?=
 =?us-ascii?Q?IOG7qviXvxt1b7DEicNxp+ioKsDdUd+11kXx5CtoWJ+jzqpw6bncRES8ctho?=
 =?us-ascii?Q?Lcnm1/swkgokyRA1iu+wLLTKf/2zamhZRyBddkVQPkwhkwyauwLR5KM16RRq?=
 =?us-ascii?Q?PwXXZygFZHA3fiPCPh/sxpq4S9l0vI5G20KvLIVyboTsKa7/6IHhF5Lj0Xk+?=
 =?us-ascii?Q?H4ktSCJgWSRAdLSX/mWnj0/5ii+SyNpmAW07T1S8FH9m3LLjlMEZbQAgjbKB?=
 =?us-ascii?Q?c2J1Uh0X84g0o1M3lQjf23WMyODnu+y3fm+W7Oh1nxq4r190RuwrQUGHew3K?=
 =?us-ascii?Q?jbaSnIcUvdwsUUMwkFDLpsSdXKtkDyd/oGLvfIPArHSdTgfHZ1tDooFvgUpP?=
 =?us-ascii?Q?4I+QspKtUnbwrNSat1/BfYxkuHnDnW+YeVASehwu/hIFy1KuNzynlzmFuxS+?=
 =?us-ascii?Q?almCVVzk78LcVapPt4dv6gkPoTa89AK5CYmLOJuK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfedcab0-1cb2-42f1-e4ba-08da6d4b37ed
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:05.5596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CT8IRlzqyvQVORkYcqQuJ462WCHTWdIXjFHsLI+dtbQjTxdfadsQLW2tF7ivDmcgMP91q0HRmoWKiUKSokvJew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add a resource identifier for maximum number of FIDs so that it could be
later used to query the information from firmware.

In Spectrum-2 and Spectrum-3, the correction field of PTP packets which are
sent as control packets is not updated at egress port. To overcome this
limitation, some packets will be sent as data packets. The header should
include FID, which is supposed to be 'Max FID + port - 1'. As preparation,
add the required resource, to be able to query the value from firmware
later.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index 826e47fb4586..19ae0d1c74a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -24,6 +24,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_COUNTER_SIZE_PACKETS_BYTES,
 	MLXSW_RES_ID_COUNTER_SIZE_ROUTER_BASIC,
 	MLXSW_RES_ID_MAX_SYSTEM_PORT,
+	MLXSW_RES_ID_FID,
 	MLXSW_RES_ID_MAX_LAG,
 	MLXSW_RES_ID_MAX_LAG_MEMBERS,
 	MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER,
@@ -83,6 +84,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_COUNTER_SIZE_PACKETS_BYTES] = 0x2443,
 	[MLXSW_RES_ID_COUNTER_SIZE_ROUTER_BASIC] = 0x2449,
 	[MLXSW_RES_ID_MAX_SYSTEM_PORT] = 0x2502,
+	[MLXSW_RES_ID_FID] = 0x2512,
 	[MLXSW_RES_ID_MAX_LAG] = 0x2520,
 	[MLXSW_RES_ID_MAX_LAG_MEMBERS] = 0x2521,
 	[MLXSW_RES_ID_GUARANTEED_SHARED_BUFFER] = 0x2805,	/* Bytes */
-- 
2.36.1

