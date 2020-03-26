Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2271A1938A3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCZGbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:31:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53518 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgCZGbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:31:40 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q6U5vI020491;
        Wed, 25 Mar 2020 23:31:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YdsXvCCiRUHs5kdxZpTplyTXEqY78tgsoQCbHrVzmK0=;
 b=YFGcVbtL3OJANlkxqO2+pjWSq3cWRegbylX6MmJ0I9J9ZzmCD/XzVu0CezF+Vl+oarnh
 z9H0YnkTFesvl0t39xqfuyXVS/8tuq7HvFvIO4ULwyH0J3s1QONKX/Wdv6dkIkGBvQLp
 WwJruLeQzKFRyeP8b7jXd3QZ4ZwvnPgdXQ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yy3gyf2b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Mar 2020 23:31:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 25 Mar 2020 23:31:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHAYVGd36d5aT72SLD+rJ6gz7rzo847dYReNd0PX03fQLMLrTGvrVtaabblupbAyh+ZF8MqLWeP3Lh3kBNeVY7CAV8lVLXDeJMz69E3/AX2xcExnOD0R18czues+eWLabJ7t/cnEyQVWGdL1F8Zmw7CcUso1XIZ1V8Qur6x1BDfNH/Uce1CDRzYkgHHiYfb19e6H2EFrmCWjgZDmnXhBRwteH53cRV7Tqgd0Ll07qDaZLyBUBqz36/KHm15q/KXF5KodHAxFGx4/XJ9WgU5/VqO+JwQlebDXGdHhgPSbez6Nl8SPnbXO3oz6C0tB9XR9VUYZUs7AFnRCo7bf5JgAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdsXvCCiRUHs5kdxZpTplyTXEqY78tgsoQCbHrVzmK0=;
 b=DhQY3OQk7Cp7eZnICC2Q8jmOIytCJAOBrUruLAHLcx28SZ7Hi59CI4zH3OUk7OZLCdCu5Lh/vJ1jWSqa/smeJR1+q04LqajEt+JRbeTt8ymiKzUxLXS5yLykIsZf0Ck244gjhgSoVI2kPw88ml5nq4M9D5lS4PTn4i5dI1SbVIUyFbZiskb7bzylBaE78evB5VfDjaFuBoytlBoDRw5pPIO6w1+7zeaVx3/V/ktDgP/yM+6KwpNIZYuVa0uwD//FmhpLiN3niIVWi4h0Hu+AsTa2bclDO2ZH7j2ym2OWzZkfK0sxvjY2cOEYRBXmSlvI94JWAvTy5iQELvrsg4pwmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdsXvCCiRUHs5kdxZpTplyTXEqY78tgsoQCbHrVzmK0=;
 b=SvkuaEZhatCkRdNWGb/Vn5774hv0GcetlAUR58MoUfJD88uuTs24ro0+iG+GVgeS3Ay1xKVye5u7NbFmrLIgRrM/8NwqKJXTo8oy5nRVQyzjjsWVw2Fn+m4zR2ASDRIkwxlL0ULzUvg9zsM8IKhFKt3ZMQawIpEFmdrFuMVmmuw=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB1964.namprd15.prod.outlook.com
 (2603:10b6:302:10::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Thu, 26 Mar
 2020 06:31:07 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9%7]) with mapi id 15.20.2835.025; Thu, 26 Mar 2020
 06:31:07 +0000
