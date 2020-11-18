Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E150A2B88CB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgKRXur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:50:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50382 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgKRXuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:50:46 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AINZJXU016260;
        Wed, 18 Nov 2020 15:50:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=97fsWMRfZuaisuBwtLNW/BAy2TVz0+7+pMEGSwhI1MU=;
 b=Uz9H4pugto4WvLAMwWd52Vzz49pMxz+JelFDF5Sj0qcy0l9AXfhzG5esb0n3EazRtMBK
 fB5F/uwI+NfW/1iL5mnTFBPX5krYtuwuqPNcI9a3HFQZRKUOAVyCGfX0oE9xJ46CdhM/
 /FOE0Wx34tbpQEsS+EPEigVuhYbBMMxndY0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhqjj3g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 15:50:26 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 18 Nov 2020 15:50:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFT3t8QRWpB+n0p8cpHTMA4AxBLKddej6wwJwtqAupAUYru14L6x393UVJ+nc1WolJj+W7WSOlxPMYNoIX+toJPS7kJadDZAOPhpyCZWMr5J/R8tJSEY7LXIhv5XMTM2GOeu5vswA42TnzKN+3yb8vIxMCFtuTIKaKbzysOqQIptDHVZt3/1Gbt0kcCncaSkqkBH69+Rdi7o5pdNL3OOfJgx5MdErXC715WdsMMxJ0Jfzj4ksLOe3Slku65DWQwhEID5O2GfFtWdrbnXBUozIsPSoPUGl5H2YF+VaJfJQlVuUuhjF2B/dKPG2/Z30bEx9ZkQDLI/xDkTtKEtXY+KOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97fsWMRfZuaisuBwtLNW/BAy2TVz0+7+pMEGSwhI1MU=;
 b=EqwSJEZqrLXxxbwDBUokLIyx/E6QcfVp2kEAUnrgS4+oJfr9U6REj4+iw4fY3klcarCkwq5hpThY8WT4YkbR+r8iIZNKkAzS92E01FS234SyIxnP6+kx68DQAXHfLxcRrm36w3ldIWpTG4S2+Q8Nmy13LeQuFlJTrsphaSkKnRtj/mNCg8cxFqgpC0+sVjiIHGdIrVoFokLcdXNEoduj0RgiiMvDe1y8y+s5eMDkhGWNJxg6FJt5cFouCshQpRpd3Flo+BPJDqbp6ce+B2nyZHnBXVHhqWYreJT0NsJa0aH4xrbTo3t6Rxlp/DQyCAoMlNcKNZCybgy+RkEZwJ6NOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97fsWMRfZuaisuBwtLNW/BAy2TVz0+7+pMEGSwhI1MU=;
 b=YbrkTN445e3K/SigFH29I4ZpE//awhHFerd7+0AYN/hrtErtmtTTZquB/1l6pRE/34tQOn0ZuhL6wFXHgqVaYxD7ejL/g1H5v6465qiqnGw3Jfo0kJG0TfQ/StD18d9c0HVkNhoYVbvlkTamKb1cAkdK7oX0RVkN2w7UXJRiEs8=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 18 Nov
 2020 23:50:24 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 23:50:24 +0000
