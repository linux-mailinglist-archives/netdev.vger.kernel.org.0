Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02742B6F1
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhJMGU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:20:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:25200 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237763AbhJMGUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:20:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="226132224"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="226132224"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 23:18:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="659411703"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 12 Oct 2021 23:18:52 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 23:18:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 23:18:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 23:18:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maMB5bGJLr0OoS8tjipv59T4USAe1tTgvMsMDu5waI69S/hA4D/fUsXq2yHgjgLn6SjGo2bFtfMMcSUZ2/1YNS8qeVHSBXh+EMGj4gKmkVGFMPd5vMX6n1X4Or2CzKkVrIEw2JMRWe6DukjRp4VPr8Ww/GduEzhOJTCB1tdT9Sq2PXewe4Ocu+crOnAKtcqy3I1KV04kIgX3HzOeEGczpry19WrcNr7pLoPwgH/NIPDsBjJ4TcnzMwnDag8yzWNRz9O0DppKyPjnxEzRonBYt7qgSDTBXfKvBVoTbM7GW/l9U+JJAsj+P3Ynok94lqFLAxPzoFR1qRGbznERhycsUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUk8MicaphQ29Rp1gMuWh33asTsripmVmxgYaPp7BKY=;
 b=iZdbyQyc2gYhfp+gpaXv7LajB71PhJPymnMK1787m+6ao5Qr74rhFfXSC9P/rJ02Sgg5YpvtWbfKcjABcUp96umhO3loajpTgwvCH5vkSGBuuGolkdsxyjWA4w6BCGrIMuqfYgYVpIZaRuP8iFtrFNgDkuHqn7Zn3mZymgTtQsW94KRv3b8AyLBWfOuu59iAqanRtdA0t/Rlmhqn+7JkA0ECPElF1N4aU/E+J1Yiei4+6JFXW1XX09xj2bpLbCUfhq/WJBXZ9BjJU/MJGKmXKVCt0m2tb2OdXc5UuiO8pnYad6lKMNV7RxGd0nnFqsLQQ5fyDXMKYpi9DMNVNqB93w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUk8MicaphQ29Rp1gMuWh33asTsripmVmxgYaPp7BKY=;
 b=G4UakKOFs8vZGpXZrMmn2SCwPxFyNAgR0VcsbTiaExo3b2p1Idq2Dt1ap3LeO53P2Dt23UXWlR1OZrdmOYSZZGCdJyCIDLS5DJwLzKNVZdtbMFo+IuRsM587Nm8/WbnPgrXyzdJe+mBTv6xJAJd743d7neUQGhQif4JfYc6MqXU=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM5PR11MB1257.namprd11.prod.outlook.com (2603:10b6:3:12::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Wed, 13 Oct 2021 06:18:50 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::1cae:b328:7501:200e]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::1cae:b328:7501:200e%7]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 06:18:50 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: phy: dp83867: add generic PHY loopback
Thread-Topic: [PATCH net-next 2/2] net: phy: dp83867: add generic PHY loopback
Thread-Index: AQHXv+NlN0wzbptZ5k28hA7rUo0CYKvQSpsAgAAp4xA=
Date:   Wed, 13 Oct 2021 06:18:49 +0000
Message-ID: <DM6PR11MB27802C56B1012ED7A575E530CAB79@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211013034128.2094426-1-boon.leong.ong@intel.com>
 <20211013034128.2094426-3-boon.leong.ong@intel.com>
 <20211013034832.GA3256@linux.intel.com>
