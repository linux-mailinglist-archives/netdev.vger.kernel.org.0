Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA0127FFF4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbgJANV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:21:28 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:47741
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731993AbgJANV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:21:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksc46LslphtcWl73pKWdsvHdqCR3kCWIbW2/aK51HVxfOgFsepn+BXAEAu8AlEzgjBscCSk58Ug5TIPGpmrMXh49JD7JjvsRPjGeGg7ZU45VyZ7Qg0Bz7RPjyPER2HXMjn/qXkyIdCPu+jvYE+rIEyPvJ0pve2sV0XCylNk+o4+DXNnsJd0+YebIl00ycAOeK/ghGH+BoFc7dC5o2koCYBCCUAsiSDfPW304guu/v4FGwB+C33Dh1ox1/NE8q3R14B0AIuKmT3TMIk+VzP3m7AwPbhjIY0PyD/WF3aEWK8MuNYX9E9JRmqJzhoyZ0j0Khgw0RIyZ89UQvQ3HLfqJ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHJknEIud4YK3uzMb7nVz44Y8thAXiYnVQCmB+vea64=;
 b=T/KW8M6oDMnow1awF3T3K68ci5mT0Gn8mf5rbFNqXj7ZbNSUUdJn3ylsgo8mJO1WuWqym5XYq2UlLCNxhN5OQ9JmDwPxWYfcDlWAQuFAVP+UIIt54+sa5KiU+lXunUKbV2mKzZ44psOCyDzTbSpI/922juB4tlZxdUTDWtwzei9XzhX067JPRRCRnexRhIKhGvHd3WpNIUp9WvIOh3bj505wuY5gspiZalJsOmg6s48Qdhl6GzUCxhE/J0wvBqbN+GVPgfQBYINxgjJxK5thF/2wgaXYkVWqBhvYOOKBxAGAD+V/YxS+qY3U7MvC/OaiS//OAcH6wfUxTia6miyAvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHJknEIud4YK3uzMb7nVz44Y8thAXiYnVQCmB+vea64=;
 b=KgA6TkXN/1svowr0KzZCWHINEjMXX/RwWHHLDFIP8U1inH3Poz4MfjKNAZt/AxDTJVr2bDIbdURa6d5beRWrzvBxkHp9M7cm9CLEldAvK2bIGq9W/N+EGAyYKllmfeVzg/y+f070WqJfKpq1EUr6Rg6Rh0phpgowaejIVkFonk4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5885.eurprd04.prod.outlook.com
 (2603:10a6:803:e1::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Thu, 1 Oct
 2020 13:21:23 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 13:21:23 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>
Subject: Re: [PATCH net-next v2 2/4] devlink: add .trap_group_action_set()
 callback
Thread-Topic: [PATCH net-next v2 2/4] devlink: add .trap_group_action_set()
 callback
Thread-Index: AQHWl15KvMqyfTzp5EKMEyJy7HPJQKmBmAGAgAEkxQA=
Date:   Thu, 1 Oct 2020 13:21:23 +0000
Message-ID: <20201001132122.ylyroyd5c45mvbsw@skbuf>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
 <20200930191645.9520-3-ioana.ciornei@nxp.com>
 <20200930195331.GB1850258@shredder>
In-Reply-To: <20200930195331.GB1850258@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e1a2fd2a-28b9-4717-2d3c-08d8660ce49c
x-ms-traffictypediagnostic: VI1PR04MB5885:
x-microsoft-antispam-prvs: <VI1PR04MB58852B36D8C013DD3C60695AE0300@VI1PR04MB5885.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26P0/TeYxs2zsFG/bHC+YXWwB2Ijhr6XBL7lUQCJK0HevkHmTXC7OK9+lAZvCJ2zwevpYTM5uOfvTgavWxheNw2BPlU1RNsZxL0kTUA1NFc1xmAvCuc5pHGgn1Ms4YtGQE8GzbJ8LVZE95Jx+xctnoc1YxtyVyc10krQsffLVs/pPRwaPj9b1utTrzvXw0RE+U96Rna0rvWMoq4ofJCOVYNAPqLOzbLDP81GOAFo/K1Da4frVXEBIRHrUdstIzOFtJMpoCF1Njg76HtbmPeTlGYhpFIu2wMhiLkUO7eZObk/8jOaHWoC9U/JiHDVT2N4fwtlHyH7JufobyfptVqgHqHrcUzc3LRjQtiM5fMTClxuhS/vIKMO1GfWkqOuW0Qk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(9686003)(76116006)(2906002)(6512007)(83380400001)(71200400001)(1076003)(4326008)(33716001)(8676002)(5660300002)(8936002)(6916009)(54906003)(186003)(316002)(6506007)(66946007)(66556008)(66446008)(64756008)(6486002)(66476007)(478600001)(86362001)(44832011)(26005)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HCRAAiCgGce+fUiEHVie4H66AKsOh+Q5dBiT3+mQfHBUq2HRBZixgNTkSSumZyzbbONd2PBM8+vljdYJ3EBD9i2wDSRA/0pZ2O0Ulh1//TkRXZ2vTj5jjzS/nuP2T6FOxJP5HujTnvsg8JN/IIK5u+CP13NaStLYCkUNxh9srTx4w9lLL57l2+JTQ20eiNWd11r6pmmtHcSiNYgKBjn2aWIby/WyKgmCs3OXLeZy0hVy5uY/yjKLetqgn74Hv8Qi1jNTaJOLoyaIz/NkWdCtoEwM1uIRoKsUTcOaYGiJ8siEkZ/WoQmcbLXoK1EK3PxVreMbXSgsoN4eBoBF1bEH7NrIVFXg2yqzkUvhc3tRf+eRdaNDl8tAwef2WHsnS8tOoG9NzqW2+cZPD9yF/CMJhkMDnUe5u36mE9HJLTsabj/yJtQ+V9fG4VB2/VPDE0qL2P7QU2DVSQpjnNqjHZ5f84VHLFbNuQnhadBIhidUI3Li2HGAyWJ5tLaX2MOdNU83PO9hNBg5r5KQgXQ4BIeR3zOtJQUfh9Zr9xJYvzTJ8J0TWoD6o+ER3ZTC2oDcyXJf82kVDJzvIXp4CrpisJph3tYFfHNuGT5AeD4sHsKIzh4vcGYw06t6L/PIZuTp5PGIFu6e4t1hvOLNPLyejVwKuw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43B21D4009B9814DBACEDA59CEE6E337@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a2fd2a-28b9-4717-2d3c-08d8660ce49c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 13:21:23.2557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hp/K8PK6eeQM1c4Iu9L74V8PgqeUH/WcBCWzqleAAm799BWsdjE088xiDxi70fqIyEl+CvqIDyKS76gFRwJmow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:53:31PM +0300, Ido Schimmel wrote:
> On Wed, Sep 30, 2020 at 10:16:43PM +0300, Ioana Ciornei wrote:
> > Add a new devlink callback, .trap_group_action_set(), which can be used
> > by device drivers which do not support controlling the action (drop,
> > trap) on each trap but rather on the entire group trap.
> > If this new callback is populated, it will take precedence over the
> > .trap_action_set() callback when the user requests a change of all the
> > traps in a group.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> Did you test this change with
>=20
> tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
>=20
> ?
>=20
> Just to make sure you didn't add a regression

Yes, everything seems alright.

[root@bionic ~/.../drivers/net/netdevsim] # ./devlink_trap.sh=20
TEST: Initialization                                                [ OK ]
TEST: Trap action                                                   [ OK ]
TEST: Trap metadata                                                 [ OK ]
TEST: Non-existing trap                                             [ OK ]
TEST: Non-existing trap action                                      [ OK ]
TEST: Trap statistics                                               [ OK ]
TEST: Trap group action                                             [ OK ]
TEST: Non-existing trap group                                       [ OK ]
TEST: Trap group statistics                                         [ OK ]
TEST: Trap policer                                                  [ OK ]
TEST: Trap policer binding                                          [ OK ]
TEST: Port delete                                                   [ OK ]
TEST: Device delete                                                 [ OK ]

>=20
> > ---
> > Changes in v2:
> >  - none
> >=20
> >  include/net/devlink.h | 10 ++++++++++
> >  net/core/devlink.c    | 18 ++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> >=20
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index 20db4a070fc8..307937efa83a 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -1226,6 +1226,16 @@ struct devlink_ops {
> >  			      const struct devlink_trap_group *group,
> >  			      const struct devlink_trap_policer *policer,
> >  			      struct netlink_ext_ack *extack);
> > +	/**
> > +	 * @trap_group_action_set: Group action set function.
>=20
> To be consistent with other operations:
>=20
> Trap group action set function.

You mean the comment, right? Sure, will change.
>=20
> > +	 *
> > +	 * If this callback is populated, it will take precedence over loopin=
g
> > +	 * over all traps in a group and calling .trap_action_set().
> > +	 */
> > +	int (*trap_group_action_set)(struct devlink *devlink,
> > +				     const struct devlink_trap_group *group,
> > +				     enum devlink_trap_action action,
> > +				     struct netlink_ext_ack *extack);
> >  	/**
> >  	 * @trap_policer_init: Trap policer initialization function.
> >  	 *
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 10fea5854bc2..18136ad413e6 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -6720,6 +6720,24 @@ __devlink_trap_group_action_set(struct devlink *=
devlink,
> >  	struct devlink_trap_item *trap_item;
> >  	int err;
> > =20
> > +	if (devlink->ops->trap_group_action_set) {
> > +		err =3D devlink->ops->trap_group_action_set(devlink, group_item->gro=
up,
> > +							  trap_action, extack);
> > +		if (err)
> > +			return err;
> > +
> > +		list_for_each_entry(trap_item, &devlink->trap_list, list) {
> > +			if (strcmp(trap_item->group_item->group->name, group_name))
> > +				continue;
> > +			if (trap_item->action !=3D trap_action &&
> > +			    trap_item->trap->type !=3D DEVLINK_TRAP_TYPE_DROP)
> > +				continue;
> > +			trap_item->action =3D trap_action;
> > +		}
> > +
> > +		return 0;
> > +	}
> > +
> >  	list_for_each_entry(trap_item, &devlink->trap_list, list) {
> >  		if (strcmp(trap_item->group_item->group->name, group_name))
> >  			continue;
> > --=20
> > 2.28.0
> > =
