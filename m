Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15B45886F8
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiHCFtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiHCFsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:48:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C8D5724F;
        Tue,  2 Aug 2022 22:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9O0c2yl95bqZvBmukK5mcLuoYfqwSwtKOlCWAd+S3/3YMFBZy1cv/i+zhEBiriycr8PoczOS2Q5ToE0iszgpNUc0SBOMJS+NV8mvZH/N5qLg1YLH1e9oDdhAMtYRZQVerGwOVqiS1D211t9UEA/hjlgT8JZIN7MAvLAhqWyNjNmK2AJ59WfH4XEyTKmOx9ZHfZ8ia9gFX3L/aidtylAt8GceWjN3ObQl8kOXquirD8zkOQCF111QvXvrGVJsekpP0hBY8PTKZlgdnltv9lohJDOjhTsTzTpp+n6LcLxMBX0b8dt0ighsuDm4nEQF21FweWIjlYn1hfjN/IaNA7plQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohBdtxbTL6dXyAEpXkG3QBDJR8+3WUaB9PRVzHWrSE8=;
 b=JMHD8Ty3hDgbYfSLS97vCXT0x2vGUj39jIX1TD9AYVrTAQ4Lmfsb9FFs8aYQ2vYUHnunrKZfs62dUMExqxCRk2O215hmW8f7t/l98GBrp4Rx6dTPcPLj/x7kriVvGJhxyPKDZLx3TUoxEh3dlzKWsHk6tXHrQylRTQNrJVlGnvwY8dc37kjCWn7yP9l+BxgPbfaTuiQaKLeuGtoUHUY1XRAqRo53yLhUreIpOtkvUDJeZk4kV4kUYzRMNyeGA6i6w/arf1zhxcp7Pb6iZRf+PoWirnq/9/g0VAB4OCFkgQR2MchjE9HCeVrv6m4tMrpb8/j24PHAsze5pEuFRdo8KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohBdtxbTL6dXyAEpXkG3QBDJR8+3WUaB9PRVzHWrSE8=;
 b=Wau+diz0s8eo8yQE3PKMq/r+qmuhSgnjzzF1FbpJfDN2Y6mGc/3qe/yYbuwVuATRsEQfp8mZy7m3YH0EyzUbiwfhpVyK+KhxPUAqEChPqH4DUuwnzBa3sepZKg8B4WcpsWnkPlORCpFPZdttqlRswV71hs1DKFtbIsRmwbs2j3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:54 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v15 mfd 7/9] resource: add define macro for register address resources
