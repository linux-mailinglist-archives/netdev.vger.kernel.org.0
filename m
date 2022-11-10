Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE33623DFE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiKJIwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiKJIwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:52:37 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D923D31EE7
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:52:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJfN+VK6I98RYLiYHHJoJopyG4x5QcKLXsAUgCFncIJ7/Aqk18ebyBGxGxsjtg8zc5SOs38AZTTwLLvnF9JrPH3rKkp8pMa3RRBCB5KuC2wYoTS4rLzV/FMK/QXRyYptLaO/MWrkkp3hC9tUVSli25NerAxXiB3PV58I0k1adkagD22Hlo1jyeB+BeCmtPhSUFIQ5yaCH9XEeHggOuwe0otvGZZxEEWO/uvsmDwi2+jMSEe/xabNCFHE9cKK+a79HecdZb6BfLDxK+u1KyqS74F6EcAU/nlWny3/WfgNO4k45Z6jogoiBsiBE9xoXAVCIwNh1/gHTmbrtbd107sLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVkDDitFia2S0MxNjJT7lvf+NSRwbYuwZTcgjiLkWHM=;
 b=HnYaL6ImKWL7f0nGG7y7FnpLtPvV9osTTp4OTSeMs4r6iMHZcCKHyjiz8sbc7o++TRYtvG1j9cVOftJTQeqCpxtSKBE7M5K5s00ZCQPWlq60j83Ecq6qKhv4XtVkkpW4LmIZOvwXxVHMaQl2iZjw5hNQYdZR9cqiEd8Ocp0sEfgfSGaeCyHTSZvJyiNiM7jZMq3rfmZRi/BGKcWesl9yqrNNo3oGy8i+fe+jmsUs55n7DeSOnFf4ORx3/Vu0u2WROXl6EKMWMl5boEqqd6ixDtgZwGTnEswGL2SkRLeHF1JpW6hlcCXc0LiVRw+JNrNPT+xB4olopeMaBmR/SU49EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVkDDitFia2S0MxNjJT7lvf+NSRwbYuwZTcgjiLkWHM=;
 b=mu+i6YGgQbN2W5IUGdUXXXGIzbiimzwRVB6+YdwzTkyVlg0qG/gfW1IxaYJ+FlScVVRiMMak+40pB4AhCYEpZ0Kxl2FaUu2t5qvVS6tAPfZfPeRhFNRH8Oio3X3hNXysd0klrZg7h2YO2DWEOJn1ztZ9F4/KxyWZgPMnKtKeNcPlwyip3imT1dcwvPrkLEsLXF4s3vBSaZiSvPhlrft8ePf9GJdDxG1xW6SzTZsDzWKu9N8+LlznrypxhSpl1zbl9oSIuWPVb+nl52qVEFOcJReEf+kz6BHrIu7vWmeUB8aVMfuVGtdnOhdFIGBE9ILnw/ny+rGhl4sv4e8MUWFYGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6181.namprd12.prod.outlook.com (2603:10b6:8:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 08:52:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 08:52:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] devlink: Fix warning when unregistering a port
