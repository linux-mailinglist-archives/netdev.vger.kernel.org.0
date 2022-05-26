Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F703534F08
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiEZMVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiEZMVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:21:40 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2088.outbound.protection.outlook.com [40.107.20.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF481C966E;
        Thu, 26 May 2022 05:21:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRB+c47PWfBoF+QCx2v6dZ+DOhOhd0WLXGPd2kQol8MHyCUhiDb1MGojlrSDGYFheH8LLW12otRYYP7VAfQxcr0voibh84mJ6TAR8GElAHf6ZlKegHmoGU2AFBr2gAqx93DFXzm/bisiS/AFrdRcwFP59V/ZfH3DPe1HrjlbUTsil7MTTGrGuOmdSOgwKJS4HsNYBOCaXEfhKJJg0kk3DhLpz8Y2s0El9qmNjefwb4+g+vjKXM4RWTMSo0bsee0g058xXoQ6ZwC1hPuZ/tnfZlZ0ds5b4XUf24VKKMbWBudsUDndWXgGQUH0EGyXtU4sbT+6nU0TH0loYP7ZTuLcpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/A4Nfm72BX9A8kAl4ewxQYUKj8AvfFgZB+bsRtehIFA=;
 b=bISYsSdK6yqo8Xd8Hy03GkDOm1DbTKP3hDJU4gWaB2H/Zzp0WdZ76V0z+OOMEKxexbApHIqofDEvp6ftse37WAtKICBX6brAnpCoLK1Hu8EqabbXtsu5UkcSZOPghWGK6wJZ3kpX/0hzGQefCP/mXDF8Lm9A4I4Pht6zJutkLIL17Z1HNi3aLNuvvVJgb5UIxgMPEVPTm5QUKCyADS2Alv8Ww5IHKEq1eZR5sbkB9V26Ati5f6aknN5EdH/VSlm9dlxsPphoBLIFgGOngzjSxxbT3l57Sy+T5xm3fdEQkPbNUq+U0KvqoIpV2NO5n+pUlxHHIvHcwqwOzc5/R+uPgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A4Nfm72BX9A8kAl4ewxQYUKj8AvfFgZB+bsRtehIFA=;
 b=ESvWKFNHsS1hAV3L2NS+LUlabRmFv8fd9dFjsYW3XC0yMFihdsqHWFckn/49ZAZ+IAGuvE3H3lLZLJ9ZM8T4X27J7T5l7GNM5cL1mKWrC48SiZv53RQ1xVvyTI2CSe5ORBiPcwCALx+qEdAwpXDjRW7fDfuu1X/rG2/8+dNF6+4=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by VE1PR08MB5597.eurprd08.prod.outlook.com (2603:10a6:800:1b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 12:21:36 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::6496:573a:4140:b034]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::6496:573a:4140:b034%6]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 12:21:36 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernandez <carlos.escuin@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Era Mayflower <mayflowerera@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Thread-Topic: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
Thread-Index: AQHYb2NB5v+kUYU0g0uDR0Vv9E1K5K0w3wKAgAA4aXg=
Date:   Thu, 26 May 2022 12:21:36 +0000
Message-ID: <AM9PR08MB678837DD17B237654A8F84AADBD99@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
 <de4aab60766b3de8705b09e36b8050feb92865ec.camel@redhat.com>
