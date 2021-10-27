Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC3143D1E1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243748AbhJ0TsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:48:21 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:36806
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231656AbhJ0TsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:48:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAmE1dOucJfHLnAK4l+GC/XihI22TGztcE0h3Ha4HkcOJAA7/Ek0yiSLGHYJIvEzRyQxV1SiYiHn718mEBJ1VULLwhfC8VXlFhu2q1V2jTZ4ilDX6y/pETkUQpIliipC62Ms2HcNiq6P2+GsBeFEh2A4vYwBHRe567ZbJ/k1IutK+Fj46Dgg38qZsjzRyaqt/nJdbqyI13XOH+GiNwXsf4vG6OzklT/q70IvDuVxJ4mZSYxL12N+KMLF26A21ukh6QyA2Qg19iDGfF5V4y8cEwZiN+HRI8GfBpm4cM2cFkjqaHbNvvR+303WdVa8PbjLfgWf4G2AhfJ3XOGyYCco5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSVVBLcYj8n8kaOAL+fiCSRw6f5uda/GAU1nE3CVfo0=;
 b=bd/xDFWRSorWxK/63IPD38OIRkRQOF+MrCl4L4z611W+sw3bPBSOyW2PJrkN8CHti0lqrIuOo5vzqBPbr+oYs62hz4URBL4hIGhy6pRpzYCdjCuXp/xVmbr3xSEGPlYpQT/Asmtr8ivw1XsxUSYCsVDTvVpL5sn1xqaqH5gRkaSqJFjVTDf+wK9+CK7pFuwhRmD4lOQx0jcdAlbi87fLNxjWDzDnLNrgrmZ7azKNYBWTO3cimG/9Yh2NWZehm82GEwpMo8m4t2xmyf0cMaP54rBOC7r6bi9JnRwBygbWLtVsWO3j3Z62jJevLKdBSeHAD/ZNHJpWrA5pxY90Gb8buA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSVVBLcYj8n8kaOAL+fiCSRw6f5uda/GAU1nE3CVfo0=;
 b=GOwrg5dLdfIBnLhVYeZHa5aTrJMF2hQKJD3+MxFydQxWV6Vy3UUTo5zdE3OmTNyXK0+RrHiYNVA2FDqr3Rl1iJKJcGFKg+if/8LFBY3rufoUnnWYmdJbTuzSO0FSKWukNV3FBgv6Bwk+jEukpf2jB3uJZ0WGGhvo0ykM0nohuRg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 19:45:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 19:45:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Thread-Topic: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Thread-Index: AQHXy06zYKcVsip7T0mT7OBKW9nN56vnOvIAgAAE7wA=
Date:   Wed, 27 Oct 2021 19:45:53 +0000
Message-ID: <20211027194552.3t4l5hi2ivfvibru@skbuf>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-2-vladimir.oltean@nxp.com>
 <a8d9df33-408b-a2a0-2e77-754200ff7840@nvidia.com>
