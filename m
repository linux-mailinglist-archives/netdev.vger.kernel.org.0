Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D40C64F168
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 20:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiLPTIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 14:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiLPTIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 14:08:44 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9285424086;
        Fri, 16 Dec 2022 11:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671217723; x=1702753723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QWImjAo/WlOSrZp7oZMpmoLjMjeJZ4fiOQ56WOTLZAY=;
  b=eg3cASfQzyDyQ05V/HkUScf9t7QbkswY5PVcl8CEzaUznjXGUbDKLaXT
   eBk7/2SRRs+oxgAPhc/knB8HXj/KdV2aGcD7+rgMOh2GYauZ6wt8zePuj
   Upz1PkUtRjsrnf2q+yQk6tDeIWd/V1jAhaifySuNsxx1495ij9eFaEOls
   R2npQUUZeIkuwYrNdOSLu6K9fC653T9WFHKiWx2wIXeP46ntIoCGGlxaB
   9rWwsK+wYSJvrGzVOdcoXmBwvA43yLRndJeRVFv72prhKSxrp9f1cl4I1
   nq860sGy1v6kzPDcMBmakqDYDaLRqHAK3xyI4pUdwfK4rRh7hdke91eNI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="346121057"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="346121057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 11:08:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="713359838"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="713359838"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 16 Dec 2022 11:08:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 11:08:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 11:08:42 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 11:08:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWNKZagR2xpqVeLOFAkNEAFhh/jVkUw5U02t/53B1IVwA4Gks2RA2apuL+f3NCPikTWk4rT2R+XvdQODRHHoGwB76NP3+MC1fnEcdfvVVeBC7J0gDfRL3N+kcHRNOQ50YbvAbLmdy5ZZ4TiryERp24zMbNd+Z+cpy1hBxesj6W3wZCOIlDgpaLE90gkrAtXNRDox1l+XMlP+nB5pd+TTUHZy+UK5CB029AtPZ2VhD8VlhetjyJuqhF+FGYbvTvrPFTcxsTLmcmIFOoZVfOPcelWkreGgfPrnyBL7oJgnAPDxknT4B4NZMOiTtU/gkvXNTWH9Z3ObjoQJIfAKlldQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTxEkiB1YUW2/yXSU578oL/qNZ2teIbVSgZfsxUm3b4=;
 b=lKsGPSg3G4tVpror57rxIRNZG5JLkKMHmpB8gxa9GV7eOvxwQc5AkL2tY/Vo4sH5DN6Zqphfj+/SF+prQecPC2O+BDTeIqJXqBHWHmFdQJWSZPZ5/NSPtF7eEx/7x+fKeDRUmVyqT3b29y/9IjH6TxOhUjSTQwBQRLWHhIVF0uK66kU2WXp5EhdOWM3GGEkm1NIv9UStLBxAwI48jFQCBAJzHnqnGT9TqV1JVFb083wcWff+RJrN0ceDL/eDwW0I1ip7No1jEE5Q4zH5MI9X1gOY47SEL7OgGbR+TedejZqOpKNlWOhqrkQTB2ULs/DxwzYYhPRthVqCzc5ZeKRJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by MW5PR11MB5762.namprd11.prod.outlook.com (2603:10b6:303:196::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.15; Fri, 16 Dec
 2022 19:08:40 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::1bdb:fbd9:b48c:6e6f]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::1bdb:fbd9:b48c:6e6f%7]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 19:08:40 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net 2/4] ice: git send-email --suppress-cc=all  --to
 e1000-patches@eclists.intel.com
Thread-Topic: [PATCH net 2/4] ice: git send-email --suppress-cc=all  --to
 e1000-patches@eclists.intel.com
Thread-Index: AQHZEYHOy+hKKl+u/E6HK+WKXE0xdQ==
Date:   Fri, 16 Dec 2022 19:08:40 +0000
Message-ID: <MW5PR11MB5811C4226F1402FD29EC96CEDDE69@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com> <Y5ES3kmYSINlAQhz@x130>
 <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
 <Y5OMXATsatvNGGS/@x130>
