Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5F6F0061
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 07:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbjD0F0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 01:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjD0FZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 01:25:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B2C268A
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 22:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPrIDyhRFKZCDYQ09gi/qoRhX9WB7UMAsG6GdAXR/fbO7JOnOowENu6dspoHsFvqAMvBzXlALJrTfv7R5bPZ0DoToYqnnfW0l6P5dcWvDylamzlMXehd8dXo/AEUPE794hc65HBVoWoY9ZtKYBwdYTUL3GERoQbE1HmpMEMWxvy+MxE5ZaPrkSROSVC4zAglVSe736xZe8AOuGZElUmd91oCS1qp+0vAJLsnJ2mYNrHYYFjvrYtiuPS9Srm94cB7+4LQMk7d5OQVT1h7AV/kkLcywAtNBXc7IedKdiKiDcSI50TD9J/nZEy3KZU7+PH3dBIUJPoox6ejn/S88bXR2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLVe4btwT5MpE1uyI9JhrgbSjERMKwdVun2tmqoGY7M=;
 b=kVrIcg9BgdIjYn6mW2U8Ux2o2YZTL+QcInU7Dd8sWJ5YXBv+khOB06r0rM9+mtOBmNrx8Ywj8woe+n4b+avruKCuQKmEqfv6n3XfCnPzU5bTXcKYhkS91hbTY6c3XGRaTo0F0G57mSgJh0TDmo6W9zZn3aiLHD0w7NhGfg31dv59Qq7jIHv1FeRYYAm4LrAD98EVPH41JA9uqNaeLXxnb3ftMg+NMDYenmAgq2TUFJNrepaOk1Ug5vjEniwEYEqbmWWLkvJDZsU8lPQvE0n0YIlNyW4Ks5HYc38c74LrrtT1Yozpw8p5cZr0W86TiVn4U32z9jv5EtaPwNjF06dSzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLVe4btwT5MpE1uyI9JhrgbSjERMKwdVun2tmqoGY7M=;
 b=AUQsLu1pl0fCH38ESZpV4VN9uPVz0SY89fFWW2vq9AAtRb182zzZVGbMu95EYhiL0OVKQjddrWlHfQnjVFK56NlF2cHvhy3hCA2zy+nIgHnFySbILeb/u7K8FyOEH5jF/Hc2rH6Lxz5NDI729h4G9HzIzGSu2dlvZwXboZarHsTymD0/8IINwyUHlg6ubdlA5w18EVUQsbrFnryf6VrhtuSbmqdYnNPXTR1IMa/zM1z3kSdnh7FqdJs9CaDu33mpzHSBz4N4WNvZtCiQmO0cUEOChL+Rh/m5ppvPczsX1oyukPKbxegPzjWN3+ELJQaXuoFl8yhrm1xJuLuLiwSxmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7661.namprd12.prod.outlook.com (2603:10b6:208:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 05:25:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 05:25:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jiri@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2] devlink: Fix dumps where interface map is used
