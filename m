Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234111FD3C0
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgFQRwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:52:37 -0400
Received: from mail-vi1eur05on2061.outbound.protection.outlook.com ([40.107.21.61]:60641
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgFQRwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:52:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8kWsCi06pBkWlhnDxkRuk/B8k0Kg2wtbE+3j93UTpMUunYe5WMFZo3ABpSM6cVtp195PKxxFQGBKcH4fE4WDo6PTf4kBJ1ET61zzkvKaZYtiZhMlAkzlqn47cgC4Ivc9OsgM3C9VSqpUtzU+4UMBHQQAHfxKtICN8NYydqKiOhcKforHxaO8OIYu1F50z89B5ia42ynfj6U1LoVERDWTFDm41PvNJRgqkMHnQy0yRLO/J/PafZZEEtkQNb7o5IgP9TBl1kjAaUuj8MAM6FeOv3ANnkPZjEF/LEUsOkwt3XBJw1af+i9FLJJ7Q4oSEmKrLGFsPrVEe7JXse3qXvf/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwIjAcLD6MIDhxGQPvri6Bmo8h9g4AfYVMXzl3t426g=;
 b=La2lwAWyqg27yRA6MevjbPOZwMc6hmyM4M3mP/vixymQWwKsJVfi3eLop4rwU1rJu369MRYtzriIw6IsPVhRuprV7AyUApinjGqL60oMTTTQDRHmXqSabLOWAaO/zNjamECq5ash+fOaak0sdZYPmN8OtAfbAK7oeA+laxn70/e2xL+vBtRBXWUEeKoRrGCqcNJJGRYq6puqF57h0KHmtgQICX6yQlbWwDXixSvPUGYeo0dQsxnOtUMeTy1tkbXjEh+lwLHS2gDyiTKOQBn+ogMlv1GWQj3r21o0dm1hToHNGFH98KluZ2IYUQay8GVsIuKgjmV6XaxCiRqKrSQ7sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwIjAcLD6MIDhxGQPvri6Bmo8h9g4AfYVMXzl3t426g=;
 b=JPuav7mBwwLI5320axaDpD7hGEq3mqnjCTjna8k8k73jT/svKIgIxQLQbnZAHzktwvKVnPFZoflmVOtPGTGhch9pql6FN4fSH+X6ln7PF/ItUajTc0/yV5Htkah9EtZtl+RI2Bu57DNT4bwQVLSe5r/2PEdxj8OtdMz5+2hCfgM=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (2603:10a6:20b:15a::7)
 by AM0PR05MB6481.eurprd05.prod.outlook.com (2603:10a6:208:13c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Wed, 17 Jun
 2020 17:52:26 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::c0cc:a656:610c:88f2]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::c0cc:a656:610c:88f2%3]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 17:52:26 +0000
