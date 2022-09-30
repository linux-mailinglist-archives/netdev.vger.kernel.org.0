Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29955F1353
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiI3ULm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiI3ULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:11:00 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2054.outbound.protection.outlook.com [40.107.104.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398EC156F91;
        Fri, 30 Sep 2022 13:10:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsEl3tfE0X3XsxdewoIb3sDBPcwqiRJKVPC9LV+flqOVYc497KYrqzDGMFtyoiFKinAlWp09pxILlLwWmieLVxJv4YPkYXJL9WqioeybD4OZtQHDTUGpzxIoxjhfu5TD8ibz5nU3++Bk1UsBCplZhBRV6uRJwmH2ME3rSjx1z2qE69OgyJgTv+kSYlBirmFk8EU7/RBu0JfapBx+tV2IJljXqyEItcFCReMpkalTxZLtsyGIQ8EK6TUNArhqt+Psr2ImK9vvK1qVW/hktBkDNs5LSlmAlNbj0rgnWqPgkQ39yzmRd2fE/jvBvtgpCXRGMLHVxfO7tHX/xBQgmBNLtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LpBZZ/E0MzZ0ssr0uah78Z2jasHTDuQGEPDYfnFsYI=;
 b=XXEfDKLOGsbPl4a9eHk4VwZgpQmhag1pSpBs9Gq/4VtaAXo9VTv0c3A8zimusjJlccsxNBg0nP3RAMDN+9pKorUk/uCikzwviVB/XzEC1kBadb3mz/W8JV9srqOKSywkhpb/ozGUyhN54+7JHucTantvBWYCnmPIOhs6l/B1P0MRUjIJMJJvQ2FpI9ZqZOVd88tZRcIqa3Ksa2ltVENxPPCmSiAcSqjz5JdZxTqvZj1QEQZdb+4LTzgqHOT4XpPzPZJi2tpimOlSzM9wXa3QyXjleDIyJK8XsNlG6YyWtM5a47l50wzaxOeJNJX8RpdyfJn+p2PrwbOAv72zulVjaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LpBZZ/E0MzZ0ssr0uah78Z2jasHTDuQGEPDYfnFsYI=;
 b=E93AcAMMjl//kWLkxXKK02Vl4OvtnQqx9cUCEEOAVa/wmmaWHft4owGOtNWLRGBopncH8CtlaRtOQVlX0ACWUKs0OS4+46Azx9PTvgidPlqYnkof65ptEWiv5IxXKFd4gIlZ3Dma09AmylsEQsiC8IQD6SWkQiG9XRWDLz76NII5QPESPYm3We/BPz886yvNxxyDzGcBk2yT/+/6yDJ87TW5rRdAwJOq/BFU9zGZhdJnqenb/8OtkX/KBgAI3HC7sXYIavCf3DZ2POupKkehnUZe1HDzWGevlpMM4MAf960Lia/8JN8U44kNlN9s3BQGgiL7fY3MnLdq4EBamEJDKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:10:00 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:10:00 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v6 8/9] powerpc: dts: qoriq: Add nodes for QSGMII PCSs
Date:   Fri, 30 Sep 2022 16:09:32 -0400
Message-Id: <20220930200933.4111249-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: aa372049-6ef4-4933-b905-08daa31fc121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzadVuOKl0sJJGfeuobrUi3SjghAzMFguY3P7nWM+dse9mfXhs8mfI4HCKjTRhdAtEOu+dRYXA9FdsXep6j3TKG1QV9VLoooa57K/7hYRHXH1PqvxQEoJdM6dzG+GSJ+j8MAJKkhD1CuOABhZMQDoV/dgZhCkUUMlGW0zQen1FtEJWCH6qK4w2CyPbGFsf/dHaxWxCXHendnx0jQeqJbOh3T2+0eFVbpfIevzAkPylMJkcgwwfHAx6GIKCWYmawyK0ofBgjcqxKog9qZw09Kbvb28OVyMPgu2hrYicbYB6lJ6ve5TXieJJSabc4+ryoMtT3VMsQdMoZHmupdMnzMd4euWbwtksoI5I/UGCij/9XGOpTVeKR8reQtA0hlNHXMcGUI+KwyHBVUewnjsbW9S1Ofj5UqeE+n8hv2+yg0oTZw29DaitFrYPTp1IIq0d7TBn62k/CIlrkT88q2PdFU6FXCO+lqYXoEKm6V8mEwGh/UHwvW/ziETtLuhbelC/tHmJM04egbbMOYwLXhQ57moLONBDm2EsyDpPDmlFXwpMs1arxStApzzY2QoIhFZCGrF1BftFC+mCOHNa6QSes+AS+smkAYdck6Fnqyo6WYl4/c2Tx/+Wnbv3LNZPw/6CtWmmeZfClS4CLeQ4HfR1/1S4kYlxHIRhbDm3CP4bpj9SohndUC6rUqtJk986MZWqf2+ufWwvW0X5dcMoHqDQUVTbZioxJtpzotY1wRheW8+5UkjUtwX+6TRFV73SV8ZkGGXdeUl8ndhHF5m1G9ni8aeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+An1k7CutCtPnIrRDnHSJHau0B4ZErEE5QyP3lDpcvCuX6uZRkxpCjbBFAFt?=
 =?us-ascii?Q?6cNWBFvPxJfnVzHkMj/d8C9gY9VaudNVdwaxajddcpO/HHcOxaJjsWXFMSbg?=
 =?us-ascii?Q?H04bSNjcH2JlJa5adeHWgar7AlXdb3sgmQwajL8F5FV1jwX77HzY5GoYUK0U?=
 =?us-ascii?Q?XMzEeyefj1LwRMLTmcQ6o+RremkfhjPLuLVzVjHmx8SXWW8KZbOiuxU+FjTu?=
 =?us-ascii?Q?B+oB0ZSSlLXYytsaIksU0doi+Qs27SpW1VryAmThURQJu23maq2RTSoGpkPj?=
 =?us-ascii?Q?g0qwX9FCvg4V84eB0goKpW4QF6Jel/WTXDkvrXQfBallVnbXLcn9G0IDunGo?=
 =?us-ascii?Q?pPHHK8lTqNgBayVc9sTFIe6pMh2b28KArdvxIqnwld3SaaDJ0MvSV5h7DZF2?=
 =?us-ascii?Q?TuO0bdo7SDXgFv9ymXvDYc7jvQJp2npuaek8Dieq5pNltrUTtSCETc7TJKOT?=
 =?us-ascii?Q?BYdlN4AKr2P0guaRx9dkhgCWvbiMfFIkOTbmb88pywcuzCGGHhdB0xGPVhJT?=
 =?us-ascii?Q?3TY0Y4HKbdo8Abgd3eSHKJ14eVtGtZ8mtTF8gv+Tws49T41F3OcWFVua6+aU?=
 =?us-ascii?Q?O9TrD56Hg2ewrsSi92AdqM94N29ygANqw7ZN/XpLcLd1MsQoB2uh+d6h1jOi?=
 =?us-ascii?Q?ol3Z0loBh7bTcRcM8EkMn4MDA0Z8sp+Vsi6sglVdbNVinLUtvUGpt0DRVB7o?=
 =?us-ascii?Q?rnmOTXED/CRij1SYoDqMUFWH+4kHfphFxYeUMf9TVsq45umEtLQwcYB2mcaS?=
 =?us-ascii?Q?CbEmaCb32q4DDWyJU2mzrq1e/jMHobC+wveNXotHOrliLz+RWN6hAr+2sbdJ?=
 =?us-ascii?Q?U7r+qui1MhSqyV/bkcytTVnY50PNvUikoLc/FzSKB+wNBJUXin1l4mlaeuB0?=
 =?us-ascii?Q?pazbLGo54HklTzORbgHvZXKK6/E8mLa8xHTLD/MIec8y9ljZSu5SdyBIYNKT?=
 =?us-ascii?Q?UUOsPGClYb0ZO0CZsdwwbWFfBMpIX30HueYJqLBCXkzQwPpl9nIqclPpLmkk?=
 =?us-ascii?Q?Vz1YVdywQ0mw4FR8+OOeusSKAhoZgLHkwUG84yLL6mJtBUO2GOXComlxSTfc?=
 =?us-ascii?Q?kpvObzVPlQHN0vBMRHy1FftPTsuc35CEqjaJtN/h1WUkLgXpa4Jh8IFIsgtv?=
 =?us-ascii?Q?dSgV/SJt/INmkVy7a5/UndowS0XLTVO4UsQjh4YfwcRmO/fOhPhbnrkF7W3x?=
 =?us-ascii?Q?aPLNHWESlrQjCzg5a359awtCVTxrIieCis83slb1XqzgwjVkrK/eSyImK3YI?=
 =?us-ascii?Q?wFq15fOa/OYruup1RvNnP8NAGGu+yJWPqbjhDO9LQp7l1kHxStKUGtXlJlIL?=
 =?us-ascii?Q?tzXsI0MNAnvJ5xNb7kcoFKuyIXGJDmNWb6RJpSElBphuyXBo1oI3fDiseMqN?=
 =?us-ascii?Q?OVlx2qGnmj7E9Fed0lglpiuLIw6WodRQKBKisAIqazkoHWCRhoAT2R7Z+SYf?=
 =?us-ascii?Q?SQEvb937TPgAqBQwy66kQp+QXwtoAC2Ypi0GbqgOyEVUieF/9yN7RiWkmADb?=
 =?us-ascii?Q?j5WTAkmXuaRnQTCRvFNfrGMLRkq07B4ZNGwT+YCcb4hbsrvAd5rkNEsJMi38?=
 =?us-ascii?Q?sjCI9VBoo4V9iSpXNqxdzqNEnv36nKsMfBF/W8fAhHFuqEPzjaQTm8cuAV3S?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa372049-6ef4-4933-b905-08daa31fc121
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:10:00.6810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qc+nR+WA2pBTl4cBzsxL/pZQM+PBLF2BbJu+hsKhjHys+vwk7gsLtfVsgfRN/EMT4ixlMfjRf9v9cuQHOmMplQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we actually read registers from QSGMII PCSs, it's important
that we have the correct address (instead of hoping that we're the MAC
with all the QSGMII PCSs on its bus). This adds nodes for the QSGMII
PCSs. They have the same addresses on all SoCs (e.g. if QSGMIIA is
present it's used for MACs 1 through 4).

Since the first QSGMII PCSs share an address with the SGMII and XFI
PCSs, we only add new nodes for PCSs 2-4. This avoids address conflicts
on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v4)

Changes in v4:
- Add XFI PCS for t208x MAC1/MAC2

Changes in v3:
- Add compatibles for QSGMII PCSs
- Split arm and powerpcs dts updates

Changes in v2:
- New

 .../boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     | 10 +++++++++-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      | 10 +++++++++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |  3 ++-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      | 10 +++++++++-
 20 files changed, 131 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index baa0c503e741..7e70977f282a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -55,7 +55,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index 93095600e808..5f89f7c1761f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -52,7 +52,15 @@ ethernet@f0000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x10 &fman0_tx_0x30>;
-		pcsphy-handle = <&pcsphy6>;
+		pcsphy-handle = <&pcsphy6>, <&qsgmiib_pcs2>, <&pcsphy6>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index ff4bd38f0645..71eb75e82c2e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -55,7 +55,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 1fa38ed6f59e..fb7032ddb7fc 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -52,7 +52,15 @@ ethernet@f2000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x11 &fman0_tx_0x31>;
-		pcsphy-handle = <&pcsphy7>;
+		pcsphy-handle = <&pcsphy7>, <&qsgmiib_pcs3>, <&pcsphy7>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@f3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
index 437dab3fc017..6b3609574b0f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -27,7 +27,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-handle-names = "sgmii", "xfi";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
index ad116b17850a..28ed1a85a436 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -27,7 +27,8 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&pcsphy1>;
+		pcs-handle-names = "sgmii", "xfi";
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index a8cc9780c0c4..1089d6861bfb 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -51,7 +51,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy0>;
+		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index 8b8bd70c9382..a95bbb4fc827 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -51,7 +51,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy1>;
+		pcsphy-handle = <&pcsphy1>, <&qsgmiia_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index 619c880b54d8..7d5af0147a25 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -51,7 +51,15 @@ ethernet@e4000 {
 		reg = <0xe4000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0a &fman0_tx_0x2a>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy2>;
+		pcsphy-handle = <&pcsphy2>, <&qsgmiia_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index d7ebb73a400d..61e5466ec854 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -51,7 +51,15 @@ ethernet@e6000 {
 		reg = <0xe6000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0b &fman0_tx_0x2b>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy3>;
+		pcsphy-handle = <&pcsphy3>, <&qsgmiia_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiia_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@e7000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index b151d696a069..3ba0cdafc069 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -51,7 +51,8 @@ ethernet@e8000 {
 		reg = <0xe8000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy4>;
+		pcsphy-handle = <&pcsphy4>, <&pcsphy4>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e9000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index adc0ae0013a3..51748de0a289 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -51,7 +51,15 @@ ethernet@ea000 {
 		reg = <0xea000 0x1000>;
 		fsl,fman-ports = <&fman0_rx_0x0d &fman0_tx_0x2d>;
 		ptp-timer = <&ptp_timer0>;
-		pcsphy-handle = <&pcsphy5>;
+		pcsphy-handle = <&pcsphy5>, <&qsgmiib_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e9000 {
+		qsgmiib_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 435047e0e250..ee4f5170f632 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -52,7 +52,15 @@ ethernet@f0000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf0000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x10 &fman1_tx_0x30>;
-		pcsphy-handle = <&pcsphy14>;
+		pcsphy-handle = <&pcsphy14>, <&qsgmiid_pcs2>, <&pcsphy14>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@f1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index c098657cca0a..83d2e0ce8f7b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -52,7 +52,15 @@ ethernet@f2000 {
 		compatible = "fsl,fman-memac";
 		reg = <0xf2000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x11 &fman1_tx_0x31>;
-		pcsphy-handle = <&pcsphy15>;
+		pcsphy-handle = <&pcsphy15>, <&qsgmiid_pcs3>, <&pcsphy15>;
+		pcs-handle-names = "sgmii", "qsgmii", "xfi";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@f3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 9d06824815f3..3132fc73f133 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -51,7 +51,8 @@ ethernet@e0000 {
 		reg = <0xe0000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x08 &fman1_tx_0x28>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy8>;
+		pcsphy-handle = <&pcsphy8>, <&pcsphy8>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e1000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 70e947730c4b..75e904d96602 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -51,7 +51,15 @@ ethernet@e2000 {
 		reg = <0xe2000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x09 &fman1_tx_0x29>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy9>;
+		pcsphy-handle = <&pcsphy9>, <&qsgmiic_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@e3000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index ad96e6529595..69f2cc7b8f19 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -51,7 +51,15 @@ ethernet@e4000 {
 		reg = <0xe4000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0a &fman1_tx_0x2a>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy10>;
+		pcsphy-handle = <&pcsphy10>, <&qsgmiic_pcs2>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs2: ethernet-pcs@2 {
+			compatible = "fsl,lynx-pcs";
+			reg = <2>;
+		};
 	};
 
 	mdio@e5000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index 034bc4b71f7a..b3aaf01d7da0 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -51,7 +51,15 @@ ethernet@e6000 {
 		reg = <0xe6000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0b &fman1_tx_0x2b>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy11>;
+		pcsphy-handle = <&pcsphy11>, <&qsgmiic_pcs3>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e1000 {
+		qsgmiic_pcs3: ethernet-pcs@3 {
+			compatible = "fsl,lynx-pcs";
+			reg = <3>;
+		};
 	};
 
 	mdio@e7000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 93ca23d82b39..18e020432807 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -51,7 +51,8 @@ ethernet@e8000 {
 		reg = <0xe8000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0c &fman1_tx_0x2c>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy12>;
+		pcsphy-handle = <&pcsphy12>, <&pcsphy12>;
+		pcs-handle-names = "sgmii", "qsgmii";
 	};
 
 	mdio@e9000 {
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 23b3117a2fd2..55f329d13f19 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -51,7 +51,15 @@ ethernet@ea000 {
 		reg = <0xea000 0x1000>;
 		fsl,fman-ports = <&fman1_rx_0x0d &fman1_tx_0x2d>;
 		ptp-timer = <&ptp_timer1>;
-		pcsphy-handle = <&pcsphy13>;
+		pcsphy-handle = <&pcsphy13>, <&qsgmiid_pcs1>;
+		pcs-handle-names = "sgmii", "qsgmii";
+	};
+
+	mdio@e9000 {
+		qsgmiid_pcs1: ethernet-pcs@1 {
+			compatible = "fsl,lynx-pcs";
+			reg = <1>;
+		};
 	};
 
 	mdio@eb000 {
-- 
2.35.1.1320.gc452695387.dirty

