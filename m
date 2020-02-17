Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6608F16103C
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgBQKkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:40:20 -0500
Received: from mail-eopbgr20082.outbound.protection.outlook.com ([40.107.2.82]:15569
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgBQKkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 05:40:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aufQwXfmvSayO5DUjP+ad0rvh82p29RkRLzuWoRxlenDnLfJernVwS5AdPBAA/nBc+Tdjr3xWxqBieUThOtrLwC2bHcdIyD+hY7Zl87EdVQlMgWtjTqbyiE9KB2wk9RNKzGU+ufJ13qPUrrDMVj+FABGv69klVveN4WNmXQR7hqWhNYnFrDA28O7rjk6FhUZemLkSlohYKdKYZAgr872sQU6YnQ3o2d2l2/+G0LFCy2vYLxpmZrIEqwnmwtRgeowuAj09DpQ1dkDDiD+TULTq+zfUbNVI1xsJOztGQI9DPKPdtP/tzLszH8BrpvW/5FlXUbDscgQvQ4i6FvST7eImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhimyWXCt+SEMOCH9NqXDSGY53pukB6qNrgS/FzHaDw=;
 b=NnDwk+QZjbV9ASHe5evU5ZE/81+tZuHRGKrYO9CpkC1IMNXXIpHMJZ7Fn1cSD6sAtlExadSQOiaoqI2OjXCqv93HSY0urU6MLW4zu6KSJN65opdToKrbwjSuOa8BahWo7+YVCwqz2P+8vG21f0c6g3kmFbbBgzr2jkP1rs6f5jF0LD5NbHPwmYRbtcMbm0PLJNhag5AMaXNh9Awmf1b9zmCfhhdyOwruwPuOut5jWfiB3TK5qPJ3zJYC+wk6ZFAm3IQldTBNMNlXx8Lyr+Ul19x/fHTEYYCt73HmEA+nsmkmTg1lADMS/iRam9JeMJBPiIicc3BAPK+UipQV8p+igw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhimyWXCt+SEMOCH9NqXDSGY53pukB6qNrgS/FzHaDw=;
 b=qvtB11p1A/6QYPxJO8BxKFO9JkuQAf21yBFGG7LjnJ8OCqUGubpCYj5X9PtCA8FauVrhw3lWed9lCX1iz/4OrxdW3Zm+icMUbx+MYhda9nHy1ygi8aH10DLemPcePkmfH4cETv2K/u/vKXLZlb4g/pMLJFHhj6XMPHKFGUOOy7I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3161.eurprd05.prod.outlook.com (10.170.247.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Mon, 17 Feb 2020 10:40:16 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2729.025; Mon, 17 Feb 2020
 10:40:16 +0000
References: <20200213094054.27993-1-liuhangbin@gmail.com> <87a75msl7i.fsf@mellanox.com> <20200214025308.GO2159@dhcp-12-139.nay.redhat.com> <875zg9qw1a.fsf@mellanox.com> <20200217025904.GP2159@dhcp-12-139.nay.redhat.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Petr Machata <pmachata@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Dawson <petedaws@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
In-reply-to: <20200217025904.GP2159@dhcp-12-139.nay.redhat.com>
Date:   Mon, 17 Feb 2020 11:40:13 +0100
Message-ID: <87r1ytpkdu.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:205::36)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
Received: from yaviefel (213.220.234.169) by AM4PR05CA0023.eurprd05.prod.outlook.com (2603:10a6:205::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Mon, 17 Feb 2020 10:40:15 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b223c69-654b-4f5d-f33f-08d7b395c684
X-MS-TrafficTypeDiagnostic: HE1PR05MB3161:|HE1PR05MB3161:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3161FB2DB7DC3ED831935B62DB160@HE1PR05MB3161.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(199004)(189003)(8936002)(36756003)(54906003)(8676002)(81156014)(81166006)(316002)(478600001)(86362001)(6916009)(2906002)(5660300002)(66476007)(66946007)(66556008)(956004)(6496006)(4326008)(26005)(6486002)(2616005)(16526019)(186003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3161;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: noPwA5cQB5xXJmVa1x2gGVsjUFy2WgmdhA87C5oPIlLQ/m73uxynwMgddXwtV1h4OXkHUOp4sde63C/SN6dsLuZ8pA9R6zcwd1wK3yRFUefOblzOnB6A0K04HsWecmPUIz+AHtvlM7Ne23B0Y2EJaKkLWD8qGsYtEUKkk8x1TIax2ximsmUThgyEIWNO6SqkjYadwebIVJ0w7Jr8mU7fknEj8BJFgeU9XLo552IlnCOl3y3UCPfOaQS/yyfRqDw85VA7j6TDUAsz6HkTUyqRWirUNJKnRyop3h5hdhTpV3bOwU/2WEUsY3T9/MImK8I3GNX/3/tpiooGEhfsQU92YomLqegWOiGqLtZBJmPKRE5SilhBVOrETMmKGsc05umIfTPfEv8hHjCa+Txumx1HLTTZHpzDy4W5poBAN2/EYZo10ElUE+7oTaHtX40iAE0U
X-MS-Exchange-AntiSpam-MessageData: akpv4F4GhUQf4/jiuMD3bfOxwwLzQDsWLbIYGIUknMWjXBry+PhwZlRGjmZKwBV1dGDD6qMnwO7Oikmp6z50JcKYresC7kTOrwr845eGWT+CmFZcsnkZs66R4hDVSWB8OMH8i11U/EK79rwt6YARQA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b223c69-654b-4f5d-f33f-08d7b395c684
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 10:40:15.9854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEn7ui/jpqsouRVOfLaOApshXk7t+6IzKZale2ZLoi5sVajwxJSJpXr4mhSj8efqUjsTeI00V8mSiUYYbnJCsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hangbin Liu <liuhangbin@gmail.com> writes:

> On Fri, Feb 14, 2020 at 11:54:09AM +0100, Petr Machata wrote:
>> >> > After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
>> >> > strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
>> >>
>> >> I don't understand how it is OK to slice the TOS field like this. It
>> >> could contain a DSCP value, which will be mangled.
>> >
>> > Thanks for this remind. I re-checked the tos definition and found a summary
>> > from Peter Dawson[1].
>> >
>> > IPv4/6 Header:0 |0 1 2 3 |0 1 2 3 |0 1 2 3 |0 1 2 3 |
>> > RFC2460(IPv6)   |Version | Traffic Class   |        |
>> > RFC2474(IPv6)   |Version | DSCP        |ECN|        |
>> > RFC2474(IPv4)   |Version |  IHL   |    DSCP     |ECN|
>> > RFC1349(IPv4)   |Version |  IHL   | PREC |  TOS   |X|
>> > RFC791 (IPv4)   |Version |  IHL   |      TOS        |
>> >
>> > According to this I think our current IPTOS_TOS_MASK should be updated to 0xFC
>> > based on RFC2474. But I'm not sure if there will have compatibility issue.
>> > What do you think?
>>
>> Looking at the various uses of RT_TOS, it looks like they tend to be
>> used in tunneling and routing code. I think that in both cases it makes
>> sense to convert to 0xfc. But I'm not ready to vouch for this :)
>
> Yes, I also could not... Maybe David or Daniel could help give some comments?
>
>>
>> What is the problem that commit 71130f29979c aims to solve? It's not
>> clear to me from the commit message. What issues arise if the TOS is
>> copied as is?
>
> As the commit said, we should not use config tos directly. We should remove
> the precedence field based on RFC1349 or ENC field based on RFC2474.

Well, RFC1349 didn't know about DSCP. I do not think it is possible to
conform to both RFC1349 and RFC2474 at the same time.

RFC2474 states that "DS field [...] is intended to supersede the
existing definitions of the IPv4 TOS octet [RFC791] and the IPv6 Traffic
Class octet [IPv6]". So the field should be assumed to contain DSCP from
that point on. In my opinion, that makes commit 71130f29979c incorrect.

(And other similar uses of RT_TOS in other tunneling devices likewise.)
