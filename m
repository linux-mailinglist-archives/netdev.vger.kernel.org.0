Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED27567C90
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiGFDgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiGFDgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:36:08 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30137.outbound.protection.outlook.com [40.107.3.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2284A1CFE4
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 20:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ot17fTpFBygte1Nhv4HHI/L+aokHwsTTPC85tnrZzFYi2OnGNRrj6or6wKsyguQW7MvVMxslMD4z1AsulMMMp6MystuUcLnksQpgrgOvppXlBsVjM70K/nox6QKXh3NWCRf7KPJPRsBnfJckD9rxVl3Dh9k5O3rkINul32nn8RHOny0XG7A8R34rNcY4F6O321O6+qQ50CqwbTInMjjz7dSz0XQleacsK48nGCNyKbUcB5J/dqWmwrY+kwuNf554oqGTCaRydfGNJeYp9GP/0QNBH5VCoEI4zv7RasSCPUG7HgnXcPpzJndC7rsJq5w19THmWMPcR4RnLrbYkNdEYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vf5qoqUhjsH8H9g+JNwZ1Iy9tTzsFlelHq5kREQuk0k=;
 b=geQfkVX8kn6SVLXKHkyRl1lq20B/65ZNn7yEIEd3KhUCZMdN7hpY4WYr1O6D1dkbh59xjRIq+mIi24jE+3NLTRszCuXdIfPRk8iMchf+sMYYAKwrFQxUdYO4XDw7JWei2RIMYGVc7BY7hmNp21L2KOorv6WuMnmSmMT5kxXQb+llbCat9IQLhbuyRTudezLXaefsvl8bmtOoCQE0/8adkBrVMO2Kso0vOy297Qsi8suvpJy/FuosRoZt6KG3z7ihyGOOZIDfshOkrf5Iu5YxWyW49a0YowCt0CsP1aDGBXZteyMdqqCWWWbX7erGSwqDS/63jEg4uotiYp7i423Mrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vf5qoqUhjsH8H9g+JNwZ1Iy9tTzsFlelHq5kREQuk0k=;
 b=yK7f1isRChBKlUDzY6gxxQ6USxgzQyXZmukO/GCrMRQcXx71Mvd5wlq4lx1riaKnqAOzBGZh+blPOBH2b7ZdZO79WpI62born7D36iigu/Cwxue6RmccTiQQkG09hZKjtTlArH6XyiULZS+ZdGI0hCKSneNrQsauIqaw2RGLM3U=
Received: from PA4PR05MB7647.eurprd05.prod.outlook.com (2603:10a6:102:fb::12)
 by AM6PR05MB5781.eurprd05.prod.outlook.com (2603:10a6:20b:95::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 03:36:01 +0000
Received: from PA4PR05MB7647.eurprd05.prod.outlook.com
 ([fe80::a167:e9b9:97aa:21b5]) by PA4PR05MB7647.eurprd05.prod.outlook.com
 ([fe80::a167:e9b9:97aa:21b5%3]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 03:36:01 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com" 
        <syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com>
Subject: RE: [net-next] tipc: fix uninit-value in
 tipc_nl_node_reset_link_stats
Thread-Topic: [net-next] tipc: fix uninit-value in
 tipc_nl_node_reset_link_stats
Thread-Index: AQHYkAlSSclZSgjtNEOK9uF4aO1nwK1wlhEAgAAbL4A=
Date:   Wed, 6 Jul 2022 03:36:01 +0000
Message-ID: <PA4PR05MB76476F5513C4A5BD18EEA237F1809@PA4PR05MB7647.eurprd05.prod.outlook.com>
References: <20220705005058.3971-1-hoang.h.le@dektech.com.au>
 <20220705185238.1c287512@kernel.org>
In-Reply-To: <20220705185238.1c287512@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecfe0268-aead-4dd7-1d45-08da5f00a5f3
x-ms-traffictypediagnostic: AM6PR05MB5781:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QbTJTeqREIZ07Vkj6AHEOhi0nhQOw6EweDcb5VP+/I/jZCGkvT2qQ5sz7qd712v2DspcjRMzNC48qC7JEjlcKar0zOiL07UhjBX9pwtmpKQwVVP7qFPBnx6Lzrbb4qtnF1K3JQrV2edJPN8o8njbm/d/Dv8PkTqlF3S3glUK08LAZJDQ3K+MG883+0WxNSKeYclmnQx5DiZCO5BajiNQsli/ar3pRywJ5xIfaClRQSZUqeMbzd9qRZOWqA/MYxZ6mPzASY9oab1hrFokiN/CrC03dtkYh3rL9AL9fuPOeAeaRyaci9Ye2oQDk//lt4/IOGELXEnTcHPKovldUa+iGdoVSJTTbVaP9h7ZB9nehvFMYO3mcMHa4JBFM8IyUiTHqLmX0OTFexqWyr/uvdM8O7MPnixIe8YIqXF8klsgb1zqkm4nNYdMAwU0fK7xPsQN4ik1go8ITcWcnt1sR/AgB2u72jglyTa4fAHDcD6HCRGssgDk8MGwU/FmYlR/x+zKGrOfraR2EHumdh31j4Nt3lZHe+vVYaOp+7QG0ZOKlwq5oJ4ODsxGrnBaQ9Q91pxBSzy0w/A+/s8lBy0Qr7L3dUxUHNK0zKmonQtru8AXLSiXSjFw7emDaEVOuy1Ft6zRgjuxzG2zals4np3ingFXjYcWrP7u3ZKvCli4960IBJUtIehM6EIwaqsWLjuue5/IroLIlHx16Vb1S8yMm9Wdv2eudUscWL/Mmk3lN4RpgtuSMlX5DT73ogQ0BCbF/F/OzkdRG5EhmP8IkdOMHtL28p/xPZf4agptndOW1xrlVhSnNNmbm5DRiM47yxRNy/nU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB7647.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(346002)(39850400004)(396003)(38070700005)(6916009)(54906003)(316002)(122000001)(86362001)(8936002)(7416002)(5660300002)(83380400001)(55016003)(66556008)(8676002)(4326008)(76116006)(66476007)(64756008)(66946007)(52536014)(26005)(9686003)(66446008)(186003)(38100700002)(478600001)(71200400001)(55236004)(53546011)(7696005)(6506007)(41300700001)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EDKeLjEZqZcRXsGmMna3bgr4+Iz7hp4TSbfJGuhgUwq/wLEAS6o+X/uE03Ku?=
 =?us-ascii?Q?bfx5zSoLYAaVj3gxpwwAmsll9VL1CpaNymwCObeSqTJcKeIAJnlgc3sXbwdt?=
 =?us-ascii?Q?Kyl6D51F/QJht+B1AAPl0UcsLYahFHDtcO41SgbHyEiSwr+7Z9RMxPqpOfFD?=
 =?us-ascii?Q?SJ1kNuCQ/F8n7POSVG89/a4jsx+yCjk4OxvrqJQI6AyY5Bn3a+1wXghp7nWn?=
 =?us-ascii?Q?Hy11LFxPhYKJzD+8Wym7ZX53y+nEG4fxM7QeV5+I2XUKk5ODmM973BrNfd7U?=
 =?us-ascii?Q?Cj0AvkiAba1R7T5tVWAsW6lvkxlOx2/1iKkfJ1kd4gQmF6WUeQU4ML1M3XuX?=
 =?us-ascii?Q?ZO81VUgEMTIxIwnxXlTLSapYN5+Ek2GQLrwXOdwep+YwybfHspl3Q/+RE8zS?=
 =?us-ascii?Q?UOAE5F8Tf/1U8MRLQ8pfkm7SbbAvvYIwJqTUjkWZcwHenQZ1T2W1CJGNVkQo?=
 =?us-ascii?Q?D2BMEJMOhqtA5MJSkUhChppMV+gtP1hFK8ExLLtqan7YtwVRUcKNxNs9U8LI?=
 =?us-ascii?Q?HC8r05oZTpW7X7whKhv288H3toLyYVebHxPPcc//+YkaIT8OUWzcbdvDibmi?=
 =?us-ascii?Q?WOU8viZaIH8o+5bT2w/iIwD89XOu0iAsPvLxTOlzBtLCBnDEOlnjmSzmL5yK?=
 =?us-ascii?Q?yCyixvnetAe/JSlxb40LIiQwK6ue+XOodV0W9+AJ5juaLkfsWc4TiwOIQcuP?=
 =?us-ascii?Q?niiTiG8f0kskgiqU9WoC5iFB41OagAfy8UiEpsHV3f2Xzgzkyo2dooyVh+r9?=
 =?us-ascii?Q?yYpGyT2f7KqrJSP6JA1KO+ByCAS5+e14j4QNGRvcK2Fh02CTHMJa6F0bvG/x?=
 =?us-ascii?Q?TBP75ApSmV3ILlJpWsJDScIveTKeikQpbZ/Z/CJmIvS6JkhayTj8cqcRWcNT?=
 =?us-ascii?Q?azrUBaHE252QTVGdbKGyfHpXbYK59eG5T8WGNpL/TzdEaxd3fDmyx8hbxJ9F?=
 =?us-ascii?Q?5XqkkCo7418EJDV5oEJy2aHobBqoZ9kwJXwcEjMeLCG/qd3ojwOT6bATfeuX?=
 =?us-ascii?Q?8a6ezXaxwlMvaKmWDyE1DfWU1/Ti2OSovdX7fMZULr24ZZPUoVb+3pCkDYyY?=
 =?us-ascii?Q?smV4JRSwsCue4HnA8l5tUWzzqDNDVLYphG0cABwPd+PTtERKxNX2SPGdfhRO?=
 =?us-ascii?Q?G2fAF1akci1nIm0bKoevIMlg9lRdhH1TbezhTpZ2hKBqR3K15eyNaWuPjnsm?=
 =?us-ascii?Q?HlfaLIL7cxe5RbfBwGG7yN4zgjGPJeK41Zec7d4hl/n1v31dSIy9Kq48tRg3?=
 =?us-ascii?Q?pcrhltyyLwywIvDxhyXGSxfXhoouw7EuWKLCpqvPQtayoToVN8DuxEX1wxwj?=
 =?us-ascii?Q?D7rIndL74CFOX/bj2jVzp4VWNwY/uPhgsfyB8S3cGXiAqf+WmJAAAB3wPKnv?=
 =?us-ascii?Q?NQkEOG1B19vHREG0KBiP1PJBosidqmOJ3rq0r68bzMQsjV4Z4WNpC77b9YtN?=
 =?us-ascii?Q?GTHyhy5vb2BOJ5+KqLWaB2lq6ukmA/q05Zxao1Q+Hz5yaeh2w56kPV0HUfZH?=
 =?us-ascii?Q?0+Rgjgpxk8Kprgy1OaYLPVp/ASQsFt0w2YdUM0Uak1806tUuLPUjzoZF9abN?=
 =?us-ascii?Q?HUFsFWXFgysrg0IYIJSZapcK5LWryNpZNLIuN9Fl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB7647.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfe0268-aead-4dd7-1d45-08da5f00a5f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 03:36:01.4533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MtLCMB83je6C3XV+WpbC+9xyIgk4qPtMQ22d3NJcuDFCkC6EgYPVJ+kPydVCMhhSHcDqGSg8dLvABY00e0eoHagaTFwyXpYUfB/z6nduUEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5781
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, July 6, 2022 8:53 AM
> To: Hoang Huu Le <hoang.h.le@dektech.com.au>
> Cc: jmaloy@redhat.com; maloy@donjonn.com; ying.xue@windriver.com; Tung Qu=
ang Nguyen <tung.q.nguyen@dektech.com.au>;
> pabeni@redhat.com; edumazet@google.com; tipc-discussion@lists.sourceforge=
.net; netdev@vger.kernel.org;
> davem@davemloft.net; syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.co=
m
> Subject: Re: [net-next] tipc: fix uninit-value in tipc_nl_node_reset_link=
_stats
>=20
> On Tue,  5 Jul 2022 07:50:57 +0700 Hoang Le wrote:
> > Reported-by: syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
> > Acked-by: Jon Maloy <jmaloy@redhat.com>
> > Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
>=20
> Can we get a Fixes tag please?
>=20
> > diff --git a/net/tipc/node.c b/net/tipc/node.c
> > index b48d97cbbe29..23419a599471 100644
> > --- a/net/tipc/node.c
> > +++ b/net/tipc/node.c
> > @@ -2561,6 +2561,7 @@ int tipc_nl_node_reset_link_stats(struct sk_buff =
*skb, struct genl_info *info)
> >  	struct net *net =3D sock_net(skb->sk);
> >  	struct tipc_net *tn =3D tipc_net(net);
> >  	struct tipc_link_entry *le;
> > +	int len;
> >
> >  	if (!info->attrs[TIPC_NLA_LINK])
> >  		return -EINVAL;
> > @@ -2574,7 +2575,14 @@ int tipc_nl_node_reset_link_stats(struct sk_buff=
 *skb, struct genl_info *info)
> >  	if (!attrs[TIPC_NLA_LINK_NAME])
> >  		return -EINVAL;
> >
> > +	len =3D nla_len(attrs[TIPC_NLA_LINK_NAME]);
> > +	if (len <=3D 0)
> > +		return -EINVAL;
> > +
> >  	link_name =3D nla_data(attrs[TIPC_NLA_LINK_NAME]);
> > +	len =3D min_t(int, len, TIPC_MAX_LINK_NAME);
> > +	if (!memchr(link_name, '\0', len))
> > +		return -EINVAL;
>=20
> Should we just change the netlink policy for this attribute to
> NLA_NUL_STRING, then?
I recognize this is redundant check. I will post v2 into net.
