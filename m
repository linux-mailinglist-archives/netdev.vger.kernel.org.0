Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D07B66720E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjALMXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbjALMXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:23:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6331917E03;
        Thu, 12 Jan 2023 04:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673526214; x=1705062214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w22ALu6M42Nbr1FWw7o3agufp6Avkg4zbT4eYPaauTY=;
  b=D8mNV1AvDGQgpl/WwX4lexgmpP22HbNZ/xtrFDYAgexiGa23bQdUzqiS
   2fAeZH/pLwSxqdGLfqFeltVhSsoEIWIwGnODcZd/Lp9ziLklljobPVGA+
   iY61ATKtMbRGKzMJfYwjfHtpzq8cxUlj5/96rI6qu4zyJOKd2OibZsQe8
   03njLzkarTiOpzLc5+amyg4h7Ij2TVp9PA/DoKe3nutMDBsz4rZzp7fF5
   tDY26YuBREboETChyjs3ud4TOtAMTvUuxz/MWzh2UkyRZzALBpiqlvRNb
   8gK2SglsFzfhSL9yMEKz/86Av2OrTqoiGDM4WH6+VD8fsPL4Q2KeFH54l
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="323751249"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="323751249"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 04:23:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="746538065"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="746538065"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jan 2023 04:23:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 04:23:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 04:23:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 04:23:31 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 04:23:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+YrXKB/RCTo96wfAOwIdtnlTkwY1mhSMC0kv6G2ExduKrqpP1FAsBQhzPh7MRteiHPtUK3u6gs1MUaEwx63GIBGVyRvrND9NRTj8oEVRXOma4Cx70Q8x5og+OHJL7Djurx+WLgrf0Xrg+9bt/z23UXqoNGZTZ+hTkJwi1aGlS8pC8CNcxQrFrpcn3K2zbfQT7Rn2TIyHA20dKjlORTshkV6miopZyW+xjYZSDLuxQ5909wLQxOAvwecvrAUDLZDOYpCLQZPyFb3/+oC89q5tP9HF1m2yaYwF+7bZ8pOjAYlIJ8ri0wnpV82UPGzOtJv5zA0SCgLajy8OZkeZyF49Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4w/4/oJ2HEDUxn44sVgV8ykM3Otigw5eCBKplhOHIE=;
 b=Fe3CDhup31zgTUJRF1iQGUn0yUWmnAJprROOn2QbawUwAozQ+2hZtcM6KvlQeYIt1qWqiPdJWQp9fM2MXue6PK7NclN6KuNrdb1C6G3YO8DyenSe1JEwknrbO7RIYUVLXihQRdDkN8WxfXa965/uKnQ7mA3edufhWtcNdPqxSLLe4dOtWU3tB5pzu9ZHkd0IsP3Qzb05r+TriuyVYafBLCi4Cop3Gf8fW7nJ9RfbnX3ocReUOruzTiiloFd6/RWofnxJuo9l3ri2PCvtFCFcFaaJ5gwT6Pp5IjTynPO0p4MpXlhmkZxE2OQAj2qzBCwq3jHqrzZA7h+pC1+o2sAaig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BL1PR11MB5556.namprd11.prod.outlook.com (2603:10b6:208:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 12:23:29 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 12:23:29 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/66a+AIA
Date:   Thu, 12 Jan 2023 12:23:29 +0000
Message-ID: <DM6PR11MB4657BF81BEBC10E6EC5044149BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
In-Reply-To: <20221129213724.10119-1-vfedorenko@novek.ru>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|BL1PR11MB5556:EE_
x-ms-office365-filtering-correlation-id: 53c24ce6-4289-4ae0-8ad4-08daf497d00d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qO0nVBfI2KSU5T702EI8nCTicd+OXXgWTnxqkr8ZijxIn1A+L/Yo+Bvds7udAy8l7GJzgYQFEMTAEvMzynrwLhAKLk7h+tWNBxg5NkjHQ/ULsTJ7o/GxjiNOgmcDfg4CoQgODduizVwRL4ngBmjJG2FtTQbQYf3nF5XzmrU8hFAhFNUr9OSKE1OIKg2AkGj45NWbUVq7rjN0Td1oGFIZbwptDmnS/Ze5Z7xoKh5NkcXjvHSOZYsBNn89FOu3MH6lreb46y1HQQubz3zGa/CM08PGHW1uErVk6QMWDKI5dtZaUdXgBjsIVfpVeZccnAAoCjFPhZEwaLBmNB4Dqllai28ZotLeKuus9CZJGz6Z8gXdBzzI9KRvMzx3uTZBqquxDqxLVHo5Pk6aAHCivld4vfq9kVTKuRGezmHpiwx4IigtjBV1Ler5NGs/Ku6sVbt5aDBXvinsAWEihYe5DRoZ7kNRbiUIznl/t2j+swQR02vRzHVbcBbREULVkSlepqhqk/VMDLGNtWq2IgxlN5C1JjKRGIi2i7DHJysp2LCiyJYgMBxc4QBdj4tY5z+kgBO2Ajg1i/EIXEIwhOI+s+pu+TAa9WHggnju/jfG3ttw7FqrjDQqm3+RChBfFBoHVIFZ9L24BFiCA+3GGrJ//u4ri9KlI2zn906TFG6rIZJpbJZOr3+UICGt3L3ffEF/Z3H3sWLAo60CgLUoYWvZfQcdkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(122000001)(82960400001)(38100700002)(83380400001)(86362001)(38070700005)(41300700001)(66556008)(4326008)(8676002)(66446008)(55016003)(76116006)(66476007)(64756008)(54906003)(316002)(110136005)(66946007)(71200400001)(2906002)(8936002)(5660300002)(52536014)(9686003)(186003)(26005)(478600001)(7696005)(6506007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?efL2qpNemim1pmQEswKj1PY88lgubylZYi734Hkri5m1NMslES2hvOJhFvrx?=
 =?us-ascii?Q?jbK6urPBZpoZV631F1u+FUW/mCWpyhVnMO1LR1lNGM2WZoRKMwbKJn1DvpuR?=
 =?us-ascii?Q?vYGE5DUM45GOhqkj+FfVrTq2hn7mmJuUrYlqT17IYsLNOEUrYdSa1JzewJxr?=
 =?us-ascii?Q?vngLryi3fB3WQJdso/RqHo+BrrLFNJtYIyeFK61D8cWIvWnynLYRqJpjxWyW?=
 =?us-ascii?Q?9A/ruzrca2JYjx7VidiEFxtLmk+ggELqnkQU08r00VBv3wvjasbvowu6BWIa?=
 =?us-ascii?Q?wl7znEsXhd80kvdAyKpHAz8EzGhun6xB30hY+iUabbKLugyk33lwM0Bcx0sJ?=
 =?us-ascii?Q?PtobOg1y+RprTSoHJLYGuiRw1dx4hJoMklp29LLi4z54/lImeaDsQYKJGQEq?=
 =?us-ascii?Q?/jeJ+DIj+EvEREwK37v51HGSYAkrT34ycJ3LfWkqJzn3U+JuPeBhDXrurH1r?=
 =?us-ascii?Q?mplDZjrme6KdQ3Pr9urM+IHovjrMS4+V1IvLMdg3ohSvhxhLkuw4UApF9NS9?=
 =?us-ascii?Q?vG3ZQV5wE5wSwiNwKu+ZPAL5KQ5T0J6ASSmoaPGvGEPZ8FVNe1hXdqRgEJc6?=
 =?us-ascii?Q?cNRsJKW6G8KpBoRsytA3SwbJ/zs8ed2JA0dPZmuwAG+/5avaeLDEBxB+4b9X?=
 =?us-ascii?Q?LBFRAgphoZAuX3uU3EJbynTJR2loI0DZR9Udrmnn9cY89OiA2EbXL64CJGS2?=
 =?us-ascii?Q?qG35KmypNvrdaJjOzCDAjCFQ3ZdQJXp9F5zKdqtGsMid7gC8cC1SLKh9dnqo?=
 =?us-ascii?Q?9rcYmYVoVJ/N4Hp5NcFkkGEImEVwpgHKxQ0ZG0ugUScFPryiCT28EMMHNTmD?=
 =?us-ascii?Q?Wqip9TZ5OuE3UuksEfr72sDg7xKKfxAVq0xCCM5tm44Kw08ul5/3bgBVozPW?=
 =?us-ascii?Q?PJOFKRc1U5U6eUIF4gBy1uz97PhqL/ubZh4UKgOe3tokMX5vGrotxkPCuDjn?=
 =?us-ascii?Q?onmguztjG4OrqKUFVpZmtft2S+RH6WwqQCsn1VO/JJ01r/QLvJzA+mrLfKKr?=
 =?us-ascii?Q?lIe7eB5NTnI511YM0C0jO4yRjirvP2OeO5B1B5IBWWcCfzaXMlbCR5vmF9g8?=
 =?us-ascii?Q?Ibuqq1OzUdPqrZKZtcKMhy2rI1hMz/o5yzwzk+KbmApgvz87VX77DNqAnMWk?=
 =?us-ascii?Q?8Lnu0WnnbaEp+xPEKBDZ0D8AsI11f9iPi2EUTFGRkHZZM79qDQyOMeJ1jERy?=
 =?us-ascii?Q?UIMMApLLSYvprLBU8cCdIb8iyb8NisIwZQN+RZzVjEm3m+MznqoHKugvcWJv?=
 =?us-ascii?Q?fX8EJrPlSSLDULtkZDpEqQcn/Pmp64UDitVcTS9CcYD9HDG04t6UnQ6wqy9d?=
 =?us-ascii?Q?ALaKgcKcyyCDdsWoHQTO8aJBbV5zPGXN7SQpXvoW/kSHuDPyvnhU1+NxKC/v?=
 =?us-ascii?Q?eCwbyHh7OS9fT9hR/56x7To4kiWo+lLTOvVppRZ1+ZJs9fUquRqKspopdmaS?=
 =?us-ascii?Q?KnDidB2BU4Flnvgoxx11sZEOc5i0ctsiiEDR8QGiyg7vLCepaYGQEEoZJT53?=
 =?us-ascii?Q?MRTC4r+nIDoBy27GekGcY9xg80Wv0IqaiP+A21y2BsgSZtyuN9C5QhojKYGj?=
 =?us-ascii?Q?j+j+vhdClDs9C71knqqxsLtDLDJGrWbT3+1Ir5IJ8lK331ay5VJLj+rPoD49?=
 =?us-ascii?Q?mA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c24ce6-4289-4ae0-8ad4-08daf497d00d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 12:23:29.3977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tbp5klDMR8FQ4EjKdP3oDdhBX/hWnp4Mq0rVL7FfedYFnfncvH0AOZG5iMhY5h8lgfAyK8OQcVOZJoj3/ywfz664/BML5z4uAiHRgJ51sIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Vadim Fedorenko <vfedorenko@novek.ru>
>Sent: Tuesday, November 29, 2022 10:37 PM
>
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and make i=
t
>flexible and easy to cover special configurations.
>
>v3 -> v4:
> * redesign framework to make pins dynamically allocated (Arkadiusz)
> * implement shared pins (Arkadiusz)
>v2 -> v3:
> * implement source select mode (Arkadiusz)
> * add documentation
> * implementation improvements (Jakub)
>v1 -> v2:
> * implement returning supported input/output types
> * ptp_ocp: follow suggestions from Jonathan
> * add linux-clk mailing list
>v0 -> v1:
> * fix code style and errors
> * add linux-arm mailing list
>
>
>Arkadiusz Kubalewski (1):
>  dpll: add dpll_attr/dpll_pin_attr helper classes
>
>Vadim Fedorenko (3):
>  dpll: Add DPLL framework base functions
>  dpll: documentation on DPLL subsystem interface
>  ptp_ocp: implement DPLL ops
>
> Documentation/networking/dpll.rst  | 271 ++++++++
> Documentation/networking/index.rst |   1 +
> MAINTAINERS                        |   8 +
> drivers/Kconfig                    |   2 +
> drivers/Makefile                   |   1 +
> drivers/dpll/Kconfig               |   7 +
> drivers/dpll/Makefile              |  11 +
> drivers/dpll/dpll_attr.c           | 278 +++++++++
> drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
> drivers/dpll/dpll_core.h           | 176 ++++++
> drivers/dpll/dpll_netlink.c        | 963 +++++++++++++++++++++++++++++
> drivers/dpll/dpll_netlink.h        |  24 +
> drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
> drivers/ptp/Kconfig                |   1 +
> drivers/ptp/ptp_ocp.c              | 123 ++--
> include/linux/dpll.h               | 261 ++++++++
> include/linux/dpll_attr.h          | 433 +++++++++++++
> include/uapi/linux/dpll.h          | 263 ++++++++
> 18 files changed, 4002 insertions(+), 37 deletions(-)  create mode 100644
>Documentation/networking/dpll.rst  create mode 100644 drivers/dpll/Kconfig
>create mode 100644 drivers/dpll/Makefile  create mode 100644
>drivers/dpll/dpll_attr.c  create mode 100644 drivers/dpll/dpll_core.c
>create mode 100644 drivers/dpll/dpll_core.h  create mode 100644
>drivers/dpll/dpll_netlink.c  create mode 100644 drivers/dpll/dpll_netlink.=
h
>create mode 100644 drivers/dpll/dpll_pin_attr.c  create mode 100644
>include/linux/dpll.h  create mode 100644 include/linux/dpll_attr.h  create
>mode 100644 include/uapi/linux/dpll.h
>
>--
>2.27.0

New thread with regard of our yesterday's call.

Is it possible to initialize a multiple output MUX?
Yes it is. Let's consider 4 input/2 output MUX and DPLL it connects with:
            +---+  =20
          --|   |  =20
  +---+     |   |  =20
--|   |   --| D |--
  |   |     | P |  =20
--| M |-----| L |--
  | U |     | L |  =20
--| X |-----|   |--
  |   |     |   |  =20
--|   |   --|   |  =20
  +---+     +---+ =20
=20
Basically dpll pins are initialized and assigned ids, like:
5 inputs (0-4), 3 outputs (5-7).
   +---+  =20
0--|   |  =20
   |   |  =20
1--| D |--5
   | P |  =20
2--| L |--6
   | L |  =20
3--|   |--7
   |   |  =20
4--|   |  =20
   +---+

Then we would create and register muxed pins with existing dpll pins.
Each muxed pin is allocated and registered with each parent it can provide
signal with, like below (number in bracket is parent idx):
                           +---+  =20
                        0--|   |  =20
                +---+      |   |  =20
 8(2) /  9(3)---|   |   1--| D |--5
                |   |      | P |  =20
10(2) / 11(3)---| M |---2--| L |--6
                | U |      | L |  =20
12(2) / 13(3)---| X |---3--|   |--7
                |   |      |   |  =20
14(2) / 15(3)---|   |   4--|   |  =20
                +---+      +---+

Controlling the mux input/output:
In this case selecting pin #8 would provide its signal into DPLLs input#2 a=
nd
selecting #9 would provide its signal into DPLLs input#3.

BR,
Arkadiusz
