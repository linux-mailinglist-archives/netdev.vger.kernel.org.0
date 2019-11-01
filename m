Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314FBEC552
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfKAPIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:08:16 -0400
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:11454
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727984AbfKAPIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 11:08:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEZ2PrsVcFVK7PpRs8TXU4XIDrMe19Qu4DHo+8LO15PEerWuWxdOvaamLhaCEZGeo0yj9cKq9Ji6I3HXcSv5vSjYjpfYOTowY/1GoOhlaWtJXSUMjOLauES02r/boyV4RAP+ADb4hh6u8dsv1PmKcLt8+WKdEhpN7T603xG2+ZJeyoe+AJXWO+zw+W93yzzc4uGljcKdxT45qjHzzpkUvuiv0vQSkPI4mz/9XVE2NCy6tXha3OzndambzJlkQKWxkm3OuhQ+vNAlZ52f02db10FAApUZQYLZbE74jVQO9XODgAvMPwIANxIjHwhS7XsrY3CT12r+xWpCvBJmzylELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0EB7bUL+yd4DDZFUly2rgtD8Z3lrwDsfrGhsI3zfG0=;
 b=IKd3tdVqaVcdwUxwLyVA77vSYtR9r+XTSMoI9w9BFXu/eKrIITJNVBw7uwk94xaUiQ7mSlDow5qxtgGlvwoYfce5mmnqFLFY6qnZY0RVX8L/zvK2sFAvnD/Abk9mKr8LlSi3NhA1+GXI1O3Y2c5Puxw9JkNqiOH8YOUzV8RjSuQwCtCcNBalwGywfeiKKK7ikMhUKNjqfrCPmVNAtjGIqBVUtxToRtLTyGo2AqvHLY8WU+oGDKEWREBz8wK9zR2wn/C4xbrYldJuA+yT4kPUQGJDMSwUWzINWaX59I6vJCaeGEPEfNU7OE/H3W2sAcSpy/6dhi+w0eFRBGANaAWBLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0EB7bUL+yd4DDZFUly2rgtD8Z3lrwDsfrGhsI3zfG0=;
 b=PTFoW3oNC/ov/AGkrooJ+N9bqkZ5bEAyn9NoMWFP6gSPIV2MIvOxy75K/7XEwC977zoDbOUo/qrK3HhYgyR1o6EdRMcWnA7ZkI+PGWmtwU4B8QXB4SgwYhjqw3xGX2JftgAwr0dbAvzZuGuhfaLhuWWp7da5EvOyIQ+cp8uP5ZE=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB3135.eurprd05.prod.outlook.com (10.170.236.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.18; Fri, 1 Nov 2019 15:08:12 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3580:5d45:7d19:99f5]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3580:5d45:7d19:99f5%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 15:08:12 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next v2 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
Thread-Topic: [RFC net-next v2 1/1] net: sched: prevent duplicate flower rules
 from tcf_proto destroy race
Thread-Index: AQHVkLMx5/o4Jg/wfUOIpPLf83boNqd2R26AgAAfyYCAAAO5AA==
Date:   Fri, 1 Nov 2019 15:08:12 +0000
Message-ID: <vbfd0eby6qv.fsf@mellanox.com>
References: <1572548904-3975-1-git-send-email-john.hurley@netronome.com>
 <vbfeeyrycmo.fsf@mellanox.com>
 <CAK+XE==iPdOq65FK1_MvTr7x6=dRQDYe7kASLDEkux+D5zUh+g@mail.gmail.com>
