Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26AC4BEF24
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiBVBnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 20:43:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiBVBnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 20:43:41 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C3B2559E;
        Mon, 21 Feb 2022 17:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645494197; x=1677030197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VdwhDbz03Xg6BdYb0qYc28/VIRDhINu0O9BdOJTdIzM=;
  b=JAIhkOQlPQpPCDBa9hJU3Gi34ve60QdLj+8hzDeQ1+MHRYaNVL0gy4ck
   XU3HnU8x4Zx+achD0UW6/ge0Zuu1RlEZNoxwqxd/RWxJT8eDhQ6O/dC2Q
   PicDoaKG/xjJ+M/bA7752pnKcQorKjmmnwNdugQGMUV16VcE5kGyOgOr5
   vVg/FcCVuHCKXsqoMT2IB4KCNYMms0H3Pr7n0kIS6ayaP73efvGRMSavX
   3HVc/A332n8T7vFew7PCCsb6F5os2CLHFmoZ5uaSENs9Xcun7jV31nKyl
   vxGUUKME+avezf2b6irY1Ps2+vpNNp1G3e+ydRWn+nVadCtSf+sAsy5AY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="250412226"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="250412226"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 17:43:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="627521588"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2022 17:43:16 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 21 Feb 2022 17:43:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 21 Feb 2022 17:43:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 21 Feb 2022 17:43:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWn83xiAItr4au9DpPbyY8zT2gmLYuV9CwJKP6LIUyPxVT2AwfvcKMg7+evcLjORC2Z/0QkIZ8JaZWmDM/yZJOy7NWnRTzl9vxC+rTH/MNdIRnrdesp+EPfSN2vaGRwwYh6BCxb38LLjS527TnLgnCnA6f8+4TnF0iBqpNVDoyqvoDJCf/Ii1EqazsxIdgRJ5O1acfm975plQeUlsS89Y7AdoxLQuVl0b+smoyFDI80yEXhL1+dQy75ubE2ghohncFm7jiBLJmr8qk4w6Vmxnp7zGBbfjn+4Xi0sZ8G0wgnzRQqfxxmULQ8OXYtvDeP1WQpIiQHiz6RsVu1zR0Xhww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XewDusyx2Emfp65BRAyZiWlL1k7lhPjGVOG4aYpFvEA=;
 b=ZPboyb8oA2+2jVG40F9x5EYjXzSXgHh3Tpj+hvoqz0BOo/dcbsM+rPuReF/LNi9XUV8ODC91zdXT+li+jWrCCzv/zyP0LGWmmO2c82WrPvGrk6/5v5dAC+dj/xcsT7VR0f8J88yeGnFpRu3ZJEDXtVdCh8+GjOemt9qGOJSegSMx+JB0j7DqBm7bpfTq7BOUwFMw3qfhBhDlNWhj5atM1olKMhHnhU1eg5kfFvcrq6oYQ0EsCE/MaZPmWQL1+dYV7EdbXwteKiSshT69MgxsO/grK4aHd6Sj/V7av7jhTpHXXp4co9WFSz2V+Y8utXXxsIQPeIhbwT1wGYulxcJffg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Tue, 22 Feb
 2022 01:43:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 01:43:13 +0000
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
Subject: RE: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Thread-Topic: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Thread-Index: AQHYHEeP9+yi67MoOESanaHY+teTS6yY7QGggAB71QCABXaE4A==
Date:   Tue, 22 Feb 2022 01:43:13 +0000
Message-ID: <BN9PR11MB5276C05DBC8C5E79154891B08C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220218140618.GO4160@nvidia.com>
In-Reply-To: <20220218140618.GO4160@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3420f146-5748-4aed-5787-08d9f5a4b0a9
x-ms-traffictypediagnostic: BYAPR11MB2599:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB25993989C4F0B27038A6A0C38C3B9@BYAPR11MB2599.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qrNbXijzlCTqgi9aPT0TGiMkIYenpS9FfFRQ1Gsm+wfO83XbkGkiPYUPIQJEwhdAQKilP5ollgKvoEyDQxKHpGhyd4/BBHqbq+0U0/XS/NYzalX1vyk5V5ImcSROmoROXx5F4GJ8pVlXBtjzRnr+Xa0O4cS1dC4da10RFNq0d7HO8yJaoMRI5lUX3F4kqaJ5qptxiLiI7HjVAwRNzls6wNqiZWvcCqG+n5ECE2sWdAMPk6NiE3ho/i392qWSFPiecTofw5vxtHvsoiF/xoQZmO4t1LLtkqoTAl7XGjNgJ8gPcfXQA8cSr3RcsEr6t43XMCBJbUd4x3NZ33ze2mvryrkxxwVYkcNy2fgdWbEYlhoK+tSHEe1QDvA/fyM5tIvg7wHPiU6e93MrTxxA2lE18Iy7zNahQM1Q/CllMKakY6rHV9Yxov7Q9YPRZqumBmqNfe2aTXlwY+nDf/8l319Lb3cTraNCreCFyYGd7fhomaUHsdoZ7Qwh0YAvXCUOsbDLF64eKHbFefNRWw2iVKYqcy5yAdfGxr4VyDx6bjdW/AhLS0Oi9mpHeCCop/iiYhIOF8dUoJnc1kFs+m4OQL69fPhB2Pjs61phOggFyKuHg1TQN3dyBgRBSkumzQyDQl6K30Bm5eQ6iQsx2QRhz/584GpLrdruZtyG/H6crMhBSFGw/iUMDv7VGGp7xYCxIl6gvcYZaysP1QoXyxmc0vtzEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66476007)(38100700002)(4326008)(66446008)(64756008)(122000001)(66556008)(76116006)(66946007)(26005)(9686003)(8676002)(186003)(7696005)(71200400001)(6506007)(86362001)(316002)(38070700005)(55016003)(8936002)(83380400001)(52536014)(82960400001)(7416002)(5660300002)(33656002)(508600001)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kt+xptfdKPO+D8Dm9pTcdw/hY/pMQyGQ8elcsNRYqStJFIA+PeIZ/jTe9X9Y?=
 =?us-ascii?Q?8SedcvyQvbV2szNHyV3ceEOUaxsIuTmwyLHMOqDQ4101TnOSx5VU1mlEVdVY?=
 =?us-ascii?Q?tleN+JT8+zP4I3cwnAsurwefZbHuyW1oGNtM5c5m2vlBYbGC3uGwQM2/lJko?=
 =?us-ascii?Q?H01HBB6U6A/12VUgZ9wiJlnOXMkAIvquYAGlHt+df4Ju/7wiS+RAxb07qB3L?=
 =?us-ascii?Q?6//+u79e3uTYlJExqQiP4Kskk6n06IEDyvxlcIqeLCXPb6F/eWPxuaCoLLj6?=
 =?us-ascii?Q?VwSJmfNtS4jcG+swQ4NDBc33akF2oNIk8thcVVieLGa5CvSn/QJqfrlby/CH?=
 =?us-ascii?Q?uekzWNnxTlP0aM98NNp5zpqZL1dkWVl1DVa8Y34nkb8oZ8Ian/X1KYhWMDdk?=
 =?us-ascii?Q?5odMRt9EA4rPRkDBSPIBR8QLVX7/ADN7J/CWzEDe91hfq5aGSlRsA2ZJVpPG?=
 =?us-ascii?Q?81+JNW68w+JoVBvXjhi5hjYg2y+ABnaDwfugOjE+OwHR2GoeHS045tEsj2oL?=
 =?us-ascii?Q?MdKjPFAz4s+1SWufiqBAD8etgFM/CGp1vYbHnywwi3waw36bQzowC4fYQIdR?=
 =?us-ascii?Q?uQRh2ZJxrvw+KJUt+vcrSMFkTsGyK6mVoy/xpDw3g73MXpi6b5KDvdPBeQ2m?=
 =?us-ascii?Q?LD4wuSg6P+6NfTRKUb6AfbBy8RmKRifR/MNeTqPNqas+3/HhDiGaO5Ab5OgK?=
 =?us-ascii?Q?kiHxwTqRP/r76U04+YOeOxRKMNMt7zdnjZzUiOla1Ycr1Fzgly7dYXR4RAPg?=
 =?us-ascii?Q?QN2iQZ3RBizk2J4YJ2MjLbbG1wp0BK/unPc+m+CGisGISjz6won+n3wvh48A?=
 =?us-ascii?Q?d4BCuBpx1AJKprJpUjFW+cdAt5RmFetrrsrUZH6iSr0YjWV8MAenv2qVT4+R?=
 =?us-ascii?Q?EudyNWdrtJkXeEOGogEe22vqUEVoK2z4R70TpLNy6ggdL9N55MRV8avBVje5?=
 =?us-ascii?Q?TJFeUEdSrpVWS9IcFiNCk1vvlZyxeDa2gUl/o40oG5oTQfilXreFICSCih1T?=
 =?us-ascii?Q?4fsZEOCmQ68+myID3vgEQE5W069e5Jm6jHTjiUS/2JsoilUm0Oa9jRILs0f6?=
 =?us-ascii?Q?JrsdlgQSlQQqY88XE3w+KcBFMVsL/CV2u0WryDotYQc3xdXXi02QdC23dzsV?=
 =?us-ascii?Q?GiJ4elvv9xNZVSWGyscB1lRdhOkp+sElSn+Hy0+9JveS5q4+IOeL+C21g7W9?=
 =?us-ascii?Q?cw7gqpcEFMtzzeNLd9lkdN2q12JE8KJ2Gxnt8FLxt+Us7TOlfPKTITv3W8iQ?=
 =?us-ascii?Q?l15ewNyUjFGjJ/ApnVKfoK/oB4wps6TkxMdkX+JoH+eh/cLqUuJV621JNfp2?=
 =?us-ascii?Q?G40EHQAPD3dlVxuBtvt5OHKo6tIJ6I1bVLnjdwwXiE9NsprhQ67hb9mRsbpD?=
 =?us-ascii?Q?3VJ+ETLlZrXJTuoCLHpPRM83uhBHosyXuDk3f5saPqf6x/KPC2dRJ99Bj8qq?=
 =?us-ascii?Q?J+5bpKk5014OwSTpamgDCCwib4hxF3Vx8IOc+2hjkZLnzodkPjg8HyVQDoC2?=
 =?us-ascii?Q?AqzUWLe+ru6qXSJZ+zuzsvbnnrf6LfjIFFFz7IvJZ2QAb4GwPodx5f/ikF4J?=
 =?us-ascii?Q?KuKZjkl64VNeNTDbXJIMfxlxQXo/15V6ST3DUtnqEooChIeBFPVhQkyRjnSH?=
 =?us-ascii?Q?yA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3420f146-5748-4aed-5787-08d9f5a4b0a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 01:43:13.5559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3uI0f0YCBh1LACVw92z/9WHnwrhR/OEsooX5U5U2v8mJvuuCoa7O2IKkERgHe9KcZ9DL5cAXL5pKbKGsC3hdXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2599
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, February 18, 2022 10:06 PM
>=20
>=20
> > > and to be defined in future. While making the whole PRE_COPY feature
> > > optional eliminates the concern from mlx5, this is still a complicate=
d arc
> > > to implement and seems prudent to leave it closed until a proper use
> case
> >
> > Can you shed some light on the complexity here?
>=20
> It is with the data_fd, once a driver enters STOP_COPY it should stuff
> its final state into the data_fd. If this is aborted back to PRE_COPY
> then the data_fd needs to return to streaming changes. Managing this
> transition is not trivial - it is something that has to be signaled to
> the receiver.
>=20
> There is also something of a race here where the data_fd can reach
> end-of-stream and then the user can do STOP_COPY->PRE_COPY and
> continue stuffing data. This makes the construction of the data stream
> framing "interesting" as there is no longer a possible in-band end of
> stream marker. See the other discussion about async operation why this
> is not ideal.
>=20
> Basically, it is behavior current qemu doesn't trigger that requires
> significant complexity and testing in any driver to support
> properly. No driver proposed

