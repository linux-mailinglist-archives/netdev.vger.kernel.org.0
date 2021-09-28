Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2191441AE3B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhI1LyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:54:02 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:6657
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240526AbhI1Lx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 07:53:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxbEkv+ZWaHOD6AUINYssiGoc6gBQfs41E8lTLD3nZxEFh/ETnLtJoRVUNnqOO0kkMBYwcomClsVMxN2XgtSQKAly6xanrksIiocZ+xXtop8a7gx0zbLq8ds+68yP6WU/0gzAchuq5bqXYYVcWatge1LW+uWsk64DDB/90SCLrAIAIqDujD+lzEZqhuPRJgDJy3uT/4iPkac8MUvA9xhV2H4TyJO73d1TGeATaIE2X5BWPyvKZ2g3nrQPcBt86QYUSruIZXEN82png8cRJofkS7i//rLE1Ko9QyNkFXZD8nFHfTife1Nso3nfH2sfMFZjeqou7AbEvf1IjFQ/wEEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xdNmtEjB4JR4/ZJwOn+sfctmtD5sw2f6r8u2lKQj+TQ=;
 b=nJ3R21BxOuXK4P191AnI5/xW99gXl4Yd/ibUNNAMQnBxmUdiu5r3C6pmmXI6lWt1rzV19CVgcTVzwkXe7V0TkzUfQTwCcjJoAvKodmd3YRXqvXDTT17YWmQKVgQSU76ccfIA15/tdyVtzUd9Rn2Ko6z/zIbsROktv1Bh76KC+8RxlHCsl7kmiB2aIMPHN5dr90bdBho8Yka0VbJvN9yjKzCxYi/8hJbp3gVblTr3iS/0MzRWVax6rlLxjF6rUIrkm/tSrzxXflValDzOkoegxTe+59B3WB555CW3A/Lis8KD9viLqISSKy0fWP1roYcxnQckqBjEUNguJxNaW6Zwxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdNmtEjB4JR4/ZJwOn+sfctmtD5sw2f6r8u2lKQj+TQ=;
 b=JOg7kNerDeofX1prQ6ix1T54Xmh4pMARyijdo0H3beBB8o+bE7DLQ67jvW4PeCahPdqcD1qIwMTlh72fCmFyFZwaQIVHCLjKMCj0Rq/eLHZv5nPgVJ65azRMaS/nHK6BHZhHZMCDg7UA2iN2F3SeoM5CDAGNnbwVurHEN3yiWO6ct8OxUHWAz5ZNJkri9o6BJpO93IlAtSUXVymOaRXifwbKXbbd+5IwhVDJOGJXbm/adoL+8X8C2jz1z0UZufEg+E1IBBnnlIzcq6Acnv48ZEFQZMUXt7W+jowGgwrlWHX5GiwlL0apt8MIaMpJvGIrjWjwYKZekzozJRvG9F9C1g==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 28 Sep
 2021 11:52:18 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 11:52:18 +0000
Date:   Tue, 28 Sep 2021 08:52:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v1 06/11] RDMA/nldev: Add support to get status
 of all counters
