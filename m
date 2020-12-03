Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1512CCE0B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgLCEoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:44:20 -0500
Received: from mail-eopbgr110107.outbound.protection.outlook.com ([40.107.11.107]:49715
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727042AbgLCEoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 23:44:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EC7YvVKRA48yUBeS39UYynioSL/iZbcEqhcxEUYZN4nIKxJzAWfwpqlj/EefD2E4m1q7xqWJoLiQDcACboq6i0SpbN9h7qe7vw3IGb1G1OaDBTmEK0p+5TfTqnPhZ6JNcDMrZtlVo1fr/Ao5AViYo4rnysBTAXInrIvKK8rJ/HCkNy5ktHR+KulTnDQEws/5X2pLua4kTGoGgGJXTn9jOx4d1NvK3ZwyWBG0SeZqmMmq45/0eUYmIsMIL6mtuwxjsJZu2f0XqEJc3oY/GClJLE5/1d7dz68s6PgT+nAmuCuhG2qzdyCTX/IWbif+6cdrthSl0+jOrl6+nXmdc25h+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41uxi4sLcP7B9eQlW1Oyi5vgC6I36P0yGkxFF3vIGy0=;
 b=KXJ2Uai6pkfC93VUMZxR4av7DLq9ewwJZYl964GJL6mL+Vc3no6B5h475Z58f4oDb4oY9usNETHKXe0bafxhjbkuqu2PMsAh4zztH1r6z9Jz250u1GYFw/d20pCcYGW5i2HbFzRysbg2mA+XFI6p8XO368i6h2V1/PEWr4RjmeQ1jPwTE82X25nGZYnsgANKkK5JxFplHpg6MDGyrgrByxh2/xj66YUXf9tvAYHa7VgkiGRpBA3sv6ogJCHiOZMqbIdHyr+76wW6j9JjiZxo2J+GlrEbMlCBfbCMWX7LgeAdPYa1p1bdAxXZjWWwVn+xWOyyyFCJYQmqHbg94+EyMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41uxi4sLcP7B9eQlW1Oyi5vgC6I36P0yGkxFF3vIGy0=;
 b=J2KcAef+gmo+GeKI+7pnLzu5xi1+RS9MOua7XkcUGQqpEdiy3T4ylgBT0MKZ9Bb6i7ktup7BEJp5jSttInrvvSalCzvXEgbybGYHGfYG1zUP/pyixX0Fz9PaBnr0oZHV1RNqCEB9KhfC/LghB+HIVAfW7ouqoPdRRmiZZE/UEBw=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWLP265MB1139.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Thu, 3 Dec
 2020 04:43:30 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee%7]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 04:43:30 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v7] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWu/oh8T+esyecpUerAB1FdPgUnqnXaMIAgAKA/DiACvt14g==
