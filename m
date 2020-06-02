Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09A1EB4AE
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 06:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgFBEqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 00:46:55 -0400
Received: from mail-eopbgr70127.outbound.protection.outlook.com ([40.107.7.127]:6279
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbgFBEqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 00:46:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmUXGMrTu/dDVwt6uaCLVZfo5UsmzYFvEB9s+F5jtoJ3imklbC6qyPhVysw7C/5sg+LNFqSdriNS0RSJxgCL6X4YIRjgpUZFCUvpnzvdrOzkY7mri+5SQNsVtCGn+QX90rAp32HlfOaglZKT5Nl1SbTS+ACSLQsOFsRAE7+XDoB2UVrwZEanqWQFivdCwI1VdMukSKtR5P+qywBpfd3dl33f/mxb+wEUyxP4Zz+TtwvE9eTo0NNyK+MG+Glimig0r/4/PIYH4EkTuvNFMWYTDaz8DW29HUa7N0GbtDanEOp+de+8uDUrgGCL6hCPWMTIKp33/tkSo4m9VAIRId3GHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TS9JDinM1mbqxKFpH9eckcQN07t9EWfxdtP38syfAjg=;
 b=dSeImFceMI1iQ3IR8nEWofHyCtjcVl+oA94u/WdD/K3kC3qEKSY+Qv3GaTaJXeGexy+UmgRbVYhnWFzMlN/IIy4uNUU1NvkACjRY3p8Pr/IoSa2+5gxaxw1EH9+CXeMl7/VdGR+h3Qg1jxsVV3VgLdkW6HR71B7z48PQThR3xDaOv/WHAQxu+F+Pokts+svd1t7JZKYMFvWEObxxl6x5bh1dp2Ci8NcoQPtNWdfLI7vRoJ0B/gD/6r+7t/XXTqfPt+C6z8io3//d+MNLFQzgRSXy3N+iIKh1huFLRvfpPxHfJQB0rFfIQyJcgUx5MPI23qzHEWbctGYx1ozVxB9O2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TS9JDinM1mbqxKFpH9eckcQN07t9EWfxdtP38syfAjg=;
 b=HZxNfucmqKsG8BIc+6ObWXH/7D7cPt1Zw2aDrqT61zssW/Zc197HfrOzdafcPuajOyJC8GEOp8DD5g9gF7i+xzfJe9jtOX0gUmqFl3B3TkgKCgs+wZnHCieptcUm14DIFlIa2hbZ1Pr/Ho7JXyK1gSq7lM2TJGYKVqD8CPrGbeo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6SPR01MB0038.eurprd05.prod.outlook.com (2603:10a6:20b:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 04:46:50 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 04:46:49 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 0/2] tipc: revert two patches
Date:   Tue,  2 Jun 2020 11:46:39 +0700
Message-Id: <20200602044641.10535-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19)
 To AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.17 via Frontend Transport; Tue, 2 Jun 2020 04:46:47 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e365aef-2e34-4ea9-c432-08d806aff659
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0038:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB00384784CF8CEC88DE8DF0AFE28B0@AM6SPR01MB0038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQjz2aJtuHDC2JTNfpMSC6d4kCzBEl7vaxjkU5L5HtgYU4ObLbdA3CReEOw7O6SN0PB+F+0e7357HQmW/arqvWLndyGGL5YQU5St/FPV91oDH6YgEP/TNtnNpct6PHAuKl+/OgyR2kIZREMGdS/mlxes0wNAF3i/PsNPWaP43eW72FKGKIGuH00IZc2ELtOJdGD2oDf/2UhguW586GJl3lQsNCsc6MLFEmCW2MXbcKdv7kdKuB7FbP8r+rkrLqS04qbwC0E3SpygXKfkF3r8nS7j8xx6wgB19CJ7aXawTImmsJixQgizLpV81Ij5TrPC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(346002)(396003)(39850400004)(376002)(478600001)(86362001)(66476007)(66556008)(5660300002)(36756003)(83380400001)(8936002)(55016002)(103116003)(66946007)(1076003)(26005)(2616005)(16526019)(7696005)(52116002)(956004)(6666004)(4326008)(4744005)(186003)(2906002)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Bt8vBVbxum1BtFH8t6isshvOcjDrc8R2LcB/RiouAtrwNkgx0118bjAZHT5mI3Ql+PnkUPZ2s1Wo9ME5uZDm/GgoyTySCNelrUKvqte3PKuLVvdy0SDu4upFua7YaQlOXh80kwwRM7JKs+r1erW0QGV/1zb2+PLXjs2l8xzQbdOcyJNN+odaYuygvHtY7KCOuHtMTDClBeTuTGcanI2KNu4t7UVBRplwaXfXHyrhE8+PigXuAFV6aBY6oOYD5V2pkGDVOfTWX3cjVUGi++iLkdA4a8trq3QwzFLTCVDrfPNsjQjPNpWJlsNSJeSF6azyadkgTfn00veiK2lZjZkuW4nMRC11P7EQQS39aqzHUyFrFm+pEhD/tg7soMSg/GeEe/kTbNjsbCRE5XDGdJo5nXjflDvepKpLe6PYSXZO3ysqSJm6WCvDipzvcAi3xRqLlhcJ4fY0AkBSI+S8bciH0TKUtNuo0d3cCgAE7GWmhRw=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e365aef-2e34-4ea9-c432-08d806aff659
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 04:46:49.8804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/L/taWJo1/HlxeCGO0Onn9dJ2WvJF+L3XdaVF7Uad2tm8N2CtFCLKK6rJ4/YkNz5Xse1xLegkAIkACU0F+uchWlNWLuZpagpyIT7OmCKic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We revert two patches:

tipc: Fix potential tipc_node refcnt leak in tipc_rcv
tipc: Fix potential tipc_aead refcnt leak in tipc_crypto_rcv

which prevented TIPC encryption from working properly and caused kernel
panic.

Tuong Lien (2):
  Revert "tipc: Fix potential tipc_node refcnt leak in tipc_rcv"
  Revert "tipc: Fix potential tipc_aead refcnt leak in tipc_crypto_rcv"

 net/tipc/crypto.c | 1 -
 net/tipc/node.c   | 1 -
 2 files changed, 2 deletions(-)

-- 
2.13.7

