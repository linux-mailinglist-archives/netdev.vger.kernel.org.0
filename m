Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FF34B2A44
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbiBKQ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:27:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiBKQ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:27:29 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304BC3AE;
        Fri, 11 Feb 2022 08:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lp1NjTIWGKQ16ImR/GrZZIFb/1P50YqF+Ax0RsBKRHHZepYW/WeRHCTNiVpVTY3fUQ3M3mz1sE9PgFUsyMTIgMpOpi36EjfU6qYvvTeMS5RdLsXfh8ptLfyfSmV3VVKaFmAu40dktY3LYLLJYGuwBToVlNoUKmdL6OdaNQVbkti8sm6gKn3butFRJOtZZ/hXxiJs5Is6o3Z2wlfPref4zZOwSPNITom+2UCSoKy5XVrh9MVX5yJFaUyCbTVS0DK+/gRIiWa94Rb92tYZSq8CD0M+Ci9JKHH6EgOViTBZ8LqVLjKY0vtuOcA1kFEcx7ObfwcM8oNJMMr7T8loEeun5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qL81H/ZsDBS3CTJTCMeI3BGYUG0Bysra4XUil2DUdd8=;
 b=eZHFBVRptr6+9WmOLzm0JAXbbLGQWA/UEl63Sr5CnmHr56f85iwJEPMZW/ifxG9yFkMVcgviJzYIlrqGPInpPUMdd87rXiCOs0rORr0ub209hzK5AaTx1tZ8idCbPqFiBdXeP6usvYiDyajid3hIbdU07UhAYEdA5v/QHdMNT7wvBqvHqwqPXh1Zwdkq8iIuoXJQrhPikbj5fleD1ccVjG9HqL5l4AKgQrlsUbH85+BnSrUM5JdlbyurEiwaN8fH332zwYGlRMdIGJ5nIVhe7YzGtbZjOjPM0ONthRnZ3sBDvcywkCEdMprZXctJHMZtekBPiGOrKsuW7O+vZH1fYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qL81H/ZsDBS3CTJTCMeI3BGYUG0Bysra4XUil2DUdd8=;
 b=ZCttDuGAvyEZ3p2V5/e9206QPbPAwkE4/1KLMkwQz1d/NNtgYuWCWGnk97urH2v5EGpCHk30bYBqdyV+bwazwDdgBgk4lq4mQShKus94n0kObtrjjHT8e1C3ZzKfMY/KfTr2nmE7ZZ+uUsOPzs44vj8Fmmiv4Fx1KTyJ42qSG2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BYAPR11MB2776.namprd11.prod.outlook.com (2603:10b6:a02:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 11 Feb
 2022 16:27:24 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 16:27:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 0/2] staging/wfx: change config files format
