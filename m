Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B938699B37
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjBPRY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBPRYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:24:25 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FDF4CCB6
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:24:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxONNovVD5Pb/S5y5NPiWWEEagJ+PjCeFJnTt031q++nfkexVWz/h3VWYwhk4HgdQ98aaEkd7JKNTQzgOp2rN5A6eOOG4GuudpBb6b3PiAdAPXkhazYEdUc7VGXpPZTVavbAD43DZ6zz6se9pElabTGG/pfMQyCEjvllA390wL51W71xrUErjF/K4Tkg1NzKh23T+6eWTd32JG9psGqj0N1NG1scLcSIiXObVqubm9GjszZCPpWqaDNGGMtO2QQpmWocEL1Mjy5l43WH4dKgt+R1PDYE2mzd29Fouf5F0P0C1GspWs4YvChtNl94G3MjIxySikCtJC3JjVlA14kDHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uv0Qj9QC+0ZrTq7exBAIZiw7HdyF5oIcjajAgBrtJdo=;
 b=h3ndT/561Ecm6mD0oOdhCW01FsfM0CPISILjwTq5VA5d1ow4MMloS5xo3bGdGRiQbkE8WgdL9c4QXLFJ4Z+ckwhEpLJklKW+UQca2ElEkapOUDwNXRFrHwWO7Owjza6gNJxn3zLP9w6zNBKezkzqMljGEWcXwuu7ekP0cwuHMSO1ewHa+ML63sVSKmRJRXPcPZD9ya55r4LS0DZ2x9kgOYkj1beWj6Cyidrg/+u0FYjOPgAxZ0XtOM17zQC/GxysNCxr0TYgZB1AGK+WerCHe5+okZ/Aufbw8kPqSstDucHWc8pbmKhjzkbTv9Wttu5uAn8CbBvYOn0ROkWsZoLlgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv0Qj9QC+0ZrTq7exBAIZiw7HdyF5oIcjajAgBrtJdo=;
 b=uDSZ0PeFEXgoOx3UFQK+D8HsVHrR205IDlkFsKkg6gA5cjfNj2nLFQCkUkbpC5Ozkg1fka06+EOlfw8eD8veb8WQlaCrPijBJveK3YiVHeKulrgeiSG1jTCbX83zDwnugFowTqGePNh0ke+gID4GBWq5u8nXgsQEuutW3mLqxrKE5OQUFau7/gHsJdy2KwNOqyzu1HbdQCmZjOv5EXPuMmkXUcuB7ryiMBn6O3rNcMttqQg6gHDYN7c7+IdnHS5D3Pw7etNfCMwBbY7SjRvjqiSvtLO8lLiLJ3fWBaWHCjrXVAgifWndecHOijDNUa3ZG6QpiFcJvgWG3pFqljm76w==
