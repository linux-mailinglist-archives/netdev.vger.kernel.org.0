Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA824C0CC6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiBWGul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiBWGuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:50:40 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46226E2A2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645599012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ttU4fHc61Snhsom8a65L/6WVy5QJJteLGtkqtOGFZg=;
        b=kCtiAq6axWCOmyAV2M0YBtA6KCb9AEYa7a7u/L5ql6SeOdNYkYtyZfRhVObDdtPeqaVORg
        ihqxtnvtP0cfZBnY+wJQEAEPKbX6JPvs64jmf/6uHYh8/xJ7k1/1foq7LDQ1d/LoiVQa9U
        yPEJx1rdkJZIig66KbJ6brdDdgYfdeg=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-8-lrfSABZeNxqbQ7wITMEkkA-1; Wed, 23 Feb 2022 07:50:11 +0100
X-MC-Unique: lrfSABZeNxqbQ7wITMEkkA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJc66TWzxt7qF7tq6h8CTrgSOqPS0T1sOVRUhBJjoOeCeQJ2yzlEp4jjMFZtU4oguS/ljRUp5L3xrOIKScLHps0tqP7NNJK8/VunFo9duFvMU+8T5vuk6N+rqSkz6tmCo0nER/9Er298egUz2dHVnFQK3mDGbCfYa+pBWkt1KWxcZoX8DfdjAlkeW/uOQFaazlaB30a6Z8qwbxZcK4OG12QGgXoSQbAefagfrHr52QeyEnT16vmbfS9dUoo8obChZT6K5r5q6Vc27Lzl60iwjWFQmiRXO1WfCo30zIxrl6J2BueVFrl5gMbxppkJAigBgvhrSVbX+H2/h9jKGnbtXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nERJeosA0j3rvIDmBgck48UQ1C4Q+JXdi1jZ/BjMB4c=;
 b=Kkn4NBp+Juw5VSsaZQH93q6uoPSnu4Kt/iCiPH7qYN/E/rjhQzd53fNAzmW2c1JLwtGT5kutzuv61fayFUm6ZtYU3AfWcbVuEY/5Ic4TVD5XWPcFwR21Sz4LhYkbhp2aME/v6QXDeOWFLFvjm9XygMPxE9/Qm4Zxa7kDYUI61BcMXWNtwrEHkuxW3BvKk7LBKaO0p4daYeQAkvXr6qfuIcH+a15D7iRc38lgBiQuCptW/2rLHutQmI/Gilxf2CeSehwCtUK4OcBCPt1V0CzWCPW7fRFwmvtNpiO6tWFzYmG7wHvC3nYmz7giL6QRZoeRvMd/qbkaUn1QTNVz2RFwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR04MB3290.eurprd04.prod.outlook.com (2603:10a6:7:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 06:50:09 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 06:50:09 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v3 1/3] mptcp: add fullmesh check for adding address
