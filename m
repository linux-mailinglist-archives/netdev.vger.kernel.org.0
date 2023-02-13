Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16589693B7B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 01:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBMAzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 19:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMAzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 19:55:17 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2128.outbound.protection.outlook.com [40.107.20.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD38974C
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 16:55:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtjCbFBbIK7BL/JcohxIbPiR5JODQevoplfGisWn4wsGWjps5618advz7lI8xVmA5Cg+LxY4v3tCrjZS+17FJVUxVLKtwOuN8bKRR8kTWKu7MJrvRlUjrLO5/q1w06KsopT1PhgriuyNPdIIWXkSMv21pg5L3OI2BuTQm1X7pf9HhXVLfLwC+kW7r4GzeLyWKPZYSB2A2SLGhDeSC1CKTZmalUIw9FlAzCjU4ccGNmeavuSAG69DlXvk1Xi3OKIGR2PL/zgU1zxMm2iNyLSciDMqSwiCZp3xNM4FFlnzUrFfZDRo4jlv1KcrygBIKkla5UWPjXoyiRw78Hcy0KOyAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1F7L4sy2RD0kA3UwkM+II9ErjiOoszJfUlailaixCps=;
 b=nq7yTcAQE5eAvDsLihk0iaBqvPn6stmt+Wym4dIVY8bAVe+qErZ+1oJh3TQA+U/LnViodcsULqFw2l5Turtwx1iNSdmWlavCVYg6wg/kSFTVK614A5h0IT1lYQgv4uOK6R8/ihFj0Fwh4GR6rBqn6sCM0SxnhEY25FAP54X805BTHEBtLJQC9pJUu/WKEepp5QSzZSGmHJUuB4i+sgDRoDZzMczFqo08CGtRlGfBnrGQ5yLxLEm9SW4pj5A4fQ8z4rH/fvTn8zgUE+i00uY6qN6b65dIWen/ebefV9JDXsmVkCURN5MR5FMwvCS5g4hXkwOm0GRNrf5tKIGkJmRMQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1F7L4sy2RD0kA3UwkM+II9ErjiOoszJfUlailaixCps=;
 b=cvvPrA56ncJuwFIBLJo3ue7Pwh8fgFOTHIGEEQP8RR7e0jlTHQA6QYh9wFmQunqkpHACH9ryF5l8pmfjiQjsCi3yiC22VWtsccBwjgwWYSX3JQaMi2O+8A0hUEojxX8hgBy1gtTRb02hsVgJRcBkMIbCnDZE4kN5Nb4PDkTS1s4=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AS8PR05MB8582.eurprd05.prod.outlook.com (2603:10a6:20b:3cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 00:55:11 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 00:55:10 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com" 
        <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
Subject: RE: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN
 message
Thread-Topic: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN
 message
Thread-Index: AQHZO4wkQ0Q1caB6ZUahNZVZ+KhuCq7GbkcAgAAGXWCAAqKfAIAC/RRw
Date:   Mon, 13 Feb 2023 00:55:10 +0000
Message-ID: <DB9PR05MB907889C6756A547F4F1916F788DD9@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230208070759.462019-1-tung.q.nguyen@dektech.com.au>
        <b36e496792de3d1811ea38f19588e5a5b32a9d2c.camel@redhat.com>
        <DB9PR05MB907893AE1AECD3CA1F91D40F88D99@DB9PR05MB9078.eurprd05.prod.outlook.com>
 <20230210191606.29b8db03@kernel.org>
In-Reply-To: <20230210191606.29b8db03@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|AS8PR05MB8582:EE_
x-ms-office365-filtering-correlation-id: bef0df87-bef0-4e71-be18-08db0d5cf4f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MV8IH8tmqyiTcpdXiyydQSCVkspc8nJYSnjqkdAVzrDp0UFPtoPxOS8LWT5gQRwKeQYTU6h8AZUfah6E6Zl2yii70ukTEELWtchBmuYbwsf6+o+NQXF5u8ep+XYtWVMvPuf7FZzvCYkpBPkYDZBf1yEg9ETrfsAWsa4sQzT9Db0v+Ygo1bF769vOubdK8fvGfP88UwaXZc42xIRQxO1GaCEQiNll3KQIKKtvY7/q+PGkUN8JkKPrfd9qlt19iefZLJotIfCuLzLhVhDPRd03IC40zIIZhgXKCre4dn6FbNb9J4tf79cG6aBCNHbkq1mcK0ICoE26EMKuGHMow1IFcPOAWD3YXOYERomnkL8fCu8F5e9Oz+Vm3hHO/hElQJNIYb0kYXILJ0LJpsHG3/yFMNDceurCYVwxVbI4Vqoi8IYPyuhWSPp8Z+kLz8OP60inn6asogjzRVlcyaMivaIDeu+K43iujgkkEj0yh7TITp6cqSKRNX4saixyMKkAY3ihwiI8vRgIftNqGe0RYpabP4BjA5pI5LEoe0SIgDjFE17iGl1iqFkQdeYSeJ5Vark/pzC6kGXAI3xUP7DX96eFCIMAaLcrW7nje3swrVww7B9+NSoM+1CV+esRAmFHlbeTdTFYutz5/1On62483kKxUSRd8pA0ofCJEJHuxUrNrSFRrE0fVlKAhQ2/2iL/PaHwfDArN58xjH53Nf06jlQ2Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(346002)(376002)(39830400003)(451199018)(66946007)(4326008)(8676002)(76116006)(71200400001)(122000001)(54906003)(316002)(86362001)(33656002)(26005)(186003)(9686003)(6506007)(38070700005)(55016003)(38100700002)(83380400001)(41300700001)(66476007)(6916009)(478600001)(7696005)(2906002)(15650500001)(66556008)(64756008)(5660300002)(52536014)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+qDrnxod0sSSQHUhdgcutXXnrz7wjLm4neP1R+5BBzl/zDpFwPGH5rRlMeGh?=
 =?us-ascii?Q?S0ug66LR8D8n7IFidX/+iI/Du4Y5F+YbUW3/BiYuESajRuwT639z8DnvUhhu?=
 =?us-ascii?Q?41Dp1r12OKqJbMEnvS3kX/EB9B70SVAPWAj5PhPT42r1/ycTRDhmi2tdIUKx?=
 =?us-ascii?Q?IgM11djkI77RvUH3BsRLclFurv5N87WU8tw5kCE7vfTbEL8es+/YWNn/w11K?=
 =?us-ascii?Q?/C4Xf4ufARQ90Uvd/RN3MSNXvoP1Q6bvrX6Sjq87+1fmintIUqlF4RGqoA4T?=
 =?us-ascii?Q?KYh/2IDQqfMS/VeTcNNG2Q6zxbMqHvCNe/hmZbxcTt4BC8sU7xq9IVrZy8VO?=
 =?us-ascii?Q?MtxzHA6zRW2AucoYb7GxZyaShgeun6FTFYx1J6CQtXgRCyGhflCUhd6w0w6j?=
 =?us-ascii?Q?95cHzdyBLlcb1d4DNZL6rrO/5SINcC82Rasfk6Wzx+CtAkcZfyP0J9Z+Wsn6?=
 =?us-ascii?Q?IquTx+pK26Prw7cHwm/QQvjFTFrM5ap+YzvAfLthVuJtvTgJr0+9/bTtXHZ4?=
 =?us-ascii?Q?rcdeHQMExL4A25pOO0xa00nixdm2KYgLVElSY7c6hSp+ZgiCOkAaZinx5Spb?=
 =?us-ascii?Q?CnwGZGAINVXfnIQvpiSRtqkSztkdW6uNITEP1FOmM7zLueqLQEvAeMEqd1y4?=
 =?us-ascii?Q?/E54rksemnNXQpHjUaurBEdHpHSjF+pZODFdN0xW3d1b2Kr4xQZyuH5N8r5t?=
 =?us-ascii?Q?wHos8xgm4dEFO6CLTF1d19lIkCQzPzOjg/KOQ2bHHDYf2+abpZAJ5KbL5DmF?=
 =?us-ascii?Q?p3eMCg6yEcqLS7h6AdomDeQHcmzFDxI8OuI6d+I8ECqtoqUEhnUAydHZvOpo?=
 =?us-ascii?Q?tWngNxkCHvUGd7lMpI1KB1miBDbJZsgQcgpW71+vIiLqX1Q4uwj+AoEa8Kov?=
 =?us-ascii?Q?i5wmaIR+z18gRaUKwVV7Emm1ovu5mt1rKB6OBso5EA/47WiS/7iqEtxkXbk0?=
 =?us-ascii?Q?BmsJ9Ac+BUot09bU8oz1T/bulLIag9azosOADSlcCIP3pimGIlgI3a4t3ZTF?=
 =?us-ascii?Q?5wAb0BPixzzwIxQI6BMXkTKOo/tggKCsCM15CzMVCUSZGtk3Xb3zaaUACwn9?=
 =?us-ascii?Q?A1L716bg4ojLW56VzZgF9Ngbj30ielU3/vNfPuLrhoenLwhXrOW5WVCb+sOZ?=
 =?us-ascii?Q?dN6X14zqOaWirncbZuVnTSAr6JiFe2YNICjD9w5bpUjhppHZ0Ke3kHe15D4T?=
 =?us-ascii?Q?qxlIgAC51KOroXoGiHqdrm5Jh4AY0GjcKdxAUm7XPgFd9X+wSchpaTYuHeIr?=
 =?us-ascii?Q?r5O66tnikun9NEl0wRqmu4yJlDv4FeZ1kB7dy+jDP3auxI3XdpqJRtYvande?=
 =?us-ascii?Q?2tGP1WsznCbEfTldl2GeAG2GkrFjL5Xmfj+4mPtQdvZ7MIRCkF7xG0zyKN7y?=
 =?us-ascii?Q?jPu2LKWdks6IsZAAOC69NmmxoGCJQ8Ss0pgxXBmu4lIeqmNt0RuR86P53nCw?=
 =?us-ascii?Q?ldSqezFhFZ8IfXJJBAhrAfEdIzjWgc8UUXB8bXySbaYMiXNHncP91FBzcNaQ?=
 =?us-ascii?Q?YfT1sa0sI34FYggtDIydGqMroCmu2kAsDt5okSN63+1Fe8C/LUNmHN5OaH5b?=
 =?us-ascii?Q?tp/38PrBexueJ6wA9iFiubG73ao2EtAzawukR8zMXvWTdRQSDMHodndJJ1KR?=
 =?us-ascii?Q?kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef0df87-bef0-4e71-be18-08db0d5cf4f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 00:55:10.0995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+SqyfoymjPMxe0nBICFqLXu7QwBavM2bC20lP/BeEh5jDXifpMMDWDoaIxOBnrpyyyBztNyDYOWn/x0iOUYoZuduadbxC96plU4M9JQIIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB8582
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Saturday, February 11, 2023 10:16 AM
>To: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
>Cc: Paolo Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; davem@davemlo=
ft.net; edumazet@google.com;
>jmaloy@redhat.com; ying.xue@windriver.com; viro@zeniv.linux.org.uk; syzbot=
+d43608d061e8847ec9f3@syzkaller.appspotmail.com
>Subject: Re: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN =
message
>
>On Thu, 9 Feb 2023 11:10:16 +0000 Tung Quang Nguyen wrote:
>> >>  	msg_set_size(mhdr, msz);
>> >>
>> >> +	if (!dsz)
>> >> +		iov_iter_init(&m->msg_iter, ITER_SOURCE, NULL, 0, 0);
>> >
>> >It looks like the root cause of the problem is that not all (indirect)
>> >callers of tipc_msg_build() properly initialize the iter.
>> >
>> >tipc_connect() is one of such caller, but AFAICS even tipc_accept() can
>> >reach tipc_msg_build() without proper iter initialization - via
>> >__tipc_sendstream -> __tipc_sendmsg.
>> >
>> >I think it's better if you address the issue in relevant callers,
>> >avoiding unneeded and confusing code in tipc_msg_build().
>>
>> I am fully aware of callers (without initializing iovec) of this
>> function. My intention was to make as less change as possible.
>
>General kernel guidance is to fix things "right" (i.e. so that the fix
>doesn't have to be refactored later).
>
>> Do you think using  iov_iter_kvec() instead in the callers make sense
>> if I go for what you suggested ?
>
>I think so. These are the potential culprits?
>
>$ git grep 'struct msghdr [^*]*;' -- net/tipc/
>net/tipc/socket.c:      struct msghdr m =3D {NULL,};
>net/tipc/socket.c:      struct msghdr m =3D {NULL,};
>net/tipc/topsrv.c:      struct msghdr msg;
>net/tipc/topsrv.c:      struct msghdr msg =3D {};
Thanks. I will send v3.
