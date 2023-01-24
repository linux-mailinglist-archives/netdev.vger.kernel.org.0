Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C335679C8B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbjAXOvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbjAXOvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:51:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D6D4A227;
        Tue, 24 Jan 2023 06:51:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Opu1dnGRiWadW7hmpCW6wwhyFvBp9KurJ88REQywrq/biT9vnTVvbcZ4vJWjL7rF+oPbCqudBvY+ufO646rmyCjHvaXhw0qtnSZrzzRJmhO+FHRVVEPkKj7oLmn6ukubTCImNbAP9A5dcke9kqnpRvJoy3hKibyyB8aUvL9Hay7wUpmYIsmsMREHnoEyeMvfAWWBmjV61bfh0kJ5RlZQ8ZkBn8lTtMgAk8a0tp+DmR25jFcx3TshiZcE4lOSjx8vHQq392pK+9feXZqmah0K9A4P7Jewd00782/Hef+rjsmQ2t8kXlOhMXTam/nfbVTfERKaWWBXqDRAnWnChOysXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdns+ccGmYa5/eT4I1wsgXqZ6qTopVSRHBbDpj6nJQM=;
 b=H8ox8of+DI7AVt+YM7jWmQa2d5IVPJRjdkLIs5PCIksDwm2Dlt+1VksnGOVEcfVDge17RB9+jBt331YUD6syd7eaXM+ibs56dx2Hs7PCmsDN5sNhxRWhZ8egX+oKbdPWzLEBs6wqo1u3SDSnyv2AhVFGBt51JaQicNWOVmhl6B9tiXQHj5y2aoyc72AHKOxa9TRvAM61Es+6JOPY35seoRjQtstp5fWiXgT0xzyNHXOWeYzfzWG2AZ94KOSxg5hGTIQt/9TDhcRBHJxPNQGa5ifRQ3eO4wB1VS+wHjjtdNw/Tb5FI9Ti4iGnjEYDNt/C44CKjvAA7wKAQi7Xqwpzvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdns+ccGmYa5/eT4I1wsgXqZ6qTopVSRHBbDpj6nJQM=;
 b=h2ZwJoCKRqW9GalHC+x195fbxhEnmmCjFQmr6XFBFlXetcYXcYScK1lBHCVKDtmgCuKfI4oIoSq5iBm9tlHW8JhEPRuANn+kbPNcPZt9P4+p3TU7GNe7lxYBL2iDSm9CSPSAWqVYKtiNlG3wFq8knU1bhB0yAdOxOMj/w6vklw7pVMKjrpj9nkYQdlucCAb0oBBB6lwK9+Vd2s9tPWHA6yn5AjWpERdb1krBMwxo8ZLpOwm9rN7xpkwncNPtkdDg97CbbT8284tKf4E6RAYuTjaxIk6YPVa3T7otVc4SENeyYNKf+uMdZgaFt/Dh4RtOc97dhUxs+QUZO1oE4xtLsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:51:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:51:07 +0000
