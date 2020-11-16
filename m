Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9AF2B4FF1
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgKPSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:38:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23932 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgKPSiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:38:24 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AGISYi4004608;
        Mon, 16 Nov 2020 10:38:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AeLIxK2SP3qoMJ1ATxVvKqvldHqC1JmXIzEdIYOGnc0=;
 b=HcaCt0sDMw6X41jO+1RcN8j/BQB/jZXRoBNLmvN2fBUp9C7vJs7RHqdSj//teRPzaySs
 0Uqt3MTCnc4lzZsYOEUpamdaqI7jT0Ws3F9oSdZ7jLqCJZ9aHLgmL2sBlN2O0JuOYIwe
 nDeNYT2IRABpG7CJjAs0HoEbjHgJq2b0FXE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 34tbss9cbv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Nov 2020 10:38:02 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 10:38:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTQ707UqLW8oMOsSkgmiEY3pajVPjxLdaETh8HmE+i7tAQE9NcOMInNzGPzGwj5CFxilkATTBKKpdopCVjvZ9inVzjb0OSEKa/UVq0fNEgHWbeEZy1oAoxLi1kDKhMWQxUVAKW5nsYAqnk5uuhDL4GjlL5KH0R6Y0XypNivmJ468SAjTTnKsSqJD9JT8Lp/iGcGyI9El+5WYuKUvIyDmSVJ0H39oyMSIgJOEfVDWsAiFwfe3ql8DcLP90VgDvLTkKm9VURMXmtckP4oHNXQK7gHNjBZx806uhqmn+6gxad0hj2UoSvFbJfsY714R185fbdep+MAV8SsnwETpgRoCww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeLIxK2SP3qoMJ1ATxVvKqvldHqC1JmXIzEdIYOGnc0=;
 b=TxHuk1APxrXN+Y+gRVIg/BQvg5j/30clhe9W8flQ0krdfJ/kWT9lBEnEQqSKter5tuD75kvBCtZaoIWRaCa3to3ln+kB7Uls25Gb78sAonM25xlRE2JQC9ydYiYHM1WqR/lINXy+UIb7NThUHX1vUCOuPYlqYlk//c+Weqox3OpMD/cEt9c2sg08KXp+JMKw8i3gBXQnESjD2MAY3BK1DSlV4n97+Z71IBMvyuEFcVu7bt/HwAhaIYSaB084FA080+8td657udwN8tTTdpt4rbTZJSqc1nt0eJU7fsgcjMX9QWJgd6/IRLZD00IQl44D/tkMZX51VdMeY3Bq0m4XbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeLIxK2SP3qoMJ1ATxVvKqvldHqC1JmXIzEdIYOGnc0=;
 b=M3zQQmDSQTicmb+reSnVuqCOF4O7hM27ObHTPLUQnoyBc01WBxjw8pEjuAP802G9jiPxzS/AABkU49akPY1FvZfAah8TT765jBdO23MGhrxnMfdPibOCnJkgKzt7Bn6YU4f9rN6u8OmPc9YMI344rc12/O2/X6QSZXn24/iAzX8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Mon, 16 Nov
 2020 18:37:56 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 18:37:56 +0000
Date:   Mon, 16 Nov 2020 10:37:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201116183749.6aaknb5ptvzlp7ss@kafai-mbp.dhcp.thefacebook.com>
References: <20201112211255.2585961-1-kafai@fb.com>
 <20201112211313.2587383-1-kafai@fb.com>
 <20201114171720.50ae0a51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116173734.a5efp2rvg43762ut@kafai-mbp.dhcp.thefacebook.com>
 <20201116100004.1bc5e70e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116100004.1bc5e70e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:8f7f]
