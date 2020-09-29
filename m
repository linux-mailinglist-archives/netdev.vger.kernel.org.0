Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDCE27C1FC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgI2KKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:10:46 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728129AbgI2KKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:10:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuA/210pdEUBGEO4j/9GfMz27SyZyvLUTqnQ+mgyuPd9/9hhnfXRN+ieSm5cNT2/KsNDgWNzEjr9OLEGI60UDSOXNwiGVpk0Cy3AUi/XxlK0hqrqGD2OFeSWAck7awQRV+yCB6AlbSts2bfS+BnFBUVNBtysk1nKzmuPraU8wOAEAv2F3xHhrGV0aEfjDPOCpcHhmUQwj/VklAzAjMWCvfsPIL2slxMEHsTK7C3NSWX0n4YnjNQsyqOBjaqS1f6k9+ld/zh1B8ZLOakIRJns1p7WFNk7fh4K2wlGc0dhlZo/VZTNP4e5tzefrmnxmSWDEuPXuKjM5rfjHsxXaU6Evg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCMyXu0sNw5Ay0lufkqFfNwyGRntdvjhC1UzBZdF02U=;
 b=RZe6o6bJNzxLK2Mtrg34ZYgsGMh/OHtvjgZTqHAaoXwX7o9HF0Lot/VEM9nGzAcvAEQfFUdr64v6g/01hcnLC3vwc3JWv3T0rT4aC2tvso/zPMhE9cMAXLSzSbz7MriVZEYTiZDIzvdlsOHVdOrl4HQeB6dMB6mVgUAN/E6lH1bZfed4Puv24ZjdnyZLlkHEM2KTkbGEeuVwEvSPMRjVBExvzcjHK7e9hKDozGSvm3kc5vuS33ROemnpkJkkwEXz51AXvkbYFVLeyNnPl3VUufi8xdsiGkEdrUjtY0nv2ZzlW8+E+3t0CK338nKGUGg0sWIx0I9ZAJJfjvjCwAw0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCMyXu0sNw5Ay0lufkqFfNwyGRntdvjhC1UzBZdF02U=;
 b=aUWGvvsLxnu+w7K+XG6z6qzSPon5AmIJ+9uOiv1M4pz3S/BCp75gZroQ4Wf2T22LLFHSN9xT+hsJJavckTRq3tGKA8dfNm0l4mdfDuc4p5xMylQ6YSfnHIiWPsQJ+wYjX8vlifIyB1OShCsPosui8Xs8bLwYcocKjLnMy864Fc0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 00/21] Offload tc-flower to mscc_ocelot switch using VCAP chains
Date:   Tue, 29 Sep 2020 13:09:55 +0300
Message-Id: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b91e910-53c6-42e4-63b7-08d8645fe75d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB529580E8C576F6DF5DABB397E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBnfoF8N5nIuuVBPCi2f35InZ178rDenDAO8UMjKAle9Uow7zXsgAFo9vucKvF5RMsajDjVdQSzAzgMJtdyP0RdGA5If5Nv1eQvmub2KCLf3Rn7ya2oWU0Xgf1sHiXNmJxLeRIvQKkolx5XzmUVAC3J44f06WSrDuUzisIXJ40hnRusawSxlXIr1shZdryUtTqBX1u58/G04FJIEyF8Zh6nUQaxGTN8qCGHhnP0MmNT/y1eQKKO6Bf4m/jVjoFsNcDkg762KQ8tKggEIDDfY3H4BjwVlp8uwtqs7BLDccJxim18fMvHsYEJVSw63rGtn5trg72ug3FWD6LHqhsZgLU8z+DJWWNduHBlOsL24wQAuOOiBcdj9Bnca1BfoxxZS61g6ylORcqfg4VZapu1vlr/v2JN7fzI8Z1aTN4gQvcTID764cDvZbCUCouuhr5v3fsxe2UE+BkPn94z42Ueg6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(66946007)(4326008)(8936002)(966005)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Gd+I/GPgPULl/aSbOOaHSKVZtLXIfOvOgdgZQpqZzT9DNUiqy20H+u3aw7QoFeUbUPbFi7GUPq4tWXsoRGm+9sA5qLnGQAi5Mmf6wCyzii52epFzYnRS58gCNJZawWrotx0yBkOuttD34wSnw6B3gI6LmUcrgOiGyqL+2Jb9nk/XERDaUOVxmzf/Vhnu3JNJYpV6xML6Yk2t4SkUs3qFZrgFLIhutsUSND07CaaP6u2BM7m5Y9Uj+jL0LV+v3JTvnnIW2CiSylGcVW+8kMHSXMZeRRRu6O1aC6lEOZ+k+tLz69Spn4iQjuf5RlvUhM19MO5hPadX7svx1+efIBjgZGytHfGfHISH2cwrfVwU8txyIvUmjiswG+z4eCQZUm+TrTurAeqNAZmMThhKhzcWvcOBhPouhCDmvBtS/z/7/aWIXC4ws6mMbL/E2fADZUNnDUmq8WGCS62QgNCTDe6Oml1WrUKYqhbsgQ8ro/7MP9ylJUSb8Bu+yGE255ZR8Gj3n1RSyYZbIKjOMnmgF77kauAhuvmM1L65DHTks097kfH2OtQPjbFgQhxMD+2PdcgfnBHcIdRvNs7siz44XFdB4FIHLqHv+RLwRPkd3O1gqsRmd4F46AD9s05bMjNju6hFaZWZhGPP3lzYeYqWbdjKJA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b91e910-53c6-42e4-63b7-08d8645fe75d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:34.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WKLR6DHQAbtR6Er/2ByX/wxTKdeO2a0vEM4jTYSf0agJRvCmKvStmKH3DuEAe7g1paaSveWN6jhunmVbQGV2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to add more comprehensive support for flow
offloading in the mscc_ocelot library and switch drivers.

