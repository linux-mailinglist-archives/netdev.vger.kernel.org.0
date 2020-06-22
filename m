Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6283D20333F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgFVJYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:24:49 -0400
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:49462
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbgFVJYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 05:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1QdRjyeauE4MJAwOUmQdSRoLpmp/60UdjKC+IsetiSbjWrCnKF/ZhB1Ap0GTs6JR7pbBfdJLkNTUzc944gDVQhSsj2YKIgaPMjOuIi5rcoh4/xymKPpYMYo1YRgG2kc6LLvYJ1jMzsTm0PlY2IN/xF9QHcu7icLW8l/r9/VxdkAUnas8XpCheuOsizB7vSO9S4Cji8sSFLE0jVXmI096ZpXkBUurwjfPZT6hsPNxHj4Nfy06DGqO/r1s9hKupyxEvpHRY8Sv+Q9HpmMAiVIMLGiSmhtj7r2hIGKGT5NlnbLWOqRtQTY86Bh5kZ+pv4kZwQVEI72CJwySFD+DpIGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fz3rQ51av+V2AQCaDeyl6rzNzfSqokzwomb4PmsTVRE=;
 b=FyRS0MFUOfYuhSCrRd9TxYfLL9m9d9WBrkzuoYmeLtopKpbizEg0aTP02HcRi5eGAxfyWCVef9iQyEZDVLwO19L4FNP5mWf5xRYBnx9bPWlcI7pJ8gLcxTn0Trr/vJHzOThsGefTWf9GRvkVdDyoTNVbPfw8QGA2JLvWbQjUYyMyf72iaVETix2asi158rrecvz1q5341YzrwSb9HNPJFKHkQJYshGExWelj5T7kplR7+toWqO8PcShB7TMWYIKCDrA5hM6Hjc1VgbEhDFN7xraEgXubePnMs5vRpFfGOjEU8bRonhv+REWyUXIZ47m8RZOYBZaE6lGp0sDAqq4SwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fz3rQ51av+V2AQCaDeyl6rzNzfSqokzwomb4PmsTVRE=;
 b=Ub3oZrLxkSzzFAy1LIWMhynlZUrLnbdSXy4fF6iIEaki0phJpmyrY8aIFFRIDscd8+Fw812ejwupgfZUwNOjcWK6Pl5cHZHLuFA4xZOM7LsczcHea+rnb42zPEkzsePDl4SC0D46Z/OIvlhkU1qak2HIeG0Ao/H+lyPUAPJrvLg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4604.eurprd05.prod.outlook.com (2603:10a6:7:99::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Mon, 22 Jun 2020 09:24:43 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::3d22:5b97:fe53:22a1]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::3d22:5b97:fe53:22a1%6]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 09:24:42 +0000
