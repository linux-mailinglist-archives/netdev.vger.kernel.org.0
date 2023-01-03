Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820B165BA4B
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbjACFPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbjACFPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:15:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41D1D2E5;
        Mon,  2 Jan 2023 21:14:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIY134iWwbUmQXwKKv1mvQ+/MpSBf8nJ3tnOwOTGu3x0Rfu9jrgJ57QJqaybmPw3c3C7zpoJxa65JlS97MIelCmWeEvJNuFz8+gbtLejcJitD0qhvkW2D9Z2Yt5uI9r1Zbje4yNzv5VTKYlyQKKutC/FjcgCQXkJaS7lsMKg8poDNj0lPMMTtdq/Q+bes4uIQye5Gd/j/VW/3ryWDRB1Bn/zw+/Rrmti3WCb3ORNfVUrP5PA06ahdUWSe3goJ+sIlOGu7rUDp4GO95l5FoGNjfpCey6YGUkaKpktkpWscpwWqlm2SmFyro7xQ+BIukLHj6ZwVZ3ZFPMdwW7VtKTT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mC3mQp1aiXk0EHSKTIPwjnEkE4DWNaR6/khz2EeS1VQ=;
 b=WPJ4KLD1sPwRK8ozbclgO7+mao44oT0h7rq+RQerygsrDcmGTlXAoqPnVLgNXEua1rNj2d764pSNY9e7XdiKExeuh65MKCQKynhTC47FPgDZAKgiEVJlLB4tbLNJfQtPGNmW3MKSrFZO8/H6IfSYw4QPoDDXUSfSM/oV7Yj+9gIaEIR5RI4B/GRiNBbN5WQel+Ve6J8PbVBx7ro+aF4mN7ApTXmvaeJchgEqiiMyvNOAExZN+AVxjSkIpHLI89giiXXjfMDEPDcX7JLPo19tPPeewK8QL2OGe+o+HPmghS1uWWteenvYzCrOMO5Rq8Oz9/E+jWvJPZoHTXhlk4QSLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mC3mQp1aiXk0EHSKTIPwjnEkE4DWNaR6/khz2EeS1VQ=;
 b=EJhiBKQv6dftpWgiSQrBIQA+J2xpI5ukuXx6tILi6LKcywrb03sSYCIaxylW8qE0cLguzMnTZ6ZAHRe91p1unqxaipl6FARZmqj4HfHbDCnlnc5JsmP6mJrDv4ZWUT89Y9RXUtBkcWr6Vg2I1IMqPPOtquoms3R55zUFuQgxqcY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6252.namprd10.prod.outlook.com
 (2603:10b6:510:210::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:29 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 net-next 07/10] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Mon,  2 Jan 2023 21:13:58 -0800
