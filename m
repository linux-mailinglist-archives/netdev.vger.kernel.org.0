Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF445BB4E8
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 02:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIQAP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 20:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiIQAP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 20:15:26 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E402B9D642;
        Fri, 16 Sep 2022 17:15:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hb2vfqmbkuUIFJb7dOorl9s6SDGRmkBEPQ0/V2fVjHogu502vxgWxURXIQGD1Or2azGdepTHPOTfpmVWNap5QRU5w1bJdtjM1wCzdTY6WZsa69h/YSccACo2RfBgKIwF1eTVBjPWwNPNAs2Snk4Mw7sRUDuqriocummRZQLRjlBOMDemST0VgPmbzkE7pdN4UTRG4mdGUZk9wr7MjEnjw/x4r2Ygw9+ceoxFD/deOH+8Wh7T6kFzFPPyHIBoDD+ShTFzOBJq/Rku+No1UWi66SIw33UJTcYtfKHFys7AQKV/JCzj7p0wdGYlZ3vZfQ0bSMwM3uHHiGag9CJ9bxZ4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnTG6Gh+kzn90FriUQiOeRbqsHN4OOipcIRLo54HDxA=;
 b=cPVASXyfTi4XyQUyFKpWbF1G4Ie48Ak/aeAOpzSInmQQUaqkczweXOcZ8TwE84VDMO/UUofQSPf22JiFwP7iRckma1glLkURKM+XPiI13j3J1KBbT2Cc20g2vnjvI6ZKBA6Wn05POVFcdvQTejy3VcUtUR+yqp95m+TtrjwPZtNzS5eWaUU9nbFBoc2jHr4oJ1rxOlWRXiPMCWnNOL2iSc0GLe8VH5fs3gY1HbuetdrKwJG/xQEY102RAApS8Mwxdc0V2+gCJot94e3klpzgr4wtXyJdNcePEBWJ0OPgyYQgWvwGMzu6NLA8VqvI7nlZ1H/Cv0ZzdqBTr2VeIqc6qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnTG6Gh+kzn90FriUQiOeRbqsHN4OOipcIRLo54HDxA=;
 b=mG/dpSTK5YKhm7xMoy0UOHqXL8kVXDefS/kf7sWccXVBpWDpv35Jz7d/DnuV4qUTcoHZm/31V/toUXw6INst0PyIcEP0Scztv/YQwiyW967SvUwCbBbkHFvuky7SndCebRPcGWUnnYowCw7ijbcEECyy48Jony33gkZoiEXxoxY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Sat, 17 Sep
 2022 00:15:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Sat, 17 Sep 2022
 00:15:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v4 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHYxGBYKUV8EatjeEynFu0Ch2i3Kq3izGWA
Date:   Sat, 17 Sep 2022 00:15:22 +0000
Message-ID: <20220917001521.wskocisy53vozska@skbuf>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
 <20220909152454.7462-3-maxime.chevallier@bootlin.com>
