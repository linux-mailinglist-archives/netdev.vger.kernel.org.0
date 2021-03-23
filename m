Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33F83466D0
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCWRy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:54:29 -0400
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:42369
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230035AbhCWRxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 13:53:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOIS2YwPRsQhtxPjGlMdzf2v3GNAnDhIXLfRfwm3K2KYxrsZEEFjvYTQJq+dCEctYxB56q+4PnmEzT5WVURarazWKVUDUgD/h9fLXosI0MGieRPFvS9wcBSz72847AGXMrtu6sGk5SB4yupiouOYK5jvaaxhYgyg4arsPg7z98oNUdkVb0GXz3bShy93dRV1ogOSyu+JaUsEpltuX99NThBLOhiTNC/rivcbGyFrbPdAidpAys4RAglPzGXl5SnWZuf16Wge+jwsvi6oWQ5eMExaqMZhQvcuB6Iazpm9VrUzxu2uNqUJmbu36nNeNLa98VpKlDhFQ0FeXv5fu/4jAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpfqslFNLATz9xJXHoEpnlunC00KYPpPdWjlHYq/kSM=;
 b=QfaoncMgXNID8XWPSyZ7UnCbl5eDmAZSiOsIF2QuujrzKa3dFw+gjFlQ9IIvrUbj27PNo5wKYsLFmQ1Lb8jYuEpN/xe7FlL4Z/EdBRFCJ1Iui5ngymiOKix1uQhAE2zAgtr0aOtXSyJHKcW8/jisiwbZghAMWK2tb+JSikjp8K6oZjN9R3aJyE94qx05e+GNjJerNOUErCJlKuqDAm2qT6b/cirlWny3S+YaYkQZQjxZI0tyN52//+NLRxbfbM3vuLK5g37rmbD8JQ+veZZ3N7253gX79vatgj4vOI6bRYC+uCRZoNJUFjBucesFFVkj+mhd/w5FBf6nHW6vLhuWPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpfqslFNLATz9xJXHoEpnlunC00KYPpPdWjlHYq/kSM=;
 b=nhIwYDWzCUa6evfEsvOv1dmgK+3Jalt+eK6UYhfl+0W7+g8lUU1XJtby4CcNpy66nYlkN9G73oWl9/ZOzXQfv9uaxRFJaBaXWskhz2AtU+4Hcp+zbMBBKTA0BWgeVi7DGYX7MRwX+0A/0jCnnAde01s12AWIf7uD/0S6G2+M818=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:53:53 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 17:53:53 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v5 08/24] wfx: add bus_sdio.c
