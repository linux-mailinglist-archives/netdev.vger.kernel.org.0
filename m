Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205CC673FD1
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjASRXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjASRXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:23:48 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00067A5F1;
        Thu, 19 Jan 2023 09:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674149027; x=1705685027;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=muo5YlXIDBLwxmNYw2r1GdCImZEJEz26ba7ELZ3T11o=;
  b=cx4P5Tdv6fW9fdI/l4x54DrchhK1flhmz3X+RsINMOyxxnGWxr36r8Hi
   Ez/631IMLLbPzNLqcUab+pwZX07DyOPqls0GuYjgObIXAVwExdFZlsSqW
   2483XCy1ZpdK/FZ9bFQO6HAQXHwjdiateqrD0RX5SEjEw1JYNgPHpO2Ir
   94XXXixPs6NsepqNYBRfK43QQJWrwSqHmx9vOeBZwng2NWD+tZUk2IDkq
   qPEYza+bA+tCWEqyAKbSbLeRNJl0u6xkGgKhFNnsjQZlKizqAtvEZ0ETM
   ahCkIx8iyIhQoFDvodu6/BCqSb3nqduTmnAY1RTvEwPBfEetw8rCl+HnP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323045637"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="323045637"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 09:23:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="749005328"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="749005328"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jan 2023 09:23:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 09:23:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 09:23:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 09:23:45 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 09:23:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPeyUrlD2DMWpXqQgfLvujWgPpF2mpMmD/zD+O5+eU267yxeRP9SdX45n/TvmdvRyv+KjAIiN3ax0Q+amCL1qJQKMWHXBC3zJyX5bUMyh0O7RwzrN5LXlXUrn7juBjljhPbmyFxSNWUcZtuZcx0Z/29JB4ruA9WXlggrIw2ICSt/81UBTSfXSGNx5NAq+/oTVrNBtt866zS4PdVsR+Fg3KaGYG//LyZjtxPRo46G//NA8vflGMbi+00KVjWN404a797z8MJIN/M8vAfgUdRzKiouPPNfwjcZ0cbxUs8b8/x4tMKrbYteE8rUKgspwdFmKE89PJXHGE0WE1gnhnVQKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6ZBARwI9YrysFLLt+BDiVgLH9RbUfL0gV7Dn0BqxDk=;
 b=YLjEYDeUG0z8wCBgqQv7KDqUs4uvfyURrIu8Ztm4tKs8T9On29NQWWB/C7tuOnxmfK8S529IrnXbmVsjYKFdoO926iG5SDz2IeU3PcogyQ+A7HsN2Z2H71xHnrZLJfKe3K/9IzmhgrYgi08T/Sv3amMJ2bxke0WMDA3umAoHNZlhaO7Lw2o1a3GQd6Fxuqyaib2XCn70OPl6G0XgiXYXcBTeAyEj+6S0+GxodHm5llVWcMYV04zWLVWumudAnOuuCKNf3LqLb5UKUPAuFkZP+QAcwlh2QAHCNfL/ERy71NbScPPISK6lJX6fwHgbwdLOHUOS3w/ogaBhlTRwhZP/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 17:23:43 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 17:23:43 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jiri Pirko <jiri@resnulli.us>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZKp4G2r/C0xvjvEaU4m2OVmfgX66kdoDggABqhYCAARyNUA==
Date:   Thu, 19 Jan 2023 17:23:42 +0000
Message-ID: <DM6PR11MB46578D70EAA4986C5A6C6DA19BC49@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
        <DM6PR11MB4657644893C565877A71E1F19BC79@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230118161525.01d6b94f@kernel.org>