Date:   Tue,  2 Aug 2022 22:47:26 -0700
Message-Id: <20220803054728.1541104-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44d0e4b0-8c25-46dc-2b8c-08da7513b5c2
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFC6G8B5/aci72ovxGLp5VKqO8OzGbgFWDRTuDMooLOwHssGIMrnLdIynhV2GPfqqLQmYa+4Bww9NtT1ui/ipKJq67Y8XqFUBp5XKsc7cBjNASowF++GrH41TXPQBP/FzRs5vyiD7TRNWj1p5NxpKOE6ezulXYoTZiDvOmUyvDcywALNETveZYwqjwAsu7yiRJnr3OXsYyZ6pXcQANvYV8CPp3/DvfuK01AOZ2Au5T7WPOnAUaQ+KCY17e8bCBqnuiIzyrSAJd4qNkL9NVXnL2TjqmiqU81fmxgE2HKyB7nYu+11IrJcjm0q8F7IrNO6PGWNycXS8hZSwcirEO3/ApFE6ENUWeuo3IiXSn+LI6vFw5S5lJKnnYlS3WtVqV9U+xTl95SE0YjoxyCQbOVcZBelkeyHswFLzkmDZxe47DXfFjJKOnJJNxIqIAuOwlWXxVJf/nb3YHdPU5TBpcHEdfwbpfWS0PMCBKXCEQgBAZ/RmHfumim7609yyYUJ7b5myrGtnitIOTaYxhaNcecBm/gvFh4941T4xt24Ytu7e+MIJ7w8DR7o/q6zTp/CVqKV+INEF+ybjX+j3n/i6YxJoWmQcugGg7rh8PXDQqhoJiksQr28qljyBG+z3MIEZSBobYl9dB1wYWogz8ddgSF+KXU7AIqHttr8pJ/YXKnWrIhoKFbuYTOzAA/B1fxoTw/6x4FURQdtkD0KQ79xwI8pdm+qjuOxX11Tt4hKIlnwDn8JhtIfaiqoLCesR7KPFZ+wd95MEDQ/ZkqC1n0gJd9/0ir1FmJnYZ1ot9jM1mqQ4YQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N8pkLkCW/AFk1LMbDa20ZImN70XyGUWiK+CKWNC08Gy3uP/EAhDIlPm1GqXO?=
 =?us-ascii?Q?sLrrIlgZDH154co94UQnH2LHdG3pkr3IQiR1KVVOU8t/H9Y6/VbbqZSPTTON?=
 =?us-ascii?Q?OUO6vPB/78PtQRDy/57Q8TwCFUosBicJeVA0Fd6/7a7rYw3VA8Ep8wf+T00Q?=
 =?us-ascii?Q?wXdhKcq38pqQvHzTFPuhHoE6qX+PXssj38CrKmxsF5OJ+bKtc1VlozG4+7W8?=
 =?us-ascii?Q?SQg8myQ/6hv1GY9dkHW8JF9PqAIywH4BnCunx77xpQc9hKZSfsgYXyNx2rwk?=
 =?us-ascii?Q?kStwi3k9rF4UW2IqV/G503kWwY7m0UXfpx/vJBSvmNHA9HxJgJO+ngoHfX6F?=
 =?us-ascii?Q?Oed/Qj83hBfU5oon9boi0SblqUNJ37rw2S2k4g+3R/pwx53ZFqagvV9HPiPF?=
 =?us-ascii?Q?mE9m5nK+k8bnuq4AeKI1PNFpCUheMWIFQM7eqoHdjS5Ujs4tZGP0fZc1++Lw?=
 =?us-ascii?Q?5oP2/21juZzXVZO38urAnodb6fXlb0xW+4k3Rxsb+xUqLTVpaT+5qHyYkVwV?=
 =?us-ascii?Q?vlC44ju6tiGVjFEVYM0Xii/5PUjX4ZbYQ0q5ZMQ6tm3aOw+GAUEl3EbWS7Zc?=
 =?us-ascii?Q?w0fZj7xZXzzZNocyR9IOAdoBQpjnSW1iOhiIaFv+inXWLA9LADdWxN73bkEP?=
 =?us-ascii?Q?1GGawlqVbZMy+gaYcfxiZ05BQI9RSQyh8DhEBtPL77r/ZfmSENmU80afISzo?=
 =?us-ascii?Q?77u1iYoktPLxrpHVaTb+HDz8gddMpDRhApPzK5k47FZNIMnBwMlgr/2m/BFF?=
 =?us-ascii?Q?RIsw0p3e09sRAztkL8YNLfYSacxIx0Ab7ajZWgov/EiE5DcHhg3pWwl6L0LM?=
 =?us-ascii?Q?u0lxIh5JxNYZt1VWAENilLePYTQrpBy1TpoBi+caH2catrKnCF/FkeeZevL/?=
 =?us-ascii?Q?XgrWDkBK3o00JVta14QdMJ87zG9TRunha4Wh2PBZtAWgPt2HLLeFr+SYKBT9?=
 =?us-ascii?Q?FNEbIoo6liuVY1b+owPzjTap3tIqevOaC7gLR6swLJBbeXYIqglq73QOHzZH?=
 =?us-ascii?Q?UDIMdWizak7taTY1Q14qFWYapLcy2peivyA4+IfRfg/6hqcEZT3/+5J/kvIz?=
 =?us-ascii?Q?EhbTLLR20+DGJxJ3GBBaCI+dbr66g+ouPzdLZmIn/79uZcSaBOOzKQk2yfrM?=
 =?us-ascii?Q?s+Gnb0mtFMJTuneToQ4ESl4s2LYd5UlAVc6qRuLNueT0wpMivifVyOwkJIwd?=
 =?us-ascii?Q?wtfbxU4Tvzov/RA4Z8kPIuQlx/gOeWp8jmioPB064ngK9ZOXEy+zy4bwvBVG?=
 =?us-ascii?Q?IskW9hZLgX9ME5aiW5Tv3tOhBvJU8957h/5IkfG8alkaJM7DQPoGS0pjXUMZ?=
 =?us-ascii?Q?1J9Xj6FMEFf5cE5cfkQhzD4Rwbvwmth45XLWQq7nYo3aaeU4gSx3LGNWEAPg?=
 =?us-ascii?Q?XkVBqanscKLQttMl3HXhPxlUyAFvoSy5hSkUfxu03oNVRCvmImROh8jZHMEK?=
 =?us-ascii?Q?GJfSsK/xCHX8a6zzrSpfiKfVovSKdnQ2x8WpeK9Ef5/rTzwATYwvFR9RMu7P?=
 =?us-ascii?Q?YPbyyU2N/4bBy1MZVRMGgQyPHmA9tYyNVMmscsfEv0yamk+8qxWxGIRGOd22?=
 =?us-ascii?Q?Gc0NE5uKI5J7vobUmTZbAaueJLMPAor/55SLkmDxk/XVvkwQYIZ6j3rDxsK8?=
 =?us-ascii?Q?Tw2TOcsWJF45E9Vh4pRsNMc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d0e4b0-8c25-46dc-2b8c-08da7513b5c2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:54.2919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZ9aXnYLUcbID5w/2fSZDKV5bJShuw1Z0XyQYOKDeZNbTwB3CJLfqLCKID5iNeWoISGEAC3iDwigdGGQJcszAesePkhP9yUnmsoFA4pzAQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

(No changes since v14)

v14
    * Add Reviewed tag

---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..b0d09b6f2ecf 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -171,6 +171,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_REG_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