In-Reply-To: <20211013034832.GA3256@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c655502c-c3f2-495d-4732-08d98e11528b
x-ms-traffictypediagnostic: DM5PR11MB1257:
x-microsoft-antispam-prvs: <DM5PR11MB1257671C8D31257F92D8B973CAB79@DM5PR11MB1257.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RgBYP/UBN6G7n7npxiw3fR8oYpAQ90PFhSNVNHaOc8Q+TFDdlnWDJssX/nonjx3ZxbBmiBf9T/KwvQf4LnN/lwCOtVYerPIMZ3N/kY5BEwiK4UrQIViuMkWA+sTfS+N/AysUfcZ2k2nmuok1Iwnjlnfn+/753F8Yw7VtulIGumSWHzNcVtyKn2ZjhgY4Trz2/XzXnYU+rWMpzh220TPkSV7WLlunhS5nZjiw+clHBEYvjjO6egAnYUAoT16MnlzX6bpSHQL//enAb7CeNKVpaT66Pu6efBIiWlx1JSXZKzFhj1u+dAOm1ayuYRVXIQZ/k9naybGLJ5tuYb3eMjWijpxnCyI0y9IL8q+VpaICqt0DMnQBuNl3W38PV7d6u5jE3haNoWz/3kLavJtDYhqiqddBk2k54XZSaENruy+rR0RBUmSfgLyuP6UFrYoTNn+DFM1/kaWaNs5X//dyDwoMPyeVRSlkTET7oVP7XiVg48pMUcbRwdeg24hSWvUCPC5VXunRreUTaCf7+CPy7MeSlJkcZEAJVXaNg2Nf8LjZB48LrzBc/cfF84lpgB8vmwxsiGqImnjwV0nNx+o/u1C1FAJzx/BsDyyn8ZiLx3zNyibl9YSN02JlxefQ+xbCN4au3DgT34cL+1xQpWOvUJTyg1wB2qpzzAABWwcsTqgcLOo7WhpF2olIx7CfkW9OrunyNQSQyKF5d6vfuNuDPecS8F0jrAOjWaKkbspZOGflszI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6506007)(316002)(7696005)(186003)(38100700002)(8936002)(54906003)(26005)(52536014)(33656002)(6916009)(82960400001)(86362001)(5660300002)(4744005)(55016002)(66446008)(9686003)(71200400001)(4326008)(64756008)(66476007)(66556008)(2906002)(66946007)(122000001)(83380400001)(76116006)(8676002)(38070700005)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r4ywrCxRCEThx3zZ3ZJRr4bPsyoi+9xXOU30vf7CCVWAMgYYtNySUR5DDdVL?=
 =?us-ascii?Q?6M7Hgpt7CAAqSjMFtm9sdh2uz1dsla1YCxDP7lYQ59fBkc6aq0Z85nCKK/p0?=
 =?us-ascii?Q?9FaI+f2lIYKPh2QyRE2a1/8m9Ro0cTxwJ62aKi6dRClRE/1Q11Eiwx7+SuAb?=
 =?us-ascii?Q?GfITiGh5wgkuiR01ED6HJE1uxenhXzpUr8/uyRrG2ExxQP5Yb9Ka/4cCVJ3C?=
 =?us-ascii?Q?9XIMjsijLi43muYCQrWeupa910FX/Udg9tlKmF6IL7RuS27S3+Eub29IsR75?=
 =?us-ascii?Q?NMKQ1vYjh2srIZ+NaDm9HoeneSkBMjGHSHquQuPmAM13wBCpbNoMBH0wywF1?=
 =?us-ascii?Q?Amb10cYLPy1AXogIFLJwuyVxs/IazTof1D2NYQ5b+SKKmudB5TowKZjkF2nw?=
 =?us-ascii?Q?ycAnxjVXSRVcka9z4K5g8JyAxUXdwWQqvHSJMDM1gBGjsw5ZhtUznfUrekmM?=
 =?us-ascii?Q?ErgjSgXrjkTHSOT2ab8HAauTgFqPjLTBtOh1GQeuUmsmgSavGYCUi+hIi+cd?=
 =?us-ascii?Q?YNGYKzBoo6X0hEZL5Sq+es19i6sfVjvjzCc5bIowCVZNrTBxN6MnP+oz6KaX?=
 =?us-ascii?Q?qDf4eR5b36fj2+PBo7S0GMlR4xZ2m3jMPUobrfofZiRwlKQihah3TO7409L6?=
 =?us-ascii?Q?mTN5/rmX75OpxEI6l4dnPkAK9NXSmH3ME7fs0S5k2i1ZiVPUChKqkPwYF4cU?=
 =?us-ascii?Q?rTz0l2cFSJqBwY3MzofL6kEPJmGiVx12yyQqDjjSOeRYs3BSj8p8TpUefoAJ?=
 =?us-ascii?Q?sDlnmuPHMtnerdc6JVq2Xd8TNzoiNShUAavIi9ItiFxmMMg0cTjIge/6PoCh?=
 =?us-ascii?Q?3r87c5cRhof7u0dqETHljIFwq4Tso5pTMzFHPHm92+cUKE8YTg29Px4kENGF?=
 =?us-ascii?Q?jAZ62NYC6c6h/jIgLzY4DpZ4FGs1wMzQL72mTCKKCjCpu6L236ti4MdyDj2+?=
 =?us-ascii?Q?AvGEaYK/dnCe7mjM/l+BCGwX2VHRYIVPnb5Av6R5VqWNHkdNX2jIvM5WRGTl?=
 =?us-ascii?Q?t7pbRxQlRXvunCTg/UraMmh/3ZyOI/1LM33ZUelXFsoMUOcFZLVVIqxiN/pO?=
 =?us-ascii?Q?Pb5yrz22rCaGWfvwf8OfoTfobX0xNdBOqL3hcDgS4sOSSPbilu4sV1Cy0NHA?=
 =?us-ascii?Q?LN4zXsFRTvZgYontffm1URtbAjSHUUCg43B9+Pz3oKC2yqdaAgiuS9GXDxGa?=
 =?us-ascii?Q?CXjx2TIRh+ADzEyQkQLVP+QgdZ8A0o1q7u2quq6EHpLZKS09qR9d54f8SWJJ?=
 =?us-ascii?Q?/GcN7k7vMAMDZVczX+8lQkfNNA86Ft8GWpY3uqjd3vTGKKDbXnqwzJCsWpQh?=
 =?us-ascii?Q?tPc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c655502c-c3f2-495d-4732-08d98e11528b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 06:18:49.8784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WiAeJUYBI4uRxpTuavxFE5DW4jqgPaWEYQzoD5toqPln0hlb7BnRh7mKtdRWfv67Dtp5nzAQevp2BIr1tTAm+3JN/5drFV4P2ViyYsCPbC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1257
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>> index bb4369b75179..af47c62d6e04 100644
>> --- a/drivers/net/phy/dp83867.c
>> +++ b/drivers/net/phy/dp83867.c
>> @@ -878,6 +878,7 @@ static struct phy_driver dp83867_driver[] =3D {
>>
>>  		.suspend	=3D genphy_suspend,
>>  		.resume		=3D genphy_resume,
>> +		.set_loopback	=3D genphy_loopback,
>
>Isn't this already handled in phy_loopback() in
>drivers/net/phy/phy_device.c?
>
That is right. Thanks. =20
