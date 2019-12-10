Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A198F1198D9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfLJVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:40:27 -0500
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:5284 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfLJVkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:40:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=921; q=dns/txt; s=iport;
  t=1576014024; x=1577223624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H+TTPZzpUytyIwuIApIJ58EDKge9wIGhb+sB//MNUIA=;
  b=hBWwZNcO/QuXAgp2oeF1MQ2KYOANSUA7QqZ0zvsJ5/YWesH/ajaKM3ed
   GKVEbVlljuZqTF5xWfuClWUYHwsXF72nER+ThCirE5LUNNoj/5QU0j5FL
   PvvtG32UoNWXnak7l4I5wHJvHy38JFhSy3NV3GhNiKKO29TKxziOAGCsg
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3A/mErGhBRjE5G70w7y4OwUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuIPfsbiE+A81qX15+9Hb9Ok9QS47z?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BNAADWD/Bd/4oNJK1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWoHAQELAYFKUAWBRCAECyoKhz8DhFqGLoJfjwsRiGqBLoEkA1Q?=
 =?us-ascii?q?JAQEBDAEBLQIBAYRAAoIDJDQJDgIDDQEBBAEBAQIBBQRthTcMhV8BAQEDEig?=
 =?us-ascii?q?GAQE3AQ8CAQgYCRUQDyMlAgQOBSKFRwMuAaM8AoE4iGGCJ4J+AQEFhRgYghc?=
 =?us-ascii?q?JFIEiAYwXGoFBP4QkPoRJhW6uaAqCL5VkJw2aK6h7AgQCBAUCDgEBBYFSOYF?=
 =?us-ascii?q?YcBWDJ1ARFIxmCRqDUIpTdIEojH4BgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,301,1571702400"; 
   d="scan'208";a="593356262"
Received: from alln-core-5.cisco.com ([173.36.13.138])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 10 Dec 2019 21:40:23 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by alln-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id xBALeMYf023971
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 10 Dec 2019 21:40:22 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 15:40:22 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 15:40:21 -0600
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 10 Dec 2019 15:40:20 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b69DJ0JnBTDlHpIGtqDFBaTbrfRNV8xBcvbzKwXGJF2l7ZaNK0pl4JrqzP1cawRmnLrVRDL6Mw3Otoj4MWUFTMiWpkzqPRRbSa0fkTv8jsV5wBnCc+jcN2KZgO3xs9QXME8Bq3FJt/RVMzC0vgwP0/lH2vlAC/TjenW4MFNIRcAygr0ZxL0hpDePEq9V9ejyQeigoq5a8AfWfcyqgYDLN3hySJQwFGnkDqb9oPrG4iF9JL292jeOcGoVfvF/I2nVo54E2OTgJzc8/GwymxqkeCKAY0FIiT4VzUHifk8lmdOIZXooiq+dJbsEzOcT+KOp23EsIvoVp8iCQG/RMinGpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+TTPZzpUytyIwuIApIJ58EDKge9wIGhb+sB//MNUIA=;
 b=Sh9IHjaswFQCPwvKT1tcK+fTXrjba1EScGTrj+SA3BBx1UM1prT+2Fpt3XMaT/XMighnoffsCZCNHo5BAwmvx6iFpqwtQ9gtv94g1/5NqVmLIS+GIZMvwym5wrXYTTUJJfMRJ17b5LBbBjwwHm1LrmpZSc6/FI5UtvByPiz1DMUqIC7pK3r3kd7Py4mqsdpVvXIscGpEYrfyOosdjFlyO7edGeuR1e0YMvufw5IyvcpE1xJHVmvmP4+37xH4ggYvuRz3t0iaA9IkQm7PcxxYNl5uC+jJVb3npleMGCyIFgmW6zx1y1PjCYD/6+perbdwAJK9LlhaldfIL3NRUAPtxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+TTPZzpUytyIwuIApIJ58EDKge9wIGhb+sB//MNUIA=;
 b=s6eMobtxHgJRc6JnTST93xC7U+RqqH7HtkWO53zFX8cgN0/PjWisGMqq5/cfm/2cwjp6j1kJOKpFS4gjngDLkrmI2Y5XLOpWIM/77I09xtJwG+rYq4AMwCzBzFyCMB/RvkBp7STLClpNDeG8cQSzg/ADn5DbEzWf0agNfc/VPkY=
