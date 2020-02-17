Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6C816146A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgBQOSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:18:51 -0500
Received: from mail-vi1eur05on2081.outbound.protection.outlook.com ([40.107.21.81]:19008
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726401AbgBQOSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 09:18:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWKMkao62Firvs0DnCt3afjer3ERSSsh8KPx5DJqNwlID9YIoiM81jgXxWPF+tp0wI5WnBuapvij9NCvI6kA99MbG1PHsWn5AyNPBTCREunDM99DMsOJeAIMbKbpt6fm8zXZuxRRcZQZekuFySnB9t3CSCLhC8cHYK1a2pNMQwX1eL+NMt42ZaqoKBFEmSH4GVLUhr6m8YGKGSBKhIu23Rt5ODnDil89E1Y1UbYVWGBwhq0gnXBDvX05wnP2B2lt01CvTbLzOUUbbWa2f5erzl89rGWZSeQ8zFXKmtV12GAK3RxsL7/6cEiC0ZOgc/KOv6+PF2zs4n1S6DSEIoFbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlDLHE5OC1QQQ0YyDE+gFVMTBN3MjcBU/ZWzyp6fqd4=;
 b=G8JGakGGUIioryNfjRotU806FZpWGfrJgXwcxk/6HqlPviGFJq1NUXfs0KkbWpmtDl5rwRpPeX5RHiglyHe+D/XjCtaTvaxBpvs9clTcTZpgiojxucoq8JiG9KERNtIoLS+LG4xS5uHcc06exxYiaVtZxMHjiSKjunyK94aKq8VTv2VD9YKVuFqL1/CFcEqwo2NlGz8ak17l4GnxOjzp8YuCtR+f+Efdsz+K66eFm8HmR0Wn9cIexoIzFZ8whK+/AHka0hMG7CUFzHVOLTuWVUw1Iddad3bdmI1+RVMmQTVHTUbBBQY4mASdbBfs3l6PYMIrlQIc5L3LPjQ7BL0Xow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlDLHE5OC1QQQ0YyDE+gFVMTBN3MjcBU/ZWzyp6fqd4=;
 b=tP0Go7kXQ5HEOmNdaZFYW5LV2yz1jwnw+jfLXsN7cqQIvzZddNeWf/sv+ykFQ5qz7TNWG68GZFqDz4oYgIn3byeoPQVKf50nCvgnRBusSyxjpbA9rUd4Wci6Kzmph0VlWOVhhVCHVDWiNWiaRJku0rKWaD3AlPDd5zOx21w6ibI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (52.134.107.149) by
 DB7PR05MB4890.eurprd05.prod.outlook.com (20.176.237.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.29; Mon, 17 Feb 2020 14:18:45 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::1498:7745:72cb:c384]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::1498:7745:72cb:c384%7]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 14:18:45 +0000
Subject: Re: [PATCH net-next v4] net/mlx5e: Don't allow forwarding between
 uplink
To:     xiangxia.m.yue@gmail.com, gerlitz.or@gmail.com,
        saeedm@dev.mellanox.co.il
