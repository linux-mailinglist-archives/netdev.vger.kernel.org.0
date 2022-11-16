Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BCF62C138
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 15:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiKPOoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 09:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiKPOn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 09:43:59 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6E43E09C;
        Wed, 16 Nov 2022 06:43:56 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGCJ9uK002578;
        Wed, 16 Nov 2022 14:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=FAtse1/m/cAi64LDjeXdipPJjsTqNb3WOuY2l/2xTko=;
 b=rVcjurYrcXscGz6U9IoJaBjiFhQxPlrNZfn6CAGwEsKXWjjC8GWSvbez8XyYRH+4ccEG
 B2Dx5DDaN14ZPk06G12DJHNqSOtn8U6EhPWWdl/8MWCNAYxmt2ftsHY+T/SqXxI7z5VK
 AtEtUVwGRtTaml/+ZZzgezgbJVgCDdjhdVojPcG0jHmLvHD6+sZN6xQlwMBJ3tyNqeQO
 C+coVKr/E17MZJX2b+zFwp9nUrXiaSGLgxwDbdNSms8a8i6YthnDERXt8n4QwMjHM9qx
 MjcomWrYNA9h25iJyEXTWr3HMKxEPJ3DHn+yXUf33lEu7wxqM8DfwgrHWsIm2NvMDVwU QA== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kt2fabd8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 14:43:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+V56XjP1Thq7mc9XbnOkrdzmHS4Hsmffw9bJGAm+phrgQjeulxF7+vLJILc7gh0owrkCqNj8KZ3id6WaBGPGbb1+LRsfJktByclp8E5MIZs0XCV+eqoYrTU79NY/iHAiefzpD1+j9kz/XTr4DpeqCwA3hoSkybtDEAInzViJS2I45WK8/u33HY97gsABxG6uGm8EagAykzYH6u63TBAkfh72IrVEgbtUJuDviQ1Kb5npPASSGZKxiMbvUn7ku8oqOaVIRXywGJ05QMUGWjjY4zqzT8Jy394hx5cmLDTsNB7wjF0O8jpgQDVjCcmLzTimERdQDy9Xxk6aue8dZcnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAtse1/m/cAi64LDjeXdipPJjsTqNb3WOuY2l/2xTko=;
 b=a384d8xciC96whulN9UMkIuXu/mOcNaG3upLtm3gip7CzTJSnl5HkMGzxDrazsBzx3m0kpSqgmC24DKKyA37ws2gXehtP5Zdxi2VEQ5k73TSkq+vpcAIYBAQ7cmRatoURtV+2nTK74gIbgvOBYlIQEYZS33pRyYmDML8UI8HQwUnajA81FfsD/V+zezzXGB1QTszOGwy33CCswGGq/jwk3+0+XUJeQws24xrEV6CSK6w+XqapgSgJ7NLD7StP9M9RsEXzlXGPzV5vzHcVkGksa9MUUfGcnmpvV2hU3F5QU2dvndM3k0Gf7HbvPVDh3yTxa3iZQK/abCIpTTNgLREiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 14:43:30 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 14:43:30 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: fec: Create device link between phy dev and mac dev
