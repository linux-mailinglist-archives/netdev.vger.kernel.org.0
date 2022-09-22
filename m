Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543CD5E5B45
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiIVGW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiIVGWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:22:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E0B56F4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:22:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akn+qrVKC7ZRou0otxtEPo+0lC7Erw8FOXLl9RPNpBFqJ9GYr+jZoAEHhj1DCRusTaoYULyMFN/aBjnNv5jvksJdfVJtPYb8VE52Gqz+e1M6hYH09aKLY7DkTJe5RarfLUSIeqDNyQCoOuEEOimRpAaQT1mPbBZOec5xM117kI5iO1dlWkIstBkjTJeByIJofpw+pOmNuUisePLsBRB5DV7AYxWChLaEPhwZ2VCoLe+fcpeMvegrgBkVn7hr2e6ceL4fILicvbH9DwvOM4dnqulVpltFTlkfGaRmRg0Kx7OY89K+s3DNZ6A+A93zduQTgomqx50EsqJ1i9SFGgL2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hX2bhBRYAKjUQcf55Y7gdFLiKJIeB3CJ/sBsv77iwo=;
 b=DyF8CZWCFWzlsM34HlOyIxGwb2a4bNRRLmulOOlT9FrM/6NfMl+vniJzQxB5lGPU+a3cqI1BTM2dUlzEaHd0qWoE15kHXj4U9yAI3bmiV66yPSLFEm1dhZvToA7hp5A0lP0QPOMc81knTf7J2W5+ctyLaDKaYBUfCc0HCqdvQwsHuHuIg+L3GpZD0dHW8pcpGsZt3pfbb/AYt1L5uLFlXeIZkROddoWkU+Yjd2Dt+RbJ2d8EBUAuSYO74aWOF+z9FxcmcRHuyvUU0IXpAElWrw2+VJee/QwVSvClpDNfjk5nu6F4qBI9ZJNEqvlz+zsp9KWqM7R1PehHnztdQ0GD9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hX2bhBRYAKjUQcf55Y7gdFLiKJIeB3CJ/sBsv77iwo=;
 b=RASUCRv8WXPJ0Lq4sRgCiZVJObMr1kYerqaS9HTKWDqtns5apXhu2+vT8tnezWwV1nKxI5k7LPFLaWDRwOi3hZ52nBaqWvAywI6Z/vLxgIvwWVCZqvGk54nVy97h93gQQbe7gcgoKi5URXRFFqaUwnWXovKreZMkE9QrX/ndUQuIX6URdxIKFFWvuQz5eI1G/tpSjObqay0D7IIO2vw6zFJeCyj3n2ft1ytasrhxP30lq5UKtLrCJdFcLRtRUsDYLemW9HTxQLi1RvmcQem411P6llKoPsoSAyaMG30y1bzx4iJoz2b4ses0CJ4Qjm1FvnFDRaBuBIOeSq/LqYqLGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Thu, 22 Sep
 2022 06:22:22 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f%4]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 06:22:22 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 2/4] ip-monitor: Do not listen for nexthops by default when specifying stats
