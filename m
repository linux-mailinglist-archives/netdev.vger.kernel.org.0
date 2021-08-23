Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6FE3F5173
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHWTnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:43:19 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:35424
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229558AbhHWTnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:43:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsQxBP2ls3LVCaDM6Q61obtNAhj6+8DGaEoy7jFPEkCb2CwMoZ5nWmuaUijzzKkdvopPPpQDIq8uKELLcSvFoO60spJqPs+3ZhyZtC1itBTek4XPehSZqpnxjcEBFM2u1ENB21ylBFEFPNfx/X+i6oHgQtb28rXYLqNxf/XZxF7yZndOg+VMOscuIDtzEjKfDKlyoTd2nQ+d0cozLTJzapqmpIKXLpjqPTMYkf7x9Za7n5FurYWFemdhKsHUglKrZNfnEZ1sLiLiHuWVlUgN4/hXzdKpOjC5uGH688/ikHvOdXQ4KI7PfhGU2q5Hq1KtrKC7O5yx7IvUDm2BrKbsMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQXbB+6/HsoIAZOgdzqiQ/OJ23r86i0lTqSHd+0PWDQ=;
 b=Mz6RpqhvJDE3dNW4Es8uUd8U5Ap37vQ0tGmacTu978UTUmd6CqL4Ly6Ba2IQhAQ95e7c/+FVeRVdOvbMKl0ZIS0GuoQ3Nw8cRYqRG3iQPM3PQCo2Wx/GKxtAqfSfCiR0JOo8DGYNOUJboEv4lzb9lJpGrkDEKR65nvPOJYPD831VTTau2j9dy4cZPSragF65fdWLnezrXDaCvX3jIWyawbKdymxZlKupPHlvMBrXkyT6j0XUmJLF/spUvU+Q6iM69wcAZ5EFLX+JS7nl3gqiDcIMqR7aqS2G0hMGicpQdBT+QFTW6Agk0ZhCFkXgUjGc+1NwdYfEqnydPZwt0hBZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQXbB+6/HsoIAZOgdzqiQ/OJ23r86i0lTqSHd+0PWDQ=;
 b=qPPKK9V2CV2Y2IIdyKrenhXl0bO3fC5IBXBaS6tVP2tPy6yg7r26uqUdGP/AIR15cIA8pQGFCl5Bk60AORZOdApY9/lR2oEZPtBoGBUTth4Efcd5CIF+GRzuoVubWFFIKf5gB6/VBXq17feIK8l/2Izi8rgbHRaqZXTFmM7s8CNLoHoNzr/ywvgY+iKrlG36zad9rw1jC+5iECWyc9cyDaL2e4A2ZnXxjSIzWUkakuuyoYhBOCUmabzUB067REpT+OtiovUMTU3oGqgLGnI6SqRAHmG/B+K/AAlp3ON4Isf8mRqML5huM25x3WKZ5eDrZR/Y5BlsD568rZO33UZaTg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Mon, 23 Aug
 2021 19:42:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 19:42:32 +0000
Date:   Mon, 23 Aug 2021 16:42:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 06/10] RDMA/nldev: Add support to add and
 remove optional counters
