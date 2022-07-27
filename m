Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47B158342E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiG0Umm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiG0Umk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:42:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C3250057;
        Wed, 27 Jul 2022 13:42:40 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RFBmp7019410;
        Wed, 27 Jul 2022 13:42:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=p1LukDoioqAOEZrRqXtv8B1zdZ2tCdYyYi5JHceByO0=;
 b=p23YyEIuLlG8lwuoDbryVQ5ulxsEMM4WynlyLlfxllhEh683zF6mDjYl2qro1nw5/A0k
 f/v+thKY9M6XbaTeGH7Cphmr/HdapGUhCYx4bozvqoxdByYcC+NVrQdoDcQq0dMfpt2j
 ZrdloDOk0jMvnXmTMCH7kuIxbeVK6JDBrsk= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hhxbx1rn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 13:42:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGA2Im1mda/MrbkXdkSj9TxIUvZAMRx+HvvhDi7MRLQZO25fupgz38KiVIliCp6ABP1ZlVaFtFFab/Ezou1sL2mK+9U+/hlOYBZmFg4YLJhoRDgawvrTKuBZjKSvqLXQQojKeo1V8Y7JzsDvxAqqvahZD3YX3q7OZjkRHBhOmIatdfrl67queHi59JI45PdCq7EL/jIdwORiloEkAUjRxaeqI0nDLE9xFLYmpHcwVMFDwoPFTBj0al3L3iNa2oJQ9RMygjUU9QCOx+io7/NYyHUrfoiGwjmKouCmr+QcgXpPKFpRZ5qxebGyL0Vmhvyc4J5lmnCiKxlaZsua5pPTOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1LukDoioqAOEZrRqXtv8B1zdZ2tCdYyYi5JHceByO0=;
 b=SJxmdaXjLu8WcqdVIOq9Jq78dIfpix1ODu+vIQpnSxYvN7rVMd/+swyn+xyVqQlco+6T8GdS/GM98jexKNLUWbck2vCwjhJV77O38uWYWIb9lYX/LKQIRlme/QavjhCIHFRk2M83oKH5tpYNV9XpbkcpO+IuZyr2X+KFezYbPIYl61a5W+tv19QasHk4knN8VLzXuDgx+c76CmPupKaGXzJbdjN8Ko4vUMhIwLz9ftz9jAiQ9g2tTtDYvpMGJPVA2e29M0+RkP+qItDjWdnvQcDIapyeIUw3EpK+ftKiQj+KVJg+naPSRRpY1n7feNGzbW8cNctPRG90ftVs1kuzkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB3289.namprd15.prod.outlook.com (2603:10b6:5:165::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 20:42:14 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 20:42:14 +0000
Date:   Wed, 27 Jul 2022 13:42:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 01/14] net: Change sock_setsockopt from taking
 sock ptr to sk ptr
Message-ID: <20220727204206.fhiamb66c3sljhg4@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060902.2370689-1-kafai@fb.com>
 <a9a3e00db4764ffcaf3324046d736b76@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a3e00db4764ffcaf3324046d736b76@AcuMS.aculab.com>
