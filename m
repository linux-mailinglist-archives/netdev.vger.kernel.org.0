Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B224755CDC8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiF0HIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbiF0HIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:08:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5E6C0C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jqbty5S1MsGVOjt4xKO0okjI2NXd1cmc0Uu1uwglVMkqHHGg1I2vruUC6+mKnrsgkIlqdxufUCxHUJDYhJ3dFtnmf3+PRJrt7UscUQAIZtxSwV4vypV58uUwNMHRQYmKaB9Ao/pK+g3REmmcXeBRvltot8xySKzC34lBnRhfLKPB8dQ9DMVWR6jxAypqcWJ9bPaFh+UC35jtQ6gGwSx7uy0qWGrtbYQZXM3VlYhvAKFWUsONFjmbOtW/PUQousI2Q+tvwV9Tc+mOm06InbdvhHPpUrQ7Q6VyLbnmAKst9QHDOM/UN/saHP1syaolY2HVN5aKntQ9cKS2FbrdD7ffeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AhHxQBSoGC7cEBbcAkZZTNlEjhN1dc2Z16yaCUqb8M=;
 b=joeIHhuSn1l3bObjI+y32EMRX4B/VbZ+8rWP3mi9Yk6NRr+fEqDwB5xKdmC/DxinaCAJQXcAg4vl8S1P7FEiOjyTy8d3J7u0zXcYZwGIEWSTqcilhYsoknKuNtmUGkrkIaveXdOd9HasPopBhWVUjR0VsUdaD5mZsAFKu1P3dlqXlfVqL14Rr6CqC4LlGOysFKeaOccMnmgLspoG8q5asNEN2ApoQlSqYuBQ3geCYK1AXA9uaVQMBA7ZFho5pCjQJNg+rloxHJFpY01OwX7RWEGqY8HVt8pm/iSlLuEJ6R3nG1bkFAsaiBDL3uSV/25lzZqQzYI07g4941ytYM/jVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AhHxQBSoGC7cEBbcAkZZTNlEjhN1dc2Z16yaCUqb8M=;
 b=EU+xcKdLKxZi+PdOTfsInEukHatPj9++WimGTPrvmyGvb0ssx1xN29JCvt2kPDAXrNsZM3ifkGTal8BFIPKymUxmXjl57OSx2UgfdpRndMaFJj02WJzDyKGyBs5++z195OjOKN1oZHxAs0sPGPZM+MnHT1mPYx9LvuFKZRMgNTnjTl8JmGgNupZEY4d0opVBhE/CmJ5542PEgswHDk/zACnuwL7+cuCn9z/ifWrT+kS2sUSdvroju53uHUIgbD9egxft3yB+T7sx6v6VCVRQghY8V5S196THPgAviuoQ7yUE2LdAX1eHIx3u9ehEZxvbn32DorWXI1qHXQj3piQkow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/13] mlxsw: Extend PGT APIs to support maintaining list of ports per entry