Message-ID: <20210823194230.GB1006065@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210818112428.209111-7-markzhang@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818112428.209111-7-markzhang@nvidia.com>
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR10CA0006.namprd10.prod.outlook.com (2603:10b6:208:120::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 19:42:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIFq2-004Dsn-Qb; Mon, 23 Aug 2021 16:42:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5c7929b-f030-4044-d813-08d9666e25d5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB535231AE3AEFD937BAD82946C2C49@BL1PR12MB5352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w7VzzLCAl6x+8Y5sAqpy7am3BeGMSerJyjBNLhs6E3IfbSv1C2GZyCTHINFwP5/QncKU48UXKnZxpEUoSiQpR+6KfeZS/3mem2fCQ772s51h+JqipjlxYUDX5YinYI7oNSsppCotg9Tv4j1cDd3cz8zupR7InkGUAAlgsdtOSi1qXq3VVuFooNm//yTDxdiIM2JI7I61U8hd2fG7T3sGZlEOeWMb1X5XCUqTH67rYTR+GRbke6+BUtZO7IOq6ILRCacVJu1LdJQmk37U2ZHQWPJC6LvpFbZwUK8OWNhaw3m4b3Jivotay0sihjyFNdprHXbdPNa1W7D/CwPpBP68jYTVp0aeDUyW1w0QRH4C5MaWGWKYtAqqCYmWbbkHvn3E4IJ7iS50c7TuiXQ1pMK95/N5QVNj4QRdO/EKZmhnWxm2jGo53gANvtuXdxqWcfwSpqaqgDDiVF5cZXZcYB+q6Ox1c7lwRtCKp6jmcSnfeGfyyJ+7JEt0BpLt+dDo+CcvtY5tjcA4Z2/GTPJN/tL1LxwWuyFpywwYVxyXz4Bp8EfvxcitAwoO2pc6IBh0PYUbHfOtW+TYhKhY8CODCShbM/rbjOeYK9WzfhPvpaX3l3JXBugY4leMQJJaPgatuOrKrEcCat8Hhh9sBX9t+en1bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(33656002)(66946007)(38100700002)(36756003)(5660300002)(186003)(4326008)(316002)(37006003)(478600001)(6636002)(66476007)(83380400001)(426003)(9746002)(2616005)(107886003)(8936002)(6862004)(8676002)(2906002)(26005)(86362001)(9786002)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LElvOBWEhzZSDB401Q6+bjy+p0KSA4sdJJ1OjOvdCEEIczPz+PwsOy54B31z?=
 =?us-ascii?Q?9jbTPy7TdqHk/1WyOQH4ARCFCnYKeDkm8lQwhKuZlY/iKnZMuYjxY5EoaCoi?=
 =?us-ascii?Q?V6ClbtyJxvvQdbc1C/YjqGIwmnoxmv+I8qR4a05hza6nGXfgDXs70IZq4ZSR?=
 =?us-ascii?Q?mwjY1fDaMZ24Hi5vaLQdEXbomF9hEzChVPe7uI5AiNly1l91XWECJpIhF/xy?=
 =?us-ascii?Q?WLhCIni/0GcRYmIzwVk2gMtWKrzoZZ0TZPlOcfnjplyMFTE+y8S5lsMy1VLK?=
 =?us-ascii?Q?v9S+0LaZPOmqzi7ZLN2N0qpAclJqIJB8mrmE8oyyFLWQI8Rf1/h799yskWcJ?=
 =?us-ascii?Q?jrtI6UC1Vr3n0yOri3SScr9J7JP01DOKlQxWU+ZwWF1680e5sAik2CHE9wGI?=
 =?us-ascii?Q?Ei2LwigUO3tIgPnab54KBS/9+y6hD8WVQmNnzmzsCK4YE4x7r3Zk1UUWiOaz?=
 =?us-ascii?Q?vnyFgHK5+Y2vFoDVc4XmbSnGVyY+UY3S0hmMGt8thSSLq+/etAal4jcKA6Xw?=
 =?us-ascii?Q?VmJyGL4FMgF2bUdZLiQ6QfSDHeBhj8AIP7g9YM0ddOtWXA5o75A25HLQQjYr?=
 =?us-ascii?Q?M0Szf7EeqoyXTSPyY4uSdYUDQD9X2axdxHuUctU21mk27z/IRvdg2GHZ4R5W?=
 =?us-ascii?Q?52sPF07QBcVNFov01aIsu2eSlbmO/9mX+mwKBqDvhdsH8aRVH8UpiOwRUaRa?=
 =?us-ascii?Q?T986iujsu9l0Z3IKwcUCJgISMG+tzp7/Fj3mk6CLPJH2EhnXpylOjqDGKTvg?=
 =?us-ascii?Q?TIc1Z/bmfH9v/ZWTR64dLUlpYHKTR2MF5N6ZraZ8J1ts7htlVBA1xLtiUMKH?=
 =?us-ascii?Q?TVbT7rnTyQnuLCpYuID/mjt3qAWFiE2Lbg8XZEAFDvaOBbiMzOXDEiSDsVbk?=
 =?us-ascii?Q?0dF3udgRXGJtzEXTMst5GGmcOIFFVSfo0qUgTFN7h9w+AIkPlhhWnbT5yX2Z?=
 =?us-ascii?Q?+4Yp6GzxxOT8w4TQk/CEPNvYJF575ggxHqa63Cq3yGYSaupemGwoT38vaYm+?=
 =?us-ascii?Q?KHVCqIpXKkxce0YnNPf402fazvdlKQGMGYi40slR8IztaJPKdWJO6wYUppGm?=
 =?us-ascii?Q?5SLpE25mkBbSEYKBTWqyVKhDZYACblHQXpbgNBG6VWvK40mTQsi7CSPcnPGF?=
 =?us-ascii?Q?5WJeV2IP2vuLRq+6xAZx+kpeldHzaAa1BYKFpTDE8O/zdPrSZbkvv9wd8Bxl?=
 =?us-ascii?Q?faJPcfiQnoLfvpwJlNGVROwfi/nATq3njthZjrrabosgJqVzODBFXIXwBm3w?=
 =?us-ascii?Q?cj1wTu0t1+F2uqPbl0p/ip+s0qCPsdmOENmBJPSD/29tBr7zGAkHgUfxE+lJ?=
 =?us-ascii?Q?URzMgGoxZdJ5n7wg9bIEuRJG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c7929b-f030-4044-d813-08d9666e25d5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 19:42:31.8694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d40spf2bvmoE7+WZvLb2pnB+qtAL9z0Ulaji+fOS2ZoD1AW+OuZXVUd3GKyGUDDQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:24:24PM +0300, Mark Zhang wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> This patch adds the ability to add/remove optional counter to a link
> through RDMA netlink. Limit it to users with ADMIN capability only.
> 
> Examples:
> $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
> $ sudo rdma statistic remove link rocep8s0f0/1 optional-set cc_rx_ce_pkts
> 
> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
> Signed-off-by: Mark Zhang <markzhang@nvidia.com>
>  drivers/infiniband/core/counters.c | 50 ++++++++++++++++
>  drivers/infiniband/core/device.c   |  2 +
>  drivers/infiniband/core/nldev.c    | 93 ++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h            |  7 +++
>  include/rdma/rdma_counter.h        |  4 ++
>  include/rdma/rdma_netlink.h        |  1 +
>  include/uapi/rdma/rdma_netlink.h   |  9 +++
>  7 files changed, 166 insertions(+)
> 
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> index b8b6db98bfdf..fa04178aa0eb 100644
> +++ b/drivers/infiniband/core/counters.c
> @@ -106,6 +106,56 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
>  	return ret;
>  }
>  
> +static struct rdma_op_counter *get_opcounter(struct rdma_op_stats *opstats,
> +					     const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < opstats->num_opcounters; i++)
> +		if (!strcmp(opstats->opcounters[i].name, name))
> +			return opstats->opcounters + i;
> +
> +	return NULL;
> +}