Date:   Wed, 16 Nov 2022 22:43:05 +0800
Message-Id: <20221116144305.2317573-3-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0216.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::11) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: f5aff93e-7193-416a-43e1-08dac7e0edec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DW4h6YhBsksv6DX/iZsA3b26F+Ph7TwrMCAOnfGLOK/lS4tKjfuxQsBPJ9NDLqCBKTFlzh+syj9sKU9Jkj0Ve7j8Wp5ahrKOClEa8RSnbYIQynli2IpfH3Tordq7zKqHWeuljalqt77oDPENdt762CT0zrkbu/d7N9ogN6Cb7r1M1uKPoHl2wTEbkBS3i9u7wrnjRYJ4EXmupFfgvCJWH+BjPQA0Zd5ZnKupolXCrKPliUxQCKANbL5O1splwI/upsKYhfNMWVidQcTB2KEab3DIpmuvWgdk6W+WlocLBg/jHNcTKt69jhD/EJOgj5vdtdw4Kf2HJVcHUY67gQfW5RVvr4q/vgM9zptyMXg/G4IYVp7dyyQCq0HWljWwwNNECb549Jab10E76O7pwsa1lXc17Nv8To7Pmu4KGCWiglRGwaJ65fKejqgW1XS/LaD60LWJwhUqHVcQbR+reDHuZcCyZzFKT82JdEC4meThakmmJs9UUqmkthBNbHM26yGR8LCiiBR1YctkZZgpEWTiECuQz2szn3wxWUv37AnqDIramZG2SsKqPhNwldFimMi/MUGa6ixhCuJxHnyeazuXDqghM3MpoPKYz9cBeZET4mpXEkwgpzd/vkZGmqulfuiVP7jKDEtKcLFuM/rvyIqyBzmuARzz+z8mN/9Bv4gqbUPQdc70JkRQDTp/Jn7j+xCLzLrYZSAJZoM+/WmVBTTsRcEoZ85FZ6em+FIPjZ3IFxeDiaHBPn9gGbs+zGDzG4e4tAKcF/PAOwLimHF8PW826w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(376002)(366004)(346002)(136003)(396003)(451199015)(83380400001)(38350700002)(186003)(2616005)(1076003)(38100700002)(2906002)(8936002)(52116002)(44832011)(6486002)(6666004)(45080400002)(6506007)(26005)(5660300002)(66556008)(66476007)(41300700001)(8676002)(6512007)(66946007)(4326008)(478600001)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yrv754TlxHXBFyQjLJmplpMX1gllHkhwPDwL2x7Eet5D5r+LDFItos3JN88w?=
 =?us-ascii?Q?ZB5JJ8UDjJiJSJ8MU8355nvWFs5sylxJRVaUXQCe5z2JDd4hxUNr9LKM5VLK?=
 =?us-ascii?Q?t4622QWW1VoTkkLn8WEV74GF3wnFkWGKir5yXHnO0ZYG769EbqezSnc4Y7Wi?=
 =?us-ascii?Q?/WbDxTsWffo68+FsOwqwXhydpCcmcN0mkFfJ/E05YeZ1dF5mUXZLgmEw1H8H?=
 =?us-ascii?Q?JSM17PXsv30dAsOeCawwb/quFLlX8iKgLb0hsuDP7khtlgEB1gULzYjr9Vma?=
 =?us-ascii?Q?RjQdMiDPdMc6/hWYakHLrwjy+fWyQjnKduxQLkJ5QrJxAdx4GRfGBhoOzSJZ?=
 =?us-ascii?Q?2mAYqm3//5+ddSVX6m4xUfljo5eECoP0poToTRSOmreZKpGV2faTygSqtKD8?=
 =?us-ascii?Q?9bsC85H51lBOOFHlfo1gRXLUg84iYA9Ac2zUwJU5eUhq1Q0wkNK6eF3QIIUk?=
 =?us-ascii?Q?2lCWnkGtzXkOThIWF9onSEU9FMvarBdHr0d9S19I9w1njY/LGLJSZLy2nnfo?=
 =?us-ascii?Q?tve0TQVDdef2sTf7izYDyrXkiL2vq8GkkpGTfwD+g+Jrzzp76EQ/oDFxFEbe?=
 =?us-ascii?Q?YxjIgX1lh954OaNEH6O4QlIvpY7YgASF4IVz7D0IAvE1/TnCscFI89fEVc7G?=
 =?us-ascii?Q?3F/0ZBWp2ZnpG9SxesN/Fr/3NdxUQVSTWdm8yEtlN687Sbm1/FCZ6m+tWOi5?=
 =?us-ascii?Q?0n7At80OdK/354U5E09O/tUULQw1kTloxVA3JRtph8VclYf4nBRM58dv1sDl?=
 =?us-ascii?Q?iTQANLNYaX5i1DtbeO3NLCQIc86Uh1yzUesH3FDrfyrn6mDXUfn/EkHLAyx1?=
 =?us-ascii?Q?fNXvSZrEddhxdcay5MazquPqpBJfoJU+ej3rkA7kBxyegL4O0eFduHiEr/Ym?=
 =?us-ascii?Q?iv4jVfZgqZwsFeYPPTkNxrO/2ye7wPPSzyxOj+59q6v531JKLS8jna/dhcST?=
 =?us-ascii?Q?xLxIPvL/+gc1sgjnp9YDGy7v9z9gyFNnngK9RWIEtzm8a1rnRpIKnvjNtk8v?=
 =?us-ascii?Q?FvEwMmQ+pFhK0vWNuSoMRm2G4NuA5QYmVUdQj9Uq+BNAUgcAAhU+PmD2jX/o?=
 =?us-ascii?Q?rtJjXnsohWCcFr41D9lxH8KvsP/tbz9IgPwp4FSGb5ZKXzo/cxtE0GHSwGOI?=
 =?us-ascii?Q?57R8jLdN7a6ZBCsfYef8XmmgxAfTTkxbMX0dr2m5s/Ut36F4BxnBLzU4Qy8s?=
 =?us-ascii?Q?vzpHhuivdd3gqrDAk3x/lAtow1rS0wwXaAH3yRCd7JPOkQiwiAZ2Wj7xwXgx?=
 =?us-ascii?Q?GGeLRWaXBAfmiaD6dREuosOpgHvar1S7Gq2RJc3TBDJwvv9IaLAK1HgKM8A0?=
 =?us-ascii?Q?ExurCfJsgMD11ofLaXV7JtemZSWJtOmr7Al1eoKxlZIu+iP9SyT67kwoCWRC?=
 =?us-ascii?Q?0rnTyDEhWhm417OL7DHNWho0f1Izg9GsDz61feo4YPHyOj1Yjs8mj+weFDKj?=
 =?us-ascii?Q?bxO+MY9urrsTAgX//jJ7jPPcXaZjoWnsvaW4lXQ6ZrTjMoVS01M0fvMhmGmA?=
 =?us-ascii?Q?mUPo31uwon8cG0/esTvvxpH4+qKFO+C/5PKCS5svSZ0kDQb2EVGJh9L+HBZM?=
 =?us-ascii?Q?ql/Rp8k+aCX0ZmojuWyFvLj3qs2QEVWl62BkOhReIlvh0/Nt4icAY/5drPv8?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5aff93e-7193-416a-43e1-08dac7e0edec
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 14:43:30.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcK89vQqO3x1FzqNub+XQho9qyCVJCMpGER5Pi1MkrIGb4vzGaEYrzsv8UpwUh3L4WFOgEEoMhbPLiPmgkpisxgu9b4US2uKIGFvPi2BhdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-Proofpoint-ORIG-GUID: C5ojkrXWFbRji-fFggq-mwCBjN8xKnn3
X-Proofpoint-GUID: C5ojkrXWFbRji-fFggq-mwCBjN8xKnn3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=502 mlxscore=0 bulkscore=0
 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On imx6sx, there are two fec interfaces, but the external
