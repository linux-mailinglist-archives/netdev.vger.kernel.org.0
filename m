Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5577E2168C9
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 11:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGGJIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 05:08:25 -0400
Received: from mail-eopbgr150059.outbound.protection.outlook.com ([40.107.15.59]:44870
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbgGGJIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 05:08:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFPSEa3KaSmcIplsrT1bIqcZs0soNWNpZYJWO0pfewjb3C2jSt1kq81nfGqrqM4LB7LGUREWo14YFsf2rTQg0+zLjegLn9gM06pAwIWMKOwGm2Poc7N+Am13GhdJ6IUe5IsmJzftk3GB+9SrmPAeHIrJ18MB+FABZkTqUT1buKBY04es3cxsOhyr55SwxOI6oAFjy04+WYTHAcYSto2IHQRFilu4oOxsRvT4MzfAkTD+59i+UtgsYUFSNHTnaWKvQuoM1WRwfbDIvf+DqFyP0MU/WwaALOcC5T/RUdOicwWG9oPHRa7k+sM/rOuWGNtkXFOcK4cc5cLOLoELuI1yVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bpn38Orczf8agnXZt1JgUZ37vuXZ59nNyBd55ycX2/4=;
 b=IBulwUT2KaJ6rWQLc6f4Twog9cfCMt52XeQqczAoJLzbXVzNJzIoqnh32xR/OQpuq64ELMejwhCoY9DEDxGp7BuOemSMLmtVaXKIlZIIBhWuMQAkXyMRM4RvZgae9T8R9x6wv4RJNbtZN9x8L1Bsjo8kkQhwdhiz21b7HduR3oQcsgw3QvirmhrL0Mct64CR/TQYBO/tOVeWzDzejDb6atieKgRojMGuSqh+g8BhVJphEbNPGPgLJLNss8YmCWVZn6etYlovI2U5laTJA/8Ck8SRUqrs1nUCSTZa13Au/nbzEfuTyjA6kB+EIRbRvrT510+wv62EHKzMYtY7WytVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bpn38Orczf8agnXZt1JgUZ37vuXZ59nNyBd55ycX2/4=;
 b=OlWC/EHHvhhFz82R6LkyJo2IcWY1oFtJ1aeCy8u4dPfMoDi0iYbsqAlfTZIv7xHgVrK/+WJV3xxH6QegSt9pe92z+sG8MVKQckIZBhuP6lHcvM+xf0P+kMgJerEGvNa9MVL5Qo7j/hSML9T2lJkhmEFuB+F8LssKQMxfIkufIZY=
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB5099.eurprd05.prod.outlook.com (2603:10a6:10:21::31)
 by DB6PR05MB4599.eurprd05.prod.outlook.com (2603:10a6:6:4b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Tue, 7 Jul
 2020 09:08:18 +0000
Received: from DB7PR05MB5099.eurprd05.prod.outlook.com
 ([fe80::98a:9ac3:85d1:70ae]) by DB7PR05MB5099.eurprd05.prod.outlook.com
 ([fe80::98a:9ac3:85d1:70ae%4]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 09:08:18 +0000
Subject: Re: mlx5 hot unplug regression on z/VM
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Raspl <raspl@de.ibm.com>
References: <0bc1a170-a643-a9d4-4b3b-2bdd2bb63759@linux.ibm.com>
From:   Shay Drory <shayd@mellanox.com>
Message-ID: <a4c1e5cf-0247-64df-49fe-c55c3d10a57e@mellanox.com>
Date:   Tue, 7 Jul 2020 12:08:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0bc1a170-a643-a9d4-4b3b-2bdd2bb63759@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:208:14::26) To DB7PR05MB5099.eurprd05.prod.outlook.com
 (2603:10a6:10:21::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.13] (37.142.148.130) by AM0PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Tue, 7 Jul 2020 09:08:18 +0000
X-Originating-IP: [37.142.148.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2130ed35-17d7-4b98-47a5-08d822554a3c
X-MS-TrafficTypeDiagnostic: DB6PR05MB4599:
X-Microsoft-Antispam-PRVS: <DB6PR05MB4599FBB8617D676B0D1CB190C2660@DB6PR05MB4599.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZXGp6b43OOmsu4mwCZgL/WWhxgomDBRtE8d3bk3OAJE9b7o5+F3Ikv8T3+Rcz0XD91bN/TzVbQTnxa8GVQeY5ltc9PNNDkq+HRO0lddCh73JEAccrgwUYGHuPlzVjqVytxBYzMQgvZ9h+WWn33d4Np46pMezHzsrPZSmqn2Y2cksMbI97Ob0JBRqyNxyHhdnwYfVStln2GBHe9ZXe7GdiBgHQFdwYccesaQZxHneBKTYPHaetKdUkOH2XMloLywxDN60X0YxWmizWbtxywTEGs3vPkI4qjxeGsriFTo6m9KxJ+VJycqdo7STaBtJdytPFc07aVkLY+zF+HFly5HbYXTDW6j9L3lEvpp4Nnr35SFsmjZzQgzuvyNkHzzco6bnrCgGj1igi5F/NRTKHJuJWzFBshN8Uhvpg0rPtGiHrndph10MFN2Ph+b5s2x6syZwP8+Smuwn6FAgrkCCJkRXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB5099.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(4326008)(186003)(54906003)(31696002)(6916009)(86362001)(36756003)(8676002)(2906002)(16526019)(6486002)(316002)(16576012)(8936002)(31686004)(53546011)(966005)(26005)(66946007)(66556008)(66476007)(478600001)(956004)(83380400001)(2616005)(52116002)(6666004)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8UB/0bmnrv388d1i+JvuvGXpk37VDptSC6tAn1hu1M+dIiFkCkzPrJxTBwpEYf5r9a3W3rzOyUFh1HAudBC7Hfmc0fxs9tPrSXqAAQBKE6y2S1IiirvxcxivWgWs7dXgxzrLakbWR7lqjs/wCEjCFGIYDfFCIZlkvd2ktrOvUsKW3Az21xx/LchcDwr5a47/16gxAKqXiZ3imrOgUO4fczWNusUoQpgwD+O1qA4ypJeUeEDARwpVm2fEowOGVfDY8BYFRCFZeYBVTGu9QeBYPdo9u18zeG2ZzsVkSs+tV+iFQMGasIRr5P4r0spcU9xSC22AB1N1R8iReu++sepqscyY5QQTtxfgsrtTr9MCmSa4MXODREkYknJWokFffYqKH1fnaGAT/6PAavXy0skbVWLvKN1TTm+BPXuOjhqL5qXIK+8agKyYLMCuqSkyTJ29uOuJYPoqtXlaLHKlkgEumSrGBsrvNptxdJgP4Kb1mHx8yOKGjZYa5QVK97CtQhRB
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2130ed35-17d7-4b98-47a5-08d822554a3c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB5099.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 09:08:18.7603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Sy0IuBehJQHDUJKhp5fZmWr5N2UP2jYQAgisE7WL/XbwQDxn9W7FPsZ7MPmark9V1Ak7tNZ9uo7GL5zVP8ufQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mr. Schnelle.

I have reviewed the code and the log, and I think I understood what is the bug.
As far I understand, the bug is as you pointed out in the mail[1], switching the call order of the two function.
running mlx5_drain_health_wq() prevents new health works to be queue, so when we calling to
mlx5_unregister_device() the driver in unaware that the VF might be missing.
I will start working on a patch to fix this.

[1] https://lkml.org/lkml/2020/6/12/376

On 7/6/2020 19:12, Niklas Schnelle wrote:

> Hi Mr. Drory, Hi Netdev List,
>
> I'm the PCI Subsystem maintainer for Linux on IBM Z and since v5.8-rc1
> we've been seeing a regression with hot unplug of ConnectX-4 VFs
> from z/VM guests. In -rc1 this still looked like a simple issue and
> I wrote the following mail:
> https://lkml.org/lkml/2020/6/12/376
> sadly since I think -rc2 I've not been able to get this working consistently
> anymore (it did work consistently with the change described above on -rc1).
> In his answer Saeed Mahameed pointed me to your commits as dealing with
> similar issues so I wanted to get some input on how to debug this
> further.
>
> The commands I used to test this are as follows (on a z/VM guest running
> vanilla debug_defconfig v5.8-rc4 installed on Fedora 31) and you find the resulting
> dmesg attached to this mail:
>
> # vmcp q pcif  // query for available PCI devices
> # vmcp attach pcif <FID> to \* // where <FID> is one of the ones listed by the above command
> # vmcp detach pcif <FID> // This does a hot unplug and is where things start going wrong
>
> I guess you don't have access to hardware but I'll be happy to assist
> as good as I can since digging on my own I sadly really don't know
> enough about the mlx5_core driver to make more progress.
>
> Best regards,
> Niklas Schnelle


