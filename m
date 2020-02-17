Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10060161926
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgBQRwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:52:18 -0500
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:59596 "EHLO
        rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgBQRwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1658; q=dns/txt; s=iport;
  t=1581961936; x=1583171536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=grWnaqNHy6oLMdR2hbnJO5oR+tPtc0j7uHR5RGdjHoQ=;
  b=a5ik/lnL3nU7TyL0H4ukTpw2cuGD7TfCg8Og6uDSmRaEntxJc31IVB9C
   ezceUqsaiEKYW6tX8uPR5WgHv7iWzrq5YIJ71PNzQu9hcFomGpA4ocX58
   rlvYFHiZmR83n/Ep2/Zv8uVyYydfOvOpqBtSfGyXtjDWMpJwLRDzNAQRZ
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3AVZ7J/h2bDuOeVSi7smDT+zVfbzU7u7jyIg8e44?=
 =?us-ascii?q?YmjLQLaKm44pD+JxKGt+51ggrPWoPWo7JfhuzavrqoeFRI4I3J8RVgOIdJSw?=
 =?us-ascii?q?dDjMwXmwI6B8vQBUT9LfPucCUSF8VZX1gj9Ha+YgBY?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BqAACS0kpe/51dJa1mHQEBAQkBEQU?=
 =?us-ascii?q?FAYFnCAELAYFTUAWBRCAECyoKh1ADhFqGH4JfjxYSiGmBLoEkA1QJAQEBDAE?=
 =?us-ascii?q?BLQIEAQGEQAKCBCQ0CQ4CAw0BAQUBAQECAQUEbYU3DIVnAQEBAxIVEwYBATc?=
 =?us-ascii?q?BDwIBCA4KCRUQDyMlAgQOBSKFTwMuAQKhbQKBOYhigXQzgn8BAQWFHxiCDAm?=
 =?us-ascii?q?BOAGMIxqBQT+EJD6EIyiFbrACCoI6lkcoDoI7iBaQOy2KWJ8VAgQCBAUCDgE?=
 =?us-ascii?q?BBYFSOYFYcBWDJ1AYDY4dg3OKU3SBKYp0gTIBgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.70,453,1574121600"; 
   d="scan'208";a="728264063"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Feb 2020 17:52:15 +0000
