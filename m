Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837434B7E56
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343991AbiBPDFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:05:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241477AbiBPDFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:05:05 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7F7FDFA6;
        Tue, 15 Feb 2022 19:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644980692; x=1676516692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RXmiO2VotT9x/0okRIn/+WMGiWP8c8qga7OVuJRAt8s=;
  b=Ty0XRVXiU20FE9Owt9q9wL0I4VneGDkofvd55VZ+udN1lpbG3+ZFiKa7
   OCzHqTLvseef1RshLNsj59QXvB1VPFzoO58WqDXqs4KJEQ3Su18N3dUzA
   vmyj5hMg23BYS87fGIJWrHS6S4lzxyLEDrhmuanOUGz5ioPNuk45C5ZYQ
   EsXWs8JTXnya4a9wvdPWdn3BCWeyepO4zldP95a7bIZtZxRbM0Vke/O77
   erM4Qai8js1BBQjYXas8Zt5s5OdHEtICcotCL87JtMnT47ALgsJeviTuK
   Ta+Mr8I1K7/y/XpAOw78dsDohLdqEXQ8COgqRd+mquS6Skzze6mkG0Epg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="248109116"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="248109116"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:04:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="529210556"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 15 Feb 2022 19:04:05 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 19:04:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 19:04:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 19:04:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CS44WAwcYUHnLH+tss1EZ2UAeLaZaju/z2cwKushe+D1tEgU9lsqBAwJJea77O01q5WXxRX/rfukc5IVEECSdgls1Yknc2ACkBgsuvtvIvEvvBi6OObGKN7U7U4NKbG5wKvjRBpe/rbg2wg5al8VgA07Wp1kYfKEPkFiCm3EA2YXqPx8tE45+30i4guoTZ44DwHQDJbxcf1j4vfV0O77EH1z2BMUhGbqJ2HbiyHYb3HS+37O+YTREO9V4OtKaIdUH/WjLa2Yp8/EiKLJQ+Oj0mac2qTraGTlJvhg3cVT7+1Z3xGAqenzMqz1FLnDR/a6uE4uhqg8bPlSfbEW4s03pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0DE4tI0bQaCwtBKQZ9v5wmSYnF/WeAcDrbyYUe/jyU=;
 b=dTzpU4YszIu4p+IGtHfPx+4UvPWdcY+T1iqqzCckzurFq1x3DWkx/z87bkgRp4FWwzgarV0VbaxaGW2c5hRUb1u8Lior8zfvRvul6latcIII+S9pSIaYcANL7Och+aLvnXgMbpCxNbzWYXMngKf0/YFwvbc2zXg3S+Jc6Fn14me8hAYhdXfsUhnN7RueX3s3VBIKE+wVXO461Gyg7HckQeSJXXfK+Im/x1nu00UjoewwQ+93xYA+A22BDA5upsTISOtYKN8PCbrAJVUObzT5l8eqNwx7QheXBxTADlF6NAfN8FnAwUofQ25W6VZgzz9cUvXUm1SetjgOro0lsl0Fmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 03:04:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 03:04:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 08/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYHEd8WrQ75CuCwEmQ+4nXbJWyQ6yUPI/ggACNtYCAAL7gMA==
