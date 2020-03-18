Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44413189E0B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCROjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:39:12 -0400
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:9536
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbgCROjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 10:39:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSJfLOmY48aphJ5gYa8ZiejgNe1fzHHfYzGgbuZN2SoVXXicI/y+dILw/1RxJONGWJOaZTLCNKIUtsanqaDeC9XaChJtgcsqujp6/agTCO7/JbeLioghqUe5p3yinR27YuEhEyov/JvXcmbE4Noia16XsThwrDQ5jUPzR/87PPM3APVmAb4LMsheGZTmQBHWiWMpg9BBszrmubW2MKiY9pwSE8a6shWDB8BTB/WJaGnsWAmLsM/aDMHSshFuqXzJoOvKC3xsYnvjULcK1hI/kdqaBxJjQImf50w/Ql87toeyvf5bESPWYTUjApcSGbsyVD4SnC7TbCSVTzzisT4JEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOwEtWXXh33/RkFgQDwFv18II2ipIMgyp+m4sv9lExM=;
 b=QrXnpQfFEfpW0ZkDXctudLQ1zh4GQuK/vdE/5M9OcuE0IyHmRCe+4nXHn17uAQHIM/r4Pgv998jJtqgS5TkS13sOyg7KiqTOzP567hiivKSqlfxBB5C448VUixpUHBVHBDhvw8ExlT7QHPQHpnR0D6EOIFYqMgiEwfVtWWZDJeqn59BXvfu7hOGP4u+JS88GTfVHKYUqPMRXOzav86VCLF+V0t5vpsEDa8URN1459EMhEJtILcomUJrJ0UDt6Irlopboeo5u3gNb+nQswU6mgjv0MpQvZPInm1fPiLriwKo8IAhZXddUSPyMrg0Vg37R0XsvNTdMq7o5sgFLEk1EQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOwEtWXXh33/RkFgQDwFv18II2ipIMgyp+m4sv9lExM=;
 b=d+THGvkfUQBTOwn8BrshIlvLL0mxXrEu5IS1O42z9GIhpHG2P4tDX0r9ddLa+SzRtF11D2jjqCYPS7PIf7Jqwp8we+YXQGYyZpGYGP+vLzy4DnBd/S4Aou+SxGWzBJbxCp62J+vX11dlRSGlAG9xlOY87jAahtkK/bPok+i1Td0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6045.eurprd05.prod.outlook.com (20.178.126.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.18; Wed, 18 Mar 2020 14:39:08 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 14:39:08 +0000
Date:   Wed, 18 Mar 2020 11:39:03 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318143903.GN13183@mellanox.com>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
 <20200318132100.GK13183@mellanox.com>
 <20200318135631.GA126497@unreal>
 <20200318140001.GL13183@mellanox.com>
 <20200318140932.GB126814@unreal>
 <20200318141208.GM13183@mellanox.com>
 <20200318142455.GC126814@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318142455.GC126814@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BN3PR03CA0080.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::40) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BN3PR03CA0080.namprd03.prod.outlook.com (2a01:111:e400:7a4d::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Wed, 18 Mar 2020 14:39:07 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEZqZ-0000t8-LE; Wed, 18 Mar 2020 11:39:03 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8a9aadb6-ccd9-433d-7514-08d7cb4a1d5c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6045:|VI1PR05MB6045:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6045629CA552DC3C3BC669ABCFF70@VI1PR05MB6045.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(199004)(54906003)(1076003)(2906002)(66556008)(66476007)(66946007)(2616005)(9746002)(9786002)(33656002)(26005)(186003)(316002)(478600001)(36756003)(6916009)(86362001)(8936002)(8676002)(81156014)(107886003)(4326008)(52116002)(5660300002)(81166006)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6045;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHStuT5oKUOJFvXGAZLaNVDSuU3S/xI9pVcb6uO4v8Bqq4YVtmQC4eubB6WBmK5JFsTyQpLhk+upPRPrTkqoqkeRdLX5QhjFU85fb4pYQ2eaSEn6g8NDYfi1h4MaaZHaduwoeljp2kZwcn/YtJLUPkORTwbdR+1S7CEyyfEO5kpWps7C1Qm5wVc5Li3xq1+Dcl23YnSO1xZJqCTfYd/QbQHy3RukGL4zxHTqlDQGUFd/sg0bBvmTQkiam97QeUCHVozSWb/O4L+EgP3VBfNTTZumMclOVd7Q0wTHoB4QrpOnnbzsCNcbF55/WBt9lKhF+qp26q9GG01k1Pdkh5e11mNxcVEa6TQfwU51IbbfHeiNYySzIVpjtnMgUp6JIwJ71z3JTQM6kTpPFkVQNdFNDJogJlNTYHdH2zVqKT+tJXNfZLu32jH2x9Q3wRo9ADPaBLu5Y85xW85AZcpD2R47YD1RzTX06eANlr+2b4fSFseEIgGCAuPsb/wQhpuYAgdF
X-MS-Exchange-AntiSpam-MessageData: jrQlnZwZV505wBZHtgVP564G1LNMlAvWIN3/eYMYi7PzxQEqtNihtI9mDdsQpjjzfY+Q9LE+1NkB3t3biSdD+quassRUvBrr0ESUFB1VapcSsmpDV7Y+w+cOec7mzo1CFzm8r5/xNWRYZY6zM0s7Tw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9aadb6-ccd9-433d-7514-08d7cb4a1d5c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 14:39:07.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /retbBQC1ez7vQc2ux0vR3NMCjIb88qSyS8vpV2qcL+yVlqPvXbL2w5xIQ3NCtAY8Qkw93X3tR2a7mIb2yVtyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6045
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 04:24:55PM +0200, Leon Romanovsky wrote:
> > > I'm ok with this approach because it helps us to find those dead
> > > paths, but have last question, shouldn't this be achieved with
> > > proper documentation of every flag instead of adding CONFIG_..?
> >
> > How do you mean?
> >
> > The other half of this idea is to disable obsolete un tested code to
> > avoid potential bugs. Which requires CONFIG_?
> 
> The second part is achievable by distros when they will decide to
> support starting from version X. The same decision is not so easy
> to do in the upstream.

Upstream will probably carry the code for a long, long time, that
doesn't mean the distros don't get value by using a shorter time
window

> Let's take as an example this feature. It will be set as default from
> rdma-core v29 and the legacy code will be guarded by
> "if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 29)". When will change
> CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION to be above 29? So we will
> delete such legacy code.

First the distros will decide in their own kconfigs where they want to
set the value.

Then the upstream kernel will decide some default value

Then maybe we could talk about lowest values when enough of the user
community uses a higher value

Jason