Date:   Thu, 27 Apr 2023 08:25:21 +0300
Message-Id: <20230427052521.464295-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::49) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e29f329-48b8-472b-f22b-08db46dfde97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRB4bpX+xzAY7RJyvlSTtqACQ0QErSOvvrZ8TWqCAgWwmkQRPRiB/1ysOQ8Srqv5OAzxSlPMF0P17Xnf0M0+aTsAvkb/qk3BTnFNaZWhF7IByOgasoioQnsyNL4IoJyX1JtxLKG7TpcivWVM5G/iSLtosS69bWWba31621JYUfGIL90dB2ADf6LKVpQ8Rc+6FDH3W/v13DiemZh7QsZFH4x8M9ZW5z12sOwiayNB89bn1CUnJ/0is6STBaZpGItHIiajzgxoHIRWFe/NZ5Mjuvyqrj8NXx7yL2kdVJ2gId89xFvowYdyu9ZjjGZZE69ONSQQ0K/i3M+9O1Ftoup6kwjm+K3eyQFlwPr8waVDVAHw16LCyZMYGgnVxa0+Ux/T3yRGszaOKyEqEoxL77R23eLJE/fuZwkcJv1vlVMxwRTZ/h3qdi6O8hNdqFiNWQ72Fl9a9LqCn9ms0IqGsJQQoxQDwjVJQpqNIBvw7qhuvx4nQ6yOLrQxZn9ZNI4LFajQlUcFMUTL6babfE1mOJfFS3XfMQmdur5cNcDK87zQ2adSQYr5tLIkKO3WGaKB5HvA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199021)(36756003)(186003)(107886003)(86362001)(26005)(2616005)(6512007)(1076003)(6506007)(66946007)(4326008)(83380400001)(41300700001)(6916009)(66476007)(316002)(66556008)(6486002)(5660300002)(8676002)(8936002)(38100700002)(478600001)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pe7q3roMJWDQX1jc8CsrfIdv4kgOGsXdQvzFOy/gih54X8jQEHQ+jp2W5TfY?=
 =?us-ascii?Q?1lq4RNzT28fE/rymWhUjVsHC3jcFMEHPq6nBD/N3nXMLPA/fn/9MM8dzdoxf?=
 =?us-ascii?Q?/Xf4DsOtUhylEDiV+qb0b0pqobf+zBTcG0s00QtYI6vJR4t5K8JcTukxzyr0?=
 =?us-ascii?Q?p9GQXWnSkYQCAxYr5xUBlK+jIQm32oEuXKRci7H4TsxAhN6iXcdAZaEFqnek?=
 =?us-ascii?Q?VgFtzEA2uG/6dDiNRUa3zWoRQG3pFem5WXj2hpGS/oZOx791eVklXsbVEZud?=
 =?us-ascii?Q?ZOkR2AkPs8sQ5vel7X4WQYNkk8MJVwwtQfwbWGkoIMibzqyY94GwTy2L9X+v?=
 =?us-ascii?Q?CZaBlEza/YlramZB54HRQp4piEP++GykIXBPpmc+kSvqAfFfr33IMsxMWxIo?=
 =?us-ascii?Q?sFh+L58ZPRB32QKCP5Faxha1wsXe6epe/QB03ilKPSTvVMLDFLg2WzsvOSY+?=
 =?us-ascii?Q?zV7Hj/5GXgHtNhfN6cv+SaG/6lBUkhcS9w4BPyQ4D9M9dpts+mZZIXquwlCF?=
 =?us-ascii?Q?KC3Nry6YUQHn6XQmsryNARCbyfYc4gRq+Q7YIvt9SXd7/0RZ+Hd3Qi5NFf+l?=
 =?us-ascii?Q?AdaXA1djPpnmiKPq9ZnswaFnkcKuBuUhhj1/8zI2KMuDf3mewqnyZfMJV1Fe?=
 =?us-ascii?Q?eQfnUVjPre+CL0ZsRG0SEoijVj76MoPoSSBZXPc/KfxW0S9YqwldOXkE4gyf?=
 =?us-ascii?Q?gzSRRASI/KAU2b9U1DX06oDrQNNX7ioIot4pWcXh93gEP3S9VoYYbBstnGIw?=
 =?us-ascii?Q?aSQno3oKBLiZTuWYHZvvVuYzXVCYlOGqwXiWS4dvVnY3DSzfjxHcz7rr7Hne?=
 =?us-ascii?Q?GiKfR365nmvB6va3/gQctezXdqKbKzTLFu+u1NJeUdomDdHsysxMBMvbbJJy?=
 =?us-ascii?Q?3vwt4iNHV3jxp2hWLuGQiY2aHIJJ7539n3OSmOhjppfHWkwUEYqhj2ONSt+K?=
 =?us-ascii?Q?m0+IbRbJU1jboY9Yl5u+dQ+KaOdr4i6z6yjvRIXsLoSLwMA6Efu4DRlHNH7Y?=
 =?us-ascii?Q?hQ9LqGU6IzqzUpyX3KQ+6jCllFyxhD8/MNebfdZA237DytBqXYSqdVoZHJ1c?=
 =?us-ascii?Q?O7aHODkytfbXzRek0r+dmnbRDQLUYfyKU3MEJYt1AKuCDkv4cYEja+j2g0Ld?=
 =?us-ascii?Q?5L4PqodZNdC3n8YOCLookRJ+iyGUEOihj4xa4u543Dm8XqCap4HLkCzuoB9p?=
 =?us-ascii?Q?EjqSmsTurdcoclP/+Gtv6A+hj+S4L6y32Qk073jlt7jhTFho6s4WCzsAiOLP?=
 =?us-ascii?Q?KmW1vxC36mglPz9HrmJbkdR2yzpQOHsAJSZ1I+YFrJgqGwJCTL8Yh0dba81V?=
 =?us-ascii?Q?n1g6yJ6nappv2PU7WfJrio7XrsqcslLD8YVJPp5JRc0Fb9MN8O+2EZhpDBiH?=
 =?us-ascii?Q?xmtGHXOKF+8Jp9NcMctrhoXiu+5NetSqfnJhvXGLgECN0Krw8BmkNQ5ETgLm?=
 =?us-ascii?Q?bn7dHpj6J+JXjdaErkK77BAu8bvIQ+as+6Yk+Xp+Z8wzzNKGDgEJlaR9W8QH?=
 =?us-ascii?Q?g0XdYXvDcOBYu4lyd3dzeKX3e4x8MBUNI6B8Q5avzLRUk1dY8wPz9CEeAIbH?=
 =?us-ascii?Q?FCU/DfnD0BXbUcvDajKauCiSO7MX16dZQ+zFTfnN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e29f329-48b8-472b-f22b-08db46dfde97
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 05:25:53.2015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpw38Es6cw/UrXuQFiBEdLk8fUCI4OV5W1Eir14IsOqpA9T022m7iGeq1VhfTqE3AQJ3V8jQjclF9vfT2wL+kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7661
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink utility stores an interface map that can be used to map an
interface name to a devlink port and vice versa. The map is populated by
issuing a devlink port dump via 'DEVLINK_CMD_PORT_GET' command.

