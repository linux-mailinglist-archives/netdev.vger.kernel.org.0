Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE026BDDCF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCQAwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCQAwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:52:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EE4AE122;
        Thu, 16 Mar 2023 17:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679014371; x=1710550371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8huGsA27V8/0OUCdUULsE5QS4RWz4x3ECdH5Zt7X7IM=;
  b=W6HY4aRX0x/OuxfKtNYcZvT75XSg+Etofy0NW5URfupCyzBu+8BfMNs9
   AxZKcOHrbv6n9ii5htsXap61qOFhta89+53aosbMCo2+9M1/8IIhhIbFo
   ciaY5hVNEQxVutbrMQk8KmwTCGjXucx8/LrMw/kGg/UVxeZqoS/EVGsSP
   QcqBVpoMEplT9j1saNzhxm+31fkWzwHejKx95vWA7CPlV0FtvBiECKy7b
   hmAY0E0qfmq4JX5vIy5x9k9b7yLU/3yYLr/cG+0IGcIOEm9T5nrZn0y4s
   8nF478xCw7Q2SBKCQ5oSYOxvU8km3lsFSdoCCDs3gpu5eqt4gFNY3479n
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339690473"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="339690473"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 17:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="682507201"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="682507201"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 16 Mar 2023 17:52:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 17:52:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 17:52:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 17:52:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 17:52:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqsQL5eR+UrLPOGTbei+EIlIUO4nrrDiE5mTz3+/pCEYBz6HNP3Pei7Xe9zfYg7U6k8uHbjVzexUnddwtcQ8WfZtuZ65Yj3NzVcA88J6lLvnZiVxOv/X8KCBUW+wXbSbxNt2BIeyavRF6K0zwfdKybrakcY2cWpsJQ0eCgq62flUfyu4EpmNdBdqFpVOmK8EdlebWFOyPNNJ1LMD8k+uumQDYEqG0MuKukrBS2ZfxWUr08kwI/gwWveNzRp6TlVv1qx0DVgwPdR+jvD5sDEDOOZE1Of8B6o5gcawLL54PHaDlhSe2J2Fi2uA2nsjri4kz5DZ3yEuqBVnH1WRfNCTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NanxJwYqRa9lcyfGgjbV4CsM/uBcHzT4gbT9tsogxxA=;
 b=SXGvW1BrYcMDCDmwGNG3VnP+ygl2tjnot1PSbnGznTyX4cNvRlvLJavALrnrcysZtJFlN9uyfz/r9Yb3FNPVYpPfW6TQOzr8AyrAdAIISRQnphCW3zvOBo9QwDwG52qGavWfY6m7HxFm/AFvPDH4cqpcxMya7nq65ggKpCCS171vylZQeIGbBhSivorOvqfJB7qBviUX0AqZ27j96/zn+tmfju1qko3P4D8my+BGqv59+cBzGDAjBUOyaMqWbJAf2VoAzdyTuPHrMkdbCYZlTfH/OXk3xVSwLXof16N+em89Q/kTcrqlDIOJWqqfCk9HeHnSOnUyEFt0MLreHcjYlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH0PR11MB4888.namprd11.prod.outlook.com (2603:10b6:510:32::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 00:52:45 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::95e8:dde5:9afe:9946%9]) with mapi id 15.20.6178.029; Fri, 17 Mar 2023
 00:52:44 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Thread-Index: AQHZVIpWqQ/E3o2ZU0SoOV6Pk96rvK76Xc8AgAML3PCAAAhNAIAAnfVQ