Make sense.

>=20
> > > @@ -959,6 +1007,8 @@ struct vfio_device_feature_mig_state {
> > >   * above FSM arcs. As there are multiple paths through the FSM arcs =
the
> > > path
> > >   * should be selected based on the following rules:
> > >   *   - Select the shortest path.
> > > + *   - The path cannot have saving group states as interior arcs, on=
ly
> > > + *     starting/end states.
> >
> > what about PRECOPY->PRECOPY_P2P->STOP_COPY? In this case
> > PRECOPY_P2P is used as interior arc.
>=20
> It isn't an interior arc because there are only two arcs :) But yes,
> it is bit unclear.
>=20
> > and if we disallow a non-saving-group state as interior arc when both
> > start and end states are saving-group states (e.g.
> > STOP_COPY->STOP->RUNNING_P2P->PRE_COPY_P2P as I asked in
> > the start) then it might be another rule to be specified...
>=20
> This isn't a shortest path.

it is the shortest path when STOP_COPY->PRE_COPY_P2P base arc is
not supported. I guess your earlier explanation about data_fd
should be the 3rd rule for why that combination arc is not allowed
in FSM.

>=20
> > > @@ -972,6 +1022,9 @@ struct vfio_device_feature_mig_state {
> > >   * support them. The user can disocver if these states are supported=
 by
> using
> > >   * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions
> the
> > > user can
> > >   * avoid knowing about these optional states if the kernel driver su=
pports
> > > them.
> > > + *
> > > + * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support
> for
> > > PRE_COPY
> > > + * is not present.
> >
> > why adding this sentence particularly for PRE_COPY? Isn't it already
> > explained by last paragraph for optional states?
>=20
> Well, I thought it was clarifying about how the optionality is
> constructed.

The last paragraph already says:

+ * The optional states cannot be used with SET_STATE if the device does no=
t
+ * support them. The user can disocver if these states are supported by us=
ing
+ * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the use=
r can
+ * avoid knowing about these optional states if the kernel driver supports=
 them.

>=20
> > > + * Drivers should attempt to return estimates so that initial_bytes =
+
> > > + * dirty_bytes matches the amount of data an immediate transition to
> > > STOP_COPY
> > > + * will require to be streamed.
> >
> > I didn't understand this requirement. In an immediate transition to
> > STOP_COPY I expect the amount of data covers the entire device
> > state, i.e. initial_bytes. dirty_bytes are dynamic and iteratively retu=
rned
> > then why we need set some expectation on the sum of
> > initial+round1_dity+round2_dirty+...
>=20
> "will require to be streamed" means additional data from this point
> forward, not including anything already sent.
>=20
> It turns into the estimate of how long STOP_COPY will take.
>=20

I still didn't get the 'match' part. Why should the amount of data which
has already been sent match the additional data to be sent in STOP_COPY?

Thanks
Keivn
