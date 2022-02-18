Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DAF4BB918
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiBRM0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:26:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiBRM0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:26:50 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80133.outbound.protection.outlook.com [40.107.8.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1C02459E
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:26:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZB1nlabAZU/slxdoPCdIRv+O7fBMqhpcKqUGwiwJxDB2wkywLMbp8xKDXRS973LKJt3tZnp+isvgoJrNBcbzU6ZcgDYsT+mrluJVpywPbFhKpRb3r+I51zIopdpJ1i6mXCqYFRRooOyVAZks8Vl8jkY0BVVJNaLgkseKlp0dtZY7ClapKVGuV1W/Kp9LICYCpBHVOFSXghR26zpQVZRcS7Z4b39kvLYEzA3Ui6hinw3kugfeF7VmEKgCsJGma7cTdpyTPPC0w5reDpRsgr0NszjrIHH7/e7lI4WEtL+c9Va5w5m6eksX+GpBQ4kcttY8QKWXp9b/SfEAdzDV/lg53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cVus6vAVTuk4xhPotYJwThiPN8RjNFChP7yHVVE4sI=;
 b=cSTtGVuSgNABVehdiRbRSHjnWxsa2iTaQsd2K1suqyPhHcj9jyPGZAnrquUKjh9xqfeRErze23Er6nHkpWm+Ev4CuMdjOyHF3RGd6xoS/WqBAT3MXvvYm7/ijc5nE859NOMHjzvbRsDujXuLoj7JlVq8GomH9jzFk7eoBD/TcBB3f/4cljcFppDUIj2VEA9HckrHnLjaqx06UGMLZpcB1hrwP5XSxr0NBSEmZzc/NaT9uCLH0TcO/THXU7FnwfICqodq4dAWNLhJn1cIe2agb2FqHVLIJqXkqON03mfSqo9FRSLMI7ntKJMILxhZEcuaNQPnR6IyLVtQJYjRbjEaxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cVus6vAVTuk4xhPotYJwThiPN8RjNFChP7yHVVE4sI=;
 b=QcnU2xrXjA4wvE6PB5td06OX4JKOfKeE1Df3Q20R8P4v/rFTGgpiMoRy1YTR9lwAGP8bTQ2mu5qZb7TqkyA6m0lcZpwty69rQkoNcIjzqZP7UP5v3Jxhlel5y6lWWHOmisvzFzhzMy054LwgFTSaSSYoBWdeUlaW347B9Tt/O10=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB7PR03MB4011.eurprd03.prod.outlook.com (2603:10a6:5:32::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 18 Feb
 2022 12:26:28 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 12:26:28 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: realtek: rtl8365mb: add support
 for rtl8_4t
Thread-Topic: [PATCH net-next v2 2/2] net: dsa: realtek: rtl8365mb: add
 support for rtl8_4t
Thread-Index: AQHYJI5NALk0/+sSBUiUD2IeewCHOg==
Date:   Fri, 18 Feb 2022 12:26:28 +0000
Message-ID: <8735kgpdho.fsf@bang-olufsen.dk>
References: <20220218060959.6631-1-luizluca@gmail.com>
        <20220218060959.6631-3-luizluca@gmail.com>
In-Reply-To: <20220218060959.6631-3-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Fri, 18 Feb 2022 03:09:59 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcd77518-1d0b-451e-1ca5-08d9f2d9e341
x-ms-traffictypediagnostic: DB7PR03MB4011:EE_
x-microsoft-antispam-prvs: <DB7PR03MB401105BFFCEAD611C117D45A83379@DB7PR03MB4011.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J5yevgY2R9m/49ZlTMUB+BYXgU/9+M4+hNukH64W/BYOsLNka4Bicv+khbxpXFEO7mG9fnb8trFhTgn0k57s/B1sVvz20nMhk1EeBrqCsYIULt+6UbeiuuJjKV6LOmhpAxQ2j4AhgHGgBsGVWdrJxcE5O8raJ2JvF2vaijmX2KaILFoQkWTGPMCU2QqQH8WUKOKju+rxvRegX0gkhhDjUrLl2AHESjFZQC1NNPyVbB9Yfhn+m6+M05ClmVh4UfdY6Fwe8gHeWqs4TiwgJvhlLg4xtUIcmXeXlFsNjYRv63NY7pVIqK6oQ6UzJBT3Y6D1Ta0c9zpKmU88o0GK4x7HzynFM9n/B5hyJm1ZJC6Uplmvf3yLzXFfnCXPiYrb1KtGn01vHh18xNSyLjkc5mqkS4xpHs45gwEH1GGwllOi3E8UQH8gJ6w3hfQCDxmCVfDXLYXb3UGw5Xs8pu+Q1efdKM1sapb7PB3N9eBCjDY/BUhg4Os2aFgAGAaWEIcC3WoLQACkp6rqY2cuo/sxLcOVoKpSmbBrbrd1O4EuoRtn46DIlhyNXbqZ21L2ZO4vrp0QU4YwliAkf5npczXjQbfLd2OkckMqAjixjL0vqizllkOEAdd6Xnc6s/WcDHEBuX1TsOxIf9urQg7xVSNSsJOhy0FM2r/Z9vIEMSCfghpiXKf9CDzMDMBbpVZn3D1fPVNDqXFwB+djMlUIWEdJxOa//w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(8676002)(316002)(4326008)(91956017)(66446008)(86362001)(7416002)(186003)(6506007)(6512007)(66476007)(6916009)(508600001)(64756008)(36756003)(2906002)(54906003)(5660300002)(6486002)(66556008)(26005)(2616005)(66946007)(76116006)(122000001)(8936002)(8976002)(38100700002)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?qV/6NPNJOZqFYejlNwelDQFo37WqrNRhvbE7RxQHsTWekWXCKTFUSVMy?=
 =?Windows-1252?Q?pHPK4Q1AYOqxIAjodZQFXirTc5imB7uMoQ1DIFcmGrsVraypTT0t1TKX?=
 =?Windows-1252?Q?30DF9X5x/FRmIIIuQ+YPhweajWvMsS/ZAC/zOi6r7H5oXcaGZirmhjHx?=
 =?Windows-1252?Q?2aLl4BX4yPvfQ/Gsx1eCmsTKQXB/xW1FkVydaVAMAH2tgvZuuu8pEISw?=
 =?Windows-1252?Q?u+80nrd6CgsOCVHltObEy8kVprJC+YbW8ypos/T2fp9FQFVkrTW0PjyZ?=
 =?Windows-1252?Q?e7u0E2LOmb8JNGsSyfloM7MqvD5r86WsKu/g3+MXOgtdRpg0nWfp9E9K?=
 =?Windows-1252?Q?zfSizq6ftKEgxFmvAICQD71Q0Hy9QZq4zqgQJ4DNJ3MakbPrqTlexJiw?=
 =?Windows-1252?Q?fWkerb87GciG5wJ+Rw466fUuHL/oHaPUVbBXM4GOThZdWxX8LXpNMC4s?=
 =?Windows-1252?Q?SFzkUFnQGlCnK6qrJxWg+g+7xZ3Si3h59qtwLROpCWPE95kS+Xonr3ih?=
 =?Windows-1252?Q?JlryDbnISZnUT6Uly+eoxm5fr93J7FmO6oWvoCZSmxxfde2TKQt8W3sG?=
 =?Windows-1252?Q?QXKRKmeGEXfEkKBSqDekGBX7aZDSLdswxUcLSq8mj1YxTcl/KtedsCUl?=
 =?Windows-1252?Q?9Zeg23WwL+3VSVCulWEB/tRfBeItvwiUxBjs25zz2IPOoPNQVAbCdK0/?=
 =?Windows-1252?Q?OpqrTnSlZcnf/p8OSbDOLepavd1QSXG2MoDpsvehrLrmRnHouMdcJ8y0?=
 =?Windows-1252?Q?MItcJ6gi1WxfsLJiC+MwYq5dYG8j5neNqto91AdRtqNx0i4U9Ksmifky?=
 =?Windows-1252?Q?M5qQWcYE7ehaPV/bG0j8r8xt1r1KAC6pah419Oau0AbwWKuo8VlBZ25J?=
 =?Windows-1252?Q?8syFJvd5DDFUKhPz4jlu19hyHtPeymVY1Ae1/n7PKYu71hCYSeyhz1Ag?=
 =?Windows-1252?Q?r75n73lTxuLholmXKIlADaUlh1gbo9a0cNWbVEB5km6r5zWg2h1YbQ57?=
 =?Windows-1252?Q?Jb7zbmsKRky1Y7zD4itqPoib9DairgpwrlSeGgz5swEYvo2maCS8XGFC?=
 =?Windows-1252?Q?5b4KEVeJ7wPBYs51/tbngtWgZa959YluxPrhryuXPlzWYQykNkg+H3M+?=
 =?Windows-1252?Q?Z9KqkTixSLWppTb9LdUCEIRQ3yum9qHiKPbiztU820jEjOUQ4256T9Cb?=
 =?Windows-1252?Q?rm09QioktOr5Bl6BtF7nVMasJqNfAwbdGrYpZh8onrJmsi2n46PRQXb1?=
 =?Windows-1252?Q?b0iVYRtDhIbTHUx1GQJ2A+oKJNoOoGzY9K2i3qEORaNJsbnsBYNgR/m+?=
 =?Windows-1252?Q?BXSpqun73mBTo8sG2Og3xFdz7OKrYBlNs5BKEbN2gdoXw4DYaybrGVyN?=
 =?Windows-1252?Q?7/Nu+kdR7w472tJkIIowI9GuLG/z76bV2SRuMOSfs3KXwKFKMJFNYSZN?=
 =?Windows-1252?Q?LiEUkzyODwKNl8Ob5qCm9KxtDIaCDGe6K8Dvld0b1hDaTGw5cp5YAZke?=
 =?Windows-1252?Q?LvXpHg8uPw52S+D7AvRcu9UVQY4vWeFF2yYCj/S4k5W5jdI/d+YREBfN?=
 =?Windows-1252?Q?7gVuHXo4bhFk8XGjEaoKSeqNKCOEnTL9sC3U7jSpZjkge7mlGzraEDYc?=
 =?Windows-1252?Q?HOohKvv1xZ2YVPOHmYnBSPSa4DpPIX81xn70xiQCeh+Pf0UtRb88t8Qv?=
 =?Windows-1252?Q?aDAhNrhMmzYHiRndRlMp3P+CvL/j6EROwCMknfgAyrE8HIINvbgs7ri+?=
 =?Windows-1252?Q?nNI2T3GlGTBCmmSYeic=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd77518-1d0b-451e-1ca5-08d9f2d9e341
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 12:26:28.3218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7wwZ+ldp+kI8kqDyIn6ltXFbmxI14vkfcCAWYxYHwUMGtLUlIpvk/JnInNpHQtjZkOpQ2arEZd5+Jnw8kCJOuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> The trailing tag is also supported by this family. The default is still
> rtl8_4 but now the switch supports changing the tag to rtl8_4t.
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 78 ++++++++++++++++++++++++-----
>  1 file changed, 66 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realte=
k/rtl8365mb.c
> index 2ed592147c20..043cac34e906 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -524,9 +524,7 @@ enum rtl8365mb_cpu_rxlen {
>   * @mask: port mask of ports that parse should parse CPU tags
>   * @trap_port: forward trapped frames to this port
>   * @insert: CPU tag insertion mode in switch->CPU frames
> - * @position: position of CPU tag in frame
>   * @rx_length: minimum CPU RX length
> - * @format: CPU tag format
>   *
>   * Represents the CPU tagging and CPU port configuration of the switch. =
These
>   * settings are configurable at runtime.
> @@ -536,9 +534,7 @@ struct rtl8365mb_cpu {
>  	u32 mask;
>  	u32 trap_port;
>  	enum rtl8365mb_cpu_insert insert;
> -	enum rtl8365mb_cpu_position position;
>  	enum rtl8365mb_cpu_rxlen rx_length;
> -	enum rtl8365mb_cpu_format format;

This struct is meant to represent the whole CPU config register. Rather
than pulling it out and adding tag_protocol to struct rtl8365mb, can you
instead do something like:

- keep these members of _cpu
- put back the cpu member of struct rtl8365mb (I don't know why it was remo=
ved...)
- in get_tag_protocol: return mb->cpu.position =3D=3D AFTER_SA ? RTL8_4 : R=
TL8_4T;
- in change_tag_protocol: just update mb->cpu.position and call
  rtl8365mb_cpu_config again
- avoid the arcane call to rtl8365mb_change_tag_protocol in _setup
- avoid the need to do regmap_update_bits instead of a clean
  regmap_write in one place

The reason I'm saying this is because, in the original version of the
driver, CPU configuration was in a single place. Now it is scattered. I
would kindly ask that you try to respect the existing design because I
can already see that things are starting to get a bit messy.

If we subsequently want to configure other CPU parameters on the fly, it
will be as easy as updating the cpu struct and calling cpu_config
again. This register is also non-volatile so the state we keep will
always conform with the switch configuration.

Sorry if you find the feedback too opinionated - I don't mean anything
personally. But the original design was not by accident, so I would
appreciate if we can keep it that way unless there is a good reason to
change it.

>  };
> =20
>  /**
> @@ -566,6 +562,7 @@ struct rtl8365mb_port {
>   * @chip_ver: chip silicon revision
>   * @port_mask: mask of all ports
>   * @learn_limit_max: maximum number of L2 addresses the chip can learn
> + * @tag_protocol: current switch CPU tag protocol
>   * @mib_lock: prevent concurrent reads of MIB counters
>   * @ports: per-port data
>   * @jam_table: chip-specific initialization jam table
> @@ -580,6 +577,7 @@ struct rtl8365mb {
>  	u32 chip_ver;
>  	u32 port_mask;
>  	u32 learn_limit_max;
> +	enum dsa_tag_protocol tag_protocol;
>  	struct mutex mib_lock;
>  	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
>  	const struct rtl8365mb_jam_tbl_entry *jam_table;
> @@ -770,7 +768,54 @@ static enum dsa_tag_protocol
>  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
>  			   enum dsa_tag_protocol mp)
>  {
> -	return DSA_TAG_PROTO_RTL8_4;
> +	struct realtek_priv *priv =3D ds->priv;
> +	struct rtl8365mb *chip_data;

Please stick to the convention and call this struct rtl8365mb pointer mb.

> +
> +	chip_data =3D priv->chip_data;
> +
> +	return chip_data->tag_protocol;
> +}
> +
> +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu,
> +					 enum dsa_tag_protocol proto)
> +{
> +	struct realtek_priv *priv =3D ds->priv;
> +	struct rtl8365mb *chip_data;

s/chip_data/mb/ per convention

> +	int tag_position;
> +	int tag_format;
> +	int ret;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_RTL8_4:
> +		tag_format =3D RTL8365MB_CPU_FORMAT_8BYTES;
> +		tag_position =3D RTL8365MB_CPU_POS_AFTER_SA;
> +		break;
> +	case DSA_TAG_PROTO_RTL8_4T:
> +		tag_format =3D RTL8365MB_CPU_FORMAT_8BYTES;
> +		tag_position =3D RTL8365MB_CPU_POS_BEFORE_CRC;
> +		break;
> +	/* The switch also supports a 4-byte format, similar to rtl4a but with
> +	 * the same 0x04 8-bit version and probably 8-bit port source/dest.
> +	 * There is no public doc about it. Not supported yet.
> +	 */
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	ret =3D regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
> +				 RTL8365MB_CPU_CTRL_TAG_POSITION_MASK |
> +				 RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
> +				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK,
> +					    tag_position) |
> +				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
> +					    tag_format));
> +	if (ret)
> +		return ret;
> +
> +	chip_data =3D priv->chip_data;

