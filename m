Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC86BD08B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjCPNQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjCPNQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:16:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B1BBAD33;
        Thu, 16 Mar 2023 06:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678972588; x=1710508588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XfQvzi77tOT40iWIT2TB0u7oyNG/J+nQHHg3UISHJqk=;
  b=XHNpzuY05MeZs30V2ZGVNohmLtgxAavxMiwFM8gddfqfWZfgrZUyZYd4
   4HwCnMxmOa24k9810ovuqNorZKUuvY90bZjfgmDymrgG8a1VrnbwTHC2P
   MqycKK0t0EZeN8MPv3IpMaYKh+KHvLdts2J1tbwPaIy3BP7aBO5RXDqNJ
   4GbO84Gpkw3iuHEtjNb6sci1A12yOggOlaoY58/zCyhPS9uCBHcPs3ah1
   4xTHjCWZY2kakb/GOrvqnPxCFhBbkFln9uHI62VwsgcGeEBzIawnzmKJO
   CUwrDIF5Jf92j0fyLrQ6BQ5nQ0XZmNFD9DXEAhBGCtu33L4ICISVs8z+t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336674654"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336674654"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:16:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="682308575"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="682308575"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 16 Mar 2023 06:16:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 06:16:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 06:16:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 06:16:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 06:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7j0pAER89Js7ggqRJ8MUvhig39HXl4ZulPE4dvi9R7saqSRBuZusEOid8kAhGD4pOevhXAZ67Jt2xyOztkNKUd+pXJNnEI10cW/rjbk9DRRmnXb/0c2c3NzbQbvd+9nodC89GYfpbt/He35Gs2EqnbU8XYzuQbRU1Olw6Z1SbC/EAoyxDPLp1uBPnTfYy+AkdWcijwd87AnMpQp+o+2HfwJ61/E6jKGWlDZQ/+TxU1jNxWi3X1yiiJOHi9ISYdfqtuUNoR7RyazCyEo2TD8X0q27k7UNS6Id3gRD5hzD4ateQAUiYoUMcAhn65amvrGYwpdIU5dvSxbJEq1aNL+fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuLXtsCT3TM//s/u1C3PZH2pP8IGYTGxzc7dwpWMTqM=;
 b=L4+9+samyrXFQMcOcldWbVjozBTWNCVa2D0dWuI4dDQ4YPcFs0cjdMdLyt0zcYDux9lTjcCKQhFp7KUuZfX+N9eKPn5nAUk6/w0/IRuenq06ncP0eVUT/U75WbFIK7Jj9tz3oZEb5cGRMpXNIg6jetijBcGwoqerHzIY9GFoO/k6en7yr20fGvSbUfjr/61yHjY/E/AHSafbKfUQM1VW9IYI9KeXnjzkO9GtNBi69TdzQjXMpaI/SWLy4KNPxBbNSkeC5psUwCejVDmhNAgMW8qF8o2Ql2bkMlJcMUxA7GLPDnNdMfN+gZrQ7zhpZbQe9cS0cjv+uVmyT/FiQINmiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SN7PR11MB7707.namprd11.prod.outlook.com (2603:10b6:806:322::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 13:15:59 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6178.029; Thu, 16 Mar 2023
 13:15:59 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZVIpWqQ/E3o2ZU0SoOV6Pk96rvK76Xc8AgAML3PA=
Date:   Thu, 16 Mar 2023 13:15:59 +0000
Message-ID: <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com> <ZBCIPg1u8UFugEFj@nanopsycho>
In-Reply-To: <ZBCIPg1u8UFugEFj@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SN7PR11MB7707:EE_
x-ms-office365-filtering-correlation-id: b3f2966c-9d06-4867-bfca-08db262095c0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZNNRcdHmrjHXW1fJs2gp8S7947zKdbSpwB7X84HT2n6H84QWWziRWcX2LIePXs/H4KLvJvW05DfqOK/suc5XSs+ReDkZPBZoiV0RHAHZYTcfGHOpqNZBqaZM7G3Rs1MmfXbdvS1D0yKOvU/OD2NLLouWzozxpX21ae6E6i+iN1F10dZW1gw/fmf2A8F4cCOUJVOpA3bK4snrwKHlcLlhZGV/nsgLtzTVIOccmpXFDsqP73ElNPXx1K6+xqsuTzW4tbCnXDHcgpxQ1jjRGhn+XAageRsbvnAoDjKhw2ANtDFd8D6wGqwcaDhAzVMHG5TMG0NN7fhoORzYZynJwe7afCMw2wUWZb99sGoB5Bvhl7KtrAJpCRZaW6O/b86OOG6uQybKks1KlWMoXr2JSEnLDLQOzTgk7ZQEdC63MoJwVruPccsE+WMlUgbsJIZFHlnfksM8Guh46bkRSuIEOXtagv3l6umEHS1D8AjtHp5NQvw18aLC3Z+bsLVgF+yoCkMI2fBFrddLaWzFbfPaSLzLCEtKPfKHa7iUlhRAACewvN2ed7i9d7yhWAyJhaRxykOl2OFoUOerNBlyD+WuHwiE9v8LLW/5poCJqSPB5eAMyn2FITlCENIoBnFT2D8p56HdRYCbuSrKxx8OTklhZ+UJO1J1EqEcAKvssUj70ZmBDQoAvAer5B+igh1/6jft/MPexYS10rd2WX5IMtb0nDNmJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199018)(38070700005)(76116006)(64756008)(478600001)(7696005)(9686003)(66556008)(66476007)(66946007)(66446008)(7416002)(82960400001)(33656002)(71200400001)(122000001)(107886003)(6506007)(26005)(52536014)(41300700001)(8936002)(5660300002)(8676002)(110136005)(316002)(83380400001)(55016003)(4326008)(186003)(54906003)(2906002)(86362001)(30864003)(38100700002)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3jflZL+G+BTsAAKMkkmmoxiY8l7pOGEAbUjv2i5OZfFun5qAmtgRnMbzrmDP?=
 =?us-ascii?Q?S7Ymbg9zcKgrEMArzW757rF9qW4U9GfsY9Ue5uCKRXNuuoLHvCI3wToao+Mf?=
 =?us-ascii?Q?ZX/s6r9ziCcZrOHzVjjPQ13jgTR5BjvO6oJlC/m1CSvLlyAoj7A3EB/6EQsy?=
 =?us-ascii?Q?XyqJJytgKdbdoVfC1Qh1Vs9myP3cFK2lu9B2BF56v27bj+v8psxfWN9z/eQo?=
 =?us-ascii?Q?QliNzog06c5A7oLYfyt3RYuXU+S1Ak2EIxtpTCidGWKpgoqW4JcjJe1J41aJ?=
 =?us-ascii?Q?L+33OtAzxIj6oHPCSq10NkEkWXZiho8Wi6WFyU15LEJ1xIZRqojiPqvG0gRL?=
 =?us-ascii?Q?h7SQZEL2EPj3KS3IyxK7syVP6MWojB7fg2PCn3GhYIhfR9h56JdeMvKbUJiA?=
 =?us-ascii?Q?Qp9T3ufw1wS1/4+pN51CpGaxDsQABQm9D//xPZo/OI02y1qtYMr4QYoGAGcK?=
 =?us-ascii?Q?mx0FIEFP0kv7fYMIns/hxZadYgS/Doibq8++p6QlH/2EuooZ2fvKmg9sVvSK?=
 =?us-ascii?Q?QlhyJRc/Fz/mgEVJIqvyBcc1aVKBlp6/5cQcuXT4QJ1t/yEgK8zeueHt73VA?=
 =?us-ascii?Q?PCUNIHMsEXkmcrBtmkFKFxl1vD/flCXD/hA7tCpgTpyFofI6JUPkvD13gRty?=
 =?us-ascii?Q?dIUaRAwCe5ZgLvGwXRraVUZRwYJZHCZ7wFVLC1oYjPMDSnPcEtbn76gdSS+j?=
 =?us-ascii?Q?cE6NUcdM3ynmxq+asGq4vuU4GIj3Y9DP7hTabidOTpHYhh+dziKDsvz6GFGI?=
 =?us-ascii?Q?f9JI80RLMSttGDXJb8VT8/Wat9WxokMkM/PhmAVdosoCKRy7Tdbmxvd8E3kX?=
 =?us-ascii?Q?Zg+ZquGQ60VUXzho8r5huIrBaKHM/v3MrkJyhVA8/N1Lgr2U1DrUnmnzw0zJ?=
 =?us-ascii?Q?4kuchgPI69aVWa31w2cbLIct2Gj/8dfFUdP8YcDxgXEgDYWqV2wSsp1HuWUG?=
 =?us-ascii?Q?Zw+ihZ0eQMBtNtX8EzZXJ6WRSyiwtYzxFLOBj6BWgEbhm+E6zph3NPnB0vWz?=
 =?us-ascii?Q?BxvQQNkWLgTXninw46Df7LorW+xGc9SPFhxoTSgJZ/8cu2MEvffNNC84ZVri?=
 =?us-ascii?Q?i0TmGSIReTTAoAD1KkoOA/Ki+4kmCZybMBJP08oIJF7crwQS2IrLMArdIcC+?=
 =?us-ascii?Q?Ru1eERJ0TyzNwzzMjlmWzAH1KRBhhmPyxqdXamEViAhgQ6BtH2VZJ6QvgrMX?=
 =?us-ascii?Q?42CZeI8eKLXTxO21YZ8qA6PveV36NwyILTxBlYriq/tjEbNyQb2IAYQ4qGD3?=
 =?us-ascii?Q?YF2dJyT0Pz742hNDOH8daQ9kOTdh2zf+Pjf03bxgvE9zRd+rzbfQUrOZ1S/D?=
 =?us-ascii?Q?dnnenkVGaKYDAsgCuF/vPpnzzaqXQmmrQwJlHyweNOLEXAh18pH4YHXgODFM?=
 =?us-ascii?Q?ywPSWw7gsPWOHDSx+hzu0qHHPVG78/8Ru+Bzx4erTraCQiECld9PhI43Z/VW?=
 =?us-ascii?Q?OglvBWTF/bXVFaJpNYkQg9sdy124vA+KLRr76uPBOW/EUOWtJypvGRXZXwIc?=
 =?us-ascii?Q?VrjseqaPDsb54RqYbYYsKDWFzBi8SnbZEzdV17C+mMDuK3Uo8Bghw/wLiQDK?=
 =?us-ascii?Q?23u7YdZgz8W8z1/zBulG3TZOvpX/tBVC5iAnEgcVMd3gS5ZI9joYo+kLyQRT?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f2966c-9d06-4867-bfca-08db262095c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 13:15:59.5678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQhXF4s/LCBm24xGz7O12WuGq/BW4+KeHGGKikvIvFDzlgQkM5EoYhAAGito6nxdgfx1dwS6PbIOUKRsPl4KSmqCGgyTSF4HLlHXPuDmvQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7707
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, March 14, 2023 3:44 PM
>
>Sun, Mar 12, 2023 at 03:28:02AM CET, vadfed@meta.com wrote:
>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>>Add a protocol spec for DPLL.
>>Add code generated from the spec.
>>
>>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>---
>> Documentation/netlink/specs/dpll.yaml | 514 ++++++++++++++++++++++++++
>> drivers/dpll/dpll_nl.c                | 126 +++++++
>> drivers/dpll/dpll_nl.h                |  42 +++
>> include/uapi/linux/dpll.h             | 196 ++++++++++
>> 4 files changed, 878 insertions(+)
>> create mode 100644 Documentation/netlink/specs/dpll.yaml
>> create mode 100644 drivers/dpll/dpll_nl.c
>> create mode 100644 drivers/dpll/dpll_nl.h
>> create mode 100644 include/uapi/linux/dpll.h
>>
>>diff --git a/Documentation/netlink/specs/dpll.yaml
>>b/Documentation/netlink/specs/dpll.yaml
>>new file mode 100644
>>index 000000000000..03e9f0e2d3d2
>>--- /dev/null
>>+++ b/Documentation/netlink/specs/dpll.yaml
>>@@ -0,0 +1,514 @@
>>+name: dpll
>>+
>>+doc: DPLL subsystem.
>>+
>>+definitions:
>>+  -
>>+    type: const
>>+    name: temp-divider
>>+    value: 10
>>+  -
>>+    type: const
>>+    name: pin-freq-1-hz
>>+    value: 1
>>+  -
>>+    type: const
>>+    name: pin-freq-10-mhz
>>+    value: 10000000
>>+  -
>>+    type: enum
>>+    name: lock-status
>>+    doc: |
>>+      Provides information of dpll device lock status, valid values for
>>+      DPLL_A_LOCK_STATUS attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: unlocked
>>+        doc: |
>>+          dpll was not yet locked to any valid (or is in one of modes:
>>+          DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>+      -
>>+        name: calibrating
>>+        doc: dpll is trying to lock to a valid signal
>>+      -
>>+        name: locked
>>+        doc: dpll is locked
>>+      -
>>+        name: holdover
>>+        doc: |
>>+          dpll is in holdover state - lost a valid lock or was forced by
>>+          selecting DPLL_MODE_HOLDOVER mode
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-type
>>+    doc: Enumerates types of a pin, valid values for DPLL_A_PIN_TYPE
>>attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: mux
>>+        doc: aggregates another layer of selectable pins
>>+      -
>>+        name: ext
>>+        doc: external source
>>+      -
>>+        name: synce-eth-port
>>+        doc: ethernet port PHY's recovered clock
>>+      -
>>+        name: int-oscillator
>>+        doc: device internal oscillator
>>+      -
>>+        name: gnss
>>+        doc: GNSS recovered clock
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-state
>>+    doc: available pin modes
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: connected
>>+        doc: pin connected
>>+      -
>>+        name: disconnected
>>+        doc: pin disconnected
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: pin-direction
>>+    doc: available pin direction
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: source
>>+        doc: pin used as a source of a signal
>>+      -
>>+        name: output
>>+        doc: pin used to output the signal
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: mode
>
>Could you please sort the enums so they are in the same order as the
>attribute which carries them? That would also put the device and pin
>enums together.
>

Fixed.

>
>>+    doc: |
>>+      working-modes a dpll can support, differentiate if and how dpll
>>selects
>>+      one of its sources to syntonize with it
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: manual
>>+        doc: source can be only selected by sending a request to dpll
>>+      -
>>+        name: automatic
>>+        doc: highest prio, valid source, auto selected by dpll
>>+      -
>>+        name: holdover
>>+        doc: dpll forced into holdover mode
>>+      -
>>+        name: freerun
>>+        doc: dpll driven on system clk, no holdover available
>>+      -
>>+        name: nco
>>+        doc: dpll driven by Numerically Controlled Oscillator
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: type
>>+    doc: type of dpll, valid values for DPLL_A_TYPE attribute
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: unspecified value
>>+      -
>>+        name: pps
>>+        doc: dpll produces Pulse-Per-Second signal
>>+      -
>>+        name: eec
>>+        doc: dpll drives the Ethernet Equipment Clock
>>+    render-max: true
>>+  -
>>+    type: enum
>>+    name: event
>>+    doc: events of dpll generic netlink family
>>+    entries:
>>+      -
>>+        name: unspec
>>+        doc: invalid event type
>>+      -
>>+        name: device-create
>>+        doc: dpll device created
>>+      -
>>+        name: device-delete
>>+        doc: dpll device deleted
>>+      -
>>+        name: device-change
>>+        doc: |
>>+          attribute of dpll device or pin changed, reason is to be found
>>with
>>+          an attribute type (DPLL_A_*) received with the event
>>+  -
>>+    type: flags
>>+    name: pin-caps
>>+    doc: define capabilities of a pin
>>+    entries:
>>+      -
>>+        name: direction-can-change
>>+      -
>>+        name: priority-can-change
>>+      -
>>+        name: state-can-change
>>+
>>+
>>+attribute-sets:
>>+  -
>>+    name: dpll
>>+    enum-name: dplla
>>+    attributes:
>>+      -
>>+        name: device
>>+        type: nest
>>+        value: 1
>>+        multi-attr: true
>>+        nested-attributes: device
>
>What is this "device" and what is it good for? Smells like some leftover
>and with the nested scheme looks quite odd.
>

No, it is nested attribute type, used when multiple devices are returned wi=
th
netlink:

- dump of device-get command where all devices are returned, each one neste=
d
inside it:
[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id': 0},
             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id': 1}]}]

- do/dump of pin-get, in case of shared pins, each pin contains number of d=
pll
handles it connects with:
[{'pin': [{'device': [{'bus-name': 'pci',
                       'dev-name': '0000:21:00.0_0',
                       'id': 0,
                       'pin-prio': 6,
                       'pin-state': {'doc': 'pin connected',
                                     'name': 'connected'}},
                      {'bus-name': 'pci',
                       'dev-name': '0000:21:00.0_1',
                       'id': 1,
                       'pin-prio': 8,
                       'pin-state': {'doc': 'pin connected',
                                     'name': 'connected'}}],
           'pin-direction': {'doc': 'pin used as a source of a signal',
                             'name': 'source'},
           'pin-frequency': 1,
           'pin-frequency-supported': [1, 10000000],
           'pin-idx': 0,
	...

>
>>+      -
>>+        name: id
>>+        type: u32
>>+      -
>>+        name: dev-name
>>+        type: string
>>+      -
>>+        name: bus-name
>>+        type: string
>>+      -
>>+        name: mode
>>+        type: u8
>>+        enum: mode
>>+      -
>>+        name: mode-supported
>>+        type: u8
>>+        enum: mode
>>+        multi-attr: true
>>+      -
>>+        name: source-pin-idx
>>+        type: u32
>>+      -
>>+        name: lock-status
>>+        type: u8
>>+        enum: lock-status
>>+      -
>>+        name: temp
>
>Could you put some comment regarding the divider here?
>

Sure, fixed.

>
>>+        type: s32
>>+      -
>>+        name: clock-id
>>+        type: u64
>>+      -
>>+        name: type
>>+        type: u8
>>+        enum: type
>>+      -
>>+        name: pin
>>+        type: nest
>>+        multi-attr: true
>>+        nested-attributes: pin
>>+        value: 12
>>+      -
>>+        name: pin-idx
>>+        type: u32
>>+      -
>>+        name: pin-description
>>+        type: string
>>+      -
>>+        name: pin-type
>>+        type: u8
>>+        enum: pin-type
>>+      -
>>+        name: pin-direction
>>+        type: u8
>>+        enum: pin-direction
>>+      -
>>+        name: pin-frequency
>>+        type: u32
>>+      -
>>+        name: pin-frequency-supported
>>+        type: u32
>>+        multi-attr: true
>>+      -
>>+        name: pin-any-frequency-min
>>+        type: u32
>>+      -
>>+        name: pin-any-frequency-max
>>+        type: u32
>
>These 2 attrs somehow overlap with pin-frequency-supported,
>which is a bit confusing, I think that pin-frequency-supported
>should carry all supported frequencies. How about to have something
>like:
>        name: pin-frequency-supported
>        type: nest
>	multi-attr: true
>        nested-attributes: pin-frequency-range
>
>and then:
>      name: pin-frequency-range
>      subset-of: dpll
>      attributes:
>        -
>          name: pin-frequency-min
>          type: u32
>        -
>          name: pin-frequency-max
>          type: u32
>          doc: should be put only to specify range when value differs
>	       from pin-frequency-min
>
>That could carry list of frequencies and ranges, in this case multiple
>ones if possibly needed.
>

Sure

>
>
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        enum: pin-state
>>+      -
>>+        name: pin-parent
>>+        type: nest
>>+        multi-attr: true
>>+        nested-attributes: pin
>>+        value: 23
>
>Value 23? What's this?
>You have it specified for some attrs all over the place.
>What is the reason for it?
>

Actually this particular one is not needed (also value: 12 on pin above),
I will remove those.
But the others you are refering to (the ones in nested attribute list),
are required because of cli.py parser issue, maybe Kuba knows a better way =
to
prevent the issue?
Basically, without those values, cli.py brakes on parsing responses, after
every "jump" to nested attribute list it is assigning first attribute there
with value=3D0, thus there is a need to assign a proper value, same as it i=
s on
'main' attribute list.

>
>>+      -
>>+        name: pin-parent-idx
>>+        type: u32
>>+      -
>>+        name: pin-rclk-device
>>+        type: string
>>+      -
>>+        name: pin-dpll-caps
>>+        type: u32
>>+  -
>>+    name: device
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: id
>>+        type: u32
>>+        value: 2
>>+      -
>>+        name: dev-name
>>+        type: string
>>+      -
>>+        name: bus-name
>>+        type: string
>>+      -
>>+        name: mode
>>+        type: u8
>>+        enum: mode
>>+      -
>>+        name: mode-supported
>>+        type: u8
>>+        enum: mode
>>+        multi-attr: true
>>+      -
>>+        name: source-pin-idx
>>+        type: u32
>>+      -
>>+        name: lock-status
>>+        type: u8
>>+        enum: lock-status
>>+      -
>>+        name: temp
>>+        type: s32
>>+      -
>>+        name: clock-id
>>+        type: u64
>>+      -
>>+        name: type
>>+        type: u8
>>+        enum: type
>>+      -
>>+        name: pin
>>+        type: nest
>>+        value: 12
>>+        multi-attr: true
>>+        nested-attributes: pin
>
>This does not belong here.
>

What do you mean?
With device-get 'do' request the list of pins connected to the dpll is
returned, each pin is nested in this attribute.
This is required by parser to work.

>
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+        value: 21
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        enum: pin-state
>>+      -
>>+        name: pin-dpll-caps
>>+        type: u32
>>+        value: 26
>
>All these 3 do not belong here are well.
>

Same as above explanation.

>
>
>>+  -
>>+    name: pin
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: device
>>+        type: nest
>>+        value: 1
>>+        multi-attr: true
>>+        nested-attributes: device
>>+      -
>>+        name: pin-idx
>>+        type: u32
>>+        value: 13
>>+      -
>>+        name: pin-description
>>+        type: string
>>+      -
>>+        name: pin-type
>>+        type: u8
>>+        enum: pin-type
>>+      -
>>+        name: pin-direction
>>+        type: u8
>>+        enum: pin-direction
>>+      -
>>+        name: pin-frequency
>>+        type: u32
>>+      -
>>+        name: pin-frequency-supported
>>+        type: u32
>>+        multi-attr: true
>>+      -
>>+        name: pin-any-frequency-min
>>+        type: u32
>>+      -
>>+        name: pin-any-frequency-max
>>+        type: u32
>>+      -
>>+        name: pin-prio
>>+        type: u32
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        enum: pin-state
>>+      -
>>+        name: pin-parent
>>+        type: nest
>>+        multi-attr: true
>
>Multiple parents? How is that supposed to work?
>

As we have agreed, MUXed pins can have multiple parents.
In our case:
/tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do pin=
-get --json '{"id": 0, "pin-idx":13}'
{'pin': [{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id'=
: 0},
                     {'bus-name': 'pci',
                      'dev-name': '0000:21:00.0_1',
                      'id': 1}],
          'pin-description': '0000:21:00.0',
          'pin-direction': {'doc': 'pin used as a source of a signal',
                            'name': 'source'},
          'pin-idx': 13,
          'pin-parent': [{'pin-parent-idx': 2,
                          'pin-state': {'doc': 'pin disconnected',
                                        'name': 'disconnected'}},
                         {'pin-parent-idx': 3,
                          'pin-state': {'doc': 'pin disconnected',
                                        'name': 'disconnected'}}],
          'pin-rclk-device': '0000:21:00.0',
          'pin-type': {'doc': "ethernet port PHY's recovered clock",
                       'name': 'synce-eth-port'}}]}


>
>>+        nested-attributes: pin-parent
>>+        value: 23
>>+      -
>>+        name: pin-rclk-device
>>+        type: string
>>+        value: 25
>>+      -
>>+        name: pin-dpll-caps
>>+        type: u32
>
>Missing "enum: "
>

It is actually a bitmask, this is why didn't set as enum, with enum type
parser won't parse it.

>
>>+  -
>>+    name: pin-parent
>>+    subset-of: dpll
>>+    attributes:
>>+      -
>>+        name: pin-state
>>+        type: u8
>>+        value: 22
>>+        enum: pin-state
>>+      -
>>+        name: pin-parent-idx
>>+        type: u32
>>+        value: 24
>>+      -
>>+        name: pin-rclk-device
>>+        type: string
>
>Yeah, as I wrote in the other email, this really smells to
>have like a simple string like this. What is it supposed to be?
>

Yes, let's discuss there.

>
>>+
>>+
>>+operations:
>>+  list:
>>+    -
>>+      name: unspec
>>+      doc: unused
>>+
>>+    -
>>+      name: device-get
>>+      doc: |
>>+        Get list of DPLL devices (dump) or attributes of a single dpll
>device
>>+      attribute-set: dpll
>
>Shouldn't this be "device"?
>

It would brake the parser, again I hope Jakub Kicinski could take a look on
this.

>
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pre-doit
>>+        post: dpll-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+        reply:
>>+          attributes:
>>+            - device
>>+
>>+      dump:
>>+        pre: dpll-pre-dumpit
>>+        post: dpll-post-dumpit
>>+        reply:
>>+          attributes:
>>+            - device
>>+
>>+    -
>>+      name: device-set
>>+      doc: Set attributes for a DPLL device
>>+      attribute-set: dpll
>
>"device" here as well?
>

Same as above.

>
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pre-doit
>>+        post: dpll-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+            - mode
>
>Hmm, shouldn't source-pin-index be here as well?

No, there is no set for this.
For manual mode user selects the pin by setting enabled state on the one
he needs to recover signal from.

source-pin-index is read only, returns active source.

>
>>+
>>+    -
>>+      name: pin-get
>>+      doc: |
>>+        Get list of pins and its attributes.
>>+        - dump request without any attributes given - list all the pins
>in the system
>>+        - dump request with target dpll - list all the pins registered
>with a given dpll device
>>+        - do request with target dpll and target pin - single pin
>attributes
>>+      attribute-set: dpll
>
>"pin"?
>

Same case as with dpll/device above.

>
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pin-pre-doit
>>+        post: dpll-pin-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+            - pin-idx
>>+        reply:
>>+          attributes:
>>+            - pin
>>+
>>+      dump:
>>+        pre: dpll-pin-pre-dumpit
>>+        post: dpll-pin-post-dumpit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+        reply:
>>+          attributes:
>>+            - pin
>>+
>>+    -
>>+      name: pin-set
>>+      doc: Set attributes of a target pin
>>+      attribute-set: dpll
>
>"pin"?
>

Same case as with dpll/device above.

>
>>+      flags: [ admin-perm ]
>>+
>>+      do:
>>+        pre: dpll-pin-pre-doit
>>+        post: dpll-pin-post-doit
>>+        request:
>>+          attributes:
>>+            - id
>>+            - bus-name
>>+            - dev-name
>>+            - pin-idx
>>+            - pin-frequency
>>+            - pin-direction
>>+            - pin-prio
>>+            - pin-parent-idx
>>+            - pin-state
>>+
>>+mcast-groups:
>>+  list:
>>+    -
>>+      name: monitor
>>diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
>>new file mode 100644
>>index 000000000000..099d1e30ca7c
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_nl.c
>>@@ -0,0 +1,126 @@
>>+// SPDX-License-Identifier: BSD-3-Clause
>>+/* Do not edit directly, auto-generated from: */
>>+/*	Documentation/netlink/specs/dpll.yaml */
>>+/* YNL-GEN kernel source */
>>+
>>+#include <net/netlink.h>
>>+#include <net/genetlink.h>
>>+
>>+#include "dpll_nl.h"
>>+
>>+#include <linux/dpll.h>
>>+
>>+/* DPLL_CMD_DEVICE_GET - do */
>>+static const struct nla_policy dpll_device_get_nl_policy[DPLL_A_BUS_NAME
>>+ 1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+};
>>+
>>+/* DPLL_CMD_DEVICE_SET - do */
>>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE + 1=
]
>>=3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_MODE] =3D NLA_POLICY_MAX(NLA_U8, 5),
>
>Hmm, any idea why the generator does not put define name
>here instead of "5"?
>

Not really, it probably needs a fix for this.

>
>>+};
>>+
>>+/* DPLL_CMD_PIN_GET - do */
>>+static const struct nla_policy dpll_pin_get_do_nl_policy[DPLL_A_PIN_IDX =
+
>>1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_PIN_IDX] =3D { .type =3D NLA_U32, },
>>+};
>>+
>>+/* DPLL_CMD_PIN_GET - dump */
>>+static const struct nla_policy
>>dpll_pin_get_dump_nl_policy[DPLL_A_BUS_NAME + 1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+};
>>+
>>+/* DPLL_CMD_PIN_SET - do */
>>+static const struct nla_policy
>>dpll_pin_set_nl_policy[DPLL_A_PIN_PARENT_IDX + 1] =3D {
>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>+	[DPLL_A_PIN_IDX] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_PIN_FREQUENCY] =3D { .type =3D NLA_U32, },
>
>4.3GHz would be the limit, isn't it future proof to make this rather u64?
>

