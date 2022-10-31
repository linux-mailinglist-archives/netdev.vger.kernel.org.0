Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC568613239
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJaJI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJaJI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:08:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50299BCB3
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:08:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRRKjDHuMi1VUJT/Suni9t6R3bOMNxxS235ZYtssDake0QF2fZ38zyAv0acQIypLJjKb7gTFJO83jG+poqKOHmdPv7z0c4WfXcSSiA75Vl8nL3w31unv8ce5UqIatMlVsizr5gAM5WSWfMAo+d2fdeuTOrMJ+nxNUN49zdSynZfKgYzHvCLSgGeZQ8aWqel7z9JmoqXq/NhCgQImlLaEK/cxCqbNurOsJ1H2sJQksIKHsNI3z/V9wCtUIx477RRc4q5DWvzw5tX3HnTohJ6gACOdPpw1PkPLYzU9r7vxUNGv/rPXaCAND+LAw3qd2HNObjChuMUZS6usI+Apv/E39g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7QZhU14D5vX2Z+6QliBOrUe7EkYPdn2Ivplzwi2zd8=;
 b=SlJrbT1P3QoGYH8gJSmQ/IWuHvxCgV1GmqA6D4f24MOd2J2GGh10JIrOOHCNwKB6nYlYh/oKA9d7FtRDBhA0clTQWOl7i+0bpQh8ohktr4E8I1SpGr1u8QAi7Um6IxTHbyQ+10MpoZPoKnkNI5mbSAU4kBblPshMOB3a1hnfO8MGm9d8fKnPTbIclLmCZ92S8fZSkipEXajLTIsDPZL58oHHKisGkp4GhHSAqjJZf2Ojo+tIWxl4WLbKFL0SGO8JYHlx9H9k3/0q/SmAZfzY0ZkFkSSHyf3NwyT8bZwVxfWV90O1RgcVgruFR9F8qCKknDoer4kCIr0YxH2zfuiLmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7QZhU14D5vX2Z+6QliBOrUe7EkYPdn2Ivplzwi2zd8=;
 b=ly29N7f/ZpEF+v1XFui6tsEF6RUkbLw5UIIoNFeEIyj5mJPrGEN4z60S4bvPLFI7haNZWgyBvpxerd753Zhiszklsxy0pDhkUWB5CyNASVSvfryG/vXqcg9eaDlm5kLRIdTTsI1k5TY7SBNt8edtnE5d49VrFZbkQr9gqSnFQZw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7986.eurprd04.prod.outlook.com (2603:10a6:20b:245::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 09:08:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Mon, 31 Oct 2022
 09:08:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next] rocker: Explicitly mark learned FDB entries as
 offloaded
Thread-Topic: [PATCH net-next] rocker: Explicitly mark learned FDB entries as
 offloaded
Thread-Index: AQHY7P7BDfwnpK2/kkK9V7yo4j3nQ64oLIQAgAAKJQA=
Date:   Mon, 31 Oct 2022 09:08:23 +0000
Message-ID: <20221031090822.q4zux45vrqr2wqi5@skbuf>
References: <20221031075922.1717163-1-idosch@nvidia.com>
 <Y1+IBAoSHj3kLQIA@shredder>
