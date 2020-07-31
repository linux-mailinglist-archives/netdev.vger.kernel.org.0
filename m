Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37526234440
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbgGaKt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:49:57 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:53202
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729141AbgGaKt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:49:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6vt4woiMUwNiv1EQvIC2MlMkEEAbIucbMkyKPfP40N+xlksI5+LEALqXVvu2czEWQUo4JQFpBpfip8nt5yzGkPIJ8Cxw0xY0EW4KgsHcBvM+5zdci6/CYh3DjvcBuc0v9BCPWibY1VvrWDdvI7PRkCl9txeEiiFG3Ub1m125oPV0oxbNhrxW/8GDfNoKTtThLzqSHGOCuOU0RH0y8eQZljIFuGpwPSOanM4TkZmLvKu9ItdmT9hSgbLBZ3br/ou7AxaMgDQbSxuJz+JBHscCtNJN2n2TjBt6NYfF+crhpdN/0LKIMgZmn6V55/ffSSMyhzWQy7s/P0tEsKlLX/xvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPS3L9AVmAAjo4PT6gpsY8md4TvbX/qp21y71+KQoY4=;
 b=mxzduvY3AhYucHQMBnMUFvoP5R+kyE5VwbWK6CQ/qjehepNNaYAqJqhhNhvw5Q5RuJ1xKKpwbHA+7LMh4N9Z+l401iZkZHbAEzKOoUiMPxm8+36L+eXHXcrNBgvXEU/eq7OBFSsU+RKGX7p3+GzGunoUU/Yzs1miBjWwiPXWMunrFOiALtUN3l3SK/i+cKW0gwDSo2PDyZDSc6t2wwwO++EFY50XAt0lgxRMq7UwGc7VraRHLkZ7tz4wRCb3EDz3SHfUBKq3chIkXceoBDr69HTZHX6JiUgzo4RScZNDzFoLmmkQI+12E7EkzGtsFKxQbfqK3yWR4bAhDqdjXlKLxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPS3L9AVmAAjo4PT6gpsY8md4TvbX/qp21y71+KQoY4=;
 b=RZC6k3BdXJkcas3hrft4rl2qXhKodagBYG04J28Xd31wML9ABLefy2rzqDcq03X/DBmXaGqZsDlC5U0v5qN5KQlKY/wRh58NRvUpvi5XLmO2oXSIuvPq3OBWTAh0eygY4+G7tQnU3nN/rEXAIr1xlWAgkqVm5Pw6yjNDyPLEIGs=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR04MB5943.eurprd04.prod.outlook.com (2603:10a6:20b:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 10:49:53 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 10:49:53 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Markus.Elfring@web.de
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v2 0/5] DPAA FMan driver fixes
Date:   Fri, 31 Jul 2020 13:49:17 +0300
Message-Id: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 10:49:52 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a7764efb-0fae-41d8-4542-08d8353f74de
X-MS-TrafficTypeDiagnostic: AM6PR04MB5943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB5943D345510CD1B941591B75FB4E0@AM6PR04MB5943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HaMmKM4cr6RqTzNRQIkkQTBY7avuqmi2+hPXBGJVz/f6N/SExFRKWfDBrs5Mcr1A4yHQFgoG/0fiLIdja76BLEc7xbeJdI3zfVLR2YfdqiElzfwZnnoCTolkd169V0NgH9Jrp78uOm94LgqtbexGmlK/kIQVijxGA5nGy5rZ1KYJZrWlfuljlfP0AquoPW841ClJFOVf9nelf5o7VmDjvstwGX56i6lefuJ8NN0P+RhHasuya3Jr3tifI+PPcdhmHBic9b7aP4aggmEjj1SGKuwV04co2MQNmNqsRQhWSkdFtXseLLGewVXFG2Pmp8HnrIomywL2hCFrtQR/nolvaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(3450700001)(6666004)(478600001)(83380400001)(36756003)(52116002)(2906002)(4326008)(6486002)(316002)(66946007)(66556008)(6512007)(5660300002)(8676002)(86362001)(8936002)(4744005)(956004)(2616005)(186003)(16526019)(26005)(44832011)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WsZPE3dFJXbWtDjzQJ7auEYSx/lrytDLjfiqdXZrwZffXfka1XoivcZTv14bBUGI3DtGrtwC9VCqdxxbtr8l2lSXIZ1tgZh4qVNGJmXEXw+nIALdhdJBtb8tnumHvN6U0qruEjUMEJbyYXvt+PfpdhaGwwRiXm7JZylyNJtmHoiT5HmzjwdM/7lYm1xG3I19wUnZbM6tzeZ1VIPfLciDc4zENEXApFhJzcbHuCla1uECr+dlWx6XfKxVBozIMG4UXrvRbebiP1ZO81VIuj8wKj71w3k+sEDMVuNZSJKbYy2/icHwP8GIJ55axVXNdjG+4r9NUGfbgs+j/K3ElqPvQPm4IALgmQtvrdTOtN8GpSGGsUknrInfYrTesbLbqWz3Ol0+VUX1Db52UYRzpyW7b2HNLxuSkWlIT5Yg0FEOqFNJ4DFYUqP0kq0ZiA3sQEov+Mkvc2FfZXvDirhPwVa7xSAyZT7odHyYBossM4U2ANsL3b0WeFoU2nm0UUz1RhenbpmTyToQuZFSWwiZw+lpIFontztCJPGvdpiOEmDn6YzyUuVq8SbaBoRftCVxEGKvM1Zh4SatZ5KRi+0gkO3LwaluMUAXRRdC4If8BB/mpa2Q9yMvw+On2k4B0W5NbReLCX1GAV1LbWnZezkkoptcPA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7764efb-0fae-41d8-4542-08d8353f74de
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 10:49:53.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rW4w0uPQp5qWmIXxGg77eTn6UJX+NShCsi4iILtWsU9lG8BExBvqc7f9ejSI46s1OaFv8vps2oywNge/HOQYuQUVmDkurNZlwggOdTXhzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are several fixes for the DPAA FMan driver.

v2 changes:
* corrected patch 4 by removing the line added by mistake
* used longer fixes tags with the first 12 characters of the SHA-1 ID

Florinel Iordache (5):
  fsl/fman: use 32-bit unsigned integer
  fsl/fman: fix dereference null return value
  fsl/fman: fix unreachable code
  fsl/fman: check dereferencing null pointer
  fsl/fman: fix eth hash table allocation

 drivers/net/ethernet/freescale/fman/fman.c       | 3 +--
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c | 3 +--
 drivers/net/ethernet/freescale/fman/fman_port.c  | 9 ++++++++-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 6 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.9.1

