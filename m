Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8780B6C322E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCUNCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCUNCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB374BEB6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oe2SZvP89SIvfZu3cYKq7pgsNH0GSY0zmvwvkyLpFrwC9zFrkQYum7oQ7nTKx2xS3HRFa/HKfYNd2+QKzK7sRa8Tbl5JFUSYlUVXCUQScj3e/zK/DgBmd2Xt9UquzOGVN14dxpY0x7lgohdNIKnLGioerY1Gf5nrNC0TviIOD0NfdHgfxtcva5nkHHSemtiE/mCN5JcWFo8iZBmWM3J6WKbYTawSpJvZPhT8L6YN3IiIi/2/P89z1oNBxAey7DZh4ZAyDOMnz458+jQJcosuHA9EkW3NeSJ7SDC1gisrLTV3BdQblR8kXSw2lXgBWfE7It85P6/+RTkuls9+ewWW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgWUnG8JvJPslZKqCjAJJLq8HoZOvVVKP2P+SquhlEI=;
 b=YTVc0nEprOO42Jmxgb93N4Yx5WcaldAK7sZ7ZYnbF71OSoIyFWa+Ru8x2LTcuq9EjYlNXsRil10Y3WMmxpvXVxtSeCYfseEPVRaPLBRaSZMFol/er39CHrDVNZwUGCkI/sfRnPvR0/XcoKrnZIsByBeLPAqX3TJItVlKHymyvGqyBINfIN5RWa7y4cCtzwClNHq5QUxuH6RpDoDwBPjItarALhpvqngqsfVic5DNO/aux0obxt8vP4ud7LrK6RtHBJPriSNDCxRjV/je7j2akO4oSd9+LwuKghHOK9KRpt7jRyjMtSqbGOkSPHVstmP4QQPI43YVFvOxSrckzmoWlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgWUnG8JvJPslZKqCjAJJLq8HoZOvVVKP2P+SquhlEI=;
 b=bH9vLWSMhxOopEltVEYxA4uqLK2YX8erjIwWuIOVAcVP7iT3a1e5GdQ16rxIGcdG9muRYVf78mBiIyn0UtDdJe1AXcZwdxtlcXrv5xSC2jZ5O9a8+4GloPzMjQW5WfpC3E03nh+rPLwWf6b0VFRlnXkA0ZxlQKbX3hHpg0JTYqiSsDtI+yXSop/v1YIT/NWzZGcLluJ5O/+hyfQltZtEHeIHPZzDTiXjmzpTKDQnMXLx5vJYDUkJO8SMCXg6u6aqoVSJpiLhAepZkXV9idCJekfAiOynSk2p3mqxDZnEn3laY8oF7gdQBckibWONjkjjKkvfeW16wVIia5GcIE9nTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 1/7] Update kernel headers
