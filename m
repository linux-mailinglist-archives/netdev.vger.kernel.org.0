Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742D32A118C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgJ3XX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:23:57 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:58849
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726051AbgJ3XXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 19:23:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O72TZe+b4fHEENL9RgHrteipUNZQ4AgyaPc8u5OGEZ1uWMDlc0/fVuXqtDM3zSOkahATKhmaeE2W1HPh/6QzXxOMKafzWHnXDWEZGfWVkVgSJ5m2dk+/qsKKJ0fOUa+LMLjWSIhubK0vkcBl1XfgdLxFOVdgclA3atuJrjC7g5YOvXAj1yloRqIDxWWADAwL5kVs2HJo4mCQEGhmQKcISNfTj71ps5O/2enMvn3d/e4NcG2xOxR507lMU+4zst0UX8j+1+EAGFrYHsg2WDRWznCRv2yzEgWWjvqBr5CK3OBTmpg4Xpqn0hZ5lHwQr+yVxmSYewjitzwg5c6XP0Zkng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vhj8bR0FEYSQLe26u0naRbFfDHrX8s0dwrX3QaS7wGs=;
 b=jzpzll8g7Py1H/O4i1lHoukCTQ5E+caFHmSg9BwjkY7sTnEUZMNoyIi3R22uszHJzXjUD4qCHkDu7wfA7NE8TLSSiI96p4F5nrFTN5m3Xw8cxVRr6krFwZa7kvbvrGzwL2Trni5nPGUiiZlcQZJTrB4b3axvO24i7AFWid3E6PaLld6EqPGB4b/KNg9l6Z5pgiIs5oJv6gv5+yXC6M4r8rVK2NhlQX3w4xRYc19QJHItPv2WJ4PAngO6XruN8zAHRFOxP0YTvfNbfCJAEWQM06gIRAddCxguSSMJxovmOVHYeh1aXApkSkeur1pZAfG3oXAyjefM33VVmub1yGpIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vhj8bR0FEYSQLe26u0naRbFfDHrX8s0dwrX3QaS7wGs=;
 b=b6byclA7ptlazZI8GuuWgH8I8ZqLwy6whn2pyx0KnJRnU1QeJ4D3aPRf1h8EICWf4GVe10kwX/wKaQuPchI90gi6NwN5zMEx2C6QgQL/WT+QitQt4gfCNo8gMlpZhMWy2HezwALezW+iTPQAyJE4biKPGbB7ZD2p4vpQUJZCfCg=
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12)
 by AM0PR0402MB3364.eurprd04.prod.outlook.com (2603:10a6:208:17::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Fri, 30 Oct
 2020 23:23:48 +0000
Received: from AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2]) by AM8PR04MB7300.eurprd04.prod.outlook.com
 ([fe80::b902:6be0:622b:26c2%4]) with mapi id 15.20.3499.029; Fri, 30 Oct 2020
 23:23:48 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC:     "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?utf-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>,
        =?utf-8?B?TWFyZWsgTWFyY3p5a293c2tpLUfDs3JlY2tp?= 
        <marmarek@invisiblethingslab.com>,
        =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andreas Klinger <ak@it-klinger.de>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Chao Yu <chao@kernel.org>,
        Christian Gromm <christian.gromm@microchip.com>,
        Colin Cross <ccross@android.com>, Dan Murphy <dmurphy@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        David Sterba <dsterba@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hanjun Guo <guohanjun@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Jonas Meurer <jonas@freesources.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Leach <mike.leach@linaro.org>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>, Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Roman Sudarikov <roman.sudarikov@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Saravana Kannan <saravanak@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Rix <trix@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Wu Hao <hao.wu@intel.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "coresight@lists.linaro.org" <coresight@lists.linaro.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i3c@lists.infradead.org" <linux-i3c@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: RE: [PATCH v2 31/39] docs: ABI: cleanup several ABI documents
Thread-Topic: [PATCH v2 31/39] docs: ABI: cleanup several ABI documents
Thread-Index: AQHWrpAP/5fyi5IMO0mg3rPCeBI8xamwyZ5A
Date:   Fri, 30 Oct 2020 23:23:48 +0000
Message-ID: <AM8PR04MB73004CAA0D31628FD8E0A7878B150@AM8PR04MB7300.eurprd04.prod.outlook.com>
References: <cover.1604042072.git.mchehab+huawei@kernel.org>
 <5bc78e5b68ed1e9e39135173857cb2e753be868f.1604042072.git.mchehab+huawei@kernel.org>
