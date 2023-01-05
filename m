Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23DF65E5CB
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjAEHET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjAEHER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:04:17 -0500
Received: from outbound.mail.protection.outlook.com (mail-tyzapc01on2050.outbound.protection.outlook.com [40.107.117.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C245548805;
        Wed,  4 Jan 2023 23:04:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mw9ZFLeaPSbQK301zOuyJGd5KW/x5iLYjlc3cwdmRL8uyRIDjh+x6GA4+dQx33TyCrzVrfEI8kIQWGZyqoOmhkAH5Dx0FmhzOXzb0QfY3Z1QPvhgrL/xi8aYRjSj4Udb7UFTW/OPgtKA67ost8mFtpW47rK6yg4cncQXP3+Fu80VqQNg7zdKvm/vT5adWvjd2RFiOAkWQDvBm6hM0SicHusmYpXg/AeoIgvUlCZaK+2ZmwEfOMwA7sRZnRMKVzpVerPT1Mp9Vs2eqiyOZt/V/tgyNtuYR5IYeJ9FykNx8MIYfCX7zA4emtHrM7shOVwDAdj/ct16HIVcl4JXVD9PFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nf2+kPQlHRKB7B/O/OwtpAougFeZGusNvdexzj42HQY=;
 b=V1gb6cH3Uw+S1aIPiwdZNg9gEGjd4UERxQ7+ysckVvMiLWo0QVY5pHgqKZZTngVRkhAxZI4JUGSFZf4+DlaW3mYgyaD4r587vKCrnPdcJjNgEWLStb8WjLSkBsAMZcuq/jDDrYtXCTG9/qFDzRleVJOA+xrUfdsX1f7b9H1eb0Yl76q16I6k0iiuZCx3qwPVJDKQkKbDk4bBO+n4XIMBqRbYrMsDf/SZAtSbY5P5ZAMBaRVAQC0TB32E38XuPFTANVDtzmtsBwtF7Flqs6GDBVVN3OFu9SV/qZvQ81ujGsbI+gGugEwkKar+pHoWIf5VIMgx/2mKxDNdvi3tE7ozRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nf2+kPQlHRKB7B/O/OwtpAougFeZGusNvdexzj42HQY=;
 b=fd3uDxhqTS/2Vv0zH1rU1PHAZQsIfMKMQEsHCn6sO9WF/xFS0sxdWLu9912ur9ol36PVG1oNojx8hgkWx1TH6DRy7WJcZ0fSAyIXOIl69W28oSsrQN16CSdEA5OFLKe8qC9jErHOcZS4AgNsQ8ZPC2EDzsvaObCX1oAI4El2mekfCrWlyp0TwgYgoKTgakaomAtBuAkVlJRxwoQs0A2RkiDLv6eRR8E03jAcjDaYCbNjdzFWvER1a0ImwAGqXhjzPCVdWnNi/w5CjvIbNGMRtrBARJ1e3vP30xrrV/UzkRJi8J7q3SNWA+ZQiFayEndA6SiL6eNCndoIkY6CkD6KuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by SI2PR06MB4489.apcprd06.prod.outlook.com (2603:1096:4:151::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 07:04:13 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::dbda:208a:7bdb:4edf]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::dbda:208a:7bdb:4edf%5]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 07:04:13 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        398776277@qq.com, Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH] vhost-test: remove meaningless debug info
