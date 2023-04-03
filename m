Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809C06D4297
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjDCKxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjDCKxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:53:17 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED1711E80
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 03:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJFbUgbEolsBjX+yzpq3jsCfv14ivZGgWcutyXBFUYbt7O74EnVyx+Bo4diOvbL4xsP/q1MmNng3VY5Hmiqertd84zkxTUINPWi2bilWoLdfWTTOG7Y8LtWuf3M4T9vFQ3PcLLLnF8JRFsIl124ScJmmIJnZ3VLOot4Lz1s7jTl9YaH4lSisheMJMeNPFcSzg7zfeHcOclbB/HLNm5HFT45jlWyZMFNnadOKk2lyrSArwDVrpvWK7rm5GwkM1kCKNB8ZrpVZlDUyCotXbWXRY3x0kdgB5UZX7l/L+GJYxMFQ+YKBN5x2I880kSyBopfENVIed8WLnJl0YdxA+2zkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znKIrnQN1WZHub+seDYhYl1zpdGk2QQamJr5UkNYT0g=;
 b=MGr38/upMSVfN91oEb2r+2AZVKlOmSJD/pJRtwvolaUiVK4afEY6sLExOQDHqH7kMSawfBnKWIh44DTu6mcJypdyhsOLsp4Unnlzn1ueOWGLACdCIt+DaNxq6b0QZk3IW+OaHAAClPP1UZ1ztBNNKJ69+6dKrzPFVyOTtsviOTyWvFd+l7g2AZBvn9WzuahYoXoYx2gB0tGVtCF8WpR21nu9NHB+u/myZLEQKtFUgB6I2vmzWAFH2mGhDj0Nv170RNeEZDY3cDbRce3PRXMPQZbOM4BRLhcV2DJ18MwdOx0Yfy3hUocXti5+t2zMTwpgWNjDpgLPIuPrT57mFbOSGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znKIrnQN1WZHub+seDYhYl1zpdGk2QQamJr5UkNYT0g=;
 b=DigGmspdc4HqUZZQSkNB7oR+qi3wt0HsGeIjaDs9xTjR02r18Z5UqPrW4HTDCTc9LcMOw+L0CjUUfnKk5cXGNqh8P19q4CI7mIQZxZBJe/OemUwWdVHE8OXO1l9YEPF3vjJ3UNqaGFn3Yg18H6ZAvDhSbBbk9PR6j7jVF76RbRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8479.eurprd04.prod.outlook.com (2603:10a6:10:2c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:53:04 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:53:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 2/9] utils: add max() definition
