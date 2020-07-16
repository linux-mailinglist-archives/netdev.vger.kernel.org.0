Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBDF222AA6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgGPSI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:08:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:60676 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgGPSI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 14:08:56 -0400
IronPort-SDR: FYGdK/WhJRPBh3slVTB1yBZ1gGH7o1A6Pr3FeCRC46GvaPeo69iB+ha5oKW0b6rHpYuaD2nRDe
 WpzfKZ7maoEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="146970313"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="146970313"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 11:08:55 -0700
IronPort-SDR: IXXFJUo241OZVD8g/E/Liv8jr4vModYC9OPH5hUpOPhBf50Ev1Tu3b+hJhfRZSUssWL2Wq7eMs
 pT7cycbSD4vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361115682"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 11:08:54 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jul 2020 11:08:54 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX153.amr.corp.intel.com (10.22.226.247) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jul 2020 11:08:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jul 2020 11:08:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lE2Io6+x1nFB4VgH2UgSKVXOStGbNzf3JH3mtFwNFnn5wECYqt5EMfsmrkctQ/TJJzFlmzxuxNW283hIjfHRPSu18m47+dsqc9JRLOCcy+Kl0tY1NB32rQyoU4zo6tKynzNMXgJpm0RLCW3BObUrPbPrwNAH13PxK7DZU3oOH+pAQEHbKcKLPgnoI3p3AdYlMx3VjCUKdOUp889mT2WQBJhB+y3V6o0u8ML2seKxk04TGhiyTwDcll2Fpg7EB6IXay7jjCE2KpNe35co7Zu7iMJH8fjD5cq+oMpzFnEMyIpRUZZg5BjajiUFxfoswflwnHerASVY+hkM/ajQ0oh/3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzD18s+ZsdrWm+pWD1PhrS8r1axsewygjcTmNw1PV9c=;
 b=TBptBzwR0/SgPM7Fa0DETDpWhMvINc+FozNcqq/JoXTSRPgNVxQ0/ODbI7HXwdCPnpnLO+pwOEAvC8hEYWXwTQ1f8FUrfZfunQW49odf+VV7VhR5My5ICpQWg2A8947d3wIibFVqZhjhNtm9QGPe3CQ0akLt+agKUeboXLQbJ9SvTp+Pt+kKr6oy8mOfV0+ZS8v4IEmEc3jljeQwmKhoSTclrE9294OCFWfaOz2CmA6FPeLoDbleVJdTS+QPiuMmyuS8hd/9Yejhx+mHw/nbyV/j0buOJYHVpvA0mc3KMr6301ZVLMIX1eRO+E/ocoVahI0C6YQ5p9w/CwAr6M7JFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzD18s+ZsdrWm+pWD1PhrS8r1axsewygjcTmNw1PV9c=;
 b=YBM9UiG4njNCnsvK5gasW10bgAQqsUu/oIY+Zu9nbksG3ygz4GYsF4o1+vaPvxPSThLRoM+UmRMJE61wP/niSTbjWESeKQxG37Xj1naHYn1UlYFN09acCAB2v63aff4mrPfJIcoPUESgcYEaNPifwsCvV4u1oy1fuOZqZaA/U50=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4219.namprd11.prod.outlook.com (2603:10b6:5:14e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Thu, 16 Jul 2020 18:08:52 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd%6]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 18:08:52 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "bjorn@helgaas.com" <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: RE: [Intel-wired-lan] [PATCH v1 2/5] igbvf: netdev: use generic power
 management
Thread-Topic: [Intel-wired-lan] [PATCH v1 2/5] igbvf: netdev: use generic
 power management
Thread-Index: AQHWTfgyxYgsGJtzC0qSOWKZgsoK6akKnDTA
Date:   Thu, 16 Jul 2020 18:08:52 +0000
Message-ID: <DM6PR11MB28906BCEB8DF7B0F7B6C7B1ABC7F0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
 <20200629092943.227910-3-vaibhavgupta40@gmail.com>
