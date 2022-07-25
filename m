Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFAD57FA5A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiGYHjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGYHi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:38:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A6D12746;
        Mon, 25 Jul 2022 00:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658734738; x=1690270738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ucL1sr7CsDmSCNTnQqz6TdbIpnUnHe4gA1TMckVUqBI=;
  b=it6mQnLx6iqavs9cm4EAyfsZ8KI5nnEd+XOKh6wOruL+AH5d4Nu+qTNW
   Raaem3vwFN4i7ongDGtX5kBEK6MpEn3et+Q2U2FZD5WbIF/CbgMWO7jEd
   rJColo43oFpBXlfj8o73XSenHeIwgVxVAkRZUAlH5Qu66UOr3T1nHt6mL
   uxZupumGdmBklOCkiqpHVeSdGllkplA8LAweRm7ApHaYeTzwm7gicm+I0
   Ki0+NDn04uabGJttkEwLRcRDwNo41u9ZHsYs0Mkh8jmQhQBM9XXpRPyY4
   M6KI1epOPVgh05R9RhCx+FBSG8uu1gXY2/DcxBWZtCu/xw8oF9K77WgX7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="288820061"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="288820061"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 00:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="845415871"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jul 2022 00:38:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 00:38:56 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 00:38:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 00:38:56 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 00:38:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL/A2fwfYn9PIEdmMetXlVyzKwk0n3NoyGqFETyQiOd0Y+iv3WgF24YLjhbw2Fle92Fi7lg8QBKK/g8TUsuuw1pMDox+WXSOML9c/hAdZ+Ph219FmPZ3tCZ6LZDY0DZxZQG0KuaOM656AdTLWy/QyRoeyjc/hqOMlYqZk+408XEnxuQhn/n1czbsWcPPmg+kuyiZXOgvCa1A/+mwK6k+fQIIulsmkvk0lCVH66CjFmKzt6zWpQ1k5cJEQXJyaJplg5hpD5eVVzYWCmUrvA0u1wEuV1BqZBFCT6ab3in2faWwfpRI4WR4iO4Gq/VfYvfWb1Q/iSrLz+kGyXu1v7/yyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bO9gwPyLLODd+Z0EJGFmHNHSTWfg46Prm6JMNyBxcw=;
 b=RIj4dJmsE5Sz12YsHPcOZfunGOf/LVI67dMo9HuYIPpwEKTK5NygsflhOeuiird1yBws3WCXheCxRL+LFMdWRauGjrmLlQ8iwTEMCR+zGZQYVSCCGNYRaVfU3reczuVqmdDNuz65D9YWSuNx1QQXKgtbs16mOWq9oXIRoa/bAs1FiQx1fvv/5lTWyiY5RUjR97cJU2uHHIUQMSaZf5BcV1xx09cufVKRJdVPqqRfw+W+RwTQb6pzWqQxddVHb37suZ63pLUK6WpHDsqI0c2a4EnSDxfmZlHKTAFx3WNJh628iP1k1nNed1dDtCYT0CKlwiMgBXc4rogD3yjterhfBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY5PR11MB4038.namprd11.prod.outlook.com (2603:10b6:a03:18c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 07:38:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 07:38:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Thread-Topic: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Thread-Index: AQHYl1nR/iQPrmnWoU2t9zhNVHHxZK2EvT4AgAC1VYCAAKlDAIAADBGAgAJmxqCAADLPAIAGARcw
Date:   Mon, 25 Jul 2022 07:38:52 +0000
Message-ID: <BN9PR11MB5276924990601C5770C633198C959@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
 <20220719200825.GK4609@nvidia.com>
 <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721115038.GX4609@nvidia.com>
In-Reply-To: <20220721115038.GX4609@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70de52a0-392f-4dee-2f3e-08da6e10b8ee
x-ms-traffictypediagnostic: BY5PR11MB4038:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qn4ucakkFyOGpQI4KFE34CU3R/qzaCp+5/5eqYe1B/6Mx5Et2/DW2c5NcENiDxn1x3NtLt4PXYCh4ZRd9YegsaLpOJep75Xtx/o+UlvbGHst9wRrxz9vLdt+Ap6wVFjsQw7l0BJv1oryZ7ZkmJ9J/XhiEyvwqNoiK8+4gK2W2zcyOnDiTt34me6FD72wMpDCR01I81+dYqAdbUc/4U7prwdhe84x7Fq2/9+52M36jq1UrPxnWe/M4OfN5kPSRqNBel9vCl0Gkm+Xf6RqeMt84LvpDnPNSgrzNHAqn923CEHefRRds79bG64Rn2FfT25wcpegxK3IuEjenAj+ozPpAuOG9TbYtVS5RYtwgJVpLRRougKi5g/CzvwNEJCx/A3FCg8dwDHxo+Yn6miqUEEU9JU2Xhos4GNGOASKYpT3p5eub8IrPYqnRyHnyiItqqjLjfpJBU7fVVT/CThizKIMZKXG8zVCGaR70OJAoclcuyhVmomwHOY8c2dQfLtmvGu4BtcIZ/9B2yTsISBcai0P1/BGS4R+VMmqGztLiLNbqkJCQDvsL2afEOBWUKCu4hD2XMfx0qoaCP0d79e413L66p3PHbpSjZLGE3TlAHQRrElU2sOb/vBYKVrmwWQ1hQXM+JLMleKWSkY2PNOPWweHZwUqJNUS9g6hh1kNsqvALe2FIFvN9rLo61yJduJkTHpwOwHZBdV27tbj/+aLY+/QW1l2399FQds4hlWvmjIj6Opo0vrncoQFAV5rL5YwBlhl3yddvChV3SN39TQLx6u6+8k5Ymb7NKPzOzNPALdcAig=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(376002)(396003)(346002)(478600001)(86362001)(54906003)(6916009)(41300700001)(7696005)(6506007)(33656002)(82960400001)(38070700005)(9686003)(26005)(316002)(186003)(71200400001)(83380400001)(55016003)(66476007)(66446008)(64756008)(8676002)(66556008)(5660300002)(52536014)(7416002)(4326008)(8936002)(76116006)(66946007)(38100700002)(122000001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V51nmKzVv45ahxQEUo3wDx0IWlY6udBDhk88farYso1m7zeQbTTtUSzuduG1?=
 =?us-ascii?Q?H8LzKDOPwvOsKXUrIefc6imDMAs6VZ6BuIeXFDP7WxlYIcNfQDNDXkemxWs8?=
 =?us-ascii?Q?7q/Ou2Xcox331snpzKxfwHNdFaU0n5zmZqxCzVZ7I3wTKh2J096BTUM5xjbm?=
 =?us-ascii?Q?GOWuD2hjI+u4VFpymZKSZXmsuF9ysP30CS26QzfNzSboHjBjqkb5g1LgsKn9?=
 =?us-ascii?Q?1gih8h7BofcnY/9uVlrudl57Ko6MWZ3GXsb5Nm62fb/smUHoVid9aYoXbstc?=
 =?us-ascii?Q?7s88Lcbb0e3qA7zUNI5bh6a/8l29UGvX4Fo95TUrkgD0zIi8PbMSbL7bbAeS?=
 =?us-ascii?Q?bNHddzRmfYeLAK2CX7EWuRv23Sb6dj4HcKaoD0Hl/2ofPsLQ35IICxGsR2Pp?=
 =?us-ascii?Q?xYA1JAGXHSBLnJUUmAuLTQuqclrcxzLMk9nT1OidPKpUZGqBCkJo3u7G8xa5?=
 =?us-ascii?Q?m63/yZgUfHZ6mAeLwl65mSPJsWMp96Nyi+xWbkB+OHoqXKuty0LYqFZRmGOP?=
 =?us-ascii?Q?WTTVaK2LMKjNHaBFhPdLaHFGwy2GQkQEtajZnFT9ZbsXenpXfSaqsmCEHIvE?=
 =?us-ascii?Q?AryCOKHvww41m9sFTwOqpzFcQ4H94cGi5BsEBkEDyD72QQw+b94FNLULPjtR?=
 =?us-ascii?Q?qDKochlmPpuhC0DJlW52PW8NptI/heHm7ScGi2LNvKu/+7n1caeciptIaPrs?=
 =?us-ascii?Q?E8B+9TwiervRC2RbBpDEGh1jo8NCDedbY4NbiCpzieBD2wM9KZIIC7mZA2Ot?=
 =?us-ascii?Q?8007yMon/lb2ekpQ7xdZF/aThAFPyhnfieT1S4RmvxNTTFYd9H+KDhTH0jYz?=
 =?us-ascii?Q?X9WbjNyYPsSjyrLe9shp6Ji6oePPMDqbpQmSpkuosSABf0VO6jYd+W3ydsV2?=
 =?us-ascii?Q?3rD7LY2iauoKHykceI4EWFQE2XVlhxcdEbC7x12Fl2N888iW4OXFabmEmlDM?=
 =?us-ascii?Q?+k7HKzeUpLdn8VU8ECj8xXtWbMNmyCaIdCxK7d1KA5QoReKCAGZFuFoWt1Ig?=
 =?us-ascii?Q?19otUpdy+8Q7NjAx8x+MdpVf+37QAoiSbwjXvH6mUgxScoeMGkhHM39OGQ1e?=
 =?us-ascii?Q?mEaCNGHbw4GkbVsNkPwTYj05eL3JeQvGzpOWfRziUgLr2tP4qowE8bt1568A?=
 =?us-ascii?Q?eO8w9YWP0L3d7KEWg/SHSO7ZMDJPCrWAxbhdTszuv/nqWc7xL3wkwXOpajMW?=
 =?us-ascii?Q?TpJcaklQFiWqPeS27M6BynEYy1FL5AsUtL5B+xyDjPDyxI/7L2X5PCxiOmXV?=
 =?us-ascii?Q?YKuDcScvJXcDO0GuDSg5tkVLW25C0m7cWLC3sHfwVNTkg692WN6+keirIUEs?=
 =?us-ascii?Q?E450sI9nM0B+uTRY0iPc1dqtZDBYCtHhDEf6tTAFxjEUK+h/CHUtSsRX4iLL?=
 =?us-ascii?Q?YKOsuvXSSuAR0ALiopC/5QhUKz2FTGlcHepsHDAgeZk8PqrwzHmb0WL0lezV?=
 =?us-ascii?Q?3nXhN/6Jap4PzTDPg7jPN4g/m8Yz918wRIwNaSx0Uif6psegGImGz8aeuwvN?=
 =?us-ascii?Q?Tt5K3oHqpMdUIEZI1Own/tprl9hflsNmGP5yAm4/n6g76Hez5jDlkBXUeQDZ?=
 =?us-ascii?Q?IroNjX9PAXyjjHBbeDxbNTnFWVXjXUbWpwfZoBtq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70de52a0-392f-4dee-2f3e-08da6e10b8ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 07:38:52.7026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U7HUAOtPd88Fal3vFT4NLS2EuCmha0+HWOWpV1XUAuYFbjXum1Lqp1iI10Pqw8nT5OdhsDJzHPc31rG1vSGysQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 21, 2022 7:51 PM
>=20
> On Thu, Jul 21, 2022 at 08:54:39AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, July 20, 2022 4:08 AM
> > >
> > > On Tue, Jul 19, 2022 at 01:25:14PM -0600, Alex Williamson wrote:
> > >
> > > > > We don't really expect user space to hit this limit, the RAM in Q=
EMU is
> > > > > divided today to around ~12 ranges as we saw so far in our evalua=
tion.
> > > >
> > > > There can be far more for vIOMMU use cases or non-QEMU drivers.
> > >
> > > Not really, it isn't dynamic so vIOMMU has to decide what it wants to
> > > track up front. It would never make sense to track based on what is
> > > currently mapped. So it will be some small list, probably a big linea=
r
> > > chunk of the IOVA space.
> >
> > How would vIOMMU make such decision when the address space
> > is managed by the guest? it is dynamic and could be sparse. I'm
> > curious about any example a vIOMMU can use to generate such small
> > list. Would it be a single range based on aperture reported from the
> > kernel?
>=20
> Yes. qemu has to select a static aperture at start.
>=20
>  The entire aperture is best, if that fails
>=20
>  A smaller aperture and hope the guest doesn't use the whole space, if
>  that fails,
>=20
>  The entire guest physical map and hope the guest is in PT mode

That sounds a bit hacky... does it instead suggest that an interface
for reporting the supported ranges on a tracker could be helpful once
trying the entire aperture fails?

>=20
> All of these options are small lists.
>=20
> Any vIOMMU maps that are created outside of what was asked to be
> tracked have to be made permanently dirty by qemu.
>=20
> Jason
