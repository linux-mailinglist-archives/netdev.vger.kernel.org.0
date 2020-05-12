Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A98B1CED03
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 08:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgELG2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 02:28:05 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:18307
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgELG2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 02:28:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNgYxPPWgqzvWAYzZHpMEKKRsrEk5O+vTbeGzOEKxdjl0iuTQudEFI96FKrgFAAJbv1ls6kTmlL9SykiHbe8wf6D6hWUomT0awtZlQY6b8KgLF7UujlVycWCDE33JnYR75RjptV7nUCWdyiHSuD9FoXREwMgnyXEv0zCcBZEfhUEIBtv5aVhr4Lc6iCCvoAE0ifA8uskKxMGZGtOTAHFAiYqzeAjQd7kIyFmWPpnQeH8Ec3ktqZ2KuQgRPB+ebjfhR1CbWlFD45aADeNZRteUZULO193oEer7ujKPvFdOl79rEhoCMEmuH5YdHMSL+LGAlxHyRCNEY38+ZTah+SOUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6f+s/cqybZ0PppcguEKBnlbF4KKYDYUaGZ/bagHuV/I=;
 b=VPM+veI8G+mtRZhFuoUARoWCrA6NcS0SwAgJOZ4v6BhQhvYKcNHRQHU1Lj4xTzNz3GenYXtqBAQotdpmQr38RwinQvtlAiDRkfo3hpoCtQXcgHQe5YFWR6HUvQX0CJAt65Jbxf+9sDFKK0omDcSpkxsHKpPMa672xfxCJZtBawEhBh9jqBA6PNYMzSSk40hdc0B7eWXiXCx0cjePM3knzVTXQJREgm+5GRx/SfpZvsvFQVvV+bM1YO02ckqR/DyPFSUnVUj1WpRM79KkiO06MR7L+GP2cECdfYkLrABRJ/BkDOxBGn1Ykv36QA9MWOU7BxDTejSGr8k6QLiOG0KDzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6f+s/cqybZ0PppcguEKBnlbF4KKYDYUaGZ/bagHuV/I=;
 b=LIZtb/C3xD8P8LjBHPrXT6gIKbOLQQ7yY4DlHCHS/Ge9WfdiLuyt/y2vMYLiNX4H/TCRQPDIqbr1BZU0tXjI36yg6zjEJd6lBoqSu0AKlxuXdaK1HekLBDrs8sfvp/uJadbeU8wzzRZJZ/5b5fNZWKdTFn9BvzIQjs+yYN/RFHM=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB6748.eurprd04.prod.outlook.com (2603:10a6:10:10e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Tue, 12 May
 2020 06:27:59 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 06:27:59 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v1 net-next 3/3] net: dsa: felix: add support
 Credit Based Shaper(CBS) for hardware offload
Thread-Topic: [EXT] Re: [PATCH v1 net-next 3/3] net: dsa: felix: add support
 Credit Based Shaper(CBS) for hardware offload
Thread-Index: AQHWJ1fQ0aW9GYkaGku6h57iU7QcdqijeduAgACDLCA=
Date:   Tue, 12 May 2020 06:27:59 +0000
Message-ID: <DB8PR04MB57850A61F400B3624CBE1A8FF0BE0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
        <20200511054332.37690-4-xiaoliang.yang_1@nxp.com>
 <20200511153403.7b402433@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200511153403.7b402433@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 603cc6c9-152a-44e9-faa7-08d7f63d9d81
x-ms-traffictypediagnostic: DB8PR04MB6748:|DB8PR04MB6748:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6748CB96191E97EB5D36058DF0BE0@DB8PR04MB6748.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t8CeT1Rc09zodKCVm8W9eLdlRfpmTlWYjCfabxYUwsuQ8q9VrUtdugWcXJwvSSH2GrzR134FintVeG7XJ4OPPIzYNNuBHNzNXuohxEAbBzWSUBceGJyQMy3Ig3m7wU4df/nq8rbcgDTdWLzd0C621gCNl5pPC0vZgAC6Hrnq21XvSGjJyz0R3dT9CDkrOlUwdb0E2cPuPV2ZteDWyo7B7Fb+fsVpygNvoQyqCaL/UVqCuGpbOCkuDc2aSOgq7zjRGIkztJ4tcemwUmvx/nzDJyR1d0RN/1SbkEJ+AWt/0v4cbH7C5JIIMxgyjxqx2fhyTF7kIxM++KIrP/37H24ZHrEbuaciTEPLgrphfxPPlSZnSCNr/s3rKhYgDk8TLyCgWGP3Q4KiWy+u0r74E/IxLO1MRAl6tIMbMwOSFRvyQmhVQQngqGVwYCdYYI7bgKws+5LFOvhMaWBU0G0m0p6AqkP2uRp1TM29lq1Wen40HE1RNE2MwntwCG2hx4UmvVs99ONgoi+ptsp6tmhcQei30w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(33430700001)(6506007)(26005)(33440700001)(33656002)(64756008)(66476007)(7696005)(76116006)(52536014)(66556008)(4326008)(66946007)(66446008)(478600001)(5660300002)(8936002)(6916009)(9686003)(186003)(7416002)(55016002)(54906003)(2906002)(86362001)(71200400001)(558084003)(316002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: EZbe8dK7W5l19twyll1gcubvXwJSjJn9Mg15aO0ShiNrXdaqS05uESo5F/w6ClsohLRCOcus6pxVnh7fKYipFNu+1zWoH2aGinME2G5tEamKc5g9zxqnJxBPgtd1gWiNUQofnDQ9eig0iOsiWqxbjk8/dtbMsvacZaWtjvpA52TK+ZwGDb3rHoUR0jt+pkO2uPz2yDpcBUFTjLuzSFdBniEma3wIDiYZEJW3/17CHbIHGdzm/fyjx6kgAQRpgxXcsm4kzBlvdG5YlwFJ+A17TyezGP1gGcyCCleWBb3XB/u45ZNxrbamLo2N7FEtc4GiKD9kJiAKLvWxy3EpFWg70X2/7ZqxpJrk+Dmiu+BxwIUHuGnoptztt5fePJdnS1dQ/mVudBpW5RIP2CmHEtOqM9CJ7nqx4Ax5gP+U6VK1xUZ3ao5D4zpvPyxXMi4+LvVLTy1gd9fe4oU06bZy5fTD1ZeX12hYPkefUB/HEMwr7eE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603cc6c9-152a-44e9-faa7-08d7f63d9d81
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 06:27:59.1364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2V66Qkw0KTlqX8lq4q9x+ARtyZVBhAhidxYEaiUbdKFmFlsk0yUzSjdF+dhv6v7FFdQG8sQLheCPxH6ENTHCLzi5IHKNpL2Hz853inV0Mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6748
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, 11 May 2020 22:34:32 Jakub Kicinski <kuba@kernel.org> wrote:
> > +int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
> > +                          struct tc_cbs_qopt_offload *cbs_qopt)
>
> static

I will update this in v2, thanks.

Regards,
Xiaoliang Yang
