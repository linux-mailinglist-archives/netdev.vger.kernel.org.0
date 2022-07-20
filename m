Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3257B0CA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbiGTGGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbiGTGG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:06:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112BD67CBB;
        Tue, 19 Jul 2022 23:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV+CsYj2W8PZyi+xZsdN7SbODMDlkm4cDVKDYp5A9dwo2Z+A1Gbi+WFtdLIOEyCid6pdxLV3M8pslf9uFXxVP4Ycg6KQ7YqZBggiGgArBcLmTnljaTQPWYpiBw2DH4gOFLJ2NXnobaxNmTnIIjXIQlPyEqn1zoZqwub/ZVflYJU5PjdY9QXMCyPza0StEFQsw/yqZxIpV2vOpztVwcZZNVGGqUng5WBpbr8a945QuDWz3vUPu+XpvI1o/aWc8ishUQMKxEqKMAQzZpGJa+/GyLqoLGSyC1cdIv7zrWAlaSjR6KueNwCvu5fFdvpQ4nwA3c406FCeKu5A0kVtnfYyVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOk1n7XcFNbm/4UcUnSQxjfjxcEgSVMPACpvRo+C/Ik=;
 b=fgwuJeBi/aMk0phsalJw+iU8Kf26i42m9fs0LwNANGaG9KZChQ5xDbVaAhcYLFk3W/znNlEkvK3u1AJIk246sSXZC8z43dSuI49DC4qlvDMcDivLEvEorMfBBVA84WIQDvYX55SHhPSrorYky7QEbjPuYWeOC1deT4zTNS9XKnrF53VDxkUAXhNOujWC2TpY8BCKf/arWSHuj+XHpHPjjN85FtXeRDb8jpTRItqohWyci5kSvEq9wCa5mtJ4XMx7nbBxchvwTp8SyFcWDTnh7Wpd/tg4vJW/5sPOJErP/aKG8U9p4NYcHGiVOdQmwwbUw34Us8eK2NXcSxI0iX9rlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOk1n7XcFNbm/4UcUnSQxjfjxcEgSVMPACpvRo+C/Ik=;
 b=SOwfPmFF6BjqBomo0Gg26tMFecYFi6wkQBKdLY12G9MWk7R8vjwSkOZ8Il4QwD745ChfwZOViT0QzQN7zVxwxeOyXTtTun+LgoDxkE/9XBjFKTpxdqzZ7csq6bP3QQ2iTQWlRSO+YUKSC6hp/1BHMkeb92M+E3I8Rutln9AlU+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN9PR03MB6025.namprd03.prod.outlook.com (2603:10b6:408:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Wed, 20 Jul
 2022 06:06:26 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%7]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 06:06:26 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com, Bernice.Chen@synaptics.com
Subject: [PATCH v5 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Date:   Wed, 20 Jul 2022 08:05:18 +0200
Message-Id: <20220720060518.541-2-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220720060518.541-1-lukasz.spintzyk@synaptics.com>
References: <4e061614-851e-0dd4-59b2-7110b1a4c339@suse.com>
 <20220720060518.541-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::18) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 787c2499-b609-4ea8-4a1d-08da6a15fb11
