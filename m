Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1472F4B6838
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 10:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiBOJyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 04:54:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiBOJyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 04:54:19 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA60510A7FB
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 01:54:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbNwVXlU1EQui5a8EkrpfEQJ/IIOedAAJNnfGNd0OVyLy98/Us2rzfZolWDcKe3Yg3PszagF6K+ZO69POS7fx2081mkxwIzykjP/YBMTik9/Iyj+CxFkeyCrrKi03hnKxBNY3DO0AaGdx7COlGFbL8eS3A/b8OE2JZdJQEbbZ57M6PWZbRHNPl0Mu8WWIHpgIyAzzjdEhZvu/r/PM1MFVMXzjCDGeVN6mCDuWrSSiAtaHX+2+Spfs82VlGK9slJhkt3K0BmRjyd55LXc+xBON+9Gtxdk2XZFZD0FeUwyY5K7m/u6TUCIxOBS0UF8hArsUEdSaRrydFYRlYafOwIJlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XnakcgSt+milQPD2F8f/foOPc0oGhZIF6VroJi9qtE=;
 b=foqjjNnZuF/v1r+YTSl74hCi1A1915kL7kHXm5oN2Y+oqpIkyJMoU285Bx2rMeHVGnyV0M2h0rq2M0GAopi33I4/FjT9lr66gsYuygToKwW8QbXLo0JNhB2lVwRoYc4x6snDcvAkAojMjrh1RCfuPzbgkamuz343RpPjr2CucKY8Nyr7VspEck/zRO8JwML/i+bJK7wBAcgkNZUEleUH7ifAcJgcoEEssJO5kTtZrYVwo9VQ1q3Dsp0jfkAPL4iO2z7CSfyHKO7hOfkpgF6WCasaEWWPATV4naD6HIjT3Po6xfdRSeW0Qmc7P4mpUvxtZa7IIK/NUz3jU9vKtr4WpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XnakcgSt+milQPD2F8f/foOPc0oGhZIF6VroJi9qtE=;
 b=Vk0QbpuwcVp8UeM8uk2Gd3mPlPjhi2KmGuInFQ4YYPqJM2UkwzN9i0zUgwg/O6xnIIEQvWinErdjsOQsQ4wAaJ+cU1J04OV09hr8I/We9yr/3rZsQWYHdAcdfUhavU4k9gadRa2+kuGqMl91xXi95oXL3nv86I9F94N9GMBo6xE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7309.eurprd04.prod.outlook.com (2603:10a6:800:1a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Tue, 15 Feb
 2022 09:54:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 09:54:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Topic: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Thread-Index: AQHYIfsSmRmY0oOnV0uNWER612b7d6yUT04AgAAQq4A=
Date:   Tue, 15 Feb 2022 09:54:06 +0000
Message-ID: <20220215095405.d2cy6rjd2faj3az2@skbuf>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
In-Reply-To: <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fefc6df-6b23-4291-5784-08d9f0691adf
x-ms-traffictypediagnostic: VE1PR04MB7309:EE_
x-microsoft-antispam-prvs: <VE1PR04MB7309543EDF0A478C62972CDBE0349@VE1PR04MB7309.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yeBUForv8Gcr6fEP1t86S1gifAg61YpaGVHswWjGGM/zAiXZC7TApooibBYA/wznm39rXCntwbDp5JUlyATUIuMFHevbog3kXNN3Ezd0eoyJcPDNrFSqS7MkO4DwU8U7AFfZ6AxLgz5u9MtgNopFjGAo5rco6RzzLF5QCIEWZrC7bEr8SyUiH21hrSJ3qMB5BT2It8iePDzFzbv0cqtMGqGtLAYwCOW+B9MzlSiX8MtQmGt2PTO1qZhUwGB0106YG68DheVpESkpTiTv1UxftpObESwNXFaol56GaR1b0OobsM4nUSeYfeTteaMgKHPSejIIQdDRT0AwePvYv1ETKPWlfGB8sHLmXe+9vn0C6YXwa42tZaFDUGP2W2BUenvxTF9nBo0Lf07g6QCE9W8GywQXSh6kIdT+zsw/3xMYFqpM2nvHiDNOKCf/3et1r4pdQXyzZ71UUNQVdiPo6CQ3v1D17LRS2yZf/ntLCciGzTiy/ihOUtselk6ZhRIupO5rYY/E4eaAnadlx9r6pN5zWZ+0CGD+NdWS+LKBGySg9HpSDxAMrnT1X7kVmPgXjOtk4YFI18xGV7Pwf0cKjiay9AUdDrTEJqi5loX06VnT5ZU/4uFvjH+6CFQQhlsQyFyDTyWNN3U3RZULpIJKE6dniWfvoZOI5Mkw4sG9wy5c2nTGcYhKoBeGshNvfph2ZM2BYiz4+NfGudwdq1EHikwJEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(76116006)(66556008)(66446008)(86362001)(64756008)(66476007)(44832011)(91956017)(1076003)(2906002)(66946007)(83380400001)(4326008)(8676002)(8936002)(7416002)(5660300002)(6506007)(6512007)(9686003)(71200400001)(316002)(186003)(54906003)(508600001)(38100700002)(33716001)(26005)(38070700005)(6486002)(6916009)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CreIdtz4mR9LIHM4YUFThgtl15iX2A3zIllZLoQdIkXRbbIQhw8WvaHcAtCp?=
 =?us-ascii?Q?MBtyUptyhcAJJFT90thSO3FOeNGokXYPXUznl8aME/hh5WxiFcH4AIBi7+Bb?=
 =?us-ascii?Q?itoF9Ouwto1/+DtMhuhVwNjR2AvHhTi+BBIkVcQNGD70Mu5/4rWQ5u/jM000?=
 =?us-ascii?Q?YJ8CZNFJDcnOyvrdQ45GbGl9HlDIK1M70QUgwghUapE+SC9KnIdCG/FlRgIp?=
 =?us-ascii?Q?FQ9gLD0hWX4XyNb3UowrExClxeHCvxDM2C5oCeoDJ0Zl+SMDaMzy9WSRWG7/?=
 =?us-ascii?Q?nG1Fg53n108ZCQ2A0/wGRewxbfRAOWq6xfwhyNUpg1n1dAE1VsiHBSJV8vcS?=
 =?us-ascii?Q?tKls6RjAUHy3KM1blq58e00e5MtH5lD7fKjyjvqYkVuIO9mQFArROij3LcM9?=
 =?us-ascii?Q?CTUKcQhIuCbdDWD4hb5h6lfmNQZJOAP7IMU0y8PSBMSKpI9RV2Q1kmRMOLlJ?=
 =?us-ascii?Q?uHoS7rH00L5C9MrPUU7kUMbqGq9tGIfXks/HZdHJMHhS3RAPRbivmFrNq90f?=
 =?us-ascii?Q?aUWf3ZrPNoASBwZlWE3GY6dk2Suor6obYX48jDJ0LBF3kXQuDgkiz442gya5?=
 =?us-ascii?Q?4YwUtp2buVdR9u9k9bZL3PZPlZ/wU68hRlWjr5h7JT3eQd3zhw9njaNS4BYO?=
 =?us-ascii?Q?8MXDxkW0mftN+bJahdw7FBD/KPvRLxWuc1I9IUMyAExwlKwZkEg5d+QQ8v96?=
 =?us-ascii?Q?Uvfzhv9mebad9CbsZJIUDcVPeKiznr0TqYoH/+STVRWXJP9bgBNRhuiFG7rV?=
 =?us-ascii?Q?D7Aww0zI506tH0RYUwHrmcKlNvHvucQTvQs2EhkLVpkdfGrBHSLfm6R5a4TB?=
 =?us-ascii?Q?AwbtA0AyQx+w2/VlxYeQGkUKW7m8p43SgQvTBWUymzKW4+2gnzXojgyl7ojP?=
 =?us-ascii?Q?JQdcwLF/FKpIykPk0yLdEHrwEpGnY+7OvD7OIiHzs0qJUFQ5bINJnwv/t4nJ?=
 =?us-ascii?Q?9F1XfrvfPCEkhaVJ33iR/Ehdovk6MNEAVPpk4mZ5eLWDfLH3Dnn73dDWWVLj?=
 =?us-ascii?Q?O45EiRyqORFatCAvnwwZd8BqR0Qo01Hbnyr6PsSb5QoOXD+CbZ9tY4C5DX/1?=
 =?us-ascii?Q?aKxEJ18iygVWZE3LVin2r3zJzDrFUt++Q74/+B+HJW9B8qDgfj2p0Z0tzUoA?=
 =?us-ascii?Q?KPajFwcMgueAduQBTayJ3B0df5XDU1euQ/dOy3wvqjHKeglo4GjcY/tl8Rwq?=
 =?us-ascii?Q?PvJ6IqLMYSrqr35+zYal+hcTXEdyUrfGSDcjYp3JXWLldo9b7/BrQ096OaWG?=
 =?us-ascii?Q?m9cDveIJ2QTQvGt+O7sFuo3pniHBbRagLsuvZAqIMTtKTTmv/PXC7Z9gCT7E?=
 =?us-ascii?Q?MNsShrguR+rGXTLfaz0oKQt8F3yUOOni0bXeQo8+5AXuAxX9T8G/apHPZYeT?=
 =?us-ascii?Q?8kTwnN/kKIKmuLbmvh8X5zyvRYHPAQ5vf3/i4kaYQuOL2yHmFtw8oo+dLtAd?=
 =?us-ascii?Q?U9mF8kwojnMHr3iG5gDJT6fUpi4KDeJigz+b01oYa/AilvNe1foXDdZugOr7?=
 =?us-ascii?Q?ZMtSNGRgCUQhNfzjxXZgvZQqsBizUOVLx0AX4laZnBvDkP6X2EWwlCoCxS8I?=
 =?us-ascii?Q?SrG3HBsJQCjYRitN2iQhIgDavrTPpqDQV5maPJ9uKJgFMSXYLqK3qiHU0ry9?=
 =?us-ascii?Q?Aq6NAM50ajVcnUO6Rcf6iy2AkVz2joszpcAU6+gH/fEB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8507AEF71CB354499C76E18C5BB01726@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fefc6df-6b23-4291-5784-08d9f0691adf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 09:54:06.1619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HcNkr829+bfn/j3AMagBCPbj03Y6dV4xHb5dwvpHhYqNumlj9SqRbsNCULKrSM2Mx/CAqwVqGKPLI2TDnQHfFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
> > +/* return true if anything will change as a result of __vlan_add_flags=
,
> > + * false otherwise
> > + */
> > +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 f=
lags)
> > +{
> > +	struct net_bridge_vlan_group *vg;
> > +	u16 old_flags =3D v->flags;
> > +	bool pvid_changed;
> > =20
> > -	return ret || !!(old_flags ^ v->flags);
> > +	if (br_vlan_is_master(v))
> > +		vg =3D br_vlan_group(v->br);
> > +	else
> > +		vg =3D nbp_vlan_group(v->port);
> > +
> > +	if (flags & BRIDGE_VLAN_INFO_PVID)
> > +		pvid_changed =3D (vg->pvid =3D=3D v->vid);
> > +	else
> > +		pvid_changed =3D (vg->pvid !=3D v->vid);
> > +
> > +	return pvid_changed || !!(old_flags ^ v->flags);
> >  }
>=20
> These two have to depend on each other, otherwise it's error-prone and
> surely in the future someone will forget to update both.
> How about add a "commit" argument to __vlan_add_flags and possibly rename
> it to __vlan_update_flags, then add 2 small helpers like __vlan_update_fl=
ags_precommit
> with commit =3D=3D false and __vlan_update_flags_commit with commit =3D=
=3D true.
> Or some other naming, the point is to always use the same flow and checks
> when updating the flags to make sure people don't forget.

You want to squash __vlan_flags_would_change() and __vlan_add_flags()
into a single function? But "would_change" returns bool, and "add"
returns void.

> > =20
> >  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *b=
r,
> > @@ -672,9 +685,13 @@ static int br_vlan_add_existing(struct net_bridge =
*br,
> >  {
> >  	int err;
> > =20
> > -	err =3D br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack)=
;
> > -	if (err && err !=3D -EOPNOTSUPP)
> > -		return err;
> > +	*changed =3D __vlan_flags_would_change(vlan, flags);
> > +	if (*changed) {
> > +		err =3D br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
> > +						 extack);
> > +		if (err && err !=3D -EOPNOTSUPP)
> > +			return err;
> > +	}
>=20
> You should revert *changed to false in the error path below,
> otherwise we will emit a notification without anything changed
> if the br_vlan_is_brentry(vlan)) { } block errors out.

Ok.=
