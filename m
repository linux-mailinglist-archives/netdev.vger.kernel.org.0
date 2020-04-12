Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481E41A5D6A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 10:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgDLIOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 04:14:45 -0400
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:10277
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbgDLIOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Apr 2020 04:14:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkODFjmOVyD7W/QCKKHQuO0MYrbmcO6y+j6k/Vt/ambeKvVzaD0gpGuPLA4SZ5JAnther/dKmS2knxBRMXIib5ZpzOzsEIDJngPVIdFrv6pZ/V+uS4c1W4EvaunpZLqz5O/XeOUK+woJWlD2Tyv1KUQ4hSBvOgVYzjTN/mghsF+QDdyaIExVEEHsuG8oOjrPF0pWGrzNIiqB0vbZARapGUkx0ySDuQe9snLAF3U4leP0GqSNKoqJ66vFjxpM8+8IytvcX2OBQMpG89VtErnEVp1BMUzK0k+nLM31DOciJw5axYZo5LT6mLJqi5yn3lZiy1vEpOdTqXE9w3eHhLSwLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp+M80PlNmgf2kMZbHALXg/Ry/Wmh10MKTx3shaqjZI=;
 b=eEVNQ9wPxBu7cbN52DkvSEEntIxY+HClqIOIT5hQZDuDciwl0voc4pR3alqHs2Ic38cg0ajsprBFbh+xya2gD/QT2jUhIUV23Zr7x8LP4k5dOb/soz8qNjyRYvpCflgFHNQHaP24MrBqJbLofBp4BZoaTHM65T8eonfAxOJEi7z6WHImYXw/w2O6m3mL7VU+Kd+xFHYvL5kLo8w5DlToAESs3H7zUttMnN+NjRleeh+hOhlFy37F90DZSdLj47t9mPmjgj7NNdCCP6WC8yj6TXLo7ULVT7ZlGGLf/U7QtF/5R9nquRs8ykwCJW/KQ8j0vhJl89mbdFbgOpSiVylUaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp+M80PlNmgf2kMZbHALXg/Ry/Wmh10MKTx3shaqjZI=;
 b=G4Xh6HEMYjD8ZWLV/nZ+B8uhvvoif8eMUtJ9vceyO9kAoOnc4PUfn+idEG/bOpgx83+EQl1ldJ9XPZJ4iFaqdsUr08bGmNKhEjQWThjT98V46Yg9UJkzcdFpR+arV/bu7ptrr4mb7XC6DVxjFoeoWW13kqhhLRl6ljYxcDBmABs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB5210.eurprd05.prod.outlook.com (2603:10a6:10:65::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.15; Sun, 12 Apr 2020 08:14:39 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::d12b:b2d7:95a0:8088]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::d12b:b2d7:95a0:8088%7]) with mapi id 15.20.2900.026; Sun, 12 Apr 2020
 08:14:39 +0000
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing to
 _once
To:     "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
 <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
 <20200403024835.GA3547@localhost.localdomain>
 <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
 <20200408215422.GA137894@localhost.localdomain>
 <54e70f800bc8f3b4d2dc7ddea02c1baa0036ea54.camel@mellanox.com>
 <20200408224256.GB137894@localhost.localdomain>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <6f4e8a85-ede4-0c10-0ef7-0d45f2b7fc73@mellanox.com>