Received: from XCH-RCD-003.cisco.com (xch-rcd-003.cisco.com [173.37.102.13])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 01HHqFlS032016
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 17 Feb 2020 17:52:15 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-RCD-003.cisco.com
 (173.37.102.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Feb
 2020 11:52:15 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Feb
 2020 12:52:14 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 17 Feb 2020 11:52:13 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGQxYyQFkvQff271humGVfn5Ljxzrie+XdIK0zuVQuppdshsH71NwqJToNu3mOGSMJ+/wWA52j0O8EdFv9WR+es3fM43cxjHYYiGZ6MwljMIIsacHjOMz9nVex1dvXCXSB7mYgQroR1OeC+MQGq+eLvpo88aEc3/3u69uco+Uqt2TjdEgLJvcQ2ea7QcUFCblpQIwiguyteZx4vgEw3vadseW0GWVkvPGRFm/VMAB5qEVlemQVZgMm77dp9F+SgJhpnUx8KeGKEgjE05N/MbuF6urR7QFD/xi0C1NLHkuSsWq4h9GqxsrEl5h1Hzn6zCiudWa1NR83yLC1VJhzkqPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eDSoWAp2RszsZIC0GzfU5IyYNyVFd0QICznJx53dgI=;
 b=lgFwBLaf4BKeVZMl93FA5WYakU9655kq6sM9PoWPxjf8at2KUFV9r2LChUl8SvqkIoPb4MBt+uvu6lpxNwWNzrabio+HZFIIr8FcNdffB2DSGS2LroWL1wBh6SZ+2XtHUBjm0nqGLa5aC2iOH1kvf6NMlEhBWxuwJaHt2Z8wiBRRVJf3EvTtKx2hw/oFjQ5AwJCSeDIPt9RggYJlT0lzO4KrTFgdXqktZhPxP6/lKeX8Oa1WHmnWjrpRqod4fq2Bal9GMA+M802GXd7V0h7xcmHH5umEpKxaJ6Fecu4YcEvSVpqUd1c0ia9FQfLzo8egLgTsi8rdNjOfXrtsVQAi8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eDSoWAp2RszsZIC0GzfU5IyYNyVFd0QICznJx53dgI=;
 b=ptSjTNGPOqVS5+z73Bt8bLtRPEXut6jAHkEgIsSCSEmkg5o3HDjsmRifB0LJBqHeSOsnQigcWwdSzPnY7kk86nWNj53ybcSZEMyVsFHZ/1o9mMIUqJPli9UQP49bFcB3gLSGxljztK8yx3AiYG86M5XRoN4dRCrlc8HNUBRRz20=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB3125.namprd11.prod.outlook.com (20.177.227.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Mon, 17 Feb 2020 17:52:11 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 17:52:11 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Evgeniy Polyakov <zbr@ioremap.net>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Topic: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Index: AQHV5br7vHcY3LtkzE2GSB4q/RS10w==
Date:   Mon, 17 Feb 2020 17:52:11 +0000
Message-ID: <20200217175209.GM24152@zorba>
References: <20200212192901.6402-1-danielwa@cisco.com>
 <20200216.184443.782357344949548902.davem@davemloft.net>
 <20200217172551.GL24152@zorba>
 <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net>
In-Reply-To: <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45a6d45f-22ae-4bfc-0e71-08d7b3d21dbf
x-ms-traffictypediagnostic: BYAPR11MB3125:
x-microsoft-antispam-prvs: <BYAPR11MB312507B5E64E0AC378735F8ADD160@BYAPR11MB3125.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(6506007)(2906002)(478600001)(186003)(6512007)(9686003)(316002)(86362001)(76116006)(26005)(66946007)(33656002)(71200400001)(54906003)(6916009)(8676002)(4326008)(66446008)(81156014)(81166006)(64756008)(5660300002)(33716001)(6486002)(66476007)(66556008)(15650500001)(8936002)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3125;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rP68uBiohgvMUojwFXUFc5/ZFJl+Wek64pQKRFA5AVlcVtglUbwW91aTyO7iVIrBQMnU/M8OxrN3ntNRHng7I2M0djVyBf645+9Y4lrbaYVfnaM9t/mMsTfqBASBiJWsx0O1h2gEF5c7OIaWa9Uie5Um9lkgkQmuLW/adf9bVdUzyEAxPwtNEaGb+F77lP3WThO5Z7jBghMTUsx5u/c75PynDgIlp85fRQI2S/oe6rS0qeqVRLpwKzwLcaczeB/3monKGCFjyONKkNZts1XilcaW+zJyBoVCBTq+6U7yqTvmrp8TpDdlwIZ1nolTmfWIkMHZJ7NjfMzIDfv1WZL7EnG7kmBTvtJGZZebV49vy+9BHonGOcZgNqqSE1fC74nvTkMkWnNg5L9GRvwe8S4dhejJ6+b8pYqGr5Is/G+w4UfM3+Y5+L5GXBdbtES0b7+y
x-ms-exchange-antispam-messagedata: /bh+SE3WJ/Yd0VXudy1Wd1Es6p7DJahCkimSCtIhfVP1qL7WZXRhGhMyrwxyNjq+aIJW8JDRgPKhRwzb8a31ycq+Fa3G2t6dkbYcmlujkEPbKJpw8NVSiXiTzUumvaUJYPPd3lJbvYCZ5urI330O4A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9CE2DF0A5AC1274EB7C61D079447A354@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a6d45f-22ae-4bfc-0e71-08d7b3d21dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2020 17:52:11.8909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ZHFmfDnNjrtM9y03OlsQO3Nvdb6+eyyiHuscPSlvyBcTZX1HR7q2veDIAKx7hPH/lZLXlLcifKY4dYtWD79cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3125
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.13, xch-rcd-003.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 08:44:35PM +0300, Evgeniy Polyakov wrote:
>    Hi Daniel, David
>    =20
>    17.02.2020, 20:26, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
>    > On Sun, Feb 16, 2020 at 06:44:43PM -0800, David Miller wrote:
>    >>  This is a netlink based facility, therefore please you should add
>    filtering
>    >>  capabilities to the netlink configuration and communications path.
>    >>
>    >>  Module parameters are quite verboten.
>    >
>    > How about adding in Kconfig options to limit the types of messages? =
The
>    issue
>    > with this interface is that it's very easy for someone to enable the
>    interface
>    > as a listener, then never turn the interface off. Then it becomes a
>    broadcast
>    > interface. It's desirable to limit the more noisy messages in some
>    cases.
>    =20
>    =20
>    Compile-time options are binary switches which live forever after kern=
el
>    config has been created, its not gonna help those who enabled messages=
.
>    Kernel modules are kind of no-go, since it requires reboot to change i=
n
>    some cases.
>    =20
>    Having netlink control from userspace is a nice option, and connector =
has
>    simple userspace->kernelspace channel,
>    but it requires additional userspace utils or programming, which is st=
ill
>    cumbersome.
>    =20
>    What about sysfs interface with one file per message type?

You mean similar to the module parameters I've done, but thru sysfs ? It wo=
uld
work for Cisco. I kind of like Kconfig because it also reduces kernel size =
for
messages you may never want to see.

Daniel=
