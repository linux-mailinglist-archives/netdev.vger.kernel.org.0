Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AC222793
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgGPPkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:40:13 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:54546
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729087AbgGPPkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:40:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSXE+irEBpGDX1yz6/L9zbZ6ueW494fdbAHZ1AjRIezUjgVo6ViP2ZTavr2wVjAVQhk+ZJIcb/TRqVD8ZjJxKRG1Bo6YqXeoDz2UFjFyySrmc/pzoW3dAUZHOysrnWxUPlcrr6N55PurUJ4elflsobrtVx+Z7Q3gEzvjjS/c8Kuq6oLqP2B3GO/AwcOEBinwAH0IZrSbT0R+q3Gtq+TTD/z3VM3ZMlRR5RlhP37NRpvSzYMgOf5e1whl4IEg9/FNdyhWkoldqj07BvaBHq04uyk8fbkF6/O8l2pxnoOzovXs2NhAO0DbWj9HdpSBcOQv3y9QCADvY102XD+ZHVlLdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR3v0C9du1IY7zusmLcsJO1ONBG0L0kL7WjqhNIvyBc=;
 b=Hzao59Po7QREZYD5ZTkwG968VWS55SCN+Z5uInsFo+muCE4c7mSauNQy6MdZzNL477cR12GYWsa5sEhNfj7jnrzWrDB0k0tUlkF1gM+YIiG334kn9KaTg03LJaU1/Hw+ssuhMqlmvV3F1bPd+6UtpQMPLz4oOxZETV2ur1YBVTIhsddeKUrPa9AYNKPL901jTmWLuaX8AuYLBntGhT8JjacuQhbyr4pXx8hL+fthKTO/N6W9WAP46pPAugdObxevrn/9eurqBHypLKqtOJ1dWPTfTQJ9QyCPxIRR19vg4t004YCJZ/F0ex3em0LUn3ne5F0Hkep2z3FZafsC9GlHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR3v0C9du1IY7zusmLcsJO1ONBG0L0kL7WjqhNIvyBc=;
 b=fEVfu+0uhX/UlQu9x8ggpFYwhM2SsD5IUGIpJNj6HCBBjuq0de+CyjOJr/OWbBufOXkjyFcywVU+RQFaH6+dDrNQBZumO/vi+uyTM5vrArCGermMKgaS/NrB178ex4cScD/XkOSmi3OvenU7ACnL3+FAlPujZVDUeOzoAB0UYco=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DBBPR05MB6523.eurprd05.prod.outlook.com (2603:10a6:10:ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 16 Jul
 2020 15:40:07 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 15:40:06 +0000
Subject: Re: [PATCH net-next v3 2/4] net/sched: Introduce action hash
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
 <20200711212848.20914-3-lariel@mellanox.com>
 <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com>
 <b4099188-cd5d-cbca-001b-3b0e4b2bb98a@mellanox.com>
 <CAM_iQpWfwOLKufZ4sJk9BP-BMcynmt327WRdNRC5vrGQ=7sT1g@mail.gmail.com>
 <2cfac051-e2fc-e751-72e3-237aa20e7278@mellanox.com>
 <c0d53867-4efa-fb45-b77e-af5dbc019bfc@iogearbox.net>
From:   Ariel Levkovich <lariel@mellanox.com>
Message-ID: <99dfaa15-c35d-19b9-302c-0946ae32a792@mellanox.com>
Date:   Thu, 16 Jul 2020 11:40:02 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <c0d53867-4efa-fb45-b77e-af5dbc019bfc@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR03CA0003.eurprd03.prod.outlook.com
 (2603:10a6:208:14::16) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Ariels-iMac.local (2604:2000:1342:c20:6880:a269:962c:38b4) by AM0PR03CA0003.eurprd03.prod.outlook.com (2603:10a6:208:14::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 15:40:05 +0000
X-Originating-IP: [2604:2000:1342:c20:6880:a269:962c:38b4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7192f33e-aa63-4040-cc6c-08d8299e83be
X-MS-TrafficTypeDiagnostic: DBBPR05MB6523:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR05MB652330D9129302B9D41F434FBA7F0@DBBPR05MB6523.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSKobvjJnH1TdOppbT2OG/nR/WWUbq0/d4T6X+JDWqFfPx6tFQaiLDMWsQc21TwFqb7MM+6uqrewy4cL+xQCbf3Itfn8QusEHMwszLy1K4eaJieqBR1ZMpXmrCZsCpD6EzK2++fsvTt/0cdioeci1GM3294El7UuZU47FrER6EjmO/be+BkzA7G3KscIZVwPEFoqhyAOVW/OqIxwS+KWb+OBFF/8oYIAnL1OJEvR2KOjm10QctpTHj70JsV8+0QIKQkvQg8PM8sBkUIGaMO+T+bUoDNXpe3m0hCgwkKwtSneOdDbGRdSEOoRTR+IgPaWd7uvCnQgab7EtyK6uuUSN7ti2vVQFq8+24v3mNyWRLT9PM5LAK2n+nAm7eUdhX4k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(8936002)(2616005)(110136005)(66946007)(66556008)(54906003)(66476007)(16526019)(186003)(6486002)(6666004)(31696002)(478600001)(52116002)(6506007)(36756003)(8676002)(53546011)(86362001)(31686004)(5660300002)(6512007)(107886003)(2906002)(316002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Kl3PbSbwF9jIS1EJdln0DWwBm91GIa/PJ4v5MVkzdTuy26Nqs48aO+eaZXY4uRXyDXPVhNEgPusz1Fwvz4SuRCiYdhBjbQH0jSotZJ6R1huDbZu13D9jexAawBGC0ahVu8ye1nGi9Ia1/rDeOGVfqGnKnKKU1t6W2oO8NQsLQlsCMIBVYdzlVTW44SvvrYPAGD+GXO20xB78knvjb+Enjj38+hxact/CScqML/M9SZk5z2W5G/CP4qJTr98oPDFlD4V3qj9FmQJVzMgPXJYa30S5QrhwZp1ykIhhcOA2mBsnEN4iQQQGdTLzy+nSP+oKPKZ87LGgkHCE+0mE6hp6EtdcPK+8bcwnycA+6JS6gzOB1AGUH/ak0QXwG9uTGYahgQ3eFyj1PU8C+jgrdUEGFoG7CCxUebrDXeE0ZPezbKmUjOgqbqFsm9lZz8dI3jdPjej/mxqftVt0K1oXjQmUEOxJG8sybj5SMKMy6Kp2bXGdJkdrJpEiTJfdPg1FqVoHx4Lz18wLxe+pJTOKfsvm2GEplBklio1g62LZGXqj5TvrVF1iZOx/M+T/llmb7lbT
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7192f33e-aa63-4040-cc6c-08d8299e83be
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0501MB2648.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 15:40:06.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YY4uMH1n0+xUvftDu4Qz0FNDLgj2AnU+nx5zlqqk6zl906aFeuVJq1sXKu6/JmJdzNhjzTvhxMU6lKhxKkyxRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6523
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 2:49 PM, Daniel Borkmann wrote:
> On 7/15/20 3:30 PM, Ariel Levkovich wrote:
>> On 7/15/20 2:12 AM, Cong Wang wrote:
>>> On Mon, Jul 13, 2020 at 8:17 PM Ariel Levkovich 
>>> <lariel@mellanox.com> wrote:
>>>> On 7/13/20 6:04 PM, Cong Wang wrote:
>>>>> On Sat, Jul 11, 2020 at 2:28 PM Ariel Levkovich 
>>>>> <lariel@mellanox.com> wrote:
>>>>>> Allow user to set a packet's hash value using a bpf program.
>>>>>>
>>>>>> The user provided BPF program is required to compute and return
>>>>>> a hash value for the packet which is then stored in skb->hash.
>>>>> Can be done by act_bpf, right?
>>>> Right. We already agreed on that.
>>>>
>>>> Nevertheless, as I mentioned, act_bpf is not offloadable.
>>>>
>>>> Device driver has no clue what the program does.
>>> What about offloading act_skbedit? You care about offloading
>>> the skb->hash computation, not about bpf.
>>>
>>> Thanks.
>>
>> That's true but act_skedit provides (according to the current design) 
>> hash
>>
>> computation using a kernel implemented algorithm.
>>
>> HW not necessarily can offload this kernel based jhash function and 
>> therefore
>>
>> we introduce the bpf option. With bpf the user can provide an 
>> implemenation
>>
>> of a hash function that the HW can actually offload and that way user
>>
>> maintains consistency between SW hash calculation and HW.
>>
>> For example, in cases where offload is added dynamically as traffic 
>> flows, like
>>
>> in the OVS case, first packets will go to SW and hash will be 
>> calculated on them
>>
>> using bpf that emulates the HW hash so that this packet will get the 
>> same hash
>>
>> result that it will later get in HW when the flow is offloaded.
>>
>>
>> If there's a strong objection to adding a new action,
>>
>> IMO, we can include the bpf option in act_skbedit - action skbedit 
>> hash bpf <bpf.o>
>>
>> What do u think?
>
> Please don't. From a BPF pov this is all very misleading since it 
> might wrongly suggest
> to the user that existing means aka {cls,act}_bpf in tc are not 
> capable of already doing
> this. They are capable for several years already though. Also, it is 
> very confusing that
> act_hash or 'skbedit hash bpf' can do everything that {cls,act}_bpf 
> can do already, so
> much beyond setting a hash value (e.g. you could set tunnel keys etc 
> from there). Given
> act_hash is only about offloading but nothing else, did you consider 
> for the BPF alternative
> to just use plain old classic BPF given you only need to parse the pkt 
> and calc the hash
> val but nothing more?

You can do almost everything with act_bpf and yet there are explicit 
actions to set a tunnel

key and add/remove MPLS header (and more...).

What do u mean by classic BPF? How will that help with the offload?

It will still go via act_bpf without any indication on what type of 
program is this, won't it?

Thanks,

Ariel