Date:   Mon, 27 Jun 2022 10:06:18 +0300
Message-Id: <20220627070621.648499-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0465.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c19784b-bb44-4c07-0b46-08da580bc328
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtnQrJGmCVqt4mWzhPf5RwX/zY4xLMg3QgVbkboV0oeiO7cG4r4hI2ziIVRvSlGpCJhLsdB1gYh93xrHnXS4cDvGPw3GIB7xHdVq8yE8ROsoIv1pK80DNvVlPW/qohy7EIfGQvZBMJlg3GkypecVjSZV6nLwzDsrq4Sr3lunzPmSAZOOhFcJAiebRpENO44bfOPaSye4ygvgqifXpKbxmuCPoFL/lmmQdkWF2Z28FjtZJSjC8IXAHMqdfAlLq2qcE6hHF8smcoRBKUq3vjJrM7rYwE+w2NuzcUIbHGnV4yma/PKy9QTYaI1Y9BweJHbo3wT47cz5KIPfq9oKGh7td6gSpJe/mEVHMWrmRiqPY5JBo+05anX1DpoSyWkxc9wAN6JPDZxaeJ/H3zK5mK14tndpX3bUD/8dE8j4CmAh730EhB1yWTWQXO0+enZfEpQZlj8UmjG0Hqk/mXBn9pIM8FSAkpA1ZhIfAoZnw4lGcS1nhZetILz0E7h9aAMphNfMl5x+cvakBvna6MFhx1tnRF6tJRpGEkd6s6/NX5dF0P/4F0yT2oJ8Z0N7ydWodonFdm2V505vGKS4ijt1Bp0QADSAyy8uuDicJR8wCd0E3F/xmW84+zjPN71/GKDZTDdTr4Q+mcnPFg5XJBAXToZCKyNUa+wBbEGvJrDXfdlGXg1+xVVrcgkZ+IHSsavz45j3KxBJI0dENcR9z/R5WXcTfnoruqdobMre2+UIOE2XeSGl7ack0t7UhwD/kLsBBToQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tRL50i2UpGdU8v8lZ9GUYjhm73VZeyjitcMAxxp22eJEbduduxEsxHt19+Tc?=
 =?us-ascii?Q?p5fbeXs0VttVOqtXTXs/3LB6h9b9Cob9e3EHgXNVMX4kcLvRAV/EW61CkdJ7?=
 =?us-ascii?Q?5405OVOKrHo3XgXl0m1BLar2R5kc7mHiuPUtah6VENbXtvlQBBUqp4QDUOGi?=
 =?us-ascii?Q?2E3AFeCTsCq+ZJMTknvJGazuQXF4neeeOaRpoGx0nKqFGdoBPxYKrmAc2Jfk?=
 =?us-ascii?Q?eR1BArnNE0YTBmXMtG3gwpho52ydZDpPsGoPm+vSsK1WcUbdkAPvlfkAKN06?=
 =?us-ascii?Q?jweqokgfVDbsnJ0VX9zk7+ky27sUDppaunH71AJFEW2c76El0sXQAz5vGer4?=
 =?us-ascii?Q?+vVcdOpc7lujeFgbfDKcUnQNoZE50Ndd+zR1XVNNaAc24JCxUgyHiAvhHGVo?=
 =?us-ascii?Q?PDRQOwDWn6fe4i/efhwDmyTGZztzFDP/HV8KcBMQOB1XDHWgbcO7u9/rnR76?=
 =?us-ascii?Q?tLy0uhRB5+Gvj4A3+CnQE4Sdjl8dPetYZKK6r79tluWtJ9pSev8fo2bvrA6z?=
 =?us-ascii?Q?5C9uW5Ew4ixFaYILWKpfS4JP84QqJxtGFRuY4QQJCKGUvouMveGkGtAXbMDn?=
 =?us-ascii?Q?b2ihrc4+qvLh25M6UFMwOFxl1gY7vQUF4ITBTKQzmoAzcjpIGvUU5hzm/NlG?=
 =?us-ascii?Q?LPzOTeGy/7b2XsseCjgsHyhOezUDKsQei5B6FtB1Ddty6sgryoVeUJw1T/+P?=
 =?us-ascii?Q?uolmN7n6DqOFr00UduO4PRlXYPUPAubXuoFCddBE5eMI4zRcDik8RIe0i4Fh?=
 =?us-ascii?Q?XUA6A67fLA/Iqz+wEfng2Ti+paCevYJhlWmLYNIIfdh1HICcz+lvSB4k2fb5?=
 =?us-ascii?Q?XTrxTZBP14aC2lMdul8bBa1Nj5ELv13LKH+jpBhwiY0ekUt9iFuozKonRqDL?=
 =?us-ascii?Q?ACs8IzDQOfWFPnAb78r20gM3YgtuKHrzlkHA98blb69ubEfiheSlTVxNOGAb?=
 =?us-ascii?Q?70KXTJvmMM227lOE+RUXPNMIevDnn3nkN1B92fy8rrkc/eRWdCN2eEO5dLPA?=
 =?us-ascii?Q?V9647kQVSI5lCsMrLuqTz/hK+nFMNuTvpXauxmUzjNR6s2+rISthTLo9ZDTy?=
 =?us-ascii?Q?eHICCOfoG1zdgTgqLyd8khjSnSCxyrFlt4G/UcGGGYDVmu9vUvSxK8pLl8k/?=
 =?us-ascii?Q?+1NOB/GTLYt6FXtc7HLD0vRD5snUkJXrBggI/Rds34u5a0yQ+TUFnSi062d3?=
 =?us-ascii?Q?cpb3L+RXARzqJwoSnpM4uu5TWBgvGJbMZAN8RaxzFVLN4kqJnLydtWtttGU7?=
 =?us-ascii?Q?JfdLo9LC2FIMIpo9OPvH1VPnXmq1UNTbLEGct5ewo8Xi37rAh7yu0MGQ9/bJ?=
 =?us-ascii?Q?sVhXSSDYWhCsRiBJbNp/yR41jFnXd68fVLS/I/9Crgwb1CKJXI9SzciYbMm3?=
 =?us-ascii?Q?kHbDTvYMk00D+K9uUJaJErwqik+LbsNaB355/RVp4wLAs6kBnGNss+81F+u8?=
 =?us-ascii?Q?uWs1vYf8oNmec9AzXy+WiBtY40lO02D0w8Vw8klDgqGGxAs2Xx4w9HWbtRbq?=
 =?us-ascii?Q?WvJLo8WSpRbKrLUgxfcT5sOzDwvfJ8qWM9t3qFMXjMovr5fcjHfgu2iSo2Ii?=
 =?us-ascii?Q?YR+ASQRI9PsW8Z2+l007Fnog1hFZ8Y9dEEEmie+O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c19784b-bb44-4c07-0b46-08da580bc328
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:57.0443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QrR0JNGL4xy/V/zLTCBizfU+f1Mq8m5u2ZoeOC27ASY6BwJcXt2P9cjbWTV01X0LSBx6bBKl83fxgElA62KIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add an API to associate a PGT entry with SMPE index and add or remove a
port. This API will be used by FID code and MDB code, to add/remove port
from specific PGT entry.