Date:   Thu, 3 Dec 2020 04:43:30 +0000
Message-ID: <CWXP265MB17995D2233C32796091FFEE4E0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20201116092253.1302196-1-srini.raju@purelifi.com>,<20201124144448.4E95EC43460@smtp.codeaurora.org>,<CWXP265MB17998453F1460D55FA667E51E0F90@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <CWXP265MB17998453F1460D55FA667E51E0F90@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.104.125.236]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 948c3068-10b4-4308-6c2a-08d89745fb80
x-ms-traffictypediagnostic: CWLP265MB1139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB1139823556CD3E77ABAD7CF9E0F20@CWLP265MB1139.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Omo/tQ6l5rZsL02a38HhRKLPnOJI+GoH4ifBojWhEE7juVQaGapuF5aXbpl9NjYGQz+XqhRglEq/3i8EfbVBgHiLmz6iATwr3yxAIHAOtsesBl+fw3KRZtj8Enw5CL4njtTXahf7AWJi6kxQKuClOESWmtcwMUKJAngSj2fOzU9B2qtr+4cFbYXnAVLLETiP7Uq4w3lTsF6Vy91EkfcVJm4xmZ/vPAkzjQuHXIqhBN0nifMtQA21T5R4F7M8+tOhgTnFjC+ikUOKi/l3s4zl7FVZMroU4Agi+oI1MPG1holJ7jOX70AnWabSlfkiwGMed9HcptXDEWlZ0YTKKFYENK2guYTiMWEmBZeYoNBeritbFMHpNOySIsCiazfPuflDYNF1cJY+9aYaGfN1job96Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(396003)(39830400003)(366004)(136003)(346002)(376002)(53546011)(5660300002)(6916009)(316002)(6506007)(26005)(54906003)(7696005)(2906002)(33656002)(4326008)(8936002)(55016002)(186003)(9686003)(52536014)(86362001)(71200400001)(8676002)(66946007)(83380400001)(64756008)(966005)(66556008)(478600001)(66446008)(76116006)(66476007)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?Zei7RGzpYwwS2Ny5JQAcHcSjL3/VzvnQm2FHGXxnBlyCADehKWBvWMSuDj?=
 =?iso-8859-1?Q?AhuBIUMVr+voEGzrNRT9il2oyQVlbo/YhBWwyzIoLwlxp7mcawHamZZKw9?=
 =?iso-8859-1?Q?0fQhd0jAdHttQXqedwgsKBejaCGJlGTyk4DPGTeGneBYzUPZdRzWsh1bG9?=
 =?iso-8859-1?Q?4yqF+QXPqCMJDqH1e44PIqzKJ8sWiMZTmyCQjMtaqu5BkK7WHZ3Pky7YT1?=
 =?iso-8859-1?Q?+QKPxTDl/h3OqpgGqqhzZLNC/A7ETJ0EAgUtc0ZgKslFUH4GdQSfmZh9Zz?=
 =?iso-8859-1?Q?kp0jbM0c5LNO7SffJQBJUk4ZmWENjXT1U0G7LlPSpwM7Z3BJG4Ebsj+saK?=
 =?iso-8859-1?Q?s1KGG4twMMQhL/qJplgbhoUkaPsXiIg6hQxq8YyvCr+DPENZIBQ7jnG+Mh?=
 =?iso-8859-1?Q?fFISVLvtv97J9xC84NcrjN6ccfmObVP8elXdwglduueK9Uw5lTT0KMPWCa?=
 =?iso-8859-1?Q?4gr0vvXjvp/LQXROBFV+k/eZbLIC/ep1oUBafjmgniOAhN2H92hwbJY9Jo?=
 =?iso-8859-1?Q?1MBmtoAZ0RvwqaazKkKQfaeHI3JvFKU6kcH0YjCF+HEL16ZGZHf+whOWAo?=
 =?iso-8859-1?Q?cJ9BaY2EfgQGuixcrBIc2DpH50j+fTFawB9BkZ50HmGp8k8ZUFd9Oowr8I?=
 =?iso-8859-1?Q?fAPlsdSCoHy4jTnPmtGr1jn5dJBwcg5HsbYSQsK9kmTCKYn6u9eWwoTAmF?=
 =?iso-8859-1?Q?YegqOh4EVCw3VQy0Le3SabWmxESoJMI3Ls/yjU9RocKqQSAd/ErXUPlTrX?=
 =?iso-8859-1?Q?8Pg29Y5EgXEodzMxk++qJmAdcepAZJAHhgBT2aNmTWI6Y2ETUpnn5uHwqj?=
 =?iso-8859-1?Q?LucWK3f65eXLA8LAvIlXQZCD59OFUDS6/1sU4h1ccpkZb7LOH1ZjXNtaLR?=
 =?iso-8859-1?Q?M82nIiZB5r27eMyx6I2gvuvP8spxtu9D1+AXOGgxwYkv9e5y4KeyqaKO2N?=
 =?iso-8859-1?Q?vtXnmK7xqDmZF1bDe3JizNSfixYXyJCsOLKiSiFsdRPkpYC2TD3iw10q5T?=
 =?iso-8859-1?Q?4a/qVZQ32WEcgnG4w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 948c3068-10b4-4308-6c2a-08d89745fb80
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 04:43:30.0352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z11ostib+C/lqXPwpSy58s8F0xXOf1KofSXXbZnj544rCLXckERfHmFLP+N56/zbV2m/tBN3TLV3cEBCoAG0Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,=0A=
=0A=
we will be submitting to linux-firmware repository @ https://git.kernel.org=
/pub/scm/linux/kernel/git/firmware/linux-firmware.git=0A=
I will share the link once it is accpeted, we have sent another version of =
the patch v8 , please review and provide your comments=0A=
=0A=
Thanks=0A=
Srini=0A=
=0A=
________________________________________=0A=
From: Srinivasan Raju <srini.raju@purelifi.com>=0A=
Sent: Thursday, November 26, 2020 10:31 AM=0A=
To: Kalle Valo=0A=
Cc: Mostafa Afgani; David S. Miller; Jakub Kicinski; Mauro Carvalho Chehab;=
 Rob Herring; Lukas Bulwahn; open list; open list:NETWORKING DRIVERS (WIREL=
ESS); open list:NETWORKING DRIVERS=0A=
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi =
STA devices=0A=
=0A=
=0A=
=0A=
> I haven't had a chance to review this yet but we have some documentation =
for new drivers:=0A=
=0A=
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches#new_driver=0A=
=0A=
> Is the firmware publically available?=0A=
=0A=
Thanks Kalle, We will make the firmware available in our website for public=
 access and share the details.=0A=
=0A=
Regards=0A=
Srini=0A=
=0A=