Cc:     netdev@vger.kernel.org
References: <20200217140850.4509-1-xiangxia.m.yue@gmail.com>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <21d44104-5523-f75b-c014-95cf2adb4e45@mellanox.com>
Date:   Mon, 17 Feb 2020 16:18:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200217140850.4509-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0044.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::21) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
Received: from [192.168.1.12] (176.231.50.124) by AM0PR02CA0044.eurprd02.prod.outlook.com (2603:10a6:208:d2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Mon, 17 Feb 2020 14:18:44 +0000
X-Originating-IP: [176.231.50.124]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92e99f4d-7dff-4c6f-3ec9-08d7b3b44c5c
X-MS-TrafficTypeDiagnostic: DB7PR05MB4890:|DB7PR05MB4890:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB489037D1849DDACAEA5F3A9EB5160@DB7PR05MB4890.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(189003)(199004)(6486002)(16576012)(31696002)(52116002)(86362001)(478600001)(31686004)(5660300002)(53546011)(16526019)(186003)(316002)(956004)(6666004)(66946007)(2616005)(81166006)(81156014)(66556008)(8936002)(66476007)(8676002)(26005)(2906002)(4326008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4890;H:DB7PR05MB4156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VfufFHcvCHmD1uRGxvW2LjZ6xafAEM6TDbY6E4r6qABtADBlQsP2rH8MwygSvOuRxQlpRWQBmEEJiPtTshbMckEOhEpOUR9OLZ+pUHaHm3l/8aMGP5ZCcNv2PZZ02eoRUQ3p+sTNE5JCpeCDB1Jm+kQU+zdhddSCZt42rRLVbqPXBw5jRXWfEEbVO/3X10FqdXlkZZVT9CPHj8+8WOZSwv0g67KueqGrFUjy/pz1Cmm3W6pty1KLzTYVI1QoxbUgiuPSshhZazKsccaTPIKPGPi3CI7doLkg+xVyc5hL1BBiwt3iIcVP+b8lwu6anttDeV84rdZnPupbqpHHZqzjuF8sgsRmFXYyf4aODYhkwxE6bZpEOD3FNy9AG0Qt4MqB7BS9SZzDX+8MncS/6uFhS0MVAXgwNfs2PYpLlSjJPsziJ9nAF2VbCfnjHJ77gxiY
X-MS-Exchange-AntiSpam-MessageData: Zc/u+DU3H7VJv636VDfi/2JA92yWu/MnefdBmTuTXudHy8ZpzycMe0k6sUfpjL27+QUEzeY3MCMYwhrGKoT0kXtr9q3Uklm74Gp4VAEKXiop8lNOkAGt3m2SGA8u6x1kpKKVmN/36i5ne5aABTWVTA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e99f4d-7dff-4c6f-3ec9-08d7b3b44c5c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 14:18:45.4282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJddg1wa+gbmY5vAApfrby0z1+gu75AUlUTH1HXy+4pBvUhA8vwhHMRxprOcZKi5pRjysV4jyHSstNIifSbv2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4890
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-02-17 4:08 PM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> We can install forwarding packets rule between uplink
> in switchdev mode, as show below. But the hardware does
> not do that as expected (mlnx_perf -i $PF1, we can't get
> the counter of the PF1). By the way, if we add the uplink
> PF0, PF1 to Open vSwitch and enable hw-offload, the rules
> can be offloaded but not work fine too. This patch add a
> check and if so return -EOPNOTSUPP.
> 
> $ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
>     flower skip_sw action mirred egress redirect dev $PF1
> 
> $ tc -d -s filter show dev $PF0 ingress
>     skip_sw
>     in_hw in_hw_count 1
>     action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>     ...
>     Sent hardware 408954 bytes 4173 pkt
>     ...
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 17 +++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 7b48cca..18d3dcd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1464,6 +1464,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
>  	.ndo_set_features        = mlx5e_set_features,
>  };
>  
> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
> +{
> +	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
> +}
> +
>  bool mlx5e_eswitch_rep(struct net_device *netdev)
>  {
>  	if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> index 3f756d5..8336301 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> @@ -200,6 +200,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
>  void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
>  
>  bool mlx5e_eswitch_rep(struct net_device *netdev);
> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
>  
>  #else /* CONFIG_MLX5_ESWITCH */
>  static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 74091f7..290cdf3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3405,6 +3405,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>  				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>  				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
>  				struct net_device *uplink_upper;
> +				struct mlx5e_rep_priv *rep_priv;
>  
>  				if (is_duplicated_output_device(priv->netdev,
>  								out_dev,
> @@ -3440,6 +3441,22 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>  						return err;
>  				}
>  
> +				/* Don't allow forwarding between uplink.
> +				 *
> +				 * Input vport was stored esw_attr->in_rep.
> +				 * In LAG case, *priv* is the private data of
> +				 * uplink which may be not the input vport.
> +				 */
> +				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
> +				if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
> +				    mlx5e_eswitch_uplink_rep(out_dev)) {
> +					NL_SET_ERR_MSG_MOD(extack,
> +							   "devices are both uplink, can't offload forwarding");
> +					pr_err("devices %s %s are both uplink, can't offload forwarding\n",
> +					       priv->netdev->name, out_dev->name);
> +					return -EOPNOTSUPP;
> +				}
> +
>  				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
>  					NL_SET_ERR_MSG_MOD(extack,
>  							   "devices are not on same switch HW, can't offload forwarding");
> 

thanks

Reviewed-by: Roi Dayan <roid@mellanox.com>
