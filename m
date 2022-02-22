Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B544C0017
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiBVR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiBVR1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:27:02 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80087.outbound.protection.outlook.com [40.107.8.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435C11400F
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:26:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+yPZZ7fmfsHNiWJT+hgyXMIGjBY+UYkbAbc9pUOFq7kQV8leEbCxdSOH9wiL0PvUE/N+Jea3NETV7yOdrYbcCk8+T+siMNW6DAOJEJltNqDeK1s8hFSALxWd6WXGG1n1Am2QL6cHunZCZlatAIc1QILQBHlWXu4hY0lSf4VX+yYJx9UmyT8C3EtGdRtaZRQ0jgVEc3tSF//tJ5UNr0rdT4BEedInGVao0JBu1cfCU2FNBK+7KiJc+Ah7CPMVJxCGbTcl/qowEUgxdIvELsEfLxE5sAR45cOc7EwIBRd6Gddk/xMO+4fJYxZbwLicb0FVBkrMufdOItqE0jJvdlCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dN4JW5/eFzmJcW5swqkeslGO4dakJQ0oR83SRi5385M=;
 b=m6Of+MwpkNsGH5n70YYHhx5RMix0BCVr3ng5FCJq9R9HtD9C0Eqd4BP1+z8/CeS9DDhzbRGmsPzBte5hxojy+EeJ0bGHzW/xIKnGTtPTQBBDMOAdyXvEytf54v2DJDXqrSx9N0K9yGMpSktY+Sk9KtMuaQ0rXviEzGDlrjMQbk9IUufcVRQRcjkcjAe6eWmxZZAwWO7WfUQwPjOGpjZimu8JLj2CnbFeFgM8lZJtwFNG6j0+1nH2o9uLbDq0YeiQlk9GrJImgJNBTc6moCUnel2wQH6z5vE3ZEvpNy0U31b5FQflyeuf/dh+plQL7uZvuCMI1ndecU46y39Kcck2gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dN4JW5/eFzmJcW5swqkeslGO4dakJQ0oR83SRi5385M=;
 b=U4f36bVMgn4sIjH/gvw+A1UYsSn0YxJkVngh9+RaLZSiO7LaxF8wlwIYZGtyvYSCa33BdTnxU0ot6khlS/ghanEd/KD4hyBJb/e6tlg8P22i3z4slE6ulflsje25wec2FqjQG8IuCe0Cblf156FFGz9S56wI/HqRAXL7hjS0oSQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8284.eurprd04.prod.outlook.com (2603:10a6:10:25e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 17:26:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 22 Feb 2022
 17:26:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "danieller@nvidia.com" <danieller@nvidia.com>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>
Subject: Re: [PATCH net-next 02/12] mlxsw: spectrum_span: Ignore VLAN entries
 not used by the bridge in mirroring
Thread-Topic: [PATCH net-next 02/12] mlxsw: spectrum_span: Ignore VLAN entries
 not used by the bridge in mirroring
Thread-Index: AQHYKBAcw2fJIHmjVkGX4NEnj43TDKyf0ooA
Date:   Tue, 22 Feb 2022 17:26:32 +0000
Message-ID: <20220222172632.ohyamkkiztspp5zl@skbuf>
References: <20220222171703.499645-1-idosch@nvidia.com>
 <20220222171703.499645-3-idosch@nvidia.com>
In-Reply-To: <20220222171703.499645-3-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f525f06-b828-4c99-7e0a-08d9f6287859
x-ms-traffictypediagnostic: DB9PR04MB8284:EE_
x-microsoft-antispam-prvs: <DB9PR04MB8284D3A4B91620168836DF4FE03B9@DB9PR04MB8284.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mT3S5gmhDmdXpIekwy9jb3YOnBnf1Y8/5c1bT2Z24ZqzujzBeBGHY0j8/rmisnYPcybmvI1CsOSrCcIZgjgx1dQwVSGxnGuK+61lLxwAeRIyJu9o9RgK685OgVGzimV5uHj545w1U6uf8wFm5MD0KI//qhQHZ3o53hQlsOfhqhFt0vTSAn8AnsLoaY7GrZklaMFOywqpJiHGKAiuAW7ptd6EuoV4G01ZDAZPKm3VCJ4KAPV8PYm2OPE64CVQzK/58dTeUBB4BMldoVeQm3p549kOyVfQObhgD9Nj31xTNPRbO/NF9O1Y+Q3XJbUrCKGiAgtItHBGzHNZj8d89Ge1rqckoN9C1Y2KbrbGNMAdmqPArYgh5xK4cSuxc+cHBH4F7Es4Nf8+rNvwRnGcSjlLG+SGbf9zYLgvfBwn18t5Ga3jjWJlnyGf8w3/npVZ0gPTmHu1xNbARNLHq1dcJKL0ZO9RDqtL3Bsz1HlMtUr1eesW/890WlL2W6VgymGbBdCId8AYsp3YK/DudadYOTE3sjLE5t9tO9Pb1Xb3bq9hfOvINPyoH/Tt80eXCXYRxJ0o+m/AWK+HcMGQ4eaetZPEwv9oWKwutBnZsT+6qEDf+Evc4xcVj6CezJT85PKaLP98wRW7AdAa4MRtRN7db/lO9IO6kfleSuXb2aCYIY0eujhKEebb317oFLBraLL2W1dNgSaejoRoAp2eT3K9qYXk2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(316002)(6916009)(508600001)(38100700002)(54906003)(6486002)(44832011)(83380400001)(38070700005)(2906002)(66556008)(66476007)(66446008)(64756008)(71200400001)(4326008)(8676002)(76116006)(66946007)(86362001)(6512007)(6506007)(8936002)(33716001)(9686003)(1076003)(186003)(26005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?edUdLtgzI+C8znerYI3pG2yBawCd/pBtyW6Xwi4it3CwVOkrYZRceQSEcccK?=
 =?us-ascii?Q?EQZdO0I4wDDV3XqRycAJwhVAle56o7UikrtzUspXLk/twkwvP0NbGe6ZxSQS?=
 =?us-ascii?Q?nz67BB3zGPdUrM63gWcWcLHaPR1t5uf15k94UATJT5S3y4H1oPa0pa733F50?=
 =?us-ascii?Q?sskPOrf3Zet81UrgvI3qrz9A+eHWLRPS6dcWcOO5qyjhFtODSWq+nYRKtoAH?=
 =?us-ascii?Q?O9jt8/pekEXuHBVTBEzkcPzgTLe9drft6koaPjp5kbtzAVDKv+mtvOmevrEd?=
 =?us-ascii?Q?RrcGFDOG3FiO4rT7FN/APfmm4MkUZMMoYqAmgoYgjtQGrBccZgUne99hmVFh?=
 =?us-ascii?Q?dvYEnTk7UV4B19VtXI7k/s+c/OYUxS6G4Ux7nt91J6qHHlIYWFMgIAlF4CcS?=
 =?us-ascii?Q?1suM+T4vKs3bwrcOBQTXVi7Op0ViDu0lbiZuxECohK+7qs27fUhgSDLtTPvr?=
 =?us-ascii?Q?6NcvfSTwBbVTdATiPVxgeW+HKMbC4IE2DwOsufijsLLY4+3MsnT/O+PuLs1W?=
 =?us-ascii?Q?iiF+Iwb+bD8ZVc/WJrc1G8U6WLE+jycxKFch6hjUVWIFXr3mSUYeupJP08jJ?=
 =?us-ascii?Q?AR8mzsIlx7N7KQ8LF4//SZd7+9p0s5jJN3cRgDnP//XwJJUO8uzjmdEpHp4M?=
 =?us-ascii?Q?qlxvM5hlGD4nBuS+BLGk95YLkhy/T3n8TvPT4Dqw3MQP/uaPkkhw1ubdz9kq?=
 =?us-ascii?Q?dy62/Jk53UamjVtOVM4+VuilRVtmy5wnzskaJxJ5LYJ6IYkfgzSf1+F0QDzr?=
 =?us-ascii?Q?rYyWKf1LrYeDP09nb48aMTXR0lDXoPaS/Ss550EgiqXoBq7RJAKQxDaeNCwh?=
 =?us-ascii?Q?D8E0MdcasJ+lETIk4SJOkT9/vUfymzElLONpiIWPkU6MOQ5G7dvLlNocp491?=
 =?us-ascii?Q?MaGUeSLuhHjTT7hBMI46YEt0oECfQmUNenxCafzQJyWrzuFEtFb5+GcqSCxM?=
 =?us-ascii?Q?bPUjBCQS23+fgSMiaZZLol7uCl11U9/uiadGEV3oNQRdkH0elijxrVlSoj8Y?=
 =?us-ascii?Q?NXD1XUnvAug7LaIN5Byl76DIXS3plqdaFcIS4fvT2W7oJ1UQ0v2xayReCQpf?=
 =?us-ascii?Q?Fj4j4bX4x8kHHDBhQM27LkIjRH7s92Ab1Ov3KQlEXu4TWhaCVBhVh93Rp2IT?=
 =?us-ascii?Q?B3Tcebh4jTAikVdVBizdDRLRZiB+UMOKOcZg2VyRmLdm+dIo0SnZK6MxRwYt?=
 =?us-ascii?Q?Ty8qZ5q3cASqib4H6NblrbMlpBRQJYPjZeGp5bhIv6St3rY1/KsWWRY4kNMT?=
 =?us-ascii?Q?mzvAndNFqaQp2PIh08V38iSu/LnQjvbUxk+nBYPQXxJp4xQ5LF4unGFkY6gQ?=
 =?us-ascii?Q?XWiud0ZeC1Zebl9Fr+oF6hsERcAS7bf04tITsjDM+4vMBIQYSSS+j45v7CTR?=
 =?us-ascii?Q?lLqQhY6o+Fye28QjfMAP6VD7GI8gz/e7+SVDwT8yStgoXIGxsXm5VldEfDKT?=
 =?us-ascii?Q?byLfDsfHWcjzr4eYPganweTX6lhvrF/UICR8THqbtrVqtt+Jk+8hBN4CJurN?=
 =?us-ascii?Q?s7iEprnl2JCZgNYVrG0I4FUQuXX4pn9YD2myIN8ensPUZ1uITgN+WlksgySQ?=
 =?us-ascii?Q?NnJeooOreR6O7uR8V++HaGj2LULn/F0Jd+6O4sSKdshYurt4EEVuMLvgn+54?=
 =?us-ascii?Q?+05VDwF3z0PlkMTfJJ747gA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCA3C908B6043A4BBB713E6D6116CD8D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f525f06-b828-4c99-7e0a-08d9f6287859
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 17:26:32.6329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3aah/31f9+f5brX/r43434SYzikVeZ3uQrxVv9zQR4Yp9aqH7MXqX13Hrkkcf3+Eglp2Y8jTBr+fWJphGvvreg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8284
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 07:16:53PM +0200, Ido Schimmel wrote:
> Only VLAN entries installed on the bridge device itself should be
> considered when checking whether a packet with a specific VLAN can be
> mirrored via a bridge device. VLAN entries only used to keep context
> (i.e., entries with 'BRIDGE_VLAN_INFO_BRENTRY' unset) should be ignored.
>=20
> Fix this by preventing mirroring when the VLAN entry does not have the
> 'BRIDGE_VLAN_INFO_BRENTRY' flag set.
>=20
> Fixes: ddaff5047003 ("mlxsw: spectrum: remove guards against !BRIDGE_VLAN=
_INFO_BRENTRY")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---

Sorry, I didn't realize br_vlan_get_info() doesn't have a
br_vlan_should_use() check. Maybe we should add it, for the same
consideration that a !BRENTRY master VLAN is still a data structure
private to the bridge, that shouldn't be revealed to other modules?

Anyway, this works too.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/driver=
s/net/ethernet/mellanox/mlxsw/spectrum_span.c
> index 5459490c7790..b73466470f75 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
> @@ -269,7 +269,8 @@ mlxsw_sp_span_entry_bridge_8021q(const struct net_dev=
ice *br_dev,
> =20
>  	if (!vid && WARN_ON(br_vlan_get_pvid(br_dev, &vid)))
>  		return NULL;
> -	if (!vid || br_vlan_get_info(br_dev, vid, &vinfo))
> +	if (!vid || br_vlan_get_info(br_dev, vid, &vinfo) ||
> +	    !(vinfo.flags & BRIDGE_VLAN_INFO_BRENTRY))
>  		return NULL;
> =20
>  	edev =3D br_fdb_find_port(br_dev, dmac, vid);
> --=20
> 2.33.1
>=
