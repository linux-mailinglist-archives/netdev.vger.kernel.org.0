Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847CD552D1C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbiFUIfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348233AbiFUIfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DFA22290
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Feir+RWSCGKx9WmK5khvZrYJiYJVpyBDmnKb6dQccVPYfpI8DfQs/fCPGqL8Q500vAN9jzMgJ+k6hb+dTfgjZgyCf7vtthPQrZIR0ZBG5No3lnXohAoLahbvXAP9U0GO9i511y7GSgMbgI4xxnEZvP8172hO8Ft1XsF8IJZp3JBTlmnhORJrgd0kfNhDdkvDGuPhKaq3C91uNssh9pBsZTRFbl4asM/oQTQDgvTP5X3G8uqhrayJw1RZTsfYj9pa9PlM0cRVI57MaT+/RZvjvu8xVihatTq1WdVFCSUjK+Bwr9svxDWIJ3JpX9NNHf4P+jqnMr6hh+ZXYHX2I5HtNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txAOY+gjCcEMOneKrHDOG1fHkjcyw0JJQqaF0zwMtHA=;
 b=eubRxba1y7o9MpFM6CctxDzEqUWfb2dKs2X7gyR4iMLrtwlWi/I71DvT+Xt359S8ipA3duL8Pw853/ZaFfcQEormLcV2oeDeiFeHrDUJiUHbLhr249tmYVn8W+snKBQn/uBe6DGaY4P8fbV6wx2QJ24ySPlfWENl0DhDPngkRrHK46LsPR8TP14FdrHL3UUp2nC5kjTI/dz9I3aqjzFoGjJBOr1sza+D+Z0joXNHzs0M3CyiTRV79Enl5R25eu+UfYrgSkXa9Xs72JttmP8tPGAELvs1AMqWw9PO11ibz54i3V2pFXZXoSbluHHtCFBvtabT4R6eTchd9Z6RP3fd6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txAOY+gjCcEMOneKrHDOG1fHkjcyw0JJQqaF0zwMtHA=;
 b=QPbulujiFHfdHW5idtqfACIyaqgp5K/9S1IiQ016Ygt7dS5dQ/EVsUbYd23woWobZQAvlFY4y4hT9g/cxqGpAjwGuAwRpMFwuwgeQ10mBhCrWcQIU+EFFAWgtxrrdWqaV1Gogh7nwU7QCEHAJIAZVRoKZS5sNkWa/X7GnWnL49PiQmYW/JCz+QImm65KSskL/4Uvy3CDtl2Lid19csNmy0/dqC/iQErkLaB3W0mcx5Ct2X5KMYCmnQhZHLYBJWBs6Kyt/UTwqO1T6shHzFKOFWOMgOAvD/cNz/LdcvMAwfHzo7pFVodZWvG7AdGSc28a0dZmrgnGNr7jo9d9idZFnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/13] mlxsw: cmd: Increase 'config_profile.flood_mode' length