Date:   Wed, 16 Feb 2022 03:04:00 +0000
Message-ID: <BN9PR11MB5276B3F6904149AB4B5FD4258C359@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <BN9PR11MB5276B8754BA82E94CF288F8C8C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215153343.GA1046125@nvidia.com>
In-Reply-To: <20220215153343.GA1046125@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf5b1d32-d3dd-4afc-f8a8-08d9f0f8fb58
x-ms-traffictypediagnostic: DM4PR11MB5536:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM4PR11MB553688CB8884E9629B7021878C359@DM4PR11MB5536.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sGxsfWloAHT7eciCXT3ievPtycM2w8rI7ShoclUeLP/pLvGMm0Efq+z8l5FWpT7isI/yT38cnbwYdQu0hnadGso4r+cCEamHMVj+12Pi/wtByRxYHurpcHZS8M/G1jAWQC1hbPXdpGPDbWL632IZPA9S61+yJWlk7qLvaSs7itngg9XYPOWRQPE5lBWuZhjoPdAOUwS69XJqDxUOa3qoJHOZ11et4svrU9soSM6pgxP2r5iVeRWOijr/v2hAPD1OO3/rMAPVkAnwFuB/dSoxhh5xJQLqnLccaQzjxCIcdwGUzSFWNQjx6yDk+cWy1j3opeJMiAYkbZGv+D7kl4FxZpQl0NVcAMqV15fznSZsn8rZX75pbyP8L9KOZlpqjquCMxeuGl+o8LIdNf9DJnlFi+iZ3mRoqH1iDoIULVUEUUmYDR+LX+m9tha5Zwtb/i+UWxZhEnrzfA8lkYRAuYpYyt5maQOw4EfgctXAodqUYJNtmnxsNdDbj2POc1njiwZifnPQY9eAAttiUnBPLKQBDyQYjJL18A1eKVHLPkg/j4I2pKBLQnfRqawFzBCsgHOcQcPpdC+SAyUt/1KeXRB7xzhJGIBQzeOlI53g+fLFLqujE+BD+Pcndy9rMe/mg7a3kO0FSE+/nnISLN0ZIucJNHtyx0DfFw6Nh58yL53XxUi3lrqKl53IwG+RLlmk1ZrBJIEa6HjVo3D9I852Wc+frg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(4326008)(38070700005)(8676002)(66556008)(186003)(7696005)(55016003)(64756008)(66476007)(66946007)(86362001)(71200400001)(6506007)(76116006)(66446008)(9686003)(26005)(316002)(6916009)(83380400001)(54906003)(2906002)(122000001)(38100700002)(7416002)(5660300002)(33656002)(52536014)(82960400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8o6UC5e1F4KN3F2MsUH4aZrnb34Vq4lB0Z5EikRxPrdyX/wE/K23e2AvXLiA?=
 =?us-ascii?Q?/aGnEGEDtDvppWqDnh0mil51pihYnd4g35JNxMm4Exvd4FTrLvnTxzzu28Hc?=
 =?us-ascii?Q?tDXbLvwLUs3piX93lNua+SoBKnEeK9iXdWdBldYTKKQBOklb6dmVhSpATZwx?=
 =?us-ascii?Q?0kuPMk3lkVgIOAdYmHDi20fxKbB+3hDmZAjq+8oUu4DgJYjBMQMrThPi2aDH?=
 =?us-ascii?Q?/YoKNT3zJ22Uv31034zlnrHbwOq6XDZKHxNF++LPOxOyQhunSURDaLpCnX3+?=
 =?us-ascii?Q?0bVwjhE0LVdeiCXf8yPizDYE6jduc2cQ1mNYFO0h+Tj8LeaF9+Rt1Yz7Ojdv?=
 =?us-ascii?Q?rChMHkqLKfaLEPfMXpERM9RKVWWTAsZGLVHHc08aAxy6tyIBI66gY2kAyO5y?=
 =?us-ascii?Q?2f/ALlG1HhmSzgqQmFDkDtbCjSC73K/Fkd3eKAQE3rNlURj+YA8IHeovB3FS?=
 =?us-ascii?Q?OKcXQsO5W+gjmUU+Cb9vrTizNdS4HXsdVCuk5wgubYqmLzXgm+MYxc5iF3IY?=
 =?us-ascii?Q?u/HQDMuY7EgYuV85Bh5gjxl3hGj3lz/tT/YqFQr/kwAnjiTyOtIj7bTNRXwS?=
 =?us-ascii?Q?6BBaJSNc2m5Wi0K8Hw9vfAGroZqvxKUqkJoN7mjI994s0+H5p+toIh/FGrJc?=
 =?us-ascii?Q?Jsyr/ZdCYxy5kmjFTg7LnS1agWJQrM1B29e5dfSODwuMA1BOvGlTikJ5Z7no?=
 =?us-ascii?Q?+WApmBBOStmVCQzLtQPJ6gPUDsqempBuQPzoI/z6eZFPE05UHQuXPMAn6yLk?=
 =?us-ascii?Q?XnzymYAr617QMZtnVyRExVR+dt4jZ7EJ142aCIrxObJz4rB/B6Oh7saFr/A0?=
 =?us-ascii?Q?w99zIc+WTtEjdkYMrKxsLPWCSX6Yhf53YgC9r/mTi16HI1GWY7LgDI5CbL2C?=
 =?us-ascii?Q?uoJ430PsXD168+FsLCXYjF1YokD+WLtS7eLB0RQ6qh/gVWEdey84cFhobQ35?=
 =?us-ascii?Q?E4CHZCa4QeMa0EYwGhp4/pyxzDiEw3li9vh64rRo/RGsiwRFPwuIlUJEjs9s?=
 =?us-ascii?Q?izkXZtdzBJChiuFQv598EUJ9Nry6N02cLFmcPIj60ajeZNbgTwGujpJBC3FL?=
 =?us-ascii?Q?2sRjQAY4E8OfQWf64qsq/Xe172BB9sxzG0xYNro2noVT0d8mn2Kd8/Tgv/nO?=
 =?us-ascii?Q?a31ClIdRy9XSxk9Y7AJZXc9ZdkaN447h0WAga1CnRl5AqGNvbiIj1w1KzLWy?=
 =?us-ascii?Q?dVHL6NQU9EQSwbUHpsa5H06A4D4MCj8iBjh20K4GYKGygSa7QpGA+GsDum33?=
 =?us-ascii?Q?ueh7iqgK9da2100r+OgNnc3Mal5peC+LkXRHWtnlsqMiRHA4syebWA7VXaoU?=
 =?us-ascii?Q?pvPe32DigprS8/2lhz+clJXo+Jij+xpQ12/+mcUCP8v9KT0tRr2hcm499Lgh?=
 =?us-ascii?Q?QME/OBFNK/dcyivaHQOS8n41qlOk4zTjU4D+bD2TONw6z+2FagDxG8L5J/y8?=
 =?us-ascii?Q?tMDQX7Ph0+uhxCjYbcBta+UAt4+ItyowXoZFes1l0fglCQ4EEsgLbICV48cJ?=
 =?us-ascii?Q?IWSg3hI6na8ytyVpxHsoVtIOYDET49rn0uSlQuoho4v3+jhNW4RpDRqOJLLC?=
 =?us-ascii?Q?iVGJyCYYxn4kyhghLwbGXi7eNX6UhBYqXibbFPNI8shcEhi2UxvSb3EHvDgc?=
 =?us-ascii?Q?c7SP12WYK2rby+/0lla7Tpg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5b1d32-d3dd-4afc-f8a8-08d9f0f8fb58
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 03:04:00.7682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZcymsvaVuLWgB0i/8YQY8oolsteO+9v1syBm5GZMZ04oS6sAEtGUWgQjf2tAsOAwd/qSR+CyhJxHfsDm8G8A5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 15, 2022 11:34 PM
>=20
> > > +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> > > +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> > > +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> > > +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
> > > +#define VFIO_DEVICE_STATE_MASK
> (VFIO_DEVICE_STATE_V1_RUNNING
> > > | \
> > > +				     VFIO_DEVICE_STATE_V1_SAVING |  \
> > > +				     VFIO_DEVICE_STATE_V1_RESUMING)
> >
> > Does it make sense to also add 'V1' to MASK and also following macros
> > given their names are general?
>=20
> No, the point of this exercise is to avoid trouble for qemu - the
> fewest changes we can get away with the better.
>=20
> Once qemu is updated we'll delete this old stuff from the kernel.

sounds good.

>=20
> > > +/*
> > > + * Indicates the device can support the migration API. See enum
> >
> > call it V2? Not necessary to add V2 in code but worthy of a clarificati=
on
> > in comment.
>=20
> We've only called it 'v2' for discussions.
>=20
> If you think it is unclear lets say 'support the migration API through
> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE'

yes, that's clearer.

> > > + *
> > > + * STOP -> STOP_COPY
> > > + *   This arc begin the process of saving the device state and will =
return a
> > > + *   new data_fd.
> > > + *
> > > + *   While in the STOP_COPY state the device has the same behavior a=
s
> STOP
> > > + *   with the addition that the data transfers session continues to =
stream
> the
> > > + *   migration state. End of stream on the FD indicates the entire d=
evice
> > > + *   state has been transferred.
> > > + *
> > > + *   The user should take steps to restrict access to vfio device re=
gions
> while
> > > + *   the device is in STOP_COPY or risk corruption of the device mig=
ration
> > > data
> > > + *   stream.
> >
> > Restricting access has been explained in the to-STOP arcs and it is sta=
ted
> > that while in STOP_COPY the device has the same behavior as STOP. So
> > I think the last paragraph is possibly not required.
>=20
> It is not the same, the language in STOP is saying that the device
> must tolerate external touches without breaking the kernel
>=20
> This language is saying if external touches happen then the device is
> free to corrupt the migration stream.
>=20
> In both cases we expect good userspace to not have device
> touches, the guidance here is for driver authors about what kind of
> steps they need to take to protect against hostile userspace.

fair enough.

>=20
> > > + * STOP -> RESUMING
> > > + *   Entering the RESUMING state starts a process of restoring the d=
evice
> > > + *   state and will return a new data_fd. The data stream fed into t=
he
> > > data_fd
> > > + *   should be taken from the data transfer output of the saving gro=
up
> states
> >
> > No definition of 'group state' (maybe introduced in a later patch?)
>=20
> Yes, it was added in the P2P patch
>=20
> We can avoid talking about saving group here entirely, it really just
> means a single FD.
>=20
>  *    The data stream fed into the data_fd should
>  *   be taken from the data transfer output of a single FD during saving =
on a
>  *   from a compatible device.
>=20

Yes.

Thanks
Kevin
