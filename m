Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5DB5E85F7
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 00:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiIWWmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 18:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiIWWmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 18:42:07 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460151401F
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 15:42:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0KcQsLd9BvpHWtTeHZ4zuhK1nnAJJjnUYDFXcHZm9bzkxCnTkvavGmbCvlXDYfV694MlhGas8DPoy03dgera4w+5TrLi2tK6fQMiaTHC7KdDsWXz/1aYMBcI4Zvrw17Dvg5xYfeIG9WTQRYWMlATCZmgjNW6SXfdMJ5MM7nbtUJz46KsnHKUJoYg3Vd/zNztKLdikTtQaS1z7BJDTg4z+SwA/Wi9IVKWFFbS8eu/G67IBJMmNcv98q6CVZe21Xh8c3BwSoCh/nKrRUcpCMeYC8sh6ZEaTmnVrkUPCSySvj8rIwUNmj3DDo1NBHOyeQNx34s4pwP1apJInAPOwKKRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a61XtNp2N6pKhphuHfbMIZMh8L6sBBV8AFH1gfeKZBg=;
 b=hKb0p40M2T4SY5dUPmPC8mZV+56+zuWGPtTzdcB6zzTM9pvdR9bGuAb0nXYZlimwnwjYAcibEj0o6pKHPyTrPDxun7WScOJXeDILttxwYiQ8fv27uVbZa11IMzYWKuZnbThQYOGpmlOLBPf0r7gspmM5YExTtNAxukhJjxjj+/ym5FAf6F3RJ7fJzF6gjeXYwQAyiB+5JPpWnwUiBVHG9MStrRFQsAxa+XcvO6KORM5ARNrjqIIqqMJPm/AQ3R+1IapHgpvzEO7KsbJTgw9kze8+QTL0Wiy/ooyZSsVBDiZ0lo8+gck7R4IEteNu62btvkwu3y6B2JSuDB9SFGWOdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a61XtNp2N6pKhphuHfbMIZMh8L6sBBV8AFH1gfeKZBg=;
 b=EIk99ChsbItk1cN8l5vzIv16pEIPak0a9IZf7t/ZvWdbkEgStzQq6RpalTlvrTmLHE7HEvItPCpB6exjr/TSs56kQoB2A+DRCYp9KkczpKmM3vdEZbxy8/2f1ZZ66531dZBMc6tI5avB9H1zlLwPDi37oXnpLl7taQ/LGHZehRQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7500.eurprd04.prod.outlook.com (2603:10a6:10:1f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Fri, 23 Sep
 2022 22:42:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 22:42:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
Thread-Topic: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
Thread-Index: AQHYzqz2VzoSaXDqfEqO+NZLedBiNw==
Date:   Fri, 23 Sep 2022 22:42:02 +0000
Message-ID: <20220923224201.pf7slosr5yag5iac@skbuf>
References: <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
In-Reply-To: <20220922175821.4184622-9-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBBPR04MB7500:EE_
x-ms-office365-filtering-correlation-id: f6bedd48-44c5-4918-f1f3-08da9db4d561
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TbO5x0IVajKAU92fmMrC9JBu+Dla9ICckCtaSKQm0UcnUjPsx4v2xRcytNWcGBc8EfvLG3p5bnCAymYxjaKGJ2oc4pc5LX5ZKKloUSPU60xezthqA3Gmp6vN4oX1tbZIycbC76qmWemql+8K6oQcWMUkYxy0FULMbbv1QULnzKYdNnzxs84vy1zddntDhJGmp2LUjrrNvdbsCwU+4KZmV/dMQoeMktsOo7cinLqEdyM1awaX7cqARncOghaatjQHDxKg4olGtL+TdMPNv43577tGbK8pv2wPfOz2mfvfWQzRy+p2ulpG5gZYr/ATtKVayp43JfWuZeG0/h4jw2gSVo3CwRec+mpu0+aMWDIsJVWVUeCCTVlzxgHbf4oN4LfZzYClfef0sKKj/n7Y7h+yonWH6ObWfZGQ5UfE9aaeqPCr9k7voL1VH2dCyTnRFOnw+ItO12iWaNZCI8N4hCuaZ/ern7QjrjNRsOafTZmQUd/Mc8vKP48p/16OvWNv34OdEL1nO41irptkRXXxFfNyMmkjPe+sTXOfoJc5bMU1fuqf0WlywG7Fa1r25XRwY+zZhUw+kPJwNwIBqcDDRR41nJD8zRQdYgUdsnG0xL4Fb21inYxsZMQIiAnOLgXAaW2wxl99sX60r7e2ezUxCKvzy9fVoEVJGwV4QwaD7/pt6y+T+gkVHkHCTC/ofb2glQlagtWZdmYRaKC5uWZK0nfLGhkZdpqt314/CoQncntHGuyTtAfULVJ6J4SabKLyrH6ieP3YTb/adGmv1gLDfV/axR900i6fCkOczCT19JkQJag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199015)(4326008)(66946007)(76116006)(91956017)(64756008)(66446008)(8936002)(316002)(54906003)(8676002)(41300700001)(6506007)(2906002)(44832011)(9686003)(26005)(478600001)(71200400001)(5660300002)(6512007)(6486002)(86362001)(186003)(1076003)(66556008)(66476007)(6916009)(38070700005)(83380400001)(122000001)(33716001)(38100700002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YKVrt0RAyy97qNv9tFQPJeL13mb9CJTpZRu98UIJGUkGawv25m3PJ1fj1vo8?=
 =?us-ascii?Q?2sD9g3zSO7jg0ha9agfuYE+jxfv0r6CT3ct2MmIb1Hz3661yyghdv0hOpYOg?=
 =?us-ascii?Q?8VhBEqQiDolseRKLcGMPksUlpnxBxNuh7VnMUvIPiQrLdiZD/8YJRe63USun?=
 =?us-ascii?Q?7E05RqN5ijiAY+IdIGhc9nl9s+niOB3ST5Bsej88utOcJ+aE8uaB1ySs+oVv?=
 =?us-ascii?Q?IeTYxxOj9HW8qy/b4YTpNNDA/MIJQD2YqAe88i28YKWgjLvZBbIYF4aVtkoz?=
 =?us-ascii?Q?acdBp0q2f5nJWE3XkIXoSffnlYKgnZ1B3dL0obNeIba9GAd/6fqDyCy1Pw/3?=
 =?us-ascii?Q?93Y3mmT6pdXG26Wco5mQ8L2ZSnf+pUadp8+a7TxNVNnDv7Tt0hcodyUdu9R+?=
 =?us-ascii?Q?lMliQ8FydH50T99YXgbZHI5Slcs9r1hEdoRljazbwy2bclI5p2RMzDxCw9xm?=
 =?us-ascii?Q?5pXjvc7AAwa8NbTlQK2yf4naIYs/+1Igek4MApwT5SaUCIcJcfnDwdP4/vsT?=
 =?us-ascii?Q?kL9wonK0uCcf9SlovDm34Y3PC5SW38B/SSPW0GRa3Zef3yMkDNNOis0YG4fr?=
 =?us-ascii?Q?FRGUGqDMdCBhED96oAovqulYau0Bv2ajvNvpk87FxFuY3dgWN8pOjxVaOGlb?=
 =?us-ascii?Q?UHlfKeovgiSujPUoqweiEnhgH/pHx8wj8L1dQDxw5JJ1qq99iMdj4y/uQtik?=
 =?us-ascii?Q?lbnXX1jQLuzoVZsTpCnj/E9YmMKxaRJXHhztK6QKtKm1BsGg5RoZUtZFJLI4?=
 =?us-ascii?Q?ncBqVGWLnX36Oz0Sl6Hgjalnfr87Gx2IhBoejqjFHurUHOFl12aP4fyYJPIA?=
 =?us-ascii?Q?Z6cw+imcbNrlHfug1PSik1P3+thuQiy0SYbC9NDtsctLHZDC+t8CM7kSu896?=
 =?us-ascii?Q?XmEUwraspDrG/M0Zy7oXXfJaYLzo/xGa4VmyM/QVqtI9UHhe/lOWopMTkcAT?=
 =?us-ascii?Q?JMqTVsJyx3Vx9397qFqZvKt/ym8QlYEo/jUM4KVx6Lhwr2dwMnzWJsDiYGHL?=
 =?us-ascii?Q?UQ5cLZWL3X9ukjwY8L3yCRH87W/P2Iyb3Tlt2yAu2XBM52JFf5xRqV8PRpDg?=
 =?us-ascii?Q?5yrlzjemwEyQ5YCqOucJfcLlBC1jx1rf8WoqT7EYFl2nWRVmhgAmGG0DXRWe?=
 =?us-ascii?Q?6+f0tuUetDQZV5iGbA0V1Tpe0Jm+jCkJ5/sdOGOwE0HSCY8SNlREop3T1lGH?=
 =?us-ascii?Q?aGUXNX0Z9/0+kdMDeVIEXCwKoU3xArbQQPZAc+07adNPMEKGKvAe3vVvGFBO?=
 =?us-ascii?Q?EQORv2mcfALnprnahhFgSNnbbAhytugdFeeJyW7Ak/mWWvliQ6f4u1VI7GfD?=
 =?us-ascii?Q?Jzy8o+/kUOXM7+x2B1VgBaWNGFeXz/c3OI/C/4IgQ0g06OFLBo8S6NaHOyFY?=
 =?us-ascii?Q?xSJb+DNWSAlEUGk57I3e7wmLQzF4dQQGYL6bFfPkJShgIlXFAxXlnjUONbDJ?=
 =?us-ascii?Q?Es3WxpRHy73zl81+hWY9JXpsYa0XmTqPJoT6UELPtkKBrL+lKk+NaOMSdL31?=
 =?us-ascii?Q?g77glFGJ/MWoqfRjPGgoaeCJaJDmxsMmfuMmR9YL4Rj+s2/Vjg+2b8916y7O?=
 =?us-ascii?Q?SH3cDZALEjVM3Ij37ZG6bbN3/zlToRI12A/ueYRKgnRqF3Dlc1Kvpa+5+RYV?=
 =?us-ascii?Q?Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7BEC45E0B837FF4CA927D14E164CDB1A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bedd48-44c5-4918-f1f3-08da9db4d561
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 22:42:02.5361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J2XVrPE3MRfPz2pqtIJ5QiM+Ic3bXCpaE5H5DsDq/nYaOKIeTxchXHfdBmMZ6N+a7huH024S4HNb83Z08hr96w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7500
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 07:58:19PM +0200, Andrew Lunn wrote:
> The code which decodes the frame and signals the complete can detect
> error within the reply, such as fields have unexpected values. Pass an
> error code between the completer and the function waiting on the
> complete. This simplifies the error handling, since all errors are
> combined into one place.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2:
>=20
> Remove EPROTO if the sequence numbers don't match, drop the reply
> ---
> @@ -1439,6 +1400,7 @@ static void qca8k_mib_autocast_handler(struct dsa_s=
witch *ds, struct sk_buff *sk
>  	const struct qca8k_mib_desc *mib;
>  	struct mib_ethhdr *mib_ethhdr;
>  	int i, mib_len, offset =3D 0;
> +	int err =3D 0;
>  	u64 *data;
>  	u8 port;
> =20
> @@ -1449,8 +1411,10 @@ static void qca8k_mib_autocast_handler(struct dsa_=
switch *ds, struct sk_buff *sk
>  	 * parse only the requested one.
>  	 */
>  	port =3D FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
> -	if (port !=3D mib_eth_data->req_port)
> +	if (port !=3D mib_eth_data->req_port) {
> +		err =3D -EPROTO;
>  		goto exit;
> +	}
> =20
>  	data =3D mib_eth_data->data;
> =20
> @@ -1479,7 +1443,7 @@ static void qca8k_mib_autocast_handler(struct dsa_s=
witch *ds, struct sk_buff *sk
>  exit:
>  	/* Complete on receiving all the mib packet */
>  	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
> -		dsa_inband_complete(&mib_eth_data->inband);
> +		dsa_inband_complete(&mib_eth_data->inband, err);
>  }

My understanding of the autocast function (I could be wrong) is that
it's essentially one request with 10 (or how many ports there are)
responses. At least this is what the code appears to handle.

I don't think you can say "if port isn't the requested port =3D> set err
to -EPROTO". Because this will make dsa_inband_wait_for_completion() see
as a return code -EPROTO whenever the requested port was anything except
for the last port for which the switch had something to autocast. Which
is probably the last port.=
