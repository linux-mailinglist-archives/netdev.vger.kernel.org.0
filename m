Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E1B282E9B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 03:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJEBU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 21:20:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:17886 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgJEBU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 21:20:59 -0400
IronPort-SDR: LSr29OYfDq1+L6o7eelotgcO/TZabaioLy6Gf6o9rvMIYpwP6RZR96+vJ5+vXFMNcgYndOD6+h
 3GH15J07BOAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="181436391"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="181436391"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 18:20:57 -0700
IronPort-SDR: j4iZwiqbvExWJITcZgv32UwvN8ORWUr7UJ0Y/xSMMxJMRfQA6+0pry+o3ukjZUDKo5rI9A/RZ4
 dMeqSWp4iJKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="515833964"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 04 Oct 2020 18:20:57 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 4 Oct 2020 18:20:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 4 Oct 2020 18:20:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 4 Oct 2020 18:20:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHi96FL44yorqvcajTXIlXz/QFWo0W70HgXXz0uirMBJGvpspka3AwgCUoFEnHCBrM5anWV8cxJ/qgk87ALjHJHo/2oRH56N33StGY97P9osvHJTjM8Y/JOw2iwu0TwB3YWlyQkTsPwkaZSqtXOV/tSJiP7IKuqIqNfpzeP2YH9T8wsicT7OgEkWZmUfAQZzKyDNQXAyx5t00axp9gkT5VQ125pI/sYPd9YouHU8gd6YpLhe0GIiyP3tr/+xg7dpxbelUJPoVC3+P/ft3gd7zEXFhr8JnAzo9IlgnFrqiBXJlO/nMmDgPPo626LQ5lTDmLu5LiAGsUtN9a0YsE8aYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbDbgMc5/wyIZLM//Cdk5J9hgBxDOexLuQn5L00bOFY=;
 b=fqrPbkHyEQP/Bq5GI1dv64/7nT/BqwEuudigSsHCix7S8sVGac3VYRbZdXgWupuNlzfoiX+5GdbItc4ZScSoiRDkr8qGnRJsuAQ2S9gQq+lCvtwBfUQKoPL44K44/+cSy+e0V0eAHYUoMAWLChqnz1cut1isumjh0DXFLULb6ff3Yuz1GRzCbqy3JCMBu4lykLjMeQ7OJH8kljOapPlgpi32s1jg+gqp/K9dbPTZ6ZtS4IakHtBsWAeahcfOGS2avhUopqHjY9KUl/8SdCIDyFRox4sONCLQEC07hDYQE1I+7z5fLUTuDeVRpJU8rKHF5spHFvynoffQKZy63RDJKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbDbgMc5/wyIZLM//Cdk5J9hgBxDOexLuQn5L00bOFY=;
 b=iBl/0ZRDrK45X6rGlB5+hNpcMAKqUtdXplTCTQC6cAj+pH4ukMuav3XDycyNO1v6Yqkck/AeK/f9RSntNUBK2uTzyYDWb+fil/qv9jIcE/7wsr002oSSXX+WNxFwxUt3+0YXRKup+0dTbEWv6wEg4m/I6EuHAm1E+kca4lh/j/Y=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Mon, 5 Oct 2020 01:20:56 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 01:20:56 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH 0/6] Ancillary bus implementation and SOF multi-client
 support
Thread-Topic: [PATCH 0/6] Ancillary bus implementation and SOF multi-client
 support
Thread-Index: AQHWl7C/GP+6Fa69bEybT9V7+O61hamFmSAAgAABmgCAAqDu8A==
Date:   Mon, 5 Oct 2020 01:20:55 +0000
Message-ID: <DM6PR11MB28413A331010FFCB9A02A4E1DD0C0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201001050534.890666-1-david.m.ertman@intel.com>
 <20201003090452.GF3094@unreal> <20201003091036.GA118157@kroah.com>
