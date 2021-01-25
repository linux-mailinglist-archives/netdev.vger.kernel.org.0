Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26965302579
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 14:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbhAYNZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 08:25:56 -0500
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:64000
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728789AbhAYNX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 08:23:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h26e/RTkYhxpbRLxuUYdbcinu6lYU3/lPoCwUGqLgl/vO/TfDKsqgH/oAJ375VAt+GEGDBD+BXdvkqUTZENXW0h3NE9udWzA9QZ0BwHb216rC3rrB4hPN75hPqTAEL6cXdJxXDTEdnj7Mxw6/K2M/Z+f1T4CU6/q7GLANSLZmxITEfa3oaRFYYQXJT2MH0MQDhZmYmEK7hZPvZK7a9PdXaU0InSbZwjaipgj3FrGMOquEBmA8TqSBjOtl5sLSPjUxTpiKgoGASLt8uheeWqU4lUUBhNmy2ljq+7y/cKXYki710IyPlFcRaPG3+26i1LqSedcpXUIYNfI0aSXhAG3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRlAEqaS5kzZtTlXrUTKD9//yLHMKNCM1LtPSQlHqNA=;
 b=bHch1xdNlBoQrU1S7YdRc/ATKLFUdL9osnNEjShFQm2qGQVcsTiuuarC4j1dmAhbSVolA2amT5EtcjHRC3OX9dXOft4WN3cNenutJu1xvivAk6yiHWonHZYVWjj2Uc1GzwgEhJo9ndJqDFIn0xcemYUXTNBZQhKXKpcr19ZV1Dr0fKogOE6XePqhdEmgR1RCKcRPZHNqnoPjRuO6pmLwkWewYoDCXZKtOmYnUaV2EHj5SCZbVaoZSwk/Xx6n1mDeOvl78mmU+VYdnCvPUK/ya8F1pIZmuWo48aOptUAXu+0rKJnAtACq11s5kFHQJpg9aCA0ZvLf6/+n+T+AmaojUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRlAEqaS5kzZtTlXrUTKD9//yLHMKNCM1LtPSQlHqNA=;
 b=h59sTK6iZgA3F8Jrp2LBlmuc/y6aL56ICWe0c86b2rVEXoRc1w3V6Nlx/0SdVYULfQqySq9agGG3DeaAml0UgGcgz0LxkwR6sm+vRRJhEWV0BCHv9j+eY25jxEPOlE5mHpAskYcSpTsIFzuJPYUO79uX5GZrWxaQELplkiI5gZQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3197.eurprd04.prod.outlook.com (2603:10a6:802:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 25 Jan
 2021 13:23:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.012; Mon, 25 Jan 2021
 13:23:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 2/2 net-next] net: mscc: ocelot: fix error code in
 mscc_ocelot_probe()
Thread-Topic: [PATCH 2/2 net-next] net: mscc: ocelot: fix error code in
 mscc_ocelot_probe()