Cited commits started to populate the map only when it is actually
needed. One such case is when a dump (e.g., shared buffer dump) only
returns devlink port handles. When pretty printing is required, the
utility will consult the map to translate the devlink port handles to
the corresponding interface names.

The above is problematic as it means that the port dump response(s) will
be queued to the same receive buffer as the response(s) of the dump that
triggered the port dump, resulting in a failed dump [1].

Fix by using a different netlink socket for the population of the
interface map.

[1]
$ devlink sb tc bind show
kernel answers: Device or resource busy
Failed to create index map
//0:
  sb 0 tc 4 type egress pool 4 threshold 9
kernel answers: Device or resource busy
[...]
$ echo $?
1

Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
Fixes: 63d84b1fc98d ("devlink: load ifname map on demand from ifname_map_rev_lookup() as well")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 devlink/devlink.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 795f8318c0c4..019ffc23e766 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -931,6 +931,7 @@ static void ifname_map_init(struct dl *dl)
 
 static int ifname_map_load(struct dl *dl, const char *ifname)
 {
+	struct mnlu_gen_socket nlg_map;
 	struct nlmsghdr *nlh;
 	int err;
 
@@ -943,15 +944,20 @@ static int ifname_map_load(struct dl *dl, const char *ifname)
 		 */
 	}
 
-	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
+	err = mnlu_gen_socket_open(&nlg_map, DEVLINK_GENL_NAME,
+				   DEVLINK_GENL_VERSION);
+	if (err)
+		return err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&nlg_map, DEVLINK_CMD_PORT_GET,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
-	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, ifname_map_cb, dl);
-	if (err) {
+	err = mnlu_gen_socket_sndrcv(&nlg_map, nlh, ifname_map_cb, dl);
+	if (err)
 		ifname_map_fini(dl);
-		return err;
-	}
-	return 0;
+
+	mnlu_gen_socket_close(&nlg_map);
+	return err;
 }
 
 static int ifname_map_check_load(struct dl *dl, const char *ifname)
-- 
2.40.0

