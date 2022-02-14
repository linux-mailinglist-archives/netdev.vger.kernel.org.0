Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1184B5E57
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiBNXhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:37:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiBNXhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:37:19 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2076.outbound.protection.outlook.com [40.107.21.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4B3116D3A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:37:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7Qqf5c4drFLD0cIwhi50L7Mu77Owl6poJVFKdYmNH2KuQ93/tNRSPmktK8Qf61WtP9pv0ZY0APTmlbNDvio5kvmTcSZ1NYObJWgNxKLQcP9n4IL8lhAatxPQuL7f9EPBNoDgupRG/2snYDLdjBuW3h71dMfAUO16+oecttk4fJncO0sQIOTmasEG/7rP41cNPVOdnanJhVmKj1HBPy8PbxiXVdxhL40D6vFlnQ+PIzyK/w55t6E5rBm6Xv3xRYOh1qqYx7M1yhs+/JspcAGKuQq3LaPQCSax1K6tu+8MeuPKo72kmxS2onoM/Qpzt2s1qA1/lTmCNOApbqThi+eVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HCH9w26Ohg5rUsT6m9M/bvVHdFpukXr1rFw2TZbBRU=;
 b=l8Z3WHpblhZyYr1qHFQEQMH0h9rAD5XhZR2AddcTW+An+t8yPbzcP3nF68C27vnTtk+DII1fVaG/n/bhC4D2OmD0lHxBfKd2fX9yoHJgN6vYHpjDvVXiBUJ6nPMX/nG0udIdqhkgxDP9fygxmLJ5Ue+dIzr7x6KAVqR/rnjKpXEvj5Ce0j/7Ca7vOIKV5bqEDPBBqU/9J8gOu1LzpvCFF1XCvTDNpdUcNP4Up+cPVnTiJtamuchG9mdMLxx2XuH0YQ5nGv/CGtwR+u2Ld4VeHxxpqtCVpHhre5RBbeNo5qnuUlq+ZhPTSLkX1xKAHYdN4hW6VEZtVdzZA6ZMUdjDVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HCH9w26Ohg5rUsT6m9M/bvVHdFpukXr1rFw2TZbBRU=;
 b=oA5KbH/+LnKsmOPRqsBRXDXNb2bAg3CcDiiR8ZIhIM4QwSSdTAsUU/02Sh3rmWRsXEBMFg+vclmqL8GjKzWyZ5lrZSn3TKElLbD1Qs0ut6tflVYgVPlSGGpnEZYnb4z3zyyaNiCNUPsWe3lFjCKBt0IIoacPCq2zIxmCzYDKRbw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:37:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:37:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: bridge: vlan: check for errors from __vlan_del in __vlan_flush
Date:   Tue, 15 Feb 2022 01:36:46 +0200
Message-Id: <20220214233646.1592855-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5P194CA0023.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0446d1b-df19-4b44-0da4-08d9f012e97c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504A72BA30D938565D23452E0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7j8QISVWNsNPeu+9J7v6rldPfLsfJwWVVmsFceUcRoovvR1pzhRg3lCGGXhREzH2/BQjx1kGOO0wyiyb3DbjSlb0pON08A4hHthEsmEd1wzVNEFxqsJy7GPhiMpKEnw0NYU4kbGCRnbLWNbb5poFwQ34Fl6DMXKBYajrbnsTRqXMUb0XbCpGi5qjcwq36vKcrzKBZQimeJJ80PdpImwPGjU8ubl8BJw8i5hpXrCxDTWk0PgqYiQEFef4h5GE3ZGLp0gt7HYkP7GaVHgS+5OfvfrNdS8g1EPpDVXaRdBRJrTVAHNqqXk0D3O2siRCNnSF9dFXphXaq5YvHZDbYDrLOn0ch9N7z0OGAjIZvldnGjhsrPKpkuhCdHayk+MBLcs5jrdVBvo5Ufudu4MFmt27E8iYQbd9O77hOBCpReSlM6pXS8fNAVYlqQUy6RJBG5fBRxY9Nk0EcvHA2ibJs0L5i47TlwtKIUeEC0KSCKtm3LG3iYE6qNMtaahro0EJWvSDvL9XLeQc41WhX+PcpOuhHFvOGg0b/Tnny+5/uBBQBpnFjcyRnyJmxJpxZVWOTDCPdQgCyQ4+CJqFSzre0qvv2vkiMIyEtZJQqxnMsIRMc0j7ETq6sD2SRMq2EOh/ZPqEBtXd2iYqWTlpJW5k3gaG16SCyiw/oGZh8dLwS+YmjhBnX9iZJHuxXxlHQv7HI4nZ9/BNI1YGQrkwedQeqel9/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6666004)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KI1B79qY6CJ828xaK1N9ixK1hJjAnzrZ4vAL6CrUCIBH9IBs5yIq3tDYGRFJ?=
 =?us-ascii?Q?xufBGHs4hNeOnAzs6gsUJeee/VuLTBjSRmMSxvxyfsj/4MUgYKJ6y0K7RgDx?=
 =?us-ascii?Q?t+1QBC6iJGbdHzWo2FzonSQC4W/6EDtl7fOpN7LiGqpoFgtFpgyLMIoAOhgL?=
 =?us-ascii?Q?zKc5feQjB9XHBmWg9rXkfftIlxczyoC8C7qA2cafV5E40MrK2hip31CxyOjw?=
 =?us-ascii?Q?rGk2BGaixUpqvtG2yXVexCE704aKJQAChInRINwE4O/qRBA8cEXtkZ41smay?=
 =?us-ascii?Q?iDXq3y0AVDhPORHYKq2vqo+2IxWxSrNCBwO4C24Y4TSWUC+Jv5fg4yguXuHU?=
 =?us-ascii?Q?vZ0JYQtOfsbvp1drE/kJU8UU2lwi8Lx7kOgJFDNFHYmTe0SRdztvrG/sNjpx?=
 =?us-ascii?Q?/Hp6nkSRSGp6z3MtjjBpSEA42r5MJUDrTQsGrWREt7+oN0gxr2+ZR06Od9os?=
 =?us-ascii?Q?yWHfz+alt1p69HpAC13FTUMSIVILkYhKDSBTtfJU2i5B9z1R64bodYc5wPax?=
 =?us-ascii?Q?z6Q08efGP6RxMbVg1L1by5vBeN4EKK76/SH5qkXLjzP0FivJPYK1/3/YMPpX?=
 =?us-ascii?Q?ar3WdDGBIFFln3tLuws4/oecqXvJOzB+P2tLIZFCNJCg/+gwdI3iBF88Bpi6?=
 =?us-ascii?Q?eyJEF0HgVOmFDzU9EaMQLY8q8qQflMWSmASwlTUPN9+DGBc7s3vfsjA710VM?=
 =?us-ascii?Q?FT40MpxmnkAb0Dq8kUYpvpce3FZ0dkRSn8FphxUHTdf0NOT283cnaN8CS8hA?=
 =?us-ascii?Q?efkjvAw3D4yPy8F/mQWuFdlKahO0UgAV+kOHKMsNeiVdUuSzHDm/aoTN8rCO?=
 =?us-ascii?Q?NP2Yw3kI4e97A5gQy87uWsxd/IsDeDSjv7NB+2slDu2UVrB9b9OGfep3J0x2?=
 =?us-ascii?Q?Nrw3R+S8DL0/QhfZe+GlNHJu32kdAC+UXVWbghiZYdAl34VTjKeHTUt82ETg?=
 =?us-ascii?Q?7+mdUByrt/sA1c7yed+xOz1RJgvOC+KYbmsKF8j8lBBy+4EIpQ+HVpbHIGsH?=
 =?us-ascii?Q?ZjR1unlJG7Xj13VsDYPwrrDFGuA4j7oZV01pgvu36aWnfREGEvbqscmYaR7/?=
 =?us-ascii?Q?466gguPTwhc0uDhwxVlDlTANfikQGy+KUgCWPxrl1ijsBQzWhKM76qs7AINi?=
 =?us-ascii?Q?Ujd1S2SDBipzPjS9G8RAxFxe4R8sERwQCaz4g+PSqu1gRw6m92PW+1vq8cyF?=
 =?us-ascii?Q?8cx16Q/o5KOCLwph5ELRmWS6wNy5CskUGwQ2JnZbvCn+CBhnusjbN5edFPjz?=
 =?us-ascii?Q?m1urghMsN0Fww/IYCBkeTn6FA/A61Fq5LK3MHvkR2981GCZP1U24/J7YBy6l?=
 =?us-ascii?Q?5s9rvWOEpilvqgeFW/F/RF4zf1YvOALQkfvAl1Cv4FmcOOALuSoRGhxogpzn?=
 =?us-ascii?Q?2mlvbTBqrx+L08rgmxjGpuQffixEvmne67FLWna2sGn6m0i+wcf8Du5DMJEZ?=
 =?us-ascii?Q?Mbr9iOaW1LWWB+Z4YkWfAXqbC/Kb7tDAkAINOPyaUw7JMgGwZblRuELJMv8u?=
 =?us-ascii?Q?eUhf01PtRyBNhPlewQz3Y2RhtbzPaaJ3SMTJ4mqrkiQ+T8MGszz4q4N8T8CN?=
 =?us-ascii?Q?kf3giSr+coGpYQf5nG995SveDMnuzjRdUAJ0EGVt2R8t9WezgQcjBQRP/dZe?=
 =?us-ascii?Q?oFQUcpEpptJBFwTw42XJFv4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0446d1b-df19-4b44-0da4-08d9f012e97c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:37:06.8028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IyQbbVnqI91ixMkEa5TVsAhUSMAwGiQy0Cegi1oUNxXEYGLQf4DDZlrQdXdBJUQ/GAF8mHpXVJGi2hjpfTOiow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the following call path returns an error from switchdev:

nbp_vlan_flush
-> __vlan_del
   -> __vlan_vid_del
      -> br_switchdev_port_vlan_del
-> __vlan_group_free
   -> WARN_ON(!list_empty(&vg->vlan_list));

then the deletion of the net_bridge_vlan is silently halted, which will
trigger the WARN_ON from __vlan_group_free().

The WARN_ON is rather unhelpful, because nothing about the source of the
error is printed. Add a print to catch errors from __vlan_del.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 6f3ee4d8fea8..84070524f657 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -418,6 +418,7 @@ static void __vlan_flush(const struct net_bridge *br,
 {
 	struct net_bridge_vlan *vlan, *tmp;
 	u16 v_start = 0, v_end = 0;
+	int err;
 
 	__vlan_delete_pvid(vg, vg->pvid);
 	list_for_each_entry_safe(vlan, tmp, &vg->vlan_list, vlist) {
@@ -431,7 +432,13 @@ static void __vlan_flush(const struct net_bridge *br,
 		}
 		v_end = vlan->vid;
 
-		__vlan_del(vlan);
+		err = __vlan_del(vlan);
+		if (err) {
+			br_err(br,
+			       "port %u(%s) failed to delete vlan %d: %pe\n",
+			       (unsigned int) p->port_no, p->dev->name,
+			       vlan->vid, ERR_PTR(err));
+		}
 	}
 
 	/* notify about the last/whole vlan range */
-- 
2.25.1