Export this and have the netlink code call it instead of working with
strings.

> +static int rdma_opcounter_set(struct ib_device *dev, u32 port,
> +			      const char *name, bool is_add)
> +{
> +	struct rdma_port_counter *port_counter;
> +	struct rdma_op_counter *opc;
> +	int ret;
> +
> +	if (!dev->ops.add_op_stat || !dev->ops.remove_op_stat)
> +		return -EOPNOTSUPP;
> +
> +	port_counter = &dev->port_data[port].port_counter;
> +	opc = get_opcounter(port_counter->opstats, name);
> +	if (!opc)
> +		return -EINVAL;
> +
> +	mutex_lock(&port_counter->opstats->lock);
> +	ret = is_add ? dev->ops.add_op_stat(dev, port, opc->type) :
> +		dev->ops.remove_op_stat(dev, port, opc->type);

Drivers should work by indexes not types, that is how the counter API
is designed

> +int rdma_opcounter_add(struct ib_device *dev, u32 port, const char *name)
> +{
> +	return rdma_opcounter_set(dev, port, name, true);
> +}
> +
> +int rdma_opcounter_remove(struct ib_device *dev, u32 port,
> +			  const char *name)
> +{
> +	return rdma_opcounter_set(dev, port, name, false);
> +}

Just pass in the add/remove flag - all this switching between wrappers
adding the flag is ugly. Do it all the way to the driver.

> +static int nldev_stat_set_op_stat(struct sk_buff *skb,
> +				  struct nlmsghdr *nlh,
> +				  struct netlink_ext_ack *extack,
> +				  bool cmd_add)
> +{
> +	char opcounter[RDMA_NLDEV_ATTR_OPCOUNTER_NAME_SIZE] = {};
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
> +	struct ib_device *device;
> +	struct sk_buff *msg;
> +	u32 index, port;
> +	int ret;
> +
> +	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> +			  nldev_policy, extack);
> +
> +	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME] ||
> +	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
> +	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> +		return -EINVAL;
> +
> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +	if (!rdma_is_port_valid(device, port)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	nla_strscpy(opcounter, tb[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME],
> +		    sizeof(opcounter));
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
> +			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> +					 (cmd_add ?
> +					  RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER :
> +					  RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER)),
> +			0, 0);
> +
> +	if (cmd_add)
> +		ret = rdma_opcounter_add(device, port, opcounter);
> +	else
> +		ret = rdma_opcounter_remove(device, port, opcounter);
> +	if (ret)
> +		goto err_msg;
> +
> +	nlmsg_end(msg, nlh);

Shouldn't the netlink message for a 'set' always return the current
value of the thing being set on return? Eg the same output that GET
would generate?

> +static int nldev_stat_add_op_stat_doit(struct sk_buff *skb,
> +				       struct nlmsghdr *nlh,
> +				       struct netlink_ext_ack *extack)
> +{
> +	return nldev_stat_set_op_stat(skb, nlh, extack, true);
> +}
> +
> +static int nldev_stat_remove_op_stat_doit(struct sk_buff *skb,
> +					  struct nlmsghdr *nlh,
> +					  struct netlink_ext_ack *extack)
> +{
> +	return nldev_stat_set_op_stat(skb, nlh, extack, false);
> +}
> +
>  static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			       struct netlink_ext_ack *extack)
>  {
> @@ -2342,6 +2427,14 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
>  		.dump = nldev_res_get_mr_raw_dumpit,
>  		.flags = RDMA_NL_ADMIN_PERM,
>  	},
> +	[RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER] = {
> +		.doit = nldev_stat_add_op_stat_doit,
> +		.flags = RDMA_NL_ADMIN_PERM,
> +	},
> +	[RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER] = {
> +		.doit = nldev_stat_remove_op_stat_doit,
> +		.flags = RDMA_NL_ADMIN_PERM,
> +	},
>  };

And here I wonder if this is the cannonical way to manipulate lists of
strings in netlink? I'm trying to think of another case like this, did
you reference something?

Are you sure this shouldn't be done via some set on some counter
object?

Jason
