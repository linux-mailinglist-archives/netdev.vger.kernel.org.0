Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1ECF8291
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 22:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfKKVrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 16:47:14 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:28490 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbfKKVrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 16:47:13 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Woojung.Huh@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="Woojung.Huh@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Woojung.Huh@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Woojung.Huh@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: HNcaRYR2GK9NDLjFrSGlPxjFqjuhn814RgOlZ23KOWAa0sraRj5W4c2ahshs5PtlV5ReEWuWa8
 FzpBPtk2gVGdKMmGNwK4ljNSLp+RstlixNGKgGkU74pLq/+5hhiJQ93HBQ6UHXRitAOiO0fCqM
 97kgxrWzoW26NAoBmsJ+psjDhQcOxGwBxlkn7SbMuv+h+8WTV278eytrIecZpiMF3ZqJ22pbt7
 msx47booCbmGlPYFa2dffJ+OfxWtYicJ5oKvx/5S0VQMrCaQtv1ldNYGmnakJw8T3fSSGoE31M
 78c=
X-IronPort-AV: E=Sophos;i="5.68,293,1569308400"; 
   d="scan'208";a="55019317"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2019 14:47:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Nov 2019 14:47:13 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 11 Nov 2019 14:47:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmI7gwU9gsy19Uy21ZoF7LxPjMiFF+gMPEp4xUThi3KyamPBSa/VHsxvJ64d/58nYbUtEBKaKjUAR3VpEb5jHUkt2pL0lnWs64HOTPpwA433dz4TyWWAGu3/Cx5lU3pK7nlunQSCcW7XKBRwMg6SH4xKjt5+0/SRhnLg7t8YiqCMe7jcoQqru4JuXssQUJElJDQ1k/nmnuXk92UGwYtuKeceRXHPOTv0sXCEj7N+1Qhfv/KGcEuPHgULKIlutDucOnjp5IVUuf+JCIrPqaMYBcxDgYy9bfaakDEh7DSt0tt2f4atp9r0dJhh2ONqTRYX57+zpgeX30vwWUvHKbvJDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1NJZP2OuEWx2OxyLcmG5bucQRo/hVhKOKB7oubart8=;
 b=i5isKHi4/+8QI9ZrY3Ng/4djT0icHDzmsvOcduFofBEcfbcgAXuDJvoUEmDOhhwdEjH5BtA1+nvgTXRifG8TRRggosv0/TeXYA/WJVERGFGTIxYXdabJJc/T0xAMV30ftQqcbJVJYl6V8zEHM+sookPTtPhb9jMhPIGsPIxZMZPegDutfIu/mH/SIxxLat5B/gk4wQQJoWulTeTHqSwfogZsRFUtCZw/45FB9x3TGHmKXc4CsZbWVmJd2RtnPpUOaMGUyT3zLSN17cG35lYte6GpNDf78YUtido1/litpP6VY/XBj6uMShxisk/QAOuD7iE8b1GwEQ+h0GzsDJuxqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1NJZP2OuEWx2OxyLcmG5bucQRo/hVhKOKB7oubart8=;
 b=mPJfgxopm9SFicGLszlWDqNIOjRJC1dLpDfAZBemXmiaskVFpTuHBa3qmHGhutdBfTBHTZqjDqwfWjXYBA5BMFngCqEgucNYvmrA9ruIJKV3PccYswFRnep3FRr98MsJ1RUAxi7Mw3CZOeH4WSPcPM+N0GVOqBBVie5XTVFJGi4=
Received: from BL0PR11MB3012.namprd11.prod.outlook.com (20.177.204.78) by
 BL0PR11MB3155.namprd11.prod.outlook.com (10.167.235.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Mon, 11 Nov 2019 21:47:11 +0000
Received: from BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::30ce:9d88:778c:f8c3]) by BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::30ce:9d88:778c:f8c3%4]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 21:47:11 +0000
From:   <Woojung.Huh@microchip.com>
To:     <Horatiu.Vultur@microchip.com>
CC:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Horatiu.Vultur@microchip.com>
Subject: RE: [PATCH] net: mscc: ocelot: reinterpret the return value of
 of_get_phy_mode
Thread-Topic: [PATCH] net: mscc: ocelot: reinterpret the return value of
 of_get_phy_mode
Thread-Index: AQHVmKyJlG49ssDkQUm2Lowd3l6CSqeGgRlQ
Date:   Mon, 11 Nov 2019 21:47:11 +0000
Message-ID: <BL0PR11MB3012FA0DEC75685EA73D7F4CE7740@BL0PR11MB3012.namprd11.prod.outlook.com>
References: <20191111162127.18684-1-horatiu.vultur@microchip.com>
In-Reply-To: <20191111162127.18684-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83dab4dc-8498-4d24-0f75-08d766f0b522
x-ms-traffictypediagnostic: BL0PR11MB3155:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB3155EE2B14D3CE75BE38B9C8E7740@BL0PR11MB3155.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(136003)(39860400002)(396003)(189003)(199004)(6246003)(66946007)(66446008)(8676002)(107886003)(305945005)(66476007)(86362001)(76176011)(76116006)(486006)(229853002)(33656002)(9686003)(66556008)(64756008)(99286004)(478600001)(7696005)(256004)(71190400001)(52536014)(55016002)(71200400001)(8936002)(7736002)(25786009)(6636002)(66066001)(74316002)(4744005)(4326008)(81166006)(81156014)(6436002)(316002)(6862004)(3846002)(2906002)(26005)(186003)(446003)(54906003)(11346002)(14454004)(6116002)(102836004)(5660300002)(476003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3155;H:BL0PR11MB3012.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N4lkqPo11U6TPuPfJR2+B218nYljkPFJ6VPxTtA68nj2dpJCe+qHrxlh8EwHS/l4deesYVNJbz+GieaYoCZfFYTmh1wEqUa2hbApXoRx+ry0/Rh0NjbGkQ7OoSjgQoiejuJcvQqyXjbm89jy812adzDZ9zVa/fQSWMWDTwquGVbBepFynR/j5KbqdddcqwjrZzOZuP0jbDT2x6cukdXcPYj5D/TXrghqguXOWzsbj32eRs/IcrU5cNFs0tSsHVeJ2T3tkFLUwxw6BsG8unAOSoZXCZhUwFmng4pWi5eWd8yew6LcUqqf+nvCqrV2bV+uuxTRDvH1Eh5QzL7qzTD+G+KKTpTFGHgbnzw8aaBS7Kr0lANlUfrtNOeSv4skFcYMaGtTQIFLgd/+GZaFk+MdHb4TLiPJVD3vqEYplW+GSgftJdk1xMit4Glgj0Z1n5n6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 83dab4dc-8498-4d24-0f75-08d766f0b522
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 21:47:11.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wdtqhie3E4mQXw4ehY3VLJCC8fvoDiDRTrYdo5pMHJps3KZx002Sw99EKRHMwn+6dj+vqHvN74gHas1B70l9N8utK2G9VN+FI2pyI7W984E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

> -		err =3D of_get_phy_mode(portnp, &phy_mode);
> -		if (err && err !=3D -ENODEV)
> -			goto out_put_ports;
> +		phy_err =3D of_get_phy_mode(portnp, &phy_mode);
> +		if (phy_err)
> +			phy_mode =3D PHY_INTERFACE_MODE_NA;

Because of_get_phy_mode() would assign PHY_INTERFACE_MODE_NA to phy_mode
when error, may not need this "if (phy_err)" statement at all.

Thanks.
Woojung
