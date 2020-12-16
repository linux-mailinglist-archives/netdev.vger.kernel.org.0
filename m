Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B6F2DC8E7
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgLPWZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:25:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51340 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730175AbgLPWZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:25:13 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGMEb1O012692;
        Wed, 16 Dec 2020 14:24:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1Ia6S/j3BUasExyDvS8A/JFU/VML+aFZtfu216Ci74A=;
 b=CqtdX7Jxk/OPOBOQ3MVkehdh4EVWfJ1/lb1AnY0cGUEna1XncgBr1OtrzJMn75lujuy2
 SjEq9YKYGtQJjXvMFZ2rfo/PhR2005k/WJM/HAjcdW/9SMcid/KyNC6xXfk8Mn1c7Axq
 ONFY/6VUh7X6wH+m2DkLwUtFUBWrUF/EqUc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35f2tx78hc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 14:24:14 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 14:24:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMEeuIcMITWYBo2pl36Df7EJwtjG1HS8cpYABqW/6ypvjGd5Q74yLVss/hHTcH7uZzKxiGE/UHYGMhYFtXMF/j+dHSdBjQVdGw2uvt5nL1A1o5OJd+NahRXjh++NSI+sPDm1MFpm58yZESUkebjP8ZX2Y9Zi++1IVOTFvdIZFgN93r3OIKBoTG19IflLQIFiq0ZWnEOLx+q3HXGo2feSopWB4BK1KRbs7L2e3Fh8Nidj9KLiwduMUqZ0wo6fOkolsT9PiwEJ8qAeNDE0/MKk96NlF9uQu/RtSqAl9zzfB4tuzk+AN0A2hEpboOu9vu1oFeFiqTeUfvYyeGfSfkbhDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ia6S/j3BUasExyDvS8A/JFU/VML+aFZtfu216Ci74A=;
 b=oU7YurKS6XyqPO4lcZleoon4jc8TIP/f84s5saJL73Tz4JDI9pTJ3P1tQzqD+0fAsxgpotcjplXNzzqN5RMCzEonxZ7zo0xZi/syAMlkWXWlLvpitqLMfGvSjfteLrmFMKPAypeZB9Hcilkx65t+pD3MYQnQKYYZdn327QzCP26Gt8yU43wNLt6PDOwyTWyWAec1tQSi/oXHPQMdFoY1vFZdsRSrVEvFkLqNUkeegYTkaVI137MY+/X5DUszHme12VHvNCn5yJvGG6jvMh5+1B3MjhERAgkY68XgvmB+B3xItcA+or2zczWqr05e1HKv0Ce+RQ9UHc3FOqUgK4fzRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ia6S/j3BUasExyDvS8A/JFU/VML+aFZtfu216Ci74A=;
 b=Y1WVGwVFgDwtVTGddjwkbvAnsz2+tRQo5qT7AuDuq2j4MWDdCX1Xm3oYsEMK/6tE3kQvH0cjM8aNxmm5B++Cq7rwTmZwW5RVPBugGjOGsaMInNmdOg0EDQeudHyOqf4XXBeBORgGReTR9j8KcHf8opgsF77ULOTgAYuu8TGxHIY=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2645.namprd15.prod.outlook.com (2603:10b6:a03:156::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 22:24:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 22:24:09 +0000
Date:   Wed, 16 Dec 2020 14:24:02 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Message-ID: <20201216222351.3hwq6cktax6v7toq@kafai-mbp.dhcp.thefacebook.com>
References: <20201215025837.k2cuhykmz6h46fud@kafai-mbp.dhcp.thefacebook.com>
 <20201216164158.65104-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216164158.65104-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:d3b9]
