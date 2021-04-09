Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBB935956B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 08:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhDIG0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 02:26:16 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:31168
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233335AbhDIG0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 02:26:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQUO8DPfrMph1GD4iiqEyJz/xMeXCCkrX829BhJXFmjh68UPNEVBMX/LGLcKpqzQUPGnJ6UesXsfP9NstDPRRX3BpXlyK+4lEv1/QY5CL38E0Xd1ZHvLNd1Q7U7Xlwxnv39KjssxZDKuRDEoj+b68jdlw7QBOuanov/7MW79Y4Nm4UixlDraaKPj+xU5zXZRa4Y7SKajCW5RCpQHwmNNLchcyy56IUwBSTfBdoWJKZ/k+i5LIa+o2pAjzo79lpE85Sphq1mvkVZQ90ntBXBhdjO9qDppTVk7iTsy2i0OcH/f4GyKqilW0DNnWBTdnQaJNOzK/qIKqXqiIfd6JbN50g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjp1ABAf0QmTjF8d+8A4bU+5IeL2sIkw0JiP9OYIUT8=;
 b=PADpMj6vUkPdvpWaviTf96eiuqjtlN84mBCjZBTCSvge99t9Wyd4dNcF5cEP7kt8uNofkkzdGerWzqFxrQ/id65l3PJnMFuuSUvvI+Ylnl56/p7WU74QTPE4OwUwKzU+FKwyYyAAPlkd9lxeOXdmD6YKUjOgqNaJV0ASAYNmLNU9HKrRwzhfS9RNVnwZRIMh+KWGBAtJ7/i8NBdrBpJnQM+caM4cdFyxkWkloEEziAFNfQivFOlBDzhEhjomj21BY0nCP0B3Y63z2nWBvxO7K6ozZkcc+S9PvQx09ngBE60lQ2qo6j/K0cYj8gpBtD+Fl90hTbGcr+ksyfPuxREb5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjp1ABAf0QmTjF8d+8A4bU+5IeL2sIkw0JiP9OYIUT8=;
 b=Rb1TsvzEjFIwBlstMUn8eCPJdmpQpazv63o0zVMCbSrm+9qxUCN3jlIe+HSYVSkCV8KuizuZhhv2DnqSbIx9Nnz6MQ3V6QeetAOPnVe4Tkg7oxnckLwFFL+WnVbt+hhpYx1Qb0R2r5RjCM9oomBKG3DepUACEvSQot/T0IMz7OCqPyZtw85KDxz6WtChkx3IZ5DGABJVtCl88GsSKWaUwPlEKxJ7/MmM0VwOGA3NRelnDtaR6szxUg1rMZ191YBn0qwJdIaGeNFpC/LW+Mf5IHYrsZ04KWYkA0izE0tmN6Wpg8SW/K1af3jhVBkGdmMtsj4absCRMUqzgM/ETVTtLA==
Received: from BN0PR04CA0148.namprd04.prod.outlook.com (2603:10b6:408:ed::33)
 by BN9PR12MB5337.namprd12.prod.outlook.com (2603:10b6:408:102::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 06:26:02 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::22) by BN0PR04CA0148.outlook.office365.com
 (2603:10b6:408:ed::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Fri, 9 Apr 2021 06:26:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 06:26:01 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 06:26:00 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 06:25:59 +0000
Date:   Fri, 9 Apr 2021 06:25:56 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net] net: flow_offload: Fix UBSAN invalid-load warning in
 tcf_block_unbind
Message-ID: <20210409062555.GA1191@vdi.nvidia.com>
References: <20210408074718.14331-1-jianbol@nvidia.com>
 <20210408141619.7dd765b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210408141619.7dd765b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5012d154-17ce-4dc3-0f4c-08d8fb2058ac