Received: from DS7PR03CA0010.namprd03.prod.outlook.com (2603:10b6:5:3b8::15)
 by BY5PR12MB4036.namprd12.prod.outlook.com (2603:10b6:a03:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 17:24:21 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::9) by DS7PR03CA0010.outlook.office365.com
 (2603:10b6:5:3b8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 17:24:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 17:24:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 09:25:06 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 09:24:09 -0800
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-6-saeed@kernel.org> <Y+5Q/aWKY+HO83A1@boxer>
User-agent: mu4e 1.6.6; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [net-next 5/9] net/mlx5e: Implement CT entry update
Date:   Thu, 16 Feb 2023 19:15:13 +0200
In-Reply-To: <Y+5Q/aWKY+HO83A1@boxer>
Message-ID: <87r0upwmkp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT006:EE_|BY5PR12MB4036:EE_
X-MS-Office365-Filtering-Correlation-Id: baf46aeb-01f5-414e-66ef-08db1042a43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t7OxTt3tk4x2b7hyAotEf4XI4PkZe33JHTe3s6okxxLoPTXSyZPe4MHPpuMR97rw3o4ySOth5j/lvHZsIe5lIrPMFaDKvjDj7uLl9oBdZ3jB6aXrV2hBopZunpHfMM5E/hMC0qMX79Raq4YkTYTj0Ov7Bbz4AqwFjFHGd+EPY/ncKbKp5ugS+qIK7MRQohUoDiY+628WDLRjoLEk0xTjriwPVh/pnbdF+OBCIrZMdIEcI3jcndpYYext00qkXTZd1nlzDmFStH194TU9fwI1eFSf3i741u3LJFrpLm/9BlGm1IQ37Sd/ImcyxJy6DMbJC3GE2S9lInHg56QdhbrgBuF+EBEI7XAVz9w6IBvsuvTTh5VI6gG5WS2XXTs5TQAuLIfW1ZYPHlwbNn+dF4j5by3gl/9M1jc1I5kW6eb6pojRJFqXa1b5MK5CZwueM56NY8VBcn7AHqkAHJYSOkdg48mKDOPKAJBAPsA3lw7p1IkdbEa8BTTYmNqeimtkP2lWyJxYF48SHSPYBYX13ARm+FhP8vSODZMVeswdKzubJ3IM1rrGJKyZDxV6oVRdy4WTisGAGDEx1QSgWQa2qw6NEQYjMWxMOpOIJDc3h1+ckRgrH63pU2eqkuDiv8Tl3hZ/rIoFI4RP/+8u4/JBI4i6QMkwuGQfwZrFvBb/7sIXKRuBGLXh9W+o0XXv3Xvx4cnpNJoYVXYFHHHYX1pqVv37ZA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(66899018)(82740400003)(2906002)(40480700001)(82310400005)(36756003)(5660300002)(40460700003)(15650500001)(316002)(86362001)(36860700001)(41300700001)(8936002)(4326008)(356005)(8676002)(6916009)(70586007)(70206006)(7636003)(54906003)(83380400001)(336012)(426003)(47076005)(186003)(26005)(2616005)(16526019)(7696005)(6666004)(107886003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 17:24:21.0737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baf46aeb-01f5-414e-66ef-08db1042a43b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 16 Feb 2023 at 16:51, Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> On Wed, Feb 15, 2023 at 04:09:14PM -0800, Saeed Mahameed wrote:
>> From: Vlad Buslov <vladbu@nvidia.com>
>> 
>> With support for UDP NEW offload the flow_table may now send updates for
>> existing flows. Support properly replacing existing entries by updating
>> flow restore_cookie and replacing the rule with new one with the same match
>> but new mod_hdr action that sets updated ctinfo.
>> 
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>  .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 118 +++++++++++++++++-
>>  1 file changed, 117 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> index 193562c14c44..76e86f83b6ac 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
>> @@ -871,6 +871,68 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
>>  	return err;
>>  }
>>  
>> +static int
>> +mlx5_tc_ct_entry_replace_rule(struct mlx5_tc_ct_priv *ct_priv,
>> +			      struct flow_rule *flow_rule,
>> +			      struct mlx5_ct_entry *entry,
>> +			      bool nat, u8 zone_restore_id)
>> +{
>> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
>> +	struct mlx5_flow_attr *attr = zone_rule->attr, *old_attr;
>> +	struct mlx5e_mod_hdr_handle *mh;
>> +	struct mlx5_ct_fs_rule *rule;
>> +	struct mlx5_flow_spec *spec;
>> +	int err;
>> +
>> +	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
>> +	if (!spec)
>> +		return -ENOMEM;
>> +
>> +	old_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
>> +	if (!attr) {
>
> when can attr == NULL? maybe check it in the first place before allocing
> spec above?

Should verify 'old_attr', not 'attr'. Thanks for catching this!

>
>> +		err = -ENOMEM;
>> +		goto err_attr;
>> +	}
>> +	*old_attr = *attr;
>> +
>> +	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule, &mh, zone_restore_id,
>> +					      nat, mlx5_tc_ct_entry_has_nat(entry));
>> +	if (err) {
>> +		ct_dbg("Failed to create ct entry mod hdr");
>> +		goto err_mod_hdr;
>> +	}
>> +
>> +	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
>> +	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
>> +
>> +	rule = ct_priv->fs_ops->ct_rule_add(ct_priv->fs, spec, attr, flow_rule);
>> +	if (IS_ERR(rule)) {
>> +		err = PTR_ERR(rule);
>> +		ct_dbg("Failed to add replacement ct entry rule, nat: %d", nat);
>> +		goto err_rule;
>> +	}
>> +
>> +	ct_priv->fs_ops->ct_rule_del(ct_priv->fs, zone_rule->rule);
>> +	zone_rule->rule = rule;
>> +	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, old_attr, zone_rule->mh);
>> +	zone_rule->mh = mh;
>> +
>> +	kfree(old_attr);
>> +	kvfree(spec);
>
> not a big deal but you could make a common goto below with a different
> name