References: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: missing retval check of call_netdevice_notifiers in dev_change_net_namespace
In-reply-to: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
Date:   Mon, 22 Jun 2020 11:24:38 +0200
Message-ID: <87tuz3jvvt.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 09:24:41 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f20475a-90c4-4d15-a3ca-08d8168e1889
X-MS-TrafficTypeDiagnostic: HE1PR05MB4604:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB46045FF84E4BF3D3DB33B665DB970@HE1PR05MB4604.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERRbnwrQZZvPcIBfXJmldjxMRZmMAD5UZ6c3U6AGmkExM32h+SxHbipOoWplG8o8+MZ4C+JFkEMV8GXHKu1zgUpUv2EjmkzOlAL/YhSoXkKvGgd5t6soVahHfyDN5Hen1F/zm/DcQu8MzqVMDV1JOX3l+vEwyzp2jboNYsu7xs2foXZiFnMVMUv15/aQxZspvgtdWOmhVFNLHpGe/PalKpveZ2/1XkRqNUgBTrBqZKaDQeBZja/7cSQ27cJ7SLsdsaHBoiCxN5h0wXNvTV4NePd2xuZDA1pMXI7QYt8tiQf65P+9t7hjpXE7YeQTMt7W2OGCc0mVHmL9gATWXT++gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(54906003)(6916009)(5660300002)(66946007)(66476007)(66556008)(2906002)(83380400001)(36756003)(4326008)(86362001)(6486002)(8676002)(956004)(6666004)(6496006)(52116002)(26005)(16526019)(186003)(316002)(478600001)(8936002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JyRQSsVHvbDyfHgmsZhzKlirfzDaGhuESBBN8DH00xylKy/XGpe/J0wczlVIjOFGgCPr0u5mA8XuSJjwRQhkHFREeiwRHlBpeRFFMmTGLWYkrjycfNOT19HcGO8WYMVG90mF+55k+/zmRTQ3CVmXwhfRwWfEF2/zzdjzwDDInTh2stEO+WR6i4MY6zQCHVyZWxnS8iVH8U+ifQIVr6VMKRnsHbmkDn4x+aVojpYhCskIbtnsBjAxdipxFq9b8EoI/O9yvkNF7G30ywkZ8Q8AxPRjtaiSdx/MoAExq9s0ohpR90mtmQ4r60HKW5HaiLAO3K5qW15SZmbmDhsBydBzBLe6dUr0KZ79UOXGkjYT4AT+wWsge3uC6IkgVaQBY1VNMOqFZxq5YHrtu5/Uyh+cwNtUrLNxLpqL8IOgI3cd2krBA7Dlsc44yHz331a2IvYcEpluN7btAnxlSYhmHI+KLsS9JrHHZb9CNvrhXJCT9hw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f20475a-90c4-4d15-a3ca-08d8168e1889
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 09:24:42.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SQX3ZCZ6f5EPAtLmFydFu0RAfaOugRPfa9HY4jHnZW+9bgo9lvHZ5ZRcg7Oq8Cxsnc6pEvXIWAx0k/9L4higg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4604
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jason A. Donenfeld <Jason@zx2c4.com> writes:

> int dev_change_net_namespace(struct net_device *dev, struct net *net,
> const char *pat)
> {
>        struct net *net_old = dev_net(dev);
>        int err, new_nsid, new_ifindex;
>
>        ASSERT_RTNL();
> [...]
>         /* Add the device back in the hashes */
>         list_netdevice(dev);
>
>         /* Notify protocols, that a new device appeared. */
>         call_netdevice_notifiers(NETDEV_REGISTER, dev);
> [...]
> }
>
> Notice that call_netdevice_notifiers isn't checking it's return value there.

I was wondering if the logic is the chance to veto namespace change is
simply setting a NETIF_F_NETNS_LOCAL flag. But that doesn't sound right.
It looks like there are use cases for vetoing the netns motion, e.g.
moving of an offloaded gre/tap underlay. So it sounds like this should
be checked for vetoes.

> It seems like if any device vetoes the notification chain, it's bad
> news bears for modules that depend on getting a netns change
> notification.
>
> I've been trying to audit the various registered notifiers to see if
> any of them pose a risk for wireguard. There are also unexpected
> errors that can happen, such as OOM conditions for kmalloc(GFP_KERNEL)
> or vmalloc and suchlike, which might be influenceable by attackers. In
> other words, relying on those notifications always being delivered
> seems kind of brittle. Not _super_ brittle, but brittle enough that
> it's at the moment making me a bit nervous. (See: UaF potential.)
>
> I've been trying to come up with a good solution to this.
>
> I'm not sure how reasonable it'd be to implement rollback inside of
> dev_change_net_namespace, but I guess that could technically be
> possible. The way that'd work would be that when vetoed, the function
> would complete, but then would start over again (a "goto top" sort of
> pattern), with oldnet and newnet reversed. But that could of course
> fail too and we could get ourselves in some sort of infinite loop. Not
> good.

I think it would be fair to just ignore the veto during the backward
motion. Perhaps with a WARN_ON, because it is indicative of a bug in
whoever vetoed it: how was the creation not vetoed when the motion back
is?