The design (with chains) is the result of this discussion:
https://lkml.org/lkml/2020/6/2/203

Still posting as RFC because there might still be some bugs and missing
checks, and I would not like this to get merged before hearing some
feedback.

I have tested it on Seville VSC9953 and Felix VSC9959, but it should
also work on Ocelot-1 VSC7514.

Vladimir Oltean (17):
  net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
  net: mscc: ocelot: generalize existing code for VCAP
  net: mscc: ocelot: auto-detect packet buffer size and number of frame
    references
  net: mscc: ocelot: automatically detect VCAP IS2 constants
  net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and
    target
  net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and
    target
  net: mscc: ocelot: auto-detect VCAP ES0 and IS1 parameters
  net: mscc: ocelot: parse flower action before key
  net: mscc: ocelot: offload multiple tc-flower actions in same rule
  net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id
    function
  net: mscc: ocelot: look up the filters in flower_stats() and
    flower_destroy()
  net: mscc: ocelot: introduce conversion helpers between port and
    netdev
  net: mscc: ocelot: create TCAM skeleton from tc filter chains
  net: mscc: ocelot: only install TCAM entries into a specific lookup
    and PAG
  net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
  net: mscc: ocelot: offload redirect action to VCAP IS2
  selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads

Xiaoliang Yang (4):
  net: mscc: ocelot: return error if VCAP filter is not found
  net: mscc: ocelot: change vcap to be compatible with full and quad
    entry
  net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP
    IS1
  net: mscc: ocelot: offload egress VLAN rewriting to VCAP ES0

 MAINTAINERS                                   |   1 +
 arch/mips/boot/dts/mscc/ocelot.dtsi           |   4 +-
 drivers/net/dsa/ocelot/felix.c                |  25 +-
 drivers/net/dsa/ocelot/felix.h                |   8 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 196 ++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 196 ++++-
 drivers/net/ethernet/mscc/ocelot.c            | 103 ++-
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_flower.c     | 559 +++++++++++++-
 drivers/net/ethernet/mscc/ocelot_io.c         |  17 +
 drivers/net/ethernet/mscc/ocelot_net.c        |  30 +
 drivers/net/ethernet/mscc/ocelot_s2.h         |  64 --
 drivers/net/ethernet/mscc/ocelot_vcap.c       | 713 ++++++++++++------
 drivers/net/ethernet/mscc/ocelot_vcap.h       |  98 ++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 187 ++++-
 include/soc/mscc/ocelot.h                     |  59 +-
 include/soc/mscc/ocelot_qsys.h                |   3 +
 include/soc/mscc/ocelot_vcap.h                | 200 ++++-
 .../drivers/net/ocelot/test_tc_chains.sh      | 179 +++++
 19 files changed, 2193 insertions(+), 451 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/test_tc_chains.sh

-- 
2.25.1

