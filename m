Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F5A5AA539
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 03:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiIBBqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 21:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiIBBqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 21:46:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313FB4F69A;
        Thu,  1 Sep 2022 18:46:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqJ82GLr185dKLick4ViNxBHY9VxG/JN5mbiAkjBCEeLf5al2z0webhJdI9iN1iUV95vn+y5QiCBJdZ33RZOWeq2l5GZR8Itr5PHdRB6ULksdZb4KpCnR8N1/Dm84WrMlAbNBy6C7pDrzXKRIMFsjBiGkgiRW2P2s/P6/dX/qcMw//Bj3ba1QbJmhjhAohhCh8HigQFNv2CKb14sfdzqJf9/fpQ8dG8hKYoVgmNN6812QLTStlCYL4kWxGDOiHcGmT9KOicZ6hXVWs4EwhrMNYTRLYAwqBg4OXi44/tipYzCKxciIHvrVIza+06UT3Niih8IxAjhGkcudpe9V6PD+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1L6OZgg9hBioGlEQ7oWb0UtEQdnxDWuOUqgrbjvQM9g=;
 b=nDo4/bi9/7XIfd1+7LplEOn60Bk3kAY2zE6/6iltKJmKB/RvBimnicdVluhvIcCXQhJcCmKzPoAgQht9JYDUeKASgVA6F83OtXNJrT3GfDwVBVqFM3HLmfmtGzrwwi+5Ghp/DkH0o0rqBcP1+vGQd1knNx0EykbueQAYBxEoEJAn0mr/EsJp1QEr5LjuOIyJzeDR9ClyNiulJaSMTpqnTYLmUwvBTZo70SE+D7QMq5x8ecPPohpKKKjGMbDgWujyYaFttj4APzwZ8GMYe+/VYZ9+pnLO/Gt65sTNM4s3ZqlAKAJupkiitQKJuRvtxWn7KxK7F6GpGQeDkX9HByfThA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1L6OZgg9hBioGlEQ7oWb0UtEQdnxDWuOUqgrbjvQM9g=;
 b=LEWNvAziuMijeNK32qxrHaXH8kci2ZT4GcgmwlJCOZk7BxqYP2p+NRX0g+l7moLhagUfHrNMxvMuDrq2lYgU9mcqF9p/25gRvpwrKvvg7gAb30eWkZXCar7Ou+YPD3GhMSF6u8vXwRqDaX3ueQ6vfJCs2NXa7+xUAIWv52KCdOP87uyPWC59/R2atjKvVdT8ovSizchA57U9RBjmmu1pwuP+ik3Mhai4doqMDo0dl8E7ILjks3zjvIaJ1jhS7GBuwjwMyCKpcAGXBfXpBiuzOXek6B/TZokHmtqegu9jxNF7lmAhNBBAnNsFDZMGOntv2UlOF3La92dW8IUXF4p8xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA1PR12MB6728.namprd12.prod.outlook.com (2603:10b6:806:257::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Fri, 2 Sep
 2022 01:46:06 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 01:46:06 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 2/3] net: team: Unsync device addresses on ndo_stop
