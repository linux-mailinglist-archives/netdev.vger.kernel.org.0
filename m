Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AFF6B1CF2
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCIHwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCIHwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:52:09 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2040.outbound.protection.outlook.com [40.107.215.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D53F6B953;
        Wed,  8 Mar 2023 23:50:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElqtXSMH8gp+o5e7QSIX9u85xAAsjJ6m9TvZxlqrGas2PhJ2IIfwO+Zim7qodoEgqt4JTXVnt4PcDr7/a0+nmmm6A8mN2/44G0TH+J5KDZ1vZOAfvBatgHvfjDZeG6zR5f2WlJgeZPLGsU1MlIP8CL+T/vzvtPPn2Gnbz+43TKH59AdnjassWUvppYTmC10ZtXqFdpENw+UeRIzNpG1G7Q1VsF5wvIQTO62bDVdZu9QmbmM2usuJP5W5UIcIOrjqEGUHfIQRLyDXWR6pS/HhM7CLLgvzblM3Q7VPFcZR0krW4T4sI1LgV1RW25nD3EDPRj3Ld1IzHgIWzdw6Z7mnfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYbVRGEiS6w+MOgZM+UEt8ebsGhxC6+9B30RymCPMZs=;
 b=K9SL/ncGlR/YEZNdL2Xcw7Jxt09pwO5FqLkOwAqmqxQHnRItD3TLo3yismbAKxZDXykIyjyjNnPU9Q/Iy/dpLMhg/GtQuxl66KTEHtU8CJNBkwegwV/jt4r9JhR073usbNgoEltGHdbmjeYnJEyeFyUwh0mMWZoxmgQk8rl7zID8DZMdYDkI6NWDLp2vK7TngEkkkrhnRYWW8g5fIocKSVudkJb1j2iMp7WpptP/GSAzW8Vsh2W16ObRmubhoZd0w9RdGHi6BBYZpsl6ph6fkuNb04aeoLI+rRO+vsJMrLaze2Z+KnB9I2mrtq7zL9rLJk+aeWQS/fJF0bojbckIJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYbVRGEiS6w+MOgZM+UEt8ebsGhxC6+9B30RymCPMZs=;
 b=srzm1hxa8+sexBDxVNDivPzdQfFWr7WLCL8UVPFuyrBs/WmVRmpi6i9g4KOfDmAnIuMxHH9+Ht9/LbivsU3C3hCH/YuTAyDKssuLom45b70GEYXrNnqKgGSyh5tORP8+OEStqyliQ1dpIqjsndX7xVLgCtpwRkmTU5H0PcUl539hoG8cZkF8Pnxms2cBtUTtk5hK4O1HT4A0sWNOmnA2ud/FtF4FVFFBFQKgXK8p+FoDQo+8/V+pDM6w4imZE9h87B3tmDHP3/7443mZEo/is+jbaSuxWqHdPmSoLRVT4PlDS0HFJvf+2ZxGkgkOO/ulzb9jHt9tlozmiRLP1B4Qrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by SEYPR06MB6011.apcprd06.prod.outlook.com (2603:1096:101:dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 07:50:17 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::47ae:ff02:a2c9:845c]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::47ae:ff02:a2c9:845c%3]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 07:50:17 +0000