Sure, fixed.

>
>>+	[DPLL_A_PIN_DIRECTION] =3D NLA_POLICY_MAX(NLA_U8, 2),
>>+	[DPLL_A_PIN_PRIO] =3D { .type =3D NLA_U32, },
>>+	[DPLL_A_PIN_PARENT_IDX] =3D { .type =3D NLA_U32, },
>
>This is a bit odd. The size is DPLL_A_PIN_PARENT_IDX + 1, yet PIN_STATE
>is last. I found that the order is not according to the enum in the yaml
>operation definition. Perhaps the generator can sort this?
>

Fixed. This related to the order on list of attributes expected on ops
definition.

>
>>+	[DPLL_A_PIN_STATE] =3D NLA_POLICY_MAX(NLA_U8, 2),
>>+};
>>+
>>+/* Ops table for dpll */
>>+static const struct genl_split_ops dpll_nl_ops[6] =3D {
>>+	{
>>+		.cmd		=3D DPLL_CMD_DEVICE_GET,
>>+		.pre_doit	=3D dpll_pre_doit,
>>+		.doit		=3D dpll_nl_device_get_doit,
>>+		.post_doit	=3D dpll_post_doit,
>>+		.policy		=3D dpll_device_get_nl_policy,
>>+		.maxattr	=3D DPLL_A_BUS_NAME,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+	{
>>+		.cmd	=3D DPLL_CMD_DEVICE_GET,
>>+		.start	=3D dpll_pre_dumpit,
>>+		.dumpit	=3D dpll_nl_device_get_dumpit,
>>+		.done	=3D dpll_post_dumpit,
>>+		.flags	=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_DEVICE_SET,
>>+		.pre_doit	=3D dpll_pre_doit,
>>+		.doit		=3D dpll_nl_device_set_doit,
>>+		.post_doit	=3D dpll_post_doit,
>>+		.policy		=3D dpll_device_set_nl_policy,
>>+		.maxattr	=3D DPLL_A_MODE,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_PIN_GET,
>>+		.pre_doit	=3D dpll_pin_pre_doit,
>>+		.doit		=3D dpll_nl_pin_get_doit,
>>+		.post_doit	=3D dpll_pin_post_doit,
>>+		.policy		=3D dpll_pin_get_do_nl_policy,
>>+		.maxattr	=3D DPLL_A_PIN_IDX,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_PIN_GET,
>>+		.start		=3D dpll_pin_pre_dumpit,
>>+		.dumpit		=3D dpll_nl_pin_get_dumpit,
>>+		.done		=3D dpll_pin_post_dumpit,
>>+		.policy		=3D dpll_pin_get_dump_nl_policy,
>>+		.maxattr	=3D DPLL_A_BUS_NAME,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
>>+	},
>>+	{
>>+		.cmd		=3D DPLL_CMD_PIN_SET,
>>+		.pre_doit	=3D dpll_pin_pre_doit,
>>+		.doit		=3D dpll_nl_pin_set_doit,
>>+		.post_doit	=3D dpll_pin_post_doit,
>>+		.policy		=3D dpll_pin_set_nl_policy,
>>+		.maxattr	=3D DPLL_A_PIN_PARENT_IDX,
>>+		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>+	},
>>+};
>>+
>>+static const struct genl_multicast_group dpll_nl_mcgrps[] =3D {
>>+	[DPLL_NLGRP_MONITOR] =3D { "monitor", },
>>+};
>>+
>>+struct genl_family dpll_nl_family __ro_after_init =3D {
>>+	.name		=3D DPLL_FAMILY_NAME,
>>+	.version	=3D DPLL_FAMILY_VERSION,
>>+	.netnsok	=3D true,
>>+	.parallel_ops	=3D true,
>>+	.module		=3D THIS_MODULE,
>>+	.split_ops	=3D dpll_nl_ops,
>>+	.n_split_ops	=3D ARRAY_SIZE(dpll_nl_ops),
>>+	.mcgrps		=3D dpll_nl_mcgrps,
>>+	.n_mcgrps	=3D ARRAY_SIZE(dpll_nl_mcgrps),
>>+};
>>diff --git a/drivers/dpll/dpll_nl.h b/drivers/dpll/dpll_nl.h
>>new file mode 100644
>>index 000000000000..3a354dfb9a31
>>--- /dev/null
>>+++ b/drivers/dpll/dpll_nl.h
>>@@ -0,0 +1,42 @@
>>+/* SPDX-License-Identifier: BSD-3-Clause */
>>+/* Do not edit directly, auto-generated from: */
>>+/*	Documentation/netlink/specs/dpll.yaml */
>>+/* YNL-GEN kernel header */
>>+
>>+#ifndef _LINUX_DPLL_GEN_H
>>+#define _LINUX_DPLL_GEN_H
>>+
>>+#include <net/netlink.h>
>>+#include <net/genetlink.h>
>>+
>>+#include <linux/dpll.h>
>>+
>>+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>>+		  struct genl_info *info);
>>+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff
>*skb,
>>+		      struct genl_info *info);
>>+void
>>+dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>>+	       struct genl_info *info);
>>+void
>>+dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb=
,
>>+		   struct genl_info *info);
>>+int dpll_pre_dumpit(struct netlink_callback *cb);
>>+int dpll_pin_pre_dumpit(struct netlink_callback *cb);
>>+int dpll_post_dumpit(struct netlink_callback *cb);
>>+int dpll_pin_post_dumpit(struct netlink_callback *cb);
>>+
>>+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info)=
;
>>+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct
>netlink_callback *cb);
>>+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)=
;
>>+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info);
>>+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback
>*cb);
>>+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info);
>>+
>>+enum {
>>+	DPLL_NLGRP_MONITOR,
>>+};
>>+
>>+extern struct genl_family dpll_nl_family;
>>+
>>+#endif /* _LINUX_DPLL_GEN_H */
>>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>>new file mode 100644
>>index 000000000000..ece6fe685d08
>>--- /dev/null
>>+++ b/include/uapi/linux/dpll.h
>>@@ -0,0 +1,196 @@
>>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>+/* Do not edit directly, auto-generated from: */
>>+/*	Documentation/netlink/specs/dpll.yaml */
>>+/* YNL-GEN uapi header */
>>+
>>+#ifndef _UAPI_LINUX_DPLL_H
>>+#define _UAPI_LINUX_DPLL_H
>>+
>>+#define DPLL_FAMILY_NAME	"dpll"
>>+#define DPLL_FAMILY_VERSION	1
>>+
>>+#define DPLL_TEMP_DIVIDER	10
>
>Some comment to this define would be nice.
>