X-MS-TrafficTypeDiagnostic: BN9PR03MB6025:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAdbhW8H4AKPDtmDxELLzoDtNqQra9U3M1/qu4yqY7By6kB1qyia6Q+ae6NE6DKWsqvr/uPOE4WD91MBX5+Zx/FKjTOj2MejG9kCU8fAgJpsBHg+zH4rrjBK65yHuQmkEqDptVMdDL5AfRl1ukInMOMk1F1LGbnPNNamN5KeTiTnFEVI9mjlLIOFwT9+ydvvY2e6A1B2Q5Mdn5ift6xFVZ3hcGzz26TT5Rgy/sLAfRSOSf7RKJzC/BKQQIAyXsO+Kgy9melLK6mAlneSNRjsvO2S/TU73A7wm2L4kpRbfFaJb4TMZ2b/pfjuSJOkYawgxxih9Z78Cps1/ly12w4CY5qcoS511ZQx3wixBrh42g0G4Wr4Cv9EyZSQOZEI0zfF/1cGdbm+SZm+3OOoeYXe5IaNKDCMvbtwd5jjBfq9rEdVtxbvcBBbJgcvVGOoumOUSvxqg3srIMdvQaKxb5QF9gyALSIJmGdqRMo9mxNs/mSb5+cGhPnNpaRSeiXFnukaKsTfAvuGLvsVH+/pDn2exuPBotVvDXT8ah3mCHISnPT4YyRUUsQ/bPtkQ9Ll+YQnGtv/sKptByJiIL6ILhXZvYsLThrJbsuDdwXUr46EhDMzD/tzBuyo1oKIr9KVIC979XLyN0zV2pSDbtw6srtS9jf2+0Fy4QTUdsDSxStaQG/M60quYPzZqsmHffrzI6FE3HG17zra95i/B4e9x1s+pm9RKRcSHoHrdHQhlKp5Nt3Y/eMps0d9y05M2kfDG9A2h59tpW/8EXsY48amFLtGvJE3yGky2T7jCaOQDkJ/goRDS2a4npExxQxAV/2YRygnjX/HY1OxZMwN53UMAz+X1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(4326008)(1076003)(66476007)(478600001)(2616005)(8676002)(8936002)(186003)(66556008)(966005)(26005)(52116002)(36756003)(6506007)(6486002)(107886003)(41300700001)(6512007)(6666004)(316002)(5660300002)(6916009)(38100700002)(83380400001)(38350700002)(2906002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmROTGZmeU1HTkh0Rnp4K24xRFR2cGdrKzNsejR5MmJYU2FkNldwMm9VNnBU?=
 =?utf-8?B?YWc4K1FZbmd2NHk4a2RhZklyLzlsaXhGcGIzL0l2YXBMV21aVkJ6WllWb1hi?=
 =?utf-8?B?TkdJZGF6eGlVOXlxcjQ1Wk9tWWdRWDhRYngwQzlXbndsazdVT3AzdlA0eG9B?=
 =?utf-8?B?VCtKT0puVW5YUzNHbWV3Y29KamY3MENna3duVmRJMEJtZVRsZXcwVWp6L0du?=
 =?utf-8?B?YnZIVzkxaGlnQlhPWG8wcU9LTnlGQnh1bTlyaDRnR3pkbkV4QStEQmNVMGN1?=
 =?utf-8?B?Y0tYMTBCYW1yeGlHVXFURlJ0VkF4Q0pBZDkrSEJQUWJMOSs0RzhaU0Z0K1FC?=
 =?utf-8?B?akdURVA1RWV1Z0lKajVrRkhmK3JmZmhsR3IrK1BLL3pBTjhMZHlXS2poTHhr?=
 =?utf-8?B?ZUV3NFFZS1Y5WU9mUEdvdVUyT29GbldFWVdvak5nQU5EcllVdzdNY2tqU0xh?=
 =?utf-8?B?MTJVZlQxUzh5V1Q4eWpWekVBRUYvanZqVE5iSkVld0hxc3JuZXlvbWZpWGg2?=
 =?utf-8?B?Sk1qZmRKdUdoTC8xZWtqL2FXU25Pc0UrWUJnM3YxZzFRS1Rld3FVek5pWDRu?=
 =?utf-8?B?TTZJQjVIeXlBdTFFV2sybnlib3FlbjQwRU4xNHVDVmx6OTFhRlhJVVUxNEdF?=
 =?utf-8?B?WlZjb3k5RTN6Qmorc0NWY2JuSjNldy9ENC9CYjgwV2ovdVdJVW5Ba29wYW9i?=
 =?utf-8?B?di9jeTVsUTVaak8wc21tY00zVjZnR0szTnk0aDI5cGFhUEY2TDBmY015Vjc3?=
 =?utf-8?B?dkZHMERFNTdkUjBlMHpSS3FSVlRzTEpTQ3dtRkhGWlpPdUpRUG5XL1NzK2RO?=
 =?utf-8?B?a0RjbmJWVlMrMjAwdEh5c0JtVklLL0NtM1gxaWQ3WlhrdHlUeGI3aSt5NkhK?=
 =?utf-8?B?ZkxyVTJNU2dObkN6czNrUVFTbnBLSVFSVWRJajBZVUJRUXIyeE5PMDVNcW1l?=
 =?utf-8?B?WlpBMzdvNmtvbENHQjh4VUpiSmRSbFlHQ2cxS2sxb0J0WWYrejdZNHJoZGhT?=
 =?utf-8?B?Z0F0ZGhKWmh3WmFrMGtaK1IvTXpkZlJYcG5iQS9NdnVpb1pVZ3l1SllBVkNZ?=
 =?utf-8?B?aXdYakFnMC9DeDM0WUpzd09YMlVTalJjU2ZQOVhFUC9kSVhwcVYrZ29sdTVC?=
 =?utf-8?B?TDVIT05WdWdyeVRwZ0dnVXRENUl4eGRlZitHS0xObHpIWjNMYkVUNXhZV0hW?=
 =?utf-8?B?eWt0WTZWemM0R25IZ1luZDIxVzRISWFtMXo3WWRVQlpnM0lZSkNGSXNFSFVi?=
 =?utf-8?B?NHQ2MWZ3N1BGTkFGMitmUXRXcWtPZUVOb291K21aVjVZQlM0NnlBVlE1T0pR?=
 =?utf-8?B?cXU4SlNJL1lGL0RJVkNOOW5MemlSTW9aREFBODNIbnVyeDRydWV0bEZWSDFJ?=
 =?utf-8?B?LzN6b1BNR1lvMnQwSUllczFqUTRLT1phQTNiSGtCSHFmRkNzL3FJR3VkRGw0?=
 =?utf-8?B?U1JsamptK3craEk0NHBkTEZneWtZRVFqVFVqZ3pjTG5WNW51N3c0SjlxcGpp?=
 =?utf-8?B?UWhWUllpaTg4UVVVUkwrTVArQ3g1d3VvZm9kWmwrREhrR2RSWGl4bWRDcE5M?=
 =?utf-8?B?QmNTL2JOeEdoalpzcHc3dVllSHh6a0NoWWREMlFTUlJibmJsQ1ZXS3prdlpq?=
 =?utf-8?B?eTE1SXBmRE9hUUtsR25yakFobjd2RnprTUJ1Zzk1UTlLbXpTd1U3VDJKN0xW?=
 =?utf-8?B?NEtXTllySWtzaFowcGRNN2E4Z21nRmcxMnNsV3hqSnZJSUlYV3dCK2pxVVpL?=
 =?utf-8?B?YmJHMitvYUhQN0NkWGU4RGdQczgrZ1ZUcnBhdm45U3M4cDZDY0lpeDd6UnRj?=
 =?utf-8?B?eE9LcTJBYlpUbEw1bDROVHpGUVl0SUIzR3FQZDUvUUxkekpLS0JZZyt0RVJ1?=
 =?utf-8?B?c1FFOEQrZExYTStDQjE5Wk02MHYvQnAvbGhMKzQ1UE1BQzIrSGZwREhERVV5?=
 =?utf-8?B?dm1aYzRZdmwzWExhdWp1VVkyVG45djYyRSs3eDlHRTYxRFBaS2NxdS9Ka3lO?=
 =?utf-8?B?d010RThFSWoybUhmNEpVVUpncSthcDVsV1Z4alRkMElIVzhraytHTTRpUVJC?=
 =?utf-8?B?YVB3MFZuOUxrSjllN2lFRE0zMDZycTlLM2RQRVVIVkFkTi9XU2VDQ21VS3VT?=
 =?utf-8?Q?bhj23yWH1bMB6iMXN6y477IvR?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787c2499-b609-4ea8-4a1d-08da6a15fb11
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 06:06:26.6998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urUHVXebrHl9tKKmKknglP8yRLBsUGv2hTn/D3B4WnCmkDgST3hA4c4mLLiISlgMw/Bs/uweveFIy/wVljtoyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6025
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DisplayLink ethernet devices require NTB buffers larger then 32kb
in order to run with highest performance.

This patch is changing upper limit of the rx and tx buffers.
Those buffers are initialized with CDC_NCM_NTB_DEF_SIZE_RX and
CDC_NCM_NTB_DEF_SIZE_TX which is 16kb so by default no device is
affected by increased limit.

Rx and tx buffer is increased under two conditions:
 - Device need to advertise that it supports higher buffer size in
   dwNtbMaxInMaxSize and dwNtbMaxOutMaxSize.
 - cdc_ncm/rx_max and cdc_ncm/tx_max driver parameters must be adjusted
   with udev rule or ethtool.

Summary of testing and performance results:
Tests were performed on following devices:
 - DisplayLink DL-3xxx family device
 - DisplayLink DL-6xxx family device
 - ASUS USB-C2500 2.5G USB3 ethernet adapter
 - Plugable USB3 1G USB3 ethernet adapter
 - EDIMAX EU-4307 USB-C ethernet adapter
 - Dell DBQBCBC064 USB-C ethernet adapter

Performance measurements were done with:
 - iperf3 between two linux boxes
 - http://openspeedtest.com/ instance running on local test machine

Insights from tests results:
 - All except one from third party usb adapters were not affected by
   increased buffer size to their advertised dwNtbOutMaxSize and
   dwNtbInMaxSize.
   Devices were generally reaching 912-940Mbps both download and upload.

   Only EDIMAX adapter experienced decreased download size from
   929Mbps to 827Mbps with iper3, with openspeedtest decrease was from
   968Mbps to 886Mbps.

 - DisplayLink DL-3xxx family devices experienced performance increase
   with iperf3 download from 300Mbps to 870Mbps and
   upload from 782Mbps to 844Mbps.
   With openspeedtest download increased from 556Mbps to 873Mbps
   and upload from 727Mbps to 973Mbps

 - DiplayLink DL-6xxx family devices are not affected by
   increased buffer size.

Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2:
  - Information how to change tx,rx buffer size
  - Added performance tests results to the commit description.
v3: No new changes to v2 2/2.
    It is just rebase on top of changed [PATCH v3 1/2]
v4: Added Acked-by from link
    https://lore.kernel.org/netdev/YtAKEyplVDC85EKV@kroah.com/#t
v5: No new changes to v4 2/2.
    It is just rebase on top of changed [PATCH v5 1/2]

 include/linux/usb/cdc_ncm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
index f7cb3ddce7fb..2d207cb4837d 100644
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -53,8 +53,8 @@
 #define USB_CDC_NCM_NDP32_LENGTH_MIN		0x20
 
 /* Maximum NTB length */
-#define	CDC_NCM_NTB_MAX_SIZE_TX			32768	/* bytes */
-#define	CDC_NCM_NTB_MAX_SIZE_RX			32768	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_TX			65536	/* bytes */
+#define	CDC_NCM_NTB_MAX_SIZE_RX			65536	/* bytes */
 
 /* Initial NTB length */
 #define	CDC_NCM_NTB_DEF_SIZE_TX			16384	/* bytes */
-- 
2.36.1