In-Reply-To: <5bc78e5b68ed1e9e39135173857cb2e753be868f.1604042072.git.mchehab+huawei@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [222.65.215.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab56f412-7e05-43a2-c8a2-08d87d2adaf8
x-ms-traffictypediagnostic: AM0PR0402MB3364:
x-microsoft-antispam-prvs: <AM0PR0402MB3364418B792F35188BB317EC8B150@AM0PR0402MB3364.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6cFTuXK2Z9T7IjE5nPSWOSW0H399lElCPFWNLu6mHH4GG8v3HOSeMavESO4H4I9gowW5Afs8cqovZdsdk4diWdRNgTMHQYwDH1gIcaeh79GVjuaHKoAYOp3+UqMXYEwxQUjNdknu4G2opTbyTt5NGMl3eveYDFQ1g+yALBS2JXjYDgu4OTZDsAdNins5Z9iDdhCsUh0n0Ac2pzEW3Phd67aVAH58rexxKss/OEMy3djmxSUwQ9eE4OVx9tAi4dePxA3E9MEfzHQJw/slZ/Ty7x+f7PPl2UIexlQS7zANo59gM4rJc6WFgnp+Rv6XZzIwB/1/1oMSKbmZPfGlnXqUqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7300.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39850400004)(66446008)(64756008)(66556008)(66476007)(66946007)(8676002)(8936002)(26005)(76116006)(33656002)(9686003)(558084003)(2906002)(6506007)(86362001)(71200400001)(4270600006)(7366002)(7416002)(7276002)(7336002)(7406005)(55016002)(478600001)(44832011)(316002)(4326008)(7696005)(52536014)(54906003)(110136005)(186003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LmyEy8+AlZr0dH3UtrHGN0gD8GkdEEPWI6n0X0Rk9JUl98O2+sB6+ZwOqVeIHcBYcxrKBjxFhjCb8dqfdB/GiKbLBrA0yyNdIPWoaTbTwIsLEJ1DBRVPEmlTd0blnrcQx9YbXzGI8eyhzke/H8OTBO8bY+bql8ELMv1wkrZDm9dzENVDiUbtBX3wGEYJYG+bR31awYvDh9k6VGUIH/Su5TWldhdNDcKPXkVmWmEM5d0sA1jF3QTyzY988DJJR6tJME+CvU93PQruGK+n3wrUZcn5HsmXC5AHnv3gFK+mMmGJRkDvfOtHItzNPyLoxDHdtbOd4hBKu9Eb6rw5XJ/PpWTH9gNj2Q2CaloNw7FWZfRwJ1nvMg/iUFq+eRpwELo1IANZ/LbdrOw/dIvuKtzdPbLUKTlyUm4qOqJjYqDF/OJ+LuAGU+BiWOBseSX7crvpQWuinc5ZbXMMgn1dkD/01Xls89DDDRP7Iw1ciEB4Im/5vXLnyyySSOlgIAQayat+uTuzaoD3U6VWZ3Kk8LLN5AeIKfYe5W6q7eUbyqOl1eeCC03y1tBciW6p5XccP84xOHvRLzjPponAsdRrafe1wbkM0cZhg0BrYnwpUtwg8KWqJ85Mk1ba56CTOL8R6NfE4LQ7lQBUVRpnNQl92xjpng==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7300.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab56f412-7e05-43a2-c8a2-08d87d2adaf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 23:23:48.6948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8UMbaQT8WSLKAWQn2nnLbTWgleWz5CJPLtzNg9ghlA+i2S0NB1XdlA7k+9UyIpcqSYEp8v3iM7Y8S+CVX+++sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWNrZWQtYnk6IFBldGVyIENoZW4gPHBldGVyLmNoZW5AbnhwLmNvbT4gDQoNCkZvcjoNCkRvY3Vt
ZW50YXRpb24vQUJJL3Rlc3RpbmcvdXNiLWNoYXJnZXItdWV2ZW50DQoNClBldGVyDQo=
