Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975CB56D20A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 01:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiGJXyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 19:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiGJXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 19:54:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FC56370
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 16:54:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WD3/Kvh/Sng/bcYc1pzJoaeaSqozYDRzCq0a2YcnoCmhV0Pa+rYV248e/Xjt5M1gPZOuJtqfa18dGtn8h1RAtPxZpMgb1k3oagtBWHW+IFsZKV9AQ3RINBDHcfEMt85AFA9NrjSbIO9HRbNL+W/ow02BiLPQbjd90apRmJWTodawA89daLJfsTcvKdoHN+U8F2pTj3FT+AErkO1UWHeEU9hm94j5eW+HYnxQfSrITzC3btX7oTxpJDAco+okoW1Fy5yXjWribhC38ibqkdXc7I26hBPZr/grYQqMvHnlOwk6Ym1tfQnibgpIQ5Fj8bsjoP6+fei8icMYjFarM57rag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVCROPtaOXURz1M/u8CM81ujHE+/8G+QIBrd2aBFHnU=;
 b=Gns1bucUXUp3nRRPXd2Kqek8VQBfh5APrfCCSI043sX8ogRvtwK8+qUsEYrMqdIis5Zk6Cs/0l5p495rYtNAic7AXO2qzo/rmC7ZBoe6cZ7dbhxgLMqRfeVwBns7daev4OmilYRCf6IMd7+nhAMo3if87WBSRfgIe2G4fk+aoeih2ASYhyH8xvpIKTKpj+j2vRebzfEG7lcDCFZm3RIUEE+atfBa7aiU4pkQghRiyL/nM6NBfrGZrZTzjj8n/CrqUT5YnGuCxk/gvINgyeO3/6gCqSZqb9pGEKg+tUdlbdseqp4uU+mUwJilGIlrtgBR8YCe+JYvzWGliGYcFGwbdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVCROPtaOXURz1M/u8CM81ujHE+/8G+QIBrd2aBFHnU=;
 b=JAq4N59M0EwsASRgW6E4Z7/ZA9JVAeQq6rcPL6+UPWm+MkT/oKslX+Ze8ie4QnKHXf5Q9p9QU7UOTI7l/56QHKZQ5H76RvXwOfqfgSDTX5Sx2r0zGiWlVAitnb4DFwBmSKy78788B9EZuwKQSGHNBvm1VhT/XRSRVwp7yXnqqsR4TX6DNxj4fAHgARLvuEs75iDDn+HGNXrI3gwnliQK1VzPckXAJTTDEIFnP3FJcl6xzHN2l1Wz9y9XjMOBITO/hSXCAJ3/1mf0HwXTkFe8bHVGTO/8OfKaQMN7baQqrp+aEPKJ6YEK5rpQeJcMq11lb0UocDBCPuSFtm9oc1foPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by MWHPR1201MB2542.namprd12.prod.outlook.com (2603:10b6:300:e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sun, 10 Jul
 2022 23:54:17 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 23:54:17 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2 5/5] ip neigh: Fix memory leak when doing 'get'
