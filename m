Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE0E596DE4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbiHQMAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbiHQMAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:00:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2053.outbound.protection.outlook.com [40.107.20.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E383BFE
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:00:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+wPPk/OYXyP/ggFrQyS38K4p5uwjpkM/HiX7JbUm4ZbX2dCjafOU8OLpriDLhMGEYFqhWKCs/0xa/YUXDk+z3WZxKxAy/EY6zAoVrUcrWOY8eANl5zrWjErGdlm4nQvUUeN6KJft0+jOKJq+gvqc/JF2sU+KyiTlLN0Jo+xiHmTgEClsG+0FfjsEZDGoihLfD9JktV8FRnW6sSHFYEYtICD+RVJCA8OuuSXsIdWLUZi0kgcZVhcnjYhHA4dlo+mISN19yjPFQNJ7brD+JPUXvshLErpnVXYFwAL93ZYaQpitXdj4HYaE4h09GQGHiuD7N16g2uOzGmWFVrGH/lv+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upoEBMqwD9PhgseI4XXuOQu8TwwH+eFe9m/FdwNBVlc=;
 b=PB4QYXtCqzG/wHWgjnWUfJ7pYXfiUBtwel24M0OsurYxy51QQ5g69Bpil+1oDZgiFKOlxEyV8DuO9auHB4BX8mmEOm1vmoogfipKFjgOzcsvaI0YCkCIdfvIKKDPrNTf+d3/Mp3fmuvBhr3VbRX6JRDXRbM/Q/385mndCi6jFg+jxBCNs+gZcTRN7ua+rja35GSiYH19WH02mkhBbw8vAB2wCYiez0nRpq1X7GzGeGEr36Sf0ec1dT+T8SMCPevZ8Gy9Kc2sWmiJSE83cI8+8C3Qn8DNEttruj3NSzZJcryZaHGbhhqG4KczM5yfFXKkpDBBBWO9QMYe3cPyiNM8yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upoEBMqwD9PhgseI4XXuOQu8TwwH+eFe9m/FdwNBVlc=;
 b=TjxlVc+Z9G3YOf/oOgYDwKlP32Nr7D94QpM3JZpfFF2Mltp8L04LsUGmkMWgKPp/jMGmks9A+VPNVyQGznlDAqRcltiZi/prnDJb6dmMpLrMAbpM8dItklzr71z+OEf+hBk8XbqY+7nFA2Z/H8WNbD4wkk0BxakgN3dMhg8Mvd8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4665.eurprd04.prod.outlook.com (2603:10a6:5:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 12:00:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 12:00:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce
 ethnl_update_bool()
Thread-Topic: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce
 ethnl_update_bool()
Thread-Index: AQHYsb+nQu/MJjl7Nki6Sbr6EcT4f62y9SuAgAAHHACAAAIlAA==
Date:   Wed, 17 Aug 2022 12:00:37 +0000
Message-ID: <20220817120036.zccibit4dj6gqjyw@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-2-vladimir.oltean@nxp.com>
 <20220817112729.4aniwysblnarakwx@lion.mk-sys.cz>
 <20220817115256.4zzcj3bg3mrlwejk@skbuf>
In-Reply-To: <20220817115256.4zzcj3bg3mrlwejk@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62299493-2a95-4320-eb16-08da804818fc
x-ms-traffictypediagnostic: DB7PR04MB4665:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pyJ7yIZ5H5HPluFMDmA99hr+3zLSNqi+FQOejuXKa0/yc1E+w8mCqx5QF2Oi2FHI8VV9Wrh/Uh2GnamdpibkSLpCcGr5UaIGztbHXBl6+E5uqa0MlpClCPDfIGTfPEob2begDy5HHSMhVV2G2SgQFB+h1JY/qDLhsjs4HhWZjV1EDAZkB4FAyRjAl5M8t93UEfrVP8Df1LCIME3iQNMNGMlAMQFlbguMy+ZZW6hZdIyKs7pAyXyFNIs63XTCtWSgKknOQWFmi4Q8qlWycglRdZ/xa6Q4E4poIiaBLXS3OGTocRETFP1tSL0F0uGBLIADFMeTTGYa7bKOUfubhF7ieWMkGuDX25Hlgy5LLGgtiZfKBot+1EtDcUdq+v8qTInlxntDB1OvWcoqOFZPToONcgS0gRKZAh18rrfkXLOpsM55tDSVSkpbQ7xWDHc4s7ofCg9v9QNUF9C22DAGnXbJi5e99ApGnNSennkb8qYqVw7czAqhXJXJvH496o2tcfaa4Su0Aoq3C8mmf/J2QbTyjzaivWzM5RpiOLiK6vy5d2S9WIHzDnYs1xSBdfNIXweicYReOzfzSF0+2MVeOPY2ntsbm2fH5JbABcrpTCrSKr8gGMx2euwiTxQ6zARGuDvz1xVYbPuF+aSd1EiLJmA2bb0e7t81v2AcKervsrwhR8pZKr6jXgQGlKjfl2IBuPcvIKLRmDiGVx18qq3L2GZPpgkzIXDtTAMYxC58vgXBjg42ysbX6hRsq+9mL73obMz8HzBXn4t2rz4Fl0hU8dt5O434xGziHR55pxSnvXvi0jYPb3ruMp7vWz2m7XRe1OWa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(39860400002)(396003)(376002)(346002)(83380400001)(6916009)(26005)(1076003)(6506007)(186003)(6512007)(66946007)(66446008)(6486002)(316002)(2906002)(8676002)(8936002)(76116006)(478600001)(5660300002)(4326008)(9686003)(64756008)(66476007)(44832011)(71200400001)(66556008)(86362001)(54906003)(33716001)(38070700005)(41300700001)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jfjqtcx2NSMvf28nAM0s4024Cx0Rql/vMMWourRYMU/tD+r/j13gbdLT0KYh?=
 =?us-ascii?Q?wh3T0sz/maY3N1NU5HpG8n6si4CEcgP8WkK01l3Ul3PRnShmAYvB864eNZGj?=
 =?us-ascii?Q?JFDYKx3r8xTR7otWlZ3EoBn8BXrW5epk4OIER0Xi4ZlXE0EczOt/Yz0+otRr?=
 =?us-ascii?Q?tJNJS0cmmo6/ZhL12JLj0TchGgZnd2rBDnAQWS/p3mnxIS/MJhR0jHecklcq?=
 =?us-ascii?Q?Tg+3MaF5nDaNw68jiBTDpLrrIiJ0vGESUazZPpXyq84VgFDGWl/W1Po4+HXE?=
 =?us-ascii?Q?aC/Xyg+gdz6Tg9tDSIpviSAZAd52KgeHLTTZEBNXF+kppS/omQ2LVNqJNMDq?=
 =?us-ascii?Q?m8hQA9mnyswbxdhNLIaL+xZDqaVVe6XzYQXQmqrth6Hc9EMUZKJZDBswH83Z?=
 =?us-ascii?Q?tzbsLLm7uJV/DfPiNoD2FmLu4faw2Fgnr4LWmhWRQPVqDc/YX812zDeYEmD8?=
 =?us-ascii?Q?UjU5OsNqz0uicAnybr7I4Lacxy7uO+plMDObCucFYEmlKFXbTAfXcu7f6j6Z?=
 =?us-ascii?Q?UwJcbn2FYpjlcseimxGD9miZruyQzjB2ytnnzaBmeEl/NYS1KDkdqGYnGt/u?=
 =?us-ascii?Q?tBPDJso9CGOU1mzmas6dx13xN3DDD99fA3Nm/0oMYWrFTeUG2mk9RtQ137//?=
 =?us-ascii?Q?udUXxsx62RV5vSJgAAMMwLLtXrbHIhRmwng7GzO1UMNftd9SAAqQ4dTNBbJk?=
 =?us-ascii?Q?yqnh84g1Bo4CvJEO5kVLqX88lEFsLdO3LHhCgL483AtslDNjgffYyoMUveGP?=
 =?us-ascii?Q?pcl5dG8cJBkJUX5DSRsU/geVT32ak1VhNFCBXHoBQpZCU+fygoQIblHRcdkp?=
 =?us-ascii?Q?OtJYGad+HWT0jsfk59BCZjrxD+EuBD4065BZymThNeWEr+jYKzhlTJR0W3oT?=
 =?us-ascii?Q?O/zkiZ4X818rgMuqDXkDc6zhxLFZXtdG2NEp9Ay35R94es+C1iyES4kH4Bg8?=
 =?us-ascii?Q?VDDnjj6H5HP9FIKUBoxg+9xFelWc+nbRFqAqvelJ3359YdcZCVA9bg1Mptoj?=
 =?us-ascii?Q?szBWlH1KtM6jgPcENBEN/I0WqCuspKuMw+zwXptiwj4/9rX+0oPZq/tjAgZg?=
 =?us-ascii?Q?U456TgCPvcDPqbz3DQZWlgkB32v7zvexpNTi3+bhQ1UGwXJTuY0FfvUsuHfU?=
 =?us-ascii?Q?qFTcj80DN7fCSjK3ciIZOPtJwk7qklY6Wn5HVxuyzpbp8Ar8ebRVYgEIrZMx?=
 =?us-ascii?Q?kSk42fra/fBGl0i1O44KLoSMqfBDLGHQbrVZUfLeEiSpm9XGJGh1EwsTBkxn?=
 =?us-ascii?Q?kb2x839jvc+zaEDg3RqpW/Ye5fndUCSFgIBWKGuybfoIa8s/qOcNH0xuuPyi?=
 =?us-ascii?Q?PBdlblgv2F9VcmNN8OtcssVhDF6U/ehavtUtAQ2hj3Nw7iVSr9ZvKvITxDn8?=
 =?us-ascii?Q?NWJTCjfp6QsaL+2+jM0LKWZ/9quJmTMzQ53PDAzojaocfw4IkwXO199HmKNv?=
 =?us-ascii?Q?rE9ogiuN/0AtXXlnLhtoEOW4E7S0Ij50R1KfdxCGQ17ZG0/jIjUaiIVNAh8A?=
 =?us-ascii?Q?aiE/2O8Vz5cRdE9jZfW+1LmL4GiJS8yDpwPmZosy5xs5J+O408wJm+5ZQbw3?=
 =?us-ascii?Q?UFgEKE/HZiyg/SjbgkTfwUeXXy0ye6qSyLDPKMZQLdyYPUOONWSyP6d6hED1?=
 =?us-ascii?Q?OQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28347375C7FC024FB26C8969A9A60A6E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62299493-2a95-4320-eb16-08da804818fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 12:00:37.0950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+ywdUhj0oDynjg/25deDuN/u/5B3w5kuBClZWho1wW0w+O5gL+NfuKiguiORMPVDl3f/AwLbJ6/wFdcN9FI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4665
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 02:52:56PM +0300, Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 01:27:29PM +0200, Michal Kubecek wrote:
> > On Wed, Aug 17, 2022 at 01:29:14AM +0300, Vladimir Oltean wrote:
> > > For a reason I can't really understand, ethnl_update_bool32() exists,
> > > but the plain function that operates on a boolean value kept in an
> > > actual u8 netlink attribute doesn't.
> >=20
> > I can explain that: at the moment these helpers were introduced, only
> > members of traditional structures shared with ioctl interface were
> > updated and all attributes which were booleans logically were
> > represented as u32 in them so that no other helper was needed back then=
.
>=20
> Thanks, but the internal data structures of the kernel did not
> necessitate boolean netlink attributes to be promoted to u32 just
> because the ioctl interface did it that way; or did they?
>=20
> Or otherwise said, is there a technical requirement that if a boolean is
> passed to the kernel as u32 via ioctl, it should be passed as u32 via
> netlink too?

Ah, don't mind me... By the time I wrote this email, I forgot that
ethnl_update_bool32() also calls nla_get_u8(). All clear now.=
