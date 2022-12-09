Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46720647B9C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLIBue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLIBub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:50:31 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31BD511ED
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670550630; x=1702086630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GzSK4mdZwHabrGZ9vvHLLYnwQDEGEy4/RKv6F1u3ZN8=;
  b=PMftW1yEja/zUQ3xlLXY23jGpdPQlUEIFf3m1L70RGHYDEtuG70Iec8a
   30+x67kckSssF4634d7Y9xrjwwJApcL8dZHxPpVk76/DIId3+8vy77P8d
   GrDwA5nmQQbtCeEi3S02I7FP3pyGgXoXFhJvgkCo3OB9m6kGHAIvgfLcJ
   OBDvPHU1nL+w06RSE8Nh+G3N4FjmQKTDEax2qkBwU/Uxgxub0BuXMAZUv
   g1B5dmIE8lK96vw6kZBv5nfMOGZ3H9Psp/AXKqgIFUmmMozq1fhrtgwwC
   keKAmPTlFeHhj0guHR+qoXqQghnRIBM53swIElt6DNxfH3rjIyge+duyF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="297708741"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="297708741"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 17:50:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="789559370"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="789559370"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 08 Dec 2022 17:50:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 17:50:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 17:50:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 17:50:26 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 17:50:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wbykfmr/dD1Fnbr0VVyZRSUvbbUjLiQ2hm0p7QbUN/MgDAHMF7JLCTwok2sCSY83wH5wSdDr8ICVCjEH6nlloTd1dTkSeDj439R3tQn+3KH3TJ4rRmWDtfvjmc6qP9FqjPE64tu9eMi91EocgFPRA7k7+ojTSNjZm4HgXoRiU+SqMN7Gvf3joJdBf/0FvhX4eH9074l/Eg5m2x4+Hjxw4dLBnKEKLPMmIkOFwklV9xW/VUifz+6tJpJRCYl6H1ZREAZY6QhZi2I2tmb94n3MXXRlsHFBFycUxiCeogU3XhQFRVv/v3IfoaRpBlBCGrWNjtuod7wTn8UVlXCmcUmSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NRlK7viYgHwelGiY9J0L1G5gwTa42NYLU1NF386n68=;
 b=Tb5Bjt2cLge3RCTgCZfxd58VsyPN1JgGLlb2pS4MLeNzqhgUkhfT8/c/L3YhvFNZLh8WhATE2bQGOrr+5VzYqIysb1RB6S+mMJeI1kQK40SqhCN0mAb+pClHv7tV1QfstpvYG0rRbP0Q06N7C+hR2RIl8165yuEQc2CIckZnPW9aU9usw+59dmdmMElI5jaq9EdWgy5Fw4TzPB4cxieGmq3AJKsiKypCZMNf3oROeIDpurOZcT8OPI/VumFKK82l+3pCpJMCVYGWkNmAHD6XbGZ+G9Rn/DJj7KvfGpSMxlb52Ws7++0efw5syBbXVVX8pPnHGIbgMe9q0O/dsqoMmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 01:50:24 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::8923:42c6:513e:a331]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::8923:42c6:513e:a331%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 01:50:24 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Tan Tee Min" <tee.min.tan@linux.intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: RE: [PATCH net-next 2/8] igc: remove I226 Qbv BaseTime restriction
Thread-Topic: [PATCH net-next 2/8] igc: remove I226 Qbv BaseTime restriction
Thread-Index: AQHZCO/5djUJjRa06kqPaVTN32Vnl65j7z2AgADel4A=
Date:   Fri, 9 Dec 2022 01:50:23 +0000
Message-ID: <SJ1PR11MB6180F185A881FD0E48DD2D39B81C9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
 <20221205212414.3197525-3-anthony.l.nguyen@intel.com> <87pmcu13mi.fsf@kurt>
