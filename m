Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82BC1DC778
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEUHSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:18:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:21638 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgEUHSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:18:40 -0400
IronPort-SDR: 4nsNLTQZfNs95rObxDwYMxPx2B2r+/NFBvk+eg1cVjNsbIPOVfnQ5xg3JSQkF4siPBk5XmW/P6
 iiXa+pb22efQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:18:39 -0700
IronPort-SDR: wD1J0RiBcaH5inP/q1/VmR+8icliGLku7DlqZNiEJLH2hXlfu4hIREGmE+Y7iB8/AI4DQcgwFU
 fapasPQ19F5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="466805733"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga006.fm.intel.com with ESMTP; 21 May 2020 00:18:39 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 21 May 2020 00:18:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 May 2020 00:18:38 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 May 2020 00:18:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 21 May 2020 00:18:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfjwDS5HwpzJXHikvuMKOFBdAsS0nTu7/aRc4M3xY8qGa8mZ7hhEXfzDXVov1Df7FnofGjqDaCM3iR0Zaex2xZHapzN/JhSI/ze3mYmBz9mKwfIfetMw59Efk3VSdp9TU95SunEVuKFJBzRwHfzstXtQS3vMhM2UjONo54saJOrwsbLJgjhX5O93h1rm12BUIa4U1HfWWg++F7aD6vho8l1jtLYn+35biE0JV8QPk3AtT9j6tqj/S5hSiSotXDSrXNKWePFSh72wUYK6EERTrbtQIUO1d/PiIq5nffe18lMWJej026zTbUGYAtELd2ef9O0h697Xmw4yoDj/qnNTdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRRjvVUPTJ095tVm5JoehRYe1+3H/O8DMISh13sElAc=;
 b=i2zrQiMEmPYos8db7ZZ5iT1Iv8rC+BDhB3XbutXjH1UrjIwAFbLW2E6dCZ1G/xQvm21wllfQI5oBD9kfWssLLwqAN4cjKK2BQT4E+9ErXNasEvmcalFGUtr0ktHSD0c6/XcMIRpQzLyXcxU7g56Ps3hHXzFhb+PH1ORLBB7mvEbD4/1+HA5ss1O5wT7c1cmnK4/feNrTXEz3vZGncMcqa+nuSU7VRG+lej9oHa8n7I1gIx6gt/FVsjBgBzZfFCrNugqXl2CWpASpzZHSe/qLDCAxHippgF24O8RXIpVVwmasW5sbxZznqcsMwGsQnpmIUmawEu2EqKcQidR/0tl4sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRRjvVUPTJ095tVm5JoehRYe1+3H/O8DMISh13sElAc=;
 b=QB+ObGK8xWyFoAkUW7s2r6HgF24y6xCSNItuyPIjl6f/A+7SYaIwK3k1Cw/0NZNljp+GReuJ+Zp74PQFTVwcjAcmeOV8y1pTkYI7KW84qauEMj9BZlV622YnC4GeHqwdBCYKo8TOJn5NesFkynG49dYhPpIvnwbwnwrglohkIO4=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4124.namprd11.prod.outlook.com (2603:10b6:5:4::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.25; Thu, 21 May 2020 07:18:28 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::40b:5b49:b17d:d875%7]) with mapi id 15.20.3000.022; Thu, 21 May 2020
 07:18:28 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        "Avargil, Raanan" <raanan.avargil@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] e1000e: Disable TSO for buffer overrun workaround