Date:   Thu, 10 Nov 2022 10:51:50 +0200
Message-Id: <20221110085150.520800-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB6181:EE_
X-MS-Office365-Filtering-Correlation-Id: 4829549c-fcdd-4507-7ca5-08dac2f8ddda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVflqz7R4ga85FQe1SxBQi/uaDyNFt11jPVbEQQh7ljCj//5sn0ZBUWlWpgzGQ9bTPYoKuSLHDO8iZfR3brPWAfhbaGJJT7BuTADIgXtKF0u8gywVRR1rvbIMEVXKZw8Jc/7AAiQ0f7BfmlA8MXYyGnzaL60fiCW+7Al9yvSr8px+RhtYm2IB3zMG+QSsYwaLL95F8EQkVgTh2cu6s8ZMUAennaStc/qnqOtDS0ck7MLsMN2EoIRK0NHedi/+A9f2YXNFnrsFqxHiaBkYslzZecQ0Ks1B/GhM8Z4bKOcOw2sY8afLpgV62fj7/+CrkpwGcoyt4PePlI4tZ7U/Bv9luwALadL6PwyoOuCtJZoeSgOhWDBCePD1FmfYZBNcFBIo+s9iyTD+zAgx6N7OjdZPu9DaITpqnX65v6VV39uxHlYaMqad7smx5P/KtT0mGnhodctoiEyQUZtgvp2zzJu6QqQ3QmxhyzxFruGzg7jSBGNrwWPllZXkIplD4+MZB/+yeKILifMaf+am9dVejJrkOVU3hdZp1gVsWMqY7ucfBaFmdv+n6uvqoXMedaWpHmltwduQfOywvOllEpf9/tfRxYqNeQz4PIpdyon9l2pZLvS6nyk+IR33J9TupM6xktCXLnkgbNcZZ6Wqqy8koG/g5OeV31/FbCBLVZ6WZm5gvgGh5ZOqORfSODx+1lD0yhoby1NN5cp0xUZSKbyGfmL8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(36756003)(41300700001)(66946007)(8676002)(66476007)(4326008)(316002)(8936002)(6486002)(2906002)(6916009)(45080400002)(66556008)(478600001)(5660300002)(38100700002)(6506007)(26005)(107886003)(86362001)(6512007)(6666004)(83380400001)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?34D/rapgIsXy95rTf9eq1osVPj2WqPcS2qIf9FpkCcReqFAcPAimo+VfDlrD?=
 =?us-ascii?Q?RAjhxq7xW9qv60AVj5WJUYmb6NWkA/ge1ANjwNZJRmaAAVNYzvzCmTIfJST4?=
 =?us-ascii?Q?fjZ9oR6WlpVn/eMW5TkGkRkcLEtOQThteVS7Z0B96eG89xXJWEizwnS+lD/p?=
 =?us-ascii?Q?gm4gAm+tVgXmiKKJAhZaPer5oRAYrm1KIG6R9IibRL/eFmlb2N9WvYOET80q?=
 =?us-ascii?Q?3dujcUSNGJACxZnzrk++upYg3RBRxz8Tbjl9xyVKShffCAvn7znkvnUsiAOY?=
 =?us-ascii?Q?26EMdYTHS9vJy3uhPomzhy8QEzTEdIje2LkPMqfjV4jx2TXjcUpP94H6qJRo?=
 =?us-ascii?Q?mQcwEJzlkqgcNMoOVESnDQLBQpkOVzpfHM7v1TlVknPbpukc94Myty6DkLvK?=
 =?us-ascii?Q?4OyGj4zuy47XGkv07a4bfF6yLGPwFH5keDiEfi0gMzW8K9Q3aiMVquJBLTY6?=
 =?us-ascii?Q?U2HP0QkXX8pPoZj5S2tmjo+JOLvtFrtpoBWpUc8Fx+YLY8lWMGvfZFp5UhWn?=
 =?us-ascii?Q?zTgVx20O9xCZLXo02ouYVjoJQPuvSx5sdOHdTv/7ruSwWY2i1BkrR3alH9LK?=
 =?us-ascii?Q?TgF4LIEJFzQ+7fmm2v61I6mtjArVCjFcezuJD6QyMy9igPexcG7AnBK8/bmH?=
 =?us-ascii?Q?mwGqcze7EAkXjDxRvGTrY3KitoaFQ1mdg3Ej4jKCT8h9FKReN0OAqkPmEaja?=
 =?us-ascii?Q?wUuAdoqGGBdYWHB9yFp3bZ+B+NsBhC9oN5PPn+w/U5KclJYiMyNZlGAvmboG?=
 =?us-ascii?Q?Q2IEIqkqcVh+592J6ADbzXe6hiX+Qf6E3B68PYlmHug6ueF6T9bmYEe3wC+S?=
 =?us-ascii?Q?8Vu7b2taxVnqV79nntuuodPAHVpFStoGZnxvpp9T5Vhkou48ugl6/zQ/kpZw?=
 =?us-ascii?Q?qkpTiH9yPXFeX5BGWql43vVv+fToywE5gcTN3111E/zoCEbc/0glV/Y0HjaT?=
 =?us-ascii?Q?Ttf1MUq0HFuMU4uXuGXxedZ5LH+j3k2RxyU9yKSH69MaJIZ8IqXnVcdy5SPE?=
 =?us-ascii?Q?PxgW/0z9qGGe9M9F9PAjywwlEpWo6vmXVnQX83pbeyzuL5Zcs9S1F6BFHjbN?=
 =?us-ascii?Q?WJFiyOq75FXUMdtYcf6WY5u/5OusLvB0xkX2yGzWjNrRuaYP8nOicK4ky5if?=
 =?us-ascii?Q?SWa0TvkOYqln/J1r8YZPsXRIGqdaAkDhDESipXak7Cw1mhj0tiIF+yqHpYSN?=
 =?us-ascii?Q?0uX4yXo4EPmjqt37SG8EnvyNM2dGJPyWjDMDBsR5bNrh+ULEeuRAxsdj/T5E?=
 =?us-ascii?Q?d8E2nRasMQKpfXBzHFr9Mxtb1fnFpi/DeXd7fHoXoP9wyydTJk7rmbfIzcwT?=
 =?us-ascii?Q?qhWtJ8OW+Oojau3FYUHDlakgjj05c9krDmKZOqN53rw2/geU9ppEG75+kgCf?=
 =?us-ascii?Q?1CDkZZ5Ja5CV7H2ukm+i9T2ej8d1GcRRq3N1u7Qkunu03mKh4rOQVYK5ph42?=
 =?us-ascii?Q?Qrgkk9lxnQ70NjlV+oxvKPHUD7NBizfE5oRS2Gu9B2LpCw0JcdFPbSTcS7+2?=
 =?us-ascii?Q?QOt6sXAKxjXluC9x+oXwMqG0whuEYb8EslXywHlHS1q+tBpZ+4TVfyGcOFHZ?=
 =?us-ascii?Q?L9mHjjOdL/tcoxBzHI0zV+T/kqZvfWaLqG6C+v8i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4829549c-fcdd-4507-7ca5-08dac2f8ddda
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 08:52:15.7513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2vGAX/lqRpJsCQgCCIyio/dQTq0Qc8Y450sEjfw1KVFk6ojOBhjTDEXGQUxSNzfGWid6zvZdxfg6/19HCunXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6181
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a devlink port is unregistered, its type is expected to be unset or
otherwise a WARNING is generated [1]. This was supposed to be handled by
cited commit by clearing the type upon 'NETDEV_PRE_UNINIT'.

