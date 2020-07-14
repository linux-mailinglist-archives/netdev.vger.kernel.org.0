Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E386021F71C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGNQTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:19:47 -0400
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:6147
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgGNQTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:19:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFZSEr0268cEn3RBZZV4hxj6gHqVUcJcGTNrxWBpSkZhUzO5AqEyI2nl0WyWMsd1pqXBsZm/+PASUPPhktktYbHGXWBb61/xKitJvSz0B2j78mNxjZSOozJUAuNFv0GTKhY7k6kcd1jZCXvA5t4MA0GtrDiYvXqVuO/mxGJK0DoCJWyhxStFW7b0+Oz6dniDaQvJVwxFx0kzauqA5DwKYAgDePNWSxR0pIgNSrkGuEqRuzbtN5uVQNYHS3o7fLF+Hvqke8LRHYKIcOnCa4WRXPstEVG/UZDNMJ6OtaGk4D0qg6dj8VZ8V2nHoen2y5/UJjcOTDXShX+cGjzg/Yfa/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GhARCajPMZ6ZvCicLYN45XbTqm1g8+NixUdOD8Wr0A=;
 b=mzvmdNfXpFj4Aj7PYpk4hbmTs1+fQs/DR1ggy7PGs2TisJkVydUYPYJAKABZfGbRe1XzfD4kgx0oxJ0ynSb+T+kwa16zTRzHrZW78Q7M38BeldNXCJUZu/EcMWIrPcsgIcuF477huxlZDe3jkntkcSr0RXSqXr61hTXDglhtF2efXykY8FSzByVqav9sDFmL2jaboRf+JgU451hp8zUyQTXxAVmF0DNY/XQ+Kb1arXYMbHeJDiX7lu0z81NX8nWNm0wDd9T7og7TQXN/N1MXIkzX8xBoEt+eQdL39i2AYQXuWR/ywiHW2xJ91NVS9ehZ4pWdqlul0D1hBHlT9lt6Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GhARCajPMZ6ZvCicLYN45XbTqm1g8+NixUdOD8Wr0A=;
 b=Ohlsnchjk5Q2E1Wg5q1l5AepF4m6BIqUC2lLyqJ7GD3wc/2gDYpWJBPOmBrGNzjmKcimhVJqIlK3FA2YmaoS15OBcfnKyarpWGYZY52I/0vPQrigcX1Hg1KXViAUXF6UMznks324meucIiDMCBaFK3raaXtyixNvnX5eT2U4MNo=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3420.eurprd05.prod.outlook.com (2603:10a6:7:30::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.23; Tue, 14 Jul 2020 16:19:43 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 16:19:42 +0000
References: <cover.1594732978.git.petrm@mellanox.com> <217e5a6059349f72e82697decc180ed9b46b066a.1594732978.git.petrm@mellanox.com> <efa8d345-6457-3bcf-4fc3-f1e5e81f34a6@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Do not pass root lock Qdisc_ops.enqueue
In-reply-to: <efa8d345-6457-3bcf-4fc3-f1e5e81f34a6@gmail.com>
Date:   Tue, 14 Jul 2020 18:19:39 +0200
Message-ID: <875zaqjch0.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 14 Jul 2020 16:19:42 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 40860c67-35c5-43b6-9f53-08d82811b72c
X-MS-TrafficTypeDiagnostic: HE1PR05MB3420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB342041830842FA620A0E5FA3DB610@HE1PR05MB3420.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a1AgPVXHs+lBKoqaAX8p+0heJOaVeR7gJwsbQauQAevJ4DwCZqX6EpjWSjxYz6SLGkZjjZnEOzqAYsSwjllHF4OoAkLTNs/s0GvikYzpfQNmApj0OnNV0Ry55Vl4UBReHFFFcd/BehNK0xdX+ki87DqBtMl2lq99vrz5L6hyrucjEUhj6K/fKrYbl1vyt/DojrStKFNP9Hhzkc64KiMaNmyvOQ+GTGJ/TNBKI7zzTCO5quZ7yo982TOM6PbXkqAdzvlfFaFzvgRz4CCEDhpbkPOQGkfNiM6q0PEzCIRJPP7CPexkTwgdCZ+fhCz+/4LO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39850400004)(136003)(2906002)(36756003)(54906003)(4744005)(5660300002)(8676002)(83380400001)(6666004)(8936002)(6916009)(66946007)(478600001)(4326008)(2616005)(6496006)(86362001)(52116002)(956004)(6486002)(53546011)(186003)(316002)(107886003)(66556008)(16526019)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z/erLGZLLk40x5gXsO6jPi/YapApIe62eM12vSdWcBA7BdszlxzXWtJMZGqBkHxpUo2uFTX2HRRl9OIILd79l6Wc57fZjCTER0TN2go1PS4bm1oVAdW0mbcreDWczyX3VzBbiqsDVJa9Thr3QkIF8+HRnNbMySXZby9Ty6N2P27u0IiSSkCrPEsMVepm9BfUffuZrOPQVw8pZdBTdJ29hxfhM+BeO0N4PNDrlgvpkx6qxoEKZoi6FbUxdvjPhb751HRD8Jfseps4JKr1abRQnZTGxZrIesS4e9KLmYDGPpGrPsUnnehhJDxA/8pqLIevKpAGSqXjGMijHYV/jG2iTJ2S7J9Ah7xWWTFcJekaZxCokvCJ5l83GVQTdnHmz54KctY9Bm7pDj8rEcdN4MnwC6fLVw0M1LAOTlbvTVZXnM1SHH1KID189HLIy4D9AS1Fe23vNDvh37z8166iNT4GRpkQkjbubTcSPOyA/bahVgm5JV2pCuXLCsfzBbn0Sdy7
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40860c67-35c5-43b6-9f53-08d82811b72c
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 16:19:42.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NjmP69Gpnrf4f2PEBTGwZ26zekVAPDbRU+FNDXzqo+kSyazc/yvrjGpJIc3IxoYNTARoChIT5dq92Tf2ycjeWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 7/14/20 6:32 AM, Petr Machata wrote:
>> The reason for this was to make visible the dangerous possibility that
>> enqueue drops the lock. The previous patch undoes the lock dropping, and
>> therefore this patch can be reverted.
>> 
>> Signed-off-by: Petr Machata <petrm@mellanox.com>
>
> Wow, I have not seen that this stuff actually went in net-next.
>
> Please make this a proper revert of
> aebe4426ccaa4838f36ea805cdf7d76503e65117 ("net: sched: Pass root lock to Qdisc_ops.enqueue")
>
> git revert aebe4426ccaa4838f36ea805cdf7d76503e65117

Sure.