Date:   Mon,  3 Apr 2023 13:52:38 +0300
Message-Id: <20230403105245.2902376-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 640f5a6c-08d4-4910-9ed9-08db343199bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNKuRrwtItpGnMh8XaknCbfg1WLXfrJ3FIqLH38T3owKgwbEyQ3FwVVVn3s2Z1fsPI3noRkbAPfxxhxJvqkgQT3VqXhijtUfyJrQEfOZm80Ydosj6IosGjBq206C+TAXTMH3Av0WQPOisKFPn968YjpL/Sgry/ld4zCE7dB9I5wl+Kbkwoknl6mUMIqnoa0X1XNK517dnSOVm/lrcmf5QWcSNUbjKrEENmcAZsszbxhLIrh+EDo4qPYReZtH0HrFkDHdWG4sLss+A/mVzsb6E4yWY2ITo3FpTCfKkLycBsbWgapolWWSX+ZXUN+GQHRKG3vOoWgZNT1CMLMBI4jeXLBQ8MWxG1KCv0SeJQQPqrnzGXL3CXFfZ8SBFZQEyS6jW31MKjrVZwr26uYuFWsBsi5u0QHHXdABW6Hm878OoMHM7YGUOwxK8mNnAp0+VCe+jG7AkoWgGUVNeiz4sE+tXqbKy0SO9e5IAv4CJdmHYBmuwxsXPEDgRWrwZ6FVSGIuspxOLcNkM8p6ZVSYTqn7Y5dwfxAjhwlmeoMTnvHNRZuM6VSng7LdlSG7W9K8H4NchzdXApBTjoaBrFenvc1LGMm6zVjETbFt32P14gRVAIeFN0TXCCZKJhYFDXqfKlOi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(4744005)(8936002)(44832011)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aOWvkO8KRio0KCDC/BqEZdU0S8ICs4uB23ZVDMFDn3MjaX4yRryE5g3nDouH?=
 =?us-ascii?Q?+cIVXVbuII9wrBFAKA2ZweMQ1ze09+OHJgBP50cSSPCmR6zaCtb4GDJtCUi2?=
 =?us-ascii?Q?BlrL8CCti8EL3rydb23fMrHvx7s9DAwMeiQaBtPK9SW9X25ovZx2NCpIng5X?=
 =?us-ascii?Q?p1Sa51HW9K8Mc2tMrQmvhTmnYWFtDwBWkYeffb9CYuXHkl4e+jIueT21qrVd?=
 =?us-ascii?Q?CJIYnYpJES7DqZCcgPBE4M3fhZxqtsxr901r4juUs45tIFjVRRaJO9Xtvzdz?=
 =?us-ascii?Q?lpXXm9LKqZGaz+scF7X2hdeffkMcdfUSrUfhNZSS2cQNvv+UvFhVHjVGYkA2?=
 =?us-ascii?Q?eXQKlHLPlkZqpIZ/xk1NV3Wfr4dmwD8vjaSMpF9VhL12YHuYuxZe8aUf3+r5?=
 =?us-ascii?Q?XuMzZRnFN1bGQkaOS8eqawIId8xWa7miEaM1lXkt/oC48D0qZBCXxQ9SWIEe?=
 =?us-ascii?Q?IITFG/g3kq2QCSGD8uAQe79uTWHRobt4IVpBElCpDhiOS8x4nduefd0EA9VK?=
 =?us-ascii?Q?irIlKtUwYLezZLxosijirJ9+alrz8AUE1Zxn71t17YHVAbwCPy6Z37FAni0n?=
 =?us-ascii?Q?THGZfqG2Z0C4f0zT/8GPCeb1q4K9BwbF9kO31VP5SLXeApYvzvKZ+nOBpyIN?=
 =?us-ascii?Q?BkXz5oEmekn8xrK0hxolEdFDHyb5NlHyGdYTxx+3/bypaxx7ZYsvPGFhU/EU?=
 =?us-ascii?Q?jd3qvWSP5zqUbAL6UpK0nHNCwezLJNHmDgX73c3stZKQEHQWH9HsG8LMLaz1?=
 =?us-ascii?Q?RlcGOK4WkplDY2WIhD5QzBBIV18hWwauIukAYbemcjm5mfjvieYrVrkjImel?=
 =?us-ascii?Q?t1K2uDc7zoqRsnyg5E/OGH/TdEjzdDLnaBy7R/N6aJWKDAuwH4N/S3+kDy3S?=
 =?us-ascii?Q?G6ZFqpfE1TKZ1xscy5u6w2U53p9432iJEHU3z9Q6mlqTP/cokwnIfmLSTxn9?=
 =?us-ascii?Q?vILWf/lIM7Kse8ds3AnE4cr5OiuPBLM55bpvUEpLYA0J/89gu0McJeddLU7x?=
 =?us-ascii?Q?04Xxw286T7IJiTc5oxeg57WMsG43n5zimYSdtfYfwn/cO8my82pq49H8flsv?=
 =?us-ascii?Q?qlrAsoeEz8r/BfLa2rA0yANCoFPXSjdi4Peafp/3lohhp/6njGvDwKERywrN?=
 =?us-ascii?Q?94P3qQs1SHX4m7LSVuMTRexKjUZqTJnjuXggLisbZ0wZgzFUp31yALL83GWN?=
 =?us-ascii?Q?628XK4JIqIafJXKnzB8rFDKo7lE5k4rZo5LDMJU7Ot8tfjKEV7V5uUmt8xeh?=
 =?us-ascii?Q?bujtk0hm8k4YSgLjYuF97FVNiGCpXuua3cMccHuCEVOIh8Skf9F/8mqVJ+8H?=
 =?us-ascii?Q?JLCYSH75hxQVRjS/P7zDgqvZxJwWxt1b8/NqSQZ/mgBZhoRF7TyyJcUDXRD8?=
 =?us-ascii?Q?+QIBdq6E71xVy+K+EZiy8Qxnrp8ywcAMM4HcxMDl3pzjWTtlZTkSd/6ztc1P?=
 =?us-ascii?Q?Tl4CPsRiY7RacSDfCE7N+RQJQFMnmpbTGvbt2puUmtkdxa+yZiCckuikAoZ3?=
 =?us-ascii?Q?WrXpYFAMm5ZfACUDOfATB6LZS+2CbPNoQHpsJG9TyzLUp5FbcOYO0WDg7XKX?=
 =?us-ascii?Q?olfHSMv/Y5qrkx66+fy6vEzfkUPJC9mK13ztBwSh18FoVrnSK1cv7MoA2GFL?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640f5a6c-08d4-4910-9ed9-08db343199bd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:53:04.2301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXYgfXag7pVv1K0FYdGM8Fdps05lV8fmq7YaXsB5bOecA9Y8ewJFddb9RsTdiOXWXSUKWyjjUEDbhgLmfI/kCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8479
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is already a min() definition, add this below it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/utils.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index 2eb80b3e487c..0f1b3bef34d8 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -284,6 +284,14 @@ unsigned int print_name_and_link(const char *fmt,
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
+#ifndef max
+# define max(x, y) ({			\
+	typeof(x) _max1 = (x);		\
+	typeof(y) _max2 = (y);		\
+	(void) (&_max1 == &_max2);	\
+	_max1 < _max2 ? _max2 : _max1; })
+#endif
+
 #ifndef __check_format_string
 # define __check_format_string(pos_str, pos_args) \
 	__attribute__ ((format (printf, (pos_str), (pos_args))))
-- 
2.34.1

