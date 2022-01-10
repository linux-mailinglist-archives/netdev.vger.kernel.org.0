Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE0489A2B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiAJNkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:40:02 -0500
Received: from mail-eopbgr70138.outbound.protection.outlook.com ([40.107.7.138]:24742
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232947AbiAJNj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:39:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtBOTo0GLVuGrMoW5NsYGBz2i4cqZbMdkZf5Zg1yOzUmeEIIRfXhDt+iwhfSUo84CJxwkllkgYvm/VF7YQEt+rHJbbO6m2vKvbsGOdcLy5/JMDSNF1Dp+vxSFdm7eEl4S4twvLIy2BYi8JNJvn//z0XP20ZD9eH5CfSghA2qIDIzv4qAMXy4VQfm+jzsr2IrcbsRxxiHIC8bgxM2qBpfweard3DXJZvmdTzZ7A2ViqUyiJcxFY2aGLmOo1CKt61NqXxL82s7Y6iTKtcpcvCxP2fXakImZvBcPdkecSi7U+NZvYV3zgDfVBtcg5vtS0df1VVt+TkAChr/ZEXAH6OCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtNx/e1vnWjtEMXA2PqVaN0TUjvbHkUILT5SSz6iGRQ=;
 b=iZ/qj1gnfR4kvXsp35e4pTy+19L5aeiGnAMbMq1Nl54JB/LG0jz60iUMJ6ufD0jTYLKUCYXX6WylU9mh6wpZ7yMEyac/CZ/53e+EPIrKjnQp+TgUAzVp1stvpYpcnsj4TuH37njuCb8f871BqnxWPU9JjftoWS2vQSifYlGxVLh2aAKW1+XaTkI6hhDmNlJMJFCrux6nGLJRJrnDmHU91ykj9ncwsyP4XJ/q+dc56Okpryt8XGyDlD0Sq50MxGrZ5+VG8T4FORrAgN3UN/PyaacrFhT8hA1t6UaNAixbFwaHwgIH70LTdyyVPp0V80hxfBHiyDF5cp90yuxNn4G+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtNx/e1vnWjtEMXA2PqVaN0TUjvbHkUILT5SSz6iGRQ=;
 b=GSJXr3ojUKGP5M2hbIlL76ywJw/v1RN9DEhQ1IgyfzG7+Y5e8Vn6flsgpAIVHJdgtAcjYbS6tGAm6l7Fikm7GlrA99KNMAxYe8wbaWDRYwxURBt7/Ve1EMVI7Xc23aFNqybGMpmJ7v6qN5stnYwJryVfJYDw0PVHDLgHBEyvEv8=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM5PR03MB2963.eurprd03.prod.outlook.com (2603:10a6:206:22::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 13:39:53 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 13:39:53 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Thread-Topic: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Thread-Index: AQHYAeKdFqOvd3BDqEyIRmVm5LaE7w==
Date:   Mon, 10 Jan 2022 13:39:53 +0000
Message-ID: <87ee5fd80m.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-12-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-12-luizluca@gmail.com> (Luiz Angelo Daros
        de Luca's message of "Wed, 5 Jan 2022 00:15:15 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f28c59d2-1017-4c3c-d0a6-08d9d43eaf07
x-ms-traffictypediagnostic: AM5PR03MB2963:EE_
x-microsoft-antispam-prvs: <AM5PR03MB2963C8EC893DF24B6653C4CB83509@AM5PR03MB2963.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EnNP65DhwguBr5KpJaVqttq06bJIITd5prkX72p7uY+0hQrmaOA2QosNAlc1w8ZkVoAJ53k/kZ2TQn74cfHMRhakbQ8zCrukMSaeFWPp02rp8kMkkF7Y0zSNPcVFR3TdQw5eO2QYGyptlQB0TC040RrLek1zH+vajD07PcL7VyBzCHknIL1An1QSWAdEPX+0yg5b3C3M/6sGCO8y4QcSbAessrusqyApQlrx8GGgv/aLVUUq6YjauYZXi0etuaDHaa/YSwmF0oQVTnUGApkwQAy9NrrIqUm+Ji/eO0+pJt0UdqhqyvSVSXCtf/KexgUSYO4eZNLzM7jOvk3GsWACerG5zn4tt6a8NQr7U6BfeWkEvVTPN5WFGqpq1y1c+/K7VkGj26G83JCZ/dj9NB2GBkq2U7o9wEDIJSpoFjqdzHs9VN0EZ31VXgFzf4dFXWizvpeCpMYRazrsFPR+GGv4NYp6xNwsDvUKWVwy9hWbHeLdmb58SakBqEVwCBxhdK7CwAlgTurjv6kC0zb2RmFjFqygWFhS3TCcALUhtVIYgfmY4pN3T/ZS+VdSeBE8iPUUrn0jFKCekTkPBL3kFpnFR/5JaQfuX1jG8NbcQMbCNMmSReg+4UV+W4OiJcmFbMW0DTUJPJAgdVgLLa6gVdL+O70GVpjsHD7roUxw0qeUT/m28qH1Rv88kA6N6d0oC3hgx8t7AM0mg/XlfCJ8d8i/fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(71200400001)(122000001)(5660300002)(83380400001)(36756003)(38100700002)(2906002)(6486002)(54906003)(8976002)(86362001)(316002)(186003)(8936002)(6916009)(76116006)(38070700005)(64756008)(66946007)(66556008)(66476007)(4326008)(66446008)(26005)(508600001)(91956017)(8676002)(6512007)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?ZjO6ozDC0rzcw+fXc69zAWaE6Wu/ZAmdH/EhTNLhCeOT0DxTh+cr4ry8?=
 =?Windows-1252?Q?Ut2BhSqdPZiBknzm4Os6h3toqupF5VI8iMmNdDsw80L/IoZCSa7Bq4lF?=
 =?Windows-1252?Q?FJjsBctssTLjL6uP5N5Mrg/EaE6m6G915sCb/V1HqL/g+AVxIWC4Cdhk?=
 =?Windows-1252?Q?Nk7TElxUzNNanCX8K68wrs+vH3O1OPcsWUZKTzqxpmT0jLuf7iQa7qQ1?=
 =?Windows-1252?Q?mk4nVjoVTroBfJlrSMao4oeta1xuratG9wUoynX+3BsEw7e6nxXgbhsy?=
 =?Windows-1252?Q?uaTFi2rdoJyGA8inrX/7X7R5k4tbp853JZTN2mg9wk9hkomURDhQEj6a?=
 =?Windows-1252?Q?huegfUgObzjT2v/C80oBbxYKjWzTJ7HfbjPJ4eTzofHhNR2plRaCaIfI?=
 =?Windows-1252?Q?/gXKYKXZnRnpY5uHTdLm7X5pHdCTSqCBAJoUpu3+XNU9w+WyBEMlWZVM?=
 =?Windows-1252?Q?LyIUiqEm/XeMHzeo8+TZbi+dYr9qOtKO0R+3epy8SopujY6Wx/X0Qmz+?=
 =?Windows-1252?Q?JEm3wGrHuEc3AwsKxm8b/6nKg0P6/MfY+39xTY2cMhgSC17ssJvX7iiA?=
 =?Windows-1252?Q?3LA1+iAVcVcI63Wqa1INxAg/IjmhIFXSmkroAdopRYAAxeYOCiBwiMEv?=
 =?Windows-1252?Q?2DuFrS/rRqD9U3lyvsVq3XK+mYY3ElCIgcaf/5wUi+NbZ2SRKu4+ttpZ?=
 =?Windows-1252?Q?rOmFMkR8TN52fWXCJLbV72CsurYWIwySSaYnksOUDfaRZ6pgTzmyvctz?=
 =?Windows-1252?Q?vr7o1dEdEThVBpkCeKuB6SRXTXWsazKBiFX9Iiupo6jFj9nMEsyUdlp9?=
 =?Windows-1252?Q?yKtaOx0yb1TNZvwB8U+PsY8ZI10JCyk2i6FzGcnoFpLEUSf7K6oKKQxc?=
 =?Windows-1252?Q?Up2/OJMWyaY2I9kHG4AAeUQ5BLSnol4dVFVO4yRPiyb3btz6cDXAiGLJ?=
 =?Windows-1252?Q?I4/AiP0oDd7kO8RNXZcgrV4LOY6fGP2bBEUmgQiW+JrFuVBqmdY9PzO5?=
 =?Windows-1252?Q?JWl//FOzUjn0VeMhj5cbXIRP5bbs3qrgNXfUIIXXQZT0F4742HiOxxfS?=
 =?Windows-1252?Q?XgrC5QxX4rLKwCY5IfIwGxSj/QpxJinW/EM8XgkRwtjuWteu+qrRQhJG?=
 =?Windows-1252?Q?qXI+ppOtV0nSfZBTsaisrhg9FDNLihB37ud2rn84QGckhxWhBpwVjBg7?=
 =?Windows-1252?Q?gXUsXWNj/6G3u5q0QUWNYwF0m0VysAwk1g0L/x8boyHo3Fzzl7MCa2G6?=
 =?Windows-1252?Q?5MU8Je3VMgIC60QmsINGAzzvh0uOB7j4JryUUH3Tp9te0OYFr+qS2i3O?=
 =?Windows-1252?Q?84o1q+2GBib0LUUH7rzathKtnkJHjdht3cPaNz2zRszraQzKpkV3UdKm?=
 =?Windows-1252?Q?/g2MXzJuSCKgvdy0U7bzIHgMMof86m9sJMSKri6QlhUxJgaErT2MVtG9?=
 =?Windows-1252?Q?m6aeHEuCj/6Os18yW5xIh+EXupuZ7N0E/lgIcTupjYlfpDqRG9Gsdxty?=
 =?Windows-1252?Q?A5SBFjVabYes8BW2lgQSeDSlMvuhinVrudAhfDXOCfRnXYLfALJkRNr6?=
 =?Windows-1252?Q?JiNYQ6Uo352CKsTETS528miSoF9eq+pwsl6XcUiyUM+TbTMyM+sxhF+9?=
 =?Windows-1252?Q?L3MYXoLrA7GfOeZkWXNSPVduoCD6JYfEb2BUSCnNuNzElxfsd74uki4e?=
 =?Windows-1252?Q?8Q+ZrBLm3TopyLFmZrkqYh/FGoY9Drb4Y3996VrdsLBVvHgSiicm0GVD?=
 =?Windows-1252?Q?puxrKbt0Ldio6o4LIuo=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f28c59d2-1017-4c3c-d0a6-08d9d43eaf07
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 13:39:53.8440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C89TMHI79UFfW3xDfpTkX1TPTO3NCa3XVhZ/Y8i+7c1+lSGi2IHfPlAoen0no+ObnMQ3sk+qQ3s3C/Co3a6ClA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR03MB2963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> Now CPU port is not limited to a single port. Also, extint can be used
> as non-cpu ports, as long as it defines relatek,ext-int. The last cpu
> port will be used as trap_port.
>
> The CPU information was dropped from chip data as it was not used
> outside setup. The only other place it was used is when it wrongly
> checks for CPU port when it should check for extint.
>
> realtek_priv->cpu_port is now only used by rtl8366rb.c

Great work with this series! If I understood correctly from your last
emails, you weren't actually able to test this due to hardware
constraints. While I think this change is not going to introduce any
surprises, I think you should still mention that it is not tested.

Some more comments below but in general the change makes sense to me.

>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 53 +++++++++++++++--------------
>  1 file changed, 27 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realte=
k/rtl8365mb.c
> index 59e08b192c06..6a00a162b2ac 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -556,7 +556,6 @@ struct rtl8365mb_port {
>   * @chip_ver: chip silicon revision
>   * @port_mask: mask of all ports
>   * @learn_limit_max: maximum number of L2 addresses the chip can learn
> - * @cpu: CPU tagging and CPU port configuration for this chip
>   * @mib_lock: prevent concurrent reads of MIB counters
>   * @ports: per-port data
>   * @jam_table: chip-specific initialization jam table
> @@ -571,7 +570,6 @@ struct rtl8365mb {
>  	u32 chip_ver;
>  	u32 port_mask;
>  	u32 learn_limit_max;
> -	struct rtl8365mb_cpu cpu;
>  	struct mutex mib_lock;
>  	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
>  	const struct rtl8365mb_jam_tbl_entry *jam_table;
> @@ -769,17 +767,20 @@ static int rtl8365mb_ext_config_rgmii(struct realte=
k_priv *priv, int port,
>  	u32 val;
>  	int ret;
> =20
> -	if (port !=3D priv->cpu_port) {
> -		dev_err(priv->dev, "only one EXT interface is currently supported\n");
> +	mb =3D priv->chip_data;
> +	p =3D &mb->ports[port];
> +	ext_int =3D p->ext_int;
> +
> +	if (ext_int =3D=3D RTL8365MB_NOT_EXT) {
> +		dev_err(priv->dev,
> +			"Port %d is not identified as extenal interface.\n",

Maybe just a warning?
also: s/as extenal/as an external/

> +			port);
>  		return -EINVAL;
>  	}
> =20
>  	dp =3D dsa_to_port(priv->ds, port);
>  	dn =3D dp->dn;
> =20
> -	mb =3D priv->chip_data;
> -	p =3D &mb->ports[port];
> -	ext_int =3D p->ext_int;
> =20
>  	/* Set the RGMII TX/RX delay
>  	 *
> @@ -859,15 +860,17 @@ static int rtl8365mb_ext_config_forcemode(struct re=
altek_priv *priv, int port,
>  	int val;
>  	int ret;
> =20
> -	if (port !=3D priv->cpu_port) {
> -		dev_err(priv->dev, "only one EXT interface is currently supported\n");
> -		return -EINVAL;
> -	}
> -
>  	mb =3D priv->chip_data;
>  	p =3D &mb->ports[port];
>  	ext_int =3D p->ext_int;
> =20
> +	if (ext_int =3D=3D RTL8365MB_NOT_EXT) {
> +		dev_err(priv->dev,
> +			"Port %d is not identified as extenal interface.\n",

ditto

> +			port);
> +		return -EINVAL;
> +	}
> +
>  	if (link) {
>  		/* Force the link up with the desired configuration */
>  		r_link =3D 1;
> @@ -1734,10 +1737,8 @@ static void rtl8365mb_irq_teardown(struct realtek_=
priv *priv)
>  	}
>  }
> =20
> -static int rtl8365mb_cpu_config(struct realtek_priv *priv)
> +static int rtl8365mb_cpu_config(struct realtek_priv *priv, struct rtl836=
5mb_cpu *cpu)

const struct rtl8365mb_cpu?

>  {
> -	struct rtl8365mb *mb =3D priv->chip_data;
> -	struct rtl8365mb_cpu *cpu =3D &mb->cpu;
>  	u32 val;
>  	int ret;
> =20
> @@ -1839,11 +1840,17 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		dev_info(priv->dev, "no interrupt support\n");
> =20
>  	/* Configure CPU tagging */
> +	cpu.mask =3D 0;

I guess the unused cpu variable in the earlier patch belongs in this
one, in which case you can just initialize it =3D { 0 } so that you don't
need to explicitly set cpu.mask =3D 0.

>  	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
> -		priv->cpu_port =3D cpu_dp->index;
> -		mb->cpu.mask =3D BIT(priv->cpu_port);
> -		mb->cpu.trap_port =3D priv->cpu_port;
> -		ret =3D rtl8365mb_cpu_config(priv);
> +		cpu.enable =3D 1;
> +		cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
> +		cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
> +		cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
> +		cpu.format =3D RTL8365MB_CPU_FORMAT_8BYTES;
> +		cpu.trap_port =3D cpu_dp->index;

If you are going to do this, perhaps it's better specified as a device
tree property like the external interface index? Making the "last" CPU
port the trap port is not incorrect, but it seems quite arbitrary.

> +		cpu.mask |=3D BIT(cpu_dp->index);
> +
> +		ret =3D rtl8365mb_cpu_config(priv, &cpu);

Shouldn't this go outside the loop to avoid potentially calling it twice
in a row?

>  		if (ret)
>  			goto out_teardown_irq;
> =20
> @@ -1862,7 +1869,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		dn =3D dsa_to_port(priv->ds, i)->dn;
> =20
>  		/* Forward only to the CPU */
> -		ret =3D rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
> +		ret =3D rtl8365mb_port_set_isolation(priv, i, cpu.mask);
>  		if (ret)
>  			goto out_teardown_irq;
> =20
> @@ -2003,12 +2010,6 @@ static int rtl8365mb_detect(struct realtek_priv *p=
riv)
>  		mb->jam_table =3D rtl8365mb_init_jam_8365mb_vc;
>  		mb->jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
> =20
> -		mb->cpu.enable =3D 1;
> -		mb->cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
> -		mb->cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
> -		mb->cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
> -		mb->cpu.format =3D RTL8365MB_CPU_FORMAT_8BYTES;
> -
>  		break;
>  	default:
>  		dev_err(priv->dev,=