In-Reply-To: <87pmcu13mi.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|SN7PR11MB7419:EE_
x-ms-office365-filtering-correlation-id: 56788580-bbdc-45a9-d288-08dad987bce2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UaWPdrWVK9z7wrDZHv0/nI6p1prnmhJIBBpJ9JYKsvg1oVqxbPMmU0TlZblPg2oXp+Eg668igQYLBFfVlK59wRzBleOe4OfuipMGBGBLDCuPSds27NyAtFvfH/Q2A06nVLhpnYfRGLn1OecaEute+G5P+lexJOxasAnflNkUkoUldBV7UV8zmNFSVat7A14kAbSAhrBeqSQl5P01YaUs2cNAJ2PX0qr+IHeHaDoXieRGo7e08lw2x0LP1tjbP9RaFan0l4HsgZd0S44kYBfACXQEEdU9iqnbly6WxUC2sZijDvAtre03Uwyq968D0ra2UxJWLLggFusG71ZLut5dUJ6LqS6rpolqnio3veZ0Kxc/kbkNX0+6LpGiLZx/kMjSyvPpzvVgXyT8OUmFqnXU4JwuAtdUwRwyYHhrUpMYp8fJn6zj3eRRy8PPaOQy/b9cCtdC5xk2hHLaWVvl7pW9f9Hrd6LLAVsat0ax21JqkNNwkchsfivI0WOFu8/8wWc5g+9pEUbYYcrqa0eEKokCOpVHEy0+VY7PWymO4q7XUnOdMP0DxQdFIFDCB+aNft2mydRhKNHiyQRQebWFggPena0O4miezz6ShWPaG2gC1c0ZIrZZMOA9EWGZGkZ/v0SIAWCNHALTLjzWFeoi2zMinoiELWAF+pyhkuKVKNuUzqtAUB80Xmsg0nr2n7m7e+/B+hqlp2RtWyFiP+qgVyhnUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199015)(6506007)(7696005)(9686003)(53546011)(71200400001)(86362001)(478600001)(66899015)(26005)(110136005)(4326008)(54906003)(8676002)(38070700005)(66556008)(66946007)(41300700001)(66446008)(186003)(64756008)(52536014)(76116006)(8936002)(66476007)(5660300002)(82960400001)(83380400001)(122000001)(55016003)(38100700002)(316002)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Re90PKl5pBRaTd8cplXERYVF0yerlvMmpHTBuxLPPKpc+m22S/zNUKLs3QRi?=
 =?us-ascii?Q?jW9988nQmzN6rmMgUxuEfQ84A9z0PitWHlaunyz2xnPnwaGyx8T7korFujUx?=
 =?us-ascii?Q?JaSy4ayy3WLK0jCviJb60J0TFwaALq4rmrgt8wGs9PCCzYK7ZmKbEsrLEArY?=
 =?us-ascii?Q?Y1P8rpyrLriJxwzqvRV5ZECYJCBlbFwfVWcA8OOGfzyq+HnUqQzjjhDXYown?=
 =?us-ascii?Q?Q+uJnOXz8wf8PtaJDTvoQE6FcAfmi6UF7Sr7w/jZysDJNGn2Sc981sK/n3/r?=
 =?us-ascii?Q?TWs9STCZDy2mBmIstIP2OA6vV00NA+4l53Pm8lw1LIg3Iz1cpHUhwFY+Dj3n?=
 =?us-ascii?Q?RG3+VbUShAJio12PVmUw+mZasDxr+q1vkExY50AFOPPprkdc5N42STL0Fioo?=
 =?us-ascii?Q?uGVjXZo1Curx3FurdCwm5Z3XA7CgKmttS5rbBt+htUpyGb2XLiTEAZpPre36?=
 =?us-ascii?Q?zn3X0Tld4qXZt4zqL4fmfBumtaZxJ38J6RnKV6XsEdXDJJlwM4kHr0FjsfDU?=
 =?us-ascii?Q?jfFlSV73fm4/JXl0jgXAsDsxlqm8//xf1fxTKzYK1FgxumLHezMM7IDvAzt6?=
 =?us-ascii?Q?AWV4695BnTBpg/nDkWdWF3IMZqsb3z8P4uDDwxW0XVlS+s+GOdCQQ3ITJZuu?=
 =?us-ascii?Q?MncG5cyaW2//1Al7IKds4o9rertuVwnGQSfexiC31Q5W5pxC4G9PNBxSBvkV?=
 =?us-ascii?Q?DlFDa8fgbzteTe6pTvQ8a5bw07cWGcKPcbArXZK8MvrkSQ5YESCaK0vz/ne4?=
 =?us-ascii?Q?lKQ8PYBArYX0c0gCBJbntUFbRemOKF7UwRAc51F32Lo2oEYqNXGW9/jLXF7Y?=
 =?us-ascii?Q?Ak4fyI5eJsuWYV0LXHGXS4alusY3+T9LLD9/6Osrsjr0dlFIrXq6wex7M7bf?=
 =?us-ascii?Q?2wcxxczshiD92tH3LvHUg9x9wl97/WOrfruOUlAvO3S97zTLl0ok4TMnBJG5?=
 =?us-ascii?Q?ObuW2pgIfXMT9BcGlU4chil4g08/fduYZerNomWa4EfZb5bA6abu/ssqozWr?=
 =?us-ascii?Q?nqnfbg3/i8biAPY1SJJ3EYxH6syCjtWz7tWq+nxtPtnfJq8nZWFxQ0rsnO/1?=
 =?us-ascii?Q?YJAxtoeZS1deet93qRM5t/kffH9OxdbYAlVMhr1hKxjABLHf8oSEWbmHpYyq?=
 =?us-ascii?Q?7gSs6DD61/3NGibUqdoldhF2nNVcjXLqutIEWe4KTB9JK8rJhLzBg8Gd/RJm?=
 =?us-ascii?Q?/ua0yE0G5zcfaSLYiZPy40LOyeq20dT3X8vd6nR+jk4AcEEUy4/JuPwBxKCd?=
 =?us-ascii?Q?jQlQdFodolhcS6XccuI7mYjnfVeFmZxVHddg9kOhYblKroU898sq8KODKvEF?=
 =?us-ascii?Q?6FKHBg/H/Hy2bUkHHlwlT2nRlOEku6NhtL8IK+FMxGVO5K/MOYi1eD8pXwsT?=
 =?us-ascii?Q?it3Pzm4DSTzE1yNtUndVRy0FXRUth18Nfakbo7TdnuSC3mgx30jslNJ72eBE?=
 =?us-ascii?Q?h6z+sU9Omh4ayy6b4noeSP7LjBGWJYwRPdmuak0TN3eZsLQNGicw5H++in4Z?=
 =?us-ascii?Q?KZycr2Xr+Udi9u5U/ib/AZME6FFJa9zSbAUOW5J8X+hp3pxfb6oqrLIq+38C?=
 =?us-ascii?Q?kftOLCiYQFWmvDUuhrYTaw37hG1KCUEPgg21krKYC5RsZdu4HkS4gGPzY08o?=
 =?us-ascii?Q?uJdgHb2F6Tc9PeRzPHvN+eQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56788580-bbdc-45a9-d288-08dad987bce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 01:50:23.8828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qf68dvu1L30sc5FL3UqTg1aa8BXE0abMkhc/xA1XtJi9hJGQAILYZXtd+Pfrfhkjg0gKJk8v0eMmqed2teNftQzWRKjYIvU1GRTfBAqusIbImKDwD8jPtC/KrBVJDssm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

