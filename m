Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE41C578FEB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiGSBjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGSBjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:39:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B2F37F91;
        Mon, 18 Jul 2022 18:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658194759; x=1689730759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m23af1RotvvSvsCVyKrj6JtoiFMuLBaDxInhY/jD2/s=;
  b=Hlx0WLEx+WqTBH6iDQCNN+abWIajGE9quusxvyZzUZhRo9Kz8NSkp+My
   RSisqG4Wr5vP7yxQkaDvnkj/2P5ds/BLGyegI5ZN5vDzcz/QfrhCZp5jE
   urSNCVpXRf0r9CJPn2Fb2J37+NQQwNBdJshj/Wpa/mMomoJhZm+LYFrKt
   q/cYyfidlKbf/wdNCE9F6/dr6+PSq9GOstSYm/jbjoBydIc2aenrTkyrI
   wqB2zuzNhWZ45db1b4BogvW3nxUH+ZCnCExtHm6vdkEfAVuxWF+dbKIwW
   ngLRDdgqW9QUrDV9chKMwNvguWmEtrjhgkh8Zf1rBDo2qvjGJTtaxpcSD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="266763586"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="266763586"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 18:39:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="572640407"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga006.jf.intel.com with ESMTP; 18 Jul 2022 18:39:19 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 18:39:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Jul 2022 18:39:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Jul 2022 18:39:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Jul 2022 18:39:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S63sHHTzORrzYzRh/sc4UXAu4qQvgPSH1NgTIQBJO6RTBfJeuctn7aZobkao+ZQK3xtPAM3/gt2bA0SvRpQPH3gqLbeOyMmIPt0AFWUdX19l6wmR1xrhs8uRkpWZZ6KhdBL8a7sDCQwgwftDy/GQ69GG3GHgAh2pGNz9bVhmfMW6F7YV43nKf3jq/G4X2nJS6fFR6Dfkq3lAa+NNa2KMWJpS0QdRr5ZnbslbH363ZIQiNw9wNYo/peFBv83NAEcQCH3s+kGCWjFj3DSvkFFQe3OWvN73pP/Dcc93yJD7Yo8uYhZIrqZh/zGRTEsN0k2czLk6wJVe5d5xWT1YsvTnKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQxtiKi4ZJwPTDvC7CCVNzMCZs/UEy5Y15DnTk8LNQA=;
 b=OVUOQP+wTRt61+sjl/nQO8850Xy2oQn8A7dXPb3blT3dZhqh1Lz/+GnWocQVQ/c8uMnpYWNHHF0QzxMLFjbeVJc4T26k7zd4m7IrKPub3yNkzzznxkeSFAjM8xfEuZ69NPAHTQ0uGOTudjIw4TX3yWbm67YwM0hUZDHVnsW/ywQ7kWiQSdiynp81w4b0ulUX/MoTlaGxVaGnz0Q4KOjl9ffT+KwaC2CVYV/rCT1LccnyUTgL0kStxk+YboM7r6lP0wRH3/iSFZUaY3k0VUlcpysB4c9uJa6g0Rdp0o6td0+9UPqXd1AdmPF/VoBP7Z6bZnagCEdFPco7OL1KxfgFFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 01:39:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 01:39:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: RE: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Topic: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62EvR2AgAAzBaA=
Date:   Tue, 19 Jul 2022 01:39:07 +0000
Message-ID: <BN9PR11MB5276B6658EE0BCE9F2EA52F68C8F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-4-yishaih@nvidia.com>
 <20220718162957.45ac2a0b.alex.williamson@redhat.com>