In-Reply-To: <Y1+IBAoSHj3kLQIA@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM8PR04MB7986:EE_
x-ms-office365-filtering-correlation-id: 65c65863-2767-44c4-1069-08dabb1f7662
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hkd4umZMhFKjbmV71MDSEqn6RgB8ffKyrZO38xj7AUJMXF9PlJgMtIAGPjAj0M2LavXW3qbEx3mX09SwGtHhZs4Ww7z2Hp4212AuKp+bORMxC095YvdvVa/GxhneP5SFpSgJqucpymJTniM6qJrTN9J0wze9+bN+9h0P9IYYoRd2iHUz5MhZCj1VD6I64F3I0okNaWKfvQi/4rwj1L9br+Zj4Oty1cBNPlPWSCQOUvaJt8kcFn4Sts7p0WLWazW+4j/IjS+x+vm7vp0W/zLDuhRbfgssJ9Me6JeO5Oz2fc7Odri69qJz6g3pstlf6G/EAoR1kMihPmI1hKCe8w5YA9g9gY5/AgyQj+3YXxPNXLiZJk/pYSKmjQAJcVyTzkJX/On7+xi+wKLXMgLEtkHkZWa9EC9p7XppOOHXNSnWhk4UaVT/5EKnNeRvDxhSzwQBibA6XxMeDu1HmvI6cMjYS/KAHqTcP5Ts9+OMOy5ouXK76f8Hi4Nw3RqimU/LbrZJwjbtmGEuDI5ZTxo5t0Fn7Vzj6UfeJh1zoOJDawDsPaOKLCHeSrBkOpIbNx6yjUezOLI10L7lIGKcWAcuTFWmTFTKnHoel0ASWdNHfLS8tj6zEXiVYeamQ5DhjGGgGb1vjlZUq/SEDmqtPK7YmEDjv7sqsqMrGZRvImpGljxqmp8bsBNl1+EuimHbGY2gSdneu/w5k+BDeC7WvG2tpb9jydElYKrvszF57klETQbcrIF/aveOqLJWRAeov0xvBCIYcj1WETUwJJx4bSVsLWgOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199015)(38100700002)(8936002)(6486002)(66946007)(5660300002)(122000001)(478600001)(186003)(1076003)(41300700001)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(38070700005)(76116006)(2906002)(6916009)(54906003)(86362001)(316002)(71200400001)(44832011)(83380400001)(6512007)(26005)(9686003)(6506007)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h21lSNtX1mVslw4IB0A3ZjuMW1VN/rh8vmFRRVy3KLWq7PiPOFEBml6lDlL5?=
 =?us-ascii?Q?0f3oM4JfCxhtt9+R//dmr0oaTgYbTQ7Sg3n6YqwOUB9JmAKipwcpKPwmSndE?=
 =?us-ascii?Q?jHrEByIZYhqAb5N0EFdhNKSQc/OaCt5uoW/hK2ZRbutZTMG5rRxYGNMTlF1/?=
 =?us-ascii?Q?D8+zgfiuMPCN3kU4ahFnLSAw7y/qfxez3EXjDeWuXoDssl6subTwN6Xs1VVC?=
 =?us-ascii?Q?cye2SP41bR9X6/iVNBzM8De8a1tBj7pAchKMeOr1jdGwujCesmpRh7YxHHGD?=
 =?us-ascii?Q?zVQyF8O9HcGfw3YYt9+qHuoqCyY83MKVqn0n11j2JzE517D1TVzuFzBdNiKc?=
 =?us-ascii?Q?TBhvt4QCn8GFYYZ5oXMhKm+/FUqUDTo1qEzxVDFVT/84MVRt4+vibltn8hBH?=
 =?us-ascii?Q?mqxn5nQTFaxPp+li23SGZ4kG9MQmyOM8S1Z5wVlQqwWEejXGBzUzvZlDoO7Y?=
 =?us-ascii?Q?//YAJQOum4L4HBZ5Rv+g03es/SYqZJ8tbkTzZgQtYgOT7pLEhy8Mz+Fn9CHU?=
 =?us-ascii?Q?JJlU4cTU6n56lUfjtsHBajdmkCeqU+oupMyf/4P7M/dW+ZTzA9vTZLma+CON?=
 =?us-ascii?Q?BRYvqMPm0HvTkCh0UJizQN4eiA61m+QQn3Ia/2MdtZGyr7e2mW7I5Gc98zf2?=
 =?us-ascii?Q?g4onfRbBWPuSbNsLwbJcSL14sZslqTl5RNADkYEuOOToPIQwd6vEt7XqoQZQ?=
 =?us-ascii?Q?ahbG+0wzZhR4EUm08lY2W+J0Yn7am6f0CZn/CjZXsdRfmpj0SdfdWxsDNO+Q?=
 =?us-ascii?Q?sCWAgcnjOdyaV9Fra/OQAIAyb41+hL5xzMZQD2Sl62qLwK/W0TDNXvvLGlg5?=
 =?us-ascii?Q?38I7rxVYplvVfeg9QirJoM9kCnoZJfvTxc92eGv7cgoUG9yO8GaVqw9tNZez?=
 =?us-ascii?Q?C5UjYKnkJxQs4Ddm8jKBVlmB8zHbxaudhsvSD4k3V6jKY3kk//qtAeTe1Qyi?=
 =?us-ascii?Q?v986uNSXq/Pma3ATEBjfHT7RNQ2UhJusP37rTY8GThBkdNnMwAkuK7amK7mH?=
 =?us-ascii?Q?m2K39BfmfqiG2gTUWIKX8cBzKgdV8ao3P+TNrxAH4S2Ay3AKvo5ghoxu4Eiz?=
 =?us-ascii?Q?a4aTnJnMvw1Nlv7rT/MeZbSVimH9/h4GO0sMJVM1q7pOZvosbmm/zhrimboN?=
 =?us-ascii?Q?744n4J+jWjYkmOXMupAlWIdzhpOX0p1MDULQFykneiBuHEZ+dC5+M/sbuKlV?=
 =?us-ascii?Q?TgVrFSUJvNyTK7+cefwI9fNzoiHUtpiy+g2aRRO//UCK+8xmuNAJHgBxaNWs?=
 =?us-ascii?Q?aVRf9DDwBPXMh4ORUTH+K7xna0HMx91GwGZiJBfALw9woai42yvTAuPVNudz?=
 =?us-ascii?Q?Ya7RjKavp2TzmpG0BOoNKACZMXnmKSK4pSFlh+kV1wF+KlIVTionHZtVEJZs?=
 =?us-ascii?Q?Mlrl7Exf5XWrdNBK2nGMYl0FO7bvy4nyCBYQpHcuNkNYOgxUjOgbBDEO3fBh?=
 =?us-ascii?Q?FAgAzYAuCg/+PjEAGQechgXS12Fh2Mgrag+ydmIo15BzNtu6IHrFuuyzWLvh?=
 =?us-ascii?Q?7m7yzXeUOyfKibkVgVmghbOIdKtwTNYRe5qT516fFNWUnNp0h5H9WXabcBYr?=
 =?us-ascii?Q?DQ9IGjLWTDAkN0F9dMY/UZpmzvvp99fIPsc7ZjbO0THwjTUJ9B+mVwr3CyjS?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5004131299CC4D4CA5984D7BA2B450D7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c65863-2767-44c4-1069-08dabb1f7662
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 09:08:23.0708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hGBMNtIS36TjMzqH/hEswm0+Svvewh/t1lKIYnNNH4iMpivg0wDqn4Ojlv0aQ+Su+d4kNLTMiWvqmxqmBPhAeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7986
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 10:32:04AM +0200, Ido Schimmel wrote:
> On Mon, Oct 31, 2022 at 09:59:22AM +0200, Ido Schimmel wrote:
> > diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/e=
thernet/rocker/rocker_ofdpa.c
> > index 58cf7cc54f40..f5880d0053da 100644
> > --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> > @@ -1828,12 +1828,14 @@ static void ofdpa_port_fdb_learn_work(struct wo=
rk_struct *work)
> >  	info.vid =3D lw->vid;
> > =20
> >  	rtnl_lock();
> > -	if (learned && removing)
> > +	if (learned && removing) {
> >  		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
> >  					 lw->ofdpa_port->dev, &info.info, NULL);
> > -	else if (learned && !removing)
> > +	} else if (learned && !removing) {
> > +		info.offloaded =3D true;
> >  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
> >  					 lw->ofdpa_port->dev, &info.info, NULL);
> > +	}
> >  	rtnl_unlock();
> > =20
> >  	kfree(work);
>=20
> Looking at it again, this is better:
>=20
> diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/eth=
ernet/rocker/rocker_ofdpa.c
> index 58cf7cc54f40..4d17ae18ea61 100644
> --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> @@ -1826,6 +1826,7 @@ static void ofdpa_port_fdb_learn_work(struct work_s=
truct *work)
> =20
>         info.addr =3D lw->addr;
>         info.vid =3D lw->vid;
> +       info.offloaded =3D learned && !removing;
> =20
>         rtnl_lock();
>         if (learned && removing)
>=20
> Will send another version tomorrow assuming no other comments.

It may also be an opportunity to not take rtnl_lock() if (!learned), and
this will in turn simplify the condition to just "info.offloaded =3D !remov=
ing"?

Actually this elimination of useless work should be done at the level of
ofdpa_port_fdb_learn(), if "flags" does not contain OFDPA_OP_FLAG_LEARNED.=
