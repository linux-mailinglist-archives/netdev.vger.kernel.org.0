Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447D267AD72
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 10:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbjAYJJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 04:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjAYJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 04:09:17 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6913A84A;
        Wed, 25 Jan 2023 01:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674637754; x=1706173754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NyFnkuM2LlnRp33OcXoaUZdendDA+jHpvHoMHUmd98Y=;
  b=NreaeFesbthAC6GqJ+nFNYqr16y5m4KC46VjSMvyLTspRgk5vJ5Q1G2H
   zcJycvu1PT/qQp2Qmdi9J1ymOvFkbSbsXVxUBVEhZazZofeEVteABvAMH
   nWJGSuBYEj/edyVBzad//DTxxt2Jp3TTRkzduCV6xbamFEYu6L857exBk
   3+7w4LjKif6kBbt1mN0BDTshtsdy+TlFEyO0VGmDunRPxm8tM+pPUWQil
   fxVUpv1aqhevwuCrm51YE9jjr9n1tnxJPnanfPH48sXiu++F1drvhfKGP
   X9gT8U6ZwsKOXeKan+2I7rOIdU7YQb3uM020uQi2JcRTJxUbjpz0A9IMf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="324211533"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="324211533"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 01:09:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="786367697"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="786367697"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 25 Jan 2023 01:09:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 25 Jan 2023 01:09:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 25 Jan 2023 01:09:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 25 Jan 2023 01:09:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlvA7nhWoi33lge34K3tekzxUaRm4Fl/YMXPHwFlFVpQJnj8v8uXuusYO/wnhKf4ytb5deQrGe/snmqwSMhK+Z+Rr2iAGdqzA9gK2tSHZ4U0GgcO7CV/sHc3j1347pxgPj4WFPw612Y5BGKvnJLurQ958tLLM+C18jErLGrxly0nJugR13ffcjUYiRM7RK04lPUakbteLbFrrKUvM5/yOOFQZDaS2HhMlRpTAiyLanRB6R0B+GRGXrIxhNg4vtPdx0hlp76aHYGXGfLXP38Tih4fgxiFc1cEJAevRCir9d7xBKlDwbHNZWKzpsChOudvrQcDonTRdvX7XiDo8vOEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLdXgpZrkKd5zIla+/MLOic5A+jFGR3mDt13bD50I9g=;
 b=b9vJrK8EvLJsxVbN4ksXHlvYeHdUpKb3cmudY2LkQkPiNEZCRQXdhkG+8HIaTLMc8zz75UhEcJfD9Elrwz90JWQ8dVuGOm20ZBjRopE04qhuYvypD9P73tY6zx8TVQ2HoN++As6tLR4QohwNrv4uM2QHfrGoRN9xwEYwcHc8gxGGBpsH66I3VRMM3whzbiH0JchsIysUTLsbRjeNbWy8OFmYuWkTr6loZyD8qLmdcrz2tOBPfUcPUDQwcPp2vB7lbzgEOxqHw9WoD5rBZwy2aKBeuanj+96quVJxKbLqcdTs4ptYN1baQOkIGGWLVvd7cYCaU0pyxaZ6n9PRdFDGIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by CH3PR11MB8154.namprd11.prod.outlook.com (2603:10b6:610:15f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 09:09:11 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 09:09:11 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH 7/9] igb: Remove redundant
 pci_enable_pcie_error_reporting()
Thread-Topic: [Intel-wired-lan] [PATCH 7/9] igb: Remove redundant
 pci_enable_pcie_error_reporting()