> -----Original Message-----
> From: Kurt Kanzenbach <kurt@linutronix.de>
> Sent: Thursday, 8 December, 2022 8:28 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com
> Cc: Zulkifli, Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>;
> netdev@vger.kernel.org; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Neftin, Sasha <sasha.neftin@intel.com>;
> Tan Tee Min <tee.min.tan@linux.intel.com>; Naama Meir
> <naamax.meir@linux.intel.com>
> Subject: Re: [PATCH net-next 2/8] igc: remove I226 Qbv BaseTime restricti=
on
>=20
> On Mon Dec 05 2022, Tony Nguyen wrote:
> > From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> >
> > Remove the Qbv BaseTime restriction for I226 so that the BaseTime can
> > be scheduled to the future time. A new register bit of Tx Qav Control
> > (Bit-7: FutScdDis) was introduced to allow I226 scheduling future time
> > as Qbv BaseTime and not having the Tx hang timeout issue.
> >
> > Besides, according to datasheet section 7.5.2.9.3.3, FutScdDis bit has
> > to be configured first before the cycle time and base time.
> >
> > Indeed the FutScdDis bit is only active on re-configuration, thus we
> > have to set the BASET_L to zero and then only set it to the desired val=
ue.
> >
> > Please also note that the Qbv configuration flow is moved around based
> > on the Qbv programming guideline that is documented in the latest
> datasheet.
> >
> > Co-developed-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> > Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> > Signed-off-by: Muhammad Husaini Zulkifli
> > <muhammad.husaini.zulkifli@intel.com>
> > Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>=20
> [snip]
>=20
> > @@ -5852,8 +5853,10 @@ static bool validate_schedule(struct igc_adapter
> *adapter,
> >  	 * in the future, it will hold all the packets until that
> >  	 * time, causing a lot of TX Hangs, so to avoid that, we
> >  	 * reject schedules that would start in the future.
> > +	 * Note: Limitation above is no longer in i226.
> >  	 */
> > -	if (!is_base_time_past(qopt->base_time, &now))
> > +	if (!is_base_time_past(qopt->base_time, &now) &&
> > +	    igc_is_device_id_i225(hw))
> >  		return false;
>=20
> Nothing against this patch per se, but you should lift the base time rest=
riction
> for i225 as well. Even if it's hardware limitation, the driver should dea=
l with
> that e.g., using a timer, workqueue, ... The TAPRIO interface allows the =
user
> to set an arbitrary base time, which can and most likely will be in the f=
uture.
> IMHO the driver should handle that. For instance, the hellcreek TSN switc=
h
> has a similar limitation (base time can only be applied up to 8 seconds i=
n the
> future) and I've worked around it in the driver.
>=20

Thanks Kurt for the comment. I agreed with you. We can revisit this for i22=
5
later. As for now, our side will lift the restriction for i226 first as HW =
supporting=20
it.

Thanks,
Husaini

> Thanks,
> Kurt
