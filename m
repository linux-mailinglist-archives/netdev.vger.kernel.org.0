Return-Path: <netdev+bounces-10977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A38C730E43
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F295281478
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B085395;
	Thu, 15 Jun 2023 04:45:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACF8386
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:45:32 +0000 (UTC)
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020023.outbound.protection.outlook.com [52.101.56.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D692103;
	Wed, 14 Jun 2023 21:45:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzGkBbwmlrQ+vbL4boljzzjKO3DSVZziGc7Hm1A/+XZMGt1skQABJGBXS66H4vwudn3/m4K2ggZB2maYUH0DPNU8ZJcshIb+F/Snh70PUA6+EU0GkiAN4paca3h2NNFBWN7LD7YSrB1DUV2wlkzVD/N67/SB5Vm/Pov6BWqtU9NwXoWgHTEIPtAyrOEPpe32HbfIthziVhTPSR75BBMUq5nrviUbdYxvGXySACt22UP+nhG9cw28k43E6sxIp46K/o4u2kaDnr30ieGNOny9U2s0rkBaQ9nxa5dsEvslx/AARCMoF7iL/DkoDv2DszdLCewdEenAWawgYNiQz9zf/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpbFp6zAL9KzMEQ9ZVlu+BVte1M8zyGgXB62E+0okMY=;
 b=maS3/bAiWs16vcl8lfHaHjLMbS5gJgFSF7FWmOCr7RE9c1SrzcUFk3L5N4nRL8qpAnLSiR1GvhuKX51cmGJLxrZsjvwyG3idBKQer/FvZcjObvxxyw6g3sQJqmi2Ubf3wMgpo7hhZ48RUOzLDfhlmDr1NPjbzgsW7/DJJPsbFnnxVQXzmsvt0k/zqSnDKKy2Bdwha3GPcZx4RVdCmjBxnVKVfn6kua/OpKtZctdZlmqm1ucfmSZ+HNNeg8uGND65jMbdiDey7in66d5Rq+/XD+X2E3vImTTZzIFo+xv0zzzlF8Wy9k0mk0+7anK5/rp1Q/Zidn2/Nk/isInRWHdMOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpbFp6zAL9KzMEQ9ZVlu+BVte1M8zyGgXB62E+0okMY=;
 b=AyUNxcJv1lNqj7k8G7HFGO9XYXrkxFyeZQcVwEUlvM5JuIVkTZAzqvfvYEb1S0pUQ2OmAVGTbuWfZAgeCLnS+lCZlnmi/Pz3sG0EvFB87lxBJrooRKNYkJwv4JWs0a2dnTRTm0vMJ6953RTsBeUd0vxK+Zct2PW5QXAHta0F8nk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3382.namprd21.prod.outlook.com
 (2603:10b6:510:1de::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:45:27 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::e673:bfeb:d3c1:7682%3]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:45:27 +0000
From: Dexuan Cui <decui@microsoft.com>
To: bhelgaas@google.com,
	davem@davemloft.net,
	decui@microsoft.com,
	edumazet@google.com,
	haiyangz@microsoft.com,
	jakeo@microsoft.com,
	kuba@kernel.org,
	kw@linux.com,
	kys@microsoft.com,
	leon@kernel.org,
	linux-pci@vger.kernel.org,
	lpieralisi@kernel.org,
	mikelley@microsoft.com,
	pabeni@redhat.com,
	robh@kernel.org,
	saeedm@nvidia.com,
	wei.liu@kernel.org,
	longli@microsoft.com,
	boqun.feng@gmail.com,
	ssengar@microsoft.com,
	helgaas@kernel.org
Cc: linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	josete@microsoft.com,
	simon.horman@corigine.com
Subject: [PATCH v4 0/5] pci-hyperv: Fix race condition bugs for fast device hotplug
Date: Wed, 14 Jun 2023 21:44:46 -0700
Message-Id: <20230615044451.5580-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: CYZPR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:930:8c::25) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH7PR21MB3382:EE_
X-MS-Office365-Filtering-Correlation-Id: 79955498-005c-40d6-dbf8-08db6d5b56b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	32l+P2bUhigoBobt33e1owO5G299ezfc+UR2UZd4assKhNZq9TqfxPIv1se3TQcJ+JsFxeEjSfSl8dFunLezRzbwLmV0ynDnptH2KJhs55qQIf4rejYFit74z6Kj7aYqvjrlATV7xZWpRPi7UdsqTLnwhg9NrBZCu+CI+zfsVMV9AqxM9/MvFeOnD4FKZLR//YZn183q9iJUwHsQZ6C/7xlNjBRqPzG1Y09hls27jfRWmpJ5aL6k8gjvLYV6UxlMfFwUF8hUhCW6xUAslQ4huCDS+gI/ibOz3c0f4YRrovGce9h48Gh8XyB/EkQP+xhdc9n7FepxEbeYv/47AMKqL4SP5BBSdJ28a8nvnQ7tqqti2KtyM8GzPXhMUhtqSJ0mfBarTurX/gzeiQaUNTFRPaE4uScXKEOA662e3n7WGXDLKCJPACK5qQ4NekMYd0INIfqkKO1mwZdeewm4Q0WAVoIwvf45A5aPeeS8/KsPzzjSCDHpIRmRzwl3ULX8Cf83Xulhd5YVmrUCbN8P1S8cOwtruTR3ymHXOYPVbXbSxngsy+ea7PNW8Zq6Ks9oA3/IVo0IcXIVwxXaryUlL29y514tA3NR4pE8z/Y/JElNI5jgpF0v/MJMguHv/OYFAU4LrlgKkLiXda4WWchDBs4Sgg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(82950400001)(921005)(478600001)(82960400001)(8676002)(41300700001)(8936002)(10290500003)(66946007)(4326008)(66476007)(316002)(38100700002)(2616005)(66556008)(83380400001)(966005)(186003)(6486002)(6666004)(52116002)(6506007)(5660300002)(6512007)(1076003)(86362001)(7416002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tKirXgxlKgFJnAjqAsy4gZr1siAu2gCZZKZzMABDvY22pIndnftc4OP+n/cv?=
 =?us-ascii?Q?dbBzBTWUYou5rfEUvlTBnwivEW5Jq8A+UuV/LOK2YbOC1lsCV6a0v9WVTSc2?=
 =?us-ascii?Q?LqSYQajJT50sNbM2KuWATZ0QklYjecsFTBSeokBwgtM7k7wn3m22iBJpIdYf?=
 =?us-ascii?Q?WFFtzESTVLfvG33awXc+HRQrV+vp4poi4a5yK2YSY06kgABPWZzTcZjQV/bl?=
 =?us-ascii?Q?Ns33ASW+ptB2DLjbkiXPdAdBWhOFSsMdG9rYegeyzKWXy4A1YsFWwaP9YfVr?=
 =?us-ascii?Q?vXQtfjC0Uv9A17WpbFIWqsuoAWQnETcuFsCTvEIL7m9YNPw5muH7hwUioeH0?=
 =?us-ascii?Q?4RrccAM4u/cSgLPEZw8nk2XHa2PO2Fs6ccDSWFgV/FL8A3rSXbmWYcLQYYiO?=
 =?us-ascii?Q?pJXNlepAZKaKmxGwH/f0M0SpfGb3g5On1kreM3HAs+2uFNE62Wx6WrZp5aM7?=
 =?us-ascii?Q?sXF3t6OauFePrmrBUdJRBZ+004bgYBChShfsiHBkC7R5w6tJxgG78VYkQ1My?=
 =?us-ascii?Q?4Z1b9Fq2TaVdnnaYCvHh+KTpcUKX1909/VcuqXoH457/GiYAAeWcA94XmouD?=
 =?us-ascii?Q?21qbbZ6aZ53MC9xiUIs2l0cmnBjVMYHCCVi/3n2SSfX+LK8NvaiptpADYtOX?=
 =?us-ascii?Q?o0CANOLgzIqjSBwc37qyJL2R4jbUt0hO89gK9rkJYyupH9hAZe2v5MfzSq1r?=
 =?us-ascii?Q?DqGUHeUfdtK6yh3jAH+qDsyYbPqgL3VaE9qPuPw/Epr8hR7mbrSkwUSVNWDD?=
 =?us-ascii?Q?1gEBaCKWxQnaiktCHP67tqthjnzUhjhGMWIbs4Ub620a8IS92cxP9kVEh1ef?=
 =?us-ascii?Q?PWAIoiN+8VfjGHFsEpzf2GuvnOQYoU2NF26zzSxEzjXp+PhnOudmp0+pphoU?=
 =?us-ascii?Q?fRVSxLCRqQGVpeVZ4N8zmc0OQ1Q+bEfr77S5pgU2YJfWjnAu2yUAUmHw2Z/H?=
 =?us-ascii?Q?XG68mdrEEpG3MqFcG97awpXmfXlyJy/bVIdiQzMnfr0rtI8wSMiD33f6Gq7q?=
 =?us-ascii?Q?zoU+w3W5hONnrcsRI2a9Ms4oUasWLCxXlwbvuB4bYJ4u/SZkmd28h7V7WmVE?=
 =?us-ascii?Q?8JbxTTykfCVrOzrbZDWAsRBT+Ko3AIPkcJve6HO6aZW+142j5m0R0yLhD/Xe?=
 =?us-ascii?Q?ni0D7dGgLGJDoEW1fmUHCO3KFMAl2T1mVlBOkP/kw67pZSmBXqYSQYOrawni?=
 =?us-ascii?Q?Uls3uu4W+Cxd6IBP3dWGF/iIa3IibP7DHcVmE+6OrURdw+9/nyfjvCCtdkxt?=
 =?us-ascii?Q?ggTc/Vl5ktbifdVoTqbgOKpiGaHzbPnGi+gK3prq1CcD62ZFri2n0NMNPvKW?=
 =?us-ascii?Q?J2zeG3XinklX05hh8Npzghb68AlrC7Pl+GJjbWuwX9j/rwS/0SVV9uhSgcED?=
 =?us-ascii?Q?FXk+6GwQYhF7FOf8KZD+JjrsCLLcgrGDsG5L0ge3ZjpBef7bt6PDzs+eaKhV?=
 =?us-ascii?Q?2Ji3ehqKWyrc454rjYR8ryn6VAvOEK5JIDCeiuq1vq24/ISXPY4LMu1b4oxn?=
 =?us-ascii?Q?Oov8rcLpjep86LDVCIkY/Kfas6WzyvoEc7C8mbZfOP10D7vmkAj+FwdA8rvW?=
 =?us-ascii?Q?OzMa8i4lgCMJFcETgzqbvgIwkCXjF78ynKtdqoQXiaL+AE9ylxW59l0qsx3N?=
 =?us-ascii?Q?wjJtPdp9Is+jlpTxWPWNeZSuU4Ij0sDU2SOobeL2zXpN?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79955498-005c-40d6-dbf8-08db6d5b56b6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 04:45:27.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBdlG6gvb2eWaHwn/C0DQwcxmBBHP+XgtvwJMKcP6cmzOkp1s9f0Pg4Dka0t+D/kuX6/tvHlcZLGDmVAlVEZrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3382
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Before the guest finishes probing a device, the host may be already starting
to remove the device. Currently there are multiple race condition bugs in the
pci-hyperv driver, which can cause the guest to panic.  The patchset fixes
the crashes.

