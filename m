Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD56619EA2
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiKDRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiKDRZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:25:06 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852CD419B8;
        Fri,  4 Nov 2022 10:24:32 -0700 (PDT)
Received: from 104.47.11.171_.trendmicro.com (unknown [172.21.188.236])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 299A6100004E7;
        Fri,  4 Nov 2022 17:24:31 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667582670.353000
X-TM-MAIL-UUID: 216e3a40-45d7-4a73-aceb-002fc6564422
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.171])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 5682A10000851;
        Fri,  4 Nov 2022 17:24:30 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Psi5o4C3QTw4+N2Xb/qY1wNTsxqEGfhRvSLrahqOdEF+SSGwX9RhwQZ79WDCoKBPkFOngVRwatPzPPPxzykBJYbwuZBSRgdEx+MldmoK5BInPv1SnEyMoZgCRTJI7n2DJ9zMgduyyN8ZYarliHE5SQtHDNEoEJqb5YWdUEuT5PAbgyGIj1ysObj7uhexBmXIHR1Mv4ei0UUwf+zQle5Eo0tBYWnEIEqZGKwEPGKI88sO/N1QRoF09P5qxqdDi9OXbWBKKWJmetQ7r2zu7DtBweB1JEDsDcpdnVyWMTJ5sIjLWzP/g4QMsDiJr8KD4wM1AjSkOCb99QQyvwGpY3wwdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLfiFPMSrZ6AdGksfQmuk/KFFC6GHPjs8XFpTXkIGZI=;
 b=Ba6vGV0dKTG2FGIDi1Ng6Ckqz2WvsZCroawICei8nNYlPNj/ANPvhv25xgqmQU8dlztVuy6qt3gTQm5BZykWAMa6DcQu84gi4nCajfsxdmbo7Yc5ro8GIv3Sq6YLqWfDZs4zfcVyAqB1s6nLDg+NXV81Hbye0CfrdOqn6IzcR53Pa4tRgyqCh0/7JRayxx3FMN7HyRXeth1EvbED+iku5I0qSqj/Kq5HqlZ+i4DB2K2W+XAaLsEtYUT0jv/M+4kSLLhLgBHM/G8WU0nDVVamFEbXsH7rGGkV4nMZgzGdfxAZQfHQbP43FrdrP36zR2aMdPABVY+maxuK6eEdwZcscA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.66.60.4) smtp.rcpttodomain=davemloft.net smtp.mailfrom=opensynergy.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=opensynergy.com;
 dkim=none (message not signed); arc=none
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.66.60.4)
 smtp.mailfrom=opensynergy.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=opensynergy.com;
