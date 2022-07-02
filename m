Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE35640B6
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiGBOaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGBOaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:30:12 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D97E0F3;
        Sat,  2 Jul 2022 07:30:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euMWUg++DEjYR/gXuZJU2OdxjhjHJGJlYHYDG1MEa9qmdANW/vdyHSqlqMhYPLFk7DYd6caBYt/Ue1DTcXep4bqgge4USHX5FX76HJ8jLM9bjs0EOF3H8S+a6Ct+3c54PDzILjWvLgPB2/+cf5KZ7mKJpH92C0c0DGwepeUQBWgEvfHpJY29Fnsgk7dbS0Gl1+s2apc/5VMM9tUWPcTSM+T0k1qTOnLmW6bensXibZTmc1uZISzz9X/ZkqCziTyb1Y0vAew1SQeUwS6k62ELCRIeIK2GpTopqKIgPUy9ro/NIHotNHddBCmc4/zkOjJ6pJNEm1ph/FMS9xfooId8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGfUprUjJK7buPofkHZ1uqsWCJrBVQcmd7nr+JfEyeg=;
 b=J7/r9beQUHgL9bj8ED0b5Jn0IOqRAkj3b+oPsLeHjG1NMSufkbg/JV0SwkxFJ87RbIPMl+z+eap0T/KcbfvIQXsbV8Fyutiiiu6OiI1+4VPVX/nEzroLtABWF069v26xOri0femUmMhSu2iFmqWdhqDsldKkxYEqiU72RujEPkORk8U3gHHuJFn+QXPyNzCCyajJkplXKV27ckGLIg4yb4m43OteQS7nf6DcDrc6zkGb3rqVqp38xgOLrp0M4esPeFWK8RXFW7d+mcczI8LWA2fcFUCbvLtCxBhillTces6gfWznTV8saiPHMoMvF2PMDw0EvlKF0NTDSlgE2qY2VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGfUprUjJK7buPofkHZ1uqsWCJrBVQcmd7nr+JfEyeg=;
 b=NrYusRPE8yxTxHvn1I/RwSoNek5z8LOUl/LzuzN8RidSvw0OvvKcs8wTU66tFkjAGSRJ6zo5FO4cz/jglKd7eaW03qGrn0gs9nUJ6qXRC4Lalmi4XTlv85bR6Gf9201IrNUW4H4z95gvgaS/2bImTMQEAiY3cvFFjBEScftCtek=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4307.eurprd04.prod.outlook.com (2603:10a6:208:5b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Sat, 2 Jul
 2022 14:30:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.017; Sat, 2 Jul 2022
 14:30:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 4/7] net: lan966x: Extend
 lan966x_foreign_bridging_check
Thread-Topic: [PATCH net-next v3 4/7] net: lan966x: Extend
 lan966x_foreign_bridging_check
Thread-Index: AQHYjYwaNmZP2nLTrk+dT9rZlh8t0q1rJVuA
Date:   Sat, 2 Jul 2022 14:30:08 +0000
Message-ID: <20220702143007.wdnup4sapkl2247p@skbuf>
References: <20220701205227.1337160-1-horatiu.vultur@microchip.com>
 <20220701205227.1337160-5-horatiu.vultur@microchip.com>