Date:   Tue, 24 Jan 2023 10:51:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Message-ID: <Y8/wWTOOjyfGBrP0@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0365.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5205:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf70ce0-71a6-4651-01e2-08dafe1a6c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0pcik2iFgncPCZCjFkfMzQNaBAAADfnWDyS/ENQquG0yJ5c8qyzTJSTAxiYBzqUKRmF70mAYivDwKj8nW3/CxfNCKIGMG+Ro5FKjjYNQaQUYVf5uackWABdFwU0tzdSZyIjROxG/wemgams9FNBRntXGSRKychl4OXDvVE4xY1/LFyBIVvseDlGT0g6oF7G3UGByShO1k7IfqcppeJz/ILU68dG5DF7xC5qyjllyZR435G8Kj0TjvBWUJgNvw9wnRz31DZk4ts/kTRgsN/h8Z6vx+dT2/B7S6jse039rkYzmfNDdZ/WYxb4EEoaR+mtvINxcu3KVGIuCJImmSB1vkk59gnqKxn5DeK0BH9RCKDgAV4tJnDUPM/gbr35kqiwE1CzrkSSSKslITDk5l8N/HWqukzqYECnRxop4XxDd/2TOv+SNA2jUxPapDELLLJTwdAAEbQEskgrzzBWpPuUuhvED38M4IKplbewymSe1BEDIdvvnS3sb8AnLfCxJVc+AqeG22wOIWBzanSOVdOdT5HzjEONYN6I2XxqXAOEvFhmqP9UO/dexBJm7BX71e4FkyM67as6TjDsOtiKvR695dH8qXCyBuPN+iiu3cm3o06j4FGrBbwk/lmC/AmLmbxHUQehMVUdK6A91lwwu6phvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(36756003)(41300700001)(86362001)(7416002)(8936002)(5660300002)(4326008)(6862004)(2906002)(38100700002)(83380400001)(6486002)(478600001)(66946007)(6512007)(26005)(6506007)(186003)(8676002)(316002)(37006003)(2616005)(6636002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?skcwf+AbpdWVt23oYoMHZQd4wMWgqhPJouHkPi2dd8uR+QVclL7K44cYbGG0?=
 =?us-ascii?Q?DNtV7v9kHpGlQI4nXH6bhhHa66kxysrDJ0xixftMAaMmBvbo2eMHswpMnPMq?=
 =?us-ascii?Q?NmqSltK2vQyvvmZHX5gh389N3i7fqabcKo+EJ5ntIQ6mMb7DjeJZP2b6F8VL?=
 =?us-ascii?Q?o/nFSteahTchHWh0d3bFYqK9dwTxHP9jsNDB1ZaHpoSbRoGb4lpxF1XnDyJF?=
 =?us-ascii?Q?XxwMs8XkMOCjORpdLY7vxwlE43a5At6KyFJq5KWOcJPrGusF5ZiS7AAKPhL9?=
 =?us-ascii?Q?v+xhCntDDRzs+fzRO9hZzURNNM7muZ/uqcaj03JYZRmV+hkVCTs3ueOvnYMZ?=
 =?us-ascii?Q?w/Liypy9E0mEj8xEJZCCXL6Xf4zNxxx5nYqNYawYtExUKDpoJJyPHc5z356J?=
 =?us-ascii?Q?Jis2RpuhuVxwJYOTtl2HyDgh5XrUt5GApMHmkX1CMgpmVMfHq6I80vIOrdHP?=
 =?us-ascii?Q?DrHTpIRfWkKGh3ntbjjAOdPDKkZd8crjWji8vs+GrM9jNM/t1E+4WQ8wmcOK?=
 =?us-ascii?Q?rBJ9RidokvqOI2ICKxL4bVR2nxKUQj3P6PeBs9gumKSm4I58XWz1KOnH89pC?=
 =?us-ascii?Q?+nFsrxAgi8j207gAfjwH8ZO65NEc0//Gp37WkC/kkKREzRnQe1CN1SANWrTj?=
 =?us-ascii?Q?MHwi30h/teXgDKrZ8NOGBxLhmGDt2P7JCw+EL8WtGT1X9lf8y9fP6PtHhlB0?=
 =?us-ascii?Q?4Rq8JgmyGsCa6Z3h/ksd1UENA6XtqoYuSVkev0m4FxwQqOma6VI/4x1A1+tY?=
 =?us-ascii?Q?QpkKjX8X2WIhfXrH7xyqrSGkY+sGedaJaOvgXiGBHdmLw2obSpUuuwDBiMrd?=
 =?us-ascii?Q?P6ELmiHNvTGeXYGlNKx6h0zqtLRARby0yRsZjjdRs15MQzt5e9jcPe/L421K?=
 =?us-ascii?Q?37LhnjqYKuFrCcAs+upwaZf8gaqMlOsY7RS7HlfERlfzil9NOnQ6Fnt6kmct?=
 =?us-ascii?Q?WycZamxzq6QjEVErYJXk6rEwb8qvb3nZB2A8DbYO/Ab9dJXrbzhkCfmq9YT7?=
 =?us-ascii?Q?gou3mCk1YGkFGkZD8oWveJZTC5AMx04tQl5TZmwHCkJ3xiaC05nQEq528jim?=
 =?us-ascii?Q?DDIYNRRj532Z5Ct4ucoKhWi1VH7lRaYNAKpv9fQi/cpFH/+QIyMsgR2xLKPX?=
 =?us-ascii?Q?ufrWD0WEiJQ/Mb5Go7yTu6hXvxUK91e3BYg1hVeYTeIeak9RFEFynADBnoPD?=
 =?us-ascii?Q?dV2To+5W1ESrqxcpKIohgTNQPpCGsrGqaCMuyeYTHNTK8Hgiq3YRw4Goa8jx?=
 =?us-ascii?Q?phTzFl//4EM0k3gHIFdGr7mTmahAQe3pRML7LkULPQxrTvsjxSevQT39uk82?=
 =?us-ascii?Q?sAk1VWVIUppF4a/FAP0czU5v8gAO1Z+/GOF3ZL9RaPK4LFAx+nK6rI0PtcQQ?=
 =?us-ascii?Q?XkdPbEi/PQ89UQ/fF9isaWxmxyFxCnfCeof7CeeI07nIrSkWQXZffDuYEfvV?=
 =?us-ascii?Q?nxL2P4GIrwkJjQVwb54duHXH2mWSjlDaiJb/ew7sFn0Up4LJZwMdoNvQlBP6?=
 =?us-ascii?Q?hCPTj2vHcAaPeI8YHRGAIL4gM/IPVV00Lq+VbZrRSldheRnioBxCinG2bgFg?=
 =?us-ascii?Q?2e790n3JF01yG4P5dFWuK9RkrAa4JvFDkNNWCosb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf70ce0-71a6-4651-01e2-08dafe1a6c3b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:51:06.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZT+nLqhhW2FA5LppZ0dY5FE6A62/M4boekR0qbuqIgjw/ISqBgzE9Gx3qQWOw91
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5205
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:39PM +1100, Alistair Popple wrote:
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6..bc3a868 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -334,6 +334,7 @@ struct sk_filter;
>    *	@sk_security: used by security modules
>    *	@sk_mark: generic packet mark
>    *	@sk_cgrp_data: cgroup data for this cgroup
> +  *	@sk_vm_account: data for pinned memory accounting
>    *	@sk_memcg: this socket's memory cgroup association
>    *	@sk_write_pending: a write to stream socket waits to start
>    *	@sk_state_change: callback to indicate change in the state of the sock
> @@ -523,6 +524,7 @@ struct sock {
>  	void			*sk_security;
>  #endif
>  	struct sock_cgroup_data	sk_cgrp_data;
> +	struct vm_account       sk_vm_account;
>  	struct mem_cgroup	*sk_memcg;
>  	void			(*sk_state_change)(struct sock *sk);
>  	void			(*sk_data_ready)(struct sock *sk);

I'm not sure this makes sense in a sock - each sock can be shared with
different proceses..

> diff --git a/net/rds/message.c b/net/rds/message.c
> index b47e4f0..2138a70 100644
> --- a/net/rds/message.c
> +++ b/net/rds/message.c
> @@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
>  	struct list_head *head;
>  	unsigned long flags;
>  
> -	mm_unaccount_pinned_pages(&znotif->z_mmp);
> +	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
>  	q = &rs->rs_zcookie_queue;
>  	spin_lock_irqsave(&q->lock, flags);
>  	head = &q->zcookie_head;
> @@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>  	int ret = 0;
>  	int length = iov_iter_count(from);
>  	struct rds_msg_zcopy_info *info;
> +	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
>  
>  	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
>  
> @@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>  		return -ENOMEM;
>  	INIT_LIST_HEAD(&info->rs_zcookie_next);
>  	rm->data.op_mmp_znotifier = &info->znotif;
> -	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
> +	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
> +	if (mm_account_pinned_pages(vm_account,
> +				    &rm->data.op_mmp_znotifier->z_mmp,
>  				    length)) {
>  		ret = -ENOMEM;
>  		goto err;
> @@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>  			for (i = 0; i < rm->data.op_nents; i++)
>  				put_page(sg_page(&rm->data.op_sg[i]));
>  			mmp = &rm->data.op_mmp_znotifier->z_mmp;
> -			mm_unaccount_pinned_pages(mmp);
> +			mm_unaccount_pinned_pages(vm_account, mmp);
>  			ret = -EFAULT;
>  			goto err;
>  		}

I wonder if RDS should just not be doing accounting? Usually things
related to iov_iter are short term and we don't account for them.

But then I don't really know how RDS works, Santos?

Regardless, maybe the vm_account should be stored in the
rds_msg_zcopy_info ?

Jason
