Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D011E9630
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgEaICA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:02:00 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:8770
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbgEaIB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 04:01:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfJxtshMi6ue4yWoH52Zzj/giI5dfj1uaA0fI1qzuPEm9Md2nU+t3l6OeycXftHTOQu+gZk6v9KxnltKmaELkBlrlMYaoOtHDpRAw3r2MV1h4Hzr/GyOySDBrI1dqNpdX91oo7gEMGsA3CJ7OeGl74HjVXBVFnzXqN2mtLU+uhOy8Sn7A6XnY3RiAYkZSkDr87VPkk2SKkjPeRKz8KfEoxfacWIcnLRxzE+V4BvgBG1Ua8U5tql7lo64mQRl2WJkoht32kO/UpeL8sxeBrzkG+zcg6srI0964DtaOugj+qqfaG6McXUtkqWDhr0xfnhcsh6vfZ5FFajef1ZD/id4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdBJoT0A91WdFjIguW6BqdH5Yt9qkEc1+s8ngIjRGHY=;
 b=Lb2aVsMx1/uy8PiQE/Q8d+eNc59bzUHvVij/TGyjLGigEdefVtuC+J6eiARReF1DbMURcHt3m9IVBlPrYwNqZO1kJ8ApyzpfZG+B9zAjRdLfiyCYpjqRu3PYBJbG8iudy3DFndggXLaDRKbOuN0EiK2DQiuCZTN47yxM0iS9d4Zj6FbMnFY/6AKgcVU+M7aJglZf6kZVB6I5JHNPJPEiPZnk/kFzQS6/qgifV7K/yN8TXvV5UKXTCUCdVIU8Xgz+WA713Qhg1zHdFaagRB+xSPwA1Ygp7eAgkyyH8wmkWnPgfPRa2LPTPsoISv9VQf33qHZX2sk+PvKFqpUB6hI9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdBJoT0A91WdFjIguW6BqdH5Yt9qkEc1+s8ngIjRGHY=;
 b=sWCbPIfwdbyomsVlgqT2es0GLFUOcOZtQ8hX+7q7nxzeqolJsVi3L1oXHzsiM65vej7iGAya38JHq6XAOcVBIrl4XpnHzsG1OLxw4nvslqKtIHp34slHmFOfUyTo61xgDZ0Wo7IdVTxq2lafGl+jXSR55yF2mowhku8rRPFxv3I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3924.eurprd05.prod.outlook.com
 (2603:10a6:208:20::30) by AM0PR0502MB3684.eurprd05.prod.outlook.com
 (2603:10a6:208:1d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Sun, 31 May
 2020 08:01:55 +0000
Received: from AM0PR0502MB3924.eurprd05.prod.outlook.com
 ([fe80::cd67:f25f:c3aa:f459]) by AM0PR0502MB3924.eurprd05.prod.outlook.com
 ([fe80::cd67:f25f:c3aa:f459%2]) with mapi id 15.20.3045.018; Sun, 31 May 2020
 08:01:55 +0000
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add ct_metadata.nat support in ct
 offload
To:     wenxu@ucloud.cn, paulb@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
References: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
 <1590650155-4403-3-git-send-email-wenxu@ucloud.cn>
From:   Oz Shlomo <ozsh@mellanox.com>
Message-ID: <91589d29-42cb-7384-3ccc-58af4350a984@mellanox.com>
Date:   Sun, 31 May 2020 11:01:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <1590650155-4403-3-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To AM0PR0502MB3924.eurprd05.prod.outlook.com (2603:10a6:208:20::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.14.169] (79.180.224.244) by FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sun, 31 May 2020 08:01:54 +0000
X-Originating-IP: [79.180.224.244]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26ee4ec3-2c20-41e5-9bfe-08d80538e29a
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3684:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3684A8C73CE9C75E360F65AFAB8D0@AM0PR0502MB3684.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-Forefront-PRVS: 0420213CCD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+hI+49NWIjn+z/PeS3RWXfmKo3FY294J2J5WaNkU66zm/bh5J1ecEDawkz7v1GrAEKjcAqwUWF+qAGH/Mk2x1DefzXEs6ih4pmxJc8e3Kf/S4XBQQ4dd1EznCsbYDC3YGzdXBBilWaLulB779YmuktU2EZOM8MZS8a5tJZwlGc2BYkcdPvJ/65OukQb0UL1g4uAiKHlAo/M1nUNEFvmEnwiTSOzL+Yv8Ki2d2WixKTH8AJHQhXqzU48EiySsUH7fTT16dy8u8Plsr1K2fsm1K0hwvE5g8I4aIALk2m+maQBO3AHiBBX0FFOKLHyijK5w+dGw3Bshn/i7xbmq3vrfEaB2oO+VulVaL3oE7BVZAiJ+dD/Kw3ASE1O/VugmD/M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3924.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(31686004)(86362001)(36756003)(478600001)(6486002)(8936002)(66476007)(66556008)(66946007)(16576012)(316002)(31696002)(8676002)(2906002)(16526019)(4326008)(26005)(186003)(6636002)(5660300002)(83380400001)(52116002)(53546011)(2616005)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W2ppSR92uINWBluPiIJ8No0QOTwSfHMcNDSNnGLN2Ru/jnf1Y+/wtg6WO4sulu5FHeaj8HPGv4FDXdeUMtmUPwQuAO7u2B8Uunyu81Wk1KwDJ2W3628m5Af2jhdVShQUa1Hc6TgRfivVMiWF/wsD2N9Qzai3H+zNf2W9UBCtwAVaOSERt5SMzB1YPtUPlmh3kJ2hfV0M6blxHuIzTp1ChvvbjVFcrwOBFETCWcC2wM049/Cxpos208KuSuZyXyuZBq5M+As5G2PzDoTFw15gh+aQoUa3WGFpU3AO/e3K06mvz9AXDNJVV3ChgOtA+s3XvCc1KFYfC8M3b52m6pN/PHL0tNp3RSBV+9vmWGflF9eNo39K6djLk9W7IAl9i7NLKFr5FgOA7+iX0S88MDfh6lR4ZcabhaTqcD3XiOz8twQbTaThDPe7dYj/H6vDUrbsAQf9RRzwSka8L3ic9HCfpWiIgvkOU413B4lcOn2TPKvdD65MwCqjw9QtWjQHuP2O
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ee4ec3-2c20-41e5-9bfe-08d80538e29a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2020 08:01:55.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2F7QdRwZR3nVKh9Af7rRdAGaoULAiNIwSnLI4TZg1I91AHIrBsWL5Mi5uNvBeeEam9N9V67UIU8vQhpks9CuuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wenxu,

On 5/28/2020 10:15 AM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the ct offload all the conntrack entry offload  rules
> will be add to both ct ft and ct_nat ft twice.
> It is not makesense. The ct_metadat.nat will tell driver

Adding the connection to both tables is required because the user may
perform a CT action without NAT even though a NAT entry was allocated
when the connection was committed.

> the rule should add to ct or ct_nat flow table
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 34 ++++++++--------------
>   1 file changed, 12 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 995b2ef..02ecd24 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -88,7 +88,7 @@ struct mlx5_ct_entry {
>   	struct mlx5_fc *counter;
>   	unsigned long cookie;
>   	unsigned long restore_cookie;
> -	struct mlx5_ct_zone_rule zone_rules[2];
> +	struct mlx5_ct_zone_rule zone_rule;
>   };
>   
>   static const struct rhashtable_params cts_ht_params = {
> @@ -238,10 +238,9 @@ struct mlx5_ct_entry {
>   
>   static void
>   mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
> -			  struct mlx5_ct_entry *entry,
> -			  bool nat)
> +			  struct mlx5_ct_entry *entry)
>   {
> -	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
>   	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
>   	struct mlx5_eswitch *esw = ct_priv->esw;
>   
> @@ -256,8 +255,7 @@ struct mlx5_ct_entry {
>   mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
>   			   struct mlx5_ct_entry *entry)
>   {
> -	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
> -	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
> +	mlx5_tc_ct_entry_del_rule(ct_priv, entry);
>   
>   	mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
>   }
> @@ -493,7 +491,7 @@ struct mlx5_ct_entry {
>   			  struct mlx5_ct_entry *entry,
>   			  bool nat)
>   {
> -	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
> +	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
>   	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
>   	struct mlx5_eswitch *esw = ct_priv->esw;
>   	struct mlx5_flow_spec *spec = NULL;
> @@ -562,7 +560,8 @@ struct mlx5_ct_entry {
>   static int
>   mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
>   			   struct flow_rule *flow_rule,
> -			   struct mlx5_ct_entry *entry)
> +			   struct mlx5_ct_entry *entry,
> +			   bool nat)
>   {
>   	struct mlx5_eswitch *esw = ct_priv->esw;
>   	int err;
> @@ -574,20 +573,10 @@ struct mlx5_ct_entry {
>   		return err;
>   	}
>   
> -	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
> +	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, nat);
>   	if (err)
> -		goto err_orig;
> -
> -	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
> -	if (err)
> -		goto err_nat;
> -
> -	return 0;
> +		mlx5_fc_destroy(esw->dev, entry->counter);
>   
> -err_nat:
> -	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
> -err_orig:
> -	mlx5_fc_destroy(esw->dev, entry->counter);
>   	return err;
>   }
>   
> @@ -619,7 +608,8 @@ struct mlx5_ct_entry {
>   	entry->cookie = flow->cookie;
>   	entry->restore_cookie = meta_action->ct_metadata.cookie;
>   
> -	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
> +	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry,
> +					 meta_action->ct_metadata.nat);
>   	if (err)
>   		goto err_rules;
>   
> @@ -1620,7 +1610,7 @@ struct mlx5_flow_handle *
>   		return false;
>   
>   	entry = container_of(zone_rule, struct mlx5_ct_entry,
> -			     zone_rules[zone_rule->nat]);
> +			     zone_rule);
>   	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
>   
>   	return true;
> 
