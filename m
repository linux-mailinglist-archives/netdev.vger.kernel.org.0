Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51D75F8558
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiJHNGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 09:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJHNGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 09:06:45 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150087.outbound.protection.outlook.com [40.107.15.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D746858
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 06:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6g73ODclv0vq3iAQ3Yapgk0f6jSshPRvtbV4YrMpwIuHOv8fA2IcVLSm/ENhIHZ6nrY4kLDTlf4KPuH2AXijYY3dj7vLGzYyR6GFzhnC+bdDFl4w3VcjhwOoXUR0GLmT4VZYkTt2N0L/hacOtwg8Gyii1IkfxXYNIWWw9bc+xVKFCadm3myx3tczGSZMO6a5PQIzSWVIzwISK5aZL8dSHemMU/flQbXB28hWvWtBpTQX6HxQlu8LgNK2vvJRWKH8mrRxIAsybS8L2tYPjBsg9REY/kUEiGWmm3vMtTcO+c6tJQh1AAfEmzR6SlSM9qzABZA2snqFa2FO/mUfIvycA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxUCvME46BEaIYd/BDK/y4sGkBFgVzWgg6VmuFynqWM=;
 b=PuIMzG0MTgB4V228PBgqj7NAT3DvuuLog2U+XRUxO+82UooFriao2ANAOUCBXnkyqyck0RgOG2YBdIr/fN/eMbwb62kO/rprYzcD3PgxZVtYuhzdWBfUgCo6Nn6sGKHPpD3VXZt+ieZeShIcLRX55YW8xOg9IDQg/lgHXVXwkfF2Yc95Ytdq8NNvVFzCH5KkSZAjjJtJdB9rxiEVi2LWtQrzBQBd/XXPQ4vuxFNaN8svneHEkR/0c+nSTi5zUqjvIzyCybkH13ueUNnYI7sza4KEcoIaPw+JzXxsLBhxOXLKszbJu1Xuq5+Ujxa7wQPzrBL7X3Pw91FkEwf78nnW4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxUCvME46BEaIYd/BDK/y4sGkBFgVzWgg6VmuFynqWM=;
 b=HlJtK8osM6J9tjhTUWkEKUB83Ib5W20OsbB4AgCpME6ZGqp2fcra3lOaUvM0AimKbygLmA4OQRVEP/dK2nJ6KImcH+6AMQUWZ+HqZ18/pbWdVX+phQT6PLwQM2nQbJi7nXU/p3L128KrqkZ3dWdV2SKfp0HzoveRM5FIh0FYhcE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8403.eurprd04.prod.outlook.com (2603:10a6:20b:3f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Sat, 8 Oct
 2022 13:06:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Sat, 8 Oct 2022
 13:06:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net] net: dsa: fix wrong pointer passed to PTR_ERR() in
 dsa_port_phylink_create()
Thread-Topic: [PATCH net] net: dsa: fix wrong pointer passed to PTR_ERR() in
 dsa_port_phylink_create()
Thread-Index: AQHY2u86lD2lbmpK50O25eWSy6t/gw==
Date:   Sat, 8 Oct 2022 13:06:40 +0000
Message-ID: <20221008130639.6nhumidbbw5duesd@skbuf>
References: <20221008083942.3244411-1-yangyingliang@huawei.com>
 <20221008083942.3244411-1-yangyingliang@huawei.com>
In-Reply-To: <20221008083942.3244411-1-yangyingliang@huawei.com>
 <20221008083942.3244411-1-yangyingliang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8403:EE_
x-ms-office365-filtering-correlation-id: 1f0151c7-1ce2-4d96-ac42-08daa92df0ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ryijfmtKbpBE9QZgRRW7LXgrDou7ngEuLIJCwbpNfm6ugwHHVf1bNXaUzwL/CCPZOMN/LMZaSrtWgCo3ZiKYZgZlc92T0zGlThFxB2Yd7ZShkkvdmYf5lJH2KM1uz/I3GM29xPTzKjR6qxfRmCtkmNn91jA28Q3/rbuaSqBTe5JqyXD798W+SVfksAZicCtEhh6W7rws6HSZdLeafu5Po/V0qUP/7Cm304wt35oOpILFR0cI7eV3TdW88xw01/ZZp1A6MbQ2yVNjbYsi3NWMx3+hhB2YSwU2TJN38VLE2KDFaN6DljJv3PelFGZXwgrW+MFsDmWZ3xANn3gu5DMw+yRJzK1Qg84Sizqm9+vkaevT1kTHcAal+sKSi8D1Yo9v7JXTrv3aitTnyjG+4z+TFQCwIoAcWyynl+aY8uIFku/YZQwapDA9mP4d7+bwmLlDLjpd6w8ywYJ+zf0+VA+8Fn//nKsfaFgvBCLv0K4ObReMB45zyRNti0HLgA75YyvtnVLwOimPVgha6bO482K+t1kUTjinG9P92RzCS0UYGXuIDRurkW5J1+OKgC3vyr+PG8evLtZ//HI79RRxGkmlYgOfodWLWAOjfnp1R7NUXGqCdrFhDhACtrp3a3IuqHJeVPA4I2c5gkB8Y2i+7Q7QB49dYihHJmGgiFWUVz8yptc7gjGBcZlUvHznuGjEgv/TJqwhK0mtUGFviuKPwkfcFo26Cw/UomWQmSjzbSjjLlIlgn7tjCyjn1tpQvKUlaqrLUqdLFg1fzhQLXf0jT/eg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199015)(71200400001)(2906002)(186003)(1076003)(66446008)(54906003)(6916009)(76116006)(66476007)(66946007)(4326008)(8676002)(316002)(478600001)(41300700001)(6486002)(26005)(5660300002)(4744005)(44832011)(122000001)(6506007)(9686003)(8936002)(6512007)(38100700002)(86362001)(64756008)(66556008)(33716001)(83380400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gWU5d+KZqwA0I0Cn0xzLgIB4IYCCS9lIbYJIRfMuxiPh1aommO1O3uF2b6Lp?=
 =?us-ascii?Q?OmvVuRqiXJKE9WVU9jhuoQZ1LFtvivUfjG/b87yBZ32MrHAOp/1XPjubC6SN?=
 =?us-ascii?Q?u/4PTnRHZh3elVmb7b5UKRvR7LOAbjAEU3eVerOFoXBrEjFAhQeW1zRqbUUU?=
 =?us-ascii?Q?EWP/lkk4rZB3kFxb8A31nVO9D2T+V4Q/BP/nLYQSCzfRRBgHjXA6RGPVri1S?=
 =?us-ascii?Q?U+yBVIAyGSzAxZ/03DuscoiUObwiiQylo6JiUW9KSlP8xZruGFhm+mHuES3l?=
 =?us-ascii?Q?OCzkyZAaA7X99GyAScsHBfXBU0D2JDirhtnFGvRdO7Yhi7J7QfX+nSB0a3ps?=
 =?us-ascii?Q?M0HKTIky01joUK+whctMt9Bt8omGitrGU9UMJFlOWf7puHDctpMRUnuuv/QW?=
 =?us-ascii?Q?/iVw59ag5cNbYicgWoSo1vRCd66a1i2hCOKbHsiYompmZnokTeOWvCgWqFaS?=
 =?us-ascii?Q?FTlIA4XWa6Z3SsGS824XB6qOMMCxfz0EDn/slMfXOxU6oxg45fwAoddB8VxW?=
 =?us-ascii?Q?X+qH51uqtRvrpP7wwHOvga1Z5sEfRN7ncg6C1Af332ZyuC6o/bK/4BqQU8aG?=
 =?us-ascii?Q?gNqSMXkXdSBe6/R9kadzahwgCCFN0uTxlnDLIC4bveOUBC1PoRsBEceI8Bu9?=
 =?us-ascii?Q?cMo8UGfRlDtSiXraKLrjUlLrwBogmf3WrmdCrhTlXzePlOyxY6fbqzazdG2p?=
 =?us-ascii?Q?VWC4/Kx17LfYP07i/u3dW36E/5e7kim9ZBL7C2+ZxmeytPUcczZH6AM/d1jI?=
 =?us-ascii?Q?Zy8j76nHpbjTSbmfyEe/ZFDgPhs8JzjT3Z8UEUoOPYHxivE9RC9wfR4rFgmL?=
 =?us-ascii?Q?IvZ7KQ3/1QMHDvQwLAaFZ/6mUA5fje4oeqHHwbRPYiWA4ygPtN4TIdGo5tR1?=
 =?us-ascii?Q?PO++B3YILdd3ZzeHsat+yKQzD46fPlTQmhoqoyP486CqG8qQ8qrymmK79YWZ?=
 =?us-ascii?Q?wbU3hksdSwwZ6B0JmYOOgBcUDrLQio9X8TdwGf8Qhh/C/JJK+7d4FtLYh6jE?=
 =?us-ascii?Q?NOsIGnZ9IfbCIP9+kfTkPbRrH0syU4vK0buc2x2cJ/DQAic39WLGkaIxmQ/8?=
 =?us-ascii?Q?0sRC/1WzPy9emgVALGvmCMy3uBbqu+aC+thAOJeMONEn0tRrmrUIAODPaPKg?=
 =?us-ascii?Q?XI7BGrc9EtKWX9+/rOfRmVkivIFZdogjy9/W1jiaql0eARTNq15To6YJxE3D?=
 =?us-ascii?Q?MhhQhaNmONAXULJ5Cp2fT07n4T6nCgZKnUtp2Bs+G4hDaA6PCKKPXzKsK1hz?=
 =?us-ascii?Q?kaIdWvEJLLRG3XPo4mvek7qapDINbiIhzqiyo1eVRSDKj6XnEo4r5dDjfuaX?=
 =?us-ascii?Q?Rvf/TjV6JxkOgAcSH6jJ9znstaZ/0qiaT1hnXJTp2FIaknDvyhR302sb898t?=
 =?us-ascii?Q?91DKFBxAcujHM40jUQpX8KDuT40SQpT9MASUeTD57oaqZpZGoUUh55Kzg+qt?=
 =?us-ascii?Q?8ke5gUfqxgF9Xi196LOus+qxNMbiS4TWhgXQaI2zRiwIwEPAO0nKDJTg0T52?=
 =?us-ascii?Q?ZzUXuwJqa93jlF4A3R5x8HgSJpAwl7rxkUNmJqTPIfQhFO7b0Pj50XVfMnZE?=
 =?us-ascii?Q?5JBgXLcKNY288gNdy0Vlv6bTIxiDeajQDTvlNFkPMH0ZXUV+Yq0VeVR7gv8H?=
 =?us-ascii?Q?Ug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FEA4132836C7FD43B9294832BA07A93E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0151c7-1ce2-4d96-ac42-08daa92df0ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2022 13:06:40.7944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kv//ONreG0j2PU5mCYHJNYFTqYNaKZPQZCcjgJHt482FsvV6arPstOWDGCRY4FFGNibD700BNPScbJ5XYuNt1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8403
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 08, 2022 at 04:39:42PM +0800, Yang Yingliang wrote:
> Fix wrong pointer passed to PTR_ERR() in dsa_port_phylink_create() to pri=
nt
> error message.
>=20
> Fixes: cf5ca4ddc37a ("net: dsa: don't leave dangling pointers in dp->pl w=
hen failing")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!

>  net/dsa/port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index e4a0513816bb..208168276995 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1681,7 +1681,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
>  	pl =3D phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
>  			    mode, &dsa_port_phylink_mac_ops);
>  	if (IS_ERR(pl)) {
> -		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
> +		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(pl));
>  		return PTR_ERR(pl);
>  	}
> =20
> --=20
> 2.25.1
>=