Message-Id: <20230103051401.2265961-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6b5105-f066-43b4-e7e4-08daed4963e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UFXlTi2D2apq6CGPtAive3bpgPZDQMFGkPiHD13OsBGkeQsw2xOd/Nufwf8kL1CBhpqxB3FNi5XMYnYJDAkJMsftaZu66XswzRSLJpyEUZh0pBLiLPg9mx7ok6nFLzH25mY9WZ9YDDYiZug0ubIRo8ln/DrOLs7fLiJ4fVIKzPk6cTd2dxW9W1MmlYSXowU+P+EI6qo+KHnorQUYJ7t4DGBLP/kSCbYzMY0yqGrQAjKyapo8KEYrBH6Xe2CXs50EJHEPMSJmu8gMV8Ezxuguz7xdMUKCjc2ScnliZNtSH0smB2UAR/L5zNsD3qd1S8IgxlWnBNiofLzFn3nL2sKSIfvUW3giGipJ9Yb+aq+Sy9ty+ZG9VdRyYqKIYo54eysuYJBQ2O2SGaPyu3kuSCCkYWTDbZ2CoAGNOdolcLKTlsxGcvADCckMF2Yv2CyeSXQcQxks6W9e9TkAD0msXT2Drd9MQMl/QKp9D98i4+NwTyDF0TJFOtPzVCpVgcF6DOLXhVX/AHmzEqTqivcJwgrXNuKAlQ/RJTBvpbXbyBxUqdTSVh4pUPxoH54taldmyO4DRnAm6yKvL4KW/GQTqXLF+iuFtRu2SZXcpydysA/lSPYcWNOBo2xSrhqth0Dm5lU22bX0NjRvIB7ZDDzxJp0g0VHp/XkuKhnzzPTrsaTYtiwkR6tpfV/RDV5L35nqoz4ECMuCBbv27VEwzBreW8i3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39830400003)(451199015)(41300700001)(4326008)(8936002)(66946007)(7406005)(8676002)(7416002)(5660300002)(316002)(54906003)(2906002)(6486002)(52116002)(6506007)(478600001)(6666004)(66556008)(66476007)(1076003)(2616005)(186003)(86362001)(26005)(6512007)(83380400001)(38350700002)(38100700002)(36756003)(66574015)(44832011)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THgxdjFxTWp4UUcwVlJhU0ZmZWx0N2M4bTFoWTNibERWYWJCb2p1cHVDTHN3?=
 =?utf-8?B?YVU5eVZHenJCTDZZZTVuT0s2YTBmdU1zU2FVZUcreWFVT2R4c05RT3ROV3J4?=
 =?utf-8?B?TW0wU2FSdkdTM2NET3FYcHpDSERpUEQwYnBta0tScDJPaHBFOFlnczc1V3hG?=
 =?utf-8?B?a2tRNUlFMFdqSDZ1MnhDKytCQ1pMNDBEYktEVE9NWVBQa0hRQU1aWWZNeDcx?=
 =?utf-8?B?aVFoeFVmMmIrNkpGNjNmSmgzMEJuVkxtd2MrNC9Ca0FVeU8xQmJ3dHFCK3RP?=
 =?utf-8?B?K2lFRFJMQ2RydXlDczloR2hhbFdOVE91L2ZkVDQ0NEpldkwzQkNRaGlDbzFV?=
 =?utf-8?B?VXN0Uk52c1NjaUhwZmJPVzIxa01hUzNodmJxMDVlWFd3WGN1Y3kvTzNLODVh?=
 =?utf-8?B?elJDU0loTG5Oa2FUSkszWjJqWnR3VHBuUmY3bXIzekFqY3VHV3lhbEt2aFNy?=
 =?utf-8?B?NHBPS25XWFEvclQ1dnJFWGVvM1oxRVpObWxCVDgrRjFkKytxVzN6UmNWY0FT?=
 =?utf-8?B?YktUdU5KTE9QaktRN0IxQVZzblhKMUU5MzJiMmNNMHZIMFhiQzdUT0VxdjVO?=
 =?utf-8?B?dU9vTk5XbmFISXR2MnJnUnQraEt2VUVNak1vRCtyUk91OEVPUU4wbUI0OWFv?=
 =?utf-8?B?RjZ3REtKUXkwUWZsdXA4dnphQlNMdmlWdVZPcTNReDNBcXJxU1VrS3Vpd0Fm?=
 =?utf-8?B?RDZSSUVFZjJUb0VRVjhWWUlnRHVwRmo3eFVCRkhoUzZ1OVZKSXhwV1BQekR4?=
 =?utf-8?B?Qm1ick03bkdCSzRFclV6aHpKR3hrSXZQVjBvU21paDc0STNSU1BHZWJwZHpC?=
 =?utf-8?B?aHYyeEc2RWxkZlpzcnRzNFkyckgvNlJxSGtyNXFmdFlqSjdKV1JNaWhDNnBs?=
 =?utf-8?B?NDBYb2Z0UEpMYlVxSVBIYXE2TTh0S2Job3dXSS9Zc3ZCZGQxNnlJQm1Kb09M?=
 =?utf-8?B?azVjaE0xU2VMMjlEd2xiNjg4a1RFTFV1b2VKMGxGamhSNk5obkdlK3pBbHBM?=
 =?utf-8?B?Z1poVXhYSmRiS1hRNlYwUldEU2I3MWhNdEprZVZpbmNNNVFOUDFRL1BCZVlV?=
 =?utf-8?B?SGtjRGo0cGUvQTdOcTJZWDdYS0JXV2FvaXlFWU9IZmo4bTRWZ2NEbUlpWVg1?=
 =?utf-8?B?QW1HNXREWkxKak1YVWtSa2NRVElvUVZNamlJb3I2cjFVSmMxS1B5NjJPcGM4?=
 =?utf-8?B?K1ZteFlxNjRmUHJOMzM4TTE1OXVja3lBeWRKV3JSc3dzc2l2S240dXFzTXBY?=
 =?utf-8?B?L2FGQjgza2t1NjJEVUw5Ky9nS3p1Ry80MGNoRlpGTXVSVERXS0lYRXJSVWkv?=
 =?utf-8?B?NGVGTWNmSzBxZkEvSmR4WWlZQkwwZkJHcGNJS0JTSE9mMUJCOXRVRVFLWnFy?=
 =?utf-8?B?Y1lOWWlFN1RhQmJ4MnVOT2pFWGJEVU9vdFRMc1l5WXMyWUpIMXlOSlYwc2VB?=
 =?utf-8?B?emozOWpMSkhjamFJbC93aTFaT0x2c1lVdWt2R3RFZWFQOUxpNFI1ajFZZFll?=
 =?utf-8?B?Zko1WGVyOXdRZ3IwdWlSb3VWaCs4emt0R3FRd041K3J2MHlMMVN2QUlTeUhY?=
 =?utf-8?B?RkJTL1JUbHMxYkJVS2IwQ1h5c0lRNkpvN3BhSTIvdnE4NzFNNWg1STVlWHFw?=
 =?utf-8?B?Vmd0ZGcwSVhLSnloeXl2QlpPL3dDbXIxeEJiMVY5UWNTTXdxUm1FQTk5U2ZF?=
 =?utf-8?B?T3dkbExQMERMcjJoRWxXemJVcnlabElkOVhDWDBobGRSVEFwWlIzY1NlNzdZ?=
 =?utf-8?B?bzR1VENsZXJUS2tzdEsrRFBLY0xrSFpVZ2hzK3FONWxRRXJ6eWxmN093NFlt?=
 =?utf-8?B?RThkc3FqRU50R3pEQnQyRSs3elhWWks4bU9TN0FPc2xZVXVPZWZKV0NLaHRs?=
 =?utf-8?B?a1Z6NndOajhaSGZtbDBoUExMQVM5cGNWM3pGYlg0UmlWL0J3K0ZyalJjY2Fh?=
 =?utf-8?B?WFF5alBSNWNRbkR6d3lzbnI3K2kvbjNiQjZnaXpHUHVETXhvaDNjWE0vTzJN?=
 =?utf-8?B?S2lyNWQxMlJSMCt3bDNWTUFrYTdZNkRoZTNyV3hZSkx0b0I1eStFd1BFb21t?=
 =?utf-8?B?ZnZ4NjdyYk45Zm51eEIxaGlaQXJMbk85Mms0VnRTbE9SUS9Oa3FIZ2hlVDd0?=
 =?utf-8?B?eloxdVRtZm5LdzE0SUxHNHg3KzAxNXBNdEdBTERYRTRiNlgyZlVCUjBhYkR5?=
 =?utf-8?Q?c18DXa+6LgQQLzGFTPQ2eAk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6b5105-f066-43b4-e7e4-08daed4963e5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:29.2940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkyyZDQI45KEUGIM6a4aM8coKjxFMUYVv4NI9WUALKlSTv35objqY7hlf1iBDWXnqmU71LVZgPLUocPiGibbrQpbVkcIV1n7tYKf309ZFx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
the binding isn't necessary. Remove this unnecessary reference.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v6
  * No change

v4 -> v5
  * Add Rob reviewed tag

v3 -> v4
  * Add Florian Reviewed tag

v2 -> v3
  * Keep "unevaluatedProperties: false" under the switch ports node.

v1 -> v2
  * Add Reviewed-by

---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 20312f5d1944..08667bff74a5 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -165,7 +165,6 @@ patternProperties:
               for user ports.
 
         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:
-- 
2.25.1