Date:   Tue, 21 Jun 2022 11:33:41 +0300
Message-Id: <20220621083345.157664-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0094.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44bb2a1f-91af-4a22-cb44-08da53610293
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832A6FBBCF2B0C0899CCDF2B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iodwb8DC5operkbDKWwj97Z1bUdKwti6QmcuC00Z7J0cFzaRKLOV8Dzt0w5Oh2+o1ucY4J2aZd4rk7UxXUxpbTrANTV+mdZhcYbJVKbmSmh/3s170BPSnH+qwqyy5+QJeaoWZPaKv4v9lMYUtQEsl8GqZrfRvN5lW2cUZ9PLzwqc43zLJg3A9dryYMCSuinzbpJ4Ga2TqxAHQZijK6G/kM57Ngz7LYTYF4X1Y+KgADN7TjD7jJYUkveRQ0VBDWo3QtWE8oiunCoEWW+e9O5pbVbc+8e4m9K4/tps8laxl/o0FSHuKJ+mHzbYfH1Vmt3Y91CpZ+xveVAWbI5z/VG+MFp6q51cY95AlG9O24A+VDQRqf+l2M0xGCxZjgoEJ+GXdT3CjFfJ/1jkmq4TIAPtA0wHa0Ex0+q+ndkfMB++PWqSTjtNGL+uwGPO4/+bGdrTrSnK+6JVkPLD3n1Bf7vOSKS6XnBcJzYmZlW+npgm+f/cosE+ei2eHXjxjx3DTi0TDl2CDA0SM3yHMIGasjLxqglTXYQqmP3pgZm5/kxgh0a5L+1d437Xjzc1gb5c+MvTd2sjVzGLxp5c7F2mGEIN4+sdAs7mu1uXOIHfNPHrYKgHRrH9N86N3p5oAe4bUO/HRuLA4chsRd2ovOWGEznkww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62iA5knsFgfiMx9+28SR3PJkzvu5s31u1pcFujhd0zy3YpXYJ9i9ZfliX1Dd?=
 =?us-ascii?Q?cIvDndi6MI/YObOEJXUIaucYCh6Im+eiIK/PvNUpyky+mnw6BUA4yIUlHGxg?=
 =?us-ascii?Q?8ACDUNakcRh93x86eouoydFz9JXqjQTCAVaWr+jOAkavPPi3xOfib2mVM8xi?=
 =?us-ascii?Q?LY+R0O6l8hHpJTVR02D4w+rihwNWv3ggIeHnhkbYcaw7eBhgrTosm7J9opgl?=
 =?us-ascii?Q?0MOu0gXVtgdzVBDfIKrRhPqpfHSxGCIPrQXIAP2KF23XQjT6B9ReuxcHk3aT?=
 =?us-ascii?Q?2XA8hCdXjbm/MYo9i0tsvEE4hzx44QcNVkLgp8N91YlWKD9++TYokE+lQY66?=
 =?us-ascii?Q?xq285Yzhl04j48iKRSK8K6hJ9B0wl9ewHGN9LxeC+hw7cskfCokou9QxPdnp?=
 =?us-ascii?Q?dcUzl8PKs/OhVJ/F+u69LVHoToWCOSZ1lZkQWu+PqV9vqKpEh3JwVoR0Ma4f?=
 =?us-ascii?Q?MVpVDo1vD/ITZx7cWQg6jUDibHIJKSvjRUNq+wg2dTTZSGaMrxy9R/OAd943?=
 =?us-ascii?Q?cxN9AnLnq3bgm1OR3yNTODibivu7TS8oETKQMURxA3748FeOFr/b76scaK8d?=
 =?us-ascii?Q?D4vEJ054QnUJ+EgB/IxpQRv29/9KwEhQARMKjMXDu9xpvo6YdLFUaUx1xIwo?=
 =?us-ascii?Q?gvwpPZv3QQGCONTFQq1PITf49yGivF7suwnw6iqHXcLW3TRq1Y0odRNoHSWa?=
 =?us-ascii?Q?GvRMIRLCWjKysmsJP8z0u+315z6RKIJ/esJP1Xxm7HAuiUClRcVr9nc2t50a?=
 =?us-ascii?Q?doAT5CksSRM6oQTucrQpJbDj9lunn9k5PjzqRdXH4jeXlgjTLq3uWaPtEzuy?=
 =?us-ascii?Q?UAnAYhBTOw5hDmWtKxh8+s8EwZWHa/92yzuFbQaGSmP+XRLO5OIEEI58RRmJ?=
 =?us-ascii?Q?OQIH9ZQ8ca9G15De2Hgena5VfRk8wYcmfZkoV2+eiNaNSbS5NrtbmXVDPF7W?=
 =?us-ascii?Q?0kH1AnUXd8QTz/Z2Z9BEt1znvX8iN9xVLgvngD7Arkws30zdWSW0uqVqgJEK?=
 =?us-ascii?Q?i6poofsC/qAEAWCKH4SCK4pRETPBGfdMaelBXHQC2rd3AFBEe/javZNQN8EQ?=
 =?us-ascii?Q?N5E61UCxgRzoRRoAfUURNzy0aeBzd8+W4JfJWjyg5iD603QpYv++Ooz1FZ8j?=
 =?us-ascii?Q?TAfdxudBYx7Ya9zKcu8bPcgFqrOiq6AlXP/IQBjAckgqqhsKSpMs/MroiNrt?=
 =?us-ascii?Q?MWFwLQuT+EvJnx16zvVAzwFGfZS7XOHGp6IVLpuQSXaUxB1MucN++q3GuHoy?=
 =?us-ascii?Q?ZICMoFoyoGB0YHjEkCEzhEDl3GVEl/AJMndHdOSz1/Oqq6QjB6ZT7ILTjkdO?=
 =?us-ascii?Q?E/+egnrtBv2di98EIz6sgLfdWYK0cJKzkNwsj7ELoWFy1a7+vT60UlDZrwtB?=
 =?us-ascii?Q?YxFEv0rSQHOPp6NNwoyUSPoh/NIFf1ACZCp+Ni2qJBYzkAytxvDsL244f2Pu?=
 =?us-ascii?Q?Fxiub5vVwX9pkG97gUQex7ERg3d3H857i6cd3yF33m5M/OEG4kh/Z4D4r81P?=
 =?us-ascii?Q?FgHxesqAMnERSs+zKDY4gPMN+mx+3wv2gMljbPEkGc7nTEOjNnfsSN8gtMli?=
 =?us-ascii?Q?09l1IrGfO2nz0LM23AjgW9+6EIbkZFvf3Ouqz/YhYR2xoke4KnwQMFNbUWms?=
 =?us-ascii?Q?b6nfHPvho9n7rFRkR1KwqEZP1kvWOfSF7YVK/Z2V4dUxSZBbzkOzvre1IPTh?=
 =?us-ascii?Q?zZ9GY9ZVALsVXYUZ9U9k/DkSkbsFgvFQSS4FCFTXFGmpP7mARNT7owVRgFos?=
 =?us-ascii?Q?yGRtzJJDmg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44bb2a1f-91af-4a22-cb44-08da53610293
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:34.7613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kWogdIU+M7bx+1ULezlcuMpjCi/2qePKcj0+tPKwS4om/S9K6ZY4RPGtogNXmsIgpZDvznKJZx/vZuGnVAcxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the length of 'config_profile.flood_mode' is defined as 2
bits, while the correct length is 3 bits.

As preparation for unified bridge model, which will use the whole field
length, fix it and increase the field to the correct size.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 150dda58d988..8a89c2773294 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -731,7 +731,7 @@ enum mlxsw_cmd_mbox_config_profile_flood_mode {
 /* cmd_mbox_config_profile_flood_mode
  * Flooding mode to use.
  */
-MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 2);
+MLXSW_ITEM32(cmd_mbox, config_profile, flood_mode, 0x30, 0, 3);
 
 /* cmd_mbox_config_profile_max_fid_offset_flood_tables
  * Maximum number of FID-offset flooding tables.
-- 
2.36.1