nit: I would put this assignment up top like in the rest of the driver,
respecting reverse-christmass-tree order. It's nice to stick to the
existing style.

> +	chip_data->tag_protocol =3D proto;
> +
> +	return 0;
>  }
> =20
>  static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int por=
t,
> @@ -1739,13 +1784,18 @@ static int rtl8365mb_cpu_config(struct realtek_pr=
iv *priv, const struct rtl8365m
> =20
>  	val =3D FIELD_PREP(RTL8365MB_CPU_CTRL_EN_MASK, cpu->enable ? 1 : 0) |
>  	      FIELD_PREP(RTL8365MB_CPU_CTRL_INSERTMODE_MASK, cpu->insert) |
> -	      FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, cpu->position) |
>  	      FIELD_PREP(RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK, cpu->rx_length) |
> -	      FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, cpu->format) |
>  	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_port & 0x=
7) |
>  	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
>  			 cpu->trap_port >> 3 & 0x1);
> -	ret =3D regmap_write(priv->map, RTL8365MB_CPU_CTRL_REG, val);
> +
> +	ret =3D regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
> +				 RTL8365MB_CPU_CTRL_EN_MASK |
> +				 RTL8365MB_CPU_CTRL_INSERTMODE_MASK |
> +				 RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK |
> +				 RTL8365MB_CPU_CTRL_TRAP_PORT_MASK |
> +				 RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
> +				 val);
>  	if (ret)
>  		return ret;
> =20
> @@ -1827,6 +1877,11 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		dev_info(priv->dev, "no interrupt support\n");
> =20
>  	/* Configure CPU tagging */
> +	ret =3D rtl8365mb_change_tag_protocol(priv->ds, -1, DSA_TAG_PROTO_RTL8_=
4);
> +	if (ret) {
> +		dev_err(priv->dev, "failed to set default tag protocol: %d\n", ret);
> +		return ret;
> +	}
>  	cpu.trap_port =3D RTL8365MB_MAX_NUM_PORTS;
>  	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
>  		cpu.mask |=3D BIT(cpu_dp->index);
> @@ -1834,13 +1889,9 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		if (cpu.trap_port =3D=3D RTL8365MB_MAX_NUM_PORTS)
>  			cpu.trap_port =3D cpu_dp->index;
>  	}
> -
>  	cpu.enable =3D cpu.mask > 0;
>  	cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
> -	cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
>  	cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
> -	cpu.format =3D RTL8365MB_CPU_FORMAT_8BYTES;