Date:   Tue, 23 Mar 2021 18:53:46 +0100
Message-ID: <5713463.b6Cmjs1FeV@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAPDyKFoXgV3m-rMKfjqRj91PNjOGaWg6odWG-EGdFKkL+dGWoA@mail.gmail.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com> <4503971.bAhddQ8uqO@pc-42> <CAPDyKFoXgV3m-rMKfjqRj91PNjOGaWg6odWG-EGdFKkL+dGWoA@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: BL0PR02CA0050.namprd02.prod.outlook.com
 (2603:10b6:207:3d::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by BL0PR02CA0050.namprd02.prod.outlook.com (2603:10b6:207:3d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:53:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 150d15dd-a825-42fc-4436-08d8ee249f12
X-MS-TrafficTypeDiagnostic: SN6PR11MB3455:
X-Microsoft-Antispam-PRVS: <SN6PR11MB345586A20D9D4C5450E0D24893649@SN6PR11MB3455.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qWCuwgO8wnOKaAdKBChinWt51PbXWN/V4Uq4HuhOjCUn0JD84pO2JyrNDd+DpxBYTtbbRB0lDa9bQHi4X/Qrj7HrC9AjiBLcvHqlrEcn8JkK5FomMTvRidYF1KsyR77eYtTApVBbwCAcfJPoBFRTk9qO3yFzMOVDnBNKg1vpNYPrOPSfqEPoF6uxvUHmDdhXQ4Pe5UREwRE+4IfUhzcZkPgXuK6Jg8PvsCgRvuX1gBBadm0jJyeYnGBmDm/VFTtnlYfIR5zhoXONke9v4RnFXAVvmomGBH/MdWjSULx+i5jZb5imm7YCoKQbNA4Xi+JqII5bnKTNf2CL7Emu/DFbPctRrrOupe0DLBLNNk3vqFJUecN5vSbDOG6qGSSdNmx6/IrXNSnnPoEnup1jDdt+LOlyX1VHiA0DUoVreHvz/4ARvdmeCjWNOLtXrfX/It3/H+r0bjvVmQzyjyz/r5yWwbNtuy+Roqj8VlphVYxjC2DztgbRyNuO1w/4NM6Uk7FiGXRX9UfIgqGZKS/P5al5458F3BUD+GJA/liZAd3CE75bifIoFxIaT6mSifY49u0eJ/63yLHM2wT3yCXdz8Q8+15mMU8/ROSd+JVlSkghoppsSrUgYA98ySLhKvnTWhZRiXxlg9hzG687fjyNEMSX5NEJkFhmNR4dtOB4d7LtG5JGPsnAc0CaQ4LZYyY1TKLM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39850400004)(396003)(136003)(2906002)(478600001)(4326008)(6916009)(83380400001)(7416002)(54906003)(6506007)(6666004)(6512007)(66574015)(52116002)(36916002)(8936002)(5660300002)(9686003)(33716001)(16526019)(66476007)(66946007)(316002)(86362001)(8676002)(66556008)(186003)(6486002)(38100700001)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?9gbywfNUFWqVs/nXbUz0K9UFKrMvvjDU1Mf1Xc8izr1Yy5XtNX6g4NwMyZ?=
 =?iso-8859-1?Q?g3qQdiMxHHqC2dsWh5aXem/ugt740i3BJlTrzlhvcXPzGerAA6VfudDP+1?=
 =?iso-8859-1?Q?j6uENjrz+WIx4bJm4jtvt8Mm7dObetUdm1lcJgdQeRM6gMY3w545xyCcd6?=
 =?iso-8859-1?Q?Q3hSX8wK34DtREW0mnIqMibgX3JMIVDzKEMaHGuVOnh7DS5Qg4WLBD7vLG?=
 =?iso-8859-1?Q?vRhrKNFrpStgQSfCTsT0OBd+XmPS0mxYIPwoW/SuTsu5B9/6Xw+yg2p3mW?=
 =?iso-8859-1?Q?wqsnC7nHo8udXkQsQLIAa6+Zfxj1YxT5+dalxK/IFZexZd6dSCGJKd0nAu?=
 =?iso-8859-1?Q?+9p+ZjyZuojVMbhoTXU/MJPLvcsIu3vq3S4iRY/0Pzl26Qev7wR7ILa1Rr?=
 =?iso-8859-1?Q?RBPUZrlCyXMjQuI66mMTFRHPU2PJQErn/gT7FvyfX2G2WH4FDqgCShre1p?=
 =?iso-8859-1?Q?PPCh0Lxay5j6rKqwmDgb6Z3/51IM7d2+glIyOC9Cbb4HLUjCoCGQtS8qA4?=
 =?iso-8859-1?Q?G4uy7d2u4i3B9U+hKlrkuRejV3w+V4REUjFxmxnyuhGCzouQYO0xMWODJa?=
 =?iso-8859-1?Q?nKLShxai+YStFuCTnIWh21ln7wQXID0VfaNfXPVYkADTj9SVHtOsBuCvYc?=
 =?iso-8859-1?Q?uG4cYJ7FDq+nArf+wiPnOawJJb4zO/CwK96v9iw/k4ItEDR7OH5wB3mO6g?=
 =?iso-8859-1?Q?qVRA9+AkESgn16Si7jmPpXky1uyyNI5DcoDHy6GcsfYrss77W2vqmnP0Qp?=
 =?iso-8859-1?Q?g3a6rrUxYb/zj/Bm7gnhUnv/V0OO4L0633eR7N5htcU/CDSTgavGlbLfAt?=
 =?iso-8859-1?Q?wp6CArx/bsBhKZxRJfk4M0aLi/4ge8bNQSsz2RIlUbLhTbeYrB5/NTfMuK?=
 =?iso-8859-1?Q?ipNQUQjInoFqW7feEGjKw3kADuSUWVBDi73ndWdyTICENpesGGYMQUQMRD?=
 =?iso-8859-1?Q?sCzmFe0McNoTJz7RuOy7no4s7z6TufUZAmXaPtQ39ftAzP3FajhtrYyHRu?=
 =?iso-8859-1?Q?iWBysGfpA2AQBAv8rLVzxqgJDIx7iJ0IsVqiKrwQFExa5MF+GZhQNdzTe3?=
 =?iso-8859-1?Q?0ZsxHs19UY78W2pUHQPooZ9xtAPs6FAvmN4hk8B8LLV//0ZWrUpBAjvXlm?=
 =?iso-8859-1?Q?1ReTBLRFx4gFSK4J23lg1onNHnpdNiFHaxpbwaBZ7/PYsP2qx8fOcaaV9K?=
 =?iso-8859-1?Q?6ES8D+Uot/LQEEwU5/93fQe31ziarwsOG2wF7n/2JpAVH1FHPOE1uI79lS?=
 =?iso-8859-1?Q?8eCqv6eGN5Sjv0HYY79JUHOtDF52Khsc/LgmmOE/3I9TNA5GaSYICfbm3f?=
 =?iso-8859-1?Q?zwaQBkXNWy24a5m4tgNQuB8paO/Do0FEQX0z9yzFYkpt9LL4KXG1AoW0+Q?=
 =?iso-8859-1?Q?OROH1ULwtiVVPIR2wbobU/JUPuWhXmTS8c7BETfsv60XCsQJFNkU03I9K0?=
 =?iso-8859-1?Q?SPEmBzhgcHWaSz9f?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150d15dd-a825-42fc-4436-08d8ee249f12
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:53:53.4029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtsylkfraRZhOmQFPcjDiE2rnPw9xTos6sdafycgEvEOBj7ULvFg4HLkS3xbaSN0tLH/v5RInL9wGF/4L7kQig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 23 March 2021 15:11:56 CET Ulf Hansson wrote:
> On Mon, 22 Mar 2021 at 18:14, J=E9r=F4me Pouiller <jerome.pouiller@silabs=
.com> wrote:
> > On Monday 22 March 2021 13:20:35 CET Ulf Hansson wrote:
> > > On Mon, 15 Mar 2021 at 14:25, Jerome Pouiller <Jerome.Pouiller@silabs=
.com> wrote:
> > > >
> > > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > >
> > > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > > ---
> > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 259 +++++++++++++++++=
++++
> > > >  1 file changed, 259 insertions(+)
> > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> > >
> > > [...]
> > >
> > > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > > > +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_=
WF200) },
> > > > +       { },
> > > > +};
> > > > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > > > +
> > > > +struct sdio_driver wfx_sdio_driver =3D {
> > > > +       .name =3D "wfx-sdio",
> > > > +       .id_table =3D wfx_sdio_ids,
> > > > +       .probe =3D wfx_sdio_probe,
> > > > +       .remove =3D wfx_sdio_remove,
> > > > +       .drv =3D {
> > > > +               .owner =3D THIS_MODULE,
> > > > +               .of_match_table =3D wfx_sdio_of_match,
> > >
> > > It's not mandatory to support power management, like system
> > > suspend/resume. However, as this looks like this is a driver for an
> > > embedded SDIO device, you probably want this.
> > >
> > > If that is the case, please assign the dev_pm_ops here and implement
> > > the ->suspend|resume() callbacks.
> >
> > I have no platform to test suspend/resume, so I have only a
> > theoretical understanding of this subject.
>=20
> I see.
>=20
> >
> > I understanding is that with the current implementation, the
> > device will be powered off on suspend and then totally reset
> > (including reloading of the firmware) on resume. I am wrong?
>=20
> You are correct, for a *removable* SDIO card. In this case, the
> mmc/sdio core will remove the corresponding SDIO card/device and its
> corresponding SDIO func devices at system suspend. It will then be
> redetected at system resume (and the SDIO func driver re-probed).
>=20
> Although, as this is an embedded SDIO device, per definition it's not
> a removable card (MMC_CAP_NONREMOVABLE should be set for the
> corresponding mmc host), the SDIO card will stick around and instead
> the ->suspend|resume() callback needs to be implemented for the SDIO
> func driver.

If I follow what has been done in other drivers I would write something
like:

  static int wfx_sdio_suspend(struct device *dev)
  {
          struct sdio_func *func =3D dev_to_sdio_func(dev);
          struct wfx_sdio_priv *bus =3D sdio_get_drvdata(func);

          config_reg_write_bits(bus->core, CFG_IRQ_ENABLE_DATA, 0);
          // Necessary to keep device firmware in RAM
          return sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
  }

However, why not the implementation below?

  static int wfx_sdio_suspend(struct device *dev)
  {
          struct sdio_func *func =3D dev_to_sdio_func(dev);

          wfx_sdio_remove(func);
          return 0;
  }

In both cases, I worry to provide these functions without being able to
test them.


--=20
J=E9r=F4me Pouiller


