Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374B51D7147
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgERGvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:51:01 -0400
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:51984
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbgERGvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 02:51:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1YOzh3My5obavtZG9wEUYxgZGfKZm9VV405mBH/r0mPPaNdU6kgkQdiU9KpmOBsP3zo7Mdm/rpmj11nvWJFfIO/fQPeIHjGkciG0Q+rKcksEgktVPPSQ+k42KTuFrkiDWBoPv7EdB7c77+eF5EuE/2z0ac/Sfaf3xeFXGem6nwzZTVCuPb+F0d67DarTS+Ns8453fCRI58B1oQx5vGSuJShlEBBlwNf2ofq2+nuedk+gwJ9CEeEw2Uc1/u0JN5heQPMhvyDtXwomFEY7LrFdi7FQnIRiCMDjWz/uhHXvmrepiILe2UxNdqWWOLQuEIpkgQBPMncZI+ndPRH0kZplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ST9XaqDqTpycZhScRa3nheKYwrRfUMyvrYcfwrRLtb0=;
 b=k0JS90bmpIbneRZ3c5qLavJsX2kInWw1JNYXmwjgY213ci5EqJT8i0NeObziyYoZ4vXZyson9DjRyYYSAVVo8jLPkoIlfgL03pUvJwqDWuvRV6J0HQ0xGJAkJhLWfkDkzQ9UC4ktyuFevf2KqdxanQyCEacEkqvjlvzIwCTleBa8T5PhtSFAZPwVVo+QeNaL5haovmtwVPq6OLVJSmKPNjDEFMj9VXqF55Aq4EiOCm3PViSlcEfl8S7k2wB1b/hl2MPLWIVxaWDZ7My4b9vczjQxpdR7x7MexhHKtbnCYL17eZxqNzYUCKz7mukAf9sW5oDGbk0T+OEwu/Ycp4tdVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ST9XaqDqTpycZhScRa3nheKYwrRfUMyvrYcfwrRLtb0=;
 b=RcQyNOPthW240NJAwFfY+VmUrvHgLJIp5OnmLznbiWKkI5r5vGGQTzFexR0Nd7THKehfQ/YuW7Vh1IZNZnIg++nulGc6aDvPWXyLAWFxLt719rgePw0GeWNbFSMV9SD3hd1074aShjZGt5Yate505Qi6NH5PFxtqh4oT/uNALb0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6806.eurprd05.prod.outlook.com (2603:10a6:20b:140::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Mon, 18 May
 2020 06:50:56 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 06:50:56 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <20200515.102516.536157145939265174.davem@davemloft.net>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     David Miller <davem@davemloft.net>
Cc:     vladbu@mellanox.com, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, dcaratti@redhat.com,
        marcelo.leitner@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <20200515.102516.536157145939265174.davem@davemloft.net>
Date:   Mon, 18 May 2020 09:50:53 +0300
Message-ID: <vbf1rnhpwhe.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0017.eurprd09.prod.outlook.com
 (2603:10a6:101:16::29) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR2PR09CA0017.eurprd09.prod.outlook.com (2603:10a6:101:16::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Mon, 18 May 2020 06:50:55 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 469d83dc-933a-4635-1994-08d7faf7d0d9
X-MS-TrafficTypeDiagnostic: AM7PR05MB6806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6806AF4114B07E6497FF1348ADB80@AM7PR05MB6806.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QqTK4eqebj9F6T2Oddbg6Vsw2zPB/rUiHe6BC58GYrC4kK5leE+Pls4nE7HHZZmZxmr3lLWnM2R+RR0yJzvz6GWYOJpz0T08XMVGZGwsxfJjJd9ENo9fXQa9BO4CmKjIT87orHgAz+FzIzAqsMfAkANqhb9f4ko8cfqBy5dVdGdCLyWqZb5J0tT2yvhUcmQ20JjhtkdhLNUt4pe/hE+e6nkafS4jwT43fGVVbT0E8nQUNuE9lpYBBkGuthLdjU8KDCnLNfZPkVmDJfU73CGuWL4rL+yRzgbkf0kTUVgPJ8T2GxGlhbFkmbg0Ec69IHeCI+OumObyHneVWEtSNGdk9LAVNF4vzDWqiBfas01qqzQDSUmOkq4288qgYKTemBJf4gJ+qlSNwAnkDlOD35fjKSeOk7PWZOyAwmEc/DZfaRxSJzLzFx03leZ85u/Jr8aV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(2906002)(6486002)(36756003)(4326008)(316002)(26005)(16526019)(186003)(6916009)(66476007)(956004)(2616005)(66946007)(66556008)(7696005)(52116002)(8676002)(86362001)(478600001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o5Kv1X8uewczPot9ZJBP2tKpXQQ3US9kBWIoktrX9MT/Lwy0GUJ7HYQwdF/Jfen9K4FNZxjhKLOAvBNlIH1qfTm1/ga4jEJaiZfi4GqfqVpH8DGJ8Lzjj0ixpojDV8LdefQoYhfgf2pdtmvOfNLT1NA4PxjRfsEcEBq6YcYBbveOZWftXyfoYzIF83Z+630Uo90SI21DXjZ2bWxbPCY6+dPxUF02qQ7+3ESjMAYxGTxzpuX7zHZPbVOrJ9afWkfzBr6JzjJXAebii2rutu1XzE6UeNZDn/ZVIDPSWbEkJQ740vyd2pyE2sEmfhyirPTcbrm4uCV5aI+kv+M9WLoszFvJ84Qfk9RvekR7ZRjDDtFvySdfbHmc1VkT2rwBYqRjK9SPgTCrnGMX3f07mdBs0XIQHxW/h4QIR8L7uJ9kVTxJGGup4pbZPjTQ4bGNAbxjZr6U1ro30zWj5svu4T909nt8TjBetrQaYJenSOmosEs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469d83dc-933a-4635-1994-08d7faf7d0d9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 06:50:56.5154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzrLQrgTlt1PQluA5fn1OYVFdmFX5rBjxtcQbjmOHQ0yfpY3zE6ZW/44zKKzQRab8LJ/hbDE1powtwPYP5CP3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6806
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 15 May 2020 at 20:25, David Miller <davem@davemloft.net> wrote:
> From: Vlad Buslov <vladbu@mellanox.com>
> Date: Fri, 15 May 2020 14:40:10 +0300
>
>> Output rate of current upstream kernel TC filter dump implementation if
>> relatively low (~100k rules/sec depending on configuration). This
>> constraint impacts performance of software switch implementation that
>> rely on TC for their datapath implementation and periodically call TC
>> filter dump to update rules stats. Moreover, TC filter dump output a lot
>> of static data that don't change during the filter lifecycle (filter
>> key, specific action details, etc.) which constitutes significant
>> portion of payload on resulting netlink packets and increases amount of
>> syscalls necessary to dump all filters on particular Qdisc. In order to
>> significantly improve filter dump rate this patch sets implement new
>> mode of TC filter dump operation named "terse dump" mode. In this mode
>> only parameters necessary to identify the filter (handle, action cookie,
>> etc.) and data that can change during filter lifecycle (filter flags,
>> action stats, etc.) are preserved in dump output while everything else
>> is omitted.
>>
>> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
>> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
>> individual classifier support (new tcf_proto_ops->terse_dump()
>> callback). Support for action terse dump is implemented in act API and
>> don't require changing individual action implementations.
>  ...
>
> This looks fine, so series applied.
>
> But really if people just want an efficient stats dump there is probably
> a better way to efficiently encode just the IDs and STATs.  Maybe even
> put the stats in pages that userland can mmap() and avoid all of this
> system call overhead and locking altogether.

Thanks! Adding such API will be my next step, if terse dump performance
proves insufficient.