In-Reply-To: <Y5OMXATsatvNGGS/@x130>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|MW5PR11MB5762:EE_
x-ms-office365-filtering-correlation-id: c3e21d68-113d-47cb-737b-08dadf98f16c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nND0kUh3voZ5zSW1CUyE3gYXA7/JYg7zCqD9LkoPkxBaOX92SVV/1KSHyqSH1WNZ1X7CE1zy8rnBu96yFzMHe7bimr/3spyLdYKFwi8agiNRcwsYFhK2qlmS6bZ3VFeFEKeu0tmXD9Tf0QYL0mkbaN9QjSSeqIc+MTW57DrNz1WcfoK/rXn7ZVBL2qAn2kpn6g5ItCtxrPzS6YDuwVLJdSKtsHmaSvYtucfNwGul1rvLry1gRLBGD17pmLnisFjrw+gdQcX/xBuTpi3eFsYpnnaWLw4wIeBeQ4Fjy0Puwu03jDY/jaMmGl/ah4of1g5iCMNsnwkBTKioLCcMy1e8th7WYeoPg09VPYc6s+rGwscSDbVpP2979QR1BtJAZE4acVcZ/brEv6/ywkOCIWTfNR7ARri6xNNAc1cHOuckjEb5Jh6bKuCpwnEPcMfwDXfaTq9C1v+Elo7OniacS+PR+W5d25TbRemr6w/g/6iJC7vglEHmbTH8XxhrlckmWU6xd93UYNyhU6Fahg5rY/5FNN2H4nLDI6EmLvjYdDLwTAVfILKa9Oj3st7XSFjxDmu3u91n2XY6wYTm/J0h1TNuN53IJ9je4ja7h6q7AFnF8W0XqGEZzwp3eSeaAvHMCrmu6sWms9zm2KDAT93UdITMprsQMpNpyLF5mNejW0ITtvRmS/SZcnfb1d5hoXZztvgqIm7TcKe9NsHugBk+5kYsaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(33656002)(52536014)(41300700001)(8936002)(4326008)(54906003)(6916009)(316002)(66946007)(64756008)(107886003)(8676002)(66556008)(76116006)(66446008)(66476007)(83380400001)(38100700002)(82960400001)(122000001)(38070700005)(55016003)(71200400001)(7696005)(478600001)(53546011)(86362001)(186003)(26005)(6506007)(9686003)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8BwkoVudHRm0m+9Y+aS0eKs44g9lnCAFLdf7N2VP4tZ+54Df4z0gUZTr2OEj?=
 =?us-ascii?Q?RZXiIwiNMoiKvEO0J61sLBdk6DP0PeJHqOJa4ZZA9ndgV20VhJEOEkDPsUav?=
 =?us-ascii?Q?KEBJ+UsWShCNWGa8cTKVxkj/fvGYaYHq+7vE+xRrTFSPbMcSDh8uvNchWp63?=
 =?us-ascii?Q?/EmVKbTox42w+PVIdiiZ8Qizu3GqpUDSN3/0EPQSNAtSzBoBJgNRFNwkWCJu?=
 =?us-ascii?Q?NmNQIKGR1Riqi2s0m5HPLaRbCof60al1xbmon3kwFiRLksmVXgzX+q5wyxa4?=
 =?us-ascii?Q?1fJV1Qd3w7PrLhztXUvID5Z2zsMgtkTXFDACeGCzfUMkCHFW2S3Mlre+ie6a?=
 =?us-ascii?Q?xmgV/oznHrXBAh8agnOtKvUVYKvSO/oYzRVy8B9ZLRF8uWMjuejrC7idahoF?=
 =?us-ascii?Q?+lz5oPTei2ir1b9f/TDOYjllV50B0CLuHimC89ZVw61xi9ZXl6T6pSYL2NdI?=
 =?us-ascii?Q?lIgCc3OWWEUjjG1cOEkQmqOcZu5BdArhokWeExCLj/5tWVxB3waCX7zwEB+q?=
 =?us-ascii?Q?ZAPedPkeJcslHQyqQi2V0ufBTHrvH8Ust46CN/8Fv2ovuns/TzprhXBAZkun?=
 =?us-ascii?Q?vDZglF9VkskBdTqb/50DI45Y68V5/MS4vE6ePmRCJeYBaDIIrJFVlQkXs+n0?=
 =?us-ascii?Q?m+C7Xbh+y7Zicny7ayXbcWLtU8SpwTA+WAUC8V0FqNXlI2mVo1eSPPVNSXlt?=
 =?us-ascii?Q?OfdQV4mvwIZ7wTcjDp8R971gWT8/ZxhXf8CrZwvaaIc1/P2fkbiW7tlKZDj6?=
 =?us-ascii?Q?H8twTYj5SP2jMyrhmY3I0n6d8ROBGlAXAu2mCDtTWmT4OS2pm5XZvlE5ry5f?=
 =?us-ascii?Q?keLJaKmrbKIYlQd0zMi1Edlk57v/aWU16cbcZo7DBCyl3fpY6OGFrInVnPFj?=
 =?us-ascii?Q?UdUkgwIHzVQCgdBPzhWEKGpSmHMBR/vmKinSdRv3x7Ke0bGyQVcvA+5bbiIF?=
 =?us-ascii?Q?7NY06CYJh1b75MLE6BwFy0Yo8PFh0IE++8cGL1XO1yaCn1jxr9hAGS4VfeJR?=
 =?us-ascii?Q?CIeT28V++UtZUxZHB8o/e4+2/HYsn6CFctxpFavBr2x+CBzfOEsEnc57NSFs?=
 =?us-ascii?Q?/pP/Gn2ktD6mUssIp3Mxqe1vKIK3KbbPM76qWGVLfeoZMnE1jeTCVErIHNRO?=
 =?us-ascii?Q?+76Gq40EvDP14uN1/oVaH1A+l8+exfUq+8qqsDBzIBhxXRhwmp50fXDox/qd?=
 =?us-ascii?Q?WkG4QmrGYfE8G4RCQANkQg4IESmrrbI0NrVfkpEeY/107Tb4kRNlpTaX9KiH?=
 =?us-ascii?Q?fQQwX5OQMsBR7XdnkPYJyy/JrqX9iFSiAlGDuxgzgob1in+AGAvcFbWYyG44?=
 =?us-ascii?Q?6IVw+Cb54d7MjHDY8B5OM2ABnr2ziaen0pqIH9xgdADWDWl0thqpScI4Zd0a?=
 =?us-ascii?Q?4r3T+yLmD+yIHnTZ0SJqfJOOTHiVLrCMtqb1VqHRzIsnUQaqb65Jnf4AiQtV?=
 =?us-ascii?Q?NjHCh6oTRtLqWAWtIwIg4h3WcF4kVOl9A1D0Farfd0oy/IJPVbJTISR94k/j?=
 =?us-ascii?Q?9vHT70k6+MHjPYZSJLtVBMOB13G6qCvmJPevV9dH5dhNuHjZsrowlwSqgZCs?=
 =?us-ascii?Q?vImxMMHHWnTEud6FZvFwymtcH1u2bWEPakPNK/5x9GhRkgoWVxX3hj48R9d+?=
 =?us-ascii?Q?vw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e21d68-113d-47cb-737b-08dadf98f16c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2022 19:08:40.4629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XTaw5liSs8tvl+A8D2AFeprcxDnL6Hx2aa3PG+gDFoCZgWPiwKKTuBF/X60P2YT+hsbJnmP6JEi5CUSX9Qz1EOSd40gXBCy2uDALnnVJ42Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5762
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Saeed Mahameed <saeed@kernel.org>
> Sent: Friday, December 9, 2022 11:28 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; netdev@vger.kernel.org; Saleem, Shiraz
> <shiraz.saleem@intel.com>; Ismail, Mustafa <mustafa.ismail@intel.com>;
> jgg@nvidia.com; leonro@nvidia.com; linux-rdma@vger.kernel.org; G,
> GurucharanX <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
> channels change
>=20
> On 09 Dec 17:21, Ertman, David M wrote:
> >> -----Original Message-----
> >> From: Saeed Mahameed <saeed@kernel.org>
> >> Sent: Wednesday, December 7, 2022 2:26 PM
> >> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> >> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> >> edumazet@google.com; Ertman, David M <david.m.ertman@intel.com>;
> >> netdev@vger.kernel.org; Saleem, Shiraz <shiraz.saleem@intel.com>;
> Ismail,
> >> Mustafa <mustafa.ismail@intel.com>; jgg@nvidia.com;
> leonro@nvidia.com;
> >> linux-rdma@vger.kernel.org; G, GurucharanX
> <gurucharanx.g@intel.com>
> >> Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
> >> channels change
> >>
> >> On 07 Dec 13:10, Tony Nguyen wrote:
> >> >From: Dave Ertman <david.m.ertman@intel.com>
> >> >
> >> >When the number of channels/queues changes on an interface, it is
> >> necessary
> >> >to change how those resources are distributed to the auxiliary device=
 for