In-Reply-To: <CAK+XE==iPdOq65FK1_MvTr7x6=dRQDYe7kASLDEkux+D5zUh+g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0322.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::22) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48f2e5f3-5ace-4a5b-53a7-08d75edd4fec
x-ms-traffictypediagnostic: VI1PR05MB3135:|VI1PR05MB3135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB31357531D143864B6E073002AD620@VI1PR05MB3135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(51914003)(189003)(199004)(76176011)(6246003)(478600001)(446003)(2616005)(52116002)(25786009)(3846002)(6512007)(4326008)(8936002)(6116002)(86362001)(316002)(102836004)(66946007)(71190400001)(71200400001)(66446008)(11346002)(6506007)(2906002)(64756008)(66556008)(66476007)(6486002)(6916009)(229853002)(53546011)(81156014)(54906003)(66066001)(5024004)(36756003)(26005)(8676002)(5660300002)(186003)(81166006)(386003)(256004)(6436002)(305945005)(14444005)(99286004)(486006)(7736002)(14454004)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3135;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +26R2ic/uAEn5iI5gpaQeUiJ3+YMtqyXZAJQ1KtrddzWvw5XKi6BDthTb5c04e2bl4zr/mv4831newK+LMtglthwVDtwLCQVjg43BY3g+NkMIDgqwLe7rvKcDeff6U/rvtRO198BV8mcSWs/icPHGYhV24QOsQzIg1s5XV1Z9lp6961mWc37Xv5vxj4NEP6k3Vlmf0txFmDoK59objVkxELTbzBnz1MtMdOFqKtwRvYba6Hq6/24x698pIaomH+Jr8LDSGb+OUjd+o7VqhPKr4PYwR5DuPbLe+XStHc1PVqHpX/4M1Ilqfrgoe1A6gtmTJHLwtzRddq0yOiAGMjPwVn1gA9DwaCJodRvcwVPY0z5A7hYA2PhMmCvDoNcfy97eosK8FAU9LpeoirSOev892d5a16zH9fv5bKQ/hzsDaYgRCHpUJkWyNUrgp/qVJ8T
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f2e5f3-5ace-4a5b-53a7-08d75edd4fec
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 15:08:12.0974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGwlo42jcAvi2Q6QMsP8RdtpVT2l1uUYe9Yk6QNiu0rL2qMXAEGWhU2B6XynAQ7ejHtann5gWZYVfgF1ZVqtrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 01 Nov 2019 at 16:54, John Hurley <john.hurley@netronome.com> wrote:
> On Fri, Nov 1, 2019 at 1:01 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>>
>> On Thu 31 Oct 2019 at 21:08, John Hurley <john.hurley@netronome.com> wro=
te:
>> > When a new filter is added to cls_api, the function
>> > tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
>> > determine if the tcf_proto is duplicated in the chain's hashtable. It =
then
>> > creates a new entry or continues with an existing one. In cls_flower, =
this
>> > allows the function fl_ht_insert_unque to determine if a filter is a
>> > duplicate and reject appropriately, meaning that the duplicate will no=
t be
>> > passed to drivers via the offload hooks. However, when a tcf_proto is
>> > destroyed it is removed from its chain before a hardware remove hook i=
s
>> > hit. This can lead to a race whereby the driver has not received the
>> > remove message but duplicate flows can be accepted. This, in turn, can
>> > lead to the offload driver receiving incorrect duplicate flows and out=
 of
>> > order add/delete messages.
>> >
>> > Prevent duplicates by utilising an approach suggested by Vlad Buslov. =
A
>> > hash table per block stores each unique chain/protocol/prio being
>> > destroyed. This entry is only removed when the full destroy (and hardw=
are
>> > offload) has completed. If a new flow is being added with the same
>> > identiers as a tc_proto being detroyed, then the add request is replay=
ed
>> > until the destroy is complete.
>> >
>> > v1->v2:
>> > - put tcf_proto into block->proto_destroy_ht rather than creating new =
key
>> >   (Vlad Buslov)
>> > - add error log for cases when hash entry fails. Previously it failed
>> >   silently with no indication. (Vlad Buslov)
>> >
>> > Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concur=
rent execution")
>> > Signed-off-by: John Hurley <john.hurley@netronome.com>
>> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
>> > Reported-by: Louis Peens <louis.peens@netronome.com>
>> > ---
>>
>> Hi John,
>>
>> Patch looks good! However, I think we can simplify it even more and
>> remove duplication of data in tcf_proto (hashtable key contains copy of
>> data that is already available in the struct itself) and remove all
>> dynamic memory allocations. I have refactored your patch accordingly
>> (attached). WDYT?
>>
>
> Hi Vlad,
> Thanks for the review/modifications.
> The changes look good to me but I can fire it through our test setup to b=
e sure.
>
> The only thing I'm a bit concerned about here is the size of the
> static allocation.
> We are now defining quite a large hash table per block (65536 buckets).
> It's hard to know exactly how many elements will be in this at the one ti=
me.
> With flushes of large chains it may well become quite full, but I'd
> expect that it will be empty a majority of the time.
> Resizable hash seems a bit more appropriate here.
> Do you have any opinions on this?
>
> John

Yeah, I agree that 65536 buckets is quite an overkill for this. I think
cls API assumes that there is not too many tp instances because they are
attached to chain through regular linked list and each lookup is a
linear search. With this I assume that proto_destroy_ht size can be
safely reduced to 256 buckets, if not less. Resizable table is an
option, but that also sounds like an overkill to me since linear search
over list of chains attached to block or over list of tp's attached to
chain will be the main bottleneck, if user creates hundreds of thousands
of proto instances.

>
>> [...]
>>
