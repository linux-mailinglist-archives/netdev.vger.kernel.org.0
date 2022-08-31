Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99415A7437
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiHaC7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiHaC7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:59:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8487B56FD;
        Tue, 30 Aug 2022 19:59:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UY4A2f2sgp7o7PwvLFWZ4EYoImYvs/ytbyH0Cvc7Ur5DCUgXDX91swPWXCdVL6JMbDUOFNw7NmUYuyExN+8Y6zSMvp/n7J0prEWC5oSkScCf9OFYw7Tl0dYiWKYzIQH79vBaX+ZPPNnZXeJ95DNOMhR49yDOFLUv+fNjl9uOUDKPkjA8yFByW2KfYLsA4lCzqAmMO5pv0t5aDSWkH7bxcYzfJvN/maFCToLS5kATyD5FeDYV2MlwKOtfKqzFPySsqbhJdQtS74TGwwkYlKwVg9VBeK99G2I9BkLx+TYG7Tl6AhAsYVGMmUnx/OYifU2GIX0SMOEKlXbfBxWQ395Z1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYHIz0VxCHVTmlv3CSlw+mc+XQjUK9S5BL1m/q9yjEo=;
 b=bKOj+UUL9XIKdhuvNgX9D0cEPhDO6YMPi8VxVFpEp62Hf+NVOeqwu1XEWPkau53DuHIduiYJka2JsJTg4yc1XT86JMo/D1oGMF1OzSMlqVWc5m5S/mybArPfmaU1SPXlpjNc2fnVm+dE6p4T4OZcZ+5zQyASmLyXCafCiy5xm2IAghAxm3bj4zdqDuMJvEKFeLaAs4D58XLSOWnawZ0WIhBvBt1WSD2TVTtjZ+RmjTn3YkW7nMpF+3NX7ZPAB0RWWf9jPStPy7RXRzEKeI99f47r/nA/HGkr4zSYxKrNYi0Ra+NMKB/bv4VLhYJHxEywJxFxzhh595Syp3Q54Php8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYHIz0VxCHVTmlv3CSlw+mc+XQjUK9S5BL1m/q9yjEo=;
 b=MrCPBqKx+JAqei7IKpBmzUrVuWq/wuAMeSkd/soklJxfW5UkVxmkSYfDj4wwjb4dRBaa1PXtNuIOga3laPtUPo/FhCq6hYHYiiD2ugtEOrwSwBcenHBmy5MIV1QXUeIVC5GKgO3X3hBbqYlmyjaLeQdB+Pc58O/3OIwbZMXXJZrUDlqaBgkpV0ih20YLo0xmNstqeB2SiM7YzfQaLrRNit6gdgea5UeoO6ygLCUXU/gML/rDWTOnNpsYV/O1qKN3uoLxXyx7D7itiJ0oaVsE9z20djw1UWADx1W/aY3VB80ptFkNl5ZZAAic6eoTi8997uOFPBDSywH1/t3jWKWb+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 02:59:15 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 02:59:15 +0000
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
        Benjamin Poirier <bpoirier@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 2/3] net: team: Unsync device addresses on ndo_stop