In-Reply-To: <20220718162957.45ac2a0b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08eec3d2-6cf3-44a5-deff-08da69277885
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wb8l+UBADF6RzqrvMqVH6T8YVI/TNLFWgMtvnDcv7vs9aqsttkJXntErGyhGRHXpdae6ata1v1v9aWACO57n3jvkmZiTq26LyHkthoOf9A4+anWjX9ARrTji34iuUTOUWIhIk9QNqBCnK8zZrzBoHfwqU9/sFn0cVxy+YLdVmjAJG5wx5n4XkfUfDa3GC4oQYkoSj4mMYVnI26hSFrHI/G2EiVh4Ewhm9AHb1XnfPrrK1StG2IaURB/nrt+3SVmqkr5sWr0+mbLpNky1J8Ti6cchDf4QmaBN/PJQG1l+/DwKt3h7oDAhfrgkzBaBykV1c41s06sotH0lcdhTnjkk5bTV8Yy39GcE29L01s6CaevvmAzdjUrKo83bZ+H9ou+gfJuMolIZEtWlafK4sm1i2lAiB1fkdE5kNm4PMsN1m9x21YFrnBJRlimbB2Dv3VWSugeTj0NzmFVQHwkf91At6BAc31ycWIcVTkEBSydtY8H4nozJcuhBfKdvB9AUuGCnZOb9zteWxFmLg9PwgqW9H5Lh4CG7JR2bxfY0PrZEinKzJPlPbUuYwS1ov2MW6HB6YgTHX5bVaFuOHVsbWq+tEUeSfCRBFwGXZd9d9C88QuUDCM4VqGsshIoSEYYlaOHzO7rnLmoE4poTdXWgAohiOL61WgnqngZvGG4kDTgiUznxbmGqo8de0g7orJ3olxU9Nu8fyAhdcCAzeJ/63i1uihAL3p7AkAhI+eNCSXmmpzaLBSn1wUMaSko/2/nuOVFVpm2xqcMhYyZl7VWbtq7FygRrrf1yjoH87WlPNsZHXOZEwGouya3wB6Xi3cHuFwp9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(396003)(366004)(346002)(54906003)(110136005)(64756008)(7696005)(2906002)(41300700001)(9686003)(8676002)(6506007)(478600001)(26005)(66476007)(55016003)(66556008)(7416002)(66946007)(66446008)(52536014)(8936002)(5660300002)(71200400001)(316002)(4326008)(82960400001)(38100700002)(122000001)(83380400001)(38070700005)(33656002)(186003)(76116006)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+JQmqXM1SvZgKkM/fV4/JqfhWBV8pTgQ/0U+rZhap92KLFgPfNWClrU1z1eY?=
 =?us-ascii?Q?gpvP1+TqB3HjmeFKx7QRFnx0A+NzRO5wedBEoZ7BHZdvg3GOto5QOwmUTGv7?=
 =?us-ascii?Q?JYUEvmR0MxubpIeSNPjsZlxN1gGzBgE5khkm7KCvqH92oQobK1j8va6UGFqX?=
 =?us-ascii?Q?6FhUrIl4g6xawJuhRtcDeuHXmpPnLWb9ok+kSxNqkhtDdBI5NnGAI9HV/t0e?=
 =?us-ascii?Q?fOaAX/9nBT2BxkD8foHRQ3ct1TtwAZiNLBDzHJk1B4DdBErTku0U23vb8yL6?=
 =?us-ascii?Q?ihxhdtWOEn7jle90LjT8dsYhixwMZq9s6IndPstHqYCfw8lyBY/C2MQaoPFs?=
 =?us-ascii?Q?t40mEZ3TcfV3L8AMoVNbHgaCefbdMEIOYHUO7QYJSpp8ugufH6sDQ1ZG9wD7?=
 =?us-ascii?Q?59qvwuqW/dZXejE9Xpqbm22hrf+64UASS4rwUhCyBQDRNEY7fk0JW63eoy52?=
 =?us-ascii?Q?Kp62x8UhbEtQ9Fhf8v5jLDRZx91t4TKS126uLiNV+SzLisUMI3GD3BVaa9Ei?=
 =?us-ascii?Q?9ppMGCI+Dhw7so1Vj6FmTfPWuLRq/d5HuoGY6nb9mb4wnM0dH6Mr5bGGnH4b?=
 =?us-ascii?Q?4vuVH2AysyJEKKbRuoiImn8wrB/ZdMVGvQC9MnJVkTZZ322gPptx6snYcu7X?=
 =?us-ascii?Q?Ayw+qJGPETdpcP8dZ8MrS/iJ/FfDGtYFm+y9Qfr+PstFHUf2X3kPbJgAfldp?=
 =?us-ascii?Q?3XrU+1MOZtXLhJBgSHP/KhPFaYCSMq20HBW2maHCsSFRaS25Oxa8qKCy6Rnn?=
 =?us-ascii?Q?3L3kGOmtb7+7hEHjPE4SttDYmQuy7VjPBWnjk9cHa8f1jOuFxU5nG8zzRsBt?=
 =?us-ascii?Q?N0J5JRSm8QdhUDRrvTHIevk3cy0QrzYReXlE7gMxP67YaOOYa1WlQfKKNM8W?=
 =?us-ascii?Q?XlLAJM744aHa47y1xg7VxMNU2yZcFlTTNWcmPbXeP1tmjpRKTPr+x8lvnwJi?=
 =?us-ascii?Q?uva1f7cRfTnY6QY3VtYamiqU6jbc1IofBkCmoBLHwtOBZ2C/GnvrVbtqLdV+?=
 =?us-ascii?Q?oHboUXDcW9yhfy2EbpQKuzd80SX6BlluIyVseMmV5FqO8WTe3MVTtPmtlEpz?=
 =?us-ascii?Q?wrpZiBSG74Zhx31D/Hxl33g+Y6wjHOwNpijlSZBKqaRd24pZTR2aQwXIVXeJ?=
 =?us-ascii?Q?dRMM4wC1ZFMcidwdayhlqQsscwL8cveg451vZ2UO8ngc4y6uEfgf639s6Y8j?=
 =?us-ascii?Q?LI8oYy9gIjHGJMtTwvH/U0o7MTugw4y/AktZlLalRV/hr1eym2lmFPqI8HY4?=
 =?us-ascii?Q?eQtjbzAsXrHGR1ldp1x0V0bdC2Eyt8ynm54Nb0gWeW9P3niQYYPEOky9eUa/?=
 =?us-ascii?Q?1GxWe60J81qBOzpxiCdmncsjzpkH7N/bqUCgeg/Q5yKAXNbkk3KpaBC0BN6Z?=
 =?us-ascii?Q?JesmK7AYNjZPNpVAfro1AWdToEmYVMcyHRFEr8CuO0Fo1PQaMl/Z/b1/7224?=
 =?us-ascii?Q?WYMr6dZ3O1MiyW8mr31HDp+SrUIuJqJ2AhFJPy9SXA9lIaaipi7/uzL17Imr?=
 =?us-ascii?Q?/3Wfp9hobL9jdRyFzqOoBd8FrIC2OQdJjCaiHr+4jQzDUkN2wZH2Vq2yLT1a?=
 =?us-ascii?Q?ry79DNYpNqzFyeZY02M9Kimm7VNoF/z6crFmnOsG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08eec3d2-6cf3-44a5-deff-08da69277885
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 01:39:07.2558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zfr7fEfPm3Egdh58Qs2ciivhvekJl3GL2FHJrTCjMV7WQseUKzOTpBcOgTL3d55rectD6SYPOYeLeXAxeZ5hFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3999
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, July 19, 2022 6:30 AM
>=20
> On Thu, 14 Jul 2022 11:12:43 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>=20
> > DMA logging allows a device to internally record what DMAs the device i=
s
> > initiating and report them back to userspace. It is part of the VFIO
> > migration infrastructure that allows implementing dirty page tracking
> > during the pre copy phase of live migration. Only DMA WRITEs are logged=
,
> > and this API is not connected to
> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
> >
> > This patch introduces the DMA logging involved uAPIs.
> >
> > It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
> >
> > It exposes a PROBE option to detect if the device supports DMA logging.
> > It exposes a SET option to start device DMA logging in given IOVAs
> > ranges.
> > It exposes a SET option to stop device DMA logging that was previously
> > started.
> > It exposes a GET option to read back and clear the device DMA log.
> >
> > Extra details exist as part of vfio.h per a specific option.
>=20
>=20
> Kevin, Kirti, others, any comments on this uAPI proposal?  Are there
> potentially other devices that might make use of this or is everyone
> else waiting for IOMMU based dirty tracking?
>=20

I plan to take a look later this week.

From Intel side I'm not aware of such device so far and IOMMU based
dirty tracking would be the standard way to go.
