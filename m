Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75947223C7
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfERPJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 11:09:51 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13378 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbfERPJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 11:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1558192192; x=1589728192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RiV7OEoZWJ9YImSHPzGObfADBhzYvQh6R89rP4cvDws=;
  b=EWMG2vuwp1a+hJNBRIRczwe6izaDWfoov8llT02KjBTmxZE4s8zLSdhu
   O71K12CATcqahOuiXzpf5C9iG1ZSQ1ucM1xWPj8jrx0ycpFCIt4D8Z4Va
   EdOLRHjBSmr904YCl2t3ub1MKgnZwIriLqetNxsKojGfJS8ch2/649Jft
   YN9vycjPeHznE4sOc8sIUgaXOfpuODB3PAPcB0NkobpgkxTU+cRhdZfVB
   0Y8O42ycBBPJIDbww2eTfnPwqKSfuW3y1utqxIwc20B57dJp6dgJ34og7
   1uWIh4m9znM7TSg0vJ/q4+mnUrHudqfi6LPlaLoDssqNAAqkI4Hh+2yfS
   A==;
X-IronPort-AV: E=Sophos;i="5.60,483,1549900800"; 
   d="scan'208";a="113518271"
Received: from mail-co1nam03lp2059.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.59])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2019 23:09:49 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiV7OEoZWJ9YImSHPzGObfADBhzYvQh6R89rP4cvDws=;
 b=QcDup351RCI/Aa+TJR8shcWepRxeiN7qF6GkoROrXYy1iLMp/NxUOtoZ/ewjle+X7rQ6CYUUYCFWErzzRjsNPl3RwkhFFZDpTik7QOAhDobcLRW7/sBDIaeNP2UmXRVgCv/31HIWx5Tls0GMp9zyXqw6rHiyszcnR9WPiZsBqOU=
Received: from SN6PR04MB4925.namprd04.prod.outlook.com (52.135.114.82) by
 SN6PR04MB4671.namprd04.prod.outlook.com (52.135.122.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Sat, 18 May 2019 15:09:44 +0000
Received: from SN6PR04MB4925.namprd04.prod.outlook.com
 ([fe80::6d99:14d9:3fa:f530]) by SN6PR04MB4925.namprd04.prod.outlook.com
 ([fe80::6d99:14d9:3fa:f530%6]) with mapi id 15.20.1900.010; Sat, 18 May 2019
 15:09:44 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
CC:     "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        "mka@chromium.org" <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Martin Hicks <mort@bork.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <MadhanMohan.R@cypress.com>
Subject: RE: [PATCH 0/3] brcmfmac: sdio: Deal better w/ transmission errors
 waking from sleep
Thread-Topic: [PATCH 0/3] brcmfmac: sdio: Deal better w/ transmission errors
 waking from sleep
Thread-Index: AQHVDQOIWiJuHBTvfUy+CZIIvlgrX6Zw/GuA
Date:   Sat, 18 May 2019 15:09:44 +0000
Message-ID: <SN6PR04MB49258D4FBE0B4D739E8BAF7EFC040@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190517225420.176893-1-dianders@chromium.org>
In-Reply-To: <20190517225420.176893-1-dianders@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [129.253.244.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61d66f27-cfb8-48e7-ddb0-08d6dba2dc50
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN6PR04MB4671;
x-ms-traffictypediagnostic: SN6PR04MB4671:
x-ms-exchange-purlcount: 1
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <SN6PR04MB4671AE9037E102DA115DBA04FC040@SN6PR04MB4671.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0041D46242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(136003)(376002)(39860400002)(199004)(189003)(81156014)(81166006)(25786009)(4326008)(8676002)(8936002)(316002)(7696005)(76176011)(99286004)(102836004)(68736007)(66946007)(64756008)(6506007)(66556008)(256004)(6246003)(76116006)(66446008)(53936002)(74316002)(33656002)(110136005)(9686003)(55016002)(73956011)(54906003)(66476007)(66066001)(6306002)(4744005)(2906002)(6436002)(86362001)(476003)(72206003)(446003)(7416002)(478600001)(486006)(3846002)(71200400001)(26005)(305945005)(5660300002)(7736002)(52536014)(71190400001)(6116002)(11346002)(229853002)(14454004)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4671;H:SN6PR04MB4925.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N9O2ae9+jU9rs2sDfOqn7v12wZG/c0afdLcUr2gn3ifl1HGEuOIRmNmuLKqKrWZW+ksTDZBfL8mgUiUcgIdPZN91PnA5XPsp6KuNZo+aZYUbVCfghSB5J+kpDyCeULdeP+3aMkAef9AeI9v9IksOdinVsuEcKOeOkGx3NALAbRRWZfctp5yawVwv8KFbWOYI/0bfyC5VgkpEWdefMIwya7MPvcFQpF8iKwnNhpYb+u1CRqUetZkb/2o4z9mE2Sh2E8cuR6etc/azGF2myiCfEjcdsYl8jmE2LyL7lnVPDa2IoXzCyPh2chtZmUebMoDKGlyIAhcQh/AT9S07BKGrFZyJLjCXj3me4O5g1l73jT9/SUehRft80O+eNJij7oouZObWg2k7Tw2qhCob1q1XwEJDcD8CTEDYjQ04dvPsRTQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d66f27-cfb8-48e7-ddb0-08d6dba2dc50
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2019 15:09:44.4257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> This series attempts to deal better with the expected transmission
> errors that we get when waking up the SDIO-based WiFi on
> rk3288-veyron-minnie, rk3288-veyron-speedy, and rk3288-veyron-mickey.
>=20
> Some details about those errors can be found in
> <https://crbug.com/960222>, but to summarize it here: if we try to
> send the wakeup command to the WiFi card at the same time it has
> decided to wake up itself then it will behave badly on the SDIO bus.
> This can cause timeouts or CRC errors.
Wake-up itself: as part of a WoWlan, or d0i3?
Looks like this calls for a wifi driver fix, and not WA in the mmc driver.

Thanks,
Avri
