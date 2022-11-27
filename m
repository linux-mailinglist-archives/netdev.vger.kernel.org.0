Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C850639BA8
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 17:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiK0QPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 11:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK0QPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 11:15:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA016BCB0;
        Sun, 27 Nov 2022 08:14:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clBBlXf2ZOaYy8h7KbU9LxiVVs7FM4qr+HQATsZpqxJkLpD5MvAmLFgPZjW39qxWIyrOFpD3TuWCZLS9YW9nl9nOGsAKuvB9yevE2be7/IRjVefDtAf16cC17W0+y1vvU+DqOculTCIAam73z8kx13qwk2X+gBWGTWxOyKXDlzh2/pB1FNsBqRp71FnvYdZ5BeaBfZF638fgaBnxze7eMcv/SROCTm9j/RrWhMH9uXx7AAsUL7PWLsPBRu0WHuSwPe9wfn2g6VnF7Cl0wtSZAme6nG+LW9qFmyHn15Tb+08kzxIfCBsUQkeeu+kKToBJDma6VED0/80u+f6sX9ms8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QRq8ntWlbOqX3muc0dWBCfXupfLJuGYB09ZO/gVZ9A=;
 b=dJq+7Kt9QTWIwM2293y01IVf5VTgLWJHUGTKLSwUWzKQsrGGC5Uota3HbEOAaA4oEtP8DhpwPkIto9zIoWcfq9H5TA5BRxaaVjnWNMr+1Larxx5nVDxsKtvZ8JtYjS3b6+ZRAvnNn85kaK0DN/NFpY8mYbOwM767s1WHtN98bQ9lX1BYcRnCDha28j5jnd/YQSReGfT8lUqkb8Xs1wlNMlT7leb9Frd5gmhgE13EgzMGPU3pZ9J7fL80wxTdeRfS0LmB9Dve7C86LYowMUgPkZzn/EK2P42lOM2IyCnAwMHnco67s6moA5DRNJE5Aw9xnymXWit4RgRLYkwBKC9eBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QRq8ntWlbOqX3muc0dWBCfXupfLJuGYB09ZO/gVZ9A=;
 b=idF88Thum+2o/JvPLKPbtffI9BIAmoQ7o1zY0nD+IsBbzoMtE7iVOKOOK9Wqy33+qjWXLVea+Z4fjGJPVCyFLWolULyHwnDLJLe1BtMC8f2iWIiBZcakqCJkHzExMNofSG0OpPivYRMqZysqHmL8RLRcFN8qufIsqbWXr4nxNAORCVeIYNJjkaXGtrJ80u0fXAUOgjULQMyNZCjRWTCmzWmDsWHmTzTIGXiGNkd6WS4PctV/axAVJddZxW7ASiPnvzaFG2z68DHAdBi1bJVjMutjpUKzGc5/+8uNK8It+zf4/GtbGuZDFIunzEvjqlE4cc8f0vCAzKsb3fzdmUUffw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BY5PR12MB4887.namprd12.prod.outlook.com (2603:10b6:a03:1c6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 16:14:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5834.015; Sun, 27 Nov 2022
 16:14:57 +0000
Date:   Sun, 27 Nov 2022 18:14:50 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 1/5] mlxsw: minimal: fix
 mlxsw_m_module_get_drvinfo() to correctly report driver name
Message-ID: <Y4OM+q5yqCE4/aGs@shredder>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
 <20221127130919.638324-2-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127130919.638324-2-mailhol.vincent@wanadoo.fr>