Date:   Fri,  2 Sep 2022 10:45:15 +0900
Message-Id: <20220902014516.184930-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902014516.184930-1-bpoirier@nvidia.com>
References: <20220902014516.184930-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0002.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::14) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d7a5ff2-164f-4e89-328b-08da8c84e71b
X-MS-TrafficTypeDiagnostic: SA1PR12MB6728:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjrYuHoEJo9i/DWvMbnrHs1kqcRjl0QapCR0UNluqRzCJLDBlVwTp9oUhVgQM4HGrASgRqItdF9jMRoFzhDOAa7cHM+nBVXtnZj/Az8TI6UyYW/fkTzio6kEEcEmSTji8puQzGFV5dZ01tt6vjldMgm69/1bRjq6+JmD2cMSCwf9RqCcaH1/gcFIXZRwwyugrOeFuxLWY/I186epZN9lXzcBOR+N5uEPA6JR4P3MNj992MwUjhso+LiFft9a56NdASjm3gy55mpTdNiujwhRn4KVAciT0YrWqu9RWPPMnwxQgrLF2ka3fTNPX3hZmSFkl7/qSUBhg3iiqBAB/nZ0CfU3ssS2kVWAtM0DVjwn6c5IGFiynCCLjXdNRnM4xFU4VH+VuIea6uMuFJghRss7vIhzblniMuiNAO0OfTdzQH0MaW+mgq4/SKlqZPP/BXOV+PdQIsuVvHpbToQ7J89+st/oBSmJfhnqQGptNplpnxE4yNaukpw6bTMzXofgnL+L9XT7wh8cXZpylUHDCFJbHmw4v6OVcBjDZDl4ezM49suh1qY66PWj214KvzXCFP59t8O9cGFNwIX3/T1aWhU5cusc+7DoSqmjBlNeEEgF2GgGZq0nNqeRvl2OSs6PsEM9HuOw0xpSoHDCLHG6xFL6zmrOxAAr2N9U7JDDECxn9QpFBjmDPFAZPcr9gUFIor3w50jvhR7pJPRsrdZoCspW1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(8936002)(5660300002)(6916009)(66946007)(66556008)(66476007)(8676002)(2906002)(36756003)(4326008)(316002)(54906003)(478600001)(7416002)(6486002)(41300700001)(83380400001)(26005)(6512007)(86362001)(6506007)(2616005)(186003)(6666004)(1076003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WKMoC2wgo2xx3A+/VMmXSBpvOSS+CJRePD1Hw04N5ER98g75FbqKptbfq7to?=
 =?us-ascii?Q?B8oPmKqLw8dYFF7EW30xNDd+flDp0QKDvYE2VmABj9TDr7gzFVnXr6Pmqfv2?=
 =?us-ascii?Q?Ck7NRemAupMyxv+gYqNyJrtSu9sCB0aDhl9PBU4tkQdO6+w7X68fMa1FZVwZ?=
 =?us-ascii?Q?r0+kD1Qfv0B7WPlkRe1wB6PRiq9L1uQp39wYMMvmsXwK+LUwx0ioyIH2yoOX?=
 =?us-ascii?Q?UXWHyVMp8uaacBFs7/q5wrgEEUhpEYHpZ7NavNfKKL4VhKgxcrooRq87GGba?=
 =?us-ascii?Q?q1UVwatfgia6BouTdUbI6jMXGUuPjfNaKDwxEiOg94FtdaY/2/lp9g4PeNjo?=
 =?us-ascii?Q?hVAvalfrrKsiyO4JAAD7t9M7Y/zUawXb/gJhABl8nGOwSSpxk0E50lSrM/Tr?=
 =?us-ascii?Q?pDmSwcEhl29dQCS8VfoOhx72y7CloY72ChmXQyiGHFIrkKY7N9bX0bAfttbZ?=
 =?us-ascii?Q?7HN+DGB4Utyclw1zn8NeH6tfKjLw+6nUyXxFl3hBlQpWxVBm2iJ8wsrvh1L7?=
 =?us-ascii?Q?cktDU7qx0lSakhK1CBckyHqXDXs9mEASvQ/r2jTHDx1dQz3urnk/mABXCzbs?=
 =?us-ascii?Q?/x94hJ6pGBDc/UUrGZVhNKckS0SK1pg6Uq2KcVDXylqiMc2tMeSy8BAKR0rI?=
 =?us-ascii?Q?Lqb1lkjJUb615SSMftigQk2yKn/+n0HfER2mLhM1vjQDzsc42LFUAVpB0Zw1?=
 =?us-ascii?Q?67FijP9JM5meYG26DDOcUc5pYycaQFs8v7LK5AxMQiFAMIDQ6yDO0FziBiyx?=
 =?us-ascii?Q?Mm+eanI8j7UNu7iwy+2EvWOGLZNEPdOBKOQRztJOKcC0qLIIVnHQFmJfhY+3?=
 =?us-ascii?Q?aiDndsTj8miIHf8G7M64w/WGm9E4TGpKFZpNTv86jEMQpFr3beA0ulRaLXzy?=
 =?us-ascii?Q?o6HSB7OJh6vfMkk/jsfpZBQspx6xtpoFTrHbHdadzKiJazNR0OXckSkURV7G?=
 =?us-ascii?Q?UQJqm8PDA1a0zd/WyWAhx8mzaoOyWoTsSgUOW3PrXqV5t32yMWeB6DEtGR8h?=
 =?us-ascii?Q?8NlQWbkkFzt/avyCTMrLQKhO7wGSH4NJEdJUTeq4e+1zMRdDDiflgu14sDNT?=
 =?us-ascii?Q?QQDw9uY+N09RR/NxK5nqKyypJfxUnyXkkynZDD40CpCR/Xf7maRvREnwZ+eQ?=
 =?us-ascii?Q?o3V+AMaGnJp+qN13fEQwnu6+qsn/lOPGQrxlkKHwqIhE867o1ldDTTo73alH?=
 =?us-ascii?Q?qnwaHk2LYmbw3MZ4aCPEhGif7FYNjSXwYmwBFGqc0leCS2D0SdU3Txs1Y2Mg?=
 =?us-ascii?Q?19ev9AkxYVfdnQFodqthd3rfTbx6ejubwdGct/mtesgTTgIsYOr5lPm8JeXE?=
 =?us-ascii?Q?s+jSr5AfyVRWJ5KlZOM1UhB4IubJvaOl0f3aapiInqMSZbrXVn2kkBMzvR2u?=
 =?us-ascii?Q?58Rxd0EEHkPAKcyQNonF3F/sDS7yE1XDs3LefQYKmD+Em1UOxn9K6W/QLqNU?=
 =?us-ascii?Q?p2oVRfzHqktYXCjlbuGMq1o1za4jDjFKq35LpRvReYDtJnGPbmLAWob70+4I?=
 =?us-ascii?Q?9+A7LZVO2nADIiOVIIae7h1AAilFiIg84UR8M7K5Xp/W+Jxofx+N8Epm8yI8?=
 =?us-ascii?Q?uMo8XXlXPXUX+FJWyP/rw1BOC30Yo9HNEXlZaEsZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7a5ff2-164f-4e89-328b-08da8c84e71b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 01:46:06.8812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiArVPZ/bnmdlnGN/3vjNAvFIQbmdKAwuj45QhoeYgtze318tdieMMd2829s8yst7qUPlVEQfRrZFZa8h/6XSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6728
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netdev drivers are expected to call dev_{uc,mc}_sync() in their
ndo_set_rx_mode method and dev_{uc,mc}_unsync() in their ndo_stop method.
This is mentioned in the kerneldoc for those dev_* functions.

The team driver calls dev_{uc,mc}_unsync() during ndo_uninit instead of
ndo_stop. This is ineffective because address lists (dev->{uc,mc}) have
already been emptied in unregister_netdevice_many() before ndo_uninit is
called. This mistake can result in addresses being leftover on former team
ports after a team device has been deleted; see test_LAG_cleanup() in the
last patch in this series.

Add unsync calls at their expected location, team_close().
The existing unsync calls in team_port_del() are left in place because
there are other call chains that lead to team_port_del(), not just
ndo_uninit.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 drivers/net/team/team.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index aac133a1e27a..07e7187d46bc 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1700,6 +1700,14 @@ static int team_open(struct net_device *dev)
 
 static int team_close(struct net_device *dev)
 {
+	struct team *team = netdev_priv(dev);
+	struct team_port *port;
+
+	list_for_each_entry(port, &team->port_list, list) {
+		dev_uc_unsync(port->dev, dev);
+		dev_mc_unsync(port->dev, dev);
+	}
+
 	return 0;
 }
 
-- 
2.37.2

