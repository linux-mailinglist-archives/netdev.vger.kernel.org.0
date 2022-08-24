Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708E85A034B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiHXV3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiHXV3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:29:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAAB1CC
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661376585; x=1692912585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aW3zFZq/0Sj/S5vzxG0OG4R89uzVFXKrtewq8nF75MU=;
  b=TyiRqiXNx4PnA817iB3hr/Y1UdI3ndhqKu0X4axA+FQZcXuaR9dHFF0V
   93FsVEtfJu/8Y44Cu6W5nF3kXbU2kbaLuXE468QqAYEqUBIzQsJT/V48Z
   eDS6z4FHEaWuDsUbk0ECpvEuzLo6KEWvWB1uvE2HC4Yv9ZIuLbnY1wrtc
   SuilRudBkHrLVvWKtRVoOB30qZaOaItGu+YTOgRHWdrxouU8c9gtZ5LvX
   At+vWM8WuNGuGhIlSTO3/s1SfeDZTnXZUIfnwIeqZZ+V1ywyQHPvYu0Qj
   DUBQtbaWrmBQssi6dg4rMskG15TiPCaShsSsSfjzevjh4a0gbVdbIdUaa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="292825104"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="292825104"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 14:29:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="639295742"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2022 14:29:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 14:29:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 14:29:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 14:29:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgFde3A1xGWjyscPF/Mcl3lOaLLrpYCsjv5d+csbJFHDUH4TVn9lyIxnyTQaUcoauS+jyByK/4sRZP510zVDuLSNvHnVzujpfoZ0LQuLYYQCoPDIv7v0JsZc1kMeHjfFBHU/kbArp0Ly0zi0s3pZokOs2l99JN0my457nz+chC1EE0jm9HicCex+kKApvKW5ObBiFfiaLF/SXcTMGUeq/BXlR8eDRvew3GEbBvm/KKgVtdKrFV5FY6/vhk8bgfshLHTRDzIZpjBNOTLdTm594nM6xLO4DI9RzjjPUENChh8xmbkriF+QAwnd87M3nI7wd5bqh2aEqlgiy/Xqp+zfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7jcervG6YXRJGIzYUO6QQG5/9c44nhVLdsz0AAY9q0=;
 b=h+NadOfL0E+CWTeFY92IWz7IOhHaJolHOvfjJIjuMCMJyrVEfpnqG9UyARgUVSP782TkmwO5+qqlcaSi2UIi3BE+ASP9CQXm+3byk7w92KHtKr6wXi6AXY+P4M3VDZVKRptg9keqD7gWHhqh5/U5yY7Ijq9Blz3POlMEcR0gjhTPZnXovYY/7MZOJAPfIMJLbV/3z8ki9L8O7mnQifhEe/YlvnEVFPFAkxjLj7I8LkoNFeKtFehEuvtT3so1IooTMZZOijIxccTHsAI/9DDXILiTD5lyQAsetweFDiK1lEQi3qkutUMeMd0c3bV3MqyoYytuakDvDjINrf21YJEtSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL0PR11MB3297.namprd11.prod.outlook.com (2603:10b6:208:69::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 21:29:32 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 21:29:31 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Greenwalt, Paul" <paul.greenwalt@intel.com>
Subject: RE: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Thread-Topic: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Thread-Index: AQHYtwG/f8zW/T1x2kmfvh0Pne5Gi629DlOAgAGC4zA=
Date:   Wed, 24 Aug 2022 21:29:31 +0000
Message-ID: <CO1PR11MB508971C03652EF412A43DD80D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
 <20220823151745.3b6b67cb@kernel.org>
In-Reply-To: <20220823151745.3b6b67cb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be75f194-b0e8-49b9-bb29-08da8617bb9e
x-ms-traffictypediagnostic: BL0PR11MB3297:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zJydYhAdPF7SxUCco/ftKUekiTasRVQc44p71NKtqRY4/uPSteYSBSwrOPpZyP76wHO9+qmzeY0AzLJqP6GBcpg5pUjJxCdOyKFkLd3olmm01u7ppdnMEfODbNcCFyrw+L3ef5Xc/ec2XP+ukKX2J5gdfM4qEScBDwR+oU0ewSLdMNX9uajCTmWMxBxZA5TlnH8vs4EKGaMOGrBTDx3NZw8XQgsGc+eZW/gpOmkUjKtMYTBL0pJzdCDE8xWga08AuqfloYP0k7tyO0T6xNwE/ujZe+Fcb7Gb+uVc74lEKMbwnTUiD+0TZNX5Al2MX2jCklfwh+UD4a0fAh8mcoc7pm/Lo6eRIsJhhLnVb+gGAJUls7hcPyKJf06R23+ljAqCKbO1YXBTNpn68uLuCj9IK5gVRZyFVhjp9TC89Mxj25WWndo9rZh/+VzCEsQlz17f5aMlTy+Rf21p7NkACsXtKmJ45uh6ZMQ8cIhzac//7B2Jbb4fQw6ECVVVlTPNHM2rAHvESXnCRqug2yhP3LHj63m+/jhujWiYbSKndA2r/4nVCuUOIq4vq0efE9G3cjOU+Y8x/WA90rEoNPsaCL6fsKp+Y9kgnycLrBxxV/vV6ecynoCE/FFiyP+n55BnaJHsVzkQiZUmVNceTEkBfUSIiRtt6SLmnm4u8zCNOLafa1wRYrf3Opzyo2aUSW1qrXRwrFewnNzuMsBBD5od5llNxA/GpLFzDKdye7UhaxMtPFXTXyfggxfqL8P8inBFgxUKXVYfwvORoKzrnRzoT6pN+KzR1EPsL1Dwa11BH2MgQNQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(39860400002)(376002)(346002)(366004)(6506007)(71200400001)(122000001)(9686003)(7696005)(8936002)(26005)(53546011)(83380400001)(966005)(186003)(38100700002)(478600001)(33656002)(107886003)(41300700001)(2906002)(5660300002)(76116006)(66946007)(4326008)(54906003)(8676002)(66446008)(66476007)(66556008)(86362001)(64756008)(52536014)(55016003)(82960400001)(45080400002)(6916009)(316002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N/SnejvGymaIgdZqlngfv9UraWbLY2xbFhuqw32cxfzLgabwerVcKQPI4wIy?=
 =?us-ascii?Q?VzIWCfVYKWOwRX5KTWPtX9bxdw9B+oCnHgW3/ALqQAm94F3t3Ja8kAickdnj?=
 =?us-ascii?Q?dUNsAWJnlm5gqHZZSZ3WGLKrNJPRpdW8585SjW3BKM8XInZiZnWIZgouwsuf?=
 =?us-ascii?Q?edekQDxNq02Fy7LVaFtupLVZvSrGar8E6fjBxjrq+fWOoDPyV4hAybk1i0BT?=
 =?us-ascii?Q?6GJU99Js5MCeaO+I6R10zp/+5ua+eL/VcE6pU28tUH+jGs54gb8jMjmNVHtH?=
 =?us-ascii?Q?h1jG0t4uFxkMFOV9UVCcsJMtoxhaRjpaaaOGbOg0KYxEsi5Uz5OOc4WQwsVL?=
 =?us-ascii?Q?o1r8XFmDZTUo3NtSlnew+ObsOiHlN7WaRWIBOTcXmP5hXuAyKEiLfIfIHvY/?=
 =?us-ascii?Q?4HvwU05jgFKUkWOLqRnAXCRy/JqF+whwzJiIe7hkzu6MQT1FKWL5M6wt9+zK?=
 =?us-ascii?Q?znSew6zjRgrmeQDW3HpqZFC/djJvwfpIpDTn5ynHAh2QQZq6DLIY7Lqobprh?=
 =?us-ascii?Q?kxbGwPzIXIEcn8yClkiEDfZCGVks5g34468rNIo76hl7IODCPvZG4ViLV6Xd?=
 =?us-ascii?Q?zpYRmRx1ZG2MM4OTn1iqvnGVnPhUO3rt/3lELs+rVCKrrLhDrg5QItnhOR1H?=
 =?us-ascii?Q?N7/DCcXVRm+9boNy03UaxhIgDH9uJ7vcfxn8Tt1Z/D631Om5z4S64f6fPIp+?=
 =?us-ascii?Q?ma9eHqPk+tQL7DoFkdEPaYXd6tyA7gEKp1vAq5p1n2KS5fpmtOEMQ2MAoQ0G?=
 =?us-ascii?Q?tl4qZESVLYCVTSnDHSXqBdcQKOmJFOcblCqHjSMEFPxX7jgzZe13+nxKZHF5?=
 =?us-ascii?Q?plMJY6trD6BWtMTErEN7zAWH8S8GBmuLT5Y7SOzfxCXzxcS5KfC/3kcIA6m/?=
 =?us-ascii?Q?bB7o85dVCVZLROpXxLArxodAlF106qttmQ2s+FSfLuE3WvJ8d5mM21kTx9my?=
 =?us-ascii?Q?7Gl2qJGjfbW1j7pvlezInmqJR9nph6IRWpcDctNN6O4sGqi07QDUrUhwtggp?=
 =?us-ascii?Q?Swd9CJe/ONMeOqfhgmsPaM7UVl/l5qY/zZeruHB8BHmKhKn55DBXkjvrf7wG?=
 =?us-ascii?Q?QLk8HvJkGCgEBxtSXvxBRaIUott4gvFS4T43WpCBmJ4Lp0hXdi7YxhG7Yksx?=
 =?us-ascii?Q?Ld6eFv72XtZ7xA3xTMg3MTTjoR2igA0+1oFj0kfd96BS/p7bnPBqF0wqn4+A?=
 =?us-ascii?Q?gAWMucNfnLIQMTot+8v7C97UDNSH7iiD8Av/u/TNpav/f3qN6DOtLNUyMBNt?=
 =?us-ascii?Q?RGyWeRkL/aE0oIzl73WXgylrvIezwUFUNiWa+gkROgfjlo+UvqQ0QR9RDLkt?=
 =?us-ascii?Q?hhF7WIDEhyqS35k7MYxpLodiyhM90Sh4EOzFhGfgV/XZh8p3AWfpp8G94agV?=
 =?us-ascii?Q?+s1N/RlbGWnD9XMu91OjsaOFGN8DMQUQL+TbYo2PFtXzXVHOCInTwQawaoPg?=
 =?us-ascii?Q?NoOH1vr1HOCXlflfSuimx/Aew6Pvt99CLXq436EIrBp36QyyhYmGnTuDsa5N?=
 =?us-ascii?Q?pKZxWF1pXm6h+ofKmd9Ycnx/9B/7Mm59d3bI9NgdJthkyGwBFIR/U6EOM/ZR?=
 =?us-ascii?Q?wsBwirIrB4qHDhAmcEyuU+f4rbk/zu7J3YZA9w5R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be75f194-b0e8-49b9-bb29-08da8617bb9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 21:29:31.6145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: miNQ/AqW7EFtRIlh0UtVYv85F6tkXnXDZ3zxmhawEj8a9n3wkJCKe2WxLqH+AtVr0RYuxvJlsIRtU8sr10s/19NiAuiwXqk1EhiM82hpu7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3297
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 23, 2022 3:18 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Greenwalt, Paul <paul.greenwalt@intel.com>
> Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC =
disabled
> via ETHTOOL_SFECPARAM
>=20
> On Tue, 23 Aug 2022 08:04:38 -0700 Jacob Keller wrote:
> > The default Link Establishment State Machine (LESM) behavior does not
>=20
> LESM is the algo as specified by the IEEE standard? If so could you add
> the citation (section of the spec where it's defined)?
>=20
> Is disabling the only customization we may want?
>=20

Ok I got information from the other folks here. LESM is not a standard its =
just the name we used internally for how the firmware establishes link. I'l=
l rephrase this whole section and clarify it.

I also clarified whats going on here in

https://lore.kernel.org/netdev/CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR=
11MB5089.namprd11.prod.outlook.com/

Basically: the firmware has a process for automatically selecting FEC mode.=
 On older firmware, this process didn't include the possibility of selectin=
g "No FEC", or in other words of disabling FEC. The process firmware uses i=
s a state machine that goes through the FEC modes known to be supported by =
the media type.

Some of our customers were confused about this and have asked if it was pos=
sible to allow disabling FEC. This is distinct from manually setting FEC_OF=
F, because it lets the firmwares existing state machine determine of the di=
sabled mode is suitable or not. I understand it as the goal of being able t=
o say "automatically select FEC for me, but if No FEC is suitable allow tha=
t".

The new firmware requires manually opting in with a new bit, and we don't w=
ant to change existing behavior, hence the new approach to using both AUTO =
and OFF together. If we instead go with "use the new mode when its availabl=
e" then there is no way for users to know this easily since it would just d=
epend on the firmware version.

I've got a proposed reword to the commit message as follows:

    Users can request automatic selection of FEC mode via the
    ETHTOOL_MSG_FEC_SET netlink message (or ETHTOOL_SFECPARAM ioctl). The i=
ce
    driver implements this by asking firmware to select a suitable mode.

    The firmware selects a FEC mode automatically based on a table of suppo=
rted
    FEC modes for the media type. Older versions of firmware will never sel=
ect
    "No FEC" (i.e. disabling FEC).

    Newer versions of firmware support an automatic mode which also allows
    selecting the "No FEC" mode.

    To support this, accept the ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF as a req=
uest
    to automatically select an appropriate FEC mode including potentially
    disabling FEC.

    This is done so that the existing behavior of ETHTOOL_FEC_AUTO remains
    unchanged, and users must actively select the new behavior. This is
    important since we do not want to change the behavior purely based on t=
he
    firmware version. Additionally, this allows reporting an error if the m=
ode
    is requested on a device still operating the older firmware version.

    This is distinct from ETHTOOL_FEC_OFF because that selection will alway=
s
    simply disable FEC without going through the firmware automatic selecti=
on
    state machine.

    This *does* mean that ice is now accepting one "bitwise OR" set for FEC
    configuration, which is somewhat against the recommendations made in
    6dbf94b264e6 ("ethtool: clarify the ethtool FEC interface"), but I am n=
ot
    sure if the addition of an entirely new ETHTOOL_FEC_AUTO_DIS would make=
 any
    sense here.

Is that a better explanation of the reasoning?

Thanks,
Jake

> > allow the use of FEC disabled if the media does not support FEC
> > disabled. However users may want to override this behavior.
> >
> > To support this, accept the ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF as a
> request
> > to automatically select an appropriate FEC mode including potentially
> > disabling FEC.
> >
> > This is distinct from ETHTOOL_FEC_AUTO because that will not allow the =
LESM
> > to select FEC disabled. It is distinct from ETHTOOL_FEC_OFF because
> > FEC_OFF will always disable FEC without any LESM automatic selection.
> >
> > This *does* mean that ice is now accepting one "bitwise OR" set for FEC
> > configuration, which is somewhat against the recommendations made in
> > 6dbf94b264e6 ("ethtool: clarify the ethtool FEC interface"), but I am n=
ot
> > sure if the addition of an entirely new ETHTOOL_FEC_AUTO_DIS would make
> any
> > sense here.
> >
> > With this change, users can opt to allow automatic FEC disable via
> >
> >   ethtool --set-fec ethX encoding auto off

