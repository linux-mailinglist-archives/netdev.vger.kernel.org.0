Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD7F3D23E7
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhGVMN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:13:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:42344 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhGVMN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 08:13:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="209740071"
X-IronPort-AV: E=Sophos;i="5.84,261,1620716400"; 
   d="scan'208";a="209740071"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 05:54:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,261,1620716400"; 
   d="scan'208";a="662671053"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jul 2021 05:54:31 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 05:54:30 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 22 Jul 2021 05:54:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 22 Jul 2021 05:54:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 22 Jul 2021 05:54:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBhHrAaXe8se9+n5LNUYVhHOV8xztafwiKUrCHNdvzKId2EKlltmfL8j6i50rJVuRe3AOHDeQRjOvfLYbIiNP/nKsCxJcM4ivrLN+QvrRVTZbD8FGnZXJifxnuhwIzbXIYpClOSoOd3r5daZrFpubjP+nWvpF+kRjThh7GNWL5cz8WLCi6Xg16zttPTKP4gAoBN0D2FrYtgIndEAO7l5wIWo8ldFhn+cLnrwzWl524IGDyK8XJdQ86nWMSBK9kVN3k84XooK1FiHa3sm/hdbAyNN1K1wnQI7gk47Ouyk5iRhJBVrbb9hl5a4qS7oPUgTQFb6uCnsYK+fDhwmPDPraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dF5pguCuumoE8tjXlr0IMcMrSY7+QsQToKx9sxdDWFE=;
 b=I7vRskq3H8GIvJQ9ESQeJ1kMl6G20HvxmO5KKB8vzY0XuIFl6psh/GVQsLdd4C94OvevEoQfamaEkpgNQBaYrK1vUWOglwlCM6wUliJ8jhSBuZwpDMKyqVo+gxzf4Nkh2/6QrQy34zWVH+KOWatKJKDUM/xzA10c4ya4y6vT/Kf/WZvoGQY2pmGn6ZZYYVng97b74vlYdnFZI7weRpIyvesxt2b/tiOmny1PSVw6Gs0I7afjE3SkAI7jHsjRqCW/4qdGOILpD2xWvT8kNfifiutgboKDc2BmATnx91ii+EV2m9do29EbvTW0DISHcj1wCSn+bFQd2AsvWH8qT/gVxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dF5pguCuumoE8tjXlr0IMcMrSY7+QsQToKx9sxdDWFE=;
 b=cNI7osRRBEDiWEQtTt3AScL+zzQ1MqImaAYdANqACJKakNCkFbICquziuwOoKxgLL5FyS9ai9Yqhtq0mIa/gtXKcoGZF+8oSgQyHcFTk4bdhdXuUM5tfaYZbNeUx2A+v4GC9QggzdNtqbPvy95eJLZdZlLm3YOSaLijUfqvOWI4=
