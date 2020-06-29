Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECDB20D3FA
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgF2TDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:03:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:9632 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729932AbgF2TDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:03:33 -0400
IronPort-SDR: +RBt/B5Hu/CSwlEq3jKAgad5rHnF+y2LvAKOeW/6Vb6YHMh/fyj6JhEffa3arOEHBz2zGg47i9
 iyqkzG5td3nA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="125596044"
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="125596044"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 06:53:54 -0700
IronPort-SDR: Od6t9l1+Tn4WWal3eZFpj9G6ssnWwR4IFbi2KFbbdwQ613BO7nMCY9KpUFh9ORXS4NZVeMTTOk
 L56Qri+5/OqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="480794823"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jun 2020 06:53:54 -0700
Received: from fmsmsx104.amr.corp.intel.com (10.18.124.202) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 06:53:54 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 29 Jun 2020 06:53:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 06:53:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpAuhAiE1ibxiKr95cNprQKyQHCxA/P2pMqpc1oABX/PhWKABm6dhRm22wWoLO0XUdALg3sZsIEAvxNi5St2a3qPusoNAWkLf7LBBjELwpcVUcaLBAxSslW78NAwZ3FiKwSP9QJZbrIBNdIgFyKp9sfiZmziTSI1L0mLAjDjk7qIUhjh/GFn1v4dKGY/JMwZqigStBhM0GcC8WEVN2TQSHc1uud68gUidbHz8DBr+wGLTuVABk7DVEB77POISRfqBCcZkDamF3mCHWsGtWB9AAfN3U9GQI6XrhejAdMUNoGG71KlToX64GInOStXY//yeR7BXnknwgm61lklx8L4IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2evFZRErBmnazkywRxBuFe5x5BbXcGgX/YiJws03t9c=;
 b=Be820ZMRM0WfJ5rj9UBfRwReL4mvy8kT+Zx0j3MCtboTFQUdnbqlEXX/1N81ero20dB5TxEy4LmhrceXHqNsM2zSK8gcjKI5klcRFm2SpiTLsmUf3upXB5stxLgHy96gIeWZQdgoXFSWYayba0LV7cpUD9rTdGlpCOK0o5F98uVTDa4W4t3/9j2Q9KgoB9+hWTMcktDRGCaPQ/gkYrs1rDv5Xzz8eVMFGMUDCntAP2O8m4DoPFDx9K6yJPGARwSwPobFVT3w3X7j963YzlWX8uF2xEIn4MRKJnb8Hnd2/XhZtwKzbNU6qNlNPSc3fjlmJPtBsXiLDdFlgvxDuwyS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2evFZRErBmnazkywRxBuFe5x5BbXcGgX/YiJws03t9c=;
 b=PYeRJf3eIkhtVSb+IB5lEz2nW+pZzlSzr7bQM3YIblguimMTVZWvuF3IOGr6r2pcecwJ7MZ1w8/jSvy6PBKZNPnpgfPdMvsjoJ4Su6w0HSTW1h/q21jY6iihSCEA4jbK1k2l4xsLJZ8JfR5OFfuLDOK1atZKuWDCxsuKFaVIVR4=