In-Reply-To: <20220909152454.7462-3-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7815:EE_
x-ms-office365-filtering-correlation-id: eecae46b-b5fb-4769-bb81-08da9841b68a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1oagfZTaN8p80cutx6JQkuD0ZzDWU3zN+YGsBLKaRWnqfEnmNkWggnAUpk0+2/Qg2BRZLtjDzpoFyCV9ihTuqZ2PNueTNcC8cFdslHLMAZOtZiPpB1BoA0mOOvhfpdYISaMyjZ9KzgA2rQiiSHbxoxlQKjIZ8avrC6jHDAIu1BCk0daMuZ0pt7t8cpyuoG2PWzvR+7t+UYpKprzBn6KfoqXTVPJuIOo+PXYLA+DTkOlLCpHR/otGsAIWG9/URjD5FMnmF3VTBr0RrzMnSqgLq5NWtFjtRAvp8xinPoQ/hLuVsojQOONJS0uQUTh5YrrEovHlVJ8BxrWk3tbz9qgVYf5XApaJYAHTVJoNYIGI3x54IAeS0xfZJVawTdIloMlDCxb4wxAI5Qp/rCvuLEnNWrxLJd3bhGdlOngZKZIP35uh/EgD6NyoFqGOfwMXuaHzEmE8pz47yc2g5QsM0o5cvArKjucw0OvocN65ObKdV4O6vmix2AjfyVmARI2aCLoA9DEm1IKWffWUBxmgxNtjLbgUyhC8X604Uh++Oku4vV561X6x2A12Xm4ryuRTPPG6W8fj/Ug9hZXzoCAs/9Z5iH/4ozlaa7CYhxk1NnYOiweItfYUgNX3k/MI2KkdORuhJt0s3D12znWMErxuS3uWFtivnl0gbgFKbU5szEYWuWWXYjKk1otoy0yCiHipPGUsjI+4r/Q3M1Pqfj+Mc1Af2/xpHPgpqfR8Iuv1Fw03w/3qrdwpAreG3OjPwgxUdeZh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199015)(33716001)(38100700002)(6486002)(478600001)(6506007)(2906002)(122000001)(41300700001)(7416002)(54906003)(6916009)(5660300002)(8936002)(38070700005)(66556008)(66476007)(66446008)(8676002)(4326008)(66946007)(86362001)(44832011)(64756008)(71200400001)(316002)(76116006)(91956017)(83380400001)(66899012)(26005)(6512007)(9686003)(186003)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XgvaS/fagbDA1i7+t/5um5Jf/imWnGKgJtfN/NMTJQw+cZ1nh0eVAWgkarkF?=
 =?us-ascii?Q?Kgk7W2uqhlc9G9hJvV7ftYSIHCzlZDYcnbYCvg/dWFBAmrUdrxQHBrJLtQod?=
 =?us-ascii?Q?BjvfiW7MQVezsfMu8Q/dm7zJ3U+MUinyKhDTQArxfRze/Kjk8NHA1k1EySwS?=
 =?us-ascii?Q?37+LYrMIE3RV3gttoMF2/ijO5XeKfEzTw1aQF3b0EL5ZO8WDuz9XbcQX3bmA?=
 =?us-ascii?Q?hNe9OrUmX/fiiJXRdUaiIM6xxmqESUgAcXw9rqVbtSSSWSq6jY7RjfzJaH2D?=
 =?us-ascii?Q?T8RmkSQwxHW/sjG9/GtBOjcu6jYU6tovnpmEGVg8rUS1PQudZ8ZGdws+NCBZ?=
 =?us-ascii?Q?4eRX89QDDlMPGHQWUVj3WfJwReaJhZ7sUTXBuJRIt7cYswsFhb9FFy6VhRzK?=
 =?us-ascii?Q?2QOqcPfeiAlB6wDJdb8xdwrXuwQ5FxB6A5vjeicCkzxezjbsmco3BRyVbz7+?=
 =?us-ascii?Q?RoOyazHtLg8IMbKyibJn2kdMNlI/RTjRYJ6QZAoaPZfP8o2ydtJAMB7bgafY?=
 =?us-ascii?Q?LdJryrXZl4+ykO9FunOF7itIEQAicv0FHXWEQvEik6c9ke2hqWNqnPhM3xSj?=
 =?us-ascii?Q?dUMRs3m2svtUrbjeFQ4cgkJdp/pB2J318GcRV/5Qcf6SMX4117jcKrioXLM4?=
 =?us-ascii?Q?CzpoIfDAaY0/oqxehb5qsAYVedekXsLd0SIR2dWls/jDB7tqWaFdXYmMk+C2?=
 =?us-ascii?Q?RRzw7Hte/DDWe4afwXhOfaWyhYNQEzg0wWOEwT2299ftocEd2crprl3hLxoT?=
 =?us-ascii?Q?LP9evNDo3wnAQLtvxV1tukRQq5+aJ1ssNZf4ujUWtyg70X3Rz9ggxQGlV8Ms?=
 =?us-ascii?Q?nyhnSnq2+NQtahcmNacuMPBDDk3HN5/YQiVBxdj2SyXRhZJ7NnpX6SezhLDx?=
 =?us-ascii?Q?PBhZRoNxxlWkeq+Xf4SggtqcYqERxiqlGWhn6ne0C+EG1rtho90nTQ+asI9J?=
 =?us-ascii?Q?Yx6tKH602brlM9b2eux9tX5pdBfWdL3bFleay7LCpJMk/ZjSmwR6yOVSjhm9?=
 =?us-ascii?Q?4TPHu1OK8A8gLTDINuQZ0Kr43kG8B082tPfCyQDLNtLhmGRyoYDGLJMVA33e?=
 =?us-ascii?Q?aApobqePGZlEQHspvN8nK5wjcJwOY4JUj+yZexxGR4fEmhdMr1le0hkoUosb?=
 =?us-ascii?Q?WO7pYD1XABm7ykAPn3JgJ1zO7i4mndxHwjQlrLiwb+QIi35cPnwsIoW2OWeU?=
 =?us-ascii?Q?vKa2iiU/JdUMtYgEeNl5WP9WySqHZGzbbTlPMZz+6A3QjNkjWmurfeecZQFL?=
 =?us-ascii?Q?MK8NKJrbG1u7oFwCl+9xUiEnFsuq7z84QA4A29KiMwbSwfEJs5k6l1cC6Z0l?=
 =?us-ascii?Q?xekeSTfLl25mSEPskjpXlJazGECMKWx3vFIszcnER/Pj4MQNHFOb7EQAZhmG?=
 =?us-ascii?Q?gosFHoEgFrgjNonqUHrg+YpUNIlE1VGE01vuApewm2K2IbdN2Nf7H1NU/bnO?=
 =?us-ascii?Q?4BGKBzAHxuFamzXjlgKOb3tOOQAahxK+eF+ffwUNXpjraW4KZ+4eWtW++RnU?=
 =?us-ascii?Q?7Lspby4Sh30OvhUyQ7KQcYY1IR547P85WtGGHvDVOXwWyZiRZtVQqZ8pocJo?=
 =?us-ascii?Q?5TppjbQTrwKT/Co6CjnrUO9u7GU1xuavmJMcqpsZZJwTqxhuVAS+sNlj4wz7?=
 =?us-ascii?Q?GQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <645D74E6B5A3C84480CB1A6114E4F10D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eecae46b-b5fb-4769-bb81-08da9841b68a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2022 00:15:22.8563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+XQ2JJnHpm7JFO4UEF4ATYVZvhAcsCVwOm7VqFSOb/ESE63hYc8hShGLoJ7fEJ8dSqnMIYjB/09n+kr2khw1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Fri, Sep 09, 2022 at 05:24:51PM +0200, Maxime Chevallier wrote:
> +int dsa_oob_tag_push(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
> +{
> +	struct dsa_oob_tag_info *tag_info;
> +
> +	tag_info =3D (struct dsa_oob_tag_info *)skb->head;
> +
> +	tag_info->proto =3D ti->proto;
> +	tag_info->dp =3D ti->dp;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dsa_oob_tag_push);
> +
> +int dsa_oob_tag_pop(struct sk_buff *skb, struct dsa_oob_tag_info *ti)
> +{
> +	struct dsa_oob_tag_info *tag_info;
> +
> +	tag_info =3D (struct dsa_oob_tag_info *)skb->head;
> +
> +	if (tag_info->proto !=3D DSA_TAG_PROTO_OOB)
> +		return -EINVAL;
> +
> +	ti->proto =3D tag_info->proto;
> +	ti->dp =3D tag_info->dp;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dsa_oob_tag_pop);
> +
> +static struct sk_buff *oob_tag_xmit(struct sk_buff *skb,
> +				    struct net_device *dev)
> +{
> +	struct dsa_port *dp =3D dsa_slave_to_port(dev);
> +	struct dsa_oob_tag_info tag_info;
> +
> +	tag_info.dp =3D dp->index;
> +	tag_info.proto =3D DSA_TAG_PROTO_OOB;
> +
> +	if (dsa_oob_tag_push(skb, &tag_info))
> +		return NULL;
> +
> +	return skb;
> +}

I don't have too many comments on this patch set, except for a very
fundamental one. It is impossible to pass a DSA out of band header
between the switch tagging protocol driver and the host Ethernet
controller via the beginning of skb->head, and just putting some magic
bytes there and hoping that no random junk in the buffer will have the
same value (and that skb_push() calls will not eat into your tag_info
structure which isn't accounted for in any way by skb->data).

Please create an skb extension for this, it is the only unambiguous way
to deal with the given hardware, which will not give lots of headaches
in the future.=