X-ClientProxiedBy: LO4P123CA0399.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::8) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BY5PR12MB4887:EE_
X-MS-Office365-Filtering-Correlation-Id: d1cf44b4-4c4b-4d59-4b97-08dad0928629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAW2LAgHzmTTLxHUJ34Z63U0Ruxalo7GD7KQ6Lcc+6dZikP3KWMoDMU8B98OB5e+/3qkbRWFGM+fUQTsbnlFKDgdZchfWdGFDPIxpTgA9pgjvXP+WAqV1n7k1qCfPpM/AEUIH90XFphgIY2Cm9fEh3HvPTDE7Ack2elbHWQ/Af0C0LPdIXoDeePpgE1R833OkATdcq/Y2QT7HMAt4JexuayOfszPzC/ipASgiH6cu+77QxO1LxTM7mgPhyKdfEqG1okLI/3OhNsvrqg+wEh+ynC0IlS2Srj2chgt4kFdKHKduQ1XPJAi5lAQMYn0+h1bZDMfdG9eC4hH5Y6XRfc9OTxlCjZDykZyGfSacCvtYHjmbEsXMPo+zBfimUZ1HCF3cERiTeNN8YZHf0u8ZlCVCpREJlVpFcWCVz4rYfcQNxyXZ9KLmmkRPIEgX6O382pZ1fpDp18/qauhp783MQ5xnPBgmn4TuTpTdMJrWeFEBxRHjgqxTox12RiDqjXiZwWjTEAVBKES57VOzNYKPB2wTmtFdKNEBXQnxtNvDlQEigafCM0zID/UUJQxvi8Esv3In9MuBLDdpRAjGcdF6mnU+TqYwAyi1K/bEb0Lv/Zw5YFdfjOpIhHnLmxDLAxIva2HlpitS7FxYvp3kuqdWRLt4/NEHak4IYhvi5g56WDa3okEUgU0+o7ymWBecja0lVLJA55w24ehLsxkNO9CBX5jrF0Bfd+zTrQor4KALpPPY0MWc6HTy7pyGw9gFdTD9ZYr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(396003)(346002)(376002)(39850400004)(366004)(451199015)(6506007)(41300700001)(6666004)(107886003)(38100700002)(5660300002)(8936002)(186003)(7406005)(33716001)(7416002)(26005)(6512007)(9686003)(54906003)(6486002)(966005)(316002)(86362001)(6916009)(478600001)(66476007)(4326008)(66556008)(8676002)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gk1TiVgGIyTPh0Or+nBkvBDkW2eJRSuIfK0BnRgEptz0vMU+ZE3GtpcRTvhF?=
 =?us-ascii?Q?oNBxHODpUHW53ysP/XOMvF8pJu87jPV6SW7VLdIkB9s7B9iBvR9NZ+O8EQFs?=
 =?us-ascii?Q?u509BM0NbIuC7KFq5fawMNG4QomF0S1vCMHUwJO1oR+qlTv2lij41vULCYoF?=
 =?us-ascii?Q?9G3ZGZ3ejvt9ZfgMDgoeS0lfhsEnJBRObX+/qe7D7hFKnl8GvEb3um8sxsAI?=
 =?us-ascii?Q?FBOOgP8untzNBi03Gplznpvbc6whEpOSliudJaqn2195ol1EexB62khZOcoX?=
 =?us-ascii?Q?KzV6NXTNpcYhy2+OID5BhAAYksUxaoc5FdZDTxvEgLOlfELVhQTI8euFzGi2?=
 =?us-ascii?Q?R3/EIkO8s+N0JLZK1pHEVIt8n/MEzTtBe1RQjJGD70Y/kMlYGaSlZgDBqXz8?=
 =?us-ascii?Q?M6szP34GU3Tgm0td7VZ4G4kdSfdMmnqrZlAtjf7uQhG2tDPHGQHhKoqnQQ1e?=
 =?us-ascii?Q?cTueStHMjYW8b+m+NHIdEN4H2B1DtyjgErOWTzdmxoET1DUbSe6zE340ZJmt?=
 =?us-ascii?Q?L3Ul303AiNN48ACSNDaFvUsuYP0eXdr7b4y96LEo/QxBxdbOicb3zAVsa9WJ?=
 =?us-ascii?Q?J3euw6e327PXK0qg4KZYlPB69FSld9KSGxnyoUitceD4ZDCUx/pDJ2EHJYhp?=
 =?us-ascii?Q?uAjr7/qZBM3C65Ov/6/gdlpOnKieB4zYnnTKqx4d6FLvrE5H2NRmhvcv1EtC?=
 =?us-ascii?Q?3MZMjftLc7u3QmKTNcnrG6EuYVLCMcXHvQznDTNMALcJrQyhDNo3Uhg94k9F?=
 =?us-ascii?Q?P2EDvWuay5JEQSUtZJYe8VLfcNv3IjB6qQ0wkVpPpAcLvP+2ppoJjzkpJW9r?=
 =?us-ascii?Q?1krDh/Cjcqx5x6ni0gljS82AwjPEvAJqh9zlSasUVTog4tj+30a96OjVX9A4?=
 =?us-ascii?Q?1+VOZ3iHBXUczGcMXAtDVKWb+txF0QrvP4/TQdE5BFLspU3uMe5jZRbznVun?=
 =?us-ascii?Q?qOjCRTP5Gv3pOWO/ilRpTI+Ph+fA+0DTMv6Rx5CXf8O5ZhUi4Q/YCACjI5+e?=
 =?us-ascii?Q?Rezw/1CuYiPsWvoKw6N4Q036ZLLprGOY3mb4S5HxI9yp3E2yDtpKMh2aILbi?=
 =?us-ascii?Q?TqvpnwXXnp5vHFWlweSQNCGtmk3il2urI6n7Wj9ZFhoGFj6v7GFH79h0xnfJ?=
 =?us-ascii?Q?Vqo4dPz4yJYdqrSEeHD1vW3e1AVn/1FszuZYuzrxELVo7BIzyrum+lpjO8Kq?=
 =?us-ascii?Q?qXi3nhxl62BWrYIELKY0jnQRAd4XShEDN6t46ad7fkpLBCG7ZSekXyLGM5wi?=
 =?us-ascii?Q?bqytTbAIrxuPFvtsZujPkTKUs7TStNfnozmSH5u5r1HSTD01+TVoyK5xMdbx?=
 =?us-ascii?Q?DchjMvImoJYpGW+63AHpHbfSfLbqcnU/Lam9qKXEKZgY/5ITzBAaG4yYU1YK?=
 =?us-ascii?Q?zty1qrnR+hfpahwAfUFE9GtsBnlO3xkAg8hwKz93WYHMuJy2ZMNmoTbJPkVV?=
 =?us-ascii?Q?+piITgHQpe2yAhB5wOZj0g+59x7kZBXJk6lVJlKXz3J/PU8cZBg2DfozfqZc?=
 =?us-ascii?Q?6SEeck+S/BePz+q2odpxftxT8KUeZTvkctN7r1xUuK8+7tgkDdlHsziMpBD1?=
 =?us-ascii?Q?Fbo8PXsFaGp00mVBCbPrlvj+o0lD2I96vohZMP/0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cf44b4-4c4b-4d59-4b97-08dad0928629
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 16:14:57.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZkPKq7blycgB3wI9zPk2fzNJhlJb4OamcpPd2liP4pBmICq66NKXrYhlIRwEmfNcZV+Jz8lW0peIvGK5iiIag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4887
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 27, 2022 at 10:09:15PM +0900, Vincent Mailhol wrote:
> Currently, mlxsw_m_module_get_drvinfo() reports the device_kind. The
> device_kind is not necessarily the same as the device_name. For
> example, the mlxsw_i2c implementation sets up the device_kind as
> ic2_client::name in [1] which indicates the type of the device
> (e.g. chip name), not the actual driver name.
> 
> Fix it so that it correctly reports the driver name.
> 
> [1] mlxsw_i2c_probe() from drivers/net/ethernet/mellanox/mlxsw/i2c.c
> Link: https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714

Before the series:

# ethtool -i eth2 | grep driver
driver: mlxsw_minimal

After the series:

# ethtool -i eth2 | grep driver
driver: mlxsw_minimal

See:
https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/minimal.c#L721

The current code is consistent with the PCI driver:
https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c#L17

Which also correctly reports the driver name.

So I prefer to keep the code as-is.

Thanks

> 
> Fixes: 9bbd7efbc055 ("mlxsw: i2c: Extend initialization with querying firmware info")
> CC: Shalom Toledo <shalomt@mellanox.com>
> CC: Ido Schimmel <idosch@mellanox.com>
> CC: Vadim Pasternak <vadimp@mellanox.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/minimal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> index 6b56eadd736e..9b37ddbe0cba 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
> @@ -92,7 +92,7 @@ static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
>  	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
>  	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
>  
> -	strscpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
> +	strscpy(drvinfo->driver, dev_driver_string(dev->dev.parent),
>  		sizeof(drvinfo->driver));
>  	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
>  		 "%d.%d.%d",
> -- 
> 2.37.4
> 
