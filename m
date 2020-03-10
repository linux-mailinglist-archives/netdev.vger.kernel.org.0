Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AF4180B6B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCJWXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:23:32 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:55005
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgCJWXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 18:23:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfufGvI4KzBF9uxWp3eG6Q/1vNk3ohD2LG4CzktckRYsXC0CVAFUdp6/q7SFL9fbINaTCKIoyEqHbISbgyDIpHtjcq0k5RiQUQgXtF100GDrdsMPjs4QJOiptBUEoGFiniZGTYiHdLNB+Qb03nC1vSzS4S5ihBmS3mCx0wlScBvHtWddiOKoyaUuRtnYYbK5WA8KWwGPx2e+MM2p5wjU6ohDsRVoan6AQdnZOMnCYOeJEoP9w01flcWu6GWA9i18oEvY+iOCwt0Yt+4I+Awwn/7nTensDnacNBLUMRfokcE7BaR5Hn+P5/zXAcTKNspWld6Mpv9SeuXOq0WiD3ZV0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bdq8pBaJ7fKthYu6SdeyfNaxAtjl3XgKBR6olsHsx90=;
 b=EVsq+XBboUCq5/5HpsjcaPTDHqGfdFxQvVasXREnCY1/kT2tEuDWQfddSHCNbjLBAhJkjuDIRa5eOua83rAQ51w1YljyDm0p2t6hkEmXafY24c5eTel7sN0WsIR4q1HSyt2W/H47UWXxwjOEtEHJ6Qfrgq2gw9SpW9OF9f/VRLIr53ehEftafh18XMAwW5z5bkNOsxanRm0vLbGpxYklWahLz2kqLqkfIVBN3LY3Ws6euRv93l3X0fJgCNa1ogApTs5C2ftpXhNpJJSpos9EkDGXsSXQTNVPdAl2+HR8Ki8xgIfuMVSePtggeYifOqYC7453oPK89AXMkKqotWRJAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bdq8pBaJ7fKthYu6SdeyfNaxAtjl3XgKBR6olsHsx90=;
 b=HsM0b8DidRk1EAAxiy2hpbhWRPH8RRw8UTHpKg63frd9aM7/xrloAZE3+YmxIeyP/LmqXCbfW03HMLqhLZciW1OQm0mKO1Y9gEQk8/X3ZtK5IL+t1ey2j/FI25h7nSs1LgGBSV6DFNuWVwS9SepELgJKP+eIxboIhZdzEXPqNps=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3452.eurprd05.prod.outlook.com (10.170.244.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 22:23:25 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 22:23:25 +0000
References: <20200309183503.173802-1-idosch@idosch.org> <20200309183503.173802-3-idosch@idosch.org> <20200309151818.4350fae6@kicinski-fedora-PC1C0HJN> <87sgigy1zr.fsf@mellanox.com> <20200310125321.699b36bc@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/6] net: sched: Add centralized RED flag checking
In-reply-to: <20200310125321.699b36bc@kicinski-fedora-PC1C0HJN>
Date:   Tue, 10 Mar 2020 23:23:23 +0100
Message-ID: <87mu8nyhlw.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0003.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::13) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by FR2P281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Tue, 10 Mar 2020 22:23:25 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: abd7d762-e2f0-4b30-d62b-08d7c541a6aa
X-MS-TrafficTypeDiagnostic: HE1PR05MB3452:|HE1PR05MB3452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34529D63B74C77DCA523896FDBFF0@HE1PR05MB3452.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(189003)(199004)(316002)(6916009)(66946007)(6496006)(2906002)(52116002)(5660300002)(6486002)(16526019)(4326008)(66476007)(36756003)(54906003)(107886003)(86362001)(478600001)(66556008)(81156014)(186003)(8936002)(81166006)(2616005)(8676002)(26005)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3452;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngAUjRyNqU0RSiSGrnXpxGPyaWfRWOv813aG5wJhP5nfWKGV4A/kiiFARw8ZL3CgZuZNzLbJpQZUeEMUpZ/Bs0weYlYkP42rgqyEizrGY6S6X4cCe0pAKVWA6FvmpWHpR7xbO9ddrxBEF50o+0VMdvQ6AEJmwcDTZU94Lvk4msqHk50rs83xlnAjviSQNlViGPhvQpvCrdYDQvicsr7vMVpnwmBanRjMk+3lEeuDNiOtctt7shmbN3p+aKz8OiFd6k+o9eU4bSyZuRpsMavQ6RIPq8njjmOApL6EAe6ktLn+YCvjDeutoRxW1Y3yAM0ZO4GIHfh34KT1YEiOw92sp09HpOPuRPJUULyfy5rmE7wGxRbijVNicHsselOBHYfvhqmydgbz9Lv63WI/dHK+tRZwTqVBq9GaRo9Q/lLbhzH5iMv+Q/S2GKYS5ZH0cc/d
X-MS-Exchange-AntiSpam-MessageData: 4iht4+vUj7alA/1G9MEm2wXn/L5pZWsloRLYrrDn3tOLIuhDO/EnpfcRtGOSqLa1At4/nBPpTtqtGuiHum5MH5JfQLy8VYvq4NF7X/+FV9pope81Pg344oo5YhR2u6V1NiaSIGR2vnTd5V1oQvbeVg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd7d762-e2f0-4b30-d62b-08d7c541a6aa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 22:23:25.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWX/UcrgBgVCbKDF1hH9udUuoci3gLTxLs6IebDktRQwAU84GFOsZdiRugaeTGH8nyM/tYsw1mDE1mbFCDvvhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3452
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 10 Mar 2020 10:48:24 +0100 Petr Machata wrote:
>> > The only flags which are validated today are the gRED per-vq ones, which
>> > are a recent addition and were validated from day one.
>>
>> Do you consider the validation as such to be a problem? Because that
>> would mean that the qdiscs that have not validated flags this way
>> basically cannot be extended ever ("a buggy userspace used to get a
>> quiet slicing of flags, and now they mean something").
>
> I just remember leaving it as is when I was working on GRED, because
> of the potential breakage. The uAPI policy is what it is, then again
> we probably lose more by making the code of these ancient Qdiscs ugly
> than we win :(
>
> I don't feel like I can ack it with clear conscience tho.

Just to make sure -- are you opposed to adding a new flag, or to
validation? At least the adaptative flag was added years after the
others in 2011. I wasn't paying much attention to kernel back then, but
I think the ABI rules are older than that.
