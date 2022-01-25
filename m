Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E6D49B9E1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380758AbiAYRO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:14:29 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:11227 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381226AbiAYRMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:12:23 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PCjBKd007915;
        Tue, 25 Jan 2022 12:12:09 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0y77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:12:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqfDzIAnzlXChD2SYB4+NuTAjbEIeWgAyrUJZZK8EXmsoO6mxKZ1UW+WputTxoV/WZDprrl7H9Rjc8qDAc9Z+Nr3Mpk8/CCv5nCTWwQPBB9eskKhamGqMXJSx4I5wRRdOROeJyUo5knbr/fs6guKP8ai5AmRHxb3UjF1GETbLIDJ3x6NW8pMCvPKf2K4+wGJSZ4woubiRM1BbxKtM5ZZaA4Ng9zeq24uDU8DEC9uzQHYuZ/fikTQYdvPrycRCyUu2w4dqvBUZ7gP7Jh+9Anr7pk3sr+PFnMlGuPM9Wlbtg6og5n2N7XopNy8JjkrlGt1x5nYNVeb1ROz3lsWApdsOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBBv6L7nuTh14DdrAsfoyaTAfWQIBln4jQF8cfrYMt0=;
 b=LU795ivOczVPqBJPN/sqBK8FzAHrMUIYl7biHh8Ajk4qGAMhlfLvVMR8o6o91VL24/wK45XFP9ElXwZYUmnfcgx2lJPIlLjpvZ3viL88cyyYfm3VPyrX/R4PzLGxRbuKH49xtU3XiZNLO1pbblMp5c+2UzJbBYxc+68DZT+yUnl7hv1Laaz2+JJElB44XoWhxvXwyaRiik9Gh7Kj0wWLC8EjpJNQMo0X6HuJ8AC8PTatSiswRdicqxWwO8agTom40jk+ogJrt6Iwxic76hE77ESu/9AO+SrE8d8uhowe5GagjHTkMonPJ74Do/lDfIRThRVTdP5UcXd7zMXtUyS8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBBv6L7nuTh14DdrAsfoyaTAfWQIBln4jQF8cfrYMt0=;
 b=eEzxGGUPJT0gjP/TYTwIEYzuno1IEejV9nmnPGZeQEfErxMH5GYdf03V4a4DvhIKcRTeB6Sxg+K2UP4mbY4AMrllCcC5rtuzgrtMsZLY4WK7pjQ1lR4STP9sCCo4tVMBZzeHtDSmWt3FKabE1oz3u8189i5QZ7ZCAaQwaagxAf0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB4382.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:30::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 25 Jan
 2022 17:12:07 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:12:07 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 1/2] net: dsa: microchip: Document property to disable reference clock
Date:   Tue, 25 Jan 2022 11:11:39 -0600
Message-Id: <20220125171140.258190-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125171140.258190-1-robert.hancock@calian.com>
References: <20220125171140.258190-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0020.namprd12.prod.outlook.com
 (2603:10b6:301:4a::30) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4a7bce1-1bc2-405e-93c6-08d9e025d0c7
