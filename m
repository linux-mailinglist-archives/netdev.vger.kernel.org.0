Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85071220E1D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbgGONac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:30:32 -0400
Received: from mail-am6eur05on2044.outbound.protection.outlook.com ([40.107.22.44]:14017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730872AbgGONab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 09:30:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPrRkOi2F6e4uftZiGz/KFUqUqZsdA7SebnGCz2dFn3crilG0r2lU7TXQ35imZ13vIUF9/l9ddIO9F3m2mEVvG+WPZ2HxxLO3GfkSipR35DUj3CmuX36cNR3uKg4JrPSzzpiJ2QTSLziFTETVi4VU7tSuZlVjAn6lnVnKZQ0oz9MDA09haTj5I2S3C650QI7CScq9nRzKsg7WNZPXFzbAgYKlJbHjt3M4Q1WxE1JHr8F4Zug1N9j9gV43R/y4ScRrMa7qOXURbHdwB3cm/WmNwMmrUDZAN4sa6FTesN5HNuVr1WtC6psM+odtGCdDEkGupqLlcAlh5djs4uPdFh0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVEpEogZM1WfJeub/IkFBE3M3DLti7+waqsA8PomVIc=;
 b=Fi34J5sk45h346WkYLccWX81uGOnPEiLGbKZLBVOPouISIKA47wN6loPXcWqN5N6+vU5Jv7FIA0voB84qNWoARKwlnyn9a1qbvOpKKca/DQWpODA3RFYuyAYZjIz50xrsUCE4L+K82tyJHj7pb+YUjtqOWnIagSlLlYfh5+j92d5bwvN9/n6C3IiCMn1cYmyBA6PHVVOVNQeZVX18mZ6jWy908UtuCg7TD/lDWDdU3m9FHRKoe8LSI1YGVyRbh1xZq+m00J6ITA0PD0fW7EHngYHNP23VnG1S4IcKfqKK8L3iO2MebMDkUG2p0EcMNhEi3yRGf4hI2f1uTVW679MQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVEpEogZM1WfJeub/IkFBE3M3DLti7+waqsA8PomVIc=;
 b=O3FrXU1KEdo1MYprT9lKojXOwP+EyybKf+74+XGCPMmhIYl8eM+Dr83YjvqN2v0w7o8EyztkwRzlIbg7JPZ+NeltLPzZUDnBXCH0hXcmUOoqKxHNvOwHlYE0/jat8LenFJXQ8WyyVsiAeTfM0A5xvgO3SNg/JaPTpEG7TB5+tHI=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DB3PR0502MB4025.eurprd05.prod.outlook.com (2603:10a6:8:8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 15 Jul
 2020 13:30:27 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 13:30:27 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v3 2/4] net/sched: Introduce action hash
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
 <20200711212848.20914-3-lariel@mellanox.com>
 <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com>
 <b4099188-cd5d-cbca-001b-3b0e4b2bb98a@mellanox.com>
 <CAM_iQpWfwOLKufZ4sJk9BP-BMcynmt327WRdNRC5vrGQ=7sT1g@mail.gmail.com>
Message-ID: <2cfac051-e2fc-e751-72e3-237aa20e7278@mellanox.com>
Date:   Wed, 15 Jul 2020 09:30:23 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <CAM_iQpWfwOLKufZ4sJk9BP-BMcynmt327WRdNRC5vrGQ=7sT1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0034.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::47) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Ariels-iMac.local (2604:2000:1342:c20:a873:455f:b003:ffde) by AM0PR07CA0034.eurprd07.prod.outlook.com (2603:10a6:208:ac::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.13 via Frontend Transport; Wed, 15 Jul 2020 13:30:26 +0000
X-Originating-IP: [2604:2000:1342:c20:a873:455f:b003:ffde]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ceb2187f-959b-4fff-ef84-08d828c33cb7
X-MS-TrafficTypeDiagnostic: DB3PR0502MB4025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0502MB40252A75485422693727C42DBA7E0@DB3PR0502MB4025.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxfZ+a3TA9UiPozfpKK54IxytlcJXJP4kxm/RdLWGJ5QXYLGdfg+OXsiyJUYCwhmUMR1FxFms9nAgNzUnW6EcD2O6ixoYeLx5H4j/Lmw5vihTlqp7KeDVxfmcCq2HTaW6X9tqyEvvC0CmJRwQ3ihM8NRLbU8np+Hy8xWGfmB+CunKIzk6LRAAgiGdjXDqV8/D7P3bzTD4cxN9bvKTmffbBqzbQBP+LO0sWKULxBWmp3SDV+WOaeBeD3XD9o2hofO7SewVY+Qvm6Y4b1k5ZsRPfF4mcaoMr2rmb8pF9okz06/5CG9n0tM4wLvbL4255O8V7PPp8oZxhiqg2lwou/eNFW9dlZC3SYiGn7QzcYnSrasypYibdZqDzAuoRVZxI9t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(16526019)(4326008)(53546011)(31686004)(6666004)(52116002)(2616005)(6506007)(86362001)(31696002)(5660300002)(6512007)(66476007)(66946007)(66556008)(8676002)(6486002)(107886003)(2906002)(186003)(6916009)(316002)(8936002)(478600001)(36756003)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZHMp9mRpCFdh6hOZBTG7egWpJLPZNel1AugqZxX75wirX2Q0gbmLrueJ34kUjAA2/8PgpEDzF9WgrwlXMApUR0nvNR7zaRk9kJV8uMUhIAq60AtYgNyzmLDsgXVeO3hAidENfS6GovujqYkEP2nWFJ+rO4/gz+k1JFFnPFaVefnEG0XCoIN2v/s17y8RYgONiqKnpG/Tg68LqP8YS/URwXpiowDhN10Unn0j10OK3CM3p5orx6UeeYOQvod9XvNM3r0eakN3svsmJiHjne6/DtSbmnphfRLeyaV4iFpg+L+gVauA8fV8YrOxhCsLFGDBEY+cgSIZlupMR3mN4keC6/7GSkPwbfV0TTV6tdfYTTI1vP1NjLvewdlHmBikNjM04iCUMLJ/KPeL23MgRCuidVtHURCylQoIKZPNncVONZiXtxEQ15aPmimFIe3vZtwJWT4rZTOYcGEvS9qyglb+jhasoaXHmZXuYmk+V2Bt9S2PhoGro+WaORQ0ODZ+muetsX19r6ViL6ePR+WZkJILnpxJXMSezHWt5SaToaIVgnVKqWo13DWE2zQy2w0AMrjK
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb2187f-959b-4fff-ef84-08d828c33cb7
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0501MB2648.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 13:30:27.7015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFE2GOHbrGJzFLVzkfbGQCGImj5xFEArS+JGh16bQePCjtWd+ijhE5VcUS2J1LZGl3Ed83uBjvVOu+avxqOSvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0502MB4025
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 2:12 AM, Cong Wang wrote:
> On Mon, Jul 13, 2020 at 8:17 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>> On 7/13/20 6:04 PM, Cong Wang wrote:
>>> On Sat, Jul 11, 2020 at 2:28 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>>>> Allow user to set a packet's hash value using a bpf program.
>>>>
>>>> The user provided BPF program is required to compute and return
>>>> a hash value for the packet which is then stored in skb->hash.
>>> Can be done by act_bpf, right?
>> Right. We already agreed on that.
>>
>> Nevertheless, as I mentioned, act_bpf is not offloadable.
>>
>> Device driver has no clue what the program does.
> What about offloading act_skbedit? You care about offloading
> the skb->hash computation, not about bpf.
>
> Thanks.


That's true but act_skedit provides (according to the current design) hash

computation using a kernel implemented algorithm.

HW not necessarily can offload this kernel based jhash function and 
therefore

we introduce the bpf option. With bpf the user can provide an implemenation

of a hash function that the HW can actually offload and that way user

maintains consistency between SW hash calculation and HW.

For example, in cases where offload is added dynamically as traffic 
flows, like

in the OVS case, first packets will go to SW and hash will be calculated 
on them

using bpf that emulates the HW hash so that this packet will get the 
same hash

result that it will later get in HW when the flow is offloaded.


If there's a strong objection to adding a new action,

IMO, we can include the bpf option in act_skbedit - action skbedit hash 
bpf <bpf.o>

What do u think?

Thanks,

Ariel


