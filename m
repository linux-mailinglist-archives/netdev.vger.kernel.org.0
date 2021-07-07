Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349653BF1BB
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhGGVyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:54:52 -0400
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:46273
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230002AbhGGVyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 17:54:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGlI00tOYmH5JlziKq/YJEi2G81qTDnMLXD0g38ik6DfnM0fAeopR4eLT1hdnPRnDZ8i7uO633WimO/ulohWRnVDoKLAj4ILVrE4zuY9aQ6LEKOQmLg5l8BRTZXvolUV76N/CHs2wIIPjO50NILCtNWIwpD6kbr3U2UpK06tAsjz9TMSIk9eZ5yVZ46e+0twVfz/6v+r9lC8p/2r0BXU11Hyu7ysatrFHXI026sSArYV19vJcH/xiqTRCvRpqFWea/lksv3CuKfidvMK+fsJNku2nB1PNOaXbiqtp+HcVtui12vXXAr69WiFh7Rd0y5kvtAS5fPPGYTSiAGbgLI9jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOlcEdl7QPNc6aw+1dLvTyRyvVtdMsDxOzlMGNdOHQA=;
 b=AiHB8XcWUzftmRQ8B4O/zoeQlhLDIu4bcW+pvwfO5IsHVyUGscy/I9slvdI4WgQVktekfnhryaEwdFwTFR9imSMoCc7ARUnSrm1lo0QSMZZylMpO9wmjhJstddGpfrjQzsjZ6jsxhAkML4Y7hsoIfHC6tg++Wry/XcWXGJSlXi8DgBGUqDzUjEat06vi2vUN3x6vP4m+8BkhOlq3PsVo58xAjDuzfXE5VEmUY9jJo9CFe09LXvRtMvEygejTKmsr77qKSu+EoDaglo0q6aconvgiVlPLTKovwKAKscuSXmhWqg5tGP1bUJuT5wpB6DoQThzZyVtb5TI5bWVDfJIrWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eckelmann.de; dmarc=pass action=none header.from=eckelmann.de;
 dkim=pass header.d=eckelmann.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eckelmannde.onmicrosoft.com; s=selector1-eckelmannde-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOlcEdl7QPNc6aw+1dLvTyRyvVtdMsDxOzlMGNdOHQA=;
 b=nyoOMG2EmWX7k1wjdqkZw23W20Vbar7Ie7yaBQcRChgP48y90jPdfJOftoeeMoO4Jvuck46m4ECg7nBFX2PDldDe9whxUm102xMg+bGkcq6MSVWb/aizip8qyVPN1ROdiJG6B3GhSHSNuHYFfZgsJa7BNBB0tyB8MvXV6LjD+K4=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=eckelmann.de;
Received: from AM9P189MB1700.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:2fc::15)
 by AM8P189MB1411.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:242::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Wed, 7 Jul
 2021 21:51:56 +0000
Received: from AM9P189MB1700.EURP189.PROD.OUTLOOK.COM
 ([fe80::cc15:eec3:792a:3310]) by AM9P189MB1700.EURP189.PROD.OUTLOOK.COM
 ([fe80::cc15:eec3:792a:3310%7]) with mapi id 15.20.4308.022; Wed, 7 Jul 2021
 21:51:56 +0000
Date:   Wed, 7 Jul 2021 23:51:54 +0200
From:   Thorsten Scherer <t.scherer@eckelmann.de>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pengutronix.de, Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, Michael Buesch <m@bues.ch>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Marc Zyngier <maz@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Samuel Holland <samuel@sholland.org>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frank Li <lznuaa@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        SeongJae Park <sjpark@amazon.de>,
        Julien Grall <jgrall@amazon.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-cxl@vger.kernel.org,
        nvdimm@lists.linux.dev, dmaengine@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-input@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCH v2 4/4] bus: Make remove callback return void
