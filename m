Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7055BD801
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiISXQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiISXQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:16:22 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2040.outbound.protection.outlook.com [40.107.20.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29562386BD
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:16:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kunfdGaY8ruMk9ShAGVN3MgrUlocPKdH7tp+ZbB5da5hXQbYFoc2jrV0duqSGlPg7sxDcXtHFyZhs9dWKv+efx3UaAm22HY4/CKtbAY2b1lDPYi20Pjd9gaPCYybVnrz3gnpDA1YufrW5/tPxeUm/CNu3w49Drpt9POj7d2dNcouNf6F2Jmdu8J+KSpfRYnZOkdM4feaLUkutkjN3O2wDa7/a9MPrgZjLJwdQ49bxWvRhONcEtxPxeshu4FQVZoebCAl+a+6ajUdV9JSjCzUjbCKT+FAh+814K5Gr79Alw92AEt5587Xa0SZZTGifNXhmBovDJuJpORxcJB6BORdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdWN3VHS1RqjXFPepRxWhTQZ9TNck7pZmWQCF4ZYQxE=;
 b=gwvphsflUNANKG/I9FwhattTM1BmC4h2LeZKNZx4r8cq0M2wCjZ0eczzX3CkqKzxDlpwYV3X8vlyj+MLo/EmJBiQn0VVv/WmfYihPaSRTa0F2PIWBbg4DF8tbHLnqSRmvcgG+UT9fsqOSiG/aNDEA6p/t9kgdvkPvxra2d1RKgV2YZMMWQsG8hcPZfWNcADBiJPCSw/eoz9JfDzTlGCJ13XSev9oaVy5YKdYRUiUdrD/PbftclCfSAn8EijTnOCKG6ajpjAjKigUO5o73Cfx3V3ANQLFynrHAbjob6gf2DeerdTrqFhIxPGbnenCLU1ljvznydGAjsnuEWFyWtu2BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdWN3VHS1RqjXFPepRxWhTQZ9TNck7pZmWQCF4ZYQxE=;
 b=Tnb6h9mvWEVyWX5LnEGXKQ1AvOOfGyj6CO2eIFRr9EVFJ2VL54tB8NvarW27p1PVoLBTbZ/6cJkPrJqGW50wD2u51xgaz486jOoCjaLqC6j8bCAd6ObnaKoBOqIn02V8emuh+eN0KGnTwbliWJIf2K2+yPXihIghudg2WW+dhvw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7318.eurprd04.prod.outlook.com (2603:10a6:10:1ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 23:16:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 23:16:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 4/9] net: dsa: qca8k: dsa_inband_request: More
 normal return values
Thread-Topic: [PATCH rfc v0 4/9] net: dsa: qca8k: dsa_inband_request: More
 normal return values
Thread-Index: AQHYzHXUsyedrDPnEEqlmyAuzhGWP63nYrqA
Date:   Mon, 19 Sep 2022 23:16:19 +0000
Message-ID: <20220919231619.f3vyzq2acbtkh7ok@skbuf>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-5-andrew@lunn.ch>
In-Reply-To: <20220919221853.4095491-5-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBAPR04MB7318:EE_
x-ms-office365-filtering-correlation-id: 10ed08fb-a713-4f49-a608-08da9a94f60e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D4yYu98vbptHwX3WhZilVHLSJrtPPHTmRox2ANzGVEQjKvPYFx5onyzxmxgpf0fMkZS1vYbEzNY8FxM5XF/fk5Xzg4uBSRyVG/TaMYQC9qR3VSzRYHoWBZZV5PlQzXLKIhP5UXUCG3q89l8eFvZE+mM+iZUWPmRLVirkKYSvzxnfTFOQhRFhglJioFwSqtJ6ouCW4R+6Tk67H9k0c8V9xChETg3tqx8+Vq/PbbPnZCx+MDizFmoOBY8U9Q9sOtoyfrOHfx9GVLHr7wc0mwGqVt0tLITTKuU8buu3N8veV2CI/bM6POLtkQStWVPyupmT6XwozbFRaqFMk6OfiOej8xsZgmWAVfgA8nMOtPBlAR8GyJS0CK/ijwCjvo7zgbR609X+IJyrKKfs2tkcEYwC0cv6nw5B2K40spxOSY0cX2uNnBVKTOlvXkytCc21XhpGidf05aNK6jCg7S2r+njdBdTGS9vxcaJgCewsHy0keoejV/eOrr0UoFrv5m1lJfhcKNNL3Tp5rArZ+34O3eKo8XO0fYizOls5XuPYmXvREx6MnPMWJaelXcAMkKMwtHBfRiVHKkcXQm0QA07mJKpdcKt7jGrNF1d+egAZPhbOrVN0XDM0euD7XY8bNY7x2Q6vS1SoWX7Sg5vSEb6S70XevBKh4WlEgQ3RUdiOW1jbrz89Itc65C64JeoRvcBbOYhVRo2OYkXYMs9tauBdTM1CQJR1QwAbt9a1C+7SmGCBE/8MpyRN5x+TMx7WM5kvKdYjNUFZRuJuvxMqhgcifVr/kH31bfz+Tt1vQhYkdvq0c1k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(44832011)(33716001)(4744005)(2906002)(122000001)(316002)(8676002)(38100700002)(4326008)(66476007)(76116006)(64756008)(5660300002)(66556008)(66946007)(66446008)(91956017)(6916009)(54906003)(8936002)(86362001)(1076003)(186003)(478600001)(38070700005)(9686003)(6512007)(26005)(6506007)(83380400001)(6486002)(71200400001)(41300700001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AV20pxIr0ozcj4Vutyf8iL0NaF2BGlLNVN4nNw8kf138pwSjrr6uYUE3TxGA?=
 =?us-ascii?Q?Wv0FIHFfnMMvY/gkX7NzKOJ6M5g6Yk0M/cWGvdGzafzH9vHkhGGXtbO5lgJB?=
 =?us-ascii?Q?Se0aj5as2N/YBRTF0bL7UKsvAqfqVhxipfLOjWPv8lCA5XMoVcdizeX04Rqr?=
 =?us-ascii?Q?uSdkJdh+RTR5B8wmeuwkU5F0FDM4EAqPnLgOegCPj1FlFKla4MaHNfhAU7SZ?=
 =?us-ascii?Q?zQab3vnYYzeVXq1Z+1jgGEnEKEiLZ9+8NvSZEyMDxzxtR293lHza2euFL3+R?=
 =?us-ascii?Q?5FDsjexzikUVYSInmrSCdfKEJVtI5MvqCPzOudzrX1Y9ptbV5pouFsdK+GbG?=
 =?us-ascii?Q?oeizpXxqD8ZWgH2PaQ8boGBptCiiI+288/NCKaNRpskKdrdeB9GZiUhcC8c8?=
 =?us-ascii?Q?W/rWRKVrmNY3H9bflijlQoM6luWFtA2iQJbpmwKW8a3Zc1+FNyt3l5YDYQkH?=
 =?us-ascii?Q?Cn6lSBxoFaiKXv/LGTsE73//p+FxSHo0rH3lv3rw0JZwCAGDAcyHYJmuTeY0?=
 =?us-ascii?Q?R+C4tTSKLEo56geK2NRs/0T0GATME7ynL3VjPGrOeQmijpRODFWY4I/NZnxg?=
 =?us-ascii?Q?Qf1oXtGC0hAu5Sh4mnax3eS83QHVE9YVmSP1uETmfccbSFQ6qKrKE6oU1OcV?=
 =?us-ascii?Q?oTRgSD9jf4/U/wc1LZ5N+tbm/xSocFCas9vsszjiTCzDhUh4Li2qAz5aRVkn?=
 =?us-ascii?Q?bhZn9nNy6ngAtJM2dUPBDfYUEgm7pvWeduOFXb8CEyX7wFjmema4ZzdddIZ1?=
 =?us-ascii?Q?xbqo/2Vi3TClerEQScTBtEMe2DbJ/vugwW+qKVWMlBex88GvOQSM+vTXOXaM?=
 =?us-ascii?Q?3Fg+GHzd23v6Str1KlNu0Mt62bms7wzvpLveVtW/WhSOJzP+RMdXbicRdXDy?=
 =?us-ascii?Q?wCbIzYcK4+JUERxGPdlVlWXokoy04oZtWwecg/Pa4iIdvzrDkCcOx0DZGfK0?=
 =?us-ascii?Q?YGVVmmNFSZY41xN4ASW2Of70+Dp3rSSXONgVl5v+jetLmCv/nj247xLXi5Vu?=
 =?us-ascii?Q?fq31jDcyfHG69NOzCwoYg/ZN/3g9AVFcAWA7JPPA+tHuOoaxOg/7Ur0gJEUG?=
 =?us-ascii?Q?ZycaG8KgVf7BhPILX2xqiFyDrs6CS9gIQoPaJaP3c6ZBwRT/mvv+gGbf2KmG?=
 =?us-ascii?Q?OBETFaugs27A1IP0QnsXw6uWVVAwKrZ3R5BrfogT3DircZnJvp5GgcRjthR8?=
 =?us-ascii?Q?p6FYo8AF0WGPQk3MWGk0e/7eSpWtHz8avfDvy/m52GZ+7GSzAsocZmkcfKjX?=
 =?us-ascii?Q?lzkVYQ6JHWYoQMUiYfBHr0s4ZHmdj85mI7LN4zwdgI/uymH5FQC9v5SM8LUj?=
 =?us-ascii?Q?MqTkhPpvDa8bNL8mAhpdgPn9AK15mm0A0qbdffz+XSiyrIc6Zvkc2ro0GEZ1?=
 =?us-ascii?Q?uj6+a+wtuCni1k/BeZJNM/VkgOkS4BHn1eJpVjZQH40HIFkwKtORi7koXqvv?=
 =?us-ascii?Q?5nWi2KyiB7PkvR2EGpEi8a1LIaRnwJBuuJfcilLHhE2ZYpX7oik9A6ZQwyRP?=
 =?us-ascii?Q?WNDnVHUAzs5NOy3saQ3Xs5fRGvZu0rS85I96YEFdAsXvRSogy8wVpNgoqD7w?=
 =?us-ascii?Q?G9fUr2ngoyXokJexLFRZnoPPuzoViqHs9PnQTKrINumrbrYHAx0Pg2U+0edq?=
 =?us-ascii?Q?BA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7CFF478BB0FD194C8EBB0C64E9B86778@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ed08fb-a713-4f49-a608-08da9a94f60e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 23:16:20.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8CnKb4KVzwqwjSLz27sZjhA8s0NHswoDSQEK/W7e4fgTupn8zxVQ/SFnwvmCOgCzQK0i7WRRFO9XMasKTLLrDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7318
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:18:48AM +0200, Andrew Lunn wrote:
> wait_for_completion_timeout() has unusual return values.  It can
> @@ -591,8 +588,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool r=
ead, int phy,
>  	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
>  	mgmt_eth_data->ack =3D false;
> =20
> -	dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
> -				       QCA8K_ETHERNET_TIMEOUT);
> +	ret =3D dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
> +				 QCA8K_ETHERNET_TIMEOUT);

Ansuel commented in Message-ID 12edaefc-89a2-f231-156e-5dbe198ae6f6@gmail.c=
om
that not checking the error code here was deliberate, and that when Mattias
did check the error code, things broke.

> =20
>  	mutex_unlock(&mgmt_eth_data->mutex);
>  =