Date:   Wed, 23 Feb 2022 14:50:37 +0800
Message-ID: <a452307d79abca899d35dce03de4fc5bbffb965e.1645598911.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1645598911.git.geliang.tang@suse.com>
References: <cover.1645598911.git.geliang.tang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:202:2::14) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65c6ef69-d0c3-4884-3ddb-08d9f698bbda
X-MS-TrafficTypeDiagnostic: HE1PR04MB3290:EE_
X-Microsoft-Antispam-PRVS: <HE1PR04MB3290887CAE8901385118B2B6F83C9@HE1PR04MB3290.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyA3dzC92j0rnfeMzV2tzB3/AoMz6KqwoGj+5eR/MgQgbevI7VwYadIHg+ASURgRrN9Kkx0ol8ByIZPhGvry6CaQRhfjnMH7Urrsc1DRKe1SqulhxS1ydtojCBvJJq+s7sifYfLcik9Lvwn6r3wC68tXeDS64y/+phtLMW+fYs0/4AMQCIOqNjvzGjyedXhqjgVtDqqGlpbd+KPhidZbBSJvclpyFJc3sLLGr4vSriX/3EgyVsFySOSkKB7pRNgg6Zk/w9LejBBP1mEUQUfJdX8+r1UbH+Uc5Dh/1scPrqRlskIqKX5feDN0yIylvFO/1jIrRa2dyap9ZuNupyrG4ZNyGfWxaGbZCaQUm6xO57zK1WoXn7l3r0xeeKeu/yydLD27ZgEcGUUAC71k7huq7Nu/KHY8OMVclafHXmo3KpXvKU976Tr/hpj7s6l33VZejXaEvClXz7JYew/bbaQabbGzxGOXO/6PdjqBrOcs5Fyzq0CQUSQOz6aUpjcR3AR6bHwmhSfNsCsycDThxGkHnzWDyy594FrZ+N5VAcqyNX8RdWDWYtvWCb9zlrc/XFZlAoMh9z30ACNZLkDuBMs+WhOsbiaaDPj+WjSUC8G8xN2QoXepe6WIrl3OMD4dcXr1EkyfoqjKUBjbf+uR/SOTZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66556008)(44832011)(4744005)(66476007)(66946007)(38100700002)(86362001)(4326008)(5660300002)(8936002)(2906002)(36756003)(6512007)(110136005)(186003)(26005)(2616005)(6486002)(508600001)(6506007)(54906003)(55236004)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3gin9KNPQDDFuT97xHOSvDzKL4EQDKHLndo6vEN2j3uBC5fgGdnhTILZyJdW?=
 =?us-ascii?Q?/wOpltHsCDU5nASSA+lb4DbiF1kJQViNlxXggG1GOhKQn4DLpvLqbenDnNWb?=
 =?us-ascii?Q?Q5RLOTVT90p5MdIQ2ViTGayynUpLnz3t8A+HhqEi5HPt7Y2vTwqrUZpH9YR6?=
 =?us-ascii?Q?poRbYq7+8ER+e0ftYRs6/kC4r8YGZKYm7cxAwQjfEFRMVFAoVMb63ExDwFcM?=
 =?us-ascii?Q?FrTw2HnSHx8gzBhkwGuaGaQQPcEx8dS/85lj2O6ZLEl4nuJlNh7mPbz2RvBO?=
 =?us-ascii?Q?qxMX+Vqpdk4P1eDixl3m3XeItJDP55WipMwW1az7c7SGi9hhxgUYocjnmqpL?=
 =?us-ascii?Q?LBqGSJpHCpsvp8kDWzhklO9bGiRwRO2fTD8RAuD1Odzx3ufcRlS8rUt3eZIR?=
 =?us-ascii?Q?IS0DP5avfnHV01QsvhnlYYNwiheOLxs7kfHFaUqBzw4rhHT+W0uvv0fkaaqd?=
 =?us-ascii?Q?m/huOdTJQcCZDezBckF7g/a/LmPBh9Pkf/QgprXnK6wVLXB5hDFKbN2LAJkx?=
 =?us-ascii?Q?RZjbu50UJVWAGrPDaB+CcqU3Ry8z+v0DiLnnuz1B1E91vKP7mpqzhozcNGd8?=
 =?us-ascii?Q?qm0lkg8k6Awjeehd4JAGvdkM5mfB36G5GrUBJyRAdUEzFYKHkxxd4JiyoaE5?=
 =?us-ascii?Q?ayzoN3zYzIiz84I1al0AKowkPJKKm2hISxGJ0Bnqrhej7F3wkbeT1lXgPBA6?=
 =?us-ascii?Q?qTINyDjw25tkJElbIgTZ/0YVYqcI/32tqRloyv3Dm4yD43XlUSWCumCoQAB+?=
 =?us-ascii?Q?x/JkMJSsFktJAni+6qXZ3lQPMEy0c8B27BTx13YyICM2rp3Hu8OSrqPKFl+4?=
 =?us-ascii?Q?vtofcAOThQbkZNjl0g2x8lN/s2RcfeNN/OCyj5o6KqsQRfMD4ybHNiq9owC0?=
 =?us-ascii?Q?Fx1IwkMzjg5eM0SXuaGaFOcXMD7WefkmlHTx4eJ3xtXmenLiBRhQC9lKwsI9?=
 =?us-ascii?Q?VWO00nLpjCFgRVG9j9Y3tqsH9Wh33mkYws850Z1WiZMdXCs0UH5tiJqy29WE?=
 =?us-ascii?Q?L3AEnDfISHz8ozQku+K1VZp7z/KN44xM2iCcmDGRtUeVrMJBEpFklI0a2Fqt?=
 =?us-ascii?Q?xgqKNLUFb0wMFEeBeTyeH9uyZQq8WxOs7LbSWmvv3N6ncs864SMYIRiWrsLH?=
 =?us-ascii?Q?WhiOQyDaY2jUWFYydvxZ2V/Qs7CTttTlJAxbpqB83E5JnlQTHYTwDUohC0N2?=
 =?us-ascii?Q?XJ/p3nJ5c7aOnPu2uSWhDKN02tNRbIWzK8MDPfgcy1SJCVwKiWe3LmTLAj7w?=
 =?us-ascii?Q?99IT9scwBUwNYJHJ1uD8cS36NQLr7YztLfgSmYJbLRAj61zq/P0rIpICb2yU?=
 =?us-ascii?Q?2Oi9Vz5Cr4D4bFaEgrhw9gZ4z6eyx9I5/UxF0CFTqTX92B1o3QZ1TF3lJ0W5?=
 =?us-ascii?Q?G2RdUIsNWkSkVbdJjBNPJuP5u6SfONcj0c1iNj9qaRxgxtMHOlEa9gLM7BsH?=
 =?us-ascii?Q?xhwiGJU9dbg+WRmdpI0Hq4OgZRojgbltchCHzSHqVEM5hiBffSFCMCv0z5ja?=
 =?us-ascii?Q?zEmwozg6MbX3fdwd81adwomE4ODk6ThqwDynxsByOF+bWIp1c7jgC3MtdJ3e?=
 =?us-ascii?Q?G9YAFTHEGTJLYBY1M3K4GVsJkNs6fV588hRj1yyS05sEbMTHUqWS3URtsC0P?=
 =?us-ascii?Q?lYOoayYxJFfZZbYGubjA0pc=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c6ef69-d0c3-4884-3ddb-08d9f698bbda
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 06:50:09.7833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxe/pDH1wOaBegnW2kEeKC41TeYccM4rmsr3zPx9SntL7y0DNJjDZPZu10wYF6IYiMUbahnObMr2jvBzULthtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3290
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fullmesh flag mustn't be used with the signal flag when adding an
address. Commands like this should be treated as invalid commands:

 ip mptcp endpoint add 10.0.2.1 signal fullmesh

This patch added the necessary flags check for this case.

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
---
 ip/ipmptcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index eef7c6f4..5682c7df 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -116,6 +116,11 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 	ll_init_map(&rth);
 	while (argc > 0) {
 		if (get_flags(*argv, &flags) =3D=3D 0) {
+			if (adding &&
+			    (flags & MPTCP_PM_ADDR_FLAG_SIGNAL) &&
+			    (flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
+				invarg("flags mustn't have both signal and fullmesh", *argv);
+
 			/* allow changing the 'backup' flag only */
 			if (cmd =3D=3D MPTCP_PM_CMD_SET_FLAGS &&
 			    (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
--=20
2.34.1