Date:   Wed, 18 Nov 2020 15:50:17 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 3/8] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201118235017.xrudgf6bfwgkaukh@kafai-mbp.dhcp.thefacebook.com>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
 <20201117094023.3685-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117094023.3685-4-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR1201CA0022.namprd12.prod.outlook.com
 (2603:10b6:301:4a::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR1201CA0022.namprd12.prod.outlook.com (2603:10b6:301:4a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 23:50:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf496c8a-3865-4370-dd54-08d88c1cb7b5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-Microsoft-Antispam-PRVS: <BYAPR15MB25825C3B37606D351FBF9BC9D5E10@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRYRgO+fcVEdrLNmqDg6QwtOU2kxmawHBT0YEUuXWXUan93Jk/reix8R/5kX+BOT780aFyA+xupE9JL+UGYD/vR7IPqMsL0KgbPM/4v8vSJws0zo2pepKzR938V7pjqlK7kCWXIV6zdJhP1FvJh/FSbHVgvkwoWWPO5r/8T3FGYhKFaXMHeYLk4wChXha78s0jidCnbwBDXjZGTh/NJ2+M5U1aPgN/mUpWXVkc4pZ7HPzshe4311jK4uYhlJ4skJ1U8ZZMxtUVQXkObAItsBr2loCkIH9wz3TN5G+egRW8MD0zCVPCIyS19icoV0J7tt0C1Dtv1gbJcAsITgftiDzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(7416002)(16526019)(1076003)(478600001)(55016002)(7696005)(8676002)(86362001)(6506007)(8936002)(9686003)(83380400001)(6916009)(52116002)(2906002)(316002)(5660300002)(54906003)(6666004)(186003)(4326008)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OcC68XNe43naP+pVkHJETkdgf+Y/4544VZ1Ve2T6Tdb/Vv+EZEATqZSBtttlaj7gDhdyNZiHabsZSi8Cz5fLCsaPf8yuZJQXndR89C1BdeFbOVQAujCaPg2dv9rZLezjYVYt16oAj+0B95Lp/La7q8UWWIChx9d1nWRxx1KLwpum9qdXM8RNsHOt9kzOl9ZLGZioOonRMfVewKIWUFWDyVopsfNp21GQrVb8RTy9mS6CfKufMYKB3/YaX1dCvqmNcB3pnt01GXVMIU3KQdfrKdDHCgyS2iafmBl295qQou3WLZz7HvHusVnCgMgHnBnGoYFmWZo99DL2RyMYeJ81Wpnff9Nf3ohVAH6jqANX+oWEta46g5BvZ+PmOWwugAzQVf20992/Umbqj06fOHIC769bvLUua4aNPLSb/6DVkXx6GwXZnY62PvwWyRxbWLZjm5ePwW3XCVnMrYJpaHSyl5+17KZw0wOF8DwDM/cJK60Q/FVPvIDYHqgQmi5gt7BqfmATGJc1SHhFaFhazD9KI6N6YgtSyigHhtYEHQKpdBxEIprjU3UPsM4zXYqlwQydy/ROmKIUbecQF8daCIRAtHh/MmMWll2ho5pd9TgLuhhkmY9s2EvnzipzDyo6csrwJjB5MpXBDmbhO7vm9+ScmSuehywJ8hb7jTLLUeg+vmBoz4/lOiUk7h8ggkFpnJ53bdl+eWPrrqdhe62BGLGy7fcWrRdyMuC347uC3JRPG9KWROtIILc2TRySsbX5wOWUTC18oc1pXBcVOO5+65dfbVh9FMfxkJS6sSYD2zO8ecGmSoaxjKKB5dIUvCwMyrty5vUovwasiHRImB9C8xxwAnvF0f2gMzU/Av7e7ub4xEOPt3GdlPj6r5SC/ZzopQx++iepTNpvuHLoCY0YJz5B272BZR3+yvzKBezIsna980I=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf496c8a-3865-4370-dd54-08d88c1cb7b5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 23:50:24.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kn42jogJyY9GWkBgbkRnyaW+I8k7Iqh6h1ouCZOydR+zDWEUmEvQR1nsJF4PvUD2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=646 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=1
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:40:18PM +0900, Kuniyuki Iwashima wrote:
> This patch lets reuseport_detach_sock() return a pointer of struct sock,
> which is used only by inet_unhash(). If it is not NULL,
> inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> sockets from the closing listener to the selected one.
> 
> Listening sockets hold incoming connections as a linked list of struct
> request_sock in the accept queue, and each request has reference to a full
> socket and its listener. In inet_csk_reqsk_queue_migrate(), we unlink the
> requests from the closing listener's queue and relink them to the head of
> the new listener's queue. We do not process each request, so the migration
> completes in O(1) time complexity. However, in the case of TCP_SYN_RECV
> sockets, we will take special care in the next commit.
> 
> By default, we select the last element of socks[] as the new listener.
> This behaviour is based on how the kernel moves sockets in socks[].
> 
> For example, we call listen() for four sockets (A, B, C, D), and close the
> first two by turns. The sockets move in socks[] like below. (See also [1])
> 
>   socks[0] : A <-.      socks[0] : D          socks[0] : D
>   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
>   socks[2] : C   |      socks[2] : C --'
>   socks[3] : D --'
> 
> Then, if C and D have newer settings than A and B, and each socket has a
> request (a, b, c, d) in their accept queue, we can redistribute old
> requests evenly to new listeners.
I don't think it should emphasize/claim there is a specific way that
the kernel-pick here can redistribute the requests evenly.  It depends on
how the application close/listen.  The userspace can not expect the
ordering of socks[] will behave in a certain way.

The primary redistribution policy has to depend on BPF which is the
policy defined by the user based on its application logic (e.g. how
its binary restart work).  The application (and bpf) knows which one
is a dying process and can avoid distributing to it.

The kernel-pick could be an optional fallback but not a must.  If the bpf
prog is attached, I would even go further to call bpf to redistribute
regardless of the sysctl, so I think the sysctl is not necessary.

> 
>   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
>   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
>   socks[2] : C (c)   |      socks[2] : C (c) --'
>   socks[3] : D (d) --'
> 