Thread-Topic: [PATCH] e1000e: Disable TSO for buffer overrun workaround
Thread-Index: AQHWJHrrUX35Ry/Ivk2wFI4JysDy3KiyNsXw
Date:   Thu, 21 May 2020 07:18:28 +0000
Message-ID: <DM6PR11MB2890015E69238E4215E93CB9BCB70@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200507142108.13090-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200507142108.13090-1-kai.heng.feng@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d14964a-a43b-41ac-7903-08d7fd5728c6
x-ms-traffictypediagnostic: DM6PR11MB4124:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB41248272D36CAF73C4862AAFBCB70@DM6PR11MB4124.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:186;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L7GmU/8oO1kAkeEY8PHePqyRfBIE+/P7/+oV5vFyQmN3NLlnCE60+m7iTZBsP+wt/Cj7SPFv7lsxrsu+3D3+OLqarJzNvGd40DaPINwP8ELckwpibBUFrBMS73WLYGgopk7fcF/PD1yjr+Ue7+G4lN9cPRVpF4vc1v6q2aB4m5LX8AtzAKnnqxwst2NbXssrMDrUnVoYOupb8bUdZL4MTwRww8w0iT9osH6eL0h4bf7aF5FODWAEBjuNHyHRjOHR1LY6yfDrO8uhEgTicK9KwvzCzOGYVp6Haj3CI9+GWzooGeP6+1Sx71iCrNMHc5XpSzL7J2wvO0I3iunmdtID6/iolU0TuzUdYJZ92kJbJHnrT+5kfDdp2O9UWISPLnfknw/nmnzs74fyg5bxGYohQABF96jLnfq1hGFy5vse8A6YaOv7T8Fe5M5ThvToQFSlx5GKU8dBaieHfwarz+zUlgMbhFRaoy+WR1ZklCUfbY9mUcxrB42aC4+73THNaSy95GtJEftvddk7vP9tUZJjwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(366004)(376002)(346002)(86362001)(55016002)(66446008)(66476007)(76116006)(4326008)(33656002)(64756008)(186003)(9686003)(66946007)(66556008)(26005)(110136005)(478600001)(53546011)(6506007)(54906003)(5660300002)(8676002)(7696005)(6636002)(2906002)(71200400001)(52536014)(8936002)(316002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fqM2jgRu9DjWGq/3csQolFDU7kIzuiNFWtEXKljMwX8w8q1z/QsIKpna8nykmGbEHq5znMbX9jZnUxT+3Bpfn4tLTiTZWuVDhf5EevtoOlPipakG7aqH+aYyq3DfivPuAyorvS9j+lx0G9DCif/ecLi16AOOittGHLypA+rUoE95V6iCMkgi0PsBCJv+Xqji1mT3BRLRj0PmXQ9kX7x0lP01SDABEoEdDcgeanc6Z9lHS4G3bJTQKawiGijO2oXF6O6y1pgNuB121tgtKTejrvOdS9kVkLfB/YyMMslBd3zDvztMOWZSuPuLrXXclX+s2rQCgG+hxpsSe/fD8JGhrI1gTgdqpZHRZS1m32n223zLBIIK0DqYv+51Tv4Fc+8jSTPlxdlzuuOWhD1lEIcrpOB+I06m3nbZjn7ivQOl6C5IZHQgjWzv5DPNpw7UjnC5xNNKe2LGQMVtj/tUS5Jci9SkcEFheizcsppSjUhNmYrK5XQ6jz3tuEnWa5KHsIMK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d14964a-a43b-41ac-7903-08d7fd5728c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 07:18:28.3502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m2yR+wnnXog+V4CMVvG5NhkwYWK9kdwBafaosSmPYb5Zs1o30lNcTHl220KwVvc/KZ6otieXBCc9L5t8eB53kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4124
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Kai-Heng Feng
> Sent: Thursday, May 7, 2020 7:21 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>; David S. Miller
> <davem@davemloft.net>; Neftin, Sasha <sasha.neftin@intel.com>; Dima
> Ruinskiy <dima.ruinskiy@intel.com>; Avargil, Raanan
> <raanan.avargil@intel.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list:NETWORKING DRIVERS
> <netdev@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH] e1000e: Disable TSO for buffer overrun workaround
>=20
> Commit b10effb92e27 ("e1000e: fix buffer overrun while the I219 is
> processing DMA transactions") imposes roughly 30% performance penalty.
>=20
> The commit log states that "Disabling TSO eliminates performance loss
> for TCP traffic without a noticeable impact on CPU performance", so
> let's disable TSO by default to regain the loss.
>=20
> Fixes: b10effb92e27 ("e1000e: fix buffer overrun while the I219 is proces=
sing
> DMA transactions")
> BugLink: https://bugs.launchpad.net/bugs/1802691
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++++
>  1 file changed, 4 insertions(+)
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