Date:   Fri, 17 Mar 2023 00:52:44 +0000
Message-ID: <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com> <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
In-Reply-To: <ZBMdZkK91GHDrd/4@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH0PR11MB4888:EE_
x-ms-office365-filtering-correlation-id: 1739874d-9a80-45c3-4b4f-08db2681eb61
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mPoEgRuFswqCRxRisyPJzNt9Lm/2Ik7zrv2JC64sczmByMsb/OzvHDxFfYAsRkl/wjcPAWQTLj5X648hVLjxrj6VxKlpLkevigv983GE2GOVWF6XPbI0YWIVzMih3+xbJJ0OUHySec/NRK+aEe8V1JriGuzWCOEiz1iAtiJDHd0ObcSfJv9vQToiRX5UVN+FkIPX1dGoJEpqFM4mFCz+yQNUgr5Ny+TVKyLZcXXJIN/k5bV3P9k6XyBrvZXcTbs+jB4D/vEsps3rkmsvYDmHm3LXw73A+eAGdVP+4+SklHTwsWfhZdIFt8hxXHP1JonHiROFJxtwe+ToBDIFmrJIsBX8MERwgBZebxNIlyFHkYLkH9hvJl2biruY2rz7u3TTIBdxBItz5ttWrrHMmHOtrXuuGvCSXhJ5mrTWHcbBtOATERJ9kk1z0JqHe7NiHm/aC10RuvMLIa1b+RPb651c3fxu/SWkEcmlFHQY4EZA6JPccArZXSy8GYdJ6MGNtqaI4nWzjwluvyuJwvm6MEMFy+TNwOyTzx9qN7NeDSndPw9Lrc7DZQAD93DtCmBEZopCrsuB5p8n6UAbnl6w5TTEsyD01OK2E8tMe6IMhHO3PBPHXuKPOzM/Ix5W6tPlOGmnosXtFckSJJHm734SW94lI0mAuyfH8D7TROidHyftovT4BB7Ojcjvu/Lc/FqzRnqT4r/YmaV8zZRoDH8+PY1qBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199018)(2906002)(5660300002)(7416002)(30864003)(55016003)(38070700005)(33656002)(86362001)(82960400001)(122000001)(38100700002)(83380400001)(7696005)(107886003)(66476007)(66446008)(64756008)(8676002)(66556008)(6916009)(76116006)(66946007)(4326008)(478600001)(316002)(54906003)(8936002)(52536014)(9686003)(71200400001)(186003)(26005)(41300700001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PrNmPnrymEKzLftp7AlU+FbcAdhtSPimK5hcssEjUToeujuSlKBZWYeWJ1L4?=
 =?us-ascii?Q?n7lnIwnEmuStyHDjLaOWMaLK1cYqwzm3AtIsQptm5+xT+lLbEbd8r4wCJxOH?=
 =?us-ascii?Q?lNFOpAGQIrBJIpFaAgE+YbsUtgk/0vp4vvuUAcNAEw2DTD1f2pwLdG9yajq7?=
 =?us-ascii?Q?cX2mc5OinsU+ZO003qkq+Z4qxeqEHlKDsduOQ6tU63eS5gdunAtQTR+VTuLk?=
 =?us-ascii?Q?5MK1rOYaeSx/Lc4Msfmsjo6AB5ESCH2GrafqSZlO39ChJA9q5poz2Thraa+n?=
 =?us-ascii?Q?S9m2+Yx5ihXgIgbDjqCtaJXK4peajpS7uzdgw9AqmiYTBrMc1HBPqDVGwTZc?=
 =?us-ascii?Q?ljRSLWGsHrntd2bRNSmzVdf4R0mTVuhK9Ux39o5Wyt/tN7y/EjpyukcgkUdA?=
 =?us-ascii?Q?lyZYsSU2tNh0sBXiz+6+//qfXnE42fSfCscf6a1ifdhAqIuGZPRCu2QYCWAD?=
 =?us-ascii?Q?t5lj4XUSxeBZqSVgYWTe2JtrXbA+C4qK2zWMPP1NWH76RrqLt99Ie7xzDBs2?=
 =?us-ascii?Q?P1c0pf2L9wGq0zdaGKi+RLTnoThMpFRiUsXUaToEoHRDopk/SITOSMddUkHo?=
 =?us-ascii?Q?l4gchNBFCJ4HO1wBvHUPejte9Eh+SmH8Cwyz1TNbLYQOBTEIp/JDQW1io5TJ?=
 =?us-ascii?Q?6g8S2jYKF0YSt2n+WGLNl5REm0uFR02p+6sU/L3OLgQsxNo8N8EBrWll7+5c?=
 =?us-ascii?Q?4oSQ4Tu7XxcVv/eiCy7HabA76DG1WBubyrNWonbf2igSin1byTngIIAzrm42?=
 =?us-ascii?Q?0S22rrvpTdSgMk2dTmxl0GPCNlRZtvwTW9gz1kzDYBRDUHiRWDt5wxT3xL5B?=
 =?us-ascii?Q?y3DLj0V84tziEQ5bfvaulSg6lErQOoX9RNxrCpEKxubm5pSSsENFKhjmY5Lj?=
 =?us-ascii?Q?VQRSRuwHAKLVZwhKjmwTNyVZBk5WYioj2xkZu4Y8xLZIsCGVy6NrY/FbkRsC?=
 =?us-ascii?Q?vYtoaYRAAyvuaXaiSD3JAFmwjNInB1lMyw7/BaZD2zxjE4GLa4t+eQQBbGKm?=
 =?us-ascii?Q?uiKBFNQUC442g4eHW8b+uyk7dWnkSkoNu2ALGCIGvazkq078OBSjxcOM/wQU?=
 =?us-ascii?Q?5OoVSmwgukp8OQBqRlmWagwEc4ZQ0OqrbcPj6krGaIPMmY74dibh00Alr9rR?=
 =?us-ascii?Q?aMqZcv8XTpugjsym7RraANkoOYSkByyoX3tM8zuAzCrjWtQBhv/Pirt6MvI1?=
 =?us-ascii?Q?0uTrvv9dMCFEJ/XQxjYdHxvrizS4x7DNnrpT/9ogxHettQlUFP4iXvjvdo9x?=
 =?us-ascii?Q?++LIcsWy2k+kyxtMtNPbETfqKo3zPjz4JxqjUdXtGMl5akVBIneuDjXhbQ0u?=
 =?us-ascii?Q?Ln19iVklcxiOzsvBzOVERG4DiNLetTZfTtrM/lWmc6kRVERdOGtO/6tCKgz8?=
 =?us-ascii?Q?0nGTtdKSiusPwuD+Z0wxBpGFE6kPomL0Ad1rxhHmJy/XjnWshvbI5yly80H+?=
 =?us-ascii?Q?u8/Pu/vZWg5+wvMJyOZs0WzcnysxF/lRdUu6MgKC1qNeuacp7cxCYmKjBJQS?=
 =?us-ascii?Q?Mdbdbc0+rXL2DCx5J+SYFvdyAIhIVW+X1yffi4mrPNaTz6hvanp2MeX1XNpp?=
 =?us-ascii?Q?2j2Pa0xTCSwlrnFJQExbxAvphUWsxD06CoZlcHhDP6IYMmRQME5Iq+biN8AN?=
 =?us-ascii?Q?mQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1739874d-9a80-45c3-4b4f-08db2681eb61
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 00:52:44.4559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPbfEQC7fM+HfYoqyjQ3v3R9t2HjVxooLlbgVXce8T0dyKkvYh6SHx8vwIyqrl3/5RxHbbWKP62hP0/v82CD9bEXLOCbcDeFg2RI2gBI97I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4888
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, March 16, 2023 2:45 PM
>

[...]

>>>>+attribute-sets:
>>>>+  -
>>>>+    name: dpll
>>>>+    enum-name: dplla
>>>>+    attributes:
>>>>+      -
>>>>+        name: device
>>>>+        type: nest
>>>>+        value: 1
>>>>+        multi-attr: true
>>>>+        nested-attributes: device
>>>
>>>What is this "device" and what is it good for? Smells like some leftover
>>>and with the nested scheme looks quite odd.
>>>
>>
>>No, it is nested attribute type, used when multiple devices are returned
>>with netlink:
>>
>>- dump of device-get command where all devices are returned, each one nes=
ted
>>inside it:
>>[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id': 0},
>>             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id': 1}]}=
]
>
>Okay, why is it nested here? The is one netlink msg per dpll device
>instance. Is this the real output of you made that up?
>
>Device nest should not be there for DEVICE_GET, does not make sense.
>

This was returned by CLI parser on ice with cmd:
$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
--dump device-get

Please note this relates to 'dump' request , it is rather expected that the=
re
are multiple dplls returned, thus we need a nest attribute for each one.

>
>>
>>- do/dump of pin-get, in case of shared pins, each pin contains number of
>dpll
>>handles it connects with:
>>[{'pin': [{'device': [{'bus-name': 'pci',
>>                       'dev-name': '0000:21:00.0_0',
>>                       'id': 0,
>>                       'pin-prio': 6,
>>                       'pin-state': {'doc': 'pin connected',
>>                                     'name': 'connected'}},
>>                      {'bus-name': 'pci',
>>                       'dev-name': '0000:21:00.0_1',
>>                       'id': 1,
>>                       'pin-prio': 8,
>>                       'pin-state': {'doc': 'pin connected',
>>                                     'name': 'connected'}}],
>
>Okay, here I understand it contains device specific pin items. Makes
>sense!
>

Good.

[...]

>>
>>>
>>>
>>>>+      -
>>>>+        name: pin-prio
>>>>+        type: u32
>>>>+      -
>>>>+        name: pin-state
>>>>+        type: u8
>>>>+        enum: pin-state
>>>>+      -
>>>>+        name: pin-parent
>>>>+        type: nest
>>>>+        multi-attr: true
>>>>+        nested-attributes: pin
>>>>+        value: 23
>>>
>>>Value 23? What's this?
>>>You have it specified for some attrs all over the place.
>>>What is the reason for it?
>>>
>>
>>Actually this particular one is not needed (also value: 12 on pin above),
>>I will remove those.
>>But the others you are refering to (the ones in nested attribute list),
>>are required because of cli.py parser issue, maybe Kuba knows a better wa=
y
>to
>>prevent the issue?
>>Basically, without those values, cli.py brakes on parsing responses, afte=
r
>>every "jump" to nested attribute list it is assigning first attribute
>there
>>with value=3D0, thus there is a need to assign a proper value, same as it=
 is
>on
>>'main' attribute list.
>
>That's weird. Looks like a bug then?
>

Guess we could call it a bug, I haven't investigated the parser that much,
AFAIR, other specs are doing the same way.

>
>>
>>>
>>>>+      -
>>>>+        name: pin-parent-idx
>>>>+        type: u32
>>>>+      -
>>>>+        name: pin-rclk-device
>>>>+        type: string
>>>>+      -
>>>>+        name: pin-dpll-caps
>>>>+        type: u32
>>>>+  -
>>>>+    name: device
>>>>+    subset-of: dpll
>>>>+    attributes:
>>>>+      -
>>>>+        name: id
>>>>+        type: u32
>>>>+        value: 2
>>>>+      -
>>>>+        name: dev-name
>>>>+        type: string
>>>>+      -
>>>>+        name: bus-name
>>>>+        type: string
>>>>+      -
>>>>+        name: mode
>>>>+        type: u8
>>>>+        enum: mode
>>>>+      -
>>>>+        name: mode-supported
>>>>+        type: u8
>>>>+        enum: mode
>>>>+        multi-attr: true
>>>>+      -
>>>>+        name: source-pin-idx
>>>>+        type: u32
>>>>+      -
>>>>+        name: lock-status
>>>>+        type: u8
>>>>+        enum: lock-status
>>>>+      -
>>>>+        name: temp
>>>>+        type: s32
>>>>+      -
>>>>+        name: clock-id
>>>>+        type: u64
>>>>+      -
>>>>+        name: type
>>>>+        type: u8
>>>>+        enum: type
>>>>+      -
>>>>+        name: pin
>>>>+        type: nest
>>>>+        value: 12
>>>>+        multi-attr: true
>>>>+        nested-attributes: pin
>>>
>>>This does not belong here.
>>>
>>
>>What do you mean?
>>With device-get 'do' request the list of pins connected to the dpll is
>>returned, each pin is nested in this attribute.
>
>No, wait a sec. You have 2 object types: device and pin. Each have
>separate netlink CMDs to get and dump individual objects.
>Don't mix those together like this. I thought it became clear in the
>past. :/
>

For pins we must, as pins without a handle to a dpll are pointless.
Same as a dpll without pins, right?

'do' of DEVICE_GET could just dump it's own status, without the list of pin=
s,
but it feels easier for handling it's state on userspace counterpart if tha=
t
command also returns currently registered pins. Don't you think so?

>
>>This is required by parser to work.
>>
>>>
>>>>+      -
>>>>+        name: pin-prio
>>>>+        type: u32
>>>>+        value: 21
>>>>+      -
>>>>+        name: pin-state
>>>>+        type: u8
>>>>+        enum: pin-state
>>>>+      -
>>>>+        name: pin-dpll-caps
>>>>+        type: u32
>>>>+        value: 26
>>>
>>>All these 3 do not belong here are well.
>>>
>>
>>Same as above explanation.
>
>Same as above reply.
>
>
>>
>>>
>>>
>>>>+  -
>>>>+    name: pin
>>>>+    subset-of: dpll
>>>>+    attributes:
>>>>+      -
>>>>+        name: device
>>>>+        type: nest
>>>>+        value: 1
>>>>+        multi-attr: true
>>>>+        nested-attributes: device
>>>>+      -
>>>>+        name: pin-idx
>>>>+        type: u32
>>>>+        value: 13
>>>>+      -
>>>>+        name: pin-description
>>>>+        type: string
>>>>+      -
>>>>+        name: pin-type
>>>>+        type: u8
>>>>+        enum: pin-type
>>>>+      -
>>>>+        name: pin-direction
>>>>+        type: u8
>>>>+        enum: pin-direction
>>>>+      -
>>>>+        name: pin-frequency
>>>>+        type: u32
>>>>+      -
>>>>+        name: pin-frequency-supported
>>>>+        type: u32
>>>>+        multi-attr: true
>>>>+      -
>>>>+        name: pin-any-frequency-min
>>>>+        type: u32
>>>>+      -
>>>>+        name: pin-any-frequency-max
>>>>+        type: u32
>>>>+      -
>>>>+        name: pin-prio
>>>>+        type: u32
>>>>+      -
>>>>+        name: pin-state
>>>>+        type: u8
>>>>+        enum: pin-state
>>>>+      -
>>>>+        name: pin-parent
>>>>+        type: nest
>>>>+        multi-attr: true
>>>
>>>Multiple parents? How is that supposed to work?
>>>
>>
>>As we have agreed, MUXed pins can have multiple parents.
>>In our case:
>>/tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>>pin-get --json '{"id": 0, "pin-idx":13}'
>>{'pin': [{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0',
>>'id': 0},
>>                     {'bus-name': 'pci',
>>                      'dev-name': '0000:21:00.0_1',
>>                      'id': 1}],
>>          'pin-description': '0000:21:00.0',
>>          'pin-direction': {'doc': 'pin used as a source of a signal',
>>                            'name': 'source'},
>>          'pin-idx': 13,
>>          'pin-parent': [{'pin-parent-idx': 2,
>>                          'pin-state': {'doc': 'pin disconnected',
>>                                        'name': 'disconnected'}},
>>                         {'pin-parent-idx': 3,
>>                          'pin-state': {'doc': 'pin disconnected',
>>                                        'name': 'disconnected'}}],
>>          'pin-rclk-device': '0000:21:00.0',
>>          'pin-type': {'doc': "ethernet port PHY's recovered clock",
>>                       'name': 'synce-eth-port'}}]}
>
>Got it, it is still a bit hard to me to follow this. Could you
>perhaps extend the Documentation to describe in more details
>with examples? Would help a lot for slower people like me to understand
>what's what.
>

Actually this is already explained in "MUX-type pins" paragraph of
Documentation/networking/dpll.rst.
Do we want to duplicate this explanation here?


>
>>
>>
>>>
>>>>+        nested-attributes: pin-parent
>>>>+        value: 23
>>>>+      -
>>>>+        name: pin-rclk-device
>>>>+        type: string
>>>>+        value: 25
>>>>+      -
>>>>+        name: pin-dpll-caps
>>>>+        type: u32
>>>
>>>Missing "enum: "
>>>
>>
>>It is actually a bitmask, this is why didn't set as enum, with enum type
>>parser won't parse it.
>
>Ah! Got it. Perhaps a docs note with the enum pointer then?
>

Same as above, explained in Documentation/networking/dpll.rst, do wan't to
duplicate?

>
>>
>>>
>>>>+  -
>>>>+    name: pin-parent
>>>>+    subset-of: dpll
>>>>+    attributes:
>>>>+      -
>>>>+        name: pin-state
>>>>+        type: u8
>>>>+        value: 22
>>>>+        enum: pin-state
>>>>+      -
>>>>+        name: pin-parent-idx
>>>>+        type: u32
>>>>+        value: 24
>>>>+      -
>>>>+        name: pin-rclk-device
>>>>+        type: string
>>>
>>>Yeah, as I wrote in the other email, this really smells to
>>>have like a simple string like this. What is it supposed to be?
>>>
>>
>>Yes, let's discuss there.
>
>Yep.
>
>>
>>>
>>>>+
>>>>+
>>>>+operations:
>>>>+  list:
>>>>+    -
>>>>+      name: unspec
>>>>+      doc: unused
>>>>+
>>>>+    -
>>>>+      name: device-get
>>>>+      doc: |
>>>>+        Get list of DPLL devices (dump) or attributes of a single dpll
>>>device
>>>>+      attribute-set: dpll
>>>
>>>Shouldn't this be "device"?
>>>
>>
>>It would brake the parser, again I hope Jakub Kicinski could take a look
>>on this.
>
>Odd.
>

Yes, seems a bit odd.

>>
>>>
>>>>+      flags: [ admin-perm ]
>>>>+
>>>>+      do:
>>>>+        pre: dpll-pre-doit
>>>>+        post: dpll-post-doit
>>>>+        request:
>>>>+          attributes:
>>>>+            - id
>>>>+            - bus-name
>>>>+            - dev-name
>>>>+        reply:
>>>>+          attributes:
>>>>+            - device
>>>>+
>>>>+      dump:
>>>>+        pre: dpll-pre-dumpit
>>>>+        post: dpll-post-dumpit
>>>>+        reply:
>>>>+          attributes:
>>>>+            - device
>>>>+
>>>>+    -
>>>>+      name: device-set
>>>>+      doc: Set attributes for a DPLL device
>>>>+      attribute-set: dpll
>>>
>>>"device" here as well?
>>>
>>
>>Same as above.
>>
>>>
>>>>+      flags: [ admin-perm ]
>>>>+
>>>>+      do:
>>>>+        pre: dpll-pre-doit
>>>>+        post: dpll-post-doit
>>>>+        request:
>>>>+          attributes:
>>>>+            - id
>>>>+            - bus-name
>>>>+            - dev-name
>>>>+            - mode
>>>
>>>Hmm, shouldn't source-pin-index be here as well?
>>
>>No, there is no set for this.
>>For manual mode user selects the pin by setting enabled state on the one
>>he needs to recover signal from.
>>
>>source-pin-index is read only, returns active source.
>
>Okay, got it. Then why do we have this assymetric approach? Just have
>the enabled state to serve the user to see which one is selected, no?
>This would help to avoid confusion (like mine) and allow not to create
>inconsistencies (like no pin enabled yet driver to return some source
>pin index)
>

This is due to automatic mode were multiple pins are enabled, but actual
selection is done on hardware level with priorities.

[...]

>>>>+
>>>>+/* DPLL_CMD_DEVICE_SET - do */
>>>>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE +
>>>>1]
>>>>=3D {
>>>>+	[DPLL_A_ID] =3D { .type =3D NLA_U32, },
>>>>+	[DPLL_A_BUS_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>>>+	[DPLL_A_DEV_NAME] =3D { .type =3D NLA_NUL_STRING, },
>>>>+	[DPLL_A_MODE] =3D NLA_POLICY_MAX(NLA_U8, 5),
>>>
>>>Hmm, any idea why the generator does not put define name
>>>here instead of "5"?
>>>
>>
>>Not really, it probably needs a fix for this.
>
>Yeah.
>

Well, once we done with review maybe we could also fix those, or ask
Jakub if he could help :)


[...]

>>>
>>>>+	DPLL_A_PIN_PRIO,
>>>>+	DPLL_A_PIN_STATE,
>>>>+	DPLL_A_PIN_PARENT,
>>>>+	DPLL_A_PIN_PARENT_IDX,
>>>>+	DPLL_A_PIN_RCLK_DEVICE,
>>>>+	DPLL_A_PIN_DPLL_CAPS,
>>>
>>>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
>>>enum name.
>>
>>Sure, fixed.
>
>
>Thanks for all your work on this!

Thanks for a great review! :)