When the first port is added to PGT entry, allocate the entry in the given
MID index, when the last port is removed from PGT entry, free it.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_pgt.c    | 229 ++++++++++++++++++
 2 files changed, 231 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 645244ac5dfc..b128692611d9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1483,6 +1483,8 @@ int mlxsw_sp_pgt_mid_alloc_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base,
 				 u16 count);
 void mlxsw_sp_pgt_mid_free_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base,
 				 u16 count);
+int mlxsw_sp_pgt_entry_port_set(struct mlxsw_sp *mlxsw_sp, u16 mid,
+				u16 smpe, u16 local_port, bool member);
 int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_pgt_fini(struct mlxsw_sp *mlxsw_sp);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
index 0fc29d486efc..3b7265b539b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
@@ -14,6 +14,17 @@ struct mlxsw_sp_pgt {
 	bool smpe_index_valid;
 };
 
+struct mlxsw_sp_pgt_entry {
+	struct list_head ports_list;
+	u16 index;
+	u16 smpe_index;
+};
+
+struct mlxsw_sp_pgt_entry_port {
+	struct list_head list; /* Member of 'ports_list'. */
+	u16 local_port;
+};
+
 int mlxsw_sp_pgt_mid_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_mid)
 {
 	int index, err = 0;
@@ -94,6 +105,224 @@ mlxsw_sp_pgt_mid_free_range(struct mlxsw_sp *mlxsw_sp, u16 mid_base, u16 count)
 	mutex_unlock(&mlxsw_sp->pgt->lock);
 }
 
