Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3433468B501
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 05:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBFEu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 23:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBFEu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 23:50:56 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6F91117F;
        Sun,  5 Feb 2023 20:50:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwLh/EZ7zituk7GeMGOsmWynLrux6zj8dDJ0Hv5ROZtKyO0sXaKHYRYyLw1F5+M3jh4+oEOvrqgd45a53vuES0gx80q5mjeHkFPPg5d3bFoDV/MtUZy+aTmKBgpiy9qAyvyPaKgGJycHOPoWF7m4JLaqkxgDF0KScGR9Vsghkw9UtigwPKpV6L8AGvRiy40tcbz8gvZKnCfE5ph2suLalArwbgpaGkZStaCHh2s2pNJWHLwM3q9i+PH16YrVhd1fXyLwlqElGZyvDQL3FdKbPKF6euNiK0mSPYrIpYExBTbtYjk53iyK4SLFB6UOzxu1B/j5WsliDHE0GUVe32z1Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V+4PXpqcCeX1uE8aWt3DfoVSzDIUjmhLieV75BId4Og=;
 b=eAX03WtB1Zul1LBWl/sFziENNULwokkdeuYxjmWu4SSVDeIXfFMIJ3pBvW8gijaym0qku3yAIlDxocOMRQjjtQCA+CoQpIxDgiEz8OGLrMQYkrsPmwOfkYMThd5g8s7/EyH1/1zPK/556Lw+GyCIqucVfZvx3KTqv8SOeVAhkwUIx3Rnx08toGuUBojvmtIiEeJGWncDNQnDWlJqyEtaVSUw17AIAt+R+LoP5gg7W7hWavmhdJWNZVPwjaP8IJBr3RB+ZNuaY/FPy6RtM4+Pkr2J25WXkM6dAISdsB3hK3FnYLlOOuVs2ggdQw1rzZjUGkKJciunnrgA7idQWxgkqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+4PXpqcCeX1uE8aWt3DfoVSzDIUjmhLieV75BId4Og=;
 b=VVDpLU4oKKHBHxq0kEWsjZacZ+4lj+pc5NNUckwYV53EHuurMOKlHhmUV2eNfd9KbXAmzv9H/MsFpxecL8jIZxtKj/9UmTyyJOcOYBBDvL6wggi9OhcVVnMx0340exVgJXCKA6tbxh0mHMmCTLPfeo/P3IIdRJOvLYFQH+sDtuabkCSe55aqTudDCfmujdeM3k+bCeeaSpC+cBkK/9r4MCSDgRrDU/BbxR5MHJp8+6o5p2B4w9nf1RMlpIcNDwYXBAl0Zcs7t9GE0V9+sj+X4l2pV0GNMkR9YqH7j+nuyPVXK/R0ddc6C55A5/MFH6ZaopYeQgG4Uxpk0+6VhXqc5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB6278.namprd12.prod.outlook.com (2603:10b6:8:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 04:50:49 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 04:50:49 +0000
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
 <Y8/wWTOOjyfGBrP0@nvidia.com> <87pmawz2ma.fsf@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date:   Mon, 06 Feb 2023 15:36:49 +1100
In-reply-to: <87pmawz2ma.fsf@nvidia.com>
Message-ID: <878rhbflcs.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0077.ausprd01.prod.outlook.com
 (2603:10c6:10:110::10) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM4PR12MB6278:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c1bec7-c191-499c-1fd6-08db07fdb7ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U49I5pHnpMQt6nKPIn9u5RjaFbhKCrslAXQ7FlhkvYe2ZxG48kVs1WhiYYRIcJu/4o/ChmxNsiWTv3Jvan/r4yXE1XTsRNh8/aDBiyO71TaQtovqV0ayJs1tKNuUEB4jXri7i8MGTUumQwY7s4DmknX1k8OQkiEzpG+FLnYZ/6Wg/K1qAi1nCCvbD1ZBHFuAG0odAREMBX7/jShbOygWmRwyjlt53V4rLec89Zv/EY8I0BinKoxPJvlIng+pMtzbEthh8CQpEzwB5nOiiSqXWMvUMnqwzLD+pthIrU1Fkh6tfcWt2k8ihGSOzdtbSb7vWUpQ+OgkkCYAyQyUbZRf1ekMopuwHVexxVMNPg8JqOqdEL38COmi434x/df3EsvQmfDjBwA9V95/UpLFVr+66W9n+fViogM8+N4GPdZjhc/vsKvvt6X+VCh9Ey2Niefc7kppB+rETh3T8upwE5m2PVFru6s747MCpgJ1dbYHVvYSGTt3JRCOKqqy7FlPqnNQS9KfEGo8/whqbSQ04ivFyRcXXNTqAgWemuZ4HdzCfuNbFhnXku6KutcTb7FfuHioSoqiFDWkXMZdlS9ixgfylYoDO4WS7N3Ury0VjqLgWdy/DTnERPeRGPQ4cczUh6cVQb40uv4W3tdY3PGL80YqMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199018)(86362001)(36756003)(38100700002)(6862004)(37006003)(2906002)(316002)(6636002)(6486002)(478600001)(41300700001)(8936002)(7416002)(6506007)(66946007)(5660300002)(66556008)(8676002)(4326008)(66476007)(83380400001)(6512007)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xY/A565GFHmYLgYYkEEsOAPRt+9YU2kd+p1H1lzHlXhGF22HpMWbfBdlTDYH?=
 =?us-ascii?Q?g/8PkQq33mo/SNHCBzO7I42o588XzYtcKjRgWf7UI3KjBQ5wXkGdHp6/z9Vk?=
 =?us-ascii?Q?BREfyzXKgcM/Zl2DCCCxYjhU2uUbx0oFeM4x1fGI2IeVhLrYcKSgHKpzoy2F?=
 =?us-ascii?Q?wFIKti80JN6ZeGUyg3tuIKIwAguYHc6uIkNbT5x4icWPLf3T2f3q93DjnqEO?=
 =?us-ascii?Q?jtTDSDN9ux3bqX8x4gjVNfKG6MdjOrk0mucewSxdUyEmSQd4+VOF3AzTxMeh?=
 =?us-ascii?Q?Nb95Nqy21z5Cl5QJNj0saqYUlnaLdQGg1b5JVo8ZC6+1tdOxABEzLdsolPLZ?=
 =?us-ascii?Q?cwIhtiovi57GvOzXm1bvVP9LUtvIH+vU5J/f649GkBZL52Hytf39IcBq+saF?=
 =?us-ascii?Q?7dygI+nobbevaH5hc9mdYsOsHiDg+tP7PtIUwC43Q4mMWkY5GnEObMv6QEvX?=
 =?us-ascii?Q?nKy4NUsSViQHnIJbkS5i5a44mOIE/sbooy8kw3tClP5a4D7pwEuQzLfQ/yGy?=
 =?us-ascii?Q?QSP/K7PkLK3s8ygi5pwt76LlaOGpEsSCaJQpcDwXQJqF8RJ/86JinXN/n6sG?=
 =?us-ascii?Q?uQQrdHEfL/nl5D+E70dCzNLZruzSZKiAqDlXVmB/kZVheDsWaKYiG6iUOcGz?=
 =?us-ascii?Q?dnphdk9XDKjyj3VkbT5z/gcD+xmqFBpI2fNBumqOO5TDxhWM34ra8NG4U6qf?=
 =?us-ascii?Q?TAAUf4yyqyrUsvk6QMolMNR3l1m0uOEqCNYyt1cMvPPHqeYOAsyDGD9amW34?=
 =?us-ascii?Q?gVjnfsK8BVi9ksccJeL0qPrPm2175RS79l6sWuWrflwTwwBnk3HSTOJ+Xx0g?=
 =?us-ascii?Q?+lVktDyk1NbTO5+8vw3bZD5XtPd6F18xHGRRGNWfXNp+rfr4ZUMuyNIp2lM1?=
 =?us-ascii?Q?UT4wRAdyzTfUDmKQjj0FZvWBBMq/l/YEqebtnOyxXfefz+vR/B/iVVyi+dSZ?=
 =?us-ascii?Q?NzIU7bQFM5REwaCfsWj5VKUIKED6Mrzj4fLjVu0nVByLEdHXdywpDp6UNidh?=
 =?us-ascii?Q?8RuhyyWDUykRDJSGsN9MILyviwonHHr+4XuZ3gJzJFi8sqR1frUHDhWAXtur?=
 =?us-ascii?Q?yJzxmq63leQnkJWlAFcghDn3r+C++2HJkOQKTozgx5jLm5vGL5yKIa+ztUmP?=
 =?us-ascii?Q?8oHiut+hVQPzaQGUYxH0gu3IBbMwjasIYCwCJojHqrIXm3utZK+Cc8btD1YZ?=
 =?us-ascii?Q?qbKXyPnKVYHleZH1qneVhvfErDPfZCabTUbQwH+8MXESn63ff1Xe7jeiJfsy?=
 =?us-ascii?Q?go57tUOWcTdYjmEZCTwqUMYgdAss1gCnm5MrOBBKOo+oNXyZnQI//fZprdD9?=
 =?us-ascii?Q?0af4o2tAQ+chX2fJeaWI+ecdCw2PRDNK34w6pZzMbohSrn+W+vn+IfKaHar4?=
 =?us-ascii?Q?1t/c7QHYl9cq+GN59+wBUbCiE9Jhc3Rczn9o/IjgbTEXsqclY/THkuQtZGeq?=
 =?us-ascii?Q?4RUboZssJqGLn16o48sIxDArKmvrahWc4Ohbo9U/WRHOvyIjsFfw5SLEH/IB?=
 =?us-ascii?Q?3D5hBREYA1a4Qi6EitfqdC63/yQCW8lNVJ6AKYkFLbf9HbwiaPyxg1/4Bnhb?=
 =?us-ascii?Q?LhYJKCKuRv4+9VZvBrb7AIsRadeFptN7xAgsfCtX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c1bec7-c191-499c-1fd6-08db07fdb7ba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 04:50:49.5636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+DXc+4jzmpz1iNPevaGF1VZPB0HoC8Q+8HoDDFdI7lgDIs8T2xqvg/tlLAHZcjmMOmR0XaEzHxnuo5jCW9oOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6278
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alistair Popple <apopple@nvidia.com> writes:

> Jason Gunthorpe <jgg@nvidia.com> writes:
>
>> On Tue, Jan 24, 2023 at 04:42:39PM +1100, Alistair Popple wrote:
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index dcd72e6..bc3a868 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -334,6 +334,7 @@ struct sk_filter;
>>>    *	@sk_security: used by security modules
>>>    *	@sk_mark: generic packet mark
>>>    *	@sk_cgrp_data: cgroup data for this cgroup
>>> +  *	@sk_vm_account: data for pinned memory accounting
>>>    *	@sk_memcg: this socket's memory cgroup association
>>>    *	@sk_write_pending: a write to stream socket waits to start
>>>    *	@sk_state_change: callback to indicate change in the state of the sock
>>> @@ -523,6 +524,7 @@ struct sock {
>>>  	void			*sk_security;
>>>  #endif
>>>  	struct sock_cgroup_data	sk_cgrp_data;
>>> +	struct vm_account       sk_vm_account;
>>>  	struct mem_cgroup	*sk_memcg;
>>>  	void			(*sk_state_change)(struct sock *sk);
>>>  	void			(*sk_data_ready)(struct sock *sk);
>>
>> I'm not sure this makes sense in a sock - each sock can be shared with
>> different proceses..
>
> TBH it didn't feel right to me either so was hoping for some
> feedback. Will try your suggestion below.
>
>>> diff --git a/net/rds/message.c b/net/rds/message.c
>>> index b47e4f0..2138a70 100644
>>> --- a/net/rds/message.c
>>> +++ b/net/rds/message.c
>>> @@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
>>>  	struct list_head *head;
>>>  	unsigned long flags;
>>>  
>>> -	mm_unaccount_pinned_pages(&znotif->z_mmp);
>>> +	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
>>>  	q = &rs->rs_zcookie_queue;
>>>  	spin_lock_irqsave(&q->lock, flags);
>>>  	head = &q->zcookie_head;
>>> @@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>>  	int ret = 0;
>>>  	int length = iov_iter_count(from);
>>>  	struct rds_msg_zcopy_info *info;
>>> +	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
>>>  
>>>  	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
>>>  
>>> @@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>>  		return -ENOMEM;
>>>  	INIT_LIST_HEAD(&info->rs_zcookie_next);
>>>  	rm->data.op_mmp_znotifier = &info->znotif;
>>> -	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
>>> +	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
>>> +	if (mm_account_pinned_pages(vm_account,
>>> +				    &rm->data.op_mmp_znotifier->z_mmp,
>>>  				    length)) {
>>>  		ret = -ENOMEM;
>>>  		goto err;
>>> @@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>>  			for (i = 0; i < rm->data.op_nents; i++)
>>>  				put_page(sg_page(&rm->data.op_sg[i]));
>>>  			mmp = &rm->data.op_mmp_znotifier->z_mmp;
>>> -			mm_unaccount_pinned_pages(mmp);
>>> +			mm_unaccount_pinned_pages(vm_account, mmp);
>>>  			ret = -EFAULT;
>>>  			goto err;
>>>  		}
>>
>> I wonder if RDS should just not be doing accounting? Usually things
>> related to iov_iter are short term and we don't account for them.
>
> Yeah, I couldn't easily figure out why these were accounted for in the
> first place either.
>
>> But then I don't really know how RDS works, Santos?
>>
>> Regardless, maybe the vm_account should be stored in the
>> rds_msg_zcopy_info ?
>
> On first glance that looks like a better spot. Thanks for the
> idea.

That works fine for RDS but not for skbuff. We still need a vm_account
in the struct sock or somewhere else for that. For example in
msg_zerocopy_realloc() we only have a struct ubuf_info_msgzc
available. We can't add a struct vm_account field to that because
ultimately it is stored in struct sk_buff->ck[] which is not large
enough to contain ubuf_info_msgzc + vm_account.

I'm not terribly familiar with kernel networking code though, so happy
to hear other suggestions.

>> Jason

