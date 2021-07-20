Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4A13D024D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhGTTHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:07:36 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:54477
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230381AbhGTTGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:06:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1O2pMisu5yWFEW1E3NEZ453F1ANkzJQo3R4lB46ex1qzkaTp83i7fJ5nCA24CPqo+CkH/9dU1qag6/M43Drsl3wMMYX99D9d4hzsOB9H/P1MNM5QFtP08YH1oAyVOhVJQjQSlRUq/4rXSmMtW08VDpsIvUExTGAwc6AQihS0neD1XQwNNCwhZ70SlJob9L8QHvE8E18FqUWN3YUr3TQxsu2mtGIywD6xO1C8y9IXoL9tJQMfr+o1ASKPwraGnr5LP5PBwVDiW/aOuu5BROVpir5eO9HRlLTjKe/yvZRqKo2EmAMiH6SrD1MMe7SsqMdggezp8sQHL6xrsdNn7UFhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1ouXLdGHZwaizv4bOA7F+GT7eaUR3+joA04k/M4mmk=;
 b=obeQGizt1Fd/5Q1DRXDaxJvb3+20d4NYmCQh+30C8ukKouCFr2ZS2M2W9N/pM5PqnffNGpvYMtmFcEF1cyVf8EyqJokOSKUrqvECBxtP9dUcFmW6h00FWhiPHFQf9A5NEU6m5FCVYd9m7DiEyF9+3hWi0ubc4rlV3MuoBNaJep2ms8/Vq19KkqMM/r0S/1H4pVQ4vl4ao4cnMLtZXwQnQIYLkubKZmL+Mk2evJbKcGu3l5WegAC64Zwqf09zRVOeQPo+VYknsoRxgO+Wqzr/4VUE2QxhGarrrJqOZh0W+XsNesntOF8hOG9eL1/ngx5/6gucnSgCIn5nxa/yOVO3YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1ouXLdGHZwaizv4bOA7F+GT7eaUR3+joA04k/M4mmk=;
 b=SaEHQwnZF58NHirdywzgR11iKZ2G68seDn4u5eXl+GbSYIV9uTCMim8N/vRyLIuZnv9/dWLlOevcXNlb+8QaetXMiwt4rovO4VPIvjGq4dWzgQRPySYFxGWKin1RwWoFtgruFolz7e/BFY4FGIxyGpunLyO2g72ImAnaYUSaSrg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Tue, 20 Jul
 2021 19:47:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 19:47:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Topic: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Index: AQHXfW29xPYONAiJQkyZbYsuqj9IL6tL5LQAgAAC2QCAAAOsAIAAWgKA
Date:   Tue, 20 Jul 2021 19:47:18 +0000
Message-ID: <20210720194717.qbdz5mmmxqbn3y3z@skbuf>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder> <20210720141200.xgk3mlipp2mzerjl@skbuf>
 <YPbcxPKjbDxChnlK@shredder>