X-ClientProxiedBy: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37c31a37-2291-4052-f6af-08da70107caf
X-MS-TrafficTypeDiagnostic: DM6PR15MB3289:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ke7iC0odGg6lFpMhiqHFl23a/WAMkEQ1Z3Gc+evl+BRK3iB3QMGu4dhhqKot2Yy6JR4mW61IHKkMU9TBejrQSt2hVlxDkhmy8qvlT6N6Kv+2MjYZv5EikNnX7JlrbdHuXF4PfWToCuFYC0oingGFMVVfgg6ZEVaiUr35DrzYvhtZDKUxFc9s/FwnTRCgxP8Bf6LjF67o8iSrQpsLJnWsYYTQJLQdDaiilP7PRRSJEYzskFd0VT8Ez784+NjwNkoZaXTWdiIk+qsv5BBxmKYiyeHBpVtxktUScFGW1a9kBNG5WZMcgP2Rt6/jJ16PUvTcf33jltSNydGmQkEU9DET3ciosi3QK4b+Jt+q5Ztko9OrxN9BfM68GjL3Kkagc9wPr/pUBL5IR1//PY6DRAwq4Z9evZr6T8VcyU2qTy3nVjNvv6cGx2JjcEX2TafeHZ+ytVowFHT4bweWxRDMLYozx1ONp0T1Ah6q9Uj8tCvwq+Mx/L1sa6dgUNHH38HXmmmauR/xJVRulUAgshQrix49NaV26Cf6TUkU6s6b7D/FXsg+7CWSEXipP/Q9HZgNacpp5g5oT4dvyBBmqMEk0U8nBELR/xJEiBsT9aitnEgQGdzlZfvwziOXGml7oGGdEXlSD5qtwGknLjksT0iYX88RYP9rZpOq0vYXj+FOk3s3a8f7Kh+1ohzvpA6WmdUWUlzE0Qh0QXJhWSq2wUPHfH90jD16o0I3+r+nHd3GAAiyDCK1ZFfN1uLuK6XgHwijZK93
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(6916009)(2906002)(54906003)(41300700001)(86362001)(1076003)(316002)(6666004)(5660300002)(66476007)(478600001)(6506007)(38100700002)(6486002)(7416002)(8936002)(6512007)(4326008)(8676002)(66946007)(83380400001)(186003)(9686003)(52116002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WlMvcVM6oJNC+/6sJiaweLMhzSJqFrvzn4rRyeHs1RMvoUhP+gJzSXfsNRie?=
 =?us-ascii?Q?z+AcGC31ryCT1CU96OONpMcYQCGsD1NkJnaiswjvJ+9WDXoIJavQr6tDvFlQ?=
 =?us-ascii?Q?bF4W0KvIg6q6RKLINxeKzfCAXkKn7lvU1nYRZU5N3202vQNqmbREiBKDZv5K?=
 =?us-ascii?Q?qso50revpLqZjX7w6n4WP/k26bgC3U/GmJLxT0os4rET92ZVbHMM+a378i0B?=
 =?us-ascii?Q?m0qYnJUXt5CZrCGh2stfz6E4t1+x/mXLAYkkCavAPzHMV0x7E+Dld57Md/Ta?=
 =?us-ascii?Q?/LuFGC3Om1dSEtVGaNuw2Oqbm5xTc++n7tW/1UQlW7v1nSAUzz79GYIJo7bK?=
 =?us-ascii?Q?7erp6v3ypXvaTv9bd3LOXnlc1En9Sub/1wQJgo85/nowf1M65zSFSjBa0b0N?=
 =?us-ascii?Q?eJqP/ABWIns5LVRHhEFF9nCXe8+HEfHp55FDumdQ37PDIhtSTzMV32yccgbn?=
 =?us-ascii?Q?XOONfVENFWoddUA2pmH/Am2RX42SEi3842IUYbZdMSemJijmNHpBgCX1LKpc?=
 =?us-ascii?Q?hzdllJfWmmkfdKCbluthPoeti2b9ILYhLPcvANDky0u3RB9l/ctkYj9RW6QK?=
 =?us-ascii?Q?pHPDes9uMBqRgQvc80tepcDsMhR4s9wOPlNG3BDQTAcP2KAE5Lx1de2IcpH3?=
 =?us-ascii?Q?4AEnHbsUTCFVRkuii+ObfjPYsS9wECF7OTxnTFdtgCuAlEhcs3OFk3ZdvVz9?=
 =?us-ascii?Q?mrWJf9R4QJvma5XkgWQZUzxFdcWbjxTP2FZxNl6KGRQBNUyLdtn0hlV75eAq?=
 =?us-ascii?Q?bwzBXNeu1r4pV20yaMs33mYJwazvbge7BHnbVyJ4C9em4BIFbRp312yN880F?=
 =?us-ascii?Q?RF0Y04epDJcVS4nS3Npwi9KiyVQ7swY2z2epoJYTMu5bg1hpw6fGs5l6wUvr?=
 =?us-ascii?Q?9sObcQflUa8f0poY3YsJhqRVgNAeEhdRgf5wJYUHcKelP0NUpyERx6MO0Q9V?=
 =?us-ascii?Q?LmHJ+uXrN+errCUNQfCbSsXD0DCvDprJ28eeCm0BRbY8c6fGmRqKO+JuznGm?=
 =?us-ascii?Q?Hq+9L3uMttcEIv6mejVrpyriDkkeW9MTKb396QK/1OOym+bwBmiyzctuxFdd?=
 =?us-ascii?Q?8SA3GgKfTlxpI9go8m+DEyRblresqKDu8ge0jy0YKYE889tMAYDYI8nejyD2?=
 =?us-ascii?Q?vlbAv6+v9O345Dckz2VtSnTHOEh9veRHgIDl9cj8mY0qT6yWKNDC5GX/IZ6x?=
 =?us-ascii?Q?tmMIAuubv6X9Vo/VOp0X387/cpzzhLzknGfVye14nCdyXjA2KnklrZpshZdh?=
 =?us-ascii?Q?N+ylPwfly9zVl3TnB51kMrOsqZkc+4U6sFsJwZZ9wWSsTgTTGIgrI2iMdSwS?=
 =?us-ascii?Q?oR9SjlRVvY0Mlb2ZMQuwQo9rV4/hN6zMPBrFDF8MRZ9jrznSCCsRDl+FXYp4?=
 =?us-ascii?Q?Fi4k+/2raFtmqUaqt5JyZ2Zy4LNIw9m6XvtAzPRDtTKU6lJJZeejDQDJaRtn?=
 =?us-ascii?Q?Aowyhli2PGBoYhwf/Fvl3hY2lshZPJwLzidHc/BQBLB/i4M3XtanYFwj1s8Y?=
 =?us-ascii?Q?07RzqApRuxX6Be9OOQ6jjrdztpBDFlWYOvSExu8LJ7dEKFKJ9yWPETtj7Q6p?=
 =?us-ascii?Q?KHVJnBah52dplQ/WysRSayK3AAGQaObkfK+kfGNTxoO5YFYHEJGT6s8AR8Gx?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c31a37-2291-4052-f6af-08da70107caf
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 20:42:14.1759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 250yqghVKYw+zZPpo5zpq2rA25bPngfM5ekC/6OJjT86rncWDXRMiLF4otdOvZOo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3289
X-Proofpoint-GUID: g6fMU2UO_R3AA5DI9LlOEvAc4aMoDEsw
X-Proofpoint-ORIG-GUID: g6fMU2UO_R3AA5DI9LlOEvAc4aMoDEsw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:11:26AM +0000, David Laight wrote:
> From: Martin KaFai Lau
> > Sent: 27 July 2022 07:09
> > 
> > A latter patch refactors bpf_setsockopt(SOL_SOCKET) with the
> > sock_setsockopt() to avoid code duplication and code
> > drift between the two duplicates.
> > 
> > The current sock_setsockopt() takes sock ptr as the argument.
> > The very first thing of this function is to get back the sk ptr
> > by 'sk = sock->sk'.
> > 
> > bpf_setsockopt() could be called when the sk does not have
> > a userspace owner.  Meaning sk->sk_socket is NULL.  For example,
> > when a passive tcp connection has just been established.  Thus,
> > it cannot use the sock_setsockopt(sk->sk_socket) or else it will
> > pass a NULL sock ptr.
> 
> I'm intrigued, I've some code that uses sock_create_kern() to create
> sockets without a userspace owner - I'd have though bpf is doing
> much the same.
> 
> I end up doing:
>         if (level == SOL_SOCKET)
>                 err = sock_setsockopt(sock, level, optname, koptval, optlen);
>         else
>                 err = sock->ops->setsockopt(sock, level, optname, koptval,
>                                             optlen);
> to set options.
> (This code used to use kern_setsockopt() - but that got removed.)
> 
> I'd have though bpf would need similar code??
By no userspace owner, I was referring a sk has not been accept()-ed by
the userspace yet instead of a 'struct socket *sock' created for
the kernel internal use.  After another thought, that tcp_sock
is sort of owned by the listen sk,  I will rephrase the commit
message to avoid the confusion.

bpf prog does not have a 'sock' ptr because the sock
has not been created yet.