Date:   Mon, 11 Jul 2022 08:52:54 +0900
Message-Id: <20220710235254.568878-6-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220710235254.568878-1-bpoirier@nvidia.com>
References: <20220710235254.568878-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0002.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::14) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fa98226-6b0f-4200-8032-08da62cf8026
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2542:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ++S82Hm99JcQuPI0WdQS1hHepCEMOkcYe6ib9e69Eg/RahQMpIf03GOYTlaFtQWazRPZmmuHkmXtkGKy7qSvh1j7wDCExKYyV+JRPoGK9jy4rYCyuT1+KZrBkKxA1OyLw6OOD3pTkUpuFS5ThwxiDpktFHZdHjb05IiaCtpDaxGKmM8/7nefLzsD+LHYr+wU0uYVYbKMtGLa8tNJaxrO5aswM3nwG9FLtzBcaAxd1NK+I0ggOlymkZNaIu/yLlb9ov8HjJnjIH/1ZOOc1f49rxOUPpAPMwM42JJZnfvredD0WRDRqcF2CE1gznGWRRCQkMvGnoIfP6XdCX2Q7ZeB6ALmJHD9Lpw3lLbqWmdtYeO0vKbcyPfa8fcfIvLxDDVKeXz19tUt32GuS9apSkPF4N9j2Ia5xh6kd6Wr+1SQl34f5uPQAZhnsX11E02Mx91Do0qxoU0kt8efVNbMt4yiPvOc4BF4+zCSVd9Tw+VDj7C3rK+5Y7pdhVLUiD950iysByZugnB8WLUGUZ+Mtydd4WKynLA5Qj7mB9sUvpK01jQ42AnqBNX1ZkTZtIJb9FqTU8WoBQTjZns5t7FrD0/C0nsmMmDNBEgb2bEwdC62pDv6p6HzpDKsi5dL6O7phL5X8T6SzuoPt5BAumyebotpmpZl5l22SrFMhsO0UKklqpts7g2k3n64KMGRU4oMQDH6KFTK5bg2N4xbW0xJBobgy8d4zQNYjmwrhnd0e5yJt+eOoracKN63YuonpKkoss/l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(186003)(66476007)(8676002)(66946007)(4326008)(66556008)(6666004)(1076003)(86362001)(6512007)(6506007)(478600001)(26005)(6486002)(41300700001)(2616005)(54906003)(6916009)(316002)(2906002)(38100700002)(36756003)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cleIbi/585GZsQyWPiH1Jeuk/AF70uoSYUiUEhIe4e4h1fEFwoYk/SUvyTBQ?=
 =?us-ascii?Q?tdn2Yd7EpY6OSHHAMWPsKczCrU2JJKqaS84VTmULYbhtovr/TywJLzQwezMx?=
 =?us-ascii?Q?kZdtMqOpbctoxG19l69ruAtthdqD2CNEgYfUo8jmkY4kxRzeUdZ0bmVIjhjl?=
 =?us-ascii?Q?GZMnKX8k7rty8DT68PZHffWxe0JM9oEMka0b8UV/UtbNxzVzPhGKEb82UnJ6?=
 =?us-ascii?Q?hwJVDsFQXAL7LneWJMRMLp96GKFNuy8xv+6U6o575Jasny2pEjeYJ6KZ8zYG?=
 =?us-ascii?Q?BdzJMA/5n43N7DN1uWW05QVWzlzyFQ3Gd3fTVszOzwkGop6Lm77A4GLuBhGk?=
 =?us-ascii?Q?zSmp0YaRJnJrtwBJUC/p0MY+Fskaq/hmdhsglsft//h11tj/VofqMpTK5CSU?=
 =?us-ascii?Q?zoJhE1hWEyG4cjD7dfT22J8DumpdP7JoBXWXuqtDmeEV/XaKlZ1mg3h40XDn?=
 =?us-ascii?Q?dhjwKqyqIvxOcctKikL/nvlwag95CxXmWQhlwghz4dQZiYURPMgFaD+4K0TN?=
 =?us-ascii?Q?JEEgxsdeqZCi+y5fiRz2pyH+mZVco1oJ3SgJoeYfv3GxqnX1UXyuCH+uZf0q?=
 =?us-ascii?Q?WnfeEygc6OqZ1+6DvltTTu/w9C05Ia1foGRABhTTIN6IvuLpv1+UW5x12afQ?=
 =?us-ascii?Q?qfkj+R4bq6hpumQ1w/LzDyPP+rg+rspn5XYdawvH3JIk2djEg7erWCeNjXuP?=
 =?us-ascii?Q?zhq67E2sycReoRQMmfajuZX2EvogfU7yVQqCBaaqwvnbjg2PXvXcybCSPH9O?=
 =?us-ascii?Q?+hEyVwircSys9+rS+A1uYUSGcVi812svstgoFvKbd6v8DJqQfzroD8bRX7X0?=
 =?us-ascii?Q?puGL3MaH6Bm7vZvEkoarscStaBLPKChrAFRXzy9udqUMBBIYXZBzV1HIywk6?=
 =?us-ascii?Q?w+DTdSn4Ge5ZzLqcbh5gJnZqMpdIL//YWBHD06zm8hMDHtrzYvQ5AKOaB8cm?=
 =?us-ascii?Q?bUUYx8Rg0oW5vEMI8SDFEWvu63W6D833TBbm4MhGstN4a3qe+ySM6jJUp8mC?=
 =?us-ascii?Q?phvqoncJRt7RcmQrzKYDoFl0WqLKLgQGlzeL9vlBMU2AMP3EEu7nADrm+IGT?=
 =?us-ascii?Q?LKmR8aRXZBMFCvZmNfcSNIdHxD1dsZMdKnSDq4859Wq3c7+4f2L7g3TvewYX?=
 =?us-ascii?Q?inbNEUSL6x7liu7Cj+0JNZWgbS7uN2crwFOUp1wjdjHw40E8PbykmSFw07fN?=
 =?us-ascii?Q?S05IkOmX8QxdLEM+G2VDfjc1rjL2hpILCS4G80yXPDcsrCX9xPoRALG6ynmr?=
 =?us-ascii?Q?FsQLxDRWzF+bQoCXmhKKs7GzNQveVE39OlvlaTc9wcOjkcoWQ6wW2kPK+Tyo?=
 =?us-ascii?Q?4zCW927PVs/uTqTmeYoE/JUKds+BUugMWCK5Qzw37oZdq3Mj0dqVDweDifup?=
 =?us-ascii?Q?ESJ98/FogDIJJtObGPrU2TtXhu0cHuG0tlf3agAVv/87HR5zbk1K8ljRZdrM?=
 =?us-ascii?Q?m/8oyUQWl6eJe7PC0uH9M95heMpsZp60UjSZ8Haeu2pi/AjU9q5vlMg4/Rxq?=
 =?us-ascii?Q?FsnAHgclcex/Ye3hMpa8xCl7fmMJJZzaVf8Hq0BAheFTfQ+RGtmkPdL64Ew0?=
 =?us-ascii?Q?3jrQZb+S41IlYeQJj959Sg6k6xdSFeomvVe8srUX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa98226-6b0f-4200-8032-08da62cf8026
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 23:54:17.5667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqKyOM4oFQ6aj316j7xsDSAsth5Jxeowzezv25bsFzTh2iB8bfbV+YU4cgovi9rNLaxnniS/ravyPyR5U/Bm0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2542
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the following command sequence:

ip link add dummy0 type dummy
ip neigh add 192.168.0.1 dev dummy0
ip neigh get 192.168.0.1 dev dummy0

when running the last command under valgrind, it reports

32,768 bytes in 1 blocks are definitely lost in loss record 2 of 2
   at 0x483F7B5: malloc (vg_replace_malloc.c:381)
   by 0x17A0EC: rtnl_recvmsg (libnetlink.c:838)
   by 0x17A3D1: __rtnl_talk_iov.constprop.0 (libnetlink.c:1040)
   by 0x17B894: __rtnl_talk (libnetlink.c:1141)
   by 0x17B894: rtnl_talk (libnetlink.c:1147)
   by 0x12E49B: ipneigh_get (ipneigh.c:728)
   by 0x1174CB: do_cmd (ip.c:136)
   by 0x116F7C: main (ip.c:324)

Free the answer obtained from rtnl_talk().

Fixes: 62842362370b ("ipneigh: neigh get support")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipneigh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 7facc399..61b0a4a2 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -731,8 +731,10 @@ static int ipneigh_get(int argc, char **argv)
 	ipneigh_reset_filter(0);
 	if (print_neigh(answer, stdout) < 0) {
 		fprintf(stderr, "An error :-)\n");
+		free(answer);
 		return -1;
 	}
+	free(answer);
 
 	return 0;
 }
-- 
2.36.1