Date:   Thu,  5 Jan 2023 15:03:56 +0800
Message-Id: <20230105070357.274-1-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0105.apcprd02.prod.outlook.com
 (2603:1096:4:92::21) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|SI2PR06MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: 63332dec-2d3d-4313-d315-08daeeeb0d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Byoqfw2DYeX/nRfcVZSTnNiEoXJvXPWNsbN/sPif/TKyOE/kUSSQsNjzffXio1WD/+zFAvaCi5K/6xzT0qX+kTSyqxgyVvZtZBwvhJoHXrh6AmoZZoc8qhQsHMr+wS3ZGqst418XySaSbkhBOowoNGFTHvQadLG7GJfnQ318uap9PUlCFYV2mEyn5rb9CGxCnZ5ZXW6cWWTERJwaem3gaE94kEt0kjNKnCulSfscPuBwg7AGHwwIKJqRuW3OoMAITfddiR/P4rDIEK+9atIGkbtrHb+g1sJjwj+Nf/TVVvNRJ4TMxwBKVB6/v/7zkigQQ/Ft7n45Bm0NZaoAxJLhtvhsDAF7zA5GHELwmrg9N80RjraK1DZQYXwdB1vJro12iI4ifslGMH9x2heBM3mWDaxNYAQzCrono2aL40UFkySeWgfCuDrxxhvKrBMpOzpZx2/wT/cfk08FqnWK50Eh13Vz+ACzUy7A+xu8aV640e5fInl1TDU2yf29E9vorVo+mLBSUptf7XMCcDFf3Pl0Xg1KVV1OAz2Yyv/3LbqG3EjCq3SENhQ20QM63+evBnRrybtsDG9OsV+MlBcGwhUm7qqCnrbE23F1m7q8gzOIe4KpynyD7ZOfIWWyf5UcZULXkghN2Pr6Xh38aSclXHVs4GR3JINP1p/+TfxQ8L30lb2DuoRtduBSUxyAlDZnuVGHXdMNGhZ0eviUXdOTZp0A8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39840400004)(366004)(396003)(451199015)(83380400001)(1076003)(26005)(186003)(6512007)(9686003)(107886003)(6666004)(6506007)(86362001)(36756003)(38350700002)(38100700002)(2616005)(4326008)(41300700001)(8676002)(6486002)(2906002)(5660300002)(4744005)(8936002)(52116002)(478600001)(66556008)(316002)(66946007)(6636002)(66476007)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LtSCy2qCmd5t3hPIuzGIg5i74q4qCUjvhnJANIsIX6j84VDEJ3YZM9FHhFeA?=
 =?us-ascii?Q?C+kaLB/UYpvJb+ZiX1T6RDTzhVJQ79YAAexHD73zTQo+X25tInjPOX28SJ7y?=
 =?us-ascii?Q?RQCfsyCFHtlwWCUP11HtCkpkeedgQuiPc3db5R0b1tpauFX1S9lWA0Az8068?=
 =?us-ascii?Q?AId6nOUvpDPud/gIP2WONDEygEs6rZDui5vb9MWN6jMfBmWhUtjisHiPFEkZ?=
 =?us-ascii?Q?UO28ZKHvRrSxNU9JDfawQWgzsmVCotJV0EoUWkOqH2In0t1+wDa6u5blALmw?=
 =?us-ascii?Q?i68X/Q0EDHTlSuzzq/CdiN/Dbgpy2InFByeor2t2aKmB2O5aGmPTqTsL7QP/?=
 =?us-ascii?Q?wXt68DVO33YFLSanEjiEj8CEnUTiHQcnS8BmmZqsFiUNdYOSaN2zjSW2eIID?=
 =?us-ascii?Q?MqZSSBC7tevc9sjxMqC/qiUNnkiTUXKikNFMDY5dNKCjDTjlePxYkJ0U8jzm?=
 =?us-ascii?Q?pNGgUSEUq6XAKM00+H8Q4tN6mVCk942KoA5iwfLr+rdle1zPNUF6ESoNzBJl?=
 =?us-ascii?Q?DsY6hrlqck9eItiYeLGoj1kiiAl97/zPSqu/IsGwe3NMXc5Yjdofdw3RfW5s?=
 =?us-ascii?Q?jt6kTpWEt4Gca0b+auZwcWwypwnQbvJMGRf9lrAIo0FtPaLsLd6HjWrQK/DD?=
 =?us-ascii?Q?GwfTaE4D8F83x8pLgMQEW7fqIRe2K+vUcLP2FhEIkw0TD6jJ5ZvBOrTlJwUl?=
 =?us-ascii?Q?G+868uB1oPLXuC8FaFMi8pVu61NJs7YbTcAiPHy22GPPbBvW+nAFUM/Gem9T?=
 =?us-ascii?Q?C3FOGGLdy5Oulwz1AJF9wLYGy1uegSpYuUFAkS+cw9yDPSbew7jljRoxSyt3?=
 =?us-ascii?Q?fs/gOTo3Nb83/E8uI1MQ2c8VeE1rbWtmkeyTTzCJXno+RQWVfjkjVddi/qsA?=
 =?us-ascii?Q?YrdcMpvVE8yR7a5hav8AMclpzT549az5NfEKNrBtcm/aOCoxpkFISEeaU+eN?=
 =?us-ascii?Q?ZZ+AxHUljFGjf+lGpKsq3Gbqg++UhU5TMBBXc6Ucq4HOSo8JkuzpisSNtYxC?=
 =?us-ascii?Q?uYqaWpmQDSpJQt2HfoCyXy+WrvO8CXowikfUWl6EwU+c/7bPgmsz7CA8LRXa?=
 =?us-ascii?Q?A7Yh8kInKSO0P9JgaJBvZFY3g16YojjD2eCERr5Cyy3W+chrCDnzanr6eIMF?=
 =?us-ascii?Q?MkNcnKlLIIDmTZr/yUTP9wxPojiOtiLoAy+9jKC+Gf5VN6QIoXFwuQI61msq?=
 =?us-ascii?Q?g5GkLI4mKdWz6ioBNnqNWt2pneS5Vtczb+rRy560pWwwsX3yBrF82beAZ8v9?=
 =?us-ascii?Q?UR3TSwAhQfOOQTapEGUSj5TM7/9gE5HfwDfTMC1fmFgx+71Ms8ZqQFopqsiV?=
 =?us-ascii?Q?aRoi420rUlV9Qo+H1EjfvY8hvdHx5l4l/hmTrgK04jwCgVy7xe+VeIC1Acr+?=
 =?us-ascii?Q?sPx3qPjt/TgZ8zsLipwWHr7R9BfMN6DcXxb4a5RRREmm2tgTHNAVW7r3CBkc?=
 =?us-ascii?Q?cdQnkLdHVwWmSd2O1MNvFANaQdtJYcDirDtot/1x6npTiIzAqkrTvxfFTJuO?=
 =?us-ascii?Q?5kpNW7x4dw7tbLt5QVXmMAL4r+RyBgzzn5Jak9dK+aOBrt2cFkjBel4kSCvY?=
 =?us-ascii?Q?/h/9IAUKxfQdHUE+LfKk8JhRnetUfx0XEy8wkE9TtwHAzplHWOUT0joWOepZ?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63332dec-2d3d-4313-d315-08daeeeb0d35
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 07:04:13.5046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJboL5JObrPd+PYRagE+hebN1ew+hqyUbP8Xq3QJ76Diq908GDLq4NC7EBT2/+UFPVEUiwC2b+gpOFuJRlIGfVJAbZD4rIT1mMk+2/IFu34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liming Wu <liming.wu@jaguarmicro.com>

remove printk as it is meaningless.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 drivers/vhost/test.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index bc8e7fb1e635..42c955a5b211 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -333,13 +333,10 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
-		printk(KERN_ERR "1\n");
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		printk(KERN_ERR "2\n");
 		if (features & ~VHOST_FEATURES)
 			return -EOPNOTSUPP;
-		printk(KERN_ERR "3\n");
 		return vhost_test_set_features(n, features);
 	case VHOST_RESET_OWNER:
 		return vhost_test_reset_owner(n);
-- 
2.25.1

