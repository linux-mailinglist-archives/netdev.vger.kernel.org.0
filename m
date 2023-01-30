Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C39680BD8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbjA3LZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbjA3LZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:25:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A171F48B;
        Mon, 30 Jan 2023 03:24:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/xWjjlo24/hDcLSh0m5+iFWOjholfC9hlnCWrMjQJrl9OkDcabwtiX6YsDqV/Cr6BDIznoHr9IBzFYMIMZwAQluMeRTEChyVQWV4Y/m7h0esf73wjxPuPUEZofF2E4vNiLiwmOTBONpE4zPfJ4eFgy+V83d/cFyYE5kPcgMIBBj+9XSqcVtDYHEWtVVDDnuCu760yDq6VipTaNXyD1J7bWE5HNY+uhOCzwIg/IietxzKPRcW1Y5aDr5IGoLFLu8crePMOubXMpBEQQUwiy8AQmizfcovdoIlqDAtCV2bUme5gY/m9temQdh3tZbe4Lak/qNoHvHZHs8eGpZ6otvsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi0a1JXB1cGcFPTt3q22VNEdnLnaDTHalmup7TcwS7U=;
 b=gsRbWeZl2y2VRxAxEyr46DPhFetWYI+vWPYOJJXM4JFilsTnyoBGfvTmUs6yQ4aroZO0PqTG8Or8vT3dTPw3rTf9jEaJje0FQwuVJoy0lUmrgQI438+6Veqc9YUPrIW9yT+iyvhp7koEuk/x4mlELiayCIsX6WPYoq6MI9GhQCRQ1QVN8XwXRB+Ni1/l6VJfHx97w9oRMfh9cinf6duF6PNUVCp96R1SzoItUi5vFRxNrMyMPapQ0iW3NRBCqRYX3lGmemSgC1mtrgb8RIc0+GnoYvRpMIX/c06w1Fd2HxUwRSguiA+5Fytu6YrEaAjmX2XSXOMBShR2N+h1DeS3fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi0a1JXB1cGcFPTt3q22VNEdnLnaDTHalmup7TcwS7U=;
 b=X+an6WzZ/iO4RB0FQnOau/akl79bJyMymk+3YsWFT1+K/hpUMrD5f+Ad7K90+bFU7nQPCb++Oum/c9VNwmRbJt138IVFBGoDqQzkTi3/X2t12X+9bqD/w8PTM5vSaMSjyVW2ll2QmtTcHymnVOlrhoEGuFbVY2Eu6rAGiXZMASydiXfv3rJOPXkoEgoNoRfO0akLB5Qf5llJzFEVvaxD2oMgCgD9oNLvgvj7GnY0J3HVptIrGPUGXslQLwAuLRU38ijDZaOyK8oLAEocOYma1wx83YJl1kIEhSuWw0TP0d5aUjpOp5DAz7FzCK1r2GX9iR9ITaeRj4vpprjA4qJ3/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM8PR12MB5432.namprd12.prod.outlook.com (2603:10b6:8:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 11:24:52 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6043.023; Mon, 30 Jan 2023
 11:24:52 +0000
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9b54eef0b41b678cc5f318bd5ae0917bba5b8e21.1674538665.git-series.apopple@nvidia.com>
 <Y8/wWTOOjyfGBrP0@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [RFC PATCH 10/19] net: skb: Switch to using vm_account
Date:   Mon, 30 Jan 2023 22:17:18 +1100
In-reply-to: <Y8/wWTOOjyfGBrP0@nvidia.com>
Message-ID: <87pmawz2ma.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0032.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::9) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM8PR12MB5432:EE_
X-MS-Office365-Filtering-Correlation-Id: 65205dcd-8944-4c62-da33-08db02b49adf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ACZdb4BpPVFp7h3wQtnPhQL6KlqB/82JMiX6s5CabgbGiycwIk0cK+pvksUv37K4cVk4s5bGlD/e5bPgVf4YnYAegMWnafwLu+I2UvMz1wDClGMXhPx3bQykHupOIukD2yczLCAIw/Dwzzo5dBlbqgg2GvRI3Lxwi0Mc0kFOMRMIJpPwJk2a7Xd2Zwv6BUeYX3aXpbzq7TlPrlBCtm/47Z2/o7Kr46bObLZUADgwBKYIc651/Cbgc0qIjzL849mMKtbiT/sTjf5SwN6B0uuiWjGE5PrqjM/JllEHCmSQ94ZE2VpcIl1XLCUP8Cec+mek4OCgfBW+f7S4u7eXb4Vmnb9SXJlgNkBcLvsAtLcOhPrAnlxnJtk03vdUvn3zRDnpvmbyFoao4YduqC/dRLquuCGv2hdjcnLK/7XOd2rOpj8AGEwp91PDXWmdPT79pHuH0suBv9JKXfsHJJFASHcTYfbjtM/v2ck463P6oQeSRGIirADMKPxvfSP79eeIrcuPOr2ZczZQXiml0zBMJCyvae7hnD+gMRlldS4LBh90oBYRPwdiJspYZZVr3yNg+B+Yam/a9RRltUhVfLmxxgvo8gF8b1x6bnsKnnKutQIdpRd7aTLjuYkqyQtb/P61OXRr3IAblsc0gvNhP8zRW6yk6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(8936002)(6862004)(41300700001)(86362001)(5660300002)(7416002)(83380400001)(2616005)(37006003)(6636002)(316002)(66556008)(66476007)(66946007)(38100700002)(4326008)(8676002)(6666004)(6512007)(26005)(186003)(6506007)(36756003)(6486002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qzRZ62TLk/RG5NoGVprRSUMF0w/KSBts6RhMaXHJvv2icjVGHFfSDcJKQmrQ?=
 =?us-ascii?Q?RfZndqH556LBxWXDAVBu6BxS+X39T7P6WGFeULrupmXsIwmyfnrWhXC3v433?=
 =?us-ascii?Q?XUzXUpYqnfCBZUbj+eLedI/Via5Nwyl+ahovb+x1CyOJA5mvOf515vZxz/Bj?=
 =?us-ascii?Q?r60AvZ/jN6wckCyOBpxbejjb+yGINwh0dyAyf6gBs0psmpTiE4YILHKTljS6?=
 =?us-ascii?Q?0SQbY43R553wMHAdi6PIAb6X+UasbZDjeDlF4X6PnI3VadqMVREBE9FT4ZDL?=
 =?us-ascii?Q?4Uc5bzDrQ0Dv7N/t/9kGSGQrqcG+tJKb8wSh2AdWJHeWQq4EfGMlyA8VWSQw?=
 =?us-ascii?Q?12Fz/eod2iwtRtp6o54/Ua81pFYQdXQYXQhGbQNXZCaZWKQr5lmwoYFDm5Zw?=
 =?us-ascii?Q?BjoX+N0/o5VyVaakBWG4s9EcOy/pckv2dvmScc6Lc1/TBRTxKtjhK+U4R1mh?=
 =?us-ascii?Q?X1dqyjNu0W++so+PkqjP9K5SDmuQyRjJVTTbiXDN7tkV+f99AWZGtRjnmb+y?=
 =?us-ascii?Q?UPHP5MY8HwIaI7qkLDh2iBT5PGZ+nwl1QVkcHDDiXBa70v7HH3ThRUNWXMmH?=
 =?us-ascii?Q?u51AJihDt+x5Reva8W6EcHiojoqqQLAwltvvMXnrEzD3GU5VNTyE7lyObsDS?=
 =?us-ascii?Q?Ac2Y6lEwXKSZiIqslIJQkorgXx8JKxPqrCTeNtSX/RNhmInTAaAm2UdCJ2YJ?=
 =?us-ascii?Q?OEJ24EFVPybBq0kYDPP3t12/nRl5JEYLYUr2uyHe9dzJ4Qq8vHyPfcKmh2FM?=
 =?us-ascii?Q?I+0D6hoDZuX5FerVCji8lvHFVD0EDJg/YMZMw62GG/zIHE7twOx7i7/I8uOK?=
 =?us-ascii?Q?gGk8iAH1wA4pt09lwCLEnzhaYfBFdQIex7bj3bxEP1EVJIGtbB6QHYmI4AMQ?=
 =?us-ascii?Q?yrKvi1pbF/gJmhgaO+uVN/ytBPjhxXddBJKdc3/12gUGxD53bJMlCrPWrSZE?=
 =?us-ascii?Q?xWMjlpKmeK5z3l1q1WohxISiscZmhJblm1EBVclJ3eOcO8WRWdWY6PfJTH5z?=
 =?us-ascii?Q?Gh5HmQOcBY3IMkGnWeo5PNeC2ZQjaGb8IUHiUCIZTRGLQ0gpSkPvGVzrCSA8?=
 =?us-ascii?Q?VqPF7G//CrfZq5rn14s4gGrZebFFNG24oGQONAPVF3tmMOlIen0zcUREmazJ?=
 =?us-ascii?Q?8RrGurwQ60raQpk2Yg6dZVu7Ngh3ONqcx/dqO4x3nOEMGHU440zu4rwwaHy8?=
 =?us-ascii?Q?pn/5lvv7589VBhiBOHbCGu8pCMuQd6KNNu3tJBsrhg8hCINaXUn27Pks6JlJ?=
 =?us-ascii?Q?CsWr6HdonfZQOLEbNn6o4QvfG9y8OEGEgbpPSAsxGSb9r++cT+0NYz0cBdJC?=
 =?us-ascii?Q?21SlT2IRVjyYP6yGDKdCyj5XWnYDVF53nA1IpZXHMDIIEJw3XbDRd+8oDJ+z?=
 =?us-ascii?Q?m24kEvnYKPthky0fHTZ/m2/Xv558m5VLdwxkJ2Zu3Hf/W3z8dT274YfbrGxJ?=
 =?us-ascii?Q?MXKqth9s4/QRYm3kLzJDnp0seWVWP6nnozmhjJy6TT0rhif1LMbHTrA5uVYe?=
 =?us-ascii?Q?gKts4M/r7aq7P7yJQomW+fWJeJHOIX+MJUUlX5+cYidFbzeOfwmviJ7qh85J?=
 =?us-ascii?Q?L+iaftOoKbnqzlavjsEHUGdb+4qgfAiz5kvA8WvZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65205dcd-8944-4c62-da33-08db02b49adf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 11:24:52.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2zgMmggG2blBDeGhjtB4VNuSc8n2YQmzzDI+jEmYrTQRVBIgs6GYZHvUba5K3fs5k2MhCw25qoz7GBsBNIxBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5432
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Tue, Jan 24, 2023 at 04:42:39PM +1100, Alistair Popple wrote:
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index dcd72e6..bc3a868 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -334,6 +334,7 @@ struct sk_filter;
>>    *	@sk_security: used by security modules
>>    *	@sk_mark: generic packet mark
>>    *	@sk_cgrp_data: cgroup data for this cgroup
>> +  *	@sk_vm_account: data for pinned memory accounting
>>    *	@sk_memcg: this socket's memory cgroup association
>>    *	@sk_write_pending: a write to stream socket waits to start
>>    *	@sk_state_change: callback to indicate change in the state of the sock
>> @@ -523,6 +524,7 @@ struct sock {
>>  	void			*sk_security;
>>  #endif
>>  	struct sock_cgroup_data	sk_cgrp_data;
>> +	struct vm_account       sk_vm_account;
>>  	struct mem_cgroup	*sk_memcg;
>>  	void			(*sk_state_change)(struct sock *sk);
>>  	void			(*sk_data_ready)(struct sock *sk);
>
> I'm not sure this makes sense in a sock - each sock can be shared with
> different proceses..

TBH it didn't feel right to me either so was hoping for some
feedback. Will try your suggestion below.

>> diff --git a/net/rds/message.c b/net/rds/message.c
>> index b47e4f0..2138a70 100644
>> --- a/net/rds/message.c
>> +++ b/net/rds/message.c
>> @@ -99,7 +99,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
>>  	struct list_head *head;
>>  	unsigned long flags;
>>  
>> -	mm_unaccount_pinned_pages(&znotif->z_mmp);
>> +	mm_unaccount_pinned_pages(&rs->rs_sk.sk_vm_account, &znotif->z_mmp);
>>  	q = &rs->rs_zcookie_queue;
>>  	spin_lock_irqsave(&q->lock, flags);
>>  	head = &q->zcookie_head;
>> @@ -367,6 +367,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>  	int ret = 0;
>>  	int length = iov_iter_count(from);
>>  	struct rds_msg_zcopy_info *info;
>> +	struct vm_account *vm_account = &rm->m_rs->rs_sk.sk_vm_account;
>>  
>>  	rm->m_inc.i_hdr.h_len = cpu_to_be32(iov_iter_count(from));
>>  
>> @@ -380,7 +381,9 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>  		return -ENOMEM;
>>  	INIT_LIST_HEAD(&info->rs_zcookie_next);
>>  	rm->data.op_mmp_znotifier = &info->znotif;
>> -	if (mm_account_pinned_pages(&rm->data.op_mmp_znotifier->z_mmp,
>> +	vm_account_init(vm_account, current, current_user(), VM_ACCOUNT_USER);
>> +	if (mm_account_pinned_pages(vm_account,
>> +				    &rm->data.op_mmp_znotifier->z_mmp,
>>  				    length)) {
>>  		ret = -ENOMEM;
>>  		goto err;
>> @@ -399,7 +402,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
>>  			for (i = 0; i < rm->data.op_nents; i++)
>>  				put_page(sg_page(&rm->data.op_sg[i]));
>>  			mmp = &rm->data.op_mmp_znotifier->z_mmp;
>> -			mm_unaccount_pinned_pages(mmp);
>> +			mm_unaccount_pinned_pages(vm_account, mmp);
>>  			ret = -EFAULT;
>>  			goto err;
>>  		}
>
> I wonder if RDS should just not be doing accounting? Usually things
> related to iov_iter are short term and we don't account for them.

Yeah, I couldn't easily figure out why these were accounted for in the
first place either.

> But then I don't really know how RDS works, Santos?
>
> Regardless, maybe the vm_account should be stored in the
> rds_msg_zcopy_info ?

On first glance that looks like a better spot. Thanks for the
idea.

> Jason