Date:   Thu, 22 Sep 2022 15:19:36 +0900
Message-Id: <20220922061938.202705-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220922061938.202705-1-bpoirier@nvidia.com>
References: <20220922061938.202705-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:404:a6::19) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|DS7PR12MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: 312896e4-d9bf-453e-d972-08da9c62cf36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JlsKTti2MijWO7KsfUMR+FWkimA1K2C02SZtBRpXjn7FV8Hdgg0MjLWIoWhqR5qqeBYxQViVR5K83kr2lCOaqKkeal3DzRBTVRYNvZmQH1II49PxiKz4FdATWCfmoP9oxwAaltOhq//fI7UdtFwA0pjY9veF0gB5UnyI3RzfKRE47z/5Z06IqaFetaMx6l1igIsCKXOcu/MH2StXNLLnxNIydLc0z9V8lCQEOQ8hBNbWbBNJgNkG4KAr7Gz4YcRCCgRgkmtVTpC22r27Ta/SxJf1Y6KE/OpQNQyNJaCOHukmYRqDZwJofQ+n8grZN6fSLZ3pTv56TToElhITeNA+I4cWOchSfet6/R6a9PUqw/p5qSki0CNolqgWYN6kD8s8/7O8ixAaLCuG+cQ/fIonCD5RTtnoEsvar78t0sCnhTt7f2bNKwSdgLgtGGsLBX5GA7vBSoH5dVc6uGGMAXJ+TU0kjHKurvJNLLVgKIWzr7qu+QV4TAc0bdZpRFzan+kmEuS9MMQr3NWSsAZYOQb/y1n55IKKRJWAQ4xa225bV9I2Lz9mvXtgiuF56gJEnhwonMAePALRpHLoL6sxoNObuGTip42OCyrsUs//m+4pJxScjBV2RfZwOn7fcPUgT3/iA3Eveza85mYMAHroq++c2EbpEpthijpo8sf36IiTSSlj/pzmzsNwE8UCP8pL6rcDHWlsx8n8h821A2zDihjWug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(6916009)(54906003)(4326008)(478600001)(4744005)(316002)(6486002)(86362001)(8676002)(66946007)(66556008)(41300700001)(66476007)(8936002)(26005)(6506007)(186003)(6512007)(6666004)(5660300002)(107886003)(38100700002)(2616005)(1076003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5mQLk1EXV/9paAw5i7zDXmLGDbHrBSrFTCq8YeYPhYRrhAjfhVKct2MBLdlM?=
 =?us-ascii?Q?WG1aqc7uiapElVEClHoSdVllf9+rgrqStnHBegvaWGGpKCrzN6W2mJva0dXc?=
 =?us-ascii?Q?077Y7wBiVAuFwW8pWuH8oCEwGHtVdmSmpJe412YlmOBN5eaNnSeb49hcYfUU?=
 =?us-ascii?Q?/Zekxm5no+UDpVHVjb/o0xZROqRhXCSvvG3WtfmsQJ4tlDIMqE5uJnb+0fm2?=
 =?us-ascii?Q?Ze+D2CKr2ER9iz4gsIBMhZUP5Ku4iPw3e9Rhw37ltkYNwAMhKbswzmTzzXAC?=
 =?us-ascii?Q?g7rkrotlS0OUJy49OfsF72+VT29VCl4coe2lp6UOGD5j75hozQDh2SbKciiT?=
 =?us-ascii?Q?d27dbAClw02deirFkU3mZH/8uU/fmALXoxRfhah7GiveeX3xRYmJvcU7uffp?=
 =?us-ascii?Q?bllYIbuCAoI20mXG0kaigiSgIOd8xSahF5is8DogSJIkO428ViGIEoxlSmFh?=
 =?us-ascii?Q?b+LU7kX69Dqige0kAOUueOcbkRgA+YRn4uv+700UTYuZ1YdwVXtU8VdUy1NX?=
 =?us-ascii?Q?2kOrSXJmg83Cd3JrEGF+9XyntgbYpYNVD5QhSdA/uTfCSUBgf1tu4kcHLQ2P?=
 =?us-ascii?Q?nhgaRPlUtnluLQ2uSep0wDXn2lWocZdjXcy1SuseAu2SLHwQoNOXKlb5i7Q3?=
 =?us-ascii?Q?ULbT+KqoJiPQanGg/m++BwRzhWA2b8tsgQ1PnRZGIc/+dt0v8FnlO2SV91R2?=
 =?us-ascii?Q?7uUhdyvspQzTBCJekBSlZoaZl0fAlbms2HFr0LyOa0EAKKm21u09iXhNVj3E?=
 =?us-ascii?Q?01RExKTTtW6lWwW5TeybEcHImyA1I/vn/H7JHje+HJBVl/kSLIEDjzc9VKJO?=
 =?us-ascii?Q?ZmV2JbuIF0v2pPqMAkQdGrP1C8soI46LMZV/WKEREBys+fJO6PZT6Qw37beP?=
 =?us-ascii?Q?MJrgVriBim3Ot4OIa//D181iA8ZL7QdZMQJ3aY0Mq4nLZL6eIgJ9X8qyJZ+t?=
 =?us-ascii?Q?ZhUxBffxGiYE0/4PiOTPGvP2xi4FUuZAGDhLBgW1SMAO6koqM3wl0SIsQ3U8?=
 =?us-ascii?Q?W6n8wnmsI7HEa9ohsLXtcdtRbi0qB+Gk940yPfVqIblN8bfBkwu6e5oQAMLT?=
 =?us-ascii?Q?SURFk+65730lA16M+GJ61Le1xUcHmJSrf/fO6KxJQkH6H2hjB7Fi2BcPJvEO?=
 =?us-ascii?Q?NFfSOAYDFXd2OeF8yb2HF0yuYYcuOwJFL5EXRo4vds/uhSe91GEkUur7Rwgp?=
 =?us-ascii?Q?CulIefFTtJTVrLzG73VHpR2ba9wat3XBGooBb2OFFAO3jvZ+Q3cWXKnE1uCL?=
 =?us-ascii?Q?cXTbiEXtQkbQhjkyDzCBCID1raqsyk7O9iGWjOwZAq0nH5Zw1Wt6N7Ji3YNW?=
 =?us-ascii?Q?Wrozqdkrl3qMdHl6TERXd2MlHiqs4zTaC/S5yhKUZsTiJ7VmIOU+Y3RkwjQG?=
 =?us-ascii?Q?7+s7PGa+G1dVWf4ZeTTmdx/V0gU9yzfUWTzdsg5njxnCF7YSac0o30rtRDzv?=
 =?us-ascii?Q?Sb47AHveEJ6qro6HOsnebYhYMnW2Wp5Qkna82RvFiJT3prj6Z/7AvaI1Sx8c?=
 =?us-ascii?Q?Oqp5ADXhRZGxB0KkzaaE/IzJ/cLuZdDgrCmGAL9q4ckNG6lOehLXqq8f1wBm?=
 =?us-ascii?Q?CNnfZSMT5HgiviARQK156Nq4UT0LvHPjfCuvNeVl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312896e4-d9bf-453e-d972-08da9c62cf36
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 06:22:22.4334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0w5KBBtbUW4cBJyDrJS37jvhl9vK0N3Zc6PWxfApg480sdUp1xErqF4XcIi2xKO0fvDMOeGbEoB/z1UnN1JBcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`ip monitor stats` listens for changes to nexthops and stats. It should
listen for stats only.

Fixes: a05a27c07cbf ("ipmonitor: Add monitoring support for stats events")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipmonitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index a4326d2a..380ab526 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -262,6 +262,7 @@ int do_ipmonitor(int argc, char **argv)
 		} else if (strcmp(*argv, "stats") == 0) {
 			lstats = 1;
 			groups = 0;
+			nh_set = 0;
 		} else if (strcmp(*argv, "all") == 0) {
 			prefix_banner = 1;
 		} else if (matches(*argv, "all-nsid") == 0) {
-- 
2.37.2

