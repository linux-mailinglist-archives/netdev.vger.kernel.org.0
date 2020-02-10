Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D161570A7
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgBJIPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:15:10 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:6105
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbgBJIPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:15:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9FuXCVESn0Wq7zAzWrS2/1mBLpJmH3H7yKKKAJz4/UU/2BIHOPaHezD7/ZnuI87ed5TW8IyLFto1i8nb5JkLtlJg27RQCRUaNRHLFNCdPb+A1GwtGf/h75gj4ohRv+Mz6yiLYhPLxInikx3HgSLTT/o6x5uUFmLwQNjL14es4FdXjReByAYJSQysLFA69+VuqoPv3rSApG2UeOY9aiqUzKpTy1NLfBdiupmBleVzhQxYILr2BWGmGmdlAd7+FMYvDk5a3y5Kth8Gdp8a/ZZb8NkwoQG/AYWfKN9u81ILt/IvQ6Pxg6ZdHoieNp8fsExalilXwRN84iZBIRvDIkElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLBGPZM9k4cxOfUvDJ2WTpUbTKXL7ASki5o+hyIlF64=;
 b=Xlx5a8DaPD9vGhjzmenLoxIGLAXbxNZenzGjaHGnGsnBcHDGSQmSErkvm5XyuGlAWY5XmPp27Mu+XlTK9ES8XNKPS0RlIW7qDi0XZGOd1sVsh2fUmLdUknPe6DMBgxzxrJeZBMfwW8Ox/lcIpR4bl+TRKrh2DH3xoKQxSPLvJBibptWYw+DpBQOfsdMaYPgqNjkpGdMtBzTvDzLIV3atrc1cqDpbLIkXoHfCppYG2N85W4/Rcd9Wl4ecoLC+IsdHCj3z5xhD3Cw+MNgMiGtXCEpQw2RAcMhLWsqiOmDUXiHzK8+DEAwUKzKtKPDHizu+z+uIvNzwHw1/FFK6Q34xKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLBGPZM9k4cxOfUvDJ2WTpUbTKXL7ASki5o+hyIlF64=;
 b=YjFtSW+sB3If8PqUt/GxP/nl0eISvrF4pGZSOLUIbXneOJP2fRCzI5XZ1NqpNi1U9ttVb3TZfx/EpY3V8p/Bci38U6TmQhGBPNButb3AN082ilKlSsIbJjjSirC8a8MuEtS6Sa1cGrsepio1m4cXBm1cIdxHUyZYFSOMuuiwPEs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (52.134.107.149) by
 DB7PR05MB5723.eurprd05.prod.outlook.com (20.178.85.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Mon, 10 Feb 2020 08:15:06 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::1498:7745:72cb:c384]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::1498:7745:72cb:c384%7]) with mapi id 15.20.2707.028; Mon, 10 Feb 2020
 08:15:06 +0000
Subject: Re: [PATCH v3] net/mlx5e: Don't allow forwarding between uplink
From:   Roi Dayan <roid@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, xiangxia.m.yue@gmail.com
Cc:     gerlitz.or@gmail.com, saeedm@dev.mellanox.co.il,
        netdev@vger.kernel.org
References: <1579691703-56363-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20200122133354.GB2196@nanopsycho>
 <d5d9c2d1-1201-c1e7-903a-a27c37e9e1e8@mellanox.com>
