Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BAF41D037
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347751AbhI2X6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:58:30 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:32898
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347184AbhI2X63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 19:58:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrQoouJ3pLRTenAB8ORV/RZ3EELXGVNtxmFWCz3w7Y4CrciDRtAOrTMBdHSLjjdcly0q4kQv8ZU4euOGTFmJYImuUoeUk33r5wJhH13ynnaQ7AmCrODmspj9/CVbBJf2Y37Eyd4rMNLU/mfzcsfUs9CkzrTWJ6xfXm7nL+49hFjqI5VhVQYyqK22lvSiTNM3fSEZrwHLSzaYb3/JiM7IAOLf1+Y5tDRMJDRsXZmT6rQwEfooQ9EZFme2px8Jp3ZzI/2hTU2CAslCLQqwurTA9xAgpV0cTFJJ9Nl2ZS3NfuCX6oj5TxnnFhOb06AAWelz+xQRqU7gXu5G7n1KWelWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=n5ecuy6gJHU/5InFpJeKsXOCg825jYAfWrwgKu/0t2Y=;
 b=EYAy/+DGApK7MIxhxE3R6QPfB3dHSAotd6z7eoHK1BpOAx+2ZjcAfTnobKI6+ub2pW5kDgjai89AVGghQtQa5bLLC9xhlcliS1/4FCkZT7ar1/tYbd7ZW4VX9O5qMJvXvYJGVCZ7W3xcBgG9QPisTCCxtRZ5lQzqB/ATt0N9rtIun7z1I3VS/4i6qq9H8gUpMIKBAbHLEtp060qASWzKeT2ZF75l6DjOhhocV52WSUp5JQKBzJaymxPwl0TySdUDZ/5FF/VcqecGJvLJfN7fIAOSHSuTZltnKcMG6smeiwETI3nbJ1i1VBCp/bcRRSh0lY9Jnp+fgQch3W6tr5Ujnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5ecuy6gJHU/5InFpJeKsXOCg825jYAfWrwgKu/0t2Y=;
 b=Yy9+lEhiq9z6crzK3RcOt6pYsKn4MxwqcDC+V92ujjTPQic42mKK2tdsHfswV3IvO6ptg3FHJbW5GMru7mH95DHr44PGnzQ5rLCgePkRxB6TKTOU3/mHV0p06x0pvI2LkvCe7/88EGVvAqdbu8OTF6NVFNSnZV+F3T+usN4OMNULeagMu4FYfAlFQHmmHR3HMgw0fAVVTwpH0Lbh3izkYF3JXuaJWwsaMOygkHYAGcX3I+/Aq5muxGAFrT3Ft8zqGhWZ9JFmZVvRa6VrCGWo6DqWjMYnBKJqqeprLap5lM5y2DSqK+msuqT+PhN12/5mWFO/T/3jscHr8Arg0TcBgQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5079.namprd12.prod.outlook.com (2603:10b6:208:31a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 23:56:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 23:56:45 +0000
Date:   Wed, 29 Sep 2021 20:56:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Mark Zhang <markzhang@nvidia.com>,
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
Message-ID: <20210929235643.GD964074@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
 <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
 <20210927173001.GD1529966@nvidia.com>
 <d812f553-1fc5-f228-18cb-07dce02eeb85@nvidia.com>
 <20210928115217.GI964074@nvidia.com>
 <YVRbcXJL/LBaSLLJ@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVRbcXJL/LBaSLLJ@unreal>
X-ClientProxiedBy: MN2PR22CA0016.namprd22.prod.outlook.com
 (2603:10b6:208:238::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR22CA0016.namprd22.prod.outlook.com (2603:10b6:208:238::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 23:56:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVjRL-007jGd-Ef; Wed, 29 Sep 2021 20:56:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3886cbff-0e68-4406-9423-08d983a4cae0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5079:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5079858FD5A56B15F7D4EE6EC2A99@BL1PR12MB5079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BE1kujPgoKCWnjodTN60ruu1Rl4RDpSv0o1nXIF08PUDNf5TFqTdNLkwexlP8hwMeaFpEri/2z16eKQdXjrAeBvfgP/2w0VXlgeCrcZ+EX45KUIrLyWdp+5THB5VDzEVAa5FGdqkT0YP1LEVqThv7wgnAB4HTN+xD+Q9PVCT/JLo9JEERrdYHC0skuC5+aGouhjnSge6unLuF7HOhl1Ln7epITWjqZUkca7THOKzusJStx5O54lzPn5LOckBUL/VV+R/onynLucLRszkxSTE0EgCGFwZm+PpO2+iYpUJ9tnlyRYxsOFbV+2XPBwBWf2fZep7UqmEg8Qwg6wtutOZikV40PgE6iODtFZtD6mcU58nQRQLfeZqxac1gTdymNA2wD3VdjZ7Fj75nG+0C2ZMIQleyLpOju21/+DLgDb4bNRCz5Y7cGrHoUnb+U2ARH7tILeJS+GPx7OVylaJCU8G+MvfY9nQRSTyGQYp+ZY9TFnemVW4H78+aWcvS9NAUC/+wXoMbVnN/rt3Wm8XN+9jhy+fTQ3+g5BZyftHsbG2BxLAFsHttkSjwcpUOvMuAnhcAtDOllXsmfb/QR/VBUo+ugD2qxSlGSCfw+vWxWpsQwdTkY62qNpoHQ8lWCZ0GAjqv0drssmzYEgT1QHBqo+mWnm4AdhST0fAM2YJyS6oE1FmXkNSDzFE6v+iC7la9Tm2+iIFu96Ay0L3YVs7cXElaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(1076003)(426003)(7416002)(54906003)(186003)(53546011)(8676002)(316002)(6916009)(9786002)(9746002)(2616005)(4326008)(26005)(2906002)(8936002)(66556008)(66476007)(86362001)(66946007)(33656002)(36756003)(38100700002)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hrVRN/n+XQy8OtiL9V+74NcX4nsxjftWp7EjarjpPZvwrtisRc0O2hrRFJUW?=
 =?us-ascii?Q?+PWJwYJ2jLZ8C76jJeAW8ilzDs/eYZVmBw5qh0xIZ8MiL0qoOEIqZInDh5tM?=
 =?us-ascii?Q?By5B8br4lJRmZug2msCtpXl2DBe5IejzSu97OiWb3fe9RYQetArgUTZRA8Xm?=
 =?us-ascii?Q?rdo7qhlolnhT/5iDo9CcdzcEtU48LnDzXMMeRnqSZQkkXURXcNOAWMWzUgbc?=
 =?us-ascii?Q?2mZ37OMzPJV4In7FYFTRmoF8Utl2SEzOo6okYg3fQBW3MwO8kQtJtIG6XnJf?=
 =?us-ascii?Q?/q8zG8vTerby/ei/UbBcK4w7NgY2exjlB9MMjxRX6wqDvTZEPGvNhmtJ4bfw?=
 =?us-ascii?Q?NSTty8u0Zj4u5F3EH4FyseuIASJu3trBv0AYg3FyRoCfHdbMVf3l32i0+v5E?=
 =?us-ascii?Q?a4zi9tf+i8DCPma3RG9cOYvBIu59T2jm3FELzbBlPNYPoGJyTrR2HAd5mz9P?=
 =?us-ascii?Q?Bjbtxhau26FOqtdznI7yQ1jHIdq/aPPl5OBsdARKsS22ZlfBwL6mmLXZn/Vz?=
 =?us-ascii?Q?0fxuKBLbEG7W1hoRP/V1F51WkUzTYZ93DetJhSnL18S9N9HCglDYfUYrpdn3?=
 =?us-ascii?Q?06VjmO4W5uZ/ddSwyoDjM6h18Bi3Nq1vHLz6hSH57Jc93aNNGH+dSDTE9N2s?=
 =?us-ascii?Q?AzHA5hiP+CCjfXI7oys4e9Tf1yW3ZQ2Cy3OAwLMQg2McZaFa3F6Ivxeng5Wd?=
 =?us-ascii?Q?9EBCfLskDXisGsno72dOAnJDefoEDUBPngMbXrlLQU66NFalXMhNDY0Z6nns?=
 =?us-ascii?Q?/7hwZxSanGBnSQ0cJhllcH0jPTJjGCF3yV0ovwh0JoyowZLnd2kCVmd+2In4?=
 =?us-ascii?Q?HRztSzteevroJjbqq6PzFHPRLb/Lj7pHlknEmcnwrouPQkK/G2lPoJKUH6V3?=
 =?us-ascii?Q?+VAlpkxiEqWMjJBjf/Bpjr3MYlTgeKZdVDfKzfVwtp7rCMsyc+y4PW3aLikw?=
 =?us-ascii?Q?y6lh9PaxBScjSUVkLSD7QKMEImj1fWWycUMqP6x9PJApMo+1O4rz8UJ2HI0r?=
 =?us-ascii?Q?1Ryw+zwRwl70wcFQOyxuK22gs4belPdb0CYAN7jYAMEZKtjd8SYau4GjfA3G?=
 =?us-ascii?Q?2NxQRfrfsCIv8LKQCKWEzpIe4vgC8H4l6cLeMGvbRwWxXeal0mPunqaYjfz1?=
 =?us-ascii?Q?TXd4tWZOjBSzVLymyLhtpQc+s3Ba1fTBOczuDo3I57lU+QW4y+pOGl25c/Th?=
 =?us-ascii?Q?lOKeSAFVJckAapULk7Ia1IT3QepfoCc7xzJRVR80mA9hv6107xEmu6ZjdbCa?=
 =?us-ascii?Q?PYJAXTB/lkmBf0/Hvo2cjKHN4b3/6z8fM9/CbR2BmukoWv8xfa9mgFNZqQAw?=
 =?us-ascii?Q?p1t6ZMnoA1bFmmpzbX9XKDxD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3886cbff-0e68-4406-9423-08d983a4cae0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 23:56:45.3078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Rp9yyufKGMxRMq73d7I9JP7HsaC1vKxLv/WsoIdNKigvsCOFAkNfiiiSrUYilnH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 03:26:25PM +0300, Leon Romanovsky wrote:
> On Tue, Sep 28, 2021 at 08:52:17AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 28, 2021 at 05:12:39PM +0800, Mark Zhang wrote:
> > > On 9/28/2021 1:30 AM, Jason Gunthorpe wrote:
> > > > On Wed, Sep 15, 2021 at 02:07:25AM +0300, Leon Romanovsky wrote:
> > > > > +static int stat_get_doit_default_counter(struct sk_buff *skb,
> > > > > +					 struct nlmsghdr *nlh,
> > > > > +					 struct netlink_ext_ack *extack,
> > > > > +					 struct nlattr *tb[])
> > > > > +{
> > > > > +	struct rdma_hw_stats *stats;
> > > > > +	struct ib_device *device;
> > > > > +	u32 index, port;
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> > > > > +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> > > > > +	if (!device)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> > > > > +	if (!rdma_is_port_valid(device, port)) {
> > > > > +		ret = -EINVAL;
> > > > > +		goto end;
> > > > > +	}
> > > > > +
> > > > > +	stats = ib_get_hw_stats_port(device, port);
> > > > > +	if (!stats) {
> > > > > +		ret = -EINVAL;
> > > > > +		goto end;
> > > > > +	}
> > > > > +
> > > > > +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> > > > > +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
> > > > > +					       device, port, stats);
> > > > > +	else
> > > > > +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
> > > > > +						 port, stats);
> > > > 
> > > > This seems strange, why is the output of a get contingent on a ignored
> > > > input attribute? Shouldn't the HWCOUNTER_DYNAMIC just always be
> > > > emitted?
> > > 
> > > The CMD_STAT_GET is originally used to get the default hwcounter statistic
> > > (the value of all hwstats), now we also want to use this command to get a
> > > list of counters (just name and status), so kernel differentiates these 2
> > > cases based on HWCOUNTER_DYNAMIC attr.
> > 
> > Don't do that, it is not how netlink works. Either the whole attribute
> > should be returned or you need a new get command
> 
> The netlink way is to be independent on returned parameter, if it not
> supported, this parameter won't be available at all. This makes HWCOUNTER_DYNAMIC
> to work exactly as netlink would do.

The issue is making the output dependent on the input:

 +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])

Setting HWCOUNTER_DYNAMIC as an input flag to get the GET to return a
completely different output format is not netlinky

Either always return HWCOUNTER_DYNAMIC or make another query to get it

Jason