Date:   Sun, 12 Apr 2020 11:14:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200408224256.GB137894@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0050.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::18) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM4PR0101CA0050.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17 via Frontend Transport; Sun, 12 Apr 2020 08:14:37 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9b45e72-e58a-4570-3541-08d7deb98bae
X-MS-TrafficTypeDiagnostic: DB7PR05MB5210:|DB7PR05MB5210:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB5210EA82E548EB4FF813C497B5DC0@DB7PR05MB5210.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0371762FE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(86362001)(36756003)(478600001)(26005)(31696002)(8936002)(186003)(53546011)(956004)(16526019)(2616005)(31686004)(2906002)(110136005)(54906003)(6636002)(66946007)(66476007)(5660300002)(15650500001)(4326008)(8676002)(16576012)(52116002)(6486002)(316002)(66556008)(81156014);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4yeppOMetpe7HmVg3NSdWO1PDqzfkyjIX64N84aU7xUr0XVHWKFt4jHbw7NGQF5oXqWKG4/y6GOXSK5BxcJuJ+oBvEYJdq0+NwNUacfnJKt9PYY36pMnPzfuTWwZ1M1oLuKgGYaexjc0x52j+NYIVBLWCLqoi/T9rV7vx0gwVAD7rFELLJ8tz9cy4OfppDbXgzxJ9LYB+HT6zD/CNAgCqyz8rx355CninkmdF/kqrHTH2cG5XANpF0P+VyrVDDc325uSkztN4EBLElaZOMx45/qB7Ea0aFkRSsypM24Cfa6YnKyy4Y5AKI2Mp0roe7/WrT5RSBNLBgJASgUfneN1GjtTBPccSQWxrofhuxDYtVzqp3HyK/c6U/wOXlTEsvlioflUE6eklV25e1azXIjLuz6SHmgjO5/sc/Z6iOJOQ0IQ8QxKEzT0JbZpFPa3Dnm
X-MS-Exchange-AntiSpam-MessageData: d/t256TqIVUwUynhyaSo1kAuuqhtmQlqC6+iT0xoBA9a5VtX0aAADPz3i3xinw9OY6q2AhWhhoWkpcxrOiMihvc790SFSQL/IdGxHOwwPJOli/GzRPopH9fL5mDN7n0XOr62a+SlKxFawO8g8x7zYw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b45e72-e58a-4570-3541-08d7deb98bae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2020 08:14:39.2039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFqbBAiUNs695lKbijm5HmzQu8B9NZKGffFzBc3QWpXvGSOroi1X5rsQ88Q2hxSLlYt4p0HjlDPIhgYsg+bluA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5210
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-04-09 1:42 AM, marcelo.leitner@gmail.com wrote:
> On Wed, Apr 08, 2020 at 10:38:52PM +0000, Saeed Mahameed wrote:
>> On Wed, 2020-04-08 at 18:54 -0300, marcelo.leitner@gmail.com wrote:
>>> On Wed, Apr 08, 2020 at 07:51:22PM +0000, Saeed Mahameed wrote:
>>> ...
>>>>>> I understand it is for debug only but i strongly suggest to not
>>>>>> totally
>>>>>> suppress these messages and maybe just move them to tracepoints
>>>>>> buffer
>>>>>> ? for those who would want to really debug .. 
>>>>>>
>>>>>> we already have some tracepoints implemented for en_tc.c 
>>>>>> mlx5/core/diag/en_tc_tracepoints.c, maybe we should define a
>>>>>> tracepoint
>>>>>> for error reporting .. 
>>>>>
>>>>> That, or s/netdev_warn/netdev_dbg/, but both are more hidden to
>>>>> the
>>>>> user than the _once.
>>>>>
>>>>
>>>> i don't see any reason to pollute kernel log with debug messages
>>>> when
>>>> we have tracepoint buffer for en_tc .. 
>>>
>>> So we're agreeing that these need to be changed. Good.
>>
>> I would like to wait for the feedback from the CC'ed mlnx TC
>> developers..
>>
>> I just pinged them, lets see what they think.
>>
>> but i totally agree, TC can support 100k offloads requests per seconds,
>> dumping every possible issue to the kernel log shouldn't be an option,this is not a boot or a fatal error/warning .. 
>>
>>>
>>> I don't think a sysadmin would be using tracepoints for
>>> troubleshooting this, but okay. My only objective here is exactly
>>> what
>>> you said, to not pollute kernel log too much with these potentially
>>> repetitive messages.
>>
>> these types of errors are easily reproduce-able, a sysadmin can see and
>> report the errno and the extack message, and in case it is really
>> required, the support or development team can ask to turn on trace-
>> points or debug and reproduce .. 
> 
> Roger that, thanks Saeed.
> 

Hi Marcelo,

I was somewhat in favor for *_once when first read it, without starting to
enable probe stuff but I guess *_once will become redundant pretty quick.
another option is debugging with tc verbose flag but ovs doesn't support
logging extack errors today.
checking ovs issues on a large system with many bridges/ports/rules without
the tc/driver errors in the log will be very difficult.
in some places we already only use extack without netdev_warn.
so currently in favor in removing the other logs if extack error exists to
avoid flooding the log each time ovs age out an unsupported rule and re-adds it.
i'm also in favor for the trace points to ease debug.

Thanks,
Roi