In-Reply-To: <YPbcxPKjbDxChnlK@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fddce2f1-aa95-46f5-5e40-08d94bb72ef1
x-ms-traffictypediagnostic: VI1PR04MB5136:
x-microsoft-antispam-prvs: <VI1PR04MB5136B10D299B590B18EB6340E0E29@VI1PR04MB5136.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JuKib9sD7Jbkgveocn2tYZk6zQ6RBML4c2PCEN3l59s/HdLcczYSp0l1mlWMblz0kwlRXUb2ULkFyIxfG6z6+uOnQ2oUhzYtKCowSV0taryw/09lBrJBLwPD0rt4LiPAT0eEXfxCpyy1QEGhLf2neCMgr2kIXunzFKaWQpaS+uGMT8DO23/74HoeQEulfs+hpeHbCbGXDaIMvZEmJr35/B7jn09jNknqxJnGt10kU7nwthZbqQepw0cj71CgQVJ50hA11MkYmhzZvrbbybQ+2GN51kwc1Bv/MiBNDywFQypCGx/dqvLBQWJ5ePY7Z5q+dlYkYS69IinLja2V4UuVbDnNJmiouZ96I/q5TenJDsWYhXOoRuLga4wKffXEk7qkVdCjFZ/45g61wpTpmDn5Z1FoUlYj0BytBXi+sC1E2EeIcE8qbPjCV40OQYMLmQuf33IjA0JlkS7I9e1H52sdHcIGmhg4vt9YIonA+310dKJD+FNYnYeJkp9KHfenz5RSMBl7Q/lc+lK5ObqfAS3/cHGvh5Fon/DCskj+PxiegObjP70MoXK5mJWfd8xJT7hNfxs6UNrOX52yxdogIwrBrI/4hMB4a4q4FuMFZ1KtJr7vFu2Y34PgjthF/PYqKT1Lwx/ln/MWVUwGeO3YxhTDPSwwECpQ+ciqm7EX0c+IP26PilIhXejbacrd5XXOwsT56SkFq2cfPenNC+H849dP+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(39850400004)(366004)(136003)(396003)(86362001)(64756008)(33716001)(26005)(6486002)(6506007)(186003)(6512007)(9686003)(478600001)(83380400001)(66446008)(2906002)(6916009)(8676002)(1076003)(71200400001)(54906003)(38100700002)(8936002)(4326008)(122000001)(44832011)(316002)(76116006)(7416002)(91956017)(66556008)(66476007)(66946007)(5660300002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ltjYW7ja7MnBXrY7ED5C4qq93YR2nr7hbYyy+KSmcXZmImibizf8jfYfC5Oh?=
 =?us-ascii?Q?wwHdo3yr1lhLjj8Hmgi9+hu7XgIVMlhV3BH1HYZPLQrquJC2VUQwex4zGVT8?=
 =?us-ascii?Q?yBwFIMsbDDcK3bOWK1+AGtmutPZec973gYSPKSH03h4mEsxyBLYCw5eZ4prx?=
 =?us-ascii?Q?9UApXa7q6daHDhZyxZFJbRZNBLMZeM54G3UfBfmz/JsfQZjJ4HuS7MzrTnD2?=
 =?us-ascii?Q?KVbS2GJ2GL7mxCsaW9CdZgAsWk5YUbMwbWKQv/f9skV9uFap/h21LJ2NxRo3?=
 =?us-ascii?Q?GBEN1dYZwsLBEUd56BxLweDr7V3RVETrhsoqC9q8GfNPb8wYTttYW/AFXcBW?=
 =?us-ascii?Q?R+tXHSZiuem8+J7oBucKlE+AfQXgaTUoeD1oyprOtfDY+t7udbuf1C9bP5dE?=
 =?us-ascii?Q?rQ8H4Zvp2i6SQwTr8JzFHKx1XZMxqK7MBXVW4qw6rM3mHtcynnd7iDgdWRH+?=
 =?us-ascii?Q?l41Kb0a1nv9ARpGz1zyS5qFcDTwSUlN44uEnJF7yVI5eenpySeVCTdmbCfhy?=
 =?us-ascii?Q?GypbBMTOOoE810uAzgUly/+fuLDfPqrrY2DYCgPHRyEr86l3Oz5NJKMZJ+4Q?=
 =?us-ascii?Q?SAETiYz9Z6eTAIRyHHPK2/LqtDFEHM9wsjsj69Vvl0dzZ64494fs76uMtTRl?=
 =?us-ascii?Q?nimd93ofRVZ3g0UwvGEeg0LvUZgyQd5lvOFEDCxaNNHDUQMS1EL630WIHlda?=
 =?us-ascii?Q?sdgR/3fAycgOPlshJSE30aCvgipU+VtsqlG2EBDxzdAHKhaAX6oKkV53+BF3?=
 =?us-ascii?Q?LDXPRAz83OzsEiYjCeP3NflradsHqReH7otuxFJMH1qDpkWquK1unE7jJYdn?=
 =?us-ascii?Q?ot/raQDi/b6+2cUsKHi+DVU2/MSbSXmy33MtuXH9eCmCG3+Q7TnNg+F6Re28?=
 =?us-ascii?Q?YNBGfXhiSGPVVaf/7v19JhRH3I3MG/Vo+rJfuuCZMl+ZzbtwGwLSOHzOjD9C?=
 =?us-ascii?Q?aazoo7kcwe9IfnjjAeVtwM6JUXlC4PV9RGqitLNE8v/aBPiZILhlG/cS8Bf2?=
 =?us-ascii?Q?fSY5icxt1VeW2TauiIPGC2mEDTixQK2v4L4Jjey/mEuv4RANcbW2LRBpdp7t?=
 =?us-ascii?Q?uo6DrPHCLOyKOVBHmAZEifeM5UoJCRQ/7rhWrs5IDHlZCqngXGS4H3d0ICpX?=
 =?us-ascii?Q?04l9VL1JGus/2+PxoUO34Cnh5D1htHvYrl7hCeXB1L1LHagmdU9UPgg0igsK?=
 =?us-ascii?Q?HZmF0gYDHbmJkmticx0hujvidz8+1ZNfT1LukUZaNePDSRoaRHOzn5qqfQ5/?=
 =?us-ascii?Q?kfJDWM+GYfU2wfYjZYJLh5O8rvhF2lMpJOHmteRWzj1cmECq8RXZ+ObvBUXA?=
 =?us-ascii?Q?RY7XRKC1E7pdupiMm3ov5t/F?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC03F5D2718ECA408BDB5BCBDFA065AD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddce2f1-aa95-46f5-5e40-08d94bb72ef1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 19:47:18.6885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0dvPGVyqFi8xMCEkoO/rMBlSxpxyikpbrm2sB+et3WVW56PjENYbxtH1/zv/W5xsxbPswlpJ7JdrFM3weCg7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:25:08PM +0300, Ido Schimmel wrote:
> If you don't want to change the order, then at least make the
> replay/cleanup optional and set it to 'false' for mlxsw. This should
> mean that the only change in mlxsw should be adding calls to
> switchdev_bridge_port_offload() / switchdev_bridge_port_unoffload() in
> mlxsw_sp_bridge_port_create() / mlxsw_sp_bridge_port_destroy(),
> respectively.

Is there any specific reason why you suggested me to move the
switchdev_bridge_port_offload() call from the top-level
mlxsw_sp_port_bridge_join() into mlxsw_sp_bridge_port_create()
(and similarly, from _pre_bridge_leave to _destroy)?

Even if you don't support replays right now, you'd need to move a bunch
of code around before you would get them to work. As far as I can see,
mlxsw_sp_bridge_port_create() is a bit too early and
mlxsw_sp_bridge_port_destroy() is a bit too late. The port needs to be
fairly up and running to be able to process the switchdev notifiers at
that stage.

Do you mind if I keep the hooks where they are, which is what I do for
all drivers? I don't think I am missing to handle any case.=
