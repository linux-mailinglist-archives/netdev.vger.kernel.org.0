Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E089745F330
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhKZRzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:55:21 -0500
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:49897
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229773AbhKZRxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:53:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWW7UqeDdX3wr4ml5KgK5U9ybcBQ5YrwJqBP9IKbBPYy1Mg80J1P3xZefWuFProDXjx+FMaZX1td1FsModwQuQL8YwWl6EuzCcESw+Mpo1uaiknTD65UMkUY5Dz3lxxcZkQpWCpgTrRHGZK6nRzS+/sQAE5qMkM/GicwjJn/NXHfzmVwR4VX6Gc67oVaWYzNlKc76PmMIzchCZnEYh0dgn4s7TDAumFoamqhKhqJ/YIVziJRvI7aeNcTzak8KGv9G4kG4vBdgcxK8xSsX6uhO4KJqm+4YVMf9zvJZ7K0qBXcLmLjKzoNYLdl28y/IQO2Aqf+99M5foEWySc02pJQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HE4EBpaOCmQakOGDzitaP3KwpT3kJzWPRuKSSwUN438=;
 b=R3//pv3wA9K6i/cRcYagFeDQAXYqmjdUIVuh9D7zUQ/cNQHTEuIg9TL61iHNgzLUeCJ6s/74G8uQLQHb9MiF/Lfli5sBilf08/wRcnmh5CU5RvUmdT7FBwkWRfUpD6iLn1zT+llxC09/h1bqWHS6pTrX4cYhSVZ5P3lie3tF2yqr4Knf2Uraq7EqMIZ129xKfhM1cH+i+svDjoloV0f1aRW2MtDc+bVvEi4uxbVSZDdO8kf6sI7/IwU0JppoBP0hqtFXvTCWaVW850lAKUtTAy3Fq4QzUe7f/9oDieoXLCOxr17WeVCUAEdnUlm9Kb4MKjVoC6XZIstCtl6O2aLBRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HE4EBpaOCmQakOGDzitaP3KwpT3kJzWPRuKSSwUN438=;
 b=BhUNlbbXy3C4gETXnCUxDK+DTo6P1vV+THQBhPoY3xM/zE4OSd38B5Uu1j8iCnkjPY0ApM/OJMokv3dPROehPCLJV4c7JIRT3MzQdDSLAII8KTIjmUBhwbh0mQqHkh60dHMHBZ/Yalhb69og21LF80xoeByFQNImRziO7KZE0NY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2864.eurprd04.prod.outlook.com (2603:10a6:800:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Fri, 26 Nov
 2021 17:50:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:50:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Thread-Topic: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Thread-Index: AQHX4uryalRRqJ6wdEegqX4WYakZdqwWFj8A
Date:   Fri, 26 Nov 2021 17:50:05 +0000
Message-ID: <20211126175004.6dsumhtepek4m36h@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-2-clement.leger@bootlin.com>
In-Reply-To: <20211126172739.329098-2-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05b540cc-1d24-46cc-6d42-08d9b1052de6
x-ms-traffictypediagnostic: VI1PR0402MB2864:
x-microsoft-antispam-prvs: <VI1PR0402MB2864CA416F18A57F26EDDEA5E0639@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dNPewgniGBeufwmFshX8UaH0xHMkLFpqx9ozQMwjdp9Fw6UPS2zNXE2SKiXEuD607gmoOTTyLHXJ/I7Jzxsd53dLpJMfVp73OUBeG1qx3UnLvHNMSdyj4xVGX0zwXZy0tCu8VEfXOzh2l++2Qcdb6UojGCNN8D/KXwqk4OR6znGJsCln8n14oIj5f154KuMcoBlDOpXpQO6v0Rol/9X+zpbcgdcTP7AieOrFfJOtkNKGufmP7W8DMqKaiur/cwP4snaAsNCw8pzUXrbMP8sbWXE+X6y+TCowkeJ6P61fGmbUJTZE7MQSwZXAOn+8ClewzNBPmK5WfP3kOhoyNTMFX+ojT+6kYHNkHUIX0DEsKUecFEjNG9HC5axmz87DEI+pHvBAnNqvSWmizXoQ7vZRv99yVGP3bw7wNkFlHWhIrTtCzRewmsR6t8rsRlktoy3ckxXK0/FaVT1s6VdYGBFs9K938ROuuS78+iLqWMZTCVEeoIX6CULdn7s68zbeNgzqKFWe+Th3vUgigyBOjCZO/xvvA6KW7426+vdQZu2LVRNHbkNF8f9ivqMc9R5/fgje8oaWNazZq2F6dP+pi/B2zIsrsoyj7CUFln1KQqSwJZ323byXq/6qS8aXWj7EoFkuA4L///a7KMRPO2v0v9yJnnVAIaOJ4oF7KV7BzHxiKOEv2kCS4RDzyxkYD0OYT4CvMB2lJKCM+D1DK0sR/6hYXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66556008)(66476007)(76116006)(6486002)(26005)(9686003)(6506007)(6512007)(2906002)(38070700005)(66446008)(508600001)(38100700002)(1076003)(4744005)(71200400001)(54906003)(64756008)(66946007)(44832011)(316002)(91956017)(122000001)(186003)(8936002)(6916009)(33716001)(86362001)(8676002)(5660300002)(7416002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4pASCljO6IpTcYdTqKscd34kybAsEEAVTe2Cn2oOEKeIdo5uAXS3fLRZdA?=
 =?iso-8859-1?Q?Wczumv/vZWqG91mNJfGPdbiAV1TvSqfB6N3qflDOgRYUQ29yDV1I91Xz81?=
 =?iso-8859-1?Q?AEWFHPvgIAVP3M62GvSITd5+2TixNwcBD9iGRGRRiPUz3B51RUvXNz5wh4?=
 =?iso-8859-1?Q?RrRkd6rgeeYqX2qTa8TdAGBligIp9Kz6ukeIPOSOJmwDv2u4AC8bVvTcOa?=
 =?iso-8859-1?Q?BVeSJWNVnhmDN3/T5FleBw82lz0BQKK2DXzNgPnjYYDyfdMBCgYs0NG+LU?=
 =?iso-8859-1?Q?TpjL0v8cdMb21ukIqJ3HE2NXjxPNupEOkMhbz1CG9U98N3jrRE1jw6WFq0?=
 =?iso-8859-1?Q?2mQeIfabOKhP/sFYA7/FnFVZDiICqncNjuyESxmR7RcBCWAGhBDXwqwKyq?=
 =?iso-8859-1?Q?HRWFaO83wOcpVbpwBGrCe6b+inzH+xYI6ujtI7hrudNr+mcgJDCjZBqqBN?=
 =?iso-8859-1?Q?Uo41rhrRX5JZvPRsSlfJ+udms8knf5sjZk2bjtFGHVeTXWDfiN6bgAouAP?=
 =?iso-8859-1?Q?mLQaPMUzYScL7scmB3Du/PmETkveiyy+QU2nMxzrOyMx2WzB9FlfatrdBn?=
 =?iso-8859-1?Q?Wwf+C3DWC4IJH/12Q1fzPAU429wHxu0RddJV+8y+NcJzbVNBrWI7mvBRGb?=
 =?iso-8859-1?Q?SO0Ji9H9yuxQ87KfyY0ivblN5YIByWZCW0/lcdUBM2SsjS0+ydy2iwGrwf?=
 =?iso-8859-1?Q?nLAV0LARVm4DaynUtOe6M/S3zdO5P/FYD31E7LoCZiXOuNo4EWebDXWfzj?=
 =?iso-8859-1?Q?DRJvV5V4IykY7PaNAICsfbwXU0LjJYvXQ3mBB+5uSUmDlY0Kh1JyKDlR4J?=
 =?iso-8859-1?Q?y5LQ9mARMwKuqmCDTMmKsJe2wolNwl/7QSNIky0J0yXIUq65pqPC18oxU0?=
 =?iso-8859-1?Q?xB5n8gHFU9nXOx+N8075yIICC4e0OohSdwgRQe5fBK5KweiJN5qRPmZl7T?=
 =?iso-8859-1?Q?Ixhko1kh35DDD+TFbM+B0esATCuLhhVDre4T0hV7lcpnKsvm357sDnmvdF?=
 =?iso-8859-1?Q?Nuzb5W96WjueU4FnQnnBWy7MQQSWlyTqBzLbE40O4gIS7CqKRMuRZSvaa2?=
 =?iso-8859-1?Q?W1IzLQkVVHfDDvmDM9xKzN3NfryDYNILJhBQM1vD6UKtOUT+7xLmvZyuZB?=
 =?iso-8859-1?Q?i8Exs6IYxRHVHcrJvpOJcWtW2dJHACHiBS436usQr7di6p23D1hNzNIxZ3?=
 =?iso-8859-1?Q?oWG85UdcSdLYC07mk92Qu7ta9fQoczhHTiV4D/7V9uqm036Huw8Hu2XLih?=
 =?iso-8859-1?Q?1wljmB/va5v6fH8u/fTcOVGLJkOGjulYr9/hayX4n5MdztSPCztEgzybqk?=
 =?iso-8859-1?Q?XfCbMwbPh4oX45apevBw81lx2VVPu3j9beK51nKlhgCPN1kyanab43S8ci?=
 =?iso-8859-1?Q?AM/AoX6HE4ik5tFcndKOAdn2WzqhHE2zZhgyeaZDxVibipLeYtSt5/Mtk9?=
 =?iso-8859-1?Q?0TuvlJwjI8HDBwOOSFInDFKX9Ci/J3mWPBYwGzMtA68Fq2V8TaBRzLIFRU?=
 =?iso-8859-1?Q?/hCoxc2yv/q1bLfJ7UIbUsFnzNwP/M/M9FKDEaV8uOSBujBhAaxB5TrT+z?=
 =?iso-8859-1?Q?4/DykcwgMBWlYYBGfWVcrGlf5LCGtX0solofljE6nc527DypmMsSVKUDlV?=
 =?iso-8859-1?Q?Psvwut/gdCrUwwQI2mW7HbAwUYNKXwE5ugaxt3LvkkniyfNO05LjXjuPqc?=
 =?iso-8859-1?Q?N3bMAmB+z4gFTNncUnE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <D513B487C0692D44AE17B90F048E454A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b540cc-1d24-46cc-6d42-08d9b1052de6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 17:50:05.0905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bvq3unbDeQE3Nh3KIgXb6utLsPcEOKNRiptuzXLDLe8VOZd7JDf2dqSHWcqJEA+TJgjg6NzR7gMiOGVmZZEGTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 06:27:36PM +0100, Cl=E9ment L=E9ger wrote:
> +  ethernet-ports:
> +    type: object
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    additionalProperties: false
> +
> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +        description: Ethernet ports handled by the switch
> +
> +        $ref: ethernet-controller.yaml#
> +
> +        unevaluatedProperties: false
> +
> +        properties:
> +          reg:
> +            description: Switch port number
> +
> +          phy-handle: true
> +
> +          phy-mode: true
> +
> +          fixed-link: true
> +
> +          mac-address: true
> +
> +        required:
> +          - reg
> +
> +        oneOf:
> +          - required:
> +              - phy-handle
> +              - phy-mode
> +          - required:
> +              - fixed-link

Are you practically saying that a phy-mode would not be required with
fixed-link? Because it still is...

> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - ethernet-ports=
