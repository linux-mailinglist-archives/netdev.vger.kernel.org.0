Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B608574CB5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiGNMCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiGNMCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:02:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957065B7A8;
        Thu, 14 Jul 2022 05:02:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmV3B2cWwCA+GiaU+5P/6ngrJacg0wJk5n7MmWqtK12rlPirabDxnPQq2F0BOvmO/T4xqCDYM50MEXqNM6iDB4oQORinsGSojxMIEyCsLlZqK7F49AHeVe63xzLtjAnvmuku368PJc55umyr7LfhN556mBT5Gj5atnfpFsJoP5lvQa4E+3U0PDVQDbf6QNyp8QT1LZqxKe7lu9MkQmvEPj1YxBfwt3o1oYoUeJ2uSO6tvR9qtUorjZevRNKKDimyxLLjJH72ZMga/JQFN6QbKSXlds2vN/zBPf4vmkHE1FjkppiI0R7No9ztt4FgmqGSafrT4ID6u5BH2/ZhPeL4Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jj0IMuqd/2MlflydqPd1Io2VhHfqWlTaHZA5efbPWw=;
 b=OFDMJGtK33pxhNeIXVes+z+Tkh86xlehG8tRKWu862UzVBfY15iWH3igGswA6fq18zzap2tkvD3pUi9DzQk7Xa7T5rncI8M/VKLexPsdyFA7Vk9/L6L+q2fam+0MF1XRKn9NHx2qZosJIWXSxvNO7QIazFKXUFV4fi40bZ3Cr26WV4cyRQjj5p1j4fEIs6zohM1pxFsDk8rFsNxBqlLNHAV3SWyHr7SipVBNEJKYRD36RCVuQjecO1uYKBVl8b9+CAoI07E2PTbwWOqCZNZpK7WmfFv/RAeSucOWLSyAmOfp7qvcT/5ODreM9BwXAcbXFGH0/STZuY+ItHlRxlxapQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jj0IMuqd/2MlflydqPd1Io2VhHfqWlTaHZA5efbPWw=;
 b=JlkltQOC4qWMCfw08NIpBZAvnnt+adVci3q1GERraU/2i/0M1IVQMHBv/gPttgJepLEtsa7HlPZcROAkrdJsNvpv6fL3vvjFoosaz767yJp5/JBYQkMzg1wQGSnYEHrk99n/7S3peF85pvez0zktoxnpekWuG+M2ItKiquxF7Ic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN8PR03MB4915.namprd03.prod.outlook.com (2603:10b6:408:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 12:02:37 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 12:02:37 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com
Subject: [PATCH v2 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Date:   Thu, 14 Jul 2022 14:02:17 +0200
Message-Id: <20220714120217.18635-2-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
References: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::16) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce38c537-bc5d-4adc-3b9f-08da6590be92
X-MS-TrafficTypeDiagnostic: BN8PR03MB4915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uU8mZIjWxj0F7kPmM7SGKnzc+TlScc88sf9ETJVoXsqbxMS6Op8TOT92g6J/uOPBXNq5pdkSrL1r/PZFmatLmxWYSjy9B8Y1f0fpI07MbytFN+8LZHO06umBPOvcINI5LBjreWHgwyHTrDMKloJ5PsP3ekILQd3LywulYCxqqM5mBDQ0X37+TPmTqrTPEd6JuxQOgqKB3XvMNMDe1gGiSGmeOznxHj2p3bujt8e6VeUHOAsw7jiHEJC9aB5O8SVjLh0j6lp5f79INR7id+bw1omUhsGJH99I3hiomrooeTeeDvj5bbrHmTLv/2xipMyEzgNDoq246Df11OOEzzvJAp0qg1fE9pzblznOnyO/051wFjolTw5qtz1s4Uirlrbjl2xt55DoZRsedPSiRQKAQgyXF9Z+0yHxy8KKdib4b/Sl8NLyb4vXb+V0aUXKUXtiWWhICxsltotSn0O5s9TsYsSCfMhyK1gl5+6rikKAIwy9vx/HqTrMmEkR3lEZnsHHW277hSfIGoAA5M2xCfiOLF5ftYNfnx2DV2pucqFjgrPA3Owie5Tjmez6EMTJtrRE/uLFxjy5FJYWi5mCxq9k4U+VACU9MpgDXvuAziGmfBJoQKSiJFOkXx7sX/raqKEE80Gk7zOhAMb1gLsr698AZE14c7Ga3Mhz1PYcMp1cTK/BIXg7VZxlGFKKkzRrdLziRr5dWhK9j7v+H8AyA6F9FgPN0Wp/gnP+03P80EMvqPWxbK5CT3JevNu1GfnweXaLGcFwRdeiaLWzqQtUDoEYNiXC8F8bYZPg2O+3tEFbnSbJ+mqkRha3gwWk+1y+40Wjmyr/MdH2WFW+SC4XYL9xvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(396003)(376002)(346002)(6916009)(6666004)(1076003)(6512007)(66476007)(41300700001)(316002)(2906002)(36756003)(8676002)(6486002)(66946007)(26005)(5660300002)(186003)(83380400001)(8936002)(478600001)(52116002)(107886003)(86362001)(2616005)(38350700002)(4326008)(6506007)(66556008)(966005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjNFRytsR2Vsc3p5TjBEdnB6aWZyMmY4UVlQK2xZUWI5cnpJQ3pUblMwemYy?=
 =?utf-8?B?RnloclUxRnhCT2JYcElsMjI2QnptSlY2WWQyU0YzR0tJdWhGWWNkVjNiNFBT?=
 =?utf-8?B?RFZ5Z04zajFhQlNQWlR0Zmtib3VvQzZJaDQvZzNkRTlPWkhMSUxuQzI2VnBH?=
 =?utf-8?B?ZTZabG42eGprczFRWXE1Tit3dUVUQnZOZlNjRDJyL1BaSHR3QlFDTHVLd1hL?=
 =?utf-8?B?bFJZWXgxQzdjT2JDNDZZMVBhQTROS2hwZGUwNnBteHdpdW5LS3dWWGMyaXpL?=
 =?utf-8?B?QWJaZUZQekp5cHdsR0tCSFlzcjU4T3M5Z3FaWTZmendQdEhmREdnZmk5Z3RC?=
 =?utf-8?B?SllRd1NHSUtsNyszY09vZjlqK1M5em54azVxM200cGUrdjBjVmpIR2NMSjJH?=
 =?utf-8?B?OUtnK3hPSFg3c2lURnpwSzR1ZVVIalhlZkhMeHJ4Tmg3dnlBOU14R0N2NnJ3?=
 =?utf-8?B?K3ZxeHBuRTROdWxhbFlpQnIxR05iRzlhb1Qxd3FyUVZmaEJleW9mckM3KytY?=
 =?utf-8?B?d1grclBNY2ZwUU5FNitOMWFaQ3NqbFRzeGNpT25xbWg1RERCZFkyekZTWTNi?=
 =?utf-8?B?ZkY3SlJ3RUZiRm12UEcra2RQR3ZxZkFGTDRTNjlYOERaMFMxUDd2T0xwQ1cv?=
 =?utf-8?B?d1dpSGdUSGtaN0x4SExvUXdNUW1LWGUyZk9sQ1BUblVYTEJONGp5REpBZU82?=
 =?utf-8?B?c3hXNENXZ216VzZLRUEwZmY5dEhvNnF6NDA0U1I3eHBRNTIyNDN5Tk5EMGxx?=
 =?utf-8?B?UDF5RmUvVVE3dGMrNFhQcDM1bVdHczJMOGZ6bVVxT1N6SnJIRG1LdXlDK081?=
 =?utf-8?B?VVBBSmdod3RvdDVCLzNvZjExTmVDTldZSTF2WjZxVVhTMFJOYzl5YjZZVDdR?=
 =?utf-8?B?NEVsTUxoMk5zWHRNdWlLUWNSUjFNWGtJL3pHWWZ1T1RkcG9SUS96Y0ZMRHRa?=
 =?utf-8?B?dS9vYVRvcndRZ255UmVqQjlGckgvaEw2S2FkVUF0QzNPdS9naU1sakU2aGRa?=
 =?utf-8?B?eVEwZEVYMEFXYW1sclUvMTVlVjFldk5vNnhCU3VYQ05Eb0xCMExvSXZkbk1m?=
 =?utf-8?B?WU9NVzNINlZ2WDd5TFluWUk0eW9DTE92TEdBOXpLR0xPZU44SUlneHovVDZ6?=
 =?utf-8?B?VXJxTUZYM1pLL29BcWoxYVhaYjVUY2FqWk9iblhHQVNqcjN6ZHVDeFJ6OUMy?=
 =?utf-8?B?QUoxUEhZUkFIU2ZoU2g2bXo3M0JpdkdqeFI2eDU1WFRvZVJ5WFRuY2l4TmVU?=
 =?utf-8?B?SFFyVC8rTHNEYVAreFBmYkV3MXhPcjlka2xHcHIwaVBhbnVYU3drbG02RDll?=
 =?utf-8?B?NU01SGE4QmROQ0FoZjQ2ZTZHVVdkRVRqVjNoajZOZ1pGa0lqQmo5ZHhqeUd4?=
 =?utf-8?B?L0Fxeml1bzBkcW8vVlo2dmpCeWZmNDRZQ3k0WU5ubWlwckw5WjBJL3kva3g1?=
 =?utf-8?B?emNBcFVubjJrTGZnamtpSk94MHJrUmgyTVRFWkFJK0pVQ3dXYnJXY2ZmK3R4?=
 =?utf-8?B?K3UrQk9EbEJHelZraDMyU05ubHRtcEV5OEduTExNeGU3aXBDQWREaGpRV3JB?=
 =?utf-8?B?UFlkeFNpQjAzdlF2TDZYRXNLUFBITGpXL29kM3F1V0dic0FoUHB5dG55b1BF?=
 =?utf-8?B?SFUvSFBLTHdKd2dvZlhlS2gwM1p1MnRmcmQxMEo1aHpyUTBoVGg0Z2lHSnJJ?=
 =?utf-8?B?L2JCRHE2TURCQ2E4bzlxcURJYisvSzBYMEZWQ0V3UEJxaFlKVVFtSjJsVjB0?=
 =?utf-8?B?U1prMlFNTWN6THJVdVJGSDdIUzV6MTdGMTRsbEpLN3JYMDZJbW0rd3c4ZkMy?=
 =?utf-8?B?TFo2RWRrYWlWQjFYSWZRYlJtM2M0NlNwZUpZSnJ3aXZEY093bm9HSHBvQ0hu?=
 =?utf-8?B?SFBncW1pUXpvNklWa1hSUmlCaitERVZuSUFveUxGeEs2cGdRQ2xDMnpYZ3g1?=
 =?utf-8?B?NDcvNmJFb3FOT2plS1ZHYWYwT0VrVG9PZ1M1cjhRWm5Bc2c4K1RjY0pYZzNt?=
 =?utf-8?B?elp2a3lMTklna0ljaW5mNlMreDBCbjYzSjllUTQwU0NYWnlGdDJYdmc5VnI5?=
 =?utf-8?B?czhQSVgxQ3l5RVdKeTBlVzdnZTV5MWx2d0hnZjVaZ2E4bnlPcXhUQ1MwSkpr?=
 =?utf-8?Q?++i+IfJbeGeaEknb8GKFAJqTm?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce38c537-bc5d-4adc-3b9f-08da6590be92
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 12:02:37.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUMTOkouYtZWlVkWMwnRzDYmb6rkGwmww4evyrwZsFBdse997ts/85KnglgPnrMlpdjZjV85Yjc3yd713KjY8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4915
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---

v2:
 - Information how to change tx,rx buffer size
 - Added performance tests results to the commit description.


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