The patchset also does some cleanup work: patch 3 removes the useless
hv_pcichild_state, and patch 4 reverts an old patch which is not really
useful (without patch 4, it would be hard to make patch 5 clean).

Patch 6 in v3 is dropped for now since it's a feature rather than a fix.
Patch 6 will be split into two patches as suggested by Lorenzo and will be
posted after the 5 patches are accepted first.

The v4 addressed Lorenzo's comments and added Lorenzo' Acks to patch
1, 3 and 5.

The v4 is based on v6.4-rc6, and can apply cleanly to the Hyper-V tree's
hyperv-fixes branch.

The patchset is also availsble in my github branch:
https://github.com/dcui/tdx/commits/decui/vpci/v6.4-rc6-vpci-v4

FYI, v3 can be found here:
https://lwn.net/ml/linux-kernel/20230420024037.5921-1-decui@microsoft.com/

Please review. Thanks!


Dexuan Cui (5):
  PCI: hv: Fix a race condition bug in hv_pci_query_relations()
  PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
  PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
  Revert "PCI: hv: Fix a timing issue which causes kdump to fail
    occasionally"
  PCI: hv: Add a per-bus mutex state_lock

 drivers/pci/controller/pci-hyperv.c | 139 ++++++++++++++++------------
 1 file changed, 82 insertions(+), 57 deletions(-)

-- 
2.25.1


