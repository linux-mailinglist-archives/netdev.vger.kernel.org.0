Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87272618F96
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiKDEwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKDEwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:52:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2097.outbound.protection.outlook.com [40.107.244.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC17A20F61;
        Thu,  3 Nov 2022 21:52:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNVZVIojc50tSmulbdOYWN59hYgZgE2F/qChjU/kDNGn3xWTQyYPXy7778ZMnJi4Q/FTGIS+Wa0/uCEklRgIGDbJ5gVvoqvk5RSZB1bO+0kTCnbo6ZlQXhmFtfocdALoVnyPnclyOJXjZzW/Fbuv3g3Mz0TrCcjmfGc79x6FUwqk0AoeT6tM97TjU64VEzJUjDrrNxPmauxZDwVfrlUU+0RK3uT3ldGd7Ono0CCtQ5Pc+wPO0/isN2uv7m93Siq6Rq/KpTr8v2d3fApkOk4ujw6zxDalfDVr6WHSVp4wNPWaynN42/ik5WXSBSEUM01t3EyQKBr98NpJPZj9h4J+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttdlU+h71Sp9QxZIFp0ETxQQa0uCrc40q7t97ziLozc=;
 b=mMr4/DmceP2ugHnfyftSani8n2FLVLM+w0zF3GGFtSmW8GCGwmwc3x++mZVfqh5+CKFwaYKfyJ4UutOaGPPm7An79hn642U2qBAIgiZav0cGKVGcMzaPUpzxC49v1+djX+HEvhzsXy8+ctYkYpdVlfP0hzADSf2V3msih6LcicN/aX7PIKH9zcD32EMco3KtqEnvfPMHPotWiCNXTyOO9/F612UD4p75t25NH4BAeWFntiDhyITXQ+8zjK5WCZz6EOT+dDeRxn1qsRasYFp/udc/BsuFQCBkdErAvHVT0nEOYVlsB2tuOpeHBmE+5jZCYVoBw/D3yB5JF/EtoPn7QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttdlU+h71Sp9QxZIFp0ETxQQa0uCrc40q7t97ziLozc=;
 b=KhCW2LcM/SA8wXczBhCnUKV+ALEZQadwCvewILzNlHXDrc2hEHGySKpMRx2YfRgW/9lV5krlX+PMV6DnEj9kFxio1Oto47Gc1YZK9YNjlvQISAZNTOkyxORpEF5DGHMBtQ1EyvAUPsDmOJ8CM+C8qgyc/yj/Tg1m95RpaTE4gpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB5986.namprd10.prod.outlook.com
 (2603:10b6:930:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.22; Fri, 4 Nov
 2022 04:52:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 04:52:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 net-next 3/6] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Thu,  3 Nov 2022 21:52:01 -0700
Message-Id: <20221104045204.746124-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104045204.746124-1-colin.foster@in-advantage.com>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY5PR10MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: d134823b-aa12-45f0-3cdb-08dabe205b2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cg+sUESexWMBH1in4Bwjsw62KfbJ1ZgZp+PdBLie2ak7KEjPXwJeTj7D2zigia8JjzMw65V+m8LB74kfXNRpTCw9MLn1bnkB2tT5sG+qgf93PwLwO29gCPwK0Bok6EFMxF2NwToEuQib3GLT5h1/WL8J6Iv4PhLGYcZGzIqdf0xQZervUxB5R54l+xUbgy6uVrPl2y2deARFSPMRmd/3qhZCaIuH4hfxRw8O2ANdfS7Dxn6bXq0NwtPVIckgclg363qoIzpZM2tEF4vuzN8P7/74yYDsOy96kBVm8OJiQDMG+AmBUyHnMtZS9i737J+ISYfocbmD0jvMTEtstdbBEWNLAKypkxJSQdNeynLtas1Ky7ze/AzlA9AqmgEpOybLKmIafi72l555vgdHfNahS7dC6VDcDgyTdRd9VtxxLIUVUwmGedik6TQ0qpv6ZeqibBVOIy2AbF3sPRlYhHWiJuvfTlfiydy0r3SvuOXl+JHW0fgz2mCQdH1Pja72DpmZgfqZ95Fjk/3WE26J6hjh49F+y0ika+4F1nbmp6wBh1km77rchBGbm2yDx1hPRpLTtP9bCihtbFGsCiwYQT/oEENY8lY9kRqANPB8ts6XzWQK2IYKTQxhPOM9zb0TwQKlgm36cr+hl9OAUfnQ5PuZJkaiSfVwoYaFaVN0mNJnlxB7+q/BzV6ecykYGBz41VBU2Lp9kAZ0hPKgJ78ifngBkn0tPY/sSCoT9BwTI0i867YR66fEzb32tlbbLAN1zBF6sugUgcPz+Wm8D+vKTqJ0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(86362001)(36756003)(316002)(38350700002)(38100700002)(6666004)(8676002)(2616005)(6506007)(66946007)(478600001)(54906003)(52116002)(66476007)(44832011)(6486002)(2906002)(5660300002)(7416002)(186003)(8936002)(4326008)(6512007)(83380400001)(1076003)(66556008)(26005)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjF3TENucER5WUUvU3krSUNVVk44c0VTSW9VT2JqUG82TnErWEVCdlIyUVJE?=
 =?utf-8?B?VEtXRjM0L204NE5meFpuUm0ycUtZakpYQ2twWlg4eS9vWURFV1dOODAxajlJ?=
 =?utf-8?B?Ukw0U3FvQUM3cVZ3MXpkRWpNTEVvUHl2cGNMSHZsczJITFNxTVpoNTFjZW5F?=
 =?utf-8?B?R2VZYjVscE1uNkFmb01la1BSREJGUVIzRmc3aDRJV1JxRUtFRTB0NDA0T2Rt?=
 =?utf-8?B?VHhjaU1wTXZDc1pjWFBOM1ZMM2w1eHFFbWRpcVd0ajM4Z3hTQnIzSzNKOGlT?=
 =?utf-8?B?bGZnNUN6Y2tqMlRtMzVxUHdSWWdyMlJOVTJjcnZ2bXIzUklyZEhxakhLbHZU?=
 =?utf-8?B?NjB4NzlwR2FkSkZRZ1hSa1d0K3NlV2cybzc2MWo5SmpNM09XWjU0VmNGcVJj?=
 =?utf-8?B?SGZCK3FSR0tsZ1ZBaktjSEhIbkZncEoyMTNGbWpCYUtWeFRtT0lFOUJwbTZZ?=
 =?utf-8?B?ZkZ3VCs0SXFndksrMnJwaEJNMWdNSzF2b0l0K0hkeUVlWHpkNitLRXdZSTY4?=
 =?utf-8?B?emRKZk5pNnJmVU95RkdQUU90dnJQbGdxcWh4NEZsZWdNbXZ2TVNJanZEbGZn?=
 =?utf-8?B?MEVrOC9iK1cxanFaaTV4OEwvM3VxUGsxZmRNWHk5eFlKMTV2a05LSUNLQlpX?=
 =?utf-8?B?RGZGQmpkY3NBOUxoVzU4VENkQVdWbkxIbFNFbEFhMnY5SURGcXBsRWUxWndt?=
 =?utf-8?B?cUlpTlF5ZForYzNoSTRYT2tIUk5ER2xtU1VGdEptVG9ZS3lwM1MvaGVlaWRY?=
 =?utf-8?B?TmNhdDhlVkZndVZON0J2d2FrRWtnZ1dJa3d5dkhuZWFiU1BaTzg5WktaV1F0?=
 =?utf-8?B?K05oaXI1bHlEa1Y0RFBRVzIrZWNLeGU0SG0wUDQ5K1d2eHZyZ1hueUFnZWVr?=
 =?utf-8?B?UDhab25LaGllZ0xPUGw3UXRtZlVnZ01jYVUxejdLWEVjekVXUUhzSlZKV1N6?=
 =?utf-8?B?cDBVMEIxWVRZaVhSMTFESXR5NTZZcVMzVXBoMmx4eEpObDk4WWxOdmRiNmNK?=
 =?utf-8?B?TkdCQm9JWGNlVXN3clBDcWE2ZkI2bUorQk0yaXZoTDNzTGJCbDZWaDEwY0dk?=
 =?utf-8?B?MFYrdFh0WUdMcU03bkJQRkVzdjBiRUsrOE52dkxRRUswd000M0M3OS9Wd25i?=
 =?utf-8?B?c0wvYjZWWjZVNzJFWS9ZVjVYQlMzSnMrRDZCNjlRcmF3YWR2K0tycnpYVitK?=
 =?utf-8?B?dmlKbDk4LzU5OWlKRHNHaEZKNDUrdmI2cUc1TC9aK2RZRWw0QVloWCtJQ2l4?=
 =?utf-8?B?QmlKL0RqSnNVNDR0NHhxYTVrQWJqOS8xQUd2eE8xQmNRUUVLMDJobTZLRjRV?=
 =?utf-8?B?UHNWTk84MUVRWU5STkhVWlRSd2tzeElnQldnY3FDYmc0dVFKS2hwOE5LUzdx?=
 =?utf-8?B?QTdYRnAxVXd5bEVpV2VxRno5emQ3ZGZVSzhZQk55N09yZHJaMzNnVG16eitZ?=
 =?utf-8?B?UkpUYmdzbWc2VDYzMnYycHJMd3ZEb0ZrSFVwTkpLRTludjVXU2d2T1VQdmVs?=
 =?utf-8?B?MUJBMlZCM3k2ODNnRUpyQytGK3E4RVRxd2FLSFY5MFB5NjFrTHp5ZUpqVGp0?=
 =?utf-8?B?U2JIYzVzdkV0d3JKSHFHYjZLNWhXMUVXU2pnQ2Jia0VIU00rU2tUUG5uRmVW?=
 =?utf-8?B?VEhiaHJBTGdnWWxhY2lWRXFYU0dLRmRVZHV0MVRnaTVrRHhLb0poLzhmVHlB?=
 =?utf-8?B?cmMzTDBlYXh6MFBHTytIRlRmNnJpMFBpU1FJYnN4RlUrNWlSMDA1Z0RsdWdC?=
 =?utf-8?B?dWh1eDNmaUlURHpGeTlpZW5IVzJ2Y0tXT05pRVZMcG9uQmdkNHFGc01NUkhv?=
 =?utf-8?B?UXhyNkdWSE9laS9VU2E3bkY5YlRuNnpCdytxK0lwRWRyM2tYbTJPNXBYVDVJ?=
 =?utf-8?B?T3YyNVRDRVkrbGZHVWR4andKVE0xRlM3UGdJWk5pNldIV051WVk2RkhZUkhm?=
 =?utf-8?B?b2hibGFIMW9JRkVla0VEYkg3c0MvS0Rwei95eTB0bUg2bXA0OTRLeElFK2Fi?=
 =?utf-8?B?ejVVSXdLUW5jN3RyRTU1QTZ5aEtWQkxYOElVSUhKWEIxR043UW1FUGZqQ2Zq?=
 =?utf-8?B?ZFVqQ0hneGR6Z3NTc2kvblIvOEQyd2JscXFMbzFYK2RjMUhPYkpGTW43cSs4?=
 =?utf-8?B?L1JIRXJUNW1VTkNHeklHS1doVFlQY1lpbEt1NmxCaEZiNElhVS83U0VLb09R?=
 =?utf-8?Q?BLHHEnm4qNJkciPR05401Zw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d134823b-aa12-45f0-3cdb-08dabe205b2a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 04:52:20.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4XWFp3/guY3Fok9gH+Mm4OII6ME/BBe39MGVlsjHH+UEqz530q4OyB0/Z4pg65BLuAGK3qCjtsWeJy/mDu6hdCzB/M0qEsFHxb9rlDyGa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
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
---

v1 -> v2
  * Add Reviewed-by

---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f2e9ff3f580b..81f291105660 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -159,8 +159,6 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        unevaluatedProperties: false
-
         properties:
           reg:
             description:
@@ -168,7 +166,6 @@ patternProperties:
               for user ports.
 
         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:
-- 
2.25.1

