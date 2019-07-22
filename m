Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FD870C7C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 00:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfGVWYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 18:24:24 -0400
Received: from mail-eopbgr780122.outbound.protection.outlook.com ([40.107.78.122]:34993
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726544AbfGVWYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 18:24:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLyyQC82vaaXlfhR5LC8twgd3HOnYMS/baU9g0MfeDrIETle9wJMMqTBkN03E0PcIXjh9J9W9p1aMCBiP5Y35ugSmwk5NzjoDbF6Mnzr/MEKHzI676Qn+aQGTWiwr9EXtKv+JXAsqCEiGjTKi9BQUk4Qr/bzFkHFeN25AwaG8T9DAD0aViKSDtOSfq2j/1e3ZZYqWw7uJQeQcHKgCjksd6MZDWf57RmfKSGIavyp/nWG6Qeww47ABUIP+NAbFPzgq7kL6JIv5d5PVOKK9bGfMw14YejWRjqnrnWoS+4C6/WkvQDPl75P8H9VHXUf+Fh2Ti4dlCEKmDg8IYDS150kwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1yvB80CD7EIfU3NOpEM4qJH1xzVU9WtxtHbSnUuN9I=;
 b=fYLn8opynXQiTqmvyOUIQvjOPmIaBYdbfxF8E9liliqXaBoBx40F7eLNsDbzoDaUD/VUMb03x4VvlEGa375/OlhCGZ1dooW5+HLsTiQMqhXkCK4Q3CqYGBtqAha7GSFUkj7Mamc39DWf3+lGwYuEn8pUkWQ9KQFBjhzH0zVQ0EKDSquz0n9V221uiqKIhnI9GPtlD8Vy4yJqzmaATN993JlGII9Q9KF96FMYArQT2IkpGBzey8gdlLlWy0zu/Mr9YodCb08uesGphKvt/bVpLT6l7ONbtjASTfPT4wO7w6r6YA5Qp/HYKzYetsq+0EJMj4OTus5vefyqTOkYx4/cBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wavecomp.com;dmarc=pass action=none
 header.from=mips.com;dkim=pass header.d=mips.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1yvB80CD7EIfU3NOpEM4qJH1xzVU9WtxtHbSnUuN9I=;
 b=IZwEmPYPoAy0/afyh/Pky8bYE5DtPrwtYQdsiXQNhJblZNo14CqcJcz5wDaz4L0SHJS5vyd/7FBemkmbTbK7yzq1E8KswuRgAyPsUS3IPVkLoGlL5zs6olbdHdLAzLO+hIsedY1LZ5zmKymyoC3m/VUlQ0ikdZdlTyTVt+Vd5S0=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1263.namprd22.prod.outlook.com (10.172.62.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Mon, 22 Jul 2019 22:24:20 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::49d3:37f8:217:c83]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::49d3:37f8:217:c83%6]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 22:24:20 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "jhogan@kernel.org" <jhogan@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next v2 2/8] MIPS: dts: mscc: describe the PTP
 register range
Thread-Topic: [PATCH net-next v2 2/8] MIPS: dts: mscc: describe the PTP
 register range
Thread-Index: AQHVM2ubifXPgAklDEWTI79p26RqDKbXUY8A
Date:   Mon, 22 Jul 2019 22:24:19 +0000
Message-ID: <20190722222418.egpd5swif7a6y52g@pburton-laptop>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
 <20190705195213.22041-3-antoine.tenart@bootlin.com>
In-Reply-To: <20190705195213.22041-3-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::49) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4dd4dc7-0384-484f-3357-08d70ef35709
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1263;
x-ms-traffictypediagnostic: MWHPR2201MB1263:
x-microsoft-antispam-prvs: <MWHPR2201MB12632F8920E25DFCF7F01C9CC1C40@MWHPR2201MB1263.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(346002)(366004)(136003)(376002)(39840400004)(199004)(189003)(76176011)(8676002)(4326008)(71190400001)(71200400001)(476003)(305945005)(7736002)(33716001)(102836004)(316002)(81166006)(8936002)(81156014)(7416002)(54906003)(2906002)(58126008)(99286004)(486006)(11346002)(446003)(52116002)(44832011)(26005)(186003)(6506007)(386003)(42882007)(68736007)(6116002)(3846002)(256004)(14444005)(1076003)(6486002)(6916009)(14454004)(478600001)(6436002)(6512007)(66476007)(66556008)(6246003)(66946007)(64756008)(66446008)(25786009)(5660300002)(9686003)(53936002)(229853002)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1263;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TYMR/8i8bXBUIqXszbIEzoJ1HDBImTUVxZFLr6KLfv3bxFSIVw4kfBjbOJxXm0xzMcB4buwzilj28n2KBbTJ4booJd0YzK/4sCFfkt564l1x+yIHcLnXj87NfM5QUviVnPvVIqy8M0G17B8I2vB+e5WiiuVn0Shf5ewe8gvR+f0Og6lFi9cjZxy2dB5Zc5Jl2wVqed8vjuNiLkhLgaI3e+cUNnZZ05uA7qr4drJPcFfW0NWnCBxkjkZzmZi2xFZTkigrRwS+FmXfD6X0RSmFgVBFEv4r0MERggNj0t3heeMfhqJusq+3Pvhss/aq/Zo6DvRRC1bYU5m1A/xvFhykvXd4f9ovl33htqtKxaHRfuYcGwDONXISPw+tOE/8cnXRoQTNi4fuffSXbvgQkBLSctndjNaLW7Vj429C+uFwwHw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBF5D62AB6D53D4AADBD7A8EC9A7C617@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4dd4dc7-0384-484f-3357-08d70ef35709
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 22:24:19.8749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

On Fri, Jul 05, 2019 at 09:52:07PM +0200, Antoine Tenart wrote:
> This patch adds one register range within the mscc,vsc7514-switch node,
> to describe the PTP registers.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Presuming this should go through net-next along with the rest of the
series:

    Acked-by: Paul Burton <paul.burton@mips.com>

Same applies for patch 4.

Thanks,
    Paul

> ---
>  arch/mips/boot/dts/mscc/ocelot.dtsi | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/msc=
c/ocelot.dtsi
> index 33ae74aaa1bb..1e55a778def5 100644
> --- a/arch/mips/boot/dts/mscc/ocelot.dtsi
> +++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
> @@ -120,6 +120,7 @@
>  			reg =3D <0x1010000 0x10000>,
>  			      <0x1030000 0x10000>,
>  			      <0x1080000 0x100>,
> +			      <0x10e0000 0x10000>,
>  			      <0x11e0000 0x100>,
>  			      <0x11f0000 0x100>,
>  			      <0x1200000 0x100>,
> @@ -134,7 +135,7 @@
>  			      <0x1800000 0x80000>,
>  			      <0x1880000 0x10000>,
>  			      <0x1060000 0x10000>;
> -			reg-names =3D "sys", "rew", "qs", "port0", "port1",
> +			reg-names =3D "sys", "rew", "qs", "ptp", "port0", "port1",
>  				    "port2", "port3", "port4", "port5", "port6",
>  				    "port7", "port8", "port9", "port10", "qsys",
>  				    "ana", "s2";
> --=20
> 2.21.0
>=20
