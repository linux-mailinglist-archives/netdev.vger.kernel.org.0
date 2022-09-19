Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20745BD846
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiISXbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiISXbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:31:03 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4594145F45
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ofh5SICsNEjw5bbbINfR/igYc7ba/j8eKZj8q3ZCuuHDztAjFljJn+hDv0hcloMflPyQMT4ReEzKg8ZaKqYp4kiCx2NnStMAaxdHRGtphGvahnSVvKc30oqyyqRO6j0FqUu9IIMFCE+g2DdBcouNGRelxV6COYxBQboz7ergWCDeG+DsAXJcA5VtfK4PWKSWLgiFg13lBEhXUWGlCeQL39bpfoIiZvUDPTVV/87O6rTabZJPyUudyfU6kujg4PctD3BLJmwB5ORwTadf4MFy81SVuiupiI4zwDW44G7iQy8VXLqnN2T6IigUm9Yz9EbaplVtEiaKZlz9Hq/GXzYBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a296gGR2H/VSE+wUvGMSKDMaIDVWiv1I7RuCHnLpvTY=;
 b=OV2HbTK/91vheb2+1zJRjADKP/4LnGi/EUXBxPDGdlp2GJ5g+OFSN1Es+B+92Ln155Uaz/xCQWTRnW/zEq8A0D1/CAU8i59EMmpVoUHOlG5Zr88Gac1cSnw5ApkQn2t8InCq/oRlYhhxB15rKXacKhGikf9UpaoQUTUCHh3j/HX3G6BcyZiB2NQpeM4Nsn/RzaUiBy688m8cIJoRoDITJWF5eyZlJF6kJcwvCAHo1b6bz+40QI+H1xEzenBL4PJY8TK82p3Es6u1lk+H1orvoPXMfVGowY/qS/tbGFqOnt7nPDLXEouCKP7VIDV03YngApsI6X69FvIOT4H/xTI/1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a296gGR2H/VSE+wUvGMSKDMaIDVWiv1I7RuCHnLpvTY=;
 b=Ef5vt4ictcq8UM1RDFb2VBetXYtKvDn0gt7tNSZRBHh1mbhcX47VG9o9131QNAoKabNAWRb07h9+EOmAk0+SDew4Vw5zwr3fOkrrMIvmHDcVYHw3oGoytO9vXC4Hs7lDUek/CvfI/BZDsxdnb+Q8Q7kS4xSOZESs2XLTpx/pQmg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9375.eurprd04.prod.outlook.com (2603:10a6:102:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Mon, 19 Sep
 2022 23:30:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 23:30:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 6/9] net: dsa: qca8k: Refactor sequence number
 mismatch to use error code
Thread-Topic: [PATCH rfc v0 6/9] net: dsa: qca8k: Refactor sequence number
 mismatch to use error code
Thread-Index: AQHYzHXWVp6H30ONC0e6ZFod0NvymQ==
Date:   Mon, 19 Sep 2022 23:30:57 +0000
Message-ID: <20220919233057.ppfarnbf25znkzj2@skbuf>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-7-andrew@lunn.ch>
 <20220919221853.4095491-7-andrew@lunn.ch>
In-Reply-To: <20220919221853.4095491-7-andrew@lunn.ch>
 <20220919221853.4095491-7-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB9375:EE_
