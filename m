Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D72D162A96
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgBRQas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:30:48 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:20257 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgBRQaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2670; q=dns/txt; s=iport;
  t=1582043445; x=1583253045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mTgqRdd/Bs0ck7gsXL9XzqNJSQImHuyRLnV/Kz3yf+A=;
  b=D2PphpnyJzNuB3a8fY4HvEpA09hD/WITnVqtYNIy4Wwvkw43eF00s5MQ
   teDZo5/RXzs8XfNLyD0IWHaPumu5Df38C9CELA7B/ZtwsspfpK+4nMuBY
   y/6jmklvWkNKXIhVv1rlGL+WuzyhJ01jM+6KjLTX2J8UksxXeKZPIPNsO
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3Afx2R4hdYJG58Xu26BLBd1p7/lGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/YyU8HclGS1ZN9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CpAADeEExe/49dJa1mHQEBAQkBEQU?=
 =?us-ascii?q?FAYFoBwELAYFTUAWBRCAECyoKh1ADinqCX48WiHuBLoEkA1QJAQEBDAEBLQI?=
 =?us-ascii?q?EAQGEQAKCAyQ1CA4CAw0BAQUBAQECAQUEbYU3DIVmAQEBAQMSFRMGAQE3AQ8?=
 =?us-ascii?q?CAQgOBgEDCRUQDyMlAgQOBSKFTwMuAQKiCgKBOYhigXQzgn8BAQWFKxiCDAm?=
 =?us-ascii?q?BOAGMIxqBQT+EJD6EIyiFbrAOCoI7lk0oDoI7iBuQQi2KW58jAgQCBAUCDgE?=
 =?us-ascii?q?BBYFUATaBWHAVgydQGA2OHQd7AYJwilN0gSmMfiWBDQGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.70,456,1574121600"; 
   d="scan'208";a="726862527"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Feb 2020 16:30:38 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 01IGUcwR022367
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 18 Feb 2020 16:30:38 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 10:30:38 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 10:30:37 -0600
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Feb 2020 10:30:37 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4lX4mJkjzqz69Tmvr0mXMSJ7tKaccn+TP/ddRphxnd1cLIkhid5h2gMvTRXZy3Dnh5mmBCtKxV1keGdpPE3AtQeEeBCQkKrUWPe2NkTUQOFg5KIHujajarkEGh0YcnKd7DwnytoUANG4weFTLtNO9VFd2vnFlm43fuIsAObCl6/oo7h1MEIfx5bQG+/8b/WNI6VHu1ytk5Ch5/EfXw9EbbUaaaK058/fy70RO+NUDGEvkIpSV2Bcrdt09wnOT3DDeQ7b1yRBPFOm6GxHWvEOifQnCRGJNlgvH/RE1Wv8Bw5uMFMyS8tfkUA6JvPYbaxqehLS1nTwIabz+ktBFdH0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hV4m5vjm3poI1yQnWcSutMqGGDFkvtpfOOyVXaGT00Q=;
 b=MnqsiUGoxvyhSZTsub6JIK5RoWub5YTX5V3uP/b2vxdx88ZGB4cEBmssmYi7pANeyMChmUeYGa/cY22fjuHDgZv/z5CIZGjpM01YPjqUmSYdN33YtqpES35Lu6tqK9s1WW/4ZilNrjB1NHKa+RGrz/NGin40e+nF7z7l/xGGM0k09timo/Czirh3TBFRt/p3JscIByeX5pJTSHBDh4qKPoaG7a0Ak5wzfFE92HdYSW7BwuogUrcfb2vjJvbuWHrJO4xpG4VK7i/PNzQ4xr1snWdSjCni3Hu7936H3blO5ZfIC5niwlCKiaP8pBOBR3YaDz0YSVqHL+zyIQOS8ARnag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hV4m5vjm3poI1yQnWcSutMqGGDFkvtpfOOyVXaGT00Q=;
 b=gB9OaCA9YRJH1vSODRXxsnFoQDK9qmprWOUjugy1hAPKYfZBkVAAGrLXD9069JeL270dUg+vdugGr3YtaqDCeTbRoexGjOlypTMSPDZPXJXuTxjq1GfnHhupPcnEG3u3L4ulhpY9lnRw1CTZKsGkfswiOKapfb126lCTj1jqZuI=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB2933.namprd11.prod.outlook.com (20.177.227.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 16:30:36 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 16:30:36 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "zbr@ioremap.net" <zbr@ioremap.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Topic: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Index: AQHV5ni/yHZMW2wqgkeUEsFC+E+QMQ==
Date:   Tue, 18 Feb 2020 16:30:36 +0000
Message-ID: <20200218163030.GR24152@zorba>
References: <20200217172551.GL24152@zorba>
 <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net>
 <20200217175209.GM24152@zorba>
 <20200217.185235.495219494110132658.davem@davemloft.net>
In-Reply-To: <20200217.185235.495219494110132658.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78b4ab45-e630-483f-bfcf-08d7b48fe227
x-ms-traffictypediagnostic: BYAPR11MB2933:
x-microsoft-antispam-prvs: <BYAPR11MB2933EA0B1D3257214A14F0D0DD110@BYAPR11MB2933.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(189003)(199004)(2906002)(5660300002)(6506007)(6916009)(316002)(33716001)(4326008)(1076003)(33656002)(71200400001)(81166006)(81156014)(76116006)(15650500001)(186003)(6486002)(478600001)(54906003)(66446008)(66476007)(66946007)(86362001)(66556008)(8676002)(64756008)(26005)(6512007)(9686003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2933;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VSsuerhOihi3MT+ow0IqsU4EA6FHKrwwqpFFntVGYkgjXu337oodBMiJonSJMkCTnysJddUJUSZg7DQPo4oCiF46hJePRocmEfkGpG75klzwki+5Iz8JC4kd5MRYLKRFKX0/yr9EwPSvyqEziGQ4k1Lnttg+SaGJcKpj7GJ81LWEv4PqxemHr47igKX++FU3XBhjA2CAcUKRmYBkYdCfWZpdVdJsfhUKrHuwLTInJ4oJHPfLLBfEbaWUdyRuLQozNUs3eG2JVZ+3TmwBzDuuRsdDePJWA7ALkehZP+WaVG/OumWY803NKla8RcouX/5gIzFOt8RoQK1XuUx9Ge+jEnzRgyUTSElkrdoqQ7VB/Lg5ePtRO55pUODWFfGW0kmvHvqEfgytNQrSkq0DMeepTYyUpecaKwlaSv07dS/jL9gR8P5/ytbIXdGgt2wS7OjL
x-ms-exchange-antispam-messagedata: hATE0pJoapETSt5rokd8RaB7QZ0LlN5QterMNWApq8Ow9eKGEIkxQdIHnkyFL464DFCNXrPltjxxrG1qAxs3nXKkhYLPNLM/oYL6rAI7T25uF4RbVYO5AxSyzyU2ANuLcpZhubLY6swGubUhyi9Q9A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C431B50AFEE5842BBEB448953213781@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b4ab45-e630-483f-bfcf-08d7b48fe227
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 16:30:36.2164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: br9JaVMmKyFIxx8kc9LCH+6KC2MWweGGQA/pGZkE8ZQwW5F2NwYIyxwW80uRbylsNihQkkCPJXwLC6Pkl98AeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2933
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 06:52:35PM -0800, David Miller wrote:
> From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
> Date: Mon, 17 Feb 2020 17:52:11 +0000
>=20
> > On Mon, Feb 17, 2020 at 08:44:35PM +0300, Evgeniy Polyakov wrote:
> >>    Hi Daniel, David
> >>    =20
> >>    17.02.2020, 20:26, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
> >>    > On Sun, Feb 16, 2020 at 06:44:43PM -0800, David Miller wrote:
> >>    >>  This is a netlink based facility, therefore please you should a=
dd
> >>    filtering
> >>    >>  capabilities to the netlink configuration and communications pa=
th.
> >>    >>
> >>    >>  Module parameters are quite verboten.
> >>    >
> >>    > How about adding in Kconfig options to limit the types of message=
s? The
> >>    issue
> >>    > with this interface is that it's very easy for someone to enable =
the
> >>    interface
> >>    > as a listener, then never turn the interface off. Then it becomes=
 a
> >>    broadcast
> >>    > interface. It's desirable to limit the more noisy messages in som=
e
> >>    cases.
> >>    =20
> >>    =20
> >>    Compile-time options are binary switches which live forever after k=
ernel
> >>    config has been created, its not gonna help those who enabled messa=
ges.
> >>    Kernel modules are kind of no-go, since it requires reboot to chang=
e in
> >>    some cases.
> >>    =20
> >>    Having netlink control from userspace is a nice option, and connect=
or has
> >>    simple userspace->kernelspace channel,
> >>    but it requires additional userspace utils or programming, which is=
 still
> >>    cumbersome.
> >>    =20
> >>    What about sysfs interface with one file per message type?
> >=20
> > You mean similar to the module parameters I've done, but thru sysfs ? I=
t would
> > work for Cisco. I kind of like Kconfig because it also reduces kernel s=
ize for
> > messages you may never want to see.
>=20
> Even the sysfs has major downsides, as it fails to take the socket contex=
t into
> consideration and makes a system wide decision for what should be a per s=
ervice
> decision.

It's multicast and essentially broadcast messages .. So everyone gets every
message, and once it's on it's likely it won't be turned off. Given that, I=
t seems
appropriate that the system administrator has control of what messages if a=
ny
are sent, and it should effect all listening for messages.

I think I would agree with you if this was unicast, and each listener could=
 tailor
what messages they want to get. However, this interface isn't that, and it =
would
be considerable work to convert to that.

Daniel=