X-MS-TrafficTypeDiagnostic: BN9PR12MB5337:
X-Microsoft-Antispam-PRVS: <BN9PR12MB533765F4A2CD459A1D724581C5739@BN9PR12MB5337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/PR7C8HlF9KOZq3THLVs84E+dBwT1xAqgWBiXvTMuW1mZQiS7H5Rr2bAIJiZuijJZGw0kC2FeIyFZFhYs7ZP7ShyfaqoMH4ei1SfIqCHlQh4DNPbfQnGnHOqt2Dvyh0qQf/61btzAw9SeXNtJr7lQccrelxnAfKzI7sFHbs0VwCL4LenbTy8LRyxhDAlBS/v6yroz3wbAkJoUsULz/G+WLKEjOKyu06NvTSdpmcuSxCXjwU9VqWwpR3M75VpBnJUD9qKxNx1FcqVqaZAx/pyBcdzsJhq5/ubLs4iWMOzUuaE75celwv6HUgfmE+5Bk0JAx1G8/6+bGXTYRXBVIUCBeqkvjaSSff0hxcP70Bb+QEPgPPnGJhtQdJzHHRo3whvWyNUl3qf3C6WcA9qRvVm7AJK73PvM9VwkJoERY6go3wioLih118pTIjYl8y3NBQT5zts1Vjm7uq1JdupZf8vUY53Z2NuFpN84+BcueohusYBXPz4kWmWwIjbtNO0+RQWZEyMO2UuDzqpZKB02xx4QyRpGohBJRFfUaXsjMuDqvkZSAlZ0lv0AdU1J7LMy9DCfHySiEfYDapwqrtyI7Cn1RMV3mrsPUVW202o5lSvEsVSqphvYXGbtTnk69Fmk537GzpNn8NMaTS/pwcYtAwq2hAdqsAuEtkoqz1xtcU3Z4=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966006)(36840700001)(86362001)(336012)(316002)(70206006)(70586007)(6916009)(82310400003)(83380400001)(33656002)(54906003)(4326008)(186003)(36860700001)(107886003)(36906005)(478600001)(47076005)(55016002)(26005)(356005)(8936002)(6666004)(7696005)(5660300002)(2906002)(8676002)(426003)(82740400003)(7636003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 06:26:01.6342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5012d154-17ce-4dc3-0f4c-08d8fb2058ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/08/2021 14:16, Jakub Kicinski wrote:
> On Thu, 8 Apr 2021 07:47:18 +0000 Jianbo Liu wrote:
> > When device is removed, indirect block is unregisterd. As
> > bo->unlocked_driver_cb is not initialized, the following UBSAN is
> > triggered.
> > 
> > UBSAN: invalid-load in net/sched/cls_api.c:1496:10
> > load of value 6 is not a valid value for type '_Bool'
> > 
> > This patch fixes the warning by calling device's indr block bind
> > callback, and unlocked_driver_cb is assigned with correct value.
> > 
> > Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> > Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> > Reviewed-by: Roi Dayan <roid@nvidia.com>
> 
> It's been a while since I looked at this code but I don't understand
> what you're doing here.

To fix the UBSAN warning in tcf_block_unbind. It's easily triggered when
netdev is removed before tunnel netdev.

> 
> The init in tc_block_indr_cleanup() makes sense. What's the change to
> setup_cb achieving? Thanks.

But unlocked_driver_cb of flow_block_offload is not initialized in init.
Calling setup_cb is to get the correct value from driver.

> 
> > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > index dc5c1e69cd9f..8cdc60833890 100644
> > --- a/include/net/flow_offload.h
> > +++ b/include/net/flow_offload.h
> > @@ -459,6 +459,11 @@ typedef int flow_setup_cb_t(enum tc_setup_type type, void *type_data,
> >  
> >  struct flow_block_cb;
> >  
> > +typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
> > +				      enum tc_setup_type type, void *type_data,
> > +				      void *data,
> > +				      void (*cleanup)(struct flow_block_cb *block_cb));
> > +
> >  struct flow_block_indr {
> >  	struct list_head		list;
> >  	struct net_device		*dev;
> > @@ -466,6 +471,7 @@ struct flow_block_indr {
> >  	enum flow_block_binder_type	binder_type;
> >  	void				*data;
> >  	void				*cb_priv;
> > +	flow_indr_block_bind_cb_t	*setup_cb;
> >  	void				(*cleanup)(struct flow_block_cb *block_cb);
> >  };
> >  
> > @@ -562,11 +568,6 @@ static inline void flow_block_init(struct flow_block *flow_block)
> >  	INIT_LIST_HEAD(&flow_block->cb_list);
> >  }
> >  
> > -typedef int flow_indr_block_bind_cb_t(struct net_device *dev, struct Qdisc *sch, void *cb_priv,
> > -				      enum tc_setup_type type, void *type_data,
> > -				      void *data,
> > -				      void (*cleanup)(struct flow_block_cb *block_cb));
> > -
> >  int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
> >  void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
> >  			      void (*release)(void *cb_priv));
> > diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> > index 715b67f6c62f..85a3d8530952 100644
> > --- a/net/core/flow_offload.c
> > +++ b/net/core/flow_offload.c
> > @@ -373,7 +373,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
> >  }
> >  EXPORT_SYMBOL(flow_indr_dev_register);
> >  
> > -static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
> > +static void __flow_block_indr_cleanup(struct flow_indr_dev *indr_dev,
> > +				      void (*release)(void *cb_priv),
> >  				      void *cb_priv,
> >  				      struct list_head *cleanup_list)
> >  {
> > @@ -381,8 +382,10 @@ static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
> >  
> >  	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
> >  		if (this->release == release &&
> > -		    this->indr.cb_priv == cb_priv)
> > +		    this->indr.cb_priv == cb_priv) {
> > +			this->indr.setup_cb = indr_dev->cb;
> >  			list_move(&this->indr.list, cleanup_list);
> > +		}
> >  	}
> >  }
> >  
> > @@ -390,10 +393,8 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
> >  {
> >  	struct flow_block_cb *this, *next;
> >  
> > -	list_for_each_entry_safe(this, next, cleanup_list, indr.list) {
> > -		list_del(&this->indr.list);
> > +	list_for_each_entry_safe(this, next, cleanup_list, indr.list)
> >  		this->indr.cleanup(this);
> > -	}
> >  }
> >  
> >  void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
> > @@ -418,7 +419,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
> >  		return;
> >  	}
> >  
> > -	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
> > +	__flow_block_indr_cleanup(this, release, cb_priv, &cleanup_list);
> >  	mutex_unlock(&flow_indr_block_lock);
> >  
> >  	flow_block_indr_notify(&cleanup_list);
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index d3db70865d66..b213206da728 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -646,7 +646,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
> >  	struct net_device *dev = block_cb->indr.dev;
> >  	struct Qdisc *sch = block_cb->indr.sch;
> >  	struct netlink_ext_ack extack = {};
> > -	struct flow_block_offload bo;
> > +	struct flow_block_offload bo = {};
> >  
> >  	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
> >  			       block_cb->indr.binder_type,
> > @@ -654,8 +654,13 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
> >  			       &extack);
> >  	rtnl_lock();
> >  	down_write(&block->cb_lock);
> > -	list_del(&block_cb->driver_list);
> > -	list_move(&block_cb->list, &bo.cb_list);
> > +	if (!block_cb->indr.setup_cb ||
> > +	    block_cb->indr.setup_cb(dev, sch, block_cb->indr.cb_priv,
> > +				    TC_SETUP_BLOCK, &bo, block, NULL)) {
> > +		list_del(&block_cb->indr.list);
> > +		list_del(&block_cb->driver_list);
> > +		list_move(&block_cb->list, &bo.cb_list);
> > +	}
> >  	tcf_block_unbind(block, &bo);
> >  	up_write(&block->cb_lock);
> >  	rtnl_unlock();
> 

-- 