Date:   Wed, 17 Jun 2020 20:52:19 +0300
From:   Ido Schimmel <idosch@mellanox.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mlxsw: spectrum: Adjust headroom buffers for 8x ports
Message-ID: <20200617175219.GB296888@splinter>
References: <bae3b4f6-3e9b-bdde-72b0-b8f1e7575fd4@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bae3b4f6-3e9b-bdde-72b0-b8f1e7575fd4@canonical.com>
X-ClientProxiedBy: AM3PR05CA0105.eurprd05.prod.outlook.com
 (2603:10a6:207:1::31) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (79.179.90.32) by AM3PR05CA0105.eurprd05.prod.outlook.com (2603:10a6:207:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Wed, 17 Jun 2020 17:52:25 +0000
X-Originating-IP: [79.179.90.32]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0d9ee03c-1b16-4f43-4a85-08d812e731fa
X-MS-TrafficTypeDiagnostic: AM0PR05MB6481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB64818C1F9290366334325253BF9A0@AM0PR05MB6481.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4H4rv2OQusqglTARkhzxdXXdWcPgZQ6ZkhVMEubIyCBiOFm/He2cpv3qVHovDlRF9jb6OCR7sVTSGdxvVrmP9GJm7kdz/YVFrY6qcp/pBzwbDx32jUMT56h31Uhz9bssxcqNjGA7boeo0nOIosDugE/3nkdl+hhEN3xc3XrWEjmaKdpo247Kaja/YxvFpqIEDyn4OoJXGCS0nykWfLDPm5P5B+wLsaVdkBkN2ri7RpC+fJHUaJGr+vuV+x1Ch7NtIwj/2ZRorgO8bBGQd0HDE/Itv7JP+578Z2p8edM2V3viBGkPyADoeYOS3laTvTXyeHEAs+jG8HrTzp1N5fqDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6754.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(16526019)(83380400001)(186003)(6496006)(52116002)(478600001)(33716001)(2906002)(26005)(86362001)(66556008)(6486002)(9686003)(6916009)(66476007)(33656002)(66946007)(4326008)(6666004)(1076003)(8936002)(316002)(8676002)(54906003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4WSgzOTR0Pf/ATytoCYTtJlp0JUA33/Pu9NyR0l6lVloeP2Hyzw/NqhN0PJlhTkNQf3FL2Z4aAT6EwPlufQ/IxIAYRa6QSjVQYTjmXZWlbzGlE96NvN8g+w+2A52ZQNhE0DSh837XvVqs0NNV3Cs8quFexodW5sYolHIQ5VwQfdN3v4on/+DnJHYvQPZcm8OU4ikepz4SvLqXbWK+E97q9Xb+j9cLbeH1NSsIq3i40m1h2vEUoywbnaYV3lI9mewZ4h5V8vjv9NbaK9yi1tP/upYhA6hD6bep9hXetfjx6NM9WXdTMguo5a/GADfFhXN3BoGRghBFLpXfiwzNz/+grtEkl3HOL2y4HnKgFogb2LaYSN/T7wsV0JtN6IEE6IbESPQU/uR5EleLagd+ue+BKGtRFGjDInOckgYut64Dnqm/MUDhSEQKmpjX3TuCj2BFTfyFHkgXC0l82vhSR+5Us74UNJZnv5iWZpWVdzFWUo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9ee03c-1b16-4f43-4a85-08d812e731fa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 17:52:25.9750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8yhBCAFKApdo+XU+vQyhmQtYXYny/6OcJmq34u79Gy7D7qIajTKf6FJBUAhkwqT+YrqM5SlkWRXB8jOslVoFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6481
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 06:15:35PM +0100, Colin Ian King wrote:
> Hi
> 
> Static analysis with Coverity has detected an issue that relies on the
> machine endianness to work. The commit in question is:
> 
> commit 60833d54d56c21e7538296eb2e00e104768fd047
> Author: Ido Schimmel <idosch@mellanox.com>
> Date:   Tue Jun 16 10:14:58 2020 +0300
> 
>     mlxsw: spectrum: Adjust headroom buffers for 8x ports
> 
> in line:
>     mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);
> 
> 
> The cast of the u32 buffsize to (u16 *) to scale buffsize in the call to
> to mlxsw_sp_port_headroom_8x_adjust() will behave differently on big
> endian architectures to that of little endian architectures.  I'm not
> sure if this is intentional or not.

Not intentional. The hardware interface is quite weird. The buffer size
can be configured via two registers. One takes size as 24 bits and the
second as 16 bits. Either way, the max size is much lower than 2^16-1.

> One solution is to either make buffsize a u16, but I am concerned this
> may be incorrect as the buffsize is assigned from the call
> mlxsw_sp_span_buffsize_get() and this returns a u32 so we may have
> overflow issues. Probably better to make
> mlxsw_sp_port_headroom_8x_adjust handle u32 integers and to return the
> adjusted value rather than modifying it by pass-by-reference.

Thanks for the report, will fix.

> 
> Colin
> 