phys can only be configured by fec0 mii_bus. That means
the fec1 can't work independently, it only work when the
fec0 is active. It is alright in the normal boot since the
fec0 will be probed first. But then the fec0 maybe moved
behind of fec1 in the dpm_list due to various device link.
So in system suspend and resume, we would get the following
warning when configuring the external phy of fec1 via the
fec0 mii_bus due to the inactive of fec0. In order to fix
this issue, we create a device link between phy dev and fec0.
This will make sure that fec0 is always active when fec1
is in active mode.

  WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
  Modules linked in:
  CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
  Hardware name: Freescale i.MX6 SoloX (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __warn+0xb4/0x24c
  __warn from warn_slowpath_fmt+0x5c/0xd8
  warn_slowpath_fmt from phy_error+0x20/0x68
  phy_error from phy_state_machine+0x22c/0x23c
  phy_state_machine from process_one_work+0x288/0x744
  process_one_work from worker_thread+0x3c/0x500
  worker_thread from kthread+0xf0/0x114
  kthread from ret_from_fork+0x14/0x28
  Exception stack(0xf0951fb0 to 0xf0951ff8)

Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f623c12eaf95..036e1bbafdd2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3963,6 +3963,9 @@ fec_probe(struct platform_device *pdev)
 		goto failed_stop_mode;
 
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
+	if (phy_node) {
+		phy_mac_link_add(phy_node, ndev);
+	}
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
 		if (ret < 0) {
-- 
2.25.1