X-ClientProxiedBy: MW2PR16CA0032.namprd16.prod.outlook.com (2603:10b6:907::45)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d3b9) by MW2PR16CA0032.namprd16.prod.outlook.com (2603:10b6:907::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 22:24:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a9efef5-7bc2-49fe-5c46-08d8a2114f29
X-MS-TrafficTypeDiagnostic: BYAPR15MB2645:
X-Microsoft-Antispam-PRVS: <BYAPR15MB264531880458328F822C7BF8D5C50@BYAPR15MB2645.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JAxEA27e/MVKB+5SglW4asna5Lr5fapZGYV9n0x5Eev3gdShrnLGEVsMR/16CWhva1ZQc2jZkG8b8Jzd7Y4VPhgnEo3VpRbkRCM1QiDH1b3j/Gy4lMPgSslMBQsktKQoby4hhjVXRWt3hJeubwDiCRfjuacm/0dSDVn9WJA4jg3qefnxN2KqGmEqEcJFuVGIhebIt8OFZyhTg5NRDiKByyjsQF+lykJ9unvUeIcd965JZExFtlPQP27mP2HXATdgRF6wt2tojNoBvvmLG6/Jol53aWstazx1fp2Dj3BqwZ+EV4xNY3YYFjtJRUevjOxp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(52116002)(86362001)(9686003)(5660300002)(8676002)(4326008)(2906002)(16526019)(83380400001)(8936002)(6916009)(186003)(7696005)(478600001)(66946007)(55016002)(66556008)(316002)(7416002)(6506007)(66476007)(1076003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IXlwvN+5R8oKQ2nIMTSQAqrGO+zUwyHdc3rq3SFcGHwQgDBWRHipbHwBbR9T?=
 =?us-ascii?Q?W4MFGrYbo+nixGRJiX0rseEjvTEWph47Wu2tpCtd4XkS9dZ2BrVoYcQG80gV?=
 =?us-ascii?Q?BhwD5/cxRES2Q18cVB179MpXXm/6vcOKSl3X2uyDz9fzHAM9wfUc0rZUmqVk?=
 =?us-ascii?Q?CJFJVkF+0z0sPIV+SZdslG/ltkBwhMOfGSuQJlGe9aEziJ9MnOV7t6+dxLIU?=
 =?us-ascii?Q?GtwO9jdZzX9eHEiwd4n86Zr8+VCylpqpfZOM4Pq86HJS9MlfjVpS4pEktPwT?=
 =?us-ascii?Q?1mE1hRHZHiYhCZ1o33ZEpMtnoRFtJyxaC13CB9aCb3QpJtoudf6eBDEpZlBI?=
 =?us-ascii?Q?ruBnAakX43auhPDnvkrZVOriFD6wjsCVBYWsbikPKTeK8JJwpwrzQjEfIdXa?=
 =?us-ascii?Q?DwLyB0vLPI8/+dErbBbIbzaC7D830nFmHOpiGuW360gcQFODyZp3Uni5AHk+?=
 =?us-ascii?Q?yqbvihzoRa9dPBguB61ylagynXuycjLcFhA6LRVktt5+co3usxRKLEvVm2um?=
 =?us-ascii?Q?jYRGYmJffw6R9fhdj4retJc7HU3aIX0ojXnqQPgmMelh7xoddrGtQKTYxdLP?=
 =?us-ascii?Q?8YG8yMpprPwoucYgT+Ju8HLHq8/EFoo/wiBt8uu2JmnJJpMfcKKRX33HSCCX?=
 =?us-ascii?Q?2EH8woTeyUslg3chtXApsj3a3e8UqxvGNmL2OHKNukYdnH95wK2feaux3omI?=
 =?us-ascii?Q?yzrVII7tle3J3SFjYwKJfbvbOwYcn935gEP41rrHaG+X6HPHbynxpm4mdZ9b?=
 =?us-ascii?Q?5MhCUV20GGQ8j/2XOIOktiTw1+VDI+fTFJx2nlV4gMS4DqZWwZgIAaijwr7Y?=
 =?us-ascii?Q?aeyzqcmzQ2tnDtLZojRAlMtoT6Wa0bw4SIh5BgCqTm/08QnW97tY8rBJnze0?=
 =?us-ascii?Q?cLFH/pQUw/PCLn6iD8KJwL7Gvuu77dfSKJ4V40iMlSUUjeKmwFi0fY7KNDqp?=
 =?us-ascii?Q?BcDOgX1cTr9Syy0zYafauuEMrK5FbPs0Cdc3JJhGPnvCokDbNcF2CJUhDCn0?=
 =?us-ascii?Q?2n20cmHcSPj+RjrHOc1yihtUWg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 22:24:09.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9efef5-7bc2-49fe-5c46-08d8a2114f29
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GGgFXqYRYkzNwFi3CtCuvo28hOibiZmTuOCi1agM7gIy2oQv0ywQf1+4o8RYZlT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2645
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_10:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012160139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 01:41:58AM +0900, Kuniyuki Iwashima wrote:
[ ... ]

> > There may also be places assuming that the req->rsk_listener will never
> > change once it is assigned.  not sure.  have not looked closely yet.
> 
> I have checked this again. There are no functions that expect explicitly
> req->rsk_listener never change except for BUG_ON in inet_child_forget().
> No BUG_ON/WARN_ON does not mean they does not assume listener never
> change, but such functions still work properly if rsk_listener is changed.
The migration not only changes the ptr value of req->rsk_listener, it also
means req is moved to another listener. (e.g. by updating the qlen of
the old sk and new sk)

Lets reuse the example about two cores at the TCP_NEW_SYN_RECV path
racing to finish up the 3WHS.

One core is already at inet_csk_complete_hashdance() doing
"reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req))".
What happen if another core migrates the req to another listener?
Would the "reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req))"
doing thing on the accept_queue that this req no longer belongs to?

Also, from a quick look at reqsk_timer_handler() on how
queue->young and req->num_timeout are updated, I am not sure
the reqsk_queue_migrated() will work also:

+static inline void reqsk_queue_migrated(struct request_sock_queue *old_accept_queue,
+					struct request_sock_queue *new_accept_queue,
+					const struct request_sock *req)
+{
+	atomic_dec(&old_accept_queue->qlen);
+	atomic_inc(&new_accept_queue->qlen);
+
+	if (req->num_timeout == 0) {
What if reqsk_timer_handler() is running in parallel
and updating req->num_timeout?

+		atomic_dec(&old_accept_queue->young);
+		atomic_inc(&new_accept_queue->young);
+	}
+}


It feels like some of the "own_req" related logic may be useful here.
not sure.  could be something worth to think about.

> 
> 
> > It probably needs some more thoughts here to get a simpler solution.
> 
> Is it fine to move sock_hold() before assigning rsk_listener and defer
> sock_put() to the end of tcp_v[46]_rcv() ?
I don't see how this ordering helps, considering the migration can happen
any time at another core.

> 
> Also, we have to rewrite rsk_listener first and then call sock_put() in
> reqsk_timer_handler() so that rsk_listener always has refcount more than 1.
> 
> ---8<---
> 	struct sock *nsk, *osk;
> 	bool migrated = false;
> 	...
> 	sock_hold(req->rsk_listener);  // (i)
> 	sk = req->rsk_listener;
> 	...
> 	if (sk->sk_state == TCP_CLOSE) {
> 		osk = sk;
> 		// do migration without sock_put()
> 		sock_hold(nsk);  // (ii) (as with (i))
> 		sk = nsk;
> 		migrated = true;
> 	}
> 	...
> 	if (migrated) {
> 		sock_put(sk);  // pair with (ii)
> 		sock_put(osk); // decrement old listener's refcount
> 		sk = osk;
> 	}
> 	sock_put(sk);  // pair with (i)
> ---8<---