X-MS-TrafficTypeDiagnostic: YT2PR01MB4382:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB4382C423AB9DD768377D5423EC5F9@YT2PR01MB4382.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /wPnRPyl71yRsOIR1kEmN990z3WadXEN/utvPvlperQ8xdc9b15Y4qwfPOIJUCAIA5QkuvLJyE1q+Ya8MlLloAvgO36761LzqKFrkeIJXhMZb9Y4sYP9RotpSz5lRAeBCMl3A8M51PoQnfvei7zGgC4RGBWgQuYGm4jyYG0/RznwTOE7MJAdeMaubz7tqbvl0718Wnrh62hZqBskfyX0EwAPLnM2/hnATQvNui8pXBDnKSZftnFaJh/fX6vVYNjTIy++dYduvRA6Q1BFn3smU63TeOMowSWtz5Hu3VtgSbDFLNwgHsanL9OUbN4daasSG3Kufb42bMLb7brpG5exmKo0vN8Rar4lzWx2rSUByCMvAoJ47TG5idipS+I5JwE8Ye629+1SiqwZ0XNro4t6xvbdvYGAIf+rwqKphWPgVxXlaWy/SHi5QJPyuJN7djxhPoqreGiwmG55Gu1oLc2x6kinC/xVHByXsK17jjksEkjd23gaaUrq4MuP8DtH7ab9oAsltja7qcStq+s34djiCdlRs4OtLCFXPIuvxfqV39a9sSC5ItZD1XxpGG//uBZMd+F/xOxJ5OdV80IZPaRbCVFUj55DgSKNTfTgJRRud0gqf0ZzWg2RhKueHqKNupHik7aLkOSWKoSkohlqkiakS8VCecnZt0FeKob1vS/1irNBor+9P+GHqS3x3TG0jqhJpB1xnalcbOUc09u32/0bkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6506007)(66946007)(66556008)(2906002)(44832011)(7416002)(36756003)(66476007)(86362001)(52116002)(6486002)(26005)(54906003)(83380400001)(38350700002)(38100700002)(8676002)(8936002)(6512007)(2616005)(6666004)(316002)(186003)(1076003)(4744005)(6916009)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?90daSVw8pOxaeHVmPtN5iGMXoFA5AmgXN6MchCowU6XTs87BLR6hoqt2XRoi?=
 =?us-ascii?Q?0Jj/UJeOQeCskhHc2hTgdoZ7BwgojzSFEmr1SCoI8RCnap6sUuJob6cCGBIB?=
 =?us-ascii?Q?iN0AwWJEsM8CXfxcjTP2JiMWYAxoFwXQ/ulp9dVaVi+80vNARC/RWNMjVnts?=
 =?us-ascii?Q?9eUgvqmmTS+JWVWBi6cx5KpQQz+DTWq2CngTouPp93yE4zZJeni4un1Rjb+x?=
 =?us-ascii?Q?o4JKOpFdtY5QjSYlqDDQdeiNW9KaXSiSKn18vU/Edn6IGdYOeShata02zWKc?=
 =?us-ascii?Q?7J+IVjMHKv0CIUbfttpSse1AzNSOCvXsveZlATe815INNHbucciwWVSpiPk8?=
 =?us-ascii?Q?Iep0q64o+QBU7y/luK5Jc2wQf9wjvRymci3hzS1RKpCAU0/iam1Pqv5CkC4J?=
 =?us-ascii?Q?yTh4MgSAaLz4Zsqb0YjsWKy4iiqq/sE9+jRnbGxyJ5AqHWaTQ7/BU/cAMmnZ?=
 =?us-ascii?Q?AkAfvOW59/CTK+qvNSLncgBMe6uOFMiYnc9Odx8Yoj1K/DUh8yGr6TaWotJ0?=
 =?us-ascii?Q?r569Q8O0vaO5R+/AmnxhCyxUY4K5c4NMEcdJzslkIIQIYWlC/TOx/MHQZv7e?=
 =?us-ascii?Q?VUTzQwUM4ahkR8d+PAR4qR7YMkKm4vHIQLqXxwnY0BhlvzW66aQVOzfI8f33?=
 =?us-ascii?Q?DGOnGB04/CrPXhFzylHfRPxazZlu+2AfhvRVPytTU3izQp/MiqS0Odpoxg48?=
 =?us-ascii?Q?rdNyXtO0LckBvoS1pAMzQT7yaFbqTOI47CddN9OEs/PRtmYyodyY20tb4rg3?=
 =?us-ascii?Q?v2NYlnFbhZUB4f5NaHo7SHC7iwq3WuTy2EBNL57ZtM057UBvN97is18pN45k?=
 =?us-ascii?Q?wqqj+B1/Wp2hzYYNwW8WrKUT0S2bkujqWEvEJ7w5f+wsUA1JKOBnpd7hRqcL?=
 =?us-ascii?Q?+3rl07zolUiCpj8AD45z3uPM81CchUa4iDkJZyGpLwnUW2V3IsJMzu/i4A+w?=
 =?us-ascii?Q?STZc6q08HZnRCDdbwjwIKQkY1Gg51CnX8g3k3FmTovOAJUSWMtJ5lTg3imF3?=
 =?us-ascii?Q?UDhbdMKunOCkVeYNr79chZghaQ+H9CKDvwrhfFhp3cfDQiUAS+2bW5jRKNkg?=
 =?us-ascii?Q?HkVvKUavgBTHQtu+vtvyTGbYKRESQBFO/zSAF1uX2e2Pl9WW1bh8FEvJ9xtO?=
 =?us-ascii?Q?HupKgotoJLReiWBU1mbZlBZF46rTpNzsi5LJymJaylIQiTfJfWXgQVbGlNy4?=
 =?us-ascii?Q?rzyUiLC6CCwuHb2xAWYfoaIP4hgNIt9R9gikkg+EuIl/y75Q/DNo/oMFmilC?=
 =?us-ascii?Q?+P1cW5Z5E1kZvg8b8rkbu5DBnMIFrWvE1ZCbvi73W4EZ9mZAqxU4rb/Hfbwg?=
 =?us-ascii?Q?haojgkrhnLVafwSHGQSOfX/K8mBPTtTktWGU8qiqr5TeUIVXUNKttkqjwWS0?=
 =?us-ascii?Q?4l53NHpI8RI4tDFol91Djxr1TUYyMWyMSlj9OJNUtUx4HiwnXon72ngtx8o7?=
 =?us-ascii?Q?Ya0+IjXVaOdQLhS4rD1mdzW49/Q+LdWNBNkAEyNsWWek3EHGtBCj6hJcFEip?=
 =?us-ascii?Q?2Sq3tQ+/qlr84kGFYp66TSyj10OxIbZ3OVnMdx7F4G2/FuHZR4lo2onr5Igp?=
 =?us-ascii?Q?QaTvQB29giHanuMxcv3bzJ5ZkOK3wnvRREwCUVz6PS5smPCib5RhcKcKYs7I?=
 =?us-ascii?Q?ql+JUK6gfOlMHX+DCEtmetODC4XdZ/LMqW9dtw26notp+J6IWtjdCtl8GH0V?=
 =?us-ascii?Q?ox0/QWr5DW2rUJP3yX4iehww3eQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a7bce1-1bc2-405e-93c6-08d9e025d0c7
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:12:07.2662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dpk6NKsRXjshHsPkAmeeuPhJ3t13u7t/S/v3KyvsUwKH97wcFeRmxWdV5tI9R+aJCmjT1yWaS6YKxA4WY1uo2hJkRopNU6/29YSofWHJuTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4382
X-Proofpoint-ORIG-GUID: wnucEwB01q5dbbEUtO0f2dGoX_MM7Eyl
X-Proofpoint-GUID: wnucEwB01q5dbbEUtO0f2dGoX_MM7Eyl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the new microchip,synclko-disable property which can be
specified to disable the reference clock output from the device if not
required by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 84985f53bffd..7cc22ab1787c 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -42,6 +42,11 @@ properties:
     description:
       Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
 
+  microchip,synclko-disable:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set if the output SYNCLKO clock should be disabled.
+
 required:
   - compatible
   - reg
-- 
2.31.1