Message-ID: <20210928115217.GI964074@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
 <20210927173001.GD1529966@nvidia.com>
 <d812f553-1fc5-f228-18cb-07dce02eeb85@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d812f553-1fc5-f228-18cb-07dce02eeb85@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:208:32e::7) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0122.namprd03.prod.outlook.com (2603:10b6:208:32e::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 11:52:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVBej-006wv9-1Z; Tue, 28 Sep 2021 08:52:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7513c949-f6d9-46d4-3dee-08d982766be1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5221E4487B1082970F1D11BBC2A89@BL1PR12MB5221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 58tcowc4oc5eqEdzqXA3S6ouAeicaXdK4Bcf+1rP67+9ycSzRO09ptgaYbsA28gr4wKSX9059h4OSJj4/czMoSEip+Ta0PaI9SV0ARjzYkOw8iA6bXswqSS4saB+jqGSBU3ABuUF53LC3WsxC5vDHNOekXDxnHYI8oFZvkQsmo9GaybjkJhEfaa2ciCnJxx0wgaTheEwFvRUcM2piZRTigW/iOuS0NkDvnBfvCbK3yXwK2gazwI5BA4aMtUyDoQZKKj8aokebawsBvNm7Yj3MqyFM3E2rhS0k19pzwhEw3eeVue6ytVdsPW6HNY8hJQ/JCrqgjCjEWBMg1tvlDTQWEVWWN/elOc1tkwKrDk40InjlyBP/+bBzgLHoH0NuTOSARn/DDQSFfcOqX3IqE4jLpEuJ8DWoarIb1uCFJba8YQr6aKHrvrCGlEG+7HspXx+incvLBOtVO4SAoSSII4NnrPKY0VGcbXpHXZfVdC1EbrGcxDHmPDZzZYeVUXrCIpSyvZdoQ0udTtaZpRwrQTe+SUj0OVg1dPV/V7AWHwEXWy3fNV04w5zhE/AOy+uqcwJFIS4pTYLPHCK4Frl6/MUGitm8bORWxKCaA4vCGCsyEpC0QuoI4ICklXHfVgsJ4BmKnsiNvCagpWbB7naOC5TlL7E9LQ6aN1NTWOGvglwBaemZmviSRca0Dibp9Vs+P84
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(54906003)(6636002)(508600001)(316002)(5660300002)(26005)(37006003)(1076003)(2906002)(186003)(4326008)(8936002)(8676002)(6862004)(7416002)(2616005)(66946007)(33656002)(86362001)(38100700002)(66476007)(66556008)(426003)(9786002)(36756003)(9746002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RJpRVnA6yYDCjBTj/P+bmM0cV5Be7CDcXs5JSe/I9OltgMgQjAPgYFJRPhSd?=
 =?us-ascii?Q?/sYd3gmMiNa2Fod3Rza9cIld1e6+9RXHKN63JpybOnlPcEgBP3uTmTkIeWa4?=
 =?us-ascii?Q?BfKmg9Af1c6/67AO/Bn7+rQSPcPI495I5BtGTITU4nYOeBWZupIFcxcNTPW5?=
 =?us-ascii?Q?yfiD6ES9JnxP/w30kEC1bnusw9maQCfh1P/qfyI52baDYSxa7Cjmps616pcu?=
 =?us-ascii?Q?1e68I70lPN4IkV6+5wDs85ZG2fCINUQbZWI898li/V7TAV78L8NMtrY6P2TR?=
 =?us-ascii?Q?XAwK3JvzZZDwojbg4s5/gwTPfbBXo2GSdQpNFOAx/AT+JzXR2rnQv6ksB5IC?=
 =?us-ascii?Q?NyM1pmMOXllZOu+rXBMNl4Wwh7eWQzYnbZ1d5+MAZGeKDFQ7YqhhcuR6tnfP?=
 =?us-ascii?Q?7UvN3De1X256INYaFoJq2I5BL4/5YcV+C5JPiAvc0K8TTzjDxkh8vvtEjfLZ?=
 =?us-ascii?Q?ulTe8mNrv8oA2DBuPvVMoaXSeVOAzAQkhzDcy3GPcvj3bujyoHTJvhYOoGHI?=
 =?us-ascii?Q?qVuOcKqBZUEUX41mLU+Ei1D9dQSrYS1efnIhJ4jlqkl1EEJX78rwole/OwnL?=
 =?us-ascii?Q?UyT9BA9RofQKPMf6sSnxdlYmzrIlmQv00S2HSOgfEZNOQpXpuErt26xdL0IG?=
 =?us-ascii?Q?Q0hTFuzK65PqazCcUbzmz/Hr7/4BiYsnKOtn5R45SbnFt7BHSyUm0K0e9w/N?=
 =?us-ascii?Q?f/Pk5FH4AxoXzTRMUtlvEwRuQA6iQ4sMpwO0ZanVK1EFou0sdQ7l+Ioe/KpY?=
 =?us-ascii?Q?rxd246nw2mz3/hQXMYags6Ra8dRkfFoMW+iXGROscBZY8FDjg+4AD5b7fgP/?=
 =?us-ascii?Q?AMFZcGdKY6Js2j0tvSB7hWq4bZuOuRXS3RjLkgZoIMgapzXGtxHlg0Z0neAN?=
 =?us-ascii?Q?GnWio7f0QDb3+xcwRgvDMYMFdxPyTp5eq48l38o1sjqMqq3clbRs54Zg6n9j?=
 =?us-ascii?Q?pYT5RDhxVsra+P6kuf+QRb3af7pnke0uKH2xt246zXlmU5aN3YlVb+OrhM9a?=
 =?us-ascii?Q?wRn470fG/C1D7ULm4x9Vm3sqI5MX74PA+cT/CJgh4NXXHgzAZsRmM3fvlYzX?=
 =?us-ascii?Q?fG3ZrJGSTGIpv0i7XsMqfB0uIru0u25NWV8tb9qDGIWdWmk2G3yk+C+wauxi?=
 =?us-ascii?Q?C3XtW5228mmn8Da/OTED+wsV4u68HIPXAX3Ark0keHQARcOU24w77jwq6/CO?=
 =?us-ascii?Q?4m0jogtJWPodid63uYSHdGMroqQw99NGchfaM9KsKRtThFsvdhsV0bhQ4URI?=
 =?us-ascii?Q?kwb4IoL6zoFilZXoAuSNGSe7SMgXcqtpQFM6MsKEhzh5mvEVToNAekiRKYoX?=
 =?us-ascii?Q?hHFkVNmJDMakMphrYKseoCgj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7513c949-f6d9-46d4-3dee-08d982766be1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:52:17.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0Ug5dVo7DWGPM871W9V3eIzX8rrmp1CUxcLy0Ck280EqyKdgYGJW74Ogx19EZZT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 05:12:39PM +0800, Mark Zhang wrote:
> On 9/28/2021 1:30 AM, Jason Gunthorpe wrote:
> > On Wed, Sep 15, 2021 at 02:07:25AM +0300, Leon Romanovsky wrote:
> > > +static int stat_get_doit_default_counter(struct sk_buff *skb,
> > > +					 struct nlmsghdr *nlh,
> > > +					 struct netlink_ext_ack *extack,
> > > +					 struct nlattr *tb[])
> > > +{
> > > +	struct rdma_hw_stats *stats;
> > > +	struct ib_device *device;
> > > +	u32 index, port;
> > > +	int ret;
> > > +
> > > +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> > > +		return -EINVAL;
> > > +
> > > +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> > > +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> > > +	if (!device)
> > > +		return -EINVAL;
> > > +
> > > +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> > > +	if (!rdma_is_port_valid(device, port)) {
> > > +		ret = -EINVAL;
> > > +		goto end;
> > > +	}
> > > +
> > > +	stats = ib_get_hw_stats_port(device, port);
> > > +	if (!stats) {
> > > +		ret = -EINVAL;
> > > +		goto end;
> > > +	}
> > > +
> > > +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> > > +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
> > > +					       device, port, stats);
> > > +	else
> > > +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
> > > +						 port, stats);
> > 
> > This seems strange, why is the output of a get contingent on a ignored
> > input attribute? Shouldn't the HWCOUNTER_DYNAMIC just always be
> > emitted?
> 
> The CMD_STAT_GET is originally used to get the default hwcounter statistic
> (the value of all hwstats), now we also want to use this command to get a
> list of counters (just name and status), so kernel differentiates these 2
> cases based on HWCOUNTER_DYNAMIC attr.

Don't do that, it is not how netlink works. Either the whole attribute
should be returned or you need a new get command

Jason 
