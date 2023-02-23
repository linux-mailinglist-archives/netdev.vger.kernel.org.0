Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07386A0B56
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbjBWN6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbjBWN6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:58:16 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC262BEFA;
        Thu, 23 Feb 2023 05:58:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/MYYRYQhgQ8wH4et/e0xT7DLEFzDtyE15EZh/y7bkqgHZbJWZ+oaqz9twUYJAL8PGNovSwTV/T7YfRUy4mDzrkaye1WKqWAoLmOWdzaimGS+T+/q9EjTFips2GWYvDiRyNrl1Dl5LbaxN1T+wzSG4/irg/RYeZbg4NoQ9ULLQRAazdAqS72oi57JZnI1RnIA5j0w4ihh6arcaVdH3cDnkSzww+VqVKhUFHpDLr52T6A9JVrooyIXkN8cGZ+H5VZz8ouAX0VwQ6eTheL36mtpSnvpTI6IqW1cNRkvhfbG2asPx6DTgpKqPhF5rkuJhCrczNRsX/tarXYbdEfGHOSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5V7PTdldgUaWiiPTuwQxN/PSC5ZoM4nlOb0akVEh/rU=;
 b=LN4cTWkUeMgA5pS7fOYr869SiHwqa0xRBoH+XzUg4bD0VEiqIH72sxefSiZaZRsyCb42TWJLaCNBRTnG4tEVWwkMzjG8KGnq4acHmVFe4unr5cleTuEbf/IMJhhUrinZxgk0fgmYbxmtJwczpejKXu3z+CWbtCw6xqsJt9xtdeJ7hV9ZatBcfP89blUocHRwNIqLWdSqvMU5myLxlZvaWACIJrrn7ywMTY56ZkgfloN9MXrf+vuR8BOdbELpeh/vVcDP1agh2zY8cIEXNeQ/4Lgeo0+vrpyzk2gA4gy1TaYTzr99QJNrDdC6/vLU94DDDfIQkJcA7gSKEdM7BoY8hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5V7PTdldgUaWiiPTuwQxN/PSC5ZoM4nlOb0akVEh/rU=;
 b=eu69qVgQEXSjsQZMvFOBDp+FpPe9oNDNFJqXfJZU/zp9/OSlbZD5MpjOZ7o8UM2JT3KMnG9Wg56B45pffzWKtM83OEVgLb8hYK5SSyiPJ+qpYyZErFFTyDE/OdM08KQqLVro+ScCj8oYzrnrw4uz2u7uNgV4TRk8UUmCA2I78uI=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PAXPR04MB8973.eurprd04.prod.outlook.com (2603:10a6:102:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 13:57:58 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 13:57:58 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP Bluetooth
 chipsets
Thread-Topic: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZR47WI5L9LPEda0u8Xg7hQHxHDg==
Date:   Thu, 23 Feb 2023 13:57:58 +0000
Message-ID: <AM9PR04MB8603BD23BC407407316E928AE7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
 <20230223103614.4137309-4-neeraj.sanjaykale@nxp.com>
 <Y/dEa6UJ2pXWsyOV@kroah.com>
In-Reply-To: <Y/dEa6UJ2pXWsyOV@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|PAXPR04MB8973:EE_
x-ms-office365-filtering-correlation-id: 5daf4104-8ae1-4e5d-d038-08db15a5f883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4NmZYsT0eX7s/S2EDvZjNvZAekzFHK4VWB0IPP3KdXIuMRahHIPoLXHmFBS5eX00xRyharsbStgQEnlCbfy7+ZbwFbay9Dyq0zRklGgypi4grXUeeo22C7PTTP5bjkdlZR2QoZpRk13evVYzCOUJuPPrGbFxs+2SnucxUTTPVVq28/ZTeK4LcIWlIl0xh2AVNPdQ8eozwQEDBr61WmaNqWFk0o46QdmWdPhpJJTbl1w3/FSCn+3+23g1/gfux4D9qYH1LBw2I6yrYcbW1vJ6DRdJzKlejAltb5ytSpqnAcBx9svXQi7xdael3P2EFv2HgLjN80ZwBY+Nzc3m0kQ69J9wQC9j7oWytP2jLXroUlZQZj8WDhLyy/t6YOGAW2h98CMaZTDlIOE74OuD4PM1nOkeaDdl+lKvyxx2MU4wn03vhhwMqIAzNWHrqCNjkjcg/v1ZZxrlaJXz4R3C82nRF+Lb4f6LTOFiw44vxny47G1cs7Y3859kHOagzlpTtslY+Xuzdhq2KrAA7ktatYRTGciHFfPHpNUsnXo+FpWVp09yhY+UlIoqj3+gmI7nMpNL2OdZwW+fMArfLmYtaA813EhMeiKS/q2JrtCnu16ks/Xc4V3eKKlmGu6UNC5XjfmCQxowUV4zuBb+qaFWcpE3OhY+MmhkvgvuDtgcbPb9gBfm/WaF7wOS7mLMdsA8Xg1RJLlFgWlrl0jEa7ZdWE5+kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199018)(2906002)(7416002)(8936002)(41300700001)(52536014)(5660300002)(76116006)(66446008)(83380400001)(66946007)(8676002)(66476007)(4326008)(6916009)(316002)(66556008)(478600001)(33656002)(186003)(26005)(7696005)(71200400001)(6506007)(55016003)(38100700002)(86362001)(64756008)(9686003)(122000001)(54906003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kli9HR7Me3hXk2y7rq3/BGwwPJyrrQJtg9z1ef+h0QaEV5nAvJkEg3QfevOk?=
 =?us-ascii?Q?AG0XVi52NljNepaAc9ux5FSjd+oW+YmHeWtUEnyMSNWNTXjhHCFVjxCNZWj6?=
 =?us-ascii?Q?aicLo48L1HQEJbR8HRGMkvDXzvg2Bm7a6eCJ967W8PftyRBb6PlTPAAPwhlp?=
 =?us-ascii?Q?euDN21OEPbYY0h1xLpPh6B+sc5MqwKxgzEH6PuzBilzwGPu7140PUylgr+6F?=
 =?us-ascii?Q?zAtKpmon456FBSZbQFimTfL2lTXZUzr9Ai3PgjuzKZtkyw96NdloHT0R60MC?=
 =?us-ascii?Q?MVh6yRjJtKvcpBAgxgHo4a/ctGMqNLINIgAWayRXD0W1W8dkLjoLZmKc3nhs?=
 =?us-ascii?Q?1IK4+7dibuJihDAM4cAbO/xeeK7S+1zodx+U7hL+CPQa1veEggoXU52QQAXe?=
 =?us-ascii?Q?U8+Dt6Db+bcT+bL149U/VCSliCx0xMIyiZz6baNtNxK17edAaBZfcSw1mrcR?=
 =?us-ascii?Q?u+6DugCNnvE9Z559yqMJJcn+GZvsKyhz85n+1U2h5OJjsGWpHRnf9F4m6G69?=
 =?us-ascii?Q?oBl+PQGnC7WDz42QIhOBJBL1PRpTdqSCOt0bmgmhsmQB3i9we0Fb+DlGksfP?=
 =?us-ascii?Q?aylMi56JCMdIn0IhwQn1w/F8rk32BVB5Pw0qA24mGxHNHpN3nxROkmXr6Cmq?=
 =?us-ascii?Q?BR2tlgXoXcphTI++YaS/JcWjpjVE6qlg2bguU/FC6KuvkmfxcWbdJyp5+CVW?=
 =?us-ascii?Q?XzNZs4Juo8ieXRk+egWA4s61wCZG6er0j61qEuE5U33h4b7cjglWfuw6X+oj?=
 =?us-ascii?Q?RruSadQfTPZGcTgc2cp6rEMnUbLF5O6P3wXaHyHrFcd2RB8UCh2DgC/DOOXZ?=
 =?us-ascii?Q?PRQhIAXNdKjM6XhAnBPs6g27ZD4yoTJ4MgYoxMQfG/jjokvc4L4TplSUs08s?=
 =?us-ascii?Q?wLFYQcA0EnozFA0njNrJ+CHAq19CK4+KYtgteCkqqR6uPLVqC1/8v4GNmeTI?=
 =?us-ascii?Q?q9IAa9RgI5amnMfBqZh2cuqSS0oj/wvBMd8qxmqBYd9XINdeJ5bq5QKSZzJ8?=
 =?us-ascii?Q?BToPHxZQSoDtTTJXf3cRl8yaS5P/GjiUCuHXSEjTq6ajveUFsIi4v8aNP3w0?=
 =?us-ascii?Q?wsiy2DoE0movHgTKlaIyAPXuVTtzFg/i0UdoLFwBfbdgrIflnSBTQSMo1pxZ?=
 =?us-ascii?Q?BubUsewPcxFHQLHZEvFXtjQFGfonIw5Qo5EqZ6NuuNny/dNZaEwdEfIkHJrP?=
 =?us-ascii?Q?XyHadyVWMuyff5Kb/Db6Fvg99bHTHgPmX+stDA36GCZM8fWpc2Ma6WsHpM1v?=
 =?us-ascii?Q?roePdoMRTmPKwIKEQXVCPwpssMtkVqi8yw7RjO8I+3/qYIRLCig/zyMh03bz?=
 =?us-ascii?Q?z7Js6FDZv21VMBVFrsRaTQ4iRFh5YDB6e0+4RD32qfNexg8pe3KoY2V5Abmx?=
 =?us-ascii?Q?6L53sGgcig2+Dobi9xyhZ6OT05a17swNauiTiW388FuKoVeIKOiDzbQTLtuo?=
 =?us-ascii?Q?ADD5rIF/YuE2yPa0ML9qnlcXDH4bzXIuE9NESwfAg//JC9oclNmgyIAbHOyQ?=
 =?us-ascii?Q?frBjxwSrNFP1rcBu7lqjd92hXMjdaKtndlgmpQ1Oyu5ld5BZSDuDw0kmjCEN?=
 =?us-ascii?Q?KcsOpyALINkosfwQiJtuLFyrpiH4kbJRG695UzvkdaX/1Qouz9otbsozW/jp?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5daf4104-8ae1-4e5d-d038-08db15a5f883
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 13:57:58.5763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SHs/00SSLmMgM/kDEOx/oaFWR4mc/E1XKGMiBeKLsNXLtj9AohO6oklERuY9/Wn37l8gKIf2ENwvQP2lEP9PodcMUouySl6QgwUiJMjQ6TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8973
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Thank you for your feedback.

>=20
> > +
> > +static int init_baudrate =3D 115200;
>=20
> and neither will this, as you need to support multiple devices in the sys=
tem,
> your driver should never be only able to work with one device.
> Please make these device-specific things, not the same for the whole driv=
er.
>=20

I am using this init_baudrate as a module parameter
static int init_baudrate =3D 115200;
module_param(init_baudrate, int, 0444);
MODULE_PARM_DESC(init_baudrate, "host baudrate after FW download: default=
=3D115200");

We need this parameter configurable since different chip module vendors usi=
ng the same NXP chipset, configure these chips differently.
For example, module vendor A distributes his modules based on NXP 88w8987 c=
hips with a different configuration compared to module vendor B (based on N=
XP 88w8987), and the init_baudrate is one of the important distinctions bet=
ween them.
If we are able to keep this init_baudrate configurable, while compiling btn=
xpuart.ko as module, we will be able to support such baudrate variations.
Please let me know your thoughts on this.

Thanks,
Neeraj
