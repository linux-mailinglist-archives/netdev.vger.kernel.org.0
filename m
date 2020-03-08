Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F0F17D2E9
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 10:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgCHJli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 05:41:38 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:51854
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbgCHJlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Mar 2020 05:41:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crGG+p4Wr99hxbkQJYYkZ69Bqbw5H0wb3wnSoynp2utGIUeC7WyWPP9N0Bq4nJ+RRGu22h6o1EwqaTQEHyymPeS93H2auytS9a4uET/PRG4/kR+NQRuou8I1HMbvbJoo6TO1JTa9brf8KMDIhp1drajeCIFwjswtbpzb1IoApMVWo1VLwhw5vGFDK2wApqEpn843GbNTeVs+ZKWiu8+/DP+LwUpG2L8g0XIyc/ZxNzl7eb4LMqbfGgF4mFMkrT26Ng6R5P5XCg7i0a9y1O9yTnGpIdZnOHGoYSyBeXe9TcoTXcjGDHUK0XhJrQhtPw5dnkY+3D+U0J6VE8wnXxFiPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uo2iucrCgnGdrNaL/tE+UOkCIpMjSfLlJU8TB0IfhHw=;
 b=kJwZnMpSEgHPYmHCk3nAxwpRqDFYJ2wjVTjwMhn7oWxf+OT24lu4Grtii2+tQFMHDG+z43Bt40Yqn55P/PUmZB1U94STsJ3A1uF4arnATqU6sW2vEakfTY9pPwH5zEhoXmuXg387fLbdlbke8UBkKVQ4FcL3xphCEYM95JJoSKKRj9mI8HWJVwMP10plyQL3f5W13jcJW2mx6C+8Yd5zNjFv+S255+tfrtOpiKuh5Z1YKqJtK23h3Y5D0LkT4Ejnj44ZAagCZdKYfZd+/tgc4zla9lUXqzlmzQOujacwHcNh1bWuvjK6LBrA1QLKGxAbBoJAWF8wRZYm0RtkFgE34w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uo2iucrCgnGdrNaL/tE+UOkCIpMjSfLlJU8TB0IfhHw=;
 b=DmkBQ4ZuCs3LpoNWR3gesTra2DPdxHod2/ryw/tksCoUsZUR+V9eZJhILEQwspBpCO8eqD4At7xMHM7KuP+Vs6VrpUtJtDvnUIn3szC9H6SZopaECO4g8ztCBKHBCWpXoHqxxZmqXW3IB4CRFwQCVuflmod9HbQnNzs3B0HUHJ8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6568.eurprd05.prod.outlook.com (20.179.18.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Sun, 8 Mar 2020 09:41:29 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Sun, 8 Mar 2020
 09:41:29 +0000
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate
 flow table entry actions
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-3-git-send-email-paulb@mellanox.com>
 <ce72a853-a416-4162-5ffb-c719c98fb7cc@solarflare.com>
 <8f58e2b3-c1f6-4c75-6662-8f356f3b4838@mellanox.com>
 <640d8d41-83e3-af9d-9e7e-f8b8f5c6fb68@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <acdcef0b-8b44-6544-59e1-0868296ea20f@mellanox.com>
Date:   Sun, 8 Mar 2020 11:41:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <640d8d41-83e3-af9d-9e7e-f8b8f5c6fb68@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::7) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Sun, 8 Mar 2020 09:41:28 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 457708f2-90ae-4d38-955d-08d7c344e0ba
X-MS-TrafficTypeDiagnostic: AM6PR05MB6568:|AM6PR05MB6568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6568AE622AEA1708AE803B30CFE10@AM6PR05MB6568.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(39850400004)(366004)(189003)(199004)(66946007)(478600001)(36756003)(66476007)(2906002)(86362001)(52116002)(110136005)(6636002)(53546011)(31696002)(316002)(16576012)(956004)(2616005)(6486002)(81166006)(186003)(31686004)(8936002)(81156014)(26005)(16526019)(5660300002)(66556008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6568;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2vb5Vhl4tFtFxPxx3pMQ06HqrWcD5pULuMNgu/qXp7DneVU+fzHFcGN18443XbIJtAkx25cx8fxEfhqBmoC8wCKNhUEb1JjiMyPIxAlVinykdMFtv2t2PJjGm04hRkVfcQJXyTHAXCOvRuSGbg1pTr8r86XxGgKIfL8W2yjUf7Zbla/EPdhHRszANlX9ahkO7PbfhWZ27xvMNRPB0o+O6c9Z6UyeuLE+X4ZnGYuy1QvCa6102hqYrJBdA46qfd/zZWUzy+XXsnlSYMmwQSNXTDp7PyC2Vh0h6QacczM3aYv5Xz6wXns/SCzKqSZhscocC/MAQUCYJl2M1hefnr7fSVwWgZXRnp7biCA1ycCUsLCfI7YuyrtdUXE/gWP5NOrSBo4NhCASPcLVwPWAxW3eZJ0u/nUxYAb1yCHl78VbScRTKJ8+ygRyC20fEB+cqIIP
X-MS-Exchange-AntiSpam-MessageData: /KN/rDVVnzgcruMCtwA2PmF5yvvwINxYRiNk/CUVtbUS8biR7+ew9Q4FrhlQ3EmYtrVEO02bqg7n2ZuyGR7R+nlOdsEkgl2RJsI8YuudZL+SVh8MhNGsFYVjQCUxtfjllXzw8qjCknVKtRw6WmrsJg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457708f2-90ae-4d38-955d-08d7c344e0ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2020 09:41:29.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0eacv8dQuA3iYBbetIgMZR5WGkQiDqiOgNEdCavYSdu7Sbqq/qfrMGvs62QHRabPzOd7FuyQ+zVpGBrw7Sa9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6568
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/6/2020 4:55 PM, Edward Cree wrote:
> On 06/03/2020 13:22, Paul Blakey wrote:
>> On 06/03/2020 13:35, Edward Cree wrote:
>>> I'm not quite sure what the zone is doing in the action.  Surely it's
>>>  a property of the match.  Or does this set a ct_zone for a potential
>>>  *second* conntrack lookup?
>> this is part of the metadata that driver should mark the with, as it can be matched against in following hardware tables/rules. consider this set of offloaded rules:
> <snip>
> So, normally I'd expect to use different chains for the different zones.
> But I can see that in theory you might want to have some rules shared by
>  both, hence being able to put them in the same chain is useful.
>
> Assuming an idealised model of the hardware, with three stages:
> * "left-hand rule" - in chain 0, match -trk, action "ct and goto chain"
> * "conntrack lookup" - match 5-tuple, return NATted 5-tuple + some flags
> * "right-hand rule" - in chain !=0, match +trk(±others), many actions
> The zone is set by the left-hand rule, it's a (semi-)implicit input to
>  the conntrack lookup, and it can be an explicit match field of the
>  right-hand rule (as it is in your example).
> But from a logical perspective, the conntrack lookup isn't *producing*
>  the zone as an output, it's just forwarding on the zone that was fed to
>  it by the left-hand rule.
> So, the conntrack entry, which already has the zone in its
>  struct flow_match (. struct flow_match_ct .key->ct_zone), doesn't need
>  to specify the zone *again* in the action.  If the driver needs to
>  supply that piece of information a second time in the action metadata
>  for the conntrack action, that's a hardware-specific implementation
>  detail.
> Or so it seems to me, anyway.
>
> -ed
I will remove this from the metadata action, and the driver will learn
the zone by keeping it in the cb_priv while they register for the flowtable.

Paul.


