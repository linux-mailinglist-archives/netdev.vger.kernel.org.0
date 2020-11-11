Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02252AF723
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgKKRFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:05:01 -0500
Received: from mail-vi1eur05on2098.outbound.protection.outlook.com ([40.107.21.98]:52321
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbgKKRFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:05:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVXKykmO0TDhx9cBUPpUm4qPe+z004F0p6XDPCuQLIDBLT5ExnV0SwSwWeyJPVo5WKdckRhSyglWEak703co7kqCOz9xf2S6eVMa6SNqgW+Po07m92dNPJe2Q1FFQXHkSUjmfXlB5an0p9HlUpHBfdyoj9Oc7BsanMy/q0dP9LufRXdNIDY355n0ij+m9LjTvm702AjkiXmdLqhnngZweVZ8eXtHu1uHcjE0H8TPa2w5l/P35VwjSMfmSnxihnNgB0Qko0fsIK90gAoLV6BmFcI/VYWJbhzsxt45fuHzO0UPv+8KDZEFrkaDIoKULvGDHD9TThbP8XhNP0k/NifI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQdGCDq5jnmqRAc/LYoeaE9MY5oVGCn/I+VwG5jfkBM=;
 b=Rf131Z5mPhgHyRtWpk6WnlloGDPIauCXftIiFAToo4Xid32lMhn6VBlbSCEIR0xpuLQw1v+R8lruuHaYJ0X9OThpYs6i5TvTGi9j3D+0BfJAAL8hmwWMebR4T8nao3iFaIAyNMxczsbfy0BK5sOkd5LP/2nT9rL2xL+12SLZaytMmlcSfg1yogZEQYNA7ia5TQ5RYecFe5cwO00diMeiaW4yDKg/oYv1bqvrfQTUSP/VWj7a2ue1BYmfslI8RP9mtrTHzBUiRkelPT3hSB7s8LwnNjAe3rf7xpSbaJ0AtNlU5QM3mrEuDMO2NUsGqIL+5OAIwqljXe7S9DcbN87t2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQdGCDq5jnmqRAc/LYoeaE9MY5oVGCn/I+VwG5jfkBM=;
 b=ezLa1hValDyxxpyPjX2twXS5UzGWSHElQzD16sIbI7Nes0Akk7U8OrPWoNQm1ipliIeCcX3MEw5N2qVCKAaBiiXNsPaYym3epYBFCzrGICL5Ww4/oLblTkaQQqHa3Jxn7MYqLqlSNuhq6dORpr6qtH0lURTJpp/wshubEF4Ij14=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM8PR05MB7524.eurprd05.prod.outlook.com (2603:10a6:20b:1d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 17:04:57 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 17:04:56 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com,
        pmenzel@molgen.mpg.de
Subject: [PATCH v4 0/6] igb: xdp patches followup
Date:   Wed, 11 Nov 2020 18:04:47 +0100
Message-Id: <20201111170453.32693-1-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (37.209.79.82) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 17:04:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38f339c6-e970-4019-6b93-08d88663ea88
X-MS-TrafficTypeDiagnostic: AM8PR05MB7524:
X-Microsoft-Antispam-PRVS: <AM8PR05MB7524393077FB42280DBF206FEFE80@AM8PR05MB7524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tU4sRejkBROtJWux8pJInlDUYX1OEiJ5IoJAaKJQZfrSjEFp4AcjJcjbBlFP592Bdu/wpmd2bwtqVE2ONoGyEDqT8LxMumqwDf3hVcoyQZapTdtHpMl/vYW095OvHQP3DMtChZU6nNkyLSurwcWHbKpIBdstLIil+Uu+1L/Xyv5lHThZy+ISRHqWtwlOSRI0fqRxG/et5A1hykllL4zyEV6Nw/808xihIzOHZgRlMjX6yJdBf7KE1HzKkrbYDogLnaYVivkwQhL8/cRwPKBLrWKicoM803VJFUPQLZo6wEUfum8+murU/9Fz1wLPmakOlQM+dbenwu8yMEB9AH3CtGoZYjE2oMo+qZSl2ZrzLqnLaPnCCJmoP2qnej+umX8/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39830400003)(346002)(366004)(136003)(396003)(6506007)(5660300002)(69590400008)(66476007)(66556008)(1076003)(66946007)(86362001)(8676002)(8936002)(9686003)(7416002)(26005)(52116002)(316002)(956004)(4326008)(6666004)(2616005)(6512007)(16526019)(186003)(2906002)(6486002)(36756003)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eMBs+1p5BWgnR+orNApC/4jc8drhIxJ6y3v9pg+iX16l/ooE5rP+lNAKp/XwsNl4dpFpNr6DKzvaqWhgCz0dsLsZ70YfMFUCDrjCLlGUGL+hEYxju0xiT+4pGjixW+4UBUa3eQb5oqb6C5dA50XBjqg3LRR3zDfU6PSY2gjjnlHd+RepzzTIZ2l7+7Nm/96b2rf+PFkl2tLknnZjJErzZKhdjI2fsZU4zWAu1x9XCFOaADwEWMICdkfuDeG1EWGsADfA/Ru5zMRnhTrLF7T/Y0Tu4VXgjhFoE3IFCu4rWKsoL0Jv0kWbPK5qe1XZ5NEcQIpqo8v0DSGmUskR8i7lvPcT3Ow9DBzHHPSWj8zqQMhGX2z2scrmXtX5aFFQUDd/UBJ4m3uiGfEPgyA42M9dWdgjEVXP7qtpyO9NY3qENqMJf8rfysTlD/xX6MrODQSfz41qrPkYhCtynOIteOP1QP8ubyjRqKylYaBiiruojnD3kIHF5xWrjne8lIWPwiD/za9NVsHdcfOGEJ77EUskvMaw2ZOPXWw9v4lmBN4tb2n4xJ8xPkxP1qCV2HX3h9n2vUi/1YRSoLoFcz7eP8GKYhlBp66FFjWAUiNklwhfWjOGQkExfsKDyF0KfqFEcveFA8pRoCTxDpGpEoeKYeFX7Q==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f339c6-e970-4019-6b93-08d88663ea88
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 17:04:56.8713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXmelH3J3bxrTdxa0jMAKsOrRVjXbx3maJZtCvrgvvidpG2petr51YjBoOIzaBjBg66JeU0bcMNr5kRiQrJlcaz3tG4wQpEuuLD7gNT6NUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7524
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

This patch series addresses some of the comments that came back
after the igb XDP patch was accepted.
Most of it is code cleanup.
The last patch contains a fix for a tx queue timeout
that can occur when using xdp.

Change from v3:
    * extack message on error add netdev warning when rx buffer
      is too small that shows the buffer and frame size

Change from v2:
    * Move SOB line to end
    * Remove SOB from cover letter
    * Add a better commit message for
      avoid transmit queue timeout in xdp path
    * Add ACK by from Maciej Fijalkowski

Change from v1:
    * Drop patch 5 as the igb_rx_frame_truesize won't match
    * Fix typo in comment
    * Add Suggested-by and Reviewed-by tags
    * Add how to avoid transmit queue timeout in xdp path
      is fixed in the commit message

Sven Auhagen (6):
  igb: XDP xmit back fix error code
  igb: take vlan double header into account
  igb: XDP extack message on error
  igb: skb add metasize for xdp
  igb: use xdp_do_flush
  igb: avoid transmit queue timeout in xdp path

 drivers/net/ethernet/intel/igb/igb.h      |  5 ++++
 drivers/net/ethernet/intel/igb/igb_main.c | 33 +++++++++++++++--------
 2 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.20.1