I added to the spec, but it is not generated by the regen script.

>
>>+#define DPLL_PIN_FREQ_1_HZ	1
>>+#define DPLL_PIN_FREQ_10_MHZ	10000000
>
>Have this as enum. Spell out "frequency" to be consistent with the
>related attribute name.
>

Sure, fixed.

>
>>+
>>+/**
>>+ * enum dpll_lock_status - Provides information of dpll device lock
>>status,
>>+ *   valid values for DPLL_A_LOCK_STATUS attribute
>>+ * @DPLL_LOCK_STATUS_UNSPEC: unspecified value
>>+ * @DPLL_LOCK_STATUS_UNLOCKED: dpll was not yet locked to any valid (or
>is in
>
>"any valid source" perhaps?
>

Yes, fixed.

>
>>+ *   one of modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>+ * @DPLL_LOCK_STATUS_CALIBRATING: dpll is trying to lock to a valid
>>signal
>>+ * @DPLL_LOCK_STATUS_LOCKED: dpll is locked
>>+ * @DPLL_LOCK_STATUS_HOLDOVER: dpll is in holdover state - lost a valid
>>lock or
>>+ *   was forced by selecting DPLL_MODE_HOLDOVER mode
>>+ */
>>+enum dpll_lock_status {
>>+	DPLL_LOCK_STATUS_UNSPEC,
>>+	DPLL_LOCK_STATUS_UNLOCKED,
>>+	DPLL_LOCK_STATUS_CALIBRATING,
>>+	DPLL_LOCK_STATUS_LOCKED,
>>+	DPLL_LOCK_STATUS_HOLDOVER,
>>+
>>+	__DPLL_LOCK_STATUS_MAX,
>>+	DPLL_LOCK_STATUS_MAX =3D (__DPLL_LOCK_STATUS_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_type - Enumerates types of a pin, valid values for
>>+ *   DPLL_A_PIN_TYPE attribute
>>+ * @DPLL_PIN_TYPE_UNSPEC: unspecified value
>>+ * @DPLL_PIN_TYPE_MUX: aggregates another layer of selectable pins
>>+ * @DPLL_PIN_TYPE_EXT: external source
>>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT: ethernet port PHY's recovered clock
>>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR: device internal oscillator
>>+ * @DPLL_PIN_TYPE_GNSS: GNSS recovered clock
>>+ */
>>+enum dpll_pin_type {
>>+	DPLL_PIN_TYPE_UNSPEC,
>>+	DPLL_PIN_TYPE_MUX,
>>+	DPLL_PIN_TYPE_EXT,
>>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>>+	DPLL_PIN_TYPE_GNSS,
>>+
>>+	__DPLL_PIN_TYPE_MAX,
>>+	DPLL_PIN_TYPE_MAX =3D (__DPLL_PIN_TYPE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_state - available pin modes
>
>For some of the enums, you say for what attribute it serves as a value
>set, for some you don't. Please unify the approach. I think it is
>valuable to say that for every enum.
>

Sure, fixed.

>
>>+ * @DPLL_PIN_STATE_UNSPEC: unspecified value
>>+ * @DPLL_PIN_STATE_CONNECTED: pin connected
>>+ * @DPLL_PIN_STATE_DISCONNECTED: pin disconnected
>>+ */
>>+enum dpll_pin_state {
>>+	DPLL_PIN_STATE_UNSPEC,
>>+	DPLL_PIN_STATE_CONNECTED,
>>+	DPLL_PIN_STATE_DISCONNECTED,
>>+
>>+	__DPLL_PIN_STATE_MAX,
>>+	DPLL_PIN_STATE_MAX =3D (__DPLL_PIN_STATE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_direction - available pin direction
>>+ * @DPLL_PIN_DIRECTION_UNSPEC: unspecified value
>>+ * @DPLL_PIN_DIRECTION_SOURCE: pin used as a source of a signal
>>+ * @DPLL_PIN_DIRECTION_OUTPUT: pin used to output the signal
>>+ */
>>+enum dpll_pin_direction {
>>+	DPLL_PIN_DIRECTION_UNSPEC,
>>+	DPLL_PIN_DIRECTION_SOURCE,
>>+	DPLL_PIN_DIRECTION_OUTPUT,
>>+
>>+	__DPLL_PIN_DIRECTION_MAX,
>>+	DPLL_PIN_DIRECTION_MAX =3D (__DPLL_PIN_DIRECTION_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_mode - working-modes a dpll can support, differentiate if
>>and how
>>+ *   dpll selects one of its sources to syntonize with it
>>+ * @DPLL_MODE_UNSPEC: unspecified value
>>+ * @DPLL_MODE_MANUAL: source can be only selected by sending a request t=
o
>>dpll
>>+ * @DPLL_MODE_AUTOMATIC: highest prio, valid source, auto selected by
>>dpll
>>+ * @DPLL_MODE_HOLDOVER: dpll forced into holdover mode
>>+ * @DPLL_MODE_FREERUN: dpll driven on system clk, no holdover available
>>+ * @DPLL_MODE_NCO: dpll driven by Numerically Controlled Oscillator
>>+ */
>>+enum dpll_mode {
>>+	DPLL_MODE_UNSPEC,
>>+	DPLL_MODE_MANUAL,
>>+	DPLL_MODE_AUTOMATIC,
>>+	DPLL_MODE_HOLDOVER,
>>+	DPLL_MODE_FREERUN,
>>+	DPLL_MODE_NCO,
>>+
>>+	__DPLL_MODE_MAX,
>>+	DPLL_MODE_MAX =3D (__DPLL_MODE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_type - type of dpll, valid values for DPLL_A_TYPE attribute
>>+ * @DPLL_TYPE_UNSPEC: unspecified value
>>+ * @DPLL_TYPE_PPS: dpll produces Pulse-Per-Second signal
>>+ * @DPLL_TYPE_EEC: dpll drives the Ethernet Equipment Clock
>>+ */
>>+enum dpll_type {
>>+	DPLL_TYPE_UNSPEC,
>>+	DPLL_TYPE_PPS,
>>+	DPLL_TYPE_EEC,
>>+
>>+	__DPLL_TYPE_MAX,
>>+	DPLL_TYPE_MAX =3D (__DPLL_TYPE_MAX - 1)
>>+};
>>+
>>+/**
>>+ * enum dpll_event - events of dpll generic netlink family
>>+ * @DPLL_EVENT_UNSPEC: invalid event type
>>+ * @DPLL_EVENT_DEVICE_CREATE: dpll device created
>>+ * @DPLL_EVENT_DEVICE_DELETE: dpll device deleted
>>+ * @DPLL_EVENT_DEVICE_CHANGE: attribute of dpll device or pin changed,
>>reason
>>+ *   is to be found with an attribute type (DPLL_A_*) received with the
>>event
>>+ */
>>+enum dpll_event {
>>+	DPLL_EVENT_UNSPEC,
>>+	DPLL_EVENT_DEVICE_CREATE,
>>+	DPLL_EVENT_DEVICE_DELETE,
>>+	DPLL_EVENT_DEVICE_CHANGE,
>>+};
>>+
>>+/**
>>+ * enum dpll_pin_caps - define capabilities of a pin
>>+ */
>>+enum dpll_pin_caps {
>>+	DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE =3D 1,
>>+	DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE =3D 2,
>>+	DPLL_PIN_CAPS_STATE_CAN_CHANGE =3D 4,
>>+};
>>+
>>+enum dplla {
>>+	DPLL_A_DEVICE =3D 1,
>>+	DPLL_A_ID,
>>+	DPLL_A_DEV_NAME,
>>+	DPLL_A_BUS_NAME,
>>+	DPLL_A_MODE,
>>+	DPLL_A_MODE_SUPPORTED,
>>+	DPLL_A_SOURCE_PIN_IDX,
>>+	DPLL_A_LOCK_STATUS,
>>+	DPLL_A_TEMP,
>>+	DPLL_A_CLOCK_ID,
>>+	DPLL_A_TYPE,
>>+	DPLL_A_PIN,
>>+	DPLL_A_PIN_IDX,
>>+	DPLL_A_PIN_DESCRIPTION,
>
>I commented this name in the other email. This does not describe
>anything. It is a label on a connector, isn't it? Why don't to call it
>"label"?
>

Sure, fixed.

>
>>+	DPLL_A_PIN_TYPE,
>>+	DPLL_A_PIN_DIRECTION,
>>+	DPLL_A_PIN_FREQUENCY,
>>+	DPLL_A_PIN_FREQUENCY_SUPPORTED,
>>+	DPLL_A_PIN_ANY_FREQUENCY_MIN,
>>+	DPLL_A_PIN_ANY_FREQUENCY_MAX,
>
>Drop "any". Not good for anything.
>

Sure, fixed.

>
>>+	DPLL_A_PIN_PRIO,
>>+	DPLL_A_PIN_STATE,
>>+	DPLL_A_PIN_PARENT,
>>+	DPLL_A_PIN_PARENT_IDX,
>>+	DPLL_A_PIN_RCLK_DEVICE,
>>+	DPLL_A_PIN_DPLL_CAPS,
>
>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
>enum name.

Sure, fixed.

>
>>+
>>+	__DPLL_A_MAX,
>>+	DPLL_A_MAX =3D (__DPLL_A_MAX - 1)
>>+};
>>+
>>+enum {
>>+	DPLL_CMD_UNSPEC,
>>+	DPLL_CMD_DEVICE_GET,
>>+	DPLL_CMD_DEVICE_SET,
>>+	DPLL_CMD_PIN_GET,
>>+	DPLL_CMD_PIN_SET,
>>+
>>+	__DPLL_CMD_MAX,
>>+	DPLL_CMD_MAX =3D (__DPLL_CMD_MAX - 1)
>>+};
>>+
>>+#define DPLL_MCGRP_MONITOR	"monitor"
>>+
>>+#endif /* _UAPI_LINUX_DPLL_H */
>>--
>>2.34.1
>>