Received: from CY4PR11MB1655.namprd11.prod.outlook.com (10.172.71.143) by
 CY4PR11MB1959.namprd11.prod.outlook.com (10.175.63.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 21:40:18 +0000
Received: from CY4PR11MB1655.namprd11.prod.outlook.com
 ([fe80::acef:ea97:7ca9:847b]) by CY4PR11MB1655.namprd11.prod.outlook.com
 ([fe80::acef:ea97:7ca9:847b%3]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 21:40:17 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "Aviraj Cj (acj)" <acj@cisco.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>
Subject: Re: [PATCH 1/2] net: stmmac: use correct DMA buffer size in the RX
 descriptor
Thread-Topic: [PATCH 1/2] net: stmmac: use correct DMA buffer size in the RX
 descriptor
Thread-Index: AQHVr6JpL751AzfYA0yQOqajkon/ag==
Date:   Tue, 10 Dec 2019 21:40:17 +0000
Message-ID: <20191210214014.GV20426@zorba>
References: <20191210170659.61829-1-acj@cisco.com>
 <20191210205542.GB4080658@kroah.com>
In-Reply-To: <20191210205542.GB4080658@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.170]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a656b30-b387-49de-19d5-08d77db98c89
x-ms-traffictypediagnostic: CY4PR11MB1959:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB1959488D528AC3C00E4AC30DDD5B0@CY4PR11MB1959.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:519;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(189003)(86362001)(33656002)(316002)(5660300002)(81166006)(8676002)(6512007)(81156014)(478600001)(4326008)(91956017)(66946007)(64756008)(66476007)(66556008)(2906002)(8936002)(71200400001)(6486002)(26005)(54906003)(186003)(6506007)(4744005)(107886003)(1076003)(66446008)(9686003)(76116006)(6916009)(33716001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR11MB1959;H:CY4PR11MB1655.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yH8WP9JMYCFjHb2WPT5vGrkje7DhcQ2s/DnkW3tbI76c3soicf2VPctd7Sc3S8082dKL9Tvv7gtPKFp3iK+mlH495LowyzPBXsPkeZBRw2T+ctoo6R4+eAKGxbZFip0iTr1oge4hSzyd4DmSmRyc7ClrjRqfRcd04U2scU/pdjeAW2M0ZLv6r31AnyNCCPV1mUacpcU2EX5NYB7sRFGR2T6lk+S1y69cS2xf/A32Uyq+CE248BCCz3cy22vSs4Cx4OVpjtzngxwd5UUmIKE4Vg8nzr380xI34MRCqRkbPMwstlJelO5gpcjuR0O/nZnI903GBb1SFnBVAJ7H/VBhxWXNrccRkXwmSNypd0RvFwCH/DW6Hkj49goqwvkqJbec7aW6KgeyMiW8REk54XlzEaDrjPEYqU8KF/D6FY3SRplIHyjnB87nHX4nvbA1LgK6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ABAF94358DB0F44B98A498EA4C0EE0F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a656b30-b387-49de-19d5-08d77db98c89
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 21:40:17.5262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 23ZyjgUEapqk7tNz/fJMY/SbcqNdzQeXYvnmxHSE0LSZdGsg87ymTqPY+g/xEMjd6bsJfbGDR9YCGZQO8tEB9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1959
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: alln-core-5.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:55:42PM +0100, Greg KH wrote:
> On Tue, Dec 10, 2019 at 09:06:58AM -0800, Aviraj CJ wrote:
> > We always program the maximum DMA buffer size into the receive descript=
or,
> > although the allocated size may be less. E.g. with the default MTU size
> > we allocate only 1536 bytes. If somebody sends us a bigger frame, then
> > memory may get corrupted.
> >=20
> > Program DMA using exact buffer sizes.
> >=20
> > [Adopted based on upstream commit c13a936f46e3321ad2426443296571fab2fed=
a44
> > ("net: stmmac: use correct DMA buffer size in the RX descriptor")
> > by Aaro Koskinen <aaro.koskinen@nokia.com> ]
>=20
> Adopted to what?
>=20
> What is this patch for, it looks just like the commit you reference
> here.
>=20
> totally confused,


We're using the patches on the v4.4 -stable branch. It doesn't have these p=
atches and
the backport had rejects.

Daniel=