In-Reply-To: <a8d9df33-408b-a2a0-2e77-754200ff7840@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ce2a91a-d97a-4597-67ef-08d999826301
x-ms-traffictypediagnostic: VI1PR04MB5693:
x-microsoft-antispam-prvs: <VI1PR04MB5693E8C9DD793B4FA5BC1971E0859@VI1PR04MB5693.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B+DSUdUgE87pN47Bdq0QPXmSl+snJPhavdzYBk5zU8joI0mkjOezpwLJJptifPg8D35wFS2BK1A+k9ZIFLui0CxfGAUj1VANkedUtwwFFUf7YjiQJzH2gc0AYaqF77KAqz+xSHF/Oa8lvCnvlbL6TV7CAMlE20ce4P3Md3lgDm251VwwjIdAXx52XzxCJojs2Rfhyz6enwQb93OEmZt22g7IWYudFh5tY7rofVWobuwIT9OBT5GDMYuYpUveNk7a8p64V9S3EZSLWaQvOR637VrzSzz4wFd7MUFPlGwXKJw9bdm9FqhU4Mix/HdbjgtemYU7bCH5rG5G1eIQnJKfe3ICwVpB/gHpjk/f84cE8gYfxsEwzbQi0n7k3qY7SN9Qe4A85UUZCNujUWMlr8o9XdITX6rF8dz4ScR5VO9I0NHz7mwtngLwx0kowBpZ0a29g8ZKTabGUdUJOswj7kkSz3rdbo+B+RBkK8BBN38uRbVhN2Ht9keHdTvgU1gU/dnMDsOUu6E5vu8b7uZelY1f7HQh/xTgKwW/chbFOllC0hSMIcAlP/tE7XacQRY833Bky1TBxqnWZzXDWj9ifmNbVwoJF6PmOVfw4D96ZjEGMJaf7BDjliFGOghO6t56F6bSXJDbeW+pBAlQDuCXzl9j75SzPQy5p+xBNXmGiOIEJpb4bEJJ31l3wshglgoX3GjFrUHwJBnlTqZUHrZLF2ZE+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(71200400001)(6916009)(91956017)(1076003)(83380400001)(86362001)(53546011)(6486002)(122000001)(8676002)(33716001)(44832011)(66556008)(54906003)(76116006)(186003)(66946007)(66446008)(508600001)(8936002)(6512007)(64756008)(316002)(4326008)(66476007)(38070700005)(5660300002)(6506007)(38100700002)(2906002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?166FfGXSSKQJUsBTDGAR02OyXk0LcIrYJdrKFicpad+6S38DteS677c/VFuL?=
 =?us-ascii?Q?rx8EDLGGGoeFWg1QpHDn85veoOxNauaicvR4bCMCMtg9dOLlNb3mTnI1OUWB?=
 =?us-ascii?Q?BFubp54VfWM43zM67UbcEcE++BKJsHeORmrWVTZMoqcaEGutrNbh2opMSJNs?=
 =?us-ascii?Q?4JYfs/34ISV5RBss/hrtDsXn/F0vn7/f2yUFnTNXSH4HEWTXykNdF7xrwqxF?=
 =?us-ascii?Q?EjkB67f/1yHf2d6sYhFF8Kbrzj2ulVhRfu2RswLRtcQzcB4nvrV1tSH+NS0p?=
 =?us-ascii?Q?1DJ5qoSavA9B4yzPpvpndsaHvg8Gx0cvRaeJU94QeSZlMQT6DIewm0kMADYE?=
 =?us-ascii?Q?gkg1JE0At2LrYwuA7pQEEcwJGNb0zV6Z17lZFdr8ucFWtQiIuLLJJH/rE8/X?=
 =?us-ascii?Q?kwbtyuov5QNiIMHbUEBNA5tLVY/tg5L7XbR1a0JYNkKlTNqyrV0Xh4kenZ6h?=
 =?us-ascii?Q?scfPjox44YRQ/Wv35ilt/adV9ALS+E5nQ3VUgVxXJdIaQK2y7ynY1lzyTX8t?=
 =?us-ascii?Q?NMhNfhjJjmQjDCyWa0HLcV1NYwMpogLOO9/pGFMfROev4R3cmAYnu5PMud0W?=
 =?us-ascii?Q?bopsCxpmHvzivgH/+eWxmLFbE44O+pPJypMIMSQ3N2U8/ar/a3tFMcVVY1UO?=
 =?us-ascii?Q?w/3+CHSDY/UNQjlz++cPxH9Q4PYAYO4n026vMkipgK0LK7qQfEAASFJyLjk4?=
 =?us-ascii?Q?9ClIh73oBI3MuWMDABZkHR/aEZpKLvwr+ba9w85/a928LZnpMxj4wgBwyhBs?=
 =?us-ascii?Q?Ss+ggUXRqZPbqPwiFd5THlJ7FeFk+bL9oQXLyble6WoaHI743R2qOF7658Ed?=
 =?us-ascii?Q?lJlpr+n5HGaJz2wJNBAvGzzhnwkejQXJ9J6JWPRghSKhjpu+K4MsAFLoTzqG?=
 =?us-ascii?Q?8L3TI7qeSXugp8ZlStQ4Pd15/3NpeL2/s5R04gcl4tzVo7dakq1lso2QioOY?=
 =?us-ascii?Q?Dqcm5f53lXvMYPkX77rUrF7lnNiq96wo4Nxcf+xCEiaKL+3/sXU/NYUeDbfl?=
 =?us-ascii?Q?OptLe3EqjlOR8aahKfO40Qaw5QJT5M2UcX6Zz+0HumId48ZM/6nj4L1hhqiP?=
 =?us-ascii?Q?GhPt2d5Jmkkj3oBLcrSPWCKU24Jtw0UAYmgNbRyLb7k74O7CyEhy9GUDp1b9?=
 =?us-ascii?Q?A8ZFMHvEWORT32P77I1H58hO0Yw7z3H8wZ5ocSgzZprlUJxv1Zdtqh7IHNBC?=
 =?us-ascii?Q?LauEti9K63Vy8VTVhoMda5RAoBEkUaAqznYEkCquuZBCFDYdXWWrLBGlZSpc?=
 =?us-ascii?Q?wqjE9fFjIkgrSubFOK8BJgOkTRIf7/3BAqWgx8LW38ACyDenIF8RIHDjyl1K?=
 =?us-ascii?Q?azXHgMETBQDvVSnmCiycWX877IqrqlT5unRqFybledBTHWaBhQsZAU6FKYN/?=
 =?us-ascii?Q?VKS/HxrzTaY8bNTchkIcD3nGU2DBnD9WT9zWDEZyAvCFChi5I4J7tYZFCOcw?=
 =?us-ascii?Q?bt/QkPyclbV3MqX6bSdLCOsJ2QyEGOkq9tM9i6Q4c9a10JqbHMOpVBJMvIc9?=
 =?us-ascii?Q?b765PH5N1WtK+TcDYYxrUzLzQqaNjF2meB9z8Rqh6Wq2xPoKVUDtiooe65Lj?=
 =?us-ascii?Q?cmME27HlnHJaMrbuE+RQVCSJWJvGU1X6R6FFQHkrQA+ugx3bzCNiQ5FaSZSY?=
 =?us-ascii?Q?faSK8EPOyF+ofoTJYpe6oNkzNr2rei3mQmixCzvCAIpF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <58BB08BAB3A75441821FC6A14F977D5A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce2a91a-d97a-4597-67ef-08d999826301
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 19:45:53.4301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eRGhNelvmo0FUwI6sr9Xa2U9XQQ2AyqltQuOdVQILbxLdaHB427qxPSrI+1LNb9G/3KBwtLZoHyBFakj27R11A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:28:12PM +0300, Nikolay Aleksandrov wrote:
> On 27/10/2021 19:21, Vladimir Oltean wrote:
> > br_vlan_replay() needs this, and we're preparing to move it to
> > br_switchdev.c, which will be compiled regardless of whether or not
> > CONFIG_BRIDGE_VLAN_FILTERING is enabled.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/bridge/br_private.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >=20
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 3c9327628060..cc31c3fe1e02 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -1708,6 +1708,11 @@ static inline bool br_vlan_can_enter_range(const=
 struct net_bridge_vlan *v_curr,
> >  	return true;
> >  }
> > =20
> > +static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 p=
vid)
> > +{
> > +	return 0;
> > +}
> > +
> >  static inline int br_vlan_replay(struct net_device *br_dev,
> >  				 struct net_device *dev, const void *ctx,
> >  				 bool adding, struct notifier_block *nb,
> >=20
>=20
> hm, shouldn't the vlan replay be a shim if bridge vlans are not defined?
> I.e. shouldn't this rather be turned into br_vlan_replay's shim?
>=20
> TBH, I haven't looked into the details just wonder why we would compile a=
ll that vlan
> code if bridge vlan filtering is not enabled.

The main reason is that I would like to avoid #ifdef if possible. If you
have a strong opinion otherwise I can follow suit.=
