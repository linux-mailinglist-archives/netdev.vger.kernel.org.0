Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C241824D8
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgCKW2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:28:03 -0400
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:27680
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729848AbgCKW2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:28:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PK1+OPoUUWlqgKUw7Sue7p9mCV+owRU4M/fN9xhgbU108OV2Nax32+ZMaw+8ZVKKi/pBNV1rmYPdYrQDmB/HIxIQOtZZYG9eIqt4yOijaE5VhEbnZyf3cZ7jX3Mx3tp3qKCy2ZW6OciNL1MwwPhAKjQ9emUD5ijbCFs2FpbrMPKifEZlexuAlbnKf3RTVJMEhx7TWb2ftTg2IdUX1Ax22R9uVz5L0RTIll6h7qNfExliIMYPyLT3hOs8Dby1pScqO3Nw0LuhxEwLBLJBYUr6RIywlvZzcb9ePaVRc3JM9MXhmCu89wOb7ut3dwMUdmR4qN3UJBEJ9R/aUsPF3A+kzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVXq7F9ra/OlsRVF8+U4xF+E0DU9L1uSHHBK7A56k68=;
 b=RRcvfEBH/gi5emXJUQMyM17ImJIPt1U6JwQscc4Sq8Zcmml3t7iK6S2eS/ZQ3WqEfMODDVq1hFYMPXv6twWnVNSTBUFI/GwXWQtlCkCpxkx3aEUAJ0YpxTSlcY9+bAhAprFL+wRrGn3kPbz3wczzt3ElXP7SYjvP8aZulXJOdFtSv+7IIz3T8KHs5euFgV1fufahr/RitIk0GqC1Lmj8GIHKbr95wH7eNSWTNFcVGAYxvBjonK7ulZT+zM6SXgBZBUvbP5j4QonP2uSHUi+KrF+k4WbJKUIzc2HE3R9no2qu5kRokkFtGvOF6wTV9Rrp41zfA3lZP8uZLmv+7UTGYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVXq7F9ra/OlsRVF8+U4xF+E0DU9L1uSHHBK7A56k68=;
 b=U3gE1wNFqeX7Z4TqSwSH3brVRby50g7n3mvbp/Imt6pjpunv0qbBJZ1azOA3Ikixue1ZDqipHBmsq+azxckPs+duq0FcQFfAl8m/hxiqJbyFDUAGzZ1/3Pf5V5B6oS3lyj11BhfWe8eOIkUVRP2NauYOtVJH/AXMWOlgLWStXX8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4293.eurprd05.prod.outlook.com (52.135.162.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Wed, 11 Mar 2020 22:28:00 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.007; Wed, 11 Mar 2020
 22:28:00 +0000
Subject: Re: [PATCH net-next ct-offload v3 04/15] net/sched: act_ct:
 Instantiate flow table entry actions
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <1583937238-21511-5-git-send-email-paulb@mellanox.com>
 <5b3b483b-28c8-6c08-7ce8-365cb717061a@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <ad8717d0-a207-06f7-c551-f0c7bfa28f3f@mellanox.com>
Date:   Thu, 12 Mar 2020 00:27:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <5b3b483b-28c8-6c08-7ce8-365cb717061a@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: PR0P264CA0187.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::31) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR0P264CA0187.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 22:27:58 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc2b69e9-3374-4bf0-e883-08d7c60b74a9
X-MS-TrafficTypeDiagnostic: AM6PR05MB4293:|AM6PR05MB4293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB42930730107FB5A326C42DC0CFFC0@AM6PR05MB4293.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(199004)(52116002)(66476007)(66946007)(66556008)(316002)(4744005)(478600001)(5660300002)(16576012)(110136005)(31696002)(8936002)(36756003)(86362001)(53546011)(31686004)(6636002)(2906002)(6486002)(956004)(81166006)(2616005)(186003)(16526019)(8676002)(81156014)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4293;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QAk4nc79hxW7x3bVeAM8ADrL/RL405l9Xgz0b1A0e5MIPlfywU087mYzerWmFB9AZ6kzUsnoV/Wl8MU1INXaA5dyF/62SE46DCyyjfl4yy9NXszwaL9kpq5JpR3vfCX6FyFCh3BfPYDCmRTxbU534y91keqMrn8dMKu7A+Qf0Gr7jHX47Gr6HYfD9WhGofURq/ijlrqpEnxaC2VfDm8OGnOeCgUykqLEhsUPahbkCbPCmoChoOdmXNTHywekoYwXw6VGA1lBaFkhVvZbQCeQG64e2hS4voPXj8x8b/utUELATYS/W4C+CxuKFzYwgSISaTns/7yc6+g7wo8Vf8OWCyn/K4QHr0WJDdo9o+o4EF7kmwyTpuhvbhS2pI1PcPNX3F83FuoKc+0uwVWSawV+TXbvq6ptIz/2JTA7xGT54iIm7vCXue4mQPWOte/nnXzL
X-MS-Exchange-AntiSpam-MessageData: 0iBwnohlTB8k8AZnR+I495FfeMWZsbCVnTjY7EKuSI5mCVZPD8o0Ts6oOw/rEDmH6Bt9Dhlu7/+7kqOTfoXda8i6jaihu6WjvWWE5TelXgByMOdNiideDexglVmLwR+ekNt0XnJGbi75v/s/aJiXeg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2b69e9-3374-4bf0-e883-08d7c60b74a9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 22:28:00.4683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKwl/MhjcEHWRiXGDoXraMJtkAuPBhipXjzJj2KGC5VeWWJaRwvuBWrVPdGRebgDvqqdtJiLKhPe44iWCFRPHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/03/2020 19:41, Edward Cree wrote:
> On 11/03/2020 14:33, Paul Blakey wrote:
>> NF flow table API associate 5-tuple rule with an action list by calling
>> the flow table type action() CB to fill the rule's actions.
>>
>> In action CB of act_ct, populate the ct offload entry actions with a new
>> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
>> zone information. If ct nat was performed, then also append the relevant
>> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
>>
>> Drivers that offload the ft entries may match on the 5-tuple and perform
>> the action list.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Edward Cree <ecree@solarflare.com>
thanks!