In-Reply-To: <20230118161525.01d6b94f@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|IA1PR11MB7320:EE_
x-ms-office365-filtering-correlation-id: f2ed14c0-a1a2-4eba-3459-08dafa41e9f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sfH8H8aABmSnaw2tOjvpcSDfi7y1x1cIw0Cr+QtyBvchh+nX1j4F6gO+mtGKjfa1QNYR/9t1SoGpliNWKILRosqqoawgpX8lxSKa3ZKshRW2ZnC0oT250MlloU8ZQs0j/oyFiULOPHrWrHKzCNIdPJauXJKSIi9C93m/6bJMAqBWeJ7ufK0TIrp3EsQx8KOi2XfZ2D2n1SYE5DKao6rcwhmcRel5YuRuQWvzsIwcPKcPTMXcDbIU232Gwb9drQXYlIuZGnyW6kTkXttTAa0k9WemPXF2JWuDIs3WlAYxj+VV5lPAIHPWzWQIcUg+0zPQvzkNOVpCXQT1LuQEeJvK5kw7mmsutbHOXV/jwbIHh+09/F32nCdLzJNjwEiwy6kXiW9m80/UANXZ6guQSp/07jdX4Rw2NCWPK0q71eytSUA442/hLE1z29HbsItvmgzZSRMZXQW22LEzqIhDSUNqB+l6SM65ki6Pcm/kIvJPllw9zqqAJSF2rpmX8YFyWq+K/7T/6LA4YLLlwDAlea8Y/nmXZ8NwTAxv0qn2tSFKQeSzgDkKQfzPVLiMOF6C/4WxXPahyQGXoJDd/qOY0S62pe5Gy50aihyuGVuNK2q+lBne03kyuBHjpqWmNyrrwW8Rlr+LCG3pW7Ng5yr/oWfuO6FXbMW1eYe+GZof4tqVC8u8NGLVMpIXNNDo/uuCL2kIzbj3xjVVuz/7MPfm0Zdlb46TLpZW8MErebkzRpMo/neZoMrp/TAppUGu8GZe11WmU6KuNcFSEo3LldPReiJT4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(82960400001)(122000001)(38100700002)(33656002)(38070700005)(86362001)(52536014)(8936002)(41300700001)(5660300002)(66446008)(64756008)(316002)(66556008)(66946007)(66476007)(8676002)(76116006)(4326008)(2906002)(55016003)(83380400001)(110136005)(7696005)(478600001)(71200400001)(54906003)(26005)(9686003)(6506007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ULmcCu4FmZ6ELIfN/1m11HOQ1zHb52TVvxOeGA03veTb2iYK2aB5DhAdl7zp?=
 =?us-ascii?Q?6Y27cMg6ttfIBrVTWEQLiqW8nCiOcua3z5lFwyPU9d0CkAUuftfi+sfi/6dr?=
 =?us-ascii?Q?M8bY4YxJUgkpYd+ZPLrrqIgIp3kBba/wNlO9280Q1u3V4QeyQaDGKM+tE0GR?=
 =?us-ascii?Q?cKRxwfWqZXWgjfDtXT/uN8BXNC2UTzB46t8GKI8rz6nR6Xm5vPG7eWWHFTe3?=
 =?us-ascii?Q?ViYA/f3sqyow0OMrRSQR7s4eIm8tExNunMSqVNJLqnFhddmPrZ0Xh8eJNfzb?=
 =?us-ascii?Q?mWIF92qu7GMLD1cld1MnnhjbCosyxrhPq2/HAfj97C+anCnE84jmmttr/BG9?=
 =?us-ascii?Q?fMeQQS7W4G21RD7y3G0+pYQ65hAOrtMejYxxMwPd33D3Qir8vN0vnVBt9ybt?=
 =?us-ascii?Q?F6PgTT88JhqWL0t8c5o9Emg1nIy4rWXDI3B6ouJZDPy3avVMpAdo46XVxYuj?=
 =?us-ascii?Q?0Qp67RpPeR3WE9Tbk9F0TQTi0g6FoBIYHnhcL/9zWdhwpAS3yod5iRigdDYN?=
 =?us-ascii?Q?lOip2pXCGJ4AKxhF37OxQ786m7JvxE1eHo77ub+NWEyDa14HW4KC6+aAnAKW?=
 =?us-ascii?Q?XHKL7sq0hVmfNRGHL1ZZqJQlNaYmmJYsWCWicneTRWPhy1gFK93q+f/kCd1i?=
 =?us-ascii?Q?gV4V5rpyi8n33rBof/xd3QAYd4ctpspecrErHnlxve1lxn8lsEZN37PlfXE6?=
 =?us-ascii?Q?nFiSvLkWHOilk9x31oQfNulClQyi0zFYxWdemo4Q3ksrMxeIzX6/Yx2L/zzl?=
 =?us-ascii?Q?h57Vl7d1NZAWBGjMd0vFEXMzgdoSdnr/zeSbZHJXF0eXRXp+EStFmXIO3L9E?=
 =?us-ascii?Q?vpAF8xz5Q8q4Uu6P7Hl5Dvodl0U36d5TLrJM6uIxiOd94+NZ5ktjADcbzZ9M?=
 =?us-ascii?Q?pfPO0VeP71w/ZbwUXBegBiCHEx8UHVFSTSysKMAjEf5TcNJB5Lry5+l0969q?=
 =?us-ascii?Q?eF4RBqoysnKVwAG2pghJvE7uI3SwyfX+PsJmgfYqrN55NZeBNrh+7p0ss9Zo?=
 =?us-ascii?Q?8FfSC34Ie7H2+WBEjrRPJPoQxwOOw1zl6RDqoo8E0TYN9PqOfiu9JyTGPelL?=
 =?us-ascii?Q?uyA4WrKBDeaYNW5w3jDsg6Bx/QzbxvVmz7w/2ijORsN80xVFzjl5bt8qeK22?=
 =?us-ascii?Q?Ub+zy/Kgo1PXr1q3lDRrAoKtYWN5Xry2unQxJMRqWrWJDsww8axakS05yWgQ?=
 =?us-ascii?Q?mBq64mxQC/BydEpqjlTT4Mab+CshUDRIB8p64lTXS5hjgQJIEaDHIrlRzG8y?=
 =?us-ascii?Q?Z8SDu+A9XMDB7QfReaB/e1UkUgJYtH6lZuZIklx+52QtXsZp/ESpf+xdCiFa?=
 =?us-ascii?Q?XGLE/3n8uQFBII4NZlyL66MjWKYa05ov2c6mGNApQkVkYNUmaqbFEi7U8et4?=
 =?us-ascii?Q?eNwgtShaw3OxYkE84or71HbG+ZepuAwSKuMvPwq+2RzNTa4zvTnETu5wwHAi?=
 =?us-ascii?Q?S1MdWSxtnFdGOGHXSQAJd5VvBwnZNpFXZLvNUHEa9oeT1lPVghs81ZRtZY8o?=
 =?us-ascii?Q?O7Q/enxxY6OJA4srrqEabuyhgek/6WJV8LstqgrCp4m1UP/NjhP6hdZFv/GG?=
 =?us-ascii?Q?YKv7myqq+EFAg0yO740k5l/OLKWQWBauriwZIEdo7WIi0fCkcsbuzlV9E9ff?=
 =?us-ascii?Q?DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ed14c0-a1a2-4eba-3459-08dafa41e9f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 17:23:43.0594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DhymsQgAWoKOJI6DKALQUX7UEmzWhrxNC/hUXaJliTj3UsZVBmNUOhj5OFAXMHOFUIfdlnJkK+LJ48mfyXmkadjUl2/qQGfWb71ch3UoTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, January 19, 2023 1:15 AM
>
>On Wed, 18 Jan 2023 18:07:53 +0000 Kubalewski, Arkadiusz wrote:
>> Based on today's sync meeting, changes we are going to introduce in next
>> version:
>> - reduce the muxed-pin number (artificial multiplication) on list of
>dpll's
>> pins, have a single pin which can be connected with multiple parents,
>> - introduce separated get command for the pin attributes,
>> - allow infinite name length of dpll device,
>> - remove a type embedded in dpll's name and introduce new attribute
>instead,
>> - remove clock class attribute as it is not known by the driver without
>> compliance testing on given SW/HW configuration,
>> - add dpll device "default" quality level attribute, as shall be known
>> by driver for a given hardware.
>
>I converted the patches to use the spec, and pushed them out here:
>
>https://github.com/kuba-moo/ynl/tree/dpll
>
>I kept the conversion step-by-step to help the readers a bit but
>the conversion patches should all be squashed into the main DPLL patch.
>
>The patches are on top of my YNL branch ('main' in that repo).
>I'll post the YNL patches later today, so hopefully very soon they will
>be upstream.
>
>Two major pieces of work which I didn't do for DPLL:
> - docs - I dropped most of the kdocs, the copy-n-pasting was too much;
>   if you want to keep the docs in the uAPI you need to add the
>   appropriate stuff in the spec (look at the definition of
>   pin-signal-type for an example of a fully documented enum)
> - the notifications are quite unorthodox in the current
>   implementation, so I faked the enums :S
>   Usually the notification is the same as the response to a get.
>   IIRC 'notify' and 'event' operation types should be used in the spec.
>
>There is documentation on the specs in
>Documentation/userspace-api/netlink/ which should give some idea of how
>things work. There is also another example of a spec here:
>https://github.com/kuba-
>moo/ynl/blob/psp/Documentation/netlink/specs/psp.yaml
>
>To regenerate the C code after changes to YAML:
>
>  ./tools/net/ynl/ynl-regen.sh
>
>if the Python script doing the generation dies and eats the files -
>bring them back with:
>
>  git checkout drivers/dpll/dpll_nl.c drivers/dpll/dpll_nl.h \
>               include/uapi/linux/dpll.h
>
>There is a "universal CLI" script in:
>
>  ./tools/net/ynl/samples/cli.py
>
>which should be able to take in JSON requests and output JSON responses.
>I'm improvising, because I don't have any implementation to try it
>out, but something like:
>
>  ./tools/net/ynl/samples/cli.py \
>       --spec Documentation/netlink/specs/dpll.yaml \
>       --do device-get --json '{"id": 1}'
>
>should pretty print the info about device with id 1. Actually - it
>probably won't because I didn't fill in all the attrs in the pin nest.
>But with a bit more work on the spec it should work.
>
>Would you be able to finish this conversion. Just LMK if you have any
>problems, the edges are definitely very sharp at this point.

Sure, I will try. Thanks for the manual!

BR, Arkadiusz
