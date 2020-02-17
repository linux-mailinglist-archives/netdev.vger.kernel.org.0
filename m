Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD811618DB
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgBQRdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:33:08 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:11482 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbgBQRdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:33:08 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 12:33:06 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=603; q=dns/txt; s=iport;
  t=1581960786; x=1583170386;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OBRp6v7Rwqz/mvtbAplSCPjjaIqs4Aw5FEfVrUlizxg=;
  b=ITOLK35chYIBzkK9sgtKY9jdbp6sCe6vnFh+JyKbdTd5BsFXvvMHCpAx
   LKEkttN7t2VMbM6+YwlUM1B7yf18NwE3Y24SMb3SzaxtmZ0eDf0/YRogM
   OQ4A+4ttJKQJrPWCTL8YxCmD61MSDR7mtVYuxh8P08+5zeZWpIxp0S54C
   M=;
IronPort-PHdr: =?us-ascii?q?9a23=3AuEYfGhQy2NgtCO7VvIz/stHiudpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESXBNfA8/wRje3QvuigQmEG7Zub+FE6OJ1XH1?=
 =?us-ascii?q?5g640NmhA4RsuMCEn1NvnvOiAzGsVPUEBs13q6KkNSXs35Yg6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ABCADHy0pe/5BdJa1mHgELHIFwC4F?=
 =?us-ascii?q?UUAWBRCAECyoKh1ADinqCX48WEohpgS6BJANUCQEBAQwBAS0CBAEBhEACggQ?=
 =?us-ascii?q?kNgcOAgMNAQEFAQEBAgEFBG2FNwyFZwEBAQMSKAYBATcBDwIBCA4KCRUQDyM?=
 =?us-ascii?q?lAgQOJ4VPAy4BAqFgAoE5iGKCJ4J/AQEFhS8YggwJgTiMJBqBQT+EJD6EIyi?=
 =?us-ascii?q?FbrACCoI6lkcoDoIrEIgWkDstilifFQIEAgQFAg4BAQWBWQQugVhwFYMnUBg?=
 =?us-ascii?q?Njh2Dc4pTdIEpinSBMgGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.70,453,1574121600"; 
   d="scan'208";a="710630933"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 Feb 2020 17:25:59 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 01HHPx7w027524
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 17 Feb 2020 17:25:59 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Feb
 2020 11:25:58 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Feb
 2020 11:25:58 -0600
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 17 Feb 2020 12:25:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+gPunQQQGennu2Ge5X8AYgQC2lyWNu+ShxEvO+yBcHZRvybfUWmYhD4pRCUTxdvzWQ+M6HVh2Q+moBDnm8kX7BwOsGuZ4W7vqE3D4VDSIW9JzlfdVIiMFIxPzFi+lXrnykLWhhVUCVnFmD8fGPHlTO9fPJK8brbo5d+SHbDErpCeGnSOZ2eK6LI5pTupgfqozdBSE0daQTxRXUOBOBHL+npP1Jy+0TPV4YyGFE4Bb+5Lhkx5G7NLB2uAosNEju8B5vI8FB5E9itFsrHbrznh+aTO6btz0/9sdviRM8av1Z6/N+mNHhs4FdcbyJk4MD4TaparGTIty7DKmQeFWiIXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBRp6v7Rwqz/mvtbAplSCPjjaIqs4Aw5FEfVrUlizxg=;
 b=cScO/9UEPWc2oj0XTkScjfvZc14GV+cAzCzT8HmiGCEEggK0KVxKJymCWD/MiWPqDUg1W/osEtmnpQaqyVjbg+S1cGfq2UEtZWQ/8dQbn3ZVR3T3L4eHg0VQM0UVsE+Q1JbWSyE/jQTUMBH2X1EH82IYrsIF17H8BbQjN9E53RMazhDaKCZp22ACVuOw2MEJ738y+x1GwuTiV3HeWSmJzOyYnE47hJrHzJZO4iAxpsuT9e4cGyKThKL9dTFq76tliczltJyP4GD/LiHy1q7Wf1h0oUHlzHyZT90JVHdakN2DdbVP/1Oz/eVX/QxkMHL6FlDh1D+lH9IzaaD5TSINsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBRp6v7Rwqz/mvtbAplSCPjjaIqs4Aw5FEfVrUlizxg=;
 b=AJNYMgXTyLyptDoDYCc5caVt3193E2C7YtehGJeR3lk9jWSh59XrrEtUhs/kXlcms4LcTBxfHwZtmO6au2RC3VYhrbxdbkjZ92lir0Vyh51pzipXB/HYiGmv5Xolg0ttGulcMeeXAHCsMQg8qVA5h5b+tHEDM/Cj74roLKgnK8k=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB3590.namprd11.prod.outlook.com (20.178.206.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Mon, 17 Feb 2020 17:25:57 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 17:25:57 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "zbr@ioremap.net" <zbr@ioremap.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Topic: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Index: AQHV5bdQT6LwfCsUu0CE16IMgyv7nQ==
Date:   Mon, 17 Feb 2020 17:25:57 +0000
Message-ID: <20200217172551.GL24152@zorba>
References: <20200212192901.6402-1-danielwa@cisco.com>
 <20200216.184443.782357344949548902.davem@davemloft.net>
In-Reply-To: <20200216.184443.782357344949548902.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b12c51c-bbea-4f99-0631-08d7b3ce7336
x-ms-traffictypediagnostic: BYAPR11MB3590:
x-microsoft-antispam-prvs: <BYAPR11MB35900BF874B424EA4B7E1129DD160@BYAPR11MB3590.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(376002)(366004)(346002)(136003)(396003)(39860400002)(199004)(189003)(26005)(5660300002)(86362001)(6506007)(81156014)(81166006)(8676002)(8936002)(316002)(33656002)(33716001)(478600001)(4744005)(15650500001)(2906002)(54906003)(6486002)(71200400001)(66446008)(66556008)(66476007)(6916009)(186003)(64756008)(1076003)(76116006)(6512007)(9686003)(66946007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3590;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KHG1w/XZrC3AF/dWihm67sU+462hAegVcSYB0jMK1bigedOpvHjQjTl04d6H0GaYTCxIrFQS++r2jyyAGlW8sB5t+6DH9rw5m0hpK6s1EasJq7Ss2Rug6hyI9rKGlR0nyC/OxjoLkHEsy2q8iqn9ud890/hukcEummVuF52nRSAXdGuIzRE/0PkSR4US9FcoJIknO3THm8P7BmViBcxOTR5Pvrhv4aSOoqUcE29Xw+z4Im6BaJrA2QZ+QCZIwpYYCUFJwEGj2ItZ0t/CtIXxT8Ap5Epi40Y0njXP+0x9blW77+CQjb778lXR4v/H80XIMomIV7mJH2K/y1YxWeu08HgdZ9leias2YzJmWCdDvTDnR+sKJ8btJD9OcRhDYrRb7yWGWGD32GniGUMCA1/qRXGF+m1vHo24kcBObJswofdXD+sv12PTEe4EZQ0H6ebw
x-ms-exchange-antispam-messagedata: zT3kYG5cmut/SgQie9nvEiinIkVpK0bMS571LigfBV+WszGJNjtSmGKSGjyrGOwbItVc0KoQJnptyOP5aK81r8jLcbodwYf3s/phwZsJ/t7HVqf415Kx3s7OyukiuIMs5VRZF8aQ0uROoHoSNQ6how==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D981EAD9FAC9348AC0A8E316B90615D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b12c51c-bbea-4f99-0631-08d7b3ce7336
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2020 17:25:57.2550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWO8ojTj6ie5Vc8Hqy1cjoIl/8g7iqgmU3dbhT2A9EwFlwNv33wg4JkkqarS9YONQi052OmPzSUwFcXJynIynQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3590
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 06:44:43PM -0800, David Miller wrote:
>=20
> This is a netlink based facility, therefore please you should add filteri=
ng
> capabilities to the netlink configuration and communications path.
>=20
> Module parameters are quite verboten.

How about adding in Kconfig options to limit the types of messages? The iss=
ue
with this interface is that it's very easy for someone to enable the interf=
ace
as a listener, then never turn the interface off. Then it becomes a broadca=
st
interface. It's desirable to limit the more noisy messages in some cases.

Daniel=