In-Reply-To: <20220701205227.1337160-5-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bce3b818-94ae-4dbe-b133-08da5c375d2f
x-ms-traffictypediagnostic: AM0PR04MB4307:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A2JOXvaWJ7ivYJi0Y9BlzgJsfJ9MVRY+rGLMK+gjiT1795bLIjQNDCO4ikqn31ACmf0MqFTyaM7joAxMsA6+XIcTJPw9tiHf55vK2CzGONTdFjxCzh3xxg93o+4xdlOhPNcnYDgbgMA1wW2Po56hEF/QqJqVq/47NiL7v84EoJFtTymqeZl2YRJEaLzjXZsRArXWy3LQtav7cqgqBLB85FwQx9ebbb6WB4xfr/oNEpaImqYjytaSSArNQxpt/uT1nM4hcR+YxpQIKxxFJUwfSgfDFENUfdtZfRbSydJKBDNazDOsfDxolt2MQ7hajzfqWciZXCAA6F+73zpfpxe0Jp6phg6W5pIAIz/bogoC77E7qj72AgirRuGzxwBBzunLdcGgNAgpy6pe7DBdqvNx3E0g6opG6P9u1QEJ+Mrek5JBbnAzvLAcnHD67WNRsrixnnX/XqPVq1HZOBh16xrximiqAvq43QWMNMR0tCOwfJ5BkVHLVlSkLj9fL1R8xz4geMoC1E71DA7Gb8abmrJ2o8JlNZFCBMUp7cMdacELrTOh9wIBrH7XXU1GpTg0itxVYJ2EIwwG/RHfvxLIGHFRODXYaGxQO4vvSEuQyxMwdhjsXL1tcZFPZQ7tkEA69JW7/KWugK2FBNharMwTQ1iM6FAU97+f3pIE8H5vcJAMnLNaSjHAwgqqTRUtuUgU/iXmkp8J9QfjBjqdtGvn8gdwALPpyzsn/X2EZ7UOjSbHmYpB0I0xC442hjUeuwdRZ582791rZDenjnezLk92ZA3sgxmvrayVik5oAG4bTzLr1YJfbBDy3dXi6YOmnOU1dq1NjJunv2q8ZMRNj/KvrpS+CYK7ud/moKRtQXU/8pF7NsEEJt5UGNWPGOtCXZxQqEGM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(376002)(396003)(366004)(39860400002)(86362001)(33716001)(38070700005)(122000001)(38100700002)(8936002)(6486002)(478600001)(2906002)(41300700001)(5660300002)(44832011)(316002)(6916009)(54906003)(71200400001)(4326008)(8676002)(91956017)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(186003)(83380400001)(1076003)(26005)(6506007)(9686003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YZqNQO6oxllO4G7LpHEPmT43iLImm7KZ8pWGNlDl6aHfACvXgoDTdmD4eEpB?=
 =?us-ascii?Q?oMqdwlfn9hmVGcOiIAqYHW9s74ssgs8QwiHUQaG3Il03KHoJo6Sw70fzVF50?=
 =?us-ascii?Q?HszWGy4JIg/KpAyRNUTNmN/78iFeylLBSwjQBjsONgQQNJ8emSks9wzdQVnP?=
 =?us-ascii?Q?iLhsTudPjRSvRK7j3XNEoChn4vzyOVKZs9gsB9XAsaQ4KZYttIxuLQaENInw?=
 =?us-ascii?Q?WpciG56b/FH3K8sLtFvr1P8OeBXDObSIUkl6NPYw6o9hcpRo2BbUu9sHU6ia?=
 =?us-ascii?Q?fI9hcz8YBGK31GEUf/cfADIKG2h0myEthIR6vD69buFNlbJj3ElS/EtVsajU?=
 =?us-ascii?Q?sm9BSX72fCA9gEJd9YEu2GCb9AeW8SFZkWrO6lbY0+4tmzZZacJTdQx+Ud1s?=
 =?us-ascii?Q?hRIAcSABdhlNZA0Iob69xiNVkzn32G043bZClrD7na6o3GAzDR0ZBCW7T3JC?=
 =?us-ascii?Q?Ip7aZggAjrHh1FUaIweJUno0lDJW8AMoH4Re7BvYK052u0JC4Yoooidn0Ski?=
 =?us-ascii?Q?o5GWKU4IIwgQdHPpXWkP3FHc9CPfzqGmfcCP2CgMVNdqk5j1pP0p0Qk3+pKr?=
 =?us-ascii?Q?uxqncYcXpOyjcHcTEXdwGz5ebcW0C1HZHxwnyN5U3tOJN69w5YpDi5BFRBtS?=
 =?us-ascii?Q?+/2lyL7Z5z5J+VwGE7ljofcn9LgS2TsfifBlQPFzn8rZSgc2lt3ZJ7ljLDzd?=
 =?us-ascii?Q?+JOGgw29lbfxLxDts8PPujR/UMIqxy2o4yJJtfA2Gq4E+5VaJ1liY/BjBxIv?=
 =?us-ascii?Q?vVVJ/L5OH8rzuJo2RsIvFNt7XRKjYp9+va0RkJ8H/0QCB2E8fSPbeSsownqa?=
 =?us-ascii?Q?dXXTci95MmcOaDK5Bx29/yCJG7axI+EGsa8x/HG6yFY+xvegK39QMcY3P0jw?=
 =?us-ascii?Q?PtE36PpoLgesHfCvRUxMXeliGvIk1oDNgRNf4hKcdppZe0bbToTKFrkGDHyK?=
 =?us-ascii?Q?K41q1x3oPxhhwrlPnCDCfxG8PEkrn+DAEGIFzbryIO5/SS13QdQmG0H8+Q2v?=
 =?us-ascii?Q?Zvn07ZrXiZKtD//Z27LlwQ5bK+NG/R+U9nNvlky6+1k9HnKFuX2jrowcpVzP?=
 =?us-ascii?Q?RnjXmLyoNTUYIryMRaX3JpEPPVUD889a7mZkLZDrOoVWx4oeRntzinHt7Iml?=
 =?us-ascii?Q?hi9mtpdKudRx5j70lvUzFAog45bBArJkGr1pQKSUvS4i9FzMAyOb4QUTIchC?=
 =?us-ascii?Q?An2GeF98myZ7HSlZFdTtzDnf9Y4TEfdXf2HM5K1DvopXLAwsxeQb9RvVtzET?=
 =?us-ascii?Q?FoltKozAR+v1nwG4FFkZJqnKp6W/CdU1INaBMxU7KUaJycxp54gSmgzFK8Vr?=
 =?us-ascii?Q?6R+Dh2MzIA8kT+OhcRSFy37pCgewrCCodHU/iHpSwK455vrflLSVg1aj8MNy?=
 =?us-ascii?Q?5KKramRebXUErfrGgz1imig2LVc3sH3odrfBHOHscqa7I4Z+T8puDIh12KIC?=
 =?us-ascii?Q?r571cPGk0VCMk3vfo9pExeNwEQybwSV03iZuP4uBLjrbgfL8WyeiokYBpmyB?=
 =?us-ascii?Q?2nHq0fddXVg3rueiZXxHB7XV+2kNvTyTX8Bn0u1xRQdoq7l0QIbdfKOdMwSm?=
 =?us-ascii?Q?7m7WqDTRLiEFkS3caTkyqb6QnO3iDrjt21vwH+TYHhdPjIMnbDLV4yCZVWVY?=
 =?us-ascii?Q?Bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CEEDA908B3BF9D48B045C50ADE85AEE3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce3b818-94ae-4dbe-b133-08da5c375d2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 14:30:08.2553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q8ZJE4HsDXrM7AXuJQn3SsqXiOacygrUIN+cVyoFz5ZjDKl2KZz0TUMeUixu2yAQmyEiSlNFC4czTKGaYyHW8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4307
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:52:24PM +0200, Horatiu Vultur wrote:
> Extend lan966x_foreign_bridging_check to check also if the upper
> interface is a lag device. Don't allow a lan966x port to be part of a
> lag if it has foreign interfaces.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../microchip/lan966x/lan966x_switchdev.c     | 32 ++++++++++++++-----
>  1 file changed, 24 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> index d9b3ca5f6214..fe872edfcdca 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -326,23 +326,25 @@ static int lan966x_port_prechangeupper(struct net_d=
evice *dev,
>  	return NOTIFY_DONE;
>  }
> =20
> -static int lan966x_foreign_bridging_check(struct net_device *bridge,
> +static int lan966x_foreign_bridging_check(struct net_device *upper,
> +					  bool *has_foreign,
> +					  bool *seen_lan966x,
>  					  struct netlink_ext_ack *extack)
>  {
>  	struct lan966x *lan966x =3D NULL;
> -	bool has_foreign =3D false;
>  	struct net_device *dev;
>  	struct list_head *iter;
> =20
> -	if (!netif_is_bridge_master(bridge))
> +	if (!netif_is_bridge_master(upper) &&
> +	    !netif_is_lag_master(upper))
>  		return 0;
> =20
> -	netdev_for_each_lower_dev(bridge, dev, iter) {
> +	netdev_for_each_lower_dev(upper, dev, iter) {
>  		if (lan966x_netdevice_check(dev)) {
>  			struct lan966x_port *port =3D netdev_priv(dev);
> =20
>  			if (lan966x) {
> -				/* Bridge already has at least one port of a
> +				/* Upper already has at least one port of a
>  				 * lan966x switch inside it, check that it's
>  				 * the same instance of the driver.
>  				 */
> @@ -353,15 +355,24 @@ static int lan966x_foreign_bridging_check(struct ne=
t_device *bridge,
>  				}
>  			} else {
>  				/* This is the first lan966x port inside this
> -				 * bridge
> +				 * upper device
>  				 */
>  				lan966x =3D port->lan966x;
> +				*seen_lan966x =3D true;
>  			}
> +		} else if (netif_is_lag_master(dev)) {
> +			/* Allow to have bond interfaces that have only lan966x
> +			 * devices
> +			 */
> +			if (lan966x_foreign_bridging_check(dev, has_foreign,
> +							   seen_lan966x,
> +							   extack))
> +				*has_foreign =3D true;

Not clear why you set *has_foreign here and not just stop and return.
The extack has presumably already been populated by the called function,
there is absolutely no need to continue if an error has already been found.

>  		} else {
> -			has_foreign =3D true;
> +			*has_foreign =3D true;
>  		}
> =20
> -		if (lan966x && has_foreign) {
> +		if (*seen_lan966x && *has_foreign) {
>  			NL_SET_ERR_MSG_MOD(extack,
>  					   "Bridging lan966x ports with foreign interfaces disallowed");
>  			return -EINVAL;
> @@ -374,7 +385,12 @@ static int lan966x_foreign_bridging_check(struct net=
_device *bridge,
>  static int lan966x_bridge_check(struct net_device *dev,
>  				struct netdev_notifier_changeupper_info *info)
>  {
> +	bool has_foreign =3D false;
> +	bool seen_lan966x =3D false;
> +
>  	return lan966x_foreign_bridging_check(info->upper_dev,
> +					      &has_foreign,
> +					      &seen_lan966x,
>  					      info->info.extack);
>  }
> =20
> --=20
> 2.33.0
>=
