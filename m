Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA05463B66F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbiK2AOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiK2AOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:14:12 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B5A1DDC2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669680851; x=1701216851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PZL9a2G1XqFtgXc7om6rCk4l6wcnrQe1W+7arFDw2bw=;
  b=eNfj4J3BaOUwhQC4rR58Z18DwSGmLIL9TGTrTDzEtXZFfm21DBa5gKLl
   j9Fm0vDaGDF0fX8VXfGzcRzHceKyxbaa2KQC603Hs7UsMTe8J3+kltcdh
   2jgDvzRM3qpPwfa7ow4ZWH+bofcGMxhYK8PptYchB59OO09SV3bwujC2z
   ToDGoQrsKaj3vH89sxUGKVE+6glPk7s4vMr2LHj7kyecbBqMlCpmYYChO
   EYLoZ+y+ICllGIb0g90p8GM1FZSH6u3F71db2qL+cKb9KvPzaKyY04uUL
   1dPT+XDK422wrrC2IphTElBVXyiJ1+rDLnpK/mp8EsJmQxvEBgWOrCi4/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="312604738"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="312604738"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:13:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="749605083"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="749605083"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 28 Nov 2022 16:13:47 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:13:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:13:46 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:13:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOOwaToeymRMe7l75MAzBf3fFH0fQO7x0j69+/sRaV1PHBvwE2ifThuUHGOTL9D50Jx8oEsvLmGabYpTNTEGlZtFItkkJ4BAepqaI6gw61N0KtlHTXNz+F5h/N6l4+ZqBR4Tmijw3TcG4KiI2fWmxlRxWbBm4HU/4iHmFC0w4MVD0NoVCoJR/sl5GKM/Kj6BEvkdDXEr+4uaWh8Nth98U83GYQ0RSBj3DVV/lKWYYTDF58ubrsoQrw+HwQKlB0rS1tagQu/+g7MKOTY/x0ZgrwSGGmm7j58lkiA986LUQnlCfjunR+EROLLt9rg+QSywdnO1EDTjPt0gPGISd3felg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fc5iHWglRnkSgACiHovkRw/ZJNsQBShLA2I6FVVfs6Y=;
 b=kRSNNX+OmdWEKs7sEN6SsU6QGDhO0+sTxbuWvqgagfbPHW/twm8TCm1SflIfCV109QcqY1GD6UOoPq5xyJkwJ9ArDKzRBPpuITGmdEjsp0XJ8nSLMUNjM+qXI7p/JSMX+k6kKnkkIBikrC8pvDAbrZi+M6vNKy28gbBH7RQsDGSmSgMMMhJ7IKZDH6z9jg0UhzQEAZ3m7u/Te3ZQxVWLIIyXW9eGneRnCnTmukwd3jlBzs64JGhdvU31YdVhy0WB6vIn9zUfq7jTcDaf81niRkec9NF80WPg4tFsmNeL9FFB05+LRkTnR9f7/vLp/LIPM8dalCBhCkN8fOFuIJmxNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN0PR11MB6087.namprd11.prod.outlook.com (2603:10b6:208:3cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 00:13:44 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:13:44 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shannon Nelson <shnelson@amd.com>
CC:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "drivers@pensando.io" <drivers@pensando.io>
Subject: RE: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Thread-Topic: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Thread-Index: AQHY+6OB9jIRuo/XUEmDcCW4ZuKVkq5UtsWAgABCrACAABLagIAACeUw
Date:   Tue, 29 Nov 2022 00:13:44 +0000
Message-ID: <CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-7-snelson@pensando.io>
        <20221128102709.444e3724@kernel.org>
        <11905a1a-4559-1e44-59ea-3a02f924419b@amd.com>
 <20221128153315.11535ddd@kernel.org>
In-Reply-To: <20221128153315.11535ddd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MN0PR11MB6087:EE_
x-ms-office365-filtering-correlation-id: 497ca9ab-3bf0-4099-33a0-08dad19e941a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DS7j9aJME7nfIgF4Y1h/OhZTXKnxUC5GA9nusqfFfWR+y2x0/z5rTq/qhD2CuRnxOOCjb0CZ/Y8m/VGfdNn1qJP7LqOlfRajwB5RQ02lrtOWNYXFHHSPAXVqgCWo54uB20pkr95tWdU+cAJhtAwB00NoFwMDhLx7FZFRFXCFnbSxjuSzFd+5IiVWOiE57bbg/UtX/3kInjg6pmGxOrK+SXukSRAXI6CtLIOp3m5miG3sNOLKKGLv5os0be+r1pUf8Pm9QA8oSsDxUz9VKjzOdT3w3ctEkHzMEfhsN36lWLe/wzWRLwu/xcatK19aZ4r67QPN1qnN7Z5xTFWKGpOu2KSkGCoN/oV9YO1HHYa1Om9844Hc38AOiE9lxGzKKmKe7ViUE4sMNYYZRSTdQFFYa3Hj3TynD9KE1tiO7ITE5ahrFIcyb2cL9vcM57rc2z7Th2ff/R6TGZFEGF/b6dq23+L36lg72hl4vH4lIXaqNQWVnRkDdi+0tfuwYqt0wDQ+S9p0w01CBEYjMqWzt/+Zq+xa4dNK+Wcw9TELXOfFqVnLf2QuygNu5W0zrKGRS/3iOmUadDKTQo7Oi9HKw4GgmgRsZggz1hmW4YQ1UMKfqZVqZbHp3vSNPgAktPHFGeXUwHNXEmRCepzD0DYjkQ0nxNCTBr1pvU9MwpyOcD3lSvU0TzCTYxGiB5SjVE8wNzyVKSo9lYyLmcpuP3qE4Ni+fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(38070700005)(52536014)(33656002)(55016003)(64756008)(66446008)(8676002)(66556008)(26005)(66476007)(53546011)(9686003)(86362001)(8936002)(41300700001)(66946007)(76116006)(6506007)(4326008)(478600001)(7696005)(71200400001)(54906003)(110136005)(38100700002)(316002)(122000001)(5660300002)(82960400001)(2906002)(15650500001)(83380400001)(186003)(66899015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q1ZUTRdPXXTWV8pjZGWOYZnPovFr1qeaT9FZtGybBfyWFRbp2FhouAjJDzdt?=
 =?us-ascii?Q?AtqfokMpycHTsrURZRAqww1IVkwgdBKFhVX8ibUA3V+xMYTJvqWM8jny5XIw?=
 =?us-ascii?Q?w0CvaYsZdSaDGzgUgNI3xe2fIwS6ynh0k7XlFoKRBRivsc/JWRsBPCyj6M79?=
 =?us-ascii?Q?JdDHPUF0EdKgB+FPWSNTTEvxjpw1/VVRPUJtfRK5tf++q4N7mlxrnvfEjQxs?=
 =?us-ascii?Q?LOxjTgocQpfpPxZMgeToommkjCD8641NhNyA71zPTaR7aN/1t/zOiNCbsPSA?=
 =?us-ascii?Q?+phMI++7F7Y5GLddSN0afIm7OpignqOPoemux7Oa+K3wppu0TL7hZfJpT9R/?=
 =?us-ascii?Q?SOf0sEph75iWi+b7dEAvtLVnScINr1An4VAzkyPD4LFW2wJ2Y/xJBkS85svl?=
 =?us-ascii?Q?2YFGDPCgm6pis/9QAZIxWTK+34sRH/oxHIcurVat336G0fnJdxHkS6O/jdqf?=
 =?us-ascii?Q?mqv8QWvbt+z5jV3oTIOZKL5C/kWWXzh+oSkURMmtAADobGn13N1XSsyARGF0?=
 =?us-ascii?Q?yKTGtNPh9QfP7xlJnrlV9zNvrRWIff3QXUra+UUAGOc2boaz5nJSS4XcvWS5?=
 =?us-ascii?Q?VvipNp7Rpcl72xqX9igA6Xip3HvHheZQgRf0r9mNzl15bPebWwxiDb0CO+8w?=
 =?us-ascii?Q?UNVOo0XeghLbH83Kp3ODpmyvxqH0q9npkYkTvBp+RYlGwTuXn7CLidpf0b8X?=
 =?us-ascii?Q?hWUAzVPb/oXjl1owE6RosSEBQt0jspzpYY7NLWRLfY9K4Q0c1OSdzg1einc2?=
 =?us-ascii?Q?lKsvYfkAzroUtEhDWmtLgYXQfLXmM8WsztYWTJEiGemQslRoPaceGN2WuWL4?=
 =?us-ascii?Q?3yYr01XrfSITm8BK2+eCCI/yag2CjZTOnHUffs5zwDZ7tSr/aUHvB5XHtIRp?=
 =?us-ascii?Q?P15AvQsk9+P9TxGmvKRm15kpNxD3CVj930ECHi/OsdNNqbci1ZQ7+/WhaiSQ?=
 =?us-ascii?Q?J90y5W/P+Rz3uf0Fz2IvAeBjGRTdvxI9wLyOe61yCS4yKTR42Ka3eFlxn48W?=
 =?us-ascii?Q?kcyNsyTTE2e9I2jGFhHmFO85EmTYJDT2GF97DhRhNyg/F0k4ma2u51vu63if?=
 =?us-ascii?Q?qR+X5lzQvtvuZMDlyN+44A4pV0e4XupoFFXK9rxkaW7xhB1bk3zont38J7rE?=
 =?us-ascii?Q?fpurEaNfvdgjzE4U/H+qqKiSgUTPd5lI/EM8flR15h6hBgVrY8vJR+K6SrBJ?=
 =?us-ascii?Q?9MWMJTCCBBpijMEYfDjdSx9tqXdnemHr7mMKDr2gugQicdmojZdVXMKyYKxQ?=
 =?us-ascii?Q?CpA4fZeqx+yxonziABj2hjKoqVDsYo6gNW/Akw5Fd2nTCTZ4ORx6oY2uaBL9?=
 =?us-ascii?Q?HeFHIVVe05oDAbY0T8C5XBQcVVD1u1upuTJtRjs1gXyRKimELohEiBRPdzTd?=
 =?us-ascii?Q?vEcv4o2MH5zp0jgxm5+X73e/negANibRKX45BFOISx72c2qLdApceUcDLOR6?=
 =?us-ascii?Q?eeA/5E9j5kanYJ7hZ9QkfCBgnYc5uiQuc27z+vliMY+qwWhkTC34jkKZXMJS?=
 =?us-ascii?Q?YWIqPV0Y4WzUiYrvCESGFu7AhrNjFVZEZdS5AiOtzFP94cd1r1wpav8fCxys?=
 =?us-ascii?Q?fn8SYLpACcp5gg+j6PPHygdeeIO70G7UMpoEwQ2I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 497ca9ab-3bf0-4099-33a0-08dad19e941a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 00:13:44.5973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkpcu9TqLaDlPSRoLDXz0ZbAZeHPHWPIve3otO/WrTSVxz02rDbo37PgRRBHHBXCQIkpJsdeXv1LqWDctIdFue+oooMpPKNRG6v5+BKRXkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6087
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, November 28, 2022 3:33 PM
> To: Shannon Nelson <shnelson@amd.com>
> Cc: Shannon Nelson <snelson@pensando.io>; netdev@vger.kernel.org;
> davem@davemloft.net; mst@redhat.com; jasowang@redhat.com;
> virtualization@lists.linux-foundation.org; drivers@pensando.io; Keller, J=
acob E
> <jacob.e.keller@intel.com>
> Subject: Re: [RFC PATCH net-next 06/19] pds_core: add FW update feature t=
o
> devlink
>=20
> On Mon, 28 Nov 2022 14:25:46 -0800 Shannon Nelson wrote:
> > I don't think Intel selects which FW image to boot, but it looks like
> > mlxsw and nfp use the PARAM_GENERIC_FW_LOAD_POLICY to select between
> > DRIVER, FLASH, or DISK.  Shall I add a couple of generic SLOT_x items t=
o
> > the enum devlink_param_fw_load_policy_value and use this API?  For exam=
ple:
> >
> > 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_0,
> > 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_1,
> > 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_2,
> > 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_3,
>=20
> Not the worst idea, although I presume normal FW flashing should switch
> between slots to activate the new image by default? Which means the
> action of fw flashing would alter the policy set by the user. A little
> awkward from an API purist standpoint.
>=20
> I'd just expose the active "bank" via netlink directly.
>=20
> > I could then modify the devlink dev info printed to refer to fw_slot_0,
> > fw.slot_1, and fw.slot_2 instead of our vendor specific names.
>=20
> Jake, didn't you have a similar capability in ice?
>=20

We have two banks of flash, the active bank, and an inactive bank used for =
updates. We can determine the active bank from the Shadow RAM contents whic=
h are generated as the EMP firmware boots up.

> Knowing my memory I may have acquiesced to something in another driver
> already. That said - I think it's cleaner if we just list the stored
> versions per bank, no?

I think it would make sense to store them per bank and make the bank number=
 some index instead of something separate as like this DEVLINK_PARAM_FW_LOA=
D_POLICY_VALUE_SLOT_<X> where each <X> makes a separate parameter.

Currently devlink info reports "stored" and "active", which aligns with our=
 current use of the active vs inactive flash bank. We could be explicit and=
 indicate which bank it is, though its a bit tricky since most of the firmw=
are interface deals with it in terms of "active" and "inactive" rather than=
 the absolute position of "bank 0 or bank 1".

Especially if another device has more than 2 banks I think its a good exten=
sion to devlink info, and we could probably get away with something like a =
new info attribute that specifies which bank index it is, and an attribute =
which indicates whether its active or not.

Thanks,
Jake
