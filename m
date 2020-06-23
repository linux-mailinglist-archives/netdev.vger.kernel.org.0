Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211E7204F72
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbgFWKo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:44:56 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:11647
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732135AbgFWKoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9FE0pumW1o2LlgXs9MtOcUuXIPFm2XCh3dvEwB89yDnqNHSkY6QUlqFbxChFmkz6/eGzjVbg11i4M0EQV/mq/UB8bViUhGlvOUJIIqCLzHqQ8c+ATmNcsl2oREBx818V5buYdQgZIYiiD9tHDhWK5bHjBtVwiJ2vTQhQ32QCd7nUGhFBGMBvqpqW3LXob1OEdzM0vXgyFJzNCzdXqVx5WZkma3ZuSYlwe9FkUSHy3k9U9d5k7Ws3qcBJ0/BLPzB1b24wy9ho/kaXhcyG6oRXpTMK6C09kTzDn4BeUxqstquyv0kDSXxYzKekyXEFdpxaOCb+BBBTL/RrV/H6U/fDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8MtfmEbwVql0/RVnvPhatM4hvDvg9Wm+z+p6GBIRpM=;
 b=JzgOrfU+xUEOqOVXFCAq/QWoEYQyAKQpN6nWpLdCUpStX6qiO/dNhMT3Z9rejKaMzf19P7PlKKrL0TFVteIZutQvL2jIfisJRI9v2ktN7/DsoK4HRXpLtH5KtRraXxxRKf+VfbbsytESNrXTi9YS2CrNJdBgFvkuPTN6qKYmh0M5MPR2tKc3lQrNeng20kDW4TuZaZBVwYY0rBIBHP9suwOjnWe4H+ML3A7kvYS/7oi8k69Lw0EMXCNGHRiXplyqtunZuWB6Zvb3PCXlpC3gF/T6dKNiKM5fwA3Mg/63+v4hVK11XxgWMH7oLPxB3g8AmDuG3hLt7dv8ouvy+QN2TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8MtfmEbwVql0/RVnvPhatM4hvDvg9Wm+z+p6GBIRpM=;
 b=jJavzAsirnpjXanthriSMCecgTNbi2C5ljOCq4fmIHW4tdeMkEfAZlYxFp2VIq+PdySDr4bjZ7O/ETbovtu7l30d0BDz4lnSMVjo7LIAI4oWrWSrq16ZjG7hGEqz0KkCaN9qZPv0h8Z8YaZONm8cPc61Fp+a5L9Oi3xoEbXb8yY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6034.eurprd05.prod.outlook.com (2603:10a6:208:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 10:44:51 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:44:51 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 0/4] devlink: Support get,set mac address of a port function
Date:   Tue, 23 Jun 2020 10:44:21 +0000
Message-Id: <20200623104425.2324-1-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0201CA0035.namprd02.prod.outlook.com (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:44:50 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a4e8052-8a90-43b7-1ab7-08d81762750c
X-MS-TrafficTypeDiagnostic: AM0PR05MB6034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB60346107985B85B184F738EDD1940@AM0PR05MB6034.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZLFLWSxOYwDBzaAi8KJIK3g5eukkufTPvzSQXfm3YWcqMeFcrgMCZ0ns+61QIwjoo0HSZBFXV7gkM0Rzh5AwZAPB5qglDKivWjpw7wt8nwMKm7/QlzDO+amMr5rii1ZO1xoscpxO6km+IBamtAPP0KlbBiNQGPP1/KHUYdhMtotugc5FrdTYPQBpczQT7quBU6xU5J0e7bktb/FQNlBw0z3ipv3ezNHlL7+LQEmEbEb1rG5RxAPvEZD+f7a+YUmV6Loic2ZKmuAtThoXfaLZOsyQQspzNbiHx6AchxLgnh82Fgr5KNQdC1i+dKXmq+9PxP60vsBQOSpKNug73Vr4g1jPU8PSEg1/ArZqgTeQ11deRAOZVxHicwPA/+4iRTmWDtjeflYnhgYwP7MNm82U1IWiAapXqt4Zf1zpNQIvdgdWtXSLTKYYwo1Ie1fm34EggleS2R3xt5qjby0EheG0WxaSHffnnNZQllhbjMJ0XU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(5660300002)(66556008)(66946007)(66476007)(966005)(1076003)(478600001)(6666004)(316002)(16526019)(186003)(26005)(8676002)(52116002)(6506007)(107886003)(83380400001)(6512007)(86362001)(8936002)(4326008)(956004)(2616005)(6486002)(36756003)(6916009)(2906002)(142933001)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cDcwcTiLJ7eSZoIxMdCMlgePUgsrugZhks1abisPW27adq+iKRYf+C5zpgztyGezpFw2rQj5H/JIArjiMr0gxg8MNuZFFK9s6mWT1W8eFefe44XljNZcwd6tKaEI72G+L4NMgF7NYQSz78S6Sg7XIKyFtZRH+lTVoN5F4bA2AEMESbYuzOv7yN5KshKClYyb48W3X++iaYDaK+ACQ7+N5WVhicH5OEFizajZi4k03FQC6r4p3c9Ss137WNyyHFfdhpNIiFMb94Dci7p2A9FQ3sG4UHEzXTIwy2M/sHGxcRrT+gtcSLt6czBUQdqYPP96xA0eWN96YQaqiTS5Ay5neTnzmvPWIWsH2tnbZXg/+F9uGdZS5ILHgD3kBVkD28xm7WI/be0EVCla129EcW4GWeb9IACC0F+aAqNuz44hozsQ6g+uUASzJ/D1oaPKEM0gWslbq8g1CWEcHs12/3RVqrc0N9SLiVXwHZc9u2GNZAI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4e8052-8a90-43b7-1ab7-08d81762750c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:44:51.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GH/L7hM276hN+ZYMMrrPmq0H9tcYXT0rK7PNbYFuMLoUOvDUbSjI5vb3xWqQ5vip/Ry70YKZiYFdRfrGxOX3xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ip link set dev <pfndev> vf <vf_num> <param> <value> has
few below limitations.

1. Command is limited to set VF parameters only.
It cannot set the default MAC address for the PCI PF.

2. It can be set only on system where PCI SR-IOV is supported.
In smartnic based system, eswitch of a NIC resides on a different
embedded cpu which has the VF and PF representors for the SR-IOV
support on a host system in which this smartnic is plugged-in.

3. It cannot setup the function attributes of sub-function described
in detail in comprehensive RFC [1] and [2].

This series covers the first small part to let user query and set MAC
address (hardware address) of a PCI PF/VF which is represented by
devlink port.

Patch summary:
Patch-1 Sync kernel header
Patch-2 Move devlink port code at start to reuse
Patch-3 Extends port dump command to query additional port function
attribute(s)
Patch-4 Enables user to set port function hardware address

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
[2] https://marc.info/?l=linux-netdev&m=158555928517777&w=2

Parav Pandit (4):
  Update kernel headers
  devlink: Move devlink port code at start to reuse
  devlink: Support querying hardware address of port function
  devlink: Support setting port function hardware address

 devlink/devlink.c            | 378 ++++++++++++++++++++++++-----------
 include/uapi/linux/devlink.h |  12 ++
 2 files changed, 269 insertions(+), 121 deletions(-)

-- 
2.25.4