Received-SPF: Pass (protection.outlook.com: domain of opensynergy.com
 designates 217.66.60.4 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.66.60.4; helo=SR-MAIL-03.open-synergy.com; pr=C
From:   Harald Mommer <Harald.Mommer@opensynergy.com>
To:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
Subject: [RFC PATCH v2 0/2] can: virtio: virtio-can driver
Date:   Fri,  4 Nov 2022 18:24:19 +0100
Message-Id: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
X-Mailer: git-send-email 2.17.1
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6EUR05FT046:EE_|BEZP281MB3121:EE_
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: fe90f9cd-945e-4f7c-d30c-08dabe896d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kQ+1JmURlfqDYDL3ZsexZ3cqOCyDolwMTqiLN+8TdHV1g455esyVqJEcyrhvPqtG8dcmyZbU5FyPxT5LU8iechBV171ZUMmrqgK9SAczsa+bLK0hYTyPraYS7A0BjzYdWEfZMLpH4Xs/NWkE6aDlhCOJFBk62PVGMQOLcclIGLEKOECpt+MrcvfcUkNtc2U+90srSvghk0sNwqbxxG6EPeX9WyvlVrESVbHNIzPtiAmJSzS7eksfDb2d0YclDD0kiRgYxS5s8YEtaxwJpNP+g+kT6WqybCdBLJLsp5I7P2MoQuT2HjXt5VsEmO8yMrj99Ba200VpwCwicRnH4DmTc34sMDcOfbnr6EeCe3F6YW5I9L8/0zWSiTrwwALdBt3ogrwAIqkgvVK4wqnzdGcDlZIrVUuZa9zz60AC8qPhPd3aWmV0vOPFP93P3A5JOBXyycjD/XPXhXE2HmitDkgTcF+QIl93zaiAgIu5E1cWAM5vBeqZ+hc0D6HeYnnJO8pqcUHCzd3rc24BXNw8l8sxNuBb/KSKEYv/unAkMskPUBVhZSXOEZGm1wQVDMNwD+vlgVRAPHmMqvnqS1ZDXBEzHiOTS8iLH34I4TzuWLC8cQFYHprh2nOg0YC6CyZtz+brtL+ObYvOCJklq8QIfKhY8uHktnVHR0X2nq0c3U9Y00GoRVbzoLZuMum8ba2m4ZvXEG2rxMkr9IuTQffaE1cD/pB2Zyg1tWMCrXzImbFrpOx2eDMSo/XWzpwn9XpY8f3OXUOcyLLqqWrRVl/d9mivlr9uCGkr60API+mrFqiT4LST3igspeYH4kmdT7Mld9tlY64vaadoopfh82yfxO38A==
X-Forefront-Antispam-Report: CIP:217.66.60.4;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SR-MAIL-03.open-synergy.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(396003)(376002)(39840400004)(136003)(346002)(451199015)(36840700001)(46966006)(82310400005)(42186006)(54906003)(316002)(40480700001)(81166007)(83380400001)(966005)(36756003)(70586007)(2906002)(70206006)(478600001)(5660300002)(8936002)(41300700001)(7416002)(4326008)(8676002)(2616005)(26005)(336012)(186003)(47076005)(1076003)(36860700001)(86362001)(107886003)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 17:24:27.6230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe90f9cd-945e-4f7c-d30c-08dabe896d20
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=800fae25-9b1b-4edc-993d-c939c4e84a64;Ip=[217.66.60.4];Helo=[SR-MAIL-03.open-synergy.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT046.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB3121
X-TM-AS-ERS: 104.47.11.171-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27244.001
X-TMASE-Result: 10--9.251200-4.000000
X-TMASE-MatchedRID: 0a+qS+HYqZUXsn05+3ENErPx3rO+jk2QSl7Mg8DR4I9ScXQMxepe+24+
        gA+i9D2DF40HISqSK6o1JRT1LSWO9ipe4ofkluPsqhcdnP91eXGWrxIsNZE6h9GenxDH6mnrXyU
        tRCqrdXJIC/625M48HzkjhB+PG6yx6goM8gKRlUf3dt27LH8hnErh/hn4JkBneGHkpR2WBaIXn0
        fuBWX+3fqHst1NzlK+bG2wDyGdkFGLNCjacuFsFZ4CIKY/Hg3AV8JCXvLn9fGvXSmSdlcYmogEL
        0sGCK9rXWPmaFoiyJsgBwKKRHe+rz9NEyPqSyoS5AiJOm0jze9oQ2PntXcZBFs///8m7oNWazzr
        6w4LafQ=
X-TMASE-XGENCLOUD: 03c815d7-b8e0-450d-a081-81479b0fcaa3-0-0-200-0
X-TM-Deliver-Signature: 0AC12DC3DAFC739BF20D0563155B8413
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667582671;
        bh=W6bZJC89dIKsoI9nr3SSvvi2cf6xqkdJmxJGN5WxRos=; l=1294;
        h=From:To:Date;
        b=zBRB+dM3yj28lpubYGEkHIny5HLBC4ToYo1o5Fy1No2q6m7HqxOK+f/8z3Vdx+UOR
         MS6QWDTj+s6JR5fepyYwUN1c2KFQqsXQZhLS2KwKd5gaTdwxRe8XNz5WriVC2nWNc9
         5pM65JPmN9dCiGuxmP+FIa3oKUP+V88ae6KpjS+mcl/kDp+ZZDDpH2w1a8KeZlh8k/
         1jnNpM5cueGiB9O465jQqlP/GRKUZmxVqdQUOeWqkxxy5UokJqIRk80tM1puQQGqbj
         gdX5G7LZXIo+X4i9Ip72jFO7YrigrgGIfO6CYNkdmIpZ9ih68soZBSMgxDQ1r49BT9
         XpAkFITBqorfQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is a new virtio-can driver. 

The proposed addition to the virtio specification which should match
this driver has been sent 25-Aug-2022 and can be found here:

https://lore.kernel.org/all/20220825133410.18367-1-harald.mommer@opensynergy.com/

(Got no comments on the updated specification proposal now.)

The RFC driver version has been sent 25-Aug-2022 and can be found here:

https://lore.kernel.org/all/20220825134449.18803-1-harald.mommer@opensynergy.com/

- Small update to be compilable against newest kernel

  - netif_napi_add() prototype change

- Address the review comments got from Arnd Bergmann, Oliver Hartkopp,
  Marc Kleine-Budde:

  - Remove virtio_can_hexdump()
  - Use completion instead of polling
  - Restructure usage of spinlock in virtio_can_start_xmit()
  - Save kicks in virtio_can_start_xmit()
  - Minimize usage of BUG_ON()
  - Make driver less noisy
  - Move register_virtio_candev() down in code
  - Remove unwanted MISRA habits used to in a former life
  - Treat bitmasks as bitmasks
  - Remove excessive usage of netdev_warn() silently sanitizing
  - Fix RTR frame handling with payload != 0
  - Work through checkpatch problems
  - Clarify license
  - Remove some pointless leftover comments

Regards
Harald
