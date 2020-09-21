Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0002718D1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgIUAXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:23:22 -0400
Received: from mail-eopbgr50074.outbound.protection.outlook.com ([40.107.5.74]:44891
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgIUAXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:23:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOdQ8NvL+L1EZoeWraucjUVd1Y04C0PeyzJPOAos1kINMIxAWEsIQWF2Q+xFTxyrG3c0FFQCm/8+449XMCdzyfCq6MdcGW8dVNnIZSHJCuyC53DEPQzqOQfdT9uJlFx1njts5MGjigHHFjUS1gPLdAjjbfREba9v09tTA/Y4is3LklV5fG39I3FEChrBwQKjRl1W06HIHI45GtjdY/iUZ4OylSPrkGg7pW+11iLI/IkNa7pNkiJELFs8EZGJp51eTRiQEM4yYHGcT4EOeVHsVWmEedxQwerz1g7XOefz78TnGSZ98BNOHEFt3HtSwNSQdb19kBnAzSJSGnpO2/7ETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M38GDGNY89GYrNArLvCjdbbXJEaOIjlY2nWuAmZll+E=;
 b=iC9BfZvaiBM8G1jZ8Q7O/FNfZwkIh7sdtypWZKmgP75j8ZBaqlltpefICf0HA3cyS0wwhAeB+AIKbtXNpuOOKbvm+p35QTzLsOhiBSfi1lY4SV8F86+09/DzlxQNrvnDN9a1GILmV2za2rq+jTgrgLzqxpNVSgZi/8iffoSJTKvpC+GCIIZwoGNgD8h1bc2GZFV1ey7gLSBy/2dy2AkyyBGwPaMM13b0m4ENK92Vq1kmQjnnaNs8QAvAYphqD9lW3lHo2vu/c3Ov8d74RNlvp0ZvjG8mgDAsRHBQ6NZJEO+Swcn/boaLCd8a5BtWpgkkt88FCGUeeTpA/C1togjZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M38GDGNY89GYrNArLvCjdbbXJEaOIjlY2nWuAmZll+E=;
 b=hl5juIJ+8NJqE8qC4dwn6kpXpYEHTN7zYyo/AbaIp0MpBGtvVgDGb86SnCCtBUoj1BPOjML8nfuyK3n1mFKeewmm0qIdrDylGIDa5avrF0G1asbsfadlz9XG7YEM4lGFlwu1jVsezvnCR7iJSaMkEquPLzqIcCaFJEKZq+yYCPI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 00:23:18 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:23:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Thread-Topic: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Thread-Index: AQHWjpNTDn/QEBX8Hk+qVrvSi0xeHqlyMyOAgAAKg4A=
Date:   Mon, 21 Sep 2020 00:23:18 +0000
Message-ID: <20200921002317.ltl4b4oqow6o6tba@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-2-andrew@lunn.ch>
 <20200920234539.ayzonwdptqp27zgl@skbuf>
In-Reply-To: <20200920234539.ayzonwdptqp27zgl@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dfb725d2-6d76-4ace-4f58-08d85dc489f7
x-ms-traffictypediagnostic: VI1PR04MB6944:
x-microsoft-antispam-prvs: <VI1PR04MB69445195E93F6E7A71442B4AE03A0@VI1PR04MB6944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zKI2HXPKYpVp646jeaWRsCmlQOHHkQ6p8MuS0Lgr4iDbAlR88QU07LaenV/HcOIbEoPf2JBi6CrNwfsi5tXXqqXZlcOytPn7Z0Ff4+julQM1SCA/dUenPZAGI9rf6kp9oLJEAyZDbfqF8Ebs6bOL+uLjJRkJX270s9C1L957WLHWKaiwZKMMO0Js+53tChfe8W77vyyuUA22Q7/w/Abs38B2NAMd+NrXT7SuG94CFY+ZRxJlNL574YpJhZQuwx494lCnWumr3iXizdN9l2K2KuIiw0vdRgwXo0q6JaolhWQXYxtSRt627LoKrZO4CLhJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(66446008)(26005)(33716001)(64756008)(66556008)(1076003)(44832011)(54906003)(71200400001)(186003)(8676002)(9686003)(66476007)(6916009)(4326008)(6512007)(2906002)(76116006)(5660300002)(316002)(6486002)(66946007)(8936002)(478600001)(86362001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jXG+9Y8wrFuBM2oMflgPDiuIPtNsHEijojBPovS0pBYaYLxWMUlouwgQQmJmjjhKYEmA5K1QCVGYh1VG/zlmcxYFuNWFAFDu1kMReXZ1CEaWURviVGVcaHtaXue/BogC5pCUU/NQkQ/1RoCl8cydST2Zpo4PF4gV0jJ9AolZ9AA7gDfvA/HzE5jMfgbxS/v2k/HlEuJoSys7dG423Mwp1h+5irSxVwUwEyecWXxf5dGddiqGRTE1R7CwG8VH3mus5TmT310t2IzabcFG74hJwY1vgx8JiUk9fjGqs6huhhBAEtLO6Sscgkp11nQ8j1RWenZVwCcPd0JtuO8GfILnW+C3Uh1vXHWIM16eFGpZkQTE3Bnvq/lnRxS0tVMPwV+qp6xQ1jUrfteTfrvuRAQEf5wO0MpUv161qz3OKxYbBcOL8ZId7dlFgAo64o8N1u9IJxDVxujHvBjH9Sgy/tku26Usq0FSlnbHw9apzw+CIb/adkHcgJkyJ28ekDPJAxpKeN2/fKAokF4zJUE2ovGz/EZPjyKgvBxEUHuVrJNrp91J+47K+n/sjT85cYUmbsKa7Ey4tyoQNuRc6W/LJeA3dwHEZ5540II79AEeydfBOT/+47eXlvTgks4nf2n6f1ieI8mhO3PsJhS8B3o5qdBBPg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8A9DAE39308E3458877CA547D6016ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb725d2-6d76-4ace-4f58-08d85dc489f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 00:23:18.2064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HLbfl2ifmUz6wUd+u7rbpxLRweWH6AbHggA8NtQcIe2XyzPc5oz9bLI1t8gEeclKbpuraJk65oBpJX6Uira8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 02:45:39AM +0300, Vladimir Oltean wrote:
> This looks like a simple enough solution, but am I right that old
> kernels, which ignore this new DEVLINK_ATTR_PORT_INDEX netlink
> attribute, will consequently interpret any devlink command for a port as
> being for a global region? Sure, in the end, that kernel will probably
> fail anyway, due to the region name mismatch. And at the moment there
> isn't any driver that registers a global and a port region with the same
> name. But when that will happen, the user space tools of the future will
> trigger incorrect behavior into the kernel of today, instead of it
> reporting an unsupported operation as it should. Or am I
> misunderstanding?

Thinking about this more, I believe that the only conditions that need
to be avoided are:
- mlx4 should never create a port region called "cr-space" or "fw-health"
- ice should never create a port region called "nvm-flash" or
  "device-caps"
- netdevsim should never create a port region called "dummy"
- mv88e6xxx should never create a port region called "global1",
  "global2" or "atu"

Because these are the only region names supported by kernels that don't
parse DEVLINK_ATTR_PORT_INDEX, I think we don't need to complicate the
solution, and go with DEVLINK_ATTR_PORT_INDEX.

-Vladimir=
