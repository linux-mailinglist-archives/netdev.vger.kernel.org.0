Return-Path: <netdev+bounces-7221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B95471F192
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A1B1C20A38
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C5948252;
	Thu,  1 Jun 2023 18:18:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153C047017
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:18:12 +0000 (UTC)
Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazon11012009.outbound.protection.outlook.com [40.93.200.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8517FE7;
	Thu,  1 Jun 2023 11:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixonITHFWvlv64PAr4xTFKyfiKUXT+bzRJRXYW0oHiCVNtLHIJYnMl344Pi3TxMHzP0eExAavRV6E8SqeTPYgn1KaSjCdTQ5ogS3uC7qS0+wjdjSqgBt9jWp5YMsdqRFK0+oxOwC7BCLkVlW91qo5k0Y4bxWu3xBQdRIS958AnTqKjlapgnD4+cRwjWwDleKdgQ8sLDd1DOk6VeJTcdMxfKN6IJdbLS0m60AGtYyp9dkjPSgSukfJgMv5mPhlBLptMZNzEw3bMCvCRD7g6Z1fDksNdUm+YILzUAORDstWBLy4WiIhe+eQvJii/nFskmF+b1MOa9h9UJqz/2pIjLGsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghjs5z5mmd1lT6YotAc106XIlQJUph/8bIxbNPbIEW8=;
 b=BH9YuFiuawudvz8F53FIXyrxSRq70VrVQVuZCACaxLk+awhdhn/AqfbNE7aJBZwVGlvDO9ozwBOovFysocgCU13kByrXlIG4hRwAYEYNuXnRO7P4yDf4hFz+RxSb+WVGbVWeNO3ynuJ0CAera6huZLZTmZ/pO9i9LySCVQngq2pHLYpuZM3nDBygjQ8R19CitksovMgouUqPGuIcnlWobBFqWvVG1cU3NCBBCbOgUqyW/twfCnbq8amrCuRxow/Eksan061OametCEzoolHfjOwGYydz0HXFZJrkd8M4Ggt3D3uRPHiJK7W305zZVyyD0QIBhF9FmPpKUuFESBICvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghjs5z5mmd1lT6YotAc106XIlQJUph/8bIxbNPbIEW8=;
 b=O0wCLMVmqVd6QR6gbCHhVHuFXj+LvaYlIUdyYiHEUPR1bxaglueSSLng4HpMkeRRQO8jFyeFNin1S5XZ7GP/K/9iZqW7b78dDaLHCERZPAwxF8HdhKBesWPNF3HSNzNE+7dmTOCbUwPeoXpU2GG+aRwhTNlFM1wGTnhtOCFnlbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from DM6PR05MB5418.namprd05.prod.outlook.com (2603:10b6:5:5d::31) by
 CO1PR05MB7958.namprd05.prod.outlook.com (2603:10b6:303:f2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.23; Thu, 1 Jun 2023 18:18:08 +0000
Received: from DM6PR05MB5418.namprd05.prod.outlook.com
 ([fe80::e933:485f:bd5b:a090]) by DM6PR05MB5418.namprd05.prod.outlook.com
 ([fe80::e933:485f:bd5b:a090%6]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 18:18:08 +0000
From: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
To: Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ashwin Dayanand Kamat <kashwindayan@vmware.com>,
	Simon Horman <simon.horman@corigine.com>,
	amakhalov@vmware.com,
	vsirnapalli@vmware.com,
	akaher@vmware.com,
	tkundu@vmware.com,
	keerthanak@vmware.com
Subject: [PATCH v3] net/sctp: Make sha1 as default algorithm if fips is enabled
Date: Thu,  1 Jun 2023 23:47:54 +0530
Message-Id: <1685643474-18654-1-git-send-email-kashwindayan@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::20) To DM6PR05MB5418.namprd05.prod.outlook.com
 (2603:10b6:5:5d::31)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR05MB5418:EE_|CO1PR05MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e54ea2-fbac-4b42-ea7f-08db62cc8cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qYlamIlCEMBCX5Te14iuGIrUoEBF2+hu1nX2RSO6SxLyw3nGPf5vqrMQL3BDkdfVgEAhczYn0AAc3VMbOa7UhQ5Fv8mblidqbs59J5TFjA4AKY2HWCLv8Xm+FTjN9GN/KXvwleLy9fW88YaeklVXr+9d0nQL0ID33U9+jj+rCGzZQNAgPODDoMQHblcPd2CNHN/4qOFVtGWTRtO9IwrsQltL3QnyfUSsh5OswjwaA8R2npm2S4nI7iQbHzUPxDet5lgRQCMAsji93N2EXlmgCGQ3rYa0pgFZTrhu1iFZwCqyh9UbA+U0yGNQw6WkKUCKA4/yOz/DxLefbt+aIDqVoeYOwLh1DatUimkU0TP+RE+Nzeb36UaxY5lH+eA+MnDMFul3Ix2lEofZgqoSbmdkMFrnne4btg+Fbtu1yNaI5GipPE/fBrraAqdI45/mAT58kO6yRp4InG+MA/KpfJhRBp19PIXKN+izGjPI02EJABqjbkeNT+Da9Np/EsEjjxGBEMEPnMrfFFUZSHEw0g5wk8eJH9TdiRdoZagWfVQ1HB6lTBx1rCX/IMA/XI5bYZovVnScIQh6OkqvH/RTT9yCDC7j8z5KwcM46/D7KVzIlX6I7wAQdlcuJUDdg+ID9x2jVPylEG5oLNf5misLDVGnAyILsnRFvLWRD6vU7Nwer7Rkl7+JE7OQp1YoihVg4gnw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR05MB5418.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(6512007)(26005)(6506007)(107886003)(186003)(6666004)(52116002)(2616005)(83380400001)(6486002)(41300700001)(316002)(2906002)(7416002)(5660300002)(8676002)(8936002)(66476007)(4326008)(66946007)(66556008)(110136005)(86362001)(54906003)(36756003)(478600001)(921005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gjtIvy8lETeOvulURYYK6CT6biYo8fRYlmhNY+2nc4lP1X8+6/qFHCh4O/ry?=
 =?us-ascii?Q?xnuvpTDzE3S29o1NI9qiSR97d6XS+uPt6UXcBvSO/6ipasuyem/9vsK6g+BH?=
 =?us-ascii?Q?61ZnzzsHPG60T+kjvf7uEZAjIom2GbCqvq5wDOAi4+zhio4peoXpd1aPKetu?=
 =?us-ascii?Q?BhKBJiDjrUwcISnUfVwMy2Z3k4bWDieiY05PNFJ5C1K/mkBptoVF+D38FOvn?=
 =?us-ascii?Q?NY6YLp3vYzfIHz+mseH8v8bugOZWx8Jl5+/WsmT7yg4Gyn4BAHuRpgkMupdm?=
 =?us-ascii?Q?B1eI0F+UILukAMaWAQvdeAy4omVbGaiJIHIiGPPapaMbg/inlMKErJRzMd8B?=
 =?us-ascii?Q?ql0gqS+mHIoTQcCsgiSZBloGP+ycV84d31B+WI/kInN+hq1rAVlNCNLEmOe5?=
 =?us-ascii?Q?aE7w9gxEQNreixyJfLrqQrka5ZQGYAarqaopP1SrIzyAhABv4NpR1oYPr1Rk?=
 =?us-ascii?Q?rqDizu0N4AZsDJNkG8qMBOEvkSjpn/HDIs1biYkTXAijwNc61pbo877nNx3m?=
 =?us-ascii?Q?91rEz6FTnAMTQPgdBsr1arXJP/aPQU2DMn4RfeIXhUIH6AZKe5mtiYakSknA?=
 =?us-ascii?Q?c/CG1XmpB0Wsq8Id7I8Y+x2Rl7PHDl061mcztMXCDOayLRAZxOi2ZnlQodlh?=
 =?us-ascii?Q?7kSTWdbskxjf47jMoZr1SmHwFe7MY+kvvWfuhr429/ntv9YB6Ws0hHG+vgRz?=
 =?us-ascii?Q?Znzeez5eLtwv0cx4IOL6e6XUVFBLIr2/pL7+cy9dE0ZIKPMBDen8YhKESIq5?=
 =?us-ascii?Q?b8fnI0uXLQM8O227bbjIRk9CwrYny2RMgsZ3Ql93FlkPzREeFdLHQSExpfdV?=
 =?us-ascii?Q?p231+7uOXgkwMi8DwHOXbzRcUp/MtFzjF7kkiVKuSTL53+PxWmvVQYSflTEP?=
 =?us-ascii?Q?qOzMO6CcQD1W8NHEt6HD9SlAlB6N2lGX32sTT6ypvmpByN3NJtQ3QuvHx2gV?=
 =?us-ascii?Q?ua6S8NtlEIzZ4SzoTu73Hd1CNBJRkG+86OJPBpG0sfnxNhe03mZLNkaDx3F5?=
 =?us-ascii?Q?cLw3cAgEsbe/9JDTwxmAYo4jGpGdiTz7Kii+yChODf4RLEi3O7WKi1GvjcDR?=
 =?us-ascii?Q?Y7rv+WyT0kUSvx4fcHkik/C8G2gX2SZWSMAsJclUkbHhgumiYhNNgq7qvjQM?=
 =?us-ascii?Q?g4gH2KdHgpOv7IsQLKj0/hKxrTVou5CiZ3MOQN+4keetwVpxJGWVmAp0FRHI?=
 =?us-ascii?Q?0yk+gtLuVlVln5gRzmXgMEoYWgk3Ht9JFNTCVx7xuwAUEjTXg5IlAQ/aBBAK?=
 =?us-ascii?Q?+jUxaKiQZ738/uwPR2U7GraykKcRH+19w2Co7Kqg2aRfOKviB6i5jme0s4PH?=
 =?us-ascii?Q?BfiTPIHsZIPvdtbLFsZNGa/dwe35KrVr124yO/tI+Pcya6Ksa+7GNAxZcIIG?=
 =?us-ascii?Q?cjtZXV1WkMv04AW05HU/pwWQmv3p64blWFP1E+IUKVqKr5DENxxPRgzlY+xC?=
 =?us-ascii?Q?WpBMQaFgBX84fZJhbYK2nvgNmfqx2xLC/4mx/p0sER7HTIxI5ppe+8mf0HoN?=
 =?us-ascii?Q?iEaw5UBMN1lUZy/8Xwy6dY8QEYToGqC103uTuGQU+jDwS8IW3mo61beqkOCK?=
 =?us-ascii?Q?pp64S9+z6A3DXvO3lnVzjq0gqeOXlB/+kfpHj/rD?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e54ea2-fbac-4b42-ea7f-08db62cc8cec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR05MB5418.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 18:18:08.2257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20jdAEd9YZjnjh2/LLo8HuRZElxKcpVtagTaV3TfrZvxel46JzPhZ1rwDRQTFLjVy1DE17DwpeFx2yTBUildfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR05MB7958
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MD5 is not FIPS compliant. But still md5 was used as the
default algorithm for sctp if fips was enabled.
Due to this, listen() system call in ltp tests was
failing for sctp in fips environment, with below error message.

[ 6397.892677] sctp: failed to load transform for md5: -2

Fix is to not assign md5 as default algorithm for sctp
if fips_enabled is true. Instead make sha1 as default algorithm.
The issue fixes ltp testcase failure "cve-2018-5803 sctp_big_chunk"

Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
---
v3:
* Resolved hunk failures.
* Changed the ratelimited notice to be more meaningful.
* Used ternary condition for if/else condtion.
v2:
* The listener can still fail if fips mode is enabled after
  that the netns is initialized.
* Fixed this in sctp_listen_start() as suggested by
  Paolo Abeni <pabeni@redhat.com>
---
 net/sctp/socket.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cda8c2874691..d7cde9cc706e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -49,6 +49,7 @@
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/fips.h>
 #include <linux/file.h>
 #include <linux/compat.h>
 #include <linux/rhashtable.h>
@@ -8501,6 +8502,15 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	struct crypto_shash *tfm = NULL;
 	char alg[32];
 
+	if (fips_enabled && !strcmp(sp->sctp_hmac_alg, "md5")) {
+		sp->sctp_hmac_alg = IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1) ?
+				    "sha1" : NULL;
+
+		net_info_ratelimited("changing the hmac algorithm to %s "
+				     "as md5 is not supported when fips is enabled",
+				      sp->sctp_hmac_alg);
+	}
+
 	/* Allocate HMAC for generating cookie. */
 	if (!sp->hmac && sp->sctp_hmac_alg) {
 		sprintf(alg, "hmac(%s)", sp->sctp_hmac_alg);
-- 
2.39.0