In-Reply-To: <de4aab60766b3de8705b09e36b8050feb92865ec.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 76fa9de3-675a-b3d5-8b4e-20e3e0f66240
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ea1a230-0abe-4e3a-5f71-08da3f12471e
x-ms-traffictypediagnostic: VE1PR08MB5597:EE_
x-microsoft-antispam-prvs: <VE1PR08MB55970C0685E85C74D3A02940DBD99@VE1PR08MB5597.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cFTmjNP7jGllda2dtgtK8QSGe5jknahtW0ASIZJ52CxijoqC2vSO3ZKAja0i2LN8KiqFOzOb6HQROHVYLBh5F30me2EnACu3drAzCo/D8m0ZxS2PMvu4ZclyarZRKWBf9cgxerISCU+KXT1QQPFeSdZ1a9cS8T2py4VJoWQLZcPzXDFdG2LNRn6cch+cPou3zrUGarTnDvVaPyeWdfuWYI33mYs8m/49vd3ICbYxaEuJy0NtqBP1UR++zKtyQoHjWc6v8OcQyScjLpp/cInrELy/9A7HsnM64YUVosA+qClvIdYC5XadMuQ26+r5zGQNcqp0AVSMg80MBNXrNWbZiaiIhe1am+h3dfwXTWkvx5zkXsWBO4CqeJwshHGgQFr/cTTWaEj8nDxEVKZuGG2kTICKConvb+JIo+R4oox849tz+5qDp/EOGzsIriYn8Qz1nWXebOCkglP5UvVhxl1UlYxJcupDb2K+8gnQJdz6bPIO4MFZt2JLRZXFXP44MBXZUJfXW85wV+vTvNjcExd9XojwT2/A8q3E5AFTP0DyFJKd7UoI69ycmGn1m29u6mLpK9saoFu7RfVF3JT4YVEfJiieCcBoMggykHLnUprlwso1yALzK9MBwlq01EtkpfSpxv/qse8WocP4IVMNy9LlrSAUkBDz5Xpi+HP5Dq2HY2isq9JjaspfpTGyPricDgVUvhjby1i7RNWtmpSNqBmq6WBoGRpAdgL3o93V7IvzD5Xy0N+1AC4b9tIiu1QuDaZDhE8NA/Hm9ESZoFdZ6mqiToshyJnLt7bdUlmghDPJeWQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(5660300002)(38100700002)(52536014)(38070700005)(53546011)(8936002)(9686003)(44832011)(6506007)(7696005)(8676002)(122000001)(110136005)(71200400001)(55016003)(316002)(54906003)(186003)(966005)(508600001)(66476007)(64756008)(66556008)(4326008)(76116006)(66446008)(66946007)(91956017)(2906002)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SNm392Y+YBcXEZHDXDaDYQZqKUVYwNx5kkvytxGZqngSPjSLrvGHCJJiXOO2?=
 =?us-ascii?Q?EN2wFCjAlcTq72y2iNza+Fo6Vl9zXb4qZDjl0Jf4trlvInY+PCt3QCSlmfkq?=
 =?us-ascii?Q?ttLmOOGTYCPAzH8zm5m5OLCM+APG3/aL+qwdmSikEkRNNn2+WJpcXUV87YT2?=
 =?us-ascii?Q?p+/p6bwXN5GSgREBt796wrfowzGwPERRn41qwu1bkkbKyb2kwJOuo63Zd81W?=
 =?us-ascii?Q?OUUWeyNSrb8XMOHFSHYu1Upyo0ykkMn2BhcXXOE1HZ2xjjISZywmFc96ChoN?=
 =?us-ascii?Q?BRyG8HH/qlotAh6fpmcca49o1oFwIElvPZYyoqXZPNRxyFlg3bBmRi5r+Xe3?=
 =?us-ascii?Q?F62sZvH8qUVVqiiSGF6H8I4DkbzFOYeQW0iklGJThHsXsUVJJDZMewO1b27s?=
 =?us-ascii?Q?8p5c5HGfEl/ZsKcabRtY1yJdGdwamHC6iDHpbujWYTLGzURQe8xrSyx523pF?=
 =?us-ascii?Q?Cy+C7U47QcUiNw0asemPdyP8A7gpjUavvXpGaNNWpLGqnnCam3iAPcgJp+58?=
 =?us-ascii?Q?vM5wZ12hiMu20gUf5hX9YzyDoJ6kNpCWMpKfVx42NCkYNqCttr89q22sAgSB?=
 =?us-ascii?Q?tBlhs//xtxnTZt1Olzdi/eBsJc5pMSMGiqwP+SNgKlZID1qW+A8weGP57Op8?=
 =?us-ascii?Q?yK0fnd+zI10hTVpIcz9dRrKSZYHgvgPDbDpIRUYLkvDCOkAAl4Yi+8Asn0EM?=
 =?us-ascii?Q?OpgtUrhKBwjzKkCGKhNlDLPb3EkfB7N1dO+o4tg1H9T1kb3WVa++w4OEWSaS?=
 =?us-ascii?Q?Sp0xKdi8QkYrKjgiSj46v3rUY6LMTQ8o4SmJxbQuOZN9WNdEIPOWG7iX/Dv/?=
 =?us-ascii?Q?UicPmvFVt+rAGLEN/V3S5ojuba0R+5CXOhRNQRUZP1iIfNh+IgY4sSCdTC91?=
 =?us-ascii?Q?PgYvIw+JPX74pEzICXOWut6Pc9eTv98estyWN8qP4WUI8TeixDIk9PkyVYRO?=
 =?us-ascii?Q?NjZDXZgkJWgSDVEdk03vxOwXA3IS0YngLD8MF75ZmCrGFLW2Ius2pQOVJ5s3?=
 =?us-ascii?Q?KhBhkxnY3YSwxGnw0qJi9FX3l65ynQwFtOboZG66PXWGeMMvRz9iMsWKNeIU?=
 =?us-ascii?Q?pMSAQwk5pUu5ePRLyZwyQG/bQgcMqI4A5DfV+LiDoXHjR/BgSJ0e9UDjqJ/W?=
 =?us-ascii?Q?FEcGRT0WUnEQTxFd6qTQv4s+qH/GhG9xJlicKubnGaPzrpLC0TcKQlCq9Lr1?=
 =?us-ascii?Q?QEdxd4PVpY0a9InAKGSEyZLdWBh3t/UVvz3fWf5NOoVDeb58MgyPZS9mAWNI?=
 =?us-ascii?Q?P4pW93ECK6VLOo7X0h2RjMSRmUkvC6ha9Ykz2qha6+DNXD927ScDFLqme4oh?=
 =?us-ascii?Q?RDLWaRF9E9c9DdHxkLZl6Pq5ibCUiqWksiQLpSAB7/87YA8VuWuGGNMas8em?=
 =?us-ascii?Q?pMbjb2JPtkK9QRAv5lgxE7Egwi6mLitF4zUNCM/z+olslkrdkQSGm5HexXiI?=
 =?us-ascii?Q?VVyurixTQ2fZSEQkRZEcz4I8450b1lP8h+L3jZCPjPyTMH4MFTCxpU3RRox8?=
 =?us-ascii?Q?YyYmW68eF9oxWked1AZOPlUd4DHs0VWBH+iOZSsxC8yBp8mACMEtRExYSwsH?=
 =?us-ascii?Q?2/1lcJeHbPFeGFXzqzqb25ClRO9EURhjAfcjap7l5XRxBP+w5acnJDYDR6oE?=
 =?us-ascii?Q?j7sQqOoD1KG1FCg9bYgDLhQoL0CXKAiwvQc3GLvlbhJAx8RCDex9yKcqaLaQ?=
 =?us-ascii?Q?oQp0/D24A1J5+P78FAEGw3JxZKcKEx9SGwWHWi0wrs2KxwczS1fiGGF3gLGk?=
 =?us-ascii?Q?ZdtuTLBuJW0GzIJ+P2shM8w6pLvX+iLoxsKykrYaAvwTTWgS47gw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea1a230-0abe-4e3a-5f71-08da3f12471e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 12:21:36.0843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGqNYdE5FK6opGsOmD8xbDiWCMgHLhDPOt3oPBD5gHg0uoe2rG8Wzpq92CIJvdVQAQkqrqYhWc44vNKj1DnhuEbu3XqINsfbbwFPlM/F9z2X75hszMqn/enyv4MrV7Lxs7PWjJ+nUAEq7T1hg5vWpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5597
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, Paolo.
I'll add the tag and resend it again.

________________________________________
From: Paolo Abeni <pabeni@redhat.com>
Sent: Thursday, May 26, 2022 10:59 AM
To: Carlos Fernandez
Cc: Carlos Fernandez; David S. Miller; Eric Dumazet; Jakub Kicinski; Era Ma=
yflower; open        list:NETWORKING DRIVERS; open list
Subject: Re: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before=
 offloading

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

On Tue, 2022-05-24 at 13:41 +0200, Carlos Fernandez wrote:
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.
>
> Fix by copying salt and id to context struct before calling the
> offloading functions.
>
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>

I'm sorry to nick-picking again, but this patch don't pass checkpatch
validation:

https://patchwork.kernel.org/project/netdevbpf/patch/20220524114134.366696-=
1-carlos.fernandez@technica-engineering.de/

Specifically, you should add a 'From:' tag as the first line:

From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

(Or send this patch from the above email address)

Thanks!

