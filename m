Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A99957D940
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbiGVEHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiGVEGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5994F89A68;
        Thu, 21 Jul 2022 21:06:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUosOEPcaBVLqJVMpfUfdbyWuczRsWu5yve+yE3I+ddc2oC6lbMAKOQ2Th1Nimug3EjF5u79oYinbQ8vxvBwZFKhDjqc6pU5SYhna083wXgPoFFewdCkM/OHEtxhTwRsmVu9WbE7J2Gr25N6R4vk5sdYnij5kz+hRqLJlZzP/9kCzsYVjxcngOqO7CJo1JO0ioy7vaqcKIsdpagxEoruq5FMzldjucDfADthKJEycuXzDJGWRiL4yi4N5bBiOZQk8yXR2rpNFy6YnZiXzrtwwIkDOUKyhrz41sdP/EthCLmeHOH6S/k4Srfg1OkaAO0/z6/iMEphqV5vIAFWt6olbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lu6RMTzrV2iPUkUz7g79Z4MPGsziOJiTMk1VVuxsbAA=;
 b=Ynr8Kc206ggVQbVudSZVui1WXLL+Zsm3ZXKqjai+vcNQzMFRutM4i85kwQxzIt2tgoJYHn8G8qTRoWf1zG8UuHYMM2TVPsSRQ01oMdOKxYLhsOeSggyHuUuRnCOoFvmw48ELmSDFdU/YG3VFDhiHcTLZpZi33aAF+EDznPdz6xv4xkgNYL8Nh6o+mJ9gD3bHE0rT0j94qDIR0YUSmJ7ylgZlA9SBWEQZT6Wyhe0xsq68HsbvN1sF6yShJZaHtf4oVHF05H/6Xqb5COtuwGr/FbxgB5y8OKYtN2Vzfc7ij+Cjya7swbEogYcgMkTAJnDACXkEJIG1isHpt0PTOaKB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu6RMTzrV2iPUkUz7g79Z4MPGsziOJiTMk1VVuxsbAA=;
 b=bamQIURUMMx+CB3g05L0pR52FWLGhmypz3uaBKsk6JGVXVMfRtPMjx4QLOU8lKsRxlqbUiUQ87tz/aBesHAe4yow5r5kg8eOV1rnvJANzCK4rFt0mEfOa/LilywhqOOuzjEQBOfC68cl+teZg6GdKd0POlHUVppawCj2a2jd31Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:31 +0000
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
Subject: [PATCH v14 mfd 7/9] resource: add define macro for register address resources
Date:   Thu, 21 Jul 2022 21:06:07 -0700
Message-Id: <20220722040609.91703-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722040609.91703-1-colin.foster@in-advantage.com>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65d5e645-a174-44f4-93c9-08da6b978e69
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dpt5e+vdcN9uBzsuyurJgeYF5PrmZ6Pu9xY6uDuR4K5FNRih3QKJJZ0DYa+lMFCogZh8uAAT4GiL7reE0P0tTtm/TI7ZA0otVyDBSReU959R7T5tBBknXX8pMVyvZqWHci0L43LlBlI4QZ+sZmdSPLIr5Iz4O/5rMfwGr9Rz0ndj/4kCdZ9BSVlzwNnM6UT1fZyT81gx6HHa0iC6V8QOBJQMnR1lNdMsiA5PHFkHwISuF+V9SQoKQljRY44kcZVtj7cn7K9Vokzuw9/nYT+eqMflLJ5KbAAC0W6ZMEZ+u4mr24vCEPUKhqoLo38PHwaB73vCCiU5dI6ZVulp2vmblUz9R4UtAk4/PZnwIGJXrgomiF7fYxxFyZ8OSGZX7sDJJlpAWvssQ87yEnz2uCodQnsRY2HyCXjJYi2tmYpILp7F2neoqHhjtK8A5dPNuh9i+Fx7VZbNl3ZAMx7sQ79vzhnZNT/BXXUnrXty9P0nx+e0auFEtvScFXBrnwA1qAuZWF6cGe3QlP8JTvqLewavJdg8ACr+o1MyUCS0iIC/j1MmabxCh5sFqzh6J5zH55o+ikIv1eyb6QI1zuutrDRzBELFAZ7cNkvFsvG1+RprA3V+hmWFX1Q4c9dBmH+ZaDJHerdoLx+i5HTdtTcXhAvwvvPlIM1yzP/L40nCs8xE0L5R5FKNIXbOc/0C/5oz3YwyPsWyB1bSauAEoZcbrTXZV5L8MLXHTfPW4eukRi0l1meDhHjXD/SaIydqhzgfrwO4ZyCMpxt68m+monrJCrHaG997cdFim/8vmPIv02IeSQk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t4XJQGW40zfnxluBECvjAGE6aOMG5uH7kSczk9doB5hL00KjLCwoxt9ljPzS?=
 =?us-ascii?Q?dXWRtE/2Ba9bQBsinD9XItJ7b2xhjBJRuLZaohVRWGuZSfMv9sxe9SwTAmA0?=
 =?us-ascii?Q?SnSEYu7H/wNcz5DdFqKwapGcr2LGQ+UC43OLQ+rCMTnGcINa7h5XW/O1ls2n?=
 =?us-ascii?Q?iYRCSozcboXdWHsFfRW08c2S/8WEUsX4+dzPCMAsVdSaQLJwFLKiuOFRcQR8?=
 =?us-ascii?Q?f9mHgrfYXkTXw70Md1Too0oTBcoTlMA87WN3IQLixqSxtvjoPNHKin7lw3J7?=
 =?us-ascii?Q?UWQH6LMI/bORDzJscvIpMaUH0EpKESIb5cFpZRrjZq4eRvbzNzSpUe67QGhT?=
 =?us-ascii?Q?+YEUutr/HCWXwHDcayjsGKk+oogdgk1eZpHZUpJAo/9NiJNzt4+31ZGjAYuQ?=
 =?us-ascii?Q?NDAUE/HEU/eQoyEAeqkqRExxMmnF7H/PoWG53Kwuq1TUPCVRqf1PDiM+5bGT?=
 =?us-ascii?Q?3z6pzsNeD9wFVdwT4Y8Z+bIgyHGhwLTCnR1Fy0e1NPyk70JRI6/D2S7ZmaIS?=
 =?us-ascii?Q?jj5hnqTOjbFGvvu4SkPflWDqaX7yRBWNi9WJTnCWjnI1riB45yuQWzashB9n?=
 =?us-ascii?Q?Rf5YkeyEZC8m9tO1XMNyPhz9Agcy8T+qNJMiUtRHQjjX4f8Isa2aTD7VBcli?=
 =?us-ascii?Q?p9mjXRA92xSYtCSo1O3d4x9IE3EJkNLf597dy/+7GxX4ix2HX3DedTLTDLQM?=
 =?us-ascii?Q?UJwQs9dFuphv8AVMJeRi/+MPGPqfztD9bAvl+3jQA+/brWumptCzgE4fcfZ/?=
 =?us-ascii?Q?eL54p9uwb9/FrDCwztJNdTF7NOZxNhZ00sQH2L8EoGTqju/yrhn1MVY7cu00?=
 =?us-ascii?Q?R9WUVx2Ofn3Ml96xDexc6+Cyr/K08S00NRYZp3dw8D090ZM7P4yHVmHz7uqw?=
 =?us-ascii?Q?uiWArxjcFygBXmwau7zJXaPgHXYrltDNL2RN11TZp+uMfdPl1eUgouOWjcno?=
 =?us-ascii?Q?fiZ0+QwpxFfYq/7zQy4MsfIxv7G1Mn+viOS/tuU3mITyegTEFgsYEv4EZlhl?=
 =?us-ascii?Q?CvG67dvSTZp6nfkGtRJ7cXgXx1GxIKuDSJXXIsfWGQTPCtdQJywXmalOoJ6D?=
 =?us-ascii?Q?PaXxa6AkHoPvuo1be4r6GHoqfbmntZ8vH2dPzqgYyzaTLp5HTG3BKZ4HSjfQ?=
 =?us-ascii?Q?z9ywa0DeLuT+ogSBAFLhBmJqRKDUQ0kSqd09GIdZtGngC5sGwvqDwdQ8/mYx?=
 =?us-ascii?Q?d7AdoI6nfjItJ3unTUdhiMdM2/+ckAAlHYJ3CWrU2gGNAD6g62Av3YCSoQtJ?=
 =?us-ascii?Q?BaIe8aCLi09RreHB5oG94kPh8MF+3OqAvRhp2ouOGjo2A6MTEw4aEpyt8Itf?=
 =?us-ascii?Q?Hysg1jKJPZTcPRm5t69KE/mOvTA9x3V2KHQ1C3SExFL5uGNrNigfDFfPGPV8?=
 =?us-ascii?Q?ahzkNuP9ECKgSw2yMinHe/ue0xokYOYHoipN/7cy+Fe68y/orQjmeguEg1vy?=
 =?us-ascii?Q?RcI04c85NGBuhTTzd+lPBsefdoGUyHS88fboL24GDQUYp4bHpg9oUD8xAiSP?=
 =?us-ascii?Q?ED9h/BT2IfYkbjLapWT1Kgm71TrCvSkfXhceQWnSiWu9rcZNexj+1NY7grus?=
 =?us-ascii?Q?11z+eWLY+IdhUbuTcj8IhSIoRIUm4zs09f1LBVhGufbLkJpNLWBbVmzUUrHy?=
 =?us-ascii?Q?mrBvy2mbfI/TDHCOTxO5QmA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d5e645-a174-44f4-93c9-08da6b978e69
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:30.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3XmfuXg1YwB0v6ThdGZl7Kd2pqC8v9cDOU5AfNcDJEZsuTJaFlw55QpqSRPzrifWozG1qO11lt9Vt7MsuW1LUtwJAffpskSBGk5c7p54AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
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

