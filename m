Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010BD1E1E77
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbgEZJZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:25:14 -0400
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:44693
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728735AbgEZJZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 05:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOpvLuBxrdn/1vq4fPHfFtkAj/uSwPFfiKSDRrZnPdyFtiHKZRa6Mq1QxEAuHFAOe+/UsBjNtV4e9iGhBs7zokA4i1WIneazjrOrHXROvbylfp9DtLAPWwfB024cpZywOyNZcMLix6Jnnd7BU5P3a5oDZCLugKNA+PJKfofEeO9lPIzG123q9U6/yWfWAR5nw+2STLPjBkywIh1/w5mzjt+ZfMi6zrIzHqmyoawGXilc6Io53kiJ99Y9hIa1qzYF+uRd/1qCJ2sWtL5HxHJbhJvp0fPd3w2o6k3U2E684DWbD7IH9FbYnkBFK74rdN1/owqtaG0QsK7GwRqFTDw2+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y60Q5YXshILacRbjIeNPPRNTOrcHql6y2sKmicX5Rwo=;
 b=XnTvDbgxrtRE42FSBIOFuZHeCd534wZ+ZwxNGKEtSj+Xv6fOEV+HrhtGpf3ucYypi/bRMp2z9KzWzZ055PFPZIBUdNT5XO17hrtlraQMCSIlVSuDn4uP3wucq6Z3J4ByRWXvMPQ4n7mN0HQPz53r8uip+/1z4vef0fDwDvTwY0WnAy7Bp8kzWo7OXPlmcrt52DW79YIGSvWQbl/wXMi+6mEpTA+dkuvfQZPnRCOO1v+534tHE0I9SAQTxZM440jSAWLZv0n8medmOLPGQx5CsW5iio2GhGko9OcDrxB3lpqNgvL5SfZSsF/L7mRljBoNl9cyWZdlXUPQbQWpVHN3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y60Q5YXshILacRbjIeNPPRNTOrcHql6y2sKmicX5Rwo=;
 b=Mkvt6Ys6F8JCyXf5s/l8CV/rBJykWQp4KC/kbWXKHv7iaYEBymyLQwWzjiWoIYznAbL2hRmTKHqUeAPoXKF7WReLoMTdatqCicQlhaOUHa/eoQFCkhqq8VRy1l4udWwK8StKPCjDrOPIAkMR1mCfD98V1JOfK+qrtiwfYh766Uo=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
 by AM6PR05MB5622.eurprd05.prod.outlook.com (2603:10a6:20b:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Tue, 26 May
 2020 09:25:09 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::38f6:4f62:cf21:18c2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::38f6:4f62:cf21:18c2%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:25:09 +0000
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
 <20200514144938.GD2676@nanopsycho>
 <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
 <f7236849-420d-558f-8e66-2501e221ca1b@mellanox.com>
 <64db5b99-2c67-750c-e5bd-79c7e426aaa2@solarflare.com>
 <20200518172542.GE2193@nanopsycho>
 <d5be2555-faf3-7ca0-0c23-f2bf92873621@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <73cf369e-80bc-b7d2-b3f5-106633c3c617@mellanox.com>
Date:   Tue, 26 May 2020 12:25:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <d5be2555-faf3-7ca0-0c23-f2bf92873621@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR04CA0035.eurprd04.prod.outlook.com
 (2603:10a6:208:122::48) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.62] (5.29.240.93) by AM0PR04CA0035.eurprd04.prod.outlook.com (2603:10a6:208:122::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Tue, 26 May 2020 09:25:08 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80af1836-a395-436b-5d02-08d80156af73
X-MS-TrafficTypeDiagnostic: AM6PR05MB5622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB56223AC6CB91995DE954F3FACFB00@AM6PR05MB5622.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAMQEFeT3PzaS1V6cHMMWwFpXbw7O8csTBbpzdlScPvUOFlpKPy+naJCY4p3wRgIxhgMR4t8c10jiGiomyCYN0XwD1DYGHfpfe+V5DRIhsxnJg0Vga2ATXYpoH6835O8Atg2BEFOVLIsQkoeOWa5Wk/1EG1dmFti2n/PG2aCDYD83evMvN7T6o1ZA6l9DvqXWdMBuZCQGijhp+voMIkae3seFiv5bMOIAJ6WGJsyzPn9u91XVca/DuY1ro1FVqYd/wYy6CJo/4sG+j5RI+7yXl0RBRthUeHdSXK3mf9jL5/aH2BlYtyFnf5sp1IVPNm7OwGv/dK/n2w1T08yxar2JjnXhtbD1/4m5yMRIVALmSpIA2e79lzerndDRKWZLoD0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5096.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(8936002)(66556008)(66946007)(66476007)(5660300002)(110136005)(16576012)(6666004)(316002)(2906002)(6486002)(54906003)(8676002)(4326008)(107886003)(52116002)(31696002)(2616005)(956004)(53546011)(16526019)(186003)(31686004)(36756003)(26005)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: krnafZHOigiKybtuzj9FCz4qhpO79DR4d6+71tK6KNuGh+4ddCofMNlSGy1Pv0eWdU88e8Fv4X4CZ5uFfE6biczMRedsR3+SE34MYaquOzFhTuzG65cgRcNDD+HnhoVgDghR66WrJ5c2QKza5cbEGLpHXinkYBDnmIZ/S+3XL8e8Us/BYtEBuQZRzVzcx3eFPnmdqRUuJT9Pi2km4KhcqJlD3U60W0smRxozyyFUqYPjPBIzZr/L1PHrlVXFxypGJS23lTst5GsNUhoQZrsqr8s9W0i8lDDYGGxbJJm8P9eGAV7sbLi0wnDBdJP1P6flfC33OMxZU9wKv9iUQLKeaOfsToz9CJx3v2XkzvggYfioS/C8a0PFy34/sHDEF+hpvF4g76mNm/cKJbT2lsfRd3WMrlYwXZe1N209RjO3YW/LbNjq1lMin/9F3iVM1TctVw9qFRbAc4G6EdqvIkSyv37y7FGLKpaszi1bb0kGWFA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80af1836-a395-436b-5d02-08d80156af73
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:25:09.7752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r167Vm7vaPYzVv/+G6KDb/3ppHX2K18IToJLQZHkJVD8AzS+/I4/Uo9icLFju+DKOuFDqCbByQniFZ6W4i+57w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5622
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/2020 9:02 PM, Edward Cree wrote:
> On 18/05/2020 18:25, Jiri Pirko wrote:
>> Is it worth to have an object just for this particular purpose? In the
>> past I was trying to push a tc block object that could be added/removed
>> and being used to insert filters w/o being attached to any qdisc. This
>> was frowned upon and refused because the existence of block does not
>> have any meaning w/o being attached.
> A tc action doesn't have any meaning either until it is attached to a
>  filter.  Is the consensus that the 'tc action' API/command set was a
>  mistake, or am I misunderstanding the objection?
>
>> What you suggest with zone sounds quite similar. More to that, it is
>> related only to act_ct. Is it a good idea to have a common object in TC
>> which is actually used as internal part of act_ct only?
> Well, really it's related as much to flower ct_stateas to act_ct: the
>  policy numbers control when a conntrack rule (from the zone) gets
>  offloaded into drivers, thus determining whether a packet (which has
>  been through an act_ct to make it +trk) is ±est.

It doesn't affect when a connection will become established (+est),
just the offloading of such connections.

> It's because it has a scope broader than a single ct action that I'm
>  resistant to hanging it off act_ct in this way.
>
> Also it still somewhat bothers me that this policy isn't scoped to the
>  device; I realise that the current implementation of a single flow
>  table shared by all offloading devices is what forces that, but it
>  just doesn't seem semantically right that the policy on when to
>  offload a connection is global across devices with potentially
>  differing capabilities (e.g. size of their conntrack tables) that
>  might want different policies.
> (And a 'tc ct add dev eth0 zone 1 policy_blah...' would conveniently
>  give a hook point for callback (1) from my offtopic ramble, that the
>  driver could use to register for connections in the zone and start
>  offloading them to hardware, rather than doing it the first time it
>  sees that zone show up in an act_ct it's offloading.  You don't
>  really want to do the same in the non-device-qualified case because
>  that could use up HW table space for connections in a zone you're
>  not offloading any rules for.)
>
> Basically I'm just dreaming of a world where TC does a lot more with
>  explicit objects that it creates and then references, rather than
>  drivers having to implicitly create HW objects for things the first
>  time a rule tries to reference them.
> "Is it worth" all these extra objects?  Really that depends on how
>  much simpler the drivers can become as a result; this is the control
>  path, so programmer time is worth more than machine time, and space
>  in the programmer's head is worth more than machine RAM ;-)
>
> -ed

I see what you mean here, but this is only used to control action ct behavior
and we don't expect this to be used or referenced in other actions/filters.

What you are suggesting will require new userspace and kernel (builtin)
tc netlink API to manage conntrack zones/nf flow tables policies.

I'm not sure how well it will sit with the flow table having a device while
the filter has a tc block which can have multiple devices.

And then we have the single IPS_OFFLOAD_BIT so a flow can't currently be
shared between different flow tables that will be created for different devices.
We will need to do a an atomic lookup/insert to each table.

So this will need a lot of work, and I think might be a overkill till we have more
use cases besides the policy per device case which can still be achieved, if needed,
with different conntrack zones.


 
