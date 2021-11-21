Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CE5458590
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbhKURto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:49:44 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:45404
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238540AbhKURtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:49:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxAtJFi1JwYGbwaLPgVWs0EnL9WNd0J84NKntCxascC8G/IArdkqnu/bxp9HYGH/jgl/QBQjUEv3w4N24SakMR2Ck7n8by5gQ49W7dZ9DsexClU9MVcS3njPIytuTkNoJTbd4XcIvB0J/RVrErSc2MDNDcnCDtpxkwHDBKaNVgSJAROg50RvPehweI5u8TpUOuaA2DZ45IwW5rjZ/WQIHTXG7uzuyLTHwalJSiT8M/0KU+LgkyLEHIpQ5vvJ/dvLXlhSPAVHLDllKDhdq7WfId/wu1o8NlGhWTholmvhYWkCzyvXIQ4V283n/B55VqHuYxODf84b/HRcCqrilP6u+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tl67/t1Vowfqo8jd/1M5yu2t0R+9I5gdq+fUXeA5jLo=;
 b=Jdf9TLyNehfJn/VOWSX6j19gV1ZNZyrOnqWCCT271tXzvzKAK2fITKY/QAIY4NxUp5GsE5TgtRn28Z41rKsgif78zc6qBya42URxVQaxrOJZZWbPHuPfwWTmlCg8oorgngqMyxV7pGQWjMevp8SjiYeq+NT5ILTlGu+zNKe6PA7NnIG9+4CT8SOiswZ3okEDdPLZHxCP2hZY1yf3CsNsjkNke93uQFo3JWRr9WZRpoE+Rhcht4uKLHZHVWh+TrkXhUC2RkfPo2YqF98reJqKB18ihhf/ei8O4FCzkGBfKF8Ce4AhUxlPL0I9xfqzzlu/fHxBHAi1pF+Tz0Mhl+XcSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tl67/t1Vowfqo8jd/1M5yu2t0R+9I5gdq+fUXeA5jLo=;
 b=GhHng4XvMO3FWGN21/EQlAI8uvdHok/WUrMV7kQVzihsaWi/2V6MxQG7IP2obqy+Jenmzf6VD0fMIR/zYD7OHW63uEtrIUcUhalr5VP+/F+gZRsAreBiCJBA0rhOnpMzXAfVPJwoqcU2YgRkQygRSEBmLbnbIGjrhM4ypUPLftw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 17:46:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:46:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] net: stmmac: retain PTP clock time during
 SIOCSHWTSTAMP ioctls
Thread-Topic: [PATCH net] net: stmmac: retain PTP clock time during
 SIOCSHWTSTAMP ioctls
Thread-Index: AQHX3ZoAkTIcPNTQCUeJkFszF9TJdqwLyqeAgAJ5mYA=
Date:   Sun, 21 Nov 2021 17:46:36 +0000
Message-ID: <20211121174635.y7ljlas26xpgfp4j@skbuf>
References: <20211119230542.3402726-1-vladimir.oltean@nxp.com>
 <20211119195851.2181aab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119195851.2181aab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: befc56b6-234a-4c12-5193-08d9ad16dda0