Date:   Wed, 25 Mar 2020 23:31:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
Message-ID: <20200326063105.siirxsbgypcizmkb@kafai-mbp>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <CAEf4BzYXedX7Bsv8jzfawYoRkN8Wu4z3+kGfQ9CWcO4dOJe+bg@mail.gmail.com>
 <CAOftzPhkoZkooOk9SkwLQnZFxM9KGO4M1XpMbzni9TrEKcepjg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPhkoZkooOk9SkwLQnZFxM9KGO4M1XpMbzni9TrEKcepjg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:300:ee::11) To MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:cd36) by MWHPR04CA0025.namprd04.prod.outlook.com (2603:10b6:300:ee::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:31:07 +0000
X-Originating-IP: [2620:10d:c090:400::5:cd36]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d122eb40-6ae9-4735-e140-08d7d14f4455
X-MS-TrafficTypeDiagnostic: MW2PR1501MB1964:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB19641B80F239CC6557F1C069D5CF0@MW2PR1501MB1964.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(376002)(346002)(136003)(478600001)(33716001)(3716004)(81166006)(1076003)(86362001)(81156014)(4326008)(8676002)(55016002)(8936002)(9686003)(186003)(5660300002)(2906002)(66946007)(6916009)(16526019)(66476007)(66556008)(316002)(54906003)(52116002)(6496006)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB1964;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9qbPCUrbChdKFP6SBq+a9kSAKG72uEpid96IF0tzkYzK6eA+jW5iAF6b2D66ffbJtDvxlZ44iprrUrh4iWxg8PCAr5ngjObEcbSuE1dKp8ycy3gs8RVMkbzy6k3NeH4CuZ6XRCRxj/dJstWjqSgUW5hWivLnz6j7AA6ViM/ZyIIKWcVF5YYXNQhiweOTtxqiYlkQS6LKiDfTUZ/4590fFWQGuqa73xKgDlhhXV3bnl0ZIo12arPtaUkFuLkFa4jY1y9e4utRUkpu9phKqBKfqVeTS9bWobde/qeZWnXiRfVAkEjD2rQs8Vu6N1PrT8c0JMopZHBdinzXMc529TfcceP1TN3KdJAzrQjMqZe3mAlnQ2h2RUWawQzeAsv3iS80mGNRD5pbAgPnDVC2QcuTW7LqlZKrJLbBtLxWhPZR4wmH66lCViXYM0FmGD+36wN
X-MS-Exchange-AntiSpam-MessageData: cSuEWV7q9Z6O9dheEyaZIT8AWNep/fCJzXXc1V5RbPyIkRU3aLxHpQjD7KxSHD971GXAQGzHgVuPO/jTxfgzLHatX0c26p+kraJSqV+Jr21QPZSWQwbYMjqoXF2hy4p+trZMCwJkzbVvv6oIT2vf4+I5bbV8UxPvj6gOd+EytyFa+RzFWheVFY0Xd1n+hP9e
X-MS-Exchange-CrossTenant-Network-Message-Id: d122eb40-6ae9-4735-e140-08d7d14f4455
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:31:07.7533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +a7EcLtILXIw4X+QJGcsuQ7JObOzuzfE5pxJY4GJGZaXyFBSgvpW1dyDYrd0LhOC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1964
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:28:11PM -0700, Joe Stringer wrote:
> On Wed, Mar 25, 2020 at 7:16 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Mar 24, 2020 at 10:58 PM Joe Stringer <joe@wand.net.nz> wrote:
> > >
> > > From: Lorenz Bauer <lmb@cloudflare.com>
> > >
> > > Attach a tc direct-action classifier to lo in a fresh network
> > > namespace, and rewrite all connection attempts to localhost:4321
> > > to localhost:1234 (for port tests) and connections to unreachable
> > > IPv4/IPv6 IPs to the local socket (for address tests).
> > >
> > > Keep in mind that both client to server and server to client traffic
> > > passes the classifier.
> > >
> > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Co-authored-by: Joe Stringer <joe@wand.net.nz>
> > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > ---
> 
> <snip>
> 
> > > +static void handle_timeout(int signum)
> > > +{
> > > +       if (signum == SIGALRM)
> > > +               fprintf(stderr, "Timed out while connecting to server\n");
> > > +       kill(0, SIGKILL);
> > > +}
> > > +
> > > +static struct sigaction timeout_action = {
> > > +       .sa_handler = handle_timeout,
> > > +};
> > > +
> > > +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> > > +{
> > > +       int fd = -1;
> > > +
> > > +       fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > > +       if (CHECK_FAIL(fd == -1))
> > > +               goto out;
> > > +       if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> > > +               goto out;
> >
> > no-no-no, we are not doing this. It's part of prog_tests and shouldn't
> > install its own signal handlers and sending asynchronous signals to
> > itself. Please find another way to have a timeout.
> 
> I realise it didn't clean up after itself. How about signal(SIGALRM,
> SIG_DFL); just like other existing tests do?
or setsockopt SO_SNDTIMEO?
