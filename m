Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC81F6A562D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 10:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjB1JzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 04:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjB1JzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 04:55:00 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2097.outbound.protection.outlook.com [40.107.15.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1122BF11
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 01:54:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO9e4nCwxkg5WCpOy1hD0kfK56gv+8RwvuXYJKZqr0hMAf5JjA+D4BLepzp87DSdys99Z7GABWTPhnb5jWYrhqY2iu3i6E02nt1cvbrnSbMw/nkujHliOmljNvuATTfApbCDNfWCaCNV42H6up+YXpXy+7kEEPBkSaqnaYrFEH+KslJ0+FwfLIMWhivW5PxeZAV752DMDqqC3okKQK2U626farJ6O/UWC3p+Js9dH96rO4/u6XEmcbb6ze/1tlBIp4NolBADS5Oaj8dGKr9154KXHdlB438xezDKhNdX4n+znayUrRaGXOG5V7g9jbw1mGXi28gegJyrjK+kH0EfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PN+gb8SKQtOFoM3oO1r1MT7Bmu3aRJlMLqLzv3qrDgs=;
 b=TStGW3vz7H/h6aaZBeuVc5jLxquKr9uFpmsZkPf5VsmXN0fUynontzS1WR99cKzsTctxd38evDGtvrE9t3qPNH76Z9MhowjyUivD0s/j3fktW++0krpBaH/iMdLJaXHP8hkxU0EZx4qI6ToJ6IgLl6bbRV93VAOvwoPXJDyIwBTQBuv3kTCtpE/WZcxWNW6iiF+FY64Z4dJjjp3PU5myGOYACT85LbvIFtf5P3wYQXfVowtDFnGH9aU4IM7sZe09CQ8vrc5STauy/4BUaNVEI8GfC4HK8rROVv2hD8mx0iYTTQ6CsrUFtTZk1TcbkpfvPO+nxbiAlhDJTHjPcO0aYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN+gb8SKQtOFoM3oO1r1MT7Bmu3aRJlMLqLzv3qrDgs=;
 b=r9T1wz25i6aNo9Tje+9Ogxbo7AcJfdnVtyVHnPLZm/EbCNpZo7avkTqsQF/3w4zbH1flsA3aqZedSujlOzyGCJqj3LdjCgCW4Wi1npj9BimgMXAjqOQysjWz8MEAUH2CMqqFjXj/sLitfKgZElBfCG7YSqUWu6RvUJeAallEsL8maRHTquIfxfy8DKYUb1uxqmwitX0tQSS7j0WJi29fjgFiJD9zdPzqKP7ERO/s5ZlFQLZUUt1TfgXhNWW8H5G002Dc8ZzPw6PS4LiBJWU1iJveYpY2A9oFsziqDNelbRII6kFg2pxUJ+Zdbdbv6a3u39q7XVotBc57rZ1m9Ewt5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com (2603:10a6:802:a5::16)
 by PAVPR08MB9281.eurprd08.prod.outlook.com (2603:10a6:102:306::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 09:54:54 +0000
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343]) by VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343%7]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 09:54:54 +0000
Message-ID: <ee004a9d-7d49-448f-16d7-807afc755dd0@virtuozzo.com>
Date:   Tue, 28 Feb 2023 11:54:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] netfilter: nf_tables: always synchronize with readers
 before releasing tables
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
 <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
 <20230227124402.GA30043@breakpoint.cc>
 <266de015-7712-8672-9ca0-67199817d587@virtuozzo.com>
 <20230227161140.GA31439@breakpoint.cc>
 <28a88519-d0e2-7629-9ed9-3f9c12ca024b@virtuozzo.com>
 <20230227233155.GA6107@breakpoint.cc>
