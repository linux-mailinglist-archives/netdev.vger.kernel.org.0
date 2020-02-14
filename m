Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7B15D61A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgBNKyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:54:17 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:40519
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbgBNKyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 05:54:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKuMEkzZQdCcPH6ZtiWY7/U3a1yKq8FA5ztWfTe7g3K5s9uZCpPLLLlFYwEwTc+o3eDfaY/O2CqZWp6S+yThKoDzyazZRUeaKHMNdV3/pzjy+3GOKqFG1ULtFlitd+Jk9Bp0FRCWDzKo9vllAnEKEKGOZSjMhyaZ9tcmhr2gaNOLVlfUU0G/Giqs6f4ZCwTUBTu1KmJrvzD3K24sqlKKQVsbaHylyilya/gBPkF9jIuiglwWnFwfVv6KaWXyz64fFxLv2WyxM/OI/oc3v7nSv4AGFMErvAZndirxfIY2E7HdTXmOodCtMK+/TzRLtMssfCOjv8fqTZCIFbWkVP5S0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNhLF5oDjWXwEXsCuKeXCx/rWy6qno4TePDdfGykTFo=;
 b=UxqSsphpfN6F54ahmKECGvySX+Z0X54M8zmi0k6p10BqCq+CwpmppvlS+d9+nQpD9Vrwqquneu40gR4XFqvDyefUXl6x8rEFhEe9iqU5Mr6lyZBS5lWuJoBuLefPALfQ5svki+xVRlthS4xt8NaWHJ6XUD+2OlsW7NGSy9tNxbdIuJi80f9dwq/pDFGjanlK10fMqaq7dqA75C/J8oJJ66nJhqBHpNbK4+jHA0th1yQah7j5y8kAP8qwe8KMJDELC00LxXegrPvAaFsH+v6sU6faJ255+J9eE7ccHFwT9Z9QHEFoGUX9GU+rFtewdNRyKplvUHWSdOz6xUiCSI8USw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNhLF5oDjWXwEXsCuKeXCx/rWy6qno4TePDdfGykTFo=;
 b=fYqg47NZiYtm2/OH3rikJEjDzbEgEM9y2VWagGozRcoQ54lYGmvEIxfYg51zN79fNttt0q9xoS/qXUq7+uuAjnJmesTbFj0e5jMuzxi8jaNVycTPCaj7tmhxRA6pI25ULXJkO+D6oibxMvYLcvTu9rBWynBZcZ+pzH2UdE5OYnQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3243.eurprd05.prod.outlook.com (10.170.246.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 14 Feb 2020 10:54:12 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 10:54:12 +0000
References: <20200213094054.27993-1-liuhangbin@gmail.com> <87a75msl7i.fsf@mellanox.com> <20200214025308.GO2159@dhcp-12-139.nay.redhat.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Petr Machata <pmachata@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Dawson <petedaws@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
In-reply-to: <20200214025308.GO2159@dhcp-12-139.nay.redhat.com>
Date:   Fri, 14 Feb 2020 11:54:09 +0100
Message-ID: <875zg9qw1a.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:207:1::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
Received: from yaviefel (213.220.234.169) by AM3PR05CA0089.eurprd05.prod.outlook.com (2603:10a6:207:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Fri, 14 Feb 2020 10:54:11 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 189015ca-797a-4001-d62a-08d7b13c39ac
X-MS-TrafficTypeDiagnostic: HE1PR05MB3243:|HE1PR05MB3243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3243859172360ECBA809D0F3DB150@HE1PR05MB3243.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(199004)(189003)(6496006)(5660300002)(86362001)(81156014)(52116002)(26005)(66556008)(6916009)(8936002)(66946007)(16526019)(186003)(66476007)(8676002)(2616005)(956004)(81166006)(36756003)(6486002)(2906002)(316002)(478600001)(966005)(4326008)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3243;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y8ngqg247NDah1zBLWqZPAAxFGGzXs6wwq7FdmhOEGV3Bz6sM+YCR7Xtf2nbz+b2XazajWADi7u7aHL5hqsxZXBkGwDfOoMjvr9OacE2LIBmbIo047WHU0uVWdynUUyX5CcrywZqVkSmYN+c8bpvZjAm9QvYXc3x1nmiOrCQAk7mhBE8aSH6Tb81gl91TkzsvCbyGR666xXueVR6RL3HHFKbUQreAN/Wfh+icgB/KMROsmTE/fuabE07W5XLYowRswAkszE0d9rt9u+VcvW0JxVmskfQjTABuDKcHZrQgBJ+o/2hWVGkwtYDuQXBt9+MdX6c/HBD71hqU33XN7L38RNY3nl5jW7TKgtSzbzflBFU9z6kHfEwJlK8Vx8jsPDDMOwGicsKaHrJlP151ZXmb40WorGwmiZo1g4wAUtR6tKIlAj3TBi8NYZCRri4dseoal3PyeeTC1Mmv0MC6Gd6Ys2uGpj/XZGV4GgiAek+ozfNUBObCUorUuXvoHgu5e+GFEAdgTZl78VsOvNI1pK+Cg==
X-MS-Exchange-AntiSpam-MessageData: yNicl4yV/x2UeApHEIQMl2Ff665t6ZYgBiQyn8wtTHg83mR9OJas82W7Y3zSpcR0ylNWutdwdcLZCvDMlJYahZOszjP+hUKjE54kmv5acGWVrZLQFFb7zOH+VmgreLyP3bbKcJhECaV+OS+xvr0/Sg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 189015ca-797a-4001-d62a-08d7b13c39ac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 10:54:12.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2ZhnWfAYF3i/WpiMJLveFKWA9wTAY1FtZw9uk2lFEJx3kY+4G/Rm78GiLfEdZTkRXmnqrIxyDFfm37WWLFHng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3243
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hangbin Liu <liuhangbin@gmail.com> writes:

> On Thu, Feb 13, 2020 at 01:52:49PM +0100, Petr Machata wrote:
>> 
>> Hangbin Liu <liuhangbin@gmail.com> writes:
>> 
>> > After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
>> > strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
>> 
>> I don't understand how it is OK to slice the TOS field like this. It
>> could contain a DSCP value, which will be mangled.
>
> Thanks for this remind. I re-checked the tos definition and found a summary
> from Peter Dawson[1].
>
> IPv4/6 Header:0 |0 1 2 3 |0 1 2 3 |0 1 2 3 |0 1 2 3 |
> RFC2460(IPv6)   |Version | Traffic Class   |        |
> RFC2474(IPv6)   |Version | DSCP        |ECN|        |
> RFC2474(IPv4)   |Version |  IHL   |    DSCP     |ECN|
> RFC1349(IPv4)   |Version |  IHL   | PREC |  TOS   |X|
> RFC791 (IPv4)   |Version |  IHL   |      TOS        |
>
> According to this I think our current IPTOS_TOS_MASK should be updated to 0xFC
> based on RFC2474. But I'm not sure if there will have compatibility issue.
> What do you think?

Looking at the various uses of RT_TOS, it looks like they tend to be
used in tunneling and routing code. I think that in both cases it makes
sense to convert to 0xfc. But I'm not ready to vouch for this :)

What is the problem that commit 71130f29979c aims to solve? It's not
clear to me from the commit message. What issues arise if the TOS is
copied as is?

>
>> >  	tc filter add dev v1 egress pref 77 prot ip \
>> > -		flower ip_tos 0x40 action pass
>> > -	vxlan_ping_test $h1 192.0.2.3 "-Q 0x40" v1 egress 77 10
>> > -	vxlan_ping_test $h1 192.0.2.3 "-Q 0x30" v1 egress 77 0
>> > +		flower ip_tos 0x11 action pass
>> > +	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
>> > +	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
>> 
>> 0x11 and 0x12 set the ECN bits, I think it would be better to avoid
>> that. It works just as well with 0x14 and 0x18.
>
> Thanks, I will update it.
>
> [1] https://lore.kernel.org/patchwork/patch/799698/#992992
>
> Regards
> Hangbin