Thread-Index: AQHZK5c8rGsK9/3tnUGTuU9JLmjdZK6u4f1Q
Date:   Wed, 25 Jan 2023 09:09:11 +0000
Message-ID: <BYAPR11MB33670FA9442A0D4659824849FCCE9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-8-helgaas@kernel.org>
In-Reply-To: <20230118234612.272916-8-helgaas@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|CH3PR11MB8154:EE_
x-ms-office365-filtering-correlation-id: 44cf39d6-2ddb-4f61-0499-08dafeb3d298
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Z5R7jMH2LAse54g11xJKo03iBOXuSjcj07+YYdHbw8ppQrYfzF/8l1eZIETzUQGeCKaEPbYNCI4IjP+uy9mKJjFYFj6xigUkYoYEECtGdtysEqr2fsYwaXfOjqzhja+Xr66jPsbIv6ikD/A3+3DqBKSu29UVT1+csBGhPrrRtSPZ0izeuM0i0EYmfWMngynUL2OvdpPjNt0wLantuGCG+qQ1jGvOP2FSNE6Q5AZLWdLcXTFAVAZlRT/TsotgQfVY8+VUYxaGpane/mB8FuNDLHo+4BUOTIg1MFSCTJQrBD1yOyfOC9XCsIIr0DgCW08kqTSoYOtWgm3KeoTh9QaQN99vwAxUVamMeO8SgnWRHh10L9j6Oo61OlMqTNkOYNkPnnFiG7bltwZcGPsumsPYnyO0gnbEqzOFbOCjE71GU9Tt/b8vTpeHVNMcHWLXsz4jihr/mtUX3I4Q9Le7jilEE9N/iboT9a8U/TTcCKJuH029Ul9phZOAgHCiZB/h5GXNpO+sXWYO4s/fXaRiJ6SPPsMu7LMiQjnwTVBvOvc0l6UPB+M15+vnvk53Zcha7ieUPdRijhGxL3jVC7FhXCs4+jT/utQpuVj0S95VXMyQrJS/sipiZYchHOQTFQFAF4u7kp86QdzLPHOYh4Ect1BomOgU5miahCMZLDqhahas9Nnt4zPUCNXfFmYBIgJ1qG/QAAggpUrkRKoxpoLzJS7SQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(33656002)(38100700002)(82960400001)(122000001)(55016003)(52536014)(8936002)(9686003)(186003)(2906002)(86362001)(53546011)(6506007)(107886003)(66946007)(41300700001)(26005)(5660300002)(316002)(83380400001)(66556008)(64756008)(478600001)(66476007)(8676002)(38070700005)(110136005)(7696005)(71200400001)(76116006)(54906003)(4326008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0wJqRlY2CHKWu+4JEFMcPIwi4jfr2D9h/Rh+5s4exSwIkTTWpnSdv5a2DmJc?=
 =?us-ascii?Q?exDw/IWT6kpBk4Ueofbq4+KkN/HnpeCpRh6/ih51IAx/Fwg1fVjMIcZNl9QM?=
 =?us-ascii?Q?+jvCI0SS7oh0Q0Ghy5QWU9Kd+7nKIExssd5lFlAo0JSKMFAUBd9ie5AhAXqm?=
 =?us-ascii?Q?GNktEm8r6ZEoCYJoSLRW4sFY6i1RGl786/vbL6RLa+C6AanITg7+7GiQ3t/L?=
 =?us-ascii?Q?MuJL503IxxLrAoVU7kWbXIa8HeS3myRW5D8uYZpJHkRsgl9xRKRQ4XOLm+92?=
 =?us-ascii?Q?HTYDS5sDh5xEWtArt0OnatkPggv1l0fPv3vLKbZhaC6nEJlVNTGozFGIcqVw?=
 =?us-ascii?Q?/rZ9zoPlmoB7lBkbYFdhuwiXGGGSHzv12Ze17ZQzXgjVubaKzhP7S3ALXsAo?=
 =?us-ascii?Q?UaS9/AlflxRiRkeldaTzqnWvXeNfGLbwwOAmRkDqjSgSpR9RkVe10Jc3scB2?=
 =?us-ascii?Q?GvTh7FU7Mn9AAl7bM+EZVBXf4w7UkBcSkPsEuAX/dlEFNw9wweOzaMoc1yB6?=
 =?us-ascii?Q?LQHdR6SlxfnES0FM64T0cLGaM5eEsmRFP1RzITCPUGS92RYzUVgHcxknQNvL?=
 =?us-ascii?Q?hQStHi5UgZTcqvJoA41eW9Yf21uWyqRrGm+wkcnieIGGHrklBEvbjLZr70uL?=
 =?us-ascii?Q?/a+kcdJiTnDGrgRKhONsb90XSwf/ZeLMTWmsUZ7qHpKmNH/sIo3cHGew7lFI?=
 =?us-ascii?Q?LikM5hQWtFTke3r6kXfkfy/iPSxBftsjwxlQISHVE7b5eR/brW6AezBW4MCh?=
 =?us-ascii?Q?jTYlYEw25L+1nG/kUKVjGpfV1fQsKXt47aX3UloIxUIUiOjD0/hWJzEkomTL?=
 =?us-ascii?Q?fZanYmNLlmEo1W5M9UOipTBCrNU+6fr9vz0ArhQy/3otvX1ml0D0mFHBZQBV?=
 =?us-ascii?Q?JInPhzRgYvN2eJZysGLMwaDKq9lT+UEpiavhhIbbcYs51yhRE2Esn5tvH8ZX?=
 =?us-ascii?Q?HaYSfmgPET7Dp03eO/Jg73+JIvtEGPY7cT6TLKaqIwV7pstzquhQYk5nbJfJ?=
 =?us-ascii?Q?JrTiOqoRx4XZmUpnwuWl/KEgX6r1x2t/vmgktAH+AyGHSyRPQOe5c9o4FSD/?=
 =?us-ascii?Q?oeYJEAQqLT7io1FYb3TRjKln4IKSAkhnOfeyIELz1wwg1rkfhFzYQzQOuFhK?=
 =?us-ascii?Q?5m3I/j0z2AdTl/ICEo+XU0eUN3s7LdHgd+x4/8N2HeHvDZaIMHMDda4tvK2u?=
 =?us-ascii?Q?j4QcMak9/4PY5uIDF/UPG/nDU1kLwcFbZo4QrsdsADr7ZRWN5NCWYf+YeEjY?=
 =?us-ascii?Q?Z830b0taxbcDYw1gndnaJ0C6Uo68P2LduhDpplnxUrnTppvwh7NALoyu+T7L?=
 =?us-ascii?Q?3xDxOWq4yuEsqKNcXi4RuI+p0L6/TCiSGFMXWWhNG/g5llwtVJJamRxd50fD?=
 =?us-ascii?Q?d99IjuS1+ut49FI39+CMwTnBY6Umrb87Tv3GxwwCXDBknq9d3tl1h3e4FDl6?=
 =?us-ascii?Q?bLvEGWkaFg9kiiRKZFwDbAXESZ+ywAElnZUFui90huQgexRkeEWHc/TFw8JL?=
 =?us-ascii?Q?n9JN0Te44E11rkiKI4a6Ed2Xm8x2Lz4Ne+HvipebIY6v25+Pk384jxeMtFLh?=
 =?us-ascii?Q?sJBiAUkffGiEzRIfgUZ0huFjRFzOLstAKMy6NUTz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cf39d6-2ddb-4f61-0499-08dafeb3d298
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 09:09:11.1813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipPfmwu15LbvYO2URqWlx7UNPhqrhBMdak/FARUQJJH0izcMoHJIWVUnxWuTpID/EPHlZTuNjfrBol6XB2nBAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8154
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Bjorn Helgaas
> Sent: Thursday, January 19, 2023 5:16 AM
> To: linux-pci@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Brandeburg,
> Jesse <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org; Bjo=
rn
> Helgaas <bhelgaas@google.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: [Intel-wired-lan] [PATCH 7/9] igb: Remove redundant
> pci_enable_pcie_error_reporting()
>=20
> From: Bjorn Helgaas <bhelgaas@google.com>
>=20
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER =
is
> native"), the PCI core does this for all devices during enumeration.
>=20
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
>=20
> Note that this doesn't control interrupt generation by the Root Port; tha=
t is
> controlled by the AER Root Error Command register, which is managed by th=
e
> AER service driver.
>=20
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