From:   Alexander Atanasov <alexander.atanasov@virtuozzo.com>
In-Reply-To: <20230227233155.GA6107@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0085.eurprd09.prod.outlook.com
 (2603:10a6:802:29::29) To VE1PR08MB4765.eurprd08.prod.outlook.com
 (2603:10a6:802:a5::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR08MB4765:EE_|PAVPR08MB9281:EE_
X-MS-Office365-Filtering-Correlation-Id: e2cc6967-31de-4d90-8510-08db1971d768
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8okNY+dGIsnDXnb8SCyUZrsXEoCeYNeDahqG1Yqqdl+1XqWlSkWoerKz9U47y/xIBhqo6acImSKW5kdq66ZXWydb0p5lwohdg3MbvH6Oa4RB5gvHHJ5Ep9ZwrwGMiR5ZFMoTQ7E4IBCQoR975c/++uIW1YTqQch2DCE8A9q3MjQP5Dq4TEwQMLA3jiS2+mvB44e9IDEwhpfTTxiz295SJbyV/UI5Zvq08HhkveUWuUbZMNI4hZiKuPZiL8z7ksf2B+qbaMAOsOLVFAIwSlbaa/uWkEvhxkMiBaJlUSBBHMVA5yI3riGrapbNQb7zxttdDhaWC3L1U1hPof/D2MeSSsMX7dC4Lsd/1F8O41h+hWbtacalenuzyjvM/WwAhZLJAyWJ7GhIbVt2TbC1M9Ghx6P2/r2K4BRq8Ci8ZHqvEt/5tEGnjTtYiD/s6bllmaTAKuLQ9iBUnKxSjfWXJht7BwR7D5lA0N4+Ng7Q1e4rLCGuPe3U6F+LCauS8/oAkDVxglUalO86jEHAETAxTbAoeBFokmkijZsRffBdKrJkJjP4HHmcsT91F3Cle/vQ4IHmeUJkZww1rkZAznaQwA/gCDO/neXKMPT7+fl1JpJV8t7WpsKVKah+Qi1URTRaexkEmu72Z5CPwdqs57iPa7fbJw8XVhHMYsuvBA485eltKtrJjk7m2hRhqvXbTj5B3qCmq7nyphbVKYmmhsAHHRbP04xxEA/xrDUMSH066DPu4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4765.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(39850400004)(346002)(451199018)(5660300002)(4326008)(38100700002)(2616005)(2906002)(6916009)(41300700001)(83380400001)(8676002)(478600001)(8936002)(26005)(186003)(6512007)(6506007)(36756003)(53546011)(66476007)(66946007)(66556008)(31696002)(86362001)(6666004)(31686004)(4744005)(6486002)(316002)(54906003)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0FHZmwxMFkzd0VsRTNscUtYNyt4YjlpMWpWRncyZ1ZRbzBBcHpWSjY5WllG?=
 =?utf-8?B?WEFuWDBTQUpsTXFkVHphR0w0VTJGVDRNSi9vaW52VnROOXoyY2pZc0FFUEk1?=
 =?utf-8?B?clRHU1ZBdEIxV04zaWh6QmhsNXdma0ZpRXNwTGNHVUhQMzFqeHF1ODJjSk8x?=
 =?utf-8?B?MytsR0xTOGg0NlRZUFh3OEQ0dVFady92bEIzWlVRMUVnWkJOL2sxUDRrbkx6?=
 =?utf-8?B?TVlnTUt4KzRiWDBjN2t2TlRVUSt5N2FEMVJ3K0pPcUZsUmtHTjBySFpjWVg1?=
 =?utf-8?B?aVkySm04U2J4WGJSNS9IOGNwSXgraG13Z2s0bWpBTkF4YlgrRHZhdG52cXpY?=
 =?utf-8?B?enExN3lHdDVkMzJoajBJS040RWM0ZWdUalpxNU9zZHF2Y25WSHM3d0c4QTdv?=
 =?utf-8?B?ajBNRU5zUTZUdyt2RFpLbFNqTzBkQ1RHQ2piaUVSN0xDb3hBS1dyUnJxdEww?=
 =?utf-8?B?VXZBYnRUS3AyK0xTbFZiekpZZ1prdVM5ak9qY05DTlp4b3NOUXVOWENJYUs5?=
 =?utf-8?B?NDR6V2JaazIyMlBkSmxUeWVoR3dBb2FEQ1lvVFp2RVhsRnZpK0RtSXd4K1o3?=
 =?utf-8?B?Rk81RXZyeW9rM0dySSsvYklZa2VIaWRVd3RGUXdpZ3BYK29QZGY5T2hyaTdU?=
 =?utf-8?B?UU5GTm5JQWQ0L0pwYThScW5PZmI0cmRKa3VBdzljZnhRNjhoMjFsRHdEK094?=
 =?utf-8?B?bTg4TWNMU0NjbXRiemlFMzFDV1p1aWc1LzZMTWRWdEFkQzZkUjhJSHA1UUkx?=
 =?utf-8?B?dkZLY0Q5SUFQODRPREdZSkNZYktTSWZzZFY5RzJPRExyMm9LUHlUM1lHdHdQ?=
 =?utf-8?B?NWY3a0paME9jZWx1VlFHWVhpKzNnR0lCWDVEdGkyUTBXSExSbC9hRm13N2Nm?=
 =?utf-8?B?c2pFeGJrVEZHYnlxaXNhdisvWUNQelZqRWl1K1RuSzFSOC9yOFIrUWFxcGZU?=
 =?utf-8?B?Yk03Uzh4Y25NUXhUODlZTEtkZFVXSmJrUlZueVNlazZ4c3p0MzNiejBUL1l3?=
 =?utf-8?B?bW44RCsvbDlkUkEyZ3ZYMlpqN2s5QnB1VlNCUklPVHA5Q3lXcmR5VVJYZUx5?=
 =?utf-8?B?aEMwNXV5WXBnVGFKUnhXaitITzdLTm1sQ3A3bklFVmprK0tjS3IrRHpyVVRS?=
 =?utf-8?B?TmxBRmRnMWVCdUJZaFdERE5aZVdUWHdKV1lyZjVSa3pOUWpEUG96NmVYQk1r?=
 =?utf-8?B?eEcrbzVyT2ZiUGJVVFdtSDYycHQ4a2llZm90Nm9MbnUxMzN5Wkp5SURRZDNQ?=
 =?utf-8?B?ZXhGa3hNVDNzMXd4VkVDVFl2d0pUcWF4TmRhUGlxTWN1Q0pKSDVZaDNsK291?=
 =?utf-8?B?WEl3U3NGbE9LVGkvRWozQ0IyT3BiUUZQdzhUSndvM3RqeWJQUy9UeHlSaTFi?=
 =?utf-8?B?QVVOZDdmNUU5dGJ3aTFSUHd1WjFtQytwZFFxREVUY0hHdVBSczZpMkpPOEhT?=
 =?utf-8?B?bm1GOXFUdnI5citLVm5HS20vZU94MEx1dFV1bU9XOTN1Y2VBUW1UVnJNQXUy?=
 =?utf-8?B?MDl3VUV0dEgxczNYQWpiUHZ3RzRSYjlUTVkrT3BuY0piaUVCNlZDRXFGLzd1?=
 =?utf-8?B?cFRNc1RZNXJBdVZNcFRrRis0czRQYVRab1cyc3NQcEVlZWhzY1ZTamxQejBh?=
 =?utf-8?B?ZmZkbEl1VGNHd2tHcC9MdzhjODA4R1FqaTNRd2VGclA3ZFp5QjlhUktGVTB2?=
 =?utf-8?B?RTFBOWNqMCtRTWZQTmNlYWJiSmpXZDZzOVZsNkxQcmZmSnk4cDY4ajBieCtu?=
 =?utf-8?B?eWo2cHdKYjFPdE1icWxVK3JleE02TUFDc2VmL1NvWXJnaVA3WXlSUUZ0NGM4?=
 =?utf-8?B?bGRHN2ZzMHhWSi9ncW5YOFYxSFI2ODVEd0h2S1JDcmRzeTdDRGtuV0lieXVk?=
 =?utf-8?B?ZjN4QVJLanptSy9OT3FiTnVvQWhRNXNidzI0bHR0ZkhzZ00rR2Y1ekFlOElL?=
 =?utf-8?B?TFpQcTVyS3dPTHdUcVRSSHJKZ2dGdGk5ZHJuQXdzQlIwbHhzSERKR1ozbVZD?=
 =?utf-8?B?ZVJaU2NvbXpYbXdMKzN0eWpqVHg5dk9ZdklsT2RwMSs5YmpGUDFUS1NnRU9B?=
 =?utf-8?B?UnlFRmV0bFlncFE3Q3pYaHFwaEhKRWhJaytNQkprdkNjNnVnSnVILzJ1UWlX?=
 =?utf-8?B?SlNiS082U0xNTjFPZEI4OGYxdDZBT0YyR1czUlpnczRnUU5MbVVxaCsyWFlm?=
 =?utf-8?Q?vys2p3xiiGPU+JEYCQ1BFU4=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2cc6967-31de-4d90-8510-08db1971d768
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4765.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 09:54:54.0569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o4oOhuAsvMJjjGLKQ8FWYkmV+r3i3TpJohdK4u8dLTTbrdfoueUllbYCKFNc77ei6x3GTbsHKmoCb6eJFWz9LezTj62DKd0TB8bt6z25AEkNON0SjEWcollOU956jN2S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9281
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.02.23 1:31, Florian Westphal wrote:
> Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
>> As i said i am still trying to figure out the basechain place,
>> where is that synchronize_rcu() call done?
> 
> cleanup_net() in net/core/net_namespace.c.
> 
> pre_exit handlers run, then synchronize_rcu, then the
> normal exit handlers, then exit_batch.

It prevents anyone new to find the namespace but it does not guard 
against the ones that have already found it.
What stops them to enter a rcu_read_lock() section after the synchronize 
call in cleanup_net() is done and race with the exit handler?

synchronize_rcu() must be called with the commit_mutex held to be safe 
against lock less readers using data protected with commit_mutext.

-- 
Regards,
Alexander Atanasov