x-ms-office365-filtering-correlation-id: e03838ab-a8d6-4aa5-a5df-08da9a97014f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UBtBnPngodhbbkoRv15VC/80zD1SpI0nUBTu3EucvhV66U8t8eR3lDCOqzT01a+jr+wiGfSGqxXHlrQnCq1epuDkytYN7sbwztwiJx+WJ1/NHewCEC0D+yx4V67NClBGkqYRWWttpS9tV2E5jN45I7MaetCWiQFssOjqOaRo2GE32YKvpWJyB8gCw1Ey7CAQOCRYDAHscP+sZyqQeOKRpD4/UOw2/uPY+etpd0vGXuX5JGqZsYn8el76BT5Vq/7fapIHLCUVYqCb3jiZDTjA1S2PPgRhkj0kj5gGCz70kJZJR2bqMkis27G/YjOYULyxfO6GTA76Aot0JaJ+d8Cra61gO4ScEO0jMqoD2kyJJRA4+xkDU1cWe4Bed10Qxad76E/u9GapnPZ88Czk1nqU+SsrRmW1LvMurz9AJ6UO6gtL8xoNZijXpuD3+GdComV0b0CArHpKw5qWDaMA1gVirxfB1jM/NFwlMolq/25zOXAivEJul9h/qsJf+NWLEJj8ikgOa7KCmh+12d6o85CVGNnBIrTe68r3c48WDNzXCYZgae+espOnV4l1fGn2JAG9nFEZYEPLGdeWWZGNKKvQrVX4dz07E5Lw+07aFbDTa0TAIMW3RRniw2tiFy+IpiPcS4kz/AerlVzqHa0C32FYIMOaH1hnfGOZcSWilia9ImTOjdleuTJpxx3o2jVYhhFIQ6VOHddk5MP4adPV5CPytWqGPshEYd6oCbWGrh5RJ0BHFS0TBcpbjGhICdbrDVUViPwe3Jk9r1fdjW2KQC8lMdMZ2PnLbYVu3/2w/bLRjwA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199015)(1076003)(186003)(83380400001)(38100700002)(86362001)(38070700005)(44832011)(122000001)(5660300002)(8936002)(41300700001)(66476007)(91956017)(8676002)(66446008)(64756008)(76116006)(33716001)(66946007)(2906002)(4326008)(6916009)(6512007)(66556008)(26005)(71200400001)(9686003)(6506007)(54906003)(6486002)(478600001)(316002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s24MDOJDFndkTnrJE6ycrDc2nisZpxEyII/iKB2hh4ht8sea07sFE3bQ+lS6?=
 =?us-ascii?Q?fChJbKbz/j7jkaU5xUUpWWMczmVC2kLurEdqynxVLsC9WCxqs+Kz53T6Is24?=
 =?us-ascii?Q?6hQ0w7n2Fwm8Tey9mp/mnXUr1VWKc1T085odEe8hYrtoiitFDoUpjiCBYsuy?=
 =?us-ascii?Q?UCJNLwsqcVuB0vvQO6FIOqaupX8tBXGyT5QnAsn29fI1GScAabegwcqo7gmi?=
 =?us-ascii?Q?bFbM7p0pgw1GQU3/C9WTx/rIkkOilcNW2Wd868G7jQvNMM2rVgmtwBTNhuWA?=
 =?us-ascii?Q?vxiXVP2ecxLHnAHuX5C6OvY1SSbNTENZ/f3PWmucsZqtxjuNEj9Vy2hFexym?=
 =?us-ascii?Q?eAv9TE4jEpSMoWZsAtWTxEkcO7W7L464YTgOY/XtY61OmVQnenNDXfeh7cpX?=
 =?us-ascii?Q?rOgFaxfzTdl/5AJTXf2wUi0uTH/i+AdULRQs4NTq1OjdNYm6zDbO/n4Y8R74?=
 =?us-ascii?Q?StuFV5C5o5wDtYwXIBvaVf43upg5elZ6TDteBym1t9x+YY9EkHnivefyj+5P?=
 =?us-ascii?Q?IMpYxPv+m1Qy3Zzv5MZOLKcvzL5kAwvt++6SlXoyj1JV1dR2oCE1AkliXvne?=
 =?us-ascii?Q?KWZDN3pnQDBlwRUN08RvIafuKqwfL8ThEI9QxFzC6eVR4HGsQwteKVNYLBFs?=
 =?us-ascii?Q?meVp9Ze3mmPgq0jZFLMEpUNnckAWs9hPsKY4pj44N1SXTEabqiuWAOUZQ+M5?=
 =?us-ascii?Q?UtU4scDg22yvW/oMSTDucm8MEGQxq/BXp3G/FnRoXTri146yXOK/qhF3ojaU?=
 =?us-ascii?Q?nsVEY/Iax/xdsqiQ81fZgZcoVP26oNuhei5BTbMy4WxZDfe3Zk9Aec02Bzq0?=
 =?us-ascii?Q?X8jyT9LzeRx0DW4b3eqLvnXA+PWDwEJM/rpiQYyl5J1qAwjspKVQoQoFktYZ?=
 =?us-ascii?Q?PHFTY3qR04ZlesibDfKYHO9sXzzA1kqXd0mv9TFpvaAnyEXgIjgWwXnYCkwF?=
 =?us-ascii?Q?VDeS6f9//MShg3TpM+TgcR5oVjRhGwOrU0JQ7PHrnSuM/hHd3dYnwvp/VlPP?=
 =?us-ascii?Q?o4nQBE4jyYjjLihMgVVjiUst4x0P7iw1aFYW96Zval4JcgpbTsQ6Rjaj3jWJ?=
 =?us-ascii?Q?T69QWmwrs7JOvR38yCNTW55poSoQuWqnM3k87lAuFP/Q+knkf5iwlQDKXNUA?=
 =?us-ascii?Q?SfJ65nJ0wp+vvJBeWhdkSMgqRfQpENX0NyUSd4q7+1SdZhZNdaOSRvlklnI6?=
 =?us-ascii?Q?QQsOknZRVSNTFPIMqvlynKpugY2riEe27PYwpST7laCjGPmfS1Hh4M94ZbaB?=
 =?us-ascii?Q?6lzY6bidPeUfxc4q300twlRejV4wsMzXdTyJ6++lLdaJi9vyqg5hu3OkWMvg?=
 =?us-ascii?Q?IgrhT6wCziyPr/Tpf+X6R7HXApa0u7gcH6bitqcK1PvBiKq3upXu9I1r6a/W?=
 =?us-ascii?Q?9lfIHSq5zFOr+F6ns0jtbhMH41V9uVQNVC0cvRgmLdct85af0dGvEGuIw15X?=
 =?us-ascii?Q?nFOl+mPco8poE/VtqZqkOdl4Q90r8B6ULfbiFBk9lXvpQSZgzcGwYSB4O6vJ?=
 =?us-ascii?Q?QnIdOMS00Ou6zquVsY7Z0xQ/PfKSTFN8gxlFZbT4gbQ72SWaDbUX8zFG1FhZ?=
 =?us-ascii?Q?fBLBY7tcGWZtH6nFvoFTbXGtEtglgQcHFmQJrEX0e3YzZr7v26G2EYbTiH0I?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B07F1F76E6C594D8ED13E34C563EEDC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03838ab-a8d6-4aa5-a5df-08da9a97014f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 23:30:57.8926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OvP/HwJBV/3X+EdZqwQG3TnvNaz7z8XfPSbCcjVn/6R2m5XOK01uzabS+sNfHgV7yM6Bez7/hp0z47FQS8t9Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9375
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:18:50AM +0200, Andrew Lunn wrote:
> @@ -229,7 +231,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u3=
2 reg, u32 *val, int len)
>  {
>  	struct qca8k_mgmt_eth_data *mgmt_eth_data =3D &priv->mgmt_eth_data;
>  	struct sk_buff *skb;
> -	bool ack;
> +	int err;
>  	int ret;
> =20
>  	skb =3D qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
> @@ -247,7 +249,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u3=
2 reg, u32 *val, int len)
>  	}
> =20
>  	skb->dev =3D priv->mgmt_master;
> -	mgmt_eth_data->ack =3D false;
> =20
>  	ret =3D dsa_inband_request(&mgmt_eth_data->inband, skb,
>  			      qca8k_mdio_header_fill_seq_num,
> @@ -257,15 +258,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, =
u32 reg, u32 *val, int len)
>  	if (len > QCA_HDR_MGMT_DATA1_LEN)
>  		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN)=
;
> =20
> -	ack =3D mgmt_eth_data->ack;
> +	err =3D mgmt_eth_data->err;
> =20
>  	mutex_unlock(&mgmt_eth_data->mutex);
> =20
>  	if (ret)
>  		return ret;
> =20
> -	if (!ack)
> -		return -EINVAL;
> +	if (err)
> +		return -ret;

Probably "if (err) return -ret" is not what you intend. We know ret is 0,
we just checked for it earlier.

Also, maybe a variable named "match" would be more expressive? This
shows how easy it is to make mistakes, mixing "err" with "ret" in the
same function.

> =20
>  	return 0;

Can it actually be expressed as "return err", here and everywhere else?

>  }=