Received: from DM6PR11MB4610.namprd11.prod.outlook.com (2603:10b6:5:2ab::19)
 by DM5PR11MB1595.namprd11.prod.outlook.com (2603:10b6:4:c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.29; Thu, 22 Jul 2021 12:54:28 +0000
Received: from DM6PR11MB4610.namprd11.prod.outlook.com
 ([fe80::b18f:287:e861:69b1]) by DM6PR11MB4610.namprd11.prod.outlook.com
 ([fe80::b18f:287:e861:69b1%8]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 12:54:28 +0000
From:   "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "K, AshishX" <ashishx.k@intel.com>
Subject: RE: [PATCH net-next v2 1/1] i40e: add support for PTP external
 synchronization clock
Thread-Topic: [PATCH net-next v2 1/1] i40e: add support for PTP external
 synchronization clock
Thread-Index: AQHXfb3kmxG0QVzrfUuksV5tYa5DAKtO4xWAgAAShfA=
Date:   Thu, 22 Jul 2021 12:54:28 +0000
Message-ID: <DM6PR11MB4610EF80DFA1C2EB2166CE49F3E49@DM6PR11MB4610.namprd11.prod.outlook.com>
References: <20210720232348.3087841-1-anthony.l.nguyen@intel.com>
 <20210722114701.GA3439@hoboy.vegasvil.org>
In-Reply-To: <20210722114701.GA3439@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a992bf97-43a1-42ee-da1e-08d94d0fd7c0
x-ms-traffictypediagnostic: DM5PR11MB1595:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1595994139F9B0C742EDA165F3E49@DM5PR11MB1595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BN7wgt25aM0o7i5J9r2tYiYz/Znwjlbzelm7J89HFRp7igVkr/ZyhBEW2K7taSC5vtbknop545VxUmgBe1ZWmNPSIBBEfcYuF8pJDvjl0MMakXOD5830NstYXrW3JpQa10xsHUdpY2SzRziMQF1reKTSv3iRA9p0H2QohCs5iNDPqyV9mArlJvO0YTEhDExbi7HdQJ7vLovXQuJ4Z74qr4dX1xfPbqCChNfP9IJ/pi2jIf1hNW7kmKMUEZHOEPDte5t9jOEXWAubK+s019bIutxJdtQeDN01ASa3dF41V9l+s5Ib1knvP3BHTzHob6LbqfyyqodIn0N7jh/fFpt6JpAgCdqit1SSHxHfnjYtciBwrHagSlIdaxkRFGRUhIpLXeUpmDlArjWGJyNOPjHb19vQ+vTSFkNOH2iNPzKmQM6Akg5Ll5knbaOC4WXG49s7w7yRwwEJMJx7/uZ6TL6/dG2oMIbnEMygzJsvndtnEqVhxroAoayUU/4kXbFm7pSWLuKtqWj4cZcriX4cyZjWTROY2Yjjra+bnuqBnhkmi+pxNtrzysj4WEKg+7no+UC2iX7gqWD+t4RtbqzKLIJKcBaElRNvUchc9/YslbAiu6GXnh4Ow0UwpwCuTDj9n5uAhxyOvnLu/48x0ISnXaGG5eciTsDj3GHlsLwuL1+I+I+8QbWV8cXNbh/IKazN1NfID+IN/lG+DlhvOaeP5lIf4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4610.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66556008)(66446008)(54906003)(64756008)(66946007)(8676002)(5660300002)(316002)(110136005)(55016002)(38100700002)(33656002)(52536014)(66476007)(4326008)(86362001)(6506007)(6636002)(9686003)(508600001)(2906002)(8936002)(186003)(71200400001)(107886003)(7696005)(122000001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lXud/G9/PPkCHS3nf07fu3BT4rFl/LnPGqeeKdls8cUf3joTfTuuwfIg3yii?=
 =?us-ascii?Q?9lWflhOc3U/TgBShzygl65EDLyo2P8VjXPLqZY99JVe7DU7IxC0+hwsQnewo?=
 =?us-ascii?Q?779YKKsrQMgynjTQ3+6h1lDrCUG77VIelEcJ+v3dL0DEknCIZ2WXCTEuoQIO?=
 =?us-ascii?Q?BcWsomKIstONIfo52HtgSA2theapZMCyMpXoV3CSFA0IsIFBcA6se4D2TBPR?=
 =?us-ascii?Q?uzv0GeILpNAHZd0B1vcAKceyrugswrcvtlq9/HhzYGMEqin/1KOoDpKsKCCv?=
 =?us-ascii?Q?tdBsHnFQyqwSZo/VTxHl/SUCRIRtZHpoVyBynWw+RKNqzcQZOMAIjQY72k46?=
 =?us-ascii?Q?wTmsqi0wH9x831AfgDmDLTByXfsOs0a5crcFO0NmTATTvE41bbWmQGfkNkUf?=
 =?us-ascii?Q?akobHkqsboy5ulLztyYohLKbL6CZUuyTJ/JXTMs/FgdxQK11O2cHDfSOfJm0?=
 =?us-ascii?Q?zoFGbVjINHqj2w+fi5DOk4jf5cB7uen2zgO+lLWI15gn9LPqWGuS3wRWvd0V?=
 =?us-ascii?Q?XQIlhakf6H7z0OPJJMlWZbTFlj+suAC43Ib++NjXhJHUeMua7CcrkwGpZ7nl?=
 =?us-ascii?Q?ri7cWdqo/2vf/epU/nuwyjyf916jBIgiNP6t4VCnNeDus24sQD/id7oA3U1V?=
 =?us-ascii?Q?3y+hUam0WBfJlFW3zv3i+zI4KSeKgl+mZX1ML3Z3xsRxRJWISH9iJCzaAlca?=
 =?us-ascii?Q?tZD1r+zr1mSPDlzNpweFw+ZRFx6HNF7ta8HIjEooMzGt7U72Mmr49yVp7gK2?=
 =?us-ascii?Q?0QbVSZGXB/PTCt5TyXyXKkm701HMTu5L8GP/RLvi7iQdPP6eEHKlhXGJvCiw?=
 =?us-ascii?Q?7hAI1mXIUCcYNljcXS3nRBzkgFcnWx7lyuoRzy+yOCW+rk+5CsoPUxqS0z71?=
 =?us-ascii?Q?L52lk5GOV+FQ5fbXaUK0yMAKUP1sOb0yPAa9NOxyIC1Lo06QV1nEGGGpOeaU?=
 =?us-ascii?Q?e1WWL9JOhB4my92gO+ReuAkEoT0ocwwTv5HTwCXqbELi3CApkqrYLpqS6Cyf?=
 =?us-ascii?Q?i3cd1AJl6mh9P0fEDro73mdc7263c6R46UDyy3/Nr2dbBhrJg8viiC9qnia5?=
 =?us-ascii?Q?tdM5bdw6lKoIXwByGsbhFKkfcr0SgWg99pRi4OMPQo+79VE9lw2DlXlrCVCQ?=
 =?us-ascii?Q?98QNHRDsNVlKeeZCkfwFOIfVZkYWP4QtDowycynJD6jxkS61hHlJd3YpRGeL?=
 =?us-ascii?Q?rK2iCGeWUiIdfT9oUhDxQxbb7n77MsY+wDcXgWUgPYAzB71AqsEOEx3Zu5af?=
 =?us-ascii?Q?mzuMPM8kMRqAOY6JZxL395PljAo/EiMNb+8sBloud7hNd0XeOzz6NMiMxQeD?=
 =?us-ascii?Q?2RVAv9vvH7pKN0+41S9N4UGmTNbDmITWMXqq0tPNr2CdQu4KL9EBZFf4Tsc9?=
 =?us-ascii?Q?pTTHTKJWKgWWAlSZoxKKDMEzE3RA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4610.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a992bf97-43a1-42ee-da1e-08d94d0fd7c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 12:54:28.7213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ExFCW+AxUfcLM7zP15joaVlL9wN2OfV8Jf2TP74ZUAIIYiFuWBgJy5MKNpeZiM0MSN4KYB4K0Skgq9SyTZ2UZSA1Es+RRj6hA9vEbEoEEFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1595
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, July 22, 2021 1:47 PM
>
> > On Tue, Jul 20, 2021 at 04:23:48PM -0700, Tony Nguyen wrote:
>
> > +/**
> > + * i40e_set_subsystem_device_id - set subsystem device id
> > + * @hw: pointer to the hardware info
> > + *
> > + * Set PCI subsystem device id either from a pci_dev structure or
> > + * a specific FW register.
> > + **/
> > +static inline void i40e_set_subsystem_device_id(struct i40e_hw *hw) {
> > +   struct pci_dev *pdev =3D ((struct i40e_pf *)hw->back)->pdev;
> > +
> > +   hw->subsystem_device_id =3D pdev->subsystem_device ?
> > +           pdev->subsystem_device :
> > +           (ushort)(rd32(hw, I40E_PFPCI_SUBSYSID) & USHRT_MAX); }
> > +
> >  /**
> >   * i40e_probe - Device initialization routine
> >   * @pdev: PCI device information struct @@ -15262,7 +15281,7 @@
> > static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id =
*ent)
> >     hw->device_id =3D pdev->device;
> >     pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
> >     hw->subsystem_vendor_id =3D pdev->subsystem_vendor;
> > -   hw->subsystem_device_id =3D pdev->subsystem_device;
> > +   i40e_set_subsystem_device_id(hw);
>
> What does this have to do with $SUBJECT?  Nothing, AFAICT.

It is required to properly handle the pin settings on PF other than 0.

Regards,
Piotr

