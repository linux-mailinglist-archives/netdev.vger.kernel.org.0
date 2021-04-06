Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A195F355868
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345954AbhDFPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:47:00 -0400
Received: from mail-eopbgr760083.outbound.protection.outlook.com ([40.107.76.83]:22144
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345793AbhDFPq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 11:46:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsJnAkZGFMXfUeivGsWHPMcQBA40lyXfVI94B2QSHz/fQt5jN6qupvH10/mSsCVWJLDpMIzdmfekwa46A3Y4/8eiUpVKnMFNw9/jvglU5L4iCAUKA7Q/6zrDC77iItGYUd0rshSAiFsC/oyKbRCJnSSh4QBzZsu7D2gSa+xlo1FaHRhUJP0NW/J7WQhXPHyjSJFxPxMsjRt56VYRDwPkPy2rlltaXXzYSQLj31WEiSEqvFY9n+T9yqmZa3VW/Bzphq9aBvo9tJ6fLEfTvMZzQVF1HR/OVaHh8J20Pi+HUzxucaq6wOSOKNSaAFsp7luRpT0eBvONjwoWGG5N3V50yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvUzj81PZ8RsUedaUK6YLPhw4bDDNSX0T0PEIsIYBew=;
 b=EgDAMLsXkl6jcltSKvf5ONUpcX7Q5exi9VD6ySN/iTTSvoC/YO5uHiyEQ/q89MXZxKN3OV8fHNxWL7LsZ64E/XagRpuUefI1in3J9l3WfIYwSTBevhLLM//lvWD8nZkMtGE5KdLbWM5iIQmKJqqDkUz+H4OncKYZBQHC5AkxSotTuB71EXZ6YMNE58R7UUzzTQTYGZoqzYNhRtLeCxH59q4gVjzV7Pr46V0tPZW0S6xV+Zs7OL2JLrjXLk46GqFJ7rzCy3hCJNueL/e/bzEsw8x8mXP3BAJ8Qxkkht8HTwPFvMvNgRnWzof6zyRut8/KI4w7qkeehPqczeLmc239kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvUzj81PZ8RsUedaUK6YLPhw4bDDNSX0T0PEIsIYBew=;
 b=rLl+2Q481DXUzt8hglponmqI8YRDFgeA9on3sn0Dmmcys5wUvi32i+0JnSMfAZSvew60+Ev5UJxy3+hJhYU3ngPE+5jvGXW/UBrcTiFKZAu0oeUNBw/R+VmcOjpXpId+/fbXvPHmFJI5vP0SCrsjxgknNWV7WpjaTTCKLsHUJQdT8YO3/NodSLLoRfAetb/mat+kZS4lVh6BrygNiptH9QpefPcriCeJS0lBJlqMPjeGWMoD/t92TGos1lpTwCRedQzFKjyRPgfcHf/i7im4mts/424xuYVMXNHO46mPBXwWAMjshw0gMqhjanvvS1f9fR2cnJSBiLb2GH6rs0N+9g==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1548.namprd12.prod.outlook.com (2603:10b6:4:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.29; Tue, 6 Apr 2021 15:46:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 15:46:47 +0000
Date:   Tue, 6 Apr 2021 12:46:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Message-ID: <20210406154646.GW7405@nvidia.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-5-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405055000.215792-5-leon@kernel.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:208:e8::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0011.namprd20.prod.outlook.com (2603:10b6:208:e8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 15:46:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTnug-001AqL-63; Tue, 06 Apr 2021 12:46:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6682a506-1af6-4af6-9d2f-08d8f9132fb8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1548:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB15484D421DC43802517F7D7AC2769@DM5PR12MB1548.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcSyhKyQuArsMaGtyMqkQpYRfSD93rmrBe0xuyov/5OsWKto2w/Rz02Hw2jZMmY///n2vIv8AqsZNkULopmTILaqNRYCWGMvzMRDxKp/x+791NERuBxMcVSUwLfrL07FJfWPRyxsXNiFttQD4onBOzpXrai+Wv0iD90Waa5qL8RuPzdSDEyHmHYjiN/XcC5ZP7KoEIBz4e+NIKe6wkX8laLQtJaz/LTD/eBUZjPEZLT4AK3jwP+XtAbM+e1+31OvCpqdgXrLwM3luYPC3t8lJNdg7BF7YnIqkjlgO8IMGpCmDKF/A+5B+ul2wA/BP3FMgembixzSou/N0c4KHQ/cF8WllTv6NXYQ6ZICo01Ucow9+Q6A7KyIWzvTY2Y6MQlSE+Y7/QxcM8k0WslfsnyIZmlNzuSbJ5mpsX4Stta7p2/79C1PfYa5Fy/NGfOdOpiRcjhC4jvEki2/hx2/gT2VDVA67l9umB2+JSEijkyCsF6CcbXF3Zu93QdcdEu2S/KCA4EYQQH7MQBAu7ug1+TaNUYSfkIXeZuYJlaN0rY8FiU8zK3KZZBNyiiECfzTDX1wLdqa4qzOAOJqUzuQ4WnKeW6OUIvB0Q6byNJ8YBv8RPATHK80jJUy0evc6X9XyGobyF/N6XKx+ym3XuH7OdylEMcMQ2yXNz2sw4e4OtHIBDE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(36756003)(5660300002)(6916009)(478600001)(1076003)(2616005)(426003)(186003)(26005)(7416002)(4744005)(86362001)(9746002)(316002)(54906003)(2906002)(33656002)(66556008)(9786002)(66946007)(83380400001)(4326008)(38100700001)(66476007)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jnnDyGAahI/mufcMT/ASY5rgsw8U+oLHt9mTHGRU7otGfZNlYvbbqLh2TKZU?=
 =?us-ascii?Q?L2ETouLMqrF/ejchyDt+N27ijkgXtoW98Rc0qXf0sQcw3TciapDYzU47AROo?=
 =?us-ascii?Q?N+U94FPZpJZYNRi6JFI4f0rjF/tHF5rEKatfg+2uOeLVHudgS6r4D+rxB1jp?=
 =?us-ascii?Q?DAVlXzaSEid3MfN0RFCe1n3UzjH3OI9//A30Rn9m+QOwkeDN8R5tpztWJQux?=
 =?us-ascii?Q?fXawgtUk5Z0keOUpThDXvXi04JPdf2UsmanDmM9TKA+k5DaGQ/nqc10GC/tz?=
 =?us-ascii?Q?QjyK3KA57haX873FrlJ0fH2KyTLx99o0X+uC3bWkRacrllGKfisfJNEkjIzo?=
 =?us-ascii?Q?qoEvbBo6UmP+qHLu4vfyBw+NCAabHR2bb7um0z/jpL8eKjYe9tLoJYMZVroC?=
 =?us-ascii?Q?gIe8txEwzdiGivvyhwgPIg/8FSmzYkSfKZu5TSEOnzBmTLIgxrywmsmA4Pyz?=
 =?us-ascii?Q?JtFSGHrKgdLzLCtV/8EEEX8bDbm7/EfPpMEbmC0XE/IDn84nKpX0+CJX5hNx?=
 =?us-ascii?Q?TVaW6OnsmajQoRK6HA60s/9HOMoD8j8eveZTq6gY4WHPwqMIkRg5bDc8++cY?=
 =?us-ascii?Q?wY8q5YNxyl576SSm1RsaYYblIrrraof4Xi/UWjikl2h8NmTeX6Wqvr48Ue+a?=
 =?us-ascii?Q?GqdATc0OgvIbk8sDqQoeo2wCwylfPV9JdidZ8lJsytZplRmyGQScQjDq9tVt?=
 =?us-ascii?Q?jA2yriVNbxFRla2PcEUT/CS403bnwoQbzouPrKwZED9dEhU91n3TM95LfmOl?=
 =?us-ascii?Q?NHfucy/J1dmZjTmuMrMVmzbAlxOYUEdANu8AnDJVPRkK51439NFs+1tNf4wQ?=
 =?us-ascii?Q?U6ZvRcvM+lr9EAtzpc0WOCcTql28yo5Evh1Gkfdya15FrrEc7mjfmzbEO1Py?=
 =?us-ascii?Q?DTiqTOeS25XqDMRcif9+9c3rBtybpxsgeAxgWIEeqJ/g/qgC1ogTS3uX84Ss?=
 =?us-ascii?Q?R7nlxZAJCYuXgSmrwdJpU7f3R1u/pbM7EQ2u3ZRHuaIWnSbHU/uwqAFtjnSI?=
 =?us-ascii?Q?9iQlO0Dv+ydOistSrMTL8yA/ldIUBdnycMfA7TDdGLVfEfMU5brEaYCMpC1W?=
 =?us-ascii?Q?a8uxKxTt0LX0Ne/68bPqgpdej2Wx1HSgoMFZmJavk7PFTf0mDy3DBMKr6n17?=
 =?us-ascii?Q?5gO+Z/1OrfNmJyuFvl4tZQ1xEEb6h4zFrx9fg8EcZ431L2BVcihn3lCL5K6j?=
 =?us-ascii?Q?RAXSzzu96tBEhh8VAIQ+gRpUAb8bpXEXeGgAcZ3Ir8nnrxF2C0O3esGMfwhf?=
 =?us-ascii?Q?S8DGpdrIok5NYMivVN7jJwr/Z4uiBvfz4Sds9mBqGDmRcnVge4uYc60pK7eY?=
 =?us-ascii?Q?8WWRgjH6d2z8KZ4d8ndaJtgyxXsaSTqerMGkt2iGYNeToA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6682a506-1af6-4af6-9d2f-08d8f9132fb8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 15:46:47.6786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29vIhU3BODF7CXbJCjMzqZmpBRr++ETdlURodfhejgqs1xKRrh+vcI4jnflI9pfN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1548
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 08:49:56AM +0300, Leon Romanovsky wrote:
> @@ -2293,6 +2295,17 @@ static void ib_sa_event(struct ib_event_handler *handler,
>  	}
>  }
>  
> +static bool ib_sa_client_supported(struct ib_device *device)
> +{
> +	unsigned int i;
> +
> +	rdma_for_each_port(device, i) {
> +		if (rdma_cap_ib_sa(device, i))
> +			return true;
> +	}
> +	return false;
> +}

This is already done though:

	for (i = 0; i <= e - s; ++i) {
		spin_lock_init(&sa_dev->port[i].ah_lock);
		if (!rdma_cap_ib_sa(device, i + 1))
			continue;
[..]

	if (!count) {
		ret = -EOPNOTSUPP;
		goto free;

Why does it need to be duplicated? The other patches are all basically
like that too.

The add_one function should return -EOPNOTSUPP if it doesn't want to
run on this device and any supported checks should just be at the
front - this is how things work right now

Jason