> >> >maintaining RDMA functionality.  To do this, the best way is to unplu=
g,
> and
> >>
> >> Can you please explain how an ethtool can affect RDMA functionality ?
> >> don't you have full bifurcation between the two eth and rdma interface=
s
> ..
> >>
> >This patch is to address a bug where the number of queues for the
> interface was
> >changed and the RDMA lost functionality due to queues being re-assigned.
> >
>=20
> sounds like an rdma or PF bug.
>=20
> >The PF is managing and setting aside resources for the RDMA aux dev. The=
n
> the
> >RDMA aux driver will request resources from the PF driver.  Changes in
> >the total number of resources make it so that resources previously
> >allocated to RDMA aux driver may not be available any more.  A re-
> allocation
> >is necessary to ensure that RDMA has all of the queues that it thinks it=
 does.
> >
>=20
> IMO it's wrong to re-initialize a parallel subsystems due to an ethtool,
> ethtool is meant to control the netdev interface, not rdma. Either
> statically allocate these resources on boot or just store them in a free
> pool in PF until next time rdma reloads by an rdma user command outside o=
f
> netdev.
>=20
> >> >then re-plug the auxiliary device.  This will cause all current resou=
rce
> >> >allocation to be released, and then re-requested under the new state.
> >> >
> >>
> >> I find this really disruptive, changing number of netdev queues to cau=
se
> >> full aux devs restart !
> >>
> >
> >Changing the number of queues available to the interface *is* a disrupti=
ve
> action.
>=20
> yes to the netdev, not to rdma or usb, or the pci bus, you get my point.
>=20
> >The netdev  and VSI have to be re-configured for queues per TC and the
> RDMA aux
> >driver has to re-allocate qsets to attach queue-pairs to.
> >
>=20
> sure for netdev, but it doesn't make sense to reload rdma, if rdma was
> using X queues, it should continue using X queues.. if you can't support
> dynamic netdev changes without disturbing rdma, then block ethtool until
> user unloads rdma.
>=20
> >> >Since the set_channel command from ethtool comes in while holding
> the
> >> RTNL
> >> >lock, it is necessary to offset the plugging and unplugging of auxili=
ary
> >> >device to another context.  For this purpose, set the flags for UNPLU=
G
> and
> >> >PLUG in the PF state, then respond to them in the service task.
> >> >
> >> >Also, since the auxiliary device will be unplugged/plugged at the end=
 of