Like I said above, I think it would be nice to put this cpu struct back
in the rtl8365mb private data.

> -
>  	ret =3D rtl8365mb_cpu_config(priv, &cpu);
>  	if (ret)
>  		goto out_teardown_irq;
> @@ -1982,6 +2033,7 @@ static int rtl8365mb_detect(struct realtek_priv *pr=
iv)
>  		mb->learn_limit_max =3D RTL8365MB_LEARN_LIMIT_MAX;
>  		mb->jam_table =3D rtl8365mb_init_jam_8365mb_vc;
>  		mb->jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
> +		mb->tag_protocol =3D DSA_TAG_PROTO_RTL8_4;
> =20
>  		break;
>  	default:
> @@ -1996,6 +2048,7 @@ static int rtl8365mb_detect(struct realtek_priv *pr=
iv)
> =20
>  static const struct dsa_switch_ops rtl8365mb_switch_ops_smi =3D {
>  	.get_tag_protocol =3D rtl8365mb_get_tag_protocol,
> +	.change_tag_protocol =3D rtl8365mb_change_tag_protocol,
>  	.setup =3D rtl8365mb_setup,
>  	.teardown =3D rtl8365mb_teardown,
>  	.phylink_get_caps =3D rtl8365mb_phylink_get_caps,
> @@ -2014,6 +2067,7 @@ static const struct dsa_switch_ops rtl8365mb_switch=
_ops_smi =3D {
> =20
>  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio =3D {
>  	.get_tag_protocol =3D rtl8365mb_get_tag_protocol,
> +	.change_tag_protocol =3D rtl8365mb_change_tag_protocol,
>  	.setup =3D rtl8365mb_setup,
>  	.teardown =3D rtl8365mb_teardown,
>  	.phylink_get_caps =3D rtl8365mb_phylink_get_caps,=
