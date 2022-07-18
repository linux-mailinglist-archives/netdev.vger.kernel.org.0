Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E3457826E
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiGRMgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiGRMgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:36:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FFD1208B;
        Mon, 18 Jul 2022 05:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TV+/+Ej+VEtEcoNDUaQtBXc2q46RE4p8y+nnRGwhKfZjbqr5db4F6gSaP7K7BZsShQyaATY6oGrR45PJum4SaUwHhT68YjxIGjYYcJcUz4CkSTb8rxv4LJTrxxFuZ8QjkZuA680myEH9mdaGmVNa+mdDrTdol5jW6SzP7aq4UotdSWstewUp6L72iFzggnNQpFevwgQPysL8iFI0SDOdEBg/hRcDAM+VVa6rKqpqWrk2DzMxvyv8UrCilJY3n5Ad9TsKl+c+PQC5J/0md7MqZFP0Nd4NMGaWU5KNJlRi6rJ192Fp7QalTGK9tQklrKPOGyGan+5N8bKfGhBxMzGTJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJQI0hAmhexuLXkjWH3+ocOV3WjwbED2k1JAaTmwf4g=;
 b=aWoX8hjoWniO+B+w4WS4FvGwQ9kpLtEJLF7PK5lc2DEC3GO3S8v/SziSDpsBepDk08FrCRueUZdC1Tup8SpPzxFLuUk+j4N7otqgVKzlojkEkq9uzVW8VSG6wHHMXWxffTgqNpkDd05YnOa7uLkpiAWBpsg1f2FdAI+dNnK2Vv11MUfhUCoa7/oHMb+W5DMnJKJQ44tRiTNBLS5B44zy3VRLaAP1pBXia5Fc2RFUhfRt6bDT9UOloXZ6v/I0UmgZ5zB6FCF0rVRkIyWrWupHIhxB2AEgh5AJbsQSnBrkTF59wHrwGBVdmx6DyEjL5i0RsyA++7gC/jOk/R1QZ6Npew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJQI0hAmhexuLXkjWH3+ocOV3WjwbED2k1JAaTmwf4g=;
 b=MO93sdu/Nod9zCb5RRBjRbK9LgL2JdlYqXqRmc+07bDBFz6+Z2I6RNbb/8cinRbbURutw+FBSSqjwGqywd/uvVBtHmRnhegkZmoNJeC17KwAyrwtbKZCbIcuILfDA9zmUEk3j8vxyKNBzMDOaEzqAeAt/KhWuCJd631bXjicdr0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN9PR03MB6171.namprd03.prod.outlook.com (2603:10b6:408:100::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Mon, 18 Jul
 2022 12:36:37 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 12:36:37 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com, Bernice.Chen@synaptics.com
Subject: [PATCH v3 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Date:   Mon, 18 Jul 2022 14:36:18 +0200
Message-Id: <20220718123618.7410-2-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220718123618.7410-1-lukasz.spintzyk@synaptics.com>
References: <YtAJ2KleMpkeFfQq@kroah.com>
 <20220718123618.7410-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::12) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 503eaf02-1267-44ee-d5b6-08da68ba2845
X-MS-TrafficTypeDiagnostic: BN9PR03MB6171:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEDKVlIQyUbMsoBgrIHvBRZh0dfg5Br9P3Xzqk7TTo3wS0JcRTYPq1g0MDuKkAS0IMvJ+72oSvJrt0ghWSXCKdpZRlFXFe8lRjUTy3y7rM119c5hFXMsfx+HCiCCYXWBLP9O0Hwd0KIH+U//5bRJP5WZQYEM4UHRUJ2sJ+G0wybK42s4fuVOmKm8wPyvacQBMgbc0Kh4Ol6dhVNt5IljHY9L2RvS2Th2zeE171vLbsxZbGlnJaH0s/xIWpLKIBMiX4jmPLIC8+5FEyJDVlZ9vgYw3Lf+8pHBTfWo1pkooAfvvifxMlSVxbqq596265uLMx8LA+dYg6Exznq7IE/MD90qYKn0DOTihnkMVZEqFWEsRoH2uHbrsLDtUiwuddYzcvVPQsnsdU6EJKskRsDATY/j0kN5a4PIH7UsRHyIEHpN/dajUJMZRjW5FZEUu8CstenLFb5uPoFaKiaf0E4gLhxqyz5nDwNDVdgbFrPQt9mJt9oeLrLnuHJpAJAyL6TzC7l4WlCuHcpqVHyKP5J+XZTVazRacd3AXawp6BgLPg2IfBxOH5yEkTlOLwCNRIR+VC4Zj+D1Tbyu59cE63vWS9RVBmv3D8sbMt6heiJVqIy3ytOiIet6PKVA/icgDQLMEGPD36vSCnusBMcxlXPOVGRkufZ+EO/OZaV4wLANcha0pIKQRvLueCS2ECES8IBF+lEn8fCyxdCPAczMEO7saHIlhUNCotaxHr5VhtvMYJooU0SgFnLIixFayjPoBKeGCCyv9zKHPZeyg+RJNGz8yfeGmU56w/HALwI5YUT5D0iLjfHdRBQOPdxx+v55sHpptI86LRbVamugSnFqN1+DuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(39860400002)(396003)(346002)(136003)(6916009)(38350700002)(38100700002)(316002)(36756003)(66556008)(66946007)(4326008)(8676002)(66476007)(26005)(41300700001)(2906002)(6666004)(186003)(6512007)(83380400001)(86362001)(5660300002)(2616005)(966005)(6486002)(478600001)(8936002)(107886003)(6506007)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkQ1aDBseXY0aDdrVlA4ZWhyVW50eVNPeHpUZHVxUDF5UGFDSXRYbTBGeHFU?=
 =?utf-8?B?VmxZb1ovd1ZVSWFZb1J2YlZjVDdPU3ZHd2R5ZnR0bkxiS3VFZmJCMFB4QkdF?=
 =?utf-8?B?WVJiOHhibmhTN2lnSXFUTXFqdjJpdEtsNlhaM3ZJTURSdDB6UFU0UU54Vkkr?=
 =?utf-8?B?em5TQUFKeHovb2dlVTFGUE9CZlRzZ09ZZHhxdnF4OTZYaGRBM2l6dlNJUTIz?=
 =?utf-8?B?bkh5Smlidm1WUXVzOVlmN3k5QlRFbExTRmZlMnpJcTdpejBIUE5WV0l4SjRp?=
 =?utf-8?B?MXNZS2pNNEdWWlNvYlNJT2Rxd29JbW5sMnNWWFdlY3RJQmN1MmU5bXhzM1pL?=
 =?utf-8?B?SVlXQTNQMEJHbnlQdHp3N2hhV0lFb25nRnBlclNET3B6Z3JyNCtHUnYxYlow?=
 =?utf-8?B?c1ZyVG14QVpmakZRL1Mvdjc4NkViV0ZxcW5YbjRudDJwUzVhZy9XZmZVTGtn?=
 =?utf-8?B?T2w2YzRjWWFWMXl6cFR1bTcrUnIzWkpDdzJ0U0NNK0dGSzh0a0s1K2dHYy90?=
 =?utf-8?B?UjRaRWF5ZzRrb2gwTnhUL29xcHVYS2ZuaUZyZHdGQmZHNXg0VXpHcVp5L3hp?=
 =?utf-8?B?SnZsNnRUdTJ4RWxpazNKak5EOElZQkdTeE9iVmpmTWhVbWZreW8rdTI2UEk4?=
 =?utf-8?B?RUJWem40Z0lQUEMvbGxnY2FNcDVFR3ovWndJazNRTC9PUEpTS2wrUGkyNUpL?=
 =?utf-8?B?d09wdFNtbkU3czdqTXM1bncrSlV2cVpPcU9aLzhKK3RudC9CRDQ5b0hyeWI0?=
 =?utf-8?B?cGZyUUgrdzM0V3F3TUFFQmNpZWlsSFZtMVd0OVY3WG93c25ET3AxSkVLeHpL?=
 =?utf-8?B?bWhQY2crMkRrWDI1VUpzWjBRazZLOWdrem9nbzhWdDluT1NoSEZTYTNiOGI2?=
 =?utf-8?B?VzdOU1BjemF5UmFqbGFxWnlzMzd5L3orVTVUZW04WkZxeVk4b1FaR1dJVXBs?=
 =?utf-8?B?cVVaZTZiS09YN0daKzdIa21yeDlSdkZJYW5BY09ab1piSFN5bE1PKytiaUJO?=
 =?utf-8?B?OTcxMHVOeFA2eXpxMjBudzlRa0NwdDRxenJla3NyNktldDVHRDA1dEM5M0Rx?=
 =?utf-8?B?UEpnQTIyWVlheDlrRXRtMGwvNzc2RzFNSUZsRisySmw0cHJUdzgybzM2STZ5?=
 =?utf-8?B?UlhGa1M0K3ZBZysyclJkdXFYMExKS1hUaEp3WEcwUDJhRW1xVy95bE9CUkFO?=
 =?utf-8?B?K0ZkQjNULzgvTGxNZ09QNDQrTUJhQUZWYjlqc1dYUVhyUkRjc1l3MEpMVm5l?=
 =?utf-8?B?VXNoOXZ5S3o0UjVsL3NRY2dJN0lVU1R0RG9mMmZ1K1N5eVA5cjdBWFZYNndL?=
 =?utf-8?B?ZmFkbXFycnBLRTlzWnhBUGtCY05iSGltUGJBWW5sa3lldFhJUUpGcTZCQUdN?=
 =?utf-8?B?YW5kYnB5Z1RNbUtCVjRJRjh0UVF5MXY1L25qbmZnem1aeTI2M0hWVWh3bnpU?=
 =?utf-8?B?cEZRakUxLzlYRnVXS2dkSW5FbXppNlFSZGxVdFZEeHkvM3FUbUtnd3ZIaXFZ?=
 =?utf-8?B?N0dkc2RFV3Z3VGRua2JPeDNjSnpueFJrZFpZQjVHSk05MU55SEQ5clJZaFVZ?=
 =?utf-8?B?c3BpZnRVQnVvdVBnTjVqbzFmR2xTSllTUjVhRWFkK2t3RGxKbytJWEtlSCtn?=
 =?utf-8?B?dXdwdzVrNWdhbCtha2NFdW5uUnVSNHRMZG83ZzV2QmVoRldrM0tzMW9ld0xo?=
 =?utf-8?B?OW5GcmZXdVZYQVZjOVNHWGJsRUE2TE9NT2Jic3RDNDJNUU1CRlFwUzNHWi9C?=
 =?utf-8?B?QjgvdFErSVpramVVbHcwV1ZvdFYyMGZTSnZPS2l4WVlMbG5jYXgxeEFHVzZr?=
 =?utf-8?B?cERrUHlUSnU3WE1JY1BwWnAvQ0QzR2NJeUdDS3B5Vit5V0RUM3lUdzY2ZW9k?=
 =?utf-8?B?d0xubDF3a3V4dDdJbUVJR1pyWk5XYkVPdkhDY2VJYXl5OExYNVN6b2JRcnFK?=
 =?utf-8?B?ZUdDNy9MS1BtbE1uWEViUVNDUnpMUjJmUFp4YWZKTUNwWXlrZWpHb1lmMEFE?=
 =?utf-8?B?NXMxbUQvejFjSGg3NHNjYUZobUppb2xJRWpBTjF0STB4dW9BOFNobENUaW9m?=
 =?utf-8?B?WDlhZjJWRlpyb1J4eHplTUs3dmRiaEFkVlByV1FGRXFaU1Zxc0Q1dHlvVXQw?=
 =?utf-8?Q?gRiwRVyEVk8gHb66WP/jJ1XKi?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503eaf02-1267-44ee-d5b6-08da68ba2845
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 12:36:37.6623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Wht0JAiiGQBybE5g1rjb7ESF9VXhlN4Z0zQALn0aE1sym6bzwZvfMiHeZmVElOfdqoPW/AoYjalt41nzU4scw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6171
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
---

 v3: No new changes to v2 2/2.
 It is just rebase on top of changed v3 1/2 patch

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