Message-ID: <75306dcb-27e3-d80c-806e-d4a86558ebb4@mellanox.com>
Date:   Mon, 10 Feb 2020 10:15:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <d5d9c2d1-1201-c1e7-903a-a27c37e9e1e8@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::11) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
Received: from [10.223.0.122] (193.47.165.251) by ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Mon, 10 Feb 2020 08:15:05 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bad8728b-074c-466a-aa2b-08d7ae015651
X-MS-TrafficTypeDiagnostic: DB7PR05MB5723:|DB7PR05MB5723:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB57233947C2F28FD4E0A8D0B4B5190@DB7PR05MB5723.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 03094A4065
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(189003)(199004)(316002)(956004)(66476007)(2616005)(66946007)(66556008)(31696002)(478600001)(16576012)(4326008)(31686004)(6666004)(86362001)(5660300002)(81156014)(6486002)(186003)(81166006)(8936002)(8676002)(53546011)(2906002)(36756003)(26005)(52116002)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5723;H:DB7PR05MB4156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pk0WAQbF+Oa8eedaDLV+o6ZCOOZ5IfsX2LDshm1GGU9nwr33HXmGkcjzTmjkwImSpfwUxNfHwDp05Z8BkrcMDjWFP3oIMqhcv5AFxvRLa4H5gltfDsM8CfDhE8OQN/gPSeayhhvripiM/d/jPjfJ3/umw6zEWbLFA3te4hjWLN0Mml8kin0oRz0+f+DkvOcYdZNxkga+ugZiDu1Zfw02/afGqxcumBsp4qoSIlNy0Ou4M/XnW3HjNq+0XWBMqoSjDPHIHVVIVmUszAY8iWx0L/fEEoJeYIw2EtdxlJ5c12xXkLtbCZEUzA+FznK+21Db9zNmwod9sI6joXnOGRZZNU+EtaBFOTdDQZlkNwR2fDGeiR1v8qxl/2x/4VDbXRoqmRTOYIBbRMtrKohcPEez+mQQo01iZ38BXIFysZhVOewnCM5iKmxkHc9zSY1fLVsV
X-MS-Exchange-AntiSpam-MessageData: nOBDErNGRLx6XpOHmVDH9kKqvVCj464e22ThOJGKCfG372gfzt/eq92x5YWrdIGYCn6ebcylSCTjLiNVDg0+XN9Wh65xB8SGrRdtvOHPtUuK6jW06ngy67tIHHcyTFxjgmzeL17cqeNPxQhmPGAr1g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad8728b-074c-466a-aa2b-08d7ae015651
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2020 08:15:06.6615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: td9Y3faTYIO98BPJIAcKLiyuOKo6Eizv2ZjkNk8S514V7B+/zus5HS32mScv7jwGtLNFaWvQwJ9bDl0viw009g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5723
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-01-29 1:42 PM, Roi Dayan wrote:
> 
> 
> On 2020-01-22 3:33 PM, Jiri Pirko wrote:
>> Wed, Jan 22, 2020 at 12:15:03PM CET, xiangxia.m.yue@gmail.com wrote:
>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>>
>>> We can install forwarding packets rule between uplink
>>> in switchdev mode, as show below. But the hardware does
>>> not do that as expected (mlnx_perf -i $PF1, we can't get
>>> the counter of the PF1). By the way, if we add the uplink
>>> PF0, PF1 to Open vSwitch and enable hw-offload, the rules
>>> can be offloaded but not work fine too. This patch add a
>>> check and if so return -EOPNOTSUPP.
>>>
>>> $ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
>>>    flower skip_sw action mirred egress redirect dev $PF1
>>>
>>> $ tc -d -s filter show dev $PF0 ingress
>>>    skip_sw
>>>    in_hw in_hw_count 1
>>>    action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>>>    ...
>>>    Sent hardware 408954 bytes 4173 pkt
>>>    ...
>>>
>>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>> ---
>>> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
>>> drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
>>> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 19 +++++++++++++++++++
>>> 3 files changed, 25 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>>> index f175cb2..ac2a035 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>>> @@ -1434,6 +1434,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
>>> 	.ndo_set_features        = mlx5e_set_features,
>>> };
>>>
>>> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
>>> +{
>>> +	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
>>> +}
>>> +
>>> bool mlx5e_eswitch_rep(struct net_device *netdev)
>>> {
>>> 	if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
>>> index 31f83c8..5211819 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
>>> @@ -199,6 +199,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
>>> void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
>>>
>>> bool mlx5e_eswitch_rep(struct net_device *netdev);
>>> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
>>>
>>> #else /* CONFIG_MLX5_ESWITCH */
>>> static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> index db614bd..35f68e4 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> @@ -3361,6 +3361,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>>> 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
>>> 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
>>> 				struct net_device *uplink_upper;
>>> +				struct mlx5e_rep_priv *rep_priv;
>>>
>>> 				if (is_duplicated_output_device(priv->netdev,
>>> 								out_dev,
>>> @@ -3396,6 +3397,24 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>>> 						return err;
>>> 				}
>>>
>>> +				/* Don't allow forwarding between uplink.
>>> +				 *
>>> +				 * Input vport was stored esw_attr->in_rep.
>>> +				 * In LAG case, *priv* is the private data of
>>> +				 * uplink which may be not the input vport.
>>> +				 */
>>> +				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
>>> +				if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
>>> +				    mlx5e_eswitch_uplink_rep(out_dev)) {
>>> +					NL_SET_ERR_MSG_MOD(extack,
>>> +							   "devices are both uplink, "
>>
>> Never break error messages.
>>
>>
>>> +							   "can't offload forwarding");
>>> +					pr_err("devices %s %s are both uplink, "
>>
>> Here as well.
>>
>>
>>> +					       "can't offload forwarding\n",
>>> +					       priv->netdev->name, out_dev->name);
>>> +					return -EOPNOTSUPP;
>>> +				}
>>> +
>>> 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
>>> 					NL_SET_ERR_MSG_MOD(extack,
>>> 							   "devices are not on same switch HW, can't offload forwarding");
>>> -- 
>>> 1.8.3.1
>>>
> 
> beside what Jiri commented, the rest looks fine to me.
> 

Hi Zhang,

Are you going to send v4?

Thanks,
Roi