You mean jump from here to the middle of the error handling code below
in order not to duplicate these two calls to *free()? Honestly, I would
much rather prefer _not_ to do that since goto is necessary evil for
error handling in C but I don't believe we should handle any common
non-error code paths with it and it is not typically done in mlx5.

>
>> +	ct_dbg("Replaced ct entry rule in zone %d", entry->tuple.zone);
>> +
>> +	return 0;
>> +
>> +err_rule:
>> +	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, mh);
>> +	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
>> +err_mod_hdr:
>> +	kfree(old_attr);
>> +err_attr:
>> +	kvfree(spec);
>> +	return err;
>> +}
>> +
>>  static bool
>>  mlx5_tc_ct_entry_valid(struct mlx5_ct_entry *entry)
>>  {
>> @@ -1065,6 +1127,52 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
>>  	return err;
>>  }
>>  
>> +static int
>> +mlx5_tc_ct_entry_replace_rules(struct mlx5_tc_ct_priv *ct_priv,
>> +			       struct flow_rule *flow_rule,
>> +			       struct mlx5_ct_entry *entry,
>> +			       u8 zone_restore_id)
>> +{
>> +	int err;
>> +
>> +	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, false,
>
> would it make sense to replace the bool nat in here with some kind of
> enum?

It is either nat rule or non-nat rule. Why would we invent an enum here?
Moreover, boolean 'nat' is already used in multiple places in this file,
so this patch just re-uses existing convention.

>
>> +					    zone_restore_id);
>> +	if (err)
>> +		return err;
>> +
>> +	err = mlx5_tc_ct_entry_replace_rule(ct_priv, flow_rule, entry, true,
>> +					    zone_restore_id);
>> +	if (err)
>> +		mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
>> +	return err;
>> +}
>> +
>> +static int
>> +mlx5_tc_ct_block_flow_offload_replace(struct mlx5_ct_ft *ft, struct flow_rule *flow_rule,
>> +				      struct mlx5_ct_entry *entry, unsigned long cookie)
>> +{
>> +	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
>> +	int err;
>> +
>> +	err = mlx5_tc_ct_entry_replace_rules(ct_priv, flow_rule, entry, ft->zone_restore_id);
>> +	if (!err)
>> +		return 0;
>> +
>> +	/* If failed to update the entry, then look it up again under ht_lock
>> +	 * protection and properly delete it.
>> +	 */
>> +	spin_lock_bh(&ct_priv->ht_lock);
>> +	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
>> +	if (entry) {
>> +		rhashtable_remove_fast(&ft->ct_entries_ht, &entry->node, cts_ht_params);
>> +		spin_unlock_bh(&ct_priv->ht_lock);
>> +		mlx5_tc_ct_entry_put(entry);
>> +	} else {
>> +		spin_unlock_bh(&ct_priv->ht_lock);
>> +	}
>> +	return err;
>> +}
>> +
>>  static int
>>  mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
>>  				  struct flow_cls_offload *flow)
>> @@ -1087,9 +1195,17 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
>>  	spin_lock_bh(&ct_priv->ht_lock);
>>  	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
>>  	if (entry && refcount_inc_not_zero(&entry->refcnt)) {
>> +		if (entry->restore_cookie == meta_action->ct_metadata.cookie) {
>> +			spin_unlock_bh(&ct_priv->ht_lock);
>> +			mlx5_tc_ct_entry_put(entry);
>> +			return -EEXIST;
>> +		}
>> +		entry->restore_cookie = meta_action->ct_metadata.cookie;
>>  		spin_unlock_bh(&ct_priv->ht_lock);
>> +
>> +		err = mlx5_tc_ct_block_flow_offload_replace(ft, flow_rule, entry, cookie);
>>  		mlx5_tc_ct_entry_put(entry);
>
> in case of err != 0, haven't you already put the entry inside
> mlx5_tc_ct_block_flow_offload_replace() ?

No. Here we release the reference that was obtained 10 lines up and
mlx5_tc_ct_block_flow_offload_replace() releases the reference held by
ct_entries_ht table.

>
>> -		return -EEXIST;
>> +		return err;
>>  	}
>>  	spin_unlock_bh(&ct_priv->ht_lock);
>>  
>> -- 
>> 2.39.1
>> 