> >> >the flow, it is better to not send the event for TCs changing in the
> >> >middle of the flow.  This will prevent a timing issue between the eve=
nts
> >> >and the probe/release calls conflicting.
> >> >
> >> >Fixes: 348048e724a0 ("ice: Implement iidc operations")
> >> >Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> >> >Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
> >> worker at Intel)
> >> >Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >> >---
> >> > drivers/net/ethernet/intel/ice/ice.h         | 2 ++
> >> > drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++++
> >> > drivers/net/ethernet/intel/ice/ice_idc.c     | 3 +++
> >> > drivers/net/ethernet/intel/ice/ice_main.c    | 3 +++
> >> > 4 files changed, 14 insertions(+)
> >> >
> >> >diff --git a/drivers/net/ethernet/intel/ice/ice.h
> >> b/drivers/net/ethernet/intel/ice/ice.h
> >> >index 001500afc4a6..092e572768fe 100644
> >> >--- a/drivers/net/ethernet/intel/ice/ice.h
> >> >+++ b/drivers/net/ethernet/intel/ice/ice.h
> >> >@@ -281,6 +281,7 @@ enum ice_pf_state {
> >> > 	ICE_FLTR_OVERFLOW_PROMISC,
> >> > 	ICE_VF_DIS,
> >> > 	ICE_CFG_BUSY,
> >> >+	ICE_SET_CHANNELS,
> >> > 	ICE_SERVICE_SCHED,
> >> > 	ICE_SERVICE_DIS,
> >> > 	ICE_FD_FLUSH_REQ,
> >> >@@ -485,6 +486,7 @@ enum ice_pf_flags {
> >> > 	ICE_FLAG_VF_VLAN_PRUNING,
> >> > 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
> >> > 	ICE_FLAG_PLUG_AUX_DEV,
> >> >+	ICE_FLAG_UNPLUG_AUX_DEV,
> >> > 	ICE_FLAG_MTU_CHANGED,
> >> > 	ICE_FLAG_GNSS,			/* GNSS successfully
> >> initialized */
> >> > 	ICE_PF_FLAGS_NBITS		/* must be last */
> >> >diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >> b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >> >index b7be84bbe72d..37e174a19860 100644
> >> >--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >> >+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >> >@@ -3536,6 +3536,8 @@ static int ice_set_channels(struct net_device
> >> *dev, struct ethtool_channels *ch)
> >> > 		return -EINVAL;
> >> > 	}
> >> >
> >> >+	set_bit(ICE_SET_CHANNELS, pf->state);
> >> >+
> >> > 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
> >> >
> >> > 	if (!netif_is_rxfh_configured(dev))
> >> >@@ -3543,6 +3545,10 @@ static int ice_set_channels(struct net_device
> >> *dev, struct ethtool_channels *ch)
> >> >
> >> > 	/* Update rss_size due to change in Rx queues */
> >> > 	vsi->rss_size =3D ice_get_valid_rss_size(&pf->hw, new_rx);
> >> >+	clear_bit(ICE_SET_CHANNELS, pf->state);
> >> >+
> >>
> >> you just set this new state a few lines ago, clearing the bit in the s=
ame
> >> function few lines later seems to be an abuse of the pf state machine,
> >> couldn't you just pass a parameter to the functions which needed this
> >> information ?
> >>
> >
> >How is this abusing the PF state machine?  There is a 3 deep function ca=
ll
> that needs
> >the information that this is a set_channel context, and each of those
> functions is called
> >from several locations - how is changing all of those functions to inclu=
de a
> parameter
>=20
> this is exactly the abuse i was talking about, setting a flag on a global
> state field because the function call is too deep.
>=20
> >(that will be false for all of them but this instance) be less abusive t=
han
> setting and
> >clearing a bit?
>=20
> this is not future sustainable and not reviewer friendly, it's a local
> parameter and shouldn't be a global flag.
>=20
> Anyway this is your driver, i am not going to force you to do something y=
ou
> don't like.
>=20
> but for the reloading of rdma due to an ethtool is a no for me..
> let's find a common place for all vendors to express such limitations,
> e.g. devlink ..

The set_channels function will cause the VSI controlling the pool of resour=
ces that
RDMA uses to be re-allocated ad reconfigured.  So, based on this, I will su=
bmit a new patch
to prevent set_channels when RDMA is probed as you suggested.

Please abandon this patch, new one will be submitted.

DaveE



>=20
> >
> >> >+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
> >> >+	set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
> >> >
> >> > 	return 0;
> >> > }
> >