Date:   Fri, 11 Feb 2022 17:26:57 +0100
Message-Id: <20220211162659.528333-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1P264CA0011.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::16) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0450fe25-a2b9-4d4f-2401-08d9ed7b6287
X-MS-TrafficTypeDiagnostic: BYAPR11MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB2776F35E0AAB82F1C5A54B7393309@BYAPR11MB2776.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RS2BkEmQ0ddUD+Mjvh4FQ3Vs9ybifxQtblHAs6SIrZ4KMcngZXhiNSJUux4u0B+KNJP3tDAnfwcBH2ssfqeoRA7UbBfs0WEW5aHXxotCpaH8OjAE2ml7+sslfk9so9R2D18DU2WE9xrHvwkysHCNr7MyRPSYhT+cy6RQmxJ6wTCCpMqSCq9ZbsaqI+ABMsOLIGrF31m8LYGLrWnX6ELyrlVAnnIsKESHG40B0g0vKHr8iQqTVWTUjaLZWLsEvLArGAQvMu7oH7p7Df/+k7rH4JiqWQ2CTQ6udYQu4Mp/3qs4BOqYhYUq4G4kNHeliyfVLp3tqlXAIbi0k8qxcDtGv4R77gF77D4VvuBm8JgTu5IIXmKA8t4soEv2ZvaXWZxH99SmmMKEYZp+K7xJC162pMoowwLPTx9akzCFJMR5kHsxuXAHxuS8OXtXF+WXW8UkJ4jCk1CE6VnEY1dn0zELclhIY0zfKvJKlEd+3ouIwMiM0NtEgoE1bc1IL4/T+cegnH7t9RkUC/ugp84RcAJeyIK69NRtis2vLXn40VmOql5GEcdYwHuuY1ENzLuuVT+qSk68yer6XgggONIL92lamAvwgNvXi+xAm/+KwkNfvw539xaw1dhA+Th8SrAX/0H7ob4ScXS/6UASdqJj8vmSL5XeG+aeloB33iUbvSLeHO6+rDtNHppCrgJMGzZKn8A3OjTxuuNN7NoxLmaIQKZuIU+apeHtuD5vx2YVkIgY03ZZ4k//YXR5zHajh+R9CtC4wL0pgubl2p289t/h0ZQ7YBJsUxIhoGUF91CQgosgb0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(107886003)(66476007)(4744005)(66556008)(186003)(26005)(1076003)(38350700002)(4326008)(36756003)(6512007)(6506007)(66946007)(83380400001)(38100700002)(6666004)(52116002)(2906002)(54906003)(86362001)(316002)(2616005)(6486002)(966005)(508600001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmwrVFkvSlNQWUlvZC83cVByTFFPd1VEeVRVSVJ5eUllM1FvZm4zckFaL3Zx?=
 =?utf-8?B?QlFyaXRvZXFoSmtkdjh1VnJmWHZnS3pCVmRjQk5QTGNQb2w1T0NWYzNDd1d1?=
 =?utf-8?B?L0VENVY2ZVRzenQyQTVUUGloQ0lTOWRHTlJudUVCNXoxK2RGM0dNSDlST0ph?=
 =?utf-8?B?ZCtpWkNmdHJRdndhYlBwdG14Z2d1ckQwSDVsWXlDYmRDTXFkeTZwMll5ZjRj?=
 =?utf-8?B?OSt0ZkdKSVRDaUQ1Ny9TZTNjMmc3UU0rRmlNMUFUQjh3THRQRmVLa3o2Qlpw?=
 =?utf-8?B?VWFoRSt3UFJMdW5wbG1kS1JIMndPUGJyMU5RM2pUZ1RIU3hZLzBLbXMvMGZH?=
 =?utf-8?B?dVF0KzRVcWhPaEwyQi90dzlFMjVLdW1uaVYvd3gzbkR4S0lxQkRQUVVPRFVH?=
 =?utf-8?B?TzV4VUNSeXVBelNUMTdNdXRBekZ1cWNkakQxSVYxK1E5Vm5BZGVxMUhDcDVM?=
 =?utf-8?B?YlZXWEVsc0J4a3RXaFFBSS95cEVSalp0ZUxlOWdoTTFpU0xGMWw4QnJxbEhX?=
 =?utf-8?B?YUJXOE52QkZlQjFRYklGREt0NXpRNFpmN1QyeFlDN3MxUlN6N3JGRXB1M3pW?=
 =?utf-8?B?OUJtSEhHK3lMZitTL2w3WXR2MGYwWTkrOXViL0ZkTDFrbFFNVGdVVE50QTJn?=
 =?utf-8?B?N1c5NC9DMTJQZWFYeXZwNXpZM2RRTkJVZVcxVkx4bkwwbkszQjk5WTcwa0Zx?=
 =?utf-8?B?Q1NTTjExbHRLU3lCek8wL0VNV04yL0xrN0l3bWZwWVkwRlV1RW1DdDU3bHBI?=
 =?utf-8?B?eFRISkZZcFU4WjRQYnQ4b2xSaHErcU1EZ1NRWldxazlZQnFyVHVXSXF5OWRU?=
 =?utf-8?B?UTh3ZDZkOVdvU3RESStLWEJKY0tOc3AxZEJQaWZ3K0htb1g1dDgzQ1orZTdY?=
 =?utf-8?B?bU5uZkNPUU1ERkpTY2lOMnNSNmEyeXh0amdUWXdsL2lZUGhzeWg0U0daSk40?=
 =?utf-8?B?Y3BDSTZ2cHNWKytiYmIxVW1kQUZpYSt2eDRxQlpNc0d4Zmx0b0EzTENDU0Fq?=
 =?utf-8?B?aWM0cHRvV3Y2aXM3U0JoU1RZR044d3JZSkJSTVB5Umt6MlJUSlUvY2tmS0Iv?=
 =?utf-8?B?ZkE1ZmpnSGxxVzdMSXp5dzFBa0tZMnJzUnlKSGR5Q3lxdkgyNVVKQXhlY2Nm?=
 =?utf-8?B?RVFjd25uZVJUekV1eENHdW5XN2hEVWl5alRaY1NEOEk4NFJLaGM3RTdhQlZk?=
 =?utf-8?B?NkFIanp6aXh3NFVuMCtuUklIZEFsdmZiUnF0aW9XZDJJZ2hnMlpKUUIrbHFT?=
 =?utf-8?B?YmN2SGFVR0pCUWxXYlFoNVA2TERHNmdsNUwzc1d0WWtIcDVjK0lZbzZjVE1L?=
 =?utf-8?B?aVVad1BLOVFVVGVNcFIyZzkzR3RjWldRRmZ1L3dmUzk0aisvdEU5TEROcEM2?=
 =?utf-8?B?VDc4UERHQk5rdkcrMUNwb2RCSkM1QTJnYXpWbWwwbnVGQUR6eWd5TDI4ckYw?=
 =?utf-8?B?dExHdDltQ052bFVjelBQd0Ywbi9MOVV0UmtUMkJuMXdCaTNzSXIvU091TDQx?=
 =?utf-8?B?cytaM0tvelh1d0NNUDR6U05ZeU9ldC9QUUc0UjZlZUZpbVlwN3JxN0VEa29M?=
 =?utf-8?B?ZWVEYnZGc3ZLV25SUURDU0VpUWZTay9ZYkJEWGpNUnp5bzh1UEVQREY1bHpN?=
 =?utf-8?B?NmdqcGtTUkVRS3JuWVNlWHkxcTNYbU5uSHpmRll4NWRTWForYUJwdktUcnQ4?=
 =?utf-8?B?eDNCWGt6NlZrekh4NzRuZitlLy8wSU9QdGFpczZhRjZ1WFVGdyt1WHBZakFU?=
 =?utf-8?B?NWxkUVBER013eUpmS0p2eGlpREtIVDYrOWNIMlFqY1BoOG92YzFUZ0JzSDA0?=
 =?utf-8?B?MDJOV1VmNFYrcmEyWFowaEdKb2pSYlgyUlVRcTZ3WFA0VTVRY05BNVNXOCsv?=
 =?utf-8?B?eVZseFV0TkVlS3BjTDRyWjVtemE1bTEvMjRXYUczMEVsWEwrYVNWckdiMURU?=
 =?utf-8?B?OE1oZWs4bVdwdVcvQkNIbGFjelh5TDd3Y0l2WWFTNXRJcERpZ0FYK05rNXRx?=
 =?utf-8?B?TGpjSXpwaUlSRlFtZEhjK0JodGxxSXNKbFg1TmtmZFlReGpBTFE4KzRpN2xs?=
 =?utf-8?B?K3JFQS9OYis3cVFBYzh4bGdzWlBxM1JzZ1FidWF4SXdJMFZHQTA2OXFObTZC?=
 =?utf-8?B?V01IVEkwWlBSUGMraDJtNlVYQXg4YmJSWTBHRjlHMlRuYzllOFh5M0JiYnJX?=
 =?utf-8?Q?jZFYvOudV742fbA7Yz1aaKQ=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0450fe25-a2b9-4d4f-2401-08d9ed7b6287
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 16:27:24.3494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGWUg1jNtFQr2MQsCcLDfsPTeotYrsdsNpVp/OM/GuKmpOTrmMExJpyrJb3CPaUwh0zTltsAuG02UqrrYT/ksg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2776
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSSBo
YXZlIGNoYW5nZWQgdGhlIGZvcm1hdCBvZiB0aGUgYW50ZW5uYSBjb25maWd1cmF0aW9uIGZpbGVz
LCBhcyBkaXNjdXNzZWQKaGVyZToKICBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvNDA1
NTIyMy5WVHhoaVpGQWl4QHBjLTQyLwoKSsOpcsO0bWUgUG91aWxsZXIgKDIpOgogIHN0YWdpbmc6
IHdmeDogYWxsb3cgbmV3IFBEUyBmb3JtYXQKICBzdGFnaW5nOiB3Zng6IHJlbW92ZSBzdXBwb3J0
IGZvciBsZWdhY3kgUERTIGZvcm1hdAoKIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIHwgODcg
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0
MCBpbnNlcnRpb25zKCspLCA0NyBkZWxldGlvbnMoLSkKCi0tIAoyLjM0LjEKCg==