In-Reply-To: <20201003091036.GA118157@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24b484b8-9121-401f-2bf9-08d868cce8d4
x-ms-traffictypediagnostic: DM6PR11MB2841:
x-microsoft-antispam-prvs: <DM6PR11MB28417C2D3D90E9792BF90E1ADD0C0@DM6PR11MB2841.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LiXRhUUy2TUoiQYctxi1qnUXRwqkVklUId8EzM/D3sGnAvSKmQQF0cHH/YdxxB4pC+HZMF6VuLcUC3i1LAeyL5wkg4aciSYvEMB6uwn0MsYfrOSDKQShmbQ09Wbsr8gFfPXt7y2SGC+rpmKbrlAmfK4Vm8XYxT14qpdNRKSEDs0fVIfSKA5VDabphTkowvQLd3SflhCB1z3J8eBE32c2ghUyTx7mDpzPpmgYDN6Z150KUA02BTdWEfJFh5iNCBxn1nTuTX52Dt+PNl0Nz1A2WqBkQeYlMPxaI6usyYQbIUiB9iMndluPMjb8fRMfX2Kx9B++HHegA7XhyhIf46a1mvlS1MoQdJnSDQWVH7EBsXLVPcx4PToOlAbRW5K4PuttI/OmR78TZA484ZI/9WrRyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(4326008)(83080400001)(66476007)(76116006)(66946007)(478600001)(2906002)(64756008)(8676002)(110136005)(54906003)(66556008)(66446008)(83380400001)(7696005)(186003)(53546011)(6506007)(316002)(26005)(966005)(8936002)(86362001)(33656002)(52536014)(71200400001)(55016002)(9686003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6k4jCLKZp96kTFUkm2xV1srqJebEVMunuwSop3QHevsnoqJ0f9+wheFI6j/nPTWqIW7yIms1rTXZFg8x+w+M1cXzCxQI4y+5Kn6GnvNusrcQVmgpdaGlgRJxrU0kh2Aefj1vBpTjnS3YKe7qp1xaozG6Nja7YpkvlxR7kPLaWyTu93/WabxlvCqK2fyfNbdtmCcA1XGIcuGOAXy8HVuEAF/AsS10ElqGLDxlxhDW3UKaLBzfB7HA69vRsxNVFwSBba6SYnR2AiPhIquuX5L9auNKCcYUrD49DgbEyiS99NGOJYwdBXzLDAu7dVdGdGobwu09DzkrVRpzkjSSW9X0cE994rs+rGHDbINCpdZvllu9vEUDAFwg8ebG3vktRJuY6QZw/FEIUk4/SIi0+A8ruc+zcI23NLLgJ43OpS7njNu+iIcgVXxYbbyIRTbuZwkqTDR9Gn6nvcJROUpj2MaoTx8MsrASWcDIWh7tjBGmJETTQ0AAymWzSIWJUl3/xlC18r2N8l76ORDOB1SfoN2GNLZBmYMBclk9QhVcb/ghp/UB1b+thWp7wDksAleY8q1cTH4vS1iQ3c5m52U13D2mZGklxyQTufuy2NlslUm7yqbaGa2oH5q0kvEgUWekHh5H+XSL9kgg96RpLrmr+67Ntg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b484b8-9121-401f-2bf9-08d868cce8d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2020 01:20:56.0002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BgJe9lsdm3OP8R250faL12wcYt/RA0Jiel042JVeZbl22bizm0KAfDDPQ9BUFw5T796PVwaCQQRy0Y64skhXyFsEjD/EQKbu4xrzAZ8mP8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2841
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Saturday, October 3, 2020 2:11 AM
> To: Leon Romanovsky <leon@kernel.org>
> Cc: Ertman, David M <david.m.ertman@intel.com>; linux-
> rdma@vger.kernel.org; linux-netdev <netdev@vger.kernel.org>; alsa-
> devel@alsa-project.org
> Subject: Re: [PATCH 0/6] Ancillary bus implementation and SOF multi-clien=
t
> support
>=20
> On Sat, Oct 03, 2020 at 12:04:52PM +0300, Leon Romanovsky wrote:
> > Hi Dave,
> >
> > I don't know why did you send this series separately to every mailing
> > list, but it is not correct thing to do.
> >
> > RDMA ML and discussion:
> > https://lore.kernel.org/linux-rdma/20201001050534.890666-1-
> david.m.ertman@intel.com/T/#t
> > Netdev ML (completely separated):
> > https://lore.kernel.org/netdev/20201001050851.890722-1-
> david.m.ertman@intel.com/
> > Alsa ML (separated too):
> > https://lore.kernel.org/alsa-devel/20200930225051.889607-1-
> david.m.ertman@intel.com/
>=20
> Seems like the goal was to spread it around to different places so that
> no one could strongly object or review it :(
>=20
> greg k-h

This was my first time sending a patchset to more than one mailing list
and I screwed it up.

I will be sending a v2 soon (Monday maybe?) and I will be sending it to=20
all CC's and mailing list in one send so that everyone will see everyone's
response.

Sorry for the mistake.

-DaveE.