In-Reply-To: <20200629092943.227910-3-vaibhavgupta40@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.173.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b825bc3-a85e-4e23-8c8b-08d829b34c33
x-ms-traffictypediagnostic: DM6PR11MB4219:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB421925E367B5A121BF0134EABC7F0@DM6PR11MB4219.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 11cR+52uG+vbebAK+XnFi6ErxsKPKNG3i8TK2UHr64/xiQBjdovtimwuGKYu8w3LIKR//c6ie5BPAJ+FjOls3UWnGhxyDHtXkl/fXTcvrj77EGWuR2KfVbHsg4iEmKoXoWvKz/MrD2qSdvChIoEhODGuj4eWmzxpS0mqg5z6X+6/CUpK0pmBfUfMBTAT/msfWj9lDBw/0JdctkmV7Zhl9ss+SqjSH57LwMZWv2vuqXWlogf3tEgY1AuW5p/TU9QR+zhdyAmN86kiA6V+gA6eOWfYBvH+tZ0SnK5V2BqZoZ2Zjn3UW+v+HHMWBDIx1qFSDe1/6RAttLeNI6dcMN2ujGYAsIDZRpwtGkDp0LSbGRr6ZL8wiV6L0j9KCSQDh+NV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(186003)(76116006)(54906003)(110136005)(66946007)(5660300002)(86362001)(66556008)(66446008)(7416002)(26005)(8676002)(64756008)(66476007)(6636002)(6506007)(7696005)(9686003)(71200400001)(2906002)(8936002)(83380400001)(478600001)(55016002)(4326008)(53546011)(52536014)(316002)(33656002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vB2iAR3Z31xjFUdLUH6U9D/v3LvXuI6Z+iD4peumQQlVE9rcTXSdT4fQs15Yhpcf3+PlgNJimVg88FOECFyQqbO5ssHrIzFdoN5c/Bjtl49VVp02ofUBHiox2AwywQkLnkRXC6OBu4mt2U7/0eF8CfOMGhmZFcYCEfjMVFcHpes4/fEa/gOCFgrM4jt6gLb/QA/3jwGG3rS63kX2mSaErT2RkjhMx1Lk169XGvrg057ZPiJ/WWNuSrvwb1obAo13nrLbCgBl0MdYD6Lm0UmvraLrOin2XDnXVMfxC558yl5RtzTwJXLfU28dzL0Pkew0ZUmeR8poihGV8yaz5uTF3A6sCjsL6roEfqxVI6iBZDekDbczR7BvNttJcvnItxc10p/TWBQDuty/HDOmwnrX4llyT4TWRKo/5p3iRmmjB8TmyTkd4r+qV6LHszyPXoVnL0tHUgwimI0S8lHX5fLlzzCIW41jSD7JrenopYQk2LiTcaF+cifBdys8EUsbs46t
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b825bc3-a85e-4e23-8c8b-08d829b34c33
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 18:08:52.5447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICKNNgUad/tM836gZgRFoQzrDa+la21fyN3QzWjMZyydGoz2EhG1WRYFyMiO/LaxpOWDpp5tx+acRhT5RA2zEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4219
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Vaibhav Gupta
> Sent: Monday, June 29, 2020 2:30 AM
> To: Bjorn Helgaas <helgaas@kernel.org>; Bjorn Helgaas
> <bhelgaas@google.com>; bjorn@helgaas.com; Vaibhav Gupta
> <vaibhav.varodek@gmail.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>
> Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> skhan@linuxfoundation.org; linux-kernel-mentees@lists.linuxfoundation.org
> Subject: [Intel-wired-lan] [PATCH v1 2/5] igbvf: netdev: use generic powe=
r
> management
>=20
> Remove legacy PM callbacks and use generic operations. With legacy code,
> drivers were responsible for handling PCI PM operations like
> pci_save_state(). In generic code, all these hre andled by PCI core.
>=20
> The generic suspend() and resume() are called at the same point the legac=
y
> ones were called. Thus, it does not affect the normal functioning of the
> driver.
>=20
> __maybe_unused attribute is used with .resume() but not with .suspend(), =
as
> .suspend() is calleb by .shutdown().
>=20
> Compile-tested only.
>=20
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/net/ethernet/intel/igbvf/netdev.c | 37 +++++------------------
>  1 file changed, 8 insertions(+), 29 deletions(-)
>=20

Tested-by: Aaron Brown <aaron.f.brown@intel.com>
