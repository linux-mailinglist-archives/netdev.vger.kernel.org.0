Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D692F579310
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiGSGZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiGSGZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:25:17 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2386FA1B5;
        Mon, 18 Jul 2022 23:25:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApXCOeIkKgJxjRp0lLt6mEHfDygV/Yul2iafixaz9BvNsHl+2eCFMaGpa2JL7NzhcVs1pu07mwOaDiQl5c55qPejoacl9oHkIO+8pjUuk69p2iw0IbSRaoZxVK8P8+01WbT/Uw6Gr5nwBVgIibPKohxDWrxYsBj1B8Roc98V9vf0rW5CXA6PZMZB6VeDNuS3lkd7QVMlQokNtCZBsHWuIcGcFvaju9ZNpuzOeWxdeBo3PdIrrNd+Ujbzz+TvIP0/sTbgATJIgfLFLP8lN65QSxgZZ7fT6cev5IZa9bx3Ku7b7zh2dUoSIjV6gJPzpfTkZmMCkEZh1Zy3iwMmSmhkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2IpcDyzFRaFkvZWvwNQdH5LIhe54YynUgvUtfShK8s=;
 b=chneW+EDxMtCS/mDPPNdK5abAQmopxdcMkwmp7/ebVZsbMTIJ7TpyONi8ToR04qK35AFv8iHblj3NTd/voR/9ITDGOrEjTSaqrfABBO40kkWic+7DMF+KZNAdQy3U/60dKYaxJZ5gflVdriBtB+52qa4Nmomq9In0sorZ1jCPx0junJ9ovdAAL9vClJXwANFW3EauUsXvyY4Ov6LhpVkGW22FAdGEbSMNIkGvXbadwDxxnQ9z9U0q/wmz/PWd93HXgWu7SAf0gKi9NJgb/fYuj3MJeidY8zwrAs+UeTVqHNGHXT2ZIu6wJtF6Btt+vpt23MsD6y1q8cp//oOw4AlbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2IpcDyzFRaFkvZWvwNQdH5LIhe54YynUgvUtfShK8s=;
 b=mYLgxY+4bTRvRSpRsr8hzk6bcwpmUgXE3Ba32CxD3NwYjvdfarv7xP7C62eHBDKAVVM/kkZdSlRMzZ0YTeNH9nr8Ke3vCukSSOHaLYsir/u9K/q8+mVuZvQnQZ0LQxbw81yklFFFk6ELY4EDrEzfqika/bFYhjfsKak17hcAvRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by MW4PR03MB6650.namprd03.prod.outlook.com (2603:10b6:303:12d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 06:25:14 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 06:25:14 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com, Bernice.Chen@synaptics.com
Subject: [PATCH v4 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Date:   Tue, 19 Jul 2022 08:24:52 +0200
Message-Id: <20220719062452.25507-2-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719062452.25507-1-lukasz.spintzyk@synaptics.com>
References: <YtVw+6SC7rtKDzaw@kroah.com>
 <20220719062452.25507-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::16) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6625b22a-023e-4d09-7d7c-08da694f7100
X-MS-TrafficTypeDiagnostic: MW4PR03MB6650:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cp4yhXlTvj1urvSzGGdg3eeUVuthSOR8M6uIRMNas520IPadAq7unhd/5sOtGdaIzfTxpPPvjdE10Tcq3z1bN07/1TYjKh/dYax5SRtKbbYNOgh9QXo/HcX34PM2yHy0+zzBVOeko8kvjPqpmKmlCMvR+EJ7VtF4vBlvUpndCtom/X86hZeGN3SgegvhUfP5AUrLfc9v2T6S1D/N7xhydFo2I+VVX9yfUpBEEc4wNG3lyU3v2s6sReBfy29I41ti0zH/TY/pwCD15IqJxVBsMKVgy2Y/6ZLGNXLDLETiudWJC789iJa7AYyqSlfE0GuGFGvabtWNU/MgQk81g1xXTUxBoOjl2UYshBYodV50VvgX7XqckV31Pco/oFwBGd//4eXmuwNyVdiSXMZOJMHYj2JlT9hPXfJuHSsxL/NHGTeW6i71AD7M3gju6rJUiuSb+GFXfUdE5WbICP0KFdLFB4fJ1UF3VFrRZApnrY2ObPu3JY7zuQ6Pj7OlgZdEKEIuSMnjYPeQCivhZ40OI5YxnA1GX7WwZrRmT7dCy07G9m1R/4gdzRSqeF6Lse+ZFhSBjKHLBs6BoJa1jaNG9fUyn6v8RJ9Y+t10U6XjTacDiPWmE8nj9ojbyZkwa/PQClN/hLjF1SdnBYs2Ym7bEQcf+9L9mFCt7jH7Fq0SfYmKr6jk4GEUU22vXXea9/sHtkMn41FiP8N2Sow+uWS0RssWRjuaTNirHIdyUOVX/JpJ7iWjXfjCofnZZYBO2EupH1qZToIiYIIi0EtrEIhLE7jhdrw2DANyFRZr/eSbyfn2veOB6PqYm/e5BbyNo0nZkbEtWp8RAh9Qlsum2eNMG4NcVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(376002)(346002)(396003)(36756003)(5660300002)(8936002)(2906002)(86362001)(66556008)(4326008)(66476007)(8676002)(316002)(52116002)(478600001)(41300700001)(6506007)(186003)(1076003)(107886003)(6486002)(6512007)(38350700002)(38100700002)(2616005)(83380400001)(6916009)(6666004)(26005)(966005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXZsLy80Zi9uNDlncVJhdklyYVZDbjN1L0NZNjA1WWw1QVVUZUFEYVl2V2lX?=
 =?utf-8?B?eGs4SFBJZ0lpQTZNUTRUYWNyN0JETUpEbXdoOTVZZ0xmaEZFZ2hxdUx0MC9C?=
 =?utf-8?B?TG1SaVlPQVp6bXdVQXlVbHpvNk9vTDZrTWpvQ044RWRaNm1wbGxxUThJOHRQ?=
 =?utf-8?B?TDN6czB1WHRWNUwvOEdpVDZ6YWMxSlBjbHljZk1URzczOTVub1dZY2MwWTNp?=
 =?utf-8?B?QWtuUUhTeUYyeWpEVUlzNlF1MXIzVjlocUl6ZTBNWDB6bnRoRzFIVURSMG9P?=
 =?utf-8?B?aXcxcUlRNlBrWm9PUzhodFJHclB4K25qbGFsWkFYWkYrNkdwOC8xNWtPOGF6?=
 =?utf-8?B?NlJOU0d1MjhQOTFYdzNTTy90SndQU2cyOG9qbUthWVpWZ0tLSFIxZ2tGMnNp?=
 =?utf-8?B?T0hvV3JDMFduZm9nRFZ1TmRPQW5HZUp5dFhrN1l1NHR3cC9CS2kxWmJ6VFp1?=
 =?utf-8?B?ME1JVU8xeVJxRlFkVUxneHhiRXFDNFdmZFlna0ZzOWJZdXoxRjNFWm9zR2k3?=
 =?utf-8?B?dXNjQStFNUxaRTdobTVicldlc3duNVVtY3RUK0dWdWUrcThTVG05NXh0RUFk?=
 =?utf-8?B?UHAvcGRUQ0hESm5YdkNWT2VSSVJZNlU2bzhubUFWbkxCTC8rTFc4TzZ0YXRm?=
 =?utf-8?B?alhVMldta1dGQ0tVRjFlOUVEV29RRGd5ci96bWFBZzZUV3BTOXQ0cWxMVW9T?=
 =?utf-8?B?V3NNbUp0UzBJUDlmdzJXd3BQZ2d4bjNweDR3VTE2N25SZVZwaCtLSHllS2ov?=
 =?utf-8?B?ZG5udzdjNGFSaUpWTmVSbndYZElGdmtUNm0waU83alYvaTZhVEMxZzdDdWF6?=
 =?utf-8?B?ck91U0lJSXczV2gweEZDcndudHcxcWtTVStORUdJWE15bmFCKyt1WlZONWY3?=
 =?utf-8?B?ZHM1RHRYYmxIVTVVN01URHRZeGRhOVR3SXNkOUZ2KzJra0hLSmplN1Q2U1c4?=
 =?utf-8?B?NGxPODZOSkxnb0Y1RG4ySnV2WlVQakdtMGMzWWFKWVA1Uk83d3dsZWY0M0dR?=
 =?utf-8?B?VC9XWWJlbmRmdFRwU0JoczY2Wnp0TW5FNVFtN29PRTRsN3pqaHNzQmhGVjBm?=
 =?utf-8?B?WDZzRFo5bDQyb2hOcHFNTFpCZmd1TFZ3OU04c0t6b296TjFGSDRjaDRpMHFO?=
 =?utf-8?B?L1lycXEraG5POHd0cmY5cEZJakRQOVFHRDUvc3NxalFTbUQvblNyVENkVEtH?=
 =?utf-8?B?MTFKRkxNeU94dnNsWkVNY0hxU2dHUGdid1M3dktvaFdjOFRMMWxrdnJwUEcv?=
 =?utf-8?B?YVl3S0ZZc1R3WGNNeHZXeWxaR3JhdU04L3UvMTNFQnZmR3VXOVJ4SDJWMWZB?=
 =?utf-8?B?VXdhQTZWK1ZVUC8wK0RhR01EZHhXUEg0K0Q0ZUZPMnlUbmZNUWhaQ3l3RDVm?=
 =?utf-8?B?KzFwdG0zSUdVa3pmSTI5ajZibE9vb0V6eDdNb1hTQVJqRHRyL1h1akVZczZD?=
 =?utf-8?B?U0wyVFd6b3JjWG1pL1ZZN2ZNUkVpSmhWcDdHYlFKTWFLZlV5ZWU5b0I5MWZ6?=
 =?utf-8?B?WDdCbjlncE5ldTdQdmx1a1FyVGFGY0xHaXMxRlVOZTEyL0UwMWVEUzBKY1FZ?=
 =?utf-8?B?SmRZQlhWTnQ2WXc5cVVpajRDdzdPd25CM1k2WHNKWEdvNlNIaE5aUlJVbUhh?=
 =?utf-8?B?alovemZuYmI1dFNiVk1pUVBabzVmVzVWTWJhRExzeHRrS0JuekcvQmNOMVNj?=
 =?utf-8?B?YXlMZkNwdVNFSVB3Q1NnMjBxM0RLcTQvZ2pNVmlzYnM3emVYREdWdjdUMDU0?=
 =?utf-8?B?ZDRKQjhPRVhTa3VsQWM3dU5ITUJnR0luVkdNU3IvT2dBQThOaVZuSitEbFpJ?=
 =?utf-8?B?d09XYmhzRXVtRnBFQ2pnRG1RY3VmVkR3TGtlQXV3amxjUFdldEhhdzBCdGpE?=
 =?utf-8?B?UzFiZDBjQXRNSTJKWmZXUzh5SnVzaDRrL25RTWtHclpJdkFySUZyenFUTXQ4?=
 =?utf-8?B?M2FXVklwZGZ5Z1drZVltU3hYVU5sNW1WRWZvREloZ2FYaVo0dncrdlBsVi91?=
 =?utf-8?B?WHdpZlJzcUwwOW5KSFUrYTRkK2FPQ3IzemdCbklIQTArejV0SGphMVp0SVhr?=
 =?utf-8?B?SlBIaXdHcGNFa2IrSm9aN0hQVVYvLys5aWkxSk4wRURrYXFZeGZGOExxS2d2?=
 =?utf-8?Q?LkaS8XKEK2NRcPxe0MXmzvouD?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6625b22a-023e-4d09-7d7c-08da694f7100
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 06:25:14.7099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjxFngDLKql08c2xmwHwcE40PXbKFgkr+cZVpPvmy5VP6zheCWyLDBbUwDRjYQwGgbq3tUF+pdKrBtHvXi+WYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR03MB6650
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

 v4: Added Acked-by from link
    https://lore.kernel.org/netdev/YtAKEyplVDC85EKV@kroah.com/#t

 Greg, Hopefully this is what you meant about missing "Reviewed-by".
 Many thanks for help!

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

