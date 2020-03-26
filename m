Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA31941B7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgCZOmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:42:09 -0400
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:12814
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbgCZOmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 10:42:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGIdf3jf/UfO/gAuqL8FTCPqq3MF84R2HuycG628AuIiwWzj/OemrMwLU76RvqFVD8eQTAtdI4bgWeE8kY9jC2W8I4AsFGsX4JCJTXuMh5PbhuZtwo+WRqmL56FTs2+iUnqOp7Chgp6K7sGhswYyebAfIBY/EEcAgO26YkdiNHLvLrqv3rExcYDWEQThPWwr+Xm2czEaGPOMlCV2dPe5pBWzEDELc/HCX1SI02wdg4q0zjgq037mQRRfdHxNvLCXEC7HJZW78VGoyWz18ULnDcn8zF3H886FCM0rESSMP5Hxqqotuc7XQRp+oGxpeJ7yTcVc1XHGVT/7ZLaxetRT8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hQbROGlvPFRYh5xDKD15lREgpfdls+tFdb2tp9kDR4=;
 b=DY+nWYaaEE7injX9W8kafrPmBpCia+/KoVOZk5dFtdy7r+BwjX7vVOxmd0MOCzTQEekegZvxFrBZqaB8dGBdDFJX0SdUXZeTPUqFLC9/3BsqJeXnK1JclpnmnIQrAKHYE+UxolWEFVphABcL9x8qTGnanMj6Vg8WqefQ4Pw5QNgAw0aNi/xV4yjpc528f67D78/06ObQar/GKUHbQosWiVmY+bsESVZ+hq8vR7yiSpJJ27ibBFIiMAyrJYDSr7IgDYujuVLYfuvlbzqW2POzlzrZYRYaGc7LSWirbJbLOJmMjJ8ZtuB6qX+NLfbRybWI+x6HW+MKZb1p8JdmxdlbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hQbROGlvPFRYh5xDKD15lREgpfdls+tFdb2tp9kDR4=;
 b=JwtnGjXHsY1VTo7/ooZe2yyAH5QYsCSf7Ch6FT2lpsOa/TPVm/1WqH35L0yyTjkm6R2boxbTy4Sl8CrXjZMuXthVK0f4JBrpnxJTdm5LA3w4QPLYMxnKuaWpqloLdV/ubP6hWgwa6/kdk2TEcV354RWsURY4AR/g4lDhevba8zo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=yossiku@mellanox.com; 
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com (10.168.21.32) by
 DB6PR05MB4534.eurprd05.prod.outlook.com (10.168.24.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Thu, 26 Mar 2020 14:42:05 +0000
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::d58:c039:72df:3c2d]) by DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::d58:c039:72df:3c2d%7]) with mapi id 15.20.2835.025; Thu, 26 Mar 2020
 14:42:05 +0000
Subject: Re: [RFC] Packet pacing (offload) for flow-aggregates and forwarding
 use-cases
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Rony Efraim <ronye@mellanox.com>
References: <d3d764d5-8eb6-59f9-cd3b-815de0258dbc@mellanox.com>
 <4d16c8e8-31d2-e3a4-2ff9-de0c9dc12d2e@gmail.com>
From:   Yossi Kuperman <yossiku@mellanox.com>
Message-ID: <46bb3497-a3cf-84ce-d0b5-855ecedbac15@mellanox.com>
Date:   Thu, 26 Mar 2020 16:42:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <4d16c8e8-31d2-e3a4-2ff9-de0c9dc12d2e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0026.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::39) To DB6PR05MB4775.eurprd05.prod.outlook.com
 (2603:10a6:6:4c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Yossis-MacBook-Pro.local (213.57.108.109) by AM0PR06CA0026.eurprd06.prod.outlook.com (2603:10a6:208:ab::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 14:42:04 +0000
X-Originating-IP: [213.57.108.109]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5b022fb-5994-42d4-b10b-08d7d193da79
X-MS-TrafficTypeDiagnostic: DB6PR05MB4534:|DB6PR05MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB4534C3AFD3B34656C026A6E1C4CF0@DB6PR05MB4534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR05MB4775.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(31696002)(478600001)(66946007)(5660300002)(107886003)(6486002)(66476007)(66556008)(4326008)(8676002)(6636002)(81166006)(6666004)(81156014)(86362001)(8936002)(6512007)(110136005)(2616005)(36756003)(956004)(26005)(186003)(16526019)(53546011)(6506007)(2906002)(52116002)(316002)(31686004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VoMbBFHVszrhleyNUVDbfqPzSHYqYusTnrmULAD2U8S32FBwlkD5faFM+lVN+DLUhidm+KSpwtz2ZOwV8qYcwsTbnpYAFudA2BVarBJn5bVm7Epp6ECvLx0JskEmZkgeXcQdo7CzaGqFFQu8IjT+Sq09fxJT3tXA+m8E2ssSn5/SGTYdeM2KTfHbhXh9PgXy+uY7G5VFLxAn24+1e6+c5tAwkIWtiAI7TJ7vjbu63e0ItToAqwR/kt+QRbFkjEi/UbCxYA/ZqQv8AwoW7Iu0llU5mVUSlep7FYZwc57JlgAD0N7bijcRMn1v6Ji8zN0UvFqOFCyBBvbMkN78CyY/KBHf4WjomWALhbgv0DCv0bkHxZRNxlVjPwl52xPRoyHODYX+n3vWuE4ZivW+VVsLlXfCwzS1oWYNXYkV9xRAo1Phh/yidAL6be+MmBrT52b4
X-MS-Exchange-AntiSpam-MessageData: 8wP9g97jOAyPo/j2IIZB5+qMLzCFrNxqrs0w3uKwGNz85cn7J3k/ESs5v512thNdvLdDbsw1xt99lAh00cwKBbbYspToBgSNtf6CHMfLz0E16WzVicFfU4LOjRtlpGXWultgo4SKlC8Q7NOUz+tkMA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b022fb-5994-42d4-b10b-08d7d193da79
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 14:42:05.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waZu3+gxQFUBjaqpXXqc51C/oAYnvWLQVxywfOpWH9O/WhuzSvk4uyGzj5U5YbRbvCT+d4IKv1Wjx81B2Zb+VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/03/2020 21:26, Eric Dumazet wrote:
>
> On 3/24/20 12:05 PM, Yossi Kuperman wrote:
>> Hello,
>>
>>  
>>
>> We would like to support a forwarding use-case in which flows are classified and paced
>>
>> according to the selected class. For example, a packet arrives at the ingress hook of interface
>>
>> eth0,  performing a sequence of filters and being redirected to interface eth1. Pacing takes
>>
>> place at the egress qdisc of eth1.
>>
>>  
>>
>> FQ queuing discipline is classless and cannot provide such functionality. Each flow is
>>
>> paced independently, and different pacing is only configurable via a socket-option—less
>>
>> suitable for forwarding  use-case.
>>
>>  
>>
>> It is worth noting that although this functionality might be implemented by stacking multiple
>>
>> queuing disciplines, it will be very difficult to offload to hardware.
>>
>>  
>>
>> We propose introducing yet another classful qdisc, where the user can specify in advance the
>>
>> desired classes (i.e. pacing) and provide filters to classify flows accordingly. Similar to other
>>
>> qdiscs, if skb->priority is already set, we can skip the classification; useful for forwarding
>>
>> use-case, as the user can set the priority field in ingress. Works nicely with OVS/TC.
>>
>>  
>>
>> Any thoughts please?
>>
> Why not using HTB for this typical use case ?


As far as I understand HTB is meant for rate-limiting, is the implementation fine-grained enough to support pacing

as well?