Date:   Tue, 21 Mar 2023 15:01:21 +0200
Message-Id: <20230321130127.264822-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0043.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: a777c893-d797-41f8-7469-08db2a0c7e8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZ5/tcOwTjoWS8yvEYFiI/dU0q5V99yP5zgPzkqpKsShXH2jEgg6CBJx5fJS10yo81MBnCUKFEClOD008KrAiWSec21hEY20ILenj17ojY3rd7975+xgFHYH/S4aEtFJlM7YRaS/PGrsNb+ZdJVWLWpT2npRLjc5nAGadLmHPgd451baZ+3yE2Z9Zi++qLcRf9n1P5NLPV6+ZLYDrP6Ck/w4VqyZst1QSi4In0Yuf8oMaN6sG3vOgd5R760aLh9R2j3Y7ypaJkfZp0NLGl8lRZvDq0sJc7iiZKCChNrECUYaGUSq+VS1wfL/QRd0+uJKLxmv+03fg2uIesrTE8I8nhocMrwsRRZJIqmaGW2wiElddfejHhqA2/fFhC+0XLpmU6qAltrHgHmmK3eK7U2vOLBVK1WuC6GBKKIaFNCE/iF2IgsWP6T9/I4+QMIoU6pnZ53fmP4MHZ016EcxwDDehGPqXErVZ3ZC1xI415fO+p3+Vikj6qUR8kHjAB0wMDgyonwLcK4eD2ozDB7WLIBUT4tEFPxFyoBxPd9sCXK5S4E0I0sXrFF/KzaRRvTPWj0jEegau5iH3ZhCG0sSIEBiK9OMKP5hvBgwN460NVB02QByXUq/t+L22fYSFWYZCkDZdlLwkn2sE2mMqqfG/iFeJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(2616005)(6486002)(478600001)(6506007)(6666004)(107886003)(316002)(66556008)(66946007)(66476007)(8676002)(6916009)(1076003)(186003)(26005)(6512007)(4326008)(4744005)(41300700001)(5660300002)(8936002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I/OTYsb9pJyYHmUg7tHLAtoZf3ZCggsghl6h1lRMoLhDqYzEa+0BfdpUEGCw?=
 =?us-ascii?Q?O94xNZV0hct7EoRGPFXTlmO/L7aUTyDKu9/EzVm8Rheeo6YNdam1gcSIN77t?=
 =?us-ascii?Q?qkQ+BJIH1RKk1FVhbQTeVhrj0MTVFlWwDabXFOs4sbwwZOzFbLHVz1zQoX9J?=
 =?us-ascii?Q?C1TacLhPLhHb4+UDt1371WmIpvKRuUhdCA2fSC8F+B8C2vnDQz0gBQumUrrt?=
 =?us-ascii?Q?wgQSpzEMh8t5FYH+g+TVjpbD2qNoGw6P0fI9iWma0e87lQfH75eX3M2+n2HA?=
 =?us-ascii?Q?3hqrFDUuPjYiWY53JIDbWkY6G6aKkutN/WGCyl63YifHFKVnV+SY/ESXyQzE?=
 =?us-ascii?Q?rvkkZSJUQst7OjK/+nnzI5Fz70dFIZGRrM0TPCB/EgsdyPOZA/KyYW+P8Q4p?=
 =?us-ascii?Q?W7EY+heLCoWbcfaRrJmcYO9QY9SGog/c0TqUn3VMTGeAPft/sjgZaqJ+WToG?=
 =?us-ascii?Q?wmlxrRE3OWJHDAawgyeceDKnlLyiBzuQIsWONiC5u+F9AKpQzrgVYRAY45Qc?=
 =?us-ascii?Q?5HQqxlpyDwRrOJxEJbKFUnRAKt12DGTwXjvwgAf6cmkeSi4NSapdG278hk07?=
 =?us-ascii?Q?VwpU6VCsse3xO6oJP+Y5/2dAap9GpB5W1oIK4ShGYX+lpsUi8hi4XgsOgdVa?=
 =?us-ascii?Q?wadJqn6/0bM+JKULH+cRMmztGRx+BBZr/vDFbcnyIKWA4jmAqYqR0a1c66N5?=
 =?us-ascii?Q?33XRrZUYyEr1pm46EYt18EGsPY0SnRXhiy5hsXf5nlyVsvWOSoCdCOXNuZYQ?=
 =?us-ascii?Q?dB7FoSa1LxnIrxd2wX5yFWYwdxsMoDOoiK5b/3WgKC7ReIyyoLBF76kuWDeB?=
 =?us-ascii?Q?Ipsl+0ttf77R7sqCN7bvbjj+MIn0UETh0mYg3Xj7Jg3/ymW5Q4Aeoe3+7Eaq?=
 =?us-ascii?Q?9RctDJVZ3pYvP8L9n0lexFCr3d6Rj38nzjMi864hrd0fh58wiBztSZB/iiks?=
 =?us-ascii?Q?QyisOZBiAL81w1XNmCxc7dsH/XoJD5kVWvDnKscTtWOBS3PJp6V1+GEMJ3DT?=
 =?us-ascii?Q?JD3+zVGhWgnxCHsPSuOrUT6I1STzF46I3YQA3oA5X1rkQ0oYoAGTrhIev2YB?=
 =?us-ascii?Q?j0D2O3J/El3TlrwNTuwGWL4JrgeZ6btRb6DwUDs0P2GIARI2jPNMjZUaZOGL?=
 =?us-ascii?Q?VmjmzdlxBogAz0dCLPHCvnABOeBc68MaWpS+SfCJFyYACPlO4G3ev+kdoud8?=
 =?us-ascii?Q?3piL1F1cllrBubayfTbwo7aE6PL4F3sV2zAgBWme0WWYI5HNFJ2JIcaB4LMq?=
 =?us-ascii?Q?v4fbkfK0UvjyqD305Y8ZqM2VFezKz2chKE0EswVG39/2n3mmnRTp1C3osmX9?=
 =?us-ascii?Q?UJdqynU2x0LoJUvfzA6odZh3xh3StG89yG7AbNyxWvRjvmbkpYkBzkbLvXqA?=
 =?us-ascii?Q?CZIEMwInrFAbHsp5vUwq8+VDwe/9WvSi/HApL0EISvHi5N4VIoXXkceUA+Ia?=
 =?us-ascii?Q?tejikHLCvljpAfSF4oS0MimV7QaJ4hQs8qA0fCX9pMFa+1bfRQd/ZW7kfMg9?=
 =?us-ascii?Q?wogCEN5JYqmliGYC6UGROKPeLXG6yLUld+n1tLFgjrv7KaHJ2cKsvgaeRdKZ?=
 =?us-ascii?Q?uE35lAtyzjtVnqqN6mykVKMSMURiox6lxFZnJWC8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a777c893-d797-41f8-7469-08db2a0c7e8c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:15.5583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gJ7dfRwQs05jCnHc3+Cl/NfT3Yi6AEsH05i2+tZFS6/o9GB7MPkuiWeNRihfAAo9RFTZXfhaQyvVw0KARNy9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        UPPERCASE_50_75,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 921b212d9cd0..792db9800aab 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -633,6 +633,11 @@ enum {
 	MDBA_MDB_EATTR_GROUP_MODE,
 	MDBA_MDB_EATTR_SOURCE,
 	MDBA_MDB_EATTR_RTPROT,
+	MDBA_MDB_EATTR_DST,
+	MDBA_MDB_EATTR_DST_PORT,
+	MDBA_MDB_EATTR_VNI,
+	MDBA_MDB_EATTR_IFINDEX,
+	MDBA_MDB_EATTR_SRC_VNI,
 	__MDBA_MDB_EATTR_MAX
 };
 #define MDBA_MDB_EATTR_MAX (__MDBA_MDB_EATTR_MAX - 1)
@@ -728,6 +733,11 @@ enum {
 	MDBE_ATTR_SRC_LIST,
 	MDBE_ATTR_GROUP_MODE,
 	MDBE_ATTR_RTPROT,
+	MDBE_ATTR_DST,
+	MDBE_ATTR_DST_PORT,
+	MDBE_ATTR_VNI,
+	MDBE_ATTR_IFINDEX,
+	MDBE_ATTR_SRC_VNI,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
-- 
2.37.3