The assumption was that no other events can be generated for the netdev
after this event, but this proved to be wrong. After the event is
generated, netdev_wait_allrefs_any() will rebroadcast a
'NETDEV_UNREGISTER' until the netdev's reference count drops to 1. This
causes devlink to set the port type back to Ethernet.

Fix by only setting and clearing the port type upon 'NETDEV_POST_INIT'
and 'NETDEV_PRE_UNINIT', respectively. For all other events, preserve
the port type.

[1]
WARNING: CPU: 0 PID: 11 at net/core/devlink.c:9998 devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
Modules linked in:
CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted 6.1.0-rc3-next-20221107-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
RIP: 0010:devl_port_unregister+0x2f6/0x390 net/core/devlink.c:9998
[...]
Call Trace:
 <TASK>
 __nsim_dev_port_del+0x1bb/0x240 drivers/net/netdevsim/dev.c:1433
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1443 [inline]
 nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1660
 nsim_dev_reload_down+0x6b/0xd0 drivers/net/netdevsim/dev.c:968
 devlink_reload+0x1c2/0x6b0 net/core/devlink.c:4501
 devlink_pernet_pre_exit+0x104/0x1c0 net/core/devlink.c:12609
 ops_pre_exit_list net/core/net_namespace.c:159 [inline]
 cleanup_net+0x451/0xb10 net/core/net_namespace.c:594
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
Reported-by: syzbot+85e47e1a08b3e159b159@syzkaller.appspotmail.com
Reported-by: syzbot+c2ca18f0fccdd1f09c66@syzkaller.appspotmail.com
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6bbe230c4ec5..7f789bbcbbd7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10177,7 +10177,7 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		 * we take into account netdev pointer appearing in this
 		 * namespace.
 		 */
-		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+		__devlink_port_type_set(devlink_port, devlink_port->type,
 					netdev);
 		break;
 	case NETDEV_UNREGISTER:
@@ -10185,7 +10185,7 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		 * also during net namespace change so we need to clear
 		 * pointer to netdev that is going to another net namespace.
 		 */
-		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
+		__devlink_port_type_set(devlink_port, devlink_port->type,
 					NULL);
 		break;
 	case NETDEV_PRE_UNINIT:
-- 
2.37.3