X-ClientProxiedBy: MWHPR14CA0042.namprd14.prod.outlook.com
 (2603:10b6:300:12b::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8f7f) by MWHPR14CA0042.namprd14.prod.outlook.com (2603:10b6:300:12b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 18:37:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 316622cb-eafa-49ae-1664-08d88a5ebc2c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB346169953B20616BC0AFCC24D5E30@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJcXKxtYgLoTuW1GGiN+xoj6bLH0InZ3g8fGHFbnUY628sRsjGRiW7cApaqXgcQTOEgCSRvdin7FOknIu9k++cmJvb9tfNK3pd6Khj2aVN9TNidUNYYDuIpm49KX4t6wdogXPPpgsdLRJEqDbO+YZzAhWbDqtJilXD/MoqXn3zn3sd1v8PvR9Y8JbrfjpvX+/K/rR1RDmHlU4FlUN8lYOFVF0Qs/O5HUD8gHwaWk1KDVB0yvm0sOTnVtRhq+m2t2afrvHxTW7OSUxNkH3XKnqmz3YRg33kgD8qjKoa6JkLfwvfBFi8c+HD90aNcFCHV3JVkBCytu42SiRMYG6U2GIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39860400002)(366004)(6916009)(6506007)(4326008)(6666004)(2906002)(8676002)(7696005)(52116002)(5660300002)(1076003)(66556008)(66476007)(66946007)(316002)(478600001)(86362001)(54906003)(8936002)(55016002)(16526019)(83380400001)(186003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: CGnu4mz/yczKBEvp8yCTsyLlRNsLhvMZdbQQNLZMstBK7h4ssE359a/m+S5MxLTueFcD7FTFqNBCyrF13omoLUMaciSdQo2Mg+vHGAJ2u4hZhDArapHEEUI/LiGR3dYZNudknsTqFtP2G7iVbTLuflPcSA5Qfml1u2vebXLo9VZXbRSJbWOFlL/IhVBAM8ZDOwPqNFFK5JghuRMwjcDNhPGwau52TMsaufU4D6WIZR96ik8l+B3ckXJ6W3hEwd9bAAL5B2Vjyeze0t8PMJ/H/qVy1MEL4hZl+A5jI1RzbSMjvrC146Owlk5ErvyWxYMcahzVri5XUA5dtLpYsHMXU8UltsHfc9uq8m54xF/mI7gpT5ArWLhZU6MdBa4R+W53Wnh9u3QvO0zthnMRaPu0ryuCYxAWdjcPSVC/pUrihdrgV3xxoZtm8K6jnmsvsr0mLVNljm9KD8XyG+2z4jGyJOuVQ7KRWCR0q7a+sAoPoQJrnzUhL+3cDbuk5PQ1xcZbn5DeuoAG6vpBADG9ZxUN5WkOXDFivyoZN1Rj/+6nsYowhadOAzhCOl4heTDvMtZ0KKFmkE/yySDMCf9x6oiKfGCNXU7+HxDwv/dJjkx9DIds/tgd7wu+lzXxkIAhx3U0rHLQh19019OQ1wccH4LJonxm4m9hx73qxt6V3b+pCE9F+cebD6/6+PqO4wDTf2eHhGHoCuHFlc/d+Kak4YuLYIw4XC9OPTQSpjuEvge2oJa5/vAqJqWAn0X6cZ5lRETAAgewcPslusYwuDoe2SW5lgaKg+Oqeni91AUe6KGVJHIrzO/cVUj/VE6zoa4Y1S+JRaK7iO0dJvsuGZpzqHJe081TFbLefan8Ei0lUqXFV+uN4gLrGUpxXP13h+I7jGn0r+r78aQSrSfKDmhgABWTJo+F3Dy7C+ytJqucU04PXvE=
X-MS-Exchange-CrossTenant-Network-Message-Id: 316622cb-eafa-49ae-1664-08d88a5ebc2c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:37:56.2749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3OpyJFPvNp11VFYG+WbBe5njCwcJFX1XxQk7IDKBVk/XV89zP1N1yRfIpCxe9784
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=1
 impostorscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=788 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 10:00:04AM -0800, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 09:37:34 -0800 Martin KaFai Lau wrote:
> > On Sat, Nov 14, 2020 at 05:17:20PM -0800, Jakub Kicinski wrote:
> > > On Thu, 12 Nov 2020 13:13:13 -0800 Martin KaFai Lau wrote:  
> > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > in runtime that the helpers can only be called when serving
> > > > softirq or running in a task context.  That should enable
> > > > most common tracing use cases on sk.  
> > >   
> > > > +	if (!in_serving_softirq() && !in_task())  
> > > 
> > > This is a curious combination of checks. Would you mind indulging me
> > > with an explanation?  
> > The current lock usage in bpf_local_storage.c is only expected to
> > run in either of these contexts.
> 
> :)
> 
> Locks that can run in any context but preempt disabled or softirq
> disabled?
Not exactly. e.g. running from irq won't work.

> 
> Let me cut to the chase. Are you sure you didn't mean to check
> if (irq_count()) ?
so, no.

From preempt.h:

/*
 * ...
 * in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
 * ...
 */
#define in_interrupt()          (irq_count())