x-ms-traffictypediagnostic: VE1PR04MB7327:
x-microsoft-antispam-prvs: <VE1PR04MB7327AA1C38A3F318998940DCE09E9@VE1PR04MB7327.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pmt+LpabY4El9qzNEVok+hlZxOaUafcGETNTpovTuIb1j2lAMCI5ckVFQdxon+cPTkacC2W2+KaMr4Y5OvYdBd4YOd6QsCqXdt3hPdU2yvFqMIs8Lb8e8mEdQ5RjD5Pp9l8M0Mz/Do9lw2Ro9ql/JH6gIn5TO7kq9X3cygcIlN7IB+9JNn/JD0/Sx7o4B1NBYRSgB6rcbqVzUIFb6zQAErC0cCcqu5kNrDA8e+Q8EvIGidxuPtotFSrq2oK0STovUWf6ilL6nvXHJ1oz4vxwlDitP5q5d7Z0a8/m8JFebRjKsQs8kaVLKlq0iDce4YjMjbTVh8thVYXGgu85fyqB747GLXuMLXivh08Hoa7muD/8URkuAqIvvs3XzgVGPdTbnnGDTaEEj8cOBGaaVjHwWwEyvIXMCVRPHrBFqZh0QkQKjiJ9K/8b4eJVpf2DVkMnALCanN3llHAie5Ulr9LtxiI3SQbHx3VR+QBV8FloFJ7EVGI1mpPXsMsahPD4vXwp/20I4dqDN5zLPzAq/zB4tHLXTAu9e7M6Z+esMH0Z9XtDir/FtPb5LBr3OUrKFpsthaAXRGyA5ub+1HxJ/hhMztUpnKAKtJXc4AyLHyX5U7vJLu/g2+CwMFocTfdrDnBIQBJu1TbQuPgcLkUzmsP5hnUBoZg7R4Gt1HJVGWndmbYNHUexpzeZ5yBjTPZDAy7NKk2W5Nj9PcYYhTv7+DQ1Hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(66446008)(8936002)(508600001)(2906002)(54906003)(6916009)(6506007)(7416002)(38070700005)(83380400001)(316002)(8676002)(4326008)(86362001)(44832011)(122000001)(6486002)(91956017)(76116006)(66476007)(66556008)(66946007)(6512007)(64756008)(5660300002)(1076003)(9686003)(38100700002)(71200400001)(26005)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ISElCfBhoxL2gcfyIYO5cidiHSluYt5iMEZStrh1WxEfHQSy03tqipgRLEo7?=
 =?us-ascii?Q?YY5vNGPK7PmI8nrzGh7HqpZom+c5QsX3onbD5STL35PkXBlfX1HFshyeAmA7?=
 =?us-ascii?Q?bUZ1iJSsecNV9Nm7yJBpOJLJ4QzymTNxM2+08vrlobLxS7f0E1QEUAauAEY9?=
 =?us-ascii?Q?c1k/Fh4K+bQWBTwOSBxlN9688U2l/S/WQwi6pNPlPTSNv9FXfgdPelE/Fd8V?=
 =?us-ascii?Q?HAMj7e5YW9OLy0/n9ntZJ6VgA0bpNdEPOLn1BC1B3bsyW0QenQsd8D+UW0L8?=
 =?us-ascii?Q?wDVPr58fefZg7oGhCpTiWrTHibfH/S61Yw6aIPYRgaWFB1tXXcjHvDmInUmR?=
 =?us-ascii?Q?tHqdXq9YFEj+DX/9LAvHI4MhZp2t3DK9A5Tf4pKVQWrZ27KTwqkAdglUFCqz?=
 =?us-ascii?Q?+C1dwgVA3pjhoxLabdxMlIu8NBicyVwA5ME82fdFs/QEnmx4+M405AibQ3KD?=
 =?us-ascii?Q?qTKmf2DtQmXxcavS98F/zBQu0P48s1i0XSsI/vwK52/v6cnBbaOa6ENg7E3z?=
 =?us-ascii?Q?tCGKKcLxcOXc/8sVOueU2g9lYUxet+2rVax5s/0WBFFHg4JE10Rc+ffzvYoE?=
 =?us-ascii?Q?ro/953GDZkLCt92QlJOhig4N+G9srxiWSjV1mzFCLnR/N/fPaUwK0z19/dTZ?=
 =?us-ascii?Q?zg5XM369Ihniurhi8EYxKeNJiozwvqExNrTwsibC5vAEcrw9moh4tS94Pate?=
 =?us-ascii?Q?3ZkKvnARsVw0G/MCsx0ozPZQKo7mZ6XxYGQPBhetFU17xa2wyYpFSuQ7DqiR?=
 =?us-ascii?Q?GOxbm/47nGotulwC6Vtn3EzROBb+tN+LTDQY7q5SQNvDwjnLmPtpH1QrvAcc?=
 =?us-ascii?Q?hIuQ45puMWlXntITnXVkbgim+Oi9Rk6ikGpbCDOs4LeXglXJroB4U+i8OSb/?=
 =?us-ascii?Q?19axUoPmtturXSo2IwIU5voY5X393SH8TTq68Dj9GD440X9UbKgsO33cdDmP?=
 =?us-ascii?Q?E0C7xhNBbCSYPMc+lFQYrRuCq37jCX7qrZL876uuwy3Tev4qpahNy9pfCZUE?=
 =?us-ascii?Q?6YKdu5C1npBRFzUkrgLxYZli+E1LDaPIuJleM2/84CTR0xa/YtarjzZ6IRAv?=
 =?us-ascii?Q?hcDe4/Lsk/aEJ7lZjBJ4auId5Ag1unW28DbX0xd3BaNQMLZ+qgkbVaYH+/Wu?=
 =?us-ascii?Q?sQ5j0wps/w+iwxS8YL4FbTQ3WhhOoOrz25WaZKL8OU3m1nH2PBwwpqgqBo23?=
 =?us-ascii?Q?Y9A63Rl1ge2OzSi2PkHzb2tpXd6zhQieG5+9iSIXYD7vlbtxXf/J9Q+tkFPA?=
 =?us-ascii?Q?8/izEmDtGftB7t/3cli9NWDQmgCToRN+aoW5MODPX0G1ZoZpW5VlzUFa+EDv?=
 =?us-ascii?Q?YJYU3WzPKuPJV+F0gHGgczeUuco+YikZzOtvtnZZ9ou25fXyRDj5SeVA7dBx?=
 =?us-ascii?Q?k3imUCcH/5NylsTqgPTGQ4IYy8lP7jflAbDCo9A71iWRkgzGfFrTyHVIovXK?=
 =?us-ascii?Q?+UErLvAxlze6Ao4V01iLr5CNVawQw8a8Nsujk+7QftY9FbUviLG1DIbSfwvj?=
 =?us-ascii?Q?uh9lBjfewcKmE0lwpI4KCGH8U/eyxdzhlD270+9CovsFjGfXz4toLMA7x739?=
 =?us-ascii?Q?mW8harw+1ESj3iV99HYeIcRFl15vC5MpLMnL4W/JiV4/Y0oLUp5YsfkV3YP/?=
 =?us-ascii?Q?lFiCULCOA2ebGzE/n9mUW2o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20FD58246351734A93FC43AB4DAEF2CF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: befc56b6-234a-4c12-5193-08d9ad16dda0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:46:36.7453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /yXS/NBFleUBcmEerg6BxlLwV72zaJeXpV4QGD9ZaLbjnsnFbZcpXSTzUV+X8ZMpq3Q2toY6act8ZvIfuubbVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 07:58:51PM -0800, Jakub Kicinski wrote:
> On Sat, 20 Nov 2021 01:05:42 +0200 Vladimir Oltean wrote:
> > Currently, when user space emits SIOCSHWTSTAMP ioctl calls such as
> > enabling/disabling timestamping or changing filter settings, the driver
> > reads the current CLOCK_REALTIME value and programming this into the
> > NIC's hardware clock. This might be necessary during system
> > initialization, but at runtime, when the PTP clock has already been
> > synchronized to a grandmaster, a reset of the timestamp settings might
> > result in a clock jump. Furthermore, if the clock is also controlled by
> > phc2sys in automatic mode (where the UTC offset is queried from ptp4l),
> > that UTC-to-TAI offset (currently 37 seconds in 2021) would be
> > temporarily reset to 0, and it would take a long time for phc2sys to
> > readjust so that CLOCK_REALTIME and the PHC are apart by 37 seconds
> > again.
> >=20
> > To address the issue, we introduce a new function called
> > stmmac_init_tstamp_counter(), which gets called during ndo_open().
> > It contains the code snippet moved from stmmac_hwtstamp_set() that
> > manages the time synchronization. Besides, the sub second increment
> > configuration is also moved here since the related values are hardware
> > dependent and runtime invariant.
> >=20
> > Furthermore, the hardware clock must be kept running even when no time
> > stamping mode is selected in order to retain the synchronized time base=
.
> > That way, timestamping can be enabled again at any time only with the
> > need to compensate the clock's natural drifting.
> >=20
> > As a side effect, this patch fixes the issue that ptp_clock_info::enabl=
e
> > can be called before SIOCSHWTSTAMP and the driver (which looks at
> > priv->systime_flags) was not prepared to handle that ordering.
>=20
> Makes build fail:
>=20
> ERROR: modpost: "stmmac_init_tstamp_counter" [drivers/net/ethernet/stmicr=
o/stmmac/stmmac-platform.ko] undefined!

You're right, I'm missing an EXPORT_SYMBOL, thanks.=