From:   Angus Chen <angus.chen@jaguarmicro.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Angus Chen <angus.chen@jaguarmicro.com>
Subject: [PATCH] virtio_net: Use NETDEV_TX_BUSY when has no buf to send
Date:   Thu,  9 Mar 2023 15:49:52 +0800
Message-Id: <20230309074952.975-1-angus.chen@jaguarmicro.com>
X-Mailer: git-send-email 2.33.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To TY2PR06MB3424.apcprd06.prod.outlook.com
 (2603:1096:404:104::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY2PR06MB3424:EE_|SEYPR06MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb3eab1-6b38-4116-ed17-08db2072ec1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G83h/HYAWs+ZlBqQSIXFhxHoy8Syc9UmeKKdK9r0Hxwpv02b4SEwXIUwWBQphP1tsLpGmWkAWnCYERVUusjxwXIL5k29TxvjmeYxj50nzOyHQQsUvgxnLqWBE7NIZH5fKtnq6oYgtg00wn0jrPtkXuKdL/5XpEYNEBVEYMtsvr45YUOXzprXMpOCkwjE6TJwK9NLq+g3oJyYnK/ZSQYiYcRsrtdzTGYLQpqXmvS8/Cbe72jesCtvCR4Tr+rD5O1wInK1XU/VT86ap6RO+nHA1n1y+r+KF9jTATeZYrw7TFKn9OibnpLSjEG/Aj9Upxn/7xaguJFQn3MJWslTRoh9sEZgzrV9BcxP63hLcjuEjT2BL78KJhe0vB91PZCNoHzNuz1jNFR+ZeiLesnDojO6GmQzWfOzoSnIMBRmNmxzePcr0eeUp4dxHv817vWCfGPfAYKGaoK/JgquX67E5fgi2Uu5gSzGvvm22eluWpXLAfqJutUmz9s7X3+fEp6xxaF1lBCeUetaq2Wt2Y7uu6DNMOtmA4gu0kiajTcWywGWuB+RLjLVp6hjF8puCM9m0bMVU+0dgPdCQvc9byYwkLoxkcDqezqPlpRYh6KALvYUkE/fLvb9tC8XHtJ+XyWtgcM2rnQb4GHiu8ekenbWOwGuyHAl53notjQ5m6wVWoQ3wQIPthnJlIeDMKG1GJNfKpL+24toNxxPyTNiicyDJ1UCibBG+jGLudyevJtGw/nHe0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(376002)(39840400004)(346002)(451199018)(86362001)(38100700002)(921005)(38350700002)(41300700001)(36756003)(4744005)(66946007)(52116002)(4326008)(2906002)(66556008)(7416002)(8936002)(8676002)(66476007)(44832011)(1076003)(83380400001)(478600001)(26005)(186003)(6512007)(2616005)(107886003)(316002)(6666004)(5660300002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3lo1gCSpvqcKWuhFpGa0R+5SdtuaLkYq1MBWETeB4+dji66RuTmSussx2K3r?=
 =?us-ascii?Q?hxZoO/43sYQGbhDJdx0p7PmTCHi/Xd7f2dbFvdZbjzwp8nu470sRVMBlU8PC?=
 =?us-ascii?Q?UmmoA7Q+XZHErE6umiJ8H53VK1zMZsXoXycqApfcn9X2+VVxLN/NpJQD7oOP?=
 =?us-ascii?Q?CWDDPPOxoZSOS8uvJ0gU8zMwruWg+JnZWxkEk6w9hq0ub80VyXIEyL/LDnbc?=
 =?us-ascii?Q?tnLHAfWmNczuR87c5b2Ycu5Q3yapaOu11vfCgy7IgzoPFHiuliOBO6+bT4cL?=
 =?us-ascii?Q?3Xd0LOq45P2Q3qXL2BcPS406mo/YL+JgGgSPlIysd1mvqwTlUaHxbPEn0POA?=
 =?us-ascii?Q?wkoWnawyJkrE6lrc3z+Zz1anG+soQ/+UefLKA6myf6ELz4Av5LudxjyrqH71?=
 =?us-ascii?Q?dr7bdPm6eXgc4rYcmbf7wUH23iELoMk6dbQIwQQG17Lvb+g+3gyN8JdelxIh?=
 =?us-ascii?Q?9oA30kXEZr4fege458PNjaak+y4vmtruo0pTFWKaBppViloDMRD3f2waeQty?=
 =?us-ascii?Q?FAYj/VtfkJ3BDzESm9ApO+0jRQu4VT9nM+Xb8KanP/oAwjnWca5s7jchW1Rz?=
 =?us-ascii?Q?ALk2SSs8a9K6l0mUyHCqkR/zY8EZthkhrH4S1e/pE62rAq645x3EkVVmpds5?=
 =?us-ascii?Q?9tEaY2YJwFBYOxNSzb+BGsNUL8cLbwDk1N/trxCddPsMwnK/U9LQxPEO4SPm?=
 =?us-ascii?Q?cO1fN8kTKQ9WiArOp3o5nVjou2e0Ba1Y1heYfTfHuwHHtz0eZ46JZE5aNP+d?=
 =?us-ascii?Q?SiP+Jf0WzP0NNZ2KnBlboA+eSt3+VIat9Lb4LYhfcsItCzK0W74noE1iqVJE?=
 =?us-ascii?Q?0e6V5bNHdwj3dzzDpWjiqJhS2tq/5rqojix7pe0d6s1kR5SEpVWeeVYYsGrc?=
 =?us-ascii?Q?BhhB8dB2HwppFysIkXLiqYhqN5x64mqTrBRcVZZ8PAjkIOBLxsVTzo+FUKds?=
 =?us-ascii?Q?RkeLZDrNsLgb21uqipTMCMAbCgJW5t5Ph9KV+cqyC3qfhODoQiPBADBkEnjW?=
 =?us-ascii?Q?e5yrwG6rQP1vw+0y6g6c6ahOVJtOTIDcHkU7jkQz8Mf8LsPhOKzSeLEkE9hz?=
 =?us-ascii?Q?YD5EPNiIjgz6Z1InyuO5J18dsesl+MB3oNjz2NSbkbfhFp/O7uKfrONtVCqw?=
 =?us-ascii?Q?9mbNI1igDpDJmq8OBkfI8di5/5CxTK1oywvFZg0kGTfkOp1/gpArR891RS2J?=
 =?us-ascii?Q?7Y4qViJuUdtuAHwjp9SDgIrivTY0USgHIwtdGYPWR6iaN7hd4Pa3ZWOji6zO?=
 =?us-ascii?Q?TK52mbI8CvXdFhi6oqcFyZRDeLdP6l57djvGYnjvFAcJTpAO2QnTC8y+6RhS?=
 =?us-ascii?Q?XowDqXP9hNw9u5kEBonSdOZ0bQetnFG9kp+oNO5qGksC+5tKPPcucOt/z4dc?=
 =?us-ascii?Q?Z0sAktvRnjU0nw2prVU9YRCr3hTK8381ZxmL0TWBLK5UGUQGw3nstB3Re19Q?=
 =?us-ascii?Q?ciXUasFG2yiGm34HNHve08Ofk0bT80ZTNpk5zEI2PtQ+JlkHm2o/ZKC1CsbJ?=
 =?us-ascii?Q?ZgV5J5WVJkNZPvM33UNJySg59o0S4h6YeG6qLz+41BYavjOHIcxHz7Dy9F1i?=
 =?us-ascii?Q?bIV3W3AWyHMLkGWnkC9iPweDrFcItaWvbegs8Za1dBUUZwFGrwZApaiChSR5?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb3eab1-6b38-4116-ed17-08db2072ec1d
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 07:50:16.9676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gnDnQ/EpUADPL83vi8Dj68F6NkmvmVQy8GTNePuNyESd2/s7hXyy/nOOQo1npnYabumg/qx66KbEvjq4Ve9TfKpfNo+uvZkmHJyCb/3Or5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't consume skb if virtqueue_add return -ENOSPC.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fb5e68ed3ec2..4096ea3d2eb6 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1980,7 +1980,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 				 qnum, err);
 		dev->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
+		return (err == -ENOSPC) ? NETDEV_TX_BUSY : NETDEV_TX_OK;
 	}
 
 	/* Don't wait up for transmitted skbs to be freed. */
-- 
2.25.1