Received: from MN2PR11MB4064.namprd11.prod.outlook.com (2603:10b6:208:137::18)
 by MN2PR11MB4000.namprd11.prod.outlook.com (2603:10b6:208:13a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Mon, 29 Jun
 2020 13:53:49 +0000
Received: from MN2PR11MB4064.namprd11.prod.outlook.com
 ([fe80::453b:72cf:dc13:cd6e]) by MN2PR11MB4064.namprd11.prod.outlook.com
 ([fe80::453b:72cf:dc13:cd6e%7]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 13:53:49 +0000
From:   "Xia, Hui" <hui.xia@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>, lkp <lkp@intel.com>
CC:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        "bjorn@helgaas.com" <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: RE: [kbuild-all] Re: [PATCH v1 1/4] ide: use generic power management
Thread-Topic: [kbuild-all] Re: [PATCH v1 1/4] ide: use generic power
 management
Thread-Index: AQHWSnTi7JozU7O8kEuaNVnVD1fiSKjrCcoAgASatrA=
Date:   Mon, 29 Jun 2020 13:53:49 +0000
Message-ID: <MN2PR11MB4064B8C29026DD76FA1B1998E56E0@MN2PR11MB4064.namprd11.prod.outlook.com>
References: <202006250611.HDgpcjeu%lkp@intel.com>
 <20200626153500.GA2895752@bjorn-Precision-5520>
In-Reply-To: <20200626153500.GA2895752@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 894a68dd-19b2-4cd7-312a-08d81c33d9ae
x-ms-traffictypediagnostic: MN2PR11MB4000:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40009F9002E2C64F0853EF0DE56E0@MN2PR11MB4000.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IzXKT7UhfXNbvVL3sHC5JVUUbLCA8rx/QuvXyUl2KODPdleNK1vHSBBcGavLUNPJP64WQXfk49xpx4BzsUNqhq2yTsALLF0F3fv26j7+9NidSJFZdnimmxP822VnZIUICE9ajekAAQnya19FSop3qbiLio7j6p3iAP6fDGkZCDi6ObAx2P1s97sNlfpGUf3j3VCO71I433Kd6mMMeR7/nJC6VWN5tWBME+hIc0l/OGy4NRBcvovyuAI+kRUSWwJ1hUzpRFHD1D2s8T2OYNlQkZk70ooNjkKL8un6afIHCdbCqYQhNeqRTkBap0KvB3Ndl1Y9z13u7G9CHatoIIPDPxYBJe2qGOjmTUDd269f6O0oofODuvExOo8nJp/IYAY27tx1YTyQ10qTtxHswWIRtD9sm+HefoOnHbtIfzepDsrIQOnIXh8wdwDM4te2PRHct+T+ZnrJGVFgXRvk5l95fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4064.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(66556008)(66476007)(71200400001)(66946007)(64756008)(66446008)(2906002)(76116006)(52536014)(33656002)(86362001)(5660300002)(4326008)(316002)(83380400001)(7416002)(26005)(186003)(6506007)(54906003)(110136005)(6636002)(966005)(8936002)(478600001)(66574015)(9686003)(55016002)(7696005)(8676002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UDYuyjDb9rfCdCa7gcw2OWe03xPx6UEzUTf0hTdl4fYAq1vQrSeDcP5xxUr3+bFbzLPOQ+7gtt3OKMzt7re+9QVeJzz/qolaCxaKLBdjLW6p/4MaG+X6G/KKqKSuBWfCMzorVN4n5Q7n58M/dgW07zbbOjdq36sUT+DPCKwv2ZWtGBAatTmKBAhw8IxxA+a7nkig/FDRo7nKX49MuxaSH4zcsuCwyh8lCxvXESEXIeJgmNBpUDHa91sgQrV5Uao6vEU4S9PZsXVZ1SnFnh5ZWsNfYuS+TlxlUC3BQ0ke1ql/DqbtiWpvivKk3fTX6NDDzH/YzuoycGwC0UtSSJ4SvxrRg8OZtjXjeVaEFkaE/JpWy09N4Kdgkdx2+7zmPmCHZiq2gPcWFxaiAKlSXGM/ycg2phQ6JxKD0M5R60dkrY2KRezESZexKZ0YW5KWpWyW65lepAffiXNTmC6Jd82NB63USbZ0jEfXuYhBmcm3rrnGXUYdUvIBB6ihqPYqXrIm
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4064.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894a68dd-19b2-4cd7-312a-08d81c33d9ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:53:49.3067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xfoIm02HJtYSIGQ4W8iPTG4Ok4DEMw42HpfizidGqTbT53EtSvCu6JL6GlPdqnrdGVVlBV+3QFiUBoV7cEjLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4000
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Bjorn Helgaas <helgaas@kernel.org>
>Sent: 2020=1B$BG/=1B(B6=1B$B7n=1B(B26=1B$BF|=1B(B 23:35
>To: lkp <lkp@intel.com>
>Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>; bjorn@helgaas.com; Vaibhav
>Gupta <vaibhav.varodek@gmail.com>; David S. Miller <davem@davemloft.net>;
>kbuild-all@lists.01.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.=
org;
>linux-kernel-mentees@lists.linuxfoundation.org; skhan@linuxfoundation.org;
>linux-ide@vger.kernel.org
>Subject: [kbuild-all] Re: [PATCH v1 1/4] ide: use generic power management
>
>On Thu, Jun 25, 2020 at 06:14:09AM +0800, kernel test robot wrote:
>> Hi Vaibhav,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on ide/master]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use  as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
>> url:    https://github.com/0day-ci/linux/commits/Vaibhav-Gupta/drivers-i=
de-
>use-generic-power-management/20200625-013242
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git ma=
ster
>> config: x86_64-randconfig-a004-20200624 (attached as .config)
>
>This auto build testing is a great service, but is there any way to tweak =
the info
>above to make it easier to reproduce the problem?
>
>I tried to checkout the source that caused these errors, but failed.
>This is probably because I'm not a git expert, but maybe others are in the=
 same
>boat.  For example, I tried:
>
>  $ git remote add kbuild https://github.com/0day-ci/linux/commits/Vaibhav=
-
>Gupta/drivers-ide-use-generic-power-management/20200625-013242
>  $ git fetch kbuild
>  fatal: repository 'https://github.com/0day-ci/linux/commits/Vaibhav-
>Gupta/drivers-ide-use-generic-power-management/20200625-013242/' not
>found
>
>I also visited the github URL in a browser, and I'm sure there must be inf=
ormation
>there that would let me fetch the source, but I don't know enough about gi=
thub
>to find it.
>
>The report doesn't include a SHA1, so even if I *did* manage to fetch the =
sources,
>I wouldn't be able to validate they were the *correct* ones.
Hi Bjorn,

Please try:
$ git remote add kbuild https://github.com/0day-ci/linux.git
$ git fetch kbuild
$ git checkout 1835cfb6a85a52c4c7459e163d2c850e8b71ce9f

The commit sha1 1835cfb6a85a52c4c7459e163d2c850e8b71ce9f could be found in =
web page at https://github.com/0day-ci/linux/commits/Vaibhav-Gupta/drivers-=
ide-use-generic-power-management/20200625-013242
We will enhance the report information to make it easier to fetch the sourc=
e code. Thanks for reporting.

>
>> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0 reproduce (this is a W=3D1
>> build):
>>         # save the attached .config to linux build tree
>>         make W=3D1 ARCH=3Dx86_64
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>, old ones prefixed by <<):
>>
>> >> ERROR: modpost: "ide_pci_pm_ops" [drivers/ide/ide-pci-generic.ko]
>undefined!
>> >> ERROR: modpost: "ide_pci_pm_ops" [drivers/ide/serverworks.ko] undefin=
ed!
>> >> ERROR: modpost: "ide_pci_pm_ops" [drivers/ide/piix.ko] undefined!
>> >> ERROR: modpost: "ide_pci_pm_ops" [drivers/ide/pdc202xx_old.ko]
>undefined!
>> >> ERROR: modpost: "ide_pci_pm_ops" [drivers/ide/ns87415.ko] undefined!
>> >> ERROR: modpost: "ide_pci_pm_ops" [drivers/ide/hpt366.ko] undefined!
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
>_______________________________________________
>kbuild-all mailing list -- kbuild-all@lists.01.org To unsubscribe send an =
email to
>kbuild-all-leave@lists.01.org