Thread-Index: AQHW8vIB6h7I1Bq+YUy7tkic5JXUWao4VIoA
Date:   Mon, 25 Jan 2021 13:23:07 +0000
Message-ID: <20210125132306.czc7thwgd3o3lbnw@skbuf>
References: <YA59en4lJCiYsPHv@mwanda> <YA59n5DbO0BkK7rv@mwanda>
In-Reply-To: <YA59n5DbO0BkK7rv@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe2bbdea-2058-4d94-8114-08d8c1345a8d
x-ms-traffictypediagnostic: VI1PR04MB3197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3197A39DD3DD5FC6BE5EB977E0BD0@VI1PR04MB3197.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:565;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CrcHXvORXEEfQVf7DGnhKMknyryksWclWuadDo6Xc6c7auQOfvHW/FgbOgfUcwvGxLaHphX5/7Tz0YoK30X0vrPQImW5+F5QuUCLS1VxWK7QEHYqkckxA6PytJbJ/syXkPPEh1FD2Msuk1OuKAEn3qMFdJWsRVRT/MdSmZTDvlTh5xVxR8ybMbDMhkvcL8Pvo/PY/GVdX3Ai6ebHobu+TB8T00vg8KgIJXYtQNfwaIcr4Fdum9YCO/PgW3puPOpQYQh583Z4n0LFSg28r2iSRGGKIKb89VQNVs1SWbf4i/rd2BtoE1dgqbpJlmnih81qoFqHlGo2EAmfLLFFQiSlrWQx6eb7HZSNqbadnExm3gJs3FO2KD8WhnQfUjwNq5b8AMdOm46YsLtTSMnPLkSFcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(39860400002)(396003)(346002)(136003)(26005)(478600001)(86362001)(66946007)(33716001)(66556008)(64756008)(6486002)(66446008)(66476007)(6512007)(91956017)(76116006)(8936002)(4326008)(9686003)(186003)(1076003)(71200400001)(6506007)(316002)(4744005)(54906003)(6916009)(8676002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dr61DF4gI0j+YWr7G8I8Wf4E+jS41vSb0lAxEwx7D1ExasMxNMCnaxAJRF8d?=
 =?us-ascii?Q?PuHA+MAHOZTkkS/3lP7m1MAXTnpHQJeMlhLuIDXG9jvKKQzyMBcB1A7CeIoU?=
 =?us-ascii?Q?K5/NsMISiUOd3IssXSduGm/6BntD+KaOHrLGm0ZXfV2DkTW0oZ/FwzJFGMe9?=
 =?us-ascii?Q?flA2DPnSlfzE+YWlE2Jq62lm0j/xeUubkXL9v7M575JHdJtKQK72glVOOebF?=
 =?us-ascii?Q?Qb11ND1ePIX7TXQEnaQqV0i5hOnMik15luNIKqQmsBJq3fBd8HvfcA8+/9Nx?=
 =?us-ascii?Q?pglMVsiYl/9rjxfVSJi+ilNzCUOCTIX4TZt+VF6nMxXvefJeK/vt4/0FzTfS?=
 =?us-ascii?Q?PiAWJTeDYL1qUgH1WQUI2G6vm771zC7PC9PLuj4XvRaZLaTitFWsX3TuWkxz?=
 =?us-ascii?Q?H6MR5lno/w7N4wjmvVBjjUMYUi75m7PQs5Mz6E/QriN92/ysujpjCMTv4qQ6?=
 =?us-ascii?Q?I37IGmjhMCdUthU86qgG16KFCdN1nbBUYb/5qIVqsk4jTYJEncxCzF/U3Fw4?=
 =?us-ascii?Q?EFqdw+kwisi44cJZIhRSl4DXLq21I8N7F5HtOYEVN0bETHMOMl9DkPm05FwL?=
 =?us-ascii?Q?0TJUgSIzZ52YC7e+q1zULdHJ5jV9fDAqN7lzsmWWXSi8laeU+fb+dWDatfDN?=
 =?us-ascii?Q?Y2hu2eN1A5VBOqfa4MRQxbHWFWeESTWDXgEsl51ngr2RzsEG4ILrjmQTUhbY?=
 =?us-ascii?Q?ii56tAcUhmvRfUuE/aXLCqwTL6P9gahsQBw7m+KO6RBQ0SZ7cROFyOmx5Pjt?=
 =?us-ascii?Q?xX4mVt4d5D3ebLopK+JS1J0TW4p349tSTFe0maNyoq8NjIYHJbm2DITaV9Wq?=
 =?us-ascii?Q?mb7tivlJKmZTqSwqgBspfChYztQpi17ioXD+IqVGNRMGDvNejLr6raKMnNKw?=
 =?us-ascii?Q?zYha7vb+qK+0XdCXFmHjG4qBicluaUEZudNSEfky83503lvZqfHFvIcLJxh0?=
 =?us-ascii?Q?UGL6pTUKlZY3DjSUe8JD9+2HvW2LSTYjUvFHGuoW45dusp6S39MlOq6RcTC5?=
 =?us-ascii?Q?tt5++hShIqrSiUwz2C9kLMdZLuy1/FTfViaWk0jUCxoJm2tdd0t7wzo8PcrB?=
 =?us-ascii?Q?oa50dFX8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B138E9780D20E4D9540B8764D0B4C2D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2bbdea-2058-4d94-8114-08d8c1345a8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 13:23:07.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +zqBNvSoauBzxnhHyHUti2zTTAe9Syrb3QQiiLXfgo+s4YLzkA+DtMmMfjXJg+wxZr70oVroeiFWm69u9djRhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:13:19AM +0300, Dan Carpenter wrote:
> Probe should return an error code if platform_get_irq_byname() fails
> but it returns success instead.
>=20
> Fixes: 6c30384eb1de ("net: mscc: ocelot: register devlink ports")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
