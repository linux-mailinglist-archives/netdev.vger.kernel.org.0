Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF51648C7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgBSPhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:37:23 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:15793 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3230; q=dns/txt; s=iport;
  t=1582126641; x=1583336241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3RGpDVPjStG91MJF435/r3PMSvdfLUTB8M+s99UfUd0=;
  b=V+fBlsHqsJiR4T0sDcj/P5LRhdfgrVc8FVSRyyO6d7o2Y5m0Mr6Cz4OC
   JaEfjbpR6+lXgV2ELAQG4dZUBWsHwNiNge/6OkEHEwGGqwEHeI4ozwHvG
   pLBoBMx4SbOW5TRNgDkVHZ/uj0RLAKjugxkUV60xmi0kp74Nfh6ETnUQ0
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ama/SlBbldZHMWwe4U8dLwjz/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el20gabRp3VvvRDjeee87vtX2AN+96giDgDa9QNMn?=
 =?us-ascii?q?1NksAKh0olCc+BB1f8KavmZio7EcBdXXdu/mqwNg5eH8OtL1A=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AmBgBdVU1e/5JdJa1mHgELHIFwC4F?=
 =?us-ascii?q?UKScFgUQgBAsqCoRrgmUDinGCX48WiHuBLoEkA1QJAQEBDAEBLQIEAQGEQAK?=
 =?us-ascii?q?CBCQ0CQ4CAw0BAQUBAQECAQUEbYU3DIVmAQEBAQIBEi4BATcBBAsCAQgOCgk?=
 =?us-ascii?q?EIQ8jJQIEDgUigjmDFgMOIAEComYCgTmIYoIngn8BAQWFPBiCDAmBOIwkGoF?=
 =?us-ascii?q?BP4QkPoQjKIVul1qXRXYKgjuWVCgOmx0tiluBbJ1AAgQCBAUCDgEBBYFSOYF?=
 =?us-ascii?q?YcBWDJ1AYDY4dg3OKU3SBKYsogTIBgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.70,461,1574121600"; 
   d="scan'208";a="727560948"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 19 Feb 2020 15:37:20 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 01JFbKTX019030
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 19 Feb 2020 15:37:20 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 09:37:19 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 10:37:19 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 19 Feb 2020 10:37:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pbvwx8fzpoSBtjal8WxiBs+JfuslpFMKyFkseU5fFyPc8fKxQIHuJeCJ1MYKSmgq1loTJ/H8Pc7BPPeIQR+Vad9OPK2USsjtzHKnSNFRdW+JVBtVoAvmSP4mMwNHyONTJUrau7sdyXoDpiBuYWoGDHEjNIQOWQxeejjXLAEO6ZsrfeBcFjbc7ylLrhIFn6x34UQasBcfg40MZ+YLZxliyic67YZU68GL5FAZOOklkqvVMYL77+FwzhAAnKjYBDEZQRkQazEk0e/8VloWi9p/PMJCUgQCnIiIrQZVLM2WkE3LSzuZ6eaAMnBL0Vwk2H9+9BTXdVacHnjkJunMHQKpDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RGpDVPjStG91MJF435/r3PMSvdfLUTB8M+s99UfUd0=;
 b=VBZIyPYo/IdctqoovROgTsftPYef22ngfhwExn7X6hxjwkVGvNhAc293GH/Pxi4dfrubTH47/y50KONE1Vr/WM3ONZvJaJWmMihKDFpWu+L6S4lWdLppGMd+CRx2O8P+YWuAlacosunOG/T6zWohADsaGfsBtl2ZSfI/rj1PShwYqXNhcdJ7MNVdfr7edSIsgr9fnP1LClP2d6/hXR4GnfmW124NKPmGCKkEnEF4tw1ygqGUGYAyS54PpfKEe390h6+3JbnokRhy7fvOt/vmqyFdfeIXinYfKpU/z89z6FVzIyTJGRsm61bHXmn7Mr9lcCetCoiNvFYJlUT7d5OeIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RGpDVPjStG91MJF435/r3PMSvdfLUTB8M+s99UfUd0=;
 b=NHcrxZ+k+HcYQpDZqrC6P6AmPKVjk1nf47nPIj4tyznOqcdcAn29f5umjIV1QaA9+lSM3NfgYbOWxq9Q28ywAafdY/jbmh+13ESoFbveo3I+/KvktchWaRBfXgve+/WLJ0hwCOvaRbzf72+yBupgfWON35ZmJuImVHK8xUODtRY=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB2551.namprd11.prod.outlook.com (52.135.226.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Wed, 19 Feb 2020 15:37:18 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 15:37:18 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Evgeniy Polyakov <zbr@ioremap.net>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Topic: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Index: AQHV5zp3EYKx17tAz0a8GUB3koLsqQ==
Date:   Wed, 19 Feb 2020 15:37:18 +0000
Message-ID: <20200219153717.GI24043@zorba>
References: <20200217175209.GM24152@zorba>
 <20200217.185235.495219494110132658.davem@davemloft.net>
 <20200218163030.GR24152@zorba>
 <20200218.123546.666027846950664712.davem@davemloft.net>
 <20200218205441.GA24043@zorba>
 <17008791582075176@myt2-508c8f44300a.qloud-c.yandex.net>
In-Reply-To: <17008791582075176@myt2-508c8f44300a.qloud-c.yandex.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9180b29-1883-438a-ec51-08d7b5519a70
x-ms-traffictypediagnostic: BYAPR11MB2551:
x-microsoft-antispam-prvs: <BYAPR11MB255121BEC1DFDE4D0A208998DD100@BYAPR11MB2551.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(71200400001)(66446008)(66556008)(5660300002)(33656002)(4326008)(1076003)(66476007)(26005)(66946007)(8936002)(76116006)(186003)(54906003)(316002)(64756008)(81166006)(9686003)(15650500001)(81156014)(2906002)(8676002)(86362001)(33716001)(6916009)(6512007)(478600001)(6486002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2551;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RKS7E+xlm3BEbQpSsWxgr7vTDP2oKpWB/BXEJ69nvwv3VlZv8ZNalXHKYraAHBne2sO6DOsnCu5qIFpY5lCDbZRRKRhKYp+rdljEPXWLRwkINXjHD6aAxEJTvM6Pzb6rfRbJDHyjgwwjALUetGH+PLabm1m2Yi5d2R+tWA/hDkY9kwRzHJapOJKLW4bVhQkkMHuwec57n85SC36UZ50URz+yzSQ0M39M6xAk0aHlffnFyy1AlKI89JBj7Bvd41yZOlPnY+dDUWesQaePTHWnpws28kbauWGdQwiFb039YEdfn3P870AFzvyz3DZ/taftau5ottp1gTiMWVV0uQUAlmzLGWconR74LgAKOwKkAh3WiPdBK4zlw4720rUNmTdJvob7wyzZiaoms/gJx2+yPxdH6Zl94qrv4+NS26Y3t55qmgZhUlQYUIWRmR1ZZpoL
x-ms-exchange-antispam-messagedata: +JAM1Lkui/RmwA5Z3tdNmMbU2YCMqDZdT2hNYMNWzVfU0vO2R3eDv+2MM2aZ9FifEleH4FJP6lwIrocsz7GFBwM7VboPcY2mlHQxkL4mKQk6XOBcSlUC9O3BxIfsb4bIPFvqP1J7WiX8TLLFdqvqJw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <81F008D355FFD5408F2091A0A68B3586@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d9180b29-1883-438a-ec51-08d7b5519a70
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 15:37:18.2705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N18BQ9EJ0RJE3iOzdsPO28/6LZtf7SzYK86tSPwhiBENAQFD1jzXp8MdJlveIK6K8XPwEe48RSHP3W7D3lhJrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2551
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 04:19:36AM +0300, Evgeniy Polyakov wrote:
> 18.02.2020, 23:55, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
> >> =A0> I think I would agree with you if this was unicast, and each list=
ener could tailor
> >> =A0> what messages they want to get. However, this interface isn't tha=
t, and it would
> >> =A0> be considerable work to convert to that.
> >>
> >> =A0You filter at recvmsg() on the specific socket, multicast or not, I
> >> =A0don't understand what the issue is.
> >
> > Cisco tried something like this (I don't know if it was exactly what yo=
ur referring to),
> > and it was messy and fairly complicated for a simple interface. In fact=
 it was
> > the first thing I suggested for Cisco.
> >
> > I'm not sure why Connector has to supply an exact set of messages, one =
could
> > just make a whole new kernel module hooked into netlink sending a diffe=
rent
> > subset of connector messages. The interface eats up CPU and slows the
> > system if it's sending messages your just going to ignore. I'm sure the
> > filtering would also slows down the system.
>=20
> Connector has unicast interface and multicast-like 'subscription', but se=
nding system-wide messages
> implies using broadcast interface, since you can not hold per-user/per-so=
cket information about particular
> event mask, instead you have channels in connector each one could have be=
en used for specific message type,
> but it looks overkill for simple process mask changes.
>=20
> And in fact, now I do not understand your point.
> I thought you have been concerned about receiving too many messages from =
particular connector module because
> there are, for example, too many 'fork/signal' events. And now you want t=
o limit them to 'fork' events only.
> Even if there could be other users who wanted to receive 'signal' and oth=
er events.
=20
This is what I'm looking for, except not fork.

> And you blame connector - basically a network media, call it TCP if you l=
ike - for not filtering this for you?
> And after you have been told to use connector channels - let's call them =
TCP ports -
> which requires quite a bit of work - you do not want to do this (also, th=
is will break backward compatibility for everyone
> else including (!) Cisco (!!)). I'm a little bit lost here.

Maybe I'm confusing connector with cn_proc. Of course I've modified cn_proc=
, and
that's all I'm concern with. If Connector is a larger entity for tranmissio=
n I'm
not concerned with that.

To be honest, I'm not sure where you confusion is coming from. My original =
patch
is what I want, and what i need, and what we're discussing. If David sugges=
ted
something I didn't understand, then maybe we discussing something from two
different perspectives.

> As a side and more practical way - do we want to have a global switch for=
 particular process state changes broadcasting?

I think it would depend if it's likely to have multiple processes listening=
.
Cisco would likely have one process, but there could be a case with contain=
ers
tools where there multiple listeners. I don't know how the containers tools=
 are
using this interface.

Daniel=
