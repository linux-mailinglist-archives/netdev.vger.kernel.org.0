Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF57136D048
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 03:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhD1B26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 21:28:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhD1B25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 21:28:57 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13S1OnLE008203;
        Tue, 27 Apr 2021 18:27:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KnItzb03voCc2cbdEiobQpm/+4564AZ4W0meEW0eRwU=;
 b=Cdpe2+jaaMO1REJkK7ecw6RPEuEb3OHVFG0P211Ch2kBhmPhZOlDH4HVd+VpE1vf+dU6
 XZOMNIkeGwAYwnVJj57VmP1QY8f1vNFe4Td23ZkvniJlSP9Xws8Mjw8HBEgDLxzaVnGZ
 8y/+gT8umUzuuTwgFMlST/8NkA/OaCIMn7o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3860wrsapj-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Apr 2021 18:27:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 18:27:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K78yEWvTlSmWoRG0NXJlzRSERA4aNK7YBAvqoX5HUvxV8LymXNC8v1hI0FBC2KmSLyLsSV1N6z1oIGXkyoJDxcvL2srRa2HOeX4jjpQ3OyOBxo3UE+UVWoTdAu3UT5Mi7l0nvgBI5sWQUD1d0GDJ2MX66Gu9hPqjivzC3TavlgJc2SY7PWOue0rA009E+7KgAfHrJkw8Nrju+9Jc9LEbuy7SZ7HcQGbOlCKZA2jr6/w4hZdkuwEfGKAEE1jCxNDCfhk2X+u9LOjmDgGx6IWv7z93naWLC4qKzeUFSwkJDUWdKv7JzTVNNiAyx8t6xbmYwFkw4qT+Hthnnx9xWv/xWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnItzb03voCc2cbdEiobQpm/+4564AZ4W0meEW0eRwU=;
 b=BI0mIAO9+E8av6K84cEw7g7HpiOM6cJUf3vZBc/N0yLTOpvguW0GaQKLrugD3GDgM+fgSbTCE1u9NChdd7UdyPtzLbacsrNTjXSdTnOPtR0r5DZfc21yyZ5dW2mmyUhONsTwBI4S0FbBV8hSy1wJN1jqR3fD80oQ3AdtlCm+YLZaUCu2QSIQ3qotZO7jtT0dAucw5qgeP1yjP3wtidnf+XOeCxiYiXXL1uuJSn5PGc8LTMx93sRB7DF6ZT7Z/afl19QCBMKukbYz+QjxIIFXAlmZUZryBhr7NeQJmtK+0fOE7dhPDF8XEH8e1sZHF4nf/2Bw4ICeQctZuCK13nR0Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: akamai.com; dkim=none (message not signed)
 header.d=none;akamai.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4712.namprd15.prod.outlook.com (2603:10b6:a03:37d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Wed, 28 Apr
 2021 01:27:38 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 01:27:38 +0000
Date:   Tue, 27 Apr 2021 18:27:34 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jason Baron <jbaron@akamai.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Message-ID: <20210428012734.cbzie3ihf6fbx5kp@kafai-mbp.dhcp.thefacebook.com>
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
 <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
X-Originating-IP: [2620:10d:c090:400::5:9d7f]
X-ClientProxiedBy: MWHPR14CA0032.namprd14.prod.outlook.com
 (2603:10b6:300:12b::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:9d7f) by MWHPR14CA0032.namprd14.prod.outlook.com (2603:10b6:300:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Wed, 28 Apr 2021 01:27:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b3b3052-21dd-4245-3b1d-08d909e4cefc
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4712:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4712555732E543B0CD2F415AD5409@SJ0PR15MB4712.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7g7Uarnq3x7pSsKeeiWl9/NiO+hvo5QjxwgUi7vZ4khqEILso74SFjY9om9u3o9GshvisrXnVcCKnifKHgSNAbVl5S4SHwKmSXeAARRRhGpHe+yN8gJhHKlfWpd1njyvBUqLfYkdoVqUq0ikuj8mt2hdFjqifCPPfvjqzpGOVHQHFqpM1SJF66geMbhfLOzCwVW/NprD8PdGZP6Xu0DG/+MMVVBzguo78FXImiULBsGgkH2fM7Jhin0JEPlKC1Zb0L1wlpOICdiKtHHzfZd+OT/mKR1LYWePpF2Px8Ts/uaZDoOkuQQpEceku8jNaOhsRpElMAqICs+JJohAeK2nerrXD8Rzhm1Bx0illocdgPEDxdPfuRrA259wKSs2tI1FUzNM9h0Yjcuutx5ielcH+C5gins/zJvTQ8uWOQkfXtRQRBi/vNb4cMfpEmp7Jm6x5Or5DeZgWnfjv+6VFaalq/1xhApxIBNbW9r0bv92i2WSv3S2F8c9tdwA7pkiCAoH/1bFS2tK48Ej9003kxmi1lwLwjjAR5uJDk7X6EYD2AE4xOb19skxmeTs34xkX4NgOCd4WJiDhAZQ5QIxqY/7FfWPjLouSRrlstFaC9BnaDY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(1076003)(66556008)(5660300002)(66946007)(316002)(4326008)(66476007)(53546011)(6506007)(54906003)(52116002)(7696005)(2906002)(16526019)(186003)(8676002)(8936002)(478600001)(86362001)(55016002)(38100700002)(9686003)(7416002)(83380400001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+leGrerUASDrAT+tq4dW1zwUQwQDd+KOJtC/6c6kQlM7627MTNMDjoDAg/7B?=
 =?us-ascii?Q?pkt2KTIli5OoYkyxHGP8HpQUAs5YzABnt2WSEzJMm5hhA7AnEAdKzKzGE3hq?=
 =?us-ascii?Q?3OIBh/DHnXTlk4kXDZHl7U/etutbwTC/JYN4SjE5kwartpC0ijUCuUlrOQNi?=
 =?us-ascii?Q?jxDT3lAthYudQxUPWDmqLzHBDzHNwbQfWS8gXzP03Dg+0IddTKa4meJIYax2?=
 =?us-ascii?Q?/t0+RDqMRa9dwk1EEa3dFJTzGH52o3lBFRL0ybbgB2p7K8mMQt7yDxsInEtC?=
 =?us-ascii?Q?lytYW3a295WRkiFUpRfUEa/sf6KNxa3S9hJFmB6ON7NYKOQD8v+sabafzUfx?=
 =?us-ascii?Q?S6AHTWgTAGnedsYe1f9xVJIQItflOqz4ruvBoeYne4tch5sdosUwRRdfa8Vw?=
 =?us-ascii?Q?avFTUF4oKNSfxi5a9U2Ots374ecF2o5XOTyBtL4KcwfBBGQ06iVLkkbSa43r?=
 =?us-ascii?Q?sdlst1ZGbctuG1Rca68hHzh+gk3yJsuMsdbXssWMHO3tRIfHi+WGVyZuc78J?=
 =?us-ascii?Q?u/+grhLqzpd5igLlmwLm1IsoGKIPVO94HLVrETeQumZIBq+aqann4ptJRBmS?=
 =?us-ascii?Q?9O6Kw6ab7vNJegEV4CCKqC9sKQVA/SyOPu/rfla3i6FDBeEls0PCQxUsgK3s?=
 =?us-ascii?Q?jT5bLpwMvU37AAYAVvBmMz0en4d+ixHUfZofxYAOQtuDTd36ZlQ+ImImMMBh?=
 =?us-ascii?Q?UIGYFVaI5HhFwwkXtyNnZDtrtikd1ssMOxTAk7FICs1N4S81GGCv4lYd4thg?=
 =?us-ascii?Q?+Ebe/xysto8hDwAr2rhx/qd4qVaKgsNS/C1s3AA+/TQ5uHko9hUlcBKnpWKI?=
 =?us-ascii?Q?TBVZdgncoTxVreIIoxJwxxUVjSh/vonbebw5VEczLLoUkYCjv9yc8JiXxYFP?=
 =?us-ascii?Q?+nI/Ui1oYrhNOkI+CpXRB5/2G7y3K4gxmpxduxIvhGaAHJCiehZWmOQKb/6h?=
 =?us-ascii?Q?Cri26bV3Wr2G/IDtSwTOLrwX1Y6/1vydi7OtxTktRAKG1zL/8Bw85VaoJC3o?=
 =?us-ascii?Q?Ylb3Xp5t7uUlmwYsdntIBL7J1g/a751T7t+l384n1eJyYLjm+cC7Yx9h3DMK?=
 =?us-ascii?Q?VUYBmpDfZLO6DgxIj2aB4QzRPlWVLfJ4DGjatblffABvO7gn0XDyXDPlPYzL?=
 =?us-ascii?Q?qFjjQE+BZ/llVHnrWpiLXkwaAIsjwfGVX0fAXT9YNOfAgkT05QJGMP1H0N6S?=
 =?us-ascii?Q?JVIw8ly6NKDlrNuCbuB6zxrvs27mo0uvP2JwW1Ub3tBKWzYQHgK7bA0hxhiy?=
 =?us-ascii?Q?6YOHTrnlhEaESvDO0xMhlJympRbssYnxQR+YJQsrNnX61/W/FmWSclKPlqdQ?=
 =?us-ascii?Q?i6xmX5U0Szsfsz7K3NTLijRKdeIWgwP2GB75li7sZwLGUw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3b3052-21dd-4245-3b1d-08d909e4cefc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 01:27:38.2993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGT+yeo10qUy23y13sAzyK1oj6kBXfmiMat9sJmPqstBIZTuf7beIvMnr7w/R0da
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4712
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: oS9vsNRjXqYO2BgyMqAaQYLRHOx-AHBU
X-Proofpoint-ORIG-GUID: oS9vsNRjXqYO2BgyMqAaQYLRHOx-AHBU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_13:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1011 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 12:38:58PM -0400, Jason Baron wrote:
> 
> 
> On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
> > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > accept connections evenly. However, there is a defect in the current
> > implementation [1]. When a SYN packet is received, the connection is tied
> > to a listening socket. Accordingly, when the listener is closed, in-flight
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners on the same port could accept
> > such connections.
> > 
> > This situation can happen when various server management tools restart
> > server (such as nginx) processes. For instance, when we change nginx
> > configurations and restart it, it spins up new workers that respect the new
> > configuration and closes all listeners on the old workers, resulting in the
> > in-flight ACK of 3WHS is responded by RST.
> 
> Hi Kuniyuki,
> 
> I had implemented a different approach to this that I wanted to get your
> thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
> listen fd (or any other fd) around. Currently, if you have an 'old' webserver
> that you want to replace with a 'new' webserver, you would need a separate
> process to receive the listen fd and then have that process send the fd to
> the new webserver, if they are not running con-currently. So instead what
> I'm proposing is a 'delayed close' for a unix socket. That is, one could do:
> 
> 1) bind unix socket with path '/sockets'
> 2) sendmsg() the listen fd via the unix socket
> 2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
> 3) exit/close the old webserver and the listen socket
> 4) start the new webserver
> 5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
> 6) recvmsg() the listen fd
> 
> So the idea is that we set a timeout on the unix socket. If the new process
> does not start and bind to the unix socket, it simply closes, thus releasing
> the listen socket. However, if it does bind it can now call recvmsg() and
> use the listen fd as normal. It can then simply continue to use the old listen
> fds and/or create new ones and drain the old ones.
> 
> Thus, the old and new webservers do not have to run concurrently. This doesn't
> involve any changes to the tcp layer and can be used to pass any type of fd.
> not sure if it's actually useful for anything else though.
We also used to do tcp-listen(/udp) fd transfer because the new process can not
bind to the same IP:PORT in the old kernel without SO_REUSEPORT.  Some of the
services listen to many different IP:PORT(s).  Transferring all of them
was ok-ish but the old and new process do not necessary listen to the same set
of IP:PORT(s) (e.g. the config may have changed during restart) and it further
complicates the fd transfer logic in the userspace.

It was then moved to SO_REUSEPORT.  The new process can create its listen fds
without depending on the old process.  It pretty much starts as if there is
no old process.  There is no need to transfer the fds, simplified the userspace
logic.  The old and new process can work independently.  The old and new process
still run concurrently for a brief time period to avoid service disruption.