Date:   Wed, 31 Aug 2022 11:58:35 +0900
Message-Id: <20220831025836.207070-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220831025836.207070-1-bpoirier@nvidia.com>
References: <20220831025836.207070-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0148.jpnprd01.prod.outlook.com
 (2603:1096:400:2b7::7) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a64fc5c3-cb96-4034-5be6-08da8afcca29
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwuPW7vEK62e1fg4hpXmcxyDCK9btAdUtEYK6GjL+Tr1NqJDTeRHQTCG3bZMoZPCH9FfHTVmjzQ4P/gdFmcuKBGyJkf60IXINfS+Jl+7aj64+az16TuWxmPzlsJI4gWuUeKGBApzx18M6H8jeyZPAIXTQotg3rbf1jU6gLyjodmJlH4znzViqaKLhe+C385F38DJCLguuc7zchzLNG1RPYZFqA1qpGiGR9WV4ISf6XNMitAL9ZgRXmin6eqiKrSj1oWgXiIiDFoW8NcfBr/MysNl0MLMjTAFSivfkDbWfuVJE23qf5xiHJx5j0Q6uWO4yzrzYw7GIxwQE71K6yg//Sw6xejQ2Zm3+auCm8eX9DC0RBCdLBj5WBTrUIn9g7RoOAFxWvfhxIDTZvlFE1U+BE/czLcpcXsv25el1iY1xYi7sb33eKBkgtapoEqjb8lg/deA/wbjAob1dLmJdW4DibuBTvxJxLdPa3xunm+mXnfg83BUNh9trqspqNHBxvBWT2YNSfHaoWJsgCzSct+1iLJLOdH75ul8iHbXgIY0+j91j4HBHjFTSzBGqeOXGTFIh5zu5b7JBbJeqkwvFBVIShj4TZ7jgRpDajuyUvt/xqtb51X/redeLlCacNaLXtEx2VL5HIYrsRiFHXEHPsiIYUJXVxy6F6H65Yo6cz4k7b1ujzi+0ek47O4o/FE4O0POlCOoQgbScUE9olbFb393PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(186003)(38100700002)(2616005)(1076003)(2906002)(6512007)(6506007)(86362001)(83380400001)(66476007)(66946007)(66556008)(316002)(6486002)(8676002)(478600001)(4326008)(6916009)(54906003)(8936002)(6666004)(36756003)(7416002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3hjIdvM67k4VVNix56wGJ7l1z9OFqL5iP2wgpaFFO0drCSSOJhfTyKJ1RYxF?=
 =?us-ascii?Q?Eo2c79OOVb6XyH3KAucTOcO9uEnq0jsS2m2Sgxepep3gpNSNQ/gCMToq8Khm?=
 =?us-ascii?Q?1ISBCMbH9+I2mzfBnVu6BuvVgwbI4U1qJFVFnq470M9s4vanyyWtNTOsOyTm?=
 =?us-ascii?Q?SnmR9/jyxrIYasdK0sgBPC/J4WpBEMwePvun7P5+kznmbDLXYOYwNCRe8qyE?=
 =?us-ascii?Q?yqX8BPaFKhNXXyVjTovBVUH2iq7nf8phTUl5eZJegkKddDb1v/k0rbrHlkRt?=
 =?us-ascii?Q?s+nS+44BeKX2+4VGOfYXeUuA64qQLCOFx5+uFidjxyVP9Nq5bTb2L6Dawe/1?=
 =?us-ascii?Q?uDZlgftgi+brtNPfVF6thVz4MR+MvRzZJzIPXFdkuTVS/Qm6wHPo7Nt0QJL/?=
 =?us-ascii?Q?Wdoza+vberpx4euHepTJWfrEIwDjKVleZF//uyMGGVsoBJPUFE/Ym317myGz?=
 =?us-ascii?Q?ygzxWeWFRNFQ5ZOeex3gvClqJ4gMPJFw9We/G8j7cy5THGv6F+WdpMHbbbQ+?=
 =?us-ascii?Q?rmFqTYEg3DKO5fdn2YTbBQaoDOuyCUopfNNxaPGd5q04aNtntv1sM5HKrwI2?=
 =?us-ascii?Q?p+eZBniPDnRcC5zMjfxYlfXrC79le/nqZcTM/dth7GoXDCZjUOQ0hdHJuXPr?=
 =?us-ascii?Q?vhDFy25foKbmJxUKAUfMvcSsGQREUNY2zlkWETvq7w3rS7y6PaFAlVJe8jvu?=
 =?us-ascii?Q?TA3V7b1GmZ5LGBr0rmzd4Oma7Wi38OXCufhU745gfH1dvT14B3MJa7AHi5jN?=
 =?us-ascii?Q?y5O8H6MCzNf8FuCOB8I8NgBpyAj1PXTULf3BKjEqhxu8mYUvJB/v47vd7Le5?=
 =?us-ascii?Q?Z7o6YLn7PIBJQnficosXXUEJ2lGTzIdNbfdHTPADCLGZHq+gz2vWytqIdcmX?=
 =?us-ascii?Q?EJ5JUDiBH/yQe+vWGqZ4HlDSKKFMwsbIcJALqD1H36URlhZXfH/Lf0vaaAPK?=
 =?us-ascii?Q?F2knlO4s1EyTFOWUAYS1MjKpNWUYI9uq7NEl2OxgN9PZS9Nxoe4hUOAzAM6E?=
 =?us-ascii?Q?X1fWtjbwiqB0bRMHCk+dm1jTVg/SA9rcUcWQSuBFTBPfE7I9FUgkCfXDK4Wm?=
 =?us-ascii?Q?UutVhBW1UKVNhrSJNgVhUcwlqjZFYWQC+Mhb9xhhb/OOesB+0+hOnpNDAATq?=
 =?us-ascii?Q?562irdvZ/WXqy8/w1kfB50kAGq0Z6XffA11neXEdvuGHPnQ4ViqOEaI7gG7q?=
 =?us-ascii?Q?GJTKIFbxOkqlMD5yS5e2GTuD9l/UrJ09B+brAf3vVr6cbiFLXBsXIZRJ2pO0?=
 =?us-ascii?Q?Zjdf3BzV0rIdCKsX0cjB8hZajfyLe7UFhHLR8lnmeomEWfVSq+GauZG6zZ5q?=
 =?us-ascii?Q?PcOwUHda0VsLRZOldI1v9wn5y4cS40ow0JY83rin5EQssMr8zNO0uhGgsHzU?=
 =?us-ascii?Q?ut9Yz4ui31QhFIfjZO0pDXZm9yZ/SxeApj/ZKt7sYjtJ1WxLGW+m/F4QNiFd?=
 =?us-ascii?Q?oUudbHVR2vok1l17zLV7ScbJXU+4tVeghrNZ95JaSVOB3XaH5h7jWGKx36G0?=
 =?us-ascii?Q?TGkD+wqgsPStpUL0lxW+wwy+YEQ1FqLQq3SqlIAyP1hcMeIef4d4DZV/kpNq?=
 =?us-ascii?Q?nhz0+H2+5IYVym8BiLQS3TCXTShGWOimF/9uwy/xwZEM9JXPXrv/WY4Tg7dD?=
 =?us-ascii?Q?T63jQA8Nv4LHOKzo4pyrECuUrHJq1z+XFtZqyS64rkmB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64fc5c3-cb96-4034-5be6-08da8afcca29
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 02:59:15.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7swHMNQzVCGnfC/3uyfFfU0UbkkkTwVKH62bOoMJC4kENUA/Qf4qIqbytAo91/unWJibxhNp1UoDCYnb+/4Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
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
2.36.1

