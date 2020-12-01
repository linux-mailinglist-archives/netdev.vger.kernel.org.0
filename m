Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6C72CABE1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbgLATXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:23:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731329AbgLATXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:23:06 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JK4tj030736;
        Tue, 1 Dec 2020 11:22:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Z60W2EtgYXY4fxblMggyiRW8q2IkJusigLS+GM+70LE=;
 b=mbphmHALaBKM3JR7xK0rAdjw4/DAntFbofVJJFTxuR/yJDwrcJE6EHPazWbHQtm4gw5K
 Gk32QmgtR7O4r1wLgAJhKZ9Xzm1PICBqAgpizeu2LXq1pyxdynfrbXPfY9ni2pksMLLn
 kdHObxmvWvyIPo7+cdy03XHQeXpRvwlGYzQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsymjsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Dec 2020 11:22:10 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 11:22:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSydSuTVANt8mLjkZVWGs+Eh8IxAJyTuCVROxCOdmRspsfvBV9OMGcPOiKeeParN+lJDfO62pII5QPK0jWxAGt9IVeOlUch3mPIWskWTcToxDA3qDqIXBXXvBiKAa+hStwc4bYS3V1eufLwfdAF00OMFsgHhxAQdxDjYuK9GpeVFKB/QnJuuUK8bzvOZX81RqdnJgdG4u3uwShPI7TG7JWY+2u6Wf8K9NZv9NES6JFDC/U2r+PbbjDrtkBWQ1JNIZRaTVJWP2JzqRJDGmNx4bXHyYphc2vCPJPMYtrhnvBrDIkGvxNg4dLi4jDMlJ6aXqAnK79Z7ci7FfHk17I1sKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z60W2EtgYXY4fxblMggyiRW8q2IkJusigLS+GM+70LE=;
 b=ionxbdT325X/bjf1vLfinJkQpN4G/mIQF8dSHiADK/GGpSz3oHukjgOFvNeVYAF6Za7hXknyTgDJq7Go2tzRjCSWkA7DcROJy/W6m9MnpK/oWOlr4VB05ZTltWgygZHYZYxvLObOa91hnntXC5pF68stzqOLG9OUa5pr4TsqX7FlxA81Ido+3XwG1eL76WdszyUDsu5QEoYK/XPkYZ2dznfuu8t2cIG9cFczXABSaqQrabL5i4Z2C0+0zd98QrSUq9Odd+1fMuG7tNavEw414veUgpbj7NEMYGirCPp/qbuRzlaRpNAzfQyqx9pSzreKIAb7DtjYm4ovAGyNcTezWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z60W2EtgYXY4fxblMggyiRW8q2IkJusigLS+GM+70LE=;
 b=RO39mG8lu0ju4hdUbVkCtQTJwaTX89Ch3Cs0aHAL5VJHQg3VXESfv1APwQ2CqTXJedFlojq2XNg9P7T5pJs6gY46YIJ4UhMaGsI07YyhkC1ifY08PqBFrUB7DKt3wfuehG9fm7OhFIo17Ni5FK8awrEpuhFi1A4QYVH9TcfJr8s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2568.namprd15.prod.outlook.com (2603:10b6:a03:14c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 19:22:03 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3611.031; Tue, 1 Dec 2020
 19:22:03 +0000
Date:   Tue, 1 Dec 2020 11:22:01 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     <sdf@google.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
Message-ID: <20201201192201.GB27988@rdna-mbp.dhcp.thefacebook.com>
References: <20201118001742.85005-1-sdf@google.com>
 <20201118001742.85005-3-sdf@google.com>
 <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com>
 <20201130010559.GA1991@rdna-mbp>
 <20201130163813.GA553169@google.com>
 <20201130230242.GA73546@rdna-mbp>
 <20201201184339.GB553169@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201201184339.GB553169@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Originating-IP: [2620:10d:c090:400::5:71c]
X-ClientProxiedBy: MWHPR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:301:4c::12) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:71c) by MWHPR15CA0050.namprd15.prod.outlook.com (2603:10b6:301:4c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 1 Dec 2020 19:22:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f40e3df-0f00-43a2-e691-08d8962e6235
X-MS-TrafficTypeDiagnostic: BYAPR15MB2568:
X-Microsoft-Antispam-PRVS: <BYAPR15MB256862392918C175CED04FACA8F40@BYAPR15MB2568.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQ4g7Z2mM3wzsCm0mS3TgxloQmnD5tsOiPUD7UHefb7XeY6WbdRtr3mTEssQRzF5hu1JHV0+KpOt86jExcnC2sPxYaVXaEEOm/uzbdyZbu/1+lXm2PG++NMyW5B1k5G7O7ZlCO2BvyKatj71fj3yx1DEv49M1wt+3AgbflYoH2QzL/k3xrn+TyCJyrBTBvNWJtWhf9LtjDSQVAgP2J2SFTwRS0ji/R8geCdlzuGOj/fnWNgDYa8eY7y8IpkLd2A90WKqNQLcoSpMFmbB5o9G4IO0yqybq7RpRqmCDAGw8jZr1I/DwwroSlMpuEZpbi85MBDhrSI+dGZA3Hb0dlaM3049KcLbcNCFoU466DBcZ9TDBtIBk3dEOGlCS0KVhRCOeygHj552xlxmM3QpJ20Ktw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(478600001)(9686003)(6916009)(186003)(16526019)(966005)(52116002)(86362001)(316002)(6496006)(8676002)(83380400001)(33656002)(8936002)(54906003)(6486002)(53546011)(4001150100001)(66556008)(5660300002)(66946007)(66476007)(4326008)(2906002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SHZCaGdIVURGRjBYZ2p5Z0RncjJUOS93TFBYYThoUExkS0FPNkJnaUxYa081?=
 =?utf-8?B?b01YT3FmTFFTMzU0dTFLY2orcFRrY01LRFYxQWRRbE1mKzduYkJsNVFKZ0hq?=
 =?utf-8?B?OWtGTjJBOTI0Q3kydkNLQzQ4QmJMcG9CYkJjTGcySlFqVHZoNFdkUUZ1VGRp?=
 =?utf-8?B?bW5XWkIzREJqYlJxY3psamRLWEFLUE1QRzhBYzdHOTJFVWdTek50NFBOYnJO?=
 =?utf-8?B?VytYdFpRYTFpVHQ3bCtLTWR2L0lrMnNyL3h4T3NtWEE2bnFhMVVTM3RJK255?=
 =?utf-8?B?ODFOUzhKbVc0OEN2MkRhd0FOQ09tdU5SYU5PSGdlTHc1RDd1Tm92a2hhSWk3?=
 =?utf-8?B?M1ZvMjRUUTNwUnB2UVZqOFlCczlxeGxuRm1uNEk0ZGh0V21CZ2F5ejY5cG9V?=
 =?utf-8?B?cDc0NENXeDZ6QU5PWlVQWFZmVHBodWdTMUQwOVllem8vK29PRmoyMDFLcnFQ?=
 =?utf-8?B?UUZ6eFlzQkFENzVrSFZRaFVuRGY4V3lxRGhIaDN6UkZlT3ZlY1BzZ20zamhn?=
 =?utf-8?B?ajEwZ1ZHTEtHa2prYUgzMFM2YmtqTFZvaFB2Y2RuZTIrOHVQZVl1NG5HNUVH?=
 =?utf-8?B?L2FJajJ0ZmJ4aEhDUFlVU3ZuOHM5UWxlVEVmZFFWMk9zRXU4NEhBZzkyYUli?=
 =?utf-8?B?ZnF6UkhRMEVJTGgvVEFyVGt5aHhkd3RlZFZzdHVPeVhjTDJzek9nTG1lRHIy?=
 =?utf-8?B?cE9XcDg0UTRWWHhPQ0dwaThXS1FYUmlQbGs4RWFzc0hlakhOSVpDbG5NWFdI?=
 =?utf-8?B?LzM3SE0zdzdZQUJDSEtTTThheFJiZlFKODUyS1RwZ0NLUXh0a1NLMDdNckFt?=
 =?utf-8?B?R0pVMkN2THJlOTRZRWg5UHhlYmx5NHVlbEdiZHBrR3lUcVR4bjlXcmRsQzY3?=
 =?utf-8?B?bHo0SjRRc2xGMll4SGs2V0I5L2pVMTArL1Z0Y1JyM3hBVlUrcStZVnZhSHlr?=
 =?utf-8?B?NWlqb1VYZ016SEVVT1VPTGxFUk1xSmtmZW42Zm04VUthNlg0eDlQekJVZlY1?=
 =?utf-8?B?aGNTRk1UUm1WeUs4Mi9VZFNZTlN0UVNjRzFWNXhNM1dOUDNXR2dTMnBzY3BQ?=
 =?utf-8?B?emtSaUdlSHJFRVdDUERMN1pBQ2Z1MlBKK0RpOHY1U0piaUEwMG5nZzM2ZHN6?=
 =?utf-8?B?Nnh1SXZRZFc0ZXNNdDhxakN1ZFRxQnF2NmpXY21CYUpMcEdsMG5WUlBDZVpF?=
 =?utf-8?B?NFlEYlFxbnBQeFE4RWZvYXBWRCs3RWxESzVLOUhXUS9VUFh0ZkRXZ0k2MkFi?=
 =?utf-8?B?TkcyK1N2elp0QmxFUnJPZUZaVlBqTTNZR2k3ZTM4YzQ0Z1dxbXdDclBhMUUw?=
 =?utf-8?B?TlkyekpqSXJFeEt0eTBFZlQ1SmVWTjVZSXc5cXhYZjVnMEU0WEErNW1CSnoy?=
 =?utf-8?B?R2FrUytKbHh1eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f40e3df-0f00-43a2-e691-08d8962e6235
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 19:22:03.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwOPNZZJdOoKJmVhkWs8vpuyVXQV3Uw2bSo5nuHlpJAwvluLfsHuQzgeTVwi7gi4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_09:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com <sdf@google.com> [Tue, 2020-12-01 10:43 -0800]:
> On 11/30, Andrey Ignatov wrote:
> > sdf@google.com <sdf@google.com> [Mon, 2020-11-30 08:38 -0800]:
> > > On 11/29, Andrey Ignatov wrote:
> > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> [Tue, 2020-11-17
> > 20:05
> > > > -0800]:
> > > > > On Tue, Nov 17, 2020 at 4:17 PM Stanislav Fomichev <sdf@google.com>
> > > > wrote:
> > > [..]
> > > > >
> > > > > I think it is ok, but I need to go through the locking paths more.
> > > > > Andrey,
> > > > > please take a look as well.
> > >
> > > > Sorry for delay, I was offline for the last two weeks.
> > > No worries, I was OOO myself last week, thanks for the feedback!
> > >
> > > >  From the correctness perspective it looks fine to me.
> > >
> > > >  From the performance perspective I can think of one relevant
> > scenario.
> > > > Quite common use-case in applications is to use bind(2) not before
> > > > listen(2) but before connect(2) for client sockets so that connection
> > > > can be set up from specific source IP and, optionally, port.
> > >
> > > > Binding to both IP and port case is not interesting since it's already
> > > > slow due to get_port().
> > >
> > > > But some applications do care about connection setup performance and
> > at
> > > > the same time need to set source IP only (no port). In this case they
> > > > use IP_BIND_ADDRESS_NO_PORT socket option, what makes bind(2) fast
> > > > (we've discussed it with Stanislav earlier in [0]).
> > >
> > > > I can imagine some pathological case when an application sets up
> > tons of
> > > > connections with bind(2) before connect(2) for sockets with
> > > > IP_BIND_ADDRESS_NO_PORT enabled (that by itself requires setsockopt(2)
> > > > though, i.e. socket lock/unlock) and that another lock/unlock to run
> > > > bind hook may add some overhead. Though I do not know how critical
> > that
> > > > overhead may be and whether it's worth to benchmark or not (maybe too
> > > > much paranoia).
> > >
> > > > [0] https://lore.kernel.org/bpf/20200505182010.GB55644@rdna-mbp/
> > > Even in case of IP_BIND_ADDRESS_NO_PORT, inet[6]_bind() does
> > > lock_sock down the line, so it's not like we are switching
> > > a lockless path to the one with the lock, right?
> 
> > Right, I understand that it's going from one lock/unlock to two (not
> > from zero to one), that's what I meant by "another". My point was about
> > this one more lock.
> 
> > > And in this case, similar to listen, the socket is still uncontended and
> > > owned by the userspace. So that extra lock/unlock should be cheap
> > > enough to be ignored (spin_lock_bh on the warm cache line).
> > >
> > > Am I missing something?
> 
> > As I mentioned it may come up only in "pathological case" what is
> > probably fine to ignore, i.e. I'd rather agree with "cheap enough to be
> > ignored" and benchmark would likely confirm it, I just couldn't say that
> > for sure w/o numbers so brought this point.
> 
> > Given that we both agree that it should be fine to ignore this +1 lock,
> > IMO it should be good to go unless someone else has objections.
> Thanks, agreed. Do you mind giving it an acked-by so it gets some
> attention in the patchwork? ;-)

Sure. Acked this one.

-- 
Andrey Ignatov