Message-ID: <20210707215108.ervxrkmbitp3l2ej@ws067.eckelmann.group>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210706154803.1631813-5-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: PR3P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::6) To AM9P189MB1700.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:2fc::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:1f08:400:4::2) by PR3P251CA0003.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:b5::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 7 Jul 2021 21:51:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8987669f-0789-4189-d163-08d94191700f
X-MS-TrafficTypeDiagnostic: AM8P189MB1411:
X-Microsoft-Antispam-PRVS: <AM8P189MB14112A254C08C477E55D0F8F9F1A9@AM8P189MB1411.EURP189.PROD.OUTLOOK.COM>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lb/VPh7eDx+8uAXqVeH7DJbNAOhaPuWa3f5CT3h/INJORJ7mDCVWkm0CgKnudmpM9LI5W5r92BSyz0MjERB/4Gl2oyYOs5kUzr701FfZiZY78zjaiiCvN937bnDKnFeBpH+5Eg0XX7n3GmrgtwbkOF74I2eM77+1VB/tY4YSiuWcARdLL6shSP45qF4FNj14/fNhVk0AUdcYfeOIsUk5I+bI5xtVyT9lRX30HosaKOFmZ7WZfL8Pedh+pb+FJSZr0vQK0xnGVagwa0sx0K5bG8EuKmDPkT/kHKOPCLtGkAy9cHH/TjUWbnenC+qYCABLS+BPXtsyhf09uojC24nCdD6qpui9tRfVEwLNN8soTS1mPqkyUjZbH2duVE8voOYUrFxoT5VB1WCHtBxJ5pf1YHLlwyNdvfjWduXRSI/1dx+pMFumUZbz4qaAIhbKhp3k0T8lKtEnVUz1tojhWXN5dkSDoOv2v09TWzbH8JNtjcm1shSJu2Ue06Lwl4vcFB4WVvzTisBKRlH4667qd3Fi6Wv0p3pLcBqXqFfUQmYbwjEjD/nEc8Xh72CCIvB6O9DMV7wGTsqVy1qgEVLiQb7fmJ1dUl9klnw57ekGd3WclklG+03/CyMV17aN8kRx6CvN4qltad8RnDU9uLm1fTUAh5SoGDVUWTVbMn1GXRNjoedSG7LnFrqmeG64bEyhrVjZW5I/ar6wxxFNkjqLmm8bNT+cimHXdWK0dPvh0tD8gYmiOnkVIw4J0AkuOz9DJBQNbLVcUoE/FBD9hslaMn1fvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P189MB1700.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39830400003)(366004)(376002)(136003)(4326008)(6916009)(4744005)(2906002)(6486002)(7406005)(7416002)(15974865002)(8936002)(8676002)(66946007)(478600001)(86362001)(5660300002)(316002)(52116002)(6496006)(1076003)(54906003)(38100700002)(66574015)(66556008)(66476007)(9686003)(186003)(557034005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?eDZZLUdi0LX9JYklNk1x7DqZXpMygmSWtSlaRlIBVNvRThOPePohfCLPA5?=
 =?iso-8859-1?Q?vqTMntKBtCEzz1xuRmWc4X3UdMrUl1+m/hUKXWwf8ByXww3o0gauh+nl2C?=
 =?iso-8859-1?Q?69oPdOhoDszfyN+oGyL8lKfkoIoELQDUp0Ha/E97SArD/mEBG3+8tGTpoH?=
 =?iso-8859-1?Q?R+/Dsd7ze7SAecXrgTcbqeE58MZtNUpv6qc3jyupRynVRxr2WwsDmPuw4e?=
 =?iso-8859-1?Q?VI6CvmvETAdFJ7Ich0AROZZHaaUyJXsw/T2LNLCk+NStIuzMFGKY/Tu6Vv?=
 =?iso-8859-1?Q?O9IX5YhN0GV5QDX4Gsp/qDQURyrnlnkOC6lE8kQoPlhRq7jFr1VnQWEVGh?=
 =?iso-8859-1?Q?4LphKn/5DEwUQSIv8a7ViE8raLMb4ZH86eg3sfpHrl8s4+QoxOdloluOpj?=
 =?iso-8859-1?Q?C9Wn34IqqcUow6TqqcoR4ZBmSIL9f4N5vo+8qJiIgtqJFtTzxqKOkWerSD?=
 =?iso-8859-1?Q?BWaD4YYbjzfF2ilwbrH+rqO8VnQXI5ld4/X1jcyMYvHLz6bg568C7V1KxD?=
 =?iso-8859-1?Q?Y7zEert5KiX/SyywI0tPlAyuqfgQ+6UQlk+fc/BPS+uz6jMsoaLINQxYVi?=
 =?iso-8859-1?Q?P9LpStzEEQAWUszpav4E4QzsZArxc2DTNOGkorJY8NnkthOeL7CBmQ8uSw?=
 =?iso-8859-1?Q?4URnC8tb0wov6bGORczmFXo4v5xsDTy+Y56CvMO7rKQ+mgK3EK3ynmizZ6?=
 =?iso-8859-1?Q?N7XObtVUWYuaOWevEeC5xqeZAblK7p/xBUrOZS/l61QdC4RpPv9x9LvOAn?=
 =?iso-8859-1?Q?rj5gjedsRyLrfjqZmVJD83C87tjMqZcwwWTTJXAZOK2BL6xcf9DCZeazaK?=
 =?iso-8859-1?Q?a6QmImE/vabFEUTlnw9THp+zXcbVPVJwCtXiHoFGQXYyMCIt6eXWo8O0vC?=
 =?iso-8859-1?Q?XslR0dVr6kKfKIJQ6pn0IKWgBw90OARdiPlJO/xswtkxlwACx9NcI/a1gf?=
 =?iso-8859-1?Q?Bxw4s+R9Tq/3wzGyGeszWMKLIr9cxaPrn5ywIu/smDokwdrndWaH8PiJlY?=
 =?iso-8859-1?Q?PeZQQzAB0LsN9sLV0OTfnoaUFyOd/NO7G91skbNKrwTr67CSMLZpO0Efix?=
 =?iso-8859-1?Q?ePmY/61Phqj1rTLGOc5UUnvgvLdUKPalem/6yK0T7emq+mTJ6f2adICuEA?=
 =?iso-8859-1?Q?fIeXJzzGT9XkhMHRlK4s9uNkklGZHW8ChgBnc/l37rX3dBSq6YR1xbogeC?=
 =?iso-8859-1?Q?vIIUdfOkiaNs6trXwq5V4kjGCaGafYjiQV1vzfd2NygYMLcH0Gy1Qm5ULX?=
 =?iso-8859-1?Q?/TafMLXdYbz3Nc2PBViPY72+XuZIeTPAyFAtWijazfS7dod5Zu9NFXXH3V?=
 =?iso-8859-1?Q?J7zFPCNC7zR7ej2QYOwXouGEQM83Ck5nULNdh8XhUk5cmio9IZQll40jUK?=
 =?iso-8859-1?Q?QIQevgKi3tv9aWyxzUZyC4tJ5cZcdoug=3D=3D?=
X-OriginatorOrg: eckelmann.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8987669f-0789-4189-d163-08d94191700f
X-MS-Exchange-CrossTenant-AuthSource: AM9P189MB1700.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 21:51:56.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 62e24f58-823c-4d73-8ff2-db0a5f20156c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ur8XMZiF6bwEyBALI0qg2jMFHKKsDYaGvYi6ddYfgV7bn1VoiuIVhLN4LTrTEmRStKglRvEnKtWfYKCJBBKoYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P189MB1411
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Jul 06, 2021 at 05:48:03PM +0200, Uwe Kleine-König wrote:
> The driver core ignores the return value of this callback because there
> is only little it can do when a device disappears.
> 
> This is the final bit of a long lasting cleanup quest where several
> buses were converted to also return void from their remove callback.
> Additionally some resource leaks were fixed that were caused by drivers
> returning an error code in the expectation that the driver won't go
> away.
> 
> With struct bus_type::remove returning void it's prevented that newly
> implemented buses return an ignored error code and so don't anticipate
> wrong expectations for driver authors.

[...]

>  drivers/siox/siox-core.c                  | 4 +---

(For drivers/siox)

Acked-by: Thorsten Scherer <t.scherer@eckelmann.de>

Best regards
Thorsten

--
Thorsten Scherer | Eckelmann AG | www.eckelmann.de |