+static struct mlxsw_sp_pgt_entry_port *
+mlxsw_sp_pgt_entry_port_lookup(struct mlxsw_sp_pgt_entry *pgt_entry,
+			       u16 local_port)
+{
+	struct mlxsw_sp_pgt_entry_port *pgt_entry_port;
+
+	list_for_each_entry(pgt_entry_port, &pgt_entry->ports_list, list) {
+		if (pgt_entry_port->local_port == local_port)
+			return pgt_entry_port;
+	}
+
+	return NULL;
+}
+
+static struct mlxsw_sp_pgt_entry *
+mlxsw_sp_pgt_entry_create(struct mlxsw_sp_pgt *pgt, u16 mid, u16 smpe)
+{
+	struct mlxsw_sp_pgt_entry *pgt_entry;
+	void *ret;
+	int err;
+
+	pgt_entry = kzalloc(sizeof(*pgt_entry), GFP_KERNEL);
+	if (!pgt_entry)
+		return ERR_PTR(-ENOMEM);
+
+	ret = idr_replace(&pgt->pgt_idr, pgt_entry, mid);
+	if (IS_ERR(ret)) {
+		err = PTR_ERR(ret);
+		goto err_idr_replace;
+	}
+
+	INIT_LIST_HEAD(&pgt_entry->ports_list);
+	pgt_entry->index = mid;
+	pgt_entry->smpe_index = smpe;
+	return pgt_entry;
+
+err_idr_replace:
+	kfree(pgt_entry);
+	return ERR_PTR(err);
+}
+
+static void mlxsw_sp_pgt_entry_destroy(struct mlxsw_sp_pgt *pgt,
+				       struct mlxsw_sp_pgt_entry *pgt_entry)
+{
+	WARN_ON(!list_empty(&pgt_entry->ports_list));
+
+	pgt_entry = idr_replace(&pgt->pgt_idr, NULL, pgt_entry->index);
+	if (WARN_ON(IS_ERR(pgt_entry)))
+		return;
+
+	kfree(pgt_entry);
+}
+
+static struct mlxsw_sp_pgt_entry *
+mlxsw_sp_pgt_entry_get(struct mlxsw_sp_pgt *pgt, u16 mid, u16 smpe)
+{
+	struct mlxsw_sp_pgt_entry *pgt_entry;
+
+	pgt_entry = idr_find(&pgt->pgt_idr, mid);
+	if (pgt_entry)
+		return pgt_entry;
+
+	return mlxsw_sp_pgt_entry_create(pgt, mid, smpe);
+}
+
+static void mlxsw_sp_pgt_entry_put(struct mlxsw_sp_pgt *pgt, u16 mid)
+{
+	struct mlxsw_sp_pgt_entry *pgt_entry;
+
+	pgt_entry = idr_find(&pgt->pgt_idr, mid);
+	if (WARN_ON(!pgt_entry))
+		return;
+
+	if (list_empty(&pgt_entry->ports_list))
+		mlxsw_sp_pgt_entry_destroy(pgt, pgt_entry);
+}
+
+static void mlxsw_sp_pgt_smid2_port_set(char *smid2_pl, u16 local_port,
+					bool member)
+{
+	mlxsw_reg_smid2_port_set(smid2_pl, local_port, member);
+	mlxsw_reg_smid2_port_mask_set(smid2_pl, local_port, 1);
+}
+
+static int
+mlxsw_sp_pgt_entry_port_write(struct mlxsw_sp *mlxsw_sp,
+			      const struct mlxsw_sp_pgt_entry *pgt_entry,
+			      u16 local_port, bool member)
+{
+	bool smpe_index_valid;
+	char *smid2_pl;
+	u16 smpe;
+	int err;
+
+	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
+	if (!smid2_pl)
+		return -ENOMEM;
+
+	smpe_index_valid = mlxsw_sp->ubridge ? mlxsw_sp->pgt->smpe_index_valid :
+			   false;
+	smpe = mlxsw_sp->ubridge ? pgt_entry->smpe_index : 0;
+
+	mlxsw_reg_smid2_pack(smid2_pl, pgt_entry->index, 0, 0, smpe_index_valid,
+			     smpe);
+
+	mlxsw_sp_pgt_smid2_port_set(smid2_pl, local_port, member);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
+
+	kfree(smid2_pl);
+
+	return err;
+}
+
+static struct mlxsw_sp_pgt_entry_port *
+mlxsw_sp_pgt_entry_port_create(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_pgt_entry *pgt_entry,
+			       u16 local_port)
+{
+	struct mlxsw_sp_pgt_entry_port *pgt_entry_port;
+	int err;
+
+	pgt_entry_port = kzalloc(sizeof(*pgt_entry_port), GFP_KERNEL);
+	if (!pgt_entry_port)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlxsw_sp_pgt_entry_port_write(mlxsw_sp, pgt_entry, local_port,
+					    true);
+	if (err)
+		goto err_pgt_entry_port_write;
+
+	pgt_entry_port->local_port = local_port;
+	list_add(&pgt_entry_port->list, &pgt_entry->ports_list);
+
+	return pgt_entry_port;
+
+err_pgt_entry_port_write:
+	kfree(pgt_entry_port);
+	return ERR_PTR(err);
+}
+
+static void
+mlxsw_sp_pgt_entry_port_destroy(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_pgt_entry *pgt_entry,
+				struct mlxsw_sp_pgt_entry_port *pgt_entry_port)
+
+{
+	list_del(&pgt_entry_port->list);
+	mlxsw_sp_pgt_entry_port_write(mlxsw_sp, pgt_entry,
+				      pgt_entry_port->local_port, false);
+	kfree(pgt_entry_port);
+}
+
+static int mlxsw_sp_pgt_entry_port_add(struct mlxsw_sp *mlxsw_sp, u16 mid,
+				       u16 smpe, u16 local_port)
+{
+	struct mlxsw_sp_pgt_entry_port *pgt_entry_port;
+	struct mlxsw_sp_pgt_entry *pgt_entry;
+	int err;
+
+	mutex_lock(&mlxsw_sp->pgt->lock);
+
+	pgt_entry = mlxsw_sp_pgt_entry_get(mlxsw_sp->pgt, mid, smpe);
+	if (IS_ERR(pgt_entry)) {
+		err = PTR_ERR(pgt_entry);
+		goto err_pgt_entry_get;
+	}
+
+	pgt_entry_port = mlxsw_sp_pgt_entry_port_create(mlxsw_sp, pgt_entry,
+							local_port);
+	if (IS_ERR(pgt_entry_port)) {
+		err = PTR_ERR(pgt_entry_port);
+		goto err_pgt_entry_port_get;
+	}
+
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+	return 0;
+
+err_pgt_entry_port_get:
+	mlxsw_sp_pgt_entry_put(mlxsw_sp->pgt, mid);
+err_pgt_entry_get:
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+	return err;
+}
+
+static void mlxsw_sp_pgt_entry_port_del(struct mlxsw_sp *mlxsw_sp,
+					u16 mid, u16 smpe, u16 local_port)
+{
+	struct mlxsw_sp_pgt_entry_port *pgt_entry_port;
+	struct mlxsw_sp_pgt_entry *pgt_entry;
+
+	mutex_lock(&mlxsw_sp->pgt->lock);
+
+	pgt_entry = idr_find(&mlxsw_sp->pgt->pgt_idr, mid);
+	if (!pgt_entry)
+		goto out;
+
+	pgt_entry_port = mlxsw_sp_pgt_entry_port_lookup(pgt_entry, local_port);
+	if (!pgt_entry_port)
+		goto out;
+
+	mlxsw_sp_pgt_entry_port_destroy(mlxsw_sp, pgt_entry, pgt_entry_port);
+	mlxsw_sp_pgt_entry_put(mlxsw_sp->pgt, mid);
+
+out:
+	mutex_unlock(&mlxsw_sp->pgt->lock);
+}
+
+int mlxsw_sp_pgt_entry_port_set(struct mlxsw_sp *mlxsw_sp, u16 mid,
+				u16 smpe, u16 local_port, bool member)
+{
+	if (member)
+		return mlxsw_sp_pgt_entry_port_add(mlxsw_sp, mid, smpe,
+						   local_port);
+
+	mlxsw_sp_pgt_entry_port_del(mlxsw_sp, mid, smpe, local_port);
+	return 0;
+}
+
 int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_pgt *pgt;
-- 
2.36.1

