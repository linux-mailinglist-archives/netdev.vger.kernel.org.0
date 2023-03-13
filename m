Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571206B7A44
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCMOZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCMOZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:25:28 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2065.outbound.protection.outlook.com [40.107.20.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A861C5B6;
        Mon, 13 Mar 2023 07:25:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNtW1MY/TrPoo3uXRXfZajkf6MWXvcnXIubQ++7C6FRNuEbo70f6R8T9NaP3br+1G5wT3YWUnJjT4QYbxHcjFJEniuuC6m6n5jlB9tt5Pd2aOLPJA6AXpPacF1+jnOSUibs1uvE1Fk/GVXidGomsIAhKzO+DccVBp+rFuYrx+9uiPRw8hEtB6sw9YOLOkc5cTgZz991p8uh4f2g+cP8467j9UuHP/+N4SST8W99GlCmJXWNCmjG+SpWLJWxKE6evtJU7Fc6N5RfhIik/mVJM/FO+qnFcCHEsS9mA7I2i79rXoiivLO9Tmt1sLy8qZ7tuhNrVBViSMHVJa/0CVK6lyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFeGdS03wtPtUV28U34sTCjvLWdtcrBQbtbVbUCpnQU=;
 b=lm0RLSRP6YVsoPR5pGuCwGaSBdWUOkWQc7yn13BZLYQ+De52UgPOpa1oOhdbeq+M7V3OjUsb+xBrTniQctuoss7QgAtbxpMSPgH2ZuxdRIaQGU+HNFMNWteE6Lfrjm7i4p7TMiwN3lpzw/gqTiyJtix/4eY6XSuAAppTDPuk4tVEsRx9j9Hqf63elTJ6ka6ky4pDNNirbZtr6Ih+X7c1nMPOVU6XjfaqYsM+OtkcPX+O/C0dNbjqqilxQFMSOTxhj4AgLBlG4AGkFIhmTwcksUmrhMXtHkzY3cU38mLoQgMuIyhaN+ksBkvnc0HGzcfFT+mp/4GDUIltPPXO8CWnGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFeGdS03wtPtUV28U34sTCjvLWdtcrBQbtbVbUCpnQU=;
 b=akEaCv1066SYwZIaKwFhxUFQbp8i1GPiZlHhLncayceo9IXsuMyA8BvUI5v9VDZSffKvxij6hXzYisUQrjg92jYjGyjqtGWsV5iCrK0nALC8vtDWJfehcml7ZzlVGhF20udTal1z61GtoI3eUulOP6d5NNNe6eaHgrA9yiGQOFc=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS8PR04MB8530.eurprd04.prod.outlook.com (2603:10a6:20b:421::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:25:23 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:25:23 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v9 3/3] Bluetooth: NXP: Add protocol support for
 NXP Bluetooth chipsets
Thread-Topic: [EXT] Re: [PATCH v9 3/3] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Thread-Index: AQHZVbWIh2ARuCjlZEWNShWbYY+/Ja74wieAgAAAxZA=
Date:   Mon, 13 Mar 2023 14:25:23 +0000
Message-ID: <AM9PR04MB8603EB5DA53821B12E049649E7B99@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com>
 <20230313140924.3104691-4-neeraj.sanjaykale@nxp.com>
 <b28d1e39-f036-c260-4452-ac1332efca0@linux.intel.com>
In-Reply-To: <b28d1e39-f036-c260-4452-ac1332efca0@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AS8PR04MB8530:EE_
x-ms-office365-filtering-correlation-id: ed41cd53-5e7c-4a9d-116c-08db23cec85d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UWw2JfEY2EN2RJqmBoHCWQZfIP6H73qjL3S9hNdKVvIRJRn+WglX4SckW2bxOmBCnl2ONWNwv9UIAl+wIxpAhv51/bCv4te+fZJQeiDhzNYxmkPFTGoHAH5hF8eGJVvAT243IloAOF7ct+43T0r+hanmya3Ngu7Ub6pVMXRD7T9wbDnyGA/uVckm6MzlrnSknSEPUuM4JpC3rDuVC45B4jXZ/IeAuwyZAq1sTTlXVjR2rz5gfRRnnTO1BCOQrpo625YNEz+RS17fsx+jc+rkhDgBzpHNgbHEGrehDtGRDlVysup6PoyxQ5rwxbZmMFtWptDiC/7T/1UyjjNBIA1T+zqhZB8QhkXkHIRGe29MZ5Dr9Gosytk4ZPXHvnIFSeLO9kOgUXWfhffA+69lFqMnwu9q7ur+o1KyATXTrNcTbpmFCr5SEOn6lP+buEX4tdQejd2E+fJ6LTVP3N4tK9uwJx5Uy8RnqVyGGfRIa7IKCtfs0A2zz9SxAptuQaq0VHuDV+K4W6GwkoGS0+aXihuBELPOkW/eMakUnjUAEt8AKxHHTZactFPQLDjyNPSsoMtoswjph5PjKA/INCb4i7OSpipVWUU7Q6NQMF6tt54x5eohHCDpsaDa6hfAqr8GCqXeqv2UyRPlSiyvndONLCFMrUKmlULbWeFhvl7ogNwWkARXoa2pYZchr+uLG7MDHOlO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199018)(5660300002)(4744005)(7416002)(83380400001)(186003)(478600001)(6506007)(71200400001)(7696005)(966005)(26005)(55236004)(9686003)(38070700005)(4326008)(6916009)(66476007)(76116006)(66446008)(8936002)(66556008)(52536014)(33656002)(66946007)(8676002)(64756008)(55016003)(86362001)(54906003)(316002)(38100700002)(122000001)(41300700001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1cm3T04U4T/HCN5RrjjQ9gqBYPqyvpXJiiy0VkKSsFFZTOdtmJhpEhRPDk?=
 =?iso-8859-1?Q?mGe3hvEKZ9zNgF92cDXxfyTBtdmg/nL3USo/EILFrXilCFf+p/nG/hVbB7?=
 =?iso-8859-1?Q?1yd6bn4Dy9907nRGy62iRi6XmvD5kT4hK7+JmoIxjFhpxsuG0AtdNBnkEo?=
 =?iso-8859-1?Q?mqO4TJCbDRa3XI3/fjyuPNTTRI8alDtDBPbWRVE6kM3qO+Kk1dwVpYSouG?=
 =?iso-8859-1?Q?eiIih13oP6DNmHBpnNy84PlmIcWkzFqVadlhA4OV9hrCh45jFrR0/H/ESY?=
 =?iso-8859-1?Q?W/FwyteLx+QArrOf5DLGA5DZJaXO4KhP8dSVjfEWkzwb85BFCzwj+aZXVD?=
 =?iso-8859-1?Q?qF54c+Iu8K4kslv05YC1A0z75rYt1mGSyl08M+ljD1RyDCdNiNZWahFTPr?=
 =?iso-8859-1?Q?tEhHwiXTV9huWmQ5Ez7H+1ho1diyMwTcJ/ey1kuoSzum99czCqCVQnGP/E?=
 =?iso-8859-1?Q?rtKXmm1ncNzA8x/HlKO+a0xlzly89A9Vf0WBi/fGQqOv/608bcszlbg8Mv?=
 =?iso-8859-1?Q?4ppuDkChHRaRvhdrVIIC6W4iUhWWMnHxIeQWcEITHC2836BPhetVB5hdOi?=
 =?iso-8859-1?Q?nDKIOyLtyr7IADASGjZ/5NJlxk4oJuyD0ALheNjAYlo6ABjt77yfX8PNSF?=
 =?iso-8859-1?Q?zujM8xkJgukpFv6oiSQyex3o0FuN8rzTdRB2vLkf3t2WLEA0dTuxaYxZCa?=
 =?iso-8859-1?Q?aaEul7ctgRvhnc0t8f8y/Nx1jZ4r9zM9Ih8TbkPfRQU4KM3QFfzsqJKww3?=
 =?iso-8859-1?Q?kMG/pz3GkRpNmtaLD+hKtjlruy4QlUEW7117S0L1d5h3/OQ2FQj4WOXfA/?=
 =?iso-8859-1?Q?f3TpUpidArUAWNgpLJ3Ebs3z2AMX08lvNJUfL3QzWbK/3mGuD9+9R6t03h?=
 =?iso-8859-1?Q?5X3dJXrRJWW530tWF2cJstOXjomSyeBonNzvK+T9JJsPyl1ObVdMRXDPgQ?=
 =?iso-8859-1?Q?X6KtCXz+V+r1EcMrzhm8Ps8/GaFWIsq5VqBwwZFgP1DuipJx/k3rT9yaK5?=
 =?iso-8859-1?Q?wM9g/Ry54oZcqsItlIhXuR+akO8OK2a11uVgWjxrA1FYygnZ/AhhfhG8Di?=
 =?iso-8859-1?Q?UYA0AKo3HLR2CnPGe0Y7U1NjnBsnkAw/ZFsNmt0CqNR807n0Rle5JcSsZ9?=
 =?iso-8859-1?Q?i68Q85loJ8FY4oJgc3/fit47xzYN8QvezCGsyHQJMA+RwBOijfwQPPlKGL?=
 =?iso-8859-1?Q?vzikIFENKyTh/zwxpDJkCXjxHVCroYSb+3dJRbXbV0V6D7oM+ckNdBFnPV?=
 =?iso-8859-1?Q?PQ+XJXI0hbpvHoGw6t78bL/tc/VuLndhmFiBQfl1aIbql58iBDLVYZAMYj?=
 =?iso-8859-1?Q?LILApHUlhsFa78m8RzHgWIgIfdk3g7UUe91cPtxvyXg91NJb1gV4XNBsO+?=
 =?iso-8859-1?Q?xxoKz2ip+5zSzNrlL8GfrTgcntSTZ5iMJylvQAj+brk8pHEuMw8+RsaC0U?=
 =?iso-8859-1?Q?7ED/PrK1QGr29lKdVtSv2bU1P8f0u/9b6YypVTRu3H8E+0TljyxEsbIkk7?=
 =?iso-8859-1?Q?VyGAYKQV3FxJvkqM1/gHjab95XECQT+AA6tdV9hYG4dK6zgSmTvKLxwe6S?=
 =?iso-8859-1?Q?UJkvLL0msLW4SOTigISmzimweWtvtr7sHfXL0h+YcIUaN/okvcgBUMGQfG?=
 =?iso-8859-1?Q?OVp6FAuFizPfejUEFGJwoX7k+N+9OTxA4j/2HqRFb80wW1MSQY8/7GlA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed41cd53-5e7c-4a9d-116c-08db23cec85d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 14:25:23.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PydAZNVA01r4e9LLd5G9LykMRH1RP/+39j3NTigmL2mo2b5WBh+VXp5u3NkWDjBkBXmAXLvq4xX/h3Mir2SVbQC3rCPvLEQiolKJRkoyG8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8530
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> Thanks, looks okay to me except this one I just noticed while preparing t=
his
> email:
>=20
> > +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
>=20
> I don't think version numbers belong to the module description.
>=20
I was asked to remove the MODULE_VERSION("v1.0") line in my v2 patch, hence=
 kept it in the description.
https://patchwork.kernel.org/project/bluetooth/patch/20230130180504.2029440=
-4-neeraj.sanjaykale@nxp.com/

Please suggest me the right way to put the version string in this driver.

>=20
> Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
>=20
>=20
> --
>  i.

Thank you again for reviewing this patch. :D

-Neeraj
