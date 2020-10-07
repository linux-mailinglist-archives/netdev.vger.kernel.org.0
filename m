Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25F528620A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgJGPZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:19 -0400
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:47836
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbgJGPZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCSpWhShHbh8tr/uVTeAbs2CCd43fv6cEa2vJHdCaZJqKBKyG1hQ9dUV58SfbldYn7HGFq9qWkzujPYN4wTyBHQtu7373snP41A78+LikAzbruR1y6dHTbx8sCEsW7PB+5k/XM4BpuHDnLnDHfU/jOnIFGtX/wpH1T4x00t9EPgd5JyBVmERHwlB8srOP4OqsBvYEh8CxEZhuNSC3sfHp0fd2tYRS/AaVayt39lmVGhwSdYG4brCeRrQ6DAgfap7NM/G8gVNwxj9sdSYC6RWZmI3PZhR8g84JKG4rZHx/5o4YtNsRtdIjFkFyleBSinAuPn4sem0vyq6+O8j2U3EOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcfG989Rx8eykg23mANVBlEzi26Vbf8qZLzrdjeArJI=;
 b=dBLkhu3yiVXZyIfNrK9KY+rUn1TGcta+L4MkLTTDYxH5JpzsRCrD5IWp7Pzz9D5yvj/HxIeeGBKQLCKC8IvzMuTBd4I25F5ExDC27+FLzbG9aTTOaPdWP4kYD8cdJvD4Ak7/owoDUucA7WcA1b1douuuFHwSbdYHIn87I/BBdA+hItzKLvj8iw5rzP4Lw4KrL/fYMYgmpRcSZsMwx/GYVuxycP+BB3hjwRKEaHHIjEuCANtkQesWLov3iwKmLR2ZHgLFXzfbt0OTEFyoyeeNE16iyvndVAwAM+Z2cTEh1CqGHN5bd5hE4PQ0MYRKQhzCdc1T8moXNZ9bfUlDQwDlBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcfG989Rx8eykg23mANVBlEzi26Vbf8qZLzrdjeArJI=;
 b=XB4BbFOTwjPu2rA7t8QK+A6kGhNxdMAz4g+20TPRSCVpEKT7Ac9Rk1qmKepQecdSlGENNzOuJkkMOMSkNo36WnwgIfUeAkQm612sKbgNOog/3n2bJX+EeY+Y0002I2drGzCjaBtGuv4zufUcHCV0IQa0/S/bTyAslE//fVXeEZM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:15 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:15 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 0/7] igb: xdp patches followup
Date:   Wed,  7 Oct 2020 17:24:59 +0200
Message-Id: <20201007152506.66217-1-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR05CA0077.eurprd05.prod.outlook.com
 (2603:10a6:208:136::17) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 161129ce-461e-4c50-3b7e-08d86ad530a0
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB608256103A6B79D69E5BD600EF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/+xVf4I+crFV2s9wYMIe/PaQ4t3IXo9Jmjvsp66sUtHa1Vt5wIHz9QEDNtt7AE3HsCml+V1zW7pMF0kxdarcC58t6IdZus2CNm/TzWAwBFDVDGoqfd5cCF/Z00CQKVclEDFQfF5SSayrlMo+E0dsHeeQpGwX75ytWKv62UHo+vOBa00W2xJlOfPwU+5WUxXLEcOGw9R+FwRFfQf/kxWlqyW7TymNnfah52Q9y4hQIB+dJcnxAwxCuIV+eAcuf3d2lyIZn7sCB7JpAWoMXz+JQOWsJAVHiDE2D+oukLSyoeiGHQwZ/OXeonYNelez0oURkikfSEMrUreQUK7Eivyhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(4744005)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZGYo1QVm7/5tD2Giu9ry2a8K+hNX+PysToGci1VT0LyQDG6COqonoioV612+3ZQEiEWtVqeatbRRGWO+5acmctEOFSM8PYwnlyi0mb2Npb6Pe1Cpyvz5qQHFkLednWdar3TZNxvQ+/L1HH3G/6vY6hhUfaOpDvbGPi+qj55cN2M5iKOC8jLNZyAmDEpV2/AzSZGy0A+pF25ma7CU5O3MgGge4LSVvStZxVnTotTT4G5BTQ+eotnqzIxghnopV7kkBxt///5/e85i/EqKOtSDX+fGFpxJzU3z+q1ZWNB10gmgajBhxj8jUMP1qf/AWv9X2SCkP8Sa5qONYp90XIT4E0zC4q5c28jRhTgkoL68Z/N6swUcqvFyHKlDqFs94/PCQQiAeN0WBA6KpWMaKpimsqScaZz6C1V1JVLLc3qTpTzkvht1cqUt1axdg5IlAQRY99PcWwEz3ZkntfmrxcqoVnBl2/h5ScS+FNZ2SE1Wozt0P0WGFTaxJOz0HkEjJXOeDtfHNexV2dx0w+PKNoD2Kd5g83Q2TR1W+3sfwe1QDu7xyBKGxpHTXrM8u9Lt/XIPy8dxhg5Epm+4DG59ssRNPz4iQJvcu5ao0b9OfnHb2A9rEdLEwlgiOZ0Lmh3K6bj+CkWEtY9TAcUSjE1L5TmdXA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 161129ce-461e-4c50-3b7e-08d86ad530a0
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:15.1262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KctNmdu5Fh9zYXRCeJXs9l58h2Ej38eEZMXZhQJcL5jYOBzDOE2SeMePxg4p2sC6F+pe6SH3z4OL7fb5fVoqLZFDGvE8SNhJOSykEEsTL5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

This patch series addresses some of the comments that came back
after the igb XDP patch was accepted.
Most of it is code cleanup.
The last patch contains a fix for a tx queue timeout
that can occur when using xdp.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Sven Auhagen (7):
  igb: XDP xmit back fix error code
  igb: take vlan double header into account
  igb: XDP extack message on error
  igb: skb add metasize for xdp
  igb: use igb_rx_buffer_flip
  igb: use xdp_do_flush
  igb: avoid transmit queue timeout in xdp path

 drivers/net/ethernet/intel/igb/igb.h      |   5 +
 drivers/net/ethernet/intel/igb/igb_main.c | 119 ++++++++++------------
 2 files changed, 61 insertions(+), 63 deletions(-)

-- 
2.20.1

